#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_SAVE_MAIN_DATA div81 패치 생성기 — Part 2 (#18 분기 + V81 블록 + DML 분기)"""
import io, sys, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
F = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_SAVE_MAIN_DATA_div81_20260714.sql")
src = F.read_text(encoding="utf-8")

R = []

# 11) #18 Price 삭제 52주 — IF(40 원문)/ELSE(81: DM_PLN_MKT_FCST, DMF0020 L545~670 정본)
R.append(("v18-open", """    IF n_Dflag_chk > 0 THEN
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.""",
 """    IF n_Dflag_chk > 0 THEN
      IF v_is_81 = 'N' THEN  --[DIV81] #18 분기: 40=DM_PLN_CFM_MKT_DEMAND_PLAN / 81=DM_PLN_MKT_FCST(하단 ELSE)
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다."""))

R.append(("v18-else", """            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
    END IF;""",
 """            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      ELSE
        --[DIV81] 18-81). Price 삭제 시 52주 FCST 확인 — DM_PLN_MKT_FCST 기준 (정본 DMF0020 L545~670 이식)
        --  키 8종 (END_CUSTOMER/CELL_PROD 제외), 대상 MEASURE = MKT_FCST/RTF_SCP/AS_In_Req (81 정본 — SCM_FCST 없음)
        -- (a) 52주 이후 동일 주차 존재 확인
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

        -- (b) 52주 이내 존재 확인
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      END IF;  --[DIV81] #18 분기
    END IF;"""))

