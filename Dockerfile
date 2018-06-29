FROM alpine

MAINTAINER Daniel Lundborg <daniel.lundborg@gmail.com>

RUN apk add --update \
    python \
    python-dev \
    musl-dev \
    py-pip \
    ca-certificates \
    gcc \
    xz-dev \
    bash \
    file \
    openssh-client \
    shadow \
    git \
    make \
    && rm -rf /var/cache/apk/*

COPY certs/*.* /usr/local/share/ca-certificates/

RUN update-ca-certificates

RUN pip install --upgrade pip

# Make an empty directory where we will mount the host directory
RUN \
    mkdir /test && \
    adduser -D -u 1000 docker && \
    chown -hR docker /test

# Make sure the logs are put in the correct place
RUN mkdir -p /etc/avocado/conf.d
COPY logs_dir.conf /etc/avocado/conf.d/

# Install avocado framework and the html plugin
RUN \
    git clone git://github.com/avocado-framework/avocado.git && \
    cd avocado && \
    git checkout tags/56.0 && \
    make requirements && \
    python setup.py install && \
    cd optional_plugins/html && \
    python setup.py install

# Install ssh keys and change permissions on the files
COPY .ssh/* /home/docker/.ssh/
RUN \
    chown -hR docker /home/docker/.ssh && \
    chmod 700 /home/docker/.ssh && \
    chmod 600 /home/docker/.ssh/id_rsa && \
    chmod 644 /home/docker/.ssh/id_rsa.pub && \
    chmod 644 /home/docker/.ssh/known_hosts && \
    chmod 600 /home/docker/.ssh/id_rsa.pi && \
    chmod 600 /home/docker/.ssh/config


# Set current working directory
WORKDIR /test

# Run the start-script
ADD docker_entry.sh /usr/local/bin/docker_entry.sh
RUN chmod 755 /usr/local/bin/docker_entry.sh

ENTRYPOINT ["docker_entry.sh"]

