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

Using a Python project as an example:

```bash
# Run with network first
SANDBOX_NETWORK=slirp4netns ~/sandbox.sh

# Create and navigate to your project
uv init myapp
cd ./myapp

# Create virtual env and install dependencies
uv venv
source .venv/bin/activate
uv add <dependencies>

# Recreate container without network
exit
~/sandbox.sh

# Run your app
source .venv/bin/activate
uv run main.py
```

Secrets are loaded automatically if `~/.secrets/<project-name>.env` exists.
