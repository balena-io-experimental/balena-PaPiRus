FROM resin/rpi-raspbian:jessie

# Install needed packages
RUN apt-get update \
    && apt-get install libfuse-dev fonts-freefont-ttf git python-imaging bc i2c-tools make pkg-config gcc python-smbus python-dateutil -y \
    # Remove package lists to free up space
    && rm -rf /var/lib/apt/lists/*

# Install PaPiRus
RUN mkdir /tmp/papirus \
    && git clone https://github.com/PiSupply/PaPiRus.git /tmp/papirus \
    && cd /tmp/papirus \
    && git checkout dc942764e4694b8f91b65f74d81f9a2fe85a7521 \
    && python setup.py install \
    && rm -rf /tmp/papirus

# Install the driver
RUN mkdir /tmp/gratis \
    && git clone https://github.com/repaper/gratis.git /tmp/gratis \
    && cd /tmp/gratis \
    && git checkout 27f245ed4a4ff391b721a0a30c7f952b2266a690 \
    && make rpi EPD_IO=epd_io.h PANEL_VERSION='V231_G2' \
    && make rpi-install EPD_IO=epd_io.h PANEL_VERSION='V231_G2' \
    && rm -rf /tmp/gratis

COPY ./epd-fuse/epd-fuse.configuration /etc/default/epd-fuse
COPY ./run.sh /app/run.sh
COPY ./resinos-logo.jpg /app/resinos-logo.jpg

# Systemd please
ENV INITSYSTEM on

CMD ["bash", "/app/run.sh"]
