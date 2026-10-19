# -*- coding: utf-8 -*-
"""
가드 대칭화 효과 실증 — 메타 DEFAULT_FLAG 가 다시 '-' 로 돌아간 상황을 **모의**해
ORDER BY 에 SORT_ORDER_NO 가 살아남는지 확인한다. (DB 는 변경하지 않는다 — 조회만)

시나리오
  A 현행 메타(DEFAULT='Y')                 : 목록에 MEASURE 포함 → 가드 미발동
  B 회귀 모의(DEFAULT='-' 로 가정)          : 목록에서 MEASURE 탈락 → **가드가 보강** → 순서 유지
"""
import sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

PROG = "DMF0035"
CASES = [("SALES (PKG_DMF0022)", "Sales Plan Waterfall", "SORT_ORDER_NO,MEASURE"),
         ("BIZ   (PKG_DMF0051)", "Biz Plan Waterfall", "SORT_ORDER_NO,MEASURE"),
         ("MKT   (PKG_DMF0035)", "Mkt Fcst Waterfall", "SORT_ORDER_NO")]

# 개인화 없음 분기 — :force_drop='Y' 면 MEASURE 를 강제 탈락(회귀 모의)
SQL = """
SELECT C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = :p AND C.SHEET_NAME = :s
   AND (C.DEFAULT_FLAG='Y'
        OR (C.VISIBLE_FLAG='N' AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y'))
   AND NOT (:force_drop = 'Y' AND C.COLUMN_NAME = 'MEASURE')
 ORDER BY C.SORT_ORDER_NO
"""


def build(rows, repl, guarded):
    order = ",".join(f" {c} {m or ''}".rstrip() for c, m in rows)
    cols = ",".join(c for c, _ in rows)
    # MEASURECOL 가드 (대칭화 적용본)
    if "MEASURE" not in cols.split(","):
        cols += ",MEASURE"
        if guarded:
            order = "MEASURE ASC" if not order.strip() else order + ",MEASURE ASC"
    # REPLACE 규약
    order = re.sub(r"VERSION_NO", "VERSION_SORT DESC,VERSION_NO", order)
    order = re.sub(r"MEASURE", repl, order)
    return order


sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
with oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)) as db:
    cur = db.cursor()
    for label, sheet, repl in CASES:
        print(f"\n===== {label} — '{sheet}' =====")
        for tag, drop in (("A 현행 메타(DEFAULT='Y')", "N"), ("B 회귀 모의(MEASURE 탈락)", "Y")):
            cur.execute(SQL, p=PROG, s=sheet, force_drop=drop)
            rows = cur.fetchall()
            before = build(rows, repl, guarded=False)   # 대칭화 적용 전
            after = build(rows, repl, guarded=True)     # 대칭화 적용 후(현재 DB)
            ok_b = "SORT_ORDER_NO" in before
            ok_a = "SORT_ORDER_NO" in after
            print(f"  {tag:26s} 컬럼 {len(rows):2d}개 | 적용전 {'O' if ok_b else 'X'}"
                  f" → 적용후 {'O' if ok_a else 'X'}")
            if drop == "Y":
                print(f"      ORDER BY 말미: ...{after[-60:]}")
