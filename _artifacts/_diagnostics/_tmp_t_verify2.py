#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_verify2.py — TUNET2 적용 문장을 SELECT 로 재현해 플랜/시간 실측 (읽기 전용)

INSERT 를 뺀 동일 SELECT 를 리터럴 바인드로 재현한다. 원장을 건드리지 않고
40분짜리 Transfer 전체를 다시 돌리지 않아도 개선 여부를 판정할 수 있다.
힌트만 바꿔 3안을 같은 조건에서 비교한다.
"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

VER = "R_S_20260128_V002_C"
DIV = "40"
YYYY = "2026"

BRANCH = """
                SELECT {H} A.DIVISION_ID, A.PRODUCT_GROUP
                     , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
                     , CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0
                            THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1) ELSE A.QTY END AS QTY
                  FROM {TBL} A
                  LEFT OUTER JOIN {ISV} B
                    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
                 WHERE A.DIVISION_ID = '{D}' AND A.VERSION_NO = '{V}'
                   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
"""


ISV_CTE = """WITH ISV AS (
    SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
      FROM SCM_MGR.DM_MST_ITEM_SINGLE_V )
"""


def stmt(outer_hint, branch_hint, materialize=False):
    src = "ISV" if materialize else "SCM_MGR.DM_MST_ITEM_SINGLE_V"
    b1 = BRANCH.format(H=branch_hint, TBL="SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C", D=DIV, V=VER, ISV=src)
    b2 = BRANCH.format(H=branch_hint, TBL="SCM_MGR.DM_PLN_SALES_ETC_REPORT_C", D=DIV, V=VER, ISV=src)
    head = ISV_CTE if materialize else ""
    mm = "\n".join(
        "     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '%02d' THEN A.QTY ELSE 0 END) AS MM%02d"
        % (m, m) for m in range(1, 13))
    return head, """
SELECT {OH} A.DIVISION_ID
     , '{V}' AS VERSION_NO
     , Y.YYYY AS YYYY
     , 'SP' AS SP_BP_TYPE
     , A.PRODUCT_GROUP AS PRODUCT_NAME
     , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'-')
            WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'-')
            ELSE '-' END AS PRODUCT_DETAIL
     , A.MEASURE
{MM}
     , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
             WHERE V.DIVISION_ID = '{D}' AND V.VERSION_NO = '{V}' AND ROWNUM = 1), '-') AS ORI_VERSION_NO
     , B.DISPLAY_SEQ AS SORT_NO
  FROM (
{B1}
                UNION ALL
{B2}
       ) A
  LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
    ON A.PRODUCT_GROUP = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
  CROSS JOIN ( SELECT TO_CHAR(TO_NUMBER('{Y}') - 1) AS YYYY FROM DUAL
               UNION ALL SELECT '{Y}' AS YYYY FROM DUAL
               UNION ALL SELECT TO_CHAR(TO_NUMBER('{Y}') + 1) AS YYYY FROM DUAL ) Y
 WHERE 1 = 1 AND A.YYYYMMDD LIKE Y.YYYY || '%'
 GROUP BY A.DIVISION_ID, A.PRODUCT_GROUP
     , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'-')
            WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'-')
            ELSE '-' END
     , A.MEASURE, B.DISPLAY_SEQ, Y.YYYY
""".format(OH=outer_hint, MM=mm, B1=b1, B2=b2, D=DIV, V=VER, Y=YYYY)


CASES = [
    ("배포 전 원본 (힌트 0)", "", "", False),
    ("TUNE-T ① 만 (안쪽만 차단)", "", "/*+ NO_PUSH_PRED(B) USE_HASH(B) */", False),
    ("TUNE-T ①+② = 현재 배포본", "/*+ NO_PUSH_PRED(A) */", "/*+ NO_PUSH_PRED(B) USE_HASH(B) */", False),
    ("★ 구조개선 WITH MATERIALIZE (힌트 0)", "", "", True),
]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 600000  # 10분 상한
        res = {}
        for label, oh, bh, mat in CASES:
            print("\n### %s" % label, flush=True)
            head, body = stmt(oh, bh, mat)
            t0 = time.time()
            try:
                cur.execute("%sSELECT COUNT(*), NVL(SUM(MM01+MM12),0) FROM (%s)" % (head, body))
                row = cur.fetchone()
                el = time.time() - t0
                res[label] = row
                print("   행수/검증합 %s  —  %.1f초" % (row, el), flush=True)
            except Exception as e:
                print("   중단(%.1f초): %s" % (time.time() - t0, str(e)[:110]), flush=True)
        print("\n=== 결과 동일성 ===")
        vals = list(res.values())
        for k, v in res.items():
            print("  %-32s %s" % (k, v))
        if len(vals) > 1:
            print("  → 전부 동일: %s" % ("YES ✅" if all(v == vals[0] for v in vals) else "NO ⛔"))


if __name__ == "__main__":
    main()
