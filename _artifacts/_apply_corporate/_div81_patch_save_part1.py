#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_SAVE_MAIN_DATA div81 패치 생성기 — Part 1 (변수/판정/게이트)
대상: DMF0082_SAVE_MAIN_DATA_div81_20260714.sql (backup 복사본을 in-place 수정)
각 치환은 정확히 1회 발생해야 하며 아니면 즉시 실패 (anti-simplification)."""
import io, sys, pathlib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
F = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_SAVE_MAIN_DATA_div81_20260714.sql")
src = F.read_text(encoding="utf-8")

R = []  # (label, old, new)

# 1) 이력 헤더 + 선언부 변수 추가
R.append(("history", " * 2026.03.10	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선",
 " * 2026.03.10	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선\n"
 " * 2026.07.14	admin		[DIV81] Division 81(LIKE '81%') 분기 — 81 테이블(DM_PLN_MKT_FCST/SCM_MST_FUTURE_PRICE) 직접 DML\n"
 " *                          + 81 전용 Validation(V81-00~11, 정본 DMF0003/DMF0020) + PR_DM_PLN_CFM_TO_MKT_FCST 게이트. 40 경로 원문 무수정."))

R.append(("declare", "    V_EDIT_CNT          NUMBER;",
 """    V_EDIT_CNT          NUMBER;

    --[DIV81] Division 81 분기 변수 (2026-07-14)
    v_is_81             VARCHAR2(1 CHAR) := 'N';
    v_div_cnt           NUMBER := 0;
    V_VALID_PROJECT_CODE VARCHAR2(200 CHAR);
    V_VALID_TYPE        VARCHAR2(100 CHAR);
    V_DESC_81           VARCHAR2(4000 CHAR);"""))

# 2) V81-00 division 판정 + 혼합 차단 + '-' 정규화 (T_MAIN 적재 직후)
R.append(("v81-00", """    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (START)""",
 """    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --==========================================================================================================================
    --[DIV81] 0. Division 판정 + 혼합 유입 차단(V81-00) + 81 placeholder 정규화 (START)
    --  단일 Division 전제(사용자 확정 2026-07-14). LIKE '81%' = 81 계열(81/81_HD/81_HG/81_HM/81_ST/81_UC 실측).
    --  40 흐름은 V_DIVISION_ID 재할당 결과가 '40' 이므로 기존 동작 불변.
    --==========================================================================================================================
    SELECT COUNT(DISTINCT DIVISION_ID) INTO v_div_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;

    IF v_div_cnt > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '복수 Division 데이터는 동시에 저장할 수 없습니다. 단일 Division 으로 저장하세요.';
        RAISE e_validation_error;
    END IF;

    IF v_div_cnt = 1 THEN
        SELECT MIN(DIVISION_ID) INTO V_DIVISION_ID FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;

    IF V_DIVISION_ID LIKE '81%' THEN
        v_is_81 := 'Y';
        -- 81 테이블에는 END_CUSTOMER / CELL_PROD_SITE_ID 컬럼이 없다 (ALL_TAB_COLUMNS 실측 2026-07-14).
        -- GET 커서의 '-' 리터럴과 동일하게 T_MAIN 도 '-' 로 정규화하여 하류 join 키를 일관시킨다.
        UPDATE SCM_MGR.GT_PRDM1_T_MAIN
        SET END_CUSTOMER = '-', CELL_PROD_SITE_ID = '-';
    END IF;
    --==========================================================================================================================
    --[DIV81] 0. Division 판정 (END)
    --==========================================================================================================================

    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (START)"""))

# 3) #1.2 T_PRICE 수집 — IF(40 원문)/ELSE(81: SCM_MST_FUTURE_PRICE) 분기
R.append(("t_price-open", "    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE",
 "    IF v_is_81 = 'N' THEN  --[DIV81] 판가 52주 수집 분기\n    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE"))

R.append(("t_price-else", "    ) AA;\n\n    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_PRICE');",
 """    ) AA;
    ELSE
        --[DIV81] 1.2-81). Sales Price 52주 구간 수집 — SCM_MST_FUTURE_PRICE (정본 DMF0003 L619 이식)
        --  81 조인키 8종 (END_CUSTOMER/CELL_PROD_SITE_ID 제외, PLANT_SITE_ID 조인 포함 — 81 정본 규약)
        INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
        , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
            -- DB에 있는 원래 데이터 (81: SCM_MST_FUTURE_PRICE, placeholder '-' 부여)
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, '-' AS END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID
                          , '-' AS CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.SCM_MST_FUTURE_PRICE B
              ON A.DIVISION_ID   = B.DIVISION_ID
             AND A.PROJECT_CODE  = B.PROJECT_CODE
             AND A.SCM_SITE_ID   = B.SCM_SITE_ID
             AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
             AND A.ITEM_ID       = B.ITEM_ID
             AND A.DOM_EXP       = B.DOM_EXP
             AND A.FCST_TYPE     = B.FCST_TYPE
             AND A.INCOTERMS     = B.INCOTERMS
            WHERE B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
            -- UI에서 입력한 신규/수정 데이터 ('-' 정규화 값 그대로)
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID
                          , A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) AA81
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;
    END IF;  --[DIV81] 판가 52주 수집 분기

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_PRICE');"""))

