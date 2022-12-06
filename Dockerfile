FROM golang:1.19

RUN apk add --no-cache ca-certificates git

ENV \
  GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux

WORKDIR /go/src/github.com/rancher/cluster-operator

ADD . .
RUN go build -v -installsuffix cgo -ldflags="-w -s" -o /go/bin/cluster-operator .


FROM alpine:3.16
RUN apk add --no-cache ca-certificates
EXPOSE 9308
ENV PATH='/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENTRYPOINT ["/go/bin/cluster-operator"]
COPY --from=0 /go/bin /go/bin
