FROM golang:alpine as builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

ENV REPOSITORY github.com/MaineK00n/go-kev
COPY . $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install


FROM alpine:3.14

ENV LOGDIR /var/log/go-kev
ENV WORKDIR /go-kev

RUN apk add --no-cache ca-certificates git \
    && mkdir -p $WORKDIR $LOGDIR

COPY --from=builder /go/bin/go-kev /usr/local/bin/

VOLUME ["$WORKDIR", "$LOGDIR"]
WORKDIR $WORKDIR
ENV PWD $WORKDIR

ENTRYPOINT ["go-kev"]
CMD ["help"]