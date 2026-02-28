# SynergySphere API — NestJS + Prisma + JWT

Converted from FastAPI/Python → Node.js + NestJS + Prisma ORM + JWT Auth.

## Stack

| Layer       | Tech                          |
|-------------|-------------------------------|
| Framework   | NestJS 10                     |
| ORM         | Prisma 5                      |
| Auth        | JWT (passport-jwt)            |
| Validation  | class-validator               |
| Database    | MySQL 8 (or PostgreSQL 15)    |
| Docs        | Swagger UI @ `/docs`          |

---

## Quick Start

### 1. Install dependencies
```bash
npm install
```

### 2. Configure environment
```bash
cp .env.example .env
# Edit .env — set DATABASE_URL and JWT_SECRET
```

### 3. Start the database
```bash
docker-compose up -d db
```

### 4. Run Prisma migrations
```bash
npx prisma migrate dev --name init
npx prisma generate
```

### 5. Start the server
```bash
npm run start:dev        # development (hot reload)
npm run start:prod       # production
```

---

## API Endpoints

| Method | Path                             | Auth | Description                      |
|--------|----------------------------------|------|----------------------------------|
| POST   | `/signup`                        | ❌   | Register user                    |
| POST   | `/login`                         | ❌   | Login → JWT                      |
| GET    | `/users/me`                      | ✅   | Current user profile             |
| GET    | `/users/:id`                     | ✅   | Get user (self/admin)            |
| GET    | `/users/:id/projects`            | ✅   | User's projects (admin-scoped)   |
| GET    | `/users/:id/tasks`               | ✅   | User's tasks (admin-scoped)      |
| POST   | `/projects`                      | ✅   | Create project                   |
| GET    | `/projects/:id`                  | ✅   | Get project (members only)       |
| PUT    | `/projects/:id/update`           | ✅   | Update project (owner/admin)     |
| POST   | `/projects/:id/members`          | ✅   | Add member (owner/admin)         |
| GET    | `/projects/:id/tasks`            | ✅   | List project tasks (members)     |
| POST   | `/tasks`                         | ✅   | Create task                      |
| PUT    | `/tasks/:id/update`              | ✅   | Update task (owner/admin)        |
| DELETE | `/tasks/:id/delete`              | ✅   | Delete task (owner/admin)        |

Swagger UI: `http://localhost:3000/docs`

---

## Switching to PostgreSQL

1. In `prisma/schema.prisma`, change `provider = "mysql"` → `provider = "postgresql"`
2. In `.env`, update `DATABASE_URL` to `postgresql://...`
3. In `docker-compose.yml`, uncomment the PostgreSQL service and comment out MySQL
4. Re-run `npx prisma migrate dev --name init`

---

## Project Structure

```
src/
├── main.ts                  # Bootstrap + Swagger
├── app.module.ts            # Root module
├── prisma/
│   ├── prisma.service.ts    # PrismaClient wrapper
│   └── prisma.module.ts
├── auth/
│   ├── auth.module.ts
│   ├── auth.service.ts      # validateUser, login
│   ├── auth.controller.ts   # POST /login
│   ├── jwt.strategy.ts      # Passport JWT strategy
│   ├── jwt-auth.guard.ts    # Guard for protected routes
│   ├── get-user.decorator.ts
│   └── dto/login.dto.ts
├── users/
│   ├── users.module.ts
│   ├── users.service.ts
│   ├── users.controller.ts
│   └── dto/user.dto.ts
├── projects/
│   ├── projects.module.ts
│   ├── projects.service.ts
│   ├── projects.controller.ts
│   └── dto/project.dto.ts
└── tasks/
    ├── tasks.module.ts
    ├── tasks.service.ts
    ├── tasks.controller.ts
    └── dto/task.dto.ts
prisma/
└── schema.prisma            # DB schema + Prisma models
```
