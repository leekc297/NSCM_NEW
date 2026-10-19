# -*- coding: utf-8 -*-
"""[E20260918-KEYNAMETOCODE] 검증 2 — 완결 증명 + 40 양식 회귀 (사내 ZIOUI1)

 A. 81 배치: Plan Date 만 미래월로 바꿔 재검증 → 전건 통과 확인 → 원값 복원
 B. 40 배치: 코드(M035) 입력분이 보완 후에도 변형되지 않는지(코드 우선 가드) 회귀
"""
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

B81 = ("DMF0074", "Metal Link Price", "minyonglee1", "2026-09-18 16:27:12.000", "ATTRIBUTE14")
B40 = ("DMF0074_40", "Metal Link Price", "minyonglee1", "2026-09-15 16:16:18.000", "ATTRIBUTE12")
W = ("""PROGRAM_ID=:1 AND SHEET_NAME=:2 AND CREATED_BY=:3
        AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')=:4""")


def dump(tag, b):
    pid, sheet, who, cd, k = b
    cur.execute("""SELECT ATTRIBUTE2, {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT, COUNT(*)
                     FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE {w}
                    GROUP BY ATTRIBUTE2, {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT
                    ORDER BY 5 DESC""".format(k=k, w=W), [pid, sheet, who, cd])
    print("  [{}]".format(tag))
    for r in cur:
        print("     PlanDate={!r:9s} {}={!r:9s} {:8s} {!r:28s} {}건".format(
            str(r[0]), k, str(r[1]), str(r[2]), str(r[3]), r[4]))


def validate(b):
    pid, sheet, who, cd, k = b
    rc = cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD", [0, who, pid, sheet, rc])
    c = rc.getvalue()
    cols = [d[0] for d in c.description]
    out = [dict(zip(cols, r)) for r in c.fetchall()]
    db.commit()
    return out


print("=" * 78)
print("A. 81 배치 — Plan Date 미래월 치환 후 재검증")
print("=" * 78)
pid, sheet, who, cd, k = B81
cur.execute("""SELECT DISTINCT ATTRIBUTE2 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE {w} AND ATTRIBUTE2 IS NOT NULL""".format(w=W), [pid, sheet, who, cd])
orig = [r[0] for r in cur]
print("  원 Plan Date = {}".format(orig))

cur.execute("""SELECT TO_CHAR(ADD_MONTHS(SYSDATE,1),'YYYYMM') FROM DUAL""")
future = cur.fetchone()[0]
print("  치환 → {}".format(future))

cur.execute("""UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD SET ATTRIBUTE2=:5
                WHERE {w} AND ATTRIBUTE2 IS NOT NULL
                  AND NVL(UPLOAD_STATUS_CODE,'X') <> '@TITLE'""".format(w=W),
            [pid, sheet, who, cd, future])
print("  치환 {}행".format(cur.rowcount))
db.commit()

print("  재검증 결과커서:", validate(B81))
dump("AFTER (미래월)", B81)

cur.execute("""SELECT NVL(MESSAGE_TEXT,'(통과)'), COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE {w} GROUP BY MESSAGE_TEXT ORDER BY 2 DESC""".format(w=W),
            [pid, sheet, who, cd])
print("  메시지 집계:")
for r in cur:
    print("     {:40s} {}건".format(str(r[0]), r[1]))

# ---- 원복 ----
restore = orig[0] if orig else "202601"
cur.execute("""UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD SET ATTRIBUTE2=:5
                WHERE {w} AND ATTRIBUTE2=:6""".format(w=W),
            [pid, sheet, who, cd, restore, future])
print("\n  원복 {}행 → Plan Date={}".format(cur.rowcount, restore))
db.commit()
cur.execute("""SELECT DISTINCT ATTRIBUTE2 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE {w} AND ATTRIBUTE2 IS NOT NULL""".format(w=W), [pid, sheet, who, cd])
print("  원복 확인 = {}".format([r[0] for r in cur]))

print()
print("=" * 78)
print("B. 40 배치 — 코드 입력분 불변(코드 우선 가드) 회귀")
print("=" * 78)
dump("BEFORE", B40)
print("  재검증 결과커서:", validate(B40))
dump("AFTER", B40)
