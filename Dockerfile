#FROM golang:alpine AS build
#WORKDIR /app
#COPY go.* ./
#RUN go mod download
#COPY *.go ./
#RUN CGO_ENABLED=0 go build -ldflags='-extldflags=-static' -tags timetzdata -o /meugo ./main.go

#FROM scratch
#COPY --from=build /meugo .
#ENTRYPOINT ./meugo

FROM golang:alpine as builder

WORKDIR /app 

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o release ./main.go

FROM scratch

WORKDIR /app

COPY --from=builder /app/release /usr/bin/

ENTRYPOINT ["/usr/bin/release"]
