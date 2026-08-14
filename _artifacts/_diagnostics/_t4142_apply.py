#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""통합테스트 No.41/42 — 사내 적용기 (백업 → 적용 → 검증).

사용: python _t4142_apply.py [--backup-only]
백업: _artifacts/_apply_corporate/BACKUP_DMF0082_test4142_20260814.json
"""
import sys, io, json, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

ROOT = pathlib.Path(__file__).resolve().parents[1]
PKG = ROOT / "_apply_corporate" / "DMF0082_TEST4142_20260814"
BACKUP = ROOT / "_apply_corporate" / "BACKUP_DMF0082_test4142_20260814.json"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def rows(sql, binds=None):
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    out = []
    for r in cur.fetchall():
        rec = {}
        for i, c in enumerate(cols):
            v = r[i]
            if hasattr(v, "read"):
                v = v.read()
            if isinstance(v, datetime.datetime):
                v = v.strftime("%Y-%m-%d %H:%M:%S")
            rec[c] = v
        out.append(rec)
    return out


# ---------- 1) 백업 ----------
backup = {
    "taken_at": None,
    "lookup_GET_ADMIN_GROUP_MEASURE_DMF0082": rows(
        """SELECT LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,DISPLAY_SEQ,VALID_YN,
                  DESCRIPTION,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,
                  CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
           WHERE  LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082'
           ORDER BY SEGMENT3,SEGMENT4,SEGMENT1"""
    ),
    "cmbo_FcstType_family": rows(
        """SELECT SQL_ID,MDU_DIVS_CD,SQL_NM,SQL_DTL_CTN,USE_YN,
                  CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
           FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M
           WHERE  SQL_ID IN ('FcstTypeByUserGroupDMF0082','FcstTypeEditDMF0082','FcstTypeWs','FcstType',
                             'EndCustomerByDivisionDMF0082','EndCustomerByDivision40')
           ORDER BY SQL_ID"""
    ),
    "sheet_columns_DMF0082_combo": rows(
        """SELECT PROGRAM_ID,SHEET_NAME,COLUMN_NAME,DIVISION_ID,CELL_CONTROL_OBJECT_TYPE_CODE,
                  CELL_COMBO_DATA_TYPE,INPUT_TP_CD,VISIBLE_FLAG,VALID_YN
           FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
           WHERE  PROGRAM_ID='DMF0082' AND CELL_COMBO_DATA_TYPE IS NOT NULL
           ORDER BY SHEET_NAME,COLUMN_NAME"""
    ),
}
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
backup["taken_at"] = cur.fetchone()[0]
BACKUP.write_text(json.dumps(backup, ensure_ascii=False, indent=1), encoding="utf-8")
print(f"[backup] {BACKUP}")
print(f"  lookup rows = {len(backup['lookup_GET_ADMIN_GROUP_MEASURE_DMF0082'])}")
print(f"  cmbo   rows = {len(backup['cmbo_FcstType_family'])}")

if "--backup-only" in sys.argv:
    con.close()
    sys.exit(0)


# ---------- 2) 적용 ----------
def _strip_leading_comments(s):
    """선행 주석 줄(-- …)만 제거한다.
    ⚠ 2026-08-14 사고: '주석으로 시작하면 문장 전체를 버린다' 로 짰더니 파일 머리말 주석 블록에
      붙어 있던 **첫 UPDATE 2건이 통째로 유실**됐다(적용 로그는 [1] OK 로 보여 성공처럼 읽힘).
      주석은 벗기되 문장은 반드시 남긴다."""
    lines = s.splitlines()
    i = 0
    while i < len(lines) and (not lines[i].strip() or lines[i].lstrip().startswith("--")):
        i += 1
    return "\n".join(lines[i:]).strip()


def split_statements(text):
    """‘;’ 로 끝나는 줄을 문장 종결로 본다. 문자열 리터럴 안에는 ‘;’ 가 없음을 파일에서 보장."""
    stmts, buf = [], []
    for line in text.replace("\r", "").splitlines():
        buf.append(line)
        if line.rstrip().endswith(";"):
            s = _strip_leading_comments("\n".join(buf).rstrip().rstrip(";"))
            if s:
                stmts.append(s)
            buf = []
    tail = _strip_leading_comments("\n".join(buf))
    if tail:
        stmts.append(tail)
    return stmts


for f in sorted(PKG.glob("0[234]_*.sql")):
    print(f"\n=== APPLY {f.name} ===")
    for i, s in enumerate(split_statements(f.read_text(encoding="utf-8"))):
        head = " ".join(s.split())[:70]
        if head.upper().startswith("COMMIT"):
            con.commit()
            print(f"  [{i+1}] COMMIT")
            continue
        try:
            cur.execute(s)
            print(f"  [{i+1}] OK  rows={cur.rowcount}  :: {head}")
        except Exception as e:
            print(f"  [{i+1}] FAIL {e}\n      :: {head}")
con.commit()

# ---------- 3) 검증 ----------
print("\n=== VERIFY : GET_ADMIN_GROUP_MEASURE / DMF0082 ===")
for r in rows(
    """SELECT SEGMENT3 DIV, SEGMENT4 MEASURE, SEGMENT1 GRP,
              NVL(ATTRIBUTE1,'-') DAYS, NVL(ATTRIBUTE2,'-') FR, NVL(ATTRIBUTE3,'-') TO_
       FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
       WHERE  LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082'
       ORDER BY SEGMENT3, SEGMENT4, SEGMENT1"""
):
    print("  " + " | ".join(f"{k}={v}" for k, v in r.items()))

print("\n=== VERIFY : 콤보 실행 ===")
for sql_id in ("FcstTypeByUserGroupDMF0082", "FcstTypeEditDMF0082"):
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:i", {"i": sql_id})
    row = cur.fetchone()
    if not row:
        print(f"  [{sql_id}] NOT REGISTERED")
        continue
    base = row[0].read() if hasattr(row[0], "read") else row[0]
    for div, uid, tag in (
        ("40", "jaehyeok", "W/S 보유"),
        ("40", "hongjae.kim", "비 W/S"),
        ("81", "jaehyeok", "W/S 보유"),
        ("81", "hongjae.kim", "비 W/S"),
        ("82", "jaehyeok", "W/S 보유"),
        ("-", "jaehyeok", "division 미전달"),
    ):
        s = base.replace("@sesUserId", f"'{uid}'").replace("@divisionId", f"'{div}'")
        cur.execute(s)
        res = cur.fetchall()
        codes = ",".join(str(x[0]) for x in res)
        print(f"  [{sql_id}] div={div:<3} user={uid:<12} ({tag}) → {len(res)}종 : {codes}")

con.close()
