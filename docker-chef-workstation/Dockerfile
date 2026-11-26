# Build :   docker build -t chef-tooling:local .
# Usage :   docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
#             -v "$(pwd)/code:/workdir" -w /workdir chef-tooling:local bash
FROM ubuntu:22.04

ARG CHEF_WORKSTATION_VERSION=25.14.2

RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends curl ca-certificates docker.io rsync openssh-client locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

RUN curl -fsSL https://omnitruck.chef.io/install.sh \
    | bash -s -- -P chef-workstation -v "${CHEF_WORKSTATION_VERSION}"


ENV CHEF_LICENSE=accept-no-persist
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN chef gem install kitchen-dokken

WORKDIR /workdir
CMD ["bash"]
