
/*
 * Program ID   : [DMF0072_SAVE_NNMASTER_MAPPING]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024. 04. 08   KJJ			최초 작성
 * 2024. 12. 10  dsiol			[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
 * 2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
exec DMF0072_SAVE_NNMASTER_MAPPING 
 @P_DIVISION_ID=N'81'
,@P_COMPANY_ID=N'G380^G450^G450'
,@P_ACT_TYPE=N'M^M^M'
,@P_CUST_FCST_TYPE=N'SCM^SCM^SCM'
,@P_END_CUSTOMER=N'Ford^Volvo^Volvo'
,@P_CUST_UNLOAD=N' ^TCFE4^TCFE4'
,@P_CUST_PLANT=N' ^^'
,@P_SOLDTO=N'US000485^CN002782^CN002782'
,@P_SHIPTO=N'US000485^CNH011174^CNH011174'
,@P_PROJECT_CODE=N'A15FD5001^A17VO4001^A17VO4001'
,@P_SCM_SITE_ID=N'Piston_US_RDF^Zhongjia_CN_TIZ^Zhongjia_CN_TIZ'
,@P_FCST_TYPE=N'MPS^MPS^MPS'
,@P_INCOTERMS=N'DDP^FCA^FCA'
,@P_DOM_EXP=N'E^E^E'
,@P_CUST_ITEM_ID=N' L1M8-10C790-A-PIA-3-AK^32299991^32361087'
,@P_MDM_CODE=N'AMFMCU611-A8^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_MAPPING_ITEM_ID=N'AMFMCU611-A9-000^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_MAPPING_ITEM_ID_ORIGINAL=N'AMFMCU611-A8^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_ACTIVE_FLAG=N'Y^Y^Y'
,@P_VALID_FROM=N'20240101^20240201^20240203'
,@P_VALID_TO=N'20991231^20991231^20991230'
,@P_USER_ID=N'dsiol'

exec DMF0072_SAVE_NNMASTER_MAPPING 
 @P_DIVISION_ID=N'81'
,@P_COMPANY_ID=N'G450^G380^G380^G450'
,@P_ACT_TYPE=N'I^M^M^M'
,@P_CUST_FCST_TYPE=N'SCM^SCM^SCM^SCM'
,@P_END_CUSTOMER=N'ATL^BMW^Ford^Aeonus'
,@P_CUST_UNLOAD=N' xxx^^^66666'
,@P_CUST_PLANT=N' yyy^1^^77777'
,@P_SOLDTO=N'B100^AT000009^US000485^AT000003'
,@P_SHIPTO=N'GBH000114^AT000009^US000485^ATH000019'
,@P_PROJECT_CODE=N'A22AT4002^A15BW7002^A15FD5001^A23US4001'
,@P_SCM_SITE_ID=N'ATL_GB_POO^BMW_DE_DFG^Piston_US_RDF^Aeonus_KR_GUN'
,@P_FCST_TYPE=N'MPS^MPS^MPS^MPS'
,@P_INCOTERMS=N'Z01^A01^DDP^FCA'
,@P_DOM_EXP=N'D^D^E^E'
,@P_CUST_ITEM_ID=N' 333^3^L1M8-10C790-A-PIA-3-AK^88888'
,@P_MDM_CODE=N'AMCOME782-A1-0A0^ACLT1010U-A1-D01^AMFMCU611-A8^ACEN1078I-A1-010'
,@P_MAPPING_ITEM_ID=N'AMVAGBEVN-B2-C07^ACLT1010U-A1-D04^ACPN1039I-A1^ACEN1078I-A1-010'
,@P_MAPPING_ITEM_ID_ORIGINAL=N'AMVAGBEVN-B2-C07^APBMW12V0-A1-000^ACPN1039I-A1^ACEN1078I-A1-010'
,@P_ACTIVE_FLAG=N'Y^Y^Y^Y'
,@P_VALID_FROM=N'20240105^20240104^20240102^20240101'
,@P_VALID_TO=N'99991205^99991231^99991230^99991231'
,@P_USER_ID=N'dsiol'

 */
