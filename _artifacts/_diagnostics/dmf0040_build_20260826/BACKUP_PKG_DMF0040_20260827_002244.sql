CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0040" IS
/****************************************************************************************************/
/* PROGRAM ID  : PKG_DMF0040                                                                        */
/* DESCRIPTION : PKG_DMF0040                                                                        */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.04.06  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          UI 항목으로 PACKAGE로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0040_GET_MKT_FCST_COMPARISON
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_SCM_SITE_ID   IN  VARCHAR2,
    P_PLANT_SITE_ID IN  VARCHAR2,
    P_TEAM_ID       IN  VARCHAR2,
    P_CUSTOMER      IN  VARCHAR2,
    P_BIZ_TYPE      IN  VARCHAR2,
    P_PROJECT_CODE  IN  VARCHAR2,
    P_ITEM_ID       IN  VARCHAR2,
    P_FROM_YYYYMMDD IN  VARCHAR2,
    P_TO_YYYYMMDD   IN  VARCHAR2,
    P_CREATED_BY    IN  VARCHAR2,
    P_VERSION_NO    IN  VARCHAR2,
    P_ITEM_TYPE     IN  VARCHAR2,
    P_OWNER         IN  VARCHAR2,
    P_DIFF_ONLY     IN  VARCHAR2,   -- 'True' or 'False'
    P_BUCKET        IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,   -- 메인 데이터
    O_RESULT_CURSOR OUT SYS_REFCURSOR    -- 항상 마지막 파라미터
)
/*=====================================================================================================================================================
 * Program ID   : DMF0040_GET_MKT_FCST_COMPARISON
 * Description  : MKT FCST Comparison 조회 (2개의 version으로 고객 수요 비교 화면용)
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2018/02/07   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180618     KHSONG         QTY <> 0 으로 수정
 * 20180706                    속도개선버젼
 * 2018/07/31   Son Young Suk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018/08/01   Son Young Suk 검색조건 version 검색할때 current 빠지게 처리
 * 20180808     KHSONG        MODIFY  실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 20180809     ytchoi        조건수정으로 속도개선
 * 20180809     JYE           멀티 오너 수정
 * 20180810     ytchoi        조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 20180816     KHSONG        VALID_YN 조건추가
 * 20180817     KHSONG        TEAM조건 인입시 속도가 느려서 수정함
 * 20180911     Son Young Suk 조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 20181101     khsong        특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 181102                     속도개선을 의해서 추가
 * 20181116     JYE           PRIORITY 추가
 * 20181207     KHSONG        고객 수요 비교 화면용으로 변환
 * 20190118     KHSONG        중복제거위한 DISTINCT추가
 * 20190911     KHSONG        ITEM_ID 검색조건 보완
 * 20200624     hwi1993       성능개선을 위해 with 문을 중간에 끊고, # 테이블로 변경함.
 * 20211125     hwi1993       [C20211109-000439] [SCM PI팀] MKT FCST Comparison 내 W/S팀 수요 구현요청
 * 2021.11.25   hwi1993       프로시저 이름 변경함.
 * 2022.04.18   rosia27       [과제PJ20216891R]GM_JV
 * 2022.04.27   hwi1993       [] 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.06.23   kdw2819       [C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022.07.26   kdw2819       [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022.09.15   KDW2819       [C20220831-000365]MKT FCST Comparison 조회 로직 개선 요청 건
 * 2022.09.29   kdw2819       [C20220929-000253]MKT FCST Comparison Project 코드 조회 오류 건
 * 2023.10.25   HMIN          [E20231017-000634] [영업/마케팅 PI팀] MKT FCST Report 화면 칼럼추가 (SCP테이블정보) (요청자: 오윤종님)
 * 2024.02.15   hmin          [E20240201-001467] MKT FCST Comparison 화면 정렬 Order 개선
 * 2024.03.07   kcw3408       DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.08.28   KJJ           [PJ2024-50461] Team Mapping
 * 2024.09.12   JSSBAE        [E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.10.04   JSSBAE        [E20241002-000765]_MKT FCST Comparision 화면 Nickname 로직 검토요청
 * 2024.11.05   KJJ           [PJ2024-50461] Team Mapping -검색조건 처리 누락 수정
 * 2024.11.21   KJJ           [PJ2024-50611] Team Mapping -반영 후 오류 수정
 * 2025.07.07   KANG.H.J      [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *===================================================================================================================================================*/
