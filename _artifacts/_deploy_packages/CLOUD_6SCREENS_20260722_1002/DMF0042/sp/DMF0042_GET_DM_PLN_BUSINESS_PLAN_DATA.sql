CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA" 
(
	  p_division_id			IN  VARCHAR2
	, p_dept_id				IN  VARCHAR2
	, p_end_customer		IN  VARCHAR2
	, p_scm_site_id			IN  VARCHAR2
	, p_project_code		IN  VARCHAR2
	, p_item_id				IN  VARCHAR2
	, p_item_type			IN  VARCHAR2
	, p_from_yyyymmdd		IN  VARCHAR2
	, p_now_yyyymmdd		IN  VARCHAR2
	, p_to_yyyymmdd			IN  VARCHAR2
	, p_created_by			IN  VARCHAR2
	, p_plant_site_id		IN  VARCHAR2
	, p_biztype				IN  VARCHAR2
	, p_userinfo			IN  VARCHAR2
	, p_owner				IN  VARCHAR2
	, p_qty_yn				IN  VARCHAR2
	-- SELECT 결과셋 반환: ① 동적 PIVOT 결과, ② 중장기 계획 날짜 결과 → SYS_REFCURSOR OUT 2개
	, p_cursor1				OUT SYS_REFCURSOR
	, p_cursor2				OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID  : [DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA]
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date        In Charge    Description
 *=====================================================================================================================================================
 * 2019/04/11	JYE			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/05/13	JYE			40사업부는 Incoterms, Fcst type, Dom exp 필수 제외
 * 2019/08/26	JYE			칼럼 수정
 * 2019/09/05	JYE			LEFT JOIN 으로 변경
 * 2019/10/02   KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019/10/18   KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 2020/03/11   KHSONG		C20200103-000586 권한그룹을 LOOKUP
 * 2020/04/08	P.C.I		[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/07/10	hwi1993     소스정리
 * 2020/07/10	hwi1993		[C20200706-000011] BP 메저정리
 * 2020/09/04	hwi1993		[c20200722-000060] biz plan active YN
 * 2021/07/22	hwi1993		과제(중장기) pk 변경에 따른 컬럼추가
 * 2021/07/29	hwi1993		과제(중장기) owner 컬럼 길이 제한
 * 2022/03/02	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024/08/01	JSSBAE		[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2024/08/26	JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
 * 2024/08/27	KJJ			[PJ2024-50461] Team Mapping
 * 2024/09/12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2026.06.01	ZIONEX			[PJ202650304] NextSCM Migration
 *===================================================================================================================================================*/
AS
	v_Prod				CLOB;          -- 피벗 컬럼 식별자 목록 (outer SELECT 용 : "M_xxx",...)
	v_Prod_in			CLOB;          -- 피벗 IN 목록 ('M_xxx' AS "M_xxx",...)
	v_ColList			CLOB;
	v_GroupList			CLOB;
	v_nsql				CLOB;
	v_nsql2				CLOB;
	p_program_id		VARCHAR2(50 CHAR) := 'DMF0042';
	v_MEASURE			PLS_INTEGER := 0;
	v_i_count			PLS_INTEGER := 0;
	v_dept_id			VARCHAR2(50 CHAR) := NULL;   -- 원본 @v_dept_id (초기값 ''→NULL)
	v_group_id			VARCHAR2(50 CHAR) := NULL;   -- 원본 @v_group_id (초기값 ''→NULL)

	v_from_yyyymmdd		VARCHAR2(6 CHAR);            -- 원본은 IN 파라미터 @p_from_yyyymmdd 재대입 → Oracle 로컬변수 사용
	v_to_yyyymmdd		VARCHAR2(6 CHAR);

	v_from_yyyymm		VARCHAR2(6 CHAR);            -- 중장기 계획 구간 (원본 @FROM_YYYYMM); UF_FX_STRING_SPLITFORIN 은 T_STR_TAB 반환 → 컬럼명 COLUMN_VALUE
	v_to_yyyymm			VARCHAR2(6 CHAR);
	v_valid_yn			VARCHAR2(1 CHAR);
BEGIN
	v_ColList	:= NULL;     -- 원본 SET @ColList=''  (Oracle ''=NULL)
	v_GroupList	:= NULL;
	v_Prod		:= NULL;
	v_from_yyyymmdd	:= SUBSTR(p_from_yyyymmdd, 1, 6);
	v_to_yyyymmdd	:= SUBSTR(p_to_yyyymmdd, 1, 6);

	--============================================================================
	-- 사용자의 팀정보 & 권한
	--============================================================================
	BEGIN
		SELECT NVL(( SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
					 AND   VALID_YN = 'Y'
					 AND   SEGMENT1 = U.DEPT_ID
					 FETCH FIRST 1 ROWS ONLY ), U.DEPT_ID)
		INTO v_dept_id
		FROM TB_FX_User U
		WHERE U.UserID = p_created_by;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;   -- 사용자 미존재 시 원본(@v_dept_id 미변경)과 동일하게 NULL 유지
	END;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A001-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (START)
	--============================================================================
	SELECT COUNT(1)
	INTO   v_i_count
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND    VALID_YN = 'Y'
	AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
	AND    SEGMENT1 = p_userinfo;
	IF v_i_count > 0 THEN
		v_group_id := 'ADMIN';
	END IF;
	v_i_count := 0;   -- 권한판별용으로만 사용하므로 원복
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	--============================================================================
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A002-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- TEMP TABLE DROP (START)
	-- (Oracle GTT: DROP 대신 세션 데이터 DELETE 로 초기화)
	--============================================================================
	DELETE FROM GT_DMF0042_RAW_DATA;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_V;
	DELETE FROM GT_DMF0042_SELECT_MEASURE;
	DELETE FROM GT_DMF0042_RAW_DATA_SUM;
	DELETE FROM GT_DMF0042_SCM_MST_SSO_USER_INFO;
	DELETE FROM GT_DMF0042_SCM_MST_SITE_ITEM;
	--------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선  (START)
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_A_V;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_B_V;
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------
	--============================================================================
	-- TEMP TABLE DROP (END)
	--============================================================================
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A003-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- TEMP TABLE CREATE (START) → Oracle GTT 는 사전 생성(DDL 파일) 이므로 본문에서 생성하지 않음
	--============================================================================
	--============================================================================
	-- TEMP TABLE CREATE (END)
	--============================================================================
	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (START)
	--============================================================================
	-- 20191002 KHSONG 주석처리 (BEGIN)
	/*
	  -- 기존로직
	SELECT *
	 INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK)
	  WHERE DIVISION_ID = @p_division_id
		--and CASE WHEN @p_item_id = ''			THEN @p_item_id			ELSE ITEM_ID			END  in  (SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,','		))
	*/
	-- 20191002 KHSONG 주석처리 (END)

	--------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (START)
	--원소스 주석처리
	/*
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
	-----------------------------------------------------------------------------------------

	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		,ENERGE AS ENERGE_WH
		,CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	 FROM
			(SELECT *
			FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst
							OR	T2.NICK_NAME	like  b.tst
			  WHERE DIVISION_ID = @p_division_id
			) G
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		,ENERGE --[E20240731-000852]_ENERGE 컬럼 추가
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-----------------------------------------------------------------------------------------
	*/

	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE, ITEM_CLASS, ITEM_CLASS_NAME
		, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		, CELL_QUANTITY, SCP_EXTRA_SPEC, CELL_TYPE, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION )
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE, ITEM_CLASS, ITEM_CLASS_NAME
		 , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		 , CELL_QUANTITY, SCP_EXTRA_SPEC, CELL_TYPE, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
	FROM SCM_MST_ITEM_SN
	WHERE DIVISION_ID = p_division_id;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_A_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
		, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		, CELL_QUANTITY, SCP_EXTRA_SPEC )
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
						  WHEN T1.ITEM_TYPE = 'H' THEN 2
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )
									WHEN 1 THEN 'P'
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC
	FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_B_V
		( DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
		, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
	SELECT DIVISION_ID
		 , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		, ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC, ENERGE_WH, ENERGE_KWH )
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		 , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
		 --------------------------------------------------------------------------------------------------
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN REGEXP_LIKE(ENERGE, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN ROUND(TO_NUMBER(ENERGE)/1000, 7) ELSE NULL END AS ENERGE_KWH
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
		 --------------------------------------------------------------------------------------------------
	FROM
	( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
		   , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE
		   , T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC
		   , T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
		FROM GT_DMF0042_DM_MST_ITEM_SINGLE_A_V T1
		INNER JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_B_V T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b
				ON	T1.ITEM_ID		like  b.tst
				OR	T1.NICK_NAME	like  b.tst
		WHERE 1=1
	) T2
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------

	/* 원본 CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON #TEMP_DM_MST_ITEM_SINGLE_V (DIVISION_ID, ITEM_ID)
	   → GTT 인덱스는 배포 시점(GTT DDL)에서 처리. 본문 인덱스 생성 제거. */
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A004-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	--============================================================================
	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	--============================================================================
	INSERT INTO GT_DMF0042_SCM_MST_SSO_USER_INFO ( USER_ID, DEPT_ID )
	SELECT USER_ID, DEPT_ID
	FROM SCM_MST_SSO_USER_INFO
	ORDER BY USER_ID;

	-- 2020.4.23 속도문제로 쿼리 변경
	-- ※ 타깃 Oracle SCM_MST_SITE_ITEM 은 MSSQL 과 컬럼 구성이 다름(REPORT_GROUP1~8/CUST_ENG_NM 등 없음).
	--    하위에서 SI 가 사용하는 컬럼만으로 한정 적재. REPORT_GROUP1~8 은 타깃에 없어 NULL 대체(TODO/이슈).
	INSERT INTO GT_DMF0042_SCM_MST_SITE_ITEM
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, APPLICATION, CUST_GROUP, CUST_GROUP_DTL, ROUTE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, OWNER
		, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
		, OWNER_NAME, OWNER_NAME_KO, DEPT_ID, EDIT_FLAG )
	SELECT SMSI.DIVISION_ID, SMSI.PROJECT_CODE, SMSI.SCM_SITE_ID, SMSI.ITEM_ID, SMSI.CURRENCY, SMSI.APPLICATION, SMSI.CUST_GROUP, SMSI.CUST_GROUP_DTL, SMSI.ROUTE
		 , SMSI.ATTRIBUTE1, SMSI.ATTRIBUTE2, SMSI.ATTRIBUTE5, SMSI.OWNER
		 /* TODO: REPORT_GROUP1~8 가 타깃 SCM_MST_SITE_ITEM 에 없어 NULL 대체 — 실제 소스 컬럼 확인 필요 */
		 , CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR))
		 , CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR))
		 , FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		 , FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		 ,( SELECT SU.DEPT_ID  FROM GT_DMF0042_SCM_MST_SSO_USER_INFO SU  WHERE UPPER(SU.USER_ID)
			= UPPER((SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(SMSI.OWNER, ',')) WHERE ROWNUM = 1)) ) DEPT_ID   -- [대소문자] MSSQL CI 비교 재현: USER_ID 매칭 시 UPPER 양변 적용
		 , SMSI.SALES_PLAN_ADJUST_YN AS EDIT_FLAG
	FROM SCM_MST_SITE_ITEM SMSI
	WHERE SMSI.DIVISION_ID = p_division_id;

	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	--============================================================================

	/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
	   과거 구간은 전체 Data가 포함되어야 함.
	   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
	   단위 환산이 되어야 함.
	*/

	INSERT INTO GT_DMF0042_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, MEASURE, SORT_ORDER_NO )
	SELECT U.PROGRAM_ID, U.SHEET_NAME--, U.USER_ID
		 , U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO
	FROM SCM_MST_SHEET_MEASURE U
	WHERE 1 = 1
	--AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID = p_program_id
	AND ( U.DIVISION_ID IS NULL OR U.DIVISION_ID LIKE '%' || p_division_id || '%' );  -- [2026-07-15 사용자 확정] DIVISION_ID NULL = 전 division 표기 대상 (SHEET_MEASURE NULL 5행 탈락 결함 수정)
	--AND U.USER_ID      = @p_created_by
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A005-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--============================================================================
	-- (1) DM_PLN_BP_FCST
	--============================================================================
	IF p_division_id = '40' THEN
		INSERT INTO GT_DMF0042_RAW_DATA
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER40--,A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS  -- [PJ20200138] Incoterms 삭제
			 --,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
			 --,A.DOM_EXP
			 , A.FCST_TYPE, A.MEASURE
			 --[E20240731-000845]_조회당시 코드값으로 넘기도록 수정(원소스 주석처리)
			 --,LK1.ATTRIBUTE1 AS CELL_PROD_SITE
			 , LK1.SEGMENT1 AS CELL_PROD_SITE, 'M_' || A.YYYYMM AS COLNAME, SM.SORT_ORDER_NO
			 , CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, CAL.CALENDAR_YYYY AS CALENDAR_YYYY
			 , A.YYYYMM, A.QTY
			 , CASE WHEN RTRIM(A.CURRENCY) IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY   -- 원본 A.CURRENCY = '' (빈문자/공백 → RTRIM IS NULL)
			 , ISV.FORECAST_INFO_CELL_PACK_COUNT
			 , ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
			 --,A.BIZ_TYPE AS BIZ_TYPE_NAME40
			 , ( SELECT LMD.SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD
				 WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
			 , ISV.ITEM_CLASS_NAME AS ITEM_CLASS_NAME, ISV.ITEM_NAME AS ITEM_NAME
			 , ISV.ITEM_TYPE AS ITEM_TYPE, ISV.NICK_NAME AS NICK_NAME
			 , ISV.MIN_CAPACITY
			 --,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   +
			 , CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = v_dept_id THEN 'Y'
					WHEN v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG
			 , SI.APPLICATION, SI.CUST_GROUP, SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL, SI.OWNER_NAME OWNER
			 --,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 --,A.DEPT_ID  AS DEPT_ID
			 , SI.DEPT_ID  AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 , S.VMI_YN, SI.ROUTE, ISV.FORECAST_INFO_PRODUCT_GROUP, ISV.FORECAST_INFO_SPEC || ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
			 , ISV.FORECAST_INFO_SPEC, ISV.FORECAST_INFOR_VERSION, ISV.MDM_PROJECT_NAME, SI.CUST_GROUP_DTL
			 , SI.ATTRIBUTE1 AS DMS_SALES, SI.ATTRIBUTE2 AS DMS_CUSTOMER
			 --,MP.BIZ_TYPE as BIZ_TYPE_NAME
			 , A.PROJECT_NAME, '' AS PROJECT_OWNER, '' AS PROJECT_STATUS, A.END_CUSTOMER, S.CITY_NAME, S.COUNTRY_NAME
			 --,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
			 , A.FCST_TYPE AS FCST_TYPE40		-- 20190513
			 --,A.DOM_EXP AS DOM_EXP40			-- 20190513
			 , SI.REPORT_GROUP1, SI.REPORT_GROUP2, SI.REPORT_GROUP3, SI.REPORT_GROUP4, SI.REPORT_GROUP5, SI.REPORT_GROUP6
			 , SI.REPORT_GROUP7, SI.REPORT_GROUP8
			 -- 201990826
			 , A.BIZ_TYPE AS BIZ_TYPE_NAME81, A.PROJECT_CODE AS PROJECT_CODE82, A.BIZ_TYPE AS BIZ_TYPE_NAME82
			 , A.ITEM_ID AS ITEM_ID40, A.SCM_SITE_ID AS SCM_SITE_ID40, A.SCM_SITE_ID AS SCM_SITE_ID81
			 , A.SCM_SITE_ID AS SCM_SITE_ID82 --,A.CELL_PER_PACK--,A.CELL_PER_MODULE--,A.MODULE_PER_PACK
			 , SI.DEPT_ID AS DEPT_ID40
			 -- 201990826
			 , '' AS PRODUCT_GROUP_NAME, A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
			 , A.UNIT_ENERGY, 0 AS CELL_PER_CAR, 0 AS MODULE_PER_CAR, ISV.ENERGE_WH	--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
			 , ISV.ENERGE_KWH --[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
		FROM DM_PLN_BP_FCST A
		INNER JOIN SCM_MST_SITE S1
				ON A.DIVISION_ID = S1.DIVISION_ID AND A.SCM_SITE_ID = S1.SCM_SITE_ID
			 --AND S1.VALID_YN	  = 'Y'	-- [c20200722-000060]
		INNER JOIN SCM_MST_SITE_ITEM S2
				ON A.DIVISION_ID = S2.DIVISION_ID AND A.PROJECT_CODE = S2.PROJECT_CODE
				AND A.SCM_SITE_ID = S2.SCM_SITE_ID AND A.ITEM_ID = S2.ITEM_ID
			  --AND S2.VALID_YN			= 'Y'	--[c20200722-000060]
		INNER JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_V ISV
				ON A.DIVISION_ID = ISV.DIVISION_ID AND A.ITEM_ID = ISV.ITEM_ID
		LEFT JOIN GT_DMF0042_SCM_MST_SITE_ITEM SI
			   ON A.DIVISION_ID	= SI.DIVISION_ID AND A.SCM_SITE_ID = SI.SCM_SITE_ID
			  AND A.PROJECT_CODE = SI.PROJECT_CODE AND A.ITEM_ID = SI.ITEM_ID
			--AND SI.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN (	SELECT X.DIVISION_ID, X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME
					FROM SCM_MST_SITE X, SCM_MST_CITY Y, SCM_MST_COUNTRY Z
					WHERE X.CITY = Y.CITY AND X.COUNTRY = Z.COUNTRY	) S
			   ON A.DIVISION_ID	= S.DIVISION_ID
			  AND A.SCM_SITE_ID	= S.SCM_SITE_ID
			--AND S.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.CELL_PROD_SITE = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
		-------------------------- Project 조건 ------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_project_code,'%'),',')) ) b1
		ON      CASE WHEN p_project_code IS NULL THEN '%'
	    			ELSE A.PROJECT_CODE  END like  b1.tst
			OR   CASE WHEN p_project_code IS NULL THEN '%'
					ELSE A.PROJECT_NAME  END like  b1.tst
		-----------------------------------------------------------------------------------------------
		-------------------------- Model 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b2
		ON      CASE WHEN p_item_id IS NULL THEN '%'
					ELSE A.ITEM_ID  END like  b2.tst
			OR   CASE WHEN p_item_id IS NULL THEN '%'
					ELSE ISV.NICK_NAME  END like  b2.tst
		-----------------------------------------------------------------------------------------------
		-------------------------- Owner 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_owner,'%'),',')) ) b3
		ON      CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER         END like  b3.tst
			OR   CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER_NAME    END like  b3.tst
			OR   CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER_NAME_KO END like  b3.tst
		-----------------------------------------------------------------------------------------------
		INNER JOIN GT_DMF0042_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
		INNER JOIN ( SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					 FROM SCM_SYS_CALENDAR_M
					 WHERE ( BASIS_YYYYMM >= v_from_yyyymmdd AND BASIS_YYYYMM <= v_to_yyyymmdd )
					 GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
		WHERE 1=1
		AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
					ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
			END IN ( SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_dept_id,',')) P WHERE
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.COLUMN_VALUE
							)
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			ELSE NVL(
					CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,NULL)
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_end_customer,',')) P WHERE
					(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
						CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,NULL) END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.SCM_SITE_ID
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_scm_site_id,',')) P WHERE
					(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.PLANT_SITE_ID
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_plant_site_id,',')) P WHERE
					(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   			ELSE ISV.ITEM_TYPE
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_item_type,',')) P WHERE
					(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   			ELSE
					CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_biztype,',')) P WHERE
					(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
					CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END) = P.COLUMN_VALUE
					)
		AND (A.YYYYMM >= v_from_yyyymmdd AND A.YYYYMM <= v_to_yyyymmdd)
		AND A.DIVISION_ID = p_division_id
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
				;

		DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A006-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	ELSE
			INSERT INTO GT_DMF0042_RAW_DATA
				 ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID
				 , INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
				 , SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY
				 , CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40, CELL_TYPE, ITEM_CLASS_NAME
				 , ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG

				 , APPLICATION, CUST_GROUP
				 , FORECAST_INFO_CELL_MODEL
				 , OWNER
				 , DEPT_ID
				 , VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
				 , FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER

				 , PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS, END_CUSTOMER, CITY_NAME
				 , COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2

				 , REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7
				 , REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40
				 , SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME
				 , ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR
				 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
				 , ENERGE_WH, ENERGE_KWH
				 )
			SELECT
				A.DIVISION_ID
				,A.PROJECT_CODE
				,A.PROJECT_CODE AS END_CUSTOMER40
				--,A.SCM_SITE_ID
				,A.PLANT_SITE_ID
				,A.ITEM_ID
				,A.INCOTERMS -- [PJ20200138] Incoterms 삭제
				--,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
				--,A.DOM_EXP
				,A.FCST_TYPE
				,A.MEASURE
				,A.CELL_PROD_SITE
				,'M_' || A.YYYYMM AS COLNAME
				,SM.SORT_ORDER_NO
				,CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
				,CAL.CALENDAR_YYYY AS CALENDAR_YYYY
				,A.YYYYMM ,A.QTY
				,CASE WHEN RTRIM(A.CURRENCY) IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY   -- 원본 A.CURRENCY = '' (빈문자/공백 → RTRIM IS NULL)
				,ISV.FORECAST_INFO_CELL_PACK_COUNT
				,ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
				--,A.BIZ_TYPE AS BIZ_TYPE_NAME40
				,(SELECT LMD.SEGMENT2  AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
				,ISV.ITEM_CLASS_NAME AS ITEM_CLASS_NAME
				,ISV.ITEM_NAME AS ITEM_NAME
				,ISV.ITEM_TYPE AS ITEM_TYPE
				,ISV.NICK_NAME AS NICK_NAME
				,ISV.MIN_CAPACITY
				--,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   +

				--[PJ2024-50461] Team Mapping------------------------------------
				/*,CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = @v_dept_id THEN 'Y'
						WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG*/
				,CASE WHEN SI.DEPT_ID = v_dept_id THEN 'Y'
										WHEN v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG
				--[PJ2024-50461] Team Mapping------------------------------------
				,SI.APPLICATION
				,SI.CUST_GROUP
				,SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
				,SUBSTR(SI.OWNER_NAME, 1, 100) AS OWNER
				--------,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID

				--[PJ2024-50461] Team Mapping------------------------------------
				--,A.DEPT_ID  AS DEPT_ID
				,SI.DEPT_ID AS DEPT_ID
				--[PJ2024-50461] Team Mapping------------------------------------

				,S.VMI_YN
				,SI.ROUTE
				,ISV.FORECAST_INFO_PRODUCT_GROUP
				,ISV.FORECAST_INFO_SPEC||ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
				,ISV.FORECAST_INFO_SPEC
				,ISV.FORECAST_INFOR_VERSION
				,ISV.MDM_PROJECT_NAME
				,SI.CUST_GROUP_DTL
				,SI.attribute1 DMS_SALES
				,SI.attribute2 DMS_CUSTOMER
							----,MP.BIZ_TYPE as BIZ_TYPE_NAME
				,CASE WHEN MP.PROJECT_NAME IS NULL THEN A.PROJECT_NAME ELSE MP.PROJECT_NAME END PROJECT_NAME
				,MP.PROJECT_OWNER
				,MP.PROJECT_STATUS
				,A.END_CUSTOMER
				,S.CITY_NAME
				,S.COUNTRY_NAME
				--,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
				,A.FCST_TYPE AS FCST_TYPE40		-- 20190513
				--,A.DOM_EXP AS DOM_EXP40			-- 20190513
				,SI.REPORT_GROUP1
				,SI.REPORT_GROUP2
				,SI.REPORT_GROUP3
				,SI.REPORT_GROUP4
				,SI.REPORT_GROUP5
				,SI.REPORT_GROUP6
				,SI.REPORT_GROUP7
				,SI.REPORT_GROUP8
				-- 201990826
				,A.BIZ_TYPE as BIZ_TYPE_NAME81
				,A.PROJECT_CODE AS PROJECT_CODE82
				,A.BIZ_TYPE AS BIZ_TYPE_NAME82
				,A.ITEM_ID AS ITEM_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID81
				,A.SCM_SITE_ID AS SCM_SITE_ID82
				--,A.CELL_PER_PACK
				--,A.CELL_PER_MODULE
				--,A.MODULE_PER_PACK
				,SI.DEPT_ID AS DEPT_ID40
				-- 201990826
				,MP.PRODUCT_GROUP_NAME
				,A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
				,A.UNIT_ENERGY
				,NVL(S2.CELL_PER_CAR, 0) AS CELL_PER_CAR
				,NVL(S2.CELL_PER_CAR / S2.CELL_PER_MODULE, 0) AS MODULE_PER_CAR
				,ISV.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
				,ISV.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
			FROM DM_PLN_BP_FCST A
				LEFT JOIN SCM_MST_SITE S1
					ON (A.DIVISION_ID		= S1.DIVISION_ID
					AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
					--AND S1.VALID_YN	  = 'Y'	--[c20200722-000060]
					)
				LEFT JOIN SCM_MST_SITE_ITEM S2
					ON (A.DIVISION_ID		= S2.DIVISION_ID
					AND A.PROJECT_CODE		= S2.PROJECT_CODE
					AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					AND A.ITEM_ID			= S2.ITEM_ID
					--AND S2.VALID_YN			= 'Y' --[c20200722-000060]
					)
				LEFT JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_V ISV
					ON A.DIVISION_ID		= ISV.DIVISION_ID
					AND A.ITEM_ID			= ISV.ITEM_ID
				LEFT JOIN GT_DMF0042_SCM_MST_SITE_ITEM SI
					 ON A.DIVISION_ID		= SI.DIVISION_ID
					AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					AND A.PROJECT_CODE		= SI.PROJECT_CODE
					AND A.iTEM_ID			= SI.ITEM_ID
					--AND SI.VALID_YN			= 'Y'	-- [c20200722-000060]
				LEFT JOIN SCM_MST_PROJECT MP
					ON A.DIVISION_ID		= MP.DIVISION_ID
					AND A.PROJECT_CODE		= MP.PROJECT_CODE
				LEFT JOIN (
							SELECT X.DIVISION_ID,X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME
							FROM SCM_MST_SITE X, SCM_MST_CITY Y, SCM_MST_COUNTRY z
							WHERE x.city = y.city  and x.country = z.country
						) S
					ON A.DIVISION_ID		= S.DIVISION_ID
					AND A.SCM_SITE_ID		= S.SCM_SITE_ID
					--AND S.VALID_YN			= 'Y'	-- [c20200722-000060]
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_project_code,'%'),',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN '%'
	    					ELSE A.PROJECT_CODE  END like  b1.tst
					OR   CASE WHEN p_project_code IS NULL THEN '%'
							ELSE A.PROJECT_NAME  END like  b1.tst
				-----------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b2
				ON      CASE WHEN p_item_id IS NULL THEN '%'
							ELSE A.ITEM_ID  END like  b2.tst
					OR   CASE WHEN p_item_id IS NULL THEN '%'
							ELSE ISV.NICK_NAME  END like  b2.tst
				-----------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_owner,'%'),',')) ) b3
				ON      CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER         END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER_NAME    END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER_NAME_KO END like  b3.tst
				-----------------------------------------------------------------------------------------------
				INNER JOIN GT_DMF0042_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
				INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					FROM SCM_SYS_CALENDAR_M
					WHERE (BASIS_YYYYMM >= v_from_yyyymmdd AND BASIS_YYYYMM <= v_to_yyyymmdd)
					GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
			--[PJ2024-50461] Team Mapping------------------------------------
				AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
							ELSE SI.DEPT_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_dept_id,',')) P WHERE
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								SI.DEPT_ID
							END) = P.COLUMN_VALUE
							)
