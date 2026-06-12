#!/usr/bin/env python3
"""
SYS0010 4 SAVE procedure 의 'single-row JSON_TABLE' 패턴을 'cursor FOR LOOP' 로 변환.

변환 대상 procedure:
    1) P_SYS0010_SAVE_LOOKUP_MASTER            (149~472)
    2) P_SYS0010_SAVE_LOOKUP_MASTER_HIST       (474~742)
    3) P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL     (744~1082)
    4) P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST(1085~1348)

변환 패턴:
    BEGIN
        SELECT JT.X1, JT.X2, ...                  ←
          INTO V_X1, V_X2, ...                    ←
          FROM JSON_TABLE(P_DATA, '$' COLUMNS(...)) JT;  ← '$' → '$[*]'
        (NVL TRIM 처리)
        (LOG_BATCH/HIST 호출)
        IF V_FLAG='I' THEN INSERT ELSE UPDATE END IF;
        COMMIT;
        (LOG_BATCH END)
        OPEN cursor;
    EXCEPTION ...

변환 후:
    BEGIN
        (LOG_BATCH START — loop 밖)
        FOR JT_REC IN (
          SELECT JT.X1 AS X1, JT.X2 AS X2, ...
            FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(...)) JT
        ) LOOP
            V_X1 := JT_REC.X1;
            V_X2 := JT_REC.X2;
            ...
            (NVL TRIM 처리)
            (per-row HIST 호출 — single-row JSON 만들어 호출)
            IF V_FLAG='I' THEN INSERT ELSE UPDATE END IF;
        END LOOP;
        COMMIT;
        (LOG_BATCH END)
        OPEN cursor;
    EXCEPTION ...
"""
import re
from pathlib import Path

SRC = Path('C:/Projects/NSCM/_artifacts/_apply_corporate/53_sys0010_save_sp_cursor_loop_fix.sql')

content = SRC.read_text(encoding='utf-8')

# 변환 (1): JSON_TABLE path '$' → '$[*]'
# pattern: JSON_TABLE\n      P_DATA\n    , '$'\n      COLUMNS
content = re.sub(
    r"FROM JSON_TABLE\(\s*\n\s*P_DATA\s*\n\s*,\s*'\$'\s*\n",
    "FROM JSON_TABLE(\n          P_DATA\n        , '$[*]'\n",
    content
)

# 변환 (2): SELECT JT.X1 ... INTO V_X1 ... FROM JSON_TABLE → cursor FOR LOOP
# 너무 복잡한 패턴 — 각 procedure 마다 수동 marker 사용.
# Step 2 는 본 script 에서 자동화 안 함. SQL 파일에 marker 만 표시.

SRC.write_text(content, encoding='utf-8')
print(f"step 1 done: JSON path '$' → '$[*]' replaced ({content.count(chr(36) + '[*]')} occurrences)")
print("step 2 (SELECT INTO → cursor LOOP) — manual Edit 작업 필요. 본 script 는 path 만 변환.")
