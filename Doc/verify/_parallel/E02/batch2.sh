#!/usr/bin/env bash
# 변이 입증 2차. 실행 중 이 파일·run.sh 수정 금지
R=/c/Projects/NSCM/Doc/verify/_parallel/E02/run.sh
stop() { local rc=$1; if [ "$rc" = 90 ]; then echo "[BATCH] 부하 중지"; exit 90; fi; }
EG_GROUPS=GRID bash "$R" DMF0005 N1 0 MAIN "" | tail -2; stop ${PIPESTATUS[0]}
EG_GROUPS=NONE bash "$R" DMF0005 N2 0 MAIN "nocorner,nocount,topline,titlewrong" | tail -2; stop ${PIPESTATUS[0]}
EG_GROUPS=GRID bash "$R" DMF0005 N3 0 MAIN "sortoff,editable" | tail -2; stop ${PIPESTATUS[0]}
EG_GROUPS=FILTER bash "$R" DMF0005 N4 0 MAIN "casesens,commaoff" | tail -2; stop ${PIPESTATUS[0]}
bash "$R" DMF0005 N5 3 PICK "" | tail -2; stop ${PIPESTATUS[0]}
bash "$R" DMF0005 N6 3 PICK "multisel" | tail -2; stop ${PIPESTATUS[0]}
bash "$R" DMF0005 N7 3 CELL "" | tail -2; stop ${PIPESTATUS[0]}
echo BATCH2_END
