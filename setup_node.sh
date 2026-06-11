#!/bin/bash
# setup_node.sh — Run this on a new node to set it up as a cluster member.
# Place this script in the root of the blume_stream_activities_ms repo.
#
# What it does:
#   1. Copies docker-compose.yml and .env from extra/ to the parent directory
#   2. Sets TAILSCALE_IP_VM to this node's own Tailscale IP in the .env
#
# Usage: ./setup_node.sh

set -e

# ── Resolve paths ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTRA_DIR="$SCRIPT_DIR/extra"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PARENT_DIR/.env"
COMPOSE_FILE="$PARENT_DIR/docker-compose.yml"

# ── Sanity checks ─────────────────────────────────────────────────────────────
if [ ! -d "$EXTRA_DIR" ]; then
  echo "✗ Could not find extra/ directory at $EXTRA_DIR"
  echo "  Make sure you run this script from inside the blume_stream_activities_ms repo root."
  exit 1
fi

if [ ! -f "$EXTRA_DIR/.env" ] || [ ! -f "$EXTRA_DIR/docker-compose.yml" ]; then
  echo "✗ Missing files in extra/ — expected both .env and docker-compose.yml"
  exit 1
fi

# ── Get this node's Tailscale IP ──────────────────────────────────────────────
# Try to detect it automatically first
detected_ip=$(tailscale ip -4 2>/dev/null || true)

if [ -n "$detected_ip" ]; then
  echo "Detected Tailscale IP: $detected_ip"
  read -rp "Use this IP? [Y/n]: " confirm
  if [[ "$confirm" =~ ^[Nn]$ ]]; then
    detected_ip=""
  fi
fi

if [ -z "$detected_ip" ]; then
  read -rp "Enter this node's Tailscale IP: " detected_ip
  if [ -z "$detected_ip" ]; then
    echo "✗ No IP provided, aborting."
    exit 1
  fi
fi

NODE_IP="$detected_ip"

# ── Copy files from extra/ to parent directory ────────────────────────────────
echo ""
echo "Copying files to $PARENT_DIR ..."

if [ -f "$ENV_FILE" ]; then
  read -rp ".env already exists in $PARENT_DIR, overwrite? [y/N]: " overwrite
  if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
    echo "Skipping .env copy — will patch existing file."
    cp "$EXTRA_DIR/docker-compose.yml" "$COMPOSE_FILE"
    echo "✓ Copied docker-compose.yml"
  else
    cp "$EXTRA_DIR/.env" "$ENV_FILE"
    cp "$EXTRA_DIR/docker-compose.yml" "$COMPOSE_FILE"
    echo "✓ Copied .env"
    echo "✓ Copied docker-compose.yml"
  fi
else
  cp "$EXTRA_DIR/.env" "$ENV_FILE"
  cp "$EXTRA_DIR/docker-compose.yml" "$COMPOSE_FILE"
  echo "✓ Copied .env"
  echo "✓ Copied docker-compose.yml"
fi

# ── Patch TAILSCALE_IP_VM in .env to this node's own IP ──────────────────────
if grep -q "^TAILSCALE_IP_VM=" "$ENV_FILE"; then
  sed -i "s|^TAILSCALE_IP_VM=.*|TAILSCALE_IP_VM=${NODE_IP}|" "$ENV_FILE"
  echo "✓ Set TAILSCALE_IP_VM=${NODE_IP} in .env"
else
  printf "\nTAILSCALE_IP_VM=%s" "$NODE_IP" >> "$ENV_FILE"
  echo "✓ Added TAILSCALE_IP_VM=${NODE_IP} to .env"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "┌─────────────────────────────────────────────────────┐"
echo "│  Node setup complete                                │"
echo "├─────────────────────────────────────────────────────┤"
printf  "│  This node's IP : %-33s│\n" "$NODE_IP"
printf  "│  .env location  : %-33s│\n" "$ENV_FILE"
echo "├─────────────────────────────────────────────────────┤"
echo "│  Next step:                                         │"
echo "│  cd $PARENT_DIR"
echo "│  docker compose up --build -d blume_stream_activities_ms"
echo "└─────────────────────────────────────────────────────┘"