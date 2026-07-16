#!/bin/bash
cd "$(dirname "$0")"
rm -f branding.jar
zip -r branding.jar guac-manifest.json translations/ css/
cp branding.jar ../guacamole-home/extensions/branding.jar
echo "branding.jar created and copied to guacamole-home/extensions/"
