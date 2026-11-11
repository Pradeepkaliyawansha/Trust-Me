# Backend setup (NestJS + Prisma + PostgreSQL)

```bash
npm i -g @nestjs/cli
nest new trust-me-api --package-manager npm && cd trust-me-api
npm i @prisma/client @nestjs/jwt @nestjs/passport passport passport-jwt \
      @nestjs/swagger class-validator class-transformer bcrypt \
      @nestjs/bullmq bullmq ioredis firebase-admin
npm i -D prisma @types/passport-jwt @types/bcrypt
npx prisma init
cp ../trust_me/backend/prisma/schema.prisma prisma/schema.prisma
npx prisma migrate dev --name init
```
The NestJS auth module itself (login/refresh/logout/me matching
`API_CONTRACT_PHASE1.md`) is delivered with Phase 2 backend work on approval.
