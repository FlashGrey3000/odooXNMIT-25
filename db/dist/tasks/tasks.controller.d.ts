import { TasksService } from './tasks.service';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';
import { User } from '@prisma/client';
export declare class TasksController {
    private tasksService;
    constructor(tasksService: TasksService);
    create(dto: CreateTaskDto, user: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }>;
    update(taskId: number, dto: UpdateTaskDto, user: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }>;
    delete(taskId: number, user: User): Promise<{
        detail: string;
    }>;
}
