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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const bcrypt = require("bcrypt");
let UsersService = class UsersService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(dto) {
        const existing = await this.prisma.user.findUnique({ where: { email: dto.email } });
        if (existing)
            throw new common_1.BadRequestException('Email already registered');
        const passwordHash = await bcrypt.hash(dto.password, 10);
        const user = await this.prisma.user.create({
            data: { name: dto.name, email: dto.email, passwordHash },
        });
        return this.sanitize(user);
    }
    async findById(userId, currentUser) {
        const user = await this.prisma.user.findUnique({ where: { userId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (currentUser.userId !== userId) {
            const sharedProjects = await this.prisma.projectMember.findFirst({
                where: {
                    userId: currentUser.userId,
                    role: { in: ['owner', 'admin'] },
                    project: {
                        members: { some: { userId } },
                    },
                },
            });
            if (!sharedProjects) {
                throw new common_1.ForbiddenException('Not authorized to view this user');
            }
        }
        return this.sanitize(user);
    }
    async getMyProjects(userId) {
        return this.prisma.project.findMany({
            where: { members: { some: { userId } } },
        });
    }
    async getUserProjects(targetUserId, currentUser) {
        if (targetUserId === currentUser.userId) {
            return this.prisma.project.findMany({
                where: { members: { some: { userId: targetUserId } } },
            });
        }
        const adminMemberships = await this.prisma.projectMember.findMany({
            where: {
                userId: currentUser.userId,
                role: { in: ['owner', 'admin'] },
            },
        });
        const allowedProjectIds = adminMemberships.map((m) => m.projectId);
        return this.prisma.project.findMany({
            where: {
                projectId: { in: allowedProjectIds },
                members: { some: { userId: targetUserId } },
            },
        });
    }
    async getUserTasks(targetUserId, currentUser) {
        if (targetUserId === currentUser.userId) {
            return this.prisma.task.findMany({
                where: { assigneeId: targetUserId },
            });
        }
        const adminMemberships = await this.prisma.projectMember.findMany({
            where: {
                userId: currentUser.userId,
                role: { in: ['owner', 'admin'] },
            },
        });
        const allowedProjectIds = adminMemberships.map((m) => m.projectId);
        return this.prisma.task.findMany({
            where: {
                assigneeId: targetUserId,
                projectId: { in: allowedProjectIds },
            },
        });
    }
    sanitize(user) {
        const { passwordHash, ...safe } = user;
        return safe;
    }
    async searchByEmail(email) {
        const user = await this.prisma.user.findUnique({ where: { email } });
        if (!user)
            throw new common_1.NotFoundException('No user found with that email');
        return this.sanitize(user);
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], UsersService);
//# sourceMappingURL=users.service.js.map