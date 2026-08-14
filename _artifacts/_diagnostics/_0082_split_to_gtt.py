#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 — `UF_FX_String_SplitForIN` 테이블 함수 → **GTT 선적재** 치환 (hook #129 §3.0 / 2순위).

사용자 지시(2026-08-15): "UF_FX_String_SplitForIn 이 있으면 GT/GTT Temp Table 에 사전 넣어서
  사용 시에는 Function 을 사용하지 않고 Temp Table 을 사용하도록 보완."

대상 (PKG_DMF0082 실측 19곳):
  P_DMF0082_GET_MAIN_DATA                      6곳  ← 측정된 조회 경로
  P_DMF0082_GET_MAIN_DATA_CURRENT              4곳
  P_DMF0082_POPUP_..._SAVE_PRICE_POPUP         9곳  ← savePriceData 2.83s (≥2초 대상)

⚠ 선적재는 **어떤 IF 블록에도 넣지 않는다**(§3.0.4) — 2026-08-15 센티널 패치가
  `IF p_team_id <> 'ALL'` 안에 들어가 미실행된 실패 계보.
⚠ 'ALL' 의미론 보존 — 원본 호출부는 이미 `IF p_x <> 'ALL'` 가드 안에서만 필터하므로,
  토큰 유무가 조회 의미를 바꾸지 않는다. 치환은 **행집합 출처만** 바꾼다.
"""
import io, re, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_PERF_20260815")
OUT.mkdir(parents=True, exist_ok=True)
GTT = "GT_DMF0082_PARAM_TOKEN"

DDL = f"""CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{GTT}
( PARAM_NM VARCHAR2(30 CHAR)
, TOKEN    VARCHAR2(960 CHAR)
) ON COMMIT PRESERVE ROWS"""
IDX = f"CREATE INDEX SCM_MGR.IX_{GTT}_01 ON SCM_MGR.{GTT} (PARAM_NM)"

# 프로시저별 사용 파라미터 (실측)
PROC_PARAMS = {
    'P_DMF0082_GET_MAIN_DATA':
        ['p_plant_site_id', 'p_project_code', 'p_owner', 'p_sender_code', 'p_team_id', 'p_scm_site_id'],
    'P_DMF0082_GET_MAIN_DATA_CURRENT':
        ['p_plant_site_id', 'p_project_code', 'p_owner', 'p_sender_code'],
    'P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP':
        ['p_division_id', 'p_scm_site_id', 'p_plant_site_id', 'p_dept_id', 'p_end_customer', 'p_biztype'],
}

u, p_, d = conn_info()
con = oracledb.connect(user=u, password=p_, dsn=d)
cur = con.cursor()

# ── 1) GTT DDL (멱등) ──────────────────────────────────────────────────────
cur.execute("SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1", [GTT])
if cur.fetchone()[0] == 0:
    cur.execute(DDL); print(f"[DDL] {GTT} 생성")
    cur.execute(IDX); print(f"[DDL] IX_{GTT}_01 생성")
else:
    print(f"[DDL] {GTT} 이미 존재 — skip")
(OUT / "04_DDL_GT_DMF0082_PARAM_TOKEN.sql").write_text(
    f"-- hook #129 §3.0 — 테이블 함수 치환용 토큰 GTT (이관 패키지 자급 의무)\n"
    f"SET DEFINE OFF\n{DDL};\n{IDX};\n", encoding="utf-8")

# ── 2) 본문 치환 ───────────────────────────────────────────────────────────
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
(OUT / "00_BACKUP4_PKG_DMF0082_BODY.sql").write_text(
    "-- 테이블함수→GTT 치환 전 백업\nSET DEFINE OFF\nCREATE OR REPLACE " + body.rstrip() + "\n/\n",
    encoding="utf-8")

before = len(re.findall(r"UF_FX_String_SplitForIN", body, re.I))
print(f"[before] 함수 호출 {before}곳")

# 2-a) 호출부 치환 — TABLE(UF_FX_String_SplitForIN(p_x, ',')) → (SELECT TOKEN FROM GTT WHERE PARAM_NM='p_x')
def repl(m):
    param = m.group(1)
    return (f"(SELECT TOKEN FROM SCM_MGR.{GTT} WHERE PARAM_NM = '{param}')")
body2, n_call = re.subn(
    r"TABLE\s*\(\s*UF_FX_String_SplitForIN\s*\(\s*([A-Za-z0-9_]+)\s*,\s*','\s*\)\s*\)",
    repl, body, flags=re.I)
print(f"[치환] 호출부 {n_call}곳")

# 2-b) 별칭 참조 컬럼명 보정 — TABLE(...) P → 서브쿼리 P 이므로 P.COLUMN_VALUE → P.TOKEN
body2, n_col = re.subn(r"\bCOLUMN_VALUE\b", "TOKEN", body2)
print(f"[치환] COLUMN_VALUE → TOKEN {n_col}곳")

# 2-c) 프로시저별 선적재 삽입 (BEGIN 직후, 조건 블록 밖)
ins_total = 0
for proc, params in PROC_PARAMS.items():
    st = body2.find(f"PROCEDURE {proc}")
    if st < 0:
        print(f"   ⚠ {proc} 미발견 — skip"); continue
    m = re.search(r"\n(\s*)BEGIN\b", body2[st:])
    if not m:
        print(f"   ⚠ {proc} BEGIN 미발견 — skip"); continue
    pos = st + m.end()
    ind = m.group(1) + "    "
    lines = [f"\n{ind}/* ⭐ [E20260815-SPLIT2GTT] hook #129 §3.0 (2순위) — 테이블 함수 → GTT 선적재.",
             f"{ind}   `TABLE(UF_FX_String_SplitForIN(p_x,','))` 는 카디널리티 추정이 고정값으로 굳고,",
             f"{ind}   같은 파라미터를 여러 곳에서 쓰면 그때마다 PIPELINED 함수가 다시 돈다(패키지 내 19곳 실측).",
             f"{ind}   파라미터당 **1회만** 쪼개 GTT 에 넣고, 호출부는 GTT 를 읽는다.",
             f"{ind}   ⚠ 이 블록은 **어떤 IF 안에도 두지 않는다** — 조건 블록에 들어가면 일반 조회에서",
             f"{ind}     통째로 건너뛰어 토큰이 비고 조회가 전멸한다(2026-08-15 센티널 패치 실패 계보). */",
             f"{ind}DELETE FROM SCM_MGR.{GTT};"]
    for prm in params:
        lines.append(f"{ind}INSERT INTO SCM_MGR.{GTT} (PARAM_NM, TOKEN)")
        # ⚠ 파이프라인 함수의 반환 컬럼은 COLUMN_VALUE 다 — GTT 의 TOKEN 과 혼동 금지.
        #   (2026-08-15 최초 시도에서 TOKEN 으로 써 ORA-00904 20건 발생)
        lines.append(f"{ind}SELECT '{prm}', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN({prm}, ','));")
    blk = "\n".join(lines) + "\n"
    body2 = body2[:pos] + blk + body2[pos:]
    ins_total += 1
    print(f"   [선적재] {proc}: 파라미터 {len(params)}개")

after = len(re.findall(r"UF_FX_String_SplitForIN", body2, re.I))
print(f"\n[after] 함수 호출 {after}곳 (선적재 {sum(len(v) for v in PROC_PARAMS.values())}곳만 남아야 정상)")

(OUT / "05_PKG_DMF0082_BODY_SPLIT2GTT.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body2.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"[deploy] errors={len(errs)}")
for e in errs[:8]:
    print("   ", e[0], str(e[1])[:130])
con.close()
