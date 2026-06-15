CREATE OR REPLACE PROCEDURE           "DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO"
(

	-- Add the parameters for the stored procedure here
     p_active_flag				VARCHAR2
    ,p_ver_seq					VARCHAR2
    ,p_department_id			VARCHAR2
    ,p_dept_id					VARCHAR2
    ,p_end_cust_report			VARCHAR2
    ,p_soldto_cust_report		VARCHAR2
    ,p_product_group			VARCHAR2
    ,p_dm_biz_type				VARCHAR2
    ,p_yyyymm					VARCHAR2
    ,p_os_corp_cd				VARCHAR2
    ,p_contribution_type		VARCHAR2
    ,p_contribution_ratio		VARCHAR2
    ,p_created_by				VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
 * Description	: 'DM_MST_CONTRIBUTE_RATIO' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 20190730  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 12:16:41
 * 파일: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ LOOP: LOOP:1  END LOOP:0  차이:+1
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * IF 위치:     L147, L193, L278, L470
 * END IF 위치: L343, L344, L483
 * BEGIN 위치:  L77, L225, L310, L371
 * END;  위치:  L256, L341, L402, L437, L485
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L131
 * END LOOP 위치:
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_active_flag VARCHAR2(4000 CHAR);
    v_ver_seq VARCHAR2(4000 CHAR);
    v_department_id VARCHAR2(4000 CHAR);
    v_dept_id VARCHAR2(4000 CHAR);
    v_end_cust_report VARCHAR2(4000 CHAR);
    v_soldto_cust_report VARCHAR2(4000 CHAR);
    v_product_group VARCHAR2(4000 CHAR);
    v_dm_biz_type VARCHAR2(4000 CHAR);
    v_yyyymm VARCHAR2(4000 CHAR);
    v_os_corp_cd VARCHAR2(4000 CHAR);
    v_contribution_type VARCHAR2(4000 CHAR);
    v_contribution_ratio VARCHAR2(4000 CHAR);
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
    v_index_department_id INTEGER;
    v_index_dept_id INTEGER;
    v_index_end_cust_report INTEGER;
    v_index_soldto_cust_report INTEGER;
    v_index_product_group INTEGER;
    v_index_dm_biz_type INTEGER;
    v_index_yyyymm INTEGER;
    v_index_os_corp_cd INTEGER;
    v_index_contribution_type INTEGER;
    v_index_contribution_ratio INTEGER;
    v_index_created_by INTEGER;
    v_in_para_data CLOB;
    vp_active_flag VARCHAR2(4000 CHAR);
    vp_ver_seq VARCHAR2(4000 CHAR);
    vp_department_id VARCHAR2(4000 CHAR);
    vp_dept_id VARCHAR2(4000 CHAR);
    vp_end_cust_report VARCHAR2(4000 CHAR);
    vp_soldto_cust_report VARCHAR2(4000 CHAR);
    vp_product_group VARCHAR2(4000 CHAR);
    vp_dm_biz_type VARCHAR2(4000 CHAR);
    vp_yyyymm VARCHAR2(4000 CHAR);
    vp_os_corp_cd VARCHAR2(4000 CHAR);
    vp_contribution_type VARCHAR2(4000 CHAR);
    vp_contribution_ratio VARCHAR2(4000 CHAR);
    vp_created_by VARCHAR2(4000 CHAR);
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_active_flag' VALUE p_active_flag,
	    'p_ver_seq' VALUE p_ver_seq,
	    'p_department_id' VALUE p_department_id,
	    'p_dept_id' VALUE p_dept_id,
	    'p_end_cust_report' VALUE p_end_cust_report,
	    'p_soldto_cust_report' VALUE p_soldto_cust_report,
	    'p_product_group' VALUE p_product_group,
	    'p_dm_biz_type' VALUE p_dm_biz_type,
	    'p_yyyymm' VALUE p_yyyymm,
	    'p_os_corp_cd' VALUE p_os_corp_cd,
	    'p_contribution_type' VALUE p_contribution_type,
	    'p_contribution_ratio' VALUE p_contribution_ratio,
	    'p_created_by' VALUE p_created_by
	  );

	-- 스플릿관련 변수
	v_delimiter := '^'; -- 데이터 구분자

	vp_active_flag := RTRIM(p_active_flag				    )  ||  '^';
	vp_ver_seq := RTRIM(p_ver_seq					    )  ||  '^';
	vp_department_id := RTRIM(p_department_id			    )  ||  '^';
	vp_dept_id := RTRIM(p_dept_id					    )  ||  '^';
	vp_end_cust_report := RTRIM(p_end_cust_report			    )  ||  '^';
	vp_soldto_cust_report := RTRIM(p_soldto_cust_report			)  ||  '^';
	vp_product_group := RTRIM(p_product_group			    )  ||  '^';
	vp_dm_biz_type := RTRIM(p_dm_biz_type				    )  ||  '^';
	vp_yyyymm := RTRIM(p_yyyymm					    )  ||  '^';
	vp_os_corp_cd := RTRIM(p_os_corp_cd				    )  ||  '^';
	vp_contribution_type := RTRIM(p_contribution_type		    )  ||  '^';
	vp_contribution_ratio := RTRIM(p_contribution_ratio		    )  ||  '^';
	vp_created_by := RTRIM(p_created_by				    )  ||  '^';

	-- GT_SDMCR_RESULTS_MST_2 TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCR_RESULTS_MST_2';

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
	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO start
	--###############################################  GT_SDMCR_RESULTS_MST_2 테이블에 split후 insert (START)
	WHILE LENGTH(vp_ver_seq) > 0 LOOP

		v_index_active_flag := INSTR(vp_active_flag, '^');
		v_index_ver_seq := INSTR(vp_ver_seq, '^');
		v_index_department_id := INSTR(vp_department_id, '^');
		v_index_dept_id := INSTR(vp_dept_id, '^');
		v_index_end_cust_report := INSTR(vp_end_cust_report, '^');
		v_index_soldto_cust_report := INSTR(vp_soldto_cust_report, '^');
		v_index_product_group := INSTR(vp_product_group, '^');
		v_index_dm_biz_type := INSTR(vp_dm_biz_type, '^');
		v_index_yyyymm := INSTR(vp_yyyymm, '^');
		v_index_os_corp_cd := INSTR(vp_os_corp_cd, '^');
		v_index_contribution_type := INSTR(vp_contribution_type, '^');
		v_index_contribution_ratio := INSTR(vp_contribution_ratio, '^');
		v_index_created_by := INSTR(vp_created_by, '^');

		IF vp_ver_seq is not null THEN

				v_active_flag := SUBSTR(vp_active_flag			, 1, v_index_active_flag - 1			);
				v_ver_seq := SUBSTR(vp_ver_seq				, 1, v_index_ver_seq - 1				);
				v_department_id := SUBSTR(vp_department_id		, 1, v_index_department_id - 1		);
				v_dept_id := SUBSTR(vp_dept_id				, 1, v_index_dept_id - 1				);
				v_end_cust_report := SUBSTR(vp_end_cust_report		, 1, v_index_end_cust_report - 1		);
				v_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, 1, v_index_soldto_cust_report - 1	);
				v_product_group := SUBSTR(vp_product_group		, 1, v_index_product_group - 1		);
				v_dm_biz_type := SUBSTR(vp_dm_biz_type			, 1, v_index_dm_biz_type - 1			);
				v_yyyymm := SUBSTR(vp_yyyymm				, 1, v_index_yyyymm - 1				);
				v_os_corp_cd := SUBSTR(vp_os_corp_cd			, 1, v_index_os_corp_cd - 1			);
				v_contribution_type := SUBSTR(vp_contribution_type	, 1, v_index_contribution_type - 1	);
				v_contribution_ratio := SUBSTR(vp_contribution_ratio	, 1, v_index_contribution_ratio - 1	);
				v_created_by := SUBSTR(vp_created_by			, 1, v_index_created_by - 1			);

				vp_active_flag := SUBSTR(vp_active_flag			, LENGTH(v_active_flag			 ||  '^') + 1, LENGTH(vp_active_flag			));
				vp_ver_seq := SUBSTR(vp_ver_seq				, LENGTH(v_ver_seq				|| '^') + 1, LENGTH(vp_ver_seq				));
				vp_department_id := SUBSTR(vp_department_id		, LENGTH(v_department_id			 ||  '^') + 1, LENGTH(vp_department_id		));
				vp_dept_id := SUBSTR(vp_dept_id				, LENGTH(v_dept_id				 ||  '^') + 1, LENGTH(vp_dept_id				));
				vp_end_cust_report := SUBSTR(vp_end_cust_report		, LENGTH(v_end_cust_report		 ||  '^') + 1, LENGTH(vp_end_cust_report		));
				vp_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, LENGTH(v_soldto_cust_report		 ||  '^') + 1, LENGTH(vp_soldto_cust_report	));
				vp_product_group := SUBSTR(vp_product_group		, LENGTH(v_product_group			 ||  '^') + 1, LENGTH(vp_product_group		));
				vp_dm_biz_type := SUBSTR(vp_dm_biz_type			, LENGTH(v_dm_biz_type			 ||  '^') + 1, LENGTH(vp_dm_biz_type			));
				vp_yyyymm := SUBSTR(vp_yyyymm				, LENGTH(v_yyyymm					 ||  '^') + 1, LENGTH(vp_yyyymm				));
				vp_os_corp_cd := SUBSTR(vp_os_corp_cd			, LENGTH(v_os_corp_cd				 ||  '^') + 1, LENGTH(vp_os_corp_cd			));
				vp_contribution_type := SUBSTR(vp_contribution_type	, LENGTH(v_contribution_type		 ||  '^') + 1, LENGTH(vp_contribution_type	));
				vp_contribution_ratio := SUBSTR(vp_contribution_ratio	, LENGTH(v_contribution_ratio		|| '^') + 1, LENGTH(vp_contribution_ratio	));
				vp_created_by := SUBSTR(vp_created_by			, LENGTH(v_created_by				 ||  '^') + 1, LENGTH(vp_created_by			));

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		ELSE
				v_ver_seq := vp_ver_seq;
				vp_ver_seq := NULL;

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		END IF;
	END LOOP;

	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO end
