CREATE PROCEDURE [dbo].[PR_SCM_OF_ELEC_CALCULATION_SIM]
  @p_user_id           varchar(100)
 ,@p_instance_id       nvarchar(30)   
 ,@p_plan_id	         nvarchar(30)   
 ,@p_company_id        nvarchar(30)  
 ,@p_division_id       nvarchar(30)  
 ,@p_site_id           nvarchar(30)  
 ,@p_plant_id          nvarchar(30)
 ,@p_factory_id	       nvarchar(30)  
 ,@p_location          nvarchar(30)
 ,@p_operation_id	     nvarchar(30)   
 ,@p_line_id	         nvarchar(30)   
 ,@p_electrode_type    nvarchar(30) 
 ,@p_equipment_id      nvarchar(30) 
 ,@p_item_id	         nvarchar(100)   
 ,@p_top_item_id	     nvarchar(100)   
 ,@p_production_type	 nvarchar(30)         
 ,@p_market	           nvarchar(30)   
 ,@p_batch_id          nvarchar(30) 
 ,@p_version           nvarchar(30)
 ,@p_qty001 numeric (20,10) = 0.0 ,@p_qty002  numeric (20,10) = 0.0 ,@p_qty003  numeric (20,10) = 0.0 ,@p_qty004  numeric (20,10) = 0.0 ,@p_qty005  numeric (20,10) = 0.0
 ,@p_qty006	numeric (20,10) = 0.0 ,@p_qty007  numeric (20,10) = 0.0 ,@p_qty008  numeric (20,10) = 0.0 ,@p_qty009  numeric (20,10) = 0.0 ,@p_qty010  numeric (20,10) = 0.0
 ,@p_qty011 numeric (20,10) = 0.0 ,@p_qty012  numeric (20,10) = 0.0 ,@p_qty013  numeric (20,10) = 0.0 ,@p_qty014  numeric (20,10) = 0.0 ,@p_qty015  numeric (20,10) = 0.0
 ,@p_qty016	numeric (20,10) = 0.0 ,@p_qty017  numeric (20,10) = 0.0 ,@p_qty018  numeric (20,10) = 0.0 ,@p_qty019  numeric (20,10) = 0.0 ,@p_qty020  numeric (20,10) = 0.0
 ,@p_qty021 numeric (20,10) = 0.0 ,@p_qty022  numeric (20,10) = 0.0 ,@p_qty023  numeric (20,10) = 0.0 ,@p_qty024  numeric (20,10) = 0.0 ,@p_qty025  numeric (20,10) = 0.0
 ,@p_qty026	numeric (20,10) = 0.0 ,@p_qty027  numeric (20,10) = 0.0 ,@p_qty028  numeric (20,10) = 0.0 ,@p_qty029  numeric (20,10) = 0.0 ,@p_qty030  numeric (20,10) = 0.0
 ,@p_qty031 numeric (20,10) = 0.0 ,@p_qty032  numeric (20,10) = 0.0 ,@p_qty033  numeric (20,10) = 0.0 ,@p_qty034  numeric (20,10) = 0.0 ,@p_qty035  numeric (20,10) = 0.0
 ,@p_qty036	numeric (20,10) = 0.0 ,@p_qty037  numeric (20,10) = 0.0 ,@p_qty038  numeric (20,10) = 0.0 ,@p_qty039  numeric (20,10) = 0.0 ,@p_qty040  numeric (20,10) = 0.0
 ,@p_qty041 numeric (20,10) = 0.0 ,@p_qty042  numeric (20,10) = 0.0 ,@p_qty043  numeric (20,10) = 0.0 ,@p_qty044  numeric (20,10) = 0.0 ,@p_qty045  numeric (20,10) = 0.0
 ,@p_qty046	numeric (20,10) = 0.0 ,@p_qty047  numeric (20,10) = 0.0 ,@p_qty048  numeric (20,10) = 0.0 ,@p_qty049  numeric (20,10) = 0.0 ,@p_qty050  numeric (20,10) = 0.0
 ,@p_qty051 numeric (20,10) = 0.0 ,@p_qty052  numeric (20,10) = 0.0 ,@p_qty053  numeric (20,10) = 0.0 ,@p_qty054  numeric (20,10) = 0.0 ,@p_qty055  numeric (20,10) = 0.0
 ,@p_qty056	numeric (20,10) = 0.0 ,@p_qty057  numeric (20,10) = 0.0 ,@p_qty058  numeric (20,10) = 0.0 ,@p_qty059  numeric (20,10) = 0.0 ,@p_qty060  numeric (20,10) = 0.0
 ,@p_qty061 numeric (20,10) = 0.0 ,@p_qty062  numeric (20,10) = 0.0 ,@p_qty063  numeric (20,10) = 0.0 ,@p_qty064  numeric (20,10) = 0.0 ,@p_qty065  numeric (20,10) = 0.0
 ,@p_qty066	numeric (20,10) = 0.0 ,@p_qty067  numeric (20,10) = 0.0 ,@p_qty068  numeric (20,10) = 0.0 ,@p_qty069  numeric (20,10) = 0.0 ,@p_qty070  numeric (20,10) = 0.0
 ,@p_qty071 numeric (20,10) = 0.0 ,@p_qty072  numeric (20,10) = 0.0 ,@p_qty073  numeric (20,10) = 0.0 ,@p_qty074  numeric (20,10) = 0.0 ,@p_qty075  numeric (20,10) = 0.0
 ,@p_qty076	numeric (20,10) = 0.0 ,@p_qty077  numeric (20,10) = 0.0 ,@p_qty078  numeric (20,10) = 0.0 ,@p_qty079  numeric (20,10) = 0.0 ,@p_qty080  numeric (20,10) = 0.0
 ,@p_qty081 numeric (20,10) = 0.0 ,@p_qty082  numeric (20,10) = 0.0 ,@p_qty083  numeric (20,10) = 0.0 ,@p_qty084  numeric (20,10) = 0.0 ,@p_qty085  numeric (20,10) = 0.0
 ,@p_qty086	numeric (20,10) = 0.0 ,@p_qty087  numeric (20,10) = 0.0 ,@p_qty088  numeric (20,10) = 0.0 ,@p_qty089  numeric (20,10) = 0.0 ,@p_qty090  numeric (20,10) = 0.0
 ,@p_qty091 numeric (20,10) = 0.0 ,@p_qty092  numeric (20,10) = 0.0 ,@p_qty093  numeric (20,10) = 0.0 ,@p_qty094  numeric (20,10) = 0.0 ,@p_qty095  numeric (20,10) = 0.0
 ,@p_qty096	numeric (20,10) = 0.0 ,@p_qty097  numeric (20,10) = 0.0 ,@p_qty098  numeric (20,10) = 0.0 ,@p_qty099  numeric (20,10) = 0.0 ,@p_qty100  numeric (20,10) = 0.0
 ,@p_first_date     nvarchar(10)
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_CELL_CALCULATION_SIM                                            **/
/** 프로그램 명   : PSI_AMEND_UI 엑셀SIMULATOR CALCULATION                                    **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2019.07.31   SHS         최초 작성                                                        **/
/**                          Amend (model / line) + DPP                                       **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)    = @p_instance_id
  DECLARE @v_instance_id      nvarchar(30)   
  DECLARE @v_plan_id          nvarchar(30)    = @p_plan_id
  
  DECLARE @v_plan_date        date
  DECLARE @v_first_date       date            = convert(date,replace(@p_first_date,'-',''),112)
  DECLARE @v_sqltext          nvarchar(MAX)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_ELEC_CALCULATION_SIM'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  DECLARE @v_flag				nvarchar(30)

  -- 사용자 변수 설정

  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      BEGIN
      
        SET @v_table_name = 'PR_SCM_OF_PSI_AMEND_UI_CAL'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
        
        IF CHARINDEX('DEV', USER) = 0  -- 운영
        SET @v_instance_id = @v_master_id
        ELSE 
        SET @v_instance_id = @v_master_id + '_DEV' -- 개발
       
        
        SELECT @v_plan_date = PLAN_DATE
        FROM  (
              SELECT CONVERT(DATE, A.PLAN_START_TIME , 112) as PLAN_DATE
              FROM   SCM_FP_PLAN_H A
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.PLAN_ID    = @v_plan_id
              ) A
              
        --SELECT @v_first_date = MIN(DATE_ID)
        --FROM SCM_SYS_CALENDAR_M
        --WHERE MONTH  = ( SELECT MONTH FROM DBO.SCM_SYS_CALENDAR_M WHERE  DATE_ID = @V_PLAN_DATE ) 
        
        
        BEGIN
          
          -- Parameter data set 구성 
          
          DELETE TH_BUF_SIM_DATA_ELEC WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 
          DELETE TH_BUF_ELEC_CALCULATION_SIM WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 
          
          INSERT INTO TH_BUF_SIM_DATA_ELEC
          SELECT  @p_user_id           
                 ,@p_instance_id          
                 ,@p_plan_id	       
                 ,@p_company_id       
                 ,@p_division_id       
                 ,@p_site_id          
                 ,@p_plant_id         
                 ,@p_factory_id	         
                 ,@p_location          
                 ,@p_operation_id	        
                 ,@p_line_id	            
                 ,@p_electrode_type     
                 ,@p_equipment_id       
                 ,@p_item_id	            
                 ,@p_top_item_id	        
                 ,@p_production_type	          
                 ,@p_market	              
                 ,@p_batch_id           
                 ,@p_version             
                 ,@p_qty001  ,@p_qty002   ,@p_qty003   ,@p_qty004   ,@p_qty005  
                 ,@p_qty006	 ,@p_qty007   ,@p_qty008   ,@p_qty009   ,@p_qty010  
                 ,@p_qty011  ,@p_qty012   ,@p_qty013   ,@p_qty014   ,@p_qty015  
                 ,@p_qty016	 ,@p_qty017   ,@p_qty018   ,@p_qty019   ,@p_qty020  
                 ,@p_qty021  ,@p_qty022   ,@p_qty023   ,@p_qty024   ,@p_qty025  
                 ,@p_qty026	 ,@p_qty027   ,@p_qty028   ,@p_qty029   ,@p_qty030  
                 ,@p_qty031  ,@p_qty032   ,@p_qty033   ,@p_qty034   ,@p_qty035  
                 ,@p_qty036	 ,@p_qty037   ,@p_qty038   ,@p_qty039   ,@p_qty040  
                 ,@p_qty041  ,@p_qty042   ,@p_qty043   ,@p_qty044   ,@p_qty045  
                 ,@p_qty046	 ,@p_qty047   ,@p_qty048   ,@p_qty049   ,@p_qty050  
                 ,@p_qty051  ,@p_qty052   ,@p_qty053   ,@p_qty054   ,@p_qty055  
                 ,@p_qty056	 ,@p_qty057   ,@p_qty058   ,@p_qty059   ,@p_qty060  
                 ,@p_qty061  ,@p_qty062   ,@p_qty063   ,@p_qty064   ,@p_qty065  
                 ,@p_qty066	 ,@p_qty067   ,@p_qty068   ,@p_qty069   ,@p_qty070  
                 ,@p_qty071  ,@p_qty072   ,@p_qty073   ,@p_qty074   ,@p_qty075  
                 ,@p_qty076	 ,@p_qty077   ,@p_qty078   ,@p_qty079   ,@p_qty080  
                 ,@p_qty081  ,@p_qty082   ,@p_qty083   ,@p_qty084   ,@p_qty085  
                 ,@p_qty086	 ,@p_qty087   ,@p_qty088   ,@p_qty089   ,@p_qty090  
                 ,@p_qty091  ,@p_qty092   ,@p_qty093   ,@p_qty094   ,@p_qty095  
                 ,@p_qty096	 ,@p_qty097   ,@p_qty098   ,@p_qty099   ,@p_qty100 
                 ,@v_first_date
          
          SET @v_table_name = 'TH_BUF_ELEC_CALCULATION_SIM'
          
          INSERT INTO TH_BUF_ELEC_CALCULATION_SIM
                (
                  INSTANCE_ID  
        				, PLAN_ID  
        				, COMPANY_ID  
        				, DIVISION_ID  
        				, SITE_ID  
        				, PLANT_ID  
        				, FACTORY_ID 
        				, LOCATION  
        				, OPERATION_ID  
        				, LINE_ID  
        				, ELECTRODE_TYPE
        				, EQUIPMENT_ID  
        				, ITEM_ID 
        				, TOP_ITEM_ID  
        				, PRODUCTION_TYPE  
        				, MARKET  
        				, BATCH_ID  
        				, VERSION  
        				, PLAN_DATE  
        				, BATCH_OUT_QTY  
        				, BATCH_IN_QTY  
                )
			 SELECT		A.INSTANCE_ID  
      						, A.PLAN_ID  
      						, A.COMPANY_ID  
      						, A.DIVISION_ID  
      						, A.SITE_ID  
      						, A.PLANT_ID  
      						, A.FACTORY_ID 
      						, A.LOCATION  
      						, A.OPERATION_ID  
      						, A.LINE_ID  
      						, A.ELECTRODE_TYPE
      						, A.EQUIPMENT_ID  
      						, A.ITEM_ID 
      						, A.TOP_ITEM_ID  
      						, A.PRODUCTION_TYPE  
      						, A.MARKET  
      						, A.BATCH_ID  
      						, A.VERSION  
      						, A.PLAN_DATE  
							, A.BATCH_IN_QTY 
						    , A.BATCH_IN_QTY  AS BATCH_OUT_QTY  
			    FROM (
  				   		SELECT    X.INSTANCE_ID  
      									, X.PLAN_ID  
      									, X.COMPANY_ID  
      									, X.DIVISION_ID  
      									, X.SITE_ID  
      									, X.PLANT_ID  
      									, X.FACTORY_ID 
      									, X.LOCATION  
      									, X.OPERATION_ID  
      									, X.LINE_ID  
      									, X.ELECTRODE_TYPE
      									, X.EQUIPMENT_ID  
      									, X.ITEM_ID 
      									, X.TOP_ITEM_ID  
      									, X.PRODUCTION_TYPE  
      									, X.MARKET  
      									, X.BATCH_ID  
      									, X.VERSION  
  										, Y.YYYYMMDD  AS PLAN_DATE
  										, QTY AS BATCH_IN_QTY
		            FROM
  			            (
  			             SELECT * 
  			             FROM TH_BUF_SIM_DATA_ELEC
  			             WHERE INSTANCE_ID = @V_MASTER_ID 
  			             AND   PLAN_ID = @V_PLAN_ID
  			             ) AS SourceTable  
			          UNPIVOT 
  			              (
  			               QTY FOR  YYYYMMDD_COLUMN IN (
  			                                             [qty001], [qty002], [qty003], [qty004], [qty005],[qty006], [qty007], [qty008], [qty009], [qty010]
  			                                            ,[qty011], [qty012], [qty013], [qty014], [qty015],[qty016], [qty017], [qty018], [qty019], [qty020]
  			                                            ,[qty021], [qty022], [qty023], [qty024], [qty025],[qty026], [qty027], [qty028], [qty029], [qty030]
  			                                            ,[qty031], [qty032], [qty033], [qty034], [qty035],[qty036], [qty037], [qty038], [qty039], [qty040]
  			                                            ,[qty041], [qty042], [qty043], [qty044], [qty045],[qty046], [qty047], [qty048], [qty049], [qty050]
  			                                            ,[qty051], [qty052], [qty053], [qty054], [qty055],[qty056], [qty057], [qty058], [qty059], [qty060]
  			                                            ,[qty061], [qty062], [qty063], [qty064], [qty065],[qty066], [qty067], [qty068], [qty069], [qty070]
  			                                            ,[qty071], [qty072], [qty073], [qty074], [qty075],[qty076], [qty077], [qty078], [qty079], [qty080]
  			                                            ,[qty081], [qty082], [qty083], [qty084], [qty085],[qty086], [qty087], [qty088], [qty089], [qty090]
  			                                            ,[qty091], [qty092], [qty093], [qty094], [qty095],[qty096], [qty097], [qty098], [qty099], [qty100]
  			                                            )  
  			              ) AS X
  			          INNER JOIN (  
                              SELECT A.DATE_ID AS YYYYMMDD    
			                              ,'qty' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY date_id) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY date_id)) AS YYYYMMDD_COLUMN
			                        FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
			                        WHERE A.DATE_ID     >= @v_first_date
  			                      )Y
  			              ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN 
			          WHERE QTY <> -9 -- 해당값 데이터는 변동 없음.
                )A
                     
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null           
  
		
		  -- AMEND DATA 동기화
          
          SET @v_table_name = 'FP_AMEND_DAILY_PLAN_R'
          
		  
          MERGE FP_AMEND_DAILY_PLAN_R AS APC
          USING (
						SELECT  INSTANCE_ID 
    							, PLAN_ID 
    							, COMPANY_ID
    							, DIVISION_ID
    							, SITE_ID
    							, PLANT_ID
    							, TOP_ITEM_ID 
    							, ITEM_ID 
    							, OPERATION_ID 
    							, FACTORY_ID 
								, LOCATION
    							, PRODUCTION_TYPE 
    							, MARKET 
    							, LINE_ID 
								, EQUIPMENT_ID 
    							, ELECTRODE_TYPE
    							, PLAN_DATE
    							, BATCH_IN_QTY
          				FROM		TH_BUF_ELEC_CALCULATION_SIM
          				WHERE	INSTANCE_ID	= @v_master_id 
          				AND		PLAN_ID			= @v_plan_id
						AND		PLAN_DATE		>= @v_plan_date
          			) AS SIM
				ON 		1=1
				AND 		APC.INSTANCE_ID	= SIM.INSTANCE_ID
				AND		APC.FP_PLAN_ID		= SIM.PLAN_ID
				AND		APC.COMPANY_ID  = SIM.COMPANY_ID
				AND		APC.DIVISION_ID	= SIM.DIVISION_ID
				AND		APC.SITE_ID			= SIM.SITE_ID
				AND		APC.PLANT_ID		= SIM.PLANT_ID
				AND		APC.FACTORY_ID	= SIM.FACTORY_ID
				AND		APC.OPERATION_ID	= SIM.OPERATION_ID 
				AND		APC.LINE_ID			= SIM.LINE_ID
				AND 		APC.EQUIPMENT_ID		= SIM.EQUIPMENT_ID
				AND		APC.ELECTRODE_TYPE	= SIM.ELECTRODE_TYPE
				AND		APC.MARKET			= SIM.MARKET
				AND		APC.PRODUCTION_TYPE	= SIM.PRODUCTION_TYPE
				AND		APC.PLAN_DATE		= SIM.PLAN_DATE
				AND		APC.TOP_ITEM_ID	= SIM.TOP_ITEM_ID
				AND		APC.ITEM_ID			= SIM.ITEM_ID 
          WHEN MATCHED  THEN
				UPDATE SET	APC.SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(SIM.BATCH_IN_QTY,0)) = 0 THEN 0 ELSE 1 END 
								, APC.ADJUST_IN_QTY_BATCH		= SIM.BATCH_IN_QTY
								, ADJUST_IN_QTY_M				= 0
								, ADJUST_IN_QTY_CELL				= 0
								, ADJUST_IN_QTY_JR				= 0
								, ADJUST_OUT_QTY_BATCH		= 0
								, ADJUST_OUT_QTY_M				= 0
								, ADJUST_OUT_QTY_CELL			= 0
								, ADJUST_OUT_QTY_JR				= 0
								, APC.UPDATE_ID					= @p_user_id
								, APC.UPDATE_TIME					= dbo.FN_SITE_TIME(SIM.SITE_ID) 
          WHEN NOT MATCHED THEN 
                INSERT ( 
								INSTANCE_ID
        						,FP_PLAN_ID
        						,COMPANY_ID
        						,DIVISION_ID
        						,SITE_ID
        						,PLANT_ID
								,FACTORY_ID
								,LOCATION
								,OPERATION_ID
								,LINE_ID
								,ELECTRODE_TYPE
								,EQUIPMENT_ID
								,PLAN_DATE
								,TOP_ITEM_ID
								,ITEM_ID
								,PRODUCTION_TYPE
								,MARKET
								,ADJUST_IN_QTY_BATCH
								,SEQ
        						,INSERT_ID
        						,INSERT_TIME
        						,UPDATE_ID
        						,UPDATE_TIME
            				) 
              	VALUES (	
								SIM.INSTANCE_ID
              					, SIM.PLAN_ID
              					, SIM.COMPANY_ID
              					, SIM.DIVISION_ID
              					, SIM.SITE_ID
								, SIM.PLANT_ID
								, SIM.FACTORY_ID
								, SIM.LOCATION 
								, SIM.OPERATION_ID 
								, SIM.LINE_ID
								, SIM.ELECTRODE_TYPE
								, SIM.EQUIPMENT_ID
								, SIM.PLAN_DATE
              					, SIM.TOP_ITEM_ID
								, SIM.ITEM_ID
								, SIM.PRODUCTION_TYPE
              					, SIM.MARKET
              					, SIM.BATCH_IN_QTY
              					, 1
								, @p_user_id 
								, dbo.FN_SITE_TIME(SIM.SITE_ID)
								, @p_user_id 
								, dbo.FN_SITE_TIME(SIM.SITE_ID)
              			);
          
		   -- AMEND HISTORY 생성
		  
		 INSERT INTO HIS_AMEND_DAILY_PLAN_R (
                   INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID
                  ,DIVISION_ID
                  ,SITE_ID
                  ,PLANT_ID
                  ,FACTORY_ID
                  ,LOCATION
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ELECTRODE_TYPE
                  ,EQUIPMENT_ID
                  ,PLAN_DATE
                  ,TOP_ITEM_ID
                  ,ITEM_ID
                  ,PRODUCTION_TYPE
                  ,MARKET
                  ,ADJUST_IN_QTY_BATCH
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
            )
            SELECT APC.INSTANCE_ID, APC.FP_PLAN_ID
					  ,APC.COMPANY_ID, APC.DIVISION_ID
					  ,APC.SITE_ID, APC.PLANT_ID, APC.FACTORY_ID
					  ,APC.LOCATION, APC.OPERATION_ID
					  ,APC.LINE_ID, APC.ELECTRODE_TYPE
					  ,APC.EQUIPMENT_ID, APC.PLAN_DATE
					  ,APC.TOP_ITEM_ID, APC.ITEM_ID
					  ,APC.PRODUCTION_TYPE, APC.MARKET
					  ,APC.ADJUST_IN_QTY_BATCH
					  ,APC.INSERT_ID, APC.INSERT_TIME
					  ,APC.UPDATE_ID, APC.UPDATE_TIME
					  ,@p_user_id AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'SIMULATION' AS JOB_TYPE
            FROM		FP_AMEND_DAILY_PLAN_R APC WITH(NOLOCK)
						,  TH_BUF_ELEC_CALCULATION_SIM SIM
			WHERE	SIM.INSTANCE_ID	= @v_master_id 
			AND		SIM.PLAN_ID			= @v_plan_id
			AND		SIM.PLAN_DATE		>= @v_plan_date
			AND 		APC.INSTANCE_ID	= SIM.INSTANCE_ID
			AND		APC.FP_PLAN_ID		= SIM.PLAN_ID
			AND		APC.COMPANY_ID  = SIM.COMPANY_ID
			AND		APC.DIVISION_ID	= SIM.DIVISION_ID
			AND		APC.SITE_ID			= SIM.SITE_ID
			AND		APC.PLANT_ID		= SIM.PLANT_ID
			AND		APC.FACTORY_ID	= SIM.FACTORY_ID 
			AND		APC.OPERATION_ID	= SIM.OPERATION_ID 
			AND		APC.LINE_ID			= SIM.LINE_ID
			AND 		APC.ELECTRODE_TYPE = SIM.ELECTRODE_TYPE
			AND 		APC.EQUIPMENT_ID	= SIM.EQUIPMENT_ID
			AND		APC.TOP_ITEM_ID	= SIM.TOP_ITEM_ID
			AND		APC.ITEM_ID			= SIM.ITEM_ID 
			AND 		APC.LOCATION		= SIM.LOCATION
			AND		APC.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
			AND		APC.MARKET			= SIM.MARKET
			AND		APC.PLAN_DATE		= SIM.PLAN_DATE
			;

          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null 
          
			BEGIN
      
				SET @v_table_name = 'PR_SCM_OF_DAILY_AMEND_UI'
				SET @v_flag = '-'

				--LOG 생성
				SET @v_message   = 'PROCEDURE Start'
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null

				-- 운영
				IF CHARINDEX('DEV', USER) = 0   
					BEGIN
          
						EXEC(@v_instance_id+'.DBO.PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''','''+@v_flag+'''')
            
						EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_instance_id , @v_plan_id
            
					END
				-- 개발
				ELSE 
				
					BEGIN
          
						EXEC LGCE_FPDEV.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_master_id, @v_plan_id, @v_flag
						
						EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_master_id , @v_plan_id

					END
				
				END
			
				SET @v_message   = 'PROCEDURE End'
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null

			END

			
			
        
      END    

        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END
        
     
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
