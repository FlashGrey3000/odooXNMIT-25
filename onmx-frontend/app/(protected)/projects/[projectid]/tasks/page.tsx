"use client";

import { useParams } from 'next/navigation';
import Link from 'next/link';

export default function TaskListPage() {
  const params = useParams();
  const { projectId } = params;

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold">Tasks for Project: {projectId}</h1>
      <ul className="mt-4 space-y-2">
        {/* Example tasks */}
        <li>
          <Link href={`/projects/${projectId}/tasks/1`} className="text-blue-500">
            Task 1
          </Link>
        </li>
        <li>
          <Link href={`/projects/${projectId}/tasks/2`} className="text-blue-500">
            Task 2
          </Link>
        </li>
      </ul>
      <Link
        href={`/projects/${projectId}/tasks/new`}
        className="mt-4 inline-block text-white bg-blue-500 px-4 py-2 rounded"
      >
        Create New Task
      </Link>
    </div>
  );
}
