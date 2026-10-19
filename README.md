# Conecta Nexus - API Gateway

Reverse proxy and API Gateway for the **Conecta Nexus** microservices ecosystem based on Nginx Alpine.

---

## Architecture & Responsibilities

The API Gateway acts as the unified reverse proxy and entry point:
- Routes incoming public traffic to the frontend and underlying microservices.
- Enforces uniform headers (`Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`).
- Supports WebSocket upgrades (`Upgrade`, `Connection: "upgrade"`) for Vite / Nuxt Hot Module Replacement (HMR).
- Provides routing prefix `/api/v1/*` to downstream services.

---

## Route Mappings

| Prefix / Path | Target Service | Internal Destination | Description |
| :--- | :--- | :--- | :--- |
| `/` | `frontend` | `http://frontend:3000` | Nuxt 4 web application |
| `/gateway/health` | `gateway` | *Local Nginx* | Gateway health check (`{"status":"healthy"}`) |
| `/api/v1/auth/` | `auth` | `http://auth:8000` | Authentication & JWT authorization |
| `/api/v1/profile/` | `profile` | `http://profile:8000` | User profiles & Law 1581 consent |
| `/api/v1/challenges/` | `challenge` | `http://challenge:8000` | Challenge creation & exploration |
| `/api/v1/applications/`| `application` | `http://application:8000` | Application submissions & matching |
| `/api/v1/moderation/` | `moderation` | `http://moderation_upstream` | Content moderation |
| `/api/v1/notifications/`| `notification` | `http://notification_upstream` | Notifications & alerts |
| `/services/<service>/` | Direct probe | `http://<service>:8000/` | Inspect microservice root `/health` directly |

---

## Local Execution

The gateway is built and managed via the root `compose.yaml` (or `podman compose`):

```bash
# From the conecta-nexus root directory:
podman compose up --build gateway
```
