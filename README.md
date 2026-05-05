# INCEPTION

Docker-based **WordPress + MariaDB + Nginx (TLS)** stack.

This repository builds and runs a small infrastructure using **Docker Compose**:

- **MariaDB** database container
- **WordPress (PHP-FPM)** application container
- **Nginx** reverse proxy serving WordPress over **HTTPS (TLSv1.3)**

The stack is wired together on a dedicated Docker bridge network and uses bind-mounted volumes on the host for persistence.

---

## Architecture

```
Internet
   |
   | 443 (HTTPS)
   v
[Nginx]  --->  fastcgi_pass wordpress:9000  --->  [WordPress / PHP-FPM]
                                      |
                                      v
                                [MariaDB]
```

- Nginx listens on **443** and forwards `*.php` requests to **WordPress** via FastCGI on port **9000**.
- WordPress connects to MariaDB using the internal hostname **`mariadb`**.

---

## Repository layout

- `Makefile` — helper targets to build/run/clean the stack
- `srcs/docker-compose.yml` — Compose definition (services, volumes, network)
- `srcs/requirements/nginx/` — Nginx image (self-signed TLS cert + config)
- `srcs/requirements/wordpress/` — WordPress image (WP-CLI install + PHP-FPM)
- `srcs/requirements/mariadb/` — MariaDB image (DB + user creation)
- `secrets/` — placeholder secret files (empty in repo)

---

## Prerequisites

- Linux environment with:
  - `docker`
  - `docker compose` (v2)
  - `make`

This repo is configured to store persistent data under:

- `/home/aragragu/data/wordpress_volume`
- `/home/aragragu/data/mariadb_volume`

If your username is not `aragragu`, you should adjust the paths in:

- `Makefile` (`DATA_DIR`)
- `srcs/docker-compose.yml` (`volumes.*.driver_opts.device`)

---

## Configuration (.env)

`docker-compose.yml` expects an env file at:

- `srcs/.env`

This repo does not include it, so you must create it.

The containers reference at least the following variables (based on the MariaDB / WordPress init scripts):

### MariaDB
- `MARIADB_DB`
- `MARIADB_USER`
- `MARIADB_PASSWORD`

### WordPress
- `DOMAINE_NAME` (used as WP site URL)
- `TITLE`
- `USER_ADMIN`
- `ADMIN_PASSWORD`
- `ADMIN_MAIL`
- `WP_USER`
- `WP_USER_MAIL`
- `ROLE`
- `USER_PASS`

Example `srcs/.env` (values are placeholders):

```dotenv
# MariaDB
MARIADB_DB=wordpress
MARIADB_USER=wpuser
MARIADB_PASSWORD=change_me

# WordPress
DOMAINE_NAME=https://aragragu.42.fr
TITLE=Inception
USER_ADMIN=admin
ADMIN_PASSWORD=change_me_too
ADMIN_MAIL=admin@example.com

WP_USER=user
WP_USER_MAIL=user@example.com
ROLE=author
USER_PASS=change_me_again
```

---

## Secrets directory

The `secrets/` directory contains placeholder files:

- `secrets/db_root_password.txt`
- `secrets/db_password.txt`
- `secrets/credentials.txt`

In the current `docker-compose.yml`, these secrets are **not wired into the services** (Compose uses `env_file: .env` instead). If you want to use Docker secrets, you would need to update `docker-compose.yml` and the scripts accordingly.

---

## Usage

### Start the stack

From the repository root:

```bash
make
```

This will:

1. Create the data directories under `/home/aragragu/data`.
2. Build the Docker images.
3. Start the containers with Docker Compose.

### Useful Makefile commands

```bash
make build     # build images
make up        # build + start
make down      # stop + remove containers + remove volumes from compose (-v)
make stop      # stop containers
make logs      # follow logs
make clean     # down + delete /home/aragragu/data + prune images/volumes
make fclean    # aggressive prune (system prune -af --volumes)
make re        # fclean + up
```

---

## Access

- Nginx exposes **HTTPS on port 443**: `https://localhost` (or your configured domain)
- Nginx TLS is set up inside the container using a **self-signed certificate** generated at build time.

Nginx config highlights:

- `ssl_protocols TLSv1.3;`
- `fastcgi_pass wordpress:9000;`
- `root /var/www/wordpress;`

---

## Notes / Troubleshooting

- If WordPress exits with `MariaDB is not ready`, ensure the DB container is healthy and that the `.env` credentials match.
- If you changed the domain (`DOMAINE_NAME`), you may need to recreate volumes or update WordPress site URLs depending on your setup.
- If you are not `aragragu`, update the bind-mount paths as described above.

---

## Docker Under the Hood

For a deep-dive explanation of how Docker works internally, check out this Notion page written by the author:

👉 [DOCKER — inception project (Notion)](https://sable-riverbed-ddf.notion.site/DOCKER-inception-project-23a3f9fb8f71800493e0e0fdf9976a93)

It covers Docker concepts and how Docker works under the hood.

---

## License

No license file is currently included in this repository.
