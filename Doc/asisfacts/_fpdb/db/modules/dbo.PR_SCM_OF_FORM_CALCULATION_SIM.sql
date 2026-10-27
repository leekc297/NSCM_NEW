CREATE PROCEDURE [dbo].[PR_SCM_OF_FORM_CALCULATION_SIM]
  @p_user_id           varchar(100)
 ,@p_instance_id       nvarchar(30)   
 ,@p_plan_id	       nvarchar(30)   
 ,@p_company_id        nvarchar(30)  
 ,@p_division_id       nvarchar(30)  
 ,@p_site_id           nvarchar(30)  
 ,@p_plant_id          nvarchar(30)  
 ,@p_top_item_id	   nvarchar(100)   
 ,@p_item_id	       nvarchar(100)   
 ,@p_operation_id	   nvarchar(30)   
 ,@p_factory_id	       nvarchar(30)  
 ,@p_location          nvarchar(30)
 ,@p_production_type   nvarchar(30)         
 ,@p_market	           nvarchar(30)   
 ,@p_line_id	       nvarchar(30)   
 ,@p_electrode_type    nvarchar(30) 
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
/** 프로그램 ID   : PR_SCM_OF_FORM_CALCULATION_SIM                                            **/
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
  DECLARE @v_formation_plan_option	nvarchar(30) 

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_FORM_CALCULATION_SIM'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  -- 사용자 변수 설정

  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      BEGIN
      
        SET @v_table_name = 'PR_SCM_OF_FORM_CALCULATION_SIM'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
        
        IF CHARINDEX('DEV', USER) = 0  -- 운영
        SET @v_instance_id = @v_master_id
        ELSE 
        SET @v_instance_id = 'KR_FORM_DEV' -- 개발
       
        
        SELECT @v_plan_date = PLAN_DATE
        FROM  (
              SELECT CONVERT(DATE, A.PLAN_START_TIME , 112) as PLAN_DATE
              FROM   SCM_FP_PLAN_H A
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.PLAN_ID    = @v_plan_id
              ) A
            
		SELECT  @v_formation_plan_option = CASE WHEN COUNT(DISTINCT OPERATION_ID ) = 1 THEN 'EOL' ELSE 'DEGAS' END 
		FROM	FP_INSTANCE_OPERATION_V
		WHERE	INSTANCE_ID = @v_master_id
		AND		AMEND_FLAG = 'Y'
		GROUP BY INSTANCE_ID 
        
		---LOG 생성
		SET @v_message   = @v_formation_plan_option
		SET @n_log_count = @n_log_count + 1
		SET @sysdate     = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null           
          
        
        BEGIN
          
          -- Parameter data set 구성 
          
			DELETE DBO.TH_BUF_SIM_DATA WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 

			--LOG 생성
			SET @v_message   = @@ROWCOUNT
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_instance_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null           
          

			DELETE DBO.TH_BUF_FORM_CALCULATION_SIM WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 
			
			--LOG 생성
			SET @v_message   = @@ROWCOUNT
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null           
          

			INSERT INTO DBO.TH_BUF_SIM_DATA
			SELECT	 @p_user_id           
					,@p_instance_id          
					,@p_plan_id	       
					,@p_company_id       
					,@p_division_id       
					,@p_site_id          
					,@p_plant_id         
					,@p_top_item_id	        
					,@p_item_id	            
					,@p_operation_id	        
					,@p_factory_id	  
					,@p_location
					,@p_production_type	          
					,@p_market	              
					,@p_line_id	            
					,@p_electrode_type     
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
          
			SET @v_table_name = 'TH_BUF_FORM_CALCULATION_SIM'
          
			INSERT INTO DBO.TH_BUF_FORM_CALCULATION_SIM
					(
					  INSTANCE_ID 
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
					, ELECTRODE_TYPE
					, PLAN_DATE
					, OUT_QTY
					, IN_QTY
					)
			SELECT	  A.INSTANCE_ID 
					, A.PLAN_ID 
					, A.COMPANY_ID  
					, A.DIVISION_ID  
					, A.SITE_ID  
					, A.PLANT_ID  
					, A.TOP_ITEM_ID 
					, A.ITEM_ID  
					, A.OPERATION_ID 
					, A.FACTORY_ID 
					, A.LOCATION 
					, A.PRODUCTION_TYPE 
					, A.MARKET  
					, A.LINE_ID  
					, A.ELECTRODE_TYPE  
					, A.PLAN_DATE 
					, A.OUT_QTY
					, CEILING(A.OUT_QTY * ISNULL(ISNULL(B.YIELD , C.YIELD) ,1) ) AS IN_QTY
			FROM  (
					SELECT    X.INSTANCE_ID 
							, X.PLAN_ID 
							, X.COMPANY_ID
							, X.DIVISION_ID
							, X.SITE_ID
							, X.PLANT_ID
							, X.TOP_ITEM_ID 
							, X.ITEM_ID 
							, X.OPERATION_ID 
							, X.FACTORY_ID 
							, X.LOCATION
							, X.PRODUCTION_TYPE 
							, X.MARKET 
							, X.LINE_ID 
							, X.ELECTRODE_TYPE
							, Y.YYYYMMDD  AS PLAN_DATE
							, QTY AS OUT_QTY
					FROM
						(
						SELECT * 
						FROM TH_BUF_SIM_DATA
						WHERE INSTANCE_ID = @V_MASTER_ID 
						AND   PLAN_ID = @V_PLAN_ID 
						) AS SourceTable  
						UNPIVOT 
						(
						QTY FOR  YYYYMMDD_COLUMN IN 
													(
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
								SELECT	A.date_id AS YYYYMMDD    
										,'qty' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY date_id) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY date_id)) AS YYYYMMDD_COLUMN
								FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
								WHERE A.date_id     >= @v_first_date
								)Y
						ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN 
						WHERE QTY <> -9 -- 해당값 데이터는 변동 없음.
					)A LEFT OUTER JOIN SCM_YIELD_EXCEPT_M B      WITH (NOLOCK) 
							ON		A.COMPANY_ID = B.COMPANY_ID 
							AND		A.DIVISION_ID = B.DIVISION_ID 
							AND		A.SITE_ID = B.SITE_ID 
							AND		A.PLANT_ID = B.PLANT_ID
							AND		A.ITEM_ID = B.ITEM_ID
							AND		A.OPERATION_ID = B.OPERATION_ID
							AND		A.FACTORY_ID = B.FACTORY_ID
							AND		A.LINE_ID = B.LINE_ID
							AND		B.YIELD <> 0
							AND		A.PLAN_DATE BETWEEN B.START_TIME AND B.END_TIME
					LEFT OUTER JOIN SCM_YIELD_M C      WITH (NOLOCK) 
							ON   	A.COMPANY_ID = C.COMPANY_ID  
							AND		A.DIVISION_ID = C.DIVISION_ID 
							AND		A.SITE_ID = C.SITE_ID 
							AND		A.PLANT_ID = C.PLANT_ID
							AND   	A.ITEM_ID = C.ITEM_ID
							AND		A.OPERATION_ID = C.OPERATION_ID
							AND		A.FACTORY_ID = C.FACTORY_ID
							AND		A.LINE_ID = C.LINE_ID
							AND		C.YIELD <> 0
							AND	 	SUBSTRING((CONVERT(VARCHAR,A.PLAN_DATE,112)),1,6) = C.MONTH
                     
			--LOG 생성
			SET @v_message   = @@ROWCOUNT
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null           
          
          
            -- DAILY PRODUCTION PLAN 동기화 
          
			SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
          
			MERGE FP_DAILY_PRODUCTION_PLAN_R AS DPP
			USING ( SELECT	INSTANCE_ID 
							, PLAN_ID 
							, COMPANY_ID
							, DIVISION_ID
							, SITE_ID
							, PLANT_ID
							, TOP_ITEM_ID 
							, ITEM_ID 
							, OPERATION_ID 
							, FACTORY_ID 
							, PRODUCTION_TYPE 
							, MARKET 
							, LINE_ID 
							, ELECTRODE_TYPE
							, PLAN_DATE
							, OUT_QTY
							, IN_QTY
					FROM	TH_BUF_FORM_CALCULATION_SIM
					WHERE	INSTANCE_ID = @v_master_id 
					AND		PLAN_ID = @v_plan_id
					AND		PLAN_DATE >= @v_plan_date
					) AS SIM
				ON 		DPP.INSTANCE_ID = SIM.INSTANCE_ID
				AND		DPP.FP_PLAN_ID  = SIM.PLAN_ID
				AND		DPP.COMPANY_ID  = SIM.COMPANY_ID
				AND		DPP.DIVISION_ID = SIM.DIVISION_ID
				AND		DPP.SITE_ID = SIM.SITE_ID
				AND		DPP.PLANT_ID = SIM.PLANT_ID
				AND		DPP.ITEM_ID = SIM.ITEM_ID 
				AND		DPP.OPERATION_ID = SIM.OPERATION_ID 
				AND		DPP.FACTORY_ID = SIM.FACTORY_ID 
				AND		DPP.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
				AND		DPP.MARKET = SIM.MARKET
				AND		DPP.LINE_ID = SIM.LINE_ID
				AND		DPP.ELECTRODE_TYPE = SIM.ELECTRODE_TYPE
				AND		CONVERT(DATE,DPP.PLAN_DATE,112) = CONVERT(DATE,SIM.PLAN_DATE,112)
			WHEN MATCHED  THEN 
								UPDATE  SET  DPP.PLAN_QTY = SIM.OUT_QTY 
											,DPP.PLAN_IN_QTY = SIM.IN_QTY	
											,DPP.INSERT_ID = @p_user_id
											,DPP.INSERT_DTTM = dbo.FN_SITE_TIME(SIM.SITE_ID)
			WHEN NOT MATCHED THEN 
								INSERT (  
										INSTANCE_ID
										,FP_PLAN_ID
										,COMPANY_ID
										,DIVISION_ID
										,SITE_ID
										,PLANT_ID
										,FACTORY_ID
										,WORK_ORDER_SPL_ID
										,WORK_ORDER_ID
										,ORG_DEMAND_ID
										,DEMAND_ID
										,ITEM_ID
										,TOP_ITEM_ID
										,OPERATION_ID
										,LINE_ID
										,ELECTRODE_TYPE
										,PLAN_DATE
										,START_TIME
										,END_TIME
										,PLAN_QTY
										,PLAN_IN_QTY
										,PRODUCTION_TYPE
										,MARKET
										,INSERT_ID
										,INSERT_DTTM
										) 
								VALUES (  SIM.INSTANCE_ID
										, SIM.PLAN_ID
										, SIM.COMPANY_ID
										, SIM.DIVISION_ID
										, SIM.SITE_ID
										, SIM.PLANT_ID
										, SIM.FACTORY_ID
										, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.OPERATION_ID + '^' + SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
										, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.OPERATION_ID + '^' +SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
										, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.OPERATION_ID + '^' +SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
										, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.OPERATION_ID + '^' +SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
										, SIM.ITEM_ID
										, SIM.TOP_ITEM_ID
										, SIM.OPERATION_ID 
										, SIM.LINE_ID
										, SIM.ELECTRODE_TYPE
										, SIM.PLAN_DATE
										, SIM.PLAN_DATE
										, SIM.PLAN_DATE
										, SIM.OUT_QTY
										, SIM.IN_QTY
										, SIM.PRODUCTION_TYPE
										, SIM.MARKET
										, @p_user_id 
										, dbo.FN_SITE_TIME(SIM.SITE_ID)
										);
          
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null 
          
          -- AMEND DATA 동기화
          
          SET @v_table_name = 'FP_AMEND_PLAN_FORM_R'
          
          MERGE FP_AMEND_PLAN_FORM_R AS APF
          USING ( SELECT  INSTANCE_ID 
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
    		            , ELECTRODE_TYPE
    		            , PLAN_DATE
    		            , OUT_QTY
    		            , IN_QTY
          			FROM	TH_BUF_FORM_CALCULATION_SIM
          			WHERE	INSTANCE_ID = @v_master_id 
          			AND		PLAN_ID = @v_plan_id
					AND		PLAN_DATE >= @v_plan_date
					) AS SIM
				ON 		APF.INSTANCE_ID = SIM.INSTANCE_ID
				AND 	APF.INSTANCE_ID = SIM.INSTANCE_ID
				AND		APF.FP_PLAN_ID  = SIM.PLAN_ID
				AND		APF.COMPANY_ID  = SIM.COMPANY_ID
				AND		APF.DIVISION_ID = SIM.DIVISION_ID
				AND		APF.SITE_ID = SIM.SITE_ID
				AND		APF.PLANT_ID = SIM.PLANT_ID
				AND		APF.TOP_ITEM_ID = SIM.TOP_ITEM_ID
				AND		APF.ITEM_ID = SIM.ITEM_ID 
				AND		APF.OPERATION_ID = SIM.OPERATION_ID 
				AND		APF.FACTORY_ID = SIM.FACTORY_ID 
				AND		APF.LOCATION   = SIM.LOCATION
				AND		APF.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
				AND		APF.MARKET = SIM.MARKET
				AND		APF.LINE_ID = SIM.LINE_ID
				AND		APF.ELECTRODE_TYPE = SIM.ELECTRODE_TYPE
				AND		APF.PLAN_DATE = SIM.PLAN_DATE
          WHEN MATCHED  THEN 
							UPDATE  SET  APF.OUT_QTY = SIM.OUT_QTY 
               							,APF.IN_QTY = SIM.IN_QTY	
               							,APF.UPDATE_ID =  @p_user_id
               							,APF.UPDATE_TIME = dbo.FN_SITE_TIME(SIM.SITE_ID)
          WHEN NOT MATCHED THEN 
							INSERT ( INSTANCE_ID
        							,FP_PLAN_ID
        							,COMPANY_ID
        							,DIVISION_ID
        							,CATEGORY_ID
        							,SITE_ID
        							,PLANT_ID
        							,ITEM_ID
        							,OPERATION_ID
        							,FACTORY_ID
									,LOCATION
        							,PRODUCTION_TYPE
        							,MARKET
        							,LINE_ID
        							,ELECTRODE_TYPE
									,CUSTOMER_ID
        							,PLAN_DATE
        							,TOP_ITEM_ID
        							,ITEM_TYPE
        							,IN_QTY
        							,OUT_QTY
									,DATE_SEQ
        							,INSERT_ID
        							,INSERT_TIME
        							,UPDATE_ID
        							,UPDATE_TIME
            						) 
              				VALUES (  SIM.INSTANCE_ID
              						, SIM.PLAN_ID
              						, SIM.COMPANY_ID
              						, SIM.DIVISION_ID
              						, 'PLAN'
									, SIM.SITE_ID
									, SIM.PLANT_ID
									, SIM.ITEM_ID
									, SIM.OPERATION_ID 
              						, SIM.FACTORY_ID
									, SIM.LOCATION 
              						, SIM.PRODUCTION_TYPE
              						, SIM.MARKET
              						, SIM.LINE_ID
              						, SIM.ELECTRODE_TYPE
									, '-' 
              						, SIM.PLAN_DATE
              						, SIM.TOP_ITEM_ID
									, '-'
              						, SIM.IN_QTY
              						, SIM.OUT_QTY
									, 1
									, @p_user_id 
									, dbo.FN_SITE_TIME(SIM.SITE_ID)
									, @p_user_id 
									, dbo.FN_SITE_TIME(SIM.SITE_ID)
              						  );

		  --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null 
          
		  -- AMEND HISTORY 생성
		  INSERT INTO HIS_AMEND_PLAN_FORM_R 
					(
					 INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, CATEGORY_ID
					, SITE_ID
					, PLANT_ID
					, ITEM_ID
					, OPERATION_ID
					, FACTORY_ID
					, LOCATION
					, PRODUCTION_TYPE
					, MARKET
					, LINE_ID
					, ELECTRODE_TYPE
					, CUSTOMER_ID
					, PLAN_DATE
					, TOP_ITEM_ID
					, ITEM_TYPE
					, IN_QTY 
					, OUT_QTY
					, INSERT_ID
					, INSERT_TIME
					, UPDATE_ID
					, UPDATE_TIME
					, DATE_SEQ
					, JOB_USER_ID
					, JOB_TIME
					, JOB_TYPE
					)
            SELECT	  APF.INSTANCE_ID
					, APF.FP_PLAN_ID
					, APF.COMPANY_ID
					, APF.DIVISION_ID
					, APF.CATEGORY_ID
					, APF.SITE_ID
					, APF.PLANT_ID
					, APF.ITEM_ID
					, APF.OPERATION_ID
					, APF.FACTORY_ID
					, APF.LOCATION
					, APF.PRODUCTION_TYPE
					, APF.MARKET
					, APF.LINE_ID
					, APF.ELECTRODE_TYPE
					, '-' AS CUSTOMER_ID
					, APF.PLAN_DATE
					, APF.TOP_ITEM_ID
					, APF.ITEM_TYPE
					, APF.IN_QTY 
					, APF.OUT_QTY
					, APF.INSERT_ID
					, APF.INSERT_TIME
					, APF.UPDATE_ID
					, APF.UPDATE_TIME
					, APF.DATE_SEQ
					, @p_user_id AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'SIMULATION' AS JOB_TYPE
            FROM	FP_AMEND_PLAN_FORM_R APF WITH(NOLOCK)
					, TH_BUF_FORM_CALCULATION_SIM SIM
			WHERE	SIM.INSTANCE_ID	= @v_master_id 
			AND		SIM.PLAN_ID		= @v_plan_id
			AND		SIM.PLAN_DATE	>= @v_plan_date
			AND		APF.INSTANCE_ID	= SIM.INSTANCE_ID
			AND 	APF.INSTANCE_ID	= SIM.INSTANCE_ID
			AND		APF.FP_PLAN_ID	= SIM.PLAN_ID
			AND		APF.COMPANY_ID  = SIM.COMPANY_ID
			AND		APF.DIVISION_ID	= SIM.DIVISION_ID
			AND		APF.SITE_ID		= SIM.SITE_ID
			AND		APF.PLANT_ID	= SIM.PLANT_ID
			AND		APF.TOP_ITEM_ID	= SIM.TOP_ITEM_ID
			AND		APF.ITEM_ID		= SIM.ITEM_ID 
			AND		APF.OPERATION_ID	= SIM.OPERATION_ID 
			AND		APF.FACTORY_ID	= SIM.FACTORY_ID 
			AND 	APF.LOCATION		= SIM.LOCATION
			AND		APF.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
			AND		APF.MARKET			= SIM.MARKET
			AND		APF.LINE_ID			= SIM.LINE_ID
			AND 	APF.ELECTRODE_TYPE  = SIM.ELECTRODE_TYPE
			AND		APF.PLAN_DATE		= SIM.PLAN_DATE
			;

          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null 
          
          -- AMEND ITEM TYPE UPDATE  
          
          UPDATE A
          SET    A.ITEM_TYPE = (CASE	WHEN A.OPERATION_ID = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN ISNULL(C.LEVEL_3_NAME, '-')
										WHEN A.OPERATION_ID = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
										ELSE ISNULL(C.LEVEL_3_NAME, '-') 
								END  )
          FROM    FP_AMEND_PLAN_FORM_R A,
                  SCM_ITEM_M        B,
                  SCM_ITEM_CLASS_M  C
          WHERE  1=1
          AND    A.INSTANCE_ID   = @v_instance_id
          AND    A.FP_PLAN_ID    = @v_plan_id 
          AND    A.COMPANY_ID    = @p_company_id       
          AND    A.DIVISION_ID   = @p_division_id       
          AND    A.SITE_ID       = @p_site_id          
          AND    A.PLANT_ID      = @p_plant_id         
          AND    A.TOP_ITEM_ID   = @p_top_item_id	        
          AND    A.ITEM_ID       = @p_item_id	            
          AND    A.OPERATION_ID  = @p_operation_id	        
          AND    A.FACTORY_ID    = @p_factory_id	
          AND    A.LOCATION      = @p_location
          AND    A.PRODUCTION_TYPE =  @p_production_type	          
          AND    A.MARKET          =  @p_market	              
          AND    A.LINE_ID         =  @p_line_id	            
          AND    A.ELECTRODE_TYPE  =  @p_electrode_type     
          AND    A.COMPANY_ID    = B.COMPANY_ID
          AND    A.DIVISION_ID   = B.DIVISION_ID
          AND    A.SITE_ID       = B.SITE_ID
          AND    A.ITEM_ID       = B.ITEM_ID
          AND    B.ITEM_CLASS    = C.CLASS_ID   
          
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 

		  -- LINE UTIL / SETUP  / OFF 갱신
		  SET @v_table_name = 'TH_BUF_LINEBY_AMEND_PLAN_FORM'
        
		  DELETE TH_BUF_LINEBY_AMEND_PLAN_FORM WHERE INSTANCE_ID = @v_master_id AND FP_PLAN_ID = @v_plan_id 
        
		  --LOG 생성
		  SET @v_message   = @@ROWCOUNT
		  SET @n_log_count = @n_log_count + 1
		  SET @sysdate     = GETDATE()
		  EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

		  INSERT INTO TH_BUF_LINEBY_AMEND_PLAN_FORM
                (
                  INSTANCE_ID , 
                  FP_PLAN_ID ,
                  COMPANY_ID , 
                  DIVISION_ID ,
                  SITE_ID , 
                  PLANT_ID , 
                  ITEM_ID , 
                  OPERATION_ID , 
                  FACTORY_ID , 
                  LINE_ID , 
                  PLAN_DATE , 
                  OUT_QTY , 
                  IN_QTY , 
                  SEQ , 
                  NEW_SEQ , 
                  SETUP , 
                  LEAD_ITEM
                )
		 SELECT		A.INSTANCE_ID , 
					A.FP_PLAN_ID , 
					A.COMPANY_ID , 
					A.DIVISION_ID , 
					A.SITE_ID , 
					A.PLANT_ID , 
					A.ITEM_ID , 
					A.OPERATION_ID , 
					A.FACTORY_ID , 
					A.LINE_ID ,
					A.PLAN_DATE , 
					A.OUT_QTY  ,
					A.IN_QTY,
					DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID  , A.OPERATION_ID , A.FACTORY_ID , A.LINE_ID , A.OPERATION_ID ORDER BY A.PLAN_DATE)	AS SEQ ,
					NULL ,
					NULL , 
					NULL
      	FROM	FP_AMEND_PLAN_FORM_R A
      	WHERE	A.INSTANCE_ID = @v_master_id
		AND		A.FP_PLAN_ID  = @v_plan_id
		AND		A.FACTORY_ID  <> '-'
		AND		A.PLAN_DATE	  >= @V_PLAN_DATE
		AND		A.OPERATION_ID	= @p_operation_id
		AND		A.LINE_ID     =  @p_line_id -- 해당 line data 만
		AND		A.OUT_QTY	  <> 0
        
		--LOG 생성
		SET @v_message   = @@ROWCOUNT
		SET @n_log_count = @n_log_count + 1
		SET @sysdate     = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

		DECLARE @c_setup_check$line_id        nvarchar(50),
                @c_setup_check$operation_id   nvarchar(50) ,
                @c_setup_check$plan_date      date , 
                @c_setup_check$seq            integer , 
                @c_setup_check$max_seq        integer ,
                @c_setup_check$last_item      nvarchar(50)
                
        DECLARE
        
          C_SETUP_CHECK CURSOR LOCAL FOR
            
            SELECT LINE_ID,OPERATION_ID ,  PLAN_DATE  ,SEQ
  	        FROM TH_BUF_LINEBY_AMEND_PLAN_FORM
			WHERE	INSTANCE_ID = @v_master_id 
			AND		FP_PLAN_ID = @v_plan_id 
			AND		OPERATION_ID	= @p_operation_id
  	        AND		LINE_ID     =  @p_line_id -- 해당 line data 만
			GROUP BY LINE_ID, OPERATION_ID , PLAN_DATE  , SEQ
            ORDER BY LINE_ID , OPERATION_ID , PLAN_DATE , SEQ

          OPEN C_SETUP_CHECK  
          WHILE 1=1
      
          BEGIN
          
            FETCH C_SETUP_CHECK
                   INTO @c_setup_check$line_id , @c_setup_check$operation_id , @c_setup_check$plan_date , @c_setup_check$seq
            
            IF @@FETCH_STATUS <> 0
                      BREAK;
            
            BEGIN
            
              IF @c_setup_check$seq = 1
              BEGIN
              
                UPDATE  TH_BUF_LINEBY_AMEND_PLAN_FORM
                SET TH_BUF_LINEBY_AMEND_PLAN_FORM.NEW_SEQ  = A.N_SEQ
                FROM (
                      SELECT A.*  , ROW_NUMBER() OVER (ORDER BY A.PLAN_DATE , ISNULL(B.ITEM_ID, 'XXXX')  ASC  ,  A.OUT_QTY DESC ) AS N_SEQ
    			            FROM TH_BUF_LINEBY_AMEND_PLAN_FORM A
    			            				LEFT OUTER JOIN TH_BUF_LINEBY_AMEND_PLAN_FORM B
    			            								ON    A.LINE_ID = B.LINE_ID
                                      AND   A.OPERATION_ID = B.OPERATION_ID
    			            								AND   A.SEQ + 1 = B.SEQ
    			            								AND   A.ITEM_ID = B.ITEM_ID 
    			            WHERE 1=1
    			            AND A.LINE_ID = @c_setup_check$line_id
							AND A.OPERATION_ID = @c_setup_check$operation_id
    			            AND A.PLAN_DATE = @c_setup_check$plan_date 
    			            AND	A.SEQ = @c_setup_check$seq
                      )A
                WHERE  TH_BUF_LINEBY_AMEND_PLAN_FORM.LINE_ID = A.LINE_ID
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.OPERATION_ID = A.OPERATION_ID
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.PLAN_DATE = A.PLAN_DATE
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.ITEM_ID = A.ITEM_ID
                
              END
              ELSE
              BEGIN
               
                SELECT @c_setup_check$max_seq = MAX(NEW_SEQ)
                FROM TH_BUF_LINEBY_AMEND_PLAN_FORM
                WHERE OPERATION_ID = @c_setup_check$operation_id
                AND   LINE_ID = @c_setup_check$line_id
                
                SELECT @c_setup_check$last_item = isnull(max(ITEM_ID),'xxx')
                FROM TH_BUF_LINEBY_AMEND_PLAN_FORM
                WHERE OPERATION_ID = @c_setup_check$operation_id 
                AND   LINE_ID = @c_setup_check$line_id
                AND   NEW_SEQ = @c_setup_check$max_seq
                
                UPDATE  TH_BUF_LINEBY_AMEND_PLAN_FORM
                SET TH_BUF_LINEBY_AMEND_PLAN_FORM.NEW_SEQ  = @c_setup_check$max_seq + A.N_SEQ
                FROM (
                      SELECT A.* , ROW_NUMBER() OVER (ORDER BY A.PLAN_DATE , FIRST_CHECK ,  A.LAST_CHECK DESC , A.OUT_QTY  ) AS N_SEQ
                      FROM (
      			                SELECT A.*  , CASE WHEN A.ITEM_ID = @c_setup_check$last_item THEN 1 ELSE 9 END AS FIRST_CHECK , 
        			                					   CASE WHEN B.ITEM_ID IS NOT NULL THEN 1 ELSE 9 END AS LAST_CHECK
        				            FROM TH_BUF_LINEBY_AMEND_PLAN_FORM A
        				            				LEFT OUTER JOIN TH_BUF_LINEBY_AMEND_PLAN_FORM B
        				            								ON  A.OPERATION_ID = B.OPERATION_ID
                                            AND A.LINE_ID = B.LINE_ID
        				            								AND A.SEQ + 1 = B.SEQ
        				            								AND A.ITEM_ID = B.ITEM_ID 
        				            WHERE 1=1
        				            AND A.LINE_ID = @c_setup_check$line_id
                            AND A.OPERATION_ID = @c_setup_check$operation_id
        				            AND A.PLAN_DATE = @c_setup_check$plan_date 
        				            AND	A.SEQ = @c_setup_check$seq
        	                  )A
                      )A
                WHERE  TH_BUF_LINEBY_AMEND_PLAN_FORM.LINE_ID = A.LINE_ID
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.OPERATION_ID = A.OPERATION_ID
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.PLAN_DATE = A.PLAN_DATE
                AND    TH_BUF_LINEBY_AMEND_PLAN_FORM.ITEM_ID = A.ITEM_ID
                
                /*--LOG 생성
                SET @v_message   = convert(nvarchar,@c_setup_check$max_seq)  + '##' +  @c_setup_check$line_id  + '##' +  convert(nvarchar,@c_setup_check$seq ) + '##' +  convert(nvarchar,@c_setup_check$plan_date )
                SET @n_log_count = @n_log_count + 1
                SET @sysdate     = GETDATE()
                EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null */
                

              END
            
            END
                      
          END
      

        CLOSE C_SETUP_CHECK

        DEALLOCATE C_SETUP_CHECK 
        
        UPDATE TH_BUF_LINEBY_AMEND_PLAN_FORM
        SET TH_BUF_LINEBY_AMEND_PLAN_FORM.SETUP = A.CHECK_VALUE , 
            TH_BUF_LINEBY_AMEND_PLAN_FORM.LEAD_ITEM = A.N_LEAD_ITEM
        FROM (
              SELECT  A.* , 
                      CASE WHEN A.ITEM_ID <> LEAD(ITEM_ID) OVER (PARTITION BY A.LINE_ID  ORDER BY A.NEW_SEQ) THEN 'Y' ELSE 'N' END AS CHECK_VALUE , 
                      LEAD(ITEM_ID) OVER (PARTITION BY A.LINE_ID  ORDER BY A.NEW_SEQ) AS N_LEAD_ITEM
              FROM TH_BUF_LINEBY_AMEND_PLAN_FORM A 
              )A
        WHERE TH_BUF_LINEBY_AMEND_PLAN_FORM.LINE_ID = A.LINE_ID 
        AND   TH_BUF_LINEBY_AMEND_PLAN_FORM.OPERATION_ID = A.OPERATION_ID
        AND   TH_BUF_LINEBY_AMEND_PLAN_FORM.PLAN_DATE = A.PLAN_DATE
        AND   TH_BUF_LINEBY_AMEND_PLAN_FORM.ITEM_ID = A.ITEM_ID
        AND   TH_BUF_LINEBY_AMEND_PLAN_FORM.NEW_SEQ = A.NEW_SEQ
        
        --LOG 생성
        SET @v_message   = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		BEGIN
        
          SET @v_table_name = 'SY_FP_AMEND_PLAN_FORM_UTIL_R'
          
          INSERT INTO FP_AMEND_PLAN_FORM_UTIL_R
                	(
					  INSTANCE_ID 
					, FP_PLAN_ID 
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
					, PLAN_DATE 
					, RUN_TIME 
					, OFF_TIME
					, SETUP_TIME 
					, UTILIZATION 
					, INSERT_ID 
					, INSERT_TIME
                	)
          SELECT 	  A.INSTANCE_ID  
					, A.FP_PLAN_ID  
                	, A.COMPANY_ID  
                	, A.DIVISION_ID  
                	, A.SITE_ID  
                	, A.PLANT_ID  
                	, A.FACTORY_ID  
                	, A.LOCATION_ID  
                	, A.OPERATION_ID  
                	, A.LINE_ID  
                	, A.ELECTRODE_TYPE  
                	, A.EQUIPMENT_ID 
                	, A.PLAN_DATE 
                	, SUM(A.RUN_TIME) AS RUN_TIME  
                	, ISNULL(B.OFFTIME_TERM,0) AS OFF_TIME  
                	, SUM(A.SETUP_TIME) AS SETUP_TIME 
                	, (SUM(A.RUN_TIME) + SUM(A.SETUP_TIME) * 60 ) / CASE WHEN ( 86400  - ISNULL(B.OFFTIME_TERM,0) *60  )  > 0 THEN ( 86400  - ISNULL(B.OFFTIME_TERM,0) *60  ) ELSE 1 END  * 100  AS UTILIZATION 
                	, @V_PROC_NAME 
                	, GETDATE() AS INSERT_TIME
          FROM (
                SELECT	  A.INSTANCE_ID  
                        , A.FP_PLAN_ID  
                        , A.COMPANY_ID  
                        , A.DIVISION_ID  
                        , A.SITE_ID 
                        , A.PLANT_ID  
                        , A.FACTORY_ID  
                        , '-' AS LOCATION_ID 
                        , A.OPERATION_ID 
                        , A.LINE_ID 
                        , '-' AS ELECTRODE_TYPE 
                        , '-' AS EQUIPMENT_ID 
                        , A.PLAN_DATE 
                        , A.RUN_TIME		AS RUN_TIME
                        , ISNULL(D.SETUP_TIME  ,0) 		AS SETUP_TIME 
                        , A.ITEM_ID 
                FROM (
                      SELECT  A.INSTANCE_ID , 
                              A.FP_PLAN_ID , 
                              A.COMPANY_ID , 
                              A.DIVISION_ID , 
                              A.SITE_ID , 
                              A.PLANT_ID , 
                  		      A.ITEM_ID , 
                              A.OPERATION_ID , 
                              A.FACTORY_ID , 
                              A.LINE_ID ,
                              A.PLAN_dATE , 
                              A.OUT_QTY  ,
                              A.IN_QTY , 
                              B.RESOURCE_ID  ,
                              FLOOR(A.OUT_QTY  *ISNULL(CASE WHEN B.DESCR = 'LINE_OFF' THEN C.TACT_TIME ELSE B.TACT_TIME END ,C.TACT_TIME)
                                      *(1/CASE WHEN ISNULL(CASE WHEN B.DESCR = 'LINE_OFF' THEN C.YIELD ELSE B.YIELD END ,C.YIELD) = 0 THEN 1 ELSE ISNULL(B.YIELD,C.YIELD) END)) as RUN_TIME ,
                              A.LEAD_ITEM
                	  FROM TH_BUF_LINEBY_AMEND_PLAN_FORM A 
                    		 LEFT OUTER JOIN	(SELECT * FROM TH_MST_OP_RESOURCE_CAL WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND DESCR  IS NULL   ) B
                          		 ON A.INSTANCE_ID = B.MASTER_ID
                          		 AND A.FP_PLAN_ID = B.PLAN_ID
                          		 AND A.ITEM_ID = B.ITEM_ID
                          		 AND A.LINE_ID + '_' +  A.OPERATION_ID = B.RESOURCE_ID
                          		 AND A.PLAN_DATE >= B.START_DATE
                          		 AND A.PLAN_DATE <=   B.END_DATE
                          		 AND B.IS_USE  = 'Y' 
                          		 --AND B.DESCR  <> 'LINE_OFF' 
                          		 AND B.ALT_PRIORITY <> 9 
                    		 LEFT OUTER JOIN TH_MST_OP_RESOURCE C
                          		 ON A.INSTANCE_ID = C.MASTER_ID
                          		 AND A.FP_PLAN_ID = C.PLAN_ID
                          		 AND A.ITEM_ID = C.ITEM_ID
                          		 AND A.LINE_ID + '_' +  A.OPERATION_ID = C.RESOURCE_ID
                      WHERE A.INSTANCE_ID = @v_master_id
                      AND A.FP_PLAN_ID = @v_plan_id
                      AND A.FACTORY_ID <> '-'
                      AND A.PLAN_DATE >= @v_plan_date
                      AND A.OUT_QTY <> 0
                      AND  EXISTS (
                        			SELECT 1
                        			FROM TH_MST_SCM_DEMAND X 
                        			WHERE    X.INSTANCE_ID  = @v_master_id
                        			AND      X.DPP_PLAN_ID = @v_plan_id
                        			AND      A.ITEM_ID = X.ITEM_ID
                      				)
            				  )A
            				  LEFT OUTER JOIN TH_MST_ITEM  B 
                					ON  A.INSTANCE_ID =  B.MASTER_ID
                  					AND A.FP_PLAN_ID = B.PLAN_ID
                  					AND A.ITEM_ID = B.ITEM_ID
              				  LEFT OUTER JOIN TH_MST_ITEM C
                  					ON  A.INSTANCE_ID =  C.MASTER_ID
                  					AND A.FP_PLAN_ID = C.PLAN_ID
                  					AND A.LEAD_ITEM = C.ITEM_ID
              				 LEFT OUTER JOIN TH_MST_SETUP_TIME D
                  					ON  A.INSTANCE_ID =  D.MASTER_ID
                  					AND A.FP_PLAN_ID = D.PLAN_ID
                  					AND B.SETUP_GROUP_ID = D.FROM_SETUP_ID
                  					AND C.SETUP_GROUP_ID = D.TO_SETUP_ID
                WHERE 1=1
                      --ORDER BY A.LINE_ID , A.PLAN_DATE
                )A  LEFT OUTER JOIN TH_MST_OFF_CALENDAR B
                      		ON A.INSTANCE_ID =  B.MASTER_ID
                      		AND A.FP_PLAN_ID = B.PLAN_ID
                      		AND CONVERT(DATE,A.PLAN_DATE,112) =  CONVERT(DATE,B.WORK_DATE,112) 
                      		AND A.LINE_ID + '_' +  A.OPERATION_ID = B.RESOURCE_GROUP_ID
          GROUP BY 	A.INSTANCE_ID , 
		                A.FP_PLAN_ID , 
		              	A.COMPANY_ID , 
		              	A.DIVISION_ID , 
		              	A.SITE_ID , 
		              	A.PLANT_ID , 
		              	A.FACTORY_ID , 
		              	A.LOCATION_ID , 
		              	A.OPERATION_ID , 
		              	A.LINE_ID , 
		              	A.ELECTRODE_TYPE , 
		              	A.EQUIPMENT_ID , 
		              	A.PLAN_DATE ,
		              	ISNULL(B.OFFTIME_TERM,0)
          --ORDER BY A.LINE_ID , A.PLAN_DATE  
          
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        
        END

		IF @v_formation_plan_option = 'EOL' 
		BEGIN
			
			EXEC(@v_instance_id+'.dbo.PR_SCM_OF_FORMATION_PSI_SIM_CAL '''+@v_master_id+''','''+@v_plan_id+''','''+@p_item_id+''','''+@p_operation_id+''','''+@p_factory_id+''','''+@p_line_id+''','''+@p_production_type+'''')

		END
		ELSE IF @v_formation_plan_option = 'DEGAS' 
		BEGIN
			
			EXEC(@v_instance_id+'.dbo.PR_SCM_OF_FORMATION_PSI_SIM_CAL_D '''+@v_master_id+''','''+@v_plan_id+''','''+@p_item_id+''','''+@p_operation_id+''','''+@p_factory_id+''','''+@p_line_id+''','''+@p_production_type+''','''+@p_user_id+'''')

		END 
		

      END    

        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END
        
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