/*
				AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
							ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where
							(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
*/
				--[PJ2024-50461] Team Mapping------------------------------------

				AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   						ELSE NVL(
							CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,NULL)
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_end_customer,',')) P WHERE
							(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
								CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,NULL) END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   						ELSE A.SCM_SITE_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_scm_site_id,',')) P WHERE
							(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   						ELSE A.PLANT_SITE_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_plant_site_id,',')) P WHERE
							(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   						ELSE ISV.ITEM_TYPE
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_item_type,',')) P WHERE
							(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   						ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_biztype,',')) P WHERE
							(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
							END) = P.COLUMN_VALUE
							)
				AND (A.YYYYMM >= v_from_yyyymmdd and A.YYYYMM <= v_to_yyyymmdd)
				AND A.DIVISION_ID = p_division_id
                AND ( ( p_item_id IS NULL ) OR A.ITEM_ID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(p_item_id    ,','))) )
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
		     ;

	END IF;

	IF p_qty_yn = 'Y' THEN
		DELETE FROM GT_DMF0042_DLT_ITEM_ID;

		INSERT INTO GT_DMF0042_DLT_ITEM_ID
			( DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
			, MEASURE, ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
			, INCOTERMS, CURRENCY, CELL_PROD_SITE
			--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
			, ENERGE_WH, ENERGE_KWH )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.FCST_TYPE, A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER
			 , A.MEASURE, A.ITEM_ID40, A.SCM_SITE_ID40, A.SCM_SITE_ID81, A.SCM_SITE_ID82, A.DEPT_ID40, A.PROJECT_CODE82, A.END_CUSTOMER40, A.FCST_TYPE40
			 , A.INCOTERMS, A.CURRENCY, A.CELL_PROD_SITE
			 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
			 , A.ENERGE_WH, A.ENERGE_KWH
		FROM GT_DMF0042_RAW_DATA A
		INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
						  , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
						  , INCOTERMS, CURRENCY, CELL_PROD_SITE
					 FROM GT_DMF0042_RAW_DATA
					 WHERE MEASURE = 'Business_Plan'
					 GROUP BY DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
					 	    , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
					 	    , INCOTERMS, CURRENCY, CELL_PROD_SITE
					 HAVING SUM(QTY) = 0) B
				 ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.PROJECT_CODE		= B.PROJECT_CODE
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.DEPT_ID			= B.DEPT_ID
				AND A.ITEM_ID40			= B.ITEM_ID40
				AND A.SCM_SITE_ID40		= B.SCM_SITE_ID40
				AND A.SCM_SITE_ID81		= B.SCM_SITE_ID81
				AND A.SCM_SITE_ID82		= B.SCM_SITE_ID82
				AND A.DEPT_ID40			= B.DEPT_ID40
				AND A.PROJECT_CODE82	= B.PROJECT_CODE82
				AND A.END_CUSTOMER40	= B.END_CUSTOMER40
				AND A.FCST_TYPE40		= B.FCST_TYPE40
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.CURRENCY			= B.CURRENCY
				AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE;

		-- 원본 DELETE A FROM #RAW_DATA A INNER JOIN #DLT_ITEM_ID B → Oracle: EXISTS 서브쿼리
		DELETE FROM GT_DMF0042_RAW_DATA A
		WHERE EXISTS ( SELECT 1 FROM GT_DMF0042_DLT_ITEM_ID B
					   WHERE A.DIVISION_ID		= B.DIVISION_ID
						 AND A.PROJECT_CODE		= B.PROJECT_CODE
						 AND A.ITEM_ID			= B.ITEM_ID
						 AND A.FCST_TYPE		= B.FCST_TYPE
						 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
						 AND A.DEPT_ID			= B.DEPT_ID
						 AND A.END_CUSTOMER		= B.END_CUSTOMER
						 AND A.ITEM_ID40		= B.ITEM_ID40
						 AND A.SCM_SITE_ID40	= B.SCM_SITE_ID40
						 AND A.SCM_SITE_ID81	= B.SCM_SITE_ID81
						 AND A.SCM_SITE_ID82	= B.SCM_SITE_ID82
						 AND A.DEPT_ID40		= B.DEPT_ID40
						 AND A.PROJECT_CODE82	= B.PROJECT_CODE82
						 AND A.END_CUSTOMER40	= B.END_CUSTOMER40
						 AND A.FCST_TYPE40		= B.FCST_TYPE40
						 AND A.INCOTERMS		= B.INCOTERMS
						 AND A.CURRENCY			= B.CURRENCY
						 AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE );
	END IF;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A007-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- 분기 합계 → #RAW_DATA_SUM
	INSERT INTO GT_DMF0042_RAW_DATA_SUM
		( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID, INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
		, SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY, CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40
		, CELL_TYPE, ITEM_CLASS_NAME, ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG, APPLICATION, CUST_GROUP
		, FORECAST_INFO_CELL_MODEL, OWNER, DEPT_ID, VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
		, FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS
		, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
		, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40, SCM_SITE_ID40
		, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME, ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR, ENERGE_WH, ENERGE_KWH )
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Q_' || REPLACE(X.CALENDAR_YYYYQQ, 'Q', '_') AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY,  X.CALENDAR_YYYYQQ AS YYYYMM
		 --,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		 , CASE WHEN X.MEASURE = 'SalesAmt_KRW' OR X.MEASURE = 'SalesAmt_LOC' OR X.MEASURE = 'SalesAmt_USD' OR X.MEASURE = 'Business_Plan'
				THEN SUM(X.QTY) ELSE MAX(X.QTY) END QTY
		 , X.CURRENCY
		 , MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		 , MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		 , MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		 , MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		 , MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		 , MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) AS ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
		 , MAX(X.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		 , MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		 , MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME
		 --, MAX(X.INCOTERMS40) AS INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		 , MAX(X.FCST_TYPE40) AS FCST_TYPE40		-- 20190513
		 --, MAX(X.DOM_EXP40) AS DOM_EXP40 			-- 20190513
		 , MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		 , MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		 , MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		 -- 201990826
		 , MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		 , MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		 , MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		 , MAX(X.DEPT_ID40) AS DEPT_ID40
		 -- 201990826
		 , X.PRODUCT_GROUP_NAME, X.ITEM_USE, X.UNIT_ENERGY-- [PJ20200138] item_use, unit_energy 추가
		 , MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
		 , MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		, X.ENERGE_WH, X.ENERGE_KWH
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)
	FROM GT_DMF0042_RAW_DATA X
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40, X.SCM_SITE_ID81
		   , X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME,  X.ITEM_USE
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		   , X.ENERGE_WH, X.ENERGE_KWH;
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A008-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- 연 합계 → #RAW_DATA_SUM 누적
	INSERT INTO GT_DMF0042_RAW_DATA_SUM
		( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID, INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
		, SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY, CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40
		, CELL_TYPE, ITEM_CLASS_NAME, ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG, APPLICATION, CUST_GROUP
		, FORECAST_INFO_CELL_MODEL, OWNER, DEPT_ID, VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
		, FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS
		, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
		, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40, SCM_SITE_ID40
		, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME, ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR, ENERGE_WH, ENERGE_KWH )
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제
		 --,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제
		 --,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Y_' || X.CALENDAR_YYYY AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYY AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY, X.CALENDAR_YYYY AS YYYYMM
		--,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		 , CASE WHEN X.MEASURE = 'SalesAmt_KRW' OR X.MEASURE = 'SalesAmt_LOC' OR X.MEASURE = 'SalesAmt_USD' OR X.MEASURE = 'Business_Plan'
				THEN SUM(X.QTY) ELSE MAX(X.QTY) END QTY
		 , X.CURRENCY, MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		, MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		, MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		, MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		, MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		, MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		, MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		, MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME, MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
		, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		, MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		, MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME--,MAX(X.INCOTERMS40)	INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		, MAX(X.FCST_TYPE40) AS FCST_TYPE40-- 20190513--,MAX(X.DOM_EXP40)		DOM_EXP40 			-- 20190513
		, MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		, MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		, MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		-- 201990826
		, MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		, MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		, MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
		--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK
		--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE
		--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		, MAX(X.DEPT_ID40) AS DEPT_ID40
		-- 201990826
		, X.PRODUCT_GROUP_NAME, X.ITEM_USE -- [PJ20200138] item_use, unit_energy 추가
		, X.UNIT_ENERGY, MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR, MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
	FROM GT_DMF0042_RAW_DATA X
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40
		   , X.SCM_SITE_ID81, X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME, X.ITEM_USE
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		   , X.ENERGE_WH, X.ENERGE_KWH;

	-- ################ #RAW_DATA and Quarter&Year Sum ###########################

	INSERT INTO GT_DMF0042_RAW_DATA
	SELECT *
	FROM GT_DMF0042_RAW_DATA_SUM;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A009-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	SELECT Count(*)
	INTO   v_i_count
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = p_program_id
	AND    U.SHEET_NAME  = 'Biz Plan'
	AND    U.USER_ID     = p_created_by
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

	--print @i_Count

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A0010-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	IF v_i_count = 0 THEN
		-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
		FOR rec IN ( SELECT C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					 FROM SCM_MST_SHEET_COLUMNS C
					 WHERE 1 = 1
					   AND C.PROGRAM_ID  = p_program_id
					   AND C.SHEET_NAME  = 'Biz Plan'
					   AND ( C.DEFAULT_FLAG = 'Y' OR
							(    C.VISIBLE_FLAG = 'N'
							 AND RTRIM(C.DEFAULT_FLAG) IS NULL   -- 원본 C.DEFAULT_FLAG = '' (MSSQL 빈문자/후행공백 비교 → Oracle RTRIM IS NULL 로 보존)
							 AND C.VALID_YN     = 'Y'
							))
					 ORDER BY C.SORT_ORDER_NO ) LOOP
			v_ColList   := v_ColList   || '"' || rec.COLUMN_NAME || '",';
			v_GroupList := v_GroupList || '"' || rec.COLUMN_NAME || '" ' || rec.DATA_SORT_METHOD_CODE || ',';
		END LOOP;
	ELSE
		FOR rec IN ( SELECT COLUMN_NAME, DATA_SORT_METHOD_CODE
					 FROM (
						SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
						FROM   SCM_MST_TITLESET_USER U
							 , SCM_MST_SHEET_COLUMNS C
						WHERE  1 = 1
							AND U.PROGRAM_ID  = C.PROGRAM_ID
							AND U.SHEET_NAME  = C.SHEET_NAME
							AND U.COLUMN_NAME = C.COLUMN_NAME
							AND U.PROGRAM_ID  = p_program_id
							AND U.SHEET_NAME  = 'Biz Plan'
							AND U.USER_ID     = p_created_by
							AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
							AND p_division_id IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
						UNION ALL
						SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE
						FROM (
							SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
							FROM   SCM_MST_SHEET_COLUMNS C
							WHERE  1 = 1
								AND C.PROGRAM_ID  = p_program_id
								AND C.SHEET_NAME  = 'Biz Plan'
								AND C.VISIBLE_FLAG = 'N'
								AND RTRIM(C.DEFAULT_FLAG) IS NULL   -- 원본 C.DEFAULT_FLAG = '' (MSSQL 빈문자/후행공백 비교 → Oracle RTRIM IS NULL 로 보존)
								AND C.VALID_YN     = 'Y'
								AND p_division_id IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
						) WHERE ROWNUM <= 100
					 ) tbColList
					 ORDER BY SORT_ORDER_NO ) LOOP
			v_ColList   := v_ColList   || '"' || rec.COLUMN_NAME || '",';
			v_GroupList := v_GroupList || '"' || rec.COLUMN_NAME || '" ' || rec.DATA_SORT_METHOD_CODE || ',';
		END LOOP;
	END IF;

	v_ColList   := SUBSTR(v_ColList,   1, LENGTH(v_ColList)  - 1);
	v_GroupList := SUBSTR(v_GroupList, 1, LENGTH(v_GroupList)- 1);

	DBMS_OUTPUT.PUT_LINE('-------------2! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A010-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--	print  @ColList

	-- 5. 피벗 결과 내기위한 날짜 리스트.
	-- @Prod = '';
	FOR rec IN ( SELECT DISTINCT COLNAME FROM GT_DMF0042_RAW_DATA ORDER BY COLNAME ) LOOP
		v_Prod    := v_Prod    || '"' || rec.COLNAME || '",';
		v_Prod_in := v_Prod_in || '''' || rec.COLNAME || ''' AS "' || rec.COLNAME || '",';
	END LOOP;

	IF v_Prod IS NULL THEN
		v_Prod    := '"D_99999999"';
		v_Prod_in := '''D_99999999'' AS "D_99999999"';
	ELSE
		v_Prod    := SUBSTR(v_Prod,    1, LENGTH(v_Prod)   - 1);
		v_Prod_in := SUBSTR(v_Prod_in, 1, LENGTH(v_Prod_in)- 1);
	END IF;
	DBMS_OUTPUT.PUT_LINE('-------------3! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A011-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- 6. 최종 피벗 내기.
	-- MEASURE에 따른 앞에 SORT_ORDER_NO 위한 삽입
	v_ColList   := REPLACE(v_ColList,   '"MEASURE"', '"SORT_ORDER_NO","MEASURE"');
	v_GroupList := REPLACE(v_GroupList, '"MEASURE"', '"SORT_ORDER_NO","MEASURE"');
	--SELECT @GroupList = REPLACE(@GroupList,'[CELL_PER_PACK] ASC,[CELL_PER_MODULE] ASC,[MODULE_PER_PACK] ASC,', '')
	v_GroupList := REPLACE(v_GroupList, '"CELL_PER_CAR" ASC,"MODULE_PER_CAR" ASC,', '');
	--select @ColList
	--return(0)
	-- Temp Table 삭제
	--IF OBJECT_ID (N'dbo.TEMP_SKH_0326_SALES_PLAN_TOBE', N'U') IS NOT NULL
	--	DROP TABLE TEMP_SKH_0326_SALES_PLAN_TOBE
	--	;
	DBMS_OUTPUT.PUT_LINE('-------------4! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	v_nsql2 := '
	SELECT
			 ' || v_ColList || '
			,' || v_Prod || '
			--INTO TEMP_SKH_0326_SALES_PLAN_TOBE
		From(
			--SELECT COLNAME, SUM(QTY) AS QTY, ' || v_ColList || '
			SELECT COLNAME, case when MEASURE in (''LOC'',''USD'',''KRW'') then MAX(QTY) else SUM(QTY) end AS QTY, ' || v_ColList || '  -- 20190108 KHSONG Unit Price 인경우는 SUM하지 않고 AVG로 표기함
			FROM GT_DMF0042_RAW_DATA
			GROUP BY COLNAME, ' || v_ColList || '
			) T
		PIVOT (MAX(QTY) FOR COLNAME IN (' || v_Prod_in || ')
		) PVT
		ORDER BY
				 ' || v_GroupList;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A012-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--SELECT @GroupList
	--select @nsql2
	--select convert(text, @nsql2)
	--for xml path('')--,root('x')

	-- 동적 PIVOT 결과셋 반환 (원본 execute dbo.SP_executesql @NSQL2)
	OPEN p_cursor1 FOR v_nsql2;

	--중장기 계획 관련 날짜 취득
	BEGIN
		SELECT ATTRIBUTE1, ATTRIBUTE2, VALID_YN
		INTO   v_from_yyyymm, v_to_yyyymm, v_valid_yn
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'DM_LONG_PLAN'
		AND A.SEGMENT1 = p_division_id
		AND A.SEGMENT2 = 'Biz Plan'
		AND A.VALID_YN = 'Y';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;   -- 미존재 시 원본(@변수 미설정)과 동일하게 NULL 유지
	END;

	DBMS_OUTPUT.PUT_LINE(v_from_yyyymm);

	-- 중장기 계획 날짜 결과셋 반환
	OPEN p_cursor2 FOR
	SELECT v_valid_yn AS VALID_YN
		, v_from_yyyymm AS START_YYYYMM
	    , v_to_yyyymm AS END_YYYYMM
	    , MIN(A.START_YYYYQQ) AS START_YYYYQQ
	    , MAX(A.END_YYYYQQ) AS END_YYYYQQ
	    , MIN(A.START_YYYY) AS START_YYYY
	    , MAX(A.END_YYYY) AS END_YYYY
	FROM (
	    SELECT
	          MIN(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS START_YYYYQQ
	        , MAX(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS END_YYYYQQ
	        , TO_CHAR(NULL) AS START_YYYY   -- [Set Operator 타입일치] CALENDAR_YYYY 가 VARCHAR2 이므로 NULL 을 TO_CHAR 로 캐스팅 (ORA-01790 회피)
	        , TO_CHAR(NULL) AS END_YYYY
	    FROM SCM_SYS_CALENDAR_M A
	       , (
	            SELECT DISTINCT CALENDAR_YYYYQQ
	            FROM SCM_SYS_CALENDAR_M A
	            WHERE BASIS_YYYYMM <  v_from_yyyymm
	                OR BASIS_YYYYMM > v_to_yyyymm
	                ) B
	    WHERE A.CALENDAR_YYYYQQ = B.CALENDAR_YYYYQQ(+)   -- [C-261/2-526] Outer Join → (+) 전환 (anti-join: IS NULL 과 함께)
	        AND A.BASIS_YYYYMM BETWEEN v_from_yyyymm AND v_to_yyyymm
	        AND B.CALENDAR_YYYYQQ IS NULL
	    UNION ALL
	    SELECT
	          TO_CHAR(NULL) AS START_YYYYQQ
	        , TO_CHAR(NULL) AS END_YYYYQQ
	        , MIN(A.CALENDAR_YYYY) AS START_YYYY
	        , MAX(A.CALENDAR_YYYY) AS END_YYYY
	    FROM SCM_SYS_CALENDAR_M A
	       , (
	            SELECT DISTINCT CALENDAR_YYYY
	            FROM SCM_SYS_CALENDAR_M A
	            WHERE BASIS_YYYYMM <  v_from_yyyymm
	                OR BASIS_YYYYMM > v_to_yyyymm
	                ) B
	    WHERE A.CALENDAR_YYYY = B.CALENDAR_YYYY(+)   -- [C-261/2-526] Outer Join → (+) 전환 (anti-join: IS NULL 과 함께)
	        AND A.BASIS_YYYYMM BETWEEN v_from_yyyymm AND v_to_yyyymm
	        AND B.CALENDAR_YYYY IS NULL
	    ) A;

END;
/
