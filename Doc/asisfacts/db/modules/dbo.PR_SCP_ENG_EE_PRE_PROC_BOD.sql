
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_BOD
 * Description  : 
                  -----------------------------------------------------------
                  -- 1. BOD INSERT
                  -----------------------------------------------------------
                     
                     - 컬럼1) bod_id         : scm_mst_bod_item_eng.item_id + '::' + scm_mst_bod_eng.bod_id
                     - 컬럼2) transport_time : ISNULL(scp_mst_operation_lt.lt_day(=전극 SLITTING 공정 Lead Time), scm_mst_bod_eng.attribute10(=BOD Lead Time))
                                               => 전극후공정('-E~*** -> -E~002') BOD일때만 scp_mst_operation_lt.lt_day 적용
                     - 컬럼3) fixed_term     : 
                                               경우1) 공장외부(from site와 to site의 site_id가 다를때, 또는 to site가 sales site일때, 또는  from site가 외주site, 또는 to site가 외주site일때) : ISNULL(scm_mst_bod_item_eng.frozen_period, ISNULL(from site의 scm_mst_site_eng.ship_frozen, 0)) (참고 : 모든 scm_mst_bod_item_eng.frozen_period값은 NULL값이다) --  select distinct frozen_period from scm_mst_bod_item_eng WITH (NOLOCK)
                                               경우2) 경우1) 제외한 모든경우는 0 셋팅

                     - 컬럼4) bod_start_dttm : ISNULL(MIN(scm_mst_bod_item_eng.eff_start_dttm), 플랜시작일(=@p_plan_name))
                                               => eff_start_date(시작일)과 eff_end_date(종료일)이 다른 동일한 item BOD가 존재 할 수 있으므로 (GROUP BY modeling_id, plan_id, plan_seq, plan_type)그룹핑한 MIN(eff_start_date)값 사용함  
                     
                     - 참고 테이블1) scm_mst_bod_eng      (plan사용할 BOD정보)
                     - 참고 테이블2) scm_mst_bod_item_eng (plan사용할 item bod 정보) : eff_start_date(시작일)과 eff_end_date(종료일)이 다른 동일한 item BOD가 존재 할 수 있으므로 (GROUP BY modeling_id, plan_id, plan_seq, plan_type)그룹핑한 MIN(eff_start_date)값 사용함
                     - 참고 테이블3) scp_mst_operation_lt (전극 후공정('-E~*** -> -E~002') Lead Time 정보) : lt_operation = 'SLITTING' 공정만 사용
                     
 
 * EXEC            
                  DECLARE  @p_plan_cycle  NVARCHAR(150)   = 'WEEKLY'
                         , @p_plan_name   nvarchar(4000)  = '20180625'
                         , @p_plan_id     nvarchar(4000)  = '1032'
                         , @p_modeling_id nvarchar(4000)  = '4'
                         , @p_seq         nvarchar(4000)  = '1'
                         , @p_plan_type   nvarchar(4000)  = 'PR'
                         , @p_master_id   nvarchar(4000)  = 'EE::WEEKLY'
                         , @p_division_id nvarchar(30)    = 'EE'
                         , @p_engine_plan_id nvarchar(4000) = '1032::PR::1'
	
                  EXEC PR_SCP_ENG_EE_PRE_PROC_BOD @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id             
                    
                  select * from th_eng_bod_sn WITH (NOLOCK)
                  where  master_id = 'EE::WEEKLY'
                  and    plan_id   = '1032::PR::1'
                  --and    ISNULL(fixed_term, 0) = 0
                  ;

 * OutTable     : TH_ENG_BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.04   KSW            Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.09.10   KSW            BOD ITEM 자동생성 관련 수정 (참고)주석1)
 * 2018.10.25   KSW            전극 후공정(*** -> 002) LT 값 설정부분 변경 ( 변경전 : '2'로 고정되어 있었음, 변경후 : ISNULL(SCP_MST_OPERATION_LT.LT_DAY,2) 값으로 대체)  
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2021.09.03   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - TE버전 FIX PLAN 반영여부 옵션화 구현
 * 2021.11.29   LHS            th_eng_bod의 transport_time < 0 이면 0 으로 변경
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_BOD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_BOD';
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

	DECLARE @v_te_frozen_yn  NVARCHAR(1);  --2021.09.03 추가

     ---(2022.04.04) 추가.
    DECLARE @v_division_group   NVARCHAR(30);    
    DECLARE @v_division_comp    NVARCHAR(30); 
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

        /*********************************************************************************
		Froze(TE) 여부 체크 및 None Froze 일 경우는 FIXED PLAN 모두 미생성, 2021.09.03 By KKC		
		**********************************************************************************/
		--1. frozen(TE) 여부 Check
		SELECT @v_te_frozen_yn  = ISNULL(a.segment3, 'N')   
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'SCP_FROZEN_APPLY_YN'
		   AND a.SEGMENT1 = @p_division_id
		   AND a.SEGMENT2 = @p_plan_type
		;

		--2. frozen(TE) 변수 Validation Check
		IF @v_te_frozen_yn IS NULL OR @v_te_frozen_yn != 'N'
			BEGIN
				SET @v_te_frozen_yn = 'Y';
			END

		SET @v_log_type = 'TXN';
        SET @v_log_message = '1 START';
        SET @v_description = N'1. th_eng_bod_sn DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        DELETE /* PR_SCP_ENG_EE_PRE_PROC_BOD */ 
        FROM  th_eng_bod_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        ;

		SET @v_log_type = 'TXN';
        SET @v_log_message = '2 START';
        SET @v_description = N'2. th_eng_bod_sn INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 1. BOD INSERT
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_BOD */ th_eng_bod_sn
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
             -- 20181207  fixed_term컬럼부분 수정시 FIXED_PLAN의 SEMI처리부분(현재 fixed_term이 내부site일때 값이 0이므로 주석처리되어있음)도 동시반영해야함
			 -- 20240617 KSG : PI 요청으로 Company_id 기준으로 변경함
             --, CASE WHEN (mse.site_id <> mst.site_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') 
             , CASE WHEN (mse.company_id <> mst.company_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') 
                         THEN ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0))
                    ELSE 0
               END                                                AS fixed_term -- 20180410 수정 (변경전 : , ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0) )  AS fixed_term )
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
               LEFT JOIN  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                           SELECT scm_site_id, item_id, lt_day, lt_operation
                           FROM   scp_mst_operation_lt a WITH (NOLOCK)
                                , scm_mst_division    di WITH(NOLOCK)
                           WHERE  di.division_id    =  a.division_id
                           AND    di.valid_yn       = 'Y' 
                           AND    a.lt_operation    = 'SLITTING'
                           AND    di.attribute3     IN ( '40', '81', '82')   -- 2022.04.04컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                           AND    di.attribute4     =  @v_division_comp  -- 회사코드

                            /* 20220404 변경전
                           SELECT scm_site_id, item_id, lt_day, lt_operation
                           FROM   scp_mst_operation_lt WITH (NOLOCK)
                           WHERE  lt_operation = 'SLITTING'
                           AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
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

		-----------------------------------------------------------
        -- 2. TE frozen = N 인 경우는 FIXED_TERM 모두 미생성, 2021.09.03
        -----------------------------------------------------------
		IF @v_te_frozen_yn = 'N'			
			BEGIN
			
				-- TXN LOG
				SET @v_log_type = 'TXN';
				SET @v_log_message = '3 START';
				SET @v_description = N'3. [TE]th_eng_bod_sn의 Fixed Term UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				UPDATE a
				   SET a.fixed_term = 0
				  FROM th_eng_bod_sn a
				 WHERE a.master_id  = @p_master_id
				   AND a.plan_id    = @p_engine_plan_id
				;
			END


		-----------------------------------------------------------
        -- 3. Transport_time < 0 인 경우에는 0 으로 변경. 2021.11.29 
        -----------------------------------------------------------	
			BEGIN

				-- TXN LOG
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'PART 3-1 START';
				SET @v_description = N'3-1. th_eng_bod_sn의 transport_time 음수값= 0 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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



             
