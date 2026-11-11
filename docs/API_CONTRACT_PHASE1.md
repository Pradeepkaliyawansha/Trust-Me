# Auth API contract expected by the Flutter app (Phase 1)

Base URL: `/api/v1`. Errors: `{ "statusCode": 401, "message": "…", "code": "INVALID_CREDENTIALS" }`.

| Method | Path | Body | Success |
|---|---|---|---|
| POST | /auth/login | `{phone, password}` | `{accessToken, refreshToken, user}` |
| POST | /auth/refresh | `{refreshToken}` | `{accessToken, refreshToken}` (rotated) |
| POST | /auth/logout | `{refreshToken}` | 204 |
| GET | /auth/me | – (Bearer) | `user` |

`user` = `{id, fullName, phone, role, email?, isVerified}`;
`role` ∈ `BUSINESS_OWNER | MONEY_LENDER | CUSTOMER | ADMIN`.

Backend requirements: store refresh tokens hashed; on **reuse of a rotated token
revoke the whole family**; rate-limit /auth/login; enforce role + tenant checks
on every endpoint (the app's route guards are UX only).
