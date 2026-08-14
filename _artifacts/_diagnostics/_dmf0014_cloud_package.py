#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 클라우드 이관 패키지 생성 (2026-08-14).

⭐ 축 수집은 **딕셔너리 기계 전수 스윕**만 사용한다 (룰: 손나열 ⛔).
   2026-08-14 DMF0082 사고 계보 — 손나열이 컬럼명을 잘못 짚어 BTN 축을 조용히 스킵했고,
   그 결과 클라우드에서 Excel Form 버튼이 보이지 않았다.
   ⇒ ALL_TAB_COLUMNS 로 **모든 SCM_ADM_* 테이블 × 모든 문자형 컬럼**을 훑어
     'DMF0014' 를 담은 축을 기계적으로 찾는다. 서베이 쿼리가 실패하면 **즉시 중단**(SKIP 금지).
"""
import io, pathlib, shutil, sys, subprocess
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKG = ROOT / "_artifacts" / "_deploy_packages" / "DMF0014_CLOUD_20260814"
A_DB, B_FE, C_FE = PKG / "A_DB", PKG / "B_FE", PKG / "C_BE"
for p in (A_DB, B_FE, C_FE):
    p.mkdir(parents=True, exist_ok=True)

u, p_, d = conn_info()
con = oracledb.connect(user=u, password=p_, dsn=d)
cur = con.cursor()

# ─────────────────────────────────────────────────────────────────────────────
# 1) DB 객체 원문 (SP/PKG) — 사내 현재본이 정본
# ─────────────────────────────────────────────────────────────────────────────
def dump(name, otype, fname, note):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1
                   AND TYPE=:2 ORDER BY LINE""", [name, otype])
    rows = cur.fetchall()
    if not rows:
        sys.exit(f"⛔ {name} ({otype}) 원문 0줄 — 중단")
    src = "".join(r[0] for r in rows).rstrip()
    (A_DB / fname).write_text(
        f"-- {note}\n-- 원천 = 사내 SCM_MGR (2026-08-14 적용본)\nSET DEFINE OFF\n\n"
        f"CREATE OR REPLACE {src}\n/\nSHOW ERRORS\n", encoding="utf-8")
    print(f"  [DB] {fname:<52} {len(rows):>5} lines")

dump("PKG_DMF0014", "PACKAGE",      "01_PKG_DMF0014_SPEC.sql",
     "DMF0014 패키지 스펙")
dump("PKG_DMF0014", "PACKAGE BODY", "02_PKG_DMF0014_BODY.sql",
     "DMF0014 패키지 본문 — Excel Form(V8 실조합) + 1단 헤더 업로드 + 허위성공 차단 가드")
dump("PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "PROCEDURE",
     "03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql",
     "후속 연계 SP — SELECT INTO 2종 정정(ORA-01422 GTT 초기화 / ORA-01403 핸들러)")

# ─────────────────────────────────────────────────────────────────────────────
# 2) 메타 축 — 딕셔너리 전수 스윕
# ─────────────────────────────────────────────────────────────────────────────
print("\n[SWEEP] SCM_ADM_* 문자형 컬럼 전수 스캔")
cur.execute("""SELECT c.TABLE_NAME, c.COLUMN_NAME
               FROM   ALL_TAB_COLUMNS c
               JOIN   ALL_TABLES t ON t.OWNER=c.OWNER AND t.TABLE_NAME=c.TABLE_NAME
               WHERE  c.OWNER='SCM_MGR'
               AND    c.TABLE_NAME LIKE 'SCM\\_ADM\\_%' ESCAPE '\\'
               AND    c.DATA_TYPE IN ('VARCHAR2','CHAR','NVARCHAR2')
               ORDER BY c.TABLE_NAME, c.COLUMN_ID""")
pairs = cur.fetchall()
print(f"  대상 {len(set(t for t,_ in pairs))} 테이블 / {len(pairs)} 컬럼")

hits = {}
for tab, col in pairs:
    try:
        cur.execute(f'SELECT COUNT(*) FROM "SCM_MGR"."{tab}" WHERE "{col}" LIKE :1', ['%DMF0014%'])
        n = cur.fetchone()[0]
    except Exception as ex:
        sys.exit(f"⛔ 서베이 실패 {tab}.{col}: {ex} — SKIP 금지, 중단")
    if n:
        hits.setdefault(tab, []).append((col, n))

print(f"\n[HIT] DMF0014 를 담은 축 {len(hits)} 테이블")
for tab in sorted(hits):
    print(f"   {tab:<34} " + ", ".join(f"{c}({n})" for c, n in hits[tab]))

# ─────────────────────────────────────────────────────────────────────────────
# 3) 메타 INSERT 생성 — 감사컬럼 'admin' 고정
# ─────────────────────────────────────────────────────────────────────────────
def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    s = str(v)
    if hasattr(v, "read"):
        s = v.read()
    return "'" + s.replace("'", "''") + "'"

AUDIT = {"CREATED_BY", "LAST_UPDATED_BY"}
DATECOL = {"CREATION_DATE", "LAST_UPDATE_DATE"}

