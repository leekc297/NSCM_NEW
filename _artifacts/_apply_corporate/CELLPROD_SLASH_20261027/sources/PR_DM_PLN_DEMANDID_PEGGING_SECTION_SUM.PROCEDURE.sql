PROCEDURE           "PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM" 
(
   p_division_id				VARCHAR2
)
/*
 * Program ID   : PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM
 * Description  : Demand ID 생성으로 FCST 변경이력추적 및 원인을 파악하기 위해서
 * Program History
 *===================================================================================================
 *   Date           In Charge      Description
 *===================================================================================================
 * 2018. 04. 19     JHBAEK			불변구간(고객인도 ~ 출하 4주전), 확정구간(출하5주전 ~ 출하10주전) FCST 구하기
 * 2025. 02. 05		KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025. 05. 07		KANG.H.J		[PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
 * 2025. 05. 14		KANG.H.J		[PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의

	PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM('81');
	PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM('82');

 */
AS

    v_division_id VARCHAR2(60 CHAR);
    v_VERSION_NO VARCHAR2(50 CHAR);
    v_project_code VARCHAR2(100 CHAR);
    v_scm_site_id VARCHAR2(60 CHAR);
    v_item_id VARCHAR2(100 CHAR);
    v_dom_exp VARCHAR2(6 CHAR);
    v_fcst_type VARCHAR2(40 CHAR);
    v_incoterms VARCHAR2(20 CHAR);
    v_measure VARCHAR2(100 CHAR);
    v_plant_site_id VARCHAR2(60 CHAR);
    v_section1_01 NUMBER(20, 10);
    v_section1_02 NUMBER(20, 10);
    v_section1_03 NUMBER(20, 10);
    v_section1_04 NUMBER(20, 10);
    v_section1_05 NUMBER(20, 10);
    v_section1_06_01 NUMBER(20, 10);
    v_section1_06_02 NUMBER(20, 10);
    v_section1_07_01 NUMBER(20, 10);
    v_section1_07_02 NUMBER(20, 10);
    v_section2_01 NUMBER(20, 10);
    v_section2_02 NUMBER(20, 10);
    v_section2_03 NUMBER(20, 10);
    v_section2_04 NUMBER(20, 10);
    v_section2_05 NUMBER(20, 10);
    v_section2_06_01 NUMBER(20, 10);
    v_section2_06_02 NUMBER(20, 10);
    v_section2_07_01 NUMBER(20, 10);
    v_section2_07_02 NUMBER(20, 10);
    v_section3_01 NUMBER(20, 10);
    v_section3_02 NUMBER(20, 10);
    v_section3_03 NUMBER(20, 10);
    v_section3_04 NUMBER(20, 10);
    v_section3_05 NUMBER(20, 10);
    v_section3_06_01 NUMBER(20, 10);
    v_section3_06_02 NUMBER(20, 10);
    v_section3_07_01 NUMBER(20, 10);
    v_section3_07_02 NUMBER(20, 10);
    v_cutoff_version_type VARCHAR2(10 CHAR);
    v_measure_fcst_type VARCHAR2(10 CHAR);
    v_batch_user VARCHAR2(150 CHAR) := 'scm_batch';
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_ifseqno VARCHAR2(30 CHAR);
    n_history_seq NUMBER;
    v_cell_prod_site_id		VARCHAR2(60 CHAR);				-- [PJ2025-50017] 추가
    v_bf_week					VARCHAR2(08 CHAR);				-- 전주차정보
    v_work_week				VARCHAR2(08 CHAR);				-- 작업주차정보
    v_in_para_data VARCHAR2(4000 CHAR);
    v_step           VARCHAR2(4000 CHAR) := NULL;
    v_fetch_status INTEGER;
    CURSOR PEGGING_OUT_CUR IS
											SELECT   DISTINCT					-- 계산의 대상이 되는 주차. 전주테이블에서 기준이 되는 정보를 가지고 온다. MAX(VERSION_NO)
													 A.DIVISION_ID
													,A.VERSION_NO
													,A.PROJECT_CODE
													,A.SCM_SITE_ID
													,A.ITEM_ID
													,A.DOM_EXP
													,A.FCST_TYPE
													,A.INCOTERMS
													,A.MEASURE
													,A.PLANT_SITE_ID
													,A.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
											FROM GT_DPDPS_PEGGING_TBL A
											WHERE   1 = 1;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    v_in_para_data := JSON_OBJECT(
        'p_division_id' VALUE p_division_id
    );

	-- CURSOR RETURN VALUE

	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) Start
	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) End
	-- 임시 테이블 생성
		--[C20200909-000203] LOG 표준화 적용
		-- LOG 용 변수 설정
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPDPS_PEGGING_TBL';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPDPS_RESULT_TBL';

	-- 주차정보 설정
	SELECT	ISO_YYYYWW
  INTO v_bf_week
		FROM  SCM_SYS_CALENDAR_M
		WHERE	BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-2)*7, 'YYYYMMDD');

	SELECT	ISO_YYYYWW INTO v_work_week
		FROM  SCM_SYS_CALENDAR_M
		WHERE	BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD');

	-- DIVISION 설정
	v_division_id := p_division_id;

