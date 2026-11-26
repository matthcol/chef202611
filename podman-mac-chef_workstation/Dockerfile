# Image Chef Workstation pour stagiaires macOS + Podman (voir README.md
# de ce dossier pour le détail des commandes build/run et des prérequis
# spécifiques à Podman : Rosetta, podman-mac-helper).
#
# --platform=linux/amd64 est fixé ici (pas juste au moment du build) pour
# que l'image soit toujours construite en amd64, quel que soit l'hôte qui
# lance `podman build` (Apple Silicon ou Intel). Chef Workstation 25.x ne
# fournit pas de paquet Linux aarch64 (ajouté seulement en 26.2.0), d'où
# la nécessité de rester en amd64 + émulation sur les Mac M1/M2/M3.
FROM --platform=linux/amd64 ubuntu:22.04

ARG CHEF_WORKSTATION_VERSION=25.14.2

RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends curl ca-certificates docker.io rsync openssh-client locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

RUN curl -fsSL https://omnitruck.chef.io/install.sh \
    | bash -s -- -P chef-workstation -v "${CHEF_WORKSTATION_VERSION}"

# Chef Workstation 25.x refuse de s'exécuter sans acceptation explicite de la
# licence (gratuite). CHEF_LICENSE=accept-no-persist l'accepte pour chaque
# invocation sans écrire de fichier de license dans l'image.
ENV CHEF_LICENSE=accept-no-persist
# Chef Infra Client vérifie la présence d'une VRAIE locale UTF-8 anglaise
# installée (via `locale -a`) et pas seulement la pseudo-locale C.UTF-8,
# sinon il affiche le warning et repasse en C (désactivant l'UTF-8).
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN chef gem install kitchen-dokken

WORKDIR /workdir
CMD ["bash"]
