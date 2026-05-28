-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0014 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0014.P_{SP_NAME}
-- ============================================================================


-- DMF0014_CUST_FCST_EXCEL_UPLOAD → PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0014_CUST_FCST_EXCEL_UPLOAD
(
	p_mode		    INTEGER,
	p_created_by    VARCHAR2,
	O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD
 * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	  KDW2819	 [C20221024-000507]CUST FCST Upload 오류 수정
 * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
 * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
 * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
 * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 */
 --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
AS

    v_in_para_data VARCHAR2(4000);
    v_program_id VARCHAR2(40 CHAR) := 'DMF0014';
    v_sheet_name VARCHAR2(40 CHAR) := 'FCST Upload';
    v_sql_text VARCHAR2(4000 CHAR);
    v_creation_date VARCHAR2(40 CHAR);
    v_count INTEGER;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_end_yyyymmdd VARCHAR2(8 CHAR);
    v_division VARCHAR2(10 CHAR);
    v_program_name VARCHAR2(200) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_step           VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    v_in_para_data := JSON_OBJECT(
        'p_mode' VALUE p_mode,
        'p_created_by' VALUE p_created_by
    );

    NULL;

	-- LOG 용 변수 설정
	v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
  INTO v_creation_date
	FROM   SCM_ADM_EXCEL_UPLOAD T
	WHERE  T.PROGRAM_ID = v_program_id
	AND    T.SHEET_NAME = v_sheet_name
	AND    T.CREATED_BY = p_created_by;
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
	IF v_creation_date IS NULL THEN
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'Data Not Found ['  ||  TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3')  || ']';
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    END IF;

 --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
		BEGIN
			SELECT ATTRIBUTE1 INTO v_division
    FROM SCM_ADM_EXCEL_UPLOAD
			WHERE  PROGRAM_ID    = v_program_id
			AND    SHEET_NAME    = v_sheet_name
			AND    CREATED_BY    = p_created_by
			AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
			--AND    UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
FETCH FIRST 1 ROWS ONLY;
		END;

	-- p_mode = 0 이면 Validation
	IF NVL(p_mode, 0) = 0 THEN
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD T
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL
		WHERE  T.PROGRAM_ID    = v_program_id
        AND    T.SHEET_NAME    = v_sheet_name
        AND    T.CREATED_BY    = p_created_by
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    NVL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
    	END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
	    v_log_type := '1';
	    v_log_message := '########## RESET Status = UPLOAD ##########';
	    v_description := p_mode;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
	    UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID    = v_program_id
        AND    SHEET_NAME    = v_sheet_name
        AND    CREATED_BY    = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    (   ATTRIBUTE1  IS NULL
	            OR LENGTH(ATTRIBUTE1) = 0
	            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
		END;

	    BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
		v_log_type := '2';
		v_log_message := '########## SKIP EMPTY LINE ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'V_TITLE'
        WHERE  PROGRAM_ID    = v_program_id
        AND    SHEET_NAME    = v_sheet_name
        AND    CREATED_BY    = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
        END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		v_log_type := '3';
		v_log_message := '########## TITLE Header Line ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Key.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND EXISTS (SELECT 1
		            FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                , X.ATTRIBUTE2 COL2
                                , X.ATTRIBUTE3 COL3
                                , X.ATTRIBUTE4 COL4
                                , X.ATTRIBUTE5 COL5
                                , X.ATTRIBUTE6 COL6
                                , X.ATTRIBUTE7 COL7
                                , X.ATTRIBUTE8 COL8
 	                            , X.ATTRIBUTE9 COL9
			                    , X.ATTRIBUTE10 COL10
								--, X.ATTRIBUTE11 COL11
								--, X.ATTRIBUTE12 COL12
                           FROM   SCM_ADM_EXCEL_UPLOAD X
                           WHERE  X.PROGRAM_ID    = v_program_id
                           AND    X.SHEET_NAME    = v_sheet_name
                           AND    X.CREATED_BY    = p_created_by
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
		                          , X.ATTRIBUTE9
			                      , X.ATTRIBUTE10
								  --, X.ATTRIBUTE11
								  --, X.ATTRIBUTE12
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
                    AND T.COL5 = ATTRIBUTE5
                    AND T.COL6 = ATTRIBUTE6
                    AND T.COL7 = ATTRIBUTE7
                    AND T.COL8 = ATTRIBUTE8
			        AND T.COL9  =ATTRIBUTE9
		            AND T.COL10 = ATTRIBUTE10
					--AND T.COL11 = ATTRIBUTE11
					--AND T.COL12 = ATTRIBUTE12
				   );
		END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		v_log_type := '4';
		v_log_message := '########## ERROR Key Duplication ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Division.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
						union
						SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					   );
		END;

		BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    ATTRIBUTE1 = (
								SELECT D.DIVISION_ID
								FROM   SCM_MST_DIVISION D
								WHERE  D.VALID_YN    = 'Y'
								AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
		                     )
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					   );
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload Bucket.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D
						      ,SCM_MST_DIVISION     D2
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						AND   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    D.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						AND    D.UPLOAD_BUCKET_TYPE IN (
						                                    SELECT CASE (TO_DATE(Z.ATTRIBUTE15,'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14,'YYYYMMDD'))  WHEN 1 THEN 'DAILY' WHEN 7 THEN 'WEEKLY' ELSE 'MONTHLY' END
														    FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                            WHERE  Z.PROGRAM_ID = v_program_id
															AND    Z.SHEET_NAME = v_sheet_name
															AND    Z.CREATED_BY = p_created_by
															AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
															AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'
						                                 )
						);
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload UOM.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D
						      ,SCM_MST_DIVISION     D2
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    D.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						AND    D.UPLOAD_UOM =  SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
						);
		END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
		v_log_type := '5';
	    v_log_message := '########## Invalid Division ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Scm Site.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S
						      ,SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		v_log_type := '6';
	    v_log_message := '########## Invalid Scm Site. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Plant Site.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    (ATTRIBUTE1 =  '81' or ATTRIBUTE1 = 'Automotive Battery')  -- ess는 제외
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S
						      ,SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		v_log_type := '6';
	    v_log_message := '########## Invalid Plant Site. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Project.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
		v_log_type := '7';
	    v_log_message := '########## Invalid Customer Project ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		IF v_division != '40' THEN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Model.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
						      ,SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    CM.VALID_YN              = 'Y'
						UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM si
						      ,SCM_MST_DIVISION D3
                        WHERE  si.DIVISION_ID = D3.DIVISION_ID
					    AND    si.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    si.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    si.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						and   ( D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    si.VALID_YN              = 'Y'
						);
		END IF;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
		v_log_type := '8';
	    v_log_message := '########## Invalid Customer Model ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Incoterms.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
						AND    L.LOOKUP_TYPE = 'INCOTERMS'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '10';
		v_log_message := '########## Invalid Incoterms. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Type.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
						union
						SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
					   );
		END;

		BEGIN -- validation이 끝났으니 code로 update
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    ATTRIBUTE7 = (
							SELECT D.SEGMENT1
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
							WHERE  D.VALID_YN    = 'Y'
							AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							AND    D.SEGMENT2    = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
		                    )
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
					   );
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '11';
		v_log_message := '########## Invalid Sales Type. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customs Handbook'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
						AND    L.LOOKUP_TYPE = 'DOM/EXP'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '12';
		v_log_message := '########## Invalid DOM/EXP. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Group.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
						AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
						AND    L.SEGMENT1 = 'CUST_FCST'
						AND    L.VALID_YN    = 'Y');
		END;

		--20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
	    v_log_type := '12';
	    v_log_message := '########## Invalid Alphabet, NUMBER. ##########';
	    v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		-- ---------------------------------------------------------------------
	    END;

	    --문자열 체크

		MERGE INTO SCM_ADM_EXCEL_UPLOAD A
		USING (
			SELECT * FROM (SELECT UPLOAD_ID, SUM(CASE WHEN REGEXP_LIKE(VALUE, '^-?[0-9]*\.?[0-9]+$') THEN 0 ELSE 1 END) PRICE
			FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
			FROM SCM_ADM_EXCEL_UPLOAD
			WHERE 1 = 1
			AND PROGRAM_ID    = v_program_id
			AND SHEET_NAME    = v_sheet_name
			AND CREATED_BY    = p_created_by
			AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND UPLOAD_STATUS_CODE = 'UPLOAD') T
			UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) X
			WHERE 1 = 1
			AND LTRIM(RTRIM(VALUE)) IS NOT NULL
			AND VALUE != '0'
			AND VALUE IS NOT NULL GROUP BY UPLOAD_ID) B
		) SRC_UPD
		ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND 1 = 1 AND PROGRAM_ID    = v_program_id AND SHEET_NAME    = v_sheet_name AND CREATED_BY    = p_created_by AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date AND UPLOAD_STATUS_CODE = 'UPLOAD')
		WHEN MATCHED THEN
		UPDATE SET UPLOAD_STATUS_CODE = 'ERROR'
				   , MESSAGE_TEXT = 'This file contains invalid quantity data such as ‘Alphabet’, ‘NUMBER’, etc. (e.g. a, b, c, 130.2, 50.4 …).';

	    --소수점 체크

		MERGE INTO SCM_ADM_EXCEL_UPLOAD A
		USING (
			SELECT * FROM (SELECT UPLOAD_ID, SUM(CASE WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE
			FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
			FROM SCM_ADM_EXCEL_UPLOAD
			WHERE 1 = 1
			AND PROGRAM_ID = v_program_id
			AND SHEET_NAME    = v_sheet_name
			AND CREATED_BY    = p_created_by
			AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND UPLOAD_STATUS_CODE = 'UPLOAD') T
			UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) X
			WHERE 1 = 1
			AND LTRIM(RTRIM(VALUE)) IS NOT NULL
			AND VALUE != '0'
			AND VALUE IS NOT NULL
			GROUP BY UPLOAD_ID) B
		) SRC_UPD
		ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND 1 = 1 AND PROGRAM_ID = v_program_id AND SHEET_NAME    = v_sheet_name AND CREATED_BY    = p_created_by AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date AND UPLOAD_STATUS_CODE = 'UPLOAD')
		WHEN MATCHED THEN
		UPDATE SET UPLOAD_STATUS_CODE = 'ERROR'
				   , MESSAGE_TEXT = 'This file contains invalid quantity data such as ‘Alphabet’, ‘NUMBER’, etc. (e.g. a, b, c, 130.2, 50.4 …).';

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '13';
		v_log_message := '########## Invalid Measure Group. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
						AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '14';
		v_log_message := '########## Invalid Upload UOM. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		-- Upload UOM by Model
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM Costpmer FCST.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF
						      ,SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
					    AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    CF.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    CF.VALID_YN    = 'Y');

		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '15';
		v_log_message := '########## Invalid Upload UOM Costpmer FCST. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		/*
		BEGIN
	    UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Project.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '16';
		v_log_message := '########## Invalid Project. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Model.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
						AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '17';
	    v_log_message := '########## Invalid Model. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3')  = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END;

		BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	    v_log_type := '16';
	    v_log_message := '########## SUCCESS ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

	END IF;

	BEGIN
    -- -------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	v_log_type := '17';
	v_log_message := '########## INSERT INTO DATA START ##########';
	v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    -- -------------------------------------------------------------------------
	END;

	--// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT COUNT(1)
  INTO v_count
    FROM   SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID         = v_program_id
    AND    T.SHEET_NAME         = v_sheet_name
    AND    T.CREATED_BY         = p_created_by
    AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

