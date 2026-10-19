# -*- coding: utf-8 -*-
"""클라우드 패키지 생성: 00_BACKUP_corp(적용 전 사내 원문)·01_NEW_corp(적용 후) → SQL*Plus 실행 파일 + 사전점검/검증/원복 스크립트"""
import pathlib, json, hashlib, re, datetime
HERE = pathlib.Path(__file__).resolve().parent
bk, nw = HERE / "00_BACKUP_corp", HERE / "01_NEW_corp"
out_apply, out_rb = HERE / "03_CLOUD_APPLY_sqlplus", HERE / "99_CLOUD_ROLLBACK_sqlplus"; out_apply.mkdir(exist_ok=True); out_rb.mkdir(exist_ok=True)
P = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]
def wrap(p, text):
    if p["object_type"] == "VIEW": return text.rstrip().rstrip(";") + "\n/\n"
    return "CREATE OR REPLACE " + text.lstrip() + "\n/\n"
rows = []
for f in sorted(nw.glob("*.sql")):
    name, otype = f.stem.rsplit(".", 1); otype = otype.replace("_", " ")
    key = f"{otype}|{name}"; p = P.get(key)
    if not p: continue
    new_text = f.read_text(encoding="utf-8"); old_text = (bk / f.name).read_text(encoding="utf-8")
    old_lines = old_text.split("\n")
    (out_apply / f.name).write_text(f"-- [E20261008-SLASHOBJ] {otype} {name} — 적용 후 원문(사내 ZIOUI1 적용본과 동일). 사전점검(02) 통과 객체만 실행.\n" + wrap(p, new_text) + f"SHOW ERRORS {otype} {name}\n", encoding="utf-8")
    (out_rb / f.name).write_text(f"-- [E20261008-SLASHOBJ] {otype} {name} — 원복(사내 적용 전 원문)\n" + wrap(p, old_text) + f"SHOW ERRORS {otype} {name}\n", encoding="utf-8")
    rows.append(dict(otype=otype, name=name, lines=len(old_lines), dash_lines=sum(1 for l in old_lines if "'-'" in l), length=sum(len(l) for l in old_lines), file=f.name, edits=len(p["edits"])))
hdr = f"-- [E20261008-SLASHOBJ] 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · 대상 {len(rows)}객체\n"
# 02 사전점검: 클라우드 원문이 사내 적용 전 원문과 같은가 (줄수 · LENGTH 합 · '-' 포함 줄수 — VIEW 는 DBMS_METADATA 기반이라 줄수만 참고)
pre = [hdr, "-- 02_CLOUD_PRECHECK — 클라우드 객체 원문이 사내 '적용 전' 원문과 같은지 (PL/SQL: ALL_SOURCE 줄수·총길이·'-' 줄수 비교). SAME 인 객체만 03 로 적용.",
       "--   DIFF 객체 = 클라우드 판본이 사내와 다름 → 전체 원문 덮어쓰기 금지. engine.py plan/apply --dsn <클라우드> 로 그 DB 원문 기준 재적용 또는 수작업.",
       "SET PAGESIZE 0 LINESIZE 300 HEADING OFF FEEDBACK OFF",
       "WITH exp AS ("]
