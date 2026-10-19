/*
 * Program ID   : PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40
 * Description  : SSP Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/11/24   KIMYONGHO	   신규추가
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40]
	@p_company_id1				NVARCHAR(10),
	@p_log_messge				NVARCHAR(1000) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @p_company_id  NVARCHAR(10);
	SET     @p_company_id = @p_company_id1 ;

	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(8);
	DECLARE @v_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_to_yyyymmdd			NVARCHAR(8);

	DECLARE @v_site_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_site_to_yyyymmdd			NVARCHAR(8);

	DECLARE @v_boh_yyyymmdd			NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd		NVARCHAR(8);

	DECLARE @v_program_id			NVARCHAR(50);
	DECLARE @v_sheet_name			NVARCHAR(50);

	DECLARE @v_fromsite_cnt			INT;
	DECLARE @v_fromsite_tmpcnt		INT;
	
	DECLARE @v_receiver_cnt			INT;
	DECLARE @v_receiver_tmpcnt		INT;

	DECLARE @v_item_cnt				INT;
	DECLARE @v_item_tmpcnt			INT;

	
	DECLARE @TESTCNT INT;
	SET @TESTCNT = 0; 

	DECLARE @MEASURECNT INT;
	SET @MEASURECNT = 0; 


	DECLARE @v_head_cont		NVARCHAR(max);
	DECLARE @v_body_cont		NVARCHAR(max);
	DECLARE @v_receiver_temp	NVARCHAR(150);
	DECLARE @v_to_mail			NVARCHAR(max);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);
	DECLARE @v_body_contents    NVARCHAR(MAX);
	DECLARE @v_mail_title       NVARCHAR(100);
	DECLARE @v_mail_receiver	NVARCHAR(100);

	DECLARE @v_division_id				NVARCHAR(100);
	DECLARE @v_company_id				NVARCHAR(100);
	DECLARE @v_from_site_description    NVARCHAR(100);
	DECLARE @v_to_site_description		NVARCHAR(100);
	DECLARE @v_dept_name_ko				NVARCHAR(100);
	DECLARE @v_mkt_user					NVARCHAR(100);
	DECLARE @v_item_id					NVARCHAR(100);
	DECLARE @v_item_id_temp				NVARCHAR(100);
	DECLARE @v_nick_name				NVARCHAR(100);
	DECLARE @v_measure_name				NVARCHAR(100);
	DECLARE @v_seq						NVARCHAR(100);
	DECLARE @v_segment1					NVARCHAR(100);
	DECLARE @v_segment2					NVARCHAR(100);
	DECLARE @v_segment3					NVARCHAR(100);
	DECLARE @v_segment4					NVARCHAR(100);
	DECLARE @v_segment5					NVARCHAR(100);
	DECLARE @v_item_seq					NVARCHAR(100);
	DECLARE @v_item_seq_temp			NVARCHAR(100) = 0;
	
	DECLARE @v_MEASURE_SEQ				NVARCHAR(100);
	DECLARE @v_rowspanCnt				NVARCHAR(100);
	DECLARE @v_rowspanCnt2				NVARCHAR(100);
	DECLARE @v_cnt						INT;



	-- SCP FINAL PLAN INFO
	DECLARE @v_scp_plan_start_yyyymmdd		NVARCHAR(8);
	DECLARE @v_scp_plan_type				NVARCHAR(10); 
	DECLARE @v_scp_seq						INTEGER ;    

	DECLARE @v_last_plan_start_yyyymmdd     NVARCHAR(8)		= '';
	DECLARE @v_last_plan_type				NVARCHAR(30)	= 'SP'; 
	DECLARE @v_last_seq						INTEGER			= 0;



	DECLARE @p_sheet_name     NVARCHAR(10) = 'Cell Biz';
	DECLARE @p_division_id    NVARCHAR(30) = '40';
	DECLARE @p_team_id        NVARCHAR(MAX);
	DECLARE @p_customer       NVARCHAR(MAX);
	DECLARE @p_scm_site_id    NVARCHAR(MAX);
	DECLARE @p_plant_site_id  NVARCHAR(MAX);
	DECLARE @p_project_code   NVARCHAR(MAX);
	DECLARE @p_item_id        NVARCHAR(4000);
	--DECLARE @p_from_yyyymmdd  NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD,21,GETDATE()),112);
	--DECLARE @p_to_yyyymmdd    NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD,25,GETDATE()),112);
	DECLARE @p_from_yyyymmdd  NVARCHAR(8) = '';
	DECLARE @p_to_yyyymmdd    NVARCHAR(8) = ''
	--DECLARE @p_from_yyyymmdd  NVARCHAR(8) = '20201210';
	--DECLARE @p_to_yyyymmdd    NVARCHAR(8) = '20201214';
	DECLARE @p_created_by	  NVARCHAR(50);
	DECLARE @debug_mode       NVARCHAR(1)='F';


	DECLARE @P_PROGRAM_ID	NVARCHAR(MAX) = 'SSP0026';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_fromsite_tmpcnt = 0;
	SET @v_receiver_tmpcnt = 0;
	SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112) ;


    DECLARE @v_mail_count   INTEGER = 0;

	select @v_mail_count = count(*)
	from   SCM_ADM_SMS_MAIL_SEND_LOG (nolock)
	where  segment1 = @v_program_name
	and    segment2 = '40'
	and    segment3 = @p_company_id
	and    convert(char(8), creation_date, 112) = @v_plan_start_yyyymmdd
	;
		
	IF @v_mail_count > 0
	BEGIN
		RETURN ;
	END ;

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;
	
	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_01') IS NOT NULL	
		DROP TABLE #Tmp_Result_01;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_02') IS NOT NULL	
		DROP TABLE #Tmp_Result_02;
	
	IF OBJECT_ID('tempdb..#TMP_Tbl_SSP_MAIL_SEND_BATCH_N') IS NOT NULL
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;

	IF OBJECT_ID('tempdb..#TMP_RESULT_PIVOT_TABLE_TEMP') IS NOT NULL
		DROP TABLE #TMP_RESULT_PIVOT_TABLE_TEMP;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_FG') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_40_FG;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_STD') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_40_STD;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	

	CREATE TABLE #Tmp_Raw_Result_Table
	(
		  DIVISION_ID		NVARCHAR(10)		
		, ITEM_ID			NVARCHAR(50)
		, FROM_SITE			NVARCHAR(30)
		, TO_SITE			NVARCHAR(30)
		, DEPT_NAME_KO		NVARCHAR(30)
		, MEASURE			NVARCHAR(50)
		, MEASURE_NAME		NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, BOD_ID			NVARCHAR(30)
		, QTY				NUMERIC(20, 10)
		, INCOTERMS			NVARCHAR(50)
		, TRANSPORT_MODE	NVARCHAR(50)
		, FCST_TYPE			NVARCHAR(50)
		, SEQ				INT
		, CONFIRM_DAY		INT
		, REQUESTOR			NVARCHAR(200)
	);


	CREATE TABLE #Tmp_RowData
	(
		DIVISION_ID			NVARCHAR(10)		
		, ITEM_ID			NVARCHAR(50)
		, FROM_SITE			NVARCHAR(30)
		, TO_SITE			NVARCHAR(30)
		, MEASURE			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, BOD_ID			NVARCHAR(30)
		, QTY				NUMERIC(20, 10)
		, INCOTERMS			NVARCHAR(50)
		, TRANSPORT_MODE	NVARCHAR(50)
		, FCST_TYPE			NVARCHAR(50)
		, SEQ				INT
		, LAST_UPDATED_BY	NVARCHAR(50)
		, LAST_UPDATE_DATE  DATETIME
		, REMARK			NVARCHAR(MAX)
	);


	CREATE TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N (
			SITE_SEQ					INT
			, REC_SEQ					INT
			, ITEM_SEQ					INT
			, MEASURE_SEQ					INT
			, MAIL_RECEIVER				NVARCHAR(100)
			, division_id				NVARCHAR(100) 
			, COMPANY_ID				NVARCHAR(100)
			, from_site_description		NVARCHAR(100)
			, to_site_description		NVARCHAR(100)
			, DEPT_NAME_KO				NVARCHAR(100)
			, MKT_USER					NVARCHAR(100)
			, item_id					NVARCHAR(100)
			, nick_name					NVARCHAR(100)
			, measure					NVARCHAR(100)
			, measure_name				NVARCHAR(100)
			, seq						INT
			, segment1					NVARCHAR(100) -- 현재일
			, segment2					NVARCHAR(100) -- 현재일 + 1
			, segment3					NVARCHAR(100) -- 현재일 + 2
			, segment4					NVARCHAR(100) -- 현재일 + 3
			, segment5					NVARCHAR(100) -- 현재일 + 4
	);
	/********************************************************************************/

	SET @v_program_id = 'SSP0026';
	SET @v_sheet_name = 'Cell Biz';



	BEGIN TRY	
		--//시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--//LOG END
		SELECT TOP 1 
			  @v_scp_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
		,      @v_scp_plan_type           = A.PLAN_TYPE 
		,      @v_scp_seq                 = A.PLAN_SEQ   
		FROM   SCP_PLAN_VERSION_V A WITH(NOLOCK)  
		WHERE  1=1 
		AND    A.DIVISION_ID = @P_division_id
		AND    A.PLAN_CYCLE  = 'WEEKLY'
		AND    A.PLAN_TYPE   = 'FN'
		ORDER BY PLAN_START_YYYYMMDD DESC , PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC 
		;
    
		--가장 최근 출하계획 버전 확인 
		SELECT @v_last_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
		,      @v_last_seq                 = MAX(PLAN_SEQ)
		,      @v_last_plan_type           = MAX(PLAN_TYPE)
		FROM   SSP_PLAN_VERSION_V
		WHERE  PLAN_TYPE    = 'SP'
		AND    DIVISION_ID  = @p_division_id 
		AND    CONFIRM_FLAG = 'Y'
		;


		SELECT @p_from_yyyymmdd = @v_last_plan_start_yyyymmdd, @p_to_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(DD, 56, CONVERT(VARCHAR, @v_last_plan_start_yyyymmdd, 121)), 112)
	
		-- SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다.
		SELECT DISTINCT
	       DIVISION_ID
	     , FROM_SITE
		 , PLAN_START_YYYYMMDD
		INTO #TblDynamic_SSP0026_40_STD     -- 기준 데이터 저장
		FROM(
			SELECT SP.DIVISION_ID
				 , SP.FROM_SITE
				 , SP.PLAN_START_YYYYMMDD
				 , RANK() OVER(PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS RANK
			  FROM SSP_ANL_SHIP_PLAN_40 SP WITH(NOLOCK)
			 WHERE SP.DIVISION_ID    = @p_division_id
			   AND SP.PLAN_START_YYYYMMDD >= CONVERT(VARCHAR(8) ,GETDATE() -1,112)  -- 전일
			   AND SP.PLAN_START_YYYYMMDD <= CONVERT(VARCHAR(8) ,GETDATE() ,112)    -- 당일
			   AND SP.QTY > 0
		   ) A
	   WHERE RANK = 1
		;

	
		SELECT  A.DIVISION_ID      
				,A.PLAN_START_YYYYMMDD                
				,A.PLAN_TYPE            
				,A.SEQ                  
				,A.ORDER_ID
				,A.ALLOCATION_QTY 
				,A.FCST_TYPE 
				,A.MASTER_ID
				,A.PLAN_ID
				,A.OUT_VERSION_ID
		INTO #TblDynamic_SSP0026_40_FG
		FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)
		WHERE A.DIVISION_ID = @P_DIVISION_ID
			AND A.PLAN_START_YYYYMMDD	   = @V_SCP_PLAN_START_YYYYMMDD                
			AND A.PLAN_TYPE					= @V_SCP_PLAN_TYPE
			AND A.SEQ					   = @V_SCP_SEQ
		;

		SELECT  DIVISION_ID                        
			  , PLAN_START_YYYYMMDD                        
			  , PLAN_TYPE                 
			  , SEQ                        
			  , MAX(OPERATION_GROUP)     AS BIZ_TYPE                                 
			  , FCST_TYPE
			  , ITEM_ID                        
			  , TO_SITE                        
			  -- , INCOTERMS                        
			  , FROM_SITE                        
			  , BOD_ID                        
			  , TRANSPORT_MODE                        
			  , MEASURE                        
			  , YYYYMMDD                         
			  , SUM(QTY) AS QTY                                             
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
		  INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG
		  FROM (
				SELECT B.DIVISION_ID                        
					, B.PLAN_START_YYYYMMDD                     
					, B.PLAN_TYPE                        
					, B.SEQ                          
					, B.OPERATION_GROUP                        
					, A.FCST_TYPE                        
					, B.ITEM_ID                        
					, B.TO_SITE                    		
					, B.FROM_SITE                        
					, B.BOD_ID                         
					, B.TRANSPORT_MODE                        
					, B.MEASURE                 
					, B.YYYYMMDD                        
					, A.ALLOCATION_QTY         AS QTY 
					, REPLACE(B.LAST_UPDATED_BY,'scp_batch','System') as LAST_UPDATED_BY
					, B.LAST_UPDATE_DATE
				FROM SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                          
				INNER JOIN #TblDynamic_SSP0026_40_FG A WITH (NOLOCK)           
					ON 1 = 1
						AND A.DIVISION_ID          = B.DIVISION_ID     
						AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
						AND A.PLAN_TYPE             = B.PLAN_TYPE   
						AND A.SEQ                   = B.SEQ      
						AND A.ORDER_ID              = B.ORDER_ID 
						AND A.MASTER_ID				= B.MASTER_ID
						AND A.PLAN_ID				= B.PLAN_ID
						AND A.OUT_VERSION_ID		= B.OUT_VERSION_ID
     
					INNER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
							ON B.DIVISION_ID		   = T4.DIVISION_ID                                                           
							AND B.TO_SITE			   = T4.SCM_SITE_ID                                                              
							AND T4.VALID_YN		   = 'Y'
							AND T4.OPERATION_GROUP IS NULL 

				WHERE 1 = 1
					AND B.DIVISION_ID			   = @p_division_id
					AND B.PLAN_START_YYYYMMDD	   = @v_scp_plan_start_yyyymmdd                    
					AND B.PLAN_TYPE				   = @v_scp_plan_type
					AND B.SEQ					   = @v_scp_seq
					AND B.MEASURE                  ='SHIP_PLAN'			  
					--AND B.SEMI_YN                  = 'N'
					AND B.OPERATION_GROUP		   = 'A' 
					AND B.YYYYMMDD			   >= @p_from_yyyymmdd
					AND B.YYYYMMDD			   <= @p_to_yyyymmdd		

			) X                        
				GROUP BY DIVISION_ID                        
						, PLAN_START_YYYYMMDD                        
						, PLAN_TYPE                
						, SEQ                           
						, FCST_TYPE              
						, ITEM_ID                        
						, TO_SITE                        
					--  , INCOTERMS                        
						, FROM_SITE                        
						, TRANSPORT_MODE                        
						, BOD_ID                        
						, MEASURE                        
						, YYYYMMDD 
						, LAST_UPDATED_BY
						, LAST_UPDATE_DATE
			;

			-----------------------------------------------
			-- 1. SCP Plan : SCP(Weekly) plant향 Shipment Plan
			-----------------------------------------------
			INSERT INTO #TMP_ROWDATA
			SELECT SP.DIVISION_ID												
				, SP.ITEM_ID													
				, SP.FROM_SITE 
				, SP.TO_SITE
				, 'SCP_SHIP_PLAN' AS MEASURE
				, SP.YYYYMMDD
				, SP.BOD_ID
				, ISNULL(SP.QTY,0) AS QTY
				, bod.INCOTERMS
				, bod.TRANSPORT_MODE
				--, ISNULL(SP.FCST_TYPE,'') AS FCST_TYPE
				, '-' AS FCST_TYPE
				, 1 AS SEQ
				, SP.LAST_UPDATED_BY
				, SP.LAST_UPDATE_DATE
				, '-' AS REMARK
			FROM   scp_anl_shipment_plan_semi sp WITH(NOLOCK)
			INNER JOIN (SELECT division_id, plan_start_yyyymmdd, plan_type, plan_seq, plan_id, modeling_id, sort_seq
							, ROW_NUMBER() OVER (PARTITION BY division_id
													ORDER BY plan_start_yyyymmdd desc, sort_seq ASC, plan_seq DESC 
												) row_num 
						FROM  (SELECT division_id, plan_start_yyyymmdd, plan_type, plan_seq, plan_id, modeling_id
									, CASE WHEN plan_type = 'PR' THEN 4
											WHEN plan_type = 'MA' THEN 3
											WHEN plan_type = 'SE' THEN 2
											WHEN plan_type = 'FN' THEN 1
											ELSE 9
										END AS sort_seq
								FROM   scp_plan_version_v with(nolock)
								WHERE  1=1
								AND    division_id          = @p_division_id -- 변수
								AND    plan_cycle           = 'WEEKLY'
								-- 191219 FN만 조회
								--AND    plan_type       NOT IN ('TE', 'TM') 
								AND    plan_type       ='FN'
								AND    plan_start_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
								) a
						) pv
				   ON  sp.division_id         = pv.division_id
				   AND sp.plan_start_yyyymmdd = pv.plan_start_yyyymmdd
				   AND sp.plan_type           = pv.plan_type
				   AND sp.seq                 = pv.plan_seq
				   AND pv.row_num             = 1
				   AND sp.measure             = 'SHIP_PLAN_AMEND'
				   AND sp.qty                 > 0
				   AND sp.operation_group	  = 'A'
				   AND sp.yyyymmdd			  >= @p_from_yyyymmdd
				   AND sp.yyyymmdd			  <= @p_to_yyyymmdd
				   AND ( ( @p_scm_site_id IS NULL OR         @p_scm_site_id         ='' ) OR sp.from_site         IN (SELECT token FROM dbo.String_Split(@p_scm_site_id    ,',')) )
				   AND ( ( @p_item_id IS NULL OR			 @p_item_id         ='' )	  OR sp.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			INNER JOIN scp_mst_bod_n_v bod WITH(NOLOCK)	ON  sp.division_id = bod.division_id
														AND sp.bod_id      = bod.bod_id
			INNER JOIN SCM_MST_SITE FS with(nolock)		ON FS.DIVISION_ID=sp.division_id
														AND FS.SCM_SITE_ID=sp.from_site
														AND FS.VALID_YN='Y'
			INNER JOIN SCM_MST_SITE TS with(nolock)		ON TS.DIVISION_ID=sp.division_id
														AND TS.SCM_SITE_ID=sp.to_site
														AND TS.VALID_YN='Y'
			WHERE 1=1
			AND FS.PLANT_ID <> TS.PLANT_ID
			;

			/*SCP_SHIP_PLAN Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT A.DIVISION_ID												
				, A.ITEM_ID													
				, A.FROM_SITE 
				, A.TO_SITE
				, 'SCP_SHIP_PLAN' AS MEASURE
				, A.YYYYMMDD
				, A.BOD_ID
				, ISNULL(A.QTY,0) AS QTY
				, C.INCOTERMS
				, C.TRANSPORT_MODE
				, ISNULL(A.FCST_TYPE,'') AS FCST_TYPE
				, 1 AS SEQ
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
				, '-' AS REMARK
			FROM  #TMP_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK) 	
			LEFT OUTER JOIN SCP_MST_BOD_N_V C WITH(NOLOCK)
					ON   C.DIVISION_ID		   = A.DIVISION_ID                        
					AND  C.BOD_ID			   = A.BOD_ID
					AND  C.DIVISION_ID		   = @p_division_id
					AND  C.BOD_TYPE			   = 'SALES'
			WHERE A.DIVISION_ID			= @p_division_id			
			AND A.MEASURE				= 'SHIP_PLAN'          
			AND A.YYYYMMDD			   >= @p_from_yyyymmdd
			AND A.YYYYMMDD			   <= @p_to_yyyymmdd		
			;

		
		
			/*SHIP_REQ Meausre 생성*/
			INSERT INTO #TMP_ROWDATA 
			SELECT A.DIVISION_ID
				, A.ITEM_ID
				, A.PLANT_SITE_ID	AS FROM_SITE
				, A.SCM_SITE_ID	AS TO_SITE	
				, 'SHIP_REQ'		AS MEASURE
				, A.YYYYMMDD
				, A.BOD_ID
				, A.QTY
				, A.INCOTERMS
				, A.TRANSPORT_MODE
				, A.FCST_TYPE
				, 2 AS SEQ
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
				, '-'  AS REMARK
			FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)

			LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
					ON   C.DIVISION_ID		   = A.DIVISION_ID                        
					AND  C.BOD_ID			   = A.BOD_ID
					AND  C.DIVISION_ID		   = @p_division_id
					--AND  C.BOD_TYPE			   = 'SALES'

			INNER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
				ON A.DIVISION_ID	 = T4.DIVISION_ID                                                           
				AND A.SCM_SITE_ID	 = T4.SCM_SITE_ID                                                              
				AND T4.VALID_YN	 = 'Y' 
			
			WHERE 1 = 1
			AND A.DIVISION_ID		 = @p_division_id 
			AND A.MEASURE			 = 'SHIP_REQ' 
			AND A.YYYYMMDD			 >= @p_from_yyyymmdd
			AND A.YYYYMMDD			 <= @p_to_yyyymmdd
			;
		

			/*SHIP_PLAN Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT SSP.DIVISION_ID
			, SSP.ITEM_ID
			, SSP.FROM_SITE
			, SSP.TO_SITE
			, 'SHIP_PLAN'            AS MEASURE
			, SSP.YYYYMMDD
			, BOD.BOD_ID
			, SSP.QTY
			, BOD.INCOTERMS          AS INCOTERMS
			, BOD.TRANSPORT_MODE     AS TR_MODE
			, SSP.FCST_TYPE
			, 3                      AS SEQ
			, '-' AS LAST_UPDATED_BY
			, SSP.LAST_UPDATE_DATE
			, '-'				AS REMARK
			FROM SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)

			INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
						FROM SCM_MST_ITEM_SN WITH (NOLOCK)
						WHERE DIVISION_ID		= @p_division_id
						AND SCP_OPERATION_GROUP  = 'A'  -- CELL/PACK 구분
						AND ACTIVE_FLAG		= 'Y'
					) IT 
				ON SSP.DIVISION_ID	= IT.DIVISION_ID 
				AND SSP.ITEM_ID	= IT.ITEM_ID

			INNER JOIN SCM_MST_SITE TS WITH (NOLOCK)     
				ON  SSP.DIVISION_ID = TS.DIVISION_ID
				AND SSP.TO_SITE     = TS.SCM_SITE_ID
				AND TS.VALID_YN     = 'Y'
				--AND TS.SITE_TYPE    = 'SALES'

			INNER JOIN SCP_MST_BOD_N_V BOD WITH(NOLOCK)
				ON  SSP.DIVISION_ID = BOD.DIVISION_ID
				AND SSP.BOD_ID      = BOD.BOD_ID
				
			WHERE SSP.DIVISION_ID	   = @p_division_id -- 변수
			  AND SSP.QTY			   >  0
			  AND SSP.YYYYMMDD		   >= @p_from_yyyymmdd
			  AND SSP.YYYYMMDD		   <= @p_to_yyyymmdd
			  AND SSP.CHANGE_TYPE	   = 'C'

			UNION ALL
			SELECT P.DIVISION_ID
				, P.ITEM_ID
				, P.PLANT_SITE_ID		AS FROM_SITE
				, P.SCM_SITE_ID		AS TO_SITE
				, 'SHIP_PLAN'			AS MEASURE
				, P.YYYYMMDD
				, P.BOD_ID
				, P.QTY
				, P.INCOTERMS
				, P.TRANSPORT_MODE
				, P.FCST_TYPE
				, 3					AS SEQ
				, '-'				AS LAST_UPDATED_BY
				, P.LAST_UPDATE_DATE
				,   '-'				AS REMARK
			FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK)

			INNER JOIN SCM_MST_SITE FZ WITH(NOLOCK) 
			ON P.DIVISION_ID		= FZ.DIVISION_ID 
				AND P.PLANT_SITE_ID = FZ.SCM_SITE_ID 
				AND FZ.VALID_YN	= 'Y'
		
			INNER JOIN SCM_MST_SITE T4 WITH(NOLOCK) 
			ON P.DIVISION_ID		= T4.DIVISION_ID 
				AND P.SCM_SITE_ID   = T4.SCM_SITE_ID 
				AND FZ.VALID_YN	= 'Y'
				--AND T4.SITE_TYPE    = 'SALES'

			WHERE 1=1 --P.YYYYMMDD		>= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함
			AND P.YYYYMMDD			   >= @p_from_yyyymmdd
			AND P.YYYYMMDD			   <= @p_to_yyyymmdd		
			;

			/*POSTP_PLAN Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT P.DIVISION_ID				AS DIVISION_ID
				, P.CELL_ITEM_ID				AS ITEM_ID 
				, P.SCM_SITE_ID				AS FROM_SITE
				, '-'						AS TO_SITE
				, 'POSTP_PLAN'					AS MEASURE
				, P.PLAN_DATE					AS YYYYMMDD
				, '-'						AS BOD_ID    
				, P.PLAN_QTY                  AS QTY 
				, '-'						AS INCOTERMS
				, '-'						AS TRANSPORT_MODE
				, '-'						AS FCST_TYPE
				, 4							AS SEQ
				, NULL						AS LAST_UPDATED_BY
				, NULL						AS LAST_UPDATE_DATE	
				, '-'						AS REMARK
			FROM SSP_FORMATION_POST_CELL_V P WITH(NOLOCK)  
			
			JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @p_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @p_company_id1
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.SCM_SITE_ID

			WHERE P.DIVISION_ID   = @p_division_id
			AND   P.PLAN_DATE    >= @p_from_yyyymmdd 
			AND   P.PLAN_DATE    <  @p_to_yyyymmdd
			AND (( @p_item_id  IS NULL OR @p_item_id ='')   OR P.CELL_ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 
		
			--GROUP BY P.DIVISION_ID
			--,        P.CELL_ITEM_ID
			--,        P.SCM_SITE_ID
			--,        P.PLAN_DATE

			--/*POSTP_PLAN Meausre 생성*/
			--INSERT INTO #TMP_ROWDATA
			--SELECT  P.DIVISION_ID				AS DIVISION_ID
			--	, P.ITEM_ID					AS ITEM_ID 
			--	, P.FROM_SITE					AS FROM_SITE
			--	, '-'						AS TO_SITE
			--	, 'POSTP_PLAN'					AS MEASURE
			--	, P.YYYYMMDD					AS YYYYMMDD
			--	, '-'						AS BOD_ID    
			--	, P.QTY						AS QTY 
			--	, '-'						AS INCOTERMS
			--	, '-'						AS TRANSPORT_MODE
			--	, '-'						AS FCST_TYPE
			--	, 4							AS SEQ
			--	, NULL						AS LAST_UPDATED_BY
			--	, NULL						AS LAST_UPDATE_DATE	
			--	, '-'						AS REMARK
			-- FROM SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK)

			--INNER JOIN SCM_MST_SITE FS
			--   ON P.DIVISION_ID		= FS.DIVISION_ID
			--  AND P.FROM_SITE        = FS.SCM_SITE_ID
			--  AND FS.SITE_TYPE       = 'SALSE'
			--  AND FS.OPERATION_GROUP = 'A'
			--  AND FS.OSP_YN          = 'N'
			--  AND FS.VALID_YN        = 'Y'

			--WHERE 1 = 1
			--  AND P.PLAN_START_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE() , 112) -- 당일(현재는 현재일 -1)
			--  AND P.MEASURE		= 'POSTP_PLAN'
			--  AND P.DIVISION_ID      = @p_division_id
			--  AND P.YYYYMMDD         >= @p_from_yyyymmdd
			--  AND P.YYYYMMDD         <= @p_to_yyyymmdd
			--  AND (( @p_item_id		  IS NULL OR @p_item_id ='')		OR P.ITEM_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 
			--  AND (( @p_plant_site_id  IS NULL OR @p_plant_site_id ='')   OR P.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))   		
			--  AND P.qty            >  0
			--  AND P.DIVISION_ID    = '40' -- 소형(40) 인 경우만 조회




			/*SITE_MOVE Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT SSP.DIVISION_ID
				, SSP.ITEM_ID
				, SSP.FROM_SITE    AS FROM_SITE
				, '-'		    AS TO_SITE
				, 'SITE_MOVE'      AS MEASURE
				, SSP.YYYYMMDD
				, ''			    AS BOD_ID
				, SSP.QTY
				, ''			    AS INCOTERMS
				, ''			    AS TRANSPORT_MODE
				, ''			    AS FCST_TYPE
				, 5                AS SEQ
				, NULL		    AS LAST_UPDATED_BY
				, NULL		    AS LAST_UPDATE_DATE	
				, '-'		    AS REMARK
			FROM  SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)

			INNER JOIN SCM_MST_SITE TS	WITH(NOLOCK)
			ON  SSP.DIVISION_ID		= TS.DIVISION_ID
				AND SSP.TO_SITE     = TS.SCM_SITE_ID
				AND TS.SITE_TYPE    = 'PLANT'  
				AND TS.VALID_YN     = 'Y'
				  
			INNER JOIN SCM_MST_SITE FS	WITH(NOLOCK)
			ON  SSP.DIVISION_ID		= FS.DIVISION_ID
				AND SSP.FROM_SITE   = FS.SCM_SITE_ID 
				AND FS.VALID_YN     = 'Y'

			WHERE  1=1
			AND TS.PLANT_ID	<> FS.PLANT_ID
			AND SSP.DIVISION_ID  = @p_division_id
			AND SSP.QTY          >  0
			AND SSP.YYYYMMDD    >= @p_from_yyyymmdd
			AND SSP.YYYYMMDD    <= @p_to_yyyymmdd
			AND SSP.BIZ_TYPE	 = 'A'
			AND SSP.CHANGE_TYPE  = 'C'
			AND (( @p_item_id  IS NULL OR @p_item_id ='')   OR SSP.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 

			UNION ALL

			SELECT R.DIVISION_ID
				, R.ITEM_ID
				, R.PLANT_SITE_ID		AS FROM_SITE
				, '-'                    AS TO_SITE
				, 'SITE_MOVE'            AS MEASURE
				, R.YYYYMMDD
				, ''                     AS BOD_ID
				, R.QTY
				, ''                     AS INCOTERMS
				, ''                     AS TRANSPORT_MODE
				, ''					AS FCST_TYPE
				, 5					AS SEQ
				, NULL				AS LAST_UPDATED_BY
				, NULL				AS LAST_UPDATE_DATE
				, '-'				AS REMARK
			FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)

			INNER JOIN SCM_MST_SITE FS	WITH(NOLOCK)
				ON  FS.DIVISION_ID	   = R.DIVISION_ID       
				AND FS.SCM_SITE_ID	   = R.PLANT_SITE_ID	   
				AND FS.SITE_TYPE       = 'PLANT'  
				AND FS.OPERATION_GROUP = 'A'
				AND FS.OSP_YN          = 'N'
				AND FS.VALID_YN        = 'Y'	  
				
			INNER JOIN SCM_MST_SITE TS	WITH(NOLOCK)
				ON  TS.DIVISION_ID	   = R.DIVISION_ID
				AND TS.SCM_SITE_ID	   = R.SCM_SITE_ID
				AND TS.SITE_TYPE	   = 'PLANT'  
				AND TS.VALID_YN	   = 'Y'

			WHERE  1=1
			AND R.DIVISION_ID		   = @p_division_id
			AND R.MEASURE			   = 'SHIP_REQ' 
			AND R.YYYYMMDD			   >= @p_from_yyyymmdd
			AND R.YYYYMMDD			   <= @p_to_yyyymmdd
			AND TS.plant_id		   <> FS.plant_id
			AND R.QTY				   >  0
			--AND R.YYYYMMDD			   >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), GETDATE()), 112)	
			AND (( @p_item_id		   IS NULL OR @p_item_id ='')   OR R.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 


			/*CUST_MOVE Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT SSP.DIVISION_ID
				, SSP.ITEM_ID
				, SSP.FROM_SITE    AS FROM_SITE
				, '-'			   AS TO_SITE
				, 'CUST_MOVE'      AS MEASURE
				, SSP.YYYYMMDD
				, ''			    AS BOD_ID
				, SSP.QTY
				, ''			    AS INCOTERMS
				, ''			    AS TRANSPORT_MODE
				, ''			    AS FCST_TYPE
				, 5                 AS SEQ
				, NULL		        AS LAST_UPDATED_BY
				, NULL		        AS LAST_UPDATE_DATE	
				, '-'		        AS REMARK
			FROM  SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)

			INNER JOIN SCM_MST_SITE TS	WITH(NOLOCK)
			ON  SSP.DIVISION_ID		= TS.DIVISION_ID
				AND SSP.TO_SITE     = TS.SCM_SITE_ID
				AND TS.SITE_TYPE    = 'SALES'  
				AND TS.VALID_YN     = 'Y'
				  
			INNER JOIN SCM_MST_SITE FS	WITH(NOLOCK)
			ON  SSP.DIVISION_ID		= FS.DIVISION_ID
				AND SSP.FROM_SITE   = FS.SCM_SITE_ID 
				AND FS.VALID_YN     = 'Y'

			WHERE  1=1
			AND TS.PLANT_ID	<> FS.PLANT_ID
			AND SSP.DIVISION_ID  = @p_division_id
			AND SSP.QTY          >  0
			AND SSP.YYYYMMDD    >= @p_from_yyyymmdd
			AND SSP.YYYYMMDD    <= @p_to_yyyymmdd
			AND SSP.BIZ_TYPE	 = 'A'
			AND SSP.CHANGE_TYPE  = 'C'
			AND (( @p_item_id  IS NULL OR @p_item_id ='')   OR SSP.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 

			UNION ALL

			SELECT R.DIVISION_ID
				, R.ITEM_ID
				, R.PLANT_SITE_ID		AS FROM_SITE
				, '-'                    AS TO_SITE
				, 'CUST_MOVE'            AS MEASURE
				, R.YYYYMMDD
				, ''                     AS BOD_ID
				, R.QTY
				, ''                     AS INCOTERMS
				, ''                     AS TRANSPORT_MODE
				, ''					AS FCST_TYPE
				, 5					AS SEQ
				, NULL				AS LAST_UPDATED_BY
				, NULL				AS LAST_UPDATE_DATE
				, '-'				AS REMARK
			FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)

			INNER JOIN SCM_MST_SITE FS	WITH(NOLOCK)
				ON  FS.DIVISION_ID	   = R.DIVISION_ID       
				AND FS.SCM_SITE_ID	   = R.PLANT_SITE_ID	   
				AND FS.SITE_TYPE       = 'PLANT'  
				AND FS.OPERATION_GROUP = 'A'
				AND FS.OSP_YN          = 'N'
				AND FS.VALID_YN        = 'Y'	  
				
			INNER JOIN SCM_MST_SITE TS	WITH(NOLOCK)
				ON  TS.DIVISION_ID	   = R.DIVISION_ID
				AND TS.SCM_SITE_ID	   = R.SCM_SITE_ID
				AND TS.SITE_TYPE	   = 'SALES'  
				AND TS.VALID_YN	   = 'Y'

			WHERE  1=1
			AND R.DIVISION_ID		   = @p_division_id
			AND R.MEASURE			   = 'SHIP_REQ' 
			AND R.YYYYMMDD			   >= @p_from_yyyymmdd
			AND R.YYYYMMDD			   <= @p_to_yyyymmdd
			--AND TS.plant_id		   <> FS.plant_id
			AND R.QTY				   >  0
			--AND R.YYYYMMDD			   >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), GETDATE()), 112)	
			AND (( @p_item_id		   IS NULL OR @p_item_id ='')   OR R.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 

			INSERT INTO #TMP_ROWDATA
			/*WH_IN Meausre 생성*/
			SELECT T. DIVISION_ID  	     
				, T.ITEM_ID    
				, T.FROM_SITE	         
				, T.TO_SITE	         
				, 'WH_IN' AS MEASURE	         
				, T.YYYYMMDD	         
				, T.BOD_ID	 
				, T.QTY	 
				, T.INCOTERMS         
				, T.TRANSPORT_MODE    
				, T.FCST_TYPE	       
				, 6 AS SEQ 
				, NULL						AS LAST_UPDATED_BY
				, NULL						AS LAST_UPDATE_DATE
				, '-'						AS REMARK
			FROM SSP_ANL_SHIP_PLAN_40 T  WITH (NOLOCK)  
			INNER JOIN #TblDynamic_SSP0026_40_STD ST
				ON ST.DIVISION_ID = T.DIVISION_ID
			   AND ST.FROM_SITE   = T.FROM_SITE
			   AND ST.PLAN_START_YYYYMMDD = T.PLAN_START_YYYYMMDD

			WHERE T.DIVISION_ID = @p_division_id
			  AND T.MEASURE ='WH_IN'
			
			  AND T.YYYYMMDD		   >= @p_from_yyyymmdd
			  AND T.YYYYMMDD		   <= @p_to_yyyymmdd
			  AND T.BIZ_TYPE		    = 'A'

			/*TOTAL_PLAN Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT DIVISION_ID
				, ITEM_ID
				, FROM_SITE      AS FROM_SITE
				, '-'            AS TO_SITE
				, 'TOTAL_PLAN'   AS MEASURE
				, YYYYMMDD
				, ''             AS BOD_ID
				, SUM(QTY)	  AS QTY
				, ''             AS INCOTERMS
				, ''             AS TRANSPORT_MODE
				, ''             AS FCST_TYPE	
				, 7			  AS SEQ
				, NULL		  AS LAST_UPDATED_BY
				, NULL		  AS LAST_UPDATE_DATE
				, '-'		  AS REMARK
			FROM (
					SELECT SSP.DIVISION_ID
						, SSP.FROM_SITE
						, SSP.ITEM_ID
						, SSP.YYYYMMDD
						, SSP.QTY
						FROM SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)
					 
						INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
									FROM SCM_MST_ITEM_SN WITH (NOLOCK)
								WHERE DIVISION_ID		 = @p_division_id
									AND SCP_OPERATION_GROUP = 'A'  -- CELL/PACK 구분
									AND ACTIVE_FLAG		 = 'Y'
		  				) IT 
						ON SSP.DIVISION_ID	= IT.DIVISION_ID 
						AND SSP.ITEM_ID	= IT.ITEM_ID

					WHERE SSP.DIVISION_ID  = @p_division_id
						AND SSP.YYYYMMDD    >= @p_from_yyyymmdd
						AND SSP.YYYYMMDD    <= @p_to_yyyymmdd
						AND SSP.CHANGE_TYPE  = 'C'
						AND SSP.QTY          >  0
			
					UNION ALL

					SELECT P.DIVISION_ID
						, P.PLANT_SITE_ID	AS FROM_SITE
						, P.ITEM_ID	
						, P.YYYYMMDD
						, P.QTY
					FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK)
				
					LEFT OUTER JOIN SCM_MST_SITE FZ WITH(NOLOCK) 
	     				ON P.DIVISION_ID	 = FZ.DIVISION_ID 
	     				AND P.PLANT_SITE_ID  = FZ.SCM_SITE_ID 
	     				AND FZ.VALID_YN	 = 'Y'

					WHERE P.DIVISION_ID = @p_division_id 
						--AND P.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함
						AND P.YYYYMMDD			   >= @p_from_yyyymmdd
						AND P.YYYYMMDD			   <= @p_to_yyyymmdd		
			
			) A 
			GROUP BY A.DIVISION_ID
				, A.ITEM_ID
				, A.YYYYMMDD
				, A.FROM_SITE

		
			/*TOTAL_REQ Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT DIVISION_ID
				, ITEM_ID
				, FROM_SITE		AS FROM_SITE
				, '-'			AS TO_SITE
				, 'TOTAL_REQ'		AS MEASURE
				, YYYYMMDD
				, ''				AS BOD_ID
				, SUM(QTY)		AS QTY
				, ''				AS INCOTERMS
				, ''				AS TRANSPORT_MODE
				, ''				AS FCST_TYPE	
				, 8				AS SEQ
				, NULL			AS LAST_UPDATED_BY
				, NULL			AS LAST_UPDATE_DATE
				, '-'			AS REMARK
			FROM (
					SELECT P.DIVISION_ID
						, P.PLANT_SITE_ID	AS FROM_SITE
						, P.ITEM_ID
						, P.YYYYMMDD
						, P.QTY
					FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK)

					INNER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
	     			ON P.DIVISION_ID = TS.DIVISION_ID 
	     				AND P.SCM_SITE_ID = TS.SCM_SITE_ID 
	     				AND TS.VALID_YN = 'Y'
						--AND P.SITE_TYPE    = 'SALES'

					WHERE P.DIVISION_ID = @p_division_id 
					AND P.YYYYMMDD		>= @p_from_yyyymmdd --@v_last_plan_start_yyyymmdd
					AND P.YYYYMMDD		<= @p_to_yyyymmdd
			) A 
			GROUP BY A.DIVISION_ID
				, A.ITEM_ID
				, A.YYYYMMDD
				, A.FROM_SITE

			/*WH_BOH_PLAN Meausre 생성*/
			INSERT INTO #TMP_ROWDATA
			SELECT A.DIVISION_ID
				, A.ITEM_ID		AS ITEM_ID
				, A.FROM_SITE       AS FROM_SITE
				, '-'			AS TO_SITE
				, 'WH_BOH_PLAN'	AS MEASURE
				, A.YYYYMMDD
				, ''				AS BOD_ID
				, SUM(CASE WHEN C.MEASURE = 'TOTAL_PLAN' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0  -- @p_from_yyyymmdd
										   --WHEN C.MEASURE = 'TOTAL_PLAN' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,21,GETDATE()),112) THEN -1 * ISNULL(C.QTY,0)  -- @p_from_yyyymmdd
								     --        WHEN C.MEASURE <> 'TOTAL_PLAN' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0
										   --WHEN C.MEASURE <> 'TOTAL_PLAN' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0)
									ELSE 0 END) + ISNULL(A.STOCK_QTY, 0) AS QTY
				--, ISNULL(A.STOCK_QTY, 0) AS QTY
				, ''				AS INCOTERMS
				, ''				AS TRANSPORT_MODE
				, ''				AS FCST_TYPE	
				, 9				AS SEQ
				, NULL			AS LAST_UPDATED_BY
				, NULL			AS LAST_UPDATE_DATE
				, '-'			AS REMARK
			FROM (
					SELECT A.DIVISION_ID
						, A.FROM_SITE			AS FROM_SITE
						, A.ITEM_ID			AS ITEM_ID
						, A.YYYYMMDD			AS YYYYMMDD
						, SUM(ISNULL(A.QTY, 0))  AS STOCK_QTY
					FROM SSP_ANL_SHIP_PLAN_40 A (NOLOCK)
					INNER JOIN #TblDynamic_SSP0026_40_STD ST
						ON ST.DIVISION_ID = A.DIVISION_ID
					   AND ST.FROM_SITE   = A.FROM_SITE
					   AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
				
					WHERE  1 = 1
					AND	A.DIVISION_ID			= @p_division_id
					AND	A.BIZ_TYPE			= 'A'   
					AND	A.MEASURE				= 'WH_STOCK'
					AND	A.YYYYMMDD			>= @p_from_yyyymmdd --@v_last_plan_start_yyyymmdd
					AND	A.YYYYMMDD			<= @p_to_yyyymmdd
				
					GROUP BY A.DIVISION_ID
						, A.FROM_SITE
						, A.ITEM_ID
						, A.YYYYMMDD
			) A
			LEFT OUTER JOIN (
							SELECT A.DIVISION_ID
									, A.ITEM_ID AS ITEM_ID
									, A.FROM_SITE
									, A.YYYYMMDD
									, A.MEASURE
									, A.QTY
							FROM   #TMP_ROWDATA  A WITH(NOLOCK)
							WHERE  1 = 1
							AND    A.DIVISION_ID = @p_division_id
							AND    A.MEASURE   IN ('TOTAL_PLAN')
							AND    A.YYYYMMDD >= @v_last_plan_start_yyyymmdd
							AND    A.YYYYMMDD <= @p_to_yyyymmdd
							
							) C
				ON   C.DIVISION_ID = A.DIVISION_ID 
				AND  C.ITEM_ID    = A.ITEM_ID 
				AND  C.YYYYMMDD   <= A.YYYYMMDD 
				AND  C.FROM_SITE   = A.FROM_SITE
			WHERE  1 = 1
			GROUP BY A.DIVISION_ID
				, A.ITEM_ID
				, A.FROM_SITE
				, A.YYYYMMDD
				, A.STOCK_QTY
			;

			--/*WH_BOH_REQ Meausre 생성*/
			--INSERT INTO #TMP_ROWDATA
			--SELECT A.DIVISION_ID
			--	, A.ITEM_ID		AS ITEM_ID
			--	, A.FROM_SITE		AS FROM_SITE
			--	, '-'			AS TO_SITE
			--	, 'WH_BOH_REQ'		AS MEASURE
			--	, A.YYYYMMDD
			--	, ''				AS BOD_ID
			--	, SUM(CASE WHEN C.MEASURE = 'TOTAL_REQ'  AND C.YYYYMMDD =  CONVERT(NVARCHAR(8), GETDATE()-1,	112) THEN 0  
			--			 WHEN C.MEASURE = 'TOTAL_REQ'  AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,21,GETDATE()),112) THEN -1 * ISNULL(C.QTY,0)  
			--			 WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD =  CONVERT(NVARCHAR(8), GETDATE()-1,	112) THEN 0
			--			 WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(),	112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0) ELSE 0 END) 
			--	  + ISNULL(A.STOCK_QTY, 0) AS QTY
			--	, ''				AS INCOTERMS
			--	, ''				AS TRANSPORT_MODE
			--	, ''				AS FCST_TYPE	
			--	, 10				AS SEQ
			--	, NULL			AS LAST_UPDATED_BY
			--	, NULL			AS LAST_UPDATE_DATE
			--	, '-'			AS REMARK
			--FROM (
			--	SELECT A.DIVISION_ID
			--		, A.FROM_SITE		AS FROM_SITE
			--		, A.ITEM_ID		AS ITEM_ID
			--		, A.YYYYMMDD		AS YYYYMMDD
			--		, SUM(ISNULL(A.QTY, 0))  AS STOCK_QTY
			--	FROM   SSP_ANL_SHIP_PLAN_40 A (NOLOCK)
			--	INNER JOIN #TblDynamic_SSP0026_40_STD ST
			--		ON ST.DIVISION_ID = A.DIVISION_ID
			--	   AND ST.FROM_SITE   = A.FROM_SITE
			--	   AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
			--	WHERE  1 = 1
			--	AND	A.DIVISION_ID			= @p_division_id
			--	AND	A.BIZ_TYPE			= 'A'   
			--	AND	A.MEASURE				= 'WH_STOCK'
			--	AND	A.YYYYMMDD			>= @v_last_plan_start_yyyymmdd
			--	AND	A.YYYYMMDD			<= @p_to_yyyymmdd
			--	AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
			--	AND (( @p_plant_site_id	IS NULL OR @p_plant_site_id ='')   OR A.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))   		

				
			--	GROUP BY A.DIVISION_ID
			--		, A.FROM_SITE
			--		, A.ITEM_ID
			--		, A.YYYYMMDD
			--) A
			--LEFT OUTER JOIN (
			--				SELECT A.DIVISION_ID
			--					, A.ITEM_ID	AS ITEM_ID
			--					, A.FROM_SITE
			--					, A.YYYYMMDD
			--					, A.MEASURE
			--					, A.QTY
			--				FROM   #TMP_ROWDATA  A WITH(NOLOCK)
			--				WHERE  1 = 1
			--				AND    A.DIVISION_ID = @p_division_id
			--				AND    A.YYYYMMDD	>= @v_last_plan_start_yyyymmdd
			--				AND    A.YYYYMMDD	<= @p_to_yyyymmdd
			--				AND    A.MEASURE	IN ('TOTAL_REQ')
			--) C
			--ON   C.DIVISION_ID		= A.DIVISION_ID 
			--	AND  C.ITEM_ID		= A.ITEM_ID 
			--	AND  C.YYYYMMDD		<= A.YYYYMMDD 
			--	AND  C.FROM_SITE	= A.FROM_SITE
			--WHERE  1 = 1
			--GROUP BY A.DIVISION_ID
			--	, A.ITEM_ID
			--	, A.FROM_SITE
			--	, A.YYYYMMDD
			--	, A.STOCK_QTY
			--;
		WITH Z AS (
			SELECT DISTINCT DIVISION_ID
						,ITEM_ID
						,FROM_SITE
						,o.basis_yyyymmdd AS YYYYMMDD
				FROM scm_sys_calendar_m o WITH(NOLOCK) 
				CROSS APPLY (  SELECT DISTINCT DIVISION_ID
										,ITEM_ID
										,FROM_SITE
								FROM  #TMP_ROWDATA  WITH(NOLOCK) 
								)  R
				WHERE o.basis_yyyymmdd>=@v_last_plan_start_yyyymmdd
				AND o.basis_yyyymmdd<=@p_to_yyyymmdd
		),
		BOH AS (   
			SELECT A.DIVISION_ID
				, A.FROM_SITE			 AS FROM_SITE
				, A.ITEM_ID				 AS ITEM_ID
				, A.YYYYMMDD			 AS YYYYMMDD
				, SUM(ISNULL(A.QTY, 0))  AS QTY
			FROM SSP_ANL_SHIP_PLAN_40 A with(NOLOCK)
			INNER JOIN #TblDynamic_SSP0026_40_STD ST
				ON ST.DIVISION_ID = A.DIVISION_ID
			   AND ST.FROM_SITE   = A.FROM_SITE
			   AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
			WHERE  1 = 1
			AND	A.DIVISION_ID			= @p_division_id
			AND	A.BIZ_TYPE				= 'A'   
			AND	A.MEASURE				= 'WH_STOCK'
			AND A.YYYYMMDD				 = @v_last_plan_start_yyyymmdd
			AND (( @p_item_id		IS NULL OR @p_item_id ='')			OR A.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
			AND (( @p_plant_site_id	IS NULL OR @p_plant_site_id ='')    OR A.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))   		
			
			GROUP BY A.DIVISION_ID
				, A.FROM_SITE
				, A.ITEM_ID
				, A.YYYYMMDD
		)
		--/*WH_BOH_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT Z.DIVISION_ID
			, Z.ITEM_ID		AS ITEM_ID
			, Z.FROM_SITE		AS FROM_SITE
			, '-'			AS TO_SITE
			, 'WH_BOH_REQ'		AS MEASURE
			, Z.YYYYMMDD
			, ''				AS BOD_ID
			, SUM(CASE WHEN X.MEASURE = 'TOTAL_REQ' AND X.YYYYMMDD > @v_last_plan_start_yyyymmdd THEN -1 * ISNULL(X.QTY,0)
					   WHEN X.MEASURE <> 'TOTAL_REQ' AND X.YYYYMMDD < Z.YYYYMMDD THEN ISNULL(X.QTY, 0)
					ELSE 0 END) + ISNULL(BOH.QTY, 0) AS QTY
			, ''				AS INCOTERMS
			, ''				AS TRANSPORT_MODE
			, ''				AS FCST_TYPE	
			, 10				AS SEQ
			, NULL			AS LAST_UPDATED_BY
			, NULL			AS LAST_UPDATE_DATE
			, '-'			AS REMARK
		  FROM Z WITH(NOLOCK)
			LEFT OUTER JOIN BOH WITH(NOLOCK)
				ON Z.DIVISION_ID       = BOH.DIVISION_ID
				AND Z.ITEM_ID           = BOH.ITEM_ID
				AND Z.FROM_SITE			= BOH.FROM_SITE
			LEFT OUTER JOIN #TMP_ROWDATA X ON  X.DIVISION_ID = Z.DIVISION_ID AND X.ITEM_ID = Z.ITEM_ID AND X.YYYYMMDD <= Z.YYYYMMDD AND X.FROM_SITE = Z.FROM_SITE
				AND X.MEASURE IN ( 'TOTAL_REQ')
		GROUP BY Z.DIVISION_ID, Z.ITEM_ID, Z.YYYYMMDD,BOH.QTY, Z.FROM_SITE
		;

		INSERT INTO #Tmp_Raw_Result_Table
		(
			DIVISION_ID
			,ITEM_ID
			,FROM_SITE
			,TO_SITE
			,MEASURE
			,MEASURE_NAME
			,YYYYMMDD
			,BOD_ID
			,QTY
			,INCOTERMS
			,TRANSPORT_MODE
			,FCST_TYPE
			,SEQ
			,REQUESTOR			
		)
		SELECT DISTINCT 
			X.DIVISION_ID
			, X.ITEM_ID
			, X.FROM_SITE
			, X.TO_SITE AS TO_SITE
			, X.MEASURE
			, X.MEASURE_NAME
			, X.YYYYMMDD
			,'-' AS BOD_ID
			,ISNULL(R.QTY,0) AS QTY
			,'-' AS INCOTERMS
			,'-' AS TRANSPORT_MODE
			,'-' AS FCST_TYPE
			,X.SEQ
			,R.LAST_UPDATED_BY
		FROM  
		(
				SELECT DISTINCT T.DIVISION_ID 
				,     T.ITEM_ID
				,	 ISNULL(T.FROM_SITE,'-') AS FROM_SITE
				,	 ISNULL(T.TO_SITE,'-')	AS TO_SITE
				,	 T.BOD_ID
				,	 T.QTY
				,	 T.INCOTERMS
				,	 T.TRANSPORT_MODE
				,	 T.FCST_TYPE
				,     TT1.COLUMN_NAME		 AS MEASURE 
				,	 TT1.COLUMN_LABEL_NAME	 AS MEASURE_NAME																									
				,	 TT1.ATTRIBUTE3		 AS BACK_COLOR							
				,	 TT1.SORT_ORDER_NO		 AS SEQ
				,     T.YYYYMMDD				  
				FROM  #TMP_ROWDATA T
				
				INNER JOIN SCM_MST_SHEET_MEASURE TT1
				     ON TT1.PROGRAM_ID = @P_PROGRAM_ID
					AND TT1.SHEET_NAME = @P_SHEET_NAME	
				
				WHERE 1=1
		) X
		LEFT OUTER JOIN  #TMP_ROWDATA R  
			ON R.DIVISION_ID		= X.DIVISION_ID
			AND R.ITEM_ID			= X.ITEM_ID
			AND R.MEASURE			= X.MEASURE
			AND R.YYYYMMDD			= X.YYYYMMDD
			AND R.FROM_SITE			= X.FROM_SITE
			AND R.TO_SITE			= X.TO_SITE
		WHERE ( X.TO_SITE = '-'	AND  X.MEASURE IN (	'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','POSTP_PLAN', 'SITE_MOVE', 'CUST_MOVE','WH_IN') )
		--WHERE ( X.TO_SITE != '-'	AND  X.MEASURE IN (	'SCP_SHIP_PLAN','SHIP_REQ','SHIP_PLAN') )
		--  OR ( X.TO_SITE = '-'	AND  X.MEASURE IN (	'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','POSTP_PLAN', 'SITE_MOVE','WH_IN') )
			
		UNION ALL

		SELECT DISTINCT 
			  X.DIVISION_ID
			, X.ITEM_ID
			, X.FROM_SITE
			, X.TO_SITE 
			, X.MEASURE
			, X.MEASURE_NAME
			, X.YYYYMMDD
			,ISNULL(X.BOD_ID,'-')				AS BOD_ID
			,ISNULL(R.QTY,0)					AS QTY
			,ISNULL(X.INCOTERMS,'-')				AS INCOTERMS
			,ISNULL(X.TRANSPORT_MODE,'-')			AS TRANSPORT_MODE
			,ISNULL(X.FCST_TYPE,'-')				AS FCST_TYPE
			,X.SEQ
			,R.LAST_UPDATED_BY
		FROM  
		(
				SELECT DISTINCT T.DIVISION_ID 
				,      T.ITEM_ID
				,	 ISNULL(T.FROM_SITE,'-')		AS FROM_SITE
				,	 ISNULL(T.TO_SITE,'-')		AS TO_SITE
				,	 T.BOD_ID
				,	 T.QTY
				,	 T.INCOTERMS
				,	 T.TRANSPORT_MODE
				,	 T.FCST_TYPE
				,      TT1.COLUMN_NAME			AS MEASURE 
				,	 TT1.COLUMN_LABEL_NAME		AS MEASURE_NAME																									
				,	 TT1.ATTRIBUTE3			AS BACK_COLOR							
				,	 TT1.SORT_ORDER_NO			AS SEQ
				,      T.YYYYMMDD					  
				FROM  #TMP_ROWDATA T
				
				INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)                                                      
					ON T.DIVISION_ID	= TS.DIVISION_ID                                                           
					AND T.TO_SITE		= TS.SCM_SITE_ID                                                              
					AND TS.VALID_YN	= 'Y'
					--AND TS.SITE_TYPE	= 'SALES'
				
				LEFT JOIN SCM_MST_SHEET_MEASURE TT1 WITH(NOLOCK)
				     ON TT1.PROGRAM_ID	= @P_PROGRAM_ID
					AND TT1.SHEET_NAME	= @P_SHEET_NAME	
				
		) X
		LEFT OUTER JOIN  #TMP_ROWDATA R  
			ON R.DIVISION_ID		= X.DIVISION_ID
			AND R.ITEM_ID			= X.ITEM_ID
			AND R.MEASURE			= X.MEASURE
			AND R.YYYYMMDD			= X.YYYYMMDD
			AND R.FROM_SITE			= X.FROM_SITE
			AND R.TO_SITE			= X.TO_SITE
			AND R.BOD_ID			= X.BOD_ID
			AND R.FCST_TYPE			= X.FCST_TYPE
		WHERE ( X.TO_SITE != '-'	AND  X.MEASURE IN (	'SCP_SHIP_PLAN','SHIP_REQ','SHIP_PLAN'))

		--RETURN;

		--////////////////////////////////////////////////////////////////////////////////--
		--//5. PIVOT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--
		SELECT DISTINCT T0.DIVISION_ID
		,	  T0.ITEM_ID	
		,	  TEAM.DEPT_NAME_KO
		,	  TEAM.DEPT_ID
		,     [dbo].[FN_GET_SSP_PROJECT_OWNER](T0.DIVISION_ID, T0.TO_SITE, T0.ITEM_ID, NULL  ) AS MKT_USER  --T2.MKT_USER	
		--,     T2.MKT_USER	
		,	  T0.FROM_SITE
		,	  T0.TO_SITE
		,	  T4.SOLDTO_CUSTOMER
		,     T0.MEASURE
		,     T0.MEASURE_NAME
		,	  T0.BOD_ID
		--,	  'D_' + T0.YYYYMMDD						AS YYYYMMDD		
		,	  T0.YYYYMMDD						AS YYYYMMDD		
		,	  T1.BASIS_YYYYMM							AS YYYYMM
		,	  RIGHT(T1.BASIS_YYYYMM,4) + T1.ISO_WEEK		AS ISO_WEEK
		,	  T0.QTY AS QTY
		,	  T0.INCOTERMS
		,	  T0.TRANSPORT_MODE
		,	  T0.FCST_TYPE
		,	  T0.SEQ
		,	  T5.SHIP_FROZEN	AS CONFIRM_DAY
		,	  RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE,	T0.BOD_ID ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE  'Y' END  DESC
				) AS ROW_NUM
		,     T0.REQUESTOR
		INTO #TMP_RESULT_PIVOT_TABLE_TEMP
		FROM #Tmp_Raw_Result_Table T0

		-- MEASURE가 10개가 안돼면 화면에 Display 하지 않음
		INNER JOIN (SELECT AAA.ITEM_ID, AAA.FROM_SITE, COUNT(*) AS CNT 
		FROM (
				SELECT DISTINCT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE 
				FROM  #Tmp_Raw_Result_Table  
			) AAA
		GROUP BY AAA.ITEM_ID, AAA.FROM_SITE
		HAVING COUNT(*) >=10) MC
			ON T0.ITEM_ID    = MC.ITEM_ID
			AND T0.FROM_SITE = MC.FROM_SITE

		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
			ON T0.DIVISION_ID = T4.DIVISION_ID                                                           
			AND T0.TO_SITE = T4.SCM_SITE_ID                                                              
			AND T4.VALID_YN = 'Y' 
		
		LEFT OUTER JOIN SCM_MST_SITE T5 WITH(NOLOCK)                                                      
			ON T0.DIVISION_ID = T5.DIVISION_ID                                                           
			AND T0.FROM_SITE = T5.SCM_SITE_ID                                                              
			AND T5.VALID_YN = 'Y' 

		--LEFT OUTER JOIN  SCM_MST_SITE_ITEM T6 WITH(NOLOCK)		                                                 
		--	ON T6.DIVISION_ID = T0.DIVISION_ID                                                           
		--	AND T6.SCM_SITE_ID = T0.TO_SITE                                                              
		--	AND T6.ITEM_ID = T0.ITEM_ID
		--	AND OWNER IS NOT  NULL 
		
		LEFT OUTER JOIN ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER
							, RANK() OVER (PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID ORDER BY   A.PROJECT_CODE, A.OWNER DESC) AS RN
							FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
							WHERE A.DIVISION_ID= @p_division_id
							AND   OWNER IS NOT  NULL 
							--GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
						) T6     -- 해당 ITEM_ID MCCE121501A2  SCM_MST_SITE_ITEM PROJECT_CODE 두개 확인!                                                  
			ON T6.DIVISION_ID = T0.DIVISION_ID                                                           
			AND T6.SCM_SITE_ID = T0.TO_SITE                                                              
			AND T6.ITEM_ID = T0.ITEM_ID
			AND T6.RN = 1
		LEFT OUTER  JOIN SCM_SYS_CALENDAR_M T1  WITH(NOLOCK)
			ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD	

		--LEFT OUTER JOIN SSP_MKT_USER_V T2
		--	ON T2.DIVISION_ID = T0.DIVISION_ID
		--	AND T2.ITEM_ID = T0.ITEM_ID
		--	AND T2.TO_SITE = T0.TO_SITE

		LEFT  JOIN (																				
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 					
			FROM [SCM_MST_SSO_USER_INFO] AS B	WITH(NOLOCK)												
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C	WITH(NOLOCK)											
			ON B.DEPT_ID = C.DEPT_ID															
		) AS TEAM
		ON TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](T6.owner, ','))
		WHERE 1=1
		--AND T0.TO_SITE = 'High Power (Icon)_CN_SZX'
		;

		--SELECT * FROM #TMP_RESULT_PIVOT_TABLE_TEMP WHERE TO_sITE = 'High Power (Icon)_CN_SZX'



		SELECT DISTINCT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.TO_SITE
			, T0.DEPT_NAME_KO
			, T0.MKT_USER
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			--, CONVERT(VARCHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, '20201120', 121)), 112) AS CONFIRM_DAY
			, CONVERT(VARCHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, GETDATE(), 121)), 112) AS CONFIRM_DAY
			, T0.YYYYMMDD
			, T0.QTY
			, RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE,	T0.BOD_ID ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE  'Y' END  DESC
				) AS ROW_NUM
			, T0.REQUESTOR
		INTO #Tmp_Result_01
		FROM #TMP_RESULT_PIVOT_TABLE_TEMP T0
        WHERE T0.DIVISION_ID = @p_division_id
		AND  [dbo].[FN_GET_SSP_SITE_INFO](T0.DIVISION_ID,T0.FROM_SITE,'COMPANY_ID')   = @P_COMPANY_ID
		;
		--//TEST-01
		
		
		--SELECT * FROM #Tmp_Result_01 where measure = 'SHIP_REQ';
		--ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, SEQ
		--;
		--RETURN;

		WITH RESULT_DATA AS
		(
			SELECT
				DENSE_RANK() OVER(ORDER BY T0.CONFIRM_DAY) AS RN
				, T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.TO_SITE
				, T0.DEPT_NAME_KO
				, T0.MKT_USER
				, T0.ITEM_ID
				, T0.MEASURE
				, T0.MEASURE_NAME
				, T0.SEQ				
				, T0.YYYYMMDD
				, T0.QTY AS QTY
				, T0.REQUESTOR
			FROM #Tmp_Result_01 T0
			WHERE 1 = 1
			AND T0.YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, 21, CONVERT(VARCHAR, GETDATE(), 121)), 112)
			AND T0.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 25, CONVERT(VARCHAR, GETDATE(), 121)), 112)
			
			AND
				EXISTS 
				(
					SELECT 
						*
					FROM #Tmp_Result_01 B
					WHERE 1 = 1
					AND B.MEASURE IN ('SHIP_PLAN' ,  'SHIP_REQ')
					AND B.YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, 21, CONVERT(VARCHAR, GETDATE(), 121)), 112)
					AND B.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 25, CONVERT(VARCHAR, GETDATE(), 121)), 112)
					AND B.QTY > 0
					AND B.DIVISION_ID = T0.DIVISION_ID
					AND B.DIVISION_ID = @p_division_id
					AND B.FROM_SITE = T0.FROM_SITE
					AND B.ITEM_ID = T0.ITEM_ID
				)

			AND EXISTS 
				(
					SELECT 
						*
					FROM #Tmp_Result_01 B
					WHERE 1 = 1
					AND B.MEASURE = 'WH_BOH_PLAN'
					AND B.YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, 21, CONVERT(VARCHAR, GETDATE(), 121)), 112)
					AND B.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 25, CONVERT(VARCHAR, GETDATE(), 121)), 112)
					AND B.QTY < 0
					AND B.DIVISION_ID = T0.DIVISION_ID
					AND B.DIVISION_ID = @p_division_id
					AND B.FROM_SITE = T0.FROM_SITE
					AND B.ITEM_ID = T0.ITEM_ID
				)
			AND T0.DIVISION_ID = @p_division_id
		)
		SELECT			
			 T0.RN
			, T0.MAIL_RECEIVER
			, T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.TO_SITE
			, T0.DEPT_NAME_KO
			, T0.MKT_USER
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			--, T0.REQUESTOR
		INTO #Tmp_Result_02
		FROM 
		(
			
			SELECT 
			     DISTINCT 
				XX.RN
				--,'kimyh8848'  as MAIL_RECEIVER --XX.MAIL_RECEIVER      
				,XX.MAIL_RECEIVER      
				,XX.DIVISION_ID
				,XX.FROM_SITE
				,XX.TO_SITE
				,XX.DEPT_NAME_KO
				,XX.MKT_USER
				,XX.ITEM_ID
				,XX.MEASURE
				,XX.MEASURE_NAME
				,XX.SEQ
				,XX.YYYYMMDD
				,XX.QTY
            FROM (
					SELECT
						 X.RN
						, U.SEGMENT2            AS MAIL_RECEIVER
						, X.DIVISION_ID
						, X.FROM_SITE
						, X.TO_SITE
						, X.DEPT_NAME_KO
						, X.MKT_USER
						, X.ITEM_ID
						, X.MEASURE
						, X.MEASURE_NAME
						, X.SEQ
						, X.YYYYMMDD
						, X.QTY
					FROM RESULT_DATA X WITH(NOLOCK)
					JOIN 
					(
						SELECT	
							M.SEGMENT2,
							A.DIVISION_ID,
							A.FROM_SITE,
							A.TO_SITE,
							A.ITEM_ID
						FROM 
						(
							SELECT 
								DIVISION_ID,
								FROM_SITE,
								TO_SITE,
								ITEM_ID,
								MKT_USER
							FROM RESULT_DATA
							WHERE 1 = 1
							AND MEASURE IN ('SHIP_PLAN' ,  'SHIP_REQ')
						) A

						INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) 
						ON  M.LOOKUP_TYPE ='WARNING_MAIL_SEND_40'
						   AND  M.VALID_YN    ='Y'
						   AND  M.SEGMENT1    ='SSP'
						   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.FROM_SITE END
						   AND  M.SEGMENT4    = CASE WHEN M.SEGMENT4 = 'ALL' THEN 'ALL' ELSE A.TO_SITE END
						   AND  M.SEGMENT5    = CASE WHEN M.SEGMENT5 = 'ALL' THEN 'ALL' ELSE A.ITEM_ID END
						
						GROUP BY M.SEGMENT2, A.DIVISION_ID,	A.FROM_SITE, A.TO_SITE, A.ITEM_ID
						--GROUP BY A.DIVISION_ID,	A.FROM_SITE, A.ITEM_ID
					) U
					ON U.DIVISION_ID = X.DIVISION_ID AND U.FROM_SITE = X.FROM_SITE
						AND U.ITEM_ID = X.ITEM_ID
					GROUP BY X.RN
						, U.SEGMENT2
						, X.DIVISION_ID
						, X.FROM_SITE
						, X.TO_SITE
						, X.DEPT_NAME_KO
						, X.MKT_USER
						, X.ITEM_ID
						, X.MEASURE
						, X.MEASURE_NAME
						, X.SEQ
						, X.YYYYMMDD
						, X.QTY

					UNION ALL
					--MKT OWNER (DIVISION_ID, ITEM_ID, TO_SITE)
					SELECT 
						 X.RN
						, U.MKT_USER             AS MAIL_RECEIVER
						, X.DIVISION_ID
						, X.FROM_SITE
						, X.TO_SITE
						, X.DEPT_NAME_KO
						, X.MKT_USER
						, X.ITEM_ID
						, X.MEASURE
						, X.MEASURE_NAME
						, X.SEQ
						, X.YYYYMMDD
						, X.QTY
					FROM  RESULT_DATA X WITH(NOLOCK) 
					JOIN 
					(
						SELECT	
							B.MKT_USER,
							A.DIVISION_ID,
							A.FROM_SITE,
							A.ITEM_ID
						FROM 
						(
							SELECT 
								DIVISION_ID,
								FROM_SITE,
								TO_SITE,
								ITEM_ID,
								MKT_USER
							FROM RESULT_DATA
							WHERE 1 = 1
							AND MEASURE IN ('SHIP_PLAN' ,  'SHIP_REQ')
						) A

						INNER JOIN SSP_MKT_USER_V B WITH(NOLOCK) 
						   ON B.DIVISION_ID   = A.DIVISION_ID  
						  AND B.TO_SITE       = A.TO_SITE 
						  AND B.ITEM_ID       = A.ITEM_ID 
						  AND B.MKT_USER	  = A.MKT_USER
						GROUP BY B.MKT_USER, A.DIVISION_ID,	A.FROM_SITE, A.ITEM_ID

					) U
					ON U.DIVISION_ID = X.DIVISION_ID AND U.FROM_SITE = X.FROM_SITE
						AND U.ITEM_ID = X.ITEM_ID

					GROUP BY X.RN
						, U.MKT_USER
						, X.DIVISION_ID
						, X.FROM_SITE
						, X.TO_SITE
						, X.DEPT_NAME_KO
						, X.MKT_USER
						, X.ITEM_ID
						, X.MEASURE
						, X.MEASURE_NAME
						, X.SEQ
						, X.YYYYMMDD
						, X.QTY
					
					UNION ALL
					--REQUESTOR
					SELECT 
						 X.RN
						, P.REQUESTOR            AS MAIL_RECEIVER
						, X.DIVISION_ID          AS DIVISION_ID
						, X.FROM_SITE            AS FROM_SITE 
						, X.TO_SITE				 AS TO_SITE 
						, X.DEPT_NAME_KO
						, X.MKT_USER
						, X.ITEM_ID              AS ITEM_ID
						, X.MEASURE
						, X.MEASURE_NAME
						, X.SEQ
						, X.YYYYMMDD
						, X.QTY
						--, X.REQUESTOR
					FROM RESULT_DATA X WITH(NOLOCK)
					JOIN 
					(
						SELECT
							REQUESTOR,
							DIVISION_ID,
							FROM_SITE,
							TO_SITE,
							DEPT_NAME_KO,
							MKT_USER,
							ITEM_ID
						FROM RESULT_DATA A
						WHERE 1 = 1
						AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
						AND REQUESTOR IS NOT NULL
						GROUP BY REQUESTOR, DIVISION_ID, FROM_SITE, TO_SITE, DEPT_NAME_KO, MKT_USER, ITEM_ID
					) P
					ON P.DIVISION_ID = X.DIVISION_ID AND P.FROM_SITE = X.FROM_SITE
						AND P.ITEM_ID = X.ITEM_ID
					INNER JOIN TB_FX_User U WITH(NOLOCK)
						ON P.REQUESTOR = U.UserID AND U.UseYN = 'Y'
					WHERE 1 = 1
			) XX
		) T0
		WHERE 1 = 1
		--AND T0.MAIL_RECEIVER IN ('kimyh8848')
		GROUP BY 
			T0.RN
			, T0.MAIL_RECEIVER
			, T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.TO_SITE
			, T0.DEPT_NAME_KO
			, T0.MKT_USER
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, T0.YYYYMMDD
		ORDER BY T0.YYYYMMDD, SEQ
		;
		
		SET @v_fromsite_tmpcnt = 0;

		SELECT @v_fromsite_cnt = MAX(RN) FROM #Tmp_Result_02;

		--//TEST-02
		--SELECT * FROM #Tmp_Result_02;
		--RETURN;

		WHILE @v_fromsite_tmpcnt < @v_fromsite_cnt			--FROM_SITE LOOP
		BEGIN
		
			DELETE FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
		
			SET @v_fromsite_tmpcnt = @v_fromsite_tmpcnt + 1;
		
			SET @v_site_from_yyyymmdd = '';
			SET @v_site_to_yyyymmdd = '';
			--FROM_YYYYMMDD. TO_YYYYMMDD 구하기
			SELECT 
				@v_site_from_yyyymmdd = MIN(YYYYMMDD), @v_site_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 4, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112)				
				--@v_site_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 21, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112), @v_site_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 25, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112)
			FROM #Tmp_Result_02
			WHERE 1 = 1
			AND RN = @v_fromsite_tmpcnt
			;
			/********************************************************************************
			* PIVOIT처리
			********************************************************************************/		
			BEGIN
				DECLARE @mQuery NVARCHAR(MAX);
				DECLARE @mEXEC NVARCHAR(MAX);

					-- PIVOIT 대상 날짜문자열 생성
				SET @mQuery = '';
				SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
				FROM (
					SELECT *
					FROM(
						SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
								,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
							FROM [dbo].[scm_sys_calendar_m] a with(nolock)
							WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
							--WHERE a.basis_yyyymmdd  BETWEEN '20210108' AND '20210111'
						GROUP BY a.basis_yyyymm, a.month_name	
						UNION ALL
						SELECT a.basis_yyyymmdd   AS yyyymmdd      
								, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
							FROM [dbo].[scm_sys_calendar_m] a with(nolock)
							WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
							--WHERE a.basis_yyyymmdd  BETWEEN '20210108' AND '20210111'
						GROUP BY a.basis_yyyymmdd		
					) A WHERE yyyymmdd NOT LIKE 'M_%'
				  	
				) AS A
				ORDER BY sort_order_no  ;

				IF( LEN(@mQuery)>0)
				BEGIN
					SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);
				END;
			
				SET @mEXEC = '';
				SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			RN AS SITE_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER) AS REC_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id) AS ITEM_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER, ITEM_ID, from_site_description ORDER BY to_site_description) AS MEASURE_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,MAIL_RECEIVER ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,division_id ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,COMPANY_ID ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,from_site_description		' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,to_site_description		' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DEPT_NAME_KO		' +CHAR(10);
				--SET @mEXEC = @mEXEC+' 			,[dbo].[FN_GET_SSP_MKT_OWNER_NAME](MKT_USER, '','', ''ko'') AS MKT_USER    		' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,MKT_USER		' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,item_id	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,[dbo].[FN_GET_ITEM_NICKNAME](division_id, item_id) AS NICK_NAME	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,MEASURE AS MEASURE	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,MEASURE_NAME AS MEASURE_NAME	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,seq	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
				SET @mEXEC = @mEXEC+'       FROM ' +CHAR(10);
				SET @mEXEC = @mEXEC+'       ( ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			SELECT  ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				RN, MAIL_RECEIVER, division_id, ''' + @p_company_id + ''' AS COMPANY_ID, ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description,  ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				isnull(dbo.fn_get_scm_site_description(division_id, to_site ),''-'') AS to_site_description,  ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				DEPT_NAME_KO, MKT_USER, ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				item_id, MEASURE, MEASURE_NAME, seq, yyyymmdd, CEILING(qty) AS QTY ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			FROM #Tmp_Result_02 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			WHERE 1 = 1 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			AND RN = ''' + CONVERT(NVARCHAR(MAX), @v_fromsite_tmpcnt) + ''' '+CHAR(10);
			--	SET @mEXEC = @mEXEC+'			AND MAIL_RECEIVER = ''kimkwanghee'' '+CHAR(10);
				SET @mEXEC = @mEXEC+'		) T0 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
				SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
				SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
				SET @mEXEC = @mEXEC+'	   ORDER BY RN, DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER), item_id, DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id), from_site_description, to_site_description desc , seq' +CHAR(10);
			END

			INSERT INTO #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
			EXEC (@mEXEC);

			SET @v_receiver_tmpcnt = 0;
			
			SELECT 
				@v_receiver_cnt = MAX(REC_SEQ)
			FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
			WHERE 1 = 1
			AND SITE_SEQ = @v_fromsite_tmpcnt;

			--SELECT * FROM #Tmp_Result_01;

			--select * from #TMP_Tbl_SSP_MAIL_SEND_BATCH_N ;

			
			--SET @v_log_type = 'END';
			--SET @v_log_message = '########## END of procedure ##########';
			--SET @v_description = '';
			--SET @d_event_date = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--return;



			WHILE @v_receiver_tmpcnt < @v_receiver_cnt
			BEGIN
				--PRINT 'TEST'
				/********************************************************************************
				* HEAD CONT 
				********************************************************************************/
				SET @v_head_cont = '';
				SET @v_head_cont = @v_head_cont+ '<tr>'

				SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Company' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'From Site' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'To Site' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Team' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'MKT Owner' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Measure' + '</th>'
				

				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 1 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 2 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 3 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 4 ), 23 )   + '</th>'
	
				SET @v_head_cont = @v_head_cont+ '</tr>'

				SET @v_mail_title = '[SSP_Early Warning] Shipping Schedule Nagative value';
				SET @v_body_contents = 'The Negative stock vlaue of shipping schedule based on the shipment request. Please refer to the table below and adjust the shipping request.
										If you do not change the shipment request before entering the confirm period, the shipment plan will be deleted, so please check in advance
										Thank you
										Best regards.
							
									';
				SET @v_body_cont = '';

				SET @v_receiver_tmpcnt = @v_receiver_tmpcnt + 1;
				SET @v_item_tmpcnt = 0;
				SET @v_cnt = 0;

				SELECT 
					@v_mail_receiver = MAX(MAIL_RECEIVER)
					--,@v_item_seq_temp = MAX(ITEM_SEQ)
				FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
				WHERE 1 = 1
				AND SITE_SEQ = @v_fromsite_tmpcnt
				AND REC_SEQ = @v_receiver_tmpcnt
				; 

				SET @v_to_mail = @v_mail_receiver+'@lgensol.com';
				--SET @v_to_mail = 'kimyh8848@lgespartner.com';

				--//TEST
				--SET @v_mail_title = @v_to_mail + '-' + @v_mail_title;

				DECLARE CUR_SEND CURSOR FOR
				SELECT
					MAIL_RECEIVER
					, division_id
					, COMPANY_ID
					, from_site_description
					, to_site_description
					, ISNULL(dept_name_ko,'-')
					, ISNULL(MKT_USER,'-')
					, item_id
					, nick_name
					, measure_name
					, ISNULL(segment1,0) AS Segment1
					, ISNULL(segment2,0) AS Segment2
					, ISNULL(segment3,0) AS Segment3
					, ISNULL(segment4,0) AS Segment4
					, ISNULL(segment5,0) AS Segment5
					, ITEM_SEQ
					, MEASURE_SEQ
				FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
				WHERE 1 = 1
				AND SITE_SEQ = @v_fromsite_tmpcnt
				AND REC_SEQ = @v_receiver_tmpcnt
				--and item_id ='MCCM125010A2'
				ORDER BY MAIL_RECEIVER, division_id, COMPANY_ID, item_id, from_site_description, to_site_description desc, SEQ
				;
			
				OPEN CUR_SEND;
				FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_to_site_description, @v_dept_name_ko , @v_mkt_user,  @v_item_id, @v_nick_name, @v_measure_name
									, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5, @v_item_seq, @v_MEASURE_SEQ
		
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					--SET @v_rowspanCnt = @@CURSOR_ROWS
					
					
					
					SELECT @v_rowspanCnt = COUNT(*)
					FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
					WHERE 1 = 1
					AND REC_SEQ = @v_receiver_tmpcnt
					AND ITEM_SEQ = @v_item_seq

					--print @v_item_seq +'-' +@v_item_seq_temp;
					--print @v_cnt;
					--PRINT @v_item_id;

					IF @v_item_seq_temp <> @v_item_seq
						SET @v_cnt = 0;

					SET @v_item_seq_temp = @v_item_seq;

					--//+++++++++++++++++++++++++++++++++++++++++++++=
					IF @v_cnt = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ '<tr>';	
						SET @v_body_cont = @v_body_cont+ '<td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_company_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>';
					END

					--IF @v_cnt = 0
					--BEGIN
					--print @v_rowspanCnt;
					--print @@CURSOR_ROWS;

					--	set @v_rowspanCnt = @@CURSOR_ROWS;
					--	SET @v_body_cont = @v_body_cont+ '< tr>';
					--	SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '< /td>';
					--	SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_company_id,''), CHAR(10),' ') + '< /td>';
					--	SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '< /td>';
					--	SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '< /td>';
					--	SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '< /td>';
					--END

					--PRINT CONVERT(VARCHAR(50),@v_MEASURE_SEQ) + ' -- ' +  CONVERT(VARCHAR(50),@MEASURECNT) + ' -- ' + CONVERT(VARCHAR(50),@v_to_site_description);

					IF @v_MEASURE_SEQ <> 1 AND @MEASURECNT = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ '<td rowspan=3>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=3>' + REPLACE(ISNULL(@v_dept_name_ko,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=3>' + REPLACE(ISNULL(@v_mkt_user,''), CHAR(10),' ') + '</td>'
					END
					

					IF @v_MEASURE_SEQ = 1
					BEGIN
						SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_dept_name_ko,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_mkt_user,''), CHAR(10),' ') + '</td>'
					END 
					
					
					--SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_mkt_user,''), CHAR(10),' ') + '</td>'
					SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_measure_name,''), CHAR(10),' ') + '</td>'
					
					
					SET @v_cnt = @v_cnt + 1;

					
					--IF @v_cnt = 10
					--IF @v_cnt = @v_rowspanCnt
					--BEGIN
					--	SET @v_cnt = 0
					--END


					IF (@v_measure_name = 'W/H BOH(Req)' or  @v_measure_name = 'W/H BOH(Plan)') and sign(@v_segment1) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF (@v_measure_name = 'W/H BOH(Req)' or  @v_measure_name = 'W/H BOH(Plan)') and sign(@v_segment2) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF (@v_measure_name = 'W/H BOH(Req)' or  @v_measure_name = 'W/H BOH(Plan)') and sign(@v_segment3) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF (@v_measure_name = 'W/H BOH(Req)' or  @v_measure_name = 'W/H BOH(Plan)') and sign(@v_segment4) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF (@v_measure_name = 'W/H BOH(Req)' or  @v_measure_name = 'W/H BOH(Plan)') and sign(@v_segment5) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END
					SET @v_body_cont = @v_body_cont+ '</tr>'


					SET @MEASURECNT = @MEASURECNT +1;

					IF @v_MEASURE_SEQ = 1 
						SET @MEASURECNT = 0;

					IF @MEASURECNT = 3 
						SET @MEASURECNT = 0;
					
					FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_to_site_description, @v_dept_name_ko, @v_mkt_user, @v_item_id, @v_nick_name, @v_measure_name
									, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5, @v_item_seq, @v_MEASURE_SEQ



				END

				CLOSE CUR_SEND;
				DEALLOCATE CUR_SEND;

				SET @TABLE_BODY = '';
				SET @TABLE_BODY = ' <html>
									<head>
											<title>Untitled Document</title>
											<style>
												* {margin:0;padding:0;}
												body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
												table {border-collapse:collapse;width:100%;}
												table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
												table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
												table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
												table tbody td {padding:6px 8px;font-size:12px}
												table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
												.hori-table table thead td {text-align:center;padding:3px;}  
												.hori-table table tbody td {text-align:center;padding:3px;}
												.vertical-table, .hori-table {margin-bottom:20px;}
											</style>
											</head>
											<body>' +'</br>'+
													'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
													'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
												'<table style=''border-top:2px solid #c8294b; width:1450px;''>
												<thead>' + ISNULL(@v_head_cont,'') +'</thead>
												<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
												</div>
											</body>
									</html>';
				--//메일 발송
				--EXEC SCM_ADM_MAIL_SEND
				--	@v_to_mail					--//'kahonmalu@lgensol.com'
				--	, @v_mail_title
				--	, @TABLE_BODY
				--	, 'Y'
				--;
				----MAIL 발송 LOG 저장
				--EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
				--	'MAIL'
				--	, '-'
				--	, @v_program_name
				--	, @v_division_id
				--	, @v_company_id
				--	, @v_from_site_description
				--	, @v_item_id
				--	, @v_nick_name
				--	, ''
				--	, ''
				--	, ''
				--	, ''
				--	, '' --p_send_pgm
				--	, @v_to_mail
				--;

				--print @v_body_cont;

				SELECT @v_to_mail, @v_mail_title, @v_body_cont, @TABLE_BODY;
			END
		END					
	END TRY
	BEGIN CATCH
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SEND')
		BEGIN
			CLOSE CUR_SEND;
			DEALLOCATE CUR_SEND;
		END

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);
			print @v_error_message;
			INSERT INTO scm_sys_log_batch 
			(
				program_name
				, log_type
				, log_count
				, log_message
				, description
				, event_date
				, creation_date
				, created_by
				, last_update_date
				, last_updated_by
			)
			VALUES 
			(
				ERROR_PROCEDURE()
				, 'ERROR'
				, NULL
				, ERROR_MESSAGE()
				, NULL
				, SYSDATETIME()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
			);

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
				'ERROR'
				, '-'
				, @v_program_name
				, 'MAIN ERROR' 
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, @v_error_message --p_send_pgm
				, ''
			;

		END
		
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
			
		set @p_log_messge = @v_error_message;
		return -1;

	END CATCH;
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG;

	-- SHIPMENT ROW DATA
	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;
	
	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_01') IS NOT NULL	
		DROP TABLE #Tmp_Result_01;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_02') IS NOT NULL	
		DROP TABLE #Tmp_Result_02;
	
	IF OBJECT_ID('tempdb..#TMP_Tbl_SSP_MAIL_SEND_BATCH_N') IS NOT NULL
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;

	IF OBJECT_ID('tempdb..#TMP_RESULT_PIVOT_TABLE_TEMP') IS NOT NULL
		DROP TABLE #TMP_RESULT_PIVOT_TABLE_TEMP;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_FG') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_40_FG;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_STD') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_40_STD;
		
	return 1;
END

