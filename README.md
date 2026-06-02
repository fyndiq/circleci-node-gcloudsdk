# CircleCI Node Google Cloud SDK

Docker image that extends the `cimg/node` image with Google's Cloud SDK and additional tools for CI/CD pipelines.

## Current Version

- **Node.js**: 22.19.0 (pinned to specific version)
- **Google Cloud SDK**: 570.0.0
- **Additional Tools**: kubectl, Helm (v4.2.0), Skaffold (installed via gcloud components)

## Quick Start

```bash
# Use in your CircleCI config
docker: fyndiq/circleci-node-gcloudsdk:latest

# To pin to a specific build (e.g. when testing changes), use the short git SHA
docker: fyndiq/circleci-node-gcloudsdk:<sha>
```

CI pipelines use the `latest` tag by default. Each build is also published under its short git SHA — see [Available Tags](#available-tags) for the full list.

## Building and Testing

### Architecture Requirements

**Important**: This image must be built for `linux/amd64` architecture to be compatible with CircleCI runners.

### Build the Image

```bash
# Build for production (amd64 - CircleCI compatible)
make build

# Build for local testing (native architecture)
make build-local
```

### Test the Image

Run the comprehensive test suite to verify all tools work correctly:

```bash
./test-image.sh
```

The test script will verify:

- ✅ Node.js version and npm
- ✅ Google Cloud SDK functionality
- ✅ kubectl, Helm, and Skaffold tools
- ✅ CircleCI user setup and sudo access

### Push to Registry

```bash
# Builds for amd64 and pushes directly
make push
```

**Note**: `make push` automatically builds for `linux/amd64` and pushes to ensure CircleCI compatibility.

## Updating Versions

> **Note**: The image tag is derived from the short git SHA at build time (see `Makefile`), so updating versions does not require editing the `TAG` anywhere — just commit your changes and rebuild.

### Update Node.js Version

1. Check available `cimg/node` tags at [CircleCI Node Images](https://circleci.com/developer/images/image/cimg/node)
2. Update the `FROM` line in `Dockerfile`:

   ```dockerfile
   FROM cimg/node:22.19.0  # Pinned to specific version
   ```

3. Test the changes: `./test-image.sh`

### Update Google Cloud SDK Version

1. Find the latest version — either browse the [Google Cloud SDK release notes](https://cloud.google.com/sdk/docs/release-notes), or query the apt repo directly (the version numbers match the tar.gz releases used here):

   ```bash
   curl -s https://packages.cloud.google.com/apt/dists/cloud-sdk/main/binary-all/Packages | grep "Version:" | sort -V | tail -5
   ```

2. Update `GOOGLE_CLOUD_CLI_VERSION` in `Dockerfile`:

   ```dockerfile
   ARG GOOGLE_CLOUD_CLI_VERSION=570.0.0  # Change to desired version
   ```

3. Test the changes: `./test-image.sh`

### Update Other Tools

- Skaffold and kubectl are installed as gcloud components, so they upgrade with the Google Cloud SDK
- Edit `HELM_VERSION` in the `Dockerfile` to bump Helm

## Troubleshooting

### Common Issues

**Architecture Issues in CircleCI**
- **Error**: "found arm64 but need [amd64 i386 386]"
- **Solution**: Rebuild with `make push` (builds for amd64 automatically)
- **Cause**: Image was built on Apple Silicon (arm64) but CircleCI needs amd64

**Google Cloud SDK Installation Fails**
- Verify the `GOOGLE_CLOUD_CLI_VERSION` exists in the [release notes](https://cloud.google.com/sdk/docs/release-notes)
- Check version compatibility with the base Node.js image

**Node.js Version Mismatch**
- **Important**: CircleCI's `cimg/node:22.19` is a floating tag that updates to newer patch versions
- To lock to an exact version, use specific version tag: `FROM cimg/node:22.19.0`
- For ultimate locking, use SHA digest: `FROM cimg/node:22.19.0@sha256:...`
- Verify the exact version: `docker run --rm cimg/node:VERSION node --version`
- Find image digests at: [CircleCI Docker Hub](https://hub.docker.com/r/cimg/node/tags)

**Build Performance**
- Docker layers are cached for faster rebuilds
- Use `docker system prune` if builds become slow

## Available Tags

See [Dockerhub](https://hub.docker.com/r/fyndiq/circleci-node-gcloudsdk/) for all available tags.

## Contributing

1. Make your changes
2. Run tests: `./test-image.sh`
3. Ensure all tests pass before pushing
4. Update this README if changing versions or adding features
