FROM golang:alpine

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o app .

EXPOSE 7070

CMD ["./app"]
