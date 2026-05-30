FROM golang:alpine

RUN apk add --no-cache git

WORKDIR /app

COPY frontend/ .

# ✅ Copy vendored dependencies
COPY frontend/vendor ./vendor

# ✅ Use vendor instead of internet
RUN go build -mod=vendor -o app .

EXPOSE 8080
CMD ["./app"]