# 4) #1.3 T_FCST 수집 — 81 skip (CELL_PROD 검증 #8 전용)
R.append(("t_fcst-open", "    INSERT INTO SCM_MGR.GT_PRDM1_T_FCST",
 "    IF v_is_81 = 'N' THEN  --[DIV81] 1.3 은 CELL_PROD 검증(#8) 전용 — 81 제외\n    INSERT INTO SCM_MGR.GT_PRDM1_T_FCST"))
R.append(("t_fcst-close", "    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_FCST');",
 "    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_FCST');\n    END IF;  --[DIV81] 1.3 게이트"))

# 5) #3-1 구코드 INCOTERMS — 81 확장 (DMF0003 L758 동일 검증 존재)
R.append(("inco-extend", """    IF V_DIVISION_ID = '40' THEN
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.INCOTERMS IN (""",
 """    IF V_DIVISION_ID = '40' OR v_is_81 = 'Y' THEN  --[DIV81] 구코드 INCOTERMS 검증 81 확장 (DMF0003 L758 동일)
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.INCOTERMS IN ("""))

# 6) #6 BIZ_TYPE — 81 skip
R.append(("biz-open", """    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.1). 룩업: EXCEPTION_BIZ_TYPE 데이터를 #TEMP_EXCEPTION_BIZ_TYPE에 담는다.""",
 """    IF v_is_81 = 'N' THEN  --[DIV81] BIZ_TYPE 검증(#6)은 40 전용 (81 정본 DMF0003 에 없음)
    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.1). 룩업: EXCEPTION_BIZ_TYPE 데이터를 #TEMP_EXCEPTION_BIZ_TYPE에 담는다."""))
R.append(("biz-close", """        IF v_BIZ_TYPE_CHECK IS NOT NULL THEN
            --BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
            V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK || '는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;""",
 """        IF v_BIZ_TYPE_CHECK IS NOT NULL THEN
            --BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
            V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK || '는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #6 게이트"""))

# 7) #7 CELL_PROD Common — 81 skip
R.append(("v7-open", """    v_CELL_TYPE_CHECK := NULL;

    BEGIN
        v_CELL_TYPE_CHECK := NULL;""",
 """    v_CELL_TYPE_CHECK := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD_SITE_ID 검증(#7)은 40 전용 (81 은 컬럼 부재 — '-' 정규화)
    BEGIN
        v_CELL_TYPE_CHECK := NULL;"""))
R.append(("v7-close", """        IF v_CELL_TYPE_CHECK IS NOT NULL THEN
            V_DESCRIPTION := 'Model*: ' || v_CELL_TYPE_CHECK || '는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;""",
 """        IF v_CELL_TYPE_CHECK IS NOT NULL THEN
            V_DESCRIPTION := 'Model*: ' || v_CELL_TYPE_CHECK || '는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #7 게이트"""))

# 8) #8 — 81 skip (앵커: SELECT A.ITEM_ID INTO s_cell_prod_valid 로 #9 와 구분)
R.append(("v8-open", """    s_cell_prod_valid := NULL;

    BEGIN
        BEGIN
            SELECT A.ITEM_ID INTO s_cell_prod_valid""",
 """    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD 검증(#8)은 40 전용
    BEGIN
        BEGIN
            SELECT A.ITEM_ID INTO s_cell_prod_valid"""))
R.append(("v8-close", """        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (END)""",
 """        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #8 게이트
    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (END)"""))

# 9) #9 — 81 skip (앵커: SELECT 'N' INTO s_cell_prod_valid)
R.append(("v9-open", """    s_cell_prod_valid := NULL;

    BEGIN
        BEGIN
            SELECT 'N' INTO s_cell_prod_valid""",
 """    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD 검증(#9)은 40 전용
    BEGIN
        BEGIN
            SELECT 'N' INTO s_cell_prod_valid"""))
R.append(("v9-close", """        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (END)""",
 """        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #9 게이트

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (END)"""))

# 10) #16 RMA→RTF 생성 DML — 81 skip
R.append(("v16-open", """    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE = 'RTF_SYS_RP'""",
 """    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    IF v_is_81 = 'N' THEN  --[DIV81] RMA→RTF 생성(#16)은 40 전용 (40 테이블 DML)
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE = 'RTF_SYS_RP'"""))
R.append(("v16-close", "      AND RSLT.YYYYMMDD >= v_plan_start_yyyymmdd; -- 당주 월요일이후\n\n    --=",
 "      AND RSLT.YYYYMMDD >= v_plan_start_yyyymmdd; -- 당주 월요일이후\n    END IF;  --[DIV81] #16 게이트\n\n    --="))

applied = 0
for label, old, new in R:
    cnt = src.count(old)
    if cnt != 1:
        sys.exit(f"FAIL [{label}]: anchor count={cnt} (must be 1)")
    src = src.replace(old, new)
    applied += 1
    print(f"OK  [{label}]")

F.write_text(src, encoding="utf-8")
print(f"\nPart1 done: {applied} replacements applied to {F.name}")
