
/*
 * PROGRAM ID   : DMF0045_SCPSHIPPLAN_TO_SHIPREQ
 * DESCRIPTION  : SCP_SHIP_PLAN 생성시 DM_PLN_SHIPMENT_REQ 에 데이터를 복사해주는 기능 ( PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 에서 호출함 )
 * OUTTABLE     :
 * EXECUTE      : EXEC DMF0045_SCPSHIPPLAN_TO_SHIPREQ '82', '1234'
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020.03.02   HWI1993        INITIAL RELEASE CSR[C20200302-000164] 전지 ESS 외주 PACKER 출하 SSP 도입관련 SHIPMENT REQUEST 화면 개선
 * 2020.03.04   HWI1993        CSR[C20200303-000235] 사용자가 입력/변경한 데이터 보존, 보존구간은 룩업, 확정구간 반영
 * 2020.03.20   HWI1993        LOOKUP 에 완료처리를 DIV 별로 구분, 로그 보완
 * 2020.03.27	HWI1993		   PROJECT_OWNER 를 System 로 변경
 * 2020.03.30	HWI1993		   삭제대상에 SCM_MST_SITE.ATTRIBUTE2 = 'Y' 조건 추가
 * 2020.04.07	HWI1993		   [C20200407-000313] SCP SHIP PLAN 생성시 REQ생성시 Data 2배로 생성.
 * 2020.07.14   KIMYONGHO      [C20200701-000388] [자동차/ESS] Shipment Request 화면의 FCST type 생성 Logic 변경 요청
 * 2020.07.15   KIMYONGHO      [C20200723-000010] I/F Blocking 관련 (SSP - SCP Final Plan 동기화)
 * 2020.08.11   hwi1993		   운영 장애발생으로 DM 호출 테스트를 위해 리턴값 추가 - 테스트중
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2021.10.01   SSP Pjt.       AS(Warranty) REQ 반영
 *                             1) PLANT to PLANT (LOOKUP:AS_SITE_PLANT에서 매핑하여 FG -> SEMI 생성)
 *                             2) PLANT to SALES (DM MKT_FCST(수요)에서 ETD적용하여 FG 생성)
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2022.08.01   SSP Pjt.       미사용 -> PR_SSP_ANL_SHIP_REQ_FG 으로 대체
 */
CREATE PROC [dbo].[DMF0045_SCPSHIPPLAN_TO_SHIPREQ]
	@p_division_id				NVARCHAR(30)  -- 82번일 경우에만 동작한다.
   ,@p_plan_id                  NVARCHAR(30)  -- PLAN_ID - 숫자로 된 PLAN_ID 를 넘겨준다. ( 내용은 뭐가 들어와도 됨 )
