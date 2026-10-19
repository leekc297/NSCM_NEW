
/*
 * Program ID   : PR_SCP_PLN_SSP_SHIP_REQ 
 * Description  : SSP SHIP Req 정보 전송
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_SSP_SHIP_REQ
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.07.28   KSG            Initial Release C20200723-000010 [SCM PI팀] I/F Blocking 관련 (SSP - SCP Final Plan 동기화)
 * 2021/05/10   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(SCP_MST_BOD_V.segment3 값이 A면 그대로,  아니면 yyyymmdd + Before_lt 만큼 add)
 * 2021.07.07   sclee          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 참조뷰 변경 및 조인조건 추가
 * 2021.09.10   ksg            C20210910-000050 [SCM PI] ESMI> HZP 출하계획 Shipment Request SEMI Data 생성 중단 요청
 * 2021.09.29   ksg            C20210929-000135 [SCM PI팀] G184-A 에서 CN003035-P로 출하 되는 Cell 에 대해서는 Shipment Request SEMI Data 생성 중지
 * 2021.10.12   ksg            확정 구간 이후 처리 로직 수정, 사용자 수정 정보는 삭제/수정 안 되도록 처리
 * 2022.09.01   SSP Pjt.       소형모듈비즈 적용
 * 2022.09.08   SSP Pjt.       미사용 -> PR_SSP_ANL_SHIP_REQ_SEMI 으로 대체
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.11.03	vadabi5	       NERP) QA, 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 EXEC NERP_PR_SCP_PLN_SSP_SHIP_REQ
   @p_division_id   = ''
 , @p_start_yyyymmdd= ''
 , @p_plan_type     = ''
 , @p_seq           = ''
 , @p_user_id       = ''

  EXEC PR_SCP_PLN_SSP_SHIP_REQ
   @p_division_id   = ''
 , @p_start_yyyymmdd= ''
 , @p_plan_type     = ''
 , @p_seq           = ''
 , @p_user_id       = ''
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_SSP_SHIP_REQ]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_SSP_SHIP_REQ';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);       
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_delete_week  INTEGER = 4;  -- Shipment Req 정보 삭제 기준 : 20211012 사용 안 함
    DECLARE @v_ow_day_cnt   INTEGER ; -- 사업부별로 확정구간 이후 구간에 대해서 사용자가 입력/변경한 데이터를 며칠까지 보존할 것인지의 일수	

	-- NERP 매핑코드
    DECLARE @v_G382A_G388P NVARCHAR(32);	-- G382-A:G388-P
	DECLARE @v_G184A_CN003035P NVARCHAR(32);-- G184-A:CN003035-P

	  SELECT @v_G382A_G388P = SEGMENT2 
		FROM SCM_CODE_LOOKUP_VALUE 
	   WHERE LOOKUP_TYPE_CODE = 'PR_SCP_PLN_SSP_SHIP_REQ'
		 AND SEGMENT1 = 'FROM_TO_SITE_STOP_1'

	  SELECT @v_G184A_CN003035P = SEGMENT2 
		FROM SCM_CODE_LOOKUP_VALUE 
	   WHERE LOOKUP_TYPE_CODE = 'PR_SCP_PLN_SSP_SHIP_REQ'
		 AND SEGMENT1 = 'FROM_TO_SITE_STOP_2'



        ----------------------------------------------------------- 
        -- 0. validation
        -- PLAN_TYPE='FN', CONFIRM된 경우에 처리함.
        -----------------------------------------------------------
        IF @p_plan_type NOT IN ('FN')
           BEGIN
              RETURN;
           END

        ----------------------------------------------------------
        -- 해당주차 SCP자동으로 수행하여 인터페이스 안내리도록
        -- SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함.
        ----------------------------------------------------------
        DECLARE @X_FP_TARGET_YN NVARCHAR(1) = 'Y';
        DECLARE @X_MRP_TARGET_YN NVARCHAR(1) = 'Y';

        SELECT @X_FP_TARGET_YN =  ISNULL(FP_TARGET_YN,'Y'),
               @X_MRP_TARGET_YN =  ISNULL(MRP_TARGET_YN,'Y')
          FROM [SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
         WHERE DIVISION_ID         = @p_division_id 
           AND PLAN_START_YYYYMMDD = @p_start_yyyymmdd;

        IF @X_FP_TARGET_YN = 'N'
           BEGIN
              RETURN;
           END

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date = SYSDATETIME();
 
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    
    BEGIN TRY
      BEGIN
    
  --      BEGIN TRANSACTION; 
        SET @p_user_id = 'scm_batch';  -- 사용자 수정 정보 삭제 방지를 위하여 지정값 유지 필요함

		-- 사업부별로 확정구간 이후 구간에 대해서 사용자가 입력/변경한 데이터를 며칠까지 보존할 것인지의 일수	
        SELECT @v_ow_day_cnt = CAST(segment2 AS INT)
        FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
        WHERE  lookup_type = 'DM_SHIP_OW_FROZEN'
        AND    segment1    = @p_division_id
        ;
		         
        BEGIN		
          --------------------------------------------------------
	      --1. Ship Frozen 이후 구간 Semi Ship Req 삭제
          --------------------------------------------------------
          DELETE r
          FROM dm_pln_shipment_req r WITH(NOLOCK)
		  
          INNER JOIN scm_mst_site fs WITH(NOLOCK)
          ON  r.division_id      = fs.division_id
          AND r.plant_site_id    = fs.scm_site_id
          AND fs.site_type       = 'PLANT'  
          AND (fs.operation_group = 'A' OR fs.OPERATION_GROUP = IIF(r.division_id = '40', 'P', 'A') )  --소형모듈비즈적용
          AND fs.osp_yn          = 'N'
          AND fs.valid_yn        = 'Y'	   

          INNER JOIN scm_mst_site ts WITH(NOLOCK)
          ON  r.division_id = ts.division_id
          AND r.scm_site_id = ts.scm_site_id
          AND ts.site_type  = 'PLANT'  
          AND ts.valid_yn   = 'Y'

          WHERE  1=1
          AND    r.division_id      = @p_division_id
          AND    r.measure          = 'SHIP_REQ'
          --AND    r.yyyymmdd        >= CONVERT(CHAR(8), DATEADD(DD, 7*@n_delete_week, CONVERT(DATETIME,@p_start_yyyymmdd,112)), 112) -- 월요일 + 주 
          -- 20211012 삭제 로직 수정
          AND    r.yyyymmdd        >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112) -- 확정구간 이후				   
          AND (
                -- 확정구간 이후 사업부별 보존구간 적용 : 사용자가 수정하지 않은 데이터만 삭제
                (    r.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112)
                 AND r.yyyymmdd <= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) -1 + ISNULL(@V_OW_DAY_CNT, 0) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112) 
                 AND ISNULL(r.last_updated_by,'Y') IN ('scm_batch', 'scp_batch', 'System')			--	사용자가 수정지 않은 데이터
                ) 
               -- -- 보존구간 이후는 전부 삭제
               OR (
                   r.yyyymmdd > CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) -1 + ISNULL(@V_OW_DAY_CNT, 0) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112) 
                  )
               OR r.qty = 0
              )
          ;
		
          --------------------------------------------------------
          --2. Ship Frozen 이후 구간 Semi Ship Req Insert
          --------------------------------------------------------
           INSERT INTO dm_pln_shipment_req
           (division_id, project_code, scm_site_id, item_id, fcst_type, incoterms, transport_mode, bod_id
          , measure, plant_site_id, site_type, yyyymmdd, qty
          , created_by, creation_date, last_updated_by, last_update_date
           )
          SELECT sp.division_id
               , '-'          AS project_code
	           , sp.to_site   AS scm_site_id
	           , sp.item_id
	           , '-'          AS fcst_type
	           , bod.incoterms
	           , bod.transport_mode
	           , sp.bod_id
               , 'SHIP_REQ'   AS measure
	           , sp.from_site AS plant_site_id
	           , 'PLANT'      AS site_type
			   -- PJ20209642 : BOD LT 1단계 개발
	           --, sp.yyyymmdd
			   , CASE WHEN bod.segment3 = 'A' THEN sp.yyyymmdd
			          ELSE sp.yyyymmdd + bod.Before_lt 
				 END		 AS YYYYMMDD
	           , sp.qty
               , @p_user_id  AS created_by
	           , GETDATE()   AS creation_date
	           , @p_user_id  AS last_updated_by
	           , GETDATE()   AS last_update_date
          FROM   [scp_anl_shipment_plan_semi] sp WITH(NOLOCK)

                 INNER JOIN scp_mst_bod_n_v bod with(nolock)   -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
                 ON  sp.division_id = bod.division_id
                 AND sp.bod_id      = bod.bod_id

                 INNER JOIN scm_mst_site fs with(nolock)
                 ON  sp.division_id     = fs.division_id
                 AND sp.from_site       = fs.scm_site_id
                 AND fs.site_type       = 'PLANT'  
                 AND (fs.operation_group = 'A' OR fs.OPERATION_GROUP = IIF(sp.division_id = '40', 'P', 'A') ) --소형모듈비즈적용
                 AND fs.osp_yn          = 'N'
                 AND fs.valid_yn        = 'Y'	     

                 INNER JOIN scm_mst_site ts with(nolock)
                 ON  sp.division_id = ts.division_id
                 AND sp.to_site     = ts.scm_site_id
                 AND ts.site_type   = 'PLANT'  
                 AND ts.valid_yn    = 'Y'

				 -- 20211012 추가 키가 겹치는 경우 제외
                 LEFT OUTER JOIN dm_pln_shipment_req AS e  WITH(NOLOCK) 
                 ON  sp.division_id  = e.division_id 
                 AND sp.bod_id       = e.bod_id 
                 AND sp.item_id      = e.item_id 
                 AND sp.yyyymmdd     = e.yyyymmdd 
                 AND e.measure       = 'SHIP_REQ' 

          WHERE  1=1
		  AND    ts.plant_id           <> fs.plant_id
          AND    sp.division_id         = @p_division_id
          AND    sp.plan_start_yyyymmdd = @p_start_yyyymmdd
          AND    sp.plan_type           = @p_plan_type
          AND    sp.seq                 = @p_seq
          AND    sp.measure             = 'SHIP_PLAN_AMEND'
          AND    e.division_id          IS NULL  -- 키가 겹치는 경우 제외 20211012

          --AND    sp.yyyymmdd           >= CONVERT(CHAR(8), DATEADD(DD, 7*@n_delete_week, CONVERT(DATETIME,@p_start_yyyymmdd,112)), 112) -- 월요일 + 주 이후
          -- 20210112 확정구간 이후
          AND    sp.yyyymmdd           >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112)
          AND    sp.yyyymmdd           <= CONVERT(CHAR(8), DATEADD(DD, 7*10, GETDATE()), 112) -- 10주 이내
          AND    sp.qty                 > 0
          -- 20210910 C20210910-000050   G382-A -> G388-P 출하계획 반영 중지
          AND    sp.from_site + ':' + sp.to_site <> @v_G382A_G388P
          -- 20210929 C20210929-000135   G184-A -> CN003035-P 출하계획 반영 중지
          AND    sp.from_site + ':' + sp.to_site <> @v_G184A_CN003035P
		 ;

          --------------------------------------------------------
          --3. Semi Ship Req History Insert - SEQ 는 자동 증가하는 컬럼임
          --------------------------------------------------------
           INSERT INTO dm_pln_shipment_req_h
           (division_id, project_code, scm_site_id, item_id, fcst_type, incoterms, transport_mode, bod_id
          , measure, plant_site_id, site_type, yyyymmdd, qty
          , created_by, creation_date, last_updated_by, last_update_date
           )
          SELECT sp.division_id
               , '-'          AS project_code
	           , sp.to_site   AS scm_site_id
	           , sp.item_id
	           , '-'          AS fcst_type
	           , bod.incoterms
	           , bod.transport_mode
	           , sp.bod_id
               , 'SHIP_REQ'   AS measure
	           , sp.from_site AS plant_site_id
	           , 'PLANT'      AS site_type
	           -- PJ20209642 : BOD LT 1단계 개발
	           --, sp.yyyymmdd
			   , CASE WHEN bod.segment3 = 'A' THEN sp.yyyymmdd
			          ELSE sp.yyyymmdd + bod.Before_lt 
				 END		 AS YYYYMMDD
	           , sp.qty
               , @p_user_id  AS created_by
	           , GETDATE()   AS creation_date
	           , @p_user_id  AS last_updated_by
	           , GETDATE()   AS last_update_date
          FROM   [scp_anl_shipment_plan_semi] sp WITH(NOLOCK)
		  
                 INNER JOIN scp_mst_bod_n_v bod with(nolock)   -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
                 ON  sp.division_id = bod.division_id
                 AND sp.bod_id      = bod.bod_id

                 INNER JOIN scm_mst_site fs with(nolock)
                 ON  sp.division_id     = fs.division_id
                 AND sp.from_site       = fs.scm_site_id
                 AND fs.site_type       = 'PLANT'  
                 AND (fs.operation_group = 'A' OR fs.OPERATION_GROUP = IIF(sp.division_id = '40', 'P', 'A') )  --소형모듈비즈적용
                 AND fs.osp_yn          = 'N'
                 AND fs.valid_yn        = 'Y'	     

                 INNER JOIN scm_mst_site ts with(nolock)
                 ON  sp.division_id = ts.division_id
                 AND sp.to_site     = ts.scm_site_id
                 AND ts.site_type   = 'PLANT'  
                 AND ts.valid_yn    = 'Y'

				 -- 20211012 추가 키가 겹치는 경우 제외
                 LEFT OUTER JOIN dm_pln_shipment_req AS e  WITH(NOLOCK) 
                 ON  sp.division_id  = e.division_id 
                 AND sp.bod_id       = e.bod_id 
                 AND sp.item_id      = e.item_id 
                 AND sp.yyyymmdd     = e.yyyymmdd 
                 AND e.measure       = 'SHIP_REQ' 

          WHERE  1=1
		  AND    ts.plant_id           <> fs.plant_id
          AND    sp.division_id         = @p_division_id
          AND    sp.plan_start_yyyymmdd = @p_start_yyyymmdd
          AND    sp.plan_type           = @p_plan_type
          AND    sp.seq                 = @p_seq
          AND    sp.measure             = 'SHIP_PLAN_AMEND'
          AND    e.division_id          IS NULL  -- 키가 겹치는 경우 제외 20211012

          --AND    sp.yyyymmdd           >= CONVERT(CHAR(8), DATEADD(DD, 7*@n_delete_week, CONVERT(DATETIME,@p_start_yyyymmdd,112)), 112) -- 월요일 + 주 이후
          -- 20210112 확정구간 이후
          AND    sp.yyyymmdd           >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(fs.ship_frozen, 10) , CONVERT(DATETIME, @p_start_yyyymmdd)), 112)
          AND    sp.yyyymmdd           <= CONVERT(CHAR(8), DATEADD(DD, 7*10, GETDATE()), 112) -- 10주 이내
          AND    sp.qty                 > 0
          -- 20210910 C20210910-000050   G382-A -> G388-P 출하계획 반영 중지
          AND    sp.from_site + ':' + sp.to_site <> @v_G382A_G388P
          -- 20210929 C20210929-000135   G184-A -> CN003035-P 출하계획 반영 중지
          AND    sp.from_site + ':' + sp.to_site <> @v_G184A_CN003035P
		 ;
		 
        END    
      
        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

     --   IF @@TRANCOUNT > 0 
     --     BEGIN
     --       COMMIT WORK;
     --     END;
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
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
  
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;
      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    return 1  

  END;

