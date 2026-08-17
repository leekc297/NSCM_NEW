#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""화면별 클라우드 이관 대상 축 전수 스윕 — 인자로 MENU_ID 지정

원본: _dmf0074_deploy_axis_sweep.py (기계 도출 — 손나열 금지, hook deploy-axis-sweep-mandatory).

축 3계열을 딕셔너리/카탈로그에서 기계적으로 도출한다.
  A. 메타 문자열 축 : SCM_ADM_%/SCM_MST_% 전 테이블의 문자열 컬럼에 'DMF0074'(또는 DMF0074_40) 보유
  B. DB 객체 축     : PKG_DMF0074 + 이름에 DMF0074/DM74 포함 객체 + PKG 의존객체(GTT/함수/타입)
  C. MSG/LBL/MNU 축 : 문자열 스캔으로는 안 걸리는 축 — FE 소스에서 코드 추출 후 메타 행 조회
                      (2026-07-24 감사: 393 중 323 누락 — LBL·MNU 전멸 사고 방지)

⚠ 쿼리 실패 = 즉시 중단 (SKIP 금지 — "확인 못 함"을 "변경 없음"으로 읽히게 두면 축이 조용히 빠진다)
"""
import io
import json
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

MENU = (sys.argv[1] if len(sys.argv) > 1 else "DMF0074")
PATTERNS = [MENU]               # 접미 변형(예: DMF0074_40)도 LIKE 로 포함
FE_MAP = {"DMF0074": "metal-link-price", "DMF0014": "customer-fcst-upload"}
# GTT 접두 등 화면별 짧은 토큰 (객체명 매칭용)
SHORT_MAP = {"DMF0074": "DM74", "DMF0014": "DPCF"}
SHORT = SHORT_MAP.get(MENU, MENU)
FE_DIR = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages") / FE_MAP[MENU]
OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages") / f"{MENU}_CLOUD_20260818" / "_survey"
OUT.mkdir(parents=True, exist_ok=True)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
result = {"A_meta": [], "B_objects": [], "C_msg_lbl_mnu": {}}


def q(sql, binds=None, label=""):
    try:
        cur.execute(sql, binds or {})
        return cur.fetchall()
    except Exception as e:
        con.close()
        sys.exit(f"\n⛔ 중단 — 쿼리 실패 [{label}]: {e}\n   (SKIP 금지 룰: 확인 못 한 축을 넘기지 않는다)")


# ══════════════════ A. 메타 문자열 축 ══════════════════
print("=" * 100)
print("A. 메타 문자열 축 — SCM_ADM_%/SCM_MST_% 전 테이블 기계 스윕")
print("=" * 100)
tables = [r[0] for r in q("""
    SELECT t.TABLE_NAME FROM ALL_TABLES t
     WHERE t.OWNER='SCM_MGR'
       AND (t.TABLE_NAME LIKE 'SCM_ADM_%' OR t.TABLE_NAME LIKE 'SCM_MST_%'
            OR t.TABLE_NAME LIKE 'DM_ADM_%')
       AND t.TABLE_NAME NOT LIKE '%_BAK%' AND t.TABLE_NAME NOT LIKE '%DROP%'
     ORDER BY 1""", label="후보 테이블")]
print(f"후보 테이블 {len(tables)}개 스캔\n")

for t in tables:
    scols = [r[0] for r in q("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                                 AND TABLE_NAME=:t AND DATA_TYPE IN ('VARCHAR2','CHAR')
                                 ORDER BY COLUMN_ID""", {"t": t}, f"컬럼 {t}")]
    if not scols:
        continue
    # 컬럼명은 반드시 인용 — 숫자로 시작하는 식별자(예: "2LEVEL_DEPT_ID")가 실제로 존재한다
    where = " OR ".join('"%s" LIKE \'%%%s%%\'' % (c, PATTERNS[0]) for c in scols)
    n = q(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {where}", label=f"카운트 {t}")[0][0]
    if n:
        # 어느 컬럼이 담고 있는지까지 기록 (이관 SQL 의 WHERE 절 근거)
        hit_cols = []
        for c in scols:
            m = q('SELECT COUNT(*) FROM SCM_MGR.%s WHERE "%s" LIKE \'%%%s%%\''
                  % (t, c, PATTERNS[0]), label=f"컬럼카운트 {t}.{c}")[0][0]
            if m:
                hit_cols.append(f"{c}({m})")
        print(f"  ⭐ {t:<36} {n:>6}행   보유컬럼={', '.join(hit_cols)}")
        result["A_meta"].append({"table": t, "rows": n, "columns": hit_cols})

print(f"\n=> A축 이관 대상 테이블 {len(result['A_meta'])}개")

# ══════════════════ B. DB 객체 축 ══════════════════
print("\n" + "=" * 100)
print("B. DB 객체 축 — 이름 매칭 + PKG 의존객체(GTT/함수/타입)")
print("=" * 100)
named = q("""SELECT OBJECT_TYPE, OBJECT_NAME, STATUS FROM ALL_OBJECTS
              WHERE OWNER='SCM_MGR'
                AND (OBJECT_NAME LIKE '%' || :m || '%' OR OBJECT_NAME LIKE '%' || :s || '%')
              ORDER BY OBJECT_TYPE, OBJECT_NAME""", {"m": MENU, "s": SHORT}, label="이름매칭 객체")
for typ, name, st in named:
    tmp = ""
    if typ == "TABLE":
        r = q("SELECT TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:n",
              {"n": name}, f"임시여부 {name}")
        tmp = " [GTT]" if r and r[0][0] == "Y" else ""
    print(f"  {typ:<14} {name:<42} {st}{tmp}")
    result["B_objects"].append({"type": typ, "name": name, "status": st, "gtt": bool(tmp)})

print("\n  -- PKG_DMF0074 의존 객체 (자급 대상 판정용) --")
deps = q("""SELECT DISTINCT REFERENCED_TYPE, REFERENCED_NAME FROM ALL_DEPENDENCIES
             WHERE OWNER='SCM_MGR' AND NAME='PKG_'||:m AND REFERENCED_OWNER='SCM_MGR'
               AND REFERENCED_TYPE IN ('FUNCTION','PROCEDURE','PACKAGE','TYPE','VIEW')
             ORDER BY 1,2""", {"m": MENU}, label="의존객체")
for typ, name in deps:
    print(f"  dep {typ:<12} {name}")
    result["B_objects"].append({"type": f"dep:{typ}", "name": name, "status": "-", "gtt": False})

# ══════════════════ C. MSG / LBL / MNU 축 ══════════════════
print("\n" + "=" * 100)
print("C. MSG/LBL/MNU 축 — 문자열 스캔 미포착 축 (FE 소스에서 코드 추출)")
print("=" * 100)
src = "\n".join(f.read_text(encoding="utf-8", errors="ignore")
                for f in FE_DIR.rglob("*") if f.suffix in (".ts", ".tsx"))
msg_codes = sorted(set(re.findall(r"MSG\d{5}", src)))
lbl_codes = sorted(set(re.findall(r"LBL\d{5}", src)))
print(f"FE 소스 추출 — MSG {len(msg_codes)}종 / LBL {len(lbl_codes)}종")
print(f"  MSG = {msg_codes}")
print(f"  LBL = {lbl_codes}")

msg_tbl = [r[0] for r in q("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
                               AND (TABLE_NAME LIKE 'SCM_ADM_MSG%' OR TABLE_NAME LIKE 'SCM_ADM_LBL%')
                               AND TABLE_NAME NOT LIKE '%_BAK%' ORDER BY 1""", label="MSG/LBL 테이블")]
print(f"\n  MSG/LBL 메타 테이블 = {msg_tbl}")
result["C_msg_lbl_mnu"] = {"msg_codes": msg_codes, "lbl_codes": lbl_codes,
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
    found = q(f"SELECT {keycol}, COUNT(*) FROM SCM_MGR.{tbl} WHERE {keycol} IN ({inlist})"
              f" GROUP BY {keycol} ORDER BY 1", label=f"코드조회 {tbl}")
    have = {r[0]: r[1] for r in found}
    missing = [c for c in codes if c not in have]
    print(f"  {tbl:<24} 키={keycol:<8} 보유 {len(have)}/{len(codes)}종"
          + (f"  ⛔ 사내 미등록={missing}" if missing else "  (전량 사내 등록)"))
    result["C_msg_lbl_mnu"]["existence"][tbl] = {"key": keycol, "have": have, "missing": missing}

print("\n  -- MNU 축 (메뉴/버튼/권한) --")
for tbl, where in [
    ("SCM_ADM_MNU_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_MNU_BTN_MPG_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", f"MNU_ID='{MENU}'"),
    ("SCM_ADM_USER_GR_MNU_MPG_M", f"MNU_ID='{MENU}'"),
]:
    n = q(f"SELECT COUNT(*) FROM SCM_MGR.{tbl} WHERE {where}", label=f"MNU축 {tbl}")[0][0]
    print(f"  {tbl:<34} {n:>5}행")
    result["C_msg_lbl_mnu"].setdefault("mnu", {})[tbl] = n

(OUT / "axis_sweep_result.json").write_text(
    json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"\n결과 저장 -> {OUT / 'axis_sweep_result.json'}")
con.close()
