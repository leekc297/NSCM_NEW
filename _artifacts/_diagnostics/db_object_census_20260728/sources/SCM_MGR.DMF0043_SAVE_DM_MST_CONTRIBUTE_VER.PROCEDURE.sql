PROCEDURE           "DMF0043_SAVE_DM_MST_CONTRIBUTE_VER"
(

	-- Add the parameters for the stored procedure here
    p_active_flag	VARCHAR2,
    p_ver_seq		VARCHAR2,
    p_yyyy			VARCHAR2,
    p_version_nm	VARCHAR2,
    p_description	VARCHAR2,
    p_valid_yn		VARCHAR2,
    p_created_by	VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
 * Description	: 'DM_MST_CONTRIBUTE_VER' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 20190508  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 12:16:42
 * 파일: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:2  END:3  차이:-1
 * ----------------------------------------
 * IF 위치:     L110, L283, L395
 * END IF 위치: L190, L362, L408
 * BEGIN 위치:  L58, L201
 * END;  위치:  L221, L363, L410
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L100
 * END LOOP 위치: L191
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_active_flag VARCHAR2(4000 CHAR);
    v_ver_seq VARCHAR2(4000 CHAR);
    v_yyyy VARCHAR2(4000 CHAR);
    v_version_nm VARCHAR2(4000 CHAR);
    v_description VARCHAR2(4000 CHAR);
    v_valid_yn VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_max_ver_seq VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_log_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_input_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_ver_seq INTEGER;
    v_index_yyyy INTEGER;
    v_index_version_nm INTEGER;
    v_index_description INTEGER;
    v_index_valid_yn INTEGER;
    v_index_created_by INTEGER;
    v_in_para_data VARCHAR2(4000);
    v_w_active_flag VARCHAR2(4000 CHAR);
    v_w_ver_seq VARCHAR2(4000 CHAR);
    v_w_yyyy VARCHAR2(4000 CHAR);
    v_w_version_nm VARCHAR2(4000 CHAR);
    v_w_description VARCHAR2(4000 CHAR);
    v_w_valid_yn VARCHAR2(4000 CHAR);
    v_w_created_by VARCHAR2(4000 CHAR);
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_active_flag' VALUE p_active_flag,
	    'p_ver_seq' VALUE p_ver_seq,
	    'p_yyyy' VALUE p_yyyy,
	    'p_version_nm' VALUE p_version_nm,
	    'p_description' VALUE p_description,
	    'p_valid_yn' VALUE p_valid_yn,
	    'p_created_by' VALUE p_created_by
	  );

	-- 스플릿관련 변수
	v_delimiter := '^'; -- 데이터 구분자

	v_w_active_flag := RTRIM(p_active_flag	    )  ||  '^';
	v_w_ver_seq := RTRIM(p_ver_seq		    )  ||  '^';
	v_w_yyyy := RTRIM(p_yyyy			    )  ||  '^';
	v_w_version_nm := RTRIM(p_version_nm	    )  ||  '^';
	v_w_description := RTRIM(p_description	    )  ||  '^';
	v_w_valid_yn := RTRIM(p_valid_yn		    )  ||  '^';
	v_w_created_by := RTRIM(p_created_by	    )  ||  '^';

	-- GT_SDMCV_RESULTS_MST_2 TEMP TABLE
	DELETE FROM GT_SDMCV_RESULTS_MST_2;

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure @@@##########';
	v_log_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
	-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
	--===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO start
	--###############################################  GT_SDMCV_RESULTS_MST_2 테이블에 split후 insert (START)
	WHILE LENGTH(v_w_yyyy) > 0 LOOP

		v_index_active_flag := INSTR(v_w_active_flag, '^');
		v_index_ver_seq := INSTR(v_w_ver_seq, '^');
		v_index_yyyy := INSTR(v_w_yyyy, '^');
		v_index_version_nm := INSTR(v_w_version_nm, '^');
		v_index_description := INSTR(v_w_description, '^');
		v_index_valid_yn := INSTR(v_w_valid_yn, '^');
		v_index_created_by := INSTR(v_w_created_by, '^');

		IF v_index_yyyy > 0 THEN

				v_active_flag := SUBSTR(v_w_active_flag, 1, v_index_active_flag - 1);
				v_w_active_flag := SUBSTR(v_w_active_flag, LENGTH(v_active_flag  ||  '^') + 1, LENGTH(v_w_active_flag));

				v_ver_seq := SUBSTR(v_w_ver_seq, 1, v_index_ver_seq - 1);
				v_w_ver_seq := SUBSTR(v_w_ver_seq, LENGTH(v_ver_seq || '^') + 1, LENGTH(v_w_ver_seq));

				v_yyyy := SUBSTR(v_w_yyyy, 1, v_index_yyyy - 1);
				v_w_yyyy := SUBSTR(v_w_yyyy, LENGTH(v_yyyy  ||	'^') + 1, LENGTH(v_w_yyyy));

				v_version_nm := SUBSTR(v_w_version_nm, 1, v_index_version_nm - 1);
				v_w_version_nm := SUBSTR(v_w_version_nm, LENGTH(v_version_nm  ||  '^') + 1, LENGTH(v_w_version_nm));

				v_description := SUBSTR(v_w_description, 1, v_index_description - 1);
				v_w_description := SUBSTR(v_w_description, LENGTH(v_description  ||  '^') + 1, LENGTH(v_w_description));

				v_valid_yn := SUBSTR(v_w_valid_yn, 1, v_index_valid_yn - 1);
				v_w_valid_yn := SUBSTR(v_w_valid_yn, LENGTH(v_valid_yn	||  '^') + 1, LENGTH(v_w_valid_yn));

				v_created_by := SUBSTR(v_w_created_by, 1, v_index_created_by - 1);
				v_w_created_by := SUBSTR(v_w_created_by, LENGTH(v_created_by  ||  '^') + 1, LENGTH(v_w_created_by));

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag			));
				v_ver_seq := rtrim(ltrim(v_ver_seq		));
				v_yyyy := rtrim(ltrim(v_yyyy			));
				v_version_nm := rtrim(ltrim(v_version_nm		));
				v_description := rtrim(ltrim(v_description	));
				v_valid_yn := rtrim(ltrim(v_valid_yn		));
				v_created_by := rtrim(ltrim(v_created_by		));
				--공백제거
				INSERT INTO GT_SDMCV_RESULTS_MST_2 (
										 active_flag
										,ver_seq
										,yyyy
										,version_nm
										,description
										,valid_yn
										,created_by
				) VALUES (
										 v_active_flag
										,v_ver_seq
										,v_yyyy
										,v_version_nm
										,v_description
										,v_valid_yn
										,v_created_by
				);

		ELSE
				v_yyyy := v_w_yyyy;
				v_w_yyyy := NULL;

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag	));
				v_ver_seq := rtrim(ltrim(v_ver_seq		));
				v_yyyy := rtrim(ltrim(v_yyyy			));
				v_version_nm := rtrim(ltrim(v_version_nm		));
				v_description := rtrim(ltrim(v_description	));
				v_valid_yn := rtrim(ltrim(v_valid_yn		));
				v_created_by := rtrim(ltrim(v_created_by		));
				--공백제거
				INSERT INTO GT_SDMCV_RESULTS_MST_2 (
										 active_flag
										,ver_seq
										,yyyy
										,version_nm
										,description
										,valid_yn
										,created_by
				) VALUES (
										 v_active_flag
										,v_ver_seq
										,v_yyyy
										,v_version_nm
										,v_description
										,v_valid_yn
										,v_created_by
				);
			END IF;
	END LOOP;

	--===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO end
	-- INPUT COUNT 확인
	SELECT count(yyyy) INTO n_input_count
								FROM GT_SDMCV_RESULTS_MST_2;

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN

		-- DELETE FROM COUNT 확인
		SELECT COUNT(YYYY)  INTO n_delete_count FROM DM_MST_CONTRIBUTE_VER A
								WHERE (
										SELECT count(1)
											FROM GT_SDMCV_RESULTS_MST_2 M
											where M.active_flag		= 'D'
												and A.VER_SEQ	= M.VER_SEQ
										) > 0;

		--  select * from GT_SDMCV_RESULTS_MST_2
		DELETE
		FROM DM_MST_CONTRIBUTE_VER
		WHERE (
				SELECT count(1)
					FROM GT_SDMCV_RESULTS_MST_2 M
					where M.active_flag		= 'D'
						and DM_MST_CONTRIBUTE_VER.VER_SEQ	= M.VER_SEQ
				) > 0;
	END;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇

		-- INSERT INTO COUNT 확인
		SELECT count(M.yyyy) INTO n_insert_count
									FROM GT_SDMCV_RESULTS_MST_2 M
										where M.active_flag	 <> 'D';

					MERGE INTO DM_MST_CONTRIBUTE_VER A
					USING (
							SELECT *
								FROM GT_SDMCV_RESULTS_MST_2 M
									where M.active_flag	 <> 'D'
						  ) B
					ON(
							    A.VER_SEQ = B.VER_SEQ
					  )
					WHEN MATCHED THEN
						 UPDATE SET
									 A.YYYY				= B.YYYY
									,A.VERSION_NM		= B.VERSION_NM
									,A.DESCRIPTION		= B.DESCRIPTION
									,A.VALID_YN			= B.VALID_YN
								    ,A.last_updated_by	= B.CREATED_BY
								    ,A.last_update_date	= SYSDATE

					WHEN NOT MATCHED THEN

						 INSERT ( -- VER_SEQ
								   YYYY
								  ,VERSION_NM
								  ,DESCRIPTION
								  ,VALID_YN
								  ,CREATED_BY
								  ,CREATION_DATE
								  ,LAST_UPDATED_BY
								  ,LAST_UPDATE_DATE
								  ,ATTRIBUTE1
								  ,ATTRIBUTE2
								  ,ATTRIBUTE3
								  ,ATTRIBUTE4
								  ,ATTRIBUTE5
								)
						 VALUES (   B.YYYY
								   ,B.VERSION_NM
								   ,B.DESCRIPTION
								   ,B.VALID_YN
								   ,B.CREATED_BY
								   ,SYSDATE
								   ,B.CREATED_BY
								   ,SYSDATE
								   ,NULL,NULL,NULL,NULL,NULL
								);

        -- 기여율 copy
	SELECT MAX(VER_SEQ) INTO v_max_ver_seq FROM DM_MST_CONTRIBUTE_VER;
	IF SQL%ROWCOUNT >= 0 THEN
	    SELECT COUNT(1) INTO n_logo_count
	      FROM DM_MST_CONTRIBUTE_RATIO_MST
	     WHERE VER_SEQ = v_max_ver_seq;
	END IF;
	IF n_logo_count = 0 THEN
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
		     ( VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , YYYYMM
		     , OS_CORP_CD
		     , CONTRIBUTION_TYPE
		     , CONTRIBUTION_RATIO
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
		SELECT v_max_ver_seq AS VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , (SELECT YYYY
			  FROM DM_MST_CONTRIBUTE_VER
			 WHERE VER_SEQ = v_max_ver_seq)  ||  SUBSTR(YYYYMM,5,2)
		     , OS_CORP_CD
		     , CONTRIBUTION_TYPE
		     , CONTRIBUTION_RATIO
		     , p_created_by
		     , SYSDATE
		     , p_created_by
		     , SYSDATE
				     , NULL,NULL,NULL,NULL,NULL
		  FROM DM_MST_CONTRIBUTE_RATIO_DTL
		 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST );

		INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
		     ( VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
		SELECT v_max_ver_seq AS VER_SEQ
		     , DEPARTMENT_ID
		     , DEPT_ID
		     , END_CUST_REPORT
		     , SOLDTO_CUST_REPORT
		     , PRODUCT_GROUP
		     , DM_BIZ_TYPE
		     , p_created_by
		     , SYSDATE
		     , p_created_by
		     , SYSDATE
				     , NULL,NULL,NULL,NULL,NULL
		  FROM DM_MST_CONTRIBUTE_RATIO_MST
		 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST );

	    END IF;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
  	-- 트랜잭션 (COMMIT)
		-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
	WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		v_log_type := 'ERROR';
		v_log_message := SUBSTR(SQLERRM, 1, 1000);
		v_log_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
		d_event_date := SYSTIMESTAMP;

		v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data	=> v_in_para_data,
	p_sql_err_code	=> SQLCODE,
	p_sql_err_msg	=> SQLERRM,
	p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL THEN
	  v_log_message := 'success';

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure @@@##########';
    v_log_description := 'input_count: '  ||  TO_CHAR(n_input_count) ;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );

  END IF;

END;