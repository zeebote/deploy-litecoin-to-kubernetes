FROM ubuntu:20.04
ENV LITECOIN_VERSION=0.18.1 USERNAME=litecoin PUID=1000 PGID=1000
ARG DISABLE_WALLET
ARG MAX_CONNECTIONS 
ARG TESTNET
ARG RPC_SERVER
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates wget gpg gpg-agent dirmngr python3-pip python3-minimal \
    && wget https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && wget https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz.asc \
    && gpg --keyserver pgp.mit.edu --recv-key FE3348877809386C \
    && gpg --verify litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz.asc \
    && tar xfz /litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && mv litecoin-${LITECOIN_VERSION}/bin/* /usr/local/bin/ \
    && rm -rf litecoin-* /root/.gnupg/ \
    && apt-get remove --purge -y \
       ca-certificates wget gpg gpg-agent dirmngr \
    && apt-get autoremove --purge -y \
    && rm -r /var/lib/apt/lists/* \
    && groupadd -g ${PGID} ${USERNAME} \
    && useradd -u ${PUID} -g ${USERNAME} -d /data/${USERNAME} ${USERNAME} \
    && mkdir -p /data/${USERNAME} \
    && chown -R ${USERNAME}:${USERNAME} /data/${USERNAME}

VOLUME ["/data/${USERNAME}"]

EXPOSE 9333

COPY ["bin", "/usr/local/bin/"]

USER ${USERNAME}
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["litecoin"]
