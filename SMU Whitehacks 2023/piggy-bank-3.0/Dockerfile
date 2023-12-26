FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
        && apt-get install -y xinetd libgmp-dev libgmp10 \
        && rm -rf /var/lib/apt/lists/*

RUN echo "$user     hard    nproc       20" >> /etc/security/limits.conf
RUN adduser --disabled-password haskell

COPY service /etc/xinetd.d/
COPY flag.txt src /

RUN chmod 755 /src && \
    chmod 744 /flag.txt

USER haskell
EXPOSE 8003
CMD ["/usr/sbin/xinetd", "-dontfork"]
