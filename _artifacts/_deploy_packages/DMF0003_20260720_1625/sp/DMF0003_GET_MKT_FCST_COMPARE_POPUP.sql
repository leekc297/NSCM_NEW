CREATE OR REPLACE PROCEDURE           "DMF0003_GET_MKT_FCST_COMPARE_POPUP"
(
    p_division_id    VARCHAR2,
    p_scm_site_id    VARCHAR2,
    p_project_code   VARCHAR2,
    p_item_id        VARCHAR2,
	--[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
	p_dom_exp		  VARCHAR2,
	p_fcst_type	  VARCHAR2,
	p_incoterms	  VARCHAR2,
	p_yyyymmdd		  VARCHAR2,
	O_RC1 OUT SYS_REFCURSOR
)
AS
/**************************************************************************************************
 Program ID  : DMF0003_GET_MKT_FCST_COMPARE_POPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-------------------------------------------------------------------------------------------------
 Date        In Charge    Description
-------------------------------------------------------------------------------------------------
 2021-01-13   KUNI		[C20210112-000446] 동기화된 수량 내역 보여주는 팝업 창(MKT FCST, SSP수량
 2021-02-22   P.C.I		[C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 기준으로 쿼리 변경
 2022-04-25	HWI1993		GM JV 작업
 2026.06.08   ZIONEX       [PJ202650304] NextSCM Migration : 결과셋 반환 복원 + #TEMP_DM_SSP를 WITH절(CTE)로 인라인(버그타입 MKT_FCST_COMPARE_POPUP_ROW.CREATED_BY=NUMBER 회피, ORA-01722 해소). ATTRIBUTE5 빈문자 RTRIM 보정.
*************************************************************************************************
*/
    V_PROGRAM_NAME	VARCHAR2(150 CHAR) := 'DMF0003_GET_MKT_FCST_COMPARE_POPUP';
    V_LOG_TYPE		VARCHAR2(30 CHAR);
    N_LOG_COUNT		INTEGER := 0;
    V_LOG_MESSAGE	VARCHAR2(1000 CHAR);
    V_DESCRIPTION	VARCHAR2(500 CHAR);
    D_EVENT_DATE	DATE;
BEGIN
	-- 시작 LOG
	V_LOG_TYPE := 'START';
	V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
	V_DESCRIPTION := '';
	D_EVENT_DATE := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

	OPEN O_RC1 FOR
	WITH SSP AS (
		--1. 동기화
		select 'SYNC' AS CATEGORY
			 , SYNC.VALUE AS CONFIRM_ID
			 , A.*
		from   DM_PLN_MKT_FCST A
		CROSS JOIN LATERAL (  SELECT ID,VALUE FROM FN_SplitString(A.ATTRIBUTE4,','))  SYNC
		where  1=1
		and    measure		= 'MKT_FCST'
		and    division_id	= p_division_id
		and    project_code	= p_project_code
		AND    scm_site_id	= p_scm_site_id
		AND    ITEM_ID		= p_item_id
		and    dom_exp		= p_dom_exp
		and    fcst_type	= p_fcst_type
		and    incoterms	= p_incoterms
		AND    YYYYMMDD		= p_yyyymmdd
		UNION ALL
		--2. 캐리오버
		select 'CARRY_OVER' AS CATEGORY
			 , CARRY.VALUE AS CONFIRM_ID
			 , A.*
		from   DM_PLN_MKT_FCST A
		CROSS JOIN LATERAL (  SELECT ID,VALUE FROM FN_SplitString(A.ATTRIBUTE5,','))  CARRY
		where  1=1
		and    measure		= 'MKT_FCST'
		and    division_id	= p_division_id
		and    project_code	= p_project_code
		AND    scm_site_id	= p_scm_site_id
		AND    ITEM_ID		= p_item_id
		and    dom_exp		= p_dom_exp
		and    fcst_type	= p_fcst_type
		and    incoterms	= p_incoterms
		AND    YYYYMMDD		= p_yyyymmdd
		AND    RTRIM(A.ATTRIBUTE5) IS NOT NULL
		--3. 네팅 (원본 주석처리 유지)
		--4.MKT Fcst
		UNION ALL
		select 'MKT_FCST' AS CATEGORY
			 , '' AS CONFIRM_ID
			 , A.*
		from   DM_PLN_MKT_FCST A
		where  1=1
		and    measure		= 'MKT_FCST'
		and    division_id	= p_division_id
		and    project_code	= p_project_code
		AND    scm_site_id	= p_scm_site_id
		AND    ITEM_ID		= p_item_id
		and    dom_exp		= p_dom_exp
		and    fcst_type	= p_fcst_type
		and    incoterms	= p_incoterms
		AND    YYYYMMDD		= p_yyyymmdd
	)
	--MKT_FCST = Confrim 제외 수량
	SELECT * FROM (
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
			 , A.CATEGORY, A.CONFIRM_ID
			 , CASE WHEN CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INTEGER) AS VARCHAR2(10 CHAR)) = '0'
						THEN ''
					ELSE CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INTEGER) AS VARCHAR2(10 CHAR))
				END AS SO_NO
			 , PLAN_QTY, SHIP_RESULT_QTY AS RESULT_QTY
			 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
					  WHEN A.CATEGORY = 'SYNC' THEN 2
					  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
					  ELSE 4
				 END AS SEQ
		FROM   SSP A
		INNER JOIN DM_PLN_MKT_FCST_CONFIRM B
		ON   ( A.CONFIRM_ID = B.CONFIRM_ID
		   AND A.ITEM_ID = B.ITEM_ID )
		UNION ALL
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
			 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 'Non-Sync MKT Fcst'
					WHEN A.CATEGORY = 'SYNC' THEN 'Sync'
					WHEN A.CATEGORY = 'CARRY_OVER' THEN 'Carry Over'
				END AS CATEGORY
			 , A.CONFIRM_ID, '' AS SO_NO
			 , MAX(QTY) - NVL(( SELECT SUM(PLAN_QTY)
									FROM   SSP A
									INNER JOIN DM_PLN_MKT_FCST_CONFIRM B
									ON   ( A.CONFIRM_ID = B.CONFIRM_ID
									   AND A.ITEM_ID = B.ITEM_ID )), 0) AS PLAN_QTY
			 , NULL AS SHIP_RESULT_QTY
			 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
					  WHEN A.CATEGORY = 'SYNC' THEN 2
					  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
					  ELSE 4
				 END AS SEQ
		FROM   SSP A
		WHERE  CATEGORY = 'MKT_FCST'
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
			 , A.CATEGORY, A.CONFIRM_ID
	)
	ORDER BY SEQ, CONFIRM_ID;

	-- 종료 LOG
	V_LOG_TYPE := 'END';
	V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
	D_EVENT_DATE := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;
/
