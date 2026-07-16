#!/bin/bash
cd "$(dirname "$0")"
rm -f branding.jar
zip -r branding.jar guac-manifest.json translations/
echo "branding.jar created"
