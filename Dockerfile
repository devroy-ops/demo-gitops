FROM golang:1.22-alpine3.18

# ✅ Only change mirror (no DNS override)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.edge.kernel.org/' /etc/apk/repositories \
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
