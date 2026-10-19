
/*
 * Program ID   : PR_SCP_PLN_ELEC_YIELD_AVG
 * Description  : SCP_MST_TACT_TIME_EXCEPT 전극 수율 입력
 * OutTable     :
 * Execute      :   EXEC PR_SCP_PLN_ELEC_YIELD_AVG @p_division_id          ='EE'
                                                  ,@p_plan_start_yyyymmdd = '20200323'
                                                  ,@p_plan_type           = 'PR'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.03.27   KTH           Initial Release 전지 공급 대응력 향상을 위한 RTF 적확도 개선 : 전극 수율 건
 * 2020.03.31   KTH           가중평균 삭제
 * 2022.03.25   sclee         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.03.31	HRK			  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_ELEC_YIELD_AVG]
    ( @p_division_id         NVARCHAR(30)-- 'EE'
    , @p_plan_start_yyyymmdd NVARCHAR(8) -- plan_name
    , @p_plan_type           NVARCHAR(30)
) 
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP_BATCH'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_ELEC_YIELD_AVG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_TACT_TIME_EXCEPT'; 
    DECLARE @d_event_date   DATETIME;
	
    -- PJ20216891
    DECLARE @v_tb_target_division TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division
	-- 2023.03.31 HM JV 가상 사업부 추가 대응
	SELECT DM.DIVISION_ID
	  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
	 WHERE DM.ATTRIBUTE3 != 'EE'
	   AND DM.VALID_YN	  = 'Y'
	--------------------------------------------------------
    -- 2023.03.31 HM JV  SELECT '40' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV  SELECT '81' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV  SELECT '81_UC' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV  SELECT '82' DIVISION_ID
	--------------------------------------------------------

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_TACT_TIME_EXCEPT INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    BEGIN TRY
      BEGIN
    
        ----------------------------------------------------------- 
        -- 기존데이타 삭제
        ----------------------------------------------------------- 

          DELETE FROM SCP_MST_TACT_TIME_EXCEPT
          WHERE OPERATION_ID       IN ('Z_A00T','Z_E00T')
		  
            -- PJ20216891
            -- AND DIVISION_ID        IN ('40', '81', '82') -- @p_division_id  -- 전체 Division 동시 생성
            AND DIVISION_ID        IN (SELECT DIVISION_ID FROM @v_tb_target_division) -- @p_division_id  -- 전체 Division 동시 생성
            AND TACT_TIME_END_DATE >= @p_plan_start_yyyymmdd
            AND LINE_ID             = '-'

        ---------------------------------------------------------------
        -- SCP_MST_TACT_TIME_EXCEPT INSERT 
        --------------------------------------------------------------- 
		
          INSERT INTO SCP_MST_TACT_TIME_EXCEPT
                    (DIVISION_ID
                    ,PLANT_SITE_ID
                    ,ITEM_ID
                    ,OPERATION_ID
                    ,LINE_ID
                    ,TACT_TIME_START_DATE
                    ,TACT_TIME_END_DATE
                    ,TACT_TIME
                    ,YIELD
                    ,EXCEPT_COMMENT
                    ,USE_YN
                    ,CREATED_BY
                    ,CREATION_DATE
                    ,LAST_UPDATED_BY
                    ,LAST_UPDATE_DATE
                    --,ATTRIBUTE1
                    --,ATTRIBUTE2
                    --,ATTRIBUTE3
                    --,ATTRIBUTE4
                    --,ATTRIBUTE5
                    --,ATTRIBUTE6
                    --,ATTRIBUTE7
                    --,ATTRIBUTE8
                    --,ATTRIBUTE9
                    --,ATTRIBUTE10
                    )
        
            SELECT XX.DIVISION_ID
                  ,XX.PLANT_SITE_ID
                  ,XX.ITEM_ID
                  ,XX.OPERATION_ID
                  ,'-' AS LINE_ID
                  ,XX.TACT_TIME_START_DATE
                  ,XX.TACT_TIME_END_DATE
                  ,MAX(XX.TACT_TIME) AS TACT_TIME
                  ,COALESCE(MAX(XX.LINE_TOTAL_QTY) /ISNULL(NULLIF(SUM(XX.LINE_QTY_YIELD),0) ,1) ,AVG(XX.YIELD_AVG)) FINAL_AVG
                  ,N'전극 수율' AS EXCEPT_COMMENT
                  ,MAX(XX.USE_YN) AS USE_YN -- N 처리 방법?
                  ,@v_batch_user AS  CREATED_BY
                  ,GETDATE() AS CREATION_DATE
                  ,@v_batch_user AS LAST_UPDATED_BY
                  ,GETDATE() AS LAST_UPDATE_DATE
                  /*
                  ,MAX(XX.LINE_TOTAL_QTY) AS LINE_TOTAL_QTY
                  ,MAX(XX.LINE_QTY) AS LINE_QTY
                  ,MAX(XX.LTQ_LQ) AS LTQ_LQ
                  ,SUM(XX.LINE_QTY_YIELD) AS LINE_QTY_YIELD
                  ,SUM(XX.LTQ_LQ_M_YIELD) AS LTQ_LQ_M_YIELD      -- 가중평균
                  ,MAX(XX.LINE_TOTAL_QTY) /ISNULL(NULLIF(SUM(XX.LINE_QTY_YIELD),0) ,1) AS TOTAL_AVG  -- 총평균
                  ,AVG(XX.YIELD_AVG) AS YIELD_AVG -- 일반평균
                  ,COALESCE(SUM(XX.LTQ_LQ_M_YIELD),MAX(XX.LINE_TOTAL_QTY) /ISNULL(NULLIF(SUM(XX.LINE_QTY_YIELD),0) ,1) ,AVG(XX.YIELD_AVG)) FINAL_AVG
                  ,MAX(XX.Rn) AS Rn
                  ,MAX(XX.START_DATE) AS START_DATE
                  ,MAX(XX.END_DATE) AS END_DATE
                  ,MAX(XX.YYYYMMDD) AS YYYYMMDD
                  */
            FROM
                (
                  SELECT X.DIVISION_ID
                        ,X.PLANT_SITE_ID
                        ,X.ITEM_ID
                        ,X.OPERATION_ID
                        ,X.LINE_ID
                        ,X.TACT_TIME_START_DATE
                        ,X.TACT_TIME_END_DATE
                        ,X.TACT_TIME
                        ,X.YIELD
                        ,X.USE_YN 
                        ,Y.LINE_TOTAL_QTY
                        ,Y.LINE_QTY
                        ,(Y.LINE_QTY/ISNULL(NULLIF(Y.LINE_TOTAL_QTY,0),1)) AS LTQ_LQ
                        ,(Y.LINE_QTY/ISNULL(NULLIF(Y.LINE_TOTAL_QTY,0),1)) * X.YIELD AS LTQ_LQ_M_YIELD
                        ,(Y.LINE_QTY/ISNULL(NULLIF(X.YIELD,0),1)) AS LINE_QTY_YIELD
                        ,AVG(X.YIELD) OVER(PARTITION BY X.DIVISION_ID,X.PLANT_SITE_ID,X.ITEM_ID,X.OPERATION_ID,X.TACT_TIME_START_DATE,X.TACT_TIME_END_DATE,X.TACT_TIME ORDER BY X.DIVISION_ID) AS YIELD_AVG
                        ,Y.Rn
                        ,Y.START_DATE
                        ,Y.END_DATE
                        ,Y.YYYYMMDD
                  FROM (
                        SELECT DIVISION_ID
                              ,PLANT_SITE_ID
                              ,ITEM_ID
                              ,OPERATION_ID
                              ,LINE_ID
                              ,TACT_TIME_START_DATE
                              ,TACT_TIME_END_DATE
                              ,TACT_TIME
                              ,YIELD
                              ,EXCEPT_COMMENT
                              ,USE_YN 
                         FROM SCP_MST_TACT_TIME_EXCEPT WITH (NOLOCK)
                        WHERE 0 = 0
						
                          -- PJ20216891
                          -- AND DIVISION_ID        IN ('40', '81', '82') -- @p_division_id  -- 전체 Division 동시 생성
                          AND DIVISION_ID        IN (SELECT DIVISION_ID FROM @v_tb_target_division) -- @p_division_id  -- 전체 Division 동시 생성
                          AND OPERATION_ID       IN ('Z_A00T','Z_E00T')
                          AND TACT_TIME_END_DATE >= @p_plan_start_yyyymmdd
                          AND LINE_ID            <> '-'
                          AND USE_YN              = 'Y'
                        
                      ) X
                      LEFT OUTER JOIN (
                                      SELECT A.DIVISION_ID
                                            ,A.PLAN_START_YYYYMMDD
                                            ,A.PLAN_TYPE
                                            ,A.SCM_SITE_ID
                                            ,A.ITEM_ID
                                            ,A.LINE_ID
                                            ,A.OPERATION_ID
                                            --,A.MEASURE
                                            ,A.YYYYMMDD
                                            ,A.QTY
                                            ,A.ORIGIN_DIVISION_ID
                                            ,B.TACT_TIME_START_DATE
                                            ,B.TACT_TIME_END_DATE
                                            ,MIN(A.YYYYMMDD) OVER(PARTITION BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SCM_SITE_ID,A.ITEM_ID,          A.OPERATION_ID,B.TACT_TIME_START_DATE,B.TACT_TIME_END_DATE ORDER BY A.DIVISION_ID) AS START_DATE
                                            ,MAX(A.YYYYMMDD) OVER(PARTITION BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SCM_SITE_ID,A.ITEM_ID,          A.OPERATION_ID,B.TACT_TIME_START_DATE,B.TACT_TIME_END_DATE ORDER BY A.DIVISION_ID) AS END_DATE
                                            ,SUM(A.QTY)      OVER(PARTITION BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SCM_SITE_ID,A.ITEM_ID,          A.OPERATION_ID,B.TACT_TIME_START_DATE,B.TACT_TIME_END_DATE ORDER BY A.DIVISION_ID) AS LINE_TOTAL_QTY
                                            ,SUM(A.QTY)      OVER(PARTITION BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SCM_SITE_ID,A.ITEM_ID,A.LINE_ID,A.OPERATION_ID,B.TACT_TIME_START_DATE,B.TACT_TIME_END_DATE ORDER BY A.DIVISION_ID) AS LINE_QTY
                                            ,ROW_NUMBER()    OVER(PARTITION BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SCM_SITE_ID,A.ITEM_ID,A.LINE_ID,A.OPERATION_ID,B.TACT_TIME_START_DATE,B.TACT_TIME_END_DATE ORDER BY A.DIVISION_ID) AS Rn
                                            --,A.ELECTRODE_TYPE 
                                      FROM SCP_PLN_ELEC_DEMAND_CELL_PLAN A WITH (NOLOCK)
                                      INNER JOIN  (SELECT DIVISION_ID
                                                        ,PLANT_SITE_ID
                                                        ,ITEM_ID
                                                        ,OPERATION_ID
                                                        ,LINE_ID
                                                        ,TACT_TIME_START_DATE
                                                        ,TACT_TIME_END_DATE
                                                        ,USE_YN 
                                                   FROM SCP_MST_TACT_TIME_EXCEPT WITH (NOLOCK)
                                                  WHERE 0 = 0
												  
                                                    -- PJ20216891
                                                    -- AND DIVISION_ID        IN ('40', '81', '82') -- @p_division_id  -- 전체 Division 동시 생성
                                                    AND DIVISION_ID        IN (SELECT DIVISION_ID FROM @v_tb_target_division) -- @p_division_id  -- 전체 Division 동시 생성
                                                    AND OPERATION_ID       IN ('Z_A00T','Z_E00T')
                                                    AND TACT_TIME_END_DATE >= @p_plan_start_yyyymmdd
                                                    AND LINE_ID            <> '-'
                                                    AND USE_YN              = 'Y'
                                                 
                                                   ) B
                                          ON 0 = 0
                                         AND A.ORIGIN_DIVISION_ID = B.DIVISION_ID  -- Org Division 으로 비교
                                         AND A.SCM_SITE_ID        = B.PLANT_SITE_ID
                                         AND A.ITEM_ID            = B.ITEM_ID
                                         AND A.LINE_ID            = B.LINE_ID
                                       WHERE 0 = 0
                                         AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                         AND A.PLAN_TYPE           = @p_plan_type
                                        --AND A.QTY                 > 0
                                         AND YYYYMMDD              >= B.TACT_TIME_START_DATE
                                         AND YYYYMMDD              <= B.TACT_TIME_END_DATE
                                      ) Y
                    ON Y.rn =1 --OR Y.rn IS NULL
                   AND X.DIVISION_ID          = Y.ORIGIN_DIVISION_ID   -- Org Division 으로 비교
                   AND X.PLANT_SITE_ID        = Y.SCM_SITE_ID
                   AND X.ITEM_ID              = Y.ITEM_ID
                   AND X.LINE_ID              = Y.LINE_ID
                   AND Y.YYYYMMDD            >= X.TACT_TIME_START_DATE
                   AND Y.YYYYMMDD            <= X.TACT_TIME_END_DATE

                ) XX
            WHERE 0 = 0
                AND XX.TACT_TIME_END_DATE >= @p_plan_start_yyyymmdd
            GROUP BY   XX.DIVISION_ID
                      ,XX.PLANT_SITE_ID
                      ,XX.ITEM_ID
                      ,XX.OPERATION_ID
                      ,XX.TACT_TIME_START_DATE
                      ,XX.TACT_TIME_END_DATE
 

        SET @n_log_count = @@ROWCOUNT;
    
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
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

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 


  END;


