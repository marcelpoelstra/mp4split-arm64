ARG ARCH=arm64v8

FROM ${ARCH}/ubuntu:focal

# ARGs declared before FROM are in a different scope, so need to be stated again
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG DEBIAN_FRONTEND=noninteractive
# Unified Streaming version
ARG VERSION=1.11.10

RUN apt update && apt-get install -y wget gnupg2

# Get USP public key
RUN wget https://beta.apt.unified-streaming.com/unifiedstreaming.pub && \
    apt-key add unifiedstreaming.pub && \
    sh -c 'echo "deb [arch=arm64] https://beta.apt.unified-streaming.com focal-ports multiverse" > /etc/apt/sources.list.d/unified-streaming-arm64.list' 

# Install mp4split
RUN apt-get update \
&& apt-get -y install \
    "mp4split=${VERSION}" \
&&  apt-get -y autoremove \
&&  apt-get clean
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["--help"]
