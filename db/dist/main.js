"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const swagger_1 = require("@nestjs/swagger");
const app_module_1 = require("./app.module");
const common_1 = require("@nestjs/common");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: false,
        exceptionFactory: (errors) => {
            return new common_1.BadRequestException(errors.map(e => Object.values(e.constraints || {})).flat());
        }
    }));
    app.enableCors();
    const config = new swagger_1.DocumentBuilder()
        .setTitle('SynergySphere API')
        .setDescription('Project Collaboration Backend — NestJS + Prisma + JWT')
        .setVersion('1.0.0')
        .addBearerAuth()
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup('docs', app, document);
    swagger_1.SwaggerModule.setup('redoc', app, document, {
        customSiteTitle: 'SynergySphere ReDoc',
    });
    await app.listen(process.env.PORT ?? 3000);
    console.log(`🚀 Server running on http://localhost:${process.env.PORT ?? 3000}`);
    console.log(`📄 Swagger UI: http://localhost:${process.env.PORT ?? 3000}/docs`);
}
bootstrap();
//# sourceMappingURL=main.js.map