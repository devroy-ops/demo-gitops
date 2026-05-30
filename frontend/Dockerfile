FROM golang:1.25

WORKDIR /app
COPY frontend/ .

RUN go build -mod=vendor -o app .

EXPOSE 8080
CMD ["./app"]
