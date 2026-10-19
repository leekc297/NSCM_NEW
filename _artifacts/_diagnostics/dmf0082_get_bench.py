# -*- coding: utf-8 -*-
"""DMF0082 MAIN 조회 성능 벤치 — 화면 실호출 파라미터 1:1 재현.

파라미터 출처: BE 로그(SystemLogAspect) 의 callProc Params 실측 (2026-09-07 13:44/13:50 SEARCH).
  div=40 / 20260901~20270228 / versionType=Current / itemId='' (ALL 아님) / userGroup=ADMIN
⚠ itemId 를 'ALL' 로, userGroup 을 'DM ADMIN' 으로 넣으면 0행이 나와 벤치가 무의미해진다(실측).

사용:
  python _artifacts/_diagnostics/dmf0082_get_bench.py [반복횟수] [--current]
출력: 호출 시간 + 커서별 행수 + 세션 내 상위 소비 SQL(V$SQL 세션 델타)
"""
import pathlib
import sys
import time

import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
REPEAT = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].isdigit() else 1
PROC = "P_DMF0082_GET_MAIN_DATA_CURRENT" if "--current" in sys.argv else "P_DMF0082_GET_MAIN_DATA"

env = {}
for ln in open(ROOT / ".env.asis", encoding="utf-8"):
    ln = ln.strip()
    if "=" in ln and not ln.startswith("#"):
        k, v = ln.split("=", 1)
        env[k] = v

# 화면 실호출 값 (BE 로그 실측 — 추정 금지)
P = {
    "P_DIVISION_ID": "40", "P_DEPT_ID": "ALL", "P_END_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
    "P_BIZTYPE": "ALL", "P_FROM_YYYYMMDD": "20260901", "P_TO_YYYYMMDD": "20270228",
    "P_SCM_SITE_ID": "ALL", "P_SALES_SITE": "ALL", "P_ITEM_ID": "", "P_VERSION_TYPE": "Current",
    "P_VERSION_NO": "Current", "P_QTY_YN": "N", "P_CREATED_BY": "minyonglee1",
    "P_USER_ID": "minyonglee1", "P_USER_GROUP": "ADMIN", "P_PLANT_SITE_ID": "ALL",
    "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL",
    "P_MENU_ID": "DMF0082", "P_MNU_ID": "DMF0082",
}

cn = oracledb.connect(user=env["TOBE_DB_USER"], password=env["TOBE_DB_PASS"],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cn.call_timeout = 900000
cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SID') FROM DUAL")
db, sid = cur.fetchone()
print(f"DB={db} SID={sid} PROC={PROC} 반복={REPEAT}\n")

# --tempundo : GTT 의 undo 를 temp 테이블스페이스로 보내 redo 생성을 줄인다(로직 무변경).
#   1위 병목이 ON CPU 가 아니라 `log buffer space`(redo 대기) 였으므로 이 축을 직접 겨냥한다.
#   ⚠ 트랜잭션 중에는 못 바꾼다 — 반드시 첫 GTT 접근 전에 설정한다.
if "--tempundo" in sys.argv:
    cur.execute("ALTER SESSION SET TEMP_UNDO_ENABLED = TRUE")
    print("TEMP_UNDO_ENABLED = TRUE")

# redo/undo 통계 델타 측정용
STAT = ("SELECT N.NAME, S.VALUE FROM V$SESSTAT S JOIN V$STATNAME N ON N.STATISTIC#=S.STATISTIC# "
        " WHERE S.SID=:sid AND N.NAME IN ('redo size','undo change vector size','db block changes')")


def stats():
    cur.execute(STAT, sid=int(sid))
    return dict(cur.fetchall())


cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS "
            "WHERE PACKAGE_NAME='PKG_DMF0082' AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION", o=PROC)
args = cur.fetchall()
missing = [a for a, io in args if io == "IN" and a not in P]
if missing:
    print("⚠ 값 미지정 IN 파라미터(공백 처리):", ", ".join(missing))

