# -*- coding: utf-8 -*-
"""[E20260819-MULTIJOIN] PKG_DMF0082 GET 2본 멀티 조회조건 인라인 분해 → GTT 선적재+IF게이트+NOT EXISTS 전환기.
   입력: PKG_DMF0082_BODY_PRE_MULTIJOIN_20260819.sql (신선 덤프) → 출력: PKG_DMF0082_BODY_MULTIJOIN_20260819.sql"""
import re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

src = open('PKG_DMF0082_BODY_PRE_MULTIJOIN_20260819.sql', encoding='utf-8').read()
rep = {}

M = "[E20260819-MULTIJOIN]"

def gated_delete(param, table, col):
    return (f"    IF {param} IS NOT NULL AND {param} <> 'ALL' THEN\n"
            f"        DELETE FROM SCM_MGR.{table} F\n"
            f"        WHERE  NOT EXISTS (\n"
            f"                   SELECT 1\n"
            f"                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T\n"
            f"                   WHERE  T.PARAM_NM = '{param}'\n"
            f"                   AND    T.TOKEN    = F.{col});\n"
            f"    END IF;\n")

def item_delete(table):
    return (f"    /* {M} Item 필터 — 구 인라인 REGEXP 분해 '%토큰%' LIKE INNER JOIN 을 GTT 선적재+NOT EXISTS(LIKE) 로 전환.\n"
            f"       'ALL' 개념 없음(텍스트 검색) — NULL/'' 이면 미적용(구 코드의 NULL토큰='%%' 전건통과와 동일 의미).\n"
            f"       ITEM_ID/NICK_NAME 스테이징 1:1 실측 — LIKE OR 술어 원형 보존. */\n"
            f"    IF p_item_id IS NOT NULL THEN\n"
            f"        DELETE FROM SCM_MGR.{table} F\n"
            f"        WHERE  NOT EXISTS (\n"
            f"                   SELECT 1\n"
            f"                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T\n"
            f"                   WHERE  T.PARAM_NM = 'p_item_id'\n"
            f"                   AND    (F.ITEM_ID   LIKE '%' || T.TOKEN || '%'\n"
            f"                        OR F.NICK_NAME LIKE '%' || T.TOKEN || '%'));\n"
            f"    END IF;\n")

lines = src.split('\n')

# ---------- 1) 인라인 OR-분기 술어 제거 (paren-balance line consumer) ----------
pred_pat = re.compile(r"^\s*AND\s*\(\s*(p_scm_site_id|p_customer|p_biz_type|p_team_id)\s*=\s*'ALL'\s*OR\b")
out = []; removed = []
i = 0
while i < len(lines):
    m = pred_pat.match(lines[i])
    if m:
        depth = 0; j = i; started = False; trail = False
        while j < len(lines):
            for ch in lines[j]:
                if ch == '(': depth += 1; started = True
                elif ch == ')': depth -= 1
            if started and depth <= 0:
                if lines[j].rstrip().endswith(';'): trail = True
                break
            j += 1
        removed.append((m.group(1), i+1, j+1))
        if trail:
            for k in range(len(out)-1, -1, -1):
                if out[k].strip():
                    out[k] = out[k].rstrip() + ';'
                    break
        i = j + 1
        continue
    out.append(lines[i]); i += 1

from collections import Counter
rc = Counter(p for p, _, _ in removed)
rep['pred_removed'] = dict(rc)
assert rc['p_scm_site_id'] == 30 and rc['p_customer'] == 2 and rc['p_biz_type'] == 2 and rc['p_team_id'] == 1, rc

