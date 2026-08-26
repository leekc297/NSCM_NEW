# -*- coding: utf-8 -*-
"""[E20260825-XLSPRICECOL2] 검증 SP(P_DMF0082_EXCEL_UPLOAD) 슬롯 2·8 재편 edits 생성
   슬롯2: End Customer -> Project Code (값 의미 동일 — 81 EC역변환은 코드 항등 실측. 라벨/메시지 정정)
   슬롯8: Cell Prod Site -> Plant Site (검증 = SITE(PLANT,VALID) ∪ 원장 도메인 / 적재 = 직송)"""
import io, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

edits = []

def add(old, new):
    assert src.count(old) == 1, "not unique (%d): %s" % (src.count(old), old[:80])
    edits.append({"old": old, "new": new})

# V1: 필수값 체크 헤더 주석 + CASE 라벨
add("""        ATTRIBUTE1  Div*
        ATTRIBUTE2  End Customer*""",
    """        ATTRIBUTE1  Div*
        ATTRIBUTE2  Project Code*   [E20260825-XLSPRICECOL2] 양식 컬럼 = 단가 테이블 축 (구 End Customer 슬롯 — 81 은 원래 코드가 실렸음)""")
add("""        ATTRIBUTE8  Cell Prod Site*
        ATTRIBUTE9  Currency*""",
    """        ATTRIBUTE8  Plant Site*   [E20260825-XLSPRICECOL2] 구 Cell Prod Site 슬롯 -> 원장 PLANT_SITE_ID 직송
        ATTRIBUTE9  Currency*""")
add("""                                         WHEN ATTRIBUTE2  IS NULL THEN 'NULL End Customer'""",
    """                                         WHEN ATTRIBUTE2  IS NULL THEN 'NULL Project Code'""")
add("""                                         WHEN ATTRIBUTE8  IS NULL THEN 'NULL Cell Prod Site'""",
    """                                         WHEN ATTRIBUTE8  IS NULL THEN 'NULL Plant Site'""")

# V2: EC 블록 헤더/메시지 (역변환 로직 무수정 — 81 코드 항등 + 존재검증 겸용)
add("""        /* #################################################### */
        /* END CUSTOMER 체크                                     */
        --ATTRIBUTE2    End Customer (Name)
        --ATTRIBUTE302  End Customer (Code) - SYSTEM UPDATE
        /* #################################################### */""",
    """        /* #################################################### */
        /* PROJECT CODE 체크  [E20260825-XLSPRICECOL2]           */
        --ATTRIBUTE2    Project Code (81 = 코드 그대로. 구 End Customer 슬롯 — EC 역변환은 81 에서 코드 항등이라 로직 무수정, 존재검증 겸용)
        --ATTRIBUTE302  Project Code (Code) - SYSTEM UPDATE
        /* #################################################### */""")
add("""             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid End Customer'""",
    """             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Project Code'   /* [E20260825-XLSPRICECOL2] */""")
add("""             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Invalid End Customer/Sales Site.'""",
    """             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Invalid Project Code/Sales Site.'   /* [E20260825-XLSPRICECOL2] */""")

# V3: Cell Prod Site 블록 -> Plant Site 검증
add("""        /* #################################################### */
        /* Cell Prod Site 체크                                   */
        -- ATTRIBUTE8    Cell Prod Site (NAME)
        -- ATTRIBUTE308  Cell Prod Site (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE308 = (SELECT MAX(M.SEGMENT1)
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
                                 WHERE  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
                                 AND    M.VALID_YN    = 'Y'
                                 AND    M.ATTRIBUTE1  = A.ATTRIBUTE8)    ---CELL PROD SITE""",
    """        /* #################################################### */
        /* Plant Site 체크  [E20260825-XLSPRICECOL2]             */
        -- ATTRIBUTE8    Plant Site (원장 PLANT_SITE_ID 코드)
        -- ATTRIBUTE308  Plant Site (검증 통과 코드) --SYSTEM UPDATE
        -- 도메인 = SITE(PLANT,VALID) 마스터 + 원장 실도메인 합집합 (원장 29종 중 5종이 마스터 밖 실측 —
        --   양식이 원장 키를 내리므로 원장 도메인 배제 시 정상 왕복이 거부된다) */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE308 = CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE MS
                                                   WHERE MS.DIVISION_ID = A.ATTRIBUTE301
                                                     AND MS.SCM_SITE_ID = A.ATTRIBUTE8
                                                     AND MS.SITE_TYPE   = 'PLANT'
                                                     AND MS.VALID_YN    = 'Y')
                                       OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
                                                   WHERE F.DIVISION_ID   = A.ATTRIBUTE301
                                                     AND F.PLANT_SITE_ID = A.ATTRIBUTE8)
                                     THEN A.ATTRIBUTE8 END""")
