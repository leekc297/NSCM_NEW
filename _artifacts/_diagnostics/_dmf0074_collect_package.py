#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0074 클라우드 이관 패키지 취합 — 스윕 결과(축)를 실제 산출물로 수집.

  A_DB/00_GTT_DDL.sql               GTT 17개 DDL (멱등 — 기존재 시 skip, 자급 의무 hook)
  A_DB/01_PKG_DMF0074_SPEC.sql      ALL_SOURCE 원문
  A_DB/02_PKG_DMF0074_BODY.sql      ALL_SOURCE 원문 (2026-08-16 NULLFIX 반영본)
  A_DB/10_META_DMF0074_ALL_AXES.sql 메타 8축 (PK 실측 MERGE / PK 없는 축은 범위삭제+재적재)
  A_DB/90_VERIFY.sql                적용 후 검증
  B_FE/...                          화면 폴더 전체 + locales 3본
"""
import io
import json
import pathlib
import shutil
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0074_CLOUD_20260818")
A, B, C = PKG / "A_DB", PKG / "B_FE", PKG / "C_BE"
FE_SRC = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\metal-link-price")
LOCALES = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\public\locales")
for p in (A, B, C):
    p.mkdir(parents=True, exist_ok=True)

MARK = "-- [DMF0074_CLOUD_20260818] 사내 → 클라우드 이관 (2026-08-18 취합)"

# 메타 8축 : (테이블, WHERE, PK컬럼 또는 None=범위삭제+재적재)
AXES = [
    ("SCM_ADM_MNU_M", "MNU_ID LIKE '%DMF0074%'", ["MNU_ID"]),
    ("SCM_ADM_API_M", "API_ID LIKE '%DMF0074%'", ["API_ID"]),
    ("SCM_ADM_PROC_M", "PROC_NM LIKE '%DMF0074%'", ["PROC_NM", "COL_NM", "COL_TP_CD"]),
    ("SCM_ADM_MNU_BTN_MPG_M", "MNU_ID LIKE '%DMF0074%' OR API_ID LIKE '%DMF0074%'",
     ["MNU_ID", "SHT_NM", "MNU_BTN_CD"]),
    ("SCM_ADM_USER_GR_MNU_MPG_M", "MNU_ID LIKE '%DMF0074%'", ["USER_GR_ID", "MNU_ID"]),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", "MNU_ID LIKE '%DMF0074%'",
     ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"]),
    # PK 없음 → 논리키 범위삭제 + 전체 재적재 (hook #98 §9)
    ("SCM_ADM_EXCEL_COLUMNS", "PROGRAM_ID LIKE '%DMF0074%'", None),
    ("SCM_MST_SHEET_COLUMNS", "PROGRAM_ID LIKE '%DMF0074%'", None),
]
DEL_SCOPE = {  # PK 없는 축의 삭제 범위 (삽입 범위와 동일해야 소실 0)
    "SCM_ADM_EXCEL_COLUMNS": "PROGRAM_ID LIKE 'DMF0074%'",
    "SCM_MST_SHEET_COLUMNS": "PROGRAM_ID LIKE 'DMF0074%'",
}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,"
            "'STORAGE',FALSE); DBMS_METADATA.SET_TRANSFORM_PARAM("
            "DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE); END;")
report = {}


AUDIT_COLS = ("CREATED_BY", "LAST_UPDATED_BY")


def lit(v, dtype, col=None):
    # hook: 메타 감사컬럼은 'admin' 만 — claude 계열 ID 를 클라우드로 넘기지 않는다
    #   실측 2026-08-18: SCM_MST_SHEET_COLUMNS.LAST_UPDATED_BY='claude_dmf0074_fe' 58행
    if col in AUDIT_COLS and v is not None and "claude" in str(v).lower():
        return "'admin'"
    if v is None:
        return "NULL"
    if dtype in ("NUMBER", "FLOAT", "BINARY_DOUBLE", "BINARY_FLOAT"):
        return str(v)
    if dtype.startswith("DATE") or dtype.startswith("TIMESTAMP"):
        return f"TO_DATE('{v.strftime('%Y-%m-%d %H:%M:%S')}','YYYY-MM-DD HH24:MI:SS')"
    return "'" + str(v).replace("'", "''") + "'"


# ═══════════ 00_GTT_DDL.sql ═══════════
cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
                AND TABLE_NAME LIKE 'GT_DM74%' AND TEMPORARY='Y' ORDER BY 1""")
