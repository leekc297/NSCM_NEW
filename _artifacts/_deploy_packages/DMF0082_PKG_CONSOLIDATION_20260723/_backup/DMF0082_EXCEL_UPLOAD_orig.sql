CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_EXCEL_UPLOAD" 
(
    p_mode           IN  NUMBER
  , p_created_by     IN  VARCHAR2
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*
 * Program ID   : [DMF0082_EXCEL_UPLOAD]
 * Description  : Fcst&Price MGMT 엑셀 업로드
 * Program History
 *==================================================================================================
 *   Date       In Charge        Description
 *==================================================================================================
 * 2025.05.xx   KJY              최초 작성 (MSSQL)
 * 2026-07-12   Claude           MSSQL dbo.DMF0082_EXCEL_UPLOAD → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *==================================================================================================
 * [변환 노트 — 부록 C 함정 처리]
 *  - @p_mode INT → P_MODE NUMBER (Excel Upload 2-Step 표준: mode=0 검증/분류, mode>0 저장 게이트)
 *  - O_RESULT_CURSOR 추가 (AS-IS 는 결과셋 없음 → TO-BE 2-Step 모달 표준: SUCCESS/ERROR 건수 반환)
 *  - CONVERT(NVARCHAR(40), CREATION_DATE, 121) → TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') 명시 마스크 (C-11)
 *  - ISNULL(x,'')=''  → x IS NULL (C-7: Oracle '' = NULL)
 *  - ISNULL(x,'')<>'' → x IS NOT NULL (C-7)
 *  - ISNULL(MESSAGE_TEXT,'') + ', xxx' → MESSAGE_TEXT || ', xxx' (Oracle 은 NULL || 'x' = 'x')
 *  - 중복 체크의 ISNULL(ATTRIBUTE9,'') 그룹/비교 → NVL(ATTRIBUTE9,'-') 양쪽 정렬
 *    (MSSQL 은 빈문자열('')로 정규화해 비교 — Oracle 에서 '' = NULL 이므로 '-' placeholder 로 동등화, C-7)
 *  - UPDATE ... FROM JOIN (코드 매핑 UPDATE 6종) → 상관 Scalar Subquery + EXISTS (룰 #30, ORA-01779 회피)
 *    매핑이 다중행일 때 MSSQL UPDATE JOIN 은 임의 1행 채택 → Oracle 은 MAX() 로 결정적 채택 (ORA-01427 방지)
 *  - ISNUMERIC(x) → VALIDATE_CONVERSION(x AS NUMBER) (12.2+, 소수/부호 허용 — 룰 44 의 정수 전용 REGEXP 보다 ISNUMERIC 에 근접)
 *  - CONVERT(FLOAT, x) → TO_NUMBER(x DEFAULT NULL ON CONVERSION ERROR)
 *  - EXEC PR_SCM_SYS_LOG_BATCH → SCM_MGR.PR_SCM_SYS_LOG_BATCH(...) (Oracle 시그니처 6 필수 + 4 default)
 *  - @@ROWCOUNT → SQL%ROWCOUNT (UPDATE 직후 즉시 캡처 — MSSQL 의 SET 문 rowcount 리셋 quirk 는 재현하지 않고 원의도 보존)
 *  - SYSDATETIME() → SYSDATE / PRINT → DBMS_OUTPUT.PUT_LINE / WITH(NOLOCK) 제거 / [bracket]·dbo. 제거 / TOP 1 → FETCH FIRST 1 ROWS ONLY
 *  - STRING_SPLIT 첫 token → INSTR/SUBSTR (룰 #5)
 *  - AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록(실행 코드 아님)은 본 파일에 미이관 —
 *    원문 보존본 = asis_DMF0082_EXCEL_UPLOAD.sql 참조 (로직 영향 0)
 *  - AS-IS 숫자/음수/0 체크가 ATTRIBUTE11~19(M4~M12)만 대상(M13~M16 미검증)인 것은 원문 그대로 보존 (임의 확장 금지)
 *  - MSSQL 은 문장별 자동 COMMIT → Oracle 은 검증 UPDATE 확정 위해 정상 종료 시 COMMIT, 예외 시 ROLLBACK
 */
 --EXEC [DMF0082_EXCEL_UPLOAD] '1', 'kjj0070'
IS
    v_program_id      VARCHAR2(40 CHAR)  := 'DMF0082';
    v_sheet_name      VARCHAR2(40 CHAR)  := 'FcstNPrice';
    v_creation_date   VARCHAR2(40 CHAR);
    v_count           NUMBER;
    v_start_yyyymmdd  VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');   --당월 기준+4  (AS-IS: CONVERT(VARCHAR(6),...,112))
    v_end_yyyymmdd    VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM');  --당월 기준+12 (AS-IS: CONVERT(VARCHAR(6),...,112))
    v_division        VARCHAR2(10 CHAR);

    -- LOG 용 변수 설정
    v_log_type        VARCHAR2(30 CHAR);   -- START/END/ERROR/...
    n_log_count       NUMBER := 0;
    v_log_message     VARCHAR2(1000 CHAR);
    v_description     VARCHAR2(500 CHAR);
    d_event_date      DATE;

    -- 결과 카운트
    n_row_cnt         NUMBER := 0;
    n_success_cnt     NUMBER := 0;
    n_error_cnt       NUMBER := 0;

    -- 표준 예외 변수
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(20 CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
BEGIN

/*
1. 40 사업부만 대상으로 한다.
2. Validation Step
    step1. 필수값 확인
    step2. 중복값 확인 (LOC인 경우 currency도 포함하여 중복체크)
    step3. 코드/네임 맵핑 확인
            - 메져 확인(Unit Price(LOC),MKT FCST[R+P])
            - FCST Type
            - Dom/Exp
*/

    V_PROC_INPUT := JSON_OBJECT('p_mode' VALUE p_mode, 'p_created_by' VALUE p_created_by);

    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by
    AND    T.UPLOAD_STATUS_CODE = 'UPLOAD';

    IF v_creation_date IS NULL THEN
        v_log_type    := 'END';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Data Not Found [' || NVL(SUBSTR(v_creation_date, 1, 19), '') || ']';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

    /* SELECT TOP 1 @v_division = ATTRIBUTE1 ... */
    BEGIN
        SELECT ATTRIBUTE1
        INTO   v_division
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    ATTRIBUTE1 != 'Div'
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

    -- @p_mode = 0 이면 Validation
    IF NVL(p_mode, 0) = 0 THEN

        DBMS_OUTPUT.PUT_LINE(v_division);   /* AS-IS: PRINT @v_division */

        ------------------------------------------------------------------------
        -- RESET Status = UPLOAD
        ------------------------------------------------------------------------
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
        SET    T.UPLOAD_STATUS_CODE = 'UPLOAD'
             , T.MESSAGE_TEXT       = NULL
        WHERE  T.PROGRAM_ID = v_program_id
        AND    T.SHEET_NAME = v_sheet_name
        AND    T.CREATED_BY = p_created_by
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;
        --AND    NVL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD'

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := '1';
        v_log_message := '########## RESET Status = UPLOAD ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        ------------------------------------------------------------------------
        -- @TITLE Header Line
        ------------------------------------------------------------------------
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 2, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := '2';
        v_log_message := '########## TITLE Header Line ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        --본격적 VALIDATION 시작

        /* ####################################################
         필수 값 NULL 값 체크
        ATTRIBUTE1  Div*
        ATTRIBUTE2  End Customer*
        ATTRIBUTE3  Sales Site*
        ATTRIBUTE4  Model*
        ATTRIBUTE5  Incoterms*
        ATTRIBUTE6  FCST Type*
        ATTRIBUTE7  Customs Handbook*
        ATTRIBUTE8  Cell Prod Site*
        ATTRIBUTE9  Currency*
        ATTRIBUTE10 Measure*
         #################################################### */
        --Div   Team    End Customer    Project Code    Currency
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN ATTRIBUTE1  IS NULL THEN 'NULL Div'
                                         WHEN ATTRIBUTE2  IS NULL THEN 'NULL End Customer'
                                         WHEN ATTRIBUTE3  IS NULL THEN 'NULL Sales Site'
                                         WHEN ATTRIBUTE4  IS NULL THEN 'NULL Model'
                                         WHEN ATTRIBUTE5  IS NULL THEN 'NULL Incoterms'
                                         WHEN ATTRIBUTE6  IS NULL THEN 'NULL FCST Type'
                                         WHEN ATTRIBUTE7  IS NULL THEN 'NULL Customs Handbook'
                                         WHEN ATTRIBUTE8  IS NULL THEN 'NULL Cell Prod Site'
                                         WHEN (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL) THEN 'NULL Currency'  --MEAUSRE가 Unit Price(LOC) 때만 필수값
                                         WHEN ATTRIBUTE10 IS NULL THEN 'NULL Measure'
                                    END
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (   ATTRIBUTE1  IS NULL
                OR ATTRIBUTE2  IS NULL
                OR ATTRIBUTE3  IS NULL
                OR ATTRIBUTE4  IS NULL
                OR ATTRIBUTE5  IS NULL
                OR ATTRIBUTE6  IS NULL
                OR ATTRIBUTE7  IS NULL
                OR ATTRIBUTE8  IS NULL
                OR (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL)
                OR ATTRIBUTE10 IS NULL
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## ERROR NULL Column Data ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* ####################################################
        Key기준 중복 체크
        ATTRIBUTE1  Div*        ~ ATTRIBUTE10 Measure*
        (C-7) MSSQL ISNULL(ATTRIBUTE9,'') 정규화 → Oracle NVL(ATTRIBUTE9,'-') 양쪽 정렬
        #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Duplication Model.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    EXISTS (SELECT 1
                       FROM  (--Unit Price(LOC) 외 메저는 Currency NULL
                              SELECT X.ATTRIBUTE1           AS COL1   --Div
                                   , X.ATTRIBUTE2           AS COL2   --End Customer
                                   , X.ATTRIBUTE3           AS COL3   --Sales Site
                                   , X.ATTRIBUTE4           AS COL4   --Modele
                                   , X.ATTRIBUTE5           AS COL5   --Incoterms
                                   , X.ATTRIBUTE6           AS COL6   --FCST Type
                                   , X.ATTRIBUTE7           AS COL7   --Customs Handbook
                                   , X.ATTRIBUTE8           AS COL8   --Cell Prod Site
                                   , NVL(X.ATTRIBUTE9, '-') AS COL9   --Currency
                                   , X.ATTRIBUTE10          AS COL10  --Measure
                              FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                              WHERE  X.PROGRAM_ID = v_program_id
                              AND    X.SHEET_NAME = v_sheet_name
                              AND    X.CREATED_BY = p_created_by
                              AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                              AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                              GROUP BY X.ATTRIBUTE1
                                     , X.ATTRIBUTE2
                                     , X.ATTRIBUTE3
                                     , X.ATTRIBUTE4
                                     , X.ATTRIBUTE5
                                     , X.ATTRIBUTE6
                                     , X.ATTRIBUTE7
                                     , X.ATTRIBUTE8
                                     , NVL(X.ATTRIBUTE9, '-')
                                     , X.ATTRIBUTE10
                              HAVING COUNT(*) > 1
                             ) T
                       WHERE 1 = 1
                       AND   T.COL1  = A.ATTRIBUTE1
                       AND   T.COL2  = A.ATTRIBUTE2
                       AND   T.COL3  = A.ATTRIBUTE3
                       AND   T.COL4  = A.ATTRIBUTE4
                       AND   T.COL5  = A.ATTRIBUTE5
                       AND   T.COL6  = A.ATTRIBUTE6
                       AND   T.COL7  = A.ATTRIBUTE7
                       AND   T.COL8  = A.ATTRIBUTE8
                       AND   T.COL9  = NVL(A.ATTRIBUTE9, '-')
                       AND   T.COL10 = A.ATTRIBUTE10
                      );

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := 'UPDATE';
        v_log_message := '########## ERROR Model Duplication ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* DIVISION  체크                                        */
        --사업부 40 만 대상으로 함
        -- ATTRIBUTE1   Div (검증전)
        -- ATTRIBUTE301 Div (검증후) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE301 = A.ATTRIBUTE1
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE1 = '40';

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ',Invalid Division(40 Only).'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE301 IS NULL;

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := 'UPDATE';
        v_log_message := '########## Invalid Division ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* END CUSTOMER 체크                                     */
        --ATTRIBUTE2    End Customer (Name)
        --ATTRIBUTE302  End Customer (Code) - SYSTEM UPDATE
        /* #################################################### */
        -- (룰 #30) MSSQL UPDATE JOIN → 상관 Scalar Subquery + EXISTS. 다중 매핑 시 MAX(CODE) 결정적 채택.
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE302 = (SELECT MAX(EC.CODE)
                                 FROM  (SELECT DISTINCT SI.PROJECT_CODE AS CODE
                                             , NVL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME
                                        FROM   SCM_MGR.SCM_MST_SITE_ITEM SI
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO UI
                                            ON SI.OWNER = UI.USER_ID
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DI
                                            ON UI.DEPT_ID = DI.DEPT_ID
                                        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                                            ON  SI.DIVISION_ID  = D.SEGMENT1
                                            AND SI.PROJECT_CODE = D.SEGMENT2
                                            AND D.LOOKUP_TYPE   = 'END_CUSTOMER'
                                            AND D.VALID_YN      = 'Y'
                                        /* (룰 #5) STRING_SPLIT 첫 token → INSTR/SUBSTR */
                                        WHERE  UI.USER_ID = CASE WHEN INSTR(SI.OWNER, ',') = 0 THEN SI.OWNER
                                                                 ELSE SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1) END
                                        AND    UI.DEPT_ID     = DI.DEPT_ID
                                        AND    SI.DIVISION_ID = '40'
                                        AND    SI.VALID_YN    = 'Y'
                                        UNION
                                        SELECT SEGMENT2 AS CODE
                                             , SEGMENT3 AS NAME
                                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                        WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
                                        AND    SEGMENT2 <> '-'
                                        AND    VALID_YN = 'Y'
                                        AND    SEGMENT1 = '40') EC
                                 WHERE EC.NAME = A.ATTRIBUTE2)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE2 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid End Customer'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE302 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* SALES SITE 체크                                       */
        --ATTRIBUTE3    Sales Site (Name)
        --ATTRIBUTE303  Sales Site (Code) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE303 = (SELECT MAX(MS.SCM_SITE_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 WHERE  MS.SITE_TYPE   = 'SALES'
                                 AND    MS.VALID_YN    = 'Y'
                                 AND    MS.DIVISION_ID = '40'
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE3)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE3 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Sales Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE303 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* END CUSTOMER / SALES SITE Mapping 체크                */
        --ATTRIBUTE2    End Customer (Name)
        --ATTRIBUTE3    Sales Site   (Name)
        --ATTRIBUTE302  End Customer (Code) - SYSTEM UPDATE
        --ATTRIBUTE303  Sales Site   (Code) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Invalid End Customer/Sales Site.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.SCM_MST_SITE MS
                           LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
                               ON  MS.DIVISION_ID = SI.DIVISION_ID
                               AND MS.SCM_SITE_ID = SI.SCM_SITE_ID
                           WHERE  1 = 1
                           AND    MS.SITE_TYPE    = 'SALES'
                           AND    MS.VALID_YN     = 'Y'
                           AND    MS.DIVISION_ID  = '40'
                           AND    SI.PROJECT_CODE = A.ATTRIBUTE302
                           AND    MS.SCM_SITE_ID  = A.ATTRIBUTE303
                          );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* MODEL 체크                                            */
        -- ATTRIBUTE4    Model*
        -- ATTRIBUTE304  Model* - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE304 = (SELECT MAX(MS.ITEM_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE_ITEM MS
                                 INNER JOIN SCM_MGR.SCM_MST_ITEM_SN SN
                                     ON  MS.DIVISION_ID = SN.DIVISION_ID
                                     AND MS.ITEM_ID     = SN.ITEM_ID
                                     AND SN.ACTIVE_FLAG = 'Y'
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301  --Div
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303  --Sales Site
                                 AND    MS.ITEM_ID     = A.ATTRIBUTE4    --Model
                                 AND    MS.VALID_YN    = 'Y')
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE4 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Model.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE304 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid MODEL ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* INCOTERMS 체크                                        */
        -- ATTRIBUTE5   Incoterms*
        -- ATTRIBUTE305 Incoterms*  - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE305 = (SELECT MAX(L.SEGMENT2)          /* LV.NAME */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'INCOTERMS'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE5)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE5 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Incoterms.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE305 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid INCOTERMS ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* FCST TYPE 체크                                        */
        -- ATTRIBUTE6   Fcst Type (NAME)
        -- ATTRIBUTE306 Fcst Type (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE306 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                 AND    NVL(L.ATTRIBUTE2, '-') <> 'Y'    --AS전용여부 (C-7: ISNULL(x,'')<>'Y')
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE6)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE6 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Fcst Type'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE306 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid FCST TYPE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* Customs Handbook 체크                                 */
        -- ATTRIBUTE7    Customs Handbook*
        -- ATTRIBUTE307  Customs Handbook* --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE307 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'DM_CUSTOMS_HANDBOOK_40'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE7)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE7 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Customs Handbook'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE307 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Customs Handbook ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* Cell Prod Site 체크                                   */
        -- ATTRIBUTE8    Cell Prod Site (NAME)
        -- ATTRIBUTE308  Cell Prod Site (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE308 = (SELECT MAX(M.SEGMENT1)
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
                                 WHERE  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
                                 AND    M.VALID_YN    = 'Y'
                                 AND    M.ATTRIBUTE1  = A.ATTRIBUTE8)    ---CELL PROD SITE
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE8 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Cell Prod Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE308 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Cell Prod Site ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* MEASURE 체크                                          */
        -- ATTRIBUTE10   Measure
        --               LOC      : Unit Price(LOC)
        --               MKT_FCST : MKT FCST[R+P]
        -- ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE310 = (SELECT MAX(L.SEGMENT3)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                     ON  L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
                                     AND L.SEGMENT1    = 'DMF0082'      -- PROGROM_ID
                                     AND L.VALID_YN    = 'Y'            -- 사용여부
                                     AND L.ATTRIBUTE1  = 'Y'            -- INSERT_YN 여부
                                     AND L.SEGMENT2    = MS.DIVISION_ID
                                     AND (
                                          ( NVL(MS.VMI_YN,'N') = 'N' AND L.ATTRIBUTE3 <> 'Y' )  -- SCM_MST_SITE에 데이터가 없으면서 VMI_YN이 Y가 아닌 경우.
                                          OR
                                          ( NVL(MS.VMI_YN,'N') = 'Y' )  -- SCM_MST_SITE에 데이터가 있을 경우.
                                          --두개 중에서 하나라도 걸린다면 가져온다.
                                         )
                                     AND L.SEGMENT4    = A.ATTRIBUTE10  --MEASURE Name
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301   --DIV
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303)  --Sales Site
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE10 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Measure'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE310 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* CURRENCY 체크                                         */
        -- ATTRIBUTE9  Currency
        -- ATTRIBUTE10 Measure 가 Unit Price(LOC) 인 대상으로만 통화 체크
        --ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE309 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'CURRENCY_LIST'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE9)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(A.ATTRIBUTE310, '-') = 'LOC';   --MEASURE가 LOC인 대상으로만. (C-7)

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid CURRENCY.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(ATTRIBUTE310, '-') = 'LOC'      --MEASURE가 LOC인 대상으로만. (C-7)
        AND    ATTRIBUTE309 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 숫자여부 체크                                         */
        -- (룰 44) ISNUMERIC(x)=0 → VALIDATE_CONVERSION(x AS NUMBER)=0
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid NUMERIC.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 0)    --M12
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid NUMERIC. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 마이너스 여부 체크                                    */
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Negative Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) < 0)    --M12
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Negative Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 0 여부 체크                                           */
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Zero Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) = 0)    --M12
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Zero Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 정상(SUCCESS) 처리
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        ----------------------------------------------------------------------------
        v_log_type    := '16';
        v_log_message := '########## SUCCESS ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* [변환 노트] AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록
           (#FCST_PRICE_EXCEL/#FCST_PRICE_UNPIVOT/#FCST_PRICE_BUCKET/#FCST_PRICE_WEEKLY 데일리 분배 시험 쿼리)
           은 실행 코드가 아니므로 미이관 — 원문 = asis_DMF0082_EXCEL_UPLOAD.sql 보존. 실 로직은
           DMF0082_GET_EXCEL_UPLOAD_DATA (02 파일) 에 정식 구현되어 있음. */

    END IF;

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    ----------------------------------------------------------------------------
    v_log_type    := '21';
    v_log_message := '########## INSERT DMF0028_EXCEL_UPLOAD END ##########';
    v_description := TO_CHAR(p_mode);   --CONVERT(CHAR(30), @v_creation_date, 121);
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ----------------------------------------------------------------------------
    -- 결과코드 반환 (TO-BE 2-Step 표준: 검증분류 결과 건수)
    ----------------------------------------------------------------------------
    SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
         , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
    INTO   n_success_cnt, n_error_cnt
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
    WHERE  PROGRAM_ID = v_program_id
    AND    SHEET_NAME = v_sheet_name
    AND    CREATED_BY = p_created_by
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT CASE WHEN n_error_cnt > 0 THEN '1' ELSE '0' END AS RESULT_CODE
             , 'SUCCESS=' || TO_CHAR(n_success_cnt) || ', ERROR=' || TO_CHAR(n_error_cnt) AS RESULT_MSG
             , TO_CHAR(NVL(p_mode, 0)) AS EVENT
        FROM   DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END DMF0082_EXCEL_UPLOAD;