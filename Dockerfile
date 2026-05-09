FROM golang:alpine

EXPOSE 8080

CMD ["./frontend"]

WORKDIR /app

COPY frontend/ .

RUN go mod tidy

