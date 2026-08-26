# -*- coding: utf-8 -*-
"""DMF0035 SALES/BIZ PKG 성능개선 **델타** 이관 패키지 생성 (파일 생성 + 사내 SELECT 검증만).

범위: 2026-08-20~21 튜닝으로 바뀐 것은 **PKG BODY 2본뿐**이다(메타·DDL·FE 변경 0).
  · PKG_DMF0022 : [E20260820-D22PREREDUCE] 2 + [E20260820-D22VERPUSH] 2
  · PKG_DMF0051 : [E20260820-D51SCALAR] + [D51REGROUP] + [D51SEMI] + [D51ITEMPFX] 각 1
따라서 전체 패키지 재적용이 아니라 **BODY 2본 + 검증**만 담은 델타로 만든다(재적용 범위 최소화).
"""
import hashlib
import io
import re
import shutil
import sys
from pathlib import Path

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

SRC = Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB")
DST = Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_PERF_SALESBIZ_20260821")
(DST / "A_DB").mkdir(parents=True, exist_ok=True)

FILES = ["15_PKG_DMF0022_BODY.sql", "17_PKG_DMF0051_BODY.sql"]
MARKERS = {
    "PKG_DMF0022": {"E20260820-D22PREREDUCE": 2, "E20260820-D22VERPUSH": 2, "E20260820-DS2": 1},
    "PKG_DMF0051": {"E20260820-D51SCALAR": 1, "E20260820-D51REGROUP": 1,
                    "E20260820-D51SEMI": 1, "E20260820-D51ITEMPFX": 1, "E20260820-DS2": 1},
}

# ── 1) BODY 2본 복사 + 형식 자기검증 ───────────────────────────────────────────
for f in FILES:
    shutil.copy2(SRC / f, DST / "A_DB" / f)
    lines = (DST / "A_DB" / f).read_text(encoding="utf-8").splitlines()
    first = next(l for l in lines
                 if l.strip() and not l.strip().startswith("--") and not l.strip().upper().startswith("SET "))
    assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", first, re.I), f"{f} 형식 오류: {first[:60]}"
    assert lines[-1].strip().upper() == "SHOW ERRORS", f"{f} 말미 오류"
    print(f"[copy] {f} ({len(lines)} lines) 형식 OK")

# ── 2) 인덱스 제안(미적용) 통합 ────────────────────────────────────────────────
sales_prop = Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
                  r"\03_INDEX_PROPOSAL_NOT_APPLIED.sql").read_text(encoding="utf-8")
biz_prop = """
-- ──────────────────────────────────────────────────────────────────────────────────────────
-- ③-4  DM_PLN_BP_FCST_C  (사내 6,768,311행 / **클라우드 58,335,432행 = 8.6배**)
--   사용처 : PKG_DMF0051 BODY  BP 버전 원장 적재 (L861~871)
--   현황   : TABLE ACCESS FULL. ④ 선행축소(버전 술어)는 **이미 적용돼 있으나** PK 가
--            (DIVISION_ID, VERSION_NO, SEQ_NO) 라 **기간(YYYYMM) 축이 없어** range 가
--            1.28M행에서 끊긴다. 사내 실측 0.88s / BG 190,196 / disk 178,700.
--   시도한 4형태 전부 FTS 유지 : IN 세미조인 / JOIN+DISTINCT / EXISTS / 단일버전 리터럴 등치
--   ⇒ 구조 변경만으로는 제거 불가 (한계). 기간 축을 붙인 복합 인덱스가 유일한 수단.
CREATE INDEX SCM_MGR.IX02_DM_PLN_BP_FCST_C
    ON SCM_MGR.DM_PLN_BP_FCST_C (DIVISION_ID, VERSION_NO, YYYYMM) ONLINE;
"""
(DST / "A_DB" / "91_INDEX_PROPOSAL_NOT_APPLIED.sql").write_text(
    sales_prop.rstrip() + "\n" + biz_prop, encoding="utf-8")
print("[gen ] 91_INDEX_PROPOSAL_NOT_APPLIED.sql (SALES 3 + BIZ 1 = 4건, **적용 안 함**)")

# ── 3) 90_VERIFY_PERF.sql 생성 ────────────────────────────────────────────────
ver = ["-- =====================================================================================",
       "-- 90_VERIFY_PERF.sql — SALES/BIZ PKG 성능개선 델타 적용 검증 (SELECT 전용)",
       "--   적용 대상: 15_PKG_DMF0022_BODY.sql / 17_PKG_DMF0051_BODY.sql (BODY 2본만)",
       "--   ⚠ 조회 중인 세션이 패키지를 물고 있으면 CREATE OR REPLACE 가 대기한다(library cache pin).",
       "--     조용한 창에서 적용하거나 DMF0035_CLOUD_20260820/A_DB/97_REDEPLOY_LOCKED.sql 절차 사용.",
       "-- =====================================================================================",
       "SET LINESIZE 200", "SET PAGESIZE 100", "",
       "PROMPT ===== P1. 객체 상태 (둘 다 VALID 여야 함) =====",
       "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI:SS') LAST_DDL",
       "  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'",
       "   AND OBJECT_NAME IN ('PKG_DMF0022','PKG_DMF0051') ORDER BY 1,2;", "",
       "PROMPT ===== P2. 컴파일 오류 (기대 0행) =====",
       "SELECT NAME, LINE, POSITION, TEXT FROM ALL_ERRORS",
       " WHERE OWNER='SCM_MGR' AND NAME IN ('PKG_DMF0022','PKG_DMF0051') ORDER BY NAME, SEQUENCE;", "",
       "PROMPT ===== P3. ⭐ 마커 카운트 (기대치와 일치해야 적용 완료) ====="]
