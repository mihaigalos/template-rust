FROM rust:alpine3.17 as base
RUN apk update \
    && apk add \
        git \
        gcc \
        g++ \
        openssl \
        openssl-dev \
        pkgconfig

COPY . /src

RUN rustup update 1.69 && rustup default 1.69

RUN cd /src \
    && sed -i -e "s/openssl.*=.*//" Cargo.toml \
    && RUSTFLAGS="-C target-feature=-crt-static" cargo build --release

FROM alpine:3.18 as tool

RUN apk update && apk add libgcc

COPY --from=base /src/target/release/{{project-name}} /usr/local/bin

ENTRYPOINT [ "{{project-name}}" ]
CMD [ "--help" ]
