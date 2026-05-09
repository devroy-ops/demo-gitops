FROM golang:alpine

WORKDIR /app

COPY frontend/ .

RUN go mod tidy
 app .

EXPOSE 8080

CMD ["./app"]









#FROM golang:alpine

#EXPOSE 8080

#CMD ["./frontend"]

#WORKDIR /app

#COPY frontend/ .

#RUN go mod tidy

