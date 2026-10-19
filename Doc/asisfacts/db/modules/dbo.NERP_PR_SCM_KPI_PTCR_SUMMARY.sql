

/*
 * Program ID   : PR_SCM_KPI_PTCR_SUMMARY
 * Description  : KPI Summary 데이타 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.30   YYDOK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.09   YYDOK      현업요구사항 반영(자동차 /ESS  SCP팀 김완종 책임)
 * 2022.03.25   sclee.lee  PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 
 *- W40주차의 내용의 비교대상은 W40주차에 계획한 W40주계획과 W39주차에 계획한 W40주차의 계획이 아닌 
 *  W39주차에 계획한 W40 주차의 계획과 W38주차에 계획한 W40의 계획 
 *   사유 : W40주차에 계획한 W40의 계획에는 계획이 아닌 실적이 포함되어 있음, (해당 내용은 예전 진단이 나와서 반영된 사항임)
 *- Plant 에 Plant와 Operation Group을 구분하여 표기 
 *   사유 : SCP팀은 Global 물동을 관리하기 때문에, 크게 Operation Group을 보여주고 법인별 변화량을 확인
 *
 * 2022.06.27   sclee.lee  PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.23	hrkim	   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2024.03.25	vadabi5	   NERP) SCM Site ID 로 Plant ID 찾는 로직 정의
						   ------------------------------------------------------------------------- 
                           -- ASIS : LEFT(P.operation_id,5)
						   -- TOBE : operation_id (5지라로 컷 해도 OP 아니면 일치하는 경우 없음)
						   -------------------------------------------------------------------------
						   -- ASIS : LEFT( A.SALES_SITE_ID,4) AS PLANT_CODE -> SCM_KPI_SUMMARY.ATTRIBUTE2
						   -- TOBE : CODE 아닌 Name 컷 하지 않도록 변경 
----------------------------------------------------------------------------------------------------
select top 1 plan_start_yyyymmdd FROM   scm_kpi_detail
NERP_PR_SCM_KPI_PTCR_SUMMARY '202200217'
 */
 
