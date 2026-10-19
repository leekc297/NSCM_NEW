"""Rebuild cloud package 07: 01_APPLY_ALL (8 objects, PKG_DMF0044 excluded) + 01b_APPLY_PKG_DMF0044 (our 14:42 hotfixed
version, separate because the corporate object is being edited by another worker) + 02_VERIFY + 99_ROLLBACK.
FRESH-GATE: this builder does not touch the DB; its inputs (applied_corp/*.sql) were re-read from ALL_SOURCE immediately after each
corporate apply (see _apply_corp_batch2.py: FRESH-GATE assert on LAST_DDL before CREATE OR REPLACE, re-fetch after)."""
import sys, json, pathlib
HERE = pathlib.Path(__file__).parent
ROOT = HERE.parent.parent
OUT = ROOT / "07_HOTFIX_GROUPBY_BATCH_20261009"; OUT.mkdir(exist_ok=True)
log = json.load(open(HERE / "APPLY_LOG_corp_hotfix.json", encoding="utf-8"))
meta = json.load(open(HERE / "fresh_all/_meta.json", encoding="utf-8"))
MARK = "[E20261009-GRPBYFIX]"
rows = []
for x in log["log"]:
    ot, nm = x["obj"].split("|"); fn = meta[x["obj"]]["file"]
    src = (HERE / "applied_corp" / fn).read_text(encoding="utf-8").rstrip()
    rows.append({"ot": ot, "nm": nm, "fn": fn, "src": src, "markers": src.count(MARK), "ddl": x.get("last_ddl") or ("2026-10-09 14:42:56" if nm == "PKG_DMF0044" else "?"), "n979": x.get("ora979_before", "?")})
    assert src.count(MARK) > 0, nm
main = [r for r in rows if r["nm"] != "PKG_DMF0044"]; d44 = [r for r in rows if r["nm"] == "PKG_DMF0044"]
assert len(main) == 8 and len(d44) == 1
hdr = lambda title, body: f"-- {MARK} {title} · 생성 2026-10-09 · SCM_MGR 접속 후 파일 전체 실행(F5), 바인드·DEFINE 없음\n{body}SET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\n"
cause = ("--   원인: 10-08 SLASHOBJ 가 SELECT 식만 NVL(NULLIF(RTRIM(x),''),'/') 로 바꾸고 같은 문장 GROUP BY 식은 NVL(x,'-') 또는 NVL(x,'/') 로 남겨 식 불일치 → 실행 시 ORA-00979 (컴파일은 VALID).\n"
         "--   조치: GROUP BY 식을 SELECT 식과 동일하게 교정(마커 " + MARK + "). 본문 = 사내 ZIOUI1 적용본 전체.\n"
         "--   사내 검증: 객체별 VALID·오류 0 · GROUP BY 문장 전수 파싱(cursor.parse) ORA-00979 → 0 · 새 INVALID 0.\n")


def apply_file(objs):
    parts = [f"-- ##### {r['ot']} {r['nm']} (사내 적용 {r['ddl']} · ORA-00979 문장 {r['n979']}→0 · 마커 {r['markers']})\nCREATE OR REPLACE {r['src']}\n/\n" for r in objs]
    names = ",".join(f"'{r['nm']}'" for r in objs)
    tail = f"""
-- 적용 결과: 전부 VALID · APPLY ERR 0행 기대
SELECT 'APPLY | ' || object_type || ' ' || object_name || ' | ' || status || ' | ddl=' || TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS line
  FROM all_objects WHERE owner='SCM_MGR' AND object_name IN ({names}) AND object_type IN ('PACKAGE BODY','PROCEDURE') ORDER BY object_name, object_type;
SELECT 'APPLY ERR | ' || type || ' ' || name || ' L' || line || ':' || position || ' | ' || SUBSTR(REPLACE(text,CHR(10),' '),1,200) AS line
  FROM all_errors WHERE owner='SCM_MGR' AND name IN ({names}) AND attribute='ERROR' ORDER BY name, sequence;
"""
    return "".join(parts) + tail


