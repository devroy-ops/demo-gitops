FROM golang:1.23-alpine build -o frontend .

EXPOSE 8080

CMD ["./frontend"]

WORKDIR /app

COPY frontend/ .

RUN go mod tidy

