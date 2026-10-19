
/*
 * Program ID   : PR_SCP_RPT_ELEC_PSI_FOR_IF
 * Description  : MCS Task_전극Visibiltiy_Global PSI (Elec)
 * Program History
 * 
 *===================================================================================================
 * Date        In Charge       Description
 *===================================================================================================
 * 2022.12.23   sclee.lee                Initial Release
 * 2023.03.16   chaan                  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - @v_is_dev_mode(개발모드/운영모드) 구분자로 소스 통합
 * 2023.03.22   chaan          V1.1.1  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - 전체 사업부 배치작업 편의성과 파라미터 지정가능하도록 PR_SCP_RPT_ELEC_PSI, PR_SCP_RPT_ELEC_PSI_FOR_IF 로 분리
 * 2023.03.23   chaan          V1.2.1  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - 개발모드(@v_is_dev_mode) 제거
 * 2023.04.04   chaan          V1.2.2  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - EOH 산출 개선
 * 2023.04.24   chaan          V1.2.3  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - COAT_REQ 집계 로직 수정(OPERATION_GROUP 이 'A' 이면서 OPERATION_ID 가 'A' 로 시작하지 않는 것들이 있음)
 * 2023.05.09   chaan          V1.2.4  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - EOH 로직, SHIP_PLAN_WH_IN 오류 수정
 * 2023.05.15   chaan          V1.2.4  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - PKG_PLAN 추가
 * 2023.05.16   chaan          V1.2.5  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - ORG_DIVISION 및 SCM_SITE_ID 조건 추가로 데이터 중복 집계 배제 로직 추가
 * 2023.05.22   chaan          V1.2.6  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - @v_plan_to_yyyymmdd_limit 로직 수정
 * 2023.07.23   chaan          V1.2.7  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2       - PROD_PLAN_AMEND -> PROD_PLAN_ENGINE 으로 변경
 * 2023/08/11   chaan          V1.1.8  - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2     - 요일 산출 오류 수정
 * 2023/09/12   chaan          V1.1.9  - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2     - 수요일 COAT_REQ 집계 오류 수정 - SE confirm 전이라 CONFIRM_FLAG = 'Y' 조건 제외
 * 2023/09/12   chaan          V1.1.10 - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2     - 수요일 COAT_REQ 집계 오류 수정 - 40 조립계획 FN -> MA 로 수정
*/

--CREATE PROCEDURE [dbo].[PR_SCP_RPT_ELEC_PSI_FOR_IF]
CREATE PROCEDURE [dbo].[PR_SCP_RPT_ELEC_PSI_FOR_IF]
      @p_division_id1			NVARCHAR(50)
    , @p_division_id2			NVARCHAR(50)        = N'EE'
	, @p_yyyymmdd				VARCHAR(8)          = ''
    , @p_plan_type			    NVARCHAR(50)        = N'' -- 'MA' : 수요일 09시 기준 생성, 'FN' : 금요일 09시 기준 생성, 금요일은 'FN' 기준, 수요일은 사업부, 계획/재고에 따라 다름
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @v_test_mode			        VARCHAR(1)          = ''; -- 코딩 테스트용(T : 테스트모드)
    --DECLARE @v_test_mode			        VARCHAR(1)          = 'T';          -- 코딩 테스트용(T : 테스트모드)
    DECLARE @v_test_mode_item_id	        VARCHAR(50)         = ''; -- 코딩 테스트용(테스트시 속도 무제로 데이터를 특정 모델로 제한)


    --DECLARE @p_division_id1			        NVARCHAR(50)        = N'40';
    --DECLARE @p_division_id2			        NVARCHAR(50)        = N'EE';
    --DECLARE @p_plan_type			        NVARCHAR(50)        = N'MA' -- 'MA' : 수요일 09시 기준 생성, 'FN' : 금요일 09시 기준 생성, 금요일은 'FN' 기준, 수요일은 사업부, 계획/재고에 따라 다름
    --DECLARE @p_yyyymmdd                     VARCHAR(8)          = '20230911'; --chaan

   PRINT CONCAT('@p_plan_type : ',   @p_plan_type);
   PRINT CONCAT('@p_yyyymmdd : ',    @p_yyyymmdd);


    DECLARE @V_ELAPSED_TIME_BEG             DATETIME            = CURRENT_TIMESTAMP;

 --   -- LOG 용 변수 설정
    DECLARE @v_batch_user                   NVARCHAR(150)   = 'scp_batch';
	DECLARE @v_program_name                 NVARCHAR(150)   = 'PR_SCP_RPT_ELEC_PSI_FOR_IF';
    DECLARE @v_log_type                     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count                    INT             = 0;    
    DECLARE @v_log_message                  NVARCHAR(1000);
    DECLARE @v_description                  NVARCHAR(500);
    DECLARE @d_event_date                   DATETIME;



    -- 내부 변수설정
    DECLARE @v_division_id                  NVARCHAR(30)    = @p_division_id1;
    DECLARE @v_division_id_ee               NVARCHAR(30)    = @p_division_id2;

   PRINT CONCAT('@v_division_id : ',    @v_division_id);
   PRINT CONCAT('@v_division_id_ee : ', @v_division_id_ee);

    DECLARE @v_plan_cycle                   NVARCHAR(30)    = N'WEEKLY';

    DECLARE @v_plan_type_fn                 NVARCHAR(50)    = N'FN';
    DECLARE @v_plan_type_ma                 NVARCHAR(50)    = N'MA';
    DECLARE @v_plan_type_se                 NVARCHAR(50)    = N'SE';
    DECLARE @v_plan_type_pr                 NVARCHAR(50)    = N'PR';

    DECLARE @v_plan_type_PLAN               NVARCHAR(50)    = N'';  --조립계획(PKG_PLAN, COAT_REQ)
    DECLARE @v_plan_type_ee_PLAN            NVARCHAR(50)    = N'';  --전극계획(SHIP_PLAN, PROD_PLAN_ENGINE, SHIP_PLAN_WH_IN)
    DECLARE @v_plan_type_ee_STOCK           NVARCHAR(50)    = N'';  --전극재고(INT_COM, INVENTORY_BOH, EOH1, EOH2, YIELD_E, YIELD_A)


    IF @p_plan_type = 'MA' -- 수요일 10시 집계
    BEGIN
        IF @p_division_id1 = '40'
        BEGIN
--확인필요            SET @v_plan_type_PLAN       = N'FN';
            SET @v_plan_type_PLAN       = N'MA';--확인필요
        END
        ELSE
        BEGIN
            SET @v_plan_type_PLAN       = N'SE';
        END

        --SET @v_plan_type_PLAN           = N'PR';--V1.2.8  - 조립계획 집계 수정 (MA/SE -> PR 로 통합)
        SET @v_plan_type_ee_PLAN        = N'FN';
        SET @v_plan_type_ee_STOCK       = N'PR';
    END
    ELSE--IF @p_plan_type = 'FN'      -- 금요일 09시 집계
    BEGIN
        SET @v_plan_type_PLAN           = N'FN';
        SET @v_plan_type_ee_PLAN        = N'FN';
        SET @v_plan_type_ee_STOCK       = N'FN';
    END




    DECLARE @v_plan_name_fn                 NVARCHAR(100);
    DECLARE @v_plan_id_fn                   NVARCHAR(30);
    DECLARE @v_plan_seq_fn                  INT;

    DECLARE @v_plan_name_ma                 NVARCHAR(100);
    DECLARE @v_plan_id_ma                   NVARCHAR(30);
    DECLARE @v_plan_seq_ma                  INT;

    DECLARE @v_plan_name_se                 NVARCHAR(100);
    DECLARE @v_plan_id_se                   NVARCHAR(30);
    DECLARE @v_plan_seq_se                  INT;

    DECLARE @v_plan_name_pr                 NVARCHAR(100);
    DECLARE @v_plan_id_pr                   NVARCHAR(30);
    DECLARE @v_plan_seq_pr                  INT;

    DECLARE @v_plan_name_ee_fn              NVARCHAR(100);
    DECLARE @v_plan_id_ee_fn                NVARCHAR(30);
    DECLARE @v_plan_seq_ee_fn               INT;

    DECLARE @v_plan_name_ee_pr              NVARCHAR(100);
    DECLARE @v_plan_id_ee_pr                NVARCHAR(30);
    DECLARE @v_plan_seq_ee_pr               INT;

    DECLARE @v_plan_name_ee_last_fn         NVARCHAR(100);
    DECLARE @v_plan_id_ee_last_fn           NVARCHAR(30);
    DECLARE @v_plan_seq_ee_last_fn          INT;

    DECLARE @v_plan_name_PLAN               NVARCHAR(100)    = N'';
    DECLARE @v_plan_id_PLAN                 NVARCHAR(30)     = N'';
    DECLARE @v_plan_seq_PLAN                INT;

    DECLARE @v_plan_name_ee_PLAN            NVARCHAR(100)    = N'';
    DECLARE @v_plan_id_ee_PLAN              NVARCHAR(30)     = N'';
    DECLARE @v_plan_seq_ee_PLAN             INT;

    DECLARE @v_plan_name_ee_STOCK           NVARCHAR(100)    = N'';
    DECLARE @v_plan_id_ee_STOCK             NVARCHAR(30)     = N'';
    DECLARE @v_plan_seq_ee_STOCK            INT;


    DECLARE @v_item_id                      NVARCHAR(100);
    DECLARE @v_value                        NUMERIC(20,10);
    DECLARE @v_flag                         CHAR(1);
    DECLARE @v_target_total                 INT;
    DECLARE @v_target_current               INT             = 0;
    DECLARE @v_creation_seq                 INT             = 0;

    DECLARE @v_plan_start_yyyymmdd_this     VARCHAR(8)      = @p_yyyymmdd;
    DECLARE @v_plan_start_yyyymmdd_last     VARCHAR(8)      = '';


    IF @v_plan_start_yyyymmdd_this IS NULL OR @v_plan_start_yyyymmdd_this = ''
    BEGIN
        SET @v_plan_start_yyyymmdd_this = CASE 
                                               WHEN DATEPART(WEEKDAY, GETDATE()) < 2 THEN FORMAT(DATEADD(DAY, 1, GETDATE()), 'yyyyMMdd')
                                               WHEN DATEPART(WEEKDAY, GETDATE()) > 2 THEN FORMAT(DATEADD(DAY, (2 - DATEPART(WEEKDAY, GETDATE())), GETDATE()), 'yyyyMMdd')
                                               ELSE FORMAT(GETDATE(), 'yyyyMMdd')
                                          END;
    END;

    SELECT	@v_plan_start_yyyymmdd_last = MAX(A.PLAN_START_YYYYMMDD)
    FROM    (
                SELECT  PLAN_START_YYYYMMDD
                FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
                WHERE	1=1
	                AND PLAN_TYPE   = 'FN'
	                AND DIVISION_ID = '81'
                    AND PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd_this
                GROUP BY PLAN_START_YYYYMMDD
            ) A

   PRINT CONCAT('@v_plan_start_yyyymmdd_this : ', @v_plan_start_yyyymmdd_this);
   PRINT CONCAT('@v_plan_start_yyyymmdd_last : ',    @v_plan_start_yyyymmdd_last);
--return;


    DECLARE @v_plan_period          INT             = 52;
    DECLARE @v_plan_to_yyyymmdd     VARCHAR(8);

    DECLARE @v_plan_to_yyyymmdd_limit VARCHAR(8)    = '';


    -- 1년뒤 데이터에 누적된 데이터 있어서 1년 초과 기간은 집계 대상에서 제외
    SELECT  @v_plan_to_yyyymmdd_limit = HORIZON_END_DATE
    FROM    dbo.SCM_MST_PLAN (NOLOCK)
    WHERE   1=1
        AND DIVISION_ID = @v_division_id
        AND PLAN_NAME   = @v_plan_start_yyyymmdd_this
        AND PLAN_CYCLE  = @v_plan_cycle

    PRINT CONCAT('@v_plan_start_yyyymmdd_this : ', @v_plan_start_yyyymmdd_this)
    PRINT CONCAT('@v_plan_to_yyyymmdd_limit : ', @v_plan_to_yyyymmdd_limit)



    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM;

	CREATE TABLE #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM
    (
    	[DIVISION_ID]				[NVARCHAR](30),
    	[COMPANY_ID]				[NVARCHAR](30),
    	[PLANT_ID]					[NVARCHAR](30),
    	[PARENT_ITEM_ID]			[NVARCHAR](100),
    	[CHILD_ITEM_ID]				[NVARCHAR](100),
    	[CHILD_QTY]					[NUMERIC](20,10),
    	[CHILD_DIVISION_ID]			[NVARCHAR](30),
    	[CONCATENATE_ITEM]			[NVARCHAR](1000)
    );
    
    --CREATE NONCLUSTERED INDEX IX_SCM_MST_BOM ON #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM (PARENT_ITEM_ID,CHILD_ITEM_ID);
    CREATE NONCLUSTERED INDEX IDX_T_SCP_RPT_ELEC_PSI_SCM_MST_BOM ON #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM (     PARENT_ITEM_ID
                                                                                    , CHILD_ITEM_ID
							                                                        , DIVISION_ID
							                                                        , COMPANY_ID
    							                                                    , PLANT_ID);


    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM
	(
    	[ROWIDX]					[INT] IDENTITY(1,1),
    	[ITEM_ID]					[NVARCHAR](100),
    	[VALUE1]					[NUMERIC](20,10),
    	[FLAG]						[CHAR](1)
    );

    CREATE NONCLUSTERED INDEX IX_T_SCP_RPT_ELEC_PSI_TARGET_ITEM ON #T_SCP_RPT_ELEC_PSI_TARGET_ITEM (ROWIDX);

