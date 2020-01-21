FROM ubuntu:xenial
RUN groupadd -r myuser && useradd -r -g myuser myuser
ENV BASE_DEPS="build-essential cmake git curl"
RUN set -eux -o pipefail && \
    apt-get update && apt-get install -y ${BASE_DEPS}
USER myuser
ENTRYPOINT ["/bin/bash"]