CREATE PROCEDURE [dbo].[DMF0072_SAVE_NNMASTER_MAPPING]
		
	@P_DIVISION_ID				NVARCHAR(MAX),
	@P_COMPANY_ID				NVARCHAR(MAX),
	@P_ACT_TYPE					NVARCHAR(MAX), -- 신규 / 수정 구분( I / M)
	@P_CUST_FCST_TYPE			NVARCHAR(MAX), -- DATA_TYPE_CODE
	@P_END_CUSTOMER				NVARCHAR(MAX),
	@P_CUST_UNLOAD				NVARCHAR(MAX),
	@P_CUST_PLANT				NVARCHAR(MAX),
	@P_SOLDTO					NVARCHAR(MAX),
	@P_SHIPTO					NVARCHAR(MAX),
	@P_PROJECT_CODE				NVARCHAR(MAX),
	@P_SCM_SITE_ID				NVARCHAR(MAX),
	@P_FCST_TYPE 				NVARCHAR(MAX),
	@P_INCOTERMS				NVARCHAR(MAX),
	@P_DOM_EXP					NVARCHAR(MAX),	
	@P_CUST_ITEM_ID				NVARCHAR(MAX),
	@P_MDM_CODE					NVARCHAR(MAX), 
	@P_MAPPING_ITEM_ID			NVARCHAR(MAX), 
	@P_MAPPING_ITEM_ID_ORIGINAL	NVARCHAR(MAX), --@P_MAPPING_ITEM_ID가 KEY인데 수정 해야 해서 원본 값을 가져온다.
	@P_ACTIVE_FLAG				NVARCHAR(MAX),
	@P_VALID_FROM				NVARCHAR(MAX),
	@P_VALID_TO					NVARCHAR(MAX),
	@P_USER_ID     				NVARCHAR(100)

AS

BEGIN


/*
-중요 로직

1.detail 테이블(DM_CUST_ITEM_MAPPING_DTL_N)은 먼저 지우고 insert한다

2.신규일 경우에,detail  정보를 입력안했으면 기본적인 Valid Range 정보를 detail에 강제로 저장한다
  =>시작일 : 당해년도 01-01
  =>종료일 : 2099-12-31
  =>item :  마스터에 등록된 ITEM_ID(@P_MDM_CODE)

3.수정일 경우에 detail  정보를 입력안했으면(기본으로 등록된 Valid Range 정보를 사용자가 직접 삭제하는경우)
  => 마스터의 ACTIVE_FLAG를 N으로 변경 =>화면에서 처리

*/
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0072_SAVE_NNMASTER_MAPPING';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SELECT 
		  B1.TOKEN AS DATA_TYPE_CODE
		, B2.TOKEN AS END_CUSTOMER
		, B3.TOKEN AS UNLOADING_POINT
		, B4.TOKEN AS CUSTOMER_PLANT
		, B5.TOKEN AS SOLDTO_CODE
		, B6.TOKEN AS SHIPTO_CODE
		, B7.TOKEN AS PROJECT_CODE
		, B8.TOKEN AS SCM_SITE_ID
		, B9.TOKEN AS FCST_TYPE
		, B10.TOKEN AS INCOTERMS
		, B11.TOKEN AS DOM_EXP	
		, B12.TOKEN AS CUSTOMER_ITEM_ID
		, B13.TOKEN AS ITEM_ID
		, B14.TOKEN AS ACTIVE_YN
		, B15.TOKEN AS VALID_FROM
		, B16.TOKEN AS VALID_TO
		, B17.TOKEN AS MAPPING_ITEM_ID
		, B18.TOKEN AS ACT_TYPE
		, B19.TOKEN AS COMPANY_ID
		, B20.TOKEN AS MAPPING_ITEM_ID_ORIGINAL
	INTO #T_MAIN
	FROM DBO.UF_FX_STRING_SPLIT(@P_CUST_FCST_TYPE                           , '^') B1
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_END_CUSTOMER			    , '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_CUST_UNLOAD			    , '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_CUST_PLANT			    , '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_SOLDTO				    , '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_SHIPTO				    , '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PROJECT_CODE			    , '^') B7  ON B1.NR = B7.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_SCM_SITE_ID			    , '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_FCST_TYPE			        , '^') B9  ON B1.NR = B9.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_INCOTERMS			        , '^') B10 ON B1.NR = B10.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_DOM_EXP				    , '^') B11 ON B1.NR = B11.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_CUST_ITEM_ID			    , '^') B12 ON B1.NR = B12.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_MDM_CODE		            , '^') B13 ON B1.NR = B13.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_ACTIVE_FLAG	            , '^') B14 ON B1.NR = B14.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_VALID_FROM	            , '^') B15 ON B1.NR = B15.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_VALID_TO	                , '^') B16 ON B1.NR = B16.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_MAPPING_ITEM_ID	        , '^') B17 ON B1.NR = B17.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_ACT_TYPE	                , '^') B18 ON B1.NR = B18.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_COMPANY_ID	            , '^') B19 ON B1.NR = B19.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_MAPPING_ITEM_ID_ORIGINAL	, '^') B20 ON B1.NR = B20.NR
		