DBMS_OUTPUT.PUT_LINE(v_count);  --20240604 SM

	-- Update Mode and No Errors
	IF p_mode > 0 AND v_count = 0 THEN
		BEGIN
		v_start_yyyymmdd := NULL;
	    v_end_yyyymmdd := NULL;
		END;

		BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '18';
		v_log_message := '########## DELETE FROM DATE START ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

DBMS_OUTPUT.PUT_LINE('TTTTTTT1');  --20240604 SM

		BEGIN
		SELECT D.MIN_YYYYMMDD,
    D.MAX_YYYYMMDD
  INTO v_start_yyyymmdd, v_end_yyyymmdd
		FROM  (
		       SELECT MIN(YYYYMMDD) MIN_YYYYMMDD
		            , MAX(YYYYMMDD) MAX_YYYYMMDD
               FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
	                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
	                 , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
	                 , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
		             , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
		             , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
		             , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
		             , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
		             , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
		             , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
		             , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
	                 , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
		             , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
	                 , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
		             , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
	                 , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
		             , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
	                 , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
		             , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
	                 , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
	                 , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
	                 , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
		             , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
		             , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
		             , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
		             , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
		             , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
		             , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
		             , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
	                 , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
		             , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
	                 , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
		             , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
	                 , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
		             , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
	                 , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                FROM   SCM_ADM_EXCEL_UPLOAD
		        WHERE  1 = 1
		        AND    PROGRAM_ID    = v_program_id
	            AND    SHEET_NAME    = v_sheet_name
		        AND    CREATED_BY    = p_created_by
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
		        AND    UPLOAD_STATUS_CODE = 'V_TITLE'
               ) T
       UNPIVOT (    YYYYMMDD
                FOR COLUMN_NAME
		        IN   ( --ATTRIBUTE12, ATTRIBUTE13,   20240605 SM임시조치
				       ATTRIBUTE14, ATTRIBUTE15
			         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
	                 , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
	                 , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
	                 , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
	                 , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
				     , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
	                 , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
	                 , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
	                 , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
	                 , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
	                 , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
	                 , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
	                 , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
				     )
		           ) X
		WHERE X.YYYYMMDD IS NOT NULL
		) D;
        END;

		BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '19-1';
		v_log_message := '########## DELETE FROM DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

				-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
			BEGIN

        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '20-1';
		v_log_message := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
			DELETE FROM DM_PLN_CUSTOMER_PSI
			WHERE  1 = 1
			AND    MEASURE_GROUP = 'CUST_FCST'
			-- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
			AND    (
			          SELECT  count(1)
						FROM   SCM_ADM_EXCEL_UPLOAD T
						WHERE  T.PROGRAM_ID         = v_program_id
						AND    T.SHEET_NAME         = v_sheet_name
						AND    T.CREATED_BY         = p_created_by
						AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
						AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
						AND   DM_PLN_CUSTOMER_PSI.DIVISION_ID           =  T.ATTRIBUTE1
						AND   DM_PLN_CUSTOMER_PSI.SCM_SITE_ID           =  T.ATTRIBUTE2
						AND   DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID         =  T.ATTRIBUTE3
						AND   DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE =  T.ATTRIBUTE4
						AND   DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL        =  T.ATTRIBUTE5
						AND   DM_PLN_CUSTOMER_PSI.INCOTERMS             =  T.ATTRIBUTE6
						AND   DM_PLN_CUSTOMER_PSI.FCST_TYPE             =  T.ATTRIBUTE7
						AND   DM_PLN_CUSTOMER_PSI.DOM_EXP               =  T.ATTRIBUTE8
						AND   DM_PLN_CUSTOMER_PSI.MEASURE               =  T.ATTRIBUTE10
			       ) > 0
			AND    YYYYMMDD BETWEEN v_start_yyyymmdd AND v_end_yyyymmdd;

        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '20';
		v_log_message := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
			END;
DBMS_OUTPUT.PUT_LINE('20');



			-- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
			UPDATE SCM_ADM_EXCEL_UPLOAD AA
			SET		ATTRIBUTE10 = (
				SELECT BB.MEASURE FROM (
				SELECT DISTINCT
					A.DIVISION_ID
					, B.DIVISION_NAME
					, A.SCM_SITE_ID
					, A.VALID_YN
					, A.MEASURE
					, A.UPLOAD_UOM
					, A.UPLOAD_BUCKET_TYPE
				FROM DM_MST_CUSTOMER_FCST A
				INNER JOIN SCM_MST_DIVISION B
				ON A.VALID_YN		= 'Y'
				AND A.DIVISION_ID	= B.DIVISION_ID
			) BB
			WHERE ( BB.DIVISION_ID = AA.ATTRIBUTE1 OR  BB.DIVISION_NAME = AA.ATTRIBUTE1  )
			AND  BB.SCM_SITE_ID = AA.ATTRIBUTE2
			AND  BB.MEASURE     = AA.ATTRIBUTE10
			AND  BB.UPLOAD_UOM	= AA.ATTRIBUTE11
			AND	 BB.UPLOAD_BUCKET_TYPE IN (

					SELECT CASE (TO_DATE(Z.ATTRIBUTE15,'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14,'YYYYMMDD'))	WHEN 1 THEN 'DAILY'
																														WHEN 7 THEN 'WEEKLY'
																														ELSE 'MONTHLY' END
					FROM   SCM_ADM_EXCEL_UPLOAD Z
					WHERE  Z.PROGRAM_ID = v_program_id
					AND    Z.SHEET_NAME = v_sheet_name
					AND    Z.CREATED_BY = p_created_by
					AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
					AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'
			)
			AND ROWNUM = 1)
			WHERE AA.PROGRAM_ID = v_program_id
			AND   AA.SHEET_NAME = v_sheet_name
			AND   AA.CREATED_BY = p_created_by
			AND   AA.UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

			INSERT INTO DM_PLN_CUSTOMER_PSI
			(
				DIVISION_ID
			  , SCM_SITE_ID
			  , PLANT_SITE_ID
			  , CUSTOMER_PROJECT_CODE
			  , CUSTOMER_MODEL
			  , INCOTERMS
			  , FCST_TYPE
			  , DOM_EXP
			  , MEASURE_GROUP
			  , MEASURE
			  , UPLOAD_UOM
			  , PROJECT_CODE
			  , ITEM_ID
			  , YYYYMMDD
			  , QTY
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			  , BATCH_RESULT
			)
			SELECT V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, V.ATTRIBUTE4, V.ATTRIBUTE5
				 , V.ATTRIBUTE6, V.ATTRIBUTE7, V.ATTRIBUTE8, V.ATTRIBUTE9, V.ATTRIBUTE10
				 , V.ATTRIBUTE11, V.ATTRIBUTE12, V.ATTRIBUTE13
				 , C.YYYYMMDD  , TO_NUMBER(V.VALUE), p_created_by, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
				 , p_created_by, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'), 'UI'
			FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
						, COLUMN_NAME, YYYYMMDD
				   FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
								, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
		               			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
		               			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
		               			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
	                  			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
						   FROM   SCM_ADM_EXCEL_UPLOAD
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = v_program_id
						   AND    SHEET_NAME    = v_sheet_name
						   AND    CREATED_BY    = p_created_by
						   -- modified by ytchoi 180305
						  -- AND    CREATION_DATE = v_creation_date
						   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') =  v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'V_TITLE'
						  ) T
				  UNPIVOT (    YYYYMMDD
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
								)
						  ) X
				  ) C
				, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
						, COLUMN_NAME, VALUE
				   FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
								, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
						   FROM   SCM_ADM_EXCEL_UPLOAD
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = v_program_id
						   AND    SHEET_NAME    = v_sheet_name
						   AND    CREATED_BY    = p_created_by
						   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
						  ) T
				  UNPIVOT (    VALUE
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
								)
							) X
				  ) V
			WHERE 1 = 1
			AND   C.COLUMN_NAME = V.COLUMN_NAME
			AND   C.YYYYMMDD IS NOT NULL
			AND   V.VALUE IS NOT NULL;

