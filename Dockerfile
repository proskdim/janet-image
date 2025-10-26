# build janet
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -yqq --no-install-recommends ca-certificates \
    git \
    make \
    gcc \
    libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build/janet

RUN git clone https://github.com/janet-lang/janet.git . \
    && git checkout HEAD \
    && make -j \
    && make test \
    && make install

# build jpm package version
WORKDIR /build/jpm

RUN git clone https://github.com/janet-lang/jpm . \
    && janet bootstrap.janet
    
RUN jpm install spork
RUN jpm install sh

# scratch 
FROM debian:bookworm-slim AS base

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib

WORKDIR /app

CMD ["bash"] 