IS
    V_PROGRAM_NAME          VARCHAR2(200 CHAR);
    V_LOG_TYPE              VARCHAR2(20  CHAR);
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE;
    V_SQL_CODE              VARCHAR2(20   CHAR);
    V_SQL_ERRMSG            VARCHAR2(4000 CHAR);
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);

    V_SQL_TEXT              CLOB;
    V_ITERATION             CLOB;
    V_SQL_CURSOR            PLS_INTEGER := NULL;
    V_EXECUTE_RET           PLS_INTEGER := 0;
    V_COLUMN                VARCHAR2(4000 CHAR);
    V_GROUPBY               VARCHAR2(4000 CHAR);
    V_ORDERBY               VARCHAR2(4000 CHAR);
    V_COLUMN_TEXT           VARCHAR2(4000 CHAR);
    V_COLUMN_NAME           VARCHAR2(200  CHAR);
    V_COLUMN_DATE           VARCHAR2(200  CHAR);
    V_COLUMN_TYPE           VARCHAR2(200  CHAR);
    V_COLUMN_VALUE          VARCHAR2(200  CHAR);
    V_SORT_ORDER_NO         VARCHAR2(200  CHAR);
    V_PROGRAM_ID            VARCHAR2(20   CHAR) := 'DMF0040';
    V_SHEET_NAME            VARCHAR2(200  CHAR) := 'Mkt Fcst Waterfall';   --[E20260827-SHEETNAME] 변환 결함 정정 — SHEET_COLUMNS/MEASURE/TITLESET 실명(공백 포함, 실측 48/49행)과 불일치로 titleset 초기화·C_TITLE 0행 → GROUP BY/ORDER BY 붕괴(ORA-00936, DBMS_OUTPUT 캡처 실증 2026-08-27)
    V_WEEK_MONDAY           VARCHAR2(8    CHAR);
    V_FROM_YYYYMMDD         VARCHAR2(2000 CHAR);
    V_TO_YYYYMMDD           VARCHAR2(2000 CHAR);
    V_FROM_YYYYMMDD_F       VARCHAR2(2000 CHAR);
    V_TO_YYYYMMDD_F         VARCHAR2(2000 CHAR);
    V_FROM_RESULT_DATE      VARCHAR2(8    CHAR);
    V_TO_RESULT_DATE        VARCHAR2(8    CHAR);
    V_FROM_RESULT           VARCHAR2(2000 CHAR);
    V_TO_RESULT             VARCHAR2(2000 CHAR);
    V_FROM_RESULT_F         VARCHAR2(2000 CHAR);
    V_TO_RESULT_F           VARCHAR2(2000 CHAR);
    V_USER_COL_CNT          PLS_INTEGER := 0;
    V_USER_MEA_CNT          PLS_INTEGER := 0;
    V_USER_TIME_ZONE        VARCHAR2(100  CHAR);
    V_GROUP_ID              VARCHAR2(4000 CHAR) := '';
    V_DATA_SORT_METHOD_CODE VARCHAR2(100  CHAR);
    V_ORDER                 VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_EXISTS_CNT            PLS_INTEGER := 0;

    -- Cursor: c_bucket
    CURSOR C_BUCKET IS
        -- D (일별)
        SELECT 'D_' || A.BASIS_YYYYMMDD          AS COLUMN_NAME
             , A.BASIS_YYYYMMDD                  AS COLUMN_DATE
             , 'F.YYYYMMDD'                      AS COLUMN_TYPE
             , 'F.QTY'                           AS COLUMN_VALUE
             , A.BASIS_YYYYMMDD || '_' || LPAD('31', 2, '0') AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET <> 'ONLY_WEEKLY'
        UNION ALL
        -- W (주별)
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
             , A.BASIS_YYYYMM || A.ISO_WEEK            AS COLUMN_DATE
             , 'F.YYYYMMWW'                            AS COLUMN_TYPE
             , 'F.QTY'                                 AS COLUMN_VALUE
             , MIN(A.BASIS_START_DATE) || '_' || LPAD('21', 2, '0') AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET <> 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK
        UNION ALL
        -- M (월별)
        SELECT 'M_' || A.BASIS_YYYYMM             AS COLUMN_NAME
             , A.BASIS_YYYYMM                     AS COLUMN_DATE
             , 'F.YYYYMM'                         AS COLUMN_TYPE
             , 'F.QTY'                            AS COLUMN_VALUE
             , MIN(A.BASIS_START_DATE) || '_' || LPAD('1', 2, '0') AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET <> 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM
        UNION ALL
        -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
        SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
             , SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK          AS COLUMN_DATE
             , 'F.YYYYMMWW'                                           AS COLUMN_TYPE
             , 'F.QTY'                                                AS COLUMN_VALUE
             , MAX(BASIS_YYYYMMDD) || '_' || LPAD('21', 2, '0')      AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET = 'ONLY_WEEKLY'
        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
    ;

    -- Cursor: c_title
    CURSOR C_TITLE IS
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , U.DATA_SORT_METHOD_CODE
        FROM   SCM_MGR.SCM_MST_TITLESET_USER  U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS  C
        WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = V_PROGRAM_ID
        AND    U.SHEET_NAME  = V_SHEET_NAME
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    C.VISIBLE_FLAG = 'Y'  --[E20240201-001467] 해당조건이 있어야 정상적으로 measure sorting 됨.
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.DATA_SORT_METHOD_CODE
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = V_PROGRAM_ID
        AND    C.SHEET_NAME   = V_SHEET_NAME
        AND    C.VISIBLE_FLAG = 'N'
        AND    C.DEFAULT_FLAG = 'Y'
    ;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- =========================================================================
    -- GTT 초기화 (TRUNCATE: 프로시저 시작 시점 이전에 일반 테이블 DML 없음)
    -- =========================================================================
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_ITEM_SINGLE_ORI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_ITEM_SINGLE_A';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_ITEM_SINGLE_B';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_ITEM_SINGLE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_ITEM_INPUT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM40_PROJECT_INPUT';

    -- =========================================================================
    -- c_bucket CURSOR 처리: 피벗 컬럼 문자열(@v_iteration) 구성
    -- =========================================================================
    DBMS_LOB.CREATETEMPORARY(V_ITERATION, TRUE);
    V_ITERATION := ' ';

    FOR R_BUCKET IN C_BUCKET LOOP
        V_COLUMN_NAME  := R_BUCKET.COLUMN_NAME;
        V_COLUMN_DATE  := R_BUCKET.COLUMN_DATE;
        V_COLUMN_TYPE  := R_BUCKET.COLUMN_TYPE;
        V_COLUMN_VALUE := R_BUCKET.COLUMN_VALUE;
        V_SORT_ORDER_NO:= R_BUCKET.SORT_ORDER_NO;

        IF SUBSTR(V_COLUMN_NAME, 2, 1) = 'B' THEN
            V_COLUMN_TEXT := ', MAX(CASE WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' THEN ' || V_COLUMN_VALUE || ' ELSE NULL END) AS "' || V_COLUMN_NAME || '" ';
        ELSE
            --20180517, 수정
            IF SUBSTR(V_COLUMN_NAME, 1, 1) = 'M' THEN
                V_COLUMN_TEXT :=
                    ', SUM(CASE '
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY '
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG = ''Y'' THEN F.QTY'
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG <> ''Y'' THEN NULL'
                    || CHR(10) || ' ELSE NULL '
                    || CHR(10) || ' END) AS "' || V_COLUMN_NAME || '"';
            END IF;
            IF SUBSTR(V_COLUMN_NAME, 1, 1) = 'W' THEN
                V_COLUMN_TEXT :=
                    ', SUM(CASE '
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY '
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG = ''Y'' THEN F.QTY '
                    || CHR(10) || ' WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' AND F.MEASURE IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG <> ''Y'' THEN NULL'
                    || CHR(10) || ' ELSE NULL '
                    || CHR(10) || ' END) AS "' || V_COLUMN_NAME || '"';
            END IF;
            IF SUBSTR(V_COLUMN_NAME, 1, 1) = 'D' THEN
                V_COLUMN_TEXT := ', SUM(CASE WHEN ' || V_COLUMN_TYPE || ' = ''' || V_COLUMN_DATE || ''' THEN ' || V_COLUMN_VALUE || ' ELSE NULL END) AS "' || V_COLUMN_NAME || '" ';
            END IF;
        END IF;

        --V_ITERATION := V_ITERATION || V_COLUMN_TEXT;
        DBMS_LOB.WRITEAPPEND(V_ITERATION, LENGTH(V_COLUMN_TEXT), V_COLUMN_TEXT);
    END LOOP;

    -- =========================================================================
    -- 사용자 컬럼 설정 조회/초기화 (SCM_MST_TITLESET_USER)
    -- =========================================================================
    V_COLUMN_NAME := ' ';
    V_COLUMN      := ' ';
    V_GROUPBY     := ' ';
    V_USER_COL_CNT := 0;
    V_USER_MEA_CNT := 0;

    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                  = V_PROGRAM_ID
    AND    U.SHEET_NAME                  = V_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID                     = P_CREATED_BY;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , '-'
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = V_PROGRAM_ID
        AND    C.SHEET_NAME   = V_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    C.VISIBLE_FLAG = 'Y'  --[E20240201-001467]
        UNION ALL
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , '-'
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = V_PROGRAM_ID
        AND    C.SHEET_NAME   = V_SHEET_NAME
        AND    C.VISIBLE_FLAG = 'N'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = V_PROGRAM_ID
    AND    U.SHEET_NAME                    = V_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID                       = P_CREATED_BY;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , '-'
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
             , P_CREATED_BY
             , SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  C.PROGRAM_ID   = V_PROGRAM_ID
        AND    C.SHEET_NAME   = V_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    -- =========================================================================
    -- c_title CURSOR 처리: GROUP BY / ORDER BY 동적 컬럼 구성
    -- =========================================================================
    FOR R_TITLE IN C_TITLE LOOP
        V_PROGRAM_ID            := R_TITLE.PROGRAM_ID;
        V_SHEET_NAME            := R_TITLE.SHEET_NAME;
        V_COLUMN_NAME           := R_TITLE.COLUMN_NAME;
        V_DATA_SORT_METHOD_CODE := R_TITLE.DATA_SORT_METHOD_CODE;

        IF V_COLUMN = ' ' THEN
            V_COLUMN  := 'F.' || V_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY F.' || V_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY F.' || V_COLUMN_NAME || ' ' || V_DATA_SORT_METHOD_CODE;
        ELSE
            V_COLUMN  := V_COLUMN  || ', F.' || V_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', F.' || V_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || ', F.' || V_COLUMN_NAME || ' ' || V_DATA_SORT_METHOD_CODE;
        END IF;
    END LOOP;

    --Measure Sort Order No로 Sort
    V_GROUPBY := V_GROUPBY || ', F.VERSION_SORT';
    V_ORDERBY := V_ORDERBY || ', F.VERSION_SORT';  --20240222

    -- =========================================================================
    -- 사용자 타임존 조회 ([dbo].[TB_FX_User] → SCM_MGR.SCM_ADM_USER_M)
    -- =========================================================================
    V_USER_TIME_ZONE := '';
    BEGIN
        SELECT U.TMZ_CD
        INTO   V_USER_TIME_ZONE
        FROM   SCM_MGR.SCM_ADM_USER_M U
        WHERE  U.USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_TIME_ZONE := NULL;
    END;

    -- =========================================================================
    -- 현재 주의 월요일 계산 및 조회 날짜 범위 결정
    -- =========================================================================
    V_WEEK_MONDAY := '';
    SELECT MIN(C.BASIS_YYYYMMDD)  /* 현재시점의 월요일 */
    INTO   V_WEEK_MONDAY
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
         , ( SELECT DISTINCT ISO_YYYYWW
             FROM   SCM_MGR.SCM_SYS_CALENDAR_M
             WHERE  BASIS_YYYYMMDD = TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD')
           ) T
    WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;

    V_FROM_RESULT_DATE := '';
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_FROM_RESULT_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT_DATE := '';
    END;

    V_TO_RESULT_DATE := '';
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_TO_RESULT_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT_DATE := '';
    END;

    V_FROM_YYYYMMDD := V_FROM_RESULT_DATE;  /* 조회시작일 */
    V_TO_YYYYMMDD   := V_TO_RESULT_DATE;    /* 조회끝날짜 */

    IF V_WEEK_MONDAY > V_FROM_RESULT_DATE THEN
        -- 실적 계획 보여줌
        V_FROM_YYYYMMDD   := '''' || V_WEEK_MONDAY || '''';
        V_TO_YYYYMMDD     := '''' || P_TO_YYYYMMDD || '''';
        V_FROM_YYYYMMDD_F := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
        V_TO_YYYYMMDD_F   := '''' || P_TO_YYYYMMDD || '''';
        V_FROM_RESULT     := '''' || P_FROM_YYYYMMDD || '''';
        V_TO_RESULT       := '''' || V_WEEK_MONDAY || '''';
        V_FROM_RESULT_F   := '''' || P_FROM_YYYYMMDD || '''';
        V_TO_RESULT_F     := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
    ELSIF V_WEEK_MONDAY <= V_FROM_RESULT_DATE THEN
        -- 실적 없음 계획만 보여줌
        V_FROM_YYYYMMDD   := '''' || V_WEEK_MONDAY || '''';
        V_TO_YYYYMMDD     := '''' || P_TO_YYYYMMDD || '''';
        V_FROM_YYYYMMDD_F := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
        V_TO_YYYYMMDD_F   := '''' || P_TO_YYYYMMDD || '''';
        V_FROM_RESULT     := '''19000101''';
        V_TO_RESULT       := '''19000101''';
        V_FROM_RESULT_F   := '''19000101''';
        V_TO_RESULT_F     := '''19000101''';
    ELSIF V_WEEK_MONDAY > V_TO_RESULT_DATE THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD   := '''19000101''';
        V_TO_YYYYMMDD     := '''19000101''';
        V_FROM_YYYYMMDD_F := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
        V_TO_YYYYMMDD_F   := '''' || V_TO_RESULT_DATE || '''';
        V_FROM_RESULT     := '''' || P_FROM_YYYYMMDD || '''';
        V_TO_RESULT       := '''' || V_TO_RESULT_DATE || '''';
        V_FROM_RESULT_F   := '''' || V_TO_RESULT_DATE || '''';
        V_TO_RESULT_F     := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
    ELSIF V_WEEK_MONDAY = V_TO_RESULT_DATE THEN
        V_FROM_YYYYMMDD   := '''' || V_WEEK_MONDAY || '''';
        V_TO_YYYYMMDD     := '''' || V_WEEK_MONDAY || '''';
        V_FROM_YYYYMMDD_F := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
        V_TO_YYYYMMDD_F   := '''' || V_WEEK_MONDAY || '''';
        V_FROM_RESULT     := '''' || P_FROM_YYYYMMDD || '''';
        V_TO_RESULT       := '''' || P_TO_YYYYMMDD || '''';
        V_FROM_RESULT_F   := '''' || P_FROM_YYYYMMDD || '''';
        V_TO_RESULT_F     := 'TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),''MON'') - 7, ''YYYYMMDD'')';
    END IF;

    DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd ='   || V_FROM_YYYYMMDD);
    DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd ='     || V_TO_YYYYMMDD);
    DBMS_OUTPUT.PUT_LINE('v_from_result ='     || V_FROM_RESULT);
    DBMS_OUTPUT.PUT_LINE('v_to_result ='       || V_TO_RESULT);
    DBMS_OUTPUT.PUT_LINE('V_FROM_YYYYMMDD_F =' || V_FROM_YYYYMMDD_F);
    DBMS_OUTPUT.PUT_LINE('V_TO_YYYYMMDD_F ='   || V_TO_YYYYMMDD_F);
    DBMS_OUTPUT.PUT_LINE('V_FROM_RESULT_F ='   || V_FROM_RESULT_F);
    DBMS_OUTPUT.PUT_LINE('V_TO_RESULT_F ='     || V_TO_RESULT_F);

    -- =========================================================================
    -- 20190911 ADD ITEM조회조건 속도개선 (BEGIN)
    -- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (BEGIN)
    -- 20190911 마지막 자릿수에 콤마값이 들어오면 제거
    -- =========================================================================
    V_ITEM_ID := P_ITEM_ID;
    IF SUBSTR(V_ITEM_ID, LENGTH(V_ITEM_ID), 1) = ',' THEN
        V_ITEM_ID := SUBSTR(V_ITEM_ID, 1, LENGTH(V_ITEM_ID) - 1);
    END IF;
    -- 20190911 마지막 자릿수에 콤마값이 들어오면 제거

    DBMS_OUTPUT.PUT_LINE('D1--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    --> SCM_MST_ITEM_SN 테이블을 GTT로 넣는다.
    INSERT INTO SCM_MGR.GT_DM40_ITEM_SINGLE_ORI
          (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME
         , MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
          )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME
         , MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE  DIVISION_ID = P_DIVISION_ID;

    DBMS_OUTPUT.PUT_LINE('D11--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO SCM_MGR.GT_DM40_ITEM_SINGLE_A
          (DIVISION_ID ,ITEM_ID ,ITEM_NAME ,ITEM_CLASS ,ITEM_CLASS_NAME ,NICK_NAME
         , ITEM_TYPE ,MATERIAL_CLASS_NAME ,ITEM_UOM ,SPEC ,MDM_PROJECT_NAME
         , MIN_CAPACITY ,ACTIVE_FLAG ,ENERGE ,CELL_QUANTITY ,SCP_EXTRA_SPEC
          )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)         AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)        AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)   AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)         AS NICK_NAME
         , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                          WHEN T1.ITEM_TYPE = 'H' THEN 2
                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
                     ELSE 4 END )
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R' END         AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME) AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)          AS ITEM_UOM
         , MAX(T1.SPEC)              AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)  AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)      AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)       AS ACTIVE_FLAG
         , MAX(T1.ENERGE)            AS ENERGE
         , MAX(T1.CELL_QUANTITY)     AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)    AS SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DM40_ITEM_SINGLE_ORI T1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    DBMS_OUTPUT.PUT_LINE('D12--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO SCM_MGR.GT_DM40_ITEM_SINGLE_B
          (DIVISION_ID ,ITEM_ID ,FORECAST_INFO_BIZ_TYPE ,FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL ,FORECAST_INFO_CELL_PACK_COUNT ,FORECAST_INFO_SPEC
         , FORECAST_INFOR_VERSION ,CELL_TYPE
          )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12)                    AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)               AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)          AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)             AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)        AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)                   AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)               AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                            AS CELL_TYPE
    FROM   SCM_MGR.GT_DM40_ITEM_SINGLE_ORI T2
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    DBMS_OUTPUT.PUT_LINE('D13--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    --TEMP 테이블에 넣은 데이터를 JOIN 한다.
    --[E20241002-000765]_MKT FCST Comparision 화면 Nickname 로직 검토요청
    INSERT INTO SCM_MGR.GT_DM40_ITEM_SINGLE
          (DIVISION_ID ,ITEM_ID ,ITEM_NAME ,ITEM_CLASS ,ITEM_CLASS_NAME ,NICK_NAME
         , ITEM_TYPE ,MATERIAL_CLASS_NAME ,ITEM_UOM ,SPEC ,MDM_PROJECT_NAME ,MIN_CAPACITY
         , ACTIVE_FLAG ,ENERGE ,CELL_QUANTITY ,SCP_EXTRA_SPEC ,FORECAST_INFO_BIZ_TYPE
         , FORECAST_INFO_PRODUCT_GROUP ,FORECAST_INFO_CELL_MODEL ,FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC ,FORECAST_INFOR_VERSION ,CELL_TYPE
          )
    SELECT T2.DIVISION_ID
         , T2.ITEM_ID
         , T2.ITEM_NAME
         , T2.ITEM_CLASS
         , T2.ITEM_CLASS_NAME
         , T2.NICK_NAME
         , T2.ITEM_TYPE
         , T2.MATERIAL_CLASS_NAME
         , T2.ITEM_UOM
         , T2.SPEC
         , T2.MDM_PROJECT_NAME
         , T2.MIN_CAPACITY
         , T2.ACTIVE_FLAG
         , T2.ENERGE
         , T2.CELL_QUANTITY
         , T2.SCP_EXTRA_SPEC
         , T3.FORECAST_INFO_BIZ_TYPE
         , T3.FORECAST_INFO_PRODUCT_GROUP
         , T3.FORECAST_INFO_CELL_MODEL
         , T3.FORECAST_INFO_CELL_PACK_COUNT
         , T3.FORECAST_INFO_SPEC
         , T3.FORECAST_INFOR_VERSION
         , T3.CELL_TYPE
    FROM   SCM_MGR.GT_DM40_ITEM_SINGLE_A T2
    INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE_B T3
           ON  T2.DIVISION_ID            = T3.DIVISION_ID
           AND SUBSTR(T2.ITEM_ID, 1, 12) = T3.ITEM_ID
    WHERE  EXISTS (
               SELECT 1
               FROM  (
                   SELECT TRIM(REGEXP_SUBSTR(V_ITEM_ID, '[^,]+', 1, LEVEL)) AS TST
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(V_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               ) B
               WHERE  T2.ITEM_ID   LIKE '%' || B.TST || '%'
               OR     T2.NICK_NAME LIKE '%' || B.TST || '%'
           )
    AND    T2.DIVISION_ID = P_DIVISION_ID
    GROUP BY T2.DIVISION_ID, T2.ITEM_ID, T2.ITEM_NAME, T2.ITEM_CLASS, T2.ITEM_CLASS_NAME, T2.NICK_NAME
           , T2.ITEM_TYPE, T2.MATERIAL_CLASS_NAME, T2.ITEM_UOM, T2.SPEC, T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
           , T3.FORECAST_INFO_BIZ_TYPE, T3.FORECAST_INFO_PRODUCT_GROUP, T3.FORECAST_INFO_CELL_MODEL
           , T3.FORECAST_INFO_CELL_PACK_COUNT, T3.FORECAST_INFO_SPEC, T3.FORECAST_INFOR_VERSION
           , T2.ACTIVE_FLAG, T3.CELL_TYPE, T2.ENERGE, T2.CELL_QUANTITY, T2.SCP_EXTRA_SPEC;

    DBMS_OUTPUT.PUT_LINE('D1A--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- 통계 수집: GT_DM40_ITEM_SINGLE (JOIN 사용, 1000건 이상 가능성 있음)
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM40_ITEM_SINGLE', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM40_ITEM_SINGLE',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    -- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (END)
    -- 20190911 ADD ITEM조회조건 속도개선 (END)

    -- GT_DM40_ITEM_INPUT : ITEM_ID 검색 결과
    INSERT INTO SCM_MGR.GT_DM40_ITEM_INPUT
          (ITEM_ID)
    SELECT DISTINCT T2.ITEM_ID
    FROM   SCM_MGR.GT_DM40_ITEM_SINGLE T2
    WHERE  T2.DIVISION_ID = P_DIVISION_ID
    AND    EXISTS (
               SELECT 1
               FROM  (
                   SELECT TRIM(REGEXP_SUBSTR(V_ITEM_ID, '[^,]+', 1, LEVEL)) AS TST
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(V_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               ) B
               WHERE  T2.ITEM_ID   LIKE '%' || B.TST || '%'
               OR     T2.NICK_NAME LIKE '%' || B.TST || '%'
           );

    DBMS_OUTPUT.PUT_LINE('D1A1--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- =========================================================================
    -- 20190911 ADD PROJECT조회조건 속도개선 (START)
    -- =========================================================================

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.SCM_MST_DIVISION WHERE ATTRIBUTE3 LIKE '81%' AND ATTRIBUTE3 = '82' AND DIVISION_ID = P_DIVISION_ID;
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM40_PROJECT_INPUT
              (PROJECT_CODE)
        SELECT DISTINCT I.PROJECT_CODE
        FROM   SCM_MGR.SCM_MST_SITE_ITEM I
        INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE T2
               ON  I.DIVISION_ID  = T2.DIVISION_ID
               AND I.ITEM_ID      = T2.ITEM_ID
               AND I.VALID_YN     = 'Y'
        INNER JOIN SCM_MGR.SCM_MST_PROJECT T3
               ON  I.DIVISION_ID  = T3.DIVISION_ID
               AND I.PROJECT_CODE = T3.PROJECT_CODE
        WHERE  I.DIVISION_ID = P_DIVISION_ID
        AND    EXISTS (
                   SELECT 1
                   FROM  (
                       SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TST
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                   ) C
                   WHERE  I.PROJECT_CODE  LIKE '%' || C.TST || '%'
                   OR     T3.PROJECT_NAME LIKE '%' || C.TST || '%'   -- 20180809 ytchoi
               );
    ELSE
        INSERT INTO SCM_MGR.GT_DM40_PROJECT_INPUT
              (PROJECT_CODE)
        SELECT DISTINCT I.PROJECT_CODE
        FROM   SCM_MGR.SCM_MST_SITE_ITEM I
        INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE T2
               ON  I.DIVISION_ID  = T2.DIVISION_ID
               AND I.ITEM_ID      = T2.ITEM_ID
               AND I.VALID_YN     = 'Y'
        WHERE  I.DIVISION_ID = P_DIVISION_ID
        AND    EXISTS (
                   SELECT 1
                   FROM  (
                       SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TST
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                   ) C
                   WHERE  I.PROJECT_CODE LIKE '%' || C.TST || '%'
               );
    END IF;
    -- 20190911 ADD PROJECT조회조건 속도개선 (END)

    DBMS_OUTPUT.PUT_LINE('D1A2--' || SYSDATE /*[E20260827-DATEINS] hook #109 — DATE 컬럼 문자열 INSERT(NLS 의존 ORA-01861) 정정*/||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- =========================================================================
    -- 동적 SQL 구성
    -- =========================================================================
    V_SQL_TEXT :=
    q'[
        /* [E20231017-000634] */
        WITH SCP_ITEM_INFO AS (
            SELECT  SCP_P.DIVISION_ID
                  , SCP_P.ITEM_ID
                  , SCP_P.CELL_NICKNAME
                  , SCP_P.BASIC_NICKNAME_CELL40
                  , SCP_P.NICKNAME_40
                  , SCP_P.GROUP_CODE1
                  , SCP_P.GROUP_CODE4
                  , SCP_P.GROUP_CODE5
                  , SCP_P.GROUP_CODE6
                  , SCP_P.GROUP_CODE7
                  , CASE WHEN SCP_P.LEVEL_EXCEPT = 'EC' THEN 'POUCH'
                         WHEN SCP_P.LEVEL_EXCEPT = 'AM' THEN 'CYLINDRICAL'
                         WHEN SUBSTR(SCP_P.ITEM_ID, 3, 1) = 'M' AND SCP_P.OPERATION_ID = 'P9500' THEN 'POUCH'
                    ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
            FROM (
                SELECT DIVISION_ID
                     , FLOW_ID                    AS OPERATION_ID
                     , ITEM_ID
                     , SUBSTR(A.ITEM_ID, 3, 1)   AS CELL_TYPE_CODE
                     , SUBSTR(A.ITEM_ID, 1, 2)   AS LEVEL_EXCEPT -- 예외적용
                     , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN GROUP_CODE1
                            WHEN A.DIVISION_ID = '82'               THEN LEVEL2_CODE
                       ELSE '' END AS CELL_NICKNAME
                     , CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
                            WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
                       ELSE
                           CASE WHEN A.OPERATION_GROUP = 'P'
                               THEN (SELECT NICK_NAME FROM SCM_MGR.SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP_DOE FROM (SELECT B2.DOE AS TOP_DOE FROM SCM_MGR.SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = A.DIVISION_ID AND B2.ITEM_ID = A.ATTRIBUTE1 AND B2.DOE IS NOT NULL AND ROWNUM = 1) X))
                               ELSE (SELECT NICK_NAME FROM SCM_MGR.SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP_DOE FROM (SELECT B2.DOE AS TOP_DOE FROM SCM_MGR.SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = A.DIVISION_ID AND B2.ITEM_ID = A.ITEM_ID   AND B2.DOE IS NOT NULL AND ROWNUM = 1) X))
                           END
                       END AS BASIC_NICKNAME_CELL40
                     , A.NICK_NAME  AS NICKNAME_40
                     , A.GROUP_CODE4
                     , A.GROUP_CODE5
                     , A.GROUP_CODE6
                     , A.GROUP_CODE7
                     , A.GROUP_CODE1
                     , CASE WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' ELSE 'E' END AS FLOW_TYPE
                FROM SCM_MGR.SCP_MST_FINAL_ITEM A
                WHERE 1=1
                AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 = '' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
                AND A.DIVISION_ID = ]' || '''' || P_DIVISION_ID || '''' || q'[
            ) SCP_P
            LEFT OUTER JOIN (
                SELECT  A.CODE                  AS CELL_TYPE_CODE
                      , SUBSTR(A.NAME, 1, 1)    AS FLOW_TYPE
                      , A.GROUP_CODE            AS CELL_TYPE_GROUP_CODE
                      , G.NAME                  AS CELL_TYPE_GROUP_NAME
                      , A.DISPLAY_SEQ
                FROM (
                    SELECT B.SEGMENT1 CODE, B.SEGMENT2 NAME, B.SEGMENT3 GROUP_CODE, B.DISPLAY_SEQ
                    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER A
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
                    WHERE  A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_CODE'
                    AND    A.VALID_YN    = 'Y'
                ) A
                JOIN (
                    SELECT B.SEGMENT1 CODE, B.SEGMENT2 NAME
                    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER A
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
                    WHERE  A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_GROUP'
                    AND    A.VALID_YN    = 'Y'
                ) G ON A.GROUP_CODE = G.CODE
            ) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE = SCP_P.CELL_TYPE_CODE
        ),
        CALENDAR AS (
            SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM, B.DAYOFWEEK
            FROM (
                SELECT SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW
                     , ISO_YYYYWW, ISO_WEEK
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD >= ]' || '''' || P_FROM_YYYYMMDD || '''' || q'[
                AND    BASIS_YYYYMMDD <= ]' || '''' || P_TO_YYYYMMDD || '''' || q'[
                GROUP BY ISO_YYYYWW, ISO_WEEK
            ) A
            JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
              ON A.ISO_YYYYWW = B.ISO_YYYYWW
             AND A.ISO_WEEK   = B.ISO_WEEK
        ),
        TARGET_VERSION_NO AS (
            SELECT TOKEN AS VERSION_NO
                 , CASE WHEN ROW_NUMBER() OVER (ORDER BY VERSION_NO_SORT DESC) = 1 THEN 'Version(A)'
                        WHEN ROW_NUMBER() OVER (ORDER BY VERSION_NO_SORT DESC) = 2 THEN 'Version(B)'
                   ELSE 'VERSION_X'
                   END AS VERSION_TYPE
            FROM (
                SELECT CASE WHEN TOKEN = 'Current' THEN 'Z'
                            ELSE 'X' || SUBSTR(TOKEN, 6, 13)
                       END AS VERSION_NO_SORT
                     , TOKEN
                FROM (
                      SELECT CASE WHEN INSTR(TOKEN,'(') > 0 THEN SUBSTR(TOKEN,1,INSTR(TOKEN,'(')-1) ELSE TOKEN END AS TOKEN
                      FROM  (
                            SELECT TRIM(REGEXP_SUBSTR(']' || P_VERSION_NO || q'[', '[^,]+', 1, LEVEL)) AS TOKEN
                            FROM   DUAL
                            CONNECT BY REGEXP_SUBSTR(']' || P_VERSION_NO || q'[', '[^,]+', 1, LEVEL) IS NOT NULL
                            )
                ) A
                WHERE TOKEN IS NOT NULL
            )
            WHERE TOKEN IS NOT NULL
        ),
        TARGET_SITE_ITEM AS (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, T3.PROJECT_NAME
                 , '' AS CELL_MODEL   -- 20180809 ytchoi
                 , S.VMI_YN
                 , CASE WHEN S.OPERATION_GROUP = 'W' THEN 'Y' ELSE 'N' END AS AS_YN
                 , F.VALID_YN
                 , F.OWNER
                 , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(F.OWNER, ',', 'EN') AS OWNER_NAME
                 , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(F.OWNER, ',', 'KO') AS OWNER_NAME_KO
            FROM   SCM_MGR.SCM_MST_SITE_ITEM F
            INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE T2
                   ON  F.DIVISION_ID = T2.DIVISION_ID
                   AND F.ITEM_ID     = T2.ITEM_ID
            LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT T3
                   ON  F.DIVISION_ID  = T3.DIVISION_ID
                   AND F.PROJECT_CODE = T3.PROJECT_CODE
            INNER JOIN SCM_MGR.GT_DM40_ITEM_INPUT ITEM_INPUT
                   ON  F.ITEM_ID = ITEM_INPUT.ITEM_ID
            INNER JOIN SCM_MGR.GT_DM40_PROJECT_INPUT PROJECT_INPUT
                   ON  F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
            INNER JOIN SCM_MGR.SCM_MST_SITE S
                   ON  F.DIVISION_ID = S.DIVISION_ID
                   AND F.SCM_SITE_ID = S.SCM_SITE_ID
            WHERE  F.DIVISION_ID <> '40' -- hard coding
            ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;


    V_SQL_TEXT := V_SQL_TEXT || q'[
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, F.PROJECT_CODE
                 , F.ATTRIBUTE5 AS CELL_MODEL  -- 20180810 ytchoi 조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
                 , S.VMI_YN
                 , CASE WHEN S.OPERATION_GROUP = 'W' THEN 'Y' ELSE 'N' END AS AS_YN
                 , F.VALID_YN
                 , F.OWNER
                 , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(F.OWNER, ',', 'EN') AS OWNER_NAME
                 , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(F.OWNER, ',', 'KO') AS OWNER_NAME_KO
            FROM   SCM_MGR.SCM_MST_SITE_ITEM F
            INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE T2
                   ON  F.DIVISION_ID = T2.DIVISION_ID
                   AND F.ITEM_ID     = T2.ITEM_ID
                   AND F.VALID_YN   = 'Y'
            INNER JOIN SCM_MGR.GT_DM40_ITEM_INPUT ITEM_INPUT
                   ON  F.ITEM_ID = ITEM_INPUT.ITEM_ID
            INNER JOIN SCM_MGR.SCM_MST_SITE S
                   ON  F.DIVISION_ID = S.DIVISION_ID
                   AND F.SCM_SITE_ID = S.SCM_SITE_ID
            WHERE  F.DIVISION_ID = '40' -- hard coding
        ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
        ),
        ALL_QUERY_DATA_B AS (
            SELECT 'Current' AS VERSION_NO
                 , F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                 , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
                 , F.YYYYMMDD, F.QTY
                 , T2.CELL_MODEL
            FROM   SCM_MGR.DM_PLN_MKT_FCST F
            LEFT OUTER JOIN TARGET_SITE_ITEM T2
                   ON  F.DIVISION_ID  = T2.DIVISION_ID
                   AND F.PROJECT_CODE = T2.PROJECT_CODE
                   AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                   AND F.ITEM_ID      = T2.ITEM_ID
            INNER JOIN SCM_MGR.SCM_MST_SITE C
                   ON  F.DIVISION_ID = C.DIVISION_ID
                   AND F.SCM_SITE_ID = C.SCM_SITE_ID
                   AND C.VALID_YN    = 'Y'
            WHERE  F.QTY <> 0
            AND    T2.VALID_YN = 'Y'
            AND    F.YYYYMMDD BETWEEN ]' || V_FROM_YYYYMMDD || q'[ AND ]' || V_TO_YYYYMMDD || q'[  /* 현재시점의 월요일 부터 조회끝날짜 */
            AND    F.MEASURE = CASE WHEN T2.VMI_YN = 'Y' AND F.DIVISION_ID NOT LIKE '81%' THEN 'VMI_In_Req'
                                    WHEN T2.AS_YN  = 'Y'                                  THEN 'AS_In_Req'
                               ELSE 'MKT_FCST' END
        ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_plant_site_id]
    IF P_PLANT_SITE_ID IS NOT NULL AND NVL(P_PLANT_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.PLANT_SITE_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_project_code] - division_id <> '40'이면 빈값, '40'이면 customer로 LK 검색
    IF P_DIVISION_ID <> '40' THEN
        NULL; -- 빈값
    ELSE
        IF P_CUSTOMER IS NOT NULL AND NVL(P_CUSTOMER,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.PROJECT_CODE LIKE ''%' || P_CUSTOMER || '%''';
        END IF;
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
            UNION ALL    -- 20180809 ytchoi
            SELECT 'Current' AS VERSION_NO
                 , F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                 , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
                 , F.YYYYMMDD
                 , SUM(F.QTY) AS QTY   -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
                 , T2.CELL_MODEL
            FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT F
            LEFT OUTER JOIN TARGET_SITE_ITEM T2
                   ON  F.DIVISION_ID  = T2.DIVISION_ID
                   AND F.PROJECT_CODE = T2.PROJECT_CODE
                   AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                   AND F.ITEM_ID      = T2.ITEM_ID
            WHERE  F.QTY <> 0
            AND    F.YYYYMMDD >= ]' || V_FROM_RESULT || q'[ AND F.YYYYMMDD < ]' || V_TO_RESULT || q'[  -- 20180808 MODIFY
            AND    F.MEASURE = CASE WHEN T2.VMI_YN = 'Y' AND F.DIVISION_ID NOT LIKE '81%' THEN 'VMI_In_Req'
                                    WHEN T2.AS_YN  = 'Y'                                  THEN 'AS_In_Req'
                               ELSE 'RTF' END
        ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_plant_site_id]
    IF P_PLANT_SITE_ID IS NOT NULL AND NVL(P_PLANT_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.PLANT_SITE_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    IF P_DIVISION_ID <> '40' THEN
        NULL;
    ELSE
        IF P_CUSTOMER IS NOT NULL AND NVL(P_CUSTOMER,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.PROJECT_CODE LIKE ''%' || P_CUSTOMER || '%''';
        END IF;
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START
            GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                   , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                   , T2.CELL_MODEL
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO
                 , F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                 , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
                 , F.YYYYMMDD
                 , SUM(F.QTY) AS QTY   -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
                 , T2.CELL_MODEL
            FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C F
            LEFT OUTER JOIN TARGET_SITE_ITEM T2
                   ON  F.DIVISION_ID  = T2.DIVISION_ID
                   AND F.PROJECT_CODE = T2.PROJECT_CODE
                   AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                   AND F.ITEM_ID      = T2.ITEM_ID
            WHERE  F.QTY <> 0
            AND    F.YYYYMMDD >= ]' || V_FROM_RESULT_F || q'[ AND F.YYYYMMDD < ]' || V_TO_RESULT_F || q'[  -- 20180808 MODIFY
            AND    F.MEASURE = CASE WHEN T2.VMI_YN = 'Y' AND F.DIVISION_ID NOT LIKE '81%' THEN 'VMI_In_Req'
                                    WHEN T2.AS_YN  = 'Y'                                  THEN 'AS_In_Req'
                               ELSE 'RTF' END
            AND    F.VERSION_NO IN (SELECT VERSION_NO FROM TARGET_VERSION_NO)
        ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_plant_site_id]
    IF P_PLANT_SITE_ID IS NOT NULL AND NVL(P_PLANT_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.PLANT_SITE_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    IF P_DIVISION_ID <> '40' THEN
        NULL;
    ELSE
        IF P_CUSTOMER IS NOT NULL AND NVL(P_CUSTOMER,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.PROJECT_CODE LIKE ''%' || P_CUSTOMER || '%''';
        END IF;
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START
            GROUP BY F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                   , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD
                   , T2.CELL_MODEL
            -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO
                 , F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                 , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
                 , F.YYYYMMDD, F.QTY
                 , T2.CELL_MODEL
            FROM   SCM_MGR.DM_PLN_MKT_FCST_C F
            LEFT OUTER JOIN TARGET_SITE_ITEM T2
                   ON  F.DIVISION_ID  = T2.DIVISION_ID
                   AND F.PROJECT_CODE = T2.PROJECT_CODE
                   AND F.SCM_SITE_ID  = T2.SCM_SITE_ID
                   AND F.ITEM_ID      = T2.ITEM_ID
            INNER JOIN SCM_MGR.SCM_MST_SITE C
                   ON  F.DIVISION_ID = C.DIVISION_ID
                   AND F.SCM_SITE_ID = C.SCM_SITE_ID
                   AND C.VALID_YN    = 'Y'
            WHERE  F.QTY <> 0
            AND    F.YYYYMMDD >= ]' || V_FROM_YYYYMMDD_F || q'[  /* CUTOFF DATE의 월요일 */
            AND    F.YYYYMMDD <= ]' || V_TO_YYYYMMDD_F || q'[
            AND    F.MEASURE = CASE WHEN T2.VMI_YN = 'Y' AND F.DIVISION_ID NOT LIKE '81%' THEN 'VMI_In_Req'
                                    WHEN T2.AS_YN  = 'Y'                                  THEN 'AS_In_Req'
                               ELSE 'MKT_FCST' END
            AND    F.VERSION_NO IN (SELECT VERSION_NO FROM TARGET_VERSION_NO)
        ]';

    -- [@v_division_id] 처리
    IF P_DIVISION_ID IS NOT NULL AND NVL(P_DIVISION_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.DIVISION_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_scm_site_id] 처리
    IF P_SCM_SITE_ID IS NOT NULL AND NVL(P_SCM_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.SCM_SITE_ID IN ('
           || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL))'
           || CHR(10) || '  FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_SCM_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_plant_site_id]
    IF P_PLANT_SITE_ID IS NOT NULL AND NVL(P_PLANT_SITE_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND F.PLANT_SITE_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_PLANT_SITE_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL)';
    END IF;

    IF P_DIVISION_ID <> '40' THEN
        NULL;
    ELSE
        IF P_CUSTOMER IS NOT NULL AND NVL(P_CUSTOMER,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.PROJECT_CODE LIKE ''%' || P_CUSTOMER || '%''';
        END IF;
    END IF;

    -- @p_owner 필터 (owner 조건 DELETE → Oracle에서는 CTE NOT EXISTS로 구현)
    V_SQL_TEXT := V_SQL_TEXT || q'[
        ),
        ALL_QUERY_DATA_FILTERED AS (
            SELECT A.*
            FROM   ALL_QUERY_DATA_B A
            LEFT OUTER JOIN TARGET_SITE_ITEM B
                   ON  A.ITEM_ID      = B.ITEM_ID
                   AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
        ]';

    IF P_OWNER IS NOT NULL AND P_OWNER <> '' THEN
        V_SQL_TEXT := V_SQL_TEXT || q'[
            WHERE EXISTS (
                SELECT 1
                FROM (
                    SELECT TRIM(REGEXP_SUBSTR(']' || P_OWNER || q'[', '[^,]+', 1, LEVEL)) AS TOKEN
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(']' || P_OWNER || q'[', '[^,]+', 1, LEVEL) IS NOT NULL
                ) C
                WHERE  B.OWNER         LIKE '%' || C.TOKEN || '%'
                OR     B.OWNER_NAME    LIKE '%' || C.TOKEN || '%'
                OR     B.OWNER_NAME_KO LIKE '%' || C.TOKEN || '%'
            )
        ]';
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
        ),
        ALL_QUERY_DATA AS (
        ]';

    /* @p_diff_only = False 인경우만 쿼리실행 */
    IF P_DIFF_ONLY = 'False' THEN
        V_SQL_TEXT := V_SQL_TEXT || q'[
            SELECT A.VERSION_NO, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID
                 , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD
                 , V.VERSION_TYPE AS MEASURE, QTY, CELL_MODEL
            FROM   ALL_QUERY_DATA_FILTERED A
            INNER JOIN TARGET_VERSION_NO V
                   ON  A.VERSION_NO = V.VERSION_NO
            UNION ALL
        ]';
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
            SELECT '' AS VERSION_NO
                 , DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID
                 , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD
                 , 'Difference' AS MEASURE
                 , SUM(CASE WHEN V.VERSION_TYPE = 'Version(A)' THEN QTY ELSE -QTY END) AS QTY
                 , CELL_MODEL
            FROM   ALL_QUERY_DATA_FILTERED B
            INNER JOIN TARGET_VERSION_NO V
                   ON  B.VERSION_NO = V.VERSION_NO
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID
                   , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD, CELL_MODEL
        ),
        MKT_FCST AS (
            SELECT A.VERSION_NO
                 , CASE WHEN A.MEASURE = 'Version(A)' THEN '1'
                        WHEN A.MEASURE = 'Version(B)' THEN '2'
                   ELSE 'Z'
                   END AS VERSION_SORT
                 , A.DIVISION_ID
                 , A.DIVISION_ID AS DIVISION_ID40

                 --[PJ2024-50461] Team Mapping------------------------------------
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , TEAM.DEPT_ID AS TEAM_ID
                 , NVL(TEAM.DEPT_NAME_KO, '') AS TEAM_NAME_KO  --[PJ2024-50611] 정렬시 사용하는 컬럼인데 하드코딩이 되어져 있음. null 방지 처리함
                 --[PJ2024-50461] Team Mapping------------------------------------

                 , G.END_CUSTOMER
                 , A.PROJECT_CODE AS END_CUSTOMER40
                 , F.BIZ_TYPE
                 , G.SOLDTO_CUSTOMER
                 , I.COUNTRY
                 , I.COUNTRY_NAME
                 , H.CITY
                 , H.CITY_NAME
                 , A.SCM_SITE_ID
                 , A.SCM_SITE_ID AS SCM_SITE_ID40
                 , A.PLANT_SITE_ID
                 , A.PROJECT_CODE
                 , F.PROJECT_NAME
                 , SCM_MGR.FN_GET_MULTI_OWNER_NAME(E.OWNER, ',', '1') AS OWNER  -- 20180817
                 , CASE WHEN A.DIVISION_ID <> '40' THEN F.PROJECT_OWNER
                   ELSE J.USER_NAME_EN END AS PROJECT_OWNER -- 20180705
                 , J.USER_ID
                 --20180809 ytchoi modify(e)
                 , A.ITEM_ID
                 , A.ITEM_ID AS ITEM_ID40
                 , L.ITEM_NAME
                 , L.NICK_NAME
                 , A.INCOTERMS
                 , L.ITEM_TYPE
                 , A.FCST_TYPE
                 , A.DOM_EXP
                 , F.PROJECT_STATUS
                 , A.MEASURE
                 , C.BASIS_YYYYMM   AS YYYYMM
                 , CASE WHEN ']' || P_BUCKET || q'[' = 'ONLY_WEEKLY' THEN C.BASIS_YYYYMMWW
                   ELSE C.BASIS_YYYYMM || C.ISO_WEEK END AS YYYYMMWW
                 , C.BASIS_YYYYMMDD AS YYYYMMDD
                 , C.DAYOFWEEK
                 , CASE WHEN M.BUCKET_PER = 'Y' THEN 'Y' WHEN M.BUCKET_PER = 'N' THEN 'N' ELSE NULL END AS PER  -- 20181101 khsong add
                 , D.QTY
                 , C.END_FLAG
                 , E.CUST_GROUP
                 , E.CUST_GROUP_DTL
                 , E.APPLICATION
                 , E.ROUTE
                 -- 20180711 추가
                 , L.MDM_PROJECT_NAME
                 , L.MIN_CAPACITY
                 , L.FORECAST_INFO_BIZ_TYPE
                 , L.FORECAST_INFO_PRODUCT_GROUP
                 , A.FORECAST_INFO_CELL_MODEL  -- 20180809 ytchoi
                 , LOOK.NAME AS CELL_TYPE  --20180911 LookUp 테이블 조인으로 CELL_TYPE 명칭
                 , L.FORECAST_INFO_CELL_PACK_COUNT
                 , L.FORECAST_INFO_SPEC || L.FORECAST_INFOR_VERSION AS FORECAST_INFO_SPEC
                 , G.VMI_YN  -- 20180719
                 , CASE WHEN
                       C.BASIS_YYYYMMDD = TO_CHAR(LAST_DAY(TO_DATE(C.BASIS_YYYYMMDD, 'YYYYMMDD')), 'YYYYMMDD')
                   THEN 'Y' ELSE 'N' END AS M_LAST_D_FLAG
                 , CASE WHEN A.DIVISION_ID = '40' THEN
                       CASE WHEN
                            --[PJ2024-50461] Team Mapping------------------------------------
                            ((A.MEASURE IN ('MKT_FCST_RP','RTF','CUST_FCST','VMI_IN_Req')) AND (SCM_MGR.FN_GET_DEPT_LIST(']' || P_CREATED_BY || q'[', TEAM.DEPT_ID) = 'Y'))
                            --[PJ2024-50461] Team Mapping------------------------------------
                            OR ((A.MEASURE IN ('MKT_FCST_RP','RTF','CUST_FCST','VMI_IN_Req')) AND (']' || V_GROUP_ID || q'[' = 'ADMIN'))
                       THEN 'Y' ELSE 'N' END
                   END AS EDIT_FLAG
                 , CASE WHEN A.DIVISION_ID = '40' AND G.VMI_YN = 'Y' AND A.MEASURE = 'VMI_In_Req' THEN 'Y'
                        WHEN A.DIVISION_ID = '40' AND G.VMI_YN = 'N' AND A.MEASURE = 'MKT_FCST_RP' THEN 'Y'
                   ELSE 'N' END AS SCP_USE_YN
                 , E.ATTRIBUTE7 AS PRIORITY  --201811116
                 --[E20231017-000634] SCP정보수집
                 , SCP.CELL_NICKNAME  --20231025
                 , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82' THEN SCP.GROUP_CODE6
                   ELSE SCP.CELL_TYPE_GROUP_NAME END AS PRODUCT_LEVEL1
                 , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82' THEN SCP.GROUP_CODE7
                   ELSE SCP.BASIC_NICKNAME_CELL40 END AS PRODUCT_LEVEL2
                 , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN SCP.GROUP_CODE5
                        WHEN A.DIVISION_ID = '82'               THEN SCP.GROUP_CODE4
                   ELSE SCP.NICKNAME_40 END AS PRODUCT_LEVEL3
            FROM (
                SELECT DISTINCT F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID
                              , F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
                              , CELL_MODEL AS FORECAST_INFO_CELL_MODEL   -- 20180809 ytchoi
                FROM   ALL_QUERY_DATA F
        ]';

    -- [@sp_project_code_join]
    IF P_PROJECT_CODE IS NOT NULL AND P_PROJECT_CODE <> '' THEN
        V_SQL_TEXT := V_SQL_TEXT || q'[
                INNER JOIN SCM_MGR.GT_DM40_PROJECT_INPUT PROJECT_INPUT
                        ON F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
        ]';
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || q'[
                WHERE  1 = 1    -- 20180809 ytchoi
            ) A
            INNER JOIN CALENDAR C
                   ON  1 = 1
            LEFT JOIN ALL_QUERY_DATA D
                   ON  A.DIVISION_ID   = D.DIVISION_ID
                   AND A.PROJECT_CODE  = D.PROJECT_CODE
                   AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                   AND A.ITEM_ID       = D.ITEM_ID
                   AND A.DOM_EXP       = D.DOM_EXP
                   AND A.FCST_TYPE     = D.FCST_TYPE
                   AND A.INCOTERMS     = D.INCOTERMS
                   AND A.MEASURE       = D.MEASURE
                   AND C.BASIS_YYYYMMDD = D.YYYYMMDD
                   AND NVL(A.VERSION_NO,'@#@#@#') = NVL(D.VERSION_NO,'@#@#@#')
            INNER JOIN (SELECT E.DIVISION_ID,E.SCM_SITE_ID,E.PROJECT_CODE,E.ITEM_ID
                              ,(SELECT TRIM(REGEXP_SUBSTR(E.OWNER, '[^,]+', 1, 1)) FROM DUAL WHERE ROWNUM = 1) AS USER_ID
                              ,E.OWNER
                              ,E.CUST_GROUP
                              ,E.CUST_GROUP_DTL
                              ,E.APPLICATION
                              ,E.ROUTE
                              ,E.ATTRIBUTE7
                        FROM   SCM_MGR.SCM_MST_SITE_ITEM E
                       ) E
                   ON  A.DIVISION_ID   = E.DIVISION_ID
                   AND A.SCM_SITE_ID   = E.SCM_SITE_ID
                   AND A.PROJECT_CODE  = E.PROJECT_CODE
                   AND A.ITEM_ID       = E.ITEM_ID
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT F
                   ON  A.DIVISION_ID   = F.DIVISION_ID
                   AND A.PROJECT_CODE  = F.PROJECT_CODE
            LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE G
                   ON  A.DIVISION_ID   = G.DIVISION_ID
                   AND A.SCM_SITE_ID   = G.SCM_SITE_ID
            LEFT OUTER JOIN SCM_MGR.SCM_MST_CITY H
                   ON  G.CITY          = H.CITY
            LEFT OUTER JOIN SCM_MGR.SCM_MST_COUNTRY I
                   ON  G.COUNTRY       = I.COUNTRY
            --[E20231017-000634]
            LEFT OUTER JOIN SCP_ITEM_INFO SCP
                   ON  SCP.DIVISION_ID = A.DIVISION_ID
                   AND SCP.ITEM_ID     = A.ITEM_ID
            -- 20180809 추가  -----------------
            LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                        ON B.DEPT_ID = C.DEPT_ID
            ) TEAM
                   ON  TEAM.USER_ID = E.USER_ID
            -- 20180809 추가  -----------------
            LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
                   ON  E.OWNER = J.USER_ID -- 20180724 add son young suk
            LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
            --[PJ2024-50461] Team Mapping------------------------------------
                   ON  J.DEPT_ID = K.DEPT_ID
            --[PJ2024-50461] Team Mapping------------------------------------
            INNER JOIN SCM_MGR.GT_DM40_ITEM_SINGLE L
                   ON  A.DIVISION_ID = L.DIVISION_ID
                   AND A.ITEM_ID     = L.ITEM_ID
            LEFT JOIN SCM_MGR.DM_MST_BUCKET_CONVERSION M
                   ON  A.DIVISION_ID = M.DIVISION_ID
                   AND A.SCM_SITE_ID = M.SCM_SITE_ID
                   AND A.INCOTERMS   = M.INCOTERMS
                   AND C.DAYOFWEEK   = M.YYYYMMDD
            LEFT JOIN (  --** 20180911  Son Young Suk  조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회 LookUp 테이블 조인
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK
                   ON  LOOK.CODE = L.CELL_TYPE
            WHERE 1=1
            AND D.QTY IS NOT NULL -- [20240312] 조건 추가함.
        ]';

    -- [@v_team_id]
    --[PJ2024-50461] Team Mapping -검색조건 처리 누락 수정
    IF P_TEAM_ID IS NOT NULL AND NVL(P_TEAM_ID,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND TEAM.DEPT_ID IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_TEAM_ID || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_TEAM_ID || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;

    -- [@v_item_type]
    IF P_ITEM_TYPE IS NOT NULL AND NVL(P_ITEM_TYPE,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
        V_SQL_TEXT := V_SQL_TEXT || ' AND L.ITEM_TYPE IN ('
            || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_ITEM_TYPE || ''',''[^,]+'',1,LEVEL))'
            || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_ITEM_TYPE || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
    END IF;


    V_SQL_TEXT := V_SQL_TEXT || '
        )
        /* 기존SQL */
        SELECT ' || V_COLUMN || '
             , F.VERSION_SORT AS SORT_ORDER_NO
               [V_ITERATION]
             , EDY.EDIT_YN
        FROM   MKT_FCST F
               INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                    ON EDY.USER_ID = ''' || P_USER_ID || '''
                   AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
                   AND EDY.UNIT_ID = F.DIVISION_ID
        WHERE  1 = 1
        -- add 181102 속도개선을 의해서 추가
        -- [20240312] 주석처리함. AND    ( F.PER IS NOT NULL OR F.QTY IS NOT NULL )
    ';


    -- [@v_customer]
    IF P_DIVISION_ID <> '40' THEN
        IF P_CUSTOMER IS NOT NULL AND NVL(P_CUSTOMER,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.END_CUSTOMER IN ('
                || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_CUSTOMER || ''',''[^,]+'',1,LEVEL))'
                || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_CUSTOMER || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
        END IF;
    END IF;

    -- [@v_biz_type]
    IF P_DIVISION_ID <> '40' THEN
        IF P_BIZ_TYPE IS NOT NULL AND NVL(P_BIZ_TYPE,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND F.BIZ_TYPE IN ('
                || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_BIZ_TYPE || ''',''[^,]+'',1,LEVEL))'
                || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_BIZ_TYPE || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
        END IF;
    ELSE
        IF P_BIZ_TYPE IS NOT NULL AND NVL(P_BIZ_TYPE,'@#@#@#') NOT IN ('ALL','@#@#@#') THEN
            V_SQL_TEXT := V_SQL_TEXT || ' AND FORECAST_INFO_BIZ_TYPE IN ('
                || CHR(10) || ' (SELECT TRIM(REGEXP_SUBSTR(''' || P_BIZ_TYPE || ''',''[^,]+'',1,LEVEL))'
                || CHR(10) || '   FROM DUAL CONNECT BY REGEXP_SUBSTR(''' || P_BIZ_TYPE || ''',''[^,]+'',1,LEVEL) IS NOT NULL))';
        END IF;
    END IF;

    V_SQL_TEXT := V_SQL_TEXT || V_GROUPBY ||' ,EDY.EDIT_YN ' || CHR(10);

    -- =========================================================================
    -- [E20240201-001467] 20240216: ORDER BY 동적 구성
    -- =========================================================================
    V_ORDER := '';
    FOR R_ORD IN (
        SELECT COLUMN_NAME, DATA_SORT_METHOD_CODE
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    U.PROGRAM_ID                    = V_PROGRAM_ID
        AND    U.SHEET_NAME                    = V_SHEET_NAME
        AND    U.USER_ID                       = P_CREATED_BY
        ORDER BY SORT_ORDER_NO
    ) LOOP
        V_ORDER := V_ORDER || R_ORD.COLUMN_NAME || ' ' || R_ORD.DATA_SORT_METHOD_CODE || ',';
    END LOOP;

    V_ORDER := ' ORDER BY ' || SUBSTR(V_ORDER, 1, LENGTH(V_ORDER) - 1) || ' , SORT_ORDER_NO ASC ';
    V_ORDER := REPLACE(REPLACE(V_ORDER, ',VERSION_NO', ''), ',MEASURE', '');

    DBMS_OUTPUT.PUT_LINE('V_ORDER : '||V_ORDER);
    --end-----------------------------------------------------------------------------
    --[E20240201-001467]
    V_SQL_TEXT := V_SQL_TEXT || V_ORDER;

    V_SQL_TEXT := PKG_DMF0007.F_FN_REPLACE_CLOB(V_SQL_TEXT,'[V_ITERATION]', V_ITERATION);

    -- =========================================================================
    -- 동적 SQL 실행 → O_RC1 반환
    -- =========================================================================
    DBMS_OUTPUT.PUT_LINE('V_COLUMN : '||V_COLUMN);
    PKG_DMF0007.P_PR_PRINT_CLOB('V_SQL_TEXT', V_ITERATION);
    PKG_DMF0007.P_PR_PRINT_CLOB('V_SQL_TEXT', V_SQL_TEXT);

    V_SQL_CURSOR := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(V_SQL_CURSOR, V_SQL_TEXT, DBMS_SQL.NATIVE);
    V_EXECUTE_RET := DBMS_SQL.EXECUTE(V_SQL_CURSOR);
    O_RC1 := DBMS_SQL.TO_REFCURSOR(V_SQL_CURSOR);
    V_SQL_CURSOR := NULL;

    IF DBMS_LOB.ISTEMPORARY(V_SQL_TEXT) = 1 THEN
        DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);
    END IF;

    IF DBMS_LOB.ISTEMPORARY(V_ITERATION) = 1 THEN
        DBMS_LOB.FREETEMPORARY(V_ITERATION);
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    COMMIT;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(V_SQL_CURSOR) THEN
            DBMS_SQL.CLOSE_CURSOR(V_SQL_CURSOR);
        END IF;

        IF DBMS_LOB.ISTEMPORARY(V_SQL_TEXT) = 1 THEN
            DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);
        END IF;

        IF DBMS_LOB.ISTEMPORARY(V_ITERATION) = 1 THEN
            DBMS_LOB.FREETEMPORARY(V_ITERATION);
        END IF;

        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_TEAM_ID'       VALUE P_TEAM_ID,
            'P_CUSTOMER'      VALUE P_CUSTOMER,
            'P_BIZ_TYPE'      VALUE P_BIZ_TYPE,
            'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
            'P_ITEM_ID'       VALUE P_ITEM_ID,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_VERSION_NO'    VALUE P_VERSION_NO,
            'P_ITEM_TYPE'     VALUE P_ITEM_TYPE,
            'P_OWNER'         VALUE P_OWNER,
            'P_DIFF_ONLY'     VALUE P_DIFF_ONLY,
            'P_BUCKET'        VALUE P_BUCKET
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
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0040_GET_MKT_FCST_COMPARISON;

END PKG_DMF0040;