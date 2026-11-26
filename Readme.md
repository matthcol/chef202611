# Chef

## Chef Workstation
### Installation OS
- chef.io/chef => Get Started

Dispo sur MacOs:
```sh
brew install --cask chef-workstation
brew install --cask chef-workstation --version 25.14.2
```

### Installation Docker
#### Build Image
Dockerfile: docker-chef-workstation
```sh
cd docker-chef-workstation
docker build -t chef-tooling:local .
```

#### Run container
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

#### Validate Tools
```sh
chef      # cli workstation
kitchen   # tester les recettes
knife     # appliquer/synchroniser les recettes
```
#### VSCode
Extension: Chef Infra Extension 


## 1er projet
```sh
chef --version
chef generate cookbook hello  # create new cookbook
cd hello       # work with this cookbook
kitchen --version                      
kitchen converge  # applique le livre de cuisine en fonction de la conf kitchen.yaml
```

Verify
```sh
docker ps  # check target container is present
docker exec -it 5f8fba4942-default-ubuntu-2204 bash
    cat /opt/hello.txt
    exit
kitchen verify  # TODO: rédiger les tests
```

Nettoyage
```sh
kitchen destroy
docker ps # check target container is destroyed
```


Liste des `resources` de Chef:
https://docs.chef.io/client/19/resources/bundled/
