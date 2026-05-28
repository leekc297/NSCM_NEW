/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0042.sql
 * Description  : Standalone Procedures — DMF0042 화면 (12개)
 *              : 향후 PKG_DMF0042로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA
(
--DECLARE
    p_division_id              VARCHAR2,
	p_dept_id                  VARCHAR2,
    p_end_customer             VARCHAR2,
	p_scm_site_id              VARCHAR2,
    p_project_code             VARCHAR2,
	p_item_id                  VARCHAR2,
	p_item_type                VARCHAR2,
	p_from_yyyymmdd            VARCHAR2,
	p_now_yyyymmdd             VARCHAR2,
	p_to_yyyymmdd              VARCHAR2,
	p_created_by               VARCHAR2,
	p_plant_site_id            VARCHAR2,
	p_biztype                  VARCHAR2,
	p_userinfo                 VARCHAR2,
	p_owner					VARCHAR2,
	p_qty_yn					VARCHAR2
/*=====================================================================================================================================================
 * Program ID  : DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date        In Charge    Description
 *=====================================================================================================================================================
 * 2019/04/11	JYE			Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/05/13	JYE			40사업부는 Incoterms, Fcst type, Dom exp 필수 제외
 * 2019/08/26	JYE			칼럼 수정
 * 2019/09/05	JYE			LEFT JOIN 으로 변경
 * 2019/10/02   KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019/10/18   KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 2020/03/11   KHSONG		C20200103-000586 권한그룹을 LOOKUP
 * 2020/04/08	P.C.I		PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
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
 *===================================================================================================================================================*/
)
AS