AS
BEGIN
	SET NOCOUNT ON

	-- LOG 용 변수 설정
	DECLARE @v_program_name		NVARCHAR(150) = 'DMF0045_SCPSHIPPLAN_TO_SHIPREQ';
	DECLARE @v_log_type			NVARCHAR(30);
	DECLARE @n_log_count		INTEGER = 0;
	DECLARE @v_log_message		NVARCHAR(1000);
	DECLARE @v_description		NVARCHAR(500);
    DECLARE @v_table_id			NVARCHAR(150)	= N'DM_PLN_SHIPMENT_REQ'; --테이블 필수
	DECLARE @d_event_date		DATETIME;
	DECLARE @v_del_cnt			NVARCHAR(10);

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	--DECLARE @N_DELETE_WEEK  INTEGER = 4;  -- Shipment Req 정보 삭제 기준

	-- 트랜잭션 (START)
    BEGIN TRANSACTION;
	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## START OF PROCEDURE ##########';
		SET @v_description = @p_plan_id;
		SET @D_EVENT_DATE = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- SCP FINAL PLAN INFO
		DECLARE @v_scp_plan_start_yyyymmdd    NVARCHAR(8);
		DECLARE @v_scp_plan_type              NVARCHAR(10); 
		DECLARE @v_scp_seq                    INTEGER ;    


		SELECT TOP 1 
			   @v_scp_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
		     , @v_scp_plan_type           = A.PLAN_TYPE 
		     , @v_scp_seq                 = A.PLAN_SEQ   
		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) 
		 WHERE 1 = 1 
		   AND A.DIVISION_ID = @p_division_id
		   AND A.PLAN_CYCLE  = 'WEEKLY'
		   AND A.PLAN_TYPE   = 'FN'
		   AND A.plan_id     = @p_plan_id
		 ORDER BY 
		       PLAN_START_YYYYMMDD DESC 
			 , PLAN_TYPE_ORDER DESC
			 , PLAN_SEQ DESC 
		; 

		--[C20200723-000010]-----------------------------------------------------------------------------------------------
		--SCP계획사용안할 경우는 자동 생성 제외(Admin > System > SCP I/F Blocking 의 FP Target YN = 'N'일 경우) 
		--휴가기간, 연말(Season Holiday)등의 경DN 등록됨 

		DECLARE @v_scp_block_count   INTEGER = 0;
	
		SELECT @v_scp_block_count	= COUNT(*)
		  FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
		 WHERE DIVISION_ID			= @p_division_id 
		   AND PLAN_START_YYYYMMDD	= @v_scp_plan_start_yyyymmdd 
		   AND FP_TARGET_YN			= 'N'
		;
	

		IF @v_scp_block_count <= 0
		BEGIN
		
			--[C20200701-000388]
			-- SCP_ANL_SHIPMENT_PLAN_FG에는 없는 FCST_TYPE 추출을 위해 
			-- SCP_ANL_SHIPMENT_PLAN_FG의 원천인SCP_PLN_SHIPMENT_PLAN_PEGGING + SCP_PLN_SHIPMENT_PLAN 으로 생성 
			-- UNPEGGING 된건 FCST_TYPE 이 없음     
			IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
				DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG

			SELECT DIVISION_ID                        
				  ,PLAN_START_YYYYMMDD                        
				  ,PLAN_TYPE                 
				  ,SEQ                        
				  ,MAX(OPERATION_GROUP)     AS BIZ_TYPE                   
				  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE                
				  ,FCST_TYPE
				  ,ITEM_ID                        
				  ,TO_SITE                        
				  ,INCOTERMS                        
				  ,FROM_SITE                        
				  ,BOD_ID                        
				  ,TRANSPORT_MODE                        
				  ,MEASURE                        
				  ,YYYYMMDD                         
				  ,SUM(QTY)					AS QTY                                     
			  INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG
			  FROM (                        
				   SELECT        
						  B.DIVISION_ID                        
						 ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
						 ,B.PLAN_TYPE                        
						 ,B.SEQ                          
						 ,B.OPERATION_GROUP                        
						 ,A.PROJECT_CODE 
						 ,A.FCST_TYPE                        
						 ,B.ITEM_ID                        
						 ,B.TO_SITE                    
						 , ISNULL(C.SSP_INCOTERMS, B.INCOTERMS)   AS INCOTERMS
						 ,B.FROM_SITE                        
						 ,B.BOD_ID                         
						 ,B.TRANSPORT_MODE                        
						 ,B.MEASURE                 
						 ,B.YYYYMMDD                        
						 ,A.ALLOCATION_QTY         AS QTY   
					 FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH(NOLOCK)                         
					      LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH(NOLOCK)                   
					   ON 1 = 1                
				      AND A.DIVISION_ID				= B.DIVISION_ID                        
					  AND A.PLAN_START_YYYYMMDD		= B.PLAN_START_YYYYMMDD                
					  AND A.PLAN_TYPE				= B.PLAN_TYPE                          
					  AND A.SEQ						= B.SEQ                               
					  AND A.ORDER_ID				= B.ORDER_ID                 
					  AND A.DIVISION_ID				= @p_division_id               
					  AND A.PLAN_START_YYYYMMDD		= @v_scp_plan_start_yyyymmdd                    
					  AND A.PLAN_TYPE				= @v_scp_plan_type                  
					  AND A.SEQ						= @v_scp_seq                      
					  AND B.MEASURE					= 'SHIP_PLAN'                
					  AND B.SEMI_YN					= 'N'                      
					  AND B.OPERATION_GROUP			= ( CASE WHEN @p_division_id = '40' THEN 'A' ELSE B.OPERATION_GROUP END)
					--AND A.ENG_DEMAND_ID        <> 'UNPEGGING'  
					
					-- 2020.09.18  KBK  법인간 거래 - 실제 매출 Incoterms 적용 
					      LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
					   ON C.DIVISION_ID				= B.DIVISION_ID                        
					  AND C.BOD_ID					= B.BOD_ID
					WHERE 1 = 1                        
					  AND A.DIVISION_ID				= @p_division_id                  
					  AND A.PLAN_START_YYYYMMDD		= @v_scp_plan_start_yyyymmdd                          
					  AND A.PLAN_TYPE				= @v_scp_plan_type                        
					  AND A.SEQ						= @v_scp_seq                            
					  AND B.DIVISION_ID				IS NOT NULL           
					  --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
			       ) X                        
			 GROUP BY                        
 				   DIVISION_ID                        
				 , PLAN_START_YYYYMMDD                        
				 , PLAN_TYPE                
				 , SEQ                        
				 , ISNULL(PROJECT_CODE,'-')    
				 , FCST_TYPE              
				 , ITEM_ID                        
				 , TO_SITE                        
				 , INCOTERMS                        
				 , FROM_SITE                        
				 , TRANSPORT_MODE                        
				 , BOD_ID                        
				 , MEASURE                        
				 , YYYYMMDD      
				;

			DECLARE  @v_ow_day_cnt INT ; -- 사업부별로 확정구간 이후 구간에 대해서 사용자가 입력/변경한 데이터를 며칠까지 보존할 것인지의 일수	

			SELECT @v_ow_day_cnt	= CAST(SEGMENT2 AS INT)
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			 WHERE LOOKUP_TYPE		= 'DM_SHIP_OW_FROZEN'
			   AND SEGMENT1			= @p_division_id
			;

			DECLARE @v_etc_setting_seg1 NVARCHAR(30)
			SET @v_etc_setting_seg1 = 'PLAN_START_YYYYMMDD_' + RTRIM(@p_division_id)


			-- 실행이력을 확인한다. ( 이 프로시저를 호출하는 프로시저가 하루에 한 번 이상 호출되면서 이 프로시저도 여러번 호출 되기 때문에 실행완료여부를 확인 )
			IF NOT EXISTS (
				          SELECT *
				            FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				           WHERE LOOKUP_TYPE = 'DM_ETC_SETTING'
					         AND SEGMENT1 = @v_etc_setting_seg1
					         AND SEGMENT2 = @v_scp_plan_start_yyyymmdd --@v_plan_start_date
					      )
			   AND @v_scp_plan_start_yyyymmdd IS NOT NULL
			   AND @p_division_id IN ( SELECT DIVISION_ID
                                         FROM SCM_MST_DIVISION WITH(NOLOCK)
                                        WHERE VALID_YN = 'Y'
                                          AND ATTRIBUTE3 IN ('40','81','82') 
									 )
			BEGIN

				DELETE A
				  FROM DM_PLN_SHIPMENT_REQ AS A WITH(NOLOCK)
				       JOIN SCM_MST_SITE AS FS WITH(NOLOCK) 
					ON A.DIVISION_ID	= FS.DIVISION_ID 
				   AND A.PLANT_SITE_ID	= FS.SCM_SITE_ID
				       JOIN SCM_MST_SITE AS TS WITH(NOLOCK) 
					ON A.DIVISION_ID	= TS.DIVISION_ID 
				   AND A.SCM_SITE_ID	= TS.SCM_SITE_ID
				 WHERE A.DIVISION_ID	= @p_division_id
				   AND A.SITE_TYPE		= 'SALES'
				   AND ISNULL(TS.ATTRIBUTE2, 'N') = N'Y'		--	해당 사이트가 자동생성 사이트일 경우
				   AND A.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				   
				   -- 확정구간 이후 사업부별 보존구간 적용
				   AND ((
							    A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) 
							AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
							AND ISNULL(A.ATTRIBUTE1,'Y') = N'N'			--	사용자가 수정한 데이터가 아니고
					    ) 
						OR	-- 그 이후 구간은 그냥 삭제
						(	
							A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
						)
						OR A.Qty = 0
					   )

				SET @v_del_cnt = CAST(@@ROWCOUNT AS NVARCHAR(30))
				
				
				-- REQ 에 데이터를 생성하는데, 위에서 보존할 데이터를 제외하고는 모두 삭제했으므로, 확정구간 이후 구간에 대해 Insert 를 하되 아래의 경우만 제외한다.
				-- 1. REQ 와 키가 겹치는 경우, 2.Sales Site 기준으로 자동생성 사이트가 아닌 경우
				INSERT INTO DM_PLN_SHIPMENT_REQ (
					   DIVISION_ID
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , FCST_TYPE
					 , INCOTERMS
					 , TRANSPORT_MODE
					 , BOD_ID
					 , MEASURE
					 , PLANT_SITE_ID
					 , SITE_TYPE
					 , YYYYMMDD
					 , QTY
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 )
				SELECT A.DIVISION_ID
				     , A.PROJECT_CODE
					 , A.TO_SITE
					 , A.ITEM_ID
					 , ISNULL(A.FCST_TYPE,'')
					 , A.INCOTERMS
					 , B.TRANSPORT_MODE		AS TR_MODE
					 , A.BOD_ID
					 , 'SHIP_REQ'			AS MEASURE
					 , A.FROM_SITE 
					 , 'SALES'				AS SITE_TYPE
					 , A.YYYYMMDD
					 , SUM(A.QTY)
					 , 'System'		
					 , getdate()	
					 , 'System'		
					 , getdate()	
					 , N'N'					AS ATTRIBUTE1
				  FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG		AS A WITH(NOLOCK)	-- [C20200701-000388] [자동차/ESS] Shipment Request 화면의 FCST type 생성 Logic 변경 요청						
				       INNER JOIN SCM_SYS_CALENDAR_M		AS O WITH(NOLOCK)  
					ON A.YYYYMMDD		= O.BASIS_YYYYMMDD
				       JOIN SCP_MST_BOD_N_V					AS B WITH(NOLOCK) 
					ON A.DIVISION_ID	= B.DIVISION_ID 
				   AND A.BOD_ID			= B.BOD_ID
				       JOIN SCM_MST_SITE					AS TS WITH(NOLOCK) 
					ON A.TO_SITE		= TS.SCM_SITE_ID 
				   AND A.DIVISION_ID	= TS.DIVISION_ID
				       LEFT OUTER JOIN SCM_MST_SITE			AS FS  WITH(NOLOCK) 
					ON A.DIVISION_ID	= FS.DIVISION_ID 
				   AND A.FROM_SITE		= FS.SCM_SITE_ID
				       LEFT OUTER JOIN DM_PLN_SHIPMENT_REQ	AS E  WITH(NOLOCK) 
					ON A.DIVISION_ID	= E.DIVISION_ID 
				   AND A.PROJECT_CODE	= E.PROJECT_CODE 
				   AND A.TO_SITE		= E.SCM_SITE_ID 
				   AND A.ITEM_ID		= E.ITEM_ID 
				   AND A.FCST_TYPE		= E.FCST_TYPE 
				   AND A.INCOTERMS		= E.INCOTERMS 
				   AND B.TRANSPORT_MODE = E.TRANSPORT_MODE 
				   AND A.FROM_SITE		= E.PLANT_SITE_ID 
				   AND A.YYYYMMDD		= E.YYYYMMDD 
				   AND E.QTY			<> 0 
				   AND E.MEASURE		= 'SHIP_REQ' 
				   AND E.SITE_TYPE		= 'SALES'
				 WHERE A.DIVISION_ID	= @p_division_id		
				   AND A.MEASURE		= 'SHIP_PLAN'                         
				   AND A.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				   AND A.YYYYMMDD		<  CONVERT(VARCHAR, DATEADD(D, 56 + 7, getdate()) ,112) -- 8주 + 7일  
				   AND E.DIVISION_ID	IS NULL						-- 키가 겹치는 경우 제외
				   AND ISNULL(TS.ATTRIBUTE2, 'N') = 'Y'				-- 자동 생성여부를 SITE 별로 적용
				   AND A.QTY			<> 0
				   AND A.TO_SITE NOT IN (
				                        SELECT SCM_SITE_ID 
										  FROM SCM_MST_SITE WITH(NOLOCK) 
										 WHERE DIVISION_ID		= @p_division_id  
										   AND OPERATION_GROUP	= 'W'  
										   AND SITE_TYPE		= 'SALES' 
										   AND VALID_YN			= 'Y'
										)
				 GROUP BY 
				       A.DIVISION_ID
					 , A.PROJECT_CODE
					 , A.TO_SITE
					 , A.ITEM_ID
					 , ISNULL(A.FCST_TYPE,'')
					 , A.INCOTERMS
					 , B.TRANSPORT_MODE
					 , A.BOD_ID
					 , A.FROM_SITE 
					 , A.YYYYMMDD


				SET @v_description = N'DIV : ' + @p_division_id + N'/ PLAN_ID : ' + @v_description + N'/ ROW_COUNT : ' + CONVERT(NVARCHAR(30), @@ROWCOUNT) + N'/ DEL_COUNT : ' + ISNULL(@v_del_cnt, '0' )


				/*===================================================================================================
				-- AS(Warranty) REQ 반영
				-----------------------------------------------------------------------------------------------------
				--   1) PLANT to PLANT (LOOKUP:AS_SITE_PLANT에서 매핑하여 FG -> SEMI 생성) 
				--      FG의 AS to_site(Sales)의 경우 Shipment Request FG 생성 제외하고 
				--      to_site를 SALES type에서 PLANT type으로 변환하여 Shipment Request SEMI 추가
				===================================================================================================*/

	            -- 1. Ship Frozen 이후 구간 Semi Ship Req 삭제

				DELETE R
				  FROM DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)
				       INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
				    ON R.DIVISION_ID		= FS.DIVISION_ID
				   AND R.PLANT_SITE_ID		= FS.SCM_SITE_ID
				   AND FS.SITE_TYPE			= 'PLANT'  
				   AND FS.VALID_YN			= 'Y'	   
				       INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
				    ON R.DIVISION_ID		= TS.DIVISION_ID
				   AND R.SCM_SITE_ID		= TS.SCM_SITE_ID
				   AND TS.SITE_TYPE			= 'PLANT'  
				   AND TS.VALID_YN			= 'Y'
				   AND TS.OPERATION_GROUP	= 'W'
				 WHERE 1 = 1
                   AND R.DIVISION_ID		= @p_division_id
                   AND R.MEASURE			= 'SHIP_REQ'
                   AND R.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , CONVERT(DATETIME, @v_scp_plan_start_yyyymmdd)), 112) -- 확정구간 이후				   
                   AND ((
							    R.YYYYMMDD  >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , CONVERT(DATETIME, @v_scp_plan_start_yyyymmdd)), 112)
							AND R.YYYYMMDD  <  CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) + ISNULL(@v_ow_day_cnt, 0) , CONVERT(DATETIME, @v_scp_plan_start_yyyymmdd)), 112) 
							AND ISNULL(R.LAST_UPDATED_BY,'Y') IN ('scm_batch', 'scp_batch', 'System')			--	사용자가 수정지 않은 데이터
                        ) 
                        OR -- 보존구간 이후는 전부 삭제
						(
								R.YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) + ISNULL(@v_ow_day_cnt, 0) , CONVERT(DATETIME, @v_scp_plan_start_yyyymmdd)), 112) 
                        )
                        OR R.QTY = 0
                       )

				-- 2. Ship Frozen 이후 구간 SHIP REQ SEMI Insert
			    INSERT INTO DM_PLN_SHIPMENT_REQ (
			           DIVISION_ID
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , FCST_TYPE
					 , INCOTERMS
					 , TRANSPORT_MODE
					 , BOD_ID
			         , MEASURE
					 , PLANT_SITE_ID
					 , SITE_TYPE
					 , YYYYMMDD
					 , QTY
			         , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
			         )
				SELECT R.DIVISION_ID
					 , R.PROJECT_CODE
					 , R.SCM_SITE_ID
					 , R.ITEM_ID
					 , R.FCST_TYPE
					 , R.INCOTERMS
					 , R.TRANSPORT_MODE
					 , R.BOD_ID
					 , R.MEASURE
					 , R.PLANT_SITE_ID
					 , R.SITE_TYPE
					 , R.YYYYMMDD
					 , R.QTY
					 , 'System'		
					 , getdate()	
					 , 'System'		
					 , getdate()	
                  FROM (
				       SELECT Y.DIVISION_ID
							, Y.PROJECT_CODE
							, Z.TO_SITE     AS SCM_SITE_ID
							, Y.ITEM_ID
							, Y.FCST_TYPE
							, Z.INCOTERMS
							, Z.TRANSPORT_MODE
							, Y.BOD_ID
							, 'SHIP_REQ'	AS MEASURE
							, Z.FROM_SITE   AS PLANT_SITE_ID
							, 'PLANT'		AS SITE_TYPE
							, Y.YYYYMMDD
							, Y.QTY
						 FROM (
							  SELECT DIVISION_ID
								   , PROJECT_CODE
								   , ITEM_ID
								   , FCST_TYPE
								   , (SELECT TOP 1 BOD_ID 
										FROM SCP_MST_BOD_N_V 
									   WHERE DIVISION_ID		= X.DIVISION_ID
										 AND FROM_SITE			= X.FROM_SITE
										 AND TO_SITE			= X.TO_SITE
										 AND INCOTERMS			= X.INCOTERMS
										 AND TRANSPORT_MODE		= X.TRANSPORT_MODE
										 AND X.YYYYMMDD			BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD
										 AND BOD_VALID_YN		= 'Y'
									   ORDER BY
											 PRIORITY
									 ) AS BOD_ID --new bod for plant type
								   , YYYYMMDD
								   , QTY
								FROM (
									 SELECT SP.DIVISION_ID
										  , SP.PROJECT_CODE
										  , L.SEGMENT2			AS TO_SITE
										  , SP.ITEM_ID
										  , SP.FCST_TYPE
										  , BOD.INCOTERMS       --FG의 ssp_incoterms가 아닌 bod의 incoterms
										  , BOD.TRANSPORT_MODE
										  , SP.FROM_SITE		AS FROM_SITE
										  , CASE WHEN BOD.SEGMENT3 = 'A' THEN SP.YYYYMMDD
										  		 ELSE SP.YYYYMMDD + BOD.BEFORE_LT 
										  	END					AS YYYYMMDD
										  , SP.QTY
									   FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG	SP WITH(NOLOCK)
											INNER JOIN SCP_MST_BOD_N_V		BOD WITH(NOLOCK)   --Searching for division_id, from_site, incoterms, trans_mode
										 ON SP.DIVISION_ID		= BOD.DIVISION_ID
										AND SP.BOD_ID			= BOD.BOD_ID
											INNER JOIN SCM_MST_SITE			FS WITH(NOLOCK)
										 ON SP.DIVISION_ID		= FS.DIVISION_ID
										AND SP.FROM_SITE		= FS.SCM_SITE_ID
										AND FS.SITE_TYPE		= 'PLANT'  
										AND FS.VALID_YN			= 'Y'
											INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS L (NOLOCK)
										 ON L.LOOKUP_TYPE		= 'AS_SITE_PLANT'
										AND L.VALID_YN			= 'Y'
										AND L.SEGMENT1			= SP.TO_SITE
										AND L.SEGMENT3			= SP.DIVISION_ID
											INNER JOIN SCM_MST_SITE			TS WITH(NOLOCK)
										 ON SP.DIVISION_ID		= TS.DIVISION_ID
										AND L.SEGMENT2			= TS.SCM_SITE_ID
										AND TS.SITE_TYPE		= 'PLANT'  
										AND TS.OPERATION_GROUP	= 'W'
										AND TS.VALID_YN			= 'Y'
									WHERE 1 = 1
										AND TS.PLANT_ID <> FS.PLANT_ID
										AND SP.TO_SITE IN (
														  SELECT SCM_SITE_ID 
															FROM SCM_MST_SITE WITH(NOLOCK) 
														   WHERE DIVISION_ID		= @p_division_id  
															 AND SITE_TYPE			= 'SALES' 
															 AND OPERATION_GROUP	= 'W'  
															 AND VALID_YN			= 'Y'
														  )
										AND SP.YYYYMMDD       >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN, 10), CONVERT(DATETIME,@v_scp_plan_start_yyyymmdd,112)), 112) -- 월요일 + 주 이후
										AND SP.YYYYMMDD       <  CONVERT(CHAR(8), DATEADD(DD, 7*10, getdate()), 112) -- 10주 이내
										AND SP.QTY            > 0
										AND SP.DIVISION_ID    = @p_division_id
									) AS X
							) AS Y
							INNER JOIN SCP_MST_BOD_N_V AS Z
						ON Y.BOD_ID = Z.BOD_ID
				       ) AS R
					   LEFT OUTER JOIN DM_PLN_SHIPMENT_REQ AS E  WITH(NOLOCK) 
					ON R.DIVISION_ID	= E.DIVISION_ID 
				   AND R.PROJECT_CODE	= E.PROJECT_CODE 
				   AND R.SCM_SITE_ID	= E.SCM_SITE_ID 
				   AND R.ITEM_ID		= E.ITEM_ID 
				   AND R.FCST_TYPE		= E.FCST_TYPE 
				   AND R.INCOTERMS		= E.INCOTERMS 
				   AND R.TRANSPORT_MODE = E.TRANSPORT_MODE 
				   AND R.MEASURE        = E.MEASURE
				   AND R.PLANT_SITE_ID	= E.PLANT_SITE_ID 
				   AND R.YYYYMMDD		= E.YYYYMMDD 
				 WHERE E.DIVISION_ID  IS NULL  --중복 방지

				/*===================================================================================================
				-- AS(Warranty) REQ 반영
				-----------------------------------------------------------------------------------------------------
				--   2) PLANT to SALES (DM MKT_FCST(수요)에서 ETD적용하여 FG 생성)
				===================================================================================================*/

			    INSERT INTO DM_PLN_SHIPMENT_REQ (
			           DIVISION_ID
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , FCST_TYPE
					 , INCOTERMS
					 , TRANSPORT_MODE
					 , BOD_ID
			         , MEASURE
					 , PLANT_SITE_ID
					 , SITE_TYPE
					 , YYYYMMDD
					 , QTY
			         , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
			         )
				SELECT R.DIVISION_ID
					 , R.PROJECT_CODE
					 , R.SCM_SITE_ID
					 , R.ITEM_ID
					 , R.FCST_TYPE
					 , R.INCOTERMS
					 , R.TRANSPORT_MODE
					 , MAX(R.BOD_ID)
					 , R.MEASURE
					 , R.PLANT_SITE_ID
					 , MAX(R.SITE_TYPE)
					 , R.YYYYMMDD
					 , SUM(R.QTY)
					 , 'System'		
					 , getdate()	
					 , 'System'		
					 , getdate()	
					 , N'N'			-- ATTRIBUTE1
                  FROM (
						SELECT  
						       Y.DIVISION_ID
							 , Y.PROJECT_CODE
							 , Y.SCM_SITE_ID
							 , Y.ITEM_ID
							 , Y.FCST_TYPE
							 , ISNULL(Z.SSP_INCOTERMS, Z.INCOTERMS) AS INCOTERMS
							 , Z.TRANSPORT_MODE
							 , Z.BOD_ID
							 , 'SHIP_REQ'							AS MEASURE
							 , Y.PLANT_SITE_ID
							 , 'SALES'								AS SITE_TYPE
							 , [dbo].[FN_GET_SSP_ETD_DATE](Y.DIVISION_ID, Z.BOD_ID, Y.DM_YYYYMMDD) AS YYYYMMDD
							 , Y.QTY
							 , Y.SHIP_FROZEN
						 FROM (
							   SELECT DM.DIVISION_ID
									, DM.PROJECT_CODE
									, DM.SCM_SITE_ID		
									, DM.ITEM_ID
									, DM.FCST_TYPE
									, DM.INCOTERMS
									, (SELECT TOP 1 BOD_ID 
										 FROM SCP_MST_BOD_V --현재일 기준으로
										WHERE DIVISION_ID	= DM.DIVISION_ID
										  AND FROM_SITE		= DM.ATTRIBUTE10
										  AND TO_SITE		= DM.SCM_SITE_ID
										  AND INCOTERMS		= DM.INCOTERMS
										  AND BOD_VALID_YN	= 'Y'
										ORDER BY
											  PRIORITY
									) AS BOD_ID
									, DM.ATTRIBUTE10		AS PLANT_SITE_ID
									, DM.YYYYMMDD           AS DM_YYYYMMDD
									, DM.QTY
									, FS.SHIP_FROZEN
								 FROM DM_PLN_MKT_FCST DM WITH(NOLOCK)
									  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
								   ON DM.DIVISION_ID		= FS.DIVISION_ID
								  AND DM.ATTRIBUTE10		= FS.SCM_SITE_ID
								  AND FS.SITE_TYPE			= 'PLANT'  
								  AND FS.OPERATION_GROUP	= 'W'
								  AND FS.VALID_YN			= 'Y'
									  INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
								   ON DM.DIVISION_ID		= TS.DIVISION_ID
								  AND DM.SCM_SITE_ID		= TS.SCM_SITE_ID
								  AND TS.SITE_TYPE			= 'SALES'  
								  AND TS.VALID_YN			= 'Y'
								WHERE 1 = 1
								  AND DM.MEASURE        = 'MKT_FCST' 
								  AND ISNULL(TS.ATTRIBUTE2, 'N') = 'Y'  --자동 생성 여부
								  AND DM.QTY            > 0
								  AND DM.DIVISION_ID	= @p_division_id
						  ) AS Y
							   INNER JOIN SCP_MST_BOD_N_V AS Z
							ON Y.BOD_ID = Z.BOD_ID	
				       ) AS R
					   LEFT OUTER JOIN DM_PLN_SHIPMENT_REQ AS E  WITH(NOLOCK) 
					ON R.DIVISION_ID	= E.DIVISION_ID 
				   AND R.PROJECT_CODE	= E.PROJECT_CODE 
				   AND R.SCM_SITE_ID	= E.SCM_SITE_ID 
				   AND R.ITEM_ID		= E.ITEM_ID 
				   AND R.FCST_TYPE		= E.FCST_TYPE 
				   AND R.INCOTERMS		= E.INCOTERMS 
				   AND R.TRANSPORT_MODE = E.TRANSPORT_MODE 
				   AND R.MEASURE        = E.MEASURE
				   AND R.PLANT_SITE_ID	= E.PLANT_SITE_ID 
				   AND R.YYYYMMDD		= E.YYYYMMDD 
				 WHERE 1 = 1
				   AND R.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(R.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				   AND R.YYYYMMDD		<  CONVERT(VARCHAR, DATEADD(D, 56 + 7, getdate()) ,112) -- 8주 + 7일
				   AND E.DIVISION_ID  IS NULL   --중복 방지
				GROUP BY
                       R.DIVISION_ID
					 , R.PROJECT_CODE
					 , R.SCM_SITE_ID
					 , R.ITEM_ID
					 , R.FCST_TYPE
					 , R.INCOTERMS
					 , R.TRANSPORT_MODE
					 --, R.BOD_ID
					 , R.MEASURE
					 , R.PLANT_SITE_ID
					 --, R.SITE_TYPE
					 , R.YYYYMMDD
				--===================================================================================================

			    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT2		= ISNULL(@v_scp_plan_start_yyyymmdd, '')
					 , SEGMENT3		= CONVERT(CHAR(30), getdate(), 121)
				 WHERE LOOKUP_TYPE	= 'DM_ETC_SETTING'
				   AND SEGMENT1		= @v_etc_setting_seg1

			END
		END

 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type = 'TXN';
		SET @v_log_message = N'INSERT INTO '+ @v_table_id;
		--SET @v_description = @p_plan_id;
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 트랜잭션 (COMMIT)
		COMMIT WORK;

	END TRY
	
	BEGIN CATCH
		ROLLBACK TRANSACTION;

 		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH (
			       PROGRAM_NAME
				  ,LOG_TYPE
				  ,LOG_COUNT
				  ,LOG_MESSAGE
				  ,DESCRIPTION
				  ,EVENT_DATE
				  ,CREATION_DATE
				  ,CREATED_BY
				  ,LAST_UPDATE_DATE
				  ,LAST_UPDATED_BY)
			VALUES (
			       ERROR_PROCEDURE()
				  ,'ERROR'
				  ,NULL
				  ,ERROR_MESSAGE()
				  ,NULL
				  ,SYSDATETIME()
				  ,SYSDATETIME()
				  ,ERROR_PROCEDURE()
				  ,SYSDATETIME()
				  ,ERROR_PROCEDURE()
				  );

		END;

		IF( @v_err_message IS NULL OR @v_err_message ='')
			SELECT 'F' AS RESULT_CODE, '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
		ELSE
			SELECT 'N' AS RESULT_CODE, @v_err_message AS ERR_MESSAGE ;

		IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
			DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG

	END CATCH;

	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END OF PROCEDURE ##########';
	--SET @v_description = @p_plan_id;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG

END
