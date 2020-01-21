FROM alpine:latest
RUN groupadd -r myuser && useradd -r -g myuser myuser
ENV BASE_DEPS git curl tar
RUN set -eux -o pipefail && \
    apk update && apk add $BASE_DEPS
USER myuser
ENTRYPOINT ["/bin/bash"]
