import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    login(dto: LoginDto): Promise<{
        access_token: string;
        token_type: string;
        user: {
            user_id: number;
            name: string;
            email: string;
        };
    }>;
}
