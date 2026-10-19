
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_BOD
 * Description  : SDB의 BOD 정보를 ODB에 적재되도록 한다.
 * OutTable     : TH_ENG_BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.15   정원식         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            활성화 LT 처리 수정
 * 2018.06.18   KSG            활성화 LT 처리 수정 : scp_mst_formation 정보 사용
 * 2018.06.26   KSG            특성 계획 3주 반영 : 수정 시 Fixed Plan 도 동시 반영 필요
 * 2018.09.10   KSW            BOD ITEM 자동생성 관련 수정 (참고)주석1)
 * 2018.10.25   KSW            전극 후공정(*** -> 002) LT 값 설정부분 변경 ( 변경전 : '2'로 고정되어 있었음, 변경후 : ISNULL(SCP_MST_OPERATION_LT.LT_DAY,2) 값으로 대체) 
 * 2021.11.29   LHS            th_eng_bod의 transport_time < 0 이면 0 으로 변경
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_BOD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_BOD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_BOD';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        DELETE /* PR_SCP_ENG_EE_FN_PROC_BOD */ 
        FROM  th_eng_bod_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        ;
        -----------------------------------------------------------

        -----------------------------------------------------------
        -- 1. BOD
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_BOD */ th_eng_bod_sn
		    ( master_id
		    , plan_id
		    , bod_id
		    , from_site_id
		    , to_site_id
		    , transport_mode
		    , transport_time
		    , transport_time_uom
		    , bod_start_dttm
		    , bod_pattern_id
		    , from_offtime_set_id
		    , to_offtime_set_id
		    , fixed_term
		    , fixed_term_uom
		    , attribute_set_id
		    , attribute_checker_id
		    , is_prev_epst
		    , descr
		    )
		SELECT DISTINCT
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             , bie.item_id + '::' + be.bod_id                     AS bod_id
		     , be.eng_from_site                                   AS from_site_id
		     , be.eng_to_site                                     AS to_site_id
		     , be.transport_mode                                  AS transport_mode
             
             --20181025 수정 전극후공정(~*** -> ~002)일때 scp_mst_operation_lt.lt_day 값 사용
             , ISNULL(lt.lt_day, be.attribute10)                  AS transittime  -- BOD ENG의 Attribute10에 LT 적용 --20181025 수정(변경전 : , be.attribute10 AS transittime  -- BOD ENG의 Attribute10에 LT 적용)
             
             , 'DAY'                                              AS transport_time_uom
		     , CONVERT(DATE, ISNULL(bie.eff_start_date, @p_plan_name)) AS bod_start_dttm 
		     , '1D'                                               AS bod_pattern_id
		     , NULL                                               AS from_offtime_set_id
		     , NULL                                               AS to_offtime_set_id
             
			 -- 20240617 KSG : PI 요청으로 company_id 기준으로 변경함
			 --, CASE WHEN (mse.site_id <> mst.site_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') 
			 , CASE WHEN (mse.company_id <> mst.company_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') 
                    THEN ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0))
               ELSE 0
               END                                                AS fixed_term  -- 20180410 수정 (변경전 : , ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0) )  AS fixed_term )

		     , 'DAY'                                              AS fixed_term_uom
		     , NULL                                               AS attribute_set_id
		     , NULL                                               AS attribute_checker_id
		     , 'N'                                                AS is_prev_epst
		     , NULL                                               AS descr
		FROM   scm_mst_bod_eng           be  WITH (NOLOCK)
               INNER JOIN 
                          --20180910 수정 (시작~종료일이 다른 동일한 item BOD 존재하므로, 1건만 INSERT해야하므로  MIN(eff_start_date) 처리함) (변경전 : , scm_mst_bod_item_eng      bie WITH (NOLOCK)  )
                          ( SELECT modeling_id, plan_id, plan_seq, plan_type
                                 , bod_id, item_id, MIN(frozen_period) AS frozen_period -- 현재는 frozen_period이 'NULL'값이지만 여러값이 입력될 경우를 대비해서 MIN처리함
                                 , MIN(eff_start_date) AS eff_start_date
                            FROM   scm_mst_bod_item_eng WITH (NOLOCK) 
                            WHERE  modeling_id   = @p_modeling_id	
		                    AND    plan_id       = @p_plan_id		
		                    AND    plan_type     = @p_plan_type
		                    AND    plan_seq      = @p_seq
                            GROUP BY modeling_id, plan_id, plan_seq, plan_type
                                   , bod_id, item_id 
                            ) bie  -- (변경전 : scm_mst_bod_item_eng bie WITH (NOLOCK) )
               
               ON   be.modeling_id   = bie.modeling_id
		       AND  be.plan_id       = bie.plan_id
		       AND  be.plan_type     = bie.plan_type
		       AND  be.plan_seq      = bie.plan_seq
               AND  be.bod_id        = bie.bod_id

               AND  be.modeling_id   = @p_modeling_id	
		       AND  be.plan_id       = @p_plan_id		
		       AND  be.plan_type     = @p_plan_type
		       AND  be.plan_seq      = @p_seq

               INNER JOIN  scm_mst_site_eng mse WITH (NOLOCK) --bod from  site 조인
               ON   be.modeling_id   = mse.modeling_id
		       AND  be.plan_id       = mse.plan_id
		       AND  be.plan_type     = mse.plan_type
		       AND  be.plan_seq      = mse.plan_seq
		       AND  be.eng_from_site = mse.eng_scm_site_id --bod from site 조인

               INNER JOIN scm_mst_site_eng mst WITH (NOLOCK) --bod to    site 조인 20180309 추가
               ON   be.modeling_id   = mst.modeling_id
		       AND  be.plan_id       = mst.plan_id
		       AND  be.plan_type     = mst.plan_type
		       AND  be.plan_seq      = mst.plan_seq
		       AND  be.eng_to_site   = mst.eng_scm_site_id -- bod to site 조인 

               --20181025 추가 전극후공정(***->002) LT값 정보 
               LEFT JOIN  (SELECT scm_site_id, item_id, lt_day, lt_operation
                           FROM   scp_mst_operation_lt WITH (NOLOCK)
                           WHERE  lt_operation = 'SLITTING'
						   -- Look up은 추후 활용
                           --WHERE  lt_operation =  ( SELECT segment1 AS lt_operation
                           --                         FROM   scm_adm_lookup_master_detail WITH (NOLOCK)
                           --                         WHERE  lookup_type = 'OPERATION_LT'
                           --                         AND    valid_yn = 'Y'
                           --                       )
               ) lt  -- 공정별 LT값 정보
               ON   be.attribute1 = 'INNER_SITE_E_002' -- BOD가 E~*** -> E002 
               AND  be.to_site    = lt.scm_site_id
               ANd  bie.item_id   = lt.item_id

		--WHERE  1=1
        ;
        
        /* 20181025 변경전
        FROM   scm_mst_bod_eng           be  WITH (NOLOCK)
             
             --20180910 수정 (시작~종료일이 다른 동일한 item BOD 존재하므로, 1건만 INSERT해야하므로  MIN(eff_start_date) 처리함) (변경전 : , scm_mst_bod_item_eng      bie WITH (NOLOCK)  )
            , ( SELECT modeling_id, plan_id, plan_seq, plan_type
                     , bod_id, item_id, MIN(frozen_period) AS frozen_period -- 현재는 frozen_period이 'NULL'값이지만 여러값이 입력될 경우를 대비해서 MIN처리함
                     , MIN(eff_start_date) AS eff_start_date
                FROM   scm_mst_bod_item_eng WITH (NOLOCK) 
                WHERE  modeling_id   = @p_modeling_id	
		        AND    plan_id       = @p_plan_id		
		        AND    plan_type     = @p_plan_type
		        AND    plan_seq      = @p_seq
                GROUP BY modeling_id, plan_id, plan_seq, plan_type
                       , bod_id, item_id 
                ) bie  -- (변경전 : scm_mst_bod_item_eng bie WITH (NOLOCK) )

             , scm_mst_site_eng          mse WITH (NOLOCK) --bod from  site 조인
             , scm_mst_site_eng          mst WITH (NOLOCK) --bod to    site 조인 20180309 추가

		WHERE  1=1
		AND    be.modeling_id   = @p_modeling_id	
		AND    be.plan_id       = @p_plan_id		
		AND    be.plan_type     = @p_plan_type
		AND    be.plan_seq      = @p_seq
    
		AND    be.modeling_id   = bie.modeling_id
		AND    be.plan_id       = bie.plan_id
		AND    be.plan_type     = bie.plan_type
		AND    be.plan_seq      = bie.plan_seq
        AND    be.bod_id        = bie.bod_id

		AND    be.modeling_id   = mse.modeling_id
		AND    be.plan_id       = mse.plan_id
		AND    be.plan_type     = mse.plan_type
		AND    be.plan_seq      = mse.plan_seq
		AND    be.eng_from_site = mse.eng_scm_site_id --bod from site 조인

        -- 추가 20180309
        AND    be.modeling_id   = mst.modeling_id
		AND    be.plan_id       = mst.plan_id
		AND    be.plan_type     = mst.plan_type
		AND    be.plan_seq      = mst.plan_seq
		AND    be.eng_to_site   = mst.eng_scm_site_id -- bod to site 조인 
		;
        */

		-----------------------------------------------------------
        -- 2. Transport_time < 0 인 경우에는 0 으로 변경. 2021.11.29 
        -----------------------------------------------------------	
			BEGIN

				-- TXN LOG
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'PART 2-1 START';
				SET @v_description = N'2-1. th_eng_bod_sn의 transport_time 음수값= 0 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


				UPDATE a
				SET    a.transport_time = 0
				FROM   th_eng_bod_sn a
				WHERE  a.master_id  = @p_master_id
				AND    a.plan_id    = @p_engine_plan_id
				AND    a.transport_time < 0 
				;
			
			END

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
      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1

  END;


