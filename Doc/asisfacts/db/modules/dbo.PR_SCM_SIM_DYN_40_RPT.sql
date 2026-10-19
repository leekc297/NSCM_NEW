


/*=====================================================================================================================================================
 * Program ID   : PR_SCM_SIM_DYN_40_RPT
 * Description  : 소형셀시뮬레이터 집계데이터 조회용
 *                소형사업부(DIVISION_ID='40') SCP PLAN 집계 결과 리포트 제공
 *                SCM_SIM_DYN_COLS 의 데이터를 Excel RAW데이터 RETURN.
 *                기존 PR_SCM_SIM_DYN_RPT 와 분리한 이유:
 *                1) 40 사업부의 SCM_SIM_DYN_COLS tail 컬럼 위치(C771~C778)가 다름
 *                2) BP_FLAG('N'/'Y') 에 따라 일자 컬럼 수 가변(364/728)
 *                3) XLS_KEY1, RNO, audit 4컬럼 등 출력 형식이 40 전용
 *                  → 기존 SP 회귀 위험 격리
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2026.05.09	김준규		최초 릴리즈
 * 2026.06.22	김준규		8k 에러 대응 ( Cannot create a row of size 9314 which is greater than the allowable maximum row size of 8060. )
 * 2026.06.23	김준규		표시순서에 메저와 TO_SITE사이에 TEAM을 넣음
 * 2026.07.20   박원채      [E20260709-001606] 암호화연결로 인한 시뮬레이터의 조회오류 대응 (복호화시 문자깨짐 발생) 
 *===================================================================================================================================================*/
--
-- How to Execute:
--   EXEC PR_SCM_SIM_DYN_40_RPT
--         @P_BATCH_ID      = '53'
--        ,@P_SNAP_YYYYMMDD = '20260508'
--        ,@P_REPORT_TITLE  = 'RAW'
--        ,@P_BP_FLAG       = 'N'
--        ,@P_DIVISION_ID   = '40';
--
-- BP_FLAG : 'N' = 364일 (52주), 'Y' = 728일 (104주)
--
--   'RAW'             - RAW (원본 데이터)
--
-- 출력 컬럼 (RAW, BP_FLAG='N' 기준):
--   C1  ~ C30                       : head metadata (어댑터 SP가 채움)
--   C31 (XLS_KEY1)                  : BATCH_ID + ' - ' + SORT_SEQ1 형식 (DATA 행)
--   C32 ~ C(31+364) = C32~C395      : QTY001 ~ QTY364 일자 데이터
--   CREATED_BY                      : SCM_SIM_DYN_COLS.CREATED_BY (audit)
--   CREATION_DATE                   : 동일
--   LAST_UPDATED_BY                 : 동일
--   LAST_UPDATE_DATE                : 동일
--   C771 ATTRIBUTE1                 : 어댑터 SP가 채움
--   C772 ATTRIBUTE3                 : 동일
--   C773 ATTRIBUTE9                 : 동일
--   C774 ATTRIBUTE10                : 동일
--   C775 SHEET_TYPE                 : 동일
--   RNO                             : SORT_SEQ1 값 직접 출력 (어댑터 C776 미사용)
--
--   BP_FLAG='Y' 일 경우 QTY 컬럼이 C32~C759 까지 확장
-- ---------------------------------------------------------------------------------------
--   C1  = DIVISION_ID                 (A.DIVISION_ID)                  -- 사업부
--   C2  = PLAN_START_YYYYMMDD         (@p_plan_start_yyyymmdd)         -- 계획 시작일
--   C3  = CREATE_FROM_YYYYMMDD        (@v_blk_from)                    -- YEARBLOCK 블록 시작일 (블록 물리행 식별 키)
--   C4  = PLAN_TYPE                   (@P_PLAN_TYPE)                   -- TE/MA 등
--   C5  = SEQ                         (@P_PLAN_SEQ)                    -- 계획 회차
--   C6  = OPERATION_GROUP             (A.OPERATION_GROUP)              -- 공정 그룹 (A=CELL, P=PACK 등)
--   C7  = FROM_SITE                   (A.FROM_SITE)                    -- 출발 사이트 코드
--   C8  = FROM_SITE_DESCRIPTION       (SCM_MST_SITE.SITE_DESCRIPTION)  -- C7 사이트 설명
--   C9  = CELL_ITEM_ID                (A.CELL_ITEM_ID)                 -- 셀 ITEM ID
--   C10 = ITEM_ID                     (A.ITEM_ID)                      -- ITEM ID (모델/FG)
--   C11 = NICK_NAME                   (SCM_MST_ITEM_SN.NICK_NAME)      -- 약칭 (없으면 '-')
--   C12 = TEAM                        (MAX(A.TEAM))                    -- 팀
--   C13 = CELL_QTY                    (0 고정)                          -- 셀 수량 (항상 0)
--   C14 = MEASURE                     (A.MEASURE)                      -- 측정 항목명
--   C15 = FROM_BOH_QTY                (FORMAT(A.FROM_BOH_QTY,'G15'))   -- 기초재고 (…_TOTAL measure 는 blank)
--   C16 = MEASURE_LABEL               (MAX(A.COLUMN_LABEL_NAME))       -- 측정 표시명
--   C17 = PROJECT_CODE                (A.PROJECT_CODE)                 -- 프로젝트 코드
--   C18 = TO_SITE                     (A.TO_SITE)                      -- 도착 사이트 코드
--   C19 = TO_SITE_DESCRIPTION         (SCM_MST_SITE.SITE_DESCRIPTION)  -- C18 사이트 설명
--   C20 = INCOTERMS                   (A.INCOTERMS)                    -- 인코텀즈
--   C21 = BOD_ID                      (A.BOD_ID)                       -- BOD ID
--   C22 = TRANSPORT_MODE              (A.TRANSPORT_MODE)               -- 운송 수단
--   C23 = YIELD                       (CASE: HOLD=1, 그 외 blank)       -- 수율 표기
--   C24 = PROD_LINE                   (A.PROD_LINE)                    -- 생산 라인
--   C25 = ITEM_TYPE                   (CELL_ITEM_ID=ITEM_ID ? 'FG':'SEMI') -- 품목 구분
--   C26 = LT_DAY                      (inline 5분기 CASE)               -- 리드타임(일) : CELL_PROD/VMI/PACK_BOH/…
--   C27 = PRIORITY                    (SCP_MST_BOD_V.priority)         -- BOD 우선순위
--   C28 = GRO_STD_DIO                 (CASE, 기본 'N')                  -- GRO 표준 DIO (ALLOCATION_DIO 매핑)
--   C29 = MIN_STD_DIO                 (CASE, 기본 'N')                  -- MIN 표준 DIO
--   C30 = MEASURE_ORDER               (MIN(A.SORT_ORDER_NO))           -- 측정 정렬 순서 (RPT 정렬 키)
--   C31 = XLS_KEY1                    (NULL 적재)                       -- 행 키. PSI 는 NULL, RPT/UPDATE 가 (BATCH_ID + ' - ' + SORT_SEQ1) 로 생성/사용
-- ---------------------------------------------------------------------------------------
--   C32 ~ C(31+@v_n_days) = 일자별 QTY (블록당 최대 364개 → C32~C395)
-- ---------------------------------------------------------------------------------------
--   C771 = ATTRIBUTE1   (A.ATTRIBUTE1)                                   -- 속성1
--   C772 = ATTRIBUTE3   (MAX(A.ATTRIBUTE3))                              -- 속성3 (PRE-PIVOT 결과)
--   C773 = ATTRIBUTE9   (A.ATTRIBUTE9)                                   -- 속성9
--   C774 = ATTRIBUTE10  (MAX(A.ATTRIBUTE10))                             -- 속성10 (PRE-PIVOT 결과)
--   C775 = SHEET_TYPE   (CASE MEASURE IN (CELL_*/…_TOTAL) → 'PROD' ELSE 'SHIP')  -- 시트 구분
--   C776 = RNO          (CONVERT(NVARCHAR(20), SM.RN))                   -- 표시 순서 번호 (#SORT_MAP.RN, SORT_SEQ1 순)
--   C777 = ITEM_TYPE    (CELL_ITEM_ID=ITEM_ID ? 'FG':'SEMI')             -- 품목 구분 (C25 와 동일 규칙)
--   C778 = SHEET_TYPE   (C775 와 동일 CASE → 'PROD'/'SHIP')              -- 시트 구분 (tail 구조 호환용 중복)
--   C779 = MEASURE_LEVEL2 (MIN(PMD.MEASURE_LEVEL2))                      -- level2 tie-break 정렬키 (#PSI_MEASURE_DAILY JOIN)
-- ---------------------------------------------------------------------------------------
--   ATTRIBUTE1  = 데이터 출처 구분 태그. measure 가 어느 원천에서 왔는지 표시하며 처리 분기에 사용.
--                  예) 'SCP_ANL_SHIPMENT_PLAN_FG' / '_SEMI' (출하계획 FG/SEMI), 'SCP_ANL_PRODUCTION_PLAN'·'SCP_PLN_PRODUCTION_PLAN' (생산계획),
--                      'PACK'·'CELL' (공정 분류), 'DIO' (DIO measure 마킹). 빈값('')으로 해제되기도 함.
--   ATTRIBUTE3  = BOD 적용 일자 구간 문자열 'FROM_YYYYMMDD,TO_YYYYMMDD'.
--                  SHIP_PLAN/SEMI_SHIP_PLAN 의 BOD(배송) 유효기간을 BOD_N_V 매칭(A.5.4/A.5.8)으로 채움.
--   ATTRIBUTE9  = OPERATION_ID (공정 식별자). 예) 'F6000'(CELL_FORM_HOLD_UNDER), 'P5200'(BOM 공정).
--                  생산/BOM 조인 키로 사용 (working_time·BOM_V 매칭 시 A.ATTRIBUTE9 = B.OPERATION_ID).
--   ATTRIBUTE10 = 다목적 마커.
--                  (1) PACK_BOH 계열: #SCP_XLS_BOH 의 DESCR(재고 구분, 예 'FOR') 보존.
--                  (2) LT_DAY 처리: 'NO_LT_DIVIDE' 마킹/해제 토글 — 이 값이 후속 LT 분할 분기를 결정(A.5.3 등, 순서 중요).
-- =============================================================================
CREATE PROCEDURE [dbo].[PR_SCM_SIM_DYN_40_RPT]
     @P_BATCH_ID         nvarchar(30)  = '0'
    ,@P_USER_ID          nvarchar(30)  = ''
    ,@P_SNAP_YYYYMMDD    nvarchar(8)   = ''
    ,@P_REPORT_TITLE     nvarchar(254) = 'RAW'
    ,@P_BP_FLAG          char(1)       = 'N'
    ,@P_PLANT_ID         nvarchar(30)  = ''
    ,@P_PLAN_GROUP       nvarchar(100) = ''
    ,@P_DIVISION_ID      nvarchar(30)  = ''
