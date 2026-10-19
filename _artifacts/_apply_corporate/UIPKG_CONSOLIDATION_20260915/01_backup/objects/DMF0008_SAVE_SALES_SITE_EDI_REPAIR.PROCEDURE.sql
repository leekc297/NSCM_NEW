-- SOURCE-FRESH: SCM_MGR.DMF0008_SAVE_SALES_SITE_EDI_REPAIR PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_SAVE_SALES_SITE_EDI_REPAIR" 
(
		p_division_id					IN  VARCHAR2,
		p_end_customer				IN  VARCHAR2,
		p_soldto_customer			IN  VARCHAR2,
		p_company_id					IN  VARCHAR2,
		p_scm_site_id					IN  VARCHAR2,
		p_soldto_code					IN  VARCHAR2,
		p_shipto_code					IN  VARCHAR2,
		p_vmi_yn							IN  VARCHAR2,
		p_valid_yn						IN  VARCHAR2,
		p_cust_valid_yn					IN  VARCHAR2,
		p_rep_yn							IN  VARCHAR2,
		p_country						IN  VARCHAR2,
		p_city								IN  VARCHAR2,
		p_ship_plan_auto				IN  VARCHAR2,
		p_dept_id						IN  VARCHAR2,
		p_created_by					IN  VARCHAR2,
		p_message_cursor				OUT SYS_REFCURSOR
)


IS

	/* SET NOCOUNT ON; */
	/* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; */
	/* SET XACT_ABORT ON; */

	v_DIVISION_ID				VARCHAR2(32767);
	v_END_CUSTOMER			VARCHAR2(32767);
	v_SOLDTO_CUSTOMER	VARCHAR2(32767);
	v_COMPANY_ID				VARCHAR2(32767);
	v_SCM_SITE_ID				VARCHAR2(32767);
	v_SOLDTO_CODE			VARCHAR2(32767);
	v_SHIPTO_CODE				VARCHAR2(32767);
	v_VMI_YN						VARCHAR2(32767);
	v_VALID_YN					VARCHAR2(32767);
	v_CUST_VALID_YN			VARCHAR2(32767);
	v_REP_YN						VARCHAR2(32767);
	v_COUNTRY					VARCHAR2(32767);
	v_CITY							VARCHAR2(32767);
	v_SHIP_PLAN_AUTO			VARCHAR2(32767);
	v_DEPT_ID						VARCHAR2(32767);
	v_CREATED_BY				VARCHAR2(32767);

	v_delimiter VARCHAR2(1 CHAR);

	max_loop_cnt		PLS_INTEGER := 0;
	mst_loop_cnt		PLS_INTEGER := 0;

	-- LOG 용 변수 설정
	v_program_name		VARCHAR2(150 CHAR) := 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR';
	v_log_type				VARCHAR2(30 CHAR); -- START/END/ERROR/...
	n_log_count			PLS_INTEGER := 0;
	v_log_message		VARCHAR2(1000 CHAR);
	v_description			VARCHAR2(500 CHAR);
	d_event_date			DATE;

	-- 결과 메시지 보관 (MSSQL SELECT N'...' 대체)
	v_result_message		VARCHAR2(4000 CHAR);

	-- 사용자 정의 예외 (INVALID 상태 처리용, goto err_rtn 대체)
	e_invalid_data EXCEPTION;

