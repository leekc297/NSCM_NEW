

CREATE PROCEDURE [dbo].[PR_SCP_ANL_DIO_REPORT]  
	@P_DIVISION_ID		         	NVARCHAR(30), 
	@P_SEQ                     		NVARCHAR(8),
	@P_PLAN_START_YYYYMMDD			NVARCHAR(8),
	@P_CREATED_BY                   NVARCHAR(150),
	@P_MONTH                        INT, --3~12까지의 개월수
	@P_VER                     		INT
AS
/***********************************************************************************
 * Program ID  : [PR_SCP_ANL_DIO_REPORT]
 * Description  :  DIO REPORT 조회용 데이터 수집
 * Execute       : 
               EXEC [dbo].[PR_SCP_ANL_DIO_REPORT]
						@P_DIVISION_ID = N'81',
						@P_SEQ = N'1',
						@P_PLAN_START_YYYYMMDD = N'20220207',
                        @P_CREATED_BY = N@GETDATE_BY,  --SCP_batch
						@P_MONTH = 3
						@P_VER = 1;

 * Program History      
 *===================================================================================================      
 *   Date		In Charge	Description      
 *===================================================================================================      
 * 2021/11/02	HJ.LEE		PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - Initial Release
 * 2022.03.25   sclee       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.05.06   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응  
 *							1. SCP_ANL_DIO_REPORT_DETAIL attribute1컬럼에 셀 환산 수량 정보 추가				
 *							2. SCP_ANL_DIO_REPORT FG 운송중재고 LT에 Incoterms 반영				
 *							3. 메인 운송 LT적용 팝업 기준으로 변경
 *								- nick_name에 대한 각각의 수량 비중 LT SUM 적용				
 * 2022.05.30   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응
 *							1. nick_name 참조 기준 변경 (Group code Management의 Cell Group -> Level4) 
 *							2. 메인 데이터 nick_name 단위로 display (운송/Aging LT는 nick_name 단위이나, plant까지 display되고 있음) 
 * 2022.06.13   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가 
 * 2022.08.22   hrkim       PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 
 *                          - 셀 활성화 Aging L/T 팝업 데이터 추가
 * 2023.03.31   hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.04.27   hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Nick Name 기준 변경
 *													- 변경전 : SCP_MST_FINAL_ITEM.GROUP_CODE5 (Product Level4 - Group Code Management - 81)
 *													- 변경후 : SCP_MST_FINAL_ITEM.GROUP_CODE1 (Product Level1 - Group Code Management - 81)
 *
************************************************************************************/
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	DECLARE @DEBUG_MODE AS NVARCHAR(8) = 'F';

	DECLARE @V_FROM_YYYYMM NVARCHAR(6);
	DECLARE @V_TO_YYYYMM AS NVARCHAR(8);  

	DECLARE @V_PLAN_TYPE AS NVARCHAR(50) = 'FN';	
	DECLARE @V_VER		 AS INTEGER;

	DECLARE @VERSION_NO AS NVARCHAR(100);
	--------DECLARE @RETURN  AS NVARCHAR(10) = '0';
	--------DECLARE @V_COUNT  INTEGER = 0;				-- 기존데이터가 있는지 확인
	--------DECLARE @V_C_INV_COUNT  INTEGER = 0;		-- 주기재고 기존데이터가 있는지 확인
	
    -- PJ20216891
    DECLARE @v_tb_target_division TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division
	-- 2023.03.31 HM JV 가상 사업부 추가 대응
	SELECT DM.DIVISION_ID
	  FROM SCM_MST_DIVISION AS DM WITH(NOLOCK)
	 WHERE DM.ATTRIBUTE3 = '81' -- 자동차 
	   AND DM.VALID_YN	 = 'Y'
    -- 2023.03.31 HM JV SELECT '81' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV SELECT '81_UC' DIVISION_ID;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_DIO_REPORT'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30);		-- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = ISNULL(@P_CREATED_BY,''); 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure  ##########';     
    SET @v_description = @P_DIVISION_ID + ' : ' + @P_PLAN_START_YYYYMMDD + ' : ' + @P_SEQ + ' : ' + CONVERT(NVARCHAR(10), ISNULL(@P_VER, 1)) + ' : ' + CONVERT(NVARCHAR(10), ISNULL(@P_MONTH, 0)) ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
	
	SET @V_FROM_YYYYMM = CONVERT(VARCHAR(6), DATEADD(MM, 1 , @P_PLAN_START_YYYYMMDD),112) ;
	SET @V_TO_YYYYMM   = CONVERT(VARCHAR(6), DATEADD(MM, @P_MONTH, @P_PLAN_START_YYYYMMDD),112)

	SET @V_VER = ISNULL(@P_VER, 1) -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가

	BEGIN
		PRINT '--------------------------------- -';
		PRINT '@P_DIVISION_ID =' +@P_DIVISION_ID
		PRINT '@P_SEQ = ' +@P_SEQ;
		PRINT '@P_PLAN_START_YYYYMMDD =' +@P_PLAN_START_YYYYMMDD;
		PRINT '@V_FROM_YYYYMM =' +@V_FROM_YYYYMM
		PRINT '@V_TO_YYYYMM =' +@V_TO_YYYYMM;		
		PRINT '@P_VER = ' + CONVERT(VARCHAR(10), ISNULL(@P_VER, 1));
		PRINT '----------------------------------';
	END;
	
    BEGIN TRY
        
		-- Range값 오류 (3개월 이상이어야 수행함)
		IF ISNULL(@P_MONTH, 0) < 3  OR ISNULL(@P_MONTH, 0) > 12  
			BEGIN
				SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									 REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 
								 
				-- 종료 LOG                  
				SET @v_log_type = N'END';                  
				SET @v_log_message = N'########## END of procedure [RETURN 8] ##########';                  
				SET @v_description = N'['+ @v_exec_time + ']';             
				SET @d_event_date = SYSDATETIME()  ;  
	
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										  ,@p_log_type      =@v_log_type                  
										  ,@p_log_count     =@n_log_count                   
										  ,@p_log_message   =@v_log_message                   
										  ,@p_description   =@v_description                   
										  ,@p_event_date    =@d_event_date                   
										  ,@p_user_id       =@v_batch_user                  
										  ;                  
				RETURN 8;   
		END

		---------------------------------------------------------------------------------------------------------
		-- Begin - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가
		---------------------------------------------------------------------------------------------------------
		IF NOT EXISTS (SELECT 1
						 FROM SCP_ANL_DIO_REPORT_VERSION V WITH(NOLOCK)
						WHERE V.DIVISION_ID			= @P_DIVISION_ID
						  AND V.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
						  AND V.PLAN_TYPE			= @V_PLAN_TYPE
						  AND V.SEQ					= @P_SEQ
						  AND V.VER					= @V_VER
						  )
			BEGIN

				INSERT INTO SCP_ANL_DIO_REPORT_VERSION 
						   ( DIVISION_ID
						   , PLAN_START_YYYYMMDD
						   , PLAN_TYPE
						   , SEQ
						   , VER
						   , VER_STATUS
						   , DATA_RANGE
						   , FROM_YYYYMM
						   , TO_YYYYMM
						   , CREATED_BY
						   , CREATION_DATE
						   , LAST_UPDATED_BY
						   , LAST_UPDATE_DATE )
			   VALUES( @P_DIVISION_ID
					  ,@P_PLAN_START_YYYYMMDD
					  ,@V_PLAN_TYPE
					  ,@P_SEQ
					  ,@V_VER
					  ,'P'
					  ,@P_MONTH
					  ,@V_FROM_YYYYMM
					  ,@V_TO_YYYYMM
					  ,@P_CREATED_BY
					  ,GETDATE()
					  ,@P_CREATED_BY
					  ,GETDATE()
					  );
			END
		ELSE
			BEGIN

				SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									 REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 
								 
				-- 종료 LOG                  
				SET @v_log_type = N'END';                  
				SET @v_log_message = N'########## END of procedure [RETURN 9] ##########';                  
				SET @v_description = N'['+ @v_exec_time + ']';             
				SET @d_event_date = SYSDATETIME()  ;  
	
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										  ,@p_log_type      =@v_log_type                  
										  ,@p_log_count     =@n_log_count                   
										  ,@p_log_message   =@v_log_message                   
										  ,@p_description   =@v_description                   
										  ,@p_event_date    =@d_event_date                   
										  ,@p_user_id       =@v_batch_user                  
										  ;                  

				RETURN 9; -- 생성중이거나 생성된 버전이 존재할시 실행하지 않음. 
			END;
		---------------------------------------------------------------------------------------------------------
		-- End - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가
		---------------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------------
		-- Temp Table
		---------------------------------------------------------------------------------------------------------  
        IF OBJECT_ID('tempdb..#LAST_PLAN') IS NOT NULL
        DROP TABLE #LAST_PLAN;

        IF OBJECT_ID('tempdb..#LAST_PLAN_KEYIN') IS NOT NULL
        DROP TABLE #LAST_PLAN_KEYIN;

        IF OBJECT_ID('tempdb..#REPORT1') IS NOT NULL
        DROP TABLE #REPORT1;

        IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL
        DROP TABLE #SCM_MST_SITE;

        IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
        DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;

        IF OBJECT_ID('tempdb..#TblDynamicPivot_CLASS_TYPE_TEMP') IS NOT NULL
        DROP TABLE #TblDynamicPivot_CLASS_TYPE_TEMP;

        IF OBJECT_ID('tempdb..#TblDynamicPivot_CLASS_TYPE') IS NOT NULL
        DROP TABLE #TblDynamicPivot_CLASS_TYPE;

        IF OBJECT_ID('tempdb..#REPORT1_1') IS NOT NULL
        DROP TABLE #REPORT1_1;

        IF OBJECT_ID('tempdb..#REPORT1_2') IS NOT NULL
        DROP TABLE #REPORT1_2;

        IF OBJECT_ID('tempdb..#LINE_SUM') IS NOT NULL
        DROP TABLE #LINE_SUM;

        IF OBJECT_ID('tempdb..#LINE_WEIGHT') IS NOT NULL
        DROP TABLE #LINE_WEIGHT;

        IF OBJECT_ID('tempdb..#SCP_MST_FORMATION_LINE') IS NOT NULL
        DROP TABLE #SCP_MST_FORMATION_LINE;

        IF OBJECT_ID('tempdb..#SCP_MST_FORMATION_LINE_ITEM') IS NOT NULL
        DROP TABLE #SCP_MST_FORMATION_LINE_ITEM;

        IF OBJECT_ID('tempdb..#AGING_LT') IS NOT NULL
        DROP TABLE #AGING_LT;

        IF OBJECT_ID('tempdb..#AGING_LT_N') IS NOT NULL
        DROP TABLE #AGING_LT_N;

        IF OBJECT_ID('tempdb..#REPORT1_3') IS NOT NULL
        DROP TABLE #REPORT1_3;

        IF OBJECT_ID('tempdb..#REPORT1_3_1') IS NOT NULL
        DROP TABLE #REPORT1_3_1;

        IF OBJECT_ID('tempdb..#REPORT1_4') IS NOT NULL
        DROP TABLE #REPORT1_4;

        IF OBJECT_ID('tempdb..#MAX_SHIP_PLAN') IS NOT NULL
        DROP TABLE #MAX_SHIP_PLAN;

        IF OBJECT_ID('tempdb..#OPERATION_LT') IS NOT NULL
        DROP TABLE #OPERATION_LT;

        IF OBJECT_ID('tempdb..#REPORT2') IS NOT NULL
        DROP TABLE #REPORT2;

        IF OBJECT_ID('tempdb..#TMP_REPORT_BIZ_TYPE') IS NOT NULL
        DROP TABLE #TMP_REPORT_BIZ_TYPE;

        IF OBJECT_ID('tempdb..#TMP_REPORT_INCOTERMS') IS NOT NULL
        DROP TABLE #TMP_REPORT_INCOTERMS;

        IF OBJECT_ID('tempdb..#TMP_REPORT_CELL_PLANT_SITE_SEMI') IS NOT NULL
        DROP TABLE #TMP_REPORT_CELL_PLANT_SITE_SEMI;

        IF OBJECT_ID('tempdb..#CYCLE_INVENTORY1') IS NOT NULL
        DROP TABLE #CYCLE_INVENTORY1;

        IF OBJECT_ID('tempdb..#CYCLE_INVENTORY2') IS NOT NULL
        DROP TABLE #CYCLE_INVENTORY2;	
		
		-- begin - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
        IF OBJECT_ID('tempdb..#SUMQTY_NICKNAME') IS NOT NULL
        DROP TABLE #SUMQTY_NICKNAME;	

        IF OBJECT_ID('tempdb..#BOD_WEIGHT') IS NOT NULL
        DROP TABLE #BOD_WEIGHT;	

        IF OBJECT_ID('tempdb..#BOD_LT') IS NOT NULL
        DROP TABLE #BOD_LT;	

        IF OBJECT_ID('tempdb..#DEPARTURE_LT') IS NOT NULL
        DROP TABLE #DEPARTURE_LT;	
		-- end - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응

		---------------------------------------------------------------------------------------------------------
        -- 사용자가 입력한 최근 데이터 가져오기 : UI 입력 정보 유지용
		---------------------------------------------------------------------------------------------------------
		SELECT TOP 1 *			
	 	   INTO #LAST_PLAN
		  FROM SCP_ANL_DIO_REPORT WITH(NOLOCK)
		WHERE DIVISION_ID = @P_DIVISION_ID 
			AND CREATION_DATE =
							   (
								SELECT TOP 1  MAX(CREATION_DATE) AS MAX_CREATION_DATE
								FROM SCP_ANL_DIO_REPORT WITH(NOLOCK)
								WHERE 1=1 
							    AND DIVISION_ID			= @P_DIVISION_ID 
								AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
								AND PLAN_TYPE			= @V_PLAN_TYPE
								AND SEQ					= @P_SEQ
							   )			 

		SELECT 
			 A.DIVISION_ID
			,A.PLAN_START_YYYYMMDD
			,A.PLAN_TYPE
			,A.SEQ
			,A.NICK_NAME
			,A.PLANT_ID
			,A.FROM_SITE
			,A.CELL_EOL_SHIPPING_LOT
			,A.PACK_INCOMMING
			,A.PACK_OPERATION_LT  -- 이후 입력값이 아니면 주석처리할것 2021.12.27
			,A.SHIPMENT_CELL_INSPECTION_LOAD
			,A.SHIPMENT_CELL_INSPECTION_WAITING
			,A.SHIPMENT_PACK_INSPECTION_LOAD
			,A.SHIPMENT_PACK_INSPECTION_WAITING
			,A.PRE_INSPECTION_CELL
			,A.PRE_INSPECTION_PACK
			,A.VMI_CELL
			,A.VMI_PACK
			,A.FOREIGN_CORP
			,A.RACK_BIZ
			,A.SAFETY_STOCK_CELL
			,A.SAFETY_STOCK_PACK
			,A.OTHER_STOCK_CELL
			,A.OTHER_STOCK_PACK
            INTO #LAST_PLAN_KEYIN
		    FROM SCP_ANL_DIO_REPORT A WITH(NOLOCK)
		   INNER JOIN  #LAST_PLAN B 
			  ON A.DIVISION_ID = B.DIVISION_ID 
			 AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			 AND A.PLAN_TYPE = B.PLAN_TYPE
			 AND A.SEQ = B.SEQ
			 AND A.VER = B.VER

     -- 사용자가 입력한 최근 데이터 가져오기 끝
	 
	 ---------------------------------------------------------------------------------------------------------
	 -- DIO 기본 데이터 FROM PSI
	 ---------------------------------------------------------------------------------------------------------
	 SELECT  [DIVISION_ID]
			,[PLAN_START_YYYYMMDD]
		    ,[PLAN_TYPE]
			,[SEQ]
			,[PLANT_ID]
            ,PLANT_ID AS FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            ,TO_PLANT_ID, TO_SITE_TYPE, TO_CITY
			,CASE WHEN FROM_CITY = TO_CITY THEN 'Y' 
			      ELSE 'N' 
			 END AS SAME_CITY_FLAG
			,[ITEM_ID]
			,[CELL_ITEM_ID]
			,CASE WHEN MEASURE = 'SHIP_PLAN' AND TO_SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'A' THEN 'CELL' 
				  WHEN MEASURE = 'SHIP_PLAN' AND TO_SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'P' THEN 'PACK' 
				  ELSE NULL
				  END [BIZ_TYPE]
			,[INCOTERMS]		   
			,[OPERATION_GROUP]
	        ,FROM_SITE
			,[TO_SITE] 
			,[TO_BOH_QTY] 
			,[BOD_ID] 
			,[TRANSPORT_MODE_LINE]
			,[MEASURE]
	        ,YYYYMM
	        ,A.MONTH_DIFF
			,SUMQTY
			,COMPANY_ID -- 2022.08 추가
			,SITE_ID	-- 2022.08 추가 
	  INTO #REPORT1
	  FROM 
            (
             SELECT A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, CELL_ITEM_ID, INCOTERMS, A.OPERATION_GROUP
                  , FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE
                  , FS.PLANT_ID,                FS.SITE_TYPE AS FROM_SITE_TYPE, FS.CITY AS FROM_CITY
                  , TS.PLANT_ID AS TO_PLANT_ID, TS.SITE_TYPE AS TO_SITE_TYPE,   TS.CITY AS TO_CITY
                  , LEFT(YYYYMMDD,6) AS YYYYMM
                  , @P_MONTH AS MONTH_DIFF
				  , FS.COMPANY_ID  -- 2022.08 추가 
				  , FS.SITE_ID   -- 2022.08 추가 
                  , SUM([QTY]) AS SUMQTY
               FROM [DBO].[SCP_ANL_PSI_GLOBAL] A WITH(NOLOCK)

					LEFT JOIN SCM_MST_SITE FS WITH(NOLOCK) 
					       ON FS.DIVISION_ID = A.DIVISION_ID
						  AND FS.SCM_SITE_ID = A.FROM_SITE
						  AND FS.VALID_YN    = 'Y'

					LEFT JOIN SCM_MST_SITE TS WITH(NOLOCK) 
					       ON TS.DIVISION_ID = A.DIVISION_ID
						  AND TS.SCM_SITE_ID = A.TO_SITE
						  AND TS.VALID_YN    = 'Y'

              WHERE A.DIVISION_ID     = @P_DIVISION_ID
                AND PLAN_TYPE           = @V_PLAN_TYPE
                AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD  
                AND SEQ                 = @P_SEQ
                AND MEASURE IN ( 'SHIP_PLAN', 'PRODUCTION')
                AND SUBSTRING(YYYYMMDD,1,6) BETWEEN @V_FROM_YYYYMM AND @V_TO_YYYYMM
                AND QTY <> 0 
             GROUP  BY A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, CELL_ITEM_ID, INCOTERMS, A.OPERATION_GROUP
                  , FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE
                  , FS.PLANT_ID, FS.SITE_TYPE, FS.CITY
                  , TS.PLANT_ID, TS.SITE_TYPE, TS.CITY
                  , LEFT(YYYYMMDD,6)
				  , FS.COMPANY_ID  -- 2022.08 추가 
				  , FS.SITE_ID   -- 2022.08 추가 
            ) A	  
	 
	 ---------------------------------------------------------------------------------------------------------
	 -- DIO Master 데이터
	 ---------------------------------------------------------------------------------------------------------
		 /* PLANT_NAME */
		SELECT S.DIVISION_ID
		     , S.LOGISTIC_PLANT_ID
			 , S.PLANT_ID, S.SCM_SITE_ID 
		     , S.OPERATION_GROUP
		     , P.PLANT_NAME AS SITE_DESCRIPTION
		  INTO #SCM_MST_SITE
		  FROM SCM_MST_SITE S WITH(NOLOCK) 
		  LEFT JOIN SCM_MST_PLANT_SN P WITH(NOLOCK) 
		    ON S.DIVISION_ID = P.DIVISION_ID
		   AND S.LOGISTIC_PLANT_ID = P.PLANT_ID
		 WHERE S.DIVISION_ID = @P_DIVISION_ID
		   AND S.LOGISTIC_PLANT_ID IS NOT NULL
		   AND S.OPERATION_GROUP IN ('A'	,'P')  
		   
		 /* Cell Convert Qty */
        SELECT division_id
              ,model_id
              ,MAX(accumulated_child_qty) AS accumulated_child_qty
        INTO   #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V
        FROM   dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
        WHERE  operation_group_id = 'A'
		GROUP BY division_id, model_id;

		 /*제품, TYPE, NICK_NAME(모델), MANAGE_CELL_GROUP적용예정(2021.11.20) */
		SELECT F.DIVISION_ID
			, F.ITEM_ID 
			, L.MATERIAL_CLASS_NAME
			, CELL_TYPE_GROUP_CODE
			, TYPE
			, FLOW_ID
			, F.GROUP_CODE1	AS CELL_GROUP
			, F.GROUP_CODE2	AS PACK_GROUP
			, F.GROUP_CODE5	AS LEVEL4
			, F.FLOW_ID		AS OPERATION_ID
			, F.NICK_NAME
			, ISNULL(C.accumulated_child_qty, 1) AS CELL_CONV_QTY
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
			            (SELECT TOP 1 DOE 
						   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
						  WHERE B.DIVISION_ID = F.DIVISION_ID
						    AND B.ITEM_ID = F.ITEM_ID 
							AND B.DOE IS NOT NULL
						 )
				    ELSE '' 
					END AS BASIC_MODEL_PACK
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
			            (SELECT NICK_NAME 
						   FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
						  WHERE B.DIVISION_ID = F.DIVISION_ID
						    AND B.ITEM_ID = (SELECT TOP 1 DOE 
							                   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
											  WHERE B.DIVISION_ID = F.DIVISION_ID 
											    AND B.ITEM_ID = F.ITEM_ID AND B.DOE IS NOT NULL
											 )
						 ) 
					ELSE ''
					END AS BASIC_NICKNAME_PACK
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
				        F.ATTRIBUTE1 
			       ELSE '' 
				   END AS CELL_MODEL
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
			            (SELECT NICK_NAME 
						   FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
						  WHERE B.DIVISION_ID = F.DIVISION_ID 
						    AND B.ITEM_ID = F.ATTRIBUTE1
						) 
					ELSE '' 
					END AS CELL_MODEL_NICKNAME
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
			            (SELECT TOP 1 DOE 
						   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
						  WHERE B.DIVISION_ID = F.DIVISION_ID 
						    AND B.ITEM_ID = F.ATTRIBUTE1 
						    AND B.DOE IS NOT NULL
						 ) 
					ELSE (SELECT TOP 1 DOE 
					        FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
						   WHERE B.DIVISION_ID = F.DIVISION_ID 
						     AND B.ITEM_ID = F.ITEM_ID 
							 AND B.DOE IS NOT NULL
						  ) 
					END AS BASIC_MODEL_CELL
			, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
			            (SELECT NICK_NAME 
						   FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
						  WHERE B.DIVISION_ID = F.DIVISION_ID 
						    AND B.ITEM_ID = (SELECT TOP 1 DOE 
							                   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
											  WHERE B.DIVISION_ID = F.DIVISION_ID 
											    AND B.ITEM_ID = F.ATTRIBUTE1 
												AND B.DOE IS NOT NULL
											 )
						) 
			       ELSE (SELECT NICK_NAME 
				          FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK)
						  WHERE B.DIVISION_ID = F.DIVISION_ID 
						    AND B.ITEM_ID = (SELECT TOP 1 DOE 
							                   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
											  WHERE B.DIVISION_ID = F.DIVISION_ID 
											    AND B.ITEM_ID = F.ITEM_ID 
												AND B.DOE IS NOT NULL
											  )
						 ) 
					END AS BASIC_NICKNAME_CELL
		INTO #TblDynamicPivot_CLASS_TYPE_TEMP
		FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
		LEFT JOIN (SELECT SEGMENT1
		                , DESCRIPTION AS MATERIAL_CLASS_NAME
				     FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				    WHERE LOOKUP_TYPE ='CELL_TYPE_GROUP_CODE'
		              AND VALID_YN ='Y'
				   ) L 
		  ON L.SEGMENT1 = F.CELL_TYPE_GROUP_CODE
		LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS TYPE 
					  FROM SCM_MST_ITEM_SN M WITH(NOLOCK) 
					 WHERE DIVISION_ID = @P_DIVISION_ID
					 GROUP BY ITEM_ID
		           ) I 
		  ON I.ITEM_ID = F.ITEM_ID
        LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V C
          ON  F.division_id = C.division_id
          AND F.item_id     = C.model_id
	    INNER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID 
					  FROM #REPORT1
					 UNION
					 SELECT DISTINCT DIVISION_ID, CELL_ITEM_ID 
					  FROM #REPORT1
		           ) B 
		  ON F.ITEM_ID	 = B.ITEM_ID
		 AND F.DIVISION_ID = B.DIVISION_ID
	   WHERE F.DIVISION_ID = @P_DIVISION_ID