AS
BEGIN
    SET NOCOUNT ON;
 
    -- =======================================================================
    -- LOG 변수
    -- =======================================================================
    DECLARE @v_online_user  NVARCHAR(150) = IIF(ISNULL(@P_USER_ID,'') = '', 'simulator', @P_USER_ID);
    DECLARE @v_program_name NVARCHAR(30)  = 'PR_SCM_SIM_DYN_40_RPT';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER       = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @START_TIME     DATETIME      = SYSDATETIME();
 
    -- =======================================================================
    -- DEBUG: @SQL 분할 PRINT 변수 (2026-05-18 김준규 추가)
    --   SQL Server PRINT 는 NVARCHAR 한 번에 최대 4000 chars
    --   @SQL 이 4000 자 초과 시 truncation → CRLF 위치 기준 청크 분할 출력
    -- =======================================================================
    DECLARE @v_dbg_pp        INT;
    DECLARE @v_dbg_total     INT;
    DECLARE @v_dbg_chunk_max INT = 3500;
    DECLARE @v_dbg_substr    NVARCHAR(MAX);
    DECLARE @v_dbg_rev_lf    INT;
    DECLARE @v_dbg_chunk_len INT;
    DECLARE @v_dbg_label     NVARCHAR(100);
 
PRINT '--A@X#00100--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
 
    -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD
                       + ',@P_REPORT_TITLE:'+@P_REPORT_TITLE
                       + ',@P_BP_FLAG:'+@P_BP_FLAG
                       + ',@P_PLANT_ID:'+@P_PLANT_ID
                       + ',@P_PLAN_GROUP:'+@P_PLAN_GROUP
                       + ',@P_DIVISION_ID:'+@P_DIVISION_ID
                       + ',@P_BATCH_ID:'+@P_BATCH_ID;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0', @v_description, @START_TIME;
 
    BEGIN TRY
        -- ===================================================================
        -- 0. 입력 안전 처리 — 빈 값 / NULL 인 경우 디폴트 'RAW' 처리
        --    (호출자가 @P_REPORT_TITLE 을 누락하거나 빈 값 보내도 RAW 출력)
        -- ===================================================================
        IF ISNULL(@P_REPORT_TITLE, '') = ''
            SET @P_REPORT_TITLE = 'RAW';
 
        IF ISNULL(@P_BP_FLAG, '') = ''
            SET @P_BP_FLAG = 'N';
 
        -- ===================================================================
        -- 1. BP_FLAG 에 따라 일자수 결정
        --    'N' = 364 (52주)
        --    'Y' = 728 (104주)
        -- ===================================================================
        DECLARE @v_n_days           INT;
        DECLARE @v_last_qty_col_idx INT;
        DECLARE @SQL                NVARCHAR(MAX);
        DECLARE @v_qty_cols         NVARCHAR(MAX) = N'';
        DECLARE @v_merge_src        NVARCHAR(MAX) = N'';   -- 2026-06-08 김준규 [YEARBLOCK] BP='Y' 파생테이블(B1+B2 병합)
        DECLARE @v_blk1_c3          NVARCHAR(8);           -- 블록1 CREATE_FROM (= measure 최소 C3)
        DECLARE @v_blk2_c3          NVARCHAR(8);           -- 블록2 CREATE_FROM (= 그 다음 C3, 없으면 NULL)
        DECLARE @v_year_src         NVARCHAR(MAX) = N'';
        DECLARE @i                  INT = 32;
 
        SET @v_n_days           = (CASE WHEN @P_BP_FLAG = 'Y' THEN 728 ELSE 364 END);
        SET @v_last_qty_col_idx = 31 + @v_n_days;   -- C32 ~ C(31+@v_n_days)
 
        -- ===================================================================
        -- 2. 동적 QTY 컬럼 빌드 (C32, C33, ..., C{31+@v_n_days})
        --    BP_FLAG='N' → C32~C395 (364개)
        --    BP_FLAG='Y' → C32~C759 (728개)
        -- ===================================================================
        WHILE @i <= @v_last_qty_col_idx
        BEGIN
		  -- 2026.7.13 박원채  [E20260709-001606] 암호화 연결시 데이터값 복호화 오류방지를 위한 수정
          --  SET @v_qty_cols = @v_qty_cols + N',CAST(S.C' + CAST(@i AS NVARCHAR(10)) + N' AS NVARCHAR(MAX))';	 -- [E20260709-001606] 삭제		
			SET @v_qty_cols = @v_qty_cols + N',CAST(S.C' + CAST(@i AS NVARCHAR(10)) + N' AS NVARCHAR(16))';   -- [E20260709-001606] 추가
            SET @i = @i + 1;
        END
