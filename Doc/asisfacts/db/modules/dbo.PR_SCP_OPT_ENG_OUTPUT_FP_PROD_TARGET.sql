


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET]
     @P_PLAN_ID             NVARCHAR(50) -- 250401_81_H5.5A_NH030
    ,@P_PLAN_START_YYYYMMDD NVARCHAR(8)  -- 20250331
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    --DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @X_START_YYYYMMDD    NVARCHAR(8)   = @P_PLAN_START_YYYYMMDD
    DECLARE @V_DIVISION_ID       NVARCHAR(20)
    DECLARE @X_CNT               INT           = 0;
    DECLARE @X_SEND_SEQ          INT           = 1;
    DECLARE @X_IF_ID             NVARCHAR(50)  = 'OSCP_OFP0_FP_PROD_TARGET';
    DECLARE @X_PLAN_WEEK         NVARCHAR(12);
    DECLARE @NOW_DATE            DATETIME      = GETDATE()
    DECLARE @V_ORDER_TYPE        NVARCHAR(20)
    DECLARE @MIN_DAY             NVARCHAR(8)
    DECLARE @MAX_DAY             NVARCHAR(8)
    DECLARE @MAX_ANL_SEQ         INT
    DECLARE @PT_PLAN_TYPE        NVARCHAR(20)
    DECLARE @PT_PLAN_WEEK        NVARCHAR(20)

    -- 최적화 엔진 및 ANL의 버전 정보를 가져오기 위해
    DECLARE @V_SCP_PLAN_DATE NVARCHAR(50)
    DECLARE @V_SCP_PLAN_TYPE NVARCHAR(50)
    DECLARE @V_SCP_PLAN_SEQ  NVARCHAR(50)

    DECLARE @TYPE_TMP TABLE(
      DIVISION_ID NVARCHAR(50)
    , TYPE        NVARCHAR(10)
    )

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'START_' + @V_PROGRAM_NAME
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    SELECT @V_DIVISION_ID = ATTRIBUTE1 
    FROM SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK) 
    WHERE PLAN_ID = @V_PLAN_ID
    
    --ANL의 최신 버전 정보를 가져오기 위해
    --순지 책임님 요청으로 최신 플랜 TYPE/SEQ를 가져오기로 함 -> 기존에는 PR의 최신 SEQ를 바라봤었음.-> 조립 및 다른 PLAN_GROUP 적용할 시 정리 필요
    SELECT @V_SCP_PLAN_DATE      = A.PLAN_START_YYYYMMDD 
          ,@V_SCP_PLAN_TYPE      = A.PLAN_TYPE 
          ,@V_SCP_PLAN_SEQ       = A.PLAN_SEQ 
    FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG, PLAN_CYCLE, PLAN_ID, MODELING_ID, ENG_PLAN_ID
           FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
           WHERE  DIVISION_ID          = @V_DIVISION_ID
           AND    PLAN_START_YYYYMMDD  = @X_START_YYYYMMDD
           ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
          ) A 

    SELECT @X_CNT = COUNT(1)
      FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
     WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
       AND DIVISION_ID         = @V_DIVISION_ID
       --AND PLAN_TYPE           = @P_PLAN_TYPE
       AND IF_ID               = @X_IF_ID;   
    

    IF (@X_CNT > 0)
       BEGIN
            SELECT @X_CNT = MAX(IFSEQNO)
              FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
               AND DIVISION_ID         = @V_DIVISION_ID
               AND IF_ID               = @X_IF_ID;  
               
            SET @X_SEND_SEQ = @X_CNT +1;    
       END
    
    -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
    SET @X_PLAN_WEEK = @X_START_YYYYMMDD + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );
    SELECT @V_ORDER_TYPE = 'MPS' -- 81번의 경우 MPS 임시

    --DIVISION 별 TYPE 구분을 위해
    INSERT INTO @TYPE_TMP
    SELECT DIVISION_ID
          ,TYPE
    FROM(
        SELECT DISTINCT 
                W.SEGMENT1    AS DIVISION_ID
        	   ,W.ATTRIBUTE8  AS TYPE
        FROM SCM_SYS_LOOKUP_VALUE_SN W WITH(NOLOCK)
        WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
        AND W.ATTRIBUTE2 = 'Y' 
        UNION ALL
        SELECT DISTINCT 
                W.SEGMENT1    AS DIVISION_ID
        	   ,W.ATTRIBUTE9  AS TYPE
        FROM SCM_SYS_LOOKUP_VALUE_SN W WITH(NOLOCK)
        WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
        AND W.ATTRIBUTE2 = 'Y' 
        UNION ALL
        SELECT DISTINCT 
                W.SEGMENT1    AS DIVISION_ID
        	   ,W.ATTRIBUTE10 AS TYPE
        FROM SCM_SYS_LOOKUP_VALUE_SN W WITH(NOLOCK)
        WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
        AND W.ATTRIBUTE2 = 'Y' 
        ) TYPE
    WHERE TYPE IS NOT NULL
    GROUP BY DIVISION_ID, TYPE


    SELECT @MIN_DAY = MIN(YYYYMMDD)
          ,@MAX_DAY = MAX(YYYYMMDD)
    FROM SCP_ANL_PRODUCTION_PLAN AP WITH(NOLOCK)
    WHERE 1=1
    AND AP.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
    AND AP.DIVISION_ID =@V_DIVISION_ID
    AND AP.MEASURE = 'PROD_PLAN_AMEND'
    --AND AP.PLAN_TYPE= 'PR' -- 의사결정 필요
    AND AP.PLAN_TYPE = @V_SCP_PLAN_TYPE 
    AND AP.SEQ       = @V_SCP_PLAN_SEQ  
    AND AP.QTY       > 0

    -- 순지 책임님 요청으로 최신 플랜 TYPE/SEQ를 가져오기로 함 -> 기존에는 PR의 최신 SEQ를 바라봤었음.-> 조립 및 다른 PLAN_GROUP 적용할 시 정리 필요
    --SELECT @MAX_ANL_SEQ = MAX(PLAN_SEQ)
    --FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
    --WHERE  DIVISION_ID          = @V_DIVISION_ID
    --AND    PLAN_START_YYYYMMDD  = @P_PLAN_START_YYYYMMDD
    --AND    PLAN_TYPE = 'PR'-- 의사결정 필요

    SELECT  @PT_PLAN_TYPE = PLAN_TYPE
           ,@PT_PLAN_WEEK = PLAN_WEEK
    FROM(
        SELECT  DISTINCT PLAN_TYPE, PLAN_WEEK
        FROM    XIF_SCP_PROD_TARGET_R_SN PT WITH(NOLOCK)
            INNER JOIN @TYPE_TMP TT 
                ON  PT.DIVISION  = TT.DIVISION_ID
                AND PT.PLAN_TYPE = TT.TYPE
        WHERE   PLAN_WEEK =(
                              SELECT TOP 1 PLAN_WEEK 
                              FROM XIF_SCP_PROD_TARGET_R_SN WITH(NOLOCK)
                                  INNER JOIN @TYPE_TMP TT 
                                      ON  DIVISION  = TT.DIVISION_ID
                                      AND PLAN_TYPE = TT.TYPE
                              WHERE DIVISION = @V_DIVISION_ID
                              AND   IF_RCV_DATE >= DATEADD(DAY,-14,GETDATE()) -- 속도 개선을 위해
                              ORDER BY PLAN_WEEK DESC
                              )
        AND     DIVISION = @V_DIVISION_ID
        ) PT


    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

        INSERT INTO XIF_SCP_PROD_TARGET_R_SN
                  ( IF_RCV_DATE      ,
                    PROC_FLAG        ,
                    PROC_DATE        ,
                    PLAN_TYPE        ,
                    PLAN_WEEK        ,
                    TARGET_ID        ,
                    ITEM_ID          ,
                    OPERATION_GROUP  ,
                    OPERATION_ID     ,
                    SITE_CODE        ,
                    PLANT_ID         ,
                    PROD_WEEK        ,
                    YYYYMMDD         ,
                    PROD_QTY         ,
                    ORDER_TYPE       ,
                    PRODUCTION_LINE  ,
                    PRIORITY         ,
                    DIVISION         ,
                    MARKET           ,
                    CREATE_USER_ID   ,
                    CREATE_DATE      ,
                    MODIFY_USER_ID   ,
                    MODIFY_DATE      ,
                    ATTR_01          ,   --ORIGIN_DIVISION_ID
                    ATTR_10              --Divide Original and OPT Engine
                   )
        SELECT  @NOW_DATE      
               ,'N'        
               ,NULL        
               ,@PT_PLAN_TYPE
               ,@X_PLAN_WEEK        
               ,PT.TARGET_ID        
               ,PT.ITEM_ID          
               ,PT.OPERATION_GROUP  
               ,PT.OPERATION_ID     
               ,PT.SITE_CODE        
               ,PT.PLANT_ID         
               ,PT.PROD_WEEK        
               ,PT.YYYYMMDD         
               ,PT.PROD_QTY         
               ,PT.ORDER_TYPE       
               ,PT.PRODUCTION_LINE  
               ,PT.PRIORITY         
               ,PT.DIVISION         
               ,PT.MARKET           
               ,PT.CREATE_USER_ID   
               ,PT.CREATE_DATE      
               ,PT.MODIFY_USER_ID   
               ,PT.MODIFY_DATE      
               ,PT.ATTR_01     
               ,PT.ATTR_10
        FROM XIF_SCP_PROD_TARGET_R_SN PT
            LEFT OUTER JOIN (
                                    SELECT SCM_SITE_ID
                                          ,ITEM_ID
                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                    WHERE  PLAN_ID = @V_PLAN_ID
                                    GROUP BY SCM_SITE_ID,ITEM_ID
                                    ) ML
                ON  PT.SITE_CODE   = ML.SCM_SITE_ID
                AND PT.ITEM_ID     = ML.ITEM_ID
        WHERE   1=1
        AND     ML.SCM_SITE_ID IS NULL
        AND     PT.PLAN_TYPE = @PT_PLAN_TYPE
        AND     PT.PLAN_WEEK = @PT_PLAN_WEEK
        AND     PT.DIVISION  = @V_DIVISION_ID
        UNION ALL
        SELECT @NOW_DATE                                                    AS IF_RCV_DATE
              ,'N'                                                          AS PROC_FLAG
              ,NULL                                                         AS PROC_DATE
              ,@PT_PLAN_TYPE                                                AS PLAN_TYPE
              ,@X_PLAN_WEEK                                                 AS PLAN_WEEK
              ,CONVERT(NVARCHAR(100),ROW_NUMBER()OVER(ORDER BY AP.ITEM_ID)) AS TARGET_ID
              ,AP.ITEM_ID                                                   AS ITEM_ID
              ,AP.OPERATION_GROUP                                           AS OPERATION_GROUP
              ,AP.OPERATION_ID                                              AS OPERATION_ID
              ,AP.SCM_SITE_ID                                               AS SITE_ID
              ,MS.PLANT_ID                                                  AS PLANT_ID
              ,CAL.W_MON                                                    AS PROD_WEEK
              ,AP.YYYYMMDD                                                  AS YYYYMMDD
              ,AP.QTY                                                       AS OUT_QTY_INT
              ,@V_ORDER_TYPE                                                AS ORDER_TYPE
              ,AP.LINE_ID                                                   AS PRODUCTION_LINE
              ,'1'                                                          AS PRIORITY
              ,@V_DIVISION_ID                                               AS DIVISION_ID
              ,'D'                                                          AS MARKET
              ,'OPT_ENG'                                                    AS CREATE_USER_ID
              ,@NOW_DATE                                                    AS CREATE_DATE
              ,'OPT_ENG'                                                    AS MODIFY_USER_ID
              ,@NOW_DATE                                                    AS MODIFY_DATE
              ,@V_DIVISION_ID                                               AS ATTR_01
              ,'OPT_ENG_'+CONVERT(NVARCHAR(30),@NOW_DATE,120)               AS ATTR_10 -- 여러번에 걸쳐 수행된 SP를 구분하기 위해 시간 추가
        FROM SCP_ANL_PRODUCTION_PLAN AP WITH(NOLOCK)
            INNER JOIN (
                        SELECT SCM_SITE_ID
                              ,ITEM_ID
                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        WHERE  PLAN_ID = @V_PLAN_ID
                        GROUP BY SCM_SITE_ID,ITEM_ID
                        ) ML
                ON  AP.SCM_SITE_ID = ML.SCM_SITE_ID
                AND AP.ITEM_ID     = ML.ITEM_ID
            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                ON  MS.DIVISION_ID = @V_DIVISION_ID
                AND AP.SCM_SITE_ID = MS.SCM_SITE_ID
            INNER JOIN(
                      SELECT  CAL1.BASIS_YYYYMMDD
                             ,CAL2.W_MON
                      FROM    SCM_SYS_CALENDAR_M CAL1 WITH(NOLOCK)
                          INNER JOIN(
                                     SELECT ISO_YYYYWW
                                           ,MIN(BASIS_YYYYMMDD) AS W_MON
                                     FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                     WHERE BASIS_YYYYMMDD BETWEEN @MIN_DAY AND @MAX_DAY
                                     GROUP BY ISO_YYYYWW
                                     ) CAL2
                              ON CAL1.ISO_YYYYWW = CAL2.ISO_YYYYWW
                      WHERE CAL1.BASIS_YYYYMMDD BETWEEN @MIN_DAY AND @MAX_DAY
                      ) CAL
                ON  AP.YYYYMMDD = CAL.BASIS_YYYYMMDD
        WHERE 1=1
        AND AP.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
        AND AP.DIVISION_ID =@V_DIVISION_ID
        AND AP.MEASURE = 'PROD_PLAN_AMEND'
        --AND AP.PLAN_TYPE= 'PR' -- 의사결정 필요
        AND AP.PLAN_TYPE= @V_SCP_PLAN_TYPE -- 
        AND AP.QTY > 0
        --AND AP.SEQ = @MAX_ANL_SEQ
        AND AP.SEQ = @V_SCP_PLAN_SEQ
        
        INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_H
                   ( PLAN_START_YYYYMMDD
                   , DIVISION_ID
                   , PLAN_TYPE
                   , IF_ID
                   , IFSEQNO
                   , CREATED_BY
                   , CREATION_DATE )
                   VALUES
                   (  
                     @X_START_YYYYMMDD
                   , @V_DIVISION_ID
                   , @PT_PLAN_TYPE
                   , @X_IF_ID
                   , @X_SEND_SEQ
                   , 'OPT_ENG'
                   , GETDATE()    
                   );
    ------------------------------------------------------------------------
    -- 종료 LOG
	------------------------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	    ------------------------------------------------------------------------
          -- ERROR LOG
	    ------------------------------------------------------------------------
        SET @v_log_type = 'ERROR';
        SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
        SET @d_event_date = SYSDATETIME();
	    SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();
	    ------------------------------------------------------------------------  
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
    END CATCH
    ------------------------------------------------------------------------
  END;