----------------------------------------------------------------------------		
	   SELECT DIVISION_ID
	       , ITEM_ID 
		   , MATERIAL_CLASS_NAME
		   , CELL_TYPE_GROUP_CODE
		   , TYPE
		   , FLOW_ID 
		   , BASIC_MODEL_PACK
		   , BASIC_NICKNAME_PACK
		   , CELL_MODEL
		   , CELL_MODEL_NICKNAME
		   , BASIC_NICKNAME_CELL
		   , BASIC_MODEL_CELL 
		   , CELL_GROUP
		   , PACK_GROUP
		   -- 2023.04.27 nick name 기준변경 , ISNULL(ISNULL(LEVEL4, CELL_GROUP), ISNULL(BASIC_NICKNAME_CELL, ISNULL(NICK_NAME, ITEM_ID) )) AS NICK_NAME -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응 (LEVEL4기준)
		   , ISNULL(CELL_GROUP, ISNULL(BASIC_NICKNAME_CELL, ISNULL(NICK_NAME, ITEM_ID) )) AS NICK_NAME -- 2023.04.27 Nick Name 기준 변경 (GROUP_CODE1 -> Product Level1 기준) 
		   , CELL_CONV_QTY
		INTO #TblDynamicPivot_CLASS_TYPE
		FROM #TblDynamicPivot_CLASS_TYPE_TEMP
		
		-- NICK_NAME, MATERIAL_CLASS_NAME, TYPE 추가
		SELECT A.* 
			, ISNULL(C.NICK_NAME ,'') NICK_NAME 
			, C.MATERIAL_CLASS_NAME
			, C.TYPE
			, ISNULL(C.CELL_CONV_QTY, 1)			AS CELL_CONV_QTY
			, ISNULL(C.CELL_CONV_QTY, 1) * SUMQTY	AS SUMQTY_CELL_CONV  -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응 
		INTO #REPORT1_1
		FROM #REPORT1 A
		LEFT JOIN #TblDynamicPivot_CLASS_TYPE C
		  ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID

