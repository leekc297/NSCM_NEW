# -*- coding: utf-8 -*-
"""DMF0049 저장 대상 표의 숫자 NOT NULL 컬럼 QTY 에 DEFAULT ON NULL 0 부여.

사용자 확정(2026-08-20): "TABLE 내 NOT NULL COLUMN 의 경우 DEFAULT ON NULL '-' NOT NULL 설정".
  · VARCHAR2 축 10컬럼은 **이미 DEFAULT ON NULL '-'** 로 적용돼 있음(실측) → 대상 아님.
  · 숫자 컬럼에 '-' 는 불가 → hook #119 규약대로 **0**.
제외 축(의도적):
  · DATA_SEQ / HISTORY_SEQ = 키·시퀀스. 기본값 0 을 주면 PK 충돌·유령행을 **조용히** 만든다.
    비면 지금처럼 즉시 실패해야 한다.
  · 감사컬럼 4종(CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE) = 사용자 확정 제외 계보.
QTY 를 0 으로 두는 근거: AS-IS 는 수치 셀 빈값을 '0' 으로 강제한다(빈 셀 = 0 이라는 화면 규약).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

TARGETS = [("DM_PLN_SALES_ETC_REPORT_C", "QTY"), ("DM_PLN_SALES_ETC_REPORT_H", "QTY")]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
Q = ("SELECT NULLABLE, DEFAULT_ON_NULL, DATA_TYPE FROM ALL_TAB_COLUMNS "
     "WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME=:c")

for tb, col in TARGETS:
    cur.execute(Q, {"t": tb, "c": col})
    before = cur.fetchone()
    print(f"[BEFORE] {tb}.{col} = {before}")
    assert before and before[0] == "N" and before[2] == "NUMBER", f"전제 불일치 — 중단: {before}"
    if before[1] == "YES":
        print("  이미 DEFAULT ON NULL — skip")
        continue
    cur.execute(f"ALTER TABLE SCM_MGR.{tb} MODIFY ({col} DEFAULT ON NULL 0)")
    cur.execute(Q, {"t": tb, "c": col})
    after = cur.fetchone()
    print(f"[AFTER ] {tb}.{col} = {after}")
    assert after[1] == "YES", "적용 실패"
con.close()
print("[OK] QTY DEFAULT ON NULL 0 적용 완료")
