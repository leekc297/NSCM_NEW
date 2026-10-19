# -*- coding: utf-8 -*-
"""[E20260918-KEYNAMETOCODE] 검증 3 — 81 배치 완결 증명 (Plan Date 만 미래월 치환 → 원복)

verify2.py 의 A 구간은 :1~:5 혼용으로 위치 바인딩이 어긋나 0행이었다(데이터 무변경 확인됨).
여기서는 전부 명명 바인드로 고쳐 재수행한다.
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

PID, SHEET, WHO, CD, K = ("DMF0074", "Metal Link Price", "minyonglee1",
                          "2026-09-18 16:27:12.000", "ATTRIBUTE14")
B = dict(pid=PID, sheet=SHEET, who=WHO, cd=CD)
W = """PROGRAM_ID=:pid AND SHEET_NAME=:sheet AND CREATED_BY=:who
        AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')=:cd"""


def dump(tag):
    cur.execute("""SELECT ATTRIBUTE2, {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT, COUNT(*)
                     FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE {w}
                    GROUP BY ATTRIBUTE2, {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT
                    ORDER BY 5 DESC""".format(k=K, w=W), B)
    print("  [{}]".format(tag))
    for r in cur:
        print("     PlanDate={!r:12s} {}={!r:9s} {:8s} {!r:28s} {}건".format(
            str(r[0]), K, str(r[1]), str(r[2]), str(r[3]), r[4]))


def validate():
    rc = cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD", [0, WHO, PID, SHEET, rc])
    c = rc.getvalue()
    cols = [d[0] for d in c.description]
    out = [dict(zip(cols, r)) for r in c.fetchall()]
    db.commit()
    return out


def msgs(tag):
    cur.execute("""SELECT NVL(MESSAGE_TEXT,'(통과)'), COUNT(*)
                     FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE {w}
                    GROUP BY MESSAGE_TEXT ORDER BY 2 DESC""".format(w=W), B)
    print("  메시지 집계 [{}]:".format(tag))
    for r in cur:
        print("     {:40s} {}건".format(str(r[0]), r[1]))


dump("BEFORE")
cur.execute("SELECT TO_CHAR(ADD_MONTHS(SYSDATE,1),'YYYYMM') FROM DUAL")
future = cur.fetchone()[0]
print("\n  Plan Date '202601' → '{}' 치환".format(future))

cur.execute("""UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD SET ATTRIBUTE2=:fut
                WHERE {w} AND ATTRIBUTE2='202601'""".format(w=W), dict(B, fut=future))
print("  치환 {}행".format(cur.rowcount))
db.commit()

print("  재검증 결과커서:", validate())
dump("AFTER (미래월)")
msgs("AFTER")

cur.execute("""UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD SET ATTRIBUTE2='202601'
                WHERE {w} AND ATTRIBUTE2=:fut""".format(w=W), dict(B, fut=future))
print("\n  원복 {}행".format(cur.rowcount))
db.commit()
cur.execute("""SELECT DISTINCT ATTRIBUTE2 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE {w} AND ATTRIBUTE2 IS NOT NULL""".format(w=W), B)
print("  원복 확인 Plan Date = {}".format(sorted(str(r[0]) for r in cur)))
