#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 (MKT FCST) 클라우드 이관 패키지 생성 (2026-08-16).

⭐ 축 수집은 **딕셔너리 기계 전수 스윕**만 사용한다 (룰: 손나열 ⛔).
   손나열이 컬럼명을 잘못 짚어 축을 조용히 스킵한 사고(2026-08-14 DMF0082/DMF0014) 재발 방지.
   ALL_TAB_COLUMNS 로 SCM_ADM_* 전 테이블 × 전 문자형 컬럼을 훑어 'DMF0003' 을 담은 축을
   기계적으로 찾는다. 서베이 쿼리 실패 시 **즉시 중단**(SKIP 금지).

⚠ 스윕만으로는 못 잡는 축 = **화면 ID 문자열이 없는 것**. 아래 2종은 명시 동봉한다:
   · LOOKUP `MKT_FCST_MEASURE`(82) 제외 마킹 — 통합테스트 1st No.52
   · GRANT `SCM_MGR.TB_FX_USER` → 앱 계정 — 셀 콤보 5종 -9994 정정 (2026-08-15)
"""
import io, pathlib, shutil, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKG = ROOT / "_artifacts" / "_deploy_packages" / "DMF0003_CLOUD_20260816"
A_DB, B_FE = PKG / "A_DB", PKG / "B_FE"
for p in (A_DB, B_FE):
    p.mkdir(parents=True, exist_ok=True)

u, p_, d = conn_info()
con = oracledb.connect(user=u, password=p_, dsn=d)
cur = con.cursor()

# ── 1) DB 객체 원문 (사내 현재본 = 정본) ────────────────────────────────────
def dump(name, otype, fname, note):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1
                   AND TYPE=:2 ORDER BY LINE""", [name, otype])
    rows = cur.fetchall()
    if not rows:
        sys.exit(f"⛔ {name} ({otype}) 원문 0줄 — 중단")
    src = "".join(r[0] for r in rows).rstrip()
    (A_DB / fname).write_text(
        f"-- {note}\n-- 원천 = 사내 SCM_MGR (2026-08-16 적용본)\nSET DEFINE OFF\n\n"
        f"CREATE OR REPLACE {src}\n/\nSHOW ERRORS\n", encoding="utf-8")
    print(f"  [DB] {fname:<46} {len(rows):>6} lines")
    return src

dump("PKG_DMF0003", "PACKAGE", "01_PKG_DMF0003_SPEC.sql", "DMF0003 패키지 스펙")
body = dump("PKG_DMF0003", "PACKAGE BODY", "02_PKG_DMF0003_BODY.sql",
            "DMF0003 패키지 본문 — 마커 5종 "
            "(SAVEPERF/SAVEPERF2 저장튜닝 · ASFROMNULL AS From Site NULL · "
            "SENTINEL 조회 센티널 정규화+dedup · PIVOTDATE RP 롤업 배수 정정)")

# 마커 자급 ASSERT — 본문에 이번 정정이 실제로 들어있는지 (빈 껍데기 이관 차단)
MARKERS = ["E20260815-SAVEPERF", "E20260815-SAVEPERF2", "E20260815-ASFROMNULL",
           "E20260815-SENTINEL", "E20260815-PIVOTDATE"]
missing = [m for m in MARKERS if m not in body]
if missing:
    sys.exit(f"⛔ BODY 에 마커 누락 {missing} — 정정 미반영본 이관 위험, 중단")
print(f"       [ASSERT] 마커 {len(MARKERS)}종 전부 포함 확인")

# ── 2) 메타 축 — 딕셔너리 전수 스윕 ─────────────────────────────────────────
print("\n[SWEEP] SCM_ADM_* 문자형 컬럼 전수 스캔")
cur.execute("""SELECT c.TABLE_NAME, c.COLUMN_NAME
               FROM   ALL_TAB_COLUMNS c
               JOIN   ALL_TABLES t ON t.OWNER=c.OWNER AND t.TABLE_NAME=c.TABLE_NAME
               WHERE  c.OWNER='SCM_MGR'
               AND    c.TABLE_NAME LIKE 'SCM\\_ADM\\_%' ESCAPE '\\'
               AND    c.DATA_TYPE IN ('VARCHAR2','CHAR','NVARCHAR2')
               ORDER BY c.TABLE_NAME, c.COLUMN_ID""")
