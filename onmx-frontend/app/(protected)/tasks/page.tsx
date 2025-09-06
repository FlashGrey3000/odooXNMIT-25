"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

const API_BASE = "http://10.57.140.70:8000";

interface Task {
  task_id: number;
  title: string;
  description: string;
  status: "todo" | "in-progress" | "done";
  assigned_to: string;
  due_date: string;
}

export default function TasksPage() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);

  // Form state
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [assigneeId, setAssigneeId] = useState("");
  const [status, setStatus] = useState<"todo" | "in-progress" | "done">("todo");
  const [dueDate, setDueDate] = useState("");

  const [token, setToken] = useState<string | null>(null);

  useEffect(() => {
    if (typeof window !== "undefined") {
      setToken(localStorage.getItem("token"));
    }

    // For now, mock tasks. Replace with API call later
    setTasks([
      {
        task_id: 1,
        title: "Design Landing Page",
        description: "Create responsive UI mockups for landing page",
        status: "in-progress",
        assigned_to: "Alice",
        due_date: "2025-09-10",
      },
      {
        task_id: 2,
        title: "Setup Database",
        description: "Initialize PostgreSQL and migrations",
        status: "todo",
        assigned_to: "Bob",
        due_date: "2025-09-12",
      },
      {
        task_id: 3,
        title: "Finish the References Table",
        description: "Create all the foreign keys and update the mongoDB databases",
        status: "in-progress",
        assigned_to: "Gokul",
        due_date: "2025-09-30",
      }
    ]);
  }, []);

  const getStatusColor = (status: Task["status"]) => {
    switch (status) {
      case "todo":
        return "bg-gray-200 text-gray-800";
      case "in-progress":
        return "bg-yellow-200 text-yellow-800";
      case "done":
        return "bg-green-200 text-green-800";
    }
  };

  async function createTask() {
    if (!token) {
        alert("No auth token found");
        return;
    }

    // Validate required fields
    if (!title || !assigneeId || !status || !dueDate) {
        alert("Please fill in all required fields.");
        return;
    }

    try {
        const res = await fetch(`${API_BASE}/tasks/`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
            title,
            description,
            assignee_id: Number(assigneeId), // ✅ ensure it's a number
            status: status, // ✅ must match backend enum ("To-Do", "In-Progress", "Done"?)
            due_date: new Date(dueDate).toISOString(), // ✅ send ISO format
        }),
        });

        if (!res.ok) {
        const error = await res.json();
        console.error("Error response:", error);
        alert(`Error: ${error.detail || "Failed to create task"}`);
        return;
        }

        const newTask = await res.json();
        setTasks((prev) => [...prev, newTask]);

        // Reset
        setTitle("");
        setDescription("");
        setAssigneeId("");
        setStatus("todo");
        setDueDate("");
        setIsModalOpen(false);
    } catch (err) {
        console.error("Network error:", err);
        alert("Could not connect to server");
    }
    }


  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createTask();
  };

  return (
    <div className="p-6 max-w-6xl mx-auto">
      {/* Header */}
      <header className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8 gap-4">
        <div>
          <h1 className="text-3xl font-extrabold text-gray-900">Tasks</h1>
          <p className="text-gray-600 mt-1">
            Manage and track tasks across your projects.
          </p>
        </div>
        <button
          onClick={() => setIsModalOpen(true)}
          className="inline-flex items-center justify-center bg-blue-600 text-white px-5 py-2.5 rounded-xl shadow hover:bg-blue-700 transition font-medium"
        >
          + New Task
        </button>
      </header>

      {/* Task List */}
      {tasks.length === 0 ? (
        <div className="text-center py-16 border-2 border-dashed rounded-2xl">
          <h2 className="text-lg font-medium text-gray-700 mb-2">
            No tasks available
          </h2>
          <p className="text-gray-500 mb-4">
            Start by creating a new task for your team.
          </p>
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
          >
            Create Task
          </button>
        </div>
      ) : (
        <ul className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {tasks.map((task) => (
            <li
              key={task.task_id}
              className="group border rounded-2xl p-6 bg-white hover:shadow-lg transition cursor-pointer"
            >
              <Link href={`/tasks/${task.task_id}`} className="block">
                <h2 className="text-lg font-semibold text-gray-900 group-hover:text-blue-600 transition">
                  {task.title}
                </h2>
                <p className="text-gray-600 mt-1 line-clamp-2">
                  {task.description}
                </p>

                <div className="mt-4 flex flex-wrap items-center gap-2 text-sm">
                  <span
                    className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(
                      task.status
                    )}`}
                  >
                    {task.status}
                  </span>
                  <span className="text-gray-500">
                    Assigned to:{" "}
                    <span className="font-medium text-gray-800">
                      {task.assigned_to}
                    </span>
                  </span>
                </div>

                <div className="mt-2 text-sm text-gray-500">
                  Due:{" "}
                  <span className="font-medium text-gray-700">
                    {new Date(task.due_date).toLocaleDateString()}
                  </span>
                </div>
              </Link>
            </li>
          ))}
        </ul>
      )}

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl shadow-lg w-full max-w-md p-6">
            <h2 className="text-xl font-bold mb-4 text-gray-800">
              Create New Task
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-gray-700 mb-1">Title</label>
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  required
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-1">Description</label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-1">Assignee ID</label>
                <input
                  type="number"
                  value={assigneeId}
                  onChange={(e) => setAssigneeId(e.target.value)}
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-1">Status</label>
                <select
                  value={status}
                  onChange={(e) =>
                    setStatus(e.target.value as "todo" | "in-progress" | "done")
                  }
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                >
                  <option value="todo">To-Do</option>
                  <option value="in-progress">In Progress</option>
                  <option value="done">Done</option>
                </select>
              </div>
              <div>
                <label className="block text-gray-700 mb-1">Due Date</label>
                <input
                  type="date"
                  value={dueDate}
                  onChange={(e) => setDueDate(e.target.value)}
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                />
              </div>
              <div className="flex justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 rounded-lg border bg-red-300 hover:bg-red-500"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
                >
                  Create
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
