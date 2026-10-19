

/*
 * Program ID   : PR_SCM_KPI_DIO_SUMMARY
 * Description  : KPI Summary 데이타 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.23   YYDOK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.11.28   YYDOK      생성대상 ITEM을 PACK,MODULE,CELL로 제한함.
 * 2019.01.10   YYDOK      DIO 최대치를 180일로 정함.
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_DIO_SUMMARY]
(
   @p_basis_yyyymmdd  NVARCHAR(8)
 )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_DIO_SUMMARY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_DIO_SUMMARY'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' PR_SCM_KPI_DIO_SUMMARY INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

  -- 업무용 변수
  DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자

  DECLARE @v_kpi_type        NVARCHAR(30) =N'DIO'; -- KPI 유형
  
    
    BEGIN TRY
      BEGIN
      -- 기준일자 설정, Default 당월1일
        IF @p_basis_yyyymmdd IS NOT NULL
          BEGIN
            SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
          END
        ELSE
          BEGIN
            SET @v_basis_yyyymmdd = LEFT(CONVERT(VARCHAR,GETDATE(),112),6)+'01' -- 당월 1일
          END
          ;



    ------------------------------------------------------------------------------------
    -- Summary 생성 (Rate 까지 계산해서 DW 로 전송하는 KPI)
    ------------------------------------------------------------------------------------

    DELETE 
    FROM   scm_kpi_summary
    WHERE  basis_yyyymmdd = @v_basis_yyyymmdd
      AND  KPI_TYPE       = @v_kpi_type
        ;

    IF OBJECT_ID('tempdb..#TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA') IS NOT NULL                
        DROP TABLE #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA ; 

    IF OBJECT_ID('tempdb..#TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1') IS NOT NULL                
        DROP TABLE #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1 ; 

WITH SUB AS
(
SELECT BASIS_YYYYMMDD,
       DIVISION_ID,
       ITEM_ID,
       YYYYMMDD,
       SUM(EOH_QTY)  AS EOH_QTY,
       SUM(FCST_QTY) AS FCST_QTY,
       ROUND(SUM( FCST_QTY ) OVER(PARTITION BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD),2) AS FCST_QTY_ACCUM  -- 누적합계          
FROM (
         SELECT F.BASIS_YYYYMMDD,
                F.DIVISION_ID,
                F.ITEM_ID,
                C.YYYYMMDD, -- EOMONTH
                0          AS EOH_QTY,
                ISNULL(SUM(F.QTY),0) AS FCST_QTY
           FROM SCM_KPI_DETAIL F WITH(NOLOCK)
                RIGHT OUTER JOIN 
                           (
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,0,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,1,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,2,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,3,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,4,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,5,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,6,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,7,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,8,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,9,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,10,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            UNION ALL
                            SELECT CONVERT(VARCHAR,EOMONTH(DATEADD(MM,11,CONVERT(DATETIME,@v_basis_yyyymmdd,112))),112)  AS YYYYMMDD
                            ) C
                            ON F.YYYYMMDD = C.YYYYMMDD
          WHERE 1=1
            AND F.MEASURE        ='MKT_FCST_MONTHLY'
            AND F.BASIS_YYYYMMDD =@v_basis_yyyymmdd
       --  AND F.DIVISION_ID ='81'
       --  AND F.ITEM_ID    ='MPCHPPVI044C' --'ACEN1063I-B1'
         GROUP BY F.BASIS_YYYYMMDD,
                  F.DIVISION_ID,
                  F.ITEM_ID,
                  C.YYYYMMDD
         --ORDER BY F.BASIS_YYYYMMDD,
         --         F.DIVISION_ID,
         --         F.ITEM_ID,
         --         C.YYYYMMDD
         UNION ALL 
         SELECT E.BASIS_YYYYMMDD,
                E.DIVISION_ID,
                E.ITEM_ID,
                E.BASIS_YYYYMMDD AS YYYYMMDD, -- EOMONTH
                SUM(E.QTY) AS EOH_QTY,
                0          AS FCST_QTY
           FROM SCM_KPI_DETAIL E WITH(NOLOCK)
          WHERE 1=1
            AND E.MEASURE        ='EOH'
            AND E.BASIS_YYYYMMDD =@v_basis_yyyymmdd
            AND EXISTS ( SELECT 'X'  -- FCST EXISTS
                           FROM SCM_KPI_DETAIL X WITH(NOLOCK)
                          WHERE X.BASIS_YYYYMMDD = E.BASIS_YYYYMMDD
                            AND X.DIVISION_ID    = E.DIVISION_ID
                            AND X.ITEM_ID        = E.ITEM_ID
                            AND X.MEASURE        = 'MKT_FCST_MONTHLY'
                        )
       --  AND E.DIVISION_ID ='81'
       --  AND E.ITEM_ID    ='MPCHPPVI044C'--'ACEN1063I-B1'
         GROUP BY E.BASIS_YYYYMMDD,
                  E.DIVISION_ID,
                  E.ITEM_ID,
                  E.BASIS_YYYYMMDD
      ) X
GROUP BY X.BASIS_YYYYMMDD,
         X.DIVISION_ID,
         X.ITEM_ID,
         X.YYYYMMDD,
         X.FCST_QTY 
)
SELECT SUB.BASIS_YYYYMMDD,
       SUB.DIVISION_ID,
       SUB.ITEM_ID,
       SUB.YYYYMMDD,
       SUB.EOH_QTY,
       SUB.FCST_QTY_ACCUM,
       LAG(SUB.FCST_QTY_ACCUM,1,0) OVER (PARTITION BY SUB.DIVISION_ID,SUB.ITEM_ID ORDER BY SUB.YYYYMMDD) AS LAG_FCST_QTY_ACCUM
  INTO #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA
  FROM SUB,
       SCM_KPI_ITEM_V V
 WHERE SUB.DIVISION_ID = V.DIVISION_ID
   AND SUB.ITEM_ID     = V.ITEM_ID
   AND V.OPERATION_GROUP_NAME IN ( 'PACK','MODULE','CELL' )
       ;

/* --data check
SELECT *
  FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA
 ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD
*/

          SELECT BASIS_YYYYMMDD
                ,DIVISION_ID          
                ,ITEM_ID           
                ,YYYYMMDD            
                ,EOH_QTY          
                ,FCST_QTY_ACCUM
                ,LAG_FCST_QTY_ACCUM
                , (SELECT TOP 1 YYYYMMDD           
                    FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA X WITH (NOLOCK)          
                    WHERE X.DIVISION_ID = A.DIVISION_ID
                      AND X.ITEM_ID     = A.ITEM_ID            
                      AND X.YYYYMMDD    > A.YYYYMMDD           
                      AND (A.FCST_QTY_ACCUM  + A.EOH_QTY  ) <= X.FCST_QTY_ACCUM           
                    ORDER BY YYYYMMDD
                    ) AS INV_YYYYMMDD 
                , (SELECT TOP 1 YYYYMMDD           
                    FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA X WITH (NOLOCK)          
                    WHERE X.DIVISION_ID = A.DIVISION_ID
                      AND X.ITEM_ID     = A.ITEM_ID            
                      --AND X.YYYYMMDD    > A.YYYYMMDD           
                      AND (A.FCST_QTY_ACCUM  + A.EOH_QTY  ) > X.FCST_QTY_ACCUM           
                    ORDER BY YYYYMMDD DESC
                    ) AS LAG_INV_YYYYMMDD 
                , (SELECT TOP 1 LAG_FCST_QTY_ACCUM           
                    FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA X WITH (NOLOCK)          
                    WHERE X.DIVISION_ID = A.DIVISION_ID
                      AND X.ITEM_ID     = A.ITEM_ID            
                      AND X.YYYYMMDD    > A.YYYYMMDD           
                      AND (A.FCST_QTY_ACCUM  + A.EOH_QTY  ) <= X.FCST_QTY_ACCUM           
                    ORDER BY YYYYMMDD
                    ) AS INV_LAG_FCST_QTY_ACCUM                            
                , (SELECT TOP 1 FCST_QTY_ACCUM           
                    FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA X WITH (NOLOCK)          
                    WHERE X.DIVISION_ID = A.DIVISION_ID
                      AND X.ITEM_ID     = A.ITEM_ID            
                      AND X.YYYYMMDD    > A.YYYYMMDD           
                      AND (A.FCST_QTY_ACCUM  + A.EOH_QTY  ) <= X.FCST_QTY_ACCUM           
                    ORDER BY YYYYMMDD
                    ) AS INV_FCST_QTY_ACCUM              
            INTO #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1          
            FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA A WITH (NOLOCK) 
           WHERE 1=1
           --AND EOH_QTY > 0 --BASIS_YYYYMMDD 
           ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD

