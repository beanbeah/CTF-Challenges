FROM ubuntu:20.04 AS src

FROM pwn.red/jail

ENV JAIL_TIME 200

COPY --from=src /bin/ls /srv/bin/ls
COPY --from=src /bin/cat /srv/bin/cat
COPY --from=src /bin/sh /srv/bin/sh

COPY --from=src /lib/ /srv/lib/
COPY --from=src /lib64/ /srv/lib64/

COPY ./src /srv/app/run
COPY ./flag.txt /srv/app/flag.txt
RUN chmod +x /srv/app/run