gtts = [r[0] for r in cur.fetchall()]
out = [MARK, "-- 00_GTT_DDL.sql — GTT 17개 자급 DDL (기존재 시 skip · 멱등)",
       "-- ⚠ hook deploy-package-gtt-type-ddl: 클라우드 기존재를 가정하지 않는다", ""]
for t in gtts:
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE',:n,'SCM_MGR') FROM DUAL", {"n": t})
    ddl = cur.fetchone()[0]
    ddl = ddl.read() if hasattr(ddl, "read") else str(ddl)
    ddl = ddl.strip().rstrip(";").replace("\n", "\n    ")
    out += [f"-- ── {t}", "DECLARE v_cnt PLS_INTEGER;", "BEGIN",
            "    SELECT COUNT(*) INTO v_cnt FROM ALL_TABLES"
            f" WHERE OWNER='SCM_MGR' AND TABLE_NAME='{t}';",
            "    IF v_cnt = 0 THEN", f"        EXECUTE IMMEDIATE q'[{ddl}]';",
            f"        DBMS_OUTPUT.PUT_LINE('CREATED {t}');", "    ELSE",
            f"        DBMS_OUTPUT.PUT_LINE('SKIP(exists) {t}');", "    END IF;", "END;", "/", ""]
(A / "00_GTT_DDL.sql").write_text("\n".join(out), encoding="utf-8")
report["GTT"] = len(gtts)
print(f"00_GTT_DDL.sql — GTT {len(gtts)}개")

# ═══════════ 01/02 PKG ═══════════
for typ, fn in [("PACKAGE", "01_PKG_DMF0074_SPEC.sql"), ("PACKAGE BODY", "02_PKG_DMF0074_BODY.sql")]:
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'"
                " AND TYPE=:t ORDER BY LINE", {"t": typ})
    src = "".join(r[0] for r in cur.fetchall())
    if not src.strip():
        sys.exit(f"⛔ {typ} 소스 조회 실패")
    (A / fn).write_text(f"{MARK}\n-- {fn} — ALL_SOURCE 원문"
                        + ("\n-- 2026-08-16 [E20260816-NULLFIX] 5결함 정정 반영본"
                           if "BODY" in typ else "")
                        + "\nCREATE OR REPLACE " + src + "\n/\n", encoding="utf-8")
    n = len(src.splitlines())
    report[fn] = n
    print(f"{fn} — {n} lines")

# ═══════════ 10_META ═══════════
meta = [MARK, "-- 10_META_DMF0074_ALL_AXES.sql — 메타 8축",
        "-- 축 도출 = _dmf0074_deploy_axis_sweep.py 기계 스윕 (손나열 금지 hook)",
        "-- ⭐ MNU_ID='DMF0074_40' 행 포함 — WHERE MNU_ID='DMF0074' 로 짜면 조용히 빠지는 축",
        "SET DEFINE OFF;", ""]
