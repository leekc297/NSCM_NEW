"""Build patched SP body v3 — Phase 1 + 2 + 3 일괄:
   - Phase 1: INSERT GT_GGET_SITE_ITEM_ALL DIV=81/82 분기 (line 959~1057 → patched)
   - Phase 2: INSERT GT_GGET_SITE_ITEM_ALL DIV=40 분기 (line 1061~1182 → patched)
   - Phase 3: GT_GGET_SPLIT_* 사전 적재 INSERT 11개 (SP body line 265 뒤 — GT cleanup 직후 + 권한 LOOKUP 전)

Source: extracted_sp_body_v2.sql (사내 현 상태, 'Mkt Fcst'→'main' 9 patch 적용 후)
Output: 028_sp_body_patched_v3.sql (CREATE OR REPLACE + '/')
"""
import pathlib, re, sys

BASE = pathlib.Path(__file__).parent
SRC = BASE / "extracted_sp_body_v2.sql"
PHASE1 = BASE / "phase1_insert_site_item_all_div81.sql"
PHASE2 = BASE / "phase2_insert_site_item_all_div40.sql"
PHASE3 = BASE / "phase3_gt_split_insert_block.sql"
DST = BASE / "028_sp_body_patched_v3.sql"

PREFIX_RE = re.compile(r"^\s*\d+\|\s?")

# Step 1: strip prefix
raw_lines = SRC.read_text(encoding="utf-8").splitlines()
clean_lines = [PREFIX_RE.sub("", l) for l in raw_lines]

# Step 2: Phase 1 영역 식별 (INSERT GT_GGET_SITE_ITEM_ALL 첫 발견 ~ ELSE 직전 ;)
PHASE1_START = None
PHASE1_END   = None
for i, l in enumerate(clean_lines):
    if PHASE1_START is None and "INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL" in l:
        PHASE1_START = i
    elif PHASE1_START is not None and l.strip() == "ELSE":
        for j in range(i - 1, PHASE1_START, -1):
            if clean_lines[j].rstrip().endswith(";"):
                PHASE1_END = j
                break
        break

# Step 3: Phase 2 영역 식별 (ELSE 후 두 번째 INSERT GT_GGET_SITE_ITEM_ALL ~ END IF 직전)
PHASE2_START = None
PHASE2_END   = None
for i in range(PHASE1_END + 1, len(clean_lines)):
    if PHASE2_START is None and "INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL" in clean_lines[i]:
        PHASE2_START = i
    elif PHASE2_START is not None and clean_lines[i].strip() == "END IF;":
        for j in range(i - 1, PHASE2_START, -1):
            if clean_lines[j].rstrip().endswith(";"):
                PHASE2_END = j
                break
        break

# Step 4: Phase 3 삽입 위치 — DELETE GT cleanup 직후 (line ~265, before 권한 LOOKUP)
PHASE3_INSERT_AT = None
for i, l in enumerate(clean_lines):
    if "DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT" in l:
        # 이 DELETE 가 마지막 cleanup. 그 다음 line 에 Phase 3 삽입.
        PHASE3_INSERT_AT = i + 1
        break

# 검증
assert PHASE1_START and PHASE1_END, f"Phase 1 영역 식별 실패: {PHASE1_START} ~ {PHASE1_END}"
assert PHASE2_START and PHASE2_END, f"Phase 2 영역 식별 실패: {PHASE2_START} ~ {PHASE2_END}"
assert PHASE3_INSERT_AT, "Phase 3 삽입 위치 식별 실패"

print(f"[OK] Phase 1 range: list-idx {PHASE1_START} ~ {PHASE1_END} ({PHASE1_END - PHASE1_START + 1} lines)")
print(f"     start: {clean_lines[PHASE1_START].strip()[:80]}")
print(f"     end  : {clean_lines[PHASE1_END].strip()[:80]}")
print(f"[OK] Phase 2 range: list-idx {PHASE2_START} ~ {PHASE2_END} ({PHASE2_END - PHASE2_START + 1} lines)")
print(f"     start: {clean_lines[PHASE2_START].strip()[:80]}")
print(f"     end  : {clean_lines[PHASE2_END].strip()[:80]}")
print(f"[OK] Phase 3 insert at: list-idx {PHASE3_INSERT_AT}")
print(f"     prev: {clean_lines[PHASE3_INSERT_AT - 1].strip()[:80]}")

# Step 5: Load new blocks
phase1_new = PHASE1.read_text(encoding="utf-8").splitlines()
phase2_new = PHASE2.read_text(encoding="utf-8").splitlines()
phase3_new = PHASE3.read_text(encoding="utf-8").splitlines()

# Step 6: Reassemble (역순 — 뒤부터 자르고 삽입)
result = []
# part A: 0 ~ PHASE3_INSERT_AT
result.extend(clean_lines[: PHASE3_INSERT_AT])
result.extend(phase3_new)
# part B: PHASE3_INSERT_AT ~ PHASE1_START
result.extend(clean_lines[PHASE3_INSERT_AT : PHASE1_START])
result.extend(phase1_new)
# part C: PHASE1_END+1 ~ PHASE2_START
result.extend(clean_lines[PHASE1_END + 1 : PHASE2_START])
result.extend(phase2_new)
# part D: PHASE2_END+1 ~ end
result.extend(clean_lines[PHASE2_END + 1 :])

# Step 7: CREATE OR REPLACE prefix + '/' suffix
final = []
final.append("CREATE OR REPLACE " + result[0])
final.extend(result[1:])
final.append("/")

DST.write_text("\n".join(final), encoding="utf-8")
print(f"\n[OK] built: {DST} ({len(final):,} lines)")
print(f"   Phase 1 replaced: {PHASE1_END - PHASE1_START + 1} → {len(phase1_new)} lines")
print(f"   Phase 2 replaced: {PHASE2_END - PHASE2_START + 1} → {len(phase2_new)} lines")
print(f"   Phase 3 inserted: 0 → {len(phase3_new)} lines (at idx {PHASE3_INSERT_AT})")
