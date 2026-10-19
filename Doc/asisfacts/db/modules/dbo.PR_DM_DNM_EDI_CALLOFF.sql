





/*
   ------------------------------------- EDI 정보유형(v20190222) -------------------------------------
   ** 현재기준 괄호()안의 고객사는 아직 수신받지 않는 데이터임
   1. VDA 문서 : SCHEDULING_TYPE 으로 구분됨
      - 해당고객사 : Audi, VW, Porsche, Daimler, BMW, (Magna)
	  - 처리방법 : 구간 상관없이 4,10,24에 대한 값을 SUM 함. 구간이 겹치더라도 SUM을 해주면 됨.

   2. EDI FACT 문서 : MESSAGE_TYPE 으로 구분됨
      - 해당고객사 : PSA, (Volvo), (GM)
	  - 처리방법 : DELJIT,DELFOR 로 구분.
	               1W에 대해서는 DELJIT 값을 써야 하고, 이후 구간은 DELFOR 값을 쓰면 됨. 

   3. ANSI 문서 : 2019.7~8월경 데이터 수신예정
      - 해당고객사 : (FCA), (Ford), (Piston)
	  - 처리방법 : 미정
   ------------------------------------- EDI 정보유형(v20190222) -------------------------------------

 * Program ID   : PR_DM_DNM_EDI_CALLOFF
 * Description  : BMW / AUDI등 EDI 정보 I/F 
 *                XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
 *                XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
 *                XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
 *===================================================================================================
 * 20181008 KHSONG Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20190130 KHSONG [CSR ID:3910052] Scheduling data 구분 처리
 * 20190211 KHSONG DM_MST_CUSTOMER_FCST 기존 사용자의 CUST_FCST 값이 존재하는경우 20000102 한건만 VALID_YN='Y'로 UPDATE하고 나머지 구간은 'N' 처리함
 * 20190225 KHSONG PSA고객사 MESSAGE_TYPE 구분처리 로직 추가
 * 20190311 KHSONG QTY 데이터타입 오류로 변환방식으로 수정
 * 20190404 KHSONG PSA고객사 Periodic DELFOR 값에 대한 구간반영 적용
 * 20191118 KHSONG [CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 20191121 KHSONG [C20191031-000137] EDI로 수신 받은 Call-off 정보 편집 기능 제외 처리
 * 20200331 KHSONG FCA 신규건 수신시 컬럼정보의 비교시 NULL 오류로 보완함
 * 20201029 HWI1993 C20200617-000033 EDI 성능개선
 * 20200923	hwi1993	C20200827-000257 [SCM PI팀] EDI 연계 관련 GSCM setting 건, 소형 테슬라 추가. DIVISION_ID 를 하드코딩에서 변수로 변경 
                    위 내용 수정부분을 2020.10.29 머지함.
 * 20200209 KUNIID	[C20210208-000443] EDI CALL-OFF수신 시 적용 사항
										필수정보인 SOLD TO CUSTOMER가 누락된 건만 제외하고 나머지 정상 DATA는 GSCM에 매핑해 주도록 함
 * 20211222 HWI1993	PK오류 수정
 * 20220105	hwi1993	컷오프 수정과 같이 배포예정, SCM_MST_SITE_CUSTOMER 에 동일한 SHIPTO, SOLDTO 가 중복으로 있을 경우 ITEM 테이블에 중복값이 들어가는 오류 수정
 * 20220224 kdw2819 RDD_START가 NULL인 잘못된 데이터 제외 하도록 수정
   20220729 hwi1993	[C20220728-000062]DOC_STATUS 추가 ( 'S', 'W' 는 정상, 'E'는 오류, 국내는 정상건만 수신되는데 null 로 들어옴 )
   20221122 HWI1993 HWI1993	C20221103-000432 EDI 상시 점검
   20221130 HWI1993	[C20221103-000435] EDI데이터 송수신 I/F 변경
   20221130 HWI1993	[C20221103-000435] EDI데이터 송수신 I/F 변경 - SENDER CODE 룰 변경
   20221213 HWI1993	[C20221103-000435] sender_code Data Type이 5자리로 변경되어서 그에 맞도록 수정
   20221220 CHANO0612 [C20221221-000148] EDI Data I/F Status 변경 요청
   20230118 kdmcc14	[E20230118-000139] I/F 테이블 데이터 이관시 EDI_CALLOFF 테이블에 SENDER_CODE, SENDER_NAME 입력되도록 개선
   20240429 kcw3408  N:N Model Mapping_적재 배치 추가(PR_DM_CUST_ITEM_MAPPING)
   20241216	KANG.H.J [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 */
 --EXEC PR_DM_DNM_EDI_CALLOFF
CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALLOFF]
AS
  BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user			NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_DNM_EDI_CALLOFF';	

    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;	

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
	BEGIN TRY	
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

PRINT N'EDI I/F 데이터 이관 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI I/F 데이터 이관 (Start)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		BEGIN			
			EXEC PR_DM_DNM_EDI_CALLOFF_DATA
		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI I/F 데이터 이관 (End)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
PRINT N'EDI I/F 데이터 이관 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

PRINT N'EDI STATUS 상태코드 체크 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI STATUS 상태코드 체크 (Start)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
		BEGIN
			EXEC PR_DM_DNM_EDI_CALLOFF_STATUS
		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI STATUS 상태코드 (End)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
PRINT N'EDI STATUS 상태코드 체크 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

PRINT N'EDI N:N Model Mapping_적재 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI N:N Model Mapping_적재 (Start)  2024.04.29
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
		BEGIN
			EXEC PR_DM_CUST_MODEL_MAPPING_IF 'ERP'	;
			EXEC PR_DM_CUST_MODEL_MAPPING 'SCM'	;		
		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--EDI N:N Model Mapping_적재 (End)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
PRINT N'EDI N:N Model Mapping_적재 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

PRINT N'MKT FCST 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--MKT FCST 생성 (Start)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		BEGIN				
			EXEC PR_DM_DNM_EDI_CALLOFF_MKT_FCST;
		END		
PRINT N'MKT FCST 생성 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--MKT FCST 생성 (End)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    BEGIN CATCH
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
	  SELECT @v_log_message

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

ERR_RTN:

PRINT 'END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

END;