DBMS_OUTPUT.PUT_LINE('21');
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '21';
		v_log_message := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		    IF (v_division = '40') THEN
				PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
			ELSE
DBMS_OUTPUT.PUT_LINE('20240605-');
				PR_DM_PLN_CUST_FCST_TO_MKT_FCST;
	        END IF;

		    COMMIT;
        -- END TRY


    -- -------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	v_log_type := 'END';
	v_log_message := '########## INSERT INTO DATA END ##########';
	v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    -- -------------------------------------------------------------------------

	END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(
            v_program_name, 'ERROR', 0, SQLERRM, NULL, SYSDATE,
            p_in_para_data => v_in_para_data,
            p_sql_err_code => SQLCODE,
            p_sql_err_msg  => SQLERRM,
            p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || v_program_name || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
END;
/

-- DMF0014_CUST_FCST_EXCEL_UPLOAD_SM → PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
(
	p_mode		   INTEGER,
	p_created_by  VARCHAR2,
	O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
 * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	  KDW2819	 [C20221024-000507]CUST FCST Upload 오류 수정
 * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
 * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
 * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
  * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 */
 --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
AS

    v_in_para_data VARCHAR2(4000);
    v_step           VARCHAR2(4000 CHAR) := NULL;
    v_program_id VARCHAR2(40 CHAR) := 'DMF0014';
    v_sheet_name VARCHAR2(40 CHAR) := 'FCST Upload';
    v_sql_text VARCHAR2(4000 CHAR);
    v_creation_date VARCHAR2(40 CHAR);
    v_count INTEGER;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_end_yyyymmdd VARCHAR2(8 CHAR);
    v_division VARCHAR2(10 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    v_in_para_data := JSON_OBJECT(
        'p_mode' VALUE p_mode,
        'p_created_by' VALUE p_created_by
    );

	-- LOG 용 변수 설정
	v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
  INTO v_creation_date
	FROM   SCM_ADM_EXCEL_UPLOAD T
	WHERE  T.PROGRAM_ID = v_program_id
	AND    T.SHEET_NAME = v_sheet_name
	AND    T.CREATED_BY = p_created_by;
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
	IF v_creation_date IS NULL THEN
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'Data Not Found ['  ||  TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3')  || ']';
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    END IF;

 --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
		BEGIN
			SELECT ATTRIBUTE1 INTO v_division
    FROM SCM_ADM_EXCEL_UPLOAD
			WHERE  PROGRAM_ID    = v_program_id
			AND    SHEET_NAME    = v_sheet_name
			AND    CREATED_BY    = p_created_by
			AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
			--AND    UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
FETCH FIRST 1 ROWS ONLY;
		END;

	-- p_mode = 0 이면 Validation
	IF NVL(p_mode, 0) = 0 THEN
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD T
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL
		WHERE  T.PROGRAM_ID    = v_program_id
        AND    T.SHEET_NAME    = v_sheet_name
        AND    T.CREATED_BY    = p_created_by
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    NVL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
    	END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
	    v_log_type := '1';
	    v_log_message := '########## RESET Status = UPLOAD ##########';
	    v_description := p_mode;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
	    UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID    = v_program_id
        AND    SHEET_NAME    = v_sheet_name
        AND    CREATED_BY    = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    (   ATTRIBUTE1  IS NULL
	            OR LENGTH(ATTRIBUTE1) = 0
	            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
		END;

	    BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
		v_log_type := '2';
		v_log_message := '########## SKIP EMPTY LINE ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'V_TITLE'
        WHERE  PROGRAM_ID    = v_program_id
        AND    SHEET_NAME    = v_sheet_name
        AND    CREATED_BY    = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
        END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		v_log_type := '3';
		v_log_message := '########## TITLE Header Line ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Key.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND EXISTS (SELECT 1
		            FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                , X.ATTRIBUTE2 COL2
                                , X.ATTRIBUTE3 COL3
                                , X.ATTRIBUTE4 COL4
                                , X.ATTRIBUTE5 COL5
                                , X.ATTRIBUTE6 COL6
                                , X.ATTRIBUTE7 COL7
                                , X.ATTRIBUTE8 COL8
 	                            , X.ATTRIBUTE9 COL9
			                    , X.ATTRIBUTE10 COL10
								--, X.ATTRIBUTE11 COL11
								--, X.ATTRIBUTE12 COL12
                           FROM   SCM_ADM_EXCEL_UPLOAD X
                           WHERE  X.PROGRAM_ID    = v_program_id
                           AND    X.SHEET_NAME    = v_sheet_name
                           AND    X.CREATED_BY    = p_created_by
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
		                          , X.ATTRIBUTE9
			                      , X.ATTRIBUTE10
								  --, X.ATTRIBUTE11
								  --, X.ATTRIBUTE12
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
                    AND T.COL5 = ATTRIBUTE5
                    AND T.COL6 = ATTRIBUTE6
                    AND T.COL7 = ATTRIBUTE7
                    AND T.COL8 = ATTRIBUTE8
			        AND T.COL9  =ATTRIBUTE9
		            AND T.COL10 = ATTRIBUTE10
					--AND T.COL11 = ATTRIBUTE11
					--AND T.COL12 = ATTRIBUTE12
				   );
		END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		v_log_type := '4';
		v_log_message := '########## ERROR Key Duplication ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Division.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
						union
						SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					   );
		END;

		BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    ATTRIBUTE1 = (
								SELECT D.DIVISION_ID
								FROM   SCM_MST_DIVISION D
								WHERE  D.VALID_YN    = 'Y'
								AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
		                     )
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					   );
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload Bucket.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D
						      ,SCM_MST_DIVISION     D2
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						AND   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    D.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						AND    D.UPLOAD_BUCKET_TYPE IN (
						                                    SELECT CASE (TO_DATE(Z.ATTRIBUTE15,'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14,'YYYYMMDD'))  WHEN 1 THEN 'DAILY' WHEN 7 THEN 'WEEKLY' ELSE 'MONTHLY' END
														    FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                            WHERE  Z.PROGRAM_ID = v_program_id
															AND    Z.SHEET_NAME = v_sheet_name
															AND    Z.CREATED_BY = p_created_by
															AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
															AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'
						                                 )
						);
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload UOM.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D
						      ,SCM_MST_DIVISION     D2
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    D.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						AND    D.UPLOAD_UOM =  SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
						);
		END;

		BEGIN
		-- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
		v_log_type := '5';
	    v_log_message := '########## Invalid Division ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Scm Site.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S
						      ,SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		v_log_type := '6';
	    v_log_message := '########## Invalid Scm Site. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Plant Site.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    (ATTRIBUTE1 =  '81' or ATTRIBUTE1 = 'Automotive Battery')  -- ess는 제외
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S
						      ,SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		v_log_type := '6';
	    v_log_message := '########## Invalid Plant Site. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Project.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
		v_log_type := '7';
	    v_log_message := '########## Invalid Customer Project ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		IF v_division != '40' THEN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Model.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
						      ,SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    CM.VALID_YN              = 'Y'
						UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM si
						      ,SCM_MST_DIVISION D3
                        WHERE  si.DIVISION_ID = D3.DIVISION_ID
					    AND    si.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    si.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    si.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						and   ( D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
                        AND    si.VALID_YN              = 'Y'
						);
		END IF;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
		v_log_type := '8';
	    v_log_message := '########## Invalid Customer Model ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Incoterms.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
						AND    L.LOOKUP_TYPE = 'INCOTERMS'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '10';
		v_log_message := '########## Invalid Incoterms. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Type.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
						union
						SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
					   );
		END;

		BEGIN -- validation이 끝났으니 code로 update
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    ATTRIBUTE7 = (
							SELECT D.SEGMENT1
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
							WHERE  D.VALID_YN    = 'Y'
							AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							AND    D.SEGMENT2    = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
		                    )
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
					   );
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '11';
		v_log_message := '########## Invalid Sales Type. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customs Handbook'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
						AND    L.LOOKUP_TYPE = 'DOM/EXP'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '12';
		v_log_message := '########## Invalid DOM/EXP. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Group.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
						AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
						AND    L.SEGMENT1 = 'CUST_FCST'
						AND    L.VALID_YN    = 'Y');
		END;

		--20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
	    v_log_type := '12';
	    v_log_message := '########## Invalid Alphabet, NUMBER. ##########';
	    v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		-- ---------------------------------------------------------------------
	    END;

	    --문자열 체크
	    BEGIN

		MERGE INTO SCM_ADM_EXCEL_UPLOAD A
		USING (
			SELECT * FROM (SELECT UPLOAD_ID, SUM(CASE WHEN REGEXP_LIKE(VALUE, '^\s*[+-]?\d*\.?\d+\s*$') THEN 0 ELSE 1 END) PRICE
			FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
			FROM SCM_ADM_EXCEL_UPLOAD
			WHERE 1 = 1
			AND PROGRAM_ID    = v_program_id
			AND SHEET_NAME    = v_sheet_name
			AND CREATED_BY    = p_created_by
			AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND UPLOAD_STATUS_CODE = 'UPLOAD') T
			UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) X
			WHERE 1 = 1
			AND LTRIM(RTRIM(VALUE)) IS NOT NULL
			AND VALUE != '0'
			AND VALUE IS NOT NULL GROUP BY UPLOAD_ID) B
		) SRC_UPD
		ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
		WHEN MATCHED THEN
  UPDATE SET UPLOAD_STATUS_CODE = 'ERROR'
       , MESSAGE_TEXT = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';

	    END;
	    --소수점 체크
	    BEGIN

		MERGE INTO SCM_ADM_EXCEL_UPLOAD A
		USING (
			SELECT * FROM (SELECT UPLOAD_ID, SUM(CASE WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE
			FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
			FROM SCM_ADM_EXCEL_UPLOAD
			WHERE 1 = 1
			AND PROGRAM_ID = v_program_id
			AND SHEET_NAME    = v_sheet_name
			AND CREATED_BY    = p_created_by
			AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND UPLOAD_STATUS_CODE = 'UPLOAD') T
			UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15
			, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
			, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
			, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
			, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
			, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
			, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
			, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
			, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
			, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
			, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
			, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
			, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
			, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
			, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
			, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) X
			WHERE 1 = 1
			AND LTRIM(RTRIM(VALUE)) IS NOT NULL
			AND VALUE != '0'
			AND VALUE IS NOT NULL
			GROUP BY UPLOAD_ID) B
		) SRC_UPD
		ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
		WHEN MATCHED THEN
  UPDATE SET UPLOAD_STATUS_CODE = 'ERROR'
       , MESSAGE_TEXT = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';

     END;

  BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
  v_log_type := '13';
		v_log_message := '########## Invalid Measure Group. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
						AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '14';
		v_log_message := '########## Invalid Upload UOM. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		-- Upload UOM by Model
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM Costpmer FCST.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF
						      ,SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
					    AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
						AND    CF.MEASURE     = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
						and   ( D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 or  D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1  )
						AND    CF.VALID_YN    = 'Y');

		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '15';
		v_log_message := '########## Invalid Upload UOM Costpmer FCST. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;

		/*
		BEGIN
	    UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Project.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		v_log_type := '16';
		v_log_message := '########## Invalid Project. ##########';
		v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		/*
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Model.'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM
                        WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
						AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
						AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        -- ---------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '17';
	    v_log_message := '########## Invalid Model. ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- ---------------------------------------------------------------------
		END;
		*/
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         = v_program_id
        AND    SHEET_NAME         = v_sheet_name
        AND    CREATED_BY         = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3')  = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END;

		BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	    v_log_type := '16';
	    v_log_message := '########## SUCCESS ##########';
	    v_description := NULL;
	    d_event_date := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

	END IF;

	BEGIN
    -- -------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	v_log_type := '17';
	v_log_message := '########## INSERT INTO DATA START ##########';
	v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    -- -------------------------------------------------------------------------
	END;

	--// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT COUNT(1)
  INTO v_count
    FROM   SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID         = v_program_id
    AND    T.SHEET_NAME         = v_sheet_name
    AND    T.CREATED_BY         = p_created_by
    AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

