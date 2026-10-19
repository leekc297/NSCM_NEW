"""Build cloud package 07_HOTFIX_GROUPBY_BATCH_20261009 from the corporate-applied sources (applied_corp/).
Files: 01_APPLY_ALL_GRPBYFIX.sql (CREATE OR REPLACE ×N + status/errors) · 02_VERIFY_GRPBYFIX.sql · 99_ROLLBACK_to_1726_payload.sql
Also syncs SLASHOBJ package copies (05_CLOUD_PAYLOAD_corp / 03_CLOUD_APPLY_sqlplus / 01_NEW_corp)."""
import sys, json, pathlib, re
HERE = pathlib.Path(__file__).parent
ROOT = HERE.parent.parent            # SLASH_DBOBJ_20261008
OUT = ROOT / "07_HOTFIX_GROUPBY_BATCH_20261009"; OUT.mkdir(exist_ok=True)
log = json.load(open(HERE / "APPLY_LOG_corp_hotfix.json", encoding="utf-8"))
meta = json.load(open(HERE / "fresh_all/_meta.json", encoding="utf-8"))
applied = [x for x in log["log"] if x["result"] in ("APPLIED", "ALREADY_APPLIED")]
assert applied, "nothing applied"
MARK = "[E20261009-GRPBYFIX]"
hdr = lambda title, body: f"-- {MARK} {title} · 생성 2026-10-09 · 대상 {len(applied)}객체 · SCM_MGR 접속 후 파일 전체 실행(F5), 바인드·DEFINE 없음\n{body}SET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\n"

apply_parts = []; rollback_parts = []; verify_rows = []
for x in applied:
    ot, nm = x["obj"].split("|"); fn = meta[x["obj"]]["file"]
    src = (HERE / "applied_corp" / fn).read_text(encoding="utf-8").rstrip()
    assert src.upper().startswith(ot.split()[0])
    apply_parts.append(f"-- ##### {ot} {nm} (사내 적용 {x['last_ddl']} · ORA-00979 문장 {x['ora979_before']}→0 · 마커 {x['markers']})\nCREATE OR REPLACE {src}\n/\n")
    prev = (ROOT / "05_CLOUD_PAYLOAD_corp" / fn).read_text(encoding="utf-8").rstrip()
    rollback_parts.append(f"-- ##### {ot} {nm} — 핫픽스 직전 클라우드 적용본(SLASHOBJ 03 페이로드 17:26) — ⚠ 되돌리면 ORA-00979 재발\nCREATE OR REPLACE {prev}\n/\n")
    verify_rows.append((ot, nm, x["markers"]))
    # sync SLASHOBJ package copies to the hotfixed version
    (ROOT / "05_CLOUD_PAYLOAD_corp" / fn).write_text(src + "\n", encoding="utf-8")
    (ROOT / "01_NEW_corp" / fn).write_text(src + "\n", encoding="utf-8")
    sp = ROOT / "03_CLOUD_APPLY_sqlplus" / fn
    sp.write_text(f"-- [E20261008-SLASHOBJ]+{MARK} {ot} {nm} — 사내 현재 원문(핫픽스 적용본, 사내 LAST_DDL {x['last_ddl']})\nCREATE OR REPLACE {src}\n/\nSHOW ERRORS {ot} {nm}\n", encoding="utf-8")

names_sql = ",".join(f"'{nm}'" for ot, nm, m in verify_rows)
tail = f"""
-- 적용 결과: 전부 VALID · APPLY ERR 0행 기대
SELECT 'APPLY | ' || object_type || ' ' || object_name || ' | ' || status || ' | ddl=' || TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS line
  FROM all_objects WHERE owner='SCM_MGR' AND object_name IN ({names_sql}) AND object_type IN ('PACKAGE BODY','PROCEDURE') ORDER BY object_name, object_type;
SELECT 'APPLY ERR | ' || type || ' ' || name || ' L' || line || ':' || position || ' | ' || SUBSTR(REPLACE(text,CHR(10),' '),1,200) AS line
  FROM all_errors WHERE owner='SCM_MGR' AND name IN ({names_sql}) AND attribute='ERROR' ORDER BY name, sequence;
"""
body01 = ("--   원인: 10-08 SLASHOBJ 가 SELECT 식만 NVL(NULLIF(RTRIM(x),''),'/') 로 바꾸고 같은 문장 GROUP BY 식은 NVL(x,'-')/NVL(x,'/') 로 남겨 식 불일치 → 실행 시 ORA-00979 (컴파일은 VALID).\n"
          "--   조치: 해당 GROUP BY 식을 SELECT 식과 동일하게 교정(마커 " + MARK + "). 본문 = 사내 ZIOUI1 적용본 전체(타 작업자 10-08 저녁 변경 포함).\n"
          "--   사내 검증: 각 객체 VALID·오류 0 · GROUP BY 문장 전수 파싱(cursor.parse) ORA-00979 17→0 · 새 INVALID 0.\n")
