
/* ---- 2) 코팅증속 ---------------------------------------------------------------------------- */
-- ▼ PR_SCP_OPMZ_APPLY_DDLY_CAPA
/*
 * Program ID   : PR_SCP_OPMZ_APPLY_DDLY_CAPA
 * Description  : 시나리오 라우팅 patch → SCP_OPMZ_DDLY_CAPA(CAPA/M_MIN) 반영
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_DDLY_CAPA
    @SNRO_CD          NVARCHAR(50),
    @USER_ID          NVARCHAR(200) = NULL,
    @OPT_KEY_VAL_ID   NVARCHAR(200) = NULL,   -- 콤마구분 카드 목록(예 'CRD-00102,CRD-00104'); NULL=전체
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    /*===============================================================================================
      프로시저 : dbo.PR_SCP_OPMZ_APPLY_DDLY_CAPA
      -----------------------------------------------------------------------------------------------
      [목적]
        시나리오(@SNRO_CD)에 포함된 "코팅증속" 카드 패치를 읽어, 일별 생산능력(DDLY_CAPA)
        기준정보의 CAPA(생산능력) 값을 시나리오가 지정한 새 속도(LOAD_PER)에 맞춰 재계산/갱신한다.

      [소스]
        dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN.SCP_OPT_PTCH_JSON_CTN (시나리오 패치 JSON)
          - 대상 테이블(JSON $.table) = SCP_OPT_ENG_ROUTING_RESOURCE
          - op = UPDATE 만 처리
          - 카드 = DDLY_CAPA 계열 : FN_GET_SCP_OPMZ_OPT_TARGET(opt_id,'DDLY_CAPA')=1 로 확인.
                   코팅속도(LOAD_PER)를 바꾸는 전극(EE) 카드 전부: CRD-00102(코팅증속)·CRD-00103(신규라인)·
                   CRD-00104(공휴일가동)·CRD-00101(주말가동). (2026-07-07: 코팅증속은 00102 전용이 아니라
                   신규라인/공휴일/주말 카드에도 섞여 들어오므로 대상 확대.)
                   ※ 자기방어: 아래 resolved 에서 WHERE TRY_CAST(new_lp AS float)>0 로 실제 LOAD_PER가 있는
                     행만 반영 → 속도 변경이 없는 카드가 섞여도 무해한 no-op(잘못 기입 위험 없음).
                     기존 행은 UPDATE, 없는 행은 INSERT(같은 라인 형제 행에서 LANE/WIDE_YN/PRDN_OPER_RT 복사,
                     M_MIN만 재계산). 형제 행조차 없으면(WIDE_YN 미등록 신규 라인) 값 지어내지 않고 SKIP+로그.

      [타겟]
        dbo.SCP_OPMZ_DDLY_CAPA : 기존 행 UPDATE + 없는 (라인/아이템/월)은 INSERT(같은 라인 형제 행에서 물리속성 복사, 2026-07-07). **사업부별 갱신 컬럼 상이**:
          - 조립(DIVISION_ID='40'): CAPA 컬럼
          - 전극(DIVISION_ID='EE', 코팅): M_MIN 컬럼(코팅속도 m/min, nvarchar)

      [핵심 변환식] — 사업부 분기 (2026-07-06)
        · 조립: CAPA  = 86400 / ( 새 LOAD_PER × (PRDN_OPER_RT/100) )                        (정방향 TACT=86400/(CAPA×rt) 역)
        · 전극: M_MIN = 60    / ( 새 LOAD_PER × (PRDN_OPER_RT/100) × LANE × (WIDE_YN='Y'?2:1) ) (정방향 TACT=60/(M_MIN×rt/100)/(LANE×wide) 역, EE_INPUT 기준)
          - PRDN_OPER_RT/LANE/WIDE_YN 는 "갱신 대상 행 자체"의 값을 사용(rt 0이면 100 보정, LANE 0이면 NULL).
          - 각 사업부는 자기 컬럼만 갱신, 반대 컬럼은 원값 유지.
          - 새 LOAD_PER = 패치 set 값. 카드 정의의 LOAD_PER×0.8은 이미 set 값에 반영되어 있어
            엔진(원본 카드 정의)은 별도로 조회하지 않는다.

      [카드]
        CRD-00102 (코팅증속) → 카드타겟 코드 DDLY_CAPA

      [파라미터]
        @SNRO_CD          : (필수) 시나리오 코드. 패치 조회 키.
        @USER_ID          : (선택) 실행자. NULL이면 SUSER_SNAME() 사용.
        @RETURN_RESULT_YN : (선택, 기본 'Y') 'Y'이면 처리 결과 요약 리절트셋 반환.

      [단계 개요]
        1  실행 옵션 설정(NOCOUNT/XACT_ABORT)
        2  필수 입력값 검증
        3  런타임 변수 선언
        4  시작 로그 적재(트랜잭션 밖)
        5  트랜잭션 시작(소유자일 때만)
        6  패치 파싱 → 반영 대상 집합 #dc 구성
        7  SCP_OPMZ_DDLY_CAPA.CAPA UPDATE + 행단위 이력(#chg) 적재
        8  커밋(소유자일 때만)
        9  성공 로그 적재
        10 결과 요약 반환
        11 (CATCH) 롤백 → 오류 로그 → 예외 재전파

      [트랜잭션/로그 규약]
        - @START_TRAN=1(진입 시 @@TRANCOUNT=0)일 때만 이 프로시저가 트랜잭션을 소유·커밋·롤백.
          중첩 호출(오케스트레이터가 이미 트랜잭션 보유)이면 합류만 하고 커밋/롤백은 소유자에 위임.
        - TRY/CATCH 로 감싸고, CATCH는 THROW로 원 예외를 상위에 재전파.
        - 로그: PR_SCM_SYS_LOG_BATCH(START/SUCCESS/ERROR 요약) + #chg 기반 행단위 이력
          (SCM_SYS_LOG_BATCH.ATTRIBUTE1~8 에 대상테이블/op/시나리오/태그/키/변경전/변경후/환산자(CV.VAL) 기록).
        - compat120 JSON 헬퍼(FN_SCP_JSON_*) 사용, 문자열 비교는 COLLATE DATABASE_DEFAULT 로 정렬 규칙 통일.
    ===============================================================================================*/

    /* 1 시작: 기본 실행 옵션.
              - SET NOCOUNT ON  : "N행 영향" 메시지 억제(클라이언트로 불필요한 done 토큰 미전송).
              - SET XACT_ABORT ON : 런타임 오류 발생 시 트랜잭션 전체를 즉시 중단/롤백 대상으로 처리. */
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    /* 1 종료. */

    /* 2 시작: 필수 입력값(시나리오 코드) 검증.
              - 공백만 있는 값도 NULLIF+LTRIM/RTRIM 으로 걸러 빈 값으로 간주.
              - 누락 시 51020 오류를 THROW 하여 이후 로직 진입 자체를 차단. */
    IF NULLIF(LTRIM(RTRIM(@SNRO_CD)), N'') IS NULL
        THROW 51020, 'SNRO_CD IS REQUIRED.', 1;
    /* 2 종료. */

    /* 3 시작: 런타임 변수 선언.
              - @uid        : 이력/로그에 남길 실행자(파라미터 없으면 로그인 계정).
              - @START_TRAN : 이 프로시저가 트랜잭션 소유자인지 여부(진입 시 @@TRANCOUNT=0 → 1).
              - @UPD        : CAPA UPDATE 반영 행수.
              - @RESOLVED   : 패치에서 도출된 반영 대상(#dc) 행수.
              - @ERR_MSG / @LOG_* : 오류 메시지 및 로그 적재용 임시값. */
    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @UPD INT = 0, @RESOLVED INT = 0, @INS INT = 0, @NOAPPLY INT = 0;
    DECLARE @ERR_MSG  NVARCHAR(2048);
    DECLARE @LOG_DT   DATETIME;
    DECLARE @LOG_CNT  INT;
    DECLARE @LOG_DESC NVARCHAR(500);
    /* 3 종료. */

    /* 4 시작: 시작 로그 적재(트랜잭션 밖 → 롤백돼도 보존).
              - 아직 BEGIN TRAN 전이므로 이 START 로그는 이후 롤백에 영향받지 않고 남는다.
              - @p_description 에 시나리오/카드/타겟 요약을 500자로 잘라 기록. */
    BEGIN
        SET @LOG_DT  = GETDATE();
        SET @LOG_CNT = 0;
        SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                    N'; CARD=', N'CRD-00102',
                                    N'; TARGET=', N'SCP_OPMZ_DDLY_CAPA'), 500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH
             @p_program_name = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
             @p_log_type     = N'START',
             @p_log_count    = @LOG_CNT,
             @p_log_message  = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA 시작',
             @p_description  = @LOG_DESC,
             @p_event_date   = @LOG_DT;
    END;
    /* 4 종료. */

    -- 재실행 대비: 이전 세션에서 남았을 수 있는 임시테이블 정리
    IF OBJECT_ID('tempdb..#dc') IS NOT NULL DROP TABLE #dc;
    IF OBJECT_ID('tempdb..#resolved') IS NOT NULL DROP TABLE #resolved;
        IF OBJECT_ID('tempdb..#cand') IS NOT NULL DROP TABLE #cand;

    BEGIN TRY
        /* 5 시작: 내가 소유한 경우에만 트랜잭션 시작.
                  - @START_TRAN=1(진입 시 열린 트랜잭션 없음)일 때만 BEGIN TRAN.
                  - 오케스트레이터 내부 호출이면 이미 열린 트랜잭션에 합류(별도 BEGIN 안 함). */
        IF @START_TRAN = 1 BEGIN TRAN;
        /* 5 종료. */

        /* 6 시작: 코팅증속 카드(CRD-00102) ROUTING_RESOURCE UPDATE 패치 파싱 → 반영 대상(#dc).
                   - 새 LOAD_PER(set)만 사용(카드 정의 LOAD_PER×0.8는 이미 set값에 반영됨, 엔진 미조회)
                   - 키: ROUTING_ID(SITE::ITEM::STAGE::LINE::일자)를 FN_SPLIT_VAL로 분해
                   - YYYYMM = START_DATE 앞 6자리
                   - 동일 (DIVISION/PLANT/LINE/ITEM/YYYYMM) 다건이면 MIN(LOAD_PER) = 가장 빠른 속도 채택

                   [CTE 파이프라인]
                     patch    : 시나리오 패치 JSON을 op/where(wf)/set(sf) 단위로 펼침(대상 테이블·카드 필터).
                     kv       : 한 패치(pseq) 내 where/set 필드를 컬럼별 값으로 피벗(plan_id/routing_id/new_lp/s_sdate).
                     resolved : 키 분해 및 DIVISION/PLANT/LINE/ITEM/YYYYMM/new_lp 로 정규화.
                     최종 SELECT INTO #dc : 그룹핑 후 MIN(new_lp)로 대표 속도 1건 확정. */
        ;WITH patch AS (
            -- 시나리오 패치 JSON 배열을 항목 단위로 펼쳐 op / where(wf) / set(sf) 조각 추출
            SELECT m.SCP_OPT_ID COLLATE DATABASE_DEFAULT AS opt_id,
                   J.[KEY]                              AS pseq,   -- 패치 항목 순번(같은 패치 묶음 식별)
                   UPPER(JSON_VALUE(J.[VALUE], '$.op')) AS op,     -- 연산 유형(여기서는 UPDATE만 사용)
                   JSON_QUERY(J.[VALUE], '$.where')     AS wf,     -- where 절 조각(대상 식별 컬럼/값)
                   JSON_QUERY(J.[VALUE], '$.set')       AS sf      -- set 절 조각(변경할 컬럼/값)
            FROM dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN m
            CROSS APPLY dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(m.SCP_OPT_PTCH_JSON_CTN) J
            WHERE m.SCP_SNRO_ID = @SNRO_CD
              AND ISJSON(m.SCP_OPT_PTCH_JSON_CTN) = 1                                                   -- 유효 JSON만
              AND UPPER(PARSENAME(JSON_VALUE(J.[VALUE], '$.table'), 1)) = N'SCP_OPT_ENG_ROUTING_RESOURCE' -- 대상 테이블 한정(스키마 제거 후 테이블명 비교)
              AND dbo.FN_GET_SCP_OPMZ_OPT_TARGET(m.SCP_OPT_ID, N'DDLY_CAPA') = 1                       -- 코팅증속(DDLY_CAPA) 카드만
              AND (@OPT_KEY_VAL_ID IS NULL
                   OR N',' + REPLACE(@OPT_KEY_VAL_ID, N' ', N'') + N',' LIKE N'%,' + m.SCP_OPT_ID COLLATE DATABASE_DEFAULT + N',%')  -- 특정 카드 목록 스코프(콤마구분, 옵션)
        ),
        kv AS (
            -- 한 패치(pseq) 안의 where/set 필드들을 컬럼별 단일 값으로 피벗
            SELECT p.pseq,
                   p.op,
                   MAX(CASE WHEN f.col='PLAN_ID'                  THEN f.val END) COLLATE DATABASE_DEFAULT AS plan_id,    -- DIVISION 보완용 계획 ID
                   MAX(CASE WHEN f.col='ROUTING_ID'               THEN f.val END) COLLATE DATABASE_DEFAULT AS routing_id, -- 키 분해 원본(SITE::ITEM::STAGE::LINE::일자)
                   MAX(CASE WHEN f.src='S' AND f.col='LOAD_PER'   THEN f.val END) COLLATE DATABASE_DEFAULT AS new_lp,     -- set의 새 LOAD_PER(새 속도)
                   MAX(CASE WHEN f.src='S' AND f.col='START_DATE' THEN f.val END) COLLATE DATABASE_DEFAULT AS s_sdate,    -- set의 시작일(YYYYMM 우선 소스)
                   -- 2026-10-01(#35): **끝 월**을 알기 위해 END_DATE 를 받는다. 종전엔 피벗에 없어서
                   --   여러 달 구간이 **첫 달만** 반영됐다(dev 실측: 2개월 이상 조각 435건,
                   --   CRD-00008 신규라인 408 · CRD-00103 15 · CRD-00401 11 · 보강 1).
                   MAX(CASE WHEN f.src='S' AND f.col='END_DATE'   THEN f.val END) COLLATE DATABASE_DEFAULT AS s_edate,
                   MAX(CASE WHEN f.src='W' AND f.col='END_DATE'   THEN f.val END) COLLATE DATABASE_DEFAULT AS w_edate,
                   MAX(CASE WHEN f.col='RESOURCE_ID'              THEN f.val END) COLLATE DATABASE_DEFAULT AS resource_id, -- 자원 키(SITE::LINE) — AUTO_ROUTING_ID 시 site/line 도출용
                   MAX(p.opt_id) COLLATE DATABASE_DEFAULT AS opt_id
            FROM patch p
            CROSS APPLY (
                -- where(src='W')와 set(src='S') 조각을 각각 (col,val) 쌍으로 풀어 UNION
                SELECT 'W' AS src, oc.col, oc.val
                FROM dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(p.wf) a
                CROSS APPLY (
                    -- 조각 오브젝트에서 column/value 키를 각각 추출
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
            WHERE p.op IN ('UPDATE','INSERT')     -- UPDATE + INSERT(실 routing_id) 반영. LOAD_PER 있는 행만 아래 자기방어로 통과
            GROUP BY p.opt_id, p.pseq, p.op
        )
        -- resolved: 피벗값을 실제 매칭 키(DIVISION/PLANT/LINE/ITEM/YYYYMM)와 새 속도로 정규화
        --
        -- ★ CTE 가 아니라 임시테이블로 받는다(2026-09-03). 아래 filled 이 이 결과를 자기참조하는데,
        --   CTE 는 실체화되지 않아 바깥 행마다 이 블록을 통째로 다시 계산한다. 그 안에 JSON 파싱과
        --   FN_SPLIT_VAL 6회·SCM_MST_SITE 서브쿼리·FN_GET_SCP_OPMZ_PLAN_SEQ 가 들어 있어
        --   442행짜리 patch 에서 442² × 함수 8회가 됐다 — dev 실측 54분+(미완).
        --   한 번만 계산해 #resolved 에 담으면 2.6초다. 계산식·필터·조인은 그대로다.
        SELECT
                -- DIVISION: 계획 마스터(SCP_OPMZ_PLAN_M) 값 우선, 없으면 plan_id의 2번째 '_' 세그먼트에서 추출
                COALESCE(
                    pm.DIVISION_ID,
                    SUBSTRING(kv.plan_id,
                              CHARINDEX('_',kv.plan_id)+1,
                              CHARINDEX('_',kv.plan_id,CHARINDEX('_',kv.plan_id)+1)-CHARINDEX('_',kv.plan_id)-1)
                ) AS DIVISION_ID,
                -- PLANT: SCM_SITE_ID→PLANT_ID 권위 매핑(SCM_MST_SITE). 문자열 절단은 _40-P 류 사이트에서 틀림
                (SELECT MAX(sm.PLANT_ID) FROM dbo.SCM_MST_SITE sm
                 WHERE sm.SCM_SITE_ID = st.site COLLATE DATABASE_DEFAULT AND sm.VALID_YN='Y') AS PLANT_ID,
                st.line AS LINE_ID,                             -- LINE : routing에 '::' 있으면 seg4, 없으면(AUTO) RESOURCE_ID(SITE::LINE)에서
                st.site AS SITE_ID,                             -- SITE(SCM_SITE_ID) : 환산자(FN_GET_SCP_OPMZ_ITEM_CONV) 조회용
                CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg2 ELSE NULL END AS ITEM_ID,  -- ITEM(seg2). AUTO는 아래 filled에서 형제로 보충
                LEFT(COALESCE(kv.s_sdate, sp.seg5), 6) AS YYYYMM, -- 시작월 = set START_DATE(없으면 5번째 세그먼트 일자) 앞 6자리
                COALESCE(kv.s_edate, kv.w_edate) AS END_DATE_RAW, -- 2026-10-01(#35): 끝 월 산출용(배타). 아래 월 전개가 쓴다
                TRY_CAST(kv.new_lp AS float) AS new_lp,         -- 새 LOAD_PER(숫자 변환)
                kv.opt_id,
                dbo.FN_GET_SCP_OPMZ_PLAN_SEQ(kv.plan_id, @SNRO_CD) AS plan_id,  -- 채번 계획ID(base→base_S00x). ATTRIBUTE1 이력 꼬리용
                kv.op AS op                                    -- 2026-10-01(#35): 반영 이력 상세의 OP 칸. UPDATE/INSERT 둘 다 온다
        INTO #resolved_raw
        FROM kv
            CROSS APPLY (
                -- ROUTING_ID(SITE::ITEM::STAGE::LINE::일자)를 '::' 기준 세그먼트로 분해
                SELECT dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',1) COLLATE DATABASE_DEFAULT AS seg1,  -- SITE
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',2) COLLATE DATABASE_DEFAULT AS seg2,  -- ITEM
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',4) COLLATE DATABASE_DEFAULT AS seg4,  -- LINE
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',5) COLLATE DATABASE_DEFAULT AS seg5   -- 일자
            ) sp
            CROSS APPLY (
                -- site/line 결정: routing에 '::' 있으면 seg1/seg4, 없으면(AUTO_ROUTING_ID) RESOURCE_ID(SITE::LINE)에서 도출
                SELECT CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg1
                            ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',1) COLLATE DATABASE_DEFAULT END AS site,
                       CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg4
                            ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',2) COLLATE DATABASE_DEFAULT END AS line
            ) st
        LEFT JOIN dbo.SCP_OPMZ_PLAN_M pm ON pm.OPMZ_PLAN_ID = kv.plan_id  -- DIVISION 보완 조인
        -- (new_lp<=0 필터는 아래 #cand의 drop_reason 계산으로 이동 — 미반영 로그를 위해 탈락행도 보존)
        ;

        /* 2-b: **월 단위로 전개한다.** (2026-10-01, GitLab #35)
           ┌ 왜 ────────────────────────────────────────────────────────────────────────────────
           │ 이 타겟 키는 `YYYYMM`(월)인데 종전에는 **시작일의 월 하나**만 만들었다
           │ (`LEFT(COALESCE(s_sdate, seg5), 6)`). 그래서 여러 달에 걸친 구간이 **첫 달만**
           │ 반영됐다 — 신규 라인이 7·9개월에 걸쳐 가동되는데 첫 달만 CAPA/M_MIN 이 바뀌었다.
           │ dev 실측: 2개월 이상 조각 435건(CRD-00008 408 · CRD-00103 15 · CRD-00401 11 · 보강 1).
           ├ 끝 월 — 라우팅 `END_DATE` 는 **배타**다(2026-09-15 RAMP_UP 끝 포함 규약 전환이 그 근거).
           │ 그래서 `END - 1일` 의 월까지 전개한다. `END=20270101` 이면 12월까지 = **한 달**이고,
           │ 이 경우가 코팅증속(CRD-00102) 1568건 전부다 — 그 카드는 종전에도 멀쩡했다.
           └ 끝 월 정보가 없거나 범위가 이상하면 **시작월 하나**만 — 종전과 같다. */
        IF OBJECT_ID('tempdb..#dm') IS NOT NULL DROP TABLE #dm;
        SELECT TOP (121) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
        INTO #dm
        FROM sys.all_objects;

        IF OBJECT_ID('tempdb..#resolved') IS NOT NULL DROP TABLE #resolved;
        SELECT r.DIVISION_ID, r.PLANT_ID, r.LINE_ID, r.SITE_ID, r.ITEM_ID,
               CONVERT(char(6), DATEADD(month, d.n, TRY_CONVERT(date, r.YYYYMM + '01', 112)), 112)
                   COLLATE DATABASE_DEFAULT AS YYYYMM,
               r.new_lp, r.opt_id, r.plan_id, r.op
        INTO #resolved
        FROM #resolved_raw r
        JOIN #dm d
          ON d.n <= CASE
                      WHEN TRY_CONVERT(date, r.YYYYMM + '01', 112) IS NOT NULL
                       AND TRY_CONVERT(date, r.END_DATE_RAW, 112) IS NOT NULL
                       AND DATEDIFF(month, TRY_CONVERT(date, r.YYYYMM + '01', 112),
                                           DATEADD(day, -1, TRY_CONVERT(date, r.END_DATE_RAW, 112)))
                           BETWEEN 0 AND 120
                      THEN DATEDIFF(month, TRY_CONVERT(date, r.YYYYMM + '01', 112),
                                           DATEADD(day, -1, TRY_CONVERT(date, r.END_DATE_RAW, 112)))
                      ELSE 0                      -- 끝 월 불명 → 시작월 하나(종전과 같다)
                    END;

        -- 형제 ITEM 보충(아래)이 (DIVISION/PLANT/LINE)로 찾지만 인덱스는 걸지 않는다.
        -- DIVISION_ID 가 COALESCE(pm.DIVISION_ID, SUBSTRING(...)) 이라 nvarchar(max) 로 떨어져
        -- 인덱스 키로 쓸 수 없다(오류 1919). 자기참조를 없앤 것만으로 이 조인은 이미 즉시 끝난다
        -- (2026-09-03 실측: resolved 적재 2.6초 + 자기조인 0.0초). 필요해지면 그때
        -- 대상 컬럼을 명시 캐스팅해서 인덱스를 검토한다 — 타입을 바꾸면 결과가 달라질 수 있으니
        -- 성능이 실제로 문제될 때만.

        -- filled: AUTO_ROUTING_ID 행은 ITEM이 비어있음 → 같은 (DIV/PLANT/LINE)의 정상 라우팅 형제 행에서 ITEM 보충
        -- filled 전체를 #cand 로 보존 + 탈락사유(drop_reason) 계산 → 미반영(NOAPPLY) 로그 소스
        SELECT r.DIVISION_ID, r.PLANT_ID, r.LINE_ID,
               COALESCE(NULLIF(r.ITEM_ID,N''), sib.ITEM_ID) AS ITEM_ID,
               r.YYYYMM, r.new_lp, r.opt_id, r.plan_id, r.SITE_ID, r.op,
               CASE WHEN r.new_lp IS NULL OR r.new_lp <= 0
                         THEN N'DROP_BADVAL(LOAD_PER 없음/음수/0)'
                    WHEN COALESCE(COALESCE(NULLIF(r.ITEM_ID,N''), sib.ITEM_ID),N'')=N''
                         THEN N'DROP_NOITEM(ITEM 미보충 - 같은 라인 정상 라우팅 없음)'
                    WHEN COALESCE(r.DIVISION_ID,N'')=N'' OR COALESCE(r.LINE_ID,N'')=N'' OR COALESCE(r.YYYYMM,N'')=N''
                         THEN N'DROP_BADKEY(DIVISION/LINE/YYYYMM 누락)'
                    ELSE NULL END AS drop_reason
        INTO #cand
        FROM #resolved r
        OUTER APPLY (
            SELECT TOP 1 r2.ITEM_ID
            FROM #resolved r2
            WHERE COALESCE(r2.ITEM_ID,N'')<>N''
              AND r2.LINE_ID = r.LINE_ID AND r2.DIVISION_ID = r.DIVISION_ID AND r2.PLANT_ID = r.PLANT_ID
            ORDER BY r2.ITEM_ID
        ) sib;                                                             -- AUTO ITEM 보충 후 전체(탈락 포함)

        -- 유효(drop_reason NULL) 후보만 동일 키 MIN(new_lp)로 집계하여 #dc 확정
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, ITEM_ID, YYYYMM,
               MIN(new_lp) AS new_lp, MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id, MAX(SITE_ID) AS SITE_ID,
               MAX(op) AS op          -- 같은 키에 UPDATE/INSERT 가 섞이면 하나만 남는다(대표 1건이라 수용)
        INTO #dc
        FROM #cand
        WHERE drop_reason IS NULL
        GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, ITEM_ID, YYYYMM;

        -- 환산자(CV.VAL) 1회 계산해 보존: M_MIN 재계산·로그에 공용 사용(전극 EA만 실제값, 그 외 1)
        ALTER TABLE #dc ADD conv NUMERIC(20,10) NULL;
        UPDATE #dc
           SET conv = dbo.FN_GET_SCP_OPMZ_ITEM_CONV(SITE_ID, ITEM_ID,
                          CASE WHEN plan_id LIKE N'SNRO[_]%' THEN STUFF(plan_id,1,5,N'') ELSE plan_id END);

        SET @RESOLVED = (SELECT COUNT(*) FROM #dc);   -- 반영 대상 건수 집계
        /* 6 종료: 반영 대상(#dc) 구성 완료. */

        -- 행단위 변경 이력 임시테이블(#chg) 준비: UPDATE OUTPUT 결과를 담아 로그로 전개
        IF OBJECT_ID('tempdb..#chg') IS NOT NULL DROP TABLE #chg;
        CREATE TABLE #chg(
            op     nvarchar(10),   -- 연산 유형(UPDATE)
            rowkey nvarchar(300),  -- 변경 대상 키(DIVISION|PLANT|LINE|ITEM|YYYYMM)
            bef    nvarchar(100),  -- 변경 전 값(전극=M_MIN / 조립=CAPA)
            aft    nvarchar(100),  -- 변경 후 값(전극=M_MIN / 조립=CAPA)
            tag    nvarchar(150),  -- 출처 태그(ATTRIBUTE9 = SNRO/opt_id)
            conv   numeric(20,10), -- 적용된 환산자(CV.VAL) — OUTPUT 불가라 사후 #dc 조인으로 채움
            -- 2026-10-01(GitLab #35): 반영 이력 상세(SCP_SNRO_PLAN_MST_APPY_D)용 **쪼갠 키**.
            --   rowkey 문자열 조인(conv 가 쓰는 방식)은 ITEM_ID 에 구분자가 섞이면 깨진다 — 컬럼으로 받는다.
            --   이 타겟 키는 품목이 있고 라인유형이 없다(PK: DIV·PLANT·LINE·OP·ITEM_ID·YYYYMM).
            k_div   nvarchar(60),
            k_plant nvarchar(60),
            k_line  nvarchar(60),
            k_opn   nvarchar(60),
            k_item  nvarchar(100),
            k_date  nvarchar(16)   -- YYYYMM (월 단위 키)
        );

        /* 7 시작: 기존 DDLY_CAPA 행의 용량값 갱신 — 사업부에 따라 갱신 컬럼이 다름.
                   ┌ 조립(DIVISION_ID='40', OP=A3000/A9000): **CAPA** 갱신
                   │     CAPA = 86400 / (새 LOAD_PER × PRDN_OPER_RT/100)   ← 정방향 TACT=86400/(CAPA×rt)의 역
                   └ 전극(DIVISION_ID='EE', OP=E2000, 코팅): **M_MIN**(코팅속도 m/min) 갱신
                         M_MIN = 60 / (새 LOAD_PER × PRDN_OPER_RT/100 × LANE × (WIDE_YN='Y'?2:1))
                              ← 정방향 TACT=60/(M_MIN×rt/100)/(LANE×wide) 의 역 (EE_INPUT_ROUTING_RESOURCE 기준). M_MIN은 nvarchar.
                   매칭: (DIVISION/PLANT/LINE/ITEM/YYYYMM). PRDN_OPER_RT/LANE/WIDE_YN 는 대상 행 자체 값 사용.
                   각 사업부는 자기 컬럼만 갱신하고 반대 컬럼은 원값 유지. OUTPUT은 실제 바뀐 컬럼(전극=M_MIN/조립=CAPA)을 before/after로 기록. */
        UPDATE dc
           SET dc.CAPA = CASE WHEN dc.DIVISION_ID = N'EE' THEN dc.CAPA   -- 전극은 CAPA 미변경
                              ELSE CONVERT(NUMERIC(18,4), 86400.0 / (s.new_lp * (ISNULL(NULLIF(dc.PRDN_OPER_RT,0),100) / 100.0))) END,
               dc.M_MIN = CASE WHEN dc.DIVISION_ID = N'EE'
                               THEN CONVERT(NVARCHAR(50), CONVERT(NUMERIC(20,6),
                                        60.0 / (s.new_lp * s.conv * (ISNULL(NULLIF(dc.PRDN_OPER_RT,0),100) / 100.0)
                                                * NULLIF(dc.LANE,0) * (CASE WHEN dc.WIDE_YN = 'Y' THEN 2 ELSE 1 END))))
                               ELSE dc.M_MIN END,                        -- 조립은 M_MIN 미변경
               dc.VALID_YN         = 'Y',
               dc.ATTRIBUTE1       = dbo.FN_GET_SCP_OPMZ_DESC_HIST(dc.ATTRIBUTE1,   -- 이력(DESC 없는 테이블 → ATTRIBUTE1에 다른 테이블 DESC와 동일 규칙)
                                          ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                                  WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'DDLY_CAPA'
                                                    AND ld.SEGMENT2=s.opt_id AND ld.VALID_YN=N'Y'),
                                                 CASE WHEN dc.DIVISION_ID=N'EE' THEN N'코팅속도 변경' ELSE N'생산능력 변경' END), s.plan_id),
               dc.ATTRIBUTE9       = CONCAT(@SNRO_CD, N'/', s.opt_id),
               dc.LAST_UPDATED_BY  = @uid,
               dc.LAST_UPDATE_DATE = GETDATE()
        OUTPUT N'UPDATE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.ITEM_ID, N'|', deleted.YYYYMM),
               CASE WHEN deleted.DIVISION_ID=N'EE' THEN deleted.M_MIN ELSE CAST(deleted.CAPA  AS nvarchar(100)) END,  -- 변경 전(전극=M_MIN/조립=CAPA)
               CASE WHEN inserted.DIVISION_ID=N'EE' THEN inserted.M_MIN ELSE CAST(inserted.CAPA AS nvarchar(100)) END, -- 변경 후
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.ITEM_ID, inserted.YYYYMM   -- #35 상세용 쪼갠 키
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_item, k_date)
        FROM dbo.SCP_OPMZ_DDLY_CAPA dc
        JOIN #dc s
            ON  dc.DIVISION_ID = s.DIVISION_ID   -- 5개 키 완전 일치 행만 갱신
            AND dc.PLANT_ID    = s.PLANT_ID
            AND dc.LINE_ID     = s.LINE_ID
            AND dc.ITEM_ID     = s.ITEM_ID
            AND dc.YYYYMM      = s.YYYYMM;
        SET @UPD = @@ROWCOUNT;   -- 실제 갱신된 행수

        /* 7b 시작: 기존 DDLY 행이 없는 (라인/아이템/월) → 신규 INSERT (2026-07-07).
                   LANE/WIDE_YN/PRDN_OPER_RT 는 화면 입력 물리속성이라 임의 생성 불가 →
                   **같은 라인(DIV/PLANT/LINE)의 기존 DDLY 행에서 복사**(CROSS APPLY sib). M_MIN만 새 LOAD_PER로 재계산.
                   형제 행이 하나도 없으면(=WIDE_YN 미등록 신규 라인) INSERT하지 않고 SKIP+로그(값 지어내지 않음).
                   sib 우선순위: 같은 ITEM → OPERATION=E2000(코팅) → 최신 YYYYMM.
                   ※ AUTO_ROUTING_ID('::' 없는 신규 라우팅)는 위 resolved/filled 에서 RESOURCE_ID로 site/line 도출 +
                     형제 라우팅 행에서 ITEM 보충하여 #dc에 포함됨(2026-07-07). 단 그 라인에 기존 DDLY 형제가 없으면 SKIP. */
        INSERT INTO dbo.SCP_OPMZ_DDLY_CAPA
            (DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, YYYYMM,
             CAPA, M_MIN, LANE, WIDE_YN, PRDN_OPER_RT, VALID_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE8, ATTRIBUTE9)
        OUTPUT N'INSERT',
               CONCAT(inserted.DIVISION_ID, N'|', inserted.PLANT_ID, N'|', inserted.LINE_ID, N'|',
                      inserted.ITEM_ID, N'|', inserted.YYYYMM),
               NULL,                                                                                   -- 신규라 before 없음
               CASE WHEN inserted.DIVISION_ID=N'EE' THEN inserted.M_MIN ELSE CAST(inserted.CAPA AS nvarchar(100)) END,
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.ITEM_ID, inserted.YYYYMM   -- #35 상세용 쪼갠 키
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_item, k_date)
        SELECT s.DIVISION_ID, s.PLANT_ID, s.LINE_ID, sib.OPERATION_ID, s.ITEM_ID, s.YYYYMM,
               -- CAPA: 전극은 형제값 그대로(엔진 미조회, NOT NULL 충족용) / 조립은 새 속도로 재계산
               CASE WHEN s.DIVISION_ID=N'EE' THEN sib.CAPA
                    ELSE CONVERT(NUMERIC(20,10), 86400.0 / (s.new_lp * (ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0))) END,
               -- M_MIN: 전극은 새 속도로 재계산 / 조립은 형제값 유지
               CASE WHEN s.DIVISION_ID=N'EE'
                    THEN CONVERT(NVARCHAR(50), CONVERT(NUMERIC(20,6),
                             60.0 / (s.new_lp * s.conv * (ISNULL(NULLIF(sib.PRDN_OPER_RT,0),100)/100.0)
                                     * NULLIF(sib.LANE,0) * (CASE WHEN sib.WIDE_YN=N'Y' THEN 2 ELSE 1 END))))
                    ELSE sib.M_MIN END,
               sib.LANE, sib.WIDE_YN, sib.PRDN_OPER_RT, N'Y',
               @uid, GETDATE(), @uid, GETDATE(),
               dbo.FN_GET_SCP_OPMZ_DESC_HIST(NULL,   -- 신규행 이력(ATTRIBUTE1) = 사유 (PLAN_ID)
                        ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'DDLY_CAPA'
                                  AND ld.SEGMENT2=s.opt_id AND ld.VALID_YN=N'Y'),
                               CASE WHEN s.DIVISION_ID=N'EE' THEN N'코팅속도 변경' ELSE N'생산능력 변경' END), s.plan_id),
               N'SNRO_INSERT/SIBLING', CONCAT(@SNRO_CD, N'/', s.opt_id)
        FROM #dc s
        CROSS APPLY (   -- 같은 라인의 기존 DDLY 행에서 물리속성 복사(없으면 이 행은 INSERT 제외 → SKIP 대상)
            SELECT TOP 1 d.OPERATION_ID, d.LANE, d.WIDE_YN, d.PRDN_OPER_RT, d.CAPA, d.M_MIN
            FROM dbo.SCP_OPMZ_DDLY_CAPA d
            WHERE d.DIVISION_ID = s.DIVISION_ID AND d.PLANT_ID = s.PLANT_ID AND d.LINE_ID = s.LINE_ID
              AND d.LANE > 0 AND d.WIDE_YN IS NOT NULL
            ORDER BY CASE WHEN d.ITEM_ID = s.ITEM_ID THEN 0 ELSE 1 END,
                     CASE WHEN d.OPERATION_ID = N'E2000' THEN 0 ELSE 1 END,
                     d.YYYYMM DESC
        ) sib
        WHERE NOT EXISTS (   -- 이미 (라인/아이템/월) 행이 있으면 위 UPDATE가 처리했으므로 제외(UPDATE와 동일한 5키 기준)
            SELECT 1 FROM dbo.SCP_OPMZ_DDLY_CAPA d2
            WHERE d2.DIVISION_ID = s.DIVISION_ID AND d2.PLANT_ID = s.PLANT_ID AND d2.LINE_ID = s.LINE_ID
              AND d2.ITEM_ID = s.ITEM_ID AND d2.YYYYMM = s.YYYYMM
        );
        SET @INS = @@ROWCOUNT;   -- 신규 INSERT 행수(형제에서 물리속성 복사한 건)

        -- 미반영(NOAPPLY) 로그 ①: 해석은 됐으나(기존행 없음) 형제 행도 없어 물리속성을 못 구해 건너뛴 대상
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_item, k_date)
        SELECT N'NOAPPLY',
               CONCAT(s.DIVISION_ID, N'|', s.PLANT_ID, N'|', s.LINE_ID, N'|', s.ITEM_ID, N'|', s.YYYYMM),
               NULL, NULL, N'NO_SIBLING(WIDE_YN 미등록 라인 - 화면 등록 후 반영)',
               s.DIVISION_ID, s.PLANT_ID, s.LINE_ID, NULL, s.ITEM_ID, s.YYYYMM   -- #35 상세용 키
        FROM #dc s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_DDLY_CAPA d2
                          WHERE d2.DIVISION_ID=s.DIVISION_ID AND d2.PLANT_ID=s.PLANT_ID AND d2.LINE_ID=s.LINE_ID
                            AND d2.ITEM_ID=s.ITEM_ID AND d2.YYYYMM=s.YYYYMM)
          AND NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_DDLY_CAPA d3
                          WHERE d3.DIVISION_ID=s.DIVISION_ID AND d3.PLANT_ID=s.PLANT_ID AND d3.LINE_ID=s.LINE_ID
                            AND d3.LANE>0 AND d3.WIDE_YN IS NOT NULL);

        -- 미반영(NOAPPLY) 로그 ②: 카드 대상이지만 해석 단계에서 탈락(빈키/음수속도/ITEM 미보충)한 대상
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_item, k_date)
        SELECT N'NOAPPLY',
               CONCAT(ISNULL(DIVISION_ID,N''), N'|', ISNULL(PLANT_ID,N''), N'|', ISNULL(LINE_ID,N''), N'|',
                      ISNULL(ITEM_ID,N''), N'|', ISNULL(YYYYMM,N'')),
               NULL, NULL, drop_reason,
               DIVISION_ID, PLANT_ID, LINE_ID, NULL, ITEM_ID, YYYYMM   -- #35 상세용 키
        FROM #cand
        WHERE drop_reason IS NOT NULL;

        -- #chg 각 행에 적용 환산자 기록(OUTPUT 불가 → #dc 키 조인). NOAPPLY②(#cand only)는 미매칭 NULL 유지
        UPDATE c
           SET c.conv = s.conv
        FROM #chg c
        JOIN #dc s
          ON c.rowkey = CONCAT(s.DIVISION_ID, N'|', s.PLANT_ID, N'|', s.LINE_ID, N'|', s.ITEM_ID, N'|', s.YYYYMM);

        SET @NOAPPLY = (SELECT COUNT(*) FROM #chg WHERE op = N'NOAPPLY');   -- 미반영(형제없음+해석탈락) 총 건수
        /* 7b 종료. */

        /* 7c 시작: **반영 이력 상세 적재** (2026-10-01, GitLab #35)
                    `#chg` 가 기준정보 키 단위이므로 그대로 상세가 된다. 카드·계획·patch op 는
                    `#cand` 와 **키 조인**으로 붙인다(`#dc` 는 유효 후보만이라 NOAPPLY② 를 못 덮는다).
                    실패해도 반영은 유효해야 하므로 TRY/CATCH 로 감싼다 — NO_WORK step10-b 와 같은 규약.
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
            ;WITH meta AS (   -- 키별 대표 1건. #dc 가 MIN(new_lp) 로 고르는 것과 같은 입자
                SELECT DIVISION_ID, PLANT_ID, LINE_ID, ISNULL(ITEM_ID, N'') AS ITEM_ID, YYYYMM,
                       MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id, MAX(op) AS op
                FROM #cand
                GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, ISNULL(ITEM_ID, N''), YYYYMM
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
                   N'SCP_OPMZ_DDLY_CAPA',
                   c.k_div   COLLATE DATABASE_DEFAULT,
                   c.k_plant COLLATE DATABASE_DEFAULT,
                   c.k_line  COLLATE DATABASE_DEFAULT,
                   c.k_opn   COLLATE DATABASE_DEFAULT,
                   NULL,                                        -- LINE_TYPE: 이 타겟 키에 없다
                   c.k_item  COLLATE DATABASE_DEFAULT,
                   c.k_date  COLLATE DATABASE_DEFAULT,           -- YYYYMM (월 단위)
                   NULL,
                   NULL,
                   -- 2026-10-01: 양식의 「기존 / 변경」 날짜. 이 타겟은 **월이 바뀌지 않는다**
                   --   (값만 바뀐다) — 기존·변경 모두 같은 YYYYMM 이고 끝 칸은 안 쓴다.
                   c.k_date COLLATE DATABASE_DEFAULT, NULL,
                   c.k_date COLLATE DATABASE_DEFAULT, NULL,
                   ISNULL(m.op, c.op) COLLATE DATABASE_DEFAULT,
                   CASE WHEN c.op = N'NOAPPLY' THEN N'NOAPPLY' ELSE N'APPLIED' END,
                   -- 갱신 컬럼이 사업부로 갈린다 — 전극(EE)=코팅속도 M_MIN, 조립=CAPA
                   CASE WHEN c.k_div = N'EE' THEN N'M_MIN' ELSE N'CAPA' END,
                   c.bef COLLATE DATABASE_DEFAULT,
                   c.aft COLLATE DATABASE_DEFAULT,
                   NULL,                                        -- NO_WORK_TYPE: 비조업 전용
                   NULL,                                        -- CAUSE: 삭제 주체 개념이 없다(이 타겟은 삭제가 없다)
                   LEFT(CASE WHEN c.op = N'NOAPPLY'
                             THEN c.tag COLLATE DATABASE_DEFAULT
                             ELSE CONCAT(N'결과=', c.op COLLATE DATABASE_DEFAULT,
                                         CASE WHEN c.conv IS NOT NULL
                                              THEN CONCAT(N' · 환산자=', CONVERT(nvarchar(30), c.conv))
                                              ELSE N'' END)
                        END, 500),
                   ISNULL(m.opt_id,  N'') COLLATE DATABASE_DEFAULT,
                   NULL,
                   m.plan_id COLLATE DATABASE_DEFAULT,
                   @uid,
                   GETDATE()
            FROM #chg c
            LEFT JOIN meta m
                ON  m.DIVISION_ID = c.k_div  AND m.PLANT_ID = c.k_plant
                AND m.LINE_ID     = c.k_line AND m.ITEM_ID  = ISNULL(c.k_item, N'')
                AND m.YYYYMM      = c.k_date;
        END TRY
        BEGIN CATCH
            BEGIN TRY
                DECLARE @dtl_err nvarchar(200) = LEFT(ERROR_MESSAGE(), 200);
                SET @LOG_DT = GETDATE();
                EXEC dbo.PR_SCM_SYS_LOG_BATCH
                     @p_program_name = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
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

        -- #chg의 각 변경 행을 SCM_SYS_LOG_BATCH에 행단위 이력으로 적재(ATTRIBUTE1~7에 상세 저장)
        INSERT INTO dbo.SCM_SYS_LOG_BATCH
            (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8)
        SELECT N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
               op,
               1,
               CONCAT(N'DDLY_CAPA ', op),                                                       -- LOG_MESSAGE: 테이블 op 라벨
               CONCAT(N'key=', rowkey, N' | ', ISNULL(bef,N'-'), N'->', ISNULL(aft,N'-'),        -- DESCRIPTION: key + 변경값(+환산자)
                      CASE WHEN conv IS NOT NULL THEN CONCAT(N' | 환산자=', CONVERT(NVARCHAR(30), conv)) ELSE N'' END),
               GETDATE(), GETDATE(), @uid, GETDATE(), @uid,   -- 2026-09-30: 감사칸 둘을 비우지 않는다
               -- ATTRIBUTE1~8 : 대상테이블 / op / 시나리오 / 태그 / 키 / 변경전 / 변경후 / 환산자(CV.VAL)
               N'SCP_OPMZ_DDLY_CAPA', op, @SNRO_CD, tag, rowkey, bef, aft, CONVERT(NVARCHAR(30), conv)
        FROM #chg;
        /* 7 종료: CAPA 갱신 완료. */

        /* 8 시작: 커밋(트랜잭션 소유자일 때만; 중첩 호출이면 소유자에 위임). */
        IF @START_TRAN = 1 COMMIT;
        /* 8 종료. */

        /* 9 시작: 성공 로그 적재(처리 건수 요약 포함). */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = ISNULL(@UPD,0) + ISNULL(@INS,0);
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', N'CRD-00102',
                                        N'; TARGET=', N'SCP_OPMZ_DDLY_CAPA',
                                        N'; UPD=', @UPD, N' INS=', @INS, N' NOAPPLY=', @NOAPPLY, N' RESOLVED=', @RESOLVED), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
                 @p_log_type     = N'END',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA 완료',
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        /* 9 종료. */

        /* 10 시작: 결과 요약 반환(@RETURN_RESULT_YN='Y'일 때만 리절트셋 방출). */
        IF @RETURN_RESULT_YN = N'Y'
            SELECT @SNRO_CD AS SNRO_CD,
                   N'Y'                          AS SUCCESS_YN,
                   N'SUCCESS'                    AS RESULT_CODE,
                   N'코팅증속(DDLY_CAPA) 반영 완료' AS RESULT_MESSAGE,
                   @UPD      AS UPDATED_ROWS,     -- 실제 갱신 행수
                   @INS      AS INSERTED_ROWS,    -- 신규 INSERT 행수(형제 물리속성 복사)
                   @NOAPPLY  AS NOAPPLY_ROWS,     -- 미반영 행수(형제없음 + 해석탈락) — 로그로 상세 확인
                   @RESOLVED AS RESOLVED_ROWS;    -- 패치에서 도출된 대상 행수
        /* 10 종료. */
    END TRY
    BEGIN CATCH
        /* 11 시작: 오류 시 롤백 → 오류 로그 → 예외 재전파.
                   - 트랜잭션 소유자이고 트랜잭션 상태가 살아있으면 ROLLBACK.
                   - 오류 로그는 소유자만 남김(중첩 호출은 상위 오케스트레이터가 기록).
                   - THROW로 원 예외를 그대로 상위에 재전파(호출자에서 최종 처리). */
        IF @START_TRAN = 1 AND XACT_STATE() <> 0
            ROLLBACK;
        SET @ERR_MSG = ERROR_MESSAGE();
        IF @START_TRAN = 1   /* 중첩 호출 시 에러로그는 트랜잭션 소유자(오케스트레이터)가 남김 */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', N'CRD-00102',
                                        N'; TARGET=', N'SCP_OPMZ_DDLY_CAPA'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_DDLY_CAPA',
                 @p_log_type     = N'ERROR',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = @ERR_MSG,
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        THROW;
        /* 11 종료. */
    END CATCH;
END