/*
    CREATE TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT
	(
    	[COMPANY_ID]				[NVARCHAR](30) NOT NULL,
    	[CELL_ITEM_ID]				[NVARCHAR](100) NOT NULL,
    	[ITEM_ID]					[NVARCHAR](100) NULL,
    	[DIVISION_ID]				[NVARCHAR](30) NULL,
    	[VALUE1]					[NUMERIC](20,10) DEFAULT(0),
    	[FLAG]						[CHAR](1) NULL,
    	[PLANT_ID]					[NVARCHAR](30) NULL
    );
*/

    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_FINAL_ITEM') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_FINAL_ITEM;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI_FINAL_ITEM
	(
    	[ITEM_ID]					[NVARCHAR](50) NULL,
		[CELL_ITEM_ID]				[NVARCHAR](150) NULL,
    	[CONVERT_QTY_CELL]			[NUMERIC](20,10) NULL,
        [ELECTRODE_TYPE]			[NVARCHAR](30) NULL,
        [DIVISION_ID]				[NVARCHAR](30) NULL,
    );

    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_ALL') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_ALL;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI_EOH_ALL
	(
    	[PLAN_START_YYYYMMDD]		[NVARCHAR](8) NOT NULL,
    	[ITEM_ID]					[NVARCHAR](50) NULL,
    	[COMPANY_ID]				[NVARCHAR](30) NULL,
    	[VALUE1]					[NUMERIC](20, 10) NOT NULL,
    	[VALUE2]					[NUMERIC](20, 10) NOT NULL,
    );

    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT
	(
    	[DIVISION_ID]				[NVARCHAR](30) NOT NULL,
    	[ITEM_ID]					[NVARCHAR](50) NULL,
    	[YIELD]						[NUMERIC](20, 10) NOT NULL,
    	[OPERATION_ID]				[NVARCHAR](30) NOT NULL,
    	[PLANT_SITE_ID]				[NVARCHAR](30) NOT NULL,
    	[TACT_TIME_START_DATE]		[NVARCHAR](8) NULL,
    	[TACT_TIME_END_DATE]		[NVARCHAR](8) NULL,
    );

    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SITE') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI_SITE;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI_SITE
	(
    	[DIVISION_ID]				[NVARCHAR](30) NOT NULL,
    	[COMPANY_ID]				[NVARCHAR](30) NULL,
    	[SCM_SITE_ID]				[NVARCHAR](30) NULL,
    	[PLANT_ID]					[NVARCHAR](30) NULL,
    	[OPERATION_GROUP]			[NVARCHAR](10) NULL,
    );

    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI') IS NOT NULL)
        DROP TABLE #T_SCP_RPT_ELEC_PSI;

    CREATE TABLE #T_SCP_RPT_ELEC_PSI
	(
    	[DIVISION_ID]				[NVARCHAR](30) NOT NULL,
    	[ORG_DIVISION_ID]			[NVARCHAR](30) NOT NULL,
    	[PLAN_START_YYYYMMDD]		[NVARCHAR](8) NOT NULL,
    	[PSI]						[CHAR](1) NOT NULL,
    	[ELEC_MODEL]				[NVARCHAR](150) NOT NULL,
    	[CELL_MODEL]				[NVARCHAR](150) NULL,
    	[ELECTRODE_TYPE]			[NVARCHAR](30) NULL,
    	[COMPANY_ID]				[NVARCHAR](30) NOT NULL,
    	[PLAN_TYPE]				    [NVARCHAR](50) NOT NULL,
    	[PLANT_ID]					[NVARCHAR](30) NOT NULL,
    	[FROM_SITE]					[NVARCHAR](150) NULL,
    	[TO_SITE]					[NVARCHAR](150) NULL,
    	[UNIT]						[NVARCHAR](150) NOT NULL,
    	[MEASURE]					[NVARCHAR](150) NOT NULL,
    	[VALUE1]					[NUMERIC](20, 10) NOT NULL,
    	[VALUE2]					[NUMERIC](20, 10) NOT NULL,
    	[YYYYMMDD]					[CHAR](8) NOT NULL,
    	[CREATED_BY]				[NVARCHAR](150) NOT NULL,
    	[CREATION_DATE]				[DATETIME] NOT NULL,
    	[LAST_UPDATED_BY]			[NVARCHAR](150) NOT NULL,
    	[LAST_UPDATE_DATE]			[DATETIME] NOT NULL,
    	[QTY]						[NUMERIC](22, 10) NULL DEFAULT(0),
        [CREATION_SEQ]				[INT] NULL
    );

    CREATE NONCLUSTERED INDEX IDX_T_SCP_RPT_ELEC_PSI ON #T_SCP_RPT_ELEC_PSI (YYYYMMDD);

    BEGIN TRY
        -- 시작 LOG
        SET @v_log_type			= 'START';
        SET @v_log_message		= '########## Start of procedure ##########';
        SET @d_event_date		= SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
        PRINT CONCAT('@n_log_count : ', @n_log_count)

        SET @v_plan_to_yyyymmdd = FORMAT(DATEADD(ww, @v_plan_period, CAST(@v_plan_start_yyyymmdd_this AS datetime)), 'yyyyMMdd');

print '@v_plan_start_yyyymmdd_this : ' + @v_plan_start_yyyymmdd_this;
print '@v_plan_to_yyyymmdd : ' + @v_plan_to_yyyymmdd;
--return;


        SET @v_log_type			= 'DELETE - SCP_RPT_ELEC_PSI';
        SET @v_log_message		= '########## Start of procedure ##########';
        SET @d_event_date		= SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;

      --  SET @V_SQL  = N'
      --      SELECT    *
		    --FROM    OPENQUERY([LN_SCM_DEV],
      --                      ''SELECT  *
      --                        FROM   LGCE_SCMDEV.dbo.SCP_RPT_ELEC_PSI
      --                        WHERE  1=1
      --                           AND DIVISION_ID            = ''''' + @v_division_id_ee + '''''
      --                           AND ORG_DIVISION_ID        = ''''' + @v_division_id + '''''
      --                           AND PLAN_START_YYYYMMDD    = ''''' + @v_plan_start_yyyymmdd_this + '''''
      --                     '')';
      --  EXEC(@V_SQL);return;

        PRINT N'------------변수셋팅 BEGIN------------------------------------------------------------------------------------';
        IF @v_test_mode <> 'T'
        BEGIN
            DELETE
            FROM    dbo.SCP_RPT_ELEC_PSI
            WHERE   1=1
                AND DIVISION_ID         = @v_division_id_ee
                AND ORG_DIVISION_ID     = @v_division_id
                AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd_this 
                AND PLAN_TYPE           = @p_plan_type
        END


        --SELECT  @v_creation_seq = MAX(creation_seq) + 1
        --FROM   dbo.SCP_RPT_ELEC_PSI WITH(NOLOCK)
        --WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd_this;

        --SET @v_creation_seq = IIF(ISNULL(@v_creation_seq, 1) = 1, 1, @v_creation_seq);

        SELECT  @v_creation_seq     = MAX(CREATION_SEQ)
        FROM    dbo.SCP_RPT_ELEC_PSI WITH(NOLOCK)
        WHERE  1=1
            AND DIVISION_ID         = @p_division_id2
            AND ORG_DIVISION_ID     = @p_division_id1
            AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd_this
            AND PLAN_TYPE           = @p_plan_type

        IF @v_creation_seq > 0
        BEGIN
    		SET @v_creation_seq         = @v_creation_seq + 1;
        END
        ELSE
        BEGIN
    		SET @v_creation_seq         = 1;
        END
PRINT CONCAT('@v_creation_seq : ', @v_creation_seq)

PRINT CONCAT('ELAPSED_TIME0 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
		
	    PRINT(CONCAT('@v_plan_start_yyyymmdd_this : ', @v_plan_start_yyyymmdd_this));
	    PRINT(CONCAT('@v_creation_seq : ', @v_creation_seq));
--return;


	    -- 최종 Plan
	    SELECT	  @v_plan_name_fn	= PLAN_NAME
			    , @v_plan_id_fn	    = PLAN_ID
			    , @v_plan_seq_fn	= PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ) PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
							    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'FN'
				    WHERE	1=1
					    AND D.DIVISION_ID   = @v_division_id
                        AND P.PLAN_NAME     = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;

	    PRINT(CONCAT('@v_plan_name_fn : ', @v_plan_name_fn));
	    PRINT(CONCAT('@v_plan_id_fn : ',   @v_plan_id_fn));
	    PRINT(CONCAT('@v_plan_seq_fn : ',  @v_plan_seq_fn));
        PRINT N'------------------------------------------------------------------------------------------------';

	    -- MA Plan
	    SELECT	  @v_plan_name_ma	= PLAN_NAME
			    , @v_plan_id_ma	    = PLAN_ID
			    , @v_plan_seq_ma	= PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ) PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
							    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'MA'
				    WHERE	1=1
					    AND D.DIVISION_ID   = @v_division_id
                        AND P.PLAN_NAME     = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;

	    PRINT(CONCAT('@v_plan_name_ma : ', @v_plan_name_ma));
	    PRINT(CONCAT('@v_plan_id_ma : ',   @v_plan_id_ma));
	    PRINT(CONCAT('@v_plan_seq_ma : ',  @v_plan_seq_ma));
        PRINT N'------------------------------------------------------------------------------------------------';

	    -- SE Plan
	    SELECT	  @v_plan_name_se	= PLAN_NAME
			    , @v_plan_id_se	    = PLAN_ID
			    , @v_plan_seq_se	= PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ) PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
--SE Plan 은 MA 가 끝나야 CONFIRM_FLAG = 'Y' 로 바뀜!!							    AND D.CONFIRM_FLAG = 'Y'
                                AND CASE WHEN @p_plan_type = 'MA'  THEN 1
                                         WHEN D.CONFIRM_FLAG = 'Y' THEN 1
                                         ELSE 0
                                    END = 1
							    AND D.PLAN_TYPE    = 'SE'
				    WHERE	1=1
					    AND D.DIVISION_ID   = @v_division_id
                        AND P.PLAN_NAME     = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;

	    PRINT(CONCAT('@v_plan_name_se : ', @v_plan_name_se));
	    PRINT(CONCAT('@v_plan_id_se : ',   @v_plan_id_se));
	    PRINT(CONCAT('@v_plan_seq_se : ',  @v_plan_seq_se));
        PRINT N'------------------------------------------------------------------------------------------------';


	    -- PR Plan
	    SELECT	  @v_plan_name_pr	= PLAN_NAME
			    , @v_plan_id_pr	    = PLAN_ID
			    , @v_plan_seq_pr	= PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ) PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
							    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'PR'
				    WHERE	1=1
					    AND D.DIVISION_ID   = @v_division_id
                        AND P.PLAN_NAME     = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;

	    PRINT(CONCAT('@v_plan_name_pr : ', @v_plan_name_pr));
	    PRINT(CONCAT('@v_plan_id_pr : ',   @v_plan_id_pr));
	    PRINT(CONCAT('@v_plan_seq_pr : ',  @v_plan_seq_pr));
        PRINT N'------------------------------------------------------------------------------------------------';


	    -- 최종 Plan (전극)
	    SELECT	  @v_plan_name_ee_fn	= PLAN_NAME
			    , @v_plan_id_ee_fn	    = PLAN_ID
			    , @v_plan_seq_ee_fn	    = PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ)                                                           AS PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC)    AS RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC)                            AS ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
							    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'FN'
				    WHERE	1=1
					    AND D.DIVISION_ID = @v_division_id_ee
                        AND P.PLAN_NAME   = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;
            
	    PRINT(CONCAT('@v_plan_name_ee_fn : ',    @v_plan_name_ee_fn));
	    PRINT(CONCAT('@v_plan_id_ee_fn : ',      @v_plan_id_ee_fn));
	    PRINT(CONCAT('@v_plan_seq_ee_fn : ',     @v_plan_seq_ee_fn));
        PRINT N'------------------------------------------------------------------------------------------------';


	    -- 최종 Plan (전극) - 전주 
	    SELECT	  @v_plan_name_ee_last_fn	= PLAN_NAME
			    , @v_plan_id_ee_last_fn     = PLAN_ID
			    , @v_plan_seq_ee_last_fn	= PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ)                                                           AS PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC)    AS RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC)                            AS ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
							    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'FN'
				    WHERE	1=1
					    AND D.DIVISION_ID = @v_division_id_ee
                        AND P.PLAN_NAME   = @v_plan_start_yyyymmdd_last
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;
            
	    PRINT(CONCAT('@v_plan_name_ee_last_fn : ',    @v_plan_name_ee_last_fn));
	    PRINT(CONCAT('@v_plan_id_ee_last_fn : ',      @v_plan_id_ee_last_fn));
	    PRINT(CONCAT('@v_plan_seq_ee_last_fn : ',     @v_plan_seq_ee_last_fn));
        PRINT N'------------------------------------------------------------------------------------------------';

	    -- PR Plan (전극)
	    SELECT	  @v_plan_name_ee_pr	= PLAN_NAME
			    , @v_plan_id_ee_pr      = PLAN_ID
			    , @v_plan_seq_ee_pr	    = PLAN_SEQ
	    FROM	(
				    SELECT	  D.DIVISION_ID
						    , P.PLAN_NAME
						    , D.PLAN_ID
						    , D.PLAN_TYPE
						    , MAX(D.PLAN_SEQ)                                                           AS PLAN_SEQ
						    , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC)    AS RN
						    , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC)                            AS ROWIDX
				    FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						    INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								    D.DIVISION_ID  = P.DIVISION_ID
							    AND D.PLAN_ID      = P.PLAN_ID
							    AND D.PLAN_STATUS  = '1'
