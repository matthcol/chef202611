# Chef

## Chef Workstation
### Installation OS
- chef.io/chef => Get Started
### Installation Docker
Dockerfile: docker-chef-workstation

Run linux/macos:
```sh
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
             -v "$(pwd)/code:/workdir" -w /workdir chef-tooling:local bash
```

Run Windows:
```sh
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock `
             -v "$(pwd)/code:/workdir" -w /workdir chef-tooling:local bash
```