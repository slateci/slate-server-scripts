# syntax=docker/dockerfile:1
FROM centos:7

# Package installs/updates:
RUN yum install epel-release -y
RUN yum less \
    python-jsonpointer \
    s3cmd \
    which -y
RUN yum clean all && rm -rf /var/cache/yum

# Change working directory:
WORKDIR /tmp

# Install AWS CLI
RUN curl -LO https://raw.githubusercontent.com/slateci/docker-images/stable/slate-client-server/scripts/install-aws-cli.sh
RUN chmod +x ./install-aws-cli.sh && \
    ./install-aws-cli.sh && \
    rm ./install-aws-cli.sh

# Change working directory:
WORKDIR /slate

# Copy in all scripts:
COPY ./scripts .
RUN chmod +x ./scripts/*.sh
