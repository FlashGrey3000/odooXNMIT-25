import { UsersService } from './users.service';
import { CreateUserDto } from './dto/user.dto';
import { User } from '@prisma/client';
export declare class UsersController {
    private usersService;
    constructor(usersService: UsersService);
    signup(dto: CreateUserDto): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
    getMe(user: User): {
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    };
    search(email: string): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
    getUser(userId: number, currentUser: User): Promise<{
        userId: number;
        email: string;
        name: string;
        createdAt: Date;
    }>;
    getUserProjects(userId: number, currentUser: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }[]>;
    getUserTasks(userId: number, currentUser: User): Promise<{
        createdAt: Date;
        description: string | null;
        title: string;
        projectId: number;
        taskId: number;
        assigneeId: number | null;
        status: import(".prisma/client").$Enums.TaskStatus;
        dueDate: Date | null;
    }[]>;
}