pre.append("\n UNION ALL\n".join(f"    SELECT '{r['otype']}' AS t, '{r['name']}' AS n, {r['lines']} AS exp_lines, {r['length']} AS exp_len, {r['dash_lines']} AS exp_dash FROM dual" for r in rows if r["otype"] != "VIEW"))
pre.append(""")
, act AS (
    SELECT type AS t, name AS n, COUNT(*) AS act_lines, SUM(LENGTH(RTRIM(text, CHR(10)||CHR(13)))) AS act_len, SUM(CASE WHEN text LIKE '%''-''%' THEN 1 ELSE 0 END) AS act_dash
      FROM all_source WHERE owner = 'SCM_MGR' GROUP BY type, name
)
SELECT 'PRECHECK | ' || RPAD(e.t, 13) || ' | ' || RPAD(e.n, 55) || ' | ' || CASE WHEN a.n IS NULL THEN 'MISSING' WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 'SAME' ELSE 'DIFF' END
    || ' | lines ' || e.exp_lines || '/' || NVL(TO_CHAR(a.act_lines), '-') || ' | len ' || e.exp_len || '/' || NVL(TO_CHAR(a.act_len), '-') || ' | dash ' || e.exp_dash || '/' || NVL(TO_CHAR(a.act_dash), '-') AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n
 ORDER BY CASE WHEN a.n IS NULL THEN 2 WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 0 ELSE 1 END, e.t, e.n;
""")
views = [r for r in rows if r["otype"] == "VIEW"]
pre.append("-- VIEW 7건: DBMS_METADATA DDL 기준이라 줄수 비교만 (참고). 적용 전 사내 DDL 줄수 = " + ", ".join(f"{r['name']}={r['lines']}" for r in views))
pre.append("SELECT 'PRECHECK-VIEW | ' || view_name || ' | text_length=' || text_length || ' | status=' || (SELECT status FROM all_objects o WHERE o.owner = v.owner AND o.object_name = v.view_name AND o.object_type = 'VIEW') AS line FROM all_views v WHERE owner = 'SCM_MGR' AND view_name IN (" + ",".join(f"'{r['name']}'" for r in views) + ") ORDER BY 1;")
(HERE / "02_CLOUD_PRECHECK.sql").write_text("\n".join(pre), encoding="utf-8")
# 03 드라이버 / 99 드라이버 (SAME 객체만 남기고 실행하도록 안내)
drv = [hdr, "-- 03_CLOUD_APPLY_ALL — 02 에서 SAME 으로 확인된 객체만 실행 (DIFF/MISSING 객체 줄은 지우거나 주석 처리). SCM_MGR 접속, 이 폴더에서 @03_CLOUD_APPLY_ALL.sql", "SET DEFINE OFF", "SPOOL 03_CLOUD_APPLY_ALL.log"]
drv += [f"@@03_CLOUD_APPLY_sqlplus/{r['file']}" for r in rows]; drv += ["SPOOL OFF"]
(HERE / "03_CLOUD_APPLY_ALL.sql").write_text("\n".join(drv) + "\n", encoding="utf-8")
rb = [hdr, "-- 99_CLOUD_ROLLBACK_ALL — 사내 적용 전 원문으로 원복 (필요 객체만 남겨 실행)", "SET DEFINE OFF", "SPOOL 99_CLOUD_ROLLBACK_ALL.log"] + [f"@@99_CLOUD_ROLLBACK_sqlplus/{r['file']}" for r in rows] + ["SPOOL OFF"]
(HERE / "99_CLOUD_ROLLBACK_ALL.sql").write_text("\n".join(rb) + "\n", encoding="utf-8")
# 04 검증: 상태·에러·'-' 줄수(적용 후 기대값 = 사내 적용 후 원문 기준)
after_rows = []
for r in rows:
    nt = (nw / r["file"]).read_text(encoding="utf-8").split("\n"); after_rows.append((r, len(nt), sum(1 for l in nt if "'-'" in l), sum(len(l) for l in nt)))
ver = [hdr, "-- 04_CLOUD_VERIFY — 적용 후: VALID/ERROR 와 줄수·총길이·'-' 줄수가 사내 적용 후와 같은지", "SET PAGESIZE 0 LINESIZE 300 HEADING OFF FEEDBACK OFF", "WITH exp AS ("]
ver.append("\n UNION ALL\n".join(f"    SELECT '{r['otype']}' AS t, '{r['name']}' AS n, {ln} AS exp_lines, {le} AS exp_len, {dl} AS exp_dash FROM dual" for r, ln, dl, le in after_rows if r["otype"] != "VIEW"))
ver.append(""")
, act AS (SELECT type AS t, name AS n, COUNT(*) AS act_lines, SUM(LENGTH(RTRIM(text, CHR(10)||CHR(13)))) AS act_len, SUM(CASE WHEN text LIKE '%''-''%' THEN 1 ELSE 0 END) AS act_dash FROM all_source WHERE owner = 'SCM_MGR' GROUP BY type, name)
SELECT 'VERIFY | ' || RPAD(e.t, 13) || ' | ' || RPAD(e.n, 55) || ' | ' || NVL((SELECT o.status FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.object_name = e.n AND o.object_type = e.t), 'MISSING')
    || ' | ' || CASE WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 'SAME_AS_CORP' ELSE 'DIFF' END
    || ' | errors=' || (SELECT COUNT(*) FROM all_errors x WHERE x.owner = 'SCM_MGR' AND x.name = e.n AND x.type = e.t AND x.attribute = 'ERROR')
    || ' | lines ' || e.exp_lines || '/' || NVL(TO_CHAR(a.act_lines), '-') || ' | dash ' || e.exp_dash || '/' || NVL(TO_CHAR(a.act_dash), '-') AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n ORDER BY e.t, e.n;
SELECT 'VERIFY-VIEW | ' || view_name || ' | status=' || (SELECT status FROM all_objects o WHERE o.owner = v.owner AND o.object_name = v.view_name AND o.object_type = 'VIEW') || ' | text_length=' || text_length AS line FROM all_views v WHERE owner = 'SCM_MGR' AND view_name IN (""" + ",".join(f"'{r['name']}'" for r in views) + """) ORDER BY 1;
SELECT 'INVALID | ' || object_type || ' ' || object_name AS line FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID' ORDER BY 1;""")
(HERE / "04_CLOUD_VERIFY.sql").write_text("\n".join(ver), encoding="utf-8")
json.dump(rows, open(HERE / "manifest_objects.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("package objects:", len(rows), "| edits:", sum(r["edits"] for r in rows), "| views:", len(views))
