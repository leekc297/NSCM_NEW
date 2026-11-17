# [E20261109-ALLBUCKET] 사내 ZIOUI1 적용 — FRESH-GATE(적용 직전 ALL_SOURCE 재조회 == 착수 기준본) → spec/body 컴파일 → PROC_M sumYn 등록
#   사용: python apply_corp.py apply | rollback
#   rollback = 00_BACKUP_ASIS 원문 재컴파일 + PROC_M sumYn 제거·OUT 순번 원복 (ASIS 는 fetch_fresh.py 착수 조회본)
import sys, pathlib, datetime, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics'); import ora

W = pathlib.Path(__file__).resolve().parent
ASIS, TOBE = W / "00_BACKUP_ASIS", W / "02_TOBE"  # 사용자 지시 18:23 — Sum 파라미터 철회본
# 사용자 지시 2026-11-09 18:23 "SUM 은 이미 존재 — 3개 BUCKET 데이터만" → BODY 2개만 (spec·BIZ·PROC_M 무변경)
OBJS = [("PKG_DMF0035", "PACKAGE BODY"), ("PKG_DMF0022", "PACKAGE BODY")]
APPLY_PROC_M = False
# PROC_M: 마지막 IN 다음(= 첫 OUT 위치)에 sumYn — OUT 행은 +1
PROCS = {"PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE": 6,
         "PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE": 8,
         "PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE": 8}

u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")


def now(): return f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"


def fetch(name, typ):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return "".join(r[0] for r in cur.fetchall())


def meta(name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
    return cur.fetchone()


def compile_src(name, typ, src):
    cur.execute("CREATE OR REPLACE " + src.replace("\r", ""))
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=name, t=typ)
    errs = cur.fetchall()
    print(f"{now()} COMPILED {name} {typ} -> {meta(name, typ)} errors={len(errs)}")
    for e in errs[:20]: print("   ", e)
    return len(errs) == 0


mode = sys.argv[1]
if mode == "apply":
    # FRESH-GATE — 착수 조회본과 1바이트라도 다르면 중단 (hook #152 §3.3)
    for name, typ in OBJS:
        base = (ASIS / f"{name}.{typ.replace(' ', '_')}.ASIS.sql").read_text(encoding="utf-8")
        nowsrc = fetch(name, typ)
        assert nowsrc == base, f"FRESH-GATE 실패: {name} {typ} 착수 후 DB 원문 변경 — 중단·재조회·재병합"
        print(f"{now()} FRESH-GATE PASS {name} {typ} {meta(name, typ)}")
    ok = True
    for name, typ in OBJS:
        ok &= compile_src(name, typ, (TOBE / f"{name}.{typ.replace(' ', '_')}.TOBE.sql").read_text(encoding="utf-8"))
    for name, typ in OBJS:
        assert fetch(name, typ) == (TOBE / f"{name}.{typ.replace(' ', '_')}.TOBE.sql").read_text(encoding="utf-8"), f"적용본 != DB 원문 {name} {typ}"
    print(f"{now()} 적용본 == DB 원문 {len(OBJS)}/{len(OBJS)}")
    if not ok:
        sys.exit("컴파일 오류 — PROC_M 미변경 · rollback 실행 필요")
    for proc, pos in (PROCS.items() if APPLY_PROC_M else []):
        cur.execute("SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM=:p AND COL_NM='sumYn'", p=proc)
        if cur.fetchone()[0]:
            print(f"SKIP PROC_M {proc} sumYn 이미 있음"); continue
        cur.execute("UPDATE SCM_ADM_PROC_M SET SORT_ORD = SORT_ORD + 1, LAST_UPDATED_BY='E20261109-ALLBUCKET', LAST_UPDATE_DATE=SYSDATE WHERE PROC_NM=:p AND SORT_ORD >= :s", p=proc, s=pos)
        n_up = cur.rowcount
        cur.execute("INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
                    "VALUES (:p, 'sumYn', 'VARCHAR', 'IN', :s, 'E20261109-ALLBUCKET', SYSDATE, 'E20261109-ALLBUCKET', SYSDATE)", p=proc, s=pos)
        print(f"{now()} PROC_M {proc}: OUT {n_up}행 +1 · sumYn INSERT SORT_ORD={pos}")
    con.commit()
elif mode == "rollback":
    for name, typ in OBJS:
        compile_src(name, typ, (ASIS / f"{name}.{typ.replace(' ', '_')}.ASIS.sql").read_text(encoding="utf-8"))
    for proc, pos in PROCS.items():
        cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p AND COL_NM='sumYn'", p=proc)
        if cur.rowcount:
            cur.execute("UPDATE SCM_ADM_PROC_M SET SORT_ORD = SORT_ORD - 1 WHERE PROC_NM=:p AND SORT_ORD > :s", p=proc, s=pos)
        print(f"{now()} PROC_M {proc} 원복")
    con.commit()

# 사후 점검: PROC_M ↔ ALL_ARGUMENTS 위치별 대조 + 의존 INVALID
for proc in PROCS:
    pkg, obj = proc.split(".")
    cur.execute("SELECT POSITION, ARGUMENT_NAME FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:k AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION", k=pkg, o=obj)
    args = cur.fetchall()
    cur.execute("SELECT SORT_ORD, COL_NM, COL_TP_CD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=proc)
    pm = cur.fetchall()
    print(f"CHECK {proc}: ARGS {len(args)} / PROC_M {len(pm)} -> {'PASS' if len(args) == len(pm) and [a[0] for a in args] == [r[0] for r in pm] else 'FAIL'}")
    for a, r in zip(args, pm): print(f"    {a[0]:>2} {a[1]:<18} | {r[0]:>2} {r[1]:<16} {r[2]}")
cur.execute("SELECT OBJECT_TYPE, OBJECT_NAME FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')")
cur.execute("SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE COL_NM='sumYn'"); print('PROC_M sumYn 잔존:', cur.fetchone()[0])
print("INVALID:", cur.fetchall())
