# Chef Infra Server, installé via le script officiel omnitruck
# Cette image reproduit l'installation "VM classique"
#
# Build :  docker build -t chef-server:local .
# Run   :  docker run -d --privileged --tmpfs /run --tmpfs /run/lock \
#            -v /sys/fs/cgroup:/sys/fs/cgroup:rw -p 8443:443 chef-server:local
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC
ENV CHEF_LICENSE=accept-no-persist
# locale réellement installée (en_US.UTF-8), pas juste C.UTF-8 : Chef Infra
# Client vérifie `locale -a` et affiche un warning sinon.
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN apt-get update -qq \
    && apt-get install -y -qq \
        systemd systemd-sysv \
        iproute2 \
        tzdata locales \
        cron \
        curl ca-certificates \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* \
    # Désactive les units systemd inutiles/instables en container (udev, swap,
    # getty...) - pattern standard pour faire tourner systemd dans Docker.
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
       /etc/systemd/system/*.wants/* \
       /lib/systemd/system/local-fs.target.wants/* \
       /lib/systemd/system/sockets.target.wants/*udev* \
       /lib/systemd/system/sockets.target.wants/*initctl* \
       /lib/systemd/system/sysinit.target.wants/*udev* \
       /lib/systemd/system/sysinit.target.wants/*swap* \
       /lib/systemd/system/plymouth* /lib/systemd/system/graphical.target

RUN curl -fsSL https://omnitruck.chef.io/install.sh \
    | bash -s -- -P chef-server -c stable

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
