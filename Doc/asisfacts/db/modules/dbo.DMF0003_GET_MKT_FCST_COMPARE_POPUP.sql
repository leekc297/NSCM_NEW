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
*************************************************************************************************
*/

CREATE PROCEDURE [dbo].[DMF0003_GET_MKT_FCST_COMPARE_POPUP]
    @p_division_id    NVARCHAR(30),
    @p_scm_site_id    NVARCHAR(4000),
    @p_project_code   NVARCHAR(4000),
    @p_item_id        NVARCHAR(4000),
	--[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
	@p_dom_exp		  NVARCHAR(10),
	@p_fcst_type	  NVARCHAR(10),
	@p_incoterms	  NVARCHAR(10),
	@p_yyyymmdd		  NVARCHAR(8) 
AS  
  
BEGIN
    SET NOCOUNT ON;
	
	
	-- LOG 용 변수 설정
    DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'DMF0003_GET_MKT_FCST_COMPARE_POPUP';
    DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @N_LOG_COUNT		INTEGER = 0;
    DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
    DECLARE @V_DESCRIPTION		NVARCHAR(500);
    DECLARE @D_EVENT_DATE		DATETIME;
    DECLARE @N_DELETE_COUNT		INTEGER = 0;
    DECLARE @N_INSERT_COUNT     INTEGER = 0;

	-- 시작 LOG
	SET @V_LOG_TYPE = 'START';
	SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
	SET @V_DESCRIPTION = '';
	SET @D_EVENT_DATE = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;



	--1. 동기화
	select 'SYNC' AS CATEGORY
		 , SYNC.VALUE AS CONFIRM_ID
		 , A.*
	INTO   #TEMP_DM_SSP
	from   DM_PLN_MKT_FCST A with(nolock)
	CROSS APPLY (  SELECT ID,VALUE FROM dbo.FN_SplitString(A.ATTRIBUTE4,','))  SYNC
	where  1=1 
	and    measure		= 'MKT_FCST'
	and    division_id	= @p_division_id
	and    project_code	= @p_project_code
	AND    scm_site_id	= @p_scm_site_id
	AND    ITEM_ID		= @p_item_id
	and    dom_exp		= @p_dom_exp
	and    fcst_type	= @p_fcst_type
	and    incoterms	= @p_incoterms
	AND    YYYYMMDD		= @p_yyyymmdd

	UNION ALL
	--2. 캐리오버
	select 'CARRY_OVER' AS CATEGORY
		 , CARRY.VALUE AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A with(nolock)
	CROSS APPLY (  SELECT ID,VALUE FROM dbo.FN_SplitString(A.ATTRIBUTE5,','))  CARRY
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= @p_division_id
	and    project_code	= @p_project_code
	AND    scm_site_id	= @p_scm_site_id
	AND    ITEM_ID		= @p_item_id
	and    dom_exp		= @p_dom_exp
	and    fcst_type	= @p_fcst_type
	and    incoterms	= @p_incoterms
	AND    YYYYMMDD		= @p_yyyymmdd
	AND    ISNULL(A.ATTRIBUTE5, '') <> ''
	UNION ALL
	--3. 네팅
	/*select 'NETTING' AS CATEGORY
		 , NET.VALUE AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A with(nolock)
	CROSS APPLY (  SELECT ID,VALUE FROM dbo.FN_SplitString(A.ATTRIBUTE6,','))  NET
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= @p_division_id
	and    project_code	= @p_project_code
	AND    scm_site_id	= @p_scm_site_id
	AND    ITEM_ID		= @p_item_id
	and    dom_exp		= @p_dom_exp
	and    fcst_type	= @p_fcst_type
	and    incoterms	= @p_incoterms
	AND    YYYYMMDD		= @p_yyyymmdd
	AND    ISNULL(A.ATTRIBUTE6, '') <> ''
	UNION ALL*/
	--4.MKT Fcst
	select 'MKT_FCST' AS CATEGORY
		 , '' AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A with(nolock)
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= @p_division_id
	and    project_code	= @p_project_code
	AND    scm_site_id	= @p_scm_site_id
	AND    ITEM_ID		= @p_item_id
	and    dom_exp		= @p_dom_exp
	and    fcst_type	= @p_fcst_type
	and    incoterms	= @p_incoterms
	AND    YYYYMMDD		= @p_yyyymmdd


	--MKT_FCST = Confrim 제외 수량
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , A.CATEGORY, A.CONFIRM_ID
		 , CASE WHEN CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INT) AS nvarchar(10)) = '0' 
					THEN '' 
				ELSE CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INT) AS nvarchar(10)) 
			END AS SO_NO
		 , PLAN_QTY, SHIP_RESULT_QTY AS RESULT_QTY
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END AS SEQ
	FROM   #TEMP_DM_SSP A
	INNER JOIN DM_PLN_MKT_FCST_CONFIRM B WITH(NOLOCK)
	ON   ( A.CONFIRM_ID = B.CONFIRM_ID
	   AND A.ITEM_ID = B.ITEM_ID )
	UNION ALL 
	
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 'Non-Sync MKT Fcst'
				WHEN A.CATEGORY = 'SYNC' THEN 'Sync'
				WHEN A.CATEGORY = 'CARRY_OVER' THEN 'Carry Over'
			END AS CATEGORY
		 , A.CONFIRM_ID, '' AS SO_NO
		 , MAX(QTY) - ISNULL(( SELECT SUM(PLAN_QTY)
								FROM   #TEMP_DM_SSP A
								INNER JOIN DM_PLN_MKT_FCST_CONFIRM B WITH(NOLOCK)
								ON   ( A.CONFIRM_ID = B.CONFIRM_ID
								   AND A.ITEM_ID = B.ITEM_ID )), 0) AS PLAN_QTY
		 , NULL AS SHIP_RESULT_QTY
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END AS SEQ
	FROM   #TEMP_DM_SSP A
	WHERE  CATEGORY = 'MKT_FCST'
	GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , A.CATEGORY, A.CONFIRM_ID
	ORDER BY CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END
	       , A.CONFIRM_ID
  
  
	-- 종료 LOG
	SET @V_LOG_TYPE = 'END';
	SET @V_LOG_MESSAGE = '########## END OF PROCEDURE ##########';
	SET @D_EVENT_DATE = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

END

