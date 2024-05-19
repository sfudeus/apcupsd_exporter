ARG GO_VERSION=1.22
FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION} AS builder
ARG TARGETARCH
ARG TARGETOS

WORKDIR /build
ADD . /build

ENV CGO_ENABLED=0
RUN go get -u
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /build/apcupsd_exporter /build/cmd/apcupsd_exporter/main.go
#RUN go install github.com/mdlayher/apcupsd_exporter@main
#RUN go build -o /build/apcupsd_exporter $GOPATH/src/github.com/mdlayher/apcupsd_exporter/cmd/apcupsd_exporter/main.go

FROM scratch
COPY --from=builder /build/apcupsd_exporter /apcupsd_exporter
LABEL maintainer="Stephan Fudeus <github@mails.fudeus.net>"

ENTRYPOINT ["/apcupsd_exporter"]
EXPOSE 9162
