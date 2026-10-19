
/*---------------------------------------------------------------------------------------------------
 * Program ID   : DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
 * Description  : MKT FCST 화면에서 팝업화면을 띄워서 INCOTERMS등 PK값을 수정할수 있도록 함.
 * Program History
 *====================================================================================================
 *   Date       In Charge		Description
 *====================================================================================================
 * 2018/05/16	KHSONG			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * 2018/06/01					pk값 validation KHSONG
 * 2018/08/07 
 * 2020/09/09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2021/05/04	P.C.I			[C20210504-000051] Sales Plan, Sales Price 적용 기준 변경
 * 2021/07/02	HWI1993			[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021/08/06	hwi1993			중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2022/11/04	rosia27			[C20221024-000510]DM UI 소스 정리 요청
 * 2022/12/07	hwi1993			[C20221205-000135] GSCM Master change 인코텀즈 변경 기능 개선
 * 2026/03/25	JSSBAE			[E20260323-000132]_MKT FCST UI Master Chg 버튼 오류 수정 요청
 * ---------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE]
	-- Add the parameters for the stored procedure here
	  @p_division_id		NVARCHAR(MAX)
	, @p_project_code		NVARCHAR(MAX)
	, @p_scm_site_id		NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
	, @p_dom_exp			NVARCHAR(MAX)
	, @p_fcst_type			NVARCHAR(MAX)
	, @p_incoterms			NVARCHAR(MAX)
	, @p_plant_site_id  	NVARCHAR(MAX)
	, @p_dom_exp_new		NVARCHAR(MAX)
	, @p_fcst_type_new		NVARCHAR(MAX)
	, @p_incoterms_new		NVARCHAR(MAX)
	, @p_plant_site_id_new	NVARCHAR(MAX)
	, @p_created_by      	NVARCHAR(MAX)
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_dom_exp				NVARCHAR(MAX);
	DECLARE @v_fcst_type			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_plant_site_id		NVARCHAR(MAX);
	DECLARE @v_dom_exp_new			NVARCHAR(MAX);
	DECLARE @v_fcst_type_new		NVARCHAR(MAX);
	DECLARE @v_incoterms_new		NVARCHAR(MAX);
	DECLARE @v_plant_site_id_new	NVARCHAR(MAX);
	DECLARE @v_created_by       	NVARCHAR(MAX);

	SET @v_division_id			= NULL;
	SET @v_project_code			= NULL;
	SET @v_scm_site_id			= NULL;
	SET @v_item_id				= NULL;
	SET @v_dom_exp				= NULL;	 
	SET @v_fcst_type			= NULL;	 
	SET @v_incoterms			= NULL;	 
	SET @v_plant_site_id		= NULL;	 
	SET @v_dom_exp_new			= NULL;	 
	SET @v_fcst_type_new		= NULL;	 
	SET @v_incoterms_new		= NULL;	 
	SET @v_plant_site_id_new	= NULL;	 
	SET @v_created_by       	= NULL;	 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_division_id			= RTRIM(@p_division_id		) + '^';
	SET @p_project_code			= RTRIM(@p_project_code		) + '^';
	SET @p_scm_site_id			= RTRIM(@p_scm_site_id		) + '^';
	SET @p_item_id				= RTRIM(@p_item_id			) + '^';
	SET @p_dom_exp				= RTRIM(@p_dom_exp			) + '^';
	SET @p_fcst_type			= RTRIM(@p_fcst_type		) + '^';
	SET @p_incoterms			= RTRIM(@p_incoterms		) + '^';
	SET @p_plant_site_id		= RTRIM(@p_plant_site_id	) + '^';
	SET @p_dom_exp_new			= RTRIM(@p_dom_exp_new      ) + '^';
	SET @p_fcst_type_new		= RTRIM(@p_fcst_type_new    ) + '^';
	SET @p_incoterms_new		= RTRIM(@p_incoterms_new    ) + '^';
	SET @p_plant_site_id_new	= RTRIM(@p_plant_site_id_new) + '^';
	SET @p_created_by       	= RTRIM(@p_created_by       ) + '^';
	
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 		
		DROP TABLE #results
	IF OBJECT_ID (N'tempdb..#valid_results', N'U') IS NOT NULL 		
		DROP TABLE #valid_results


	-- #results TEMP TABLE
	CREATE TABLE #results  (
			 v_division_id			NVARCHAR(MAX)
			,v_project_code			NVARCHAR(MAX)
			,v_scm_site_id			NVARCHAR(MAX)
			,v_item_id				NVARCHAR(MAX)
			,v_dom_exp				NVARCHAR(MAX)
			,v_fcst_type			NVARCHAR(MAX)
			,v_incoterms			NVARCHAR(MAX)
			,v_plant_site_id		NVARCHAR(MAX)
			,v_dom_exp_new          NVARCHAR(MAX)
			,v_fcst_type_new        NVARCHAR(MAX)
			,v_incoterms_new        NVARCHAR(MAX)
			,v_plant_site_id_new    NVARCHAR(MAX)
			,v_created_by           NVARCHAR(MAX)
			)

	-- #valid_results TEMP TABLE
	CREATE TABLE #valid_results  (
			 v_division_id			NVARCHAR(MAX)
			,v_project_code			NVARCHAR(MAX)
			,v_scm_site_id			NVARCHAR(MAX)
			,v_item_id				NVARCHAR(MAX)
			,v_dom_exp              NVARCHAR(MAX)
			,v_fcst_type            NVARCHAR(MAX)
			,v_incoterms            NVARCHAR(MAX)
			,v_plant_site_id        NVARCHAR(MAX)
			,v_measure              NVARCHAR(MAX)
			)

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION TR_SAVE_MKT_FCST_PK_DATA_UPDATE;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
--===================================================================================== #results 테이블에 split후 insert start
	--###############################################  #results 테이블에 split후 insert (START)
	WHILE LEN(@p_DIVISION_ID) > 0
	BEGIN

	 DECLARE @index_division_id				INT
	 DECLARE @index_project_code			INT
	 DECLARE @index_scm_site_id				INT
	 DECLARE @index_item_id					INT
	 DECLARE @index_dom_exp					INT
	 DECLARE @index_fcst_type				INT
	 DECLARE @index_incoterms				INT
	 DECLARE @index_plant_site_id			INT
	 DECLARE @index_dom_exp_new				INT
	 DECLARE @index_fcst_type_new			INT
	 DECLARE @index_incoterms_new			INT
	 DECLARE @index_plant_site_id_new		INT
	 DECLARE @index_created_by				INT

	 SET @index_division_id			= PATINDEX('%' + '^' + '%', @p_division_id			)
	 SET @index_project_code		= PATINDEX('%' + '^' + '%', @p_project_code			)
	 SET @index_scm_site_id			= PATINDEX('%' + '^' + '%', @p_scm_site_id			)
	 SET @index_item_id				= PATINDEX('%' + '^' + '%', @p_item_id				)
	 SET @index_dom_exp				= PATINDEX('%' + '^' + '%', @p_dom_exp				)
	 SET @index_fcst_type			= PATINDEX('%' + '^' + '%', @p_fcst_type			)
	 SET @index_incoterms			= PATINDEX('%' + '^' + '%', @p_incoterms			)
	 SET @index_plant_site_id		= PATINDEX('%' + '^' + '%', @p_plant_site_id		)
	 SET @index_dom_exp_new			= PATINDEX('%' + '^' + '%', @p_dom_exp_new			)
	 SET @index_fcst_type_new		= PATINDEX('%' + '^' + '%', @p_fcst_type_new		)
	 SET @index_incoterms_new		= PATINDEX('%' + '^' + '%', @p_incoterms_new		)
	 SET @index_plant_site_id_new	= PATINDEX('%' + '^' + '%', @p_plant_site_id_new	)
	 SET @index_created_by			= PATINDEX('%' + '^' + '%', @p_created_by			)

	 -- 확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
		IF @index_DIVISION_ID > 0
			  BEGIN
			   SET @v_division_id		= SUBSTRING(@p_division_id			, 0, @index_division_id			)
			   SET @v_project_code		= SUBSTRING(@p_project_code			, 0, @index_project_code		)
			   SET @v_scm_site_id		= SUBSTRING(@p_scm_site_id			, 0, @index_scm_site_id			)
			   SET @v_item_id			= SUBSTRING(@p_item_id				, 0, @index_item_id				)
			   SET @v_dom_exp			= SUBSTRING(@p_dom_exp				, 0, @index_dom_exp				)
			   SET @v_fcst_type			= SUBSTRING(@p_fcst_type			, 0, @index_fcst_type			)
			   SET @v_incoterms			= SUBSTRING(@p_incoterms			, 0, @index_incoterms			)
			   SET @v_plant_site_id		= SUBSTRING(@p_plant_site_id		, 0, @index_plant_site_id		)
			   SET @v_dom_exp_new       = SUBSTRING(@p_dom_exp_new			, 0, @index_dom_exp_new         )
			   SET @v_fcst_type_new     = SUBSTRING(@p_fcst_type_new		, 0, @index_fcst_type_new       )
			   SET @v_incoterms_new     = SUBSTRING(@p_incoterms_new		, 0, @index_incoterms_new       )
			   SET @v_plant_site_id_new = SUBSTRING(@p_plant_site_id_new	, 0, @index_plant_site_id_new   )
			   SET @v_created_by	    = SUBSTRING(@p_created_by			, 0, @index_created_by		    )

			   SET @p_division_id		= SUBSTRING(@p_division_id		, LEN(@v_division_id		+ '^') + 1, LEN(@p_division_id		))
			   SET @p_project_code		= SUBSTRING(@p_project_code		, LEN(@v_project_code		+ '^') + 1, LEN(@p_project_code		))
			   SET @p_scm_site_id		= SUBSTRING(@p_scm_site_id		, LEN(@v_scm_site_id		+ '^') + 1, LEN(@p_scm_site_id		))
			   SET @p_item_id			= SUBSTRING(@p_item_id			, LEN(@v_item_id			+ '^') + 1, LEN(@p_item_id			))
			   SET @p_dom_exp			= SUBSTRING(@p_dom_exp			, LEN(@v_dom_exp			+ '^') + 1, LEN(@p_dom_exp			))
			   SET @p_fcst_type			= SUBSTRING(@p_fcst_type		, LEN(@v_fcst_type			+ '^') + 1, LEN(@p_fcst_type		))
			   SET @p_incoterms			= SUBSTRING(@p_incoterms		, LEN(@v_incoterms			+ '^') + 1, LEN(@p_incoterms		))
			   SET @p_plant_site_id		= SUBSTRING(@p_plant_site_id	, LEN(@v_plant_site_id		+ '^') + 1, LEN(@p_plant_site_id	))
			   SET @p_dom_exp_new       = SUBSTRING(@p_dom_exp_new      , LEN(@v_dom_exp_new		+ '^') + 1, LEN(@p_dom_exp_new      ))
			   SET @p_fcst_type_new     = SUBSTRING(@p_fcst_type_new    , LEN(@v_fcst_type_new		+ '^') + 1, LEN(@p_fcst_type_new    ))
			   SET @p_incoterms_new     = SUBSTRING(@p_incoterms_new    , LEN(@v_incoterms_new		+ '^') + 1, LEN(@p_incoterms_new    ))
			   SET @p_plant_site_id_new = SUBSTRING(@p_plant_site_id_new, LEN(@v_plant_site_id_new	+ '^') + 1, LEN(@p_plant_site_id_new))
			   SET @p_created_by		= SUBSTRING(@p_created_by		, LEN(@v_created_by			+ '^') + 1, LEN(@p_created_by		))
 
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  @v_dom_exp_new			IS NULL OR @v_dom_exp_new = ''
			      SET @v_dom_exp_new		=		@v_dom_exp
			   IF  @v_fcst_type_new			IS NULL OR @v_fcst_type_new = ''
			      SET @v_fcst_type_new		=		@v_fcst_type
			   IF  @v_incoterms_new			IS NULL OR @v_incoterms_new = ''
			      SET @v_incoterms_new		=		@v_incoterms
			   IF  @v_plant_site_id_new		IS NULL OR @v_plant_site_id_new = ''
			      SET @v_plant_site_id_new	=		@v_plant_site_id
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)
			       

			   INSERT INTO #results ( 
					  v_division_id  
					 ,v_project_code 
					 ,v_scm_site_id  
					 ,v_item_id      
					 ,v_dom_exp      
					 ,v_fcst_type    
					 ,v_incoterms    
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new   
					 ,v_incoterms_new    
					 ,v_plant_site_id_new
					 ,v_created_by
			   ) VALUES ( 
					  @v_division_id  
					 ,@v_project_code 
					 ,@v_scm_site_id  
					 ,@v_item_id      
					 ,@v_dom_exp      
					 ,@v_fcst_type    
					 ,@v_incoterms    
					 ,@v_plant_site_id
					 ,@v_dom_exp_new
					 ,@v_fcst_type_new    
					 ,@v_incoterms_new    
					 ,@v_plant_site_id_new
					 ,@v_created_by
			   )
			  END
		ELSE
			  BEGIN
			   SET @v_DIVISION_ID = @p_DIVISION_ID
			   SET @p_DIVISION_ID = NULL
 
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  @v_dom_exp_new			IS NULL OR @v_dom_exp_new = ''
			      SET @v_dom_exp_new		=		@v_dom_exp
			   IF  @v_fcst_type_new			IS NULL OR @v_fcst_type_new = ''
			      SET @v_fcst_type_new		=		@v_fcst_type
			   IF  @v_incoterms_new			IS NULL OR @v_incoterms_new = ''
			      SET @v_incoterms_new		=		@v_incoterms
			   IF  @v_plant_site_id_new		IS NULL OR @v_plant_site_id_new = ''
			      SET @v_plant_site_id_new	=		@v_plant_site_id
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)

			   INSERT INTO #results ( 
					  v_division_id  
					 ,v_project_code 
					 ,v_scm_site_id  
					 ,v_item_id      
					 ,v_dom_exp      
					 ,v_fcst_type    
					 ,v_incoterms    
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new   
					 ,v_incoterms_new    
					 ,v_plant_site_id_new
					 ,v_created_by
			   ) VALUES ( 
					  @v_division_id  
					 ,@v_project_code 
					 ,@v_scm_site_id  
					 ,@v_item_id      
					 ,@v_dom_exp      
					 ,@v_fcst_type    
					 ,@v_incoterms    
					 ,@v_plant_site_id
					 ,@v_dom_exp_new
					 ,@v_fcst_type_new    
					 ,@v_incoterms_new    
					 ,@v_plant_site_id_new
					 ,@v_created_by
			   )
	  END
		
	END
		--###############################################   #results 테이블에 split후 insert (END)

	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (start)
	BEGIN
		IF isnull((select count(1) from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
			        where 1=1
			            and division_id   = @v_division_id 
			            and project_code  = @v_project_code 
			),0) = 0
		begin
			SET @v_log_type = 'INVALID';
			SELECT '['+ @v_PROJECT_CODE +']'+ N' Invalid Project Code !'
			goto err_rtn
		end
	END

	-- 22년 데이터가 있고, 소형이고 , 마감이 되었다면 수정내역 취소
	IF EXISTS ( SELECT * FROM #results WHERE V_DIVISION_ID = '40' )
		AND EXISTS (
				SELECT *
				FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'DM_LONG_PLAN'
				AND SEGMENT1 = '40'
				AND ATTRIBUTE1 = 'Y'	-- 마감여부
				AND VALID_YN = 'Y')
		AND EXISTS (
				SELECT *
				FROM #results A
				JOIN DM_PLN_MKT_FCST B ON	A.V_DIVISION_ID		= B.DIVISION_ID	
										AND A.V_PROJECT_CODE 	= B.PROJECT_CODE 	
										AND A.V_SCM_SITE_ID 	= B.SCM_SITE_ID 	
										AND A.V_ITEM_ID 		= B.ITEM_ID 		
										AND A.V_DOM_EXP 		= B.DOM_EXP 		
										AND A.V_FCST_TYPE 		= B.FCST_TYPE 	
										AND A.V_INCOTERMS 		= B.INCOTERMS 	
										AND A.V_PLANT_SITE_ID	= B.PLANT_SITE_ID	
				WHERE B.YYYYMMDD >= '20220101'
					AND B.MEASURE IN ( 'MKT_FCST', 'RTF', 'RTF_SYS_RP', 'VMI_IN_REQ' )
				) 
		begin
			SET @v_log_type = 'INVALID';
			SELECT N'2022년 데이터가 있는 마스터는 변경할 수 없습니다.'
			goto err_rtn
		end




	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (end)

		-- 속도개선 cursor 구조로 변경
		-- 신규변수
		DECLARE @m_DIVISION_ID         NVARCHAR(MAX);
		DECLARE @m_SCM_SITE_ID         NVARCHAR(MAX);
		DECLARE @m_PROJECT_CODE        NVARCHAR(MAX);

		DELETE #valid_results;

			
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_MST')
			BEGIN
				CLOSE CURSOR1_MST
				DEALLOCATE CURSOR1_MST
			END;
		DECLARE CURSOR1_MST CURSOR FAST_FORWARD FOR
		SELECT 
			      V_DIVISION_ID,V_SCM_SITE_ID,V_PROJECT_CODE
			FROM  #results WHERE 1=1
		GROUP BY V_DIVISION_ID,  V_SCM_SITE_ID,V_PROJECT_CODE

		BEGIN
			OPEN CURSOR1_MST;
			FETCH NEXT FROM CURSOR1_MST INTO          -- PROJECT_CODE별 LOOP수행
									  @m_DIVISION_ID    
									 ,@m_SCM_SITE_ID  
									 ,@m_PROJECT_CODE  
		END

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
        BEGIN
		

		----------------------------------------------------------------------------------------------- 20180601 pk값 validation (start) 
		--BEGIN
			--BEGIN TRANSACTION PK_UPDATE_01
			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (start)
			delete from DM_PLN_MKT_FCST
			where EXISTS(
					select v_division_id
						from #results x
						where x.v_division_id     = DM_PLN_MKT_FCST.DIVISION_ID
						and x.v_project_code      = DM_PLN_MKT_FCST.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_MKT_FCST.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_MKT_FCST.ITEM_ID
						and x.v_dom_exp_new       = DM_PLN_MKT_FCST.DOM_EXP
						and x.v_fcst_type_new     = DM_PLN_MKT_FCST.FCST_TYPE
						and x.v_incoterms_new     = DM_PLN_MKT_FCST.incoterms
						and x.v_plant_site_id_new = DM_PLN_MKT_FCST.PLANT_SITE_ID
					) 
				and qty = 0
				and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  @m_DIVISION_ID 
				AND SCM_SITE_ID   =  @m_SCM_SITE_ID 
				AND PROJECT_CODE  =  @m_PROJECT_CODE
			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (end)
			--COMMIT TRANSACTION PK_UPDATE_01
		--END

			-- 20181108 (start)
			delete from SCM_MST_FUTURE_PRICE
			where EXISTS(
					select v_division_id
						from #results x
						where x.v_division_id     = SCM_MST_FUTURE_PRICE.DIVISION_ID
						and x.v_project_code      = SCM_MST_FUTURE_PRICE.PROJECT_CODE
						and x.v_scm_site_id       = SCM_MST_FUTURE_PRICE.SCM_SITE_ID
						and x.v_item_id           = SCM_MST_FUTURE_PRICE.ITEM_ID
						and x.v_dom_exp_new       = SCM_MST_FUTURE_PRICE.DOM_EXP
						and x.v_fcst_type_new     = SCM_MST_FUTURE_PRICE.FCST_TYPE
						and x.v_incoterms_new     = SCM_MST_FUTURE_PRICE.incoterms
						and x.v_plant_site_id_new = SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
						--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 변경 후 Sales Price 삭제
						AND x.v_fcst_type not in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					) 
				--and PRICE = 0 --[C20210504-000051] Sales Price 적용 기준 변경
				and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  @m_DIVISION_ID 
				AND SCM_SITE_ID   =  @m_SCM_SITE_ID 
				AND PROJECT_CODE  =  @m_PROJECT_CODE
			-- 20181108 (END)

			
			--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제						
			delete from DM_PLN_SALES_PLAN
			where EXISTS(
					select v_division_id
						from #results x
						where x.v_division_id     = DM_PLN_SALES_PLAN.DIVISION_ID
						and x.v_project_code      = DM_PLN_SALES_PLAN.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_SALES_PLAN.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_SALES_PLAN.ITEM_ID
						and x.v_dom_exp           = DM_PLN_SALES_PLAN.DOM_EXP
						and x.v_fcst_type		  = DM_PLN_SALES_PLAN.FCST_TYPE
						and x.v_incoterms		  = DM_PLN_SALES_PLAN.incoterms
						and x.v_plant_site_id	  = DM_PLN_SALES_PLAN.PLANT_SITE_ID
						--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
						AND x.v_fcst_type_new in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					) 
				and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  @m_DIVISION_ID 
				AND SCM_SITE_ID   =  @m_SCM_SITE_ID 
				AND PROJECT_CODE  =  @m_PROJECT_CODE
				AND MEASURE in ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','MKT_AMT_KRW','MKT_AMT_LOC')



			-- 입력된 MASTER 정보로 MEASURE 추출 (start)
			INSERT INTO #valid_results
				SELECT   a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
					  ,#results rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp_new
					and a.fcst_type			= rslt.v_fcst_type_new
					and a.incoterms			= rslt.v_incoterms_new
					and a.plant_site_id		= rslt.v_plant_site_id_new
					and a.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  @m_DIVISION_ID 
					AND a.SCM_SITE_ID        =  @m_SCM_SITE_ID 
					AND a.PROJECT_CODE       =  @m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  @m_DIVISION_ID 
					AND rslt.v_SCM_SITE_ID   =  @m_SCM_SITE_ID 
					AND rslt.v_PROJECT_CODE  =  @m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE

				UNION

				SELECT   a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
					  ,#results rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp
					and a.fcst_type			= rslt.v_fcst_type
					and a.incoterms			= rslt.v_incoterms
					and a.plant_site_id		= rslt.v_plant_site_id
					and a.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  @m_DIVISION_ID 
					AND a.SCM_SITE_ID        =  @m_SCM_SITE_ID 
					AND a.PROJECT_CODE       =  @m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  @m_DIVISION_ID 
					AND rslt.v_SCM_SITE_ID   =  @m_SCM_SITE_ID 
					AND rslt.v_PROJECT_CODE  =  @m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE

			-- 입력된 MASTER 정보로 MEASURE 추출 (end)

			-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
			IF
				(SELECT COUNT(1) from DM_PLN_MKT_FCST WITH(NOLOCK)
				where (
						select count(1)
							from #valid_results rslt
							where rslt.v_division_id    = DM_PLN_MKT_FCST.DIVISION_ID
							and rslt.v_project_code     = DM_PLN_MKT_FCST.PROJECT_CODE
							and rslt.v_scm_site_id      = DM_PLN_MKT_FCST.SCM_SITE_ID
							and rslt.v_item_id          = DM_PLN_MKT_FCST.ITEM_ID
							and rslt.v_dom_exp			= DM_PLN_MKT_FCST.DOM_EXP
							and rslt.v_fcst_type		= DM_PLN_MKT_FCST.FCST_TYPE
							and rslt.v_incoterms		= DM_PLN_MKT_FCST.incoterms
							and rslt.v_plant_site_id	= DM_PLN_MKT_FCST.PLANT_SITE_ID
							and rslt.v_measure			= DM_PLN_MKT_FCST.MEASURE
							and DM_PLN_MKT_FCST.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
							AND rslt.v_DIVISION_ID   =  @m_DIVISION_ID 
							AND rslt.v_SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND rslt.v_PROJECT_CODE  =  @m_PROJECT_CODE
							group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 1) > 1
					AND DIVISION_ID        =  @m_DIVISION_ID 
					AND SCM_SITE_ID        =  @m_SCM_SITE_ID 
					AND PROJECT_CODE       =  @m_PROJECT_CODE

					 )
					> 0
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT N'이미 존재하는 Project,site,model 정보입니다.'
						goto err_rtn
					END

			----------------------------------------------------------------------------------------------- 20180601 pk값 validation (end)

				-- DM_PLN_MKT_FCST UPDATE 
				BEGIN
				--BEGIN TRANSACTION PK_UPDATE_02
						MERGE INTO dbo.DM_PLN_MKT_FCST A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from #results
										  where 1=1
											AND v_DIVISION_ID        =  @m_DIVISION_ID 
											AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID 
											AND v_PROJECT_CODE       =  @m_PROJECT_CODE
								  ) B
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  @m_DIVISION_ID 
								AND A.SCM_SITE_ID        =  @m_SCM_SITE_ID 
								AND A.PROJECT_CODE       =  @m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= GETDATE()
							 ;
				END

				-- DM_PLN_SALES_PLAN UPDATE 
				BEGIN						
						MERGE INTO dbo.DM_PLN_SALES_PLAN A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from #results
										  where 1=1
											AND v_DIVISION_ID        =  @m_DIVISION_ID 
											AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID 
											AND v_PROJECT_CODE       =  @m_PROJECT_CODE
							  ) B
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  @m_DIVISION_ID 
								AND A.SCM_SITE_ID        =  @m_SCM_SITE_ID 
								AND A.PROJECT_CODE       =  @m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= GETDATE()
							 ;

						--[C20210504-000051] 변경 전 fcst type이 무상인 경우에 SalesAMT 생성
						INSERT INTO dbo.DM_PLN_SALES_PLAN
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID 
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,@v_created_by						
								,GETDATE()							
								,'SYSTEM'						
								,GETDATE()							
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
							left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'KRW' 
							   )
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
							AND w.DIVISION_ID   =  @m_DIVISION_ID 
							AND w.SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND w.PROJECT_CODE  =  @m_PROJECT_CODE
							and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
										  ,dm_pln_sales_plan b WITH(NOLOCK)
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id  
											from #results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= isnull(v_plant_site_id,'')
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL 
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,@v_created_by							
								,GETDATE()								
								,'SYSTEM'    							
								,GETDATE()								
								,NULL -- ATTRIBUTE1	
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
							left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'LOC' 
							   )
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)   
							AND w.DIVISION_ID   =  @m_DIVISION_ID 
							AND w.SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND w.PROJECT_CODE  =  @m_PROJECT_CODE
							and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
										  ,dm_pln_sales_plan b WITH(NOLOCK)
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id  
											from #results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= isnull(v_plant_site_id,'')
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL 
						-- USD 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_USD' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,@v_created_by								
								,GETDATE()									
								,'SYSTEM'    							
								,GETDATE()								
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
							left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'USD' 
							   )
							where w.measure = 'RTF_SYS_RP'
						   and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)    
						   AND w.DIVISION_ID   =  @m_DIVISION_ID 
							AND w.SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND w.PROJECT_CODE  =  @m_PROJECT_CODE
							and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
										  ,dm_pln_sales_plan b WITH(NOLOCK)
									 where sales_plan_adjust_yn = 'N'
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id  
											from #results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= isnull(v_plant_site_id,'')
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL 
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID 
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10)) 
								,@v_created_by						--[2018-03-15][수정]
								,GETDATE()							--[2018-03-15][수정]
								,'SYSTEM'						--[2018-03-15][수정]
								,GETDATE()							--[2018-03-15][수정]
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
							left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'KRW' 
							   )
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	-- [C20210629-000239]
							and w.division_id = @v_division_id
							and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
							AND w.DIVISION_ID   =  @m_DIVISION_ID 
							AND w.SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND w.PROJECT_CODE  =  @m_PROJECT_CODE
							and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
							and exists (select v_division_id  
											from #results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.PLANT_SITE_ID		= isnull(v_plant_site_id,'')
												and W.item_id			= v_item_id
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL 
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10)) 
								,@v_created_by							--[2018-03-15][수정]
								,GETDATE()								--[2018-03-15][수정]
								,'SYSTEM'    							--[2018-03-15][수정]
								,GETDATE()								--[2018-03-15][수정]
								,NULL -- ATTRIBUTE1	
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
							left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'LOC' 
							   )
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	[C20210629-000239]
							and w.division_id = @v_division_id
							and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)   
							AND w.DIVISION_ID   =  @m_DIVISION_ID 
							AND w.SCM_SITE_ID   =  @m_SCM_SITE_ID 
							AND w.PROJECT_CODE  =  @m_PROJECT_CODE
							and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
							and exists (select v_division_id  
											from #results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= isnull(v_plant_site_id,'')
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)



				END

				-- SCM_MST_FUTURE_PRICE UPDATE 
				BEGIN
					----------------------------------------------------------------------------------------------- 20181108 pk값 validation (START)
					-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
					DECLARE @s_FUTURE_valid    	NVARCHAR(MAX);
					set @s_FUTURE_valid = ''

					set @s_FUTURE_valid = 
					(SELECT top 1 '[PROJECT_CODE : '+PROJECT_CODE+']'+char(10)+'[SCM_SITE_ID : '+SCM_SITE_ID+']'+char(10)+'[ITEM_ID : '+ITEM_ID+']'+char(10)+'[DOM_EXP : '+DOM_EXP+']'
					+char(10)+'[FCST_TYPE : '+FCST_TYPE+']'+char(10)+'[INCOTERMS : '+INCOTERMS+']'+char(10)+'[PLANT_SITE_ID : '+PLANT_SITE_ID+']'
						  from SCM_MST_FUTURE_PRICE WITH(NOLOCK)
						where exists (
								select v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
								--DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,incoterms,PLANT_SITE_ID
									from #results rslt
									where rslt.v_division_id		= SCM_MST_FUTURE_PRICE.DIVISION_ID
									and rslt.v_project_code			= SCM_MST_FUTURE_PRICE.PROJECT_CODE
									and rslt.v_scm_site_id			= SCM_MST_FUTURE_PRICE.SCM_SITE_ID
									and rslt.v_item_id				= SCM_MST_FUTURE_PRICE.ITEM_ID
									and rslt.v_dom_exp_new			= SCM_MST_FUTURE_PRICE.DOM_EXP
									and rslt.v_fcst_type_new		= SCM_MST_FUTURE_PRICE.FCST_TYPE
									and rslt.v_incoterms_new		= SCM_MST_FUTURE_PRICE.incoterms
									and rslt.v_plant_site_id_new	= SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
									and SCM_MST_FUTURE_PRICE.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
									AND rslt.v_DIVISION_ID   =  @m_DIVISION_ID 
									AND rslt.v_SCM_SITE_ID   =  @m_SCM_SITE_ID 
									AND rslt.v_PROJECT_CODE  =  @m_PROJECT_CODE
									--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 중복 Check
									AND rslt.v_fcst_type not in (	SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
									group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 0
									)
							AND DIVISION_ID        =  @m_DIVISION_ID 
							AND SCM_SITE_ID        =  @m_SCM_SITE_ID 
							AND PROJECT_CODE       =  @m_PROJECT_CODE
							)
							

					if @s_FUTURE_valid <> ''
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT N'Sales Price 중복이 발생하였습니다.'+char(10)+@s_FUTURE_valid
							goto err_rtn
						END
						----------------------------------------------------------------------------------------------- 20181108 pk값 validation (end)
						--[C20210504-000051] Sales Price 적용 기준 변경(변경된 Key 값으로 Update -> 변경된 Key 값으로 Insert, 무상은 제외)
						INSERT INTO dbo.SCM_MST_FUTURE_PRICE
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, v_plant_site_id_new, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
						     , v_dom_exp_new, v_fcst_type_new, v_incoterms_new, A.PRICE, A.CREATED_BY, A.CREATION_DATE, v_created_by, GETDATE()
							 , A.ATTRIBUTE1 , A.ATTRIBUTE2 , A.ATTRIBUTE3 , A.ATTRIBUTE4 , A.ATTRIBUTE5 , A.ATTRIBUTE6 , A.ATTRIBUTE7 , A.ATTRIBUTE8 , A.ATTRIBUTE9 , A.ATTRIBUTE10 
						FROM   dbo.SCM_MST_FUTURE_PRICE A
						INNER JOIN (SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									from #results
									where 1=1
									AND v_DIVISION_ID        =  @m_DIVISION_ID 
									AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID 
									AND v_PROJECT_CODE       =  @m_PROJECT_CODE 
									AND v_fcst_type_new not in (SELECT SEGMENT2 
																FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																WHERE 1=1
																AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																AND MST.SEGMENT1    = 'FCST_TYPE'
																AND VALID_YN        = 'Y' )  -- 무상은 제외
									) B		
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID     =  @m_DIVISION_ID 
								AND A.SCM_SITE_ID     =  @m_SCM_SITE_ID 
								AND A.PROJECT_CODE    =  @m_PROJECT_CODE
						  )

						  
						--[C20210504-000051] 무상->유상으로 변경된 경우에 유상 Sales Price가 없으면 알림
						/* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨) */
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
														+char(10) + 'Customs Handbook__ : '+ ISNULL(v_dom_exp_new ,'')    
														+char(10) + 'Fcst Type_____________ : '+ 
																	ISNULL((SELECT TOP 1 SEGMENT2
																		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																		WHERE 1=1
																		AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																		AND MST.SEGMENT1    = A.v_fcst_type_new
																		),'')
														+char(10) + 'Incoterms____________ : '+ ISNULL(v_incoterms_new ,'')     
														+char(10) + 'Plant Site___________ : '+ ISNULL(v_plant_site_id_new ,'')
														+CHAR(10) + 'YYYYMMDD_________ : '+ ISNULL( MIN(M.BASIS_START_DATE),'')  + ' ~ ' + ISNULL(MAX(M.BASIS_START_DATE),'')
														+char(10) +char(10)

										FROM #results A
										inner join scm_mst_site_item z with(nolock)
										on  a.v_division_id		 = z.DIVISION_ID
										and a.v_project_code	 = z.PROJECT_CODE
										and a.v_scm_site_id		 = z.SCM_SITE_ID
										and a.v_item_id			 = z.ITEM_ID
										and z.VALID_YN			 = 'Y'
										AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL )
										LEFT JOIN ( SELECT BASIS_START_DATE 
													FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
														WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
																					AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
													GROUP BY BASIS_START_DATE

													) M
													ON 1=1

										LEFT JOIN SCM_MST_FUTURE_PRICE P WITH(NOLOCK)
											ON (
													a.v_division_id		= p.division_id
												AND a.v_project_code	= p.project_code
												AND a.v_scm_site_id		= p.scm_site_id
												AND a.v_item_id			= p.item_id
												AND a.v_dom_exp_new		= p.dom_exp
												AND a.v_fcst_type_new	= p.fcst_type
												AND a.v_incoterms_new	= p.INCOTERMS
												AND a.v_plant_site_id_new = CASE WHEN a.v_division_id = '81' THEN p.plant_site_id ELSE a.v_plant_site_id END
												AND p.yyyymmdd			= M.basis_start_date
												AND p.price > 0
												)

										WHERE 1=1
											AND p.yyyymmdd IS NULL  -- PRICE값이 없는경우
											AND a.v_fcst_type_new not in (  SELECT SEGMENT2
																			FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																			WHERE 1=1
																			AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																			AND MST.SEGMENT1     = 'FCST_TYPE'
																			AND VALID_YN        = 'Y'  )
											AND a.v_fcst_type in (		SELECT SEGMENT2
																		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																		WHERE 1=1
																		AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																		AND MST.SEGMENT1     = 'FCST_TYPE'
																		AND VALID_YN        = 'Y'  )
										GROUP BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD
										ORDER BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD
									)

						IF @s_unit_price_valid IS NOT NULL
						BEGIN
							SET @v_log_type = 'INVALID';
							SET @v_description = @s_unit_price_valid + N'Unit Price Not Found !'+char(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'+char(10) + N'미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.'
							SELECT @v_description
							GOTO ERR_RTN
						END
						 
						/*
						MERGE INTO dbo.SCM_MST_FUTURE_PRICE A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from #results
										  where 1=1
											AND v_DIVISION_ID        =  @m_DIVISION_ID 
											AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID 
											AND v_PROJECT_CODE       =  @m_PROJECT_CODE
							  ) B
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  @m_DIVISION_ID 
								AND A.SCM_SITE_ID        =  @m_SCM_SITE_ID 
								AND A.PROJECT_CODE       =  @m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= GETDATE()
							 ;*/
				END


				--===================================================================================== HISTORY INSERT start
				BEGIN
		  
							INSERT INTO dbo.DM_PLN_MKT_FCST_PK_DATA_UPDATE_H
							SELECT 
									 v_division_id 
									,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_PK_DATA_UPDATE_H 
									,v_project_code 
									,v_scm_site_id  
									,v_item_id      
									,v_dom_exp      
									,v_fcst_type    
									,v_incoterms    
									,v_plant_site_id
									,v_dom_exp_new      
									,v_fcst_type_new    
									,v_incoterms_new    
									,v_plant_site_id_new
									,v_created_by   
									,getdate()
									,v_created_by   
									,getdate()
									,null,null,null,null,null,null,null,null,null,null
							FROM #results 
								where 1=1
								AND v_DIVISION_ID        =  @m_DIVISION_ID 
								AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID 
								AND v_PROJECT_CODE       =  @m_PROJECT_CODE

				END

				--===================================================================================== HISTORY INSERT end

			--COMMIT TRANSACTION PK_UPDATE_02

			FETCH NEXT FROM CURSOR1_MST INTO 
										@m_DIVISION_ID    
										,@m_SCM_SITE_ID   
										,@m_PROJECT_CODE 

			---------------------------------------------------------------------------------------- 
			END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR1_MST;  
        DEALLOCATE CURSOR1_MST;

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION TR_SAVE_MKT_FCST_PK_DATA_UPDATE;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION TR_SAVE_MKT_FCST_PK_DATA_UPDATE;
	--ROLLBACK TRANSACTION PK_UPDATE_01

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  --[C20200909-000203] LOG 표준화 적용
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
    --  IF @v_log_message IS NULL
	--  SELECT 'success'

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION TR_SAVE_MKT_FCST_PK_DATA_UPDATE
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;
