#!/bin/bash
# Creates branding.jar (a zip) from branding files
cd "$(dirname "$0")"
rm -f branding.jar
zip -j branding.jar guac-manifest.json branding.json
echo "branding.jar created"
