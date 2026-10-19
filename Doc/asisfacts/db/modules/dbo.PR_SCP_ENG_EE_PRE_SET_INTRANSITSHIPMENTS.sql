
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS
 * Description  : SDB의 Site별 해상재고 정보를 ODB의 해상재고에 적재되도록 한다.
                  
                  1. 운송중 재고 정보 생성 : 해상재고( I : GTS 있는 해상정보, 'S' : GTS 없는 정보, 'C' 법인간 해상재고)
				     SCM_DNM_INTRANSIT_V 사용
                  
                  2. 위 1에서 생성된 운송중재고 정보의 from_site 값 변경
                     
                     --전극일때 :  -1) from site가 전극('E') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                                   -2) from site가 전극('E') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
                     --셀일때   :  -1) from site가 전극('A') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트이거나 외주packer 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                                   -2) from site가 전극('A') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
                                                     
 * OutTable     : SCP_ENG_INTRANSITSHPMNT_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.29   KSW         전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.10.01   KSW         외주 전극 ***만 생성( 외주전극 : 002, 003 생성제외)
 * 2018.10.18   KSW         1) result_type = 'C' 제외처리 (참고)주석1-1, 주석1-2
                            2) Plant site일때 incoterms <> 'FOB' 주석처리 (참고)주석1-2
 * 2018.11.21   KSG         SO Reserve Stock : result_type = 'B' 추가
 * 2018.12.05   KSG         SO Reserve Stock : result_type = 'B' 제거 : 해상재고 대신 To Site의 재고로 처리
 * 2018.12.13   KSW         해상재고 INSERT부분수정 ( to site의 site_type ='PLANT' 일때 result_type = 'C' 만처리되게 수정) (참고)주석1-2
 * 2019.03.05   KSW         [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2019.06.11   KSG         VMI향 Intransit : result_type = 'V' 추가
 * 2019.06.13   KSG         Intransit(GTS) 정보에서 To Site 가 plant인 경우도 추가 반영
 * 2019.06.19   KSG         SCM_DNM_INTRANSIT_V 사용
 * 2020.10.13   KSG         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                컬럼 정보 수정 FINAL_SOLDTO_CODE / FINAL_INCOTERMS
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
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

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS';
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

    ---(2022.04.04) 추가.
    DECLARE @v_division_group    NVARCHAR(30);   
    DECLARE @v_division_comp     NVARCHAR(30);   
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.ATTRIBUTE4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id
    ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        DELETE /* PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS*/ 
		FROM   scp_eng_intransitshpmnt_i_sn
		WHERE  modeling_id  = @p_modeling_id
        AND    plan_id      = @p_plan_id
		AND    plan_type    = @p_plan_type 
        AND    plan_seq     = @p_seq
        ;        
        -----------------------------------------------------------
		
        -----------------------------------------------------------
        -- 1. 해상재고 정보 INSERT 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS*/ scp_eng_intransitshpmnt_i_sn 
        (	modeling_id
          , plan_id
          , plan_type
          , plan_seq 
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
        )
		
        SELECT @p_modeling_id  AS modeling_id
		     , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
   	         , a.result_date
             , a.result_type
             , a.company_id
             , @p_division_id  AS division_id  --20180629 수정 ( 변경전 : a.division_id )
             , a.plant_id 
	         , a.shipment_no
             , a.project_code
             , a.item_id
             , a.plant_issue_date
             , a.final_incoterms             AS incoterms   -- 20201006 PJ20202001 컬럼 변경  a.incoterms 
             , a.fcst_type 
	         , a.final_soldto_code           AS customer_code  -- 20201006 PJ20202001 컬럼 변경  a.customer_code
             , a.shipto_code
             , a.from_scm_site_id + '~***'   AS from_scm_site_id
             , a.from_scm_site_id            AS org_from_scm_site_id
             , 'Y' AS from_site_item_mapping_yn -- DNM에서 관리 안 함

	         -- 20201006 PJ20202001 컬럼 변경
             , a.to_scm_site_id + '~' + CASE WHEN a.site_type = 'PLANT' THEN '***' ELSE a.final_incoterms END AS to_scm_site_id
             --, a.to_scm_site_id + '~' + CASE WHEN a.site_type = 'PLANT' THEN '***' ELSE a.incoterms END AS to_scm_site_id

             , a.to_scm_site_id                   AS org_to_scm_site_id
             , 'Y' AS to_site_item_mapping_yn  -- DNM에서 관리 안 함
	         , a.delivery_qty
             , a.uom
             , a.transport_mode 
	         , a.shipping_date
             , a.pol
             , a.pol_atd_date 
	         , a.pod
             , a.pod_eta_date
             , a.pod_ata_date
             , a.pod_etd_date
             , a.pod_atd_date 
	         , a.f_dest_port_code
             , a.f_dest_eta_date
             , a.f_dest_ata_date 
			 , a.eta_date -- 도착 예정일자 
             
	         , 'Y'         AS valid_yn
             , 'scp_batch' AS created_by
             , GETDATE()   AS creation_date
             , 'scp_batch' AS last_updated_by
             , GETDATE()   AS last_update_date 
	         , a.final_incoterms AS attribute1
             , NULL AS attribute2
             , NULL AS attribute3
             , NULL AS attribute4
             , NULL AS attribute5 
	         , NULL AS attribute6
             , NULL AS attribute7
             , NULL AS attribute8
             , NULL AS attribute9
             , NULL AS attribute10 	   
		FROM  (-- 2022.04.04 JV사업부 추가: 같은회사 내 division_id대신 division_group으로 변경 
                SELECT a.* 
                     , di.attribute3 AS division_group 
                     , di.attribute4 AS division_comp 
                FROM   SCM_DNM_INTRANSIT_V  a WITH (NOLOCK)
                     , scm_mst_division    di WITH(NOLOCK)
                WHERE  di.valid_yn     =  'Y' 
                AND    di.division_id  =  a.division_id
                AND    di.attribute4   = @v_division_comp  -- 회사코드
              ) a               

               -- 20180629 추가  ( from site가 전극site만 조회되게 하기위해서)
               INNER JOIN ( SELECT division_id, scm_site_id 
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  site_type       = 'PLANT' 
                            AND    valid_yn        = 'Y'
                            AND    operation_group = 'E' 
                            ) sms
               ON   a.division_id        = sms.division_id
               AND  a.from_scm_site_id   = sms.scm_site_id

        WHERE  1=1
        AND    a.division_group  IN ( '40', '81', '82')  -- 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 20220404 division_group으로 변경.
        AND    a.result_date   = @v_cutoff_day        
        ; 
      /* 20220404 변경전
		FROM   SCM_DNM_INTRANSIT_V  a WITH (NOLOCK)
               
               -- 20180629 추가  ( from site가 전극site만 조회되게 하기위해서)
               INNER JOIN ( SELECT division_id, scm_site_id 
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  site_type       = 'PLANT' 
                            AND    valid_yn        = 'Y'
                            AND    operation_group = 'E' 
                            ) sms
               ON   a.division_id        = sms.division_id
               AND  a.from_scm_site_id   = sms.scm_site_id

        WHERE  1=1
        AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
        AND    a.result_date   = @v_cutoff_day  */ 
		    
        /*
        -----------------------------------------------------------
        --1.2 DELETE : from_site 가 전극인 정보 삭제 -- 전극 모델은 제외 : ksg 20180517
        -----------------------------------------------------------
		DELETE scp_eng_intransitshpmnt_i_sn
        WHERE  division_id = @p_division_id
        AND    modeling_id = @p_modeling_id
        AND    plan_id     = @p_plan_id
        AND    plan_type   = @p_plan_type
        AND    plan_seq    = @p_seq
        AND    division_id + '::' + org_from_scm_site_id
		   IN ( SELECT division_id + '::' + scm_site_id
                FROM   dbo.scm_mst_site WITH (NOLOCK) 
                WHERE  division_id = @p_division_id
                AND    site_type   = 'PLANT' 
              --  AND    valid_yn    = 'Y'
                AND    operation_group = 'E'
              ) 
		;
        */

        -----------------------------------------------------------
        --2. UPDATE : from_site 변경
        -----------------------------------------------------------
            
            --전극일때 :  -1) from site가 전극('E') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
            --            -2) from site가 전극('E') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
            --셀일때   :  -1) from site가 전극('A') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
            --            -2) from site가 전극('A') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
               
        -----------------------------------------------------------
        UPDATE scp_eng_intransitshpmnt_i_sn
        SET from_scm_site_id = CASE WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND ( ISNULL(b.site_id, '0') <> ISNULL(c.site_id, '0') OR c.site_type ='SALES' ) THEN a.org_from_scm_site_id + '~003'  --20181001 수정=>AND ISNULL(b.osp_yn, 'N') = 'N' 추가
                                    WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND  ISNULL(b.site_id, '0') = ISNULL(c.site_id, '1')  THEN a.org_from_scm_site_id + '~002'                             --20181001 수정=>AND ISNULL(b.osp_yn, 'N') = 'N' 추가
                                    ELSE a.from_scm_site_id --20181001 추가
                                    --WHEN b.operation_group  = 'A' AND ( dbo.FN_SCM_SYS_NVL(b.site_id, '0') <> dbo.FN_SCM_SYS_NVL(c.site_id, '0') OR c.site_type ='SALES' OR c.osp_yn = 'Y') THEN a.org_from_scm_site_id + '~003' 
                                    --WHEN b.operation_group  = 'A' AND dbo.FN_SCM_SYS_NVL(b.site_id, '0') = dbo.FN_SCM_SYS_NVL(c.site_id, '1') THEN a.org_from_scm_site_id + '~002'                                    
                               END
        FROM   scp_eng_intransitshpmnt_i_sn a
               INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 division_id대신 division_group(attribute3)으로 변경.
                            SELECT a.division_id, a.scm_site_id, a.site_id, a.operation_group
                                 , a.osp_yn --20181001 추가   
                            FROM   dbo.scm_mst_site     a WITH (NOLOCK) 
                                 , scm_mst_division    di WITH(NOLOCK)
                            WHERE  a.valid_yn        = 'Y'
                            AND    a.site_type       = 'PLANT'                            
                            AND    a.operation_group = 'E'    
                            AND    di.division_id    =  a.division_id 
                            AND    di.valid_yn       = 'Y'  
                            AND    di.attribute3    IN ('40', '81', '82') --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                            AND    di.attribute4     = @v_division_comp 

                          /* 20220404 수정전 
                            SELECT division_id, scm_site_id, site_id, operation_group
                                 , osp_yn --20181001 추가   
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  site_type   = 'PLANT' 
                            AND    valid_yn    = 'Y'
                            AND    operation_group = 'E' --AND    operation_group IN ('E', 'A')
                            --AND    division_id = @p_division_id
                            AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */ 

                          ) b
               ON  a.org_from_scm_site_id  = b.scm_site_id                
               --AND  a.division_id           = b.division_id  -- 20180629 주석처리

               INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 division_id대신 division_group으로 변경.
                            SELECT a.division_id, a.scm_site_id, a.site_id, a.operation_group, a.site_type, a.osp_yn    
                            FROM   dbo.scm_mst_site   a WITH (NOLOCK) 
                                 , scm_mst_division  di WITH(NOLOCK)
                            WHERE  a.valid_yn        =  'Y'
                            AND    di.division_id    =  a.division_id 
                            AND    di.valid_yn       =  'Y'     
                            AND    di.attribute3    IN ('40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                            AND    di.attribute4     =  @v_division_comp 

                         /* 20220404 수정전 
                            SELECT division_id, scm_site_id, site_id, operation_group,site_type, osp_yn    
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  valid_yn    = 'Y'
                            --AND    division_id = @p_division_id -- 20180629 주석처리
                            AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */ 

                            ) c
               ON  a.org_to_scm_site_id  = c.scm_site_id 
               --AND a.division_id         = c.division_id --20180629 주석처리

        WHERE  a.modeling_id = @p_modeling_id 
        AND    a.plan_id     = @p_plan_id
        AND    a.plan_type   = @p_plan_type 
        AND    a.plan_seq    = @p_seq
        ;

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

