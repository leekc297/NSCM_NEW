#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 클라우드 이관 패키지 취합 (DMF0074 취합기와 동일 규약).

  A_DB/00_GTT_DDL.sql                GTT 자급 DDL (멱등)
  A_DB/01_PKG_DMF0014_SPEC.sql       ALL_SOURCE 원문
  A_DB/02_PKG_DMF0014_BODY.sql       ALL_SOURCE 원문 (2026-08-18 업로드 보완 반영)
  A_DB/03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql   후속 프로시저 (2026-08-18 4건 정정 반영)
  A_DB/04_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql (div 40 전용 — 존재 시)
  A_DB/10_META_DMF0014_ALL_AXES.sql  메타 축
  A_DB/90_VERIFY.sql                 적용 후 검증
  B_FE/customer-fcst-upload/**       화면 폴더 전체 + locales 3본
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

MENU = "DMF0014"
PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages") / f"{MENU}_CLOUD_20260818"
A, B, C = PKG / "A_DB", PKG / "B_FE", PKG / "C_BE"
FE_SRC = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\customer-fcst-upload")
LOCALES = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\public\locales")
for p in (A, B, C):
    p.mkdir(parents=True, exist_ok=True)
MARK = f"-- [{MENU}_CLOUD_20260818] 사내 → 클라우드 이관 (2026-08-18 취합)"

# 메타 축 (스윕 결과 기준 — 데이터/개인화/AS-IS 카탈로그는 제외)
AXES = [
    ("SCM_ADM_MNU_M", "MNU_ID LIKE '%DMF0014%'", ["MNU_ID"]),
    ("SCM_ADM_API_M", "API_ID LIKE '%DMF0014%' OR API_URL LIKE '%DMF0014%'", ["API_ID"]),
    ("SCM_ADM_PROC_M", "PROC_NM LIKE '%DMF0014%'", ["PROC_NM", "COL_NM", "COL_TP_CD"]),
    ("SCM_ADM_MNU_BTN_MPG_M", "MNU_ID LIKE '%DMF0014%' OR API_ID LIKE '%DMF0014%'",
     ["MNU_ID", "SHT_NM", "MNU_BTN_CD"]),
    ("SCM_ADM_USER_GR_MNU_MPG_M", "MNU_ID LIKE '%DMF0014%'", ["USER_GR_ID", "MNU_ID"]),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", "MNU_ID LIKE '%DMF0014%'",
     ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"]),
    ("SCM_ADM_EXCEL_COLUMNS", "PROGRAM_ID LIKE '%DMF0014%'", None),
    ("SCM_MST_SHEET_COLUMNS", "PROGRAM_ID LIKE '%DMF0014%'", None),
]
DEL_SCOPE = {"SCM_ADM_EXCEL_COLUMNS": "PROGRAM_ID LIKE 'DMF0014%'",
             "SCM_MST_SHEET_COLUMNS": "PROGRAM_ID LIKE 'DMF0014%'"}
AUDIT = ("CREATED_BY", "LAST_UPDATED_BY")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,"
            "'STORAGE',FALSE); DBMS_METADATA.SET_TRANSFORM_PARAM("
            "DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE); END;")
report = {}


def lit(v, dtype, col=None):
    if col in AUDIT and v is not None and "claude" in str(v).lower():
        return "'admin'"
    if v is None:
        return "NULL"
    if dtype in ("NUMBER", "FLOAT", "BINARY_DOUBLE", "BINARY_FLOAT"):
        return str(v)
    if dtype.startswith("DATE") or dtype.startswith("TIMESTAMP"):
        return f"TO_DATE('{v.strftime('%Y-%m-%d %H:%M:%S')}','YYYY-MM-DD HH24:MI:SS')"
    return "'" + str(v).replace("'", "''") + "'"


# ── GTT DDL — PKG/후속 프로시저가 실제로 참조하는 GTT 만 (이름 접두 스윕) ──
cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y'
                AND (TABLE_NAME LIKE 'GT_DPCF%' OR TABLE_NAME LIKE 'GT_DCIM%') ORDER BY 1""")
gtts = [r[0] for r in cur.fetchall()]
out = [MARK, "-- 00_GTT_DDL.sql — GTT 자급 DDL (기존재 시 skip · 멱등)",
       "-- hook deploy-package-gtt-type-ddl: 클라우드 기존재를 가정하지 않는다", ""]
for t in gtts:
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE',:n,'SCM_MGR') FROM DUAL", {"n": t})
    ddl = cur.fetchone()[0]
    ddl = (ddl.read() if hasattr(ddl, "read") else str(ddl)).strip().rstrip(";").replace("\n", "\n    ")
    out += [f"-- ── {t}", "DECLARE v_cnt PLS_INTEGER;", "BEGIN",
            "    SELECT COUNT(*) INTO v_cnt FROM ALL_TABLES"
            f" WHERE OWNER='SCM_MGR' AND TABLE_NAME='{t}';",
            "    IF v_cnt = 0 THEN", f"        EXECUTE IMMEDIATE q'[{ddl}]';",
            f"        DBMS_OUTPUT.PUT_LINE('CREATED {t}');", "    ELSE",
            f"        DBMS_OUTPUT.PUT_LINE('SKIP(exists) {t}');", "    END IF;", "END;", "/", ""]
(A / "00_GTT_DDL.sql").write_text("\n".join(out), encoding="utf-8")
report["GTT"] = len(gtts)
print(f"00_GTT_DDL.sql — GTT {len(gtts)}개")

# ── PKG + 후속 프로시저 ──
OBJS = [("PACKAGE", "PKG_DMF0014", "01_PKG_DMF0014_SPEC.sql", ""),
        ("PACKAGE BODY", "PKG_DMF0014", "02_PKG_DMF0014_BODY.sql",
         "\n-- 2026-08-18 [E20260818-BATCHKEEP] 재업로드 배치 정정 + [E20260818-GRAYWEEK] 회색주차 반려"),
        ("PROCEDURE", "PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql",
         "\n-- 2026-08-18 [E20260818-MKTDEL/RAISE/MKTMERGE/MKTDISTINCT/MKTPKGUARD] 5건 정정"),
        ("PROCEDURE", "PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40",
         "04_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql", "  -- div 40 전용")]
for typ, name, fn, note in OBJS:
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t"
                " ORDER BY LINE", {"n": name, "t": typ})
    src = "".join(r[0] for r in cur.fetchall())
    if not src.strip():
        print(f"  ⚠ {name} ({typ}) 소스 없음 — 파일 미생성")
        continue
    (A / fn).write_text(f"{MARK}\n-- {fn}{note}\nCREATE OR REPLACE " + src + "\n/\n",
                        encoding="utf-8")
    report[fn] = len(src.splitlines())
    print(f"{fn} — {report[fn]} lines")

# ── 메타 ──
meta = [MARK, "-- 10_META_DMF0014_ALL_AXES.sql — 메타 축",
        "-- 축 도출 = _ui_deploy_axis_sweep.py DMF0014 기계 스윕 (손나열 금지 hook)",
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
    meta += ["-" * 96,
             f"-- {tbl} : {len(rows)}행  ({'MERGE PK=' + ','.join(pk) if pk else '범위삭제+재적재'})",
             "-" * 96]
    if not pk:
        meta.append(f"DELETE FROM SCM_MGR.{tbl} WHERE {DEL_SCOPE[tbl]};")
    for r in rows:
        vals = [lit(v, types[c], c) for c, v in zip(names, r)]
        if pk:
            on = " AND ".join(f"T.{k} = {lit(dict(zip(names, r))[k], types[k], k)}" for k in pk)
            upd = ", ".join(f"T.{c} = {v}" for c, v in zip(names, vals) if c not in pk)
            meta += [f"MERGE INTO SCM_MGR.{tbl} T USING DUAL ON ({on})",
                     f"WHEN MATCHED THEN UPDATE SET {upd}",
                     f"WHEN NOT MATCHED THEN INSERT ({', '.join(names)}) VALUES ({', '.join(vals)});"]
        else:
            meta.append(f"INSERT INTO SCM_MGR.{tbl} ({', '.join(names)}) VALUES ({', '.join(vals)});")
    meta.append("")
meta += ["COMMIT;", ""]
(A / "10_META_DMF0014_ALL_AXES.sql").write_text("\n".join(meta), encoding="utf-8")
print(f"10_META_DMF0014_ALL_AXES.sql — {len(AXES)}축 / {sum(report[t] for t, _, _ in AXES)}행")

# ── 검증 ──
ver = [MARK, "-- 90_VERIFY.sql — 적용 후 검증", "",
       "-- ① DB 객체 (전부 VALID 여야 한다)",
       "SELECT OBJECT_TYPE, OBJECT_NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'",
       "   AND OBJECT_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST',",
       "                       'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40') ORDER BY 1,2;",
       f"SELECT COUNT(*) GTT_CNT FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y'",
       f"   AND (TABLE_NAME LIKE 'GT_DPCF%' OR TABLE_NAME LIKE 'GT_DCIM%');  -- 기대: {len(gtts)}", ""]
ver.append("-- ② 메타 축 행수 (사내 실측 기준값)")
for tbl, where, _ in AXES:
    ver.append(f"SELECT '{tbl}' TBL, COUNT(*) CNT FROM SCM_MGR.{tbl} WHERE {where};"
               f"  -- 기대: {report[tbl]}")
ver += ["", "-- ③ 2026-08-18 정정 반영 확인 (마커)",
        "SELECT 'BATCHKEEP' M, COUNT(*) N FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0014' AND TEXT LIKE '%E20260818-BATCHKEEP%'",
        " UNION ALL SELECT 'GRAYWEEK', COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PKG_DMF0014' AND TEXT LIKE '%E20260818-GRAYWEEK%'",
        " UNION ALL SELECT 'MKTPKGUARD', COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND TEXT LIKE '%E20260818-MKTPKGUARD%'",
        " UNION ALL SELECT 'RAISE', COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'",
        "   AND NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND TEXT LIKE '%E20260818-RAISE%';",
        "-- 기대: 각 1 이상", "",
        "-- ④ Customer Master 실재 (0행이면 업로드가 전건 'Invalid Measure Upload Bucket.' 로 탈락)",
        "SELECT COUNT(*) CUST_MASTER FROM SCM_MGR.DM_MST_CUSTOMER_FCST;  -- 사내 실측 3,171",
        "-- 0행이면 DM_MST_CUSTOMER_FCST_C 최신 PLAN_WEEK 스냅샷에서 복구할 것", ""]
(A / "90_VERIFY.sql").write_text("\n".join(ver), encoding="utf-8")
print("90_VERIFY.sql 작성")

# ── FE ──
dst = B / "customer-fcst-upload"
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
