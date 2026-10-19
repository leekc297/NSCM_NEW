# -*- coding: utf-8 -*-
"""GET_MAIN_DATA 결과 동등성·시간 비교 — 패키지 A vs B, 6개 OUT 커서 전 행 정렬 SHA-256 + 행수, 사용자 지정.

화면 파라미터 = FE 원문(미선택 'ALL', itemId NULL, userGroup=ADMIN, 기간=당월1일~+6개월-1일, versionType=Current, qtyYn=N).
각 패키지 warm 1회 후 N회 측정. 해시 = 각 행 repr 정렬 후 sha256 (행 순서 무관) + 순서 해시 별도.
MF_SP INSERT 문장(L4182 부근 'INSERT INTO SCM_MGR.GT_DMF0082_MF_SP')의 1회 소요·PHV·계획 lateral 여부도 패키지별로 출력.
사용: python v01_compare_user.py <div> <user> <pkgA> <pkgB> [N=2]
"""
import datetime, hashlib, io, pathlib, sys, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV, USER, PA, PB = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
N = int(sys.argv[5]) if len(sys.argv) > 5 else 2
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
IN = [DIV, "ALL", "ALL", "ALL", frm.strftime("%Y%m%d"), to.strftime("%Y%m%d"), "ALL", None, "Current", "N",
      USER, "ADMIN", "ALL", "ALL", "ALL", "ALL"]

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()


def body_id(pkg):
    cur.execute("SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg)
    return cur.fetchone()[0]


def mfsp_stmt(pkg):
    """해당 패키지의 MF_SP INSERT 자식 커서 (가장 최근 활동) — SQL_ID·PHV·1회 초·행·lateral 여부."""
    cur.execute("""SELECT S.SQL_ID, S.CHILD_NUMBER, S.PLAN_HASH_VALUE, S.EXECUTIONS, ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1),2),
                          ROUND(S.CPU_TIME/1e6/GREATEST(S.EXECUTIONS,1),2), ROUND(S.ROWS_PROCESSED/GREATEST(S.EXECUTIONS,1)), S.PROGRAM_LINE#,
                          (SELECT COUNT(*) FROM V$SQL_PLAN P WHERE P.SQL_ID=S.SQL_ID AND P.CHILD_NUMBER=S.CHILD_NUMBER AND P.OBJECT_NAME LIKE 'VW_LAT%') LAT,
                          (SELECT LISTAGG(P.OPERATION||' '||NVL(P.OPTIONS,''), ' > ') WITHIN GROUP (ORDER BY P.ID) FROM V$SQL_PLAN P
                            WHERE P.SQL_ID=S.SQL_ID AND P.CHILD_NUMBER=S.CHILD_NUMBER AND P.ID BETWEEN 6 AND 9) OPS
                     FROM V$SQL S WHERE S.PROGRAM_ID=:b AND UPPER(S.SQL_TEXT) LIKE 'INSERT%INTO SCM_MGR.GT_DMF0082_MF_SP (%'
                    ORDER BY S.LAST_ACTIVE_TIME DESC FETCH FIRST 1 ROWS ONLY""", b=body_id(pkg))
    return cur.fetchone()


def run(pkg):
    outs = [cn.cursor() for _ in range(6)]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", IN + outs)
    t1 = time.time()
    res = []
    for oc in outs:
        oc.arraysize = 5000
        rows = oc.fetchall()
        cols = [c[0] for c in oc.description] if oc.description else []
        rs = [repr(tuple(r)) for r in rows]
        res.append((len(rows), hashlib.sha256("\n".join(sorted(rs)).encode()).hexdigest()[:16],
                    hashlib.sha256("\n".join(rs).encode()).hexdigest()[:16], len(cols)))
    t2 = time.time()
    cn.rollback()
    return t1 - t0, t2 - t1, res


print(f"div={DIV} user={USER} 기간 {IN[4]}~{IN[5]}  {PA} vs {PB}  N={N}")
out = {}
for pkg in (PA, PB):
    run(pkg)  # warm
    ts = []
    for _ in range(N):
        sp, fe, res = run(pkg)
        ts.append(sp)
    out[pkg] = res
    st = mfsp_stmt(pkg)
    print(f"{pkg:18} SP {' / '.join(f'{t:.2f}' for t in ts)}s  (fetch {fe:.2f}s)")
    if st:
        print(f"    MF_SP INSERT {st[0]}/{st[1]} PHV={st[2]} ex={st[3]} sec/ex={st[4]} cpu/ex={st[5]} rows/ex={st[6]} line={st[7]} VW_LAT={st[8]} ops6-9=[{st[9]}]")
    for i, r in enumerate(res):
        print(f"    cur{i + 1}: rows={r[0]:>6} cols={r[3]:>4} sortedSHA={r[1]} orderSHA={r[2]}")
TIMEDEP = {2}  # cur3 = SYSDATE 기반 → 행수·컬럼수만
same = all((a[0] == b[0] and a[3] == b[3]) if i in TIMEDEP else (a[:2] == b[:2] and a[3] == b[3])
           for i, (a, b) in enumerate(zip(out[PA], out[PB])))
order = all(a[2] == b[2] for i, (a, b) in enumerate(zip(out[PA], out[PB])) if i not in TIMEDEP)
print(f"\n결과 동등성(행수+정렬해시+컬럼수): {'PASS' if same else 'FAIL'}   행 순서까지: {'PASS' if order else 'DIFF'}")
cn.close()
