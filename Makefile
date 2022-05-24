IMAGE := yew-yo-mama-jokes-client
PROXY_IMAGE := ${IMAGE}-proxy
VERSION := 0.0.2
PROXY_VERSION := 0.0.1
REGISTRY_URL := ghcr.io/apinanyogaratnam/${IMAGE}:${VERSION}
PROXY_REGISTRY_URL := ghcr.io/apinanyogaratnam/${PROXY_IMAGE}:${PROXY_VERSION}

start:
	trunk serve

start-proxy:
	python3 proxy/proxy.py

build:
	docker build -t ${IMAGE} .

build-proxy:
	docker build -t ${PROXY_IMAGE} proxy

run:
	docker run -d -p 8080:8080 --name ${IMAGE} ${IMAGE}

run-proxy:
	docker run -d -p 8000:8000 --name ${PROXY_IMAGE} ${PROXY_IMAGE}

up:
	docker-compose up --build --remove-orphans

stop:
	docker stop ${IMAGE}

stop-proxy:
	docker stop ${PROXY_IMAGE}

remove-proxy:
	docker rm ${PROXY_IMAGE}

prune:
	docker system prune --all --volumes

exec:
	docker exec -it $(sha) /bin/sh

auth:
	grep -v '^#' .env.local | grep -e "CR_PAT" | sed -e 's/.*=//' | docker login ghcr.io -u USERNAME --password-stdin

tag:
	docker tag ${IMAGE} ${REGISTRY_URL}
	git tag -m "v${VERSION}" v${VERSION}

tag-proxy:
	docker tag ${PROXY_IMAGE} ${PROXY_REGISTRY_URL}

push:
	docker push ${REGISTRY_URL}
	git push --tags

push-proxy:
	docker push ${PROXY_REGISTRY_URL}

all:
	make build && make auth && make tag && make push

all-proxy:
	make build-proxy && make auth && make tag-proxy && make push-proxy
