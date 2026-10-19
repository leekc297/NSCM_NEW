


/*  
 * Program ID   : PR_DM_DNM_SALES_RESULT_IF  
 * Description  : 매출 정보 I/F   
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.09.10   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2018.09.17   Kim Jihye      Sales Site Mapping 시 site_type 이 SALES 인 Site 만 Mapping 하도록 로직 수정  
 * 18-11-08     ytChoi         Modifieyd  상품에 대해서 pack 대표 코드를 찾지 못해서 변경 함  
 * 20190121		KHSONG		날짜 조건을 같은달내에서만 실적과 비교하여 fcst_type을 못찾는경우를 줄임  
 * 20190125     KHSONG         국내 ERP 매출 Data의 Currency정보중 CNY -> RMB 로 전환  
 * 20190307     JSYOUN         [C20190306_40879]BMZ VMI 실적 반영 조건 변경의 건  
 * 20190607     JSYOUN         [CSR ID:4001986] FCST type과 실적 Type 매칭 로직 개선 | [요청번호]C20190524_01986 | [서비스번호]4001986   
 * 20190620		KHSONG		ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완  
 * 20200207     KHSONG         C20200131-000350 매출실적MAPPING 오류로 INCOTERMS 추가함  
 * 20200729		hwi1993   과제 - ESS 실적매핑 내부거래 예외 처리  
 * 20200925  P.C.I     [C20200921-000297] 자동차 사업부에 MKT FCST에 FCST_TYPE이 2개 이상이거나, 없는 경우 MASS로 적용 
 * 20201204		hwi1993			전지분사 - B100 을 그대로 Sales Site 로 처리하는 문제 수정
 * 20201205		kuniid			[C20201103-000150] [SCM PI팀] ERP 개선항목 8번에 대한 I/F 개선 - SO 번호를 SSP 와 연동
 * 20201218		HWI1993			[C20201103-000150] [SCM PI팀] ERP 개선항목 8번에 대한 I/F 개선 - 기본통화 외의 통화 처리
 * 20210201		kuniid			[C20210201-000116] DOC_AMT_FOR, DOC_AMT_KRW - 금액 SUM 하는 부분 추가
								[C20210201-000116] 해외법인 원화(Company id가 'G'로 시작)는 DOC_AMT_KRW 대신 sales_amount_sum 사용
 * 2021.02.09	P.C.I 		    [C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
 * 2021.03.17	kuniid			[C20210315-000140] Sales Report 통화 컬럼 Null값으로 표기되는 오류 수정 요청의 건
 * 2021.03.19	hwi1993			[C20210316-000434] [SCM PI팀] ERP -> GSCM I/F 시, FCST Type 이 GSCM 기준으로 UPDATE 
 * 2021.03.22	hwi1993			[C20210316-000434] 데이터 문제로 Sales_type_2 외에 기존 Sales_type_2 값을 attribute1 에 추가로 받음
								Attribute1 은 이 프로시저에서만 사용함. 다음 테이블로 이동 안함. - attribute1 적용은 일주일 연기함.
 * 2021.03.24	hwi1993			[C20210323-000369] [SCM PI팀] GSCM 기준 FCST Type 별 매출 실적 구분	-- attribute1 다시 살림
 * 2021.05.18	hwi1993			[C20210506-000350] 마케팅 CO 매출 반영 요청의 건
 * 2021.10.25	hwi1993			소형 반품건 데이터 생성
 * 2021.11.15	kdw2819			[C20211013-000459] GSCM 반품 오더 ERP 동일 환율 적용 요청의 건
 * 2022.04.14   hwi1993         GM JV 작업
 * 2022.05.18	kdw2819			[C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
 * 2022.06.27	kdw2819			[과제] 리콜 무상매출 수량 I/F, 룩업테이블 관리 연계
   2022.07.26	HWI1993			[과제] 리콜 무상매출 수량 I/F, 룩업테이블 관리 연계 - ATTRIBUTE2 추가
   2022.08.18	HWI1993			[과제] 리콜 무상매출 수량 I/F, 룩업테이블 관리 연계 - ATTRIBUTE2 추가, 룩업에 등록된 모델만 ATTR2 사용
   2023.10.12	JSSBAE			[E20230927-000826]SCM.DM 실적 매핑 Sold to, Ship to 코드 외 COMPANY_ID 추가
								(반영이유: SOLDTO, SHIPTO가 같다는 이유로 DIVISION_ID를 업데이트 하다보니, 잘못된 매핑이 발생하여, COMPANY_ID까지 동일한 부분만 업데이트 하도록 조건 추가)

   2024.04.25   HMIN 			[E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경
								- 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영
								- 적용시점기준 : 82번 사업부 LGESVT_US_BOS 의 G810 매출에 한함.
   2024.05.29	P.C.I			[PJ20228272] NERP 하드코딩 대응 및 개선
   2024.08.16	P.C.I			[E20240814-000938]_MKT FCST 컷오프 수행 변경 및 매출실적 수신 속도개선
   2025.01.07	JSSBAE			[PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 (12월데이터를 모두 받은 시점에는 삭제할 로직)
   2025.02.13   JSSBAE			[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치
   2025.06.23   KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
   2025.06.30   JSSBAE          [IT20250117A] NERP 오픈차수별 Mapping Code적용
   2025.10.21   김준규			[IT20250117A] RMB를 CNY로 Currency변경
   2026.06.18   JSSBAE          [E20260615-000248]_ERP 실적 데이터 Mapping 로직 개선
   --exec [PR_DM_DNM_SALES_RESULT_IF]
 */  
  

CREATE PROCEDURE [dbo].[PR_DM_DNM_SALES_RESULT_IF]  
AS  
BEGIN  
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	SET NOCOUNT ON;   
	SET XACT_ABORT ON;  
  
  
	-- LOG 용 변수 설정  
	DECLARE @v_batch_user    NVARCHAR(150) = 'scm_batch';  
	DECLARE @v_program_name  NVARCHAR(150) = 'PR_DM_DNM_SALES_RESULT_IF';  
	DECLARE @v_log_type      NVARCHAR(30); -- START/END/ERROR/...  
	DECLARE @n_log_count     INTEGER = 0;  
	DECLARE @v_log_message   NVARCHAR(1000);  
	DECLARE @v_description   NVARCHAR(500);  
	DECLARE @d_event_date    DATETIME;  
	DECLARE @v_ifseqno       NVARCHAR(30);  
	DECLARE @v_yyyymmdd_from NVARCHAR(8);  
	DECLARE @v_yyyymmdd_to   NVARCHAR(8);  
	DECLARE @n_history_seq   BIGINT;  
  
	--[E20240814-000938] Batch Event Date에 Start Date를 넣어서 실제 실행된 시간 비교
    DECLARE @d_start_date   DATETIME = SYSDATETIME();
  
	--[E20240814-000938] 변경이 발생하는 Row Count 확인
	DECLARE @n_update_cnt   INT = 0;

-----------------------------------------------------------  
-- TEMP TABLE : XIF GROUPING (2020.12.01)  
-----------------------------------------------------------  
  
	-- 시작 LOG  
	SET @v_log_type    = 'START';  
	SET @v_log_message = '########## Start of procedure ##########';  
	SET @v_description = '';  
	SET @d_event_date  = SYSDATETIME();  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	BEGIN TRY  
        

