import { PrismaService } from '../prisma/prisma.service';
import { CreateProjectDto, UpdateProjectDto, AddMemberDto } from './dto/project.dto';
import { User } from '@prisma/client';
export declare class ProjectsService {
    private prisma;
    constructor(prisma: PrismaService);
    create(dto: CreateProjectDto, userId: number): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    findById(projectId: number, currentUser: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    update(projectId: number, dto: UpdateProjectDto, currentUser: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    addMember(projectId: number, dto: AddMemberDto, currentUser: User): Promise<{
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    }>;
    getMembership(projectId: number, userId: number): Promise<{
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    }>;
    getMembers(projectId: number, currentUser: User): Promise<({
        user: {
            userId: number;
            email: string;
            name: string;
        };
    } & {
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    })[]>;
    removeMember(projectId: number, targetUserId: number, currentUser: User): Promise<{
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    }>;
}
