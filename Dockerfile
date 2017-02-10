FROM resin/rpi-raspbian:jessie

# Install needed packages
RUN apt-get update \
    && apt-get install libfuse-dev fonts-freefont-ttf git python-imaging bc i2c-tools make pkg-config gcc -y \
    # Remove package lists to free up space
    && rm -rf /var/lib/apt/lists/*

# Install PaPiRus
RUN mkdir /tmp/papirus \
    && git clone https://github.com/PiSupply/PaPiRus.git /tmp/papirus \
    && cd /tmp/papirus \
    && git checkout 3e768f06dad50a0656e3b58235644dfb801028f0 \
    && python setup.py install \
    && rm -rf /tmp/papirus

# Install the driver
RUN mkdir /tmp/gratis \
    && git clone https://github.com/repaper/gratis.git /tmp/gratis \
    && cd /tmp/gratis/PlatformWithOS \
    && git checkout ab46fd7 \
    && make rpi PANEL_VERSION=V231_G2 \
    && make rpi-install PANEL_VERSION=V231_G2 \
    && rm -rf /tmp/gratis

COPY ./epd-fuse/epd-fuse.configuration /etc/default/epd-fuse
COPY ./run.sh /app/run.sh
COPY ./resinos-logo.jpg /app/resinos-logo.jpg

# Systemd please
ENV INITSYSTEM on

CMD ["bash", "/app/run.sh"]
