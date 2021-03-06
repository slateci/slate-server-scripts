# syntax=docker/dockerfile:1

# Docker image build arguments:
ARG baseimage=centos:7

#######################################
## Local Stage                        #
#######################################
FROM ${baseimage} as local-stage

ARG kubectlversion=1.18.2

# Set up custom yum repos:
COPY ./resources/docker/yum.repos.d/kubernetes.repo /etc/yum.repos.d/kubernetes.repo

RUN echo "$baseimage" > output1.txt
RUN echo "$kubectlversion" > output2.txt

# Package installs/updates:
RUN yum install epel-release -y
RUN yum install bind-utils \
    jq \
    kubectl-$kubectlversion \
    less \
    net-tools \
    openssh-clients \
    openssl \
    python-jsonpointer \
    s3cmd \
    unzip \
    python3 \
    python36-requests \
    which -y
RUN yum clean all && rm -rf /var/cache/yum

# Change working directory:
WORKDIR /tmp

# Install AWS CLI
RUN curl -LO https://raw.githubusercontent.com/slateci/docker-images/stable/slate-client-server/scripts/install-aws-cli.sh
RUN chmod +x ./install-aws-cli.sh && \
    ./install-aws-cli.sh && \
    rm ./install-aws-cli.sh

# Make root slate directory:
RUN mkdir /slate

# Change working directory:
WORKDIR /

# Run once the container has started:
ENTRYPOINT [ "/bin/bash" ]

#######################################
## Release Stage                      #
#######################################
FROM local-stage as release-stage

# Change working directory:
WORKDIR /slate

# Copy in all scripts:
COPY ./scripts ./scripts
RUN chmod +x ./scripts/*.sh

# Change working directory:
WORKDIR /
