# -*- coding: utf-8 -*-
"""[E20261002-DMF0082-81MKTAMT] 수정본 사전 컴파일 검증 — 실험용 복제 패키지 PKG_DMF0082_T81 (운영 PKG_DMF0082 무영향).
원천 = 01_PKG_DMF0082_BODY_81MKTAMT.sql(오늘 USER_SOURCE 에서 새로 추출한 원문 + 삽입 6곳) / SPEC = USER_SOURCE 현재본.
FRESH-GATE 해당 없음(운영 객체 미변경). 사용: python t01_clone_compile.py create | run | drop
"""
import io, sys, re, time, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d); cn.call_timeout = 1800000
cur = cn.cursor()
CL = "PKG_DMF0082_T81"
MODE = sys.argv[1]
if MODE == "drop":
    cur.execute(f"DROP PACKAGE SCM_MGR.{CL}"); print("dropped"); sys.exit(0)
if MODE == "create":
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE' ORDER BY LINE")
    spec = "".join(t or "" for (t,) in cur)
    body = (HERE / "01_PKG_DMF0082_BODY_81MKTAMT.sql").read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    def ren(s):
        s2, n = re.subn(r'"?PKG_DMF0082"?(?=\s+(IS|AS)\b)', CL, s, count=1)
        assert n == 1
        s3, n = re.subn(r"END\s+PKG_DMF0082\s*;\s*$", f"END {CL};", s2.rstrip())
        assert n == 1, "END 치환 실패"
        return s3
    for typ, src in (("PACKAGE", ren(spec)), ("PACKAGE BODY", ren(body))):
        cur.execute("CREATE OR REPLACE " + src)
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [CL, typ])
        st = cur.fetchone()[0]
        cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [CL, typ])
        errs = cur.fetchall()
        print(typ, st, "오류", len(errs))
        for e in errs[:10]: print("  ", e)
    sys.exit(0)
# run: 복제 패키지로 81 조회 → 금액 메저 행 확인
import datetime
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
proc, user, div, ver = sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME=:1 AND OBJECT_NAME=:2 AND DATA_LEVEL=0 ORDER BY POSITION", [CL, proc])
P = {"P_DIVISION_ID": div, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
     "P_FROM_YYYYMMDD": frm.strftime("%Y%m%d"), "P_TO_YYYYMMDD": to.strftime("%Y%m%d"),
     "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": ver, "P_QTY_YN": "N",
     "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN", "P_PLANT_SITE_ID": "ALL",
     "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
ins, outs = [], []
for a_, io_ in cur.fetchall():
    (ins.append(P[a_]) if io_ == "IN" else outs.append(cn.cursor()))
t0 = time.time(); cur.callproc(f"{CL}.{proc}", ins + outs); t1 = time.time()
rows = outs[0].fetchall(); cols = [c[0] for c in outs[0].description]
res = outs[-1].fetchall()
cn.rollback()
mi = cols.index("MEASURE")
amt = [r for r in rows if r[mi] in ("MKT_AMT_KRW", "MKT_AMT_LOC")]
print(f"SP {t1-t0:.1f}s  RC1 {len(rows)}행  금액 메저 행 {len(amt)}  결과커서 {res}")
print("컬럼:", cols)
for r in amt[:4]: print(r)
import pickle
(HERE / f"t01_run_{proc[-4:]}_{user}_{div}.pkl").write_bytes(pickle.dumps((cols, rows)))
