FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copia somente os arquivos de dependência inicialmente
COPY go.mod go.sum ./
RUN go mod download

# Copia o restante do projeto
COPY . .

# Compila a aplicação
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Etapa final - imagem leve
FROM alpine:latest

WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 8080
ENTRYPOINT ["./main"]
