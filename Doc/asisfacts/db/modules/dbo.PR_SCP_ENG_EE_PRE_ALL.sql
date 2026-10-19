
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_ALL
 * Description  : PRE Plan Control
 * OutTable     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   KSG            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.24   KSG            주석 정리
 * 2018.06.04   KSG            Input 생성 후 후속 작업 정리 :MIN(yield) 처리 삭제
 * 2018.06.08   김성기         Work Order Seq Update 삭제
 * 2018.06.18   KSW            PR_SCP_ENG_EE_PRE_PROC_PLAN_BOM_CAL 프로시저 호출 추가 
 * 2021.04.05   KSG            PJ20209642 LGES 전지GSCM 상반기 프로젝트 : Version ID
 * 2022.06.15   KKC            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 엔진Custom 필드값 생성 (주요 엔진D/B 후처리의 In-Memory화)
*/

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_PRE_ALL]
    ( @p_modeling_id1    NVARCHAR(4000)
    , @p_plan_type1      NVARCHAR(4000)
) AS
  BEGIN
    --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;    

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_master_id        NVARCHAR(4000);
    DECLARE @v_division_id      NVARCHAR(4000);
    DECLARE @v_plan_cycle       NVARCHAR(4000);
    DECLARE @v_plan_name        NVARCHAR(4000);
    DECLARE @v_plan_id          NVARCHAR(4000);
    DECLARE @v_engine_plan_id   NVARCHAR(4000);
    DECLARE @n_plan_seq         INTEGER;
    DECLARE @v_outversion_id    NVARCHAR(4000);
    DECLARE @v_active_flag      NVARCHAR(10);

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
    DECLARE @v_eng_flag          NVARCHAR(10);
    DECLARE @n_eng_time          INTEGER = 0;
    DECLARE @v_version_id        NVARCHAR(30);  -- 20210405  PJ20209642 Version ID
	
    DECLARE @rows                INT;
    DECLARE @plan_status         INT = 0;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_modeling_id + ' / ' + @p_plan_type ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    SET @rows = 0;
  	-- SELECT '0. ==>      ', @p_modeling_id as modeling_id , @p_plan_type as plan_type;

    -----------------------------------------------------------
    -- 실행용 변수 설정
    -----------------------------------------------------------
    -- 1. Master ID / Division ID / Plan Cycle / Planname
    -- engine_id를 ACTIVE_FLAG의 값으로 하여 서버에서 구동중인 RUNNER를 선택하여 엔진을 구동함.
    -- LCHASCPPOB1 : WEEKLY 자동자 811, ESS 821, 소형 401, 전극 991
    --               DAILY  자동자 813, ESS 823, 소형 403, 전극 993
    -- LCHASCPPOB2 : WEEKLY 자동자 812, ESS 822, 소형 402, 전극 992
    --               DAILY  자동자 814, ESS 824, 소형 404, 전극 994
    SELECT /* PR_SCP_ENG_EE_PRE_ALL */
           @v_master_id   = m.enterprise  -- v_master_id
         , @v_division_id = m.division_id -- v_division_id
         , @v_plan_cycle  = m.plan_cycle  -- v_plan_cycle
         , @v_plan_name   =
                CASE WHEN m.plan_cycle = 'WEEKLY' -- v_plan_cycle
                     THEN
                       CONVERT(char(8), DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON')), 112) -- weekly (???? ??????)
                     ELSE
                       CONVERT(char(8), DATEADD(dd, -1, GETDATE()), 112) -- daily (전일자)
                END
         , @v_active_flag = m.engine_id 
    FROM  scm_mst_modeling m with(nolock)
    WHERE modeling_id = @p_modeling_id ; --'1'; -- v_master_id
  	-- SELECT '1. ==>      ', @v_master_id as master_id, @v_division_id as division_id , @v_division_id as division_id , @v_plan_cycle as plan_cycle , @v_plan_name as plan_name;

    -- 2. Plan ID
    SELECT /* PR_SCP_ENG_EE_PRE_ALL */
           @v_plan_id = p.plan_id -- v_plan_id
    FROM   scm_mst_plan p with(nolock)
    WHERE  p.division_id = @v_division_id
    AND    p.plan_cycle  = @v_plan_cycle
    AND    p.plan_name   = @v_plan_name;
  	-- SELECT '2. ==>      ', @@v_plan_id as plan_id;

    -- 3. Plan seq : 처음이면 1, 아니면 MAX(Seq) + 1
    SELECT /* PR_SCP_ENG_EE_PRE_ALL */
           @n_plan_seq = ISNULL(MAX(p.plan_seq),0) + 1 -- n_plan_seq
    FROM   scm_mst_plan_detail p with(nolock)
    WHERE  p.modeling_id = @p_modeling_id
    AND    p.division_id = @v_division_id
    AND    p.plan_id     = @v_plan_id
    AND    p.plan_type   = @p_plan_type  --20180219 추가 (plan_type 별 seq 구하기 위해서 수정함) 
	;
	
	IF (@n_plan_seq = null)  select @n_plan_seq = ISNULL(@n_plan_seq,1)
  	-- SELECT '3. ==>      ', @n_plan_seq as plan_seq;
    
    -- 4. Engine Plan ID
    SET @v_engine_plan_id = @v_plan_id + '::' + @p_plan_type + '::' + CONVERT(NVARCHAR, @n_plan_seq)

    -- SELECT '4. ==>       ', @v_engine_plan_id as engine_plan_id;

    -----------------------------------------------------------
    -- 5. Plan Detail / 엔진제어용 Flag 정보 생성
    -----------------------------------------------------------
	-- 20210405  PJ20209642 Version ID
	SELECT @v_version_id = MAX(version_id)
    FROM   scm_master_version_info_h_sn WITH(NOLOCK)
    WHERE  division_id  = @v_division_id
	AND    scp_use_flag = 'Y'
	;

	DELETE
	FROM   /* PR_SCP_ENG_EE_PRE_ALL */
           th_mst_eng_plan_flag_sn
	WHERE  master_id      = @v_master_id
	AND    plan_id        = @v_engine_plan_id
	AND    out_version_id = @v_engine_plan_id
	;
    -- SELECT '5.delete th_mst_eng_plan_flag_sn==>  ', @@ROWCOUNT;

	DELETE
	FROM   /* PR_SCP_ENG_EE_PRE_ALL */
           scm_mst_plan_detail
	WHERE  modeling_id = @p_modeling_id
	AND    division_id = @v_division_id
	AND    plan_id     = @v_plan_id
	AND    plan_seq    = @n_plan_seq
	AND    plan_type   = @p_plan_type
	;  
    -- SELECT '5.delete scm_mst_plan_detail==>  ', @@ROWCOUNT;

    -- 5.1실행 Flag Insert
    INSERT INTO /* PR_SCP_ENG_EE_PRE_ALL */ th_mst_eng_plan_flag_sn
        ( master_id, plan_id, out_version_id
        , active_flag
        , inbound_flag, engine_flag, outbound_flag, db_trans_flag
        , inbound_start
        , insert_id, insert_date
        )
    SELECT @v_master_id, @v_engine_plan_id, @v_engine_plan_id
         , @v_active_flag
         , 'R', 'R', 'R', 'R'
         , GETDATE()
         , 'scp_batch', GETDATE()
    ;
    -- SELECT '5.1 insert th_mst_eng_plan_flag_sn==>  ', @@ROWCOUNT;
	
    -- 5.2 Plan Detail Insert
   INSERT INTO /* PR_SCP_ENG_EE_PRE_ALL */ scm_mst_plan_detail
          ( modeling_id
          , division_id
          , plan_id
          , plan_seq
          , input_start_date
          , plan_status
          , run_type
          , plan_type
          , plan_type_description
          , base_seq
          , display_yn
          , attribute1 -- 20210405  PJ20209642 Version ID
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          )
    SELECT @p_modeling_id
         , xsm.division_id
         , @v_plan_id
         , @n_plan_seq      AS seq
         , GETDATE()        AS input_start_date
         , '0'              AS status
         , xsm.engine_type  AS run_type
         , @p_plan_type     AS plan_type
         ,(SELECT x.description
           FROM   scm_adm_lookup_master_detail x WITH(NOLOCK)
           WHERE  1=1
           AND    x.lookup_type = 'PLAN_TYPE'
           AND    x.valid_yn    = 'Y'
           AND    x.segment1    = @p_plan_type
          )                 AS plan_type_desc
         , @n_plan_seq      AS base_seq
         , 'N'              AS display_yn
         , @v_version_id -- 20210405  PJ20209642 Version ID
         , GETDATE()        AS creation_date
         , 'scp_batch'      AS created_by
         , GETDATE()        AS last_update_date
         , 'scp_batch'      AS last_updated_by
    FROM   scm_mst_modeling xsm WITH (NOLOCK) 
    WHERE  xsm.modeling_id = @p_modeling_id
    ;
    -- SELECT '5.2 insert scm_mst_plan_detail==>  ', @@ROWCOUNT;

    BEGIN TRY
      BEGIN

      	SELECT 'v_master_id==>      ', @v_master_id;
        SELECT 'v_division_id==>    ', @v_division_id;
        SELECT 'p_plan_cycle==>     ', @v_plan_cycle;
        SELECT 'v_plan_name==>      ', @v_plan_name;
        SELECT 'v_plan_id==>        ', @v_plan_id;
        SELECT 'v_engine_plan_id==> ', @v_engine_plan_id;
        SELECT 'n_plan_seq==>       ', @n_plan_seq;
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   

        -----------------------------------------------------------
		--20180510 실행위치이동 (마지막에서 처음으로 이동)
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_DEMAND_ATTRIBUTE @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_DEMAND_ATTRIBUTE', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        -- Demand에 설정된 SCM_SITE_ID 를 사용하기 위하여 먼저 처리함 : SCM_SITE_ID = scm_site_id + '::' + incoterms
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        -- SCM_SITE_ID = scm_site_id + '::' + incoterms
        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		        
        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_BOMCOMPONENTS @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_BOMCOMPONENTS ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------
		
        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_SITE_ENG @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_SITE_ENG ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_BOD_ENG @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_BOD_ENG ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
				        
        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_INVENTORY @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_INVENTORY ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_SET_ITEMSITEMSTR @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_SET_ITEMSITEMSTR ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------
		
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_PLAN_INFO @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_PLAN_INFO ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_BUCKET_INFO @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_BUCKET_INFO ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_SITE @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_SITE ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_BOD @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_BOD ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_BOD_PATTERN @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_BOD_PATTERN ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_PLAN_BOM @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_PLAN_BOM ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        --20180618 추가
        --EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_PLAN_BOM_CAL @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        --SELECT 'PR_SCP_ENG_EE_PRE_PROC_PLAN_BOM_CAL ', @rows;
        --IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_ITEM @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_ITEM ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_ITEM_BOD @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_ITEM_BOD ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_SALES_PRODUCT_MAP @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_SALES_PRODUCT_MAP ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_ITEM_BOD_CAL @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_ITEM_BOD_CAL ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_ITEM_ROUTE_SITE @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_ITEM_ROUTE_SITE ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_ROUTE @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_ROUTE ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_RESOURCE @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_RESOURCE ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_BUCKET_RES_CAPA @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_BUCKET_RES_CAPA ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN_PROD @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN_PROD ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

     
         --20180521 생성
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
        
         --20180521 생성
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX_MAP @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX_MAP ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE 
      

        -- 20180625 각종 후처리작업(엔진요청작업) 추가
        -- 반영전 선행사항 ( 1. PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN_PROD 의 FIXED_PLAN 내 확정 W/O, D/O 의 WORKORDER_SEQ 생성 처리부분 삭체처리 필요
        --                   2. 엔진 요청에 의한 임시 실행 구문 삭제처리필요)
        EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_FIX_MISMATCHING @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_FIX_MISMATCHING ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE 

        -- 2022.06.15, 엔진Custom 필드 생성 프로시져 호출
		EXEC @rows = PR_SCP_ENG_EE_PRE_PROC_CUSTOM @v_plan_cycle, @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_master_id, @v_division_id, @v_engine_plan_id
        SELECT 'PR_SCP_ENG_EE_PRE_PROC_CUSTOM ', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE 

        -----------------------------------------------------------
        -- 실행 Flag Update
        -----------------------------------------------------------
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

        -- 엔진제어용 Flag 정보 Update
        UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
               th_mst_eng_plan_flag_sn
        SET    inbound_flag = 'C'
             , inbound_end  = GETDATE()
             , update_id    = 'scp_batch'
             , update_date  = GETDATE()
        WHERE  master_id      = @v_master_id
        AND    plan_id        = @v_engine_plan_id
        AND    out_version_id = @v_engine_plan_id;
        -- SELECT 'update th_mst_eng_plan_flag_sn==>  ', @@ROWCOUNT;
		
        -- Plan Detail 정보 Update
        UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
               scm_mst_plan_detail
        SET    input_end_date   = GETDATE()
             , plan_start_date  = GETDATE()
             , last_update_date = GETDATE()
        WHERE  modeling_id = @p_modeling_id
        AND    division_id = @v_division_id
        AND    plan_id     = @v_plan_id
        AND    plan_seq    = @n_plan_seq        -- TXN LOG
        AND    plan_type   = @p_plan_type       -- 20180219 추가 (plan_type 별 seq 구하기 위해서 수정함)
        ;
         -- SELECT 'update scm_mst_plan_detail==>  ', @@ROWCOUNT;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'RUN ';
        SET @v_description = 'Process Complete... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

        _RETURN_ERR_CODE:
        BEGIN
          IF @rows < 0
            BEGIN
              -----------------------------------------------------------
              -- 실행 Flag Update
              -----------------------------------------------------------
              -- 엔진제어용 Flag 정보 Update
              UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
                     th_mst_eng_plan_flag_sn
              SET    inbound_flag = 'E'
                   , inbound_end  = GETDATE()
                   , update_id    = 'scp_batch'
                   , update_date  = GETDATE()
              WHERE  master_id      = @v_master_id
              AND    plan_id        = @v_engine_plan_id
              AND    out_version_id = @v_engine_plan_id;
              --SELECT 'update th_mst_eng_plan_flag_sn==>  ', @@ROWCOUNT;
		
              -- Plan Detail 정보 Update
              UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
                     scm_mst_plan_detail
              SET    plan_status      = '-1'
                   , last_update_date = GETDATE()
              WHERE  modeling_id = @p_modeling_id
              AND    division_id = @v_division_id
              AND    plan_id     = @v_plan_id
              AND    plan_seq    = @n_plan_seq        -- TXN LOG
              AND    plan_type   = @p_plan_type       -- 20180219 추가 (plan_type 별 seq 구하기 위해서 수정함)              ;
              -- SELECT 'update scm_mst_plan_detail==>  ', @@ROWCOUNT;

              -- ROLLBACK
              -- ERROR LOG
              SET @v_log_type = 'ERROR';
              SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
              SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              RETURN -1
            END; -- IF @rows < 0

        END; -- _RETURN_ERR_CODE:

      END;

    END TRY

    BEGIN CATCH
      -----------------------------------------------------------
      -- 실행 Flag Update
      -----------------------------------------------------------
      -- 엔진제어용 Flag 정보 Update
      UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
             th_mst_eng_plan_flag_sn
      SET    inbound_flag = 'E'
           , inbound_end  = GETDATE()
           , update_id    = 'scp_batch'
           , update_date  = GETDATE()
      WHERE  master_id      = @v_master_id
      AND    plan_id        = @v_engine_plan_id
      AND    out_version_id = @v_engine_plan_id;
      --SELECT 'update th_mst_eng_plan_flag_sn==>  ', @@ROWCOUNT;
		
      -- Plan Detail 정보 Update
      UPDATE /* PR_SCP_ENG_EE_PRE_ALL */
             scm_mst_plan_detail
      SET    plan_status      = '-1'
           , last_update_date = GETDATE()
      WHERE  modeling_id = @p_modeling_id
      AND    division_id = @v_division_id
      AND    plan_id     = @v_plan_id
      AND    plan_seq    = @n_plan_seq        -- TXN LOG
      AND    plan_type   = @p_plan_type       -- 20180219 추가 (plan_type 별 seq 구하기 위해서 수정함)              ;
      -- SELECT 'update scm_mst_plan_detail==>  ', @@ROWCOUNT;

      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_master_id + ' / ' + @v_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1 

  END;