pairs = cur.fetchall()
print(f"  대상 {len(set(t for t, _ in pairs))} 테이블 / {len(pairs)} 컬럼")

hits = {}
for tab, col in pairs:
    try:
        cur.execute(f'SELECT COUNT(*) FROM "SCM_MGR"."{tab}" WHERE "{col}" LIKE :1', ['%DMF0003%'])
        n = cur.fetchone()[0]
    except Exception as ex:
        sys.exit(f"⛔ 서베이 실패 {tab}.{col}: {ex} — SKIP 금지, 중단")
    if n:
        hits.setdefault(tab, []).append((col, n))

# ⭐ 이관 제외 — 스윕은 "찾는" 도구이지 "가르는" 도구가 아니다. 아래는 **사유 있는 제외**이며
#   조용히 빠지지 않도록 전부 출력하고 SQL 헤더에도 남긴다(누락 은폐 금지).
EXCLUDE = {
    "SCM_ADM_BTNMPG_BAK_DMF0003_RENAME":  "백업 테이블 — 클라우드 미존재. 이관 대상 아님",
    "SCM_ADM_UGBTN_BAK_DMF0003_RENAME":   "백업 테이블 — 클라우드 미존재. 이관 대상 아님",
    "SCM_ADM_PROC_M_BAK_20260612_153917": "백업 테이블(일자 스냅샷) — 이관 대상 아님",
    "SCM_ADM_LOOKUP_MASTER_DETAIL_H":     "이력(History) 테이블 — 원장이 아니라 변경 이력. 이관 대상 아님",
    "SCM_ADM_SMS_MAIL_SEND_LOG":          "발송 로그 — 런타임 산출물. 이관 대상 아님",
    "SCM_ADM_USER_MNU_SRCH_COND_M":       "사용자 개인화 조회조건 — 계정별 데이터라 환경 간 이관 금지(TITLESET_USER 동일 규약)",
}
excluded = {t: hits.pop(t) for t in list(hits) if t in EXCLUDE}
print(f"\n[EXCLUDE] 사유 있는 제외 {len(excluded)} 테이블")
for t in sorted(excluded):
    print(f"   ⊘ {t:<36} {EXCLUDE[t]}")

print(f"\n[HIT] DMF0003 을 담은 이관 축 {len(hits)} 테이블")
for tab in sorted(hits):
    print(f"   {tab:<36} " + ", ".join(f"{c}({n})" for c, n in hits[tab]))

# ⚠ 파생 메뉴(DMF0003_1 / DMF0003_T) 동반 여부 — 사용자 범위 제외 메뉴지만
#   LIKE 매칭상 함께 잡힌다. 삭제범위=삽입범위라 정합은 유지되나 보고서에 명시한다.
cur.execute("""SELECT MNU_ID, COUNT(*) FROM SCM_ADM_MNU_M
                WHERE MNU_ID LIKE '%DMF0003%' GROUP BY MNU_ID ORDER BY 1""")
menus = cur.fetchall()
print(f"  ↳ 매칭 메뉴: {menus}")

# ── 3) 메타 INSERT 생성 — 감사컬럼 'admin' 고정 ─────────────────────────────
def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    s = v.read() if hasattr(v, "read") else str(v)
    return "'" + s.replace("'", "''") + "'"

AUDIT = {"CREATED_BY", "LAST_UPDATED_BY"}
DATECOL = {"CREATION_DATE", "LAST_UPDATE_DATE"}

