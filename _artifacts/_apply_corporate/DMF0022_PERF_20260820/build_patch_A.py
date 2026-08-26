# -*- coding: utf-8 -*-
"""Stage A — [E20260820-D22PREREDUCE] ④ 선행축소 2건 (라인 정밀 치환, 원본 바이트 보존).

P1 L1591  SCM_MST_ITEM_SN → GT_DM22_DM_MST_ITEM_SINGLE_ORI_V 적재를
          GT_DM22_RAW_DATA 의 ITEM 12자리 prefix 집합으로 선행축소
P2 L2690  GT_DM22_SCM_MST_SITE 적재(현재 division 필터 전무, 전 사업부 118,322행)를
          GT_DM22_RAW_DATA 의 (DIVISION_ID, SCM_SITE_ID) 로 선행축소
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
src = open(BASE + r"\00_BACKUP_PKG_DMF0022_BODY.sql", encoding="utf-8").read().splitlines()


def chk(ln, frag):
    assert frag in src[ln - 1], f"L{ln} 전제 불일치: {src[ln-1][:110]!r}"


# ── 전제 assert (대상 문자열 실재 확인 — 없으면 중단) ─────────────────────────
chk(1590, "FROM   SCM_MGR.SCM_MST_ITEM_SN")
chk(1591, "WHERE DIVISION_ID = p_division_id")
chk(1592, ";")
chk(1638, "FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T1")
chk(1666, "FROM  SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T2")
chk(1731, "JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM SCM_MGR.GT_DM22_RAW_DATA )")
chk(2686, "FROM SCM_MGR.SCM_MST_SITE A")
chk(2690, "WHERE 1=1")
chk(2691, "GROUP BY A.DIVISION_ID, A.SCM_SITE_ID")

P1 = """    WHERE DIVISION_ID = p_division_id
      --[E20260820-D22PREREDUCE] hook #129 ④ 선행축소 — 이 GTT 의 소비처는 아래 A_V(L1597)/B_V(L1646) 뿐이고
      --  최종 소비처 GT_DM22_DM_MST_ITEM_SINGLE_V(L1688) 는 GT_DM22_RAW_DATA 의 (DIVISION_ID,ITEM_ID) 로
      --  다시 INNER JOIN 된다. B_V 가 SUBSTR(ITEM_ID,1,12) 로 MAX 집계하므로 **prefix 단위**로 축소해야
      --  집계 그룹이 온전히 보존된다(정확 ITEM_ID 축소는 B_V 의 MAX 를 바꿔 금지).
      --  RAW_DATA 는 L1009/L1072 적재 후 L1688 까지 변경 DML 이 없다(사이 INSERT/DELETE/UPDATE 부재).
      --  실측(사내 2026-08-20): div40 243,050행 적재 → 최종 SINGLE_V 136행, TABLE ACCESS FULL SCM_ITEM_M.
      AND SUBSTR(ITEM_ID, 1, 12) IN (SELECT SUBSTR(R.ITEM_ID, 1, 12)
                                       FROM SCM_MGR.GT_DM22_RAW_DATA R
                                      WHERE R.DIVISION_ID = p_division_id)"""

P2 = """             WHERE 1=1
               --[E20260820-D22PREREDUCE] hook #129 ④ 선행축소 — 이 GTT 의 유일한 소비처(최종 동적 SQL L3516)는
               --  GT_DM22_RAW_DATA 와 (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID) 로 LEFT JOIN 하므로
               --  RAW_DATA 에 (DIVISION_ID, SCM_SITE_ID) 가 없는 행은 결과에 기여할 수 없다.
               --  L2681 이후의 RAW_DATA 적재문은 모두 RAW_DATA/TEMP40_KEY/RTF_ENERGY 파생이라 SITE 집합이 늘지 않는다.
               --  실측(사내 2026-08-20): 필터 전무로 조회 사업부와 무관하게 항상 118,322행 적재.
               AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_RAW_DATA R
                            WHERE R.DIVISION_ID = A.DIVISION_ID
                              AND R.SCM_SITE_ID = A.SCM_SITE_ID)"""

out = (src[:1590] + P1.splitlines() + src[1591:2689] + P2.splitlines() + src[2690:])
txt = "\n".join(out)

# 산출 자기검증
assert txt.count("E20260820-D22PREREDUCE") == 2, txt.count("E20260820-D22PREREDUCE")
assert txt.count("E20260820-DS2") == 1
assert txt.count("v_measure_sheet") == 6
assert "WHERE 1=1\n             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID" not in txt, "P2 미적용"
assert len(out) == len(src) + 17, f"라인 증가 {len(out)-len(src)}"
open(BASE + r"\01_PATCHED_A_PKG_DMF0022_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 01_PATCHED_A_PKG_DMF0022_BODY.sql — {len(out)} lines (원본 {len(src)})")
print("  markers: PREREDUCE", txt.count("E20260820-D22PREREDUCE"),
      "/ DS2", txt.count("E20260820-DS2"), "/ v_measure_sheet", txt.count("v_measure_sheet"))
