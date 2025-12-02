# rsgain-runner

A Docker container that runs rsgain (ReplayGain scanner) on a mounted music volume, scheduled via cron.

## Quick Start

Pull the pre-built image from Docker Hub:

```bash
docker pull themranderson/rsgain-runner:latest
```

Then run it:

```bash
docker run -d \
  -v /path/to/your/music:/music \
  -e MODE=easy \
  -e OPTIONS="-m MAX" \
  themranderson/rsgain-runner:latest
```

## Features

- Builds rsgain from the latest source code from https://github.com/complexlogic/rsgain
- Supports both easy and custom rsgain modes
- Configurable options via environment variables
- Cron scheduling (default: weekly on Sunday at midnight)
- Volume mount for music directory

## Building the Image

### From Docker Hub (Recommended)

The image is automatically built and pushed to Docker Hub via GitHub Actions.

### Locally

To build the Docker image yourself:

```bash
docker build -t rsgain-runner .
```

This will clone the latest rsgain source and build it.

## Running the Container

Mount your music directory to `/music` inside the container.

### Easy Mode (default)

```bash
docker run -d \
  -v /path/to/your/music:/music \
  -e MODE=easy \
  -e OPTIONS="-m MAX -p preset_name" \
  -e SCHEDULE="0 0 * * 0" \
  rsgain-runner
```

- `MODE`: Set to `easy` for easy mode (scans directories recursively)
- `OPTIONS`: Additional options for rsgain easy, e.g., `-m MAX` for multithreading, `-p ebur128` for preset
- `SCHEDULE`: Cron schedule (default: "0 0 * * 0" for weekly Sunday midnight)

### Custom Mode

```bash
docker run -d \
  -v /path/to/your/music:/music \
  -e MODE=custom \
  -e OPTIONS="-a -s i" \
  -e SCHEDULE="0 0 * * 0" \
  rsgain-runner
```

- `MODE`: Set to `custom` for custom mode (scans all supported audio files recursively in /music)
- `OPTIONS`: Additional options for rsgain custom, e.g., `-a` for album tags, `-s i` for tag mode. [Full documentation](https://github.com/complexlogic/rsgain?tab=readme-ov-file#custom-mode)

## Keeping Up to Date

Since the Dockerfile clones the rsgain repository during build, to update to the latest rsgain version, simply rebuild the image:

```bash
docker build -t rsgain-runner .
```

### Automating Updates

Run the `update_and_build.sh` script periodically to check for updates and rebuild the image only if there are changes:

```bash
./update_and_build.sh
```

You can schedule this script with Windows Task Scheduler or cron on another machine to automate the update process.

## Notes

- The container runs cron in the foreground. The rsgain scan will execute according to the SCHEDULE.
- Ensure your music files are in supported formats (see rsgain documentation).
- For easy mode, organize your music by album in subdirectories.
- Logs from rsgain will be in the container logs (use `docker logs <container_id>`).

## Development

### GitHub Actions Setup

The repository includes a GitHub Action that automatically builds and pushes the Docker image to Docker Hub on every push to the main branch. You can also manually trigger the workflow from the Actions tab.

To set it up:

1. Go to your repository settings on GitHub
2. Navigate to "Secrets and variables" > "Actions"
3. Add the following secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: A Docker Hub access token (create one at https://hub.docker.com/settings/security)

The workflow will then automatically build and push images with appropriate tags.

## rsgain Documentation

For more information on rsgain options and usage, see: https://github.com/complexlogic/rsgain