--SELECT * FROM #T_MAIN

	DECLARE   @CUR_DATA_TYPE_CODE	NVARCHAR(150)
	, @CUR_END_CUSTOMER				NVARCHAR(150)
	, @CUR_PROJECT_CODE				NVARCHAR(150)
	, @CUR_SCM_SITE_ID				NVARCHAR(150)
	, @CUR_FCST_TYPE				NVARCHAR(150)
	, @CUR_INCOTERMS				NVARCHAR(150)
	, @CUR_DOM_EXP					NVARCHAR(150)
	, @CUR_ITEM_ID					NVARCHAR(150)
	, @CUR_VALID_FROM				NVARCHAR(150)
	, @CUR_VALID_TO					NVARCHAR(150)
	, @CUR_MAPPING_ITEM_ID			NVARCHAR(150)
	, @CUR_UNLOADING_POINT			NVARCHAR(150)
	, @CUR_CUSTOMER_PLANT			NVARCHAR(150)
	, @CUR_CUSTOMER_ITEM_ID			NVARCHAR(150)
	, @CUR_ACT_TYPE					NVARCHAR(150)
	, @CUR_ACTIVE_YN				NVARCHAR(150)
	, @CUR_SOLDTO_CODE				NVARCHAR(150)
	, @CUR_SHIPTO_CODE				NVARCHAR(150)
	, @CUR2_VALID_FROM				NVARCHAR(150)
	, @CUR2_VALID_TO				NVARCHAR(150)
	, @CUR2_MAPPING_ITEM_ID			NVARCHAR(150)

	, @IDX					INT --시작점
	, @CNT					INT --Valid Range 갯수

	--마스터에서 다시 조회해올 값
	, @CUR_M_UNLOADING_POINT	NVARCHAR(150)--마스터의 UNLOADING_POINT(공백이 있을수 있는데이터)
	, @CUR_M_CUSTOMER_PLANT	NVARCHAR(150)--마스터의 CUSTOMER_PLANT(공백이 있을수 있는데이터)
	, @CUR_M_CUSTOMER_ITEM_ID	NVARCHAR(150)--마스터의 CUSTOMER_ITEM_ID(공백이 있는데이터)

	DECLARE @ROWCNT INT
	SET @ROWCNT = 0
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                              ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--DECLARE @VALID_ITEM_ID		     NVARCHAR(MAX);

	--마스터 체크(신규일때만 체크)
	--BEGIN
	--	SET @VALID_ITEM_ID =
	--	(
	--		SELECT TOP 1 A.ITEM_ID
	--			FROM #T_MAIN A
	--			where NOT EXISTS (SELECT  ITEM.division_id  
	--								FROM dbo.scm_mst_site_item ITEM WITH(NOLOCK)
	--									,dbo.SCM_MST_ITEM_SN SN WITH(NOLOCK)  -- 2022.01.20
	--								where 1=1
 --										and ITEM.division_id   = @P_DIVISION_ID
	--									and ITEM.PROJECT_CODE  = A.PROJECT_CODE
	--									and ITEM.scm_site_id   = A.SCM_SITE_ID
	--									and ITEM.ITEM_ID       = A.ITEM_ID 
	--									and ITEM.division_id   = SN.division_id --20180720 ACTIVE_FLAG 조건추가
	--									and ITEM.ITEM_ID       = SN.ITEM_ID --20180720 ACTIVE_FLAG 조건추가
	--									and SN.ACTIVE_FLAG = 'Y' --20180720 ACTIVE_FLAG 조건추가
	--									AND ITEM.VALID_YN = 'Y'		-- [C20200812-000104]
	--								)
	--			AND A.ACT_TYPE = 'I'--신규일때만 체크
	--	)

	--	-------------------------------------------------------------------◎◎◎◎
	--	IF @VALID_ITEM_ID IS NOT NULL
	--		BEGIN
	--			SET @v_log_type = 'INVALID';
	--			--SELECT '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
	--			SET @v_description = '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
	--			goto err_rtn
	--		END
	--	-------------------------------------------------------------------◎◎◎◎
	--END

	--Detail Check---------------------------------------------------------------
	--BEGIN

	--	DECLARE CUR_VALIDMAPPING_LIST CURSOR FAST_FORWARD FOR
	--	SELECT 
	--		PROJECT_CODE
	--		,SCM_SITE_ID
	--		,ITEM_ID
	--	FROM #T_MAIN

	--	OPEN CUR_VALIDMAPPING_LIST;
	--	FETCH NEXT FROM CUR_VALIDMAPPING_LIST INTO 		
	--		 @CUR_PROJECT_CODE		
	--		,@CUR_SCM_SITE_ID
	--		,@CUR_MAPPING_ITEM_ID		

	--	WHILE @@FETCH_STATUS = 0
	--	BEGIN
	--		IF @CUR_MAPPING_ITEM_ID <> '' --MAPPING_ITEM_ID 값이 있을 경우만 처리
	--		BEGIN
	--			SET @VALID_ITEM_ID = NULL

	--			SET @VALID_ITEM_ID =
	--			(
	--				SELECT TOP 1 A.TOKEN
	--					FROM (SELECT * from dbo.UF_FX_STRING_SPLIT(@CUR_MAPPING_ITEM_ID, '$')) A
	--					where NOT EXISTS (SELECT  ITEM.division_id  
	--										FROM dbo.scm_mst_site_item ITEM WITH(NOLOCK)
	--											,dbo.SCM_MST_ITEM_SN SN WITH(NOLOCK)  -- 2022.01.20
	--										where 1=1
 --												and ITEM.division_id   = @P_DIVISION_ID
	--											and ITEM.PROJECT_CODE  = @CUR_PROJECT_CODE
	--											and ITEM.scm_site_id   = @CUR_SCM_SITE_ID
	--											and ITEM.ITEM_ID       = A.TOKEN --$로 구분한 값
	--											and ITEM.division_id   = SN.division_id
	--											and ITEM.ITEM_ID       = SN.ITEM_ID
	--											and SN.ACTIVE_FLAG = 'Y'
	--											AND ITEM.VALID_YN = 'Y'
	--										)
	--			)

	--			-------------------------------------------------------------------◎◎◎◎
	--			IF @VALID_ITEM_ID IS NOT NULL
	--			BEGIN
	--				SET @v_log_type = 'INVALID';
	--				--SELECT '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
	--				SET @v_description = '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
	--				goto err_rtn
	--			END
	--			-------------------------------------------------------------------◎◎◎◎

	--		END


	--	FETCH NEXT FROM CUR_VALIDMAPPING_LIST INTO 		
	--		 @CUR_PROJECT_CODE		
	--		,@CUR_SCM_SITE_ID
	--		,@CUR_MAPPING_ITEM_ID		
	--	END
	
	--	CLOSE CUR_VALIDMAPPING_LIST;
	--	DEALLOCATE CUR_VALIDMAPPING_LIST;
	--END


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                              ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	--SELECT DATA_TYPE_CODE
	--	,  COMPANY_ID
	--	, SOLDTO_CODE
	--	, SHIPTO_CODE
	--	, UNLOADING_POINT
	--	, CUSTOMER_PLANT
	--	, CUSTOMER_ITEM_ID
	--	, END_CUSTOMER
	--	, SCM_SITE_ID
	--	, PROJECT_CODE
	--	, FCST_TYPE
	--	,  INCOTERMS
	--	,  DOM_EXP	
	--	,  ITEM_ID
	--	, MAPPING_ITEM_ID
	--	, MAPPING_ITEM_ID_ORIGINAL
	--	,  VALID_FROM
	--	,  VALID_TO
	--	,  ACTIVE_YN
	--	,  ACT_TYPE
	--	FROM #T_MAIN

	--SELECT * FROM DM_CUST_MODEL_MAPPING_M WHERE DATA_TYPE_CODE = 'SCM' AND DIVISION_ID = '81'

	--SELECT * FROM DM_CUST_MODEL_MAPPING_M A
	--INNER JOIN #T_MAIN B
	--ON 		       A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
	--	   AND A.DIVISION_ID = @P_DIVISION_ID
	--	   AND A.COMPANY_ID = B.COMPANY_ID
	--	   AND A.SOLDTO_CODE = B.SOLDTO_CODE
	--	   AND A.SHIPTO_CODE = B.SHIPTO_CODE
	--	   AND ISNULL(LTRIM(RTRIM(A.UNLOADING_POINT)),'') = ISNULL(LTRIM(RTRIM(B.UNLOADING_POINT)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
	--	   AND ISNULL(LTRIM(RTRIM(A.CUSTOMER_PLANT)),'') = ISNULL(LTRIM(RTRIM(B.CUSTOMER_PLANT)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
	--	   AND ISNULL(LTRIM(RTRIM(A.CUSTOMER_ITEM_ID)),'') = ISNULL(LTRIM(RTRIM(B.CUSTOMER_ITEM_ID)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
	--	   --AND A.END_CUSTOMER = B.END_CUSTOMER
	--	   AND A.SCM_SITE_ID = B.SCM_SITE_ID
	--	   AND A.PROJECT_CODE = B.PROJECT_CODE
	--	   AND A.FCST_TYPE = B.FCST_TYPE
	--	   AND A.INCOTERMS = B.INCOTERMS
	--	   AND A.DOM_EXP = B.DOM_EXP
	--	   AND A.ITEM_ID = B.ITEM_ID
	--	   AND A.MAPPING_ITEM_ID = B.MAPPING_ITEM_ID_ORIGINAL

	--MASTER 처리
		MERGE INTO DM_CUST_MODEL_MAPPING_M AS A
		USING #T_MAIN AS B
		   ON (
		       A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
		   AND A.DIVISION_ID = @P_DIVISION_ID
		   AND A.COMPANY_ID = B.COMPANY_ID
		   AND A.SOLDTO_CODE = B.SOLDTO_CODE
		   AND A.SHIPTO_CODE = B.SHIPTO_CODE
		   AND ISNULL(LTRIM(RTRIM(A.UNLOADING_POINT)),'')  = ISNULL(LTRIM(RTRIM(B.UNLOADING_POINT)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
		   AND ISNULL(LTRIM(RTRIM(A.CUSTOMER_PLANT)),'')   = ISNULL(LTRIM(RTRIM(B.CUSTOMER_PLANT)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
		   AND ISNULL(LTRIM(RTRIM(A.CUSTOMER_ITEM_ID)),'') = ISNULL(LTRIM(RTRIM(B.CUSTOMER_ITEM_ID)),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
		   --AND A.END_CUSTOMER = B.END_CUSTOMER
		   AND A.SCM_SITE_ID = B.SCM_SITE_ID
		   AND A.PROJECT_CODE = B.PROJECT_CODE
		   AND A.FCST_TYPE = B.FCST_TYPE
		   AND A.INCOTERMS = B.INCOTERMS
		   AND A.DOM_EXP = B.DOM_EXP
		   AND A.ITEM_ID = B.ITEM_ID
		   AND A.MAPPING_ITEM_ID = B.MAPPING_ITEM_ID_ORIGINAL
		   AND B.ACT_TYPE = 'M'
		   --AND A.UNLOADING_POINT = B.UNLOADING_POINT--PK 추가
		   --AND A.CUSTOMER_PLANT = B.CUSTOMER_PLANT--PK 추가
		   --AND A.CUSTOMER_ITEM_ID = B.CUSTOMER_ITEM_ID--PK 추가
		   )
		 WHEN MATCHED THEN
		   UPDATE SET 
			   A.VALID_START_DATE = B.VALID_FROM
			  ,A.VALID_END_DATE   = B.VALID_TO
			  ,A.ACTIVE_YN        = B.ACTIVE_YN
			  ,A.MAPPING_ITEM_ID  = B.MAPPING_ITEM_ID
			  ,A.LAST_UPDATED_BY = @P_USER_ID
			  ,A.LAST_UPDATE_DATE = GETDATE()
		 WHEN NOT MATCHED THEN
		   INSERT           
				(
					 DATA_TYPE_CODE
					,DIVISION_ID
					,COMPANY_ID
					,SOLDTO_CODE
					,SHIPTO_CODE
					,UNLOADING_POINT
					,CUSTOMER_PLANT
					,CUSTOMER_ITEM_ID
					,END_CUSTOMER
					,SCM_SITE_ID
					,PROJECT_CODE
					,FCST_TYPE
					,INCOTERMS
					,DOM_EXP
					,ITEM_ID
					,MAPPING_ITEM_ID
					,VALID_START_DATE
					,VALID_END_DATE
					,ACTIVE_YN 
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
			   )
		   VALUES
	   			(
				    B.DATA_TYPE_CODE
				   ,@P_DIVISION_ID
				   ,B.COMPANY_ID
				   ,B.SOLDTO_CODE
				   ,B.SHIPTO_CODE
				   ,ISNULL(LTRIM(RTRIM(B.UNLOADING_POINT)),'')
				   ,ISNULL(LTRIM(RTRIM(B.CUSTOMER_PLANT)),'')
				   ,ISNULL(LTRIM(RTRIM(B.CUSTOMER_ITEM_ID)),'')
				   ,B.END_CUSTOMER
				   ,B.SCM_SITE_ID
				   ,B.PROJECT_CODE
				   ,B.FCST_TYPE
				   ,B.INCOTERMS
				   ,B.DOM_EXP
				   ,B.ITEM_ID
				   ,B.MAPPING_ITEM_ID
				   ,B.VALID_FROM
				   ,B.VALID_TO
				   ,B.ACTIVE_YN
				   ,@P_USER_ID
				   ,GETDATE()
				   ,@P_USER_ID
				   ,GETDATE()	
			   )
		;

	SET @ROWCNT = @@ROWCOUNT

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환
	SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN

			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;

-- 트랜잭션 (END)
err_rtn:
IF @v_log_type = 'INVALID'
	begin
		--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드, 결과 카운트 반환
		SELECT  'F' AS result_code,  @v_description AS result_msg ;
	end

END





