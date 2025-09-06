"use client";

import { useEffect, useState } from "react";
import Link from "next/link";

const API_BASE = "http://10.57.140.70:8000";

interface Project {
  project_id: number;
  name: string;
  description?: string;
}

export default function ProjectsPage() {
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState<string | null>(null);
  const [token, setToken] = useState<string | null>(null);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [newName, setNewName] = useState("");
  const [newDesc, setNewDesc] = useState("");

  useEffect(() => {
    console.log(typeof window !== "undefined")
    if (typeof window !== "undefined") {
      setUserId(localStorage.getItem("user_id"));
      setToken(localStorage.getItem("token"));
      console.log(userId, token)
    }
  }, []);

  async function createProject(name: string, description: string) {
    if (!userId && !token) {
      console.log("De naaddaaa")
      return null;
    }

    try {
      const res = await fetch(`${API_BASE}/projects/?user_id=${userId}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ name, description }),
      });

      if (!res.ok) {
        const errorData = await res.json();
        console.error("Error creating project:", errorData);
        alert(`Error: ${errorData.detail || "Failed to create project"}`);
        return null;
      }

      const data = await res.json();
      return data;
    } catch (err) {
      console.error("Network error:", err);
      alert("Could not connect to the server.");
      return null;
    }
  }

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault();
    const project = await createProject(newName, newDesc);
    if (project) {
      setProjects((prev) => [...prev, project]);
      setNewName("");
      setNewDesc("");
      setIsModalOpen(false);
    }
  }

  useEffect(() => {
    if (!userId || !token) {
      setLoading(false);
      return;
    }

    async function fetchProjects() {
      try {
        const res = await fetch(`${API_BASE}/users/${userId}/projects/`, {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        });

        if (!res.ok) throw new Error("Failed to fetch projects");

        const data = await res.json();
        setProjects(data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    }

    fetchProjects();
  }, [userId, token]);

  return (
    <div className="p-6 max-w-6xl mx-auto">
      {/* Header */}
      <header className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8 gap-4">
        <div>
          <h1 className="text-3xl font-extrabold text-gray-900">Projects</h1>
          <p className="text-gray-600 mt-1">
            Manage and explore all your ongoing projects in one place.
          </p>
        </div>
        <button
          onClick={() => setIsModalOpen(true)}
          className="inline-flex items-center justify-center bg-blue-600 text-white px-5 py-2.5 rounded-xl shadow hover:bg-blue-700 transition font-medium"
        >
          + New Project
        </button>
      </header>

      {/* Content */}
      {loading ? (
        <div className="flex justify-center items-center h-40">
          <p className="text-gray-500 animate-pulse">Loading projects...</p>
        </div>
      ) : projects.length === 0 ? (
        <div className="text-center py-16 border-2 border-dashed rounded-2xl">
          <h2 className="text-lg font-medium text-gray-700 mb-2">
            No projects found
          </h2>
          <p className="text-gray-500 mb-4">
            Start by creating your very first project.
          </p>
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
          >
            Create Project
          </button>
        </div>
      ) : (
        <ul className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {projects.map((project) => (
            <li
              key={project.project_id}
              className="group border rounded-2xl p-6 bg-white hover:shadow-lg transition cursor-pointer"
            >
              <Link href={`/projects/${project.project_id}`} className="block">
                <h2 className="text-xl font-semibold text-gray-900 group-hover:text-blue-600 transition">
                  {project.name}
                </h2>
                {project.description && (
                  <p className="text-gray-600 mt-2 line-clamp-3">
                    {project.description}
                  </p>
                )}
                <div className="mt-4 text-sm text-blue-600 font-medium flex items-center gap-1">
                  View Details →
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
            <h2 className="text-xl font-bold mb-4 text-gray-800">Create New Project</h2>
            <form onSubmit={handleCreate} className="space-y-4">
              <div>
                <label className="block text-gray-700 mb-1">Project Name</label>
                <input
                  type="text"
                  value={newName}
                  onChange={(e) => setNewName(e.target.value)}
                  required
                  className="w-full border rounded-lg p-2 focus:ring focus:ring-blue-300 focus:outline-none text-black"
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-1">
                  Project Description
                </label>
                <textarea
                  value={newDesc}
                  onChange={(e) => setNewDesc(e.target.value)}
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
