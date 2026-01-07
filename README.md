# Rotating Tor Proxy

This project provides an array of Tor daemons that are load balanced
through an HAProxy server. By default, it sets up 20 Tor daemons. It
is forked from an upstream project and updated to more recent versions
of Ubuntu and Tor.

## Build

```
$ git clone https://github.com/teamhg-memex/docker-tor-rotator.git
$ cd docker-tor-rotator
$ docker build -t tor-rotator .
```

## Run

Here's an example of running the container:

```
$ docker run --rm --name TorRotator -p 8000:8000 -p 9050:9050 tor-rotator
Starting Tor instance 1 on port=9051
Oct 29 20:06:54.948 [notice] Tor 0.3.2.10 (git-0edaa32732ec8930) running on Linux with Libevent 2.1.8-stable, OpenSSL 1.1.1, Zlib 1.2.11, Liblzma 5.2.2, and Libzstd 1.3.3.
Oct 29 20:06:54.948 [notice] Tor can't help you if you use it wrong! Learn how to be safe at https://www.torproject.org/download/download#warning
Oct 29 20:06:54.948 [notice] Read configuration file "/etc/tor/torrc".
Oct 29 20:06:54.952 [notice] Scheduler type KIST has been enabled.
Oct 29 20:06:54.953 [notice] Opening Socks listener on 127.0.0.1:9051
Oct 29 20:06:54.953 [warn] Fixing permissions on directory /var/db/tor/1
Starting Tor instance 2 on port=9052
...
=== Starting HAProxy ===
```

The container pauses for 10 seconds after starting each Tor daemon in order to
let it start bootstrapping, then after all Tor instances it starts HAProxy. This
does mean that the container takes quite some time to start up! You should wait
until you see "Starting HAProxy" before using the system.

Test the system by running a few curl commands:

```
$ curl --socks5 127.0.0.1:9050 wtfismyip.com/text
178.17.171.197
$ curl --socks5 127.0.0.1:9050 wtfismyip.com/text
104.244.72.115
$ curl --socks5 127.0.0.1:9050 wtfismyip.com/text
199.249.230.72
```

If these tests don't work right away, it is possible that your Tor instances
are still bootstrapping. Try waiting a few minutes and then trying again.

You can also view the HAProxy status page by going to `http://localhost:8000`.

# Customizing the number of Tor instances

The Docker build is a parameterized so that you can customize the number of Tor
instances that are configured. For example, to build an image with only 3 Tor
instances, set the following build argument:

```
$ docker build -t tor-rotator --build-arg TOR_COUNT=3 .
```

The resulting image can be run the same way as the default image.

<a href="https://www.hyperiongray.com/?pk_campaign=github&pk_kwd=docker-tor-rotator"><img alt="define hyperion gray" width="500px" src="https://hyperiongray.s3.amazonaws.com/define-hg.svg"></a>
