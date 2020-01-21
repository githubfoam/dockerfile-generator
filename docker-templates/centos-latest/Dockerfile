FROM centos:latest
RUN groupadd -r myuser && useradd -r -g myuser myuser
ENV BASE_DEPS gcc cmake make git curl tar
RUN set -eux -o pipefail && \
    yum update && yum install -y $BASE_DEPS
USER myuser
ENTRYPOINT ["/bin/bash"]
