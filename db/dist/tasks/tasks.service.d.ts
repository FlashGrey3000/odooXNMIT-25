import { PrismaService } from '../prisma/prisma.service';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';
import { User } from '@prisma/client';
export declare class TasksService {
    private prisma;
    constructor(prisma: PrismaService);
    create(dto: CreateTaskDto, currentUser: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }>;
    update(taskId: number, dto: UpdateTaskDto, currentUser: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }>;
    delete(taskId: number, currentUser: User): Promise<{
        detail: string;
    }>;
}
