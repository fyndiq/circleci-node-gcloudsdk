REPO=fyndiq
NAME=circleci-node-gcloudsdk
TAG=node-22.19-gcloudsdk538.0.0-v1

build:
	docker build -t $(REPO)/$(NAME):$(TAG) .
	docker tag $(REPO)/$(NAME):$(TAG) $(REPO)/$(NAME):latest

run:
	docker run -it --rm $(REPO)/$(NAME):$(TAG)

push:
	docker push $(REPO)/$(NAME):$(TAG)
	docker push $(REPO)/$(NAME):latest
