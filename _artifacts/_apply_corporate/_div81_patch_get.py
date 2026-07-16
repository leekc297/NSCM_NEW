#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 body + GET_MAIN_DATA_CURRENT div81 패치 생성기
40 스테이징 INSERT 원문에서 81 클론을 기계 파생:
  - 테이블 스왑 (DM_PLN_CFM_* → 81 테이블)
  - SELECT 항목 A.END_CUSTOMER / A.CELL_PROD_SITE_ID → '-' 리터럴 (81 컬럼 부재)
  - IF p_division_id LIKE '81%' THEN <81클론> ELSE <40원문> END IF; 래핑
파생 후 81 클론에 A.END_CUSTOMER / A.CELL_PROD_SITE_ID 잔존 시 즉시 실패."""
import io, sys, re, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
AC = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")

TBL = [  # 순서 중요: _C 먼저
    ("DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_MKT_FCST_C"),
    ("DM_PLN_CFM_MKT_DEMAND_PLAN",   "DM_PLN_MKT_FCST"),
    ("DM_PLN_CFM_SELLING_PRICE_C",   "SCM_MST_FUTURE_PRICE_C"),
    ("DM_PLN_CFM_SELLING_PRICE",     "SCM_MST_FUTURE_PRICE"),
]
# END_CUSTOMER 81 규약 = PROJECT_CODE alias (실측 2026-07-14: 실적 arm/파생 measure arm 이 PROJECT_CODE AS END_CUSTOMER
#  이고 pivot GROUP BY 키에 END_CUSTOMER 포함 — '-' 리터럴이면 measure 간 행 분열. AS-IS popup 규약과도 동일)
# CELL_PROD_SITE_ID 81 규약 = '-' (컬럼 부재 placeholder, 81 실적 데이터도 '-' 지배적 실측)
COL = [
    # AS-alias 형: "A.END_CUSTOMER AS END_CUSTOMER"
    (re.compile(r"A\.END_CUSTOMER\s+AS\s+END_CUSTOMER"),
     r"A.PROJECT_CODE AS END_CUSTOMER /*[DIV81]*/"),
    (re.compile(r"A\.CELL_PROD_SITE_ID\s+AS\s+CELL_PROD_SITE_ID"),
     r"'-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/"),
    # SELECT 항목 EOL 형: ", A.END_CUSTOMER" (뒤 주석 허용)
    (re.compile(r"([,(]\s*)A\.END_CUSTOMER(\s*(?:--.*)?)$"),
     r"\g<1>A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE\g<2>"),
    (re.compile(r"([,(]\s*)A\.CELL_PROD_SITE_ID(\s*(?:--.*)?)$"),
     r"\g<1>'-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재\g<2>"),
    # SELECT 항목 미드라인 형: ", A.END_CUSTOMER," — 조인/비교 형('= A.xxx')은 미매칭 → 하단 assert 가 차단
    (re.compile(r"(,\s*)A\.END_CUSTOMER(\s*,)"), r"\g<1>A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/\g<2>"),
    (re.compile(r"(,\s*)A\.CELL_PROD_SITE_ID(\s*,)"), r"\g<1>'-' /*[DIV81]*/\g<2>"),
]

def derive_81(block_lines, label):
    out = []
    for ln in block_lines:
        for old, new in TBL:
            ln = ln.replace(f"SCM_MGR.{old}", f"SCM_MGR.{new}")
        for pat, rep in COL:
            ln = pat.sub(rep, ln)
        out.append(ln)
    joined = "\n".join(out)
    bad = [l for l in out if re.search(r"\bA\.END_CUSTOMER\b|\bA\.CELL_PROD_SITE_ID\b", l)]
    if bad:
        sys.exit(f"FAIL [{label}] 81 클론에 잔존 참조:\n" + "\n".join(bad))
    if not any(any(n in l for _, n in TBL) for l in out):
        sys.exit(f"FAIL [{label}] 81 테이블 스왑 미발생")
    return joined

def patch_file(src_path, dst_path, from_lines, header_old, header_new):
    """from_lines: 1-based 'FROM SCM_MGR.<40테이블>' 라인 번호 목록 (본문 파일 기준)"""
    text = src_path.read_text(encoding="utf-8")
    assert text.count(header_old) == 1, f"header anchor != 1 in {src_path.name}"
    lines = text.split("\n")

    blocks = []  # (start_idx, end_idx) 0-based inclusive
    for fl in from_lines:
        i = fl - 1
        assert "FROM" in lines[i] and "SCM_MGR.DM_PLN_CFM" in lines[i], f"L{fl} anchor mismatch: {lines[i]!r}"
        s = i
        while s >= 0 and not re.match(r"\s*INSERT INTO SCM_MGR\.GTT?_", lines[s]):
            s -= 1
        assert s >= 0, f"L{fl}: INSERT INTO 미발견"
        e = i
        while e < len(lines) and not lines[e].split("--", 1)[0].rstrip().endswith(";"):
            e += 1
        assert e < len(lines), f"L{fl}: 종결 ';' 미발견"
        if any(b[0] == s and b[1] == e for b in blocks):
            print(f'SKIP [L{fl}] 동일 블록 (UNION 내 복수 FROM)')
            continue
        blocks.append((s, e, fl))

    # 겹침 검증 + 역순 적용
    blocks.sort()
    for a, b in zip(blocks, blocks[1:]):
        assert a[1] < b[0], f"블록 겹침: {a} vs {b}"

    for s, e, fl in reversed(blocks):
        orig = lines[s:e + 1]
        indent = re.match(r"\s*", orig[0]).group(0)
        clone = derive_81(orig, f"L{fl}")
        wrapped = (
            f"{indent}IF p_division_id LIKE '81%' THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)\n"
            + clone + "\n"
            + f"{indent}ELSE\n"
            + "\n".join(orig) + "\n"
            + f"{indent}END IF;  --[DIV81]"
        )
        lines[s:e + 1] = wrapped.split("\n")
        print(f"OK  [{src_path.name} L{fl}] {e - s + 1}줄 블록 분기")

    text = "\n".join(lines).replace(header_old, header_new)
    dst_path.write_text(text, encoding="utf-8")
    print(f"-> {dst_path.name} 생성\n")

HDR_NOTE = ("[DIV81] 2026-07-14 admin: Division 81(LIKE '81%') 시 GTT 스테이징 INSERT 만 81 테이블"
            "(DM_PLN_MKT_FCST(_C)/SCM_MST_FUTURE_PRICE(_C))로 분기. END_CUSTOMER/CELL_PROD_SITE_ID 는 '-' 리터럴"
            " (컬럼 부재 — ALL_TAB_COLUMNS 실측). 하류(pivot/커서) 공통. 40 원문 무수정.")

# 1) PKG body — backup 은 라이브와 동일 라인 (CREATE OR REPLACE 는 1행에 병합됨, grep 실측 2026-07-14)
pkg_src = AC / "PKG_DMF0082_body_BACKUP_pre_div81_20260714.sql"
pkg_dst = AC / "PKG_DMF0082_body_div81_20260714.sql"
patch_file(pkg_src, pkg_dst,
           [1391, 1408, 1435, 1454, 1554, 1661, 1884, 1951, 2138, 2259, 2326],
           'CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0082" ',
           'CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0082" \n/* ' + HDR_NOTE + ' */')

# 2) GET_MAIN_DATA_CURRENT — FROM 라인 grep 실측 (787,813,912,998,1076)
cur_src = AC / "DMF0082_GET_MAIN_DATA_CURRENT_BACKUP_pre_div81_20260714.sql"
cur_dst = AC / "DMF0082_GET_MAIN_DATA_CURRENT_div81_20260714.sql"
patch_file(cur_src, cur_dst, [787, 813, 912, 998, 1076],
           "CREATE OR REPLACE PROCEDURE         DMF0082_GET_MAIN_DATA_CURRENT",
           "CREATE OR REPLACE PROCEDURE         DMF0082_GET_MAIN_DATA_CURRENT\n/* " + HDR_NOTE + " */")
