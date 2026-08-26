#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_patch_dmf0082_pricechk1_20260818.py — 52주 판가 검증을 Excel Upload 1단계로 전진

요구(2026-08-18 사용자): "이러한 오류가 발생할 사항이면 1단계에서 오류로 발생시켜주세요"
  — [OK](P_MODE=1) 적재부의 P_DMF0082_SAVE_MAIN_DATA 검증 10(Unit Price Not Found)이 전체 실패로
    떨어지던 것을, [Upload](P_MODE=0) 분류 단계에서 위반 키의 행을 ERROR 로 표기하도록 전진.
  — 2단계의 기존 검증은 최종 방어선으로 유지(무변경).

판정 산식 = SAVE 검증 1.2(판가 수집: 원장 LOC ∪ 업로드 LOC) + 10(52주 커버리지) 1:1,
SENTINEL3 정규화·MKT_FCST_VALIDATION_PRICE 대상/제외(FCSTNAME 코드∪명칭) 동일.
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

SRC = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_deployed2_20260818.sql"
OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_PRICECHK1_20260818.sql"

ANCHOR = """        /* [변환 노트] AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록"""

INJECT = """        --================================================================================================
        -- [E20260818-PRICECHK1] 52주 판가(Unit Price) 검증을 1단계([Upload])로 전진 (사용자 요구).
        --   종전: 2단계([OK]) 적재부의 SAVE_MAIN_DATA 검증 10 에서야 전체 실패(Unit Price Not Found).
        --   본 블록: 같은 판정(정본 = SAVE 검증 1.2 판가 수집 + 10 판정, SENTINEL3 정규화 동일)을
        --   분류 단계에서 수행해 위반 키의 업로드 행을 ERROR + 상세 메시지로 표기한다.
        --   2단계 검증은 최종 방어선으로 유지. GTT 는 사용 전 DELETE (커넥션 풀 세션 잔존 방어).
        --================================================================================================
        DECLARE
            v_chk_cnt PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(*) INTO v_chk_cnt
            FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = v_program_id
            AND    SHEET_NAME = v_sheet_name
            AND    CREATED_BY = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'SUCCESS';

            IF v_chk_cnt > 0 THEN
                -- (1) 업로드분 일 단위 전개 → GT_PRDM1_T_MAIN (2단계 적재부와 동일 경로 재사용)
                SCM_MGR.PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA(p_created_by, v_rc_a, v_rc_b, v_rc_c);
                BEGIN IF v_rc_a IS NOT NULL THEN CLOSE v_rc_a; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
                BEGIN IF v_rc_b IS NOT NULL THEN CLOSE v_rc_b; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
                BEGIN IF v_rc_c IS NOT NULL THEN CLOSE v_rc_c; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

                INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
                ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
                , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
                , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
                , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
                SELECT U.DIVISION_ID, U.END_CUSTOMER, U.SCM_SITE_ID, U.ITEM_ID, U.INCOTERMS
                     , U.FCST_TYPE, U.DOM_EXP, U.CELL_PROD_SITE, U.CURRENCY, U.MEASURE
                     , U.KEY_VALUE, U.YYYYMM, U.YYYYMM || '01', NULL
                     , 1, U.QTY, U.QTY, 'Y', U.QTY
                FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT U
                WHERE  U.MEASURE = 'VMI_In_Req'
                AND    NVL(U.QTY, 0) <> 0;

                DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
                INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
                ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
                , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
                , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
                SELECT 'M'
                     , D.DIVISION_ID
                     , D.END_CUSTOMER
                     , D.END_CUSTOMER
                     , D.SCM_SITE_ID
                     , D.ITEM_ID
                     , D.DOM_EXP
                     , D.FCST_TYPE
                     , D.INCOTERMS
                     , D.MEASURE
                     , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                               FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                              WHERE X.DIVISION_ID       = D.DIVISION_ID
                                AND X.PROJECT_CODE      = D.END_CUSTOMER
                                AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                                AND X.ITEM_ID           = D.ITEM_ID
                                AND X.DOM_EXP           = D.DOM_EXP
                                AND X.FCST_TYPE         = D.FCST_TYPE
                                AND X.INCOTERMS         = D.INCOTERMS
                                AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                          , '-' )
                     , D.CELL_PROD_SITE
                     , D.BASIS_YYYYMMDD
                     , D.CURRENCY
                     , D.DAILY_QTY
                     , p_created_by
                     , '', '', '', '', '', '', '', '', '', '', '', ''
                FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY D
                WHERE  NVL(D.MONTHLY_QTY, 0) <> 0;

                -- (2) 검증 대상 MEASURE / 제외 FCST_TYPE (SAVE 검증 10 동일 — lookup 단일 소스)
                DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1;
                INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)
                SELECT MST.SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                AND    MST.SEGMENT1 = 'MEASURE' AND MST.VALID_YN = 'Y';

                DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;
                INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2)
                SELECT MST.SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                AND    MST.SEGMENT1 = 'FCST_TYPE' AND MST.VALID_YN = 'Y';

                -- (3) 판가 52주 수집 — 원장 LOC ∪ 업로드 LOC (SAVE 검증 1.2 의 40 경로 동일,
                --     SENTINEL3 변형 3형 정규화 비교 동일)
                DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE;
                INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
                SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                     , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
                FROM (
                    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID
                                  , B.CELL_PROD_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
                                  , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
                      ON A.DIVISION_ID  = B.DIVISION_ID
                     AND A.PROJECT_CODE = B.PROJECT_CODE
                     AND A.END_CUSTOMER = B.END_CUSTOMER
                     AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                     AND CASE WHEN TRIM(A.PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END
                       = CASE WHEN TRIM(B.PLANT_SITE_ID) IS NULL OR B.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE B.PLANT_SITE_ID END
                     AND CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
                       = CASE WHEN TRIM(B.CELL_PROD_SITE_ID) IS NULL OR B.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE B.CELL_PROD_SITE_ID END
                     AND A.ITEM_ID   = B.ITEM_ID
                     AND A.DOM_EXP   = B.DOM_EXP
                     AND A.FCST_TYPE = B.FCST_TYPE
                     AND A.INCOTERMS = B.INCOTERMS
                    WHERE B.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND B.YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND B.PRICE <> 0
                      AND B.MEASURE = 'LOC'
                    UNION
                    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID
                                  , A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
                                  , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND A.YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND A.QTY_PRICE <> 0
                      AND A.MEASURE = 'LOC'
                ) AA
                GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                       , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;

                -- (4) 위반 키별 업로드 행 ERROR 분류 (SAVE 검증 10 판정식 동일 — TOP1 대신 전 키)
                FOR v IN (
                    SELECT A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END AS CELL_KEY
                         , A.MEASURE
                         , MIN(M.BASIS_START_DATE) AS MISS_FROM
                         , MAX(M.BASIS_START_DATE) AS MISS_TO
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                            ON A.DIVISION_ID  = Z.DIVISION_ID
                           AND A.PROJECT_CODE = Z.PROJECT_CODE
                           AND A.SCM_SITE_ID  = Z.SCM_SITE_ID
                           AND A.ITEM_ID      = Z.ITEM_ID
                           AND Z.VALID_YN     = 'Y'
                           AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
                    LEFT JOIN (
                        SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M
                        WHERE BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                          AND BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                        GROUP BY BASIS_START_DATE
                    ) M ON 1 = 1
                    LEFT JOIN SCM_MGR.GT_PRDM1_T_PRICE P
                           ON A.DIVISION_ID  = P.DIVISION_ID
                          AND A.PROJECT_CODE = P.PROJECT_CODE
                          AND A.END_CUSTOMER = P.END_CUSTOMER
                          AND A.SCM_SITE_ID  = P.SCM_SITE_ID
                          AND CASE WHEN TRIM(A.PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END
                            = CASE WHEN TRIM(P.PLANT_SITE_ID) IS NULL OR P.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
                          AND CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
                            = CASE WHEN TRIM(P.CELL_PROD_SITE_ID) IS NULL OR P.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE P.CELL_PROD_SITE_ID END
                          AND A.ITEM_ID   = P.ITEM_ID
                          AND A.DOM_EXP   = P.DOM_EXP
                          AND A.FCST_TYPE = P.FCST_TYPE
                          AND A.INCOTERMS = P.INCOTERMS
                          AND P.YYYYMMDD  = M.BASIS_START_DATE
                          AND P.PRICE     > 0
                    WHERE P.YYYYMMDD IS NULL
                      AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU1)
                      AND A.QTY_PRICE <> 0
                      --[E20260814-FCSTNAME] 코드·명칭 양쪽 제외 (SAVE 검증 10 동일)
                      AND A.FCST_TYPE NOT IN (
                              SELECT X.SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU2 X
                              UNION ALL
                              SELECT L.SEGMENT2
                              FROM   SCM_MGR.GT_PRDM1_MSHYCHU2 X
                              JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                     ON L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                    AND L.VALID_YN    = 'Y'
                                    AND L.SEGMENT1    = X.SEGMENT2 )
                    GROUP BY A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                           , CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
                           , A.MEASURE
                ) LOOP
                    UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD EU
                    SET    EU.UPLOAD_STATUS_CODE = 'ERROR'
                         , EU.MESSAGE_TEXT       = 'Unit Price Not Found ! 해당주차의 Sales Price 값을 입력하시기 바랍니다. '
                                                   || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다. '
                                                   || '(미입력: ' || v.MISS_FROM || ' ~ ' || v.MISS_TO || ')'
                    WHERE  EU.PROGRAM_ID = v_program_id
                    AND    EU.SHEET_NAME = v_sheet_name
                    AND    EU.CREATED_BY = p_created_by
                    AND    TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                    AND    EU.UPLOAD_STATUS_CODE = 'SUCCESS'
                    AND    EU.ATTRIBUTE302 = v.END_CUSTOMER
                    AND    EU.ATTRIBUTE303 = v.SCM_SITE_ID
                    AND    EU.ATTRIBUTE304 = v.ITEM_ID
                    AND    EU.ATTRIBUTE305 = v.INCOTERMS
                    AND    EU.ATTRIBUTE306 = v.FCST_TYPE
                    AND    EU.ATTRIBUTE307 = v.DOM_EXP
                    AND    CASE WHEN TRIM(EU.ATTRIBUTE308) IS NULL OR EU.ATTRIBUTE308 IN ('-','--') THEN '-' ELSE EU.ATTRIBUTE308 END = v.CELL_KEY
                    AND    EU.ATTRIBUTE310 = v.MEASURE;
                END LOOP;
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- 1단계 선검증 실패는 분류를 막지 않는다(2단계 검증이 최종 방어) — 단, 조용히 삼키지
                -- 않도록 로그는 남긴다.
                v_log_type    := 'PRICECHK1';
                v_log_message := '########## PRICECHK1 SKIPPED: ' || SUBSTR(SQLERRM, 1, 150) || ' ##########';
                v_description := '';
                d_event_date  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
                EXCEPTION WHEN OTHERS THEN NULL; END;
        END;

        /* [변환 노트] AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록"""


def main():
    body = open(SRC, encoding="utf-8").read()
    cnt = body.count(ANCHOR)
    if cnt != 1:
        raise SystemExit(f"[중단] 앵커 {cnt}회 (1이어야 함)")
    patched = body.replace(ANCHOR, INJECT)
    open(OUT, "w", encoding="utf-8", newline="").write(patched)
    print(f"[1] 패치본 생성 (+{len(patched.splitlines()) - len(body.splitlines())}줄)")

    import ora

    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    ddl = patched.rstrip()
    if ddl.endswith("/"):
        ddl = ddl[:-1].rstrip()
    cur.execute(ddl)
    print("[2] 재배포 완료")
    cur.execute(
        "SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'HH24:MI:SS') FROM ALL_OBJECTS "
        "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1"
    )
    for r in cur.fetchall():
        print("    ", " | ".join(str(v) for v in r))
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'")
    print(f"    컴파일 오류 = {cur.fetchone()[0]}")
    cur.execute(
        "SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' "
        "AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260818-PRICECHK1%'"
    )
    print(f"    마커 = {cur.fetchone()[0]}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
