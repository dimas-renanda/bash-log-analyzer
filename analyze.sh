#!/usr/bin/env bash
# analyze.sh — summarize nginx/apache access logs
LOG="${1:-}"
[[ -z "$LOG" ]] && echo "Usage: analyze.sh <logfile>" && exit 1
[[ ! -f "$LOG" ]] && echo "File not found: $LOG" && exit 1

echo "=== Log Analysis: $LOG ==="
echo "Total requests: $(wc -l < "$LOG")"
echo ""

echo "── Top 10 IPs ──────────────────────"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -10 | awk '{printf "  %6d  %s\n",$1,$2}'

echo ""
echo "── Status Codes ────────────────────"
awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn | awk '{printf "  %6d  %s\n",$1,$2}'

echo ""
echo "── Top 10 URLs ─────────────────────"
awk '{print $7}' "$LOG" | sort | uniq -c | sort -rn | head -10 | awk '{printf "  %6d  %s\n",$1,$2}'

echo ""
echo "── Top 5 User Agents ───────────────"
awk -F'"' '{print $6}' "$LOG" | sort | uniq -c | sort -rn | head -5 | awk '{printf "  %6d  %s\n",$1,substr($0,index($0,$2))}'