PRINT '--A@X#00200--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
 
        -- ===================================================================
        -- 3. TITLE 분기
        -- ===================================================================
 
        -- ===================================================================
        -- 2026-05-14 김준규: #sort_keys 임시테이블 1회 CREATE (BP_FLAG='Y' 시만)
        --   - 한 호출에 한 시트만 실행되므로 충돌 없음
        --   - 같은 SP 안에서 CREATE TABLE 1회만 → 컴파일러 Msg 2714 회피
        --   - 각 시트의 IF @P_BP_FLAG = 'Y' 안에서 TRUNCATE + INSERT 만 수행
        --   - SP 종료 시 자동 DROP (임시테이블 scope: SP batch)
        --   - BP_FLAG='N' 시 CREATE 실행 안 됨 → 오버헤드 0
        -- ===================================================================
        -- 2026-06-22 김준규 8k 에러 대응 : BP='N'도 8060(wide-row ORDER BY worktable) 회피 위해 동일 적용 시작
        -- IF @P_BP_FLAG = 'Y'
        IF 1 = 1
        -- 2026-06-22 김준규 8k 에러 대응 : BP='N'도 8060(wide-row ORDER BY worktable) 회피 위해 동일 적용 종료
        BEGIN
            IF OBJECT_ID('tempdb..#sort_keys') IS NOT NULL DROP TABLE #sort_keys;
            CREATE TABLE #sort_keys (
                 rn         BIGINT IDENTITY(1,1) PRIMARY KEY CLUSTERED
                ,SORT_SEQ1  NVARCHAR(30)
            );
            CREATE NONCLUSTERED INDEX IX_sort_keys_seq1 ON #sort_keys (SORT_SEQ1) INCLUDE (rn);
        END
 
        -- ─────────────────────────────────────────────────────────────────
        -- 3-A. 'RAW' : 원본 데이터 시트
        -- ─────────────────────────────────────────────────────────────────
        IF @P_REPORT_TITLE = 'RAW'
        --IF @P_REPORT_TITLE IN ( 'RAW','PR_SCM_SIM_DYN_40_RPT' )
        BEGIN
            -- =================================================================
            -- 2026-05-11 김준규 [LABEL 1줄 + 헤더 자동화 변경]
            --   요구사항:
            --     1. ROW 1 의 자동 SQL 헤더 (C1, C2, ...) 가 보이지 않도록 SELECT alias 를
            --        LABEL 행 (SORT_SEQ1=10) 의 값 (DIVISION, PLAN_STA, ...) 으로 동적 설정.
            --     2. LABEL (=10), LABEL2 (=20), LABEL3 (=30) 행 모두 결과에서 제외.
            --        → ROW 1 = SCM_SIM_DYN_COLS 의 LABEL 값 기반 의미있는 헤더 (자동 생성)
            --          ROW 2~= DATA 행 (SORT_SEQ1>=40)
            --
            --   기존 다중 LABEL 출력 (LABEL+LABEL2+LABEL3+DATA) 로직은 본 블록 아래
            --   /* ... 기존 로직 REMARK ... */ 안에 보존.
            -- =================================================================
 
            -- [1단계] LABEL 행 (SORT_SEQ1=10) 에서 C1~C30 alias 변수에 추출
            --   NULL / 빈 문자열은 'C{N}' 으로 fallback (alias 유효성 보장)
            DECLARE @lbl_c1  NVARCHAR(100), @lbl_c2  NVARCHAR(100), @lbl_c3  NVARCHAR(100);
            DECLARE @lbl_c4  NVARCHAR(100), @lbl_c5  NVARCHAR(100), @lbl_c6  NVARCHAR(100);
            DECLARE @lbl_c7  NVARCHAR(100), @lbl_c8  NVARCHAR(100), @lbl_c9  NVARCHAR(100);
            DECLARE @lbl_c10 NVARCHAR(100), @lbl_c11 NVARCHAR(100), @lbl_c12 NVARCHAR(100);
            DECLARE @lbl_c13 NVARCHAR(100), @lbl_c14 NVARCHAR(100), @lbl_c15 NVARCHAR(100);
            DECLARE @lbl_c16 NVARCHAR(100), @lbl_c17 NVARCHAR(100), @lbl_c18 NVARCHAR(100);
            DECLARE @lbl_c19 NVARCHAR(100), @lbl_c20 NVARCHAR(100), @lbl_c21 NVARCHAR(100);
            DECLARE @lbl_c22 NVARCHAR(100), @lbl_c23 NVARCHAR(100), @lbl_c24 NVARCHAR(100);
            DECLARE @lbl_c25 NVARCHAR(100), @lbl_c26 NVARCHAR(100), @lbl_c27 NVARCHAR(100);
            DECLARE @lbl_c28 NVARCHAR(100), @lbl_c29 NVARCHAR(100), @lbl_c30 NVARCHAR(100);
 
            SELECT TOP 1
                 @lbl_c1  = ISNULL(NULLIF(C1,  N''), N'C1' ),  @lbl_c2  = ISNULL(NULLIF(C2,  N''), N'C2' )
                ,@lbl_c3  = ISNULL(NULLIF(C3,  N''), N'C3' ),  @lbl_c4  = ISNULL(NULLIF(C4,  N''), N'C4' )
                ,@lbl_c5  = ISNULL(NULLIF(C5,  N''), N'C5' ),  @lbl_c6  = ISNULL(NULLIF(C6,  N''), N'C6' )
                ,@lbl_c7  = ISNULL(NULLIF(C7,  N''), N'C7' ),  @lbl_c8  = ISNULL(NULLIF(C8,  N''), N'C8' )
                ,@lbl_c9  = ISNULL(NULLIF(C9,  N''), N'C9' ),  @lbl_c10 = ISNULL(NULLIF(C10, N''), N'C10')
                ,@lbl_c11 = ISNULL(NULLIF(C11, N''), N'C11'),  @lbl_c12 = ISNULL(NULLIF(C12, N''), N'C12')
                ,@lbl_c13 = ISNULL(NULLIF(C13, N''), N'C13'),  @lbl_c14 = ISNULL(NULLIF(C14, N''), N'C14')
                ,@lbl_c15 = ISNULL(NULLIF(C15, N''), N'C15'),  @lbl_c16 = ISNULL(NULLIF(C16, N''), N'C16')
                ,@lbl_c17 = ISNULL(NULLIF(C17, N''), N'C17'),  @lbl_c18 = ISNULL(NULLIF(C18, N''), N'C18')
                ,@lbl_c19 = ISNULL(NULLIF(C19, N''), N'C19'),  @lbl_c20 = ISNULL(NULLIF(C20, N''), N'C20')
                ,@lbl_c21 = ISNULL(NULLIF(C21, N''), N'C21'),  @lbl_c22 = ISNULL(NULLIF(C22, N''), N'C22')
                ,@lbl_c23 = ISNULL(NULLIF(C23, N''), N'C23'),  @lbl_c24 = ISNULL(NULLIF(C24, N''), N'C24')
                ,@lbl_c25 = ISNULL(NULLIF(C25, N''), N'C25'),  @lbl_c26 = ISNULL(NULLIF(C26, N''), N'C26')
                ,@lbl_c27 = ISNULL(NULLIF(C27, N''), N'C27'),  @lbl_c28 = ISNULL(NULLIF(C28, N''), N'C28')
                ,@lbl_c29 = ISNULL(NULLIF(C29, N''), N'C29'),  @lbl_c30 = ISNULL(NULLIF(C30, N''), N'C30')
              FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
             WHERE BATCH_ID      = @P_BATCH_ID
               AND SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
               AND REPORT_TITLE  = @P_REPORT_TITLE
               AND SORT_SEQ1     = 10;
 
            -- LABEL 행이 없을 경우 fallback (모든 alias 가 NULL → 'C{N}' 사용)
            SET @lbl_c1  = ISNULL(@lbl_c1,  N'C1' );  SET @lbl_c2  = ISNULL(@lbl_c2,  N'C2' );
            SET @lbl_c3  = ISNULL(@lbl_c3,  N'C3' );  SET @lbl_c4  = ISNULL(@lbl_c4,  N'C4' );
            SET @lbl_c5  = ISNULL(@lbl_c5,  N'C5' );  SET @lbl_c6  = ISNULL(@lbl_c6,  N'C6' );
            SET @lbl_c7  = ISNULL(@lbl_c7,  N'C7' );  SET @lbl_c8  = ISNULL(@lbl_c8,  N'C8' );
            SET @lbl_c9  = ISNULL(@lbl_c9,  N'C9' );  SET @lbl_c10 = ISNULL(@lbl_c10, N'C10');
            SET @lbl_c11 = ISNULL(@lbl_c11, N'C11');  SET @lbl_c12 = ISNULL(@lbl_c12, N'C12');
            SET @lbl_c13 = ISNULL(@lbl_c13, N'C13');  SET @lbl_c14 = ISNULL(@lbl_c14, N'C14');
            SET @lbl_c15 = ISNULL(@lbl_c15, N'C15');  SET @lbl_c16 = ISNULL(@lbl_c16, N'C16');
            SET @lbl_c17 = ISNULL(@lbl_c17, N'C17');  SET @lbl_c18 = ISNULL(@lbl_c18, N'C18');
            SET @lbl_c19 = ISNULL(@lbl_c19, N'C19');  SET @lbl_c20 = ISNULL(@lbl_c20, N'C20');
            SET @lbl_c21 = ISNULL(@lbl_c21, N'C21');  SET @lbl_c22 = ISNULL(@lbl_c22, N'C22');
            SET @lbl_c23 = ISNULL(@lbl_c23, N'C23');  SET @lbl_c24 = ISNULL(@lbl_c24, N'C24');
            SET @lbl_c25 = ISNULL(@lbl_c25, N'C25');  SET @lbl_c26 = ISNULL(@lbl_c26, N'C26');
            SET @lbl_c27 = ISNULL(@lbl_c27, N'C27');  SET @lbl_c28 = ISNULL(@lbl_c28, N'C28');
            SET @lbl_c29 = ISNULL(@lbl_c29, N'C29');  SET @lbl_c30 = ISNULL(@lbl_c30, N'C30');
 
            -- [2단계] QTY 컬럼 alias 빌드 (QTY001~QTYNNN, 0-padding 3자리)
            SET @v_qty_cols = N'';
            SET @i          = 32;
            DECLARE @qty_idx INT;
            WHILE @i <= @v_last_qty_col_idx
            BEGIN
                SET @qty_idx = @i - 31;
                SET @v_qty_cols = @v_qty_cols
						-- 2026.7.13 박원채  [E20260709-001606] 암호화 연결시 데이터값 복호화 오류방지를 위한 수정
                          --      + N',CAST(S.C' + CAST(@i AS NVARCHAR(10)) + N' AS NVARCHAR(MAX))'   -- [E20260709-001606] 삭제	
								+ N',CAST(S.C' + CAST(@i AS NVARCHAR(10)) + N' AS NVARCHAR(256))'      -- [E20260709-001606] 추가	
                                + N' AS [QTY' + RIGHT(N'000' + CAST(@qty_idx AS NVARCHAR(3)), 3) + N']';
                SET @i = @i + 1;
            END
 