sql_lines, total = [], 0
for tab in sorted(hits):
    cols_with_hits = [c for c, _ in hits[tab]]
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS
                   WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1 ORDER BY COLUMN_ID""", [tab])
    meta = cur.fetchall()
    allcols = [c for c, _ in meta]
    dtype = dict(meta)
    where = " OR ".join(f'"{c}" LIKE \'%DMF0003%\'' for c in cols_with_hits)
    cur.execute(f'SELECT {",".join(chr(34)+c+chr(34) for c in allcols)} '
                f'FROM "SCM_MGR"."{tab}" WHERE {where}')
    rows = cur.fetchall()
    total += len(rows)
    sql_lines.append(f"\n-- ═══ {tab} ({len(rows)} rows) — 매칭 컬럼: {', '.join(cols_with_hits)}")
    sql_lines.append(f"DELETE FROM {tab} WHERE {where};")
    for r in rows:
        vals = []
        for c, v in zip(allcols, r):
            if c in AUDIT:
                vals.append("'admin'")
            elif c in DATECOL or dtype.get(c) == "DATE":
                vals.append("SYSDATE")
            else:
                vals.append(lit(v))
        sql_lines.append(f"INSERT INTO {tab} ({', '.join(allcols)}) VALUES ({', '.join(vals)});")

(A_DB / "10_META_DMF0003_ALL_AXES.sql").write_text(
    "-- DMF0003 메타 전 축 (딕셔너리 전수 스윕 산출 — 손나열 아님)\n"
    "-- 감사컬럼 = 'admin' 고정 / 날짜 = SYSDATE\n"
    "-- 각 축은 DELETE(동일 조건) → INSERT 로 멱등. 삭제범위 = 삽입범위.\n"
    f"-- ⚠ LIKE '%DMF0003%' 라 파생 메뉴({', '.join(m[0] for m in menus)}) 행도 함께 포함된다.\n"
    + "".join(f"-- ⊘ 제외: {t} — {EXCLUDE[t]}\n" for t in sorted(excluded))
    + "SET DEFINE OFF\n" + "\n".join(sql_lines) + "\n\nCOMMIT;\n", encoding="utf-8")
print(f"\n  [META] 10_META_DMF0003_ALL_AXES.sql — {total} rows / {len(hits)} 축")

# ── 4) 스윕이 못 잡는 축 (화면 ID 문자열 없음) ──────────────────────────────
cur.execute("""SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, ATTRIBUTE2
                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE='MKT_FCST_MEASURE' AND VALID_YN='Y'
                ORDER BY SEGMENT1, SEGMENT2""")
lk = cur.fetchall()
ex82 = [r[2] for r in lk if r[1] == '82' and str(r[3] or '') == 'Y']
lines = ["-- 통합테스트 1st No.52 — 82 Div Measure 후보 제외 마킹 (ATTRIBUTE2='Y')",
         "--   행 삭제가 아니라 제외 마킹 = AS-IS 데이터 보존 + FE 후보 필터",
         f"--   제외 대상(사내 실측 2026-08-16): {ex82}",
         "--   적용 후 82 선택가능 = MKT_FCST_RP / VMI_In_Req / AS_In_Req 3종",
         "SET DEFINE OFF", ""]
for r in lk:
    if r[1] == '82':
        lines.append(
            "UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL SET ATTRIBUTE2 = %s, LAST_UPDATED_BY='admin', "
            "LAST_UPDATE_DATE=SYSDATE\n WHERE LOOKUP_TYPE='MKT_FCST_MEASURE' AND SEGMENT1='82' "
            "AND SEGMENT2=%s;" % (lit(r[3]), lit(r[2])))
lines.append("\nCOMMIT;")
(A_DB / "11_LOOKUP_MKT_FCST_MEASURE_82.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"  [META] 11_LOOKUP_MKT_FCST_MEASURE_82.sql — 82 {len([r for r in lk if r[1]=='82'])}행 (제외 {len(ex82)})")

# GRANT — 환경별 앱 계정 3종 전부 커버 (계정명 가정 금지 룰)
(A_DB / "12_GRANT_TB_FX_USER.sql").write_text("""-- SCM_MGR.TB_FX_USER SELECT 권한 — 앱 계정
-- [증상] 셀 콤보 5종이 code=-9994 "Sql Error" 로 조용히 실패 → 그리드가 CODE 를 raw 로 표시
--        TeambyDivisionAuth / SiteByEndCustomerAuth / EndCustomerByDivisionDeptAuth
--        / TeambyDivision / TeambyDivision2
-- [원인] 사내 실측 2026-08-15 — 권한이 SCMD_APP 에만 부여. 시노님은 있으나 시노님은 권한을 주지 않는다.
-- [적용] 환경별 앱 계정이 다르므로(사내 SCMD_APP / QA SCMQ_APP / DEV·운영 SCMP_APP)
--        존재하는 계정 전부에 부여한다. SCM_MGR 로 실행.
SET SERVEROUTPUT ON
BEGIN
  FOR r IN (SELECT USERNAME FROM ALL_USERS
             WHERE USERNAME IN ('SCMD_APP','SCMQ_APP','SCMP_APP')) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.TB_FX_USER TO ' || r.USERNAME;
    DBMS_OUTPUT.PUT_LINE('GRANT SELECT ON SCM_MGR.TB_FX_USER TO ' || r.USERNAME);
  END LOOP;
