CREATE OR REPLACE PROCEDURE           "DMF0003_MKT_FCST_SALES_PLAN_SYNC"
(

	-- Add the parameters for the stored procedure here
	p_division_id				VARCHAR2		,
	p_CREATED_BY               VARCHAR2

/*
 * Program ID   : DMF0003_MKT_FCST_SALES_PLAN_SYNC
 * Description  : MKT_FCST & SALES_PLAN DATA SYNC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20230607   chano0612 고희선님 요청으로 MKT_FCST 와 SALES_PLAN 데이터 SYNC
 * 20260520		byunmj0223		mssql -> oracle 버전으로 수정
  */
)
AS
	GT_DMF0_PRICE	DMF0003_GT_DMF0_PRICE_TAB;
	GT_DMF0_MKT_FCST	DMF0003_GT_DMF0_MKT_FCST_TAB;
	GT_DMF0_SALES_PLAN_TEMP_LOC		DMF0003_GT_DMF0_MKT_FCST_TAB_2;
	v_recv_division_id VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_division_id VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_MKT_FCST_SALES_PLAN_SYNC';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_err_concat_message VARCHAR2(1000 CHAR);
BEGIN
            	-- CUTOFF 변수 설정

	-- 스플릿관련 변수

	v_recv_division_id := NULL;
	v_recv_division_id := p_division_id;

	v_delimiter := '^'; -- 데이터 구분자




	--            있는경우[매개변수로 처리]
	--			  없는경우[ROLLING 에서 처리하므로 'CUTOFF'로 처리]
	IF NVL(p_CREATED_BY, NULL) IS NULL THEN
		v_created_by := 'CUTOFF';
	ELSE
		v_created_by := p_CREATED_BY;

	-- LOG 용 변수 설정
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := 'p_division_id : '  ||  p_division_id  ||  ' / '  || 'v_created_by : '  ||   NVL(v_created_by, 'NULL');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL;      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN
	-- -----------------------------------------------------------------------------------------
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
		-- SELECT v_max_loop_cnt  as 'v_max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
		-- SELECT TO_CHAR(v_max_loop_cnt)  as 'v_max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
		DBMS_OUTPUT.PUT_LINE('A--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        /*---------------------------------------------------------------*/
		WHILE (LENGTH(v_recv_division_id) > 0 AND v_mst_loop_cnt < v_max_loop_cnt) LOOP
		BEGIN
			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				-- Loop Count +1씩 증가시킴
				v_mst_loop_cnt := v_mst_loop_cnt || 1;
				v_division_id := SCM_ARR_SPL_VAL (p_division_id  ,  v_delimiter , v_mst_loop_cnt) ;
			END;

          /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       v_mst_loop_cnt <= v_max_loop_cnt THEN
				-- 기존 정보 삭제
				delete dm_pln_sales_plan
				-- where yyyymmdd >= TO_CHAR(7 + (/* TODO:DATEDIFF(week,0,dateadd( dd, -1*7,  SYSDATE) */ ))*7SYSDATE + (-1*7) ), 7), 'YYYYMMDD')
				 where yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
				   and division_id = v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from scm_mst_item_sn  group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a
								  ,dm_pln_sales_plan b
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       );
DBMS_OUTPUT.PUT_LINE('B--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dm_pln_sales_plan
				 where yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
				   and division_id = v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from scm_mst_item_sn  group by item_id )
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF','RTF_SYS_RP','TMM_FCST' ); -- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
DBMS_OUTPUT.PUT_LINE('C--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				-- 2021.08.25
				/* TODO:GTT:GT_DMF0_PRICE-->GT_DMF0_PRICE */
				SELECT DMF0003_GT_DMF0_PRICE_ROW(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE)
						BULK COLLECT INTO GT_DMF0_PRICE
				FROM SCM_MST_FUTURE_PRICE A
				WHERE DIVISION_ID = v_division_id
					AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' );
DBMS_OUTPUT.PUT_LINE('D--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				/* TODO:GTT:GT_DMF0_MKT_FCST-->GT_DMF0_MKT_FCST */
				SELECT DMF0003_GT_DMF0_MKT_FCST_ROW(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE)
					   BULK COLLECT INTO GT_DMF0_MKT_FCST
				FROM DM_PLN_MKT_FCST A
				WHERE A.DIVISION_ID = v_division_id
					-- and w.yyyymmdd >= TO_CHAR(7 + (/* TODO:DATEDIFF(week,0,dateadd( dd, -1*7,  SYSDATE) */ ))*7SYSDATE + (-1*7) ), 7), 'YYYYMMDD')
					and A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
					and A.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')
					and A.ITEM_ID in ( select item_id  from scm_mst_item_sn  group by item_id);
				DBMS_OUTPUT.PUT_LINE('E--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
								--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가

				--SELECT * FROM GT_DMF0_PRICE
				DBMS_OUTPUT.PUT_LINE('F--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
								--PRINT 'EXEC_001                                       =>  ' + TO_CHAR(SYSDATE)

				-- 신규 정보 추가

				-- Temp 테이블에 저장
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				SELECT	DMF0003_GT_DMF0_MKT_FCST_ROW_2(
					DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
					MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
				) BULK COLLECT INTO GT_DMF0_SALES_PLAN_TEMP_LOC
				FROM (
					select   DISTINCT
					         w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							,w.MEASURE
							,w.PLANT_SITE_ID
							,w.YYYYMMDD
							,si.CURRENCY
							,w.QTY
							,w.CREATED_BY
							,w.CREATION_DATE
						from TABLE(GT_DMF0_MKT_FCST) w
						left outer join TABLE(GT_DMF0_PRICE) si
						on (
							w.DIVISION_ID   = si.DIVISION_ID
							and w.PROJECT_CODE  = si.PROJECT_CODE
							and w.SCM_SITE_ID   = si.SCM_SITE_ID
							and w.ITEM_ID       = si.ITEM_ID
							and w.DOM_EXP       = si.dom_exp
							and w.fcst_type     = si.fcst_type
							and w.INCOTERMS     = si.INCOTERMS
							and w.plant_site_id = si.plant_site_id
							-- and w.yyyymmdd      = si.yyyymmdd
							-- and ( select basis_start_date from SCM_SYS_CALENDAR_M  where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
						)
						JOIN SCM_SYS_CALENDAR_M sscm
						ON (
							sscm.basis_yyyymmdd = w.yyyymmdd
							AND si.yyyymmdd = sscm.basis_yyyymmdd
						)
						where w.measure in ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD

					UNION ALL
					-- KRW 값을 계산
					select   w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							, CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
									WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
									WHEN FP.MEASURE = 'USD' THEN  'SalesAmt_USD'
									ELSE FP.MEASURE
									END AS MEASURE
							,w.PLANT_SITE_ID
							,w.YYYYMMDD
							,fp.CURRENCY
							, CASE WHEN FP.MEASURE = 'KRW' THEN cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , '999999999999999.00000' ) as NUMBER(30, 10))
									WHEN FP.MEASURE = 'LOC' THEN cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , '999999999999999.00000' ) as NUMBER(30, 10))
									WHEN FP.MEASURE = 'USD' THEN cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , '999999999999999.00000' ) as NUMBER(30, 10))
									end as qty
							, NULL, NULL
						from TABLE(GT_DMF0_MKT_FCST) w
						join TABLE(GT_DMF0_PRICE) FP
						on (    FP.DIVISION_ID   = w.DIVISION_ID
							AND FP.PROJECT_CODE  = w.PROJECT_CODE
							AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
							AND FP.ITEM_ID       = w.ITEM_ID
							AND FP.DOM_EXP       = w.DOM_EXP
							AND FP.FCST_TYPE     = w.FCST_TYPE
							AND FP.INCOTERMS     = w.INCOTERMS
							and FP.plant_site_id = w.plant_site_id
							--AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
							--AND FP.MEASURE = 'KRW'
						   )
						JOIN SCM_SYS_CALENDAR_M sscm
						ON (
							sscm.basis_yyyymmdd = w.yyyymmdd
							AND FP.yyyymmdd = sscm.basis_yyyymmdd
						)
						where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
					   and NOT EXISTS (
								select A.DIVISION_ID
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
					       )


					-- ---------------------------------------------------------------------------------------------------------------------
					-- 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
					-- ---------------------------------------------------------------------------------------------------------------------
					UNION ALL
					-- KRW 값을 계산
					select   w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							, CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
									WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
									END AS MEASURE
							,w.PLANT_SITE_ID
							,w.YYYYMMDD
							,fp.CURRENCY
							--,cast( STR( w.QTY * NVL(FP.PRICE , 1) , 20, 5 ) as numeric)
							, CASE WHEN FP.MEASURE = 'KRW' THEN cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , '999999999999999.00000' ) as NUMBER(30, 10))
									WHEN FP.MEASURE = 'LOC' THEN cast( TO_CHAR( w.QTY * NVL(FP.PRICE , 0) , '999999999999999.00000') as NUMBER(30, 10))
									END AS QTY
							, NULL, NULL
						from TABLE(GT_DMF0_MKT_FCST) w
						join TABLE(GT_DMF0_PRICE) FP
						on (    FP.DIVISION_ID   = w.DIVISION_ID
							AND FP.PROJECT_CODE  = w.PROJECT_CODE
							AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
							AND FP.ITEM_ID       = w.ITEM_ID
							AND FP.DOM_EXP       = w.DOM_EXP
							AND FP.FCST_TYPE     = w.FCST_TYPE
							AND FP.INCOTERMS     = w.INCOTERMS
							and FP.plant_site_id = w.plant_site_id
							--AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
							AND FP.MEASURE IN ( 'KRW' , 'LOC' )
						   )
						JOIN SCM_SYS_CALENDAR_M sscm
						ON (
							sscm.basis_yyyymmdd = w.yyyymmdd
							AND FP.yyyymmdd = sscm.basis_yyyymmdd
						)
						where w.measure = 'MKT_FCST'
				);

					DBMS_OUTPUT.PUT_LINE('G--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				-- 확인용
				-- select * from GT_DMF0_SALES_PLAN_TEMP_LOC;
				-- 테이블의 중복제거
				   BEGIN
					   DELETE
					   FROM dm_pln_sales_plan
					   WHERE exists(
								SELECT B.DIVISION_ID
								  FROM TABLE(GT_DMF0_SALES_PLAN_TEMP_LOC) B
								 where 1=1
								   and dm_pln_sales_plan.DIVISION_ID    =  B.DIVISION_ID
								   and dm_pln_sales_plan.PROJECT_CODE   =  B.PROJECT_CODE
								   and dm_pln_sales_plan.SCM_SITE_ID    =  B.SCM_SITE_ID
								   and dm_pln_sales_plan.ITEM_ID        =  B.ITEM_ID
								   and dm_pln_sales_plan.DOM_EXP        =  B.DOM_EXP
								   and dm_pln_sales_plan.FCST_TYPE      =  B.FCST_TYPE
								   and dm_pln_sales_plan.INCOTERMS      =  B.INCOTERMS
								   and dm_pln_sales_plan.MEASURE        =  B.MEASURE
								   and dm_pln_sales_plan.PLANT_SITE_ID  =  B.PLANT_SITE_ID
								   and dm_pln_sales_plan.YYYYMMDD       =  B.YYYYMMDD
							  );
				   END;
				DBMS_OUTPUT.PUT_LINE('H--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT  INTO  dm_pln_sales_plan
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
				SELECT distinct
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,NVL(CREATED_BY, v_created_by) , NVL(CREATION_DATE, SYSDATE)
					  ,v_created_by, SYSTIMESTAMP as LAST_UPDATE_DATE
					  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
				FROM TABLE(GT_DMF0_SALES_PLAN_TEMP_LOC);
				DBMS_OUTPUT.PUT_LINE('I--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		    END IF;
          /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

			END;
		END LOOP;
		END;
	END IF;
    /*---------------------------------------------------------------*/

     -- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
    COMMIT;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
  	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
   --  IF v_log_message IS NULL
	  --SELECT 'success'
  	-- 종료 LOG
    IF v_log_message IS NULL THEN
		BEGIN
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'p_division_id : '  ||  p_division_id  ||  ' / '  || 'v_created_by : '  ||   NVL(v_created_by, 'NULL');
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

      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := SQLERRM;
      v_description := 'ERROR_LINE : ' || TO_CHAR(NULL);
      v_err_concat_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  v_log_message;
      d_event_date := SYSTIMESTAMP;

	  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	-- -----------------------------------------------------------
  END;
/