# ---------- 2) item LIKE-join 제거 (3지점) ----------
res = []; k = 0; item_removed = 0
join_like = re.compile(r"^\s*(ON|OR)\b.*LIKE B\.TST")
tst_mark = "SELECT DISTINCT '%' || TOKEN || '%' AS TST"
while k < len(out):
    l = out[k]
    if 'INNER JOIN (' in l and (tst_mark in l or any(tst_mark in out[x] for x in range(k+1, min(k+4, len(out))))):
        depth = 0; j = k; started = False
        while j < len(out):
            for ch in out[j]:
                if ch == '(': depth += 1; started = True
                elif ch == ')': depth -= 1
            if started and depth <= 0:
                break
            j += 1
        # j = ') B' 줄. 이어지는 ON/OR ... LIKE B.TST 줄(사이 공백줄 포함) 소비
        j += 1
        while j < len(out):
            if not out[j].strip():
                nxt = next((x for x in range(j+1, len(out)) if out[x].strip()), None)
                if nxt is None or not join_like.match(out[nxt]):
                    break
                j += 1
                continue
            if join_like.match(out[j]):
                j += 1
                continue
            break
        item_removed += 1
        k = j
        continue
    res.append(l); k += 1
out = res
rep['item_join_removed'] = item_removed
assert item_removed == 3, item_removed

body = '\n'.join(out)

# ---------- 3) GTT 선적재 추가 ----------
# MAIN 의 scm_site 선적재는 DS2 주석이 바로 뒤따르는 유일 지점 (popup L9213 은 다음 INSERT 가 뒤따름 — 실측 구분)
main_anchor_re = re.compile(
    r"(    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE\(UF_FX_String_SplitForIN\(p_scm_site_id, ','\)\);)(\s*\n\s*--\[2026-07-31 클라우드 대응\])")
assert len(main_anchor_re.findall(body)) == 1
main_add_body = ("\n"
    f"    /* {M} 인라인 REGEXP 분해 전환분 선적재 — p_customer/p_biz_type/p_item_id/p_version_type (2026-08-19 사용자 확장 지시) */\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_customer, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_biz_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biz_type, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_item_id, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_version_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));")
body, n = main_anchor_re.subn(lambda mm: mm.group(1) + main_add_body + mm.group(2), body); assert n == 1, n

cur_anchor_re = re.compile(
    r"(    SELECT 'p_sender_code', COLUMN_VALUE FROM TABLE\(UF_FX_String_SplitForIN\(p_sender_code, ','\)\);)(\s*\n\s*--\[2026-07-31 클라우드 대응\])")
cur_add = (r"\1" + "\n"
    f"    /* {M} 인라인 REGEXP 분해 전환분 선적재 — p_scm_site_id/p_team_id/p_customer/p_biz_type/p_item_id (2026-08-19 사용자 확장 지시) */\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_team_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_team_id, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_customer, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_biz_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biz_type, ','));\n"
    "    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)\n"
    "    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_item_id, ','));"
    + r"\2")
body, n = cur_anchor_re.subn(cur_add, body); assert n == 1, n

# ---------- 4) version 블록 소스 스왑 ----------
ver_re = re.compile(
    r"FROM   \(SELECT REGEXP_SUBSTR\(p_version_type, '\[\^,\]\+', 1, LEVEL\) AS TOKEN\s*\n"
    r"\s*FROM   DUAL\s*\n"
    r"\s*CONNECT BY LEVEL <= REGEXP_COUNT\(p_version_type, ','\) \+ 1\) A")
ver_new = (f"FROM   (SELECT TOKEN                             /* {M} 인라인 REGEXP 분해 → GTT 선적재 소비\n"
           "                   (IF LIKE 게이트 기존 유지 — 'ALL' 개념 없는 버전 유니버스 해석 지점) */\n"
           "                FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN\n"
           "                WHERE  PARAM_NM = 'p_version_type') A")
body, n = ver_re.subn(ver_new, body); assert n == 1, n

# ---------- 5) MAIN 아이템 유니버스 post-DELETE ----------
mst_anchor = "    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료"
idx = body.find(mst_anchor); assert idx > 0
body = body[:idx] + item_delete("GT_DMF0082_MST_ITEM_SINGLE_V") + body[idx:]

