# build temporary image
FROM --platform=$BUILDPLATFORM gcc:11.2.0 as builder

RUN apt update -yqq && \
    apt install -yqq gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

WORKDIR /build
COPY ./compile ./
COPY ./ascii.c ./

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN ./compile ascii.c -static -o ascii

# final image
FROM scratch

COPY --from=builder /build/ascii /usr/bin/ascii

ENTRYPOINT ["/usr/bin/ascii"]
