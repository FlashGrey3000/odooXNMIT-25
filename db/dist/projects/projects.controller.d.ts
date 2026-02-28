import { ProjectsService } from './projects.service';
import { CreateProjectDto, UpdateProjectDto, AddMemberDto } from './dto/project.dto';
import { User } from '@prisma/client';
export declare class ProjectsController {
    private projectsService;
    constructor(projectsService: ProjectsService);
    create(dto: CreateProjectDto, user: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    findOne(projectId: number, user: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    update(projectId: number, dto: UpdateProjectDto, user: User): Promise<{
        name: string;
        createdAt: Date;
        description: string | null;
        projectId: number;
        createdBy: number;
    }>;
    addMember(projectId: number, dto: AddMemberDto, user: User): Promise<{
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    }>;
    getProjectTasks(projectId: number, user: User): Promise<any>;
    getMembers(projectId: number, user: User): Promise<({
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
    removeMember(projectId: number, userId: number, user: User): Promise<{
        userId: number;
        projectId: number;
        role: import(".prisma/client").$Enums.Role;
    }>;
}