DBMS_OUTPUT.PUT_LINE('■■■■■ Start1 v_count: '  ||  TO_CHAR(v_count));  --20240604 SM

	-- Update Mode and No Errors
	IF p_mode > 0 AND v_count = 0 THEN
		BEGIN
		v_start_yyyymmdd := NULL;
	    v_end_yyyymmdd := NULL;
		END;

		BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '18';
		v_log_message := '########## DELETE FROM DATE START ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

		BEGIN
		SELECT D.MIN_YYYYMMDD,
    D.MAX_YYYYMMDD
  INTO v_start_yyyymmdd, v_end_yyyymmdd
		FROM  (
		       SELECT MIN(YYYYMMDD) MIN_YYYYMMDD
		            , MAX(YYYYMMDD) MAX_YYYYMMDD
               FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
	                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
	                 , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
	                 , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
		             , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
		             , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
		             , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
		             , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
		             , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
		             , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
		             , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
	                 , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
		             , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
	                 , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
		             , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
	                 , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
		             , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
	                 , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
		             , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
	                 , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
	                 , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
	                 , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
		             , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
		             , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
		             , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
		             , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
		             , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
		             , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
		             , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
	                 , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
		             , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
	                 , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
		             , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
	                 , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
		             , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
	                 , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                FROM   SCM_ADM_EXCEL_UPLOAD
		        WHERE  1 = 1
		        AND    PROGRAM_ID    = v_program_id
	            AND    SHEET_NAME    = v_sheet_name
		        AND    CREATED_BY    = p_created_by
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
		        AND    UPLOAD_STATUS_CODE = 'V_TITLE'
               ) T
       UNPIVOT (    YYYYMMDD
                FOR COLUMN_NAME
		        IN   ( --ATTRIBUTE12, ATTRIBUTE13,   --20240605 sm (일자셋팅이 14부터 시작이라 14부터로 처리되도록 수정)
				       ATTRIBUTE14, ATTRIBUTE15
			         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
			         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
			         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
			         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
			         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
			         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
			         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
			         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
			         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
			         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
	                 , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
			         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
	                 , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
			         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
	                 , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
			         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
	                 , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
				     , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
	                 , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
	                 , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
	                 , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
			         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
			         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
			         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
			         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
			         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
			         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
			         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
	                 , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
			         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
	                 , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
			         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
	                 , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
			         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
	                 , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
				     )
		           ) X
		WHERE X.YYYYMMDD IS NOT NULL
		) D;
        END;

		BEGIN

DBMS_OUTPUT.PUT_LINE('■■■■■v_start_yyyymmdd: '  ||  v_start_yyyymmdd);
DBMS_OUTPUT.PUT_LINE('■■■■■v_end_yyyymmdd:   '  ||  v_end_yyyymmdd);

        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '19-1';
		v_log_message := '########## DELETE FROM DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
		END;

				-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
			BEGIN

        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '20-1';
		v_log_message := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
			DELETE FROM DM_PLN_CUSTOMER_PSI
			WHERE  1 = 1
			AND    MEASURE_GROUP = 'CUST_FCST'
			-- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
			AND    (
			          SELECT  count(1)
						FROM   SCM_ADM_EXCEL_UPLOAD T
						WHERE  T.PROGRAM_ID         = v_program_id
						AND    T.SHEET_NAME         = v_sheet_name
						AND    T.CREATED_BY         = p_created_by
						AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
						AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
						AND   DM_PLN_CUSTOMER_PSI.DIVISION_ID           =  T.ATTRIBUTE1
						AND   DM_PLN_CUSTOMER_PSI.SCM_SITE_ID           =  T.ATTRIBUTE2
						AND   DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID         =  T.ATTRIBUTE3
						AND   DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE =  T.ATTRIBUTE4
						AND   DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL        =  T.ATTRIBUTE5
						AND   DM_PLN_CUSTOMER_PSI.INCOTERMS             =  T.ATTRIBUTE6
						AND   DM_PLN_CUSTOMER_PSI.FCST_TYPE             =  T.ATTRIBUTE7
						AND   DM_PLN_CUSTOMER_PSI.DOM_EXP               =  T.ATTRIBUTE8
						AND   DM_PLN_CUSTOMER_PSI.MEASURE               =  T.ATTRIBUTE10
			       ) > 0
			AND    YYYYMMDD BETWEEN v_start_yyyymmdd AND v_end_yyyymmdd;

        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '20';
		v_log_message := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
			END;
