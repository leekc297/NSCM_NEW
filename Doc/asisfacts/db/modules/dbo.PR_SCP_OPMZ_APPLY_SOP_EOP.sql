
/* ---- 4) SOP/EOP ---------------------------------------------------------------------------- */

CREATE   PROCEDURE dbo.PR_SCP_OPMZ_APPLY_SOP_EOP
    @SNRO_CD          NVARCHAR(50),
    @USER_ID          NVARCHAR(200) = NULL,
    @OPT_KEY_VAL_ID   NVARCHAR(200) = NULL,        -- NULL=routing_resource 패치 전체(생산구간), 또는 콤마구분 카드 목록
    @RETURN_RESULT_YN NCHAR(1)      = N'Y'
AS
BEGIN
    /*==================================================================================================
      프로시저 : dbo.PR_SCP_OPMZ_APPLY_SOP_EOP
      --------------------------------------------------------------------------------------------------
      [목적]
        시나리오 패치(SNRO) 중 라우팅/자원(SCP_OPT_ENG_ROUTING_RESOURCE)의 생산 START/END_DATE 를
        읽어, (DIVISION/PLANT/LINE/ITEM)별 "생산 가능구간"의 SOP(양산시작)·EOP(양산종료)로 집계하여
        최적화 전용 조회테이블 dbo.SCP_OPMZ_SOP_EOP 에 교체 반영한다.

      [소스]
        - dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN (SCP_OPT_PTCH_JSON_CTN) 의 패치 JSON
        - 대상 패치 : table = SCP_OPT_ENG_ROUTING_RESOURCE, op IN ('UPDATE','INSERT')
        - 사용 값   : START_DATE / END_DATE (set 우선, 없으면 where), ROUTING_ID / RESOURCE_ID / PLAN_ID
        - 카드      : **신규라인 가동 카드만**(CRD-00008 조립 / CRD-00103 전극). (2026-07-07)
                      코팅증속(CRD-00102)·라인mix(CRD-00007)은 기존 가동 라인의 능력/구성 변경일 뿐
                      새 양산개시가 아니므로 SOP 대상에서 제외(룩업 SOP_EOP 행 VALID_YN='N').
                      → 카드→타겟 게이트 FN_GET_SCP_OPMZ_OPT_TARGET(opt_id,'SOP_EOP')=1 이 자동 필터링.
                      ※ 이미 가동 중인 라인에 UPDATE(월별 daily_value 조정 등)가 와도 MIN(START)로
                        스퍼리어스 SOP를 찍지 않도록 함(예: 계속 가동 라인 FP_E4M01_A의 20261001).

      [타겟]
        - dbo.SCP_OPMZ_SOP_EOP
        - DATE 컬럼이 PK 구성요소 → in-place UPDATE 불가 → (키+TYPE) 삭제 후 INSERT 로 교체.

      [핵심 변환]
        - 정방향(엔진 입력 생성)에서 SOP_EOP 는 (ITEM,LINE)별 생산 가능구간 [SOP..EOP] 로 쓰인다.
        - 역방향(본 프로시저)에서는 라우팅/자원 패치의 날짜들을 집계하여
              SOP = MIN(START_DATE)
          로 산출하고, 한 (키)당 TYPE='SOP' 1행만 적재한다.
          ※ EOP(=MAX(END))는 산출은 하지만 **테이블에 넣지 않는다**(2026-07-06): 기존 SCP_OPMZ_SOP_EOP에 EOP
            미관리 데이터가 많아 EOP를 새로 넣으면 오히려 충돌/오류가 될 수 있어 SOP만 관리한다.
        - OPERATION_ID : (사업부/공장/라인)→OPERATION 룩업(FN_GET_SCP_OPMZ_LINE_OP, A3000/A9000/E2000)으로 도출.
          (routing STAGE(seg3)가 아니라 기존 테이블 관례인 조작코드에 맞춤. **라인룩업만** 사용 — 미등록 라인은 OP를 못 구해 NOAPPLY(DROP_NOOP), STAGE로 지어내지 않음. 2026-07-07)
        - 기존 테이블 관례 맞춤 : LINE_TYPE = '-', ATTRIBUTE1 = NULL. DESC = 'SOP/EOP PROD(SNRO)'(SNRO 산출 표식).

      [AUTO_ROUTING_ID 처리 — 신규라인 카드 CRD-00008]
        - op='INSERT' 신규 라우팅은 ROUTING_ID = '<<AUTO_ROUTING_ID>>' (엔진 auto placeholder)라 '::' 없음.
        - 이 경우 SITE/LINE 은 RESOURCE_ID(SITE::LINE)에서 도출한다
          (CASE WHEN routing_id LIKE '%::%' 로 분기 : '::' 있으면 ROUTING_ID 파싱, 없으면 RESOURCE_ID).
        - ITEM/OPERATION 은 filled CTE 가 같은 (DIV/PLANT/LINE)의 정상 라우팅 형제 행에서 채운다
          (OUTER APPLY TOP 1). 이후 win CTE 가 filled 로부터 라인/아이템별 SOP/EOP 를 집계한다.

      [파라미터]
        @SNRO_CD          : 시나리오 코드(필수)
        @USER_ID          : 감사 컬럼용 사용자(없으면 SUSER_SNAME())
        @OPT_KEY_VAL_ID   : NULL=routing_resource 패치 전체, 또는 특정 카드(SCP_OPT_ID)만
        @RETURN_RESULT_YN : 'Y'면 결과요약 결과셋 반환

      [단계]
        1  실행 옵션 설정 (NOCOUNT / XACT_ABORT)
        2  필수 입력 검증
        3  런타임 변수 선언
        4  시작 로그(트랜잭션 밖)
        5  트랜잭션 시작(소유 시)
        6  패치 → 생산구간 도출(#se)  ← 핵심 (patch/kv/resolved/filled/win CTE)
        7  기존행 삭제 후 신규 INSERT(교체) + 행단위 로그
        8  커밋
        9  성공 로그
        10 결과요약 반환
        11 CATCH : 롤백 → 오류 로그 → THROW
      --------------------------------------------------------------------------------------------------
      비고 : compat120 JSON 헬퍼 사용, COLLATE DATABASE_DEFAULT 로 콜레이션 정합, TRY/CATCH+THROW,
             트랜잭션은 @START_TRAN 으로 소유/합류 판단(오케스트레이터 중첩 호출 지원).
    ==================================================================================================*/

    /* 1 시작: 기본 실행 옵션. 영향건수(rowcount) 메시지를 끄고(NOCOUNT),
               오류 발생 시 현재 문 단위가 아니라 트랜잭션 전체를 즉시 실패/롤백시킨다(XACT_ABORT). */
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    /* 1 종료. */

    /* 2 시작: 필수 입력값 검증. 시나리오 코드(@SNRO_CD)가 공백/NULL 이면 즉시 예외 발생. */
    IF NULLIF(LTRIM(RTRIM(@SNRO_CD)), N'') IS NULL
        THROW 51030, 'SNRO_CD IS REQUIRED.', 1;
    /* 2 종료. */

    /* 3 시작: 런타임 변수 선언.
               @uid        : 감사(CREATED_BY/LAST_UPDATED_BY)용 사용자
               @START_TRAN : 진입 시 열린 트랜잭션이 없으면 1(내가 트랜잭션 소유) — commit/rollback 책임 판단
               @INS/@DEL   : INSERT/DELETE 건수, @RESOLVED : 도출된 SOP/EOP 행 수
               @ERR_MSG / @LOG_* : 오류 메시지 및 로그 적재용 */
    DECLARE @uid        NVARCHAR(200) = COALESCE(@USER_ID, SUSER_SNAME());
    DECLARE @START_TRAN BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @INS INT = 0, @DEL INT = 0, @RESOLVED INT = 0, @NOAPPLY INT = 0;
    DECLARE @ERR_MSG  NVARCHAR(2048);
    DECLARE @LOG_DT   DATETIME;
    DECLARE @LOG_CNT  INT;
    DECLARE @LOG_DESC NVARCHAR(500);
    /* 3 종료. */

    /* 4 시작: 시작 로그 적재. 트랜잭션 밖에서 기록하므로 이후 롤백돼도 실행 이력은 보존된다. */
    BEGIN
        SET @LOG_DT  = GETDATE();
        SET @LOG_CNT = 0;
        SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                    N'; CARD=', @OPT_KEY_VAL_ID,
                                    N'; TARGET=', N'SCP_OPMZ_SOP_EOP'), 500);
        EXEC dbo.PR_SCM_SYS_LOG_BATCH
             @p_program_name = N'PR_SCP_OPMZ_APPLY_SOP_EOP',
             @p_log_type     = N'START',
             @p_log_count    = @LOG_CNT,
             @p_log_message  = N'PR_SCP_OPMZ_APPLY_SOP_EOP 시작',
             @p_description  = @LOG_DESC,
             @p_event_date   = @LOG_DT;
    END;
    /* 4 종료. */

    IF OBJECT_ID('tempdb..#se') IS NOT NULL DROP TABLE #se;   -- 재실행 대비 임시테이블 정리
    IF OBJECT_ID('tempdb..#resolved') IS NOT NULL DROP TABLE #resolved;
        IF OBJECT_ID('tempdb..#se_cand') IS NOT NULL DROP TABLE #se_cand;

    BEGIN TRY
        /* 5 시작: 트랜잭션 시작. 내가 소유한 경우(@START_TRAN=1)에만 BEGIN TRAN.
                   이미 상위(오케스트레이터)가 열어둔 트랜잭션이면 합류만 하고 여기서 열지 않는다. */
        IF @START_TRAN = 1 BEGIN TRAN;
        /* 5 종료. */

        /* 6 시작: routing_resource 패치(UPDATE/INSERT)의 START/END_DATE로 (라인/아이템)별 생산구간 도출 → #se.
                   정방향(PR_SCP_OPT_ENG_INPUT_ROUTING_RESOURCE)에서 SOP_EOP 는 (ITEM,LINE)별
                   생산 가능구간[SOP_MM..EOP_MM]으로 사용됨 → 역으로 SOP=MIN(START). (EOP=MAX(END)는 산출만, 미적재)
                   키는 ROUTING_ID(SITE::ITEM::STAGE::LINE::일자)를 FN_SPLIT_VAL로 분해. 그 후 TYPE='SOP' 1행 전개.
                   ※ OPERATION_ID=라인→OP 룩업(A3000 등), LINE_TYPE='-', ATTRIBUTE1=NULL (기존 테이블 관례에 맞춤). */
        ;WITH patch AS (
            -- [patch] 이 시나리오의 패치 JSON 배열에서 SCP_OPT_ENG_ROUTING_RESOURCE 의 UPDATE/INSERT 항목만 추출.
            --         각 항목의 op / where(wf) / set(sf) 절을 그대로 하위 CTE 로 넘긴다.
            SELECT m.SCP_OPT_ID COLLATE DATABASE_DEFAULT AS opt_id,   -- 카드 코드(SCP_OPT_ID)
                   J.[KEY]                              AS pseq,    -- 패치 배열 내 순번(항목 식별자)
                   UPPER(JSON_VALUE(J.[VALUE], '$.op')) AS op,      -- 연산: UPDATE / INSERT
                   JSON_QUERY(J.[VALUE], '$.where')     AS wf,      -- where 절(키/조건 컬럼-값 배열)
                   JSON_QUERY(J.[VALUE], '$.set')       AS sf       -- set 절(변경 컬럼-값 배열)
            FROM dbo.SCP_SNRO_PLAN_SNRO_OPT_M_SN m
            CROSS APPLY dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(m.SCP_OPT_PTCH_JSON_CTN) J   -- 패치 JSON → 항목 단위 전개
            WHERE m.SCP_SNRO_ID = @SNRO_CD
              AND ISJSON(m.SCP_OPT_PTCH_JSON_CTN) = 1                                            -- 유효 JSON 만
              AND UPPER(PARSENAME(JSON_VALUE(J.[VALUE], '$.table'), 1)) = N'SCP_OPT_ENG_ROUTING_RESOURCE'  -- 대상 테이블 필터(스키마 접두 제거)
              AND UPPER(JSON_VALUE(J.[VALUE], '$.op')) IN ('UPDATE','INSERT')                    -- 생산구간에 영향 주는 연산만
              AND ((@OPT_KEY_VAL_ID IS NULL OR N',' + REPLACE(@OPT_KEY_VAL_ID, N' ', N'') + N',' LIKE N'%,' + m.SCP_OPT_ID COLLATE DATABASE_DEFAULT + N',%')  -- 특정 카드 목록 스코프(콤마구분, 옵션)
                   AND dbo.FN_GET_SCP_OPMZ_OPT_TARGET(m.SCP_OPT_ID, N'SOP_EOP') = 1)            -- 카드→SOP_EOP 타겟 매핑 확인
        ),
        kv AS (
            -- [kv] 패치 항목별로 where/set 의 컬럼-값들을 한 행으로 피벗(MAX + CASE).
            --      날짜는 set(src='S') 우선, 없으면 where(src='W') 값을 사용한다.
            SELECT p.pseq,
                   p.op,   -- patch 가 요청한 연산. 상세의 OP 칸용이다(2026-10-02, GitLab #35)
                   MAX(CASE WHEN f.col='PLAN_ID'    THEN f.val END) COLLATE DATABASE_DEFAULT AS plan_id,     -- 계획 ID(DIVISION 도출용)
                   MAX(CASE WHEN f.col='ROUTING_ID' THEN f.val END) COLLATE DATABASE_DEFAULT AS routing_id,  -- 라우팅 키(SITE::ITEM::STAGE::LINE::일자) 또는 AUTO placeholder
                   COALESCE(MAX(CASE WHEN f.src='S' AND f.col='START_DATE' THEN f.val END),                  -- SOP 후보: set 우선
                            MAX(CASE WHEN f.src='W' AND f.col='START_DATE' THEN f.val END))                  --           없으면 where
                       COLLATE DATABASE_DEFAULT AS sdate,
                   COALESCE(MAX(CASE WHEN f.src='S' AND f.col='END_DATE' THEN f.val END),                    -- EOP 후보: set 우선
                            MAX(CASE WHEN f.src='W' AND f.col='END_DATE' THEN f.val END))                    --           없으면 where
                       COLLATE DATABASE_DEFAULT AS edate,
                   MAX(p.opt_id) COLLATE DATABASE_DEFAULT AS opt_id,
                   MAX(CASE WHEN f.col='RESOURCE_ID' THEN f.val END) COLLATE DATABASE_DEFAULT AS resource_id -- 자원 키(SITE::LINE) — AUTO_ROUTING_ID 시 site/line 도출용
            FROM patch p
            CROSS APPLY (
                -- where(src='W') 와 set(src='S') 배열을 각각 (col,val) 쌍으로 평탄화하여 UNION ALL
                SELECT 'W' AS src, oc.col, oc.val
                FROM dbo.FN_SCP_JSON_ARRAY_ITEMS_120_SN(p.wf) a
                CROSS APPLY (
                    SELECT MAX(CASE WHEN UPPER([KEY])='COLUMN' THEN [VALUE] END) col,    -- 항목 객체에서 column 키
                           MAX(CASE WHEN UPPER([KEY])='VALUE'  THEN [VALUE] END) val     -- 항목 객체에서 value 키
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
            GROUP BY p.opt_id, p.pseq, p.op
        )
        -- resolved: CTE 가 아니라 임시테이블로 받는다(2026-09-03).
        -- 아래 filled 이 이 결과를 자기참조하는데 CTE 는 실체화되지 않아 바깥 행마다 통째로
        -- 재계산된다. 그 안에 JSON 파싱·FN_SPLIT_VAL·SCM_MST_SITE·FN_GET_SCP_OPMZ_PLAN_SEQ 가
        -- 들어 있어 형제 프로시저 DDLY_CAPA 에서 같은 형태가 54분+ 를 만들었다(dev 실측).
        -- 계산식·필터·조인은 그대로다. 실체화 위치만 옮긴다.
        SELECT
            -- [resolved] kv 의 키 문자열들을 세그먼트로 분해하여 타겟 컬럼(DIVISION/PLANT/LINE/ITEM/OPERATION/일자)으로 해석.
            --            routing_id 에 '::' 있으면 ROUTING_ID(SITE::ITEM::STAGE::LINE::일자)에서, 없으면(AUTO) RESOURCE_ID 에서 site/line 도출.
            
                COALESCE(
                    pm.DIVISION_ID,                                              -- 1순위: 계획마스터의 DIVISION
                    SUBSTRING(kv.plan_id,                                        -- 2순위: plan_id 의 2번째 '_' 세그먼트
                              CHARINDEX('_',kv.plan_id)+1,
                              CHARINDEX('_',kv.plan_id,CHARINDEX('_',kv.plan_id)+1)-CHARINDEX('_',kv.plan_id)-1)
                ) AS DIVISION_ID,
                (SELECT MAX(sm.PLANT_ID) FROM dbo.SCM_MST_SITE sm     -- SCM_SITE_ID→PLANT_ID 권위 매핑(문자열 절단 아님)
                 WHERE sm.SCM_SITE_ID = st.site COLLATE DATABASE_DEFAULT AND sm.VALID_YN='Y') AS PLANT_ID,
                st.line AS LINE_ID,
                CAST(NULL AS NVARCHAR(30)) AS OPERATION_ID,   -- OP는 filled에서 라인룩업으로만 도출(STAGE 폴백 제거)
                CAST('-' AS NVARCHAR(30)) COLLATE DATABASE_DEFAULT AS LINE_TYPE,                  -- 기존 테이블 관례에 맞춤('-')
                CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg2 ELSE NULL END AS ITEM_ID,        -- ITEM(seg2). AUTO 는 filled 에서 보충
                COALESCE(kv.sdate, CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg5 ELSE NULL END) AS START_DATE,  -- 날짜: 패치값 우선, 없으면 키의 일자(seg5)
                kv.edate AS END_DATE,
                kv.opt_id,
                kv.op,
                dbo.FN_GET_SCP_OPMZ_PLAN_SEQ(kv.plan_id, @SNRO_CD) AS plan_id   -- 채번 계획ID(base→base_S00x). DESC 이력 꼬리용
        INTO #resolved
        FROM kv
            CROSS APPLY (
                -- ROUTING_ID 를 '::' 기준 5개 세그먼트로 분해 : seg1=SITE, seg2=ITEM, seg3=STAGE, seg4=LINE, seg5=일자
                SELECT dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',1) COLLATE DATABASE_DEFAULT AS seg1,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',2) COLLATE DATABASE_DEFAULT AS seg2,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',3) COLLATE DATABASE_DEFAULT AS seg3,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',4) COLLATE DATABASE_DEFAULT AS seg4,
                       dbo.FN_SPLIT_VAL_SN(kv.routing_id,'::',5) COLLATE DATABASE_DEFAULT AS seg5
            ) sp
            CROSS APPLY (
                -- site/line 결정 : ROUTING_ID 에 '::' 있으면 seg1/seg4, 없으면(AUTO_ROUTING_ID) RESOURCE_ID(SITE::LINE)에서 도출
                SELECT CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg1
                            ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',1) COLLATE DATABASE_DEFAULT END AS site,
                       CASE WHEN kv.routing_id LIKE '%::%' THEN sp.seg4
                            ELSE dbo.FN_SPLIT_VAL_SN(kv.resource_id,'::',2) COLLATE DATABASE_DEFAULT END AS line
            ) st
        LEFT JOIN dbo.SCP_OPMZ_PLAN_M pm ON pm.OPMZ_PLAN_ID = kv.plan_id   -- 계획마스터로 DIVISION 우선 확보
        ;

        ;WITH filled AS (   -- OPERATION_ID = 라인→OP 룩업(A3000 등) 도출. ITEM 은 AUTO 행이면 형제에서 보충.
            SELECT r.DIVISION_ID, r.PLANT_ID, r.LINE_ID, r.LINE_TYPE, r.START_DATE, r.END_DATE, r.opt_id, r.plan_id, r.op,
                   COALESCE(NULLIF(r.ITEM_ID,N''),      sib.ITEM_ID)      AS ITEM_ID,        -- 비어있으면 형제 행 값으로 대체
                   dbo.FN_GET_SCP_OPMZ_LINE_OP(r.DIVISION_ID, r.PLANT_ID, r.LINE_ID) AS OPERATION_ID  -- 라인룩업만(A3000/A9000/E2000). STAGE/형제 폴백 제거 → 미등록 라인은 아래 #se_cand에서 DROP_NOOP
            FROM #resolved r
            OUTER APPLY (
                -- 형제(sibling) 탐색 : 같은 DIV/PLANT/LINE 에서 ITEM 이 채워진 행 하나(ITEM 순으로 첫 행)
                SELECT TOP 1 r2.ITEM_ID, r2.OPERATION_ID
                FROM #resolved r2
                WHERE COALESCE(r2.ITEM_ID,N'')<>N''
                  AND r2.LINE_ID     = r.LINE_ID
                  AND r2.DIVISION_ID = r.DIVISION_ID
                  AND r2.PLANT_ID    = r.PLANT_ID
                ORDER BY r2.ITEM_ID
            ) sib
        ),
        win AS (   -- 라인/아이템별 생산구간
            -- [win] (DIV/PLANT/LINE/OPERATION/LINE_TYPE/ITEM) 그룹별로 SOP=MIN(START), EOP=MAX(END) 집계.
            SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID,
                   MIN(NULLIF(START_DATE,'')) AS SOP_DATE,    -- 생산 시작(양산개시) = 최소 START
                   MAX(NULLIF(END_DATE,''))   AS EOP_DATE,    -- 생산 종료(양산종료) = 최대 END
                   MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id,
                   /* 대표 patch op. 이 타겟의 SOP 는 조각 여럿을 MIN(START_DATE) 로 접은 값이라
                      한 조각의 op 가 그 줄을 다 설명하지는 못한다 — 그래서 상세의 `DETAIL` 에
                      DB 가 실제로 한 연산(`결과=`)을 같이 남긴다. */
                   MAX(op) AS op
            FROM filled
            -- (키 필터는 아래 #se_cand의 drop_reason 계산으로 이동 — 미반영 로그를 위해 탈락행도 보존)
            GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID
        )
        -- win 전체를 SOP 행으로 전개하여 #se_cand 로 보존 + 탈락사유 계산 (2026-07-06: EOP 미관리 — SOP만)
        SELECT w.DIVISION_ID, w.PLANT_ID, w.LINE_ID, w.OPERATION_ID, w.LINE_TYPE, w.ITEM_ID,
               v.TYPE COLLATE DATABASE_DEFAULT AS TYPE,      -- 'SOP' 고정
               v.DT   COLLATE DATABASE_DEFAULT AS [DATE],    -- SOP 날짜
               w.opt_id,
               w.plan_id,
               w.op,
               CASE WHEN COALESCE(w.ITEM_ID,N'')=N'' OR COALESCE(w.DIVISION_ID,N'')=N'' OR COALESCE(w.LINE_ID,N'')=N''
                         THEN N'DROP_BADKEY(DIVISION/LINE/ITEM 누락)'
                    WHEN COALESCE(w.OPERATION_ID,N'')=N''
                         THEN N'DROP_NOOP(라인 미등록: SCP_OPMZ_LINE_OPERATION)'
                    WHEN COALESCE(v.DT,N'')=N''
                         THEN N'DROP_NODATE(SOP 날짜 없음)'
                    ELSE NULL END AS drop_reason
        INTO #se_cand
        FROM win w
        CROSS APPLY (VALUES (N'SOP', w.SOP_DATE)) v(TYPE, DT);   -- SOP 행만 생성(EOP 제외)

        -- 유효(drop_reason NULL)만 #se 로 확정
        SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, TYPE, [DATE], opt_id, plan_id
        INTO #se
        FROM #se_cand
        WHERE drop_reason IS NULL;

        SET @RESOLVED = (SELECT COUNT(*) FROM #se);   -- 도출된 SOP/EOP 행 수
        /* 6 종료: 생산구간(#se: SOP/EOP 행) 구성 완료. */

        IF OBJECT_ID('tempdb..#chg') IS NOT NULL DROP TABLE #chg;
        CREATE TABLE #chg(   -- 변경 이력 버퍼(삭제/삽입된 행을 행단위 로그로 남기기 위함)
            op     nvarchar(10),
            rowkey nvarchar(300),
            bef    nvarchar(100),
            aft    nvarchar(100),
            tag    nvarchar(150),
            /* 쪼갠 키 (2026-10-01, GitLab #35). 이 타겟 PK 는
               DIV·PLANT·LINE·OP·LINE_TYPE·ITEM·TYPE·DATE 여덟이다.
               rowkey 문자열을 되파싱하지 않는 이유는 DDLY_CAPA step7c 와 같다. */
            k_div    nvarchar(30),
            k_plant  nvarchar(30),
            k_line   nvarchar(30),
            k_opn    nvarchar(30),
            k_ltype  nvarchar(30),
            k_item   nvarchar(100),
            k_type   nvarchar(10),
            k_date   nvarchar(8)
        );

        /* 7 시작: SOP 반영 — **물리삭제 대신 (a)기존 (키+TYPE) 소프트삭제 + (b)새 SOP full-PK MERGE(재활성/삽입)** (2026-07-07).
                   물리 DELETE 없이 이력 보존. 엔진은 VALID_YN='Y'만 읽음. 재실행/PK충돌 안전(MERGE는 full PK 기준). */
        -- (0) 기존 DESC 캡처 : **현재 활성(VALID_YN='Y') 행**의 DESC만 확보(→ DESC 전환 '기존->사유(SNRO)' 용).
        --     활성 행만 보므로 재실행 시 이미 '(SNRO)'된 값을 집어 → 이중 부착 없이 멱등.
        IF OBJECT_ID('tempdb..#old') IS NOT NULL DROP TABLE #old;
        SELECT se.DIVISION_ID, se.PLANT_ID, se.LINE_ID, se.OPERATION_ID, se.LINE_TYPE, se.ITEM_ID, se.TYPE,
               MAX(se.[DESC]) AS OLD_DESC
        INTO #old
        FROM dbo.SCP_OPMZ_SOP_EOP se
        JOIN (SELECT DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, TYPE FROM #se) k
          ON  se.DIVISION_ID=k.DIVISION_ID AND se.PLANT_ID=k.PLANT_ID AND se.LINE_ID=k.LINE_ID
          AND se.OPERATION_ID=k.OPERATION_ID AND se.LINE_TYPE=k.LINE_TYPE AND se.ITEM_ID=k.ITEM_ID AND se.TYPE=k.TYPE
        WHERE se.VALID_YN = 'Y'
        GROUP BY se.DIVISION_ID, se.PLANT_ID, se.LINE_ID, se.OPERATION_ID, se.LINE_TYPE, se.ITEM_ID, se.TYPE;

        -- (1) **삭제** : 교체 대상 (키+TYPE)의 기존 행을 지운다. (2026-09-18 #27: 소프트 삭제 폐기)
        --     예전에는 VALID_YN='N' + DESC 이력 전환이었는데, 현업 요구(변경 전 기준정보는 삭제)로
        --     행 자체를 없앤다. 날짜(DATE)를 뺀 키로 잡으므로 **SOP 날짜가 바뀌어도 옛 행이 안 남는다** —
        --     이 구조가 없는 APPLY_RAMP_UP 이 고아를 남겨 왔다(#27 ②).
        --     ※ 기존 DESC 는 이 앞 (0) 단계에서 #old 에 캡처해 두었으므로 (2) 의 승계가 그대로 산다.
        --     ※ VALID_YN='N' 이던 행도 함께 지운다 — 잔재를 남기지 않는 것이 요구의 취지다.
        --     멱등: 없는 행은 0건이다.
        DELETE se
        OUTPUT N'DELETE',
               CONCAT(deleted.DIVISION_ID, N'|', deleted.PLANT_ID, N'|', deleted.LINE_ID, N'|',
                      deleted.OPERATION_ID, N'|', deleted.ITEM_ID, N'|', deleted.TYPE),
               deleted.[DATE],       -- 지워진 날짜(before)
               N'DELETED',           -- 변경 후 = 행 없음
               deleted.ATTRIBUTE9,   -- 지워지는 행에 남아 있던 출처 태그
               deleted.DIVISION_ID, deleted.PLANT_ID, deleted.LINE_ID, deleted.OPERATION_ID,
               deleted.LINE_TYPE, deleted.ITEM_ID, deleted.TYPE, deleted.[DATE]
        INTO #chg(op, rowkey, bef, aft, tag,
                  k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_type, k_date)
        FROM dbo.SCP_OPMZ_SOP_EOP se
        JOIN (SELECT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, TYPE, MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id FROM #se
              GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, TYPE) k
          ON  se.DIVISION_ID  = k.DIVISION_ID AND se.PLANT_ID = k.PLANT_ID AND se.LINE_ID = k.LINE_ID
          AND se.OPERATION_ID = k.OPERATION_ID AND se.LINE_TYPE = k.LINE_TYPE AND se.ITEM_ID = k.ITEM_ID AND se.TYPE = k.TYPE;
        SET @DEL = @@ROWCOUNT;

        -- (2) 새 SOP MERGE(full PK: DIV/PLANT/LINE/OP/LINE_TYPE/ITEM/TYPE/DATE) : 같은 PK 있으면 재활성+갱신, 없으면 삽입.
        --     LINE_TYPE='-'·ATTRIBUTE1=NULL(기존관례), DESC 전환('기존->사유(SNRO)'), ATTRIBUTE9=SNRO/카드.
        MERGE dbo.SCP_OPMZ_SOP_EOP AS tgt
        USING (
            SELECT s.DIVISION_ID, s.PLANT_ID, s.LINE_ID, s.OPERATION_ID, s.LINE_TYPE, s.ITEM_ID, s.TYPE, s.[DATE], s.opt_id,
                   dbo.FN_GET_SCP_OPMZ_DESC_HIST(o.OLD_DESC,   -- 기존 활성 DESC(원본) 보존 + 최신 시나리오로 전환
                        ISNULL((SELECT TOP 1 ld.DESCRIPTION FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL ld
                                WHERE ld.LOOKUP_TYPE=N'SCP_OPMZ_SNRO_OPT' AND ld.SEGMENT1=N'SOP_EOP'
                                  AND ld.SEGMENT2=s.opt_id AND ld.VALID_YN=N'Y'), N'SOP/EOP PROD'), s.plan_id) AS NEW_DESC
            FROM #se s
            LEFT JOIN #old o
              ON  o.DIVISION_ID=s.DIVISION_ID AND o.PLANT_ID=s.PLANT_ID AND o.LINE_ID=s.LINE_ID
              AND o.OPERATION_ID=s.OPERATION_ID AND o.LINE_TYPE=s.LINE_TYPE AND o.ITEM_ID=s.ITEM_ID AND o.TYPE=s.TYPE
        ) AS src
           ON  tgt.DIVISION_ID=src.DIVISION_ID AND tgt.PLANT_ID=src.PLANT_ID AND tgt.LINE_ID=src.LINE_ID
           AND tgt.OPERATION_ID=src.OPERATION_ID AND tgt.LINE_TYPE=src.LINE_TYPE AND tgt.ITEM_ID=src.ITEM_ID
           AND tgt.TYPE=src.TYPE AND tgt.[DATE]=src.[DATE]
        WHEN MATCHED THEN   -- 같은 PK 존재 → 갱신. (1) 이 물리 삭제로 바뀐 뒤로는 거의 NOT MATCHED 로 간다
            UPDATE SET tgt.VALID_YN='Y', tgt.[DESC]=src.NEW_DESC, tgt.ATTRIBUTE1=NULL,
                       tgt.ATTRIBUTE9=CONCAT(@SNRO_CD, N'/', src.opt_id),
                       tgt.LAST_UPDATED_BY=@uid, tgt.LAST_UPDATE_DATE=GETDATE()
        WHEN NOT MATCHED THEN   -- 새 날짜 → 신규 삽입(Y)
            INSERT (DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ITEM_ID, TYPE, [DATE], [DESC], VALID_YN,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, LINE_TYPE, ATTRIBUTE1, ATTRIBUTE9)
            VALUES (src.DIVISION_ID, src.PLANT_ID, src.LINE_ID, src.OPERATION_ID, src.ITEM_ID, src.TYPE, src.[DATE], src.NEW_DESC, 'Y',
                    @uid, GETDATE(), @uid, GETDATE(), src.LINE_TYPE, NULL, CONCAT(@SNRO_CD, N'/', src.opt_id))
        OUTPUT CASE WHEN deleted.TYPE IS NULL THEN N'INSERT' ELSE N'UPDATE' END,
               CONCAT(inserted.DIVISION_ID, N'|', inserted.PLANT_ID, N'|', inserted.LINE_ID, N'|',
                      inserted.OPERATION_ID, N'|', inserted.ITEM_ID, N'|', inserted.TYPE),
               CAST(deleted.[DATE] AS nvarchar(100)),   -- 이전 날짜(재활성 시), 신규면 NULL
               inserted.[DATE],                         -- 반영 날짜(after)
               inserted.ATTRIBUTE9,
               inserted.DIVISION_ID, inserted.PLANT_ID, inserted.LINE_ID, inserted.OPERATION_ID,
               inserted.LINE_TYPE, inserted.ITEM_ID, inserted.TYPE, inserted.[DATE]
        INTO #chg(op, rowkey, bef, aft, tag,
                  k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_type, k_date);
        SET @INS = @@ROWCOUNT;

        -- 미반영(NOAPPLY) 로그: 카드 대상이지만 해석 단계에서 탈락(키 누락/SOP 날짜 없음)한 건. MERGE는 유효행을 모두 반영하므로 미반영=탈락뿐.
        INSERT INTO #chg(op, rowkey, bef, aft, tag,
                         k_div, k_plant, k_line, k_opn, k_ltype, k_item, k_type, k_date)
        SELECT N'NOAPPLY',
               CONCAT(ISNULL(DIVISION_ID,N''), N'|', ISNULL(PLANT_ID,N''), N'|', ISNULL(LINE_ID,N''), N'|',
                      ISNULL(ITEM_ID,N''), N'|', ISNULL(TYPE,N''), N'|', ISNULL([DATE],N'')),
               NULL, NULL, drop_reason,
               DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE, ITEM_ID, TYPE, [DATE]
        FROM #se_cand
        WHERE drop_reason IS NOT NULL;
        SET @NOAPPLY = @@ROWCOUNT;

        /* 7c 시작: **반영 이력 상세 적재** (2026-10-01, GitLab #35)
                    `#chg` 가 기준정보 키 단위이므로 그대로 상세가 된다.

                    ┌ 「기존/변경」을 키 단위로 짝지운다 ───────────────────────────────────────
                    │ 이 타겟의 SOP 이동은 **옛 날짜 행 삭제 + 새 날짜 행 INSERT** 로 나타난다.
                    │ 두 줄 다 같은 쌍(옛→새)을 들게 해야 고객 양식의 한 줄로 읽힌다 —
                    │ NO_WORK step10-b 가 이동을 다루는 방식과 같다.
                    │ `prev` 는 7-(1) 이 지운 날짜, `newd` 는 `#se` 가 확정한 날짜다.
                    ├ **OP 는 patch 가 요청한 연산**이다(2026-10-02 정정). 네 타겟의 뜻을 하나로 맞췄다.
                    │ 이 타겟의 SOP 는 조각 여럿을 `MIN(START_DATE)` 로 접은 값이라 대표 1건(`MAX(op)`)
                    │ 이고, DB 가 실제로 한 일은 `DETAIL` 의 `결과=` 가 말한다.
                    └ 실패해도 반영은 유효해야 하므로 TRY/CATCH 로 감싼다.
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
            ;WITH meta AS (   -- 카드·계획 (탈락행까지 덮어야 하므로 #se 가 아니라 #se_cand)
                /* 좌표까지 전부 ISNULL 로 접는다 — 탈락행은 좌표가 비고 NULL 끼리는 조인이 안 붙는다. */
                SELECT ISNULL(DIVISION_ID,N'') AS DIVISION_ID, ISNULL(PLANT_ID,N'') AS PLANT_ID,
                       ISNULL(LINE_ID,N'') AS LINE_ID, ISNULL(OPERATION_ID,N'') AS OPERATION_ID,
                       ISNULL(LINE_TYPE,N'') AS LINE_TYPE, ISNULL(ITEM_ID,N'') AS ITEM_ID,
                       ISNULL(TYPE,N'') AS TYPE,
                       MAX(opt_id) AS opt_id, MAX(plan_id) AS plan_id, MAX(op) AS op
                FROM #se_cand
                GROUP BY ISNULL(DIVISION_ID,N''), ISNULL(PLANT_ID,N''), ISNULL(LINE_ID,N''),
                         ISNULL(OPERATION_ID,N''),
                         ISNULL(LINE_TYPE,N''), ISNULL(ITEM_ID,N''), ISNULL(TYPE,N'')
            ),
            prev AS (         -- 「기존」 = 7-(1) 이 지운 그 날짜
                SELECT ISNULL(k_div,N'') AS k_div, ISNULL(k_plant,N'') AS k_plant,
                       ISNULL(k_line,N'') AS k_line, ISNULL(k_opn,N'') AS k_opn,
                       ISNULL(k_ltype,N'') AS k_ltype, ISNULL(k_item,N'') AS k_item,
                       ISNULL(k_type,N'') AS k_type, MIN(bef) AS old_date
                FROM #chg
                WHERE op = N'DELETE'
                GROUP BY ISNULL(k_div,N''), ISNULL(k_plant,N''), ISNULL(k_line,N''), ISNULL(k_opn,N''),
                         ISNULL(k_ltype,N''), ISNULL(k_item,N''), ISNULL(k_type,N'')
            ),
            newd AS (         -- 「변경」 = 이번에 확정한 SOP
                SELECT ISNULL(DIVISION_ID,N'') AS DIVISION_ID, ISNULL(PLANT_ID,N'') AS PLANT_ID,
                       ISNULL(LINE_ID,N'') AS LINE_ID, ISNULL(OPERATION_ID,N'') AS OPERATION_ID,
                       ISNULL(LINE_TYPE,N'') AS LINE_TYPE, ISNULL(ITEM_ID,N'') AS ITEM_ID,
                       ISNULL(TYPE,N'') AS TYPE, MIN([DATE]) AS new_date
                FROM #se
                GROUP BY ISNULL(DIVISION_ID,N''), ISNULL(PLANT_ID,N''), ISNULL(LINE_ID,N''),
                         ISNULL(OPERATION_ID,N''),
                         ISNULL(LINE_TYPE,N''), ISNULL(ITEM_ID,N''), ISNULL(TYPE,N'')
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
                   N'SCP_OPMZ_SOP_EOP',
                   c.k_div   COLLATE DATABASE_DEFAULT,
                   c.k_plant COLLATE DATABASE_DEFAULT,
                   c.k_line  COLLATE DATABASE_DEFAULT,
                   c.k_opn   COLLATE DATABASE_DEFAULT,
                   c.k_ltype COLLATE DATABASE_DEFAULT,
                   c.k_item  COLLATE DATABASE_DEFAULT,
                   c.k_date  COLLATE DATABASE_DEFAULT,      -- 그 줄이 가리키는 SOP 날짜(조회 축)
                   NULL,                                    -- SOP 는 점이다 — 끝 날짜가 없다
                   c.k_type  COLLATE DATABASE_DEFAULT,      -- 양식의 「Type」 = SOP
                   /* 삭제 행은 **그 행의 날짜**가 곧 기존이다. `prev` 로 뭉뚱그리면 같은 키에서
                      여러 날짜를 지울 때(소프트삭제 잔재) 전부 한 날짜로 접힌다 — dev 실측에서
                      20261001 을 지운 줄이 20260901 로 보였다. 삽입 행만 `prev` 를 쓴다. */
                   CASE WHEN c.op = N'DELETE' THEN c.k_date COLLATE DATABASE_DEFAULT
                        ELSE p.old_date COLLATE DATABASE_DEFAULT END,
                   NULL,
                   CASE WHEN c.op = N'NOAPPLY' THEN NULL ELSE n.new_date COLLATE DATABASE_DEFAULT END,
                   NULL,
                   /* patch 가 요청한 연산을 적는다(2026-10-02). 네 타겟의 `OP` 칸 뜻을 하나로 맞춘 것이다 —
                      화면 머리칸이 `유형(patch)` 라 여기만 DB 연산이면 그 라벨이 거짓이 된다.
                      DB 가 실제로 한 일은 `DETAIL` 의 `결과=` 가 말한다. 못 찾으면 DB 연산으로 떨어진다. */
                   ISNULL(m.op, c.op) COLLATE DATABASE_DEFAULT,
                   CASE WHEN c.op = N'NOAPPLY' THEN N'NOAPPLY' ELSE N'APPLIED' END,
                   /* 값 칸을 **비운다**(2026-10-02). 이 타겟이 바꾸는 값은 날짜 하나뿐이라
                      「기존/변경」 날짜 칸이 이미 그걸 담는다. 여기에 또 적으면 같은 값이 한 줄에
                      두 번 나오고, 삭제 행은 Value 에 `DELETED` 라는 상태 문자열이 들어간다
                      (그 뜻은 `OP`·`CAUSE` 가 이미 말한다). 화면 캡처로 확인된 중복이다. */
                   NULL,
                   NULL,
                   NULL,
                   NULL,                                    -- NO_WORK_TYPE: 비조업 전용
                   CASE WHEN c.op = N'DELETE' THEN N'DELETE' ELSE NULL END,
                   LEFT(CASE WHEN c.op = N'NOAPPLY'
                             THEN c.tag COLLATE DATABASE_DEFAULT
                             ELSE CONCAT(N'결과=', c.op COLLATE DATABASE_DEFAULT)
                        END, 500),
                   ISNULL(m.opt_id, N'') COLLATE DATABASE_DEFAULT,
                   NULL,
                   m.plan_id COLLATE DATABASE_DEFAULT,
                   @uid,
                   GETDATE()
            FROM #chg c
            LEFT JOIN meta m
                ON  m.DIVISION_ID = ISNULL(c.k_div,  N'') AND m.PLANT_ID = ISNULL(c.k_plant, N'')
                AND m.LINE_ID     = ISNULL(c.k_line, N'') AND m.OPERATION_ID = ISNULL(c.k_opn, N'')
                AND m.LINE_TYPE   = ISNULL(c.k_ltype, N'') AND m.ITEM_ID = ISNULL(c.k_item, N'')
                AND m.TYPE        = ISNULL(c.k_type,  N'')
            LEFT JOIN prev p
                ON  p.k_div   = ISNULL(c.k_div,  N'') AND p.k_plant = ISNULL(c.k_plant, N'')
                AND p.k_line  = ISNULL(c.k_line, N'') AND p.k_opn   = ISNULL(c.k_opn, N'')
                AND p.k_ltype = ISNULL(c.k_ltype, N'') AND p.k_item = ISNULL(c.k_item, N'')
                AND p.k_type  = ISNULL(c.k_type,  N'')
            LEFT JOIN newd n
                ON  n.DIVISION_ID = ISNULL(c.k_div,  N'') AND n.PLANT_ID = ISNULL(c.k_plant, N'')
                AND n.LINE_ID     = ISNULL(c.k_line, N'') AND n.OPERATION_ID = ISNULL(c.k_opn, N'')
                AND n.LINE_TYPE   = ISNULL(c.k_ltype, N'') AND n.ITEM_ID = ISNULL(c.k_item, N'')
                AND n.TYPE        = ISNULL(c.k_type,  N'');
        END TRY
        BEGIN CATCH
            BEGIN TRY
                DECLARE @dtl_err nvarchar(200) = LEFT(ERROR_MESSAGE(), 200);
                SET @LOG_DT = GETDATE();
                EXEC dbo.PR_SCM_SYS_LOG_BATCH
                     @p_program_name = N'PR_SCP_OPMZ_APPLY_SOP_EOP',
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

        -- (3) 행단위 변경 로그 적재 : #chg 의 각 DELETE/INSERT 를 SCM_SYS_LOG_BATCH 에 기록(ATTRIBUTE1~7)
        INSERT INTO dbo.SCM_SYS_LOG_BATCH
            (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,
             ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7)
        SELECT N'PR_SCP_OPMZ_APPLY_SOP_EOP',
               op,                                                       -- 'DELETE' / 'INSERT'
               1,
               CONCAT(N'SOP_EOP ', op),                                                        -- LOG_MESSAGE: 테이블 op 라벨
               CONCAT(N'key=', rowkey, N' | DATE ', ISNULL(bef,N'-'), N'->', ISNULL(aft,N'-')),  -- DESCRIPTION: key + 변경값
               GETDATE(), GETDATE(), @uid, GETDATE(), @uid,   -- 2026-09-30: 감사칸 둘을 비우지 않는다
               N'SCP_OPMZ_SOP_EOP', op, @SNRO_CD, tag, rowkey, bef, aft   -- ATTRIBUTE1=대상테이블 ... 7=after
        FROM #chg;
        /* 7 종료: SOP/EOP 교체 INSERT 완료. */

        /* 8 시작: 커밋. 내가 트랜잭션을 소유한 경우에만 COMMIT(합류한 경우 상위가 커밋). */
        IF @START_TRAN = 1 COMMIT;
        /* 8 종료. */

        /* 9 시작: 성공 로그 적재(삭제+삽입 건수/RESOLVED 요약). */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = ISNULL(@DEL,0) + ISNULL(@INS,0);
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', @OPT_KEY_VAL_ID,
                                        N'; TARGET=', N'SCP_OPMZ_SOP_EOP',
                                        N'; DEL=', @DEL, N' INS=', @INS, N' NOAPPLY=', @NOAPPLY, N' RESOLVED=', @RESOLVED), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_SOP_EOP',
                 @p_log_type     = N'END',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = N'PR_SCP_OPMZ_APPLY_SOP_EOP 완료',
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        /* 9 종료. */

        /* 10 시작: 결과 요약 반환(@RETURN_RESULT_YN='Y'일 때만). */
        IF @RETURN_RESULT_YN = N'Y'
            SELECT @SNRO_CD AS SNRO_CD,
                   N'Y'                          AS SUCCESS_YN,
                   N'SUCCESS'                    AS RESULT_CODE,
                   N'SOP/EOP(생산구간) 반영 완료' AS RESULT_MESSAGE,
                   @INS      AS INSERTED_ROWS,
                   @DEL      AS DELETED_ROWS,
                   @NOAPPLY  AS NOAPPLY_ROWS,
                   @RESOLVED AS RESOLVED_ROWS;
        /* 10 종료. */
    END TRY
    BEGIN CATCH
        /* 11 시작: 오류 시 롤백 → 오류 로그 → 예외 재전파. */
        IF @START_TRAN = 1 AND XACT_STATE() <> 0    -- 내가 소유한 트랜잭션이 아직 살아있으면 롤백
            ROLLBACK;
        SET @ERR_MSG = ERROR_MESSAGE();
        IF @START_TRAN = 1   /* 중첩 호출 시 에러로그는 트랜잭션 소유자(오케스트레이터)가 남김 */
        BEGIN
            SET @LOG_DT  = GETDATE();
            SET @LOG_CNT = 0;
            SET @LOG_DESC = LEFT(CONCAT(N'SNRO=',   @SNRO_CD,
                                        N'; CARD=', @OPT_KEY_VAL_ID,
                                        N'; TARGET=', N'SCP_OPMZ_SOP_EOP'), 500);
            EXEC dbo.PR_SCM_SYS_LOG_BATCH
                 @p_program_name = N'PR_SCP_OPMZ_APPLY_SOP_EOP',
                 @p_log_type     = N'ERROR',
                 @p_log_count    = @LOG_CNT,
                 @p_log_message  = @ERR_MSG,
                 @p_description  = @LOG_DESC,
                 @p_event_date   = @LOG_DT;
        END;
        THROW;   -- 원 예외를 그대로 재전파(상위 트랜잭션/오케스트레이터가 처리)
        /* 11 종료. */
    END CATCH;
END
