#!/usr/bin/env bash

echo "=== Health Check: $(hostname) @ $(date) ==="

echo ""
echo "--- Disk Usage ---"
df -h | grep -v tmpfs

echo ""
echo "--- Memory (MB) ---"
free -m

