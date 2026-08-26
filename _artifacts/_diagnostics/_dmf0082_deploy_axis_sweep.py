#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 클라우드 이관 대상 축 전수 스윕 (기계 도출 — 손나열 금지, hook #140 deploy-axis-sweep-mandatory).

축 (딕셔너리/카탈로그에서 기계 도출):
  A. 메타 문자열 축 : SCM_ADM_%/SCM_MST_%/DM_ADM_% 전 테이블 문자열 컬럼에 'DMF0082' 보유
  B. DB 객체 축     : 이름 매칭(DMF0082/DM82) + PKG_DMF0082 의존객체(GTT/함수/타입/뷰)
  C. MSG/LBL/MNU 축 : FE 소스 + PKG BODY 에서 코드 추출 후 메타 실존 조회
  D. CMBO 축        : SHEET_COLUMNS(CELL_COMBO_DATA_TYPE / ATTRIBUTE9) + FE 소스 콤보명
                      → SCM_ADM_CMBO_SQL_M 실존 + 공유 여부(타 화면 소비 카운트)
  E. 시간 축        : A 축 각 테이블의 LAST_UPDATE_DATE 최대 + 기준일 이후 행수 (delta 판정)
  F. BODY 마커 축   : PKG_DMF0082 BODY 의 [E2026MMDD-XXXX] 마커 계보 카운트

