FROM 0x01be/haskell as builder

RUN apk add --no-cache --virtual clash-build-dependencies \
    git \
    ncurses-dev

RUN git clone --depth 1 https://github.com/clash-lang/clash-compiler /clash

WORKDIR /clash

RUN stack --resolver nightly-2020-08-02 --system-ghc build clash-ghc
RUN stack --resolver nightly-2020-08-02 --system-ghc install

FROM 0x01be/alpine:edge

COPY --from=builder /root/.local/bin/ /opt/clash/bin/

RUN apk add --no-cache --virtual clash-runtime-dependencies \
    gmp

ENV PATH $PATH:/opt/clash/bin/