sel = []
for pkg, marks in MARKERS.items():
    for m, exp in marks.items():
        sel.append(f"SELECT '{pkg}' PKG, '{m}' MARKER, {exp} EXPECT, "
                   f"(SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='{pkg}' "
                   f"AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{m}%') ACTUAL FROM DUAL")
ver.append("SELECT PKG, MARKER, EXPECT, ACTUAL, "
           "CASE WHEN ACTUAL >= EXPECT THEN 'PASS' ELSE '*** FAIL - 미적용 ***' END VERDICT FROM (")
ver.append("\nUNION ALL\n".join(sel))
ver.append(") ORDER BY PKG, MARKER;")
ver += ["",
        "PROMPT ===== P4. ⚠ 회귀 탐지 — 구세대 덮어쓰기 방지축 =====",
        "--  v_measure_sheet 가 사라지면 SALES PLAN 이 **조용히 0행**이 된다(2026-08-20 실사고 계보).",
        "SELECT 'PKG_DMF0022 / v_measure_sheet' AXIS, 6 EXPECT,",
        "       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'",
        "         AND TYPE='PACKAGE BODY' AND LOWER(TEXT) LIKE '%v_measure_sheet%') ACTUAL FROM DUAL;", "",
        "PROMPT ===== P5. ⚠ 권한축 보존 — 제거되면 조회가 0행이 된다 =====",
        "SELECT NAME, COUNT(*) AUTH_JOIN_LINES FROM ALL_SOURCE",
        " WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY'",
        "   AND NAME IN ('PKG_DMF0022','PKG_DMF0051')",
        "   AND TEXT LIKE '%SCM_ADM_USER_MNU_EDIT_AUTH_V%' GROUP BY NAME ORDER BY 1;", "",
        "PROMPT ===== P6. 적용 후 성적 확인 (화면 1회 조회 뒤 실행) =====",
        "SELECT SQL_ID, PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/GREATEST(EXECUTIONS,1)/1e6,2) ELA_S,",
        "       BUFFER_GETS, DISK_READS, TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI') LAST_ACT,",
        "       SUBSTR(REPLACE(SQL_TEXT,CHR(10),' '),1,80) SQL_HEAD",
        "  FROM V$SQL WHERE PARSING_SCHEMA_NAME='SCM_MGR'",
        "   AND LAST_ACTIVE_TIME > SYSDATE - 30/1440 AND ELAPSED_TIME > 2e6",
        " ORDER BY ELAPSED_TIME DESC FETCH FIRST 10 ROWS ONLY;", "",
        "PROMPT ===== 판독 =====",
        "PROMPT   P1 INVALID / P2 행 존재  → 적용 실패. 재컴파일 또는 재적용",
        "PROMPT   P3 FAIL                  → 그 마커분 미반영(대기 중 취소 등). 재적용",
        "PROMPT   P4 ACTUAL <> 6           → **구세대 덮어쓰기** = SALES PLAN 0행 위험. 즉시 재적용",
        "PROMPT   P5 행이 사라짐           → 권한축 훼손. 즉시 원복",
        ]
(DST / "A_DB" / "90_VERIFY_PERF.sql").write_text("\n".join(ver) + "\n", encoding="utf-8")
print("[gen ] 90_VERIFY_PERF.sql")

# ── 4) 사내에서 VERIFY 실측(P1~P5) ────────────────────────────────────────────
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
print("\n== 사내 실증 ==")
cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME IN ('PKG_DMF0022','PKG_DMF0051') ORDER BY 1,2""")
for r in cur.fetchall():
    print("  P1", r)
cur.execute("""SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME IN ('PKG_DMF0022','PKG_DMF0051')""")
print("  P2 ALL_ERRORS:", cur.fetchone()[0])
ok = True
for pkg, marks in MARKERS.items():
    for m, exp in marks.items():
        cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                       AND TYPE='PACKAGE BODY' AND TEXT LIKE :m""", {"n": pkg, "m": f"%{m}%"})
        act = cur.fetchone()[0]
        ok &= act >= exp
        print(f"  P3 {pkg} {m:26} 기대>={exp} 실제={act} {'PASS' if act >= exp else '⛔FAIL'}")
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
               AND TYPE='PACKAGE BODY' AND LOWER(TEXT) LIKE '%v_measure_sheet%'""")
print("  P4 v_measure_sheet:", cur.fetchone()[0], "(기대 6)")
cur.execute("""SELECT NAME, COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY'
               AND NAME IN ('PKG_DMF0022','PKG_DMF0051')
               AND TEXT LIKE '%SCM_ADM_USER_MNU_EDIT_AUTH_V%' GROUP BY NAME ORDER BY 1""")
print("  P5 권한축:", cur.fetchall())
con.close()

# ── 5) FILELIST ──────────────────────────────────────────────────────────────
rows = []
for f in sorted((DST / "A_DB").iterdir()):
    b = f.read_bytes()
    rows.append((f"A_DB/{f.name}", len(b.decode('utf-8', 'ignore').splitlines()),
                 hashlib.md5(b).hexdigest()[:12]))
(DST / "_FILELIST.md").write_text(
    "# DMF0035_PERF_SALESBIZ_20260821 — 파일 목록\n\n"
    "| 파일 | 행수 | md5(12) |\n|---|---:|---|\n"
    + "\n".join(f"| {a} | {b:,} | `{c}` |" for a, b, c in rows) + "\n", encoding="utf-8")
print(f"\n[gen ] _FILELIST.md ({len(rows)} files)")
print("[판정]", "사내 마커 전수 PASS" if ok else "⛔ 마커 불일치")
