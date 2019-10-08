FROM jdlk7/golang

ENV GOPATH=/go
COPY . /app
VOLUME [ "./vendor:${GOPATH}/src" ]
WORKDIR /app

RUN ./build.sh

CMD [ "cgr-engine" ]
