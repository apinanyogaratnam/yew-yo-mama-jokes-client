IMAGE := yew-yo-mama-jokes-client
VERSION := 0.0.2
REGISTRY_URL := ghcr.io/apinanyogaratnam/${IMAGE}:${VERSION}

start:
	trunk serve

build:
	docker build -t ${IMAGE} .

build-proxy:
	docker build -t ${IMAGE}-proxy -f proxy/Dockerfile .

run:
	docker run -d -p 8080:8080 --name ${IMAGE} ${IMAGE}

run-proxy:
	docker run -d -p 8000:8000 --name ${IMAGE}-proxy ${IMAGE}-proxy

stop:
	docker stop ${IMAGE}

stop-proxy:
	docker stop ${IMAGE}-proxy

prune:
	docker system prune --all --volumes

exec:
	docker exec -it $(sha) /bin/sh

auth:
	grep -v '^#' .env.local | grep -e "CR_PAT" | sed -e 's/.*=//' | docker login ghcr.io -u USERNAME --password-stdin

tag:
	docker tag ${IMAGE} ${REGISTRY_URL}
	git tag -m "v${VERSION}" v${VERSION}

push:
	docker push ${REGISTRY_URL}
	git push --tags

all:
	make build && make auth && make tag && make push
