-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0004 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0004.P_{SP_NAME}
-- ============================================================================


-- DMF0004_GET_SALES_SITE_DATA → PKG_DMF0004.P_DMF0004_GET_SALES_SITE_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_GET_SALES_SITE_DATA
(
  p_division_id		VARCHAR2,	--Division
  p_dept_id			VARCHAR2,	--Team
  p_end_customer		VARCHAR2,	--  EndCustomer
  p_scm_site_id		VARCHAR2,	--FCST Type
  p_active_flag		VARCHAR2,   --, p_debug         OUT VARCHAR2
  p_created_by			VARCHAR2,
  p_userinfo			VARCHAR2,
  p_soldto_customer	VARCHAR2,
  p_user_dept_id		VARCHAR2	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가

)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:06
 * 파일: dbo.DMF0004_GET_SALES_SITE_DATA.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:1  END:0  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L20
 * END;  위치: 
 * ----------------------------------------
 * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_sql_text VARCHAR2(4000 CHAR);
    v_group_id VARCHAR2(4000 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
BEGIN


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
  v_sql_text := '
	SELECT S.DIVISION_ID
		 /*
		 , S.DEPT_ID       AS TEAM_ID
		 , T.DEPT_NAME_KO  AS TEAM_NAME
		 , S.END_CUSTOMER
		 */
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''XXX'' ELSE S.DEPT_ID END   AS TEAM_ID
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''XXX'' ELSE T.DEPT_NAME_KO END  AS TEAM_NAME
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''acer'' ELSE S.END_CUSTOMER END AS END_CUSTOMER
		 , S.SOLDTO_CUSTOMER
		 , C.SOLDTO_CODE   AS REP_SOLDTO_CODE
		 , C.SHIPTO_CODE   AS REP_SHIPTO_CODE
		 , S.COUNTRY
		 , CO.COUNTRY_NAME
		 , S.CITY
		 , CT.CITY_NAME
		 , S.SCM_SITE_ID
		 , S.COMPANY_ID -- 20180907 ADD son young suk
		 , S.SITE_DESCRIPTION
		 , S.ATTRIBUTE3   AS DISTRIBUTION_CHANNEL -- PJ20200138 유통경로 추가
		 , S.VMI_YN
		 , S.VALID_YN
		 , S.LAST_UPDATED_BY
		 , S.LAST_UPDATE_DATE
		 , S.ATTRIBUTE2 AS SHIP_PLAN_AUTO
		 , CASE WHEN S.DIVISION_ID <> ''40'' AND ((FN_GET_DEPT_LIST(''p_created_by'', S.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')  THEN ''Y''
	            WHEN S.DIVISION_ID = ''40'' AND((FN_GET_DEPT_LIST2(''p_created_by'', S.SCM_SITE_ID) = ''Y'')
						OR ''v_group_id'' =''ADMIN'' OR ''p_created_by'' = S.LAST_UPDATED_BY) THEN ''Y'' ELSE '''' END AS EDIT_FLAG
		 --[C20200915-000323] Sales Site 에대한 team 변경 권한 추가
		 , (SELECT NVL(MAX(LU.VALID_YN) ,'''')
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL LU
			WHERE  LU.LOOKUP_TYPE = ''SALES_MGMT_TEAM''
			AND    LU.VALID_YN = ''Y''
			AND  ( LU.SEGMENT1 = (SELECT MAX(Dept_ID)
								  FROM   TB_FX_User
								  WHERE UserID = ''p_created_by'')
			    OR LU.SEGMENT1 = ''p_userinfo'' )	--[C20201222-000383] SCM PI Admin 에 Team변경 권한 추가
			AND    ''v_group_id'' =''ADMIN'') AS TEAM_EDIT_FLAG
		, S.ATTRIBUTE5
	FROM  SCM_MST_SITE  S
	LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = ''Y'') AS T
	   ON S.DEPT_ID = T.DEPT_ID
	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER C
	   ON (    S.DIVISION_ID = C.DIVISION_ID
	       AND S.SCM_SITE_ID = C.SCM_SITE_ID
	       AND C.REP_YN = ''Y''
		   -- modified by ytchoi 180601
		   AND C.VALID_YN = ''Y''
		  )
	LEFT JOIN SCM_MST_COUNTRY CO
	   ON S.COUNTRY = CO.COUNTRY
	LEFT JOIN SCM_MST_CITY CT
	   ON (    S.COUNTRY = CT.COUNTRY
	       AND S.CITY    = CT.CITY )
	WHERE S.SITE_TYPE = ''SALES'';
	-- AND   S.END_CUSTOMER IS NOT NULL
	v_division_id
	v_dept_id
	v_end_customer
	v_scm_site_id
	v_soldto_customer
	v_active_flag
	/*
	ORDER BY S.DIVISION_ID, S.DEPT_ID, S.END_CUSTOMER, S.SITE_DESCRIPTION, S.SCM_SITE_ID;
	*/
	';
	IF p_division_id = '40' THEN
		v_sql_text := v_sql_text  ||  'ORDER BY S.DIVISION_ID, S.SITE_DESCRIPTION, S.SCM_SITE_ID';
	ELSE
		v_sql_text := v_sql_text  ||  'ORDER BY S.DIVISION_ID, S.DEPT_ID, S.END_CUSTOMER, S.SITE_DESCRIPTION, S.SCM_SITE_ID';


	v_sql_text := REPLACE(v_sql_text,'v_division_id'  , FN_SCM_GET_WHERE_SQL('S.DIVISION_ID' , 'EQ', p_division_id ));
	v_sql_text := REPLACE(v_sql_text,'v_dept_id'      , FN_SCM_GET_WHERE_SQL('S.DEPT_ID'     , 'EQ', p_dept_id     ));
	v_sql_text := REPLACE(v_sql_text,'v_end_customer' , FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER', 'EQ', p_end_customer));
	v_sql_text := REPLACE(v_sql_text,'v_scm_site_id'  , FN_SCM_GET_WHERE_SQL('S.SCM_SITE_ID' , 'EQ', p_scm_site_id ));
	v_sql_text := REPLACE(v_sql_text,'v_soldto_customer'  , FN_SCM_GET_WHERE_SQL('S.SOLDTO_CUSTOMER'    , 'EQ', p_soldto_customer ));
	v_sql_text := REPLACE(v_sql_text,'v_active_flag'  , FN_SCM_GET_WHERE_SQL('S.VALID_YN'    , 'EQ', p_active_flag ));
	v_sql_text := REPLACE(v_sql_text,'p_created_by'   , p_created_by   );
	v_sql_text := REPLACE(v_sql_text,'v_group_id'      , v_group_id      );
	v_sql_text := REPLACE(v_sql_text,'p_userinfo'      , p_userinfo      ); --[C20201222-000383] SCM PI Admin 에 Team변경 권한 추가


  --p_debug := v_sql_text;
  --RETURN p_debug;
  --SELECT v_sql_text
  SP_EXECUTESQL v_sql_text;

END IF;
/

-- DMF0004_SAVE_SALES_SITE_BUCKET_DATA → PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_SAVE_SALES_SITE_BUCKET_DATA
(

	-- Add the parameters for the stored procedure here
	p_active_flag			VARCHAR2,
	p_division_id			VARCHAR2,
	p_scm_site_id			VARCHAR2,
	p_Incoterms            VARCHAR2,
	p_yyyymmdd				VARCHAR2,
	p_bucket_per			VARCHAR2,
	p_conversion_type		VARCHAR2,
	p_created_by			VARCHAR2
/****************************************************************************************************/
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:06
 * 파일: dbo.DMF0004_SAVE_SALES_SITE_BUCKET_DATA.sql
 * ----------------------------------------
 * ⚠ IF: IF:1  END IF:0  차이:+1
 * ⚠ BEGIN: BEGIN:4  END:1  차이:+3
 * ----------------------------------------
 * BEGIN 위치: L42, L121, L129, L159
 * END;  위치: L155
 * ----------------------------------------
 * 힌트: BEGIN이 3개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_recv_division_id VARCHAR2(4000 CHAR);
    v_recv_scm_site_id VARCHAR2(4000 CHAR);
    v_recv_Incoterms VARCHAR2(4000 CHAR);
    v_recv_yyyymmdd VARCHAR2(4000 CHAR);
    v_recv_bucket_per VARCHAR2(4000 CHAR);
    v_recv_conversion_type VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_division_id VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_Incoterms VARCHAR2(4000 CHAR);
    v_yyyymmdd VARCHAR2(4000 CHAR);
    v_bucket_per VARCHAR2(4000 CHAR);
    v_conversion_type VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := 'DMF0004_SAVE_SALES_SITE_BUCKET_DATA';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN









	v_recv_active_flag := NULL;
	v_recv_division_id := NULL;
	v_recv_scm_site_id := NULL;
	v_recv_Incoterms := NULL;
	v_recv_yyyymmdd := NULL;
	v_recv_bucket_per := NULL;
	v_recv_conversion_type := NULL;

	v_recv_active_flag := p_active_flag;
	v_recv_division_id := p_division_id;
	v_recv_scm_site_id := p_scm_site_id;
	v_recv_Incoterms := p_Incoterms;
	v_recv_yyyymmdd := p_yyyymmdd;
	v_recv_bucket_per := p_bucket_per;
	v_recv_conversion_type := p_conversion_type;









	v_active_flag := NULL;
	v_division_id := NULL;
	v_scm_site_id := NULL;
	v_Incoterms := NULL;
	v_yyyymmdd := NULL;
	v_bucket_per := NULL;
	v_conversion_type := NULL;
	v_created_by := NULL;


	v_delimiter := '^';








	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


		BEGIN TRY
		--    v_results TABLE (;
		--						active_flag			VARCHAR2(4000 CHAR)
		--					   ,division_id			VARCHAR2(4000 CHAR)
		--					   ,scm_site_id			VARCHAR2(4000 CHAR)
		--					   ,yyyymmdd			VARCHAR2(4000 CHAR)
		--					   ,bucket_per			VARCHAR2(4000 CHAR)
		--					   ,conversion_type	    VARCHAR2(4000 CHAR)
		--						)
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_active_flag, v_delimiter);
		--SELECT    v_max_loop_cnt;

		--	WHILE LENGTH(p_active_flag) > 0
		WHILE LENGTH(v_recv_active_flag) > 0 AND v_mst_loop_cnt < v_max_loop_cnt

		BEGIN

			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1;
			--SELECT v_mst_loop_cnt,'v_mst_loop_cnt'


			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				v_active_flag := SCM_ARR_SPL_VAL(p_active_flag, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_active_flag

				v_division_id := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_division_id

				v_scm_site_id := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_scm_site_id

				v_Incoterms := SCM_ARR_SPL_VAL(p_Incoterms, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_Incoterms

				v_yyyymmdd := SCM_ARR_SPL_VAL(p_yyyymmdd, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_yyyymmdd

				v_bucket_per := SCM_ARR_SPL_VAL(p_bucket_per, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_bucket_per

				v_conversion_type := SCM_ARR_SPL_VAL(p_conversion_type, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_conversion_type

				v_created_by := SCM_ARR_SPL_VAL(p_created_by, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_created_by

			END

			IF v_mst_loop_cnt > 0			--SELECT 	n_active_flag

				BEGIN

					--SELECT n_active_flag,'active_flag'
					--SELECT v_active_flag;
					--SELECT v_recv_active_flag;
					--SELECT p_active_flag;
					--SELECT v_division_id;
					--SELECT v_recv_division_id;
					--SELECT p_division_id;
					--SELECT v_scm_site_id;
					--SELECT p_scm_site_id;
					--SELECT v_yyyymmdd;
					--SELECT p_yyyymmdd;
				--	--SELECT v_conversion_type;
				--	--SELECT p_conversion_type;

					--SELECT v_bucket_per		-- 30
					--SELECT v_recv_bucket_per		-- 5^5^60
					--SELECT TO_NUMBER(REPLACE(v_bucket_per,v_delimiter,''))		-- 30
					--SELECT TO_NUMBER(REPLACE(CAST(v_bucket_per AS VARCHAR2(10 CHAR)),v_delimiter,'' )
					--SELECT TO_NUMBER(v_bucket_per);


				--HISTORY INSERT INTO PR_DM_MST_BUCKET_CONVERSION_HIST	--v_return_value = PR_DM_MST_BUCKET_CONVERSION_HIST
						v_division_id);
/

-- DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA → PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA
(
    --P_SUCCESS_YN			OUT VARCHAR2
    P_ACTIVE_FLAG			    VARCHAR2
   ,P_DIVISION_ID			    VARCHAR2
   ,P_SCM_SITE_ID			    VARCHAR2
   ,P_SOLDTO_CODE			    VARCHAR2
   ,P_SOLDTO_DESCRIPTION	VARCHAR2
   ,P_SHIPTO_CODE		    	VARCHAR2
   ,P_SHIPTO_DESCRIPTION	VARCHAR2
   ,P_REP_YN				      VARCHAR2
   ,P_VALID_YN				    VARCHAR2
   ,P_CREATED_BY			    VARCHAR2
)
AS
/****************************************************************************************************/
/* PROGRAM ID  : [DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA]                                            */
/* DESCRIPTION : SCM_MST_SITE HISTORYT INSERT                                                       */
/* USAGE       : PROCEDURE 작성 시 참조하세요!                                                         */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/05  DWOK/DWPARK  INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180611 YTCHOI : @V_VALID_YN = 'Y' 조건 추가 VALID를 Y로 하는 경우에만 CHECK 하도록 함. 
 * 20180626 KHSONG INVALID LOG 생성
 * 20180628 YTCHOI SOLDTO_CODE VALIDATION 조건에 추가
 * 20180712 KHSONG 컬럼값 NULL인경우 VALIDATION 조건 추가
 * 20181011 KHSONG SCM_MST_CUSTOMER VALIDATION CHECK
 * 20181030 KHSONG REP_YN 중복 VALIDATION 추가
 * 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 SOLDTO_CODE 와 동일한지 VALIDATION CHECK 
 * 20181115 KHSONG 신규 INSERT 요청시 기존 SHIPTO CODE에 앞 2자리가 SCM_MST_SITE의 국가코드와 VALIDATION
 * 20200528 KHSONG C20200417-000237 (SALES SITE-SHIP-TO 코드 생성시 VALIDATION 로직 변경)
 * 2020/12/21 P.C.I [C20201217-000228] SALES SITE에서 SOLD TO, SHIP TO의 VALID가 ''인 대상도 수정가능하도록 적용, VALID가 ''인 대상은 ACTIVE 'Y'로 변경 불가
 * 2021/01/18   KUNI  [C20210115-000214] (1)SALES SITE (SALES CUSTOMER) - ACTIVE 이력 저장관련 오류사항 , PARAMETER 값으로 저장
 * 2021/03/09   KUNI  [C20210305-000229] 판매법인 SALES SITE의 경우 국가/도시 통제 해제, (중복 SCM_SITE_ID)LOOKUP으로 관리
                        1. SOLDTO CODE 2개이상 저장가능
                        2. 국가/도시 통제 해제
 * 2022/04/26 ROSIA27   [C20220419-000344]판매처납품처 조합1-복수의 SALES SITE 내 VALIDATION Y 지정 불가 로직 점검 요청의 件
 * 2022/10/24 ROSIA27   [C20221024-000510]DM UI 소스 정리 요청
 * 2024/06/05 P.C.I   [PJ20228272]NERP 대응 - NERP 오픈 이후 신코드만 대표코드로 설정 가능, SOLDTO_CODE 중복 확인 시 NERP 신코드/구코드가 동일한 경우에 제외 
 * 2025/02/05 JSSBAE    [E20250205-001041]_SALES SITE의 SOLD TO 구코드, 신코드 인식 오류 검토 요청의 건
 * 2025/06/29 JSSBAE    [IT20250117A] NERP 오펀차수별 MAPPING CODE적용
 * 2026-03-10 SSLEE     [PJ20264226] NextSCM Pilot 설계 및 개발
*/
/****************************************************************************************************/


/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:06
 * 파일: DBO.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA.SQL
 * ----------------------------------------
 * ? IF: IF:21  END IF:15  차이:+6
 * ? BEGIN: BEGIN:10  END:6  차이:+4
 * ----------------------------------------
 * BEGIN 위치: L74, L140, L147, L204, L219, L237, L252, L347, L434, L520
 * END;  위치: L179, L209, L224, L242, L286, L602
 * ----------------------------------------
 * 힌트: BEGIN이 4개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    V_RECV_ACTIVE_FLAG      VARCHAR2(4000 CHAR) := P_ACTIVE_FLAG;
    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR) := NULL;
    V_DIVISION_ID           VARCHAR2(4000 CHAR) := NULL;
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR) := NULL;
    V_SOLDTO_CODE           VARCHAR2(4000 CHAR) := NULL;
    V_SOLDTO_DESCRIPTION    VARCHAR2(4000 CHAR) := NULL;
    V_SHIPTO_CODE           VARCHAR2(4000 CHAR) := NULL;
    V_SHIPTO_DESCRIPTION    VARCHAR2(4000 CHAR) := NULL;
    V_REP_YN                VARCHAR2(4000 CHAR) := NULL;
    V_VALID_YN              VARCHAR2(4000 CHAR) := NULL;
    V_CREATED_BY            VARCHAR2(4000 CHAR) := NULL;
  
    
    V_DELIMITER             VARCHAR2(1 CHAR) := '^';
    V_MAX_LOOP_CNT          PLS_INTEGER := 0;
    V_MST_LOOP_CNT          PLS_INTEGER := 0;
    
    -- RECORD 타입 선언
    -- 사용하는 곳이 없어서 주석처리 SSLEE
/*    TYPE RESULTS_RECORD_TYPE IS RECORD (
        DIVISION_ID      VARCHAR(4000 CHAR)
       ,SCM_SITE_ID      VARCHAR(4000 CHAR)
       ,SOLDTO_CODE      VARCHAR(4000 CHAR)
       ,SHIPTO_CODE      VARCHAR(4000 CHAR)
    );
    
    -- RECORD 타입 변수 선언
    RESULTS_RECORD       RESULTS_RECORD_TYPE;*/
    
    V_DUP_SCM_SITE_ID       VARCHAR2(4000 CHAR) := NULL;
    --V_PROGRAM_NAME          VARCHAR2(150 CHAR)  = 'DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA';
    V_LOG_TYPE              VARCHAR2(30 CHAR)   := 'START';
    N_LOG_COUNT             PLS_INTEGER         := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR) := '########## Start of procedure ##########';
    V_DESCRIPTION           VARCHAR2(500 CHAR)  := '';
    D_EVENT_DATE            TIMESTAMP(6)        := SYSTIMESTAMP;
    V_CNT_1                 PLS_INTEGER := 0;
    V_CNT_2                 PLS_INTEGER := 0;
    
    V_SCM_MST_CUSTOMER_CNT  PLS_INTEGER         := 0;
    V_SHIPTO_CODE_LEN       PLS_INTEGER         := 0;
    V_SCM_MST_SITE_CNT      PLS_INTEGER         := 0;
    V_CNT_3                 PLS_INTEGER := 0;
    ERR_RTN_EXCEPTION       EXCEPTION;

BEGIN

	  PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

	  -- 시작 LOG  (END)
	  V_LOG_MESSAGE := NULL ;     /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


		-- 프로시저 LOOP 길이를 판단
		V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
		--SELECT    V_MAX_LOOP_CNT;
		--	WHILE LENGTH(P_ACTIVE_FLAG) > 0
    IF LENGTH(V_RECV_ACTIVE_FLAG) > 0 THEN
        FOR I IN 1..V_MAX_LOOP_CNT LOOP
    		

            -- V_MST_LOOP_CNT 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            --SELECT V_MST_LOOP_CNT,'V_MST_LOOP_CNT'
            
            -- 각 컬럼들에 대한 스플릿처리로직 스타트

            V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
            --SELECT V_ACTIVE_FLAG
                
            V_DIVISION_ID := SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
            --SELECT V_DIVISION_ID
                
            V_SCM_SITE_ID := SCM_ARR_SPL_VAL(P_SCM_SITE_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
            --SELECT V_SCM_SITE_ID
                
            V_SOLDTO_CODE := SCM_ARR_SPL_VAL(P_SOLDTO_CODE, V_DELIMITER , V_MST_LOOP_CNT) ;
            --SELECT V_SOLDTO_CODE
                
            V_SOLDTO_DESCRIPTION := SCM_ARR_SPL_VAL(P_SOLDTO_DESCRIPTION, V_DELIMITER , V_MST_LOOP_CNT) ;
            --SELECT V_SOLDTO_DESCRIPTION
                
            V_SHIPTO_CODE := SCM_ARR_SPL_VAL(P_SHIPTO_CODE, V_DELIMITER, V_MST_LOOP_CNT) ;
            --SELECT V_SHIPTO_CODE
                
            V_SHIPTO_DESCRIPTION := SCM_ARR_SPL_VAL(P_SHIPTO_DESCRIPTION, V_DELIMITER, V_MST_LOOP_CNT) ;
            --SELECT V_SHIPTO_DESCRIPTION
                
            V_REP_YN := SCM_ARR_SPL_VAL(P_REP_YN, V_DELIMITER, V_MST_LOOP_CNT) ;
            --SELECT V_REP_YN
                
            V_VALID_YN := SCM_ARR_SPL_VAL(P_VALID_YN, V_DELIMITER, V_MST_LOOP_CNT) ;
            --SELECT V_VALID_YN
                
            V_CREATED_BY := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT) ;
            --SELECT V_CREATED_BY
            

            --HISTORY INSERT INTO
            --V_RETURN_VALUE = PR_DM_MST_SITE_CUSTOMER_HIST
            PR_DM_MST_SITE_CUSTOMER_HIST (
                 V_DIVISION_ID
                ,V_SCM_SITE_ID
                ,V_SOLDTO_CODE
                ,V_SHIPTO_CODE
                ,V_REP_YN
                ,V_CREATED_BY
                ,V_VALID_YN -- [C20210115-000214] (1)
                );
                  --,V_OK_DESCRIPTION OUTPUT
                  --SELECT V_OK_DESCRIPTION;

            ----------------------------------------------------- 20180712 KHSONG 컬럼값 NULL인경우 VALIDATION 조건 추가 (END)
            IF V_DIVISION_ID IS NULL
                OR  V_SCM_SITE_ID IS NULL
                OR  V_SOLDTO_CODE IS NULL
                OR  V_SHIPTO_CODE IS NULL
                OR  V_REP_YN IS NULL
                OR  V_DIVISION_ID = ''
                OR  V_SCM_SITE_ID = ''
                OR  V_SOLDTO_CODE = ''
                OR  V_SHIPTO_CODE = ''
                OR  V_REP_YN      = '' THEN
                   -- 중복 발생인경우의 LOGIC
                   V_LOG_TYPE := 'INVALID';
                   V_DESCRIPTION := '입력값을 확인하세요.';
                  -- GOTO ERR_RTN;
                  RAISE ERR_RTN_EXCEPTION;
            END IF;
            ----------------------------------------------------- 20180712 KHSONG 컬럼값 NULL인경우 VALIDATION 조건 추가 (END)
            --------------------------------------------------------------------------------------------------------------------------------------- 20181011 KHSONG SCM_MST_CUSTOMER VALIDATION CHECK (START)
            BEGIN
                V_SCM_MST_CUSTOMER_CNT := 0;

               SELECT COUNT(1)
                 INTO V_SCM_MST_CUSTOMER_CNT
                 FROM SCM_MST_CUSTOMER
                WHERE 1=1
                  AND DIVISION_ID = V_DIVISION_ID
                  AND SHIPTO_CODE = V_SHIPTO_CODE
                  AND SOLDTO_CODE = V_SOLDTO_CODE
                  --AND VALID_YN = 'Y' --[C20201217-000228] SALES SITE에서 SOLD TO, SHIP TO의 VALID가 ''인 대상도 수정가능하도록 적용
                  ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_SCM_MST_CUSTOMER_CNT := 0;
            END;

            IF V_SCM_MST_CUSTOMER_CNT = 0 THEN

                V_LOG_TYPE := 'INVALID';
                V_DESCRIPTION := 'Invalid soldto - shipto mapping'||CHR(10)||'Sold-To Code: '||RTRIM(LTRIM(V_SOLDTO_CODE))||CHR(10)||'Ship-To Code: '||RTRIM(LTRIM(V_SHIPTO_CODE))||CHR(10);
                --GOTO ERR_RTN;
                RAISE ERR_RTN_EXCEPTION;

            END IF;

            --START [C20201217-000228] SALES SITE에서 SOLD TO, SHIP TO의 VALID가 ''인 대상은 ACTIVE 'Y'로 변경 불가
            BEGIN
                V_CNT_1 := 0;
                    
                SELECT COUNT(1)
                  INTO V_CNT_1
                  FROM SCM_MST_CUSTOMER
                 WHERE 1=1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SHIPTO_CODE = V_SHIPTO_CODE
                   AND SOLDTO_CODE = V_SOLDTO_CODE
                   AND VALID_YN	   = ''
                   AND 'Y'         = V_VALID_YN;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_CNT_1 := 0;
            END;

            IF V_CNT_1 > 0 THEN
             
                V_LOG_TYPE := 'INVALID';
                V_DESCRIPTION := 'Invalid soldto - shipto mapping'||CHR(10)||'Sold-To Code: '||RTRIM(LTRIM(V_SOLDTO_CODE))||'Ship-To Code: '||RTRIM(LTRIM(V_SHIPTO_CODE))||CHR(10);
                --GOTO ERR_RTN;
                RAISE ERR_RTN_EXCEPTION;
                
            END IF;

            --END [C20201217-000228] SALES SITE에서 SOLD TO, SHIP TO의 VALID가 ''인 대상은 ACTIVE 'Y'로 변경 불가
            --------------------------------------------------------------------------------------------------------------------------------------- 20181011 KHSONG SCM_MST_CUSTOMER VALIDATION CHECK (END)

            --PJ20228272NERP 대응 - NERP 오픈 이후 신코드만 대표코드로 설정 가능
            --20240522 SM NERP관련 수정
            --START
            --PRINT V_REP_YN + '/' + V_DIVISION_ID + '/' + V_SHIPTO_CODE + '/' + V_SOLDTO_CODE
            IF V_REP_YN = 'Y' THEN

            -- --------------------------------------------------------------------------------------------------------------------------
            --IT20250117A_NERP MASTER 바라보도록 수정 START
            -- ERP에서 1차 CONVERSION 대상들에 대해서도 계속 OLD 데이터로 데이터를 넘겨주는 것을 확인하여, 직접 NERP 테이블을 바라보고 이미 지나간 차수에
            --대해서는 OLD VALUE가 저장되지 않도록 수정 과거 소스 주석처리하고 NERP MASTER 바라보도록 수정
            --SHIPTO_CODE, SOLDTO_CODE 둘중에 하나라도 OLD가 들어오면 안되므로, OR로 JOIN함.
            -- --------------------------------------------------------------------------------------------------------------------------
            /*
            IF (SELECT COUNT(1) FROM SCM_MST_CUSTOMER
                  WHERE 1=1
                      AND DIVISION_ID = V_DIVISION_ID
                      AND SHIPTO_CODE = V_SHIPTO_CODE
                    AND SOLDTO_CODE = V_SOLDTO_CODE
                    AND NVL(ATTRIBUTE1, NULL) = 'OLD'
            ) > 0*/

                
                BEGIN
                    V_CNT_2 := 0;
                        
                    SELECT COUNT(1)
                      INTO V_CNT_2
                      FROM (SELECT SHIPTO_CODE, SOLDTO_CODE
                              FROM SCM_MST_CUSTOMER
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND SHIPTO_CODE = V_SHIPTO_CODE
                               AND SOLDTO_CODE = V_SOLDTO_CODE ) A
                              INNER JOIN (SELECT OLD_VALUE1
                                            FROM NERP_CONV_MASTER
                                           WHERE CODETYPE = 'END_CUSTOMER_ID') B
                                  ON A.SOLDTO_CODE = B.OLD_VALUE1	OR A.SHIPTO_CODE = B.OLD_VALUE1
                    ;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_CNT_2 := 0;
                END;
                
                
                IF V_CNT_2 > 0 THEN
                    V_LOG_TYPE := 'INVALID';
                    V_DESCRIPTION := '구버전 soldto_code를 대표코드로 선택할 수 없습니다.';
                    --GOTO ERR_RTN;
                    RAISE ERR_RTN_EXCEPTION;
                END IF;
            END IF;


            IF V_MST_LOOP_CNT > 0 THEN

                -- SCM_MST_SITE_CUSTOMER MASTER SAVE LOGIC
                
                BEGIN
                    V_CNT_3 := 0;
                        
                    SELECT COUNT(1) --A.DIVISION_ID,A.SCM_SITE_ID,A.SOLDTO_CODE,A.SHIPTO_CODE
                      INTO V_CNT_3
                      FROM SCM_MST_SITE_CUSTOMER A
                          ,(SELECT V_DIVISION_ID	AS DIVISION_ID
                                  ,V_SCM_SITE_ID	AS SCM_SITE_ID
                                  ,V_SOLDTO_CODE	AS SOLDTO_CODE
                                  ,V_SHIPTO_CODE	AS SHIPTO_CODE
                              FROM DUAL) B
                          ,SCM_MST_SITE C  -- ADDED BY YTCHOI 180730
                     WHERE 1 = 1
                       AND A.DIVISION_ID  = B.DIVISION_ID
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                       AND A.SOLDTO_CODE  = B.SOLDTO_CODE
                       AND A.SHIPTO_CODE  = B.SHIPTO_CODE
                         -- ADDED BY YTCHOI 180730
                       AND A.DIVISION_ID  = C.DIVISION_ID
                       AND A.SCM_SITE_ID  = C.SCM_SITE_ID
                       AND C.SITE_TYPE    = 'SALES'
                    ;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_CNT_3 := 0;
                END;

                IF V_CNT_3 > 0 THEN

                    IF V_REP_YN = 'Y' THEN

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET REP_YN = ''
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID;

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET DIVISION_ID		  = V_DIVISION_ID
                              ,SCM_SITE_ID	    = V_SCM_SITE_ID
                              ,SOLDTO_CODE	    = V_SOLDTO_CODE
                              ,SHIPTO_CODE		  = V_SHIPTO_CODE
                              ,REP_YN				    = V_REP_YN
                              ,VALID_YN			    = V_VALID_YN
                              ,LAST_UPDATED_BY	= V_CREATED_BY
                              ,LAST_UPDATE_DATE	= SYSTIMESTAMP
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID
                           AND SOLDTO_CODE  = V_SOLDTO_CODE
                           AND SHIPTO_CODE  = V_SHIPTO_CODE
                           ;


                    ELSE

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET DIVISION_ID		  = V_DIVISION_ID
                              ,SCM_SITE_ID	    = V_SCM_SITE_ID
                              ,SOLDTO_CODE	    = V_SOLDTO_CODE
                              ,SHIPTO_CODE		  = V_SHIPTO_CODE
                              ,REP_YN				    = V_REP_YN
                              ,VALID_YN			    = V_VALID_YN
                              ,LAST_UPDATED_BY	= V_CREATED_BY
                              ,LAST_UPDATE_DATE	= SYSTIMESTAMP
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID
                           AND SOLDTO_CODE  = V_SOLDTO_CODE
                           AND SHIPTO_CODE  = V_SHIPTO_CODE
                           ;
                    
                    END IF;


                ELSE
                    ----------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 INSERT INTO 요청시 기존 SHIPTO CODE에 앞 2자리가 SCM_MST_SITE의 국가코드와 VALIDATION (START)
                    BEGIN
                        V_SHIPTO_CODE_LEN := 0;
                        
                        SELECT LENGTH(V_SHIPTO_CODE)
                          INTO V_SHIPTO_CODE_LEN
                          FROM DUAL
                        ;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_SHIPTO_CODE_LEN := 0;
                    END;

                    IF V_SHIPTO_CODE_LEN > 4 THEN
                      -- --
                        -- [C20210305-000229]
                        BEGIN
                            V_CNT_3 := 0;
                                
                            SELECT COUNT(1) --A.DIVISION_ID,A.SCM_SITE_ID,A.SOLDTO_CODE,A.SHIPTO_CODE
                              INTO V_CNT_3
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'
                               AND SEGMENT1    = V_SCM_SITE_ID
                               AND VALID_YN    = 'Y'
                            ;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_CNT_3 := 0;
                        END;
                        
                        IF V_CNT_3 = 0 THEN

                            BEGIN
                                V_SCM_MST_SITE_CNT := 0;
                                
                                SELECT NVL(COUNT(1),0)
                                  INTO V_SCM_MST_SITE_CNT
                                  FROM SCM_MST_SITE
                                 WHERE DIVISION_ID	= V_DIVISION_ID
                                   AND SCM_SITE_ID	= V_SCM_SITE_ID
                                   AND COUNTRY		  = SUBSTR(V_SHIPTO_CODE,1,2)
                                   AND VALID_YN     = 'Y'
                                ;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    V_SCM_MST_SITE_CNT := 0;
                            END;
                    
                            IF V_SCM_MST_SITE_CNT = 0 THEN
                              -- --------
                                V_LOG_TYPE := 'INVALID';
                                V_DESCRIPTION := 'Sales Site의 국가와 등록하려는 Shipto Code의 국가 코드가 다릅니다.'||CHR(10)||' Div : '
                                                 ||RTRIM(LTRIM(V_DIVISION_ID))||CHR(10)||' Sales Site : '||RTRIM(LTRIM(V_SCM_SITE_ID))||CHR(10)||' Shipto Code : '||RTRIM(LTRIM(V_SHIPTO_CODE));
                                --GOTO ERR_RTN;
                                RAISE ERR_RTN_EXCEPTION;
                              -- --------
                            END IF;
                              -- --------
                        END IF;
                      -- --
                    END IF;
                      -- --
                    ----------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 INSERT INTO 요청시 기존 SHIPTO CODE에 앞 2자리가 SCM_MST_SITE의 국가코드와 VALIDATION (END)
                    INSERT INTO	SCM_MST_SITE_CUSTOMER
                        (
                            DIVISION_ID
                           ,SCM_SITE_ID
                           ,SOLDTO_CODE
                           ,SHIPTO_CODE
                           ,REP_YN
                           ,VALID_YN
                           ,CREATED_BY
                           ,CREATION_DATE
                           ,LAST_UPDATED_BY
                           ,LAST_UPDATE_DATE
                        )
                    VALUES (
                            V_DIVISION_ID
                           ,V_SCM_SITE_ID
                           ,V_SOLDTO_CODE
                           ,V_SHIPTO_CODE
                           ,V_REP_YN
                           ,V_VALID_YN
                           --,TO_NUMBER(CAST(V_QTY AS VARCHAR2(10 CHAR)))
                           ,V_CREATED_BY
                           ,SYSTIMESTAMP
                           ,V_CREATED_BY
                           ,SYSTIMESTAMP
                        );
                END IF;


              --다중 ROW 일때 (END)

            ELSE

              --단일 ROW 일때 (START)

                V_ACTIVE_FLAG        := P_ACTIVE_FLAG;
                V_DIVISION_ID        := P_DIVISION_ID;
                V_SOLDTO_CODE        := P_SOLDTO_CODE;
                V_SOLDTO_DESCRIPTION := P_SOLDTO_DESCRIPTION;
                V_SHIPTO_CODE        := P_SHIPTO_CODE;
                V_SHIPTO_DESCRIPTION := P_SHIPTO_DESCRIPTION;
                V_REP_YN             := P_REP_YN;
                V_VALID_YN           := P_VALID_YN;
                V_CREATED_BY         := P_CREATED_BY;

                --HISTORY INSERT INTO 
                --V_RETURN_VALUE = PR_DM_MST_SITE_CUSTOMER_HIST
                PR_DM_MST_SITE_CUSTOMER_HIST (
                    V_DIVISION_ID
                   ,V_SCM_SITE_ID
                   ,V_SOLDTO_CODE
                   ,V_SHIPTO_CODE
                   ,V_REP_YN
                   ,V_CREATED_BY
                   ,V_VALID_YN		-- [C20210115-000214] (1)
                   );
                  --SELECT V_OK_DESCRIPTION;
                  --V_OK_DESCRIPTION OUTPUT
                  
                BEGIN
                    V_CNT_3 := 0;
                                
                    SELECT COUNT(1) --A.DIVISION_ID,A.SCM_SITE_ID,A.SOLDTO_CODE,A.SHIPTO_CODE
                      INTO V_CNT_3
                      FROM SCM_MST_SITE_CUSTOMER A
                          ,(SELECT V_DIVISION_ID	AS DIVISION_ID
                                  ,V_SCM_SITE_ID	AS SCM_SITE_ID
                                  ,V_SOLDTO_CODE	AS SOLDTO_CODE
                                  ,V_SHIPTO_CODE	AS SHIPTO_CODE
                              FROM DUAL) B
                          ,SCM_MST_SITE C  -- ADDED BY YTCHOI 180730
                     WHERE 1 = 1
                       AND A.DIVISION_ID  = B.DIVISION_ID
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                       AND A.SOLDTO_CODE  = B.SOLDTO_CODE
                       AND A.SHIPTO_CODE  = B.SHIPTO_CODE
                         -- ADDED BY YTCHOI 180730
                       AND A.DIVISION_ID  = C.DIVISION_ID
                       AND A.SCM_SITE_ID  = C.SCM_SITE_ID
                       AND C.SITE_TYPE    = 'SALES'
                    ;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_CNT_3 := 0;
                END;

                IF V_CNT_3 > 0 THEN

                    IF V_REP_YN = 'Y' THEN

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET REP_YN = ''
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID
                        ;

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET DIVISION_ID		= V_DIVISION_ID
                              ,SCM_SITE_ID	    = V_SCM_SITE_ID
                              ,SOLDTO_CODE	    = V_SOLDTO_CODE
                              ,SHIPTO_CODE		= V_SHIPTO_CODE
                              ,REP_YN				= V_REP_YN
                              ,VALID_YN			= V_VALID_YN
                              ,LAST_UPDATED_BY	= V_CREATED_BY
                              ,LAST_UPDATE_DATE	= SYSTIMESTAMP
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID
                           AND SOLDTO_CODE  = V_SOLDTO_CODE
                           AND SHIPTO_CODE  = V_SHIPTO_CODE
                        ;

                    ELSE

                        UPDATE SCM_MST_SITE_CUSTOMER
                           SET DIVISION_ID		= V_DIVISION_ID
                              ,SCM_SITE_ID	    = V_SCM_SITE_ID
                              ,SOLDTO_CODE	    = V_SOLDTO_CODE
                              ,SHIPTO_CODE		= V_SHIPTO_CODE
                              ,REP_YN				= V_REP_YN
                              ,VALID_YN			= V_VALID_YN
                              ,LAST_UPDATED_BY	= V_CREATED_BY
                              ,LAST_UPDATE_DATE	= SYSTIMESTAMP
                         WHERE DIVISION_ID  = V_DIVISION_ID
                           AND SCM_SITE_ID  = V_SCM_SITE_ID
                           AND SOLDTO_CODE  = V_SOLDTO_CODE
                           AND SHIPTO_CODE  = V_SHIPTO_CODE
                        ;
                           
                    END IF;


                ELSE
                  --------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 INSERT INTO 요청시 기존 SHIPTO CODE에 앞 2자리가 SCM_MST_SITE의 국가코드와 VALIDATION (START)
                    BEGIN
                        V_SHIPTO_CODE_LEN := 0;
                        
                        SELECT LENGTH(V_SHIPTO_CODE)
                          INTO V_SHIPTO_CODE_LEN
                          FROM DUAL
                        ;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_SHIPTO_CODE_LEN := 0;
                    END;
                    
                    IF V_SHIPTO_CODE_LEN > 4 THEN
                      -- --
                        -- [C20210305-000229]
                        
                        BEGIN
                            V_CNT_3 := 0;
                                        
                            SELECT COUNT(1) --A.DIVISION_ID,A.SCM_SITE_ID,A.SOLDTO_CODE,A.SHIPTO_CODE
                              INTO V_CNT_3
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'
                               AND SEGMENT1    = V_SCM_SITE_ID
                               AND VALID_YN    = 'Y'
                            ;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_CNT_3 := 0;
                        END;
                        
                        IF V_CNT_3 = 0 THEN

                            BEGIN
                                V_SCM_MST_SITE_CNT := 0;
                                
                                SELECT NVL(COUNT(1),0)
                                  INTO V_SCM_MST_SITE_CNT
                                  FROM SCM_MST_SITE
                                 WHERE DIVISION_ID	= V_DIVISION_ID
                                   AND SCM_SITE_ID	= V_SCM_SITE_ID
                                   AND COUNTRY		  = SUBSTR(V_SHIPTO_CODE,1,2)
                                   AND VALID_YN     = 'Y'
                                ;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    V_SCM_MST_SITE_CNT := 0;
                            END;
                           
                           
                           
                            IF V_SCM_MST_SITE_CNT = 0 THEN
                              -- --------
                                V_LOG_TYPE := 'INVALID';
                                V_DESCRIPTION := 'Sales Site의 국가와 등록하려는 Shipto Code의 국가 코드가 다릅니다.'||CHR(10)||' Div : '
                                                 ||RTRIM(LTRIM(V_DIVISION_ID))||CHR(10)||' Sales Site : '||RTRIM(LTRIM(V_SCM_SITE_ID))||CHR(10)||' Shipto Code : '||RTRIM(LTRIM(V_SHIPTO_CODE));
                                --GOTO ERR_RTN;
                                RAISE ERR_RTN_EXCEPTION;
                              -- --------
                            END IF;
                            -- --------
                        END IF;
                      -- --
                    END IF;
                    -- --
                    --------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 INSERT INTO 요청시 기존 SHIPTO CODE에 앞 2자리가 SCM_MST_SITE의 국가코드와 VALIDATION (END)
                    INSERT INTO	SCM_MST_SITE_CUSTOMER
                        (
                            DIVISION_ID
                           ,SCM_SITE_ID
                           ,SOLDTO_CODE
                           ,SHIPTO_CODE
                           ,REP_YN
                           ,VALID_YN
                           ,CREATED_BY
                           ,CREATION_DATE
                           ,LAST_UPDATED_BY
                           ,LAST_UPDATE_DATE
                        )
                    VALUES (
                            V_DIVISION_ID
                           ,V_SCM_SITE_ID
                           ,V_SOLDTO_CODE
                           ,V_SHIPTO_CODE
                           ,V_REP_YN
                           ,V_VALID_YN
                           --,TO_NUMBER(CAST(V_QTY AS VARCHAR2(10 CHAR)))
                           ,V_CREATED_BY
                           ,SYSTIMESTAMP
                           ,V_CREATED_BY
                           ,SYSTIMESTAMP
                        );
                        
               END IF;

            END IF;
            --단일 ROW 일때 (END)

            --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH -- 20220426 EDIT(START)
            BEGIN
                V_SCM_MST_CUSTOMER_CNT := 0;

                SELECT COUNT(1)
                  INTO V_SCM_MST_CUSTOMER_CNT
                  FROM SCM_MST_SITE_CUSTOMER A
                      ,SCM_MST_SITE C  -- ADDED BY YTCHOI 180730
                 WHERE 1=1
                   AND A.DIVISION_ID  = V_DIVISION_ID
                   AND A.SHIPTO_CODE  = V_SHIPTO_CODE
                   AND A.SOLDTO_CODE  = V_SOLDTO_CODE -- ADDED BY YTCHOI 20180628
                   AND A.VALID_YN     = 'Y'                    -- VALID_YN = 'Y' 것만 중복체크
                   AND A.DIVISION_ID  = C.DIVISION_ID
                   AND A.SCM_SITE_ID  = C.SCM_SITE_ID
                   AND C.SITE_TYPE    = 'SALES'
              GROUP BY A.DIVISION_ID, A.SHIPTO_CODE
                HAVING COUNT(*) > 1                     -- UI에서 INPUT받은 데이터 포함하여 2건이상인것 체크
                  ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_SCM_MST_CUSTOMER_CNT := 0;
            END;
                    
            IF V_SCM_MST_CUSTOMER_CNT > 1 THEN
              
                BEGIN
                    V_DUP_SCM_SITE_ID := NULL;

                    SELECT A.SCM_SITE_ID
                      INTO V_DUP_SCM_SITE_ID
                      FROM SCM_MST_SITE_CUSTOMER A  -- 정상인경우 2건이상일수 없지만 현재 데이터정비가 되어있지 않아 TOP 1 으로 한건만 추출
                          ,SCM_MST_SITE C
                     WHERE 1=1
                       AND A.DIVISION_ID  = V_DIVISION_ID
                       AND A.SHIPTO_CODE  = V_SHIPTO_CODE
                       AND A.SOLDTO_CODE  = V_SOLDTO_CODE -- ADDED BY YTCHOI 20180628
                       AND A.SCM_SITE_ID  <> V_SCM_SITE_ID      -- UI에서 INPUT받은 SCM_SITE_ID 제외하고 존재하고있는 SCM_SITE_ID 를 추출
                       AND A.VALID_YN     = 'Y'
                       AND A.DIVISION_ID  = C.DIVISION_ID
                       AND A.SCM_SITE_ID  = C.SCM_SITE_ID
                       AND C.SITE_TYPE    = 'SALES'
                       AND ROWNUM       = 1
                      ;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DUP_SCM_SITE_ID := 0;
                END;

                V_LOG_TYPE := 'INVALID';
                --  ' FORD_US_RDF SALES SITE 에서 USH000534A SHIP-TO CODE가 이미 사용중입니다.'
                --   {0} SALES SITE 에서  {1} SHIP-TO CODE가 이미 사용중입니다.
                V_DESCRIPTION := V_DUP_SCM_SITE_ID||' Sales Site 에서'||V_SHIPTO_CODE||'Ship-To Code가 이미 사용중입니다.'; -- 20180626 KHSONG INVALID LOG 생성
                --GOTO ERR_RTN;
                RAISE ERR_RTN_EXCEPTION;
            END IF;
          --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH -- 20220426 EDIT (END)

        END LOOP;
    
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------- 20181030 KHSONG REP_YN 중복 VALIDATION 추가 (START)
    BEGIN
        V_SCM_MST_CUSTOMER_CNT := 0;

        SELECT COUNT(1)
          INTO V_SCM_MST_CUSTOMER_CNT
          FROM SCM_MST_SITE_CUSTOMER A
              ,SCM_MST_SITE C
         WHERE 1=1
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.SCM_SITE_ID  = V_SCM_SITE_ID
           AND A.REP_YN       = 'Y'              -- REP_YN   = 'Y' 것만 중복체크
           AND A.DIVISION_ID  = C.DIVISION_ID
           AND A.SCM_SITE_ID  = C.SCM_SITE_ID
           AND C.SITE_TYPE    = 'SALES'
      GROUP BY A.DIVISION_ID, A.SCM_SITE_ID
        HAVING COUNT(*) > 1                     -- UI에서 INPUT받은 데이터 포함하여 2건이상인것 체크
          ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_SCM_MST_CUSTOMER_CNT := 0;
    END;
        
    IF V_SCM_MST_CUSTOMER_CNT > 1 THEN
        V_LOG_TYPE := 'INVALID';
        V_DESCRIPTION := V_DUP_SCM_SITE_ID  ||  ' Sales Site 에서 Rep값 설정이 중복되었습니다.';
        --GOTO ERR_RTN;
        RAISE ERR_RTN_EXCEPTION;
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------------- 20181030 KHSONG REP_YN 중복 VALIDATION 추가 (END)

    --------------------------------------------------------------------------------------------------------------------------------------- 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 SOLDTO_CODE 와 동일한지 VALIDATION CHECK (START)
    -- [C20210305-000229]
    
    BEGIN
        V_CNT_3 := 0;
                                
        SELECT COUNT(1)
          INTO V_CNT_3
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'
           AND SEGMENT1    = V_SCM_SITE_ID
           AND VALID_YN    = 'Y'
        ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_CNT_3 := 0;
    END;
    
    IF V_CNT_3 = 0 THEN
       
        BEGIN
            V_SCM_MST_CUSTOMER_CNT := 0;

            --[E20250205-001041]_Sales Site의 Sold To 구코드, 신코드 인식 오류 검토 요청의 건
            -- SOLDTO_CODE 중복 확인 시 NERP 신코드/구코드가 동일한 경우에 제외
            /*
            SELECT division_id,SCM_SITE_ID,SOLDTO_CODE,row_number() OVER (ORDER BY DIVISION_ID) AS ROWNUM
               FROM SCM_MST_SITE_CUSTOMER with(nolock)
                  WHERE DIVISION_ID = @v_division_id
                  and scm_site_id = @v_scm_site_id
                  AND VALID_Yn = 'Y'
            GROUP BY DIVISION_ID, SCM_SITE_ID,SOLDTO_CODE
            */
            SELECT NVL(MAX(ROWNUM),0)
              INTO V_SCM_MST_CUSTOMER_CNT
              FROM (SELECT A.DIVISION_ID, A.SCM_SITE_ID, NVL(B.NEW_VALUE1, A.SOLDTO_CODE) AS SOLDTO_CODE, ROW_NUMBER() OVER (ORDER BY DIVISION_ID) AS ROWNUM
                      FROM SCM_MST_SITE_CUSTOMER A
                           LEFT JOIN NERP_CONV_MASTER B
                           ON  B.OLD_VALUE1 = A.SOLDTO_CODE
                           AND B.CODETYPE   = 'END_CUSTOMER_ID'
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.SCM_SITE_ID = V_SCM_SITE_ID
                       AND A.VALID_YN    = 'Y'
                  GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, NVL(B.NEW_VALUE1, A.SOLDTO_CODE)
              ) A
              ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_SCM_MST_CUSTOMER_CNT := 0;
        END;

        IF V_SCM_MST_CUSTOMER_CNT > 1 THEN
            V_LOG_TYPE := 'INVALID';
            --+ 'INVALID SOLDTO - SHIPTO MAPPING' +CHAR(10)
            --+ 'SOLD-TO CODE: ' + RTRIM(LTRIM(V_SOLDTO_CODE))
            V_DESCRIPTION := '하나의 Sales Site에 2개 이상의 Sold-To는 등록할 수 없습니다. '||'Sold-To Code: '||  RTRIM(LTRIM(V_SOLDTO_CODE));
            --GOTO ERR_RTN;
            RAISE ERR_RTN_EXCEPTION;
        END IF;
        
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------------- 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 SOLDTO_CODE 와 동일한지 VALIDATION CHECK (END)

    COMMIT;


EXCEPTION
    WHEN ERR_RTN_EXCEPTION THEN
        --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (START)
        -- 트랜잭션 (END)
        --<<ERR_RTN>>
        IF V_LOG_TYPE = 'INVALID' THEN
            ROLLBACK;
                  --20180626 KHSONG INVALID LOG 생성
            V_LOG_MESSAGE := '########## END of procedure ##########';
            D_EVENT_DATE := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            -- 종료 LOG
            V_LOG_TYPE := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := NULL;
            D_EVENT_DATE := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            RAISE;
        END IF;
        --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (END)
    WHEN OTHERS THEN

        ROLLBACK;
        -- ERROR LOG
        V_LOG_TYPE := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM,1,1000);
        V_DESCRIPTION := 'ERROR_LINE : '  ||  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE := SYSTIMESTAMP;

        --IF V_OK_DESCRIPTION <> 'OK'
        --V_LOG_MESSAGE := CAST(V_OK_DESCRIPTION AS VARCHAR2(1000 CHAR));
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -- 종료 LOG
        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RAISE;

END DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA;
/

-- DMF0004_SAVE_SALES_SITE_DATA → PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_SAVE_SALES_SITE_DATA
(
	p_active_flag		VARCHAR2,
	p_division_id		VARCHAR2,
	p_scm_site_id		VARCHAR2,
	p_site_description	VARCHAR2,
	p_end_customer     VARCHAR2,
	p_sold_customer    VARCHAR2,
	p_city				VARCHAR2,
	p_country			VARCHAR2,
	p_dept_id			VARCHAR2,
	p_vmi_yn			VARCHAR2,
	p_valid_yn			VARCHAR2,
	p_created_by		VARCHAR2,
	p_company_id 		VARCHAR2,  -- 20180907 KHSONG company_id 추가
	p_ship_plan_auto	VARCHAR2,  -- 20200306
	p_distribution_channel	VARCHAR2,  -- PJ20200138 Distribution Channel 추가
	p_attribute5		VARCHAR2	--


)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:06
 * 파일: dbo.DMF0004_SAVE_SALES_SITE_DATA.sql
 * ----------------------------------------
 * ⚠ IF: IF:13  END IF:2  차이:+11
 * ⚠ BEGIN: BEGIN:13  END:11  차이:+2
 * ----------------------------------------
 * BEGIN 위치: L64, L156, L163, L267, L278, L288, L307, L321, L325, L340 ...
 * END;  위치: L250, L272, L283, L314, L315, L330, L332, L345, L366, L674 ...
 * ----------------------------------------
 * 힌트: BEGIN이 2개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_PLANT_ID VARCHAR2(4000 CHAR);
    v_OPERATION_GROUP VARCHAR2(4000 CHAR);
    v_SITE_DESCRIPTION VARCHAR2(4000 CHAR);
    v_SITE_TYPE VARCHAR2(4000 CHAR);
    v_CITY VARCHAR2(4000 CHAR);
    v_COUNTRY VARCHAR2(4000 CHAR);
    v_DEPT_ID VARCHAR2(4000 CHAR);
    v_VMI_YN VARCHAR2(4000 CHAR);
    v_VALID_YN VARCHAR2(4000 CHAR);
    v_NEW_YN VARCHAR2(4000 CHAR);
    v_SITE_HRCY_ID VARCHAR2(4000 CHAR);
    v_OSP_YN VARCHAR2(4000 CHAR);
    v_SHIP_FROZEN VARCHAR2(4000 CHAR);
    v_PROD_FROZEN VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_SOLDTO_CUSTOMER VARCHAR2(4000 CHAR);
    v_FP_PLAN_PERIOD VARCHAR2(4000 CHAR);
    v_BUILD_AHEAD VARCHAR2(4000 CHAR);
    v_LOGISTIC_PLANT_ID VARCHAR2(4000 CHAR);
    v_COMPANY_ID VARCHAR2(4000 CHAR);
    v_SITE_ID VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_ship_plan_auto VARCHAR2(4000 CHAR);
    v_distribution_channel VARCHAR2(4000 CHAR);
    v_attribute5 VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := 'DMF0004_SAVE_SALES_SITE_DATA';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN


	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;
	--    v_OK_description VARCHAR2(1200 CHAR);	-- cut off Generated Number






























	v_active_flag := NULL;
	v_DIVISION_ID := NULL;
	v_SCM_SITE_ID := NULL;
	v_PLANT_ID := NULL;
	v_OPERATION_GROUP := NULL;
	v_SITE_DESCRIPTION := NULL;
	v_SITE_TYPE := NULL;
	v_CITY := NULL;
	v_COUNTRY := NULL;
	v_DEPT_ID := NULL;
	v_VMI_YN := NULL;
	v_VALID_YN := NULL;
	v_NEW_YN := NULL;
	v_SITE_HRCY_ID := NULL;
	v_OSP_YN := NULL;
	v_SHIP_FROZEN := NULL;
	v_PROD_FROZEN := NULL;
	v_END_CUSTOMER := NULL;
	v_SOLDTO_CUSTOMER := NULL;
	v_FP_PLAN_PERIOD := NULL;
	v_BUILD_AHEAD := NULL;
	v_LOGISTIC_PLANT_ID := NULL;
	v_COMPANY_ID := NULL;
	v_SITE_ID := NULL;
	v_CREATED_BY := NULL;
	v_LAST_UPDATED_BY := NULL;
	v_ship_plan_auto := NULL;
	v_distribution_channel := NULL; -- PJ20200138 Distribution Channel 추가
	v_attribute5 := NULL;


	v_delimiter := '^';









	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_active_flag, v_delimiter);
		WHILE LENGTH(v_recv_active_flag) > 0 AND v_mst_loop_cnt < v_max_loop_cnt
		BEGIN

			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1;
			--SELECT v_mst_loop_cnt,'v_mst_loop_cnt'

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				v_active_flag := SCM_ARR_SPL_VAL(p_active_flag, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_active_flag

				v_division_id := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_division_id

				v_scm_site_id := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_scm_site_id

				v_site_description := SCM_ARR_SPL_VAL(p_site_description, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_site_description

				v_end_customer := SCM_ARR_SPL_VAL(p_end_customer, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_end_customer

				v_soldto_customer := SCM_ARR_SPL_VAL(p_sold_customer, v_delimiter , v_mst_loop_cnt) ;
				--SELECT @v_soldto_customer

				v_city := SCM_ARR_SPL_VAL(p_city, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_city

				v_country := SCM_ARR_SPL_VAL(p_country, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_country

				v_dept_id := SCM_ARR_SPL_VAL(p_dept_id, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_dept_id

				v_vmi_yn := SCM_ARR_SPL_VAL(p_vmi_yn, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_vmi_yn

				-- 20180621 KHSONG vmi_yn값이 없는경우 ''으로 기본값 셋팅
				IF  v_vmi_yn = '' OR v_vmi_yn IS NULL
					v_vmi_yn := '';

				IF  v_dept_id  IS NULL
					v_dept_id := NULL;

				v_valid_yn := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_valid_yn

				v_created_by := SCM_ARR_SPL_VAL(p_created_by, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_created_by

				v_LAST_UPDATED_BY := v_created_by;

				v_COMPANY_ID := SCM_ARR_SPL_VAL(p_COMPANY_ID, v_delimiter, v_mst_loop_cnt) ;

				v_ship_plan_auto := SCM_ARR_SPL_VAL(p_ship_plan_auto, v_delimiter, v_mst_loop_cnt) ;

				--PJ20200138 Distribution Channel 추가
				v_distribution_channel := SCM_ARR_SPL_VAL(p_distribution_channel, v_delimiter, v_mst_loop_cnt) ;

				v_attribute5 := SCM_ARR_SPL_VAL(p_attribute5, v_delimiter, v_mst_loop_cnt) ;

				-- -----------------------------------------------------------------------------------------------
				-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (START)
				v_active_flag := RTRIM(LTRIM(v_active_flag));
				v_division_id := RTRIM(LTRIM(v_division_id));
				v_scm_site_id := RTRIM(LTRIM(v_scm_site_id));
				v_site_description := RTRIM(LTRIM(v_site_description));
				v_end_customer := RTRIM(LTRIM(v_end_customer));
				v_soldto_customer := RTRIM(LTRIM(v_soldto_customer));
				v_city := RTRIM(LTRIM(v_city));
				v_country := RTRIM(LTRIM(v_country));
				v_PLANT_ID := RTRIM(LTRIM(v_PLANT_ID));
				v_OPERATION_GROUP := RTRIM(LTRIM(v_OPERATION_GROUP));
				v_COMPANY_ID := RTRIM(LTRIM(v_COMPANY_ID));
				v_dept_id := RTRIM(LTRIM(v_dept_id));
				v_ship_plan_auto := RTRIM(LTRIM(v_ship_plan_auto));
				v_distribution_channel := RTRIM(LTRIM(v_distribution_channel));
				v_vmi_yn := RTRIM(LTRIM(v_vmi_yn));
				v_valid_yn := RTRIM(LTRIM(v_valid_yn));
				v_SITE_HRCY_ID := RTRIM(LTRIM(v_SITE_HRCY_ID));
				v_OSP_YN := RTRIM(LTRIM(v_OSP_YN));
				v_SHIP_FROZEN := RTRIM(LTRIM(v_SHIP_FROZEN));
				v_PROD_FROZEN := RTRIM(LTRIM(v_PROD_FROZEN));
				v_FP_PLAN_PERIOD := RTRIM(LTRIM(v_FP_PLAN_PERIOD));
				v_BUILD_AHEAD := RTRIM(LTRIM(v_BUILD_AHEAD));
				v_LOGISTIC_PLANT_ID := RTRIM(LTRIM(v_LOGISTIC_PLANT_ID));
				v_SITE_ID := RTRIM(LTRIM(v_SITE_ID));
				v_created_by := RTRIM(LTRIM(v_created_by));
				v_attribute5 := RTRIM(LTRIM(v_attribute5));
				v_LAST_UPDATED_BY := RTRIM(LTRIM(v_LAST_UPDATED_BY));
				-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (END)
				-- -----------------------------------------------------------------------------------------------
			END

	       -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start 20180426 skh -----------------------------------------------
	       IF     v_division_id = ''
		      or  v_scm_site_id = ''
			  or  v_end_customer = ''
			  or  v_soldto_customer = ''
			  or  v_city = ''
			  or  v_country = ''
			  or  v_division_id is null
			  or  v_scm_site_id is null
			  or  v_end_customer is null
			  or  v_soldto_customer is null
			  or  v_city is null
			  or  v_country is null
			  or  v_ship_plan_auto is null;

			  BEGIN
				   v_log_type := 'INVALID';
				   SELECT '필수 입력값을 확인하세요.'
				   v_description := '필수 입력값을 확인하세요.';
				   goto err_rtn
			  END
	       -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end 20180426 skh -----------------------------------------------

		   	--[E20250305-000665]_Sales Site UI 입력항목 필수입력 처리 요청 START
			IF v_COMPANY_ID = ''

			  BEGIN
				   v_log_type := 'INVALID';
				   SELECT 'Company는 필수 입력 항목입니다.'
				   v_description := 'Company는 필수 입력 항목입니다.';
				   goto err_rtn
			  END
			--[E20250305-000665]_Sales Site UI 입력항목 필수입력 처리 요청 END

				----------◎◎◎◎ 20181121 KHSONG VALID_YN='' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (START)
				IF v_valid_yn = '' and v_division_id = '40'
					BEGIN
						IF (
							SELECT NVL(COUNT(1),0) FROM
															(SELECTDIVISION_ID
																FROM  DM_PLN_SALES_PLAN
																	WHERE 1=1
																	  AND DIVISION_ID		=	v_DIVISION_ID
																	  AND SCM_SITE_ID		=	v_SCM_SITE_ID
																	  AND QTY <> 0
															UNION
FETCH FIRST 1 ROWS ONLY
															SELECTDIVISION_ID
																FROM  DM_PLN_SALES_PLAN_RESULT
																	WHERE 1=1
																	  AND DIVISION_ID		=	v_DIVISION_ID
																	  AND SCM_SITE_ID		=	v_SCM_SITE_ID
																	  AND QTY <> 0
																) A;
						   ) > 0
							BEGIN
								v_description := 'SALES PLAN 정보가 존재하므로 Active='''' 처리가 불가합니다.' || char(10)  ||  'Sales Site : '  ||  v_SCM_SITE_ID
FETCH FIRST 1 ROWS ONLY
								select v_description
								v_log_type := 'INVALID';
								GOTO ERR_RTN
								FROM DUAL;
							END
					END
				----------◎◎◎◎ 20181121 KHSONG VALID_YN='' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (END)

		   -- 20180627 KHSONG Team Id값 Validation 추가 (start)
		   --IF v_division_id <> '40'
		   IF v_division_id not in('40','42','44')  -- 20190123 khsong 전지재료 로직추가
		   BEGIN
			   IF   NVL((SELECT COUNT(*) FROM SCM_MST_SSO_DEPT_INFO
								WHERE VALID_YN = 'Y' AND DEPT_ID = v_dept_id),0);
								= 0
				   BEGIN
						   v_log_type := 'INVALID';
						   SELECT '입력값:[ '  ||  v_dept_id  ||  ' ]'  ||  ' Team Id는 PopUp 화면에서 선택해주세요.'
						   v_description := '입력값:[ '  ||  v_dept_id  ||  ' ]'  ||  ' Team Id는 PopUp 화면에서 선택해주세요.';
						   goto err_rtn
				   END
			   -- 20180627 KHSONG Team Id값 Validation 추가 (end)
		   END

		   IF
				(SELECT COUNT(*)
					FROM SCM_MST_SITE
						WHERE SCM_SITE_ID = v_SCM_SITE_ID
						AND  division_id = v_division_id
						AND v_active_flag = 'I')  > 0;
				   BEGIN
						   v_log_type := 'INVALID';
						   SELECT '이미 존재하는 Site 정보입니다.'
						   v_description := v_SCM_SITE_ID  ||  '이미 존재하는 Site 정보입니다.';
						   goto err_rtn
				   END


		   -- 20180712 KHSONG SCM_MST_SITE 에 UPDATE건중 VALID_YN=''이면 SCM_MST_SITE_CUSTOMER의 데이터를 VALID_YN=''으로 일괄 업데이트함  (START)
		   IF		v_active_flag = 'M'  -- UPDATE건인 경우
				AND v_valid_yn = ''; -- valid ''처리요청건인경우
					BEGIN
						UPDATE SCM_MST_SITE_CUSTOMER
							SET VALID_YN = '' , REP_YN = '' , LAST_UPDATED_BY = v_created_by , LAST_UPDATE_DATE = SYSDATE
								WHERE 	division_id  = v_division_id
									AND scm_site_id  = v_scm_site_id;

							-- History 생성 20180726 Added
							PR_DM_MST_SITE_CUSTOMER_HIST
										v_division_id,
										v_scm_site_id,
										'ALL', --v_soldto_code,
										'ALL', --v_shipto_code,
										'',--v_rep_yn,
										v_created_by
										, v_valid_yn  -- [C20210115-000214] (1)
					END
		   -- 20180712 KHSONG SCM_MST_SITE 에 UPDATE건중 VALID_YN=''이면 SCM_MST_SITE_CUSTOMER의 데이터를 VALID_YN=''으로 일괄 업데이트함  (END)

				--HISTORY INSERT

		--		select v_division_id+' '+v_scm_site_id+' '+v_site_description+' '+v_city+' '+v_country+' '+v_dept_id+' '+v_vmi_yn+' '+v_valid_yn+' '+v_end_customer+' '+v_created_by
				PR_DM_MST_SITE_HIST	--v_return_value = PR_DM_MST_SITE_HIST
						 v_DIVISION_ID
						,v_SCM_SITE_ID
						,v_SITE_DESCRIPTION
						,'SALES' --v_SITE_TYPE
						,v_CITY
						,v_COUNTRY
						,v_PLANT_ID
						,v_OPERATION_GROUP
						,v_DEPT_ID
						,v_VMI_YN
						,v_VALID_YN
						,'Y' --v_NEW_YN
						,v_SITE_HRCY_ID
						,v_OSP_YN
						,v_SHIP_FROZEN
						,v_PROD_FROZEN
						,v_END_CUSTOMER
						,v_SOLDTO_CUSTOMER
						,v_FP_PLAN_PERIOD
						,v_BUILD_AHEAD
						,v_LOGISTIC_PLANT_ID
						,v_COMPANY_ID
						,v_SITE_ID
						,v_CREATED_BY
						,v_LAST_UPDATED_BY
						,''
						,v_ship_plan_auto
						,v_distribution_channel --PJ20200138 Distribution Channel 추가
						,v_attribute5

			IF v_mst_loop_cnt > 0

				BEGIN

					-- 임시확인용
					--select 'v_division_id', v_division_id,'v_scm_site_id',v_scm_site_id
					MERGE INTO SCM_MST_SITE A;
					USING (
							SELECT
								v_division_id	as division_id,
								v_scm_site_id	as site_id
						  ) B;
					ON(
							    A.division_id  = B.division_id
							AND A.scm_site_id  = B.site_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET;
/*
								 division_id		= v_division_id
								,v_scm_site_id AS scm_site_id
								,v_site_description AS site_description
								,'SALES' AS site_type
								,v_end_customer AS end_customer
								,v_soldto_customer AS soldto_customer
								,v_city AS city
								,v_country AS country
*/								--[C20200915-000323] Sales Site 에대한 team 변경 권한 추가
								 dept_id			= v_dept_id
								,v_vmi_yn AS vmi_yn
								,v_valid_yn AS valid_yn
							--	,v_new_yn AS new_yn
								,v_COMPANY_ID  --20180907 KHSONG company_id 추가 AS COMPANY_ID
								,v_created_by AS last_updated_by
								,SYSTIMESTAMP AS last_update_date
								,v_ship_plan_auto AS attribute2
								,v_distribution_channel --PJ20200138 Distribution Channel 추가 AS attribute3
								,v_attribute5 AS attribute5

					WHEN NOT MATCHED THEN

						 INSERT (;
								    division_id
								   ,scm_site_id
								   ,site_description
								   ,site_type
								   ,end_customer
								   ,soldto_customer
								   ,city
								   ,country
								   ,dept_id
								   ,vmi_yn
								   ,valid_yn
								   ,new_yn
								   ,COMPANY_ID --20180907 KHSONG company_id 추가
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								   ,attribute2
								   ,attribute3
								   ,attribute5
								)
						 VALUES (
									v_division_id
								   ,v_scm_site_id
								   ,v_site_description
								   ,'SALES'
								   ,v_end_customer
								   ,v_soldto_customer
								   ,v_city
								   ,v_country
								   ,v_dept_id
								   ,v_vmi_yn
								   ,v_valid_yn
								   ,'Y'
								   ,v_COMPANY_ID --20180907 KHSONG company_id 추가
								   ,v_created_by
								   ,SYSTIMESTAMP
								   ,v_created_by
								   ,SYSTIMESTAMP
								   ,v_ship_plan_auto
								   ,v_distribution_channel --PJ20200138 Distribution Channel 추가
								   ,v_attribute5
								);


			ELSE  --단일 ROW 일때

				BEGIN
					v_active_flag := p_active_flag;
					p_active_flag := NULL;
					v_division_id := p_division_id;
					p_division_id := NULL;
					v_site_description := p_site_description;
					p_site_description := NULL;
					v_end_customer := p_end_customer;
					p_end_customer := NULL;
					v_soldto_customer := p_sold_customer;
					p_sold_customer := NULL;
					v_city := p_city;
					p_city := NULL;
					v_country := p_country;
					p_country := NULL;
					v_dept_id := p_dept_id;
					p_dept_id := NULL;
					v_vmi_yn := p_vmi_yn;
					p_vmi_yn := NULL;
					v_ship_plan_auto := p_ship_plan_auto;
					p_ship_plan_auto := NULL;
					--PJ20200138 Distribution Channel 추가
					v_distribution_channel := p_distribution_channel;
					p_distribution_channel := NULL;

					-- 20180621 KHSONG vmi_yn값이 없는경우 ''으로 기본값 셋팅
					IF  v_vmi_yn = '' OR v_vmi_yn IS NULL THEN
						v_vmi_yn := '';

					v_valid_yn := p_valid_yn;
					p_valid_yn := NULL;
					v_created_by := p_created_by;
					p_created_by := NULL;

					v_attribute5 := p_attribute5;
					p_attribute5 := NULL;

					-- -----------------------------------------------------------------------------------------------
					-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (START)
					v_active_flag := RTRIM(LTRIM(v_active_flag));
					v_division_id := RTRIM(LTRIM(v_division_id));
					v_scm_site_id := RTRIM(LTRIM(v_scm_site_id));
					v_site_description := RTRIM(LTRIM(v_site_description));
					v_end_customer := RTRIM(LTRIM(v_end_customer));
					v_soldto_customer := RTRIM(LTRIM(v_soldto_customer));
					v_city := RTRIM(LTRIM(v_city));
					v_country := RTRIM(LTRIM(v_country));
					v_PLANT_ID := RTRIM(LTRIM(v_PLANT_ID));
					v_OPERATION_GROUP := RTRIM(LTRIM(v_OPERATION_GROUP));
					v_COMPANY_ID := RTRIM(LTRIM(v_COMPANY_ID));
					v_dept_id := RTRIM(LTRIM(v_dept_id));
					v_ship_plan_auto := RTRIM(LTRIM(v_ship_plan_auto));
					v_distribution_channel := RTRIM(LTRIM(v_distribution_channel));
					v_vmi_yn := RTRIM(LTRIM(v_vmi_yn));
					v_valid_yn := RTRIM(LTRIM(v_valid_yn));
					v_SITE_HRCY_ID := RTRIM(LTRIM(v_SITE_HRCY_ID));
					v_OSP_YN := RTRIM(LTRIM(v_OSP_YN));
					v_SHIP_FROZEN := RTRIM(LTRIM(v_SHIP_FROZEN));
					v_PROD_FROZEN := RTRIM(LTRIM(v_PROD_FROZEN));
					v_FP_PLAN_PERIOD := RTRIM(LTRIM(v_FP_PLAN_PERIOD));
					v_BUILD_AHEAD := RTRIM(LTRIM(v_BUILD_AHEAD));
					v_LOGISTIC_PLANT_ID := RTRIM(LTRIM(v_LOGISTIC_PLANT_ID));
					v_SITE_ID := RTRIM(LTRIM(v_SITE_ID));
					v_created_by := RTRIM(LTRIM(v_created_by));
					v_attribute5 := RTRIM(LTRIM(v_attribute5));
					v_LAST_UPDATED_BY := RTRIM(LTRIM(v_LAST_UPDATED_BY));
					-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (END)
					-- -----------------------------------------------------------------------------------------------
					--HISTORY INSERT INTO PR_DM_MST_SITE_HIST	--v_return_value = PR_DM_MST_SITE_HIST
						 v_DIVISION_ID
						,v_SCM_SITE_ID
						,v_SITE_DESCRIPTION
						,'SALES' -- v_SITE_TYPE
						,v_CITY
						,v_COUNTRY
						,v_PLANT_ID
						,v_OPERATION_GROUP
						,v_DEPT_ID
						,v_VMI_YN
						,v_VALID_YN
						,'Y' --v_NEW_YN
						,v_SITE_HRCY_ID
						,v_OSP_YN
						,v_SHIP_FROZEN
						,v_PROD_FROZEN
						,v_END_CUSTOMER
						,v_SOLDTO_CUSTOMER
						,v_FP_PLAN_PERIOD
						,v_BUILD_AHEAD
						,v_LOGISTIC_PLANT_ID
						,v_COMPANY_ID
						,v_SITE_ID
						,v_CREATED_BY
						,v_LAST_UPDATED_BY
						,''
						,v_ship_plan_auto
						,v_distribution_channel --PJ20200138 Distribution Channel 추가
						,v_attribute5



					MERGE INTO SCM_MST_SITE A;
					USING (
							SELECT
								v_division_id	as division_id,
								v_scm_site_id	as site_id
						  ) B;
					ON(
							    A.division_id  = B.division_id
							AND A.scm_site_id  = B.site_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET;
/*
								 division_id		= v_division_id
								,v_scm_site_id AS scm_site_id
								,v_site_description AS site_description
								,'SALES' AS site_type
								,v_end_customer AS end_customer
								,v_soldto_customer AS soldto_customer
								,v_city AS city
								,v_country AS country
								,v_dept_id AS dept_id
*/
								 vmi_yn				= v_vmi_yn
								,v_valid_yn AS valid_yn
								--	,v_new_yn AS new_yn
								,v_COMPANY_ID  --20180907 KHSONG company_id 추가 AS COMPANY_ID
								,v_created_by AS last_updated_by
								,SYSTIMESTAMP AS last_update_date
								,v_ship_plan_auto AS attribute2
								,v_distribution_channel --PJ20200138 Distribution Channel 추가 AS attribute3
								,v_attribute5 AS attribute5

					WHEN NOT MATCHED THEN

						 INSERT (;
								    division_id
								   ,scm_site_id
								   ,site_description
								   ,site_type
								   ,end_customer
								   ,soldto_customer
								   ,city
								   ,country
								   ,dept_id
								   ,vmi_yn
								   ,valid_yn
								   ,new_yn
								   ,COMPANY_ID --20180907 KHSONG company_id 추가
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								   ,attribute2
								   ,attribute3 --PJ20200138 Distribution Channel 추가
								   ,attribute5
								)
						 VALUES (
									v_division_id
								   ,v_scm_site_id
								   ,v_site_description
								   ,'SALES'
								   ,v_end_customer
								   ,v_soldto_customer
								   ,v_city
								   ,v_country
								   ,v_dept_id
								   ,v_vmi_yn
								   ,v_valid_yn
								   ,'Y'
								   ,v_COMPANY_ID --20180907 KHSONG company_id 추가
								   ,v_created_by
								   ,SYSTIMESTAMP
								   ,v_created_by
								   ,SYSTIMESTAMP
								   ,v_ship_plan_auto
								   ,v_distribution_channel --PJ20200138 Distribution Channel 추가
								   ,v_attribute5
								);

				END IF;
			END;


		COMMIT  ;



		-- END TRY


	EXCEPTION
	    WHEN OTHERS THEN

      -- ROLLBACK

      -- ERROR LOG
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

      PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
	  FROM DUAL;

    -- END CATCH


	--SELECT 'success'

	-- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);


	-- 트랜잭션 (END)
	err_rtn:
	IF v_log_type = 'INVALID' THEN
						v_log_message := '########## END of procedure ##########';
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			-- 2020.12.15 hwi1993
			PR_SCM_SYS_LOG_BATCH(v_program_name, 'END', n_log_count, v_log_message, v_description, d_event_date);

			-- 종료 LOG
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		END IF;
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- DMF0004_SAVE_SALES_SITE_LOCATION_DATA → PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0004_SAVE_SALES_SITE_LOCATION_DATA
(
	p_active_flag			VARCHAR2,
	p_location_seq         VARCHAR2,
	p_division_id			VARCHAR2,
	p_location_code		VARCHAR2,
	p_location_description	VARCHAR2,
	p_scm_site_id			VARCHAR2,
	p_plant_id				VARCHAR2,
	p_storage_id			VARCHAR2,
	p_valid_yn             VARCHAR2,
	p_created_by			VARCHAR2

/****************************************************************************************************/
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:07
 * 파일: dbo.DMF0004_SAVE_SALES_SITE_LOCATION_DATA.sql
 * ----------------------------------------
 * ⚠ IF: IF:6  END IF:0  차이:+6
 * ⚠ BEGIN: BEGIN:10  END:12  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L41, L97, L108, L117, L156, L183, L212, L281, L306, L432
 * END;  위치: L119, L145, L163, L190, L277, L308, L392, L394, L444, L446
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_division_id VARCHAR2(4000 CHAR);
    v_location_code VARCHAR2(4000 CHAR);
    v_location_description VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_plant_id VARCHAR2(4000 CHAR);
    v_storage_id VARCHAR2(4000 CHAR);
    v_valid_yn VARCHAR2(4000 CHAR);
    v_location_seq VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    n_location_seq INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := 'DMF0004_SAVE_SALES_SITE_LOCATION_DATA';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    s_scm_site_id VARCHAR2(100 CHAR);
BEGIN


	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;
	-- 자식 프로시저 성공/에러 셋팅
	--    v_OK_description VARCHAR2(1200 CHAR);











	v_active_flag := NULL;
	v_division_id := NULL;
	v_location_code := NULL;
	v_location_description := NULL;
	v_scm_site_id := NULL;
	v_plant_id := NULL;
	v_storage_id := NULL;
	v_valid_yn := NULL;
	v_location_seq := NULL;
	v_created_by := NULL;


	v_delimiter := '^';









	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN TRY
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_active_flag, v_delimiter);
		--SELECT    v_max_loop_cnt;

		WHILE LENGTH(v_recv_active_flag) > 0 AND v_mst_loop_cnt < v_max_loop_cnt
		BEGIN

			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1;
			--SELECT v_mst_loop_cnt,'v_mst_loop_cnt'

			-- location_seq 채번
			n_location_seq := NEXT VALUE FOR SEQ1_SCM_MST_LOCATION; -- -- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
			--SELECT n_location_seq

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				v_active_flag := SCM_ARR_SPL_VAL(p_active_flag, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_active_flag

				v_location_seq := SCM_ARR_SPL_VAL(p_location_seq, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_location_seq

				IF v_location_seq = ''
				BEGIN
				v_location_seq := n_location_seq;
				END;

				v_division_id := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_division_id

				v_location_code := SCM_ARR_SPL_VAL(p_location_code, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_location_code

				v_location_description := SCM_ARR_SPL_VAL(p_location_description, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_location_description

				v_scm_site_id := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_scm_site_id

				v_plant_id := SCM_ARR_SPL_VAL(p_plant_id, v_delimiter , v_mst_loop_cnt) ;
				--SELECT v_plant_id

				v_storage_id := SCM_ARR_SPL_VAL(p_storage_id, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_storage_id

				v_valid_yn := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_valid_yn

				v_created_by := SCM_ARR_SPL_VAL(p_created_by, v_delimiter, v_mst_loop_cnt) ;
				--SELECT v_created_by

			END

			-- [C20200224-000354] SLOC 입력 시 SLOC Master에 존재하는지 확인
			IF not exists  (SELECTNVL(A.STORAGE_ID, NULL)
							from SCM_MST_SLOC A
							WHERE 1=1
							and A.VALID_YN    = 'Y'
							and A.DIVISION_ID = v_division_id
							and A.PLANT_ID	  = v_PLANT_ID
							and A.STORAGE_ID  = v_location_code );

			BEGIN
FETCH FIRST 1 ROWS ONLY
				SELECT 'storage id : '  ||  v_location_code  ||  ' 은(는) 존재하지 않는 Storage 입니다.';
				v_log_type := 'INVALID';
				v_description := 'storage id : '  ||  v_location_code  ||  ' 은(는) 존재하지 않는 Storage 입니다.';
				GOTO ERR_RTN
				FROM DUAL;
			END

			-- 20181019 KHSONG 중복값 VALIDATION 추가

			s_scm_site_id := NULL;

			s_scm_site_id := ( SELECTNVL(A.SCM_SITE_ID, NULL)
										from SCM_MST_LOCATION A
											INNER JOIN SCM_MST_SITE B
												ON  A.DIVISION_ID = B.DIVISION_ID
												AND B.SCM_SITE_ID = v_scm_site_id
												AND B.SITE_TYPE   = 'SALES'
												AND A.VALID_YN    = 'Y'
									  WHERE 1=1
										and A.DIVISION_ID = v_division_id
										and A.PLANT_ID	  = v_PLANT_ID
										and A.STORAGE_ID  = v_storage_id
										and A.SCM_SITE_ID <> v_scm_site_id
								)
				IF  s_scm_site_id IS NOT NULL
					BEGIN
FETCH FIRST 1 ROWS ONLY
						SELECT 'storage id : '  ||  v_storage_id  ||  ' 은(는)'  ||  '  Sales Site : '  ||  s_scm_site_id  ||  ' 에서'  || char(10)  ||  '이미 사용중입니다.';
						v_log_type := 'INVALID';
						v_description := 'storage id : '  ||  v_storage_id  ||  ' 은(는)'  ||  '  Sales Site : '  ||  s_scm_site_id  ||  ' 에서'  || char(10)  ||  '이미 사용중입니다.';
						GOTO ERR_RTN
						FROM DUAL;
					END
			-- 20181019 KHSONG 중복값 VALIDATION 추가

			PR_DM_MST_SITE_SLOC_MAPPING_HIST	--v_return_value = PR_DM_MST_SITE_SLOC_MAPPING_HIST

					v_location_seq,
					v_division_id,
					v_location_code,
					v_location_description,
					v_scm_site_id,
					v_plant_id,
					'***',		--p_factory_id
					'***',		--p_operation_id
					v_storage_id,
					NULL,		--p_electrode_type,
					v_valid_yn,		--p_valid_yn,
					v_created_by

					--SELECT v_OK_description;
					--v_OK_description OUTPUT

			IF v_mst_loop_cnt > 0
			BEGIN

	-- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
			MERGE INTO SCM_MST_LOCATION A;
			USING (
					SELECT
						v_location_seq		as location_seq,
						v_division_id		as division_id,
						v_location_code	as location_code
					) B;
			ON(
						A.location_seq	= B.location_seq
					AND A.division_id	= B.division_id
					AND A.location_code = B.location_code
				)
			WHEN MATCHED THEN
					UPDATE SET;
							--location_seq			= n_location_seq
						 division_id			= v_division_id
						,v_location_code AS location_code
						,v_location_description AS location_description
						,v_scm_site_id AS scm_site_id
						,v_plant_id AS plant_id
						,'***' AS factory_id
						,'***' AS operation_id
						,v_storage_id AS storage_id
						,v_valid_yn AS valid_yn
						,v_created_by AS last_updated_by
						,SYSTIMESTAMP AS last_update_date

			WHEN NOT MATCHED THEN

					INSERT (;
							location_seq
							,division_id
							,location_code
							,location_description
							,scm_site_id
							,plant_id
							,factory_id
							,operation_id
							,storage_id
							,valid_yn
							,created_by
							,creation_date
							,last_updated_by
							,last_update_date
						)
					VALUES (
							 v_location_seq		--n_location_seq+8000
							,v_division_id
							,v_location_code
							,v_location_description
							,v_scm_site_id
							,v_plant_id
							,'***'
							,'***'
							,v_storage_id
							,v_valid_yn
							,v_created_by
							,SYSTIMESTAMP
							,v_created_by
							,SYSTIMESTAMP
						);

			  END

			ELSE    --단일 ROW 일때

				BEGIN
					v_active_flag := p_active_flag;
					p_active_flag := NULL;
					v_location_seq := p_location_seq;
					p_location_seq := NULL;
					v_division_id := p_division_id;
					p_division_id := NULL;
					v_location_code := p_location_code;
					p_location_code := NULL;
					v_location_description := p_location_description;
					p_location_description := NULL;
					v_scm_site_id := p_scm_site_id;
					p_scm_site_id := NULL;
					v_storage_id := p_storage_id;
					p_storage_id := NULL;
					v_valid_yn := p_valid_yn;
					p_valid_yn := NULL;
					v_created_by := p_created_by;
					p_created_by := NULL;

					-- location_seq 채번
					n_location_seq := NEXT VALUE FOR SEQ1_SCM_MST_LOCATION; -- -- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
					--SELECT n_location_seq

					IF p_location_seq IS NULL
					BEGIN
					    v_location_seq := n_location_seq;
					END;

					--HISTORY INSERT INTO PR_DM_MST_SITE_SLOC_MAPPING_HIST	--v_return_value = PR_DM_MST_SITE_SLOC_MAPPING_HIST

						v_location_seq,
						v_division_id,
						v_location_code,
						v_location_description,
						v_scm_site_id,
						v_plant_id,
						'***',		--p_factory_id
						'***',		--p_operation_id
						v_storage_id,
						NULL,		--p_electrode_type,
						v_valid_yn,		--p_valid_yn,
						v_created_by

						--SELECT v_OK_description;
						--v_OK_description OUTPUT


					MERGE INTO SCM_MST_LOCATION A;
					USING (
							SELECT
								v_location_seq		as location_seq,
								v_division_id		as division_id,
								v_location_code	as location_code
						  ) B;
					ON(
							    A.location_seq	= B.location_seq
							AND A.division_id	= B.division_id
							AND A.location_code = B.location_code
					  )
					WHEN MATCHED THEN
						 UPDATE SET;
								 --location_seq			= n_location_seq+8000
								 location_seq			= v_location_seq
								,v_division_id AS division_id
								,v_location_code AS location_code
								,v_location_description AS location_description
								,v_scm_site_id AS scm_site_id
								,v_plant_id AS plant_id
								,'***' AS factory_id
								,'***' AS operation_id
								,v_storage_id AS storage_id
								,v_valid_yn AS valid_yn
								,v_created_by AS last_updated_by
								,SYSTIMESTAMP AS last_update_date

					WHEN NOT MATCHED THEN

						 INSERT (;
									location_seq
								   ,division_id
								   ,location_code
								   ,location_description
								   ,scm_site_id
								   ,plant_id
								   ,factory_id
								   ,operation_id
								   ,storage_id
								   ,valid_yn
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (
									v_location_seq	-- n_location_seq+8000
								   ,v_division_id
								   ,v_location_code
								   ,v_location_description
								   ,v_scm_site_id
								   ,v_plant_id
								   ,'***'
								   ,'***'
								   ,v_storage_id
								   ,v_valid_yn
								   ,v_created_by
								   ,SYSTIMESTAMP
								   ,v_created_by
								   ,SYSTIMESTAMP
								);

				END

			END

			COMMIT ;

		END TRY

   	BEGIN CATCH


      -- ERROR LOG
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

	  --IF v_OK_description <> 'OK'
	  --v_log_message := CAST(v_OK_description AS VARCHAR2(1000 CHAR));

      PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
	  FROM DUAL;

    END CATCH;

	--select 'success'

	-- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);


	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
		IF  v_log_type = 'INVALID'
			BEGIN
								-- 종료 LOG
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSTIMESTAMP;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

				-- 종료 LOG
				v_log_type := 'END';
				v_log_message := '########## END of procedure ##########';
				v_description := NULL;
				d_event_date := SYSTIMESTAMP;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			END;

  END;
/
