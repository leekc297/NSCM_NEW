"""Build patched SP body v2:
   - Base: extracted_sp_body.sql (사내 raw, prefix `NNN| ` 포함)
   - Patch 1: 'Mkt Fcst' → 'main' (9 occurrences — 기존 patch 유지)
   - Patch 2: line 959~1057 (INSERT INTO GT_GGET_SITE_ITEM_ALL, DIV='81/82' 분기) replace
   - Output: 025_sp_body_patched_v2.sql (CREATE OR REPLACE + '/')
"""
import pathlib, re, sys

SRC = pathlib.Path(__file__).parent.parent / "_dmf0003_dynamic_property" / "extracted_sp_body.sql"
NEW_INSERT = pathlib.Path(__file__).parent / "025_patched_insert_block.sql"
DST = pathlib.Path(__file__).parent / "025_sp_body_patched_v2.sql"

PREFIX_RE = re.compile(r"^\s*\d+\|\s?")

# Step 1: extracted_sp_body.sql 의 line별 prefix 제거
raw_lines = SRC.read_text(encoding="utf-8").splitlines()
clean_lines = [PREFIX_RE.sub("", l) for l in raw_lines]

# Step 2: search-based line range 식별 (prefix off-by-one 회피)
#   start: 첫 INSERT INTO GT_GGET_SITE_ITEM_ALL (DIV='81/82' 분기 안)
#   end  : 그 INSERT 의 마지막 ;  (ELSE 직전)

PATCH_START_IDX = None
PATCH_END_IDX   = None
for i, l in enumerate(clean_lines):
    if PATCH_START_IDX is None and "INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL" in l:
        PATCH_START_IDX = i
    elif PATCH_START_IDX is not None and PATCH_END_IDX is None:
        if l.strip() == "ELSE":
            # ELSE 의 직전 ; 종료 라인을 backward search
            for j in range(i - 1, PATCH_START_IDX, -1):
                if clean_lines[j].rstrip().endswith(";"):
                    PATCH_END_IDX = j
                    break
            break

if PATCH_START_IDX is None or PATCH_END_IDX is None:
    sys.exit("FAIL: PATCH 영역 식별 실패")

print(f"[OK] Patch range: list-idx {PATCH_START_IDX} ~ {PATCH_END_IDX} (length {PATCH_END_IDX - PATCH_START_IDX + 1})")
print(f"   start: {clean_lines[PATCH_START_IDX].strip()[:80]}")
print(f"   end  : {clean_lines[PATCH_END_IDX].strip()[:80]}")

# Step 3: 'Mkt Fcst' → 'main' patch (9 occurrences 기존 유지)
mkt_patched = 0
for i, l in enumerate(clean_lines):
    if "'Mkt Fcst'" in l:
        clean_lines[i] = l.replace("'Mkt Fcst'", "'main'")
        mkt_patched += 1
print(f"[OK] 'Mkt Fcst' → 'main' patches: {mkt_patched}")

# Step 4: line 959~1057 replace
new_insert_block = NEW_INSERT.read_text(encoding="utf-8").splitlines()
print(f"[OK] New INSERT block: {len(new_insert_block)} lines")

before_block = clean_lines[: PATCH_START_IDX]
after_block  = clean_lines[PATCH_END_IDX + 1 :]

# Final output
result = []
result.append("CREATE OR REPLACE " + before_block[0])     # PROCEDURE 키워드 prefix
result.extend(before_block[1:])
result.extend(new_insert_block)
result.extend(after_block)
result.append("/")

DST.write_text("\n".join(result), encoding="utf-8")
print(f"[OK] built: {DST} ({len(result):,} lines)")
print(f"   before block: {len(before_block):,}")
print(f"   new insert  : {len(new_insert_block):,}")
print(f"   after block : {len(after_block):,}")
