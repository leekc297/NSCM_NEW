

/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_PLAN_BOM
 * Description  : FP DB와 SCM SDB의 BOM 정보를 ODB에 적재되도록 한다.

                  1. LGCE Plant Site 엔진용 BOM 데이터 생성

                  2. 외주 Plant Site 엔진용 BOM 데이터 생성
				    : PJ20202001 : Parent가 RACK인 모델 제외
                  2-2. 외주 Plant Site 엔진용 BOM 데이터 생성 
				    : PJ20202001 : Parent가 RACK이고 Child가 Pack인 모델 추가
                                   plant_id / operation_id = plant_id + '_R1'

                  3. 소형('40') 일때 OPERATION_ID in ('F6200', 'F7000', 'F7100', 'F7200', 'F7300') 인 경우 site_id 변경( ~*** => ~002 변경)

                  * PROC ITEM 에서 BOM 정보 정리 작업 수행함

 * OutTable     : TH_ENG_PLAN_BOM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.16   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.30   KSG            외주 Packer BOM 처리 수정
 * 2018.06.18   KSG            BOM Eff Start/End 처리 수정
 * 2018.07.18   KSG            가상 Plant Site 생성 제외
 * 2018.07.24   KSW            소형('40') 일때 OPERATION_ID in ('F6200', 'F7000', 'F7100', 'F7200', 'F7300') 인 경우 site_id를  ~*** => ~002 변경
 * 2018.08.07   KSG            TCO Cell 외주 Site용 BOM 생성
 * 2018.09.11   KSG            OSP BOM : Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
 * 2018.09.12   KSW            OSP BOM : 팩item에  외주(TCO셀)셀과 일반셀 있을경우 TCO셀로만 BOM 구성으로 변경 (기존 : 외주(TCO셀)과 일반셀 모두 BOM구성되었음) (참고)주석2
 * 2018.10.24   KSW            동일 parent_item,  child_item 인데 소요량 차이로 인한 PK중복 오류방지위해서 GROUP BY 처리로 변경(FP의 SCM_BOM_M 테이블에 소요량 업데이트처리 중에 해당 PR_SCP_ENG_IN_FN_PROC_PLAN_BOM프로시저가 실행되어 오류발생함, FP업데이트 완료후에는 소요량이 동일하게 적용되어 오류발생하지 않음) (참고)주석1, 주석2
 * 2018.11.09   KSW            하드코딩 -> LOOKUP테이블로 변경(소형일때 TCO셀 관련공정('F6200', 'F7000', 'F7100', 'F7200', 'F7300') 하드코딩부분수정)  (참고)주석3
 * 2019.05.09   KSG            [전지고도화] Cell Package 하위 공정 삭제
 * 2020.11.02   KSG            [PJ20202001] LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021.11.11   KKC            [PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : DC_LINK
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------

 * 2022.06.24   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 소형(40) P5000 공정 isuzu 모델링 추가
 * 2023.02.20   KSG            PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : ESS 외주 Trust BCU Dummy BOM 추가
 * 2023.07.07   SHS			   PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리\ 사내BOM 수정
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_PLAN_BOM_0724_ORG]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_PLAN_BOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_PLAN_BOM';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME    = CONVERT(DATETIME, @p_plan_name);

    DECLARE @v_division_group    NVARCHAR(30);   ---(2022.04.04) 추가.
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.attribute4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ; 


  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		DELETE /* PR_SCP_ENG_IN_FN_PROC_PLAN_BOM */
		FROM   th_eng_plan_bom_sn 
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;
        
       -----------------------------------------------------------
        -- 1. LGCE Plant Site 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )  
        SELECT @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id

			 , a.parent_item_id  AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , c.eng_scm_site_id AS site_id
			 , a.flow_id         AS route_id
			 , a.flow_id         AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , a.bom_version_id  AS BOM_VERSION_ID
			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , CASE WHEN ISNULL(MAX(a.parent_qty), 0) = 0 THEN 1
                    WHEN MAX(a.child_qty) < 0 THEN 0
                    WHEN ROUND(MAX(a.child_qty) / MAX(a.parent_qty), 3, 0) = 0 THEN 1
                    ELSE ROUND(IIF(MAX(a.child_qty) < 0, 0, MAX(a.child_qty)) / MAX(a.parent_qty), 3, 0)  
               END               AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL              AS ALT_ID
			 , MAX(a.alt_priority)    AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR
        
		FROM   dbo.scp_eng_bomcomponents_i_sn a WITH(NOLOCK) 
            ,  ( SELECT plan_id
                      , plan_type    --20180321 plan_type 추가
                      , modeling_id
                      , seq
                      , enterprise
                      , parent_item_id
                      , company_id
                      , division_id
                      , site_id
                      , plant_id
                      , child_item_id
                      , model_id
                      , bom_version_id
                      , flow_id
                      , MAX(KEY_DATE) max_key_date                         
                 FROM  scp_eng_bomcomponents_i_sn WITH (NOLOCK)  
                 WHERE plan_id     = @p_plan_id  
                 AND   modeling_id = @p_modeling_id  
                 AND   seq         = @p_seq  
                 AND   enterprise  = @p_master_id  
                 AND   division_id = @p_division_id  
                 AND   plan_type   = @p_plan_type  --20180406 추가
                 GROUP BY plan_id
                        , plan_type     --20180321 plan_type 추가
                        , modeling_id
                        , seq
                        , enterprise
                        , parent_item_id
                        , company_id
                        , division_id
                        , site_id
                        , plant_id
                        , child_item_id
                        , model_id
                        , bom_version_id
                        , flow_id
               ) d 
			 -- 20190509 [전지고도화] Cell Package 하위 공정 삭제
			 ,(SELECT t.*
               FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK)
               WHERE  t.division_id = @p_division_id
               AND    t.valid_yn    = 'Y'
               AND    SUBSTRING(t.flow_id, 1, 1) NOT IN ('A', 'E')  -- 전극 공정 제외 / Cell Package 공정은 UNION 아래서 처리
			   UNION
			   SELECT t.*
               FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK)
               WHERE  t.division_id = @p_division_id
               AND    t.valid_yn    = 'Y'
               AND     t.operation_id IN ('A3000', 'A9000')  -- Cell Package 하위 공정은 계획 대상 아님
              ) b

			/* ,(SELECT t.*
               FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK) --20180306 view로 변경 (변경전 : FROM   dbo.scm_mst_operation_flow_sn t WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_OPERATION_FLOW_M] )
               WHERE  t.division_id = @p_division_id
               AND    t.valid_yn    = 'Y'  --20180306 수정 ( 변경전 : AND    SUBSTRING(operation_id, 1, 1) NOT IN ( 'S', 'F' ) -- SRS/활성화 공정 제외 )
               AND    SUBSTRING(t.flow_id, 1, 1) NOT IN ('E')  -- 전극 공정 제외 -- 전극 모델은 제외 : ksg 20180517
               --AND    SUBSTRING(t.flow_id, 1, 2) NOT IN ('E0', 'E1')  -- E2000 이전 공정은 제외
              ) b */

			 , dbo.scm_mst_site_eng c WITH(NOLOCK)
		WHERE  a.division_id        = @p_division_id
		AND    a.plan_id            = @p_plan_id
        AND    a.plan_type          = @p_plan_type   --20180321 plan_type 컬럼 추가로 인한 조회조건 추가
		AND    a.modeling_id        = @p_modeling_id
		AND    a.seq                = @p_seq
		AND    a.enterprise         = @p_master_id
		AND    a.flow_id            IS NOT NULL
		AND    a.flow_id           <> ''  
		AND    a.flow_id           <> '-'  
		AND    a.child_qty         >  0  
		--AND    ISNULL(a.alt_priority, 1) = 1  -- 대치 BOM 제외 BOMCOMPONENT 생성 시 처리

        AND    a.plan_id            = d.plan_id
        AND    a.plan_type          = d.plan_type     --20180321 plan_type 추가
        AND    a.modeling_id        = d.modeling_id
        AND    a.seq                = d.seq 
        AND    a.enterprise         = d.enterprise 
        AND    a.parent_item_id     = d.parent_item_id
        AND    a.company_id         = d.company_id
        AND    a.division_id        = d.division_id 
        AND    a.site_id            = d.site_id 
        AND    a.plant_id           = d.plant_id 
        AND    a.child_item_id      = d.child_item_id 
        AND    a.model_id           = d.model_id 
        AND    a.bom_version_id     = d.bom_version_id
        AND    a.flow_id            = d.flow_id 
        AND    a.key_date           = d.max_key_date 

		AND    a.company_id         = b.company_id
		AND    a.division_id        = b.division_id
		AND    a.site_id            = b.site_id
		AND    a.flow_id            = b.flow_id
		AND    c.modeling_id        = @p_modeling_id
		AND    c.plan_id            = @p_plan_id
		AND    c.plan_type          = @p_plan_type
		AND    c.plan_seq           = @p_seq
		AND    a.division_id        = c.division_id
        AND    a.plan_type          = c.plan_type          --20180321 plan_type 추가
		AND    a.plant_id           = c.plant_id
		AND    b.operation_group    = c.operation_group
        AND    c.eng_scm_site_id    LIKE '%~***' -- 가상 Plant Site 생성 제외
		
		-- 2018.06.18 Plan Name 일자에 유효한 BOM
        --AND    a.eff_start_date    <= @d_plan_name
        AND    a.eff_end_date      >  @d_plan_name
        
        -- 2022.06.24 ISUZU 대상 중 외주PACK 생산품은 제외.
        AND  NOT EXISTS (SELECT 'X'
                         FROM  (SELECT a.item_id , b.scm_site_id 
                                FROM  ( SELECT * 
                                        FROM  scm_mst_final_item_v A WITH(NOLOCK) 
                                        WHERE a.division_id  = @p_division_id
                                        AND   a.is_yn        = 'Y'   -- isuzu 대상 검색
                                        ) A 
                                INNER JOIN ( -- Pack 외주생산 item 검색 
                                        SELECT e.division_id , e.item_id , e.scm_site_id , b.eng_scm_site_id , b.operation_group 
                                        FROM  dbo.scm_mst_site_item e WITH (NOLOCK)
                                            , dbo.scm_mst_site_eng  b WITH(NOLOCK)
                                        WHERE 1=1
                                        AND    e.division_id        = @p_division_id
                                        AND    b.modeling_id        = @p_modeling_id
                                        AND    b.plan_id            = @p_plan_id
                                        AND    b.plan_type          = @p_plan_type
                                        AND    b.plan_seq           = @p_seq
                                        AND    b.division_id        = e.division_id
                                        AND    b.scm_site_id        = e.scm_site_id
                                        AND    b.osp_yn             = 'Y'         -- 외주 Packer
                                        AND    b.eng_scm_site_id    LIKE '%~***'  -- 가상 Plant Site 생성 제외		
                                        AND    b.operation_group    = 'P'         -- Pack 작업
                                        ) B 
                                        ON ( 1=1
                                        AND  b.division_id = a.division_id 
                                        AND  b.item_id     = a.item_id )                        
                                ) X 
                        WHERE a.parent_item_id = x.item_id 
                    )    -- NOT EXISTS 끝.

        --20181024 추가
        GROUP BY a.parent_item_id, a.child_item_id, c.eng_scm_site_id
			   , a.flow_id, a.bom_version_id		        
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete... : PLANT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		
        -----------------------------------------------------------
        -- 2. 외주 Plant Site : 
        --   Pack Site이면 해당 Item을 Parent로 하는 Cell Item을 Child로 추가 필요
        --   Cell Site이면 해당 Item을 Parent로 하는 전극 Item을 Child로 추가 필요
        --   20201102 PJ20202001 : Parent가 RACK인 모델 제외
        --   2022.06.24: ISUZU Model 제외
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )              
  	    SELECT @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id
			 , a.model_id        AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , b.eng_scm_site_id AS site_id
			 , b.plant_id        AS route_id
			 , b.plant_id        AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , '1'               AS BOM_VERSION_ID			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , ROUND(MAX(a.accumulated_child_qty), 3, 0) AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음             
             , NULL              AS ALT_ID
			 , NULL              AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR		        
        FROM   ( 
                 -- model에 TCO셀과 일반셀이 있을경우 TCO 셀만 사용 
                 SELECT  a.division_id
                      ,  a.model_id
                      ,  a.child_item_id
                      ,  a.operation_group_id
                      ,  a.accumulated_child_qty
                      ,  a.eff_end_date
                      ,  b.tco_cell_yn
                      ,  DENSE_RANK()  OVER (PARTITION BY a.division_id, a.plant_id, a.model_id ORDER BY IIF(b.tco_cell_yn = 'Y', 0, 1) , 
                                                                                                        CASE WHEN A.CELL_TYPE = 'CP'  THEN 1 
                                                                                                             WHEN A.CELL_TYPE = 'CA2' THEN 2 
                                                                                                             WHEN A.CELL_TYPE = 'CA1' THEN 3
                                                                                                             ELSE  4 END 
                                                                                                             ) AS row_num  /* 2023.07.07 n-ERP 활성화 코드 분리: CP TYPE 우선으로 변경 
                         --23.07.07 수정전 코드
                      ,  DENSE_RANK()  OVER (PARTITION BY a.division_id, a.plant_id, a.model_id ORDER BY IIF(b.tco_cell_yn = 'Y', 0, 1) ) AS row_num  
                      */      
		         FROM    dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK)
                         --LEFT JOIN dbo.scm_mst_final_item_v b WITH (NOLOCK)
                         /* 2022.06.24: is_yn 추가 / 2021.11.11 :  dc Item 제외 조건 추가 */
						 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn, dc_yn, is_yn FROM scm_mst_final_item_v WITH (NOLOCK)) b
                         ON   a.division_id = b.division_id
                         AND  a.child_item_id = b.item_id 
						 -- 20201102 PJ20202001 :  Rack Item 제외 조건 추가
						 /* 2022.06.24: is_yn 추가 / 2021.11.11 :  dc Item 제외 조건 추가 */
                         LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn, dc_yn, is_yn FROM scm_mst_final_item_v WITH (NOLOCK)) c
                         ON   a.division_id = c.division_id
                         AND  a.model_id    = c.item_id 						 
		         WHERE   a.division_id          = @p_division_id
                 AND     a.eff_end_date         > @d_plan_name
                 AND     a.model_id            <> a.child_item_id
                 AND     a.operation_group_id   = 'A'
                 AND     ISNULL(c.rack_yn, 'N') = 'N' -- 20201102 PJ20202001 :  Rack Item 제외 조건 추가
                 AND     ISNULL(c.dc_yn, 'N')   = 'N' -- 2021.11.11, DC Item 제외 조건 추가        
                 AND     ISNULL(C.is_yn, 'N')   = 'N' -- 2022.06.24: Isuzu건 조건추가 
		    )  a  --20180912 수정 (변경전 : FROM   dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK) )				
             , dbo.scm_mst_site_eng  b WITH(NOLOCK)
			 , dbo.scm_mst_site_item e WITH(NOLOCK)
		WHERE  a.division_id        = @p_division_id
        AND    a.operation_group_id = 'A'   -- 전극 공정 제외 : 외주 패커는 Pack에 바로 Cell 만 처리함
		AND    a.accumulated_child_qty >  0  
		AND    a.division_id        = b.division_id
		-- 2018.09.11 Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
		--AND    a.plant_id           = b.logistic_plant_id
		AND    b.modeling_id        = @p_modeling_id
		AND    b.plan_id            = @p_plan_id
		AND    b.plan_type          = @p_plan_type
		AND    b.plan_seq           = @p_seq
        AND    b.osp_yn             = 'Y' -- 외주 Packer
        AND    b.eng_scm_site_id    LIKE '%~***'  -- 2018.07.18   가상 Plant Site 생성 제외
		
		AND    b.division_id        = e.division_id
		AND    b.scm_site_id        = e.scm_site_id
		AND    a.model_id           = e.item_id
        AND    a.model_id          <> a.child_item_id -- 2018.08.07 TCO Cell 외주 Site용 BOM
		
		-- 2018.06.18 Plan Name 일자에 유효한 BOM
        --AND    a.eff_start_date    <= @d_plan_name
        AND    a.eff_end_date      >  @d_plan_name

        AND    a.row_num = 1     --20180912 추가 -- model에 TCO셀과 일반셀이 있을경우 TCO 셀만 사용

        --20181024 추가
        GROUP BY a.model_id
			   , a.child_item_id
			   , b.eng_scm_site_id
			   , b.plant_id			 
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = 'Process Complete... : OSP' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        -- 2-2. 외주 Plant Site : 
        --   PJ20202001 : Parent가 RACK이고 Child가 Pack인 모델 추가
        --                plant_id / operation_id = plant_id + '_R1'
        --   20201102 PJ20202001 : Parent가 RACK인 모델 제외, 2021.11.03
        --   2022.06.24 : Isuzu BOM 추가 [child: P-Module(P5000) , parent: P-외주Pack(P9500)]
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )  
  	    SELECT @p_master_id        AS master_id
			 , @p_engine_plan_id   AS plan_id
			 , a.model_id          AS parent_item_id
			 , a.child_item_id     AS child_item_id
			 , b.eng_scm_site_id   AS site_id
			   /* DC 아이템 추가, 2021.11.11, By KKC */ 
			 , CASE WHEN MAX(a.rack_yn) = 'Y' THEN b.plant_id + '_R1'
			        ELSE b.plant_id
				END                AS route_id
			 , CASE WHEN MAX(a.rack_yn) = 'Y' THEN b.plant_id + '_R1'
			        ELSE b.plant_id
				END                AS operation_id			   
			   /* OLD ~ 2021.11.11
			 , b.plant_id + '_R1'  AS route_id
			 , b.plant_id + '_R1'  AS operation_id
			   */
			 , '-'                 AS BINNING_ID
			 , 'Y'                 AS PRODUCTION_FLAG
			 , '1'                 AS BOM_VERSION_ID
			 
             , 1                   AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , ROUND(MAX(a.accumulated_child_qty), 3, 0) AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL                AS ALT_ID
			 , NULL                AS ALT_PRIORITY
			 , 1                   AS ALT_RATE
			 , '0'                 AS IN_MOVE_TIME
			 , '0'                 AS OUT_MOVE_TIME
			 , 'MINUTE'            AS MOVE_TIME_UOM
			 , NULL                AS DESCR        
		
        FROM   ( 
                 -- model에 TCO셀과 일반셀이 있을경우 TCO 셀만 사용
                 SELECT  a.division_id
                      ,  a.model_id
                      ,  a.child_item_id
                      ,  a.operation_group_id
                      ,  a.accumulated_child_qty
                      ,  a.eff_end_date
                      ,  b.tco_cell_yn
					  /* rack_yn, dc_yn 추가, 2021.11.11 */
					  ,  c.rack_yn
					  ,  c.dc_yn
                      ,  c.is_yn   --~ isuzu 대상모델(Y). 2022.06.24 add 
                      ,  DENSE_RANK()  OVER (PARTITION BY a.division_id, a.plant_id, a.model_id ORDER BY IIF(b.tco_cell_yn = 'Y', 0, 1) ) AS row_num
		         FROM    dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK)
                         --LEFT JOIN dbo.scm_mst_final_item_v b WITH (NOLOCK)
                         /* is_yn 추가  2022.06.24 / dc_yn 추가, 2021.11.11  */
						 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn, dc_yn, is_yn FROM scm_mst_final_item_v WITH (NOLOCK)) b
                         ON   a.division_id = b.division_id
                         AND  a.child_item_id = b.item_id 
						 -- 20201102 PJ20202001 :  Rack Item 제외 조건 추가
						 /* is_yn 추가  2022.06.24 / dc_yn 추가, 2021.11.11  */
                         LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn, dc_yn, is_yn FROM scm_mst_final_item_v WITH (NOLOCK)) c
                         ON   a.division_id = c.division_id
                         AND  a.model_id    = c.item_id 

		         WHERE   a.division_id          = @p_division_id
                 AND     a.eff_end_date         > @d_plan_name
                 AND     a.model_id            <> a.child_item_id
                 AND     a.operation_group_id   = 'P'  -- Child가 Pack
			   --AND     ISNULL(c.rack_yn, 'N') = 'Y'  -- 20201102 PJ20202001 :  Rack Item
                 AND     (
				          (ISNULL(c.rack_yn, 'N') = 'Y') 
				       OR (ISNULL(c.dc_yn, 'N') = 'Y')    -- 2021.11.11 [PJ20214997] :  DC Item
                       OR (ISNULL(c.IS_YN, 'N') = 'Y')    -- 2022.06.24: isuzu 조건추가 
					     )                              
		    )  a  --20180912 수정 (변경전 : FROM   dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK) )
		    
			 , dbo.scm_mst_site_eng  b WITH(NOLOCK)
			 , dbo.scm_mst_site_item e WITH(NOLOCK)
		WHERE  a.division_id        = @p_division_id
        AND    a.operation_group_id = 'P'   --Child가 Pack
		AND    a.accumulated_child_qty >  0  
		AND    a.division_id        = b.division_id
		-- 2018.09.11 Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
		--AND    a.plant_id           = b.logistic_plant_id
		AND    b.modeling_id        = @p_modeling_id
		AND    b.plan_id            = @p_plan_id
		AND    b.plan_type          = @p_plan_type
		AND    b.plan_seq           = @p_seq
        AND    b.osp_yn             = 'Y' -- 외주 Packer
        AND    b.eng_scm_site_id    LIKE '%~***'  -- 2018.07.18   가상 Plant Site 생성 제외		
		AND    b.division_id        = e.division_id
		AND    b.scm_site_id        = e.scm_site_id
		AND    a.model_id           = e.item_id
		AND    a.model_id          <> a.child_item_id -- 2018.08.07 TCO Cell 외주 Site용 BOM		
		-- 2018.06.18 Plan Name 일자에 유효한 BOM
        --AND    a.eff_start_date    <= @d_plan_name
        AND    a.eff_end_date      >  @d_plan_name
        AND    a.row_num = 1     --20180912 추가 -- model에 TCO셀과 일반셀이 있을경우 TCO 셀만 사용
		/* 지정 경로의 Site만 유효, 2021.11.11 추가, KKC */
		AND    EXISTS (SELECT 'X'
		                 FROM scm_mst_site_item_priority x WITH(NOLOCK)
						WHERE x.division_id = @p_division_id
						  AND x.item_id     = e.item_id
						  AND x.plant_site_id = e.scm_site_id
                       )
        --20181024 추가
        GROUP BY a.model_id
			   , a.child_item_id
			   , b.eng_scm_site_id
			   , b.plant_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = 'Process Complete... : OSP RACK' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		 
        -----------------------------------------------------------
        -- 2-3. 20230220 외주 Plant Site : ESS 외주 Trust BCU Dummy BOM 추가
        --   Pack 에 하위 Cell이 없어 DUMMY BOM 추가
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )              
  	    SELECT @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id
			 , a.item_id         AS parent_item_id
			 , 'DUMMY'           AS child_item_id  -- 20230220 Trust BCU Item 구분 : item_class = 'EM0306', 하위 Cell 없어 Dummy 처리
			 , b.eng_scm_site_id AS site_id
			 , b.plant_id        AS route_id
			 , b.plant_id        AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , '1'               AS BOM_VERSION_ID			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , 1                 AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음             
             , NULL              AS ALT_ID
			 , NULL              AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR		        
        FROM   scm_mst_final_item_v  a  WITH(NOLOCK)	
             , dbo.scm_mst_site_eng  b WITH(NOLOCK)
			 , dbo.scm_mst_site_item e WITH(NOLOCK)
		WHERE  a.division_id        = @p_division_id
        AND    a.operation_group_id = 'P'   -- 전극 공정 제외 : 외주 패커는 Pack에 바로 Cell 만 처리함
		AND    a.item_class         = 'EM0306'  -- 20230220 Trust BCU Item 구분 : item_class = 'EM0306'
		AND    a.division_id        = b.division_id
		-- 2018.09.11 Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
		--AND    a.plant_id           = b.logistic_plant_id
		AND    b.modeling_id        = @p_modeling_id
		AND    b.plan_id            = @p_plan_id
		AND    b.plan_type          = @p_plan_type
		AND    b.plan_seq           = @p_seq
        AND    b.osp_yn             = 'Y' -- 외주 Packer
        AND    b.eng_scm_site_id    LIKE '%~***'  -- 2018.07.18   가상 Plant Site 생성 제외
		
		AND    b.division_id        = e.division_id
		AND    b.scm_site_id        = e.scm_site_id
		AND    a.item_id            = e.item_id		
        --AND    a.eff_end_date      >  @d_plan_name	 
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = 'Process Complete... : OSP BCU' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        /*  2023.07.07 n-ERP 활성화 코드 분리:
            활성화 코드 분리로 TOC모델에 대해, 모두 CP로 재정의 됨으로 불필요한 로직 주석 처리   
        */
        /*
        IF @v_division_group = '40'         ---2022.04.04 JV사업부 추가 변수변경: @p_division_id -> @v_division_group
        BEGIN
            UPDATE th_eng_plan_bom_sn
            SET    site_id = REPLACE(a.site_id, '~***', '~002')
                    
            FROM  th_eng_plan_bom_sn a with(nolock)
            WHERE a.master_id = @p_master_id     
            AND   a.plan_id   = @p_engine_plan_id  
            AND   a.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH(NOLOCK)
		                              WHERE  lookup_type = 'OPERATION_TCO'
                                      AND    valid_yn    = 'Y'
                                    ) -- 20181109 수정 (변경전 : AND   a.operation_id in ( 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') )
         
        END ;
        */

         /*  2023.07.07 n-ERP 활성화 코드 분리:
             (1) CP 타입의 생산 SITE_ID는 ~002 로 설정, 그 외는 유지.  
             */
        UPDATE a
		    SET a.site_id      = REPLACE(a.site_id, '~***', '~002')
		   FROM th_eng_plan_bom_sn a
           JOIN scm_mst_final_item_v b WITH(NOLOCK)
             ON b.division_id = @p_division_id
            AND b.cell_type IN ('CP', 'CA2')
            AND b.item_id     = a.parent_item_id
            JOIN   scm_mst_site_eng  smse WITH (NOLOCK)  
            ON   smse.division_id = @p_division_id
            AND  smse.modeling_id = @p_modeling_id
            AND  smse.plan_id     = @p_plan_id
            AND  smse.plan_type   = @p_plan_type
            AND  smse.plan_seq    = @p_seq
            AND  smse.eng_scm_site_id = a.site_id  
            AND  ISNULL(smse.osp_yn, 'N')  = 'N'   -- 사내 사이트 대상
          WHERE a.master_id =   @p_master_id
		    AND a.plan_id   =   @p_engine_plan_id
        ;

         /*  2023.07.07 n-ERP 활성화 코드 분리:
             (2) Parent : TCO CELL(CP) & Child : TCO CELL(CA2)경우는 ROUTE_ID/OPERATION_ID를 +_CELL_TYPE("CP")로 재정의(공정 중복 제거).   
          */
        UPDATE a
		    SET a.route_id     = a.route_id+'_CP'
              , a.operation_id = a.operation_id+'_CP'
		   FROM th_eng_plan_bom_sn a
          WHERE a.master_id =   @p_master_id
		    AND a.plan_id   =   @p_engine_plan_id
            AND EXISTS (SELECT 'X' 
                         FROM scp_mst_cell_prod_assy_map x WITH(NOLOCK)
		                WHERE x.item_id_prod = a.parent_item_id
                          AND x.item_id_assy = a.child_item_id
		                  AND CHARINDEX(x.plant_id, a.site_id ) > 0
                          AND x.cell_type    = 'CA2'
                          AND x.valid_yn = 'Y'
                       )       
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE '+@v_table_id;
        SET @v_description = 'Process Complete... : BOM UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- * PROC ITEM 에서 BOM 정보 정리 작업 수행함
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH;

-----------------------------------------------------------
-- 임시 Logic START : 미래 시방 BOM 건 삭제 --
-----------------------------------------------------------
/*
BEGIN TRY

  DELETE th_eng_plan_bom_sn 
  WHERE  master_id      = @p_master_id
  AND    plan_id        = @p_engine_plan_id
  AND    parent_item_id = 'APFCAGSW0-A1'
  AND    child_item_id  = 'AMDAU0112H'
  ;

END TRY

BEGIN CATCH
      -- ERROR LOG
      SET @v_log_type = 'TXN';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = '임시 Logic Error / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END CATCH;
*/
-----------------------------------------------------------
-- 임시 Logic END --
-----------------------------------------------------------

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;

