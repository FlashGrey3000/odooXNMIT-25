"use client"

import { useParams } from 'next/navigation';

export default function NewTaskPage() {
  const params = useParams();
  const { projectId } = params;
  
  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold">Create a new task for Project: {projectId}</h1>
      <form className="mt-4 space-y-4">
        <div>
          <label className="block mb-1">Task Name</label>
          <input className="w-full border px-3 py-2 rounded" placeholder="Enter task name" />
        </div>
        <div>
          <label className="block mb-1">Description</label>
          <textarea className="w-full border px-3 py-2 rounded" placeholder="Enter description" />
        </div>
        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">
          Create Task
        </button>
      </form>
    </div>
  );
}
