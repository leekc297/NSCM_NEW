

/*
 * Program ID   : PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP
 * Description  : CREATE TACT TIME EXCEPT FROM FP
 *                FP의 Division별 MAX(version_id) Except 정보를 SCP Except 로 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.03.12   KSG           Initial Release PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2021.05.28   KSG           PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2022.03.25   sclee         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.16   KSG           속도 이슈로 Monthly Temp 생성 시 Division 조건 수정
 * 2022.06.27   sclee.lee     PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.30	HRK			  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP]
    ( @p_division_id         NVARCHAR(30) = NULL
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_TACT_TIME_EXCEPT'; 
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_period       INT = 450; -- Tact Time 생성 구간
    DECLARE @v_delete_date  NVARCHAR(6);
    DECLARE @v_end_month    NVARCHAR(6);
    DECLARE @v_pet_date     NVARCHAR(8) ; -- Plan End Date

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_TACT_TIME INSERT LOGIC';
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

	    -- Plan End Date까지 생성
	    SELECT @v_pet_date = MAX(p.horizon_end_date)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = ISNULL(@p_division_id, division_id)  
        AND    p.plan_cycle  = 'WEEKLY'
        AND    p.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) ;
    
        --BEGIN TRANSACTION; 
		SET  @v_delete_date = SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,-1,GETDATE()),112),1,6);
		  -- CONVERT(DATETIME, CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112));
		SET  @v_end_month = SUBSTRING(@v_pet_date, 1, 6); -- 20210528 PJ20209642 생성 기간
		
        ---------------------------------------------------------------------------- 
        -- 대상 사업부
        ---------------------------------------------------------------------------- 
        IF OBJECT_ID('tempdb..#scm_mst_division') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_division         
        END
        CREATE TABLE #scm_mst_division(
	        DIVISION_ID NVARCHAR(50) NOT NULL
		)
		
        -------------------------------------------------------------------------------------------------------------                     
        -- temp 테이블 (LOCATION_GROUP_ROUTE) 생성
        -------------------------------------------------------------------------------------------------------------                     
        IF OBJECT_ID('tempdb..#tmp_LOCATION_GROUP_ROUTE') IS NOT NULL
        BEGIN 
            DROP TABLE  #tmp_LOCATION_GROUP_ROUTE
        END
		
        SELECT DISTINCT b.segment4
        INTO   #tmp_LOCATION_GROUP_ROUTE
        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
        WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
        AND    b.valid_yn    = 'Y'
        AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
		
        -------------------------------------------------------------------------------------------------------------                     
        -- temp 테이블 (ISUZU) 생성
        -------------------------------------------------------------------------------------------------------------                     
        IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
        BEGIN 
            DROP TABLE  #tmp_ISUZU
        END
		
        -- PJ20216891
        -- ISUZU item
        SELECT A.ITEM_ID
        INTO   #tmp_ISUZU
        FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
        INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
        WHERE  A.IS_YN = 'Y'
	  
        ---------------------------------------------------------------------------- 
        -- SCP_MST_TACT_TIME_EXCEPT 구간 삭제 : 정상 Capa 대상 공정 : 적극용 전극 후공정 / Cell 조립 촘공정 수율은(Z_***) 삭제하면 안 됨
        ---------------------------------------------------------------------------- 
		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'ALL') <> 'EE'
        -- 2023.03.30 HM JV IF ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL 
		   OR 
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3 != 'EE'
					 AND VALID_YN	 = 'Y' ) 
        BEGIN
		  INSERT INTO #scm_mst_division
          SELECT division_id
          FROM   SCM_MST_DIVISION WITH(NOLOCK)
          WHERE  1=1
          AND    division_id = ISNULL(@p_division_id, division_id)
		  AND	 attribute3	!= 'EE'
		  AND	 valid_yn	 = 'Y'
          -- HM JV 대응 AND    division_id NOT LIKE N'EE%'

          DELETE dbo.scp_mst_tact_time_except
          FROM   dbo.scp_mst_tact_time_except t
          WHERE  1 = 1
          AND    t.division_id           = ISNULL(@p_division_id, t.division_id)
          AND    t.tact_time_end_date   >= @v_delete_date + '01'
		  
          -- PJ20216891	
          -- ISUZU item
          AND    (
                  t.operation_id IN (
                                     SELECT b.segment4
                                     FROM   #tmp_LOCATION_GROUP_ROUTE b
                                     WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                                    )
                  OR (
                      t.operation_id = 'P5000'
                      AND EXISTS (
                                  SELECT 1
                                  FROM   #tmp_ISUZU A
                                  WHERE  A.ITEM_ID = t.ITEM_ID
                                 )
                     )
                 )

          --DELETE scp_mst_tact_time_except 
          --WHERE  1=1
          --AND    division_id           = ISNULL(@p_division_id, division_id)     
          --AND    tact_time_end_date   >= @v_delete_date + '01'
          --AND    operation_id IN ( 
          --                        SELECT DISTINCT b.segment4
          --                        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
          --                        WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
          --                        AND    b.valid_yn    = 'Y'
          --                        AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
          --                        AND    SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
          --                       )

        END; -- IF ISNULL(@p_division_id, 'ALL') <> 'EE'

		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'EE') = 'EE'
		-- 2023.03.30 HM JV IF ISNULL(@p_division_id, 'EE') LIKE 'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL 
		   OR 
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y') 
        BEGIN
		
		  INSERT INTO #scm_mst_division
          SELECT division_id
          FROM   SCM_MST_DIVISION WITH(NOLOCK)
          WHERE  1=1
          AND    attribute4 =  (SELECT attribute4
                                FROM   SCM_MST_DIVISION WITH(NOLOCK)
                                WHERE  division_id = @p_division_id -- NULL 인 경우는 위에서 사업부 생성됨
								  AND  valid_yn	   = 'Y'
                               )
          AND    attribute3 != 'EE' -- 2023.03.30 HM JV 가상 사업부 추가 대응
		  AND	 valid_yn	 = 'Y'
		  -- 2023.03.30 HM JV AND    division_id NOT LIKE N'EE%'

          DELETE scp_mst_tact_time_except 
          WHERE  1=1
          --AND    division_id           = division_id  -- 전극 : 전체 사업부 : 20220616 주석
          AND    division_id          IN (SELECT division_id FROM #scm_mst_division)
          AND    tact_time_end_date   >= @v_delete_date + '01'
          AND    operation_id IN (
/* 		  
                                  SELECT DISTINCT b.segment4
                                  FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                                  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                  AND    b.valid_yn    = 'Y'
                                  AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
                                  AND    SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
*/
                                  SELECT b.segment4
                                  FROM   #tmp_LOCATION_GROUP_ROUTE b
                                  WHERE  SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                 )

          --DELETE scp_mst_tact_time_except 
          --WHERE  1=1
          ----AND    division_id           = division_id  -- 전극 : 전체 사업부 : 20220616 주석
          --AND    division_id          IN (SELECT division_id FROM #scm_mst_division)
          --AND    tact_time_end_date   >= @v_delete_date + '01'
          --AND    operation_id IN ( 
          --                        SELECT DISTINCT b.segment4
          --                        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
          --                        WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
          --                        AND    b.valid_yn    = 'Y'
          --                        AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
          --                        AND    SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
          --                       )
        ;
        END; -- ISNULL(@p_division_id, 'EE') = 'EE'
		
        ---------------------------------------------------------------------------- 
        -- Tact Time / Yield Monthly Temp 입력
        ---------------------------------------------------------------------------- 
        ----------
		-- 전극 외
        ----------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_v_div') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_v_div   
        END			
        IF OBJECT_ID('tempdb..#scm_mst_yield_ver_h_v_div') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_yield_ver_h_v_div   
        END		

		-- 전극 외 : Tact Time
		SELECT T.DIVISION_ID
            , T.PLANT_SITE_ID
            , T.ITEM_ID
            , T.OPERATION_ID
            , T.LINE_ID
            , T.MONTH                               
            , t.TACT_TIME
            , 0 AS YIELD
            , t.lane_qty AS lane_qty
        INTO #scm_mst_tact_time_ver_h_v_div
        FROM scm_mst_tact_time_ver_h_v t WITH(NOLOCK)							                   
        WHERE 1=1
        --AND T.DIVISION_ID    = ISNULL(@p_division_id, t.division_id)  -- 전극 외 : 20220616 주석
        AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
		AND ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'

        --AND T.OPERATION_ID   IN ( 
        --                        SELECT DISTINCT b.segment4
        --                        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
        --                        WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
        --                        AND    b.valid_yn    = 'Y'
        --                        AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							 --   AND    SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
        --                        )
        -- PJ20216891	
        -- ISUZU item
        AND (
            t.operation_id IN (
                                SELECT b.segment4
                                FROM   #tmp_LOCATION_GROUP_ROUTE b
                                WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                            )
            OR (
                t.operation_id = 'P5000'
                AND EXISTS (
                            SELECT 1
                            FROM   #tmp_ISUZU A
                            WHERE  A.ITEM_ID = t.ITEM_ID
                            )
                )
            )
        AND T.MONTH >= @v_delete_date										 

		-- 전극 외 : Yield 
		SELECT T.DIVISION_ID
            , T.PLANT_SITE_ID
            , T.ITEM_ID
            , T.OPERATION_ID
            , T.LINE_ID
            , T.MONTH                               
            , 0 AS TACT_TIME
            , ISNULL(t.yield, 1) AS YIELD
            , 0 AS lane_qty                               
        INTO #scm_mst_yield_ver_h_v_div
        FROM scm_mst_yield_ver_h_v t WITH(NOLOCK)							                   
        WHERE 1=1
        --AND T.DIVISION_ID    = ISNULL(@p_division_id, t.division_id)  -- 전극 외 : 20220616 주석
        AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
		AND ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'
        --AND T.OPERATION_ID   IN ( 
        --                        SELECT DISTINCT b.segment4
        --                        FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
        --                        WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
        --                        AND    b.valid_yn    = 'Y'
        --                        AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							 --   AND    SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
        --                        )
        -- PJ20216891	
        -- ISUZU item
        AND (
            t.operation_id IN (
                                SELECT b.segment4
                                FROM   #tmp_LOCATION_GROUP_ROUTE b
                                WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                            )
            OR (
                t.operation_id = 'P5000'
                AND EXISTS (
                            SELECT 1
                            FROM   #tmp_ISUZU A
                            WHERE  A.ITEM_ID = t.ITEM_ID
                            )
                )
            )
        AND T.MONTH >= @v_delete_date

        ----------
		-- 전극
        ----------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_v_ee') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_v_ee   
        END			
        IF OBJECT_ID('tempdb..#scm_mst_yield_ver_h_v_ee') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_yield_ver_h_v_ee   
        END	

		-- 전극 : Tact Time
		SELECT T.DIVISION_ID
            , T.PLANT_SITE_ID
            , T.ITEM_ID
            , T.OPERATION_ID
            , T.LINE_ID
            , T.MONTH                               
            , t.TACT_TIME
            , 0 AS YIELD
            , t.lane_qty AS lane_qty
        INTO #scm_mst_tact_time_ver_h_v_ee                               
        FROM scm_mst_tact_time_ver_h_v t WITH(NOLOCK)							                   
        WHERE 1=1
        AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
		AND ISNULL(@p_division_id, 'EE') LIKE N'EE%'
        AND T.OPERATION_ID   IN ( 
           --                     SELECT DISTINCT b.segment4
           --                     FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
           --                     WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
           --                     AND    b.valid_yn    = 'Y'
           --                     AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							    --AND    SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                SELECT b.segment4
                                FROM   #tmp_LOCATION_GROUP_ROUTE b
                                WHERE  SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                )
        AND T.MONTH >= @v_delete_date
										 
		-- 전극 : Yield										 
        SELECT T.DIVISION_ID
            , T.PLANT_SITE_ID
            , T.ITEM_ID
            , T.OPERATION_ID
            , T.LINE_ID
            , T.MONTH                               
            , 0 AS TACT_TIME
            , ISNULL(t.yield, 1) AS YIELD
            , 0 AS lane_qty                               
        INTO #scm_mst_yield_ver_h_v_ee
        FROM scm_mst_yield_ver_h_v t WITH(NOLOCK)							                   
        WHERE 1=1
        AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
		AND ISNULL(@p_division_id, 'EE') LIKE N'EE%'
        AND T.OPERATION_ID   IN ( 
           --                     SELECT DISTINCT b.segment4
           --                     FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
           --                     WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
           --                     AND    b.valid_yn    = 'Y'
           --                     AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							    --AND    SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                SELECT b.segment4
                                FROM   #tmp_LOCATION_GROUP_ROUTE b
                                WHERE  SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                )
        AND T.MONTH >= @v_delete_date

		-- Tact Time / Yield Monthly Temp
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h          
        END

        SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id
             , a.start_time, a.end_time, a.month, a.tact_time, a.yield, a.use_yn
        INTO #scm_mst_tact_time_ver_h 
        FROM  (
               ---------------------
		       --  1. 전극 외
               ---------------------
               SELECT scp_tt.division_id, scp_tt.plant_site_id, scp_tt.item_id, scp_tt.operation_id, scp_tt.line_id
                    , scp_tt.basis_yyyymm + '01'   AS start_time
                    , scp_tt.basis_yyyymmdd        AS end_time
                    , scp_tt.basis_yyyymm          AS month
                    , ISNULL(fp_tt.tact_time, 0)   AS tact_time
                    , ISNULL(fp_tt.yield, 0)       AS yield
                    , CASE WHEN ISNULL(fp_tt.tact_time, 0) = 0 THEN 'N'
                           ELSE 'Y'
                      END AS use_yn
               FROM (
                     SELECT st.division_id, st.plant_site_id, st.item_id, st.operation_id, st.line_id
                          , c.basis_yyyymm, c.basis_yyyymmdd
                     FROM   (SELECT T.DIVISION_ID
                                  , T.PLANT_SITE_ID
                                  , T.ITEM_ID
                                  , T.OPERATION_ID
                                  , T.LINE_ID
                              FROM scp_mst_tact_time t WITH(NOLOCK)
							        
                              WHERE 1=1
                              --AND T.DIVISION_ID    = ISNULL(@p_division_id, t.division_id)  -- 전극 외 : 20220616 주석
                              AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
							  AND ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'

                   --           AND T.OPERATION_ID   IN ( 
                   --                                    SELECT DISTINCT b.segment4
                   --                                    FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                   --                                    WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                   --                                    AND    b.valid_yn    = 'Y'
                   --                                    AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							      					 --AND    SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation 20220616 주석 처리
                   --                                   )
                              -- PJ20216891	
                              -- ISUZU item
                              AND (
                                   t.operation_id IN (
                                                      SELECT b.segment4
                                                      FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                      WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                                                     )
                                   OR (
                                       t.operation_id = 'P5000'
                                       AND EXISTS (
                                                   SELECT 1
                                                   FROM   #tmp_ISUZU A
                                                   WHERE  A.ITEM_ID = t.ITEM_ID
                                                  )
                                      )
                                  )
				                    ) st
                            , (SELECT basis_yyyymm
							        , CASE WHEN basis_yyyymm = @v_end_month THEN @v_pet_date
									       ELSE MAX(basis_yyyymmdd) 
								      END AS basis_yyyymmdd
                               FROM   scm_sys_calendar_m WITH(NOLOCK)
				               WHERE  basis_yyyymm >= @v_delete_date
				               AND    basis_yyyymm <= @v_end_month -- -- 202105285 PJ20209642 : SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,24,GETDATE()),112),1,6) 
				               GROUP BY basis_yyyymm
                              ) c
                   ) scp_tt

               LEFT OUTER JOIN (
                                SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month
                                     , SUM(ISNULL(a.tact_time, 0)) AS tact_time
                                     , SUM(ISNULL(a.yield, 0)) AS yield
                                FROM   (SELECT T.DIVISION_ID
                                             , T.PLANT_SITE_ID
                                             , T.ITEM_ID
                                             , T.OPERATION_ID
                                             , T.LINE_ID
                                             , T.MONTH
                                             , t.TACT_TIME
                                             , t.YIELD
                                             , t.lane_qty                               
                                         FROM #scm_mst_tact_time_ver_h_v_div t WITH(NOLOCK)							                   
                                         WHERE 1=1
                                        
                                        UNION ALL
                               
                                        SELECT T.DIVISION_ID
                                             , T.PLANT_SITE_ID
                                             , T.ITEM_ID
                                             , T.OPERATION_ID
                                             , T.LINE_ID
                                             , T.MONTH
                                             , t.TACT_TIME
                                             , t.YIELD
                                             , t.lane_qty     
                                         FROM #scm_mst_yield_ver_h_v_div t WITH(NOLOCK)							                   
                                         WHERE 1=1
                                       ) a
                                GROUP BY a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month
                                HAVING SUM(ISNULL(a.tact_time, 0)) > 0
                               
                               ) fp_tt
               ON  scp_tt.DIVISION_ID   = fp_tt.DIVISION_ID
               AND scp_tt.PLANT_SITE_ID = fp_tt.PLANT_SITE_ID
               AND scp_tt.ITEM_ID       = fp_tt.ITEM_ID
               AND scp_tt.OPERATION_ID  = fp_tt.OPERATION_ID
               AND scp_tt.LINE_ID       = fp_tt.LINE_ID
               AND scp_tt.basis_yyyymm  = fp_tt.MONTH

               UNION
               ---------------------
		       --  2. 전극
               ---------------------
               SELECT scp_tt.division_id, scp_tt.plant_site_id, scp_tt.item_id, scp_tt.operation_id, scp_tt.line_id
                    , scp_tt.basis_yyyymm + '01'   AS start_time
                    , scp_tt.basis_yyyymmdd        AS end_time
                    , scp_tt.basis_yyyymm          AS month
                    , ISNULL(fp_tt.tact_time, 0)   AS tact_time
                    , ISNULL(fp_tt.yield, 0)       AS yield
                    , CASE WHEN ISNULL(fp_tt.tact_time, 0) = 0 THEN 'N'
                           ELSE 'Y'
                      END AS use_yn
               FROM (
                     SELECT st.division_id, st.plant_site_id, st.item_id, st.operation_id, st.line_id
                          , c.basis_yyyymm, c.basis_yyyymmdd
                     FROM   (SELECT T.DIVISION_ID
                                  , T.PLANT_SITE_ID
                                  , T.ITEM_ID
                                  , T.OPERATION_ID
                                  , T.LINE_ID
                              FROM scp_mst_tact_time t WITH(NOLOCK)
							        
                              WHERE 1=1
                              AND T.DIVISION_ID    IN (SELECT division_id FROM #scm_mst_division)
							  AND ISNULL(@p_division_id, 'EE') LIKE N'EE%'

                              AND T.OPERATION_ID   IN ( 
                     --                                  SELECT DISTINCT b.segment4
                     --                                  FROM   scm_adm_lookup_master_detail b WITH (NOLOCK)
                     --                                  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                     --                                  AND    b.valid_yn    = 'Y'
                     --                                  AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							      					   --AND    SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                                       SELECT b.segment4
                                                       FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                       WHERE  SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                                      )
				                    ) st
                            , (SELECT basis_yyyymm
							        , CASE WHEN basis_yyyymm = @v_end_month THEN @v_pet_date
									       ELSE MAX(basis_yyyymmdd) 
								      END AS basis_yyyymmdd
                               FROM   scm_sys_calendar_m WITH(NOLOCK)
				               WHERE  basis_yyyymm >= @v_delete_date
				               AND    basis_yyyymm <= @v_end_month -- -- 202105285 PJ20209642 : SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,24,GETDATE()),112),1,6) 
				               GROUP BY basis_yyyymm
                              ) c
                   ) scp_tt

               LEFT OUTER JOIN (
                                SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month
                                     , SUM(ISNULL(a.tact_time, 0)) AS tact_time
                                     , SUM(ISNULL(a.yield, 0)) AS yield
                                FROM   (SELECT T.DIVISION_ID
                                             , T.PLANT_SITE_ID
                                             , T.ITEM_ID
                                             , T.OPERATION_ID
                                             , T.LINE_ID
                                             , T.MONTH                               
                                             , t.TACT_TIME
                                             , t.YIELD
                                             , t.lane_qty                               
                                         FROM #scm_mst_tact_time_ver_h_v_ee t WITH(NOLOCK)							                   
                                         WHERE 1=1
                                        
                                        UNION ALL
                               
                                        SELECT T.DIVISION_ID
                                             , T.PLANT_SITE_ID
                                             , T.ITEM_ID
                                             , T.OPERATION_ID
                                             , T.LINE_ID
                                             , T.MONTH                             
                                             , t.TACT_TIME
                                             , t.YIELD
                                             , t.lane_qty    
                                         FROM #scm_mst_yield_ver_h_v_ee t WITH(NOLOCK)							                   
                                         WHERE 1=1
                                       ) a
                                GROUP BY a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month
                                HAVING SUM(ISNULL(a.tact_time, 0)) > 0
                               
                               ) fp_tt
               ON  scp_tt.DIVISION_ID   = fp_tt.DIVISION_ID
               AND scp_tt.PLANT_SITE_ID = fp_tt.PLANT_SITE_ID
               AND scp_tt.ITEM_ID       = fp_tt.ITEM_ID
               AND scp_tt.OPERATION_ID  = fp_tt.OPERATION_ID
               AND scp_tt.LINE_ID       = fp_tt.LINE_ID
               AND scp_tt.basis_yyyymm  = fp_tt.MONTH

              ) a;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'Insert #scm_mst_tact_time_ver_h : ' + ISNULL(@p_division_id, 'ALL');
        SET @v_description = N'Monthly Tact Time Temp Insert...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

        ----------------------------------------------------------- 
        -- Tact Time / Yield Except Temp 입력 : 동일 기간에 Tact Time/Yield Except 미존재 시 Monthly 값으로 처리
        -----------------------------------------------------------	
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_exct_ver') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_exct_ver       
        END

        SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id
             , a.start_time, a.end_time, a.tact_time, a.yield, 'Y' AS use_yn
        INTO #scm_mst_tact_time_exct_ver
        FROM  (
               ---------------------
		       --  1. 전극 외
               ---------------------
               SELECT tt.division_id, tt.plant_site_id, tt.item_id, tt.operation_id, tt.line_id
                    , tt.start_time, tt.end_time

                    , CASE WHEN SUM(ISNULL(tt.tact_time, 0)) = 0 THEN MIN(ISNULL(t.tact_time, 0)) 
                           ELSE SUM(ISNULL(tt.tact_time, 0))
                      END AS tact_time

                    , CASE WHEN SUM(ISNULL(tt.yield, 0)) = 0 THEN MIN(ISNULL(t.yield, 0)) 
                           ELSE SUM(ISNULL(tt.yield, 0))
                      END AS yield
               FROM  (
                       SELECT t.division_id, t.plant_id, t.plant_site_id, t.item_id, t.operation_id, t.line_id, t.start_time, t.end_time
                            , CONVERT(CHAR(6), t.end_time, 112)  AS month
                            , t.tact_time                        AS tact_time
                            , NULL                               AS yield
							  
                       FROM   scm_mst_tact_time_exct_ver_v t WITH(NOLOCK)

                       WHERE  1=1
                       AND    t.division_id    = ISNULL(@p_division_id, t.division_id)  -- 전극 외
                       AND    t.end_time      >= @v_delete_date + '01'
                       AND    t.tact_time     >= 0
                   --    AND    t.operation_id  IN ( 
                   --                                SELECT DISTINCT b.segment4
                   --                                FROM scm_adm_lookup_master_detail b WITH (NOLOCK)
                   --                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                   --                                    AND b.valid_yn    = 'Y'
                   --                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부
												       --AND SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                   --                            )       
                       -- PJ20216891	
                       -- ISUZU item
                       AND    (
                               t.operation_id IN (
                                                  SELECT b.segment4
                                                  FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                  WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                                                 )
                               OR (
                                   t.operation_id = 'P5000'
                                   AND EXISTS (
                                               SELECT 1
                                               FROM   #tmp_ISUZU A
                                               WHERE  A.ITEM_ID = t.ITEM_ID
                                              )
                                  )
                              )
                                           
                       UNION ALL  

                       SELECT t.division_id, t.plant_id, t.plant_site_id, t.item_id, t.operation_id, t.line_id, t.start_time, t.end_time
                            , CONVERT(CHAR(6), t.end_time, 112)  AS month
					        , NULL                               AS tact_time
                            , t.yield                            AS yield

                       FROM   scm_mst_yield_exct_ver_h_v t WITH(NOLOCK)   

                       WHERE  1=1
                       AND    t.division_id    = ISNULL(@p_division_id, t.division_id)  -- 전극 외
                       AND    t.end_time      >= @v_delete_date + '01'
                       AND    t.yield         >  0
                       AND    t.yield         <= 1
                   --    AND    t.operation_id  IN ( 
                   --                                SELECT DISTINCT b.segment4
                   --                                FROM scm_adm_lookup_master_detail b WITH (NOLOCK)
                   --                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                   --                                    AND b.valid_yn    = 'Y'
                   --                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부
												       --AND SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                   --                            )
                       -- PJ20216891	
                       -- ISUZU item
                       AND    (
                               t.operation_id IN (
                                                  SELECT b.segment4
                                                  FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                  WHERE  SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                                                 )
                               OR (
                                   t.operation_id = 'P5000'
                                   AND EXISTS (
                                               SELECT 1
                                               FROM   #tmp_ISUZU A
                                               WHERE  A.ITEM_ID = t.ITEM_ID
                                              )
                                  )
                              )
                     ) tt

                      LEFT OUTER JOIN  #scm_mst_tact_time_ver_h t WITH(NOLOCK)
                      ON 0 = 0
                      AND tt.division_id    = t.division_id   
                      AND tt.plant_site_id  = t.plant_site_id  
                      AND tt.operation_id   = t.operation_id
                      AND tt.item_id        = t.item_id
                      AND tt.line_id        = t.line_id
                      AND tt.month          = t.month
			   
               GROUP BY tt.division_id, tt.plant_site_id, tt.item_id, tt.operation_id, tt.line_id
                      , tt.start_time, tt.end_time

               UNION
               ---------------------
		       --  2. 전극
               ---------------------
               SELECT tt.division_id, tt.plant_site_id, tt.item_id, tt.operation_id, tt.line_id
                    , tt.start_time, tt.end_time

                    , CASE WHEN SUM(ISNULL(tt.tact_time, 0)) = 0 THEN MIN(ISNULL(t.tact_time, 0)) 
                           ELSE SUM(ISNULL(tt.tact_time, 0))
                      END AS tact_time

                    , CASE WHEN SUM(ISNULL(tt.yield, 0)) = 0 THEN MIN(ISNULL(t.yield, 0)) 
                           ELSE SUM(ISNULL(tt.yield, 0))
                      END AS yield
               FROM  (
                       SELECT t.division_id, t.plant_id, t.plant_site_id, t.item_id, t.operation_id, t.line_id, t.start_time, t.end_time
                            , CONVERT(CHAR(6), t.end_time, 112)  AS month
                            , t.tact_time                        AS tact_time
                            , NULL                               AS yield
							  
                       FROM   scm_mst_tact_time_exct_ver_v t WITH(NOLOCK)

                       WHERE  1=1
                       AND    t.division_id    = CASE WHEN ISNULL(@p_division_id, '') = ''   THEN t.division_id
					   
										 			  -- PJ20216891
                                                      -- WHEN @p_division_id             = 'EE' THEN t.division_id
                                                      WHEN @p_division_id             LIKE 'EE%' THEN t.division_id
                                                      ELSE 'NA'
                                                 END
                       AND    t.end_time      >= @v_delete_date + '01'
                       AND    t.tact_time     >= 0
                       AND    t.operation_id  IN ( 
                   --                                SELECT DISTINCT b.segment4
                   --                                FROM scm_adm_lookup_master_detail b WITH (NOLOCK)
                   --                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                   --                                    AND b.valid_yn    = 'Y'
                   --                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부
												       --AND SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                                   SELECT b.segment4
                                                   FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                   WHERE SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                               )       
                                           
                       UNION ALL  

                       SELECT t.division_id, t.plant_id, t.plant_site_id, t.item_id, t.operation_id, t.line_id, t.start_time, t.end_time
                            , CONVERT(CHAR(6), t.end_time, 112)  AS month
					        , NULL                               AS tact_time
                            , t.yield                            AS yield

                       FROM   scm_mst_yield_exct_ver_h_v t WITH(NOLOCK)   

                       WHERE  1=1
                       AND    t.division_id    = CASE WHEN ISNULL(@p_division_id, '') = ''   THEN t.division_id
					   
										 			  -- PJ20216891
                                                      -- WHEN @p_division_id             = 'EE' THEN t.division_id
                                                      WHEN @p_division_id             LIKE 'EE%' THEN t.division_id
                                                      ELSE 'NA'
                                                 END
                       AND    t.end_time      >= @v_delete_date + '01'
                       AND    t.yield         >  0
                       AND    t.yield         <= 1
                       AND    t.operation_id  IN ( 
                   --                                SELECT DISTINCT b.segment4
                   --                                FROM scm_adm_lookup_master_detail b WITH (NOLOCK)
                   --                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                   --                                    AND b.valid_yn    = 'Y'
                   --                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부
												       --AND SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                                   SELECT b.segment4
                                                   FROM   #tmp_LOCATION_GROUP_ROUTE b
                                                   WHERE  SUBSTRING(b.segment4, 1, 1) = 'E' -- 전극 Operation
                                               )
                     ) tt

                      LEFT OUTER JOIN  #scm_mst_tact_time_ver_h t WITH(NOLOCK)
                      ON 0 = 0
                      AND tt.division_id    = t.division_id   
                      AND tt.plant_site_id  = t.plant_site_id  
                      AND tt.operation_id   = t.operation_id
                      AND tt.item_id        = t.item_id
                      AND tt.line_id        = t.line_id
                      AND tt.month          = t.month
			   
               GROUP BY tt.division_id, tt.plant_site_id, tt.item_id, tt.operation_id, tt.line_id
                      , tt.start_time, tt.end_time

        ) a
         WHERE a.tact_time > 0
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO #scm_mst_tact_time_exct_ver : ' + ISNULL(@p_division_id, 'ALL');
        SET @v_description = N'Except Tact Time/ Yield Temp Insert...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

        ----------------------------------------------------------- 
        -- Tact Time / Yield : Monthly 와 Except 사용하여 구간별 정보 처리
		-- Except 테이블의 End Date 까지 포함하여 Except 값 적용함
        -----------------------------------------------------------	
        ---------------------------------------------------------------
        -- 1) 분할대상 임시테이블생성 (except 처리)    
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_cal          
        END

        SELECT x.*
             , DATEDIFF(d, x.monthly_start_date, x.except_start_date) AS start_date_diff -- 'except의 start_time' - Monthly의 start_time'  

             , DATEDIFF(d, x.except_end_date, x.monthly_end_date) AS end_date_diff -- Monthly의 end_time' - except의 end_time'    

             , DATEDIFF(d, x.except_end_date, CONVERT(DATETIME, x.next_except_tact_time_start_date)) AS except_enddate_nextstartdate_diff  -- '다음행의 except의 start_time' -'현재행의 except의 end_time'  
        INTO   #scm_mst_tact_time_ver_h_cal 
        FROM   (SELECT    a.*
                        , CONVERT(DATETIME, a.start_time) AS monthly_start_date
                        , CONVERT(DATETIME, a.end_time)   AS monthly_end_date
                        , CONVERT(DATETIME, b.start_time) AS except_start_date
                        , CONVERT(DATETIME, b.end_time)   AS except_end_date
                        , b.start_time AS except_start_time
                        , b.end_time   AS except_end_time
                        , b.tact_time  AS except_tact_time
                        , b.use_yn     AS except_use_yn
                        
                        , CASE WHEN b.yield <= 0 THEN 1
                               WHEN b.yield > 1 THEN 1
                               ELSE ISNULL(b.yield, 1)
                          END AS except_yield

                        , ROW_NUMBER()           OVER (PARTITION BY a.division_id, a.plant_site_id, a.operation_id, a.item_id, a.line_id, a.start_time ORDER BY a.start_time, b.start_time) row_num --그룹별 순번
                        , COUNT(*)               OVER (PARTITION BY a.division_id, a.plant_site_id, a.operation_id, a.item_id, a.line_id, a.start_time) cnt                                         --그룹별 전체개수
                        , LEAD(CONVERT(DATETIME, b.start_time), 1)  OVER (PARTITION BY a.division_id, a.plant_site_id, a.operation_id, a.item_id, a.line_id, a.start_time ORDER BY a.start_time, b.start_time) next_except_tact_time_start_date  --다음행의 Except start_time
               
                FROM    #scm_mst_tact_time_ver_h a
                        INNER JOIN #scm_mst_tact_time_exct_ver b WITH (NOLOCK)
                        ON 0 = 0
                        AND a.division_id    = b.division_id   
                        AND a.plant_site_id  = b.plant_site_id  
                        AND a.operation_id   = b.operation_id
                        AND a.item_id        = b.item_id
                        AND a.line_id        = b.line_id
                        AND  (
                                ( a.start_time <= b.start_time
                                AND  a.end_time   >=  b.start_time
                                )
                                OR
                                ( a.start_time <= b.end_time
                                AND  a.end_time   >=  b.end_time
                                )
                                OR
                                ( a.start_time >= b.start_time
                                  AND a.end_time <= b.end_time
                                )
                            )
                WHERE 1=1
               ) x
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO #scm_mst_tact_time_ver_h_cal : ' + ISNULL(@p_division_id, 'ALL');
        SET @v_description = N'분할대상 생성...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

        ---------------------------------------------------------------
        -- 2) 분할대상 except 일자별로 분리후 임시테이블에 생성
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_cal_add') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_cal_add
        END
						
        SELECT DISTINCT 
               division_id, plant_site_id, item_id, operation_id, line_id
			 			 
             , CASE WHEN gubun = 1 THEN start_time
                 
                    WHEN gubun = 2 AND monthly_start_date <= except_start_date THEN except_start_time
                    WHEN gubun = 2 AND monthly_start_date >  except_start_date THEN start_time  

                    WHEN gubun = 3 THEN CONVERT(CHAR(8), DATEADD(d, 1, except_end_date), 112)
               END AS start_time
         
             , CASE WHEN gubun = 1 THEN CONVERT(CHAR(8), DATEADD(d, -1, except_start_date), 112) 
                
                    WHEN gubun = 2 AND monthly_end_date >  except_end_date THEN except_end_time
                    WHEN gubun = 2 AND monthly_end_date <= except_end_date THEN end_time 
                
                    WHEN gubun = 3 AND row_num <> cnt THEN CONVERT(CHAR(8), DATEADD(d, -1, next_except_tact_time_start_date), 112)
                    WHEN gubun = 3 AND row_num =  cnt THEN end_time           
               END AS end_time
		     
             , CASE WHEN gubun = 1 THEN tact_time 
                    WHEN gubun = 2 THEN except_tact_time
                    WHEN gubun = 3 THEN tact_time 
               END tact_time
             
             , CASE WHEN gubun = 1 THEN yield 
                    WHEN gubun = 2 THEN except_yield 
                    WHEN gubun = 3 THEN yield 
               END yield
             
             , CASE WHEN gubun = 1 THEN use_yn 
                    WHEN gubun = 2 THEN except_use_yn 
                    WHEN gubun = 3 THEN use_yn 
               END use_yn

        INTO  #scm_mst_tact_time_ver_h_cal_add
        FROM (
                SELECT *
                FROM  #scm_mst_tact_time_ver_h_cal a
                    , (SELECT 1 gubun UNION ALL SELECT 2 UNION ALL SELECT 3) b
                WHERE (
                        ( gubun = 1 AND  row_num =1 AND start_date_diff > 0)
                        OR
                        ( gubun = 2)
                        OR
                        ( gubun = 3 AND end_date_diff > 1 AND ISNULL(except_enddate_nextstartdate_diff, 99) <> 1)                    
                        )
                ) x
        ;		  

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO #scm_mst_tact_time_ver_h_cal_add : ' + ISNULL(@p_division_id, 'ALL');
        SET @v_description = N'분할대상 except 일자별로 분리...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

        ----------------------------------------------------------- 
        -- 3) Tact Time / Yield Except 입력
        -----------------------------------------------------------	
        INSERT INTO scp_mst_tact_time_except
               ( division_id, plant_site_id, item_id, operation_id, line_id
               , tact_time_start_date, tact_time_end_date
               , tact_time, yield, except_comment, use_yn
               , created_by, creation_date, last_updated_by, last_update_date
               ) 
        SELECT tt.division_id, tt.plant_site_id, tt.item_id, tt.operation_id, tt.line_id
             , tt.start_time, tt.end_time
             , tt.tact_time, tt.yield

             , 'Copy FP' AS except_comment
             , use_yn    AS use_yn      
             , 'COPY'    AS CREATED_BY
             , GETDATE() AS CREATION_DATE
             , 'COPY'    AS LAST_UPDATED_BY
             , GETDATE() AS LAST_UPDATE_DATE  
        FROM   (   

                   SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id
                        , a.start_time, a.end_time, a.tact_time, a.yield, a.use_yn
                   FROM   #scm_mst_tact_time_ver_h  a   -- montjly
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT division_id, plant_site_id, item_id, operation_id, line_id, start_time
                                                FROM #scm_mst_tact_time_ver_h_cal 
                                            ) x
                                       WHERE x.division_id   = a.division_id
                                       AND   x.plant_site_id =  a.plant_site_id
                                       AND   x.item_id       =  a.item_id
                                       AND   x.operation_id  =  a.operation_id
                                       AND   x.line_id       =  a.line_id
                                       AND   x.start_time    =  a.start_time
                                       ) 
                   UNION ALL

                   -- except 대상(start_time, end_time 분할된 신규데이터)
                   SELECT division_id, plant_site_id, item_id, operation_id, line_id
                        , start_time, end_time, tact_time, yield, use_yn
                   FROM #scm_mst_tact_time_ver_h_cal_add 
               ) tt

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO scp_mst_tact_time_except : ' + ISNULL(@p_division_id, 'ALL');
        SET @v_description = N'Except Insert...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;
		
        ---------------------------------------------------------------------------- 
        -- 임시 테이블 삭제
        ---------------------------------------------------------------------------- 
        IF OBJECT_ID('tempdb..#scm_mst_division') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_division         
        END

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_v_div') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_v_div   
        END			
        IF OBJECT_ID('tempdb..#scm_mst_yield_ver_h_v_div') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_yield_ver_h_v_div   
        END		

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_v_ee') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_v_ee   
        END			
        IF OBJECT_ID('tempdb..#scm_mst_yield_ver_h_v_ee') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_yield_ver_h_v_ee   
        END	

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h          
        END

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_exct_ver') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_exct_ver       
        END
        
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_cal          
        END

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_ver_h_cal_add') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_tact_time_ver_h_cal_add
        END

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT;
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
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;
      
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
