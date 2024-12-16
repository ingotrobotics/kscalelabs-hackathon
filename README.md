# kscalelabs-hackathon
Files for the K-Scale Labs Hackathon

This repo contains Dockerfiles for building images for [K-Scale Labs](https://docs.kscale.dev) robots, as developed during their hackathon on Dec 14-15, 2024.

Contributions, bug reports, issues, and pull requests are appreciated.

## Dependencies
The following packages (on Ubuntu 24.04) need to be installed before building and running these containers: `docker-buildx`, `docker-compose-v2`, `docker.io`.

If you are using an older version of Ubuntu, these packages are likely available and should work.

## K-Scale OS (kos)
To build a container for K-Scale OS (kos), which runs on the robots, use the `kos.dockerfile`.

### Build
```
DOCKER_BUILDKIT=1 docker build -t kos:latest -f kos.dockerfile .
```

### Run
Cross-compiling using the Rust `cross` tool uses Docker containers, so either run a Docker-in-Docker container (`dind`), or use the preferred solution: 
For more background on the potential security issues, read this article: <https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>.

Below is the command to launch the container build above:
```
docker run -it -v /var/run/docker.sock:/var/run/docker.sock kos:latest
```
Once running, you can execute all of the `cargo` commands found in the [kos README](https://github.com/kscalelabs/kos/blob/master/README.md). `cross` commands have an issue with running from the existing container, though those are being worked on.