⚠ 쿼리 실패 = 즉시 중단 (SKIP 금지 — "확인 못 함"을 "변경 없음"으로 읽히게 두면 축이 조용히 빠진다)
"""
import io
import json
import pathlib
import re
import sys
from collections import Counter

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

MENU = "DMF0082"
PKG = "PKG_DMF0082"
PATTERN = "DMF0082"
BASELINE = "20260820"   # 직전 취합 패키지 기준일 (delta 판정용)
FE_DIR = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")
OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260823\_survey")
OUT.mkdir(parents=True, exist_ok=True)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
result = {"menu": MENU, "baseline": BASELINE,
          "A_meta": [], "B_objects": [], "C_msg_lbl_mnu": {}, "D_cmbo": [],
          "E_time": [], "F_markers": {}}


def q(sql, binds=None, label=""):
    try:
        cur.execute(sql, binds or {})
        return cur.fetchall()
    except Exception as e:
        con.close()
        sys.exit(f"\n⛔ 중단 — 쿼리 실패 [{label}]: {e}\n   (SKIP 금지 룰: 확인 못 한 축을 넘기지 않는다)")


# ══════════════════ A. 메타 문자열 축 ══════════════════
print("=" * 104)
print("A. 메타 문자열 축 — SCM_ADM_%/SCM_MST_%/DM_ADM_% 전 테이블 기계 스윕")
print("=" * 104)
tables = [r[0] for r in q("""
    SELECT t.TABLE_NAME FROM ALL_TABLES t
     WHERE t.OWNER='SCM_MGR'
       AND (t.TABLE_NAME LIKE 'SCM_ADM_%' OR t.TABLE_NAME LIKE 'SCM_MST_%'
            OR t.TABLE_NAME LIKE 'DM_ADM_%')
       AND t.TABLE_NAME NOT LIKE '%_BAK%' AND t.TABLE_NAME NOT LIKE 'BAK%'
       AND t.TABLE_NAME NOT LIKE '%DROP%'
     ORDER BY 1""", label="후보 테이블")]
print(f"후보 테이블 {len(tables)}개 스캔\n")

for t in tables:
    scols = [r[0] for r in q("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                                 AND TABLE_NAME=:t AND DATA_TYPE IN ('VARCHAR2','CHAR')
                                 ORDER BY COLUMN_ID""", {"t": t}, f"컬럼 {t}")]
    if not scols:
        continue
    # 컬럼명은 반드시 인용 — 숫자로 시작하는 식별자(예: "2LEVEL_DEPT_ID")가 실제로 존재한다
    where = " OR ".join('"%s" LIKE \'%%%s%%\'' % (c, PATTERN) for c in scols)
    n = q(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {where}", label=f"카운트 {t}")[0][0]
    if n:
        hit_cols = []
        for c in scols:
            m = q('SELECT COUNT(*) FROM SCM_MGR.%s WHERE "%s" LIKE \'%%%s%%\''
                  % (t, c, PATTERN), label=f"컬럼카운트 {t}.{c}")[0][0]
            if m:
                hit_cols.append(f"{c}({m})")
        print(f"  ⭐ {t:<38} {n:>6}행   보유컬럼={', '.join(hit_cols)}")
        result["A_meta"].append({"table": t, "rows": n, "columns": hit_cols,
                                 "where": where})

print(f"\n=> A축 이관 대상 테이블 {len(result['A_meta'])}개")

# ══════════════════ E. 시간 축 (A축 테이블별 delta) ══════════════════
print("\n" + "=" * 104)
print(f"E. 시간 축 — A축 테이블별 LAST_UPDATE_DATE 최대 / 기준일({BASELINE}) 이후 행수")
print("=" * 104)
for a in result["A_meta"]:
    t, where = a["table"], a["where"]
    has_lud = q("""SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME=:t AND COLUMN_NAME='LAST_UPDATE_DATE'""",
                {"t": t}, f"LUD 컬럼 {t}")[0][0]
    if not has_lud:
        print(f"  {t:<38} (LAST_UPDATE_DATE 없음 — 전량 대상 판정)")
        result["E_time"].append({"table": t, "last_update": None, "delta_rows": None})
        continue
    mx = q(f"SELECT TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') "
           f"FROM SCM_MGR.{t} WHERE {where}", label=f"MAX LUD {t}")[0][0]
    dn = q(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE ({where}) "
           f"AND LAST_UPDATE_DATE >= TO_DATE('{BASELINE}','YYYYMMDD')",
           label=f"delta {t}")[0][0]
    flag = "  ⭐delta" if dn else ""
    print(f"  {t:<38} MAX={mx}   {BASELINE}+ = {dn:>5}행{flag}")
    result["E_time"].append({"table": t, "last_update": mx, "delta_rows": dn})

# ══════════════════ B. DB 객체 축 ══════════════════
print("\n" + "=" * 104)
print("B. DB 객체 축 — 이름 매칭 + PKG 의존객체(GTT/함수/타입/뷰)")
print("=" * 104)
named = q("""SELECT OBJECT_TYPE, OBJECT_NAME, STATUS,
                    TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
               FROM ALL_OBJECTS
              WHERE OWNER='SCM_MGR'
                AND (OBJECT_NAME LIKE '%DMF0082%' OR OBJECT_NAME LIKE '%DM82%')
              ORDER BY OBJECT_TYPE, OBJECT_NAME""", label="이름매칭 객체")
for typ, name, st, ddl in named:
    tmp = ""
    if typ == "TABLE":
        r = q("SELECT TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:n",
              {"n": name}, f"임시여부 {name}")
        tmp = " [GTT]" if r and r[0][0] == "Y" else ""
    print(f"  {typ:<14} {name:<44} {st:<8} DDL={ddl}{tmp}")
    result["B_objects"].append({"type": typ, "name": name, "status": st,
                                "last_ddl": ddl, "gtt": bool(tmp)})

print(f"\n  -- {PKG} 의존 객체 (자급 대상 판정용) --")
deps = q("""SELECT DISTINCT REFERENCED_TYPE, REFERENCED_NAME FROM ALL_DEPENDENCIES
             WHERE OWNER='SCM_MGR' AND NAME=:p AND REFERENCED_OWNER='SCM_MGR'
               AND REFERENCED_TYPE IN ('FUNCTION','PROCEDURE','PACKAGE','TYPE','VIEW')
             ORDER BY 1,2""", {"p": PKG}, label="의존객체")
for typ, name in deps:
    print(f"  dep {typ:<12} {name}")
    result["B_objects"].append({"type": f"dep:{typ}", "name": name, "status": "-",
                                "last_ddl": None, "gtt": False})

print(f"\n  -- {PKG} 참조 GTT (BODY 원문 스캔 + ALL_TABLES TEMPORARY='Y') --")
body = "".join(t for (t,) in q(
    "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:p "
    "AND TYPE='PACKAGE BODY' ORDER BY LINE", {"p": PKG}, "BODY 덤프") if t)
gtt_tokens = sorted(set(re.findall(r"\bGT_[A-Z0-9_]+", body)))
gtts = []
for g in gtt_tokens:
    r = q("SELECT TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:n",
          {"n": g}, f"GTT {g}")
    state = "GTT" if (r and r[0][0] == "Y") else ("TABLE" if r else "⛔미존재")
    gtts.append({"name": g, "state": state})
    print(f"  {g:<40} {state}")
result["B_objects_gtt"] = gtts
print(f"  => BODY 참조 GT_% {len(gtts)}종 (미존재 {sum(1 for x in gtts if '미존재' in x['state'])})")

# ══════════════════ F. BODY 마커 축 ══════════════════
print("\n" + "=" * 104)
print("F. BODY 마커 축 — [E2026MMDD-XXXX] 계보 (README 정정표 근거)")
print("=" * 104)
markers = Counter(re.findall(r"E2026\d{4}-[A-Z0-9]+", body))
for m, c in sorted(markers.items()):
    star = " ⭐" if m >= f"E{BASELINE}" else ""
    print(f"  {m:<32} {c:>4}회{star}")
result["F_markers"] = dict(markers)
result["F_body_lines"] = body.count("\n") + 1
print(f"  => 마커 {len(markers)}종 / BODY {result['F_body_lines']}줄")

# ══════════════════ C. MSG / LBL / MNU 축 ══════════════════
print("\n" + "=" * 104)
print("C. MSG/LBL/MNU 축 — FE 소스 + PKG BODY 코드 추출 → 메타 실존")
print("=" * 104)
src = "\n".join(f.read_text(encoding="utf-8", errors="ignore")
                for f in FE_DIR.rglob("*") if f.suffix in (".ts", ".tsx"))
msg_fe = set(re.findall(r"MSG\d{5}", src))
lbl_fe = set(re.findall(r"LBL\d{5}", src))
msg_sp = set(re.findall(r"MSG\d{5}", body))
lbl_sp = set(re.findall(r"LBL\d{5}", body))
msg_codes = sorted(msg_fe | msg_sp)
lbl_codes = sorted(lbl_fe | lbl_sp)
print(f"FE {len(msg_fe)} MSG / {len(lbl_fe)} LBL   +   BODY {len(msg_sp)} MSG / {len(lbl_sp)} LBL")
print(f"  MSG(합집합 {len(msg_codes)}) = {msg_codes}")
print(f"  LBL(합집합 {len(lbl_codes)}) = {lbl_codes}")

msg_tbl = [r[0] for r in q("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
                               AND (TABLE_NAME LIKE 'SCM_ADM_MSG%' OR TABLE_NAME LIKE 'SCM_ADM_LBL%')
                               AND TABLE_NAME NOT LIKE '%_BAK%' ORDER BY 1""", label="MSG/LBL 테이블")]
print(f"\n  MSG/LBL 메타 테이블 = {msg_tbl}")
result["C_msg_lbl_mnu"] = {"msg_codes": msg_codes, "lbl_codes": lbl_codes,
                           "msg_from_fe": sorted(msg_fe), "msg_from_sp": sorted(msg_sp),
                           "lbl_from_fe": sorted(lbl_fe), "lbl_from_sp": sorted(lbl_sp),
                           "msg_lbl_tables": msg_tbl, "existence": {}}

for tbl in msg_tbl:
    keycol = "MSG_ID" if "MSG" in tbl else "LBL_ID"
    cols = [r[0] for r in q("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                                AND TABLE_NAME=:t ORDER BY COLUMN_ID""", {"t": tbl}, f"컬럼 {tbl}")]
    if keycol not in cols:
        keycol = next((c for c in cols if c.endswith("_ID")), cols[0])
    codes = msg_codes if "MSG" in tbl else lbl_codes
    if not codes:
        continue
    inlist = ",".join(f"'{c}'" for c in codes)
    found = q(f"SELECT {keycol}, COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI')"
              f" FROM SCM_MGR.{tbl} WHERE {keycol} IN ({inlist})"
              f" GROUP BY {keycol} ORDER BY 1", label=f"코드조회 {tbl}")
    have = {r[0]: {"rows": r[1], "last_update": r[2]} for r in found}
    missing = [c for c in codes if c not in have]
    delta = sorted(k for k, v in have.items()
                   if v["last_update"] and v["last_update"].replace("-", "")[:8] >= BASELINE)
    print(f"  {tbl:<24} 키={keycol:<8} 보유 {len(have)}/{len(codes)}종"
          + (f"  ⛔ 사내 미등록={missing}" if missing else "  (전량 사내 등록)")
          + (f"  ⭐{BASELINE}+ 갱신={delta}" if delta else ""))
    result["C_msg_lbl_mnu"]["existence"][tbl] = {"key": keycol, "have": have,
                                                 "missing": missing, "delta": delta}

print("\n  -- MNU 축 (메뉴/버튼/권한) --")
for tbl, where in [
    ("SCM_ADM_MNU_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_MNU_BTN_MPG_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_USER_GR_MNU_MPG_M", f"MNU_ID='{MENU}'"),
]:
    exists = q("SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t",
               {"t": tbl}, f"테이블존재 {tbl}")[0][0]
    if not exists:
        print(f"  {tbl:<34} ⛔ 테이블 미존재")
        continue
    n = q(f"SELECT COUNT(*) FROM SCM_MGR.{tbl} WHERE {where}", label=f"MNU축 {tbl}")[0][0]
    print(f"  {tbl:<34} {n:>5}행")
    result["C_msg_lbl_mnu"].setdefault("mnu", {})[tbl] = n

# ══════════════════ D. CMBO 축 ══════════════════
print("\n" + "=" * 104)
print("D. CMBO 축 — 메타(표시/편집) + FE 소스 → CMBO_SQL_M 실존 + 공유 판정")
print("=" * 104)
meta_combo = q("""SELECT DISTINCT TRIM(CELL_COMBO_DATA_TYPE) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                   WHERE PROGRAM_ID LIKE '%DMF0082%' AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL
                   UNION
                  SELECT DISTINCT TRIM(ATTRIBUTE9) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                   WHERE PROGRAM_ID LIKE '%DMF0082%' AND TRIM(ATTRIBUTE9) IS NOT NULL""",
               label="메타 콤보")
meta_names = sorted({r[0] for r in meta_combo if r[0]})
fe_names = sorted(set(re.findall(r"['\"]([A-Za-z][A-Za-z0-9_]{3,})['\"]\s*(?=[,)\]}])", "")))  # placeholder
# FE 콤보명 — comboId/comboName/dataType 키에 오는 문자열 리터럴 추출
fe_names = sorted(set(re.findall(
    r"(?:comboId|comboName|comboType|dataType|cellComboDataType|CELL_COMBO_DATA_TYPE)\s*[:=]\s*['\"]([A-Za-z][\w]+)['\"]",
    src)))
# GRID_EDIT_COMBO / SEARCH combo 상수 블록의 값도 수집
fe_names += re.findall(r"['\"]([A-Za-z][\w]*(?:ByDivision|ByEndCustomer|DMF0082|Customer|Site|Type|Team)[\w]*)['\"]", src)
fe_names = sorted(set(fe_names))
print(f"  메타 콤보 {len(meta_names)}종 = {meta_names}")
print(f"  FE 후보 {len(fe_names)}종 = {fe_names}")

cand = sorted(set(meta_names) | set(fe_names))
for c in cand:
    row = q("""SELECT SQL_ID, SQL_NM, USE_YN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
                 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s""", {"s": c}, f"CMBO {c}")
    if not row:
        continue
    sid, nm, use, lud = row[0]
    shared = q("""SELECT COUNT(DISTINCT PROGRAM_ID) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                   WHERE TRIM(CELL_COMBO_DATA_TYPE) = :s OR TRIM(ATTRIBUTE9) = :s""",
               {"s": c}, f"공유 {c}")[0][0]
    mark = " ⭐delta" if (lud or "").replace("-", "")[:8] >= BASELINE else ""
    warn = "  ⚠공유" if shared > 1 else ""
    print(f"  {sid:<38} USE={use} LUD={lud} 소비화면={shared}{warn}{mark}")
    result["D_cmbo"].append({"sql_id": sid, "sql_nm": nm, "use_yn": use,
                             "last_update": lud, "consumer_programs": shared,
                             "source": ("meta" if c in meta_names else "fe")})
print(f"  => CMBO 실존 {len(result['D_cmbo'])}종 "
      f"(공유 {sum(1 for x in result['D_cmbo'] if x['consumer_programs'] > 1)})")

(OUT / "axis_sweep_result.json").write_text(
    json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"\n결과 저장 -> {OUT / 'axis_sweep_result.json'}")
con.close()
