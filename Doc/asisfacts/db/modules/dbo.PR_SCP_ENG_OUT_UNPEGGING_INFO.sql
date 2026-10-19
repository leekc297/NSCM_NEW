
/*
 * Program ID   : PR_SCP_ENG_OUT_UNPEGGING_INFO
 * Description  : SCP 엔진에서 수행된 unpegging info 정보를 처리하여 SDB에 적재한다.
 * OutTable     : scp_eng_unpegging_info_o_sn
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.17   KSG            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.09.22   KSG            PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합
 * 2022.03.23	KSW			   GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_OUT_UNPEGGING_INFO]
    ( @p_plan_cycle1     NVARCHAR(150)
    , @p_plan_name1      NVARCHAR(4000)
    , @p_plan_id1        NVARCHAR(4000)
    , @p_modeling_id1    NVARCHAR(4000)
    , @p_seq1            NVARCHAR(4000)
    , @p_plan_type1      NVARCHAR(4000)
    , @p_master_id1      NVARCHAR(4000)
    , @p_division_id1    NVARCHAR(30)
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
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_OUT_UNPEGGING_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_UNPEGGING_INFO_O_TEMP';
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
        ----------------------------------------------------------------------------------------------------------------
        -- 0. #temp_scp_eng_unpegging_info_o_sn 생성
        ----------------------------------------------------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#temp_scp_eng_unpegging_info_o_sn') IS NOT NULL
        DROP TABLE #temp_scp_eng_unpegging_info_o_sn

        SELECT @p_plan_id                                   AS plan_id
             , @p_modeling_id                               AS modeling_id
             , @p_seq                                       AS seq
             , @p_plan_name                                 AS plan_name
             , substring(a.master_id,1,150)                 AS master_id
             , substring(a.out_version_id,1,150)            AS out_version_id
             , @p_division_id                               AS division_id
             , @p_plan_type                                 AS plan_type

             , a.delivery_order_id, a.work_order_id, a.bod_id, a.route_id, a.site_id, a.item_id
             , a.operation_qty, a.complete_qty, a.start_dttm, a.end_dttm, a.from_site_id			  
			  
             , @p_division_id AS  ORIGIN_DIVISION_ID
             , B.ELECTRODE_TYPE
             , B.OPERATION_GROUP
             , SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))   AS FROM_SCM_SITE_ID
             , SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END))   AS TO_SCM_SITE_ID
             , 'N'             AS  ATTRIBUTE5      -- FROM OSP_YN
             , 'N'             AS  ATTRIBUTE6      --   TO OSP_YN
             , B.TCO_CELL_YN   AS  ATTRIBUTE8      --   TO TCO_CELL
        INTO   #temp_scp_eng_unpegging_info_o_sn
        FROM   th_exp_unpegging_info_sn A WITH(NOLOCK)
        INNER JOIN SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) 
              ON  0 = 0
              AND A.ITEM_ID     = B.item_id
        WHERE  1=1
        AND    a.plan_id        = @p_engine_plan_id  
        AND    a.master_id      = @p_master_id  
        AND    a.out_version_id = @p_engine_plan_id

        ----------------------------------------------------------------------------------------------------------------             
        -- 1. #temp_scp_eng_unpegging_info_o_sn ORIGIN_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
		-- 2023.03.30 IF @p_division_id IN ('EE', 'EE_UC')			-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y' ) 
		BEGIN
          UPDATE X
          SET    X.ORIGIN_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE5         = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM   #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)  
          INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y      
                ON  0 = 0
                AND Y.SCM_SITE_ID = REPLACE(X.FROM_SCM_SITE_ID,'-S','')
                AND Y.VALID_YN    = 'Y'  
                      
          UPDATE X
          SET    X.ORIGIN_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE6         = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM   #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                   INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y       
                ON  0 = 0 
                AND Y.SCM_SITE_ID = REPLACE(X.TO_SCM_SITE_ID,'-S','')
                AND Y.VALID_YN    = 'Y'   
	    END; -- IF @p_division_id = 'EE'

		-- 2023.03.30 IF @p_division_id NOT IN ('EE', 'EE_UC')			-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가 <-- IF @p_division_id <> 'EE'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3 != 'EE'
					 AND VALID_YN	 = 'Y') 
		BEGIN
          UPDATE X
          SET    X.ORIGIN_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE5         = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM   #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                ON  0 = 0
                AND X.DIVISION_ID = Y.DIVISION_ID
                AND Y.SCM_SITE_ID = X.FROM_SCM_SITE_ID
                AND Y.VALID_YN    = 'Y'  
                      
          UPDATE X
          SET    X.ORIGIN_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE6         = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM   #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                ON  0 = 0 
                AND X.DIVISION_ID = Y.DIVISION_ID
                AND Y.SCM_SITE_ID = X.TO_SCM_SITE_ID
                AND Y.VALID_YN    = 'Y'   
	    END; -- IF @p_division_id <> 'EE'
		
        ----------------------------------------------------------------------------------------------------------------
        -- 2. ENG OUT -> OUT_TEMP 테이블 데이터 적재
        ----------------------------------------------------------------------------------------------------------------
        DELETE FROM SCP_ENG_UNPEGGING_INFO_O_TEMP_SN  WHERE division_id = @p_division_id     --'81'

		INSERT INTO SCP_ENG_UNPEGGING_INFO_O_TEMP_SN
              (
               PLAN_ID
              ,MODELING_ID
              ,SEQ
              ,PLAN_NAME
              ,MASTER_ID
              ,OUT_VERSION_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,DELIVERY_ORDER_ID
              ,WORK_ORDER_ID
              ,BOD_ID
              ,ROUTE_ID
              ,SITE_ID
              ,ITEM_ID
              ,OPERATION_QTY
              ,COMPLETE_QTY
              ,START_DTTM
              ,END_DTTM
              ,FROM_SITE_ID
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,OPERATION_GROUP
              ,SCM_SITE_ID          --TO_SCM_SITE_ID
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE8
              ) 

        SELECT A.PLAN_ID
                ,A.MODELING_ID
                ,A.SEQ
                ,A.PLAN_NAME
                ,A.MASTER_ID
                ,A.OUT_VERSION_ID
                ,A.DIVISION_ID
                ,A.PLAN_TYPE
                ,A.DELIVERY_ORDER_ID
                ,A.WORK_ORDER_ID
                ,A.BOD_ID
                ,A.ROUTE_ID
                ,A.SITE_ID
                ,A.ITEM_ID
                ,A.OPERATION_QTY
                ,A.COMPLETE_QTY
                ,A.START_DTTM
                ,A.END_DTTM
                ,A.FROM_SITE_ID
                ,A.ORIGIN_DIVISION_ID
                ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
                ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
                ,A.TO_SCM_SITE_ID
                ,@v_batch_user                 AS CREATED_BY      
                ,GETDATE()                     AS CREATION_DATE      
                ,@v_batch_user                 AS LAST_UPDATED_BY      
                ,GETDATE()                     AS LAST_UPDATED_DATE   
                ,ISNULL(A.ATTRIBUTE5 ,'')      AS ATTRIBUTE5        -- FROM OSP_YN
                ,ISNULL(A.ATTRIBUTE6 ,'')      AS ATTRIBUTE6        --   TO OSP_YN
                ,ISNULL(A.ATTRIBUTE8 ,'')      AS ATTRIBUTE8        --   TO TCO_CELL
        FROM   #temp_scp_eng_unpegging_info_o_sn AS A WITH(NOLOCK)
        WHERE  1=1
        AND    A.PLAN_ID         = @p_plan_id
        AND    A.MODELING_ID     = @p_modeling_id
        AND    A.SEQ             = @p_seq
        AND    A.PLAN_NAME       = @p_plan_name
        AND    A.MASTER_ID       = @p_master_id    
        AND    A.OUT_VERSION_ID  = @p_engine_plan_id  
        AND    A.DIVISION_ID     = @p_division_id
        AND    A.PLAN_TYPE       = @p_plan_type   

   /* -- 20200922  PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합 : START
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_OUT_UNPEGGING_INFO */
        FROM  scp_eng_unpegging_info_o_sn
        WHERE 1=1
        AND   division_id = @p_division_id  
        AND   plan_id     = @p_plan_id  
        AND   plan_type   = @p_plan_type  
        AND   seq         = @p_seq  
        AND   modeling_id = @p_modeling_id  
        ;   

        INSERT INTO /*  PR_SCP_ENG_OUT_UNPEGGING_INFO */ scp_eng_unpegging_info_o_sn
            ( plan_id
            , modeling_id
            , seq
            , plan_name
            , master_id
            , out_version_id
            , division_id
            , plan_type
            , delivery_order_id, work_order_id, bod_id, route_id, site_id, item_id
            , operation_qty, complete_qty, start_dttm, end_dttm, from_site_id
            , creation_date, created_by, last_update_date, last_updated_by
        )
        SELECT  @p_plan_id                                   AS plan_id
              , @p_modeling_id                               AS modeling_id
              , @p_seq                                       AS seq
              , @p_plan_name                                 AS plan_name
              , substring(a.master_id,1,150)                 AS master_id
              , substring(a.out_version_id,1,150)            AS out_version_id
              , @p_division_id                               AS division_id
              , @p_plan_type                                 AS plan_type
              , delivery_order_id, work_order_id, bod_id, route_id, site_id, item_id
              , operation_qty, complete_qty, start_dttm, end_dttm, from_site_id
              , GETDATE(), 'scp_batch', GETDATE(), 'scp_batch'
         FROM   th_exp_unpegging_info_sn a WITH (NOLOCK)  
         WHERE  1=1
         AND    a.plan_id        = @p_engine_plan_id  
         AND    a.master_id      = @p_master_id  
         AND    a.out_version_id = @p_engine_plan_id
         ;
	*/	 -- 20200922  PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합 : EMD

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
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#temp_scp_eng_unpegging_info_o_sn') IS NOT NULL
        DROP TABLE #temp_scp_eng_unpegging_info_o_sn

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

