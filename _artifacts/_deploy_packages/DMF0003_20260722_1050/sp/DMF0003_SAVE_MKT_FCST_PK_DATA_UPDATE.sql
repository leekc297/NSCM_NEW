CREATE OR REPLACE PROCEDURE           "DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE"
(

	-- Add the parameters for the stored procedure here
	 p_division_id			VARCHAR2
	,p_project_code		VARCHAR2
	,p_scm_site_id			VARCHAR2
	,p_item_id				VARCHAR2
	,p_dom_exp				VARCHAR2
	,p_fcst_type			VARCHAR2
	,p_incoterms			VARCHAR2
	,p_plant_site_id  	    VARCHAR2

	,p_dom_exp_new		    VARCHAR2
	,p_fcst_type_new		VARCHAR2
	,p_incoterms_new		VARCHAR2
	,p_plant_site_id_new	VARCHAR2
	,p_created_by      	VARCHAR2

/*
 * Program ID   : DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
 * Description  : MKT FCST 화면에서 팝업화면을 띄워서 INCOTERMS등 PK값을 수정할수 있도록 함.
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2018.05.16   KHSONG         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * 20180601 pk값 validation KHSONG
 * 20180807
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/05/04     P.C.I		[C20210504-000051] Sales Plan, Sales Price 적용 기준 변경
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.08.06		hwi1993		중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2022.11.04		rosia27		[C20221024-000510]DM UI 소스 정리 요청
 * 2022.12.07		hwi1993		[C20221205-000135] GSCM Master change 인코텀즈 변경 기능 개선
 * 2026.05.22		byunmj0223	oracle 버전으로 수정
 * ---------------------------------------------------------------------------------------------------
 */
)
AS
	/* 가공된 파라미터 변수들 */
	 p_division_id_process			VARCHAR2(4000 CHAR);
	p_project_code_process		VARCHAR2(4000 CHAR);
	p_scm_site_id_process			VARCHAR2(4000 CHAR);
	p_item_id_process				VARCHAR2(4000 CHAR);
	p_dom_exp_process			VARCHAR2(4000 CHAR);
	p_fcst_type_process			VARCHAR2(4000 CHAR);
	p_incoterms_process			VARCHAR2(4000 CHAR);
	p_plant_site_id_process  	    VARCHAR2(4000 CHAR);

	p_dom_exp_new_process		    VARCHAR2(4000 CHAR);
	p_fcst_type_new_process		VARCHAR2(4000 CHAR);
	p_incoterms_new_process		VARCHAR2(4000 CHAR);
	p_plant_site_id_new_process	VARCHAR2(4000 CHAR);
	p_created_by_process      	VARCHAR2(4000 CHAR);


    v_division_id VARCHAR2(4000 CHAR);
    v_project_code VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_item_id VARCHAR2(4000 CHAR);
    v_dom_exp VARCHAR2(4000 CHAR);
    v_fcst_type VARCHAR2(4000 CHAR);
    v_incoterms VARCHAR2(4000 CHAR);
    v_plant_site_id VARCHAR2(4000 CHAR);
    v_dom_exp_new VARCHAR2(4000 CHAR);
    v_fcst_type_new VARCHAR2(4000 CHAR);
    v_incoterms_new VARCHAR2(4000 CHAR);
    v_plant_site_id_new VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_index_division_id INTEGER;
    v_index_project_code INTEGER;
    v_index_scm_site_id INTEGER;
    v_index_item_id INTEGER;
    v_index_dom_exp INTEGER;
    v_index_fcst_type INTEGER;
    v_index_incoterms INTEGER;
    v_index_plant_site_id INTEGER;
    v_index_dom_exp_new INTEGER;
    v_index_fcst_type_new INTEGER;
    v_index_incoterms_new INTEGER;
    v_index_plant_site_id_new INTEGER;
    v_index_created_by INTEGER;
    m_DIVISION_ID VARCHAR2(4000 CHAR);
    m_SCM_SITE_ID VARCHAR2(4000 CHAR);
    m_PROJECT_CODE VARCHAR2(4000 CHAR);
    s_FUTURE_valid VARCHAR2(4000 CHAR);
    s_unit_price_valid VARCHAR2(1000 CHAR);
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_sql_code VARCHAR2(150 CHAR);
    v_err_message VARCHAR2(2000 CHAR);
    v_fetch_status INTEGER;

    GT_DMF0_results DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE_DMF0_RESULT_TAB;
    GT_DMF0_valid_results DMF0003_GT_DMF0_VAILD_RESULT_TAB;
    CURSOR1_MST SYS_REFCURSOR;
