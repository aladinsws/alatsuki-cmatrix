# Build Container image
FROM alpine as cmatrixbuilder

WORKDIR cmatrix

RUN apk update --no-cache && \
    apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
    git clone https://github.com/aladinsws/cmatrix.git . && \
    autoreconf -i && \
    mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
    ./configure LDFLAGS="-static" && \
    make

#cmatrix Container image
FROM alpine

LABEL org.opencontainers.image.authors="Aladinsws" \ 
      org.opencontainers.image.description="Container image for https://github.com/aladinsws/cmatrix"

RUN apk update --no-cache && \
    apk add ncurses-terminfo-base && \
    adduser -g "ala" -s /usr/sbin/nologin -D -H ala
COPY --from=cmatrixbuilder  /cmatrix/cmatrix /cmatrix

USER ala

ENTRYPOINT ["./cmatrix"]

CMD ["-b"]

