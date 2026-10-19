



CREATE   PROCEDURE [dbo].[PR_SCP_ANL_MONTH_END_STOCK_R]
AS

/*
 * Program ID   : PR_SCP_ANL_MONTH_END_STOCK_R
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.03.16   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - Initial Release [PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선
 * 2022.05.17 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 마감환율 적용
 * 2022.05.17 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 위안화 RMB -> CNY (하드코딩으로 변경 필요)
 * 2022.07.01   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - SOBKZ값에 따른 SUPPLIER_CODE, SUPPLIER_NAME 표시값 변경
 * 2022.08.11 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 컬럼추가 (가용재고, 보류재고, In-Transit)
 * 2022.09.14 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 당월 매일 재고 조회 기능 요청 => Monthly / Daily 구분 처리 필요
 * 2023.02.14   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 월령재고 컬럼 추가
 * 2023.02.21 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 중복 구분 위한 EBELP 등 추가 => ATTRIBUTE5 에 입력
 * 2023.04.28 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 환율정보 추가
 * 2023.05.02 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - A000 추가 작업
 * 2023.10.20 : vadabi3        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 재고 수량 개선
 * 2024.10.04   ksg            E20241004-000934 ENDING INVENTORY 월마감 재고 집계 시 '미착'재고 있을 경우에만 마감데이터 집계
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.12.15	vadabi5	       NERP) QA, 개발 DB 적용
 * 2025.06.19   김준규         [IT20250117A] NERP 오펀차수별 Mapping Code적용 
 * 2025.07.04   김준규         [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행
 * 2025.12.17	YMH			   E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건
 ----------------------------------------------------------------------------------------------------
 EXEC NERP_PR_SCP_ANL_MONTH_END_STOCK_R
 EXEC      PR_SCP_ANL_MONTH_END_STOCK_R


 */

BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
  DECLARE @v_batch_user              NVARCHAR(150) = N'SCP_batch';
  
  -- LOG 용 변수 설정
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_MONTH_END_STOCK_R';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  
  -- LOOP 용 변수 설정
  DECLARE @v_start_cnt    INTEGER = 0;
  DECLARE @v_end_cnt1     INTEGER;
  DECLARE @v_end_cnt2     INTEGER;
  DECLARE @v_new_matnr    VARCHAR(18);
  DECLARE @v_LGOBE_cnt    INTEGER = 0; -- E20241004-000934 미착 Qty

    -- NERP 매핑코드
  DECLARE @v_ESOC NVARCHAR(8);
  DECLARE @v_A000 NVARCHAR(8); --A000 
  SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_ANL_MONTH_END_STOCK_R', 'ESOC')  
  SELECT @v_A000  =  SEGMENT2 
	FROM SCM_CODE_LOOKUP_VALUE 
   WHERE LOOKUP_TYPE_CODE = 'PR_SCP_ANL_MONTH_END_STOCK_R'
	 AND SEGMENT1 = 'WERKS'
  --SELECT @v_ESOC, @v_A000

  ------------------------------------------------------------------------
  -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
  ------------------------------------------------------------------------
  DECLARE @V_NERP_ROLLIN_STAGE NVARCHAR(30);
  DECLARE @V_NERP_START_YYYYMMDD NVARCHAR(8);
  DECLARE @V_NERP_APPLY_YYYYMMDD NVARCHAR(8);

  SELECT TOP 1 @V_NERP_ROLLIN_STAGE = LMD.SEGMENT1
        ,@V_NERP_START_YYYYMMDD = LMD.SEGMENT2
        ,@V_NERP_APPLY_YYYYMMDD = LMD.SEGMENT3
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL lmd WITH(NOLOCK)
  JOIN   SCM_ADM_LOOKUP_MASTER alm WITH(NOLOCK)
  ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
  AND    ALM.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
  WHERE  ALM.VALID_YN = 'Y'
  AND    LMD.VALID_YN = 'Y';
  ------------------------------------------------------------------------
  -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End
  ------------------------------------------------------------------------

  -- 시작 LOG  (START)
  SET @v_log_type = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  -- 시작 LOG  (END)  
	
	--------------------------------------------------------------------------------------
	-- 0. 복사대상 추출 
	--------------------------------------------------------------------------------------
	DECLARE @v_before_month nvarchar(8);
	SELECT @v_before_month =  CONVERT(CHAR(6),DATEADD(MM,-1,GETDATE()),112);

	--------------------------------------------------------------------------------------
	-- 0-1. PLANT별 1개 IFSEQNO 본데이블에 반영하기 때문에 합쳐지는 PLANT의 IFSEQNO를 UPDATE 한다.
	--------------------------------------------------------------------------------------
    --아래 처리 로직은 어느정도 시간이 걸리는 로직이기 때문에 NERP 컨버전 전월에 한해서만 처리하는 것으로 함
    IF FORMAT(DATEADD(MONTH,-1,CONVERT(DATE,@V_NERP_APPLY_YYYYMMDD) ),'yyyyMM') =  @v_before_month 
    BEGIN
        -- 합쳐지는 PLANT 만 찾아낸다
        -- 매핑 규칙과 대표 IFSEQNO를 저장할 테이블 변수 생성
        DECLARE @T_PLANT_IFSEQNO TABLE (
             ORIG_PLANT  NVARCHAR(10)
            ,MAP_PLANT   NVARCHAR(10)
            ,MAP_IFSEQNO BIGINT      
            ,CONC_PLANT  NVARCHAR(1000)--참조
        );

        WITH W_CUP AS (
            SELECT NEW_VALUE1
                  ,MIN_OLD_VALUE1 = MIN(OLD_VALUE1)
                  ,STRING_AGG(OLD_VALUE1,',') WITHIN GROUP (ORDER BY OLD_VALUE1) AS CONC_OLD_VALUE1
            FROM   NERP_CONV_MASTER_CFM_V MCV WITH(NOLOCK)
            WHERE  CODETYPE = 'PLANT_ID'
            AND    ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE
            GROUP BY NEW_VALUE1
            HAVING COUNT(*)>1
        )
        , W_GET_PLANT AS (
            SELECT NEW_VALUE1
                  ,MIN_OLD_VALUE1
                  ,CONC_OLD_VALUE1
                  ,token AS ORIG_PLANT
            FROM   W_CUP AS WR
            CROSS APPLY STRING_SPLIT(CONC_OLD_VALUE1, ',')
        )
        , W_GET_IFID AS (
            SELECT 
                WGP.ORIG_PLANT,
                WGP.MIN_OLD_VALUE1,
                (SELECT TOP 1 ESR.IFSEQNO 
                 --FROM [10.34.220.88,7433].[LGCE_INF].[DBO].XIF_ERP_ZMM_GSCM_END_STOCK_R ESR WITH(NOLOCK) 
                 FROM  XIF_ERP_ZMM_GSCM_END_STOCK_R_SN ESR WITH(NOLOCK)
                 WHERE WERKS = WGP.MIN_OLD_VALUE1 
                 AND   SPMON = @v_before_month
                 AND   TRANSFER_FLAG = 'N'
                 ORDER BY ESR.IFSEQNO DESC) AS Rep_IFSEQNO,
                WGP.CONC_OLD_VALUE1
            FROM W_GET_PLANT AS WGP
            GROUP BY WGP.ORIG_PLANT,WGP.MIN_OLD_VALUE1,WGP.CONC_OLD_VALUE1
        )
        INSERT INTO @T_PLANT_IFSEQNO(ORIG_PLANT,MAP_PLANT,MAP_IFSEQNO,CONC_PLANT)
        SELECT * 
        FROM   W_GET_IFID
        WHERE  ORIG_PLANT <> MIN_OLD_VALUE1;
        -- SELECT *FROM @T_PLANT_IFSEQNO;

        UPDATE ESR
        SET    ESR.IFSEQNO = PIF.MAP_IFSEQNO
        --SELECT *
        FROM   XIF_ERP_ZMM_GSCM_END_STOCK_R_SN ESR
        INNER JOIN @T_PLANT_IFSEQNO AS PIF ON ESR.WERKS = PIF.ORIG_PLANT;
    
        -----------------------------------------------------------------------------------------------------------
        -- 0-2. 2025.07.04 김준규 [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행 시작
        -----------------------------------------------------------------------------------------------------------
        DECLARE @CNT_DUP_PLANTBY_SPMON INT=0;
        DECLARE @NOW_DATE  AS NVARCHAR(20);
        DECLARE @NOW_TIME  AS NVARCHAR(20);
        select @NOW_DATE = convert(char(8), getdate(), 112);
        select @NOW_TIME = CONCAT(FORMAT(GETDATE(), 'HH'),FORMAT(GETDATE(), 'mm'));
    
                        -- 20 19초
        WITH W_RAW AS (
            SELECT SPMON, BUKRS, WERKS, LGORT, BKLAS, MATNR, SOBKZ, LIFNR, LIFNR1, CASE WHEN ISNULL(A.SOBKZ, '') = 'O' THEN A.LIFNR ELSE A.LIFNR1 END SUPPLIER_CODE, count(*) AS CNT
                FROM XIF_ERP_ZMM_GSCM_END_STOCK_R_SN A  with (nolock)
            where SPMON =  @v_before_month
            AND   A.TRANSFER_FLAG = 'N'
            group by SPMON, BUKRS, WERKS, LGORT, BKLAS, MATNR, SOBKZ, LIFNR, LIFNR1, CASE WHEN ISNULL(A.SOBKZ, '') = 'O' THEN A.LIFNR ELSE A.LIFNR1 END
        )
        , W_CONV AS (
            SELECT SPMON, BUKRS, WERKS, LGORT, BKLAS, MATNR, SOBKZ, LIFNR, LIFNR1, SUPPLIER_CODE
                    , NC.NEW_VALUE1  AS TOBE_COMPANY
                    , NP.NEW_VALUE1  AS TOBE_PLANT
                    , NST.NEW_VALUE1 AS TOBE_STORAGE_PLANT
                    , NST.NEW_VALUE2 AS TOBE_STORAGE
                    , E.NEW_VALUE2   AS TOBE_VALUATION_CLASSS
                    , NV.NEW_VALUE1  AS TOBE_SUPPLIER
                    , CNT
            FROM W_RAW AS WR
            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) AS NC ON NC.OLD_VALUE1 = BUKRS
            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) AS NP ON NP.OLD_VALUE1 = WERKS
            LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2
                            FROM NERP_CONV_MASTER_CFM_V
                        WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE
                        and OLD_VALUE1 IN (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE)
                        ) AS NST ON NST.OLD_VALUE1 = WERKS
                                AND NST.OLD_VALUE2 = LGORT
            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'VENDOR_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) AS NV ON NV.OLD_VALUE1 = SUPPLIER_CODE
            LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2
                                         FROM NERP_CONV_MASTER_CFM_V
                                        WHERE CODETYPE = 'MATKL'
                                          AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE
                                        ) E  ON MATNR   = E.NEW_VALUE1 AND BKLAS in ('3000','3001') and ISNULL(E.NEW_VALUE2,'') like 'R%'
            WHERE NC.NEW_VALUE1 IS NOT NULL OR NP.NEW_VALUE1 IS NOT NULL OR NST.NEW_VALUE1 IS NOT NULL OR NST.NEW_VALUE2 IS NOT NULL OR NV.NEW_VALUE1 IS NOT NULL OR E.NEW_VALUE2 IS NOT NULL 
            --------------------------------------------------------------------------------------
        )
        --SELECT * FROM  W_CONV ;
        UPDATE SRS
           SET SRS.BUKRS          = ISNULL(WCO.TOBE_COMPANY , SRS.BUKRS          )
              ,SRS.WERKS          = ISNULL(WCO.TOBE_PLANT   , SRS.WERKS          )
              ,SRS.LGORT          = ISNULL(WCO.TOBE_STORAGE , SRS.LGORT          )
              ,SRS.BKLAS          = ISNULL(WCO.TOBE_VALUATION_CLASSS , SRS.BKLAS )
              ,SRS.LIFNR          = CASE WHEN ISNULL(SRS.SOBKZ, '') = 'O' THEN ISNULL(WCO.TOBE_SUPPLIER , SRS.LIFNR ) ELSE SRS.LIFNR  END
              ,SRS.LIFNR1         = CASE WHEN ISNULL(SRS.SOBKZ, '') = 'O' THEN ISNULL(WCO.TOBE_SUPPLIER , SRS.LIFNR1) ELSE SRS.LIFNR1 END
              ,SRS.UPDATE_USER_ID = @v_batch_user
              ,SRS.UPDATE_DATE    = @NOW_DATE
              ,SRS.UPDATE_TIME    = @NOW_TIME
        --SELECT 'DUMMY' DUMMY
        --    ,TOBE_COMPANY          = ISNULL(WCO.TOBE_COMPANY , SRS.BUKRS          )
        --    ,TOBE_PLANT            = ISNULL(WCO.TOBE_PLANT   , SRS.WERKS          )
        --    ,TOBE_STORAGE          = ISNULL(WCO.TOBE_STORAGE , SRS.LGORT          )
        --    ,TOBE_VALUATION_CLASSS = ISNULL(WCO.TOBE_VALUATION_CLASSS , SRS.BKLAS )
        --    ,SUPPLIER_CODE         = ISNULL(WCO.SUPPLIER_CODE, (CASE WHEN ISNULL(SRS.SOBKZ, '') = 'O' THEN SRS.LIFNR ELSE SRS.LIFNR1 END))
        --    ,BUKRS                 = ISNULL(SRS.BUKRS          ,'')
        --    ,WERKS                 = ISNULL(SRS.WERKS          ,'')
        --    ,LGORT                 = ISNULL(SRS.LGORT          ,'')
        --    ,BKLAS                 = ISNULL(SRS.BKLAS          ,'')
        --    ,LIFNR                 = ISNULL(SRS.LIFNR          ,'')
        --    ,LIFNR1                = ISNULL(SRS.LIFNR1         ,'')
        --    ,SPMON                 = ISNULL(SRS.SPMON          ,'')
        --    ,*
        FROM .XIF_ERP_ZMM_GSCM_END_STOCK_R_SN AS SRS
        JOIN  W_CONV AS WCO
        ON    1 = 1
        AND   ISNULL(SRS.BUKRS          ,'') = ISNULL(WCO.BUKRS ,'')
        AND   ISNULL(SRS.WERKS          ,'') = ISNULL(WCO.WERKS ,'')
        AND   ISNULL(SRS.LGORT          ,'') = ISNULL(WCO.LGORT ,'')
        AND   ISNULL(SRS.BKLAS          ,'') = ISNULL(WCO.BKLAS ,'')
        AND   ISNULL(SRS.MATNR          ,'') = ISNULL(WCO.MATNR ,'')
        AND   ISNULL(SRS.SOBKZ          ,'') = ISNULL(WCO.SOBKZ ,'')
        AND   ISNULL(SRS.LIFNR          ,'') = ISNULL(WCO.LIFNR ,'')
        AND   ISNULL(SRS.LIFNR1         ,'') = ISNULL(WCO.LIFNR1,'')
        AND   SRS.SPMON                      = WCO.SPMON
        AND   SRS.SPMON                      = @v_before_month
        AND   SRS.TRANSFER_FLAG              = 'N'
        ;

    END;--IF FORMAT(DATEADD(MONTH,-1,CONVERT(DATE,@V_NERP_APPLY_YYYYMMDD) ),'yyyyMM') =  @v_before_month BEGIN
    
    SELECT TOP 1 @CNT_DUP_PLANTBY_SPMON = COUNT(*)
    FROM (
        SELECT DISTINCT SPMON,WERKS,IFFROM=CASE WHEN LEN(IFSEQNO) <15 THEN 'GERP' ELSE 'NERP' END
        FROM   XIF_ERP_LONG_TERM_STOCK_R_SN
        WHERE  SPMON = @v_before_month
        AND    TRANSFER_FLAG = 'N'
    ) X
    GROUP BY SPMON,WERKS
    HAVING COUNT(*) > 1;

    --PRINT @CNT_DUP_PLANTBY_SPMON;
    --GERP,NERP 중복으로 입력되었을 경우 중단하고 에러 발생
    IF @CNT_DUP_PLANTBY_SPMON > 0 BEGIN

        SET @v_log_type = N'ERROR';
        SET @v_log_message = N'GERP 와 NERP 동일 PLANT 발생, 발생월:'+@v_before_month;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        RETURN; --종료 끝내기.
    END;

    -----------------------------------------------------------------------------------------------------------
    -- 0. 2025.07.04 김준규 [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행 종료
    -----------------------------------------------------------------------------------------------------------
	UPDATE dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
	   SET TRANSFER_FLAG = 'P'
	 WHERE ISNULL(TRANSFER_FLAG, 'N') = 'N'
	   AND SPMON <= @v_before_month
       -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
       -- OLD 코드는 반영이 되지 않게 처리
       AND    NOT EXISTS ( SELECT 1
                           FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                           WHERE  NCM.CODETYPE = 'COMPANY_ID'
                           AND    NCM.OLD_VALUE1 = XIF_ERP_ZMM_GSCM_END_STOCK_R_SN.BUKRS
                           AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                         );
       -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End

    ----------------------------------------------------------- 
    -- 0. validation : E20241004-000934 : 'C100'에 '미착'이 한 건도 없으면 Transfer_flag='Z' 처리 후 Skip
    -----------------------------------------------------------
	SET @v_LGOBE_cnt = 0;

	SELECT @v_LGOBE_cnt = COUNT(*)
	FROM (
			SELECT TOP 1 *
			FROM    dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN A with(nolock)
			WHERE   TRANSFER_FLAG      = 'P'
			AND     BUKRS              = @v_ESOC
			AND     ISNULL(LGOBE, N'') IN (N'미착', 'In-Transit')
		 ) a;

    IF @v_LGOBE_cnt = 0
        BEGIN
			UPDATE dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
			   SET TRANSFER_FLAG = 'Z'
			 WHERE TRANSFER_FLAG = 'P';

			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## SKIP END of procedure ##########';
			SET @v_description = 'SKIP';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            RETURN;
        END
		

  -- 트랜잭션 (START)
  BEGIN TRANSACTION PR_SCP_ANL_MONTH_END_STOCK_R;

    -------------------------------------------
    BEGIN TRY
    -------------------------------------------
	IF OBJECT_ID('tempdb..#tmp_XIF_ERP_EXCRATE_R_SN') IS NOT NULL
	BEGIN 
		DROP TABLE #tmp_XIF_ERP_EXCRATE_R_SN;
	END
	
	IF OBJECT_ID('tempdb..#tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN') IS NOT NULL
	BEGIN 
		DROP TABLE #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN;
	END
	
    -- 0으로 시작하는 자재코드 처리용 테이블
	IF OBJECT_ID('tempdb..#tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1') IS NOT NULL
	BEGIN
		DROP TABLE #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1;
	END

	-------------------------------------------------------------------------
	-- 1. 환율정보 조회
	-------------------------------------------------------------------------
	-- 2022.05.17
	-- 1) 변경전 = 배치일 이전 Last Day (5월3일 실행 시 5월  2일 환율적용)  FORMAT(GETDATE(), 'yyyyMMdd')
	-- 2) 변경후 = 이전월 마감 환율     (5월3일 실행 시 4월 30일 환율적용)
	-- 3) 위안화 RMB -> CNY (하드코딩으로 변경 필요)
	-------------------------------------------------------------------------
    ;WITH sub AS
    (
   --  SELECT CASE 
	  --      WHEN EX_FROM_CURR_CD = 'CNY' THEN 'RMB'
	  --      ELSE EX_FROM_CURR_CD
			--END AS EX_FROM_CURR_CD 
		 SELECT EX_FROM_CURR_CD AS EX_FROM_CURR_CD
           ,EX_TO_CURR_CD
           ,EX_TO_BAMT
           ,EX_DT
           ,TRANSFER_FLAG
           ,ROW_NUMBER() OVER (PARTITION BY EX_FROM_CURR_CD, EX_TO_CURR_CD ORDER BY EX_DT DESC) RN
     FROM dbo.XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
     WHERE 1 = 1
     AND TRANSFER_FLAG = 'Y'
     AND EX_TO_CURR_CD = 'KRW'
	 AND EX_DT <=  CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0, GETDATE()) ,0), 112)

	UNION
		 
	SELECT 'RMB' AS EX_FROM_CURR_CD
		,EX_TO_CURR_CD
		,EX_TO_BAMT
		,EX_DT
		,TRANSFER_FLAG
		,ROW_NUMBER() OVER (PARTITION BY EX_FROM_CURR_CD, EX_TO_CURR_CD ORDER BY EX_DT DESC) RN
	FROM dbo.XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
	WHERE 1 = 1
	AND TRANSFER_FLAG = 'Y'
	AND EX_TO_CURR_CD = 'KRW'
	AND EX_FROM_CURR_CD = 'CNY'
	AND EX_DT <=  CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0, GETDATE()) ,0), 112)
    )
    SELECT *
    INTO   #tmp_XIF_ERP_EXCRATE_R_SN
    FROM   sub
    WHERE  RN = 1;   

    ----------------------------------------------------------- 
    -- 2. Data Query 
	--------------------------------------------------------------------------------------
	-- 0. 복사대상 추출 (가장 최근버전의 WERKS만 반영하기 위해 PARTITION BY WERKS, SPMON ORDER BY IFSEQNO DESC 적용)
    -- XIF_ERP_ZMM_GSCM_END_STOCK_R_SN 의 division이 lookup (sub2)에 있으면 sub2.division을 사용하지만 없으면 받은값 그대로 간다
    -- MATNR의 경우 앞에 0은 제거 후 INSERT처리를 한다
	-- 2022.09.14 : 당월 매일 재고 조회 기능 요청 => Monthly / Daily 구분 처리 필요 
	--                                               Monthly = PR_SCP_ANL_MONTH_END_STOCK_R
	--                                               Daily   = PR_SCP_ANL_MONTH_END_STOCK_R_D
	--------------------------------------------------------------------------------------
    -----------------------------------------------------------
    ;WITH sub AS
    (
     SELECT WERKS
           ,IFSEQNO
           ,SPMON
           ,ROW_NUMBER() OVER (PARTITION BY WERKS, SPMON ORDER BY IFSEQNO DESC) RN
     FROM   dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
     WHERE  TRANSFER_FLAG = 'P'
    ),
    sub9 AS
    (
     SELECT SEGMENT1 ATTRIBUTE3
           ,SEGMENT3 DIVISION_ID
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) 
      WHERE LOOKUP_TYPE = 'ERP_POSTING_STOCK_PRCTR'
	    AND valid_yn = 'Y'
    ),
    sub10 AS
    (
     SELECT SEGMENT3 PLANT_ID
     	  , ATTRIBUTE5 DIVISION_ID
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) 
      WHERE LOOKUP_TYPE = 'ERP_POSTING_STOCK_SETUP'
	    AND valid_yn = 'Y'
        AND ATTRIBUTE5 <> '-'
    ),
    sub_storage AS
    (
     SELECT SEGMENT3 DIVISION_ID
     	  , SEGMENT1 STORAGE
		  , SEGMENT2 STORAGE_DESC
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) 
      WHERE LOOKUP_TYPE = 'ERP_POSTING_STOCK_STORAGE'
	    AND valid_yn = 'Y'
    ),
    sub11 AS
    (
     SELECT A.SPMON YYYYMM
	 
           -- 1. sub10의 DIVISION_ID를 사용하지만 없을 경우
           -- 2. sub9의 DIVISION_ID를 사용한다
           --,IIF(ISNULL(D.DIVISION_ID, '') = '', E.DIVISION_ID, D.DIVISION_ID) DIVISION_ID
           ,CASE WHEN A.WERKS = @v_A000
		         THEN F.DIVISION_ID
		         ELSE IIF(ISNULL(D.DIVISION_ID, '') = '', E.DIVISION_ID, D.DIVISION_ID) 
				 END AS DIVISION_ID
           ,A.BUKRS COMPANY_ID
           ,A.WERKS PLANT_ID
           ,A.MATNR ITEM_ID
           ,A.MAKTX ITEM_DESCRIPTION
           ,A.MEINS ITEM_UOM
           ,A.LGORT STORAGE_LOCATION
           ,A.LGOBE STORAGE_DESC
           ,(CASE WHEN ISNULL(LGOBE, N'') IN (N'미착', 'In-Transit') THEN A.ZDMBMEN ELSE A.STOCK END) AS QUANTITY
           ,(CASE WHEN ISNULL(LGOBE, N'') IN (N'미착', 'In-Transit') THEN A.ZDMBTRM ELSE A.SALKV END) AS AMOUNT
		   , CASE WHEN A.WAERS = 'RMB' THEN 'CNY'
		          ELSE A.WAERS 
				  END CURRENCY -- 20220517 RMB -> CNY
           ,CASE WHEN A.WAERS = 'KRW' THEN IIF(ISNULL(LGOBE, N'') IN (N'미착', 'In-Transit'), A.ZDMBTRM, A.SALKV)
                 ELSE ISNULL(C.EX_TO_BAMT, 1) * IIF(ISNULL(LGOBE, N'') IN (N'미착', 'In-Transit'), A.ZDMBTRM, A.SALKV) END AMOUNT_KRW
           ,A.NETPR UNIT_PRICE
           ,CASE WHEN A.WAERS = 'KRW' THEN A.NETPR
                 ELSE ISNULL(C.EX_TO_BAMT, 1) * A.NETPR END UNIT_PRICE_KRW
           ,A.BKLAS VALUATION_CLASS
           ,A.EBELN PURCHASE_PO

           --PJ20216891
           -- ,A.LIFNR1 SUPPLIER_CODE
           -- ,A.NAME1 SUPPLIER_NAME
		   , CASE WHEN ISNULL(A.SOBKZ, '') = 'O' THEN A.LIFNR
		          ELSE A.LIFNR1
		     END SUPPLIER_CODE
		   , CASE WHEN ISNULL(A.SOBKZ, '') = 'O' THEN A.LGOBE
		          ELSE A.NAME1
		     END SUPPLIER_NAME
           ,@v_batch_user CREATED_BY
           ,GETDATE() CREATION_DATE
           ,@v_batch_user LAST_UPDATED_BY
           ,GETDATE() LAST_UPDATE_DATE
           ,A.ATTRIBUTE1 SALES_DOC_ID
           ,A.ATTRIBUTE2 SALES_DOC_ITEM_SEQ
           ,A.ATTRIBUTE3 PROFIT_CENTER_ID
           ,A.ATTRIBUTE4 PROFIT_CENTER_NAME
           ,A.SOBKZ SPECIAL_INVENTORY

           -- 0으로 시작하는 자재코드 별도처리용 구분자
           ,IIF(LEFT(A.MATNR, 1) = '0', 'Y', 'N') TARGET_YN
		   ,LABST AS UNRESTRICTED_QTY -- 20220811 추가
		   ,SPEME AS BLOCKED_STOCK	  -- 20220811 추가
		   ,INTRAN AS IN_TRANSIT	  -- 20220811 추가
		   ,B.IFSEQNO   -- 20230208 IF 중복체크 위해 추가
		   ,A.EBELP		-- 20230208 IF 중복체크 위해 추가
		   ,A.BWTAR		-- 20230208 IF 중복체크 위해 추가
		   ,A.KUNNR		-- 20230208 IF 중복체크 위해 추가
		   ,A.ATTRIBUTE1-- 20230208 IF 중복체크 위해 추가
		   ,A.SPART	    -- 20251217 E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건 (ATTRIBUTE10)
           ,GRM01     -- 2023.02.14
           ,GRK01     -- 2023.02.14
           ,GRL01     -- 2023.02.14
           ,GRM02     -- 2023.02.14
           ,GRK02     -- 2023.02.14
           ,GRL02     -- 2023.02.14
           ,GRM03     -- 2023.02.14
           ,GRK03     -- 2023.02.14
           ,GRL03     -- 2023.02.14
           ,GRM04     -- 2023.02.14
           ,GRK04     -- 2023.02.14
           ,GRL04     -- 2023.02.14
           ,GRM05     -- 2023.02.14
           ,GRK05     -- 2023.02.14
           ,GRL05     -- 2023.02.14
           ,GRM06     -- 2023.02.14
           ,GRK06     -- 2023.02.14
           ,GRL06     -- 2023.02.14
           ,GRM07     -- 2023.02.14
           ,GRK07     -- 2023.02.14
           ,GRL07     -- 2023.02.14
           ,GRM08     -- 2023.02.14
           ,GRK08     -- 2023.02.14
           ,GRL08     -- 2023.02.14
           ,GRM09     -- 2023.02.14
           ,GRK09     -- 2023.02.14
           ,GRL09     -- 2023.02.14
           ,GRM10     -- 2023.02.14
           ,GRK10     -- 2023.02.14
           ,GRL10     -- 2023.02.14
           ,GRM11     -- 2023.02.14
           ,GRK11     -- 2023.02.14
           ,GRL11     -- 2023.02.14
           ,GRM12     -- 2023.02.14
           ,GRK12     -- 2023.02.14
           ,GRL12     -- 2023.02.14
           ,GRM13     -- 2023.02.14
           ,GRK13     -- 2023.02.14
           ,GRL13     -- 2023.02.14
           ,WAERS_KRW -- 2023.02.14
		   ,C.EX_TO_BAMT  -- 2023.04.23
		   ,A.WAERS
		   ,A.INSME -- 2023.10.20
     FROM   dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN A
     INNER JOIN sub B
     ON  A.IFSEQNO = B.IFSEQNO
     AND A.WERKS = B.WERKS
     AND A.SPMON = B.SPMON
     LEFT JOIN #tmp_XIF_ERP_EXCRATE_R_SN C
     ON  A.WAERS = C.EX_FROM_CURR_CD
     LEFT JOIN sub10 D
     ON A.WERKS = D.PLANT_ID
     LEFT JOIN sub9 E
     ON A.ATTRIBUTE3 = E.ATTRIBUTE3
     LEFT JOIN sub_storage F
     ON A.LGORT = F.STORAGE
     WHERE B.RN = 1
    )
    SELECT *
    INTO   #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
    FROM   sub11;


    SET @v_end_cnt1 = @@ROWCOUNT;

	-------------------------------------------
	-- 3. DATA DELETE & INSERT
	-------------------------------------------
    IF(@v_end_cnt1 > 0)
    BEGIN
        BEGIN TRAN
             WHILE(1 = 1)
             BEGIN
                 DELETE TOP (1000000) A
                 FROM dbo.SCP_ANL_MONTH_END_STOCK_R A
                 INNER JOIN #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN B
                 ON  A.YYYYMM = B.YYYYMM
                 AND A.PLANT_ID = B.PLANT_ID;
    
                 IF(@@ROWCOUNT = 0)
                 BEGIN
                     BREAK;
                 END
             END
        COMMIT
		
        INSERT INTO dbo.SCP_ANL_MONTH_END_STOCK_R WITH (TABLOCK)
        (
          YYYYMM
         ,DIVISION_ID
         ,COMPANY_ID
         ,PLANT_ID
         ,ITEM_ID
         ,ITEM_DESCRIPTION
         ,ITEM_UOM
         ,STORAGE_LOCATION
         ,STORAGE_DESC
         ,QUANTITY
         ,AMOUNT
         ,CURRENCY
         ,AMOUNT_KRW
         ,UNIT_PRICE
         ,UNIT_PRICE_KRW
         ,VALUATION_CLASS
         ,PURCHASE_PO
         ,SUPPLIER_CODE
         ,SUPPLIER_NAME
         ,CREATED_BY
         ,CREATION_DATE
         ,LAST_UPDATED_BY
         ,LAST_UPDATE_DATE
         ,ATTRIBUTE1
         ,ATTRIBUTE2
         ,ATTRIBUTE3
         ,ATTRIBUTE4
		 ,ATTRIBUTE5	-- 20230208 IF 중복체크 위해 추가
		 ,ATTRIBUTE6	-- 20230208 IF 중복체크 위해 추가
		 ,ATTRIBUTE7	-- 20230208 IF 중복체크 위해 추가
		 ,ATTRIBUTE8	-- 20230208 IF 중복체크 위해 추가
		 ,ATTRIBUTE9	-- 20230423 환율정보 추가
		 ,ATTRIBUTE10   -- 20251217 E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건
         ,SPECIAL_INVENTORY
		 ,UNRESTRICTED_QTY -- 20220811 추가
		 ,BLOCKED_STOCK	-- 20220811 추가
		 ,IN_TRANSIT	    -- 20220811 추가
         ,M1_QUANTITY       -- 2023.02.14
         ,M2_QUANTITY       -- 2023.02.14
         ,M3_QUANTITY       -- 2023.02.14
         ,M4_QUANTITY       -- 2023.02.14
         ,M5_QUANTITY       -- 2023.02.14
         ,M6_QUANTITY       -- 2023.02.14
         ,M7_QUANTITY       -- 2023.02.14
         ,M8_QUANTITY       -- 2023.02.14
         ,M9_QUANTITY       -- 2023.02.14
         ,M10_QUANTITY      -- 2023.02.14
         ,M11_QUANTITY      -- 2023.02.14
         ,M12_QUANTITY      -- 2023.02.14
         ,M13_QUANTITY      -- 2023.02.14
         ,M1_AMOUNT         -- 2023.02.14
         ,M2_AMOUNT         -- 2023.02.14
         ,M3_AMOUNT         -- 2023.02.14
         ,M4_AMOUNT         -- 2023.02.14
         ,M5_AMOUNT         -- 2023.02.14
         ,M6_AMOUNT         -- 2023.02.14
         ,M7_AMOUNT         -- 2023.02.14
         ,M8_AMOUNT         -- 2023.02.14
         ,M9_AMOUNT         -- 2023.02.14
         ,M10_AMOUNT        -- 2023.02.14
         ,M11_AMOUNT        -- 2023.02.14
         ,M12_AMOUNT        -- 2023.02.14
         ,M13_AMOUNT        -- 2023.02.14
         ,M1_AMOUNT_KRW     -- 2023.02.14
         ,M2_AMOUNT_KRW     -- 2023.02.14
         ,M3_AMOUNT_KRW     -- 2023.02.14
         ,M4_AMOUNT_KRW     -- 2023.02.14
         ,M5_AMOUNT_KRW     -- 2023.02.14
         ,M6_AMOUNT_KRW     -- 2023.02.14
         ,M7_AMOUNT_KRW     -- 2023.02.14
         ,M8_AMOUNT_KRW     -- 2023.02.14
         ,M9_AMOUNT_KRW     -- 2023.02.14
         ,M10_AMOUNT_KRW    -- 2023.02.14
         ,M11_AMOUNT_KRW    -- 2023.02.14
         ,M12_AMOUNT_KRW    -- 2023.02.14
         ,M13_AMOUNT_KRW    -- 2023.02.14
         ,CURRENCY_KRW      -- 2023.02.14
		 ,QT_STOCK			-- 2023.10.20
        )
        SELECT YYYYMM
              ,DIVISION_ID
              ,COMPANY_ID
              ,PLANT_ID
              ,ITEM_ID
              ,ITEM_DESCRIPTION
              ,ITEM_UOM
              ,STORAGE_LOCATION
              ,STORAGE_DESC
              ,QUANTITY
              ,AMOUNT
              ,CURRENCY
              ,AMOUNT_KRW
              ,UNIT_PRICE
              ,UNIT_PRICE_KRW
              ,VALUATION_CLASS
              ,PURCHASE_PO
              ,SUPPLIER_CODE
              ,SUPPLIER_NAME
              ,CREATED_BY
              ,CREATION_DATE
              ,@v_batch_user
              ,GETDATE()
              ,SALES_DOC_ID
              ,SALES_DOC_ITEM_SEQ
              ,PROFIT_CENTER_ID
              ,PROFIT_CENTER_NAME
			  ,EBELP		-- 20230208 IF 중복체크 위해 추가
		      ,BWTAR		-- 20230208 IF 중복체크 위해 추가
			  ,KUNNR		-- 20230208 IF 중복체크 위해 추가
		      ,ATTRIBUTE1   -- 20230208 IF 중복체크 위해 추가
		      ,EX_TO_BAMT   -- 20230423 IF 환율정보 추가
			  ,SPART	    -- 20251217 E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건 (ATTRIBUTE10)
              ,SPECIAL_INVENTORY
			  ,UNRESTRICTED_QTY -- 20220811 추가
			  ,BLOCKED_STOCK	-- 20220811 추가
			  ,IN_TRANSIT	    -- 20220811 추가
              ,GRM01            -- 2023.02.14
              ,GRM02            -- 2023.02.14
              ,GRM03            -- 2023.02.14
              ,GRM04            -- 2023.02.14
              ,GRM05            -- 2023.02.14
              ,GRM06            -- 2023.02.14
              ,GRM07            -- 2023.02.14
              ,GRM08            -- 2023.02.14
              ,GRM09            -- 2023.02.14
              ,GRM10            -- 2023.02.14
              ,GRM11            -- 2023.02.14
              ,GRM12            -- 2023.02.14
              ,GRM13            -- 2023.02.14
              ,GRL01            -- 2023.02.14
              ,GRL02            -- 2023.02.14
              ,GRL03            -- 2023.02.14
              ,GRL04            -- 2023.02.14
              ,GRL05            -- 2023.02.14
              ,GRL06            -- 2023.02.14
              ,GRL07            -- 2023.02.14
              ,GRL08            -- 2023.02.14
              ,GRL09            -- 2023.02.14
              ,GRL10            -- 2023.02.14
              ,GRL11            -- 2023.02.14
              ,GRL12            -- 2023.02.14
              ,GRL13            -- 2023.02.14
              ,GRK01            -- 2023.02.14
              ,GRK02            -- 2023.02.14
              ,GRK03            -- 2023.02.14
              ,GRK04            -- 2023.02.14
              ,GRK05            -- 2023.02.14
              ,GRK06            -- 2023.02.14
              ,GRK07            -- 2023.02.14
              ,GRK08            -- 2023.02.14
              ,GRK09            -- 2023.02.14
              ,GRK10            -- 2023.02.14
              ,GRK11            -- 2023.02.14
              ,GRK12            -- 2023.02.14
              ,GRK13            -- 2023.02.14
              ,WAERS_KRW        -- 2023.02.14
			  ,INSME
        FROM   #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
        WHERE  TARGET_YN = 'N';
    
        SET @n_log_count = @@ROWCOUNT;
		
        WITH sub AS
        (
         SELECT *
               ,ROW_NUMBER() OVER (ORDER BY NEWID() ASC) RN
         FROM   #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
         WHERE  TARGET_YN = 'Y'
        )
        SELECT *
        INTO   #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1
        FROM   sub;

        SET @v_end_cnt2 = @@ROWCOUNT;

        WHILE(@v_start_cnt < @v_end_cnt2)
        BEGIN
            SET @v_start_cnt = @v_start_cnt + 1;
        
            SELECT @v_new_matnr = ITEM_ID
              FROM #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1
             WHERE RN = @v_start_cnt;
            
            WHILE(LEFT(@v_new_matnr, 1) = '0')
            BEGIN
                SET @v_new_matnr = RIGHT(@v_new_matnr, LEN(@v_new_matnr) - 1);
            END
        			
            INSERT INTO dbo.SCP_ANL_MONTH_END_STOCK_R WITH (TABLOCK)
            (
              YYYYMM
             ,DIVISION_ID
             ,COMPANY_ID
             ,PLANT_ID
             ,ITEM_ID
             ,ITEM_DESCRIPTION
             ,ITEM_UOM
             ,STORAGE_LOCATION
             ,STORAGE_DESC
             ,QUANTITY
             ,AMOUNT
             ,CURRENCY
             ,AMOUNT_KRW
             ,UNIT_PRICE
             ,UNIT_PRICE_KRW
             ,VALUATION_CLASS
             ,PURCHASE_PO
             ,SUPPLIER_CODE
             ,SUPPLIER_NAME
             ,CREATED_BY
             ,CREATION_DATE
             ,LAST_UPDATED_BY
             ,LAST_UPDATE_DATE
             ,ATTRIBUTE1
             ,ATTRIBUTE2
             ,ATTRIBUTE3
             ,ATTRIBUTE4
			 ,ATTRIBUTE5	-- 20230208 IF 중복체크 위해 추가
			 ,ATTRIBUTE6	-- 20230208 IF 중복체크 위해 추가
			 ,ATTRIBUTE7	-- 20230208 IF 중복체크 위해 추가
			 ,ATTRIBUTE8	-- 20230208 IF 중복체크 위해 추가
			 ,ATTRIBUTE9	-- 20230423 환율정보 추가
			 ,ATTRIBUTE10   -- 20251217 E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건 (ATTRIBUTE10)
             ,SPECIAL_INVENTORY
			 ,UNRESTRICTED_QTY -- 20220811 추가
			 ,BLOCKED_STOCK	   -- 20220811 추가
			 ,IN_TRANSIT	   -- 20220811 추가
             ,M1_QUANTITY      -- 2023.02.14
             ,M2_QUANTITY      -- 2023.02.14
             ,M3_QUANTITY      -- 2023.02.14
             ,M4_QUANTITY      -- 2023.02.14
             ,M5_QUANTITY      -- 2023.02.14
             ,M6_QUANTITY      -- 2023.02.14
             ,M7_QUANTITY      -- 2023.02.14
             ,M8_QUANTITY      -- 2023.02.14
             ,M9_QUANTITY      -- 2023.02.14
             ,M10_QUANTITY     -- 2023.02.14
             ,M11_QUANTITY     -- 2023.02.14
             ,M12_QUANTITY     -- 2023.02.14
             ,M13_QUANTITY     -- 2023.02.14
             ,M1_AMOUNT        -- 2023.02.14
             ,M2_AMOUNT        -- 2023.02.14
             ,M3_AMOUNT        -- 2023.02.14
             ,M4_AMOUNT        -- 2023.02.14
             ,M5_AMOUNT        -- 2023.02.14
             ,M6_AMOUNT        -- 2023.02.14
             ,M7_AMOUNT        -- 2023.02.14
             ,M8_AMOUNT        -- 2023.02.14
             ,M9_AMOUNT        -- 2023.02.14
             ,M10_AMOUNT       -- 2023.02.14
             ,M11_AMOUNT       -- 2023.02.14
             ,M12_AMOUNT       -- 2023.02.14
             ,M13_AMOUNT       -- 2023.02.14
             ,M1_AMOUNT_KRW    -- 2023.02.14
             ,M2_AMOUNT_KRW    -- 2023.02.14
             ,M3_AMOUNT_KRW    -- 2023.02.14
             ,M4_AMOUNT_KRW    -- 2023.02.14
             ,M5_AMOUNT_KRW    -- 2023.02.14
             ,M6_AMOUNT_KRW    -- 2023.02.14
             ,M7_AMOUNT_KRW    -- 2023.02.14
             ,M8_AMOUNT_KRW    -- 2023.02.14
             ,M9_AMOUNT_KRW    -- 2023.02.14
             ,M10_AMOUNT_KRW   -- 2023.02.14
             ,M11_AMOUNT_KRW   -- 2023.02.14
             ,M12_AMOUNT_KRW   -- 2023.02.14
             ,M13_AMOUNT_KRW   -- 2023.02.14
             ,CURRENCY_KRW     -- 2023.02.14
			 ,QT_STOCK			-- 2023.10.20
            )
            SELECT YYYYMM
                  ,DIVISION_ID
                  ,COMPANY_ID
                  ,PLANT_ID
                  ,@v_new_matnr ITEM_ID
                  ,ITEM_DESCRIPTION
                  ,ITEM_UOM
                  ,STORAGE_LOCATION
                  ,STORAGE_DESC
                  ,QUANTITY
                  ,AMOUNT
                  ,CURRENCY
                  ,AMOUNT_KRW
                  ,UNIT_PRICE
                  ,UNIT_PRICE_KRW
                  ,VALUATION_CLASS
                  ,PURCHASE_PO
                  ,SUPPLIER_CODE
                  ,SUPPLIER_NAME
                  ,CREATED_BY
                  ,CREATION_DATE
				  ,@v_batch_user
				  ,GETDATE()
                  ,SALES_DOC_ID
                  ,SALES_DOC_ITEM_SEQ
                  ,PROFIT_CENTER_ID
                  ,PROFIT_CENTER_NAME
				  ,EBELP		-- 20230208 IF 중복체크 위해 추가
				  ,BWTAR		-- 20230208 IF 중복체크 위해 추가
				  ,KUNNR		-- 20230208 IF 중복체크 위해 추가
				  ,ATTRIBUTE1   -- 20230208 IF 중복체크 위해 추가
				  ,EX_TO_BAMT   -- 20230423 환율정보 추가
				  ,SPART	    --20251217 E20251114-001566 ENDING INVENTORY UI 내 ERP DIV 추가 요청건 (ATTRIBUTE10)
                  ,SPECIAL_INVENTORY
				  ,UNRESTRICTED_QTY -- 20220811 추가
				  ,BLOCKED_STOCK	-- 20220811 추가
				  ,IN_TRANSIT	    -- 20220811 추가
                  ,GRM01            -- 2023.02.14
                  ,GRM02            -- 2023.02.14
                  ,GRM03            -- 2023.02.14
                  ,GRM04            -- 2023.02.14
                  ,GRM05            -- 2023.02.14
                  ,GRM06            -- 2023.02.14
                  ,GRM07            -- 2023.02.14
                  ,GRM08            -- 2023.02.14
                  ,GRM09            -- 2023.02.14
                  ,GRM10            -- 2023.02.14
                  ,GRM11            -- 2023.02.14
                  ,GRM12            -- 2023.02.14
                  ,GRM13            -- 2023.02.14
                  ,GRL01            -- 2023.02.14
                  ,GRL02            -- 2023.02.14
                  ,GRL03            -- 2023.02.14
                  ,GRL04            -- 2023.02.14
                  ,GRL05            -- 2023.02.14
                  ,GRL06            -- 2023.02.14
                  ,GRL07            -- 2023.02.14
                  ,GRL08            -- 2023.02.14
                  ,GRL09            -- 2023.02.14
                  ,GRL10            -- 2023.02.14
                  ,GRL11            -- 2023.02.14
                  ,GRL12            -- 2023.02.14
                  ,GRL13            -- 2023.02.14
                  ,GRK01            -- 2023.02.14
                  ,GRK02            -- 2023.02.14
                  ,GRK03            -- 2023.02.14
                  ,GRK04            -- 2023.02.14
                  ,GRK05            -- 2023.02.14
                  ,GRK06            -- 2023.02.14
                  ,GRK07            -- 2023.02.14
                  ,GRK08            -- 2023.02.14
                  ,GRK09            -- 2023.02.14
                  ,GRK10            -- 2023.02.14
                  ,GRK11            -- 2023.02.14
                  ,GRK12            -- 2023.02.14
                  ,GRK13            -- 2023.02.14
                  ,WAERS_KRW        -- 2023.02.14
				  ,INSME
            FROM   #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1
            WHERE  RN = @v_start_cnt;
            
            SET @n_log_count = @n_log_count + 1;        
        END
    END

	UPDATE dbo.XIF_ERP_ZMM_GSCM_END_STOCK_R_SN
	   SET TRANSFER_FLAG = 'Y'
	 WHERE TRANSFER_FLAG = 'P';
                         
    IF OBJECT_ID('tempdb..#tmp_XIF_ERP_EXCRATE_R_SN') IS NOT NULL
    BEGIN 
        DROP TABLE #tmp_XIF_ERP_EXCRATE_R_SN;
    END
	
    IF OBJECT_ID('tempdb..#tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN') IS NOT NULL
    BEGIN 
        DROP TABLE #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN;
    END
	
    IF OBJECT_ID('tempdb..#tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1') IS NOT NULL
    BEGIN 
        DROP TABLE #tmp_XIF_ERP_ZMM_GSCM_END_STOCK_R_SN1;
    END

    -- 트랜잭션 (COMMIT)
    COMMIT WORK;

    -------------------------------------------
    END TRY
    -------------------------------------------

    -------------------------------------------
    BEGIN CATCH
    -------------------------------------------
    -- ROLLBACK
    -- ERROR LOG VALUE SAVE
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date  = SYSDATETIME();

    SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

    -- 트랜잭션 (END)
    ROLLBACK TRANSACTION PR_SCP_ANL_MONTH_END_STOCK_R;

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  
    -------------------------------------------
    END CATCH;
    -------------------------------------------

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


  END;




