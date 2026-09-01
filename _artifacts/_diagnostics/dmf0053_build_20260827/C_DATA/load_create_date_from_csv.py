# -*- coding: utf-8 -*-
"""[E20260827-CFHCD] 클라우드용 — DM_PLN_CUST_FCST_H.CREATE_DATE 이관 누락 채움 (CSV 원천, NULL-only UPDATE, 멱등)

  python load_create_date_from_csv.py [cfh_create_date.csv]
  접속: 환경변수 NSCM_ORA_USER / NSCM_ORA_PASS / NSCM_ORA_DSN (클라우드 SCM_MGR)

원천 csv = 사내 AS-IS(MSSQL) DM_PLN_CUST_FCST_H 의 (HISTORY_SEQ, CREATE_DATE) 실값 — HISTORY_SEQ 키.
파생 금지 근거: AS-IS CREATE_DATE == CONVERT(CREATION_DATE,112) 일치율 12% 실측 → CREATION_DATE 로 만들 수 없다.
사전 게이트: 고정 건수 ASSERT 대신 스냅샷 정합(총행/채움 수) 출력 · NULL 인 행만 갱신(재실행 안전).
"""
import csv, io, os, sys, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb

path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), "cfh_create_date.csv")
u, p, d = os.environ.get("NSCM_ORA_USER"), os.environ.get("NSCM_ORA_PASS"), os.environ.get("NSCM_ORA_DSN")
if not (u and p and d):
    sys.exit("NSCM_ORA_USER / NSCM_ORA_PASS / NSCM_ORA_DSN 환경변수 필요")
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("SELECT COUNT(*), COUNT(CREATE_DATE) FROM SCM_MGR.DM_PLN_CUST_FCST_H"); tot, filled = cur.fetchone()
print(f"사전: 총 {tot:,} / CREATE_DATE 채움 {filled:,}")

BATCH = 50000; n = 0; t0 = time.time(); buf = []
with open(path, newline="", encoding="utf-8-sig") as f:
    rd = csv.reader(f)
    for row in rd:
        if not row or not row[0].strip().lstrip("-").isdigit():
            continue  # 헤더/공백 행 skip
        seq, cd = int(row[0]), (row[1].strip() if len(row) > 1 else "")
        if not cd:
            continue
        buf.append((cd, seq))
        if len(buf) >= BATCH:
            cur.executemany("UPDATE SCM_MGR.DM_PLN_CUST_FCST_H SET CREATE_DATE = :1 WHERE HISTORY_SEQ = :2 AND CREATE_DATE IS NULL", buf)
            n += len(buf); buf = []; print(f"  {n:,}행 처리 {time.time()-t0:.0f}s")
if buf:
    cur.executemany("UPDATE SCM_MGR.DM_PLN_CUST_FCST_H SET CREATE_DATE = :1 WHERE HISTORY_SEQ = :2 AND CREATE_DATE IS NULL", buf); n += len(buf)
con.commit()
cur.execute("SELECT COUNT(*), COUNT(CREATE_DATE), MIN(CREATE_DATE), MAX(CREATE_DATE) FROM SCM_MGR.DM_PLN_CUST_FCST_H")
print(f"완료: {n:,}행 {time.time()-t0:.0f}s · 사후:", cur.fetchone())
con.close()
