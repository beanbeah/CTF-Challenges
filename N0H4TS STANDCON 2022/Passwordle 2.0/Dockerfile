FROM ubuntu:18.04 AS src

RUN apt-get update
RUN apt-get install -y --no-install-recommends libgmp-dev libgmp10

FROM redpwn/jail:v0.0.1

ENV JAIL_TIME 60

# Include the bare bones of /bin from `ubuntu` (ls, cat, sh)
COPY --from=src /bin/ls /srv/bin/ls
COPY --from=src /bin/cat /srv/bin/cat
COPY --from=src /bin/sh /srv/bin/sh

# Copy the minumum required shared libraries for your binaries. Run `ldd <binary>` to find these.
# The below lines will copy libc.so.6 and ld.so from src, and are usually sufficient
COPY --from=src /lib/ /srv/lib/
COPY --from=src /usr/lib/x86_64-linux-gnu/ /srv/lib/
COPY --from=src /lib64/ /srv/lib64/

# Copy over challenge files. Substitute ${BINARY} with the path to your binary
COPY ./passwordleV2Source /srv/app/run
COPY ./flag.txt /srv/app/flag.txt
