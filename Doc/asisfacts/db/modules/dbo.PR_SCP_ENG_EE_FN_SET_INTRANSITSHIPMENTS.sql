
/*
 * Program ID   : PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS
 * Description  : 동일 PLAN_ID의 Confirm Flag ='Y'인 이전 PLAN_TYPE의 최종 생성된 데이터를 적재
 * OutTable     : SCP_ENG_INTRANSITSHPMNT_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.16   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2021.02.04   KSG            C20210203-000224 [SCM PI팀] GSCM시스템의 RTF정합성 향상을 위한 ETA 기준 반영 시간 변경 개선 건
 * 2021.03.09   KSG            C20210308-000089 [SCM PI팀] 판매법인 법인간거래 ETA 정보 Update 로직 수정 요청 건 
                                  법인간 해상재고는 To Site가 SALES 이더라도 GTS의 ETA 사용
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_INTRANSITSHPMNT_I';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cutoff_day        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        DELETE /* PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS*/ 
		FROM   scp_eng_intransitshpmnt_i_sn
		WHERE  modeling_id  = @p_modeling_id
        AND    plan_id      = @p_plan_id
		AND    plan_type    = @p_plan_type 
        AND    plan_seq     = @p_seq
        ;        
        -----------------------------------------------------------
   /*-- 20220321 주석 START
		INSERT INTO /* PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS*/ scp_eng_intransitshpmnt_i_sn 
        (	modeling_id, plan_id, plan_type, plan_seq
          , result_date, result_type, company_id, division_id, plant_id, shipment_no
          , project_code, item_id, plant_issue_date, incoterms, fcst_type, customer_code, shipto_code
          , from_scm_site_id, org_from_scm_site_id, from_site_item_mapping_yn 
	      , to_scm_site_id, org_to_scm_site_id, to_site_item_mapping_yn 
	      , delivery_qty, uom, transport_mode 
	      , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date 
	      , f_dest_port_code, f_dest_eta_date, f_dest_ata_date 
	      , eta_date 
	      , valid_yn
          , created_by, creation_date, last_updated_by, last_update_date
	      , attribute1, attribute2, attribute3, attribute4, attribute5 
	      , attribute6, attribute7, attribute8, attribute9, attribute10 
        )
        SELECT a.modeling_id, a.plan_id, a.plan_type, a.plan_seq
	         , a.result_date, a.result_type, a.company_id, a.division_id, a.plant_id, a.shipment_no
             , a.project_code, a.item_id, a.plant_issue_date, a.incoterms, a.fcst_type, a.customer_code, a.shipto_code
             , a.from_scm_site_id, a.org_from_scm_site_id, a.from_site_item_mapping_yn 
	         , a.to_scm_site_id, a.org_to_scm_site_id, a.to_site_item_mapping_yn 
	         , a.delivery_qty, a.uom, a.transport_mode
	         , a.shipping_date, a.pol, a.pol_atd_date, a.pod, a.pod_eta_date, a.pod_ata_date, a.pod_etd_date, a.pod_atd_date 
	         , a.f_dest_port_code, a.f_dest_eta_date, a.f_dest_ata_date

			 -- 20210204 C20210203-000224 이전 Plan 정보 COPY 시 GTS 정보 사용하여 ETA Update 처리
             -- -- 20210309 C20210308-000089 법인간 해상재고는 To Site가 SALES 이더라도 GTS의 ETA 사용 : DNM_INTRANSIT_CO_CUTOFF 에도 동일 로직 존재함
             ,CASE WHEN ISNULL(dt.shipment_no, '')   = ''      THEN a.eta_date
                   WHEN ISNULL(a.result_type, '')    = 'C'     THEN
                        CASE WHEN ISNULL(dt.f_dest_eta_date, '') = '' THEN a.eta_date ELSE dt.f_dest_eta_date END
                   WHEN ISNULL(s.site_type, '')      = ''      THEN a.eta_date
                   WHEN ISNULL(s.site_type, 'SALES') = 'SALES' THEN 
                        CASE WHEN ISNULL(dt.f_dest_eta_date_sales, '') = '' THEN a.eta_date ELSE dt.f_dest_eta_date_sales END
                   ELSE CASE WHEN ISNULL(dt.f_dest_eta_date, '')       = '' THEN a.eta_date ELSE dt.f_dest_eta_date       END
              END eta_date

			 , a.valid_yn
             , a.created_by, a.creation_date, a.last_updated_by, a.last_update_date
	         , a.attribute1, a.attribute2, a.attribute3, a.attribute4, a.attribute5 
	         , a.attribute6, a.attribute7, a.attribute8, a.attribute9, a.attribute10 
        FROM  (
               SELECT modeling_id, plan_id, @p_plan_type AS plan_type, @p_seq       AS plan_seq
	                , result_date, result_type, company_id, division_id, plant_id 
	                , shipment_no
		            , CASE WHEN CHARINDEX('_', shipment_no) = 0 THEN shipment_no
                           ELSE SUBSTRING(shipment_no, 1, CHARINDEX('_', shipment_no)-1)  
                      END as shipment_no_org

                    , project_code, item_id, plant_issue_date, incoterms, fcst_type, customer_code, shipto_code
                    , from_scm_site_id, org_from_scm_site_id, from_site_item_mapping_yn 
	                , to_scm_site_id, org_to_scm_site_id, to_site_item_mapping_yn 
	                , delivery_qty, uom, transport_mode
	                , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date 
	                , f_dest_port_code, f_dest_eta_date, f_dest_ata_date, eta_date, valid_yn
                    , created_by, creation_date, last_updated_by, last_update_date
	                , attribute1, attribute2, attribute3, attribute4, attribute5 
	                , attribute6, attribute7, attribute8, attribute9, attribute10 
               FROM  scp_eng_intransitshpmnt_i_sn WITH (NOLOCK)
               WHERE modeling_id = @p_modeling_id
               AND   plan_id     = @p_plan_id
               AND   plan_type   = @p_pre_plan_type
               AND   plan_seq    = @p_pre_plan_seq
               AND   division_id = @p_division_id
              ) a

        LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
        --ON  a.division_id        = s.division_id  -- EE 
        ON  a.org_to_scm_site_id = s.scm_site_id

        LEFT OUTER JOIN SCM_DNM_GTS_ETA_V dt WITH(NOLOCK)

        ON     a.company_id      = dt.company_id -- 20181204 company_id 추가
        AND    a.shipment_no_org = dt.shipment_no
		*/ -- 20220321 주석 END

   -- 20210204 C20210203-000224 주석 START
	 INSERT INTO /* PR_SCP_ENG_EE_FN_SET_INTRANSITSHIPMENTS*/ scp_eng_intransitshpmnt_i_sn 
        (	modeling_id, plan_id, plan_type, plan_seq
          , result_date, result_type, company_id, division_id, plant_id, shipment_no
          , project_code, item_id, plant_issue_date, incoterms, fcst_type, customer_code, shipto_code
          , from_scm_site_id, org_from_scm_site_id, from_site_item_mapping_yn 
	      , to_scm_site_id, org_to_scm_site_id, to_site_item_mapping_yn 
	      , delivery_qty, uom, transport_mode 
	      , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date 
	      , f_dest_port_code, f_dest_eta_date, f_dest_ata_date 
	      , eta_date 
	      , valid_yn
          , created_by, creation_date, last_updated_by, last_update_date
	      , attribute1, attribute2, attribute3, attribute4, attribute5 
	      , attribute6, attribute7, attribute8, attribute9, attribute10 
        )
        SELECT modeling_id
          , plan_id
          , @p_plan_type AS plan_type
          , @p_seq       AS plan_seq
	      , result_date
          , result_type
          , company_id
          , division_id
          , plant_id 
	      , shipment_no
          , project_code
          , item_id
          , plant_issue_date
          , incoterms 
          , fcst_type
	      , customer_code
          , shipto_code
          , from_scm_site_id
          , org_from_scm_site_id
          , from_site_item_mapping_yn 
	      , to_scm_site_id
          , org_to_scm_site_id
          , to_site_item_mapping_yn 
	      , delivery_qty
          , uom
          , transport_mode 
	      , shipping_date
          , pol
          , pol_atd_date 
	      , pod
          , pod_eta_date
          , pod_ata_date
          , pod_etd_date
          , pod_atd_date 
	      , f_dest_port_code
          , f_dest_eta_date
          , f_dest_ata_date 
	      , eta_date 
	      , valid_yn
          , created_by
          , creation_date
          , last_updated_by
          , last_update_date
	      , attribute1
          , attribute2
          , attribute3
          , attribute4
          , attribute5 
	      , attribute6
          , attribute7
          , attribute8
          , attribute9
          , attribute10 
        FROM  scp_eng_intransitshpmnt_i_sn WITH (NOLOCK)
        WHERE modeling_id = @p_modeling_id
        AND   plan_id     = @p_plan_id
        AND   plan_type   = @p_pre_plan_type
        AND   plan_seq    = @p_pre_plan_seq
        AND   division_id = @p_division_id   --'EE'
        ;
        ; -- 20210204 C20210203-000224 주석 END

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;


