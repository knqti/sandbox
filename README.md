# sandbox

A bash script to reduce supply-chain attack risk.

## How It Works

Runs your project directory inside a rootless [Podman](https://podman.io/) container with:
- No network access by default
- Dropped Linux capabilities
- No privilege escalation

The container is ephemeral (`--rm`), nothing persists outside your project directory.

## Files

- `~/sandbox.sh`: bash script to execute 
- `~/.dockerfiles/Dockerfile.dev`: Docker file to build the image
- `~/.secrets/<project-name>.env`: Optional, per-project environment variables

## Usage

```bash
# Navigate to your project and run
cd ~/projects/myapp
~/sandbox.sh
```

Secrets are loaded automatically if `~/.secrets/<project-name>.env` exists.
