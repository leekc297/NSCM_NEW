-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_EXCEL_UPLOAD (PROCEDURE, INVALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_EXCEL_UPLOAD"
(
    P_MODE            IN PLS_INTEGER,
    P_CREATED_BY      IN VARCHAR2,
    P_PROGRAM_ID      IN VARCHAR2,  -- 3/26 추가 결정
    P_SHEET_NAME      IN VARCHAR2,  -- 3/26 추가 결정

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0020_EXCEL_UPLOAD]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.05.27   KJJ			최초 작성
 * 2024.12.31	KJJ			[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한
 * 2026.03.19   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 * validation: 필수값, 모델중복, Currency 중복, Division 오류, TEAM 오류
 *
 */
IS
/*


1.81 사업부만 대상임


2. LOC 값이 없을 경우 0으로 간주하여 처리(skip 이 아님)
=>기존 저장 SP(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL) 는 무조건 삭제 후 0 값이 아닌 것들(구분자 D 가 아닌것들)만 insert 하는 것으로 되어 있으나
본 SP는 Merge into 구문으로 구현하여 0으로 처리


=>2024.06.12 로직 변경
0 으로 넣은 경우: Validation 에서 Invalid 처리
빈값으로 넣은 경우: SKIP, 기존 Sales Price 데이터를 유지



3.입력된 엑셀 row 중복체크
=>1)동일모델 입력 방지 위해 Div / Team /	End Customer /	Project Code /	Model 로 중복체크
=>2)위 체크조건 통과했을 경우 여러개 Currency 입력방지 위해 중복체크



4.ItemID가 입력되지 않은 것들과  ItemID가 입력된 건들을 나누어서 추출 후 병합(row순서는 고려하지 않음)
=>
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD	 AMVAGBEVM-A4-D13  300	300	300	300	300
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD					   100	100	100	100	100


81	자동차.마케팅.아시아.현대기아차팀	KIA	A22MZ1002	USD	ACHP2005I-A1T007	500	500	500	500


순서로 입력되어 있어도 ItemID가 입력되지 않은 것 먼저 처리함(2024.05.29 박필수 책임 확인사항)

=>이를 위해 ItemID 없는 건들 먼저 추출(전체 데이터셋)
=>ItemID 있는 건들 추출(ItemID 데이터셋)
=>merge into 처리


5.SCM_MST_FUTURE_PRICE , SCM_MST_FUTURE_PRICE_H 저장시 화면에서 수동으로 등록한 것과 구분하기 위해 ATTRIBUTE8 컬럼에 EXCEL UPLOAD 표시

*/

    V_PROGRAM_ID        VARCHAR2(40 CHAR) := P_PROGRAM_ID; -- 'DMF0020';
    V_SHEET_NAME        VARCHAR2(40 CHAR) := P_SHEET_NAME; -- 'Sales Price';
    V_CREATION_DATE     VARCHAR2(40 CHAR);
    V_COUNT             PLS_INTEGER;
    V_DIVISION          VARCHAR2(10 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

    -- EXCEPTION 용 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);


BEGIN

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- v_creation_date 조회
    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
      INTO V_CREATION_DATE
      FROM SCM_ADM_EXCEL_UPLOAD T
     WHERE T.PROGRAM_ID = V_PROGRAM_ID
       AND T.SHEET_NAME = V_SHEET_NAME
       AND T.CREATED_BY = P_CREATED_BY;

    IF V_CREATION_DATE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        -- V_DESCRIPTION := 'Data Not Found [' || V_CREATION_DATE || ']';
        V_DESCRIPTION := to_char(0); -- 3/26 실패 시, 3번째 컬럼 0 리턴
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    BEGIN
        SELECT ATTRIBUTE1
          INTO V_DIVISION
          FROM SCM_ADM_EXCEL_UPLOAD
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'SUCCESS'
           AND ROWNUM             = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_DIVISION := NULL;
    END;

    -- @p_mode = 0 이면 Validation
    IF NVL(P_MODE, 0) = 0 THEN

        -- RESET Status = UPLOAD
        UPDATE SCM_ADM_EXCEL_UPLOAD T
           SET UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL
         WHERE T.PROGRAM_ID    = V_PROGRAM_ID
           AND T.SHEET_NAME    = V_SHEET_NAME
           AND T.CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND NVL(T.UPLOAD_STATUS_CODE, 'X') <> 'UPLOAD';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
        V_LOG_TYPE    := '1';
        V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -- SKIP EMPTY LINE
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'SKIP'
         WHERE PROGRAM_ID    = V_PROGRAM_ID
           AND SHEET_NAME    = V_SHEET_NAME
           AND CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND (   ATTRIBUTE1 IS NULL
                OR UPPER(ATTRIBUTE1) = 'TOTAL');

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
        V_LOG_TYPE    := '2';
        V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -- @TITLE Header Line
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = '@TITLE'
         WHERE PROGRAM_ID    = V_PROGRAM_ID
           AND SHEET_NAME    = V_SHEET_NAME
           AND CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPPER(ATTRIBUTE1) = 'DIV';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
        V_LOG_TYPE    := '3';
        V_LOG_MESSAGE := '########## TITLE Header Line ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --본격적 VALIDATION 시작

        /* #################################################### */
        /* 필수 값 NULL 값 체크									*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* #################################################### */
        --Div	Team	End Customer	Project Code	Currency
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN NVL(ATTRIBUTE1, '') = '' THEN 'NULL DIVISION.'
                                        WHEN NVL(ATTRIBUTE2, '') = '' THEN 'NULL TEAM.'
                                        WHEN NVL(ATTRIBUTE3, '') = '' THEN 'NULL END CUSTOMER.'
                                        WHEN NVL(ATTRIBUTE4, '') = '' THEN 'NULL PROJECT CODE.'
                                        WHEN NVL(ATTRIBUTE5, '') = '' THEN 'NULL CURRENCY.'
                                   END
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                NVL(ATTRIBUTE1, '') = '' OR NVL(ATTRIBUTE2, '') = '' OR NVL(ATTRIBUTE3, '') = '' OR NVL(ATTRIBUTE4, '') = '' OR NVL(ATTRIBUTE5, '') = ''
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## ERROR NULL Column Data ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 동일아이템 중복 체크									*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Model.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND EXISTS (
                SELECT 1
                FROM (
                    SELECT X.ATTRIBUTE1 AS COL1/* ATTRIBUTE1  : Div		*/
                         , X.ATTRIBUTE2 AS COL2/* ATTRIBUTE2  : Team		*/
                         , X.ATTRIBUTE3 AS COL3/* ATTRIBUTE3  : End Customer	*/
                         , X.ATTRIBUTE4 AS COL4/* ATTRIBUTE4 : Project Code	*/
                         , X.ATTRIBUTE6 AS COL6/*ATTRIBUTE6  : Model			*/
                      FROM SCM_ADM_EXCEL_UPLOAD X
                     WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                       AND X.SHEET_NAME    = V_SHEET_NAME
                       AND X.CREATED_BY    = P_CREATED_BY
                       AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                       AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                     GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE6
                    HAVING COUNT(*) > 1
                ) T
                WHERE T.COL1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                  AND T.COL2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                  AND T.COL3 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                  AND T.COL4 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                  AND T.COL6 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
               );

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Model Duplication ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 위 체크 통과했을 경우 Currency 체크					*/
        /*두 개 이상의 Currency가 중복으로 입력되면 안됨		*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */
        DECLARE
            V_MODEL_DUP_EXISTS PLS_INTEGER;
        BEGIN
            SELECT 1 INTO V_MODEL_DUP_EXISTS FROM DUAL WHERE EXISTS (
                SELECT 1
                  FROM SCM_ADM_EXCEL_UPLOAD X
                 WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                   AND X.SHEET_NAME    = V_SHEET_NAME
                   AND X.CREATED_BY    = P_CREATED_BY
                   AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                 GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE6
                HAVING COUNT(*) > 1
            );
            -- 모델 중복이 존재하면 Currency 체크 skip
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- 모델 중복 없을 때만 Multiple Currency 체크
                UPDATE SCM_ADM_EXCEL_UPLOAD
                   SET UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Multiple Currency.'
                 WHERE PROGRAM_ID         = V_PROGRAM_ID
                   AND SHEET_NAME         = V_SHEET_NAME
                   AND CREATED_BY         = P_CREATED_BY
                   AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                   AND UPLOAD_STATUS_CODE = 'UPLOAD'
                   AND EXISTS (
                        SELECT 1
                        FROM (
                            SELECT COL1, COL2, COL3, COL4
                            FROM (
                                SELECT X.ATTRIBUTE1 AS COL1
                                     , X.ATTRIBUTE2 AS COL2
                                     , X.ATTRIBUTE3 AS COL3
                                     , X.ATTRIBUTE4 AS COL4
                                     , X.ATTRIBUTE5 AS COL5
                                  FROM SCM_ADM_EXCEL_UPLOAD X
                                 WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                                   AND X.SHEET_NAME    = V_SHEET_NAME
                                   AND X.CREATED_BY    = P_CREATED_BY
                                   AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                 GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE5
                            ) A
                            GROUP BY COL1, COL2, COL3, COL4
                           HAVING COUNT(*) > 1
                        ) T
                        WHERE T.COL1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                          AND T.COL2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                          AND T.COL3 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                          AND T.COL4 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                       );
        END;

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Multiple Currency ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* DIVISION  체크											*/
        /* #################################################### */
        --81 사업부만 처리
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Division.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND ATTRIBUTE1 NOT LIKE '81%';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
        V_LOG_TYPE    := '5';
        V_LOG_MESSAGE := '########## Invalid Division ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* TEAM 체크											*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid TEAM.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SSO_DEPT_INFO DI
                 WHERE DI.DEPT_NAME_KO = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                   AND DI.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid TEAM. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* END CUSTOMER 체크									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid END CUSTOMER.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE MS
                 WHERE MS.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                   AND MS.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid END CUSTOMER. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* PROJECT CODE 체크									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid PROJECT CODE.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_PROJECT MP
                 WHERE MP.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MP.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid PROJECT CODE. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* CURRENCY 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid CURRENCY.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM DM_MST_EXCHANGE_RATE ER
                 WHERE ER.DIVISION_ID   = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND ER.UNIT_CURRENCY = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid CURRENCY. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* MODEL 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid MODEL.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE6, '') <> ''
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE MS
                 INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.ITEM_ID      = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                   AND ITM.VALID_YN     = 'Y'
                 INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                    ON ITM.DEPT_ID      = DI.DEPT_ID
                   AND DI.DEPT_NAME_KO = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                   AND DI.VALID_YN     = 'Y'
                 WHERE MS.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                   AND MS.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid MODEL. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 숫자여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid NUMERIC.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$')) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$')) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$')) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$')) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$')) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$')) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$')) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$')) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$')) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$')) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$')) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$')) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$'))   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid NUMERIC. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 마이너스 여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Negative Number.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE7)  < 0) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE8)  < 0) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE9)  < 0) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE10) < 0) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE11) < 0) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE12) < 0) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE13) < 0) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE14) < 0) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE15) < 0) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE16) < 0) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE17) < 0) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE18) < 0) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE19) < 0)   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Negative Number. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 0 여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Zero Number.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE7)  = 0) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE8)  = 0) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE9)  = 0) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE10) = 0) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE11) = 0) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE12) = 0) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE13) = 0) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE14) = 0) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE15) = 0) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE16) = 0) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE17) = 0) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE18) = 0) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE19) = 0)   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Zero Number. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한 START
        /* #################################################### */
        /*  item별로 1개의 currency만 등록되게 기존 데이터 체크하여 튕겨냄					*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */

        --ITEM 입력 안된 경우는 프로젝트 하위의 전체 ITEM을 체크
        -- M0~M12 각 월별 기존 FP 데이터와 Currency 불일치 여부를 UNION ALL 기반으로 체크
        UPDATE SCM_ADM_EXCEL_UPLOAD EU
           SET EU.UPLOAD_STATUS_CODE = 'ERROR'
             , EU.MESSAGE_TEXT       = '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID
           AND EU.SHEET_NAME         = V_SHEET_NAME
           AND EU.CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND EU.UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(EU.ATTRIBUTE6, '') = '' --item_id 입력 안된건
           AND EXISTS (
                SELECT 1
                FROM SCM_MST_SITE MS
                INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = MS.DIVISION_ID
                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.VALID_YN     = 'Y'
                INNER JOIN SCM_MST_FUTURE_PRICE FP
                    ON FP.DIVISION_ID   = ITM.DIVISION_ID
                   AND FP.PROJECT_CODE  = ITM.PROJECT_CODE
                   AND FP.SCM_SITE_ID   = ITM.SCM_SITE_ID
                   AND FP.MEASURE       = 'LOC'
                   AND FP.ITEM_ID       = ITM.ITEM_ID
                   AND FP.CURRENCY     <> EU.ATTRIBUTE5
                WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                  AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                  AND MS.VALID_YN     = 'Y'
                  AND (
                       (NVL(EU.ATTRIBUTE7,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(SYSDATE, 'YYYYMM'))                      --M0
                    OR (NVL(EU.ATTRIBUTE8,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM'))  --M1
                    OR (NVL(EU.ATTRIBUTE9,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM'))  --M2
                    OR (NVL(EU.ATTRIBUTE10, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM'))  --M3
                    OR (NVL(EU.ATTRIBUTE11, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM'))  --M4
                    OR (NVL(EU.ATTRIBUTE12, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM'))  --M5
                    OR (NVL(EU.ATTRIBUTE13, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM'))  --M6
                    OR (NVL(EU.ATTRIBUTE14, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM'))  --M7
                    OR (NVL(EU.ATTRIBUTE15, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM'))  --M8
                    OR (NVL(EU.ATTRIBUTE16, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM'))  --M9
                    OR (NVL(EU.ATTRIBUTE17, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM'))  --M10
                    OR (NVL(EU.ATTRIBUTE18, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM'))  --M11
                    OR (NVL(EU.ATTRIBUTE19, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM'))  --M12
                  )
           );

        --ITEM 입력된 경우
        UPDATE SCM_ADM_EXCEL_UPLOAD EU
           SET EU.UPLOAD_STATUS_CODE = 'ERROR'
             , EU.MESSAGE_TEXT       = '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID
           AND EU.SHEET_NAME         = V_SHEET_NAME
           AND EU.CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND EU.UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(EU.ATTRIBUTE6, '') <> '' --item_id 입력 된건
           AND EXISTS (
                SELECT 1
                FROM SCM_MST_SITE MS
                INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = MS.DIVISION_ID
                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.VALID_YN     = 'Y'
                INNER JOIN SCM_MST_FUTURE_PRICE FP
                    ON FP.DIVISION_ID   = ITM.DIVISION_ID
                   AND FP.PROJECT_CODE  = ITM.PROJECT_CODE
                   AND FP.SCM_SITE_ID   = ITM.SCM_SITE_ID
                   AND FP.MEASURE       = 'LOC'
                   AND FP.ITEM_ID       = ITM.ITEM_ID
                   AND FP.ITEM_ID       = EU.ATTRIBUTE6
                   AND FP.CURRENCY     <> EU.ATTRIBUTE5
                WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                  AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                  AND MS.VALID_YN     = 'Y'
                  AND (
                       (NVL(EU.ATTRIBUTE7,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(SYSDATE, 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE8,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE9,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE10, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE11, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE12, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE13, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE14, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE15, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE16, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE17, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE18, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE19, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM'))
                  )
           );

        --[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한 END

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## ERROR Multiple Currency ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- 정상(SUCCESS) 처리
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'SUCCESS'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD';

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '16';
        V_LOG_MESSAGE := '########## SUCCESS ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ----------------------------------------------------------------------------

    END IF; -- END OF p_mode = 0

------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    V_LOG_TYPE    := '17';
    V_LOG_MESSAGE := '########## INSERT DATA START ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

    --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT COUNT(1)
      INTO V_COUNT
      FROM SCM_ADM_EXCEL_UPLOAD T
     WHERE T.PROGRAM_ID         = V_PROGRAM_ID
       AND T.SHEET_NAME         = V_SHEET_NAME
       AND T.CREATED_BY         = P_CREATED_BY
       AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
       AND T.UPLOAD_STATUS_CODE = 'ERROR';

    --실제 업무처리
    IF P_MODE > 0 AND V_COUNT > 0 THEN
        -- Validation 실패 상태에서 저장 시도 → 조기 리턴
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        -- V_DESCRIPTION := 'Validation ERROR exists: ' || TO_CHAR(V_COUNT) || ' rows';
        V_DESCRIPTION := TO_CHAR(V_COUNT);  -- 3/26 실패 시, to_char(0) 리턴
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    IF P_MODE > 0 AND V_COUNT = 0 THEN

        --------------------------------------------------
        -- 엑셀 업로드용 TMP 테이블 생성 및 데이터 저장
        --------------------------------------------------
        -- EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

        -- GTT TRUNCATE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_EXCEL_UPLOAD';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_UPLOAD_MASTER_STEP1';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_UPLOAD_MASTER_WITH_ITEM';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_UPLOAD_MASTER_STEP2';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_UPLOAD_MASTER_FINAL';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F020_EXCH';

        BEGIN
            --그냥 빈값을 넣어도 되나 추후 UNPIVOT시 제대로 되지 않을까 우려하여 0으로 놓고 나중에 걸러내기로 함
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_EXCEL_UPLOAD
            (DIVISION_ID, TEAM_NAME, END_CUST, PROJECT_CODE, CURRENCY, MODEL,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                ATTRIBUTE1   --DIVISION_ID
              , ATTRIBUTE2   --TEAM_NAME
              , ATTRIBUTE3   --END_CUST
              , ATTRIBUTE4   --PROJECT_CODE
              , ATTRIBUTE5   --CURRENCY
              , ATTRIBUTE6   --MODEL
              , CASE WHEN ATTRIBUTE7  = '' THEN '0' ELSE ATTRIBUTE7  END  --M0 빈값이면 0 처리
              , CASE WHEN ATTRIBUTE8  = '' THEN '0' ELSE ATTRIBUTE8  END  --M1
              , CASE WHEN ATTRIBUTE9  = '' THEN '0' ELSE ATTRIBUTE9  END  --M2
              , CASE WHEN ATTRIBUTE10 = '' THEN '0' ELSE ATTRIBUTE10 END  --M3
              , CASE WHEN ATTRIBUTE11 = '' THEN '0' ELSE ATTRIBUTE11 END  --M4
              , CASE WHEN ATTRIBUTE12 = '' THEN '0' ELSE ATTRIBUTE12 END  --M5
              , CASE WHEN ATTRIBUTE13 = '' THEN '0' ELSE ATTRIBUTE13 END  --M6
              , CASE WHEN ATTRIBUTE14 = '' THEN '0' ELSE ATTRIBUTE14 END  --M7
              , CASE WHEN ATTRIBUTE15 = '' THEN '0' ELSE ATTRIBUTE15 END  --M8
              , CASE WHEN ATTRIBUTE16 = '' THEN '0' ELSE ATTRIBUTE16 END  --M9
              , CASE WHEN ATTRIBUTE17 = '' THEN '0' ELSE ATTRIBUTE17 END  --M10
              , CASE WHEN ATTRIBUTE18 = '' THEN '0' ELSE ATTRIBUTE18 END  --M11
              , CASE WHEN ATTRIBUTE19 = '' THEN '0' ELSE ATTRIBUTE19 END  --M12
              FROM SCM_ADM_EXCEL_UPLOAD
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND UPLOAD_STATUS_CODE = 'SUCCESS'
               AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname          => 'SCM_MGR',
                tabname          => 'GT_F020_EXCEL_UPLOAD',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                method_opt       => 'FOR ALL COLUMNS SIZE 1'
            );

            --------------------------------------------------
            --item_id 없는 데이터셋 추출
            --------------------------------------------------
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_STEP1
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                FP.INCOTERMS, FP.DOM_EXP, FP.PLANT_SITE_ID, FP.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_FUTURE_PRICE FP
                ON FP.DIVISION_ID   = TMP.DIVISION_ID
               AND FP.PROJECT_CODE  = TMP.PROJECT_CODE
               AND FP.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND FP.ITEM_ID       = ITM.ITEM_ID
               AND FP.MEASURE       = 'LOC'
             WHERE NVL(TMP.MODEL, '') = '' --item_id 입력 안된건(전체데이터셋)
            UNION
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                PN.INCOTERMS, PN.DOM_EXP, PN.PLANT_SITE_ID, PN.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN DM_PLN_SALES_PLAN PN
                ON PN.DIVISION_ID   = TMP.DIVISION_ID
               AND PN.PROJECT_CODE  = TMP.PROJECT_CODE
               AND PN.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND PN.ITEM_ID       = ITM.ITEM_ID
               AND PN.MEASURE       = 'RTF_SYS_RP'
             WHERE NVL(TMP.MODEL, '') = ''; --item_id 입력 안된건(전체데이터셋)

            COMMIT;

            --------------------------------------------------
            --item_id 있는 데이터셋 추출
            --------------------------------------------------
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_WITH_ITEM
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                FP.INCOTERMS, FP.DOM_EXP, FP.PLANT_SITE_ID, FP.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.ITEM_ID      = TMP.MODEL
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_FUTURE_PRICE FP
                ON FP.DIVISION_ID   = TMP.DIVISION_ID
               AND FP.PROJECT_CODE  = TMP.PROJECT_CODE
               AND FP.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND FP.ITEM_ID       = ITM.ITEM_ID
               AND FP.MEASURE       = 'LOC'
            UNION
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                PN.INCOTERMS, PN.DOM_EXP, PN.PLANT_SITE_ID, PN.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.ITEM_ID      = TMP.MODEL
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN DM_PLN_SALES_PLAN PN
                ON PN.DIVISION_ID   = TMP.DIVISION_ID
               AND PN.PROJECT_CODE  = TMP.PROJECT_CODE
               AND PN.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND PN.ITEM_ID       = ITM.ITEM_ID
               AND PN.MEASURE       = 'RTF_SYS_RP';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_STEP1',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );
            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_WITH_ITEM',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            ----===============================================================================
            --두 데이터셋 합치기
            /* ITEM있는 항목(GT_F020_UPLOAD_MASTER_WITH_ITEM)의 값이 '0'이면 원래값 유지*/
            MERGE INTO GT_F020_UPLOAD_MASTER_STEP1 A
            USING GT_F020_UPLOAD_MASTER_WITH_ITEM B
               ON (
                    A.DIVISION_ID  = B.DIVISION_ID
                AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID      = B.ITEM_ID
                AND A.CURRENCY     = B.CURRENCY
                AND A.INCOTERMS    = B.INCOTERMS
                AND A.DOM_EXP      = B.DOM_EXP
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND A.FCST_TYPE    = B.FCST_TYPE
                  )
            WHEN MATCHED THEN
                UPDATE SET
                    A.M0  = CASE WHEN B.M0  = '0' THEN A.M0  ELSE B.M0  END
                  , A.M1  = CASE WHEN B.M1  = '0' THEN A.M1  ELSE B.M1  END
                  , A.M2  = CASE WHEN B.M2  = '0' THEN A.M2  ELSE B.M2  END
                  , A.M3  = CASE WHEN B.M3  = '0' THEN A.M3  ELSE B.M3  END
                  , A.M4  = CASE WHEN B.M4  = '0' THEN A.M4  ELSE B.M4  END
                  , A.M5  = CASE WHEN B.M5  = '0' THEN A.M5  ELSE B.M5  END
                  , A.M6  = CASE WHEN B.M6  = '0' THEN A.M6  ELSE B.M6  END
                  , A.M7  = CASE WHEN B.M7  = '0' THEN A.M7  ELSE B.M7  END
                  , A.M8  = CASE WHEN B.M8  = '0' THEN A.M8  ELSE B.M8  END
                  , A.M9  = CASE WHEN B.M9  = '0' THEN A.M9  ELSE B.M9  END
                  , A.M10 = CASE WHEN B.M10 = '0' THEN A.M10 ELSE B.M10 END
                  , A.M11 = CASE WHEN B.M11 = '0' THEN A.M11 ELSE B.M11 END
                  , A.M12 = CASE WHEN B.M12 = '0' THEN A.M12 ELSE B.M12 END
            WHEN NOT MATCHED THEN
                INSERT (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
                        INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
                        M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
                VALUES (B.DIVISION_ID, B.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.CURRENCY,
                        B.INCOTERMS, B.DOM_EXP, B.PLANT_SITE_ID, B.FCST_TYPE,
                        B.M0, B.M1, B.M2, B.M3, B.M4, B.M5, B.M6, B.M7, B.M8, B.M9, B.M10, B.M11, B.M12);

            COMMIT;

            --------------------------------------------------
            -- 5. 추출된 PK 기준으로 LOC Measure의 가격을 Upload Master 기준 가격으로 Calendar Join해서 주차별 반영(Insert / Update, 52주 구간)
            --------------------------------------------------
            --월별로 UNPIVOT하여 실제 월 구하기(GT_F020_UPLOAD_MASTER_STEP2)
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_STEP2
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2)
            SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
                   INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM,
                   CASE MM
                       WHEN 'M0'  THEN TO_CHAR(SYSDATE, 'YYYYMM')
                       WHEN 'M1'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM')
                       WHEN 'M2'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM')
                       WHEN 'M3'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM')
                       WHEN 'M4'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM')
                       WHEN 'M5'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM')
                       WHEN 'M6'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM')
                       WHEN 'M7'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM')
                       WHEN 'M8'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM')
                       WHEN 'M9'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM')
                       WHEN 'M10' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM')
                       WHEN 'M11' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM')
                       WHEN 'M12' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM')
                   END AS MM2
              FROM GT_F020_UPLOAD_MASTER_STEP1
            UNPIVOT (
                LOC FOR MM IN (
                    M0  AS 'M0',  M1  AS 'M1',  M2  AS 'M2',  M3  AS 'M3',
                    M4  AS 'M4',  M5  AS 'M5',  M6  AS 'M6',  M7  AS 'M7',
                    M8  AS 'M8',  M9  AS 'M9',  M10 AS 'M10', M11 AS 'M11',
                    M12 AS 'M12'
                )
            );

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_STEP2',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            --5-1)Upload Master와 CALENDAR 테이블 조인하여 주차별로 ROW 생성
            --52주차
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT DISTINCT
                TMP.DIVISION_ID, TMP.SCM_SITE_ID, TMP.PROJECT_CODE, TMP.ITEM_ID, TMP.CURRENCY,
                TMP.INCOTERMS, TMP.DOM_EXP, TMP.PLANT_SITE_ID, TMP.FCST_TYPE,
                TMP.LOC, TMP.MM, TMP.MM2, CAL.BASIS_START_DATE,
                'LOC' --엑셀 입력값은 LOC 메저로 간주
              FROM GT_F020_UPLOAD_MASTER_STEP2 TMP
             INNER JOIN (
                SELECT DISTINCT
                    SUBSTR(BASIS_START_DATE, 1, 6) AS YYYYMM,
                    BASIS_START_DATE
                  FROM SCM_SYS_CALENDAR_M CAL
                 WHERE CAL.BASIS_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                   AND CAL.BASIS_YYYYMMDD <  TO_CHAR(SYSDATE + 52 * 7, 'YYYYMMDD')
             ) CAL
                ON TMP.MM2 = CAL.YYYYMM
             WHERE TO_NUMBER(TMP.LOC) > 0; -- 0 이상만 처리 (빈값 제외)

            COMMIT;

            --5-2)환율데이터 생성
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_EXCH
            (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
            SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
              FROM DM_MST_EXCHANGE_RATE A
              JOIN GT_F020_UPLOAD_MASTER_STEP2 B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.YYYYMMDD    = B.MM2 || '01'
               AND A.CURRENCY    = 'KRW';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_FINAL',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );
            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_EXCH',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            --5-3) CURRENCY가 'KRW', 'USD'일 경우 해당 CURRENCY로 메저생성
            --환율 계산할 필요 없으므로 LOC값 그대로 저장
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                A.LOC, A.MM, A.MM2, A.BASIS_START_DATE,
                A.CURRENCY AS MEASURE
              FROM GT_F020_UPLOAD_MASTER_FINAL A
             WHERE A.MEASURE  = 'LOC'
               AND A.CURRENCY IN ('KRW', 'USD');

            COMMIT;

            --5-4) KRW 메저 생성(기준값)  : 환율금액을 곱하여 KRW 생성
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                TO_CHAR(ROUND(TO_NUMBER(A.LOC) * B.EXCHANGE_PRICE, 3)),
                A.MM, A.MM2, A.BASIS_START_DATE,
                'KRW'
              FROM GT_F020_UPLOAD_MASTER_FINAL A
              JOIN GT_F020_EXCH B
                ON B.UNIT_CURRENCY = A.CURRENCY
               AND B.YYYYMMDD      = A.MM2 || '01'
             WHERE A.MEASURE   = 'LOC'
               AND A.CURRENCY <> 'KRW';

            COMMIT;

            --5-5) USD 메저 생성 : KRW 기준으로 계산
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                TO_CHAR(ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3)),
                A.MM, A.MM2, A.BASIS_START_DATE,
                'USD'
              FROM GT_F020_UPLOAD_MASTER_FINAL A
              JOIN GT_F020_EXCH B
                ON B.UNIT_CURRENCY = 'USD'
               AND B.YYYYMMDD      = A.MM2 || '01'
             WHERE A.MEASURE   = 'KRW'
               AND A.CURRENCY <> 'USD';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_FINAL',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            ----------------------------------------------------
            --6) SCM_MST_FUTURE_PRICE 저장
            ----------------------------------------------------
            MERGE INTO SCM_MST_FUTURE_PRICE A
            USING GT_F020_UPLOAD_MASTER_FINAL B
               ON (
                    A.DIVISION_ID   = B.DIVISION_ID
                AND A.PROJECT_CODE  = B.PROJECT_CODE
                AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND A.ITEM_ID       = B.ITEM_ID
                AND A.YYYYMMDD      = B.BASIS_START_DATE
                AND A.CURRENCY      = B.CURRENCY
                AND A.MEASURE       = B.MEASURE
                AND A.DOM_EXP       = B.DOM_EXP
                AND A.FCST_TYPE     = B.FCST_TYPE
                AND A.INCOTERMS     = B.INCOTERMS
                  )
            WHEN MATCHED THEN
                UPDATE SET
                    A.PRICE            = TO_NUMBER(B.LOC)
                  , A.LAST_UPDATED_BY  = P_CREATED_BY
                  , A.LAST_UPDATE_DATE = SYSDATE
                  , A.ATTRIBUTE8       = 'EXCEL UPLOAD' --엑셀업로드 여부 표시
            WHEN NOT MATCHED THEN
                INSERT (
                    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                    ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                    INCOTERMS, PRICE, CREATED_BY, CREATION_DATE,
                    LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE8
                )
                VALUES (
                    B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID,
                    B.ITEM_ID, B.BASIS_START_DATE, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE,
                    B.INCOTERMS, TO_NUMBER(B.LOC), P_CREATED_BY, SYSDATE,
                    P_CREATED_BY, SYSDATE, 'EXCEL UPLOAD' --엑셀업로드 여부 표시
                );

            N_LOG_COUNT := SQL%ROWCOUNT;

            ----------------------------------------------------
            --7) SCM_MST_FUTURE_PRICE_H 저장
            ----------------------------------------------------
            INSERT INTO SCM_MST_FUTURE_PRICE_H
            (
                DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                INCOTERMS, PRICE, CREATED_BY, CREATION_DATE,
                LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE8
            )
            SELECT
                DIVISION_ID,
                SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL,
                PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                ITEM_ID, BASIS_START_DATE, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                INCOTERMS, TO_NUMBER(LOC), P_CREATED_BY, SYSDATE,
                P_CREATED_BY, SYSDATE,
                'EXCEL UPLOAD' --엑셀업로드 여부 표시
              FROM GT_F020_UPLOAD_MASTER_FINAL;

            COMMIT;

            EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

            ----------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '21';
            V_LOG_MESSAGE := '########## INSERT DMF0020_EXCEL_UPLOAD END ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            ----------------------------------------------------------------------------

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

                V_SQL_CODE   := TO_CHAR(SQLCODE);
                V_SQL_ERRMSG := SQLERRM;
                V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                V_PROC_INPUT := JSON_OBJECT(
                    'P_MODE'       VALUE P_MODE,
                    'P_CREATED_BY' VALUE P_CREATED_BY
                );

                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                        $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION',
                        '', SYSDATE, V_PROC_INPUT,
                        V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
                    );
                END;

                RAISE_APPLICATION_ERROR(-20001,
                    '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
                    ' / SQLERRM=' || V_SQL_ERRMSG ||
                    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                    ' / PARAMS=' || V_PROC_INPUT
                );
                RAISE;
        END;

    END IF; -- END OF p_mode > 0

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## INSERT DATA END ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

    -- 결과 반환 분기
    IF NVL(P_MODE, 0) = 0 THEN
        -- 조회(Validation) 성공: EVENT는 NULL (Case 3 조회 성공 패턴)
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;
    ELSE
        -- DML 성공: EVENT에 처리 건수 반환
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    END IF;

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
            'P_MODE'       VALUE P_MODE,
            'P_CREATED_BY' VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END DMF0020_EXCEL_UPLOAD;
/
