FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server sudo curl ca-certificates locales iproute2 \
    && locale-gen en_US.UTF-8 \
    && mkdir -p /var/run/sshd \
    && rm -rf /var/lib/apt/lists/*

# sshd transmet LANG/LC_* du client (knife, depuis "workstation") au shell
# distant (AcceptEnv LANG LC_* activé par défaut sur Ubuntu) : sans la locale
# générée ci-dessus, bash affichait un warning à chaque connexion.
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Utilisateur dédié pour le bootstrap (pas de connexion root en SSH) : knife
# bootstrap se connecte en tant que "deploy" puis utilise sudo (--sudo) pour
# les étapes qui ont besoin des droits root.
RUN useradd -m -s /bin/bash deploy \
    && echo 'deploy:chefpass' | chpasswd \
    && echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/deploy \
    && chmod 0440 /etc/sudoers.d/deploy \
    && sed -i 's/#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
