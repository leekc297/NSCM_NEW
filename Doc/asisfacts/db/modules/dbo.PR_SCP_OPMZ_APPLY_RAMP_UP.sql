
/* ---- 3) 램프업 ---------------------------------------------------------------------------- */

CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_RAMP_UP
    @SNRO_CD          NVARCHAR(50),
    @USER_ID          NVARCHAR(200) = NULL,
    @OPT_KEY_VAL_ID   NVARCHAR(200) = NULL,   -- 콤마구분 카드 목록(예 'CRD-00105,CRD-00103'); NULL=전체
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    /*==========================================================================================
     [프로시저] dbo.PR_SCP_OPMZ_APPLY_RAMP_UP
    ------------------------------------------------------------------------------------------
     [목적]
       OPTENG_SCP 시나리오 패치(JSON) 중 램프업(RAMP_UP) 관련 UPDATE 패치를 해석하여,
       라인/품목/기간별 효율(EFCY)을 산출하고 최적화 입력 테이블 SCP_OPMZ_RAMP_UP 에 반영한다.
       (전체 PK 기준 MERGE 이므로 재실행해도 결과가 동일한 멱등(idempotent) 처리.)

     [소스]
       dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN.SCP_OPT_PTCH_JSON_CTN (시나리오 패치 JSON)
         └ table = 'SCP_OPT_ENG_ROUTING_RESOURCE' 이고 op IN ('UPDATE','INSERT') 인 패치 대상.
       카드 판정: FN_GET_SCP_OPMZ_OPT_TARGET(SCP_OPT_ID, 'RAMP_UP')=1 (lookup).
                  CRD-00105(기존 램프단축, UPDATE) + CRD-00008/00103(신규라인 램프, INSERT). CRD-00009 는 VALID_N(참조용).

     [타겟]
       dbo.SCP_OPMZ_RAMP_UP (라인/품목/기간별 램프업 효율 입력).

     [핵심 변환식] EFCY(%)
       (1) UPDATE(기존 램프단축): EFCY = 기준 old_lp ÷ 변경 new_lp × 100
           · 기준(old_lp)은 "패치 where 옛값"만 사용(엔진 원본 미조회 → 값 오염 방지).
           · where 옛값 없으면 계산 불가 → 제외.
       (2) INSERT(신규라인 램프, CRD-00008/00103): EFCY = 같은 라인/품목 INSERT들의 최소(steady-state) LOAD_PER ÷ 해당 new_lp × 100
           · routing_id=<<AUTO_ROUTING_ID>>('::'없음) → RESOURCE_ID(SITE::LINE)로 라인, ITEM/OP는 형제행 보충(filled).
           · 예) LOAD_PER 0.279/0.465→60, 0.279/0.349→80, 0.279/0.279→100 (60/80/100 램프곡선).
       공통: new_lp(set) 0 이하면 제외(0 나눗셈 방지).

     [키 파싱]
       ROUTING_ID = SITE::ITEM::STAGE::LINE::일자 형식을 FN_SPLIT_VAL('::',n) 로 seg1~5 분해.
         seg1=SITE → PLANT_ID 는 '-' 앞부분, seg2=ITEM, seg3=OPERATION, seg4=LINE, seg5=일자.
       DIVISION_ID = SCP_OPMZ_PLAN_M.DIVISION_ID 우선, 없으면 plan_id 의 2번째 '_' 세그먼트.

     [src 태깅]  'W'=where(기존/키 조건), 'S'=set(변경 후 값).
                 old_lp = where 의 LOAD_PER, new_lp = set 의 LOAD_PER.

     [파라미터]
       @SNRO_CD          시나리오 코드(필수). SCP_SNRO_ID 로 매칭.
       @USER_ID          감사 컬럼용 사용자(미지정 시 SUSER_SNAME()).
       @RETURN_RESULT_YN 'Y' 면 마지막에 결과 요약 SELECT 반환.

     [트랜잭션/호환성]
       @START_TRAN = (@@TRANCOUNT=0) → 단독 호출 시에만 BEGIN/COMMIT/ROLLBACK,
       오케스트레이터 하위 호출이면 기존 트랜잭션에 합류(중첩 커밋/롤백/에러로그 미수행).
       compat120 환경: OPENJSON 불가 → FN_SCP_JSON_ARRAY_ITEMS_120 / FN_SCP_JSON_OBJECT_ITEMS_120 /
       JSON_VALUE / JSON_QUERY 사용. 크로스DB 문자열 비교는 COLLATE DATABASE_DEFAULT 로 정렬 통일.

     [로그]
       PR_SCM_SYS_LOG_BATCH 로 START/SUCCESS/ERROR 요약 남기고,
       #chg(MERGE OUTPUT) 를 SCM_SYS_LOG_BATCH 에 행단위 변경이력(ATTRIBUTE1~7)으로 적재.

     [단계 요약]
       1 실행옵션 → 2 입력검증 → 3 변수선언 → 4 시작로그 → 5 트랜잭션시작
       → 6 패치파싱/EFCY산출(#rp) → 7 MERGE 반영 + 행단위 로그 → 8 커밋
       → 9 성공로그 → 10 결과반환 / 11 CATCH(롤백·에러로그·재전파)
    ==========================================================================================*/

    /* 1 시작: 기본 실행 옵션. 영향건수 메시지 끄고(불필요한 DONE_IN_PROC 억제), 오류 시 트랜잭션 전체 즉시 실패. */
    SET NOCOUNT ON;

    /* SOP Pull-in(GitLab #20) 지정 EFCY 표식의 카드코드. patch 의 set.USER_ATTB2 가
       `CRD-00401|50` 처럼 오면 그 값을 그대로 EFCY 로 쓴다(역산하지 않는다).
       **앞자리가 이 카드일 때만** 읽는다 — 다른 카드가 같은 칸을 써도 서로 안 부딪친다. */
    DECLARE @SOP_REQUEST_CARD NVARCHAR(50) = N'CRD-00401';
    SET XACT_ABORT ON;
    /* 1 종료. */

    /* 2 시작: 필수 입력값(시나리오 코드) 검증 — 공백/NULL 이면 즉시 예외로 조기 종료. */
    IF NULLIF(LTRIM(RTRIM(@SNRO_CD)), N'') IS NULL
        THROW 51010, 'SNRO_CD IS REQUIRED.', 1;
    /* 2 종료. */

    /* 3 시작: 런타임 변수 선언(사용자/트랜잭션 소유 여부/집계건수/로그 필드). */
    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());              -- 감사 컬럼용 사용자
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;              -- 1=내가 트랜잭션 소유, 0=중첩 합류
    DECLARE @AFF INT = 0, @RESOLVED INT = 0, @NOAPPLY INT = 0, @DEL INT = 0;            -- @AFF=MERGE 반영건수, @RESOLVED=산출대상건수, @NOAPPLY=미반영건수, @DEL=선-삭제(6b) 건수
    DECLARE @ERR_MSG  NVARCHAR(2048);
    DECLARE @LOG_DT   DATETIME;
    DECLARE @LOG_CNT  INT;
    DECLARE @LOG_DESC NVARCHAR(500);
    /* 3 종료. */

    /* 4 시작: 시작 로그 적재. 트랜잭션 밖에서 기록 → 이후 롤백돼도 "시작했음" 이력은 보존. */
    BEGIN
        SET @LOG_DT  = GETDATE();
        SET @LOG_CNT = 0;
        SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                    N'; CARD=', N'CRD-00105/00103/00008',
                                    N'; TARGET=', N'SCP_OPMZ_RAMP_UP'), 500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH
             @p_program_name = N'PR_SCP_OPMZ_APPLY_RAMP_UP',
             @p_log_type     = N'START',
             @p_log_count    = @LOG_CNT,
             @p_log_message  = N'PR_SCP_OPMZ_APPLY_RAMP_UP 시작',
             @p_description  = @LOG_DESC,
             @p_event_date   = @LOG_DT;
    END;
    /* 4 종료. */

    IF OBJECT_ID('tempdb..#rp') IS NOT NULL DROP TABLE #rp;   -- 재실행 대비 임시테이블 정리
    IF OBJECT_ID('tempdb..#res0') IS NOT NULL DROP TABLE #res0;
        IF OBJECT_ID('tempdb..#rp_cand') IS NOT NULL DROP TABLE #rp_cand;

    BEGIN TRY
        /* 5 시작: 트랜잭션 시작 — 내가 소유한 경우(@START_TRAN=1)에만. 중첩 호출이면 기존 트랜잭션 합류. */
        IF @START_TRAN = 1 BEGIN TRAN;
        /* 5 종료. */

        /* 6 시작: 램프업 패치 파싱 → EFCY 산출 → 반영 대상(#rp) 구성.
                   [무엇을] SCP_OPT_ENG_ROUTING_RESOURCE 패치를 key/value로 펼쳐 라인/품목/기간과 EFCY 계산.
                   [왜]     엔진이 읽는 SCP_OPMZ_RAMP_UP 입력을 시나리오 의도대로 세팅.
                   [두 유형]
                     · UPDATE(기존 램프단축, CRD-00105): where=기준 LOAD_PER, set=변경 LOAD_PER → EFCY=기준÷변경×100.
                       기준(where 옛값)이 없으면 EFCY 산출 불가로 제외(엔진 테이블 미조회 원칙).
                     · INSERT(신규라인 램프, CRD-00008/00103): 신규 라우팅이 주차별 LOAD_PER로 들어옴.
                       routing_id=<<AUTO_ROUTING_ID>>('::'없음)이라 RESOURCE_ID(SITE::LINE)로 라인 도출,
                       ITEM/OPERATION은 같은 라인의 정상 라우팅 형제행에서 보충(filled).
                       EFCY = 같은 라인/품목 INSERT들의 최소(steady-state) LOAD_PER ÷ 해당 LOAD_PER × 100 (예 60/80/100).
                   - 값추출: JSON_VALUE/JSON_QUERY + FN_SCP_JSON_OBJECT_ITEMS_120, 크로스DB COLLATE DATABASE_DEFAULT
                   - 흐름: patch → kv(피벗) → res0(라인/품목/기간/LP) → filled(형제 ITEM보충) → efcy(EFCY) → #rp(PK그룹) */
        ;WITH patch AS (
            -- 시나리오 패치 JSON 배열을 원소 단위로 펼치고, ROUTING_RESOURCE 대상 + RAMP_UP 카드만 필터
            SELECT m.SCP_OPT_ID COLLATE DATABASE_DEFAULT AS opt_id,
                   J.[KEY]                              AS pseq,   -- 패치 배열 내 순번(그룹 키로 사용)
                   UPPER(JSON_VALUE(J.[VALUE], '$.op')) AS op,     -- 패치 연산(UPDATE 만 사용)
                   JSON_QUERY(J.[VALUE], '$.where')     AS wf,     -- where 절 조각(기존/키 값 배열)
                   JSON_QUERY(J.[VALUE], '$.set')       AS sf      -- set 절 조각(변경 후 값 배열)
            FROM dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN m
            CROSS APPLY dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(m.SCP_OPT_PTCH_JSON_CTN) J
            WHERE m.SCP_SNRO_ID = @SNRO_CD
              AND ISJSON(m.SCP_OPT_PTCH_JSON_CTN) = 1                                                    -- 유효 JSON 만
              AND UPPER(PARSENAME(JSON_VALUE(J.[VALUE], '$.table'), 1)) = N'SCP_OPT_ENG_ROUTING_RESOURCE' -- 대상 테이블 판정(스키마 제거 후 이름)
              AND dbo.FN_GET_SCP_OPMZ_OPT_TARGET(m.SCP_OPT_ID, N'RAMP_UP') = 1                          -- RAMP_UP 카드 lookup 판정
              AND (@OPT_KEY_VAL_ID IS NULL
                   OR N',' + REPLACE(@OPT_KEY_VAL_ID, N' ', N'') + N',' LIKE N'%,' + m.SCP_OPT_ID COLLATE DATABASE_DEFAULT + N',%')  -- 특정 카드 목록 스코프(콤마구분, 옵션)
        ),
        kv AS (
            -- 패치별(pseq) where/set 을 컬럼명 기준으로 피벗 → 키/기준값/변경값을 한 행으로 모음
            SELECT p.pseq,
                   p.op,
                   MAX(CASE WHEN f.col='PLAN_ID'                  THEN f.val END) COLLATE DATABASE_DEFAULT AS plan_id,     -- 계획 ID(DIVISION 폴백 파싱용)
                   MAX(CASE WHEN f.col='ROUTING_ID'               THEN f.val END) COLLATE DATABASE_DEFAULT AS routing_id,  -- SITE::ITEM::STAGE::LINE::일자
                   MAX(CASE WHEN f.col='RESOURCE_ID'              THEN f.val END) COLLATE DATABASE_DEFAULT AS resource_id, -- AUTO_ROUTING_ID 행 라인 도출용(SITE::LINE)
                   MAX(CASE WHEN f.src='W' AND f.col='LOAD_PER'   THEN f.val END) COLLATE DATABASE_DEFAULT AS old_lp,      -- 기준 LOAD_PER(where 옛값)
                   MAX(CASE WHEN f.src='S' AND f.col='LOAD_PER'   THEN f.val END) COLLATE DATABASE_DEFAULT AS new_lp,      -- 변경 LOAD_PER(set 값)
                   MAX(CASE WHEN f.src='S' AND f.col='START_DATE' THEN f.val END) COLLATE DATABASE_DEFAULT AS s_sdate,     -- set 시작일(있으면 우선)
                   MAX(CASE WHEN f.src='S' AND f.col='END_DATE'   THEN f.val END) COLLATE DATABASE_DEFAULT AS s_edate,      -- set 종료일(있으면 우선)
                   -- where 의 기간. **SOP Pull-in(CRD-00401)만** 이걸 본다(아래 START/END_DATE 참조).
                   -- 램프 구간이 라우팅 행의 기간과 똑같으면 patch 의 set 에 날짜가 안 실린다
                   -- (바꿀 게 없으니 당연하다). 그때 seg5(ROUTING_ID 의 일자 토큰)로 떨어지면
                   -- 시작=종료인 **하루짜리 램프**가 등록된다(2026-09-11 dev 실측: 30일 구간이
                   -- `20260901~20260901` 로 접힘). where 의 기간이 그 구간의 진짜 경계다.
                   MAX(CASE WHEN f.src='W' AND f.col='START_DATE' THEN f.val END) COLLATE DATABASE_DEFAULT AS w_sdate,      -- where 시작일(SOP Pull-in 전용 폴백)
                   MAX(CASE WHEN f.src='W' AND f.col='END_DATE'   THEN f.val END) COLLATE DATABASE_DEFAULT AS w_edate,      -- where 종료일(SOP Pull-in 전용 폴백)
                   -- SOP Pull-in(CRD-00401)이 싣는 **지정 EFCY**. `카드코드|값` 또는 `카드코드|SKIP`.
                   -- 다른 카드는 이 칸을 안 채우므로 NULL 이고, 아래 분기를 안 탄다(GitLab #20).
                   MAX(CASE WHEN f.src='S' AND f.col='USER_ATTB2' THEN f.val END) COLLATE DATABASE_DEFAULT AS efcy_mark,    -- SOP Pull-in 지정 EFCY 표식
                   MAX(p.opt_id) COLLATE DATABASE_DEFAULT AS opt_id
            FROM patch p
            CROSS APPLY (
                -- where 조각을 src='W' 로, set 조각을 src='S' 로 태깅하여 (col,val) 쌍으로 평탄화
                SELECT 'W' AS src, oc.col, oc.val
                FROM dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(p.wf) a
                CROSS APPLY (
                    SELECT MAX(CASE WHEN UPPER([KEY])='COLUMN' THEN [VALUE] END) col,
                           MAX(CASE WHEN UPPER([KEY])='VALUE'  THEN [VALUE] END) val
                    FROM dbo.FN_SCP_JSON_OBJECT_ITEMS_120_SN(a.[VALUE])
                ) oc
                UNION ALL
                SELECT 'S', oc.col, oc.val
                FROM dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(p.sf) a
                CROSS APPLY (
                    SELECT MAX(CASE WHEN UPPER([KEY])='COLUMN' THEN [VALUE] END) col,
                           MAX(CASE WHEN UPPER([KEY])='VALUE'  THEN [VALUE] END) val
                    FROM dbo.FN_SCP_JSON_OBJECT_ITEMS_120_SN(a.[VALUE])
                ) oc
            ) f
            WHERE p.op IN ('UPDATE','INSERT')     -- UPDATE=기존 램프단축, INSERT=신규라인 램프곡선
            GROUP BY p.opt_id, p.pseq, p.op
        )
        -- res0: CTE 가 아니라 임시테이블로 받는다(2026-09-03).
        -- 아래 filled 이 이 결과를 자기참조하는데 CTE 는 실체화되지 않아 바깥 행마다 통째로
        -- 재계산된다. 그 안에 JSON 파싱·FN_SPLIT_VAL·SCM_MST_SITE·FN_GET_SCP_OPMZ_PLAN_SEQ 가
        -- 들어 있어 형제 프로시저 DDLY_CAPA 에서 같은 형태가 54분+ 를 만들었다(dev 실측).
        -- 계산식·필터·조인은 그대로다. 실체화 위치만 옮긴다.
        SELECT
            /* 라인/품목/기간/LOAD_PER 도출.
               - routing_id 가 '::'형: SITE::ITEM::STAGE::LINE::일자 파싱
               - AUTO(<<AUTO_ROUTING_ID>>, '::'없음): RESOURCE_ID(SITE::LINE)로 SITE/LINE 도출, ITEM/OP는 NULL(→filled에서 보충)
               - LOAD_PER 필터는 여기서 안 함(형제 ITEM 보충을 위해 load_per 없는 ::형 행도 보존). */
            
                COALESCE(
                    pm.DIVISION_ID,                                       -- 우선: 계획마스터의 DIVISION_ID
                    SUBSTRING(kv.plan_id,                                 -- 폴백: plan_id 의 2번째 '_' 세그먼트
                              CHARINDEX('_',kv.plan_id)+1,
                              CHARINDEX('_',kv.plan_id,CHARINDEX('_',kv.plan_id)+1)-CHARINDEX('_',kv.plan_id)-1)
                ) AS DIVISION_ID,
                (SELECT MAX(sm.PLANT_ID) FROM dbo.SCM_MST_SITE sm       -- SCM_SITE_ID→PLANT_ID 권위 매핑(문자열 절단 아님; '-' 없는 실제 PLANT)
                 WHERE sm.SCM_SITE_ID = st.site COLLATE DATABASE_DEFAULT AND sm.VALID_YN='Y') AS PLANT_ID,
                st.line AS LINE_ID,                                                     -- LINE
                CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg3 ELSE NULL END AS OPERATION_ID,  -- OP: ::형만, AUTO는 filled
                CAST('-' AS NVARCHAR(30)) COLLATE DATABASE_DEFAULT AS LINE_TYPE,   -- 기존 테이블 관례('-'). (2026-07-13: 'LINE'→'-' 수정; SOP_EOP와 동일)
                CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg2 ELSE NULL END AS ITEM_ID,       -- ITEM: ::형만, AUTO는 filled
                -- 기간: set → **(우리 카드일 때만) where** → seg5.
                -- 가운데 칸은 SOP Pull-in 표식이 붙은 행에서만 열린다. 다른 카드의 폴백 순서는
                -- 건드리지 않는다 — 이 프로시저는 램프업을 쓰는 카드 전부가 공유한다.
                COALESCE(kv.s_sdate,
                         CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                                   = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT THEN kv.w_sdate END,
                         CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END) AS START_DATE,
                /* ── 2026-09-15: 라우팅 끝(배타) → 램프업 끝(포함) 변환 ──────────────────
                   `SCP_OPT_ENG_ROUTING_RESOURCE` 는 END_DATE 가 **다음 행의 START_DATE** 다.
                   그런데 `SCP_OPMZ_RAMP_UP` 의 소비자는 포함으로 읽는다:
                     PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE:943
                       CAL.BASIS_YYYYMMDD BETWEEN R.START_DATE AND R.END_DATE
                   그대로 넣으면 **END 와 다음 START 가 같아 그 하루가 두 구간에 걸린다**
                   (실측: 5/11 이 95% 행과 97% 행 양쪽에 걸렸다).

                   ⚠ END > START 일 때만 뺀다. 신규라인(CRD-00008)·전극(CRD-00103)은
                     END 를 안 실어 `s_sdate` 로 떨어져 START==END 가 되는데, 거기서 빼면
                     END < START 로 뒤집힌다. 그 두 계열은 이 변환을 타지 않는다. */
                CASE
                    WHEN COALESCE(kv.s_edate,
                                  CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                                            = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT THEN kv.w_edate END,
                                  kv.s_sdate,
                                  CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END)
                         > COALESCE(kv.s_sdate,
                                  CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                                            = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT THEN kv.w_sdate END,
                                  CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END)
                    THEN CONVERT(NVARCHAR(8), DATEADD(DAY, -1, CONVERT(DATETIME,
                             COALESCE(kv.s_edate,
                                      CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                                                = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT THEN kv.w_edate END,
                                      kv.s_sdate,
                                      CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END))), 112)
                    ELSE COALESCE(kv.s_edate,
                                  CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                                            = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT THEN kv.w_edate END,
                                  kv.s_sdate,
                                  CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END)
                END COLLATE DATABASE_DEFAULT AS END_DATE,
                TRY_CAST(kv.old_lp AS float) AS old_lp_f,                 -- 기준 LOAD_PER(where, UPDATE 램프단축용)
                TRY_CAST(kv.new_lp AS float) AS new_lp_f,                 -- 변경/신규 LOAD_PER(set)
                -- 지정 EFCY 파싱 — `카드코드|값`. **앞자리가 그 카드일 때만** 읽는다.
                -- 카드코드를 안 보면 다른 카드가 같은 칸을 쓸 때 그 값을 우리 것으로 오해한다.
                CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                          = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT
                     THEN TRY_CAST(dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',2) AS float)
                     ELSE NULL END AS given_efcy_f,
                CASE WHEN dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',1) COLLATE DATABASE_DEFAULT
                          = @SOP_REQUEST_CARD COLLATE DATABASE_DEFAULT
                      AND UPPER(dbo.FN_SPLIT_VAL_SN(kv.efcy_mark,'|',2)) COLLATE DATABASE_DEFAULT
                          = N'SKIP' COLLATE DATABASE_DEFAULT
                     THEN 1 ELSE 0 END AS efcy_skip,
                -- 「기존」 표시용 patch where 기간 (GitLab #35). 반영 계산에는 쓰지 않는다 —
                -- 기간 폴백 순서(위 START_DATE/END_DATE)는 그대로다.
                kv.w_sdate,
                kv.w_edate,
                kv.op,
                kv.opt_id,
                dbo.FN_GET_SCP_OPMZ_PLAN_SEQ(kv.plan_id, @SNRO_CD) AS plan_id  -- 채번 계획ID(base→base_S00x). DESC 이력 꼬리용
        INTO #res0
        FROM kv
            CROSS APPLY (   -- ROUTING_ID '::' 5분해(SITE/ITEM/STAGE/LINE/일자)
                SELECT dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',1) COLLATE DATABASE_DEFAULT AS seg1,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',2) COLLATE DATABASE_DEFAULT AS seg2,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',3) COLLATE DATABASE_DEFAULT AS seg3,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',4) COLLATE DATABASE_DEFAULT AS seg4,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',5) COLLATE DATABASE_DEFAULT AS seg5
            ) sp
            CROSS APPLY (   -- SITE/LINE: ::형이면 routing 세그, AUTO면 RESOURCE_ID(SITE::LINE)
                SELECT CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg1 ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',1) COLLATE DATABASE_DEFAULT END AS site,
                       CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg4 ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',2) COLLATE DATABASE_DEFAULT END AS line
            ) st
        LEFT JOIN dbo.SCP_OPMZ_PLAN_M pm ON pm.OPMZ_PLAN_ID = kv.plan_id
        ;

        ;WITH filled AS (
            /* AUTO 행(ITEM/OP 없음)은 같은 (DIV/PLANT/LINE)의 정상 라우팅 형제행에서 ITEM/OPERATION 채움.
               (형제는 load_per 유무 무관 — 그래서 res0 에서 load_per 필터를 미리 안 걸었음) */
            SELECT r.DIVISION_ID, r.PLANT_ID, r.LINE_ID, r.LINE_TYPE, r.START_DATE, r.END_DATE,
                   r.old_lp_f, r.new_lp_f, r.op, r.opt_id, r.plan_id, r.w_sdate, r.w_edate,
                   r.given_efcy_f, r.efcy_skip,
                   COALESCE(NULLIF(r.ITEM_ID,N''),      sib.ITEM_ID)      AS ITEM_ID,
                   dbo.FN_GET_SCP_OPMZ_LINE_OP(r.DIVISION_ID, r.PLANT_ID, r.LINE_ID) AS OPERATION_ID  -- 라인룩업만(STAGE/형제 폴백 제거). 미등록 라인은 아래 #rp_cand에서 DROP_NOOP
            FROM #res0 r
            OUTER APPLY (
                SELECT TOP 1 r2.ITEM_ID, r2.OPERATION_ID
                FROM #res0 r2
                WHERE COALESCE(r2.ITEM_ID,N'')<>N''
                  AND r2.LINE_ID=r.LINE_ID AND r2.DIVISION_ID=r.DIVISION_ID AND r2.PLANT_ID=r.PLANT_ID
                ORDER BY r2.ITEM_ID
            ) sib
        ),
        efcy AS (
            /* EFCY(%) 산출 (실제 LOAD_PER 있는 세그먼트만):
               - UPDATE(기존 램프단축, old_lp 있음): EFCY = 기준 old_lp ÷ 변경 new_lp × 100
               - INSERT(신규라인 램프, old_lp 없음): EFCY = 같은 라인/품목 INSERT들의 최소(steady-state) LOAD_PER ÷ 해당 new_lp × 100
                 → 예 0.279/0.465=60, 0.279/0.349=80, 0.279/0.279=100 (60/80/100 램프곡선) */
            SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, START_DATE, END_DATE, opt_id, plan_id,
                   op, w_sdate, w_edate,
                   CONVERT(NUMERIC(5,2), ROUND(
                       CASE WHEN efcy_skip = 1
                                 THEN NULL   -- SOP Pull-in 이 "이 구간은 반영하지 마라" 고 찍은 행
                            WHEN given_efcy_f IS NOT NULL
                                 THEN given_efcy_f   -- ★ 지정값 그대로. 역산하지 않는다(GitLab #20)
                            WHEN old_lp_f IS NOT NULL
                                 THEN old_lp_f / new_lp_f * 100.0
                            WHEN op = 'INSERT'
                                 THEN MIN(CASE WHEN op='INSERT' THEN new_lp_f END)
                                        OVER (PARTITION BY DIVISION_ID, PLANT_ID, LINE_ID, ITEM_ID) / new_lp_f * 100.0
                            ELSE NULL   -- UPDATE인데 기준 old_lp 없음 → 산출 불가(기존 정책대로 제외)
                       END, 2)) AS EFCY,
                   efcy_skip
            FROM filled
            WHERE new_lp_f > 0                       -- 실제 LOAD_PER 있는 램프 세그먼트만
        )
        -- efcy 전체를 #rp_cand 로 보존 + 탈락사유(drop_reason) 계산 → 미반영(NOAPPLY) 로그 소스
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, START_DATE, END_DATE, EFCY, opt_id, plan_id,
               op,
               w_sdate,
               /* where 의 끝을 **변경 쪽과 같은 규약**으로 맞춘다. 라우팅 END 는 배타(다음 행의 시작)이고
                  램프업 END 는 포함이다 — 위 END_DATE 가 이미 -1 변환을 하므로 「기존」만 안 하면
                  한 줄 안에서 두 규약이 섞인다. 날짜가 아닌 값이면 손대지 않는다. */
               CASE WHEN w_edate > w_sdate AND TRY_CONVERT(DATETIME, w_edate) IS NOT NULL
                         THEN CONVERT(NVARCHAR(8), DATEADD(DAY, -1, CONVERT(DATETIME, w_edate)), 112)
                    ELSE w_edate END COLLATE DATABASE_DEFAULT AS w_edate,
               CASE WHEN COALESCE(ITEM_ID,N'')=N'' OR COALESCE(DIVISION_ID,N'')=N'' OR COALESCE(LINE_ID,N'')=N''
                         OR COALESCE(START_DATE,N'')=N'' OR COALESCE(END_DATE,N'')=N''
                         THEN N'DROP_BADKEY(DIVISION/LINE/ITEM/기간 누락)'
                    WHEN COALESCE(OPERATION_ID,N'')=N''
                         THEN N'DROP_NOOP(라인 미등록: SCP_OPMZ_LINE_OPERATION)'
                    WHEN EFCY IS NULL AND efcy_skip = 1
                         THEN N'SKIP_BY_CARD(지정 카드가 반영 제외로 표시한 구간)'
                    WHEN EFCY IS NULL
                         THEN N'DROP_NOEFCY(UPDATE인데 기준 old_lp 없음 - EFCY 산출불가)'
                    ELSE NULL END AS drop_reason
        INTO #rp_cand
        FROM efcy;

        -- 유효(drop_reason NULL)만 PK 그룹화(중복 제거, 동일 키 다건이면 보수적 최소 EFCY)하여 #rp 확정
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, START_DATE, END_DATE,
               MIN(EFCY) AS EFCY, MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id
        INTO #rp
        FROM #rp_cand
        WHERE drop_reason IS NULL
        GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, START_DATE, END_DATE;

        SET @RESOLVED = (SELECT COUNT(*) FROM #rp);   -- 산출 대상 건수 집계
        /* 6 종료: 반영 대상(#rp) 구성 완료. */

        IF OBJECT_ID('tempdb..#chg') IS NOT NULL DROP TABLE #chg;
        -- MERGE OUTPUT 를 담을 행단위 변경이력 버퍼(이후 SCM_SYS_LOG_BATCH 로 이관)
        CREATE TABLE #chg(
            op     nvarchar(10),    -- DELETE(6b 선-삭제) / INSERT / UPDATE
            rowkey nvarchar(300),   -- 반영 대상 키 문자열
            bef    nvarchar(100),   -- 변경 전 EFCY
            aft    nvarchar(100),   -- 변경 후 EFCY
            tag    nvarchar(150),   -- 출처 태그(SNRO/카드)
            /* 쪼갠 키 (2026-10-01, GitLab #35). 이 타겟 PK 는
               DIV·PLANT·LINE·OP·LINE_TYPE·ITEM·START_DATE·END_DATE 여덟이다.
               rowkey 문자열을 되파싱하지 않는 이유는 DDLY_CAPA step7c 와 같다 —
               ITEM_ID 에 구분자가 섞이면 조용히 깨지고, 라인별 조회에 어차피 컬럼이 필요하다. */
            k_div    nvarchar(30),
            k_plant  nvarchar(30),
            k_line   nvarchar(30),
            k_opn    nvarchar(30),
            k_ltype  nvarchar(30),
            k_item   nvarchar(100),
            k_sdate  nvarchar(8),
            k_edate  nvarchar(8)
        );

        /* 6b 시작: **선-삭제** — 반영 구간과 겹치는 기존 행을 먼저 지운다. (2026-09-18, GitLab #27 ②)
           ┌ 왜 필요한가 ───────────────────────────────────────────────────────────────────────
           │ 아래 MERGE 는 매칭 키 8개에 START_DATE·END_DATE 를 포함하고 `WHEN NOT MATCHED BY SOURCE`
           │ 가 없다. 그래서 **구간 경계가 바뀌면 새 행이 INSERT 되고 옛 행이 그대로 남는다.**
           │ 2026-09-15 끝 포함 규약 전환(END 를 하루 뺌)이 정확히 그 조건이다 —
           │     옛  20270501~20270511      새  20270501~20270510
           │ 둘 다 남으면 5/11 이 두 행에 걸린다. 반영 프로시저 넷 중 이 문제는 여기뿐이다
           │ (SOP_EOP 는 (1) 에서 먼저 지우고, NO_WORK 는 9e, DDLY_CAPA 는 키가 월이라 무관).
           ├ 무엇을 지우나 ─────────────────────────────────────────────────────────────────────
           │ 같은 좌표(DIV/PLANT/LINE/OP/LINE_TYPE/ITEM)에서 **이번에 반영할 구간과 겹치는** 기존 행.
           │ 겹침은 양쪽 다 포함 규약으로 본다(`기존.START <= 새.END AND 기존.END >= 새.START`).
           │ 이번에 쓸 바로 그 구간(키 완전 일치)은 남긴다 — MERGE 가 갱신하므로 지웠다 넣을 이유가 없다.
           ├ **한계(의도적)** ─────────────────────────────────────────────────────────────────
           │ 구간이 통째로 옮겨가 겹치지도 않는 경우는 여기서 못 지운다. 그걸 잡으려면 패치 where 의
           │ **원본 구간**(w_sdate·w_edate)을 #rp 까지 날라야 하는데, 그 CTE 체인은 SOP Pull-in(#20)이
           │ 지금 만지고 있어 이번 범위에서 건드리지 않았다. dev 실측(2026-09-18)상 그 형태의 고아는
           │ 0건이고, 실재하는 것은 규약 전환분이다.
           └ 멱등: 지울 게 없으면 0건이다. */
        DELETE ru
        OUTPUT N'DELETE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.OPERATION_ID, N'|', deleted.ITEM_ID, N'|',
                      deleted.START_DATE, N'~', deleted.END_DATE),
               CAST(deleted.EFCY AS nvarchar(100)),   -- 변경 전 EFCY
               N'DELETED',                             -- 변경 후 = 행 없음
               deleted.ATTRIBUTE9,
               deleted.DIVISION_ID, deleted.PLANT_ID, deleted.LINE_ID, deleted.OPERATION_ID,
               deleted.LINE_TYPE, deleted.ITEM_ID, deleted.START_DATE, deleted.END_DATE
        INTO #chg(op, rowkey, bef, aft, tag,
                  k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_sdate, k_edate)
        FROM dbo.SCP_OPMZ_RAMP_UP ru
        WHERE EXISTS (
                SELECT 1 FROM #rp s
                 WHERE s.DIVISION_ID  = ru.DIVISION_ID  AND s.PLANT_ID     = ru.PLANT_ID
                   AND s.LINE_ID      = ru.LINE_ID      AND s.OPERATION_ID = ru.OPERATION_ID
                   AND s.LINE_TYPE    = ru.LINE_TYPE    AND s.ITEM_ID      = ru.ITEM_ID
                   AND ru.START_DATE <= s.END_DATE      AND ru.END_DATE   >= s.START_DATE)
          AND NOT EXISTS (
                SELECT 1 FROM #rp s2
                 WHERE s2.DIVISION_ID = ru.DIVISION_ID  AND s2.PLANT_ID     = ru.PLANT_ID
                   AND s2.LINE_ID     = ru.LINE_ID      AND s2.OPERATION_ID = ru.OPERATION_ID
                   AND s2.LINE_TYPE   = ru.LINE_TYPE    AND s2.ITEM_ID      = ru.ITEM_ID
                   AND s2.START_DATE  = ru.START_DATE   AND s2.END_DATE     = ru.END_DATE);
        SET @DEL = @@ROWCOUNT;
        /* 6b 종료. */

        /* 7 시작: SCP_OPMZ_RAMP_UP 에 전체 PK 기준 MERGE(멱등) — 있으면 EFCY 갱신, 없으면 신규 삽입. */
        MERGE dbo.SCP_OPMZ_RAMP_UP AS tgt
        USING #rp AS s
           ON  tgt.DIVISION_ID  = s.DIVISION_ID     -- ↓ PK 8개 컬럼 전체 일치로 대상 행 식별
           AND tgt.PLANT_ID     = s.PLANT_ID
           AND tgt.LINE_ID      = s.LINE_ID
           AND tgt.OPERATION_ID = s.OPERATION_ID
           AND tgt.LINE_TYPE    = s.LINE_TYPE
           AND tgt.ITEM_ID      = s.ITEM_ID
           AND tgt.START_DATE   = s.START_DATE
           AND tgt.END_DATE     = s.END_DATE
        WHEN MATCHED THEN
            -- 기존 행: EFCY/유효여부/출처태그/감사컬럼 갱신 + DESC 전환(기존내용->카드사유(SNRO), NO_WORK 방식)
            UPDATE SET tgt.EFCY             = s.EFCY,
                       tgt.VALID_YN         = 'Y',
                       tgt.[DESC]           = dbo.FN_GET_SCP_OPMZ_DESC_HIST(tgt.[DESC],   -- 최신 시나리오로 전환(원본 보존, 멱등)
                                                               ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                                                       WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'RAMP_UP'
                                                                         AND ld.SEGMENT2=s.opt_id AND ld.VALID_YN=N'Y'), N'램프업 단축'), s.plan_id),
                       tgt.ATTRIBUTE9       = CONCAT(@SNRO_CD, N'/', s.opt_id),  -- 출처: 시나리오/카드
                       tgt.LAST_UPDATED_BY  = @uid,
                       tgt.LAST_UPDATE_DATE = GETDATE()
        WHEN NOT MATCHED THEN
            -- 신규 행 삽입: DESC=카드사유(SNRO)(기존 없음), 유효 'Y', 출처태그 기록
            INSERT (DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, START_DATE, END_DATE, EFCY, [DESC], VALID_YN,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, LINE_TYPE, ATTRIBUTE9)
            VALUES (s.DIVISION_ID, s.PLANT_ID, s.LINE_ID, s.OPERATION_ID, s.ITEM_ID, s.START_DATE, s.END_DATE, s.EFCY,
                    CONCAT(ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                   WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'RAMP_UP'
                                     AND ld.SEGMENT2=s.opt_id AND ld.VALID_YN=N'Y'), N'램프업 단축'), CONCAT(N' (', s.plan_id, N')')), 'Y',
                    @uid, GETDATE(), @uid, GETDATE(), s.LINE_TYPE, CONCAT(@SNRO_CD, N'/', s.opt_id))
        OUTPUT CASE WHEN deleted.ITEM_ID IS NULL THEN N'INSERT' ELSE N'UPDATE' END,  -- deleted 없으면 INSERT
               CONCAT(inserted.DIVISION_ID, N'|', inserted.PLANT_ID, N'|', inserted.LINE_ID, N'|',   -- rowkey 조립
                      inserted.OPERATION_ID, N'|', inserted.ITEM_ID, N'|',
                      inserted.START_DATE, N'~', inserted.END_DATE),
               CAST(deleted.EFCY  AS nvarchar(100)),   -- 변경 전 EFCY(INSERT 이면 NULL)
               CAST(inserted.EFCY AS nvarchar(100)),   -- 변경 후 EFCY
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID, inserted.OPERATION_ID,
               inserted.LINE_TYPE, inserted.ITEM_ID, inserted.START_DATE, inserted.END_DATE
        INTO #chg(op, rowkey, bef, aft, tag,
                  k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_sdate, k_edate);
        SET @AFF = @@ROWCOUNT;   -- MERGE 반영(INSERT+UPDATE) 총 건수

        -- 미반영(NOAPPLY) 로그: 카드 대상이지만 해석 단계에서 탈락(EFCY 산출불가/키 누락)한 건. MERGE는 유효행을 모두 반영하므로 미반영=탈락뿐.
        INSERT INTO #chg(op, rowkey, bef, aft, tag,
                         k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_sdate, k_edate)
        SELECT N'NOAPPLY',
               CONCAT(ISNULL(DIVISION_ID,N''), N'|', ISNULL(PLANT_ID,N''), N'|', ISNULL(LINE_ID,N''), N'|',
                      ISNULL(ITEM_ID,N''), N'|', ISNULL(START_DATE,N''), N'~', ISNULL(END_DATE,N'')),
               NULL, NULL, drop_reason,
               DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, START_DATE, END_DATE
        FROM #rp_cand
        WHERE drop_reason IS NOT NULL;
        SET @NOAPPLY = @@ROWCOUNT;

        /* 7c 시작: **반영 이력 상세 적재** (2026-10-01, GitLab #35)
                    `#chg` 가 기준정보 키 단위이므로 그대로 상세가 된다. 카드·계획·patch op·
                    「기존」 기간은 `#rp_cand` 에서 가져온다.

                    ┌ 조인이 둘인 이유 ─────────────────────────────────────────────────────────
                    │ 6b 선-삭제 행은 **지워진 옛 구간**이 키라 `#rp_cand` 의 새 구간과 날짜가
                    │ 다르다. 그래서 날짜까지 포함한 `metaK` 로는 안 걸린다. 좌표만 보는 `metaC`
                    │ 를 폴백으로 둔다 — 같은 좌표에 램프 구간이 여럿이면 대표 1건이다(수용).
                    └ 실패해도 반영은 유효해야 하므로 TRY/CATCH 로 감싼다(NO_WORK step10-b 규약).
                    `HIS_SEQ` 는 비워 두고 `PR_SCP_SNRO_MGE_MST_APPY` 가 채운다. */
        /* ── fail-soft 를 **실제로** 성립시킨다 (2026-10-02, 별도 검증 세션 지적) ───────────────
           종전에는 TRY/CATCH 만 둘렀는데, 이 프로시저 머리에 `SET XACT_ABORT ON` 이 있어
           **CATCH 가 돌아도 트랜잭션이 커밋 불가(XACT_STATE=-1)가 되고 뒤의 COMMIT 이 3930 으로
           죽는다.** 실측: ON 이면 `CATCH 실행 / XACT_STATE=-1 / COMMIT 3930`, OFF 면
           `CATCH 실행 / XACT_STATE=1 / COMMIT 성공`. 즉 상세 적재가 한 번 실패하면 **진짜
           기준정보 반영이 통째로 롤백**됐다 — 헤더에 적어 둔 「반영을 막지 않는다」가 거짓이었다.

           두 겹으로 닫는다.
             ① **시노님 존재 확인** — 없으면 아예 들어가지 않는다. 없는 오브젝트 참조는 같은
                스코프의 이름 해석 오류(208)라 TRY/CATCH 가 **못 잡고 배치가 즉사**한다.
                반입 순서가 거꾸로일 때(19 를 18 보다 먼저) 모든 반영이 죽던 자리다.
                분기를 안 타면 그 문장은 컴파일되지 않으므로 이 가드로 닫힌다.
             ② **`SET XACT_ABORT OFF`** 를 이 블록에서만 끈다. 끝나면 되돌린다 —
                CATCH 로 빠져도 아래 `SET ... ON` 은 실행된다(블록 밖이다).
           이 둘로 「상세가 실패해도 반영은 산다」가 비로소 참이 된다. */
        /* ⚠ 타입 인자를 주지 않는다. `OBJECT_ID(name,'U')` 는 **시노님을 못 잡아** 항상 NULL 이고
              (실측: 'U' → NULL / 'SN' → 955150448 / 무타입 → 955150448) 그러면 상세가 영영 0행이 된다. */
           IF OBJECT_ID('dbo.SCP_SNRO_PLAN_MST_APPY_D_SN') IS NOT NULL
        BEGIN
        SET XACT_ABORT OFF;
        BEGIN TRY
            ;WITH metaK AS (   -- 전체 키(좌표+구간)
                /* 좌표까지 전부 ISNULL 로 접는다 — 탈락행(DROP_BADKEY)은 좌표가 비고,
                   익명화 plan 은 PLANT 가 빈다. NULL 끼리는 조인이 안 붙어 카드·계획이 빈 채로 남았다. */
                SELECT ISNULL(DIVISION_ID,N'') AS DIVISION_ID, ISNULL(PLANT_ID,N'') AS PLANT_ID,
                       ISNULL(LINE_ID,N'') AS LINE_ID, ISNULL(OPERATION_ID,N'') AS OPERATION_ID,
                       ISNULL(LINE_TYPE,N'') AS LINE_TYPE, ISNULL(ITEM_ID,N'') AS ITEM_ID,
                       ISNULL(START_DATE,N'') AS START_DATE, ISNULL(END_DATE,N'') AS END_DATE,
                       MAX(op) AS op, MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id,
                       MIN(w_sdate) AS w_sdate, MAX(w_edate) AS w_edate
                FROM #rp_cand
                GROUP BY ISNULL(DIVISION_ID,N''), ISNULL(PLANT_ID,N''), ISNULL(LINE_ID,N''),
                         ISNULL(OPERATION_ID,N''),
                         ISNULL(LINE_TYPE,N''), ISNULL(ITEM_ID,N''),
                         ISNULL(START_DATE,N''), ISNULL(END_DATE,N'')
            ),
            metaC AS (         -- 좌표만 — 6b 선-삭제 행 폴백
                SELECT ISNULL(DIVISION_ID,N'') AS DIVISION_ID, ISNULL(PLANT_ID,N'') AS PLANT_ID,
                       ISNULL(LINE_ID,N'') AS LINE_ID, ISNULL(OPERATION_ID,N'') AS OPERATION_ID,
                       ISNULL(LINE_TYPE,N'') AS LINE_TYPE, ISNULL(ITEM_ID,N'') AS ITEM_ID,
                       MAX(op) AS op, MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id,
                       MIN(w_sdate) AS w_sdate, MAX(w_edate) AS w_edate
                FROM #rp_cand
                GROUP BY ISNULL(DIVISION_ID,N''), ISNULL(PLANT_ID,N''), ISNULL(LINE_ID,N''),
                         ISNULL(OPERATION_ID,N''),
                         ISNULL(LINE_TYPE,N''), ISNULL(ITEM_ID,N'')
            )
            INSERT INTO dbo.SCP_SNRO_PLAN_MST_APPY_D_SN
                (SCP_SNRO_ID, TGT_TABLE,
                 DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID,
                 KEY_DATE_FROM, KEY_DATE_TO, KEY_TYPE,
                 BEF_DATE_FROM, BEF_DATE_TO, AFT_DATE_FROM, AFT_DATE_TO,
                 OP, APPLY_STATUS, VALUE_NAME, BEF_VALUE, AFT_VALUE,
                 NO_WORK_TYPE, CAUSE, DETAIL,
                 SCP_OPT_ID, DTL_SEQ, PLAN_ID, CREATED_BY, CREATION_DATE)
            SELECT @SNRO_CD COLLATE DATABASE_DEFAULT,
                   N'SCP_OPMZ_RAMP_UP',
                   c.k_div   COLLATE DATABASE_DEFAULT,
                   c.k_plant COLLATE DATABASE_DEFAULT,
                   c.k_line  COLLATE DATABASE_DEFAULT,
                   c.k_opn   COLLATE DATABASE_DEFAULT,
                   c.k_ltype COLLATE DATABASE_DEFAULT,
                   c.k_item  COLLATE DATABASE_DEFAULT,
                   c.k_sdate COLLATE DATABASE_DEFAULT,      -- 그 줄이 가리키는 기준정보 키(조회 축)
                   c.k_edate COLLATE DATABASE_DEFAULT,
                   NULL,                                    -- KEY_TYPE: SOP_EOP 전용
                   /* 「기존」 — 6b 선-삭제 행은 **지워진 그 구간**이 곧 기존이다.
                      나머지는 patch 의 where 기간이고, patch op 가 INSERT(신규 라인 램프)면 기존이 없다. */
                   CASE WHEN c.op = N'DELETE' THEN c.k_sdate COLLATE DATABASE_DEFAULT
                        WHEN COALESCE(mk.op, mc.op) = N'INSERT' THEN NULL
                        ELSE COALESCE(mk.w_sdate, mc.w_sdate) COLLATE DATABASE_DEFAULT END,
                   CASE WHEN c.op = N'DELETE' THEN c.k_edate COLLATE DATABASE_DEFAULT
                        WHEN COALESCE(mk.op, mc.op) = N'INSERT' THEN NULL
                        ELSE COALESCE(mk.w_edate, mc.w_edate) COLLATE DATABASE_DEFAULT END,
                   /* 「변경」 — 그 줄이 실제로 쓴 구간. 삭제 행은 남은 게 없고,
                      미반영 행은 쓴 적이 없으니 둘 다 비운다. */
                   CASE WHEN c.op IN (N'DELETE', N'NOAPPLY') THEN NULL ELSE c.k_sdate COLLATE DATABASE_DEFAULT END,
                   CASE WHEN c.op IN (N'DELETE', N'NOAPPLY') THEN NULL ELSE c.k_edate COLLATE DATABASE_DEFAULT END,
                   ISNULL(COALESCE(mk.op, mc.op), c.op) COLLATE DATABASE_DEFAULT,
                   /* 상태가 셋이다(2026-10-02). `SKIP_BY_CARD` 는 **실패가 아니라 정상 동작**이라
                      빨간 미반영과 섞으면 「봐야 할 것」이 흐려진다 — SOP Pull-in 이 SOP 를 당기면서
                      그 날짜를 품던 라우팅 행의 시작일만 옮긴 줄이고(효율은 한 칸도 안 바뀐다),
                      그 줄로 `APPLY_SOP_EOP` 가 SOP 를 옮긴다. 한 조각의 양면이다.
                      **이 판정은 여기(DB)서 한다.** 화면이 사유 문자열 앞머리를 맞추게 두면
                      이 문구를 고치는 순간 조용히 미반영으로 돌아간다. 사유는 바로 위 `#rp_cand`
                      가 쓴 것이라 같은 파일 안에서 짝이 맞는다.
                      ⚠ 프로시저의 `@NOAPPLY` 카운터는 그대로 둔다(로그 호환) — 그래서
                      `NOAPPLY=1` 인 실행이 상세에서는 `SKIPPED` 1행으로 보일 수 있다. */
                   CASE WHEN c.op <> N'NOAPPLY' THEN N'APPLIED'
                        WHEN c.tag LIKE N'SKIP[_]BY[_]CARD%' THEN N'SKIPPED'
                        ELSE N'NOAPPLY' END,
                   N'EFCY',                                 -- 이 타겟이 바꾸는 값은 효율(%) 하나다
                   /* 값도 날짜와 **같은 기준**으로 가른다(2026-10-02). 종전에는 날짜만 patch op 로
                      가르고 값은 DB 가 본 것을 그대로 썼다 — 그래서 `INSERT` 요청인데 DB 에선
                      기존 행이 있어 갱신된 줄에서 **기존 날짜는 비고 기존 값만 차는** 어긋남이
                      생겼다(2026-10-02 화면 캡처). 「기존/변경」은 요청의 전후로 읽는 칸이고,
                      DB 가 실제로 한 일은 `DETAIL` 의 `결과=` 가 말한다.
                      `DELETED` 는 값이 아니라 상태라 넣지 않는다 — `OP`·`CAUSE` 가 말한다. */
                   CASE WHEN COALESCE(mk.op, mc.op) = N'INSERT' THEN NULL ELSE c.bef COLLATE DATABASE_DEFAULT END,
                   CASE WHEN c.aft COLLATE DATABASE_DEFAULT = N'DELETED' THEN NULL ELSE c.aft COLLATE DATABASE_DEFAULT END,
                   NULL,                                    -- NO_WORK_TYPE: 비조업 전용
                   CASE WHEN c.op = N'DELETE' THEN N'DELETE' ELSE NULL END,   -- 변화를 만든 주체
                   LEFT(CASE WHEN c.op = N'NOAPPLY'
                             THEN c.tag COLLATE DATABASE_DEFAULT
                             ELSE CONCAT(N'결과=', c.op COLLATE DATABASE_DEFAULT)
                        END, 500),
                   ISNULL(COALESCE(mk.opt_id, mc.opt_id), N'') COLLATE DATABASE_DEFAULT,
                   NULL,
                   COALESCE(mk.plan_id, mc.plan_id) COLLATE DATABASE_DEFAULT,
                   @uid,
                   GETDATE()
            FROM #chg c
            LEFT JOIN metaK mk
                ON  mk.DIVISION_ID  = ISNULL(c.k_div,   N'') AND mk.PLANT_ID = ISNULL(c.k_plant, N'')
                AND mk.LINE_ID      = ISNULL(c.k_line,  N'') AND mk.OPERATION_ID = ISNULL(c.k_opn, N'')
                AND mk.LINE_TYPE    = ISNULL(c.k_ltype, N'') AND mk.ITEM_ID = ISNULL(c.k_item, N'')
                AND mk.START_DATE   = ISNULL(c.k_sdate, N'') AND mk.END_DATE = ISNULL(c.k_edate, N'')
            LEFT JOIN metaC mc
                ON  mc.DIVISION_ID  = ISNULL(c.k_div,   N'') AND mc.PLANT_ID = ISNULL(c.k_plant, N'')
                AND mc.LINE_ID      = ISNULL(c.k_line,  N'') AND mc.OPERATION_ID = ISNULL(c.k_opn, N'')
                AND mc.LINE_TYPE    = ISNULL(c.k_ltype, N'') AND mc.ITEM_ID = ISNULL(c.k_item, N'');
        END TRY
        BEGIN CATCH
            BEGIN TRY
                DECLARE @dtl_err nvarchar(200) = LEFT(ERROR_MESSAGE(), 200);
                SET @LOG_DT = GETDATE();
                EXEC dbo.PR_SCM_SYS_LOG_BATCH
                     @p_program_name = N'PR_SCP_OPMZ_APPLY_RAMP_UP',
                     @p_log_type     = N'WARN',
                     @p_log_count    = 0,
                     @p_log_message  = N'반영 이력 상세 적재 실패(반영은 유효)',
                     @p_description  = @dtl_err,
                     @p_event_date   = @LOG_DT;
            END TRY
            BEGIN CATCH
            END CATCH
        END CATCH
        SET XACT_ABORT ON;   -- ② 되돌린다. 이 아래부터는 다시 원래 규약이다
        END
        /* 7c 종료. */

        -- 행단위 변경이력 적재: 키/전후 EFCY/출처를 ATTRIBUTE 컬럼으로 남겨 추적성 확보
        INSERT INTO dbo.SCM_SYS_LOG_BATCH
            (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7)
        SELECT N'PR_SCP_OPMZ_APPLY_RAMP_UP',
               op,
               1,
               CONCAT(N'RAMP_UP ', op),                                                         -- LOG_MESSAGE: 테이블 op 라벨
               CONCAT(N'key=', rowkey, N' | EFCY ', ISNULL(bef,N'-'), N'->', ISNULL(aft,N'-')),  -- DESCRIPTION: key + 변경값
               GETDATE(), GETDATE(), @uid, GETDATE(), @uid,   -- 2026-09-30: 감사칸 둘을 비우지 않는다
               N'SCP_OPMZ_RAMP_UP', op, @SNRO_CD, tag, rowkey, bef, aft
        FROM #chg;
        /* 7 종료: MERGE 반영 완료. */

        /* 8 시작: 커밋 — 내가 트랜잭션을 소유한 경우에만. */
        IF @START_TRAN = 1 COMMIT;
        /* 8 종료. */

        /* 9 시작: 성공 로그 적재(반영건수/산출건수 요약 포함). */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = ISNULL(@AFF,0);
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', N'CRD-00105/00103/00008',
                                        N'; TARGET=', N'SCP_OPMZ_RAMP_UP; NOAPPLY=' + CAST(@NOAPPLY AS nvarchar(10)),
                                        N'; UPD=', @AFF, N' DEL=', @DEL, N' RESOLVED=', @RESOLVED), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_RAMP_UP',
                 @p_log_type     = N'END',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = N'PR_SCP_OPMZ_APPLY_RAMP_UP 완료',
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        /* 9 종료. */

        /* 10 시작: 결과 요약 반환(@RETURN_RESULT_YN='Y' 일 때만). */
        IF @RETURN_RESULT_YN = N'Y'
            SELECT @SNRO_CD AS SNRO_CD,
                   N'Y'                       AS SUCCESS_YN,
                   N'SUCCESS'                 AS RESULT_CODE,
                   N'램프업(RAMP_UP) 반영 완료' AS RESULT_MESSAGE,
                   @AFF      AS AFFECTED_ROWS,     -- MERGE 반영건수
                   @NOAPPLY  AS NOAPPLY_ROWS,      -- 미반영(해석탈락)건수 — 로그로 상세 확인
                   @RESOLVED AS RESOLVED_ROWS;     -- 산출대상건수
        /* 10 종료. */
    END TRY
    BEGIN CATCH
        /* 11 시작: 오류 처리 — (내가 소유한 트랜잭션이면) 롤백 → 오류 로그 → 예외 재전파(THROW). */
        IF @START_TRAN = 1 AND XACT_STATE() <> 0
            ROLLBACK;
        SET @ERR_MSG = ERROR_MESSAGE();
        IF @START_TRAN = 1   /* 중첩 호출 시 에러로그는 트랜잭션 소유자(오케스트레이터)가 남김 */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', N'CRD-00105/00103/00008',
                                        N'; TARGET=', N'SCP_OPMZ_RAMP_UP'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_RAMP_UP',
                 @p_log_type     = N'ERROR',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = @ERR_MSG,
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        THROW;   -- 원본 오류를 상위(오케스트레이터)로 재전파
        /* 11 종료. */
    END CATCH;
END