--SELECT p_division_id='40', p_dept_id='ALL', p_end_customer='ALL', p_scm_site_id='ALL', p_project_code='', p_item_id='', p_item_type='ALL', p_from_yyyymmdd='20220601', p_now_yyyymmdd='20220601'
--	, p_to_yyyymmdd='20221231', p_created_by='rosia27', p_plant_site_id='ALL', p_biztype='ALL', p_userinfo='ADMIN', p_owner='', p_qty_yn=''

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:22
 * 파일: dbo.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA.sql
 * ----------------------------------------
 * ⚠ IF: IF:5  END IF:4  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L66, L1134, L1169
 * END;  위치: L811, L1201, L1299
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    V_Prod VARCHAR2(MAX);
    V_ColList VARCHAR2(MAX);
    V_GroupList VARCHAR2(MAX);
    v_nsql VARCHAR2(4000 CHAR);
    v_nsql2 VARCHAR2(4000 CHAR);
    p_program_id VARCHAR2(50 CHAR) := 'DMF0042';
    V_MEASURE INTEGER := 0;
    i_count INTEGER := 0;
    v_dept_id VARCHAR2(50 CHAR) := NULL;
    v_group_id VARCHAR2(50 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
BEGIN






  V_ColList := NULL;
  V_GroupList := NULL;
  V_Prod := NULL;




	p_from_yyyymmdd := SUBSTR(p_from_yyyymmdd, 1,6);
	p_to_yyyymmdd := SUBSTR(p_to_yyyymmdd, 1,6)

	-- 사용자의 팀정보 & 권한
	SELECT NVL(,(	SELECTSEGMENT3
  INTO v_dept_id
									  from  SCM_ADM_LOOKUP_MASTER_DETAIL
									 where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
										AND VALID_YN = 'Y'
										and SEGMENT1         =   U.DEPT_ID
								) , U.DEPT_ID
								)
	FROM   TB_FX_User U
	WHERE  U.UserID = p_created_by

	--IF p_userinfo = 'ADMIN' OR p_userinfo = 'DM ADMIN'
	--	v_group_id := 'ADMIN'
 --
FETCH FIRST 1 ROWS ONLY;
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	-- ------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
	AND SEGMENT1 = p_userinfo;
	IF v_cnt_1 > 0 THEN
			v_group_id := 'ADMIN';
		END IF;
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- ------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	-- ---------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

	-- ---------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	-- ---------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RAW_DATA';
	-- ---------------------------------------------------------------------------------------
	--                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (BEGIN)
	-- ---------------------------------------------------------------------------------------
    -- 20191002 KHSONG 주석처리 (BEGIN)
	/*
	  -- 기존로직
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT *
	FROM DM_MST_ITEM_SINGLE_V
	  WHERE DIVISION_ID = p_division_id;
		--and CASE WHEN p_item_id IS NULL			THEN p_item_id			ELSE ITEM_ID			END  in  (SELECT DISTINCT token FROM TABLE(fn_string_split(p_item_id,','		)))
	*/
    -- 20191002 KHSONG 주석처리 (END)

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--원소스 주석처리
	/*
	-- --------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
	-- --------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		,ENERGE AS ENERGE_WH
		,CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (TO_NUMBER(ROUND((TO_NUMBER(ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
	 FROM
			(SELECT *
			FROM DM_MST_ITEM_SINGLE_V T2
					INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b
							ON	T2.ITEM_ID		like  b.tst
							OR	T2.NICK_NAME	like  b.tst
			  WHERE DIVISION_ID = p_division_id
			) G;
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		,ENERGE --[E20240731-000852]_ENERGE 컬럼 추가
	-- --------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-- --------------------------------------------------------------------------------------
	*/
	DBMS_OUTPUT.PUT_LINE('A--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_ORI-->GT_DMF0_DM_MST_ITEM_SINGLE_ORI */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_ORI
	SELECT *
	FROM SCM_MST_ITEM_SN
	WHERE DIVISION_ID = p_division_id;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_A_V-->GT_DMF0_DM_MST_ITEM_SINGLE_A_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_A_V
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
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_B_V-->GT_DMF0_DM_MST_ITEM_SINGLE_B_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_B_V
	SELECT DIVISION_ID
		 , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DIVISION_ID
		 , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE
		 , ENERGE
		 , CELL_QUANTITY
		 , SCP_EXTRA_SPEC
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (TO_NUMBER(ROUND((TO_NUMBER(ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
	FROM
	(
		SELECT T1.DIVISION_ID
			 , T1.ITEM_ID
			 , T1.ITEM_NAME							AS ITEM_NAME
			 , T1.ITEM_CLASS						AS ITEM_CLASS
			 , T1.ITEM_CLASS_NAME					AS ITEM_CLASS_NAME
			 , T1.NICK_NAME							AS NICK_NAME
			 , T1.ITEM_TYPE							AS ITEM_TYPE
			 , T1.MATERIAL_CLASS_NAME				AS MATERIAL_CLASS_NAME
			 , T1.ITEM_UOM							AS ITEM_UOM
			 , T1.SPEC								AS SPEC
			 , T1.MDM_PROJECT_NAME					AS MDM_PROJECT_NAME
			 , T1.MIN_CAPACITY						AS MIN_CAPACITY
			 , T2.FORECAST_INFO_BIZ_TYPE			AS FORECAST_INFO_BIZ_TYPE
			 , T2.FORECAST_INFO_PRODUCT_GROUP		AS FORECAST_INFO_PRODUCT_GROUP
			 , T2.FORECAST_INFO_CELL_MODEL			AS FORECAST_INFO_CELL_MODEL
			 , T2.FORECAST_INFO_CELL_PACK_COUNT		AS FORECAST_INFO_CELL_PACK_COUNT
			 , T2.FORECAST_INFO_SPEC				AS FORECAST_INFO_SPEC
			 , T2.FORECAST_INFOR_VERSION			AS FORECAST_INFOR_VERSION
			 , T1.ACTIVE_FLAG						AS ACTIVE_FLAG
			 , T2.CELL_TYPE							AS CELL_TYPE
			 , T1.ENERGE							AS ENERGE
			 , T1.CELL_QUANTITY						AS CELL_QUANTITY
			 , T1.SCP_EXTRA_SPEC					AS SCP_EXTRA_SPEC
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_A_V T1
		INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_B_V T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b
				ON	T1.ITEM_ID		like  b.tst
				OR	T1.NICK_NAME	like  b.tst
		WHERE 1=1
	) T2;
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

DBMS_OUTPUT.PUT_LINE('B--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


	CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V ON GT_DMF0_DM_MST_ITEM_SINGLE_V
	(division_id   ASC
	,item_id       ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY

	-- ---------------------------------------------------------------------------------------
	--                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	-- ---------------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	-- ---------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_SCM_MST_SSO_USER_INFO-->GT_DMF0_SCM_MST_SSO_USER_INFO */
	INSERT INTO GT_DMF0_SCM_MST_SSO_USER_INFO
	SELECT *
	FROM SCM_MST_SSO_USER_INFO
	  ORDER BY USER_ID;


	-- 2020.4.23 속도문제로 쿼리 변경
	/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM-->GT_DMF0_SCM_MST_SITE_ITEM */
	INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM
	SELECT *
		, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		,( SELECT SU.DEPT_ID  FROM GT_DMF0_SCM_MST_SSO_USER_INFO SU  WHERE SU.USER_ID
			= (SELECTtoken FROM TABLE(fn_string_split(SMSI.owner, ','))) ) DEPT_ID
		,SMSI.SALES_PLAN_ADJUST_YN AS EDIT_FLAG
	FROM SCM_MST_SITE_ITEM SMSI
	WHERE SMSI.Division_id = p_division_id;


	-- ---------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	-- ---------------------------------------------------------------------------------------
/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.
*/

FETCH FIRST 1 ROWS ONLY
	/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
	INSERT INTO GT_DMF0_SELECT_MEASURE
	SELECT U.PROGRAM_ID
			, U.SHEET_NAME
			--, U.USER_ID
			, U.COLUMN_NAME AS MEASURE
			, U.SORT_ORDER_NO
	FROM SCM_MST_SHEET_MEASURE U
	WHERE 1 = 1
	--AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID   = p_program_id
	AND U.DIVISION_ID LIKE '%'  ||  p_division_id  ||  '%';
	--AND U.USER_ID      = p_created_by

			-- -----------------------------------------------
			-- (1) DM_PLN_BP_FCST
			-- -----------------------------------------------
    IF p_division_id = '40' THEN
            INSERT INTO GT_DMF0_RAW_DATA
			SELECT
				A.DIVISION_ID
				,A.PROJECT_CODE
				,A.PROJECT_CODE AS END_CUSTOMER40
				--,A.SCM_SITE_ID
				,PLANT_SITE_ID
				,A.ITEM_ID
				,A.INCOTERMS  -- PJ20200138 Incoterms 삭제
				--,A.INCOTERMS AS INCOTERMS82 -- PJ20200138 Incoterms 삭제
				--,A.DOM_EXP
				,A.FCST_TYPE
				,A.MEASURE
				--[E20240731-000845]_조회당시 코드값으로 넘기도록 수정(원소스 주석처리)
				--,LK1.ATTRIBUTE1 AS CELL_PROD_SITE
				,LK1.SEGMENT1 AS CELL_PROD_SITE
				,'M_'  ||  YYYYMM AS COLNAME
				,SM.SORT_ORDER_NO
				,CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
				,CAL.CALENDAR_YYYY AS CALENDAR_YYYY
				,A.YYYYMM ,A.QTY
				,CASE WHEN A.CURRENCY IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY
				,ISV.FORECAST_INFO_CELL_PACK_COUNT
				,ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
				--,A.BIZ_TYPE AS BIZ_TYPE_NAME40
				,(SELECT LMD.SEGMENT2  AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD  WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
				,NVL(ISV.ITEM_CLASS_NAME, NULL)AS ITEM_CLASS_NAME
				,NVL(ISV.ITEM_NAME, NULL)AS ITEM_NAME
				,NVL(ISV.ITEM_TYPE, NULL)AS ITEM_TYPE
				,NVL(ISV.NICK_NAME, NULL)AS NICK_NAME
				,ISV.MIN_CAPACITY
				--,CASE WHEN ISV.ITEM_ID IS NULL THEN '' WHEN NVL(SI.EDIT_FLAG, NULL)  = '' THEN '' ELSE 'Y' END + '_'   +
				,CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = v_dept_id THEN 'Y'
						WHEN v_group_id ='ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG
				,SI.APPLICATION
				,SI.CUST_GROUP
				,SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
				,SI.OWNER_NAME OWNER
				--,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID

				--[PJ2024-50461] Team Mapping------------------------------------
				--,A.DEPT_ID  AS DEPT_ID
				, SI.DEPT_ID  AS DEPT_ID
				--[PJ2024-50461] Team Mapping------------------------------------

				,S.VMI_YN
				,SI.ROUTE
				,ISV.FORECAST_INFO_PRODUCT_GROUP
				,ISV.FORECAST_INFO_SPEC || ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
				,ISV.FORECAST_INFO_SPEC
				,ISV.FORECAST_INFOR_VERSION
				,ISV.MDM_PROJECT_NAME
				,SI.CUST_GROUP_DTL
				,NVL(SI.attribute1, NULL) DMS_SALES
				,NVL(SI.attribute2, NULL) DMS_CUSTOMER
				--,MP.BIZ_TYPE as BIZ_TYPE_NAME
				,A.PROJECT_NAME   AS PROJECT_NAME
				,''               AS PROJECT_OWNER
				,''               AS PROJECT_STATUS
				,A.END_CUSTOMER
				,S.CITY_NAME
				,S.COUNTRY_NAME
				--,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- PJ20200138 Incoterms 삭제
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
				,'' AS PRODUCT_GROUP_NAME
				,A.ITEM_USE  -- PJ20200138 item_use, unit_energy 추가
				,A.UNIT_ENERGY
				,0   AS CELL_PER_CAR
				,0   AS MODULE_PER_CAR
				,ISV.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
				,ISV.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
			FROM DM_PLN_BP_FCST A
				INNER JOIN SCM_MST_SITE S1
					ON (A.DIVISION_ID		= S1.DIVISION_ID
					AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
					--AND S1.VALID_YN	  = 'Y'	-- [c20200722-000060]
					)
				INNER JOIN SCM_MST_SITE_ITEM S2
					ON (A.DIVISION_ID		= S2.DIVISION_ID
					AND A.PROJECT_CODE		= S2.PROJECT_CODE
					AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					AND A.ITEM_ID			= S2.ITEM_ID
					--AND S2.VALID_YN			= 'Y'	--[c20200722-000060]
					)
				INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V ISV
					ON A.DIVISION_ID		= ISV.DIVISION_ID
					AND A.ITEM_ID			= ISV.ITEM_ID
				LEFT JOIN GT_DMF0_SCM_MST_SITE_ITEM SI
					 ON A.DIVISION_ID		= SI.DIVISION_ID
					AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					AND A.PROJECT_CODE		= SI.PROJECT_CODE
					AND A.iTEM_ID			= SI.ITEM_ID
					--AND SI.VALID_YN			= 'Y'	--[c20200722-000060]
				LEFT JOIN (
							SELECT X.DIVISION_ID,X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME
							FROM SCM_MST_SITE X , SCM_MST_CITY Y , SCM_MST_COUNTRY z
							WHERE x.city = y.city  and x.country = z.country
						) S;
					ON A.DIVISION_ID		= S.DIVISION_ID
					AND A.SCM_SITE_ID		= S.SCM_SITE_ID
					--AND S.VALID_YN			= 'Y'	--[c20200722-000060]
				LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.CELL_PROD_SITE = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN p_project_code
	    					ELSE A.PROJECT_CODE  END like  b1.tst
					OR   CASE WHEN p_project_code IS NULL THEN p_project_code
							ELSE A.PROJECT_NAME  END like  b1.tst
				-- --------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b2
				ON      CASE WHEN p_item_id IS NULL THEN p_item_id
							ELSE A.ITEM_ID  END like  b2.tst
					OR   CASE WHEN p_item_id IS NULL THEN p_item_id
							ELSE ISV.NICK_NAME  END like  b2.tst
				-- --------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_owner,',')) ) b3
				ON      CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER         END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER_NAME    END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER_NAME_KO END like  b3.tst
				-- --------------------------------------------------------------------------------------------
				INNER JOIN GT_DMF0_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
				INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					FROM SCM_SYS_CALENDAR_M
					WHERE (BASIS_YYYYMM >= p_from_yyyymmdd AND BASIS_YYYYMM <= p_to_yyyymmdd)
					GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) AS CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
				AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
							ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
					END IN (
							Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
				AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   					ELSE NVL(
							CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							, NULL)
					END IN (
							Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
							(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
								CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							, NULL) END) = P.data
							)
				AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.SCM_SITE_ID
					END IN (
							Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
							(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
							)
				AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.PLANT_SITE_ID
					END IN (
							Select * from UF_FX_String_SplitForIN (p_plant_site_id,',') as P Where
							(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
							)
				AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   					ELSE ISV.ITEM_TYPE
					END IN (
							Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where
							(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.data
							)
				AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   					ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END IN (
							Select * from UF_FX_String_SplitForIN (p_biztype,',') as P Where
							(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
							END) = P.data
							)
				AND (A.YYYYMM >= p_from_yyyymmdd and A.YYYYMM <= p_to_yyyymmdd)
				AND A.DIVISION_ID = p_division_id;
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
    ELSE

            INSERT INTO GT_DMF0_RAW_DATA
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
				,PLANT_SITE_ID
				,A.ITEM_ID
				,A.INCOTERMS -- PJ20200138 Incoterms 삭제
				--,A.INCOTERMS AS INCOTERMS82 -- PJ20200138 Incoterms 삭제
				--,A.DOM_EXP
				,A.FCST_TYPE
				,A.MEASURE
				,A.CELL_PROD_SITE
				,'M_'  ||  YYYYMM AS COLNAME
				,SM.SORT_ORDER_NO
				,CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
				,CAL.CALENDAR_YYYY AS CALENDAR_YYYY
				,A.YYYYMM ,A.QTY
				,CASE WHEN A.CURRENCY IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY
				,ISV.FORECAST_INFO_CELL_PACK_COUNT
				,ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
				--,A.BIZ_TYPE AS BIZ_TYPE_NAME40
				,(SELECT LMD.SEGMENT2  AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD  WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
				,NVL(ISV.ITEM_CLASS_NAME, NULL)AS ITEM_CLASS_NAME
				,NVL(ISV.ITEM_NAME, NULL)AS ITEM_NAME
				,NVL(ISV.ITEM_TYPE, NULL)AS ITEM_TYPE
				,NVL(ISV.NICK_NAME, NULL)AS NICK_NAME
				,ISV.MIN_CAPACITY
				--,CASE WHEN ISV.ITEM_ID IS NULL THEN '' WHEN NVL(SI.EDIT_FLAG, NULL)  = '' THEN '' ELSE 'Y' END + '_'   +

				--[PJ2024-50461] Team Mapping------------------------------------
				/*,CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = v_dept_id THEN 'Y'
						WHEN v_group_id ='ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG*/
				,CASE WHEN SI.DEPT_ID = v_dept_id THEN 'Y'
										WHEN v_group_id ='ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG
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
				,ISV.FORECAST_INFO_SPEC || ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
				,ISV.FORECAST_INFO_SPEC
				,ISV.FORECAST_INFOR_VERSION
				,ISV.MDM_PROJECT_NAME
				,SI.CUST_GROUP_DTL
				,NVL(SI.attribute1, NULL) DMS_SALES
				,NVL(SI.attribute2, NULL) DMS_CUSTOMER
							----,MP.BIZ_TYPE as BIZ_TYPE_NAME
				,CASE WHEN MP.PROJECT_NAME IS NULL OR MP.PROJECT_NAME IS NULL THEN A.PROJECT_NAME ELSE MP.PROJECT_NAME END PROJECT_NAME
				,MP.PROJECT_OWNER
				,MP.PROJECT_STATUS
				,A.END_CUSTOMER
				,S.CITY_NAME
				,S.COUNTRY_NAME
				--,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- PJ20200138 Incoterms 삭제
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
				,A.ITEM_USE  -- PJ20200138 item_use, unit_energy 추가
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
				LEFT JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V ISV
					ON A.DIVISION_ID		= ISV.DIVISION_ID
					AND A.ITEM_ID			= ISV.ITEM_ID
				LEFT JOIN GT_DMF0_SCM_MST_SITE_ITEM SI
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
							FROM SCM_MST_SITE X , SCM_MST_CITY Y , SCM_MST_COUNTRY z
							WHERE x.city = y.city  and x.country = z.country
						) S;
					ON A.DIVISION_ID		= S.DIVISION_ID
					AND A.SCM_SITE_ID		= S.SCM_SITE_ID
					--AND S.VALID_YN			= 'Y'	-- [c20200722-000060]
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN p_project_code
	    					ELSE A.PROJECT_CODE  END like  b1.tst
					OR   CASE WHEN p_project_code IS NULL THEN p_project_code
							ELSE A.PROJECT_NAME  END like  b1.tst
				-- --------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,',')) ) b2
				ON      CASE WHEN p_item_id IS NULL THEN p_item_id
							ELSE A.ITEM_ID  END like  b2.tst
					OR   CASE WHEN p_item_id IS NULL THEN p_item_id
							ELSE ISV.NICK_NAME  END like  b2.tst
				-- --------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_owner,',')) ) b3
				ON      CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER         END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER_NAME    END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN p_owner
							ELSE SI.OWNER_NAME_KO END like  b3.tst
				-- --------------------------------------------------------------------------------------------
				INNER JOIN GT_DMF0_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
				INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					FROM SCM_SYS_CALENDAR_M
					WHERE (BASIS_YYYYMM >= p_from_yyyymmdd AND BASIS_YYYYMM <= p_to_yyyymmdd)
					GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) AS CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
			--[PJ2024-50461] Team Mapping------------------------------------
				AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
							ELSE SI.DEPT_ID
					END IN (
							Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								SI.DEPT_ID
							END) = P.data
							)
/*
				AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
							ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
					END IN (
							Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
*/
				--[PJ2024-50461] Team Mapping------------------------------------

				AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   					ELSE NVL(
							CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							, NULL)
					END IN (
							Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
							(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
								CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							, NULL) END) = P.data
							)
				AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.SCM_SITE_ID
					END IN (
							Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
							(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
							)
				AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.PLANT_SITE_ID
					END IN (
							Select * from UF_FX_String_SplitForIN (p_plant_site_id,',') as P Where
							(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
							)
				AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   					ELSE ISV.ITEM_TYPE
					END IN (
							Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where
							(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.data
							)
				AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   					ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END IN (
							Select * from UF_FX_String_SplitForIN (p_biztype,',') as P Where
							(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
							END) = P.data
							)
				AND (A.YYYYMM >= p_from_yyyymmdd and A.YYYYMM <= p_to_yyyymmdd)
				AND A.DIVISION_ID = p_division_id
                AND ( ( p_item_id IS NULL OR  p_item_id     IS NULL ) OR A.ITEM_ID   IN (SELECT token FROM TABLE(fn_string_split(p_item_id    ,','))) );
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'

        END

		IF p_qty_yn = 'Y' THEN
			/* TODO:GTT:GT_DMF0_DLT_ITEM_ID-->GT_DMF0_DLT_ITEM_ID */
			INSERT INTO GT_DMF0_DLT_ITEM_ID
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.FCST_TYPE, A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER
				, A.MEASURE, A.ITEM_ID40, A.SCM_SITE_ID40, A.SCM_SITE_ID81, A.SCM_SITE_ID82, A.DEPT_ID40, A.PROJECT_CODE82, A.END_CUSTOMER40, A.FCST_TYPE40
				, A.INCOTERMS, A.CURRENCY, A.CELL_PROD_SITE
				--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
				, A.ENERGE_WH, A.ENERGE_KWH
			FROM GT_DMF0_RAW_DATA A
			INNER JOIN  (
				SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
					, ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
					, INCOTERMS, CURRENCY, CELL_PROD_SITE
				FROM GT_DMF0_RAW_DATA
				WHERE MEASURE = 'Business_Plan'
				GROUP BY DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
					, ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
					, INCOTERMS, CURRENCY, CELL_PROD_SITE
				HAVING SUM(QTY) = 0) AS B
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

			--SELECT* FROM GT_DMF0_DLT_ITEM_ID

			DELETE A FROM GT_DMF0_RAW_DATA A
			INNER JOIN GT_DMF0_DLT_ITEM_ID B
					ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.PROJECT_CODE		= B.PROJECT_CODE
					AND A.ITEM_ID			= B.ITEM_ID
					AND A.FCST_TYPE			= B.FCST_TYPE
					AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					AND A.DEPT_ID			= B.DEPT_ID
					AND A.END_CUSTOMER		= B.END_CUSTOMER
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
		END IF;

--select * from GT_DMF0_RAW_DATA
-- ################ GT_DMF0_RAW_DATA ###########################

    DBMS_OUTPUT.PUT_LINE('------------- -1! : '  ||   TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- Quarter SUM
	--INSERT INTO GT_DMF0_RAW_DATA
	/* TODO:GTT:GT_DMF0_RAW_DATA_SUM-->GT_DMF0_RAW_DATA_SUM */
	INSERT INTO GT_DMF0_RAW_DATA_SUM
	SELECT
		X.DIVISION_ID
		,X.PROJECT_CODE
		,X.END_CUSTOMER40
		--,X.SCM_SITE_ID
		,X.PLANT_SITE_ID
		,X.ITEM_ID
		,X.INCOTERMS -- PJ20200138 Incoterms 삭제
		--,X.INCOTERMS82 -- PJ20200138 Incoterms 삭제
		--,X.DOM_EXP
		,X.FCST_TYPE
		,X.MEASURE
		,X.CELL_PROD_SITE
		, 'Q_'  ||  REPLACE(CALENDAR_YYYYQQ, 'Q', '_') AS COLNAME
		,X.SORT_ORDER_NO
		,  X.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
		,X.CALENDAR_YYYY
		,  X.CALENDAR_YYYYQQ AS YYYYMM
		--,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		,CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
			THEN SUM(QTY)
			ELSE MAX(QTY)
		END QTY
		,X.CURRENCY
		,MAX(X.FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
		,MAX(X.BIZ_TYPE_NAME40) BIZ_TYPE_NAME40
		,MAX(X.CELL_TYPE) CELL_TYPE
		,MAX(X.ITEM_CLASS_NAME) ITEM_CLASS_NAME
		,MAX(X.ITEM_NAME) ITEM_NAME
		,MAX(X.ITEM_TYPE) ITEM_TYPE
		,MAX(X.NICK_NAME) NICK_NAME
		,MAX(X.MIN_CAPACITY) MIN_CAPACITY
		,MAX(X.EDIT_FLAG) EDIT_FLAG
		,MAX(X.APPLICATION) APPLICATION
		,MAX(X.CUST_GROUP) CUST_GROUP
		,MAX(X.FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
		,MAX(X.OWNER) OWNER
		,X.DEPT_ID AS DEPT_ID
		,MAX(X.VMI_YN) VMI_YN
		,MAX(X.ROUTE) ROUTE
		,MAX(X.FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
		,MAX(X.FORECAST_INFO_ALL) FORECAST_INFO_ALL
		,MAX(X.FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
		,MAX(X.FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
		,MAX(X.MDM_PROJECT_NAME) MDM_PROJECT_NAME
		,MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
		,MAX(X.DMS_SALES) DMS_SALES
		,MAX(X.DMS_CUSTOMER) DMS_CUSTOMER
		--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		,MAX(X.PROJECT_NAME) PROJECT_NAME
		,MAX(X.PROJECT_OWNER) PROJECT_OWNER
		,MAX(X.PROJECT_STATUS) PROJECT_STATUS
		,MAX(X.END_CUSTOMER) END_CUSTOMER
		,MAX(X.CITY_NAME) CITY_NAME
		,MAX(X.COUNTRY_NAME) COUNTRY_NAME
		--,MAX(X.INCOTERMS40)	INCOTERMS40 		-- 20190513 -- PJ20200138 Incoterms 삭제
		,MAX(X.FCST_TYPE40)	FCST_TYPE40			-- 20190513
		--,MAX(X.DOM_EXP40)		DOM_EXP40 			-- 20190513
		,MAX(X.REPORT_GROUP1) AS REPORT_GROUP1
		,MAX(X.REPORT_GROUP2) AS REPORT_GROUP2
		,MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		,MAX(X.REPORT_GROUP4) AS REPORT_GROUP4
		,MAX(X.REPORT_GROUP5) AS REPORT_GROUP5
		,MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		,MAX(X.REPORT_GROUP7) AS REPORT_GROUP7
		,MAX(X.REPORT_GROUP8) AS REPORT_GROUP8

		-- 201990826
		,MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81
		,MAX(X.PROJECT_CODE82) AS PROJECT_CODE82
		,MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		,MAX(X.ITEM_ID40) AS ITEM_ID40
		,MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40
		,MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		,MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
		--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK
		--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE
		--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		,MAX(X.DEPT_ID40) AS DEPT_ID40
		-- 201990826
		,X.PRODUCT_GROUP_NAME
		,X.ITEM_USE -- PJ20200138 item_use, unit_energy 추가
		,X.UNIT_ENERGY
		,MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
		,MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
	FROM GT_DMF0_RAW_DATA X
	GROUP BY;
		X.DIVISION_ID
		, X.PROJECT_CODE
		, X.PROJECT_NAME
		, X.END_CUSTOMER
		, X.END_CUSTOMER40
		, X.SCM_SITE_ID40
		, X.SCM_SITE_ID81
		, X.SCM_SITE_ID82
		, X.PLANT_SITE_ID
		, X.ITEM_ID
		, X.ITEM_ID40
		, X.DEPT_ID
		, X.INCOTERMS -- PJ20200138 Incoterms 삭제
		--, X.INCOTERMS82 -- PJ20200138 Incoterms 삭제
		--, X.DOM_EXP
		, X.FCST_TYPE
		, X.SORT_ORDER_NO
		, X.BIZ_TYPE_NAME40
		, X.BIZ_TYPE_NAME81
		, X.BIZ_TYPE_NAME82
		, X.CALENDAR_YYYY
		, X.CALENDAR_YYYYQQ
		, X.CURRENCY
		, X.MEASURE
		, X.PRODUCT_GROUP_NAME
		, X.ITEM_USE -- PJ20200138 item_use, unit_energy 추가
		, X.UNIT_ENERGY
		, X.CELL_PROD_SITE
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
DBMS_OUTPUT.PUT_LINE('-------------0! : '  ||   TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

--SELECT * FROM GT_DMF0_RAW_DATA
--SELECT * FROM GT_DMF0_RAW_DATA_SUM
	-- Year SUM
	INSERT INTO GT_DMF0_RAW_DATA_SUM
	SELECT
		X.DIVISION_ID
		,X.PROJECT_CODE
		,X.END_CUSTOMER40
		--,X.SCM_SITE_ID
		,X.PLANT_SITE_ID
		,X.ITEM_ID
		,X.INCOTERMS -- PJ20200138 Incoterms 삭제
		--,X.INCOTERMS82 -- PJ20200138 Incoterms 삭제
		--,X.DOM_EXP
		,X.FCST_TYPE
		,X.MEASURE
		,X.CELL_PROD_SITE
		, 'Y_'  ||  X.CALENDAR_YYYY AS COLNAME
		,X.SORT_ORDER_NO
		,  X.CALENDAR_YYYY AS CALENDAR_YYYYQQ
		,X.CALENDAR_YYYY
		,  X.CALENDAR_YYYY AS YYYYMM
		--,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		,CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
			THEN SUM(QTY)
			ELSE MAX(QTY)
		END QTY
		,X.CURRENCY
		,MAX(X.FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
		,MAX(X.BIZ_TYPE_NAME40) BIZ_TYPE_NAME40
		,MAX(X.CELL_TYPE) CELL_TYPE
		,MAX(X.ITEM_CLASS_NAME) ITEM_CLASS_NAME
		,MAX(X.ITEM_NAME) ITEM_NAME
		,MAX(X.ITEM_TYPE) ITEM_TYPE
		,MAX(X.NICK_NAME) NICK_NAME
		,MAX(X.MIN_CAPACITY) MIN_CAPACITY
		,MAX(X.EDIT_FLAG) EDIT_FLAG
		,MAX(X.APPLICATION) APPLICATION
		,MAX(X.CUST_GROUP) CUST_GROUP
		,MAX(X.FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
		,MAX(X.OWNER) OWNER
		,X.DEPT_ID AS DEPT_ID
		,MAX(X.VMI_YN) VMI_YN
		,MAX(X.ROUTE) ROUTE
		,MAX(X.FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
		,MAX(X.FORECAST_INFO_ALL) FORECAST_INFO_ALL
		,MAX(X.FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
		,MAX(X.FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
		,MAX(X.MDM_PROJECT_NAME) MDM_PROJECT_NAME
		,MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
		,MAX(X.DMS_SALES) DMS_SALES
		,MAX(X.DMS_CUSTOMER) DMS_CUSTOMER
		--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		,MAX(X.PROJECT_NAME) PROJECT_NAME
		,MAX(X.PROJECT_OWNER) PROJECT_OWNER
		,MAX(X.PROJECT_STATUS) PROJECT_STATUS
		,MAX(X.END_CUSTOMER) END_CUSTOMER
		,MAX(X.CITY_NAME) CITY_NAME
		,MAX(X.COUNTRY_NAME) COUNTRY_NAME
		--,MAX(X.INCOTERMS40)	INCOTERMS40 		-- 20190513 -- PJ20200138 Incoterms 삭제
		,MAX(X.FCST_TYPE40)	FCST_TYPE40			-- 20190513
		--,MAX(X.DOM_EXP40)		DOM_EXP40 			-- 20190513
		,MAX(X.REPORT_GROUP1) AS REPORT_GROUP1
		,MAX(X.REPORT_GROUP2) AS REPORT_GROUP2
		,MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		,MAX(X.REPORT_GROUP4) AS REPORT_GROUP4
		,MAX(X.REPORT_GROUP5) AS REPORT_GROUP5
		,MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		,MAX(X.REPORT_GROUP7) AS REPORT_GROUP7
		,MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		-- 201990826
		,MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81
		,MAX(X.PROJECT_CODE82) AS PROJECT_CODE82
		,MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		,MAX(X.ITEM_ID40) AS ITEM_ID40
		,MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40
		,MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		,MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
		--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK
		--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE
		--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		,MAX(X.DEPT_ID40) AS DEPT_ID40
		-- 201990826
		,X.PRODUCT_GROUP_NAME
		,X.ITEM_USE -- PJ20200138 item_use, unit_energy 추가
		,X.UNIT_ENERGY
		,MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
		,MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
	FROM GT_DMF0_RAW_DATA X
	GROUP BY;
		X.DIVISION_ID
		, X.PROJECT_CODE
		, X.PROJECT_NAME
		, X.END_CUSTOMER
		, X.END_CUSTOMER40
		, X.SCM_SITE_ID40
		, X.SCM_SITE_ID81
		, X.SCM_SITE_ID82
		, X.PLANT_SITE_ID
		, X.ITEM_ID
		, X.ITEM_ID40
		, X.DEPT_ID
		, X.INCOTERMS -- PJ20200138 Incoterms 삭제
		--, X.INCOTERMS82 -- PJ20200138 Incoterms 삭제
		--, X.DOM_EXP
		, X.FCST_TYPE
		, X.SORT_ORDER_NO
		, X.BIZ_TYPE_NAME40
		, X.BIZ_TYPE_NAME81
		, X.BIZ_TYPE_NAME82
		, X.CALENDAR_YYYY
		, X.CALENDAR_YYYYQQ
		, X.CURRENCY
		, X.MEASURE
		, X.PRODUCT_GROUP_NAME
		, X.ITEM_USE -- PJ20200138 item_use, unit_energy 추가
		, X.UNIT_ENERGY
		, X.CELL_PROD_SITE
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH

	-- ################ GT_DMF0_RAW_DATA and Quarter&Year Sum ###########################

	INSERT INTO GT_DMF0_RAW_DATA
	SELECT *
	FROM GT_DMF0_RAW_DATA_SUM;

    DBMS_OUTPUT.PUT_LINE('-------------1! : '  ||   TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

BEGIN
    SELECT  Count(*)
  INTO i_Count
		FROM   SCM_MST_TITLESET_USER U
			WHERE  1 = 1
			AND    U.PROGRAM_ID  = p_Program_Id
			AND    U.SHEET_NAME  = 'Biz Plan'
			AND    U.USER_ID     = p_created_by
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

	--print i_Count

	IF i_Count = 0 THEN
			SELECT V_ColList = V_ColList  ||  '['  ||  COLUMN_NAME  ||  '],'
				   , V_GroupList = V_GroupList  ||  '['  ||  COLUMN_NAME  ||  '] '  ||  DATA_SORT_METHOD_CODE  ||  ','
				FROM
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT
							C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
						FROM SCM_MST_SHEET_COLUMNS C
						WHERE 1 = 1
							AND    C.PROGRAM_ID  = p_Program_Id
							AND    C.SHEET_NAME  = 'Biz Plan'
							AND    ( C.DEFAULT_FLAG = 'Y' OR
								(    C.VISIBLE_FLAG = ''
								AND    C.DEFAULT_FLAG IS NULL
								AND    C.VALID_YN     = 'Y'
								)
								)
				) tbColList;
			ORDER BY SORT_ORDER_NO;

	ELSE

		BEGIN
			SELECT V_ColList = V_ColList  ||  '['  ||  COLUMN_NAME  ||  '],'
				   , V_GroupList = V_GroupList  ||  '['  ||  COLUMN_NAME  ||  '] '  ||  DATA_SORT_METHOD_CODE  ||  ','
				FROM
					(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT
						U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
					FROM   SCM_MST_TITLESET_USER U
								 , SCM_MST_SHEET_COLUMNS C
					WHERE  1 = 1
							AND    U.PROGRAM_ID  = C.PROGRAM_ID
							AND    U.SHEET_NAME  = C.SHEET_NAME
							AND    U.COLUMN_NAME = C.COLUMN_NAME
							AND    U.PROGRAM_ID  = p_Program_Id
							AND    U.SHEET_NAME  = 'Biz Plan'
							AND    U.USER_ID     = p_created_by
							AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
							AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
					UNION ALL
					SELECTC.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					FROM   SCM_MST_SHEET_COLUMNS C
					WHERE  1 = 1
							AND    C.PROGRAM_ID  = p_Program_Id
							AND    C.SHEET_NAME  = 'Biz Plan'
							AND    C.VISIBLE_FLAG = ''
							AND    C.DEFAULT_FLAG IS NULL
							AND    C.VALID_YN     = 'Y'
							AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
					) tbColList;
			ORDER BY SORT_ORDER_NO
FETCH FIRST 100 ROWS ONLY
		END;
	END IF;

	SELECT SUBSTR(V_ColList, 1, LENGTH(V_ColList)-1),
    SUBSTR(V_GroupList, 1, LENGTH(V_GroupList)-1),
    V_Prod  ||  '['  ||  A.COLNAME  ||  ']
  INTO V_ColList, V_GroupList, V_Prod
			FROM (SELECT DISTINCT COLNAME FROM GT_DMF0_RAW_DATA ) A
		ORDER BY COLNAME;

		IF V_Prod = '' THEN
				V_Prod := 'D_99999999';
		ELSE
				Select V_Prod = SUBSTR(V_Prod, 1, LENGTH(V_Prod)-1)
			END IF;
    DBMS_OUTPUT.PUT_LINE('-------------3! : ' +  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


-- 6. 최종 피벗 내기.
-- MEASURE에 따른 앞에 SORT_ORDER_NO 위한 삽입

SELECT REPLACE(V_ColList,'MEASURE','SORT_ORDER_NO,MEASURE'),
    REPLACE(V_GroupList,'MEASURE','SORT_ORDER_NO,MEASURE'),
    REPLACE(V_GroupList,'CELL_PER_CAR ASC,MODULE_PER_CAR ASC,', '')
  INTO V_ColList, V_GroupList, V_GroupList
		From(
			--SELECT COLNAME, SUM(QTY) AS QTY, ' + V_ColList + '
			SELECT COLNAME, case when MEASURE in (''LOC'',''USD'',''KRW'') then MAX(QTY) else SUM(QTY) end AS QTY, ' + V_ColList + '  -- 20190108 KHSONG Unit Price 인경우는 SUM하지 않고 AVG로 표기함
			FROM GT_DMF0_RAW_DATA
			GROUP BY COLNAME, ' + V_ColList + '
			) T;
		PIVOT (MAX(QTY) FOR COLNAME IN (' + v_prod + ')
		) AS PVT

		ORDER BY;
				 ' + V_GroupList + '
		'

--SELECT V_GroupList
--select v_nsql2
     --select CAST(v_nsql2 AS text)
     --for xml path('')--,root('x')

execute SP_executesql V_NSQL2

--중장기 계획 관련 날짜 취득
DECLARE V_FROM_YYYYMM NCHAR(6), TO_YYYYMM NCHAR(6), V_VALID_YN NCHAR(1);

SELECT ATTRIBUTE1,
    VALID_YN
  INTO V_FROM_YYYYMM, V_VALID_YN
FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
WHERE A.LOOKUP_TYPE = 'DM_LONG_PLAN'
AND A.SEGMENT1 = p_division_id
AND A.SEGMENT2 = 'Biz Plan'
AND A.VALID_YN = 'Y';

DBMS_OUTPUT.PUT_LINE(V_FROM_YYYYMM);

SELECT V_VALID_YN AS VALID_YN
	, V_FROM_YYYYMM AS START_YYYYMM
    , TO_YYYYMM AS END_YYYYMM
    , MIN(A.START_YYYYQQ) AS START_YYYYQQ
    , MAX(A.END_YYYYQQ) AS END_YYYYQQ
    , MIN(A.START_YYYY) AS START_YYYY
    , MAX(A.END_YYYY) AS END_YYYY
FROM (
    SELECT
          MIN(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS START_YYYYQQ
        , MAX(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS END_YYYYQQ
        , NULL AS START_YYYY
        , NULL AS END_YYYY
    FROM SCM_SYS_CALENDAR_M A
    LEFT OUTER JOIN (
            SELECT DISTINCT CALENDAR_YYYYQQ
            FROM SCM_SYS_CALENDAR_M A
            WHERE BASIS_YYYYMM <  V_FROM_YYYYMM
                OR BASIS_YYYYMM > TO_YYYYMM
                ) B ON A.CALENDAR_YYYYQQ = B.CALENDAR_YYYYQQ
    WHERE A.BASIS_YYYYMM BETWEEN V_FROM_YYYYMM AND TO_YYYYMM
        AND B.CALENDAR_YYYYQQ IS NULL
    UNION ALL
    SELECT
          NULL AS START_YYYYMM
        , NULL AS END_YYYYMM
        , MIN(A.CALENDAR_YYYY) AS START_YYYY
        , MAX(A.CALENDAR_YYYY) AS END_YYYY
    FROM SCM_SYS_CALENDAR_M A
    LEFT OUTER JOIN (
            SELECT DISTINCT CALENDAR_YYYY
            FROM SCM_SYS_CALENDAR_M A
            WHERE BASIS_YYYYMM <  V_FROM_YYYYMM
                OR BASIS_YYYYMM > TO_YYYYMM
                ) B ON A.CALENDAR_YYYY = B.CALENDAR_YYYY
    WHERE A.BASIS_YYYYMM BETWEEN V_FROM_YYYYMM AND TO_YYYYMM
        AND B.CALENDAR_YYYY IS NULL
    ) A;

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF
(

    -- Add the parameters for the stored procedure here
      p_division_id          VARCHAR2    -- division_id 전달받음
    , p_version_description  VARCHAR2  -- description 전달받음
    , p_ver_type             VARCHAR2
    , p_created_by           VARCHAR2
/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF
 * Description  : Business Plan DM_PLN_BP_FCST_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190617 KHSONG DM_BP_EXCHANGE_RATE => DM_BP_EXCHANGE_RATE_C (6/11 추가)
 * 2020/04/23	P.C.I    PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/07/26	SJHAN	중장기계획 과제 관련 - SEQ 추가
 * 2022/04/12	rosia27		과제PJ20216891RGM_JV
 * 2022/06/10	rosia27		[C20220526-000090]Business Plan Waterfall 개발 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:23
 * 파일: dbo.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:3  END:4  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L48, L103, L134
 * END;  위치: L131, L152, L192
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    n_history_seq INTEGER;
    v_program_name VARCHAR2(150 CHAR) := 'DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_division_id VARCHAR2(4000 CHAR);
    v_ver_description VARCHAR2(4000 CHAR);
    v_ver_type VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_ver_return_no VARCHAR2(100 CHAR);
    v_cutoff_yyyymmdd VARCHAR2(4000 CHAR);
    v_OK_description VARCHAR2(1200 CHAR);
    n_Seq_No INTEGER := 0;
BEGIN















    v_division_id := NULL;
    v_ver_description := NULL;
    v_ver_type := NULL;
    v_created_by := NULL;
    v_cutoff_yyyymmdd := TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD');

    -- 시작 LOG  (START)
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)

    -- -----------------------------------------------------------------------------------------
    BEGIN TRY
    -- -----------------------------------------------------------------------------------------
        v_ver_description := p_version_description;
        v_ver_type := 'BP_M';
        v_created_by := p_created_by;

        v_division_id := p_division_id;

        PR_DM_PLN_VERSION_CREATE
                v_division_id,
                v_ver_description,
                v_ver_type,
                v_created_by,
                v_ver_return_no  OUTPUT,
                v_OK_description OUTPUT

        -- DM_PLN_BP_FCST -> DM_PLN_BP_FCST_C

		SELECT MAX(NVL(SEQ_NO,0)) || 1
  INTO n_Seq_No
		FROM DM_PLN_BP_FCST_C A;
        BEGIN

            INSERT INTO DM_PLN_BP_FCST_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
				 , PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
                 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY --PJ20200138 item_use, unit_energy 추가
				 , QTY, CELL_PER_PACK
                 , CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
                 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
                 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, CELL_PROD_SITE )
            SELECT A.DIVISION_ID, v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
                 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 , A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER, A.BIZ_TYPE
                 , A.YYYYMM, A.CURRENCY, ITEM_USE, UNIT_ENERGY --PJ20200138 item_use, unit_energy 추가
				 , A.QTY, A.CELL_PER_PACK
                 , A.CELL_PER_MODULE, A.MODULE_PER_PACK, A.CREATED_BY, A.CREATION_DATE
                 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2
                 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				 , ROW_NUMBER() OVER(ORDER BY DIVISION_ID)	-- 2021/07/26 SJHAN 중장기계획 과제 관련 - SEQ 추가
				 , CELL_PROD_SITE  -- 2022/06/02 [C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
              FROM DM_PLN_BP_FCST A
             WHERE 1 = 1
               AND A.DIVISION_ID = v_division_id;
        END

        /* 20190617 CUTOFF DATA INSERT (BEGIN) */
        BEGIN
            -- INSERT INTO 작업
            INSERT INTO DM_BP_EXCHANGE_RATE_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10 )
            -- DM_PLN_BP_FCST_C 테이블에 생성된 동일한 version no 를 저장
            SELECT p_division_id, v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, v_created_by AS LAST_UPDATED_BY, SYSDATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10
              FROM DM_BP_EXCHANGE_RATE
             WHERE DIVISION_ID = p_division_id;
        END;

        /* CUTOFF DATA INSERT INTO END) */

        -- 트랜잭션 (COMMIT)
        COMMIT WORK;

    -- -----------------------------------------------------------------------------------------
    -- END TRY
    -- -----------------------------------------------------------------------------------------
    -- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
    -- -----------------------------------------------------------
        -- ROLLBACK
        -- 트랜잭션 (END)

        -- ERROR LOG VALUE SAVE
        v_log_type := 'ERROR';
        v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
        v_description := 'ERROR_LINE : '  ||  STR(NULL);
        d_event_date := SYSTIMESTAMP;

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

 SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/


    -- -----------------------------------------------------------
    END CATCH;
    -- -----------------------------------------------------------
    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
END;
/
