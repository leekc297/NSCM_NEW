

/*
 * Program ID   : PR_SCP_PLN_INTERFACE_PLAN
 * Description  : 엔진결과 외부시스템 인터페이스 처리
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_INTERFACE_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.22   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.10   YYDOK         FINAL PLAN 코드변경(FI-> FN)
 * 2018.04.20   YYDOK         LOG추가, 오류처리 추가
 * 2018.05.15   YYDOK         특정시점이전에 운영DB에서는 INTERFACE처리하지 않고 RETURN처리
 * 2018.05.16   YYDOK         PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출추가
 * 2018.06.11   YYDOK         FINAL CONFIRM시 FP로 타겟전송 추가
 * 2018.07.03   YYDOK         전극,소형에 대해서 2018.10.01이전에는 인터페이스 전송방지
 * 2018.12.20   YYDOK         DM RTF전송여부 체크로직 반영
 * 2019.03.22   YYDOK         전지사업부가 아니면 RETURN처리
 * 2020.07.28   KSG           C20200723-000010 [SCM PI팀] I/F Blocking 관련 (SSP - SCP Final Plan 동기화)
 *                               PR_SSP_ANL_SHIP_REQ_SEMI Call 추가, 81/82 FN 에서만 수행함
 * 2020.08.14   KSG           [Packer Visivility] 외주용 Target 생성 Proc Call 추가 => SCS는 Call 하지 않기로 결정함
                                 SSP용 정보 생성 Call 추가
 * 2020.10.20   KSG           PJ2020-00520 전지 시스템 기능변경 및 신규개발 적용 프로젝트('20년하반기) : 소형사업부 SSP Ship Req 추가
 * 2020.12.08   KSG           C20201203-000215 SCP → Chempion 생산 계획 I/F 개발 건 
 * 2022.03.25   sclee         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.02.28   KSG           PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 소형 Pre FP 전송 추가
 * 2023.03.31	HRK			  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2024.03.22   KSG           E20240320-000935 ESS사업부 Final plan Target 정보(생산출하) → PSCM 전송 추가 건 : ESS / FN 후 SCS Target 생성 추가
 * 2024.11.19   KSG           E20241114-000976 81_ST Global PSI New 생성 시점 외 1건 : GSCM → PSCM 출하 타겟 Order type F 수행중지
 * 2024.12.03   KSG           [PJ20249346] LGES SCP 개선과제 이행 : 소형 Semi/전극 MAin 도 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출
 * 2024.12.27   KSG           NERP - MRP에 생산타겟 전송데이타 생성
 * 2025.04.22   kimcd         PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 
 *                            - 자동차 MA에서 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출하여 DM RTF 형성
 * 2025.10.31	YMH			  [E20251020-000203] MRP 전송 FN 에서 MA/SE/FN 으로 변경
 * 2026.02.06   YMH			  [E20260120-000702] DIV:40 PLAN_TYPE:FN SEQ:1 일때 DM SALES CUTOFF BAT 수행
 * 2026.04.09   YMH           [E20260408-001129] 81_FN 이후 SALES PLAN C 프로시져 호출 연동 진행건 81 + 81_JV
 * 2026.07.21	ymh			  E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_INTERFACE_PLAN]
    ( 
      @x_division_id          NVARCHAR(10)
    , @x_start_yyyymmdd       NVARCHAR(8)
    , @x_plan_type            NVARCHAR(40)
    , @x_seq                  INT
    , @x_user_id              NVARCHAR(100)
) AS
  BEGIN

    -- PJ20216891
    --전지사업부가 아니면 리턴.
    -- IF ( @X_DIVISION_ID NOT IN ('81','82','40','EE' ) )
    -- 2023.03.31 HM JV IF ( @X_DIVISION_ID NOT IN ('81','82','40','EE','81_UC','EE_UC' ) )
	-- 2023.03.31 HM JV 가상 사업부 추가 대응
	IF NOT EXISTS (SELECT 1
				 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
				WHERE DM.DIVISION_ID = @X_DIVISION_ID
				  AND DM.VALID_YN	 = 'Y') 
       BEGIN
           RETURN;   
       END     
    
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정  
    DECLARE @v_batch_user               NVARCHAR(150) = N'scp_batch';    
    SET @v_batch_user = @x_user_id  
    DECLARE @v_program_name             NVARCHAR(150) = 'PR_SCP_PLN_INTERFACE_PLAN';  
    DECLARE @v_log_type                 NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count                INTEGER = 0;  
    DECLARE @v_log_message              NVARCHAR(1000);  
    DECLARE @v_description              NVARCHAR(500);  
    DECLARE @v_table_id                 NVARCHAR(150) = 'PLN_INTERFACE';  
    DECLARE @d_event_date               DATETIME;
		  
    DECLARE @X_DM_RTF_YN                NVARCHAR(1) = 'Y';
	
    -- PJ20216891
    DECLARE @v_tb_target_division TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division
	-- 2023.03.31 HM JV 가상 사업부 추가 대응
	SELECT DM.DIVISION_ID
	  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
	 WHERE DM.ATTRIBUTE3 != 'EE'
	   AND DM.VALID_YN	  = 'Y'
	------------------------------------------------------
    -- 2023.03.31 HM JV SELECT '40' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV SELECT '81' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV SELECT '81_UC' DIVISION_ID UNION ALL
    -- 2023.03.31 HM JV SELECT '82' DIVISION_ID
	------------------------------------------------------
    
    SET @v_log_type = N'START';     
    SET @v_log_message = N'########## START of procedure ##########';  
    SET @v_description = N'['+@x_division_id +',' +@x_start_yyyymmdd+',' +@x_plan_type+',' +CONVERT(VARCHAR,@x_seq)  + ']';  
    SET @d_event_date = SYSDATETIME();  
  
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name  
                              ,@p_log_type      =@v_log_type  
                              ,@p_log_count     =@n_log_count   
                              ,@p_log_message   =@v_log_message   
                              ,@p_description   =@v_description   
                              ,@p_event_date    =@d_event_date  
                              ;  
        
    DECLARE @rows INT=0;     
    DECLARE @rows_c INT=0;     
    DECLARE @x_plan_id NVARCHAR(100);
    
    select top 1 @x_plan_id = P.PLAN_ID
      from scm_mst_plan_detail d with(nolock),
           scm_mst_plan        p with(nolock),
           scm_mst_modeling    m with(nolock)
     where 1=1
       and m.MODELING_ID   = d.MODELING_ID
       and m.PLAN_CYCLE    = 'WEEKLY'
       and m.DIVISION_ID   = d.DIVISION_ID
       and m.MODELING_ID   = d.MODELING_ID
       and p.DIVISION_ID   = d.DIVISION_ID
       and p.PLAN_CYCLE    = m.PLAN_CYCLE
       and p.PLAN_ID       = d.PLAN_ID
       and d.PLAN_STATUS   = '1'
       and d.UI_DISPLAY_YN = 'Y'
       AND D.DIVISION_ID   = @x_division_id
       AND p.plan_name     = @x_start_yyyymmdd
       AND d.plan_type     = @x_plan_type 
       AND d.plan_seq      = @x_seq
       ;     

    BEGIN TRY 
    BEGIN 

          -------------------------------------------------------------------------------------------------  
          -- 20230228  PJ20230691R  소형 Pre FP 전송 추가
          IF  @x_plan_type = 'PR' AND @x_division_id = '40'--PRE PLAN
          BEGIN
          
              -------------------------------------------------------------------------------------------------  
              -- FP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_PROD_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
          
              -------------------------------------------------------------------------------------------------  
              -- FP에 출하타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_SHIP_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행         
                
          END  -- IF  @x_plan_type = 'PR' --PRE PLAN         

          -------------------------------------------------------------------------------------------------  

          IF  @x_plan_type = 'MA' --MAIN PLAN
          BEGIN
		  
              -------------------------------------------------------------------------------------------------  
		      -- 2024.12.03 [PJ20249346] 전극 Main 도 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출
              -- DM에 ALLOCATION정보를 이용하여 BALANCE반영 프로그램 호출
			  -- DM 정보 전송이 최우선 순위임
              -------------------------------------------------------------------------------------------------    
			   -- 20241210 PI 요청으로 보류
			  IF  @x_division_id IN ( '81', 'EE')  --MAIN PLAN  -- 2025.04.22 PJ20249548R 자동차 사업부 호출 추가
			  BEGIN             
				  SELECT @X_DM_RTF_YN =  ISNULL(DM_RTF_YN,'N')
					FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
				   WHERE DIVISION_ID         = @x_division_id
					 AND PLAN_START_YYYYMMDD = @x_start_yyyymmdd;

				  IF @X_DM_RTF_YN = 'Y'  --DM RTF INTERFACE='Y'경우만 호출
				  BEGIN
                           
					  EXEC @ROWS = [dbo].[PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE]
								   @p_division_id    = @x_division_id,
								   @p_plan_id        = @x_plan_id
					  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행                   
				  END
			  END  --IF  AND @x_division_id  'EE' --MAIN PLAN
          
              -------------------------------------------------------------------------------------------------  
              -- FP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_PROD_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
          
              -------------------------------------------------------------------------------------------------  
              -- FP에 출하타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_SHIP_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행                                       
          
              -------------------------------------------------------------------------------------------------  
              -- MRP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              -- E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청
              -- 사용안하는 기존 MRP 로직 제거
              /*
              EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id  
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              */
          
              -------------------------------------------------------------------------------------------------  
              -- NERP - MRP에 생산타겟 전송데이타 생성 : NERP 는 MA 정보 수신 제외되어 있어 생성 안 하도록 처리(20250115)
              -------------------------------------------------------------------------------------------------
			  -- 20250-10-31 YMH E20251020-000203 MA/SE/FN 에서 MRP 전송
			  EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id  
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
            
          END  -- IF  @x_plan_type = 'MA' --MAIN PLAN

		  -- 20250-10-31 YMH E20251020-000203 MA/SE/FN 에서 MRP 전송
		  IF  @x_plan_type = 'SE' --SEMI PLAN
		  BEGIN
			  EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id  
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
		  END  --IF  @x_plan_type = 'SE' 

          -------------------------------------------------------------------------------------------------  
		  -- 2024.12.03 [PJ20249346] 소형 Semi 도 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출
          -------------------------------------------------------------------------------------------------  
          IF  @x_plan_type = 'SE' AND @x_division_id = '40' --SEMI PLAN
          BEGIN
              -------------------------------------------------------------------------------------------------  
              -- DM에 ALLOCATION정보를 이용하여 BALANCE반영 프로그램 호출
			  -- DM 정보 전송이 최우선 순위임
              -------------------------------------------------------------------------------------------------                
              SELECT @X_DM_RTF_YN =  ISNULL(DM_RTF_YN,'N')
                FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
               WHERE DIVISION_ID         = @x_division_id
                 AND PLAN_START_YYYYMMDD = @x_start_yyyymmdd;

              IF @X_DM_RTF_YN = 'Y'  --DM RTF INTERFACE='Y'경우만 호출
              BEGIN
                           
                  EXEC @ROWS = [dbo].[PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE]
                               @p_division_id    = @x_division_id,
                               @p_plan_id        = @x_plan_id
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행                   
              END
          END  --IF  @x_plan_type = 'SE' AND @x_division_id = '40' --SEMI PLAN

          -------------------------------------------------------------------------------------------------  
          
          IF  @x_plan_type = 'FN'  --FINAL PLAN
          BEGIN

              -------------------------------------------------------------------------------------------------  
              -- DM에 ALLOCATION정보를 이용하여 BALANCE반영 프로그램 호출
			  -- DM 정보 전송이 최우선 순위임
              -------------------------------------------------------------------------------------------------                
              SELECT @X_DM_RTF_YN =  ISNULL(DM_RTF_YN,'N')
                FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
               WHERE DIVISION_ID         = @x_division_id
                 AND PLAN_START_YYYYMMDD = @x_start_yyyymmdd;

              IF @X_DM_RTF_YN = 'Y'  --DM RTF INTERFACE='Y'경우만 호출
              BEGIN
                           
                  EXEC @ROWS = [dbo].[PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE]
                               @p_division_id    = @x_division_id,
                               @p_plan_id        = @x_plan_id
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행                   
              END

			  -- E20260120-000702 40사업부 FN 수행 로직 개선 검토 요청
			  -- SCP_PLN_INTERFACE_YN 여부 상관없이 무조건 호출 
			  -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 수행하던 안하던 해당 로직 후에 수행해야함.
              -- E20260408-001129  81_FN 이후 SALES PLAN C 프로시져 호출 연동 진행건
			  IF (@x_division_id = '40' OR (EXISTS(SELECT * FROM SCM_MST_DIVISION WITH(NOLOCK)  WHERE ATTRIBUTE3 = '81' AND DIVISION_ID = @x_division_id))) AND @x_seq = 1
			  BEGIN
				EXEC @ROWS = [dbo].[PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE] 
				  @p_division_id = @x_division_id,
				  @p_cutoff_yyyymmdd = N''
				  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행                   
			  END


              -------------------------------------------------------------------------------------------------  
              -- FP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_PROD_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행             
          
              -------------------------------------------------------------------------------------------------  
              -- FP에 출하타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_FP_SHIP_TARGET]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
                        
              -------------------------------------------------------------------------------------------------  
              -- MRP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------        
              -- E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청
              -- 사용안하는 기존 MRP 전송 제거
              /*
              EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET]
                            @p_division_id    = @x_division_id,
                            @p_start_yyyymmdd = @x_start_yyyymmdd,
                            @p_plan_type      = @x_plan_type,
                            @p_seq            = @x_seq,
                            @p_user_id        = @x_user_id  
                            
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              */
          
              -------------------------------------------------------------------------------------------------  
              -- NERP - MRP에 생산타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------
              EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE]
                           @p_division_id    = @x_division_id,
                           @p_start_yyyymmdd = @x_start_yyyymmdd,
                           @p_plan_type      = @x_plan_type,
                           @p_seq            = @x_seq,
                           @p_user_id        = @x_user_id  
                           
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행

              -- E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청 추가로직 시작
              -- 20260721 82 FN = JV 혼용생산의 주체의 FN 이 수행되면
              -- JV 혼용생산 DIV 를 재전송 한다.
              declare @MRP_DIV		nvarchar(50)
              declare @MRP_PLAN_TYPE	nvarchar(50)
              declare @MRP_PLAN_SEQ	nvarchar(50)

              DECLARE MRP_DIV CURSOR FOR

              SELECT  DISTINCT MS2.DIVISION_ID , PLN_DATA.PLAN_TYPE , PLN_DATA.PLAN_SEQ
              FROM    SCM_MST_SITE MS WITH(NOLOCK)
                  INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
                  ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID
                  INNER JOIN (
		              SELECT * FROM 
		              (
			              SELECT 
				                   PLN.DIVISION_ID 
				               , DTL.PLAN_TYPE
				               , DTL.PLAN_SEQ
				               , ROW_NUMBER() OVER(PARTITION BY PLN.DIVISION_ID , DTL.PLAN_TYPE , DTL.PLAN_SEQ ORDER BY PLN.DIVISION_ID , DTL.PLAN_TYPE , DTL.PLAN_SEQ DESC ) AS RN
			              FROM SCM_MST_PLAN PLN WITH(NOLOCK)
			              JOIN SCM_MST_PLAN_DETAIL AS DTL WITH(NOLOCK)
			              ON PLN.PLAN_ID = DTL.PLAN_ID
			              AND PLN.PLAN_CYCLE = 'WEEKLY'
			              AND PLN.PLAN_NAME = @x_start_yyyymmdd
			              AND PLN.DIVISION_ID = DTL.DIVISION_ID
			              AND DTL.PLAN_TYPE = 'FN'
			              AND DTL.PLAN_STATUS = '1'
		              ) AS LIST
		              WHERE RN = 1
                  ) AS PLN_DATA
	              ON  MS2.DIVISION_ID = PLN_DATA.DIVISION_ID
              WHERE   MS.DIVISION_ID = @x_division_id -- 82
              AND     MS.SITE_TYPE   = 'PLANT'
              AND     MS.VALID_YN    = 'Y'

              OPEN MRP_DIV;

              FETCH NEXT FROM MRP_DIV INTO @MRP_DIV, @MRP_PLAN_TYPE, @MRP_PLAN_SEQ
		 
              WHILE (@@FETCH_STATUS = 0)
              BEGIN
    
	              EXEC @ROWS = [dbo].[PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE]
                                          @p_division_id    = @MRP_DIV,
                                          @p_start_yyyymmdd = @x_start_yyyymmdd,
                                          @p_plan_type      = @MRP_PLAN_TYPE,
                                          @p_seq            = @MRP_PLAN_SEQ,
                                          @p_user_id        = @x_user_id  
                         
	              IF (@rows < 0 )  SET @rows_c = -1

                  FETCH NEXT FROM MRP_DIV INTO @MRP_DIV, @MRP_PLAN_TYPE, @MRP_PLAN_SEQ
              END

              CLOSE MRP_DIV;
              DEALLOCATE MRP_DIV; 	
              -- E20260716-001301 Virtual Plant 생산계획 MRP 전송 로직 수정 요청 추가 로직 끝.

          
              -------------------------------------------------------------------------------------------------  
              -- SSP에 출하타겟 전송데이타 생성 : 20200728 C20200723-000010 추가     
              -- 20201020 PJ2020-00520 소형(40)사업부 SSP Ship Req 추가
              -------------------------------------------------------------------------------------------------
			  
              -- PJ20216891
              -- IF  @x_division_id IN ('81', '82', '40') -- 40/81/82 FN 에서만 수행함
              IF  @x_division_id IN (SELECT DIVISION_ID FROM @v_tb_target_division) -- 40/81/82/81_UC FN 에서만 수행함
              BEGIN
                  EXEC @ROWS = [dbo].[PR_SSP_ANL_SHIP_REQ_SEMI]
                               @p_division_id    = @x_division_id,
                               @p_start_yyyymmdd = @x_start_yyyymmdd,
                               @p_plan_type      = @x_plan_type,
                               @p_seq            = @x_seq,
                               @p_user_id        = @x_user_id
                           
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              END -- IF  @x_division_id IN ('81', '82', '40') -- 40/81/82 FN 에서만 수행함

              -------------------------------------------------------------------------------------------------  
              -- SSP에 Semi 타겟 전송데이타 생성 : 20200814 [Packer Visivility]
              -------------------------------------------------------------------------------------------------   

			  -- 40 DIVISION REQ 생성(SSP_ANL_SHIP_REQ_P)
              IF  @x_division_id IN ('40') -- 40 FN 에서만 수행함
              BEGIN             
                  EXEC @ROWS = [dbo].[PR_SSP_ANL_SHIP_REQ_P]
                                @p_division_id    = @x_division_id,
                                @p_start_yyyymmdd = @x_start_yyyymmdd,
                                @p_plan_type      = @x_plan_type,
                                @p_seq            = @x_seq
                            
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              END -- IF  @x_division_id IN ('40') -- 40 FN 에서만 수행함

			  -- SCS에 Packer 출하타겟 'FN'버전 전송데이타 생성(SCP Ship Plan)
              -- PJ20216891
			  -- 2024.11.19 E20241114-000976 : GSCM → PSCM 출하 타겟 Order type F 수행중지
              -- IF  @x_division_id IN ('81', '82', '40') -- 40/81/82 FN 에서만 수행함
          /*    IF  @x_division_id IN (SELECT DIVISION_ID FROM @v_tb_target_division) -- 40/81/82/81_UC FN 에서만 수행함
              BEGIN
                  EXEC @ROWS = [dbo].[PR_SSP_XIF_SCS_PACK_SHIP_PLAN_F_S]
                               @p_division_id    = @x_division_id,
                               @p_start_yyyymmdd = @x_start_yyyymmdd,
                               @p_plan_type      = @x_plan_type,
                               @p_seq            = @x_seq,
                               @p_user_id        = @x_user_id
                           
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              END 
			  */
			  
              -------------------------------------------------------------------------------------------------  
              -- SSP에 FG 타겟 전송데이타 생성
              -------------------------------------------------------------------------------------------------                
              EXEC @ROWS = [dbo].[PR_SSP_ANL_SHIP_REQ_FG] 
                            @p_division_id    = @x_division_id,
                            @p_plan_id        = @x_plan_id
                            
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
                        
              -------------------------------------------------------------------------------------------------  
              -- Chempion 생산 계획 I/F용 정보 생성 프로그램 호출 : 20201208  C20201203-000215 추가
              -------------------------------------------------------------------------------------------------                
              EXEC @ROWS = [dbo].[PR_SCP_PLN_PEGGING_PLAN]
                            @p_division_id    = @x_division_id,
                            @p_start_yyyymmdd = @x_start_yyyymmdd,
                            @p_plan_type      = @x_plan_type,
                            @p_seq            = @x_seq,
                            @p_user_id        = @x_user_id  
                            
              IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
			  			  
              ------------------------------------------------------------------------------------------------- 
              -- 20240322  E20240320-000935 : ESS / FN 후 SCS Target 생성 추가
              ------------------------------------------------------------------------------------------------- 
              IF  @x_division_id IN ('82') -- 82 FN 에서만 수행함
              BEGIN             
                  EXEC @ROWS = [dbo].[PR_SCP_IF_SCS_SHIP_TARGET]
                                @p_division_id    = @x_division_id,
                                @p_start_yyyymmdd = @x_start_yyyymmdd
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행

                  EXEC @ROWS = [dbo].[PR_SCP_IF_SCS_PROD_TARGET]
                                @p_division_id    = @x_division_id,
                                @p_start_yyyymmdd = @x_start_yyyymmdd
                            
                  IF (@rows < 0 )  SET @rows_c = -1 -- GOTO _RETURN_ERR_CODE -- Error 라도 다음 작업 수행
              END -- IF  @x_division_id IN ('82') -- 82 FN 에서만 수행함
                 
           END -- IF  @x_plan_type = 'FN'  --FINAL PLAN
              
        -----------------------------------------------------------  
        -- 실행 Logic END --  
        -----------------------------------------------------------  
       -- IF @@TRANCOUNT > 0  
       --   BEGIN  
       --     COMMIT ;  
       --   END;         
       IF (@rows_c < 0 )  GOTO _RETURN_ERR_CODE -- 위 작업 중 하나라도 Error 면 Error 처리
  
        -- TXN LOG  
        SET @v_log_type = N'TXN';     
        SET @n_log_count = @@ROWCOUNT;  
        SET @v_log_message = N'INSERT INTO '+@v_table_id;  
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);  
        SET @d_event_date = SYSDATETIME();  
  
        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name  
                                  ,@p_log_type      =@v_log_type  
                                  ,@p_log_count     =@n_log_count   
                                  ,@p_log_message   =@v_log_message   
                                  ,@p_description   =@v_description   
                                  ,@p_event_date    =@d_event_date 
                                  ;                  
    
    END          
    END TRY  
  
    BEGIN CATCH  
    --  IF @@TRANCOUNT > 0  
    --    BEGIN  
    --      ROLLBACK   
    --    END;  
        
      -- ERROR LOG  
      SET @v_log_type = N'ERROR';  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());  
      SET @d_event_date = SYSDATETIME();  
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name  
                                ,@p_log_type      =@v_log_type  
                                ,@p_log_count     =@n_log_count   
                                ,@p_log_message   =@v_log_message   
                                ,@p_description   =@v_description   
                                ,@p_event_date    =@d_event_date
                                ;  
--      PRINT @@ERROR  
      return -1  
    END CATCH; 

    -- 종료 LOG  
    SET @v_log_type = N'END';  
    SET @v_log_message = N'########## END of procedure ##########';  
    SET @v_description = N'['+@x_division_id +',' +@x_start_yyyymmdd+',' +@x_plan_type+',' +CONVERT(VARCHAR,@x_seq)  + ']';  
    SET @d_event_date =  SYSDATETIME()  ;   -- 로그 정렬시에 일자와 LOG_TYPE 순서대로 보기 위해서  
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name  
                              ,@p_log_type      =@v_log_type  
                              ,@p_log_count     =@n_log_count   
                              ,@p_log_message   =@v_log_message   
                              ,@p_description   =@v_description   
                              ,@p_event_date    =@d_event_date  
                              ;  
    return 1   
    _RETURN_ERR_CODE:  
        BEGIN  
             RETURN -1  
        END;         

  END;

