FROM golang:1.25

RUN apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY frontend/ .

# ✅ CRITICAL FIX
ENV GOPROXY=direct
ENV GOSUMDB=off

RUN go mod tidy
RUN go build -o app .

EXPOSE 8080
CMD ["./app"]

