
/*
 * Program ID   : SSP0015_GET_SHIPMENT_PSI
 * Description  : Shipment Plan Confrim
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/03/05   AYJ			   IInitial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/04/03   MCTHEJ		   IInitial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT - 속도 수정
 * 2019/04/16   AYJ			   IInitial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT - 속도 수정
 * 2019/05/16	AYJ			   [CSR:] MST_MEASURE DEFAULT_FLAG='N', 유져 셋팅 없을 시 화면에 노출되지 않도록 수정
 * 2019/06/11	AYJ			   속도 개선 - MyModel 체크 부분 수정
 * 2019/06/17	AYJ			   조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
 * 2019/08/05	MCTHEJ		   [CSR ID:4045693] SSP 시스템 개선 요청건 - measure 'LOT'의 문자값에 대한 PIVOT 처리 추가
 * 2019/08/09   MCTHEJ		   [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan) - NOTE 추가
 * 2019/08/28	AYJ			   조회 조건 추가(p_delegateeChk)
 * 2019/12/17	KIMYONGHO	   BOH 조정 (이름 변경 및 추가) EX) TOTAL -> oWMS
 * 2020/09/23	KIMYONGHO	   WH_STOCK BOH 수량에서 CHANGE_STATUS 'Delete' 제외 ('D')
 * 2020/10/22	KIMYONGHO	   POUCH_WH_IN_DAY LOOKUP에 해당하는 내용은 L/T  =  LOOKUP의 SEGMENT2 값 적용
 * 2021/11/01	KIMYONGHO	   @p_real_flag 구분 조회
 * 2022/11/14   jilee          DM_PLN_SHIPMENT_REQ -> SITE_TYPE ='SALES' 주석처리
 * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
 * 2024/10/01   KHJ            NERP_SSP
 ex)
 */
CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_PSI]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX) = 'N'
	,@p_program_id			NVARCHAR(MAX)
	,@p_sheet_name			NVARCHAR(MAX)
	,@debug_mode			NVARCHAR(1)	='F'
	,@p_seq					NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)
--WITH RECOMPILE 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_data_cnt			 NVARCHAR(8);
	DECLARE @v_real_flag		 NVARCHAR(1);
	DECLARE @v_plan_version_date NVARCHAR(8);
	DECLARE @v_plan_start_yyyymmdd NVARCHAR(8);
	
	SET @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd;

	SET @v_data_cnt =0;
	DECLARE @plan_cnt    INTEGER = 0;	

	DECLARE @v_cnt_usr_measure	INT =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user   with(nolock)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )


	SET @v_plan_version_date = (
								SELECT TOP 1 CONVERT(char(8), plan_start_yyyymmdd, 112) code 
								FROM [DBO].[SSP_PLAN_VERSION_V] WITH(NOLOCK) 
								WHERE DIVISION_ID = '40'
								GROUP BY plan_start_yyyymmdd
								ORDER BY plan_start_yyyymmdd DESC
							  )


	IF @v_plan_version_date = @v_plan_start_yyyymmdd
		BEGIN 
			SET @v_real_flag = 'Y';
		END
	ELSE
		BEGIN
			SET @v_real_flag = 'N';
		END

	
	--SET @v_real_flag = 'Y';
	PRINT '@v_real_flag = ' + @v_real_flag;
   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0015') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0015;


	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;


	CREATE TABLE #Tmp_RowData(
		 DIVISION_ID  				nvarchar(030)
		,PLAN_START_YYYYMMDD		nvarchar(008)
		,PLAN_TYPE					nvarchar(050)
		,SEQ						INT	
		,ITEM_ID					nvarchar(050)
		,FROM_SITE					nvarchar(030)
		,TO_SITE					nvarchar(030)
		,MEASURE					nvarchar(050)
		,YYYYMMDD					nvarchar(008)
		,BOD_ID						nvarchar(150)
		,QTY						numeric(20,10)
		,ROUTE_ID					INT	
		,INCOTERMS					nvarchar(010)   
		,TRANSPORT_MODE				nvarchar(050)    
		,BIZ_TYPE					nvarchar(030)
		,PROJECT_CODE				nvarchar(050)
		,FCST_TYPE					nvarchar(020)
		,FCST_ETD_DATE				nvarchar(008)
		,FCST_ETA_DATE				nvarchar(008)
		,ETD_DATE					nvarchar(008)
		,ETA_DATE					nvarchar(008)
		,CONFIRM_ID					nvarchar(020)
		,ORIGIN_FROM_DIVISION_ID	nvarchar(030)
		,ORIGIN_TO_DIVISION_ID		nvarchar(030)
		,ATTRIBUTE1                 nvarchar(150)
		,ATTRIBUTE2                 nvarchar(150) 
		,ATTRIBUTE3                 nvarchar(150) 
		,ATTRIBUTE4                 nvarchar(150)
		,ATTRIBUTE5                 nvarchar(150)
		,ATTRIBUTE6                 nvarchar(150)
		,ATTRIBUTE10                nvarchar(150)
	);


	SELECT * INTO #TblDynamicTitlest_SSP0015
	FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	WHERE PROGRAM_ID  = @p_program_id
		AND SHEET_NAME  = @p_sheet_name
		AND USER_ID     = @p_user_id

	--Pivaot Sum을 위한 동적 변수
	DECLARE @mDQry NVARCHAR(MAX)='';
	--Pivaot Max을(문자) 위한 동적 변수
	DECLARE @mDQry1 NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';

	SET     @v_plan_start_yyyymmdd =  CONVERT(char(8), @v_plan_start_yyyymmdd, 112); 

	DECLARE @v_plan_type  NVARCHAR(30) = 'SP'; 
	DECLARE @v_seq        INTEGER = 1;

	IF LEN(@p_from_site) > 6
		SET @p_from_site = '';

	SET @v_division_id	= @p_division_id;
	SET @v_item_id		= @p_item_id;
	set @v_from_site	= @p_from_site;


	/*AGING재고의 cutoff는 생성시점의 가장 최근 정보 ( 보통 한국: 전일cutoff_date기준 당일 08:00~08:30 , 남경 10~11시에  생성됨) 
	  owms 재고는 당일 생성 시점 재고 이므로 Data생성은 당일시작일 기준으로 생성 */
	-- DATA 생성 시작 일자 (당일) 
    DECLARE @v_data_start_yyyymmdd    NVARCHAR(8) = '';
	--SET     @v_data_start_yyyymmdd =  CONVERT(char(8), DATEADD(DD, -1, GETDATE()), 112); 
	SET     @v_data_start_yyyymmdd =  CONVERT(char(8), DATEADD(DD, 0, @v_plan_start_yyyymmdd), 112); 

 	-- DATA 생성 마지막 일자    
	DECLARE @v_data_end_yyyymmdd   NVARCHAR(8) = '';
	SET     @v_data_end_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 84, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ; --12주(84일) 
	
	-- [C20200601-000370] OWMS I/F SSP_DNM_OWMS_STOCK 테이블 CUTOFF 조회용 
	DECLARE @v_data_cutoff_yyyymmdd    NVARCHAR(8) = '';
	SET @v_data_cutoff_yyyymmdd = @v_data_start_yyyymmdd;


	PRINT '-------------1------------: ' +  CONVERT(CHAR(23), getdate(), 21)   
	INSERT INTO #Tmp_RowData
	(
		DIVISION_ID  	     
		,PLAN_START_YYYYMMDD 
		,PLAN_TYPE	         
		,SEQ	             
		,ITEM_ID	         
		,FROM_SITE	         
		,TO_SITE	         
		,MEASURE	         
		,YYYYMMDD	         
		,BOD_ID	           
		,QTY	             
		,ROUTE_ID	         
		,INCOTERMS         
		,TRANSPORT_MODE    
		,BIZ_TYPE	         
		,PROJECT_CODE	     
		,FCST_TYPE	       
		,FCST_ETD_DATE	
		,FCST_ETA_DATE   
		,ETD_DATE	         
		,ETA_DATE
		,CONFIRM_ID	    
		,ORIGIN_FROM_DIVISION_ID
		,ORIGIN_TO_DIVISION_ID
		,ATTRIBUTE1 -- PROD_DATE
		,ATTRIBUTE2 -- REQUESTOR
		,ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
		,ATTRIBUTE4 -- Prod Qty(MASS)	
		,ATTRIBUTE5 -- Prod Qty(ALL)
		,ATTRIBUTE6 -- oWMS재고수량									  	
		,ATTRIBUTE10 -- COMPANY_ID
	)
	SELECT 
		 A.DIVISION_ID  			
		,A.PLAN_START_YYYYMMDD	
		,A.PLAN_TYPE				
		,A.SEQ					
		,A.ITEM_ID				
		,A.FROM_SITE				
		,A.TO_SITE				
		,A.MEASURE				
		,A.YYYYMMDD				
		,A.BOD_ID					
		,A.QTY					
		,A.ROUTE_ID				
		,A.INCOTERMS				
		,A.TRANSPORT_MODE			
		,A.BIZ_TYPE				
		,A.PROJECT_CODE			
		,A.FCST_TYPE				
		,A.FCST_ETD_DATE			
		,A.FCST_ETA_DATE			
		,A.ETD_DATE				
		,A.ETA_DATE				
		,A.CONFIRM_ID				
		,A.ORIGIN_FROM_DIVISION_ID
		,A.ORIGIN_TO_DIVISION_ID	
		,A.ATTRIBUTE1             
		,A.ATTRIBUTE2             
		,A.ATTRIBUTE3             
		,A.ATTRIBUTE4             
		,A.ATTRIBUTE5             
		,A.ATTRIBUTE6             
		,A.ATTRIBUTE10            
	FROM SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK)   
	
	LEFT OUTER JOIN SSP_MST_MODEL_USER tt3 WITH(NOLOCK)                                                                                                      
		ON  tt3.DIVISION_ID		= A.DIVISION_ID			                                                                                                     
		AND tt3.FROM_SITE		= A.FROM_SITE				                                                                                                     
		AND tt3.ITEM_ID			= A.ITEM_ID					                                                                                                     
		AND tt3.VALID_YN		= 'Y'					
		
	WHERE 1=1

	AND A.DIVISION_ID			= @v_division_id
	AND A.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
	AND A.PLAN_TYPE				= @p_plan_type
	AND A.SEQ					= @p_seq

	
	AND (@v_item_id IS NULL OR @v_item_id =''   AND 1=1  OR A.ITEM_ID = @v_item_id)
