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


Plateformes: ajout de 4 plateformes dans kitchden.yml
```sh
kitchen list
kitchen converge   # add new platforms

# recreate platform
kitchen destroy default-ubuntu-2604
kitchen converge default-ubuntu-2604
kitchen list

# checkup
docker ps
docker exec -it 5f8fba4942-default-ubuntu-2604 bash -c "tail -1 /etc/passwd && ls -l /opt/hello.txt && cat /opt/hello.txt"
docker exec -it 5f8fba4942-default-debian-13 bash -c "tail -1 /etc/passwd && ls -l /opt/hello.txt && cat /opt/hello.txt"
docker exec -it 5f8fba4942-default-rockylinux-10 bash -c "tail -1 /etc/passwd && ls -l /opt/hello.txt && cat /opt/hello.txt"
```

Ajout du package nginx dans la recette
```sh
kitchen converge default-ubuntu-2204    # utilise apt
kitchen converge default-rockylinux-10  # utilise dnf

docker exec -it 5f8fba4942-default-rockylinux-10 bash -c "systemctl status nginx"
docker exec -it 5f8fba4942-default-ubuntu-2204 bash -c "systemctl status nginx"

# pour toutes
kitchen converge
docker exec -it 5f8fba4942-default-ubuntu-2404 bash -c "systemctl status nginx"
docker exec -it 5f8fba4942-default-ubuntu-2604 bash -c "systemctl status nginx"
docker exec -it 5f8fba4942-default-debian-13 bash -c "systemctl status nginx"
```

## Kitchen : recap/complément
```sh
kitchen converge  # create target node and apply recipes (n times)
kitchen destroy   # clean kitchen => destroy target node
kitchen verify    # test auto 

# idem, only on this target
kitchen converge default-ubuntu-2204 
kitchen destroy default-ubuntu-2204  # clean kitchen => destroy target node
kitchen verify default-ubuntu-2204   # test auto 

# manual checkup
kitchen login default-ubuntu-2204  # session interactive
kitchen exec default-ubuntu-2204  -c "ls -alh /opt" # 1 commande à distance
```

## Tests
### Tests de validation
Chef ChefSpec vérifie avant convergence (clause conditionnelle)
### Tests d'intégration
Chef InSpec vérifie la convergence.

Chaque resource a ses propres validations.

Doc: 
https://docs.chef.io/inspec/7.3/resources/



## Resources tierces: Supermarket
Supermarket :  https://supermarket.chef.io/

Sous ensemble : sous-chef : https://supermarket.chef.io/users/sous-chefs
NB: equivalent galaxy communauty d'ansible

- ajoute la dépendance dans 
```
# file metadata.rb
depends 'line', '~> 5.0.1'
```

- install la dépendance / projet
```sh
chef install  -- 1ère fois
chef update   -- à chaque maj => Policyfile.lock.json
```

TODO: essayer les cookbooks de sous-chef
- nginx
- apache2
- mariadb
- postgresql

## Plateforme de déploiement : staging
### Install Plateforme
```sh
cd docker-platform-chef
docker compose up -d
```

Shells sur les différents noeuds:
```sh
docker exec -it chef-workstation bash
docker exec -it chef-server bash 
docker exec -it node1 bash
docker exec -it node2 bash
```

### Initialisation du chef-server
Sur le chef server
```sh
docker exec -it chef-server bash 
chef-server-ctl status  # aucun composant
chef-server-ctl reconfigure # auto-configure (avec Chef) + start
chef-server-ctl status  # all component started

# user Chef
chef-server-ctl user-create admin Admin User admin@example.org 'superpassword!' --filename /etc/opscode/admin.pem
chef-server-ctl user-list

# organisation
chef-server-ctl org-create formation "Formation Chef" --association_user admin --filename /etc/opscode/formation-validator.pem
chef-server-ctl org-list
```


### Enrôlement des noeuds : workstation
Sur l'hôte/workstation rappatrier la clé de l'admin
```sh
mkdir keys
docker cp chef-server:/etc/opscode/admin.pem keys/admin.pem
```

Outil de pilotage CLI : `knife`
```sh
docker exec -it chef-workstation bash
knife client list  # => formation-validator
knife node list   # => liste vide pour l'instant
```

Enrôlement des noeuds cibles
```sh
knife bootstrap node1 \
        --connection-user deploy --connection-password chefpass \
        --node-name node1 --sudo \
        --bootstrap-product cinc \
        --bootstrap-url https://omnitruck.cinc.sh/install.sh \
        --ssh-verify-host-key never \
        --node-ssl-verify-mode none 

knife bootstrap node2 \
        --connection-user deploy --connection-password chefpass \
        --node-name node2 --sudo \
        --bootstrap-product cinc \
        --bootstrap-url https://omnitruck.cinc.sh/install.sh \
        --ssh-verify-host-key never \
        --node-ssl-verify-mode none 

# checkup enrolment
knife client list 
knife node list 
```

NB:
- gestion du user côté node : root ou user sudoers avec ou sans validation de mot passe + clé SSH
    (ici clé SSH à faire)
- chef-cli de Progres Chef nécessite une licence et un compte (gratuit pour les dev)

## Node bootstrap et `chef-cli`
TODO