--11--------------------------------------------------------
			SELECT A.*
				,  M.END_CUSTOMER
				,  M.SCM_SITE_ID
				,  M.SOLDTO_CUSTOMER
				,  ISNULL(A.TO_SITE_TYPE, 'PLANT') AS SITE_TYPE
			INTO #REPORT1_2
			FROM #REPORT1_1 A
			LEFT JOIN  ( SELECT T.DIVISION_ID
								, T.END_CUSTOMER
								, CASE WHEN T.SOLDTO_CUSTOMER1 <> T.SOLDTO_CUSTOMER2 THEN 'COMMON' 
										ELSE ISNULL(T.SOLDTO_CUSTOMER1,T.SOLDTO_CUSTOMER2) 
										END AS SOLDTO_CUSTOMER
								,T.SCM_SITE_ID
								,T.SITE_TYPE   
							FROM (
									SELECT P.DIVISION_ID		  
										,CASE WHEN DIVISION_ID = '40' THEN 'acer' 
												ELSE END_CUSTOMER 
												END AS END_CUSTOMER
										,MAX(P.SOLDTO_CUSTOMER) AS  SOLDTO_CUSTOMER1
										,MIN(P.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER2
										,P.SCM_SITE_ID
										,P.SITE_TYPE 
									FROM SCM_MST_SITE P WITH(NOLOCK)
									WHERE 1=1 
 									AND P.DIVISION_ID = @P_DIVISION_ID
									GROUP BY P.DIVISION_ID, P.END_CUSTOMER, P.SCM_SITE_ID, P.SITE_TYPE
								) T
		   			) M
			ON  A.TO_SITE     = M.SCM_SITE_ID
			AND A.DIVISION_ID = M.DIVISION_ID
			WHERE A.SUMQTY != 0	


-----------------------------------------------------------------------------------------------------------------------------------------
---####  Start -  PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 2022.08 셀 활성화 Aging L/T 팝업 데이터 추가/변경 
-----------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------
		--  AGING L/T 용
		-----------------------------------------------------------------------------------------
		    -- LINE별 가중치
		 	SELECT DISTINCT
				   R.NICK_NAME
			      ,R.PLANT_ID
				  ,R.TRANSPORT_MODE_LINE AS LINE_ID 
			      ,SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME
												 ,R.PLANT_ID
												 ,R.TRANSPORT_MODE_LINE)     AS  SUMQTY
				  ,SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME)				 AS  PROD_QTY 
				  ,SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME
												 ,R.PLANT_ID
												 ,R.TRANSPORT_MODE_LINE)
					/ 
				   SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME)				 AS  LINE_WEIGHT
              INTO #LINE_WEIGHT
			  FROM #REPORT1_2 R 
			  WHERE MEASURE         = 'PRODUCTION'
			    AND OPERATION_GROUP = 'A'
			    AND SUMQTY          > 0

			-- FP Aging LT 정보 (가중치 적용전) - LINE*ITEM
			 SELECT A.COMPANY_ID
				  , A.DIVISION_ID
				  , A.SITE_ID
				  , A.PLANT_ID
				  , A.LINE_ID 
				  , C.NICK_NAME
				  , A.ITEM_ID
				  , MAX(A.FACTORY_ID)			AS FACTORY_ID
				  , MAX(I.FLOW_ID)				AS OPERATION_ID
				  , ISNULL(SUM(A.STANDARD_LT), 0)				AS STANDARD_LT_MIN
				  , ISNULL(SUM(A.STANDARD_LT), 0) / 60 / 24		AS STANDARD_LT_DAY
			  INTO #SCP_MST_FORMATION_LINE_ITEM
			  FROM SCM_MST_AGING_ITEM_FLOW_M_SN A WITH(NOLOCK)   
				   INNER JOIN #TblDynamicPivot_CLASS_TYPE C
						   ON A.DIVISION_ID = C.DIVISION_ID 
						  AND A.ITEM_ID     = C.ITEM_ID
				   LEFT  JOIN SCM_MST_ITEM_SN I WITH(NOLOCK)
					       ON I.ITEM_ID     = A.ITEM_ID
						  AND I.COMPANY_ID  = A.COMPANY_ID
						  AND I.DIVISION_ID = A.DIVISION_ID
						  AND I.SITE_ID     = A.SITE_ID
			  WHERE  1=1
			    AND    A.DEFAULT_ROUTE = 'Y'            
				AND    A.STANDARD_LT IS NOT NULL  
				AND    EXISTS ( SELECT 1
								FROM  ( SELECT P.COMPANY_ID, P.DIVISION_ID, P.SITE_ID, P.PLANT_ID, P.FACTORY_ID, P.ITEM_ID, P.LINE_ID, P.ROUTE_TYPE, MIN(P.ROUTE_ID) AS ROUTE_ID
										FROM SCM_MST_AGING_ITEM_FLOW_M_SN P (NOLOCK) 
										WHERE  1=1
										  AND  P.DIVISION_ID = @P_DIVISION_ID
										  AND  P.ROUTE_TYPE IN ( 'C', 'D')
										  AND  P.DEFAULT_ROUTE = 'Y'   
										GROUP BY P.COMPANY_ID, P.DIVISION_ID, P.SITE_ID, P.PLANT_ID, P.FACTORY_ID, P.ITEM_ID, P.LINE_ID, P.ROUTE_TYPE
										) B
								WHERE A.COMPANY_ID	= B.COMPANY_ID
								AND A.DIVISION_ID	= B.DIVISION_ID
								AND A.SITE_ID		= B.SITE_ID
								AND A.PLANT_ID		= B.PLANT_ID
								AND A.FACTORY_ID	= B.FACTORY_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.LINE_ID		= B.LINE_ID
								AND A.ROUTE_ID		= B.ROUTE_ID
								AND A.ROUTE_TYPE	= B.ROUTE_TYPE	)
			   GROUP BY A.COMPANY_ID
					   ,A.DIVISION_ID
					   ,A.SITE_ID
					   ,A.PLANT_ID
					   ,A.ITEM_ID 
					   ,A.LINE_ID
					   ,C.NICK_NAME

		-- FP Aging LT 정보 (가중치 적용전) - LINE
		 SELECT A.COMPANY_ID
		      , A.DIVISION_ID
			  , A.SITE_ID
			  , A.PLANT_ID
			  , A.NICK_NAME
			  , A.LINE_ID 
              , CONVERT(NUMERIC(10,2), AVG(A.STANDARD_LT_MIN) / 1440.0) AS STANDARD_LT_DAY
		  INTO #SCP_MST_FORMATION_LINE
		  FROM #SCP_MST_FORMATION_LINE_ITEM A
		GROUP BY A.COMPANY_ID
		      , A.DIVISION_ID
			  , A.SITE_ID
			  , A.PLANT_ID
			  , A.NICK_NAME
			  , A.LINE_ID


		-- AGING L/T * 가중치  
		-- Cell Prod 존재하는 경우
		SELECT A.* 
			  ,W.LINE_WEIGHT
			  ,A.STANDARD_LT_DAY * W.LINE_WEIGHT AS AGING_LT
		  INTO #AGING_LT 
		  FROM #SCP_MST_FORMATION_LINE A		
			   INNER JOIN #LINE_WEIGHT W
			           ON A.NICK_NAME   = W.NICK_NAME
			          AND A.PLANT_ID    = W.PLANT_ID 
			          AND A.LINE_ID     = W.LINE_ID  --12.02조건 추가
			  
		-- Cell Prod  없는 경우
		SELECT  A.*
			  , 1				   LINE_WEIGHT
			  , A.STANDARD_LT_DAY  AS AGING_LT
		  INTO #AGING_LT_N
		  FROM #SCP_MST_FORMATION_LINE A	
		 WHERE 1=1
		   AND NOT EXISTS (SELECT 1
						    FROM #AGING_LT W
						   WHERE W.NICK_NAME = A.NICK_NAME) 

