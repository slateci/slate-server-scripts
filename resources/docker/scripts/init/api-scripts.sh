#!/bin/bash

# Enable strict mode:
set -euo pipefail

echo "Copying clean slate.conf..."
cp -f /resources/docker/conf/slate.conf /slate/slate.conf

/bin/bash