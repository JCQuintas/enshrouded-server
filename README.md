# Enshrouded-Dedicated-Server

[![Docker Pulls](https://img.shields.io/docker/pulls/mornedhels/enshrouded-server.svg)](https://hub.docker.com/r/mornedhels/enshrouded-server)
[![Docker Stars](https://img.shields.io/docker/stars/mornedhels/enshrouded-server.svg)](https://hub.docker.com/r/mornedhels/enshrouded-server)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mornedhels/enshrouded-server/latest)](https://hub.docker.com/r/mornedhels/enshrouded-server)
[![GitHub](https://img.shields.io/github/license/mornedhels/enshrouded-server)](https://github.com/mornedhels/enshrouded-server/blob/main/LICENSE)

[![GitHub](https://img.shields.io/badge/Repository-mornedhels/enshrouded--server-blue?logo=github)](https://github.com/mornedhels/enshrouded-server)

Docker image for the game Enshrouded. The image is based on
the [steamcmd](https://hub.docker.com/r/cm2network/steamcmd/) image and uses supervisor to handle startup, automatic
updates and cleanup.

## Environment Variables

| Variable                                                                                                     | Required | Default             | Contraints            | Description                                                                                                        | WIP | 
|--------------------------------------------------------------------------------------------------------------|:--------:|---------------------|-----------------------|--------------------------------------------------------------------------------------------------------------------|:---:|
| `SERVER_NAME`                                                                                                |          | `Enshrouded Server` | string                | The name of the server                                                                                             |  ️  |
| `SERVER_SLOT_COUNT`                                                                                          |          | `16`                | integer (1-16)        | Max allowed concurrent players                                                                                     |     |
| `SERVER_QUERYPORT`                                                                                           |          | `15637`             | integer               | The steam query port for the server                                                                                |     |
| `SERVER_IP`                                                                                                  |          | `0.0.0.0`           | string (ipv4)         | Server IP for internal network configuration                                                                       |     |
| `SERVER_SAVE_DIR`                                                                                            |          | `./savegame`        | string                | Folder for savegames (relative and absolute paths are supported)                                                   |     |
| `SERVER_LOG_DIR`                                                                                             |          | `./logs`            | string                | Folder for logs (relative and absolute paths are supported)                                                        |     |
| `SERVER_VOICE_CHAT_MODE`                                                                                     |          | `Proximity`         | Proximity \| Global   | This setting allows switching between the proximity voice chat and the global, server-wide voice chat              |     |
| `SERVER_ENABLE_VOICE_CHAT`                                                                                   |          | `false`             | boolean (true, false) | This setting allows switching voice chat completely off or enabling it.                                            |     |
| `SERVER_ENABLE_TEXT_CHAT`                                                                                    |          | `false`             | boolean (true, false) | This setting allows switching text chat completely off or enabling it.                                             |     |
| `UPDATE_CRON`                                                                                                |          |                     | string (cron format)  | Update game server files cron (eg. `*/30 * * * *` check for updates every 30 minutes)                              |     |
| `UPDATE_CHECK_PLAYERS`                                                                                       |          | `false`             | boolean (true, false) | Should the update check if someone is connected                                                                    |     |
| `BACKUP_CRON`                                                                                                |          |                     | string (cron format)  | Backup game server files cron (eg. `*/15 * * * *` backup saves every 15 minutes) - don't set cron under 10 minutes |     |
| `BACKUP_DIR`                                                                                                 |          | `./backups`          | string                | Folder for backups (relative and absolute paths are supported)                                                     |     |
| `BACKUP_MAX_COUNT`                                                                                           |          | `0`                 | integer               | Number of backups to keep (0 means infinite)                                                                       |     |
| `RESTART_CRON`                                                                                               |          |                     | string (cron format)  | Restart game server cron (eg. `0 3 * * *` restart server daily at 3)                                               | ⚠️  |
| `RESTART_CHECK_PLAYERS`                                                                                      |          | `false`             | boolean (true, false) | Should the restart check if someone is connected                                                                   | ⚠️  |
| `GAME_BRANCH`                                                                                                |          | `public`            | string                | Steam branch (eg. testing) of the Enshrouded server                                                                |     |
| `STEAMCMD_ARGS`                                                                                              |          | `validate`          | string                | Additional steamcmd args for the updater                                                                           |     |
| `SERVER_PASSWORD` ⚠️DEPRECATED                                                                               |          |                     | string                | ⚠️ DEPRECATED: The password for the server (Enshrouded ignores this value - use Server Roles instead)              |     |
| **[Server Roles](https://github.com/mornedhels/enshrouded-server/blob/main/docs/SERVER_ROLES.md)**           |          |                     |                       | further informations can be found following the link                                                               |     |
| **[Server Difficulty](https://github.com/mornedhels/enshrouded-server/blob/main/docs/SERVER_DIFFICULTY.md)** |          |                     |                       | further informations can be found following the link                                                               | ⚠️  |

All environment Variables prefixed with SERVER, are the available enshrouded_server.json options
(see [Enshrouded Docs](https://enshrouded.zendesk.com/hc/en-us/articles/16055441447709-Dedicated-Server-Configuration))

⚠️: Work in Progress

### Additional Information

* During the update process, the container temporarily requires more disk space (up to 2x the game size).
* Server role configuration can be done via the `enshrouded_server.json` file directly or the `SERVER_ROLE_<index>_XYZ`
  environment vars. The file is located in the `game/server` folder. More information can be found in
  the [official documentation](https://enshrouded.zendesk.com/hc/en-us/articles/19191581489309-Server-Roles-Configuration).

### Hooks

| Variable            | Description                            | WIP |
|---------------------|----------------------------------------|:---:|
| `BOOTSTRAP_HOOK`    | Command to run after general bootstrap |     |
| `UPDATE_PRE_HOOK`   | Command to run before update           |     |
| `UPDATE_POST_HOOK`  | Command to run after update            |     |
| `BACKUP_PRE_HOOK`   | Command to run before backup & cleanup |     |
| `BACKUP_POST_HOOK`  | Command to run after backup & cleanup  |     |
| `RESTART_PRE_HOOK`  | Command to run before server restart   |     |
| `RESTART_POST_HOOK` | Command to run after server restart    |     |

The scripts will wait for the hook to resolve/return before continuing.

⚠️: Work in Progress

## Image Tags

| Tag                | Virtualization | Description                              |
|--------------------|----------------|------------------------------------------|
| `latest`           | proton         | Latest image based on proton             |
| `<version>`        | proton         | Pinned image based on proton (>= 1.x.x)  |
| `stable-proton`    | proton         | Same as latest image                     |
| `<version>-proton` | proton         | Pinned image based on proton             |
| `stable-wine`      | wine           | Latest image based on wine               |
| `<version>-wine`   | wine           | Pinned image based on wine               |
| `dev-proton`       | proton         | Dev build based on proton                |
| `dev-wine`         | wine           | Dev build based on wine                  |
| `dev-wine-staging` | wine           | Dev build based on wine (staging branch) |

## Ports (default)

| Port      | Description      |
|-----------|------------------|
| 15637/udp | Steam query port |

## Volumes

| Volume          | Description                      |
|-----------------|----------------------------------|
| /opt/enshrouded | Game files (steam download path) |

**Note:** The container runs as the user specified via Docker's `--user` flag. Make sure the mounted volumes are owned
by or writable by this user. You can use `--user $(id -u):$(id -g)` to run as your current user.

## Recommended System Requirements

* CPU: >= 6 cores
* RAM: >= 16 GB
* Disk: >= 30 GB (preferably SSD)

**[Official Docs](https://enshrouded.zendesk.com/hc/en-us/articles/16055628734109-Recommended-Server-Specifications)**

## Usage

### Docker

```bash
docker run -d --name enshrouded \
  --hostname enshrouded \
  --restart=unless-stopped \
  --user $(id -u):$(id -g) \
  -p 15637:15637/udp \
  -v ./game:/opt/enshrouded \
  -e SERVER_NAME="Enshrouded Server" \
  -e SERVER_PASSWORD="secret" \
  -e UPDATE_CRON="*/30 * * * *" \
  mornedhels/enshrouded-server:latest
```

### Docker Compose

```yaml
services:
  enshrouded:
    image: mornedhels/enshrouded-server:latest
    container_name: enshrouded
    hostname: enshrouded
    restart: unless-stopped
    stop_grace_period: 90s
    # Run as specific user (UID:GID) - replace with your user's IDs
    user: "1000:1000"
    ports:
      - "15637:15637/udp"
    volumes:
      - ./game:/opt/enshrouded
    # only add ntsync device if your kernel supports it (6.14 or newer)
    devices:
      - /dev/ntsync:/dev/ntsync
    environment:
      - SERVER_NAME=Enshrouded Server
      - SERVER_PASSWORD=secret
      - UPDATE_CRON=*/30 * * * *
```

**Note:** The volumes are created next to the docker-compose.yml file. If you want to create the volumes, in the default
location (eg. /var/lib/docker) you can use the following compose file:

```yaml
services:
  enshrouded:
    image: mornedhels/enshrouded-server:latest
    container_name: enshrouded
    hostname: enshrouded
    restart: unless-stopped
    stop_grace_period: 90s
    # Run as specific user (UID:GID) - replace with your user's IDs
    user: "1000:1000"
    ports:
      - "15637:15637/udp"
    volumes:
      - game:/opt/enshrouded
    # only add ntsync device if your kernel supports it (6.14 or newer)
    devices:
      - /dev/ntsync:/dev/ntsync
    environment:
      - SERVER_NAME=Enshrouded Server
      - SERVER_PASSWORD=secret
      - UPDATE_CRON=*/30 * * * *

volumes:
  game:
```

## Backup

The image includes a backup script that creates a zip file of the last saved game state. To enable backups, set
the `BACKUP_CRON` environment variable. To limit the number of backups, set the `BACKUP_MAX_COUNT` environment variable.

To restore a backup, stop the server and simply extract the zip file to the savegame folder and start the server up
again. If you want to keep the current savegame, make sure to make a backup before deleting or overwriting the files.

> [!WARNING]  
> Verify the permissions of the extracted files. The files should be owned by or writable by the user specified
> via Docker's `--user` flag.

## Commands

* **Force Update:**
  ```bash
  docker compose exec enshrouded supervisorctl start enshrouded-force-update
  ```
* **Reset Server Roles:** (Restarts the whole docker container) ⚠️
  ```bash
  docker compose exec enshrouded supervisorctl start enshrouded-reset-roles
  ```
* **Restart Enshrouded Server:** (can be used for periodic restarts)
  ```bash
  docker compose exec enshrouded supervisorctl restart enshrouded-server
  ```

## Known Issues

* The server doesn't start (not logging `'HostOnline' (up)!`) or the update fails with following error:
  ```
  Error! App '2278520' state is 0x202 after update job.
  ```
  This means there is probably something wrong with your file permissions, or you don't have enough disk space left.
  Make sure the mounted volumes are owned by or writable by the user specified via Docker's `--user` flag.
* The (auto-)update fails with the following error:
  ```
  Error! App '2278520' state is 0x6 after update job.
  ```
  Officially this means the updater has no connection to the content servers.
  <br/>But there could also be something wrong with the steam
  appmanifest ([#119](https://github.com/mornedhels/enshrouded-server/issues/119)). To fix this, you can use the **force
  update** command.
