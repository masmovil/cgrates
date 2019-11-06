FROM golang:1.13.1
COPY . /app
WORKDIR /app
RUN go build -ldflags  "-w -s -X 'github.com/cgrates/cgrates/utils.GitLastLog=${GIT_LAST_LOG}'" -o cgr-engine github.com/cgrates/cgrates/cmd/cgr-engine

FROM frolvlad/alpine-glibc
RUN apk --no-cache add ca-certificates jq
COPY --from=0 /app/cgr-engine /app/cgr-engine
COPY k8s-entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD [ "/app/cgr-engine" ]
