FROM golang:1.8.5-alpine3.6 AS build-{NAME}
MAINTAINER  {USER}<{EMAIL}> 

RUN mkdir -p /go/src/{NAME}/build
WORKDIR /go/src/{NAME}
COPY . /go/src/{NAME}/
RUN go list ./...|grep -v vendor|xargs go test
RUN go build -v -o build/{NAME}.bin

FROM alpine:3.6
#EXPOSE 8080 8081
COPY --from=build-{NAME} /go/src/{NAME}/build/{NAME}.bin /usr/local/bin/
ENTRYPOINT ["{NAME}.bin", "", ""]