for tbl, where, pk in AXES:
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME=:t ORDER BY COLUMN_ID""", {"t": tbl})
    cols = cur.fetchall()
    names = [c for c, _ in cols]
    types = dict(cols)
    cur.execute(f"SELECT {', '.join(names)} FROM SCM_MGR.{tbl} WHERE {where}")
    rows = cur.fetchall()
    report[tbl] = len(rows)
    meta += ["-" * 96, f"-- {tbl} : {len(rows)}행  ({'MERGE PK=' + ','.join(pk) if pk else '범위삭제+재적재'})",
             "-" * 96]
    if not pk:
        meta += [f"DELETE FROM SCM_MGR.{tbl} WHERE {DEL_SCOPE[tbl]};",
                 f"-- ↑ 삭제범위 = 삽입범위 (DMF0074 / DMF0074_40 전량 동봉 — 소실 0)"]
    for r in rows:
        vals = [lit(v, types[c], c) for c, v in zip(names, r)]
        if pk:
            on = " AND ".join(f"T.{k} = {lit(dict(zip(names, r))[k], types[k], k)}" for k in pk)
            upd = ", ".join(f"T.{c} = {v}" for c, v in zip(names, vals) if c not in pk)
            meta += [f"MERGE INTO SCM_MGR.{tbl} T USING DUAL ON ({on})",
                     f"WHEN MATCHED THEN UPDATE SET {upd}",
                     f"WHEN NOT MATCHED THEN INSERT ({', '.join(names)})"
                     f" VALUES ({', '.join(vals)});"]
        else:
            meta += [f"INSERT INTO SCM_MGR.{tbl} ({', '.join(names)})"
                     f" VALUES ({', '.join(vals)});"]
    meta.append("")
meta += ["COMMIT;", ""]
(A / "10_META_DMF0074_ALL_AXES.sql").write_text("\n".join(meta), encoding="utf-8")
print(f"10_META_DMF0074_ALL_AXES.sql — 8축 / 총 "
      f"{sum(report[t] for t, _, _ in AXES)}행")

# 감사컬럼 오염 점검 (hook: 메타 감사컬럼 'admin' 만 — claude ID 금지)
bad = []
for tbl, where, _ in AXES:
    for c in ("CREATED_BY", "LAST_UPDATED_BY"):
        cur.execute("""SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                        AND TABLE_NAME=:t AND COLUMN_NAME=:c""", {"t": tbl, "c": c})
        if not cur.fetchone()[0]:
            continue
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{tbl} WHERE ({where})"
                    f" AND LOWER({c}) LIKE '%claude%'")
        n = cur.fetchone()[0]
        if n:
            bad.append(f"{tbl}.{c}({n}행)")
print(f"감사컬럼 claude 오염 = {len(bad)}건 {bad if bad else '(없음 — admin/사용자ID)'}")

# ═══════════ 90_VERIFY ═══════════
ver = [MARK, "-- 90_VERIFY.sql — 적용 후 검증 (사내 기준값과 대조)", ""]
ver += ["-- ① DB 객체", "SELECT OBJECT_TYPE, OBJECT_NAME, STATUS FROM ALL_OBJECTS"
        " WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074';  -- 기대: PACKAGE/BODY 모두 VALID",
        "SELECT COUNT(*) GTT_CNT FROM ALL_TABLES WHERE OWNER='SCM_MGR'"
        f" AND TABLE_NAME LIKE 'GT_DM74%' AND TEMPORARY='Y';  -- 기대: {len(gtts)}", ""]
ver.append("-- ② 메타 축 행수 (사내 실측 기준값)")
for tbl, where, _ in AXES:
    ver.append(f"SELECT '{tbl}' TBL, COUNT(*) CNT FROM SCM_MGR.{tbl} WHERE {where};"
               f"  -- 기대: {report[tbl]}")
ver += ["", "-- ③ div 40 전용 축 (누락 시 40 업로드 전멸)",
        "SELECT MNU_ID, MNU_BTN_CD, API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M"
        " WHERE MNU_ID='DMF0074_40';  -- 기대: UPLOAD 1행",
        "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M"
        " WHERE MNU_ID='DMF0074_40';  -- 기대: 2",
        "SELECT PROGRAM_ID, LENGTH(HEADER_CONTENT) LEN FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS"
        " WHERE PROGRAM_ID LIKE 'DMF0074%';  -- 기대: DMF0074=696 / DMF0074_40=675", ""]
ver += ["-- ④ 정정 반영 확인 ① (2026-08-16 NULLFIX — ''=NULL 사문화 술어 잔존 0)",
        "SELECT COUNT(*) DEAD_PREDICATE FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'",
        "   AND (TEXT LIKE '%NVL(ATTRIBUTE7, '''') <> ''''%'",
        "     OR TEXT LIKE '%NVL(ATTRIBUTE12, '''') <> ''''%');  -- 기대: 0",
        "SELECT COUNT(*) NULLFIX_MARK FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'",
        "   AND TEXT LIKE '%E20260816-NULLFIX%';  -- 기대: 9 (본문 실측 — 파일 헤더 주석 1건 제외)", "",
        "-- ⑤ 정정 반영 확인 ② (2026-08-18 GTTDEL — GTT DDL 경합 제거)",
        "SELECT COUNT(*) GTT_TRUNCATE_LEFT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'",
        "   AND TEXT LIKE '%EXECUTE IMMEDIATE ''TRUNCATE TABLE%';  -- 기대: 0",
        "SELECT COUNT(*) GTTDEL_MARK FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'",
        "   AND TEXT LIKE '%E20260818-GTTDEL%';  -- 기대: 17 (GTT 17개소)", "",
        "-- ⑥ 이력 identity 시퀀스 재시드 확인 (05_FIX_HISTORY_SEQ_RESEED.sql 적용 결과)",
        "--    SEQ_LAST_NUMBER <= MAX_SEQ 이면 다건 Excel Upload 가 ORA-00001 로 실패한다",
        "SELECT (SELECT MAX(HISTORY_SEQ) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_H) MAX_SEQ,",
        "       (SELECT LAST_NUMBER FROM ALL_SEQUENCES s",
        "         WHERE s.SEQUENCE_OWNER='SCM_MGR'",
        "           AND s.SEQUENCE_NAME=(SELECT REGEXP_SUBSTR(i.SEQUENCE_NAME,'[^.]+$')",
        "                                  FROM ALL_TAB_IDENTITY_COLS i",
        "                                 WHERE i.OWNER='SCM_MGR'",
        "                                   AND i.TABLE_NAME='DM_BPS_METAL_LINK_PRICE_H'",
        "                                   AND i.COLUMN_NAME='HISTORY_SEQ')) SEQ_LAST_NUMBER",
        "  FROM DUAL;  -- 기대: SEQ_LAST_NUMBER > MAX_SEQ", "",
        "-- ⑦ 스모크 — D_SAMPLE 의 3건 업로드 후 조회 확인 (README §7 절차)",
        "--    ⚠ 조회 Version 은 반드시 'Current' — 특정 버전은 _C(버전 스냅샷)를 읽어 업로드분이 안 보인다",
        "SELECT PLAN_YYYYMM, COUNT(*) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE",
        " WHERE DIVISION_ID='40' GROUP BY PLAN_YYYYMM ORDER BY 1 DESC;", ""]
(A / "90_VERIFY.sql").write_text("\n".join(ver), encoding="utf-8")
print("90_VERIFY.sql 작성")

# ═══════════ B_FE ═══════════
dst = B / "metal-link-price"
if dst.exists():
    shutil.rmtree(dst)
shutil.copytree(FE_SRC, dst)
fe_files = sorted(f.relative_to(B).as_posix() for f in dst.rglob("*") if f.is_file())
loc = B / "locales"
loc.mkdir(exist_ok=True)
for j in ("KO.json", "EN.json", "CN.json"):
    shutil.copy2(LOCALES / j, loc / j)
print(f"B_FE — 화면 파일 {len(fe_files)}개 + locales 3본")

(PKG / "_survey" / "collect_report.json").write_text(
    json.dumps({"meta_rows": report, "gtt": gtts, "fe_files": fe_files},
               ensure_ascii=False, indent=2), encoding="utf-8")
con.close()
print("\n취합 완료")