PRINT 'start:' + CONVERT(NVARCHAR(50), GETDATE(), 121)

		UPDATE xif_erp_sales_result_r_sn   
		SET    transfer_flag = 'P'  
		WHERE  transfer_flag IS NULL  
		OR  transfer_flag = 'N'  
		;  
		
		SET @n_update_cnt = @@ROWCOUNT; --[E20240814-000938] Row Count 확인(Update TRANSFER_FLAG to P)

		--[E20240814-000938] 시간소요 확인위해 LOG 삽입 추가 
		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = N'Update TRANSFER_FLAG to P';  
		SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
		
	--[E20240814-000938] Start 'JOB_RFC.매출 실적 정보'에 있는 업데이트 구문이 아직 필요한지 확인을 위해 소스에 업데이트 함 START
	/* 일주일 모니터링한 결과 업데이트 대상 데이터가 더이상 유입되지 않는 건으로 확인되어 주석처리 진행함 20240827 
	BEGIN 
		/*
		2020.12.09 ERP 실적이 G260으로 계속 들어와서 해당 코드를 업데이트함 
		G260 실적이 완전히 없어진 후에 제거 */
		SET @n_update_cnt = 0;

		UPDATE XIF_ERP_SALES_RESULT_R_SN
		SET COMPANY_ID = 'G690'
		WHERE TRANSFER_FLAG = 'P'
		AND COMPANY_ID = 'G260'
		
		SET @n_update_cnt = @@ROWCOUNT; 

		UPDATE XIF_ERP_SALES_RESULT_R_SN
		SET SHIPTO_CODE = 'G690'
		WHERE TRANSFER_FLAG = 'P'
		AND SHIPTO_CODE = 'G260'
		
		SET @n_update_cnt = @n_update_cnt +  @@ROWCOUNT;
	
		UPDATE XIF_ERP_SALES_RESULT_R_SN
		SET CUSTOMER_CODE = 'G690'
		WHERE TRANSFER_FLAG = 'P'
		AND CUSTOMER_CODE = 'G260'
		
		SET @n_update_cnt = @n_update_cnt +  @@ROWCOUNT;  
	
		--[E20240814-000938] 시간소요 확인위해 LOG 삽입 추가 
		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = 'Update XIF_ERP_SALES_RESULT_R_SN to G690';  
		SET @v_description = 'Check Time';  
		SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
		SET @n_log_count = 0;
	END
	*/
	--[E20240814-000938] Start 'JOB_RFC.매출 실적 정보'에 있는 업데이트 구문이 아직 필요한지 확인을 위해 소스에 업데이트 함 END
  
    -----------------------------------------------------------  
    -- TEMP TABLE : XIF GROUPING (2020.12.01)   [C20201103-000150]
    -----------------------------------------------------------  
	--20240610 SM임시조치
	BEGIN 
		IF OBJECT_ID (N'tempdb..#XIF_ERP_SALES_RESULT_R_SN_TMP', N'U') IS NOT NULL 
		   DROP TABLE #XIF_ERP_SALES_RESULT_R_SN_TMP
		   
		 --[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP Temp 생성
		IF OBJECT_ID (N'tempdb..#XIF_SALES_RESULT_TRANSFER_P_TMP', N'U') IS NOT NULL 
		   DROP TABLE #XIF_SALES_RESULT_TRANSFER_P_TMP
		   		   
		 --[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_SO_NO_TMP Temp 생성
		IF OBJECT_ID (N'tempdb..#XIF_SALES_RESULT_SO_NO_TMP', N'U') IS NOT NULL 
		   DROP TABLE #XIF_SALES_RESULT_SO_NO_TMP

		 --[E20240814-000938] 속도개선을 위해 #SSP_ANL_SHIP_CONFIRM_TMP Temp 생성
		IF OBJECT_ID (N'tempdb..#SSP_ANL_SHIP_CONFIRM_TMP', N'U') IS NOT NULL 
		   DROP TABLE #SSP_ANL_SHIP_CONFIRM_TMP

		 --[E20240814-000938] 속도개선을 위해 #TEMP_DM_MST_ITEM_SINGLE_V 생성
		IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		
			DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
	END 
		
	--[E20240814-000938] 속도개선을 위해 #TEMP_DM_MST_ITEM_SINGLE_V 생성 START
	BEGIN 	
		SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE
			 , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE
			 , ENERGE, CELL_QUANTITY 
		INTO #TEMP_DM_MST_ITEM_SINGLE_V
		FROM 
		(
			SELECT	T1.DIVISION_ID,
					T1.ITEM_ID, 
					MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
					case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
									when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
									when T1.item_type = 'Q' then 3
									else 4 end )  
													when 1 then 'P' 
													when 2 then 'H'
													when 3 then 'Q'
													else 'R' end	AS ITEM_TYPE,
					MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
					MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
					MAX(T1.SPEC								)		AS SPEC,
					MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
					MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
					MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
					MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
					MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
					MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
					MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
					MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
					MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
					MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
					MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
					MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
					MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
				FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
				INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
								, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
								, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
								, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
								, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
								, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
								, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
								, MAX(CELL_TYPE) AS CELL_TYPE
							FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK) 
							GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
						) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
					AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
				where 1=1
				--WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
				--LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
				group by T1.DIVISION_ID, T1.ITEM_ID	
		) T2		
		GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
				,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY
	END 
	--[E20240814-000938] 속도개선을 위해 #TEMP_DM_MST_ITEM_SINGLE_V 생성 END
	
	--[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP Temp 생성 START
	BEGIN 	

		SELECT *, REPLICATE('0', 10-LEN(RTRIM(XIF.SO_NO))) + RTRIM(XIF.SO_NO) AS ERP_SO_NO
		INTO   #XIF_SALES_RESULT_TRANSFER_P_TMP
		FROM   XIF_ERP_SALES_RESULT_R_SN XIF WITH(NOLOCK)  
		WHERE  sales_posting_date >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
		AND    transfer_flag = 'P'  
		;

		SET @n_update_cnt = @@ROWCOUNT;
			
		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = 'INSERT INTO #XIF_SALES_RESULT_TRANSFER_P_TMP';  
		SET @v_description = 'Check Time';
		SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
		
		--[E20240814-000938] 속도개선을 위해 #SSP_ANL_SHIP_CONFIRM_TMP Temp 생성
		SELECT DIVISION_ID, ERP_SO_NO, MAX(TO_SITE) AS TO_SITE
		INTO   #SSP_ANL_SHIP_CONFIRM_TMP
		FROM   SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
		WHERE  ERP_SO_NO IS NOT NULL
		--AND    ERP_SO_NO LIKE '00%'
		GROUP BY DIVISION_ID, ERP_SO_NO 

		SET @n_update_cnt = @@ROWCOUNT;

		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = 'INSERT INTO #SSP_ANL_SHIP_CONFIRM_TMP';  
		SET @v_description = 'Check Time';  
		SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
		
	END 
	--[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP Temp 생성 END

	
	--[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_SO_NO_TMP 생성 START
	BEGIN 		
		SELECT  company_id  
			,XIF.division_id  
			,sales_type  
			,sales_dept  
			,sales_work_place  
			,sales_work_place_name  
			,sales_group  
			,sales_group_name  
			,sales_posting_date  
			,cost_item  
			,cost_item_name  
			,sales_type_2  
			,valuation_class  
			,item_type  
			,customer_code  
			,customer_name  
			,customer_project_name  
			,customer_item_name  
			,XIF.biz_type AS biz_type  
			,XIF.project_code as project_code
			,project_name --as origin_project_name  
			,cell_type  
			,car_model  
			,qty_cell_by_pack  
			,z_type  
			,z_code  
			,sales_region  
			,distribution_channel  
			,lgs_route_name  
			,connect_name  
			,car_qty  
			,cell_qty  
			,sales_price  
			, currency -- ,CASE WHEN currency = 'CNY' THEN 'RMB' ELSE currency END AS currency  -- 20190125 KHSONG 국내 ERP 매출 Data의 Currency정보중 CNY -> RMB 로 전환  
			,SUM(sales_amount_for) AS SALES_AMOUNT_FOR  
			,SUM(sales_amount_sum) AS SALES_AMOUNT_SUM  
			,uom  
			,SUM( CASE WHEN B.AS_ITEM IS NOT NULL AND SALES_QTY = 0 AND ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS NUMERIC(20,10))
						ELSE SALES_QTY
						END ) AS SALES_QTY
			,SUM( CASE WHEN B.AS_ITEM IS NOT NULL AND SALES_QTY = 0 AND ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS NUMERIC(20,10))
						ELSE SALES_QTY
						END ) AS SO_QTY --[C20210225-000385] SO_QTY 추가, 2022.08.18 LOOKUP 에 등록된 모델만 ATTR2 사용
			,sales_user  
			,sales_user_name  
			,mat_group  
			,mat_group_desc  
			,XIF.item_id  AS item_id  --as origin_item_id  
			,biz_type_2  
			,app  
			,usage  
			,sales_team  
			,ess_pm  
			,plant_id  
			,shipto_code  
			,shipto_description  
			,country  
			,country_name  
			,shipto_city_name  
			,shipto_zone_code  
			,shipto_zone_name  
			,rbu_customer  
			,XIF.incoterms AS incoterms   --as origin_incoterms  
			,profit_center_id  
			,profit_center_name  
			,partner_profit_center_id  
			,partner_profit_center_name  
			,item_text  
			,affiliate_code  
			,customer_group_code  
			,customer_group_name  
			,cell_code  
			,delegate_model_id  
			,delegate_model_name  
			,c_p_model_id  
			,c_p_model_name  
			,lrregular_code  
			,lrregular_name  
			,machine_code  
			,machine_name  
			,line_id  
			,line_name  
			,tco  
			,system_input_date  
			,system_input_time         
			,ifseqno  
			,transfer_flag  
			,result_yyyymm  
			, SUM( ISNULL( CASE WHEN (ISNULL(SSP.ERP_SO_NO,'')<>'') THEN SALES_QTY ELSE 0 END ,0) ) AS ATTRIBUTE3 
			, MAX(SSP.TO_SITE) AS ATTRIBUTE4
			, DOC_CURRENCY
			, SUM(DOC_AMT_FOR) AS DOC_AMT_FOR -- [C20210201-000116]
			, SUM(DOC_AMT_KRW) AS DOC_AMT_KRW -- [C20210201-000116]
			, SO_NO
			/*
			--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START 
			--주석처리
			, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY company_id ,XIF.division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name ,sales_group  ,sales_group_name  
											,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  ,item_type  ,customer_code  ,customer_name  
											,customer_project_name  ,customer_item_name  ,XIF.biz_type,XIF.project_code,project_name,cell_type  ,car_model  ,qty_cell_by_pack  
											,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  , currency 
											,uom  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,XIF.item_id,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  
											,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  
											,XIF.incoterms,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  
											,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  
											,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time         
											,ifseqno  ,transfer_flag  ,result_yyyymm  , DOC_CURRENCY ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
			, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY company_id ,XIF.division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  ,sales_group_name  
											,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  ,item_type  ,customer_code  ,customer_name  
											,customer_project_name  ,customer_item_name  ,XIF.biz_type,XIF.project_code,project_name,cell_type  ,car_model  ,qty_cell_by_pack  
											,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  , currency 
											,uom  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,XIF.item_id,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  
											,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  
											,XIF.incoterms,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  
											,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  
											,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time         
											,ifseqno  ,transfer_flag  ,result_yyyymm  , DOC_CURRENCY ORDER BY SO_NO) AS NVARCHAR(1000)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
			--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
			*/
			, ATTRIBUTE1	-- [C20210316-000434]
		--[E20240814-000938] Start 속도 개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP, #SSP_ANL_SHIP_CONFIRM_TMP 으로 변경
		/*FROM  XIF_ERP_SALES_RESULT_R_SN XIF WITH(NOLOCK)  
		LEFT OUTER JOIN (   
			SELECT ERP_SO_NO, MAX(TO_SITE) AS TO_SITE, DIVISION_ID 
			--FROM SSP_ANL_SHIP_CONFIRM
			FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)  
			WHERE ERP_SO_NO IS NOT NULL
			GROUP BY ERP_SO_NO, DIVISION_ID
		) SSP ON SSP.ERP_SO_NO = REPLICATE('0', 10-LEN(RTRIM(XIF.SO_NO))) + RTRIM(XIF.SO_NO) AND SSP.DIVISION_ID = XIF.DIVISION_ID  */
		   , XIF.FROM_COMPANY_ID, XIF.FROM_SELL_DOC, XIF.FROM_SHIP_NO 			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		INTO #XIF_SALES_RESULT_SO_NO_TMP
		FROM #XIF_SALES_RESULT_TRANSFER_P_TMP XIF WITH(NOLOCK)
		LEFT OUTER JOIN #SSP_ANL_SHIP_CONFIRM_TMP SSP
		ON   SSP.DIVISION_ID = XIF.DIVISION_ID
		AND  SSP.ERP_SO_NO   = XIF.ERP_SO_NO
		--[E20240814-000938] End 속도 개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP, #SSP_ANL_SHIP_CONFIRM_TMP 으로 변경
		LEFT OUTER JOIN (	SELECT DISTINCT SEGMENT2 AS AS_ITEM
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
							WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
								AND VALID_YN		= N'Y'
							UNION 
							SELECT DISTINCT SEGMENT3 AS AS_ITEM
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
							WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
								AND VALID_YN		= N'Y'
							) B ON XIF.ITEM_ID = B.AS_ITEM
		WHERE  1=1   
		--ifseqno       = @v_ifseqno  -- [C20201103-000150]
		-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
		--AND sales_posting_date >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01' --[E20240814-000938] 속도 개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP 으로 변경
		-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
		--AND     transfer_flag = 'P'  --[E20240814-000938] 속도 개선을 위해 #XIF_SALES_RESULT_TRANSFER_P_TMP 으로 변경
		
		GROUP BY  company_id,XIF.division_id,sales_type,sales_dept,sales_work_place,sales_work_place_name,sales_group,sales_group_name,sales_posting_date
			,cost_item,cost_item_name,sales_type_2,valuation_class,item_type,customer_code,customer_name,customer_project_name,customer_item_name,XIF.biz_type
			,XIF.project_code,project_name,cell_type,car_model,qty_cell_by_pack,z_type,z_code,sales_region,distribution_channel,lgs_route_name,connect_name
			,car_qty,cell_qty,sales_price,currency,uom,sales_user,sales_user_name,mat_group,mat_group_desc,XIF.item_id,biz_type_2,app,usage,sales_team
			,ess_pm,plant_id,shipto_code,shipto_description,country,country_name,shipto_city_name,shipto_zone_code,shipto_zone_name,rbu_customer,XIF.incoterms
			,profit_center_id,profit_center_name,partner_profit_center_id,partner_profit_center_name,item_text,affiliate_code,customer_group_code,customer_group_name
			,cell_code,delegate_model_id,delegate_model_name,c_p_model_id,c_p_model_name,lrregular_code,lrregular_name,machine_code,machine_name,line_id,line_name
			,tco,system_input_date,system_input_time,ifseqno,transfer_flag,result_yyyymm  
			, DOC_CURRENCY, SO_NO
			, ATTRIBUTE1
		    , XIF.FROM_COMPANY_ID, XIF.FROM_SELL_DOC, XIF.FROM_SHIP_NO 			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			
		SET @n_update_cnt = @@ROWCOUNT; --[E20240814-000938] Row Count 확인(#XIF_SALES_RESULT_SO_NO_TMP)

		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = 'INSERT INTO #XIF_SALES_RESULT_SO_NO_TMP';  
		SET @v_description = 'Check Time';  
		SET @d_event_date  = @d_start_date;
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
		
	END
	--[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_SO_NO_TMP 생성 END


    -- #XIF_ERP_SALES_RESULT_R_SN_TMP 에 넣는 구문
    BEGIN
		--[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
		SELECt company_id  
			,division_id  
			,sales_type  
			,sales_dept  
			,sales_work_place  
			,sales_work_place_name  
			,sales_group  
			,sales_group_name  
			,sales_posting_date  
			,cost_item  
			,cost_item_name  
			,sales_type_2  
			,valuation_class  
			,item_type  
			,customer_code  
			,customer_name  
			,customer_project_name  
			,customer_item_name  
			,biz_type  
			,project_code
			,project_name
			,cell_type  
			,car_model  
			,qty_cell_by_pack  
			,z_type  
			,z_code  
			,sales_region  
			,distribution_channel  
			,lgs_route_name  
			,connect_name  
			,car_qty  
			,cell_qty  
			,sales_price  
			, currency
			,SUM(sales_amount_for) AS SALES_AMOUNT_FOR  
			,SUM(sales_amount_sum) AS SALES_AMOUNT_SUM  
			,uom  
			,SUM(sales_qty) AS sales_qty  
			,sales_user  
			,sales_user_name  
			,mat_group  
			,mat_group_desc  
			,item_id
			,biz_type_2  
			,app  
			,usage  
			,sales_team  
			,ess_pm  
			,plant_id  
			,shipto_code  
			,shipto_description  
			,country  
			,country_name  
			,shipto_city_name  
			,shipto_zone_code  
			,shipto_zone_name  
			,rbu_customer  
			,incoterms
			,profit_center_id  
			,profit_center_name  
			,partner_profit_center_id  
			,partner_profit_center_name  
			,item_text  
			,affiliate_code  
			,customer_group_code  
			,customer_group_name  
			,cell_code  
			,delegate_model_id  
			,delegate_model_name  
			,c_p_model_id  
			,c_p_model_name  
			,lrregular_code  
			,lrregular_name  
			,machine_code  
			,machine_name  
			,line_id  
			,line_name  
			,tco  
			,system_input_date  
			,system_input_time         
			,ifseqno  
			,transfer_flag  
			,result_yyyymm  
			, SUM(ATTRIBUTE3) AS ATTRIBUTE3 
			, MAX(ATTRIBUTE4) AS ATTRIBUTE4
			, DOC_CURRENCY
			, SUM(DOC_AMT_FOR) AS DOC_AMT_FOR -- [C20210201-000116]
			, SUM(DOC_AMT_KRW) AS DOC_AMT_KRW -- [C20210201-000116]
			/*[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START */
		    , STUFF((SELECT ',' + SO_NO 
					FROM #XIF_SALES_RESULT_SO_NO_TMP B WITH(NOLOCK)
					WHERE A.company_id = B.company_id AND A.division_id = B.division_id	AND A.sales_type = B.sales_type
					AND A.sales_dept = B.sales_dept	AND A.sales_work_place = B.sales_work_place	AND A.sales_work_place_name = B.sales_work_place_name	
					AND A.sales_group = B.sales_group AND A.sales_group_name = B.sales_group_name AND A.sales_posting_date = B.sales_posting_date	  
					AND A.cost_item = B.cost_item AND A.cost_item_name = B.cost_item_name AND A.sales_type_2 = B.sales_type_2	  
					AND A.valuation_class = B.valuation_class AND A.item_type = B.item_type	AND A.customer_code = B.customer_code	  
					AND A.customer_name = B.customer_name AND A.customer_project_name = B.customer_project_name	AND A.customer_item_name = B.customer_item_name	 
					AND A.biz_type = B.biz_type AND A.project_code = B.project_code	AND A.project_name = B.project_name	 
					AND A.cell_type = B.cell_type AND A.car_model = B.car_model	AND A.qty_cell_by_pack = B.qty_cell_by_pack	 
					AND A.z_type = B.z_type AND A.z_code = B.z_code	AND A.sales_region = B.sales_region	 
					AND A.distribution_channel = B.distribution_channel AND A.lgs_route_name = B.lgs_route_name	AND A.connect_name = B.connect_name	 
					AND A.car_qty = B.car_qty AND A.cell_qty = B.cell_qty AND A.sales_price = B.sales_price	 
					AND A.currency = B.currency AND A.uom = B.uom AND A.sales_user = B.sales_user	 
					AND A.sales_user_name = B.sales_user_name AND A.mat_group = B.mat_group AND A.mat_group_desc = B.mat_group_desc	 
					AND A.item_id = B.item_id AND A.biz_type_2 = B.biz_type_2 AND A.app = B.app	 
					AND A.usage = B.usage AND A.sales_team = B.sales_team AND A.ess_pm = B.ess_pm	 
					AND A.plant_id = B.plant_id AND A.shipto_code = B.shipto_code AND A.shipto_description = B.shipto_description	
					AND A.country = B.country AND A.country_name = B.country_name AND A.shipto_city_name = B.shipto_city_name	
					AND A.shipto_zone_code = B.shipto_zone_code AND A.shipto_zone_name = B.shipto_zone_name AND A.rbu_customer = B.rbu_customer	
					AND A.incoterms = B.incoterms AND A.profit_center_id = B.profit_center_id AND A.profit_center_name = B.profit_center_name	
					AND A.partner_profit_center_id = B.partner_profit_center_id AND A.partner_profit_center_name = B.partner_profit_center_name AND A.item_text = B.item_text	
					AND A.affiliate_code = B.affiliate_code AND A.customer_group_code = B.customer_group_code AND A.customer_group_name = B.customer_group_name	
					AND A.cell_code = B.cell_code AND A.delegate_model_id = B.delegate_model_id AND A.delegate_model_name = B.delegate_model_name	
					AND A.c_p_model_id = B.c_p_model_id AND A.c_p_model_name = B.c_p_model_name AND A.lrregular_code = B.lrregular_code	
					AND A.lrregular_name = B.lrregular_name AND A.machine_code = B.machine_code AND A.machine_name = B.machine_name	
					AND A.line_id = B.line_id AND A.line_name = B.line_name AND A.tco = B.tco	
					AND A.system_input_time = B.system_input_time AND A.system_input_date = B.system_input_date AND A.ifseqno = B.ifseqno	
					AND A.transfer_flag = B.transfer_flag AND A.result_yyyymm = B.result_yyyymm AND A.DOC_CURRENCY = B.DOC_CURRENCY	
					AND A.FROM_COMPANY_ID = B.FROM_COMPANY_ID 					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 
					 FOR XML PATH('')
				), 1, 1, '') AS SO_NO
		    , STUFF((SELECT ',' + CAST(CAST(SO_QTY AS INT) AS VARCHAR)
					FROM #XIF_SALES_RESULT_SO_NO_TMP B WITH(NOLOCK)
					WHERE A.company_id = B.company_id AND A.division_id = B.division_id	AND A.sales_type = B.sales_type
					AND A.sales_dept = B.sales_dept	AND A.sales_work_place = B.sales_work_place	AND A.sales_work_place_name = B.sales_work_place_name	
					AND A.sales_group = B.sales_group AND A.sales_group_name = B.sales_group_name AND A.sales_posting_date = B.sales_posting_date	  
					AND A.cost_item = B.cost_item AND A.cost_item_name = B.cost_item_name AND A.sales_type_2 = B.sales_type_2	  
					AND A.valuation_class = B.valuation_class AND A.item_type = B.item_type	AND A.customer_code = B.customer_code	  
					AND A.customer_name = B.customer_name AND A.customer_project_name = B.customer_project_name	AND A.customer_item_name = B.customer_item_name	 
					AND A.biz_type = B.biz_type AND A.project_code = B.project_code	AND A.project_name = B.project_name	 
					AND A.cell_type = B.cell_type AND A.car_model = B.car_model	AND A.qty_cell_by_pack = B.qty_cell_by_pack	 
					AND A.z_type = B.z_type AND A.z_code = B.z_code	AND A.sales_region = B.sales_region	 
					AND A.distribution_channel = B.distribution_channel AND A.lgs_route_name = B.lgs_route_name	AND A.connect_name = B.connect_name	 
					AND A.car_qty = B.car_qty AND A.cell_qty = B.cell_qty AND A.sales_price = B.sales_price	 
					AND A.currency = B.currency AND A.uom = B.uom AND A.sales_user = B.sales_user	 
					AND A.sales_user_name = B.sales_user_name AND A.mat_group = B.mat_group AND A.mat_group_desc = B.mat_group_desc	 
					AND A.item_id = B.item_id AND A.biz_type_2 = B.biz_type_2 AND A.app = B.app	 
					AND A.usage = B.usage AND A.sales_team = B.sales_team AND A.ess_pm = B.ess_pm	 
					AND A.plant_id = B.plant_id AND A.shipto_code = B.shipto_code AND A.shipto_description = B.shipto_description	
					AND A.country = B.country AND A.country_name = B.country_name AND A.shipto_city_name = B.shipto_city_name	
					AND A.shipto_zone_code = B.shipto_zone_code AND A.shipto_zone_name = B.shipto_zone_name AND A.rbu_customer = B.rbu_customer	
					AND A.incoterms = B.incoterms AND A.profit_center_id = B.profit_center_id AND A.profit_center_name = B.profit_center_name	
					AND A.partner_profit_center_id = B.partner_profit_center_id AND A.partner_profit_center_name = B.partner_profit_center_name AND A.item_text = B.item_text	
					AND A.affiliate_code = B.affiliate_code AND A.customer_group_code = B.customer_group_code AND A.customer_group_name = B.customer_group_name	
					AND A.cell_code = B.cell_code AND A.delegate_model_id = B.delegate_model_id AND A.delegate_model_name = B.delegate_model_name	
					AND A.c_p_model_id = B.c_p_model_id AND A.c_p_model_name = B.c_p_model_name AND A.lrregular_code = B.lrregular_code	
					AND A.lrregular_name = B.lrregular_name AND A.machine_code = B.machine_code AND A.machine_name = B.machine_name	
					AND A.line_id = B.line_id AND A.line_name = B.line_name AND A.tco = B.tco	
					AND A.system_input_time = B.system_input_time AND A.system_input_date = B.system_input_date AND A.ifseqno = B.ifseqno	
					AND A.transfer_flag = B.transfer_flag AND A.result_yyyymm = B.result_yyyymm AND A.DOC_CURRENCY = B.DOC_CURRENCY	
					AND A.FROM_COMPANY_ID = B.FROM_COMPANY_ID 					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 
					 FOR XML PATH('')
				), 1, 1, '') AS SO_QTY				
			--해당 로직 주석처리
			/*
			, ISNULL(MAX([SN1]),'') + CASE WHEN MAX([SN2]) IS NULL THEN '' ELSE ',' + MAX([SN2]) END
				+ CASE WHEN MAX([SN3]) IS NULL THEN '' ELSE ',' + MAX([SN3]) END	+ CASE WHEN MAX([SN4]) IS NULL THEN '' ELSE ',' + MAX([SN4]) END
				+ CASE WHEN MAX([SN5]) IS NULL THEN '' ELSE ',' + MAX([SN5]) END	+ CASE WHEN MAX([SN6]) IS NULL THEN '' ELSE ',' + MAX([SN6]) END
				+ CASE WHEN MAX([SN7]) IS NULL THEN '' ELSE ',' + MAX([SN7]) END	+ CASE WHEN MAX([SN8]) IS NULL THEN '' ELSE ',' + MAX([SN8]) END
				+ CASE WHEN MAX([SN9]) IS NULL THEN '' ELSE ',' + MAX([SN9]) END	+ CASE WHEN MAX([SN10]) IS NULL THEN '' ELSE ',' + MAX([SN10]) END 
				+ CASE WHEN MAX([SN11]) IS NULL THEN '' ELSE ',' + MAX([SN11]) END 	+ CASE WHEN MAX([SN12]) IS NULL THEN '' ELSE ',' + MAX([SN12]) END
				+ CASE WHEN MAX([SN13]) IS NULL THEN '' ELSE ',' + MAX([SN13]) END	+ CASE WHEN MAX([SN14]) IS NULL THEN '' ELSE ',' + MAX([SN14]) END
				+ CASE WHEN MAX([SN15]) IS NULL THEN '' ELSE ',' + MAX([SN15]) END	+ CASE WHEN MAX([SN16]) IS NULL THEN '' ELSE ',' + MAX([SN16]) END
				+ CASE WHEN MAX([SN17]) IS NULL THEN '' ELSE ',' + MAX([SN17]) END	+ CASE WHEN MAX([SN18]) IS NULL THEN '' ELSE ',' + MAX([SN18]) END
				+ CASE WHEN MAX([SN19]) IS NULL THEN '' ELSE ',' + MAX([SN19]) END	+ CASE WHEN MAX([SN20]) IS NULL THEN '' ELSE ',' + MAX([SN20]) END
				+ CASE WHEN MAX([SN21]) IS NULL THEN '' ELSE ',' + MAX([SN21]) END 	+ CASE WHEN MAX([SN22]) IS NULL THEN '' ELSE ',' + MAX([SN22]) END
				+ CASE WHEN MAX([SN23]) IS NULL THEN '' ELSE ',' + MAX([SN23]) END	+ CASE WHEN MAX([SN24]) IS NULL THEN '' ELSE ',' + MAX([SN24]) END
				+ CASE WHEN MAX([SN25]) IS NULL THEN '' ELSE ',' + MAX([SN25]) END	+ CASE WHEN MAX([SN26]) IS NULL THEN '' ELSE ',' + MAX([SN26]) END
				+ CASE WHEN MAX([SN27]) IS NULL THEN '' ELSE ',' + MAX([SN27]) END	+ CASE WHEN MAX([SN28]) IS NULL THEN '' ELSE ',' + MAX([SN28]) END
				+ CASE WHEN MAX([SN29]) IS NULL THEN '' ELSE ',' + MAX([SN29]) END	+ CASE WHEN MAX([SN30]) IS NULL THEN '' ELSE ',' + MAX([SN30]) END 
				+ CASE WHEN MAX([SN31]) IS NULL THEN '' ELSE ',' + MAX([SN31]) END 	+ CASE WHEN MAX([SN32]) IS NULL THEN '' ELSE ',' + MAX([SN32]) END
				+ CASE WHEN MAX([SN33]) IS NULL THEN '' ELSE ',' + MAX([SN33]) END	+ CASE WHEN MAX([SN34]) IS NULL THEN '' ELSE ',' + MAX([SN34]) END
				+ CASE WHEN MAX([SN35]) IS NULL THEN '' ELSE ',' + MAX([SN35]) END	+ CASE WHEN MAX([SN36]) IS NULL THEN '' ELSE ',' + MAX([SN36]) END
				+ CASE WHEN MAX([SN37]) IS NULL THEN '' ELSE ',' + MAX([SN37]) END	+ CASE WHEN MAX([SN38]) IS NULL THEN '' ELSE ',' + MAX([SN38]) END
				+ CASE WHEN MAX([SN39]) IS NULL THEN '' ELSE ',' + MAX([SN39]) END	+ CASE WHEN MAX([SN40]) IS NULL THEN '' ELSE ',' + MAX([SN40]) END 
				+ CASE WHEN MAX([SN41]) IS NULL THEN '' ELSE ',' + MAX([SN41]) END 	+ CASE WHEN MAX([SN42]) IS NULL THEN '' ELSE ',' + MAX([SN42]) END
				+ CASE WHEN MAX([SN43]) IS NULL THEN '' ELSE ',' + MAX([SN43]) END	+ CASE WHEN MAX([SN44]) IS NULL THEN '' ELSE ',' + MAX([SN44]) END
				+ CASE WHEN MAX([SN45]) IS NULL THEN '' ELSE ',' + MAX([SN45]) END	+ CASE WHEN MAX([SN46]) IS NULL THEN '' ELSE ',' + MAX([SN46]) END
				+ CASE WHEN MAX([SN47]) IS NULL THEN '' ELSE ',' + MAX([SN47]) END	+ CASE WHEN MAX([SN48]) IS NULL THEN '' ELSE ',' + MAX([SN48]) END
				+ CASE WHEN MAX([SN49]) IS NULL THEN '' ELSE ',' + MAX([SN49]) END	+ CASE WHEN MAX([SN50]) IS NULL THEN '' ELSE ',' + MAX([SN50]) END 
				+ CASE WHEN MAX([SN51]) IS NULL THEN '' ELSE ',' + MAX([SN51]) END 	+ CASE WHEN MAX([SN52]) IS NULL THEN '' ELSE ',' + MAX([SN52]) END
				+ CASE WHEN MAX([SN53]) IS NULL THEN '' ELSE ',' + MAX([SN53]) END	+ CASE WHEN MAX([SN54]) IS NULL THEN '' ELSE ',' + MAX([SN54]) END
				+ CASE WHEN MAX([SN55]) IS NULL THEN '' ELSE ',' + MAX([SN55]) END	+ CASE WHEN MAX([SN56]) IS NULL THEN '' ELSE ',' + MAX([SN56]) END
				+ CASE WHEN MAX([SN57]) IS NULL THEN '' ELSE ',' + MAX([SN57]) END	+ CASE WHEN MAX([SN58]) IS NULL THEN '' ELSE ',' + MAX([SN58]) END
				+ CASE WHEN MAX([SN59]) IS NULL THEN '' ELSE ',' + MAX([SN59]) END	+ CASE WHEN MAX([SN60]) IS NULL THEN '' ELSE ',' + MAX([SN60]) END 
				+ CASE WHEN MAX([SN61]) IS NULL THEN '' ELSE ',' + MAX([SN61]) END 	+ CASE WHEN MAX([SN62]) IS NULL THEN '' ELSE ',' + MAX([SN62]) END
				+ CASE WHEN MAX([SN63]) IS NULL THEN '' ELSE ',' + MAX([SN63]) END	+ CASE WHEN MAX([SN64]) IS NULL THEN '' ELSE ',' + MAX([SN64]) END
				+ CASE WHEN MAX([SN65]) IS NULL THEN '' ELSE ',' + MAX([SN65]) END	+ CASE WHEN MAX([SN66]) IS NULL THEN '' ELSE ',' + MAX([SN66]) END
				+ CASE WHEN MAX([SN67]) IS NULL THEN '' ELSE ',' + MAX([SN67]) END	+ CASE WHEN MAX([SN68]) IS NULL THEN '' ELSE ',' + MAX([SN68]) END
				+ CASE WHEN MAX([SN69]) IS NULL THEN '' ELSE ',' + MAX([SN69]) END	+ CASE WHEN MAX([SN70]) IS NULL THEN '' ELSE ',' + MAX([SN70]) END 
				+ CASE WHEN MAX([SN71]) IS NULL THEN '' ELSE ',' + MAX([SN71]) END 	+ CASE WHEN MAX([SN72]) IS NULL THEN '' ELSE ',' + MAX([SN72]) END
				+ CASE WHEN MAX([SN73]) IS NULL THEN '' ELSE ',' + MAX([SN73]) END	+ CASE WHEN MAX([SN74]) IS NULL THEN '' ELSE ',' + MAX([SN74]) END
				+ CASE WHEN MAX([SN75]) IS NULL THEN '' ELSE ',' + MAX([SN75]) END	+ CASE WHEN MAX([SN76]) IS NULL THEN '' ELSE ',' + MAX([SN76]) END
				+ CASE WHEN MAX([SN77]) IS NULL THEN '' ELSE ',' + MAX([SN77]) END	+ CASE WHEN MAX([SN78]) IS NULL THEN '' ELSE ',' + MAX([SN78]) END
				+ CASE WHEN MAX([SN79]) IS NULL THEN '' ELSE ',' + MAX([SN79]) END	+ CASE WHEN MAX([SN80]) IS NULL THEN '' ELSE ',' + MAX([SN80]) END 
				+ CASE WHEN MAX([SN81]) IS NULL THEN '' ELSE ',' + MAX([SN81]) END 	+ CASE WHEN MAX([SN82]) IS NULL THEN '' ELSE ',' + MAX([SN82]) END
				+ CASE WHEN MAX([SN83]) IS NULL THEN '' ELSE ',' + MAX([SN83]) END	+ CASE WHEN MAX([SN84]) IS NULL THEN '' ELSE ',' + MAX([SN84]) END
				+ CASE WHEN MAX([SN85]) IS NULL THEN '' ELSE ',' + MAX([SN85]) END	+ CASE WHEN MAX([SN86]) IS NULL THEN '' ELSE ',' + MAX([SN86]) END
				+ CASE WHEN MAX([SN87]) IS NULL THEN '' ELSE ',' + MAX([SN87]) END	+ CASE WHEN MAX([SN88]) IS NULL THEN '' ELSE ',' + MAX([SN88]) END
				+ CASE WHEN MAX([SN89]) IS NULL THEN '' ELSE ',' + MAX([SN89]) END	+ CASE WHEN MAX([SN90]) IS NULL THEN '' ELSE ',' + MAX([SN90]) END
				+ CASE WHEN MAX([SN91]) IS NULL THEN '' ELSE ',' + MAX([SN91]) END 	+ CASE WHEN MAX([SN92]) IS NULL THEN '' ELSE ',' + MAX([SN92]) END
				+ CASE WHEN MAX([SN93]) IS NULL THEN '' ELSE ',' + MAX([SN93]) END	+ CASE WHEN MAX([SN94]) IS NULL THEN '' ELSE ',' + MAX([SN94]) END
				+ CASE WHEN MAX([SN95]) IS NULL THEN '' ELSE ',' + MAX([SN95]) END	+ CASE WHEN MAX([SN96]) IS NULL THEN '' ELSE ',' + MAX([SN96]) END
				+ CASE WHEN MAX([SN97]) IS NULL THEN '' ELSE ',' + MAX([SN97]) END	+ CASE WHEN MAX([SN98]) IS NULL THEN '' ELSE ',' + MAX([SN98]) END
				+ CASE WHEN MAX([SN99]) IS NULL THEN '' ELSE ',' + MAX([SN99]) END	+ CASE WHEN MAX([SN100]) IS NULL THEN '' ELSE ',' + MAX([SN100]) END 
				+ CASE WHEN MAX([SN101]) IS NULL THEN '' ELSE ',' + MAX([SN101]) END	+ CASE WHEN MAX([SN102]) IS NULL THEN '' ELSE ',' + MAX([SN102]) END
				+ CASE WHEN MAX([SN103]) IS NULL THEN '' ELSE ',' + MAX([SN103]) END	+ CASE WHEN MAX([SN104]) IS NULL THEN '' ELSE ',' + MAX([SN104]) END
				+ CASE WHEN MAX([SN105]) IS NULL THEN '' ELSE ',' + MAX([SN105]) END	+ CASE WHEN MAX([SN106]) IS NULL THEN '' ELSE ',' + MAX([SN106]) END
				+ CASE WHEN MAX([SN107]) IS NULL THEN '' ELSE ',' + MAX([SN107]) END	+ CASE WHEN MAX([SN108]) IS NULL THEN '' ELSE ',' + MAX([SN108]) END
				+ CASE WHEN MAX([SN109]) IS NULL THEN '' ELSE ',' + MAX([SN109]) END	+ CASE WHEN MAX([SN110]) IS NULL THEN '' ELSE ',' + MAX([SN110]) END 
				+ CASE WHEN MAX([SN111]) IS NULL THEN '' ELSE ',' + MAX([SN111]) END 	+ CASE WHEN MAX([SN112]) IS NULL THEN '' ELSE ',' + MAX([SN112]) END
				+ CASE WHEN MAX([SN113]) IS NULL THEN '' ELSE ',' + MAX([SN113]) END	+ CASE WHEN MAX([SN114]) IS NULL THEN '' ELSE ',' + MAX([SN114]) END
				+ CASE WHEN MAX([SN115]) IS NULL THEN '' ELSE ',' + MAX([SN115]) END	+ CASE WHEN MAX([SN116]) IS NULL THEN '' ELSE ',' + MAX([SN116]) END
				+ CASE WHEN MAX([SN117]) IS NULL THEN '' ELSE ',' + MAX([SN117]) END	+ CASE WHEN MAX([SN118]) IS NULL THEN '' ELSE ',' + MAX([SN118]) END
				+ CASE WHEN MAX([SN119]) IS NULL THEN '' ELSE ',' + MAX([SN119]) END	+ CASE WHEN MAX([SN120]) IS NULL THEN '' ELSE ',' + MAX([SN120]) END
				+ CASE WHEN MAX([SN121]) IS NULL THEN '' ELSE ',' + MAX([SN121]) END 	+ CASE WHEN MAX([SN122]) IS NULL THEN '' ELSE ',' + MAX([SN122]) END
				+ CASE WHEN MAX([SN123]) IS NULL THEN '' ELSE ',' + MAX([SN123]) END	+ CASE WHEN MAX([SN124]) IS NULL THEN '' ELSE ',' + MAX([SN124]) END
				+ CASE WHEN MAX([SN125]) IS NULL THEN '' ELSE ',' + MAX([SN125]) END	+ CASE WHEN MAX([SN126]) IS NULL THEN '' ELSE ',' + MAX([SN126]) END
				+ CASE WHEN MAX([SN127]) IS NULL THEN '' ELSE ',' + MAX([SN127]) END	+ CASE WHEN MAX([SN128]) IS NULL THEN '' ELSE ',' + MAX([SN128]) END
				+ CASE WHEN MAX([SN129]) IS NULL THEN '' ELSE ',' + MAX([SN129]) END	+ CASE WHEN MAX([SN130]) IS NULL THEN '' ELSE ',' + MAX([SN130]) END 
				+ CASE WHEN MAX([SN131]) IS NULL THEN '' ELSE ',' + MAX([SN131]) END 	+ CASE WHEN MAX([SN132]) IS NULL THEN '' ELSE ',' + MAX([SN132]) END
				+ CASE WHEN MAX([SN133]) IS NULL THEN '' ELSE ',' + MAX([SN133]) END	+ CASE WHEN MAX([SN134]) IS NULL THEN '' ELSE ',' + MAX([SN134]) END
				+ CASE WHEN MAX([SN135]) IS NULL THEN '' ELSE ',' + MAX([SN135]) END	+ CASE WHEN MAX([SN136]) IS NULL THEN '' ELSE ',' + MAX([SN136]) END
				+ CASE WHEN MAX([SN137]) IS NULL THEN '' ELSE ',' + MAX([SN137]) END	+ CASE WHEN MAX([SN138]) IS NULL THEN '' ELSE ',' + MAX([SN138]) END
				+ CASE WHEN MAX([SN139]) IS NULL THEN '' ELSE ',' + MAX([SN139]) END	+ CASE WHEN MAX([SN140]) IS NULL THEN '' ELSE ',' + MAX([SN140]) END 
				+ CASE WHEN MAX([SN141]) IS NULL THEN '' ELSE ',' + MAX([SN141]) END 	+ CASE WHEN MAX([SN142]) IS NULL THEN '' ELSE ',' + MAX([SN142]) END
				+ CASE WHEN MAX([SN143]) IS NULL THEN '' ELSE ',' + MAX([SN143]) END	+ CASE WHEN MAX([SN144]) IS NULL THEN '' ELSE ',' + MAX([SN144]) END
				+ CASE WHEN MAX([SN145]) IS NULL THEN '' ELSE ',' + MAX([SN145]) END	+ CASE WHEN MAX([SN146]) IS NULL THEN '' ELSE ',' + MAX([SN146]) END
				+ CASE WHEN MAX([SN147]) IS NULL THEN '' ELSE ',' + MAX([SN147]) END	+ CASE WHEN MAX([SN148]) IS NULL THEN '' ELSE ',' + MAX([SN148]) END
				+ CASE WHEN MAX([SN149]) IS NULL THEN '' ELSE ',' + MAX([SN149]) END	+ CASE WHEN MAX([SN150]) IS NULL THEN '' ELSE ',' + MAX([SN150]) END 
				+ CASE WHEN MAX([SN151]) IS NULL THEN '' ELSE ',' + MAX([SN151]) END 	+ CASE WHEN MAX([SN152]) IS NULL THEN '' ELSE ',' + MAX([SN152]) END
				+ CASE WHEN MAX([SN153]) IS NULL THEN '' ELSE ',' + MAX([SN153]) END	+ CASE WHEN MAX([SN154]) IS NULL THEN '' ELSE ',' + MAX([SN154]) END
				+ CASE WHEN MAX([SN155]) IS NULL THEN '' ELSE ',' + MAX([SN155]) END	+ CASE WHEN MAX([SN156]) IS NULL THEN '' ELSE ',' + MAX([SN156]) END
				+ CASE WHEN MAX([SN157]) IS NULL THEN '' ELSE ',' + MAX([SN157]) END	+ CASE WHEN MAX([SN158]) IS NULL THEN '' ELSE ',' + MAX([SN158]) END
				+ CASE WHEN MAX([SN159]) IS NULL THEN '' ELSE ',' + MAX([SN159]) END	+ CASE WHEN MAX([SN160]) IS NULL THEN '' ELSE ',' + MAX([SN160]) END 
				+ CASE WHEN MAX([SN161]) IS NULL THEN '' ELSE ',' + MAX([SN161]) END 	+ CASE WHEN MAX([SN162]) IS NULL THEN '' ELSE ',' + MAX([SN162]) END
				+ CASE WHEN MAX([SN163]) IS NULL THEN '' ELSE ',' + MAX([SN163]) END	+ CASE WHEN MAX([SN164]) IS NULL THEN '' ELSE ',' + MAX([SN164]) END
				+ CASE WHEN MAX([SN165]) IS NULL THEN '' ELSE ',' + MAX([SN165]) END	+ CASE WHEN MAX([SN166]) IS NULL THEN '' ELSE ',' + MAX([SN166]) END
				+ CASE WHEN MAX([SN167]) IS NULL THEN '' ELSE ',' + MAX([SN167]) END	+ CASE WHEN MAX([SN168]) IS NULL THEN '' ELSE ',' + MAX([SN168]) END
				+ CASE WHEN MAX([SN169]) IS NULL THEN '' ELSE ',' + MAX([SN169]) END	+ CASE WHEN MAX([SN170]) IS NULL THEN '' ELSE ',' + MAX([SN170]) END 
				+ CASE WHEN MAX([SN171]) IS NULL THEN '' ELSE ',' + MAX([SN171]) END 	+ CASE WHEN MAX([SN172]) IS NULL THEN '' ELSE ',' + MAX([SN172]) END
				+ CASE WHEN MAX([SN173]) IS NULL THEN '' ELSE ',' + MAX([SN173]) END	+ CASE WHEN MAX([SN174]) IS NULL THEN '' ELSE ',' + MAX([SN174]) END
				+ CASE WHEN MAX([SN175]) IS NULL THEN '' ELSE ',' + MAX([SN175]) END	+ CASE WHEN MAX([SN176]) IS NULL THEN '' ELSE ',' + MAX([SN176]) END
				+ CASE WHEN MAX([SN177]) IS NULL THEN '' ELSE ',' + MAX([SN177]) END	+ CASE WHEN MAX([SN178]) IS NULL THEN '' ELSE ',' + MAX([SN178]) END
				+ CASE WHEN MAX([SN179]) IS NULL THEN '' ELSE ',' + MAX([SN179]) END	+ CASE WHEN MAX([SN180]) IS NULL THEN '' ELSE ',' + MAX([SN180]) END 
				+ CASE WHEN MAX([SN181]) IS NULL THEN '' ELSE ',' + MAX([SN181]) END 	+ CASE WHEN MAX([SN182]) IS NULL THEN '' ELSE ',' + MAX([SN182]) END
				+ CASE WHEN MAX([SN183]) IS NULL THEN '' ELSE ',' + MAX([SN183]) END	+ CASE WHEN MAX([SN184]) IS NULL THEN '' ELSE ',' + MAX([SN184]) END
				+ CASE WHEN MAX([SN185]) IS NULL THEN '' ELSE ',' + MAX([SN185]) END	+ CASE WHEN MAX([SN186]) IS NULL THEN '' ELSE ',' + MAX([SN186]) END
				+ CASE WHEN MAX([SN187]) IS NULL THEN '' ELSE ',' + MAX([SN187]) END	+ CASE WHEN MAX([SN188]) IS NULL THEN '' ELSE ',' + MAX([SN188]) END
				+ CASE WHEN MAX([SN189]) IS NULL THEN '' ELSE ',' + MAX([SN189]) END	+ CASE WHEN MAX([SN190]) IS NULL THEN '' ELSE ',' + MAX([SN190]) END
				+ CASE WHEN MAX([SN191]) IS NULL THEN '' ELSE ',' + MAX([SN191]) END 	+ CASE WHEN MAX([SN192]) IS NULL THEN '' ELSE ',' + MAX([SN192]) END
				+ CASE WHEN MAX([SN193]) IS NULL THEN '' ELSE ',' + MAX([SN193]) END	+ CASE WHEN MAX([SN194]) IS NULL THEN '' ELSE ',' + MAX([SN194]) END
				+ CASE WHEN MAX([SN195]) IS NULL THEN '' ELSE ',' + MAX([SN195]) END	+ CASE WHEN MAX([SN196]) IS NULL THEN '' ELSE ',' + MAX([SN196]) END
				+ CASE WHEN MAX([SN197]) IS NULL THEN '' ELSE ',' + MAX([SN197]) END	+ CASE WHEN MAX([SN198]) IS NULL THEN '' ELSE ',' + MAX([SN198]) END
				+ CASE WHEN MAX([SN199]) IS NULL THEN '' ELSE ',' + MAX([SN199]) END	+ CASE WHEN MAX([SN200]) IS NULL THEN '' ELSE ',' + MAX([SN200]) END 
				+ CASE WHEN MAX([SN201]) IS NULL THEN '' ELSE ',' + MAX([SN201]) END	+ CASE WHEN MAX([SN202]) IS NULL THEN '' ELSE ',' + MAX([SN202]) END
				+ CASE WHEN MAX([SN203]) IS NULL THEN '' ELSE ',' + MAX([SN203]) END	+ CASE WHEN MAX([SN204]) IS NULL THEN '' ELSE ',' + MAX([SN204]) END
				+ CASE WHEN MAX([SN205]) IS NULL THEN '' ELSE ',' + MAX([SN205]) END	+ CASE WHEN MAX([SN206]) IS NULL THEN '' ELSE ',' + MAX([SN206]) END
				+ CASE WHEN MAX([SN207]) IS NULL THEN '' ELSE ',' + MAX([SN207]) END	+ CASE WHEN MAX([SN208]) IS NULL THEN '' ELSE ',' + MAX([SN208]) END
				+ CASE WHEN MAX([SN209]) IS NULL THEN '' ELSE ',' + MAX([SN209]) END	+ CASE WHEN MAX([SN210]) IS NULL THEN '' ELSE ',' + MAX([SN210]) END 
				+ CASE WHEN MAX([SN211]) IS NULL THEN '' ELSE ',' + MAX([SN211]) END 	+ CASE WHEN MAX([SN212]) IS NULL THEN '' ELSE ',' + MAX([SN212]) END
				+ CASE WHEN MAX([SN213]) IS NULL THEN '' ELSE ',' + MAX([SN213]) END	+ CASE WHEN MAX([SN214]) IS NULL THEN '' ELSE ',' + MAX([SN214]) END
				+ CASE WHEN MAX([SN215]) IS NULL THEN '' ELSE ',' + MAX([SN215]) END	+ CASE WHEN MAX([SN216]) IS NULL THEN '' ELSE ',' + MAX([SN216]) END
				+ CASE WHEN MAX([SN217]) IS NULL THEN '' ELSE ',' + MAX([SN217]) END	+ CASE WHEN MAX([SN218]) IS NULL THEN '' ELSE ',' + MAX([SN218]) END
				+ CASE WHEN MAX([SN219]) IS NULL THEN '' ELSE ',' + MAX([SN219]) END	+ CASE WHEN MAX([SN220]) IS NULL THEN '' ELSE ',' + MAX([SN220]) END
				+ CASE WHEN MAX([SN221]) IS NULL THEN '' ELSE ',' + MAX([SN221]) END 	+ CASE WHEN MAX([SN222]) IS NULL THEN '' ELSE ',' + MAX([SN222]) END
				+ CASE WHEN MAX([SN223]) IS NULL THEN '' ELSE ',' + MAX([SN223]) END	+ CASE WHEN MAX([SN224]) IS NULL THEN '' ELSE ',' + MAX([SN224]) END
				+ CASE WHEN MAX([SN225]) IS NULL THEN '' ELSE ',' + MAX([SN225]) END	+ CASE WHEN MAX([SN226]) IS NULL THEN '' ELSE ',' + MAX([SN226]) END
				+ CASE WHEN MAX([SN227]) IS NULL THEN '' ELSE ',' + MAX([SN227]) END	+ CASE WHEN MAX([SN228]) IS NULL THEN '' ELSE ',' + MAX([SN228]) END
				+ CASE WHEN MAX([SN229]) IS NULL THEN '' ELSE ',' + MAX([SN229]) END	+ CASE WHEN MAX([SN230]) IS NULL THEN '' ELSE ',' + MAX([SN230]) END 
				+ CASE WHEN MAX([SN231]) IS NULL THEN '' ELSE ',' + MAX([SN231]) END 	+ CASE WHEN MAX([SN232]) IS NULL THEN '' ELSE ',' + MAX([SN232]) END
				+ CASE WHEN MAX([SN233]) IS NULL THEN '' ELSE ',' + MAX([SN233]) END	+ CASE WHEN MAX([SN234]) IS NULL THEN '' ELSE ',' + MAX([SN234]) END
				+ CASE WHEN MAX([SN235]) IS NULL THEN '' ELSE ',' + MAX([SN235]) END	+ CASE WHEN MAX([SN236]) IS NULL THEN '' ELSE ',' + MAX([SN236]) END
				+ CASE WHEN MAX([SN237]) IS NULL THEN '' ELSE ',' + MAX([SN237]) END	+ CASE WHEN MAX([SN238]) IS NULL THEN '' ELSE ',' + MAX([SN238]) END
				+ CASE WHEN MAX([SN239]) IS NULL THEN '' ELSE ',' + MAX([SN239]) END	+ CASE WHEN MAX([SN240]) IS NULL THEN '' ELSE ',' + MAX([SN240]) END 
				+ CASE WHEN MAX([SN241]) IS NULL THEN '' ELSE ',' + MAX([SN241]) END 	+ CASE WHEN MAX([SN242]) IS NULL THEN '' ELSE ',' + MAX([SN242]) END
				+ CASE WHEN MAX([SN243]) IS NULL THEN '' ELSE ',' + MAX([SN243]) END	+ CASE WHEN MAX([SN244]) IS NULL THEN '' ELSE ',' + MAX([SN244]) END
				+ CASE WHEN MAX([SN245]) IS NULL THEN '' ELSE ',' + MAX([SN245]) END	+ CASE WHEN MAX([SN246]) IS NULL THEN '' ELSE ',' + MAX([SN246]) END
				+ CASE WHEN MAX([SN247]) IS NULL THEN '' ELSE ',' + MAX([SN247]) END	+ CASE WHEN MAX([SN248]) IS NULL THEN '' ELSE ',' + MAX([SN248]) END
				+ CASE WHEN MAX([SN249]) IS NULL THEN '' ELSE ',' + MAX([SN249]) END	+ CASE WHEN MAX([SN250]) IS NULL THEN '' ELSE ',' + MAX([SN250]) END 
				+ CASE WHEN MAX([SN251]) IS NULL THEN '' ELSE ',' + MAX([SN251]) END 	+ CASE WHEN MAX([SN252]) IS NULL THEN '' ELSE ',' + MAX([SN252]) END
				+ CASE WHEN MAX([SN253]) IS NULL THEN '' ELSE ',' + MAX([SN253]) END	+ CASE WHEN MAX([SN254]) IS NULL THEN '' ELSE ',' + MAX([SN254]) END
				+ CASE WHEN MAX([SN255]) IS NULL THEN '' ELSE ',' + MAX([SN255]) END	+ CASE WHEN MAX([SN256]) IS NULL THEN '' ELSE ',' + MAX([SN256]) END
				+ CASE WHEN MAX([SN257]) IS NULL THEN '' ELSE ',' + MAX([SN257]) END	+ CASE WHEN MAX([SN258]) IS NULL THEN '' ELSE ',' + MAX([SN258]) END
				+ CASE WHEN MAX([SN259]) IS NULL THEN '' ELSE ',' + MAX([SN259]) END	+ CASE WHEN MAX([SN260]) IS NULL THEN '' ELSE ',' + MAX([SN260]) END 
				+ CASE WHEN MAX([SN261]) IS NULL THEN '' ELSE ',' + MAX([SN261]) END 	+ CASE WHEN MAX([SN262]) IS NULL THEN '' ELSE ',' + MAX([SN262]) END
				+ CASE WHEN MAX([SN263]) IS NULL THEN '' ELSE ',' + MAX([SN263]) END	+ CASE WHEN MAX([SN264]) IS NULL THEN '' ELSE ',' + MAX([SN264]) END
				+ CASE WHEN MAX([SN265]) IS NULL THEN '' ELSE ',' + MAX([SN265]) END	+ CASE WHEN MAX([SN266]) IS NULL THEN '' ELSE ',' + MAX([SN266]) END
				+ CASE WHEN MAX([SN267]) IS NULL THEN '' ELSE ',' + MAX([SN267]) END	+ CASE WHEN MAX([SN268]) IS NULL THEN '' ELSE ',' + MAX([SN268]) END
				+ CASE WHEN MAX([SN269]) IS NULL THEN '' ELSE ',' + MAX([SN269]) END	+ CASE WHEN MAX([SN270]) IS NULL THEN '' ELSE ',' + MAX([SN270]) END 
				+ CASE WHEN MAX([SN271]) IS NULL THEN '' ELSE ',' + MAX([SN271]) END 	+ CASE WHEN MAX([SN272]) IS NULL THEN '' ELSE ',' + MAX([SN272]) END
				+ CASE WHEN MAX([SN273]) IS NULL THEN '' ELSE ',' + MAX([SN273]) END	+ CASE WHEN MAX([SN274]) IS NULL THEN '' ELSE ',' + MAX([SN274]) END
				+ CASE WHEN MAX([SN275]) IS NULL THEN '' ELSE ',' + MAX([SN275]) END	+ CASE WHEN MAX([SN276]) IS NULL THEN '' ELSE ',' + MAX([SN276]) END
				+ CASE WHEN MAX([SN277]) IS NULL THEN '' ELSE ',' + MAX([SN277]) END	+ CASE WHEN MAX([SN278]) IS NULL THEN '' ELSE ',' + MAX([SN278]) END
				+ CASE WHEN MAX([SN279]) IS NULL THEN '' ELSE ',' + MAX([SN279]) END	+ CASE WHEN MAX([SN280]) IS NULL THEN '' ELSE ',' + MAX([SN280]) END 
				+ CASE WHEN MAX([SN281]) IS NULL THEN '' ELSE ',' + MAX([SN281]) END 	+ CASE WHEN MAX([SN282]) IS NULL THEN '' ELSE ',' + MAX([SN282]) END
				+ CASE WHEN MAX([SN283]) IS NULL THEN '' ELSE ',' + MAX([SN283]) END	+ CASE WHEN MAX([SN284]) IS NULL THEN '' ELSE ',' + MAX([SN284]) END
				+ CASE WHEN MAX([SN285]) IS NULL THEN '' ELSE ',' + MAX([SN285]) END	+ CASE WHEN MAX([SN286]) IS NULL THEN '' ELSE ',' + MAX([SN286]) END
				+ CASE WHEN MAX([SN287]) IS NULL THEN '' ELSE ',' + MAX([SN287]) END	+ CASE WHEN MAX([SN288]) IS NULL THEN '' ELSE ',' + MAX([SN288]) END
				+ CASE WHEN MAX([SN289]) IS NULL THEN '' ELSE ',' + MAX([SN289]) END	+ CASE WHEN MAX([SN290]) IS NULL THEN '' ELSE ',' + MAX([SN290]) END
				+ CASE WHEN MAX([SN291]) IS NULL THEN '' ELSE ',' + MAX([SN291]) END 	+ CASE WHEN MAX([SN292]) IS NULL THEN '' ELSE ',' + MAX([SN292]) END
				+ CASE WHEN MAX([SN293]) IS NULL THEN '' ELSE ',' + MAX([SN293]) END	+ CASE WHEN MAX([SN294]) IS NULL THEN '' ELSE ',' + MAX([SN294]) END
				+ CASE WHEN MAX([SN295]) IS NULL THEN '' ELSE ',' + MAX([SN295]) END	+ CASE WHEN MAX([SN296]) IS NULL THEN '' ELSE ',' + MAX([SN296]) END
				+ CASE WHEN MAX([SN297]) IS NULL THEN '' ELSE ',' + MAX([SN297]) END	+ CASE WHEN MAX([SN298]) IS NULL THEN '' ELSE ',' + MAX([SN298]) END
				+ CASE WHEN MAX([SN299]) IS NULL THEN '' ELSE ',' + MAX([SN299]) END	+ CASE WHEN MAX([SN300]) IS NULL THEN '' ELSE ',' + MAX([SN300]) END AS SO_NO --[C20210225-000385] SO_NO 추가(','로 구분)
			, ISNULL((CAST(CAST(SUM([SQ1]) AS INT) AS NVARCHAR(1000))),'') 
				+ CASE WHEN (CAST(CAST(SUM([SQ2]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ2]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ3]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ3]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ4]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ4]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ5]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ5]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ6]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ6]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ7]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ7]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ8]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ8]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ9]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ9]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ10]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ10]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ11]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ11]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ12]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ12]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ13]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ13]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ14]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ14]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ15]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ15]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ16]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ16]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ17]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ17]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ18]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ18]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ19]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ19]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ20]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ20]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ21]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ21]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ22]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ22]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ23]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ23]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ24]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ24]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ25]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ25]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ26]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ26]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ27]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ27]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ28]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ28]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ29]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ29]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ30]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ30]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ31]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ31]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ32]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ32]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ33]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ33]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ34]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ34]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ35]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ35]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ36]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ36]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ37]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ37]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ38]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ38]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ39]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ39]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ40]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ40]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ41]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ41]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ42]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ42]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ43]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ43]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ44]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ44]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ45]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ45]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ46]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ46]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ47]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ47]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ48]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ48]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ49]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ49]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ50]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ50]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ51]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ51]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ52]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ52]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ53]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ53]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ54]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ54]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ55]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ55]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ56]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ56]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ57]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ57]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ58]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ58]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ59]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ59]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ60]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ60]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ61]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ61]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ62]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ62]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ63]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ63]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ64]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ64]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ65]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ65]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ66]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ66]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ67]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ67]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ68]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ68]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ69]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ69]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ70]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ70]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ71]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ71]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ72]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ72]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ73]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ73]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ74]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ74]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ75]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ75]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ76]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ76]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ77]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ77]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ78]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ78]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ79]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ79]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ80]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ80]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ81]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ81]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ82]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ82]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ83]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ83]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ84]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ84]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ85]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ85]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ86]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ86]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ87]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ87]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ88]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ88]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ89]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ89]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ90]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ90]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ91]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ91]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ92]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ92]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ93]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ93]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ94]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ94]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ95]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ95]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ96]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ96]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ97]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ97]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ98]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ98]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ99]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ99]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ100]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ100]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ101]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ101]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ102]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ102]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ103]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ103]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ104]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ104]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ105]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ105]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ106]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ106]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ107]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ107]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ108]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ108]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ109]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ109]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ110]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ110]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ111]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ111]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ112]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ112]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ113]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ113]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ114]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ114]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ115]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ115]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ116]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ116]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ117]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ117]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ118]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ118]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ119]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ119]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ120]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ120]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ121]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ121]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ122]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ122]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ123]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ123]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ124]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ124]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ125]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ125]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ126]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ126]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ127]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ127]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ128]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ128]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ129]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ129]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ130]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ130]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ131]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ131]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ132]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ132]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ133]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ133]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ134]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ134]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ135]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ135]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ136]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ136]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ137]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ137]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ138]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ138]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ139]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ139]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ140]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ140]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ141]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ141]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ142]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ142]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ143]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ143]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ144]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ144]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ145]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ145]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ146]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ146]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ147]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ147]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ148]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ148]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ149]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ149]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ150]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ150]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ151]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ151]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ152]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ152]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ153]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ153]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ154]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ154]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ155]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ155]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ156]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ156]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ157]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ157]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ158]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ158]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ159]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ159]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ160]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ160]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ161]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ161]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ162]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ162]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ163]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ163]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ164]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ164]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ165]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ165]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ166]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ166]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ167]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ167]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ168]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ168]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ169]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ169]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ170]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ170]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ171]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ171]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ172]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ172]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ173]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ173]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ174]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ174]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ175]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ175]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ176]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ176]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ177]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ177]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ178]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ178]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ179]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ179]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ180]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ180]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ181]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ181]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ182]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ182]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ183]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ183]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ184]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ184]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ185]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ185]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ186]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ186]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ187]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ187]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ188]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ188]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ189]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ189]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ190]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ190]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ191]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ191]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ192]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ192]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ193]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ193]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ194]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ194]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ195]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ195]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ196]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ196]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ197]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ197]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ198]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ198]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ199]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ199]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ200]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ200]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ201]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ201]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ202]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ202]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ203]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ203]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ204]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ204]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ205]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ205]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ206]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ206]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ207]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ207]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ208]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ208]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ209]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ209]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ210]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ210]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ211]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ211]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ212]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ212]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ213]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ213]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ214]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ214]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ215]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ215]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ216]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ216]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ217]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ217]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ218]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ218]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ219]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ219]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ220]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ220]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ221]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ221]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ222]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ222]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ223]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ223]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ224]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ224]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ225]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ225]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ226]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ226]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ227]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ227]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ228]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ228]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ229]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ229]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ230]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ230]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ231]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ231]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ232]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ232]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ233]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ233]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ234]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ234]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ235]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ235]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ236]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ236]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ237]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ237]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ238]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ238]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ239]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ239]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ240]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ240]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ241]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ241]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ242]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ242]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ243]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ243]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ244]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ244]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ245]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ245]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ246]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ246]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ247]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ247]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ248]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ248]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ249]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ249]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ250]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ250]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ251]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ251]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ252]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ252]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ253]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ253]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ254]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ254]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ255]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ255]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ256]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ256]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ257]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ257]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ258]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ258]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ259]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ259]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ260]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ260]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ261]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ261]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ262]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ262]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ263]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ263]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ264]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ264]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ265]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ265]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ266]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ266]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ267]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ267]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ268]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ268]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ269]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ269]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ270]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ270]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ271]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ271]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ272]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ272]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ273]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ273]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ274]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ274]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ275]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ275]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ276]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ276]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ277]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ277]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ278]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ278]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ279]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ279]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ280]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ280]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ281]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ281]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ282]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ282]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ283]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ283]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ284]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ284]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ285]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ285]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ286]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ286]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ287]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ287]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ288]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ288]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ289]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ289]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ290]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ290]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ291]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ291]) AS INT) AS NVARCHAR(1000))) END 
				+ CASE WHEN (CAST(CAST(SUM([SQ292]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ292]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ293]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ293]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ294]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ294]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ295]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ295]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ296]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ296]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ297]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ297]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ298]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ298]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ299]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ299]) AS INT) AS NVARCHAR(1000))) END
				+ CASE WHEN (CAST(CAST(SUM([SQ300]) AS INT) AS NVARCHAR(1000))) IS NULL THEN '' ELSE ',' + (CAST(CAST(SUM([SQ300]) AS INT) AS NVARCHAR(1000))) END  AS SO_QTY --[C20210225-000385] SO_QTY 추가(','로 구분)
			--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END 
			*/
			, ATTRIBUTE1	-- [C20210316-000434]
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START
			, FROM_COMPANY_ID
		    , STUFF((SELECT ',' + FROM_SELL_DOC 
					FROM #XIF_SALES_RESULT_SO_NO_TMP B WITH(NOLOCK)
					WHERE A.company_id = B.company_id AND A.division_id = B.division_id	AND A.sales_type = B.sales_type
					AND A.sales_dept = B.sales_dept	AND A.sales_work_place = B.sales_work_place	AND A.sales_work_place_name = B.sales_work_place_name	
					AND A.sales_group = B.sales_group AND A.sales_group_name = B.sales_group_name AND A.sales_posting_date = B.sales_posting_date	  
					AND A.cost_item = B.cost_item AND A.cost_item_name = B.cost_item_name AND A.sales_type_2 = B.sales_type_2	  
					AND A.valuation_class = B.valuation_class AND A.item_type = B.item_type	AND A.customer_code = B.customer_code	  
					AND A.customer_name = B.customer_name AND A.customer_project_name = B.customer_project_name	AND A.customer_item_name = B.customer_item_name	 
					AND A.biz_type = B.biz_type AND A.project_code = B.project_code	AND A.project_name = B.project_name	 
					AND A.cell_type = B.cell_type AND A.car_model = B.car_model	AND A.qty_cell_by_pack = B.qty_cell_by_pack	 
					AND A.z_type = B.z_type AND A.z_code = B.z_code	AND A.sales_region = B.sales_region	 
					AND A.distribution_channel = B.distribution_channel AND A.lgs_route_name = B.lgs_route_name	AND A.connect_name = B.connect_name	 
					AND A.car_qty = B.car_qty AND A.cell_qty = B.cell_qty AND A.sales_price = B.sales_price	 
					AND A.currency = B.currency AND A.uom = B.uom AND A.sales_user = B.sales_user	 
					AND A.sales_user_name = B.sales_user_name AND A.mat_group = B.mat_group AND A.mat_group_desc = B.mat_group_desc	 
					AND A.item_id = B.item_id AND A.biz_type_2 = B.biz_type_2 AND A.app = B.app	 
					AND A.usage = B.usage AND A.sales_team = B.sales_team AND A.ess_pm = B.ess_pm	 
					AND A.plant_id = B.plant_id AND A.shipto_code = B.shipto_code AND A.shipto_description = B.shipto_description	
					AND A.country = B.country AND A.country_name = B.country_name AND A.shipto_city_name = B.shipto_city_name	
					AND A.shipto_zone_code = B.shipto_zone_code AND A.shipto_zone_name = B.shipto_zone_name AND A.rbu_customer = B.rbu_customer	
					AND A.incoterms = B.incoterms AND A.profit_center_id = B.profit_center_id AND A.profit_center_name = B.profit_center_name	
					AND A.partner_profit_center_id = B.partner_profit_center_id AND A.partner_profit_center_name = B.partner_profit_center_name AND A.item_text = B.item_text	
					AND A.affiliate_code = B.affiliate_code AND A.customer_group_code = B.customer_group_code AND A.customer_group_name = B.customer_group_name	
					AND A.cell_code = B.cell_code AND A.delegate_model_id = B.delegate_model_id AND A.delegate_model_name = B.delegate_model_name	
					AND A.c_p_model_id = B.c_p_model_id AND A.c_p_model_name = B.c_p_model_name AND A.lrregular_code = B.lrregular_code	
					AND A.lrregular_name = B.lrregular_name AND A.machine_code = B.machine_code AND A.machine_name = B.machine_name	
					AND A.line_id = B.line_id AND A.line_name = B.line_name AND A.tco = B.tco	
					AND A.system_input_time = B.system_input_time AND A.system_input_date = B.system_input_date AND A.ifseqno = B.ifseqno	
					AND A.transfer_flag = B.transfer_flag AND A.result_yyyymm = B.result_yyyymm AND A.DOC_CURRENCY = B.DOC_CURRENCY	
					AND A.FROM_COMPANY_ID = B.FROM_COMPANY_ID 					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 
					AND ISNULL(B.FROM_SELL_DOC, '') != ''						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가  (데이터가 없을때는 SKIP)
					 FOR XML PATH('')
				), 1, 1, '') AS FROM_SELL_DOC					
		    , STUFF((SELECT ',' + FROM_SHIP_NO 
					FROM #XIF_SALES_RESULT_SO_NO_TMP B WITH(NOLOCK)
					WHERE A.company_id = B.company_id AND A.division_id = B.division_id	AND A.sales_type = B.sales_type
					AND A.sales_dept = B.sales_dept	AND A.sales_work_place = B.sales_work_place	AND A.sales_work_place_name = B.sales_work_place_name	
					AND A.sales_group = B.sales_group AND A.sales_group_name = B.sales_group_name AND A.sales_posting_date = B.sales_posting_date	  
					AND A.cost_item = B.cost_item AND A.cost_item_name = B.cost_item_name AND A.sales_type_2 = B.sales_type_2	  
					AND A.valuation_class = B.valuation_class AND A.item_type = B.item_type	AND A.customer_code = B.customer_code	  
					AND A.customer_name = B.customer_name AND A.customer_project_name = B.customer_project_name	AND A.customer_item_name = B.customer_item_name	 
					AND A.biz_type = B.biz_type AND A.project_code = B.project_code	AND A.project_name = B.project_name	 
					AND A.cell_type = B.cell_type AND A.car_model = B.car_model	AND A.qty_cell_by_pack = B.qty_cell_by_pack	 
					AND A.z_type = B.z_type AND A.z_code = B.z_code	AND A.sales_region = B.sales_region	 
					AND A.distribution_channel = B.distribution_channel AND A.lgs_route_name = B.lgs_route_name	AND A.connect_name = B.connect_name	 
					AND A.car_qty = B.car_qty AND A.cell_qty = B.cell_qty AND A.sales_price = B.sales_price	 
					AND A.currency = B.currency AND A.uom = B.uom AND A.sales_user = B.sales_user	 
					AND A.sales_user_name = B.sales_user_name AND A.mat_group = B.mat_group AND A.mat_group_desc = B.mat_group_desc	 
					AND A.item_id = B.item_id AND A.biz_type_2 = B.biz_type_2 AND A.app = B.app	 
					AND A.usage = B.usage AND A.sales_team = B.sales_team AND A.ess_pm = B.ess_pm	 
					AND A.plant_id = B.plant_id AND A.shipto_code = B.shipto_code AND A.shipto_description = B.shipto_description	
					AND A.country = B.country AND A.country_name = B.country_name AND A.shipto_city_name = B.shipto_city_name	
					AND A.shipto_zone_code = B.shipto_zone_code AND A.shipto_zone_name = B.shipto_zone_name AND A.rbu_customer = B.rbu_customer	
					AND A.incoterms = B.incoterms AND A.profit_center_id = B.profit_center_id AND A.profit_center_name = B.profit_center_name	
					AND A.partner_profit_center_id = B.partner_profit_center_id AND A.partner_profit_center_name = B.partner_profit_center_name AND A.item_text = B.item_text	
					AND A.affiliate_code = B.affiliate_code AND A.customer_group_code = B.customer_group_code AND A.customer_group_name = B.customer_group_name	
					AND A.cell_code = B.cell_code AND A.delegate_model_id = B.delegate_model_id AND A.delegate_model_name = B.delegate_model_name	
					AND A.c_p_model_id = B.c_p_model_id AND A.c_p_model_name = B.c_p_model_name AND A.lrregular_code = B.lrregular_code	
					AND A.lrregular_name = B.lrregular_name AND A.machine_code = B.machine_code AND A.machine_name = B.machine_name	
					AND A.line_id = B.line_id AND A.line_name = B.line_name AND A.tco = B.tco	
					AND A.system_input_time = B.system_input_time AND A.system_input_date = B.system_input_date AND A.ifseqno = B.ifseqno	
					AND A.transfer_flag = B.transfer_flag AND A.result_yyyymm = B.result_yyyymm AND A.DOC_CURRENCY = B.DOC_CURRENCY	
					AND A.FROM_COMPANY_ID = B.FROM_COMPANY_ID 					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 
					AND ISNULL(B.FROM_SHIP_NO, '') != ''						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가  (데이터가 없을때는 SKIP)
					 FOR XML PATH('')
				), 1, 1, '') AS FROM_SHIP_NO					
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
		INTO #XIF_ERP_SALES_RESULT_R_SN_TMP
		FROM #XIF_SALES_RESULT_SO_NO_TMP A WITH(NOLOCK) --[E20240814-000938] 속도개선을 위해 #XIF_SALES_RESULT_SO_NO_TMP 으로 변경
		/*
		FROM (
			SELECT  company_id  
				,XIF.division_id  
				,sales_type  
				,sales_dept  
				,sales_work_place  
				,sales_work_place_name  
				,sales_group  
				,sales_group_name  
				,sales_posting_date  
				,cost_item  
				,cost_item_name  
				,sales_type_2  
				,valuation_class  
				,item_type  
				,customer_code  
				,customer_name  
				,customer_project_name  
				,customer_item_name  
				,XIF.biz_type AS biz_type  
				,XIF.project_code as project_code
				,project_name --as origin_project_name  
				,cell_type  
				,car_model  
				,qty_cell_by_pack  
				,z_type  
				,z_code  
				,sales_region  
				,distribution_channel  
				,lgs_route_name  
				,connect_name  
				,car_qty  
				,cell_qty  
				,sales_price  
				, currency -- ,CASE WHEN currency = 'CNY' THEN 'RMB' ELSE currency END AS currency  -- 20190125 KHSONG 국내 ERP 매출 Data의 Currency정보중 CNY -> RMB 로 전환  
				,SUM(sales_amount_for) AS SALES_AMOUNT_FOR  
				,SUM(sales_amount_sum) AS SALES_AMOUNT_SUM  
				,uom  
				,SUM( CASE WHEN B.AS_ITEM IS NOT NULL AND SALES_QTY = 0 AND ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS NUMERIC(20,10))
							ELSE SALES_QTY
							END ) AS SALES_QTY
				,SUM( CASE WHEN B.AS_ITEM IS NOT NULL AND SALES_QTY = 0 AND ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS NUMERIC(20,10))
							ELSE SALES_QTY
							END ) AS SO_QTY --[C20210225-000385] SO_QTY 추가, 2022.08.18 LOOKUP 에 등록된 모델만 ATTR2 사용
				,sales_user  
				,sales_user_name  
				,mat_group  
				,mat_group_desc  
				,XIF.item_id  AS item_id  --as origin_item_id  
				,biz_type_2  
				,app  
				,usage  
				,sales_team  
				,ess_pm  
				,plant_id  
				,shipto_code  
				,shipto_description  
				,country  
				,country_name  
				,shipto_city_name  
				,shipto_zone_code  
				,shipto_zone_name  
				,rbu_customer  
				,XIF.incoterms AS incoterms   --as origin_incoterms  
				,profit_center_id  
				,profit_center_name  
				,partner_profit_center_id  
				,partner_profit_center_name  
				,item_text  
				,affiliate_code  
				,customer_group_code  
				,customer_group_name  
				,cell_code  
				,delegate_model_id  
				,delegate_model_name  
				,c_p_model_id  
				,c_p_model_name  
				,lrregular_code  
				,lrregular_name  
				,machine_code  
				,machine_name  
				,line_id  
				,line_name  
				,tco  
				,system_input_date  
				,system_input_time         
				,ifseqno  
				,transfer_flag  
				,result_yyyymm  
				, SUM( ISNULL( CASE WHEN (ISNULL(SSP.ERP_SO_NO,'')<>'') THEN SALES_QTY ELSE 0 END ,0) ) AS ATTRIBUTE3 
				, MAX(SSP.TO_SITE) AS ATTRIBUTE4
				, DOC_CURRENCY
				, SUM(DOC_AMT_FOR) AS DOC_AMT_FOR -- [C20210201-000116]
				, SUM(DOC_AMT_KRW) AS DOC_AMT_KRW -- [C20210201-000116]
				, SO_NO
				, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY company_id ,XIF.division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name ,sales_group  ,sales_group_name  
												,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  ,item_type  ,customer_code  ,customer_name  
												,customer_project_name  ,customer_item_name  ,XIF.biz_type,XIF.project_code,project_name,cell_type  ,car_model  ,qty_cell_by_pack  
												,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  , currency 
												,uom  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,XIF.item_id,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  
												,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  
												,XIF.incoterms,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  
												,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  
												,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time         
												,ifseqno  ,transfer_flag  ,result_yyyymm  , DOC_CURRENCY ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
				, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY company_id ,XIF.division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  ,sales_group_name  
												,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  ,item_type  ,customer_code  ,customer_name  
												,customer_project_name  ,customer_item_name  ,XIF.biz_type,XIF.project_code,project_name,cell_type  ,car_model  ,qty_cell_by_pack  
												,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  , currency 
												,uom  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,XIF.item_id,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  
												,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  
												,XIF.incoterms,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  
												,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  
												,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time         
												,ifseqno  ,transfer_flag  ,result_yyyymm  , DOC_CURRENCY ORDER BY SO_NO) AS NVARCHAR(1000)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
				, ATTRIBUTE1	-- [C20210316-000434]
			FROM    XIF_ERP_SALES_RESULT_R_SN XIF WITH(NOLOCK)  
			LEFT OUTER JOIN (   
				SELECT ERP_SO_NO, MAX(TO_SITE) AS TO_SITE, DIVISION_ID 
				--FROM SSP_ANL_SHIP_CONFIRM
				FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)  
				WHERE ERP_SO_NO IS NOT NULL
				GROUP BY ERP_SO_NO, DIVISION_ID
			) SSP ON SSP.ERP_SO_NO = REPLICATE('0', 10-LEN(RTRIM(XIF.SO_NO))) + RTRIM(XIF.SO_NO) AND SSP.DIVISION_ID = XIF.DIVISION_ID  
			LEFT OUTER JOIN (	SELECT DISTINCT SEGMENT2 AS AS_ITEM
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
								WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
									AND VALID_YN		= N'Y'
								UNION 
								SELECT DISTINCT SEGMENT3 AS AS_ITEM
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
								WHERE LOOKUP_TYPE	= N'DM_R_ITEM_ID'
									AND VALID_YN		= N'Y'
								) B ON XIF.ITEM_ID = B.AS_ITEM
		WHERE  1=1   
		--ifseqno       = @v_ifseqno  -- [C20201103-000150]
		-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
		AND sales_posting_date >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
		-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
		AND     transfer_flag = 'P'  
		
		GROUP BY  company_id,XIF.division_id,sales_type,sales_dept,sales_work_place,sales_work_place_name,sales_group,sales_group_name,sales_posting_date
			,cost_item,cost_item_name,sales_type_2,valuation_class,item_type,customer_code,customer_name,customer_project_name,customer_item_name,XIF.biz_type
			,XIF.project_code,project_name,cell_type,car_model,qty_cell_by_pack,z_type,z_code,sales_region,distribution_channel,lgs_route_name,connect_name
			,car_qty,cell_qty,sales_price,currency,uom,sales_user,sales_user_name,mat_group,mat_group_desc,XIF.item_id,biz_type_2,app,usage,sales_team
			,ess_pm,plant_id,shipto_code,shipto_description,country,country_name,shipto_city_name,shipto_zone_code,shipto_zone_name,rbu_customer,XIF.incoterms
			,profit_center_id,profit_center_name,partner_profit_center_id,partner_profit_center_name,item_text,affiliate_code,customer_group_code,customer_group_name
			,cell_code,delegate_model_id,delegate_model_name,c_p_model_id,c_p_model_name,lrregular_code,lrregular_name,machine_code,machine_name,line_id,line_name
			,tco,system_input_date,system_input_time,ifseqno,transfer_flag,result_yyyymm  
			, DOC_CURRENCY, SO_NO
			, ATTRIBUTE1

		) A */
	/*[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START 
	--해당 로직 주석처리
	PIVOT (
		MAX(SO_NO) FOR SO_NO_ROW_NUM IN ( [SN1], [SN2], [SN3], [SN4], [SN5], [SN6], [SN7], [SN8], [SN9], [SN10] ,[SN11], [SN12], [SN13], [SN14], [SN15], [SN16], [SN17], [SN18], [SN19], [SN20]
									,[SN21], [SN22], [SN23], [SN24], [SN25], [SN26], [SN27], [SN28], [SN29], [SN30],[SN31], [SN32], [SN33], [SN34], [SN35], [SN36], [SN37], [SN38], [SN39], [SN40]
									,[SN41], [SN42], [SN43], [SN44], [SN45], [SN46], [SN47], [SN48], [SN49], [SN50],[SN51], [SN52], [SN53], [SN54], [SN55], [SN56], [SN57], [SN58], [SN59], [SN60]
									,[SN61], [SN62], [SN63], [SN64], [SN65], [SN66], [SN67], [SN68], [SN69], [SN70],[SN71], [SN72], [SN73], [SN74], [SN75], [SN76], [SN77], [SN78], [SN79], [SN80]
									,[SN81], [SN82], [SN83], [SN84], [SN85], [SN86], [SN87], [SN88], [SN89], [SN90],[SN91], [SN92], [SN93], [SN94], [SN95], [SN96], [SN97], [SN98], [SN99], [SN100]
									,[SN101], [SN102], [SN103], [SN104], [SN105], [SN106], [SN107], [SN108], [SN109], [SN110],[SN111], [SN112], [SN113], [SN114], [SN115], [SN116], [SN117], [SN118], [SN119], [SN120]
									,[SN121], [SN122], [SN123], [SN124], [SN125], [SN126], [SN127], [SN128], [SN129], [SN130],[SN131], [SN132], [SN133], [SN134], [SN135], [SN136], [SN137], [SN138], [SN139], [SN140]
									,[SN141], [SN142], [SN143], [SN144], [SN145], [SN146], [SN147], [SN148], [SN149], [SN150],[SN151], [SN152], [SN153], [SN154], [SN155], [SN156], [SN157], [SN158], [SN159], [SN160]
									,[SN161], [SN162], [SN163], [SN164], [SN165], [SN166], [SN167], [SN168], [SN169], [SN170],[SN171], [SN172], [SN173], [SN174], [SN175], [SN176], [SN177], [SN178], [SN179], [SN180]
									,[SN181], [SN182], [SN183], [SN184], [SN185], [SN186], [SN187], [SN188], [SN189], [SN190],[SN191], [SN192], [SN193], [SN194], [SN195], [SN196], [SN197], [SN198], [SN199], [SN200] 
									,[SN201], [SN202], [SN203], [SN204], [SN205], [SN206], [SN207], [SN208], [SN209], [SN210],[SN211], [SN212], [SN213], [SN214], [SN215], [SN216], [SN217], [SN218], [SN219], [SN220]
									,[SN221], [SN222], [SN223], [SN224], [SN225], [SN226], [SN227], [SN228], [SN229], [SN230],[SN231], [SN232], [SN233], [SN234], [SN235], [SN236], [SN237], [SN238], [SN239], [SN240]
									,[SN241], [SN242], [SN243], [SN244], [SN245], [SN246], [SN247], [SN248], [SN249], [SN250],[SN251], [SN252], [SN253], [SN254], [SN255], [SN256], [SN257], [SN258], [SN259], [SN260]
									,[SN261], [SN262], [SN263], [SN264], [SN265], [SN266], [SN267], [SN268], [SN269], [SN270],[SN271], [SN272], [SN273], [SN274], [SN275], [SN276], [SN277], [SN278], [SN279], [SN280]
									,[SN281], [SN282], [SN283], [SN284], [SN285], [SN286], [SN287], [SN288], [SN289], [SN290],[SN291], [SN292], [SN293], [SN294], [SN295], [SN296], [SN297], [SN298], [SN299], [SN300]  )
		) AS PVT1 --[C20210225-000385] Key 값 기준으로 최대 300개 SO_NO를 갖을 수 있음
	PIVOT (
		SUM(SO_QTY) FOR SO_QTY_ROW_NUM IN ( [SQ1], [SQ2], [SQ3], [SQ4], [SQ5], [SQ6], [SQ7], [SQ8], [SQ9], [SQ10] ,[SQ11], [SQ12], [SQ13], [SQ14], [SQ15], [SQ16], [SQ17], [SQ18], [SQ19], [SQ20]
									,[SQ21], [SQ22], [SQ23], [SQ24], [SQ25], [SQ26], [SQ27], [SQ28], [SQ29], [SQ30],[SQ31], [SQ32], [SQ33], [SQ34], [SQ35], [SQ36], [SQ37], [SQ38], [SQ39], [SQ40]
									,[SQ41], [SQ42], [SQ43], [SQ44], [SQ45], [SQ46], [SQ47], [SQ48], [SQ49], [SQ50],[SQ51], [SQ52], [SQ53], [SQ54], [SQ55], [SQ56], [SQ57], [SQ58], [SQ59], [SQ60]
									,[SQ61], [SQ62], [SQ63], [SQ64], [SQ65], [SQ66], [SQ67], [SQ68], [SQ69], [SQ70],[SQ71], [SQ72], [SQ73], [SQ74], [SQ75], [SQ76], [SQ77], [SQ78], [SQ79], [SQ80]
									,[SQ81], [SQ82], [SQ83], [SQ84], [SQ85], [SQ86], [SQ87], [SQ88], [SQ89], [SQ90],[SQ91], [SQ92], [SQ93], [SQ94], [SQ95], [SQ96], [SQ97], [SQ98], [SQ99], [SQ100]  
									,[SQ101], [SQ102], [SQ103], [SQ104], [SQ105], [SQ106], [SQ107], [SQ108], [SQ109], [SQ110],[SQ111], [SQ112], [SQ113], [SQ114], [SQ115], [SQ116], [SQ117], [SQ118], [SQ119], [SQ120]
									,[SQ121], [SQ122], [SQ123], [SQ124], [SQ125], [SQ126], [SQ127], [SQ128], [SQ129], [SQ130],[SQ131], [SQ132], [SQ133], [SQ134], [SQ135], [SQ136], [SQ137], [SQ138], [SQ139], [SQ140]
									,[SQ141], [SQ142], [SQ143], [SQ144], [SQ145], [SQ146], [SQ147], [SQ148], [SQ149], [SQ150],[SQ151], [SQ152], [SQ153], [SQ154], [SQ155], [SQ156], [SQ157], [SQ158], [SQ159], [SQ160]
									,[SQ161], [SQ162], [SQ163], [SQ164], [SQ165], [SQ166], [SQ167], [SQ168], [SQ169], [SQ170],[SQ171], [SQ172], [SQ173], [SQ174], [SQ175], [SQ176], [SQ177], [SQ178], [SQ179], [SQ180]
									,[SQ181], [SQ182], [SQ183], [SQ184], [SQ185], [SQ186], [SQ187], [SQ188], [SQ189], [SQ190],[SQ191], [SQ192], [SQ193], [SQ194], [SQ195], [SQ196], [SQ197], [SQ198], [SQ199], [SQ200] 
									,[SQ201], [SQ202], [SQ203], [SQ204], [SQ205], [SQ206], [SQ207], [SQ208], [SQ209], [SQ210],[SQ211], [SQ212], [SQ213], [SQ214], [SQ215], [SQ216], [SQ217], [SQ218], [SQ219], [SQ220]
									,[SQ221], [SQ222], [SQ223], [SQ224], [SQ225], [SQ226], [SQ227], [SQ228], [SQ229], [SQ230],[SQ231], [SQ232], [SQ233], [SQ234], [SQ235], [SQ236], [SQ237], [SQ238], [SQ239], [SQ240]
									,[SQ241], [SQ242], [SQ243], [SQ244], [SQ245], [SQ246], [SQ247], [SQ248], [SQ249], [SQ250],[SQ251], [SQ252], [SQ253], [SQ254], [SQ255], [SQ256], [SQ257], [SQ258], [SQ259], [SQ260]
									,[SQ261], [SQ262], [SQ263], [SQ264], [SQ265], [SQ266], [SQ267], [SQ268], [SQ269], [SQ270],[SQ271], [SQ272], [SQ273], [SQ274], [SQ275], [SQ276], [SQ277], [SQ278], [SQ279], [SQ280]
									,[SQ281], [SQ282], [SQ283], [SQ284], [SQ285], [SQ286], [SQ287], [SQ288], [SQ289], [SQ290],[SQ291], [SQ292], [SQ293], [SQ294], [SQ295], [SQ296], [SQ297], [SQ298], [SQ299], [SQ300] )
		) AS PVT2  --[C20210225-000385] Key 값 기준으로 최대 300개 SO_QTY를 갖을 수 있음	
	[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END 
	*/
	GROUP BY  company_id,division_id,sales_type,sales_dept,sales_work_place,sales_work_place_name,sales_group,sales_group_name,sales_posting_date
		,cost_item,cost_item_name,sales_type_2,valuation_class,item_type,customer_code,customer_name,customer_project_name,customer_item_name,biz_type
		,project_code,project_name,cell_type,car_model,qty_cell_by_pack,z_type,z_code,sales_region,distribution_channel,lgs_route_name,connect_name
		,car_qty,cell_qty,sales_price,currency,uom,sales_user,sales_user_name,mat_group,mat_group_desc,item_id,biz_type_2,app,usage,sales_team
		,ess_pm,plant_id,shipto_code,shipto_description,country,country_name,shipto_city_name,shipto_zone_code,shipto_zone_name,rbu_customer,incoterms
		,profit_center_id,profit_center_name,partner_profit_center_id,partner_profit_center_name,item_text,affiliate_code,customer_group_code,customer_group_name
		,cell_code,delegate_model_id,delegate_model_name,c_p_model_id,c_p_model_name,lrregular_code,lrregular_name,machine_code,machine_name,line_id,line_name
		,tco,system_input_date,system_input_time,ifseqno,transfer_flag,result_yyyymm  
		, DOC_CURRENCY
		, ATTRIBUTE1	--[C20210316-000434]
		, FROM_COMPANY_ID 							-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (FROM_SELL_DOC, FROM_SHIP_NO 는 STUFF 처리하므로 GROUP BY 제외)
		SET @n_update_cnt = @@ROWCOUNT; --[E20240814-000938] Row Count 확인(#XIF_ERP_SALES_RESULT_R_SN_TMP)
    END
	
	--SM 20240801 시간소요 확인위해 LOG 삽입 추가 
	-----------------------------------------------------------  
	-- INSERT LOG  
	-----------------------------------------------------------  
	SET @v_log_type    = 'APPEND';  
	SET @v_log_message = 'INSERT INTO #XIF_ERP_SALES_RESULT_R_SN_TMP';  
	SET @v_description = 'Check Time';  
	SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	-----------------------------------------------------------  

	
	---------------------------------------------------------------------------------------------------------
	--[IT20250117A] NERP 오픈차수별 Mapping Code적용	START	
	---------------------------------------------------------------------------------------------------------

	
    DECLARE @V_NERP_ROLLIN_STAGE NVARCHAR(30); --NERP Open 차수
    DECLARE @V_NERP_RESULT_START_YYYYMMDD NVARCHAR(8);

    SELECT TOP 1 @V_NERP_ROLLIN_STAGE = LMD.SEGMENT1
	      , @V_NERP_RESULT_START_YYYYMMDD = LMD.SEGMENT3
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK)
    WHERE  LMD.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
    AND    LMD.VALID_YN = 'Y'
	;

	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START	/ 현재 NERP 적용차수 체크하여 NERP 적용 이전의 법인은 OLD_CODE로 변환함 
	-- [PJ2025-50188] FROM_COMPANY_ID는 NERP에서 IF되는 데이터로 추정 (모든 데이터가 NEW_CODE 로 들어오고 있으므로 현재 ROLL-OUT 법인은 OLD_CODE로 역변환 처리)
	UPDATE A
	SET A.FROM_COMPANY_ID = B.OLD_VALUE1
	--FROM #XIF_SALES_RESULT_SO_NO_TMP A WITH(NOLOCK)
	FROM #XIF_ERP_SALES_RESULT_R_SN_TMP A WITH(NOLOCK)
	INNER JOIN 
	(
		SELECT OLD_VALUE1, NEW_VALUE1, ATTRIBUTE5
		FROM NERP_CONV_MASTER WITH(NOLOCK)
		WHERE CODETYPE = 'COMPANY_ID'
		AND   ATTRIBUTE5 > @V_NERP_ROLLIN_STAGE
	) B
	ON	A.FROM_COMPANY_ID = B.NEW_VALUE1
	WHERE 1=1
	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END



    DECLARE @T_COMPANY_ID TABLE (
        OLD_COMPANY_ID  NVARCHAR(254) NOT NULL PRIMARY KEY
        ,NEW_COMPANY_ID  NVARCHAR(254) 
        ,MAX_ATTRIBUTE5 NVARCHAR(30)
    );

    INSERT INTO @T_COMPANY_ID
    SELECT OLD_VALUE1, NEW_VALUE1, MAX(ATTRIBUTE5) AS ATTRIBUTE5
    FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
    WHERE  NCM.CODETYPE = 'COMPANY_ID'
    AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
    GROUP BY OLD_VALUE1, NEW_VALUE1
	;


	--2025.06.30 park.choyi NERP 오픈법인  중복방지를 위해 '@V_NERP_RESULT_START_YYYYMMDD 이전 NERP 데이터 삭제, @V_NERP_RESULT_START_YYYYMMDD 이후 GERP 데이터 삭제' Start
	--@V_NERP_RESULT_START_YYYYMMDD 이전 NERP 데이터 삭제
	DELETE
	FROM   #XIF_ERP_SALES_RESULT_R_SN_TMP
	WHERE  COMPANY_ID IN (SELECT DISTINCT NEW_COMPANY_ID FROM @T_COMPANY_ID WHERE MAX_ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE )
	AND    SALES_POSTING_DATE < @V_NERP_RESULT_START_YYYYMMDD
	;
			
	----------------------------------------------------------------------------------------------------------------------
	SET @n_update_cnt = @@ROWCOUNT;

	SET @v_log_type    = 'APPEND';  
	SET @v_log_message = N'Delete NERP Result';  
	SET @d_event_date  = @d_start_date;
	SET @n_log_count   = @n_update_cnt;
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	----------------------------------------------------------------------------------------------------------------------
		
	--@V_NERP_RESULT_START_YYYYMMDD 이후 GERP 데이터 삭제
	DELETE
	FROM   #XIF_ERP_SALES_RESULT_R_SN_TMP
	WHERE  COMPANY_ID IN (SELECT DISTINCT OLD_COMPANY_ID FROM @T_COMPANY_ID WHERE MAX_ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE )
	AND    SALES_POSTING_DATE >= @V_NERP_RESULT_START_YYYYMMDD
	;	
	----------------------------------------------------------------------------------------------------------------------
	SET @n_update_cnt = @@ROWCOUNT;

	SET @v_log_type    = 'APPEND';  
	SET @v_log_message = N'Delete GERP Result';  
	SET @d_event_date  = @d_start_date;
	SET @n_log_count   = @n_update_cnt;
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	----------------------------------------------------------------------------------------------------------------------
	--2025.06.30 park.choyi NERP 2차 오픈법인 기준으로 중복방지를 위해 '7/1일 이전 NERP 데이터 삭제, 7/1일 이후 GERP 데이터 삭제' End

	UPDATE A
	SET   A.COMPANY_ID		= ISNULL( B.NEW_COMPANY_ID, A.COMPANY_ID)
		, A.CUSTOMER_CODE	= ISNULL( C.NEW_CUSTOMER_ID, A.CUSTOMER_CODE)
		, A.PLANT_ID		= ISNULL( D.NEW_PLANT_ID, A.PLANT_ID )
		, A.SALES_DEPT		= ISNULL( E.NEW_SALES_DEPT, A.SALES_DEPT)
		, A.SHIPTO_CODE		= ISNULL( F.NEW_SHIPTO_CODE, A.SHIPTO_CODE )
	FROM #XIF_ERP_SALES_RESULT_R_SN_TMP A WITH(NOLOCK)
	INNER JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_COMPANY_ID, NEW_VALUE1 AS NEW_COMPANY_ID
					FROM  NERP_CONV_MASTER WITH(NOLOCK)
					WHERE CODETYPE  = 'COMPANY_ID'
					AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) B
	ON A.COMPANY_ID = B.OLD_COMPANY_ID
	LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_CUSTOMER_ID, NEW_VALUE1 AS NEW_CUSTOMER_ID
				FROM  NERP_CONV_MASTER WITH(NOLOCK)
				WHERE CODETYPE  = 'END_CUSTOMER_ID'
				AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) C
	ON A.CUSTOMER_CODE = C.OLD_CUSTOMER_ID
	LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_PLANT_ID, NEW_VALUE1 AS NEW_PLANT_ID
				FROM  NERP_CONV_MASTER WITH(NOLOCK)
				WHERE CODETYPE  = 'PLANT_ID'
				AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) D
	ON A.PLANT_ID = D.OLD_PLANT_ID
	LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_SALES_DEPT, NEW_VALUE1 AS NEW_SALES_DEPT
				FROM  NERP_CONV_MASTER WITH(NOLOCK)
				WHERE CODETYPE  = 'COMPANY_ID'
				AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) E
	ON A.SALES_DEPT = E.OLD_SALES_DEPT
	LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_SHIPTO_CODE, NEW_VALUE1 AS NEW_SHIPTO_CODE
				FROM  NERP_CONV_MASTER WITH(NOLOCK)
				WHERE CODETYPE  = 'END_CUSTOMER_ID'
				AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) F
	ON A.SHIPTO_CODE = F.OLD_SHIPTO_CODE

	;
	----------------------------------------------------------------------------------------------------------------------
	SET @n_update_cnt = @@ROWCOUNT;

	SET @v_log_type    = 'APPEND';  
	SET @v_log_message = N'Update GERP Code';  
	SET @d_event_date  = @d_start_date;
	SET @n_log_count   = @n_update_cnt;
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	----------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	--[IT20250117A] NERP 오픈차수별 Mapping Code적용 END		
	---------------------------------------------------------------------------------------------------------


    --GM JV. 81_GM 사이트가 있을 경우 DIVISION_ID 를 업데이트 해준다.
    UPDATE A
    SET DIVISION_ID = B.DIVISION_ID
    FROM #XIF_ERP_SALES_RESULT_R_SN_TMP A
    JOIN (
        SELECT A.SHIPTO_CODE, A.SOLDTO_CODE, C.ORI_DIVISION_ID, A.DIVISION_ID
			 , B.COMPANY_ID	-- 20231012 [E20230927-000826]SCM.DM 실적 매핑 Sold to, Ship to 코드 외 COMPANY_ID 조건추가
        FROM SCM_MST_SITE_CUSTOMER A WITH (NOLOCK)
        JOIN SCM_MST_SITE B WITH (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
        JOIN (  SELECT DIVISION_ID, ATTRIBUTE3 AS ORI_DIVISION_ID
                FROM SCM_MST_DIVISION WITH (NOLOCK)
                WHERE ATTRIBUTE3 IN ( '40', '81', '82' )
                    AND DIVISION_ID <> ATTRIBUTE3
            ) C ON A.DIVISION_ID = C.DIVISION_ID
        WHERE A.VALID_YN = 'Y'
            AND B.VALID_YN = 'Y'
        ) B ON A.DIVISION_ID = B.ORI_DIVISION_ID
            AND A.CUSTOMER_CODE = B.SOLDTO_CODE
            AND A.SHIPTO_CODE = B.SHIPTO_CODE
            AND A.COMPANY_ID = B.COMPANY_ID	-- 20231012 [E20230927-000826]SCM.DM 실적 매핑 Sold to, Ship to 코드 외 COMPANY_ID 조건추가

PRINT 'temp create :' + CONVERT(NVARCHAR(50), GETDATE(), 121)

		-- I/F 대상  
		DECLARE cur_sales CURSOR FOR  
		SELECT ifseqno  
			,CONCAT(MIN(result_yyyymm), '01') result_yyyymm_from  
			,CONCAT(MAX(result_yyyymm), '31') result_yyyymm_to        
		FROM   #XIF_ERP_SALES_RESULT_R_SN_TMP WITH(NOLOCK) --(2020.12.01) FROM   xif_erp_sales_result_r_sn WITH(NOLOCK)  
		--WHERE  transfer_flag = 'P'  --[E20240814-000938] 속도개선을 위해 TRANSFER_FLAG = 'P' 조건 제외
		GROUP BY ifseqno  
		ORDER BY ifseqno ASC;  

		OPEN cur_sales;  
		FETCH NEXT FROM cur_sales INTO @v_ifseqno, @v_yyyymmdd_from, @v_yyyymmdd_to;  
       
		WHILE (@@FETCH_STATUS = 0)  
		BEGIN  
  
			-- [과제] 리콜 무상매출 수량 I/F, 룩업테이블 관리 연계
			-- SEGMENT2 는 유효한 MODEL 이어야 한다.
			UPDATE A
			SET ITEM_ID		= B.SEGMENT2
			FROM #XIF_ERP_SALES_RESULT_R_SN_TMP A
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  WITH (NOLOCK)
					ON A.DIVISION_ID	= B.SEGMENT1
					AND A.ITEM_ID		= B.SEGMENT3
					AND B.LOOKUP_TYPE	= N'DM_R_ITEM_ID'
					AND B.VALID_YN		= N'Y'
			--[E20240814-000938] 속도개선을 위해 DM_MST_ITEM_SINGLE_V TEMP에 넣음
			--JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK) ON B.SEGMENT1 = C.DIVISION_ID AND B.SEGMENT2 = C.ITEM_ID
			JOIN #TEMP_DM_MST_ITEM_SINGLE_V C WITH (NOLOCK) ON B.SEGMENT1 = C.DIVISION_ID AND B.SEGMENT2 = C.ITEM_ID			
			

			-- 지난달 1일부터 어제 날짜까지의 실적이 인터페이스 되므로, 해당 데이터는 삭제후 다시 처리     
			DELETE   
			FROM   DM_DNM_SALES_RESULT_IF  
			WHERE  SALES_POSTING_DATE BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
			AND SALES_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
			-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 START
			-- NERP에서 더이상 12월 데이터를 넣어주지 않으나, 현재 구조는 전달 데이터를 모두 지워 실적이 사라지는 현상으로 해당 조치함.
			-- AND COMPANY_ID NOT IN ('WA00', 'HQ00')					--2025.06.30 park.choyi 삭제
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 END
			;  
			
			--2025.06.30 park.choyi 삭제 Start
			/*
			-- 20250106 JSSBAE WA00인 경우의 데이터는 20250101이후 데이터만 삭제하도록 한다. START			
			DELETE   
			FROM   DM_DNM_SALES_RESULT_IF  
			WHERE  SALES_POSTING_DATE BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
			AND SALES_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
			-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 START
			-- NERP에서 더이상 12월 데이터를 넣어주지 않으나, 현재 구조는 전달 데이터를 모두 지워 실적이 사라지는 현상으로 해당 조치함.
			AND COMPANY_ID IN ('WA00', 'HQ00')					
			AND SALES_POSTING_DATE >= '20250101'
			;  -- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 END			
			*/
			--2025.06.30 park.choyi 삭제 End
		  -----------------------------------------------------------  
          -- dm_dnm_sales_result_if INSERT <<<< TEMP TALBE (2020.12.01)  
          -----------------------------------------------------------  
			INSERT INTO DM_DNM_SALES_RESULT_IF  (
				company_id  ,division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  
				,sales_group_name  ,sales_yyyymm  ,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  
				,item_type  ,customer_code  ,customer_name  ,customer_project_name  ,customer_item_name  ,biz_type  ,origin_project_code  
				,origin_project_name  ,cell_type  ,car_model  ,qty_cell_by_pack  ,z_type  ,z_code  ,sales_region  ,distribution_channel  
				,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  ,currency  ,sales_amount_for  ,sales_amount_sum  
				,uom  ,sales_qty  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,origin_item_id  ,biz_type_2  ,app  
				,usage  ,sales_team  ,ess_pm  ,plant_id  ,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  
				,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  ,origin_incoterms  ,profit_center_id  ,profit_center_name  
				,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  ,customer_group_code  ,customer_group_name  
				,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  ,lrregular_code  ,lrregular_name  
				,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time  ,project_code  
				,plant_site_id  ,sales_site_id  ,item_id  ,fcst_type  ,incoterms  ,creation_date  ,created_by  ,last_update_date  
				,last_updated_by  ,ATTRIBUTE3, ATTRIBUTE4, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				,FROM_COMPANY_ID, FROM_SELL_DOC, FROM_SHIP_NO 			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)  
			SELECT  company_id,division_id,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  
				,sales_group_name  ,LEFT(sales_posting_date, 6)  ,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  
				,valuation_class  ,item_type  ,customer_code  ,customer_name  ,customer_project_name  ,customer_item_name  ,biz_type  
				,project_code as origin_project_code  ,project_name as origin_project_name  ,cell_type  ,car_model  ,qty_cell_by_pack  
				,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty,sales_price  
				-- [C20201103-000150]
                -- 2025.10.21 김준규 [IT20250117A] RMB를 CNY로 Currency변경 시작
				--, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN REPLACE(CURRENCY, 'CNY', 'RMB') 
				--		-- [C20211013-000459] 소형 사업부의 20211101 이후 일때 판매가 통화
				--		WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40' THEN REPLACE(DOC_CURRENCY, 'CNY', 'RMB')
				--		WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN REPLACE(CURRENCY, 'CNY', 'RMB')		-- [C20210506-000350]
				--		ELSE -- [C20210315-000140] DOC_CURRENCY 
				--			REPLACE(DOC_CURRENCY, 'CNY', 'RMB') 
				--		END
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN REPLACE(CURRENCY, 'CNY', 'CNY') 
						-- [C20211013-000459] 소형 사업부의 20211101 이후 일때 판매가 통화
						WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40' THEN REPLACE(DOC_CURRENCY, 'CNY', 'CNY')
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN REPLACE(CURRENCY, 'CNY', 'CNY')		-- [C20210506-000350]
						ELSE -- [C20210315-000140] DOC_CURRENCY 
							REPLACE(DOC_CURRENCY, 'CNY', 'CNY') 
						END
                -- 2025.10.21 김준규 [IT20250117A] RMB를 CNY로 Currency변경 종료
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_for 
						-- [C20211013-000459] 소형 사업부의 20211101 이후일때 판매가 외화 
						WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40' THEN DOC_AMT_FOR
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN 
									CASE WHEN sales_amount_for <> 0 THEN sales_amount_for ELSE sales_amount_sum END					-- [C20210506-000350]
						ELSE DOC_AMT_FOR END
				--[C20210201-000116] 해외법인 원화(Company id가 'G'로 시작)는 DOC_AMT_KRW 대신 sales_amount_sum 사용
				--, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_sum ELSE DOC_AMT_KRW END
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_sum
						-- [C20211013-000459] 소형 사업부의 20211101 이후 일때 원가 원화
                        WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40'  THEN sales_amount_sum	
						WHEN /* SALES_POSTING_DATE >= '20211001' AND */ SALES_QTY < 0 AND SALES_AMOUNT_SUM < 0 AND SALES_AMOUNT_FOR < 0 THEN SALES_AMOUNT_SUM
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN sales_amount_sum					-- [C20210506-000350]
			            --WHEN  COMPANY_ID = 'G540' AND SHIPTO_CODE <> 'G540' THEN DOC_AMT_KRW
						WHEN  COMPANY_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'COMPANY_ID')) --[PJ20228272] NERP 대응
						AND  SHIPTO_CODE NOT IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'SHIPTO_CODE_01')) --[PJ20228272] NERP 대응
						THEN DOC_AMT_KRW
						--WHEN  COMPANY_ID LIKE 'G%'  THEN SALES_AMOUNT_SUM
						WHEN  COMPANY_ID NOT IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'COMPANY_ID_HQ')) --[PJ20228272] NERP 대응  
						THEN SALES_AMOUNT_SUM
						ELSE DOC_AMT_KRW END
				--,CASE WHEN CURRENCY = 'CNY' THEN 'RMB' 
				--	ELSE CURRENCY 
				--	END AS CURRENCY  -- 20190125 KHSONG 국내 ERP 매출 Data의 Currency정보중 CNY -> RMB 로 전환  
				--,sales_amount_for  
				--,sales_amount_sum  
				,uom  ,sales_qty  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,item_id    as origin_item_id  
				,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  ,shipto_code  ,shipto_description  ,country  
				,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  ,incoterms   as origin_incoterms  
				,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  
				,affiliate_code  ,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  
				,c_p_model_id  ,c_p_model_name  ,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  
				,line_name  ,tco  ,system_input_date  ,system_input_time  ,DBO.FN_SCM_SYS_NVL(project_code, '') project_code  
				,CASE WHEN division_id LIKE '81%' THEN DBO.FN_SCM_SYS_NVL(  DBO.FN_GET_SCM_SITE_ID_PLANT(plant_id, DBO.FN_GET_ITEM_OPERATION_GROUP(division_id, item_id)),plant_id)  
									ELSE ''    
									END  plant_site_id  
				,'' as sales_site_id  
				-- Modifieyd 18-11-08 상품에 대해서 pack 대표 코드를 찾지 못해서 변경 함.  
				-- ,DBO.FN_SCM_SYS_NVL(DBO.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id), 'ETC') item_id  
				--SM 20240801 하단 두 테이블에 WITH (NOLOCK) 구문이 없어 추가
				,ISNULL( CASE	WHEN DIVISION_ID = '40' AND SUBSTRING(item_id,1,2) = 'MP' 
									THEN  ISNULL( ( SELECT TOP 1 ITEM_ID 
													FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK), SCM_MST_SITE S WITH(NOLOCK)
													WHERE SI.DIVISION_ID = S.division_id 
														AND SI.SCM_SITE_ID = S.SCM_SITE_ID 
														AND SI.DIVISION_ID = k.DIVISION_ID  
														AND S.SITE_TYPE = 'SALES' 
														AND SI.ITEM_ID LIKE SUBSTRING( k.ITEM_ID,1,11)+'%')
												, K.ITEM_ID)  
								WHEN k.item_id = '' 
									THEN 'ETC'  
								ELSE item_id 
							END , 'ETC'
						) item_id2  		
				--[C20210316-000434] fcst type 로직 변경
				, CASE	WHEN ATTRIBUTE1 <> '' THEN ATTRIBUTE1
						WHEN sales_type_2 in ('A/S',N'샘플') THEN sales_type_2   
						ELSE DBO.FN_GET_FCST_TYPE(sales_type_2)   
					END as fcst_type  --[CSR ID:4001986] 'A/S','샘플'인 경우 sales_type2를 셋팅함.  
				,incoterms  ,GETDATE()  ,@v_batch_user  ,GETDATE()  ,@v_batch_user  
				, ATTRIBUTE3
				, ATTRIBUTE4
				, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				, FROM_COMPANY_ID, FROM_SELL_DOC, FROM_SHIP_NO			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM    #XIF_ERP_SALES_RESULT_R_SN_TMP k WITH(NOLOCK)--  (2020.12.01) XIF_ERP_SALES_RESULT_R_SN k WITH(NOLOCK)  
			WHERE   ifseqno       = @v_ifseqno  
				-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
				--AND SALES_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
				-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
				--AND     TRANSFER_FLAG = 'P' --[E20240814-000938] 속도개선을 위해 TRANSFER_FLAG = 'P' 조건 제외
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 START
			-- NERP에서 더이상 12월 데이터를 넣어주지 않으나, 현재 구조는 전달 데이터를 모두 지워 실적이 사라지는 현상으로 해당 조치함
			-- AND COMPANY_ID NOT IN ('WA00', 'HQ00')					--2025.06.30 park.choyi 삭제
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 END
			;  

			
			--2025.06.30 park.choyi 삭제 Start
			/*
			-- 20250106 JSSBAE WA00인 경우의 데이터는 20250101이후 데이터만 적재하도록 한다. START		
			INSERT INTO DM_DNM_SALES_RESULT_IF  (
				company_id  ,division_id  ,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  
				,sales_group_name  ,sales_yyyymm  ,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  ,valuation_class  
				,item_type  ,customer_code  ,customer_name  ,customer_project_name  ,customer_item_name  ,biz_type  ,origin_project_code  
				,origin_project_name  ,cell_type  ,car_model  ,qty_cell_by_pack  ,z_type  ,z_code  ,sales_region  ,distribution_channel  
				,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty  ,sales_price  ,currency  ,sales_amount_for  ,sales_amount_sum  
				,uom  ,sales_qty  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,origin_item_id  ,biz_type_2  ,app  
				,usage  ,sales_team  ,ess_pm  ,plant_id  ,shipto_code  ,shipto_description  ,country  ,country_name  ,shipto_city_name  
				,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  ,origin_incoterms  ,profit_center_id  ,profit_center_name  
				,partner_profit_center_id  ,partner_profit_center_name  ,item_text  ,affiliate_code  ,customer_group_code  ,customer_group_name  
				,cell_code  ,delegate_model_id  ,delegate_model_name  ,c_p_model_id  ,c_p_model_name  ,lrregular_code  ,lrregular_name  
				,machine_code  ,machine_name  ,line_id  ,line_name  ,tco  ,system_input_date  ,system_input_time  ,project_code  
				,plant_site_id  ,sales_site_id  ,item_id  ,fcst_type  ,incoterms  ,creation_date  ,created_by  ,last_update_date  
				,last_updated_by  ,ATTRIBUTE3, ATTRIBUTE4, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				,FROM_COMPANY_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)  
			SELECT  company_id,division_id,sales_type  ,sales_dept  ,sales_work_place  ,sales_work_place_name  ,sales_group  
				,sales_group_name  ,LEFT(sales_posting_date, 6)  ,sales_posting_date  ,cost_item  ,cost_item_name  ,sales_type_2  
				,valuation_class  ,item_type  ,customer_code  ,customer_name  ,customer_project_name  ,customer_item_name  ,biz_type  
				,project_code as origin_project_code  ,project_name as origin_project_name  ,cell_type  ,car_model  ,qty_cell_by_pack  
				,z_type  ,z_code  ,sales_region  ,distribution_channel  ,lgs_route_name  ,connect_name  ,car_qty  ,cell_qty,sales_price  
				-- [C20201103-000150]
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN REPLACE(CURRENCY, 'CNY', 'RMB') 
						-- [C20211013-000459] 소형 사업부의 20211101 이후 일때 판매가 통화
						WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40' THEN REPLACE(DOC_CURRENCY, 'CNY', 'RMB')
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN REPLACE(CURRENCY, 'CNY', 'RMB')		-- [C20210506-000350]
						ELSE -- [C20210315-000140] DOC_CURRENCY 
							REPLACE(DOC_CURRENCY, 'CNY', 'RMB') 
						END
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_for 
						-- [C20211013-000459] 소형 사업부의 20211101 이후일때 판매가 외화 
						WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40' THEN DOC_AMT_FOR
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN 
									CASE WHEN sales_amount_for <> 0 THEN sales_amount_for ELSE sales_amount_sum END					-- [C20210506-000350]
						ELSE DOC_AMT_FOR END
				--[C20210201-000116] 해외법인 원화(Company id가 'G'로 시작)는 DOC_AMT_KRW 대신 sales_amount_sum 사용
				--, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_sum ELSE DOC_AMT_KRW END
				, CASE WHEN SALES_POSTING_DATE <= '20210103' THEN sales_amount_sum
						-- [C20211013-000459] 소형 사업부의 20211101 이후 일때 원가 원화
                        WHEN SALES_POSTING_DATE >= '20211101' AND division_id = '40'  THEN sales_amount_sum	
						WHEN /* SALES_POSTING_DATE >= '20211001' AND */ SALES_QTY < 0 AND SALES_AMOUNT_SUM < 0 AND SALES_AMOUNT_FOR < 0 THEN SALES_AMOUNT_SUM
						WHEN SALES_POSTING_DATE >= '20210501' AND division_id = '40' AND sales_amount_sum <> 0 AND DOC_AMT_KRW = 0 THEN sales_amount_sum					-- [C20210506-000350]
			            --WHEN  COMPANY_ID = 'G540' AND SHIPTO_CODE <> 'G540' THEN DOC_AMT_KRW
						WHEN  COMPANY_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'COMPANY_ID')) --[PJ20228272] NERP 대응
						AND  SHIPTO_CODE NOT IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'SHIPTO_CODE_01')) --[PJ20228272] NERP 대응
						THEN DOC_AMT_KRW
						--WHEN  COMPANY_ID LIKE 'G%'  THEN SALES_AMOUNT_SUM
						WHEN  COMPANY_ID NOT IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'COMPANY_ID_HQ')) --[PJ20228272] NERP 대응  
						THEN SALES_AMOUNT_SUM
						ELSE DOC_AMT_KRW END
				--,CASE WHEN CURRENCY = 'CNY' THEN 'RMB' 
				--	ELSE CURRENCY 
				--	END AS CURRENCY  -- 20190125 KHSONG 국내 ERP 매출 Data의 Currency정보중 CNY -> RMB 로 전환  
				--,sales_amount_for  
				--,sales_amount_sum  
				,uom  ,sales_qty  ,sales_user  ,sales_user_name  ,mat_group  ,mat_group_desc  ,item_id    as origin_item_id  
				,biz_type_2  ,app  ,usage  ,sales_team  ,ess_pm  ,plant_id  ,shipto_code  ,shipto_description  ,country  
				,country_name  ,shipto_city_name  ,shipto_zone_code  ,shipto_zone_name  ,rbu_customer  ,incoterms   as origin_incoterms  
				,profit_center_id  ,profit_center_name  ,partner_profit_center_id  ,partner_profit_center_name  ,item_text  
				,affiliate_code  ,customer_group_code  ,customer_group_name  ,cell_code  ,delegate_model_id  ,delegate_model_name  
				,c_p_model_id  ,c_p_model_name  ,lrregular_code  ,lrregular_name  ,machine_code  ,machine_name  ,line_id  
				,line_name  ,tco  ,system_input_date  ,system_input_time  ,DBO.FN_SCM_SYS_NVL(project_code, '') project_code  
				,CASE WHEN division_id LIKE '81%' THEN DBO.FN_SCM_SYS_NVL(  DBO.FN_GET_SCM_SITE_ID_PLANT(plant_id, DBO.FN_GET_ITEM_OPERATION_GROUP(division_id, item_id)),plant_id)  
									ELSE ''    
									END  plant_site_id  
				,'' as sales_site_id  
				-- Modifieyd 18-11-08 상품에 대해서 pack 대표 코드를 찾지 못해서 변경 함.  
				-- ,DBO.FN_SCM_SYS_NVL(DBO.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id), 'ETC') item_id  
				--SM 20240801 하단 두 테이블에 WITH (NOLOCK) 구문이 없어 추가
				,ISNULL( CASE	WHEN DIVISION_ID = '40' AND SUBSTRING(item_id,1,2) = 'MP' 
									THEN  ISNULL( ( SELECT TOP 1 ITEM_ID 
													FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK), SCM_MST_SITE S WITH(NOLOCK)
													WHERE SI.DIVISION_ID = S.division_id 
														AND SI.SCM_SITE_ID = S.SCM_SITE_ID 
														AND SI.DIVISION_ID = k.DIVISION_ID  
														AND S.SITE_TYPE = 'SALES' 
														AND SI.ITEM_ID LIKE SUBSTRING( k.ITEM_ID,1,11)+'%')
												, K.ITEM_ID)  
								WHEN k.item_id = '' 
									THEN 'ETC'  
								ELSE item_id 
							END , 'ETC'
						) item_id2  		
				--[C20210316-000434] fcst type 로직 변경
				, CASE	WHEN ATTRIBUTE1 <> '' THEN ATTRIBUTE1
						WHEN sales_type_2 in ('A/S',N'샘플') THEN sales_type_2   
						ELSE DBO.FN_GET_FCST_TYPE(sales_type_2)   
					END as fcst_type  --[CSR ID:4001986] 'A/S','샘플'인 경우 sales_type2를 셋팅함.  
				,incoterms  ,GETDATE()  ,@v_batch_user  ,GETDATE()  ,@v_batch_user  
				, ATTRIBUTE3
				, ATTRIBUTE4
				, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				, FROM_COMPANY_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM    #XIF_ERP_SALES_RESULT_R_SN_TMP k --  (2020.12.01) XIF_ERP_SALES_RESULT_R_SN k WITH(NOLOCK)  
			WHERE   ifseqno       = @v_ifseqno  
				-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (start)  
				--AND SALES_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MM,CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END,GETDATE()), 112) + '01'  
				-- 20190620 KHSONG ERP실적이 전월보다 이전 데이터가 인입되어 삭제되는 오류발생. 매월 1일인경우는 전전월 1일부터, 그외는 전월1일부터만 사용하도록 보완 (end)  
				--AND     TRANSFER_FLAG = 'P' --[E20240814-000938] 속도개선을 위해 TRANSFER_FLAG = 'P' 조건 제외
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 START
			-- NERP에서 더이상 12월 데이터를 넣어주지 않으나, 현재 구조는 전달 데이터를 모두 지워 실적이 사라지는 현상으로 해당 조치함
			AND COMPANY_ID IN ('WA00', 'HQ00')					
			AND SALES_POSTING_DATE >= '20250101'
			-- [PJ20228272]_실적 데이터 삭제하는 구조로 인하여, WA00, HQ00은 202501이후 데이터만 삭제하고 신규로 받도록 함 END
			*/
			--2025.06.30 park.choyi 삭제 End
			-----------------------------------------------------------  
			-- INSERT LOG  
			-----------------------------------------------------------  
			
			SET @n_update_cnt = @@ROWCOUNT;

			SET @v_log_type    = 'APPEND';  
			SET @v_log_message = 'INSERT INTO dm_dnm_sales_result_if';  
			SET @v_description = 'ifseqno = ' + @v_ifseqno;  
			SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date 
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			-----------------------------------------------------------  
  
  --SELECT * FROM #XIF_ERP_SALES_RESULT_R_SN_TMP
  --WHERE ISNULL(ATTRIBUTE4, '') <> ''


			-- 20200729 ESS 내부거래  예외처리 시작 ------------------------------------------------------------------------------  
			UPDATE A   
			SET A.INTERNAL_TYPE = B.ATTRIBUTE1  
			FROM DM_DNM_SALES_RESULT_IF A  
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK) ON A.SALES_GROUP = B.SEGMENT1 AND A.DISTRIBUTION_CHANNEL = B.SEGMENT2 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP' AND B.SEGMENT3 = 'ALL'  
			WHERE A.DIVISION_ID = '82'  
				AND A.SALES_POSTING_DATE BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to   
  
			UPDATE A   
			SET A.INTERNAL_TYPE = B.ATTRIBUTE1  
			FROM DM_DNM_SALES_RESULT_IF A  
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK) ON A.COST_ITEM = B.SEGMENT3 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP' AND B.SEGMENT1 = 'ALL'  
			WHERE A.DIVISION_ID = '82'  
				AND A.SALES_POSTING_DATE BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to   
  
  -- ESS 내부거래 끝      ------------------------------------------------------------------------------  
     
			-- 사내 매출 거래시 Lookup 의 Setup 된 값으로 Project Code, Sales Site Mapping  
			UPDATE  dm_dnm_sales_result_if  
			SET     project_code  = si.project_code  
					,sales_site_id = si.scm_site_id  
			FROM    dm_dnm_sales_result_if ri  
			JOIN   (SELECT  si.division_id  
							,md.segment2 company_id  
							,si.project_code  
							,si.scm_site_id  
							,si.item_id  
					FROM   scm_mst_site_item si WITH(NOLOCK)  
					JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)  
					ON     si.division_id = md.segment1  
					AND    si.scm_site_id = md.segment3  
					WHERE  md.lookup_type = 'INTERNAL_BIZ_SITE'  
					AND    si.valid_yn    = 'Y'  
					AND    md.valid_yn    = 'Y') si  
			ON      ri.company_id  = si.company_id  
			AND     ri.division_id = si.division_id  
			AND     ri.item_id     = si.item_id   
			WHERE   ri.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to   
			AND     ri.profit_center_id         = 'A40012'  
			AND     ri.partner_profit_center_id = 'A50101'  
			;  

			/*[E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경
								- 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영 
								- Soldto Code 가 법인인 경우 법인코드로 Mapping 하는 부분 타기전에 먼저 적용 되어야 함 ------------------*/
			WITH #EXCEPTION_SITE_MAPPING AS (
				SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS SOLDTO_CODE, SEGMENT3 AS SHIPTO_CODE, SEGMENT4 AS SALES_SITE_ID
				FROM scm_adm_lookup_master_detail WITH (NOLOCK)
				WHERE LOOKUP_TYPE = 'DM_EXCEPT_SALES_SITE_MAPPING'
			)
			UPDATE dm_dnm_sales_result_if 
			SET sales_site_id = B.SALES_SITE_ID
				--SELECT A.SALES_SITE_ID, B.SALES_SITE_ID
			FROM DM_DNM_SALES_RESULT_IF A WITH (NOLOCK) 
			INNER JOIN #EXCEPTION_SITE_MAPPING B ON A.DIVISION_ID = B.DIVISION_ID AND A.CUSTOMER_CODE = B.SOLDTO_CODE AND A.SHIPTO_CODE =  B.SHIPTO_CODE
			WHERE  A.sales_posting_date BETWEEN @v_yyyymmdd_from AND  @v_yyyymmdd_to;
			/* [E20240415-000036] END------------------------------------------------------------------------------------- */
			
    -- Sales Site Mapping  
			-- 1. Sales Site Mapping : Soldto Code 가 법인인 경우 법인코드로 Mapping  
			UPDATE dm_dnm_sales_result_if  
			SET    sales_site_id = CASE WHEN sr.customer_code = 'B100' THEN 'C100' ELSE sr.customer_code END	-- 2020.12.04
			FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)  
			WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND    sales_site_id = ''  
			AND    LEN(sr.customer_code) = 4;  
  
			-- 2. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping  
			UPDATE dm_dnm_sales_result_if  
			SET    sales_site_id   =  B.scm_site_id  
			FROM   dm_dnm_sales_result_if A WITH(NOLOCK)  
			JOIN  (SELECT  sc.division_id  
						,sc.soldto_code  
						,sc.shipto_code  
						,MAX(sc.scm_site_id) scm_site_id   
					FROM   scm_mst_site_customer sc WITH(NOLOCK)  
					JOIN   scm_mst_site ms WITH(NOLOCK)  
					ON     sc.division_id = ms.division_id  
					AND    sc.scm_site_id = ms.scm_site_id  
					WHERE  sc.valid_yn = 'Y'   
					AND    ms.valid_yn = 'Y'  
					AND    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
					GROUP BY sc.division_id, sc.soldto_code, sc.shipto_code  
					HAVING count(distinct sc.scm_site_id) = 1  
			) B  
			ON     B.division_id =  A.division_id  
			AND    B.soldto_code =  A.customer_code  
			AND    B.shipto_code =  A.shipto_code  
			WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND    A.sales_site_id = ''  
			AND    LEN(A.customer_code) != 4  
			AND    LEN(A.shipto_code)   != 4;  
  
    -- Project Code Mapping  
			-- Project Code Mapping : 소형의 경우 자재그룹을 참조로 한 End Customer 정보로 Project Code 설정  
			UPDATE dm_dnm_sales_result_if  
			SET    project_code     = md.attribute1  
			FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)  
			JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)  
			ON     sr.mat_group     = md.segment3  
			AND    sr.company_id    = md.segment2  
			AND    sr.division_id   = md.segment1  
			WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND    sr.division_id   = '40'  
			AND    sr.project_code  = ''  
			AND    md.lookup_type   = 'MTRL_GRP3_MAPPING'  
			AND    md.valid_yn      = 'Y';  
    
          -- Project Code Mapping : project_code 가 없는 경우 project_code Mapping  
			UPDATE dm_dnm_sales_result_if  
			SET    project_code     = b.new_project_code   
					,last_update_date = GETDATE()  
			FROM   dm_dnm_sales_result_if a  
			JOIN  (SELECT  CASE WHEN (-- MKT FCST를 입력한 Project가 하나인 경우  
										SELECT COUNT(DISTINCT x.project_code)  
										FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
										WHERE  x.division_id = a.division_id  
										AND    x.scm_site_id = a.sales_site_id  
										AND    x.item_id     = a.item_id  
										AND    x.measure     = 'MKT_FCST'  
										) = 1 THEN (SELECT DISTINCT x.project_code  
													FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
													WHERE  x.division_id = a.division_id  
													AND    x.scm_site_id = a.sales_site_id  
													AND    x.item_id     = a.item_id  
													AND    x.measure     = 'MKT_FCST')   
								WHEN (-- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우  
										SELECT COUNT(DISTINCT w.project_code)  
										FROM   scm_mst_site_item w WITH(NOLOCK)  
										WHERE  w.division_id = a.division_id  
										AND    w.scm_site_id = a.sales_site_id  
										AND    w.item_id     = a.item_id   
										AND    w.valid_yn    = 'Y'  
										) = 1  THEN (SELECT DISTINCT w.project_code  
													FROM   scm_mst_site_item w WITH(NOLOCK)  
													WHERE  w.division_id = a.division_id  
													AND    w.scm_site_id = a.sales_site_id  
													AND    w.item_id     = a.item_id  
													AND    w.valid_yn    = 'Y')  
								WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우  
										SELECT COUNT(DISTINCT w.project_code)  
										FROM   scm_mst_site_item w WITH(NOLOCK)  
										WHERE  w.division_id = a.division_id  
										AND    w.item_id     = a.item_id  
										AND    w.valid_yn    = 'Y'  
										) = 1  THEN (SELECT DISTINCT w.project_code  
													FROM   scm_mst_site_item w WITH(NOLOCK)  
													WHERE  w.division_id = a.division_id  
													AND    w.item_id     = a.item_id  
													AND    w.valid_yn    = 'Y')  
								ELSE 'X'  
								END new_project_code  
						,division_id  
						,sales_site_id  
						,item_id  
				FROM   dm_dnm_sales_result_if a WITH(NOLOCK)  
				WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
				AND    project_code = ''  
				AND   item_id     <> 'ETC'  
				) B  
			ON    A.division_id   = B.division_id  
			AND   A.sales_site_id = B.sales_site_id  
			AND   A.item_id  = B.item_id   
			WHERE A.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND   A.project_code = ''  
			AND   A.item_id     <> 'ETC'  
			AND   B.new_project_code != 'X';  
  
		  --[E20260615-000248]_기준정보 이외의 정보로 매핑하다보니, 오히려 사용자의 혼선을 가지고 옴, 하여 기준 로직으로만 매핑을 진행하고, 보완로직은 모두 주석처리 (START)
		  --[E20260615-000248]_향후 다시 살릴 수도 있으므로 예쁘게 구분해서 주석처리 여기 바로 아래 /* 지우면 다시 롤백 된다 [대상: SALES_SITE, PROJECT_CODE]
		 /*
          -- 3. Sales Site Mapping : project-item-customer 기준으로 하나의 site 만 등록된 경우 Mapping   
          UPDATE dm_dnm_sales_result_if  
          SET    sales_site_id = b.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
          JOIN   (SELECT  item.division_id  
                         ,item.project_code  
                         ,item_id  
                         ,cus.soldto_code  
                         ,cus.shipto_code  
                         ,MAX(item.scm_site_id) scm_site_id  
                  FROM   scm_mst_site site WITH(NOLOCK)   
                  JOIN   scm_mst_site_item item WITH(NOLOCK)   
                  ON     site.division_id = item.division_id  
                  AND    site.scm_site_id = item.scm_site_id  
                  JOIN   scm_mst_site_customer cus WITH(NOLOCK)  
                  ON     site.division_id = cus.division_id  
                  AND    site.scm_site_id = cus.scm_site_id  
                  WHERE  site.valid_yn    = 'Y'  
                  AND    item.valid_yn    = 'Y'  
                  AND    site.site_type   = 'SALES'  
                  GROUP BY item.division_id, item.project_code, item.item_id, cus.soldto_code, cus.shipto_code  
                  HAVING count(distinct item.scm_site_id) = 1  
                 ) b  
          ON     sr.division_id        = b.division_id  
          AND    sr.project_code       = b.project_code  
          AND    sr.item_id      = b.item_id  
          AND    sr.customer_code      = b.soldto_code  
		  AND    sr.shipto_code        = b.shipto_code  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.sales_site_id      = ''  
		  AND    sr.division_id        != '40' -- 소형 제외  
          AND    LEN(sr.customer_code) != 4   
          AND    LEN(sr.shipto_code)   != 4;   
  
          -- 4. Sales Site Mapping : project code-Item 기준으로 하나의 site 만 등록된 경우 Mapping   
          UPDATE dm_dnm_sales_result_if  
		  SET    sales_site_id = b.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
          JOIN   (SELECT  item.division_id  
                         ,item.project_code  
                         ,item_id  
                         ,MAX(item.scm_site_id) scm_site_id  
                  FROM   scm_mst_site site WITH(NOLOCK)   
                  JOIN   scm_mst_site_item item WITH(NOLOCK)   
                  ON     site.division_id = item.division_id  
                  AND    site.scm_site_id = item.scm_site_id  
                  WHERE  site.valid_yn    = 'Y'  
                  AND    item.valid_yn    = 'Y'  
                  AND    site.site_type   = 'SALES'  
                  GROUP BY item.division_id, item.project_code, item.item_id  
                  HAVING count(distinct item.scm_site_id) = 1  
                 ) b  
          ON     sr.division_id        = b.division_id  
          AND    sr.project_code       = b.project_code  
          AND    sr.item_id      = b.item_id  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.sales_site_id      = ''  
          AND    sr.division_id        != '40' -- 소형 제외  
          AND    LEN(sr.customer_code) != 4   
          AND    LEN(sr.shipto_code)   != 4;  
  
    -- 5. Sales Site Mapping : project code 기준으로 하나의 site 만 등록된 경우 Mapping  
          UPDATE dm_dnm_sales_result_if  
          SET    sales_site_id = b.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
          JOIN   (SELECT  item.division_id  
                         ,item.project_code  
                         ,MAX(item.scm_site_id) scm_site_id  
                  FROM   scm_mst_site site WITH(NOLOCK)   
                  JOIN   scm_mst_site_item item WITH(NOLOCK)   
                  ON     site.division_id = item.division_id  
                  AND    site.scm_site_id = item.scm_site_id  
                  WHERE  site.valid_yn    = 'Y'  
                  AND    item.valid_yn    = 'Y'  
                  AND    site.site_type   = 'SALES'  
				  AND    item.project_code != ''  
				  GROUP BY item.division_id, item.project_code  
                  HAVING count(distinct item.scm_site_id) = 1  
                 ) b  
          ON     sr.division_id        = b.division_id  
          AND    sr.project_code       = b.project_code  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.sales_site_id      = ''  
          AND    sr.division_id        != '40' -- 소형 제외  
          AND    LEN(sr.customer_code) != 4  
          AND    LEN(sr.shipto_code)   != 4;  
  
    -- 6. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있는 경우 mapping  
          UPDATE dm_dnm_sales_result_if  
          SET    sales_site_id = cus.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
          JOIN   (SELECT  cus.division_id  
                         ,cus.shipto_code  
                         ,MAX(cus.scm_site_id) scm_site_id  
                  FROM   scm_mst_site_customer cus WITH(NOLOCK)  
				  JOIN   scm_mst_site ms WITH(NOLOCK)  
				  ON     cus.division_id = ms.division_id  
				  AND    cus.scm_site_id = ms.scm_site_id  
							  WHERE  cus.valid_yn = 'Y'  
				  AND    ms.valid_yn  = 'Y'  
				  AND    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
                  GROUP BY cus.division_id, cus.shipto_code  
               HAVING count(distinct cus.scm_site_id) = 1) cus  
          ON     sr.division_id        = cus.division_id  
          AND    sr.shipto_code        = cus.shipto_code  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.sales_site_id      = ''  
          AND    sr.division_id        != '40' -- 소형 제외  
          AND    LEN(sr.customer_code) != 4   
          AND    LEN(sr.shipto_code)   != 4;  
  
   -- 7. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있는 경우 mapping  
          UPDATE dm_dnm_sales_result_if  
          SET    sales_site_id = cus.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
          JOIN   (SELECT  cus.division_id  
                         ,cus.soldto_code  
                         ,MAX(cus.scm_site_id) scm_site_id  
                  FROM   scm_mst_site_customer cus WITH(NOLOCK)  
				  JOIN   scm_mst_site ms WITH(NOLOCK)  
				  ON     cus.division_id = ms.division_id  
				  AND    cus.scm_site_id = ms.scm_site_id  
							  WHERE  cus.valid_yn = 'Y'  
				  AND    ms.valid_yn  = 'Y'  
				  AND    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
                  GROUP BY cus.division_id, cus.soldto_code  
                  HAVING count(distinct cus.scm_site_id) = 1) cus  
          ON     sr.division_id        = cus.division_id  
          AND    sr.customer_code      = cus.soldto_code  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.sales_site_id      = ''  
		  AND    sr.division_id        != '40' -- 소형 제외  
		  AND    LEN(sr.customer_code) != 4   
		  AND    LEN(sr.shipto_code)   != 4;  
  
          -- [C20190306_40879] 8. 소형 특정 Soldto, Shipto의 실적은 incoterms별로 특정 Sales Site에 Mapping 처리  
		  -- Sales Site에는 하나의 Soldto,Shipto가 연결되어야 하나, 2개가 맵핑된 케이스가 발생함.  
		  -- 실적엔 Sales Site 정보가 없어 Mapping할 수 없으니, 해당 케이스는 incoterms별로 구분하도록 오경택선임과 합의.(2019.03.06)  
          UPDATE dm_dnm_sales_result_if  
          SET    sales_site_id     = CASE WHEN incoterms = 'DAP' THEN 'LGCEG_DE_WIN' ELSE 'BMZ_DE_KSN' END  
          WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    division_id    = '40'  
		  AND    sales_site_id  = ''  
		  --AND    shipto_code    = 'DE000271'  
		  --AND    customer_code  = 'DE000271'
		  AND    shipto_code    IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'SHIPTO_CODE_02')) --[PJ20228272] NERP 대응
		  AND    customer_code  IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'CUSTOMER_CODE')) --[PJ20228272] NERP 대응
		  ;
  
          -- Project Code Mapping : project_code 가 없는 경우 project_code Mapping (Sales Site Mapping 후 한번 더)  
          UPDATE dm_dnm_sales_result_if  
          SET    project_code     = b.new_project_code   
                ,last_update_date = GETDATE()  
          FROM   dm_dnm_sales_result_if a  
          JOIN  (SELECT  CASE WHEN (-- MKT FCST를 입력한 Project가 하나인 경우  
                  SELECT COUNT(DISTINCT x.project_code)  
                                    FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
                                    WHERE  x.division_id = a.division_id  
									AND    x.scm_site_id = a.sales_site_id 
                                    AND    x.item_id     = a.item_id  
                                    AND    x.measure     = 'MKT_FCST'  
                                    ) = 1 THEN (SELECT DISTINCT x.project_code  
                                                FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
                                                WHERE  x.division_id = a.division_id  
                                                AND    x.scm_site_id = a.sales_site_id  
                                                AND    x.item_id     = a.item_id  
                                                AND    x.measure     = 'MKT_FCST')   
                              WHEN (-- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우  
                                    SELECT COUNT(DISTINCT w.project_code)  
                                    FROM   scm_mst_site_item w WITH(NOLOCK)  
									WHERE  w.division_id = a.division_id  
                                    AND    w.scm_site_id = a.sales_site_id  
                                    AND    w.item_id     = a.item_id   
                                    AND    w.valid_yn    = 'Y'  
                                   ) = 1  THEN (SELECT DISTINCT w.project_code  
                                                FROM   scm_mst_site_item w WITH(NOLOCK)  
												WHERE  w.division_id = a.division_id  
                                                AND    w.scm_site_id = a.sales_site_id  
                                                AND    w.item_id     = a.item_id  
                                                AND    w.valid_yn    = 'Y')  
                                   WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우  
                                         SELECT COUNT(DISTINCT w.project_code)  
                                         FROM   scm_mst_site_item w WITH(NOLOCK)  
                                         WHERE  w.division_id = a.division_id  
                                         AND    w.item_id     = a.item_id  
                                         AND    w.valid_yn    = 'Y'  
                                         ) = 1  THEN (SELECT DISTINCT w.project_code  
                                                      FROM   scm_mst_site_item w WITH(NOLOCK)  
                                                      WHERE  w.division_id = a.division_id  
                                                      AND    w.item_id     = a.item_id  
                                                      AND    w.valid_yn    = 'Y')  
                                   ELSE 'X'  
                               END new_project_code  
                         ,division_id  
                         ,sales_site_id  
                         ,item_id  
                 FROM   dm_dnm_sales_result_if a WITH(NOLOCK)  
                 WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
				 AND    project_code = ''  
                  AND   item_id     <> 'ETC'  
                 ) B  
          ON    A.division_id   = B.division_id  
          AND   A.sales_site_id = B.sales_site_id  
          AND   A.item_id  = B.item_id   
          WHERE A.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND   A.project_code = ''  
          AND   A.item_id     <> 'ETC'  
		  AND   B.new_project_code != 'X';  
		  */
		 --[E20260615-000248]_향후 다시 살릴 수도 있으므로 예쁘게 구분해서 주석처리 여기 바로 위 */ 지우면 다시 롤백 된다 [대상: SALES_SITE, PROJECT_CODE]
  		 --[E20260615-000248]_기준정보 이외의 정보로 매핑하다보니, 오히려 사용자의 혼선을 가지고 옴, 하여 기준 로직으로만 매핑을 진행하고, 보완로직은 모두 주석처리 (END)
  
          -- Item 이 Pack원부자재일 경우 Plant_site_id mapping  
          UPDATE dm_dnm_sales_result_if  
          SET    plant_site_id = ms.scm_site_id  
          FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)  
          JOIN   scm_mst_item_sn mi WITH(NOLOCK)  
          ON     sr.division_id = mi.division_id  
          AND    sr.item_id     = mi.item_id  
          JOIN   (SELECT  scm_site_id  
                         ,plant_id  
                  FROM scm_mst_site WITH(NOLOCK)  
                  WHERE valid_yn      = 'Y'  
				  AND   site_type     = 'PLANT'  
                  AND operation_group = 'P') ms  
          ON     sr.plant_site_id = ms.plant_id  
          WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
		  AND    sr.division_id        LIKE '81%'  
          AND    LEN(sr.plant_site_id) = 4  
          --AND    mi.material_class     = 'BC15' 
		  AND    mi.material_class  IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_DNM_SALES_RESULT_IF', 'MATERIAL_CLASS')) --[PJ20228272] NERP 대응
		  ;



	-------------------------------------------- [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건 ------ 시작 --------------------------------------------------------------------------------------

			-- 2. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping  
			UPDATE dm_dnm_sales_result_if  
			SET    sales_site_id   =  B.scm_site_id  
			FROM   dm_dnm_sales_result_if A WITH(NOLOCK)  
			JOIN  (SELECT  sc.division_id  
						,sc.soldto_code  
						,sc.shipto_code  
						,MAX(sc.scm_site_id) scm_site_id   
			FROM   scm_mst_site_customer sc WITH(NOLOCK)  
			JOIN   scm_mst_site ms WITH(NOLOCK)  
			ON     sc.division_id = ms.division_id  
			AND    sc.scm_site_id = ms.scm_site_id  
			/* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
            WHERE  sc.valid_yn = 'Y'   
			AND    ms.valid_yn = 'Y' */ 
			WHERE    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
			GROUP BY sc.division_id, sc.soldto_code, sc.shipto_code  
			HAVING count(distinct sc.scm_site_id) = 1  
			) B  
			ON     B.division_id =  A.division_id  
			AND    B.soldto_code =  A.customer_code  
			AND    B.shipto_code =  A.shipto_code  
			WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND    A.sales_site_id = ''  
			AND    LEN(A.customer_code) != 4  
			AND    LEN(A.shipto_code)   != 4;  
					  

          -- Project Code Mapping : project_code 가 없는 경우 project_code Mapping  
			UPDATE dm_dnm_sales_result_if  
			SET    project_code     = b.new_project_code   
					,last_update_date = GETDATE()  
			FROM   dm_dnm_sales_result_if a  
			JOIN  (SELECT  CASE WHEN (-- MKT FCST를 입력한 Project가 하나인 경우  
										SELECT COUNT(DISTINCT x.project_code)  
										FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
										WHERE  x.division_id = a.division_id  
										AND    x.scm_site_id = a.sales_site_id  
										AND    x.item_id     = a.item_id  
										AND    x.measure     = 'MKT_FCST'  
										) = 1 THEN (SELECT DISTINCT x.project_code  
													FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
													WHERE  x.division_id = a.division_id  
													AND    x.scm_site_id = a.sales_site_id  
													AND    x.item_id     = a.item_id  
													AND    x.measure     = 'MKT_FCST')   
								WHEN (-- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우  
										SELECT COUNT(DISTINCT w.project_code)  
										FROM   scm_mst_site_item w WITH(NOLOCK)  
										WHERE  w.division_id = a.division_id  
										AND    w.scm_site_id = a.sales_site_id  
										AND    w.item_id     = a.item_id   
                                        /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
										AND    w.valid_yn    = 'Y'  
                                        */
										) = 1  THEN (SELECT DISTINCT w.project_code  
													FROM   scm_mst_site_item w WITH(NOLOCK)  
													WHERE  w.division_id = a.division_id  
													AND    w.scm_site_id = a.sales_site_id  
													AND    w.item_id     = a.item_id 
                                                    /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건 
													AND    w.valid_yn    = 'Y'  */)  
								WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우  
										SELECT COUNT(DISTINCT w.project_code)  
										FROM   scm_mst_site_item w WITH(NOLOCK)  
										WHERE  w.division_id = a.division_id  
										AND    w.item_id     = a.item_id  
                                        /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
										AND    w.valid_yn    = 'Y'  
                                        */
										) = 1  THEN (SELECT DISTINCT w.project_code  
													FROM   scm_mst_site_item w WITH(NOLOCK)  
													WHERE  w.division_id = a.division_id  
													AND    w.item_id     = a.item_id  
                                                    /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
													AND    w.valid_yn    = 'Y'
                                                    */)  
								ELSE 'X'  
								END new_project_code  
						,division_id  
						,sales_site_id  
						,item_id  
				FROM   dm_dnm_sales_result_if a WITH(NOLOCK)  
				WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
				AND    project_code = ''  
				AND   item_id     <> 'ETC'  
				) B  
			ON    A.division_id   = B.division_id  
			AND   A.sales_site_id = B.sales_site_id  
			AND   A.item_id  = B.item_id   
			WHERE A.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
			AND   A.project_code = ''  
			AND   A.item_id     <> 'ETC'  
			AND   B.new_project_code != 'X';  

  		  --[E20260615-000248]_기준정보 이외의 정보로 매핑하다보니, 오히려 사용자의 혼선을 가지고 옴, 하여 기준 로직으로만 매핑을 진행하고, 보완로직은 모두 주석처리 (START)
		  --[E20260615-000248]_향후 다시 살릴 수도 있으므로 예쁘게 구분해서 주석처리 여기 바로 아래 /* 지우면 다시 롤백 된다 [대상: SALES_SITE, PROJECT_CODE]
		  /*
        -- 3. Sales Site Mapping : project-item-customer 기준으로 하나의 site 만 등록된 경우 Mapping   
        UPDATE dm_dnm_sales_result_if  
        SET    sales_site_id = b.scm_site_id  
        FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
        JOIN   (SELECT  item.division_id  
                        ,item.project_code  
                        ,item_id  
                        ,cus.soldto_code  
                        ,cus.shipto_code  
                        ,MAX(item.scm_site_id) scm_site_id  
                FROM   scm_mst_site site WITH(NOLOCK)   
                JOIN   scm_mst_site_item item WITH(NOLOCK)   
                ON     site.division_id = item.division_id  
                AND    site.scm_site_id = item.scm_site_id  
                JOIN   scm_mst_site_customer cus WITH(NOLOCK)  
                ON     site.division_id = cus.division_id  
                AND    site.scm_site_id = cus.scm_site_id  
                /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
                WHERE  site.valid_yn    = 'Y'  
                AND    item.valid_yn    = 'Y'  */
                WHERE    site.site_type   = 'SALES'  
                GROUP BY item.division_id, item.project_code, item.item_id, cus.soldto_code, cus.shipto_code  
                HAVING count(distinct item.scm_site_id) = 1  
                ) b  
        ON     sr.division_id        = b.division_id  
        AND    sr.project_code       = b.project_code  
        AND    sr.item_id      = b.item_id  
        AND    sr.customer_code      = b.soldto_code  
        AND    sr.shipto_code        = b.shipto_code  
        WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND    sr.sales_site_id      = ''  
        AND    sr.division_id        != '40' -- 소형 제외  
        AND    LEN(sr.customer_code) != 4   
        AND    LEN(sr.shipto_code)   != 4;   
  
        -- 4. Sales Site Mapping : project code-Item 기준으로 하나의 site 만 등록된 경우 Mapping   
        UPDATE dm_dnm_sales_result_if  
        SET    sales_site_id = b.scm_site_id  
        FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
        JOIN   (SELECT  item.division_id  
                        ,item.project_code  
                        ,item_id  
                        ,MAX(item.scm_site_id) scm_site_id  
                FROM   scm_mst_site site WITH(NOLOCK)   
                JOIN   scm_mst_site_item item WITH(NOLOCK)   
                ON     site.division_id = item.division_id  
                AND    site.scm_site_id = item.scm_site_id  
                /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
                WHERE  site.valid_yn    = 'Y'  
                AND    item.valid_yn    = 'Y'  */
                WHERE    site.site_type   = 'SALES'  
                GROUP BY item.division_id, item.project_code, item.item_id  
                HAVING count(distinct item.scm_site_id) = 1  
                ) b  
        ON     sr.division_id        = b.division_id  
        AND    sr.project_code       = b.project_code  
        AND    sr.item_id      = b.item_id  
        WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND    sr.sales_site_id      = ''  
        AND    sr.division_id        != '40' -- 소형 제외  
        AND    LEN(sr.customer_code) != 4   
        AND    LEN(sr.shipto_code)   != 4;  
  
        -- 5. Sales Site Mapping : project code 기준으로 하나의 site 만 등록된 경우 Mapping  
        UPDATE dm_dnm_sales_result_if  
        SET    sales_site_id = b.scm_site_id  
   FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
        JOIN   (SELECT  item.division_id  
                        ,item.project_code  
                        ,MAX(item.scm_site_id) scm_site_id  
                FROM   scm_mst_site site WITH(NOLOCK)   
                JOIN   scm_mst_site_item item WITH(NOLOCK)   
                ON     site.division_id = item.division_id  
                AND    site.scm_site_id = item.scm_site_id  
                /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
                WHERE  site.valid_yn    = 'Y'  
                AND    item.valid_yn    = 'Y'  */
                WHERE    site.site_type   = 'SALES'  
                AND    item.project_code != ''  
                GROUP BY item.division_id, item.project_code  
                HAVING count(distinct item.scm_site_id) = 1  
                ) b  
        ON     sr.division_id        = b.division_id  
        AND    sr.project_code       = b.project_code  
        WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND    sr.sales_site_id      = ''  
        AND    sr.division_id        != '40' -- 소형 제외  
        AND    LEN(sr.customer_code) != 4  
        AND    LEN(sr.shipto_code)   != 4;  
  
        -- 6. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있는 경우 mapping  
        UPDATE dm_dnm_sales_result_if  
        SET    sales_site_id = cus.scm_site_id  
        FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
        JOIN   (SELECT  cus.division_id  
                        ,cus.shipto_code  
                        ,MAX(cus.scm_site_id) scm_site_id  
                FROM   scm_mst_site_customer cus WITH(NOLOCK)  
                JOIN   scm_mst_site ms WITH(NOLOCK)  
                ON     cus.division_id = ms.division_id  
                AND    cus.scm_site_id = ms.scm_site_id  
                /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
                WHERE  cus.valid_yn = 'Y'  
                AND    ms.valid_yn  = 'Y'  */
                WHERE    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
                GROUP BY cus.division_id, cus.shipto_code  
                HAVING count(distinct cus.scm_site_id) = 1) cus  
        ON     sr.division_id        = cus.division_id  
        AND    sr.shipto_code        = cus.shipto_code  
        WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND    sr.sales_site_id      = ''  
        AND    sr.division_id        != '40' -- 소형 제외  
        AND    LEN(sr.customer_code) != 4   
        AND    LEN(sr.shipto_code)   != 4;  
  

        -- 7. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있는 경우 mapping  
        UPDATE dm_dnm_sales_result_if  
        SET    sales_site_id = cus.scm_site_id  
        FROM   dm_dnm_sales_result_if sr WITH(NOLOCK)   
        JOIN   (SELECT  cus.division_id  
                        ,cus.soldto_code  
                        ,MAX(cus.scm_site_id) scm_site_id  
                FROM   scm_mst_site_customer cus WITH(NOLOCK)  
                JOIN   scm_mst_site ms WITH(NOLOCK)  
                ON     cus.division_id = ms.division_id  
                AND    cus.scm_site_id = ms.scm_site_id  
                /* [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건
                WHERE  cus.valid_yn = 'Y'  
                AND    ms.valid_yn  = 'Y'  */
                WHERE    ms.site_type = 'SALES'  -- 2018.09.17 Sales Site 만 Mapping  
                GROUP BY cus.division_id, cus.soldto_code  
                HAVING count(distinct cus.scm_site_id) = 1) cus  
        ON     sr.division_id        = cus.division_id  
        AND    sr.customer_code      = cus.soldto_code  
        WHERE  sr.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND    sr.sales_site_id      = ''  
        AND    sr.division_id        != '40' -- 소형 제외  
        AND    LEN(sr.customer_code) != 4   
        AND    LEN(sr.shipto_code)   != 4;  



        -- Project Code Mapping : project_code 가 없는 경우 project_code Mapping (Sales Site Mapping 후 한번 더)  
        UPDATE dm_dnm_sales_result_if  
        SET project_code = b.new_project_code   
            ,last_update_date = GETDATE()  
        FROM dm_dnm_sales_result_if a  
        JOIN (SELECT CASE   WHEN (-- MKT FCST를 입력한 Project가 하나인 경우  
                                SELECT COUNT(DISTINCT x.project_code)  
                                FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
                                WHERE  x.division_id = a.division_id  
                                AND    x.scm_site_id = a.sales_site_id 
                                AND    x.item_id     = a.item_id  
                                AND    x.measure     = 'MKT_FCST') = 1 
                            THEN (SELECT DISTINCT x.project_code  
                                FROM   dm_pln_mkt_fcst x WITH(NOLOCK)  
                                WHERE  x.division_id = a.division_id  
                                AND    x.scm_site_id = a.sales_site_id  
                                AND    x.item_id     = a.item_id  
                                AND    x.measure     = 'MKT_FCST')   

                            WHEN (-- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우  
                                SELECT COUNT(DISTINCT w.project_code)  
                                FROM   scm_mst_site_item w WITH(NOLOCK)  
                                WHERE  w.division_id = a.division_id  
                                AND    w.scm_site_id = a.sales_site_id  
                                AND    w.item_id     = a.item_id   
                                /*AND    w.valid_yn    = 'Y'*/) = 1  
                            THEN (SELECT DISTINCT w.project_code  
                                FROM   scm_mst_site_item w WITH(NOLOCK)  
                                WHERE  w.division_id = a.division_id  
                                AND    w.scm_site_id = a.sales_site_id  
                                AND    w.item_id     = a.item_id  
                                /*AND    w.valid_yn    = 'Y'*/)  

                            WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우  
                                SELECT COUNT(DISTINCT w.project_code)  
                                FROM   scm_mst_site_item w WITH(NOLOCK)  
                                WHERE  w.division_id = a.division_id  
                                AND    w.item_id     = a.item_id  
                                /*AND    w.valid_yn    = 'Y'*/) = 1  
                            THEN (SELECT DISTINCT w.project_code  
                                FROM   scm_mst_site_item w WITH(NOLOCK)  
                                WHERE  w.division_id = a.division_id  
                                AND    w.item_id     = a.item_id  
                                /*AND    w.valid_yn    = 'Y'*/) 

                            ELSE 'X' END new_project_code  
                ,division_id  
                ,sales_site_id  
                ,item_id  
            FROM   dm_dnm_sales_result_if a WITH(NOLOCK)  
            WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
            AND    project_code = ''  
            AND   item_id     <> 'ETC'  
            ) B  
        ON    A.division_id   = B.division_id  
        AND   A.sales_site_id = B.sales_site_id  
        AND   A.item_id  = B.item_id   
        WHERE A.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
        AND   A.project_code = ''  
        AND   A.item_id     <> 'ETC'  
        AND   B.new_project_code != 'X';  
		*/
		--[E20260615-000248]_향후 다시 살릴 수도 있으므로 예쁘게 구분해서 주석처리 여기 바로 위 */ 지우면 다시 롤백 된다 [대상: SALES_SITE, PROJECT_CODE]
  		--[E20260615-000248]_기준정보 이외의 정보로 매핑하다보니, 오히려 사용자의 혼선을 가지고 옴, 하여 기준 로직으로만 매핑을 진행하고, 보완로직은 모두 주석처리 (END)

	-------------------------------------------- [C20220512-000045][SCMPI] GSCM 시스템의 판매 실적 개선을 위한 Sales Site 누락 Case를 보정하는 로직 개발 요청 건 ------ 종료 --------------------------------------------------------------------------------------
  
    -- Fcst Type mapping : Mkt Fcst 의 Fcst Type Mapping  
	UPDATE dm_dnm_sales_result_if  
	SET    fcst_type = B.fcst_type  
	FROM   dm_dnm_sales_result_if A WITH(NOLOCK)  
	JOIN  (SELECT  mf.division_id  
				,mf.project_code  
				,sr.sales_site_id  
				,mf.item_id  
				,MAX(mf.fcst_type) fcst_type  
				,MF.INCOTERMS  -- 20200207 (KHSONG C20200131-000350) INCOTERMS추가  
			FROM  dm_pln_mkt_fcst mf WITH(NOLOCK)  
			JOIN  dm_dnm_sales_result_if sr WITH(NOLOCK)  
			ON    mf.division_id  = sr.division_id  
			AND   mf.project_code = sr.project_code  
			AND   mf.scm_site_id  = sr.sales_site_id  
			AND   mf.item_id      = sr.item_id  
			WHERE sr.fcst_type    = '-'		--[C20210316-000434]
			AND   sr.sales_posting_date >= DATEADD(mm, DATEDIFF(mm,0,getdate()) - 1, 0)  
			and   substring(mf.yyyymmdd,1,6) = substring(sr.sales_posting_date,1,6)  -- 20190121 KHSONG 날짜 조건을 같은달내에서만 실적과 비교하여 fcst_type을 못찾는경우를 줄임  
			AND   mf.INCOTERMS    = sr.INCOTERMS  -- 20200207 (KHSONG C20200131-000350) INCOTERMS추가  
			AND   mf.measure      = 'MKT_FCST'  
			AND   mf.qty          > 0                    
			GROUP BY mf.division_id,mf.project_code,sr.sales_site_id,mf.item_id  
			,MF.INCOTERMS -- 20200207 (KHSONG C20200131-000350) INCOTERMS추가  
			HAVING count(distinct mf.fcst_type) = 1) B  
	ON    A.division_id   = B.division_id  
	AND   A.project_code  = B.project_code  
	AND   A.sales_site_id = B.sales_site_id  
	AND   A.item_id  = B.item_id  
	AND   A.INCOTERMS  = B.INCOTERMS -- 20200207 (KHSONG C20200131-000350) INCOTERMS추가  
	WHERE sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
	--AND   A.fcst_type     = '-'
	--[C20210316-000434]
	AND A.FCST_TYPE = '-';
  
    -- [CSR ID:4001986] 'A/S', '샘플' 인 경우 수량이 0 일때 Free(F) 로 셋팅  
    UPDATE dm_dnm_sales_result_if  
    SET    fcst_type = case when A.sales_amount_sum = 0  
                                       then case when A.fcst_type = 'A/S' then 'ASF'  
                                                 when A.fcst_type = N'샘플' and B.fcst_type like 'SD%' then 'SDF'  
                                                 when A.fcst_type = N'샘플' and B.fcst_type like 'SM%' then 'SMF'  
                                                 when A.fcst_type = N'샘플' and isnull(B.fcst_type,'') = '' or B.fcst_type not like 'S%' then 'SMF'  
                                            end  
                                  when A.sales_amount_sum <> 0   
                                       then case when A.fcst_type = 'A/S' then 'AS'  
                                                 when A.fcst_type = N'샘플' and B.fcst_type like 'SD%' then 'SDC'  
                                                 when A.fcst_type = N'샘플' and B.fcst_type like 'SM%' then 'SMC'  
                                                 when A.fcst_type = N'샘플' and isnull(B.fcst_type,'') = '' or B.fcst_type not like 'S%' then 'SMC'  
                                 end  
                                  when isnull(B.fcst_type,'') = ''   
                                       then case when A.fcst_type = 'A/S' then 'AS'  
                                                 when A.fcst_type = N'샘플' then 'SMC'   
                                            end  
                             end  -- B.fcst_type  
    FROM   (SELECT division_id, project_code, sales_site_id, item_id, fcst_type  
                       , SUM(sales_amount_sum) OVER(PARTITION BY division_id, project_code, sales_site_id, plant_site_id  
                                                               , item_id, origin_item_id, incoterms, currency, sales_posting_date  
                                                               , fcst_type, customer_code, shipto_code) as sales_amount_sum  
                    FROM dm_dnm_sales_result_if WITH(NOLOCK)  
                   WHERE sales_posting_date >= CONVERT(VARCHAR(8), DATEADD(mm, DATEDIFF(mm,0,getdate()) - 1, 0), 112)  
                 ) A  
    LEFT OUTER JOIN    
                (SELECT  mf.division_id  
      ,mf.project_code  
      ,sr.sales_site_id  
      ,mf.item_id  
      ,MAX(mf.fcst_type) fcst_type  
     FROM  dm_pln_mkt_fcst mf WITH(NOLOCK)  
     JOIN  dm_dnm_sales_result_if sr WITH(NOLOCK)  
     ON    mf.division_id  = sr.division_id  
     AND   mf.project_code = sr.project_code  
     AND   mf.scm_site_id  = sr.sales_site_id  
     AND   mf.item_id      = sr.item_id  
     WHERE sr.fcst_type    in ('A/S',N'샘플')  
     AND   sr.sales_posting_date >= CONVERT(VARCHAR(8), DATEADD(mm, DATEDIFF(mm,0,getdate()) - 1, 0), 112)  
     and   substring(mf.yyyymmdd,1,6) = substring(sr.sales_posting_date,1,6)  -- 20190121 KHSONG 날짜 조건을 같은달내에서만 실적과 비교하여 fcst_type을 못찾는경우를 줄임  
     AND   mf.measure      = 'MKT_FCST'  
     AND   mf.qty          > 0                    
     GROUP BY mf.division_id,mf.project_code,sr.sales_site_id,mf.item_id  
     HAVING count(distinct mf.fcst_type) = 1) B  
    ON    A.division_id   = B.division_id  
    AND   A.project_code  = B.project_code  
    AND   A.sales_site_id = B.sales_site_id  
    AND   A.item_id  = B.item_id  
    WHERE dm_dnm_sales_result_if.sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
    AND   dm_dnm_sales_result_if.fcst_type     in ('A/S',N'샘플')  
          AND   dm_dnm_sales_result_if.division_id   = A.division_id  
          AND   dm_dnm_sales_result_if.project_code  = A.project_code  
          AND   dm_dnm_sales_result_if.sales_site_id = A.sales_site_id  
          AND   dm_dnm_sales_result_if.item_id       = A.item_id  
          AND   dm_dnm_sales_result_if.fcst_type     = A.fcst_type  
          ;  
  
    --[C20200921-000297] 자동차 사업부에 MKT FCST에 FCST_TYPE이 2개 이상이거나, 없는 경우 MASS로 적용  
    -- Fcst_type mapping : 81 의 경우 Sample -> MASS  
    /*  
    UPDATE dm_dnm_sales_result_if  
    SET    fcst_type   = 'SMC'  
    WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
    AND    fcst_type   = '-'  
    AND    division_id = '81';*/  
  
    -- Fcst_type mapping : 모든 사업부는 Mass  
    UPDATE dm_dnm_sales_result_if  
    SET    fcst_type = 'MPS'  
    WHERE  sales_posting_date BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to  
    --[C20210316-000434]
	AND    fcst_type IN ( '-' );  

    -- 인터페이스 처리 완료 Update  
    UPDATE xif_erp_sales_result_r_sn  
          SET    transfer_flag = 'Y'  
          WHERE  ifseqno       = @v_ifseqno  
          AND    transfer_flag = 'P';      
  
		SET @n_update_cnt = @@ROWCOUNT; --[E20240814-000938] Row Count 확인(Update TRANSFER_FLAG to Y)

		--[E20240814-000938] 시간소요 확인위해 LOG 삽입 추가 
		-----------------------------------------------------------  
		-- INSERT LOG  
		-----------------------------------------------------------  
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = N'Update TRANSFER_FLAG to Y';  
		SET @d_event_date  = @d_start_date; --[E20240814-000938] Batch Start Date
		SET @n_log_count   = @n_update_cnt;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------  
  
        FETCH NEXT FROM cur_sales INTO @v_ifseqno, @v_yyyymmdd_from, @v_yyyymmdd_to;  
      END  
          
      CLOSE cur_sales;  
      DEALLOCATE cur_sales;  
      
  
	  -- DM 프로시저 호출
      EXEC PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING @p_division_id = NULL;


  
      IF @@TRANCOUNT > 0  
        BEGIN  
          COMMIT WORK;  
        END;  
        
 
  END TRY  
  
  BEGIN CATCH  
    -- ERROR LOG  
    SET @v_log_type    = 'ERROR';  
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;  
    SET @d_event_date  =  @d_start_date; --[E20240814-000938] Batch Start Date
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  END CATCH;  
  
  -- 종료 LOG  
  SET @v_log_type = 'END';  
  SET @v_log_message = '########## END of procedure ##########';  
  SET @v_description = '';  
  SET @d_event_date  = SYSDATETIME();  
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
END; 
