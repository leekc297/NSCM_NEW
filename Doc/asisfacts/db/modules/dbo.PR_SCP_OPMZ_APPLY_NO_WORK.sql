
/* ---- 1) 비조업 ---------------------------------------------------------------------------- */

/*
 * Program ID   : PR_SCP_OPMZ_APPLY_NO_WORK
 * Description  : 시나리오 캘린더 patch → SCP_OPMZ_NO_WORK 반영
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 * 2026/09/18   park.choyi        [GitLab #11] 캘린더 신규 구간행(op='INSERT') 반영 추가 (step 9c)
 * 2026/09/18   park.choyi        [GitLab #27] 역산 삭제(9d) + 소프트 삭제 폐기·물리 삭제 일원화(9e)
 *
 */
CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_NO_WORK
    @SNRO_CD          NVARCHAR(50),
    @USER_ID          NVARCHAR(200) = NULL,
    @OPT_KEY_VAL_ID   NVARCHAR(200) = NULL,   -- 콤마구분 카드 목록(예 'CRD-00001,CRD-00104'); NULL=전체
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    /*==============================================================================================
      PR_SCP_OPMZ_APPLY_NO_WORK — 시나리오(SNRO)의 비조업(NO WORK) 패치를 운영테이블에 반영
    ------------------------------------------------------------------------------------------------
      [목적] 최적화 엔진이 산출한 시나리오 JSON 패치 중 캘린더(RESOURCE_EVERY_CALENDAR) 변경분을
             GSCM 운영테이블 dbo.SCP_OPMZ_NO_WORK 에 반영한다.
      [소스] dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN (SCP_SNRO_ID=@SNRO_CD 의 패치 JSON 배열)
             ※ 엔진 결과테이블은 직접 읽지 않고, SNRO로 키가 잡힌 JSON 패치만 파싱(재최적화 오염 방지).
      [타겟] dbo.SCP_OPMZ_NO_WORK  (U=OFF_TIME 갱신, D=**물리 삭제**, I=날짜이동 신규행 + 신규 구간 전개행)
      [판정] 어떤 카드가 NO_WORK 대상인지는 dbo.FN_GET_SCP_OPMZ_OPT_TARGET(opt_id,'NO_WORK') = lookup 등록 여부.
      [핵심 변환]
        · OFF_TIME = 86400 - DAILY_VALUE           (하루=86400초, 정방향 DAILY=86400-OFF 의 역산)
        · LINE_ID  = RESOURCE_ID→RESOURCE.RESOURCE_NAME
        · DIVISION/PLANT = RESOURCE.SITE_ID → SCM_MST_SITE
      [처리 유형] op = DELETE(무가동 해제) / UPDATE(OFF량 변경) / 날짜이동(공사·PM지연: 구→새 날짜)
                 / INSERT(캘린더 신규 구간 → 일자 전개. 비조업 방향만. 2026-09-18 추가)
                 / **역산 삭제**(구간 쪼개기로 없어진 날. DELETE 패치가 안 나오는 경우. 2026-09-18 추가)
      [부가] ATTRIBUTE9=SNRO/카드 이력태그, DESC 사유문구(lookup DESCRIPTION), 행단위 변경이력 로그
      [멱등] UPDATE + 물리삭제 + NOT EXISTS 가드로 재실행 안전
             (9c 는 기존 행이면 UPDATE 로 흘러 같은 값이 들어가고, 9e 는 없는 행이면 0건이다)
      [삭제] 2026-09-18(#27)부터 **소프트 삭제(VALID_YN='N')를 쓰지 않는다.** 변경 전 기준정보는
             행 자체를 지운다(현업 요구). 삭제 지점은 셋이지만 **실제 DELETE 는 9e 한 곳**이라
             나중에 키가 늘어도(복수 비조업) 조인을 한 군데만 고치면 된다.
      [파라미터] @SNRO_CD(필수), @USER_ID(처리자), @OPT_KEY_VAL_ID(특정 카드만 스코프), @RETURN_RESULT_YN
      [단계] 1 옵션 → 2 검증 → 3 변수 → 4 START로그 → 5 트랜잭션 → 6 파싱(#p) →
             7 삭제대상수집 → 8 UPDATE → 9 날짜이동 → 9c INSERT전개 → 9d 역산 →
             9b 미반영로그 → **9e 실제 삭제(한 곳)** → 10 행이력로그 → 11 커밋 →
             12 SUCCESS로그 → 13 반환 / 14 예외
    ==============================================================================================*/

    /* 1 시작: 기본 실행 옵션. SET NOCOUNT=영향건수 메시지 억제, SET XACT_ABORT=런타임 오류 시 트랜잭션 전체 즉시 롤백. */
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    /* 1 종료. */

    /* 2 시작: 필수 입력값(시나리오 코드) 검증. */
    IF NULLIF(LTRIM(RTRIM(@SNRO_CD)), N'') IS NULL
        THROW 51000, 'SNRO_CD IS REQUIRED.', 1;
    /* 2 종료. */

    /* 3 시작: 런타임 변수 선언. */
    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());  -- 처리자(미지정 시 로그인 계정)
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;  -- 1=내가 트랜잭션 소유(단독 호출), 0=상위(오케스트레이터) 트랜잭션에 합류
    DECLARE @UPD INT = 0, @DEL INT = 0, @INS INT = 0, @PATCHES INT = 0, @NOAPPLY INT = 0;  -- 반영 카운터: UPDATE건, DELETE건, INSERT건(날짜이동 신규행), 파싱된 대상건(#p), 미반영건
    DECLARE @ERR_MSG  NVARCHAR(2048);                                       -- CATCH 오류메시지
    DECLARE @LOG_DT   DATETIME;                                             -- 로그 시각
    DECLARE @LOG_CNT  INT;                                                  -- 로그 건수
    DECLARE @LOG_DESC NVARCHAR(500);                                        -- 로그 상세(SNRO/CARD/TARGET/카운터)
    /* 3 종료. */

    /* 4 시작: 시작 로그 적재(트랜잭션 밖 → 롤백돼도 보존). */
    BEGIN
        SET @LOG_DT  = GETDATE();
        SET @LOG_CNT = 0;
        SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                    N'; CARD=', @OPT_KEY_VAL_ID,
                                    N'; TARGET=', N'SCP_OPMZ_NO_WORK'), 500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH
             @p_program_name = N'PR_SCP_OPMZ_APPLY_NO_WORK',
             @p_log_type     = N'START',
             @p_log_count    = @LOG_CNT,
             @p_log_message  = N'PR_SCP_OPMZ_APPLY_NO_WORK 시작',
             @p_description  = @LOG_DESC,
             @p_event_date   = @LOG_DT;
    END;
    /* 4 종료. */

    IF OBJECT_ID('tempdb..#p') IS NOT NULL DROP TABLE #p;

    BEGIN TRY
        /* 5 시작: 트랜잭션 시작 — 내가 소유(@START_TRAN=1, 단독 호출)일 때만. 오케스트레이터 하위로 실행 시엔
                   이미 상위 트랜잭션 안이라 여기서 열지 않고 합류(전부 성공/전부 롤백 보장). */
        IF @START_TRAN = 1 BEGIN TRAN;
        /* 5 종료. */

        /* 6 시작: 시나리오 JSON 패치 파싱 → 반영 대상 임시테이블(#p) 구성.
           ┌ compat120라 OPENJSON 불가 → FN_SCP_JSON_ARRAY_ITEMS_120(배열→행) + FN_SCP_JSON_OBJECT_ITEMS_120(객체→KV) 사용.
           ├ patch CTE : SNRO의 패치 JSON 배열을 건별로 펼쳐 op/where/set 추출.
           │             필터 = 캘린더 테이블(RESOURCE_EVERY_CALENDAR) ∧ NO_WORK 카드(FN 판정) ∧ (@OPT_KEY_VAL_ID 스코프).
           ├ kv CTE    : where/set 각각을 (컬럼,값)으로 분해하며 src 태깅 →
           │             src='W'(where=기존/키값), src='S'(set=변경후값). 같은 컬럼도 W/S로 의미가 달라 구분.
           │             예) w_sdate=기존 날짜, s_sdate=바뀔 날짜 / s_daily=새 가동(OFF_TIME 산출). ※ where.DAILY_VALUE는 미사용(2026-07-08).
           └ 최종 SELECT: RESOURCE(resource_id→라인명·SITE) + SCM_MST_SITE(SITE→DIV/PLANT) 조인해 #p 확정.
                          OFF_TIME=86400-DAILY(DELETE는 NULL), OLD_DATE/MOVE_TO는 날짜이동(step9) 판정용.
                          ※ SCM_MST_SITE INNER JOIN: opt_key로 전건 매핑되므로 폴백 불필요(매핑 실패행은 제외). */
        ;WITH patch AS (   -- 6-1: 패치 JSON 배열을 op/where/set 로 펼침 (카드·테이블 필터)
            SELECT m.SCP_OPT_ID,
                   J.[KEY]                              AS pseq,               -- 패치 배열 인덱스(카드 내 순번)
                   UPPER(JSON_VALUE(J.[VALUE], '$.op')) AS op,                 -- INSERT/UPDATE/DELETE
                   JSON_QUERY(J.[VALUE], '$.where')     AS wf,                 -- where 절 배열(기존/키)
                   JSON_QUERY(J.[VALUE], '$.set')       AS sf                  -- set 절 배열(변경후)
            FROM dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN m
            CROSS APPLY dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(m.SCP_OPT_PTCH_JSON_CTN) J
            WHERE m.SCP_SNRO_ID = @SNRO_CD
              AND ISJSON(m.SCP_OPT_PTCH_JSON_CTN) = 1
              AND UPPER(PARSENAME(JSON_VALUE(J.[VALUE], '$.table'), 1)) = N'SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR'  -- 캘린더 패치만
              AND ((@OPT_KEY_VAL_ID IS NULL OR N',' + REPLACE(@OPT_KEY_VAL_ID, N' ', N'') + N',' LIKE N'%,' + m.SCP_OPT_ID COLLATE DATABASE_DEFAULT + N',%')  -- 특정 카드 목록 스코프(콤마구분, 옵션)
                   AND dbo.FN_GET_SCP_OPMZ_OPT_TARGET(m.SCP_OPT_ID, N'NO_WORK') = 1)                             -- NO_WORK 대상 카드만
        ),
        kv AS (   -- 6-2: where/set 을 (컬럼,값)으로 분해 → 컬럼별 피벗. src W=where(기존), S=set(변경후)
            SELECT p.pseq,
                   p.op,
                   MAX(p.SCP_OPT_ID) AS opt_id,
                   MAX(CASE WHEN f.col='PLAN_ID'                   THEN f.val END) AS plan_id,
                   MAX(CASE WHEN f.col='RESOURCE_ID'               THEN f.val END) AS resource_id,
                   MAX(CASE WHEN f.col='TYPE'                      THEN f.val END) AS typ,
                   MAX(CASE WHEN f.src='S' AND f.col='START_DATE'  THEN f.val END) AS s_sdate,
                   MAX(CASE WHEN f.src='W' AND f.col='START_DATE'  THEN f.val END) AS w_sdate,
                   MAX(CASE WHEN f.src='S' AND f.col='END_DATE'    THEN f.val END) AS s_edate,   -- set 종료일(INSERT 조각의 구간 끝. 배타)
                   MAX(CASE WHEN f.src='W' AND f.col='END_DATE'    THEN f.val END) AS w_edate,   -- where 종료일(UPDATE 조각의 **원본** 구간 끝. 역산의 기준)
                   MAX(CASE WHEN f.src='S' AND f.col='DAILY_VALUE' THEN f.val END) AS s_daily,
                   -- 2026-09-29: 비조업 유형 관통 — 보강(REINFORCE_PROJECTION) patch 는 조각마다 유형을
                   --             ATTRIBUTE13 에 싣는다(DELETE 는 where, INSERT 는 set). CRD patch 엔 없다(NULL).
                   MAX(CASE WHEN f.col='ATTRIBUTE13' THEN f.val END) AS no_work_type,
                   -- 2026-10-01: 복수 비조업의 **사유별 비율**. 엔진 슬롯이 ATTRIBUTE12 → ATTRIBUTE11 로
                   --   옮겨질 수 있어(SM 검토 중) **둘 다 받는다**. 둘 다 있으면 11 우선.
                   COALESCE(MAX(CASE WHEN f.col='ATTRIBUTE11' THEN f.val END),
                            MAX(CASE WHEN f.col='ATTRIBUTE12' THEN f.val END)) AS no_work_ratio
                   -- where.DAILY_VALUE(w_daily) 제거(2026-07-08): OFF_TIME은 set.DAILY_VALUE로만 산출, where는 키(라인/일자)만 필요
            FROM patch p
            CROSS APPLY (
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
            GROUP BY p.SCP_OPT_ID, p.pseq, p.op
        )
        -- 6-3: 라인/사이트/사업부 매핑 + 파생값 계산해 #p 확정. (COLLATE: OPTENG↔LGCE 콜레이션 불일치 방지)
        SELECT
            kv.op   COLLATE DATABASE_DEFAULT AS op,
            kv.opt_id COLLATE DATABASE_DEFAULT AS opt_id,                          -- 이 행을 만든 카드(CRD)
            dbo.FN_GET_SCP_OPMZ_PLAN_SEQ(kv.plan_id COLLATE DATABASE_DEFAULT, @SNRO_CD) AS plan_id,   -- 채번 계획ID(base→base_S00x). DESC 이력 꼬리용
            COALESCE(lo.SEGMENT1 COLLATE DATABASE_DEFAULT, st.DIVISION_ID) AS DIVISION_ID,  -- 사업부: 라인룩업 우선(전극=EE), 없으면 SITE 마스터
            COALESCE(lo.SEGMENT2 COLLATE DATABASE_DEFAULT, st.PLANT_ID)    AS PLANT_ID,     -- 공장:  라인룩업 우선, 없으면 SITE 마스터
            res.RESOURCE_NAME COLLATE DATABASE_DEFAULT AS LINE_ID,            -- RESOURCE_ID→라인명
            COALESCE(kv.s_sdate, kv.w_sdate) COLLATE DATABASE_DEFAULT AS NO_WORK_DATE,  -- 대상 일자(set 우선, 없으면 where)
            CASE WHEN kv.op='DELETE' THEN NULL                                -- DELETE는 OFF 불필요
                 -- 2026-09-18: TRY_CAST(... AS int) 단독이면 엔진 표기('0.0'·'77760.0')가 전부 NULL 이 된다.
                 -- NULL OFF_TIME 은 step8 의 `OFF_TIME IS NOT NULL` 과 step9c 의 `OFF_TIME > 0` 에 걸려
                 -- 조용히 미반영된다. float 를 거쳐 정수화한다(값·반올림 규칙 동일, 표기만 수용).
                 ELSE 86400 - TRY_CAST(TRY_CAST(kv.s_daily AS float) AS int) END AS OFF_TIME,  -- 무가동초=86400-set.가동량(where.DAILY_VALUE 미사용)
            kv.w_sdate COLLATE DATABASE_DEFAULT AS OLD_DATE,                  -- 날짜이동 판정용: 기존 날짜(where)
            CASE WHEN kv.s_sdate IS NOT NULL AND kv.s_daily IS NULL THEN kv.s_sdate END  -- 날짜이동: set에 날짜만·가동량 없음
                 COLLATE DATABASE_DEFAULT AS MOVE_TO,                         -- → 옮겨갈 새 날짜(아니면 NULL)
            kv.s_edate COLLATE DATABASE_DEFAULT AS END_DATE,                  -- INSERT 조각의 구간 끝(배타). step9c 가 일자로 펼친다
            kv.w_edate COLLATE DATABASE_DEFAULT AS W_END_DATE,                -- UPDATE 조각의 원본 구간 끝(배타). step9d 역산의 기준
            -- 2026-10-01: **운휴라인 표기 안전장치.** 고객 결정은 '운휴라인'(붙임)인데 엔진 patch 에는
            --   '운휴 라인'(공백)이 그대로 나간다 — 정규화 모듈(no_work_types.py)은 **읽을 때만** 흡수하고
            --   쓰기 경로(cards.py:32 · session_newline.py:464 · registry.py:141)는 공백 리터럴이다.
            --   실측: 2026-10 patch 336건이 전부 공백. 기준정보에 들어가는 값은 여기서 붙임으로 고정한다.
            --   REPLACE 라 복수 비조업(콤마) 값에도 안전하다 — '공휴일,운휴 라인' → '공휴일,운휴라인'.
            REPLACE(kv.no_work_type, N'운휴 라인', N'운휴라인')
                COLLATE DATABASE_DEFAULT AS NO_WORK_TYPE,         -- 조각의 비조업 유형(2026-09-29 관통)
            kv.no_work_ratio COLLATE DATABASE_DEFAULT AS NO_WORK_RATIO       -- 사유별 비율(2026-10-01)
        INTO #p
        FROM kv
        JOIN dbo.SCP_OPT_ENG_RESOURCE_SN res                          -- resource_id → 라인명/SITE
            ON  res.PLAN_ID     COLLATE DATABASE_DEFAULT = kv.plan_id
            AND res.RESOURCE_ID COLLATE DATABASE_DEFAULT = kv.resource_id
        JOIN dbo.SCM_MST_SITE st                                  -- SITE_ID → 사업부/공장 (폴백용)
            ON  st.SCM_SITE_ID = res.SITE_ID COLLATE DATABASE_DEFAULT
            AND st.VALID_YN = 'Y'
        LEFT JOIN dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL lo            -- 라인→(사업부/공장/OP) 권위 룩업(라인 유일키). 전극 사이트를 SITE마스터가 '40'으로 오매핑하는 문제 회피
            ON  lo.LOOKUP_TYPE = N'SCP_OPMZ_LINE_OPERATION' AND lo.VALID_YN = 'Y'
            AND lo.SEGMENT3 = res.RESOURCE_NAME COLLATE DATABASE_DEFAULT
        WHERE kv.typ = 'upper_limit';                                         -- 상한(upper_limit) 캘린더만 = 무가동 정의

        SET @PATCHES = (SELECT COUNT(*) FROM #p);   -- 파싱된 반영 대상 건수(RESOLVED)
        /* 6 종료: 반영 대상(#p) 구성 완료. */

        -- 변경 이력 수집용 임시테이블: 이하 D/U/I의 OUTPUT을 여기 모아 step10에서 로그로 적재.
        IF OBJECT_ID('tempdb..#chg') IS NOT NULL DROP TABLE #chg;
        CREATE TABLE #chg(
            op     nvarchar(10),    -- DELETE/UPDATE/INSERT/NOAPPLY
            rowkey nvarchar(300),   -- DIV|PLANT|LINE|OP|DATE 식별자
            bef    nvarchar(100),   -- 변경 전 OFF_TIME
            aft    nvarchar(100),   -- 변경 후 OFF_TIME
            tag    nvarchar(150),   -- ATTRIBUTE9(SNRO/카드)
            -- 2026-10-01(GitLab #35): 반영 이력 상세(SCP_SNRO_PLAN_MST_APPY_D)용으로 **키를 쪼개 담는다.**
            --   rowkey 는 파이프로 붙인 문자열이라 라인별 조회가 LIKE 가 된다 — 상세는 컬럼으로 받아야
            --   인덱스를 탄다. 카드/계획/유형/사유는 여기 담지 않는다:
            --   `INSERT ... OUTPUT` 절은 FROM 절 테이블을 참조할 수 없어(SQL Server 제약) 네 자리에서
            --   값을 꺼낼 수 없다. step10-b 가 #p/#del 과 **키 조인**으로 붙인다.
            k_div   nvarchar(60),
            k_plant nvarchar(60),
            k_line  nvarchar(60),
            k_opn   nvarchar(60),
            k_ltype nvarchar(40),
            k_date  nvarchar(16),
            /* 2026-10-02: **기준정보 행이 들고 있던 비조업 유형**(ATTRIBUTE2).
               종전에는 유형을 patch 조각(`#p`)에서만 가져와, 조각에 유형이 안 실린 건이
               상세에서 빈칸이 됐다(고객사 화면 49줄 중 7줄). 실제로 지우거나 고친 행에는
               그 값이 들어 있다 — OUTPUT 의 `deleted`/`inserted` 로 꺼내 폴백으로 쓴다.
               지울 행이 아예 없던 `NOMATCH` 는 여전히 빈다(가져올 데가 없으니 맞다).
               ⚠ **유형은 `ATTRIBUTE2` 가 아니라 `[DESC]` 에 있다** — dev 전수 실측(2026-10-02):
               `SCP_OPMZ_NO_WORK` 6,313행 **전부** `ATTRIBUTE2` 가 비었고 6,003행이 `[DESC]` 에
               유형을 들고 있다(`휴무일`·`운휴라인`). 그래서 원문을 그대로 담고 **다듬기는
               step10-b 에서** 한다 — 여기 OUTPUT 절에 긴 식을 넣으면 다섯 자리가 다 길어진다. */
            k_type  nvarchar(400)
        );

        /* 삭제 대상·보존 대상 버퍼 (2026-09-18, GitLab #27).
           ── 왜 모으나 ────────────────────────────────────────────────────────────────────────
           삭제 지점이 셋이다(7 해제 · 9-3 이동원본 · 9d 역산). 각자 DELETE 하면 **키를 세 곳에
           나열**하게 되고, 나중에 NO_WORK 키가 늘 때(복수 비조업) 세 곳을 다 찾아 고쳐야 한다.
           대상만 모아 두고 **실제 삭제는 9e 한 곳**에서 한다 — 키 조인이 한 군데뿐이다.

           ── #keep 이 필요한 이유 ─────────────────────────────────────────────────────────────
           같은 (라인/일자)에 카드 A 가 DELETE 를, 카드 B 가 UPDATE 를 낼 수 있다. 소프트 삭제
           시절에는 7 이 N 으로 내린 행을 8 이 다시 Y 로 되살려 **UPDATE 가 이겼다**. 물리 삭제로
           바꾸면 그 복원이 불가능하므로, 이번 실행에서 살아남아야 하는 키를 #keep 에 모아
           9e 에서 제외한다. 그래야 기존 판정(UPDATE 우선)이 그대로 유지된다. */
        IF OBJECT_ID('tempdb..#del') IS NOT NULL DROP TABLE #del;
        CREATE TABLE #del(
            DIVISION_ID  nvarchar(60),
            PLANT_ID     nvarchar(60),
            LINE_ID      nvarchar(60),
            NO_WORK_DATE nvarchar(16),
            opt_id       nvarchar(200),   -- 이 삭제를 부른 카드
            plan_id      nvarchar(200),
            src          nvarchar(20)     -- DELETE(7) / MOVE(9-3) / CARVE(9d)
        );
        IF OBJECT_ID('tempdb..#keep') IS NOT NULL DROP TABLE #keep;
        CREATE TABLE #keep(
            DIVISION_ID  nvarchar(60),
            PLANT_ID     nvarchar(60),
            LINE_ID      nvarchar(60),
            NO_WORK_DATE nvarchar(16)
        );

        /* 6b 시작: 구간 → 일자 전개용 숫자표(0..365). 재귀 CTE 를 쓰지 않는다(자기참조 재계산 회피).
                     2026-10-01(#35): 9c-1 에 있던 것을 **여기로 올렸다** — step 7(DELETE 전개)이 가장 앞이다.
                     7·8-0·9-1b·9c-2·9d-2 가 같은 표를 공유한다. */
        IF OBJECT_ID('tempdb..#d') IS NOT NULL DROP TABLE #d;
        SELECT TOP (366) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
        INTO #d
        FROM sys.all_objects;
        /* 6b 종료. */

        /* 7 시작: DELETE 패치 → 삭제 대상 수집. (2026-09-18 #27: 소프트 삭제 폐기)
                   op='DELETE' 인 #p 행의 (DIV/PLANT/LINE/일자)를 #del 에 넣는다.
                   예전에는 여기서 VALID_YN='N' 으로 내리고 DESC 에 이력 꼬리를 붙였는데,
                   현업 요구(변경 전 기준정보는 삭제)로 **행 자체를 없앤다**. 실제 삭제는 9e.
                   (OPERATION 은 라인당 1:1 이라 매칭 조건에서 생략 — 기존 관례 유지) */
        -- 2026-10-01(#35): **구간을 일자로 펼친다.** 종전에는 `p.NO_WORK_DATE` 한 날만 넣어서,
        --   where 에 END_DATE 가 실린 여러 날 해제가 **첫날만** 반영됐다
        --   (dev 실측: 2~10일 구간 DELETE 조각 549건 — CRD-00104 450 · CRD-00003 86 · 보강 6 …).
        --   구간 정보가 없으면(where 에 END 없음) span=1 로 종전과 같다.
        INSERT INTO #del(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, opt_id, plan_id, src)
        SELECT p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112)
                   COLLATE DATABASE_DEFAULT,
               p.opt_id, p.plan_id, N'DELETE'
        FROM #p p
        JOIN #d d
          ON d.n < CASE WHEN TRY_CONVERT(date, p.W_END_DATE, 112) IS NOT NULL
                         AND DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                           TRY_CONVERT(date, p.W_END_DATE,  112)) BETWEEN 1 AND 366
                        THEN DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                           TRY_CONVERT(date, p.W_END_DATE,  112))
                        ELSE 1 END
        WHERE p.op = 'DELETE';
        /* 7 종료. */

        /* 8 시작: UPDATE 패치 반영 — 기존 무가동 행의 OFF_TIME(무가동 초) 갱신 + 사유/이력 기록.
           ┌ agg CTE: 같은 (DIV/PLANT/LINE/일자)에 여러 카드가 걸리면 충돌 →
           │          ROW_NUMBER(ORDER BY OFF_TIME DESC, opt_id)로 'OFF가 가장 큰(=가장 강한 무가동) 카드' 1건 고정.
           ├ SET OFF_TIME=선정 카드값, VALID_YN='Y', ATTRIBUTE9=SNRO/카드(이력태그).
           └ DESC 전환: 이미 (SNRO) 표기 있으면 유지, 없으면 '기존DESC->사유(SNRO)'.
                        사유 = 그 카드의 SNRO_CARD lookup DESCRIPTION(예 공휴일 가동), 없으면 OFF=0→'가동'/else→'단축'. */
        /* 8-0: UPDATE(값 변경) 조각을 **일자로 펼친다.** (2026-10-01, #35)
                 종전 agg 는 `#p` 를 직접 읽어 `PARTITION BY … NO_WORK_DATE` 로 일자 대표 1건을 골랐다.
                 그래서 where 에 END_DATE 가 실린 여러 날 값 변경이 **첫날만** 반영됐다
                 (dev 실측: 2~5일 구간 UPDATE 조각 21건 — CRD-00103 신규라인 가동).
                 구간 정보가 없으면 span=1 로 종전과 같다. 이동 조각은 OFF_TIME 이 NULL 이라 여기 안 온다. */
        IF OBJECT_ID('tempdb..#pu') IS NOT NULL DROP TABLE #pu;
        SELECT p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112)
                   COLLATE DATABASE_DEFAULT AS NO_WORK_DATE,
               p.OFF_TIME, p.opt_id, p.plan_id
        INTO #pu
        FROM #p p
        JOIN #d d
          ON d.n < CASE WHEN TRY_CONVERT(date, p.W_END_DATE, 112) IS NOT NULL
                         AND DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                           TRY_CONVERT(date, p.W_END_DATE,  112)) BETWEEN 1 AND 366
                        THEN DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                           TRY_CONVERT(date, p.W_END_DATE,  112))
                        ELSE 1 END
        WHERE p.op = 'UPDATE' AND p.OFF_TIME IS NOT NULL;

        ;WITH agg AS (   -- 8-1: 라인/일자별 대표 카드(최대 OFF) 선정
            SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, OFF_TIME, opt_id, plan_id
            FROM (
                SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, OFF_TIME, opt_id, plan_id,
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE  -- 같은 라인/일자 묶음에서
                           ORDER BY OFF_TIME DESC, opt_id) AS rn                        -- OFF 큰 순(동률이면 카드코드)
                FROM #pu                      -- 2026-10-01(#35): 구간 전개본(8-0)을 읽는다
            ) z
            WHERE rn = 1   -- 대표 1건만
        )
        UPDATE nw
           SET nw.OFF_TIME   = a.OFF_TIME,
               nw.VALID_YN   = 'Y',
               nw.ATTRIBUTE9 = CONCAT(@SNRO_CD, N'/', a.opt_id),
               nw.[DESC] = dbo.FN_GET_SCP_OPMZ_DESC_HIST(nw.[DESC],   -- 최신 시나리오로 전환(원본 보존, 멱등)
                            ISNULL(
                                (SELECT TOP 1 ld.DESCRIPTION
                                 FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                 WHERE ld.LOOKUP_TYPE = N'SCP_OPMZ_SNRO_OPT'
                                   AND ld.SEGMENT1 = N'NO_WORK'
                                   AND ld.SEGMENT2 = a.opt_id
                                   AND ld.VALID_YN = N'Y'),
                                CASE WHEN a.OFF_TIME = 0 THEN N'가동' ELSE N'단축' END),
                            a.plan_id),
               nw.LAST_UPDATED_BY   = @uid,
               nw.LAST_UPDATE_DATE  = GETDATE()
        OUTPUT N'UPDATE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.OPERATION_ID, N'|', deleted.NO_WORK_DATE),
               CAST(deleted.OFF_TIME  AS nvarchar(100)),
               CAST(inserted.OFF_TIME AS nvarchar(100)),
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.LINE_TYPE, inserted.NO_WORK_DATE,   -- #35 상세용 쪼갠 키
               COALESCE(NULLIF(inserted.ATTRIBUTE2,N''), NULLIF(deleted.ATTRIBUTE2,N''), inserted.[DESC], deleted.[DESC])  -- 2026-10-02: 유형 폴백(원문)
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date, k_type)
        FROM dbo.SCP_OPMZ_NO_WORK nw
        JOIN agg a
            ON  nw.DIVISION_ID  = a.DIVISION_ID
            AND nw.PLANT_ID     = a.PLANT_ID
            AND nw.LINE_ID      = a.LINE_ID
            AND nw.NO_WORK_DATE = a.NO_WORK_DATE;
        SET @UPD = @@ROWCOUNT;

        -- 8b: 이번 실행에서 살아남아야 하는 키(UPDATE 가 DELETE 를 이긴다 — #keep 주석 참조).
        INSERT INTO #keep(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE)
        SELECT DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE
        FROM #p WHERE op = 'UPDATE' AND OFF_TIME IS NOT NULL AND MOVE_TO IS NULL;
        /* 8 종료. */

        /* 9 시작: 비조업일 "날짜 이동" 처리 (공사지연 / PM지연 유형).
           ┌ 배경: 공사지연·PM지연 카드는 기존 무가동일을 '없애는' 게 아니라 '뒤로 미룬다'.
           │       패치가 UPDATE인데 set에 START_DATE(새 날짜)만 있고 DAILY_VALUE가 없으면(=OFF량 불변)
           │       #p 구성 단계(step6)에서 MOVE_TO=set.START_DATE, OLD_DATE=where.START_DATE 로 채워둠.
           ├ 판정: op='UPDATE' AND MOVE_TO/OLD_DATE 둘 다 존재 AND 서로 다름(같으면 이동 아님).
           ├ 방식: NO_WORK의 PK에 NO_WORK_DATE가 포함돼 in-place 날짜변경 불가 →
           │       ① 구 날짜 행 값(OFF_TIME/OPERATION_ID/LINE_TYPE)을 그대로 승계해 새 날짜로 INSERT
           │       ② 구 날짜 행 DELETE  (순서 중요: INSERT를 먼저 해야 JOIN 대상 구 행이 살아있음)
           ├ 카드 다건: 같은 (DIV/PLANT/LINE/OLD_DATE/MOVE_TO) 조합에 카드가 겹치면 MAX(opt_id)=mopt_id 로 대표 1건.
           └ DESC 사유: '구날짜 -> 카드 lookup DESCRIPTION(SNRO)' (예: '20260701 -> 공사 지연(SNRO)').
                        어느 날짜에서 왔는지 + 왜 이동했는지를 한 줄로 남김. */
        IF OBJECT_ID('tempdb..#mv') IS NOT NULL DROP TABLE #mv;
        -- 9-0: 일자 전개용 숫자표 #d 는 **step 6b 에서 이미 만들었다**(2026-10-01, #35).
        --      네 경로가 같은 표를 쓴다 — 7(DELETE 전개)·8-0(UPDATE 전개)·9-1b(이동 전개)·9c-2·9d-2.

        /* 9-1: 이동 대상 집계 — **구간 끝까지 함께** 가져온다. (2026-10-01, GitLab #35)
           ┌ 왜 바뀌었나 ───────────────────────────────────────────────────────────────────────
           │ 엔진은 **구간 1행**을 옮긴다(`expectedRows:1`). 종전 9-1 은 `OLD_DATE`(where 시작일)와
           │ `MOVE_TO`(set 시작일) **한 쌍만** 집계해서, 12/3~12/6 → 4/14~4/17 이동이 **12/3 → 4/14
           │ 하나로** 반영됐다(2026-10-01 운영 확정 `SNRO-20260930-0005`/`CRD-00108`).
           │ 남은 구 날짜는 9d 역산이 `MOVE_TO IS NULL` 로 비켜가고, 새 날짜는 9c 전개가
           │ `op='INSERT'` 만 보니 아무도 만들지 않았다. `NOAPPLY=0` 이라 조용히 사라졌다.
           └ 이제 `W_END_DATE`(원본 끝)·`END_DATE`(새 끝)를 함께 들고 9-1b 에서 일자로 펼친다. */
        IF OBJECT_ID('tempdb..#mv0') IS NOT NULL DROP TABLE #mv0;
        SELECT g.*,
               -- span: 전개할 일수. **두 구간 길이가 같고 1~366일일 때만** 값이 들어간다.
               --       다르거나 구간 정보가 없으면(옛 계약 패치는 where 에 END 가 없다) NULL →
               --       9-1b 가 첫날 한 쌍만 옮기고 **사유를 로그로 남긴다**(조용히 사라지지 않게).
               CASE WHEN TRY_CONVERT(date, g.O_END, 112) IS NOT NULL
                     AND TRY_CONVERT(date, g.A_END, 112) IS NOT NULL
                     AND DATEDIFF(day, TRY_CONVERT(date, g.OLD_DATE, 112), TRY_CONVERT(date, g.O_END, 112))
                       = DATEDIFF(day, TRY_CONVERT(date, g.MOVE_TO,  112), TRY_CONVERT(date, g.A_END, 112))
                     AND DATEDIFF(day, TRY_CONVERT(date, g.OLD_DATE, 112), TRY_CONVERT(date, g.O_END, 112))
                         BETWEEN 1 AND 366
                    THEN DATEDIFF(day, TRY_CONVERT(date, g.OLD_DATE, 112), TRY_CONVERT(date, g.O_END, 112))
               END AS span
        INTO #mv0
        FROM (
            SELECT DIVISION_ID, PLANT_ID, LINE_ID, OLD_DATE, MOVE_TO,
                   W_END_DATE AS O_END,      -- where.END_DATE = 원본 구간 끝(배타)
                   END_DATE   AS A_END,      -- set.END_DATE   = 옮겨간 구간 끝(배타)
                   MAX(opt_id) AS mopt_id, MAX(plan_id) AS mplan_id
            FROM #p
            WHERE op = 'UPDATE' AND MOVE_TO IS NOT NULL AND OLD_DATE IS NOT NULL AND MOVE_TO <> OLD_DATE
            GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OLD_DATE, MOVE_TO, W_END_DATE, END_DATE
        ) g;

        -- 9-1b: 구간을 **일자 쌍**으로 펼친다. span 이 있으면 n=0..span-1, 없으면 첫날 한 쌍만.
        --       아래 9-2(새 날짜 INSERT)·9-2b(#keep)·9-3(구 날짜 삭제)는 #mv 를 그대로 쓰므로
        --       여기서 펼치면 세 곳이 자동으로 전 구간을 따라온다.
        IF OBJECT_ID('tempdb..#mv') IS NOT NULL DROP TABLE #mv;
        SELECT m.DIVISION_ID, m.PLANT_ID, m.LINE_ID,
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, m.OLD_DATE, 112)), 112)
                   COLLATE DATABASE_DEFAULT AS OLD_DATE,
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, m.MOVE_TO,  112)), 112)
                   COLLATE DATABASE_DEFAULT AS MOVE_TO,
               m.mopt_id, m.mplan_id
        INTO #mv
        FROM #mv0 m
        JOIN #d d ON d.n < m.span
        WHERE m.span IS NOT NULL
        UNION ALL
        SELECT m.DIVISION_ID, m.PLANT_ID, m.LINE_ID,
               m.OLD_DATE COLLATE DATABASE_DEFAULT, m.MOVE_TO COLLATE DATABASE_DEFAULT,
               m.mopt_id, m.mplan_id
        FROM #mv0 m
        WHERE m.span IS NULL;

        -- 9-1c: 구간을 못 펼친 이동은 **사유를 남긴다.** 첫날만 옮겨지므로 조용한 손실이 되면 안 된다.
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date)
        SELECT N'NOAPPLY',
               CONCAT(m.DIVISION_ID, N'|', m.PLANT_ID, N'|', m.LINE_ID, N'|', N'|', m.OLD_DATE),
               NULL, NULL,
               CONCAT(N'MOVE_RANGE_SKIP(구간 미전개 — 첫날만 이동: 원본 ',
                      ISNULL(m.OLD_DATE, N'?'), N'~', ISNULL(m.O_END, N'?'),
                      N' / 이동 ', ISNULL(m.MOVE_TO, N'?'), N'~', ISNULL(m.A_END, N'?'), N')'),
               m.DIVISION_ID, m.PLANT_ID, m.LINE_ID, NULL, NULL, m.OLD_DATE   -- #35 상세용 키
        FROM #mv0 m
        WHERE m.span IS NULL
          -- **옮길 구간이 2일 이상임이 드러난 경우만** 남긴다. 하루 이동은 첫날 한 쌍이 전부여서
          -- 전개할 것이 없다 — 거기까지 로그를 내면 정상 동작에 거짓 경고가 붙는다
          -- (2026-10-01 dev 실측: 조교대 CRD-00002 이동 83건이 전부 set 구간 1일이고 where 에 END 가 없다).
          AND ( (TRY_CONVERT(date, m.A_END, 112) IS NOT NULL
                 AND DATEDIFF(day, TRY_CONVERT(date, m.MOVE_TO,  112), TRY_CONVERT(date, m.A_END, 112)) > 1)
             OR (TRY_CONVERT(date, m.O_END, 112) IS NOT NULL
                 AND DATEDIFF(day, TRY_CONVERT(date, m.OLD_DATE, 112), TRY_CONVERT(date, m.O_END, 112)) > 1) );
        SET @NOAPPLY = @NOAPPLY + @@ROWCOUNT;

        INSERT INTO dbo.SCP_OPMZ_NO_WORK
            (DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, NO_WORK_DATE, OFF_TIME, [DESC], VALID_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, LINE_TYPE,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        OUTPUT N'INSERT',
               CONCAT(inserted.DIVISION_ID, N'|', inserted.PLANT_ID, N'|', inserted.LINE_ID, N'|',
                      inserted.OPERATION_ID, N'|', inserted.NO_WORK_DATE),
               NULL,
               CAST(inserted.OFF_TIME AS nvarchar(100)),
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.LINE_TYPE, inserted.NO_WORK_DATE,   -- #35 상세용 쪼갠 키
               COALESCE(NULLIF(inserted.ATTRIBUTE2,N''), inserted.[DESC])   -- 2026-10-02: 유형 폴백(원문)
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date, k_type)
        -- 9-2: 새 날짜 행 INSERT — 구 행(nw)의 기준 데이터 그대로 승계 + DESC='구날짜 -> 사유(SNRO)'.
        --      ATTRIBUTE1~8,10 = 구 행 값 승계(기준데이터), ATTRIBUTE9만 우리 이력태그(SNRO/카드)로 덮어씀.
        --      NOT EXISTS: 새 날짜에 동일 키(OP/라인/일자) 행이 이미 있으면 중복 INSERT 방지.
        SELECT nw.DIVISION_ID, nw.PLANT_ID, nw.LINE_ID, nw.OPERATION_ID, mv.MOVE_TO, nw.OFF_TIME,
               CONCAT(mv.OLD_DATE, N' -> ',                          -- 구 날짜(어디서 이동했는지)
                      ISNULL((SELECT TOP 1 ld.DESCRIPTION            -- 사유 = 이동카드의 lookup DESCRIPTION
                              FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                              WHERE ld.LOOKUP_TYPE = N'SCP_OPMZ_SNRO_OPT'
                                AND ld.SEGMENT1 = N'NO_WORK'
                                AND ld.SEGMENT2 = mv.mopt_id
                                AND ld.VALID_YN = N'Y'), N'NO WORK MOVE'),  -- lookup 없으면 폴백
                      CONCAT(N' (', mv.mplan_id, N')')), 'Y',
               @uid, GETDATE(), @uid, GETDATE(),
               nw.LINE_TYPE,
               nw.ATTRIBUTE1, nw.ATTRIBUTE2, nw.ATTRIBUTE3, nw.ATTRIBUTE4, nw.ATTRIBUTE5,  -- 기준데이터 승계
               nw.ATTRIBUTE6, nw.ATTRIBUTE7, nw.ATTRIBUTE8,                                 -- 기준데이터 승계
               CONCAT(@SNRO_CD, N'/', mv.mopt_id),                    -- ATTRIBUTE9 = 우리 이력태그(SNRO/카드)
               nw.ATTRIBUTE10                                        -- 기준데이터 승계
        FROM #mv mv
        JOIN dbo.SCP_OPMZ_NO_WORK nw
            ON  nw.DIVISION_ID  = mv.DIVISION_ID
            AND nw.PLANT_ID     = mv.PLANT_ID
            AND nw.LINE_ID      = mv.LINE_ID
            AND nw.NO_WORK_DATE = mv.OLD_DATE
        WHERE NOT EXISTS (
            SELECT 1
            FROM dbo.SCP_OPMZ_NO_WORK x
            WHERE x.DIVISION_ID  = nw.DIVISION_ID
              AND x.PLANT_ID     = nw.PLANT_ID
              AND x.LINE_ID      = nw.LINE_ID
              AND x.OPERATION_ID = nw.OPERATION_ID
              AND x.NO_WORK_DATE = mv.MOVE_TO
        );
        SET @INS = @@ROWCOUNT;   -- 날짜이동 신규행. 이 줄이 없으면 아래 12단계 건수에서 통째로 빠진다.

        -- 9-2b: 이동으로 새로 생긴 날짜는 살아남아야 한다(다른 카드의 DELETE 와 겹칠 수 있다).
        INSERT INTO #keep(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE)
        SELECT DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, MOVE_TO FROM #mv;

        -- 9-3: 이동 원본(구 날짜)은 **삭제 대상**이다. (2026-09-18 #27: 소프트 삭제 폐기)
        --      9-2 의 INSERT 가 구 행에서 값을 승계하므로 실제 삭제는 그 뒤여야 한다 → 9e 에서 한다.
        --      요구서 예시가 정확히 이 경우다: "10/1 공휴일 → 10/5 로 이동했을 때 10/1 은 삭제".
        INSERT INTO #del(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, opt_id, plan_id, src)
        SELECT mv.DIVISION_ID, mv.PLANT_ID, mv.LINE_ID, mv.OLD_DATE, mv.mopt_id, mv.mplan_id, N'MOVE'
        FROM #mv mv;

        /* 9 종료: 날짜 이동(INSERT 새날짜 + 구날짜 삭제대상 등록) 완료. */

        /* 9c 시작: **INSERT 패치 반영** — 캘린더 신규 구간행을 비조업 일자로 펼친다. (2026-09-18)
           ┌ 배경: 엔진은 캘린더 구간을 쪼갤 때 원본행 UPDATE 와 함께 **새 구간행(op='INSERT')** 을 낸다
           │       (availability 의 CALENDAR_CARVE / move 의 DELETE_INSERT·RELOCATE_SPLIT /
           │        신규라인 NEWLINE_COMPOSITE — 엔진의 _new_calendar_row 가 만드는 행).
           │       7~9 는 DELETE/UPDATE 만 받아 그 신규 구간을 통째로 버렸다. 특히 DELETE_INSERT
           │       (CRD-00002·CRD-00107 이동)는 구 날짜만 해제되고 새 날짜가 안 생겨 **비조업이 사라졌다**.
           ├ 계약차: 캘린더는 **구간** 한 행([START_DATE, END_DATE) 반열림), NO_WORK 은 **하루** 한 행.
           │        그래서 구간을 일자로 펼친다. END_DATE 는 배타라 그 날은 포함하지 않는다.
           ├ 방향 제한: **비조업을 만드는 방향(OFF_TIME>0)만 반영한다.**
           │        INSERT 패치는 where 가 비어 있어(신규행이라 엔진이 전/후 비교를 안 실어 준다)
           │        "값이 바뀐 조각"과 "원본값 그대로인 나머지 조각"을 패치만 보고 가를 수 없다.
           │        OFF_TIME=0(종일 가동) 조각까지 반영하면 엔진 seed 에 없는 다른 사유의 무가동 행을
           │        지우게 된다. 가동 해제 방향은 엔진이 DELETE 패치로 내므로 step7 이 이미 맡는다.
           ├ 상한: 한 조각 366일. 넘거나 날짜가 안 읽히면 반영하지 않고 NOAPPLY 로 남긴다.
           └ 멱등: 같은 (DIV/PLANT/LINE/일자) 행이 있으면 UPDATE, 없으면 INSERT.
                   재실행하면 UPDATE 경로로 같은 값이 들어가 결과가 같다. */

        -- 9c-1: 일자 전개용 숫자표 #d 는 **step 9-0 에서 이미 만들었다**(2026-10-01, #35).
        --       이동 전개(9-1b)·INSERT 전개(9c-2)·역산(9d-2) 세 곳이 같은 표를 쓴다.

        -- 9c-2: op='INSERT' 조각을 일자로 펼친다. START 포함 ~ END 배타.
        IF OBJECT_ID('tempdb..#pins') IS NOT NULL DROP TABLE #pins;
        SELECT p.opt_id, p.plan_id, p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
               p.NO_WORK_DATE AS SEG_START,                                        -- 조각 식별용(어느 조각에서 나왔나)
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112)
                   COLLATE DATABASE_DEFAULT AS NO_WORK_DATE,
               p.OFF_TIME,
               p.NO_WORK_TYPE, p.NO_WORK_RATIO
        INTO #pins
        FROM #p p
        JOIN #d d
          ON  d.n < DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                  TRY_CONVERT(date, p.END_DATE,     112))
        WHERE p.op = 'INSERT'
          -- 2026-09-18(#27): OFF>0 필터를 여기서 걸지 않는다. 9d 역산이 "이 날을 조각이 덮는가" 를
          --                  판정할 때 가동(OFF=0) 조각도 덮는 것으로 세어야 하기 때문이다.
          --                  비조업 방향만 반영하는 제한은 9c-3 으로 내렸다.
          AND TRY_CONVERT(date, p.NO_WORK_DATE, 112) IS NOT NULL
          AND TRY_CONVERT(date, p.END_DATE,     112) IS NOT NULL
          AND DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                            TRY_CONVERT(date, p.END_DATE,     112)) BETWEEN 1 AND 366;

        -- 9c-3: 같은 (DIV/PLANT/LINE/일자)에 카드가 겹치면 대표 1건. step8 과 같은 규칙(OFF 큰 순, 동률이면 카드코드).
        IF OBJECT_ID('tempdb..#pi') IS NOT NULL DROP TABLE #pi;
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, OFF_TIME, opt_id, plan_id, NO_WORK_TYPE, NO_WORK_RATIO
        INTO #pi
        FROM (
            SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, OFF_TIME, opt_id, plan_id, NO_WORK_TYPE, NO_WORK_RATIO,
                   ROW_NUMBER() OVER (
                       PARTITION BY DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE
                       ORDER BY OFF_TIME DESC, opt_id) AS rn
            FROM #pins
            WHERE OFF_TIME > 0                      -- 비조업 방향만 반영(가동 조각은 9d 가 해제로 다룬다)
        ) z
        WHERE rn = 1;

        -- 9c-4: 이미 그 일자 행이 있으면 갱신(신규 INSERT 가 아니라 UPDATE 로 간다 — 멱등의 핵심).
        UPDATE nw
           SET nw.OFF_TIME         = i.OFF_TIME,
               nw.VALID_YN         = 'Y',
               -- 2026-10-01: **복수 비조업이면 첫 사유 하나만** 넣는다(사용자 결정).
               --   이 칸은 고객사 화면이 유형으로 표시하는 자리라 콤마값이 그대로 노출되면 곤란하다.
               --   전체 사유는 [DESC] 가 들고 있고(아래), 그쪽이 엔진 ATTRIBUTE13 왕복의 정본이다.
               --   SM 이 복수 표시를 지원하면 이 제한을 걷는다.
               nw.ATTRIBUTE2       = COALESCE(
                                        NULLIF(LEFT(LTRIM(RTRIM(i.NO_WORK_TYPE)),
                                                    CHARINDEX(N',', LTRIM(RTRIM(i.NO_WORK_TYPE)) + N',') - 1), N''),
                                        nw.ATTRIBUTE2),                                 -- 유형 첫 사유(화면 표시 칸)
               nw.ATTRIBUTE9       = CONCAT(@SNRO_CD, N'/', i.opt_id),
               nw.[DESC]           = dbo.FN_GET_SCP_OPMZ_DESC_HIST(nw.[DESC],
                                          COALESCE(NULLIF(CASE WHEN NULLIF(LTRIM(RTRIM(i.NO_WORK_RATIO)), N'') IS NOT NULL
                         THEN CONCAT(LTRIM(RTRIM(i.NO_WORK_TYPE)), N' (', LTRIM(RTRIM(i.NO_WORK_RATIO)), N')')
                         ELSE LTRIM(RTRIM(i.NO_WORK_TYPE)) END, N''),   -- 2026-09-29 유형 우선 · 2026-10-01 비율 동반
                                          ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                                  WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'NO_WORK'
                                                    AND ld.SEGMENT2=i.opt_id AND ld.VALID_YN=N'Y'), N'단축')), i.plan_id),
               nw.LAST_UPDATED_BY  = @uid,
               nw.LAST_UPDATE_DATE = GETDATE()
        OUTPUT N'UPDATE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.OPERATION_ID, N'|', deleted.NO_WORK_DATE),
               CAST(deleted.OFF_TIME  AS nvarchar(100)),
               CAST(inserted.OFF_TIME AS nvarchar(100)),
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.LINE_TYPE, inserted.NO_WORK_DATE,   -- #35 상세용 쪼갠 키
               COALESCE(NULLIF(inserted.ATTRIBUTE2,N''), NULLIF(deleted.ATTRIBUTE2,N''), inserted.[DESC], deleted.[DESC])  -- 2026-10-02: 유형 폴백(원문)
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date, k_type)
        FROM dbo.SCP_OPMZ_NO_WORK nw
        JOIN #pi i
            ON  nw.DIVISION_ID  = i.DIVISION_ID
            AND nw.PLANT_ID     = i.PLANT_ID
            AND nw.LINE_ID      = i.LINE_ID
            AND nw.NO_WORK_DATE = i.NO_WORK_DATE;
        SET @UPD = @UPD + @@ROWCOUNT;

        -- 9c-5: 신규 일자의 기준데이터 승계원 — 같은 라인의 기존 무가동 행 중 가장 최근 것 1건.
        --       LINE_TYPE·ATTRIBUTE1~8,10 은 우리가 만들 수 없는 기준데이터라 승계한다(step9-2 와 같은 관례).
        --       OPERATION_ID 는 라인 룩업(SEGMENT4)이 권위이고, 없으면 승계원 값을 쓴다.
        IF OBJECT_ID('tempdb..#nwsrc') IS NOT NULL DROP TABLE #nwsrc;
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE10
        INTO #nwsrc
        FROM (
            SELECT nw.DIVISION_ID, nw.PLANT_ID, nw.LINE_ID, nw.OPERATION_ID, nw.LINE_TYPE,
                   nw.ATTRIBUTE1, nw.ATTRIBUTE2, nw.ATTRIBUTE3, nw.ATTRIBUTE4, nw.ATTRIBUTE5,
                   nw.ATTRIBUTE6, nw.ATTRIBUTE7, nw.ATTRIBUTE8, nw.ATTRIBUTE10,
                   ROW_NUMBER() OVER (PARTITION BY nw.DIVISION_ID, nw.PLANT_ID, nw.LINE_ID
                                      ORDER BY nw.NO_WORK_DATE DESC) AS rn
            FROM dbo.SCP_OPMZ_NO_WORK nw
            WHERE EXISTS (SELECT 1 FROM #pi i
                          WHERE i.DIVISION_ID = nw.DIVISION_ID
                            AND i.PLANT_ID    = nw.PLANT_ID
                            AND i.LINE_ID     = nw.LINE_ID)
        ) z
        WHERE rn = 1;

        -- 9c-6: 없는 일자를 새로 넣는다. NOT EXISTS 로 중복 방어(9c-4 가 이미 잡은 행은 여기 안 온다).
        INSERT INTO dbo.SCP_OPMZ_NO_WORK
            (DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, NO_WORK_DATE, OFF_TIME, [DESC], VALID_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, LINE_TYPE,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        OUTPUT N'INSERT',
               CONCAT(inserted.DIVISION_ID, N'|', inserted.PLANT_ID, N'|', inserted.LINE_ID, N'|',
                      inserted.OPERATION_ID, N'|', inserted.NO_WORK_DATE),
               NULL,
               CAST(inserted.OFF_TIME AS nvarchar(100)),
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID,
               inserted.OPERATION_ID, inserted.LINE_TYPE, inserted.NO_WORK_DATE,   -- #35 상세용 쪼갠 키
               COALESCE(NULLIF(inserted.ATTRIBUTE2,N''), inserted.[DESC])   -- 2026-10-02: 유형 폴백(원문)
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date, k_type)
        SELECT i.DIVISION_ID, i.PLANT_ID, i.LINE_ID,
               COALESCE(lo.SEGMENT4 COLLATE DATABASE_DEFAULT, s.OPERATION_ID),   -- 라인 룩업(SEG4) 우선, 없으면 승계
               i.NO_WORK_DATE, i.OFF_TIME,
               -- 2026-09-29 유형 관통: 조각에 유형(ATTRIBUTE13)이 실려 오면 [DESC] = 유형 그대로.
               --   다음 plan 적재 때 엔진이 ATTRIBUTE13 = NO_WORK.[DESC] 를 복사하므로, 태그를 붙이면
               --   유형 분류(별칭표)가 깨진다. 출처는 ATTRIBUTE9(SNRO/카드 태그)가 이미 담당한다.
               -- 2026-10-01: 비율이 실려 오면 **[DESC] 에 함께 보여 준다** — `공휴일,공사 (0.5,0.5)`.
               --   기준정보에는 비율을 담을 칸이 아직 없다(ATTRIBUTE1~10 뿐). 화면에서 지금 보이게 하는
               --   임시 조치다(사용자 결정). 유형 부분은 **원문 그대로** 두고 괄호만 덧붙인다.
               --   ⚠ 우리 dev 는 구버전 입력 프로시저라 [DESC] 가 엔진 ATTRIBUTE13(유형)으로 복사된다 —
               --     거기선 이 괄호가 유형 파싱을 흔든다. 내부망 신버전은 [DESC] → ATTRIBUTE12(설명)라 무해.
               COALESCE(NULLIF(CASE WHEN NULLIF(LTRIM(RTRIM(i.NO_WORK_RATIO)), N'') IS NOT NULL
                         THEN CONCAT(LTRIM(RTRIM(i.NO_WORK_TYPE)), N' (', LTRIM(RTRIM(i.NO_WORK_RATIO)), N')')
                         ELSE LTRIM(RTRIM(i.NO_WORK_TYPE)) END, N''),
               CONCAT(ISNULL((SELECT TOP 1 ld.DESCRIPTION                        -- 사유 = 카드 lookup DESCRIPTION
                              FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                              WHERE ld.LOOKUP_TYPE = N'SCP_OPMZ_SNRO_OPT'
                                AND ld.SEGMENT1 = N'NO_WORK'
                                AND ld.SEGMENT2 = i.opt_id
                                AND ld.VALID_YN = N'Y'), N'단축'),
                      CONCAT(N' (', i.plan_id, N')'))), 'Y',
               @uid, GETDATE(), @uid, GETDATE(),
               s.LINE_TYPE,
               s.ATTRIBUTE1,
               -- 2026-10-01: 복수 비조업이면 **첫 사유 하나만**(위 9c-4 와 같은 규칙). 전체는 [DESC] 에
               COALESCE(NULLIF(LEFT(LTRIM(RTRIM(i.NO_WORK_TYPE)),
                                    CHARINDEX(N',', LTRIM(RTRIM(i.NO_WORK_TYPE)) + N',') - 1), N''),
                        s.ATTRIBUTE2),                                                  -- ATTRIBUTE2 = 첫 사유. 없으면 승계
               s.ATTRIBUTE3, s.ATTRIBUTE4, s.ATTRIBUTE5,                                -- 기준데이터 승계
               s.ATTRIBUTE6, s.ATTRIBUTE7, s.ATTRIBUTE8,                                -- 기준데이터 승계
               CONCAT(@SNRO_CD, N'/', i.opt_id),                                        -- ATTRIBUTE9 = 이력태그
               s.ATTRIBUTE10                                                            -- 기준데이터 승계
        FROM #pi i
        JOIN #nwsrc s
            ON  s.DIVISION_ID = i.DIVISION_ID
            AND s.PLANT_ID    = i.PLANT_ID
            AND s.LINE_ID     = i.LINE_ID
        LEFT JOIN dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL lo
            ON  lo.LOOKUP_TYPE = N'SCP_OPMZ_LINE_OPERATION' AND lo.VALID_YN = 'Y'
            AND lo.SEGMENT3 = i.LINE_ID COLLATE DATABASE_DEFAULT
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.SCP_OPMZ_NO_WORK x
            WHERE x.DIVISION_ID  = i.DIVISION_ID
              AND x.PLANT_ID     = i.PLANT_ID
              AND x.LINE_ID      = i.LINE_ID
              AND x.NO_WORK_DATE = i.NO_WORK_DATE
        );
        SET @INS = @INS + @@ROWCOUNT;

        -- 9c-7: 미반영 로그 ① 승계원이 없어 신규 일자를 못 만든 건(그 라인에 기존 무가동 행이 하나도 없다).
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date)
        SELECT N'NOAPPLY',
               CONCAT(i.DIVISION_ID, N'|', i.PLANT_ID, N'|', i.LINE_ID, N'|', N'|', i.NO_WORK_DATE),
               NULL, NULL, N'NOSRC(INSERT 기준데이터 승계원 없음)',
               i.DIVISION_ID, i.PLANT_ID, i.LINE_ID, NULL, NULL, i.NO_WORK_DATE   -- #35 상세용 키
        FROM #pi i
        WHERE NOT EXISTS (SELECT 1 FROM #nwsrc s
                          WHERE s.DIVISION_ID = i.DIVISION_ID AND s.PLANT_ID = i.PLANT_ID
                            AND s.LINE_ID     = i.LINE_ID)
          AND NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_NO_WORK x
                          WHERE x.DIVISION_ID  = i.DIVISION_ID AND x.PLANT_ID = i.PLANT_ID
                            AND x.LINE_ID      = i.LINE_ID     AND x.NO_WORK_DATE = i.NO_WORK_DATE);
        SET @NOAPPLY = @NOAPPLY + @@ROWCOUNT;

        -- 9c-8: 미반영 로그 ② 아예 펼치지 않은 조각(가동 구간 / 구간이 비었거나 366일 초과 / 날짜 해석 실패).
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date)
        SELECT N'NOAPPLY',
               CONCAT(p.DIVISION_ID, N'|', p.PLANT_ID, N'|', p.LINE_ID, N'|', N'|', p.NO_WORK_DATE),
               NULL, NULL,
               CASE WHEN p.OFF_TIME IS NULL OR p.OFF_TIME <= 0
                    THEN N'SKIP_INSERT(가동 구간 — 해제는 DELETE 패치가 맡는다)'
                    ELSE N'SKIP_INSERT(구간 없음/366일 초과/날짜 해석 실패)' END,
               p.DIVISION_ID, p.PLANT_ID, p.LINE_ID, NULL, NULL, p.NO_WORK_DATE   -- #35 상세용 키
        FROM #p p
        WHERE p.op = 'INSERT'
          AND NOT EXISTS (SELECT 1 FROM #pins q
                          WHERE q.DIVISION_ID = p.DIVISION_ID AND q.PLANT_ID = p.PLANT_ID
                            AND q.LINE_ID     = p.LINE_ID     AND q.SEG_START = p.NO_WORK_DATE
                            AND q.opt_id      = p.opt_id);
        SET @NOAPPLY = @NOAPPLY + @@ROWCOUNT;
        /* 9c 종료: INSERT 패치 반영 완료. */

        -- 9c-9: 9c 가 실제로 반영한 일자는 살아남아야 한다.
        INSERT INTO #keep(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE)
        SELECT DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE FROM #pi;

        /* 9d 시작: **역산으로 "없어진 날" 을 찾는다.** (2026-09-18, GitLab #27 ①)
           ┌ 왜 필요한가 ───────────────────────────────────────────────────────────────────────
           │ 현업이 캘린더에서 비조업을 **지우면**(예: 10/1 공사 삭제) 엔진은 그 날을 구간에서
           │ 빼면서 원본행을 쪼갠다. 원본 구간이 여러 날이면 결과가
           │     원본 UPDATE(END 축소) + 나머지 INSERT
           │ 이고 **DELETE 패치가 나오지 않는다** (DELETE 는 원본 구간이 통째로 없어질 때만 난다).
           │ 그래서 op 만 보면 삭제를 감지할 수 없었다 — 그 날 무가동 행이 그대로 남았다.
           ├ 어떻게 푸는가 ─────────────────────────────────────────────────────────────────────
           │ UPDATE 패치의 **where 에 원본 START_DATE·END_DATE 가 그대로 실린다.** 그 원본 구간에서
           │ after-image(원본 UPDATE 조각 + 같은 라인의 INSERT 조각들)가 덮지 않는 날을 빼면
           │ **제거된 날**이 나온다. 그 날이 삭제 대상이다.
           │     원본  [w_start, w_end)          ← where
           │     after [w_start, set.END)        ← 원본행이 줄어든 만큼
           │           + INSERT 조각들           ← 쪼개져 나온 나머지
           │     제거된 날 = 원본 − after − INSERT조각
           ├ 날짜이동은 제외한다 — step9 가 이미 구/새 날짜를 짝지어 처리한다(MOVE_TO IS NOT NULL).
           ├ 옛 계약 패치는 건너뛴다 — where 에 END_DATE 가 없으면 원본 구간을 모른다(W_END_DATE NULL).
           └ 상한 366일. 넘거나 날짜가 안 읽히면 역산하지 않는다(구간 오염 방어). */

        -- 9d-1: 역산 대상 원본 구간. A_END = after 구간의 끝(set.END_DATE 가 있으면 그것, 없으면 원본 그대로).
        IF OBJECT_ID('tempdb..#orig') IS NOT NULL DROP TABLE #orig;
        SELECT p.opt_id, p.plan_id, p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
               p.OLD_DATE                        AS O_START,   -- where.START_DATE = 원본 구간 시작
               p.W_END_DATE                      AS O_END,     -- where.END_DATE   = 원본 구간 끝(배타)
               COALESCE(p.END_DATE, p.W_END_DATE) AS A_END      -- set.END_DATE 우선 = 줄어든 끝(배타)
        INTO #orig
        FROM #p p
        WHERE p.op = 'UPDATE'
          AND p.MOVE_TO   IS NULL          -- 날짜이동은 step9 담당
          AND p.OLD_DATE  IS NOT NULL
          AND p.W_END_DATE IS NOT NULL     -- 옛 계약 패치(where 에 END 없음)는 역산 불가
          AND TRY_CONVERT(date, p.OLD_DATE,   112) IS NOT NULL
          AND TRY_CONVERT(date, p.W_END_DATE, 112) IS NOT NULL
          AND DATEDIFF(day, TRY_CONVERT(date, p.OLD_DATE, 112),
                            TRY_CONVERT(date, p.W_END_DATE, 112)) BETWEEN 1 AND 366;

        -- 9d-2: 원본 구간을 일자로 펼친다(9c-1 의 #d 재사용). START 포함 ~ END 배타.
        IF OBJECT_ID('tempdb..#origd') IS NOT NULL DROP TABLE #origd;
        SELECT o.opt_id, o.plan_id, o.DIVISION_ID, o.PLANT_ID, o.LINE_ID, o.A_END,
               CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, o.O_START, 112)), 112)
                   COLLATE DATABASE_DEFAULT AS DAY_
        INTO #origd
        FROM #orig o
        JOIN #d d ON d.n < DATEDIFF(day, TRY_CONVERT(date, o.O_START, 112),
                                         TRY_CONVERT(date, o.O_END,   112));

        -- 9d-3: 제거된 날 = after 구간 밖 ∧ 어떤 INSERT 조각도 덮지 않음 → 삭제 대상.
        --       #pins 는 9c-2 가 만든 **모든** INSERT 조각의 일자 전개다(가동 조각 포함).
        INSERT INTO #del(DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE, opt_id, plan_id, src)
        SELECT od.DIVISION_ID, od.PLANT_ID, od.LINE_ID, od.DAY_, od.opt_id, od.plan_id, N'CARVE'
        FROM #origd od
        WHERE od.DAY_ >= od.A_END
          AND NOT EXISTS (SELECT 1 FROM #pins q
                          WHERE q.DIVISION_ID = od.DIVISION_ID AND q.PLANT_ID = od.PLANT_ID
                            AND q.LINE_ID     = od.LINE_ID     AND q.NO_WORK_DATE = od.DAY_);
        /* 9d 종료. */

        /* 9b 시작: 미반영(NOAPPLY) 로그 — 값을 조용히 버리지 않고 사유와 함께 남긴다.
                    ★ 2026-09-18(#27): **9e(실제 삭제) 앞에 둔다.** 물리 삭제로 바뀌면서, 9e 뒤에
                      두면 방금 지운 행을 "매칭 대상 없음" 으로 오인해 성공한 삭제가 NOAPPLY 로
                      잡힌다(②의 이동 판정도 구 날짜 행 EXISTS 를 전제로 한다).
                    ① 비이동(UPDATE/DELETE): (DIV/PLANT/LINE/일자) 매칭 무가동 행이 없어 0건.
                    ② 이동(MOVE): 옮길 원본(구 날짜) 무가동 행이 없어 이동 INSERT가 0건.
                       (성공한 이동은 구 날짜 행이 VALID_N으로 남아 EXISTS → 로그 안 됨) */
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date)
        SELECT N'NOAPPLY',
               CONCAT(p.DIVISION_ID, N'|', p.PLANT_ID, N'|', p.LINE_ID, N'|', N'|', p.NO_WORK_DATE),
               NULL, NULL,
               CONCAT(N'NOMATCH(', p.op, N' 대상 무가동 행 없음)'),
               p.DIVISION_ID, p.PLANT_ID, p.LINE_ID, NULL, NULL, p.NO_WORK_DATE   -- #35 상세용 키
        FROM #p p
        WHERE p.MOVE_TO IS NULL
          AND p.op <> 'INSERT'          -- INSERT 조각의 미반영은 9c-7·9c-8 이 전담한다(여기선 매칭 행 없음이 정상)
          AND NOT EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_NO_WORK nw
                          WHERE nw.DIVISION_ID = p.DIVISION_ID AND nw.PLANT_ID = p.PLANT_ID
                            AND nw.LINE_ID = p.LINE_ID AND nw.NO_WORK_DATE = p.NO_WORK_DATE);
        -- 2026-09-18: `=` 가 아니라 누적이다. 9c(-7·-8)가 이 앞에서 이미 @NOAPPLY 를 올려 두는데
        --             여기서 덮어쓰면 그 건수가 통째로 사라진다(#chg 로그만 남고 숫자가 안 맞는다).
        SET @NOAPPLY = @NOAPPLY + @@ROWCOUNT;

        -- ② 이동이지만 실제로 옮겨지지 않은 모든 건(원본 날짜 무가동 행 없음 / OLD_DATE 없음 / MOVE_TO=OLD_DATE)
        --    성공한 이동은 구 날짜 행이 VALID_N으로 남아 EXISTS → 제외. (RESOLVED = 적용 + NOAPPLY 정합 보장)
        INSERT INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date)
        SELECT N'NOAPPLY',
               CONCAT(p.DIVISION_ID, N'|', p.PLANT_ID, N'|', p.LINE_ID, N'|', N'|', ISNULL(p.OLD_DATE, p.NO_WORK_DATE)),
               NULL, NULL,
               N'NOMATCH_MOVE(이동 원본 무가동 행 없음/불가)',
               p.DIVISION_ID, p.PLANT_ID, p.LINE_ID, NULL, NULL,
               ISNULL(p.OLD_DATE, p.NO_WORK_DATE)                                 -- #35 상세용 키(rowkey 와 같은 규칙)
        FROM #p p
        WHERE p.MOVE_TO IS NOT NULL
          AND NOT ( p.OLD_DATE IS NOT NULL
                    AND p.MOVE_TO <> p.OLD_DATE
                    AND EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_NO_WORK nw
                                WHERE nw.DIVISION_ID = p.DIVISION_ID AND nw.PLANT_ID = p.PLANT_ID
                                  AND nw.LINE_ID = p.LINE_ID AND nw.NO_WORK_DATE = p.OLD_DATE) );
        SET @NOAPPLY = @NOAPPLY + @@ROWCOUNT;
        /* 9b 종료. */

        /* 9e 시작: **실제 삭제 — 여기 한 곳뿐이다.** (2026-09-18, GitLab #27 ②)
           7(해제) · 9-3(이동 원본) · 9d(역산)가 모은 #del 을 #keep 으로 거른 뒤 지운다.
           소프트 삭제(VALID_YN='N')를 쓰지 않는다 — 현업 요구는 행 자체를 없애는 것이다.
           **키 조인이 이 한 군데뿐이라** 나중에 NO_WORK 키가 늘어도(복수 비조업) 여기만 고치면 된다.
           멱등: 없는 행은 0건이다. 재실행해도 결과가 같다. */
        DELETE nw
        OUTPUT N'DELETE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.OPERATION_ID, N'|', deleted.NO_WORK_DATE),
               CAST(deleted.OFF_TIME AS nvarchar(100)),   -- 변경 전 OFF
               N'DELETED',                                 -- 변경 후 = 행 없음
               deleted.ATTRIBUTE9,                          -- 지워지는 행에 남아 있던 출처 태그
               deleted.DIVISION_ID, deleted.PLANT_ID, deleted.LINE_ID,
               deleted.OPERATION_ID, deleted.LINE_TYPE, deleted.NO_WORK_DATE,   -- #35 상세용 쪼갠 키
               COALESCE(NULLIF(deleted.ATTRIBUTE2,N''), deleted.[DESC])   -- 2026-10-02: 지워진 행의 유형(원문)
        INTO #chg(op, rowkey, bef, aft, tag, k_div, k_plant, k_line, k_opn, k_ltype, k_date, k_type)
        FROM dbo.SCP_OPMZ_NO_WORK nw
        JOIN (SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE FROM #del
              GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE) d
            ON  nw.DIVISION_ID  = d.DIVISION_ID
            AND nw.PLANT_ID     = d.PLANT_ID
            AND nw.LINE_ID      = d.LINE_ID
            AND nw.NO_WORK_DATE = d.NO_WORK_DATE
        WHERE NOT EXISTS (SELECT 1 FROM #keep k
                          WHERE k.DIVISION_ID  = nw.DIVISION_ID AND k.PLANT_ID = nw.PLANT_ID
                            AND k.LINE_ID      = nw.LINE_ID     AND k.NO_WORK_DATE = nw.NO_WORK_DATE);
        SET @DEL = @@ROWCOUNT;
        /* 9e 종료. */


        /* 10 시작: 행 단위 변경 이력 적재 — 위 7~9에서 #chg에 모은 실제 D/U/I 데이터를 건별로 SCM_SYS_LOG_BATCH에 기록.
                   ATTRIBUTE1=타겟테이블, 2=op, 3=SNRO, 4=태그(SNRO/카드), 5=rowkey, 6=before, 7=after.
                   (요약로그와 별개로, "어떤 행이 어떻게 바뀌었는지" 감사 추적용) */
        INSERT INTO dbo.SCM_SYS_LOG_BATCH
            (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7)
        SELECT N'PR_SCP_OPMZ_APPLY_NO_WORK',
               op,
               1,
               CONCAT(N'NO_WORK ', op),                                                        -- LOG_MESSAGE: 테이블 op 라벨
               CONCAT(N'key=', rowkey, N' | OFF ', ISNULL(bef,N'-'), N'->', ISNULL(aft,N'-')),   -- DESCRIPTION: key + 변경값
               GETDATE(), GETDATE(), @uid, GETDATE(), @uid,   -- 2026-09-30: 감사칸 둘을 비우지 않는다
               N'SCP_OPMZ_NO_WORK', op, @SNRO_CD, tag, rowkey, bef, aft
        FROM #chg;
        /* 10 종료. */

        /* 10-b 시작: **반영 이력 상세 적재** (2026-10-01, GitLab #35)
                      `#chg` 가 이미 기준정보 키 단위이므로 그대로 상세가 된다. 카드/계획/유형/사유는
                      여기서 `#p`·`#del` 과 **키 조인**으로 붙인다 — `INSERT ... OUTPUT` 절이 FROM 절
                      테이블을 참조할 수 없어(SQL Server 제약) 적재 자리에서 꺼내지 못했다.

                      ── 왜 TRY/CATCH 인가 ────────────────────────────────────────────────────────
                      상세는 **부가 기록**이다. 시노님이 없거나 권한이 없어도 반영 자체는 유효해야 한다.
                      여기서 예외를 올리면 성공한 반영이 실패로 보고되고, 사용자가 되돌릴 수 없는
                      동작을 한 번 더 누른다(이력 프로시저가 실패를 삼키는 것과 같은 이유).

                      ── HIS_SEQ 는 비워 둔다 ─────────────────────────────────────────────────────
                      이력 행은 앱이 **반영 성공 후** `PR_SCP_SNRO_MGE_MST_APPY` 로 따로 남긴다.
                      그 프로시저가 자기 구간의 `HIS_SEQ IS NULL` 행을 찾아 채운다. */
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
            ;WITH pk AS (   -- 조각을 **일자로 펼쳐** 키에 건다. 변경 구간과 기존 구간 양쪽 다.
                --   2026-10-01: 양식이 「기존 / 변경」 날짜를 각각 보여 주므로 조각의 네 날짜를 함께 든다.
                --   기존 = where(원본 구간) · 변경 = set 우선(#p.NO_WORK_DATE·END_DATE).
                --   ⚠ 구간을 펼치지 않으면 둘째 날 이후 상세가 meta 조인에 걸리지 않아 날짜·OP 가 빈다
                --     (step7·8·9-1b 가 기준정보는 전 구간에 적용하므로 상세만 비는 어긋남이 생긴다).
                SELECT p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112)
                           COLLATE DATABASE_DEFAULT AS kdate,
                       p.op, p.opt_id, p.plan_id, p.NO_WORK_TYPE, p.OFF_TIME,
                       /* 「기존/변경」도 **같은 offset 으로 펼친다**(2026-10-02). 종전에는 키 날짜만
                          펼치고 날짜 쌍은 조각 구간을 그대로 들고 가서, 여러 날 조각이면 **모든 줄이
                          똑같아 보였다**(dev 재현: 9일 공사 해제 → 8줄 전부 `20261213~20261221`).
                          화면은 키 날짜를 안 보여주므로 구별할 칸이 하나도 없었다.
                          dev 조각 분포상 98.8%가 하루짜리라 그동안 안 드러났다(여러 날 1,050건·최대 588일). */
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.OLD_DATE, 112)), 112) COLLATE DATABASE_DEFAULT AS b_from,
                       CONVERT(char(8), DATEADD(day, d.n + 1, TRY_CONVERT(date, p.OLD_DATE, 112)), 112) COLLATE DATABASE_DEFAULT AS b_to,
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112) COLLATE DATABASE_DEFAULT AS a_from,
                       CONVERT(char(8), DATEADD(day, d.n + 1, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112) COLLATE DATABASE_DEFAULT AS a_to
                FROM #p p
                JOIN #d d
                  ON d.n < CASE WHEN TRY_CONVERT(date, p.END_DATE, 112) IS NOT NULL
                                 AND DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                                   TRY_CONVERT(date, p.END_DATE,     112)) BETWEEN 1 AND 366
                                THEN DATEDIFF(day, TRY_CONVERT(date, p.NO_WORK_DATE, 112),
                                                   TRY_CONVERT(date, p.END_DATE,     112))
                                ELSE 1 END
                UNION ALL
                SELECT p.DIVISION_ID, p.PLANT_ID, p.LINE_ID,
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.OLD_DATE, 112)), 112)
                           COLLATE DATABASE_DEFAULT,
                       p.op, p.opt_id, p.plan_id, p.NO_WORK_TYPE, p.OFF_TIME,
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.OLD_DATE, 112)), 112) COLLATE DATABASE_DEFAULT,
                       CONVERT(char(8), DATEADD(day, d.n + 1, TRY_CONVERT(date, p.OLD_DATE, 112)), 112) COLLATE DATABASE_DEFAULT,
                       CONVERT(char(8), DATEADD(day, d.n, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112) COLLATE DATABASE_DEFAULT,
                       CONVERT(char(8), DATEADD(day, d.n + 1, TRY_CONVERT(date, p.NO_WORK_DATE, 112)), 112) COLLATE DATABASE_DEFAULT
                FROM #p p
                JOIN #d d
                  ON d.n < CASE WHEN TRY_CONVERT(date, p.W_END_DATE, 112) IS NOT NULL
                                 AND DATEDIFF(day, TRY_CONVERT(date, p.OLD_DATE,   112),
                                                   TRY_CONVERT(date, p.W_END_DATE, 112)) BETWEEN 1 AND 366
                                THEN DATEDIFF(day, TRY_CONVERT(date, p.OLD_DATE,   112),
                                                   TRY_CONVERT(date, p.W_END_DATE, 112))
                                ELSE 1 END
                WHERE p.OLD_DATE IS NOT NULL
            ),
            meta AS (   -- 키별 대표 조각 1건. step8·9c-3 과 **같은 규칙**(OFF 큰 순, 동률이면 카드코드)
                SELECT DIVISION_ID, PLANT_ID, LINE_ID, kdate, op, opt_id, plan_id, NO_WORK_TYPE,
                       b_from, b_to, a_from, a_to
                FROM (
                    SELECT DIVISION_ID, PLANT_ID, LINE_ID, kdate, op, opt_id, plan_id, NO_WORK_TYPE,
                           b_from, b_to, a_from, a_to,
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PLANT_ID, LINE_ID, kdate
                               ORDER BY ISNULL(OFF_TIME, 0) DESC, opt_id) AS rn
                    FROM pk
                ) z
                WHERE rn = 1
            ),
            dl AS (   -- 삭제 주체. 한 키에 여럿이 겹치면 하나만 남는다(MIN — 1차 단순화)
                SELECT DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE,
                       MIN(src) AS src, MIN(opt_id) AS opt_id, MIN(plan_id) AS plan_id
                FROM #del
                GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, NO_WORK_DATE
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
                   N'SCP_OPMZ_NO_WORK',
                   c.k_div   COLLATE DATABASE_DEFAULT,
                   c.k_plant COLLATE DATABASE_DEFAULT,
                   c.k_line  COLLATE DATABASE_DEFAULT,
                   c.k_opn   COLLATE DATABASE_DEFAULT,
                   c.k_ltype COLLATE DATABASE_DEFAULT,
                   NULL,
                   c.k_date  COLLATE DATABASE_DEFAULT,
                   NULL,
                   NULL,
                   -- 2026-10-01: 양식의 「기존 / 변경」 날짜. patch op 로 가른다 —
                   --   DELETE 는 변경이 없고, INSERT 는 기존이 없다. UPDATE(이동 포함)는 둘 다.
                   CASE WHEN m.op = N'INSERT' THEN NULL ELSE m.b_from END COLLATE DATABASE_DEFAULT,
                   CASE WHEN m.op = N'INSERT' THEN NULL ELSE m.b_to   END COLLATE DATABASE_DEFAULT,
                   CASE WHEN m.op = N'DELETE' THEN NULL ELSE m.a_from END COLLATE DATABASE_DEFAULT,
                   CASE WHEN m.op = N'DELETE' THEN NULL ELSE m.a_to   END COLLATE DATABASE_DEFAULT,
                   ISNULL(m.op, c.op) COLLATE DATABASE_DEFAULT,
                   CASE WHEN c.op = N'NOAPPLY' THEN N'NOAPPLY' ELSE N'APPLIED' END,
                   N'OFF_TIME',
                   /* 값도 날짜와 **같은 기준**으로 가른다(2026-10-02). 종전에는 날짜만 patch op 로
                      가르고 값은 DB 가 본 것을 그대로 썼다 — 그래서 `INSERT` 요청인데 DB 에선
                      기존 행이 있어 갱신된 줄에서 **기존 날짜는 비고 기존 값만 차는** 어긋남이
                      생겼다(2026-10-02 화면 캡처). 「기존/변경」은 요청의 전후로 읽는 칸이고,
                      DB 가 실제로 한 일은 `DETAIL` 의 `결과=` 가 말한다.
                      `DELETED` 는 값이 아니라 상태라 넣지 않는다 — `OP`·`CAUSE` 가 말한다. */
                   CASE WHEN m.op = N'INSERT' THEN NULL ELSE c.bef COLLATE DATABASE_DEFAULT END,
                   CASE WHEN c.aft COLLATE DATABASE_DEFAULT = N'DELETED' THEN NULL ELSE c.aft COLLATE DATABASE_DEFAULT END,
                   /* 유형: patch 조각이 우선, 없으면 **기준정보 행이 들고 있던 값**(2026-10-02).
                      조각에 유형이 안 실리는 건이 있어 상세가 빈칸이 됐다 — 실제로 지우거나 고친
                      행에는 그 값이 있고, 그쪽이 「무엇을 건드렸나」에 더 가깝다. */
                   COALESCE(m.NO_WORK_TYPE,
                            /* `[DESC]` 원문에서 유형만 뽑는다. 두 꼬리를 떼면 된다 —
                                 `기존->새사유`  → 마지막 `->` 뒤  (FN_GET_SCP_OPMZ_DESC_HIST 가 붙인다)
                                 `사유 (plan)`   → 첫 `(` 앞       (계획 꼬리·비율 표기)
                               마지막 `->` 는 뒤집어서 첫 `>-` 를 찾는 상투 수법으로 집는다. */
                            NULLIF(LTRIM(RTRIM(
                                CASE WHEN CHARINDEX(N'(', dsc.t) > 0
                                     THEN LEFT(dsc.t, CHARINDEX(N'(', dsc.t) - 1)
                                     ELSE dsc.t END)), N'')
                   ) COLLATE DATABASE_DEFAULT,
                   dl.src COLLATE DATABASE_DEFAULT,
                   -- 미반영은 사유를, 적용은 **결과 종류**를 남긴다(patch op 와 다를 수 있다 — 이동이 그렇다).
                   -- 주체(해제/이동/역산)는 CAUSE 칸이 담당하므로 여기 겹쳐 쓰지 않는다.
                   LEFT(CASE WHEN c.op = N'NOAPPLY'
                             THEN c.tag COLLATE DATABASE_DEFAULT
                             ELSE CONCAT(N'결과=', c.op COLLATE DATABASE_DEFAULT)
                        END, 500),
                   ISNULL(m.opt_id, dl.opt_id)   COLLATE DATABASE_DEFAULT,
                   NULL,
                   ISNULL(m.plan_id, dl.plan_id) COLLATE DATABASE_DEFAULT,
                   @uid,
                   GETDATE()
            FROM #chg c
            CROSS APPLY (SELECT REVERSE(LEFT(REVERSE(ISNULL(c.k_type, N'')),
                                             CHARINDEX(N'>-', REVERSE(ISNULL(c.k_type, N'')) + N'>-') - 1)) AS t) dsc
            LEFT JOIN meta m
                ON  m.DIVISION_ID = c.k_div   AND m.PLANT_ID = c.k_plant
                AND m.LINE_ID     = c.k_line  AND m.kdate    = c.k_date
            LEFT JOIN dl
                ON  dl.DIVISION_ID   = c.k_div  AND dl.PLANT_ID = c.k_plant
                AND dl.LINE_ID       = c.k_line AND dl.NO_WORK_DATE = c.k_date;
        END TRY
        BEGIN CATCH
            /* 상세 적재 실패는 반영을 막지 않는다. 경고 로그로만 남긴다. */
            BEGIN TRY
                DECLARE @dtl_err nvarchar(200) = LEFT(ERROR_MESSAGE(), 200);
                SET @LOG_DT = GETDATE();
                EXEC dbo.PR_SCM_SYS_LOG_BATCH
                     @p_program_name = N'PR_SCP_OPMZ_APPLY_NO_WORK',
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
        /* 10-b 종료. */

        /* 11 시작: 커밋 — 내가 연 트랜잭션만 확정. 합류 상태면 상위(오케스트레이터)가 커밋. */
        IF @START_TRAN = 1 COMMIT;
        /* 11 종료. */

        /* 12 시작: 성공 로그(SUCCESS) 적재 — 최종 카운터(UPD/DEL/INS/RESOLVED) 요약.
                   INSERT(9-2 날짜이동 신규행)를 반드시 함께 센다. 2026-09-03 이전에는 UPD+DEL 만
                   세어, 날짜이동만 일어난 반영이 호출부에 '0건'으로 보고됐다 — 화면은 아무것도
                   바뀌지 않았다고 안내하는데 실제로는 새 행이 들어가 있었다.
                   형제 PR_SCP_OPMZ_APPLY_SOP_EOP 는 처음부터 @INS 를 함께 센다. 그 모양에 맞춘다. */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = ISNULL(@UPD,0) + ISNULL(@DEL,0) + ISNULL(@INS,0);
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', @OPT_KEY_VAL_ID,
                                        N'; TARGET=', N'SCP_OPMZ_NO_WORK',
                                        N'; UPD=', @UPD, N' DEL=', @DEL, N' INS=', @INS,
                                        N' NOAPPLY=', @NOAPPLY, N' RESOLVED=', @PATCHES), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_NO_WORK',
                 @p_log_type     = N'END',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = N'PR_SCP_OPMZ_APPLY_NO_WORK 완료',
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        /* 12 종료. */

        /* 13 시작: 결과 요약 반환. */
        IF @RETURN_RESULT_YN = N'Y'
            SELECT @SNRO_CD AS SNRO_CD,
                   N'Y'                        AS SUCCESS_YN,
                   N'SUCCESS'                  AS RESULT_CODE,
                   N'비조업(NO WORK) 반영 완료' AS RESULT_MESSAGE,
                   @UPD     AS UPDATED_ROWS,
                   @DEL     AS DELETED_ROWS,
                   @NOAPPLY AS NOAPPLY_ROWS,
                   @PATCHES AS RESOLVED_PATCHES;
        /* 13 종료. */
    END TRY
    BEGIN CATCH
        /* 14 시작: 예외 처리 — (소유 트랜잭션이고 살아있으면)롤백 → ERROR 로그 → THROW로 상위 재전파.
                    합류 상태(@START_TRAN=0)면 롤백/에러로그는 소유자(오케스트레이터)가 담당하고 여기선 THROW만. */
        IF @START_TRAN = 1 AND XACT_STATE() <> 0
            ROLLBACK;
        SET @ERR_MSG = ERROR_MESSAGE();
        IF @START_TRAN = 1   /* 중첩 호출 시 에러로그는 트랜잭션 소유자(오케스트레이터)가 남김 */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', @OPT_KEY_VAL_ID,
                                        N'; TARGET=', N'SCP_OPMZ_NO_WORK'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_NO_WORK',
                 @p_log_type     = N'ERROR',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = @ERR_MSG,
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        THROW;
        /* 14 종료. */
    END CATCH;
END