DBMS_OUTPUT.PUT_LINE('20');



			-- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
			UPDATE SCM_ADM_EXCEL_UPLOAD AA
			SET		ATTRIBUTE10 = (
				SELECT BB.MEASURE
				FROM (
					SELECT DISTINCT
						A.DIVISION_ID
						, B.DIVISION_NAME
						, A.SCM_SITE_ID
						, A.VALID_YN
						, A.MEASURE
						, A.UPLOAD_UOM
						, A.UPLOAD_BUCKET_TYPE
					FROM DM_MST_CUSTOMER_FCST A
					INNER JOIN SCM_MST_DIVISION B
					ON A.VALID_YN		= 'Y'
					AND A.DIVISION_ID	= B.DIVISION_ID
				) BB
				WHERE ( BB.DIVISION_ID = AA.ATTRIBUTE1 OR  BB.DIVISION_NAME = AA.ATTRIBUTE1  )
				AND  BB.SCM_SITE_ID = AA.ATTRIBUTE2
				AND  BB.MEASURE     = AA.ATTRIBUTE10
				AND  BB.UPLOAD_UOM	= AA.ATTRIBUTE11
				AND	 BB.UPLOAD_BUCKET_TYPE IN (
						SELECT CASE (TO_DATE(Z.ATTRIBUTE15,'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14,'YYYYMMDD'))	WHEN 1 THEN 'DAILY'
																													WHEN 7 THEN 'WEEKLY'
																													ELSE 'MONTHLY' END
						FROM   SCM_ADM_EXCEL_UPLOAD Z
						WHERE  Z.PROGRAM_ID = v_program_id
						AND    Z.SHEET_NAME = v_sheet_name
						AND    Z.CREATED_BY = p_created_by
						AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
						AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'
				)
				FETCH FIRST 1 ROWS ONLY
			)
			WHERE AA.PROGRAM_ID = v_program_id
			AND   AA.SHEET_NAME = v_sheet_name
			AND   AA.CREATED_BY = p_created_by
			AND   AA.UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
			AND EXISTS (
				SELECT 1
				FROM (
					SELECT DISTINCT
						A.DIVISION_ID
						, B.DIVISION_NAME
						, A.SCM_SITE_ID
						, A.MEASURE
						, A.UPLOAD_UOM
						, A.UPLOAD_BUCKET_TYPE
					FROM DM_MST_CUSTOMER_FCST A
					INNER JOIN SCM_MST_DIVISION B
					ON A.VALID_YN		= 'Y'
					AND A.DIVISION_ID	= B.DIVISION_ID
				) BB
				WHERE ( BB.DIVISION_ID = AA.ATTRIBUTE1 OR  BB.DIVISION_NAME = AA.ATTRIBUTE1  )
				AND  BB.SCM_SITE_ID = AA.ATTRIBUTE2
				AND  BB.MEASURE     = AA.ATTRIBUTE10
				AND  BB.UPLOAD_UOM	= AA.ATTRIBUTE11
			);

DBMS_OUTPUT.PUT_LINE('20240605-21');

			INSERT INTO DM_PLN_CUSTOMER_PSI
			(
				DIVISION_ID
			  , SCM_SITE_ID
			  , PLANT_SITE_ID
			  , CUSTOMER_PROJECT_CODE
			  , CUSTOMER_MODEL
			  , INCOTERMS
			  , FCST_TYPE
			  , DOM_EXP
			  , MEASURE_GROUP
			  , MEASURE
			  , UPLOAD_UOM
			  , PROJECT_CODE
			  , ITEM_ID
			  , YYYYMMDD
			  , QTY
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			  , BATCH_RESULT
			)
			SELECT V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, V.ATTRIBUTE4, V.ATTRIBUTE5
				 , V.ATTRIBUTE6, V.ATTRIBUTE7, V.ATTRIBUTE8, V.ATTRIBUTE9, V.ATTRIBUTE10
				 , V.ATTRIBUTE11, V.ATTRIBUTE12, V.ATTRIBUTE13
				 , C.YYYYMMDD  , TO_NUMBER(V.VALUE), p_created_by, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
				 , p_created_by, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'), 'UI'
			FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
						, COLUMN_NAME, YYYYMMDD
				   FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
								, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
		               			, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
		               			, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
		               			, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
	                  			, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
						   FROM   SCM_ADM_EXCEL_UPLOAD
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = v_program_id
						   AND    SHEET_NAME    = v_sheet_name
						   AND    CREATED_BY    = p_created_by
						   -- modified by ytchoi 180305
						  -- AND    CREATION_DATE = v_creation_date
						   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') =  v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'V_TITLE'
						  ) T
				  UNPIVOT (    YYYYMMDD
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
								)
						  ) X
				  ) C
				, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
						, COLUMN_NAME, VALUE
				   FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
								, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
						   FROM   SCM_ADM_EXCEL_UPLOAD
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = v_program_id
						   AND    SHEET_NAME    = v_sheet_name
						   AND    CREATED_BY    = p_created_by
						   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
						  ) T
				  UNPIVOT (    VALUE
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
								, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
								, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
								, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
								, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
								, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
								, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
								, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
								, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
								, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
								, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
								, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
								, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
								, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
								, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
								, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
								, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
								, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
								, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
								, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
								, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
								, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
								, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
								, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
								, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
								, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
								, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
								, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
								, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
								, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
								, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
								, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
								, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
								, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
								, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
								, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
								, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
								, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
								)
							) X
				  ) V
			WHERE 1 = 1
			AND   C.COLUMN_NAME = V.COLUMN_NAME
			AND   C.YYYYMMDD IS NOT NULL
			AND   V.VALUE IS NOT NULL;

DBMS_OUTPUT.PUT_LINE('21');
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		v_log_type := '21';
		v_log_message := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
		v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------

		    IF v_division = '40' THEN
				PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
			--2026-03-30 김준규 아래는 dm 에서 하지 않는 것으로 정리함.
			/*ELSE
DBMS_OUTPUT.PUT_LINE('20240605-PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM');
				PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM;*/
	        END IF;

		    COMMIT;
			--COMMIT ;
        -- END TRY
	END IF;
    -- -------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	v_log_type := 'END';
	v_log_message := '########## INSERT INTO DATA END ##########';
	v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    -- -------------------------------------------------------------------------

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
		    WHEN OTHERS THEN
		        ROLLBACK;
		        PR_SCM_SYS_LOG_BATCH(
		            v_program_name, 'ERROR', 0, SQLERRM, NULL, SYSDATE,
		            p_in_para_data => v_in_para_data,
		            p_sql_err_code => SQLCODE,
		            p_sql_err_msg  => SQLERRM,
		            p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
		        );
		        RAISE_APPLICATION_ERROR(-20001,
		            '[' || v_program_name || '] SQLCODE=' || SQLCODE ||
		            ' / SQLERRM=' || SQLERRM ||
		            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
		            ' / PARAMS=' || v_in_para_data
		        );
END;
/

-- DMF0014_GET_CUST_FCST_UPLOAD_DATA → PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0014_GET_CUST_FCST_UPLOAD_DATA
(
  p_division_id     VARCHAR2,
  p_dept_id         VARCHAR2,
  p_end_customer    VARCHAR2,
  p_scm_site_id     VARCHAR2,
  p_plant_site_id   VARCHAR2,
  p_project_code    VARCHAR2,
  p_item_id         VARCHAR2,
  p_start_yyyymmdd  VARCHAR2,
  p_end_yyyymmdd    VARCHAR2,
  p_bucket_type     VARCHAR2,
  p_dom_exp         VARCHAR2,
  p_created_by      VARCHAR2,    --, p_debug OUT VARCHAR2
  p_userinfo		VARCHAR2
  , O_RESULT_CURSOR OUT SYS_REFCURSOR)
/*
 DMF0014_GET_CUST_FCST_UPLOAD_DATA(p_division_id='81', p_dept_id='ALL', p_end_customer='ALL', p_scm_site_id='ALL', p_plant_site_id='ALL', p_project_code = NULL);
 , p_item_id = NULL, p_start_yyyymmdd='20230904', p_end_yyyymmdd='20240310', p_bucket_type='WEEKLY', p_dom_exp='ALL', p_created_by='chano0612', p_userinfo='ADMIN'
*/
AS
    v_program_name VARCHAR2(200) := $$PLSQL_UNIT;

    v_sql_text VARCHAR2(4000 CHAR);
    v_iteration VARCHAR2(4000 CHAR);
    v_column_text VARCHAR2(200 CHAR);
    v_column_name VARCHAR2(50 CHAR);
    v_yyyymmdd VARCHAR2(8 CHAR);
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_group_id VARCHAR2(50 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    v_step         VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_dept_id' VALUE p_dept_id,
            'p_end_customer' VALUE p_end_customer,
            'p_scm_site_id' VALUE p_scm_site_id,
            'p_plant_site_id' VALUE p_plant_site_id,
            'p_project_code' VALUE p_project_code,
            'p_item_id' VALUE p_item_id,
            'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
            'p_bucket_type' VALUE p_bucket_type,
            'p_dom_exp' VALUE p_dom_exp,
            'p_created_by' VALUE p_created_by
          );

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

	--	v_group_id := 'ADMIN'
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	-- ------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
	AND SEGMENT1 = p_userinfo;
	IF v_cnt_1 > 0 THEN
			v_group_id := 'ADMIN';
		END IF;
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- ------------------------------------------------------------------------------
	SELECT A.BASIS_START_DATE
  INTO v_start_yyyymmdd
    FROM   SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD = p_start_yyyymmdd;

    v_iteration := NULL;

	IF p_bucket_type = 'DAILY' THEN
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- c_cust_fcst CURSOR FAST_FORWARD FOR
	    FOR rec IN (SELECT 'D_'  ||  BASIS_YYYYMMDD  AS COLUMN_NAME
              , BASIS_YYYYMMDD YYYYMMDD
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= v_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        ORDER BY COLUMN_NAME) LOOP

		v_column_name := rec.COLUMN_NAME;
        v_yyyymmdd := rec.YYYYMMDD;
            v_column_text := ', SUM(CASE WHEN CP.YYYYMMDD IS NULLv_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

            v_column_text := REPLACE(v_column_text,'v_yyyymmdd'   , v_yyyymmdd   );
            v_column_text := REPLACE(v_column_text,'v_column_name', v_column_name);

            v_iteration := v_iteration  ||  v_column_text;


        END LOOP;


	ELSIF p_bucket_type = 'WEEKLY' THEN
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- c_cust_fcst CURSOR FAST_FORWARD FOR
		FOR rec IN (SELECT 'D_'  ||  MIN(A.BASIS_START_DATE) COLUMN_NAME
             , A.ISO_YYYYWW --A.BASIS_YYYYMM + MIN(SUBSTR('00' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_START_DATE, 'IW')), 'YYYY-MM-DD'), -2)) YYYYMMDD
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= v_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        GROUP BY A.ISO_YYYYWW, A.WEEK_NAME
        ORDER BY COLUMN_NAME) LOOP

	    v_column_name := rec.COLUMN_NAME;
        v_yyyymmdd := rec.ISO_YYYYWW;

            v_column_text := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 4) || SUBSTR(''00'' || TO_CHAR(TO_NUMBER(TO_CHAR(CP.YYYYMMDD, ''IW'')), ''YYYY-MM-DD''), -2) = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

            v_column_text := REPLACE(v_column_text,'v_yyyymmdd'   , v_yyyymmdd   );
            v_column_text := REPLACE(v_column_text,'v_column_name', v_column_name);

            v_iteration := v_iteration  ||  v_column_text;


        END LOOP;


	ELSIF p_bucket_type = 'MONTHLY' THEN
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- c_cust_fcst CURSOR FAST_FORWARD FOR
		FOR rec IN (SELECT 'D_'  ||  MIN(A.BASIS_YYYYMM)  ||  '01' AS COLUMN_NAME
             , MIN(A.BASIS_YYYYMM) YYYYMMDD
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= v_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        GROUP BY A.MONTH_NAME
	    ORDER BY COLUMN_NAME) LOOP

		v_column_name := rec.COLUMN_NAME;
        v_yyyymmdd := rec.YYYYMMDD;
            v_column_text := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 6) = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

            v_column_text := REPLACE(v_column_text,'v_yyyymmdd'   , v_yyyymmdd   );
            v_column_text := REPLACE(v_column_text,'v_column_name', v_column_name);

            v_iteration := v_iteration  ||  v_column_text;


        END LOOP;
	END IF;

    v_sql_text := ';
        SELECT CP.DIVISION_ID
		     , CP.SCM_SITE_ID
			 , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS
             , CP.FCST_TYPE
			 , CP.DOM_EXP
			 , CP.MEASURE_GROUP
             , CP.MEASURE
			 , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
		--[PJ2024-50461] Team Mapping------------------------------------
			 --, CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', S.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
				--THEN ''Y'' ELSE '''' END AS EDIT_FLAG
			 , CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', TEAM.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
				THEN ''Y'' ELSE '''' END AS EDIT_FLAG
		--[PJ2024-50461] Team Mapping------------------------------------
             v_iteration
        FROM   DM_PLN_CUSTOMER_PSI CP
		     			--, SCM_MST_SITE        S
		--[PJ2024-50611] 명시적으로 INNER JOIN 처리 START
		INNER JOIN  SCM_MST_SITE        S
			ON CP.DIVISION_ID   = S.DIVISION_ID
			AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
		--[PJ2024-50611] 명시적으로 INNER JOIN 처리 END
