REPO=fyndiq
NAME=circleci-node-gcloudsdk
TAG=node-lts-gcloudsdk538.0.0-v1

build:
	docker buildx build --platform linux/amd64 -t $(REPO)/$(NAME):$(TAG) --load .
	docker tag $(REPO)/$(NAME):$(TAG) $(REPO)/$(NAME):latest

build-local:
	docker build -t $(REPO)/$(NAME):$(TAG) .
	docker tag $(REPO)/$(NAME):$(TAG) $(REPO)/$(NAME):latest

run:
	docker run -it --rm $(REPO)/$(NAME):$(TAG)

push:
	docker buildx build --platform linux/amd64 -t $(REPO)/$(NAME):$(TAG) -t $(REPO)/$(NAME):latest . --push
