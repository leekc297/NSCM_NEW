#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP div81 패치 생성기
4개 statement 를 IF p_division_id LIKE '81%' 분기 (81 클론 = 원본 주석 SCM_MST_FUTURE_PRICE 복원):
  B1: GTT_OVER_RANGE INSERT (CFM 4개소) — CELL_PROD select→'-', PARTITION/GROUP BY·내부 조인에서 제거
  B2: GTT_PLAN_DATA INSERT (1개소)
  B3: over_range='Y' GTT_MST_FUTURE_PRICE_SAVE_PRICE INSERT (1개소) — A↔B CELL_PROD 조인 제거
  B4: ELSE 분기 INSERT (1개소) — 동일
각 변환은 기대 치환 횟수 assert."""
import io, sys, re, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
AC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
SRC = AC / "DMF0082_POPUP_SAVEPRICE_BACKUP_pre_div81_20260714.sql"
DST = AC / "DMF0082_POPUP_SAVEPRICE_div81_20260714.sql"

text = SRC.read_text(encoding="utf-8")
lines = text.split("\n")  # 0-based; 파일 라인 = idx+1 (backup 은 라이브와 동일 라인)


def cut(a, b):
    """1-based [a, b] 구간"""
    return "\n".join(lines[a - 1:b])


def sub_n(block, pat, rep, n, label, flags=0):
    new, cnt = re.subn(pat, rep, block, flags=flags)
    if cnt != n:
        sys.exit(f"FAIL [{label}] 치환 {cnt}회 (기대 {n})")
    return new


def swap_tbl(block, n, label):
    return sub_n(block, r"FROM DM_PLN_CFM_SELLING_PRICE A",
                 "FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/", n, label + ":swap")


blocks = {}

# ---- B1: GTT_OVER_RANGE INSERT (L71~233) ----
b = cut(71, 233)
b = swap_tbl(b, 4, "B1")  # L116,138,172,188
b = sub_n(b, r"^(\s*)CELL_PROD_SITE_ID,$", r"\g<1>'-' AS CELL_PROD_SITE_ID, --[DIV81] 컬럼 부재",
          3, "B1:cp-select", flags=re.M)  # L113,135,185
b = sub_n(b, r"^(\s*)A\.CELL_PROD_SITE_ID$", r"\g<1>'-' AS CELL_PROD_SITE_ID --[DIV81]",
          1, "B1:cp-select-A", flags=re.M)  # L170
b = sub_n(b, r", INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD\)",
          ", INCOTERMS ORDER BY YYYYMMDD)", 2, "B1:partition")  # L114,136
b = sub_n(b, r"GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID",
          "GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS",
          1, "B1:groupby")  # L192
b = sub_n(b, r"\n\s*AND A\.CELL_PROD_SITE_ID = B\.CELL_PROD_SITE_ID", "", 1, "B1:join-AB")  # L204
# AA/BB/CC 레벨 CELL_PROD 조인 (L153/217)은 '-'='-' 상수 조인으로 유지 (컴파일 안전)
blocks["B1"] = (71, 233, b)

# ---- B2: GTT_PLAN_DATA INSERT (L291~ 종결 ';') ----
e2 = 291
while not lines[e2 - 1].split("--", 1)[0].rstrip().endswith(";"):
    e2 += 1
b = cut(291, e2)
# SELECT 항목 (L313 — 직후 FROM 라인이 앵커)
b = sub_n(b, r"A\.DOM_EXP,\n(\s*)A\.CELL_PROD_SITE_ID\n(\s*)FROM DM_PLN_CFM_SELLING_PRICE A",
          r"A.DOM_EXP,\n\g<1>'-' AS CELL_PROD_SITE_ID --[DIV81] 컬럼 부재\n\g<2>FROM DM_PLN_CFM_SELLING_PRICE A",
          1, "B2:cp-select")
# GROUP BY 항목 (L361 — 직후 ';' 가 앵커, 선행 콤마 함께 제거)
b = sub_n(b, r"A\.DOM_EXP,\n(\s*)A\.CELL_PROD_SITE_ID\n(\s*);",
          r"A.DOM_EXP --[DIV81] CELL_PROD 그룹 제거\n\g<2>;", 1, "B2:cp-groupby")
b = swap_tbl(b, 1, "B2")  # L314
blocks["B2"] = (291, e2, b)

# ---- B3: over_range='Y' INSERT (L626~701) ----
b = cut(626, 701)
b = sub_n(b, r"INNER JOIN DM_PLN_CFM_SELLING_PRICE B",
          "INNER JOIN SCM_MST_FUTURE_PRICE B /*[DIV81]*/", 1, "B3:swap")
b = sub_n(b, r"\n\s*AND A\.CELL_PROD_SITE_ID = B\.CELL_PROD_SITE_ID", "", 1, "B3:join-AB")  # L668
blocks["B3"] = (626, 701, b)

# ---- B4: ELSE INSERT (L703~765) ----
b = cut(703, 765)
b = sub_n(b, r"INNER JOIN DM_PLN_CFM_SELLING_PRICE B",
          "INNER JOIN SCM_MST_FUTURE_PRICE B /*[DIV81]*/", 1, "B4:swap")
b = sub_n(b, r"\n\s*AND A\.CELL_PROD_SITE_ID = B\.CELL_PROD_SITE_ID", "", 1, "B4:join-AB")  # L746
blocks["B4"] = (703, 765, b)

# ---- 잔존 검증: 81 클론에 CFM 테이블 참조 0 ----
for k, (_, _, b) in blocks.items():
    if "DM_PLN_CFM_SELLING_PRICE" in b:
        sys.exit(f"FAIL [{k}] CFM 참조 잔존")

# ---- 래핑 (역순) ----
for k in ["B4", "B3", "B2", "B1"]:
    a, e, clone = blocks[k]
    indent = re.match(r"\s*", lines[a - 1]).group(0)
    orig = cut(a, e)
    wrapped = (f"{indent}IF p_division_id LIKE '81%' THEN  --[DIV81] {k}: 81 테이블 분기 (하단 ELSE=40 원문 무수정)\n"
               f"{clone}\n{indent}ELSE\n{orig}\n{indent}END IF;  --[DIV81] {k}")
    lines[a - 1:e] = wrapped.split("\n")
    print(f"OK  [{k}] L{a}~{e} 분기")

out = "\n".join(lines)
hdr = 'CREATE OR REPLACE PROCEDURE           "DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP" '
assert out.count(hdr) == 1
out = out.replace(hdr, hdr + "\n/* [DIV81] 2026-07-14 admin: Division 81(LIKE '81%') 시 SCM_MST_FUTURE_PRICE 로 분기"
                            " (원본 MSSQL 테이블 복원 — 소스 내 주석 물증). CELL_PROD_SITE_ID 는 '-' 리터럴/조인 제거"
                            " (컬럼 부재). 40 원문 무수정. */")
DST.write_text(out, encoding="utf-8")
print(f"-> {DST.name} 생성")
