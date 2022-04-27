# syntax=docker/dockerfile:1

# Docker image build arguments:
ARG baseimage=centos:7

#######################################
## Local Stage                        #
#######################################
FROM ${baseimage} as local-stage

# Package installs/updates:
RUN yum install epel-release -y
RUN yum install bind-utils \
    less \
    net-tools \
    openssh-clients \
    python-jsonpointer \
    s3cmd \
    unzip \
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
FROM ${baseimage} as release-stage

# Package installs/updates:
RUN yum install epel-release -y
RUN yum install bind-utils \
    less \
    net-tools \
    openssh-clients \
    python-jsonpointer \
    s3cmd \
    unzip \
    which -y
RUN yum clean all && rm -rf /var/cache/yum

# Change working directory:
WORKDIR /usr/local/bin

# Install AWS CLI
COPY --from=local-stage /usr/local/aws-cli /usr/local/aws-cli
RUN ln -s /usr/local/aws-cli/v2/current/bin/aws aws && \
    ln -s /usr/local/aws-cli/v2/current/bin/aws_completer aws_completer

# Change working directory:
WORKDIR /slate

# Copy in all scripts:
COPY ./scripts ./scripts
RUN chmod +x ./scripts/*.sh

# Change working directory:
WORKDIR /
