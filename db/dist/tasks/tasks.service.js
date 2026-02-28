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
exports.TasksService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const client_1 = require("@prisma/client");
let TasksService = class TasksService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(dto, currentUser) {
        const membership = await this.prisma.projectMember.findUnique({
            where: { projectId_userId: { projectId: dto.projectId, userId: currentUser.userId } },
        });
        if (!membership)
            throw new common_1.ForbiddenException('You are not part of this project');
        if (membership.role === 'member') {
            if (!dto.assigneeId || dto.assigneeId !== currentUser.userId) {
                throw new common_1.ForbiddenException('Members can only assign tasks to themselves');
            }
        }
        else {
            if (dto.assigneeId) {
                const assigneeMembership = await this.prisma.projectMember.findUnique({
                    where: { projectId_userId: { projectId: dto.projectId, userId: dto.assigneeId } },
                });
                if (!assigneeMembership) {
                    throw new common_1.BadRequestException('Assignee must be a member of the project');
                }
            }
        }
        return this.prisma.task.create({
            data: {
                projectId: dto.projectId,
                title: dto.title,
                description: dto.description,
                assigneeId: dto.assigneeId ?? currentUser.userId,
                status: dto.status ?? client_1.TaskStatus.TODO,
                dueDate: dto.dueDate ? new Date(dto.dueDate) : null,
            },
        });
    }
    async update(taskId, dto, currentUser) {
        const task = await this.prisma.task.findUnique({ where: { taskId } });
        if (!task)
            throw new common_1.NotFoundException('Task not found');
        const membership = await this.prisma.projectMember.findUnique({
            where: { projectId_userId: { projectId: task.projectId, userId: currentUser.userId } },
        });
        if (!membership || !['owner', 'admin'].includes(membership.role)) {
            throw new common_1.ForbiddenException('Not authorized to update this task');
        }
        return this.prisma.task.update({
            where: { taskId },
            data: {
                ...(dto.title && { title: dto.title }),
                ...(dto.description !== undefined && { description: dto.description }),
                ...(dto.assigneeId && { assigneeId: dto.assigneeId }),
                ...(dto.status && { status: dto.status }),
                ...(dto.dueDate && { dueDate: new Date(dto.dueDate) }),
            },
        });
    }
    async delete(taskId, currentUser) {
        const task = await this.prisma.task.findUnique({ where: { taskId } });
        if (!task)
            throw new common_1.NotFoundException('Task not found');
        const membership = await this.prisma.projectMember.findUnique({
            where: { projectId_userId: { projectId: task.projectId, userId: currentUser.userId } },
        });
        if (!membership || !['owner', 'admin'].includes(membership.role)) {
            throw new common_1.ForbiddenException('Not authorized to delete this task');
        }
        await this.prisma.task.delete({ where: { taskId } });
        return { detail: 'Task deleted successfully' };
    }
};
exports.TasksService = TasksService;
exports.TasksService = TasksService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], TasksService);
//# sourceMappingURL=tasks.service.js.map