--15----여기서 부터는 SHIP_PLAN DATA 만--------------------------------------------------------
		SELECT R.*, LT.AGING_LT
		  INTO #REPORT1_3        
		  FROM #REPORT1_2 R
          LEFT JOIN ( SELECT NICK_NAME
						   , SUM(AGING_LT) AS AGING_LT  -- Cell Prod 존재하는 경우 : 가중치 SUM
					   FROM #AGING_LT 
			          GROUP BY NICK_NAME
					  UNION ALL 
					  SELECT NICK_NAME
						   , AVG(AGING_LT) AS AGING_LT  -- Cell Prod  없는 경우 : 평균
					   FROM #AGING_LT_N 
			          GROUP BY NICK_NAME
				    ) LT
			ON R.NICK_NAME = LT.NICK_NAME
		 WHERE R.MEASURE = 'SHIP_PLAN'
		
		-----------------------------------------------------------------------------------------
		-- DIO_REPORT_DETAIL_AGING 생성 - 2022.08월 추가
		-----------------------------------------------------------------------------------------
			BEGIN TRAN
 				  WHILE (1=1)
						BEGIN
 							DELETE TOP(4000) FROM SCP_ANL_DIO_REPORT_DETAIL_AGING
							WHERE DIVISION_ID			= @P_DIVISION_ID
							  AND PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD 
							  AND PLAN_TYPE				= @V_PLAN_TYPE
							  AND SEQ					= @P_SEQ
							  AND VER					= @V_VER
 	 		
 							IF @@ROWCOUNT = 0 BREAK;
						END
			     COMMIT 
				 
			;WITH PRODUCTION_INFO AS (
			SELECT R.NICK_NAME
			      ,R.ITEM_ID
				  ,R.DIVISION_ID
				  ,R.COMPANY_ID
				  ,R.SITE_ID
				  ,R.PLANT_ID
				  ,R.TRANSPORT_MODE_LINE	AS LINE_ID
				  ,SUM(R.SUMQTY)			AS TOTAL 
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  1, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M1
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  2, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M2
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  3, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M3
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  4, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M4
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  5, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M5
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  6, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M6
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  7, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M7
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  8, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M8
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM,  9, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M9
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 10, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M10
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 11, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M11
				  ,SUM(CASE WHEN R.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 12, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN R.SUMQTY END ) AS M12
			  FROM #REPORT1_2 R 
			  WHERE R.MEASURE         = 'PRODUCTION'
			    AND R.OPERATION_GROUP = 'A'
			    AND R.SUMQTY          > 0
			GROUP BY R.NICK_NAME
			        ,R.ITEM_ID
					,R.DIVISION_ID
				    ,R.COMPANY_ID
				    ,R.SITE_ID
				    ,R.PLANT_ID
				    ,R.TRANSPORT_MODE_LINE
		)
		INSERT INTO SCP_ANL_DIO_REPORT_DETAIL_AGING (
					 DIVISION_ID		
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE			
					,SEQ				
					,VER				
					,NICK_NAME			
					,ITEM_ID			
					,COMPANY_ID			
					,SITE_ID			
					,PLANT_ID			
					,FACTORY_ID			
					,LINE_ID			
					,OPERATION_ID	
					
					,LINE_AVG_AGING_LT
					,CELL_AGING_LT
					
					,TOTAL
					,M1	
					,M2	
					,M3	
					,M4	
					,M5	
					,M6	
					,M7	
					,M8	
					,M9	
					,M10
					,M11
					,M12

					,CREATED_BY			
					,CREATION_DATE		
					,LAST_UPDATED_BY	
					,LAST_UPDATE_DATE	
					)
		SELECT 
					 @P_DIVISION_ID		
					,@P_PLAN_START_YYYYMMDD
					,@V_PLAN_TYPE			
					,@P_SEQ				
					,@V_VER
					
					,ISNULL ( F.NICK_NAME		,P.NICK_NAME	)	
					,ISNULL ( F.ITEM_ID			,P.ITEM_ID		)
					,ISNULL ( F.COMPANY_ID		,P.COMPANY_ID	)	
					,ISNULL ( F.SITE_ID			,P.SITE_ID		)
					,ISNULL ( F.PLANT_ID		,P.PLANT_ID	)	
					,ISNULL ( F.FACTORY_ID		,''	)	
					,ISNULL ( F.LINE_ID			,P.LINE_ID		)
					,ISNULL ( F.OPERATION_ID	,'' )
					
					,ISNULL(L.STANDARD_LT_DAY, 0)	AS LINE_AVG_AGING_LT     
					,ISNULL(F.STANDARD_LT_DAY, 0)	AS CELL_AGING_LT
					
					,ISNULL(P.TOTAL, 0) AS TOTAL 
					,ISNULL(P.M1,  0) AS M1
					,ISNULL(P.M2,  0) AS M2
					,ISNULL(P.M3,  0) AS M3
					,ISNULL(P.M4,  0) AS M4
					,ISNULL(P.M5,  0) AS M5
					,ISNULL(P.M6,  0) AS M6
					,ISNULL(P.M7,  0) AS M7
					,ISNULL(P.M8,  0) AS M8
					,ISNULL(P.M9,  0) AS M9
					,ISNULL(P.M10, 0) AS M10
					,ISNULL(P.M11, 0) AS M11
					,ISNULL(P.M12, 0) AS M12

					,@P_CREATED_BY							AS CREATED_BY   
					,GETDATE()								AS CREATION_DATE
					,@P_CREATED_BY							AS UPDATED_BY    
					,GETDATE()								AS UPDATED_DATE
		 FROM #SCP_MST_FORMATION_LINE_ITEM F WITH(NOLOCK)
			  FULL OUTER JOIN PRODUCTION_INFO  P WITH(NOLOCk)
					 ON P.NICK_NAME    =  F.NICK_NAME
					AND P.ITEM_ID      =  F.ITEM_ID
					AND P.DIVISION_ID  =  F.DIVISION_ID
					AND P.COMPANY_ID   =  F.COMPANY_ID
					AND P.SITE_ID      =  F.SITE_ID
					AND P.PLANT_ID     =  F.PLANT_ID
					AND P.LINE_ID      =  F.LINE_ID
		      LEFT JOIN #SCP_MST_FORMATION_LINE L WITH(NOLOCK)
					 ON L.NICK_NAME    =  ISNULL(F.NICK_NAME,   P.NICK_NAME   )
					AND L.DIVISION_ID  =  ISNULL(F.DIVISION_ID, P.DIVISION_ID )
					AND L.COMPANY_ID   =  ISNULL(F.COMPANY_ID,  P.COMPANY_ID  )
					AND L.SITE_ID      =  ISNULL(F.SITE_ID,     P.SITE_ID	  )
					AND L.PLANT_ID     =  ISNULL(F.PLANT_ID,    P.PLANT_ID	  )
					AND L.LINE_ID      =  ISNULL(F.LINE_ID,     P.LINE_ID	  )
		WHERE 1=1
		  AND EXISTS (SELECT TOP 1 *
						FROM #REPORT1_3 R   -- SHIP_PLAN FG가 존재하는 경우만 main에 조회됨
					   WHERE R.NICK_NAME = ISNULL(F.NICK_NAME, P.NICK_NAME)
					     AND R.SITE_TYPE = 'SALES' -- FG
					   );
					  
-----------------------------------------------------------------------------------------------------------------------------------------
---####  End -  PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - - 2022.08 셀 활성화 Aging L/T 팝업 데이터 변경/추가 
-----------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------
		--  Operation LT구하기
		-----------------------------------------------------------------------------------------
		SELECT DIVISION_ID
		     , SCM_SITE_ID
			 , ITEM_ID 
			 , LT_DAY   
		  INTO #OPERATION_LT
		  FROM SCP_MST_OPERATION_LT WITH(NOLOCK)
		 WHERE DIVISION_ID = @P_DIVISION_ID
		   AND LT_OPERATION = 'PRE_INSP'


----------------------------------------------------------------------------------------------------------------
-- begin -- 2022.05 PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 
----------------------------------------------------------------------------------------------------------------
		-- NICNAME/SITE_TYPE별 수량 합계 
		SELECT NICK_NAME
			  ,SITE_TYPE
			  ,SUM(SUMQTY)						AS SHIP_QTY
			  ,SUM(SUMQTY * CELL_CONV_QTY)		AS CELL_CONV_SHIP_QTY
		 INTO #SUMQTY_NICKNAME
		 FROM #REPORT1_2  WITH(NOLOCK) 
		WHERE 1=1
		  AND MEASURE = 'SHIP_PLAN'
		  AND SUMQTY > 0 
	    GROUP BY NICK_NAME
			    ,SITE_TYPE
		;

		-- NICNAME/SITE_TYPE별/PLANT/BOD별 NICK NAME 전체 수량에 대한 비중
		SELECT A.NICK_NAME
			  ,S.SITE_TYPE
			  ,CASE WHEN S.SITE_TYPE  = 'SALES' 
					THEN A.PLANT_ID 
					ELSE A.TO_PLANT_ID 
			   END	AS PLANT_ID
			  ,A.BOD_ID
			  ,S.CELL_CONV_SHIP_QTY
			  ,SUM(A.SUMQTY)											AS SUMQTY
			  ,SUM(A.SUMQTY * A.CELL_CONV_QTY)							AS SUMQTY_CONV
			  ,SUM(A.SUMQTY * A.CELL_CONV_QTY)  / S.CELL_CONV_SHIP_QTY	AS SITE_WEIGHT
		 INTO #BOD_WEIGHT
		 FROM #REPORT1_2 A WITH(NOLOCK)
			  INNER JOIN #SUMQTY_NICKNAME S WITH(NOLOCK) 
					  ON S.NICK_NAME = A.NICK_NAME
					 AND S.SITE_TYPE = A.SITE_TYPE
		WHERE 1=1
		  AND A.MEASURE = 'SHIP_PLAN'
		  AND A.SUMQTY > 0 
	  GROUP BY A.NICK_NAME
			  ,S.SITE_TYPE
			  ,CASE WHEN S.SITE_TYPE  = 'SALES' 
					THEN A.PLANT_ID 
					ELSE A.TO_PLANT_ID 
			   END
			  ,A.BOD_ID
			  ,S.CELL_CONV_SHIP_QTY -- nick_name, site_type에 대한 종속적인 값 
		;

		-- BOD LT 참조
		SELECT DISTINCT
			   B.BOD_ID
			  ,CASE WHEN R.DAYS_MON = 'Y' OR R.DAYS_TUE = 'Y' OR R.DAYS_WED = 'Y' OR R.DAYS_THU = 'Y' 
			          OR R.DAYS_FRI = 'Y' OR R.DAYS_SAT = 'Y' OR R.DAYS_SUN = 'Y' 
				    THEN ROUND(
						   3.5 / (CASE WHEN R.DAYS_MON = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_TUE = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_WED = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_THU = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_FRI = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_SAT = 'Y' THEN 1 ELSE 0 END
										+ CASE WHEN R.DAYS_SUN = 'Y' THEN 1 ELSE 0 END)
							  , 2) 
					ELSE 0
			   END  AS DEPART_DAYS
			  ,R.LT_DEPARTURE_INLAND
			  ,R.LT_WAIT_SHIPPING
			  ,R.LT_VOYAGE
			  ,R.LT_LAY_OFF_CLEARANCE
			  ,R.LT_ARRIVAL_INLAND
			  ,CASE WHEN ISNULL(I.SEGMENT3, 'F') != 'A' 
			  	    THEN R.LT_DEPARTURE_INLAND 
			  	    ELSE 0 
			   END	AS INCOTERMS_LT_DEPARTURE_INLAND
			  ,CASE WHEN ISNULL(I.SEGMENT3, 'F') NOT IN ('A', 'B')
			  	    THEN R.LT_WAIT_SHIPPING 
			  	    ELSE 0 
			   END	AS INCOTERMS_LT_WAIT_SHIPPING
			  ,CASE WHEN ISNULL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C')
			  	    THEN R.LT_VOYAGE 
			  	    ELSE 0 
			   END	AS INCOTERMS_LT_VOYAGE
			  ,CASE WHEN ISNULL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D')
			  	    THEN R.LT_LAY_OFF_CLEARANCE 
			  	    ELSE 0 
			   END	AS INCOTERMS_LT_LAY_OFF_CLEARANCE
			  ,CASE WHEN ISNULL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D', 'E')
			  	    THEN R.LT_ARRIVAL_INLAND 
			  	    ELSE 0 
			   END	AS INCOTERMS_LT_ARRIVAL_INLAND
		 INTO #BOD_LT 
		 FROM #REPORT1_2 A  WITH(NOLOCK) 
			  INNER JOIN SCP_MST_BOD B   WITH(NOLOCK) 
					  ON B.BOD_ID = A.BOD_ID
			  INNER JOIN SCP_MST_DISTRIBUTION_ROUTE R  WITH(NOLOCK)   
					  ON R.ROUTE_ID = B.ROUTE_ID
			  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL I WITH(NOLOCK) 
					  ON I.LOOKUP_TYPE = 'INCOTERMS' 
					 AND I.SEGMENT1    = CASE WHEN A.SITE_TYPE  = 'SALES'
									          THEN B.INCOTERMS
											  ELSE 'DAP'
										  END
					 AND I.VALID_YN    = 'Y'
		WHERE 1=1
		  AND A.MEASURE = 'SHIP_PLAN'
		  AND A.SUMQTY > 0 
		;

		-- NICK_NAME, PLANT_ID, SITE_TYPE별 LT 사이트 가중치 Summary
		SELECT A.NICK_NAME
			  -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응 (plant_id 제외.. nick_name기준) ,A.PLANT_ID
			  ,A.SITE_TYPE
			  ,SUM(A.SUMQTY)										  AS SUMQTY
			  ,SUM(A.SUMQTY_CONV)									  AS SUMQTY_CONV
			  ,SUM(A.SITE_WEIGHT									) AS SITE_WEIGHT
			  ,SUM(A.SITE_WEIGHT * L.DEPART_DAYS					) AS DEPART_DAYS
			  -- incoterms 반영 (MAIN 생성시 반영)
			  ,SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_DEPARTURE_INLAND	) AS INCOTERMS_LT_DEPARTURE_INLAND
			  ,SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_WAIT_SHIPPING		) AS INCOTERMS_LT_WAIT_SHIPPING
			  ,SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_VOYAGE			) AS INCOTERMS_LT_VOYAGE
			  ,SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_LAY_OFF_CLEARANCE	) AS INCOTERMS_LT_LAY_OFF_CLEARANCE
			  ,SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_ARRIVAL_INLAND	) AS INCOTERMS_LT_ARRIVAL_INLAND
			  -- incoterms 미반영 (DETAIL 생성시 반영 - UI에서 반영)  
			  ,SUM(A.SITE_WEIGHT * L.LT_DEPARTURE_INLAND	) AS LT_DEPARTURE_INLAND
			  ,SUM(A.SITE_WEIGHT * L.LT_WAIT_SHIPPING		) AS LT_WAIT_SHIPPING
			  ,SUM(A.SITE_WEIGHT * L.LT_VOYAGE			    ) AS LT_VOYAGE
			  ,SUM(A.SITE_WEIGHT * L.LT_LAY_OFF_CLEARANCE	) AS LT_LAY_OFF_CLEARANCE
			  ,SUM(A.SITE_WEIGHT * L.LT_ARRIVAL_INLAND	    ) AS LT_ARRIVAL_INLAND
		 INTO #DEPARTURE_LT
		 FROM #BOD_WEIGHT A  WITH(NOLOCK)
			  INNER JOIN #BOD_LT L WITH(NOLOCK)
				      ON L.BOD_ID = A.BOD_ID
		WHERE 1=1
		GROUP BY A.NICK_NAME
			    -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응 (plant_id 제외.. nick_name기준) ,A.PLANT_ID
			    ,A.SITE_TYPE
		;