BEGIN

	v_DIVISION_ID				:= NULL;
	v_END_CUSTOMER			:= NULL;
	v_SOLDTO_CUSTOMER	:= NULL;
	v_COMPANY_ID				:= NULL;
	v_SCM_SITE_ID				:= NULL;
	v_SOLDTO_CODE			:= NULL;
	v_SHIPTO_CODE				:= NULL;
	v_VMI_YN						:= NULL;
	v_VALID_YN					:= NULL;
	v_CUST_VALID_YN			:= NULL;
	v_REP_YN						:= NULL;
	v_COUNTRY					:= NULL;
	v_CITY							:= NULL;
	v_SHIP_PLAN_AUTO			:= NULL;
	v_DEPT_ID						:= NULL;
	v_CREATED_BY				:= NULL;

	v_delimiter := '^';

	-- 시작 LOG
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := '';
	d_event_date := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-- BEGIN TRAN SAVE_SALES_SITE_EDI;
	SAVEPOINT SAVE_SALES_SITE_EDI;

	BEGIN

		-- 프로시저 LOOP 길이를 판단
		max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
		WHILE LENGTH(p_division_id) > 0 AND mst_loop_cnt < max_loop_cnt
		LOOP

			-- @mst_loop_cnt 1증가
			mst_loop_cnt := mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				v_DIVISION_ID := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_DIVISION_ID

				v_END_CUSTOMER := SCM_ARR_SPL_VAL(p_end_customer, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_END_CUSTOMER

				v_SOLDTO_CUSTOMER := SCM_ARR_SPL_VAL(p_soldto_customer, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SOLDTO_CUSTOMER

				v_COMPANY_ID := SCM_ARR_SPL_VAL(p_company_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_COMPANY_ID

				v_SCM_SITE_ID := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SCM_SITE_ID

				v_SOLDTO_CODE := SCM_ARR_SPL_VAL(p_soldto_code, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SOLDTO_CODE

				v_SHIPTO_CODE := SCM_ARR_SPL_VAL(p_shipto_code, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SHIPTO_CODE

				v_VMI_YN := SCM_ARR_SPL_VAL(p_vmi_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_VMI_YN

				v_VALID_YN := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_VALID_YN

				v_CUST_VALID_YN := SCM_ARR_SPL_VAL(p_cust_valid_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_CUST_VALID_YN

				v_REP_YN := SCM_ARR_SPL_VAL(p_rep_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_REP_YN

				v_COUNTRY := SCM_ARR_SPL_VAL(p_country, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_COUNTRY

				v_CITY := SCM_ARR_SPL_VAL(p_city, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_CITY

				v_SHIP_PLAN_AUTO := SCM_ARR_SPL_VAL(p_ship_plan_auto, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SHIP_PLAN_AUTO

				v_DEPT_ID := SCM_ARR_SPL_VAL(p_dept_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_DEPT_ID

				v_created_by := p_created_by;

			END;

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF v_VALID_YN = '' OR v_VALID_YN IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := '필수 입력값을 확인하세요.';
				v_description := '필수 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_DIVISION_ID = '' OR v_DIVISION_ID IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Div 입력값을 확인하세요.';
				v_description := 'Div 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SCM_SITE_ID = '' OR v_SCM_SITE_ID IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Sales Site 입력값을 확인하세요.';
				v_description := 'Sales Site 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SOLDTO_CODE = '' OR v_SOLDTO_CODE IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Sold-To 입력값을 확인하세요.';
				v_description := 'Sold-To 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SHIPTO_CODE = '' OR v_SHIPTO_CODE IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Rep Ship-To 입력값을 확인하세요.';
				v_description := 'Rep Ship-To 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_CUST_VALID_YN = '' OR v_CUST_VALID_YN IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Customer Active 입력값을 확인하세요.';
				v_description := 'Customer Active 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;
			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------

			--SCM_MST_SITE_HIST History 생성
			BEGIN
				INSERT INTO SCM_MST_SITE_H
						( HISTORY_SEQ, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, CITY, COUNTRY, DEPT_ID
						, VMI_YN, VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, END_CUSTOMER, SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, COMPANY_ID, SITE_ID, CREATED_BY, CREATION_DATE
						, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, HISTORY_CREATION_DATE )
				SELECT SEQ1_SCM_MST_SITE_H.NEXTVAL, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, v_CITY, v_COUNTRY, '-' AS DEPT_ID         -- v_DEPT_ID2026.09.06 AJS  
						, v_VMI_YN, v_VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, v_END_CUSTOMER, v_SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, v_COMPANY_ID, SITE_ID, v_CREATED_BY, SYSDATE
						, v_CREATED_BY, SYSDATE, ATTRIBUTE1, v_SHIP_PLAN_AUTO, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SYSDATE
				FROM SCM_MST_SITE
				WHERE DIVISION_ID = v_DIVISION_ID
				AND SCM_SITE_ID = v_SCM_SITE_ID;
			END;

			--SCM_MST_SITE_CUSTOMER History 생성
			BEGIN
				PR_DM_MST_SITE_CUSTOMER_HIST(
							 v_DIVISION_ID
							, v_SCM_SITE_ID
							, v_SOLDTO_CODE
							, v_SHIPTO_CODE
							, v_REP_YN
							, v_CREATED_BY
							, v_CUST_VALID_YN);
			END;

			IF mst_loop_cnt > 0 THEN

				BEGIN

					--SCM_MST_SITE_CUSTOMER
					MERGE INTO SCM_MST_SITE_CUSTOMER A
					USING (
								SELECT
									v_DIVISION_ID	AS DIVISION_ID,
									v_SCM_SITE_ID	AS SITE_ID,
									v_SOLDTO_CODE AS SOLDTO_CODE,
									v_SHIPTO_CODE AS SHIPTO_CODE
								FROM DUAL
							) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID
							AND A.SOLDTO_CODE = B.SOLDTO_CODE
							AND A.SHIPTO_CODE = B.SHIPTO_CODE
					)
					WHEN MATCHED THEN
						UPDATE SET
								    REP_YN = NVL(v_REP_YN, 'N')
								  , VALID_YN = NVL(v_CUST_VALID_YN, 'N')
								  , LAST_UPDATED_BY = v_CREATED_BY
								  , LAST_UPDATE_DATE = SYSDATE

					WHEN NOT MATCHED THEN
						INSERT (
									 DIVISION_ID
								   , SCM_SITE_ID
								   , SOLDTO_CODE
								   , SHIPTO_CODE
								   , REP_YN
								   , VALID_YN
								   , CREATED_BY
								   , CREATION_DATE
								   , LAST_UPDATED_BY
								   , LAST_UPDATE_DATE
								   )
						VALUES (
									 v_DIVISION_ID
								   , v_SCM_SITE_ID
								   , v_SOLDTO_CODE
								   , v_SHIPTO_CODE
								   , NVL(v_REP_YN, 'N')
								   , NVL(v_CUST_VALID_YN, 'N')
								   , v_CREATED_BY
								   , SYSDATE
								   , v_CREATED_BY
								   , SYSDATE
								   );

					--SCM_MST_SITE

					--임시확인용
					/* SELECT @v_DIVISION_ID AS DIVISION_ID, @v_SCM_SITE_ID AS  SCM_SITE_ID, @v_SOLDTO_CODE AS SOLDTO_CODE, @v_SHIPTO_CODE AS SHIPTO_CODE, @v_VALID_YN AS VALID_YN */
					NULL;

					MERGE INTO SCM_MST_SITE A
					USING (
							SELECT
								v_DIVISION_ID	AS DIVISION_ID,
								v_SCM_SITE_ID	AS SITE_ID
							FROM DUAL
						) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID

						)
					WHEN MATCHED THEN
						UPDATE SET
									CITY = v_CITY
								  , COUNTRY = v_COUNTRY
--								  ,	DEPT_ID	= v_DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 갱신 제외
								  ,	VMI_YN = NVL(v_VMI_YN, 'N')
								  ,	VALID_YN = v_VALID_YN
								  , END_CUSTOMER = v_END_CUSTOMER
								  , SOLDTO_CUSTOMER = v_SOLDTO_CUSTOMER
								  , COMPANY_ID = v_COMPANY_ID
								  , ATTRIBUTE2 = v_SHIP_PLAN_AUTO
								  , LAST_UPDATED_BY = v_CREATED_BY
								  , LAST_UPDATE_DATE	= SYSDATE

					WHEN NOT MATCHED THEN
						INSERT (
								     DIVISION_ID
								   , SCM_SITE_ID
								   , SITE_DESCRIPTION
								   , SITE_TYPE
								   , END_CUSTOMER
								   , SOLDTO_CUSTOMER
								   , CITY
								   , COUNTRY
--								   , DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 등록 제외
								   , VMI_YN
								   , VALID_YN
								   , NEW_YN
								   , COMPANY_ID
								   , CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								   ,ATTRIBUTE2
								   )
						VALUES (
									 v_DIVISION_ID
								   , v_SCM_SITE_ID
								   , v_SCM_SITE_ID
								   , 'SALES'
								   , v_END_CUSTOMER
								   , v_SOLDTO_CUSTOMER
								   , v_CITY
								   , v_COUNTRY
--								   , v_DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 등록 제외 (VALUES 대응)
								   , NVL(v_VMI_YN, 'N')
								   , v_VALID_YN
								   , 'Y'
								   , v_COMPANY_ID
								   , v_CREATED_BY
								   , SYSDATE
								   , v_CREATED_BY
								   , SYSDATE
								   , v_SHIP_PLAN_AUTO
								   );

				END;

			END IF;

		END LOOP;

/*
  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81', @p_end_customer='BMW', @p_soldto_customer='BMW'
	, @p_company_id='G480', @p_scm_site_id='BMW_AT_GRZ', @p_soldto_code='AT000003A', @p_shipto_code='AT000003A'
	, @p_vmi_yn='N', @p_valid_yn='Y', @p_cust_valid_yn='Y', @p_rep_yn='Y'
	, @p_country='AT', @p_city='ATGRZ', @p_ship_plan_auto='Y', @p_dept_id='58665472', @p_created_by='kdmcc14'

  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81^81', @p_end_customer='BMW^BMW', @p_soldto_customer='BMW^BMW'
	, @p_company_id='G480^G480', @p_scm_site_id='BMW_AT_GRZ^BMW_AT_SER', @p_soldto_code='AT000003A^DE000272', @p_shipto_code='AT000003A^ATH000024'
	, @p_vmi_yn='N^N', @p_valid_yn='Y^Y', @p_cust_valid_yn='Y^Y', @p_rep_yn='Y^Y'
	, @p_country='AT^AT', @p_city='ATGRZ^ATSER', @p_ship_plan_auto='Y^Y', @p_dept_id='58665472^58665472', @p_created_by='kdmcc14'

 */

		COMMIT;

	EXCEPTION
		WHEN e_invalid_data THEN
			-- 트랜잭션 (END)
			-- err_rtn:
			IF v_log_type = 'INVALID' THEN
				ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;
				v_log_type := 'END';
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSDATE;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			END IF;

		WHEN OTHERS THEN

			ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;

			-- ERROR LOG
			v_log_type := 'ERROR';
			v_log_message := SUBSTR(SQLERRM, 1, 1000);
			v_description := 'ERROR_LINE : ' || TO_CHAR($$PLSQL_LINE);
			d_event_date := SYSDATE;

			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

			v_result_message := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

	END;

	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := '';
	d_event_date := SYSDATE;

	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 결과 메시지 반환 (MSSQL SELECT N'필수 입력값을 확인하세요.' / ERROR_MESSAGE 결과셋 → SYS_REFCURSOR OUT)
	OPEN p_message_cursor FOR
		SELECT v_result_message AS RESULT_MSG FROM DUAL;

END;
/