END;
/
-- 검증 (SCMx_APP 행이 SELECT 로 나와야 한다)
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS
 WHERE OWNER='SCM_MGR' AND TABLE_NAME='TB_FX_USER' ORDER BY 1,2;
""", encoding="utf-8")
print("  [GRANT] 12_GRANT_TB_FX_USER.sql")

# ── 5) 검증 스크립트 ────────────────────────────────────────────────────────
verify = ["-- DMF0003 이관 검증", "SET LINESIZE 200", "SET PAGESIZE 200",
          "PROMPT === 1. 객체 상태 (VALID 여야 함) ===",
          "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS",
          " WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0003';",
          "PROMPT === 2. 컴파일 오류 (0건이어야 함) ===",
          "SELECT COUNT(*) ERRCNT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003';",
          "PROMPT === 3. 정정 마커 (5종 전부 존재해야 함) ==="]
for m in MARKERS:
    verify.append(f"SELECT '{m}' MARKER, COUNT(*) CNT FROM ALL_SOURCE"
                  f" WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY'"
                  f" AND TEXT LIKE '%{m}%';")
verify.append("PROMPT === 4. 메타 축별 건수 ===")
for tab in sorted(hits):
    where = " OR ".join(f"{c} LIKE '%DMF0003%'" for c, _ in hits[tab])
    verify.append(f"SELECT '{tab}' AXIS, COUNT(*) CNT FROM {tab} WHERE {where};")
verify += ["PROMPT === 5. No.52 82 Measure 후보 (3종이어야 함) ===",
           "SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL",
           " WHERE LOOKUP_TYPE='MKT_FCST_MEASURE' AND SEGMENT1='82' AND VALID_YN='Y'",
           " AND NVL(ATTRIBUTE2,'N') <> 'Y' ORDER BY 1;",
           "PROMPT === 6. TB_FX_USER 권한 (앱 계정 행 존재해야 함) ===",
           "SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS",
           " WHERE OWNER='SCM_MGR' AND TABLE_NAME='TB_FX_USER' ORDER BY 1,2;"]
(A_DB / "90_VERIFY.sql").write_text("\n".join(verify) + "\n", encoding="utf-8")
print("  [DB] 90_VERIFY.sql")

# ── 6) FE — 수정 파일이 있는 폴더 전체 (부분 이관 금지) ─────────────────────
FE_UNITS = [
    ("nscm-fe/features/demand/src/pages/mkt-fcst", "mkt-fcst"),
    ("nscm-fe/packages/foundation/src/utils",      "foundation-utils"),
    # ⭐ [2026-08-16] 전 화면 조회조건 콤보의 **옵션 중복 제거** 공통 지점.
    #   CMBO SQL 이 cascade 용 부가 컬럼(DEPT_ID 등)까지 반환해 같은 CODE 가 여러 행으로 오고,
    #   화면별로 dedupe 가 있으면 1개·없으면 N개로 갈렸다(클라우드 DMF0003 End Customer 'LGE' 2회).
    #   ⚠ 공용 컴포넌트라 **DMF0003 외 전 화면에 영향**한다 — 적용 시 함께 회귀 확인할 것.
    ("nscm-fe/packages/shared/src/components/molecules/customDropdown", "shared-customDropdown"),
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
    if "pages/" in rel:
        # 2026-08-14 "Page Not Found" 사고 재발 방지 — viewRegistry 등록키
        assert (tgt / "index.ts").exists(), f"⛔ {dest}/index.ts 누락 — viewRegistry 등록키 소실"
        print("       [ASSERT] index.ts 포함 확인")

con.close()

lines = ["# DMF0003 클라우드 이관 파일 목록", ""]
for f in sorted(PKG.rglob("*")):
    if f.is_file():
        lines.append(f"- `{f.relative_to(PKG).as_posix()}`  ({f.stat().st_size:,} bytes)")
(PKG / "_FILELIST.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"\n[DONE] {PKG}")
print(f"  총 {sum(1 for f in PKG.rglob('*') if f.is_file())} 파일")
