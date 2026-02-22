#!/bin/bash
# Starter script for ComfyUI in Lightning Studio
# Lightning AI typically forwards port 8080 or port 8188 securely to the web.

cd "$(dirname "$0")/ComfyUI" || exit 1

# Make sure we don't try to use an isolated venv accidentally if one slipped in
unset VIRTUAL_ENV

# Launch ComfyUI
# You can view it using the Studio's Web URL forwarder for port 8188
echo "🚀 Starting ComfyUI on Port 8188..."
echo "🌐 Use the Lightning 'Port' app in your Studio UI to map port 8188."

python main.py --listen 0.0.0.0 --port 8188 --use-sage-attention