--전극재고는 CONFIRM 전	데이터 허용						    AND D.CONFIRM_FLAG = 'Y'
							    AND D.PLAN_TYPE    = 'PR'
				    WHERE	1=1
					    AND D.DIVISION_ID = @v_division_id_ee
                        AND P.PLAN_NAME   = @v_plan_start_yyyymmdd_this
					GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			    ) sub
	    WHERE	1=1
		    AND RN = 1;
            
	    PRINT(CONCAT('@v_plan_name_ee_pr : ',    @v_plan_name_ee_pr));
	    PRINT(CONCAT('@v_plan_id_ee_pr : ',      @v_plan_id_ee_pr));
	    PRINT(CONCAT('@v_plan_seq_ee_pr : ',     @v_plan_seq_ee_pr));
        PRINT N'------------------------------------------------------------------------------------------------';
--TESTING : OK
--return;

	    PRINT(CONCAT('@p_plan_type : ',     @p_plan_type));

        IF @p_plan_type = 'FN'
        BEGIN
            SET @v_plan_name_PLAN       = @v_plan_name_fn;
            SET @v_plan_id_PLAN         = @v_plan_id_fn;
            SET @v_plan_seq_PLAN        = @v_plan_seq_fn;

            SET @v_plan_name_ee_PLAN    = @v_plan_name_ee_fn;
            SET @v_plan_id_ee_PLAN      = @v_plan_id_ee_fn;
            SET @v_plan_seq_ee_PLAN     = @v_plan_seq_ee_fn;

            SET @v_plan_name_ee_STOCK   = @v_plan_name_ee_fn;
            SET @v_plan_id_ee_STOCK     = @v_plan_id_ee_fn;
            SET @v_plan_seq_ee_STOCK    = @v_plan_seq_ee_fn;
        END
        ELSE IF @p_plan_type = 'MA'
        BEGIN
            IF @p_division_id1 = '40'
            BEGIN
                SET @v_plan_name_PLAN       = @v_plan_name_ma;
                SET @v_plan_id_PLAN         = @v_plan_id_ma;
                SET @v_plan_seq_PLAN        = @v_plan_seq_ma;
            END
            ELSE
            BEGIN
                SET @v_plan_name_PLAN       = @v_plan_name_se;
                SET @v_plan_id_PLAN         = @v_plan_id_se;
                SET @v_plan_seq_PLAN        = @v_plan_seq_se;
            END

            --SET @v_plan_name_PLAN          = @v_plan_name_pr;    -- V1.2.8  - 조립계획 집계 수정 (MA/SE -> PR 로 통합)
            --SET @v_plan_id_PLAN            = @v_plan_id_pr;      -- V1.2.8  - 조립계획 집계 수정 (MA/SE -> PR 로 통합)
            --SET @v_plan_seq_PLAN           = @v_plan_seq_pr;     -- V1.2.8  - 조립계획 집계 수정 (MA/SE -> PR 로 통합)

            SET @v_plan_name_ee_PLAN       = @v_plan_name_ee_last_fn;
            SET @v_plan_id_ee_PLAN         = @v_plan_id_ee_last_fn;
            SET @v_plan_seq_ee_PLAN        = @v_plan_seq_ee_last_fn;

            SET @v_plan_name_ee_STOCK      = @v_plan_name_ee_pr;
            SET @v_plan_id_ee_STOCK        = @v_plan_id_ee_pr;
            SET @v_plan_seq_ee_STOCK       = @v_plan_seq_ee_pr;
        END

	    PRINT(CONCAT('@v_plan_name_PLAN      : ', @v_plan_name_PLAN));
	    PRINT(CONCAT('@v_plan_id_PLAN        : ', @v_plan_id_PLAN));
	    PRINT(CONCAT('@v_plan_seq_PLAN       : ', @v_plan_seq_PLAN));
        PRINT N'------------------------------------------------------------------------------------------------';

	    PRINT(CONCAT('@v_plan_name_ee_PLAN   : ', @v_plan_name_ee_PLAN));
	    PRINT(CONCAT('@v_plan_id_ee_PLAN     : ', @v_plan_id_ee_PLAN));
	    PRINT(CONCAT('@v_plan_seq_ee_PLAN    : ', @v_plan_seq_ee_PLAN));
        PRINT N'------------------------------------------------------------------------------------------------';

	    PRINT(CONCAT('@v_plan_name_ee_STOCK  : ', @v_plan_name_ee_STOCK));
	    PRINT(CONCAT('@v_plan_id_ee_STOCK    : ', @v_plan_id_ee_STOCK));
	    PRINT(CONCAT('@v_plan_seq_ee_STOCK   : ', @v_plan_seq_ee_STOCK));
        PRINT N'------------변수셋팅 END------------------------------------------------------------------------------------';

        INSERT INTO #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM
        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , A.CHILD_QTY
                , A.CHILD_DIVISION_ID
                , A.CONCATENATE_ITEM
        FROM    dbo.SCM_MST_BOM_SN A WITH(NOLOCK)
                JOIN dbo.SCP_MST_BOM_ELEC B WITH(NOLOCK) ON
                        A.DIVISION_ID       = B.DIVISION_ID
                    AND A.CHILD_ITEM_ID     = B.CHILD_ITEM_ID
                    AND B.PARENT_ITEM_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(A.CONCATENATE_ITEM, '^'))
                    AND B.SCP_YN            = 'Y'
	    WHERE	1=1
		    AND A.ALT_PRIORITY = 'Y'

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM;return;


	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM;

	    SELECT	  X.DIVISION_ID
			    , X.COMPANY_ID
			    , X.PLANT_ID
			    , X.CHILD_ITEM_ID
			    , X.CONCATENATE_ITEM
	    INTO	#T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM
	    FROM	#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM X
			    INNER JOIN dbo.SCP_MST_FINAL_ITEM F WITH(NOLOCK) ON
					    X.CHILD_DIVISION_ID = F.DIVISION_ID
				    AND X.CHILD_ITEM_ID     = F.ITEM_ID
				    AND F.OPERATION_GROUP   = 'E'
	    GROUP BY X.DIVISION_ID
			    ,X.COMPANY_ID
			    ,X.PLANT_ID
			    ,X.CHILD_ITEM_ID
			    ,X.CONCATENATE_ITEM;

        --CREATE NONCLUSTERED INDEX IX_T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM ON #T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM (CONCATENATE_ITEM);

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM;return;


	    INSERT INTO #T_SCP_RPT_ELEC_PSI_FINAL_ITEM
	    SELECT	  ITEM_ID
			    , CELL_ITEM_ID
			    , CONVERT_QTY_CELL
			    , ELECTRODE_TYPE
			    , DIVISION_ID
	    FROM	dbo.SCP_MST_FINAL_ITEM WITH(NOLOCK)
	    WHERE	1=1
		    AND CONVERT_QTY_CELL IS NOT NULL
	    GROUP BY  ITEM_ID
			    , CELL_ITEM_ID
			    , CONVERT_QTY_CELL
			    , ELECTRODE_TYPE
			    , DIVISION_ID;

--TESTING : OK
--select  *
--from    #T_SCP_RPT_ELEC_PSI_FINAL_ITEM
--where   1=1
--    AND ITEM_ID = 'APCAN0901A';
--return;


	    INSERT INTO #T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT
	    SELECT	  DIVISION_ID
			    , ITEM_ID
			    , YIELD
			    , OPERATION_ID
			    , PLANT_SITE_ID
			    , TACT_TIME_START_DATE
			    , TACT_TIME_END_DATE
	    FROM	dbo.SCP_MST_TACT_TIME_EXCEPT WITH(NOLOCK)
	    WHERE	1=1
		    AND OPERATION_ID IN ('Z_A00T', 'Z_E00T') -- 전극 후공정 수율
		    AND LINE_ID = '-';

	    INSERT INTO #T_SCP_RPT_ELEC_PSI_SITE
	    SELECT	  DIVISION_ID
			    , COMPANY_ID
			    , SCM_SITE_ID
			    , PLANT_ID
			    , OPERATION_GROUP
	    FROM	dbo.SCM_MST_SITE WITH(NOLOCK);
        
