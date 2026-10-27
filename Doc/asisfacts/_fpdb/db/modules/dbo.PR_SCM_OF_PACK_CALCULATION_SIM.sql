CREATE PROCEDURE [dbo].[PR_SCM_OF_PACK_CALCULATION_SIM]
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
/** 프로그램 ID   : PR_SCM_OF_PACK_CALCULATION_SIM                                            **/
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
/** 2019.10.29   SHS         최초 작성                                                        **/
/**                          Amend (model / line) + DPP                                       **/
/** 2021.04.26   CGJ          통합 CAPA UI 적용 - OFF CALENDAR TABLE을 VIEW TABLE로 변경      **/
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
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PACK_CALCULATION_SIM'
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
        
        IF CHARINDEX('DEV', USER) = 0  -- 운영
        SET @v_instance_id = @v_master_id
        ELSE 
        SET @v_instance_id = 'KR_CELL_DEV' -- 개발
       
        
        SELECT @v_plan_date = PLAN_DATE
        FROM  (
              SELECT CONVERT(DATE, A.PLAN_START_TIME , 112) as PLAN_DATE
              FROM   SCM_FP_PLAN_H A
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.PLAN_ID    = @v_plan_id
     ) A
            
        
        BEGIN
          
          -- Parameter data set 구성 
          
          DELETE TH_BUF_SIM_DATA WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 
          DELETE TH_BUF_PACK_CALCULATION_SIM WHERE  INSTANCE_ID = @v_master_id AND PLAN_ID = @v_plan_id 
          
          INSERT INTO TH_BUF_SIM_DATA
          SELECT  @p_user_id           
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
          
          SET @v_table_name = 'TH_BUF_PACK_CALCULATION_SIM'
          
          INSERT INTO TH_BUF_PACK_CALCULATION_SIM
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
          SELECT    A.INSTANCE_ID 
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
    			  , CEILING( A.OUT_QTY *  (1/  ISNULL(ISNULL(B.YIELD, C.YIELD) , 1 )) ) AS IN_QTY
			FROM (
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
  			        INNER JOIN (SELECT A.date_id AS YYYYMMDD    
  			                        ,'qty' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY date_id) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY date_id)) AS YYYYMMDD_COLUMN
			                    FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
			                    WHERE A.date_id     >= @v_first_date
  			                    )Y
  			        ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN 
  			        WHERE QTY <> -9 -- 해당값 데이터는 변동 없음.
                )A		LEFT OUTER JOIN SCM_YIELD_EXCEPT_M B      WITH (NOLOCK) 
          					 ON   	A.COMPANY_ID = B.COMPANY_ID 
          					 AND    A.DIVISION_ID = B.DIVISION_ID 
          					 AND    A.SITE_ID = B.SITE_ID 
          					 AND	A.PLANT_ID = B.PLANT_ID
          					 AND	A.ITEM_ID = B.ITEM_ID
          					 AND 	A.OPERATION_ID = B.OPERATION_ID
          					 AND 	A.FACTORY_ID = B.FACTORY_ID
          					 AND 	A.LINE_ID = B.LINE_ID
							 AND	B.YIELD <> 0
          					 AND 	A.PLAN_DATE BETWEEN B.START_TIME AND B.END_TIME
          				LEFT OUTER JOIN SCM_YIELD_M C      WITH (NOLOCK) 
          					 ON   	A.COMPANY_ID = C.COMPANY_ID  
          					 AND    A.DIVISION_ID = C.DIVISION_ID 
          					 AND    A.SITE_ID = C.SITE_ID 
          					 AND	A.PLANT_ID = C.PLANT_ID
          					 AND   	A.ITEM_ID = C.ITEM_ID
          					 AND 	A.OPERATION_ID = C.OPERATION_ID
          					 AND 	A.FACTORY_ID = C.FACTORY_ID
          					 AND 	A.LINE_ID = C.LINE_ID
							 AND	C.YIELD <> 0
          					 AND	SUBSTRING((CONVERT(VARCHAR,A.PLAN_DATE,112)),1,6) = C.MONTH
                     
      --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null           
          
          
          -- DAILY PRODUCTION PLAN 동기화 
          
          SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
          
          MERGE FP_DAILY_PRODUCTION_PLAN_R AS DPP
          USING (SELECT  INSTANCE_ID 
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
          		FROM TH_BUF_PACK_CALCULATION_SIM
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
          WHEN NOT MATCHED THEN 
                INSERT ( INSTANCE_ID
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
              			, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
              			, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
              			, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
              			, 'ES' + '^' + convert(nvarchar,plan_date,112) + '^' + SIM.LINE_ID + '^' + SIM.PRODUCTION_TYPE + '^' + SIM.MARKET + '^' + SIM.ELECTRODE_TYPE + '^' + SIM.ITEM_ID
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
                        , GETDATE() 
              		    );
          
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null 
          
          -- AMEND DATA 동기화
          
          SET @v_table_name = 'FP_AMEND_PLAN_PACK_R'
          
          MERGE FP_AMEND_PLAN_PACK_R AS APC
          USING (SELECT  INSTANCE_ID 
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
          		FROM TH_BUF_PACK_CALCULATION_SIM
          		WHERE	INSTANCE_ID = @v_master_id 
          		AND		PLAN_ID = @v_plan_id
                AND		PLAN_DATE >= @v_plan_date
          		) AS SIM
            ON 		APC.INSTANCE_ID = SIM.INSTANCE_ID
            AND 	APC.INSTANCE_ID = SIM.INSTANCE_ID
            AND		APC.FP_PLAN_ID  = SIM.PLAN_ID
            AND		APC.COMPANY_ID  = SIM.COMPANY_ID
            AND		APC.DIVISION_ID = SIM.DIVISION_ID
            AND		APC.SITE_ID = SIM.SITE_ID
            AND		APC.PLANT_ID = SIM.PLANT_ID
            AND		APC.TOP_ITEM_ID = SIM.TOP_ITEM_ID
            AND		APC.ITEM_ID = SIM.ITEM_ID 
            AND		APC.OPERATION_ID = SIM.OPERATION_ID 
            AND		APC.FACTORY_ID = SIM.FACTORY_ID 
            AND		APC.LOCATION   = SIM.LOCATION
            AND		APC.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
            AND		APC.MARKET = SIM.MARKET
            AND		APC.LINE_ID = SIM.LINE_ID
            AND		APC.ELECTRODE_TYPE = SIM.ELECTRODE_TYPE
            AND		APC.PLAN_DATE = SIM.PLAN_DATE
          WHEN MATCHED  THEN 
                UPDATE  SET  APC.OUT_QTY = SIM.OUT_QTY 
               				,APC.IN_QTY = SIM.IN_QTY	
               				,APC.UPDATE_ID =  @p_user_id
               				,APC.UPDATE_TIME = dbo.FN_SITE_TIME(SIM.SITE_ID)
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
        				,PLAN_DATE
        				,TOP_ITEM_ID
        				,ITEM_TYPE
        				,IN_QTY
        				,OUT_QTY
        				,CELL_IN_QTY
        				,CELL_OUT_QTY
                        ,DATE_SEQ
        				,INSERT_ID
        				,INSERT_TIME
        				,UPDATE_ID
        				,UPDATE_TIME
            			) 
              	VALUES ( SIM.INSTANCE_ID
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
              			, SIM.PLAN_DATE
              			, SIM.TOP_ITEM_ID
						, '-'
              			, SIM.IN_QTY
              			, SIM.OUT_QTY
                        , 0
              			, 0
                        , 1
                        , @p_user_id 
                        , dbo.FN_SITE_TIME(SIM.SITE_ID)
                        , @p_user_id 
                        , dbo.FN_SITE_TIME(SIM.SITE_ID)
              		      );
    
		  -- AMEND HISTORY 생성
		  INSERT INTO HIS_AMEND_PLAN_PACK_R 
					   (
						INSTANCE_ID, FP_PLAN_ID
						,COMPANY_ID, DIVISION_ID
						,CATEGORY_ID
						,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
						,LOCATION, PRODUCTION_TYPE, MARKET
						,LINE_ID, ELECTRODE_TYPE
						,PLAN_DATE
						,TOP_ITEM_ID
						,ITEM_TYPE
						,IN_QTY 
						,OUT_QTY
						,CELL_IN_QTY 
						,CELL_OUT_QTY
						,INSERT_ID, INSERT_TIME
						,UPDATE_ID, UPDATE_TIME
						,DATE_SEQ
						,JOB_USER_ID, JOB_TIME, JOB_TYPE
						)
            SELECT	   APC.INSTANCE_ID, APC.FP_PLAN_ID
					  ,APC.COMPANY_ID, APC.DIVISION_ID
					  ,APC.CATEGORY_ID
					  ,APC.SITE_ID, APC.PLANT_ID, APC.ITEM_ID, APC.OPERATION_ID, APC.FACTORY_ID
					  ,APC.LOCATION, APC.PRODUCTION_TYPE, APC.MARKET
					  ,APC.LINE_ID, APC.ELECTRODE_TYPE
					  ,APC.PLAN_DATE
					  ,APC.TOP_ITEM_ID
					  ,APC.ITEM_TYPE
					  ,APC.IN_QTY 
					  ,APC.OUT_QTY
					  ,APC.CELL_IN_QTY 
					  ,APC.CELL_OUT_QTY
					  ,APC.INSERT_ID, APC.INSERT_TIME
					  ,APC.UPDATE_ID, APC.UPDATE_TIME
					  ,APC.DATE_SEQ
					  ,@p_user_id AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'SIMULATION' AS JOB_TYPE
            FROM		FP_AMEND_PLAN_PACK_R APC WITH(NOLOCK)
					,   TH_BUF_PACK_CALCULATION_SIM SIM
			WHERE	SIM.INSTANCE_ID	= @v_master_id 
			AND		SIM.PLAN_ID			= @v_plan_id
			AND		SIM.PLAN_DATE		>= @v_plan_date
			AND		APC.INSTANCE_ID	= SIM.INSTANCE_ID
			AND 	APC.INSTANCE_ID	= SIM.INSTANCE_ID
			AND		APC.FP_PLAN_ID		= SIM.PLAN_ID
			AND		APC.COMPANY_ID  = SIM.COMPANY_ID
			AND		APC.DIVISION_ID	= SIM.DIVISION_ID
			AND		APC.SITE_ID			= SIM.SITE_ID
			AND		APC.PLANT_ID		= SIM.PLANT_ID
			AND		APC.TOP_ITEM_ID	= SIM.TOP_ITEM_ID
			AND		APC.ITEM_ID			= SIM.ITEM_ID 
			AND		APC.OPERATION_ID	= SIM.OPERATION_ID 
			AND		APC.FACTORY_ID	= SIM.FACTORY_ID 
			AND 	APC.LOCATION		= SIM.LOCATION
			AND		APC.PRODUCTION_TYPE = SIM.PRODUCTION_TYPE
			AND		APC.MARKET			= SIM.MARKET
			AND		APC.LINE_ID			= SIM.LINE_ID
			AND 	APC.ELECTRODE_TYPE = SIM.ELECTRODE_TYPE
			AND		APC.PLAN_DATE		= SIM.PLAN_DATE
			;

          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null 
          
          -- AMEND ITEM TYPE UPDATE  
          
          UPDATE A
          SET    A.ITEM_TYPE = (CASE WHEN A.OPERATION_ID = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN ISNULL(C.LEVEL_3_NAME, '-')
                                   WHEN A.OPERATION_ID = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
                                   ELSE ISNULL(C.LEVEL_3_NAME, '-') 
                              END  )
          FROM    FP_AMEND_PLAN_PACK_R A,
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
          AND    A.ITEM_ID      = @p_item_id	            
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


		  -- 하위모델 S값 생성
		  EXEC(@v_instance_id+'.dbo.PR_SCM_OF_PSI_AMEND_UI_CAL '''+@v_master_id+''','''+@v_plan_id+'''') 

          /*
          해당 모델라인 Utilization / setup 계산 
          */
          
          -- LINE / OPERATION 별 계획
          
          SET @v_table_name = 'TH_BUF_AMEND_LINE_PLAN'
          
          DELETE TH_BUF_AMEND_LINE_PLAN WHERE INSTANCE_ID = @v_master_id AND FP_PLAN_ID = @v_plan_id
          DELETE TH_BUF_AMEND_LINE_PLAN_UTIL WHERE INSTANCE_ID = @v_master_id AND FP_PLAN_ID = @v_plan_id
          
          INSERT INTO TH_BUF_AMEND_LINE_PLAN 
                           ( 
                             INSTANCE_ID
                           , FP_PLAN_ID 
                           , COMPANY_ID
                           , DIVISION_ID
                           , SITE_ID
                           , PLANT_ID 
                           , FACTORY_ID
                           , LOCATION
                           , LINE_ID
                           , OPERATION_ID
                           , ELECTRODE_TYPE 
                           , EQUIPMENT_ID 
                           , ITEM_ID
                           , PLAN_DATE
                           , DATE_SEQ
                           , IN_QTY
                           , OUT_QTY 
                           , TOTAL_WORKING_TIME 
                           , SETUP_TIME 
                           ) 
          SELECT  INSTANCE_ID
                , FP_PLAN_ID 
                , COMPANY_ID
                , DIVISION_ID
                , SITE_ID
                , PLANT_ID 
                , FACTORY_ID
                , LOCATION
                , LINE_ID
                , OPERATION_ID
                , ELECTRODE_TYPE 
                , LINE_ID +'_'+  OPERATION_ID 
                       + ( CASE ELECTRODE_TYPE WHEN NULL  THEN  ''
                                               WHEN '- '  THEN '' 
                                               WHEN  ''   THEN  ''
                                                          ELSE +'_'+ +ELECTRODE_TYPE 
                           END ) AS EQUIPMENT_ID 
                , ITEM_ID
                , PLAN_DATE
                , DATE_SEQ
                , IN_QTY
                , OUT_QTY 
                , 0          AS TOTAL_WORKING_TIME 
                , 0          AS SETUP_TIME 
          FROM    FP_AMEND_PLAN_PACK_R (NOLOCK)
          WHERE  INSTANCE_ID  = @v_master_id 
          AND    FP_PLAN_ID   = @v_plan_id
          AND    OUT_QTY      > 0 
          AND    LINE_ID	  = @p_line_id
          AND	 OPERATION_ID = @p_operation_id
          AND    LOCATION     = @p_location
          AND    PLAN_DATE  >= @v_plan_date
          
          --LOG 생성
          SET @v_message   = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          
        --SET  A.TOTAL_WORKING_TIME = A.IN_QTY * B.TACT_TIME
        --자리수 넘쳐서 강제 조정 처리 : 앞에 10 자리
        
        SET @v_sqltext  = ' UPDATE A '
                        + ' SET    A.TOTAL_WORKING_TIME = CASE WHEN A.OUT_QTY * B.TACT_TIME > 10000000000.0 THEN 9999999999.0 '
                        + '                                                                                 ELSE A.OUT_QTY * B.TACT_TIME '
                        + '                               END   '     
                        + ' FROM   TH_BUF_AMEND_LINE_PLAN     A , '
                        + ' ' + @v_instance_id + '.dbo.TH_BUF_AMEND_PSI_BOR_C  B'
                        + ' WHERE  A.INSTANCE_ID  = '''+@v_master_id+''' '
                        + ' AND    A.FP_PLAN_ID   = '''+@v_plan_id+''' '
                        + ' AND    A.FACTORY_ID     = B.FACTORY_ID '
                        + ' AND    A.OPERATION_ID   = B.OPERATION_ID '
                        + ' AND    A.LINE_ID        = B.LINE_ID '
                        + ' AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE '
                        + ' AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID '
                        + ' AND    A.ITEM_ID        = B.ITEM_ID '
                        + ' AND    A.PLAN_DATE      BETWEEN B.START_DATE AND B.END_DATE '
                        
        
        EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT
        
        --LOG 생성
        SET @v_message   = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        SET @v_sqltext  = ' UPDATE A '
                        + ' SET    A.SETUP_TIME = ISNULL(B.SETUP_TIME, 0) * 60 '
                        + ' FROM   ( '
                        + '         SELECT A.* '
                        + '                 , LAG(SETUP_GROUP_ID) OVER(PARTITION BY A.FACTORY_ID '
                        + '                                                       , A.LINE_ID '
                        + '                                                       , A.OPERATION_ID '
                        + '                                                       , A.EQUIPMENT_ID '
                        + '                                             ORDER     BY  A.PLAN_DATE '
                        + '                                                         , A.DATE_SEQ '
                        + '                                                         , A.ITEM_ID '
                        + '                                            ) AS PREV_SETUP_GROUP_ID '
                        + '         FROM   (  '
                        + '                  SELECT A.* '
                        + '                       , B.RESOURCE_SETUP_GROUP_ID '
                        + '                       , C.SETUP_GROUP_ID '
                        + '                   FROM   TH_BUF_AMEND_LINE_PLAN  A , '
                        + ' '                     +  @v_instance_id + '.dbo.TH_MST_RESOURCE  B ,' 
                        + ' '                     +  @v_instance_id + '.dbo.TH_MST_ITEM  C ' 
                        + '                   WHERE  A.INSTANCE_ID  = '''+@v_master_id+''' '
                        + '                   AND    A.FP_PLAN_ID   = '''+@v_plan_id+''' '
                        + '                   AND    A.INSTANCE_ID    = B.MASTER_ID '
                        + '                   AND    A.FP_PLAN_ID     = B.PLAN_ID '
                        + '                   AND    A.FACTORY_ID     = B.SITE_ID '
                        --AND    A.LINE_ID        = B.ROUTE_ID
                        --AND    A.OPERATION_ID   = B.OPERATION_ID
                        + '                   AND    A.EQUIPMENT_ID   = B.RESOURCE_ID '
                        + '                   AND    A.INSTANCE_ID    = C.MASTER_ID '
                        + '                   AND    A.FP_PLAN_ID     = C.PLAN_ID '
                        + '                   AND    A.ITEM_ID        = C.ITEM_ID '
                        --AND    A.OPERATION_ID   = C.OPERATION_ID
                        + '                   AND    A.OUT_QTY        > 0 '
                        + '               ) A '
                        + '         ) A '
                        + ' LEFT OUTER JOIN ' + ' '+ @v_instance_id + '.dbo.TH_MST_SETUP_TIME  B ' 
                        + '           ON    A.INSTANCE_ID             = B.MASTER_ID '
                        + '           AND   A.FP_PLAN_ID              = B.PLAN_ID '
                        + '           AND   A.RESOURCE_SETUP_GROUP_ID = B.RESOURCE_SETUP_GROUP_ID '
                        + '           AND   A.PREV_SETUP_GROUP_ID     = B.FROM_SETUP_ID '
                        + '           AND   A.SETUP_GROUP_ID          = B.TO_SETUP_ID '
                     
          EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT
        
			--LOG 생성
			SET @v_message   = @v_sqltext
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_BUF_AMEND_LINE_PLAN_UTIL'
          
          INSERT INTO TH_BUF_AMEND_LINE_PLAN_UTIL
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
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT A.INSTANCE_ID
             , A.FP_PLAN_ID
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
             , B.PLAN_DATE
             , @v_proc_name       AS INSERT_ID
             , GETDATE()          AS INSERT_TIME
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.FP_PLAN_ID
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
                FROM   TH_BUF_AMEND_LINE_PLAN    A
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.FP_PLAN_ID   = @v_plan_id
                GROUP  BY
                       A.INSTANCE_ID
                     , A.FP_PLAN_ID
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
               ) A
             , (
                SELECT CONVERT(DATE, DATEADD(DAY, B.INT-1, PLAN_START_TIME)) AS PLAN_DATE
                FROM   SCM_FP_PLAN_H A WITH(NOLOCK)
                     , COPYT            B WITH(NOLOCK)
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.PLAN_ID      = @v_plan_id
                AND    A.PLAN_HORIZON > B.INT - 1
          ) B
        WHERE  1=1       
        ORDER  BY
               A.INSTANCE_ID
             , A.FP_PLAN_ID
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
             , B.PLAN_DATE
      
        --LOG 생성
        SET @v_message   = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        UPDATE A
        SET    A.RUN_TIME   = B.RUN_TIME
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
             , (
                SELECT A.INSTANCE_ID
                     , A.FP_PLAN_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.OPERATION_ID
                     , A.LOCATION
                     , A.LINE_ID
                     , A.ELECTRODE_TYPE
                     , A.EQUIPMENT_ID
                     , A.PLAN_DATE
                     --자리수 넘쳐서 강제 조정 처리 : 앞에 10 자리
                     , CASE WHEN SUM(A.TOTAL_WORKING_TIME) > 10000000000.0  THEN 9999999999.0
                                                                            ELSE SUM(A.TOTAL_WORKING_TIME)
                       END  AS RUN_TIME
                FROM   TH_BUF_AMEND_LINE_PLAN A
                WHERE  A.INSTANCE_ID    = @v_master_id
                AND    A.FP_PLAN_ID     = @v_plan_id
                GROUP  BY
                       A.INSTANCE_ID
                     , A.FP_PLAN_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.OPERATION_ID
                     , A.LOCATION
                     , A.LINE_ID
                     , A.ELECTRODE_TYPE
                     , A.EQUIPMENT_ID
                     , A.PLAN_DATE
               ) B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.INSTANCE_ID    = B.INSTANCE_ID   
        AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
        AND    A.COMPANY_ID     = B.COMPANY_ID    
        AND    A.DIVISION_ID    = B.DIVISION_ID   
        AND    A.SITE_ID        = B.SITE_ID       
        AND    A.PLANT_ID       = B.PLANT_ID      
        AND    A.FACTORY_ID     = B.FACTORY_ID  
        AND    A.LOCATION       = B.LOCATION
        AND    A.OPERATION_ID   = B.OPERATION_ID  
        AND    A.LINE_ID        = B.LINE_ID       
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
        AND    A.PLAN_DATE      = B.PLAN_DATE     
      
        --LOG 생성
        SET @v_message   = 'RUN_TIME ( LINE ) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        UPDATE A
        SET    A.OFF_TIME = B.OFF_TIME
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
             , (
                SELECT RESOURCE_ID, PLAN_DATE
                     , SUM(OFFTIME_TERM) / MAX(RES_COUNT) AS OFF_TIME
                FROM   (
                        SELECT B.RESOURCE_ID
                             , B.RES_COUNT
                             , A.OFF_DATE AS PLAN_DATE
                             , A.OFF_TIME_TERM * (CASE A.OFF_TIME_UOM WHEN 'DAY'    THEN 86400
     WHEN 'HOUR'   THEN  3600
                   WHEN 'MINUTE' THEN    60
                                                                      WHEN 'SECOND' THEN     1
                                                                                    ELSE    60    -- DEFAULT 는 MINUTE
                                                  END )
                                AS OFFTIME_TERM
--                        FROM   SCM_OFF_CALENDAR_LINE_M A WITH(NOLOCK)
                        FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK)                        -- 2021.04.26 CGJ 통합 CAPA UI 적용
                             , (
                                SELECT A.*
                                     , COUNT(1) OVER (PARTITION BY DIVISION_ID
                                                                 , PLANT_ID
                                                                 , FACTORY_ID
                                                                 , LINE_ID
                                                                 , OPERATION_ID
                                                                 , ELECTRODE_TYPE
                                                                 , RESOURCE_ID ) AS RES_COUNT 
                                FROM   (
                                        SELECT DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID , LOCATION
                                             , LINE_ID + '_' + OPERATION_ID
                                                             + CASE ELECTRODE_TYPE WHEN NULL THEN ''
                                                                                   WHEN ''   THEN ''
                                                                                   WHEN '-'  THEN ''
                                                                                             ELSE '_'+ELECTRODE_TYPE
                                                               END
                                               AS RESOURCE_ID
                                        FROM   SCM_EQUIPMENT_M A WITH(NOLOCK)
                                        WHERE  A.COMPANY_ID    = @p_company_id       
                                        AND    A.DIVISION_ID   = @p_division_id       
                                        AND    A.SITE_ID       = @p_site_id          
                                        AND    A.PLANT_ID      = @p_plant_id            
                                        AND    A.OPERATION_ID  = @p_operation_id	  
                                        AND    A.LOCATION      = @p_location
                                        AND    A.LINE_ID       = @p_line_id
                                        AND    A.ELECTRODE_TYPE = @p_electrode_type 
                                        AND    A.EQUIPMENT_TYPE = 'M'
                                        AND    A.ACTIVE_FLAG = 'Y'
                                       ) A
                               ) B
                        WHERE  1=1
                        AND    A.COMPANY_ID    = @p_company_id       
                        AND    A.DIVISION_ID   = @p_division_id       
                        AND    A.SITE_ID       = @p_site_id          
                        AND    A.PLANT_ID      = @p_plant_id            
                        AND    A.OPERATION_ID  = @p_operation_id	   
                        AND    A.LINE_ID       = @p_line_id
                        AND    A.ELECTRODE_TYPE = @p_electrode_type 
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.PLANT_ID       = B.PLANT_ID
                        AND    A.FACTORY_ID     = B.FACTORY_ID
                        AND    A.OPERATION_ID   = B.OPERATION_ID
                        AND    A.LINE_ID        = B.LINE_ID
                        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                        AND    A.OFF_DATE  BETWEEN @v_plan_date AND DATEADD(DAY, 100, @v_plan_date)
                       ) A
                GROUP  BY RESOURCE_ID, PLAN_DATE
               ) B
      WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    A.EQUIPMENT_ID = B.RESOURCE_ID
        AND    A.PLAN_DATE    = B.PLAN_DATE

        --LOG 생성
        SET @v_message = 'OFF_TIME ( LINE ) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          
        UPDATE A
        SET    A.DAY_FIRST_SETUP_TIME     = B.DAY_FIRST_SETUP_TIME
             , A.SETUP_TIME               = B.SETUP_TIME
             , A.DAY_LAST_SETUP_TIME      = 0
             , A.ORG_DAY_FIRST_SETUP_TIME = B.DAY_FIRST_SETUP_TIME
             , A.ORG_SETUP_TIME           = B.SETUP_TIME
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
             , (
                SELECT A.INSTANCE_ID
                     , A.FP_PLAN_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.OPERATION_ID
                     , A.LOCATION
                     , A.LINE_ID
                     , A.ELECTRODE_TYPE
                     , A.EQUIPMENT_ID
                     , A.PLAN_DATE
                     , SUM(A.NEW_DAY_FIRST_SETUP_TIME)  AS DAY_FIRST_SETUP_TIME
                     , SUM(A.NEW_SETUP_TIME)            AS SETUP_TIME
                FROM   (
                        SELECT A.*
                             , CASE WHEN A.PLAN_DATE <> A.PREV_PLAN_DATE THEN ISNULL(A.SETUP_TIME, 0) ELSE 0
                               END  AS NEW_DAY_FIRST_SETUP_TIME
                             , CASE WHEN A.PLAN_DATE =  A.PREV_PLAN_DATE THEN ISNULL(A.SETUP_TIME, 0) ELSE 0
                               END  AS NEW_SETUP_TIME
                        FROM   (
                                SELECT A.INSTANCE_ID
                                     , A.FP_PLAN_ID
                                     , A.COMPANY_ID
                                     , A.DIVISION_ID
                                     , A.SITE_ID
                                     , A.PLANT_ID
                                     , A.FACTORY_ID
                                     , A.OPERATION_ID
                                     , A.LOCATION
                                     , A.LINE_ID
                                     , A.ELECTRODE_TYPE
                                     , A.EQUIPMENT_ID
                                     , A.PLAN_DATE
                                     , A.SETUP_TIME
                                     , LAG(PLAN_DATE)  OVER(PARTITION BY A.FACTORY_ID
                                                                       , A.LINE_ID
                                                                       , A.OPERATION_ID
                                                                       , A.EQUIPMENT_ID
                                                            ORDER     BY A.PLAN_DATE
                                                                       , A.DATE_SEQ
                                                                       , A.ITEM_ID
                                                            ) AS PREV_PLAN_DATE
                                FROM   TH_BUF_AMEND_LINE_PLAN    A
                                WHERE  A.INSTANCE_ID  = @v_master_id
                                AND    A.FP_PLAN_ID   = @v_plan_id
                                AND    A.OUT_QTY      > 0
                               ) A
                       ) A
                GROUP  BY
                       A.INSTANCE_ID
                     , A.FP_PLAN_ID
             , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
, A.FACTORY_ID
                     , A.OPERATION_ID
                     , A.LOCATION
                     , A.LINE_ID
                     , A.ELECTRODE_TYPE
                     , A.EQUIPMENT_ID
                     , A.PLAN_DATE
               ) B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.INSTANCE_ID    = B.INSTANCE_ID   
        AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
        AND    A.COMPANY_ID     = B.COMPANY_ID    
        AND    A.DIVISION_ID    = B.DIVISION_ID   
        AND    A.SITE_ID        = B.SITE_ID       
        AND    A.PLANT_ID       = B.PLANT_ID      
        AND    A.FACTORY_ID     = B.FACTORY_ID    
        AND    A.LOCATION       = B.LOCATION
        AND    A.OPERATION_ID   = B.OPERATION_ID  
        AND    A.LINE_ID        = B.LINE_ID       
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
        AND    A.PLAN_DATE      = B.PLAN_DATE
        
        --LOG 생성
        SET @v_message = 'SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        UPDATE A
        SET    A.ORG_UTILIZATION  = ROUND(((A.RUN_TIME + A.OFF_TIME + A.ORG_DAY_FIRST_SETUP_TIME + A.ORG_SETUP_TIME) / 86400.0 * 100.0), 2)
             , A.UTILIZATION      = ROUND(((A.RUN_TIME + A.OFF_TIME + A.DAY_FIRST_SETUP_TIME     + A.SETUP_TIME)     / 86400.0 * 100.0), 2)
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
      
        --LOG 생성
        SET @v_message = 'ORG_UTILIZATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        --
        
        UPDATE B
        SET    B.DAY_LAST_SETUP_TIME = B.DAY_LAST_SETUP_TIME
                                         + CASE WHEN A.DAY_FIRST_SETUP_TIME < FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400) THEN A.DAY_FIRST_SETUP_TIME
                                                ELSE FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400)
                                           END
        FROM   (
                SELECT A.*
                     , DATEADD(DAY, -1, PLAN_DATE) AS PREV_DATE
                FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
                WHERE  A.INSTANCE_ID          = @v_master_id
                AND    A.FP_PLAN_ID           = @v_plan_id
                AND    A.UTILIZATION          > 100
                AND    A.DAY_FIRST_SETUP_TIME > 0
               ) A
             , TH_BUF_AMEND_LINE_PLAN_UTIL B
        WHERE  A.INSTANCE_ID    = B.INSTANCE_ID   
        AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
        AND    A.COMPANY_ID     = B.COMPANY_ID    
        AND    A.DIVISION_ID    = B.DIVISION_ID   
        AND    A.SITE_ID        = B.SITE_ID       
        AND    A.PLANT_ID       = B.PLANT_ID      
        AND    A.FACTORY_ID     = B.FACTORY_ID    
        AND    A.OPERATION_ID   = B.OPERATION_ID  
        AND    A.LOCATION       = B.LOCATION
        AND    A.LINE_ID        = B.LINE_ID       
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
        AND    A.PREV_DATE      = B.PLAN_DATE
        AND    B.UTILIZATION    < 100

        --LOG 생성
        SET @v_message = 'DAY_LAST_SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        UPDATE A
        SET    A.DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME
                                         - CASE WHEN A.DAY_FIRST_SETUP_TIME < FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400) THEN A.DAY_FIRST_SETUP_TIME
                                                ELSE FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400)
                                           END
        FROM   (
                SELECT A.*
                     , DATEADD(DAY, -1, PLAN_DATE) AS PREV_DATE
                FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
                WHERE  A.INSTANCE_ID          = @v_master_id
                AND    A.FP_PLAN_ID           = @v_plan_id
                AND    A.UTILIZATION          > 100
                AND    A.DAY_FIRST_SETUP_TIME > 0
               ) A
             , TH_BUF_AMEND_LINE_PLAN_UTIL B
        WHERE  A.INSTANCE_ID    = B.INSTANCE_ID   
        AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
        AND    A.COMPANY_ID     = B.COMPANY_ID    
        AND    A.DIVISION_ID    = B.DIVISION_ID   
        AND    A.SITE_ID        = B.SITE_ID       
        AND    A.PLANT_ID       = B.PLANT_ID      
        AND    A.FACTORY_ID     = B.FACTORY_ID    
        AND    A.OPERATION_ID   = B.OPERATION_ID  
        AND    A.LOCATION       = B.LOCATION
        AND    A.LINE_ID        = B.LINE_ID       
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
        AND    A.PREV_DATE      = B.PLAN_DATE
        AND    B.UTILIZATION    < 100

        --LOG 생성
        SET @v_message = 'DAY_LAST_SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE A
        SET    A.UTILIZATION = ROUND(((A.RUN_TIME + A.OFF_TIME + A.DAY_FIRST_SETUP_TIME 
                                                               + A.SETUP_TIME
                                                               + A.DAY_LAST_SETUP_TIME 
                                                               ) / 86400.0 * 100.0), 2)
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
      
        UPDATE A
        SET    A.ORG_UTILIZATION          = A.UTILIZATION
             , A.ORG_DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME
             , A.ORG_SETUP_TIME           = A.SETUP_TIME
             , A.ORG_DAY_LAST_SETUP_TIME  = A.DAY_LAST_SETUP_TIME
        FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id

        --LOG 생성
        SET @v_message = 'DAY_LAST_SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        --
        
        BEGIN
        
          DECLARE C_UTIL_ADJ CURSOR FOR
            SELECT A.FACTORY_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.ELECTRODE_TYPE
                 , A.EQUIPMENT_ID
                 , A.PLAN_DATE
                 , A.DAY_FIRST_SETUP_TIME
            FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
            WHERE  A.INSTANCE_ID          = @v_master_id
            AND    A.FP_PLAN_ID           = @v_plan_id
            AND    A.UTILIZATION          > 100
            AND    A.DAY_FIRST_SETUP_TIME > 0
            ORDER  BY EQUIPMENT_ID, PLAN_DATE

          DECLARE               -- 커서로 받을 변수
      @c_factory_id           nvarchar(30)
            , @c_operation_id         nvarchar(30)
            , @c_line_id              nvarchar(30)
            , @c_electrode_type       nvarchar(30)
            , @c_equipment_id         nvarchar(30)
            , @c_plan_date            datetime
            , @c_day_first_setup_time numeric(20,10)
            --
            , @c_new_plan_date        datetime
            , @c_new_check_date       int
            , @c_new_utilization      numeric(20,10)
            , @c_new_setup_time       numeric(20,10)

          OPEN C_UTIL_ADJ
          
          WHILE 1 = 1
          BEGIN
            
            FETCH C_UTIL_ADJ
            INTO  @c_factory_id
                , @c_operation_id
                , @c_line_id
                , @c_electrode_type
                , @c_equipment_id
                , @c_plan_date
                , @c_day_first_setup_time
        
            IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
              BREAK
              
            SET @c_new_plan_date = @c_plan_date
            
            WHILE 1=1
            BEGIN
            
              SET @c_new_plan_date = DATEADD(DAY, -1, @c_new_plan_date)

              SELECT @c_new_check_date = COUNT(1)
              FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
              WHERE  A.INSTANCE_ID    = @v_master_id
              AND    A.FP_PLAN_ID     = @v_plan_id
              AND    A.FACTORY_ID     = @c_factory_id
              AND    A.OPERATION_ID   = @c_operation_id
              AND    A.LINE_ID        = @c_line_id
              AND    A.ELECTRODE_TYPE = @c_electrode_type
              AND    A.EQUIPMENT_ID   = @c_equipment_id
              AND    A.PLAN_DATE      = @c_new_plan_date
              AND    A.RUN_TIME       = 0
              AND   (A.OFF_TIME
                     + A.DAY_LAST_SETUP_TIME ) >= 86400
                      
              
              IF @c_new_check_date = 0  -- 배분 가능
              BEGIN

                SET @c_new_utilization = 100.0    -- 빈 쿼리 생성 방지
                
                SELECT @c_new_utilization = A.UTILIZATION
                     , @c_new_setup_time = ( CASE WHEN @c_day_first_setup_time < FLOOR(( 1.0 - A.UTILIZATION / 100.0 ) * 86400) THEN @c_day_first_setup_time
                                                  ELSE FLOOR(( 1.0 - A.UTILIZATION / 100.0 ) * 86400)
                                             END )              
                FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
                WHERE  A.INSTANCE_ID    = @v_master_id
                AND    A.FP_PLAN_ID     = @v_plan_id
                AND    A.FACTORY_ID     = @c_factory_id
                AND    A.OPERATION_ID   = @c_operation_id
                AND    A.LINE_ID        = @c_line_id
                AND    A.ELECTRODE_TYPE = @c_electrode_type
                AND    A.EQUIPMENT_ID   = @c_equipment_id
                AND    A.PLAN_DATE      = @c_new_plan_date
                AND    A.UTILIZATION    < 100
                
                IF @c_new_utilization >= 100.0
                  BREAK;

                UPDATE A
                SET    A.DAY_LAST_SETUP_TIME = A.DAY_LAST_SETUP_TIME + @c_new_setup_time
                FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
                WHERE  A.INSTANCE_ID    = @v_master_id
                AND    A.FP_PLAN_ID     = @v_plan_id
                AND    A.FACTORY_ID     = @c_factory_id
                AND    A.OPERATION_ID   = @c_operation_id
                AND    A.LINE_ID        = @c_line_id
                AND    A.ELECTRODE_TYPE = @c_electrode_type
                AND    A.EQUIPMENT_ID   = @c_equipment_id
                AND    A.PLAN_DATE      = @c_new_plan_date
                
                UPDATE A
                SET    A.DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME - @c_new_setup_time
                FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
   WHERE  A.INSTANCE_ID    = @v_master_id
                AND    A.FP_PLAN_ID     = @v_plan_id
                AND    A.FACTORY_ID  = @c_factory_id
                AND    A.OPERATION_ID   = @c_operation_id
                AND    A.LINE_ID        = @c_line_id
                AND    A.ELECTRODE_TYPE = @c_electrode_type
                AND    A.EQUIPMENT_ID   = @c_equipment_id
                AND    A.PLAN_DATE      = @c_plan_date

                SET @c_day_first_setup_time = @c_day_first_setup_time - @c_new_setup_time

              END

              IF @c_day_first_setup_time <= 0
                BREAK
            
            END

            UPDATE A
            SET    A.UTILIZATION = CASE WHEN A.OFF_TIME >= 86400.0 THEN 0
                                        ELSE ROUND((
                                                      ( A.RUN_TIME  + A.DAY_FIRST_SETUP_TIME 
                                                                    + A.SETUP_TIME
                                                                    + A.DAY_LAST_SETUP_TIME  ) 
                                                    / ( 86400.0     - A.OFF_TIME ) 
                                                    * 100.0
                                                   ), 2)
                                   END
            FROM   TH_BUF_AMEND_LINE_PLAN_UTIL A
            WHERE  A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id

          END
          CLOSE C_UTIL_ADJ
          
          DEALLOCATE C_UTIL_ADJ

          --LOG 생성
          SET @v_message = 'UTILIZATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'C_UTIL_ADJ', 'UPDATE', @n_log_count, null, @v_message, null

          UPDATE A
          SET    A.SETUP_TIME = B.DAY_FIRST_SETUP_TIME
          FROM   (
                  SELECT A.*
                       , LAG(A.PLAN_DATE)  OVER(PARTITION BY A.FACTORY_ID
                                                           , A.LINE_ID
                                                           , A.OPERATION_ID
                                                           , A.EQUIPMENT_ID
                                                ORDER     BY A.PLAN_DATE
                                                           , A.DATE_SEQ
                                                           , A.ITEM_ID
                                                ) AS PREV_PLAN_DATE 
                  FROM   TH_BUF_AMEND_LINE_PLAN A
                  WHERE  A.INSTANCE_ID  = @v_master_id
                  AND    A.FP_PLAN_ID   = @v_plan_id
                  AND    A.OUT_QTY      > 0
                 ) A
               , TH_BUF_AMEND_LINE_PLAN_UTIL B
          WHERE  A.PLAN_DATE     <> A.PREV_PLAN_DATE
          AND    A.INSTANCE_ID    = B.INSTANCE_ID
          AND    A.FP_PLAN_ID     = B.FP_PLAN_ID
          AND    A.COMPANY_ID     = B.COMPANY_ID    
          AND    A.DIVISION_ID    = B.DIVISION_ID   
          AND    A.SITE_ID        = B.SITE_ID       
          AND    A.PLANT_ID       = B.PLANT_ID      
          AND    A.FACTORY_ID     = B.FACTORY_ID    
          AND    A.OPERATION_ID   = B.OPERATION_ID  
          AND    A.LINE_ID        = B.LINE_ID       
          AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
          AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
          AND    A.PLAN_DATE      = B.PLAN_DATE
          AND    A.SETUP_TIME    <> B.DAY_FIRST_SETUP_TIME

          --LOG 생성
          SET @v_message = 'SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          UPDATE A
          SET    A.LOCATION = ISNULL(B.LOCATION, '-')
      FROM   TH_BUF_AMEND_LINE_PLAN_UTIL  A
               , SCM_LINE_M                B
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.FACTORY_ID     = B.FACTORY_ID
          AND    A.LINE_ID        = B.LINE_ID
          AND    A.OPERATION_ID   = B.OPERATION_ID
          AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        
          --LOG 생성
          SET @v_message = 'LOCATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'FP_AMEND_PLAN_PACK_UTIL_R'
          
          UPDATE A
          SET   A.RUN_TIME = B.RUN_TIME 
          		, A.OFF_TIME = B.OFF_TIME 
          		, A.SETUP_TIME = B.SETUP_TIME 
          		, A.UTILIZATION = B.UTILIZATION 
          FROM  FP_AMEND_PLAN_PACK_UTIL_R A ,
          		  TH_BUF_AMEND_LINE_PLAN_UTIL B
          WHERE A.INSTANCE_ID = @v_master_id 
          AND	A.FP_PLAN_ID = @v_plan_id 
          AND	A.COMPANY_ID    = @p_company_id       
          AND   A.DIVISION_ID   = @p_division_id       
          AND   A.SITE_ID       = @p_site_id          
          AND   A.PLANT_ID      = @p_plant_id     
          AND   A.FACTORY_ID      = @p_factory_id            
          AND   A.OPERATION_ID  = @p_operation_id	   
          AND   A.LINE_ID       = @p_line_id
          AND   A.ELECTRODE_TYPE = @p_electrode_type 
          AND	A.INSTANCE_ID  = B.INSTANCE_ID
          AND	A.FP_PLAN_ID  = B.FP_PLAN_ID 
          AND	A.COMPANY_ID = B.COMPANY_ID 
          AND	A.DIVISION_ID = B.DIVISION_ID
          AND	A.SITE_ID = B.SITE_ID
          AND	A.PLANT_ID = B.PLANT_ID 
          AND	A.FACTORY_ID = B.FACTORY_ID
          AND	A.OPERATION_ID = B.OPERATION_ID 
          AND	A.LINE_ID = B.LINE_ID
          AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
          AND	A.PLAN_DATE = B.PLAN_DATE
          
          --LOG 생성
          SET @v_message = 'RUN TIME/OFF/SETUP : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate     = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
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
