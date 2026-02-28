"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProjectsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ProjectsService = class ProjectsService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(dto, userId) {
        const project = await this.prisma.project.create({
            data: {
                name: dto.name,
                description: dto.description,
                createdBy: userId,
                members: {
                    create: { userId, role: 'owner' },
                },
            },
        });
        return project;
    }
    async findById(projectId, currentUser) {
        const project = await this.prisma.project.findUnique({ where: { projectId } });
        if (!project)
            throw new common_1.NotFoundException('Project not found');
        const membership = await this.getMembership(projectId, currentUser.userId);
        if (!membership)
            throw new common_1.ForbiddenException('Not authorized to view this project');
        return project;
    }
    async update(projectId, dto, currentUser) {
        const membership = await this.getMembership(projectId, currentUser.userId);
        if (!membership || !['owner', 'admin'].includes(membership.role)) {
            throw new common_1.ForbiddenException('Not authorized to update this project');
        }
        const project = await this.prisma.project.findUnique({ where: { projectId } });
        if (!project)
            throw new common_1.NotFoundException('Project not found');
        return this.prisma.project.update({
            where: { projectId },
            data: {
                ...(dto.name && { name: dto.name }),
                ...(dto.description && { description: dto.description }),
            },
        });
    }
    async addMember(projectId, dto, currentUser) {
        const membership = await this.getMembership(projectId, currentUser.userId);
        if (!membership || !['owner', 'admin'].includes(membership.role)) {
            throw new common_1.ForbiddenException('Not authorized to add members');
        }
        const existing = await this.getMembership(projectId, dto.userId);
        if (existing)
            throw new common_1.BadRequestException('User already a member of this project');
        return this.prisma.projectMember.create({
            data: { projectId, userId: dto.userId, role: dto.role ?? 'member' },
        });
    }
    async getMembership(projectId, userId) {
        return this.prisma.projectMember.findUnique({
            where: { projectId_userId: { projectId, userId } },
        });
    }
    async getMembers(projectId, currentUser) {
        const membership = await this.getMembership(projectId, currentUser.userId);
        if (!membership)
            throw new common_1.ForbiddenException('Not a member of this project');
        return this.prisma.projectMember.findMany({
            where: { projectId },
            include: { user: { select: { userId: true, name: true, email: true } } },
        });
    }
    async removeMember(projectId, targetUserId, currentUser) {
        const membership = await this.getMembership(projectId, currentUser.userId);
        if (!membership || !['owner', 'admin'].includes(membership.role)) {
            throw new common_1.ForbiddenException('Not authorized to remove members');
        }
        if (targetUserId === currentUser.userId) {
            throw new common_1.BadRequestException('You cannot remove yourself');
        }
        return this.prisma.projectMember.delete({
            where: { projectId_userId: { projectId, userId: targetUserId } },
        });
    }
};
exports.ProjectsService = ProjectsService;
exports.ProjectsService = ProjectsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ProjectsService);
//# sourceMappingURL=projects.service.js.map