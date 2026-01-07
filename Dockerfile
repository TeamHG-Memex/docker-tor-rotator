FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y dumb-init haproxy tor

ADD ./haproxy.conf /etc/default/haproxy.conf

ARG TOR_COUNT
ENV TOR_COUNT ${TOR_COUNT:-20}
RUN for i in $(seq 1 $TOR_COUNT); do \
        port=$((9050 + $i)); \
        mkdir -p /var/db/tor/$i; \
        echo "  server 127.0.0.1:$port 127.0.0.1:$port check" >> /etc/default/haproxy.conf; \
    done

RUN mkdir /var/run/tor
ADD start.sh /
RUN chmod +x /start.sh

STOPSIGNAL SIGUSR1
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "start.sh"]
