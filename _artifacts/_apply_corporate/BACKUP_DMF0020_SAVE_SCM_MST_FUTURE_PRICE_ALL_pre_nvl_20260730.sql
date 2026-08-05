CREATE OR REPLACE PROCEDURE           "DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL" 
(
    P_ACTIVE_FLAG       IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_PROJECT_CODE      IN  VARCHAR2,
    P_SCM_SITE_ID       IN  VARCHAR2,
    P_PLANT_SITE_ID     IN  VARCHAR2,
    P_ITEM_ID           IN  VARCHAR2,
    P_YYYYMMDD          IN  VARCHAR2,
    P_CURRENCY          IN  VARCHAR2,
    P_MEASURE           IN  VARCHAR2,
    P_DOM_EXP           IN  VARCHAR2,
    P_FCST_TYPE         IN  VARCHAR2,
    P_INCOTERMS         IN  VARCHAR2,
    P_PRICE             IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_CREATION_DATE     IN  VARCHAR2,
    P_LAST_UPDATED_BY   IN  VARCHAR2,
    P_ROWNUM            IN  VARCHAR2,                 --[PJ20200138] RowNum 추가
    O_RC1               OUT SYS_REFCURSOR,        -- Range Rate 위반 결과셋
    O_RESULT_CURSOR     OUT SYS_REFCURSOR         -- 작업결과 (항상 마지막)
)
/*============================================================================================================================
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL
 * Description  : 'SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE
 * Program History
 *=============================================================================================================================
 *   Date       In Charge       Description
 *=============================================================================================================================
 * 2017/02/12   DWOK/KHSONG     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2017/03/13   JHBAEK          INPUT KEY VALUE(PROJECT_CODE, MODEL) VALIDATION CHECK
 *                              : PROJECT_CODE, MODEL(ITEM) 값을 수기로 입력할 수 있기에 INSERT 전에 VALIDATION CHECK를 한다.
 * 2018/05/14   KHSONG          Sales Price 화면에서 저장시 SalesAmt 계산후 dm_pln_sales_plan 테이블 SAVE Procedure 호출하는 로직 추가
 * 2018/07/18   KHSONG          기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함
 * 2018/07/18   KHSONG          기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경
 * 2018/08/14   KHSONG          Invalid Site Item validation 추가
 * 2018/10/05   khsong          공백제거로직추가
 * 2020/03/04   P.C.I           [PJ20200138] 입력된 Price가 주변 주차와 Range Rate 가 초과되어 차이나는 데이터 Return
 * 2020/04/22   KHSONG          C20200102-000131 GSCM Sales Price 수정 제한 조건 추가 요청의 건
 * 2020/08/14   P.C.I           [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인
 * 2020/09/09   P.C.I           [C20200909-000203] LOG 표준화 적용
 * 2021/12/02   kdw2819         [C20211126-000348] AS In Req관련 추가 체크 로직 보완
 * 2022/03/24   rosia27         [C20220317-000402]MDM 상 block 된 제품의 GSCM 상 삭제 방안 요청
 * 2022/04/01   rosia27         [과제PJ20216891R]GM_JV
 * 2022/07/22   hwi1993         삭제시에는 단가변동 체크 안하도록 하는 로직 테스트중입니다.
 * 2022/08/26   rosia27         환율 정보가 없을 시에 validation 체크하는 로직 추가
 * 2024/02/13   JSSBAE          [E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선
 * 2024/11/22   JSSBAE          [E20241125-000026]_Sales Price Validation 추가
 * 2025/01/24   JSSBAE          [E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가
 * 2025/03/12   JSSBAE          [E20250306-001052]_Sales Price Validation 추가
 * 2025/03/25   P.C.I           [PJ2025-50017] 소형사업부 편집 제외 Validation 추가
 * 2025/07/21   JSSBAE          [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025/08/26   JSSBAE          [E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2026.04.07   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
*============================================================================================================================*/

