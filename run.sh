#!/bin/bash

# Make sure i2c is loaded
modprobe i2c-dev

# Start the fuse driver
systemctl start epd-fuse.service

# Draw nice logo
papirus-draw /app/resinos-logo.jpg
