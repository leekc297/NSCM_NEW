
/*
 * Program ID   : PR_SCM_MST_PLAN_FP_RELEASE_ID
 * Description  : FP 생산 계획 Version 저장 프로시져  
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.07.09   KSG            Initial Release [CSR ID:4034546] GSCM 계획 수립 시점 별 FP Version 조회가능 UI 개발 요청
 * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.03.23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_PLAN_FP_RELEASE_ID]
    ( @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- 입력변수를 일반변수로 변경함
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PLAN_FP_RELEASE_ID';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

		------------------------------------------------
		-- 1. PR용 Cutoff Plan Version 저장 작업
		------------------------------------------------
		IF @p_plan_type = 'PR' 
		BEGIN

          DELETE 
		  FROM  scm_mst_plan_fp_release_id
		  WHERE plan_name = @p_plan_name
          AND   plan_type = @p_plan_type
		  ;

          INSERT INTO scm_mst_plan_fp_release_id
             (modeling_id, division_id, plan_id, plan_seq, plan_type, p.plan_name
            , company_id, site_id, plant_id
            , instance_id, instance_type, instance_date
            , release_plan_id, factory_id, plan_group_id
            , creation_date, created_by, last_update_date, last_updated_by
             )-- 1. 전극 외 사업부 
          SELECT m.modeling_id
               , p.division_id
               , p.plan_id
               , '-'  plan_seq -- PR은 특정 시점에 Cutoff하여 동일하게 사용함
               , @p_plan_type plan_type
               , p.plan_name
               , fp.company_id
               , fp.site_id
               , fp.plant_id
               , fp.instance_id
               , fp.instance_type
               , fp.instance_date
               , fp.release_plan_id
               , fp.factory_id
               , fp.plan_group_id
               , GETDATE()   creation_date
               , 'scm_batch' created_by
               , GETDATE()   last_update_date
               , 'scm_batch' last_updated_by
          FROM   scm_mst_plan p WITH(NOLOCK)
               
          INNER JOIN (SELECT DISTINCT division_id, plant_id
                      FROM   scm_mst_site WITH(NOLOCK)
                      WHERE site_type        = 'PLANT'
                      AND   osp_yn          <> 'Y'
                      AND   valid_yn         = 'Y'
                      AND   operation_group <> 'E' -- 전극 제외
                     ) s
          ON  p.division_id = s.division_id
               
          LEFT OUTER JOIN scm_mst_modeling m WITH(NOLOCK)
          ON  p.division_id = m.division_id
          AND p.plan_cycle  = m.plan_cycle
          AND m.valid_yn    = 'Y'
               
          INNER JOIN scm_dnm_fp_last_release_plan_id_v_sn fp WITH(NOLOCK)
          ON  p.division_id = CASE WHEN p.division_id = 'EE' THEN p.division_id
                                   ELSE fp.division_id
                              END
          AND fp.plant_id   = s.plant_id
         
          WHERE  p.plan_cycle   = 'WEEKLY'
          AND    p.plan_name    = @p_plan_name
        
          UNION
          -- 2. 전극사업부
          SELECT m.modeling_id
               , p.division_id
               , p.plan_id
               , '-'  plan_seq -- PR은 특정 시점에 Cutoff하여 동일하게 사용함
               , @p_plan_type plan_type
               , p.plan_name
               , fp.company_id
               , fp.site_id
               , fp.plant_id
               , fp.instance_id
               , fp.instance_type
               , fp.instance_date
               , fp.release_plan_id
               , fp.factory_id
               , fp.plan_group_id
               , GETDATE()   creation_date
               , 'scm_batch' created_by
               , GETDATE()   last_update_date
               , 'scm_batch' last_updated_by
          FROM   scm_mst_plan p WITH(NOLOCK)
               
          INNER JOIN (SELECT DISTINCT 'EE' division_id, plant_id
                      FROM   scm_mst_site WITH(NOLOCK)
                      WHERE site_type        = 'PLANT'
                      AND   osp_yn          <> 'Y'
                      AND   valid_yn         = 'Y'
                      AND   operation_group  = 'E' -- 전극
                     ) s
          ON  p.division_id = s.division_id
               
          LEFT OUTER JOIN scm_mst_modeling m WITH(NOLOCK)
          ON  p.division_id = m.division_id
          AND p.plan_cycle  = m.plan_cycle
          AND m.valid_yn    = 'Y'
               
          INNER JOIN scm_dnm_fp_last_release_plan_id_v_sn fp WITH(NOLOCK)
          ON  p.division_id = CASE WHEN p.division_id = 'EE' THEN p.division_id
                                   ELSE fp.division_id
                              END
          AND fp.plant_id   = s.plant_id
        
          WHERE  p.plan_cycle   = 'WEEKLY'
          AND    p.plan_name    = @p_plan_name
          ;

		END  --IF @p_plan_type = 'PR'
		
		------------------------------------------------
		-- 2. 전극 : MA/SE/FN
		------------------------------------------------
        ELSE IF @p_division_id = 'EE'
		BEGIN
		
          DELETE 
		  FROM  scm_mst_plan_fp_release_id
		  WHERE modeling_id = @p_modeling_id
          AND   division_id = @p_division_id
          AND   plan_id     = @p_plan_id
          AND   plan_seq    = @p_seq
          AND   plan_type   = @p_plan_type
          AND   plan_name   = @p_plan_name
		  ;

          INSERT INTO scm_mst_plan_fp_release_id
             (modeling_id, division_id, plan_id, plan_seq, plan_type, p.plan_name
            , company_id, site_id, plant_id
            , instance_id, instance_type, instance_date
            , release_plan_id, factory_id, plan_group_id
            , creation_date, created_by, last_update_date, last_updated_by
             )
          SELECT @p_modeling_id
               , @p_division_id
               , @p_plan_id
               , @p_seq
               , @p_plan_type
               , @p_plan_name
               , fp.company_id
               , fp.site_id
               , fp.plant_id
               , fp.instance_id
               , fp.instance_type
               , fp.instance_date
               , fp.release_plan_id
               , fp.factory_id
               , fp.plan_group_id
               , GETDATE()   creation_date
               , 'scm_batch' created_by
               , GETDATE()   last_update_date
               , 'scm_batch' last_updated_by
          FROM   scm_dnm_fp_last_release_plan_id_v_sn fp WITH(NOLOCK)
               
          INNER JOIN (SELECT DISTINCT ms.division_id, ms.plant_id
                       FROM  scm_mst_site ms WITH(NOLOCK)
					         -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
							 inner join scm_mst_division dm WITH(NOLOCK)  
									 on dm.division_id = ms.division_id
									and dm.attribute4  = 'LG' -- JV plant 제외 
									and dm.valid_yn	   = 'Y'
                      WHERE  ms.site_type        = 'PLANT'
                        AND  ms.osp_yn          <> 'Y'
                        AND  ms.valid_yn         = 'Y'
                        AND  ms.operation_group  = 'E' -- 전극
					  
                      -- PJ20216891
                      -- 81_UC의 plant는 제외한다
                      -- AND   division_id      <> '81_UC'
                     ) s
          ON  fp.division_id = s.division_id
          AND fp.plant_id   = s.plant_id
 
          WHERE  1=1
          --AND    fp.division_id = @p_division_id -- 전극은 전체 Division  
          ;

		END --IF @p_division_id = 'EE' : 2. 전극 : MA/SE/FN
		
        -- PJ20216891
        -- 새사업부 추가로 인한 별도 처리로직
        -- ELSE IF @p_division_id = 'EE_UC'

		-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
        ELSE IF EXISTS (SELECT 1
						  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
						 WHERE DIVISION_ID =  @p_division_id
						   AND ATTRIBUTE3  = 'EE'
						   AND ATTRIBUTE4 != 'LG' ) -- JV division
		BEGIN
		
          DELETE 
		  FROM  scm_mst_plan_fp_release_id
		  WHERE modeling_id = @p_modeling_id
          AND   division_id = @p_division_id
          AND   plan_id     = @p_plan_id
          AND   plan_seq    = @p_seq
          AND   plan_type   = @p_plan_type
          AND   plan_name   = @p_plan_name
		  ;

          INSERT INTO scm_mst_plan_fp_release_id
             (modeling_id, division_id, plan_id, plan_seq, plan_type, p.plan_name
            , company_id, site_id, plant_id
            , instance_id, instance_type, instance_date
            , release_plan_id, factory_id, plan_group_id
            , creation_date, created_by, last_update_date, last_updated_by
             )
          SELECT @p_modeling_id
               , @p_division_id
               , @p_plan_id
               , @p_seq
               , @p_plan_type
               , @p_plan_name
               , fp.company_id
               , fp.site_id
               , fp.plant_id
               , fp.instance_id
               , fp.instance_type
               , fp.instance_date
               , fp.release_plan_id
               , fp.factory_id
               , fp.plan_group_id
               , GETDATE()   creation_date
               , 'scm_batch' created_by
               , GETDATE()   last_update_date
               , 'scm_batch' last_updated_by
          FROM   scm_dnm_fp_last_release_plan_id_v_sn fp WITH(NOLOCK)
               
		  /*
          --INNER JOIN (SELECT DISTINCT division_id, plant_id
          --            FROM   scm_mst_site WITH(NOLOCK)
          --            WHERE site_type        = 'PLANT'
          --            AND   osp_yn          <> 'Y'
          --            AND   valid_yn         = 'Y'
          --            AND   operation_group  = 'E' -- 전극
		  --		  
          --            -- PJ20216891
          --            -- 81_UC의 plant만 포함한다
          --            AND   division_id      = '81_UC'
          --           ) s
			*/
		  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
          INNER JOIN (select distinct ms.division_id, ms.plant_id
					  from scm_mst_division ed WITH(NOLOCK)
						   inner join scm_mst_division dm WITH(NOLOCK)
								   on dm.attribute4  = ed.attribute4
								  and dm.attribute3 != 'EE'
								  and dm.valid_yn	 = 'Y'
						   inner join scm_mst_site ms WITH(NOLOCK)
								   on ms.division_id	 = dm.division_id 
								  and ms.site_type		 = 'PLANT'
								  and ms.osp_yn			<> 'Y'
								  and ms.valid_yn		 = 'Y'
								  and ms.operation_group = 'E'
					  where 1=1
					    and ed.division_id = @p_division_id  -- 'EE_UC' 'EE_HM' 
						and ed.valid_yn	   = 'Y'
					) s
          ON  fp.division_id = s.division_id
          AND fp.plant_id   = s.plant_id
 
          WHERE  1=1
          --AND    fp.division_id = @p_division_id -- 전극은 전체 Division  
          ;

		END --IF @p_division_id = 'EE' : 2. 전극 : MA/SE/FN
		
		------------------------------------------------
		-- 3. 전극외 사업부 : MA/SE/FN
		------------------------------------------------
        ELSE 
		BEGIN
		
          DELETE 
		  FROM  scm_mst_plan_fp_release_id
		  WHERE modeling_id = @p_modeling_id
          AND   division_id = @p_division_id
          AND   plan_id     = @p_plan_id
          AND   plan_seq    = @p_seq
          AND   plan_type   = @p_plan_type
          AND   plan_name   = @p_plan_name
		  ;

          INSERT INTO scm_mst_plan_fp_release_id
             (modeling_id, division_id, plan_id, plan_seq, plan_type, p.plan_name
            , company_id, site_id, plant_id
            , instance_id, instance_type, instance_date
            , release_plan_id, factory_id, plan_group_id
            , creation_date, created_by, last_update_date, last_updated_by
             )
          SELECT @p_modeling_id
               , @p_division_id
               , @p_plan_id
               , @p_seq
               , @p_plan_type
               , @p_plan_name
               , fp.company_id
               , fp.site_id
               , fp.plant_id
               , fp.instance_id
               , fp.instance_type
               , fp.instance_date
               , fp.release_plan_id
               , fp.factory_id
               , fp.plan_group_id
               , GETDATE()   creation_date
               , 'scm_batch' created_by
               , GETDATE()   last_update_date
               , 'scm_batch' last_updated_by
          FROM   scm_dnm_fp_last_release_plan_id_v_sn fp WITH(NOLOCK)
               
          INNER JOIN (SELECT DISTINCT division_id, plant_id
                      FROM   scm_mst_site WITH(NOLOCK)
                      WHERE site_type        = 'PLANT'
                      AND   osp_yn          <> 'Y'
                      AND   valid_yn         = 'Y'
                      AND   operation_group <> 'E' -- 전극 외
                     ) s
          ON  fp.division_id = s.division_id
          AND fp.plant_id   = s.plant_id 
 
          WHERE  1=1
          AND    fp.division_id = @p_division_id   
          ;

		END -- ELSE -- 3. 전극외 사업부 : MA/SE/FN
		;

	  END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10)) + ' : ' + @p_plan_name   ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