PRINT '--A@X#00300--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
 
            -- ============================================================================================================
            -- 2026-05-14 김준규 [옵션 5]: BP_FLAG='Y' 시만 #sort_keys + OUTER APPLY + SORT_ORDER 컬럼 적용
            --   - BP_FLAG='N' (364일): 단일 row → 8060 안전 → 기존 단순 SELECT
            --   - BP_FLAG='Y' (728일): row size 위험 → #sort_keys 사전 정렬 + OUTER APPLY scalar lookup
            -- ============================================================================================================
            -- 2026-06-22 김준규 8k 에러 대응 :BP='N'도 SORT_ORDER 사용 위해 항상 populate 시작
            -- IF @P_BP_FLAG = 'Y'
            IF 1 = 1
            -- 2026-06-22 김준규 8k 에러 대응 :BP='N'도 SORT_ORDER 사용 위해 항상 populate 종료
            BEGIN
                -- 2026-05-14 김준규: 최상단에 1회 CREATE 된 #sort_keys 에 INSERT (TRUNCATE 후)
                TRUNCATE TABLE #sort_keys;
 
            -- 2026-06-08 김준규 [YEARBLOCK]: 블록1∪블록2 universe 에서 measure 당 1행(최소 C3 = 블록1, 없으면 블록2)
            --   → year2-only measure 도 포함 (블록1 드라이빙 누락 방지). 병합행 1개라 C3 정렬키 제외.
            INSERT INTO #sort_keys (SORT_SEQ1)
            SELECT SORT_SEQ1
              FROM (
                    SELECT SORT_SEQ1, C775, C7, C9, C25, C10, C30, C12, C18, C20, C17, C779 --2026.06.23 김준규 표시순서에 메저와 TO_SITE사이에 TEAM을 넣음
                          ,ROW_NUMBER() OVER (PARTITION BY SORT_SEQ1 ORDER BY C3) AS rn1
              FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
             WHERE BATCH_ID      = @P_BATCH_ID
               AND SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
               AND REPORT_TITLE  = @P_REPORT_TITLE
               AND SORT_SEQ1     NOT IN (10, 20, 30)
                   ) X
             WHERE X.rn1 = 1
             ORDER BY C775 DESC, C7, C9, C25, C10, CONVERT(INT, C30), C12, C18, C20, C17, SORT_SEQ1, CONVERT(INT, C779); --2026.06.23 김준규 표시순서에 메저와 TO_SITE사이에 TEAM을 넣음
            END

            -- 2026-06-08 김준규 [YEARBLOCK]: BP='Y' 파생테이블(S) 빌드 — universe(블록1∪블록2) + B1(year1)+B2(year2) 병합
            --   universe 로 year2-only measure 누락 방지. C32~C395=B1, C396~C759=B2(블록상대 C32~). 메타=COALESCE(B1,B2).
            --   LEFT LOOP JOIN → worktable 회피. 바깥 SELECT 는 S.Cx 그대로 사용.
            IF @P_BP_FLAG = 'Y'
            BEGIN
                -- 2026-06-08 김준규 [YEARBLOCK]: 블록 C3 식별 (C2 의존 제거 — measure 최소 C3=블록1, 그 다음=블록2)
                SET @v_blk1_c3 = (SELECT MIN(C3) FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
                                  WHERE BATCH_ID=@P_BATCH_ID AND SNAP_YYYYMMDD=@P_SNAP_YYYYMMDD
                                    AND REPORT_TITLE=@P_REPORT_TITLE AND SORT_SEQ1 NOT IN (10,20,30));
                SET @v_blk2_c3 = (SELECT MIN(C3) FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
                                  WHERE BATCH_ID=@P_BATCH_ID AND SNAP_YYYYMMDD=@P_SNAP_YYYYMMDD
                                    AND REPORT_TITLE=@P_REPORT_TITLE AND SORT_SEQ1 NOT IN (10,20,30)
                                    AND C3 > @v_blk1_c3);   -- 2블록째 없으면 NULL → B2 매칭 0 (정상)

                SET @v_year_src = N'';
                SET @i = 32;
                WHILE @i <= @v_last_qty_col_idx
                BEGIN
                    SET @v_year_src = @v_year_src
                        + CASE WHEN @i <= 395
                               THEN N',B1.C' + CAST(@i       AS NVARCHAR(10)) + N' AS C' + CAST(@i AS NVARCHAR(10))
                               ELSE N',B2.C' + CAST(@i - 364 AS NVARCHAR(10)) + N' AS C' + CAST(@i AS NVARCHAR(10)) END;
                    SET @i = @i + 1;
                END

                SET @v_merge_src = N'(SELECT U.BATCH_ID, U.SNAP_YYYYMMDD, U.REPORT_TITLE, U.PLANT_ID, U.PLAN_GROUP, U.DIVISION_ID, U.SORT_SEQ1
                    ,COALESCE(B1.C1,B2.C1) AS C1,COALESCE(B1.C2,B2.C2) AS C2,COALESCE(B1.C3,B2.C3) AS C3,COALESCE(B1.C4,B2.C4) AS C4,COALESCE(B1.C5,B2.C5) AS C5
                    ,COALESCE(B1.C6,B2.C6) AS C6,COALESCE(B1.C7,B2.C7) AS C7,COALESCE(B1.C8,B2.C8) AS C8,COALESCE(B1.C9,B2.C9) AS C9,COALESCE(B1.C10,B2.C10) AS C10
                    ,COALESCE(B1.C11,B2.C11) AS C11,COALESCE(B1.C12,B2.C12) AS C12,COALESCE(B1.C13,B2.C13) AS C13,COALESCE(B1.C14,B2.C14) AS C14,COALESCE(B1.C15,B2.C15) AS C15
                    ,COALESCE(B1.C16,B2.C16) AS C16,COALESCE(B1.C17,B2.C17) AS C17,COALESCE(B1.C18,B2.C18) AS C18,COALESCE(B1.C19,B2.C19) AS C19,COALESCE(B1.C20,B2.C20) AS C20
                    ,COALESCE(B1.C21,B2.C21) AS C21,COALESCE(B1.C22,B2.C22) AS C22,COALESCE(B1.C23,B2.C23) AS C23,COALESCE(B1.C24,B2.C24) AS C24,COALESCE(B1.C25,B2.C25) AS C25
                    ,COALESCE(B1.C26,B2.C26) AS C26,COALESCE(B1.C27,B2.C27) AS C27,COALESCE(B1.C28,B2.C28) AS C28,COALESCE(B1.C29,B2.C29) AS C29,COALESCE(B1.C30,B2.C30) AS C30
                    ,COALESCE(B1.C771,B2.C771) AS C771,COALESCE(B1.C772,B2.C772) AS C772,COALESCE(B1.C773,B2.C773) AS C773,COALESCE(B1.C774,B2.C774) AS C774,COALESCE(B1.C775,B2.C775) AS C775
                    ,COALESCE(B1.CREATED_BY,B2.CREATED_BY) AS CREATED_BY
                    ,COALESCE(B1.CREATION_DATE,B2.CREATION_DATE) AS CREATION_DATE
                    ,COALESCE(B1.LAST_UPDATED_BY,B2.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                    ,COALESCE(B1.LAST_UPDATE_DATE,B2.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE'
                    + @v_year_src + N'
                 FROM (SELECT DISTINCT BATCH_ID, SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID, SORT_SEQ1
                         FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
                        WHERE BATCH_ID = @P_BATCH_ID AND SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
                          AND REPORT_TITLE = @P_REPORT_TITLE AND SORT_SEQ1 NOT IN (10,20,30)) U
                 LEFT LOOP JOIN SCM_SIM_DYN_COLS B1 WITH(NOLOCK)
                      ON B1.BATCH_ID=U.BATCH_ID AND B1.SNAP_YYYYMMDD=U.SNAP_YYYYMMDD AND B1.REPORT_TITLE=U.REPORT_TITLE AND B1.SORT_SEQ1=U.SORT_SEQ1 AND B1.C3=@v_blk1_c3
                 LEFT LOOP JOIN SCM_SIM_DYN_COLS B2 WITH(NOLOCK)
                      ON B2.BATCH_ID=U.BATCH_ID AND B2.SNAP_YYYYMMDD=U.SNAP_YYYYMMDD AND B2.REPORT_TITLE=U.REPORT_TITLE AND B2.SORT_SEQ1=U.SORT_SEQ1 AND B2.C3=@v_blk2_c3
                ) S';
            END
 
            -- [3단계] 동적 SQL 빌드 (LABEL/LABEL2/LABEL3 모두 제외, alias 적용) — DATA 행만 출력
            SET @SQL = N'
                SELECT
                    -- C1~C30: LABEL 행 값을 alias 로 (ROW 1 헤더가 의미있는 텍스트로 표시됨)
                     S.C1  AS [' + @lbl_c1  + N']
                    ,S.C2  AS [' + @lbl_c2  + N']
                    ,S.C3  AS [' + @lbl_c3  + N']
                    ,S.C4  AS [' + @lbl_c4  + N']
                    ,S.C5  AS [' + @lbl_c5  + N']
                    ,S.C6  AS [' + @lbl_c6  + N']
                    ,S.C7  AS [' + @lbl_c7  + N']
                    ,S.C8  AS [' + @lbl_c8  + N']
                    ,S.C9  AS [' + @lbl_c9  + N'] -- CELL_ITEM_ID
                    ,NULL  AS [Key] -- KEY
                    ,S.C10 AS [' + @lbl_c10 + N'] -- ITEM_ID
                    ,S.C11 AS [' + @lbl_c11 + N']
                    ,S.C12 AS [' + @lbl_c12 + N']
                    ,S.C13 AS [' + @lbl_c13 + N']
                    ,S.C14 AS [' + @lbl_c14 + N']
                    ,S.C15 AS [' + @lbl_c15 + N']
                    ,S.C16 AS [' + @lbl_c16 + N']
                    ,S.C17 AS [' + @lbl_c17 + N']
                    ,S.C18 AS [' + @lbl_c18 + N']
                    ,S.C19 AS [' + @lbl_c19 + N']
                    ,S.C20 AS [' + @lbl_c20 + N']
                    ,S.C21 AS [' + @lbl_c21 + N']
                    ,S.C22 AS [' + @lbl_c22 + N']
                    ,S.C23 AS [' + @lbl_c23 + N']
                    ,S.C24 AS [' + @lbl_c24 + N']
                    ,S.C25 AS [' + @lbl_c25 + N']
                    ,S.C26 AS [' + @lbl_c26 + N']
                    ,S.C27 AS [' + @lbl_c27 + N']
                    ,S.C28 AS [' + @lbl_c28 + N']
                    ,S.C29 AS [' + @lbl_c29 + N']
                    ,S.C30 AS [' + @lbl_c30 + N']
                    -- C30 XLS_KEY1: DATA 행만 출력하므로 단순 식 (CASE WHEN 불필요)
                    ,(CONVERT(NVARCHAR(50), S.BATCH_ID) + N'' - '' + CONVERT(NVARCHAR(50), S.SORT_SEQ1)) AS [XLS_KEY1]'
                    + @v_qty_cols + N'
                    -- audit 4 컬럼 (DATA 값 그대로)
                    ,S.CREATED_BY                                   AS [CREATED_BY]
                    ,CONVERT(NVARCHAR(30), S.CREATION_DATE, 121)    AS [CREATION_DATE]
                    ,S.LAST_UPDATED_BY                              AS [LAST_UPDATED_BY]
                    ,CONVERT(NVARCHAR(30), S.LAST_UPDATE_DATE, 121) AS [LAST_UPDATE_DATE]
                    -- tail 5 컬럼 (어댑터 SP가 C771~C775에 채움)
                    ,S.C771 AS [ATTRIBUTE1]
                    ,S.C772 AS [ATTRIBUTE3]
                    ,S.C773 AS [ATTRIBUTE9]
                    ,S.C774 AS [ATTRIBUTE10]
                    ,S.C775 AS [SHEET_TYPE]
                    -- RNO: DATA 행의 SORT_SEQ1 (향후 UPDATE API 의 key 로 사용)
                    ,CONVERT(NVARCHAR(30), S.SORT_SEQ1) AS [RNO]'
                    -- 2026-05-14 김준규 [옵션 A]: BP_FLAG='Y' 시만 SORT_ORDER 컬럼 (K.rn) 추가
                    --   BP_FLAG='Y': 마지막 컬럼 SORT_ORDER 추가 (VBA 정렬용)
                    --   BP_FLAG='N': SORT_ORDER 컬럼 없음
		    -- 2026-06-22 김준규 8k 에러 대응 : BP 무관 항상 추가(VBA 정렬키) 시작
                    --+ (CASE WHEN @P_BP_FLAG = 'Y' THEN N',RIGHT(N''00000000'' + CONVERT(NVARCHAR(30), K.rn), 8) AS [SORT_ORDER]' ELSE N'' END)
                    + N',RIGHT(N''00000000'' + CONVERT(NVARCHAR(30), K.rn), 8) AS [SORT_ORDER]'
		    -- 2026-06-22 김준규 8k 에러 대응 : BP 무관 항상 추가(VBA 정렬키) 종료
                + N'
                FROM ' + (CASE WHEN @P_BP_FLAG = 'Y' THEN @v_merge_src ELSE N'SCM_SIM_DYN_COLS S WITH(NOLOCK)' END)
                -- 2026-05-14 김준규 [OUTER APPLY]: BP_FLAG='Y' 시만 #sort_keys lookup
		-- 2026-06-22 김준규 8k 에러 대응 : BP 무관 항상 추가(VBA 정렬키) 시작
                --+ (CASE WHEN @P_BP_FLAG = 'Y' THEN N'
                + N'
		-- 2026-06-22 김준규 8k 에러 대응 : BP 무관 항상 추가(VBA 정렬키) 종료
                OUTER APPLY (SELECT TOP 1 K2.rn
                               FROM #sort_keys K2 WITH(INDEX = IX_sort_keys_seq1)
                              --WHERE K2.SORT_SEQ1 = S.SORT_SEQ1) K'' ELSE N'' END)
                              WHERE K2.SORT_SEQ1 = S.SORT_SEQ1) K'
		-- 2026-06-22 김준규 8k 에러 대응 : BP 무관 항상 추가(VBA 정렬키) 종료
                + N'
                WHERE S.BATCH_ID         = @P_BATCH_ID
                  AND S.SNAP_YYYYMMDD    = @P_SNAP_YYYYMMDD
                  AND S.REPORT_TITLE     = @P_REPORT_TITLE
                  AND S.SORT_SEQ1        NOT IN (10, 20, 30)';   -- LABEL/LABEL2/LABEL3 제외
 
            -- 옵셔널 필터
            IF ISNULL(@P_PLANT_ID,'')     <> ''  SET @SQL = @SQL + N' AND S.PLANT_ID    = @P_PLANT_ID';
            IF ISNULL(@P_PLAN_GROUP,'')   <> ''  SET @SQL = @SQL + N' AND S.PLAN_GROUP  = @P_PLAN_GROUP';
            IF ISNULL(@P_DIVISION_ID,'')  <> ''  SET @SQL = @SQL + N' AND S.DIVISION_ID = @P_DIVISION_ID';
 
            -- 2026-05-14 김준규 [옵션 A RAW]: BP_FLAG 분기
            --   BP_FLAG='N' (364일): 기존 ORDER BY (worktable 안전)
            --   BP_FLAG='Y' (728일): ORDER BY 제거 (worktable 회피) — VBA 가 SORT_ORDER 컬럼으로 정렬
            -- 2026-06-22 김준규 8k 에러 대응 : BP 무관 ORDER BY 제거 — wide-row 정렬 worktable(8060) 회피, VBA 가 SORT_ORDER 로 정렬 시작
            -- IF @P_BP_FLAG = 'Y'
            IF 1 = 1
            -- 2026-06-22 김준규 8k 에러 대응 : BP 무관 ORDER BY 제거 — wide-row 정렬 worktable(8060) 회피, VBA 가 SORT_ORDER 로 정렬 종료
            BEGIN
                SET @SQL = @SQL + N';';
            END
            ELSE
            BEGIN
            -- 2026-05-15 김준규 [ORDER BY 통일 v2]: PR_SCP_XLS_DAILY_SMALL 의 ORDER BY 와 동일 (11개 정렬 키)
            --   1. CREATE_FROM_YYYYMMDD  (C3)
            --   2. SHEET_TYPE DESC       (C775)   -- 시트분리기준
            --   3. FROM_SITE             (C7)
            --   4. CELL_ITEM_ID          (C9)
            --   5. ITEM_TYPE             (C25)    -- 제품먼저 (KSK, 250407)
            --   6. ITEM_ID               (C10)
            --   7. MEASURE_ORDER         (CASE C14 직접 매핑)
            --   7-1.TEAM                 (C12)
            --   8. TO_SITE               (C18)
            --   (DEPT_NAME_KO 는 SCM_SIM_DYN_COLS 에 매핑 컬럼 없음 — 원본 PR_SCP_XLS_DAILY_SMALL 도 주석처리)
            --   9. INCOTERMS             (C20)
            --  10. PROJECT_CODE          (C17)
            --  11. XLS_KEY1              (BATCH_ID + ' - ' + SORT_SEQ1)  -- REQ TO PLAN 복사시 순서역전 방지 (KSK, 250319)
            -- 2026-05-15 김준규 변경: MEASURE_ORDER CASE 옵션 C (SHIP 16 + PROD 7) 적용
            --   PR_SCP_XLS_DAILY_SMALL 라인 198~203 에서 적재되는 23개 measure 모두 결정적 매핑
            --   SHIP 16 (10~130), PROD 7 (200~260), 매핑 외 measure 는 ELSE 9999
            SET @SQL = @SQL + N'
                ORDER BY S.C3                                                                                              -- CREATE_FROM_YYYYMMDD
                       , S.C775                              DESC                                                          -- SHEET_TYPE DESC (시트분리기준)
                       , S.C7                                                                                              -- FROM_SITE
                       , S.C9                                                                                              -- CELL_ITEM_ID
                       , S.C25                                                                                             -- ITEM_TYPE (제품먼저, KSK 250407)
                       , S.C10                                                                                             -- ITEM_ID
                       , CONVERT(INT,S.C30)                                                                          -- 2026-05-31 김준규: level1 (C30 = MEASURE_ORDER 직접)
                       --, CASE S.C14                                                                                        -- MEASURE_ORDER (옵션 C: SHIP 16 + PROD 7)
                       --       -- SHIP 그룹 (16개)
                       --       WHEN N''MKT_FCST''                       THEN  10
                       --       WHEN N''ALLOCATION''                     THEN  20
                       --       WHEN N''FCST_RTF_ACC''                   THEN  30
                       --       WHEN N''TO_SITE_BOH''                    THEN  40
                       --       WHEN N''TO_SITE_EOH''                    THEN  50
                       --       WHEN N''INTRANSIT''                      THEN  60
                       --       WHEN N''INTRANSIT_ETA''                  THEN  70
                       --       WHEN N''WHIN_TOTAL''                     THEN  80
                       --       WHEN N''WHIN''                           THEN  90
                       --       WHEN N''SHIP_REQ''                       THEN  95
                       --       WHEN N''SHIP_PLAN_ETA''                  THEN 100
                       --       WHEN N''SEMI_SHIP_PLAN_ORG''             THEN 105
                       --       WHEN N''SEMI_SHIP_PLAN''                 THEN 110
                       --       WHEN N''SEMI_SHIP_GAP_ACC''              THEN 115
                       --       WHEN N''SHIP_PLAN''                      THEN 120
                       --       WHEN N''SHIP_PLAN_PLANT''                THEN 130
                       --       -- PROD 그룹 (7개, PR_SCP_XLS_DAILY_SMALL 라인 202~203 동일)
                       --       WHEN N''CELL_EOH''                       THEN 200
                       --       WHEN N''CELL_FOR_FORM_END''              THEN 210
                       --       WHEN N''CELL_PROD_FORM_END''             THEN 220
                       --       WHEN N''CELL_PROD''                      THEN 230
                       --       WHEN N''CELL_FORM_PROGRESS''             THEN 240
                       --       WHEN N''CELL_FORM_HOLD_UNDER_AVAILABLE'' THEN 250
                       --       WHEN N''CELL_FORM_HOLD_AFTER''           THEN 260
                       --       ELSE 9999
                       --  END
                       , S.C12                                                                                             -- TEAM
                       , S.C18                                                                                             -- TO_SITE
                       --, S.DEPT_NAME_KO                                                                                  -- (SCM_SIM_DYN_COLS 매핑 없음 — 원본 주석유지)
                       , S.C20                                                                                             -- INCOTERMS
                       , S.C17                                                                                             -- PROJECT_CODE
                       --2026-05-20 김준규 REPORT 순서에 SEMI_SHIP_PLAN 추가 2개라인 순서 추가 함
                       , (CONVERT(NVARCHAR(50), S.BATCH_ID) + N'' - '' + CONVERT(NVARCHAR(50), S.SORT_SEQ1))               -- XLS_KEY1 (블록·TRANS·measure 자연순 우선) [2026-06-01 김준규: C779 보다 앞으로]
                       , CONVERT(INT,S.C779)                                                                               -- level2 tie-break (XLS_KEY1 동률시만 ORG=100/PLAN=200/GAP=300)
                       ;';
            END
 
            -- (DEBUG: 동적 SQL 검토용) PRINT @SQL;
 
            -- 2026-05-14 김준규 [테스트]: BATCH_ID/SNAP_YYYYMMDD/REPORT_TITLE 는 값 concat 처리 → parameter 에서 제거
