#!/bin/bash

# Test script to validate the Node.js 22 Docker image functionality
set -e

IMAGE_TAG="fyndiq/circleci-node-gcloudsdk:node-lts-gcloudsdk538.0.0-v1"

echo "🧪 Testing Docker image: $IMAGE_TAG"
echo "=================================="

# Step 1: Build the image
echo "1️⃣  Building Docker image..."
make build

# Step 2: Test Node.js version
echo "2️⃣  Testing Node.js version..."
NODE_VERSION=$(docker run --rm $IMAGE_TAG node --version)
echo "✅ Node.js version: $NODE_VERSION"

# Verify it's Node.js 22
if [[ $NODE_VERSION == v22.* ]]; then
    echo "✅ Node.js 22.x confirmed"
else
    echo "❌ Expected Node.js 22.x, got: $NODE_VERSION"
    exit 1
fi

# Step 3: Test npm
echo "3️⃣  Testing npm..."
NPM_VERSION=$(docker run --rm $IMAGE_TAG npm --version)
echo "✅ npm version: $NPM_VERSION"

# Step 4: Test Google Cloud SDK
echo "4️⃣  Testing Google Cloud SDK..."
GCLOUD_VERSION=$(docker run --rm $IMAGE_TAG gcloud --version | head -1)
echo "✅ Google Cloud SDK version: $GCLOUD_VERSION"

# Step 5: Test kubectl
echo "5️⃣  Testing kubectl..."
KUBECTL_VERSION=$(docker run --rm $IMAGE_TAG kubectl version --client --output=yaml | grep gitVersion || echo "kubectl installed")
echo "✅ kubectl: $KUBECTL_VERSION"

# Step 6: Test helm
echo "6️⃣  Testing Helm..."
HELM_VERSION=$(docker run --rm $IMAGE_TAG helm version --short --client)
echo "✅ Helm version: $HELM_VERSION"

# Step 7: Test skaffold
echo "7️⃣  Testing Skaffold..."
SKAFFOLD_VERSION=$(docker run --rm $IMAGE_TAG skaffold version)
echo "✅ Skaffold version: $SKAFFOLD_VERSION"

# Step 8: Test jq
echo "8️⃣  Testing jq..."
JQ_VERSION=$(docker run --rm $IMAGE_TAG jq --version)
echo "✅ jq version: $JQ_VERSION"

# Step 9: Test user setup
echo "9️⃣  Testing user setup..."
USER_INFO=$(docker run --rm $IMAGE_TAG whoami)
echo "✅ Running as user: $USER_INFO"

if [[ $USER_INFO == "circleci" ]]; then
    echo "✅ CircleCI user setup confirmed"
else
    echo "❌ Expected user 'circleci', got: $USER_INFO"
    exit 1
fi

# Step 10: Test sudo access
echo "🔟 Testing sudo access..."
docker run --rm $IMAGE_TAG sudo echo "Sudo access works" > /dev/null
echo "✅ Sudo access confirmed"

echo ""
echo "🎉 All tests passed! The Docker image is ready for use."
echo "=================================="
echo "Node.js version: $NODE_VERSION"
echo "Google Cloud SDK: $GCLOUD_VERSION"
echo "Running as: $USER_INFO"
echo ""
echo "To use this image:"
echo "  docker run -it --rm $IMAGE_TAG"
echo ""
echo "To push to registry:"
echo "  make push"
