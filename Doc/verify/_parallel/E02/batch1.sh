#!/usr/bin/env bash
# 변이 입증 1차 — DMF0005 #0·#1. 실행 중 이 파일·run.sh 수정 금지
R=/c/Projects/NSCM/Doc/verify/_parallel/E02/run.sh
stop() { local rc=$1; if [ "$rc" = 90 ]; then echo "[BATCH] 부하 중지"; exit 90; fi; }
EG_GROUPS=NONE bash "$R" DMF0005 M1 0 MAIN "title_,btnorder,nocorner,nocount,topline" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=NONE bash "$R" DMF0005 M2 1 MAIN "reverse" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=FILTER bash "$R" DMF0005 M3 0 MAIN "nofilter" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=NONE bash "$R" DMF0005 M4 0 MAIN "http500" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=NONE bash "$R" DMF0005 M5 0 MAIN "nopermission" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=LAYOUT bash "$R" DMF0005 M6 0 MAIN "overflow,bodyscroll" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=GRID bash "$R" DMF0005 M7 0 MAIN "sortoff" | tail -3; stop ${PIPESTATUS[0]}
EG_GROUPS=NONE bash "$R" DMF0005 M8 0 MAIN "undisable" | tail -3; stop ${PIPESTATUS[0]}
bash "$R" DMF0005 M9 3 PICK "multisel" | tail -3; stop ${PIPESTATUS[0]}
