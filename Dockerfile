FROM golang:alpine

# ✅ Install git (THIS FIXES YOUR ERROR)
RUN apk add --no-cache git

WORKDIR /app
COPY frontend/ .

# ✅ Network-safe config
ENV GOPROXY=direct
ENV GOSUMDB=off

RUN go mod tidy
RUN go build -o app .

EXPOSE 8080
CMD ["./app"]
