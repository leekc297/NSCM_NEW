

/*
 * Program ID   : PR_SCM_KPI_CFA_SUMMARY
 * Description  : KPI Summary 데이타 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.22   YYDOK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.12.11   YYDOK      scm_kpi_summary.YYYYMMDD에 대각선상단의 일자로 값을 생성.  
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_CFA_SUMMARY]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_CFA_SUMMARY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_CFA_SUMMARY'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' PR_SCM_KPI_CFA_SUMMARY INSERT LOGIC';
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

  DECLARE @v_kpi_type        NVARCHAR(30) =N'CFA'; -- KPI 유형
  DECLARE @v_measure_plan    NVARCHAR(50) =N'CUST_FCST'; -- Plan Measure
  DECLARE @v_measure_result  NVARCHAR(50) =N'SALES'; -- Result Measure

  DECLARE @n_planning_week_offset INT;
  DECLARE @n_period               INT = 12;
  
    
    BEGIN TRY
      BEGIN
      -- 기준일자 설정, Default 전주차 KPI 생성
        IF @p_basis_yyyymmdd IS NOT NULL
          BEGIN
            SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
          END
        ELSE
          BEGIN
            SET @v_basis_yyyymmdd = DBO.FN_GET_BUCKET_YYYYMMDD(-1); -- 전주차의 월요일(W-1)
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


	WITH WEEK_KPI AS
	(
				  SELECT RST.division_id
						,RST.project_code
						,RST.sales_site_id
						,RST.item_id
						, @v_basis_yyyymmdd              AS basis_yyyymmdd
						, ( SELECT TOP 1 CM.WEEK_NAME
							  FROM scm_sys_calendar_m cm WITH(NOlOCK)
							 WHERE cm.basis_yyyymmdd = @v_basis_yyyymmdd
						  ) AS BASIS_WEEK
						, PLN.PLAN_START_YYYYMMDD
						, DATEDIFF(WEEK,CONVERT(DATETIME,PLN.PLAN_START_YYYYMMDD,112),CONVERT(DATETIME,RST.YYYYMMDD,112))+1 AS KPI_PLANNING_OFFSET
						, RST.YYYYMMDD AS RST_YYYYMMDD
						, PLN.YYYYMMDD AS PLN_YYYYMMDD
						, ISNULL(PLN.QTY,0) AS PLN_QTY
						,ISNULL(RST.QTY,0) AS RST_QTY
						, (CASE WHEN ISNULL(PLN.QTY,0) =  0 THEN 0 
								WHEN (1 - ABS(ISNULL(RST.QTY, 0)-PLN.QTY)/PLN.QTY) < 0 THEN 0 
								ELSE ROUND(
										   (1 - ABS(ISNULL(RST.QTY, 0)-PLN.QTY)/PLN.QTY)
										   ,3) 
						   END) AS KPI_RATE
				  FROM  (SELECT --*
								kd.division_id
							   ,kd.project_code
							   ,kd.sales_site_id
							   ,kd.item_id
							   ,kd.plan_start_yyyymmdd
							   ,kd.plan_week       
							   ,kd.measure
							   ,C.BASIS_YYYYMMDD AS YYYYMMDD
							   ,MAX(CASE WHEN KD.YYYYMMDD = C.BASIS_YYYYMMDD THEN KD.QTY
								   ELSE 0
								  END) AS QTY
						 FROM  
                     
								  ( SELECT BASIS_YYYYMMDD
									   FROM scm_sys_calendar_m WITH(NOLOCK)
									  WHERE BASIS_YYYYMMDD > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
										AND BASIS_YYYYMMDD <= @v_basis_yyyymmdd
										AND DAYOFWEEK_NO =2 --MON 
										) C
									CROSS APPLY
									scm_kpi_detail kd WITH(NOLOCK)
						 WHERE  kd.plan_start_yyyymmdd  > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, '20181126', 112)), 112)
						 AND    kd.plan_start_yyyymmdd  <= @v_basis_yyyymmdd
						 AND    kd.yyyymmdd              <=@v_basis_yyyymmdd 
						 AND    kd.measure              = 'CUST_FCST'--@v_measure_plan
						-- AND    kd.qty                  > 0
						AND C.BASIS_YYYYMMDD >= kd.plan_start_yyyymmdd
					   -- AND KD.DIVISION_ID ='81'
					   -- AND KD.PROJECT_CODE ='A15GM3003'
					   -- AND KD.SALES_SITE_ID='LGE_US_HZP'
					   -- AND KD.ITEM_ID='ACEN1059I-A1'
					   GROUP BY kd.division_id
							   ,kd.project_code
							   ,kd.sales_site_id
							   ,kd.item_id
							   ,kd.plan_start_yyyymmdd
							   ,kd.plan_week       
							   ,kd.measure
							   ,C.BASIS_YYYYMMDD
						) pln
					   RIGHT OUTER JOIN  
							 (SELECT kd.division_id
									,kd.project_code
									,kd.sales_site_id
									,kd.item_id
									,kd.yyyymmdd
									,kd.measure
									,kd.qty
							FROM   --( SELECT BASIS_YYYYMMDD
								   --    FROM scm_sys_calendar_m WITH(NOLOCK)
								   --   WHERE BASIS_YYYYMMDD > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
								   --     AND BASIS_YYYYMMDD <= @v_basis_yyyymmdd
								   --     AND DAYOFWEEK_NO =2 --MON 
								   --     ) C
								   -- LEFT OUTER JOIN
									scm_kpi_detail kd WITH(NOLOCK)
								   -- ON C.BASIS_YYYYMMDD = KD.YYYYMMDD
							WHERE  kd.plan_start_yyyymmdd  = @v_basis_yyyymmdd
							AND    kd.measure              = 'SALES'--@v_measure_result
						 --   AND    kd.qty                  > 0  
					  --  AND KD.DIVISION_ID ='81'
					  --  AND KD.PROJECT_CODE ='A15GM3003'
					  --  AND KD.SALES_SITE_ID='LGE_US_HZP'
					  --  AND KD.ITEM_ID='ACEN1059I-A1'                                   
							AND    kd.planning_week_offset = 0 -- 실적은 그주차 Data 만 존재
					  --  ORDER BY 1,2,3,4,5
						   ) rst
							ON     pln.division_id   = rst.division_id
							AND    pln.project_code  = rst.project_code
							AND    pln.sales_site_id = rst.sales_site_id
							AND    pln.item_id       = rst.item_id
							AND    pln.yyyymmdd      = rst.yyyymmdd
					  WHERE PLN.PLAN_START_YYYYMMDD <= RST.YYYYMMDD
						AND (ISNULL(PLN.QTY,0) + ISNULL(RST.QTY,0)) > 0 --둘다 없는것 제외
				   /*  ORDER BY RST.division_id
						,RST.project_code
						,RST.sales_site_id
						,RST.item_id
						,PLN.PLAN_START_YYYYMMDD
						,RST.YYYYMMDD
					*/
             
	)
	INSERT INTO scm_kpi_summary (
		   division_id
		  ,project_code
		  ,sales_site_id
		  ,item_id
		  ,basis_yyyymmdd
		  ,basis_week           
      ,planning_week_offset -- KPI OFFSET (1~12),DATEDIFF이 아님.
      ,YYYYMMDD             --대각선 상단에 있는 날짜.
		  ,kpi_type
		  ,accumulated_yn   -- kpi rate가 week누적인지 여부
		  ,kpi_rate
		  ,weight
		  ,valid_yn
		  ,created_by
		  ,creation_date
		  ,last_updated_by
		  ,last_update_date)
	SELECT DIVISION_ID,
		   PROJECT_CODE,
		   SALES_SITE_ID,
		   ITEM_ID,
		   BASIS_YYYYMMDD,
		   BASIS_WEEK,
       KPI_PLANNING_OFFSET,
       CONVERT(VARCHAR(08), DATEADD(WW, KPI_PLANNING_OFFSET-12, CONVERT(DATE, BASIS_YYYYMMDD, 112)), 112),
		   @v_kpi_type             AS KPI_TYPE,
		   ACCUMULATED_YN,
		   KPI_RATE,
		   WEIGHT,
		 --  1             AS WEIGHT,
		   'Y'           AS VALID_YN,
		   @v_batch_user AS CREATED_BY,
		   GETDATE()     AS CREATION_DATE,
		   @v_batch_user AS LAST_UPDATED_BY,
		   GETDATE()     AS LAST_UPDATE_DATE       
	FROM       
	(
	/**********************
	 * WEEK RFCR
	 **********************/
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 KPI_PLANNING_OFFSET,
			 'N'                    AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3) AS KPI_RATE,
			 SUM(PLN_QTY)           AS WEIGHT
		FROM WEEK_KPI
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 KPI_PLANNING_OFFSET
	UNION ALL
	/**********************
	 * ACCUMULATED RFCR
	 **********************/
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 1                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 1
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 2                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 2
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 3                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 3
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 4                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 4
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 5                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 5
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 6                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 6
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 7                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 7
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 8                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 8
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 9                        AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 9
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 10                       AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 10
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 11                       AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 11
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	UNION ALL
	 SELECT  DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK,
			 12                       AS KPI_PLANNING_OFFSET,
			 'Y'                      AS ACCUMULATED_YN,
			 ROUND(AVG(KPI_RATE),3)   AS KPI_RATE,
			 SUM(PLN_QTY)             AS WEIGHT
		FROM WEEK_KPI
	   WHERE KPI_PLANNING_OFFSET <= 12
	   GROUP BY 
			 DIVISION_ID,
			 PROJECT_CODE,
			 SALES_SITE_ID,
			 ITEM_ID,
			 BASIS_YYYYMMDD,
			 BASIS_WEEK
	) X 
	;        
   
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
