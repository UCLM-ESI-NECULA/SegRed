.PHONY: build network container remove clean

containers: build network
	docker run --privileged --rm -ti -d --name postgres --hostname postgres -e POSTGRES_PASSWORD=root -e POSTGRES_USER=root -e POSTGRES_DB=gin-gonic-api -p 5432:5432 --ip 10.0.2.5 --network srv -v postgres-data:/var/lib/postgresql/data postgres:14-alpine
	
	docker run --privileged --rm -ti -d --name router -p 8080:8080 --hostname router midebian-router
	docker network connect dmz router
	docker network connect srv router
	docker network connect dev router


	docker run --privileged --rm -ti -d --name jump		--hostname jump		--ip 10.0.1.3	--network dmz midebian-jump
	docker run --privileged --rm -ti -d --name work		--hostname work		--ip 10.0.3.3	--network dev midebian-work
	docker run --privileged --rm -ti -d --name file 	--hostname file 	--ip 10.0.2.4	--network srv 	 --env-file ./docker/seg-red-file/.dk.env seg-red-file
	docker run --privileged --rm -ti -d --name auth 	--hostname auth 	--ip 10.0.2.3	--network srv 	 --env-file ./docker/seg-red-auth/.dk.env seg-red-auth
	docker run --privileged --rm -ti -d --name broker	--hostname broker	--ip 10.0.1.4	--network dmz 	 --env-file ./docker/seg-red-broker/.dk.env seg-red-broker

build:
	docker build --rm -f docker/Dockerfile --tag midebian docker/
	docker build --rm -f docker/router/Dockerfile --tag midebian-router docker/router
	docker build --rm -f docker/jump/Dockerfile --tag midebian-jump docker/jump
	docker build --rm -f docker/work/Dockerfile --tag midebian-work docker/work
	docker build --rm -f docker/seg-red-file/Dockerfile --tag seg-red-file docker/seg-red-file
	docker build --rm -f docker/seg-red-auth/Dockerfile --tag seg-red-auth docker/seg-red-auth
	docker build --rm -f docker/seg-red-broker/Dockerfile --tag seg-red-broker docker/seg-red-broker

network:
	-docker network create -d bridge --subnet 10.0.1.0/24 dmz
	-docker network create -d bridge --subnet 10.0.2.0/24 srv
	-docker network create -d bridge --subnet 10.0.3.0/24 dev

remove:
	-docker stop router work jump postgres file auth broker
	-docker network prune -f

run-tests:
	python3 tests.py

clean:
	find . -name "*~" -delete