PRINT '--A@X#00400--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
DECLARE @DUMMY NVARCHAR(MAX);
SET @DUMMY = @SQL;
DECLARE @POS INT;
 
WHILE LEN(@DUMMY) > 0
BEGIN
    SET @POS = CHARINDEX(CHAR(13) + CHAR(10), @DUMMY);
    IF @POS = 0
    BEGIN
        PRINT @DUMMY;             -- CRLF 없으면 마지막 줄 출력 후 종료
        BREAK;
    END;
    PRINT LEFT(@DUMMY, @POS - 1); -- CRLF 직전까지 출력
    SET @DUMMY = SUBSTRING(@DUMMY, @POS + 2, LEN(@DUMMY));
END;
 
            -- ==========================================================
            -- DEBUG: @SQL 분할 PRINT (2026-05-18 김준규 추가)
            --   PRINT 4000자 제한 회피 — CRLF 위치 기준 청크 분할
            -- ==========================================================
            SET @v_dbg_label = N'RAW';
            PRINT N'--A@X#RAW_SQL_PRINT_START-- (' + @v_dbg_label + N') len=' + CAST(LEN(@SQL) AS NVARCHAR(20));
            SET @v_dbg_pp    = 1;
            SET @v_dbg_total = LEN(@SQL);
            WHILE @v_dbg_pp <= @v_dbg_total
            BEGIN
                IF @v_dbg_pp + @v_dbg_chunk_max - 1 >= @v_dbg_total
                    SET @v_dbg_chunk_len = @v_dbg_total - @v_dbg_pp + 1;
                ELSE
                BEGIN
                    SET @v_dbg_substr = SUBSTRING(@SQL, @v_dbg_pp, @v_dbg_chunk_max);
                    SET @v_dbg_rev_lf = CHARINDEX(CHAR(10), REVERSE(@v_dbg_substr));
                    IF @v_dbg_rev_lf > 0 AND @v_dbg_rev_lf < @v_dbg_chunk_max
                        SET @v_dbg_chunk_len = LEN(@v_dbg_substr) - @v_dbg_rev_lf + 1;
                    ELSE
                        SET @v_dbg_chunk_len = @v_dbg_chunk_max;
                END
                PRINT SUBSTRING(@SQL, @v_dbg_pp, @v_dbg_chunk_len);
                SET @v_dbg_pp = @v_dbg_pp + @v_dbg_chunk_len;
            END
            PRINT N'--A@X#RAW_SQL_PRINT_END-- (' + @v_dbg_label + N')';
            EXEC sp_executesql @SQL,
                N'@P_BATCH_ID NVARCHAR(30), @P_SNAP_YYYYMMDD NVARCHAR(8), @P_REPORT_TITLE NVARCHAR(254), @P_PLANT_ID NVARCHAR(30), @P_PLAN_GROUP NVARCHAR(100), @P_DIVISION_ID NVARCHAR(30), @v_blk1_c3 NVARCHAR(8), @v_blk2_c3 NVARCHAR(8)',
                @P_BATCH_ID, @P_SNAP_YYYYMMDD, @P_REPORT_TITLE, @P_PLANT_ID, @P_PLAN_GROUP, @P_DIVISION_ID, @v_blk1_c3, @v_blk2_c3;
 
