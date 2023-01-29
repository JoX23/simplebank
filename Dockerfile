# Build stage
FROM golang:1.19-alpine3.16 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN mkdir /migrate/
RUN cd /migrate/
WORKDIR /migrate
RUN apk add curl
RUN apk add tar
RUN wget https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz
RUN tar -xvzf migrate.linux-amd64.tar.gz -C /migrate
RUN mv migrate /app/migrate
RUN chmod +x /app/migrate

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/main /app
COPY --from=builder /app/migrate /app/migrate
COPY app.env /app
COPY start.sh /app
COPY wait-for.sh /app
COPY db/migration /app/db/migration

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]