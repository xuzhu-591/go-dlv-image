FROM golang:1.20.2-alpine3.17

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk update && \
  apk add vim gcc make libc-dev musl-dev bash curl git && \
  apk add tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone

RUN go env -w GO111MODULE=on && \
  go install github.com/go-delve/delve/cmd/dlv@latest

ARG GROUP=horizon
ARG USER=appops
ARG GROUP_ID=10001
ARG USER_ID=10001

RUN addgroup --gid $GROUP_ID $GROUP && \
  adduser -h /home/$USER -u $USER_ID -G $GROUP -D $USER

RUN echo "hosts: files dns" > /etc/nsswitch.conf

RUN chmod -R 777 /go

USER $USER

RUN go env -w GOPROXY=https://goproxy.cn,direct

CMD ["/bin/bash"]