CREATE PROCEDURE [dbo].[NERP_PR_SCM_KPI_PTCR_SUMMARY]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_PTCR_SUMMARY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_PTCR_SUMMARY'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' PR_SCM_KPI_PTCR_SUMMARY INSERT LOGIC';
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
  DECLARE @v_basis_yyyymmdd    NVARCHAR(8);  -- 기준 일자(w-1)
  DECLARE @v_preweek_yyyymmdd  NVARCHAR(8);  -- 기준 일자 앞주(w-2)
  DECLARE @v_2preweek_yyyymmdd  NVARCHAR(8);  -- 기준 일자 앞주(w-3)  


  DECLARE @v_kpi_type        NVARCHAR(30) =N'PTCR'; -- KPI 유형
  
  -- PJ20216891
  -- ISUZU item
  IF OBJECT_ID('tempdb..#ISUZU') IS NOT NULL
  BEGIN
      DROP TABLE #ISUZU;
  END
  
  -- PJ20216891
  -- ISUZU item
  SELECT A.ITEM_ID
  INTO #ISUZU
  FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
  INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
  WHERE A.IS_YN = 'Y'
    
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

    SET @v_preweek_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-7,CONVERT(DATETIME,@v_basis_yyyymmdd,112)),112);
    SET @v_2preweek_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-14,CONVERT(DATETIME,@v_basis_yyyymmdd,112)),112);    
    
    ------------------------------------------------------------------------------------
    -- Detail 생성 : PROD_TARGET(생산타겟) 
    -- 지난주 MA PLAN TYPE CONFIRM기준으로 생산타겟정보를 주단위SUM으로 형성한다.
    -- (3WEEKS ONLY FOR PTCR KPI CALC.)
    -- (DIVISION, PLANT_SITE_ID, ITEM, QTY )
    ------------------------------------------------------------------------------------

    DELETE 
    FROM   scm_kpi_detail
    WHERE  plan_start_yyyymmdd = @v_basis_yyyymmdd
    AND    measure IN ('PROD_TARGET');

    WITH SUB AS
    (
              SELECT    
                       P.DIVISION_ID            AS DIVISION_ID
                     , P.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
                     , P.PLAN_TYPE              AS PLAN_TYPE
                     , P.SEQ                    AS SEQ
                     , P.ITEM_ID                AS ITEM_ID
                     , P.SITE_ID                AS SITE_ID
                     , CONVERT(VARCHAR,P.END_TIME,112) 
                                                AS YYYYMMDD
                     , ( SELECT basis_yyyymmdd
                           FROM scm_sys_calendar_m cm WITH(NOLOCK)
                          WHERE iso_yyyyww IN (SELECT iso_yyyyww
                                                 FROM scm_sys_calendar_m WITH(NOLOCK)
                                                WHERE basis_yyyymmdd = CONVERT(VARCHAR,P.END_TIME,112)
                                                )
                            AND dayofweek = 'MON'
                        )                       AS PROD_WEEK
                     , SUM(P.COMPLETE_QTY)
                                                AS PROD_QTY
                     , P.ORIGIN_DIVISION_ID     AS ORIGIN_DIVISION_ID
                   FROM  dbo.SCP_PLN_PRODUCTION_PLAN         P  WITH(NOLOCK)
                   JOIN
                      (
                         select d.DIVISION_ID,
                                p.plan_name,
                                d.plan_type,
                                d.plan_seq
                           from scm_mst_plan_detail d with(nolock),
                                scm_mst_plan        p with(nolock),
                                scm_mst_modeling    m with(nolock)
                          where 1=1
                            and m.MODELING_ID   = d.MODELING_ID
                            and m.PLAN_CYCLE    = 'WEEKLY'
                            and m.DIVISION_ID   = d.DIVISION_ID
                            and m.MODELING_ID   = d.MODELING_ID
                            and p.DIVISION_ID   = d.DIVISION_ID
                            and p.PLAN_CYCLE    = m.PLAN_CYCLE
                            and p.PLAN_ID       = d.PLAN_ID
                            and d.PLAN_STATUS   = '1'
                            and d.UI_DISPLAY_YN = 'Y'
                            and p.plan_name     = @v_basis_yyyymmdd
                            and d.CONFIRM_FLAG  ='Y'
                            and d.plan_type     ='MA'
                      ) D
                      ON  P.DIVISION_ID              = D.DIVISION_ID
                      AND P.PLAN_START_YYYYMMDD      = D.PLAN_NAME
                      AND P.PLAN_TYPE                = D.PLAN_TYPE
                      AND P.SEQ                      = D.PLAN_SEQ
					  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
					  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
							  ON DM.DIVISION_ID = P.DIVISION_ID 
							 AND DM.VALID_YN	= 'Y'
                  WHERE 1=1
/* 
                    AND  LEFT(P.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                      SELECT segment1 AS OPERATION_ID
                                                        FROM scm_adm_lookup_master_detail WITH(NOLOCK)   
                                                       WHERE lookup_type = 'SCP_PLAN_OPERATION' )
 */													   

                    -- PJ20216891	
                    -- ISUZU item
                    AND (
                         P.operation_id IN (
                                                    SELECT segment1 AS OPERATION_ID
                                                      FROM scm_adm_lookup_master_detail WITH(NOLOCK)
                                                     WHERE lookup_type = 'SCP_PLAN_OPERATION'
                                                   )
                         OR (
                             P.operation_id = 'P5000'
                             AND EXISTS (
                                         SELECT 1
                                         FROM   #ISUZU A
                                         WHERE  A.ITEM_ID = P.ITEM_ID
                                        )
                            )
                        )
													   
                    AND P.operation_id NOT IN ( 'F1000','F6000') --활성화,특성제외 
                    AND P.COMPLETE_QTY >= 1.0
					
                    -- PJ20216891
                    -- AND ( ( P.DIVISION_ID <> 'EE' ) OR ( P.DIVISION_ID = 'EE' AND P.OPERATION_GROUP <> 'A' )) 
                    -- AND ( ( P.DIVISION_ID <> 'EE' ) OR ( P.DIVISION_ID LIKE 'EE%' AND P.OPERATION_GROUP <> 'A' ))
					AND  ( (DM.ATTRIBUTE3 <> 'EE') OR (DM.ATTRIBUTE3 = 'EE' AND P.OPERATION_GROUP <> 'A') ) -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
                    AND P.END_TIME < DATEADD(D,21,CONVERT(DATETIME,@v_basis_yyyymmdd,112)) -- PTCR KPI 산출시 2주만 필요
                  GROUP BY P.DIVISION_ID
                          ,P.PLAN_START_YYYYMMDD
                          ,P.PLAN_TYPE
                          ,P.SEQ
                          ,P.ITEM_ID
                          ,P.SITE_ID
                          ,CONVERT(VARCHAR,P.END_TIME,112)
                          ,P.ORIGIN_DIVISION_ID    
                 HAVING ROUND(SUM(ISNULL(P.COMPLETE_QTY,0)),0)>= 1
    )
     INSERT INTO scm_kpi_detail (
            division_id
           ,project_code
           ,sales_site_id
           ,item_id
           ,plan_start_yyyymmdd
           ,plan_week
           ,yyyymmdd
           ,planning_week_offset
           ,measure
           ,qty
           ,item_type   
           ,valid_yn
           ,created_by
           ,creation_date
           ,last_updated_by
           ,last_update_date)
     SELECT ORIGIN_DIVISION_ID AS DIVISION_ID
           ,''                 AS PROJECT_CODE
           ,SITE_ID
           ,ITEM_ID
           ,PLAN_START_YYYYMMDD
           ,( SELECT TOP 1 WEEK_NAME 
                FROM scm_sys_calendar_m cm WITH(NOlOCK) 
               WHERE cm.basis_yyyymmdd = PLAN_START_YYYYMMDD ) 
                               AS PLAN_WEEK
           ,PROD_WEEK          AS YYYYMMDD      
           ,DATEDIFF(WK,  SUB.PLAN_START_YYYYMMDD,
                          CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(SUB.PROD_WEEK, 'MON')), 112)
                     ) AS PLANNING_WEEK_OFFSET
           ,'PROD_TARGET'      AS MEASURE
           ,SUM(PROD_QTY)      AS QTY
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
               WHERE t1.division_id  = SUB.ORIGIN_DIVISION_ID --EE고려
                 and t1.item_id      = SUB.ITEM_ID              
             )            AS ITEM_TYPE
           ,'Y'           AS valid_yn
           ,@v_batch_user AS created_by
           ,GETDATE()     AS creation_date
           ,@v_batch_user AS last_updated_by
           ,GETDATE()     AS last_update_date  
       FROM SUB
      GROUP BY 
            ORIGIN_DIVISION_ID,
            PLAN_START_YYYYMMDD,
            SITE_ID,
            ITEM_ID,
            PROD_WEEK              
            ;
  
    ------------------------------------------------------------------------------------
    -- Detail 생성 : PROD_TARGET(생산타겟) 
    -- (W-2)의 W-1주차에 대한  생산타겟존재하지만, 그 전주(W-3)에 W-1주차 타겟이 없는 경우
    -- 0으로 과거타겟을 생성한다. (PTCR KPI 계산용)
    ------------------------------------------------------------------------------------
     INSERT INTO scm_kpi_detail (
            division_id
           ,project_code
           ,sales_site_id
           ,item_id
           ,plan_start_yyyymmdd
           ,plan_week
           ,yyyymmdd
           ,planning_week_offset
           ,measure
           ,qty
           ,item_type   
           ,valid_yn
           ,created_by
           ,creation_date
           ,last_updated_by
           ,last_update_date)
     SELECT W_2.DIVISION_ID
           ,''         AS PROJECT_CODE
           ,W_2.SALES_SITE_ID
           ,W_2.ITEM_ID
           ,@v_2preweek_yyyymmdd AS PLAN_START_YYYYMMDD  -- W_3
           ,( SELECT TOP 1 WEEK_NAME 
                FROM scm_sys_calendar_m cm WITH(NOlOCK) 
               WHERE cm.basis_yyyymmdd = @v_2preweek_yyyymmdd ) 
                              AS PLAN_WEEK
           ,@v_basis_yyyymmdd AS YYYYMMDD                -- W_1
           , 2         AS PLANNING_WEEK_OFFSET           -- W_1
           ,W_2.MEASURE
           , 0         AS QTY
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
               WHERE t1.division_id  = W_2.DIVISION_ID 
                 and t1.item_id      = W_2.ITEM_ID              
             )
           ,'Y'           AS valid_yn
           ,@v_batch_user AS created_by
           ,GETDATE()     AS creation_date
           ,@v_batch_user AS last_updated_by
           ,GETDATE()     AS last_update_date       
      FROM SCM_KPI_DETAIL AS W_2 WITH(NOLOCK)  
     WHERE W_2.PLAN_START_YYYYMMDD  = @v_preweek_yyyymmdd 
       AND w_2.MEASURE              = 'PROD_TARGET'
       AND w_2.PLANNING_WEEK_OFFSET = 1 --W_1
       AND NOT EXISTS (
                          SELECT 'X'
                            FROM SCM_KPI_DETAIL AS W_3 WITH(NOLOCK)  
                           WHERE W_3.PLAN_START_YYYYMMDD  = @v_2preweek_yyyymmdd 
                             AND w_3.MEASURE              = 'PROD_TARGET'
                             AND w_3.PLANNING_WEEK_OFFSET = 2
                             AND W_3.DIVISION_ID          = W_2.DIVISION_ID
                             AND W_3.SALES_SITE_ID        = W_2.SALES_SITE_ID
                             AND W_3.ITEM_ID              = W_2.ITEM_ID
                       ); 

    ------------------------------------------------------------------------------------
    -- Detail 생성 : PROD_TARGET(생산타겟) 
    -- (W-3) 생산타겟존재하지만(W-1), 그 (W-2)에 W-1주차 타겟이 없는 경우
    -- 0으로 타겟을 생성한다. (PTCR KPI 계산용)
    ------------------------------------------------------------------------------------                              
     INSERT INTO scm_kpi_detail (
            division_id
           ,project_code
           ,sales_site_id
           ,item_id
           ,plan_start_yyyymmdd
           ,plan_week
           ,yyyymmdd
           ,planning_week_offset
           ,measure
           ,qty
           ,item_type   
           ,valid_yn
           ,created_by
           ,creation_date
           ,last_updated_by
           ,last_update_date)
     SELECT W_3.DIVISION_ID
           ,''         AS PROJECT_CODE
           ,W_3.SALES_SITE_ID
           ,W_3.ITEM_ID
           ,@v_preweek_yyyymmdd AS PLAN_START_YYYYMMDD  --W_2
           ,( SELECT TOP 1 WEEK_NAME 
                FROM scm_sys_calendar_m cm WITH(NOlOCK) 
               WHERE cm.basis_yyyymmdd = @v_preweek_yyyymmdd ) 
                              AS PLAN_WEEK
           ,@v_basis_yyyymmdd AS YYYYMMDD               --W_1
           , 1         AS PLANNING_WEEK_OFFSET
           ,W_3.MEASURE
           , 0         AS QTY
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
               WHERE t1.division_id  = W_3.DIVISION_ID 
                 and t1.item_id      = W_3.ITEM_ID              
             )
           ,'Y'           AS valid_yn
           ,@v_batch_user AS created_by
           ,GETDATE()     AS creation_date
           ,@v_batch_user AS last_updated_by
           ,GETDATE()     AS last_update_date       
      FROM SCM_KPI_DETAIL AS W_3 WITH(NOLOCK)  
     WHERE W_3.PLAN_START_YYYYMMDD  = @v_2preweek_yyyymmdd --w_3
       AND w_3.MEASURE              = 'PROD_TARGET'
       AND w_3.PLANNING_WEEK_OFFSET = 2
       AND NOT EXISTS (
                          SELECT 'X'
                            FROM SCM_KPI_DETAIL AS W_2 WITH(NOLOCK)  
                           WHERE W_2.PLAN_START_YYYYMMDD  = @v_preweek_yyyymmdd --W_2
                             AND w_2.MEASURE              = 'PROD_TARGET'
                             AND w_2.PLANNING_WEEK_OFFSET = 1                   --W_1
                             AND W_2.DIVISION_ID          = W_3.DIVISION_ID
                             AND W_2.SALES_SITE_ID        = W_3.SALES_SITE_ID
                             AND W_2.ITEM_ID              = W_3.ITEM_ID
                       ); 

    ------------------------------------------------------------------------------------
    -- Summary 생성 (Rate 까지 계산해서 DW 로 전송하는 KPI)
    ------------------------------------------------------------------------------------

    DELETE 
    FROM   scm_kpi_summary
    WHERE  basis_yyyymmdd = @v_basis_yyyymmdd
      AND  KPI_TYPE       = @v_kpi_type
        ;

