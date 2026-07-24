
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC" 
(
    p_division_id        IN  VARCHAR2,
    p_project_code       IN  VARCHAR2,
    p_project_name       IN  VARCHAR2,
    p_yyyymm_from        IN  VARCHAR2,
    p_yyyymm_to          IN  VARCHAR2,
    p_yyyymm_from_simul  IN  VARCHAR2,
    p_yyyymm_to_simul    IN  VARCHAR2,
    p_created_by         IN  VARCHAR2,
    p_end_customer       IN  VARCHAR2,
    O_RC1                OUT SYS_REFCURSOR
)
IS
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC]
 * Author:  <Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감분석 Simulation 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.11.03 kcw3408 	[개발요청] 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록) SUPPLY_ISSUE  추가
 2023.11.08 kcw3408 	[개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.12 kcw3408 	[오류수정] EDI-고수분 Data 입력 영업 담당자 및 Logic 문의/확인의 件(PERIOD를 변경하고서 '실행'버튼을 누르면, 고객수요 값이 모두 잘못된 값으로 계산되어 조회됨)
                        YYYYMM 기준이 불일치(@p_yyyymm_to_simul --> @p_yyyymm 로 변경)
 2026.06.08 [PJ202650304] NextSCM Migration  PLS-00382 수정: CAST(x AS NUMBER) -> ROUND(x,2) (MSSQL CONVERT(NUMERIC(4,2),x) 의미 복원)
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC '81', 'A15AI7001', 'AUDI 48V', '202211', '202211','202211', '202311',''
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_project_name=N'12V DSS', @p_yyyymm_from=N'202207', @p_yyyymm_to=N'202408',@p_yyyymm_from_simul=N'202301', @p_yyyymm_to_simul=N'202307',@p_created_by=N''
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_project_name=N'ASVAGCBEV-1',@p_yyyymm_from=N'202211',@p_yyyymm_to=N'202311',@p_yyyymm_from_simul=N'202211',@p_yyyymm_to_simul=N'202310',@p_created_by=N'',@p_end_customer=N'BMW'
 */
    v_CNT               PLS_INTEGER     := 0;
    v_i                 PLS_INTEGER     := 1;
    v_yyyymm            VARCHAR2(20 CHAR);
    v_p_yyyymm          VARCHAR2(20 CHAR);
    v_CUST_FCST_M       VARCHAR2(4000 CHAR);
    v_MKT_FCST_S        VARCHAR2(4000 CHAR);  --수요계획(1st)
    v_MKT_FCST_R        VARCHAR2(4000 CHAR);  --수요계획(Result)

    v_DP_RESULT_SUM     NUMBER(20,10);
    v_DP_RESULT_P       NUMBER(20,10);
    v_DP_RESULT_S       NUMBER(20,10);
    v_DP_RESULT_I       NUMBER(20,10);
    v_DP_RESULT_V       NUMBER(20,10);
    v_DP_RESULT_M       NUMBER(20,10);
    v_DP_RESULT_CP      NUMBER(20,10);
    v_EDI_SUM           NUMBER(20,10);

    v_DP_ANL_SUM        NUMBER(20,10);
    v_DP_ANL_P          NUMBER(20,10);
    v_DP_ANL_S          NUMBER(20,10);
    v_DP_ANL_I          NUMBER(20,10);
    v_DP_ANL_V          NUMBER(20,10);
    v_DP_ANL_M          NUMBER(20,10);
    v_DP_ANL_CP         NUMBER(20,10);
    v_LAST_MONTH_EDI    NUMBER(20,10);

    v_0month_tuesday    VARCHAR2(8 CHAR);   --당월의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
    v_0month            VARCHAR2(6 CHAR);   --M0 당월
    v_1month            VARCHAR2(6 CHAR);   --M-1 전월

    v_s                 PLS_INTEGER     := 0;
    v_PSI_CNT           PLS_INTEGER     := 1;
    v_YYYYMM_CNT        PLS_INTEGER     := 1;
    v_YYYYMM            VARCHAR2(30 CHAR);
    v_YYYYMM_FROM       VARCHAR2(30 CHAR);
    v_YYYYMM_TO         VARCHAR2(30 CHAR);
    v_V_MEASURE         VARCHAR2(30 CHAR);
    v_V_P               PLS_INTEGER     := 0;
    v_V_S               PLS_INTEGER     := 0;
    v_V_I               PLS_INTEGER     := 0;
    v_V_V               PLS_INTEGER     := 0;
    v_V_M               PLS_INTEGER     := 0;
    v_V_CP              PLS_INTEGER     := 0;

    v_weekday           PLS_INTEGER;
    v_next_tue          DATE;
    v_cur_yyyymmdd      VARCHAR2(8 CHAR);
BEGIN
    v_0month := TO_CHAR(SYSDATE, 'YYYYMM');                          --M0 당월
    v_1month := TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');          --M-1 전월

    DBMS_OUTPUT.PUT_LINE('@v_0month = ' || v_0month);
    DBMS_OUTPUT.PUT_LINE('@@v_1month = ' || v_1month);

    SELECT MONTHS_BETWEEN(
               TO_DATE(SUBSTR(p_yyyymm_from, 1, 4) || '-' || SUBSTR(p_yyyymm_from, 5, 2) || '-01', 'YYYY-MM-DD'),
               TO_DATE(SUBSTR(p_yyyymm_to,   1, 4) || '-' || SUBSTR(p_yyyymm_to,   5, 2) || '-01', 'YYYY-MM-DD')
           )
      INTO v_i
      FROM DUAL;

    DBMS_OUTPUT.PUT_LINE('@i = ' || TO_CHAR(v_i));
    DBMS_OUTPUT.PUT_LINE('@p_yyyymm_to = ' || p_yyyymm_to);

    v_p_yyyymm := p_yyyymm_to;

    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TEMP_DATA';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TEMP_DM_MST_VERSION';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TMP_PROJECT_CODE';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TEMP_SCM_MST_SITE';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TMP_DM_PLN_MKT_FCST_C';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C';
    /* 테이블중복제거 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_ANLO_TEMP_AN_LOGIC';

    /* #TMP_PROJECT_CODE */
    INSERT INTO GT_ANLO_TMP_PROJECT_CODE (PROJECT_CODE)
    SELECT PROJECT_CODE
      FROM SCM_MST_PROJECT
     WHERE DIVISION_ID  = p_division_id
       AND PROJECT_NAME = p_project_name;

    COMMIT;

    --월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
    v_cur_yyyymmdd := TO_CHAR(SYSDATE, 'YYYYMM') || '01';
    /* ⚠️ TO_NUMBER(TO_CHAR(date,'D')) 는 NLS_TERRITORY에 따라 요일 번호가 달라짐. MSSQL WEEKDAY=4는 수요일(일요일=1 기준). Oracle에서는 NLS 설정 확인 필요 */
    v_weekday := TO_NUMBER(TO_CHAR(TO_DATE(v_cur_yyyymmdd, 'YYYYMMDD'), 'D'));

    IF v_weekday = 4 THEN
        /* ⚠️ DBO.FN_NEXT_DAY는 커스텀 함수. Oracle 내장 NEXT_DAY로 대체 (NLS_DATE_LANGUAGE 확인 필요) */
        v_next_tue := FN_NEXT_DAY(TO_DATE(v_cur_yyyymmdd, 'YYYYMMDD') - 1, 'TUE');
        v_0month_tuesday := TO_CHAR(v_next_tue - 7, 'YYYYMMDD');
    ELSE
        /* 당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff */
        /* ⚠️ DATEADD(WK, DATEDIFF(WK,0,DATEADD(DD,5-DAY(SYSDATE),SYSDATE)),1) 로직: 해당 주의 월요일을 구함 */
        v_0month_tuesday := TO_CHAR(
            TRUNC(SYSDATE + (5 - TO_NUMBER(TO_CHAR(SYSDATE, 'DD'))), 'IW'),
            'YYYYMMDD'
        );
    END IF;

    /* #TEMP_DM_MST_VERSION */
    INSERT INTO GT_ANLO_TEMP_DM_MST_VERSION (NUM, VERSION_NO, VERSION_TYPE)
    SELECT ROW_NUMBER() OVER (ORDER BY X.VERSION_NO) AS NUM
         , X.VERSION_NO
         , X.VERSION_TYPE
      FROM (
            SELECT ROW_NUMBER() OVER (PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
                 , A.VERSION_NO
                 , A.VERSION_TYPE
              FROM DM_MST_VERSION A
              JOIN SCM_SYS_CALENDAR_M B
                ON A.YYYYMMDD = B.BASIS_YYYYMMDD
             WHERE 1 = 1
               AND A.DIVISION_ID  = p_division_id
               AND A.VERSION_TYPE = 'MF_W'   --MKT_FCST Weekly Cutoff
               AND A.YYYYMMDD     = v_0month_tuesday
           ) X
     WHERE RNK = 1;

    COMMIT;

    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
    /* ⚠️ GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V의 컬럼 구성은 DM_MST_ITEM_SINGLE_V와 동일해야 함. 사전 DDL 생성 필요 */
    INSERT INTO GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V
    SELECT *
      FROM DM_MST_ITEM_SINGLE_V
     WHERE DIVISION_ID = p_division_id
       AND ITEM_ID IN (
               SELECT ITEM_ID
                 FROM SCM_MST_PROJECT_ITEM
                WHERE PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                  AND VALID_YN = 'Y'
           )
       AND ITEM_TYPE   = 'P'
       AND ACTIVE_FLAG = 'Y';

    COMMIT;
    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------

    --SCM_MST_SITE 대상건만 추출
    /* 테이블중복제거 */
    INSERT INTO GT_ANLO_TEMP_SCM_MST_SITE (DIVISION_ID, SCM_SITE_ID, END_CUSTOMER)
    SELECT DIVISION_ID
         , SCM_SITE_ID
         , END_CUSTOMER
      FROM SCM_MST_SITE
     WHERE DIVISION_ID   = p_division_id
       AND END_CUSTOMER  = p_end_customer;

    COMMIT;

    /* ⚠️ GT_ANLO_TMP_DM_PLN_MKT_FCST_C 컬럼 구성은 DM_PLN_MKT_FCST_C와 동일해야 함. 사전 DDL 생성 필요 */
    INSERT INTO GT_ANLO_TMP_DM_PLN_MKT_FCST_C
    SELECT X.*
      FROM DM_PLN_MKT_FCST_C X
      JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
        ON X.VERSION_NO = Y.VERSION_NO
      JOIN GT_ANLO_TEMP_SCM_MST_SITE Z
        ON X.DIVISION_ID  = Z.DIVISION_ID
       AND X.SCM_SITE_ID  = Z.SCM_SITE_ID
     WHERE 1 = 1
       AND X.DIVISION_ID   = p_division_id
       AND X.MEASURE       IN ('MKT_FCST', 'CUST_FCST_EDI', 'CUST_FCST')
       AND X.PROJECT_CODE  = p_project_code
       --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
       AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V);
       --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

    COMMIT;

    /* ⚠️ GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C 컬럼 구성은 DM_PLN_MKT_FCST_RESULT_C와 동일해야 함 */
    INSERT INTO GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C
    SELECT X.*
      FROM DM_PLN_MKT_FCST_RESULT_C X
      JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
        ON X.VERSION_NO = Y.VERSION_NO
      JOIN GT_ANLO_TEMP_SCM_MST_SITE Z
        ON X.DIVISION_ID  = Z.DIVISION_ID
       AND X.SCM_SITE_ID  = Z.SCM_SITE_ID
     WHERE 1 = 1
       AND X.DIVISION_ID   = p_division_id
       AND X.MEASURE       IN ('MKT_FCST', 'CUST_FCST_EDI', 'CUST_FCST')
       AND X.PROJECT_CODE  = p_project_code
       --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
       AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V);
       --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

    COMMIT;

    --SELECT * FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V

    WHILE v_i <= 0 LOOP

        SELECT COUNT(*)
          INTO v_CNT
          FROM DM_ANL_MKT_PSI
         WHERE 1 = 1
           AND DIVISION_ID   = p_division_id
           --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
           AND END_CUSTOMER  = p_end_customer
           AND PROJECT_CODE  = p_project_code
           AND YYYYMM        = TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM');

        IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') THEN
            --고객수요계획
            IF TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN
                SELECT (A_QTY + B_QTY)
                  INTO v_CUST_FCST_M
                  FROM (
                        SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
                          FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_C X
                          JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
                            ON X.VERSION_NO = Y.VERSION_NO
                         WHERE 1 = 1
                           AND X.DIVISION_ID  = p_division_id
                           AND X.MEASURE      IN ('CUST_FCST_EDI', 'CUST_FCST')
                           --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                           AND X.PROJECT_CODE = p_project_code
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                           AND X.FCST_TYPE = 'MPS'
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND SUBSTR(X.YYYYMMDD, 1, 6) = v_p_yyyymm
                           AND X.QTY <> 0
                       ) A,
                       (
                        SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
                          FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C X
                          JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
                            ON X.VERSION_NO = Y.VERSION_NO
                         WHERE 1 = 1
                           AND X.DIVISION_ID  = p_division_id
                           AND X.MEASURE      IN ('CUST_FCST_EDI', 'CUST_FCST')
                           --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                           AND X.PROJECT_CODE = p_project_code
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                           AND X.FCST_TYPE = 'MPS'
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND SUBSTR(X.YYYYMMDD, 1, 6) = v_p_yyyymm
                       ) B;
            ELSE
                v_CUST_FCST_M := '0';
            END IF;

            --마케팅수요계획
            IF TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN
                --수요계획(1st)
                SELECT (A_QTY + B_QTY)
                  INTO v_MKT_FCST_S
                  FROM (
                        SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
                          FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_C X
                          JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
                            ON X.VERSION_NO = Y.VERSION_NO
                         WHERE 1 = 1
                           AND X.DIVISION_ID  = p_division_id
                           AND X.MEASURE      = 'RTF_SYS_RP'
                           --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                           AND X.PROJECT_CODE = p_project_code
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                           AND X.FCST_TYPE = 'MPS'
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND SUBSTR(X.YYYYMMDD, 1, 6) = v_p_yyyymm
                           AND X.QTY <> 0
                       ) A,
                       (
                        SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
                          FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C X
                          JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
                            ON X.VERSION_NO = Y.VERSION_NO
                         WHERE 1 = 1
                           AND X.DIVISION_ID  = p_division_id
                           AND X.MEASURE      = 'RTF_SYS_RP'
                           --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                           AND X.PROJECT_CODE = p_project_code
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                           AND X.FCST_TYPE = 'MPS'
                           --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                           AND SUBSTR(X.YYYYMMDD, 1, 6) = v_p_yyyymm
                       ) B;
            ELSE
                v_MKT_FCST_S := '0';
            END IF;

            IF TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_1month THEN
                --수요계획(Result)
                /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
                SELECT v_MKT_FCST_R = (A_QTY + B_QTY)
                FROM (
                    SELECT ISNULL(CEILING(SUM(QTY)), 0) AS A_QTY
                    FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_C X
                    JOIN GT_ANLO_TEMP_DM_MST_VERSION Y ON X.VERSION_NO = Y.VERSION_NO
                    WHERE 1=1
                    AND DIVISION_ID = p_division_id
                    AND MEASURE = 'RTF_SYS_RP'
                    --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                    AND PROJECT_CODE = p_project_code
                    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                    AND ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                    AND X.FCST_TYPE = 'MPS'
                    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                    AND SUBSTRING(YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, -1, v_p_yyyymm + '01'), 112)
                    AND QTY <> 0
                    ) A,
                    (
                    SELECT ISNULL(CEILING(SUM(QTY)), 0) AS B_QTY
                    FROM GT_ANLO_TMP_DM_PLN_MKT_FCST_RESULT_C X
                    JOIN GT_ANLO_TEMP_DM_MST_VERSION Y ON X.VERSION_NO = Y.VERSION_NO
                    WHERE 1=1
                    AND DIVISION_ID = p_division_id
                    AND MEASURE = 'RTF_SYS_RP'
                    --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
                    AND PROJECT_CODE = p_project_code
                    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                    AND ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
                    AND X.FCST_TYPE = 'MPS'
                    --DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
                    AND SUBSTRING(YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, -1, v_p_yyyymm + '01'), 112)
                    ) B
                */
                SELECT A.A_QTY
                  INTO v_MKT_FCST_R
                  FROM (
                        SELECT NVL(CEIL(SUM(QTY)), 0) AS A_QTY
                          FROM DM_PLN_MKT_FCST_RESULT X
                          JOIN SCM_MST_SITE_ITEM F
                            ON  F.DIVISION_ID  = X.DIVISION_ID
                           AND  F.PROJECT_CODE = X.PROJECT_CODE
                           AND  F.SCM_SITE_ID  = X.SCM_SITE_ID
                           AND  F.ITEM_ID      = X.ITEM_ID
                          JOIN GT_ANLO_TEMP_SCM_MST_SITE H
                            ON  F.DIVISION_ID  = H.DIVISION_ID
                           AND  F.SCM_SITE_ID  = H.SCM_SITE_ID
                          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
                            ON  G.SEGMENT1     = X.FCST_TYPE
                           AND  G.LOOKUP_TYPE  = 'SALES_TYPE_CODE'
                         WHERE 1 = 1
                           AND X.DIVISION_ID   = p_division_id
                           AND X.MEASURE       = 'RTF_SYS_RP'
                           AND X.PROJECT_CODE  = p_project_code
                           AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), -1), 'YYYYMM')
                       ) A;
            ELSE
                v_MKT_FCST_R := '0';
            END IF;
        ELSE
            v_CUST_FCST_M := '0';
            v_MKT_FCST_S  := '0';
            v_MKT_FCST_R  := '0';
        END IF;

        IF v_CNT = 0 THEN
            IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
               AND TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , v_CUST_FCST_M
                     , 'Average impact(%)'
                     , '0%', '0%', '0%', '0%', '0%', '0%', '0%'
                     , NULL, '1'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , v_CUST_FCST_M
                     , 'Simulation (Impact)'
                     , 0, 0, 0, 0, 0, 0, 0, 0, '2'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , v_CUST_FCST_M
                     , 'Demand Plan (1st)'
                     , 0, 0, 0, 0, 0, 0, 0, CEIL(TO_NUMBER(v_MKT_FCST_S)), '3'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , v_CUST_FCST_M
                     , 'Demand Plan (final)'
                     , 0, 0, 0, 0, 0, 0, 0, CEIL(TO_NUMBER(v_MKT_FCST_R)), '4'
                  FROM DUAL;

            ELSE
                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , 0
                     , 'Average impact(%)'
                     , '0%', '0%', '0%', '0%', '0%', '0%', '0%'
                     , NULL, '1'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , 0
                     , 'Simulation (Impact)'
                     , 0, 0, 0, 0, 0, 0, 0, 0, '2'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , 0
                     , 'Demand Plan (1st)'
                     , 0, 0, 0, 0, 0, 0, 0, CEIL(TO_NUMBER(v_MKT_FCST_S)), '3'
                  FROM DUAL;

                INSERT INTO GT_ANLO_TEMP_DATA
                SELECT p_division_id, p_end_customer, p_project_name, p_project_code
                     , TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                     , 0
                     , 'Demand Plan (final)'
                     , 0, 0, 0, 0, 0, 0, 0, CEIL(TO_NUMBER(v_MKT_FCST_R)), '4'
                  FROM DUAL;
            END IF;
        ELSE
            -- 고객수요증감분석 전체조회
            INSERT INTO GT_ANLO_TEMP_DATA
            SELECT T1.DIVISION_ID AS DIVISION_ID
                 , p_end_customer
                 , p_project_name
                 , p_project_code
                 , T1.YYYYMM AS YYYYMM
                 , (CASE WHEN NVL(T1.CUST_FCST_M, 0) = 0 THEN
                              v_CUST_FCST_M
                         WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                          AND TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN
                              v_CUST_FCST_M
                         ELSE TO_CHAR(CEIL(T1.CUST_FCST_M))
                    END) AS EDI_QTY
                 , (CASE T1.MEASURE
                         WHEN 'AN_LOGIC'  THEN 'Average impact(%)'
                         WHEN 'AN_RESULT' THEN 'Simulation (Impact)'
                         WHEN 'DP_INIT'   THEN 'Demand Plan (1st)'
                         WHEN 'DP_RESULT' THEN 'Demand Plan (final)'
                    END) AS MEASURE
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T2.VSUM AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T2.VSUM), 'FM999,999,999,999')
                    END) AS C_SUM
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.P_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.P_VALUE), 'FM999,999,999,999')
                    END) AS PRODUCT
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.S_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.S_VALUE), 'FM999,999,999,999')
                    END) AS SALE
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.I_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.I_VALUE), 'FM999,999,999,999')
                    END) AS INVENTORY
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.V_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.V_VALUE), 'FM999,999,999,999')
                    END) AS TIME_ADJUST
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.M_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.M_VALUE), 'FM999,999,999,999')
                    END) AS MODEL_MIX
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'
                              THEN TO_CHAR(ROUND(CAST(T1.CP_VALUE AS FLOAT), 2)) || '%'
                         ELSE TO_CHAR(CEIL(T1.CP_VALUE), 'FM999,999,999,999')
                    END) AS SUPPLY_ISSUE
                 , (CASE WHEN T1.MEASURE = 'AN_RESULT' THEN
                              (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN 0
                                    ELSE CEIL(T1.MKT_FCST_M) END)
                         WHEN T1.MEASURE = 'DP_INIT' THEN
                              (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
                                         CEIL(TO_NUMBER(v_MKT_FCST_S))
                                    WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                     AND TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN
                                         CEIL(TO_NUMBER(v_MKT_FCST_S))
                                    ELSE CEIL(T1.MKT_FCST_M) END)
                         WHEN T1.MEASURE = 'DP_RESULT' THEN
                              (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
                                         CEIL(TO_NUMBER(v_MKT_FCST_R))
                                    WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                     AND TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month THEN
                                         CEIL(TO_NUMBER(v_MKT_FCST_R))
                                    ELSE CEIL(T1.MKT_FCST_M) END)
                         ELSE NULL END)
                 , (CASE WHEN T1.MEASURE = 'AN_LOGIC'  THEN '1'
                         WHEN T1.MEASURE = 'AN_RESULT' THEN '2'
                         WHEN T1.MEASURE = 'DP_INIT'   THEN '3'
                         ELSE '4' END) AS RNK
              FROM DM_ANL_MKT_PSI T1
              /* ⚠️ MSSQL UNPIVOT → Oracle: UNION ALL로 대체하여 VSUM 계산 */
              LEFT OUTER JOIN (
                    SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE
                         , SUM(VVALUE) AS VSUM
                      FROM (
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, P_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                            UNION ALL
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, S_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                            UNION ALL
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, I_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                            UNION ALL
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, V_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                            UNION ALL
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, M_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                            UNION ALL
                            SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, CP_VALUE AS VVALUE FROM DM_ANL_MKT_PSI
                           ) UPV_RST
                     GROUP BY PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE
                   ) T2
                ON T1.PROJECT_CODE   = T2.PROJECT_CODE
               AND T1.END_CUSTOMER   = T2.END_CUSTOMER
               AND T1.YYYYMM         = T2.YYYYMM
               AND T1.MEASURE        = T2.MEASURE
             WHERE 1 = 1
               AND T1.DIVISION_ID    = p_division_id
               AND T1.END_CUSTOMER   = p_end_customer
               AND T1.PROJECT_CODE   = p_project_code
               AND T1.YYYYMM         = TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM');  --20240112 @p_yyyymm_to_simul --> @p_yyyymm 로 변경

            IF TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') >= TO_CHAR(TO_DATE(p_yyyymm_from_simul || '01', 'YYYYMMDD'), 'YYYYMM')
            AND TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') <= TO_CHAR(TO_DATE(p_yyyymm_to_simul   || '01', 'YYYYMMDD'), 'YYYYMM') THEN

                SELECT T1.CUST_FCST_M   + NVL(v_EDI_SUM,       0)
                     , T2.VSUM          + NVL(v_DP_RESULT_SUM,  0)
                     , T1.P_VALUE       + NVL(v_DP_RESULT_P,    0)
                     , T1.S_VALUE       + NVL(v_DP_RESULT_S,    0)
                     , T1.I_VALUE       + NVL(v_DP_RESULT_I,    0)
                     , T1.V_VALUE       + NVL(v_DP_RESULT_V,    0)
                     , T1.M_VALUE       + NVL(v_DP_RESULT_M,    0)
                     , NVL(T1.CP_VALUE, 0) + NVL(v_DP_RESULT_CP, 0)
                  INTO v_EDI_SUM
                     , v_DP_RESULT_SUM
                     , v_DP_RESULT_P
                     , v_DP_RESULT_S
                     , v_DP_RESULT_I
                     , v_DP_RESULT_V
                     , v_DP_RESULT_M
                     , v_DP_RESULT_CP
                  FROM DM_ANL_MKT_PSI T1
                  /* ⚠️ UNPIVOT → UNION ALL 대체 */
                  LEFT OUTER JOIN (
                        SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE
                             , SUM(VVALUE) AS VSUM
                          FROM (
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, P_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                                UNION ALL
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, S_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                                UNION ALL
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, I_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                                UNION ALL
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, V_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                                UNION ALL
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, M_VALUE  AS VVALUE FROM DM_ANL_MKT_PSI
                                UNION ALL
                                SELECT PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE, CP_VALUE AS VVALUE FROM DM_ANL_MKT_PSI
                               ) UPV_RST
                         GROUP BY PROJECT_CODE, END_CUSTOMER, YYYYMM, MEASURE
                       ) T2
                    ON T1.PROJECT_CODE   = T2.PROJECT_CODE
                   AND T1.END_CUSTOMER   = T2.END_CUSTOMER
                   AND T1.YYYYMM         = T2.YYYYMM
                   AND T1.MEASURE        = T2.MEASURE
                 WHERE 1 = 1
                   AND T1.DIVISION_ID    = p_division_id
                   AND T1.END_CUSTOMER   = p_end_customer
                   AND T1.PROJECT_CODE   = p_project_code
                   AND T1.YYYYMM         = TO_CHAR(ADD_MONTHS(TO_DATE(v_p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
                   AND T1.MEASURE        = 'DP_RESULT';
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('@@p_yyyymm = ' || v_p_yyyymm || ' '
            || TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm_to_simul || '01', 'YYYYMMDD'), v_i + 1), 'YYYYMM')
            || ' ' || TO_CHAR(v_i));

        v_i := v_i + 1;

    END LOOP;

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    SELECT MONTHS_BETWEEN(
               TRUNC(SYSDATE, 'MM'),
               TO_DATE(p_yyyymm_from_simul || '01', 'YYYYMMDD')
           )
      INTO v_YYYYMM_CNT
      FROM DUAL;

    v_YYYYMM_FROM := p_yyyymm_from_simul;

    SELECT TO_CHAR(SYSDATE, 'YYYYMM')
      INTO v_YYYYMM_TO
      FROM DUAL;

    /* GT_ANLO_TEMP_AN_LOGIC는 이 프로시저에서 별도 사용 없음 (향후 확장용) */

    --PRINT v_YYYYMM_CNT

    SELECT NVL(CEIL(SUM(QTY)), 0)
      INTO v_LAST_MONTH_EDI
      FROM DM_PLN_MKT_FCST_C X
      JOIN GT_ANLO_TEMP_DM_MST_VERSION Y
        ON X.VERSION_NO = Y.VERSION_NO
      JOIN GT_ANLO_TEMP_SCM_MST_SITE Z
        ON X.DIVISION_ID = Z.DIVISION_ID
       AND X.SCM_SITE_ID = Z.SCM_SITE_ID
     WHERE 1 = 1
       AND X.DIVISION_ID   = p_division_id
       AND X.MEASURE       IN ('CUST_FCST_EDI', 'CUST_FCST')
       --AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM GT_ANLO_TMP_PROJECT_CODE)
       AND X.PROJECT_CODE  = p_project_code
       AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_ANLO_TMP_DM_MST_ITEM_SINGLE_V)
       AND X.FCST_TYPE = 'MPS'
       AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm_to_simul || '01', 'YYYYMMDD'), 1), 'YYYYMM');  --'202308'

    v_DP_ANL_SUM := ROUND(v_DP_RESULT_SUM / v_EDI_SUM, 2);
    v_DP_ANL_P   := ROUND(v_DP_RESULT_P   / v_EDI_SUM, 2);
    v_DP_ANL_S   := ROUND(v_DP_RESULT_S   / v_EDI_SUM, 2);
    v_DP_ANL_I   := ROUND(v_DP_RESULT_I   / v_EDI_SUM, 2);
    v_DP_ANL_V   := ROUND(v_DP_RESULT_V   / v_EDI_SUM, 2);
    v_DP_ANL_M   := ROUND(v_DP_RESULT_M   / v_EDI_SUM, 2);
    v_DP_ANL_CP  := ROUND(v_DP_RESULT_CP  / v_EDI_SUM, 2);

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_EDI_SUM));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_SUM, 0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_P,   0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_S,   0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_I,   0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_V,   0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_M,   0), 2) * 100) || '%');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(ROUND(NVL(v_DP_ANL_CP,  0), 2) * 100) || '%');

    UPDATE GT_ANLO_TEMP_DATA
       SET C_SUM       = TO_CHAR(ROUND(NVL(v_DP_ANL_SUM, 0), 2) * 100) || '%'
         , PRODUCT     = TO_CHAR(ROUND(NVL(v_DP_ANL_P,   0), 2) * 100) || '%'
         , SALE        = TO_CHAR(ROUND(NVL(v_DP_ANL_S,   0), 2) * 100) || '%'
         , INVENTORY   = TO_CHAR(ROUND(NVL(v_DP_ANL_I,   0), 2) * 100) || '%'
         , TIME_ADJUST = TO_CHAR(ROUND(NVL(v_DP_ANL_V,   0), 2) * 100) || '%'
         , MODEL_MIX   = TO_CHAR(ROUND(NVL(v_DP_ANL_M,   0), 2) * 100) || '%'
         , SUPPLY_ISSUE= TO_CHAR(ROUND(NVL(v_DP_ANL_CP,  0), 2) * 100) || '%'
     WHERE YYYYMM      = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm_to_simul || '01', 'YYYYMMDD'), 1), 'YYYYMM')
       AND MEASURE      = 'Average impact(%)';

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_LAST_MONTH_EDI));

    UPDATE GT_ANLO_TEMP_DATA
       SET C_SUM       = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_SUM, 0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , PRODUCT     = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_P,   0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , SALE        = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_S,   0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , INVENTORY   = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_I,   0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , TIME_ADJUST = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_V,   0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , MODEL_MIX   = TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_M,   0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
         , SUPPLY_ISSUE= TO_CHAR(CEIL(ROUND(NVL(v_DP_ANL_CP,  0), 3) * v_LAST_MONTH_EDI), 'FM999,999,999,999')
     WHERE YYYYMM      = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm_to_simul || '01', 'YYYYMMDD'), 1), 'YYYYMM')
       AND MEASURE      = 'Simulation (Impact)';

    COMMIT;

    OPEN O_RC1 FOR
    SELECT T.DIVISION_ID
         , T.END_CUSTOMER
         , T.PROJECT_NAME
         , T.PROJECT_CODE
         , SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2) AS YYYYMM
         , CEIL(TO_NUMBER(EDI_QTY)) AS EDI_QTY
         , MEASURE
         , C_SUM        AS "SUM"
         , PRODUCT
         , SALE
         , INVENTORY
         , TIME_ADJUST
         , MODEL_MIX
         , MKT_DP
         , SUPPLY_ISSUE  --2023.11.03 kcw3408 	[개발요청] 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록)
      FROM GT_ANLO_TEMP_DATA T
     ORDER BY YYYYMM ASC
            , RNK;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, SQLERRM);
END ;
/