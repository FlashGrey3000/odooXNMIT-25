import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/user.dto';
import { User } from '@prisma/client';
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    create(dto: CreateUserDto): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
    findById(userId: number, currentUser: User): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
    getMyProjects(userId: number): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }[]>;
    getUserProjects(targetUserId: number, currentUser: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }[]>;
    getUserTasks(targetUserId: number, currentUser: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }[]>;
    sanitize(user: User): {
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    };
    searchByEmail(email: string): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
}
