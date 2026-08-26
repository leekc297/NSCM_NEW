# -*- coding: utf-8 -*-
"""REQ:CHAT-20260820-18 — DMF0049 'MDF Reports' 정적 3컬럼 편집을 **division 40 만** 개방.

AS-IS 근거: `DMF0049_Sales_ETC_Reports.cs` EditButton — division 40 분기(L396~406)는
  DEPARTMENT_ID / DEPT_ID / CUST_REPORT 를 **잠그지 않는다**(기존행도 편집 가능).
  비-40 은 L409 에서 정적 전 컬럼 잠금.
TO-BE 표현: INPUT_TP_CD `IM/IO`(신규행만) → **`M`/`O`(전 행)** 로 40 축만 전환.
  ⚠ 비-40 행은 **손대지 않는다** — 'S'(전면 잠금)로 바꾸면 81/82 의 **신규행 입력까지** 막혀
    AS-IS InsertRow 경로가 회귀한다. 요구는 "40 기존행 개방"이지 "비-40 잠금 강화"가 아니다.
"""
import io
import json
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0049_META_EDIT40_20260820"
KEY = dict(pg="DMF0049", sh="MDF Reports")
NON40 = "82,81,81_UC,81_HM,81_ST,81_HD,81_HG"
# 컬럼 → 40 축 입력형 (AS-IS: DEPARTMENT 는 필수 검증 대상 → M / 나머지 선택 → O)
PLAN = {"DEPARTMENT_ID": "M", "DEPT_ID": "O", "CUST_REPORT": "O"}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='SCM_MST_SHEET_COLUMNS' ORDER BY COLUMN_ID""")
cols = [r[0] for r in cur.fetchall()]

sel = (f"SELECT {','.join(cols)} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
       "WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND COLUMN_NAME IN "
       "('DEPARTMENT_ID','DEPT_ID','CUST_REPORT') ORDER BY COLUMN_NAME, DIVISION_ID")
cur.execute(sel, KEY)
before = cur.fetchall()
json.dump([[str(v) for v in r] for r in before],
          open(BASE + r"\BACKUP_before_20260820.json", "w", encoding="utf-8"),
          ensure_ascii=False, indent=1)
print(f"[backup] {len(before)}행 → BACKUP_before_20260820.json")
idx = {c: i for i, c in enumerate(cols)}
for r in before:
    print(f"  {r[idx['COLUMN_NAME']]:14} DIV={r[idx['DIVISION_ID']]:42} TP={r[idx['INPUT_TP_CD']]}")

assert len(before) == 3, "전제 불일치(3행 아님) — 중단"

for col, tp40 in PLAN.items():
    row = next(r for r in before if r[idx["COLUMN_NAME"]] == col)
    div = row[idx["DIVISION_ID"]]
    if div == "40":
        # 40 전용 행 — 입력형만 전환
        cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD=:tp,
                       LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                       WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND COLUMN_NAME=:c
                       AND DIVISION_ID='40'""", dict(tp=tp40, c=col, **KEY))
        assert cur.rowcount == 1, f"{col} UPDATE {cur.rowcount}행"
        print(f"[update] {col} (40 전용) INPUT_TP_CD → {tp40}")
        continue
    # 공유 행 → 비-40 으로 축소 + 40 전용 행 신설(복제 후 division/입력형만 교체)
    assert "40" in div.split(","), f"{col}: 40 미포함 — 중단({div})"
    cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DIVISION_ID=:nd,
                   LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                   WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND COLUMN_NAME=:c
                   AND DIVISION_ID=:od""", dict(nd=NON40, c=col, od=div, **KEY))
    assert cur.rowcount == 1, f"{col} 축소 UPDATE {cur.rowcount}행"
    vals = list(row)
    vals[idx["DIVISION_ID"]] = "40"
    vals[idx["INPUT_TP_CD"]] = tp40
    for a in ("LAST_UPDATED_BY", "CREATED_BY"):
        if a in idx:
            vals[idx[a]] = "admin"
    binds = {f"c{i}": v for i, v in enumerate(vals)}
    cur.execute(f"INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS ({','.join(cols)}) "
                f"VALUES ({','.join(':c' + str(i) for i in range(len(cols)))})", binds)
    assert cur.rowcount == 1
    print(f"[split ] {col}: 공유행 → '{NON40}' 유지 / 40 전용행 신설 INPUT_TP_CD={tp40}")

con.commit()
cur.execute(sel, KEY)
print("\n[AFTER]")
for r in cur.fetchall():
    print(f"  {r[idx['COLUMN_NAME']]:14} DIV={r[idx['DIVISION_ID']]:42} TP={r[idx['INPUT_TP_CD']]}")
con.close()
print("[OK] 40 편집 개방 적용 완료")
