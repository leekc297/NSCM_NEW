

/*
 * Program ID   : PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP
 * Description  : CREATE SCP FINAL ITEM FROM FP ITEM MASTER
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.15   YYDOK          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.03   Kim Jihye      Packer Plan Item ID (소형 Packer 대표 ID) 추가
 * 2018.08.15   YYDOK          TCO_CELL_YN ADD
 * 2018.09.03   YYDOK          SCM_MST_FINAL_ITEM_V -> SCM_MST_FINAL_ITEM_ORIGIN_DIV_V 변경
 * 2018.09.18   YYDOK          소형 셀,팩 ITEM에 대하여 원/각/파우치구분칼럼추가(CELL_TYPE_GROUP_CODE)
 * 2018.10.05   KTH            칼럼추가(CELL_ITEM_ID,CONVERT_QTY_CELL) 후 UPDATE문 반영
 * 2018.10.31   YYDOK          DM FCST에 존재하는 모델하위 FINAL ITEM에 수요존재여부,최소납기일자 칼럼 업데이트
 * 2018.11.02   YYDOK          TCO셀 구분에 공정코드 추가반영( 초소형셀 MCSS20253-A4 F6200공정은 TCO CELL ITEM)
 * 2018.11.27   YYDOK          PACK,TCO셀,셀(자신)에 대하여 들어가는 CELL LIST를 콤마로 구분하여 ATTRIBUTE1에 셋팅
 *                             GLOBAL PSI화면에서 조회조건에 사용하기위해 로직적용. 
 * 2019.02.22   YYDOK          CONVERT_QTY_CELL 추출시 SCM_MST_MODEL_FINAL_ITEM_BOM_V -> SCM_MST_MODEL_FINAL_ITEM_BOM_V1 변경
 * 2019.07.09   KTH            CELL_TYPE_GROUP_CODE에 WHEN 'E' THEN 'P' 조건 추가
 * 2019.09.30   KSG            [CSR ID 4083826] 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼
 *                             전극의 Cell 환산자 처리 수정 : FN_GET_REQ_QTY_MODEL_FOR_SCP_SN 사용(FP의 FN_GET_REQ_QTY_MODEL)
 * 2020.02.18   KSG            [C20200207-000240] MRP - Requirement list cell수량 확인요청 
 * 2020.10.14   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021.05.28   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2021.10.06   sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : RTF개선
 * 2021.11.05   sclee.lee      PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : MEB
 * 2022.01.10   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : DC Item 구분 : attribute4
 * 2022-06-02   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISUZU Item 구분 : attribute5
 * 2022-09-20   KSG            PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : 소형 P5000 Cell Type Group 처리 추가
 * 2022.11.15   KSG            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023.02.23   jahn1501       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCP_MST_FINAL_ITEM 테이블에 셀환산자(CELL_CF)컬럼 업데이트
 * 2023.04.13	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.06.02   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 Cell Prod/Assy 구분자 추가 - ATTRIBUTE8 에 설정
 * 2023.07.26   KSG            PJ20230692 LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : SCP_MST_CELL_PROD_ASSY_MAP 사용 시 Valid_yn = 'Y' 조건 추가
 * 2023.11.02   KSG            E20231026-001169 4680/4695 제품에 대한 [Cell Type Gr] 지정 요청의 건 : CELL_TYPE_GROUP_CODE -‘M’인 경우 Cell은‘C, pack은‘P’처리
 * 2023.11.23   KSG            E20231120-000042 [SCM/물류 PI팀]Model code master 시스템의 셀환산 누락방지를 위한 신규 기능 추가의 건 : 평가감 모델의 CELL_CF Update
 * 2023.12.11   KSG            E20231204-000282 CELL_CF  CONVERT_QTY_CELL 설정 logic 수정 요청 : 
 * 2024.06.15   KSG            PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : FCST 처리 시 동일 GROUP Item 추가
 * 2024.11.01   KSG            E20240923-000249 Model Code Master 내 Cell NickName 변경 요청 드립니다. : 신규 item Code 등록 시 Basic Model Cell의 NickName 값으로 넣어줌
 * 2026.04.15   YMH            E20260313-002032 SCP 전극 Cell환산기준 변경요청
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP_YMH_NEW_20260415]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_FINAL_ITEM'; 
    DECLARE @d_event_date   DATETIME;
    DECLARE @d_plan_date    DATETIME;
	SET     @d_plan_date = DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON'));
	DECLARE @n_period        INT = 450; -- FCST 확인 구간
    DECLARE @v_plan_date     NVARCHAR(8);  -- FCST 확인 구간
    DECLARE @v_plan_end_date NVARCHAR(8);  -- FCST 확인 구간
	SET     @v_plan_date     = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	SET     @v_plan_end_date = CONVERT(CHAR(8), DATEADD(DD, @n_period, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	
  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_FINAL_ITEM INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    DECLARE @X_DEFAULT_DEMAND_GROUPING_DAYS INT =1;
    
    BEGIN TRY
      BEGIN
	  	  
		-- 20210528 PJ20209642 : FCST 확인 구간
		SELECT @n_period = MAX(DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1) -- HM JV 가상 사업부 추가 대응 : 사업부 상관없이 MAX값
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  1=1 -- HM JV 가상 사업부 추가 대응  p.division_id = '81'
		AND    p.plan_cycle  = 'WEEKLY'
		AND    p.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
		;
    
        ----------------------------------------------------------- 
        -- SCP FINAL ITEM CREATE
        ----------------------------------------------------------- 
        WITH XX AS
        (
        SELECT  I.DIVISION_ID,
                I.ITEM_ID,
                MAX(I.NICK_NAME)  AS NICK_NAME,
                MAX(I.ITEM_CLASS) AS ITEM_CLASS,
				-- 20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID
                CASE WHEN MAX(I.SCP_OPERATION_GROUP) = 'E' THEN MAX(I.APPLIED_MODEL) 
				     ELSE NULL
				END AS CELL_ITEM_ID,
                MAX(CASE WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID ELSE FLOW_ID END) AS FLOW_ID,
                MAX(I.SCP_OPERATION_GROUP)    AS OPERATION_GROUP,
                MAX(I.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID,
                MAX(FI.ELECTRODE_TYPE)        AS ELECTRODE_TYPE,
				-- PJ20202001 Rack Item 추가
    --            CASE WHEN MAX(I.ITEM_CLASS) = 'EM0304' THEN 'Y'
				--     ELSE 'N'
				--END AS ATTRIBUTE3
				MAX(ISNULL(FI.RACK_YN, 'N'))   AS ATTRIBUTE3,
				MAX(ISNULL(FI.DC_YN, 'N'))     AS ATTRIBUTE4, -- 20220110 DC Item 구분
				MAX(ISNULL(FI.IS_YN, 'N'))     AS ATTRIBUTE5, -- 20220602 PJ20216891 ISUZU Item 구분
				MAX(ISNULL(FI.CELL_TYPE, ''))  AS ATTRIBUTE8  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
          FROM  SCM_MST_ITEM_SN       I WITH(NOLOCK)
               ,SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  FI WITH(NOLOCK)
         WHERE I.DIVISION_ID = FI.DIVISION_ID
           AND I.ITEM_ID     = FI.ITEM_ID
           AND I.ACTIVE_FLAG = 'Y'
           AND I.SCP_OPERATION_GROUP IS NOT NULL
         GROUP BY I.DIVISION_ID, 
                  I.ITEM_ID           
        )
          UPDATE SCP_MST_FINAL_ITEM
          SET     NICK_NAME          = XX.NICK_NAME
                , ITEM_CLASS         = XX.ITEM_CLASS				
                , CELL_ITEM_ID       = XX.CELL_ITEM_ID -- 20190930 전극 대표 Cell 처리
				--, CONVERT_QTY_CELL   = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date)) -- 20231211 : E20231204-000282 아래에서 별도 처리 -- 20190930 Cell 환산자 처리
                , FLOW_ID            = XX.FLOW_ID
                , OPERATION_GROUP    = XX.OPERATION_GROUP
                , OPERATION_GROUP_ID = XX.OPERATION_GROUP_ID
                , ELECTRODE_TYPE     = XX.ELECTRODE_TYPE
                , ATTRIBUTE3         = XX.ATTRIBUTE3  -- PJ20202001 Rack Item 추가
                , ATTRIBUTE4         = XX.ATTRIBUTE4  -- 20220110 DC Item 구분
                , ATTRIBUTE5         = XX.ATTRIBUTE5  -- 20220602 PJ20216891 ISUZU Item 구분
                , ATTRIBUTE8         = XX.ATTRIBUTE8  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
                , LAST_UPDATED_BY    = 'COPY'
                , LAST_UPDATE_DATE   = GETDATE()
         /* SELECT  XX.NICK_NAME
                , XX.ITEM_CLASS
                , XX.FLOW_ID
                , XX.OPERATION_GROUP
                , XX.OPERATION_GROUP_ID
                , XX.ELECTRODE_TYPE
          */
            FROM XX,
                 SCP_MST_FINAL_ITEM AA WITH(NOLOCK)
           WHERE 1=1
             AND XX.DIVISION_ID = AA.DIVISION_ID
             AND XX.ITEM_ID     = AA.ITEM_ID
           ;    

        SET @n_log_count = @@ROWCOUNT;                
        
        WITH XX AS
        (
        SELECT  I.DIVISION_ID,
                I.ITEM_ID,
                MAX(I.NICK_NAME)  AS NICK_NAME,
                MAX(I.ITEM_CLASS) AS ITEM_CLASS,
				-- 20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID
                CASE WHEN MAX(I.SCP_OPERATION_GROUP) = 'E' THEN MAX(I.APPLIED_MODEL) 
				     ELSE NULL
				END AS CELL_ITEM_ID,
                MAX(CASE WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID ELSE FLOW_ID END) AS FLOW_ID,
                MAX(I.SCP_OPERATION_GROUP)    AS OPERATION_GROUP,
                MAX(I.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID,
                MAX(FI.ELECTRODE_TYPE)        AS ELECTRODE_TYPE,
                --MAX( CASE WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MD' ) THEN 'Y' 
                --          WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MI' ) THEN 'Y' 
                --          WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MT' ) THEN 'Y' 
                --          WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' AND SUBSTRING(I.ITEM_ID,1,2) = 'MT' ) THEN 'Y' 
                --          WHEN (I.SCP_OPERATION_GROUP ='A' AND I.DIVISION_ID ='40' 
                --                AND (CASE WHEN FLOW_ID IS NULL THEN LEFT(SCP_FLOW_ID,5) ELSE LEFT(FLOW_ID,5) END) IN ('F6200','F7000','F7100','F7200','F7300') ) THEN 'Y'                           
                --     ELSE 'N' 
                --     END ) AS TCO_CELL_YN,
				MAX(ISNULL(FI.TCO_CELL_YN, 'N')) AS TCO_CELL_YN,
				-- PJ20202001 Rack Item 추가
    --            CASE WHEN MAX(I.ITEM_CLASS) = 'EM0304' THEN 'Y'
				--     ELSE 'N'
				--END AS ATTRIBUTE3
				MAX(ISNULL(FI.RACK_YN, 'N'))   AS ATTRIBUTE3,
				MAX(ISNULL(FI.DC_YN, 'N'))     AS ATTRIBUTE4, -- 20220110 DC Item 구분
				MAX(ISNULL(FI.IS_YN, 'N'))     AS ATTRIBUTE5, -- 20220602 PJ20216891 ISUZU Item 구분
				MAX(ISNULL(FI.CELL_TYPE, ''))  AS ATTRIBUTE8  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
          FROM  SCM_MST_ITEM_SN       I WITH(NOLOCK)
               ,SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  FI WITH(NOLOCK)
         WHERE I.DIVISION_ID = FI.DIVISION_ID
           AND I.ITEM_ID     = FI.ITEM_ID
           AND I.ACTIVE_FLAG = 'Y'
           AND I.SCP_OPERATION_GROUP IS NOT NULL
         GROUP BY I.DIVISION_ID, 
                  I.ITEM_ID 
        )
          INSERT SCP_MST_FINAL_ITEM
               ( DIVISION_ID
                ,ITEM_ID
                ,NICK_NAME            
                ,ITEM_CLASS           
                ,CELL_ITEM_ID     -- 20190930 전극 대표 Cell 처리
				,CONVERT_QTY_CELL -- 20190930 Cell 환산자 처리
                ,OPERATION_GROUP      
                ,OPERATION_GROUP_ID   
                ,ELECTRODE_TYPE       
                ,FLOW_ID              
                ,DEMAND_GROUPING_DAYS 
                ,CREATED_BY           
                ,CREATION_DATE        
                ,LAST_UPDATED_BY      
                ,LAST_UPDATE_DATE 
                ,TCO_CELL_YN 
				,ATTRIBUTE3 -- PJ20202001 Rack Item 추가
                ,ATTRIBUTE4 -- 20220110 DC Item 구분
                ,ATTRIBUTE5 -- 20220602 PJ20216891 ISUZU Item 구분
                ,ATTRIBUTE8 -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
			   )
          SELECT DIVISION_ID
                ,ITEM_ID
                ,NICK_NAME            
                ,ITEM_CLASS               
                ,CELL_ITEM_ID     -- 20190930 전극 대표 Cell 처리
				,(1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, @d_plan_date)) -- 20231211 : E20231204-000282 아래에서 추가 처리 -- 20190930 Cell 환산자 처리
                ,OPERATION_GROUP      
                ,OPERATION_GROUP_ID   
                ,ELECTRODE_TYPE       
                ,FLOW_ID              
                ,( CASE WHEN OPERATION_GROUP = 'A' THEN 1 ELSE NULL END ) AS DEMAND_GROUPING_DAYS 
                ,'COPY'    AS CREATED_BY           
                ,GETDATE() AS CREATION_DATE        
                ,'COPY'    AS LAST_UPDATED_BY      
                ,GETDATE() AS LAST_UPDATE_DATE
                ,TCO_CELL_YN
				,ATTRIBUTE3 -- PJ20202001 Rack Item 추가
                ,ATTRIBUTE4 -- 20220110 DC Item 구분
                ,ATTRIBUTE5 -- 20220602 PJ20216891 ISUZU Item 구분
                ,ATTRIBUTE8 -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
            FROM XX
           WHERE 1=1
             AND NOT EXISTS ( SELECT 'X' 
                                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
                               WHERE X.DIVISION_ID = XX.DIVISION_ID
                                 AND X.ITEM_ID     = XX.ITEM_ID )                             
           ;

        SET @n_log_count = @n_log_count + @@ROWCOUNT;    

        ----------------------------------------------------------- 
        --Packer Plan Item ID (소형 Packer 대표 ID) 추가
        -----------------------------------------------------------
        UPDATE SCP_MST_FINAL_ITEM
        SET    PACKER_PLAN_ITEM_ID = A.ITEM_ID,
               LAST_UPDATE_DATE    = GETDATE()
        FROM   SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
        JOIN   (SELECT DISTINCT 
                       DIVISION_ID
                      ,ITEM_ID
                FROM   SCM_MST_SITE_ITEM SI WITH(NOLOCK)
                WHERE  DIVISION_ID  = '40'
                AND    LEN(ITEM_ID) > 11
                AND    DBO.FN_GET_ITEM_OPERATION_GROUP(DIVISION_ID, ITEM_ID) = 'P') A
        ON     FI.DIVISION_ID       = A.DIVISION_ID
        AND    LEFT(FI.ITEM_ID, 11) = LEFT(A.ITEM_ID, 11)
        WHERE  FI.DIVISION_ID       = '40'
        AND    FI.OPERATION_GROUP   = 'P'
        -- AND    FI.PACKER_PLAN_ITEM_ID IS NULL
        AND    LEN(FI.ITEM_ID)      > 11
        AND    LEFT(FI.ITEM_ID, 11) IN (SELECT LEFT(ITEM_ID, 11)
                                        FROM   SCP_MST_FINAL_ITEM WITH(NOLOCK)
                                        WHERE  DIVISION_ID     = '40'
                                        AND    OPERATION_GROUP = 'P'
                                        AND    LEN(ITEM_ID)    > 11
                                        GROUP BY LEFT(ITEM_ID, 11)
                                        HAVING COUNT(*) > 1)
        ;

        ----------------------------------------------------------- 
        -- 칼럼추가(CELL_ITEM_ID,CONVERT_QTY_CELL) 후 UPDATE문 반영
        -- 20190930 전극 대표 Cell 처리 : CELL_ITEM_ID가 NULL 인 경우만 처리
		-- 20230602 PJ20230691 활성화 대응 : 최정 Cell Prod 로 처리
        -----------------------------------------------------------
        UPDATE X
           SET X.CELL_ITEM_ID       = Y.CELL_ITEM_ID
               --, X.CONVERT_QTY_CELL   = Y.CONVERT_QTY_CELL-- 20231211 : E20231204-000282 아래에서 별도 처리
        --SELECT X.CELL_ITEM_ID, Y.CELL_ITEM_ID,X.CONVERT_QTY_CELL,Y.CONVERT_QTY_CELL,*
         FROM SCP_MST_FINAL_ITEM X
          INNER JOIN 
		  -- Cell 생산 계획이 있는 모델 대상
          (
             SELECT SUB.DIVISION_ID, SUB.ITEM_ID AS CELL_ITEM_ID,
                    A.CHILD_ITEM_ID AS ELEC_ITEM_ID,
                    MIN(ACCUMULATED_CHILD_QTY) AS BOM_QTY,
                    1.0/MIN(ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,  -- ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 
                    ROW_NUMBER() OVER(PARTITION BY  SUB.DIVISION_ID,A.CHILD_ITEM_ID ORDER BY  SUB.DIVISION_ID,A.CHILD_ITEM_ID,MIN(ACCUMULATED_CHILD_QTY) asc) AS No
               FROM (SELECT DISTINCT x.ORIGIN_DIVISION_ID AS DIVISION_ID
                                   , IIF(ISNULL(m.ITEM_ID_PROD, '') = '', x.ITEM_ID, m.ITEM_ID_PROD) AS ITEM_ID
                       FROM dbo.SCP_PLN_ELEC_DEMAND_CELL_PLAN X WITH(NOLOCK)
					        -- 20230602 PJ20230691 활성화 대응
                            LEFT JOIN (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
                                       FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
									      INNER JOIN scp_mst_final_item f WITH(NOLOCK)
										  ON  c.division_id  = f.division_id
										  AND c.item_id_prod = f.item_id
										  AND f.ATTRIBUTE8   = 'CP'
                                       WHERE  c.cell_type = 'CA1' -- Cell 생산 계획
                                       AND    c.valid_yn  = 'Y'   -- 20230726 PJ20230692 : Valid_yn = 'Y' 조건 추가
                                       GROUP BY c.division_id, c.item_id_assy
                                      ) M
                            ON  x.ORIGIN_DIVISION_ID = m.DIVISION_ID
                            AND x.ITEM_ID            = m.ITEM_ID_ASSY
                     WHERE x.PLAN_START_YYYYMMDD >= DBO.FN_GET_BUCKET_YYYYMMDD(-1)
                     ) AS SUB
                     INNER HASH JOIN dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A WITH(NOLOCK) -- 20250901 운영 속도 이슈로 변경
					 ON		A.MODEL_ID            = SUB.ITEM_ID  -- 20250901 운영 속도 이슈로 변경
					 AND	A.DIVISION_ID         = SUB.DIVISION_ID  -- 20250901 운영 속도 이슈로 변경
              WHERE 1 = 1  -- 20250901 운영 속도 이슈로 변경
                AND a.OPERATION_GROUP_ID  = 'E'
--              AND A.CHILD_ITEM_ID       = 'APCAN1120A'
            GROUP BY SUB.DIVISION_ID, SUB.ITEM_ID, A.CHILD_ITEM_ID
            HAVING MIN(ACCUMULATED_CHILD_QTY) > 0
            ) Y
		/* -- 전체 Cell 모델 대상 : 가끔 수작업으로 Update 처리할 것
          (
             SELECT a.DIVISION_ID, A.MODEL_ID AS CELL_ITEM_ID,
                    A.CHILD_ITEM_ID AS ELEC_ITEM_ID,
                    MIN(ACCUMULATED_CHILD_QTY) AS BOM_QTY,
                    1.0/MIN(ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,  -- ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 
                    ROW_NUMBER() OVER(PARTITION BY  a.DIVISION_ID,A.CHILD_ITEM_ID ORDER BY  a.DIVISION_ID,A.CHILD_ITEM_ID,MIN(ACCUMULATED_CHILD_QTY) asc) AS No
               FROM dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A
              WHERE 1=1
                AND a.OPERATION_GROUP_ID  = 'E'
            GROUP BY a.DIVISION_ID, A.MODEL_ID, A.CHILD_ITEM_ID
            HAVING MIN(ACCUMULATED_CHILD_QTY) > 0
            ) Y
			*/
          ON 0 = 0
          AND X.DIVISION_ID = Y.DIVISION_ID
          AND X.ITEM_ID     = Y.ELEC_ITEM_ID
          AND Y.No          = 1 
        WHERE  X.OPERATION_GROUP_ID = 'E'
        -- 20190930 전극 대표 Cell 처리 : CELL_ITEM_ID가 NULL 인 경우만 처리
	    AND   (X.CELL_ITEM_ID IS NULL OR X.CELL_ITEM_ID = '')
            ;     

        ----------------------------------------------------------- 
        -- 당주이후 미래구간 수요가 존재하는 ITEM에 대하여,
        -- BOM존재하는 팩,셀,전극 ITEM에 수요존재='Y',최소납기일자 기록.
        --  : TACT TIME미존재 체크화면이나 메일링시 수요존재하는 경우만 반영
        -----------------------------------------------------------

        UPDATE SCP_MST_FINAL_ITEM
           SET FCST_YN = NULL,
               MIN_DUE_DATE = NULL
         WHERE 1=1;

        WITH SUB AS
        (
                        SELECT /* aa.division_id		                          
                                , aa.project_code
                                , aa.scm_site_id
                                , aa.item_id                
                                , aa.yyyymmdd
                                , aa.qty
                                , aa.measure             
                              */
                                aa.division_id	
                              , ISNULL(gr2.item_id, aa.item_id) AS item_id
                              , MIN( aa.yyyymmdd )              AS min_yyyymmdd                       
                        FROM   (SELECT *
						        FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
							    WHERE  1=1 --aa.division_id     = '40'
		                        -- 20210528 PJ20209642 : FCST 확인 구간
                                AND    aa.yyyymmdd >= @v_plan_date     -- CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                                AND    aa.yyyymmdd <= @v_plan_end_date -- CONVERT(CHAR(8), DATEADD(DD, @n_period, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                                AND    aa.measure  IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')
                                AND    aa.qty      >  0
							   ) aa
                       
                               -- 20180716 추가 VMI 대상 site 조회
                                INNER JOIN ( 
                                            SELECT division_id, scm_site_id, vmi_yn, operation_group
                                            FROM   scm_mst_site  WITH (NOLOCK)
                                            WHERE  1=1 --division_id = '40' 
                                            AND    valid_yn    = 'Y'
                                           -- AND    vmi_yn      = 'Y'
                                           ) mse
                                ON   aa.division_id = mse.division_id
                                AND  aa.scm_site_id = mse.scm_site_id 
                       
                               -- 20240615 PJ20244573 동일 GROUP Item 추가
                                LEFT JOIN ( 
                                            SELECT division_id, project_code, item_id, group_id
                                            FROM   SCP_MST_ITEM_GROUP_DETAIL  WITH (NOLOCK)
                                            WHERE  1=1 --division_id = '40' 
                                            AND    valid_yn    = 'Y'
                                            AND    ISNULL(group_id, '') <> ''
                                           ) gr
                                ON   aa.division_id  = gr.division_id
                                AND  aa.project_code = gr.project_code 
                                AND  aa.item_id      = gr.item_id 
                       
                               -- 20240615 PJ20244573 동일 GROUP Item 추가
                                LEFT JOIN ( 
                                            SELECT division_id, project_code, item_id, group_id
                                            FROM   SCP_MST_ITEM_GROUP_DETAIL  WITH (NOLOCK)
                                            WHERE  1=1 --division_id = '40' 
                                            AND    valid_yn    = 'Y'
                                            AND    ISNULL(group_id, '') <> ''
                                           ) gr2
                                ON   gr.division_id  = gr2.division_id
                                AND  gr.group_id     = gr2.group_id 

                        WHERE  1=1 --aa.division_id     = '40'
				                
                        /* PJ20214907 */
					    --20221115 PJ20216994  MKT FCST 조건 변경
                        -- vmi = 'Y' 이면 'MKT_FCST' 대신 'VMI_In_Req' Measure 사용하도록 처리
						AND   aa.measure = CASE WHEN ISNULL(mse.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(aa.attribute10, '') = '' THEN 'MKT_FCST' END
			  			
                        group by aa.division_id	
                               , ISNULL(gr2.item_id, aa.item_id)
        )
        UPDATE T
           SET FCST_YN      = 'Y',
               MIN_DUE_DATE = CONVERT(DATETIME,XX.MIN_YYYYMMDD,112)
        --SELECT XX.*
          FROM 
               ( SELECT B.DIVISION_ID,B.CHILD_ITEM_ID,MIN(X.MIN_YYYYMMDD) AS MIN_YYYYMMDD
                   FROM SUB X
                       ,DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                  WHERE X.DIVISION_ID  = B.DIVISION_ID
                    AND X.ITEM_ID      = B.MODEL_ID
                 GROUP BY B.DIVISION_ID,B.CHILD_ITEM_ID   
                 ) XX,
                 SCP_MST_FINAL_ITEM T WITH(NOLOCK)
         WHERE 1=1
           AND XX.DIVISION_ID   = T.DIVISION_ID
           AND XX.CHILD_ITEM_ID = T.ITEM_ID
       ;

        -------------------------------------------------------------------
        -- PACK(MODULE포함) 모델,TCO모델,셀 모델에 대하여, BOM 하위에 존재하는 CELL LIST를 콤마로 구분하여
        -- ATTRIBUTE1에 셋팅하여 GLOBAL PSI 화면에서 조회조건으로 활용
		-- 20230602 PJ20230691 활성화 대응 : 1. TCO(CP) / CP : 자신으로 처리
		--                                   2. CP 중 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
		--                                   3-1. CA1/CA2 : CP 로 처리
		--                                   3-2. CA1/CA2 : 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
		--                                   4-1. Pack : CP 로 처리
		--                                   4-2. Pack : TCO(CP) 가 있는 경우 TCO(CP) 로 처리
        -------------------------------------------------------------------
        -- 1. TCO(CP) / CP : 자신으로 처리
              UPDATE X
                 SET ATTRIBUTE1 = ITEM_ID
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'A'
                 --AND X.TCO_CELL_YN     = 'Y'
                 AND X.ATTRIBUTE8     IN ('CP')
                 ;        
		
        -- 2. CP 중 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
              UPDATE X
                 SET ATTRIBUTE1 = ISNULL(
                                   (
                                    SELECT TOP 1 B.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = O.DIVISION_ID
                                       AND B.MODEL_ID           = O.ITEM_ID
                                       AND B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = X.ITEM_ID 
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'Y'    
                                       AND O.CELL_TYPE          = 'CP'
                                   ), ATTRIBUTE1)
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'A'
                 AND X.TCO_CELL_YN     = 'N'
                 AND X.ATTRIBUTE8     IN ('CP')
                 ; 		
		
        -- 3-1. CA1/CA2 : CP 로 처리
              UPDATE X
                 SET ATTRIBUTE1 = ISNULL(
                                   (
                                    SELECT TOP 1 B.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = O.DIVISION_ID
                                       AND B.MODEL_ID           = O.ITEM_ID
                                       AND B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = X.ITEM_ID 
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'N'    
                                       AND O.CELL_TYPE          = 'CP'
                                   ), ATTRIBUTE1)
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'A'
                 --AND X.TCO_CELL_YN     = 'N'
                 AND X.ATTRIBUTE8     IN ('CA1', 'CA2')
                 ; 	
		
        -- 3-2. CA1/CA2 : 상위 TCO(CP) 가 있는 경우 상위 TCO(CP) 로 처리
              UPDATE X
                 SET ATTRIBUTE1 = ISNULL(
                                   (
                                    SELECT TOP 1 B.MODEL_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = O.DIVISION_ID
                                       AND B.MODEL_ID           = O.ITEM_ID
                                       AND B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = X.ITEM_ID 
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'Y'    
                                       AND O.CELL_TYPE          = 'CP'
                                   ), ATTRIBUTE1)
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1
                 AND X.OPERATION_GROUP = 'A'
                 --AND X.TCO_CELL_YN     = 'N'
                 AND X.ATTRIBUTE8     IN ('CA1', 'CA2')
                 ; 	
		
        -- 4-1. Pack : CP 로 처리
	/* -- ymh 운영 속도 이슈로 주석처리 20250903
              UPDATE X
                 SET ATTRIBUTE1 = ISNULL(
                                   (
                                    SELECT TOP 1 B.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.MODEL_ID           = X.ITEM_ID 
                                       AND B.DIVISION_ID        = o.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = o.item_id  
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'N'    
                                       AND O.CELL_TYPE         IN ('CP')
                                   ), ATTRIBUTE1)
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1 
                 AND X.OPERATION_GROUP = 'P' 
                 ;      
	*/
	/*운영 속도이슈로 ymh 로직 변경 시작 */
	UPDATE X
		SET ATTRIBUTE1 =ISNULL(B.CHILD_ITEM_ID,ATTRIBUTE1)
	FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)

		INNER HASH JOIN 
				(
				SELECT   B.DIVISION_ID ,  B.CHILD_ITEM_ID , MODEL_ID
					FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
					, SCM_MST_FINAL_ITEM_V O WITH(NOLOCK)
					WHERE 1 = 1
					AND B.DIVISION_ID        = O.DIVISION_ID
					AND B.CHILD_ITEM_ID      = O.ITEM_ID  
					AND O.OPERATION_GROUP_ID = 'A'
					AND O.TCO_CELL_YN        = 'N'    
					AND O.CELL_TYPE         IN ('CP')
				) AS B
		ON B.DIVISION_ID        = X.DIVISION_ID
		AND B.MODEL_ID           = X.ITEM_ID
	WHERE 1=1 
	AND X.OPERATION_GROUP = 'P'
	/*운영 속도이슈로 ymh 로직 변경 끝 */

        -- 4-2. Pack : TCO(CP) 가 있는 경우 TCO(CP) 로 처리
		/* -- ymh 운영 속도 이슈로 주석처리 20250903
              UPDATE X
                 SET ATTRIBUTE1 =ISNULL(
                                    (
                                    SELECT TOP 1 B.CHILD_ITEM_ID
                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
                                         , scm_mst_final_item_v o WITH(NOLOCK)
                                     WHERE B.DIVISION_ID        = X.DIVISION_ID
                                       AND B.MODEL_ID           = X.ITEM_ID
                                       AND B.DIVISION_ID        = o.DIVISION_ID
                                       AND B.CHILD_ITEM_ID      = o.item_id  
                                       AND O.OPERATION_GROUP_ID = 'A'
                                       AND O.TCO_CELL_YN        = 'Y'    
                                       AND O.CELL_TYPE         IN ('CP')
                                   ), ATTRIBUTE1)
              --SELECT *
                FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
               WHERE 1=1 
                 AND X.OPERATION_GROUP = 'P' 
                 ;  
		*/ 
		/*운영 속도이슈로 ymh 로직 변경 시작 */
		update x
			SET ATTRIBUTE1 =ISNULL(b.CHILD_ITEM_ID,ATTRIBUTE1)
		from SCP_MST_FINAL_ITEM X WITH(NOLOCK)

			inner hash join 
					(
					SELECT  b.DIVISION_ID ,  B.CHILD_ITEM_ID , MODEL_ID
						FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
						, scm_mst_final_item_v o WITH(NOLOCK)
						WHERE 1 = 1
						AND B.DIVISION_ID        = o.DIVISION_ID
						AND B.CHILD_ITEM_ID      = o.item_id  
						AND O.OPERATION_GROUP_ID = 'A'
						AND O.TCO_CELL_YN        = 'Y'    
						AND O.CELL_TYPE         IN ('CP')
					) as b
			on B.DIVISION_ID        = X.DIVISION_ID
			AND B.MODEL_ID           = X.ITEM_ID
		WHERE 1=1 
		AND X.OPERATION_GROUP = 'P'
		/*운영 속도이슈로 ymh 로직 변경 끝 */

        /* PJ20214997 */
        -- 2.1) MEB Item은 BOM에서 하위에 나오는 셀을 셋팅
              ;WITH sub AS
              (
               SELECT B.MODEL_ID, A.ITEM_ID, A.FLOW_ID
                 FROM dbo.SCP_MST_FINAL_ITEM A WITH (NOLOCK)
                 LEFT JOIN dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                   ON A.ITEM_ID = B.CHILD_ITEM_ID
                WHERE 1 = 1
                  AND A.FLOW_ID = 'P5200'
                  AND B.MODEL_ID IS NOT NULL
              ),
              sub1 AS
              (
               SELECT A.*, B.ATTRIBUTE1
                 FROM sub A
                INNER JOIN dbo.SCP_MST_FINAL_ITEM B WITH(NOLOCK)
                   ON A.MODEL_ID = B.ITEM_ID
              )
			  UPDATE X
			     SET ATTRIBUTE1 = A.ATTRIBUTE1
                FROM sub1 A
               INNER JOIN dbo.SCP_MST_FINAL_ITEM X WITH(NOLOCK)
                  ON A.ITEM_ID = X.ITEM_ID
                 AND A.FLOW_ID = 'P5200';

---------------START2 : KSG--------------------------------------------------------------------------------
  /*      
        -- 3) PACK중에서 BOM하위에 다종의 셀이 들어가는 경우 콤마로 구분하여 셋팅
               UPDATE F
                  SET ATTRIBUTE1 =  (
                                        SELECT MAX(CELL_LIST)
                                        FROM
                                             (
                                               SELECT S.DIVISION_ID,
                                                      S.MODEL_ID,
                                                      STUFF(( SELECT ','+CHILD_ITEM_ID
                                                                FROM (
                                                                       SELECT  DISTINCT V.DIVISION_ID, V.MODEL_ID, V.CHILD_ITEM_ID
                                                                         FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH(NOLOCK)
                                                                            , scm_mst_final_item_origin_div_v o WITH(NOLOCK)
                                                                        WHERE 1=1
                                                                          AND V.DIVISION_ID        = o.DIVISION_ID
                                                                          AND V.CHILD_ITEM_ID      = o.item_id  
                                                                          AND V.DIVISION_ID        = S.DIVISION_ID --'40'
                                                                          AND V.MODEL_ID           = S.MODEL_ID    --'MPMHPPBUFF1C'
                                                                          AND V.OPERATION_GROUP_ID = 'A'
                                                                          AND V.TCO_CELL_YN        = 'N'
                                                                          AND V.CELL_TYPE         IN ('CP', 'CA2')
                                                                      ) X
                                                               WHERE 1=1
                                                                 AND X.DIVISION_ID = S.DIVISION_ID
                                                                 AND X.MODEL_ID    = S.MODEL_ID
                                                                 AND X.CHILD_ITEM_ID <= S.CHILD_ITEM_ID
                                                               ORDER BY X.CHILD_ITEM_ID
                                                                 FOR XML PATH('')
                                                             ),1,1,'') CELL_LIST             
                                                 FROM (
                                                        SELECT  DISTINCT V.DIVISION_ID, V.MODEL_ID, V.CHILD_ITEM_ID
                                                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH(NOLOCK)
                                                             , scm_mst_final_item_origin_div_v o WITH(NOLOCK)
                                                         WHERE 1=1
                                                           AND V.DIVISION_ID        = o.DIVISION_ID
                                                           AND V.CHILD_ITEM_ID      = o.item_id  
                                                           AND V.division_id        = F.DIVISION_ID --'40'
                                                           AND V.MODEL_ID           = F.ITEM_ID     --'MPMHPPBUFF1C'
                                                           AND V.OPERATION_GROUP_ID ='A'
                                                           AND V.TCO_CELL_YN        ='N'
                                                           AND V.CELL_TYPE         IN ('CP', 'CA2')
                                                       ) S
                                                WHERE 1=1
                                              ) Z   
                  
  )	         
               --SELECT F.*
                 FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK),
                      (
      SELECT DIVISION_ID, PLANT_ID,MODEL_ID,COUNT(1) AS CNT
                         FROM
                             (
                               SELECT DISTINCT V.DIVISION_ID, V.PLANT_ID, V.MODEL_ID, V.CHILD_ITEM_ID
                                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH(NOLOCK)
                                    , scm_mst_final_item_origin_div_v o WITH(NOLOCK)
                                WHERE V.DIVISION_ID        = '40'
                                 --  AND MODEL_ID='MPCHPPPEIN1C'
                                  AND V.OPERATION_GROUP_ID = 'A'
                                  AND V.TCO_CELL_YN        = 'N'
                                  AND V.CELL_TYPE         IN ('CP', 'CA2')
                                  AND V.DIVISION_ID        = o.DIVISION_ID
                                  AND V.CHILD_ITEM_ID      = o.item_id  
                              ) X
                         GROUP BY DIVISION_ID, PLANT_ID,MODEL_ID
                         HAVING COUNT(1) > 1
                       ) P
                WHERE 1=1
                  AND F.DIVISION_ID   = '40'
                  AND F.DIVISION_ID   = P.DIVISION_ID
                  AND F.ITEM_ID       = P.MODEL_ID  
                  AND EXISTS (
                               SELECT 'X'
                                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V XXX WITH(NOLOCK)
                                WHERE XXX.DIVISION_ID        = F.DIVISION_ID
                                  AND XXX.MODEL_ID           = F.ITEM_ID
                              )
                  ;
		*/		  
-----------------END 2: KSG------------------------------------------------------------------------------
        ----------------------------------------------------------- 
        -- 소형 셀,팩 ITEM에 대하여 원/각/파우치구분칼럼반영 (CELL_TYPE_GROUP_CODE)
        --   20220920 PJ20216994 : 소형 P5000 Cell Type Group 처리 추가
        --   20231102 E20231026-001169 4680/4695 [Cell Type Gr] 지정 : 'M’인 경우 Cell은‘C, pack은 ‘P’처리
        -----------------------------------------------------------
        UPDATE SCP_MST_FINAL_ITEM
           SET CELL_TYPE_GROUP_CODE = ( CASE SUBSTRING(FLOW_ID,1,5) WHEN 'P5000' THEN
                                                                                     ( CASE WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'R' THEN 'R'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'B' THEN 'C'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'C' THEN 'C'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'S' THEN 'C'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'P' THEN 'P'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'F' THEN 'P'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'N' THEN 'P'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'E' THEN 'P'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'M' AND OPERATION_GROUP = 'A' THEN 'C'
                                                                                            WHEN SUBSTRING(ATTRIBUTE1,3,1) = 'M' AND OPERATION_GROUP = 'P' THEN 'P'
                                                                                            ELSE ''
                                                                                       END
                                                                                     )
                                                                    ELSE 
                                                                        ( CASE WHEN SUBSTRING(ITEM_ID,3,1) = 'R' THEN 'R'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'B' THEN 'C'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'C' THEN 'C'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'S' THEN 'C'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'P' THEN 'P'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'F' THEN 'P'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'N' THEN 'P'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'E' THEN 'P'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'M' AND OPERATION_GROUP = 'A' THEN 'C'
                                                                               WHEN SUBSTRING(ITEM_ID,3,1) = 'M' AND OPERATION_GROUP = 'P' THEN 'P'
                                                                               ELSE ''
                                                                           END
									                                    )
                                        END )
            ,  LAST_UPDATE_DATE     = GETDATE()                                                     
         WHERE 1=1
           AND DIVISION_ID     = '40'       --소형
           AND OPERATION_GROUP IN ('A','P') --CELL,PACK
           ;
       
        /*----------------------------------------------------------- 
        -- 셀환산자 : CELL_CF / CONVERT_QTY_CELL 적용
        -- 20230323 : 자동차만 해당하며 셀환산자 업데이트 => DM에서 CELL_CF 활용
        -- 20231211 : E20231204-000282 우선 순위 역순으로 구현하여 Update 되도록 처리
		  - CELL_CF/CONVERT_QTY_CELL 
		   1) CELL_CF/CONVERT_QTY_CELL : GPLM
		   2) CELL_CF/CONVERT_QTY_CELL :  => 5) 에서 처리??
		   3) CELL ITEM ID 확인(적용모델찾기) : 위에서 처리된 상태임
		   4) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준
		   5) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인
		   6) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정
		   7) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]]
        */-----------------------------------------------------------        

        /*
            E20260313-002032 SCP 전극 Cell환산기준 변경 으로 인해 로직 변경. (로직순서)
            1) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정                              
            2) CONVERT_QTY_CELL : FP 정보 적용모델기준 반영 [SCM_ITEM_CONV_CALC_M]] * UNIT EA 제외
            3) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준 (*전극 환산자값이 없을때추가.)
            4) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인 (*전극 환산자값이 없을때추가.)
            5) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]] (*전극 환산자값이 없을때가.)
            6) CELL_CF/CONVERT_QTY_CELL : GPLM 값 있으면 최종 적용                                           

            * 1순위 GPLM 데이터 값이 있으면 해당 값 적용.
            * 2순위 FP 환산자 적용모델 기준 적용.
            * 1,2순위 적용시 세팅된 환산자 값 없을때
            * FP Conversion 정보 -> BOM 기준 MIN -> FP 적용모델 없이 MAX환산자적용 


        */

		-----------------------------------------------------------
        -- 7) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]]
        -- 20200218 [C20200207-000240] 전극 -> Cell 환산자 정보 없는 경우 FP 로직으로 추가
		-----------------------------------------------------------
        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 제거
        /*
        UPDATE SCP_MST_FINAL_ITEM
        SET    convert_qty_cell = (SELECT MAX(ic.value)
                                   FROM   SCM_MST_ITEM_CONV_CALC_SN ic WITH(NOLOCK)
                                   WHERE  ic.item_id      = a.item_id
                                   --AND    ic.company_id   = 'G480'
                                   AND    ic.max_ver_flag = 'Y'
                                   AND    ic.category     = 'Pancake (cell/m)'
                                   AND    ic.operation    = 'E2000' 
                                  )
 	    FROM   SCP_MST_FINAL_ITEM a WITH(NOLOCK)
		WHERE  1=1
		AND    ISNULL(convert_qty_cell, -99) = -99
		;
        */
		
        -- E20260313-002032 전극 Cell환산기준 변경 으로 인해 로직 변경 - 로직순서 변경.
		-----------------------------------------------------------
        -- 1) CONVERT_QTY_CELL : SCP_MST_ITEM_CELL_CF 의 UNIT 이 ‘EA’ 이면 1 설정
		-----------------------------------------------------------
		UPDATE A
		   SET A.CONVERT_QTY_CELL = 1
		  FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
		 WHERE ITEM_ID IN  (SELECT DISTINCT ITEM_ID FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)	WHERE UNIT = 'EA')
		 
		-----------------------------------------------------------
        -- 5) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인
        -- 칼럼추가(CELL_ITEM_ID) 후 UPDATE문 반영 PJ20230691 활성화 대응 : 최종 Cell Prod 로 처리
        -----------------------------------------------------------
        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 제거
        /*
        UPDATE X
		   SET X.CELL_CF          = Y.CONVERT_QTY_CELL
             , X.CONVERT_QTY_CELL = Y.CONVERT_QTY_CELL
         FROM SCP_MST_FINAL_ITEM X
          INNER JOIN 
		  -- 전체 Cell 모델 대상
          (
             SELECT a.DIVISION_ID, A.MODEL_ID AS CELL_ITEM_ID,
                    A.CHILD_ITEM_ID AS ELEC_ITEM_ID,
                    MIN(ACCUMULATED_CHILD_QTY) AS BOM_QTY,
                    1.0/MIN(ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,  -- ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 
                    ROW_NUMBER() OVER(PARTITION BY  a.DIVISION_ID,A.CHILD_ITEM_ID ORDER BY  a.DIVISION_ID,A.CHILD_ITEM_ID,MIN(ACCUMULATED_CHILD_QTY) asc) AS No
               FROM dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A
              WHERE 1=1
                AND a.OPERATION_GROUP_ID  = 'E'
            GROUP BY a.DIVISION_ID, A.MODEL_ID, A.CHILD_ITEM_ID
            HAVING MIN(ACCUMULATED_CHILD_QTY) > 0
            ) Y
          ON 0 = 0
          AND X.DIVISION_ID = Y.DIVISION_ID
          AND X.ITEM_ID     = Y.ELEC_ITEM_ID
          AND Y.No          = 1 
        WHERE X.OPERATION_GROUP_ID = 'E'
          AND ISNULL(Y.CONVERT_QTY_CELL, -99) <> -99
        ;     
        */
			
		-----------------------------------------------------------
        -- 4) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준
		-----------------------------------------------------------        
        -- -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 추가 로 해당 로직 제거.
          --UPDATE SCP_MST_FINAL_ITEM
          --SET    CELL_CF          = ISNULL((1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, @d_plan_date)), CELL_CF) -- 20231211 : E20231204-000282  -- 20190930 Cell 환산자 처리
          --     , CONVERT_QTY_CELL = ISNULL((1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, @d_plan_date)), CONVERT_QTY_CELL)
          --WHERE 1=1

    --    WITH XX AS
    --    (
    --    SELECT  I.DIVISION_ID,
    --            I.ITEM_ID,
    --            MAX(I.NICK_NAME)  AS NICK_NAME,
    --            MAX(I.ITEM_CLASS) AS ITEM_CLASS,
				---- 20190930 전극 대표 Cell 처리 수정 : FP Item Master의 APPLIED_MODEL 컬럼  CELL_ITEM_ID
    --            CASE WHEN MAX(I.SCP_OPERATION_GROUP) = 'E' THEN MAX(I.APPLIED_MODEL) 
				--     ELSE NULL
				--END AS CELL_ITEM_ID,
    --            MAX(CASE WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID ELSE FLOW_ID END) AS FLOW_ID,
    --            MAX(I.SCP_OPERATION_GROUP)    AS OPERATION_GROUP,
    --            MAX(I.SCP_OPERATION_GROUP_ID) AS OPERATION_GROUP_ID,
    --            MAX(FI.ELECTRODE_TYPE)        AS ELECTRODE_TYPE,
				--MAX(ISNULL(FI.RACK_YN, 'N'))   AS ATTRIBUTE3,
				--MAX(ISNULL(FI.DC_YN, 'N'))     AS ATTRIBUTE4, -- 20220110 DC Item 구분
				--MAX(ISNULL(FI.IS_YN, 'N'))     AS ATTRIBUTE5, -- 20220602 PJ20216891 ISUZU Item 구분
				--MAX(ISNULL(FI.CELL_TYPE, ''))  AS ATTRIBUTE8  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
    --      FROM  SCM_MST_ITEM_SN       I WITH(NOLOCK)
    --           ,SCM_MST_FINAL_ITEM_ORIGIN_DIV_V  FI WITH(NOLOCK)
    --     WHERE I.DIVISION_ID = FI.DIVISION_ID
    --       AND I.ITEM_ID     = FI.ITEM_ID
    --       AND I.ACTIVE_FLAG = 'Y'
    --       AND I.SCP_OPERATION_GROUP IS NOT NULL
    --     GROUP BY I.DIVISION_ID, 
    --              I.ITEM_ID           
    --    )
    --      UPDATE SCP_MST_FINAL_ITEM
    --      SET    CELL_CF          = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date)) -- 20231211 : E20231204-000282  -- 20190930 Cell 환산자 처리
    --           , CONVERT_QTY_CELL = (1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', XX.CELL_ITEM_ID, XX.ITEM_ID, @d_plan_date))
    --        FROM XX,
    --             SCP_MST_FINAL_ITEM AA WITH(NOLOCK)
    --       WHERE 1=1
    --         AND XX.DIVISION_ID = AA.DIVISION_ID
    --         AND XX.ITEM_ID     = AA.ITEM_ID
           ; 
			
        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 추가.
        -- CONVERT_QTY_CELL : FP 정보 적용모델기준 반영 [SCM_ITEM_CONV_CALC_M]] + UNIT 'EA' 제외.
        UPDATE SCP_MST_FINAL_ITEM
            SET    convert_qty_cell = (SELECT MAX(ic.value)
                                       FROM   SCM_MST_ITEM_CONV_CALC_SN ic WITH(NOLOCK)
                                       WHERE  ic.item_id        = a.ITEM_ID
                                       --AND    ic.company_id   = 'G480'
                                       and    ic.model_id       = a.CELL_ITEM_ID
                                       AND    ic.max_ver_flag   = 'Y'
                                       AND    ic.category       = 'Pancake (cell/m)'
                                       AND    ic.operation      = 'E2000' 
                                    )
 	    FROM   SCP_MST_FINAL_ITEM a WITH(NOLOCK)
		WHERE  1=1
        AND A.ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)	WHERE UNIT = 'EA')
		;

        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직으로 
        -- *** 적용된 환산자값이 없을때만 반영
		-----------------------------------------------------------
        -- 4) CELL_CF/CONVERT_QTY_CELL : FP Conversion 정보 사용 : CELL_ITEM_ID와 ITEM_ID 기준
		-----------------------------------------------------------        
          UPDATE SCP_MST_FINAL_ITEM
          SET    CELL_CF          = ISNULL((1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, @d_plan_date)), CELL_CF) -- 20231211 : E20231204-000282  -- 20190930 Cell 환산자 처리
               , CONVERT_QTY_CELL = ISNULL((1.0 / DBO.FN_GET_REQ_QTY_MODEL_FOR_SCP_SN('', CELL_ITEM_ID, ITEM_ID, @d_plan_date)), CONVERT_QTY_CELL)
          WHERE 1=1
          AND ISNULL(CONVERT_QTY_CELL, -99) = -99 -- E20260313-002032 적용된 환산자 값이 없을때만 반영.


        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직으로 
        -- *** 적용된 환산자값이 없을때만 반영
		-----------------------------------------------------------
        -- 3) CELL_CF/CONVERT_QTY_CELL : 전극 모델 대상 BOM 소요량 확인
        -- 칼럼추가(CELL_ITEM_ID) 후 UPDATE문 반영 PJ20230691 활성화 대응 : 최종 Cell Prod 로 처리
        -----------------------------------------------------------
        UPDATE X
		   SET X.CELL_CF          = Y.CONVERT_QTY_CELL
             , X.CONVERT_QTY_CELL = Y.CONVERT_QTY_CELL
         FROM SCP_MST_FINAL_ITEM X
          INNER JOIN 
		  -- 전체 Cell 모델 대상
          (
             SELECT a.DIVISION_ID, A.MODEL_ID AS CELL_ITEM_ID,
                    A.CHILD_ITEM_ID AS ELEC_ITEM_ID,
                    MIN(ACCUMULATED_CHILD_QTY) AS BOM_QTY,
                    1.0/MIN(ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,  -- ACCUMULATED_CHILD_QTY가 0일 경우는 오류처리는 ?  --> 0 ? 1 
                    ROW_NUMBER() OVER(PARTITION BY  a.DIVISION_ID,A.CHILD_ITEM_ID ORDER BY  a.DIVISION_ID,A.CHILD_ITEM_ID,MIN(ACCUMULATED_CHILD_QTY) asc) AS No
               FROM dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V1 A
              WHERE 1=1
                AND a.OPERATION_GROUP_ID  = 'E'
            GROUP BY a.DIVISION_ID, A.MODEL_ID, A.CHILD_ITEM_ID
            HAVING MIN(ACCUMULATED_CHILD_QTY) > 0
            ) Y
          ON 0 = 0
          AND X.DIVISION_ID = Y.DIVISION_ID
          AND X.ITEM_ID     = Y.ELEC_ITEM_ID
          AND Y.No          = 1 
        WHERE X.OPERATION_GROUP_ID = 'E'
          AND ISNULL(X.CONVERT_QTY_CELL, -99) = -99 -- E20260313-002032 적용된 환산자 값이 없을때만 반영.
        ;     



        -- E20260313-002032 SCP 전극 Cell환산기준 변경요청 로직개선으로 해당 로직 제거
		-----------------------------------------------------------
        -- 4) CONVERT_QTY_CELL : FP 정보 최종 확인 [SCM_ITEM_CONV_CALC_M]]
        -- 20200218 [C20200207-000240] 전극 -> Cell 환산자 정보 없는 경우 FP 로직으로 추가
        -- **** 위 로직 모두 반영하고 환산자값이 없을때 반영.
		-----------------------------------------------------------
        UPDATE SCP_MST_FINAL_ITEM
        SET    convert_qty_cell = (SELECT MAX(ic.value)
                                   FROM   SCM_MST_ITEM_CONV_CALC_SN ic WITH(NOLOCK)
                                   WHERE  ic.item_id      = a.item_id
                                   --AND    ic.company_id   = 'G480'
                                   AND    ic.max_ver_flag = 'Y'
                                   AND    ic.category     = 'Pancake (cell/m)'
                                   AND    ic.operation    = 'E2000' 
                                  )
 	    FROM   SCP_MST_FINAL_ITEM a WITH(NOLOCK)
		WHERE  1=1
		AND    ISNULL(convert_qty_cell, -99) = -99
		;			
		-----------------------------------------------------------
        -- 5) CELL_CF / CONVERT_QTY_CELL : GPLM
		-----------------------------------------------------------
		;WITH W_CELL_CF AS
		(
		   SELECT DISTINCT TARGET_CELL
				, ITEM_ID
				, CELL_CF
				, ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RANKNO
			 FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)	
            WHERE ISNULL(CELL_CF, '') <> ''
		 )

		UPDATE A
		   SET A.CELL_CF          = B.CELL_CF
             , A.CONVERT_QTY_CELL = B.CELL_CF
		  FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
		  INNER JOIN (
		  				SELECT A.ITEM_ID
				     		 , A.CELL_CF
				  		  FROM W_CELL_CF A 
						 WHERE A.RANKNO = 1
						 ) B ON A.ITEM_ID = B.ITEM_ID  
         WHERE 1=1
						 
		-----------------------------------------------------------
        -- 20231123 E20231120-000042 : 평가감 모델의 CELL_CF/CONVERT_QTY_CELL Update
		-----------------------------------------------------------
        UPDATE F 
		   SET F.CELL_CF          = B.CELL_CF
             , F.CONVERT_QTY_CELL = B.CELL_CF
          FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK)
          INNER JOIN (SELECT DIVISION_ID, ITEM_ID, CELL_CF
                           , CASE WHEN RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  THEN SUBSTRING(A.ITEM_ID, 1, LEN(A.ITEM_ID) - 2)
                                  WHEN RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK')                                                   THEN SUBSTRING(A.ITEM_ID, 1, LEN(A.ITEM_ID) - 3)
                             END AS BASIC_ITEM_ID
                      FROM  SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                      WHERE   1=1
                      AND (RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R') OR
                           RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK'))
                     ) A 
               ON  F.DIVISION_ID = A.DIVISION_ID
               AND F.ITEM_ID     = A.ITEM_ID

          LEFT JOIN (SELECT  *
                     FROM    SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
                     WHERE   ISNULL(CELL_CF, '') <> ''
                    ) B 
               ON  A.BASIC_ITEM_ID = B.ITEM_ID
         WHERE 1=1
           AND (F.CELL_CF IS NULL OR F.CONVERT_QTY_CELL IS NULL);
						 
		-----------------------------------------------------------
        -- 20241101 E20240923-000249  : 자동차 사업부 신규 item Code 등록 시 Basic Model Cell의 NickName 값으로 넣어줌
		-----------------------------------------------------------
        UPDATE A 
		   SET A.group_code1   = (CASE
	                                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
									                                   WHERE B.DIVISION_ID = A.DIVISION_ID 
																	   AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
																	                    WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL
																					   )
																	  )
	                                ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
									      WHERE B.DIVISION_ID = A.DIVISION_ID 
										  AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
										                   WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL
														  )
									     )
	                              END
                                 ) 
          FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
         WHERE 1=1
		   AND A.division_id IN (SELECT division_id FROM scm_mst_division WITH(NOLOCK) where attribute3 = '81')
           AND ISNULL(A.group_code1, '') = '';

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        --SET @n_log_count = @@ROWCOUNT;
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