(OUT / "01_APPLY_ALL_GRPBYFIX.sql").write_text(hdr("01_APPLY_ALL — GROUP BY 식 불일치 회귀 일괄 핫픽스 (8객체, PKG_DMF0044 제외 → 01b)", cause) + apply_file(main), encoding="utf-8")
(OUT / "01b_APPLY_PKG_DMF0044_GRPBYFIX.sql").write_text(hdr("01b_APPLY_PKG_DMF0044 — 별도 파일", cause +
    "--   ⚠ PKG_DMF0044 는 사내에서 2026-10-09 15:00:45 타 작업자가 자기 사본으로 덮어써 편집 중(15:15:55 INVALID). 이 파일 = 그 직전 사내 적용본(14:42:56, 10-08 수정분 + 핫픽스 17줄).\n"
    "--      타 작업자 변경(ENERGE_KWH 포맷·NO_DATA_FOUND 처리)은 포함되지 않음. 그 변경을 함께 올려야 하면 사내 재교정(pending 파일) 뒤 다시 생성한다.\n") + apply_file(d44), encoding="utf-8")
# rollback: both sets, from 17:26 payload backup kept in _work? the payload copies were overwritten → use 00_BACKUP? No: cloud pre-hotfix = 17:26 payload == 01_NEW at that time. Use 99 of previous build if exists.
prev99 = OUT / "99_ROLLBACK_to_1726_payload.sql"
if not prev99.exists():
    print("⚠ 99 rollback not found")
names_all = ",".join(f"'{r['nm']}'" for r in rows)
v_marker = "\nUNION ALL\n".join(f"SELECT '{r['ot']}' t, '{r['nm']}' n, {r['markers']} exp FROM dual" for r in rows)
verify = hdr("02_VERIFY — 적용 후 검증(조회 전용, 9객체)", "--   V1 상태/오류 · V2 마커 수 = 기대치(MISMATCH 0행) · V3 마커 줄 원문. PKG_DMF0044 를 01b 로 올리지 않았으면 V2 에서 PKG_DMF0044 만 MISMATCH 로 나오는 것이 정상.\n") + f"""
SELECT 'V1 | ' || object_type || ' ' || object_name || ' | ' || status || ' | ddl=' || TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS line
  FROM all_objects WHERE owner='SCM_MGR' AND object_name IN ({names_all}) AND object_type IN ('PACKAGE BODY','PROCEDURE') ORDER BY object_name, object_type;
SELECT 'V1 ERR | ' || type || ' ' || name || ' L' || line || ' | ' || SUBSTR(REPLACE(text,CHR(10),' '),1,200) AS line
  FROM all_errors WHERE owner='SCM_MGR' AND name IN ({names_all}) AND attribute='ERROR' ORDER BY name, sequence;
WITH exp AS (
{v_marker}
), act AS (
    SELECT type t, name n, COUNT(*) cnt FROM all_source WHERE owner='SCM_MGR' AND name IN ({names_all}) AND type IN ('PACKAGE BODY','PROCEDURE') AND text LIKE '%{MARK}%' GROUP BY type, name
)
SELECT 'V2 | ' || e.t || ' ' || e.n || ' | markers=' || NVL(a.cnt,0) || ' expected=' || e.exp || CASE WHEN NVL(a.cnt,0) = e.exp THEN '' ELSE '  <== MISMATCH' END AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n ORDER BY e.n;
SELECT 'V3 | ' || type || ' ' || name || ' L' || line || ' | ' || SUBSTR(TRIM(REPLACE(text,CHR(10),'')),1,140) AS line
  FROM all_source WHERE owner='SCM_MGR' AND name IN ({names_all}) AND type IN ('PACKAGE BODY','PROCEDURE') AND text LIKE '%{MARK}%' ORDER BY name, type, line;
"""
(OUT / "02_VERIFY_GRPBYFIX.sql").write_text(verify, encoding="utf-8")
# sync SLASHOBJ package copies for the 8 (DMF0044 copy already synced to 14:42 version by previous build)
for r in main:
    (ROOT / "05_CLOUD_PAYLOAD_corp" / r["fn"]).write_text(r["src"] + "\n", encoding="utf-8")
    (ROOT / "01_NEW_corp" / r["fn"]).write_text(r["src"] + "\n", encoding="utf-8")
    (ROOT / "03_CLOUD_APPLY_sqlplus" / r["fn"]).write_text(f"-- [E20261008-SLASHOBJ]+{MARK} {r['ot']} {r['nm']} — 사내 현재 원문(핫픽스 적용본, 사내 LAST_DDL {r['ddl']})\nCREATE OR REPLACE {r['src']}\n/\nSHOW ERRORS {r['ot']} {r['nm']}\n", encoding="utf-8")
print("built:", sorted(f.name for f in OUT.glob("*.sql")))
print("objects:", [(r["nm"], r["markers"], r["ddl"]) for r in rows])