--	AND (@v_from_site IS NULL OR @v_from_site =''  AND A.FROM_SITE IN ('A010-A', 'G182-A','G182-P') OR A.FROM_SITE = @v_from_site)
	AND (@v_from_site IS NULL OR @v_from_site =''  AND A.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P')) OR A.FROM_SITE = @v_from_site)
	
	AND ( ( @v_real_flag  = 'Y'  AND A.MEASURE NOT IN ('SHIP_REQ', 'SHIP_CONFIRM','WH_STOCK', 'BALANCE')) 
		OR (@v_real_flag  = 'N' AND A.MEASURE IN ('BALANCE','INCO_WIP','INSP_WIP','LOT','MES_FCS_HOLD','MES_FCS_RELEASE','POSTP_PLAN','PROD_DATE','PROD_PLAN','SHIP_CONFIRM','SHIP_REQ','WH_IN','WH_STOCK')))

	AND A.YYYYMMDD				>= @p_from_yyyymmdd
	AND A.YYYYMMDD				<= @p_to_yyyymmdd

	AND EXISTS                                                                                                                                                  
		(                                                                                                                                                           
			SELECT 1 FROM (SELECT Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE, SUM(Z.QTY) AS QTY 
							FROM  SSP_ANL_SHIP_PLAN_40 Z  with(nolock) 
							WHERE Z.DIVISION_ID = @p_division_id 
							AND Z.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  
--							AND (@v_from_site IS NULL OR @v_from_site =''   AND A.FROM_SITE IN ('A010-A', 'G182-A','G182-P')  OR A.FROM_SITE = @v_from_site)
							AND (@v_from_site IS NULL OR @v_from_site =''   AND A.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P'))  OR A.FROM_SITE = @v_from_site)
							GROUP BY Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE) B
			WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SEQ = B.SEQ AND A.ITEM_ID = B.ITEM_ID AND A.FROM_SITE = B.FROM_SITE AND B.QTY <> 0 
		)                      

	AND (( @p_nonChk  = 'Y' AND 1 = 1 OR tt3.USER_ID IN (SELECT CASE WHEN  @p_myModelChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
															UNION 																								
															SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END					
															FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id  GROUP BY USER_ID) 				
	   														OR tt3.PART_LEADER = CASE WHEN @p_partLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
	   														OR tt3.TEAM_LEADER = CASE WHEN @p_teamLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END))	

		;

	
	PRINT '-------------2------------: ' +  CONVERT(CHAR(23), getdate(), 21)   
	------------------------------------------------------------------------------------------------------------- 
	--[S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량 (SSP_ANL_SHIP_REQ)
	----------------------------------------------------------------------------------------------------------- 

	IF @v_real_flag = 'Y'
	BEGIN
		INSERT INTO #Tmp_RowData
		(
			DIVISION_ID  	     
			,PLAN_START_YYYYMMDD 
			,PLAN_TYPE	         
			,SEQ	             
			,ITEM_ID	         
			,FROM_SITE	         
			,TO_SITE	         
			,MEASURE	         
			,YYYYMMDD	         
			,BOD_ID	           
			,QTY	             
			,ROUTE_ID	         
			,INCOTERMS         
			,TRANSPORT_MODE    
			,BIZ_TYPE	         
			,PROJECT_CODE	     
			,FCST_TYPE	       
			,FCST_ETD_DATE	
			,FCST_ETA_DATE   
			,ETD_DATE	         
			,ETA_DATE
			,CONFIRM_ID	    
			,ORIGIN_FROM_DIVISION_ID
			,ORIGIN_TO_DIVISION_ID
			,ATTRIBUTE1 -- PROD_DATE
			,ATTRIBUTE2 -- REQUESTOR
			,ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
			,ATTRIBUTE4 -- Prod Qty(MASS)	
			,ATTRIBUTE5 -- Prod Qty(ALL)
			,ATTRIBUTE6 -- oWMS재고수량									  	
			,ATTRIBUTE10 -- COMPANY_ID
		)
		SELECT R.DIVISION_ID             AS DIVISION_ID  	                   
		,      @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD              
		,      @v_plan_type              AS PLAN_TYPE	                       
		,      @v_seq                    AS SEQ	                             
		,      R.ITEM_ID                 AS ITEM_ID	                         
		,      R.FROM_SITE	             AS FROM_SITE	                       
		,      R.TO_SITE	             AS TO_SITE	                         
		,      'SHIP_REQ'   	         AS MEASURE	                         
		,      R.YYYYMMDD	             AS YYYYMMDD	                       
		,      R.BOD_ID	                 AS BOD_ID	                         
		,      SUM(R.QTY)                AS QTY	                             
		,      ISNULL(S.ROUTE_ID, '-')	             AS ROUTE_ID	                       
		,      ISNULL(S.SSP_INCOTERMS, R.INCOTERMS)  AS INCOTERMS                        
		,      R.TRANSPORT_MODE          AS TRANSPORT_MODE                   
		,      R.BIZ_TYPE	             AS BIZ_TYPE	                       
		,      R.PROJECT_CODE	         AS PROJECT_CODE	                   
		,      R.FCST_TYPE	             AS FCST_TYPE	                       
		,      R.FCST_ETD_DATE	         AS FCST_ETD_DATE	                   
		,      R.FCST_ETA_DATE           AS FCST_ETA_DATE                    
		,      R.ETD_DATE	             AS ETD_DATE	                       
		,      R.ETA_DATE                AS ETA_DATE                         
		,      R.CONFIRM_ID	     
		,      R.DIVISION_ID			 AS ORIGIN_FROM_DIVISION_ID          
		,      R.DIVISION_ID			 AS ORIGIN_TO_DIVISION_ID  	
		,	   NULL						 AS ATTRIBUTE1-- PROD_DATE
		,	   R.CREATED_BY              AS ATTRIBUTE2 --REQUESTOR 
		,	   NULL						 AS ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
		,	   NULL						 AS ATTRIBUTE4 -- Prod Qty(MASS)	
		,	   NULL						 AS ATTRIBUTE5 -- Prod Qty(ALL)
		,	   NULL						 AS ATTRIBUTE6 -- oWMS재고수량									  	
		,	   NULL						 AS ATTRIBUTE10 -- COMPANY_ID
		FROM   (
			    SELECT R.DIVISION_ID
					, R.ITEM_ID
					, R.PLANT_SITE_ID  AS FROM_SITE
					, R.SCM_SITE_ID    AS TO_SITE
					, R.MEASURE
					, R.YYYYMMDD
					, R.BOD_ID
					, R.QTY
					, R.INCOTERMS
					, R.TRANSPORT_MODE
					, CASE WHEN CHARINDEX('-', R.PLANT_SITE_ID) = 0 THEN 'A'
						ELSE SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID)+1, 1) END   AS BIZ_TYPE
					, R.PROJECT_CODE
					, R.FCST_TYPE
					, R.YYYYMMDD AS FCST_ETD_DATE
					, NULL AS FCST_ETA_DATE
					--, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
					, R.YYYYMMDD AS ETD_DATE
					, NULL AS ETA_DATE
					--, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
					, R.ATTRIBUTE10                                                    AS CONFIRM_ID
					, R.CREATED_BY				
				FROM  [DBO].[DM_PLN_SHIPMENT_REQ] R WITH(NOLOCK)

				LEFT OUTER JOIN SSP_MST_MODEL_USER tt3 WITH(NOLOCK)                                                                                                      
				ON  tt3.DIVISION_ID		= R.DIVISION_ID			                                                                                                     
				AND tt3.FROM_SITE		= R.PLANT_SITE_ID				                                                                                                     
				AND tt3.ITEM_ID			= R.ITEM_ID					                                                                                                     
				AND tt3.VALID_YN		= 'Y'					

				WHERE  1=1 
				AND    R.DIVISION_ID = @v_division_id 
				AND   (@v_item_id IS NULL or @v_item_id =''   AND 1=1  OR R.ITEM_ID = @v_item_id)
				AND    R.MEASURE     = 'SHIP_REQ'
--				AND   (@v_from_site IS NULL OR @v_from_site =''   AND R.PLANT_SITE_ID IN ('A010-A', 'G182-A','G182-P')  OR R.PLANT_SITE_ID = @v_from_site)
				AND   (@v_from_site IS NULL OR @v_from_site =''   AND R.PLANT_SITE_ID IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P'))  OR R.PLANT_SITE_ID = @v_from_site)
				--AND    R.SITE_TYPE ='SALES'
				AND    R.YYYYMMDD    >= @v_data_start_yyyymmdd
				AND    R.YYYYMMDD    <= @p_to_yyyymmdd
				AND    R.QTY         > 0

				AND (( @p_nonChk  = 'Y' AND 1 = 1 OR tt3.USER_ID IN (SELECT CASE WHEN  @p_myModelChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
															UNION 																								
															SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END					
															FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id  GROUP BY USER_ID) 				
	   														OR tt3.PART_LEADER = CASE WHEN @p_partLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
	   														OR tt3.TEAM_LEADER = CASE WHEN @p_teamLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END))	
								
			    ) R
				LEFT OUTER JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
				ON    S.INCOTERMS <> S.SSP_INCOTERMS
				AND   S.DIVISION_ID = R.DIVISION_ID
				AND   S.FROM_SITE   = R.FROM_SITE
				AND   S.BOD_ID      = R.BOD_ID
			
		WHERE 1=1 
		
		AND   R.DIVISION_ID = @v_division_id
		AND   R.MEASURE     = 'SHIP_REQ'
--		AND   (@v_from_site IS NULL OR @v_from_site =''   AND  R.FROM_SITE IN ('A010-A', 'G182-A','G182-P') OR R.FROM_SITE = @v_from_site)
		AND   (@v_from_site IS NULL OR @v_from_site =''   AND  R.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P')) OR R.FROM_SITE = @v_from_site)
		AND   R.YYYYMMDD    >= @v_data_start_yyyymmdd 	  
		AND   R.YYYYMMDD    <= @p_to_yyyymmdd 		
		
		GROUP BY R.DIVISION_ID  
		,      R.ITEM_ID        
		,      R.FROM_SITE	    
		,      R.TO_SITE	    
		,      R.YYYYMMDD	    
		,      R.BOD_ID	        
		,      ISNULL(S.ROUTE_ID, '-')
		,      ISNULL(S.SSP_INCOTERMS, R.INCOTERMS)
		,      R.TRANSPORT_MODE 
		,      R.BIZ_TYPE	    
		,      R.PROJECT_CODE
		,      R.FCST_TYPE	  
		,      R.FCST_ETD_DATE
		,      R.FCST_ETA_DATE
		,      R.ETD_DATE	
		,      R.ETA_DATE   
		,      R.CONFIRM_ID	
		,      R.CREATED_BY
		;
	
	PRINT '-------------3------------: ' +  CONVERT(CHAR(23), getdate(), 21)   
	------------------------------------------------------------------------------------------------------------- 
	--[S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량  
	------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #Tmp_RowData
		(
			 DIVISION_ID  	     
			,PLAN_START_YYYYMMDD 
			,PLAN_TYPE	         
			,SEQ	             
			,ITEM_ID	         
			,FROM_SITE	         
			,TO_SITE	         
			,MEASURE	         
			,YYYYMMDD	         
			,BOD_ID	           
			,QTY	             
			,ROUTE_ID	         
			,INCOTERMS         
			,TRANSPORT_MODE    
			,BIZ_TYPE	         
			,PROJECT_CODE	     
			,FCST_TYPE	       
			,FCST_ETD_DATE	
			,FCST_ETA_DATE   
			,ETD_DATE	         
			,ETA_DATE
			,CONFIRM_ID	    
			,ORIGIN_FROM_DIVISION_ID
			,ORIGIN_TO_DIVISION_ID		
			,ATTRIBUTE1 -- PROD_DATE
			,ATTRIBUTE2 -- REQUESTOR
			,ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
			,ATTRIBUTE4 -- Prod Qty(MASS)	
			,ATTRIBUTE5 -- Prod Qty(ALL)
			,ATTRIBUTE6 -- oWMS재고수량									  	
			,ATTRIBUTE10 -- COMPANY_ID
		)
		SELECT A.DIVISION_ID  	     
				,A.PLAN_START_YYYYMMDD 
				,A.PLAN_TYPE	         
				,A.SEQ	             
				,A.ITEM_ID	         
				,A.FROM_SITE	         
				,A.TO_SITE	         
				,A.MEASURE	         
				,A.YYYYMMDD	         
				,A.BOD_ID	           
				,SUM(A.QTY)	             AS QTY
				,A.ROUTE_ID
				,A.INCOTERMS         
				,A.TRANSPORT_MODE    
				,A.BIZ_TYPE	         
				,A.PROJECT_CODE	     
				,A.FCST_TYPE	       
				,A.FCST_ETD_DATE
				,MAX(A.FCST_ETA_DATE)   AS    FCST_ETA_DATE
				,A.ETD_DATE
				,MAX(A.ETA_DATE)   AS ETA_DATE
				,MAX(A.CONFIRM_ID)	    AS CONFIRM_ID
				,A.ORIGIN_FROM_DIVISION_ID
				,A.ORIGIN_TO_DIVISION_ID	
				,NULL						 AS ATTRIBUTE1-- PROD_DATE
				,MAX(A.ATTRIBUTE2)           AS ATTRIBUTE2 --REQUESTOR 
				,NULL						 AS ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
				,NULL						 AS ATTRIBUTE4 -- Prod Qty(MASS)	
				,NULL						 AS ATTRIBUTE5 -- Prod Qty(ALL)
				,NULL						 AS ATTRIBUTE6 -- oWMS재고수량									  	
				,NULL						 AS ATTRIBUTE10 -- COMPANY_ID
		FROM   (
				SELECT C.DIVISION_ID										AS DIVISION_ID  	                   
				,      @v_plan_start_yyyymmdd								AS PLAN_START_YYYYMMDD              
				,      @v_plan_type											AS PLAN_TYPE	                       
				,      @v_seq												AS SEQ	                             
				,      C.ITEM_ID											AS ITEM_ID	                         
				,      C.FROM_SITE											AS FROM_SITE	                       
				,      C.TO_SITE											AS TO_SITE	                         
				,      'SHIP_CONFIRM'										AS MEASURE	                         
				,      C.YYYYMMDD											AS YYYYMMDD	                       
				,      C.BOD_ID												AS BOD_ID	                         
				,      C.QTY												AS QTY	                             
				,      C.ROUTE_ID											AS ROUTE_ID	                       
				,      ISNULL(S.SSP_INCOTERMS, C.INCOTERMS)					AS INCOTERMS                        
				,      C.TRANSPORT_MODE										AS TRANSPORT_MODE                   
				,      C.BIZ_TYPE											AS BIZ_TYPE	                       
				,      C.PROJECT_CODE										AS PROJECT_CODE	                   
				,      C.FCST_TYPE											AS FCST_TYPE	                       
				,      C.FCST_ETD_DATE										AS FCST_ETD_DATE	                   
				,      C.FCST_ETA_DATE										AS FCST_ETA_DATE                    
				,      C.ETD_DATE											AS ETD_DATE	                       
				,      C.ETA_DATE											AS ETA_DATE                         
				,      C.CONFIRM_ID											AS CONFIRM_ID	                     
				,      C.DIVISION_ID										AS ORIGIN_FROM_DIVISION_ID          
				,      C.DIVISION_ID										AS ORIGIN_TO_DIVISION_ID 
				,      C.REQUESTOR											AS ATTRIBUTE2  -- REQUESTOR	
				FROM   [DBO].[SSP_ANL_SHIP_CONFIRM]  C WITH(NOLOCK) 
				
				LEFT OUTER JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
					ON    S.INCOTERMS <> S.SSP_INCOTERMS
					AND   S.DIVISION_ID = C.DIVISION_ID
					AND   S.FROM_SITE   = C.FROM_SITE
					AND   S.BOD_ID      = C.BOD_ID

				LEFT OUTER JOIN SSP_MST_MODEL_USER tt3 WITH(NOLOCK)                                                                                                      
					ON  tt3.DIVISION_ID		= C.DIVISION_ID			                                                                                                     
					AND tt3.FROM_SITE		= C.FROM_SITE				                                                                                                     
					AND tt3.ITEM_ID			= C.ITEM_ID					                                                                                                     
					AND tt3.VALID_YN		= 'Y'

				WHERE  1=1
		
				AND	   C.DIVISION_ID = @v_division_id
--				AND   (@v_from_site IS NULL OR @v_from_site ='' AND  C.FROM_SITE IN ('A010-A', 'G182-A','G182-P')  OR C.FROM_SITE = @v_from_site)
				AND   (@v_from_site IS NULL OR @v_from_site ='' AND  C.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P'))  OR C.FROM_SITE = @v_from_site)
				AND   (@v_item_id IS NULL or @v_item_id =''   AND 1=1  OR C.ITEM_ID = @v_item_id)
				AND    C.CHANGE_TYPE = 'C'
				AND    C.BIZ_TYPE   <> 'E' -- 전극제외 
				AND    C.QTY > 0 
				AND    C.YYYYMMDD    >= @v_data_start_yyyymmdd 	  
				AND    C.YYYYMMDD    <=  @p_to_yyyymmdd

				AND (( @p_nonChk  = 'Y' AND 1 = 1 OR tt3.USER_ID IN (SELECT CASE WHEN  @p_myModelChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
															UNION 																								
															SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END					
															FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id  GROUP BY USER_ID) 				
	   														OR tt3.PART_LEADER = CASE WHEN @p_partLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
	   														OR tt3.TEAM_LEADER = CASE WHEN @p_teamLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END))	
				
				

				UNION ALL

				SELECT R.DIVISION_ID
				,      @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD              
				,      @v_plan_type              AS PLAN_TYPE	                       
				,      @v_seq                    AS SEQ	                             
				,		R.ITEM_ID				 AS ITEM_ID
				,		R.PLANT_SITE_ID			 AS FROM_SITE
				,		R.SCM_SITE_ID			 AS TO_SITE
				,      'SHIP_CONFIRM'	         AS MEASURE	                         
				,		R.YYYYMMDD
				,		R.BOD_ID
				,		R.QTY
				,		S.ROUTE_ID AS ROUTE_ID
				,		R.INCOTERMS
				,		R.TRANSPORT_MODE
				,		CASE WHEN CHARINDEX('-', R.PLANT_SITE_ID) = 0 THEN 'A' ELSE SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID)+1, 1) END   AS BIZ_TYPE
				,		R.PROJECT_CODE
				,		R.FCST_TYPE
				,		R.YYYYMMDD														 AS FCST_ETD_DATE
				,		NULL AS FCST_ETA_DATE
				--,		[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
				,		R.YYYYMMDD														 AS ETD_DATE
				,		NULL AS ETA_DATE
				--,		[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
				,		R.ATTRIBUTE10                                                    AS CONFIRM_ID
				,       R.DIVISION_ID													 AS ORIGIN_FROM_DIVISION_ID          
				,       R.DIVISION_ID													 AS ORIGIN_TO_DIVISION_ID 
				,	   NULL   AS ATTRIBUTE2
				FROM   [DBO].[DM_PLN_SHIPMENT_REQ] R WITH(NOLOCK) 

				JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
				ON  S.DIVISION_ID = R.DIVISION_ID
					AND   S.FROM_SITE   = R.PLANT_SITE_ID
					AND   S.BOD_ID      = R.BOD_ID
				
				LEFT OUTER JOIN SSP_MST_MODEL_USER tt3 WITH(NOLOCK)                                                                                                      
				ON  tt3.DIVISION_ID		= R.DIVISION_ID			                                                                                                     
					AND tt3.FROM_SITE		= R.PLANT_SITE_ID				                                                                                                     
					AND tt3.ITEM_ID			= R.ITEM_ID					                                                                                                     
					AND tt3.VALID_YN		= 'Y'

				WHERE  1=1 

				AND    R.DIVISION_ID   = @v_division_id							
				AND   (@v_item_id IS NULL or @v_item_id =''   AND 1=1  OR R.ITEM_ID = @v_item_id)				
				AND    R.MEASURE       = 'SHIP_REQ'
--				AND   (@v_from_site IS NULL OR @v_from_site =''   AND   R.PLANT_SITE_ID IN ('A010-A', 'G182-A','G182-P')  OR R.PLANT_SITE_ID = @v_from_site)
				AND   (@v_from_site IS NULL OR @v_from_site =''   AND   R.PLANT_SITE_ID IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI'  ,'A010A_G182A_G182P')) OR R.PLANT_SITE_ID = @v_from_site)
				--AND    R.SITE_TYPE ='SALES'
				AND    R.YYYYMMDD      > (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0 THEN @v_plan_start_yyyymmdd
										  ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID)-1, @v_plan_start_yyyymmdd) ,112) END)
				AND    R.YYYYMMDD      <= @p_to_yyyymmdd
				AND    R.QTY           > 0
				AND    R.ATTRIBUTE10 IS NULL

				AND (( @p_nonChk  = 'Y' AND 1 = 1 OR tt3.USER_ID IN (SELECT CASE WHEN  @p_myModelChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
															UNION 																								
															SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END					
															FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id  GROUP BY USER_ID) 				
	   														OR tt3.PART_LEADER = CASE WHEN @p_partLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END		
	   														OR tt3.TEAM_LEADER = CASE WHEN @p_teamLeaderChk  = 'Y' THEN  @p_user_id  ELSE 'X' END))	
				

				) A
		WHERE  1 = 1
		GROUP BY A.DIVISION_ID  	     
				,A.PLAN_START_YYYYMMDD 
				,A.PLAN_TYPE	         
				,A.SEQ	             
				,A.ITEM_ID	         
				,A.FROM_SITE	         
				,A.TO_SITE	         
				,A.MEASURE	         
				,A.YYYYMMDD	         
				,A.BOD_ID	           
				,A.ROUTE_ID
				,A.INCOTERMS         
				,A.TRANSPORT_MODE    
				,A.BIZ_TYPE	         
				,A.PROJECT_CODE	     
				,A.FCST_TYPE	  
				,A.FCST_ETD_DATE
				,A.ETD_DATE     
				,A.ORIGIN_FROM_DIVISION_ID
				,A.ORIGIN_TO_DIVISION_ID
		;
	------------------------------------------------------------------------------------------------------------- 
	--[I]WH_STOC(Warehouse Stock) 
	--      당일 WH_STOC = OWMS 가용수량 
	--      익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량(MES/FCS) + 전일 MES_FCS_RELEASE수량(MES/FCS 사용자설정)
	------------------------------------------------------------------------------------------------------------- 
	WITH BOH AS (
			        SELECT A.DIVISION_ID
						, A.PLAN_START_YYYYMMDD
						, A.PLAN_TYPE
						, A.SEQ
						, A.FROM_SITE
						, A.ITEM_ID
						, SUM(A.QTY)   AS QTY
					FROM   (
						SELECT A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.FROM_SITE
								, A.ITEM_ID
								, (CASE WHEN ISNULL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
						FROM   [DBO].[SSP_ANL_MES_FCS_STOCK_40_C]  A WITH(NOLOCK)
								LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH(NOLOCK)
								ON   B.DIVISION_ID = A.DIVISION_ID
								AND  B.ITEM_ID = A.ITEM_ID
								LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
								ON  C.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
								AND C.VALID_YN    = 'Y' 
								AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
						WHERE  1 = 1
						AND    A.DIVISION_ID         = @v_division_id
						AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    A.PLAN_TYPE           = @v_plan_type
						AND    A.SEQ                 = @v_seq
						AND    A.AVAILABLE_YN <> 'N'
						AND    ISNULL(A.CHANGE_STATUS, '') <> 'D'
	

						GROUP BY A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.FROM_SITE
								, A.ITEM_ID
								, C.SEGMENT3

						UNION ALL

						SELECT A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.FROM_SITE
								, A.ITEM_ID
								, SUM(A.AVAILABLE_QTY) AS QTY
						FROM   [DBO].[SSP_ANL_OWMS_STOCK_C]  A WITH(NOLOCK)
						WHERE  1 = 1
						AND    A.DIVISION_ID         = @v_division_id
						AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    A.PLAN_TYPE           = @v_plan_type
						AND    A.SEQ                 = @v_seq
						
						GROUP BY A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.FROM_SITE
								, A.ITEM_ID

						UNION ALL

						--STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고
						SELECT T.DIVISION_ID  	        AS DIVISION_ID   
						,	   T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
						,      T.PLAN_TYPE	            AS PLAN_TYPE
						,      T.SEQ 	                AS SEQ
						,      T.SCM_SITE_ID            AS FROM_SITE  
						,      T.ITEM_ID	            AS ITEM_ID   
						,      ROUND(SUM(T.QTY),0) AS  QTY	   
						FROM   [DBO].[SSP_ANL_TCO_STOCK_C] T WITH(NOLOCK)  
						WHERE  1 = 1
						AND    T.DIVISION_ID         = @v_division_id
						AND    T.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    T.PLAN_TYPE           = @v_plan_type
						AND    T.SEQ                 = @v_seq

						GROUP BY 
								T.DIVISION_ID 
						,     T.PLAN_START_YYYYMMDD
						,     T.PLAN_TYPE
						,     T.SEQ
						,     T.ITEM_ID
						,     T.SCM_SITE_ID

						) A
						
					WHERE  1 = 1
					GROUP BY A.DIVISION_ID
						, A.PLAN_START_YYYYMMDD
						, A.PLAN_TYPE
						, A.SEQ
						, A.FROM_SITE
						, A.ITEM_ID
				),  
		Z AS (
			SELECT DISTINCT  
					P.DIVISION_ID  	     
			,      P.PLAN_START_YYYYMMDD 
			,      P.PLAN_TYPE	         
			,      P.SEQ	             
			,      P.ITEM_ID	         
			,      P.FROM_SITE  
			,      P.YYYYMMDD     
			FROM  #Tmp_RowData P WITH(NOLOCK ) 

			WHERE 1=1 
			AND P.DIVISION_ID         = @v_division_id         -- '81'
			AND P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- '20180429' 
			AND P.PLAN_TYPE           = @v_plan_type           -- 'SP'
			AND P.SEQ                 = @v_seq                 -- '3'
			AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
			AND P.YYYYMMDD            >= @v_data_start_yyyymmdd
			AND P.YYYYMMDD            <= @p_to_yyyymmdd

			GROUP BY P.DIVISION_ID  	     
			,        P.PLAN_START_YYYYMMDD 
			,        P.PLAN_TYPE	         
			,        P.SEQ	             
			,        P.ITEM_ID	         
			,        P.FROM_SITE  
			,        P.YYYYMMDD 
			)  

	INSERT INTO #Tmp_RowData
	(
		DIVISION_ID  	     
		,PLAN_START_YYYYMMDD 
		,PLAN_TYPE	         
		,SEQ	             
		,ITEM_ID	         
		,FROM_SITE	         
		,TO_SITE	         
		,MEASURE	         
		,YYYYMMDD	         
		,BOD_ID	           
		,QTY	             
		,INCOTERMS         
		,TRANSPORT_MODE    
		,PROJECT_CODE	     
		,FCST_TYPE
		,CONFIRM_ID	      
		,ORIGIN_FROM_DIVISION_ID
		,ORIGIN_TO_DIVISION_ID -- ORIGIN_TO_DIVISION_ID					 
		)
	SELECT   
			Z.DIVISION_ID            
			,Z.PLAN_START_YYYYMMDD            
			,Z.PLAN_TYPE            
			,Z.SEQ            
			,Z.ITEM_ID            
			,Z.FROM_SITE    
			,'-'   AS TO_SITE         
			,'WH_STOCK' AS MEASURE
			,Z.YYYYMMDD  
			,'-'   AS BOD_ID
			,-- 전일 WH_IN , 전일 SHIP_CONFIRM
				(
				CASE WHEN CONVERT(NVARCHAR(8), @v_plan_start_yyyymmdd, 112) < Z.YYYYMMDD THEN
					CASE WHEN ( ISNULL(B.SEGMENT3, '-') = 'P' ) THEN
						    (
							SELECT  
								ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
															WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0) 
															WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0) 
															WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
															WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
												ELSE 0.0  
									END),0)   
							FROM #Tmp_RowData X WITH(NOLOCK)     
							WHERE 1=1  
							AND X.DIVISION_ID          = Z.DIVISION_ID  
							AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
							AND X.PLAN_TYPE            = Z.PLAN_TYPE  
							AND X.SEQ                  = Z.SEQ  
							AND X.ITEM_ID              = Z.ITEM_ID  
							AND X.FROM_SITE            = Z.FROM_SITE  
							AND X.MEASURE              IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
							AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
							AND X.YYYYMMDD             < Z.YYYYMMDD
							
							)
					ELSE
						    (
							SELECT  
								ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
															WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0) 
															WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0) 
															WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
															WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
												ELSE 0.0  
									END),0)   
							FROM #Tmp_RowData X WITH(NOLOCK)     
							WHERE 1=1  
							AND X.DIVISION_ID          = Z.DIVISION_ID  
							AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
							AND X.PLAN_TYPE            = Z.PLAN_TYPE  
							AND X.SEQ                  = Z.SEQ  
							AND X.ITEM_ID              = Z.ITEM_ID  
							AND X.FROM_SITE            = Z.FROM_SITE  
							AND X.MEASURE              IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
							AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
							AND X.YYYYMMDD             < Z.YYYYMMDD

							)
					END
				ELSE  0
				END
				)

				-- 당일 OWMS 재고 
					+ ISNULL(BOH.QTY,0)

				-- 2020.09.09 KBK : 'DCP', 'MDP', 'MIP', 'MTP' 처리
					- (
						CASE WHEN CONVERT(NVARCHAR(8), @v_plan_start_yyyymmdd, 112) <= Z.YYYYMMDD THEN
							CASE WHEN ISNULL(B.SEGMENT3, '-') = 'P' THEN ISNULL(B.WH_IN_QTY2, 0)
							ELSE 0 END
						ELSE 0 END
						)

				-- HOLD 재고 
					-   ISNULL((SELECT SUM(H.HOLD_QTY )  -- HOLD재고 제외
								FROM  [DBO].[SSP_ANL_HOLD_STOCK] H WITH(NOLOCK) -- #tmp_SSP_ANL_HOLD_STOCK H WITH(NOLOCK) 
								,     SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
								WHERE H.DIVISION_ID         = @v_division_id 
								AND   H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND   H.PLAN_TYPE           = @v_plan_type
								AND   H.SEQ                 = @v_seq
								AND   C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
								AND   C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
								AND   C.BASIS_YYYYMMDD     >=  @v_data_start_yyyymmdd
								AND   C.BASIS_YYYYMMDD     <  @v_data_end_yyyymmdd
								AND   H.DIVISION_ID         = Z.DIVISION_ID 
								AND   H.FROM_SITE           = Z.FROM_SITE
								AND   H.ITEM_ID             = Z.ITEM_ID 
								AND   C.BASIS_YYYYMMDD      = Z.YYYYMMDD
								
   								GROUP BY H.DIVISION_ID 
							,        H.FROM_SITE
							,        H.ITEM_ID 
							,        C.BASIS_YYYYMMDD ) ,0)					  AS QTY
	--------------------------------------------------------------------------------------------------------------------------------------
			,'-'   AS INCOTERMS         
			,'-'   AS TRANSPORT_MODE    
			,'-'   AS PROJECT_CODE	
			,'-'   AS FCST_TYPE	
			,'-'   AS CONFIRM_ID	
			,Z.DIVISION_ID
			,Z.DIVISION_ID  --ORIGIN_TO_DIVISION_ID	
	FROM Z WITH(NOLOCK)   
	LEFT OUTER JOIN BOH WITH(NOLOCK) 
					ON Z.DIVISION_ID      = BOH.DIVISION_ID  
				AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD  
				AND Z.PLAN_TYPE           = BOH.PLAN_TYPE  
				AND Z.SEQ                 = BOH.SEQ  
				AND Z.ITEM_ID             = BOH.ITEM_ID  
				AND Z.FROM_SITE           = BOH.FROM_SITE  
		-- 2020.09.09 KBK 
		LEFT OUTER JOIN (
						SELECT A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.ITEM_ID
								, A.FROM_SITE
								--, A.TO_SITE
								, SUM(A.QTY)   AS WH_IN_QTY2
								, C.SEGMENT3
						FROM   #Tmp_RowData  A WITH(NOLOCK)
								LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH(NOLOCK)
								ON   B.DIVISION_ID = A.DIVISION_ID
								AND  B.ITEM_ID = A.ITEM_ID
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
								ON  C.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
								AND C.VALID_YN    = 'Y' 
								AND C.SEGMENT3    = 'P'
								AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
								ON  D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY' 
								AND D.SEGMENT1    = SUBSTRING(A.ITEM_ID, 1, 3)
								AND D.VALID_YN    = 'Y' 
						WHERE  1 = 1
						AND    A.DIVISION_ID         = @v_division_id
						AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    A.PLAN_TYPE           = @v_plan_type
						AND    A.SEQ                 = @v_seq
						AND    A.MEASURE = 'WH_IN'
						AND    A.YYYYMMDD > @v_data_start_yyyymmdd
						AND    A.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, CONVERT(INT, D.SEGMENT2), CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112)
						AND ( ( @v_real_flag  = 'Y'  AND 1=1) )
						GROUP BY A.DIVISION_ID
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.ITEM_ID
								, A.FROM_SITE
								--, A.TO_SITE
								, C.SEGMENT3
						)  B
		ON   B.DIVISION_ID		   = Z.DIVISION_ID
		AND  B.PLAN_START_YYYYMMDD = Z.PLAN_START_YYYYMMDD
		AND  B.PLAN_TYPE		   = Z.PLAN_TYPE
		AND  B.SEQ				   = Z.SEQ
		AND  B.ITEM_ID			   = Z.ITEM_ID
		AND  B.FROM_SITE		   = Z.FROM_SITE

	WHERE 1=1
	
	
	PRINT '-------------5------------: ' +  CONVERT(CHAR(23), getdate(), 21)   
	------------------------------------------------------------------------------------------------------------- 
	--2-15. [I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm - 당일 Post Process Plan 
	------------------------------------------------------------------------------------------------------------- 
	INSERT INTO #Tmp_RowData
	(
		DIVISION_ID  	     
		,PLAN_START_YYYYMMDD 
		,PLAN_TYPE	         
		,SEQ	             
		,ITEM_ID	         
		,FROM_SITE	         
		,TO_SITE	         
		,MEASURE	         
		,YYYYMMDD	         
		,BOD_ID	           
		,QTY	             
		,INCOTERMS         
		,TRANSPORT_MODE    
		,PROJECT_CODE	     
		,FCST_TYPE	
		,CONFIRM_ID      
		,ORIGIN_FROM_DIVISION_ID
		,ORIGIN_TO_DIVISION_ID				 
		)
	SELECT B.DIVISION_ID 
	,      B.PLAN_START_YYYYMMDD 
	,      B.PLAN_TYPE	         
	,      B.SEQ	             
	,      B.ITEM_ID	         
	,      B.FROM_SITE	         
	,      B.TO_SITE	         
	,      'BALANCE'  AS MEASURE	         
	,      B.YYYYMMDD	         
	,      B.BOD_ID	           
	,      B.QTY - (SELECT SUM(C.QTY) 
					FROM #Tmp_RowData C WITH(NOLOCK) 
					WHERE 1=1 
					AND B.DIVISION_ID          = C.DIVISION_ID        
					AND B.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
					AND B.PLAN_TYPE            = C.PLAN_TYPE          
					AND B.SEQ                  = C.SEQ                
					AND B.ITEM_ID              = C.ITEM_ID             
					AND B.FROM_SITE            = C.FROM_SITE           
					AND B.YYYYMMDD             = C.YYYYMMDD 
					AND C.MEASURE              IN ('SHIP_CONFIRM' ,'POSTP_PLAN')
					GROUP BY C.DIVISION_ID        							
							,C.PLAN_START_YYYYMMDD
							,C.PLAN_TYPE          
							,C.SEQ                
							,C.ITEM_ID            
							,C.FROM_SITE          
							,C.YYYYMMDD ) AS QTY 		             
	,      B.INCOTERMS         
	,      B.TRANSPORT_MODE    
	,      B.PROJECT_CODE	     
	,      B.FCST_TYPE	
	,      '-' AS CONFIRM_ID 
	,      B.DIVISION_ID -- ORIGIN_FROM_DIVISION_ID
	,      B.DIVISION_ID -- ORIGIN_TO_DIVISION_ID			 
	FROM #Tmp_RowData B WITH(NOLOCK) 
			
	WHERE 1=1 
	AND B.DIVISION_ID         = @v_division_id          -- '81'
	AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  -- '20180429'  
	AND B.PLAN_TYPE           = @v_plan_type            -- 'SP' 
	AND B.SEQ                 = @v_seq                  -- '3'
	AND B.MEASURE = 'WH_STOCK'       

	;

 
	END

		INSERT INTO #Tmp_RowData
	(
		DIVISION_ID  	     
		,PLAN_START_YYYYMMDD 
		,PLAN_TYPE	         
		,SEQ	             
		,ITEM_ID	         
		,FROM_SITE	         
		,TO_SITE	         
		,MEASURE	         
		,YYYYMMDD	         
		,BOD_ID	           
		,QTY	             
		,INCOTERMS         
		,TRANSPORT_MODE    
		,PROJECT_CODE	
		,FCST_TYPE
		,CONFIRM_ID 						     
		,ORIGIN_FROM_DIVISION_ID	
		,ORIGIN_TO_DIVISION_ID	-- ORIGIN_TO_DIVISION_ID      
		)        
	SELECT   
		SUB.DIVISION_ID
		,SUB.PLAN_START_YYYYMMDD
		,SUB.PLAN_TYPE
		,SUB.SEQ
		,SUB.ITEM_ID
		,SUB.FROM_SITE
		,SUB.TO_SITE
		,SUB.MEASURE
		,SUB.YYYYMMDD
		,SUB.BOD_ID
		,0              AS QTY                      
		,SUB.INCOTERMS
		,SUB.TRANSPORT_MODE
		,SUB.PROJECT_CODE
		,SUB.FCST_TYPE
		,SUB.CONFIRM_ID --'-' AS CONFIRM_ID 
		,SUB.DIVISION_ID -- ORIGIN_FROM_DIVISION_ID
		,SUB.DIVISION_ID --ORIGIN_TO_DIVISION_ID	
	FROM     
		(    
			SELECT   DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,ITEM_ID
					,FROM_SITE
					,'-'         AS TO_SITE
					--,@X_MEASURE  AS MEASURE
					,MEASURE  AS MEASURE
					,YYYYMMDD
					,'-' AS BOD_ID
					,'-' AS INCOTERMS
					,'-' AS TRANSPORT_MODE
					,'-' AS PROJECT_CODE
					,'-' AS FCST_TYPE
					,'-' AS CONFIRM_ID
				FROM    
					(  -- 56 DAYS (7*8)
						SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
						FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
						WHERE 1=1  
						AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
						AND C.BASIS_YYYYMMDD <=  @p_to_yyyymmdd
						--AND ( ( @v_real_flag  = 'Y'  AND 1=1) )
					) A,    
					(    
						SELECT  DISTINCT   
								DIVISION_ID
								,PLAN_START_YYYYMMDD
								,PLAN_TYPE
								,SEQ
								,ITEM_ID
								,FROM_SITE
						FROM  #Tmp_RowData X WITH(NOLOCK)   								 
						WHERE 1=1

								  
					) B    ,
					(
						SELECT COLUMN_NAME AS MEASURE
						FROM SCM_MST_SHEET_MEASURE
						WHERE 1=1
						AND PROGRAM_ID = @p_program_id
						AND SHEET_NAME = @p_sheet_name
						AND VALID_YN = 'Y'


					) C
		) SUB    
		WHERE 1=1    
			AND NOT EXISTS (    
							SELECT 'X'    
							FROM #Tmp_RowData Z WITH(NOLOCK)     
							WHERE 1=1    
								AND Z.DIVISION_ID              = SUB.DIVISION_ID            
								AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD        
								AND Z.PLAN_TYPE                = SUB.PLAN_TYPE              
								AND Z.SEQ                      = SUB.SEQ          
								AND Z.ITEM_ID                  = SUB.ITEM_ID   										            
								AND Z.FROM_SITE                = SUB.FROM_SITE       
								--AND Z.MEASURE                  = @X_MEASURE    
								AND Z.MEASURE                  = SUB.MEASURE      		
								AND Z.YYYYMMDD                 = SUB.YYYYMMDD

							)
		;   


	SET @mDQry = '	SELECT																																							' + char(10) ;
	SET @mDQry = @mDQry + '		T3.DIVISION_ID,			T3.PLAN_START_YYYYMMDD,					T3.PLAN_TYPE,								T3.FROM_SITE,                                   ' + char(10) ;
	SET @mDQry = @mDQry + '		T3.ITEM_ID,				T0.COLUMN_NAME AS MEASURE,				T0.COLUMN_LABEL_NAME AS MEASURE_NAME,		T0.ATTRIBUTE1 AS PSI_NAME,                      ' + char(10) ;
	SET @mDQry = @mDQry + '		T3.SHIP_FROZEN,							T3.SEQ,	                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '		CONVERT(INT, CASE WHEN T0.COLUMN_NAME = ''PROD_DATE'' THEN ISNULL(T3.PROD_DATE, NULL) ELSE T3.QTY END) AS QTY,                                               ' + char(10) ;
    
	SET @mDQry = @mDQry + '		'''' AS nick_name,            ' + char(10) ;
	SET @mDQry = @mDQry + '		''' + @p_from_yyyymmdd + ''' AS FROM_YYYYMMDD,					''' + @p_to_yyyymmdd + ''' AS TO_YYYYMMDD,				''D_'' + T3.YYYYMMDD AS YYYYMMDD,    ' + char(10) ;
	SET @mDQry = @mDQry + '		ISNULL(T1.SORT_ORDER_NO, T0.SORT_ORDER_NO) AS user_sort_order_no                                                                                            ' + char(10) ;
	
	SET @mDQry = @mDQry + '	FROM SCM_MST_SHEET_MEASURE T0 WITH(NOLOCK)                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '	LEFT OUTER JOIN SCM_MST_TITLESET_USER T1 WITH(NOLOCK)                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '		ON T1.PROGRAM_ID = T0.PROGRAM_ID                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '		AND T1.SHEET_NAME = T0.SHEET_NAME                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '		AND T1.COLUMN_NAME = T0.COLUMN_NAME                                                                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + '		AND T1.USER_ID = ''' + @p_user_id + '''                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	,(                                                                                                                                                              ' + char(10) ;
	SET @mDQry = @mDQry + '		SELECT                                                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '			tt0.DIVISION_ID,			tt0.PLAN_START_YYYYMMDD,				tt0.PLAN_TYPE,			tt0.FROM_SITE,                                              ' + char(10) ;
	SET @mDQry = @mDQry + '			tt0.ITEM_ID,				tt0.YYYYMMDD,							SUM(tt0.QTY) as QTY,    tt0.MEASURE,                                                ' + char(10) ;
	SET @mDQry = @mDQry + '			MAX(tt0.SEQ) as SEQ,		MAX(tt0.ATTRIBUTE1) as PROD_DATE,		tt2.SHIP_FROZEN,		tt0.ORIGIN_FROM_DIVISION_ID                                 ' + char(10) ;
	SET @mDQry = @mDQry + '		FROM #Tmp_RowData tt0 with(nolock)                                                                                                                  ' + char(10) ;
	
	SET @mDQry = @mDQry + '		LEFT OUTER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '			ON (CASE WHEN tt0.DIVISION_ID = ''EE'' THEN tt0.ORIGIN_FROM_DIVISION_ID ELSE tt0.DIVISION_ID END) = tt2.DIVISION_ID                                     ' + char(10) ;
	SET @mDQry = @mDQry + '			AND tt0.FROM_SITE = tt2.SCM_SITE_ID                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '			AND tt2.VALID_YN = ''Y''                                                                                                                                ' + char(10) ;
	
	SET @mDQry = @mDQry + '		WHERE 1 = 1                                                                                                                                                 ' + char(10) ;
	SET @mDQry = @mDQry + '		AND tt0.YYYYMMDD >= ''' + @p_from_yyyymmdd + '''                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '		AND tt0.YYYYMMDD <= ''' + @p_to_yyyymmdd + '''                                                                                                              ' + char(10) ;
	
	SET @mDQry = @mDQry + '		AND EXISTS                                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + '		(                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '			SELECT 1                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '			FROM                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + '			(                                                                                                                                                       ' + char(10) ;
	SET @mDQry = @mDQry + '				SELECT DIVISION_ID,	MAX(PLAN_SEQ) AS PLAN_SEQ FROM SSP_PLAN_VERSION_V                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '				WHERE PLAN_TYPE    = ''' + @p_plan_type + '''																															' + char(10);
	
	SET @mDQry = @mDQry + '				AND CONFIRM_FLAG = ''Y'' AND PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''																' + char(10) ;
	SET @mDQry = @mDQry + '				GROUP BY DIVISION_ID                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '			) a                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '			WHERE a.DIVISION_ID = TT0.DIVISION_ID AND a.PLAN_SEQ = TT0.SEQ                                                                                          ' + char(10) ;
	SET @mDQry = @mDQry + '		)                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '		GROUP BY tt0.DIVISION_ID, tt0.PLAN_START_YYYYMMDD, tt0.PLAN_TYPE, tt0.FROM_SITE, tt0.ITEM_ID, tt0.YYYYMMDD, tt2.SHIP_FROZEN, tt0.ORIGIN_FROM_DIVISION_ID, tt0.MEASURE ' + char(10) ;
	SET @mDQry = @mDQry + '	) T3                                                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	WHERE 1 = 1                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	AND T0.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
	SET @mDQry = @mDQry + '	AND T0.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
	SET @mDQry = @mDQry + '	AND T0.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' 			  AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;
	SET @mDQry = @mDQry + ' 						OR EXISTS (SELECT 1                                    ' + char(10) ;
	SET @mDQry = @mDQry + ' 									 FROM #TblDynamicTitlest_SSP0015			   ' + char(10) ;
	SET @mDQry = @mDQry + ' 									 WHERE COLUMN_NAME = T0.COLUMN_NAME)         ' + char(10) ;
	SET @mDQry = @mDQry + ' 				                  )                                            ' + char(10) ;
	SET @mDQry = @mDQry + ' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T0.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;
	SET @mDQry = @mDQry + ' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;
	SET @mDQry = @mDQry + ' 				                  )                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	AND T0.COLUMN_NAME = T3.MEASURE																																	  ' + char(10) ;
	SET @mDQry = @mDQry + '	AND T3.MEASURE != ''LOT''																																  ' + char(10) ;

	SET @mDQry1 = '	SELECT																																							' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		T3.DIVISION_ID,			T3.PLAN_START_YYYYMMDD,					T3.PLAN_TYPE,								T3.FROM_SITE,                                   ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		T3.ITEM_ID,				T0.COLUMN_NAME AS MEASURE,				T0.COLUMN_LABEL_NAME AS MEASURE_NAME,		T0.ATTRIBUTE1 AS PSI_NAME,                      ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		T3.SHIP_FROZEN,							T3.SEQ,	                                                                                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		CASE WHEN T0.COLUMN_NAME = ''LOT'' THEN ISNULL(T3.PROD_DATE, NULL) ELSE convert(NVARCHAR(100),T3.QTY) END AS QTY,                                                ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		'''' AS nick_name,            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		''' + @p_from_yyyymmdd + ''' AS FROM_YYYYMMDD,					''' + @p_to_yyyymmdd + ''' AS TO_YYYYMMDD,				''D_'' + T3.YYYYMMDD AS YYYYMMDD,    ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		ISNULL(T1.SORT_ORDER_NO, T0.SORT_ORDER_NO) AS user_sort_order_no                                                                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	FROM SCM_MST_SHEET_MEASURE T0 WITH(NOLOCK)                                                                                                                      ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	LEFT OUTER JOIN SCM_MST_TITLESET_USER T1 WITH(NOLOCK)                                                                                                           ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		ON T1.PROGRAM_ID = T0.PROGRAM_ID                                                                                                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		AND T1.SHEET_NAME = T0.SHEET_NAME                                                                                                                           ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		AND T1.COLUMN_NAME = T0.COLUMN_NAME                                                                                                                         ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		AND T1.USER_ID = ''' + @p_user_id + '''                                                                                                                     ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	,(                                                                                                                                                              ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		SELECT                                                                                                                                                      ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			tt0.DIVISION_ID,			tt0.PLAN_START_YYYYMMDD,				tt0.PLAN_TYPE,			tt0.FROM_SITE,                                              ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			tt0.ITEM_ID,				tt0.YYYYMMDD,							SUM(tt0.QTY) as QTY,    tt0.MEASURE,                                                ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			MAX(tt0.SEQ) as SEQ,		MAX(tt0.ATTRIBUTE1) as PROD_DATE,		tt2.SHIP_FROZEN,		tt0.ORIGIN_FROM_DIVISION_ID                                 ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		FROM #Tmp_RowData tt0 with(nolock)																															' + char(10) ;	
	SET @mDQry1 = @mDQry1 + '		LEFT OUTER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                               ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			ON (CASE WHEN tt0.DIVISION_ID = ''EE'' THEN tt0.ORIGIN_FROM_DIVISION_ID ELSE tt0.DIVISION_ID END) = tt2.DIVISION_ID                                     ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			AND tt0.FROM_SITE = tt2.SCM_SITE_ID                                                                                                                     ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			AND tt2.VALID_YN = ''Y''                                                                                                                                ' + char(10) ;
	
	SET @mDQry1 = @mDQry1 + '		WHERE 1 = 1                                                                                                                                                 ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		AND tt0.YYYYMMDD >= ''' + @p_from_yyyymmdd + '''                                                                                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		AND tt0.YYYYMMDD <= ''' + @p_to_yyyymmdd + '''                                                                                                              ' + char(10) ;
	
	SET @mDQry1 = @mDQry1 + '		AND EXISTS                                                                                                                                                  ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		(                                                                                                                                                           ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			SELECT 1                                                                                                                                                ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			FROM                                                                                                                                                    ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			(                                                                                                                                                       ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '				SELECT DIVISION_ID,	MAX(PLAN_SEQ) AS PLAN_SEQ FROM SSP_PLAN_VERSION_V                                                                               ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '				WHERE PLAN_TYPE    = ''' + @p_plan_type + '''																															' + char(10);
	
	SET @mDQry1 = @mDQry1 + '				AND CONFIRM_FLAG = ''Y'' AND PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''																' + char(10) ;
	SET @mDQry1 = @mDQry1 + '				GROUP BY DIVISION_ID                                                                                                                                ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			) a                                                                                                                                                     ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '			WHERE a.DIVISION_ID = TT0.DIVISION_ID AND a.PLAN_SEQ = TT0.SEQ                                                                                          ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		)                                                                                                                                                           ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '		GROUP BY tt0.DIVISION_ID, tt0.PLAN_START_YYYYMMDD, tt0.PLAN_TYPE, tt0.FROM_SITE, tt0.ITEM_ID, tt0.YYYYMMDD, tt2.SHIP_FROZEN, tt0.ORIGIN_FROM_DIVISION_ID, tt0.MEASURE ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	) T3                                                                                                                                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	WHERE 1 = 1                                                                                                                                                     ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	AND T0.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	AND T0.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	AND T0.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 			  AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 						OR EXISTS (SELECT 1                                    ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 									 FROM #TblDynamicTitlest_SSP0015			   ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 									 WHERE COLUMN_NAME = T0.COLUMN_NAME)         ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 				                  )                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T0.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;
	SET @mDQry1 = @mDQry1 + ' 				                  )                                            ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	AND T0.COLUMN_NAME = T3.MEASURE																																	  ' + char(10) ;
	SET @mDQry1 = @mDQry1 + '	AND T3.MEASURE = ''LOT''																																  ' + char(10) ;

	--select @mDQry;
	--select @mDQry1;

	BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mQuery1 NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';

		SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
		FROM (
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

			UNION ALL

			SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
					,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name

			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd

		) AS A
		ORDER BY sort_order_no  ;


		SET @mQuery1 = '';

		SELECT @mQuery1 = @mQuery1 + 'CONVERT(NVARCHAR(100), [' + yyyymmdd + ']) AS [' + yyyymmdd + '], '
		FROM (
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

			UNION ALL

			SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
					,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name

			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a with(nolock)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd

		) AS A
		ORDER BY sort_order_no  ;

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

		IF( LEN(@mQuery1)>0)
			SET @mQuery1 = LEFT(@mQuery1, LEN(@mQuery1) - 1);

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+' SELECT * FROM ( ' + CHAR(10);
			SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 a.DIVISION_ID ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 ,a.FROM_SITE ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(dbo.fn_get_scm_site_description(a.DIVISION_ID, a.FROM_SITE ),''-'') as from_site_nm		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PLAN_START_YYYYMMDD		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PLAN_TYPE		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.ITEM_ID	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(a.SHIP_FROZEN,0)	ship_frozen' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.SEQ	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_item_nickname( a.division_id, a.ITEM_ID) as nick_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.MEASURE	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.MEASURE_NAME	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.USER_SORT_ORDER_NO	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PSI_NAME	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.FROM_YYYYMMDD	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.TO_YYYYMMDD	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(CONVERT(NVARCHAR,(SELECT CASE WHEN ISNULL(X.SEGMENT2, '''') = '''' THEN B.LT_FORMATION + ISNULL(B.ATTRIBUTE1 , 0) ELSE CONVERT(INT, X.SEGMENT2) END FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK) ON     X.LOOKUP_TYPE = ''POUCH_WH_IN_DAY'' AND    X.VALID_YN    = ''Y'' AND    X.SEGMENT1    =  SUBSTRING(B.ITEM_ID, 1, 3) AND    X.SEGMENT3    = ''-'' AND    X.SEGMENT4    = ''-'' AND    X.SEGMENT5    = ''-''  WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + ''')),'' '') AS LT_DAY	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2),ROUND(B.SSP_MODIFY_YIELD*100,2)) FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + ''')),'' '') AS YEILD	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL((SELECT B.ATTRIBUTE2 FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + '''), '' '') AS LT_UPDATE_YN	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(case when a.measure=''MES_FCS_HOLD'' then ''oWMS'' when a.measure=''MES_FCS_RELEASE'' then ''Hold'' when a.measure=''WH_STOCK'' then ''MES'' when a.measure=''BALANCE'' then ''FCS'' else '' '' end ) as TYPE	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(case
													when a.measure=''MES_FCS_HOLD'' then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''MES_FCS_RELEASE'' then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''WH_STOCK''  then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''BALANCE''  then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
											  else REPLACE(REPLACE(CONVERT( VARCHAR,convert(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' ),0,'' '')
											  end)  as FIGURE		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,'+@mQuery1	 +CHAR(10);
			SET @mEXEC = @mEXEC+'		FROM (' + @mDQry + ') TTT ' +CHAR(10);
			SET @mEXEC = @mEXEC+'			PIVOT ( ' +CHAR(10);
			SET @mEXEC = @mEXEC+'				    SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
			SET @mEXEC = @mEXEC+'				  ) AS A'   +CHAR(10);
			SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN  (  SELECT S.DIVISION_ID , S.PLAN_START_YYYYMMDD , S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID , (SUM(S.QTY)) TOTAL_QTY
										FROM SSP_ANL_WH_STOCK_V S WITH(NOLOCK)  '   +CHAR(10);
			SET @mEXEC = @mEXEC+'			WHERE S.PLAN_START_YYYYMMDD  = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.DIVISION_ID = '''+@v_division_id +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.SEQ = ''' + @p_seq + '''        ' + char(10);
			SET @mEXEC = @mEXEC+'		GROUP BY S.DIVISION_ID , S.PLAN_START_YYYYMMDD , S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID ) W
											ON W.DIVISION_ID = A.DIVISION_ID AND W.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND W.FROM_SITE = A.FROM_SITE AND W.ITEM_ID = A.ITEM_ID ' + char(10);
			SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN ( SELECT K.DIVISION_ID , K.FROM_SITE, K.ITEM_ID, SUM(K.HOLD_QTY)   AS HOLD_QTY
										FROM   SSP_ANL_HOLD_STOCK K WITH(NOLOCK)  WHERE  1=1		' + char(10);
			SET @mEXEC = @mEXEC+'			AND K.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, '''+@v_plan_start_yyyymmdd +''') +1, 112)			' + char(10);
			SET @mEXEC = @mEXEC+'			AND K.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, '''+@v_plan_start_yyyymmdd +''') +1, 112)		' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.PLAN_START_YYYYMMDD = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.SEQ = ''' + @p_seq + '''        ' + char(10);
			SET @mEXEC = @mEXEC+'		GROUP BY K.DIVISION_ID , K.FROM_SITE, K.ITEM_ID ) X
											ON X.DIVISION_ID = A.DIVISION_ID  AND X.FROM_SITE = A.FROM_SITE AND X.ITEM_ID = A.ITEM_ID ' + char(10);
						SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN  (  SELECT M.DIVISION_ID , M.PLAN_START_YYYYMMDD , M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID , SUM(M.LOT_QTY_MES) AS MES_QTY , SUM(M.LOT_QTY_FCS) AS FCS_QTY
										FROM SSP_ANL_MES_FCS_STOCK_40_C  M WITH(NOLOCK)  '   +CHAR(10);
			SET @mEXEC = @mEXEC+'			WHERE M.PLAN_START_YYYYMMDD  = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.DIVISION_ID = '''+@v_division_id +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.AVAILABLE_YN <> ''N''        ' + char(10);
			 --* 2020/09/23	KIMYONGHO	        WH_STOCK BOH 수량에서 CHANGE_STATUS 'Delete' 제외 ('D')
			SET @mEXEC = @mEXEC+'			AND   M.CHANGE_STATUS <> ''D''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.SEQ = ''' + @p_seq + '''           ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.AVAILABLE_YN = ''Y''           ' + char(10);
			SET @mEXEC = @mEXEC+'			GROUP BY M.DIVISION_ID , M.PLAN_START_YYYYMMDD , M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID    ) Y    ' + char(10);
			SET @mEXEC = @mEXEC+'		ON Y.DIVISION_ID = A.DIVISION_ID AND Y.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND Y.FROM_SITE = A.FROM_SITE AND Y.ITEM_ID = A.ITEM_ID ' + char(10);
			--SET @mEXEC = @mEXEC+'		ORDER BY division_id, from_site,item_id, user_sort_order_no' +CHAR(10);

			SET @mEXEC = @mEXEC+' UNION ALL' + CHAR(10);

			SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 a.DIVISION_ID ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 ,a.FROM_SITE ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(dbo.fn_get_scm_site_description(a.DIVISION_ID, a.FROM_SITE ),''-'') as from_site_nm		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PLAN_START_YYYYMMDD		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PLAN_TYPE		' +CHAR(10);
			
			SET @mEXEC = @mEXEC+' 			,a.ITEM_ID	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(a.SHIP_FROZEN,0)	ship_frozen' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.SEQ	' +CHAR(10);
			
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_item_nickname( a.division_id, a.ITEM_ID) as nick_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.MEASURE	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.MEASURE_NAME	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.USER_SORT_ORDER_NO	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.PSI_NAME	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.FROM_YYYYMMDD	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,a.TO_YYYYMMDD	' +CHAR(10);
			
			SET @mEXEC = @mEXEC+' 			,ISNULL(CONVERT(NVARCHAR,(SELECT CASE WHEN ISNULL(X.SEGMENT2, '''') = '''' THEN B.LT_FORMATION + ISNULL(B.ATTRIBUTE1 , 0) ELSE CONVERT(INT, X.SEGMENT2) END FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK) ON     X.LOOKUP_TYPE = ''POUCH_WH_IN_DAY'' AND    X.VALID_YN    = ''Y'' AND    X.SEGMENT1    =  SUBSTRING(B.ITEM_ID, 1, 3) AND    X.SEGMENT3    = ''-'' AND    X.SEGMENT4    = ''-'' AND    X.SEGMENT5    = ''-''  WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + ''')),'' '') AS LT_DAY	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2),ROUND(B.SSP_MODIFY_YIELD*100,2)) FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + ''')),'' '') AS YEILD	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL((SELECT B.ATTRIBUTE2 FROM SSP_ANL_FORMATION_C B WITH(NOLOCK) WHERE A.DIVISION_ID=B.DIVISION_ID AND A.FROM_SITE=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd +''' AND PLAN_TYPE = '''+@p_plan_type +''' AND SEQ = ''' + @p_seq + '''), '' '') AS LT_UPDATE_YN	' +CHAR(10);			
			SET @mEXEC = @mEXEC+' 			,(case when a.measure=''MES_FCS_HOLD'' then ''oWMS'' when a.measure=''MES_FCS_RELEASE'' then ''Hold'' when a.measure=''WH_STOCK'' then ''MES'' when a.measure=''BALANCE'' then ''FCS'' else '' '' end ) as TYPE	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(case
													when a.measure=''MES_FCS_HOLD'' then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''MES_FCS_RELEASE'' then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''WH_STOCK''  then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
													when a.measure=''BALANCE''  then REPLACE(CONVERT( VARCHAR,CONVERT(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' )
											  else REPLACE(REPLACE(CONVERT( VARCHAR,convert(MONEY,CEILING((case when a.measure=''MES_FCS_HOLD'' then ISNULL(W.TOTAL_QTY,0) when a.measure=''MES_FCS_RELEASE'' then ISNULL(X.HOLD_QTY,0) when a.measure=''WH_STOCK'' then ISNULL(Y.MES_QTY,0) when a.measure=''BALANCE'' then ISNULL(Y.FCS_QTY,0) else 0 end))), 1 ), ''.00'', '''' ),0,'' '')
											  end)  as FIGURE		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
			SET @mEXEC = @mEXEC+'		FROM (' + @mDQry1 + ') TTT ' +CHAR(10);
			SET @mEXEC = @mEXEC+'			PIVOT ( ' +CHAR(10);
			SET @mEXEC = @mEXEC+'				    MAX(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
			SET @mEXEC = @mEXEC+'				  ) AS A'   +CHAR(10);
			SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN  (  SELECT S.DIVISION_ID , S.PLAN_START_YYYYMMDD , S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID , (SUM(S.QTY)) TOTAL_QTY
										FROM SSP_ANL_WH_STOCK_V S WITH(NOLOCK)  '   +CHAR(10);
			SET @mEXEC = @mEXEC+'			WHERE S.PLAN_START_YYYYMMDD  = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.DIVISION_ID = '''+@v_division_id +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   S.SEQ = ''' + @p_seq + '''        ' + char(10);
			SET @mEXEC = @mEXEC+'		GROUP BY S.DIVISION_ID , S.PLAN_START_YYYYMMDD , S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID ) W
											ON W.DIVISION_ID = A.DIVISION_ID AND W.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND W.FROM_SITE = A.FROM_SITE AND W.ITEM_ID = A.ITEM_ID ' + char(10);
			SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN ( SELECT K.DIVISION_ID , K.FROM_SITE, K.ITEM_ID, SUM(K.HOLD_QTY)   AS HOLD_QTY
										FROM   SSP_ANL_HOLD_STOCK K WITH(NOLOCK)  WHERE  1=1		' + char(10);
			SET @mEXEC = @mEXEC+'			AND K.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, '''+@v_plan_start_yyyymmdd +''') +1, 112)			' + char(10);
			SET @mEXEC = @mEXEC+'			AND K.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, '''+@v_plan_start_yyyymmdd +''') +1, 112)		' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.PLAN_START_YYYYMMDD = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   K.SEQ = ''' + @p_seq + '''        ' + char(10);
			SET @mEXEC = @mEXEC+'		GROUP BY K.DIVISION_ID , K.FROM_SITE, K.ITEM_ID ) X
											ON X.DIVISION_ID = A.DIVISION_ID  AND X.FROM_SITE = A.FROM_SITE AND X.ITEM_ID = A.ITEM_ID ' + char(10);
			SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN  (  SELECT M.DIVISION_ID , M.PLAN_START_YYYYMMDD , M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID , SUM(M.LOT_QTY_MES) AS MES_QTY , SUM(M.LOT_QTY_FCS) AS FCS_QTY
										FROM SSP_ANL_MES_FCS_STOCK_40_C  M WITH(NOLOCK)  '   +CHAR(10);
			SET @mEXEC = @mEXEC+'			WHERE M.PLAN_START_YYYYMMDD  = '''+@v_plan_start_yyyymmdd +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.PLAN_TYPE = '''+@p_plan_type +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.DIVISION_ID = '''+@v_division_id +'''        ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.SEQ = ''' + @p_seq + '''           ' + char(10);
			SET @mEXEC = @mEXEC+'			AND   M.AVAILABLE_YN = ''Y''           ' + char(10);
			 --* 2020/09/23	KIMYONGHO	        WH_STOCK BOH 수량에서 CHANGE_STATUS 'Delete' 제외 ('D')
			SET @mEXEC = @mEXEC+'			AND   M.CHANGE_STATUS <> ''D''        ' + char(10);
			SET @mEXEC = @mEXEC+'			GROUP BY M.DIVISION_ID , M.PLAN_START_YYYYMMDD , M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID    ) Y    ' + char(10);
			SET @mEXEC = @mEXEC+'		ON Y.DIVISION_ID = A.DIVISION_ID AND Y.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND Y.FROM_SITE = A.FROM_SITE AND Y.ITEM_ID = A.ITEM_ID ' + char(10);
			--SET @mEXEC = @mEXEC+'		ORDER BY division_id, from_site,item_id, user_sort_order_no' +CHAR(10);
			SET @mEXEC = @mEXEC+' ) TTTT ORDER BY division_id, from_site,item_id, user_sort_order_no' +CHAR(10);

			EXEC (@mEXEC);


			--NOTE, Prod_Qty Load
			EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS @v_division_id, @v_plan_start_yyyymmdd, @v_from_site, @p_item_id, @p_from_yyyymmdd, @p_to_yyyymmdd;



		IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0015') IS NOT NULL	
			DROP TABLE #TblDynamicTitlest_SSP0015;


		-- SHIPMENT ROW DATA
		IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
			DROP TABLE #Tmp_RowData;

	END
END