add("""             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Cell Prod Site'""",
    """             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Plant Site'   /* [E20260825-XLSPRICECOL2] */""")

# V4: T_MAIN PLANT 직송 — 모드0(PRICECHK1) 지점
old_m0 = """                     , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                               FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                              WHERE X.DIVISION_ID       = D.DIVISION_ID
                                AND X.PROJECT_CODE      = D.END_CUSTOMER
                                AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                                AND X.ITEM_ID           = D.ITEM_ID
                                AND X.DOM_EXP           = D.DOM_EXP
                                AND X.FCST_TYPE         = D.FCST_TYPE
                                AND X.INCOTERMS         = D.INCOTERMS
                                AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                          , NVL( (SELECT MAX(F.PLANT_SITE_ID)   /* [E20260820-XLSWEEKLY] 81 원장 역참조 — 40 참조(DM_PLN_CFM)는 81 에 항상 NULL
                                                                    → PLANT_SITE '-' 로 SAVE 필수검증 'F' (사내 실측 2026-08-20).
                                                                    기존 키('M' 갱신)는 원장 실키로 해소. 원장 무존재 신규 키는 '-' 유지 = Plant Site 축 미결. */
                                 FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
                                WHERE F.DIVISION_ID  = D.DIVISION_ID
                                  AND F.PROJECT_CODE = D.END_CUSTOMER
                                  AND F.SCM_SITE_ID  = D.SCM_SITE_ID
                                  AND F.ITEM_ID      = D.ITEM_ID
                                  AND F.DOM_EXP      = D.DOM_EXP
                                  AND F.FCST_TYPE    = D.FCST_TYPE
                                  AND F.INCOTERMS    = D.INCOTERMS
                                  AND F.MEASURE      = 'LOC')
                             , '-' ) )
                     , D.CELL_PROD_SITE"""
new_m0 = """                     , D.CELL_PROD_SITE   /* [E20260825-XLSPRICECOL2] Plant Site 직송 — 양식 슬롯8 = 원장 PLANT_SITE_ID.
                                                구 원장 역참조 NVL 체인 폐지 ('Plant Site 축 미결' 해소 — 신규 키도 명시 지정) */
                     , '-'                /* [E20260825-XLSPRICECOL2] CELL_PROD_SITE_ID = '-' (81 테이블 컬럼 부재 규약) */"""
add(old_m0, new_m0)

# V5: T_MAIN PLANT 직송 — 모드1([OK] 적재) 지점
old_m1 = """             , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                       FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                      WHERE X.DIVISION_ID       = D.DIVISION_ID
                        AND X.PROJECT_CODE      = D.END_CUSTOMER
                        AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                        AND X.ITEM_ID           = D.ITEM_ID
                        AND X.DOM_EXP           = D.DOM_EXP
                        AND X.FCST_TYPE         = D.FCST_TYPE
                        AND X.INCOTERMS         = D.INCOTERMS
                        AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                  , (SELECT MAX(F.PLANT_SITE_ID)   /* [E20260820-XLSWEEKLY] 81 원장 역참조 — 40 참조(DM_PLN_CFM)는 81 에 항상 NULL
                                                            → PLANT_SITE '-' 로 SAVE 필수검증 'F' (사내 실측 2026-08-20).
                                                            기존 키('M' 갱신)는 원장 실키로 해소. 원장 무존재 신규 키는 '-' 유지 = Plant Site 축 미결.
                                                            [E20260820-SENTINELDDL] 최종 '-' 폴백 NVL 제거 — NULL 이면 GTT DEFAULT ON NULL '-' 적용 */
                         FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
                        WHERE F.DIVISION_ID  = D.DIVISION_ID
                          AND F.PROJECT_CODE = D.END_CUSTOMER
                          AND F.SCM_SITE_ID  = D.SCM_SITE_ID
                          AND F.ITEM_ID      = D.ITEM_ID
                          AND F.DOM_EXP      = D.DOM_EXP
                          AND F.FCST_TYPE    = D.FCST_TYPE
                          AND F.INCOTERMS    = D.INCOTERMS
                          AND F.MEASURE      = 'LOC') )
             , D.CELL_PROD_SITE"""
new_m1 = """             , D.CELL_PROD_SITE   /* [E20260825-XLSPRICECOL2] Plant Site 직송 (모드0 지점과 동일 — 양식 슬롯8) */
             , '-'                /* [E20260825-XLSPRICECOL2] CELL_PROD_SITE_ID = '-' (81 규약) */"""
add(old_m1, new_m1)

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_pricecol_valid.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("valid edits %d건 생성" % len(edits))