--select department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--		, SUM(CAST (Contribution_Ratio AS NUMBER(5,2)))
--from GT_SDMCR_RESULTS_MST_2
--GROUP BY department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--RAISE_APPLICATION_ERROR(-20001, 'sdf')
	-- INPUT COUNT 확인
	SELECT count(ver_seq) INTO n_input_count
								FROM GT_SDMCR_RESULTS_MST_2;

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT INTO COUNT 확인
		SELECT count(M.ver_seq) INTO n_logo_count
									FROM GT_SDMCR_RESULTS_MST_2 M
										where 1=1;

		-- MST INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_MST
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_MST.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_MST.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_MST.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_MST.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_MST.dm_biz_type			= M.dm_biz_type
				);
		-- MST INSERT전 DELETE수행 (END)
		-- MST INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,MAX(CREATED_BY),SYSDATE,MAX(CREATED_BY) LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1
		GROUP BY VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE;
		-- MST INSERT수행 (END)
	END;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇

		-- DTL INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_DTL
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_DTL.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_DTL.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_DTL.dm_biz_type			= M.dm_biz_type
				);
		-- DTL INSERT전 DELETE수행 (END)
		-- DTL INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,SYSDATE,CREATED_BY LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1;
		-- DTL INSERT수행 (END)

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
  	-- 트랜잭션 (COMMIT)
		-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
    COMMIT;
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
	ROLLBACK;

	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	  );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END;