/*

1. SCM_MGR.SCM_MST_FUTURE_PRICE (메인 테이블)

원본 프로시저명 그대로 "SCM_MST_FUTURE_PRICE TABLE INSERT/UPDATE/DELETE" 가 목적
DELETE: V_ACTIVE_FLAG = 'D' 인 행에 해당하는 기존 데이터 삭제
DELETE + INSERT: V_ACTIVE_FLAG <> 'D' 인 행은 동일 키로 기존 데이터를 먼저 삭제한 뒤 새로 INSERT (MERGE 대신 DELETE-INSERT 패턴 — 2018/07/18 KHSONG 변경 이력)

2. SCM_MGR.SCM_MST_FUTURE_PRICE_H (이력 테이블)

V_ACTIVE_FLAG <> 'D' 인 행을 SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL 시퀀스와 함께 이력 보관

*/
IS
    -- 로깅 표준 변수
    V_PROGRAM_NAME    VARCHAR2(150 CHAR);
    V_LOG_TYPE        VARCHAR2(30  CHAR);
    N_LOG_COUNT       NUMBER(10) := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500  CHAR);
    D_EVENT_DATE      DATE;
    V_SQL_CODE        VARCHAR2(30  CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
    V_PROC_INPUT      CLOB;

    -- 카운터
    N_DELETE_COUNT    NUMBER(10) := 0;
    N_INSERT_COUNT    NUMBER(10) := 0;

    -- Validation 변수
    V_FIRST_DIVISION  VARCHAR2(30  CHAR);
    V_INVALID_CHK     NUMBER(10);
    V_VALID_ITEM_ID   VARCHAR2(50  CHAR);
    V_INVALID_SITE    VARCHAR2(200 CHAR);
    V_INVALID_DUP     VARCHAR2(200 CHAR);
    V_INVALID_DUP_DATA VARCHAR2(200 CHAR);
    N_DFLAG_CHK       NUMBER(10) := 0;
BEGIN
    -- 프로그램명 자동 기록
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    V_LOG_MESSAGE := NULL;  -- <- 변수 재사용을 위하여 초기화

    -- GTT 초기화 (시작 시점, 일반 테이블 DML 없음 → TRUNCATE 사용 가능)
    DELETE FROM SCM_MGR.GT_FCSV_RESULTS_MST;
    DELETE FROM SCM_MGR.GT_FCSV_RESULTS;

    --===================================================================================== GT_FCSV_RESULTS_MST 테이블에 split후 insert start
    -- '^' 구분자로 모든 입력 파라미터를 일괄 파싱하여 GTT에 적재
    -- (MSSQL의 WHILE LEN(@p_DIVISION_ID) > 0 PATINDEX 루프를 SET 단위로 변환)
    INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST
    (
         V_ACTIVE_FLAG
        ,V_DIVISION_ID
        ,V_PROJECT_CODE
        ,V_SCM_SITE_ID
        ,V_PLANT_SITE_ID
        ,V_ITEM_ID
        ,V_YYYYMMDD
        ,V_CURRENCY
        ,V_MEASURE
        ,V_DOM_EXP
        ,V_FCST_TYPE
        ,V_INCOTERMS
        ,V_PRICE
        ,V_CREATED_BY
        ,V_CREATION_DATE
        ,V_LAST_UPDATED_BY
        ,V_ROWNUM
    )
    WITH SPLIT_DATA AS
    (
        SELECT  LEVEL AS LV
               ,TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG     , '[^\^]+', 1, LEVEL)) AS V_ACTIVE_FLAG
               ,TRIM(REGEXP_SUBSTR(P_DIVISION_ID     , '[^\^]+', 1, LEVEL)) AS V_DIVISION_ID
               ,TRIM(REGEXP_SUBSTR(P_PROJECT_CODE    , '[^\^]+', 1, LEVEL)) AS V_PROJECT_CODE
               ,TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID     , '[^\^]+', 1, LEVEL)) AS V_SCM_SITE_ID
               ,TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID   , '[^\^]+', 1, LEVEL)) AS V_PLANT_SITE_ID
               ,TRIM(REGEXP_SUBSTR(P_ITEM_ID         , '[^\^]+', 1, LEVEL)) AS V_ITEM_ID_RAW
               ,TRIM(REGEXP_SUBSTR(P_YYYYMMDD        , '[^\^]+', 1, LEVEL)) AS V_YYYYMMDD
               ,TRIM(REGEXP_SUBSTR(P_CURRENCY        , '[^\^]+', 1, LEVEL)) AS V_CURRENCY
               ,TRIM(REGEXP_SUBSTR(P_MEASURE         , '[^\^]+', 1, LEVEL)) AS V_MEASURE
               ,TRIM(REGEXP_SUBSTR(P_DOM_EXP         , '[^\^]+', 1, LEVEL)) AS V_DOM_EXP
               ,TRIM(REGEXP_SUBSTR(P_FCST_TYPE       , '[^\^]+', 1, LEVEL)) AS V_FCST_TYPE
               ,TRIM(REGEXP_SUBSTR(P_INCOTERMS       , '[^\^]+', 1, LEVEL)) AS V_INCOTERMS
               ,TRIM(REGEXP_SUBSTR(P_PRICE           , '[^\^]+', 1, LEVEL)) AS V_PRICE
               ,TRIM(REGEXP_SUBSTR(P_CREATED_BY      , '[^\^]+', 1, LEVEL)) AS V_CREATED_BY
               ,TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY , '[^\^]+', 1, LEVEL)) AS V_LAST_UPDATED_BY
               ,TRIM(REGEXP_SUBSTR(P_ROWNUM          , '[^\^]+', 1, LEVEL)) AS V_ROWNUM
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^\^]+', 1, LEVEL) IS NOT NULL
    )
    SELECT
         V_ACTIVE_FLAG
        ,V_DIVISION_ID
        ,V_PROJECT_CODE
        ,V_SCM_SITE_ID
        ,V_PLANT_SITE_ID
        -- [E20250522-001188]_TRIM 처리를 했음에도 지워지지 않는 데이터가 존재하는 것 확인하여 ITEM에 추가처리
        -- 1).RTRIM / 2).LTRIM / 3).CHR(13): Carriage return / 4).CHR(10): Line feed / 5).CHR(9): TAB / 6).' '공백을 ''
        ,REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID_RAW), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '') AS V_ITEM_ID
        ,V_YYYYMMDD
        ,V_CURRENCY
        ,V_MEASURE
        ,V_DOM_EXP
        ,V_FCST_TYPE
        ,V_INCOTERMS
        ,TO_NUMBER(V_PRICE DEFAULT 0 ON CONVERSION ERROR)
        ,V_CREATED_BY
        ,SYSDATE                                              -- @v_CREATION_DATE 대신 GETDATE()
        ,V_LAST_UPDATED_BY
        ,TO_NUMBER(V_ROWNUM DEFAULT 0 ON CONVERSION ERROR)    --[PJ20200138] RowNum 추가
    FROM   SPLIT_DATA;

    -- GTT 통계 수집 (1000건 이상 + JOIN/UPDATE 사용 → 조건 충족)
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_FCSV_RESULTS_MST', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_FCSV_RESULTS_MST',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    --[PJ2025-50017] 소형사업부 편집 제외 Validation 추가
    BEGIN
        SELECT V_DIVISION_ID
        INTO   V_FIRST_DIVISION
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_FIRST_DIVISION := NULL;
    END;

    IF V_FIRST_DIVISION = '40' THEN
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        V_DESCRIPTION := '해당 사업부 편집은 Demand - Demand Plan - FcstPrice MGMT 에서 할 수 있습니다.';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    --[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 START
    -- 원본 MSSQL의 UPDATE #results_MST FROM ... JOIN T 구문은 외부 alias A와 서브쿼리 T가
    -- 모두 LOC 행에 매칭되어 A.v_CURRENCY = T.v_CURRENCY 가 되므로
    -- WHERE A.v_CURRENCY <> T.v_CURRENCY 조건이 항상 False 가 되어 0건 갱신.
    -- 원본과 100% 동일 결과 유지를 위해 Oracle 변환에서도 No-op 처리.
    --[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 END

    ---------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START-----------------------------------
    -- LOC메져만 수정할 수 있는 시스템으로, KRW나 USD에 들어온 값과 관계없이 ACTIVE_FLAG를 LOC기준으로 변경작업 진행
    -- 발생한현상: 환율이 없는 경우 KRW나 USD가 0으로 들어오는데, ACTIVE_FLAG가 D로 변경되어 VALIDATION에 걸려 데이터 수정이 불가능함
    -- 원본 MSSQL의 UPDATE 구문은 위 Currency 동기화와 동일한 패턴 (외부 A = LOC, T 내부 A = LOC)으로
    -- WHERE A.v_ACTIVE_FLAG <> T.v_ACTIVE_FLAG 조건이 항상 False 가 되어 0건 갱신.
    -- 원본과 100% 동일 결과 유지를 위해 Oracle 변환에서도 No-op 처리.
    ----------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 END------------------------------------

    --###############################################   GT_FCSV_RESULTS_MST 테이블에 split후 insert (END)
    -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
    BEGIN
        --[E20250306-001052]_비정상적으로 3쌍이 아닌 메져가 들어오는 경우가 발생함(매번 발생하는 건이 아닌, 가끔 발생하는 부분임)
        --VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 START
        --데이터 중 메져가 LOC, KRW, USD 세쌍으로 이루어지지 않은 데이터를 추출한다.
        SELECT COUNT(1)
        INTO   V_INVALID_CHK
        FROM
        (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS
            HAVING COUNT(*) < 3
        );

        -- DBMS_OUTPUT.PUT_LINE('입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.>V_INVALID_CHK:' || V_INVALID_CHK);

        IF V_INVALID_CHK > 0 THEN
            --MSG00452: 입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.
            BEGIN
                SELECT MSG_NM -- KO
                INTO V_DESCRIPTION
                FROM   SCM_MGR.SCM_ADM_MSG_M -- SCM_MGR.TB_FX_MESSAGEINFO
                WHERE  MSG_ID = 'MSG00452' -- MESSAGEID = 'MSG00452'
                AND LANG_CD = 'KO'
                ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_DESCRIPTION := '입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.';
            END;

            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;
        --VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 END

        IF V_FIRST_DIVISION <> '40' THEN
            -- Project Code 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT P
                WHERE  P.PROJECT_CODE = R.V_PROJECT_CODE
            );

            -- DBMS_OUTPUT.PUT_LINE('Project Code 검증>V_INVALID_CHK:' || V_INVALID_CHK);

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.PC || '] Invalid Project Code !'
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_PROJECT_CODE AS PC
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT P
                            WHERE  P.PROJECT_CODE = R.V_PROJECT_CODE
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Project Code !';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            -- Item ID 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                WHERE  I.ITEM_ID = R.V_ITEM_ID
            );

            -- DBMS_OUTPUT.PUT_LINE('Item ID 검증>V_INVALID_CHK:' || V_INVALID_CHK);

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.IID || '] Invalid Item ID !'
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                            WHERE  I.ITEM_ID = R.V_ITEM_ID
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Item ID !';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            --[V20260708-DMF0020] 신규/수정 행 마스터 정합 검증 START (조회 JOIN 미통과 = 저장 차단 + 사유 반환)
            -- 배경: 저장은 되지만 조회 SP(DMF0020_GET_SCM_MST_FUTURE_PRICE)의 하드 JOIN 을 통과하지 못해
            --       화면에서 보이지 않는 사고. 조회와 동일 기준으로 저장 전 검증한다.
            --   (a) SCM_MST_SITE  : DIVISION_ID + SCM_SITE_ID, SITE_TYPE='SALES', VALID_YN='Y' (조회 L301/L683 동일)
            --   (b) SCM_MST_ITEM_SN: DIVISION_ID + ITEM_ID (조회 TMPITEM L597~599 동일 — 기존 Item 검증은 사업부 무관이라 격차)
            --   삭제행(V_ACTIVE_FLAG='D')은 검증 제외 (무효 마스터의 기존 데이터 삭제 허용).
            -- (a) Sales Site 마스터 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG <> 'D'
            AND    NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                WHERE  S.DIVISION_ID = R.V_DIVISION_ID
                AND    S.SCM_SITE_ID = R.V_SCM_SITE_ID
                AND    S.SITE_TYPE   = 'SALES'
                AND    S.VALID_YN    = 'Y'
            );

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.DIV || '/' || X.SITE || '] Invalid Sales Site !'
                           || ' (Sales Site 마스터 미등록/무효 - 저장해도 조회되지 않아 저장 차단)'
                           || CASE WHEN V_INVALID_CHK > 1 THEN ' 외 ' || (V_INVALID_CHK - 1) || '건' ELSE '' END
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_DIVISION_ID AS DIV, R.V_SCM_SITE_ID AS SITE
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  R.V_ACTIVE_FLAG <> 'D'
                        AND    NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                            WHERE  S.DIVISION_ID = R.V_DIVISION_ID
                            AND    S.SCM_SITE_ID = R.V_SCM_SITE_ID
                            AND    S.SITE_TYPE   = 'SALES'
                            AND    S.VALID_YN    = 'Y'
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Sales Site ! (Sales Site 마스터 미등록/무효 - 저장 차단)';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            -- (b) 사업부 Item 마스터 검증 (기존 Item 검증은 사업부 무관 — 조회는 DIVISION 범위로 필터되므로 보강)
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG <> 'D'
            AND    NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                WHERE  I.DIVISION_ID = R.V_DIVISION_ID
                AND    I.ITEM_ID     = R.V_ITEM_ID
            );

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.DIV || '/' || X.IID || '] Invalid Item for Division !'
                           || ' (해당 사업부 Item 마스터 미등록 - 저장해도 조회되지 않아 저장 차단)'
                           || CASE WHEN V_INVALID_CHK > 1 THEN ' 외 ' || (V_INVALID_CHK - 1) || '건' ELSE '' END
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_DIVISION_ID AS DIV, R.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  R.V_ACTIVE_FLAG <> 'D'
                        AND    NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                            WHERE  I.DIVISION_ID = R.V_DIVISION_ID
                            AND    I.ITEM_ID     = R.V_ITEM_ID
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Item for Division ! (사업부 Item 마스터 미등록 - 저장 차단)';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;
            --[V20260708-DMF0020] 마스터 정합 검증 END

            -- 20180814 KHSONG Invalid Site Item validation 추가
            V_VALID_ITEM_ID := NULL;

            -- 자동차, 소형인경우
            BEGIN
                SELECT 1 INTO V_INVALID_CHK FROM DUAL
                WHERE  EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST
                    WHERE  V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '40'
                );
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_INVALID_CHK := 0;
            END;

            IF V_INVALID_CHK = 1 THEN
                BEGIN
                    SELECT X.IID INTO V_VALID_ITEM_ID
                    FROM
                    (
                        SELECT A.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST A
                        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITEM
                            ON  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                            AND ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                            AND ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                            AND ITEM.ITEM_ID      = A.V_ITEM_ID
                            AND ITEM.VALID_YN     = 'Y'
                        LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SN
                            ON  ITEM.DIVISION_ID = SN.DIVISION_ID
                            AND ITEM.ITEM_ID     = SN.ITEM_ID
                            AND SN.ACTIVE_FLAG   = 'Y'
                        WHERE  A.V_PRICE <> 0
                        AND   (ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL)
                    ) X
                    WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_VALID_ITEM_ID := NULL;
                END;

                IF V_VALID_ITEM_ID IS NOT NULL THEN
                    V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Invalid Site Item ID !';
                    V_LOG_TYPE    := 'INVALID';
                    V_LOG_MESSAGE := '########## END of procedure @@@##########';
                    D_EVENT_DATE  := SYSDATE;
                    BEGIN
                        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    END;

                    OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                    RETURN;
                END IF;
            END IF;
        END IF;
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end -----------------------------------------------
    END;
    --===================================================================================== GT_FCSV_RESULTS_MST 테이블에 split후 insert end

    --------------------------------------------------------------------------------------------------------------------------------
    --                                                                 20200422 KHSONG C20200102-000131 Validation 로직 추가 (BEGIN)
    --------------------------------------------------------------------------------------------------------------------------------
    V_INVALID_SITE := NULL;

    -------------------------------------------------------------------------------------------------------------------------------------
    --[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START
    --ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다.
    -------------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   N_DFLAG_CHK
    FROM   SCM_MGR.GT_FCSV_RESULTS_MST
    WHERE  V_ACTIVE_FLAG = 'D';

    IF N_DFLAG_CHK > 0 THEN
        --52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        BEGIN
            SELECT '★ Sales Site : ' || SCM_SITE_ID || ' / ★ Model : ' || ITEM_ID
            INTO   V_INVALID_SITE
            FROM
            (
                SELECT F.SCM_SITE_ID, F.ITEM_ID
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.SCM_SYS_CALENDAR_M B
                  ON   F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE  EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_FCSV_RESULTS_MST A
                    JOIN   SCM_MGR.SCM_SYS_CALENDAR_M D
                      ON   A.V_YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE  A.V_ACTIVE_FLAG = 'D'
                    AND    F.DIVISION_ID   = A.V_DIVISION_ID
                    AND    F.PROJECT_CODE  = A.V_PROJECT_CODE
                    AND    F.SCM_SITE_ID   = A.V_SCM_SITE_ID
                    AND    F.PLANT_SITE_ID = A.V_PLANT_SITE_ID
                    AND    F.ITEM_ID       = A.V_ITEM_ID
                    AND    F.DOM_EXP       = A.V_DOM_EXP
                    AND    F.FCST_TYPE     = A.V_FCST_TYPE
                    AND    F.INCOTERMS     = A.V_INCOTERMS
                    AND    F.MEASURE      IN ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
                    -----------------------------------------------------------------------------------------------------------------------------------
                    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
                    --AND F.YYYYMMDD  >  CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 7 + 7 * 52, 'YYYYMMDD')
                    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (END)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    B.ISO_YYYYWW = D.ISO_YYYYWW
                    AND    F.QTY <> 0  -- 제로값은 제외함
                    AND    F.FCST_TYPE NOT IN (
                        SELECT MST.SEGMENT1  -- FCST_TYPE
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                        WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    MST.SEGMENT4    = 'FREE'  -- 무상 제공인경우
                        GROUP BY MST.SEGMENT1
                    )  -- 무상제공인경우는 Validation 에서 제외
                )
                AND ROWNUM = 1
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_INVALID_SITE := NULL;
        END;

        IF V_INVALID_SITE IS NOT NULL THEN
            V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || V_INVALID_SITE;
            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;

        V_INVALID_SITE := NULL;
        BEGIN
            SELECT '★ Sales Site : ' || SCM_SITE_ID || ' / ★ Model : ' || ITEM_ID
            INTO   V_INVALID_SITE
            FROM
            (
                SELECT F.SCM_SITE_ID, F.ITEM_ID
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                WHERE  EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_FCSV_RESULTS_MST
                    WHERE  V_ACTIVE_FLAG  = 'D'
                    AND    F.DIVISION_ID  = V_DIVISION_ID
                    AND    F.PROJECT_CODE = V_PROJECT_CODE
                    AND    F.SCM_SITE_ID  = V_SCM_SITE_ID
                    AND    F.PLANT_SITE_ID= V_PLANT_SITE_ID
                    AND    F.ITEM_ID      = V_ITEM_ID
                    AND    F.DOM_EXP      = V_DOM_EXP
                    AND    F.FCST_TYPE    = V_FCST_TYPE
                    AND    F.INCOTERMS    = V_INCOTERMS
                    -- [C20211126-000348] AS_In_Req 메저 추가
                    AND    F.MEASURE     IN ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
                    -----------------------------------------------------------------------------------------------------------------------------------
                    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
                    /*
                    AND F.YYYYMMDD           BETWEEN  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후건만 확인
                                             AND      CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- SCP PLANNING 구간이 52주 */
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD')               -- 당주 월요일부터
                    AND    F.YYYYMMDD <  TO_CHAR(TRUNC(SYSDATE, 'IW') - 7 + 7 * 52, 'YYYYMMDD')      -- 52주후 월요일까지
                    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.QTY <> 0  -- 제로값은 제외함
                    AND    F.FCST_TYPE NOT IN (
                        SELECT MST.SEGMENT1  -- FCST_TYPE
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                        WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    MST.SEGMENT4    = 'FREE'  -- 무상 제공인경우
                        GROUP BY MST.SEGMENT1
                    )  -- 무상제공인경우는 Validation 에서 제외
                )
                AND ROWNUM = 1
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_INVALID_SITE := NULL;
        END;

        IF V_INVALID_SITE IS NOT NULL THEN
            V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || V_INVALID_SITE;
            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------
    --                                                                   20200422 KHSONG C20200102-000131 Validation 로직 추가 (END)
    --------------------------------------------------------------------------------------------------------------------------------

    --Start [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인
    V_INVALID_DUP := NULL;
    BEGIN
        SELECT V_ITEM_ID
        INTO   V_INVALID_DUP
        FROM
        (
            SELECT V_ITEM_ID
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST
            WHERE  NVL(V_PRICE, 0) <> 0
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE
            HAVING COUNT(V_CURRENCY) > 1
        )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_INVALID_DUP := NULL;
    END;

    IF V_INVALID_DUP IS NOT NULL THEN
        V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;
    --End [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인

    --[E20241125-000026]_Sales Price Validation 추가 START
    V_INVALID_DUP_DATA := NULL;
    BEGIN
        SELECT ITEM_ID
        INTO   V_INVALID_DUP_DATA
        FROM
        (
            SELECT S.ITEM_ID
            FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
            WHERE  EXISTS (
                SELECT 1
                FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                WHERE  S.DIVISION_ID   = R.V_DIVISION_ID
                AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
                AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
                AND    S.PLANT_SITE_ID = R.V_PLANT_SITE_ID
                AND    S.ITEM_ID       = R.V_ITEM_ID
                AND    S.YYYYMMDD      = R.V_YYYYMMDD
                --AND    S.CURRENCY    = R.V_CURRENCY
                AND    S.MEASURE       = R.V_MEASURE
                AND    S.DOM_EXP       = R.V_DOM_EXP
                AND    S.FCST_TYPE     = R.V_FCST_TYPE
                AND    S.INCOTERMS     = R.V_INCOTERMS
                AND    R.V_ACTIVE_FLAG = 'I'
            )
        )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_INVALID_DUP_DATA := NULL;
    END;

    IF V_INVALID_DUP_DATA IS NOT NULL THEN
        V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;
    --[E20241125-000026]_Sales Price Validation 추가 END

    /*
    --START 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
    -- (원소스에서 주석처리되어 있어 그대로 유지)
    --END 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
    --===================================================================================== #results_MST delete start
    -- (원소스 주석블록 - 변환 생략)
    --===================================================================================== #results_MST delete end
    */

    --===================================================================================== delete start
    BEGIN
        -- DELETE COUNT 확인
        SELECT COUNT(DIVISION_ID)
        INTO   N_DELETE_COUNT
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG = 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.PLANT_SITE_ID = R.V_PLANT_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    S.DOM_EXP       = R.V_DOM_EXP
            AND    S.FCST_TYPE     = R.V_FCST_TYPE
            AND    S.INCOTERMS     = R.V_INCOTERMS
        );

        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG = 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.PLANT_SITE_ID = R.V_PLANT_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    S.DOM_EXP       = R.V_DOM_EXP
            AND    S.FCST_TYPE     = R.V_FCST_TYPE
            AND    S.INCOTERMS     = R.V_INCOTERMS
        );
    END;
    --===================================================================================== delete end


    --===================================================================================== update, insert start
    -- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (START)
    BEGIN
        -- INSERT COUNT 확인
        SELECT COUNT(V_DIVISION_ID)
        INTO   N_INSERT_COUNT
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';

        -- INSERT전 동일대상 delete 수행
        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG <> 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.PLANT_SITE_ID = R.V_PLANT_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    S.DOM_EXP       = R.V_DOM_EXP
            AND    S.FCST_TYPE     = R.V_FCST_TYPE
            AND    S.INCOTERMS     = R.V_INCOTERMS
        );

        -- INSERT 수행
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE
        (
             DIVISION_ID
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,YYYYMMDD
            ,CURRENCY
            ,MEASURE
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS
            ,PRICE
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
        )
        SELECT
             V_DIVISION_ID
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_PLANT_SITE_ID
            ,V_ITEM_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_MEASURE
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,CAST(V_PRICE AS NUMBER(20,10))
            ,V_CREATED_BY
            ,SYSDATE
            ,V_LAST_UPDATED_BY
            ,SYSDATE
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';
        -- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (END)

        /*
                            --[2018-03-20][수정][기존소스]
                            -- HISTORY 생성
                               BEGIN
                                  EXEC [dbo].[PR_DM_ANL_SALES_PRICE_HIST]
                                                        ,@v_project_code
                                                        ,@v_scm_site_id
                                                        ,@v_plant_site_id
                                                        ,@v_item_id
                                                        ,@v_yyyymmdd
                                                        ,@v_currency
                                                        ,@v_measure
                                                        ,@v_dom_exp
                                                        ,@v_fcst_type
                                                        ,@v_incoterms
                                                        ,@v_price
                                                        ,@v_created_by
                                                        ,@v_last_updated_by
                               END
        */

        -- [2018-03-20][수정][수정소스]
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H
        (
             DIVISION_ID
            ,HISTORY_SEQ
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,YYYYMMDD
            ,CURRENCY
            ,MEASURE
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS
            ,PRICE
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
        )
        SELECT
             V_DIVISION_ID
            ,SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_PLANT_SITE_ID
            ,V_ITEM_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_MEASURE
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_PRICE
            ,V_CREATED_BY
            ,SYSDATE
            ,V_LAST_UPDATED_BY
            ,SYSDATE
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';   -- DELETE값이 아닌경우만

        --------------------------------------------------------------------------------------  20180510 SKH ADD START
        INSERT INTO SCM_MGR.GT_FCSV_RESULTS
        (
             V_DIVISION_ID
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_ITEM_ID
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_MEASURE
            ,V_PLANT_SITE_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_PRICE
            ,V_CREATED_BY
        )
        SELECT
             V_DIVISION_ID
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_ITEM_ID
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_MEASURE
            ,V_PLANT_SITE_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_PRICE
            ,V_CREATED_BY
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';   -- DELETE값이 아닌경우만

        -- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
        SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE;
        --------------------------------------------------------------------------------------  20180510 SKH ADD END
    END;
    --===================================================================================== update, insert end

    --[PJ20200138] 입력된 Price가 주변 주차와 Range Rate 가 초과되어 차이나는 데이터 Return
    OPEN O_RC1 FOR
    WITH W_MIN_MAX_DATE (ROWNUMVAL, YYYYMMDD, MIN_YYYYMMDD, MAX_YYYYMMDD) AS
    (
        SELECT
             R.V_ROWNUM AS ROWNUMVAL
            ,R.V_YYYYMMDD
            ,(SELECT NVL(MAX(S_MIN.YYYYMMDD), '')
              FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S_MIN
              WHERE  S_MIN.DIVISION_ID  = R.V_DIVISION_ID
              AND    S_MIN.PROJECT_CODE = R.V_PROJECT_CODE
              AND    S_MIN.SCM_SITE_ID  = R.V_SCM_SITE_ID
              AND    S_MIN.PLANT_SITE_ID= R.V_PLANT_SITE_ID
              AND    S_MIN.ITEM_ID      = R.V_ITEM_ID
              AND    S_MIN.CURRENCY     = R.V_CURRENCY
              AND    S_MIN.MEASURE      = R.V_MEASURE
              AND    S_MIN.DOM_EXP      = R.V_DOM_EXP
              AND    S_MIN.FCST_TYPE    = R.V_FCST_TYPE
              AND    S_MIN.INCOTERMS    = R.V_INCOTERMS
              AND    S_MIN.MEASURE      = 'LOC'
              AND    S_MIN.YYYYMMDD     < R.V_YYYYMMDD) AS MIN_YYYYMMDD
            ,(SELECT NVL(MIN(S_MAX.YYYYMMDD), '')
              FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S_MAX
              WHERE  S_MAX.DIVISION_ID  = R.V_DIVISION_ID
              AND    S_MAX.PROJECT_CODE = R.V_PROJECT_CODE
              AND    S_MAX.SCM_SITE_ID  = R.V_SCM_SITE_ID
              AND    S_MAX.PLANT_SITE_ID= R.V_PLANT_SITE_ID
              AND    S_MAX.ITEM_ID      = R.V_ITEM_ID
              AND    S_MAX.CURRENCY     = R.V_CURRENCY
              AND    S_MAX.MEASURE      = R.V_MEASURE
              AND    S_MAX.DOM_EXP      = R.V_DOM_EXP
              AND    S_MAX.FCST_TYPE    = R.V_FCST_TYPE
              AND    S_MAX.INCOTERMS    = R.V_INCOTERMS
              AND    S_MAX.MEASURE      = 'LOC'
              AND    S_MAX.YYYYMMDD     > R.V_YYYYMMDD) AS MAX_YYYYMMDD
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
        WHERE  1 = 1
        AND    R.V_MEASURE = 'LOC'
        AND    R.V_ACTIVE_FLAG <> 'D'   -- 2022.07.22
    )
    , W_RETURN AS
    (
        SELECT
             R.V_ROWNUM
            ,(CASE WHEN S.DIVISION_ID = '40' THEN S.PROJECT_CODE ELSE C.END_CUSTOMER END) AS END_CUSTOMER
            ,S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.INCOTERMS, S.FCST_TYPE, S.CURRENCY
            ,S.DIVISION_ID, S.PLANT_SITE_ID, S.MEASURE, S.DOM_EXP
            ,R.V_YYYYMMDD AS CH_YYYYMMDD, CAST(R.V_PRICE AS NUMBER(13,3)) AS CH_PRICE
            ,S.YYYYMMDD   AS ST_YYYYMMDD, CAST(S.PRICE   AS NUMBER(13,3)) AS ST_PRICE
            ,ROW_NUMBER() OVER (PARTITION BY R.V_ROWNUM, R.V_YYYYMMDD ORDER BY R.V_ROWNUM, R.V_YYYYMMDD) AS REP_ROWNUM
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
        INNER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE S
            ON  S.DIVISION_ID  = R.V_DIVISION_ID
            AND S.PROJECT_CODE = R.V_PROJECT_CODE
            AND S.SCM_SITE_ID  = R.V_SCM_SITE_ID
            AND S.PLANT_SITE_ID= R.V_PLANT_SITE_ID
            AND S.ITEM_ID      = R.V_ITEM_ID
            AND S.CURRENCY     = R.V_CURRENCY
            AND S.MEASURE      = R.V_MEASURE
            AND S.DOM_EXP      = R.V_DOM_EXP
            AND S.FCST_TYPE    = R.V_FCST_TYPE
            AND S.INCOTERMS    = R.V_INCOTERMS
        INNER JOIN W_MIN_MAX_DATE W
            ON  R.V_ROWNUM     = W.ROWNUMVAL
            AND R.V_YYYYMMDD   = W.YYYYMMDD
        LEFT JOIN SCM_MGR.SCM_MST_SITE C
            ON  S.DIVISION_ID = C.DIVISION_ID
            AND S.SCM_SITE_ID = C.SCM_SITE_ID
            AND C.SITE_TYPE   = 'SALES'
        JOIN
        (
            SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS RANGE_VAL
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  VALID_YN    = 'Y'
            AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
        ) L
            ON  S.DIVISION_ID = L.DIVISION_ID
        WHERE  S.MEASURE  = 'LOC'
        AND    C.VALID_YN = 'Y'
        AND    (S.PRICE * L.RANGE_VAL) < ABS(S.PRICE - R.V_PRICE)
        AND    S.YYYYMMDD IN (W.MIN_YYYYMMDD, W.MAX_YYYYMMDD)
    )
    SELECT *
    FROM   W_RETURN
    WHERE  REP_ROWNUM = 1
    ORDER BY 1, 2, 3, 8, 9;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / insert_count: ' || TO_CHAR(N_INSERT_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    -- DML 결과 반환 커서 (DML 직후 SQL%ROWCOUNT는 마지막 INSERT 건수이므로 N_INSERT_COUNT 사용)
    N_LOG_COUNT := N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_PROJECT_CODE'    VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'     VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID'   VALUE P_PLANT_SITE_ID,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_MEASURE'         VALUE P_MEASURE,
            'P_DOM_EXP'         VALUE P_DOM_EXP,
            'P_FCST_TYPE'       VALUE P_FCST_TYPE,
            'P_INCOTERMS'       VALUE P_INCOTERMS,
            'P_PRICE'           VALUE P_PRICE,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_CREATION_DATE'   VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY,
            'P_ROWNUM'          VALUE P_ROWNUM
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || V_BACKTRACE
        );
END DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL;
/