/*		-- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. Start
	-- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 Start
	IF (p_division_id = '40')
	BEGIN

		SELECT v_cutoff_version_type	= SEGMENT2
			 , v_measure_fcst_type		= ATTRIBUTE1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE	= 'DM_NET_DEMAND_CUTOFF_TYPE'
		AND   SEGMENT1		= p_division_id

	END
	-- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 End
*/		-- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. End
		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 Start
		BEGIN
			-- [PJ2025-50188] 전주 기준의 VERSION_NO / CUTOFF_TYPE / MEASURE 정의
			SELECT A.VERSION_TYPE		-- [PJ2025-50188] ㅡMF_W / SF_W
				 , CASE WHEN A.VERSION_TYPE = 'MF_W' THEN 'MKT_FCST'
												   WHEN A.VERSION_TYPE = 'SF_W' THEN 'SCM_FCST'
											  ELSE NULL END
			INTO v_cutoff_version_type, v_measure_fcst_type
			FROM
			(
--				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY CREATION_DATE DESC, YYYYMMDD DESC, VER_CRE_SEQ DESC) RN	-- [PJ2025-50188] 가장 최근의 버젼
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) RN	-- [PJ2025-50188] 가장 최근의 버젼. SF_W가 MF_W보다 우선함.
				FROM DM_MST_VERSION
				WHERE DIVISION_ID = p_division_id
				AND   VERSION_TYPE IN ('MF_W', 'SF_W')
			) A
			WHERE RN = 1
			FETCH FIRST 1 ROWS ONLY;

		END;
		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 End
	INSERT /*+ NO_PARALLEL */ INTO GT_DPDPS_PEGGING_TBL
	 	SELECT	DISTINCT
				 A.DIVISION_ID
				,A.VERSION_NO
				,A.PROJECT_CODE
				,A.SCM_SITE_ID
				,A.ITEM_ID
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,A.MEASURE
				,A.PLANT_SITE_ID
				,A.CELL_PROD_SITE_ID								-- [PJ2025-50017] 추가
		FROM	DM_PLN_DEMANDID_PEGGING A
		WHERE	1 = 1
		--AND		A.MEASURE		= 'MKT_FCST'
		AND		A.MEASURE		= v_measure_fcst_type				-- [PJ2025-50188] (MKT_FCST / SCM_FCST)
		AND		A.CREATION_WEEK	= v_work_week
		AND		A.DIVISION_ID     LIKE '%'  ||  p_division_id  ||  '%';
			--AND  A.DIVISION_ID     LIKE '%' || '81' || '%'
		-- 커서 사용
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- PEGGING_OUT_CUR CURSOR FAST_FORWARD FOR
											--SELECT   DISTINCT					-- 계산의 대상이 되는 주차. 전주테이블에서 기준이 되는 정보를 가지고 온다. MAX(VERSION_NO)
											--		 A.DIVISION_ID
											--		,A.VERSION_NO
											--		,A.PROJECT_CODE
											--		,A.SCM_SITE_ID
											--		,A.ITEM_ID
											--		,A.DOM_EXP
											--		,A.FCST_TYPE
											--		,A.INCOTERMS
											--		,A.MEASURE
											--		,A.PLANT_SITE_ID
											--		,A.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
											--FROM GT_DPDPS_PEGGING_TBL A
											--WHERE   1 = 1;

				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'D17PS0001'
				--AND  SCM_SITE_ID = 'ESS_KR_OCH'
				--AND  ITEM_ID = 'ECP0640N5-04'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'MPS'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'A040-A'
				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15AI4002'
				--AND  SCM_SITE_ID = 'Audi_DE_ING'
				--AND  ITEM_ID = 'AMVAGBEVM-A4-C01'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'SDC'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'G481-P'
				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15AI4002'
				--AND  SCM_SITE_ID = 'Audi_DE_ING'
				--AND  ITEM_ID = 'AMVAGBEVN-A4-C01'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'SDC'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'G481-P'
				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15PE7001'
				--AND  SCM_SITE_ID = 'Porsche_SK_BTS'
				--AND  ITEM_ID = 'APPAG12V0-A3-C06'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'MPS'
				--AND  INCOTERMS = 'DAP'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'A040-P'
		OPEN PEGGING_OUT_CUR;
		FETCH PEGGING_OUT_CUR INTO    v_division_id		,
												v_VERSION_NO		,
												v_project_code		,
												v_scm_site_id		,
												v_item_id			,
												v_dom_exp			,
												v_fcst_type		,
												v_incoterms		,
												v_measure			,
												v_plant_site_id	,
												v_cell_prod_site_id;				-- [PJ2025-50017] 추가
		WHILE PEGGING_OUT_CUR%FOUND LOOP
			-- 초기값 설정
			v_section1_01 := 0;
			v_section1_02 := 0;
			v_section1_03 := 0;
			v_section1_04 := 0;
			v_section1_05 := 0;
			v_section1_06_01 := 0;
			v_section1_06_02 := 0;
			v_section1_07_01 := 0;
			v_section1_07_02 := 0;

			v_section2_01 := 0;
			v_section2_02 := 0;
			v_section2_03 := 0;
			v_section2_04 := 0;
			v_section2_05 := 0;
			v_section2_06_01 := 0;
			v_section2_06_02 := 0;
			v_section2_07_01 := 0;
			v_section2_07_02 := 0;

			/* 1. 불변구간(고객인도 ~ 출하6주전) FCST 구하기 */--------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1. 전주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0)
  INTO v_section1_01
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD');

			-- 1-2.  당주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section1_02
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD');
				--ORDER BY M_DEMAND_ID
			-- 2. 이월
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section1_03
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD');

			-- 3. 신규/증량
			SELECT		NVL(SUM(QTY), 0) INTO v_section1_04
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
				AND     A.DEMAND_CHANGE_TYPE = 'NEW';

			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	NVL(SUM(R1.QTY), 0) - NVL(SUM(R2.QTY), 0) INTO v_section1_05
				FROM	(
							SELECT	DEMAND_ID,
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING
							WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
							AND     DEMAND_CHANGE_TYPE <> 'CO'
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY
													FROM
													(
														SELECT	DEMAND_ID,
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
														AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
														AND     DEMAND_CHANGE_TYPE <> 'CO'
													) A INNER JOIN
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID;

			-- 5-1. 주차이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section1_06_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
																   INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW  <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW   < R.ISO_M_YYYYWW; 					-- 이전날자로 이동한 경우

			-- 5-2. 주차이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section1_06_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW  <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW   > R.ISO_M_YYYYWW; 				-- 이후날자로 이동한 경우

			-- 6-1. 일자이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section1_07_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B   ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C   ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD;

			-- 6-2. 일자이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section1_07_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B   ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C   ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD;
			/* 1. 불변구간(고객인도 ~ 출하6주전) FCST 구하기 */--------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END
			/* 2. 확정구간(출하7주전 ~ 출하11주전) FCST 구하기 */------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1. 확정구간 전주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section2_01
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD');

			-- 1-2. 확정구간 당주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section2_02
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 *10), 'YYYYMMDD');
				--ORDER BY M_DEMAND_ID
			-- 2. 이월
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section2_03
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD');

			-- 3. 신규/증량
			SELECT		NVL(SUM(QTY), 0) INTO v_section2_04
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
				AND		A.DEMAND_CHANGE_TYPE <> 'CO'				-- 이월을 제외하고
				AND     A.DEMAND_CHANGE_TYPE = 'NEW';
				--GROUP BY SUBSTR(DEMAND_ID, 1, 14)
			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	NVL(SUM(R1.QTY), 0) - NVL(SUM(R2.QTY), 0) INTO v_section2_05
				FROM	(
							SELECT	DEMAND_ID,
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING
							WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND     DEMAND_CHANGE_TYPE <> 'CO'
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY
													FROM
													(
														SELECT	DEMAND_ID,
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
														AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
														AND     DEMAND_CHANGE_TYPE <> 'CO'
													) A INNER JOIN
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID;

			-- 5-1. 주차이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section2_06_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B   ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C   ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  < R.ISO_M_YYYYWW;

			-- 5-2. 주차이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section2_06_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A   INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  > R.ISO_M_YYYYWW;

			-- 6-1. 일자이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section2_07_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A   INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD;

			-- 6-2. 일자이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section2_07_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A   INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 5), 'YYYYMMDD')				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD;

			/* 2. 확정구간(출하7주전 ~ 출하11주전) FCST 구하기 */------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END
			/* 3. 확정구간(출하12주전) FCST 구하기 */------------------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1.  전주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section3_01
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD');

			-- 1-2. 당주 FCST
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section3_02
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD');
				--ORDER BY M_DEMAND_ID
			-- 2. 이월
			SELECT		NVL(SUM(NVL(QTY, 0)), 0) INTO v_section3_03
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD');

			-- 3. 신규/증량
			SELECT		NVL(SUM(QTY), 0) INTO v_section3_04
				FROM	DM_PLN_DEMANDID_PEGGING A
				WHERE	1 =1
				AND     DIVISION_ID     = v_division_id
				AND		PROJECT_CODE	= v_project_code
				AND		SCM_SITE_ID		= v_scm_site_id
				AND		ITEM_ID			= v_item_id
				AND		DOM_EXP			= v_dom_exp
				AND		FCST_TYPE		= v_fcst_type
				AND		INCOTERMS		= v_incoterms
				AND		MEASURE			= v_measure
				AND		PLANT_SITE_ID	= v_plant_site_id
				AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
				AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
				AND		A.DEMAND_CHANGE_TYPE <> 'CO'				-- 이월을 제외하고
				AND     A.DEMAND_CHANGE_TYPE = 'NEW';
				--GROUP BY SUBSTR(DEMAND_ID, 1, 14)
			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	NVL(SUM(R1.QTY), 0) - NVL(SUM(R2.QTY), 0) INTO v_section3_05
				FROM	(
							SELECT	DEMAND_ID,
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING
							WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
							AND     DEMAND_CHANGE_TYPE <> 'CO'
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY
													FROM
													(
														SELECT	DEMAND_ID,
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
														AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
														AND     DEMAND_CHANGE_TYPE <> 'CO'
													) A INNER JOIN
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING
														WHERE	1 =1
														AND     DIVISION_ID     = v_division_id
														AND		PROJECT_CODE	= v_project_code
														AND		SCM_SITE_ID		= v_scm_site_id
														AND		ITEM_ID			= v_item_id
														AND		DOM_EXP			= v_dom_exp
														AND		FCST_TYPE		= v_fcst_type
														AND		INCOTERMS		= v_incoterms
														AND		MEASURE			= v_measure
														AND		PLANT_SITE_ID	= v_plant_site_id
														AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID;

			-- 5-1. 주차이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section3_06_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  < R.ISO_M_YYYYWW;

			-- 5-2. 주차이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section3_06_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  And   R.ISO_YYYYWW  > R.ISO_M_YYYYWW;

			-- 6-1. 일자이동(선행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section3_07_01
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD;

			-- 6-2. 일자이동(후행)
			SELECT	NVL(SUM(R.QTY), 0) INTO v_section3_07_02
			  FROM  (
					SELECT	A.DEMAND_ID
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  INNER JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1
							AND     DIVISION_ID     = v_division_id
							AND		PROJECT_CODE	= v_project_code
							AND		SCM_SITE_ID		= v_scm_site_id
							AND		ITEM_ID			= v_item_id
							AND		DOM_EXP			= v_dom_exp
							AND		FCST_TYPE		= v_fcst_type
							AND		INCOTERMS		= v_incoterms
							AND		MEASURE			= v_measure
							AND		PLANT_SITE_ID	= v_plant_site_id
							AND		CELL_PROD_SITE_ID = v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 10), 'YYYYMMDD')
							AND		YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (7 * 11), 'YYYYMMDD')
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD;

			/* 3. 확정구간(출하12주전) FCST 구하기 */------------------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END
			INSERT /*+ NO_PARALLEL */ INTO GT_DPDPS_RESULT_TBL(
										DIVISION_ID			,
										VERSION_NO          ,
										PROJECT_CODE		,
										SCM_SITE_ID			,
										ITEM_ID				,
										DOM_EXP				,
										FCST_TYPE			,
										INCOTERMS			,
										MEASURE				,
										PLANT_SITE_ID		,
										CELL_PROD_SITE_ID	,					-- [PJ2025-50017] 추가
										S1_BF_WK_FCST		,
										S1_NOW_WK_FCST		,
										S1_CO_FCST			,
										S1_NEW_FCST			,
										S1_DEL_FCST			,
										S1_WK_MV_FCST_PRE	,
										S1_WK_MV_FCST_POST	,
										S1_DAY_MV_FCST_PRE	,
										S1_DAY_MV_FCST_POST	,
										S2_BF_WK_FCST		,
										S2_NOW_WK_FCST		,
										S2_CO_FCST			,
										S2_NEW_FCST			,
										S2_DEL_FCST			,
										S2_WK_MV_FCST_PRE	,
										S2_WK_MV_FCST_POST	,
										S2_DAY_MV_FCST_PRE	,
										S2_DAY_MV_FCST_POST	,
										S3_BF_WK_FCST		,
										S3_NOW_WK_FCST		,
										S3_CO_FCST			,
										S3_NEW_FCST			,
										S3_DEL_FCST			,
										S3_WK_MV_FCST_PRE	,
										S3_WK_MV_FCST_POST	,
										S3_DAY_MV_FCST_PRE	,
										S3_DAY_MV_FCST_POST
									)
								VALUES (
										v_division_id				,
										v_VERSION_NO               ,
										v_project_code				,
										v_scm_site_id				,
										v_item_id					,
										v_dom_exp					,
										v_fcst_type				,
										v_incoterms				,
										v_measure					,
										v_plant_site_id			,
										v_cell_prod_site_id		,				-- [PJ2025-50017] 추가

										v_section1_01				,
										v_section1_02				,
										v_section1_03				,
										v_section1_04				,
										v_section1_05				,
										v_section1_06_01			,
										v_section1_06_02			,
										v_section1_07_01			,
										v_section1_07_02			,

										v_section2_01				,
										v_section2_02				,
										v_section2_03				,
										v_section2_04				,
										v_section2_05				,
										v_section2_06_01			,
										v_section2_06_02			,
										v_section2_07_01			,
										v_section2_07_02			,

										v_section3_01				,
										v_section3_02				,
										v_section3_03				,
										v_section3_04				,
										v_section3_05				,
										v_section3_06_01			,
										v_section3_06_02			,
										v_section3_07_01			,
										v_section3_07_02
										);

			-- OUTER CURSOR
			FETCH PEGGING_OUT_CUR INTO v_division_id		,
												v_VERSION_NO		,
												v_project_code		,
												v_scm_site_id		,
												v_item_id			,
												v_dom_exp			,
												v_fcst_type		,
												v_incoterms		,
												v_measure			,
												v_plant_site_id	,
												v_cell_prod_site_id;				-- [PJ2025-50017] 추가

		END LOOP;

		CLOSE PEGGING_OUT_CUR;

		-- INSERT INTO 전 중복제거
		DELETE
		FROM DM_PLN_DEMAND_CHANGE_STATUS
			where 1=1
				and exists (
					SELECT division_id
						FROM GT_DPDPS_RESULT_TBL
							where 1=1
								and DM_PLN_DEMAND_CHANGE_STATUS.DIVISION_ID     =   DIVISION_ID
								and DM_PLN_DEMAND_CHANGE_STATUS.VERSION_NO      =   VERSION_NO
							);

		INSERT INTO DM_PLN_DEMAND_CHANGE_STATUS
			 (
			 DIVISION_ID,VERSION_NO,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
			,CELL_PROD_SITE_ID						-- [PJ2025-50017] 추가
			,S1_BF_WK_FCST,S1_NOW_WK_FCST,S1_CO_FCST,S1_NEW_FCST,S1_DEL_FCST,S1_WK_MV_FCST_PRE,S1_WK_MV_FCST_POST,S1_DAY_MV_FCST_PRE,S1_DAY_MV_FCST_POST
			,S2_BF_WK_FCST,S2_NOW_WK_FCST,S2_CO_FCST,S2_NEW_FCST,S2_DEL_FCST,S2_WK_MV_FCST_PRE,S2_WK_MV_FCST_POST,S2_DAY_MV_FCST_PRE,S2_DAY_MV_FCST_POST
			,S3_BF_WK_FCST,S3_NOW_WK_FCST,S3_CO_FCST,S3_NEW_FCST,S3_DEL_FCST,S3_WK_MV_FCST_PRE,S3_WK_MV_FCST_POST,S3_DAY_MV_FCST_PRE,S3_DAY_MV_FCST_POST
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
			 )
		SELECT
			 DIVISION_ID
			,VERSION_NO
			,PROJECT_CODE
			,SCM_SITE_ID
			,ITEM_ID
			,DOM_EXP
			,FCST_TYPE
			,INCOTERMS
			,MEASURE
			,PLANT_SITE_ID
			,CELL_PROD_SITE_ID						-- [PJ2025-50017] 추가
			,S1_BF_WK_FCST
			,S1_NOW_WK_FCST
			,S1_CO_FCST
			,S1_NEW_FCST
			,S1_DEL_FCST
			,S1_WK_MV_FCST_PRE
			,S1_WK_MV_FCST_POST
			,S1_DAY_MV_FCST_PRE
			,S1_DAY_MV_FCST_POST
			,S2_BF_WK_FCST
			,S2_NOW_WK_FCST
			,S2_CO_FCST
			,S2_NEW_FCST
			,S2_DEL_FCST
			,S2_WK_MV_FCST_PRE
			,S2_WK_MV_FCST_POST
			,S2_DAY_MV_FCST_PRE
			,S2_DAY_MV_FCST_POST
			,S3_BF_WK_FCST
			,S3_NOW_WK_FCST
			,S3_CO_FCST
			,S3_NEW_FCST
			,S3_DEL_FCST
			,S3_WK_MV_FCST_PRE
			,S3_WK_MV_FCST_POST
			,S3_DAY_MV_FCST_PRE
			,S3_DAY_MV_FCST_POST
			,'SYSTEM',SYSDATE,'SYSTEM',SYSDATE
		 FROM GT_DPDPS_RESULT_TBL;

		COMMIT;

	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
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