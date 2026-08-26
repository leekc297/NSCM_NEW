# -*- coding: utf-8 -*-
"""클라우드 이관 패키지 17_PKG_DMF0051_BODY.sql 재생성 — 사내 라이브 ALL_SOURCE 직덤프.

⚠ 헤더 주석의 'PACKAGE BODY' 문자열로 자르는 방식 금지 (실사고 계보).
   ALL_SOURCE 는 'PACKAGE BODY PKG_DMF0051 ...' 로 시작하므로 'CREATE OR REPLACE ' 접두만 붙인다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

DST = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\17_PKG_DMF0051_BODY.sql"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
lines = [r[0] for r in cur.fetchall()]
body = "".join(t if t.endswith("\n") else t + "\n" for t in lines)

# 자기검증 ①: 본문 시작 토큰
assert body.lstrip().upper().startswith("PACKAGE BODY"), "ALL_SOURCE 시작 토큰 이상"
# 자기검증 ②: 마커
MK = {"[E20260820-D51SCALAR]": 1, "[E20260820-D51REGROUP]": 1, "[E20260820-D51SEMI]": 1, "[E20260820-D51ITEMPFX]": 1,
      "[E20260820-DS2]": 1, "[E20260806-00979]": 3, "[E20260806-WF]": 3}
for m, n in MK.items():
    g = body.count(m)
    assert g == n, f"마커 {m} = {g} (기대 {n})"
# 자기검증 ③: 타 패키지 미포함
assert "PACKAGE BODY PKG_DMF0022" not in body and "PACKAGE BODY PKG_DMF0035" not in body
# 자기검증 ④: 종결
assert body.rstrip().endswith("END PKG_DMF0051;"), "본문 종결자 이상"

HDR = (
    "-- DMF0035_CLOUD_20260820 / 17_PKG_DMF0051_BODY.sql\n"
    "-- PKG_DMF0051 PACKAGE BODY — Biz Plan Waterfall (사내 라이브 재덤프 2026-08-21)\n"
    "--   [E20260820-DS2]        클라우드 optimizer_dynamic_sampling=0 방어 1줄 포함\n"
    "--   [E20260820-D51SCALAR]  GT_DM51_SCM_MST_SITE_ITEM 행별 상관 스칼라/함수 → DISTINCT OWNER 선계산 + LEFT JOIN\n"
    "--   [E20260820-D51REGROUP] GT_DM22_DM_MST_ITEM_SINGLE_V 무용 GROUP BY 제거 (값 무영향 — 유일성 증명)\n"
    "--   [E20260820-D51SEMI]    최종 동적SQL div40 분기 INNER JOIN SCM_MST_SITE → EXISTS (PK 유일 → 등가)\n--   [E20260820-D51ITEMPFX] SCM_MST_ITEM_SN → ORI_V 적재 선행축소 (prefix 12자, 243,050행 → 3,559행)\n"
    "--   실행: SQL*Plus 에서 이 파일을 그대로 @실행 (말미 '/' 로 컴파일)\n"
    "SET DEFINE OFF\n"
    "SET SQLBLANKLINES ON\n"
)
out = HDR + "CREATE OR REPLACE " + body.lstrip("\n") + "/\nSHOW ERRORS\n"
open(DST, "w", encoding="utf-8", newline="\n").write(out)
print(f"[saved] {DST} ({len(out)} bytes / {out.count(chr(10))} lines)")

# 자기검증 ⑤: 산출 파일 형식
chk = open(DST, encoding="utf-8").read()
seq = ["-- DMF0035_CLOUD_20260820", "SET DEFINE OFF", "SET SQLBLANKLINES ON",
       "CREATE OR REPLACE PACKAGE BODY", "\n/\n", "SHOW ERRORS"]
pos = -1
for s in seq:
    i = chk.find(s, pos + 1)
    assert i > pos, f"형식 순서 위반: {s}"
    pos = i
assert chk.count("CREATE OR REPLACE PACKAGE BODY") == 1
print("[자기검증] 헤더→SET DEFINE OFF→SET SQLBLANKLINES ON→CREATE OR REPLACE→/→SHOW ERRORS 순서 OK / 마커 6종 OK")
con.close()


