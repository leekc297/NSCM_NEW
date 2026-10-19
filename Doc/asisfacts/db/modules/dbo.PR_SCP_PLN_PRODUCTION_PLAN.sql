



/*
 * Program ID   : PR_SCP_PLN_PRODUCTION_PLAN  
 * Description  : 생산계획 엔진출력 데이터 적재
 * OutTable     :
 * Execute      :   
 
  DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='LTW'

  EXEC PR_SCP_PLN_PRODUCTION_PLAN  @p_plan_cycle           = N'WEEKLY' 
                                   ,@p_plan_start_yyyymmdd = N'20180604' 
                                   ,@p_plan_id             = N'1029::PR::3' 
                                   ,@p_modeling_id         = N'2' 
                                   ,@p_seq                 = 3 
                                   ,@p_plan_type           = N'PR' 
                                   ,@p_master_id           = N'81::WEEKLY'
                                   ,@p_division_id         = N'81' 
                                   ,@p_engine_plan_id      = N'1029::PR::3' 
                                   ,@p_user_id             = N'LTW'

SELECT * FROM SCM_SYS_LOG_BATCH  where CREATED_BY ='kth' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.10   YYDOK       PACKER VENDOR CODE ADD TO OPERATION_ID
 * 2018.05.16   LTW         SCP_ENG_PEGGING_INFO_WO_V 추가된 엔진 DEMAND ID 반영(기존에도 엔진DEMAND ID를 사용하였으나 SCP_ENG_PEGGING_INFO_WO_V에서 제공하지 않고있었음)
 * 2018.05.31   LTW         프로시져 성능 개선을 위한 수정(FN_GET_ITEM_OPERATION_GROUP() => SCM_MST_FINAL_ITEM_V.OPERATION_GROUP_ID 변경)
 * 2018.06.08   LTW         PEGGING 성능개선을 위한 수정(SCP_ENG_WORK_ORDER_O_SN->SCP_ENG_WORK_ORDER_O_TEMP_SN)
 * 2018.06.22   LTW         SCP 52주 제한 로직 추가
 * 2018.06.27   LTW         전극 SCP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
 * 2018.07.04   LTW         OPERATION_GROUP 데이터 조회 부분 수정 : SCM_MST_FINAL_ITEM_V(DIVISION_ID ,ITEM_ID) => SCP_MST_FINAL_ITEM_V(ITEM_ID) 
 * 2018.07.10   LTW         UNPEGGING 데이터의 dom_exp ,fcst_type 를 같은 site_id ,item_id 의 PEGGING데이터의 TOP1 dom_exp ,fcst_type 로 업데이트 
 * 2018.07.19   LTW         SCP_PLN_DELIVERY_V -> SCP_ENG_DELIVERY_O_TEMP_SN 변경
 * 2018.07.24   LTW         소형 특성후공정셀관련 공정코드추가(F6200,F7000,F7100,F7200,F7300)
 * 2018.08.09   YYDOK       WO PEGGING,UNPEGGING도 없는 경우, PLN_PEGGING에 UNPEGGING,ALLOCATION_QTY = WO.COMPLETE_QTY처리함.
 * 2018.09.12   LTW         SCP_PLN_PRODUCTION_PLAN_PEGGING.ITEM_ID 컬럼 추가
 * 2018.11.01   KTH         SCP_PLN_PRODUCTION_PLAN.CHILD_ITEM_ID 컬럼 추가(-- 2.1 생산계획(PLAN) 정보 CHILD_ITEM_ID 추가 (40 일경우))
 * 2018.11.05   KTH         ATTRIBUTE7(TCO_CELL_YN) 반영
 * 2019.02.27   YYDOK       소형전지 TCO CELL ITEM 하위 CELL ITEM ID SETTING로직 수정
 * 2020-10-29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021-10-07   KSW         PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB Biz. 추가
 * 2022.03.23	KSW			GM JV 반영 :: EE_UC  추가
 * 2022.06.27   sclee.lee   PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.31	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2025.08.01   HRK		    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : SCP Plan 공정 하드코딩 변경 
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_PRODUCTION_PLAN]
    ( 
      @p_plan_cycle           NVARCHAR(150)
    , @p_plan_start_yyyymmdd  NVARCHAR(8)
    , @p_plan_id              NVARCHAR(4000)
    , @p_modeling_id          NVARCHAR(4000)
    , @p_seq                  NVARCHAR(4000)
    , @p_plan_type            NVARCHAR(4000)
    , @p_master_id            NVARCHAR(4000)
    , @p_division_id          NVARCHAR(30)
    , @p_engine_plan_id       NVARCHAR(4000)
    , @p_user_id              NVARCHAR(150)  = N'scp_batch'
    --, @p_engine_out_version_id nvarchar(4000) = N'1017::PR::13'
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_PRODUCTION_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      --상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_PLN_PRODUCTION_PLAN'; --테이블 필수
    DECLARE @d_event_date   DATETIME;

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] SCP Plan 공정 하드코딩 변경 (임시 테이블 변수) 
	print  convert(varchar(30), getdate(), 121) + N' SCP 계획 공정 정보 전체 ' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_PLAN_OPERATION_ALL TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_PLAN_OPERATION_ALL
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	------------------------------------------------------------------------------------------------------------------

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_PRODUCTION_PLAN INSERT LOGIC';
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

    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_PLN_PRODUCTION_PLAN  
        */

        --BEGIN TRAN T1  

        --SCP 52주 계획
        DECLARE @v_scp_end_date   datetime;

		-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
		-- 변경전
		--SET @v_scp_end_date = DATEADD( WEEK, 52, CONVERT(DATETIME ,@p_plan_start_yyyymmdd,112))--SCP 52주 계획
		--
		DECLARE @v_pet_date		NVARCHAR(12) = '';

		--  Plan End Date
		SELECT @v_pet_date = p.horizon_end_date
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  p.division_id = @p_division_id
		AND    p.plan_id     = @p_plan_id ;

		SET @v_scp_end_date = DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112));
		-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end


        ----------------------------------------------------------- 
        -- 1. SCP_PLN_PRODUCTION_PLAN 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type 과 같은 데이터가 있으면 삭제한다.
        -- 1.2. 임시테이블 생성
        ----------------------------------------------------------- 
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type 과 같은 데이터가 있으면 삭제한다.
        DELETE SCP_PLN_PRODUCTION_PLAN 
        WHERE 1=1
          AND division_id         = @p_division_id 
          AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
          AND plan_type           = @p_plan_type 
          AND seq                 = @p_seq 
          ;
        DELETE SCP_PLN_PRODUCTION_PLAN_PEGGING
        WHERE 1=1
          AND division_id         = @p_division_id 
          AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
          AND plan_type           = @p_plan_type 
          AND seq                 = @p_seq 
          ;
        
        
        --작업용 임시테이블 생성        
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK') is not null
          DROP TABLE #Tbl_PLAN_WORK
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK_PEGGING') is not null
          DROP TABLE #Tbl_PLAN_WORK_PEGGING
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK_UNPEGGING') is not null
          DROP TABLE #Tbl_PLAN_WORK_UNPEGGING
          ;
	
        -----------------------------------------------------------
        -- (ISUZU) 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
          DROP TABLE #tmp_ISUZU
          ;
		
        SELECT A.ITEM_ID
        INTO   #tmp_ISUZU
        FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
        INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
        WHERE  A.IS_YN = 'Y'
        
        ----------------------------------------------------------- 
        -- 2. 생산계획(PLAN) 정보 조회
        ----------------------------------------------------------- 
        SELECT 
             z.division_id 
            ,z.origin_division_id 
            ,z.work_order_id 
            ,z.operation_group 
            ,z.site_id 
            ,z.item_id 
            ,z.resource_id 
            ,z.operation_id 
            ,z.start_time 
            ,z.end_time 
            ,z.epst ,z.lpst 
            ,z.operation_qty 
            ,z.complete_qty          
            ,z.operation_time 
            ,z.total_working_time 
            ,z.batch_qty 
            ,z.pegging_type
            ,z.electrode_type
            ,CONVERT(NVARCHAR(50),NULL) AS child_item_id
            ,CONVERT(NVARCHAR(150),NULL) AS ATTRIBUTE7
        INTO #Tbl_PLAN_WORK
        FROM (
              --생산계획(그룹핑)
              SELECT 
                   b.division_id 
                  ,b.origin_division_id 
                  ,b.work_order_id --기준1
                  ,b.operation_group 
                  ,b.site_id 
                  ,b.item_id 
                  ,b.resource_id 
                  ,b.operation_id 
                  ,b.start_time --기준2
                  ,MAX(b.end_time)       AS end_time
                  ,MIN(b.epst)           AS epst
                  ,MAX(b.lpst)           AS lpst
                  ,MAX(b.operation_qty)  AS operation_qty
                  ,MAX(b.complete_qty)   AS complete_qty 
                                
                  ,MAX(b.operation_time) AS operation_time ,MAX(b.total_working_time) as total_working_time ,MAX(b.batch_qty) AS batch_qty 
                  ,MAX(b.electrode_type) AS electrode_type
                  ,N'WORK_ORDER'         AS pegging_type
                  
                FROM (
                      --생산계획(엔진)
                      SELECT wo.division_id
                          ,wo.origin_division_id
                          ,wo.operation_group --fi.operation_group
                          ,wo.work_order_id
                          ,dbo.fn_scm_split(wo.site_id,1,N'~') AS site_id
                          ,wo.item_id 
                          ,SUBSTRING( wo.resource_id,[dbo].[fn_charindex_rev](wo.resource_id,N'::',0)+2,LEN(wo.resource_id) ) AS resource_id 
                          --,left(wo.route_id,5) as route_id
						  /*** [PJ20257329] 변경전 소스 begin 
                          ,(CASE left(wo.operation_id,5) WHEN 'E2000' THEN 'E2000'  --COATING
                                                         WHEN 'A3000' THEN 'A3000'  --ASSM
                                                         WHEN 'A9000' THEN 'A9000'  --PACKAGING
														 WHEN 'P5200' THEN 'P5200'  --CMA (반제품) -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB Biz. 추가
                                                         WHEN 'P5500' THEN 'P5500'  --CMA
                                                         WHEN 'P9500' THEN 'P9500'  --BMA
                                                         WHEN 'F6200' THEN 'F6200'  --External Tab Welding
                                                         WHEN 'F7000' THEN 'F7000'  --DSF
                                                         WHEN 'F7100' THEN 'F7100'  --TCO
                                                         WHEN 'F7200' THEN 'F7200'  --TAPING
                                                         WHEN 'F7300' THEN 'F7300'  --SIDE TAPING

                                                         -- PJ20216891	
                                                         -- ISUZU item														 
                                                         WHEN 'P5000' THEN 'P5000'
														 
                                                         ELSE wo.operation_id  
                             END  
                            ) AS operation_id  
						   [PJ20257329] 변경전 소스 end  */
						   -- [PJ20257329] SCP Plan 공정 하드코딩 변경 - Start 
						  ,case when po.operation_id is not null 
							    then po.operation_id
								else wo.operation_id
						   end  as operation_id
						   -- [PJ20257329] SCP Plan 공정 하드코딩 변경 - End 
                          ,wo.start_time 
                          ,wo.end_time
                          ,wo.epst 
                          ,wo.lpst
                          ,CONVERT(NUMERIC(20,10) ,wo.operation_qty)  AS operation_qty 
                          ,CONVERT(NUMERIC(20,10) ,wo.complete_qty)   AS complete_qty 
                    
                          ,wo.operation_time ,wo.total_working_time ,wo.batch_qty 
                          ,wo.electrode_type --fi.electrode_type
                                                  
                        FROM SCP_ENG_WORK_ORDER_O_TEMP_SN     AS wo WITH(NOLOCK) --생산계획(ENG)
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)   -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = WO.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'
						   -- [PJ20257329] SCP Plan 공정 하드코딩 변경 - Start 
							 LEFT  JOIN @SCP_PLAN_OPERATION_ALL  PO
								     ON PO.OPERATION_ID = left(wo.operation_id,5)
 						   -- [PJ20257329] SCP Plan 공정 하드코딩 변경 - End 
                            --INNER JOIN SCP_MST_FINAL_ITEM_V  AS fi WITH(NOLOCK)
                             --   ON wo.division_id = @p_division_id 
                             --  AND wo.item_id = fi.item_id
                       WHERE 1=1
                         AND wo.master_id      = @p_master_id             --N'81::WEEKLY'     --
                         AND wo.plan_id        = @p_plan_id               --N'1032'           --
                         AND wo.out_version_id = @p_engine_plan_id        --N'1032::PR::1'    --
                         AND wo.division_id    = @p_division_id           --N'81'             --
                         AND wo.plan_name      = @p_plan_start_yyyymmdd   --N'20180625'       --
                         AND wo.plan_type      = @p_plan_type             --N'PR'             --
                         AND wo.seq            = @p_seq                   --N'1'              --
                         AND CONVERT(NUMERIC(20,10),wo.operation_qty) > 0.0
                         AND (LEFT(wo.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                           SELECT segment1 AS operation_id
                                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
                                                            WHERE lookup_type = 'SCP_PLAN_OPERATION' 
                                                              AND valid_yn    = 'Y' 
														 )
                       -- PJ20216891	
                       -- ISUZU item
                       OR (
                           LEFT(wo.operation_id,5) = 'P5000'
                           AND EXISTS (
                                       SELECT 1
                                       FROM   #tmp_ISUZU
                                       WHERE  ITEM_ID = wo.ITEM_ID
                                      )
                          )

                       OR

					   -- 2020-10-29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
					   -- operation_id vs plant_id Rack case 대응 ??????_R1
					   -- old version
					   --
                       --      wo.operation_id        IN (--외주PACKER의 업체코드
					           (CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) IN (--외주PACKER의 업체코드
					   -- 2020-10-29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

                                                           SELECT ms.plant_id  AS operation_id
                                                            FROM SCM_MST_SITE ms WITH(NOLOCK)      
                                                           WHERE 1=1
                                                             --  2023.03.31 HM JV AND division_id = (CASE WHEN wo.division_id IN ('EE', 'EE_UC') THEN wo.origin_division_id		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
                                                             AND ms.division_id = CASE	WHEN dm.attribute3 = 'EE' -- 2023.03.31 HM JV 가상 사업부 추가 대응
																						THEN wo.origin_division_id
																						ELSE wo.division_id 
                                                                                  END
                                                             AND ms.site_type   = 'PLANT'
                                                             AND ms.osp_yn      = 'Y' 
                                                             AND ms.valid_yn    = 'Y' 
                                                         ) 
                             )
                     ) AS b
                       GROUP BY --생산계획 GROUP BY
                             b.division_id               
                            ,b.origin_division_id               
                            ,b.operation_group 
                            ,b.site_id 
                            ,b.item_id 
                            ,b.resource_id 
                            --,b.route_id 
                            ,b.operation_id               
                            ,b.work_order_id  --기준1
                            ,b.start_time     --기준2

              UNION ALL
              --출하계획(그룹핑)
              --출하계획(order_id 기준 start_time 별로 complete_qty를 max(단,활성화/특성은 end_time기준))
              SELECT 
                   d.division_id 
                  ,d.origin_division_id 
                  ,d.order_id             AS work_order_id --기준1
                  ,d.operation_group 
                  ,d.site_id 
                  ,d.item_id 
                  ,d.resource_id 
                  ,d.operation_id 
                  ,MIN(d.start_time)      AS start_time
                  ,d.end_time --기준2
                  ,MIN(d.epst)            AS epst
                  ,MAX(d.lpst)            AS lpst
                  ,MAX(d.operation_qty)   AS operation_qty
                  ,MAX(d.complete_qty)    AS complete_qty 
                                
                  ,NULL AS operation_time ,null AS total_working_time ,null AS batch_qty --컬럼맞추기위해 추가
                  ,MAX(d.electrode_type)  AS electrode_type
                  ,N'DELIVERY_ORDER'      AS pegging_type
                  
                FROM (
                      --출하(활성화,특성)(엔진)
                      SELECT do.division_id 
                          ,do.origin_from_division_id AS origin_division_id 
                          ,do.order_id 
                          ,do.operation_group --fi.operation_group 
                          ,dbo.fn_scm_split(do.from_site_id,1,N'~') AS site_id --출하계획(from_site 사용) 
                          ,do.item_id                   
                          ,N'-' AS resource_id 
                          --,(CASE do.p_flag WHEN N'A~001' THEN N'F1000' WHEN N'A~002' THEN N'F6000' ELSE N'-' END) AS operation_id              
                          ,(CASE do.attribute3 WHEN N'A~001' THEN N'F1000' WHEN N'A~002' THEN N'F6000' ELSE N'-' END) AS operation_id              
                          ,do.start_time 
                          ,do.end_time 
                          ,do.epst 
                          ,do.lpst                     
                          ,do.operation_qty 
                          ,do.complete_qty 
                          ,do.electrode_type --fi.electrode_type

                      FROM SCP_ENG_DELIVERY_O_TEMP_SN AS do  WITH(NOLOCK) --출하정보 View 
                      --FROM SCP_PLN_DELIVERY_V   AS do  WITH(NOLOCK) --출하정보 View 
                           --INNER JOIN SCP_MST_FINAL_ITEM_V  AS fi WITH(NOLOCK)
                           --   ON do.division_id = @p_division_id 
                           --  AND do.item_id = fi.item_id
                      WHERE 1=1 
                        AND do.master_id        = @p_master_id            --N'81::WEEKLY'     --
                        AND do.plan_id          = @p_plan_id              --N'1032'           --
                        AND do.out_version_id   = @p_engine_plan_id       --N'1032::PR::1'    --
                        AND do.division_id      = @p_division_id          --N'81'             --
                        AND do.plan_name        = @p_plan_start_yyyymmdd  --N'20180625'       --
                        AND do.plan_type        = @p_plan_type            --N'PR'             --
                        AND do.seq              = @p_seq                  --N'1'              --
                        AND do.attribute2       = N'P' --do.sp_flag          = N'P' --출하계획에서 생산계획에 해당하는 데이터(SCP_PLN_DELIVERY_V에 정의되어있음)
                        --AND do.org_demand_id <> N'-' --출하요청 처리 되지 않은건은 제외
                        
                        AND do.end_time < @v_scp_end_date --SCP 52주 계획
                        --AND do.to_site_id NOT LIKE '%~003'   
                        --AND do.to_site_id NOT LIKE '%E~002' 
                ) AS d 
               GROUP BY --출하계획 GROUP BY
                     d.division_id                 
                    ,d.origin_division_id   
                    ,d.operation_group 
                    ,d.site_id ,d.item_id ,d.resource_id ,d.operation_id               
                    ,d.order_id --기준1
                    ,d.end_time --기준2
                                       
                    /* 출하요청(demand_id 기준 lpst(출하요청일) 별로 allocation_qty를 sum)*/
                    /* 출하계획(order_id 기준 start_time 별로 complete_qty를 max(단,활성화/특성은 end_time기준))*/
                      
              ) AS z 
              ;

        ----------------------------------------------------------- 
        -- 2.1 생산계획(PLAN) 정보 CHILD_ITEM_ID 추가 (40 일경우)
        ----------------------------------------------------------- 
        IF @p_division_id = '40'
        BEGIN
          -- 소형전지 TCO CELL ITEM 하위 CELL ITEM ID SETTING로직 수정 2019.02.27
          UPDATE X
             SET  X.CHILD_ITEM_ID = Y.ATTRIBUTE1       -- CELL ITEM ID
            FROM #Tbl_PLAN_WORK X WITH (NOLOCK)
            JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
              ON X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
             AND X.ITEM_ID            = Y.ITEM_ID
             AND Y.TCO_CELL_YN        = 'Y';            
            
        END  -- IF @p_division_id = '40'

        ----------------------------------------------------------- 
        -- 2.2 TCO_CELL YN 추가
        ----------------------------------------------------------- 
        UPDATE X
           SET  X.ATTRIBUTE7 = Y.TCO_CELL_YN         -- FROM TCO_CELL_YN
          FROM #Tbl_PLAN_WORK X WITH (NOLOCK)
          JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
            ON X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
           AND X.ITEM_ID            = Y.ITEM_ID

        ----------------------------------------------------------- 
        -- 3. 생산계획(PEGGING) 정보 조회
        ----------------------------------------------------------- 
        SELECT 
             z.division_id 
            ,z.work_order_id 
            ,z.eng_demand_id            
            ,SUM(z.allocation_qty)                              AS allocation_qty          
            ,ISNULL(dbo.fn_scm_split(z.demand_id,4,'::'),'D')   AS dom_exp --default :D(domestic)
            ,ISNULL(dbo.fn_scm_split(z.demand_id,5,'::'),'MPS') AS fcst_type --default :MPS (양산)
            ,MAX(z.eng_demand_priority)                         AS eng_demand_priority          
            ,MAX(z.pegging_type)                                AS pegging_type
            ,MAX(z.item_id)                                     AS item_id

        INTO #Tbl_PLAN_WORK_PEGGING
        FROM (

            --생산계획(엔진)
            SELECT 
                 wo.division_id
                ,wo.work_order_id
                ,pi.demand_id
                ,isnull(pi.eng_demand_id ,'UNPEGGING')                            AS eng_demand_id      --2018.8.9 ISNULL로직추가      
                ,isnull(CONVERT(NUMERIC(20,10) ,pi.supply_qty),wo.operation_qty)  AS allocation_qty     --2018.8.9 ISNULL로직추가              
                ,pi.demand_priority                     AS eng_demand_priority
                ,wo.item_id
                ,N'WORK_ORDER'                          AS pegging_type

            FROM #Tbl_PLAN_WORK                   AS wo WITH(NOLOCK) --생산계획(ENG)
              LEFT JOIN SCP_ENG_PEGGING_INFO_WO_V AS pi WITH(NOLOCK) --생산계획 PEGGING_INFO
                ON 1=1 
                AND pi.master_id      = @p_master_id              --N'81::WEEKLY'     --
                AND pi.plan_id        = @p_plan_id                --N'1032'           --
                AND pi.out_version_id = @p_engine_plan_id         --N'1032::PR::1'    --
                AND pi.division_id    = @p_division_id            --N'81'             --
                AND pi.plan_name      = @p_plan_start_yyyymmdd    --N'20180625'       --
                AND pi.plan_type      = @p_plan_type              --N'PR'             --
                AND pi.seq            = @p_seq                    --N'1'              --
                AND pi.modeling_id    = @p_modeling_id
                AND wo.division_id    = pi.division_id
                AND wo.work_order_id  = pi.work_order_id 
                --AND pi.demand_id <> N'UNPEGGING' --DEMAND_ID가 없는것 제외              
            WHERE 1=1 
              AND wo.pegging_type = 'WORK_ORDER'
            
            UNION ALL
            --출하(활성화,특성)(엔진)
            SELECT do.division_id 
                ,do.order_id        AS work_order_id 
                ,do.org_demand_id   AS demand_id
                ,do.demand_id       AS eng_demand_id            
                ,do.allocation_qty             
                ,d.priority         AS eng_demand_priority
                ,do.item_id 
                ,N'DELIVERY_ORDER'  AS pegging_type 

            FROM SCP_ENG_DELIVERY_O_TEMP_SN      AS do WITH(NOLOCK)  --출하정보 View
            --FROM SCP_PLN_DELIVERY_V           AS do WITH(NOLOCK)  --출하정보 View 
              LEFT JOIN TH_ENG_NET_DEMAND_SN  AS  d WITH (NOLOCK) -- MASTER_ID, PLAN_ID, DEMAND_ID
                  ON  1=1 
                  AND d.master_id     = @p_master_id              --N'81::WEEKLY'     --
                  AND d.plan_id       = @p_engine_plan_id         --N'1032::PR::1'    --
                  AND d.demand_id     = do.org_demand_id
                  AND do.end_time     < @v_scp_end_date --SCP 52주 계획
            WHERE 1=1 
              AND do.master_id        = @p_master_id              --N'81::WEEKLY'     --
              AND do.plan_id          = @p_plan_id                --N'1032'           --
              AND do.out_version_id   = @p_engine_plan_id         --N'1032::PR::1'    --
              AND do.division_id      = @p_division_id            --N'81'             --
              AND do.plan_name        = @p_plan_start_yyyymmdd    --N'20180625'       --
              AND do.plan_type        = @p_plan_type              --N'PR'             --
              AND do.seq              = @p_seq                    --N'1'              --
              AND do.attribute2       = N'P' --do.sp_flag          = N'P' --출하계획에서 생산계획에 해당하는 데이터(scp_pln_delivery_v에 정의되어있음)
              --AND do.org_demand_id <> N'-' --출하요청 처리 되지 않은건은 제외

              --AND do.to_site_id NOT LIKE '%~003'   
              --AND do.to_site_id NOT LIKE '%E~002' 
        ) AS z
        GROUP BY
              z.division_id
             ,z.work_order_id
             ,z.demand_id
             ,z.eng_demand_id
             ;
        
        ----------------------------------------------------------- 
        -- 4. 생산계획(PLAN) 정보 저장
        ----------------------------------------------------------- 
        INSERT SCP_PLN_PRODUCTION_PLAN(  
             master_id 
            ,out_version_id 
            ,plan_id 
            ,plan_type 
            ,plan_start_yyyymmdd 
            ,seq
            ,division_id 
            ,work_order_id
            ,operation_group 
            ,item_id 
            ,site_id 
            ,resource_id 
            ,operation_id
            ,start_time 
            ,complete_qty
            ,end_time 
            ,operation_time 
            ,total_working_time
            ,operation_qty 
            ,batch_qty 
            ,epst 
            ,lpst
            ,pegging_type  
            ,origin_division_id             
            ,electrode_type

            ,created_by 
            ,last_updated_by 
            ,child_item_id
            ,attribute7
            )        
            SELECT 
                 @p_master_id           AS master_id 
                ,@p_engine_plan_id      AS out_version_id 
                ,@p_plan_id             AS plan_id 
                ,@p_plan_type           AS plan_type 
                ,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
                ,@p_seq                 AS seq
                ,a.division_id 
                ,a.work_order_id 
                ,a.operation_group 
                ,a.item_id 
                ,a.site_id 
                ,a.resource_id 
                ,a.operation_id
                ,a.start_time 
                ,a.complete_qty
                ,a.end_time 
                ,a.operation_time 
                ,a.total_working_time
                ,a.operation_qty 
                ,a.batch_qty 
                ,a.epst 
                ,a.lpst
                ,a.pegging_type
                ,a.origin_division_id   --전극 작업 추가
                ,a.electrode_type       --전극 작업 추가

                ,@p_user_id             AS created_by 
                ,@p_user_id             AS last_updated_by
                ,a.child_item_id
                ,a.ATTRIBUTE7
            FROM #Tbl_PLAN_WORK     AS  a WITH(NOLOCK)
            ;
        
        ----------------------------------------------------------- 
        -- 5. 생산계획(PEGGING) UNPEGGING ALLOCATION_QTY 보정
        ----------------------------------------------------------- 
        UPDATE  #Tbl_PLAN_WORK_PEGGING
            SET #Tbl_PLAN_WORK_PEGGING.allocation_qty = b.allocation_qty_amend
        FROM #Tbl_PLAN_WORK_PEGGING
            ,(
              SELECT 
                   p.division_id
                  ,p.work_order_id
                  ,p.eng_demand_id
                  ,wo.complete_qty
                  -(SELECT ISNULL(SUM(ISNULL(a.allocation_qty,0.0)),0.0)
                    FROM #Tbl_PLAN_WORK_PEGGING AS a WITH(NOLOCK)
                    WHERE 1=1 
                      AND a.division_id   = p.division_id
                      AND a.work_order_id = p.work_order_id
                      AND a.eng_demand_id <> 'UNPEGGING') AS allocation_qty_amend --생산 수량에서 'UNPEGGING'아닌 DEMAND의 합을 뺀다
              FROM #Tbl_PLAN_WORK_PEGGING AS p WITH(NOLOCK)
                INNER JOIN #Tbl_PLAN_WORK AS wo WITH(NOLOCK)
                  ON 1=1
                    AND p.division_id   = wo.division_id
                    AND p.work_order_id = wo.work_order_iD
                    AND p.eng_demand_id = N'UNPEGGING' --DEMAND_ID가 'UNPEGGING' 인것
                    AND p.work_order_id = p.work_order_id    
              ) AS b 
        WHERE 1=1 
          AND #Tbl_PLAN_WORK_PEGGING.division_id    = b.division_id 
          AND #Tbl_PLAN_WORK_PEGGING.work_order_id  = b.work_order_id
          AND #Tbl_PLAN_WORK_PEGGING.eng_demand_id  = N'UNPEGGING' --DEMAND_ID가 'UNPEGGING' 인것
          ;


        -----------------------------------------------------------   
        -- UNPEGGING 데이터의 dom_exp ,fcst_type 를
        -- 같은 site_id ,item_id 의 PEGGING데이터의 TOP1 dom_exp ,fcst_type 로 업데이트
        -----------------------------------------------------------   
		
        SELECT a.work_order_id 
              ,b.dom_exp
              ,b.fcst_type
        INTO #Tbl_PLAN_WORK_UNPEGGING
         FROM (
                SELECT  pp.site_id 
                        ,pp.item_id
                        ,pp.work_order_id 
                        ,pi.dom_exp
                        ,pi.fcst_type
                        ,pi.pegging_type
                    FROM #Tbl_PLAN_WORK pp(NOLOCK)
                        inner join #Tbl_PLAN_WORK_PEGGING pi(NOLOCK)
                        on  1=1                 
                        and pp.division_id   = pi.division_id 
                        and pp.work_order_id = pi.work_order_id  
                        and pi.eng_demand_id = 'UNPEGGING'
              ) AS a 
              CROSS APPLY (
                        SELECT TOP 1 
                                pp.site_id
                            ,pp.item_id
                            ,pi.dom_exp
                            ,pi.fcst_type
                            ,pi.work_order_id
                            --,pi.eng_demand_id
                            --,pi.eng_demand_priority
                        FROM #Tbl_PLAN_WORK AS pp(NOLOCK)
                                INNER JOIN #Tbl_PLAN_WORK_PEGGING AS pi(NOLOCK)
                                ON  1=1                 
                                AND pp.division_id     = pi.division_id 
                                AND pp.work_order_id   = pi.work_order_id 
                                AND pi.eng_demand_id  <> 'UNPEGGING'
                                AND pp.site_id         = a.site_id
                                AND pp.item_id         = a.item_id
                        WHERE 1=1
                        ORDER BY pi.eng_demand_priority ASC
              ) AS b    ;

        UPDATE x
           SET  x.dom_exp   = f.dom_exp
               ,x.fcst_type = f.fcst_type
        --SELECT *
          FROM #Tbl_PLAN_WORK_PEGGING AS x WITH (NOLOCK)
               INNER JOIN #Tbl_PLAN_WORK_UNPEGGING AS f WITH (NOLOCK)
               ON f.work_order_id = x.work_order_id
         WHERE x.eng_demand_id = 'UNPEGGING'
         ;
		 /*
               INNER JOIN (
                            SELECT a.work_order_id 
                                  ,b.dom_exp
                                  ,b.fcst_type
                              FROM (
                                    SELECT  pp.site_id 
                                           ,pp.item_id
                                           ,pp.work_order_id 
                                           ,pi.dom_exp
                                           ,pi.fcst_type
                                           ,pi.pegging_type
                                      FROM #Tbl_PLAN_WORK pp(NOLOCK)
                                           inner join #Tbl_PLAN_WORK_PEGGING pi(NOLOCK)
                                           on  1=1                 
                                           and pp.division_id   = pi.division_id 
                                           and pp.work_order_id = pi.work_order_id  
                                           and pi.eng_demand_id = 'UNPEGGING'
                              ) AS a 
                             CROSS APPLY (
                                          SELECT TOP 1 
                                                 pp.site_id
                                                ,pp.item_id
                                                ,pi.dom_exp
                                                ,pi.fcst_type
                                                ,pi.work_order_id
                                                --,pi.eng_demand_id
                                                --,pi.eng_demand_priority
                                            FROM #Tbl_PLAN_WORK AS pp(NOLOCK)
                                                 INNER JOIN #Tbl_PLAN_WORK_PEGGING AS pi(NOLOCK)
                                                 ON  1=1                 
                                                 AND pp.division_id     = pi.division_id 
                                                 AND pp.work_order_id   = pi.work_order_id 
                                                 AND pi.eng_demand_id  <> 'UNPEGGING'
                                                 AND pp.site_id         = a.site_id
                                     AND pp.item_id         = a.item_id
                                          WHERE 1=1
                                          ORDER BY pi.eng_demand_priority ASC
                            ) AS b
                           ) AS f 
                             ON f.work_order_id = x.work_order_id
         WHERE x.eng_demand_id = 'UNPEGGING'
         ; */


        ----------------------------------------------------------- 
        -- 6. 생산계획(PEGGING) 정보 저장
        ----------------------------------------------------------- 
        INSERT SCP_PLN_PRODUCTION_PLAN_PEGGING (  
             master_id 
            ,out_version_id 
            ,plan_id 
            ,plan_type 
            ,plan_start_yyyymmdd 
            ,seq
            ,division_id 
            ,work_order_id 
            ,eng_demand_id
            ,allocation_qty
            ,dom_exp
            ,fcst_type
            ,eng_demand_priority
            ,pegging_type 
            ,item_id 
            
            ,created_by 
            ,last_updated_by 
            )        
            SELECT 
                 @p_master_id           AS master_id 
                ,@p_engine_plan_id      AS out_version_id 
                ,@p_plan_id             AS plan_id 
                ,@p_plan_type           AS plan_type 
                ,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
                ,@p_seq                 AS seq
                ,a.division_id 
                ,a.work_order_id 
                ,a.eng_demand_id 
                ,a.allocation_qty
                ,a.dom_exp         --default :D(domestic)
                ,a.fcst_type       --default :MPS (양산)
                ,a.eng_demand_priority              
                ,a.pegging_type
                ,a.item_id
                
                ,@p_user_id             AS created_by 
                ,@p_user_id             AS last_updated_by
            FROM #Tbl_PLAN_WORK_PEGGING AS a WITH(NOLOCK)
            ;


        --PRINT N'프로시저 종료'


        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT TRAN T1; 
        --  END;
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK') is not null
          DROP TABLE #Tbl_PLAN_WORK
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK_PEGGING') is not null
          DROP TABLE #Tbl_PLAN_WORK_PEGGING
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_PLAN_WORK_UNPEGGING') is not null
          DROP TABLE #Tbl_PLAN_WORK_UNPEGGING
          ;
        IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
          DROP TABLE #tmp_ISUZU
          ;
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    --로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
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
      --    ROLLBACK TRAN T1   
      --  END;


      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

         -- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';       
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
