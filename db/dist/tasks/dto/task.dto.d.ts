export declare class CreateTaskDto {
    projectId: number;
    title: string;
    description?: string;
    assigneeId?: number;
    status?: 'TODO' | 'IN_PROGRESS' | 'DONE';
    dueDate?: string;
}
export declare class UpdateTaskDto {
    title?: string;
    description?: string;
    assigneeId?: number;
    status?: 'TODO' | 'IN_PROGRESS' | 'DONE';
    dueDate?: string;
}