----------------------------------------------------------------------------------------------------------------
-- end -- 2022.05 PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 
----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------	
		-- DIO_REPORT_DETAIL 생성
		-----------------------------------------------------------------------------------------
			BEGIN TRAN
 				  WHILE (1=1)
						BEGIN
 							DELETE TOP(4000) FROM SCP_ANL_DIO_REPORT_DETAIL
							WHERE DIVISION_ID			= @P_DIVISION_ID
							  AND PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD 
							  AND PLAN_TYPE				= @V_PLAN_TYPE
							  AND SEQ					= @P_SEQ
							  AND VER					= @V_VER
 	 		
 							IF @@ROWCOUNT = 0 BREAK;
						END
			     COMMIT 

				INSERT INTO [dbo].[SCP_ANL_DIO_REPORT_DETAIL]
							([DIVISION_ID]
						   ,[PLAN_START_YYYYMMDD]
						   ,[PLAN_TYPE]
						   ,[SEQ]
						   ,[VER]
						   ,[ITEM_ID]
						   ,[NICK_NAME]
						   ,[FROM_SITE]
						   ,[TO_SITE]
						   ,[TRANSPORT_MODE_LINE]
						   ,[INCOTERMS]
						   ,[OPERATION_GROUP]
						   ,[BOD_ID]
						   ,[M1]
						   ,[M2]
						   ,[M3]
						   ,[M4]
						   ,[M5]
						   ,[M6]
						   ,[M7]
						   ,[M8]
						   ,[M9]
						   ,[M10]
						   ,[M11]
						   ,[M12]
						   ,[DATA_RANGE]
						   ,[FROM_CITY]
						   ,[TO_CITY]
						   ,[DNI_DEPART_DAYS]
						   ,[DNI_DEPARTURE_INLAND]
						   ,[DNI_WAITING_FOR_SHIPPING]	
						   ,[DNI_VOYAGE]	
						   ,[DNI_LAY_OFF_CUSTOMS_CLEARANCE]
						   ,[DNI_ARRIVAL_INLAND]	
						   ,[CREATED_BY]
						   ,[CREATION_DATE]
						   ,[LAST_UPDATED_BY]
						   ,[LAST_UPDATE_DATE]
						   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 (셀환산수량추가)
						   ,[ATTRIBUTE1]
						   /*
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[ATTRIBUTE6]
						   ,[ATTRIBUTE7]
						   ,[ATTRIBUTE8]
						   ,[ATTRIBUTE9]
						   ,[ATTRIBUTE10]
						   */
						 )
                     SELECT T.DIVISION_ID
						,T.PLAN_START_YYYYMMDD
						,T.PLAN_TYPE
						,T.SEQ
						,@V_VER
						,T.ITEM_ID
						,T.NICK_NAME
						,T.FROM_SITE
						,T.TO_SITE
						,T.TRANSPORT_MODE_LINE
						,REPLACE(T.INCOTERMS,' ', '') AS INCOTERMS
						,T.OPERATION_GROUP
						,T.BOD_ID
						,T.M1
						,T.M2
						,T.M3
						,T.M4
						,T.M5
						,T.M6
						,T.M7
						,T.M8
						,T.M9
						,T.M10
						,T.M11
						,T.M12
						,T.DATA_RANGE
						,T.FROM_CITY				
						,T.TO_CITY
						,T.DEPART_DAYS
						,T.LT_DEPARTURE_INLAND	
						,T.LT_WAIT_SHIPPING	
						,T.LT_VOYAGE	
						,T.LT_LAY_OFF_CLEARANCE
						,T.LT_ARRIVAL_INLAND	
						,T.CREATED_BY
						,T.CREATION_DATE
						,T.UPDATED_BY
						,T.UPDATED_DATE
						-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 (셀환산수량추가)
						,CONVERT(NVARCHAR, T.CELL_CONV_QTY)  AS ATTRIBUTE1 --- 	AS CELL_CONV_QTY
					FROM (
							SELECT 
								 A.DIVISION_ID												
								,A.PLAN_START_YYYYMMDD										
								,RTRIM(A.PLAN_TYPE)					AS PLAN_TYPE			
								,A.SEQ														
								,RTRIM(A.ITEM_ID)					AS ITEM_ID
								,A.NICK_NAME	 
								,RTRIM(A.FROM_SITE)					AS FROM_SITE												
								,RTRIM(A.TO_SITE)					AS TO_SITE
								,RTRIM(A.TRANSPORT_MODE_LINE)		AS TRANSPORT_MODE_LINE
			                    ,A.INCOTERMS
								,MAX(A.OPERATION_GROUP)					AS OPERATION_GROUP
								,MAX(A.BOD_ID)							AS BOD_ID
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 1, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M1
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 2, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M2
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 3, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M3
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 4, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M4
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 5, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M5
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 6, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M6
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 7, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M7
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 8, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M8
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 9, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M9
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 10, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M10
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 11, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M11
								,ISNULL(SUM(CASE WHEN A.YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 12, CONVERT(DATETIME, @P_PLAN_START_YYYYMMDD )), 112),1,6) THEN A.SUMQTY END ),0) M12
								,MAX(@P_MONTH)   						AS DATA_RANGE
								,MAX(A.FROM_CITY)						AS FROM_CITY
								,MAX(A.TO_CITY)							AS TO_CITY     
								,MAX(B.DEPART_DAYS)					    AS DEPART_DAYS
								,MAX(B.LT_DEPARTURE_INLAND)				AS LT_DEPARTURE_INLAND	
								,MAX(B.LT_WAIT_SHIPPING)				AS LT_WAIT_SHIPPING	
								,MAX(B.LT_VOYAGE)						AS LT_VOYAGE	
								,MAX(B.LT_LAY_OFF_CLEARANCE)			AS LT_LAY_OFF_CLEARANCE
								,MAX(B.LT_ARRIVAL_INLAND)				AS LT_ARRIVAL_INLAND	
								-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 (셀환산수량추가)
								,ISNULL(MAX(A.CELL_CONV_QTY), 1)		AS CELL_CONV_QTY
								,@P_CREATED_BY							AS CREATED_BY   
								,GETDATE()								AS CREATION_DATE
								,@P_CREATED_BY							AS UPDATED_BY    
								,GETDATE()								AS UPDATED_DATE
							FROM #REPORT1_3 A WITH(NOLOCK) 
								 -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응 : temp테이블 참조 변경
								 LEFT JOIN #BOD_LT B WITH(NOLOCK) 
									    ON B.BOD_ID = A.BOD_ID
							GROUP BY A.DIVISION_ID
									,A.PLAN_START_YYYYMMDD
									,A.PLAN_TYPE
									,A.SEQ
									,A.ITEM_ID
									,A.NICK_NAME
									,A.TRANSPORT_MODE_LINE
									,A.INCOTERMS	
									,A.FROM_SITE			
									,A.TO_SITE
							) AS T	
					
--22---------------------------------------------------------------------------------------------	
		-- DIO_REPORT 생성용 FG 정보 처리
		-----------------------------------------------------------------------------------------
		    --  월 전체 SUM : YYYYMM 없음
			SELECT   A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
                    , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
					, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
					, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE
					, MAX(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.SUMQTY) AS SUMQTY, MAX(A.CELL_CONV_QTY) AS CELL_CONV_QTY, MAX(A.AGING_LT) AS AGING_LT
					, SUM(SUMQTY_CELL_CONV) AS SUMQTY_CELL_CONV -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응
            INTO #REPORT1_3_1
			FROM #REPORT1_3 A WITH(NOLOCK) 
			GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
                    , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
					, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
					, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE

		    --  Item 이 다른 경우 처리
			SELECT   A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
                    , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, MAX(A.ITEM_ID) AS ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
					, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
					, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE
					, SUM(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.SUMQTY) AS SUMQTY, MAX(A.CELL_CONV_QTY) AS CELL_CONV_QTY, MAX(A.AGING_LT) AS AGING_LT
					, SUM(SUMQTY_CELL_CONV) AS SUMQTY_CELL_CONV -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응
            INTO #REPORT1_4
			FROM #REPORT1_3_1 A WITH(NOLOCK) 
			GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
                    , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
					, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
					, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE

			SELECT 
				 A.DIVISION_ID
				,A.PLAN_START_YYYYMMDD
				,A.MONTH_DIFF
				,A.PLAN_TYPE
				,A.SEQ 
				,A.NICK_NAME 
				,A.SITE_TYPE  
				,A.PLANT_ID
				,A.TO_PLANT_ID
				,A.FROM_SITE
				, (SELECT TOP 1 SITE_DESCRIPTION  
					 FROM #SCM_MST_SITE S
					WHERE A.DIVISION_ID = S.DIVISION_ID 
					  AND A.PLANT_ID  = S.LOGISTIC_PLANT_ID
					  AND A.OPERATION_GROUP = S.OPERATION_GROUP 
				   ) AS FROM_SITE_DESCRIPTION
				,A.TO_SITE
				,A.FROM_CITY
				,A.TO_CITY
				,A.TO_BOH_QTY
				,A.BOD_ID
				,A.TRANSPORT_MODE_LINE
				,A.OPERATION_GROUP
				,A.MEASURE
				,NULL AS SHIP_PLAN_QTY
				,CASE WHEN A.DIVISION_ID = '40' THEN A.SOLDTO_CUSTOMER 
						ELSE  A.END_CUSTOMER 
						END AS END_CUSTOMER
				,A.MATERIAL_CLASS_NAME AS PRODUCTION_TYPE
				,A.TYPE AS EXTRA_SPEC
				,A.ITEM_ID
				,A.CELL_ITEM_ID
				,SUBSTRING(A.BIZ_TYPE,1,60) AS BIZ_TYPE
				,SUBSTRING(A.INCOTERMS,1,60) AS INCOTERMS													   
				,A.AGING_LT AS CELL_AGING_LT 
				,A.SAME_CITY_FLAG
				,K.CELL_EOL_SHIPPING_LOT
				,K.PACK_INCOMMING
				,K.PACK_OPERATION_LT
				,K.SHIPMENT_CELL_INSPECTION_LOAD
				,K.SHIPMENT_CELL_INSPECTION_WAITING
				,K.SHIPMENT_PACK_INSPECTION_LOAD
				,K.SHIPMENT_PACK_INSPECTION_WAITING

				-- Semi 용 : Pack Biz 가 존재하는 경우 Semi 정보 표시용 : 뒤에서 Update
				,0 AS DNI_CELL_DEPARTURE_DAYS
				,0 AS DNI_CELL_DEPARTURE_INLAND
				,0 AS DNI_CELL_WAITING_FOR_SHIPPING
				,0 AS DNI_CELL_VOYAGE
				,0 AS DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
				,0 AS DNI_CELL_ARRIVAL_INLAND

				,CASE WHEN A.BIZ_TYPE = 'CELL' THEN  L.LT_DAY 
						END PRE_INSPECTION_CELL
				,CASE WHEN A.BIZ_TYPE = 'PACK' THEN  L.LT_DAY 
						END AS PRE_INSPECTION_PACK

				,K.VMI_CELL
				,K.VMI_PACK
				,K.FOREIGN_CORP
				,K.RACK_BIZ
				,NULL AS DEPARTURE_INTRANSIT_VMI
				,K.SAFETY_STOCK_CELL
				,K.SAFETY_STOCK_PACK
				,K.OTHER_STOCK_CELL
				,K.OTHER_STOCK_PACK
				,NULL AS PRODUCTION_CYCLE_CELL
				,NULL AS PRODUCTION_CYCLE_PACK
				,NULL AS STANDARD_DIO
				,NULL AS ASSEMBLY_QTY
				,NULL AS ASSEMBLY_TYPE_RATIO
				,NULL AS ASSEMBLY_TOTAL_RATIO
				,NULL AS WEIGHT_DIO
				,SUMQTY
			INTO #REPORT2  
			FROM #REPORT1_4 A
		  LEFT JOIN #LAST_PLAN_KEYIN K
			 ON A.DIVISION_ID = K.DIVISION_ID
			AND A.PLAN_TYPE   = K.PLAN_TYPE
			AND A.NICK_NAME   = K.NICK_NAME
			-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응 (plant_id 제외.. nick_name기준) AND A.PLANT_ID    = K.PLANT_ID

		  LEFT JOIN #OPERATION_LT L
			ON A.DIVISION_ID = L.DIVISION_ID
		   AND A.FROM_SITE = L.SCM_SITE_ID
		   AND A.ITEM_ID = L.ITEM_ID
		  
		  WHERE A.SITE_TYPE = 'SALES'	-- FG 정보만 처리


--39---------------------------------------------------------------------------------------------	

		 SELECT A.*
		   INTO #MAX_SHIP_PLAN
		   FROM (
					SELECT ROW_NUMBER() OVER ( PARTITION BY  NICK_NAME
												 ORDER BY CAST(SUMQTY_CELL_CONV AS INT) DESC) RANK_SEQ,
		               *
					  FROM (SELECT NICK_NAME
							     , PLANT_ID
								 , END_CUSTOMER
								 , MAX(ITEM_ID)				AS ITEM_ID
								 , SUM(SUMQTY_CELL_CONV)	AS SUMQTY_CELL_CONV
						     FROM #REPORT1_4
							WHERE SITE_TYPE = 'SALES'
							GROUP BY NICK_NAME
							       , PLANT_ID
								   , END_CUSTOMER
							) S
					) A
		WHERE	A.RANK_SEQ = 1

         -- BIZ TYPE이 여러개 일때 한 칼럼에 보여주기 위한 Temp Talble
		 SELECT DISTINCT DIVISION_ID
			, PLAN_START_YYYYMMDD
			, PLAN_TYPE
			, SEQ
			, PLANT_ID	
			, NICK_NAME
			, BIZ_TYPE
		INTO #TMP_REPORT_BIZ_TYPE
		FROM #REPORT2

