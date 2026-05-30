#!/bin/bash
set -e
cd /tmp/csv
count=0
for f in *.csv; do
  tr -d '\r' < "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
  count=$((count + 1))
done
echo "stripped CR from $count CSV files"
tail -c 20 /tmp/csv/SCM_ADM_USER_M_202605261612.csv | od -c | tail -2
