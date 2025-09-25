# CircleCI Node Google Cloud SDK

Docker image that extends the `cimg/node` image with Google's Cloud SDK and additional tools for CI/CD pipelines.

## Current Version

- **Node.js**: 22.19 (pinned for compatibility)
- **Google Cloud SDK**: 538.0.0
- **Additional Tools**: kubectl, Helm (v3.4.2), Skaffold (v1.17.2), jq

## Quick Start

```bash
# Use in your CircleCI config
docker: fyndiq/circleci-node-gcloudsdk:node-lts-gcloudsdk538.0.0-v1
```

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
- ✅ kubectl, Helm, Skaffold, and jq tools
- ✅ CircleCI user setup and sudo access

### Push to Registry

```bash
# Builds for amd64 and pushes directly
make push
```

**Note**: `make push` automatically builds for `linux/amd64` and pushes to ensure CircleCI compatibility.

## Updating Versions

### Update Node.js Version

1. Check available `cimg/node` tags at [CircleCI Node Images](https://circleci.com/developer/images/image/cimg/node)
2. Update the `FROM` line in `Dockerfile`:

   ```dockerfile
   FROM cimg/node:22.19  # Pinned to specific version for compatibility
   ```

3. Update the tag in `Makefile`:

   ```makefile
   TAG=node-lts-gcloudsdk538.0.0-v1  # Use lts or specific version number
   ```

4. Update the test script tag in `test-image.sh`
5. Test the changes: `./test-image.sh`

### Update Google Cloud SDK Version

1. Find latest version:

   ```bash
   curl -s https://packages.cloud.google.com/apt/dists/cloud-sdk/main/binary-all/Packages | grep "Version:" | sort -V | tail -5
   ```

2. Update `GOOGLE_SDK_VERSION` in `Dockerfile`:

   ```dockerfile
   ARG GOOGLE_SDK_VERSION=538.0.0-0  # Change to desired version
   ```

3. Update the tag in `Makefile` and `test-image.sh`
4. Test the changes: `./test-image.sh`

### Update Other Tools

Edit the respective `ARG` variables in the `Dockerfile`:

- `SKAFFOLD_VERSION` for Skaffold
- `HELM_VERSION` for Helm

## Troubleshooting

### Common Issues

**Architecture Issues in CircleCI**
- **Error**: "found arm64 but need [amd64 i386 386]"
- **Solution**: Rebuild with `make push` (builds for amd64 automatically)
- **Cause**: Image was built on Apple Silicon (arm64) but CircleCI needs amd64

**Google Cloud SDK Installation Fails**
- Ensure you're using the correct package name (`google-cloud-cli` vs `google-cloud-sdk`)
- Check version compatibility with the base Node.js image

**Node.js Version Mismatch**
- Verify the `cimg/node` tag exists: `docker pull cimg/node:VERSION`
- Use `docker run --rm cimg/node:VERSION node --version` to check exact version

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
