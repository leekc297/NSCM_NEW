
/*
 * Program ID   : PR_SCP_ANL_TACT_TIME
 * Description  : CREATE DAILY TACT TIME WITH FP INPUT ENGINE LOGIC
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.27   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.27   YYDOK         OUTSOURCING TACT TIME은 1로 셋팅(생산계획 화면LOADING계산을 위함..ENGINE INPUT과는 다를수있음.)
 * 2018.05.28   YYDOK         SCP_MST_TACT_TIME_EXCEPT 반영
 * 2018.06.04   YYDOK         2개월 FP TT,3개월이후 SCP TT-> 전구간 SCP TT으로 적용(7주~2개월말사이의 TT적용규칙에 혼선으로 규칙재정의)
 * 2018.08.14   YYDOK         소형 PACKER SITE의 SCM_SITE_ID에 DIVISION이 들어가는데, 생산계획과 일치를 위해 PLANT ID로 OPERATION_ID 생성
 * 2018.08.17   YYDOK         사내 TACT TIME기준을 SCP TACT TIME -> FP TACT TIME(당차월),SCP TACT TIME(차차월 이후)
 * 2018.09.17   YYDOK         소형 원,각형전극에 대해서 TACT TIME에 UOM CONVERT VALUE를 반영.
 * 2018.09.21   YYDOK         TACT TIME INSERT속도때문에 대상을 나눠서 처리,WITH(TABLOCK)추가.
 * 2019.10.08   KTH           @v_exec_time 추가(속도 학인 용)
 * 2019.10.31   KTH           dbo.FN_GET_BUCKET_YYYYMMDD(0) 지역변수로 분리, CURSOR 제거, FN_GET_ITEM_OPERATION_GROUP 제거
                              ,입력 파라미턴 변경(진행시간 확인을 위해서)
 * 2020.02.05   KTH           ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.09.24   KSG           생성 Bucket 조정
 * 2021.03.15   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2021.05.10   KSW           PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.22   KSW           JV GM 반영
 * 2022.06.27   sclee.lee     PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.29	hrkim		  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2024.01.25   vadabi3       NERP - 특정 Company 별도 처리 개선
 * 2024.11.03   vadabi3       NERP - 개발DB 적용
 * 2026.07.24   YMH           E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 ---------------------------------------------------------------------------------------------------------

 EXEC NERP_PR_SCP_ANL_TACT_TIME
   @p_plan_cycle           = ''
 , @p_plan_start_yyyymmdd  = ''
 , @p_plan_id              = ''
 , @p_modeling_id          = ''
 , @p_seq                  = ''
 , @p_plan_type            = ''
 , @p_master_id            = ''
 , @p_division_id          = ''
 , @p_engine_plan_id       = ''
 , @p_user_id              = ''

  EXEC PR_SCP_ANL_TACT_TIME
   @p_plan_cycle           = ''
 , @p_plan_start_yyyymmdd  = ''
 , @p_plan_id              = ''
 , @p_modeling_id          = ''
 , @p_seq                  = ''
 , @p_plan_type            = ''
 , @p_master_id            = ''
 , @p_division_id          = ''
 , @p_engine_plan_id       = ''
 , @p_user_id              = ''
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_TACT_TIME]
(
      @p_plan_cycle           NVARCHAR(150)            
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name         
    , @p_plan_id              NVARCHAR(4000)            
    , @p_modeling_id          NVARCHAR(4000)            
    , @p_seq                  NVARCHAR(4000)            
    , @p_plan_type            NVARCHAR(4000)            
    , @p_master_id            NVARCHAR(4000)            
    , @p_division_id          NVARCHAR(30)            
    , @p_engine_plan_id       NVARCHAR(4000)            
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'            
    ---- , @p_debug       INT OUTPUT                       
    )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    --SET     @v_batch_user = 'scp_batch'
    SET     @v_batch_user = @p_user_id    
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_TACT_TIME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_TACT_TIME'; 
    DECLARE @d_event_date   DATETIME;

    -- EE 기준정보는 EE로 관리되지 않아서 수행제외
    -- 2023.03.29 IF (@p_division_id = 'EE' OR @p_division_id = 'EE_UC')		-- 2022.03.22 KSW JV GM 반영 <-- @p_division_id = 'EE'
	IF EXISTS (SELECT *
				FROM SCM_MST_DIVISION WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
			   WHERE DIVISION_ID = @p_division_id
			     AND ATTRIBUTE3  = 'EE' 
				 AND VALID_YN	 = 'Y' ) 
       BEGIN
            RETURN;
       END

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + @p_division_id + N' SCP_ANL_TACT_TIME INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    -- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';              
    -- dbo.FN_GET_BUCKET_YYYYMMDD(0)
    DECLARE @v_bucket_yyyymmdd    NVARCHAR(8) = dbo.FN_GET_BUCKET_YYYYMMDD(0);
	-- 20200924 생성 Bucket 조정용 변수 설정
    DECLARE @v_bucket_yyyymm0     NVARCHAR(6) = LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6); -- 당월
    DECLARE @v_bucket_yyyymm1     NVARCHAR(6) = LEFT(CONVERT(VARCHAR,DATEADD(M,1,@v_bucket_yyyymmdd),112),6); -- 차월
    DECLARE @v_bucket_yyyymm2     NVARCHAR(6) = LEFT(CONVERT(VARCHAR,DATEADD(M,2,@v_bucket_yyyymmdd),112),6); -- 차차월

    BEGIN TRY
      BEGIN
    
      --  BEGIN TRANSACTION; 

	    -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
		DECLARE @v_pet_date		NVARCHAR(12) = '';

		--  Plan End Date
		SELECT @v_pet_date = p.horizon_end_date
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  p.division_id = @p_division_id
		AND    p.plan_id     = @p_plan_id ;

		SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 37, CONVERT(DATETIME, @v_pet_date, 112)), 112);
		-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end


        ----------------------------------------------------------- 
        -- 1. SCP_ANL_TACT_TIME 삭제
        ----------------------------------------------------------- 
        DELETE SCP_ANL_TACT_TIME 
        WHERE 1=1
          AND YYYYMMDD  >= @v_bucket_yyyymm0 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'
          AND DIVISION_ID = @p_division_id          
          ;

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00100 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  


        ----------------------------------------------------------- 
        -- 2. SCP_ANL_TACT_TIME 입력
        -----------------------------------------------------------
        /* 2.1 OUTSOURCING VENDOR */
        INSERT SCP_ANL_TACT_TIME WITH(TABLOCK)
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMMDD
             , TACT_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 -- ITEM_UOM
              )
            SELECT A.DIVISION_ID
                  ,A.PLANT_SITE_ID AS SCM_SITE_ID
                  ,(SELECT TOP 1 PLANT_ID
                      FROM SCM_MST_SITE X WITH(NOLOCK)
                     WHERE X.DIVISION_ID = A.DIVISION_ID
                       AND X.SCM_SITE_ID = A.PLANT_SITE_ID ) AS OPERATION_ID
                  ,'-'  AS LINE_ID
                  ,A.ITEM_ID
                  ,B.YYYYMMDD
             --     , (1440 * 60) / A.DAILY_CAPA_QTY   AS TACT_TIME
                  , 60          AS TACT_TIME --SECOND
                  , 'SCP_BATCH' AS CREATED_BY
                  , GETDATE()   AS CREATION_DATE
                  , 'SCP_BATCH' AS LAST_UPDATED_BY
                  , GETDATE()   AS LAST_UPDATE_DATE
                  , ITEM_UOM
            FROM
                (
                 SELECT O.DIVISION_ID,
                        O.PLANT_SITE_ID,
                        O.ITEM_ID,
                       (SELECT TOP 1 ITEM_UOM
                          FROM SCM_MST_ITEM_SN U WITH(NOLOCK)
                         WHERE U.DIVISION_ID = O.DIVISION_ID
                          AND U.ITEM_ID      = O.ITEM_ID  ) AS ITEM_UOM
                 FROM SCP_MST_OUTSOURCING_CAPA O WITH(NOLOCK)
                      INNER JOIN SCM_MST_SITE S WITH (NOLOCK)        -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                             ON S.DIVISION_ID              = O.DIVISION_ID
                            AND S.SCM_SITE_ID              = O.PLANT_SITE_ID            
                            AND S.OSP_YN                   = 'Y'
                            AND ISNULL(S.ATTRIBUTE1, 'N')  IN ('N','')
                WHERE 1=1
                  AND O.ITEM_ID    <> '-'
                  AND O.VALID_YN    = 'Y'
                  AND O.DIVISION_ID = @p_division_id
                ) A CROSS JOIN
                (  -- 400 DAYS  
                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
                  WHERE 1=1  
                    AND C.BASIS_YYYYMMDD >= @v_bucket_yyyymm0 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'

					-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                    --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,400,CONVERT(DATETIME,@v_bucket_yyyymmdd,112)),112)  
					--
					AND C.BASIS_YYYYMMDD <  @v_pet_date  
					-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                ) B
          ;

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

        /* 2.2 ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 */
        INSERT SCP_ANL_TACT_TIME WITH(TABLOCK)
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMMDD
             , TACT_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 -- ITEM_UOM
              )
            SELECT A.DIVISION_ID
                  ,A.PLANT_SITE_ID AS SCM_SITE_ID
                  ,A.OPERATION_ID
                  ,A.LINE_ID
                  ,A.ITEM_ID
                  ,B.YYYYMMDD
                  ,ISNULL(A.TACT_TIME,0) AS TACT_TIME
                  ,'SCP_BATCH' AS CREATED_BY
                  ,GETDATE()   AS CREATION_DATE
                  ,'SCP_BATCH' AS LAST_UPDATED_BY
                  ,GETDATE()   AS LAST_UPDATE_DATE
                  ,A.ITEM_UOM
            FROM
                (
                 SELECT T.DIVISION_ID,
                        T.PLANT_SITE_ID,
                        T.OPERATION_ID,
                        T.LINE_ID,
                        T.ITEM_ID,
                        --T.ITEM_UOM,
                        (SELECT TOP 1 ITEM_UOM
                           FROM SCM_MST_ITEM_SN U WITH(NOLOCK)
                          WHERE U.DIVISION_ID = T.DIVISION_ID
                            AND U.ITEM_ID     = T.ITEM_ID  ) AS ITEM_UOM,
                        T.TACT_TIME
                        -- T TABLE에는 ITEM_UOM이 있음.                   
                   FROM SCP_MST_TACT_TIME_OSP T WITH(NOLOCK)
                        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                            ON S.DIVISION_ID              = T.DIVISION_ID
                           AND S.SCM_SITE_ID              = T.PLANT_SITE_ID            
                           AND S.OSP_YN                   = 'Y'
                           AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
                  WHERE 1=1
                    AND T.VALID_YN   = 'Y'
                    --AND S.OSP_YN     = 'Y'
                    AND T.DIVISION_ID = @p_division_id
                 ) A CROSS JOIN
                 (  -- M+2 ~400 DAYS  
                  SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
                    FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
                   WHERE 1=1  
                     AND C.BASIS_YYYYMMDD >= @v_bucket_yyyymm0 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'

					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                     --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,400,CONVERT(DATETIME,@v_bucket_yyyymmdd,112)),112)  
					 --
					 AND C.BASIS_YYYYMMDD <  @v_pet_date  
					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                 ) B                           
            --  WHERE 0 = 0
			 WHERE PLANT_SITE_ID IS NOT NULL		-- 개발서버 실행시 주석해제 KSW

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

            
        /* 2.3 당차월 사내 TACT TIME */
        INSERT SCP_ANL_TACT_TIME WITH(TABLOCK)
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMMDD
             , TACT_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 -- ITEM_UOM
             )             
            SELECT A.DIVISION_ID
                  ,A.PLANT_SITE_ID AS SCM_SITE_ID
                  ,A.OPERATION_ID
                  ,A.LINE_ID
                  ,A.ITEM_ID
                  ,B.YYYYMMDD
                --  ,ISNULL(A.TACT_TIME,0) AS TACT_TIME
                  , CASE SUBSTRING(B.YYYYMMDD,1,6) WHEN @v_bucket_yyyymm0 -- SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,0,GETDATE()),112),1,6) 
                                                        THEN ISNULL(TACT_TIME0,0)
                                                   WHEN @v_bucket_yyyymm1 --SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,1,GETDATE()),112),1,6)      
                                                        THEN ISNULL(TACT_TIME1,ISNULL(TACT_TIME0,0))
                                                  -- ELSE ISNULL(TACT_TIME2,ISNULL(TACT_TIME1,ISNULL(TACT_TIME0,0)))
                    END AS TACT_TIME                                                         
                  , 'SCP_BATCH' AS CREATED_BY
                  , GETDATE()   AS CREATION_DATE
                  , 'SCP_BATCH' AS LAST_UPDATED_BY
                  , GETDATE()   AS LAST_UPDATE_DATE
                  , A.ITEM_UOM
            FROM
                ( -- Table A
                   SELECT  DIVISION_ID
                         , PLANT_SITE_ID
                         , ITEM_ID
                         , OPERATION_ID
                         , LINE_ID
                         , TACT_TIME2
                         , TACT_TIME1
                         , TACT_TIME0
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , (SELECT TOP 1 ITEM_UOM
                              FROM SCM_MST_ITEM_SN U WITH(NOLOCK)
                             WHERE U.DIVISION_ID = X.DIVISION_ID
                               AND U.ITEM_ID     = X.ITEM_ID  ) AS ITEM_UOM
                   FROM
                         (-- Table X
                                SELECT   SUB.DIVISION_ID
                                        ,SUB.PLANT_SITE_ID
                                        ,SUB.ITEM_ID
                                        ,SUB.OPERATION_ID
                                        ,SUB.LINE_ID
                   
                                        ,MAX( CASE WHEN SUB.MONTH = @v_bucket_yyyymm2 THEN SUB.TACT_TIME ELSE NULL END ) AS TACT_TIME2
                                        ,MAX( CASE WHEN SUB.MONTH = @v_bucket_yyyymm1 THEN SUB.TACT_TIME ELSE NULL END ) AS TACT_TIME1
                                        ,MAX( CASE WHEN SUB.MONTH = @v_bucket_yyyymm0 THEN SUB.TACT_TIME ELSE NULL END ) AS TACT_TIME0
                   
                                        , 'Y'       AS VALID_YN
                                        , 'COPY'    AS CREATED_BY
                                        , GETDATE() AS CREATION_DATE
                                        , 'COPY'    AS LAST_UPDATED_BY
                                        , GETDATE() AS LAST_UPDATE_DATE
                                
                                  FROM 
                                           (-- Table SUB
                                             SELECT T.DIVISION_ID
                                                  , T.PLANT_ID+'-'
                                                    +
                                                     (SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') 
                                                       FROM DBO.SCM_MST_ITEM_SN I WITH(NOLOCK)
                                                       WHERE 1=1
                                                       AND I.DIVISION_ID          = T.DIVISION_ID
                                                       AND I.ITEM_ID              = T.ITEM_ID
                                                     )  AS PLANT_SITE_ID
                                                  , T.ITEM_ID
                                                  , T.OPERATION_ID
                                                  , T.LINE_ID
                                                  , T.MONTH
                                                  , MAX(ISNULL(t.tact_time, 0))  AS TACT_TIME  
											  /* -- PJ20209642
                                                  , (CASE WHEN (SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') 
                                                                 FROM DBO.SCM_MST_ITEM_SN I WITH(NOLOCK)
                                                                WHERE 1=1
                                                                  AND I.DIVISION_ID          = T.DIVISION_ID
                                                                  AND I.ITEM_ID              = T.ITEM_ID
                                                                ) <> 'E' 
                                                            THEN IIF( SUM(ISNULL(t.daily_capa,0)) = 0 , 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) ) -- 셀, 팩일때
                                                          --전극일때
                                                          WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 
                                                            THEN MAX(ISNULL(t.tact_time, 0))
                                                          ELSE MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))
                                                     END )   AS TACT_TIME
												*/

                                               FROM   dbo.scm_mst_tact_time_ver_h_v T WITH (NOLOCK)  -- PJ20209642
                                               --FROM SCM_MST_TACT_TIME_SN T WITH(NOLOCK)
                                                    LEFT OUTER JOIN dbo.scm_mst_item_lane_m_sn l WITH(NOLOCK)
                                                                          ON     t.division_id  = l.division_id
                                                                          AND    t.company_id   = l.company_id
                                                                          AND    t.site_id      = l.site_id
                                                                          AND    t.plant_id     = l.plant_id
                                                                          AND    t.factory_id   = l.factory_id
                                                                          AND    t.item_id      = l.item_id
											  /* -- PJ20209642
                                                    INNER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN  A WITH(NOLOCK)
                                                                          ON  T.DIVISION_ID    = A.DIVISION_ID
                                                                          AND T.OPERATION_ID   = A.OPERATION_ID
                                                                          AND T.ITEM_ID        = A.ITEM_ID
                                                                          AND T.LINE_ID        = A.LINE_ID
                                                                          AND T.MONTH          = A.MONTH
												*/
                                              WHERE 1=1
                                                AND T.DIVISION_ID    = @p_division_id
/* 												
                                                AND T.OPERATION_ID   IN ( 
                                                                          SELECT DISTINCT b.segment4
                                                                            FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                                           WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                                             AND b.valid_yn    = 'Y'
                                                                             AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                                                         )
 */														
                                                -- PJ20216891	
                                                -- ISUZU item
                                                AND (
                                                     T.OPERATION_ID IN (
                                                                        SELECT DISTINCT b.segment4
                                                                          FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                                         WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                                           AND b.valid_yn    = 'Y'
                                                                           AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                                                       )
                                                     OR (
                                                         T.OPERATION_ID = 'P5000'
                                                         AND EXISTS (
                                                                     SELECT 1
                                                                       FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                                                      INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                                                      WHERE A.ITEM_ID = T.ITEM_ID
                                                                        AND A.IS_YN = 'Y'
                                                                    )
                                                        )
                                                    )
                                                AND T.MONTH          in ( @v_bucket_yyyymm1, @v_bucket_yyyymm0
                                                                        --  select SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,2,GETDATE()),112),1,6)  --1순위:차차월
                                                                        --  union all
                                                                          --select SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,1,GETDATE()),112),1,6)  --2순위:차월
                                                                          --union all
                                                                          --select SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,0,GETDATE()),112),1,6)  --3순위:당월
                                                                         )
											  /* -- PJ20209642
                                                AND A.ACTIVE_FLAG    ='Y'
                                                AND A.PRIORITY       NOT IN ( 0, 9 )
												*/
                                                              
                                              GROUP BY T.DIVISION_ID
                                                     , T.PLANT_ID
                                                     , T.ITEM_ID
                                                     , T.OPERATION_ID
                                                     , T.LINE_ID
                                                     , T.MONTH
                                              HAVING MAX(ISNULL(t.tact_time, 0)) > 0
											  /* -- PJ20209642
                                              HAVING (CASE WHEN (SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') 
                                                                  FROM DBO.SCM_MST_ITEM_SN I WITH(NOLOCK)
                                                                WHERE 1=1
                                                                  AND I.DIVISION_ID          = T.DIVISION_ID
                                                                  AND I.ITEM_ID              = T.ITEM_ID
                                                                ) <> 'E' 
                                                            THEN IIF( SUM(ISNULL(t.daily_capa,0)) = 0 , 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) ) -- 셀, 팩일때
                                                         --전극일때
                                                          WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 
                                                            THEN MAX(ISNULL(t.tact_time, 0))
                                                          ELSE MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))
                                                     END )   > 0 
												*/
                                           ) SUB
                                 WHERE 1=1
                                GROUP BY SUB.DIVISION_ID
                                        ,SUB.PLANT_SITE_ID
                                        ,SUB.ITEM_ID
                                        ,SUB.OPERATION_ID
                                        ,SUB.LINE_ID
                         ) X
                ) A CROSS JOIN
                (  -- M0, M+1 DAYS  
                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
                  WHERE 1=1  
                    AND C.BASIS_YYYYMMDD >= @v_bucket_yyyymm0 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'
                    AND C.BASIS_YYYYMMDD <  @v_bucket_yyyymm2 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,2,@v_bucket_yyyymmdd),112),6)+'01'
                ) B
			WHERE PLANT_SITE_ID IS NOT NULL		-- 개발서버 실행시 주석해제 KSW
            ;

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00300 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

        /* 2.4 차차월이후  사내 TACT TIME = SCP TACT TIME */   
        INSERT SCP_ANL_TACT_TIME WITH(TABLOCK)
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMMDD
             , TACT_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 -- ITEM_UOM
              )                                                
            SELECT A.DIVISION_ID
                  ,A.PLANT_SITE_ID AS SCM_SITE_ID
                  ,A.OPERATION_ID
                  ,A.LINE_ID
                  ,A.ITEM_ID
                  ,B.YYYYMMDD
                  ,ISNULL(A.TACT_TIME,0) AS TACT_TIME
                  , 'SCP_BATCH' AS CREATED_BY
                  , GETDATE()   AS CREATION_DATE
                  , 'SCP_BATCH' AS LAST_UPDATED_BY
                  , GETDATE()   AS LAST_UPDATE_DATE
                  ,A.ITEM_UOM
            FROM
                (
                SELECT T.DIVISION_ID,
                       T.PLANT_SITE_ID,
                       T.OPERATION_ID,
                       T.LINE_ID,
                       T.ITEM_ID,
                       T.ITEM_UOM,
                       T.TACT_TIME
                       -- T TABLE에는 ITEM_UOM이 있음.                   
                  FROM [dbo].[SCP_MST_TACT_TIME] T WITH(NOLOCK)
                       INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                          ON T.DIVISION_ID   = S.DIVISION_ID
                         AND T.PLANT_SITE_ID = S.SCM_SITE_ID
                 WHERE 1=1
                   AND T.VALID_YN   = 'Y'
                   AND S.OSP_YN     <> 'Y'
                   AND T.DIVISION_ID = @p_division_id
                ) A CROSS JOIN
                (  -- M+2 ~400 DAYS  
                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
                  WHERE 1=1  
                    AND C.BASIS_YYYYMMDD >= @v_bucket_yyyymm2 + '01' --LEFT(CONVERT(VARCHAR,DATEADD(M,2,@v_bucket_yyyymmdd),112),6)+'01'

					-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                    --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,400,CONVERT(DATETIME,@v_bucket_yyyymmdd,112)),112)  
					--
					AND C.BASIS_YYYYMMDD <  @v_pet_date
					-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                ) B                           
              ;      

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00400 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
              
        ----------------------------------------------------------- 
        -- 3. SCP_MST_TACT_TIME_EXCEPT 예외구간 반영
        -----------------------------------------------------------         
        UPDATE X
           SET X.TACT_TIME        = Y.TACT_TIME
              ,X.LAST_UPDATED_BY  = 'EXCEPT'
              ,X.LAST_UPDATE_DATE = GETDATE()
          FROM SCP_ANL_TACT_TIME X WITH (NOLOCK)
          INNER JOIN 
          (
            SELECT DIVISION_ID
                  ,PLANT_SITE_ID AS SCM_SITE_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ITEM_ID
                  ,TACT_TIME_START_DATE
                  ,TACT_TIME_END_DATE
                  ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
              FROM SCP_MST_TACT_TIME_EXCEPT WITH(NOLOCK)
             WHERE DIVISION_ID         = @p_division_id
               AND TACT_TIME_END_DATE >= @v_bucket_yyyymmdd
            UNION 
            -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
            SELECT DIVISION_ID
                  ,PLANT_SITE_ID AS SCM_SITE_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ITEM_ID
                  ,TACT_TIME_START_DATE
                  ,TACT_TIME_END_DATE
                  ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
              FROM SCP_MST_TACT_TIME_EXCEPT_OSP WITH(NOLOCK)
             WHERE DIVISION_ID         = @p_division_id
               AND TACT_TIME_END_DATE >= @v_bucket_yyyymmdd
          ) Y
          ON  0 = 0
          AND X.DIVISION_ID    = Y.DIVISION_ID
          AND X.SCM_SITE_ID    = Y.SCM_SITE_ID
          AND X.OPERATION_ID   = Y.OPERATION_ID
          AND X.LINE_ID        = Y.LINE_ID
          AND X.ITEM_ID        = Y.ITEM_ID
          AND ( X.YYYYMMDD >= Y.TACT_TIME_START_DATE AND X.YYYYMMDD <= Y.TACT_TIME_END_DATE )

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00500 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

        ----------------------------------------------------------- 
        -- 4. 소형전지, 전극 UOM='EA'인 경우는
        --    원각형 전극이며, TACT TIME은 UOM CONVERSION VALUE로 나눈다.
        -----------------------------------------------------------
        IF @p_division_id = '40'
        BEGIN
          
            UPDATE SCP_ANL_TACT_TIME 
            SET    ATTRIBUTE2 = ( SELECT TOP 1
                                         CASE SUB.UOM_CONVERT_VALUE WHEN 0.0 THEN 1.0
                                                                    ELSE SUB.UOM_CONVERT_VALUE
                                         END
                                    FROM (
                                          SELECT I.ITEM_ID,I.ITEM_UOM
                                               , CASE WHEN ISNULL(MAX(L.LANE_QTY),1) = 0 THEN ISNULL(MAX(C.VALUE),1)
											          ELSE ISNULL(MAX(C.VALUE),1)/ISNULL(MAX(L.LANE_QTY),1) 
												 END AS UOM_CONVERT_VALUE
                                            FROM SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK)
                                                 LEFT OUTER JOIN dbo.SCM_MST_ITEM_LANE_M_SN L WITH(NOLOCK)
                                                            ON  C.DIVISION_ID = L.DIVISION_ID
                                                            AND C.COMPANY_ID  = L.COMPANY_ID
                                                            AND C.SITE_ID     = L.SITE_ID
                                                            AND C.PLANT_ID    = L.PLANT_ID
                                                            AND C.FACTORY_ID  = L.FACTORY_ID
                                                            AND C.ITEM_ID     = L.ITEM_ID 
                                                 INNER JOIN SCM_MST_ITEM_SN I WITH(NOLOCK)
                                                            ON  C.DIVISION_ID  = I.DIVISION_ID
                                                            AND  C.COMPANY_ID   = I.COMPANY_ID
                                                            AND  C.SITE_ID      = I.SITE_ID
                                                            AND  C.ITEM_ID      = I.ITEM_ID
                                           WHERE  C.MAX_VER_FLAG = 'Y'
                                             AND  C.CATEGORY     = 'Jumbo Roll (cell/m)'
                                             AND  C.DIVISION_ID  = '40'
                                             AND  I.ITEM_UOM     = 'EA'
                                             AND  C.DIVISION_ID  = SCP_ANL_TACT_TIME.DIVISION_ID
                                             AND  C.ITEM_ID      = SCP_ANL_TACT_TIME.ITEM_ID
                                          GROUP BY I.ITEM_ID,I.ITEM_UOM 
                                         ) SUB 
                                ),
                   ATTRIBUTE3 = TACT_TIME
             WHERE DIVISION_ID  = '40'
               AND OPERATION_ID = 'E2000' 
			   AND SCM_SITE_ID IN (  SELECT SEGMENT2 
									   FROM SCM_CODE_LOOKUP_VALUE 
									  WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_TACT_TIME' 
									    AND SEGMENT1         = 'SCM_SITE_ID_IN'
								   ) -- A011-E, G183-E
               AND YYYYMMDD    >= LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'
               AND ATTRIBUTE1   = 'EA';
                
            UPDATE SCP_ANL_TACT_TIME 
            SET    TACT_TIME = CASE WHEN CONVERT(NUMERIC(20,10),ATTRIBUTE2) = 0 THEN CONVERT(NUMERIC(20,10),ATTRIBUTE3)
			                        ELSE (CONVERT(NUMERIC(20,10),ATTRIBUTE3) / CONVERT(NUMERIC(20,10),ATTRIBUTE2) )
							   END
             WHERE DIVISION_ID  = '40'
               AND OPERATION_ID = 'E2000' 
               AND SCM_SITE_ID IN (  SELECT SEGMENT2 
									   FROM SCM_CODE_LOOKUP_VALUE 
									  WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_TACT_TIME' 
									    AND SEGMENT1         = 'SCM_SITE_ID_IN'
								   ) -- A011-E, G183-E
               AND YYYYMMDD    >= LEFT(CONVERT(VARCHAR,DATEADD(M,0,@v_bucket_yyyymmdd),112),6)+'01'
               AND ATTRIBUTE1   = 'EA'
               AND ATTRIBUTE2 IS NOT NULL
               AND ATTRIBUTE3 IS NOT NULL;          
          
        END
        
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00600 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

        PRINT N'프로시저 종료'

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

       -- IF @@TRANCOUNT > 0 
       --   BEGIN
       --     COMMIT WORK;
       --   END;
	   
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
        
      --IF @@TRANCOUNT > 0 
      --  BEGIN
      --    ROLLBACK;
      --  END;
    
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

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,      @v_start_time, SYSDATETIME())/ 60))) + ':' +               
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))               

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
--    SET @v_description = @v_program_name + ':' + @p_division_id + N' SCP_ANL_TACT_TIME INSERT LOGIC';
--    SET @v_description = N'[' + @p_division_id + '][' + @v_exec_time + ']';      
    SET @v_description  = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';   
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

