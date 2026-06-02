REPO=fyndiq
NAME=circleci-node-gcloudsdk
TAG:=$(shell git rev-parse --short HEAD)
IMAGE=$(REPO)/$(NAME):$(TAG)

build:
	docker buildx build --platform linux/amd64 -t $(IMAGE) --load .
	docker tag $(IMAGE) $(REPO)/$(NAME):latest

build-local:
	docker build -t $(IMAGE) .
	docker tag $(IMAGE) $(REPO)/$(NAME):latest

run:
	docker run -it --rm $(IMAGE)

push:
	docker buildx build --platform linux/amd64 -t $(IMAGE) -t $(REPO)/$(NAME):latest . --push
