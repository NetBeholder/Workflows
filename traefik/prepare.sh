#!/bin/bash

[ ! -f .env ] && cp .env.default .env

touch data/acme.json
chmod 600 data/acme.json
