"use client";

import { useParams } from 'next/navigation';

export default function TaskDetailPage() {
  const params = useParams();
  const { projectId, taskId } = params;

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold">Task {taskId} for Project {projectId}</h1>
      <p>Task details and description will be shown here.</p>
    </div>
  );
}
