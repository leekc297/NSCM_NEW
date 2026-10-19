---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*--------------------------------------------------------------------------------------------------*/
/* Program ID  : [DM0003_SAVE_MKT_FCST]                                                             */
/* Description : MKT FCST 저장, 수정, 삭제                                                          */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/27  KHSONG  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
** 20180531 insert시 테이블 컬럼지정
** 20180611 MKT_FCST_QTY_BALANCE_CREATE 로직 추가
** 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (임시로직으로 차후삭제필요)
** 20180618 KHSONG 40 DIVISION 조건 추가
** 20180627 KHSONG MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발
** 20180703 KHSONG SCM_MST_SITE테이블의 VMI대상조건 추가
** 20180703 KHSONG 1. 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. 
**                    BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴.
**				   2. 저장하려는 SITE의 4주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. 
**                    SITE SHIP-TO가 없다고 Alert을 띄우고 ROLLBACK시킴.
** ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■
** 20180710 SKH 속도개선 수정 버전
** ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■
** 20180713   KHSONG VMI_In_Plan 조건 추가, 당주월요일 초재고 VMI_Inv 값은 SCM_DNM_STOCK_V 에서 산출
** 20180717   KHSONG 속도개선 커서제거 로직으로 수정 (VMI재고 확인후 RTF 생성 로직)
** 20180720   KHSONG ACTIVE_FLAG 조건추가
** 20180725   ytchoi vmi stock qty 를 초재고로 적용
** 20180730   KHSONG 대상 Row 수가 20건 이하일 때만 수행하도록 처리
** 20180731   KHSONG balance등 저장속도개선
** 20180806   KHSONG 2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함)
** 20180810-1 KHSONG 소형은 BOM Validation 에서 제외
** 20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외
** 20180810-2 KHSONG 소형은 BALANCE_CREATE 에서 제외 (임시)
** 20180813   KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
** 20180813   ytchoi 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직은 Div:40 소형은 제외로직 추가
** 20180816   KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출
** 20180816   KHSONG Unit Price가 없는 MKT_FCST validation
** 20180914-1 KHSONG (20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
** 20180914-2 KHSONG (20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
** 20180914 소형도 FROM_SITE 조건에 추가
** 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
** 20181002 KHSONG BALANCE CREATE 프로시져 호출로직으로 변경
** 20181005 khsong 공백제거로직추가
** 20181011 khsong Price가 없는 case Validation 에서 제외
** 20181012 BLOCK Model
** 20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
** 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type 조건추가
** 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation
** 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
** 20190115 KHSONG SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
** 20190118 KHSONG ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
** 20190614 KHSONG 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
** 20190708 KHSONG 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
** 20190709 KHSONG [CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
** 20200304 KHSONG 날짜선택 오류수정
** 20200507 KHSONG C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 2020/05/22     P.C.I		[C20200525-000296] (81 사업부) MKT Fcst 입력 시 Unit Price 체크 기준에 Plant Site 조건 추가
** 20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건)
 2020/06/08     P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 2020/06/15     P.C.I		[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
 2020/07/07     hwi1993		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화 -- 제품일경우에만 적용
 2020/07/09     P.C.I		[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가
 2020/07/16		hwi1993		[C20200713-000189] [VMI-in Req] 에 의해 자동계산된 mkt fcst 는 무시하고, 다시 자동계산해서 insert 함.
 2020/07/20     P.C.I		[C20200717-000157] ESS 사업부 Sales Site Project Model validation 추가
 2025/05/21     KANG.H.J	[PJ2025-00017] CELL_PROD_SITE_ID 추가 - [PJ2025-00017] RTF_BALANCE 계산시 40 사업부와 통일 필요
*/
CREATE PROCEDURE [dbo].[DM0003_SAVE_MKT_FCST]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_dom_exp				NVARCHAR(MAX),
	@p_fcst_type			NVARCHAR(MAX),
	@p_incoterms			NVARCHAR(MAX),
	@p_measure				NVARCHAR(MAX),
	@p_plant_site_id  	    NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)

AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_dom_exp				NVARCHAR(MAX);
	DECLARE @v_fcst_type			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_PLANT_SITE_ID		NVARCHAR(MAX);
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	
    DECLARE @plan_start_yyyymmdd    NVARCHAR(MAX);  -- 20180611 KHSONG ADDED

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_project_code = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_item_id = NULL;
	SET @v_dom_exp = NULL;	 
	SET @v_fcst_type = NULL;	 
	SET @v_incoterms = NULL;	 
	SET @v_measure = NULL;	 
	SET @v_PLANT_SITE_ID = NULL;	 
	SET @v_yyyymmdd = NULL;	
	SET @v_qty = NULL;	  
	SET @v_created_by = NULL;

	DECLARE @read_cnt		INTEGER = 0; 
	DECLARE @read_1000_cnt		INTEGER = 0; 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_MKT_FCST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag    = RTRIM(@p_active_flag   ) + '^';
	SET @p_division_id    = RTRIM(@p_division_id   ) + '^';
	SET @p_project_code   = RTRIM(@p_project_code  ) + '^';
	SET @p_scm_site_id    = RTRIM(@p_scm_site_id   ) + '^';
	SET @p_item_id        = RTRIM(@p_item_id       ) + '^';
	SET @p_dom_exp        = RTRIM(@p_dom_exp       ) + '^';
	SET @p_fcst_type      = RTRIM(@p_fcst_type     ) + '^';
	SET @p_incoterms      = RTRIM(@p_incoterms     ) + '^';
	SET @p_measure        = RTRIM(@p_measure       ) + '^';
	SET @p_plant_site_id  = RTRIM(@p_plant_site_id ) + '^';
	SET @p_yyyymmdd       = RTRIM(@p_yyyymmdd      ) + '^';
	SET @p_qty            = RTRIM(@p_qty           ) + '^';
	SET @p_created_by     = RTRIM(@p_created_by    ) + '^';

	-- TEMP TABLE 확인후 삭제
	IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL 
		DROP TABLE #SEND_TARGET_DATA

	--[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V


	CREATE TABLE #SEND_TARGET_DATA  (
			 division_id      NVARCHAR(30) NOT NULL
			,project_code     NVARCHAR(50) NOT NULL
			,scm_site_id      NVARCHAR(30) NOT NULL
			,item_id          NVARCHAR(50) NOT NULL
			,dom_exp          NVARCHAR(03) NOT NULL
			,fcst_type        NVARCHAR(20) NOT NULL
			,incoterms        NVARCHAR(10) NOT NULL
			,plant_site_id    NVARCHAR(30) NOT NULL
			,vmi_yn           NVARCHAR(01) NULL
			,cell_prod_site_id    NVARCHAR(30) NULL				--	[PJ2025-00017] RTF_BALANCE 계산시 40 사업부와 통일 필요
	)

	CREATE CLUSTERED INDEX [IDX_SEND_TARGET_DATA_N1] ON [#SEND_TARGET_DATA]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		--,v_MEASURE ASC
		,PLANT_SITE_ID ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;

	-- #results TEMP TABLE 변경 20180711
	CREATE TABLE #results  (
             v_active_flag      NVARCHAR(01) NOT NULL
			,v_division_id      NVARCHAR(30) NOT NULL
			,v_project_code     NVARCHAR(50) NOT NULL
			,v_scm_site_id      NVARCHAR(30) NOT NULL
			,v_item_id          NVARCHAR(50) NOT NULL
			,v_dom_exp          NVARCHAR(03) NOT NULL
			,v_fcst_type        NVARCHAR(20) NOT NULL
			,v_incoterms        NVARCHAR(10) NOT NULL
			,v_measure          NVARCHAR(50) NOT NULL
			,v_plant_site_id    NVARCHAR(30) NOT NULL
			,v_yyyymmdd         NVARCHAR(08) NOT NULL
			,v_qty              NUMERIC(30,10) NOT NULL
			,v_created_by       NVARCHAR(150) NULL
			,v_vmi_yn			NCHAR(1)
			,v_dio				int
                           )

	CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [#results]
	(
		 V_DIVISION_ID ASC
		,V_PROJECT_CODE ASC
		,V_SCM_SITE_ID ASC
		,V_ITEM_ID ASC
		,V_DOM_EXP ASC
		,V_FCST_TYPE ASC
		,V_INCOTERMS ASC
		,v_MEASURE ASC
		,V_PLANT_SITE_ID ASC
		,V_YYYYMMDD ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;

	-- @@tmp_site_customer_map TEMP TABLE
	DECLARE @tmp_site_customer_map TABLE (
              DIVISION_ID      NVARCHAR(MAX)
             ,SCM_SITE_ID      NVARCHAR(MAX)
             ,MEASURE          NVARCHAR(MAX)
             ,start_day        NVARCHAR(MAX)
             ,end_day          NVARCHAR(MAX)
			 )
	-- DM_PLN_MKT_FCST 최종 insert값 TEMP TABLE
	CREATE TABLE #tmp_DM_PLN_MKT_FCST  (
              v_DIVISION_ID       NVARCHAR(30)
             ,v_PROJECT_CODE      NVARCHAR(50)
             ,v_SCM_SITE_ID       NVARCHAR(30)
             ,v_ITEM_ID           NVARCHAR(50)
             ,v_DOM_EXP           NVARCHAR(03)
             ,v_FCST_TYPE         NVARCHAR(20)
             ,v_INCOTERMS         NVARCHAR(10)
             ,v_MEASURE           NVARCHAR(50)
             ,v_PLANT_SITE_ID     NVARCHAR(30)
             ,v_YYYYMMDD          NVARCHAR(08)
             ,v_QTY               NUMERIC(20,10)
             ,v_CREATED_BY        NVARCHAR(150)
             ,v_LAST_UPDATED_BY   NVARCHAR(150)
			  )
	CREATE CLUSTERED INDEX [IDX_tmp_DM_PLN_MKT_FCST_N1] ON [#tmp_DM_PLN_MKT_FCST]
	(
		 V_DIVISION_ID ASC
		,V_PROJECT_CODE ASC
		,V_SCM_SITE_ID ASC
		,V_ITEM_ID ASC
		,V_DOM_EXP ASC
		,V_FCST_TYPE ASC
		,V_INCOTERMS ASC
		,v_MEASURE ASC
		,V_PLANT_SITE_ID ASC
		,V_YYYYMMDD ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;
	--CREATE NONCLUSTERED INDEX [IDX_tmp_DM_PLN_MKT_FCST_N2] ON [#tmp_DM_PLN_MKT_FCST]
	--(
	--	 V_DIVISION_ID ASC
	--	,V_PROJECT_CODE ASC
	--	,V_SCM_SITE_ID ASC
	--)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	--;
/*
	DECLARE #tmp_DM_PLN_MKT_FCST TABLE (
              v_DIVISION_ID       NVARCHAR(MAX)
             ,v_PROJECT_CODE      NVARCHAR(MAX)
             ,v_SCM_SITE_ID       NVARCHAR(MAX)
             ,v_ITEM_ID           NVARCHAR(MAX)
             ,v_DOM_EXP           NVARCHAR(MAX)
             ,v_FCST_TYPE         NVARCHAR(MAX)
             ,v_INCOTERMS         NVARCHAR(MAX)
             ,v_MEASURE           NVARCHAR(MAX)
             ,v_PLANT_SITE_ID     NVARCHAR(MAX)
             ,v_YYYYMMDD          NVARCHAR(MAX)
             ,v_QTY               NVARCHAR(MAX)
             ,v_CREATED_BY        NVARCHAR(MAX)
             ,v_CREATION_DATE     NVARCHAR(MAX)
             ,v_LAST_UPDATED_BY   NVARCHAR(MAX)
             ,v_LAST_UPDATE_DATE  NVARCHAR(MAX)
             ,v_ATTRIBUTE1        NVARCHAR(MAX)
             ,v_ATTRIBUTE2        NVARCHAR(MAX)
             ,v_ATTRIBUTE3        NVARCHAR(MAX)
             ,v_ATTRIBUTE4        NVARCHAR(MAX)
             ,v_ATTRIBUTE5        NVARCHAR(MAX)
             ,v_ATTRIBUTE6        NVARCHAR(MAX)
             ,v_ATTRIBUTE7        NVARCHAR(MAX)
             ,v_ATTRIBUTE8        NVARCHAR(MAX)
             ,v_ATTRIBUTE9        NVARCHAR(MAX)
             ,v_ATTRIBUTE10       NVARCHAR(MAX)
			  )
*/
	------------------------------------------------------------- TEMP 추가 20180711


	---- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST

	BEGIN TRY

	--PRINT 'SPLIT START                                      =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
	----------------------------------------------------------|
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                  #results 테이블에 split후 insert (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	WHILE LEN(@p_DIVISION_ID) > 0
	BEGIN

	 DECLARE @index_active_flag    INT
	 DECLARE @index_division_id    INT
	 DECLARE @index_project_code   INT
	 DECLARE @index_scm_site_id    INT
	 DECLARE @index_item_id        INT
	 DECLARE @index_dom_exp        INT
	 DECLARE @index_fcst_type      INT
	 DECLARE @index_incoterms      INT
	 DECLARE @index_measure        INT
	 DECLARE @index_plant_site_id  INT
	 DECLARE @index_yyyymmdd       INT
	 DECLARE @index_qty            INT
	 DECLARE @index_created_by     INT

	 SET @index_active_flag   = PATINDEX('%' + '^' + '%', @p_active_flag    )
	 SET @index_division_id   = PATINDEX('%' + '^' + '%', @p_division_id    )
	 SET @index_project_code  = PATINDEX('%' + '^' + '%', @p_project_code   )
	 SET @index_scm_site_id   = PATINDEX('%' + '^' + '%', @p_scm_site_id    )
	 SET @index_item_id       = PATINDEX('%' + '^' + '%', @p_item_id        )
	 SET @index_dom_exp       = PATINDEX('%' + '^' + '%', @p_dom_exp        )
	 SET @index_fcst_type     = PATINDEX('%' + '^' + '%', @p_fcst_type      )
	 SET @index_incoterms     = PATINDEX('%' + '^' + '%', @p_incoterms      )
	 SET @index_measure       = PATINDEX('%' + '^' + '%', @p_measure        )
	 SET @index_plant_site_id = PATINDEX('%' + '^' + '%', @p_plant_site_id  )
	 SET @index_yyyymmdd      = PATINDEX('%' + '^' + '%', @p_yyyymmdd       )
	 SET @index_qty           = PATINDEX('%' + '^' + '%', @p_qty            )
	 SET @index_created_by    = PATINDEX('%' + '^' + '%', @p_created_by     )

	 -- 확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
		IF @index_DIVISION_ID > 0
			  BEGIN
			   SET @v_active_flag   = SUBSTRING(@p_active_flag  , 0, @index_active_flag     )
			   SET @v_division_id   = SUBSTRING(@p_division_id  , 0, @index_division_id     )
			   SET @v_project_code  = SUBSTRING(@p_project_code , 0, @index_project_code    )
			   SET @v_scm_site_id   = SUBSTRING(@p_scm_site_id  , 0, @index_scm_site_id     )
			   SET @v_item_id       = SUBSTRING(@p_item_id      , 0, @index_item_id         )
			   SET @v_dom_exp       = SUBSTRING(@p_dom_exp      , 0, @index_dom_exp         )
			   SET @v_fcst_type     = SUBSTRING(@p_fcst_type    , 0, @index_fcst_type       )
			   SET @v_incoterms     = SUBSTRING(@p_incoterms    , 0, @index_incoterms       )
			   SET @v_measure       = SUBSTRING(@p_measure      , 0, @index_measure         )
			   SET @v_plant_site_id = SUBSTRING(@p_plant_site_id, 0, @index_plant_site_id   )
			   SET @v_yyyymmdd      = SUBSTRING(@p_yyyymmdd     , 0, @index_yyyymmdd        )
			   SET @v_qty           = SUBSTRING(@p_qty          , 0, @index_qty             )
			   SET @v_created_by    = SUBSTRING(@p_created_by   , 0, @index_created_by      )

			   SET @p_active_flag   = SUBSTRING(@p_active_flag  , LEN(@v_active_flag   + '^') + 1, LEN(@p_active_flag  ))
			   SET @p_division_id   = SUBSTRING(@p_division_id  , LEN(@v_division_id   + '^') + 1, LEN(@p_division_id  ))
			   SET @p_project_code  = SUBSTRING(@p_project_code , LEN(@v_project_code  + '^') + 1, LEN(@p_project_code ))
			   SET @p_scm_site_id   = SUBSTRING(@p_scm_site_id  , LEN(@v_scm_site_id   + '^') + 1, LEN(@p_scm_site_id  ))
			   SET @p_item_id       = SUBSTRING(@p_item_id      , LEN(@v_item_id       + '^') + 1, LEN(@p_item_id      ))
			   SET @p_dom_exp       = SUBSTRING(@p_dom_exp      , LEN(@v_dom_exp       + '^') + 1, LEN(@p_dom_exp      ))
			   SET @p_fcst_type     = SUBSTRING(@p_fcst_type    , LEN(@v_fcst_type     + '^') + 1, LEN(@p_fcst_type    ))
			   SET @p_incoterms     = SUBSTRING(@p_incoterms    , LEN(@v_incoterms     + '^') + 1, LEN(@p_incoterms    ))
			   SET @p_measure       = SUBSTRING(@p_measure      , LEN(@v_measure       + '^') + 1, LEN(@p_measure      ))

				IF (@v_measure = 'MKT_FCST_RP')
					BEGIN 
						SET @v_measure = 'MKT_FCST';
					END;

			   SET @p_plant_site_id = SUBSTRING(@p_plant_site_id, LEN(@v_plant_site_id + '^') + 1, LEN(@p_plant_site_id))
			   SET @p_yyyymmdd      = SUBSTRING(@p_yyyymmdd     , LEN(@v_yyyymmdd      + '^') + 1, LEN(@p_yyyymmdd     ))
			   SET @p_qty           = SUBSTRING(@p_qty          , LEN(@v_qty           + '^') + 1, LEN(@p_qty          ))
			   SET @p_created_by    = SUBSTRING(@p_created_by   , LEN(@v_created_by    + '^') + 1, LEN(@p_created_by   ))

 
				--20181005 khsong 공백제거로직추가 (START)
				SET @v_active_flag				= rtrim(ltrim(@v_active_flag))
				SET @v_division_id				= rtrim(ltrim(@v_division_id))
				SET @v_project_code				= rtrim(ltrim(@v_project_code))
				SET @v_scm_site_id				= rtrim(ltrim(@v_scm_site_id))
				SET @v_item_id					= rtrim(ltrim(@v_item_id))
				SET @v_dom_exp					= rtrim(ltrim(@v_dom_exp))
				SET @v_fcst_type				= rtrim(ltrim(@v_fcst_type))
				SET @v_incoterms				= rtrim(ltrim(@v_incoterms))
				SET @v_measure					= rtrim(ltrim(@v_measure))
				SET @v_PLANT_SITE_ID			= rtrim(ltrim(@v_PLANT_SITE_ID))
				SET @v_yyyymmdd					= rtrim(ltrim(@v_yyyymmdd))
				SET @v_qty						= rtrim(ltrim(@v_qty))
				SET @v_created_by				= rtrim(ltrim(@v_created_by	))
				--20181005 khsong 공백제거로직추가 (END)

				   IF @v_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
						BEGIN 
						   INSERT INTO #results ( 
								  v_active_flag  ,v_division_id  ,v_project_code  ,v_scm_site_id  ,v_item_id      
								 ,v_dom_exp      ,v_fcst_type    ,v_incoterms     ,v_measure      ,v_plant_site_id	 ,v_yyyymmdd     
								 ,v_qty          ,v_created_by  
						   ) VALUES ( 
								  @v_active_flag ,@v_division_id ,@v_project_code ,@v_scm_site_id ,@v_item_id      
								 ,@v_dom_exp     ,@v_fcst_type   ,@v_incoterms    ,@v_measure     ,@v_plant_site_id
								 ,@v_yyyymmdd    ,@v_qty         ,@v_created_by  
						   )
						END;
			  END
		ELSE
			  BEGIN
			   SET @v_DIVISION_ID = @p_DIVISION_ID
			   SET @p_DIVISION_ID = NULL
 
				--20181005 khsong 공백제거로직추가 (START)
				SET @v_active_flag				= rtrim(ltrim(@v_active_flag))
				SET @v_division_id				= rtrim(ltrim(@v_division_id))
				SET @v_project_code				= rtrim(ltrim(@v_project_code))
				SET @v_scm_site_id				= rtrim(ltrim(@v_scm_site_id))
				SET @v_item_id					= rtrim(ltrim(@v_item_id))
				SET @v_dom_exp					= rtrim(ltrim(@v_dom_exp))
				SET @v_fcst_type				= rtrim(ltrim(@v_fcst_type))
				SET @v_incoterms				= rtrim(ltrim(@v_incoterms))
				SET @v_measure					= rtrim(ltrim(@v_measure))
				SET @v_PLANT_SITE_ID			= rtrim(ltrim(@v_PLANT_SITE_ID))
				SET @v_yyyymmdd					= rtrim(ltrim(@v_yyyymmdd))
				SET @v_qty						= rtrim(ltrim(@v_qty))
				SET @v_created_by				= rtrim(ltrim(@v_created_by	))
				--20181005 khsong 공백제거로직추가 (END)

				   IF @v_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
						BEGIN 
						   INSERT INTO #results ( 
								  v_active_flag   ,v_division_id   ,v_project_code 	 ,v_scm_site_id   ,v_item_id      
								 ,v_dom_exp       ,v_fcst_type     ,v_incoterms    	 ,v_measure       ,v_plant_site_id
								 ,v_yyyymmdd      ,v_qty           ,v_created_by   
						   ) VALUES ( 
								  @v_active_flag  ,@v_division_id  ,@v_project_code  ,@v_scm_site_id  ,@v_item_id      
								 ,@v_dom_exp      ,@v_fcst_type    ,@v_incoterms     ,@v_measure      ,@v_plant_site_id
								 ,@v_yyyymmdd     ,@v_qty          ,@v_created_by   
						   )
						END;
			  END
	-- if end
			----------- 20180810 KHSONG NULL VALIDATION ADDED
			BEGIN
			-----------
			   IF     @v_division_id	IS NULL OR @v_division_id    = ''
				   OR @v_project_code	IS NULL OR @v_project_code	 = ''
				   OR @v_scm_site_id	IS NULL OR @v_scm_site_id	 = ''
				   OR @v_item_id		IS NULL OR @v_item_id		 = ''
				   OR @v_dom_exp		IS NULL OR @v_dom_exp		 = ''
				   OR @v_fcst_type		IS NULL OR @v_fcst_type		 = ''
				   OR @v_incoterms		IS NULL OR @v_incoterms		 = ''
				   OR @v_measure		IS NULL OR @v_measure		 = ''
				begin
					SET @v_log_type = 'INVALID';
					SELECT N' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !'
					SET @v_description = N' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !'
					goto err_rtn
				end
			-----------
			END
			-----------
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                  #results 테이블에 split후 insert (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                              20181012 BLOCK Model (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

				DECLARE @s_BLOCK_Model  NVARCHAR(max);
				set @s_BLOCK_Model = '';
				set @s_BLOCK_Model = 
									ISNULL((select TOP 1 V_item_id
										  from #results a where 1=1
												and (
													select count(1)
													  from [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] with(nolock)
													 where LOOKUP_TYPE = 'FCST_EXCEPT_MODEL'
													   and SEGMENT1 = '40'
													   and valid_yn = 'Y'
													   and SEGMENT2 = A.V_item_id
													) > 0
												--and a.v_measure IN ('MKT_FCST','RTF')
												and a.v_qty <> 0
												),'') 
				IF @s_BLOCK_Model <> ''
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT 'Model : ' + @s_BLOCK_Model +char(10) + N'FCST INPUT BLOCK Model. contact 영업관리팀'
						SET @v_description = 'Model : ' + @s_BLOCK_Model +char(10) + N'FCST INPUT BLOCK Model. contact 영업관리팀'
						GOTO ERR_RTN
					END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                              20181012 BLOCK Model (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                              PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
			
	-----------
	BEGIN
	-----------
	--PRINT 'VALIDATION_1 START                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
	----------------------------------------------------------|
		-- 저장전 변수 초기화
		DECLARE @valid_project_code		 NVARCHAR(MAX);
		DECLARE @valid_item_id		     NVARCHAR(MAX);
		DECLARE @valid_item_id_2	     NVARCHAR(MAX);
		SET @valid_project_code	  = NULL
		SET @valid_item_id = NULL
		SET @valid_item_id_2 = NULL
		----------------------------------------------------------------------------------------------------------◎◎◎◎
		IF (select count(1)  
				from #results  where v_division_id <> '40'  -- 20180618 KHSONG 40 DIVISION 조건 추가
			) > 0
			BEGIN
					-------------------------------------------------------------------◎◎◎◎
					SET @valid_project_code =
					(
						SELECT TOP 1 A.v_project_code
							FROM #results A
							where NOT EXISTS (SELECT  c.division_id 
												FROM dbo.scm_mst_project C  WITH(NOLOCK)
													WHERE  A.v_division_id  = c.division_id 
													and A.v_project_code = c.project_code 
													and c.division_id <> '40'
											  )
							and A.v_division_id <> '40'
					)
					-------------------------------------------------------------------◎◎◎◎

					-------------------------------------------------------------------◎◎◎◎
					IF @valid_project_code IS NOT NULL
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT '['+ @valid_project_code +']'+ N' Invalid Project Code !'
							SET @v_description = '['+ @valid_project_code +']'+ N' Invalid Project Code !'
							goto err_rtn
						END
					-------------------------------------------------------------------◎◎◎◎
			END
		----------------------------------------------------------------------------------------------------------◎◎◎◎

		--임시저장
		--select * into temp_skh_0903_01 from #results
		----------------------------------------------------------------------------------------------------------◎◎◎◎
		--[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
			/*IF (select count(1)  
					from #results  where v_division_id IN ('81','40')  -- 자동차,소형인경우
				) > 0*/

				----------------------------------------------------------------------------------◎◎◎◎
				BEGIN
					SET @valid_item_id =
					(
						SELECT TOP 1 A.v_item_id
							FROM #results A
							where NOT EXISTS (SELECT  ITEM.division_id  
												FROM dbo.scm_mst_site_item ITEM WITH(NOLOCK)
												    ,dbo.DM_MST_ITEM_SINGLE_V SN WITH(NOLOCK) -- 20180720 ACTIVE_FLAG 조건추가
												where 1=1
 													and ITEM.division_id   = A.v_division_id 
													and ITEM.PROJECT_CODE  = A.v_project_code
													and ITEM.scm_site_id   = A.v_scm_site_id
													and ITEM.ITEM_ID       = A.v_ITEM_ID 
													and ITEM.division_id   = SN.division_id --20180720 ACTIVE_FLAG 조건추가
													and ITEM.ITEM_ID       = SN.ITEM_ID --20180720 ACTIVE_FLAG 조건추가
													and SN.ACTIVE_FLAG = 'Y' --20180720 ACTIVE_FLAG 조건추가
													--and ITEM.division_id IN ('81','40') --[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
											  )
								--AND A.v_division_id IN ('81','40') --[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
					)

						-------------------------------------------------------------------◎◎◎◎
						IF @valid_item_id IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
								SET @v_description = '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
								goto err_rtn
							END
						-------------------------------------------------------------------◎◎◎◎
				END
				----------------------------------------------------------------------------------◎◎◎◎
				
				--[C20200717-000157] Sales Site Project Model Sales Company, Sales Plant Validation 추가 
				----------------------------------------------------------------------------------◎◎◎◎
				BEGIN
					SET @valid_item_id =
					(
						SELECT TOP 1 A.v_item_id
							FROM   #results A
							where  EXISTS (SELECT  ITEM.division_id  
											FROM dbo.scm_mst_site_item ITEM WITH(NOLOCK)
												,dbo.DM_MST_ITEM_SINGLE_V SN WITH(NOLOCK)
											where 1=1
 												and ITEM.division_id   = A.v_division_id 
												and ITEM.PROJECT_CODE  = A.v_project_code
												and ITEM.scm_site_id   = A.v_scm_site_id
												and ITEM.ITEM_ID       = A.v_ITEM_ID 
												and ITEM.division_id   = SN.division_id
												and ITEM.ITEM_ID       = SN.ITEM_ID
												and SN.ACTIVE_FLAG	   = 'Y' 
												and ((ITEM.SALES_COMPANY IS NULL OR ITEM.SALES_COMPANY = '')
												  OR (ITEM.SALES_PLANT   IS NULL OR ITEM.SALES_PLANT   = '') )
											)
					)

						-------------------------------------------------------------------◎◎◎◎
						IF @valid_item_id IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id +']'+ N' Sales Company/Plant does not exist !'
								SET @v_description = '['+ @valid_item_id +']'+ N' Sales Company/Plant does not exist !'
								goto err_rtn
							END
						-------------------------------------------------------------------◎◎◎◎

				END
				----------------------------------------------------------------------------------◎◎◎◎
				
		----------------------------------------------------------------------------------------------------------◎◎◎◎
		--[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
			/*IF (select count(1)  
					from #results  where v_division_id = '82'  -- ESS인경우
				) > 0

				----------------------------------------------------------------------------------◎◎◎◎
				BEGIN
					SET @valid_item_id_2 =
					(
						SELECT TOP 1 A.v_item_id
							FROM #results A
							where NOT EXISTS (SELECT  ITEM.division_id  
												FROM dbo.scm_mst_item_sn ITEM WITH(NOLOCK)
												where 1=1
 													and ITEM.division_id   = A.v_division_id 
													and ITEM.ITEM_ID       = A.v_ITEM_ID 
													and ITEM.ACTIVE_FLAG   = 'Y' 
													and ITEM.division_id   = '82'
											  )
								AND v_division_id = '82'
					)

						-------------------------------------------------------------------◎◎◎◎
						IF @valid_item_id_2 IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id_2 +']'+ N' Invalid Site Item ID !'
								SET @v_description = '['+ @valid_item_id_2 +']'+ N' Invalid Site Item ID !'
								goto err_rtn
							END
						-------------------------------------------------------------------◎◎◎◎
				END*/
				----------------------------------------------------------------------------------◎◎◎◎

	-----------
	END
	-----------
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                              PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                   ESS인경우 SCM_MST_SITE_ITEM 테이블에 INPUT 데이터를 INSERT 수행 (START)  20190118 KHSONG ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
	/*IF (select count(1)  
			from #results  where v_division_id = '82'  -- ESS인경우
		) > 0
	BEGIN
			   DELETE 
			   FROM dbo.SCM_MST_SITE_ITEM
			   WHERE exists (
						SELECT v_division_id
						  FROM #results 
						 where v_division_id      = '82'
						   and division_id        =   v_division_id      
						   AND project_code       =   v_project_code   
						   AND scm_site_id        =   v_scm_site_id  
						   AND item_id            =   v_item_id      
					  ) ;

			   INSERT INTO dbo.SCM_MST_SITE_ITEM
			   -- 20180531 insert시 테이블 컬럼지정
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,CURRENCY,CELL_PER_CAR,CELL_PER_MODULE,LIABILITY_PERIOD
					,SALES_PLAN_ADJUST_YN,ITEM_HRCY_ID,VALID_YN,BPMS_EXIST
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
					,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
			   SELECT distinct
					 v_division_id  
					,v_project_code 
					,v_scm_site_id  
					,v_item_id 
					,(select top 1 CURRENCY from SCM_MST_PROJECT WITH(NOLOCK) where DIVISION_ID = v_division_id and PROJECT_CODE = v_project_code and CURRENCY is not null)  -- CURRENCY     
					,null         -- CELL_PER_CAR
					,null         -- CELL_PER_MODULE
					,null         -- LIABILITY_PERIOD
					,'Y'          -- SALES_PLAN_ADJUST_YN
					,null         -- ITEM_HRCY_ID
					,'Y'          -- VALID_YN
					,'N'          -- BPMS_EXIST
					,'SYSTEM'     --CREATED_BY
					,GETDATE()    -- CREATION_DATE
					,'SYSTEM'     -- LAST_UPDATED_BY
					, GETDATE()   -- LAST_UPDATE_DATE
					,null,null,null,null,null,null,null,null,null,null
			  FROM #results 
				where v_division_id      = '82'

	END*/
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                   ESS인경우 SCM_MST_SITE_ITEM 테이블에 INPUT 데이터를 INSERT 수행 (END)    20190118 KHSONG ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                     20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) FCST주차의 Unit Price 유무 Validation (BEGIN)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	/* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨)  */
	DECLARE @s_unit_price_valid  NVARCHAR(1000);
	set @s_unit_price_valid = null;
	set @s_unit_price_valid = 

				(
					select top 1		   CASE 
											WHEN a.v_division_id = '40' THEN
												'End Customer________ : '+ ISNULL(v_project_code ,'')
											ELSE
												'Project_________ : '+ ISNULL(v_project_code ,'')
											END
									+char(10) + 'Sales site_____________ : '+ ISNULL(v_scm_site_id ,'') 
									+char(10) + 'Model________________ : '+ ISNULL(v_item_id ,'')  
									+char(10) + 'Customs Handbook__ : '+ ISNULL(v_dom_exp ,'')    
									+char(10) + 'Fcst Type_____________ : '+ 
												ISNULL((SELECT TOP 1 SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
													AND MST.SEGMENT1    = A.v_fcst_type
													),'')  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
									+char(10) + 'Incoterms____________ : '+ ISNULL(v_incoterms ,'')     
									+char(10) + 'Plant Site___________ : '+ ISNULL(v_plant_site_id ,'')     --[C20200525-000296] (81 사업부) Plant Site 조건 추가
									+char(10) + 'YYYYMMDD_________ : '+ ISNULL(M.basis_start_date,'')
									+char(10) +char(10)

					FROM #results A
							--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
							inner join scm_mst_site_item z with(nolock)
							on  a.v_division_id		 = z.DIVISION_ID
							and a.v_project_code	 = z.PROJECT_CODE
							and a.v_scm_site_id		 = z.SCM_SITE_ID
							and a.v_item_id			 = z.ITEM_ID
							and z.VALID_YN			 = 'Y'
							AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL )  -- 20181023 보완
							--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외

							LEFT JOIN (
										SELECT basis_start_date
										 FROM [dbo].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
												WHERE M.basis_yyyymmdd BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
																		   AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
										GROUP BY basis_start_date
									  ) M
									  ON 1=1

							LEFT JOIN SCM_MST_FUTURE_PRICE P WITH(NOLOCK)
								ON (
										a.v_division_id		= p.division_id
									AND a.v_project_code	= p.project_code
									AND a.v_scm_site_id		= p.scm_site_id
									AND a.v_item_id			= p.item_id
									AND a.v_dom_exp			= p.dom_exp
									AND a.v_fcst_type		= p.fcst_type
									AND a.v_incoterms		= p.INCOTERMS
									AND a.v_plant_site_id = CASE WHEN a.v_division_id = '81' THEN p.plant_site_id ELSE a.v_plant_site_id END --[C20200525-000296] (81 사업부) Plant Site 조건 추가
									AND p.yyyymmdd			= M.basis_start_date
									AND p.price > 0
									)

							WHERE 1=1
								AND p.yyyymmdd IS NULL  -- PRICE값이 없는경우
								AND a.v_measure IN ('MKT_FCST','RTF')  -- 20181010
								AND a.v_qty <> 0
								AND a.v_fcst_type not in (
															SELECT SEGMENT1 -- FCST_TYPE
																FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																		AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																		AND ( MST.SEGMENT4 = 'FREE'  -- 무상 제공인경우
																		  OR  MST.SEGMENT1 in ('RMA', 'TST')) -- [C20200525-000296] 반품, Internal Test 제외
															GROUP BY SEGMENT1
														)  -- 무상제공인경우는 Validation 에서 제외 / 기존 하드코딩을 Lookup으로 변경
					GROUP BY v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_measure,v_plant_site_id,p.yyyymmdd,M.basis_start_date
					ORDER BY v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_measure,v_plant_site_id,p.yyyymmdd
				)

	IF @s_unit_price_valid IS NOT NULL
	BEGIN
		SET @v_log_type = 'INVALID';
		SET @v_description = @s_unit_price_valid + N'Unit Price Not Found !'+char(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'+char(10) + N'미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.'
		SELECT @v_description
		GOTO ERR_RTN
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                     20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) FCST주차의 Unit Price 유무 Validation (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

																		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
																		--                                                                                                                    20180816 Unit Price가 없는 MKT_FCST validation (START)  -- 20200529 KHSONG C20200424-000010 주석처리
																		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
																		/*

																					DECLARE @s_unit_price_valid  NVARCHAR(max);
																					set @s_unit_price_valid = null;
																					set @s_unit_price_valid = 
																					(select top 1 'Project :                    '+ v_project_code +char(10) +'Sales site :                 '+ v_scm_site_id +char(10) +'Model :                     '+ v_item_id 
																								   +char(10) +'Customs Handbook :   '+ v_dom_exp +char(10) +'Fcst Type :                 '+ 
																								   (SELECT TOP 1 SEGMENT2
																										FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																										WHERE 1=1
																										AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																										AND MST.SEGMENT1    = A.v_fcst_type
																										)  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
																								   +char(10) +'incoterms :                '+ v_incoterms 
																								   +char(10) +'YYYYMMDD :            '+ v_yyyymmdd +char(10) +char(10)
																																										--'-----------------------------'                                      
																					  from #results a 
																							--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
																						  inner join scm_mst_site_item z with(nolock)
																						  on  a.v_division_id		 = z.DIVISION_ID
																						  and a.v_project_code		 = z.PROJECT_CODE
																						  and a.v_scm_site_id		 = z.SCM_SITE_ID
																						  and a.v_item_id			 = z.ITEM_ID
																						  and z.VALID_YN			 = 'Y'
																						  AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL )  -- 20181023 보완
																							--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
																					  where 1=1
																							and (
																									select count(1)
																									from [dbo].[SCM_MST_FUTURE_PRICE] p with(nolock)
																									where a.v_division_id	= p.division_id
																									  and a.v_project_code  = p.project_code
																									  and a.v_scm_site_id	= p.scm_site_id
																									  and a.v_item_id		= p.item_id
																									  and a.v_dom_exp		= p.dom_exp
																									  and a.v_fcst_type		= p.fcst_type
																									  and a.v_incoterms		= p.INCOTERMS
																									  and a.v_plant_site_id = CASE WHEN a.v_division_id = '81' THEN p.plant_site_id ELSE a.v_plant_site_id END
																									  and p.yyyymmdd		= ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd )
																									  and p.price > 0
																								) = 0

																							----------------------------------------------------------------------------------------------------------------------
																							-- 날짜선택 오류수정 20200304 KHSONG (주석처리) BEGIN
																							----------------------------------------------------------------------------------------------------------------------
																							--and a.v_yyyymmdd between ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) and ( select basis_start_date + 6 from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyy
m
mdd = a.v_yyyymmdd )  -- 주석처리
																							----------------------------------------------------------------------------------------------------------------------
																							-- 날짜선택 오류수정 20200304 KHSONG (주석처리) END
																							----------------------------------------------------------------------------------------------------------------------

																							----------------------------------------------------------------------------------------------------------------------
																							-- 20200304 KHSONG 날짜선택 오류수정 : Partial Week 인경우 2개의 Price값이 존재하므로 구분하여 선택 가능하도록 수정(BEGIN)
																							----------------------------------------------------------------------------------------------------------------------
																							and a.v_yyyymmdd between ( select basis_start_date  from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) 
																								and ( select CONVERT(CHAR(8), DATEADD(DD, +6,(DATEADD(DD, -7, dbo.FN_NEXT_DAY(basis_yyyymmdd, 'MON')) )),112) from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) -- 반영로직
																							----------------------------------------------------------------------------------------------------------------------
																							-- 20200304 KHSONG 날짜선택 오류수정 : Partial Week 인경우 2개의 Price값이 존재하므로 구분하여 선택 가능하도록 수정 (END)
																							----------------------------------------------------------------------------------------------------------------------

																							--and a.v_measure =  'RTF'  -- 'MKT_FCST'
																							and a.v_measure IN ('MKT_FCST','RTF')  -- 20181010
																							and a.v_qty <> 0
																							and a.v_fcst_type not in ('SDF','SMF','TST','ASF')  -- 20181011 khsong Price가 없는 case Validation 에서 제외  -- 20190115 KHSONG SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
																								)

																						IF @s_unit_price_valid IS NOT NULL
																							BEGIN
																								SET @v_log_type = 'INVALID';
																								SET @v_description = @s_unit_price_valid + N'Unit Price Not Found !'+char(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'
																								SELECT @v_description
																								GOTO ERR_RTN
																							END
																		*/
																		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
																		--                                                                                                                      20180816 Unit Price가 없는 MKT_FCST validation (END)  -- 20200529 KHSONG C20200424-000010 주석처리
																		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                          20181107 RMA FCST_TYPE 음수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				  IF (SELECT ISNULL(COUNT(*),0) from #results 
				    WHERE v_fcst_type = 'RMA'
					  AND v_qty > 0
					  ) > 0
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT N'반품수량(RMA)은 음수값만 입력가능합니다 !'
							SET @v_description = N'반품수량(RMA)은 음수값만 입력가능합니다 !'
							GOTO ERR_RTN
						END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                          20181107 RMA FCST_TYPE 음수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                           20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				  IF (SELECT ISNULL(COUNT(*),0) from #results 
				    WHERE v_fcst_type <> 'RMA'
					  AND v_qty < 0
					  ) > 0
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT N'정수값만 입력가능합니다 !'
							SET @v_description = N'정수값만 입력가능합니다 !'
							GOTO ERR_RTN
						END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                           20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--Start [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
	DECLARE @valid_type	NVARCHAR(100); 
	SET @valid_type = NULL;

	IF (select count(1)  
			from #results  where v_division_id = '81'
		) > 0
		BEGIN
			SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY
			,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
					,ENERGE, CELL_QUANTITY
			INTO #TEMP_DM_MST_ITEM_SINGLE_V
			FROM   (SELECT *
					FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
					INNER JOIN #results A  WITH(NOLOCK)
					ON  A.V_DIVISION_ID		= T2.DIVISION_ID
					AND A.V_ITEM_ID         = T2.ITEM_ID
					) G
			GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY
			,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
					,ENERGE, CELL_QUANTITY
			
			CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
			(division_id   ASC
			,item_id       ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			
			SET @valid_item_id =
			(
				SELECT  TOP 1 A.V_ITEM_ID 
				FROM #results A
				LEFT JOIN scm_mst_site_item F  WITH(NOLOCK)
					ON  A.V_DIVISION_ID		= F.DIVISION_ID
					AND A.V_ITEM_ID         = F.ITEM_ID
					AND A.V_PROJECT_CODE	= F.PROJECT_CODE
					AND A.V_SCM_SITE_ID		= F.SCM_SITE_ID
				INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V X  WITH(NOLOCK)
					ON  A.V_DIVISION_ID		= X.DIVISION_ID
					AND A.V_ITEM_ID         = X.ITEM_ID
				WHERE	X.ITEM_TYPE = 'P'
					   AND CASE WHEN CHARINDEX('Cell', X.ITEM_CLASS_NAME) > 0 AND ISNULL(F.CELL_PER_CAR, 0) > 0 THEN 0
								 WHEN CHARINDEX('Module', X.ITEM_CLASS_NAME) > 0 AND ISNULL(F.CELL_PER_CAR, 0) > 0 AND ISNULL(F.CELL_PER_MODULE, 0) > 0  THEN 0
								 WHEN CHARINDEX('Pack', X.ITEM_CLASS_NAME) > 0 AND ISNULL(F.CELL_PER_CAR, 0) > 0  THEN 0
								 ELSE 1
							END = 1
				-- 20.7.7 [C20200511-000360] WHERE 절에 ITEM_TYPE = 'P' 추가, ITEM_SINGLE_V --> iNNER JOIN 으로 변경
			)
			

			IF @valid_item_id IS NOT NULL
				BEGIN
					SET @valid_type = 					
					ISNULL((SELECT CASE WHEN CHARINDEX('Module', X.ITEM_CLASS_NAME) > 0 THEN 'Cell/Car or Cell/Module'
						                ELSE 'Cell/Car'
								   END
						FROM    #TEMP_DM_MST_ITEM_SINGLE_V X  WITH(NOLOCK)
						WHERE   X.ITEM_ID = @valid_item_id ) , '')

					SET @v_log_type = 'INVALID';
					SELECT '['+ @valid_item_id +'] ' + @valid_type + N' does not exist !'
					SET @v_description = '['+ @valid_item_id +'] ' + @valid_type + N' does not exist !'
					goto err_rtn
				END
		END
		
	--End [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--              20180703 KHSONG 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--IF (SELECT count(1) FROM #results where v_DIVISION_ID = '40') = 0  --20180914-1   KHSONG (20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
	BEGIN


		--PRINT 'VALIDATION_2 START                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

				-- 저장전 변수 초기화
				DECLARE @valid_bom		 NVARCHAR(MAX);
				DECLARE @valid_shipto    NVARCHAR(MAX);
				SET @valid_bom	  = NULL
				SET @valid_shipto = NULL

				SET @valid_bom =
				(
					SELECT TOP 1 A.V_ITEM_ID
						FROM #results A
							INNER JOIN [DBO].[DM_MST_ITEM_SINGLE_V] C  WITH(NOLOCK)
								ON  A.V_ITEM_ID			= C.ITEM_ID
								AND A.V_DIVISION_ID		= C.DIVISION_ID
								AND C.ITEM_TYPE			IN ( 'P','H' )
								AND C.ACTIVE_FLAG		= 'Y' --20180720 ACTIVE_FLAG 조건추가
							LEFT JOIN [DBO].[SCM_MST_BOM_ENG_SN] X  WITH(NOLOCK)
								ON  A.V_DIVISION_ID		= X.DIVISION_ID
								AND A.V_ITEM_ID			= X.PARENT_ITEM_ID
							LEFT JOIN (
								SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE , TO_SITE, INCOTERMS, MIN(LT_TOTAL) LT_TOTAL --20180914 소형도 FROM_SITE 조건에 추가
									FROM [DBO].[SCP_MST_BOD_V] WITH(NOLOCK)
										WHERE PRIORITY = 1
										GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END , TO_SITE, INCOTERMS  --20180914 소형도 FROM_SITE 조건에 추가
										) BOD  
								ON  A.V_DIVISION_ID		= BOD.DIVISION_ID
								AND A.V_PLANT_SITE_ID	= BOD.FROM_SITE
								AND A.V_SCM_SITE_ID		= BOD.TO_SITE
								AND A.V_INCOTERMS		= BOD.INCOTERMS
							WHERE A.V_MEASURE		IN ('MKT_FCST','Vmi_In_Req')
								AND A.V_YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
								AND A.V_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*10) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일 + 11주 까지
								AND A.V_QTY			> 0
								AND X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
								and a.v_item_id not in ('ECE0074N5-01')  -- 20190614 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
								and a.v_item_id not in ('MCCH120022B2-K','MCCH120022B2-GD')  -- 20190708 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
				)
				IF @valid_bom IS NOT NULL
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT '['+ @valid_bom +']'+ N' BOM does not exist !'
						SET @v_description = '['+ @valid_bom +']'+ N' BOM does not exist !'
						goto err_rtn
					END

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--              20180703 KHSONG 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180703 KHSONG 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 scm_site_id 가 없다고 Alert을 띄우고 ROLLBACK시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--IF (SELECT count(1) FROM #results where v_DIVISION_ID = '40') = 0  --20180914-2 KHSONG (20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
	BEGIN
				SET @valid_shipto =
				(
					SELECT  TOP 1 A.V_SCM_SITE_ID
						FROM #results A
							LEFT JOIN [DBO].[SCM_MST_SITE_CUSTOMER] X  WITH(NOLOCK)
								ON  A.V_DIVISION_ID		= X.DIVISION_ID
								AND A.V_SCM_SITE_ID     = X.SCM_SITE_ID
								AND X.VALID_YN			= 'Y'
								AND X.REP_YN			= 'Y'
							LEFT JOIN (
								SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE , TO_SITE, INCOTERMS, MIN(LT_TOTAL) LT_TOTAL --20180914 소형도 FROM_SITE 조건에 추가
									FROM [DBO].[SCP_MST_BOD_V] WITH(NOLOCK)
										WHERE PRIORITY = 1
								GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END , TO_SITE, INCOTERMS --20180914 소형도 FROM_SITE 조건에 추가
										) BOD  
								ON  A.V_DIVISION_ID		= BOD.DIVISION_ID
								AND A.V_PLANT_SITE_ID	= BOD.FROM_SITE
								AND A.V_SCM_SITE_ID		= BOD.TO_SITE
								AND A.V_INCOTERMS		= BOD.INCOTERMS
							WHERE A.V_MEASURE	IN ('MKT_FCST','Vmi_In_Req')
							AND A.V_YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
							AND A.V_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*3) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- BOD LT + 4W
							AND A.V_QTY			> 0
							AND X.SHIPTO_CODE IS NULL
				)
				IF @valid_shipto IS NOT NULL
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT '['+ @valid_shipto +']'+ N' SITE SHIP-TO does not exist !'
						SET @v_description = '['+ @valid_shipto +']'+ N' SITE SHIP-TO does not exist !'
						goto err_rtn
					END
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180703 KHSONG 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 scm_site_id 가 없다고 Alert을 띄우고 ROLLBACK시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                               INPUT MEASURE 중복값 delete후 INSERT (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT '#results DATA DELETE start                       =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
				-- 속도이슈로 cursor 구조로 변경
				-- 신규변수

		-- 소형 SPREAD 처리 시작 ----------------------------------------------------------------------------------------------------
		-- 소형일 경우 VMI_YN, DIO 를 추가한다.
		IF @V_DIVISION_ID = '40'
		BEGIN
			UPDATE A
			SET V_VMI_YN = ISNULL(B.VMI_YN, 'N')
				, V_DIO = ISNULL(CAST(C.VMI_STD_DIO AS INT), 0)
			FROM #RESULTS A
			LEFT OUTER JOIN SCM_MST_SITE B ON A.V_DIVISION_ID = B.DIVISION_ID AND A.V_SCM_SITE_ID = B.SCM_SITE_ID
			LEFT OUTER JOIN (
					SELECT A.ITEM_ID, A.VMI_STD_DIO
					FROM SCP_MST_DIO A
					JOIN (
						SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
							, MAX(YYYYMM) AS YYYYMM
						FROM SCP_MST_DIO
						WHERE DIVISION_ID ='40'
						AND TOTAL_YN = 'Y'
						AND PLANT_ID = '*'
						GROUP BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
						) B ON A.DIVISION_ID = B.DIVISION_ID 
							AND A.PLANT_ID = B.PLANT_ID 
							AND A.ITEM_ID = B.ITEM_ID 
							AND A.TOTAL_YN = B.TOTAL_YN
							AND A.YYYYMM = B.YYYYMM
					WHERE A.DIVISION_ID = '40'
						AND A.TOTAL_YN = 'Y'
						AND A.PLANT_ID = '*'
						) C ON A.V_ITEM_ID = C.ITEM_ID

			-- VMI SITE 의 경우 MKT FCST 는 VMI_IN_REQ 에 의해 계산되어야 하기 때문에 입력받은 MKT_FCST 메저를 모두 지운다.
			DELETE FROM #results
			WHERE V_MEASURE = 'MKT_FCST_RP'
				AND V_VMI_YN = 'Y'

			-- VMI in Req 를 이용해서 MKT FCST 생성
			INSERT INTO #results (
				v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id, v_dom_exp, v_fcst_type
				, v_incoterms, v_measure, v_plant_site_id, v_yyyymmdd, v_qty, v_created_by, v_vmi_yn, v_dio )
			SELECT v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id, v_dom_exp, v_fcst_type
				, v_incoterms, N'MKT_FCST_RP' AS v_measure, v_plant_site_id
				, CONVERT(CHAR(8), DATEADD(DAY, V_DIO, v_yyyymmdd), 112) AS V_YYYYMMDD, v_qty, v_created_by, v_vmi_yn, v_dio
			FROM #results
			WHERE V_MEASURE = 'VMI_IN_REQ'
				AND V_VMI_YN = 'Y'
				AND ISNUMERIC(V_DIO) > 0
				
		END
		-- 소형 SPREAD 처리 끝 ----------------------------------------------------------------------------------------------------

				DECLARE @m4_DIVISION_ID         NVARCHAR(MAX);
				DECLARE @m4_SCM_SITE_ID         NVARCHAR(MAX);
				DECLARE @m4_PROJECT_CODE        NVARCHAR(MAX);

				IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_m4_MST')
					BEGIN
						CLOSE CURSOR_m4_MST
						DEALLOCATE CURSOR_m4_MST
					END;
				DECLARE CURSOR_m4_MST CURSOR FAST_FORWARD FOR
				SELECT 
							V_DIVISION_ID,V_SCM_SITE_ID,v_project_code
					FROM  #results WHERE 1=1
				GROUP BY V_DIVISION_ID,  V_SCM_SITE_ID, v_project_code

				BEGIN
					OPEN CURSOR_m4_MST;
					FETCH NEXT FROM CURSOR_m4_MST INTO          -- PROJECT_CODE별 LOOP수행
												 @m4_DIVISION_ID    
												,@m4_SCM_SITE_ID
												,@m4_PROJECT_CODE   
				END
				---------------------------------------------------------------------------------------- WHILE_m4 LOOP START
				WHILE @@FETCH_STATUS = 0   
				----------------------------------------------------------------------------------------
				BEGIN
				--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST2


																   
				   DELETE 
				   FROM dbo.DM_PLN_MKT_FCST
				   WHERE exists(
							SELECT v_division_id
							  FROM #results 
							 where 1=1
							   and division_id        =   v_division_id      
							   AND project_code       =   v_project_code   
							   AND scm_site_id        =   v_scm_site_id  
							   AND item_id            =   v_item_id      
							   AND dom_exp            =   v_dom_exp      
							   AND fcst_type          =   v_fcst_type    
							   AND incoterms          =   v_incoterms    
							   AND measure            =   v_measure      
							   AND plant_site_id      =   v_plant_site_id
							   AND yyyymmdd           =   v_yyyymmdd
						  )
						  AND division_id   =  @m4_DIVISION_ID 
						  AND project_code	=  @m4_PROJECT_CODE
						  AND scm_site_id 	=  @m4_SCM_SITE_ID

		  
				--PRINT '#results DATA insert start                       =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
					   INSERT INTO dbo.DM_PLN_MKT_FCST
					   SELECT 
							   v_division_id  ,v_project_code  ,v_scm_site_id   ,v_item_id       ,v_dom_exp      
							  ,v_fcst_type    ,v_incoterms     ,v_measure       ,v_plant_site_id ,v_yyyymmdd     
							  ,v_qty          ,v_created_by    ,getdate()		,v_created_by    ,getdate()
							  ,null,null,null,null,null,null,null,null,null,null
					  FROM #results 
					  WHERE 1=1
						  AND V_division_id     =  @m4_DIVISION_ID 
						  AND V_project_code	=  @m4_PROJECT_CODE
						  AND V_scm_site_id 	=  @m4_SCM_SITE_ID

					--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST2

					FETCH NEXT FROM CURSOR_m4_MST INTO          -- PROJECT_CODE별 LOOP수행
												 @m4_DIVISION_ID    
												,@m4_SCM_SITE_ID
												,@m4_PROJECT_CODE   
				---------------------------------------------------------------------------------------- 
				END;
				---------------------------------------------------------------------------------------- WHILE_m4 LOOP END

				CLOSE CURSOR_m4_MST;  
				DEALLOCATE CURSOR_m4_MST;

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                               INPUT MEASURE 중복값 delete후 INSERT (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                     HISTORY INSERT (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT 'FCST DATA HISTORY INSERT START                   =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			   INSERT INTO dbo.DM_PLN_MKT_FCST_H
			   SELECT 
					   v_division_id 
					   ,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H 
					  ,v_project_code ,v_scm_site_id  ,v_item_id       ,v_dom_exp  ,v_fcst_type    
					  ,v_incoterms    ,v_measure      ,v_plant_site_id ,v_yyyymmdd ,v_qty          
					  ,v_created_by   ,getdate()	  ,v_created_by    ,getdate()
					  ,null,null,null,null,null,null,null,null,null,null
			  FROM #results 

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                     HISTORY INSERT (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                           20180409 DM_MST_CUSTOMER_FCST map create (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN

		--PRINT 'DM_MST_CUSTOMER_FCST map create START            =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		insert into  @tmp_site_customer_map
		select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE,
   			   a.SUMMARY_BUCKET_VALUE as start_day
			  ,case when summary_bucket_type = 'WEEKLY' THEN CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY( cast( SUMMARY_BUCKET_VALUE as datetime) , 'SUN')), 112) 
			       else a.SUMMARY_BUCKET_VALUE
			    END  end_day
		FROM dbo.DM_MST_CUSTOMER_FCST a WITH(NOLOCK) 
		  inner join 
		  (select distinct v_DIVISION_ID,v_SCM_SITE_ID
		  from #results 
			WHERE v_measure NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
		  ) rslt
	  on(
		    a.DIVISION_ID   = rslt.v_DIVISION_ID
		and a.SCM_SITE_ID   = rslt.v_SCM_SITE_ID
	   )
		where 1=1
		and VALID_YN = 'Y'
		and a.MEASURE_GROUP = 'CUST_FCST'
		and a.PLAN_WEEK = 
				(SELECT MAX(PLAN_WEEK)  
					FROM DM_MST_CUSTOMER_FCST WITH(NOLOCK) 
					)
		and a.SUMMARY_BUCKET_VALUE >=  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후데이터만 
		and summary_bucket_type in ('DAILY','WEEKLY')

		UNION

		select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE
   			  , case when  SUMMARY_BUCKET_VALUE = convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112) THEN  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			        else  SUMMARY_BUCKET_VALUE  end as start_day
			  , CONVERT(CHAR(8),  dateadd(day,-DATEPART(DD, dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) )), dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) ))   , 112)   end_day
		FROM dbo.DM_MST_CUSTOMER_FCST a WITH(NOLOCK) 
		  inner join 
		  (select distinct v_DIVISION_ID,v_SCM_SITE_ID
		  from #results 
			WHERE v_measure NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
		  ) rslt
	  on(
		    a.DIVISION_ID   = rslt.v_DIVISION_ID
		and a.SCM_SITE_ID   = rslt.v_SCM_SITE_ID
	   )
		where 1=1
		and VALID_YN = 'Y'
		and a.MEASURE_GROUP = 'CUST_FCST'
		and a.PLAN_WEEK = 
				(SELECT MAX(PLAN_WEEK)  
					FROM DM_MST_CUSTOMER_FCST WITH(NOLOCK) 
					)
		and a.SUMMARY_BUCKET_VALUE >=  convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112)
		and summary_bucket_type in ('MONTHLY')

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                       20180409 DM_MST_CUSTOMER_FCST map create (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT 'DM_PLN_MKT_FCST insert START                     =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST3
	insert into #tmp_DM_PLN_MKT_FCST
			 (v_DIVISION_ID    
			 ,v_PROJECT_CODE   
			 ,v_SCM_SITE_ID    
			 ,v_ITEM_ID        
			 ,v_DOM_EXP        
			 ,v_FCST_TYPE      
			 ,v_INCOTERMS      
			 ,v_MEASURE        
			 ,v_PLANT_SITE_ID  
			 ,v_YYYYMMDD       
			 ,v_QTY            
			 ,v_CREATED_BY     
			 ,v_LAST_UPDATED_BY)
	select   distinct 
			  a.DIVISION_ID		,a.PROJECT_CODE		,a.SCM_SITE_ID		,a.ITEM_ID	   ,a.DOM_EXP	  ,a.FCST_TYPE
			 ,a.INCOTERMS		,'CUST_FCST'		,a.PLANT_SITE_ID	,a.YYYYMMDD	   ,a.QTY		  ,a.CREATED_BY
			 ,a.LAST_UPDATED_BY	
	  from dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
		  inner join 
		  (select distinct v_DIVISION_ID,v_SCM_SITE_ID,v_ITEM_ID,v_incoterms, v_PLANT_SITE_ID, v_PROJECT_CODE,v_DOM_EXP,v_FCST_TYPE
		  from #results ) rslt
	  on(
		    a.DIVISION_ID   = rslt.v_DIVISION_ID
		and a.SCM_SITE_ID   = rslt.v_SCM_SITE_ID
		and a.ITEM_ID       = rslt.v_ITEM_ID
		and a.incoterms     = rslt.v_incoterms
		and a.PLANT_SITE_ID = rslt.v_PLANT_SITE_ID
		and a.PROJECT_CODE  = rslt.v_PROJECT_CODE
		and a.DOM_EXP       = rslt.v_DOM_EXP
		and a.FCST_TYPE     = rslt.v_FCST_TYPE
	   )
		  inner join 
		  (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
		  from @tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

	  on(
			a.DIVISION_ID   = map.DIVISION_ID 
		and a.SCM_SITE_ID   = map.SCM_SITE_ID
		and a.MEASURE       = map.MEASURE
	   )
		where 1=1
		and a.YYYYMMDD between map.start_day and map.end_day
		and a.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
		--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST3
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                          20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT 'DM_PLN_MKT_FCST DUP CHECK DELETE START           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

				-- 속도이슈로 cursor 구조로 변경
				-- 신규변수


				DECLARE @m5_DIVISION_ID         NVARCHAR(MAX);
				DECLARE @m5_SCM_SITE_ID      NVARCHAR(MAX);
				DECLARE @m5_PROJECT_CODE        NVARCHAR(MAX);

				IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_m5_MST')
					BEGIN
						CLOSE CURSOR_m5_MST
						DEALLOCATE CURSOR_m5_MST
					END;
				DECLARE CURSOR_m5_MST CURSOR FAST_FORWARD FOR
				SELECT 
							V_DIVISION_ID,V_SCM_SITE_ID,v_project_code
					FROM  #results WHERE 1=1
				GROUP BY V_DIVISION_ID,  V_SCM_SITE_ID, v_project_code

				BEGIN
					OPEN CURSOR_m5_MST;
					FETCH NEXT FROM CURSOR_m5_MST INTO          -- PROJECT_CODE별 LOOP수행
												 @m5_DIVISION_ID    
												,@m5_SCM_SITE_ID
												,@m5_PROJECT_CODE   
				END
				---------------------------------------------------------------------------------------- WHILE_m5 LOOP START
				WHILE @@FETCH_STATUS = 0   
				----------------------------------------------------------------------------------------
				BEGIN

				--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST4
					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
					WHERE exists (
							SELECT v_division_id 
								FROM #tmp_DM_PLN_MKT_FCST 
								where 1=1
								and DM_PLN_MKT_FCST.division_id        =   v_division_id      
								AND DM_PLN_MKT_FCST.project_code       =   v_project_code   
								AND DM_PLN_MKT_FCST.scm_site_id        =   v_scm_site_id  
								AND DM_PLN_MKT_FCST.item_id            =   v_item_id      
								AND DM_PLN_MKT_FCST.dom_exp            =   v_dom_exp      
								AND DM_PLN_MKT_FCST.fcst_type          =   v_fcst_type    
								AND DM_PLN_MKT_FCST.incoterms          =   v_incoterms    
								AND DM_PLN_MKT_FCST.measure            =   v_measure      
								AND DM_PLN_MKT_FCST.plant_site_id      =   v_plant_site_id
							--   AND yyyymmdd           =   v_yyyymmdd     
								AND DM_PLN_MKT_FCST.yyyymmdd           >=   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
								AND v_division_id        =  @m5_DIVISION_ID     
								AND v_project_code       =  @m5_PROJECT_CODE
								AND v_scm_site_id        =  @m5_SCM_SITE_ID   
							) 
						and division_id        =   @m5_DIVISION_ID      
						AND project_code       =   @m5_PROJECT_CODE
						AND scm_site_id        =   @m5_SCM_SITE_ID   
							;

		--PRINT 'DM_PLN_MKT_FCST DUP CHECK INSERT START           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
					INSERT INTO dbo.DM_PLN_MKT_FCST
							(DIVISION_ID    
							,PROJECT_CODE   
							,SCM_SITE_ID    
							,ITEM_ID        
							,DOM_EXP        
							,FCST_TYPE      
							,INCOTERMS      
							,MEASURE        
							,PLANT_SITE_ID  
							,YYYYMMDD       
							,QTY            
							,CREATED_BY     
							,CREATION_DATE     
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE )
					SELECT 
							 v_division_id ,v_project_code ,v_scm_site_id	 ,v_item_id       ,v_dom_exp      
							,v_fcst_type   ,v_incoterms    ,v_measure    	 ,v_plant_site_id ,v_yyyymmdd     
							,v_qty         ,v_created_by   ,getdate()		 ,v_created_by    ,getdate()
					FROM #tmp_DM_PLN_MKT_FCST 
					where 1=1
						AND v_division_id        =  @m5_DIVISION_ID     
						AND v_project_code       =  @m5_PROJECT_CODE
						AND v_scm_site_id        =  @m5_SCM_SITE_ID    

					--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST4

					FETCH NEXT FROM CURSOR_m5_MST INTO          -- PROJECT_CODE별 LOOP수행
												 @m5_DIVISION_ID    
												,@m5_SCM_SITE_ID
												,@m5_PROJECT_CODE   
				---------------------------------------------------------------------------------------- 
				END;
				---------------------------------------------------------------------------------------- WHILE_m5 LOOP END

				CLOSE CURSOR_m5_MST;  
				DEALLOCATE CURSOR_m5_MST;
	END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                          20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		  

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                  20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT N'상품 전극 RTF생성                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정
		--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST5

		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			--where MEASURE = 'RTF'
			where MEASURE = 'RTF_SYS_RP' --20200427 변경
			AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			-- modified by ytchoi 20180813
			-- AND DIVISION_ID <> '40'
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK)
				where 1=1
				AND rslt.v_division_id					=	item.division_id
				AND rslt.v_item_id						=	item.item_id
				AND DM_PLN_MKT_FCST.division_id			=   rslt.v_division_id      
				AND DM_PLN_MKT_FCST.project_code		=   rslt.v_project_code   
				AND DM_PLN_MKT_FCST.scm_site_id			=   rslt.v_scm_site_id  
				AND DM_PLN_MKT_FCST.item_id				=   rslt.v_item_id      
				AND DM_PLN_MKT_FCST.dom_exp				=   rslt.v_dom_exp      
				AND DM_PLN_MKT_FCST.fcst_type			=   rslt.v_fcst_type    
				AND DM_PLN_MKT_FCST.incoterms			=   rslt.v_incoterms    
				AND DM_PLN_MKT_FCST.plant_site_id		=   rslt.v_plant_site_id
				AND DM_PLN_MKT_FCST.yyyymmdd			>=  @plan_start_yyyymmdd
				AND item.ACTIVE_FLAG = 'Y'  --20180720 ACTIVE_FLAG 조건추가
				--↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND ( item.item_type in ('Q' , 'R' ) OR 
					( rslt.v_item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) 
					  where k.division_id = rslt.v_division_id and k.SCP_OPERATION_GROUP = 'E' and k.ACTIVE_FLAG = 'Y'  )  ))  --20180720 ACTIVE_FLAG 조건추가
				--↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND DM_PLN_MKT_FCST.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				) ;


		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  --,'RTF' 
			  ,'RTF_SYS_RP'  --20200427 변경
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]
			  ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,a.[ATTRIBUTE1]
			  ,a.[ATTRIBUTE2]
			  ,a.[ATTRIBUTE3]
			  ,a.[ATTRIBUTE4]
			  ,a.[ATTRIBUTE5]
			  ,a.[ATTRIBUTE6]
			  ,a.[ATTRIBUTE7]
			  ,a.[ATTRIBUTE8]
			  ,a.[ATTRIBUTE9]
			  ,a.[ATTRIBUTE10]
		  from dm_pln_mkt_fcst a WITH(NOLOCK)
			where a.MEASURE = 'MKT_FCST'
			AND a.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			-- modified by ytchoi 20180813
			-- AND DIVISION_ID <> '40'
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK)
				where 1=1
				AND rslt.v_division_id		=	item.division_id
				AND rslt.v_item_id			=	item.item_id
				AND a.division_id			=   rslt.v_division_id      
				AND a.project_code			=   rslt.v_project_code   
				AND a.scm_site_id			=   rslt.v_scm_site_id  
				AND a.item_id				=   rslt.v_item_id      
				AND a.dom_exp				=   rslt.v_dom_exp      
				AND a.fcst_type				=   rslt.v_fcst_type    
				AND a.incoterms				=   rslt.v_incoterms    
				AND a.plant_site_id			=   rslt.v_plant_site_id
				AND item.ACTIVE_FLAG = 'Y'  --20180720 ACTIVE_FLAG 조건추가
				--↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND ( item.item_type in ('Q' , 'R' ) OR 
					( rslt.v_item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) 
					  where k.division_id = rslt.v_division_id and k.SCP_OPERATION_GROUP = 'E' and k.ACTIVE_FLAG = 'Y'  )  ))  --20180720 ACTIVE_FLAG 조건추가
				--↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				) 

		--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST5
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                  20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		----------------------------------------------------------|
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정

		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			--where MEASURE = 'RTF'
			where MEASURE = 'RTF_SYS_RP'  --20200507 변경
			AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK)
				where 1=1
				AND rslt.v_division_id					=	item.division_id
				AND rslt.v_item_id						=	item.item_id
				AND DM_PLN_MKT_FCST.division_id			=   rslt.v_division_id      
				AND DM_PLN_MKT_FCST.project_code		=   rslt.v_project_code   
				AND DM_PLN_MKT_FCST.scm_site_id			=   rslt.v_scm_site_id  
				AND DM_PLN_MKT_FCST.item_id				=   rslt.v_item_id      
				AND DM_PLN_MKT_FCST.dom_exp				=   rslt.v_dom_exp      
				AND DM_PLN_MKT_FCST.fcst_type			=   rslt.v_fcst_type    
				AND DM_PLN_MKT_FCST.incoterms			=   rslt.v_incoterms    
				AND DM_PLN_MKT_FCST.plant_site_id		=   rslt.v_plant_site_id
				AND DM_PLN_MKT_FCST.yyyymmdd			>=  @plan_start_yyyymmdd
				AND item.ACTIVE_FLAG = 'Y'
				AND rslt.v_fcst_type  = 'RMA'
				) ;


		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  --,'RTF' 
			  ,'RTF_SYS_RP'  --20200507 변경
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]
			  ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,a.[ATTRIBUTE1]
			  ,a.[ATTRIBUTE2]
			  ,a.[ATTRIBUTE3]
			  ,a.[ATTRIBUTE4]
			  ,a.[ATTRIBUTE5]
			  ,a.[ATTRIBUTE6]
			  ,a.[ATTRIBUTE7]
			  ,a.[ATTRIBUTE8]
			  ,a.[ATTRIBUTE9]
			  ,a.[ATTRIBUTE10]
		  from dm_pln_mkt_fcst a WITH(NOLOCK)
			where a.MEASURE = 'MKT_FCST'
			AND a.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK)
				where 1=1
				AND rslt.v_division_id		=	item.division_id
				AND rslt.v_item_id			=	item.item_id
				AND a.division_id			=   rslt.v_division_id      
				AND a.project_code			=   rslt.v_project_code   
				AND a.scm_site_id			=   rslt.v_scm_site_id  
				AND a.item_id				=   rslt.v_item_id      
				AND a.dom_exp				=   rslt.v_dom_exp      
				AND a.fcst_type				=   rslt.v_fcst_type    
				AND a.incoterms				=   rslt.v_incoterms    
				AND a.plant_site_id			=   rslt.v_plant_site_id
				AND item.ACTIVE_FLAG = 'Y'
				AND rslt.v_fcst_type  = 'RMA'
				) 

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                          BALANCE_CREATE 호출 로직 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN


		DECLARE @c_division_id         NVARCHAR(MAX);

		INSERT INTO #SEND_TARGET_DATA
		        (division_id  
				,project_code 
				,scm_site_id  
				,item_id      
				,dom_exp      
				,fcst_type    
				,incoterms    
				,plant_site_id
				,cell_prod_site_id
				,vmi_yn 
				)
		SELECT 
			     V_DIVISION_ID,v_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP,V_FCST_TYPE,V_INCOTERMS,V_PLANT_SITE_ID
				,'-'		AS cell_prod_site_id
				,'N'		AS vmi_yn-- vmi_yn 초기값
			FROM  #results WHERE 1=1
		GROUP BY V_DIVISION_ID,v_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP,V_FCST_TYPE,V_INCOTERMS,V_PLANT_SITE_ID
		;
		SET @c_division_id = (SELECT TOP 1 DIVISION_ID FROM #SEND_TARGET_DATA)
			
		--PRINT N'BALANCE_CREATE CALL START  Division => ' + @c_division_id + N'              '+ CONVERT(VARCHAR(8), GETDATE(), 108)

		---------------------------------------------------------------------------------------- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (START)
		EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 
													  @c_division_id
													, @p_plan_id = 'CALL'
		---------------------------------------------------------------------------------------- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (END)

		--PRINT N'BALANCE_CREATE CALL END    Division => ' + @c_division_id + N'              '+ CONVERT(VARCHAR(8), GETDATE(), 108)

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                          BALANCE_CREATE 호출 로직 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

 
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- SCP가 Open 했기 때문에 RTF 값을 MKT FCST에서 수정하지 않음.
	IF (SELECT count(1) FROM #results where v_DIVISION_ID = '40') > 0
		BEGIN
			EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE  
		END
	--PRINT N'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE   end                            =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎


    --COMMIT TRANSACTION DM0003_SAVE_MKT_FCST ;
		--PRINT N'ALL JOB END                                     =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

	END TRY

	BEGIN CATCH

		--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST
		--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST9
  
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']_O' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END CATCH

	SET NOCOUNT OFF;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
  END;

	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST

			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end


