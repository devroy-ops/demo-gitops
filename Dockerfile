FROM golang:1.21-alpine

WORKDIR /app

COPY frontend/ .

RUN go mod tidy
RUN go build -o frontend .

EXPOSE 8080

CMD ["./frontend"]
