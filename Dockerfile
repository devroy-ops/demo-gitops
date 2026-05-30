FROM golang:1.22-alpine3.18

# ✅ Use default repo + retry mechanism
RUN apk update || apk update || apk update \
    && apk add --no-cache git

WORKDIR /app
COPY frontend/ .

ENV GOPROXY=direct
ENV GOSUMDB=off

RUN go mod tidy
RUN go build -o app .

EXPOSE 8080
CMD ["./app"]
