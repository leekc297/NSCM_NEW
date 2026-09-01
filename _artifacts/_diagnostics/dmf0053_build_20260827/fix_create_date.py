# -*- coding: utf-8 -*-
"""[E20260827-CFHCD] DM_PLN_CUST_FCST_H.CREATE_DATE 이관 누락 채움 — AS-IS 실값 (HISTORY_SEQ 키)
사전: TO-BE CREATE_DATE 전량 NULL 실측(2,873,365) · AS-IS 전량 채움(NULL 0) · 행수 완전 일치.
파생 금지 근거: AS-IS CREATE_DATE==CONVERT(CREATION_DATE,112) 일치율 12%(349,289/2,843,411)."""
import io, sys, re, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import pyodbc, oracledb

env = io.open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8").read()
a = dict(re.findall(r'^(ASIS_DB_\w+)=(.*)$', env, re.M))
t = dict(re.findall(r'^(TOBE_DB_\w+)=(.*)$', env, re.M))
cn_a = pyodbc.connect(f"DRIVER={{{a['ASIS_DB_DRIVER']}}};SERVER={a['ASIS_DB_HOST']},{a['ASIS_DB_PORT']};DATABASE={a['ASIS_DB_NAME']};UID={a['ASIS_DB_USER']};PWD={a['ASIS_DB_PASS']}", timeout=30)
cn_t = oracledb.connect(user=t["TOBE_DB_USER"], password=t["TOBE_DB_PASS"], dsn=f"{t['TOBE_DB_HOST']}:{t['TOBE_DB_PORT']}/{t['TOBE_DB_PDB']}")
ca, ct = cn_a.cursor(), cn_t.cursor()

# 사전 단언 (원천 DB 는 재적재된다 — 고정 건수 ASSERT 대신 스냅샷 정합 게이트)
ct.execute("SELECT COUNT(*), COUNT(CREATE_DATE) FROM DM_PLN_CUST_FCST_H")
tot, filled = ct.fetchone()
print(f"TO-BE 사전: 총 {tot} / CREATE_DATE 채움 {filled}")
if filled:
    print("이미 일부 채움 — MERGE 방식으로 계속 (덮어쓰지 않고 NULL 만)")

ca.execute("SELECT HISTORY_SEQ, CREATE_DATE FROM DM_PLN_CUST_FCST_H WITH(NOLOCK) WHERE CREATE_DATE IS NOT NULL AND CREATE_DATE <> ''")
BATCH = 50000
n = 0
t0 = time.time()
while True:
    rows = ca.fetchmany(BATCH)
    if not rows:
        break
    ct.executemany(
        "UPDATE DM_PLN_CUST_FCST_H SET CREATE_DATE = :2 WHERE HISTORY_SEQ = :1 AND CREATE_DATE IS NULL",
        [(int(r[0]), r[1]) for r in rows])
    n += len(rows)
    if n % 500000 < BATCH:
        print(f"  {n:,}행 처리 {time.time()-t0:.0f}s")
cn_t.commit()
print(f"완료: {n:,}행 {time.time()-t0:.0f}s")

ct.execute("SELECT COUNT(*), COUNT(CREATE_DATE), MIN(CREATE_DATE), MAX(CREATE_DATE) FROM DM_PLN_CUST_FCST_H")
print("TO-BE 사후:", ct.fetchone())
cn_a.close(); cn_t.close()
