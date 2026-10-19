
/*
 * Program ID   : PR_SCP_ENG_OUT_PEGGING_INFO
 * Description  : SCP 엔진에서 수행된 pegging info 정보를 처리하여 SDB에 적재한다.
 * OutTable     : scp_eng_pegging_info_o
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.04   yydok          org_demand_id add
 * 2018.06.20   KSG            Rowcount 젹용 수정
 * 2020.09.22   KSG            PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합
 * 2022.03.23	KSW			   GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2026.07.13   YMH            E20260622-000079 소형엔진 오류건 후속 조치 - 오류발생 상태값 체크위한 프로그램 수정 
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_OUT_PEGGING_INFO]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_OUT_PEGGING_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_PEGGING_INFO_O_TEMP';
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
        -- 0. #temp_scp_eng_pegging_info_o_sn 생성
        ----------------------------------------------------------------------------------------------------------------- 
        IF OBJECT_ID('tempdb..#temp_scp_eng_pegging_info_o_sn') IS NOT NULL
        DROP TABLE #temp_scp_eng_pegging_info_o_sn
				
        SELECT  @p_plan_id                                   AS plan_id
              , @p_modeling_id                               AS modeling_id
              , @p_seq                                       AS seq
              , @p_plan_name                                 AS plan_name
              , @p_plan_type                                 AS plan_type
              , substring(a.master_id,1,150)                 AS master_id
              , substring(a.out_version_id,1,150)            AS out_version_id
              , @p_division_id                               AS division_id
              , a.track_seq, a.demand_id, a.org_demand_id, a.demand_priority, a.due_date, a.pegging_type
              , a.bod_id, a.route_id, a.qty, a.delivery_order_id, a.work_order_id, a.stock_plan_lot_id
              , a.start_dttm, a.end_dttm, a.demand_site_id, a.demand_item_id
              , a.from_site_id, a.from_item_id, a.to_site_id, a.to_item_id
              , a.to_delivery_order_id, a.to_work_order_id, a.to_request_qty, a.plan_depth, a.plan_path

              , @p_division_id AS  ORIGIN_FROM_DIVISION_ID
              , SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))  AS SCM_FROM_SITE_ID
              , @p_division_id AS  ORIGIN_TO_DIVISION_ID
              , SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END))  AS SCM_TO_SITE_ID

              , B.ELECTRODE_TYPE
              , B.OPERATION_GROUP
              , 'PLANT_SALES'  AS ATTRIBUTE1     -- TO   SITE_TYPE
              , 'N'            AS ATTRIBUTE2     -- TO   OSP_YN 
              , A.TO_SITE_ID   AS ATTRIBUTE3     -- TO   SITE_ID 
              , A.FROM_SITE_ID AS ATTRIBUTE4     -- FROM SITE_ID
              , 'N'            AS ATTRIBUTE5     -- FROM OSP_YN
              , 'N'            AS ATTRIBUTE6     -- TO   OSP_YN
              , B.TCO_CELL_YN  AS ATTRIBUTE7     -- FROM TCO_CELL
              , B.TCO_CELL_YN  AS ATTRIBUTE8     -- TO   TCO_CELL
        INTO  #temp_scp_eng_pegging_info_o_sn
        FROM th_exp_pegging_info_sn  AS A WITH(NOLOCK)
        INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
              ON  0 = 0
              AND A.FROM_ITEM_ID = B.item_id
        WHERE  1=1
        AND    a.plan_id        = @p_engine_plan_id  
        AND    a.master_id      = @p_master_id  
        AND    a.out_version_id = @p_engine_plan_id
		
        ----------------------------------------------------------------------------------------------------------------              
        -- 1. #temp_scp_eng_pegging_info_o_sn ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
		-- 2023.03.30 IF @p_division_id IN ('EE', 'EE_UC')			-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y') 
		BEGIN
		  UPDATE X
          SET    X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE4              = ISNULL(Y.SITE_ID, '')      --TS.SITE_ID   
               , X.ATTRIBUTE5              = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
          INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN, MIN(SITE_TYPE) SITE_TYPE, MIN(SITE_ID) SITE_ID
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y 
                ON 0 = 0
                AND Y.SCM_SITE_ID = REPLACE(X.SCM_FROM_SITE_ID,'-S','')
                AND Y.VALID_YN    = 'Y'   

          UPDATE X
          SET    X.ORIGIN_TO_DIVISION_ID  = ISNULL(Z.DIVISION_ID, '')
               , X.ATTRIBUTE1             = ISNULL(Z.SITE_TYPE, '')     --TS.SITE_TYPE
               , X.ATTRIBUTE2             = ISNULL(Z.OSP_YN, '')        --TS.OSP_YN    
               , X.ATTRIBUTE3             = ISNULL(Z.SITE_ID, '')       --TS.SITE_ID   
               , X.ATTRIBUTE6             = ISNULL(Z.OSP_YN, '')        --TO OSP_YN
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                   INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN, MIN(SITE_TYPE) SITE_TYPE, MIN(SITE_ID) SITE_ID
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Z
                ON 0 = 0
                AND Z.SCM_SITE_ID = REPLACE(X.SCM_TO_SITE_ID,'-S','')
                AND Z.VALID_YN    = 'Y'         
                     
          UPDATE X
          SET    X.ATTRIBUTE8         = ISNULL(B.TCO_CELL_YN, '')   -- TO TCO_CELL
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                ON  0 = 0
                AND X.PLAN_ID         = @p_plan_id 
                AND X.MODELING_ID     = @p_modeling_id
                AND X.SEQ             = @p_seq
                AND X.PLAN_NAME       = @p_plan_name
                AND X.MASTER_ID       = @p_master_id    
                AND X.OUT_VERSION_ID  = @p_engine_plan_id   
                AND X.DIVISION_ID     = @p_division_id
                AND X.PLAN_TYPE       = @p_plan_type                  
                AND X.TO_ITEM_ID      = B.ITEM_ID
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
          SET    X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE4              = ISNULL(Y.SITE_ID, '')      --TS.SITE_ID   
               , X.ATTRIBUTE5              = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                ON 0 = 0
                AND X.DIVISION_ID = Y.DIVISION_ID
                AND Y.SCM_SITE_ID = X.SCM_FROM_SITE_ID
                AND Y.VALID_YN    = 'Y'   

          UPDATE X
          SET    X.ORIGIN_TO_DIVISION_ID  = ISNULL(Z.DIVISION_ID, '')
               , X.ATTRIBUTE1             = ISNULL(Z.SITE_TYPE, '')     --TS.SITE_TYPE
               , X.ATTRIBUTE2             = ISNULL(Z.OSP_YN, '')        --TS.OSP_YN    
               , X.ATTRIBUTE3             = ISNULL(Z.SITE_ID, '')       --TS.SITE_ID   
               , X.ATTRIBUTE6             = ISNULL(Z.OSP_YN, '')        --TO OSP_YN
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                ON 0 = 0
                AND X.DIVISION_ID = Z.DIVISION_ID
                AND Z.SCM_SITE_ID = X.SCM_TO_SITE_ID
                AND Z.VALID_YN    = 'Y'         
                     
          UPDATE X
          SET    X.ATTRIBUTE8         = ISNULL(B.TCO_CELL_YN, '')   -- TO TCO_CELL
          FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
          INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                ON  0 = 0
                AND X.PLAN_ID         = @p_plan_id 
                AND X.MODELING_ID     = @p_modeling_id
                AND X.SEQ             = @p_seq
                AND X.PLAN_NAME       = @p_plan_name
                AND X.MASTER_ID       = @p_master_id    
                AND X.OUT_VERSION_ID  = @p_engine_plan_id   
                AND X.DIVISION_ID     = @p_division_id
                AND X.PLAN_TYPE       = @p_plan_type                  
                AND X.TO_ITEM_ID      = B.ITEM_ID
	    END; -- IF @p_division_id <> 'EE'

        ----------------------------------------------------------------------------------------------------------------
        -- 2. ENG OUT -> OUT_TEMP 테이블 데이터 적재
        ----------------------------------------------------------------------------------------------------------------
        DELETE FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN    WHERE division_id = @p_division_id     --'81'

        INSERT INTO SCP_ENG_PEGGING_INFO_O_TEMP_SN
                (
                 PLAN_ID
                ,MODELING_ID
                ,SEQ
                ,PLAN_NAME
                ,MASTER_ID
                ,OUT_VERSION_ID
                ,DEMAND_ID
                ,ORG_DEMAND_ID
                ,TRACK_SEQ
                ,DIVISION_ID
                ,PLAN_TYPE
                ,DEMAND_PRIORITY
                ,DUE_DATE
                ,PEGGING_TYPE
                ,BOD_ID
                ,ROUTE_ID
                ,QTY
                ,DELIVERY_ORDER_ID
                ,WORK_ORDER_ID
                ,STOCK_PLAN_LOT_ID
                ,START_DTTM
                ,END_DTTM
                --,DEMAND_SITE_ID
                --,DEMAND_ITEM_ID
                ,ORIGIN_FROM_DIVISION_ID
                ,FROM_SITE_ID
                ,SCM_FROM_SITE_ID
                ,FROM_ITEM_ID
                ,ORIGIN_TO_DIVISION_ID
                ,TO_SITE_ID
                ,SCM_TO_SITE_ID
                ,TO_ITEM_ID
                ,TO_DELIVERY_ORDER_ID
                ,TO_WORK_ORDER_ID
                ,TO_REQUEST_QTY
                ,PLAN_DEPTH
                ,ELECTRODE_TYPE
                ,OPERATION_GROUP
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE            
                ,ATTRIBUTE1  --TS.SITE_TYPE
                ,ATTRIBUTE2  --TS.OSP_YN
                ,ATTRIBUTE3  --TS.SITE_ID
                ,ATTRIBUTE4  --FS.SITE_ID
                ,ATTRIBUTE5  -- FROM   OSP_YN
                ,ATTRIBUTE6  -- TO   OSP_YN
                ,ATTRIBUTE7  -- FROM TCO_CELL
                ,ATTRIBUTE8  -- TO   TCO_CELL
                )

        SELECT A.PLAN_ID
                ,A.MODELING_ID
                ,A.SEQ
                ,A.PLAN_NAME
                ,A.MASTER_ID
                ,A.OUT_VERSION_ID
                ,A.DEMAND_ID
                ,A.ORG_DEMAND_ID
                ,A.TRACK_SEQ
                ,A.DIVISION_ID
                ,A.PLAN_TYPE
                ,A.DEMAND_PRIORITY
                ,A.DUE_DATE
                ,A.PEGGING_TYPE
                ,A.BOD_ID
                ,A.ROUTE_ID
                ,A.QTY
                ,A.DELIVERY_ORDER_ID
                ,A.WORK_ORDER_ID
                ,A.STOCK_PLAN_LOT_ID
                ,A.START_DTTM
                ,A.END_DTTM
                ,A.ORIGIN_FROM_DIVISION_ID
                ,A.FROM_SITE_ID
                ,A.SCM_FROM_SITE_ID
                ,A.FROM_ITEM_ID
                ,A.ORIGIN_TO_DIVISION_ID
                ,A.TO_SITE_ID
                ,A.SCM_TO_SITE_ID
                ,A.TO_ITEM_ID
                ,A.TO_DELIVERY_ORDER_ID
                ,A.TO_WORK_ORDER_ID
                ,A.TO_REQUEST_QTY
                ,A.PLAN_DEPTH
                ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
                ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
                ,@v_batch_user                 AS CREATED_BY      
                ,GETDATE()                     AS CREATION_DATE      
                ,@v_batch_user                 AS LAST_UPDATED_BY      
                ,GETDATE()                     AS LAST_UPDATED_DATE   
                ,ISNULL(A.ATTRIBUTE1 ,'')      AS ATTRIBUTE1        --TS.SITE_TYPE
                ,ISNULL(A.ATTRIBUTE2 ,'')      AS ATTRIBUTE2        --TS.OSP_YN    
                ,ISNULL(A.ATTRIBUTE3 ,'')      AS ATTRIBUTE3        --TS.SITE_ID   
                ,ISNULL(A.ATTRIBUTE4 ,'')      AS ATTRIBUTE4        --FS.SITE_ID   
                ,ISNULL(A.ATTRIBUTE5 ,'')      AS ATTRIBUTE5        --FROM   OSP_YN
                ,ISNULL(A.ATTRIBUTE6 ,'')      AS ATTRIBUTE6        --TO   OSP_YN
                ,ISNULL(A.ATTRIBUTE7 ,'')      AS ATTRIBUTE7        --FROM TCO_CELL
                ,ISNULL(A.ATTRIBUTE8 ,'')      AS ATTRIBUTE8        --TO   TCO_CELL
        FROM   #temp_scp_eng_pegging_info_o_sn  AS A WITH(NOLOCK)
        WHERE  1=1
        AND    A.PLAN_ID         = @p_plan_id
        AND    A.MODELING_ID     = @p_modeling_id
        AND    A.SEQ             = @p_seq
        AND    A.PLAN_NAME       = @p_plan_name
        AND    A.MASTER_ID       = @p_master_id    
        AND    A.OUT_VERSION_ID  = @p_engine_plan_id  
        AND    A.DIVISION_ID     = @p_division_id
        AND    A.PLAN_TYPE       = @p_plan_type     
	    ;		

   /* -- 20200922  PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합 : START
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_OUT_PEGGING_INFO_OUT */
        FROM  scp_eng_pegging_info_o_sn
        WHERE 1=1
        AND   division_id = @p_division_id  
        AND   plan_id     = @p_plan_id  
        AND   plan_type   = @p_plan_type  
        AND   seq         = @p_seq  
        AND   modeling_id = @p_modeling_id  
        ;   

        INSERT INTO /*  PR_SCP_ENG_OUT_PEGGING_INFO_OUT */ scp_eng_pegging_info_o_sn
            ( plan_id
            , modeling_id
            , seq
            , plan_name
            , plan_type
            , master_id
            , out_version_id
            , division_id
            , track_seq, demand_id, org_demand_id, demand_priority, due_date, pegging_type
            , bod_id, route_id, qty, delivery_order_id, work_order_id, stock_plan_lot_id
            , start_dttm, end_dttm, demand_site_id, demand_item_id
            , from_site_id, from_item_id, to_site_id, to_item_id
            , to_delivery_order_id, to_work_order_id, to_request_qty, plan_depth, plan_path
            , creation_date, created_by, last_update_date, last_updated_by
        )
        SELECT  @p_plan_id                                   as plan_id
              , @p_modeling_id                               as modeling_id
              , @p_seq                                       as seq
              , @p_plan_name                                 as plan_name
              , @p_plan_type                                 as plan_type
              , substring(a.master_id,1,150)                 as master_id
              , substring(a.out_version_id,1,150)            as out_version_id
              , @p_division_id
              , a.track_seq, a.demand_id, a.org_demand_id, a.demand_priority, a.due_date, a.pegging_type
              , a.bod_id, a.route_id, a.qty, a.delivery_order_id, a.work_order_id, a.stock_plan_lot_id
              , a.start_dttm, a.end_dttm, a.demand_site_id, a.demand_item_id
              , a.from_site_id, a.from_item_id, a.to_site_id, a.to_item_id
              , a.to_delivery_order_id, a.to_work_order_id, a.to_request_qty, a.plan_depth, a.plan_path
              , GETDATE(), 'scp_batch', GETDATE(), 'scp_batch'
         FROM   th_exp_pegging_info_sn a WITH (NOLOCK)  
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
        IF OBJECT_ID('tempdb..#temp_scp_eng_pegging_info_o_sn') IS NOT NULL
        DROP TABLE #temp_scp_eng_pegging_info_o_sn

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

		-- 2018.06.20 : Output Data 가 0건이면 Error 처리
        IF @n_log_count <= 0
          BEGIN
            
            -- E20260622-000079 추가로 수요없을때 엔진 오류 안나게 수정.
            -- OUT DATA 가 0건이고 수요정보가 있을때 ERROR 처리.
            IF EXISTS (
                SELECT * FROM dm_pln_net_demand WITH(NOLOCK)
                WHERE 1 = 1
                AND DIVISION_ID IN
                (
                    -- 1.전극이 아닌 DIV 가져오기.
                    -- 2. 40,81,82 인경우 해당건 한개.
                    SELECT  DIVISION_ID 
                    FROM    SCM_MST_DIVISION WITH(NOLOCK)
                    WHERE   1 = 1 
                    AND ATTRIBUTE4 IN
                    (
	                    SELECT ATTRIBUTE4
	                    FROM SCM_MST_DIVISION WITH(NOLOCK)
	                    WHERE 1 = 1 
	                    AND VALID_YN	    = 'Y'
	                    AND DIVISION_ID		= @p_division_id
                    )
                    AND ATTRIBUTE3 != 'EE'
                    AND (
                    (	
	                    @p_division_id IN ('40','81','82')
	                    AND @p_division_id = DIVISION_ID
                    )
                    OR 
	                    @p_division_id NOT IN ('40','81','82')	
                    )
                )
                AND CUTOFF_YYYYMMDD >= @v_cur_monday
            )
            BEGIN
                -- ERROR LOG
                SET @v_log_type = 'ERROR';
                SET @v_log_message = 'Output Data';
                SET @v_description = N'Output Data 0건' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                return -1
            END
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
