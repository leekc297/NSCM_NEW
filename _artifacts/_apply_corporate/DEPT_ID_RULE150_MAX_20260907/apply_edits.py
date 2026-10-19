# -*- coding: utf-8 -*-
"""hook #150 §3 MAX 전환 — PKG_DMF0020 P_DMF0020_GET_SALES_PRICE_TEMPLATE 라인 기반 편집.

원본 보존 규약(2026-09-06 패키지와 동일): 기존 라인은 지우지 않고 접두 주석 처리 + 신규 라인에 마커.
입력 = 00_BACKUP_ASIS/01_PKG_DMF0020.ASIS.sql (USER_SOURCE 원문 + CREATE OR REPLACE 헤더)
출력 = 01_APPLY/01_PKG_DMF0020.sql
"""
import re
import pathlib

S = pathlib.Path(__file__).parent
M = "-- [hook#150-MAX 2026-09-07 AJS] AS-IS: "

NEW = [
    "        -- 2026-09-07 hook#150 AJS: site 대표부서 = (DIVISION_ID, SCM_SITE_ID) 기준 MAX(DEPT_ID) 1건 (룰 §3-1).",
    "        --   AS-IS 는 IM 을 DIV+SITE 단독 INNER JOIN 하여 SITE_ITEM 행수만큼 증식한다(실측 2026-09-07: 키당 최대 3,506행).",
    "        --   DI 는 유효부서 필터 전용(출력 DEPT_ID 는 PK grain 의 TEAM 에서 나온다)이므로",
    "        --   MAX 를 유효부서 집합 '안에서' 취해 통과 키 집합을 보존한다(룰 §3-4 / G150-7).",
    "        INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID",
    "                      FROM SCM_MST_SITE_ITEM SA",
    "                     INNER JOIN SCM_MST_SSO_DEPT_INFO SD",
    "                        ON SD.DEPT_ID  = SA.DEPT_ID",
    "                       AND SD.VALID_YN = 'Y'",
    "                     WHERE SA.DEPT_ID IS NOT NULL",
    "                     GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM",
    "            ON MS.DIVISION_ID = IM.DIVISION_ID",
    "            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID",
]

# (주석처리 시작 body line, 끝 body line, 시작 라인에 있어야 하는 토큰)
BLOCKS = [(2753, 2755, "INNER JOIN SCM_MST_SITE_ITEM IM"),
          (2832, 2834, "INNER JOIN SCM_MST_SITE_ITEM IM")]

src = (S / "00_BACKUP_ASIS" / "01_PKG_DMF0020.ASIS.sql").read_text(encoding="utf-8")
lines = src.split("\n")          # lines[0] = "CREATE OR REPLACE " -> body line N == lines[N]

for a, b, tok in sorted(BLOCKS, key=lambda x: -x[0]):
    assert tok in lines[a], f"body:{a} expected [{tok}] got [{lines[a].strip()[:90]}]"
    for i in range(a, b + 1):
        ind = re.match(r"\s*", lines[i]).group(0)
        lines[i] = ind + M + lines[i][len(ind):]
    lines[b + 1:b + 1] = NEW

out = S / "01_APPLY" / "01_PKG_DMF0020.sql"
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text("\n".join(lines), encoding="utf-8")
print(f"PKG_DMF0020: {len(BLOCKS)} blocks -> {out} ({len(lines)} lines, +{len(lines) - len(src.split(chr(10)))})")
