# Lab 3

## Description 
In this Lab, we had to split the services of lab 3 into 3 microservices, Auth, File, and Broker. Then we had to put them on 3 different networks with docker. We had to limit the functionalities of the networks.

## Istall
To install everything use the Makefile in the docker folder. All you have to do to build and start all the microservices with their networks is to use:

```
make containers
```

The IP of the router is 172.17.0.2 and the port is 8080. All the requests will need to be secure. 

```
curl -k --location 'https://172.17.0.2:8080/api/v1/version'
```

## More stuff
- I tried to use docker-compose and is almost all done. The problem is that with docker-compose I could not assign the IP 172.17.0.2 to the router. Maybe there is a solution to this but I couldn't find it. 
- I added the Postgres database with its volume.

# How to use these files

The provided `Makefile` has the following rules:

- `build`: create the base container image and the container images for
    `router`, `jump` and `work` machines.
- network: create the Docker networks `dmz` and `dev` using their
    respective subnets.
- containers: run the containers `router`, `jump` and `work`, adding them
    to the expected networks using their expected IP addresses.
- remove: stop the containers and remove the networks.
- clean: used to remove temporary files from the project.


## Connecting to the SSH servers

- All the accesses should be done using `jump` as "jump machine".
- There are only two users: `dev` and `op`.
- The users must only login in `work` machine.
- The `dev` user cannot access to any other machine.
- The `op` user can access to all the machines, but always running SSH
    from `work`.
- No server can be accessed using passwords, a pair of private-public
    key should be used.
- The files `op_key` and `op_key.pub` contains the private and public key
    for the user `op`.
- The files `dev_key` and `dev_key.pub` contains the private and
    public key for the user `dev`.