BEGIN
	v_division_id := NULL;
	v_project_code := NULL;
	v_scm_site_id := NULL;
	v_item_id := NULL;
	v_dom_exp := NULL;
	v_fcst_type := NULL;
	v_incoterms := NULL;
	v_plant_site_id := NULL;
	v_dom_exp_new := NULL;
	v_fcst_type_new := NULL;
	v_incoterms_new := NULL;
	v_plant_site_id_new := NULL;
	v_created_by := NULL;
    v_fetch_status := 0;

	-- LOG 용 변수 설정
	p_division_id_process := RTRIM(p_division_id		)  ||  '^';
	p_project_code_process := RTRIM(p_project_code		)  ||  '^';
	p_scm_site_id_process := RTRIM(p_scm_site_id		)  ||  '^';
	p_item_id_process := RTRIM(p_item_id			)  ||  '^';
	p_dom_exp_process := RTRIM(p_dom_exp			)  ||  '^';
	p_fcst_type_process := RTRIM(p_fcst_type		)  ||  '^';
	p_incoterms_process := RTRIM(p_incoterms		)  ||  '^';
	p_plant_site_id_process := RTRIM(p_plant_site_id	)  ||  '^';
	p_dom_exp_new_process := RTRIM(p_dom_exp_new      )  ||  '^';
	p_fcst_type_new_process := RTRIM(p_fcst_type_new    )  ||  '^';
	p_incoterms_new_process := RTRIM(p_incoterms_new    )  ||  '^';
	p_plant_site_id_new_process := RTRIM(p_plant_site_id_new)  ||  '^';
	p_created_by_process := RTRIM(p_created_by       )  ||  '^';

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL;      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)

	--===================================================================================== GT_DMF0_results 테이블에 split후 INSERT INTO start
	--###############################################  GT_DMF0_results 테이블에 split후 insert (START)
	WHILE LENGTH(p_DIVISION_ID) > 0	LOOP
	BEGIN
		v_index_division_id := REGEXP_INSTR(p_division_id_process, '^');
		v_index_project_code := REGEXP_INSTR(p_project_code_process, '^');
		v_index_scm_site_id := REGEXP_INSTR(p_scm_site_id_process,	'^');
		v_index_item_id := REGEXP_INSTR(p_item_id_process, '^');
		v_index_dom_exp := REGEXP_INSTR(p_dom_exp_process, '^');
		v_index_fcst_type := REGEXP_INSTR(p_fcst_type_process, '^');
		v_index_incoterms := REGEXP_INSTR(p_incoterms_process, '^');
		v_index_plant_site_id := REGEXP_INSTR(p_plant_site_id_process, '^');
		v_index_dom_exp_new := REGEXP_INSTR(p_dom_exp_new_process, '^');
		v_index_fcst_type_new := REGEXP_INSTR(p_fcst_type_new_process, '^');
		v_index_incoterms_new := REGEXP_INSTR(p_incoterms_new_process, '^');
		v_index_plant_site_id_new := REGEXP_INSTR(p_plant_site_id_new_process, '^');
		v_index_created_by := REGEXP_INSTR(p_created_by_process, '^');

	 -- 확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
		IF v_index_DIVISION_ID > 0 THEN
		  BEGIN
			   v_division_id := SUBSTR(p_division_id_process			, 0, v_index_division_id			);
			   v_project_code := SUBSTR(p_project_code_process			, 0, v_index_project_code		);
			   v_scm_site_id := SUBSTR(p_scm_site_id_process			, 0, v_index_scm_site_id			);
			   v_item_id := SUBSTR(p_item_id_process				, 0, v_index_item_id				);
			   v_dom_exp := SUBSTR(p_dom_exp_process				, 0, v_index_dom_exp				);
			   v_fcst_type := SUBSTR(p_fcst_type_process			, 0, v_index_fcst_type			);
			   v_incoterms := SUBSTR(p_incoterms_process			, 0, v_index_incoterms			);
			   v_plant_site_id := SUBSTR(p_plant_site_id_process		, 0, v_index_plant_site_id		);
			   v_dom_exp_new := SUBSTR(p_dom_exp_new_process			, 0, v_index_dom_exp_new         );
			   v_fcst_type_new := SUBSTR(p_fcst_type_new_process		, 0, v_index_fcst_type_new       );
			   v_incoterms_new := SUBSTR(p_incoterms_new_process		, 0, v_index_incoterms_new       );
			   v_plant_site_id_new := SUBSTR(p_plant_site_id_new_process	, 0, v_index_plant_site_id_new   );
			   v_created_by := SUBSTR(p_created_by_process			, 0, v_index_created_by		    );

			   p_division_id_process := SUBSTR(p_division_id_process		, LENGTH(v_division_id		 ||  '^') || 1, LENGTH(p_division_id_process		));
			   p_project_code_process := SUBSTR(p_project_code_process		, LENGTH(v_project_code		 ||  '^') || 1, LENGTH(p_project_code_process		));
			   p_scm_site_id_process := SUBSTR(p_scm_site_id_process		, LENGTH(v_scm_site_id		 ||  '^') || 1, LENGTH(p_scm_site_id_process		));
			   p_item_id_process := SUBSTR(p_item_id_process			, LENGTH(v_item_id			 ||  '^') || 1, LENGTH(p_item_id_process			));
			   p_dom_exp_process := SUBSTR(p_dom_exp_process			, LENGTH(v_dom_exp			 ||  '^') || 1, LENGTH(p_dom_exp_process			));
			   p_fcst_type_process := SUBSTR(p_fcst_type_process		, LENGTH(v_fcst_type			 ||  '^') || 1, LENGTH(p_fcst_type_process		));
			   p_incoterms_process := SUBSTR(p_incoterms_process		, LENGTH(v_incoterms			 ||  '^') || 1, LENGTH(p_incoterms_process		));
			   p_plant_site_id_process := SUBSTR(p_plant_site_id_process	, LENGTH(v_plant_site_id		 ||  '^') || 1, LENGTH(p_plant_site_id_process	));
			   p_dom_exp_new_process := SUBSTR(p_dom_exp_new_process      , LENGTH(v_dom_exp_new		 ||  '^') || 1, LENGTH(p_dom_exp_new_process      ));
			   p_fcst_type_new_process := SUBSTR(p_fcst_type_new_process    , LENGTH(v_fcst_type_new		 ||  '^') || 1, LENGTH(p_fcst_type_new_process    ));
			   p_incoterms_new_process := SUBSTR(p_incoterms_new_process    , LENGTH(v_incoterms_new		 ||  '^') || 1, LENGTH(p_incoterms_new_process    ));
			   p_plant_site_id_new_process := SUBSTR(p_plant_site_id_new_process, LENGTH(v_plant_site_id_new	 ||  '^') || 1, LENGTH(p_plant_site_id_new_process));
			   p_created_by_process := SUBSTR(p_created_by_process		, LENGTH(v_created_by			 ||  '^') || 1, LENGTH(p_created_by_process		));

			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  v_dom_exp_new			IS NULL OR v_dom_exp_new = '' THEN
			      v_dom_exp_new := v_dom_exp;
			   END IF;
			   IF  v_fcst_type_new			IS NULL OR v_fcst_type_new = '' THEN
			      v_fcst_type_new := v_fcst_type;
			   END IF;
			   IF  v_incoterms_new			IS NULL OR v_incoterms_new = '' THEN
			      v_incoterms_new := v_incoterms;
			   END IF;
			   IF  v_plant_site_id_new		IS NULL OR v_plant_site_id_new = '' THEN
			      v_plant_site_id_new := v_plant_site_id;
			   END IF;
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)

			   SELECT DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE_DMF0_RESULT_ROW(
			   			v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
					 ) BULK COLLECT INTO GT_DMF0_results
				FROM DUAL;
		  END;
		ELSE
		  BEGIN
			   v_DIVISION_ID := p_DIVISION_ID_process;
			   p_DIVISION_ID_process := NULL;

			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  v_dom_exp_new			IS NULL OR v_dom_exp_new = '' THEN
			      v_dom_exp_new := v_dom_exp;
			   END IF;

			   IF  v_fcst_type_new			IS NULL OR v_fcst_type_new = '' THEN
			      v_fcst_type_new := v_fcst_type;
			   END IF;

			   IF  v_incoterms_new			IS NULL OR v_incoterms_new = '' THEN
			      v_incoterms_new := v_incoterms;
			   END IF;

			   IF  v_plant_site_id_new		IS NULL OR v_plant_site_id_new = '' THEN
			      v_plant_site_id_new := v_plant_site_id;
			   END IF;
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)

			   SELECT DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE_DMF0_RESULT_ROW(
			   			v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
					 ) BULK COLLECT INTO GT_DMF0_results
				FROM DUAL;
	  		END;
		END IF;
		--###############################################   GT_DMF0_results 테이블에 split후 insert (END)
		END;
	END LOOP;

	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (start)
	BEGIN
		select count(1) INTO v_cnt_1
		from DM_PLN_MKT_FCST
        where 1=1
            and division_id   = v_division_id
            and project_code  = v_project_code;

		IF v_cnt_1 = 0 then
			v_log_type := 'INVALID';
			SELECT '[' ||  v_PROJECT_CODE  || ']' ||  ' Invalid Project Code !' INTO V_ERR_MESSAGE
			FROM dual;
			goto err_rtn;
		END if;
	END;

	-- 22년 데이터가 있고, 소형이고 , 마감이 되었다면 수정내역 취소
	SELECT COUNT(1) INTO v_cnt_1
	 FROM TABLE(GT_DMF0_results)
	WHERE V_DIVISION_ID = '40'
	  AND EXISTS (
			SELECT *
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = 'DM_LONG_PLAN'
			AND SEGMENT1 = '40'
			AND ATTRIBUTE1 = 'Y'	-- 마감여부
			AND VALID_YN = 'Y')
	 AND EXISTS (
			SELECT *
			FROM TABLE(GT_DMF0_results) A
			JOIN DM_PLN_MKT_FCST B ON	(
				A.V_DIVISION_ID		= B.DIVISION_ID
				AND A.V_PROJECT_CODE 	= B.PROJECT_CODE
				AND A.V_SCM_SITE_ID 	= B.SCM_SITE_ID
				AND A.V_ITEM_ID 		= B.ITEM_ID
				AND A.V_DOM_EXP 		= B.DOM_EXP
				AND A.V_FCST_TYPE 		= B.FCST_TYPE
				AND A.V_INCOTERMS 		= B.INCOTERMS
				AND A.V_PLANT_SITE_ID	= B.PLANT_SITE_ID
			)
			WHERE B.YYYYMMDD >= '20220101'
				AND B.MEASURE IN ( 'MKT_FCST', 'RTF', 'RTF_SYS_RP', 'VMI_IN_REQ' )
			);

	IF v_cnt_1 > 0 THEN
		begin
			v_log_type := 'INVALID';
			SELECT '2022년 데이터가 있는 마스터는 변경할 수 없습니다.' INTO v_err_message
			FROM dual;
			goto err_rtn;
		END;
	END IF;

	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (end)

		-- 속도개선 cursor 구조로 변경
		-- 신규변수
		BEGIN
			OPEN CURSOR1_MST FOR
			SELECT
			      V_DIVISION_ID,V_SCM_SITE_ID,V_PROJECT_CODE
			FROM TABLE(GT_DMF0_results)
			WHERE 1=1
			GROUP BY V_DIVISION_ID, V_SCM_SITE_ID,V_PROJECT_CODE;

			LOOP
			FETCH CURSOR1_MST INTO -- PROJECT_CODE별 LOOP수행
				m_DIVISION_ID ,m_SCM_SITE_ID ,m_PROJECT_CODE;

			EXIT WHEN CURSOR1_MST%NOTFOUND;
			END LOOP;
		END;

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE v_fetch_status = 0	LOOP
		-- -------------------------------------------------------------------------------------
        BEGIN


		----------------------------------------------------------------------------------------------- 20180601 pk값 validation (start)
		--BEGIN
			--			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (start)
			delete from DM_PLN_MKT_FCST
			where EXISTS(
					select v_division_id
						from TABLE(GT_DMF0_results) x
						where x.v_division_id     = DM_PLN_MKT_FCST.DIVISION_ID
						and x.v_project_code      = DM_PLN_MKT_FCST.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_MKT_FCST.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_MKT_FCST.ITEM_ID
						and x.v_dom_exp_new       = DM_PLN_MKT_FCST.DOM_EXP
						and x.v_fcst_type_new     = DM_PLN_MKT_FCST.FCST_TYPE
						and x.v_incoterms_new     = DM_PLN_MKT_FCST.incoterms
						and x.v_plant_site_id_new = DM_PLN_MKT_FCST.PLANT_SITE_ID
					)
				and qty = 0
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE;
			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (end)
			--		--END

			-- 20181108 (start)
			delete from SCM_MST_FUTURE_PRICE
			where EXISTS(
					select v_division_id
						from TABLE(GT_DMF0_results) x
						where x.v_division_id     = SCM_MST_FUTURE_PRICE.DIVISION_ID
						and x.v_project_code      = SCM_MST_FUTURE_PRICE.PROJECT_CODE
						and x.v_scm_site_id       = SCM_MST_FUTURE_PRICE.SCM_SITE_ID
						and x.v_item_id           = SCM_MST_FUTURE_PRICE.ITEM_ID
						and x.v_dom_exp_new       = SCM_MST_FUTURE_PRICE.DOM_EXP
						and x.v_fcst_type_new     = SCM_MST_FUTURE_PRICE.FCST_TYPE
						and x.v_incoterms_new     = SCM_MST_FUTURE_PRICE.incoterms
						and x.v_plant_site_id_new = SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
						--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 변경 후 Sales Price 삭제
						AND x.v_fcst_type not in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					)
				--and PRICE = 0 --[C20210504-000051] Sales Price 적용 기준 변경
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE;
			-- 20181108 (END)


			--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
			delete from DM_PLN_SALES_PLAN
			where EXISTS(
					select v_division_id
						from TABLE(GT_DMF0_results) x
						where x.v_division_id     = DM_PLN_SALES_PLAN.DIVISION_ID
						and x.v_project_code      = DM_PLN_SALES_PLAN.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_SALES_PLAN.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_SALES_PLAN.ITEM_ID
						and x.v_dom_exp           = DM_PLN_SALES_PLAN.DOM_EXP
						and x.v_fcst_type		  = DM_PLN_SALES_PLAN.FCST_TYPE
						and x.v_incoterms		  = DM_PLN_SALES_PLAN.incoterms
						and x.v_plant_site_id	  = DM_PLN_SALES_PLAN.PLANT_SITE_ID
						--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
						AND x.v_fcst_type_new in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					)
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE
				AND MEASURE in ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','MKT_AMT_KRW','MKT_AMT_LOC');



			-- 입력된 MASTER 정보로 MEASURE 추출 (start)
			SELECT DMF0003_GT_DMF0_VAILD_RESULT_ROW(
				AA.DIVISION_ID,
				AA.PROJECT_CODE,
				AA.SCM_SITE_ID,
				AA.ITEM_ID,
				AA.DOM_EXP,
				AA.FCST_TYPE,
				AA.INCOTERMS,
				AA.PLANT_SITE_ID,
				AA.MEASURE
			) BULK COLLECT INTO GT_DMF0_valid_results
			FROM (
				SELECT  a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   DM_PLN_MKT_FCST a
					  ,TABLE(GT_DMF0_results) rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp_new
					and a.fcst_type			= rslt.v_fcst_type_new
					and a.incoterms			= rslt.v_incoterms_new
					and a.plant_site_id		= rslt.v_plant_site_id_new
					and a.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  m_DIVISION_ID
					AND a.SCM_SITE_ID        =  m_SCM_SITE_ID
					AND a.PROJECT_CODE       =  m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
					AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
					AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				UNION
				SELECT   a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   DM_PLN_MKT_FCST a
					  ,TABLE(GT_DMF0_results) rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp
					and a.fcst_type			= rslt.v_fcst_type
					and a.incoterms			= rslt.v_incoterms
					and a.plant_site_id		= rslt.v_plant_site_id
					and a.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  m_DIVISION_ID
					AND a.SCM_SITE_ID        =  m_SCM_SITE_ID
					AND a.PROJECT_CODE       =  m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
					AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
					AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
			) AA;

			-- 입력된 MASTER 정보로 MEASURE 추출 (end)

			-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
			SELECT COUNT(1) INTO V_CNT_1
			from DM_PLN_MKT_FCST
			where (
					select count(1)
						from TABLE(GT_DMF0_valid_results) rslt
						where rslt.v_division_id    = DM_PLN_MKT_FCST.DIVISION_ID
						and rslt.v_project_code     = DM_PLN_MKT_FCST.PROJECT_CODE
						and rslt.v_scm_site_id      = DM_PLN_MKT_FCST.SCM_SITE_ID
						and rslt.v_item_id          = DM_PLN_MKT_FCST.ITEM_ID
						and rslt.v_dom_exp			= DM_PLN_MKT_FCST.DOM_EXP
						and rslt.v_fcst_type		= DM_PLN_MKT_FCST.FCST_TYPE
						and rslt.v_incoterms		= DM_PLN_MKT_FCST.incoterms
						and rslt.v_plant_site_id	= DM_PLN_MKT_FCST.PLANT_SITE_ID
						and rslt.v_measure			= DM_PLN_MKT_FCST.MEASURE
						and DM_PLN_MKT_FCST.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
						AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
						AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
						AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
						group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 1) > 1
				AND DIVISION_ID        =  m_DIVISION_ID
				AND SCM_SITE_ID        =  m_SCM_SITE_ID
				AND PROJECT_CODE       =  m_PROJECT_CODE;

			IF V_CNT_1 > 0 THEN
				v_log_type := 'INVALID';
				SELECT '이미 존재하는 Project,site,model 정보입니다.' INTO v_err_message
				FROM DUAL;
				goto err_rtn;
			END IF;

			----------------------------------------------------------------------------------------------- 20180601 pk값 validation (end)

				-- DM_PLN_MKT_FCST UPDATE
				BEGIN
						MERGE INTO DM_PLN_MKT_FCST A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
								  from TABLE(GT_DMF0_results) X
								  where 1=1
									AND v_DIVISION_ID        =  m_DIVISION_ID
									AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
									AND v_PROJECT_CODE       =  m_PROJECT_CODE
								  ) B
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  m_DIVISION_ID
								AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
								AND A.PROJECT_CODE       =  m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= SYSDATE;
				END;

				-- DM_PLN_SALES_PLAN UPDATE
				BEGIN
						MERGE INTO DM_PLN_SALES_PLAN A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
								  from TABLE(GT_DMF0_results) X
									  where 1=1
										AND v_DIVISION_ID        =  m_DIVISION_ID
										AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
										AND v_PROJECT_CODE       =  m_PROJECT_CODE
							  ) B
						ON(
								A.division_id     = B.v_division_id
							AND A.project_code    = B.v_project_code
							AND A.scm_site_id     = B.v_scm_site_id
							AND A.item_id         = B.v_item_id
							AND A.dom_exp         = B.v_dom_exp
							AND A.fcst_type       = B.v_fcst_type
							AND A.incoterms       = B.v_incoterms
							AND A.plant_site_id   = B.v_plant_site_id
							and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
							AND A.DIVISION_ID        =  m_DIVISION_ID
							AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
							AND A.PROJECT_CODE       =  m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= SYSDATE;

						--[C20210504-000051] 변경 전 fcst type이 무상인 경우에 SalesAMT 생성
						INSERT INTO DM_PLN_SALES_PLAN
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0), 'FM9999999999999.00000' ) as NUMBER(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
								,'-'
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.MEASURE = 'KRW'
							   )
							JOIN SCM_SYS_CALENDAR_M CM
							ON (
								CM.basis_yyyymmdd = w.yyyymmdd
								AND FP.YYYYMMDD = CM.basis_start_date
							)
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from TABLE(GT_DMF0_results) a  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , 'FM9999999999999.00000' ) as NUMBER(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
								,'-'
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.MEASURE = 'LOC'
							   )
							JOIN SCM_SYS_CALENDAR_M CM
							ON (
								CM.basis_yyyymmdd = w.yyyymmdd
								AND FP.YYYYMMDD = CM.basis_start_date
							)
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from TABLE(GT_DMF0_results)  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- USD 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_USD' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0), 'FM9999999999999.00000' ) as number(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
								,'-'
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.MEASURE = 'USD'
							   )
							JOIN SCM_SYS_CALENDAR_M CM
							ON (
								CM.basis_yyyymmdd = w.yyyymmdd
								AND FP.YYYYMMDD = CM.basis_start_date
							)
							where w.measure = 'RTF_SYS_RP'
						   and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
						   AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from TABLE(GT_DMF0_results) X where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , 'FM9999999999999.00000' ) as NUMBER(30, 10))
								,v_created_by						--[2018-03-15]수정
								,SYSDATE							--[2018-03-15]수정
								,'SYSTEM'						--[2018-03-15]수정
								,SYSDATE							--[2018-03-15]수정
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
								,'-'
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.MEASURE = 'KRW'
							   )
							JOIN SCM_SYS_CALENDAR_M CM
							ON (
								CM.basis_yyyymmdd = w.yyyymmdd
								AND FP.YYYYMMDD = CM.basis_start_date
							)
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	-- [C20210629-000239]
							and w.division_id = v_division_id
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
							and exists (select v_division_id
											from TABLE(GT_DMF0_results)  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.item_id			= v_item_id
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0), 'FM9999999999999.00000') as NUMBER(30, 10))
								,v_created_by							--[2018-03-15]수정
								,SYSDATE								--[2018-03-15]수정
								,'SYSTEM'    							--[2018-03-15]수정
								,SYSDATE								--[2018-03-15]수정
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
								,'-'
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.MEASURE = 'LOC'
							   )
							JOIN SCM_SYS_CALENDAR_M CM
							ON (
								CM.basis_yyyymmdd = w.yyyymmdd
								AND FP.YYYYMMDD = CM.basis_start_date
							)
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	[C20210629-000239]
							and w.division_id = v_division_id
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
							and exists (select v_division_id
											from TABLE(GT_DMF0_results) X  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												);



				END;

				-- SCM_MST_FUTURE_PRICE UPDATE
				BEGIN
					----------------------------------------------------------------------------------------------- 20181108 pk값 validation (START)
					-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)

					s_FUTURE_valid := NULL;

					SELECT '[PROJECT_CODE : ' || PROJECT_CODE || ']' || CHR(10) || '[SCM_SITE_ID : ' || SCM_SITE_ID || ']' || CHR(10) || '[ITEM_ID : ' || ITEM_ID || ']' || CHR(10) || '[DOM_EXP : ' || DOM_EXP || ']'
					 || CHR(10) || '[FCST_TYPE : ' || FCST_TYPE || ']' || CHR(10) || '[INCOTERMS : ' || INCOTERMS || ']' || CHR(10) || '[PLANT_SITE_ID : ' || PLANT_SITE_ID || ']' INTO s_FUTURE_valid
					 from SCM_MST_FUTURE_PRICE
					where exists (
						select v_project_code, v_scm_site_id, v_item_id, v_dom_exp, v_fcst_type, v_incoterms, v_plant_site_id
						--DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,incoterms,PLANT_SITE_ID
							from TABLE(GT_DMF0_results) rslt
							where rslt.v_division_id		= SCM_MST_FUTURE_PRICE.DIVISION_ID
							and rslt.v_project_code			= SCM_MST_FUTURE_PRICE.PROJECT_CODE
							and rslt.v_scm_site_id			= SCM_MST_FUTURE_PRICE.SCM_SITE_ID
							and rslt.v_item_id				= SCM_MST_FUTURE_PRICE.ITEM_ID
							and rslt.v_dom_exp_new			= SCM_MST_FUTURE_PRICE.DOM_EXP
							and rslt.v_fcst_type_new		= SCM_MST_FUTURE_PRICE.FCST_TYPE
							and rslt.v_incoterms_new		= SCM_MST_FUTURE_PRICE.incoterms
							and rslt.v_plant_site_id_new	= SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
							and SCM_MST_FUTURE_PRICE.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
							AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
							AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
							AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
							--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 중복 Check
							AND rslt.v_fcst_type not in (
								SELECT SEGMENT2
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
								WHERE 1=1
								AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
								AND MST.SEGMENT1    = 'FCST_TYPE'
								AND VALID_YN        = 'Y'
							)
							group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 0
							FETCH FIRST 1 ROWS ONLY
						)
						AND DIVISION_ID        =  m_DIVISION_ID
						AND SCM_SITE_ID        =  m_SCM_SITE_ID
						AND PROJECT_CODE       =  m_PROJECT_CODE;

					if s_FUTURE_valid IS NOT NULL THEN
						BEGIN
							v_log_type := 'INVALID';
							SELECT 'Sales Price 중복이 발생하였습니다.' || CHR(10) || s_FUTURE_valid INTO v_err_message
							FROM DUAL;
							goto err_rtn;
						END;
					END IF;
					----------------------------------------------------------------------------------------------- 20181108 pk값 validation (end)
					--[C20210504-000051] Sales Price 적용 기준 변경(변경된 Key 값으로 Update -> 변경된 Key 값으로 Insert, 무상은 제외)
					INSERT INTO SCM_MST_FUTURE_PRICE
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, v_plant_site_id_new, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
					     , v_dom_exp_new, v_fcst_type_new, v_incoterms_new, A.PRICE, A.CREATED_BY, A.CREATION_DATE, v_created_by, SYSDATE
						 , A.ATTRIBUTE1 , A.ATTRIBUTE2 , A.ATTRIBUTE3 , A.ATTRIBUTE4 , A.ATTRIBUTE5 , A.ATTRIBUTE6 , A.ATTRIBUTE7 , A.ATTRIBUTE8 , A.ATTRIBUTE9 , A.ATTRIBUTE10
					FROM   SCM_MST_FUTURE_PRICE A
					INNER JOIN (
						SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
						  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
						from TABLE(GT_DMF0_results) X
						where 1=1
						AND v_DIVISION_ID        =  m_DIVISION_ID
						AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
						AND v_PROJECT_CODE       =  m_PROJECT_CODE
						AND v_fcst_type_new not in (
							SELECT SEGMENT2
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
							WHERE 1=1
							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
							AND MST.SEGMENT1    = 'FCST_TYPE'
							AND VALID_YN        = 'Y'
						)  -- 무상은 제외
					) B
					ON(
								A.division_id     = B.v_division_id
							AND A.project_code    = B.v_project_code
							AND A.scm_site_id     = B.v_scm_site_id
							AND A.item_id         = B.v_item_id
							AND A.dom_exp         = B.v_dom_exp
							AND A.fcst_type       = B.v_fcst_type
							AND A.incoterms       = B.v_incoterms
							AND A.plant_site_id   = B.v_plant_site_id
							and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
							AND A.DIVISION_ID     =  m_DIVISION_ID
							AND A.SCM_SITE_ID     =  m_SCM_SITE_ID
							AND A.PROJECT_CODE    =  m_PROJECT_CODE
					  );


					--[C20210504-000051] 무상->유상으로 변경된 경우에 유상 Sales Price가 없으면 알림
					/* s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨) */

					s_unit_price_valid := null;
					SELECT
						CASE
							WHEN a.v_division_id = '40' THEN
								'End Customer________ : ' ||  NVL(v_project_code , NULL)
							ELSE
								'Project_________ : ' ||  NVL(v_project_code, NULL)
						END
						 || CHR(10)  ||  'Sales site_____________ : ' ||  NVL(v_scm_site_id , NULL)
						 || CHR(10)  ||  'Model________________ : ' ||  NVL(v_item_id , NULL)
						 || CHR(10)  ||  'Customs Handbook__ : ' ||  NVL(v_dom_exp_new , NULL)
						 || CHR(10)  ||  'Fcst Type_____________ : ' ||
						NVL(
								(
									SELECT SEGMENT2
									  FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
									 WHERE 1=1
									   AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
									   AND MST.SEGMENT1    = A.v_fcst_type_new
								), NULL
						)
						|| CHR(10)  ||  'Incoterms____________ : ' ||  NVL(v_incoterms_new , NULL)
					 	|| CHR(10)  ||  'Plant Site___________ : ' ||  NVL(v_plant_site_id_new , NULL)
					 	|| CHR(10)  ||  'YYYYMMDD_________ : ' ||  NVL( MIN(M.BASIS_START_DATE), NULL)   ||  ' ~ '  ||  NVL(MAX(M.BASIS_START_DATE), NULL)
						|| CHR(10)  || CHR(10) INTO s_unit_price_valid
					FROM TABLE(GT_DMF0_results) A
					inner join scm_mst_site_item z
					on  a.v_division_id		 = z.DIVISION_ID
					and a.v_project_code	 = z.PROJECT_CODE
					and a.v_scm_site_id		 = z.SCM_SITE_ID
					and a.v_item_id			 = z.ITEM_ID
					and z.VALID_YN			 = 'Y'
					AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN IS NULL OR z.SALES_PLAN_ADJUST_YN IS NULL )
					LEFT JOIN (
						SELECT BASIS_START_DATE
						  FROM SCM_SYS_CALENDAR_M M
						WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')  --당주 월요일부터
						  AND TO_CHAR(/* TODO:DATEADD(WW,52,TO_CHAR(DATEADD(DD, -7, FN_NEXT_DAY(SYSDATE, 'MON')), 'YYYYMMDD')) */FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')  -- 52주후 월요일까지;
						GROUP BY BASIS_START_DATE
					) M
					ON 1=1
					LEFT JOIN SCM_MST_FUTURE_PRICE P
					ON (
						a.v_division_id		= p.division_id
						AND a.v_project_code	= p.project_code
						AND a.v_scm_site_id		= p.scm_site_id
						AND a.v_item_id			= p.item_id
						AND a.v_dom_exp_new		= p.dom_exp
						AND a.v_fcst_type_new	= p.fcst_type
						AND a.v_incoterms_new	= p.INCOTERMS
						AND a.v_plant_site_id_new = CASE
							WHEN a.v_division_id = '81' THEN p.plant_site_id
							ELSE a.v_plant_site_id
						END
						AND p.yyyymmdd			= M.basis_start_date
						AND p.price > 0
					)
					WHERE 1=1
					  AND p.yyyymmdd IS NULL  -- PRICE값이 없는경우
					  AND a.v_fcst_type_new not in (
						  	SELECT SEGMENT2
						  	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
							WHERE 1=1
							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
							AND MST.SEGMENT1     = 'FCST_TYPE'
							AND VALID_YN        = 'Y'
						)
					  AND a.v_fcst_type in (
						SELECT SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
						WHERE 1=1
						AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
						AND MST.SEGMENT1     = 'FCST_TYPE'
						AND VALID_YN        = 'Y'
					)
					GROUP BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD
					ORDER BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD;

					IF s_unit_price_valid IS NOT NULL THEN
						v_log_type := 'INVALID';
						v_description := s_unit_price_valid  ||  'Unit Price Not Found !' || CHR(10)  ||  '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)  ||  '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
						GOTO ERR_RTN;
					END IF;

					/*
					MERGE INTO SCM_MST_FUTURE_PRICE A;
					USING (
							SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
								  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
								  from GT_DMF0_results
									  where 1=1
										AND v_DIVISION_ID        =  m_DIVISION_ID
										AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
										AND v_PROJECT_CODE       =  m_PROJECT_CODE
						  ) B;
					ON(
								A.division_id     = B.v_division_id
							AND A.project_code    = B.v_project_code
							AND A.scm_site_id     = B.v_scm_site_id
							AND A.item_id         = B.v_item_id
							AND A.dom_exp         = B.v_dom_exp
							AND A.fcst_type       = B.v_fcst_type
							AND A.incoterms       = B.v_incoterms
							AND A.plant_site_id   = B.v_plant_site_id
							and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
							AND A.DIVISION_ID        =  m_DIVISION_ID
							AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
							AND A.PROJECT_CODE       =  m_PROJECT_CODE
					  )
					WHEN MATCHED THEN
						 UPDATE  SET  dom_exp			= v_dom_exp_new
									 ,fcst_type			= v_fcst_type_new
									 ,incoterms			= v_incoterms_new
									 ,plant_site_id		= v_plant_site_id_new
									,last_updated_by	= v_created_by
									,last_update_date	= SYSDATE
						 ;*/
				END;

				--===================================================================================== HISTORY INSERT INTO start
				BEGIN
					INSERT INTO DM_PLN_MKT_FCST_PK_DATA_UPDATE_H
						SELECT
								 v_division_id
								,SEQ1_DM_PLN_MKT_FCST_PK_DATA_UPDATE_H.NEXTVAL
								,v_project_code
								,v_scm_site_id
								,v_item_id
								,v_dom_exp
								,v_fcst_type
								,v_incoterms
								,v_plant_site_id
								,v_dom_exp_new
								,v_fcst_type_new
								,v_incoterms_new
								,v_plant_site_id_new
								,v_created_by
								,SYSDATE
								,v_created_by
								,SYSDATE
								,null,null,null,null,null,null,null,null,null,null
						FROM TABLE(GT_DMF0_results) X
							where 1=1
							AND v_DIVISION_ID        =  m_DIVISION_ID
							AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
							AND v_PROJECT_CODE       =  m_PROJECT_CODE;
				END;

				--===================================================================================== HISTORY INSERT INTO end

			--
			FETCH CURSOR1_MST INTO m_DIVISION_ID, m_SCM_SITE_ID, m_PROJECT_CODE;

			-- -------------------------------------------------------------------------------------
			END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END
		END LOOP;

		CLOSE CURSOR1_MST;

  	-- 트랜잭션 (COMMIT)

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
<<err_rtn>>
	IF v_log_type = 'INVALID' THEN
		begin
			v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		END;
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
	END IF;

	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
	-- 트랜잭션 (END)
		--
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
	  v_sql_code := TO_CHAR(SQLCODE);
      v_log_message := SQLERRM;
      v_description := 'ERROR_LINE : ';
      d_event_date := SYSTIMESTAMP;
	  --[C20200909-000203] LOG 표준화 적용
	  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	  SELECT '['  ||  v_sql_code  ||  ']'  ||  v_log_message INTO v_err_message  /*-- 에러메시지 DISPLAY --*/
	  FROM DUAL;

	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
    --  IF v_log_message IS NULL
	--  SELECT 'success'

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 트랜잭션 (END)
END;
/
