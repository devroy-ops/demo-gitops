FROM golang:alpine

# ✅ FIX: force working DNS + mirror + retry-safe install
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.edge.kernel.org/' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache git

WORKDIR /app
COPY frontend/ .

ENV GOPROXY=direct
ENV GOSUMDB=off

RUN go mod tidy
RUN go build -o app .

EXPOSE 8080
CMD ["./app"]