PRINT '--A@X#00500--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
 
        END
        ELSE
        BEGIN
            DECLARE @v_err NVARCHAR(500) =
                N'지원하지 않는 REPORT_TITLE 입니다: [' + ISNULL(@P_REPORT_TITLE,'') + N']. ' +
                N'가능한 값: RAW';
            RAISERROR(@v_err, 16, 1);
        END
 
        -- 종료 LOG
        SET @v_log_type    = 'END';
        SET @v_log_message = '##### END of procedure #####';
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', 0, @v_log_message, @v_description, @d_event_date;
 
    END TRY
    BEGIN CATCH
        DECLARE @v_err_msg NVARCHAR(MAX) = ERROR_MESSAGE();
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @@ROWCOUNT, @v_err_msg, @v_description, @d_event_date;
 
        PRINT 'ERROR';
        PRINT @v_err_msg;
 
        -- 에러 정보 출력
        SELECT
             ERROR_NUMBER()    AS ErrorNumber
            ,ERROR_SEVERITY()  AS ErrorSeverity
            ,ERROR_STATE()     AS ErrorState
            ,ERROR_PROCEDURE() AS ErrorProcedure
            ,ERROR_LINE()      AS ErrorLine
            ,ERROR_MESSAGE()   AS ErrorMessage;
    END CATCH;
END
