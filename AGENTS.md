# Agent guidelines

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Docker image (`fyndiq/circleci-node-gcloudsdk`) that extends `cimg/node` with the Google Cloud SDK and CI/CD tooling (kubectl, Helm, Skaffold, jq) for use as a CircleCI executor. There is no application code — the entire project is the `Dockerfile`, its build/test tooling, and the CI pipeline that publishes it.

## Commands

```bash
make build        # Build for linux/amd64 (CircleCI-compatible), tag :TAG and :latest, load locally
make build-local  # Build for native arch (e.g. arm64 on Apple Silicon) — for quick local iteration only
make push         # Build linux/amd64 and push :TAG + :latest to Docker Hub
make run          # Run the built image interactively
./test-image.sh   # Build (via `make build`) then run 11 smoke tests against the image
```

There is no separate test runner — `./test-image.sh` is the test suite. It builds the image and asserts each bundled tool runs, that the default user is `circleci`, sudo works, and the architecture is `amd64`.

## Architecture constraint (critical)

The image **must** be `linux/amd64` to run on CircleCI. `make build`/`make push` enforce this via `docker buildx --platform linux/amd64`. Building with plain `docker build` (or `make build-local`) on an arm64 host produces an arm64 image that fails in CircleCI with `found arm64 but need [amd64 i386 386]`. Only publish via `make push`.

## Version pinning is the main maintenance task

Tool versions are duplicated across three files and must be kept in sync when bumping:

- `Dockerfile` — `FROM cimg/node:<version>` and the `ARG` lines (`GOOGLE_SDK_VERSION`, `SKAFFOLD_VERSION`, `HELM_VERSION`)
- `Makefile` — `TAG` (e.g. `node-lts-gcloudsdk538.0.0-v1`)
- `test-image.sh` — `IMAGE_TAG` (must match `Makefile`'s `REPO/NAME:TAG`)
- `README.md` — the "Current Version" section, for documentation

Pin `cimg/node` to an exact patch version (`22.19.0`, not the floating `22.19`). The Google Cloud SDK `ARG` uses the apt package suffix (`538.0.0-0`); the human-facing tag drops it (`538.0.0`).

After any version change, run `./test-image.sh` to verify.

## Publishing

CircleCI (`.circleci/config.yml`) auto-builds and pushes on every commit to `master` (`make build` then `make push`), using `DOCKERHUB_USERNAME`/`DOCKERHUB_PASSWORD` env vars. Pushing to `master` therefore ships a new image — there is no manual release step.

## Service interactions

This repo is not a runtime service — it has no Kafka producers/consumers, no HTTP routes, and no datastores. Its sole "interface" is the published Docker image `fyndiq/circleci-node-gcloudsdk` (Docker Hub), consumed as a CircleCI executor by other fyndiq repos. The map below was discovered from the `Dockerfile`/`Makefile` and an exhaustive `gh search code` across the fyndiq org. Update as consumers come and go.

### Upstream (what this image is built from)

- Base image `cimg/node:<version>` (`Dockerfile` `FROM`) — CircleCI's image, not a fyndiq service.
- Google Cloud SDK via the `packages.cloud.google.com` apt repo; Skaffold and Helm via GitHub releases (`Dockerfile`). All external — no fyndiq upstream services.

### Downstream (repos that use this image as their CircleCI executor)

- `fyndiq/lhci-server` — `.circleci/config.yml` (`image: fyndiq/circleci-node-gcloudsdk:latest`)
- `fyndiq/web-client-ssr` — `.circleci/continue-config.yml` (`image: fyndiq/circleci-node-gcloudsdk:latest`)
- `fyndiq/web-client-bffs` — `.circleci/config.yml` (`image: fyndiq/circleci-node-gcloudsdk:latest`)
- `fyndiq/fyndiq-2.0` — vendors this repo as a git submodule (`.gitrepos`, path `infrastructure/circleci-node-gcloudsdk/`)
