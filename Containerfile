FROM docker.io/golang:1.20 as builder

WORKDIR /src

COPY . .
	
RUN GOARCH=wasm GOOS=js go build -o docs/web/app.wasm ./bin/lofimusic && \ 
    go build -o docs/lofimusic ./bin/lofimusic && \
    cd docs && ./lofimusic github && cd .. \
    go clean ./... && rm docs/lofimusic

FROM nginx:latest

COPY --from=builder /src/docs/. /usr/share/nginx/html/
