import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
export declare class AuthService {
    private prisma;
    private jwt;
    constructor(prisma: PrismaService, jwt: JwtService);
    validateUser(email: string, password: string): Promise<{
        userId: number;
        email: string;
        name: string;
        passwordHash: string;
        createdAt: Date;
    }>;
    login(email: string, password: string): Promise<{
        access_token: string;
        token_type: string;
        user: {
            user_id: number;
            name: string;
            email: string;
        };
    }>;
}
