#!/usr/bin/env python3
"""
gen_dmf0020_authunion_sql.py — DMF0020 AUTHUNION 2곳 SP 패치 파일 생성기 (읽기 전용)

ALL_SOURCE 에서 두 standalone SP 원문을 덤프해 그룹 판정을 보유그룹 합집합(AUTHUNION)으로
확장한 CREATE OR REPLACE 파일 + 원문 백업을 _apply_corporate 에 생성한다. DB 는 변경하지 않는다.
  [1] DMF0020_GET_SCM_MST_FUTURE_PRICE               (L190 부근: SEGMENT1=P_USERINFO OR P_CREATED_BY)
  [2] DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (L55: SEGMENT1 = p_userinfo)
실행은 별도 `python ora.py exec <파일>` (①사내 ②클라우드 QA ③클라우드 DEV).
"""
import sys, pathlib, re

sys.stdout.reconfigure(encoding="utf-8")
ROOT = pathlib.Path(__file__).resolve().parents[2]
env = {}
for line in (ROOT / ".env.asis").read_text().splitlines():
    if "=" in line and not line.strip().startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip()

import oracledb
oc = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
c = oc.cursor()
OUT = ROOT / "_artifacts" / "_apply_corporate"

HDR = """-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
-- (클라우드 DB 적용물은 QA·DEV 2군데 동시 적용 의무 — 2026-08-04 사용자 확정)
-- 정책: 본문 무수정 원칙 — 그룹 판정 1개 조건만 [AUTHUNION 2026-08-05] 마커로 확장 / 데이터 무변경
"""

def fetch_src(name):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1 AND TYPE='PROCEDURE' ORDER BY LINE", [name])
    return "".join(r[0] for r in c.fetchall())

MARK = "[AUTHUNION 2026-08-05]"
UNION_GET = (" OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M /* " + MARK + " */\n"
             "                               WHERE USER_ID IN (P_USERINFO, P_CREATED_BY) AND USE_YN = 'Y')")
UNION_POP = ("            OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M /* " + MARK + " */\n"
             "                            WHERE USER_ID IN (p_userinfo, p_created_by) AND USE_YN = 'Y')")

jobs = [
    ("DMF0020_GET_SCM_MST_FUTURE_PRICE",
     re.compile(r"AND \(SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY\)"),
     lambda m: "AND (SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY" + UNION_GET + ")",
     "DMF0020_AUTHUNION_GET_20260805.sql"),
    ("DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP",
     re.compile(r"AND SEGMENT1 = p_userinfo;"),
     lambda m: "AND (SEGMENT1 = p_userinfo\n" + UNION_POP + ");",
     "DMF0020_AUTHUNION_SAVE_PRICE_POPUP_20260805.sql"),
]

for name, pat, repl, fname in jobs:
    src = fetch_src(name)
    hits = pat.findall(src)
    assert len(hits) == 1, f"{name}: 매칭 {len(hits)}회 (기대 1)"
    assert MARK not in src, f"{name}: 이미 적용됨"
    bk = OUT / f"BACKUP_{name}_pre_authunion_20260805.sql"
    bk.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
    patched = pat.sub(lambda m: repl(m), src, count=1)
    out = OUT / fname
    body = (f"-- {fname}\n-- 목적: DMF0020 그룹 판정 보유그룹 합집합(AUTHUNION) 확장 — 타 3UI(0003/0021/0082) 정렬\n"
            f"-- 원문 백업: {bk.name}\n" + HDR +
            "CREATE OR REPLACE " + patched + "\n/\n"
            f"-- 검증: SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{name}';\n")
    out.write_text(body, encoding="utf-8")
    print(f"생성: {fname} ({len(patched.splitlines())}줄) + 백업 {bk.name}")

oc.close()