# ---------- 6) SITE_ITEM_ALL post-DELETE 클러스터 (MAIN / CURRENT) ----------
def cluster(table):
    note = (f"    /* {M} 조회조건 SCM Site / Customer / Biz Type — 구 인라인 OR분기(REGEXP 분해)를 GTT 선적재+IF게이트+NOT EXISTS 로 전환.\n"
            f"       Biz Type 술어식(CASE WHEN F.ITEM_ID=LOOKA.MODEL...)은 FORECAST_INFO_BIZ_TYPE 컬럼으로 1:1 스테이징(실측) — 동일 값 필터.\n"
            f"       전 컬럼 ALL_TAB_COLUMNS 실측 NULLABLE='Y' → 양변 원문 비교(구 bare-IN 의미론 보존 — 무값 행은 값 지정 시 제외). */\n")
    return (note
            + gated_delete('p_scm_site_id', table, 'SCM_SITE_ID')
            + gated_delete('p_customer',    table, 'PROJECT_CODE')
            + gated_delete('p_biz_type',    table, 'FORECAST_INFO_BIZ_TYPE')
            + item_delete(table))

sia_anchor = "    -- #TempSiteItemAll 만들기 종료"
idx = body.find(sia_anchor); assert idx > 0
body = body[:idx] + cluster("GT_DMF0082_TEMP_SITE_ITEM_ALL") + body[idx:]

# CURRENT 는 '-- #TempSiteItemAll 만들기 (END)' 박스 주석 (MAIN 은 '만들기 종료' — 실측 구분)
cur_sia_anchor = "    -- #TempSiteItemAll 만들기 (END)"
idx = body.find(cur_sia_anchor); assert idx > 0, "CURRENT SITEITEMALL end not found"
# 박스 주석 상단 구분선까지 포함해 그 앞에 삽입
box_start = body.rfind("    ----", 0, idx)
ins_at = box_start if box_start > idx - 200 and box_start > 0 else idx
body = body[:ins_at] + cluster("GTT_TEMPSITEITEMALL") + body[ins_at:]

# ---------- 7) 스테이징 GTT 통합 scm_site DELETE (PLANT_SITE 클러스터 앞) ----------
for table in ("GT_DMF0082_TEMP_FCST_N_PRICE", "GTT_TEMPFCSTNPRICE"):
    pat = re.compile(r"(IF p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL' THEN\s*\n\s*DELETE FROM SCM_MGR\." + table + r")")
    note = (f"    /* {M} 조회조건 SCM Site — 구 스테이징 INSERT 별 인라인 OR분기(REGEXP 분해 {'20지점' if table.startswith('GT_') else '10지점(MERGE 포함)'})를\n"
            f"       PLANT_SITE 동형의 스테이징 후 단일 지점 GTT+NOT EXISTS 로 통합(그레인에 SCM_SITE_ID 포함 — 파생 메저 GROUP BY 실측, 최종 내용 동일). */\n")
    ins = note + gated_delete('p_scm_site_id', table, 'SCM_SITE_ID') + "\n    "
    body, n = pat.subn(lambda mm: ins + mm.group(1), body, count=1); assert n == 1, (table, n)

# ---------- 8) CURRENT GTT_MF_SP team DELETE ----------
mf_anchor_re = re.compile(r"(\n[ \t]*/\* \[E20260819-SENDERJOIN\] Sender Code 필터 = 실적용[\s\S]{0,500}?GTT_MF_SP)")
m = mf_anchor_re.search(body); assert m, "GTT_MF_SP sender block not found"
team_blk = ("\n"
    f"    /* {M} Team(deptId) 필터 — 구 인라인 (p_team_id='ALL' OR A.DEPT_ID IN REGEXP분해) 를 GTT 선적재+IF게이트+NOT EXISTS 로 전환\n"
    "       (스테이징 컬럼 TEAM_ID = A.DEPT_ID 1:1 실측 · NULLABLE='Y' → 양변 원문 비교 = 구 bare-IN 의미론 보존). */\n"
    + gated_delete('p_team_id', 'GTT_MF_SP', 'TEAM_ID'))
body = body[:m.start()] + team_blk + body[m.start():]

open('PKG_DMF0082_BODY_MULTIJOIN_20260819.sql', 'w', encoding='utf-8', newline='').write(body)
rep['marker_MULTIJOIN'] = body.count('E20260819-MULTIJOIN')
rep['marker_SENDERJOIN'] = body.count('E20260819-SENDERJOIN')
rep['marker_PJTNAME'] = body.count('E20260819-PJTNAME')
rep['regexp_p_left'] = len(re.findall(r"REGEXP_SUBSTR\(p_\w+", body))
print(rep)