# 12) [DIV81] 19. 81 전용 Validation 블록 (V81-01~11)
R.append(("v81-block", """    --==========================================================================================================================
    -- Validaion Check (END)
    --==========================================================================================================================""",
 """    --==========================================================================================================================
    --[DIV81] 19. 81 전용 Validation (V81-01 ~ V81-11) — 정본: DMF0003_SAVE_MKT_FCST / DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (START)
    --==========================================================================================================================
    IF v_is_81 = 'Y' THEN

        -- V81-01. 필수 컬럼 + PLANT_SITE_ID 필수 (DMF0003 L566 이식 + plant site 요구사항 2026-07-14)
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE NVL(A.DIVISION_ID, '-')   = '-'
           OR NVL(A.PROJECT_CODE, '-')  = '-'
           OR NVL(A.SCM_SITE_ID, '-')   = '-'
           OR NVL(A.ITEM_ID, '-')       = '-'
           OR NVL(A.DOM_EXP, '-')       = '-'
           OR NVL(A.FCST_TYPE, '-')     = '-'
           OR NVL(A.INCOTERMS, '-')     = '-'
           OR NVL(A.MEASURE, '-')       = '-'
           OR NVL(A.PLANT_SITE_ID, '-') = '-';

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook or Plant Site ) !';
            RAISE e_validation_error;
        END IF;

        -- V81-02. AS PLANT 로 가는 DP 의 INCOTERMS 제한 (DMF0003 L731 이식 — C 조인 무필터 포함 정본 그대로)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.DIVISION_ID  = B.SEGMENT3
         AND   A.SCM_SITE_ID  = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT'
         AND   B.VALID_YN     = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.DIVISION_ID  = C.SEGMENT1
         AND   A.INCOTERMS    = C.SEGMENT2
         AND   C.VALID_YN     = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-03. Invalid Project Code (DMF0003 L847 ≡ DMF0020 L280 이식)
        V_VALID_PROJECT_CODE := NULL;
        BEGIN
            SELECT A.PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.DIVISION_ID  = C.DIVISION_ID
                         AND  A.PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID <> '40'
                   )
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;

        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            RAISE e_validation_error;
        END IF;

        -- V81-04. Cell/Module/Pack 인데 CELL_PER_CAR 미등록 (DMF0003 L1123 이식 — 스테이징 GTT 대신 뷰 직조인)
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.DIVISION_ID  = F.DIVISION_ID
             AND   A.ITEM_ID      = F.ITEM_ID
             AND   A.PROJECT_CODE = F.PROJECT_CODE
             AND   A.SCM_SITE_ID  = F.SCM_SITE_ID
            JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V X
              ON   A.DIVISION_ID = X.DIVISION_ID
             AND   A.ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V X
                WHERE  X.ITEM_ID = v_valid_item_id
                  AND  ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] ' || V_VALID_TYPE || ' does not exist !';
            RAISE e_validation_error;
        END IF;

        -- V81-05. Kwh/Cell(ATTRIBUTE8) / CELL_TYPE(ATTRIBUTE10) / CELL_PER_CAR 필수 (DMF0003 L1170 이식)
        V_DESC_81 := NULL;
        BEGIN
            SELECT V_DESCRIPTION_81 INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                                  OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION_81
                FROM SCM_MGR.GT_PRDM1_T_MAIN A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.DIVISION_ID  = B.DIVISION_ID
                 AND A.PROJECT_CODE = B.PROJECT_CODE
                 AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON A.DIVISION_ID  = C.DIVISION_ID
                 AND A.ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE    = 'P'
                WHERE (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
        EXCEPTION WHEN NO_DATA_FOUND THEN V_DESC_81 := NULL;
        END;

        IF V_DESC_81 IS NOT NULL THEN
            V_DESCRIPTION := V_DESC_81;
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;

        -- V81-06. Invalid Item ID (DMF0020 L324 이식 — ITEM_SN 존재)
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I WHERE I.ITEM_ID = A.ITEM_ID)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Item ID !';
            RAISE e_validation_error;
        END IF;

        -- V81-07. Invalid Sales Site (DMF0020 L365 [V20260708] 이식 — 조회 JOIN 정합. price 행 한정 + 삭제행 제외)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  R.MEASURE = 'LOC'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                   WHERE  S.DIVISION_ID = R.DIVISION_ID
                     AND  S.SCM_SITE_ID = R.SCM_SITE_ID
                     AND  S.SITE_TYPE   = 'SALES'
                     AND  S.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Sales Site ! (Sales Site 마스터 미등록/무효 - Sales Price 는 저장해도 조회되지 않아 저장 차단)';
            RAISE e_validation_error;
        END IF;

        -- V81-08. Invalid Item for Division (DMF0020 L421 이식 — 사업부 Item 마스터. 삭제행 제외)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                   WHERE  I.DIVISION_ID = R.DIVISION_ID
                     AND  I.ITEM_ID     = R.ITEM_ID
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Item for Division ! (해당 사업부 Item 마스터 미등록 - 저장 차단)';
            RAISE e_validation_error;
        END IF;

        -- V81-09. 동일 기간 Currency 중복 (DMF0020 L675 이식 — KRW/USD 파생 전이므로 LOC 기준)
        SELECT COUNT(1) INTO v_cnt_check
        FROM (
            SELECT 1 AS DUP
            FROM SCM_MGR.GT_PRDM1_T_MAIN
            WHERE MEASURE = 'LOC' AND NVL(QTY_PRICE, 0) <> 0
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            HAVING COUNT(CURRENCY) > 1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-10. 신규(I) Price 행이 SCM_MST_FUTURE_PRICE 에 기존재 (DMF0020 L710 이식)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN R
                   WHERE  S.DIVISION_ID   = R.DIVISION_ID
                     AND  S.PROJECT_CODE  = R.PROJECT_CODE
                     AND  S.SCM_SITE_ID   = R.SCM_SITE_ID
                     AND  S.PLANT_SITE_ID = R.PLANT_SITE_ID
                     AND  S.ITEM_ID       = R.ITEM_ID
                     AND  S.YYYYMMDD      = R.YYYYMMDD
                     AND  S.MEASURE       = R.MEASURE
                     AND  S.DOM_EXP       = R.DOM_EXP
                     AND  S.FCST_TYPE     = R.FCST_TYPE
                     AND  S.INCOTERMS     = R.INCOTERMS
                     AND  R.ACTION        = 'I'
                     AND  R.MEASURE       = 'LOC'
               )
          AND  ROWNUM = 1;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-11. AS 계열 FCST TYPE 신규(I) 입력 차단 — 본 SP 는 AS FROM SITE(ATTRIBUTE10) 파라미터가 없어 불완전 저장 방지.
        --  수정(M)은 MERGE 가 기존 ATTRIBUTE10 을 보존하므로 허용. (SALES_TYPE_CODE.ATTRIBUTE2='Y' = AS 계열 — DMF0003 규약)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.FCST_TYPE   = C.SEGMENT1
         AND   C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
         AND   C.ATTRIBUTE2  = 'Y'
        WHERE  A.ACTION = 'I'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  A.SCM_SITE_ID = B.SEGMENT1
                     AND  B.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3    = A.DIVISION_ID
                     AND  B.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS 관련 FCST TYPE 의 신규 입력은 본 화면에서 지원하지 않습니다 (AS FROM SITE 지정 불가). Mkt Fcst 화면을 사용하세요.';
            RAISE e_validation_error;
        END IF;

    END IF;
    --==========================================================================================================================
    --[DIV81] 19. 81 전용 Validation (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- Validaion Check (END)
    --=========================================================================================================================="""))

