FROM alpine:3.19

RUN apk add --no-cache git bash openssh \
    && wget -P / https://raw.githubusercontent.com/programic/bash-common/main/common.sh

COPY pipe /

RUN chmod a+x /*.sh

ENTRYPOINT ["/pipe.sh"]