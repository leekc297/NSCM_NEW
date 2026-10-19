
/*
 * Program ID   : PR_SCP_PLN_ELEC_CELL_RTF_PLAN 
 * Description  : 전극 RTF결과를 CELL PLAN에 반영
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_ELEC_CELL_RTF_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.09   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021.05.10   KSW           PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.25   sclee         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.03.30	HRK			  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_ELEC_CELL_RTF_PLAN]
    ( @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name       
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @V_BATCH_USER   NVARCHAR(150) = N'';  
    SET     @V_BATCH_USER = 'SCP_BATCH';
    DECLARE @V_PROGRAM_NAME NVARCHAR(150) = N'PR_SCP_PLN_ELEC_CELL_RTF_PLAN';
    DECLARE @V_LOG_TYPE     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @N_LOG_COUNT    INTEGER = 0;
    DECLARE @V_LOG_MESSAGE  NVARCHAR(1000);
    DECLARE @V_DESCRIPTION  NVARCHAR(500);      
    DECLARE @V_TABLE_ID     NVARCHAR(150) = N'SCP_ANL_PRODUCTION_PLAN'; 
    DECLARE @D_EVENT_DATE   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date = SYSDATETIME();
 
    EXEC PR_SCM_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
                              
    -- 데이타처리용 변수선언
    DECLARE @V_SCP_END_DATE   DATETIME;

	-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
	-- 변경전
    --SET @V_SCP_END_DATE = DATEADD( WEEK, 52, CONVERT(DATETIME ,@P_PLAN_START_YYYYMMDD,112))
	--
	DECLARE @v_pet_date		NVARCHAR(12) = '';

	--  Plan End Date
	SELECT @v_pet_date = p.horizon_end_date
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = LEFT(@p_engine_plan_id, 4) ;

	SET @V_SCP_END_DATE = DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112));
	-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
    
    DECLARE @X_CELL_DIVISION_ID    NVARCHAR(50);        
    DECLARE @X_CELL_PLAN_SEQ       INT;                              
 
    BEGIN TRY
      BEGIN
         
		--------------------------------------------------------
		-- BEGIN 2023.03.30 HM JV 가상 사업부 추가 대응
        IF OBJECT_ID('tempdb..#tmp_TARGET_DIVISION') IS NOT NULL
        DROP TABLE #tmp_TARGET_DIVISION;	

		SELECT DIVISION_ID
			  ,ROW_NUMBER()	OVER (ORDER BY CASE WHEN ATTRIBUTE4 = 'LG' THEN 1 ELSE 2 END, DIVISION_ID)	AS SEQ
		  INTO #tmp_TARGET_DIVISION
		 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
		WHERE 1=1
		  AND DM.ATTRIBUTE3 != 'EE'
		  AND DM.VALID_YN	 = 'Y'

        DECLARE @X_DIVISION_CNT  INT = 0;
		SELECT  @X_DIVISION_CNT = MAX(SEQ) 
		  FROM #tmp_TARGET_DIVISION
		-- END  2023.03.30 HM JV 가상 사업부 추가 대응
		--------------------------------------------------------

        DECLARE @X_CNT  INT = 0;
        
        -- PJ20216891
        -- WHILE @X_CNT < 3
        -- 2023.03.30 HM JV WHILE @X_CNT < 4
		WHILE @X_CNT < @X_DIVISION_CNT  -- 2023.03.30 HM JV 가상 사업부 추가 대응
        BEGIN
            
            /***************************
             * CELL PLAN DIVISION SETTING
             ***************************/
            SET @X_CNT = @X_CNT + 1;

			-- 2023.03.30 HM JV 가상 사업부 추가 대응
			SELECT @X_CELL_DIVISION_ID = DIVISION_ID
			  FROM #tmp_TARGET_DIVISION
			  WHERE SEQ = @X_CNT

            -- 2023.03.30 HM JV IF @X_CNT = 1 
            -- 2023.03.30 HM JV    BEGIN
            -- 2023.03.30 HM JV      SET    @X_CELL_DIVISION_ID = N'81';
            -- 2023.03.30 HM JV    END
            -- 2023.03.30 HM JV  
            -- 2023.03.30 HM JV IF @X_CNT = 2 
            -- 2023.03.30 HM JV    BEGIN
            -- 2023.03.30 HM JV      SET    @X_CELL_DIVISION_ID = N'82';
            -- 2023.03.30 HM JV    END
            -- 2023.03.30 HM JV  
            -- 2023.03.30 HM JV IF @X_CNT = 3 
            -- 2023.03.30 HM JV    BEGIN
            -- 2023.03.30 HM JV      SET    @X_CELL_DIVISION_ID = N'40';
            -- 2023.03.30 HM JV    END
			-- 2023.03.30 HM JV  
            -- 2023.03.30 HM JV IF @X_CNT = 4
            -- 2023.03.30 HM JV    BEGIN
            -- 2023.03.30 HM JV      SET    @X_CELL_DIVISION_ID = N'81_UC';
            -- 2023.03.30 HM JV    END			   
               
            /**********************************************************************
             * 해당 사업부가 EE 수요에 참여한 경우에 대하여,
             * 전극 ALLOCATION정보를 활용하여, ELEC_RTF MEASURE데이타 생성로직수행
             **********************************************************************/                                                   
               
            SET    @X_CELL_PLAN_SEQ    = -1;
            
            SELECT TOP 1 @X_CELL_PLAN_SEQ = a.ORIGIN_SEQ
            --select *
              FROM SCP_PLN_ELEC_DEMAND_CELL_PLAN AS a WITH(NOLOCK)
             WHERE a.DIVISION_ID         = @P_DIVISION_ID            --N'EE'          --
               AND a.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD    --N'20180709'    --
               AND a.PLAN_TYPE           = @P_PLAN_TYPE              --N'PR'          --
               AND a.ORIGIN_DIVISION_ID  = @X_CELL_DIVISION_ID;      --N'81'          --
               ;
      
            /* DEBUG
            select @X_CELL_DIVISION_ID  AS '@X_CELL_DIVISION_ID' 
                    ,@X_CELL_PLAN_SEQ     AS '@X_CELL_PLAN_SEQ'

            select *
              from SCP_ANL_PRODUCTION_PLAN as a with(nolock)
             where 1=1
               and a.DIVISION_ID          = N'81'
               and a.PLAN_START_YYYYMMDD  = N'20180716'
               and a.PLAN_TYPE            = N'PR'
               and a.SEQ                  = N'2'
               and a.measure              = N'ELEC_RTF'

               and a.operation_group      = 'A'
               and a.scm_site_id          = 'G451-A'
               and a.item_id              = 'ACEN1053I-B1'
               and a.qty                  > 0.0
            */

            IF ( @X_CELL_PLAN_SEQ <> -1 )
            BEGIN
      
                   DELETE SCP_ANL_PRODUCTION_PLAN 
                    WHERE DIVISION_ID         = @X_CELL_DIVISION_ID       --N'81'          --
                      AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD    --N'20180709'    --
                      AND PLAN_TYPE           = @P_PLAN_TYPE              --N'PR'          --
                      AND SEQ                 = @X_CELL_PLAN_SEQ          --N'1'           --
                      AND MEASURE            IN (N'ELEC_RTF')
                      ;
                     
                   INSERT SCP_ANL_PRODUCTION_PLAN 
                   (
                       DIVISION_ID 
                      ,PLAN_START_YYYYMMDD 
                      ,PLAN_TYPE 
                      ,SEQ
                      ,OPERATION_GROUP 
                      ,SCM_SITE_ID     
                      ,ITEM_ID 
                      ,LINE_ID 
                      ,OPERATION_ID
                      ,MEASURE 
                      ,YYYYMMDD 
                      ,QTY 
                      ,ORIGIN_DIVISION_ID 
                      ,ELECTRODE_TYPE
                   
                      ,CREATED_BY 
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                   )
                   SELECT 
                         @X_CELL_DIVISION_ID               AS DIVISION_ID
                        ,a.PLAN_START_YYYYMMDD
                        ,a.PLAN_TYPE
                        ,@X_CELL_PLAN_SEQ                  AS SEQ
                        ,a.OPERATION_GROUP
                        ,a.PLANT_SITE_ID                   AS SCM_SITE_ID
                        ,a.ITEM_ID
                        ,a.PROJECT_CODE                    AS LINE_ID
                        ,(SELECT TOP 1 LEFT(fi.FLOW_ID,5) 
                            FROM SCP_MST_FINAL_ITEM        AS fi WITH(NOLOCK)
                           WHERE fi.DIVISION_ID = a.ORIGIN_FROM_DIVISION_ID
                             AND fi.ITEM_ID     = a.ITEM_ID
                         )                                 AS OPERATION_ID
                        ,'ELEC_RTF'                        AS MEASURE
                        ,a.YYYYMMDD
                        ,ROUND(SUM(a.ALLOCATION_QTY),0)    AS QTY
                        ,a.ORIGIN_FROM_DIVISION_ID         AS ORIGIN_DIVISION_ID
                        ,a.ELECTRODE_TYPE                  AS ELECTRODE_TYPE

                        ,@V_BATCH_USER                     
                        ,GETDATE()                                  
                        ,@V_BATCH_USER
                        ,GETDATE()
                  --select *
                    FROM SCP_PLN_ALLOCATION AS a WITH(NOLOCK)
                   WHERE 1=1
                     AND a.OUT_VERSION_ID          = @P_ENGINE_PLAN_ID         --N'1035::PR::1' --
                     AND a.DIVISION_ID             = @P_DIVISION_ID            --N'EE'          --
                     AND a.PLAN_START_YYYYMMDD     = @P_PLAN_START_YYYYMMDD    --N'20180716'    --
                     AND a.PLAN_TYPE               = @P_PLAN_TYPE              --N'PR'          --
                     AND a.SEQ                     = @P_SEQ                    --N'1'           --
                     
                     AND a.ORIGIN_FROM_DIVISION_ID = @X_CELL_DIVISION_ID       --N'81'          --
                     AND a.OPERATION_GROUP         = N'A'
                   GROUP BY
                         a.DIVISION_ID
                        ,a.PLAN_START_YYYYMMDD
                        ,a.PLAN_TYPE
                        ,a.SEQ
                        ,a.OPERATION_GROUP
                        ,a.PLANT_SITE_ID
                        ,a.ITEM_ID
                        ,a.PROJECT_CODE
                        ,a.YYYYMMDD
                        ,a.ORIGIN_FROM_DIVISION_ID
                        ,a.ELECTRODE_TYPE
                        ;
      
                  ----------------------------------------------------------- 
                  -- MEASURE의 빈날짜 채우기('ELEC_RTF')
                  ----------------------------------------------------------- 
                  INSERT INTO SCP_ANL_PRODUCTION_PLAN
                  (  
                     DIVISION_ID
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,OPERATION_GROUP
                    ,SCM_SITE_ID
                    ,ITEM_ID
                    ,LINE_ID
                    ,OPERATION_ID
                    ,MEASURE
                    ,YYYYMMDD
                    ,QTY
                    ,ORIGIN_DIVISION_ID 
                    ,ELECTRODE_TYPE 
                  
                    ,CREATED_BY
                    ,CREATION_DATE
                    ,LAST_UPDATED_BY
                    ,LAST_UPDATE_DATE
                  )
                  SELECT  
                          SUB.DIVISION_ID
                         ,SUB.PLAN_START_YYYYMMDD
                         ,SUB.PLAN_TYPE
                         ,SUB.SEQ
                         ,SUB.OPERATION_GROUP
                         ,SUB.SCM_SITE_ID
                         ,SUB.ITEM_ID
                         ,SUB.LINE_ID
                         ,SUB.OPERATION_ID
                         ,MS.MEASURE
                         ,SUB.YYYYMMDD
                         ,0 AS QTY
                         ,SUB.ORIGIN_DIVISION_ID 
                         ,SUB.ELECTRODE_TYPE 

                         ,@V_BATCH_USER
                         ,GETDATE()
                         ,@V_BATCH_USER
                         ,GETDATE()
                    FROM (
                          SELECT  B.DIVISION_ID
                                 ,B.PLAN_START_YYYYMMDD
                                 ,B.PLAN_TYPE
                                 ,B.SEQ
                                 ,B.OPERATION_GROUP
                                 ,B.SCM_SITE_ID
                                 ,B.ITEM_ID
                                 ,B.LINE_ID
                                 ,B.OPERATION_ID
                                 ,A.BASIS_YYYYMMDD        AS YYYYMMDD                                   
                                 ,B.ORIGIN_DIVISION_ID 
                                 ,B.ELECTRODE_TYPE 
                  
                            FROM (
                                 SELECT BASIS_YYYYMMDD
                                   FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                  WHERE BASIS_YYYYMMDD >= @P_PLAN_START_YYYYMMDD
                                    AND BASIS_YYYYMMDD <  CONVERT(NVARCHAR,@V_SCP_END_DATE,112)
                            ) AS A,
                            (
                            SELECT  DIVISION_ID
                                   ,PLAN_START_YYYYMMDD
                                   ,PLAN_TYPE
                                   ,SEQ
                                   ,OPERATION_GROUP
                                   ,SCM_SITE_ID
                                   ,ITEM_ID
                                   ,LINE_ID
                                   ,OPERATION_ID                               
                                   ,MAX(ORIGIN_DIVISION_ID ) AS ORIGIN_DIVISION_ID
                                   ,MAX(ELECTRODE_TYPE )     AS ELECTRODE_TYPE
                  
                              FROM SCP_ANL_PRODUCTION_PLAN AS X WITH(NOLOCK)
                             WHERE 1=1
                               AND DIVISION_ID         = @X_CELL_DIVISION_ID       --N'EE'          --
                               AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD    --N'20180716'    --
                               AND PLAN_TYPE           = @P_PLAN_TYPE              --N'PR'          --
                               AND SEQ                 = @X_CELL_PLAN_SEQ          --N'1'           --
                               AND MEASURE             = N'PROD_PLAN_ENGINE'
                               AND OPERATION_GROUP     = N'A'
                             GROUP BY DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                            ) AS B
                    ) AS SUB,
                    ( 
                      SELECT 'ELEC_RTF' AS MEASURE
                    ) AS MS
                    WHERE 1=1
                      AND NOT EXISTS (
                                      SELECT 'X'
                                        FROM SCP_ANL_PRODUCTION_PLAN AS Z WITH(NOLOCK)
                                       WHERE 1=1
                                         AND Z.DIVISION_ID           = SUB.DIVISION_ID         
                                         AND Z.PLAN_START_YYYYMMDD   = SUB.PLAN_START_YYYYMMDD 
                                         AND Z.PLAN_TYPE             = SUB.PLAN_TYPE           
                                         AND Z.SEQ                   = SUB.SEQ                 
                                         AND Z.OPERATION_GROUP       = SUB.OPERATION_GROUP     
                                         AND Z.SCM_SITE_ID           = SUB.SCM_SITE_ID         
                                         AND Z.ITEM_ID               = SUB.ITEM_ID             
                                         AND Z.LINE_ID               = SUB.LINE_ID             
                                         AND Z.OPERATION_ID          = SUB.OPERATION_ID        
                                         AND Z.MEASURE               = MS.MEASURE             
                                         AND Z.YYYYMMDD              = SUB.YYYYMMDD            
                                      )
                                      ;  
      

            END; --IF ( @X_CELL_PLAN_SEQ <> -1 ) : DELETE AND INSERT

        END; --WHILE @X_CNT < 3 : 
              

          
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
  
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;


      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    return 1  


  END;