--40---------------------------------------------------------------------------------------------	
		-- INCOTERMS가 여러개 일때 한 칼럼에 보여주기 위한 Temp Talble
		SELECT DISTINCT DIVISION_ID
			, PLAN_START_YYYYMMDD
			, PLAN_TYPE
			, SEQ
			, PLANT_ID	
			, NICK_NAME
			, INCOTERMS
		INTO #TMP_REPORT_INCOTERMS
		FROM #REPORT2
	   WHERE SAME_CITY_FLAG = 'N'
		 AND INCOTERMS != '-'

--42---------------------------------------------------------------------------------
          -- From / To가 다른 City 인 Semi 정보
		  SELECT DISTINCT A.DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PLAN_TYPE
				, A.SEQ
				, A.PLANT_ID	
				, A.NICK_NAME
			INTO #TMP_REPORT_CELL_PLANT_SITE_SEMI 
			FROM #REPORT1_3 A
		   WHERE A.SAME_CITY_FLAG = 'N'
		     AND A.SITE_TYPE      = 'PLANT'
								
	    -----------------------------------------------------------------------------------------------	
		-- DIO_REPORT FG 정보 처리
		-----------------------------------------------------------------------------------------

				BEGIN TRAN
 					WHILE (1=1)
						BEGIN
 							DELETE TOP(4000) FROM SCP_ANL_DIO_REPORT
							WHERE 1=1
							AND DIVISION_ID = @P_DIVISION_ID
							AND PLAN_TYPE = @V_PLAN_TYPE
							AND MEASURE = 'SHIP_PLAN'
							AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD  
							AND SEQ = @P_SEQ 
							AND VER = @V_VER
 	 		
 							IF @@ROWCOUNT = 0 BREAK;
						END
				COMMIT 

				  ------PRINT @v_log_type
				  ------IF @V_COUNT = 0 
				  ------BEGIN
	   ----------------------------------------------------------------------------
				INSERT INTO [dbo].[SCP_ANL_DIO_REPORT]
							   ([DIVISION_ID]
							   ,[PLAN_START_YYYYMMDD]
							   ,[PLAN_TYPE]
							   ,[SEQ]
							   ,[VER]
							   ,[NICK_NAME]
							   ,[PLANT_ID]
							   ,[CELL_PLANT_SITE]
							   ,[FROM_SITE]
							   ,[FROM_SITE_DESCRIPTION]
						       ,[TO_SITE]
							   ,[TO_BOH_QTY]
							   ,[BOD_ID]
							   ,[TRANSPORT_MODE_LINE]
							   ,[MEASURE]
							   ,[SHIP_PLAN_QTY]								
							   ,[END_CUSTOMER]
							   ,[PRODUCTION_TYPE]
							   ,[EXTRA_SPEC]	
							   ,[ITEM_ID]
							   ,[CELL_ITEM_ID]
							   ,[BIZ_TYPE]
							   ,[INCOTERMS]
							   ,[CELL_AGING_LT]
							   ,[CELL_EOL_SHIPPING_LOT]
							   ,[PACK_INCOMMING]
							   ,[PACK_OPERATION_LT]
							   ,[SHIPMENT_CELL_INSPECTION_LOAD]
							   ,[SHIPMENT_CELL_INSPECTION_WAITING]
							   ,[SHIPMENT_PACK_INSPECTION_LOAD]
							   ,[SHIPMENT_PACK_INSPECTION_WAITING]
							   ,[DNI_CELL_DEPARTURE_DAYS]
							   ,[DNI_CELL_DEPARTURE_INLAND]
							   ,[DNI_CELL_WAITING_FOR_SHIPPING]
							   ,[DNI_CELL_VOYAGE]
							   ,[DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE]
							   ,[DNI_CELL_ARRIVAL_INLAND]
							   ,[DNI_PACK_DEPARTURE_DAYS]
							   ,[DNI_PACK_DEPARTURE_INLAND]
							   ,[DNI_PACK_WAITING_FOR_SHIPPING]
							   ,[DNI_PACK_VOYAGE]
							   ,[DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE]
							   ,[DNI_PACK_ARRIVAL_INLAND]
							   ,[PRE_INSPECTION_CELL]
							   ,[PRE_INSPECTION_PACK]
							   ,[VMI_CELL]
							   ,[VMI_PACK]
							   ,[FOREIGN_CORP]
							   ,[RACK_BIZ]
							   ,[DEPARTURE_INTRANSIT_VMI]
							   ,[SAFETY_STOCK_CELL]
							   ,[SAFETY_STOCK_PACK]
							   ,[OTHER_STOCK_CELL]
							   ,[OTHER_STOCK_PACK]
							   ,[PRODUCTION_CYCLE_CELL]
							   ,[PRODUCTION_CYCLE_PACK]
							   ,[STANDARD_DIO]
							   ,[ASSEMBLY_QTY]
							   ,[ASSEMBLY_TYPE_RATIO]
							   ,[ASSEMBLY_TOTAL_RATIO]
							   ,[WEIGHT_DIO]
							   ,[SHIP_PLAN_WEIGHT] 
							   ,[CREATED_BY]
							   ,[CREATION_DATE]
							   ,[LAST_UPDATED_BY]
							   ,[LAST_UPDATE_DATE]
							  )
                        SELECT  T1.DIVISION_ID
							   ,T1.PLAN_START_YYYYMMDD
							   ,T1.PLAN_TYPE
							   ,T1.SEQ
							   ,@V_VER
							   ,T1.NICK_NAME
							   ,T1.PLANT_ID
							   ,T1.CELL_PLANT_SITE
							   ,T1.FROM_SITE					
							   ,T1.FROM_SITE_DESCRIPTION
						       ,T1.TO_SITE
							   ,T1.TO_BOH_QTY
							   ,T1.BOD_ID
							   ,T1.TRANSPORT_MODE_LINE
							   ,T1.MEASURE
							   ,T1.SHIP_PLAN_QTY								
							   ,ISNULL(T1.END_CUSTOMER,'-')
							   ,T1.PRODUCTION_TYPE
							   ,T1.EXTRA_SPEC
							   ,T1.ITEM_ID
							   ,T1.CELL_ITEM_ID
							   ,T1.BIZ_TYPE
			                   ,T1.INCOTERMS
							   ,T1.CELL_AGING_LT
							   ,T1.CELL_EOL_SHIPPING_LOT
							   ,T1.PACK_INCOMMING
							   ,T1.PACK_OPERATION_LT
							   ,T1.SHIPMENT_CELL_INSPECTION_LOAD
							   ,T1.SHIPMENT_CELL_INSPECTION_WAITING
							   ,T1.SHIPMENT_PACK_INSPECTION_LOAD
							   ,T1.SHIPMENT_PACK_INSPECTION_WAITING
							   ,T1.DNI_CELL_DEPARTURE_DAYS				
							   ,T1.DNI_CELL_DEPARTURE_INLAND			
							   ,T1.DNI_CELL_WAITING_FOR_SHIPPING		
							   ,T1.DNI_CELL_VOYAGE						
							   ,T1.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE	
							   ,T1.DNI_CELL_ARRIVAL_INLAND
							   ,T1.DNI_PACK_DEPARTURE_DAYS
							   ,T1.DNI_PACK_DEPARTURE_INLAND
							   ,T1.DNI_PACK_WAITING_FOR_SHIPPING
							   ,T1.DNI_PACK_VOYAGE
							   ,T1.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
							   ,T1.DNI_PACK_ARRIVAL_INLAND             
							   ,T1.PRE_INSPECTION_CELL
							   ,T1.PRE_INSPECTION_PACK
							   ,T1.VMI_CELL
							   ,T1.VMI_PACK
							   ,T1.FOREIGN_CORP
							   ,T1.RACK_BIZ
							   ,T1.DEPARTURE_INTRANSIT_VMI
							   ,T1.SAFETY_STOCK_CELL
							   ,T1.SAFETY_STOCK_PACK
							   ,T1.OTHER_STOCK_CELL
							   ,T1.OTHER_STOCK_PACK
							   ,T1.PRODUCTION_CYCLE_CELL
							   ,T1.PRODUCTION_CYCLE_PACK
							   ,T1.STANDARD_DIO
							   ,T1.ASSEMBLY_QTY
							   ,T1.ASSEMBLY_TYPE_RATIO
							   ,T1.ASSEMBLY_TOTAL_RATIO
							   ,T1.WEIGHT_DIO
							   ,T1.SHIP_PLAN_WEIGHT
							   ,T1.CREATED_BY
							   ,T1.CREATION_DATE
							   ,T1.LAST_UPDATED_BY
							   ,T1.LAST_UPDATE_DATE
						FROM (
						       SELECT
                                A.DIVISION_ID
							   ,A.PLAN_START_YYYYMMDD
							   ,A.PLAN_TYPE
							   ,A.SEQ
							   ,A.NICK_NAME
							   ,A.PLANT_ID
							   ,MAX(A.END_CUSTOMER)    					AS END_CUSTOMER
							   ,REPLACE(STUFF((SELECT ',' + X1.PLANT_ID
											     FROM #TMP_REPORT_CELL_PLANT_SITE_SEMI X1 WITH(NOLOCK)  
												WHERE A.NICK_NAME = X1.NICK_NAME 
												  FOR XML PATH('')
									          ),1,1,''),' ','')		AS CELL_PLANT_SITE
							   ,MAX(A.FROM_SITE)					AS FROM_SITE					
							   ,MAX(A.FROM_SITE_DESCRIPTION)		AS FROM_SITE_DESCRIPTION
						       ,MAX(A.TO_SITE)						AS TO_SITE			
							   ,MAX(A.TO_BOH_QTY)					AS TO_BOH_QTY
							   ,MAX(A.BOD_ID)						AS BOD_ID
							   ,MAX(A.TRANSPORT_MODE_LINE)			AS TRANSPORT_MODE_LINE
							   ,MAX(A.MEASURE)						AS MEASURE
							   ,MAX(A.SHIP_PLAN_QTY)				AS SHIP_PLAN_QTY	
							   ,MAX(A.PRODUCTION_TYPE)				AS PRODUCTION_TYPE
							   ,MAX(A.EXTRA_SPEC)					AS EXTRA_SPEC
							   ,MAX(B.ITEM_ID)						AS ITEM_ID
							   ,MAX(A.CELL_ITEM_ID)					AS CELL_ITEM_ID
							   ,REPLACE(STUFF((SELECT ',' + X1.BIZ_TYPE
											     FROM #TMP_REPORT_BIZ_TYPE X1 WITH(NOLOCK)  
												WHERE A.PLANT_ID = X1.PLANT_ID
												  AND A.NICK_NAME = X1.NICK_NAME
												  FOR XML PATH('')
									          ),1,1,''),' ','')				AS BIZ_TYPE
			                   ,REPLACE(STUFF((SELECT ',' + X2.INCOTERMS
					                             FROM #TMP_REPORT_INCOTERMS X2 WITH(NOLOCK)  
						                        WHERE A.PLANT_ID = X2.PLANT_ID
						                         AND A.NICK_NAME = X2.NICK_NAME
												  FOR XML PATH('')
											  ),1,1,''),' ','')				AS INCOTERMS
							   ,MAX(A.CELL_AGING_LT)						AS CELL_AGING_LT
							   ,MAX(A.CELL_EOL_SHIPPING_LOT)				AS CELL_EOL_SHIPPING_LOT
							   ,MAX(A.PACK_INCOMMING)						AS PACK_INCOMMING
							   ,MAX(A.PACK_OPERATION_LT)					AS PACK_OPERATION_LT
							   ,MAX(A.SHIPMENT_CELL_INSPECTION_LOAD)		AS SHIPMENT_CELL_INSPECTION_LOAD
							   ,MAX(A.SHIPMENT_CELL_INSPECTION_WAITING)		AS SHIPMENT_CELL_INSPECTION_WAITING
							   ,MAX(A.SHIPMENT_PACK_INSPECTION_LOAD)		AS SHIPMENT_PACK_INSPECTION_LOAD
							   ,MAX(A.SHIPMENT_PACK_INSPECTION_WAITING)		AS SHIPMENT_PACK_INSPECTION_WAITING

							   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
							   -- SEMI
							   ,ISNULL(MAX(R2.DEPART_DAYS), 0)						AS DNI_CELL_DEPARTURE_DAYS												
							   ,ISNULL(MAX(R2.LT_DEPARTURE_INLAND), 0)				AS DNI_CELL_DEPARTURE_INLAND
							   ,ISNULL(MAX(R2.LT_WAIT_SHIPPING), 0)					AS DNI_CELL_WAITING_FOR_SHIPPING
							   ,ISNULL(MAX(R2.LT_VOYAGE), 0)						AS DNI_CELL_VOYAGE
							   ,ISNULL(MAX(R2.LT_LAY_OFF_CLEARANCE), 0)				AS DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
							   ,ISNULL(MAX(R2.LT_ARRIVAL_INLAND), 0)				AS DNI_CELL_ARRIVAL_INLAND
							   -- FG
							   ,ISNULL(MAX(R.DEPART_DAYS), 0)						AS DNI_PACK_DEPARTURE_DAYS
							   ,ISNULL(MAX(R.INCOTERMS_LT_DEPARTURE_INLAND), 0)		AS DNI_PACK_DEPARTURE_INLAND
							   ,ISNULL(MAX(R.INCOTERMS_LT_WAIT_SHIPPING), 0)		AS DNI_PACK_WAITING_FOR_SHIPPING
							   ,ISNULL(MAX(R.INCOTERMS_LT_VOYAGE), 0)				AS DNI_PACK_VOYAGE
							   ,ISNULL(MAX(R.INCOTERMS_LT_LAY_OFF_CLEARANCE), 0)	AS DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
							   ,ISNULL(MAX(R.INCOTERMS_LT_ARRIVAL_INLAND), 0)		AS DNI_PACK_ARRIVAL_INLAND                 

							   ,MAX(A.PRE_INSPECTION_CELL)					AS PRE_INSPECTION_CELL
							   ,MAX(A.PRE_INSPECTION_PACK)					AS PRE_INSPECTION_PACK
							   ,MAX(A.VMI_CELL)								AS VMI_CELL
							   ,MAX(A.VMI_PACK)								AS VMI_PACK
							   ,MAX(A.FOREIGN_CORP)							AS FOREIGN_CORP
							   ,MAX(A.RACK_BIZ)								AS RACK_BIZ
							   ,MAX(A.DEPARTURE_INTRANSIT_VMI)				AS DEPARTURE_INTRANSIT_VMI
							   ,MAX(A.SAFETY_STOCK_CELL)					AS SAFETY_STOCK_CELL
							   ,MAX(A.SAFETY_STOCK_PACK)					AS SAFETY_STOCK_PACK
							   ,MAX(A.OTHER_STOCK_CELL)						AS OTHER_STOCK_CELL
							   ,MAX(A.OTHER_STOCK_PACK)						AS OTHER_STOCK_PACK
							   ,MAX(A.PRODUCTION_CYCLE_CELL)				AS PRODUCTION_CYCLE_CELL
							   ,MAX(A.PRODUCTION_CYCLE_PACK)				AS PRODUCTION_CYCLE_PACK
							   ,MAX(A.STANDARD_DIO)							AS STANDARD_DIO
							   ,MAX(A.ASSEMBLY_QTY)							AS ASSEMBLY_QTY
							   ,MAX(A.ASSEMBLY_TYPE_RATIO)					AS ASSEMBLY_TYPE_RATIO
							   ,MAX(A.ASSEMBLY_TOTAL_RATIO)					AS ASSEMBLY_TOTAL_RATIO
							   ,MAX(A.WEIGHT_DIO)							AS WEIGHT_DIO
							   ,MAX(R.SITE_WEIGHT)							AS SHIP_PLAN_WEIGHT  -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
							   ,@P_CREATED_BY								AS CREATED_BY
							   ,GETDATE()									AS CREATION_DATE
							   ,@P_CREATED_BY								AS LAST_UPDATED_BY
							   ,GETDATE()									AS LAST_UPDATE_DATE
						FROM #REPORT2 A 								 
							INNER JOIN #MAX_SHIP_PLAN  B
									ON A.NICK_NAME				= B.NICK_NAME
								   AND A.PLANT_ID				= B.PLANT_ID	  -- nick_name별로 SHIP_PLAN cell 환산 수량 비중이 높은 Plant/end_customer 하나만 선택  
								   AND A.END_CUSTOMER			= B.END_CUSTOMER  -- nick_name별로 SHIP_PLAN cell 환산 수량 비중이 높은 Plant/end_customer 하나만 선택  

							-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
							LEFT JOIN #DEPARTURE_LT R				
								   ON A.NICK_NAME = R.NICK_NAME
								  AND R.SITE_TYPE = 'SALES'		-- FG 
							LEFT JOIN #DEPARTURE_LT R2				
								   ON A.NICK_NAME = R2.NICK_NAME
								  AND R2.SITE_TYPE = 'PLANT'	-- SEMI 

					   WHERE 1=1
					     AND A.MEASURE				= 'SHIP_PLAN'
						 AND A.SITE_TYPE			= 'SALES'
						 AND A.DIVISION_ID			= @P_DIVISION_ID
						 AND A.PLAN_TYPE			= @V_PLAN_TYPE
						 AND A.PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD  
						 AND A.SEQ					= @P_SEQ 
						 AND A.SITE_TYPE			IS NOT NULL  --조건 추가
				       GROUP BY A.DIVISION_ID
				  		       ,A.PLAN_START_YYYYMMDD
						       ,A.PLAN_TYPE
						       ,A.SEQ
						       ,A.PLANT_ID	
						       --,A.TO_PLANT_ID	
						       ,A.NICK_NAME

				) AS T1


	    -----------------------------------------------------------------------------------------------	
		-- DIO_REPORT 이력 저장
		-----------------------------------------------------------------------------------------	
			   -- 이력 저장
			  DELETE SCP_ANL_DIO_REPORT_H
			   WHERE 1=1
				AND PLAN_TYPE = @V_PLAN_TYPE
				AND MEASURE = 'SHIP_PLAN'
				AND DIVISION_ID = @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD 
				AND SEQ = @P_SEQ -- '1'						
				AND VER = @V_VER
				AND VERSION = 0
			
			  INSERT  INTO  SCP_ANL_DIO_REPORT_H (   DIVISION_ID
													,PLAN_START_YYYYMMDD
													,PLAN_TYPE
													,SEQ
													,VER
													,NICK_NAME
													,PLANT_ID
													,VERSION
													,FROM_SITE_DESCRIPTION
													,TO_SITE
													,TO_BOH_QTY
													,BOD_ID
													,TRANSPORT_MODE_LINE
													,MEASURE
													,SHIP_PLAN_QTY
													,END_CUSTOMER
													,PRODUCTION_TYPE
													,EXTRA_SPEC
													,ITEM_ID
													,CELL_ITEM_ID
													,BIZ_TYPE
													,INCOTERMS
													,CELL_AGING_LT
													,CELL_EOL_SHIPPING_LOT
													,PACK_INCOMMING
													,PACK_OPERATION_LT
													,SHIPMENT_CELL_INSPECTION_LOAD
													,SHIPMENT_CELL_INSPECTION_WAITING
													,SHIPMENT_PACK_INSPECTION_LOAD
													,SHIPMENT_PACK_INSPECTION_WAITING
													,DNI_CELL_DEPARTURE_DAYS
													,DNI_CELL_DEPARTURE_INLAND
													,DNI_CELL_WAITING_FOR_SHIPPING
													,DNI_CELL_VOYAGE
													,DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
													,DNI_CELL_ARRIVAL_INLAND
													,DNI_PACK_DEPARTURE_DAYS
													,DNI_PACK_DEPARTURE_INLAND
													,DNI_PACK_WAITING_FOR_SHIPPING
													,DNI_PACK_VOYAGE
													,DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
													,DNI_PACK_ARRIVAL_INLAND
													,PRE_INSPECTION_CELL
													,PRE_INSPECTION_PACK
													,VMI_CELL
													,VMI_PACK
													,FOREIGN_CORP
													,RACK_BIZ
													,DEPARTURE_INTRANSIT_VMI
													,SAFETY_STOCK_CELL
													,SAFETY_STOCK_PACK
													,OTHER_STOCK_CELL
													,OTHER_STOCK_PACK
													,PRODUCTION_CYCLE_CELL
													,PRODUCTION_CYCLE_PACK
													,STANDARD_DIO
													,ASSEMBLY_QTY
													,ASSEMBLY_TYPE_RATIO
													,ASSEMBLY_TOTAL_RATIO
													,WEIGHT_DIO
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE)
											 SELECT  DIVISION_ID
													,PLAN_START_YYYYMMDD
													,PLAN_TYPE
													,SEQ
													,@V_VER
													,NICK_NAME
													,PLANT_ID
													,0
													,FROM_SITE_DESCRIPTION
													,TO_SITE
													,TO_BOH_QTY
													,BOD_ID
													,TRANSPORT_MODE_LINE
													,MEASURE
													,SHIP_PLAN_QTY
													,END_CUSTOMER
													,PRODUCTION_TYPE
													,EXTRA_SPEC
													,ITEM_ID
													,CELL_ITEM_ID
													,BIZ_TYPE
													,INCOTERMS
													,CELL_AGING_LT
													,CELL_EOL_SHIPPING_LOT
													,PACK_INCOMMING
													,PACK_OPERATION_LT
													,SHIPMENT_CELL_INSPECTION_LOAD
													,SHIPMENT_CELL_INSPECTION_WAITING
													,SHIPMENT_PACK_INSPECTION_LOAD
													,SHIPMENT_PACK_INSPECTION_WAITING
													,DNI_CELL_DEPARTURE_DAYS
													,DNI_CELL_DEPARTURE_INLAND
													,DNI_CELL_WAITING_FOR_SHIPPING
													,DNI_CELL_VOYAGE
													,DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
													,DNI_CELL_ARRIVAL_INLAND
													,DNI_PACK_DEPARTURE_DAYS
													,DNI_PACK_DEPARTURE_INLAND
													,DNI_PACK_WAITING_FOR_SHIPPING
													,DNI_PACK_VOYAGE
													,DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
													,DNI_PACK_ARRIVAL_INLAND
													,PRE_INSPECTION_CELL
													,PRE_INSPECTION_PACK
													,VMI_CELL
													,VMI_PACK
													,FOREIGN_CORP
													,RACK_BIZ
													,DEPARTURE_INTRANSIT_VMI
													,SAFETY_STOCK_CELL
													,SAFETY_STOCK_PACK
													,OTHER_STOCK_CELL
													,OTHER_STOCK_PACK
													,PRODUCTION_CYCLE_CELL
													,PRODUCTION_CYCLE_PACK
													,STANDARD_DIO
													,ASSEMBLY_QTY
													,ASSEMBLY_TYPE_RATIO
													,ASSEMBLY_TOTAL_RATIO
													,WEIGHT_DIO
													,CREATED_BY
													,CREATION_DATE
													,LAST_UPDATED_BY
													,LAST_UPDATE_DATE
												FROM SCP_ANL_DIO_REPORT  WITH(NOLOCK) 
												WHERE DIVISION_ID = @P_DIVISION_ID
												  AND PLAN_TYPE = @V_PLAN_TYPE
												  AND MEASURE = 'SHIP_PLAN'
												  AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD   
												  AND SEQ = @P_SEQ 
												  AND VER = @V_VER
		---			  SET @RETURN = '1'	  
		---		  END
		---		  ELSE
		---				BEGIN
		---					SET @RETURN = '2'
		---				END
		---		  SELECT @RETURN AS RESULT;
				  
		-------------------------------------------------------------------------------
        --   주기 재고 처리 : 주기재고(CYCLE_INVENTORY)는 자동차(81, 81_UC)만 해당함.
		-------------------------------------------------------------------------------
          -- PJ20216891
	   	  IF @P_DIVISION_ID IN ( SELECT DIVISION_ID FROM @v_tb_target_division )
	   	  -- IF @P_DIVISION_ID = '81' 

		  BEGIN	
		  -- 주기 재고용
				SELECT A.DIVISION_ID
				    , [PLAN_START_YYYYMMDD]
				    , [PLAN_TYPE]
				    , [SEQ]
				    , PLANT_ID
				    , FROM_SITE
				    , [ITEM_ID]
					, [CELL_ITEM_ID]
				    , CASE WHEN A.OPERATION_GROUP = 'A' THEN 'CELL' 
						   WHEN A.OPERATION_GROUP = 'P' THEN 'PACK' 
						   END [BIZ_TYPE]
					, [INCOTERMS]		   
					, A.OPERATION_GROUP
					, [TO_SITE] 
					, [TO_BOH_QTY] 
					, [BOD_ID] 
					, [TRANSPORT_MODE_LINE]
					, [MEASURE]
					, SUBSTRING(YYYYMMDD,1,6) AS YYYYMM
					, SUM([QTY])AS  SUMQTY
				INTO #CYCLE_INVENTORY1
				FROM [DBO].[SCP_ANL_PSI_GLOBAL] A WITH(NOLOCK)
				LEFT JOIN SCM_MST_SITE X WITH(NOLOCK) 
				  ON X. DIVISION_ID = A.DIVISION_ID
				 AND X.SCM_SITE_ID = A.FROM_SITE
				 AND X.VALID_YN = 'Y'
			   WHERE A.DIVISION_ID = @P_DIVISION_ID
				 AND PLAN_TYPE = @V_PLAN_TYPE
				 AND MEASURE IN ( 'PRODUCTION')
				 AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD 
				 AND SEQ =  @P_SEQ
				 AND SUBSTRING(YYYYMMDD,1,6) BETWEEN @V_FROM_YYYYMM AND @V_TO_YYYYMM
				 AND QTY <> 0 
				 AND MEASURE = 'PRODUCTION'
			   GROUP BY A.DIVISION_ID
					,[PLAN_START_YYYYMMDD]
					,[PLAN_TYPE]
					,[SEQ]
					, A.OPERATION_GROUP
					,[ITEM_ID]
					,[CELL_ITEM_ID]
					,[TO_SITE]
					,[TO_BOH_QTY]
					,[INCOTERMS]
					,PLANT_ID
					,FROM_SITE
					,BOD_ID
					,[TRANSPORT_MODE_LINE]
					,[MEASURE]
					, LEFT(YYYYMMDD,6)
			
				   --주기재고(CYCLE_INVENTORY)는 자동차(81, 81_UC)만 해당함.
   
				SELECT A.*
					, ISNULL(C.NICK_NAME ,'') NICK_NAME 
					, C.MATERIAL_CLASS_NAME
					, C.TYPE
					, C.CELL_GROUP
					, C.PACK_GROUP
				INTO #CYCLE_INVENTORY2
				FROM #CYCLE_INVENTORY1 A
				LEFT JOIN #TblDynamicPivot_CLASS_TYPE C
				ON A.DIVISION_ID = C.DIVISION_ID 
				AND A.ITEM_ID = C.ITEM_ID

				BEGIN TRAN
 				  WHILE (1=1)
						BEGIN
 							DELETE TOP(4000) FROM SCP_ANL_DIO_CYCLE_INVENTORY
							WHERE DIVISION_ID = @P_DIVISION_ID 
							  AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
							  AND SEQ = @P_SEQ
							  AND VER = @V_VER
 	 		
 							IF @@ROWCOUNT = 0 BREAK;
						END
				COMMIT 


				INSERT INTO  SCP_ANL_DIO_CYCLE_INVENTORY([DIVISION_ID]
														,[PLAN_START_YYYYMMDD]
														,[PLAN_TYPE]
														,[SEQ]
														,[VER]
														,[NICK_NAME]
														,[PLANT_ID]
														,[FROM_SITE]
														,[TRANSPORT_MODE_LINE]																			  
														,[PACK_GROUP]
														,[CELL_GROUP]
														,[FROM_SITE_DESCRIPTION]
														,[OPERATION_GROUP]
														,[DATA_RANGE]
														,[M1]
														,[M2]
														,[M3]
														,[M4]
														,[M5]
														,[M6]
														,[M7]
														,[M8]
														,[M9]
														,[M10]
														,[M11]
														,[M12]
														,[CYCLE]
														,[CREATED_BY]
														,[CREATION_DATE])
				SELECT A.DIVISION_ID
					,A.PLAN_START_YYYYMMDD
					,RTRIM(A.PLAN_TYPE) AS	PLAN_TYPE
					,A.SEQ
					,@V_VER
					,A.NICK_NAME
					,RTRIM(A.PLANT_ID) AS PLANT_ID
					,RTRIM(A.FROM_SITE) AS FROM_SITE
					,RTRIM(A.TRANSPORT_MODE_LINE) AS TRANSPORT_MODE_LINE 
					,MAX(PACK_GROUP) AS PACK_GROUP
					,MAX(CELL_GROUP) AS CELL_GROUP
					,RTRIM(MAX(S.SITE_DESCRIPTION)) AS FROM_SITE_DESCRIPTION
					,RTRIM(A.OPERATION_GROUP)
					,@P_MONTH
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 1, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M1
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 2, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M2
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 3, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M3
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 4, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M4
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 5, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M5
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M6
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 7, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M7
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 8, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M8
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 9, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M9
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 10, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M10
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 11, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M11
					,ISNULL(SUM(CASE WHEN YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 12, convert(datetime, @P_PLAN_START_YYYYMMDD)), 112),1,6) THEN SUMQTY END ),0) AS M12
					,0
					,@P_CREATED_BY
					,GETDATE()
			   FROM #CYCLE_INVENTORY2 A
			   LEFT JOIN #SCM_MST_SITE S
				 ON A.DIVISION_ID = S.DIVISION_ID
				AND A.PLANT_ID   =  S.LOGISTIC_PLANT_ID 
				AND A.OPERATION_GROUP = S.OPERATION_GROUP  
			  GROUP BY A.DIVISION_ID
				 ,A.PLAN_START_YYYYMMDD
				 ,A.PLAN_TYPE
				 ,A.SEQ
				 ,A.NICK_NAME
				 ,A.PLANT_ID
				 ,A.FROM_SITE
				 ,A.OPERATION_GROUP
				 ,A.TRANSPORT_MODE_LINE

		END -- IF @P_DIVISION_ID IN ( SELECT DIVISION_ID FROM @v_tb_target_division )

		---------------------------------------------------------------------------------------------------------
		-- 임시 테이블 삭제
		--------------------------------------------------------------------------------------------------------  
        IF OBJECT_ID('tempdb..#LAST_PLAN') IS NOT NULL
        DROP TABLE #LAST_PLAN;

        IF OBJECT_ID('tempdb..#LAST_PLAN_KEYIN') IS NOT NULL
        DROP TABLE #LAST_PLAN_KEYIN;

        IF OBJECT_ID('tempdb..#REPORT1') IS NOT NULL
        DROP TABLE #REPORT1;

        IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL
        DROP TABLE #SCM_MST_SITE;

        IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
        DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;

        IF OBJECT_ID('tempdb..#TblDynamicPivot_CLASS_TYPE_TEMP') IS NOT NULL
        DROP TABLE #TblDynamicPivot_CLASS_TYPE_TEMP;

        IF OBJECT_ID('tempdb..#TblDynamicPivot_CLASS_TYPE') IS NOT NULL
        DROP TABLE #TblDynamicPivot_CLASS_TYPE;

        IF OBJECT_ID('tempdb..#REPORT1_1') IS NOT NULL
        DROP TABLE #REPORT1_1;

        IF OBJECT_ID('tempdb..#REPORT1_2') IS NOT NULL
        DROP TABLE #REPORT1_2;

        IF OBJECT_ID('tempdb..#LINE_SUM') IS NOT NULL
        DROP TABLE #LINE_SUM;

        IF OBJECT_ID('tempdb..#LINE_WEIGHT') IS NOT NULL
        DROP TABLE #LINE_WEIGHT;

        IF OBJECT_ID('tempdb..#SCP_MST_FORMATION_LINE') IS NOT NULL
        DROP TABLE #SCP_MST_FORMATION_LINE;

        IF OBJECT_ID('tempdb..#SCP_MST_FORMATION_LINE_ITEM') IS NOT NULL
        DROP TABLE #SCP_MST_FORMATION_LINE_ITEM;

        IF OBJECT_ID('tempdb..#AGING_LT') IS NOT NULL
        DROP TABLE #AGING_LT;

        IF OBJECT_ID('tempdb..#AGING_LT_N') IS NOT NULL
        DROP TABLE #AGING_LT_N;

        IF OBJECT_ID('tempdb..#REPORT1_3') IS NOT NULL
        DROP TABLE #REPORT1_3;

        IF OBJECT_ID('tempdb..#REPORT1_3_1') IS NOT NULL
        DROP TABLE #REPORT1_3_1;

        IF OBJECT_ID('tempdb..#REPORT1_4') IS NOT NULL
        DROP TABLE #REPORT1_4;

        IF OBJECT_ID('tempdb..#MAX_SHIP_PLAN') IS NOT NULL
        DROP TABLE #MAX_SHIP_PLAN;

        IF OBJECT_ID('tempdb..#OPERATION_LT') IS NOT NULL
        DROP TABLE #OPERATION_LT;

        IF OBJECT_ID('tempdb..#REPORT2') IS NOT NULL
        DROP TABLE #REPORT2;

        IF OBJECT_ID('tempdb..#TMP_REPORT_BIZ_TYPE') IS NOT NULL
        DROP TABLE #TMP_REPORT_BIZ_TYPE;

        IF OBJECT_ID('tempdb..#TMP_REPORT_INCOTERMS') IS NOT NULL
        DROP TABLE #TMP_REPORT_INCOTERMS;

        IF OBJECT_ID('tempdb..#TMP_REPORT_CELL_PLANT_SITE_SEMI') IS NOT NULL
        DROP TABLE #TMP_REPORT_CELL_PLANT_SITE_SEMI;

        IF OBJECT_ID('tempdb..#CYCLE_INVENTORY1') IS NOT NULL
        DROP TABLE #CYCLE_INVENTORY1;

        IF OBJECT_ID('tempdb..#CYCLE_INVENTORY2') IS NOT NULL
        DROP TABLE #CYCLE_INVENTORY2;

		-- begin - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
        IF OBJECT_ID('tempdb..#SUMQTY_NICKNAME') IS NOT NULL
        DROP TABLE #SUMQTY_NICKNAME;	

        IF OBJECT_ID('tempdb..#BOD_WEIGHT') IS NOT NULL
        DROP TABLE #BOD_WEIGHT;	

        IF OBJECT_ID('tempdb..#BOD_LT') IS NOT NULL
        DROP TABLE #BOD_LT;	

        IF OBJECT_ID('tempdb..#DEPARTURE_LT') IS NOT NULL
        DROP TABLE #DEPARTURE_LT;	
		-- end - PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응

     END TRY

     BEGIN CATCH     

 	   ----------------------------------------------------------------------------------------------------
	   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가
	   -- 오류발생시 등록된 버전정보 삭제 
	   ----------------------------------------------------------------------------------------------------
	   DELETE SCP_ANL_DIO_REPORT_VERSION
		WHERE DIVISION_ID		  = @P_DIVISION_ID
		  AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
		  AND PLAN_TYPE			  = @V_PLAN_TYPE
		  AND SEQ				  = @P_SEQ
		  AND VER				  = @V_VER
		  AND VER_STATUS		  = 'P' 
		  ;

      SET @v_log_type = N'ERROR';                  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
      SET @d_event_date = SYSDATETIME();                  
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                                ,@p_log_type      =@v_log_type                  
                                ,@p_log_count     =@n_log_count                   
                                ,@p_log_message   =@v_log_message                   
                                ,@p_description   =@v_description                   
                                ,@p_event_date    =@d_event_date                   
                                ,@p_user_id       =@v_batch_user                  
                                ;                  
          PRINT @@ERROR    
	   PRINT @v_log_message + ' : ' + @v_description;

      return -1      
    END CATCH;  

	----------------------------------------------------------------------------------------------------
	-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가
	-- 데이터 생성 완료시 버전 상태 정보 업데이트 
	----------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT TOP 1 *
					 FROM SCP_ANL_DIO_REPORT WITH(NOLOCK)
					WHERE DIVISION_ID			= @P_DIVISION_ID
					  AND PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD
					  AND PLAN_TYPE				= @V_PLAN_TYPE
					  AND SEQ				    = @P_SEQ
					  AND VER				    = @V_VER)
		BEGIN
			-- 버전 상태 업데이트 (완료) 
			UPDATE SCP_ANL_DIO_REPORT_VERSION
			  SET VER_STATUS = 'C'
				, LAST_UPDATE_DATE = GETDATE()
			WHERE DIVISION_ID			= @P_DIVISION_ID
			  AND PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD
			  AND PLAN_TYPE				= @V_PLAN_TYPE
			  AND SEQ				    = @P_SEQ
			  AND VER				    = @V_VER
			  ;
		END
	ELSE
		BEGIN
			-- 생성된 데이터가 없으면 버전 삭제
			DELETE FROM SCP_ANL_DIO_REPORT_VERSION
			WHERE DIVISION_ID			= @P_DIVISION_ID
			  AND PLAN_START_YYYYMMDD	= @P_PLAN_START_YYYYMMDD
			  AND PLAN_TYPE				= @V_PLAN_TYPE
			  AND SEQ				    = @P_SEQ
			  AND VER				    = @V_VER
			  ;
		END

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 

    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'########## END of procedure  ##########';                  
    SET @v_description = N'['+ @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;  
	
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
   return 1      

END 
