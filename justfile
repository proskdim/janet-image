IMAGE_NAME := "proskurekov/janet"

default: build

run:
    docker run -it --rm {{IMAGE_NAME}} bash

build:
    docker buildx build -t {{IMAGE_NAME}} .

push:
	docker push {{IMAGE_NAME}}