--[PJ2024-50461] Team Mapping------------------------------------
			LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM
				ON S.DIVISION_ID = ITM.DIVISION_ID
				AND S.SCM_SITE_ID = ITM.SCM_SITE_ID
				AND CP.PROJECT_CODE = ITM.PROJECT_CODE--[PJ2024-50611] 조인 추가
				AND CP.ITEM_ID = ITM.ITEM_ID--[PJ2024-50611] 조인 추가
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
				FROM SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) TEAM
			ON
			TEAM.USER_ID   IN (SELECT value FROM TABLE(fn_splitstring(ITM.owner, '','')))
--[PJ2024-50461] Team Mapping------------------------------------
        WHERE  1 = 1
		AND    CP.DIVISION_ID   = S.DIVISION_ID
		AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        AND    CP.MEASURE_GROUP IS NULLCUST_FCST'';
		p_division_id
		p_dept_id
        p_scm_site_id
		p_plant_site_id
		p_project_code
        p_item_id
	    p_dom_exp
		p_end_customer
		AND    CP.YYYYMMDD BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
		AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
		                      FROM   DM_MST_CUSTOMER_FCST X
							  WHERE  1 = 1
							  AND    X.DIVISION_ID = CP.DIVISION_ID
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID -- 해당 SITE에 연결된 Measure만 구함.
                              AND    X.UPLOAD_BUCKET_TYPE IS NULLp_bucket_type''
							  AND    X.VALID_YN IS NULLY''
							)
		GROUP BY CP.DIVISION_ID
		--[PJ2024-50461] Team Mapping------------------------------------
				--, S.DEPT_ID
			   , TEAM.DEPT_ID
		--[PJ2024-50461] Team Mapping------------------------------------
		       , CP.SCM_SITE_ID
			   , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS
               , CP.FCST_TYPE
			   , CP.DOM_EXP
			   , CP.MEASURE_GROUP
               , CP.MEASURE
			   , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID

        ORDER BY CP.DIVISION_ID
		       , CP.SCM_SITE_ID
			   , CP.PLANT_SITE_ID
		       , CP.CUSTOMER_PROJECT_CODE
			   , CP.CUSTOMER_MODEL

  ';

  v_sql_text := REPLACE(v_sql_text,'v_iteration'     , v_iteration     );
  v_sql_text := REPLACE(v_sql_text,'p_division_id'   , FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID'   , 'IN', p_division_id ));
  --[PJ2024-50461] Team Mapping------------------------------------
  v_sql_text := REPLACE(v_sql_text,'p_dept_id'       , FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID'        , 'IN', p_dept_id ));
  --[PJ2024-50461] Team Mapping------------------------------------
  v_sql_text := REPLACE(v_sql_text,'p_end_customer'  , FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER'   , 'IN', p_end_customer));
  v_sql_text := REPLACE(v_sql_text,'p_scm_site_id'   , FN_SCM_GET_WHERE_SQL('CP.SCM_SITE_ID'   , 'IN', p_scm_site_id));
  v_sql_text := REPLACE(v_sql_text,'p_plant_site_id' , FN_SCM_GET_WHERE_SQL('CP.PLANT_SITE_ID' , 'IN', p_plant_site_id));
  v_sql_text := REPLACE(v_sql_text,'p_project_code'  , FN_SCM_GET_WHERE_SQL('CP.PROJECT_CODE'  , 'IN', p_project_code));
  v_sql_text := REPLACE(v_sql_text,'p_item_id'       , FN_SCM_GET_WHERE_SQL('CP.ITEM_ID'       , 'IN', p_item_id));
  v_sql_text := REPLACE(v_sql_text,'p_dom_exp'       , FN_SCM_GET_WHERE_SQL('CP.DOM_EXP'       , 'IN', p_dom_exp));
  v_sql_text := REPLACE(v_sql_text,'p_start_yyyymmdd', v_start_yyyymmdd);
  v_sql_text := REPLACE(v_sql_text,'p_end_yyyymmdd'  , p_end_yyyymmdd  );
  v_sql_text := REPLACE(v_sql_text,'p_bucket_type'   , p_bucket_type   );
  v_sql_text := REPLACE(v_sql_text,'p_created_by'    , p_created_by    );
  v_sql_text := REPLACE(v_sql_text,'v_group_id'    , v_group_id    );

  --p_debug := v_sql_text;
  --RETURN p_debug;
  --SELECT v_sql_text;
  DBMS_OUTPUT.PUT_LINE(SUBSTR(v_sql_text, 1, 3000));
  DBMS_OUTPUT.PUT_LINE(SUBSTR(v_sql_text, 3001, 6000));
  --EXECUTE IMMEDIATE v_sql_text;
  EXECUTE IMMEDIATE v_sql_text; --, p_param_list,
                                  --p_plan_week, p_division_code, p_customer_id, p_fcst_sit_id, p_measure, p_edi_fcst_yn, p_valid_yn;
 --xml확인할경우
--SELECT TO_CLOB(v_sql_text)
--FROM DUAL;
/* TODO: FOR XML PATH --> LISTAGG 수동변환 */--,ROOT('x')
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH(v_program_name,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
END;
/

-- DMF0014_GET_SPREAD_TITLE → PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0014_GET_SPREAD_TITLE
(
  p_start_yyyymmdd  VARCHAR2,
  p_end_yyyymmdd    VARCHAR2,
  p_bucket_type     VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0014_GET_SPREAD_TITLE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/22  SongDH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/10/26  KDW2819		  [C20221024-000507]CUST FCST Upload 오류 수정
 * 2026/03/15  김준규		  [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
            'p_bucket_type' VALUE p_bucket_type
          );

	IF p_bucket_type = 'DAILY' THEN
        /* TODO:EDIT_YN:수동확인필요 */
        OPEN O_RC1 FOR
        SELECT 'D_'  ||  BASIS_YYYYMMDD  AS COLUMN_NAME
              , BASIS_YYYYMMDD COLUMN_LABEL
              , A.DAYOFWEEK SMALL_LABEL_NAME
              , 'Y' AS EDIT_YN
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd; --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
	ELSIF p_bucket_type = 'WEEKLY' THEN
		/* TODO:EDIT_YN:수동확인필요 */
		OPEN O_RC1 FOR
		SELECT 'D_'  ||  MIN(A.BASIS_START_DATE) COLUMN_NAME
              , MIN(A.BASIS_START_DATE) COLUMN_LABEL
              , A.WEEK_NAME SMALL_LABEL_NAME
              , 'Y' AS EDIT_YN
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        GROUP BY A.ISO_YYYYWW, A.WEEK_NAME
		ORDER BY COLUMN_LABEL;
    ELSIF p_bucket_type = 'MONTHLY' THEN
		/* TODO:EDIT_YN:수동확인필요 */
		OPEN O_RC1 FOR
		SELECT 'D_'  ||  MIN(A.BASIS_YYYYMM)  ||  '01'  AS COLUMN_NAME
              , MIN(A.BASIS_YYYYMM)  ||  '01'        AS COLUMN_LABEL
              , A.MONTH_NAME SMALL_LABEL_NAME
              , 'Y' AS EDIT_YN
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
        AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        GROUP BY A.MONTH_NAME ;
		END IF;


    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
END;
/

-- DMF0014_SAVE_CUST_FCST_UPLOAD_DATA → PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
(
	p_active_flag				VARCHAR2,
	p_division_id				VARCHAR2,
	p_scm_site_id				VARCHAR2,
	p_customer_project_code	VARCHAR2,
	p_customer_model			VARCHAR2,
	p_incoterms				VARCHAR2,
	p_fcst_type 				VARCHAR2,
	p_dom_exp					VARCHAR2,
	p_measure_group     		VARCHAR2,
	p_measure					VARCHAR2,
	p_plant_site_id			VARCHAR2,
	p_upload_uom				VARCHAR2,
	p_project_code				VARCHAR2,
	p_item_id					VARCHAR2,
	p_yyyymmdd					VARCHAR2,
	p_qty						VARCHAR2,
	p_created_by				VARCHAR2
  , O_RESULT_CURSOR OUT SYS_REFCURSOR)
/*
 * Program ID   : DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
 * Description  : SAVE CUST FCST UPLOAD DATA
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 28    KHSONG     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	   KDW2819	  [C20221024-000507]CUST FCST Upload 오류 수정
 *
  * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    v_in_para_data VARCHAR2(4000);
    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_division_id VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_customer_project_code VARCHAR2(4000 CHAR);
    v_customer_model VARCHAR2(4000 CHAR);
    v_incoterms VARCHAR2(4000 CHAR);
    v_fcst_type VARCHAR2(4000 CHAR);
    v_dom_exp VARCHAR2(4000 CHAR);
    v_measure_group VARCHAR2(4000 CHAR);
    v_measure VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    v_upload_uom VARCHAR2(4000 CHAR);
    v_project_code VARCHAR2(4000 CHAR);
    v_item_id VARCHAR2(4000 CHAR);
    v_yyyymmdd VARCHAR2(4000 CHAR);
    v_qty VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_dummy_cursor SYS_REFCURSOR;
    v_index_active_flag INTEGER;
    v_index_division_id INTEGER;
    v_index_scm_site_id INTEGER;
    v_index_customer_project_code INTEGER;
    v_index_customer_model INTEGER;
    v_index_incoterms INTEGER;
    v_index_fcst_type INTEGER;
    v_index_dom_exp INTEGER;
    v_index_measure_group INTEGER;
    v_index_measure INTEGER;
    v_index_plant_site_id INTEGER;
    v_index_upload_uom INTEGER;
    v_index_project_code INTEGER;
    v_index_item_id INTEGER;
    v_index_yyyymmdd INTEGER;
    v_index_qty INTEGER;
    v_index_created_by INTEGER;
    v_p_active_flag VARCHAR2(4000 CHAR);
    v_p_division_id VARCHAR2(4000 CHAR);
    v_p_scm_site_id VARCHAR2(4000 CHAR);
    v_p_customer_project_code VARCHAR2(4000 CHAR);
    v_p_customer_model VARCHAR2(4000 CHAR);
    v_p_incoterms VARCHAR2(4000 CHAR);
    v_p_fcst_type VARCHAR2(4000 CHAR);
    v_p_dom_exp VARCHAR2(4000 CHAR);
    v_p_measure_group VARCHAR2(4000 CHAR);
    v_p_measure VARCHAR2(4000 CHAR);
    v_p_plant_site_id VARCHAR2(4000 CHAR);
    v_p_upload_uom VARCHAR2(4000 CHAR);
    v_p_project_code VARCHAR2(4000 CHAR);
    v_p_item_id VARCHAR2(4000 CHAR);
    v_p_yyyymmdd VARCHAR2(4000 CHAR);
    v_p_qty VARCHAR2(4000 CHAR);
    v_p_created_by VARCHAR2(4000 CHAR);
BEGIN

    NULL;

	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;

	-- 멀티처리 변수선언
	v_active_flag := NULL;
	v_division_id := NULL;
	v_scm_site_id := NULL;
	v_customer_project_code := NULL;
	v_customer_model := NULL;
	v_incoterms := NULL;
	v_fcst_type := NULL;
	v_dom_exp := NULL;
	v_measure_group := NULL;
	v_measure := NULL;
	v_PLANT_SITE_ID := NULL;
	v_upload_uom := NULL;
	v_project_code := NULL;
	v_item_id := NULL;
	v_yyyymmdd := NULL;
	v_qty := NULL;
	v_created_by := NULL;

	v_delimiter := '^';

	 v_p_active_flag := RTRIM(p_active_flag           )  ||  '^';
	 v_p_division_id := RTRIM(p_division_id           )  ||  '^';
	 v_p_scm_site_id := RTRIM(p_scm_site_id           )  ||  '^';
	 v_p_customer_project_code := RTRIM(p_customer_project_code )  ||  '^';
	 v_p_customer_model := RTRIM(p_customer_model        )  ||  '^';
	 v_p_incoterms := RTRIM(p_incoterms             )  ||  '^';
	 v_p_fcst_type := RTRIM(p_fcst_type             )  ||  '^';
	 v_p_dom_exp := RTRIM(p_dom_exp               )  ||  '^';
	 v_p_measure_group := RTRIM(p_measure_group         )  ||  '^';
	 v_p_measure := RTRIM(p_measure               )  ||  '^';
	 v_p_plant_site_id := RTRIM(p_plant_site_id         )  ||  '^';
	 v_p_upload_uom := RTRIM(p_upload_uom            )  ||  '^';
	 v_p_project_code := RTRIM(p_project_code          )  ||  '^';
	 v_p_item_id := RTRIM(p_item_id               )  ||  '^';
	 v_p_yyyymmdd := RTRIM(p_yyyymmdd              )  ||  '^';
	 v_p_qty := RTRIM(p_qty                   )  ||  '^';
	 v_p_created_by := RTRIM(p_created_by            )  ||  '^';

	-- GT_SCFU_RESULTS TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCFU_RESULTS';

	-- 시작 LOG
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

--===================================================================================== GT_SCFU_RESULTS 테이블에 split후 INSERT INTO start
	--###############################################  GT_SCFU_RESULTS 테이블에 split후 insert (START)
	WHILE LENGTH(v_p_DIVISION_ID) > 0 LOOP

	 v_index_active_flag := INSTR(v_p_active_flag, '^');
	 v_index_division_id := INSTR(v_p_division_id, '^');
	 v_index_scm_site_id := INSTR(v_p_scm_site_id, '^');
	 v_index_customer_project_code := INSTR(v_p_customer_project_code, '^');
	 v_index_customer_model := INSTR(v_p_customer_model, '^');
	 v_index_incoterms := INSTR(v_p_incoterms, '^');
	 v_index_fcst_type := INSTR(v_p_fcst_type, '^');
	 v_index_dom_exp := INSTR(v_p_dom_exp, '^');
	 v_index_measure_group := INSTR(v_p_measure_group, '^');
	 v_index_measure := INSTR(v_p_measure, '^');
	 v_index_plant_site_id := INSTR(v_p_plant_site_id, '^');
	 v_index_upload_uom := INSTR(v_p_upload_uom, '^');
	 v_index_project_code := INSTR(v_p_project_code, '^');
	 v_index_item_id := INSTR(v_p_item_id, '^');
	 v_index_yyyymmdd := INSTR(v_p_yyyymmdd, '^');
	 v_index_qty := INSTR(v_p_qty, '^');
	 v_index_created_by := INSTR(v_p_created_by, '^');

	 --확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
		IF v_index_DIVISION_ID > 0 THEN
			   v_active_flag := SUBSTR(v_p_active_flag          , 1, v_index_active_flag - 1        );
			   v_division_id := SUBSTR(v_p_division_id          , 1, v_index_division_id - 1        );
			   v_scm_site_id := SUBSTR(v_p_scm_site_id          , 1, v_index_scm_site_id - 1        );
			   v_customer_project_code := SUBSTR(v_p_customer_project_code, 1, v_index_customer_project_code - 1);
			   v_customer_model := SUBSTR(v_p_customer_model       , 1, v_index_customer_model - 1     );
			   v_incoterms := SUBSTR(v_p_incoterms            , 1, v_index_incoterms - 1          );
			   v_fcst_type := SUBSTR(v_p_fcst_type            , 1, v_index_fcst_type - 1          );
			   v_dom_exp := SUBSTR(v_p_dom_exp              , 1, v_index_dom_exp - 1            );
			   v_measure_group := SUBSTR(v_p_measure_group        , 1, v_index_measure_group - 1      );
			   v_measure := SUBSTR(v_p_measure              , 1, v_index_measure - 1            );
			   v_plant_site_id := SUBSTR(v_p_plant_site_id        , 1, v_index_plant_site_id - 1      );
			   v_upload_uom := SUBSTR(v_p_upload_uom           , 1, v_index_upload_uom - 1         );
			   v_project_code := SUBSTR(v_p_project_code         , 1, v_index_project_code - 1       );
			   v_item_id := SUBSTR(v_p_item_id              , 1, v_index_item_id - 1            );
			   v_yyyymmdd := SUBSTR(v_p_yyyymmdd             , 1, v_index_yyyymmdd - 1           );
			   v_qty := SUBSTR(v_p_qty                  , 1, v_index_qty - 1                );
			   v_created_by := SUBSTR(v_p_created_by           , 1, v_index_created_by - 1         );

			   v_p_active_flag := SUBSTR(v_p_active_flag           , v_index_active_flag + 1);
			   v_p_division_id := SUBSTR(v_p_division_id           , v_index_division_id + 1);
			   v_p_scm_site_id := SUBSTR(v_p_scm_site_id           , v_index_scm_site_id + 1);
			   v_p_customer_project_code := SUBSTR(v_p_customer_project_code , v_index_customer_project_code + 1);
			   v_p_customer_model := SUBSTR(v_p_customer_model        , v_index_customer_model + 1);
			   v_p_incoterms := SUBSTR(v_p_incoterms             , v_index_incoterms + 1);
			   v_p_fcst_type := SUBSTR(v_p_fcst_type             , v_index_fcst_type + 1);
			   v_p_dom_exp := SUBSTR(v_p_dom_exp               , v_index_dom_exp + 1);
			   v_p_measure_group := SUBSTR(v_p_measure_group         , v_index_measure_group + 1);
			   v_p_measure := SUBSTR(v_p_measure               , v_index_measure + 1);
			   v_p_plant_site_id := SUBSTR(v_p_plant_site_id         , v_index_plant_site_id + 1);
			   v_p_upload_uom := SUBSTR(v_p_upload_uom            , v_index_upload_uom + 1);
			   v_p_project_code := SUBSTR(v_p_project_code          , v_index_project_code + 1);
			   v_p_item_id := SUBSTR(v_p_item_id               , v_index_item_id + 1);
			   v_p_yyyymmdd := SUBSTR(v_p_yyyymmdd              , v_index_yyyymmdd + 1);
			   v_p_qty := SUBSTR(v_p_qty                   , v_index_qty + 1);
			   v_p_created_by := SUBSTR(v_p_created_by            , v_index_created_by + 1);

			   INSERT /*+ NO_PARALLEL */ INTO GT_SCFU_RESULTS (
					  v_active_flag
					 ,v_division_id
					 ,v_scm_site_id
					 ,v_customer_project_code
					 ,v_customer_model
					 ,v_incoterms
					 ,v_fcst_type
					 ,v_dom_exp
					 ,v_measure_group
					 ,v_measure
					 ,v_plant_site_id
					 ,v_upload_uom
					 ,v_project_code
					 ,v_item_id
					 ,v_yyyymmdd
					 ,v_qty
					 ,v_created_by
			   ) VALUES (
					  v_active_flag
					 ,v_division_id
					 ,v_scm_site_id
					 ,v_customer_project_code
					 ,v_customer_model
					 ,v_incoterms
					 ,v_fcst_type
					 ,v_dom_exp
					 ,v_measure_group
					 ,v_measure
					 ,v_plant_site_id
					 ,v_upload_uom
					 ,v_project_code
					 ,v_item_id
					 ,v_yyyymmdd
					 ,v_qty
					 ,v_created_by
			   );
		ELSE
			   v_DIVISION_ID := v_p_DIVISION_ID;
			   v_p_DIVISION_ID := NULL;

			   INSERT /*+ NO_PARALLEL */ INTO GT_SCFU_RESULTS (
					  v_active_flag
					 ,v_division_id
					 ,v_scm_site_id
					 ,v_customer_project_code
					 ,v_customer_model
					 ,v_incoterms
					 ,v_fcst_type
					 ,v_dom_exp
					 ,v_measure_group
					 ,v_measure
					 ,v_plant_site_id
					 ,v_upload_uom
					 ,v_project_code
					 ,v_item_id
					 ,v_yyyymmdd
					 ,v_qty
					 ,v_created_by
			   ) VALUES (
					  v_active_flag
					 ,v_division_id
					 ,v_scm_site_id
					 ,v_customer_project_code
					 ,v_customer_model
					 ,v_incoterms
					 ,v_fcst_type
					 ,v_dom_exp
					 ,v_measure_group
					 ,v_measure
					 ,v_plant_site_id
					 ,v_upload_uom
					 ,v_project_code
					 ,v_item_id
					 ,v_yyyymmdd
					 ,v_qty
					 ,v_created_by
			   );
	  END IF;
	-- if end
	END LOOP;
		--###############################################   GT_SCFU_RESULTS 테이블에 split후 insert (END)
			   -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
			   --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
			   --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
				  -- AND
				  -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
			   --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
			   --begin
				  -- v_log_type := 'INVALID';
				  -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Project !';
				  -- goto err_rtn
			   --end
			   --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
			   --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND CUSTOMER_MODEL = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
				  -- AND
				  -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
			   --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND ITEM_ID = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
			   --begin
				  -- v_log_type := 'INVALID';
				  -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Model !';
				  -- goto err_rtn
			   --end
			   -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------
--SELECT * FROM GT_SCFU_RESULTS
	--===================================================================================== INSERT INTO 전 DELETE FROM start
	BEGIN
			   -- 확인  select * from GT_SCFU_RESULTS
			   DELETE
			   FROM DM_PLN_CUSTOMER_PSI
			   WHERE (
						SELECT count(1)
						  FROM GT_SCFU_RESULTS
						 where 1=1
						   and DIVISION_ID            =   DM_PLN_CUSTOMER_PSI.DIVISION_ID
						   AND CUSTOMER_PROJECT_CODE  =   DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE
						   AND CUSTOMER_MODEL         =   DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL
						   AND SCM_SITE_ID            =   DM_PLN_CUSTOMER_PSI.SCM_SITE_ID
						   AND DOM_EXP                =   DM_PLN_CUSTOMER_PSI.DOM_EXP
						   AND FCST_TYPE              =   DM_PLN_CUSTOMER_PSI.FCST_TYPE
						   AND MEASURE_GROUP          =   DM_PLN_CUSTOMER_PSI.MEASURE_GROUP
						   AND MEASURE                =   DM_PLN_CUSTOMER_PSI.MEASURE
						   AND YYYYMMDD               =   DM_PLN_CUSTOMER_PSI.YYYYMMDD
						   AND INCOTERMS              =   DM_PLN_CUSTOMER_PSI.INCOTERMS
						   AND PLANT_SITE_ID          =   DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID
					  ) > 0;
	END;

	--===================================================================================== INSERT INTO 전 DELETE FROM end
	--===================================================================================== INSERT INTO start
	BEGIN

			   INSERT INTO DM_PLN_CUSTOMER_PSI
			   SELECT
					   v_DIVISION_ID
					  ,v_CUSTOMER_PROJECT_CODE
					  ,v_CUSTOMER_MODEL
					  ,v_SCM_SITE_ID
					  ,v_DOM_EXP
					  ,v_FCST_TYPE
					  ,v_MEASURE_GROUP
					  ,v_MEASURE
					  ,v_YYYYMMDD
					  ,v_INCOTERMS
					  ,v_PLANT_SITE_ID
					  ,v_PROJECT_CODE
					  ,v_ITEM_ID
					  ,v_QTY
					  ,v_UPLOAD_UOM
					  ,v_CREATED_BY
					  ,SYSDATE
					  ,v_CREATED_BY
					  ,SYSDATE
					  ,'UI' --BATCH_RESULT
					  ,null --MST_UPLOAD_UOM
					  ,null --MST_UPLOAD_BUCKET_TYPE
					  ,null --MST_SUMMARY_BUCKET_TYPE
					  ,null --MST_CONVERT_QTY
					  ,null --PLAN_WEEK
					  ,null --SPLIT_RESULT
					  ,null,null,null,null,null,null,null,null,null,null
			  FROM GT_SCFU_RESULTS;

	END;

	--===================================================================================== INSERT INTO end
	       -- 시작과 종료일자 사이에 정보를 일괄 update 함. added by ytchoi 180314
			update  DM_PLN_CUSTOMER_PSI
			   set batch_result = 'UI'
			 where (
					 select count(1)
					   from (
					        select
					              division_id,
					              scm_site_id,
					              customer_project_code,
					              customer_model,
					              incoterms,
					              fcst_type,
					              dom_exp,
					              measure_group,
					              measure,
					              PLANT_SITE_ID,
					              min(yyyymmdd) min_yyyymmdd,
					              max(yyyymmdd) max_yyyymmdd
					          from DM_PLN_CUSTOMER_PSI
					         where batch_result = 'UI'
					        group by division_id,
					              scm_site_id,
					              customer_project_code,
					              customer_model,
					              incoterms,
					              fcst_type,
					              dom_exp,
					              measure_group,
					              measure,
					              PLANT_SITE_ID
					        ) a
					  where a.division_id            = DM_PLN_CUSTOMER_PSI.division_id
						and a.scm_site_id            = DM_PLN_CUSTOMER_PSI.scm_site_id
						and a.customer_project_code  = DM_PLN_CUSTOMER_PSI.customer_project_code
						and a.customer_model         = DM_PLN_CUSTOMER_PSI.customer_model
						and a.incoterms              = DM_PLN_CUSTOMER_PSI.incoterms
						and a.fcst_type              = DM_PLN_CUSTOMER_PSI.fcst_type
						and a.dom_exp                = DM_PLN_CUSTOMER_PSI.dom_exp
						and a.measure_group          = DM_PLN_CUSTOMER_PSI.measure_group
						and a.measure                = DM_PLN_CUSTOMER_PSI.measure
						and a.PLANT_SITE_ID          = DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID
						and DM_PLN_CUSTOMER_PSI.yyyymmdd between a.min_yyyymmdd and a.max_yyyymmdd
				   ) > 0;

	--===================================================================================== HISTORY INSERT INTO start
	BEGIN

			   INSERT INTO DM_PLN_CUSTOMER_PSI_H
			   SELECT
					 v_division_id
					,SEQ1_DM_PLN_CUSTOMER_PSI_H.NEXTVAL
					,v_CUSTOMER_PROJECT_CODE
					,v_CUSTOMER_MODEL
					,v_SCM_SITE_ID
					,v_DOM_EXP
					,v_FCST_TYPE
					,v_MEASURE_GROUP
					,v_MEASURE
					,v_YYYYMMDD
					,v_INCOTERMS
					,v_PLANT_SITE_ID
					,v_PROJECT_CODE
					,v_ITEM_ID
					,TO_NUMBER(v_QTY)
					,v_UPLOAD_UOM
					,v_CREATED_BY
					,SYSDATE
					,v_CREATED_BY
					,SYSDATE
					,'UI',null,null,null,null,null,null
					,null,null,null,null,null,null,null,null,null,null
					FROM GT_SCFU_RESULTS;

	END;

	--===================================================================================== HISTORY INSERT INTO end
		BEGIN
	        PR_DM_PLN_CUST_FCST_TO_MKT_FCST(v_dummy_cursor);
        END;

		COMMIT;

		-- END TRY

	    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

    EXCEPTION
	    WHEN OTHERS THEN
      -- ERROR LOG
            v_log_type := 'ERROR';
      v_log_message := SUBSTR(SQLERRM, 1, 1000);
      v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      d_event_date := SYSTIMESTAMP;
	  NULL;

      PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

    -- END CATCH

	-- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	        RAISE_APPLICATION_ERROR(-20001,
	            '[' || v_program_name || '] SQLCODE=' || SQLCODE ||
	            ' / SQLERRM=' || SQLERRM ||
	            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	            ' / PARAMS=' || v_in_para_data
	        );
  END;
/