# 13) MKT_AMT 파생 — 81 skip
R.append(("amt-open", """    ----------------------------------------------------------------------------------------------------------------------------
    -- 3. MKT_AMT_KRW, MKT_AMT_LOC 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN""",
 """    ----------------------------------------------------------------------------------------------------------------------------
    -- 3. MKT_AMT_KRW, MKT_AMT_LOC 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    IF v_is_81 = 'N' THEN  --[DIV81] 81 은 MKT_AMT 메져 미사용 (2026-07-14 실측: 81 measure 인벤토리 부재)
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN"""))
R.append(("amt-close", """           , AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD;

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인""",
 """           , AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD;

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
    ELSE
        n_update_cnt := 0;
    END IF;  --[DIV81] MKT_AMT 파생 게이트"""))

# 14) 판가 DML — IF(40)/ELSE(81: SCM_MST_FUTURE_PRICE DELETE+MERGE)
R.append(("price-dml-open", """    -- Phase 1: DELETE existing rows where new QTY_PRICE = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE A""",
 """    IF v_is_81 = 'N' THEN  --[DIV81] 판가 DML 분기: 40=DM_PLN_CFM_SELLING_PRICE / 81=SCM_MST_FUTURE_PRICE(하단 ELSE)
    -- Phase 1: DELETE existing rows where new QTY_PRICE = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE A"""))
R.append(("price-dml-else", """    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);""",
 """    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
        --[DIV81] Phase 1-81: DELETE SCM_MST_FUTURE_PRICE (QTY_PRICE=0) — 키 10종 (END_CUSTOMER/CELL_PROD 제외)
        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
        WHERE EXISTS (
            SELECT 1 FROM (
                SELECT M.DIVISION_ID, M.PROJECT_CODE, M.SCM_SITE_ID, M.PLANT_SITE_ID
                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                     , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                      , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                      , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                      , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
            ) B
            WHERE RN = 1
              AND B.QTY_PRICE = 0
              AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE
              AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
              AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
              AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
        );

        --[DIV81] Phase 2-81: MERGE SCM_MST_FUTURE_PRICE — INSERT 명시 16컬럼 (정본 DMF0020 L840), PRICE=CAST NUMBER(20,10)
        MERGE INTO SCM_MGR.SCM_MST_FUTURE_PRICE A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                         , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.YYYYMMDD          = B.YYYYMMDD
        AND A.MEASURE           = B.MEASURE
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS)
        WHEN MATCHED THEN
        UPDATE
        SET A.CURRENCY         = B.CURRENCY
          , A.PRICE            = CAST(B.QTY_PRICE AS NUMBER(20,10))
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE
        , DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
        , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, CAST(B.QTY_PRICE AS NUMBER(20,10)), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    END IF;  --[DIV81] 판가 DML 분기"""))

