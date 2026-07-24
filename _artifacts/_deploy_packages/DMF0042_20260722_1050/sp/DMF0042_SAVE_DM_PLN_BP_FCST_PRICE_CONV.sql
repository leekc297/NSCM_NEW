CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV" 
(

  -- Add the parameters for the stored procedure here
   s_flag                   VARCHAR2,
   s_division_id            VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
 * Description  : Business Plan PRICE 계산 Procedure
 *                1. Procedure에서 저장시 : s_flag = 'CALL'
           (1) DMF0042_SAVE_DM_PLN_BP_FCST 프로시져에서 호출시 TEMP TABLE로 대상을 전달받음
                     (2) DM_PLN_BP_FCST 테이블에 생성할 FUTURE PRICE 금액을 생성하여 TEMP TABLE로 RETURN해줌
                  2. ui에서 Set Price 버튼을 클릭하여 전체 재계산 요청시 : s_flag <> 'CALL'
           (1) Division만 전달받아 전체 Item에 대하여 재계산수행함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190429 KHSONG Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190830 JSYOUN 81, 82 사업부에 따른 변경
 * 2020/04/09 P.C.I    PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/06/12 hwi1993  temp3 에 넣을 때 Price <> 0 조건 제거 ( 오류내역 : Loc 를 0으로 변경시, USD, KRW Price 가 변경안됨 )
 * 2020/08/25 hwi1993 [C20200820-000170] Business Plan. Set Price 버튼 클릭시 Amnt 메저들 업데이트( 현재는 Price 메저만 업데이트함 )
 * 2020/08/27 hwi1993 [C20200820-000170] Business Plan. 운영에서 실행시간이 너무 오래 걸려서 속도개선함.
 2020/09/09     P.C.I   [C20200909-000203] LOG 표준화 적용
 * 2021/07/23 hwi1993 incoterms 추가 등 ( 중장기계획 과제 관련 )
 * 2021/08/06 hwi1993 MKT FCST 메저 추가
 * 2022/06/21 rosia27 [C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 18:40:46
 * 파일: DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * IF 위치:     L106, L167, L230, L325, L336, L347, L360, L379, L402, L421, L560
 * END IF 위치: L233, L334, L345, L355, L398, L400, L439, L440, L526, L564, L576
 * BEGIN 위치:  L76, L93, L128, L188
 * END;  위치:  L141, L205, L504, L524, L578
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L312
 * END LOOP 위치: L468
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_PROJECT_NAME VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_DOM_EXP VARCHAR2(4000 CHAR);
    v_FCST_TYPE VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_ITEM_USE VARCHAR2(4000 CHAR);
    v_UNIT_ENERGY NUMBER(30,10);
    v_CELL_PROD_SITE VARCHAR2(4000 CHAR);
    v_PRICE NUMBER(30,10);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_CREATION_DATE DATE;
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATE_DATE DATE;
    v_ROW_COUNT VARCHAR2(4000 CHAR);
    v_DEPT_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_BIZ_TYPE VARCHAR2(4000 CHAR);
    n1_MEASURE VARCHAR2(4000 CHAR);
    n2_MEASURE VARCHAR2(4000 CHAR);
    n1_PRICE NUMBER(30,10);
    n2_PRICE NUMBER(30,10);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_cnt_1  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    V_BP_QTY NUMBER(30,10);
    v_exchange_price NUMBER(30,10);
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;

    CURSOR future_price_cur IS
      SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.YYYYMM,B.CURRENCY
            ,B.MEASURE,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS
            ,B.ITEM_USE,B.UNIT_ENERGY
            ,B.CELL_PROD_SITE
            ,B.QTY
            ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE
            ,B.ROW_COUNT
            ,NVL((SELECT C.QTY FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY C
                  WHERE C.DIVISION_ID = B.DIVISION_ID AND C.PROJECT_CODE = B.PROJECT_CODE
                    AND C.SCM_SITE_ID = B.SCM_SITE_ID AND C.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND C.ITEM_ID = B.ITEM_ID AND C.YYYYMM = B.YYYYMM
                    AND C.CURRENCY = B.CURRENCY AND C.DOM_EXP = B.DOM_EXP
                    AND C.FCST_TYPE = B.FCST_TYPE AND C.INCOTERMS = B.INCOTERMS
                    AND C.ITEM_USE = B.ITEM_USE AND C.UNIT_ENERGY = B.UNIT_ENERGY
                    AND C.CELL_PROD_SITE = B.CELL_PROD_SITE
                    AND C.DEPT_ID = B.DEPT_ID AND C.END_CUSTOMER = B.END_CUSTOMER
                    AND C.BIZ_TYPE = B.BIZ_TYPE
                    AND C.MEASURE = 'Business_Plan'
                    AND ROWNUM = 1), 0) V_BP_QTY
       FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4 B
       WHERE B.MEASURE = 'LOC'
       ORDER BY B.ROW_COUNT;
BEGIN

DBMS_OUTPUT.PUT_LINE('EXEC_001                                       =>  '  ||  TO_CHAR(SYSDATE));

  -- PJ20200138 item_use, unit_energy 추가
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    --v_description := 'DIVISION_ID : ' || p_division_id;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)
    -- 트랜잭션 (START)
    --
  -- -----------------------------------------------------------------------------------------
    -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
  -- -----------------------------------------------------------------------------------------
    BEGIN

      -- Temp Table0 존재여부 확인하여 삭제
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP0_4';

      -- Temp Table2 존재여부 확인하여 삭제
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP2_4';

        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB_FUTURE_PRICE_TEMP_QTY';

      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      IF s_flag = 'CALL' THEN
          --임시확인
          --SELECT 'GT_SDPB_BP_FCST'
          --SELECT * FROM GT_SDPB_BP_FCST
          insert into GT_SDPBP_FUTURE_PRICE_TEMP0_4
          SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,'' AS DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
                ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                          ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                          ,COUNT(*) G_COUNT
           FROM GT_SDPB_BP_FCST  WHERE 1=1
              --AND DIVISION_ID = p_division_id
              --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
              AND MEASURE NOT IN ('Business_Plan', 'MKT_FCST')
              GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
             ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE;

      END IF;

      IF s_flag <> 'CALL' THEN
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 전체대상인경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
        insert into GT_SDPBP_FUTURE_PRICE_TEMP0_4
        SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
            ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
              ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                      ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                      ,COUNT(*) G_COUNT
         FROM DM_PLN_BP_FCST  WHERE 1=1
            AND DIVISION_ID = s_division_id
            --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
          GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
           ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE;
      END IF;

      -- Temp Table1 존재여부 확인하여 삭제
      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP0_4'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4
      -- Temp Table1 에 작업대상을 저장
      /* TODO:GTT:GT_SDPBP_FUTURE_PRICE_TEMP1_2-->GT_SDPBP_FUTURE_PRICE_TEMP1_2 */
      INSERT INTO GT_SDPBP_FUTURE_PRICE_TEMP1_2
      SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
          ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,CELL_PROD_SITE
            ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                  ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                  ,G_COUNT
       FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4  WHERE 1=1
            --AND G_COUNT < 3     -- 3개 정상 셋트가 아닌경우만 대상으로함 -> 20180720 KHSONG 주석처리 전체를 다시 계산함
            GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE
         ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE;

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP1_2'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 대상데이터 INSERT INTO insert into GT_SDPBP_FUTURE_PRICE_TEMP2_4
      INSERT INTO GT_SDPBP_FUTURE_PRICE_TEMP2_4
      SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.ITEM_ID,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS-- PJ20200138 Incoterms 삭제
            ,B.ITEM_USE, B.UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,B.CELL_PROD_SITE
            ,B.MEASURE,B.PLANT_SITE_ID,B.YYYYMM,B.CURRENCY,B.QTY
                  ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE-- 20190830 추가
                  ,G_COUNT,row_number() OVER (ORDER BY B.DIVISION_ID) ROW_COUNT
       FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2 B
      ORDER BY G_COUNT;

      -- Business Plan 메저만 별도 저장
      insert into GT_SDPB_FUTURE_PRICE_TEMP_QTY
      SELECT *
      FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
      WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST');

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP2_4'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
      -- Temp Table3 존재여부 확인하여 삭제
     /* SELECT * INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
        FROM DM_PLN_BP_FCST  ; -- TEMP 테이블 컬럼생성*/

      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP3_2';

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP2_4'
      --DROP TABLE TEMP_SKH_0605_FUTURE_PRICE_TEMP2
      --SELECT * INTO TEMP_SKH_0605_FUTURE_PRICE_TEMP2
      --FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
--SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
--SELECT * FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY
      -- 변수선언
      --    V_ROW_COUNT VARCHAR2(2 CHAR);
    -- V_BP_QTY NUMBER(30,10) -- [C20200820-000170]

      -- 데이터 확인하여 INSERT
        -- 커서 확인후 초기화
      --SELECT COUNT(1)
      --INTO v_cnt_1
      --FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'future_price_cur';
      --IF v_cnt_1 > 0 THEN
      --  close future_price_cur
      --  deallocate future_price_cur
      --END IF;

      -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- future_price_cur CURSOR fast_forward for
      --OPEN O_RC1 FOR

        -- 커서 오픈
      OPEN future_price_cur;

      -- -----------------------------------------------------------------------------------------------------
      FETCH future_price_cur INTO
                        v_DIVISION_ID
             ,v_PROJECT_CODE
             ,v_PROJECT_NAME
             ,v_SCM_SITE_ID
             ,v_PLANT_SITE_ID
             ,v_ITEM_ID
             ,v_YYYYMM
             ,v_CURRENCY
             ,v_MEASURE
             ,v_DOM_EXP
             ,v_FCST_TYPE
             ,v_INCOTERMS  -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             ,v_ITEM_USE
             ,v_UNIT_ENERGY
             ,v_CELL_PROD_SITE
             ,v_PRICE
                       -- 20190830 추가
                       ,v_DEPT_ID
                       ,v_END_CUSTOMER
                       ,v_BIZ_TYPE

             ,v_ROW_COUNT
             ,V_BP_QTY;
      -- -----------------------------------------------------------------------------------------------------
      WHILE future_price_cur%FOUND LOOP
      -- -----------------------------------------------------------------------------------------------------
        --확인 SELECT V_ROW_COUNT AS 'V_ROW_COUNT'
        --확인 SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4  WHERE ROW_COUNT = V_ROW_COUNT
        -- 변수 초기화
        n1_MEASURE := NULL;
        n2_MEASURE := NULL;
        n1_PRICE := 0;
        n2_PRICE := 0;

        -- 임시확인
        --SELECT 'v_MEASURE',v_MEASURE,'v_CURRENCY',v_CURRENCY
      -- -----------------------------------------------------------------------------------------------------
        IF  v_MEASURE='LOC' AND v_CURRENCY = 'KRW' THEN
            -- KRW SETTING
            n1_MEASURE := 'KRW';
            n1_PRICE := v_PRICE;

            -- USD 산출
            n2_MEASURE := 'USD';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(v_PRICE / v_exchange_price, 0);
            END IF;

        IF  v_MEASURE='LOC' AND v_CURRENCY = 'USD' THEN
            -- USD SETTING
            n1_MEASURE := 'USD';
            n1_PRICE := v_PRICE;

            -- KRW 산출
            n2_MEASURE := 'KRW';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(v_PRICE * v_exchange_price, 0);
            END IF;

        IF  v_MEASURE='LOC' AND v_CURRENCY NOT IN ('KRW','USD') THEN
            n1_MEASURE := 'KRW';
            -- KRW 산출
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = v_CURRENCY AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n1_PRICE := v_PRICE * v_exchange_price;
            n2_MEASURE := 'USD';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(n1_PRICE / v_exchange_price, 0);
            END IF;

        -- 임시확인
        --SELECT   v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n2_MEASURE
        --    ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS,ROUND(n2_PRICE,3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP
        IF  n1_MEASURE IS NOT NULL THEN
          -- PRICE INSERT #1
          insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
            (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
            ,QTY
            ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
          values
            (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n1_MEASURE
            ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS -- PJ20200138 Incoterms 삭제
            ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,v_CELL_PROD_SITE
            ,ROUND(n1_PRICE,3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
            ,null,null,null,null,null,null,null,null,null,null
                        ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가

          IF s_flag <> 'CALL' THEN
            -- Amount INSERT #1
            insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
              (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
              ,QTY
              ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
              ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
              ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
            values
              (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY, 'SalesAmt_'  ||  n1_MEASURE
              ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
              ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,v_CELL_PROD_SITE
              ,ROUND(n1_PRICE * V_BP_QTY,3)
              ,'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
              ,null,null,null,null,null,null,null,null,null,null
              ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가
          END IF;

          END IF;

        IF  n2_MEASURE IS NOT NULL THEN
          -- PRICE INSERT #2
          insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
            (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
            ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
            ,QTY
            ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
          values
            (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n2_MEASURE
            ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
            ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,v_CELL_PROD_SITE
            ,ROUND(n2_PRICE, 3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
            ,null,null,null,null,null,null,null,null,null,null
                        ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가

          IF s_flag <> 'CALL' THEN
            -- Amount INSERT #2
            insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
              (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
              ,QTY
              ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
              ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
              ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
            values
              (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY, 'SalesAmt_'  ||  n2_MEASURE
              ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
              ,v_ITEM_USE, v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,v_CELL_PROD_SITE
              ,ROUND(n2_PRICE * V_BP_QTY, 3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
              ,null,null,null,null,null,null,null,null,null,null
              ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가
          END IF;
          END IF;

      -- -----------------------------------------------------------------------------------------------------
      FETCH future_price_cur INTO
                        v_DIVISION_ID
             ,v_PROJECT_CODE
             ,v_PROJECT_NAME
             ,v_SCM_SITE_ID
             ,v_PLANT_SITE_ID
             ,v_ITEM_ID
             ,v_YYYYMM
             ,v_CURRENCY
             ,v_MEASURE
             ,v_DOM_EXP
             ,v_FCST_TYPE
             ,v_INCOTERMS -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             ,v_ITEM_USE
             ,v_UNIT_ENERGY
             ,v_CELL_PROD_SITE
             ,v_PRICE
                       -- 20190830 추가
                       ,v_DEPT_ID
                       ,v_END_CUSTOMER
                       ,v_BIZ_TYPE

             ,v_ROW_COUNT
             ,V_BP_QTY;
      END LOOP;
      -- -----------------------------------------------------------------------------------------------------
      close future_price_cur;
      -- deallocate  future_price_cur
--select 'GT_SDPBP_FUTURE_PRICE_TEMP3_2', * from GT_SDPBP_FUTURE_PRICE_TEMP3_2
      --임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP3_2'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2

      DELETE
        FROM  DM_PLN_BP_FCST
                  WHERE EXISTS (
                    SELECT 1
            FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2 B
             where  1=1
             and  DM_PLN_BP_FCST.DIVISION_ID     =  B.DIVISION_ID
             and  DM_PLN_BP_FCST.PROJECT_CODE    =  B.PROJECT_CODE
             --and  DM_PLN_BP_FCST.PROJECT_NAME    =  B.PROJECT_NAME
             and  DM_PLN_BP_FCST.SCM_SITE_ID     =  B.SCM_SITE_ID
             and  DM_PLN_BP_FCST.PLANT_SITE_ID   =  B.PLANT_SITE_ID
             and  DM_PLN_BP_FCST.ITEM_ID         =  B.ITEM_ID
             and  DM_PLN_BP_FCST.YYYYMM          =  B.YYYYMM
             and  DM_PLN_BP_FCST.CURRENCY        =  B.CURRENCY
             and  DM_PLN_BP_FCST.MEASURE         =  B.MEASURE
             and  DM_PLN_BP_FCST.DOM_EXP         =  B.DOM_EXP
             and  DM_PLN_BP_FCST.FCST_TYPE       =  B.FCST_TYPE
             and  DM_PLN_BP_FCST.INCOTERMS       =  B.INCOTERMS     -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             and  DM_PLN_BP_FCST.ITEM_USE        =  B.ITEM_USE
             and  DM_PLN_BP_FCST.UNIT_ENERGY     =  B.UNIT_ENERGY
             and  DM_PLN_BP_FCST.CELL_PROD_SITE  =  B.CELL_PROD_SITE
                       -- 20190830 추가
             and  DM_PLN_BP_FCST.DEPT_ID         =  B.DEPT_ID
             and  DM_PLN_BP_FCST.END_CUSTOMER    =  B.END_CUSTOMER
             and  DM_PLN_BP_FCST.BIZ_TYPE        =  B.BIZ_TYPE
          );


      INSERT INTO DM_PLN_BP_FCST
         ( DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
        ,INCOTERMS-- PJ20200138 Incoterms 삭제
        ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
        ,CELL_PROD_SITE
        ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
        ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가
        )
        SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
          ,INCOTERMS-- PJ20200138 Incoterms 삭제
          ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,CELL_PROD_SITE
          ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
          ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                    ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가
        FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2;

        /*---------------------------------------------------------------*/
     -- IF 0 > 0
    -- 트랜잭션 (COMMIT)
        --COMMIT;
  -- -----------------------------------------------------------------------------------------
    -- END TRY
  -- -----------------------------------------------------------------------------------------
  -- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
  -- -----------------------------------------------------------
    --[C20200909-000203] LOG 표준화 적용
    -- 트랜잭션 (END)
    --    SELECT 'ERROR';
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := SUBSTR(SQLERRM, 1, 1000);
      v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      d_event_date := SYSTIMESTAMP;
    --[C20200909-000203] LOG 표준화 적용
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

    V_SQL_CODE    := SQLCODE;
    V_SQL_ERRMSG  := SQLERRM;

    OPEN O_RC2 FOR
    SELECT '['  ||  TO_CHAR(V_SQL_CODE)  ||  ']'  ||  v_log_message FROM DUAL;  /*-- 에러메시지 DISPLAY --*/

  END;
  -- -----------------------------------------------------------
    -- END CATCH
  -- -----------------------------------------------------------
  -- 수행결과 성공여부 DISPLAY
    IF s_flag <> 'CALL' and v_log_message IS NULL THEN
        --SELECT 'success'
        OPEN O_RC1 FOR
        SELECT 'Sales Price Recalculation is Complete' FROM DUAL;
      END IF;

      -- Temp Table0 존재여부 확인하여 삭제
      -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    --v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );


END;
/
