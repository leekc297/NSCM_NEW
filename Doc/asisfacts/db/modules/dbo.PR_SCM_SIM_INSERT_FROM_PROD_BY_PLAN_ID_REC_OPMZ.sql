
-- ==========================================================================================
-- Program:      PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ
-- Author:       김준규
-- Create date:  2025-12-08
-- Description:  최적화 Table 데이터 PLAN_ID 별 삭제후 가져오기
-- How to Execute: EXEC PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ @P_TABLE='SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT',@P_RTYPE='';
-- EXEC PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ @P_TABLE='SCP_OPMZ_YLD_ELEC',@P_RTYPE='';
-- EXEC PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ @P_TABLE='',@P_RTYPE='';
--
-- ==========================================================================================
-- 2025-12-08       김준규       PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_SCP COPY하여 사용
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ]
   @P_TABLE nvarchar(128)=''
 , @P_RTYPE nvarchar(128)
AS
BEGIN

--################################################################################################################
--DECLARE
--################################################################################################################
    DECLARE @CNT BIGINT;
    DECLARE @WORK_SECOND BIGINT;
    DECLARE @MAPPING_RESULT NVARCHAR(2);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @YYYYMM nvarchar(10) = '';
    DECLARE @V_SCOPE_ID BIGINT;
    DECLARE @V_ROWS_INSERTED BIGINT;
    DECLARE @LinkedServerName NVARCHAR(254) = '10.34.220.85,7433';
    DECLARE @LocalServerName NVARCHAR(254) = '';
    --DECLARE @DBPrefix NVARCHAR(254) = '[LGCE_SCMPROD].[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBOPTPrefix NVARCHAR(254) = '[OPTENG_SCP].[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBLocal NVARCHAR(254) = '[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBOPTLocal NVARCHAR(254) = '[OPTENG_SCP].[DBO].';-- LINKED_SERVER 운영DB 사용

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'simulator';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SIM_INSERT_FROM_PROD_BY_PLAN_ID_REC_OPMZ';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;
    DECLARE @DUMMY          NVARCHAR(MAX);


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_RTYPE:'+@P_RTYPE;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

    --##########################
    --PLAN_ID 가져오기
    --##########################
    DECLARE @p_division_id NVARCHAR(8)='EE';
    DECLARE @QUERY_START_YYYYMMDD NVARCHAR(8);
    DECLARE @QUERY_END_YYYYMMDD NVARCHAR(8);
    SET @p_division_id = CASE WHEN ISNULL(@p_division_id,'')='' THEN 'EE' ELSE @p_division_id END;
    SELECT @QUERY_START_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY, 0, p.PLAN_NAME),112)
          ,@QUERY_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112)
    FROM   [10.34.220.88,7433].[LGCE_SCMPROD].[DBO].scm_mst_plan p WITH(NOLOCK)
    JOIN   (SELECT TOP 1 PLAN_START_YYYYMMDD FROM [10.34.220.88,7433].[LGCE_SCMPROD].[DBO].SCP_OPMZ_PLAN_M OPM WITH(NOLOCK) WHERE OPM.PROD_REF_SYS_DIVS_CD ='SCP' AND OPM.division_id = @p_division_id AND PLAN_START_YYYYMMDD >= CONVERT(NVARCHAR(8),GETDATE()-7*6,112) ORDER BY PLAN_START_YYYYMMDD DESC ) OPM ON OPM.PLAN_START_YYYYMMDD = p.PLAN_NAME
    WHERE  p.division_id = @p_division_id
    AND    p.plan_id     = (SELECT max(plan_id) FROM [10.34.220.88,7433].[LGCE_SCMPROD].[DBO].scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
    AND    p.plan_cycle  = 'WEEKLY';
    --SELECT QUERY_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112),P.*
    --FROM   dbo.scm_mst_plan p WITH(NOLOCK)
    --WHERE  p.division_id = @p_division_id
    --AND    p.plan_id     = (SELECT max(plan_id) FROM [10.34.220.88,7433].[LGCE_SCMPROD].[DBO].scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
    --AND    p.plan_cycle  = 'WEEKLY';
    PRINT '@p_division_id:'+@p_division_id;
    PRINT '@QUERY_START_YYYYMMDD:'+@QUERY_START_YYYYMMDD;
    PRINT '@QUERY_END_YYYYMMDD:'+@QUERY_END_YYYYMMDD;
    DECLARE @CONC_OPT_PLAN_ID NVARCHAR(MAX)=N'';
    SELECT @CONC_OPT_PLAN_ID=STRING_AGG(OPT_PLAN_ID,',') 
    FROM  (
          SELECT MAX(PLAN_ID) OPT_PLAN_ID
          FROM   [10.34.220.88,7433].[OPTENG_SCP].[DBO].SCP_OPT_ENG_PLAN_MASTER WITH(NOLOCK)
          WHERE  PLAN_START_DATE = @QUERY_START_YYYYMMDD
          AND    ATTRIBUTE1 = @p_division_id
          --AND    ( ATTRIBUTE2 NOT LIKE '%_C' AND ATTRIBUTE2 NOT LIKE '%_A' )
          AND    ( ATTRIBUTE2 NOT LIKE '%[_]C' AND ATTRIBUTE2 NOT LIKE '%[_]A' )
          GROUP BY ATTRIBUTE2
    ) X;
    PRINT '@CONC_OPT_PLAN_ID:'+ISNULL(@CONC_OPT_PLAN_ID,'NULL');
    IF @CONC_OPT_PLAN_ID IS NULL BEGIN RETURN; END;
    --SELECT dbo.FN_GET_NERP_IN_VALUES( @CONC_OPT_PLAN_ID );

    ---- 해당 주차의 EE Division 중 하위 Plan Gr별 마지막 Plan ID 추출
    --SELECT ATTRIBUTE2, MAX(PLAN_ID)
    --FROM   [10.34.220.88,7433].[OPTENG_SCP].[DBO].SCP_OPT_ENG_PLAN_MASTER WITH(NOLOCK)
    --WHERE  PLAN_START_DATE = @QUERY_START_YYYYMMDD
    --AND    ATTRIBUTE1 = @p_division_id
    --AND    ( ATTRIBUTE2 NOT LIKE '%_C' AND ATTRIBUTE2 NOT LIKE '%_A' )
    --AND    ( ATTRIBUTE2 NOT LIKE '%[_]C' AND ATTRIBUTE2 NOT LIKE '%[_]A' )
    --GROUP BY ATTRIBUTE2
    ;
    ---- 각 PLAN ID 별로 운영 -> 개발  최적화 엔진 관련 DATA 이전
    --DECLARE @GM_EE_PLAN_ID NVARCHAR(100) = '20251201_EE_ESWA_ED_001'
    --DECLARE @GM_PLAN_ID    NVARCHAR(100) = ''
;

    --##########################
    --##########################
    -- 테이블 이름
    DECLARE @C_RTYPE NVARCHAR(30)
    DECLARE @C_TABLE_NAME NVARCHAR(128)
    DECLARE @C_PLAN_ID_COL NVARCHAR(128)
    DECLARE @C_LocalDB NVARCHAR(128)
    DECLARE @C_RemoteDB NVARCHAR(128)
    DECLARE @C_COLUMNLIST NVARCHAR(MAX)
    DECLARE @C_IS_IDENTITY_YN NVARCHAR(1)
    DECLARE @C_IS_TBL_COLS_YN NVARCHAR(1)
    DECLARE @ColumnsToSelect NVARCHAR(MAX)='';
    DECLARE @crlf          CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos           INT;
    DECLARE @SQL NVARCHAR(MAX)=''
    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END
    DECLARE mig_cursor CURSOR FOR
        WITH W_OPMZ_RAW AS (
            SELECT TRIM('SCP_OPMZ_PLAN_M                          ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'OPMZ_PLAN_ID' AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_ANL_PRODUCTION_PLAN                  ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_ANL_SHIPMENT_PLAN_SEMI               ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_LINE_OSP                         ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_MODEL_BOM                        ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_DIVISION                         ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_ITEM_CLASS_M                     ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_PLAN                             ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_PLAN_DETAIL                      ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_MST_SITE                             ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_SYS_CALENDAR_M                       ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_MST_BOM_ELEC                         ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_MST_CELL_PROD_ASSY_MAP               ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_MST_FINAL_ITEM                       ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPMZ_PLAN_GR_M                       ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPMZ_PLAN_GR_LINE_M                  ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPMZ_LOOKUP_MASTER_DETAIL            ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPMZ_YLD_ELEC                        ') AS OPMZ_TABLE_NAME, '[LGCE_SCMDEV].[DBO].' LocalDB, '[LGCE_SCMPROD].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_ITEM_LINE_ASSIGN_M                   ') AS OPMZ_TABLE_NAME, '[LGCE_FPDEV_TR].[DBO].' LocalDB, '[LGCE_FP_TR].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_LINE_M                               ') AS OPMZ_TABLE_NAME, '[LGCE_FPDEV_TR].[DBO].' LocalDB, '[LGCE_FP_TR].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_PLANT_M                              ') AS OPMZ_TABLE_NAME, '[LGCE_FPDEV_TR].[DBO].' LocalDB, '[LGCE_FP_TR].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCM_ITEM_M                               ') AS OPMZ_TABLE_NAME, '[LGCE_FPDEV_TR].[DBO].' LocalDB, '[LGCE_FP_TR].[DBO].' RemoteDB,'INSERT'  AS PLAN_ID_COL, 01 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_BOD                          ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 02 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_BOM                          ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 03 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_BOM_ELEC                     ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 04 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_BUCKETS                      ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 05 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_COBY_PROD_ITEM               ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 06 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_DEMAND                       ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 07 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_DEMAND_ORIGIN                ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 08 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_FROZEN_MASTER                ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 09 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_FROZEN_PLAN                  ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 10 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_GOALS                        ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 11 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_INCOMING_STOCK               ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 12 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_INCOMING_STOCK_XTR           ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 13 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_ITEM_BOM_ROUTING             ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 14 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_ITEM_SITE                    ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 15 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_LOOKUP                       ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 16 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_MODEL_LIST_N                 ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 17 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OBJECTIVE_GOAL_MAPPING       ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 18 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OBJECTIVES                   ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 19 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING    ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 20 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 21 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_DEMAND_BUFFER_PEGGING_INT') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 22 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY    ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 23 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_INT') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 24 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_PRODUCTION         ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 25 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT     ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 26 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_SHIPPING           ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 27 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT       ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 28 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_PLAN_RESULT              ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 29 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_OUT_RESULT_RESOURCE          ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 30 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_PHASES                       ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 31 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_PLAN_MASTER                  ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 32 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_RESOURCE                     ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 33 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR      ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 34 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_RESOURCE_HORIZON_CALENDAR    ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 35 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_ROUTING                      ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 36 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_ROUTING_RESOURCE             ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 37 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_SAFETY_STOCK                 ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 38 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_SCHEDULED_MOVE               ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 39 AS SORT_SEQ UNION
            SELECT TRIM('SCP_OPT_ENG_SCP_PLAN_ID_M                ') AS OPMZ_TABLE_NAME, '[OPTENG_SCP].[DBO].' LocalDB , '[OPTENG_SCP].[DBO].' RemoteDB,  'PLAN_ID' AS PLAN_ID_COL, 40 AS SORT_SEQ        
        )
        SELECT TNV.OPMZ_TABLE_NAME,TNV.LocalDB,TNV.RemoteDB,TNV.PLAN_ID_COL,IIF(IDE.TBL_NM IS NOT NULL, 'Y','N') IS_IDENTITY_YN 
        FROM   W_OPMZ_RAW TNV WITH(NOLOCK)
        LEFT JOIN ( SELECT t.name AS TBL_NM,max(c.name) AS colnumn_name
                    FROM   sys.tables t WITH(NOLOCK)
                    JOIN   sys.columns c WITH(NOLOCK) ON t.object_id = c.object_id
                    WHERE  c.is_identity = 1
                    GROUP BY t.name
                  ) AS IDE
        ON TNV.OPMZ_TABLE_NAME = IDE.TBL_NM
        WHERE  1=1
        AND    (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR TNV.OPMZ_TABLE_NAME = @P_TABLE) 
        --AND        EXISTS (SELECT 1
        --                   FROM   [10.34.220.88,7433].[LGCE_SCMPROD].INFORMATION_SCHEMA.TABLES T
        --                   WHERE  T.TABLE_NAME = TNV.OPMZ_TABLE_NAME
        --                   UNION
        --                   SELECT 1
        --                   FROM   [10.34.220.88,7433].[OPTENG_SCP].INFORMATION_SCHEMA.TABLES T
        --                   WHERE  T.TABLE_NAME = TNV.OPMZ_TABLE_NAME
        --                   )
        ORDER BY TNV.SORT_SEQ,TNV.OPMZ_TABLE_NAME,TNV.LocalDB,TNV.RemoteDB

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @C_TABLE_NAME, @C_LocalDB, @C_RemoteDB, @C_PLAN_ID_COL, @C_IS_IDENTITY_YN

    WHILE @@FETCH_STATUS = 0
    BEGIN

        --LGCE_SCMTEST DB에서만 INSERT 작업한다. 그외는 아래 2개 테이블은 작업하지 않는다.
        IF @C_LocalDB NOT LIKE '%TEST%' AND @C_TABLE_NAME IN ( 'SCP_ANL_PRODUCTION_PLAN','SCP_ANL_SHIPMENT_PLAN_SEMI') BEGIN
           -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
           FETCH NEXT FROM mig_cursor INTO @C_TABLE_NAME, @C_LocalDB, @C_RemoteDB, @C_PLAN_ID_COL, @C_IS_IDENTITY_YN
           CONTINUE;
           END;

        --IF @C_TABLE_NAME = 'SCP_OPMZ_PLAN_M' BEGIN
        --SET @V_PLAN_ID_COL = 'OPMZ_PLAN_ID'; END
        --ELSE BEGIN--IF @C_TABLE_NAME = '' BEGIN
        --SET @V_PLAN_ID_COL = 'PLAN_ID'; END

        -- 동적 SQL 생성 및 실행
        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
             SUBSTRING(@C_TABLE_NAME+'|'+@C_LocalDB+'|'+@C_RemoteDB+'|'+@C_PLAN_ID_COL+'|'+@C_IS_IDENTITY_YN,1,254)
            ,'ALL'
            ,'ALL'
            ,FORMAT(GETDATE(),'yyyyMMdd')
        );
        
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

    --DECLARE @LinkedServerName NVARCHAR(254) = '10.34.220.85,7433';
    --DECLARE @LocalServerName NVARCHAR(254) = '';
    --DECLARE @DBPrefix NVARCHAR(254) = '[LGCE_SCMPROD].[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBOPTPrefix NVARCHAR(254) = '[OPTENG_SCP].[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBLocal NVARCHAR(254) = '[DBO].';-- LINKED_SERVER 운영DB 사용
    --DECLARE @DBOPTLocal NVARCHAR(254) = '[OPTENG_SCP].[DBO].';-- LINKED_SERVER 운영DB 사용

    IF @C_PLAN_ID_COL = 'INSERT' BEGIN

        DECLARE @DBPrefix NVARCHAR(254) = LEFT(@C_LocalDB, CHARINDEX('.', @C_LocalDB) )
        SET @SQL = N'
        -- 2. PK 컬럼 확인
        SELECT @ColumnsToSelect = STRING_AGG(''AND X.'' + QUOTENAME(c.name) + ''='' + '' Z.'' + QUOTENAME(c.name),'' '') WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM '+@DBPrefix+'sys.tables t
        INNER JOIN '+@DBPrefix+'sys.indexes i ON t.object_id = i.object_id
        INNER JOIN '+@DBPrefix+'sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN '+@DBPrefix+'sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.is_primary_key = 1
        AND t.name = '''+@C_TABLE_NAME+'''
        AND SCHEMA_NAME(t.schema_id) = ''dbo'' ';

        PRINT @SQL  -- 디버깅용 출력

        EXEC sp_executesql @SQL, 
             N'@ColumnsToSelect NVARCHAR(MAX) OUTPUT',
             @ColumnsToSelect = @ColumnsToSelect OUTPUT;

        PRINT '1:'+@ColumnsToSelect;

        IF @ColumnsToSelect IS NULL
        BEGIN
        SET @SQL = N'
            -- 3. PK가 없으면 전체 컬럼 사용
            SELECT @ColumnsToSelect = STRING_AGG(N''AND ISNULL(X.'' + QUOTENAME(c.name) + N'', '' + dbo.FN_GET_NERP_FORMATTED_VALUE('''+@C_TABLE_NAME+''',c.name,''N'') + N'') = '' +
                                  N''ISNULL(Z.'' + QUOTENAME(c.name) + N'', '' + dbo.FN_GET_NERP_FORMATTED_VALUE(''SCM_MST_PLAN_DETAIL'',c.name,''N'') + N'')'' ,
                                  N'' '')  WITHIN GROUP (ORDER  BY c.column_id)
            FROM '+@DBPrefix+'sys.columns c
            JOIN '+@DBPrefix+'sys.tables t ON c.object_id = t.object_id
            WHERE t.name = '''+@C_TABLE_NAME+'''
            AND SCHEMA_NAME(t.schema_id) = ''dbo'' ';

        PRINT @SQL  -- 디버깅용 출력

        EXEC sp_executesql @SQL, 
             N'@ColumnsToSelect NVARCHAR(MAX) OUTPUT',
             @ColumnsToSelect = @ColumnsToSelect OUTPUT;

        PRINT '2:'+@ColumnsToSelect;
        END;

        SET @SQL  = N'INSERT INTO '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+@crlf;
        SET @SQL += N'SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', '+@crlf;
        SET @SQL += N'''SELECT * '+@crlf;
        SET @SQL += N'FROM '+ @C_RemoteDB + QUOTENAME(@C_TABLE_NAME) +' H WITH(NOLOCK) '+@crlf;
        SET @SQL += N'WHERE 1=1'+@crlf;
    IF @C_TABLE_NAME IN ( 'SCP_ANL_PRODUCTION_PLAN','SCP_ANL_SHIPMENT_PLAN_SEMI') BEGIN
        SET @SQL += N'AND H.PLAN_START_YYYYMMDD >= CONVERT(NVARCHAR(8),DATEADD(DD,-14,GETDATE()),112)'+@crlf; 
        END;
        SET @SQL += N' '') X '+@crlf;
        SET @SQL += N'WHERE 1=1 '+@crlf;
        SET @SQL += N'AND   NOT EXISTS ( SELECT 1 '+@crlf;
        SET @SQL += N'                   FROM   '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+' Z WITH(NOLOCK) '+@crlf;
        SET @SQL += N'                   WHERE  1=1 '+@crlf;
    IF @C_TABLE_NAME IN ( 'SCP_ANL_PRODUCTION_PLAN','SCP_ANL_SHIPMENT_PLAN_SEMI') BEGIN
        SET @SQL += N'AND Z.PLAN_START_YYYYMMDD >= CONVERT(NVARCHAR(8),DATEADD(DD,-14,GETDATE()),112)'+@crlf; 
        END;
        SET @SQL += N'                   '+@ColumnsToSelect+@crlf;
        SET @SQL += N'                  ) '+@crlf;;
        SET @SQL += N'SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;';        
        
        END;

    ELSE BEGIN
        --IDENTITY 아닌 테이블
        IF @C_IS_IDENTITY_YN = 'N' BEGIN
            SET @SQL  = N'DELETE H'+@crlf;
            SET @SQL += N'FROM '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+' H'+@crlf;
            SET @SQL += N'WHERE 1=1'+@crlf;
            SET @SQL += N'AND   H.'+@C_PLAN_ID_COL+' IN ('+dbo.FN_GET_NERP_IN_VALUES( @CONC_OPT_PLAN_ID ) +');'+@crlf;
            SET @SQL += N''+@crlf;
            SET @SQL += N'INSERT INTO '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+@crlf;
            SET @SQL += N'SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', '+@crlf;
            SET @SQL += N'''SELECT * '+@crlf;
            SET @SQL += N'FROM '+ @C_RemoteDB + QUOTENAME(@C_TABLE_NAME) +' H WITH(NOLOCK) '+@crlf;
            SET @SQL += N'WHERE 1=1'+@crlf;
            SET @SQL += N'AND   H.'+@C_PLAN_ID_COL+' IN ('+REPLACE(dbo.FN_GET_NERP_IN_VALUES( @CONC_OPT_PLAN_ID ),CHAR(39),CHAR(39)+CHAR(39)) +')'+@crlf;--CHAR(34):따옴표
            SET @SQL += N' '');'+@crlf;
            SET @SQL += N'SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;';
        END
        --@C_IS_IDENTITY_YN = 'Y'
        ELSE IF @C_IS_IDENTITY_YN = 'Y' BEGIN
            -- 테이블의 전체 컬럼 목록 가져오기
            SELECT @C_COLUMNLIST = STRING_AGG(QUOTENAME(c.name), ', ')
            FROM sys.columns c WITH(NOLOCK)
            WHERE c.object_id = OBJECT_ID(@C_TABLE_NAME)

            -- 컬럼 정보 출력
            PRINT 'Processing table: ' + @C_TABLE_NAME
            PRINT 'Columns: ' + @C_COLUMNLIST

            SET @SQL  = N'DELETE H'+@crlf;
            SET @SQL += N'FROM '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+' H'+@crlf;
            SET @SQL += N'WHERE 1=1'+@crlf;
            SET @SQL += N'AND   H.'+@C_PLAN_ID_COL+' IN ('+dbo.FN_GET_NERP_IN_VALUES( @CONC_OPT_PLAN_ID ) +');'+@crlf;
            SET @SQL += N''+@crlf;
            SET @SQL += N'INSERT INTO '+@C_LocalDB + QUOTENAME(@C_TABLE_NAME)+ + ' (' + @C_COLUMNLIST + ') '+@crlf;
            SET @SQL += N'SELECT ' + @C_COLUMNLIST + ' FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', '+@crlf;
            SET @SQL += N'''SELECT ' + @C_COLUMNLIST + ' '+@crlf;
            SET @SQL += N'FROM '+ @C_RemoteDB + QUOTENAME(@C_TABLE_NAME) +' H WITH(NOLOCK) '+@crlf;
            SET @SQL += N'WHERE 1=1'+@crlf;
            SET @SQL += N'AND   H.'+@C_PLAN_ID_COL+' IN ('+REPLACE(dbo.FN_GET_NERP_IN_VALUES( @CONC_OPT_PLAN_ID ),CHAR(39),CHAR(39)+CHAR(39)) +')'+@crlf;--CHAR(34):따옴표
            SET @SQL += N' '');'+@crlf;
            SET @SQL += N'SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;';

        END
    END;
        ----@C_IS_IDENTITY_YN = 'Y'
        --ELSE BEGIN
        --    -- 테이블의 전체 컬럼 목록 가져오기
        --    SELECT @C_COLUMNLIST = STRING_AGG(QUOTENAME(c.name), ', ')
        --    FROM sys.columns c WITH(NOLOCK)
        --    WHERE c.object_id = OBJECT_ID(@C_TABLE_NAME)

        --    -- 컬럼 정보 출력
        --    PRINT 'Processing table: ' + @C_TABLE_NAME
        --    PRINT 'Columns: ' + @C_COLUMNLIST

        --    -- IDENTITY_INSERT ON과 INSERT를 하나의 sp_executesql로 실행
        --    SET @SQL = '
        --        SET IDENTITY_INSERT ' + QUOTENAME(@C_TABLE_NAME) + ' ON;
        --        TRUNCATE TABLE [LGCE_SCMDEV].DBO.' + QUOTENAME(@C_TABLE_NAME) + ';
        --        INSERT INTO ' + QUOTENAME(@C_TABLE_NAME) + ' (' + @C_COLUMNLIST + ') 
        --        SELECT ' + @C_COLUMNLIST + ' FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
        --        ''SELECT ' + @C_COLUMNLIST + ' 
        --        FROM '+ @DBPrefix + QUOTENAME(@C_TABLE_NAME) + ' WITH(NOLOCK) '');
        --        SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
        --        SET IDENTITY_INSERT ' + QUOTENAME(@C_TABLE_NAME) + ' OFF;';
        --END

        PRINT @SQL  -- 디버깅용 출력

        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL, 
                     N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                     @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;
                UPDATE FPP
                SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                      ,SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @v_description = 'Error executing SQL: ' + QUOTENAME(@C_TABLE_NAME) + '|' + @C_IS_IDENTITY_YN +@crlf + ' ' + @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @v_description+' '+@SQL
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @v_description;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

                    PRINT 'ERROR'
                    PRINT ERROR_MESSAGE();
            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH

        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @C_TABLE_NAME, @C_LocalDB, @C_RemoteDB, @C_PLAN_ID_COL, @C_IS_IDENTITY_YN
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor


    SET @BATCH_END_TIME = SYSDATETIME();
    SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
    PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  'END, RUN_TIME ', @BATCH_END_TIME;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();


END CATCH

END
