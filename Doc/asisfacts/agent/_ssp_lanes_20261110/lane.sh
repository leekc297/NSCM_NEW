#!/bin/bash
# usage: lane.sh <laneName> <ids...>
L=$1; shift
cd /c/Projects/NSCM/tools/AsisFacts
LOG=/c/Projects/NSCM/Doc/asisfacts/agent/_ssp_lanes_20261110/lane_$L.log
for id in "$@"; do
  echo "$(date '+%F %T') START $id" >> $LOG
  dotnet _bin/AsisFacts.dll agent $id --driver claude-cli --model claude-opus-5-5 --phase all --config asisfacts.json >> $LOG 2>&1
  rc=$?
  echo "$(date '+%F %T') AGENT_RC $id $rc" >> $LOG
  if [ $rc -eq 0 ]; then python ../Docs/md2xlsx.py $id >> $LOG 2>&1; echo "$(date '+%F %T') MD2XLSX_RC $id $?" >> $LOG; fi
done
echo "$(date '+%F %T') LANE_DONE $L" >> $LOG
