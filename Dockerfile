FROM malice/alpine:tini

MAINTAINER blacktop, https://github.com/blacktop

COPY . /go/src/github.com/maliceio/malice-shadow-server
RUN apk-install ca-certificates
RUN apk-install -t build-deps go git mercurial build-base \
  && set -x \
  && echo "Building info Go binary..." \
  && cd /go/src/github.com/maliceio/malice-shadow-server \
  && export GOPATH=/go \
  && go version \
  && go get \
  && go build -ldflags "-X main.Version=$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" -o /bin/shadow-server \
  && rm -rf /go \
  && apk del --purge build-deps

WORKDIR /malware

ENTRYPOINT ["gosu","malice","/sbin/tini","--","shadow-server"]

CMD ["--help"]