/* -- data check
SELECT *
  FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1
 ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD
*/

/* -- data check
SELECT *
  FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1
 WHERE 1=1
   AND BASIS_YYYYMMDD = @v_basis_yyyymmdd
   AND YYYYMMDD       = @v_basis_yyyymmdd
 ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD
*/

/* --data check
SELECT BASIS_YYYYMMDD,
       DIVISION_ID,
       ITEM_ID,
       ISNULL(
               ROUND(
                     DATEDIFF(DD, CONVERT(DATETIME,BASIS_YYYYMMDD,112)
                                , CONVERT(DATETIME,LAG_INV_YYYYMMDD,112)
                              ) -- 재고소진 직전월까지의 일수차이
                     + 1.0  -- 시작일 1일추가반영
                     +
                     ( CASE WHEN ( INV_FCST_QTY_ACCUM - INV_LAG_FCST_QTY_ACCUM ) = 0 THEN 0
                          ELSE ( EOH_QTY - INV_LAG_FCST_QTY_ACCUM ) / ( INV_FCST_QTY_ACCUM - INV_LAG_FCST_QTY_ACCUM )
                       END  --전월이후 잔량의 당월수요대비 비율
                       *
                       CONVERT(NUMERIC,RIGHT(INV_YYYYMMDD,2)) --해당월의 일수
                     )
                     ,0)
             ,365)     AS DIO
  FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1
 WHERE 1=1
   AND BASIS_YYYYMMDD = @v_basis_yyyymmdd
   AND YYYYMMDD       = @v_basis_yyyymmdd
 ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD 
*/
 