PRINT CONCAT('ELAPSED_TIME1 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
        
	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_1') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_1;

        SELECT	  A.PLAN_START_YYYYMMDD
                , A.ITEM_ID
                , B.COMPANY_ID
                , CAST(A.MEASURE_VALUE2 AS NUMERIC(20, 10)) AS VALUE1
                , 0                                         AS VALUE2
        INTO    #T_SCP_RPT_ELEC_PSI_EOH_1
        FROM    dbo.SCP_XLS_PSI_GLOBAL_ELECTRODE A WITH(NOLOCK)
                LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON
                        A.MEASURE_VALUE1 = B.SCM_SITE_ID
        WHERE   1=1
            AND A.DIVISION_ID           = @v_division_id_ee
            AND A.PLAN_START_YYYYMMDD   = @v_plan_name_ee_STOCK
            AND A.PLAN_TYPE             = @v_plan_type_ee_STOCK
            AND A.SEQ                   = @v_plan_seq_ee_STOCK
            AND A.ATTRIBUTE1            = 'INVENTORY_BOH'
            AND B.OPERATION_GROUP       = 'E'

--TESTING : NOK
--select * from #T_SCP_RPT_ELEC_PSI_EOH_1;return;

	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_2') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_2;

        SELECT	  A.PLAN_START_YYYYMMDD
                , A.ITEM_ID
                , B.COMPANY_ID
                , 0 VALUE1
                , CAST(A.MEASURE_VALUE2 AS NUMERIC(20, 10)) VALUE2
        INTO    #T_SCP_RPT_ELEC_PSI_EOH_2
        FROM	dbo.SCP_XLS_PSI_GLOBAL_ELECTRODE A WITH(NOLOCK)
                LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
                        A.MEASURE_VALUE1 = B.SCM_SITE_ID
        WHERE	1=1
            AND A.DIVISION_ID           = @v_division_id_ee
            AND A.PLAN_START_YYYYMMDD   = @v_plan_name_ee_STOCK
            AND A.PLAN_TYPE             = @v_plan_type_ee_STOCK
            AND A.SEQ                   = @v_plan_seq_ee_STOCK
            AND A.ATTRIBUTE1            = 'INVENTORY_BOH'
            AND B.OPERATION_GROUP       = 'A'

--TESTING : NOK 재고 소스테이블에 데이터 유무 여기서 확인 -----------------------------------------
--select * from #T_SCP_RPT_ELEC_PSI_EOH_1;--return;
--select * from #T_SCP_RPT_ELEC_PSI_EOH_2;return;
--          재고 소스테이블에 데이터 유무 여기서 확인 -----------------------------------------

--TESTING : OK
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH_1
--where   1=1
--    --AND ITEM_ID = 'APCAN0239A';
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH_2
--where   1=1
--    --AND ITEM_ID = 'APCAN0239A';
--return;

	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_SUM') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_SUM;

		SELECT	  A.PLAN_START_YYYYMMDD
				, A.ITEM_ID
				, A.COMPANY_ID
				, SUM(A.VALUE1) VALUE1
				, SUM(A.VALUE2) VALUE2
        INTO    #T_SCP_RPT_ELEC_PSI_EOH_SUM
		FROM	(
                    SELECT  *
                    FROM    #T_SCP_RPT_ELEC_PSI_EOH_1
		            UNION ALL
                    SELECT  *
                    FROM    #T_SCP_RPT_ELEC_PSI_EOH_2
                ) A
		GROUP BY A.PLAN_START_YYYYMMDD, A.ITEM_ID, A.COMPANY_ID

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_EOH_SUM;return;
--select  *
--from    #T_SCP_RPT_ELEC_PSI_EOH_SUM
--WHERE   ITEM_ID = 'APCAN2173A'
--return;

        INSERT INTO #T_SCP_RPT_ELEC_PSI_EOH_ALL
        SELECT	A.*
        FROM	#T_SCP_RPT_ELEC_PSI_EOH_SUM A
        WHERE	1=1
	        AND (A.VALUE1 <> 0 OR A.VALUE2 <> 0);

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_EOH_ALL;return;
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH_ALL
--WHERE   1=1
--    AND ITEM_ID = 'APCAN2173A'
--return;

PRINT CONCAT('ELAPSED_TIME2 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW;
        
        SELECT    A.ITEM_ID
                , A.VALUE1
                , A.FLAG
        INTO    #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW
        FROM    (
		            SELECT	  A.ITEM_ID
				            , SUM(A.QTY)    AS VALUE1
				            , 'A'           AS FLAG
		            FROM	(
                                SELECT    A.*
                                        , (SELECT TOKEN FROM dbo.STRING_SPLIT(A.SITE_ID, '~') WHERE NR = 1) AS SCM_SITE_ID
                                FROM    dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
            		            WHERE	1=1
			                        AND A.MASTER_ID = CONCAT(@v_division_id_ee, '::', @v_plan_cycle) --'EE::WEEKLY'
			                        AND A.PLAN_ID   = CONCAT(@v_plan_id_ee_STOCK, '::', @v_plan_type_ee_STOCK, '::', @v_plan_seq_ee_STOCK) --'1261::FN::1'
			                        AND A.DESCR LIKE 'WH%'
			                        AND A.SITE_ID LIKE '%-A%'
                            ) A
                            JOIN #T_SCP_RPT_ELEC_PSI_SITE B ON
                                    A.SCM_SITE_ID = B.SCM_SITE_ID
                                AND B.DIVISION_ID = @v_division_id
		            GROUP BY A.ITEM_ID
		            UNION ALL
		            SELECT	  A.ITEM_ID
				            , 0             AS VALUE1
				            , 'B'           AS FLAG
		            FROM	dbo.SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
		            WHERE	1=1
			            AND A.DIVISION_ID           = @v_division_id
			            AND A.PLAN_START_YYYYMMDD   = @v_plan_name_ee_STOCK
			            AND A.PLAN_TYPE             = @v_plan_type_ee_STOCK
			            AND A.SEQ                   = @v_plan_seq_ee_STOCK
			            AND A.MEASURE               = 'PROD_PLAN_ENGINE'
			            AND A.OPERATION_GROUP       = 'A'
			            AND EXISTS 
				            (
					            SELECT	1
					            FROM	#T_SCP_RPT_ELEC_PSI_SITE WITH(NOLOCK)
					            WHERE	SCM_SITE_ID = A.SCM_SITE_ID
						            AND OPERATION_GROUP = 'A'
				            )
                        AND A.YYYYMMDD <= @v_plan_to_yyyymmdd_limit
		            GROUP BY A.ITEM_ID
                ) A
--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW;return;

        IF @v_test_mode = 'T'
        BEGIN
            IF @v_test_mode_item_id <> '' AND @v_test_mode_item_id IS NOT NULL
            BEGIN
                DELETE FROM #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW WHERE ITEM_ID <> @v_test_mode_item_id;
            END
        END

--select * from #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW;return;

		INSERT INTO #T_SCP_RPT_ELEC_PSI_TARGET_ITEM
		(
			  ITEM_ID
			, FLAG
			, VALUE1
		)
			SELECT	  ITEM_ID
					, FLAG
					, SUM(VALUE1)
			FROM	#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW
			GROUP BY ITEM_ID, FLAG;

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_TARGET_ITEM;return;


        SET @v_log_type			= 'INSERT #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT';
        SET @v_log_message		= 'INSERT #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT - BEGIN';
        PRINT @v_log_type;
        PRINT @v_log_message;

	    --SET @v_target_total = @@ROWCOUNT;

        SELECT  @v_target_total = COUNT(*)
        FROM    #T_SCP_RPT_ELEC_PSI_TARGET_ITEM;


	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT;

		CREATE TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT
		(
			[COMPANY_ID]		[NVARCHAR](30) NOT NULL,
			[CELL_ITEM_ID]		[NVARCHAR](100) NOT NULL,
			[ITEM_ID]			[NVARCHAR](100) NULL,
			[DIVISION_ID]		[NVARCHAR](30) NULL,
			[VALUE1]			[NUMERIC](20,10) DEFAULT(0),
			[FLAG]				[CHAR](1) NULL,
			[PLANT_ID]			[NVARCHAR](30) NULL
		);

        PRINT   '@v_target_current : ' + CONVERT(VARCHAR, @v_target_current);
        PRINT   '@v_target_total : ' + CONVERT(VARCHAR, @v_target_total);

		WHILE(@v_target_current < @v_target_total)
		BEGIN
			SET @v_target_current += 1;

			SELECT	  @v_item_id    = ITEM_ID
					, @v_value      = VALUE1
					, @v_flag       = FLAG
			FROM	#T_SCP_RPT_ELEC_PSI_TARGET_ITEM
			WHERE	ROWIDX = @v_target_current;

    	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP;

			SELECT	  A.DIVISION_ID
					, A.COMPANY_ID
					, A.PLANT_ID
					, A.ITEM_ID
					, A.ELEC_ITEM_ID
					, A.CON_ITEM
					, CHARINDEX('^', A.CON_ITEM, 1) AS CON01
					, CASE 
						WHEN CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1) = 0 THEN 1000
						ELSE CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1)
						END AS CON02
					, CASE 
						WHEN CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1) + 1) = 0 THEN 1000
						ELSE CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1) + 1)
						END AS CON03
					, CASE 
						WHEN CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1) + 1) + 1) = 0 THEN 1000
						ELSE CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, CHARINDEX('^', A.CON_ITEM, 1) + 1) + 1) + 1)
						END AS CON04
            INTO    #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP
			FROM	(
						SELECT	  X.DIVISION_ID
								, X.COMPANY_ID
								, X.PLANT_ID
								, @v_item_id ITEM_ID --  -- 변환 대상 N/L/F Item
								, X.CHILD_ITEM_ID ELEC_ITEM_ID-- 전극 ITEM
								, SUBSTRING(X.CONCATENATE_ITEM, CHARINDEX(@v_item_id, X.CONCATENATE_ITEM), 1000) CON_ITEM
						FROM	#T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM X
						WHERE	1=1
							AND X.CONCATENATE_ITEM LIKE CONCAT('%', @v_item_id, '^%')  -- 변환 대상 N/L/F Item
					) A

    	    IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB;

			SELECT	  C.DIVISION_ID
					, C.COMPANY_ID
					, C.PLANT_ID
					, C.ITEM_ID
					, C.ELEC_ITEM_ID
			-- 2. 소요량 계산
					, ISNULL((
						SELECT	MAX(AB.CHILD_QTY) AS CHILD_ITEM_RATE
						FROM	#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM AB
						WHERE	1=1
							AND AB.PARENT_ITEM_ID = C.ITEM_ID
							AND AB.CHILD_ITEM_ID = C.CHILD_ITEM_1
							AND AB.DIVISION_ID = C.DIVISION_ID
							AND AB.COMPANY_ID = C.COMPANY_ID
							AND AB.PLANT_ID = C.PLANT_ID
						), 1) AS CHILD_ITEM_RATE01
					, ISNULL((
						SELECT	MAX(AB.CHILD_QTY) AS CHILD_ITEM_RATE
						FROM	#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM AB
						WHERE	1=1
							AND AB.PARENT_ITEM_ID = C.CHILD_ITEM_1
							AND AB.CHILD_ITEM_ID = C.CHILD_ITEM_2
							AND AB.DIVISION_ID = C.DIVISION_ID
							AND AB.COMPANY_ID = C.COMPANY_ID
							AND AB.PLANT_ID = C.PLANT_ID
						), 1) AS CHILD_ITEM_RATE02
					, ISNULL((
						SELECT	MAX(AB.CHILD_QTY) AS CHILD_ITEM_RATE
						FROM	#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM AB
						WHERE	1=1
							AND AB.PARENT_ITEM_ID  = C.CHILD_ITEM_2
							AND AB.CHILD_ITEM_ID  = C.CHILD_ITEM_3
							AND AB.DIVISION_ID = C.DIVISION_ID
							AND AB.COMPANY_ID  = C.COMPANY_ID
							AND AB.PLANT_ID  = C.PLANT_ID
						), 1) AS CHILD_ITEM_RATE03
            INTO    #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB
			FROM	(
						SELECT	  B.DIVISION_ID
								, B.COMPANY_ID
								, B.PLANT_ID
								, B.ITEM_ID
								, B.ELEC_ITEM_ID
								, B.CON_ITEM
								, B.CON01
								, B.CON02
								, B.CON03
								, B.CON04
								, CASE 
									WHEN B.CON01=1000 THEN 'N/A'
									WHEN B.CON02 = 1000 THEN SUBSTRING(B.CON_ITEM, B.CON01 + 1, 1000)
									ELSE SUBSTRING(B.CON_ITEM, B.CON01 + 1, (B.CON02 - B.CON01 - 1))
									END AS CHILD_ITEM_1
								, CASE 
									WHEN B.CON02 = 1000 THEN 'N/A'
									WHEN B.CON03 = 1000 THEN SUBSTRING(B.CON_ITEM, B.CON02 + 1,1000)
									ELSE SUBSTRING(B.CON_ITEM, B.CON02 + 1, (B.CON03 - B.CON02 - 1))
									END AS CHILD_ITEM_2
								, CASE 
									WHEN B.CON03 = 1000 THEN 'N/A'
									WHEN B.CON04 = 1000 THEN SUBSTRING(B.CON_ITEM, B.CON03 + 1, 1000)
									ELSE SUBSTRING(B.CON_ITEM, B.CON03 + 1, (B.CON04 - B.CON03 - 1))
									END AS CHILD_ITEM_3
						FROM    #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP B
					) C

			INSERT INTO #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT
			(
				  ITEM_ID
				, COMPANY_ID
				, DIVISION_ID
				, CELL_ITEM_ID
				, VALUE1
				, FLAG
				, PLANT_ID
			)
			SELECT	  @v_item_id ITEM_ID
					, A.COMPANY_ID
					, A.DIVISION_ID
					, A.ELEC_ITEM_ID
					, IIF(@v_flag = 'A', A.CHILD_ITEM_RATE01 * A.CHILD_ITEM_RATE02 * A.CHILD_ITEM_RATE03 * @v_value, A.CHILD_ITEM_RATE01 * A.CHILD_ITEM_RATE02 * A.CHILD_ITEM_RATE03) VALUE1
					, @v_flag FLAG
					, A.PLANT_ID
			FROM	#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB A

			PRINT(CONCAT('@p_division_id1 : ', @p_division_id1, ', [', @v_target_current, ' / ', @v_target_total, '], ', '@v_item_id : ', @v_item_id, ', @v_value : ', CONVERT(NVARCHAR, @v_value), ', @v_flag : ', @v_flag));
		END

        SET @v_log_type			= 'INSERT #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT';
        SET @v_log_message		= 'INSERT #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT - END';
        PRINT @v_log_type;
        PRINT @v_log_message;

--TESTING : OK
--select  * from #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT;return;
--where   1=1
    --AND CELL_ITEM_ID    = 'APCAN1280C'
    --AND ITEM_ID         = 'ACEN1066I-A1-200'
--select DISTINCT
--          CELL_ITEM_ID
--        , ITEM_ID
--from    #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT
--where   1=1
--    --AND CELL_ITEM_ID    = 'APCAN1731A'
--    AND ITEM_ID         = 'ACEN4065I-A1-301'
    
--return;