# 15) MKT_AMT DELETE — 81 skip
R.append(("amt-del-open", """    -- 행 Delete 가능 - 편집 가능, 삭제 불가 행의 경우 값 일괄 업데이트 - D로 들어올 경우도 존재 한다.
    -- Phase 1: DELETE MKT_AMT rows where new QTY = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A""",
 """    -- 행 Delete 가능 - 편집 가능, 삭제 불가 행의 경우 값 일괄 업데이트 - D로 들어올 경우도 존재 한다.
    -- Phase 1: DELETE MKT_AMT rows where new QTY = 0
    IF v_is_81 = 'N' THEN  --[DIV81] MKT_AMT DELETE 는 40 전용
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A"""))
R.append(("amt-del-close", """          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD
    );""",
 """          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD
    );
    END IF;  --[DIV81] MKT_AMT DELETE 게이트"""))

# 16) 81-VMI 자동복제 + 수요 DML 분기 open
R.append(("demand-open", """    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched for MKT_FCST,VMI_In_Req only)
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 )
    MERGE INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A""",
 """    --[DIV81] 81-VMI 자동복제 — VMI_YN='Y' 사이트의 MKT_FCST 를 VMI_In_Req 로 동반 저장 (정본 DMF0003 L1588~1614 이식)
    IF v_is_81 = 'Y' THEN
        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT A.ACTION, A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'VMI_In_Req' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.QTY_PRICE, A.CREATED_BY
             , A.V_ATTRIBUTE1, A.V_ATTRIBUTE2, A.V_ATTRIBUTE3, A.V_ATTRIBUTE4
             , A.V_ATTRIBUTE5, A.V_ATTRIBUTE6, A.V_ATTRIBUTE7, A.V_ATTRIBUTE8, A.V_ATTRIBUTE9, A.V_ATTRIBUTE10, A.V_BOM_YN, A.V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN SCM_MGR.SCM_MST_SITE B
          ON A.SCM_SITE_ID = B.SCM_SITE_ID
         AND A.DIVISION_ID = B.DIVISION_ID
         AND B.VMI_YN      = 'Y'
        WHERE A.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W
                WHERE W.DIVISION_ID   = A.DIVISION_ID
                  AND W.PROJECT_CODE  = A.PROJECT_CODE
                  AND W.SCM_SITE_ID   = A.SCM_SITE_ID
                  AND W.ITEM_ID       = A.ITEM_ID
                  AND W.DOM_EXP       = A.DOM_EXP
                  AND W.FCST_TYPE     = A.FCST_TYPE
                  AND W.INCOTERMS     = A.INCOTERMS
                  AND W.PLANT_SITE_ID = A.PLANT_SITE_ID
                  AND W.YYYYMMDD      = A.YYYYMMDD
                  AND W.MEASURE       = 'VMI_In_Req'
          );
    END IF;

    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched for MKT_FCST,VMI_In_Req only)
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 )
    IF v_is_81 = 'N' THEN  --[DIV81] 수요 DML 분기: 40=DM_PLN_CFM_MKT_DEMAND_PLAN / 81=DM_PLN_MKT_FCST(하단 ELSE)
    MERGE INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A"""))

# 17) 수요 DML — ELSE 81 MERGE DM_PLN_MKT_FCST
R.append(("demand-else", """    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);""",
 """    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
        --[DIV81] 수요 DML 81: MERGE DM_PLN_MKT_FCST — ON 키 10종. MERGE 채택 사유: DMF0003 정본은 DELETE+INSERT 이나
        --  기존 ATTRIBUTE(CONFIRM 계열) 보존을 위해 UPDATE 는 QTY/감사컬럼만 갱신. DMF0003 과 동일하게 QTY=0 행도 물리 저장.
        MERGE INTO SCM_MGR.DM_PLN_MKT_FCST A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                         , M.PLANT_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req'))
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.MEASURE           = B.MEASURE
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.YYYYMMDD          = B.YYYYMMDD)
        WHEN MATCHED THEN
        UPDATE
        SET A.QTY              = NVL(B.QTY_PRICE, 0)
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
        , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.YYYYMMDD
        , NVL(B.QTY_PRICE, 0), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE
        , NULL, NULL, NULL, NULL, NULL
        , NULL, NULL, NULL, NULL, NULLIF(B.V_ATTRIBUTE10, '') );
    END IF;  --[DIV81] 수요 DML 분기"""))

