'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';

const API_BASE = "http://10.57.140.70:8000";

interface Project {
  id: string;
  name: string;
  description?: string;
  members?: User[];
}

interface User {
  id: string;
  username: string;
}

interface Task {
  id: string;
  title: string;
  description?: string;
  assignee?: User;
}

export default function ProjectDetailPage() {
  const params = useParams();
  const { projectId } = params;

  const [project, setProject] = useState<Project | null>(null);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);

  // form states
  const [taskTitle, setTaskTitle] = useState('');
  const [taskDescription, setTaskDescription] = useState('');
  const [assigneeId, setAssigneeId] = useState('');

  const token = localStorage.getItem('access_token');

  // fetch project + tasks
  useEffect(() => {
    async function fetchData() {
      try {
        const [projRes, tasksRes] = await Promise.all([
          fetch(`${API_BASE}/projects/${projectId}`, {
            headers: { Authorization: `Bearer ${token}` },
          }),
          fetch(`${API_BASE}/projects/${projectId}/tasks/`, {
            headers: { Authorization: `Bearer ${token}` },
          }),
        ]);

        if (!projRes.ok) throw new Error('Failed to load project');
        if (!tasksRes.ok) throw new Error('Failed to load tasks');

        const projData = await projRes.json();
        const tasksData = await tasksRes.json();

        setProject(projData);
        setTasks(tasksData);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, [projectId, token]);

  async function handleCreateTask(e: React.FormEvent) {
    e.preventDefault();
    try {
      const res = await fetch(`${API_BASE}/tasks/`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          title: taskTitle,
          description: taskDescription,
          project_id: projectId,
          assignee_id: assigneeId || null,
        }),
      });

      if (!res.ok) throw new Error('Failed to create task');
      const newTask = await res.json();

      setTasks((prev) => [...prev, newTask]);
      setTaskTitle('');
      setTaskDescription('');
      setAssigneeId('');
    } catch (err) {
      console.error(err);
    }
  }

  if (loading) return <p className="p-4">Loading project...</p>;
  if (!project) return <p className="p-4">Project not found</p>;

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-6">
      {/* Project Details */}
      <section>
        <h1 className="text-3xl font-bold">{project.name}</h1>
        <p className="text-gray-600">{project.description}</p>
      </section>

      {/* Members */}
      <section>
        <h2 className="text-2xl font-semibold mb-2">Members</h2>
        {project.members && project.members.length > 0 ? (
          <ul className="list-disc pl-6">
            {project.members.map((u) => (
              <li key={u.id}>{u.username}</li>
            ))}
          </ul>
        ) : (
          <p>No members yet.</p>
        )}
        {/* Future: Add "Assign User" form here */}
      </section>

      {/* Tasks */}
      <section>
        <h2 className="text-2xl font-semibold mb-2">Tasks</h2>
        {tasks.length === 0 ? (
          <p>No tasks yet.</p>
        ) : (
          <ul className="space-y-2">
            {tasks.map((task) => (
              <li
                key={task.id}
                className="border p-3 rounded hover:shadow cursor-pointer"
              >
                <h3 className="font-semibold">{task.title}</h3>
                {task.description && (
                  <p className="text-gray-600">{task.description}</p>
                )}
                {task.assignee && (
                  <p className="text-sm text-gray-500">
                    Assigned to: {task.assignee.username}
                  </p>
                )}
              </li>
            ))}
          </ul>
        )}
      </section>

      {/* Create Task */}
      <section>
        <h2 className="text-2xl font-semibold mb-2">Create Task</h2>
        <form onSubmit={handleCreateTask} className="space-y-4">
          <div>
            <label className="block mb-1">Title</label>
            <input
              value={taskTitle}
              onChange={(e) => setTaskTitle(e.target.value)}
              className="w-full border px-3 py-2 rounded"
              required
            />
          </div>
          <div>
            <label className="block mb-1">Description</label>
            <textarea
              value={taskDescription}
              onChange={(e) => setTaskDescription(e.target.value)}
              className="w-full border px-3 py-2 rounded"
            />
          </div>
          <div>
            <label className="block mb-1">Assign to User (ID)</label>
            <input
              value={assigneeId}
              onChange={(e) => setAssigneeId(e.target.value)}
              className="w-full border px-3 py-2 rounded"
              placeholder="Enter user ID"
            />
          </div>
          <button
            type="submit"
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            Create Task
          </button>
        </form>
      </section>
    </div>
  );
}
