  
/*  
 * Program ID   : PR_SCP_ENG_OUT_DELIVERY  
 * Description  : SCP 엔진에서 수행된 Delivery 정보를 처리하여 SDB에 적재한다.  
 * OutTable     : scp_eng_delivery_o  
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2017.11.21   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.06.20   KSG            Rowcount 젹용 수정 
 * 2020.09.22   KSG            PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합
 * 2022.03.23	KSW			   GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2026.07.13   YMH            E20260622-000079 소형엔진 오류건 후속 조치 - 오류발생 상태값 체크위한 프로그램 수정 
 */  
  
CREATE PROCEDURE [dbo].[PR_SCP_ENG_OUT_DELIVERY]  
    ( @p_plan_cycle1     NVARCHAR(150)
    , @p_plan_name1      NVARCHAR(4000)
    , @p_plan_id1        NVARCHAR(4000)
    , @p_modeling_id1    NVARCHAR(4000)
    , @p_seq1            NVARCHAR(4000)
    , @p_plan_type1      NVARCHAR(4000)
    , @p_master_id1      NVARCHAR(4000)
    , @p_division_id1    NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000) 
    --, @p_debug       INT OUTPUT  
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_OUT_DELIVERY';  
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count    INTEGER = 0;  
    DECLARE @v_log_message  NVARCHAR(1000);  
    DECLARE @v_description  NVARCHAR(500);  
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_DELIVERY_O_TEMP';  
    DECLARE @d_event_date   DATETIME;  
  
    DECLARE @n_pre_plan_id       INTEGER = 0;  
    DECLARE @n_cur_plan_id       INTEGER = 0;  
    DECLARE @n_pre_week_plan_id  INTEGER = 0;  
    DECLARE @n_cur_week_plan_id  INTEGER = 0;  
    -- DECLARE @v_division_id       NVARCHAR(30);  
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8)  
            , DATEADD(DD  
            , -7  
            , dbo.FN_NEXT_DAY(GETDATE()  
            , 'MON'))  
            , 112); -- 당주 월요일 YYYYMMDD  
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
        -- 0. #tmp_scp_eng_delivery_o_sn 생성
        -----------------------------------------------------------------------------------------------------------------  
        IF OBJECT_ID('tempdb..#tmp_scp_eng_delivery_o_sn') IS NOT NULL
        DROP TABLE #tmp_scp_eng_delivery_o_sn

        SELECT DISTINCT @p_plan_id                        AS plan_id  
              , @p_modeling_id                            AS modeling_id  
              , @p_seq                                    AS seq  
              , @p_plan_name                              AS plan_name  
              , @p_plan_type                              AS plan_type  
              , substring(a.master_id,1,150)              AS master_id  
              , substring(a.out_version_id,1,150)         AS out_version_id  
              , @p_division_id                            AS division_id 
              , a.item_id  
              , a.operation_qty  
              , a.complete_qty  
              , a.allocation_qty  
              , a.from_site_id  
              , a.to_site_id  
              ,(CASE WHEN dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') = 'x' THEN NULL ELSE dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') END) AS BOD_ID
              , a.start_time  
              , a.end_time  
              , a.order_id  
              , a.fix_type  
              , a.demand_id  
              , a.org_demand_id  
              , a.demand_type  
              , ISNULL(A.LPST, A.EPST)  AS LPST
              , ISNULL(A.EPST, A.LPST)  AS EPST
              , @p_division_id AS ORIGIN_FROM_DIVISION_ID
              , @p_division_id AS ORIGIN_TO_DIVISION_ID
              , B.ELECTRODE_TYPE
              , B.OPERATION_GROUP
              , SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))  AS SCM_FROM_SITE_ID
              , SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END))  AS SCM_TO_SITE_ID
              , CASE  WHEN   (A.FROM_SITE_ID  like '_____E~***'  AND A.TO_SITE_ID    like '%E~002')   THEN  'SLITTING'     
                      WHEN   (A.FROM_SITE_ID  like '_____E~002'  AND A.TO_SITE_ID    like '%E~003')   THEN  'E_MOVE_WH'     
                      WHEN   (A.FROM_SITE_ID  like '%-A~***'     AND A.TO_SITE_ID    like '%A~001')   THEN  'FORMING'     
                      WHEN   (A.FROM_SITE_ID  like '_____A~001'  AND A.TO_SITE_ID    like '%A~002')   THEN  'CHARING'     
                      WHEN   (A.FROM_SITE_ID  like '_____A~002'  AND A.TO_SITE_ID    like '%A~003')   THEN  'A_MOVE_WH'    
                      WHEN   (A.FROM_SITE_ID  like '_____P~***'  AND A.TO_SITE_ID    like '%P~003')   THEN  'P_MOVE_WH'     
                      ELSE '-' 
                END            AS  ATTRIBUTE4     -- Stock Type : Plant Onhand용 
              , 'N'            AS  ATTRIBUTE5     -- FROM OSP_YN
              , 'N'            AS  ATTRIBUTE6     -- TO   OSP_YN
              , B.TCO_CELL_YN  AS  ATTRIBUTE7     -- FROM TCO_CELL
        INTO   #tmp_scp_eng_delivery_o_sn
        FROM   th_exp_delivery_sn A WITH (NOLOCK) 
        INNER JOIN SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) 
              ON  0 = 0
              AND A.ITEM_ID     = B.item_id
        WHERE  1=1
        AND    a.plan_id        = @p_engine_plan_id  
        AND    a.master_id      = @p_master_id  
        AND    a.out_version_id = @p_engine_plan_id
		
        ----------------------------------------------------------------------------------------------------------------              
        -- 1. #tmp_scp_eng_delivery_o_sn ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
		-- 2023.03.30 IF @p_division_id IN ('EE', 'EE_UC')		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y') 
		BEGIN
          UPDATE X
          SET    X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE5              = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
          INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y 
                ON 0 = 0
                AND Y.SCM_SITE_ID = X.SCM_FROM_SITE_ID
                AND Y.VALID_YN    = 'Y'   

          UPDATE X
          SET X.ORIGIN_TO_DIVISION_ID = ISNULL(Z.DIVISION_ID, '')
            , X.ATTRIBUTE6            = ISNULL(Z.OSP_YN, '')       --TO   OSP_YN
          FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
          --INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                   INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Z
                ON 0 = 0  
                AND Z.SCM_SITE_ID = REPLACE(X.SCM_TO_SITE_ID,'-S','') -- 속도는?
                AND Z.VALID_YN    = 'Y'  
	    END; -- IF @p_division_id = 'EE'

		-- 2023.03.30 IF @p_division_id NOT IN ('EE', 'EE_UC')			-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가	<-- IF @p_division_id <> 'EE'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3 != 'EE'
					 AND VALID_YN	 = 'Y' ) 
		BEGIN
          UPDATE X
          SET    X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID, '')
               , X.ATTRIBUTE5              = ISNULL(Y.OSP_YN, '')       --FROM OSP_YN
          FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                ON 0 = 0
                AND Y.DIVISION_ID = X.DIVISION_ID
                AND Y.SCM_SITE_ID = X.SCM_FROM_SITE_ID
                AND Y.VALID_YN    = 'Y'   

          UPDATE X
          SET X.ORIGIN_TO_DIVISION_ID = ISNULL(Z.DIVISION_ID, '')
            , X.ATTRIBUTE6            = ISNULL(Z.OSP_YN, '')       --TO   OSP_YN
          FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
          INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                ON 0 = 0  
                AND Z.DIVISION_ID = X.DIVISION_ID
                AND Z.SCM_SITE_ID = X.SCM_TO_SITE_ID
                AND Z.VALID_YN    = 'Y'  
	    END; -- IF @p_division_id <> 'EE'
		
        ----------------------------------------------------------------------------------------------------------------
        -- 2. ENG OUT -> OUT_TEMP 테이블 데이터 적재
        ----------------------------------------------------------------------------------------------------------------
        DELETE FROM SCP_ENG_DELIVERY_O_TEMP_SN        WHERE division_id = @p_division_id     --'81'

        INSERT INTO SCP_ENG_DELIVERY_O_TEMP_SN
              (
               PLAN_ID
              ,MODELING_ID
              ,SEQ
              ,PLAN_NAME
              ,MASTER_ID
              ,OUT_VERSION_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,FROM_SITE_ID
              ,TO_SITE_ID
              ,ITEM_ID
              ,START_TIME
              ,ORDER_ID
              ,DEMAND_ID
              ,ORG_DEMAND_ID
              ,OPERATION_QTY
              ,COMPLETE_QTY
              ,ALLOCATION_QTY
              ,END_TIME
              ,BOD_ID
              ,FIX_TYPE
              ,DEMAND_TYPE
              ,LPST
              ,EPST
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,OPERATION_GROUP
              ,SCM_FROM_SITE_ID
              ,SCM_TO_SITE_ID
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE 
              ,ATTRIBUTE1           -- SEMI_YN
              ,ATTRIBUTE2           -- SP_Flag
              ,ATTRIBUTE3           -- P_Flag 
              ,ATTRIBUTE4           -- Stock Type : Plant Onhand용 
              ,ATTRIBUTE5           -- FROM OSP_YN
              ,ATTRIBUTE6           -- TO OSP_YN     
              ,ATTRIBUTE7           -- FROM TCO_CELL     
              )
        SELECT 
               A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.FROM_SITE_ID
              ,A.TO_SITE_ID
              ,A.ITEM_ID
              ,A.START_TIME
              ,A.ORDER_ID
              ,A.DEMAND_ID
              ,A.ORG_DEMAND_ID
              ,A.OPERATION_QTY
              ,A.COMPLETE_QTY
              ,A.ALLOCATION_QTY
              ,A.END_TIME
              ,A.BOD_ID
              ,A.FIX_TYPE
              ,A.DEMAND_TYPE
              ,A.LPST
              ,A.EPST
              ,A.ORIGIN_FROM_DIVISION_ID
              ,A.ORIGIN_TO_DIVISION_ID
              ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
              ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
              ,A.SCM_FROM_SITE_ID
              ,A.SCM_TO_SITE_ID
              ,@v_batch_user                 AS CREATED_BY      
              ,GETDATE()                     AS CREATION_DATE      
              ,@v_batch_user                 AS LAST_UPDATED_BY      
              ,GETDATE()                     AS LAST_UPDATED_DATE 
              ,ISNULL(dbo.FN_GET_SEMI_YN(A.ORIGIN_FROM_DIVISION_ID, A.SCM_FROM_SITE_ID, A.ORIGIN_TO_DIVISION_ID, A.SCM_TO_SITE_ID) ,'') AS ATTRIBUTE1  --SEMI_YN
              ,ISNULL((CASE  WHEN SUBSTRING(TO_SITE_ID,CHARINDEX('~', A.TO_SITE_ID)+1,3) NOT IN ('001','002','003') THEN 'S'  -- 출하
                             WHEN (A.ATTRIBUTE5 = 'Y' /* AND A.ATTRIBUTE7 ='Y'*/ )                                       THEN 'S'  -- 출하  FROM_OSP_YN <> 'N' , TCO_CELL_YN(FROM) ='Y'
--                             WHEN (A.FROM_SITE_ID LIKE '____-P%')                                                 THEN 'S'  -- 팩일 경우 무조건 출하
                             WHEN SUBSTRING(A.TO_SITE_ID,CHARINDEX('~', A.TO_SITE_ID)-1 ,6) IN ('A~001','A~002')    THEN 'P'  -- 생산 
                             ELSE '-' END) ,'') AS ATTRIBUTE2 --SP_Flag     -- 출하계획/생산계획구분  
              ,ISNULL(SUBSTRING(TO_SITE_ID,CHARINDEX('~', TO_SITE_ID)-1,6) ,'') AS ATTRIBUTE3 -- P_Flag
              ,ISNULL(A.ATTRIBUTE4 ,'')     AS ATTRIBUTE4   -- Stock Type : Plant Onhand용 
              ,ISNULL(A.ATTRIBUTE5 ,'')     AS ATTRIBUTE5   -- FROM OSP_YN
              ,ISNULL(A.ATTRIBUTE6 ,'')     AS ATTRIBUTE6   -- TO OSP_YN    
              ,ISNULL(A.ATTRIBUTE7 ,'')     AS ATTRIBUTE7   -- FROM TCO_CELL
        FROM   #tmp_scp_eng_delivery_o_sn A WITH (NOLOCK) 
        WHERE  1=1
        AND A.PLAN_ID         = @p_plan_id
        AND A.MODELING_ID     = @p_modeling_id
        AND A.SEQ             = @p_seq
        AND A.PLAN_NAME       = @p_plan_name
        AND A.MASTER_ID       = @p_master_id    
        AND A.OUT_VERSION_ID  = @p_engine_plan_id  
        AND A.DIVISION_ID     = @p_division_id
        AND A.PLAN_TYPE       = @p_plan_type  
		;		
  
   /* -- 20200922  PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합 : START
        -----------------------------------------------------------  
        DELETE /* PR_SCP_ENG_OUT_DELIVERY_OUT */  
        FROM  scp_eng_delivery_o_sn  
        WHERE 1=1  
        AND   division_id = @p_division_id  
        AND   plan_id     = @p_plan_id  
        AND   plan_type   = @p_plan_type  
        AND   seq         = @p_seq  
        AND   modeling_id = @p_modeling_id  
        ;   
  
        INSERT INTO /* PR_SCP_ENG_OUT_DELIVERY_OUT */ scp_eng_delivery_o_sn  
            ( plan_id  
            , modeling_id  
            , seq  
            , plan_name  
            , plan_type  
            , master_id  
            , out_version_id  
            , division_id  
            , item_id  
            , operation_qty  
            , complete_qty  
            , allocation_qty  
            , from_site_id  
            , to_site_id  
            , start_time  
            , end_time  
            , bod_id  
            , order_id 
            , fix_type  
            , demand_id 
            , org_demand_id 
            , demand_type 
            , lpst  
            , epst  
            , creation_date  
            , created_by  
            , last_update_date  
            , last_updated_by  
        )  
        SELECT DISTINCT @p_plan_id                        as plan_id  
              , @p_modeling_id                            as modeling_id  
              , @p_seq                                    as seq  
              , @p_plan_name                              as plan_name  
              , @p_plan_type                              as plan_type  
              , substring(a.master_id,1,150)              as master_id  
              , substring(a.out_version_id,1,150)         as out_version_id  
              , @p_division_id  
              , a.item_id  
              , a.operation_qty  
              , a.complete_qty  
              , a.allocation_qty  
              , a.from_site_id  
              , a.to_site_id  
              , a.start_time  
              , a.end_time  
              , a.bod_id  
              , a.order_id  
              , a.fix_type  
              , a.demand_id  
              , a.org_demand_id  
              , a.demand_type  
              , a.lpst  
              , a.epst  
              , GETDATE()  
              , 'scp_batch'  
              , GETDATE()  
              , 'scp_batch'  
         FROM   th_exp_delivery_sn a WITH (NOLOCK)    
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
        IF OBJECT_ID('tempdb..#tmp_scp_eng_delivery_o_sn') IS NOT NULL
        DROP TABLE #tmp_scp_eng_delivery_o_sn
  
        IF @@TRANCOUNT > 0  
          BEGIN  
            COMMIT WORK;  
          END;  

        -- E20260622-000079 소형엔진 오류건 후속 조치 - 오류발생 상태값 체크위한 프로그램 수정 
        -- 엔진이 에러를 뱉어내면 오류처리.
        IF EXISTS(
            SELECT * FROM [TH_ENG_PLAN_STATUS_SN] WITH(NOLOCK)
            WHERE   MASTER_ID       = @P_MASTER_ID
            AND     PLAN_ID         = @P_ENGINE_PLAN_ID
            AND     OUT_VERSION_ID  = @P_ENGINE_PLAN_ID
            AND     PLAN_STATUS     = 'ERROR'
        )
        BEGIN
            -- ERROR LOG
            SET @v_log_type = 'ERROR';
            SET @v_log_message = 'ENGINE ERROR';
            SET @v_description = N'ENGINE ERROR 종료' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            return -1            
        END

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
            ELSE
            BEGIN
                   DECLARE @MESSAGE NVARCHAR(200)
                   SET @MESSAGE = N'NO DEMAND 엔진 수행 ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		           EXEC SCM_ADM_SMS_SEND_BATCH 60, @message	
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