# 18) EE 전극 RTF — 81 skip
R.append(("ee-open", """    n_EE_chk := 0;
    SELECT COUNT(*) INTO n_EE_chk""",
 """    n_EE_chk := 0;
    IF v_is_81 = 'N' THEN  --[DIV81] 전극 RTF 생성은 40 전용 (40 테이블 DML)
    SELECT COUNT(*) INTO n_EE_chk"""))
R.append(("ee-close", """        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (END)
        --==========================================================================================================================
    END IF;""",
 """        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (END)
        --==========================================================================================================================
    END IF;
    END IF;  --[DIV81] EE 게이트"""))

# 19) 판가 이력 — IF(40)/ELSE(81: SCM_MST_FUTURE_PRICE_H 명시 17컬럼)
R.append(("price-h-open", "    INSERT INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE_H",
 "    IF v_is_81 = 'N' THEN  --[DIV81] 판가 이력 분기\n    INSERT INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE_H"))
R.append(("price-h-else", """    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정""",
 """    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정
    ELSE
        --[DIV81] SCM_MST_FUTURE_PRICE_H — 명시 17컬럼 (정본 DMF0020 L902)
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
        , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
             , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
             , CREATED_BY, V_GETDATE
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    END IF;  --[DIV81] 판가 이력 분기"""))

# 20) 수요 이력 — IF(40)/ELSE(81: DM_PLN_MKT_FCST_H 명시 26컬럼 의무)
R.append(("plan-h-open", "    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H",
 "    IF v_is_81 = 'N' THEN  --[DIV81] 수요 이력 분기\n    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H"))
R.append(("plan-h-else", """    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정""",
 """    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정
    ELSE
        --[DIV81] DM_PLN_MKT_FCST_H — 명시 26컬럼 의무 (CTAS 사고 쓰레기 컬럼 20여개 실측 — 컬럼 생략/SELECT * 절대 금지), 정본 DMF0003 L1758
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
        , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
             , YYYYMMDD, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE, CREATED_BY
             , V_GETDATE, NULL, NULL, NULL, NULL, NULL
             , NULL, NULL, NULL, NULL, NULLIF(V_ATTRIBUTE10, '')
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req');
    END IF;  --[DIV81] 수요 이력 분기"""))

# 21) PR_DM_PLN_CFM_TO_MKT_FCST 게이트
R.append(("pr-gate", "    SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);",
 """    --[DIV81] 81 은 DM_PLN_MKT_FCST 에 직접 기록하므로 CFM→MKT_FCST 전파 프로시저 skip (게이트 — 2026-07-14 소스 실측 근거)
    --  1) PR 내부 V_DIVISION_ID='40' 하드코딩 — 동기화 자체는 40 한정.
    --  2) 단, GT_PRDM_SEND_TARGET_DATA 적재에 division 필터가 없어 81 행 유입 시 40 BALANCE 재생성이 불필요 실행됨.
    --  3) 참고: PR 은 GT_PRDM_T_MAIN(무 '1')을 읽으나 본 SP 는 GT_PRDM1_T_MAIN 에 적재 — 별개 GTT (잠재 이슈,
    --     40 동작 불변 원칙에 따라 본 패치에서는 미수정. 상세: work_report 2026-07-14 DMF0082 div81).
    IF v_is_81 = 'N' THEN
        SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);
    END IF;"""))

applied = 0
for label, old, new in R:
    cnt = src.count(old)
    if cnt != 1:
        sys.exit(f"FAIL [{label}]: anchor count={cnt} (must be 1)")
    src = src.replace(old, new)
    applied += 1
    print(f"OK  [{label}]")

F.write_text(src, encoding="utf-8")
print(f"\nPart2 done: {applied} replacements applied to {F.name}")
