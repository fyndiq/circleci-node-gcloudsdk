# CircleCI Node Google Cloud SDK

Docker image that extends the `cimg/node` image with Google's Cloud SDK and additional tools for CI/CD pipelines.

## Current Version

- **Node.js**: 22.19.0 (LTS)
- **Google Cloud SDK**: 538.0.0
- **Additional Tools**: kubectl, Helm (v3.4.2), Skaffold (v1.17.2), jq

## Quick Start

```bash
# Use in your CircleCI config
docker: fyndiq/circleci-node-gcloudsdk:node-22.19-gcloudsdk538.0.0-v1
```

## Building and Testing

### Build the Image

```bash
make build
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
make push
```

## Updating Versions

### Update Node.js Version

1. Check available `cimg/node` tags at [CircleCI Node Images](https://circleci.com/developer/images/image/cimg/node)
2. Update the `FROM` line in `Dockerfile`:

   ```dockerfile
   FROM cimg/node:22.19  # Change to desired version
   ```

3. Update the tag in `Makefile`:

   ```makefile
   TAG=node-22.19-gcloudsdk538.0.0-v1  # Update Node.js version
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

## Available Tags

See [Dockerhub](https://hub.docker.com/r/fyndiq/circleci-node-gcloudsdk/) for all available tags.

## Contributing

1. Make your changes
2. Run tests: `./test-image.sh`
3. Ensure all tests pass before pushing
4. Update this README if changing versions or adding features