INSERT INTO SCM_KPI_SUMMARY (
       BASIS_YYYYMMDD         --*
      ,DIVISION_ID            --*
      ,ITEM_ID                --*
      ,KPI_TYPE               --
      ,KPI_RATE               --
      ,PROJECT_CODE           --*
      ,SALES_SITE_ID          --*
      ,BASIS_WEEK             --
      ,PLANNING_WEEK_OFFSET   --*
      ,ACCUMULATED_YN         --*
      ,WEIGHT                 --
      ,VALID_YN               --
      ,CREATED_BY             --
      ,CREATION_DATE          --
      ,LAST_UPDATED_BY        --
      ,LAST_UPDATE_DATE)      --
SELECT  BASIS_YYYYMMDD
       ,DIVISION_ID
       ,ITEM_ID
       ,'DIO'
       ,ISNULL(
                 ROUND(
                       DATEDIFF(DD, CONVERT(DATETIME,BASIS_YYYYMMDD,112)
                                  , CONVERT(DATETIME,LAG_INV_YYYYMMDD,112)
                                ) -- 재고소진 직전월까지의 일수차이
                       + 1.0  -- 시작일 1일추가반영
                       +
                       ( CASE WHEN ( INV_FCST_QTY_ACCUM - INV_LAG_FCST_QTY_ACCUM ) = 0 THEN 0
                            ELSE ( EOH_QTY - INV_LAG_FCST_QTY_ACCUM ) / ( INV_FCST_QTY_ACCUM - INV_LAG_FCST_QTY_ACCUM )
                         END  --전월이후 잔량의 당월수요대비 비율
                         *
                         CONVERT(NUMERIC,RIGHT(INV_YYYYMMDD,2)) --해당월의 일수
                       )
                       ,0)
              ,365)     AS DIO
      ,''               --PROJECT_CODE           --*
      ,''               --SALES_SITE_ID          --*
      ,NULL             --BASIS_WEEK             --
      ,0                --PLANNING_WEEK_OFFSET   --*
      ,''               --ACCUMULATED_YN         --*
      ,NULL             --WEIGHT                 --
      ,'Y'              --VALID_YN               --
      ,@v_batch_user    --CREATED_BY             --
      ,GETDATE()        --CREATION_DATE          --
      ,@v_batch_user    --LAST_UPDATED_BY        --
      ,GETDATE()        --LAST_UPDATE_DATE)      --             
  FROM #TBL_SCM_KPI_SUMMARY_DIO_CUMUL_DATA1
 WHERE 1=1
   AND BASIS_YYYYMMDD = @v_basis_yyyymmdd
   AND YYYYMMDD       = @v_basis_yyyymmdd
 ORDER BY BASIS_YYYYMMDD,DIVISION_ID,ITEM_ID,YYYYMMDD     
    
    
    /************************************
     *  item type update
     ************************************/
    update scm_kpi_summary
       set item_type = 
                       ( SELECT 
                               case  min( 
                                          case when T1.item_type = 'P' then 1
                                               when T1.item_type = 'H' then 2
                                               when T1.item_type = 'Q' then 3
                                               else 4 
                                          end
                                         )  
                               when 1 then 'P' 
                               when 2 then 'H'
                               when 3 then 'Q'
                               else 'R' 
                               end
                          FROM dbo.SCM_MST_ITEM_SN T1 WITH(NOLOCK)
                         WHERE t1.division_id  = scm_kpi_summary.division_id
                           and t1.item_id      = scm_kpi_summary.item_id              
                                   )       
     where basis_yyyymmdd = @v_basis_yyyymmdd
       AND KPI_TYPE       = @v_kpi_type
        ;
    /************************************
     *  DIO 최대값 180로 지정
     ************************************/          
    update scm_kpi_summary
       set KPI_RATE = 180
     where basis_yyyymmdd = @v_basis_yyyymmdd
       AND KPI_TYPE       = @v_kpi_type
       and KPI_RATE       > 180 
        ;
                  
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @n_log_count = @@ROWCOUNT;
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
