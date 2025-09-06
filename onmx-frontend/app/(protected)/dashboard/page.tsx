"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import {
  PieChart,
  Pie,
  Cell,
  ResponsiveContainer,
  Tooltip,
  Legend,
} from "recharts";

import { useEffect } from 'react';

export default function DashboardPage() {
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      router.push('/login');
    }
  }, [router]);

  // Synthetic Data
  const projects = [
    { project_id: 1, name: "Project Alpha", description: "AI system for fraud detection" },
    { project_id: 2, name: "Project Beta", description: "Next-gen ecommerce platform" },
    { project_id: 3, name: "Project Gamma", description: "Mobile app for productivity" },
  ];

  const tasks = [
  { 
    task_id: 1, 
    title: "Design Landing Page", 
    description: "Create responsive UI mockups and wireframes for the landing page", 
    status: "todo", 
    assigned_to: "Alice" 
  },
  { 
    task_id: 2, 
    title: "Setup Database", 
    description: "Initialize PostgreSQL, create schemas, and setup migrations", 
    status: "in-progress", 
    assigned_to: "Bob" 
  },
  { 
    task_id: 3, 
    title: "API Authentication", 
    description: "Implement JWT-based login, signup, and token verification endpoints", 
    status: "done", 
    assigned_to: "Charlie" 
  },
  { 
    task_id: 4, 
    title: "User Dashboard", 
    description: "Build dashboard layout with project summaries, task stats, and notifications", 
    status: "todo", 
    assigned_to: "Alice" 
  },
  { 
    task_id: 5, 
    title: "Notifications System", 
    description: "Create real-time notification system for task updates and deadlines", 
    status: "in-progress", 
    assigned_to: "Bob" 
  },
];


  const stats = {
    totalProjects: projects.length,
    todo: tasks.filter((t) => t.status === "todo").length,
    inProgress: tasks.filter((t) => t.status === "in-progress").length,
    done: tasks.filter((t) => t.status === "done").length,
  };

  const chartData = [
    { name: "To-Do", value: stats.todo },
    { name: "In-Progress", value: stats.inProgress },
    { name: "Done", value: stats.done },
  ];

  const COLORS = ["#9CA3AF", "#FBBF24", "#34D399"];

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-8">
      {/* Header */}
      <header className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-extrabold text-gray-900">Dashboard</h1>
          <p className="text-gray-600 mt-1">
            Overview of your projects and tasks.
          </p>
        </div>
        <div className="flex gap-3">
          <Link
            href="/projects"
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
          >
            View Projects
          </Link>
          <Link
            href="/tasks"
            className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition"
          >
            View Tasks
          </Link>
        </div>
      </header>

      {/* Stats */}
      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="p-6 rounded-xl bg-white shadow text-center">
          <h2 className="text-2xl font-bold text-gray-900">{stats.totalProjects}</h2>
          <p className="text-gray-600">Total Projects</p>
        </div>
        <div className="p-6 rounded-xl bg-white shadow text-center">
          <h2 className="text-2xl font-bold text-gray-900">{stats.todo}</h2>
          <p className="text-gray-600">Tasks To-Do</p>
        </div>
        <div className="p-6 rounded-xl bg-white shadow text-center">
          <h2 className="text-2xl font-bold text-gray-900">{stats.inProgress}</h2>
          <p className="text-gray-600">In-Progress Tasks</p>
        </div>
        <div className="p-6 rounded-xl bg-white shadow text-center">
          <h2 className="text-2xl font-bold text-gray-900">{stats.done}</h2>
          <p className="text-gray-600">Completed Tasks</p>
        </div>
      </section>

      {/* Content Grid */}
      <section className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Recent Projects */}
        <div className="lg:col-span-2 space-y-4">
          <h2 className="text-xl font-bold text-gray-800">Recent Projects</h2>
          <ul className="space-y-4">
            {projects.map((project) => (
              <li
                key={project.project_id}
                className="p-4 bg-white rounded-lg shadow hover:shadow-md transition"
              >
                <Link href={`/projects/${project.project_id}`} className="block">
                  <h3 className="text-lg font-semibold text-gray-900">
                    {project.name}
                  </h3>
                  <p className="text-gray-600 mt-1">{project.description}</p>
                </Link>
              </li>
            ))}
          </ul>
        </div>

        {/* Task Chart */}
        <div className="p-6 bg-white rounded-lg shadow">
          <h2 className="text-xl font-bold text-gray-800 mb-4">Task Status</h2>
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={chartData}
                dataKey="value"
                nameKey="name"
                cx="50%"
                cy="50%"
                outerRadius={80}
                label
              >
                {chartData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </section>

      {/* My Tasks */}
      <section>
        <h2 className="text-xl font-bold text-gray-800 mb-4">My Tasks</h2>
        <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {tasks.slice(0, 6).map((task) => (
            <li
              key={task.task_id}
              className="p-4 bg-white rounded-lg shadow hover:shadow-md transition"
            >
              <Link href={`/tasks/${task.task_id}`} className="block">
                <h3 className="text-lg font-semibold text-gray-900">{task.title}</h3>
                <p className="text-gray-600 text-sm line-clamp-2 mt-1">
                  {task.description}
                </p>
                <div className="mt-2 text-sm text-gray-500">
                  Assigned to:{" "}
                  <span className="font-medium">{task.assigned_to}</span>
                </div>
              </Link>
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}