sql_lines = []
for tab in sorted(hits):
    cols_with_hits = [c for c, _ in hits[tab]]
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS
                   WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1 ORDER BY COLUMN_ID""", [tab])
    meta = cur.fetchall()
    allcols = [c for c, _ in meta]
    dtype = dict(meta)
    where = " OR ".join(f'"{c}" LIKE \'%DMF0014%\'' for c in cols_with_hits)
    cur.execute(f'SELECT {",".join(chr(34)+c+chr(34) for c in allcols)} '
                f'FROM "SCM_MGR"."{tab}" WHERE {where}')
    rows = cur.fetchall()
    sql_lines.append(f"\n-- ═══ {tab} ({len(rows)} rows) — 매칭 컬럼: {', '.join(cols_with_hits)}")
    sql_lines.append(f"DELETE FROM {tab} WHERE {where};")
    for r in rows:
        vals = []
        for c, v in zip(allcols, r):
            if c in AUDIT:
                vals.append("'admin'")            # 감사컬럼은 'admin' 만 (룰)
            elif c in DATECOL or dtype.get(c) == "DATE":
                vals.append("SYSDATE")
            else:
                vals.append(lit(v))
        sql_lines.append(f"INSERT INTO {tab} ({', '.join(allcols)}) VALUES ({', '.join(vals)});")

(A_DB / "10_META_DMF0014_ALL_AXES.sql").write_text(
    "-- DMF0014 메타 전 축 (딕셔너리 전수 스윕 산출 — 손나열 아님)\n"
    "-- 감사컬럼 = 'admin' 고정 / 날짜 = SYSDATE\n"
    "-- 각 축은 DELETE(동일 조건) → INSERT 로 멱등\n"
    "SET DEFINE OFF\n" + "\n".join(sql_lines) + "\n\nCOMMIT;\n", encoding="utf-8")
print(f"\n  [META] 10_META_DMF0014_ALL_AXES.sql — {sum(len(v) for v in hits.values())} 컬럼히트")

# ─────────────────────────────────────────────────────────────────────────────
# 4) 검증 스크립트
# ─────────────────────────────────────────────────────────────────────────────
verify = ["-- DMF0014 이관 검증", "SET LINESIZE 200", "SET PAGESIZE 100",
          "PROMPT === 객체 상태 ===",
          "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS",
          " WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST');",
          "PROMPT === 컴파일 오류 (0이어야 함) ===",
          "SELECT NAME, COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR'",
          " AND NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST') GROUP BY NAME;",
          "PROMPT === 메타 축별 건수 ==="]
for tab in sorted(hits):
    where = " OR ".join(f"{c} LIKE '%DMF0014%'" for c, _ in hits[tab])
    verify.append(f"SELECT '{tab}' AXIS, COUNT(*) CNT FROM {tab} WHERE {where};")
(A_DB / "90_VERIFY.sql").write_text("\n".join(verify) + "\n", encoding="utf-8")
print("  [DB] 90_VERIFY.sql")

# ─────────────────────────────────────────────────────────────────────────────
# 5) FE / BE — **수정 파일이 있는 폴더 전체**
# ─────────────────────────────────────────────────────────────────────────────
FE_UNITS = [
    ("nscm-fe/features/demand/src/pages/customer-fcst-upload", "customer-fcst-upload"),
    ("nscm-fe/packages/foundation/src/utils",                  "foundation-utils"),
]
for rel, dest in FE_UNITS:
    src = ROOT / rel
    if not src.exists():
        sys.exit(f"⛔ FE 경로 없음: {rel}")
    tgt = B_FE / dest
    if tgt.exists():
        shutil.rmtree(tgt)
    shutil.copytree(src, tgt)
    n = sum(1 for _ in tgt.rglob("*") if _.is_file())
    print(f"  [FE] {rel}  → {n} files")
    # index.ts 자급 ASSERT (2026-08-14 Page Not Found 사고 재발 방지)
    if "pages/" in rel:
        assert (tgt / "index.ts").exists(), f"⛔ {dest}/index.ts 누락 — viewRegistry 등록키 소실"
        print(f"       [ASSERT] index.ts 포함 확인")

BE_FILE = ROOT / "nscm-be/src/main/java/com/lgcns/nscm/general/file/FileServiceImpl.java"
shutil.copy2(BE_FILE, C_FE / "FileServiceImpl.java")
print(f"  [BE] FileServiceImpl.java")

con.close()

# ─────────────────────────────────────────────────────────────────────────────
# 6) FILELIST
# ─────────────────────────────────────────────────────────────────────────────
lines = ["# DMF0014 클라우드 이관 파일 목록", ""]
for f in sorted(PKG.rglob("*")):
    if f.is_file():
        lines.append(f"- `{f.relative_to(PKG).as_posix()}`  ({f.stat().st_size:,} bytes)")
(PKG / "_FILELIST.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"\n[DONE] {PKG}")
print(f"  총 {sum(1 for f in PKG.rglob('*') if f.is_file())} 파일")
