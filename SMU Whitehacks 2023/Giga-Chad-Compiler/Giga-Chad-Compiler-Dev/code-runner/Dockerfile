#build with -t code-runner  
FROM alpine:3.17
#grab GCC and standard headers
RUN set -ex && \
    apk add --no-cache gcc musl-dev libcap
#remove objective-c, LTO, java frontend gcj
RUN set -ex && \
    rm -f /usr/libexec/gcc/x86_64-alpine-linux-musl/6.4.0/cc1obj && \
    rm -f /usr/libexec/gcc/x86_64-alpine-linux-musl/6.4.0/lto1 && \
    rm -f /usr/libexec/gcc/x86_64-alpine-linux-musl/6.4.0/lto-wrapper && \
    rm -f /usr/bin/x86_64-alpine-linux-musl-gcj
#copy script
COPY build_run.sh /
#execute script
CMD ["sh", "/build_run.sh"]