(OUT / "01_APPLY_ALL_GRPBYFIX.sql").write_text(hdr("01_APPLY_ALL — GROUP BY 식 불일치 회귀 일괄 핫픽스", body01) + "".join(apply_parts) + tail, encoding="utf-8")
(OUT / "99_ROLLBACK_to_1726_payload.sql").write_text(hdr("99_ROLLBACK — 핫픽스 직전 클라우드 본(17:26 페이로드)으로", "--   ⚠ 되돌리면 9 객체 조회/배치에서 ORA-00979 재발. 핫픽스 자체 결함 확인 시에만.\n") + "".join(rollback_parts), encoding="utf-8")

v_marker = "\nUNION ALL\n".join(f"SELECT '{ot}' t, '{nm}' n, {m} exp FROM dual" for ot, nm, m in verify_rows)
verify = hdr("02_VERIFY — 적용 후 검증(조회 전용)", "--   V1 상태/오류 · V2 마커 수(객체별 기대치와 일치) · V3 잔존 불일치 패턴(0행 기대: SELECT 쪽 '/' 식이 있는 객체에서 GROUP BY 쪽 NVL(x,'-') 잔존 여부는 사내 파싱 게이트로 확정했음 — 여기서는 마커 줄 원문만 출력)\n") + f"""
-- V1
SELECT 'V1 | ' || object_type || ' ' || object_name || ' | ' || status || ' | ddl=' || TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS line
  FROM all_objects WHERE owner='SCM_MGR' AND object_name IN ({names_sql}) AND object_type IN ('PACKAGE BODY','PROCEDURE') ORDER BY object_name, object_type;
SELECT 'V1 ERR | ' || type || ' ' || name || ' L' || line || ' | ' || SUBSTR(REPLACE(text,CHR(10),' '),1,200) AS line
  FROM all_errors WHERE owner='SCM_MGR' AND name IN ({names_sql}) AND attribute='ERROR' ORDER BY name, sequence;

-- V2: 마커 수 = 기대치 (MISMATCH 0행 기대)
WITH exp AS (
{v_marker}
), act AS (
    SELECT type t, name n, COUNT(*) cnt FROM all_source WHERE owner='SCM_MGR' AND name IN ({names_sql}) AND type IN ('PACKAGE BODY','PROCEDURE') AND text LIKE '%{MARK}%' GROUP BY type, name
)
SELECT 'V2 | ' || e.t || ' ' || e.n || ' | markers=' || NVL(a.cnt,0) || ' expected=' || e.exp || CASE WHEN NVL(a.cnt,0) = e.exp THEN '' ELSE '  <== MISMATCH' END AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n ORDER BY e.n;

-- V3: 마커 줄 원문(참고)
SELECT 'V3 | ' || type || ' ' || name || ' L' || line || ' | ' || SUBSTR(TRIM(REPLACE(text,CHR(10),'')),1,140) AS line
  FROM all_source WHERE owner='SCM_MGR' AND name IN ({names_sql}) AND type IN ('PACKAGE BODY','PROCEDURE') AND text LIKE '%{MARK}%' ORDER BY name, type, line;
"""
(OUT / "02_VERIFY_GRPBYFIX.sql").write_text(verify, encoding="utf-8")
print("built:", [f.name for f in OUT.glob("*.sql")], "| objects:", [(nm, m) for ot, nm, m in verify_rows])

