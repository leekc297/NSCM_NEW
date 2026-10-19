# -*- coding: utf-8 -*-
"""DMF0082 조회 구역별 소요시간 프로파일.

방법: SP 를 N 회 호출하며 **내 세션 한정 ASH** 를 모으고, 각 SQL_ID 의 텍스트를
      PKG_DMF0082 소스에서 찾아 **소스 라인**에 매핑한다. 라인 순으로 정렬하면
      "조회가 어느 구역에서 얼마를 쓰는가" 가 실행 순서대로 나온다.

왜 이 방법인가:
  - SP 내장 마커(■ : A0xx)는 실제로 3건만 기록돼 구간 분해가 안 된다(2026-09-07 실측).
  - V$SQL 델타는 **인스턴스 전역**이라 타 세션이 섞인다(같은 날 오귀속 실측).
  ⇒ 귀속 정본 = SID 한정 ASH. ASH 1 샘플 ≈ 1초.

사용: python _artifacts/_diagnostics/dmf0082_stage_profile.py [반복=8]
"""
import pathlib
import re
import sys
import time

import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
REPEAT = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].isdigit() else 8

env = {}
for ln in open(ROOT / ".env.asis", encoding="utf-8"):
    ln = ln.strip()
    if "=" in ln and not ln.startswith("#"):
        k, v = ln.split("=", 1)
        env[k] = v

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
cur.execute("SELECT SYS_CONTEXT('USERENV','SID'), SYSTIMESTAMP FROM DUAL")
sid, t_begin = cur.fetchone()
sid = int(sid)

# --- 소스 로드 (공백 정규화본 + 원본 라인 인덱스) ---
cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = [(ln, (tx or "").rstrip()) for ln, tx in cur]
norm_src = " ".join(re.sub(r"\s+", " ", t).strip() for _, t in src).upper()
# 정규화본 오프셋 -> 소스 라인 매핑
offsets, pos = [], 0
for ln, t in src:
    piece = re.sub(r"\s+", " ", t).strip()
    offsets.append((pos, ln))
    pos += len(piece) + 1


def line_of(offset):
    lo, hi, best = 0, len(offsets) - 1, offsets[0][1]
    while lo <= hi:
        mid = (lo + hi) // 2
        if offsets[mid][0] <= offset:
            best = offsets[mid][1]
            lo = mid + 1
        else:
            hi = mid - 1
    return best


cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
args = cur.fetchall()

times = []
for r in range(REPEAT):
    ins, outs = [], []
    for a, io in args:
        (ins.append(P.get(a, "")) if io == "IN" else outs.append(cn.cursor()))
    t0 = time.time()
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", ins + outs)
    times.append(time.time() - t0)
    outs[0].arraysize = 5000
    n = 0
    while True:
        b = outs[0].fetchmany(5000)
        if not b:
            break
        n += len(b)
    cn.rollback()
print(f"{REPEAT}회 호출 — 평균 {sum(times)/len(times):.1f}s (min {min(times):.1f}/max {max(times):.1f}), 메인커서 {n}행\n")

cur.execute("""
SELECT A.SQL_ID, COUNT(*) SAMPLES, MAX(NVL(A.EVENT,'ON CPU')) EVT,
       SUBSTR(REPLACE((SELECT X.SQL_TEXT FROM V$SQL X WHERE X.SQL_ID=A.SQL_ID AND ROWNUM=1),CHR(10),' '),1,200) TXT
  FROM V$ACTIVE_SESSION_HISTORY A
 WHERE A.SESSION_ID=:s AND A.SAMPLE_TIME >= :t AND A.SQL_ID IS NOT NULL
 GROUP BY A.SQL_ID
""", s=sid, t=t_begin)
found = []
for sql_id, n_s, evt, txt in cur:
    key = re.sub(r"\s+", " ", (txt or "")).strip().upper()[:120]
    off = norm_src.find(key) if len(key) > 40 else -1
    if off < 0 and len(key) > 60:                       # 바인드/리터럴 차이 대비 축약 재시도
        off = norm_src.find(key[:60])
    found.append((line_of(off) if off >= 0 else 10 ** 9, n_s, evt, sql_id, key[:76]))

found.sort()
total = sum(f[1] for f in found)
print(f"{'소스라인':>8} {'초':>5} {'비중':>6}  {'이벤트':22} 문장")
for line, n_s, evt, sql_id, key in found:
    loc = "(외부)" if line == 10 ** 9 else str(line)
    print(f"{loc:>8} {n_s:5} {n_s*100/max(total,1):5.1f}%  {evt:22} {key}")
print(f"\n총 ASH 샘플 {total} (≈{total}초 / {REPEAT}회 = 회당 {total/REPEAT:.1f}초)")
cn.close()