PRINT CONCAT('ELAPSED_TIME3 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -- 'SHIP_PLAN'
	    BEGIN
            -- S
            -- 전극출하 (출하계획기반)
            -- 전극출하는 타 법인향만 반영
            INSERT INTO #T_SCP_RPT_ELEC_PSI
            (
			      DIVISION_ID
			    , ORG_DIVISION_ID
			    , PLAN_START_YYYYMMDD
			    , PSI
			    , ELEC_MODEL
			    , CELL_MODEL
			    , ELECTRODE_TYPE
			    , COMPANY_ID
			    , PLAN_TYPE
			    , PLANT_ID
			    , FROM_SITE
			    , TO_SITE
			    , UNIT
			    , MEASURE
			    , VALUE1
			    , VALUE2
			    , YYYYMMDD
			    , QTY
			    , CREATED_BY
			    , CREATION_DATE
			    , LAST_UPDATED_BY
			    , LAST_UPDATE_DATE
			    , CREATION_SEQ
		    )
		    SELECT	  A.DIVISION_ID
				    , A.ORIGIN_FROM_DIVISION_ID
				    , @v_plan_start_yyyymmdd_this                                                AS PLAN_START_YYYYMMDD
				    , 'S'                                                                   AS PSI
				    , A.ITEM_ID                                                             AS ELEC_MODEL
				    , D.CELL_ITEM_ID                                                        AS CELL_MODEL
				    , ISNULL(A.ELECTRODE_TYPE, ISNULL(E.ELECTRODE_TYPE, ''))                AS ELECTRODE_TYPE
				    , B.COMPANY_ID                                                          AS COMPANY
				    , @p_plan_type                                                          AS PLAN_TYPE
				    , (SELECT token FROM dbo.string_split(A.FROM_SITE, '-') WHERE nr = 1)   AS PLANT
				    , A.FROM_SITE                                                           AS FROM_SITE
				    , A.TO_SITE                                                             AS TO_SITE
				    , ''                                                                    AS UNIT
				    , 'SHIP_PLAN'                                                           AS MEASURE
				    , 0                                                                     AS VALUE1
				    , 0                                                                     AS VALUE2
				    , A.YYYYMMDD
				    , SUM(ISNULL(A.QTY, 0) * ISNULL(D.CONVERT_QTY_CELL, 1))                 AS QTY
				    , @v_batch_user                                                         AS CREATED_BY
				    , GETDATE()                                                             AS CREATION_DATE
				    , @v_batch_user                                                         AS LAST_UPDATED_BY
				    , GETDATE()                                                             AS LAST_UPDATE_DATE
				    , @v_creation_seq                                                       AS CREATION_SEQ
		    FROM	dbo.SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
				    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
						    A.FROM_SITE = B.SCM_SITE_ID
				    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE C WITH(NOLOCK) ON 
						    A.TO_SITE = C.SCM_SITE_ID
				    LEFT JOIN #T_SCP_RPT_ELEC_PSI_FINAL_ITEM D ON 
						    A.ITEM_ID = D.ITEM_ID 
					    AND @v_division_id = D.DIVISION_ID
				    LEFT JOIN	(
								    SELECT	  ITEM_ID
										    , ELECTRODE_TYPE
								    FROM	#T_SCP_RPT_ELEC_PSI_FINAL_ITEM
								    GROUP BY ITEM_ID, ELECTRODE_TYPE
							    ) E ON 
						    A.ITEM_ID = E.ITEM_ID
			    WHERE	1=1
				    AND A.DIVISION_ID               = @v_division_id_ee
				    AND A.PLAN_START_YYYYMMDD       = @v_plan_name_ee_PLAN
				    AND A.PLAN_TYPE                 = @v_plan_type_ee_PLAN
				    AND A.SEQ                       = @v_plan_seq_ee_PLAN
				    AND A.MEASURE                   = 'SHIP_PLAN_AMEND'
				    AND A.ORIGIN_FROM_DIVISION_ID   = @v_division_id
				    AND EXISTS (SELECT 1 FROM #T_SCP_RPT_ELEC_PSI_SITE WITH(NOLOCK) WHERE SCM_SITE_ID = A.FROM_SITE AND OPERATION_GROUP = 'E')
				    AND B.COMPANY_ID                != C.COMPANY_ID
			    GROUP BY	  A.ITEM_ID
						    , D.CELL_ITEM_ID
						    , ISNULL(A.ELECTRODE_TYPE, ISNULL(E.ELECTRODE_TYPE, ''))
						    , B.COMPANY_ID
						    --, @p_plan_type
						    , A.FROM_SITE
						    , A.TO_SITE
						    , A.MEASURE
						    , A.YYYYMMDD
						    , A.DIVISION_ID
						    , A.PLAN_START_YYYYMMDD
						    , A.ORIGIN_FROM_DIVISION_ID
						    , B.COMPANY_ID
						    , C.COMPANY_ID

            SET @n_log_count = @@ROWCOUNT;

            PRINT(CONCAT('MEASURE : SHIP_PLAN (', @n_log_count, ')'));
	    END

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI;return;

PRINT CONCAT('ELAPSED_TIME4 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

print 'TEST - A';
	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type			= 'APPEND';
	    SET @v_log_message		= 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = S';
	    SET @v_description		= N'PSI 유형 S: SHIP_PLAN';
	    SET @d_event_date		= SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'COAT_REQ'
	    BEGIN
            -- S
            -- 전극소요 (조립계획기반) 라인 합계
            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND;

			SELECT	  A.*
					, B.COMPANY_ID
					, B.PLANT_ID
            INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND
			FROM	dbo.SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
							A.SCM_SITE_ID = B.SCM_SITE_ID
			WHERE	1=1
				AND A.DIVISION_ID           = @v_division_id
				AND A.PLAN_START_YYYYMMDD   = @v_plan_name_PLAN
				AND A.PLAN_TYPE             = @v_plan_type_PLAN
				AND A.SEQ                   = @v_plan_seq_PLAN
				AND A.MEASURE               = 'PROD_PLAN_ENGINE'
				AND A.OPERATION_GROUP       = 'A'
				AND A.OPERATION_ID LIKE 'A%'
                AND A.YYYYMMDD <= @v_plan_to_yyyymmdd_limit
--return;
--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND;return;
--select  *
--from    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND
--WHERE   1=1
--    AND ITEM_ID = 'ACPN1033I-A1-001'
--return;


        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1;

		SELECT	  @v_division_id_ee             AS DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, @v_plan_start_yyyymmdd_this   AS PLAN_START_YYYYMMDD
				, 'S'                           AS PSI
				, B.CELL_ITEM_ID                AS ELEC_MODEL
				, A.ITEM_ID                     AS CELL_MODEL
				, ISNULL(C.ELECTRODE_TYPE, '')  AS ELECTRODE_TYPE
				, A.COMPANY_ID                  AS COMPANY
				, A.PLANT_ID                    AS PLANT
				, A.SCM_SITE_ID                 AS FROM_SITE
				, ''                            AS TO_SITE
				, ''                            AS UNIT
				, 'COAT_REQ'                    AS MEASURE
				, 0                             AS VALUE1
				, 0                             AS VALUE2
				, A.YYYYMMDD
				, ISNULL(A.QTY, 0)              AS QTY
				, A.SCM_SITE_ID
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND A
				LEFT JOIN 
					(
						SELECT	  A.CELL_ITEM_ID
								, A.COMPANY_ID
								, A.DIVISION_ID
								, A.PLANT_ID
                                , A.ITEM_ID
						FROM	#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT A
						WHERE	1=1
							AND FLAG = 'B'
						GROUP BY A.CELL_ITEM_ID, A.COMPANY_ID, A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID
					) B ON 
						A.ORIGIN_DIVISION_ID = B.DIVISION_ID 
					AND A.COMPANY_ID         = B.COMPANY_ID 
					AND A.PLANT_ID           = B.PLANT_ID
					AND A.ITEM_ID            = B.ITEM_ID 
				LEFT JOIN 
					(
						SELECT	  DIVISION_ID
                                , ITEM_ID
								, ELECTRODE_TYPE
						FROM	#T_SCP_RPT_ELEC_PSI_FINAL_ITEM
						GROUP BY DIVISION_ID, ITEM_ID, ELECTRODE_TYPE
					) C ON 
						    B.DIVISION_ID  = C.DIVISION_ID
						AND B.CELL_ITEM_ID = C.ITEM_ID


        IF @v_test_mode = 'T'
        BEGIN
            IF @v_test_mode_item_id <> '' AND @v_test_mode_item_id IS NOT NULL
            BEGIN
                DELETE FROM #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1 WHERE ELEC_MODEL <> @v_test_mode_item_id
            END
        END

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND;
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1;return;
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1
--where   1=1
--    AND CELL_MODEL  = 'ACEN1066I-A1-200'
--    --AND ELEC_MODEL  = 'APCAN1280C'; 
--return;


        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2;

		SELECT	  A.*
				, ISNULL((
					SELECT	YIELD
					FROM	#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT
					WHERE	DIVISION_ID = A.ORIGIN_DIVISION_ID
						AND OPERATION_ID = 'Z_A00T'
						AND ITEM_ID = A.CELL_MODEL
						AND A.YYYYMMDD BETWEEN TACT_TIME_START_DATE AND TACT_TIME_END_DATE
						AND PLANT_SITE_ID = A.SCM_SITE_ID
				), 1) AS YIELD1  -- 조립수율
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1 A

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2;return;
--select * 
--from   #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2
--where  CELL_MODEL = 'ACEN4065I-A1-301';return;


        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3;

		SELECT	  A.*
				, ISNULL((
					SELECT	YIELD
					FROM	#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT
					WHERE	DIVISION_ID = A.ORIGIN_DIVISION_ID
						AND OPERATION_ID = 'Z_E00T'
						AND ITEM_ID = A.ELEC_MODEL
						AND A.YYYYMMDD BETWEEN TACT_TIME_START_DATE AND TACT_TIME_END_DATE
						AND PLANT_SITE_ID = A.SCM_SITE_ID
				), 1) AS YIELD2 -- 전극 후공정 수율
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2 A

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3;return;


        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4;

		SELECT	  A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PSI
				, A.ELEC_MODEL
				, A.CELL_MODEL
				, A.ELECTRODE_TYPE
				, A.COMPANY
				, A.PLANT
				, A.FROM_SITE
				, A.TO_SITE
				, A.UNIT
				, A.MEASURE
				, A.VALUE1
				, A.VALUE2
				, A.YYYYMMDD
				, @v_batch_user                                                     AS CREATED_BY
				, GETDATE()                                                         AS CREATION_DATE
				, @v_batch_user                                                     AS LAST_UPDATED_BY
				, GETDATE()                                                         AS LAST_UPDATE_DATE
				, @v_creation_seq                                                   AS CREATION_SEQ
				, SUM(ISNULL(A.QTY, 0))                                             AS QTY  -- A.QTY / PKG_PLAN
				, SUM(ISNULL(A.QTY, 0) / ISNULL(A.YIELD1, 1) * ISNULL(A.YIELD2, 1)) AS QTY1 -- A.QTY / (조립수율*전극후공정수율)
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3 A
		GROUP BY	  A.DIVISION_ID
					, A.ORIGIN_DIVISION_ID
					, A.PLAN_START_YYYYMMDD
					, A.PSI
					, A.ELEC_MODEL
					, A.CELL_MODEL
					, A.ELECTRODE_TYPE
				    , A.COMPANY
				    , A.PLANT
					, A.FROM_SITE
					, A.TO_SITE
					, A.UNIT
					, A.MEASURE
					, A.VALUE1
					, A.VALUE2
					, A.YYYYMMDD

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4;return;
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4
--WHERE   1=1
--    AND CELL_MODEL = 'MCCM348015A1-D14'
--return;

        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN;

		SELECT	  A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, 'S'                AS PSI
				, A.ELEC_MODEL
				, A.CELL_MODEL
				, A.ELECTRODE_TYPE
				, A.COMPANY
				, A.PLANT
				, A.FROM_SITE
				, A.TO_SITE
				, A.UNIT
				, 'PKG_PLAN'        AS MEASURE
				, A.VALUE1
				, A.VALUE2
				, A.YYYYMMDD
				, A.QTY         AS QTY1
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
				, A.CREATION_SEQ
				, ROW_NUMBER() OVER (PARTITION BY A.PSI, A.MEASURE, ISNULL(A.ELEC_MODEL, ''), A.CELL_MODEL, A.YYYYMMDD, A.Company, A.Plant, ISNULL(A.FROM_SITE, ''), ISNULL(A.TO_SITE, '') 
                                        ORDER BY CREATION_DATE DESC) AS RN
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4 A
        WHERE   1=1

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN;return;

        IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5') IS NOT NULL)
            DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5;

		SELECT	  A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PSI
				, A.ELEC_MODEL
				, A.CELL_MODEL
				, A.ELECTRODE_TYPE
				, A.COMPANY
				, A.PLANT
				, A.FROM_SITE
				, A.TO_SITE
				, A.UNIT
				, A.MEASURE
				, A.VALUE1
				, A.VALUE2
				, A.YYYYMMDD
				, A.QTY1
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
				, A.CREATION_SEQ
				, ROW_NUMBER() OVER (PARTITION BY A.PSI, A.MEASURE, ISNULL(A.ELEC_MODEL, ''), A.CELL_MODEL, A.YYYYMMDD, A.COMPANY, A.PLANT, ISNULL(A.FROM_SITE, ''), ISNULL(A.TO_SITE, '') 
                                        ORDER BY CREATION_DATE DESC) AS RN
        INTO    #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5
		FROM	#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4 A
        WHERE   1=1

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5;return;

PRINT CONCAT('ELAPSED_TIME5 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
				   DIVISION_ID
				 , ORG_DIVISION_ID
				 , PLAN_START_YYYYMMDD
				 , PSI
				 , ELEC_MODEL
				 , CELL_MODEL
				 , ELECTRODE_TYPE
				 , COMPANY_ID
				 , PLAN_TYPE
				 , PLANT_ID
				 , FROM_SITE
				 , TO_SITE
				 , UNIT
				 , MEASURE
				 , VALUE1
				 , VALUE2
				 , YYYYMMDD
				 , QTY
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , CREATION_SEQ
			)
			SELECT	  A.DIVISION_ID
					, A.ORIGIN_DIVISION_ID
					, A.PLAN_START_YYYYMMDD
					, A.PSI
					--chaan              , A.ELEC_MODEL
                    , ISNULL(A.ELEC_MODEL, '')      AS ELEC_MODEL
					, A.CELL_MODEL
					, A.ELECTRODE_TYPE
					--chaan              ,A.Company
					--chaan              ,A.Plant
					, ISNULL(A.COMPANY, '')         AS COMPANY
                    , @p_plan_type                  AS PLAN_TYPE
					, ISNULL(A.PLANT, '')           AS PLANT
					, A.FROM_SITE
					, A.TO_SITE
					, A.UNIT
					, A.MEASURE
					, A.VALUE1
					, A.VALUE2
					, A.YYYYMMDD
					, A.QTY1
					, A.CREATED_BY
					, A.CREATION_DATE
					, A.LAST_UPDATED_BY
					, A.LAST_UPDATE_DATE
					, A.CREATION_SEQ
			FROM	  #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5 A
			WHERE	A.RN = 1

		    PRINT(CONCAT('MEASURE : COAT_REQ (', @n_log_count, ')'));

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
				   DIVISION_ID
				 , ORG_DIVISION_ID
				 , PLAN_START_YYYYMMDD
				 , PSI
				 , ELEC_MODEL
				 , CELL_MODEL
				 , ELECTRODE_TYPE
				 , COMPANY_ID
 			     , PLAN_TYPE
				 , PLANT_ID
				 , FROM_SITE
				 , TO_SITE
				 , UNIT
				 , MEASURE
				 , VALUE1
				 , VALUE2
				 , YYYYMMDD
				 , QTY
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , CREATION_SEQ
			)
			SELECT	  A.DIVISION_ID
					, A.ORIGIN_DIVISION_ID
					, A.PLAN_START_YYYYMMDD
					, A.PSI
					--chaan              , A.ELEC_MODEL
                    , ISNULL(A.ELEC_MODEL, '')      AS ELEC_MODEL
					, A.CELL_MODEL
					, A.ELECTRODE_TYPE
					--chaan              ,A.Company
					--chaan              ,A.Plant
					, ISNULL(A.COMPANY, '')         AS COMPANY
    				, @p_plan_type                  AS PLAN_TYPE
					, ISNULL(A.PLANT, '')           AS PLANT
					, A.FROM_SITE
					, A.TO_SITE
					, A.UNIT
					, A.MEASURE
					, A.VALUE1
					, A.VALUE2
					, A.YYYYMMDD
					, A.QTY1
					, A.CREATED_BY
					, A.CREATION_DATE
					, A.LAST_UPDATED_BY
					, A.LAST_UPDATE_DATE
					, A.CREATION_SEQ
			FROM	  #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN A
			WHERE	A.RN = 1

		    SET @n_log_count = @@ROWCOUNT;
		
		    PRINT(CONCAT('MEASURE : PKG_PLAN (', @n_log_count, ')'));
	    END

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI;return;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = S';
	    SET @v_description = N'PSI 유형 S: COAT_REQ';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------
print 'TEST - B';
--return;


	    --'PROD_PLAN_ENGINE'
	    BEGIN
            -- P
            -- 전극생산 : 날짜별 SUM
            ;WITH sub AS
            (
			    SELECT	  A.DIVISION_ID
					    , A.ORIGIN_DIVISION_ID
					    , @v_plan_start_yyyymmdd_this                                   AS PLAN_START_YYYYMMDD
					    , 'P'                                                           AS PSI
					    , A.ITEM_ID                                                     AS ELEC_MODEL
					    , B.CELL_ITEM_ID                                                AS CELL_MODEL
					    , ISNULL(A.ELECTRODE_TYPE, ISNULL(D.ELECTRODE_TYPE, ''))        AS ELECTRODE_TYPE
					    , C.COMPANY_ID                                                  AS COMPANY
					    , REPLACE(A.SCM_SITE_ID, CONCAT('-', A.OPERATION_GROUP), '')    AS PLANT
					    , ''                                                            AS FROM_SITE
					    , A.SCM_SITE_ID                                                 AS TO_SITE
					    , ''                                                            AS UNIT
					    , A.MEASURE
					    , 0                                                             AS VALUE1
					    , 0                                                             AS VALUE2
					    , A.YYYYMMDD
					    , (A.QTY * ISNULL(B.CONVERT_QTY_CELL, 1))                       AS QTY
			    FROM	dbo.SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
					    LEFT JOIN #T_SCP_RPT_ELEC_PSI_FINAL_ITEM B ON 
                                A.ITEM_ID = B.ITEM_ID 
                            AND A.ORIGIN_DIVISION_ID = B.DIVISION_ID
					    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE C WITH(NOLOCK) ON 
                                A.SCM_SITE_ID = C.SCM_SITE_ID
					    LEFT JOIN 
						    (
							    SELECT	  ITEM_ID
									    , ELECTRODE_TYPE
							    FROM	#T_SCP_RPT_ELEC_PSI_FINAL_ITEM
							    GROUP BY ITEM_ID, ELECTRODE_TYPE
						    ) D ON 
							    A.ITEM_ID = D.ITEM_ID
			    WHERE	1=1
				    AND A.DIVISION_ID           = @v_division_id_ee
				    AND A.PLAN_START_YYYYMMDD   = @v_plan_name_ee_PLAN
				    AND A.PLAN_TYPE             = @v_plan_type_ee_PLAN
				    AND A.SEQ                   = @v_plan_seq_ee_PLAN
				    AND A.OPERATION_ID IN ('E2000')
				    AND A.ORIGIN_DIVISION_ID    = @v_division_id
				    AND A.MEASURE               = 'PROD_PLAN_ENGINE'
				    AND EXISTS (SELECT 1 FROM #T_SCP_RPT_ELEC_PSI_SITE WITH(NOLOCK) WHERE SCM_SITE_ID = A.SCM_SITE_ID AND OPERATION_GROUP = 'E')
                    AND A.YYYYMMDD <= @v_plan_to_yyyymmdd_limit
		    )
			    INSERT INTO #T_SCP_RPT_ELEC_PSI
			    (
				      DIVISION_ID
				    , ORG_DIVISION_ID
				    , PLAN_START_YYYYMMDD
				    , PSI
				    , ELEC_MODEL
				    , CELL_MODEL
				    , ELECTRODE_TYPE
				    , COMPANY_ID
    			    , PLAN_TYPE
				    , PLANT_ID
				    , FROM_SITE
				    , TO_SITE
				    , UNIT
				    , MEASURE
				    , VALUE1
				    , VALUE2
				    , YYYYMMDD
				    , QTY
				    , CREATED_BY
				    , CREATION_DATE
				    , LAST_UPDATED_BY
				    , LAST_UPDATE_DATE
				    , CREATION_SEQ
			    )
			    SELECT	  A.DIVISION_ID
					    , A.ORIGIN_DIVISION_ID
					    , A.PLAN_START_YYYYMMDD
					    , A.PSI
					    , A.ELEC_MODEL
					    , A.CELL_MODEL
					    , A.ELECTRODE_TYPE
					    , A.COMPANY
        				, @p_plan_type      AS PLAN_TYPE
					    , A.PLANT
					    , A.FROM_SITE
					    , A.TO_SITE
					    , A.UNIT
					    , A.MEASURE
					    , A.VALUE1
					    , A.VALUE2
					    , A.YYYYMMDD
					    , SUM(A.QTY)        AS QTY
					    , @v_batch_user     AS CREATED_BY
					    , GETDATE()         AS CREATION_DATE
					    , @v_batch_user     AS LAST_UPDATED_BY
					    , GETDATE()         AS LAST_UPDATE_DATE
					    , @v_creation_seq   AS CREATION_SEQ
			    FROM   sub A
			    GROUP BY	  A.DIVISION_ID
						    , A.ORIGIN_DIVISION_ID
						    , A.PLAN_START_YYYYMMDD
						    , A.PSI
						    , A.ELEC_MODEL
						    , A.CELL_MODEL
						    , A.ELECTRODE_TYPE
						    , A.COMPANY
						    , A.PLANT
						    , A.FROM_SITE
						    , A.TO_SITE
						    , A.UNIT
						    , A.MEASURE
						    , A.VALUE1
						    , A.VALUE2
						    , A.YYYYMMDD

            SET @n_log_count = @@ROWCOUNT;

            PRINT(CONCAT('MEASURE : PROD_PLAN_ENGINE (', @n_log_count, ')'));
	    END

PRINT CONCAT('ELAPSED_TIME6 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = P';
	    SET @v_description = N'PSI 유형 P: PROD_PLAN_ENGINE';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'INT_INCOM'
	    BEGIN
            -- P
            -- 전극입고 (운송중) : from site 없고 site_id가 cell인거
            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM;

			SELECT	A.*
			INTO    #T_SCP_RPT_ELEC_PSI_INT_COM
			FROM    (
                        SELECT  A.*
                                , (SELECT TOKEN FROM dbo.STRING_SPLIT(A.SITE_ID, '~') WHERE NR = 1) AS SCM_SITE_ID
                        FROM    dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
			            WHERE	1=1
				            AND A.MASTER_ID = CONCAT(@v_division_id_ee, '::', @v_plan_cycle) --'EE::WEEKLY'
				            AND A.PLAN_ID   = CONCAT(@v_plan_id_ee_STOCK, '::', @v_plan_type_ee_STOCK, '::', @v_plan_seq_ee_STOCK) --'1261::FN::1'
				            AND A.DESCR LIKE 'INT%'
                    ) A
                    JOIN #T_SCP_RPT_ELEC_PSI_SITE B ON
                            A.SCM_SITE_ID = B.SCM_SITE_ID
                        AND B.DIVISION_ID = @v_division_id

            IF @v_test_mode = 'T'
            BEGIN
                IF @v_test_mode_item_id <> '' AND @v_test_mode_item_id IS NOT NULL
                BEGIN
                    DELETE FROM #T_SCP_RPT_ELEC_PSI_INT_COM WHERE ITEM_ID <> @v_test_mode_item_id
                END
            END


            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_SITE') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_SITE;

            SELECT	  A.*
                    , B.PLANT_ID
                    , B.DIVISION_ID
                    , B.COMPANY_ID
            INTO    #T_SCP_RPT_ELEC_PSI_INT_COM_SITE
            FROM	#T_SCP_RPT_ELEC_PSI_INT_COM A
                    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
                            A.SCM_SITE_ID = B.SCM_SITE_ID
            WHERE	1=1
                AND B.OPERATION_GROUP = 'A'


            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM;

			SELECT	  A.*
					, B.CELL_ITEM_ID
					, B.CONVERT_QTY_CELL
					, ISNULL(C.ELECTRODE_TYPE, '') ELECTRODE_TYPE
            INTO    #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM
			FROM	#T_SCP_RPT_ELEC_PSI_INT_COM_SITE A
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_FINAL_ITEM B WITH(NOLOCK) ON 
							A.ITEM_ID = B.ITEM_ID 
						AND A.DIVISION_ID = B.DIVISION_ID
					LEFT JOIN 
						(
							SELECT	  ITEM_ID
									, ELECTRODE_TYPE
							FROM	#T_SCP_RPT_ELEC_PSI_FINAL_ITEM
							GROUP BY ITEM_ID, ELECTRODE_TYPE
						) C ON 
							A.ITEM_ID = C.ITEM_ID

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
  			      DIVISION_ID
				, ORG_DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PSI
				, ELEC_MODEL
				, CELL_MODEL
				, ELECTRODE_TYPE
				, COMPANY_ID
			    , PLAN_TYPE
				, PLANT_ID
				, FROM_SITE
				, TO_SITE
				, UNIT
				, MEASURE
				, VALUE1
				, VALUE2
				, YYYYMMDD
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, CREATION_SEQ
			)
			SELECT	  @v_division_id_ee                                         AS DIVISION_ID
					, A.DIVISION_ID                                             AS ORIGIN_DIVISION_ID
					, @v_plan_start_yyyymmdd_this                               AS PLAN_START_YYYYMMDD
					, 'P'                                                       AS PSI
					, A.ITEM_ID                                                 AS ELEC_MODEL
					, A.CELL_ITEM_ID                                            AS CELL_MODEL
					, A.ELECTRODE_TYPE                                          AS ELECTRODE_TYPE
					, A.COMPANY_ID                                              AS COMPANY
				    , @p_plan_type                                              AS PLAN_TYPE
					, A.PLANT_ID                                                AS PLANT --G182-A~***
					, ''                                                        AS FROM_SITE
					, A.SCM_SITE_ID                                             AS TO_SITE
					, ''                                                        AS UNIT
					, 'INT_INCOM'                                               AS MEASURE
					, 0                                                         AS VALUE1
					, 0                                                         AS VALUE2
					, FORMAT(A.RECEIVING_DTTM, 'yyyyMMdd')                      AS YYYYMMDD
					, SUM(ISNULL(A.QTY, 0) * ISNULL(A.CONVERT_QTY_CELL, 1))     AS QTY
					, @v_batch_user                                             AS CREATED_BY
					, GETDATE()                                                 AS CREATION_DATE
					, @v_batch_user                                             AS LAST_UPDATED_BY
					, GETDATE()                                                 AS LAST_UPDATE_DATE
					, @v_creation_seq                                           AS CREATION_SEQ
			FROM	#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM A
			GROUP BY A.DIVISION_ID, A.ITEM_ID, A.CELL_ITEM_ID, A.ELECTRODE_TYPE, A.COMPANY_ID, A.PLANT_ID, A.SCM_SITE_ID, A.RECEIVING_DTTM

            SET @n_log_count = @@ROWCOUNT;

            PRINT(CONCAT('MEASURE : INT_INCOM (', @n_log_count, ')'));
	    END


PRINT CONCAT('ELAPSED_TIME7 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = P';
	    SET @v_description = N'PSI 유형 P: INT_INCOM';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'SHIP_PLAN_WH_IN'
	    BEGIN
            -- P
            -- 전극입고 (Ship plan)
            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SHIP_PLAN') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_SHIP_PLAN;

			SELECT	  A.DIVISION_ID
					, A.OPERATION_GROUP
					, A.ITEM_ID
					, A.FROM_SITE
					, A.TO_SITE
					, A.ELECTRODE_TYPE
					, CONVERT(NVARCHAR(8), A.END_TIME, 112) AS YYYYMMDD
					, A.COMPLETE_QTY                        AS QTY
					, A.ORIGIN_TO_DIVISION_ID
					, C.COMPANY_ID
					, C.PLANT_ID
            INTO    #T_SCP_RPT_ELEC_PSI_SHIP_PLAN
			FROM	dbo.SCP_PLN_SHIPMENT_PLAN A WITH(NOLOCK)
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
							A.FROM_SITE = B.SCM_SITE_ID
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE C WITH(NOLOCK) ON 
							A.TO_SITE = C.SCM_SITE_ID
			WHERE	1=1
				AND A.DIVISION_ID           = @v_division_id_ee
				AND A.ORIGIN_TO_DIVISION_ID = @v_division_id --chaan
				AND A.PLAN_START_YYYYMMDD   = @v_plan_name_ee_PLAN
				AND A.PLAN_TYPE             = @v_plan_type_ee_PLAN
				AND A.SEQ                   = @v_plan_seq_ee_PLAN
				AND A.MEASURE               = 'SHIP_PLAN'
				AND A.SEMI_YN               = 'Y'
				AND B.COMPANY_ID            != C.COMPANY_ID

            IF @v_test_mode = 'T'
            BEGIN
                IF @v_test_mode_item_id <> '' AND @v_test_mode_item_id IS NOT NULL
                BEGIN
                    DELETE FROM #T_SCP_RPT_ELEC_PSI_SHIP_PLAN WHERE ITEM_ID <> @v_test_mode_item_id
                END
            END


            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN;

			SELECT	  A.ITEM_ID                                             AS ELEC_MODEL
					, C.CELL_ITEM_ID                                        AS CELL_MODEL
					, A.ELECTRODE_TYPE                                      AS ELECTRODE_TYPE
					, A.COMPANY_ID                                          AS COMPANY
					, A.PLANT_ID                                            AS PLANT
					, A.FROM_SITE                                           AS FROM_SITE
					, A.TO_SITE                                             AS TO_SITE
					, ''                                                    AS UNIT
					, 'SHIP_PLAN_WH_IN'                                     AS MEASURE
					, 0                                                     AS VALUE1
					, 0                                                     AS VALUE2
					, A.YYYYMMDD
					, SUM(ISNULL(A.QTY, 0) * ISNULL(C.CONVERT_QTY_CELL, 1)) AS QTY
					, A.DIVISION_ID
					, A.ORIGIN_TO_DIVISION_ID
					, @v_plan_start_yyyymmdd_this                                AS PLAN_START_YYYYMMDD
					, 'P'                                                   AS PSI
            INTO    #T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN
			FROM	#T_SCP_RPT_ELEC_PSI_SHIP_PLAN A
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_FINAL_ITEM C ON 
                            A.ORIGIN_TO_DIVISION_ID = C.DIVISION_ID -- 데이터 중복으로 추가 by chaan
                        AND A.ITEM_ID = C.ITEM_ID
			WHERE	1=1
			GROUP BY    A.ITEM_ID
                      , C.CELL_ITEM_ID
                      , A.ELECTRODE_TYPE
                      , A.COMPANY_ID
                      , A.PLANT_ID
                      , A.FROM_SITE
                      , A.TO_SITE
                      , A.YYYYMMDD
                      , A.DIVISION_ID
                      , A.ORIGIN_TO_DIVISION_ID
                      , A.ELECTRODE_TYPE

--TESTING : NOK
--select * from #T_SCP_RPT_ELEC_PSI_SHIP_PLAN;
--select * from #T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN;return;

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
				  DIVISION_ID
				, ORG_DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PSI
				, ELEC_MODEL
				, CELL_MODEL
				, ELECTRODE_TYPE
				, COMPANY_ID
                , PLAN_TYPE
				, PLANT_ID
				, FROM_SITE
				, TO_SITE
				, UNIT
				, MEASURE
				, VALUE1
				, VALUE2
				, YYYYMMDD
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, CREATION_SEQ
			)
			SELECT	  A.DIVISION_ID
					, A.ORIGIN_TO_DIVISION_ID
					, A.PLAN_START_YYYYMMDD
					, A.PSI
					, A.ELEC_MODEL
					, A.CELL_MODEL
					, A.ELECTRODE_TYPE
					, A.COMPANY
    				, @p_plan_type      AS PLAN_TYPE
					, A.PLANT
					, A.FROM_SITE
					, A.TO_SITE
					, A.Unit
					, A.Measure
					, A.Value1
					, A.Value2
					, A.YYYYMMDD
					, A.QTY
					, @v_batch_user     AS CREATED_BY
					, GETDATE()         AS CREATION_DATE
					, @v_batch_user     AS LAST_UPDATED_BY
					, GETDATE()         AS LAST_UPDATE_DATE
					, @v_creation_seq   AS CREATION_SEQ
			FROM	#T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN A

		    SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('MEASURE : SHIP_PLAN_WH_IN (', @n_log_count, ')'));
	    END

PRINT CONCAT('ELAPSED_TIME8 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type			= 'APPEND';
	    SET @v_log_message		= 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = P';
	    SET @v_description		= N'PSI 유형 P: SHIP_PLAN_WH_IN';
	    SET @d_event_date		= SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'EOH'
	    BEGIN
		    --EOH
            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB;

			SELECT DISTINCT
                      A.ITEM_ID
					, B.COMPANY_ID
					, B.DIVISION_ID
					, B.PLANT_ID
                    , B.SCM_SITE_ID
            INTO    #T_SCP_RPT_ELEC_PSI_EOH1_SUB
			FROM	(
                        SELECT    A.*
                                , (SELECT TOKEN FROM dbo.STRING_SPLIT(A.SITE_ID, '~') WHERE NR = 1) AS SCM_SITE_ID
                        FROM    dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
                        WHERE   1=1
				            AND A.MASTER_ID = CONCAT(@v_division_id_ee, '::', @v_plan_cycle) --'EE::WEEKLY'
				            AND A.PLAN_ID   = CONCAT(@v_plan_id_ee_STOCK, '::', @v_plan_type_ee_STOCK, '::', @v_plan_seq_ee_STOCK) --'1261::FN::1'
				            AND A.DESCR LIKE 'WH%'
                    ) A
                    JOIN #T_SCP_RPT_ELEC_PSI_SITE B ON
                            A.SCM_SITE_ID = B.SCM_SITE_ID
                        AND B.DIVISION_ID = @v_division_id
				        AND (A.SCM_SITE_ID LIKE '%-E%' OR --TESTING
                             A.SCM_SITE_ID LIKE '%-A%')   --TESTING

        	CREATE CLUSTERED INDEX IDX_T_SCP_RPT_ELEC_PSI_EOH1_SUB ON #T_SCP_RPT_ELEC_PSI_EOH1_SUB (ITEM_ID);


--TESTING : NOK
--select * from #T_SCP_RPT_ELEC_PSI_EOH1_SUB;return;
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH1_SUB
--where   1=1
--    AND ITEM_ID = 'APCAN2173A';
--return;


            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB1') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB1;

			SELECT	  A.*
					, B.CELL_ITEM_ID
					, B.CONVERT_QTY_CELL
					, ISNULL(C.ELECTRODE_TYPE, '') ELECTRODE_TYPE
            INTO    #T_SCP_RPT_ELEC_PSI_EOH1_SUB1
			FROM	#T_SCP_RPT_ELEC_PSI_EOH1_SUB A
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_FINAL_ITEM B WITH(NOLOCK) ON 
							A.ITEM_ID = B.ITEM_ID 
						AND A.DIVISION_ID = B.DIVISION_ID
					LEFT JOIN 
						(
							SELECT	  ITEM_ID
									, ELECTRODE_TYPE
							FROM	#T_SCP_RPT_ELEC_PSI_FINAL_ITEM
							GROUP BY ITEM_ID, ELECTRODE_TYPE
						) C ON 
							A.ITEM_ID = C.ITEM_ID

        	CREATE CLUSTERED INDEX IDX_T_SCP_RPT_ELEC_PSI_EOH1_SUB1 ON #T_SCP_RPT_ELEC_PSI_EOH1_SUB1 (ITEM_ID, COMPANY_ID);

            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB2') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB2

			SELECT	  A.DIVISION_ID
					, A.ITEM_ID
					, A.COMPANY_ID
					, A.CELL_ITEM_ID
					, A.ELECTRODE_TYPE
					, A.PLANT_ID
					, SUM(ISNULL(B.VALUE1, 0)) AS VALUE1
					, SUM(ISNULL(B.VALUE2, 0)) AS VALUE2
            INTO    #T_SCP_RPT_ELEC_PSI_EOH1_SUB2
			FROM	#T_SCP_RPT_ELEC_PSI_EOH1_SUB1 A
-- #T_SCP_RPT_ELEC_PSI_EOH1_SUB1 데이터 없을 경우도 있음!!!					LEFT JOIN #T_SCP_RPT_ELEC_PSI_EOH_ALL B ON 
					LEFT JOIN #T_SCP_RPT_ELEC_PSI_EOH_ALL B ON -- #T_SCP_RPT_ELEC_PSI_EOH1_SUB1 데이터 없을 경우도 있음!!!
							A.ITEM_ID = B.ITEM_ID 
						AND A.COMPANY_ID = B.COMPANY_ID
			GROUP BY A.DIVISION_ID, A.ITEM_ID, A.COMPANY_ID, A.CELL_ITEM_ID, A.ELECTRODE_TYPE, A.PLANT_ID

        	CREATE CLUSTERED INDEX IDX_T_SCP_RPT_ELEC_PSI_EOH1_SUB2 ON #T_SCP_RPT_ELEC_PSI_EOH1_SUB2 (ITEM_ID);

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_EOH1_SUB2;return;
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH_ALL
--where   1=1
--    AND ITEM_ID = 'APCAN2173A'
--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH1_SUB1
--where   1=1
--    AND ITEM_ID = 'APCAN2173A'

--select  * 
--from    #T_SCP_RPT_ELEC_PSI_EOH1_SUB2
--where   1=1
--    AND ITEM_ID = 'APCAN2173A'
--return;

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
				  DIVISION_ID
				, ORG_DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PSI
				, ELEC_MODEL
				, CELL_MODEL
				, ELECTRODE_TYPE
				, COMPANY_ID
                , PLAN_TYPE
				, PLANT_ID
				, FROM_SITE
				, TO_SITE
				, UNIT
				, MEASURE
				, VALUE1
				, VALUE2
				, YYYYMMDD
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, CREATION_SEQ
			)
			SELECT	  @v_division_id_ee         AS DIVISION_ID
					, DIVISION_ID               AS ORG_DIVISION_ID
					, @v_plan_start_yyyymmdd_this    AS PLAN_START_YYYYMMDD
					, 'I'                       AS PSI
					, ITEM_ID                   AS ELEC_MODEL
					, CELL_ITEM_ID              AS CELL_MODEL
					, ELECTRODE_TYPE
					, COMPANY_ID
					, @p_plan_type              AS PLAN_TYPE
					, PLANT_ID
					, ''                        AS FROM_SITE
					, ''                        AS TO_SITE
					, ''                        AS UNIT
					, 'EOH'                     AS MEASURE
					, VALUE1
					, VALUE2
					, @v_plan_start_yyyymmdd_this    AS YYYYMMDD
					, 0                         AS QTY
					, @v_batch_user             AS CREATED_BY
					, GETDATE()                 AS CREATION_DATE
					, @v_batch_user             AS LAST_UPDATED_BY
					, GETDATE()                 AS LAST_UPDATE_DATE
					, @v_creation_seq           AS CREATION_SEQ
			FROM	#T_SCP_RPT_ELEC_PSI_EOH1_SUB2
			WHERE	1=1
                AND (ISNULL(VALUE1, 0) <> 0 OR  --TESTING
                     ISNULL(VALUE2, 0) <> 0)    --TESTING
			ORDER BY ITEM_ID

		    SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('MEASURE : EOH1 (', @n_log_count, ')'));
	    END

PRINT CONCAT('ELAPSED_TIME9 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type		= 'APPEND';
	    SET @v_log_message	= 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = I';
	    SET @v_description	= N'PSI 유형 I: EOH';
	    SET @d_event_date	= SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'EOH'
	    BEGIN
		    --EOH (P나 S에 없는 것들)
            IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH2_SUB') IS NOT NULL)
                DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH2_SUB

			SELECT	  A.ELEC_MODEL                  AS ITEM_ID
					, A.CELL_MODEL                  AS CELL_ITEM_ID
					, A.COMPANY_ID
					, A.ORG_DIVISION_ID
					, ISNULL(A.ELECTRODE_TYPE, '')  AS ELECTRODE_TYPE
					, 0                             AS VALUE1
					, 0                             AS VALUE2
					, A.PLANT_ID
            INTO    #T_SCP_RPT_ELEC_PSI_EOH2_SUB
			FROM	#T_SCP_RPT_ELEC_PSI A
			WHERE	1=1
				AND A.PSI IN ('P', 'S')
				AND NOT EXISTS 
				(
					SELECT	1
					FROM	#T_SCP_RPT_ELEC_PSI
					WHERE	PSI = 'I'
						AND MEASURE = 'EOH'
						AND ELEC_MODEL = A.ELEC_MODEL
						AND CELL_MODEL = A.CELL_MODEL
						AND COMPANY_ID = A.COMPANY_ID
				)
			GROUP BY A.ELEC_MODEL, A.CELL_MODEL, A.COMPANY_ID, A.ORG_DIVISION_ID, ISNULL(A.ELECTRODE_TYPE, ''), A.PLANT_ID
--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI_EOH2_SUB;return;

			INSERT INTO #T_SCP_RPT_ELEC_PSI
			(
				  DIVISION_ID
				, ORG_DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PSI
				, ELEC_MODEL
				, CELL_MODEL
				, ELECTRODE_TYPE
				, COMPANY_ID
                , PLAN_TYPE
				, PLANT_ID
				, FROM_SITE
				, TO_SITE
				, UNIT
				, MEASURE
				, VALUE1
				, VALUE2
				, YYYYMMDD
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, CREATION_SEQ
			)
			SELECT	  @v_division_id_ee             AS DIVISION_ID
					, ORG_DIVISION_ID
					, @v_plan_start_yyyymmdd_this   AS PLAN_START_YYYYMMDD
					, 'I'                           AS PSI
					, ITEM_ID                       AS ELEC_MODEL
					, CELL_ITEM_ID                  AS CELL_MODEL
					, ELECTRODE_TYPE
					, COMPANY_ID
					, @p_plan_type                  AS PLAN_TYPE
					, PLANT_ID
					, ''                            AS FROM_SITE
					, ''                            AS TO_SITE
					, ''                            AS UNIT
					, 'EOH'                         AS MEASURE
					, VALUE1
					, VALUE2
					, @v_plan_start_yyyymmdd_this   AS YYYYMMDD
					, 0                             AS QTY
					, @v_batch_user                 AS CREATED_BY
					, GETDATE()                     AS CREATION_DATE
					, @v_batch_user                 AS LAST_UPDATED_BY
					, GETDATE()                     AS LAST_UPDATE_DATE
					, @v_creation_seq               AS CREATION_SEQ
			FROM	#T_SCP_RPT_ELEC_PSI_EOH2_SUB
			WHERE	1=1
			ORDER BY ITEM_ID

		    SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('MEASURE : EOH2 (', @n_log_count, ')'));
	    END

PRINT CONCAT('ELAPSED_TIME10 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = I';
	    SET @v_description = N'PSI 유형 I: EOH';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI where MEASURE = 'EOH';return;
--select  * 
--from    #T_SCP_RPT_ELEC_PSI 
--where 1=1
--    AND MEASURE    = 'EOH' 
--    AND ELEC_MODEL = 'APCAN1298A'
--return;


	    --'YIELD_E'
	    BEGIN
		    --YIELD_E
		    ;WITH sub AS
		    (
			    SELECT	  A.ITEM_ID
					    , A.DIVISION_ID
					    , A.YIELD
					    , A.TACT_TIME_START_DATE
					    , A.TACT_TIME_END_DATE
					    , B.COMPANY_ID
					    , B.PLANT_ID
					    , B.OPERATION_GROUP
			    FROM	#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT A WITH(NOLOCK)
					    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON	
							    A.PLANT_SITE_ID = B.SCM_SITE_ID
			    WHERE	1=1
				    AND A.OPERATION_ID IN ('Z_E00T') -- 전극 후공정 수율
		    ),
		    sub1 AS
		    (
			    SELECT	  A.*
					    , ISNULL(B.YIELD, 1) QTY
					    , B.TACT_TIME_START_DATE
					    , B.TACT_TIME_END_DATE
					    , 'YIELD_E' MEASURE
			    FROM	(
						    SELECT	  PSI
								    , ORG_DIVISION_ID
								    , ELEC_MODEL
								    , CELL_MODEL
								    , YYYYMMDD
								    , COMPANY_ID
								    , PLANT_ID
								    , ISNULL(ELECTRODE_TYPE, '') ELECTRODE_TYPE
						    FROM	#T_SCP_RPT_ELEC_PSI
						    WHERE	1=1
							    AND PSI != 'I'
						    GROUP BY	  PSI
									    , ORG_DIVISION_ID
									    , ELEC_MODEL
									    , CELL_MODEL
									    , YYYYMMDD
									    , COMPANY_ID
									    , PLANT_ID
									    , ISNULL(ELECTRODE_TYPE, '')
					    ) A
					    LEFT JOIN sub B ON 
							    A.ORG_DIVISION_ID = B.DIVISION_ID 
						    AND A.COMPANY_ID = B.COMPANY_ID 
						    AND A.ELEC_MODEL = B.ITEM_ID 
						    AND A.PLANT_ID = B.PLANT_ID 
						    AND A.YYYYMMDD BETWEEN B.TACT_TIME_START_DATE AND B.TACT_TIME_END_DATE
			    WHERE	1=1
				    AND B.OPERATION_GROUP = 'E'
		    ),
		    sub2 AS
		    (
			    SELECT	  *
					    , ROW_NUMBER() OVER (PARTITION BY A.ORG_DIVISION_ID, A.ELEC_MODEL, A.CELL_MODEL, A.COMPANY_ID, A.YYYYMMDD, ELECTRODE_TYPE ORDER BY A.YYYYMMDD) RN
			    FROM	sub1 A
		    )
			    INSERT INTO #T_SCP_RPT_ELEC_PSI
			    (
				      DIVISION_ID
				    , ORG_DIVISION_ID
				    , PLAN_START_YYYYMMDD
				    , PSI
				    , ELEC_MODEL
				    , CELL_MODEL
				    , ELECTRODE_TYPE
				    , COMPANY_ID
                    , PLAN_TYPE
				    , PLANT_ID
				    , FROM_SITE
				    , TO_SITE
				    , UNIT
				    , MEASURE
				    , VALUE1
				    , VALUE2
				    , YYYYMMDD
				    , QTY
				    , CREATED_BY
				    , CREATION_DATE
				    , LAST_UPDATED_BY
				    , LAST_UPDATE_DATE
				    , CREATION_SEQ
			    )
			    SELECT	  @v_division_id_ee             AS DIVISION_ID
					    , ORG_DIVISION_ID
					    , @v_plan_start_yyyymmdd_this   AS PLAN_START_YYYYMMDD
					    , 'I'                           AS PSI
					    , ELEC_MODEL
					    , CELL_MODEL
					    , ELECTRODE_TYPE
					    , COMPANY_ID
					    , @p_plan_type                  AS PLAN_TYPE
					    , PLANT_ID
					    , ''                            AS FROM_SITE
					    , ''                            AS TO_SITE
					    , ''                            AS UNIT
					    , MEASURE
					    , 0                             AS VALUE1
					    , 0                             AS VALUE2
					    , YYYYMMDD
					    , QTY
					    , @v_batch_user                 AS CREATED_BY
					    , GETDATE()                     AS CREATION_DATE
					    , @v_batch_user                 AS LAST_UPDATED_BY
					    , GETDATE()                     AS LAST_UPDATE_DATE
					    , @v_creation_seq               AS CREATION_SEQ
			    FROM	sub2
			    WHERE	RN = 1

		    SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('MEASURE : YIELD_E (', @n_log_count, ')'));
	    END

PRINT CONCAT('ELAPSED_TIME11 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = I';
	    SET @v_description = N'PSI 유형 I: YIELD_E';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------

	    --'YIELD_A'
	    BEGIN
		    --YIELD_A
		    ;WITH sub AS
		    (
			    SELECT	  A.ITEM_ID
					    , A.DIVISION_ID
					    , A.YIELD
					    , A.TACT_TIME_START_DATE
					    , A.TACT_TIME_END_DATE
					    , B.COMPANY_ID
					    , B.PLANT_ID
					    , B.OPERATION_GROUP
			    FROM	#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT A WITH(NOLOCK)
					    LEFT JOIN #T_SCP_RPT_ELEC_PSI_SITE B WITH(NOLOCK) ON 
							    A.PLANT_SITE_ID = B.SCM_SITE_ID
			    WHERE	1=1
				    AND A.OPERATION_ID IN ('Z_A00T') -- 전극 후공정 수율
		    ),
		    sub1 AS
		    (
			    SELECT	  A.*
					    , ISNULL(B.YIELD, 1) AS QTY
					    , B.TACT_TIME_START_DATE
					    , B.TACT_TIME_END_DATE
					    , 'YIELD_A' MEASURE
			    FROM	(
						    SELECT	  PSI
								    , ORG_DIVISION_ID
								    , ELEC_MODEL
								    , CELL_MODEL
								    , YYYYMMDD
								    , COMPANY_ID
								    , PLANT_ID
								    , ISNULL(ELECTRODE_TYPE, '') ELECTRODE_TYPE
						    FROM	#T_SCP_RPT_ELEC_PSI
						    WHERE	1=1
							    AND PSI != 'I'
						    GROUP BY	  PSI
									    , ORG_DIVISION_ID
									    , ELEC_MODEL
									    , CELL_MODEL
									    , YYYYMMDD
									    , COMPANY_ID
									    , PLANT_ID
									    , ISNULL(ELECTRODE_TYPE, '')
					    ) A
					    LEFT JOIN sub B ON 
							    A.ORG_DIVISION_ID = B.DIVISION_ID 
						    AND A.COMPANY_ID = B.COMPANY_ID 
						    AND A.CELL_MODEL = B.ITEM_ID 
						    AND A.PLANT_ID = B.PLANT_ID 
						    AND A.YYYYMMDD BETWEEN B.TACT_TIME_START_DATE AND B.TACT_TIME_END_DATE
			    WHERE	1=1
				    AND B.OPERATION_GROUP = 'A'
		    ),
		    sub2 AS
		    (
			    SELECT	  *
					    , ROW_NUMBER() OVER (PARTITION BY A.ORG_DIVISION_ID, A.ELEC_MODEL, A.CELL_MODEL, A.COMPANY_ID, A.YYYYMMDD, A.ELECTRODE_TYPE ORDER BY A.YYYYMMDD) RN
			    FROM	sub1 A
		    )
			    INSERT INTO #T_SCP_RPT_ELEC_PSI
			    (
				      DIVISION_ID
				    , ORG_DIVISION_ID
				    , PLAN_START_YYYYMMDD
				    , PSI
				    , ELEC_MODEL
				    , CELL_MODEL
				    , ELECTRODE_TYPE
				    , COMPANY_ID
                    , PLAN_TYPE
				    , PLANT_ID
				    , FROM_SITE
				    , TO_SITE
				    , UNIT
				    , MEASURE
				    , VALUE1
				    , VALUE2
				    , YYYYMMDD
				    , QTY
				    , CREATED_BY
				    , CREATION_DATE
				    , LAST_UPDATED_BY
				    , LAST_UPDATE_DATE
				    , CREATION_SEQ
			    )
			    SELECT	  @v_division_id_ee             AS DIVISION_ID
					    , ORG_DIVISION_ID
					    , @v_plan_start_yyyymmdd_this   AS PLAN_START_YYYYMMDD
					    , 'I'                           AS PSI
					    , ELEC_MODEL
					    , CELL_MODEL
					    , ELECTRODE_TYPE
					    , COMPANY_ID
                        , @p_plan_type                  AS PLAN_TYPE
					    , PLANT_ID
					    , ''                            AS ROM_SITE
					    , ''                            AS O_SITE
					    , ''                            AS NIT
					    , MEASURE
					    , 0                             AS VALUE1
					    , 0                             AS VALUE2
					    , YYYYMMDD
					    , QTY
					    , @v_batch_user                 AS CREATED_BY
					    , GETDATE()                     AS CREATION_DATE
					    , @v_batch_user                 AS LAST_UPDATED_BY
					    , GETDATE()                     AS LAST_UPDATE_DATE
					    , @v_creation_seq               AS CREATION_SEQ
			    FROM	sub2
			    WHERE	RN = 1

		    SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('MEASURE : YIELD_A (', @n_log_count, ')'));
	    END

--TESTING : OK
--select * from #T_SCP_RPT_ELEC_PSI; return;

PRINT CONCAT('ELAPSED_TIME12 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'APPEND';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI , PSI = I';
	    SET @v_description = N'PSI 유형 I: YIELD_A';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
	    -----------------------------------------------------------
--select * from #T_SCP_RPT_ELEC_PSI where MEASURE = 'SHIP_PLAN';return;

        IF @v_test_mode <> 'T'
        BEGIN
            INSERT INTO SCP_RPT_ELEC_PSI WITH(TABLOCK)
            (
                  DIVISION_ID
                , ORG_DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PSI
                , ELEC_MODEL
                , CELL_MODEL
                , ELECTRODE_TYPE
                , COMPANY_ID
                , PLAN_TYPE
                , PLANT_ID
                , FROM_SITE
                , TO_SITE
                , UNIT
                , MEASURE
                , VALUE1
                , VALUE2
                , YYYYMMDD
                , QTY
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                , CREATION_SEQ
            )
	            SELECT	  DIVISION_ID
			            , ORG_DIVISION_ID
			            , PLAN_START_YYYYMMDD
			            , PSI
			            , ELEC_MODEL
			            , CELL_MODEL
			            , ELECTRODE_TYPE
			            , COMPANY_ID
                        , PLAN_TYPE
			            , PLANT_ID
			            , FROM_SITE
			            , TO_SITE
			            , UNIT
			            , MEASURE
			            , VALUE1
			            , VALUE2
			            , YYYYMMDD
			            , QTY
			            , CREATED_BY
			            , CREATION_DATE
			            , LAST_UPDATED_BY
			            , LAST_UPDATE_DATE
			            , CREATION_SEQ
	            FROM	#T_SCP_RPT_ELEC_PSI
	            WHERE	1=1
		            AND YYYYMMDD <= @v_plan_to_yyyymmdd

	        SET @n_log_count = @@ROWCOUNT;

		    PRINT(CONCAT('INSERT INTO SCP_RPT_ELEC_PSI COUNT : (', @n_log_count, ')'));
        END
        ELSE
        BEGIN
	            SELECT	  DIVISION_ID
			            , ORG_DIVISION_ID
			            , PLAN_START_YYYYMMDD
			            , PSI
			            , ELEC_MODEL
			            , CELL_MODEL
			            , ELECTRODE_TYPE
			            , COMPANY_ID
                        , PLAN_TYPE
			            , PLANT_ID
			            , FROM_SITE
			            , TO_SITE
			            , UNIT
			            , MEASURE
			            , VALUE1
			            , VALUE2
			            , YYYYMMDD
			            , QTY
			            , CREATED_BY
			            , CREATION_DATE
			            , LAST_UPDATED_BY
			            , LAST_UPDATE_DATE
			            , CREATION_SEQ
	            FROM	#T_SCP_RPT_ELEC_PSI
	            WHERE	1=1
		            AND YYYYMMDD <= @v_plan_to_yyyymmdd
	                --AND ELEC_MODEL = @v_test_mode_item_id --testing 용

	            SELECT DISTINCT
                          ORG_DIVISION_ID
			            , MEASURE
	            FROM	#T_SCP_RPT_ELEC_PSI
	            WHERE	1=1
		            AND YYYYMMDD <= @v_plan_to_yyyymmdd
        END


PRINT CONCAT('ELAPSED_TIME13 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

	    -----------------------------------------------------------
	    -- Insert LOG
	    -----------------------------------------------------------
	    SET @v_log_type = 'INSERT';
	    SET @v_log_message = 'INSERT INTO SCP_RPT_ELEC_PSI';
	    SET @v_description = N'TOTAL';
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;
        PRINT CONCAT('@n_log_count : ', @n_log_count)
	    -----------------------------------------------------------
    END TRY
    BEGIN CATCH
	    IF @@TRANCOUNT > 0
	    BEGIN
		    ROLLBACK;
	    END;

	    -- ERROR LOG
	    SET @v_log_type = 'ERROR';
	    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
	    SET @d_event_date = SYSDATETIME();

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_type;
        PRINT @v_log_message;
        PRINT @v_description;

	    PRINT(CONCAT('@v_log_type : ', @v_log_type));
	    PRINT(CONCAT('@v_log_message : ', @v_log_message));
    END CATCH;

	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_BOM_FINAL_ITEM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND1;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND2;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND3;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND4;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_COAT_REQ_PROD_PLAN_AMEND5_PKG_PLAN;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB1') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB1;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH1_SUB2') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH1_SUB2;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH2_SUB') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH2_SUB;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_1') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_1;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_2') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_2;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_ALL') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_ALL;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_EOH_SUM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_EOH_SUM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_FINAL_ITEM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_FINAL_ITEM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SCM_MST_BOM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_SCM_MST_BOM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SHIP_PLAN') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_SHIP_PLAN;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_SHIP_PLAN_WH_IN;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_SITE') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_SITE;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_ITEM_RAW;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_INT_COM_SITE') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_INT_COM_SITE;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TACT_TIME_EXCEPT;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB;
	IF (OBJECT_ID('tempdb..#T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP') IS NOT NULL)
		DROP TABLE #T_SCP_RPT_ELEC_PSI_TARGET_ITEM_RESULT_SUB_TEMP;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    IF @v_test_mode <> 'T'
    BEGIN
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END

    PRINT @v_log_type;
    PRINT @v_log_message;
    PRINT @v_description;
END