INSERT INTO SCM_KPI_SUMMARY (
       BASIS_YYYYMMDD         --*
      ,DIVISION_ID            --*C
      ,SALES_SITE_ID          --*
      ,ITEM_ID                --*
      ,KPI_TYPE               --
      ,KPI_RATE               --
      
      ,PROJECT_CODE           --*      
      ,BASIS_WEEK             --
      ,PLANNING_WEEK_OFFSET   --*
      ,ACCUMULATED_YN         --*
      ,WEIGHT                 --
      ,VALID_YN               --
      ,CREATED_BY             --
      ,CREATION_DATE          --
      ,LAST_UPDATED_BY        --
      ,LAST_UPDATE_DATE       --
      ,ATTRIBUTE1             -- OPERATION_GROUP_NAME
      ,ATTRIBUTE2             -- PLANT_NAME
      ,ATTRIBUTE3             -- W_2 UI COLUMN VALUE
      ,ATTRIBUTE4             -- W_1 UI COLUMN VALUE
      )      
SELECT @v_basis_yyyymmdd AS BASIS_YYYYMMDD
      ,A.DIVISION_ID
      ,A.SALES_SITE_ID AS PLANT_SITE_ID
      ,A.ITEM_ID
      ,'PTCR'          AS KPI_TYPE
      ,ROUND(
              CASE WHEN  (CASE WHEN A.QTY = 0 AND B.QTY > 0 THEN 100
                               WHEN A.QTY > 0 AND B.QTY = 0 THEN 100
                               WHEN A.QTY = 0 AND B.QTY = 0 THEN 0
                               ELSE (ABS( A.QTY - B.QTY ) / A.QTY ) * 100.0
                          END) > 100  THEN 100
                   ELSE  (CASE WHEN A.QTY = 0 AND B.QTY > 0 THEN 100
                               WHEN A.QTY > 0 AND B.QTY = 0 THEN 100
                               WHEN A.QTY = 0 AND B.QTY = 0 THEN 0
                               ELSE (ABS( A.QTY - B.QTY ) / A.QTY ) * 100.0
                          END)
              END
             ,5)         AS KPI_RATE
      ,''               --PROJECT_CODE           --*
      ,NULL             --BASIS_WEEK             --
      ,0                --PLANNING_WEEK_OFFSET   --*
      ,''               --ACCUMULATED_YN         --*
      ,NULL             --WEIGHT                 --
      ,'Y'              --VALID_YN               --
      ,@v_batch_user    --CREATED_BY             --
      ,GETDATE()        --CREATION_DATE          --
      ,@v_batch_user    --LAST_UPDATED_BY        --
      ,GETDATE()        --LAST_UPDATE_DATE)      --             
      , (CASE S.OPERATION_GROUP WHEN 'E' THEN 'Electrode'
                                WHEN 'A' THEN 'Cell'
                                WHEN 'P' THEN 'Pack'
         END)           AS OPERATION_GROUP
      --, LEFT( A.SALES_SITE_ID,4) AS PLANT_CODE --PLANT CODE
	  , A.SALES_SITE_ID
      , A.QTY
      , B.QTY      
  FROM (
         SELECT DIVISION_ID
               ,SALES_SITE_ID
               ,ITEM_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_WEEK
               ,YYYYMMDD
               ,PLANNING_WEEK_OFFSET
               ,MEASURE
               ,QTY
          FROM SCM_KPI_DETAIL AS W_3 WITH(NOLOCK)  
         WHERE W_3.PLAN_START_YYYYMMDD  = @v_2preweek_yyyymmdd --W_3
           AND w_3.MEASURE              = 'PROD_TARGET'
           AND w_3.PLANNING_WEEK_OFFSET = 2                    --W_1
        ) A
        JOIN
        (
         SELECT DIVISION_ID
               ,SALES_SITE_ID
               ,ITEM_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_WEEK
               ,YYYYMMDD
               ,PLANNING_WEEK_OFFSET
               ,MEASURE
               ,QTY
          FROM SCM_KPI_DETAIL AS W_2 WITH(NOLOCK)  
         WHERE W_2.PLAN_START_YYYYMMDD  = @v_preweek_yyyymmdd --W_2
           AND w_2.MEASURE              = 'PROD_TARGET'
           AND w_2.PLANNING_WEEK_OFFSET = 1                   --W_1
        ) B
        ON  A.DIVISION_ID       =  B.DIVISION_ID
        AND A.SALES_SITE_ID     =  B.SALES_SITE_ID
        AND A.ITEM_ID           =  B.ITEM_ID
       , SCM_MST_SITE S WITH(NOLOCK)
  WHERE 1=1
    AND A.DIVISION_ID   = S.DIVISION_ID
    AND A.SALES_SITE_ID = S.SCM_SITE_ID
    AND S.SITE_TYPE     = 'PLANT'
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

      -- PJ20216891
      -- ISUZU item
      IF OBJECT_ID('tempdb..#ISUZU') IS NOT NULL
      BEGIN
          DROP TABLE #ISUZU;
      END
		
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
