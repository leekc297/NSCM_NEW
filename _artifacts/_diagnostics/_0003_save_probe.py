#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 저장 속도 — ⓪ 병목 실측 + 정적 안티패턴 스캔 (hook #129).

⓪ 실측 우선: 최근 저장 실행이 V$SQL / ASH 에 남아 있으면 그것이 가장 강한 근거다.
   (사용자가 방금 저장을 했으므로 커서가 남아 있을 가능성이 높다)
정적 스캔은 **보조**다 — 추정으로 고치지 않기 위해 실측과 함께만 쓴다.
"""
import io, re, sys, pathlib
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

SAVE_PROCS = ['P_DMF0003_SAVE_MKT_FCST', 'P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE',
              'P_DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL', 'P_DMF0003_SAVE_PRPOPUP']

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── ⓪-1 최근 저장 실행 로그 (SP 자체 로그) ────────────────────────────────
print("=== 최근 DMF0003 저장 실행 로그 (24h) ===")
cur.execute("""SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') T, PROGRAM_NAME, LOG_TYPE,
                      SUBSTR(LOG_MESSAGE,1,60), SUBSTR(DESCRIPTION,1,40)
               FROM SCM_SYS_LOG_BATCH
               WHERE PROGRAM_NAME LIKE '%DMF0003%' AND CREATION_DATE > SYSDATE - 1
               ORDER BY CREATION_DATE DESC FETCH FIRST 12 ROWS ONLY""")
rows = cur.fetchall()
for r in rows:
    print(f"   {r[0]}  {str(r[1])[:34]:<36}{str(r[2]):<6}{str(r[3])[:52]}")
if not rows:
    print("   (없음)")

# ── ⓪-2 V$SQL 에 남은 저장 관련 SQL (elapsed 상위) ────────────────────────
print("\n=== V$SQL — DMF0003 저장 경로 SQL (elapsed 상위) ===")
cur.execute("""SELECT SQL_ID, ROUND(ELAPSED_TIME/1e6,1) EL, EXECUTIONS, BUFFER_GETS,
                      ROWS_PROCESSED, SUBSTR(SQL_TEXT,1,70)
               FROM V$SQL
               WHERE (UPPER(SQL_TEXT) LIKE '%DMF0003%'
                   OR UPPER(SQL_TEXT) LIKE '%GT_DMF0003%')
               ORDER BY ELAPSED_TIME DESC FETCH FIRST 12 ROWS ONLY""")
tot = 0
for r in cur.fetchall():
    tot += r[1] or 0
    mark = '★' if (r[1] or 0) >= 2 else ' '
    print(f" {mark} {r[0]}  {r[1]:>8.1f}s  exec={r[2]:<5} gets={r[3]:>12,}  rows={r[4]:>9,}  {r[5][:50]}")

# ── ⓪-3 ASH 귀속 (최근 2시간, DMF0003 SQL) ────────────────────────────────
print("\n=== ASH — 최근 2h, DMF0003 관련 SQL 시간 점유 ===")
cur.execute("""WITH A AS (
                 SELECT a.SQL_ID, NVL(a.EVENT,'ON CPU') EV, COUNT(*) S
                 FROM V$ACTIVE_SESSION_HISTORY a
                 WHERE a.SAMPLE_TIME > SYSDATE - 2/24
                 GROUP BY a.SQL_ID, NVL(a.EVENT,'ON CPU')
               ), T AS (
                 SELECT SQL_ID, MIN(SUBSTR(SQL_TEXT,1,70)) TXT FROM V$SQL
                 WHERE UPPER(SQL_TEXT) LIKE '%DMF0003%' OR UPPER(SQL_TEXT) LIKE '%GT_DMF0003%'
                 GROUP BY SQL_ID
               )
               SELECT A.SQL_ID, A.EV, A.S, T.TXT
               FROM A JOIN T ON T.SQL_ID = A.SQL_ID
               ORDER BY A.S DESC FETCH FIRST 12 ROWS ONLY""")
ash = cur.fetchall()
if ash:
    for r in ash:
        mark = '★' if r[2] >= 2 else ' '
        print(f" {mark} {r[0]}  {r[1][:26]:<28}{r[2]:>5}s  {(r[3] or '')[:46]}")
else:
    print("   (최근 2h ASH 없음 — 저장 실행 후 다시 수집 필요)")

# ── 보조: 정적 안티패턴 ───────────────────────────────────────────────────
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
procs = [(m.start(), m.group(1)) for m in re.finditer(r"PROCEDURE\s+(\w+)", body)]
print("\n=== 보조 — 저장 프로시저 정적 안티패턴 ===")
for i, (pos, nm) in enumerate(procs):
    if nm not in SAVE_PROCS:
        continue
    end = procs[i+1][0] if i+1 < len(procs) else len(body)
    seg = body[pos:end]
    act = [l for l in seg.split("\n") if 'DBMS_STATS' in l.upper() and not l.strip().startswith('--')]
    print(f"\n   [{nm}]  {end-pos:,}자")
    print(f"      DBMS_STATS 활성      : {len(act)}곳   ⛔ SP 내 통계수집 금지(#129)" if act
          else f"      DBMS_STATS 활성      : 0곳")
    n_for  = len(re.findall("FOR[^" + chr(10) + "]{0,80}LOOP", seg, re.I))
    n_fet  = len(re.findall(r"FETCH", seg, re.I))
    n_mrg  = len(re.findall(r"MERGE\s+INTO", seg, re.I))
    n_dml  = len(re.findall(r"(INSERT\s+INTO|UPDATE)", seg, re.I))
    n_cmt  = len(re.findall(r"COMMIT", seg, re.I))
    print(f"      FOR ~ LOOP           : {n_for}")
    print(f"      행별 커서 FETCH      : {n_fet}")
    print(f"      MERGE                : {n_mrg}")
    print(f"      단건 INSERT/UPDATE   : {n_dml}")
    print(f"      COMMIT               : {n_cmt}")
    fx = Counter(m.group(1).upper() for m in re.finditer(r"(UF_[A-Z0-9_]+|FN_[A-Z0-9_]+)\s*\(", seg, re.I))
    if fx:
        print(f"      함수 호출            : {dict(fx.most_common(5))}")
con.close()
