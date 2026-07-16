#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 div81 사내 적용 (사용자 일괄 승인 2026-07-14)
DDL 4건(CREATE OR REPLACE) + DML 1건(SHEET_MEASURE 토큰 확장) — 단일 커넥션, 건별 USER_ERRORS 확인.
실패(컴파일 에러) 시 즉시 중단. 로그: _apply_corporate/_logs/ 규약."""
import io, sys, datetime, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
AC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
sys.path.insert(0, str(AC.parent / "_diagnostics"))
from ora import conn_info
import oracledb

LOG = AC / "_logs" / (datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + "_DMF0082_div81_apply.log")
LOG.parent.mkdir(exist_ok=True)
logf = open(LOG, "w", encoding="utf-8")

def log(msg):
    print(msg)
    logf.write(msg + "\n")
    logf.flush()

DDL = [
    ("DMF0082_SAVE_MAIN_DATA",  "PROCEDURE",    "DMF0082_SAVE_MAIN_DATA_div81_20260714.sql"),
    ("PKG_DMF0082",             "PACKAGE BODY", "PKG_DMF0082_body_div81_20260714.sql"),
    ("DMF0082_GET_MAIN_DATA_CURRENT", "PROCEDURE", "DMF0082_GET_MAIN_DATA_CURRENT_div81_20260714.sql"),
    ("DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP", "PROCEDURE", "DMF0082_POPUP_SAVEPRICE_div81_20260714.sql"),
]

u, p, d = conn_info()
log(f"[conn] {u}@{d}  {datetime.datetime.now()}")
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

ok = True
for name, otype, fname in DDL:
    src = (AC / fname).read_text(encoding="utf-8")
    stmt = src.rstrip()
    if stmt.endswith("/"):
        stmt = stmt[:-1].rstrip()  # sqlplus 종결자 제거
    log(f"\n=== DDL: {name} ({otype}) ← {fname} ({len(stmt.splitlines())}줄)")
    try:
        cur.execute(stmt)
    except oracledb.DatabaseError as e:
        log(f"  !! 실행 실패: {e}")
        ok = False
        break
    cur.execute("""SELECT LINE, POSITION, TEXT FROM USER_ERRORS
                   WHERE NAME=:n AND TYPE=:t ORDER BY SEQUENCE""", n=name, t=otype)
    errs = cur.fetchall()
    if errs:
        log(f"  !! USER_ERRORS {len(errs)}건:")
        for line, pos, txt in errs[:20]:
            log(f"     L{line}:{pos} {txt.strip()}")
        ok = False
        break
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=otype)
    st = cur.fetchone()
    log(f"  OK — STATUS={st[0] if st else '???'}")

if ok:
    log("\n=== DML: SCM_MST_SHEET_MEASURE 81 토큰 확장 (멱등)")
    cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_MEASURE
        SET DIVISION_ID='40,81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
        WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND DIVISION_ID='40'
        AND COLUMN_NAME IN ('MKT_FCST_PP','MKT_FCST','RTF_SYS_RP','BALANCE',
                            'VMI_In_Plan','VMI_In_Req','VMI_Inv','KRW','USD','LOC')""")
    log(f"  UPDATE {cur.rowcount}건 (기대 10 / 재실행 시 0)")
    con.commit()
    cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                   WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' GROUP BY DIVISION_ID""")
    for div, cnt in cur.fetchall():
        log(f"  {div} : {cnt}")

    log("\n=== 사후 확인: DMF0082 4객체 상태 + INVALID 총수")
    cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
                   WHERE OBJECT_NAME IN ('DMF0082_SAVE_MAIN_DATA','PKG_DMF0082',
                        'DMF0082_GET_MAIN_DATA_CURRENT','DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP')
                   ORDER BY OBJECT_NAME, OBJECT_TYPE""")
    for n, t, s in cur.fetchall():
        log(f"  {n:<58} {t:<14} {s}")
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS='INVALID'")
    log(f"  INVALID 총수 = {cur.fetchone()[0]} (기준선 1,022)")

con.close()
log(f"\n[{'DONE' if ok else 'ABORTED'}] {datetime.datetime.now()}  log={LOG.name}")
sys.exit(0 if ok else 2)