SNAP = ("SELECT SQL_ID, ELAPSED_TIME, BUFFER_GETS, EXECUTIONS, ROWS_PROCESSED, "
        "       SUBSTR(REPLACE(SQL_TEXT,CHR(10),' '),1,70) TXT "
        "  FROM V$SQL")


def snap():
    """V$SQL 스냅샷 — 호출 전후 델타로 문장별 실소비를 귀속한다(짧은 호출에서 ASH 표본보다 정확)."""
    cur.execute(SNAP)
    return {r[0]: r for r in cur}


times = []
for r in range(REPEAT):
    ins, outs = [], []
    for a, io in args:
        (ins.append(P.get(a, "")) if io == "IN" else outs.append(cn.cursor()))
    before = snap()
    t0 = time.time()
    cur.callproc(f"PKG_DMF0082.{PROC}", ins + outs)
    call_s = time.time() - t0
    counts = []
    t1 = time.time()
    for oc in outs:
        try:
            oc.arraysize = 5000
            n = 0
            while True:
                b = oc.fetchmany(5000)
                if not b:
                    break
                n += len(b)
            counts.append(n)
        except Exception as e:
            counts.append(f"ERR:{str(e)[:40]}")
    fetch_s = time.time() - t1
    times.append(call_s)
    print(f"[{r+1}] call={call_s:6.1f}s fetch={fetch_s:5.1f}s  cursors={counts}")

    after = snap()
    rows = []
    for sid_, a in after.items():
        b = before.get(sid_)
        d_el = (a[1] - (b[1] if b else 0)) / 1e6
        d_ex = a[3] - (b[3] if b else 0)
        d_gets = a[2] - (b[2] if b else 0)
        if d_gets >= 999999999 and d_ex > 0:
            rows.append((d_gets, d_el, d_ex, a[4] - (b[4] if b else 0), sid_, a[5]))
    rows.sort(reverse=True)
    tot = sum(x[0] for x in rows)
    print(f"     문장별 buffer gets (합 {tot:,} / 부모 총계 참고):")
    for gets, el, ex, rp, sid_, txt in rows[:26]:
        print(f"       gets={gets:>8} {el:6.2f}s ex={ex:>4} rows={rp:>8}  {sid_} {txt}")
    cn.rollback()

print(f"\n평균 call = {sum(times)/len(times):.1f}s  (min {min(times):.1f} / max {max(times):.1f})")

# ⚠ V$SQL 은 **인스턴스 전역**이라 위 델타에는 타 세션 문장이 섞인다(2026-09-07 실측 오귀속:
#    PKG_COM0000.P_COM0008... 은 PKG_DMF0082 소스에 없는데 델타에 잡혔다).
#    귀속의 정본은 **내 SID 로 한정한 ASH** 다. 표본이 얇으므로 반복 횟수를 늘려 쌓는다.
cur.execute("""
SELECT * FROM (
  SELECT A.SQL_ID, COUNT(*) SAMPLES, ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (),1) PCT,
         MAX(NVL(A.EVENT,'ON CPU')) EVT,
         SUBSTR(REPLACE((SELECT X.SQL_TEXT FROM V$SQL X WHERE X.SQL_ID=A.SQL_ID AND ROWNUM=1),CHR(10),' '),1,66) TXT
    FROM V$ACTIVE_SESSION_HISTORY A
   WHERE A.SESSION_ID = :sid AND A.SAMPLE_TIME > SYSDATE - :mins/1440
     AND A.SQL_ID IS NOT NULL
   GROUP BY A.SQL_ID ORDER BY 2 DESC) WHERE ROWNUM <= 15
""", sid=int(sid), mins=(sum(times) + 60) / 60.0)
print("\n세션 ASH 귀속 (SID 한정 — 전역 오염 없음):")
for sql_id, n, pct, evt, txt in cur:
    print(f"  {n:4} {pct:5.1f}%  {evt:24} {sql_id}  {txt}")
cn.close()
