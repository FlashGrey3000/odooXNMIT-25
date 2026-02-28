export declare class CreateProjectDto {
    name: string;
    description?: string;
}
export declare class UpdateProjectDto {
    name?: string;
    description?: string;
}
export declare class AddMemberDto {
    userId: number;
    role?: 'member' | 'admin';
}
