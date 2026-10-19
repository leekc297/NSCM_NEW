

/*
 * Program ID   : PR_SCM_KPI_SFA_SUMMARY
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
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_SFA_SUMMARY]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_SFA_SUMMARY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_SFA_SUMMARY'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' PR_SCM_KPI_SFA_SUMMARY INSERT LOGIC';
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

  DECLARE @v_kpi_type        NVARCHAR(30) =N'SFA'; -- KPI 유형
  DECLARE @v_measure_plan    NVARCHAR(50) =N'MKT_FCST'; -- Plan Measure
  DECLARE @v_measure_result  NVARCHAR(50) =N'SALES'; -- Result Measure

  DECLARE @n_planning_week_offset INT;
  DECLARE @n_period               INT = 12;
 
  DECLARE @no  numeric;  
    
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
		  
	IF  OBJECT_ID(N'dbo.#ROW_TABLE', N'U') IS NOT NULL 
			DROP TABLE #ROW_TABLE ;

	CREATE TABLE #ROW_TABLE  ( 
				 DIVISION_ID          NVARCHAR(30)
				,PROJECT_CODE         NVARCHAR(50)
				,SCM_SITE_ID          NVARCHAR(30)
				,ITEM_ID              NVARCHAR(50)
				,YYYYMMDD             NVARCHAR(10)
				,measure_qty          NUMERIC(20, 10)
				,SALES_QTY            NUMERIC(20, 10)
				,KPI_TYPE             NVARCHAR(30)
				,KPI                  NUMERIC(20, 10)
				,OFFSET               NUMERIC(20)
						)


    ------------------------------------------------------------------------------------
    -- Summary 생성 (Rate 까지 계산해서 DW 로 전송하는 KPI)
    ------------------------------------------------------------------------------------

    DELETE 
    FROM   scm_kpi_summary
    WHERE  basis_yyyymmdd = @v_basis_yyyymmdd
      AND  KPI_TYPE       in ( 'CFA','SFA','RFCR')
        ;


  DECLARE ACCUM_WEEK CURSOR FOR
                          select *
							from (
									select 0 no union all select 1 no union all select 2 no union all select 3 no union all select 4 no 
									union all select 5 no union all select 6 no union all select 7 no union all select 8 no union all select 9 no  
									union all select 10 no union all select 11 no 
								) z
							order by no
    ;

    OPEN ACCUM_WEEK;
    FETCH NEXT FROM ACCUM_WEEK INTO @no;
        
    WHILE (@@FETCH_STATUS = 0)
      BEGIN

                       with KPI_CAL_RAW AS (
							                            SELECT KEY_LIST.DIVISION_ID, KEY_LIST.PROJECT_CODE, KEY_LIST.SALES_SITE_ID, KEY_LIST.ITEM_ID, WEEKS.basis_yyyymmdd yyyymmdd
                                          ,isnull(mkt_fcst_dtl.qty,0) MKT_FCST_QTY
										  ,isnull(rtf_dtl.qty,0) RTF_QTY
										  ,isnull(cust_fcst_dtl.qty,0) CUST_FCST_QTY
										  ,isnull(sales_dtl.qty,0) SALES_QTY
							  FROM (  -- 대상 Key List 
							         select distinct * from (
										SELECT DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, ITEM_ID
										  FROM [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL] a with(nolock)
										 WHERE QTY > 0 
										   and MEASURE in ('SALES' )
										   and plan_start_yyyymmdd = @v_basis_yyyymmdd  -- 주차 변경 값
										UNION ALL
										SELECT DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, ITEM_ID
										  FROM [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL] a with(nolock)
										 WHERE QTY > 0 
										   and MEASURE in ('MKT_FCST','RTF','CUST_FCST' )
										   and plan_start_yyyymmdd >= convert( varchar, dateadd(WEEK,-11, cast(@v_basis_yyyymmdd as datetime)) ,112)  -- 주차 변경 값
										) W
								   ) KEY_LIST
								INNER JOIN (
										select basis_yyyymmdd
											from [dbo].[SCM_SYS_CALENDAR_M] with(nolock)
											where dayofweek='MON'
											and basis_yyyymmdd between convert( varchar, dateadd(WEEK,-11 +@no/* 변경 off set*/, cast(@v_basis_yyyymmdd as datetime)) ,112)  and @v_basis_yyyymmdd
					     			) AS WEEKS
								on 1=1
								LEFT JOIN [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL]  mkt_fcst_dtl with(nolock)
								ON KEY_LIST.division_id   = mkt_fcst_dtl.DIVISION_ID
								and KEY_LIST.project_code  = mkt_fcst_dtl.PROJECT_CODE
								and KEY_LIST.sales_site_id = mkt_fcst_dtl.SALES_SITE_ID
								and KEY_LIST.item_id       = mkt_fcst_dtl.ITEM_ID
								and WEEKS.basis_yyyymmdd   = mkt_fcst_dtl.yyyymmdd
								and mkt_fcst_dtl.MEASURE            = 'MKT_FCST'
								and mkt_fcst_dtl.planning_week_offset = +@no /* 변경 off set*/
								and mkt_fcst_dtl.qty > 0 
								LEFT JOIN [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL]  cust_fcst_dtl with(nolock)
								ON KEY_LIST.division_id   = cust_fcst_dtl.DIVISION_ID
								and KEY_LIST.project_code  = cust_fcst_dtl.PROJECT_CODE
								and KEY_LIST.sales_site_id = cust_fcst_dtl.SALES_SITE_ID
								and KEY_LIST.item_id       = cust_fcst_dtl.ITEM_ID
								and WEEKS.basis_yyyymmdd   = cust_fcst_dtl.yyyymmdd
								and cust_fcst_dtl.MEASURE            = 'CUST_FCST'
								and cust_fcst_dtl.planning_week_offset = +@no /* 변경 off set*/
								and cust_fcst_dtl.qty > 0 
								LEFT JOIN [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL]  rtf_dtl with(nolock)
								ON KEY_LIST.division_id   = rtf_dtl.DIVISION_ID
								and KEY_LIST.project_code  = rtf_dtl.PROJECT_CODE
								and KEY_LIST.sales_site_id = rtf_dtl.SALES_SITE_ID
								and KEY_LIST.item_id       = rtf_dtl.ITEM_ID
								and WEEKS.basis_yyyymmdd   = rtf_dtl.yyyymmdd
								and rtf_dtl.MEASURE            = 'RTF'
								and rtf_dtl.planning_week_offset = +@no /* 변경 off set*/
								and rtf_dtl.qty > 0 
								LEFT JOIN [LGCE_SCMDEV].[dbo].[SCM_KPI_DETAIL]  sales_dtl with(nolock)
								ON KEY_LIST.division_id   = sales_dtl.DIVISION_ID
								and KEY_LIST.project_code  = sales_dtl.PROJECT_CODE
								and KEY_LIST.sales_site_id = sales_dtl.SALES_SITE_ID
								and KEY_LIST.item_id       = sales_dtl.ITEM_ID
								and WEEKS.basis_yyyymmdd   = sales_dtl.yyyymmdd
								and sales_dtl.MEASURE            = 'SALES'
								and sales_dtl.plan_start_yyyymmdd = @v_basis_yyyymmdd
								and sales_dtl.qty > 0      -- 음수값은 제외
					    )
                            insert into #ROW_TABLE
							select DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,ITEM_ID,YYYYMMDD
							     ,MKT_FCST_QTY measure_qty
								 ,SALES_QTY
							     ,'SFA' kpi_type
								 ,CASE WHEN ISNULL(MKT_FCST_QTY,0) +ISNULL(SALES_QTY,0) = 0 THEN NULL -- Null로 data set은 만들지만 avg 계산에서는 제외도록 처리 
								       WHEN MKT_FCST_QTY = 0 THEN 0
									   WHEN SALES_QTY/MKT_FCST_QTY > 2 THEN 0 
									   ELSE 1-abs(MKT_FCST_QTY-SALES_QTY)/MKT_FCST_QTY
								   END KPI
								 , @no offset
							  from KPI_CAL_RAW
                            union all
							select DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,ITEM_ID,YYYYMMDD
							     ,CUST_FCST_QTY measure_qty
								 ,SALES_QTY
							     ,'CFA' kpi_type
								 ,CASE WHEN ISNULL(CUST_FCST_QTY,0) +ISNULL(SALES_QTY,0) = 0 THEN NULL  -- Null로 data set은 만들지만 avg 계산에서는 제외도록 처리 
								       WHEN CUST_FCST_QTY = 0 THEN 0
									   WHEN SALES_QTY/CUST_FCST_QTY > 2 THEN 0 
									   ELSE 1-abs(CUST_FCST_QTY-SALES_QTY)/CUST_FCST_QTY
								   END KPI
								 , @no offset
							  from KPI_CAL_RAW
                            union all
							select DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,ITEM_ID,YYYYMMDD
							     ,RTF_QTY measure_qty
								 ,SALES_QTY
							     ,'RFCR' kpi_type
								 ,CASE WHEN ISNULL(RTF_QTY,0) +ISNULL(SALES_QTY,0) = 0 THEN NULL   -- Null로 data set은 만들지만 avg 계산에서는 제외도록 처리 
								       WHEN RTF_QTY = 0 THEN 0
									   WHEN SALES_QTY/RTF_QTY > 2 THEN 0 
									   ELSE 1-abs(RTF_QTY-SALES_QTY)/RTF_QTY
								   END KPI
								 , @no offset
							  from KPI_CAL_RAW


     FETCH NEXT FROM ACCUM_WEEK INTO @no;

	 END
      
    CLOSE ACCUM_WEEK;
    DEALLOCATE ACCUM_WEEK;      

  --------------------------- WEEKLY  계산 START ---------------------------------------
                        INSERT INTO SCM_KPI_SUMMARY
						select division_id, project_code, SCM_SITE_ID, item_id
							 ,@v_basis_yyyymmdd plan_start_yyyymmdd
							 , (
								   select week_name
									 from [dbo].[SCM_SYS_CALENDAR_M] with(nolock)
									where basis_yyyymmdd = @v_basis_yyyymmdd
							   ) plan_week,null,null
							 ,CONVERT(VARCHAR(08), DATEADD(WW, offset+1-12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112) -- yyyymmdd
							 ,offset+1
							 ,kpi_type
							 ,'N'--ACCUMULATED_YN
							 , avg(kpi) kpi_rate
							 , sum(measure_qty) weight
							 ,'Y'--valid_yn
							 ,'scm_batch'
							 ,getdate()
							 ,'scm_batch'
							 ,getdate()
							 ,null,null,null,null,null,null,null,null,null,null
							 ,( SELECT 
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
								 WHERE t1.division_id  = a.division_id
								   and t1.item_id      = a.item_id              
										   )      
						  from #ROW_TABLE a
						 group by division_id, project_code, SCM_SITE_ID, item_id, offset, kpi_type
						;

  --------------------------- WEEKLY  계산 END   ---------------------------------------


  --------------------------- ACCMULATE  계산 START ---------------------------------------
  DECLARE ACCUM_WEEK CURSOR FOR
                          select *
							from (
									select 0 no union all select 1 no union all select 2 no union all select 3 no union all select 4 no 
									union all select 5 no union all select 6 no union all select 7 no union all select 8 no union all select 9 no  
									union all select 10 no union all select 11 no 
								) z
							order by no
    ;

    OPEN ACCUM_WEEK;
    FETCH NEXT FROM ACCUM_WEEK INTO @no;
        
    WHILE (@@FETCH_STATUS = 0)
      BEGIN
	                   INSERT INTO SCM_KPI_SUMMARY
						select division_id, project_code, SCM_SITE_ID, item_id
							 ,@v_basis_yyyymmdd plan_start_yyyymmdd
							 , (
								   select week_name
									 from [dbo].[SCM_SYS_CALENDAR_M] with(nolock)
									where basis_yyyymmdd = @v_basis_yyyymmdd
							   ) plan_week,null,null
							 ,CONVERT(VARCHAR(08), DATEADD(WW, @no+1-12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112) -- yyyymmdd
							 ,@no+1
							 ,a.kpi_type
							 ,'Y'--ACCUMULATED_YN
							 , ( SELECT avg(kpi)
							       FROM #ROW_TABLE b
								  where a.division_id = b.division_id
								    and a.project_code = b.project_code
									and a.scm_site_id  = b.SCM_SITE_ID
									and a.item_id      = b.item_id
									and a.kpi_type     = b.kpi_type
									and @no      >= b.offset
								) kpi_rate
							 , (  SELECT sum(measure_qty)
									FROM #ROW_TABLE b
									where a.division_id = b.division_id
									and a.project_code = b.project_code
									and a.scm_site_id  = b.SCM_SITE_ID
									and a.item_id      = b.item_id
									and a.kpi_type     = b.kpi_type
									and @no      >= b.offset
								)  weight
							 ,'Y'--valid_yn
							 ,'scm_batch'
							 ,getdate()
							 ,'scm_batch'
							 ,getdate()
							 ,null,null,null,null,null,null,null,null,null,null
							 ,( SELECT 
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
								 WHERE t1.division_id  = a.division_id
								   and t1.item_id      = a.item_id              
										   )      
						  from ( SELECT DISTINCT  division_id, project_code, SCM_SITE_ID, item_id, kpi_type FROM #ROW_TABLE )  a
						;
     FETCH NEXT FROM ACCUM_WEEK INTO @no;

	 END
      
    CLOSE ACCUM_WEEK;
    DEALLOCATE ACCUM_WEEK;    


   /*
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
						 AND    kd.measure              = 'MKT_FCST'--@v_measure_plan
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
	*/
          
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
