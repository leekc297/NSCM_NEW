PROCEDURE           "SCP0013_GET_PRODUCTION_PLAN_LINEBY"
(
	  p_division_id			VARCHAR2		= N''
	, p_operation_group		VARCHAR2		= N''
	, p_scm_site_id			VARCHAR2		= N''
	, p_line_id				VARCHAR2		= N''
	, p_model_id				VARCHAR2		= N''
	, p_item_id				VARCHAR2		= N''
	, p_from_yyyymmdd			VARCHAR2			= N''
    , p_to_yyyymmdd			VARCHAR2			= N''
	, p_plan_start_yyyymmdd	VARCHAR2			= N''
	, p_plan_type				VARCHAR2		= N''
	, p_seq					VARCHAR2		= N''
	, p_program_id				VARCHAR2		 DEFAULT 'SCP0013'
	, p_sheet_name				VARCHAR2		 DEFAULT 'LINE'
	, p_user_id				VARCHAR2		= N''
	, p_electrode_type			VARCHAR2		= N''
	, p_nick_name				VARCHAR2		= N''
	, p_cell_type_gr			VARCHAR2		= N''
	, p_line_assign			VARCHAR2		 DEFAULT 'N'
	, p_bucket					VARCHAR2		= N''
	, p_chk_all				VARCHAR2			= N'' -- 2021.11.24 :  체크 시 bucket DEFAULT 'daily' 조회
	, p_extra_spec				VARCHAR2		= N''	-- Extra Spec 조회조건 추가
	, v_debug_mode				VARCHAR2		 DEFAULT 'F'
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:41:15
 * 파일: dbo.SCP0013_GET_PRODUCTION_PLAN_LINEBY.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:2  END:0  차이:+2
 * ----------------------------------------
 * BEGIN 위치: L171, L1561
 * END;  위치: L2180
 * ----------------------------------------
 * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_division_group VARCHAR2(30 CHAR);
    v_division_comp VARCHAR2(30 CHAR);
    v_cnt_usr_measure INTEGER := 0;
    v_item_input VARCHAR2(1 CHAR) := 'N';
    v_min_yyyymmdd VARCHAR2(8 CHAR);
    v_plan_month VARCHAR2(6 CHAR);
    v_from_yyyymmdd VARCHAR2(8 CHAR);
    v_to_yyyymmdd VARCHAR2(8 CHAR);
    v_from_result VARCHAR2(8 CHAR);
    v_to_result VARCHAR2(8 CHAR);
    v_result_only CHAR(1) := 'N';
    p_plan_end_yyyymmdd VARCHAR2(8 CHAR);
    v_mQuery VARCHAR2(4000 CHAR);
    v_mEXEC VARCHAR2(4000 CHAR);
    v_mQry_field VARCHAR2(4000 CHAR);
    v_arr_cell_type_gr VARCHAR2(max);
    v_arr_extra_spec VARCHAR2(4000 CHAR);
    v_arr_model_id VARCHAR2(MAX);
    V_SQL2 VARCHAR2(max);
    V_SQL3 VARCHAR2(max);
BEGIN
			SET ARITHIGNORE ON
	SET ARITHABORT OFF
	    --    p_division_id VARCHAR2(50 CHAR) := '40';;
    --    p_operation_group VARCHAR2(50 CHAR) := 'P';;
    --    p_scm_site_id VARCHAR2(4000 CHAR) := N'';;
    --    p_line_id VARCHAR2(4000 CHAR) := N'';;
    --    p_model_id VARCHAR2(4000 CHAR) := N'';;
    --    p_item_id VARCHAR2(4000 CHAR) := N'';;
    --    p_from_yyyymmdd VARCHAR2(8 CHAR) := '20240715';;
    --    p_to_yyyymmdd VARCHAR2(8 CHAR) := '20250713';;
    --    p_plan_start_yyyymmdd VARCHAR2(8 CHAR) := '20240715';;
    --    p_plan_type VARCHAR2(50 CHAR) := 'PR';;
    --    p_seq VARCHAR2(50 CHAR) := '1';;
    --    p_program_id VARCHAR2(300 CHAR) := 'SCP0013';;
    --    p_sheet_name VARCHAR2(150 CHAR) := 'LINE';;
    --    p_user_id VARCHAR2(100 CHAR) := 'iamarock';;
    --    p_electrode_type VARCHAR2(30 CHAR) := N'';;
    --    p_nick_name VARCHAR2(50 CHAR) := N'';;
    --    p_cell_type_gr VARCHAR2(30 CHAR) := N'';;
    --    p_line_assign VARCHAR2(30 CHAR) := 'N';;
    --    p_bucket VARCHAR2(10 CHAR) := 'DAILY';;
    --    p_chk_all VARCHAR2(1 CHAR) := 'N';;
    --    v_debug_mode VARCHAR2(20 CHAR) := 'F';;

	-- 20240108  E20240104-001182 EE JV 를 위한 Division Group 처리


    /*------------------------------------------------------------------
     * Division Group 정의  (Joint Venture 사업부 추가)
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 'v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC
    ----------------------------------------------------------------------*/
    SELECT di.attribute3,
    di.ATTRIBUTE4
  INTO v_division_group, v_division_comp
    FROM   scm_mst_division di
    WHERE  di.valid_yn         =  'Y'
    AND    di.division_id      =  p_division_id;


								SELECT COUNT(*)  INTO v_cnt_usr_measure
								FROM scm_mst_titleset_user
								WHERE 1=1
								 AND program_id  =  p_program_id
								 AND sheet_name  =  p_sheet_name
								 AND user_id     =  p_user_id;
	IF (v_debug_mode ='T') THEN
		DBMS_OUTPUT.PUT_LINE('v_cnt_usr_measure='  || TO_CHAR(v_cnt_usr_measure));









	v_plan_month := NULL; -- 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보
	v_from_yyyymmdd := NULL;
	v_to_yyyymmdd := NULL;
	v_from_result := NULL;
	v_to_result := NULL;

	-- 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보
	SELECT basis_yyyymm
  INTO v_plan_month
	FROM   SCM_SYS_CALENDAR_M      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이 속한 월 기준

	SELECT v_from_yyyymmdd = C.BASIS_START_DATE
	FROM   SCM_SYS_CALENDAR_M      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = p_plan_start_yyyymmdd

	SELECT v_from_result = C.BASIS_START_DATE
	FROM   SCM_SYS_CALENDAR_M      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = p_from_yyyymmdd;

	SELECT C.BASIS_START_DATE
  INTO v_to_result
	FROM   SCM_SYS_CALENDAR_M      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = p_to_yyyymmdd;

	IF v_from_yyyymmdd > v_from_result THEN
			v_to_yyyymmdd := p_to_yyyymmdd;
			v_to_result := v_from_yyyymmdd;
	ELSIF v_from_yyyymmdd <= v_from_result THEN
			v_to_yyyymmdd := p_to_yyyymmdd;
			v_from_result := TO_CHAR(ADD_MONTHS(TO_DATE(p_plan_start_yyyymmdd), 6), 'YYYYMMDD');
			v_to_result := TO_CHAR(ADD_MONTHS(TO_DATE(p_plan_start_yyyymmdd), -6), 'YYYYMMDD');
	ELSIF v_from_yyyymmdd > v_to_result THEN
			v_from_yyyymmdd := TO_CHAR(ADD_MONTHS(TO_DATE(p_plan_start_yyyymmdd), -6), 'YYYYMMDD');
			v_to_yyyymmdd := TO_CHAR(ADD_MONTHS(TO_DATE(p_plan_start_yyyymmdd), -6), 'YYYYMMDD');
			v_from_result := p_from_yyyymmdd;
			v_to_result := p_to_yyyymmdd;
	ELSIF v_from_yyyymmdd = v_to_result THEN
			v_to_yyyymmdd := v_from_yyyymmdd;
			v_from_result := p_from_yyyymmdd;
			v_to_result := p_to_yyyymmdd;
		END IF;

	IF v_debug_mode ='T' THEN
			DBMS_OUTPUT.PUT_LINE('----------------------------------');
			DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd ='  || v_from_yyyymmdd);
			DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd ='  || v_to_yyyymmdd);
			DBMS_OUTPUT.PUT_LINE('v_from_result ='  || v_from_result);
			DBMS_OUTPUT.PUT_LINE('v_to_result ='  || v_to_result	);
			DBMS_OUTPUT.PUT_LINE('----------------------------------');
		END IF;

	-- 실적용

	IF v_from_yyyymmdd > v_to_yyyymmdd THEN
		v_result_only := 'Y';
	END IF;


	DBMS_OUTPUT.PUT_LINE('Start. ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


	SELECT p_plan_end_yyyymmdd= MAX_BASIS_YYYYMMDD
	FROM (
			SELECT MIN_BASIS_YYYYMMDD
					,DATEPART(DW,MIN_BASIS_YYYYMMDD ) AS MIN_PART
					,TO_CHAR(TO_DATE(MAX_BASIS_YYYYMMDD)-DATEPART(DW,MAX_BASIS_YYYYMMDD ) || 1, 'YYYYMMDD')  AS MAX_BASIS_YYYYMMDD
					,DATEPART(DW,MAX_BASIS_YYYYMMDD ) AS MAX_PART
				FROM (	SELECT MIN(A.BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
						FROM SCM_SYS_CALENDAR_M A
						WHERE A.BASIS_YYYYMMDD >= p_plan_start_yyyymmdd
						AND A.BASIS_YYYYMMDD <= TO_CHAR(ADD_MONTHS(p_plan_start_yyyymmdd, TO_NUMBER('18')), 'YYYYMMDD') -- 2021-05-27 : 중장기(12=>18로 변경)
					) T;
			) U;

	-- 2021.11.24 : 체크 시 bucket='daily' 조회
	IF(p_chk_all = 'Y')	p_bucket := 'DAILY' ; THEN

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	-- Pivot용 Row Data 적재용
	-- Model/NickName 조회 시 Plant, Line 추출용
	-- Line Assign 체크 시 T/T Plant, Line 추출용
	-- Base Row Date 조회
	-- Line Load율 조회
	-- Prod Plan(Amend) 로드율 계산용 Working Time 조회
	-- 과거생산실적 조회
	-- 생산계획 조회
	-- Base Row Date-KEY 조회
	-- 2023/06/12 begin
	-- 임시테이블 초기화
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCP0_DynamicPivot_SCP0013_P';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCP0_DynamicPivot_SCP0013_P';


	-- 2023.01.02
	--SELECT v_min_yyyymmdd = MIN_YYYYMMDD FROM FN_GET_SCP_PLAN_MIN_DATE(p_program_id, p_division_id, p_plan_type, p_operation_group, p_seq);
	SELECT replace(TO_CHAR(SYSDATE  ||  (datepart(dw,SYSDATE) * -1 - 5), 'YYYY-MM-DD HH24:MI:SS'),'-','');
  INTO v_min_yyyymmdd
		v_item_input := 'Y'
	FROM DUAL;

		IF p_plan_start_yyyymmdd >= v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_P
			SELECT distinct SCM_SITE_ID, line_id
			FROM scp_anl_production_plan A
			WHERE 1=1
			AND division_id	         = p_division_id
			AND operation_group      = p_operation_group
			AND plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND plan_type            = p_plan_type
			AND seq				     = p_seq
			AND LINE_ID				 != '*';
			/*AND ( (p_nick_name=NULL OR p_nick_name='') OR
				item_id              IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+p_nick_name+'%')
			)
			AND ( (p_item_id=NULL OR p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ','))))*/
			AND item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, p_nick_name))
			-- 2021/07/06 LWY
			UNION
			SELECT distinct SCM_SITE_ID, line_id
			FROM SCM_DNM_PRODUCT_RESULT_V A
			WHERE 1=1
			AND division_id	         = p_division_id
			AND company_id IN (
											SELECT DISTINCT company_id  AS operation_id
											FROM SCM_MST_SITE
											WHERE 1=1
											AND ( p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) OR division_id = p_division_id ) --div_commonization
											AND site_type   = 'PLANT'
											AND valid_yn    = 'Y'
											)
			AND scp_operation_group  = p_operation_group
			AND plan_date  >= v_from_result
			AND plan_date  <  v_to_result
			AND LINE_ID				 != '*';
			/*AND ( (p_nick_name=NULL OR p_nick_name='') OR
				item_id IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+p_nick_name+'%')
			)
			AND ( (p_item_id=NULL OR p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ','))))*/
			AND item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, p_nick_name));
			-- 2021/07/06 LWY

		ELSIF p_plan_start_yyyymmdd < v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_P
			SELECT distinct SCM_SITE_ID, line_id
			FROM hist_scp_anl_production_plan A
			WHERE 1=1
			AND division_id	         = p_division_id
			AND operation_group      = p_operation_group
			AND plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND plan_type            = p_plan_type
			AND seq				     = p_seq
			AND LINE_ID				 != '*';
			/*AND ( (p_nick_name=NULL OR p_nick_name='') OR
				item_id              IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+p_nick_name+'%')
			)
			AND ( (p_item_id=NULL OR p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ','))))*/
			AND item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, p_nick_name))
			UNION
			SELECT distinct SCM_SITE_ID, line_id
			FROM SCM_DNM_PRODUCT_RESULT_V A
			WHERE 1=1
			AND division_id	         = p_division_id
			AND company_id IN (
											SELECT DISTINCT company_id  AS operation_id
											FROM SCM_MST_SITE
											WHERE 1=1
											AND ( p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) OR division_id = p_division_id ) --div_commonization
											AND site_type   = 'PLANT'
											AND valid_yn    = 'Y'
											)
			AND scp_operation_group  = p_operation_group
			AND plan_date  >= v_from_result
			AND plan_date  <  v_to_result
			AND LINE_ID				 != '*';
			/*AND ( (p_nick_name=NULL OR p_nick_name='') OR
				item_id IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+p_nick_name+'%')
			)
			AND ( (p_item_id=NULL OR p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ','))))*/
			AND item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, p_nick_name));

		END IF;


	-- Line Assign용 Plant, Line 추출
	IF (p_line_assign='Y') THEN
		INSERT INTO GT_SCP0_DynamicPivot_SCP0013_P
		SELECT DISTINCT T.PLANT_SITE_ID AS SCM_SITE_ID, T.LINE_ID, T.PLANT_SITE_ID || T.LINE_ID || T.OPERATION_ID AS LINE_ASSIGN_KEY
		FROM scp_mst_tact_time T
		JOIN scm_mst_site S   ON T.division_id = S.division_id AND T.plant_site_id = S.scm_site_id AND S.OSP_YN='N' --외주 제외
		JOIN SCM_MST_LINE_SN LS   ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=S.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
									AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y' -- 활성화 된 라인
		JOIN SCP_MST_FINAL_ITEM_V V   ON V.ITEM_ID=T.ITEM_ID AND NVL(V.TCO_CELL_YN,'-')='N' -- TCO Cell 제외
		WHERE 1=1
		AND T.VALID_YN		= 'Y'
		--AND (p_division_id IN ('EE','EE_UC') or T.DIVISION_ID	= p_division_id)
		AND (p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) or T.DIVISION_ID	= p_division_id) --div_commonization
		AND T.OPERATION_ID	<> 'P5000' -- P5000공정 제외
		--AND ( (p_item_id=NULL OR p_item_id='') OR T.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ','))))
		AND ( (p_item_id=NULL OR p_item_id='') OR T.item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, '')))
		-- 외주
		UNION ALL

		SELECT DISTINCT a.scm_site_id, '-' as LINE_ID, a.scm_site_id || '-' || b.vendor_code AS LINE_ASSIGN_KEY
		FROM scm_mst_site a
		JOIN SCM_MST_VENDOR b   ON a.plant_id = b.vendor_code
		JOIN SCM_MST_SITE_ITEM_PRIORITY c   ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		JOIN SCP_MST_OUTSOURCING_CAPA d   ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id and c.item_id = d.item_id
		WHERE (p_division_id='EE' or a.division_id = p_division_id) --a.division_id = p_division_id
		AND a.osp_yn ='Y' -- 외주
		-- ESS 외주 Pakcer Line 생산 Target 적용
		AND NVL(a.attribute1,'N') IN ('','N')
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y' -- Project Route
		--AND d.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ',')))
		AND ( (p_item_id=NULL OR p_item_id='') OR d.item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, '')))

		-- ESS 외주 Pakcer Line 생산 Target 적용
		UNION ALL

		SELECT DISTINCT T.PLANT_SITE_ID AS SCM_SITE_ID, T.LINE_ID, T.PLANT_SITE_ID || T.LINE_ID || b.vendor_code AS LINE_ASSIGN_KEY
		FROM scp_mst_tact_time_osp T
		JOIN scm_mst_site S   ON T.division_id = S.division_id AND T.plant_site_id = S.scm_site_id AND S.OSP_YN='Y' AND NVL(S.ATTRIBUTE1,'N')='Y' AND S.VALID_YN='Y'
		JOIN SCM_MST_VENDOR b   ON s.plant_id = b.vendor_code
		JOIN SCM_MST_LINE_OSP LS   ON LS.DIVISION_ID=S.DIVISION_ID AND LS.SCM_SITE_ID=S.scm_site_id AND LS.VALID_YN='Y' AND T.LINE_ID=LS.LINE_ID
		WHERE 1=1
		AND T.VALID_YN		= 'Y'
		--AND (p_division_id IN ('EE','EE_UC') or T.DIVISION_ID	= p_division_id)
		AND (p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) or T.DIVISION_ID	= p_division_id) --div_commonization
		--AND T.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM TABLE(fn_string_split(p_item_id		, ',')))
		AND ( (p_item_id=NULL OR p_item_id='') OR T.item_id IN (SELECT * FROM FN_GET_ITEM_LIKE_CONDITION(p_item_id, '')));
	END IF;


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCP0_DynamicPivot_SCP0013_t';

		-- qty > 0 추출
		IF p_plan_start_yyyymmdd >= v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_t
			SELECT
				 a.DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,a.OPERATION_GROUP
				,SCM_SITE_ID
				,a.ITEM_ID
				,LINE_ID
				,OPERATION_ID
				,MEASURE
				,YYYYMMDD
				,QTY
				,CELL_QTY
				,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN SUBSTR(a.scm_site_id, 1, LENGTH(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
				,ORIGIN_DIVISION_ID
				,a.ELECTRODE_TYPE
				,b.CELL_TYPE_GROUP_CODE

			FROM scp_anl_production_plan a
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group

			WHERE 1=1
			AND a.yyyymmdd			  >= p_from_yyyymmdd
			AND a.yyyymmdd			  <= p_to_yyyymmdd
			AND a.division_id	       = p_division_id
			AND a.operation_group      = p_operation_group
			AND a.plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND a.plan_type            = p_plan_type
			AND a.seq				   = p_seq
			AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
			AND ( ( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
			AND ( ( p_cell_type_gr IS NULL OR    p_cell_type_gr    IS NULL ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM TABLE(fn_string_split(p_cell_type_gr    ,','))) )
			and NVL(a.qty,0) > 0;

			-- 20240108 E20240104-001182 'PROD_PLAN_ENGINE_STD_JR' AS MEASURE 생성 부분 IF 문 밖으로 처리

		ELSIF p_plan_start_yyyymmdd < v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_t
			SELECT
				 a.DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,a.OPERATION_GROUP
				,SCM_SITE_ID
				,a.ITEM_ID
				,LINE_ID
				,OPERATION_ID
				,MEASURE
				,YYYYMMDD
				,QTY
				,CELL_QTY
				,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN SUBSTR(a.scm_site_id, 1, LENGTH(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
				,ORIGIN_DIVISION_ID
				,a.ELECTRODE_TYPE
				,b.CELL_TYPE_GROUP_CODE

			FROM hist_scp_anl_production_plan a
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  >= p_from_yyyymmdd
			AND a.yyyymmdd			  <= p_to_yyyymmdd
			AND a.division_id	       = p_division_id
			AND a.operation_group      = p_operation_group
			AND a.plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND a.plan_type            = p_plan_type
			AND a.seq				   = p_seq
			AND ( ( p_scm_site_id IS NULL OR    p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
			AND ( ( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
			AND ( ( p_cell_type_gr IS NULL OR    p_cell_type_gr    IS NULL ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM TABLE(fn_string_split(p_cell_type_gr    ,','))) )
			and NVL(a.qty,0) > 0;
		END IF;

        -- 20240108  E20240104-001182 IF 문 밖으로 처리 : START
		--PROD_PLAN_ENGINE 기준으로 전극단위 추가 및 계산
		--전극 단위 가 M 일때 QTY / LANE , EA 일때 QTY / (LANE * CELL_CF)
		--IF (p_division_id = 'EE' and p_operation_group = 'E')
		IF (v_division_group = 'EE' and p_operation_group = 'E') THEN
				INSERT INTO GT_SCP0_DynamicPivot_SCP0013_t
				SELECT    A.DIVISION_ID
						, A.PLAN_START_YYYYMMDD
						, A.PLAN_TYPE
						, A.SEQ
						, A.OPERATION_GROUP
						, A.SCM_SITE_ID
						, A.ITEM_ID
						, A.LINE_ID
						, A.OPERATION_ID
						, 'PROD_PLAN_ENGINE_STD_JR' AS MEASURE
						, A.YYYYMMDD
						, CASE
						    WHEN X.ITEM_UOM =  'M' THEN
							    CASE
								    WHEN B.LANE_QTY  = 0  THEN A.QTY / 1.0
								    ELSE A.QTY / (B.LANE_QTY / TO_NUMBER(NVL(F.ATTRIBUTE1, 1.0)))
							    END IF;
						    --	WHEN 'EA' THEN
							    --CASE B.LANE_QTY
							    --	WHEN 0 THEN (A.QTY / H.CELL_CF) / (1 / F.ATTRIBUTE1)
							    --	ELSE (A.QTY / H.CELL_CF) / (B.LANE_QTY / F.ATTRIBUTE1)
							    --END
						    WHEN X.ITEM_UOM =  'EA' THEN
                                CASE
                                    WHEN F.ATTRIBUTE1 = '1'                           THEN A.QTY / NVL(FG.JOMBO_ROLL, NVL(FW.JOMBO_ROLL, 1.0)) / (1.0 / TO_NUMBER(NVL(F.ATTRIBUTE1, 1.0)))
                                    WHEN F.ATTRIBUTE1 = '2' AND FW.JOMBO_ROLL IS NULL THEN A.QTY / NVL(FG.JOMBO_ROLL, 1.0)
						    ELSE QTY
						  END AS QTY
						, 0 CELL_QTY
						, A.SCM_SITE_ID2
						, A.ORIGIN_DIVISION_ID
						, A.ELECTRODE_TYPE
						, A.CELL_TYPE_GROUP_CODE

				FROM GT_SCP0_DynamicPivot_SCP0013_t A
						LEFT JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B ON
								A.ITEM_ID = B.ITEM_ID AND LANE_QTY <> 0
						--AND SUBSTR(A.PLAN_START_YYYYMMDD,0,7) = B.MONTH
						AND B.MONTH   = v_plan_month -- 20240108  E20240104-001182  당주가 속한 월 조건으로 변경
							AND A.LINE_ID = B.LINE_ID
						--LEFT JOIN (SELECT ITEM_UOM, MIN(DIVISION_ID) FROM SCM_MST_ITEM_SN X  ON A.ITEM_ID = X.ITEM_ID AND X.COMPANY_ID = 'C100' GROUP BY ITEM_UOM)
						LEFT JOIN (
									SELECT DISTINCT
											  ITEM_ID
											, ITEM_UOM
											, MIN(DIVISION_ID) AS DIVISION_ID
									FROM	SCM_MST_ITEM_SN
									WHERE	1=1 --COMPANY_ID = 'C100'
									GROUP BY ITEM_ID, ITEM_UOM
								  ) X ON
								A.ITEM_ID = X.ITEM_ID
						LEFT JOIN SCP_MST_ITEM_CELL_CF H  ON
								A.ITEM_ID = H.ITEM_ID --CELL
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    SCM_MST_ITEM_CONV_CALC_SN C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                            ) A;
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) F ON
								A.SCM_SITE_ID = F.SCM_SITE_ID
							AND A.LINE_ID     = F.LINE_ID
							AND A.ITEM_ID     = F.ITEM_ID
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    SCM_MST_ITEM_CONV_CALC_SN C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                                    AND C.PROD_VERSION_TYPE   = 'GENERAL'
                                            ) A;
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) FG ON
								A.SCM_SITE_ID = FG.SCM_SITE_ID
							AND A.LINE_ID     = FG.LINE_ID
							AND A.ITEM_ID     = FG.ITEM_ID
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    SCM_MST_ITEM_CONV_CALC_SN C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                                    AND C.PROD_VERSION_TYPE   = 'WIDE'
                                            ) A;
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) FW ON
								A.SCM_SITE_ID = FW.SCM_SITE_ID
							AND A.LINE_ID     = FW.LINE_ID
							AND A.ITEM_ID     = FW.ITEM_ID
				WHERE	MEASURE = 'PROD_PLAN_ENGINE';
			END IF;
        -- 20240108  E20240104-001182 IF 문 밖으로 처리 : END

		DBMS_OUTPUT.PUT_LINE('1. Base Row.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

--TESTING : NOK
--select * from GT_SCP0_DynamicPivot_SCP0013_t;return;


		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCP0_DynamicPivot_SCP0013_k';

		IF p_plan_start_yyyymmdd >= v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_k
			SELECT distinct
		     a.DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,a.OPERATION_GROUP
			,SCM_SITE_ID
			,a.ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,MEASURE
			,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN SUBSTR(a.scm_site_id, 1, LENGTH(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
			,ORIGIN_DIVISION_ID
			,a.ELECTRODE_TYPE
			,b.CELL_TYPE_GROUP_CODE

			FROM scp_anl_production_plan a
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  = p_plan_start_yyyymmdd

			AND a.division_id	       = p_division_id
			AND a.operation_group      = p_operation_group
			AND a.plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND a.plan_type            = p_plan_type
			AND a.seq				   = p_seq
			AND A.LINE_ID				 != '*'
			AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
			AND ( ( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
			AND ( ( p_cell_type_gr IS NULL OR         p_cell_type_gr         IS NULL ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM TABLE(fn_string_split(p_cell_type_gr    ,','))) );

		ELSIF p_plan_start_yyyymmdd < v_min_yyyymmdd THEN
			INSERT INTO GT_SCP0_DynamicPivot_SCP0013_k
			SELECT distinct
		     a.DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,a.OPERATION_GROUP
			,SCM_SITE_ID
			,a.ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,MEASURE
			,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN SUBSTR(a.scm_site_id, 1, LENGTH(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
			,ORIGIN_DIVISION_ID
			,a.ELECTRODE_TYPE
			,b.CELL_TYPE_GROUP_CODE

			FROM hist_scp_anl_production_plan a
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  = p_plan_start_yyyymmdd

			AND a.division_id	       = p_division_id
			AND a.operation_group      = p_operation_group
			AND a.plan_start_yyyymmdd  = p_plan_start_yyyymmdd
			AND a.plan_type            = p_plan_type
			AND a.seq				   = p_seq
			AND A.LINE_ID				 != '*'
			AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
			AND ( ( p_line_id IS NULL OR         p_line_id      IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
			AND ( ( p_cell_type_gr IS NULL OR         p_cell_type_gr         IS NULL ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM TABLE(fn_string_split(p_cell_type_gr    ,','))) );
		END IF;



		DBMS_OUTPUT.PUT_LINE('1.1 Base Row Key Find.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		insert into GT_SCP0_DynamicPivot_SCP0013_t
		SELECT distinct a.DIVISION_ID
					,a.PLAN_START_YYYYMMDD
					,a.PLAN_TYPE
					,a.SEQ
					,a.OPERATION_GROUP
					,a.SCM_SITE_ID
					,a.ITEM_ID
					,a.LINE_ID
					,a.OPERATION_ID
					,a.MEASURE
					,o.basis_yyyymmdd as YYYYMMDD
					,0 as QTY
					,0 as CELL_QTY
					,a.SCM_SITE_ID2
					,a.ORIGIN_DIVISION_ID
					,a.ELECTRODE_TYPE
					,a.CELL_TYPE_GROUP_CODE
		FROM GT_SCP0_DynamicPivot_SCP0013_k A
			 CROSS JOIN LATERAL (  SELECT basis_yyyymmdd
							  FROM scm_sys_calendar_m
							--WHERE basis_yyyymmdd>=v_from_yyyymmdd
							--  AND basis_yyyymmdd<=v_to_yyyymmdd
							 where basis_yyyymmdd = v_to_yyyymmdd
						)  o;
		WHERE 1=1
		  AND NOT EXISTS (SELECT 'X'
							FROM GT_SCP0_DynamicPivot_SCP0013_t B
						   WHERE B.SCM_SITE_ID=A.SCM_SITE_ID
							 AND B.ITEM_ID=A.ITEM_ID
							 AND B.LINE_ID=A.LINE_ID
							 AND B.OPERATION_ID=A.OPERATION_ID
							 AND B.MEASURE=A.MEASURE
							 AND B.YYYYMMDD = o.basis_yyyymmdd
						 )

						 and 'N' = v_result_only;


		DBMS_OUTPUT.PUT_LINE('1.2 Key Row Insert.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


		--Working Time 추출
		/* TODO:GTT:GT_SCP0_DynamicPivot_SCP0013_w-->GT_SCP0_DynamicPivot_SCP0013_w */
		INSERT INTO GT_SCP0_DynamicPivot_SCP0013_w
		SELECT DIVISION_ID
			   , PLANT_SITE_ID AS SCM_SITE_ID
			   , OPERATION_ID
			   , LINE_ID
			   , YYYYMMDD
			   , WORKING_TIME
		FROM FN_LINE_WORKINGTIME_BY_LOSS(p_division_id, v_from_yyyymmdd, v_to_yyyymmdd, p_line_id);

		DBMS_OUTPUT.PUT_LINE('2. Working Time Base.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		--CREATE TABLE GT_SCP0_DynamicPivot_SCP0013_w (
		--		 division_id			VARCHAR2(2 CHAR)
		--		,scm_site_id			VARCHAR2(30 CHAR)
		--		,operation_id			VARCHAR2(30 CHAR)
		--		,line_id				VARCHAR2(50 CHAR)
		--		,yyyymmdd				VARCHAR2(8 CHAR)
		--		,working_time			INTEGER
		--		--,week_yyyymm			VARCHAR2(10 CHAR)
		--		--,yyyymm					VARCHAR2(6 CHAR)
		--		--,week_working_time		INTEGER
		--		--,month_working_time		INTEGER
		--);

		--INSERT INTO GT_SCP0_DynamicPivot_SCP0013_w
		--select a.division_id
		--     , a.scm_site_id
		--	 , a.operation_id
		--	 , a.line_id
		--	 , a.yyyymmdd
		--	 , a.working_time
		--	 --, b.week_yyyymm
		--	 --, SUBSTR(a.yyyymmdd, 1, 6) as yyyymm
		--	 --, sum(working_time) over( partition by a.division_id, a.scm_site_id, a.operation_id, a.line_id, b.week_yyyymm) as week_working_time
		--	 --, sum(working_time) over( partition by a.division_id, a.scm_site_id, a.operation_id, a.line_id, SUBSTR(b.basis_yyyymmdd, 1, 6)) as month_working_time
		--  --into GT_SCP0_DynamicPivot_SCP0013_w
		--  from GT_SCP0_DynamicPivot_SCP0013_w a
		----		, (SELECT basis_yyyymmdd , 'W_' + basis_yyyymm + iso_week as week_yyyymm , iso_yyyyww
		----			FROM scm_sys_calendar_m
		----			WHERE basis_yyyymmdd>= v_from_yyyymmdd
		----			AND basis_yyyymmdd <= v_to_yyyymmdd
		----		)b
		----where a.yyyymmdd = b.basis_yyyymmdd
  --       ;

		DBMS_OUTPUT.PUT_LINE('2.1 Working Time.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		-- LINE 로드율 추출
		/* TODO:GTT:GT_SCP0_DynamicPivot_SCP0013_l-->GT_SCP0_DynamicPivot_SCP0013_l */
		INSERT INTO GT_SCP0_DynamicPivot_SCP0013_l
		SELECT A.*
		FROM (
			-- LINE_TOTAL_LOAD_AMEND 추가
			SELECT distinct
					a.division_id
					,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
					,p_plan_type AS PLAN_TYPE
					,p_seq AS PLAN_SEQ
					,a.operation_group
					,a.scm_site_id	,'-' as item_id	,a.operation_id	,a.line_id
					,'LINE_TOTAL_LOAD_AMEND' AS measure
					, CASE WHEN d.working_time <= 0.0 THEN 0
							ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						END AS qty
					, NVL(round(sum(a.qty * (e.tact_time/60)),0), 0) AS CAPA_TACT
					--, NVL( d.working_time ,0 ) AS working_time
					,p_from_yyyymmdd AS from_yyyymmdd
					,'D_' || a.yyyymmdd AS yyyymmdd
					--,c.basis_yyyymm AS yyyymm
					--,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
					,NVL(NULLIF(a.origin_division_id, NULL),'-') origin_division_id
					,'-' electrode_type
					,'L' CELL_TYPE_GROUP_CODE
					--,'W_'+c.basis_yyyymm + c.iso_week AS week_yyyymmdd
					--,'M_'+c.basis_yyyymm  AS month_yyyymmdd
			FROM GT_SCP0_DynamicPivot_SCP0013_t a
			--JOIN scm_sys_calendar_m c   ON a.yyyymmdd = c.basis_yyyymmdd
			LEFT OUTER JOIN GT_SCP0_DynamicPivot_SCP0013_w d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
					and a.SCM_SITE_ID2=d.scm_site_id
					and a.line_id = d.line_id
					and a.yyyymmdd= d.yyyymmdd
			LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
					and a.SCM_SITE_ID2=e.scm_site_id
					and a.line_id = e.line_id
					and a.item_id = e.item_id
					and a.yyyymmdd= e.yyyymmdd
			WHERE 1=1
			AND a.line_id			  <> '*'
			AND a.measure              = upper('PROD_PLAN_AMEND')
			GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id, a.yyyymmdd,;
						d.working_time
						, a.origin_division_id
			UNION
			-- LINE_TOTAL_LOAD_ENGINE 추가
			SELECT distinct
						a.division_id
					,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
					,p_plan_type AS PLAN_TYPE
					,p_seq AS PLAN_SEQ
					,a.operation_group
					,a.scm_site_id	,'-' as item_id	,a.operation_id	,a.line_id
					,'LINE_TOTAL_LOAD_ENGINE' AS measure
					, CASE WHEN d.working_time <= 0.0 THEN 0
							ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						END AS qty
					, NVL(round(sum(a.qty * (e.tact_time/60)),0), 0) AS CAPA_TACT
					--, NVL( d.working_time ,0 ) AS working_time
					,p_from_yyyymmdd AS from_yyyymmdd
					,'D_' || a.yyyymmdd AS yyyymmdd
					--,c.basis_yyyymm AS yyyymm
					--,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
					,NVL(NULLIF(a.origin_division_id, NULL),'-') origin_division_id
					,'-' electrode_type
					,'L' CELL_TYPE_GROUP_CODE
					--,'W_'+c.basis_yyyymm + c.iso_week AS week_yyyymmdd
					--,'M_'+c.basis_yyyymm  AS month_yyyymmdd
			FROM GT_SCP0_DynamicPivot_SCP0013_t a
			--JOIN scm_sys_calendar_m c   ON a.yyyymmdd = c.basis_yyyymmdd
			LEFT OUTER JOIN scp_anl_working_time d   ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
					and a.SCM_SITE_ID2 = d.scm_site_id
					and a.line_id = d.line_id
					and a.yyyymmdd= d.yyyymmdd
			LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
					and a.SCM_SITE_ID2 = e.scm_site_id
					and a.line_id = e.line_id
					and a.item_id = e.item_id
					and a.yyyymmdd= e.yyyymmdd
			WHERE 1=1
			AND a.line_id			  <> '*'
			AND a.measure              = upper('PROD_PLAN_ENGINE')
			GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id, a.yyyymmdd ,;
						d.working_time
						, origin_division_id
		) A;

		DBMS_OUTPUT.PUT_LINE('3. Line Load Base.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		-- 2022.08.31 start
		-- Isuzu Item
		  /* TODO:GTT:GT_SCP0_ISUZU_SCP0013-->GT_SCP0_ISUZU_SCP0013 */
		  INSERT INTO GT_SCP0_ISUZU_SCP0013
		  SELECT A.ITEM_ID
		  FROM SCM_MST_FINAL_ITEM_V A


		  INNER JOIN SCP_MST_FINAL_ITEM_V B  ON A.ITEM_ID = B.ITEM_ID
		  WHERE A.IS_YN = 'Y';
		-- 2022.08.31 end


		/* 2022.10.31
		--생산실적 추출
		/* TODO:GTT:GT_SCP0_DynamicPivot_SCP0013_P-->GT_SCP0_DynamicPivot_SCP0013_P */
		INSERT INTO GT_SCP0_DynamicPivot_SCP0013_P
		SELECT *
		    FROM(
				   SELECT  distinct
						 (CASE WHEN p_division_id='EE' THEN 'EE' WHEN p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END) AS division_id
		   				,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
						,p_plan_type AS PLAN_TYPE
						,p_seq AS PLAN_SEQ
   						,r.scp_operation_group as operation_group
   						,r.scm_site_id	,r.item_id	,r.operation_id
						,(case when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTR(r.item_id,2,1) = 'T' or SUBSTR(r.item_id,2,1) = 'I' or SUBSTR(r.item_id,2,1) = 'D') then '-' else r.LINE_ID end) line_id
   						,'PROD_PLAN_ENGINE' AS measure
   						,r.actual_good_qty AS qty
						,p_from_yyyymmdd AS from_yyyymmdd
						,'D_' || TO_CHAR(r.plan_date, 'YYYYMMDD')  AS yyyymmdd
						--,c.basis_yyyymm AS yyyymm
						--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
						,r.division_id as origin_division_id
						,NVL(NULLIF(r.electrode_type, NULL),'-') electrode_type
						,b.CELL_TYPE_GROUP_CODE
						,'' AS LINE_ASSIGN_KEY
				   --FROM SCM_DNM_product_result_v r
				   --FROM SCM_DNM_product_result_v_khj79 r
				   FROM SCM_DNM_PRODUCT_RESULT_V r
				   --JOIN scm_sys_calendar_m c   on TO_CHAR(r.plan_date, 'YYYYMMDD')  = c.basis_yyyymmdd
				   LEFT OUTER JOIN SCP_MST_FINAL_ITEM b   on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
				   WHERE 1=1
				     AND r.plan_date          >= TO_DATE(v_from_result)
				     AND r.plan_date          < TO_DATE(v_to_result)
				     AND ( p_division_id IN ('EE','EE_UC') OR r.division_id = p_division_id )
				     AND r.scp_operation_group =  p_operation_group
					 AND ( SUBSTR(r.operation_id, 1, 5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
														SELECT segment1 AS operation_id
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL
														WHERE lookup_type = 'SCP_PLAN_OPERATION'
															AND SEGMENT1 <> 'F6000'
															AND valid_yn    = 'Y')
							-- 2022.08.31 start
							OR (;
                             SUBSTR(r.operation_id, 1, 5) = 'P5000'
                             AND EXISTS (
                                         SELECT 1
                                         FROM GT_SCP0_ISUZU_SCP0013 A
                                         WHERE  A.ITEM_ID = r.ITEM_ID
                                        )
                            )
							-- 2022.08.31 end

							OR r.operation_id IN (--외주PACKER의 업체코드
														SELECT plant_id  AS operation_id
														FROM SCM_MST_SITE
														WHERE 1=1
														AND ( p_division_id IN ('EE','EE_UC') OR division_id = p_division_id )
														AND site_type   = 'PLANT'
														AND osp_yn      = 'Y'
														AND valid_yn    = 'Y'
														) )
				     AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR r.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
					 AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR r.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) )
			) a;
			where (( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) );
		*/



	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCP0_DynamicPivot_SCP0013_P';

	--생산실적 추출
	IF v_from_yyyymmdd > v_from_result THEN


		INSERT INTo GT_SCP0_DynamicPivot_SCP0013_P
		(
			 division_id
			,plan_start_yyyymmdd
			,PLAN_TYPE
			,PLAN_SEQ
			,operation_group
			,scm_site_id
			,item_id
			,operation_id
			,line_id
			,measure
			,qty
			,from_yyyymmdd
			,yyyymmdd
			,origin_division_id
			,electrode_type
			,CELL_TYPE_GROUP_CODE
			,LINE_ASSIGN_KEY
		)
		SELECT *
		    FROM(

				   SELECT
				         --distinct
						 --(CASE WHEN p_division_id='EE' THEN 'EE' WHEN p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END) AS division_id
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위해 기존로직 주석처리
						 /*
						 (CASE
						  WHEN p_division_id='EE' THEN 'EE'
						  WHEN p_division_id='EE_UC' THEN 'EE_UC'
						  WHEN p_division_id='EE_HM' THEN 'EE_HM'
						  ELSE r.division_id
						  END) AS division_id --div_commonization
						*/
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위한 로직 추가.
						 p_division_id AS division_id
		   				,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
						,p_plan_type AS PLAN_TYPE
						,p_seq AS PLAN_SEQ
   						,r.scp_operation_group as operation_group
   						,r.scm_site_id	,r.item_id	,r.operation_id
						,(case
						when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTR(r.item_id,2,1) = 'T' or SUBSTR(r.item_id,2,1) = 'I' or SUBSTR(r.item_id,2,1) = 'D')
						then '-'
						else r.LINE_ID
						END IF;
						) line_id;
   						,'PROD_PLAN_ENGINE' AS measure
   						,NVL(sum(r.actual_good_qty),0) AS qty
						,p_from_yyyymmdd AS from_yyyymmdd
						,'D_' || TO_CHAR(r.plan_date, 'YYYYMMDD')  AS yyyymmdd
						--,c.basis_yyyymm AS yyyymm
						--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
						,r.division_id as origin_division_id
						,NVL(NULLIF(r.electrode_type, NULL),'-') electrode_type
						,b.CELL_TYPE_GROUP_CODE
						,'' AS LINE_ASSIGN_KEY
				   --FROM SCM_DNM_product_result_v r
				   --FROM SCM_DNM_product_result_v_khj79 r
				   FROM SCM_DNM_PRODUCT_RESULT_V r
				   --JOIN scm_sys_calendar_m c   on TO_CHAR(r.plan_date, 'YYYYMMDD')  = c.basis_yyyymmdd
				   LEFT OUTER JOIN SCP_MST_FINAL_ITEM b   on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
				   WHERE 1=1
				     AND r.plan_date          >= TO_DATE(v_from_result)
				     AND r.plan_date          < TO_DATE(v_to_result)
				     --AND ( p_division_id IN ('EE','EE_UC') OR r.division_id = p_division_id )
					 AND ( p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) OR r.division_id = p_division_id ) --div_commonization
				     AND r.company_id IN (
														SELECT DISTINCT company_id  AS operation_id
														FROM SCM_MST_SITE
														WHERE 1=1
														AND ( p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) OR division_id = p_division_id ) --div_commonization
														AND site_type   = 'PLANT'
														AND valid_yn    = 'Y'
														)
				     AND r.scp_operation_group =  p_operation_group
					 AND ( SUBSTR(r.operation_id, 1, 5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
														SELECT segment1 AS operation_id
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL
														WHERE lookup_type = 'SCP_PLAN_OPERATION'
															AND SEGMENT1 <> 'F6000'
															AND valid_yn    = 'Y')
							-- 2022.08.31 start
							OR (;
                             SUBSTR(r.operation_id, 1, 5) = 'P5000'
                             AND EXISTS (
                                         SELECT 1
                                         FROM GT_SCP0_ISUZU_SCP0013 A
                                         WHERE  A.ITEM_ID = r.ITEM_ID
                                        )
                            )
							-- 2022.08.31 end

							OR r.operation_id IN (--외주PACKER의 업체코드
														SELECT plant_id  AS operation_id
														FROM SCM_MST_SITE
														WHERE 1=1
														--AND ( p_division_id IN ('EE','EE_UC') OR division_id = p_division_id )
														AND ( p_division_id IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV('EE')) OR division_id = p_division_id ) --div_commonization
														AND site_type   = 'PLANT'
														AND osp_yn      = 'Y'
														AND valid_yn    = 'Y'
														) )
				     AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR r.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
					 AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR r.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) )
				group by
				         --(CASE WHEN p_division_id='EE' THEN 'EE' WHEN p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END)
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위해 기존로직 주석처리
						 /*
						 (CASE
						  WHEN p_division_id='EE' THEN 'EE'
						  WHEN p_division_id='EE_UC' THEN 'EE_UC'
						  WHEN p_division_id='EE_HM' THEN 'EE_HM'
						  ELSE r.division_id
						  END) --div_commonization
						  */
   						 r.scp_operation_group
   						,r.scm_site_id
						,r.item_id
						,r.operation_id
						,(case when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTR(r.item_id,2,1) = 'T' or SUBSTR(r.item_id,2,1) = 'I' or SUBSTR(r.item_id,2,1) = 'D') then '-' else r.LINE_ID end)
						,'D_' || TO_CHAR(r.plan_date, 'YYYYMMDD')
						,r.division_id
						,NVL(NULLIF(r.electrode_type, NULL),'-')
						,b.CELL_TYPE_GROUP_CODE


			) a;
			WHERE  (( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
			  AND A.origin_division_id in
	                (
					select division_id
					from SCM_MST_DIVISION
					where attribute4 in (
									select attribute4
									from SCM_MST_DIVISION
									where division_id = p_division_id
									)
					and attribute3 <> 'EE'
	               ) --div_commonization


		END IF;


		DBMS_OUTPUT.PUT_LINE('4. Prod Performance.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		--생산계획 추출
		/* TODO:GTT:GT_SCP0_DynamicPivot_SCP0013_p-->GT_SCP0_DynamicPivot_SCP0013_p */
		INSERT INTO GT_SCP0_DynamicPivot_SCP0013_p
		SELECT distinct
			a.division_id
			,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,p_plan_type AS PLAN_TYPE
			,p_seq AS PLAN_SEQ
			,a.operation_group
			,a.scm_site_id,a.item_id ,a.operation_id,a.line_id
			,a.measure
			,a.qty
			,p_from_yyyymmdd AS from_yyyymmdd
			,'D_' || a.yyyymmdd AS yyyymmdd
			--,c.basis_yyyymm AS yyyymm
			--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
			,NVL(NULLIF(a.origin_division_id, NULL),'-') origin_division_id
			,NVL(NULLIF(a.electrode_type, NULL),'-') electrode_type
			,CELL_TYPE_GROUP_CODE
			,'' AS LINE_ASSIGN_KEY
		FROM GT_SCP0_DynamicPivot_SCP0013_t a
		JOIN scm_mst_sheet_measure b   on a.measure = b.column_name
		--JOIN scm_sys_calendar_m c   on a.yyyymmdd = c.basis_yyyymmdd
		WHERE 1=1
		AND b.program_id           = p_program_id
		AND b.sheet_name           = p_sheet_name
		AND b.valid_yn		       = 'Y'
		AND a.measure			   in ( 'PROD_PLAN_AMEND' , 'PROD_PLAN_ENGINE' ,'ELEC_RTF', 'PROD_PLAN_ENGINE_STD_JR')
		AND ( p_operation_group = 'A'  OR NVL(B.ATTRIBUTE1, NULL) <>'A')
		AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) );

		DBMS_OUTPUT.PUT_LINE('4.1 Prod Plna.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/

	 /* TODO:GTT:GT_SCP0_DynamicPivot_SCP0013-->GT_SCP0_DynamicPivot_SCP0013 */
	 INSERT INTO GT_SCP0_DynamicPivot_SCP0013
	 SELECT
			 t.division_id || t.scm_site_id || t.plan_start_yyyymmdd || plan_type || TO_CHAR(plan_seq) as cp_key
			,t.division_id  ||  t.operation_group ||  t.scm_site_id ||  t.item_id || t.line_id  ||  t.operation_id  ||  t.origin_division_id  ||  t.electrode_type as fix_key
			,t.division_id
			,t.plan_start_yyyymmdd
			,t.plan_type
			,t.plan_seq
-- PJ20257329 2025.09.01 변경전 --2021.10.25 Start kwon
-- PJ20257329 2025.09.01 변경전 			,(SELECTIIF(BOM.PARENT_ITEM_ID='*',BOM.MODEL_ID,BOM.PARENT_ITEM_ID) FROM SCM_MST_BOM_SN BOM
-- PJ20257329 2025.09.01 변경전 		       WHERE BOM.CHILD_ITEM_ID= t.ITEM_ID) AS PARENT_ITEM_ID
-- PJ20257329 2025.09.01 변경전 --2021.10.25 End
		-- ---------------------------------------------------------------------------------------------------------
 		-- Start  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
		--			UI에서 많은 양의 데이터를 조회하지 않기 때문에 기존 스칼라 서브 쿼리 형태 유지
		-- ---------------------------------------------------------------------------------------------------------
			,(SELECT /*__FETCH_1__*/IIF(BOM.PARENT_ITEM_ID='*' OR CM.SCP_EXC_YN = 'Y'
							  ,BOM.MODEL_ID
							  ,BOM.PARENT_ITEM_ID)
				FROM SCM_MST_BOM_SN BOM
					 INNER JOIN SCM_MST_ITEM_SN MM 	-- model
							 ON MM.COMPANY_ID	= BOM.COMPANY_ID
							AND MM.DIVISION_ID	= BOM.DIVISION_ID
							AND MM.SITE_ID		= BOM.SITE_ID
							AND MM.ITEM_ID		= BOM.MODEL_ID
					 LEFT JOIN SCM_MST_ITEM_SN IM 	-- parent가 '*'인 경우가 있음
							 ON IM.COMPANY_ID	= BOM.COMPANY_ID
							AND IM.DIVISION_ID	= BOM.DIVISION_ID
							AND IM.SITE_ID		= BOM.SITE_ID
							AND IM.ITEM_ID		= BOM.PARENT_ITEM_ID
					 LEFT  JOIN SCM_MST_ITEM_CLASS_M CM			-- parent item class (SCP Exclude class 여부 참조)
						     ON CM.CLASS_ID		= IM.ITEM_CLASS
 		       WHERE BOM.CHILD_ITEM_ID= T.ITEM_ID
			   ORDER BY CASE WHEN MM.SCP_OPERATION_GROUP = 'E' THEN 1;
							 WHEN MM.SCP_OPERATION_GROUP = 'A' THEN 2
							 ELSE 9 END )
			  AS PARENT_ITEM_ID
		-- ---------------------------------------------------------------------------------------------------------
		-- End  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
		-- ---------------------------------------------------------------------------------------------------------
			,t.operation_group
			,t.scm_site_id
			,t.operation_id
			,t.line_id
			,t.item_id
			,t.measure
			,m.column_label_name as measure_name
			,NVL(n.sort_order_no,m.sort_order_no ) AS sort_order_no
			,t.qty
			,t.from_yyyymmdd
			,t.yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,RIGHT(c.basis_yyyymm,4) || c.iso_week AS iso_week
			,t.origin_division_id
			,t.electrode_type
			,t.CELL_TYPE_GROUP_CODE
			,CASE X.ITEM_UOM WHEN 'EA' THEN CASE t.measure WHEN 'PROD_PLAN_AMEND' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE_CELL_QTY' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE_STD_JR' THEN 'M'
															ELSE '' END
							 WHEN 'M' THEN CASE t.measure WHEN 'PROD_PLAN_AMEND' THEN 'M'
							 								WHEN 'PROD_PLAN_ENGINE' THEN 'M'
							 								WHEN 'PROD_PLAN_ENGINE_CELL_QTY' THEN 'EA'
							 								WHEN 'PROD_PLAN_ENGINE_STD_JR' THEN 'M'
							 								ELSE '' END
							 ELSE X.ITEM_UOM END UNIT

	 FROM (
			 --생산계획
FETCH FIRST 1 ROWS ONLY
		  SELECT division_id
				,plan_start_yyyymmdd
				,PLAN_TYPE
				,PLAN_SEQ
				,operation_group
				,scm_site_id
				,item_id
				,operation_id
				,line_id
				,measure
				,qty
				,from_yyyymmdd
				,yyyymmdd
				--,yyyymm
				--,iso_week
				,origin_division_id
				,electrode_type
				,CELL_TYPE_GROUP_CODE
				,LINE_ASSIGN_KEY
			FROM GT_SCP0_DynamicPivot_SCP0013_p

		   UNION
		   --CELL 환산수량
		   SELECT DISTINCT
				 a.division_id
				,p_plan_start_yyyymmdd AS plan_start_yyyymmdd
				,p_plan_type AS PLAN_TYPE
				,p_seq AS PLAN_SEQ
				,a.operation_group
				,a.scm_site_id,a.item_id ,a.operation_id,a.line_id
				,'PROD_PLAN_ENGINE_CELL_QTY' AS measure
				,a.CELL_QTY as qty
				,p_from_yyyymmdd AS from_yyyymmdd
				,'D_' || a.yyyymmdd AS yyyymmdd
				--,c.basis_yyyymm AS yyyymm
				--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
				,NVL(NULLIF(a.origin_division_id, NULL),'-') origin_division_id
				,NVL(NULLIF(a.electrode_type, NULL),'-') electrode_type
				,CELL_TYPE_GROUP_CODE
				,'' AS LINE_ASSIGN_KEY
			FROM GT_SCP0_DynamicPivot_SCP0013_t a
			JOIN scm_mst_sheet_measure b   on a.measure = b.column_name
			--JOIN scm_sys_calendar_m c   on a.yyyymmdd = c.basis_yyyymmdd
			WHERE 1=1
			AND b.program_id           = p_program_id
			AND b.sheet_name           = p_sheet_name
			AND b.valid_yn		       = 'Y'
			AND a.measure			   = 'PROD_PLAN_ENGINE'
			AND ( p_operation_group = 'A'  OR NVL(B.ATTRIBUTE1, NULL) <>'A')
			AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) )
			AND p_operation_group = 'E'
		   UNION
		   -- 생산 실적 (PROD_PLAN_ENGINE)
		   SELECT division_id
				  , plan_start_yyyymmdd
				  , PLAN_TYPE
				  , PLAN_SEQ
				  , operation_group
				  , scm_site_id
				  , item_id
				  , operation_id
				  , line_id
				  , 'PROD_PLAN_ENGINE' AS measure
				  , qty
				  , from_yyyymmdd
				  , yyyymmdd
				  --, yyyymm
				  --, iso_week
				  , origin_division_id
				  , electrode_type
				  , CELL_TYPE_GROUP_CODE
				  , LINE_ASSIGN_KEY
		   FROM GT_SCP0_DynamicPivot_SCP0013_P
		   UNION
		   -- 생산 실적 (PROD_PLAN_ENGINE_CELL_QTY) 셀 환산수량
		   SELECT a.division_id
				  , a.plan_start_yyyymmdd
				  , a.PLAN_TYPE
				  , a.PLAN_SEQ
				  , a.operation_group
				  , a.scm_site_id
				  , a.item_id
				  , a.operation_id
				  , a.line_id
				  , 'PROD_PLAN_ENGINE_CELL_QTY' AS measure
				  --, a.qty
				  ,NVL(a.qty,0.00)
                    * ( SELECT NVL( MIN(Y.CONVERT_QTY_CELL),1)
                          FROM SCP_MST_FINAL_ITEM Y
                         WHERE Y.ITEM_ID    = a.item_id
                           AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS qty
				  , a.from_yyyymmdd
				  , a.yyyymmdd
				  --, a.yyyymm
				  --, a.iso_week
				  , a.origin_division_id
				  , a.electrode_type
				  , a.CELL_TYPE_GROUP_CODE
				  , a.LINE_ASSIGN_KEY
		   FROM GT_SCP0_DynamicPivot_SCP0013_P a
		   WHERE p_operation_group = 'E'
		   UNION
		   -- 생산 실적 (PROD_PLAN_AMEND)
		   SELECT a.division_id
				  , a.plan_start_yyyymmdd
				  , a.PLAN_TYPE
				  , a.PLAN_SEQ
				  , a.operation_group
				  , a.scm_site_id
				  , a.item_id
				  , a.operation_id
				  , a.line_id
				  , 'PROD_PLAN_AMEND' AS measure
				  , a.qty
				  , a.from_yyyymmdd
				  , a.yyyymmdd
				  --, a.yyyymm
				  --, a.iso_week
				  , a.origin_division_id
				  , a.electrode_type
				  , a.CELL_TYPE_GROUP_CODE
				  , a.LINE_ASSIGN_KEY
		   FROM GT_SCP0_DynamicPivot_SCP0013_P a

			UNION

			SELECT a.division_id
					,a.plan_start_yyyymmdd
					,a.PLAN_TYPE
					,a.PLAN_SEQ
					,a.operation_group
					,a.scm_site_id
					,a.item_id
					,a.operation_id
					,a.line_id
					,a.measure
					,a.qty
					,a.from_yyyymmdd
					,a.yyyymmdd
					--,a.yyyymm
					--,a.iso_week
					,a.origin_division_id
					,a.electrode_type
					,a.CELL_TYPE_GROUP_CODE
					,a.scm_site_id || a.line_id || a.operation_id AS LINE_ASSIGN_KEY
			FROM GT_SCP0_DynamicPivot_SCP0013_l a
			--join (select distinct line_id, scm_site_id, month_working_time , operation_id, YYYYMMDD
			--			from GT_SCP0_DynamicPivot_SCP0013_w   ) b
			--		on a.yyyymmdd = b.yyyymmdd
			--		and a.line_id = b.line_id
			--		and	a.SCM_SITE_ID = b.SCM_SITE_ID
			--		and a.operation_id = b.operation_id

		) T;
		JOIN scm_sys_calendar_m c   on RIGHT(T.yyyymmdd, 8) = c.basis_yyyymmdd
		LEFT JOIN scm_mst_sheet_measure m   on t.measure = m.column_name
		LEFT OUTER JOIN	scm_mst_titleset_user n   ON n.program_id  = m.program_id
										   AND n.sheet_name  = m.sheet_name
										   AND n.column_name = m.column_name
										   AND n.user_id     = p_user_id
		--LEFT JOIN scm_mst_item_sn X  ON  t.division_id = x.division_id AND T.ITEM_ID = X.ITEM_ID AND X.COMPANY_ID = 'C100'
          LEFT JOIN (SELECT DISTINCT ITEM_ID
          			      , ITEM_UOM
          			      , MIN(DIVISION_ID) AS DIVISION_ID
          			   FROM SCM_MST_ITEM_SN
          			  WHERE 1=1 --COMPANY_ID = 'C100'
          			  GROUP BY ITEM_ID, ITEM_UOM) X ON T.ITEM_ID = X.ITEM_ID
		WHERE 1=1
		AND m.valid_yn		       = 'Y'
		AND m.program_id           = p_program_id
		AND m.sheet_name           = p_sheet_name
		AND ( p_operation_group = 'A'  OR NVL(m.ATTRIBUTE1, NULL) <>'A')
		AND ( v_cnt_usr_measure = 0
					OR EXISTS (SELECT 1
								 FROM scm_mst_titleset_user
								WHERE program_id  = p_program_id
								  AND sheet_name  = p_sheet_name
								  AND user_id     = p_user_id
								  AND column_name = m.column_name)
				  )
        AND ( ( p_line_id IS NULL OR p_line_id IS NULL ) OR t.line_id IN (SELECT token FROM TABLE(fn_string_split(p_line_id,','))) )



		AND (
				( v_item_input ='N' )
				OR t.scm_site_id || t.line_id IN (SELECT scm_site_id || line_id FROM GT_SCP0_DynamicPivot_SCP0013_P)

				OR ( t.LINE_ASSIGN_KEY IN (SELECT LINE_ASSIGN_KEY FROM GT_SCP0_DynamicPivot_SCP0013_P)
						AND t.measure in ('LINE_TOTAL_LOAD_ENGINE','LINE_TOTAL_LOAD_AMEND')
				   )
			)


		DBMS_OUTPUT.PUT_LINE('5. OutDataSet.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN



		v_mQuery := NULL;
		v_mQry_field := NULL;





		SELECT		 v_mQry_field  ||  ',
    v_mQuery+'
  INTO v_mQry_field, v_mQuery
		FROM (

				SELECT 'W_' || a.basis_yyyymm  ||  a.iso_week AS yyyymmdd
					, a.basis_start_date  ||  TO_CHAR(21) AS sort_order_no
					, TO_CHAR(COUNT(1)) AS CNT
				FROM scm_sys_calendar_m a
				WHERE a.basis_yyyymmdd  BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
				AND (p_bucket= 'DAILY' OR p_bucket = 'WEEKLY')
				GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

				UNION ALL

				SELECT 'M_' || a.basis_yyyymm  AS yyyymmdd
						,MIN(a.basis_start_date)  ||  TO_CHAR('01') AS sort_order_no
						,TO_CHAR(COUNT(1)) AS CNT
				FROM scm_sys_calendar_m a
				WHERE a.basis_yyyymmdd  BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name

				UNION ALL

				SELECT 'D_' || a.basis_yyyymmdd   AS yyyymmdd
						, a.basis_yyyymmdd  ||  TO_CHAR(31) AS sort_order_no
						, TO_CHAR(COUNT(1)) AS CNT
				FROM scm_sys_calendar_m a
				WHERE a.basis_yyyymmdd  BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
				AND p_bucket= 'DAILY'
				GROUP BY a.basis_yyyymmdd
		) AS A
		ORDER BY sort_order_no  ;


        --DEBUG_LOG v_mQuery, 'T';RETURN; --chaan

		IF( LENGTH(v_mQuery)>0) THEN
			v_mQuery := SUBSTR(v_mQuery, 1, LENGTH(v_mQuery) - 1);


			SELECT NVL(v_arr_cell_type_gr  ||  ','''  ||  token  || '''', '''' || token || '''')
  INTO v_arr_cell_type_gr
			FROM TABLE(fn_string_split(p_cell_type_gr,','));

			IF p_cell_type_gr is not null or p_cell_type_gr IS NOT NULL THEN
					v_arr_cell_type_gr := v_arr_cell_type_gr  ||  ',''L''';
				END IF;

			-- Extra Spec 조회조건 추가 2025-04-02 mrchois

			SELECT NVL(v_arr_extra_spec  ||  ', '  ||  'N'''  ||  token  || '''', 'N''' || token || '''')
  INTO v_arr_extra_spec
			FROM TABLE(fn_string_split(p_extra_spec,','));

			/* TODO:GTT:GT_SCP0_LookUp_SCP0013-->GT_SCP0_LookUp_SCP0013 */
			INSERT INTO GT_SCP0_LookUp_SCP0013
			SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2
			 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE 1 = 1
			AND LOOKUP_TYPE IN ('CELL_TYPE_GROUP_CODE','OPERATION_GROUP')


			SELECT v_arr_model_id	= NVL(v_arr_model_id	 ||  ','''  ||  token  || '''', '''' || token || '''') FROM TABLE(fn_string_split(p_model_id,','))


			-- -------------------------------------------------------------------
			-- RESULT 1
			-- -------------------------------------------------------------------
			v_mEXEC := N';
	            /* TODO:GTT:GT_SCP0_SCP0013_RAW_TEMP-->GT_SCP0_SCP0013_RAW_TEMP */
	            INSERT INTO GT_SCP0_SCP0013_RAW_TEMP
	            SELECT	  A.CP_KEY,FIX_KEY
						, A.DIVISION_ID
						, A.OPERATION_GROUP
						, A.SCM_SITE_ID
						, A.LINE_ID
						, A.PARENT_ITEM_ID
						, FN_GET_ITEM_PROD_OP(A.DIVISION_ID,A.OPERATION_GROUP, A.ITEM_ID) AS MODEL_ID
						, A.ITEM_ID
						, A.MEASURE
						, A.MEASURE_NAME
						, A.OPERATION_ID,A.PLAN_TYPE, A.PLAN_SEQ, A.PLAN_START_YYYYMMDD,A.FROM_YYYYMMDD,A.SORT_ORDER_NO
						, A.ORIGIN_DIVISION_ID
						, A.ELECTRODE_TYPE
						, A.CELL_TYPE_GROUP_CODE
						, A.UNIT'
						 ||  v_mQuery  ||  '
				FROM GT_SCP0_DynamicPivot_SCP0013 A
				WHERE	1=1
					AND A.ORIGIN_DIVISION_ID NOT IN (SELECT DIVISION_ID FROM FN_GET_DIVISION_DIV(''EE''))	--div_commonization
				GROUP BY	  A.CP_KEY
							, A.FIX_KEY
							, A.DIVISION_ID
							, A.OPERATION_GROUP
							, A.SCM_SITE_ID
							, A.LINE_ID
							, A.PARENT_ITEM_ID
							, A.ITEM_ID
							, A.MEASURE
							, A.MEASURE_NAME
							, A.OPERATION_ID
							, A.PLAN_TYPE
							, A.PLAN_SEQ
							, A.PLAN_START_YYYYMMDD
							, A.FROM_YYYYMMDD
							, A.SORT_ORDER_NO
							, A.ORIGIN_DIVISION_ID
							, A.ELECTRODE_TYPE
							, A.CELL_TYPE_GROUP_CODE
							, A.UNIT;


	            /* TODO:GTT:GT_SCP0_SCP0013_RAW-->GT_SCP0_SCP0013_RAW */
	            INSERT INTO GT_SCP0_SCP0013_RAW
	            SELECT	  (
						    SELECTX.SITE_DESCRIPTION
						    FROM	SCM_MST_SITE X
						    WHERE	1=1
							    AND X.SCM_SITE_ID = A.SCM_SITE_ID
						    ) AS SCM_SITE_DESCRIPTION
					    , (
FETCH FIRST 1 ROWS ONLY
						    SELECTDIVISION_NAME
						    FROM	SCM_MST_DIVISION
						    WHERE	1=1
							    AND DIVISION_ID = A.DIVISION_ID
						    ) AS DIVISION_NAME
					    , (
FETCH FIRST 1 ROWS ONLY
						    SELECTNVL(NICK_NAME, '''')
						    FROM	SCM_MST_ITEM_SN
						    WHERE	1=1
							    AND ITEM_ID = A.ITEM_ID
							    AND NICK_NAME IS NOT NULL
						    ) AS NICK_NAME
					    , (
FETCH FIRST 1 ROWS ONLY
						    SELECTCELL_ITEM_ID
						    FROM	SCP_MST_FINAL_ITEM X
						    WHERE	1=1
							    AND X.DIVISION_ID = A.ORIGIN_DIVISION_ID
							    AND X.ITEM_ID = A.ITEM_ID
						    ) AS CELL_ID
					    , (
FETCH FIRST 1 ROWS ONLY
						    SELECTNVL(NULLIF(SCP_EXTRA_SPEC,''''),''-'')
						    FROM	SCM_MST_ITEM_SN X
						    WHERE	1=1
							    AND X.DIVISION_ID = ''40''
							    AND X.DIVISION_ID = A.DIVISION_ID
							    AND X.ITEM_ID = A.ITEM_ID
						    )	AS EXTRA_SPEC
					    , A.*
			    FROM GT_SCP0_SCP0013_RAW_TEMP A
FETCH FIRST 1 ROWS ONLY;


				SELECT	  NVL(B.SEGMENT2,''-'') AS CELL_TYPE_GROUP_CODE
						, NVL(C.SEGMENT2,''-'') OPERATION_GROUP_NAME
						, T.*
				FROM GT_SCP0_SCP0013_RAW T
						LEFT OUTER JOIN GT_SCP0_LookUp_SCP0013 B ON
								B.LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE''
							AND B.SEGMENT1 = T.CELL_TYPE_GROUP_CODE
						LEFT OUTER JOIN GT_SCP0_LookUp_SCP0013 C ON
								C.LOOKUP_TYPE = ''OPERATION_GROUP''
							AND C.SEGMENT1 = T.OPERATION_GROUP
				WHERE	1=1';


			IF NOT(p_cell_type_gr IS NULL OR  p_cell_type_gr    IS NULL) THEN
				v_mEXEC := v_mEXEC  ||  N'
						AND (NVL(T.CELL_TYPE_GROUP_CODE,''L'')  IN (' || v_arr_cell_type_gr || '))';
			END IF;

			IF (NOT(p_model_id IS NULL OR p_model_id IS NULL)) THEN
				v_mEXEC := v_mEXEC  ||  N'
						AND MODEL_ID IN (' || v_arr_model_id || ')';
			END IF;

			-- Extra Spec 조회조건 추가 2025-04-02 mrchois
			IF (NOT(p_extra_spec IS NULL OR p_extra_spec IS NULL)) THEN
				v_mEXEC := v_mEXEC  ||  N'
						AND T.EXTRA_SPEC IN (' || v_arr_extra_spec || ')';
			END IF;


			v_mEXEC := v_mEXEC  ||  N'
					ORDER BY	  T.DIVISION_ID
								, T.OPERATION_GROUP
								, T.SCM_SITE_ID
								, T.LINE_ID
								, T.OPERATION_ID
								, T.PARENT_ITEM_ID DESC
								, T.ITEM_ID DESC
								, T.SORT_ORDER_NO ASC';

--TESTING : OK
--debug_log v_mEXEC, 'T';return;

            EXEC (v_mEXEC);


			DBMS_OUTPUT.PUT_LINE('6. OutDataSet Pivot.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			IF p_bucket= 'DAILY' THEN

				-- -------------------------------------------------------------------
				-- RESULT 2, DAILY
				-- -------------------------------------------------------------------
			SELECT   division_id
					,operation_group
					,scm_site_id
					,item_id
					,line_id
					,operation_id
					--,division_id + operation_group + scm_site_id + item_id + line_id + operation_id + NVL(NULLIF(origin_division_id, NULL),'-') + NVL(NULLIF(electrode_type, NULL),'-') as fix_key
					--,'D_'+yyyymmdd AS yyyymmdd
					--,'W_'+b.basis_yyyymm + iso_week AS	yyyymm_week
					--,NVL(NULLIF(origin_division_id, NULL),'-') origin_division_id
					--,NVL(NULLIF(electrode_type, NULL),'-') electrode_type

					,'' as fix_key
					,yyyymmdd
					,b.basis_yyyymm as basis_yyyymm
					,iso_week
					,NVL(NULLIF(origin_division_id, NULL),'-') origin_division_id
					,NVL(NULLIF(electrode_type, NULL),'-') electrode_type

				FROM SCP_ANL_PRODUCTION_PLAN_FIX A      --WITH(NOLOCK INDEX(IX01_SCP_ANL_PRODUCTION_PLAN_FIX))
				    INNER JOIN scm_sys_calendar_m B   ON A.yyyymmdd =B.BASIS_YYYYMMDD
				WHERE 1=1
				AND a.yyyymmdd			  >= p_from_yyyymmdd
				AND a.yyyymmdd			  <= p_to_yyyymmdd
				AND a.division_id	       = p_division_id
				AND a.operation_group      = p_operation_group
				AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
				AND ( ( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
				AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) );
			   --ORDER BY fix_key,yyyymmdd



			ELSE

				-- -------------------------------------------------------------------
				-- RESULT 2, NO DAILY
				-- -------------------------------------------------------------------
				SELECT DISTINCT division_id
					,operation_group
					,scm_site_id
					,item_id
					,line_id
					,operation_id
					--,division_id + operation_group + scm_site_id + item_id + line_id + operation_id + NVL(NULLIF(origin_division_id, NULL),'-') + NVL(NULLIF(electrode_type, NULL),'-') as fix_key
					--,'D_'+yyyymmdd AS yyyymmdd
					--,'W_'+b.basis_yyyymm + iso_week AS	yyyymm_week
					--,NVL(NULLIF(origin_division_id, NULL),'-') origin_division_id
					--,NVL(NULLIF(electrode_type, NULL),'-') electrode_type

					,'' as fix_key
					--,yyyymmdd
					,b.basis_yyyymm as basis_yyyymm
					,iso_week
					,NVL(NULLIF(origin_division_id, NULL),'-') origin_division_id
					,NVL(NULLIF(electrode_type, NULL),'-') electrode_type

				FROM SCP_ANL_PRODUCTION_PLAN_FIX A      --WITH(NOLOCK INDEX(IX01_SCP_ANL_PRODUCTION_PLAN_FIX))
				    INNER JOIN scm_sys_calendar_m B   ON A.yyyymmdd =B.BASIS_YYYYMMDD
				WHERE 1=1
				AND a.yyyymmdd			  >= p_from_yyyymmdd
				AND a.yyyymmdd			  <= p_to_yyyymmdd
				AND a.division_id	       = p_division_id
				AND a.operation_group      = p_operation_group
				AND ( ( p_scm_site_id IS NULL OR     p_scm_site_id     IS NULL ) OR a.scm_site_id     IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
				AND ( ( p_line_id IS NULL OR         p_line_id         IS NULL ) OR a.line_id         IN (SELECT token FROM TABLE(fn_string_split(p_line_id    ,','))) )
				AND ( ( p_electrode_type IS NULL OR  p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM TABLE(fn_string_split(p_electrode_type,','))) );
			   --ORDER BY fix_key,yyyymmdd
			END IF;


			DBMS_OUTPUT.PUT_LINE('7. Fix Data.    ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			-- --------------------------------------------------------------------------------
			-- 2023/06/12 begin
			-- ---------------------------------------------------
		-- weekly :: working_time = 0 제외 cnt
		-- ---------------------------------------------------
		/* TODO:GTT:GT_SCP0_WEEK_SCP0013-->GT_SCP0_WEEK_SCP0013 */
		INSERT INTO GT_SCP0_WEEK_SCP0013
		SELECT   a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				,a.measure
				,'W_' || b.basis_yyyymm  ||  b.iso_week AS yyyymmdd
				,SUM(NVL(A.QTY,0)) AS SUM_QTY
		FROM (
				-- LINE_TOTAL_LOAD_ENGINE
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_ENGINE' AS measure
						,p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						,CASE WHEN d.working_time <= 0.0 THEN 0
							  ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						 END AS qty

						,case when NVL(d.WORKING_TIME,0) > 0 then 1 else 0 end as cnt


				FROM GT_SCP0_DynamicPivot_SCP0013_t a
				LEFT OUTER JOIN scp_anl_working_time d   ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2 = e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_ENGINE')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd ,d.working_time, origin_division_id

				UNION ALL

				-- LINE_TOTAL_LOAD_AMEND
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_AMEND' AS measure
						,p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						, CASE WHEN d.working_time <= 0.0 THEN 0
							   ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						  END AS qty

						, case when NVL(f.WORKING_TIME,0) > 0 then 1 else 0 end as cnt

				FROM GT_SCP0_DynamicPivot_SCP0013_t a
				LEFT OUTER JOIN GT_SCP0_DynamicPivot_SCP0013_w d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2=d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2=e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				LEFT OUTER JOIN scp_anl_working_time f   ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = f.scm_site_id
						and a.line_id = f.line_id
						and a.yyyymmdd= f.yyyymmdd


				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_AMEND')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd, d.working_time, a.origin_division_id, f.working_time


		) A;
		LEFT JOIN scm_sys_calendar_m b on a.YYYYMMDD = b.BASIS_YYYYMMDD
		GROUP BY a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				--,a.YYYYMMDD
				,b.basis_yyyymm, b.iso_week
				,a.measure

-- -------------------------------------
		/* TODO:GTT:GT_SCP0_WEEK_CNT_SCP0013-->GT_SCP0_WEEK_CNT_SCP0013 */
		INSERT INTO GT_SCP0_WEEK_CNT_SCP0013
		select   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,sum(NVL(a.cnt,0)) as cnt
		  from (
				select b.division_id
					  ,b.scm_site_id
					  ,b.operation_id
					  ,b.line_id
					  --,a.BASIS_YYYYMMDD
					  ,'W_' || a.basis_yyyymm  ||  a.iso_week AS yyyymmdd
					  ,case when NVL(b.WORKING_TIME,0) > 0 then 1 else 0 end as cnt
				from scm_sys_calendar_m a
				join scp_anl_working_time b on a.BASIS_YYYYMMDD = b.YYYYMMDD
					and b.DIVISION_ID = p_division_id
					AND ( ( p_scm_site_id IS NULL OR p_scm_site_id IS NULL ) OR scm_site_id IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
					AND ( ( p_line_id IS NULL OR p_line_id IS NULL ) OR line_id IN (SELECT token FROM TABLE(fn_string_split(p_line_id,','))) )
				where 1 = 1
				and a.BASIS_YYYYMMDD between p_from_yyyymmdd AND p_to_yyyymmdd
			   ) a;
		group by;
			   a.division_id
			  ,a.scm_site_id
			  ,a.operation_id
			  ,a.line_id
			  ,a.yyyymmdd
-- -------------------------------------
		/* TODO:GTT:GT_SCP0_WEEK_RATIO_SCP0013-->GT_SCP0_WEEK_RATIO_SCP0013 */
		INSERT INTO GT_SCP0_WEEK_RATIO_SCP0013
		SELECT   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,a.measure
				,NVL((a.SUM_QTY / b.cnt), 0) as ratio
		  FROM GT_SCP0_WEEK_SCP0013 A
		  JOIN GT_SCP0_WEEK_CNT_SCP0013 B
		    ON A.DIVISION_ID = B.DIVISION_ID
		   AND A.SCM_SITE_ID = B.SCM_SITE_ID
		   AND A.OPERATION_ID = B.OPERATION_ID
		   AND A.LINE_ID = B.LINE_ID
		   AND A.yyyymmdd = B.yyyymmdd;

		-- ---------------------------------------------------
		-- monthly :: working_time = 0 제외 cnt
		-- ---------------------------------------------------
		/* TODO:GTT:GT_SCP0_MONTH_SCP0013-->GT_SCP0_MONTH_SCP0013 */
		INSERT INTO GT_SCP0_MONTH_SCP0013
		SELECT   a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				,a.measure
				,'M_' || b.basis_yyyymm AS yyyymmdd
				,SUM(NVL(A.QTY,0)) AS SUM_QTY


		FROM (
				-- LINE_TOTAL_LOAD_ENGINE
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_ENGINE' AS measure
						,p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						,CASE WHEN d.working_time <= 0.0 THEN 0
								ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
							END AS qty

						,case when NVL(d.WORKING_TIME,0) > 0 then 1 else 0 end as cnt


				FROM GT_SCP0_DynamicPivot_SCP0013_t a
				LEFT OUTER JOIN scp_anl_working_time d   ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2 = e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_ENGINE')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd ,d.working_time, origin_division_id

				UNION ALL

				-- LINE_TOTAL_LOAD_AMEND
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_AMEND' AS measure
						,p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						, CASE WHEN d.working_time <= 0.0 THEN 0
								ELSE NVL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
							END AS qty

						, case when NVL(f.WORKING_TIME,0) > 0 then 1 else 0 end as cnt

				FROM GT_SCP0_DynamicPivot_SCP0013_t a
				LEFT OUTER JOIN GT_SCP0_DynamicPivot_SCP0013_w d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2=d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e   ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2=e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				LEFT OUTER JOIN scp_anl_working_time f   ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = f.scm_site_id
						and a.line_id = f.line_id
						and a.yyyymmdd= f.yyyymmdd


				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_AMEND')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd, d.working_time, a.origin_division_id, f.working_time


		) A;
		LEFT JOIN scm_sys_calendar_m b on a.YYYYMMDD = b.BASIS_YYYYMMDD
		GROUP BY a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				--,a.YYYYMMDD
				,b.basis_yyyymm
				,a.measure
		-- -----------------------------------
		/* TODO:GTT:GT_SCP0_MONTH_CNT_SCP0013-->GT_SCP0_MONTH_CNT_SCP0013 */
		INSERT INTO GT_SCP0_MONTH_CNT_SCP0013
		select   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,sum(NVL(a.cnt,0)) as cnt
		  from (
				select b.division_id
					  ,b.scm_site_id
					  ,b.operation_id
					  ,b.line_id
					  --,a.MONTH_NAME AS yyyymmdd
					  ,'M_' || a.basis_yyyymm AS yyyymmdd
					  ,case when NVL(b.WORKING_TIME,0) > 0 then 1 else 0 end as cnt
				from scm_sys_calendar_m a
				join scp_anl_working_time b on a.BASIS_YYYYMMDD = b.YYYYMMDD
					and b.DIVISION_ID = p_division_id
					AND ( ( p_scm_site_id IS NULL OR p_scm_site_id IS NULL ) OR scm_site_id IN (SELECT token FROM TABLE(fn_string_split(p_scm_site_id,','))) )
					AND ( ( p_line_id IS NULL OR p_line_id IS NULL ) OR line_id IN (SELECT token FROM TABLE(fn_string_split(p_line_id,','))) )
				where 1 = 1
				and a.BASIS_YYYYMMDD between p_from_yyyymmdd AND p_to_yyyymmdd
			   ) a;
		group by;
			   a.division_id
			  ,a.scm_site_id
			  ,a.operation_id
			  ,a.line_id
			  ,a.yyyymmdd

		/* TODO:GTT:GT_SCP0_MONTH_RATIO_SCP0013-->GT_SCP0_MONTH_RATIO_SCP0013 */
		INSERT INTO GT_SCP0_MONTH_RATIO_SCP0013
		SELECT   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,a.measure
				,NVL((a.SUM_QTY / b.cnt), 0) as ratio
		  FROM GT_SCP0_MONTH_SCP0013 A
		  JOIN GT_SCP0_MONTH_CNT_SCP0013 B
		    ON A.DIVISION_ID = B.DIVISION_ID
		   AND A.SCM_SITE_ID = B.SCM_SITE_ID
		   AND A.OPERATION_ID = B.OPERATION_ID
		   AND A.LINE_ID = B.LINE_ID
		   AND A.yyyymmdd = B.yyyymmdd;

		-- -------------------------------------------------------------------
			-- RESULT 3, WEEKLY PIVOT
			-- -------------------------------------------------------------------
			SELECT 'SELECT division_id,
    V_SQL2 + '
  INTO V_SQL2, V_SQL2
			  FROM (select distinct yyyymmdd as yyyymmdd
				    from GT_SCP0_WEEK_RATIO_SCP0013) t

			SELECT V_SQL2 = V_SQL2 + ' FROM GT_SCP0_WEEK_RATIO_SCP0013 GROUP BY division_id, scm_site_id, operation_id, line_id, measure'

			DBMS_OUTPUT.PUT_LINE(V_SQL2);
			EXEC (V_SQL2)
			-- -------------------------------------------------------------------
			-- RESULT 4, MONTHLY PIVOT
			-- -------------------------------------------------------------------
			SELECT 'SELECT division_id,
    V_SQL3 + '
  INTO V_SQL3, V_SQL3
			  FROM (select distinct yyyymmdd as yyyymmdd
				    from GT_SCP0_MONTH_RATIO_SCP0013) t

			SELECT V_SQL3 = V_SQL3 + ' FROM GT_SCP0_MONTH_RATIO_SCP0013 GROUP BY division_id, scm_site_id, operation_id, line_id, measure'

			DBMS_OUTPUT.PUT_LINE(V_SQL3);
			EXEC (V_SQL3)

			-- 2023/06/12 end


		END IF;

		--임시테이블 삭제
		END;