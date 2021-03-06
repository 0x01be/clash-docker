FROM 0x01be/haskell as builder

RUN apk add --no-cache --virtual clash-build-dependencies \
    git

RUN git clone --depth 1 https://github.com/clash-lang/clash-compiler /clash

WORKDIR /clash

RUN stack --resolver nightly-2020-08-10 --system-ghc install

FROM alpine

ENV GHC_VERSION 8.10.1

COPY --from=builder /opt/ghc/ /opt/ghc/
COPY --from=builder /opt/cabal/ /opt/cabal/
COPY --from=builder /root/.local/bin/ /opt/clash/bin/
COPY --from=builder /root/ /root/

RUN apk add --no-cache --virtual clash-runtime-dependencies \
    gmp \
    ncurses

ENV PATH $PATH:/opt/ghc/bin/:/opt/cabal/bin/:/opt/clash/bin/

RUN ln -s /opt/ghc/bin/ghc /opt/ghc/bin/ghc-$GHC_VERSION

VOLUME /workspace
WORKDIR /workspace

