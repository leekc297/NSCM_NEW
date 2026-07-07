# Hook — 조회 이상 3증상 진단 플레이북 (오류 없는 0행 / 동일 데이터 2행 중복 / 저장 성공인데 미표시)

> **트리거**: "조회가 안 된다(에러 없음)" / "같은 데이터가 2행 나온다" / "저장은 됐다는데 화면에 안 보인다" —
> 특히 **특정 환경(클라우드)에서만** 발생하는 조회 이상 전부.
>
> **목적**: 2026-07-02 DMF0020 + SYS0012 사고 5건에서 정립한 진단 순서를 표준화 — 추측 없이
> 원인을 단계별로 **기각/확정**하며 좁힌다. (오진 사례 2건 포함 — §5 안티패턴 필독)

작성: 2026-07-02 (DMF0020 조회 중복 / 저장 미표시 / DMF0073 Current-only / SYS0012 silent 0행 / API_M 오진)
관련: `oracle-db-workflow.md` §3 (증상표 진입점), `proc-meta-signature-match.md`, `oracle-save-payload-integrity.md`
상위 룰: `anti-simplification.md`

---

## §0. 대원칙 — "저장 안 됨"과 "안 보임"을 먼저 분리하라

| 신호 | 판정 |
|---|---|
| SAVE 응답 `O_RESULT_CURSOR = {CODE:'0', EVENT:'N'}` | **EVENT = SP INSERT 건수** — N>0 이면 저장+COMMIT 완료. "저장 안 됨"이 아니라 "GET 이 숨김" |
| GET 이 'Current' 류 DUAL UNION 행만 반환 | **배선(API_M/PROC_M)은 정상** — SP WHERE 절 필터를 의심 (§2) |
| 조회 0행 + 에러/로그 아무것도 없음 | 배선 자체가 아니라 **값이 엉뚱한 인자에 꽂혔을 가능성** (§1) |

---

## §1. 오류 없는 0행 (silent) — PROC_M 순서 뒤틀림

**사고 (SYS0012 클라우드 2026-07-02)**: PROC_M 행수 9 = SP 인자 9 로 "개수는 정합"인데
COL_NM **순서만 뒤틀림** (2~7: divisionId, userId, department, startDate, endDate, status).
전부 VARCHAR 라 PLS-00306 도 안 나고 SP 는 정상 실행 — `P_STATUS` 에 시작일('20260602')이
꽂혀 상태 분기(ALL/REQUEST/…)가 전부 불일치 → **항상 0행**.

**진단 (위치+이름 대조 — 행수 카운트만으로는 못 잡는다)**:
```sql
WITH EXPECT (POS, COL_NM) AS ( /* 사내 정상 순서를 기대값으로 나열 */ )
SELECT E.POS, A.ARGUMENT_NAME SP_ARG, P.COL_NM PROC_M_COL, E.COL_NM EXPECTED_COL,
       CASE WHEN A.POSITION IS NULL THEN '*** SP 인자 없음' WHEN P.SORT_ORD IS NULL THEN '*** PROC_M 행 없음'
            WHEN P.COL_NM <> E.COL_NM THEN '*** 순서/이름 뒤틀림' ELSE 'OK' END CHK
FROM EXPECT E
LEFT JOIN (SELECT POSITION, ARGUMENT_NAME FROM ALL_ARGUMENTS
            WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{SP}' AND PACKAGE_NAME IS NULL) A ON A.POSITION=E.POS
LEFT JOIN (SELECT SORT_ORD, COL_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{SP}') P ON P.SORT_ORD=E.POS
ORDER BY E.POS;
```

**교정 (⚠ PROC_M PK = (PROC_NM, COL_NM, COL_TP_CD) — COL_NM UPDATE 는 ORA-00001!)**:
- ✅ **단일 CASE UPDATE 로 SORT_ORD 스왑** (문장 단위 일관성 — swap 안전):
  `UPDATE ... SET SORT_ORD = CASE COL_NM WHEN 'userId' THEN 2 ... END WHERE PROC_NM=... AND COL_NM IN (...)`
- ✅ 이관 스크립트는 **SP 단위 DELETE 후 INSERT** (PK 구조 무관·멱등)
- ❌ MERGE ON (PROC_NM, SORT_ORD) + UPDATE COL_NM — 클라우드에서 ORA-00001
- BE 는 매 요청 PROC_M 재조회 (`GeneralServiceImpl` → `makeProcedure`) — **교정 COMMIT 즉시 반영, BE 재시작 불필요**

→ 상세: `proc-meta-signature-match.md` §0.4

## §2. 'Current' 류만 반환 — WHERE 절 변환 잔재

**사고 (DMF0073_GET_VERSION_SALESPRICE)**: `NVL(ATTRIBUTE1, NULL) <> 'MOVE'` — ISNULL→NVL
변환 사고로 NULL 행 전부 제외 → DUAL UNION 'Current' 행만 반환. 배선은 완전 정상이었음.

**진단**: 데이터 행만 0 이면 WHERE 필터를 컬럼별 분리 COUNT 로 이등분 탐색.
**교정**: `NVL(x, '-') <> 'MOVE'` (placeholder 생존) — SP 원본 보존 + 해당 줄만 수정.

## §3. 동일 데이터 2행 중복 — PIVOT 암묵 GROUP BY 행 분열

**사고 (DMF0020)**: 최종 커서 `PIVOT(MAX(PRICE))` 는 **모든 비피벗 컬럼을 암묵 GROUP BY** —
"완전히 같은 2행"은 불가능하고, 반드시 **화면 비표시 컬럼 1개가 다른 것**이다.
원인 = 판가 `'-'` vs 판매계획 `'--'`/`' '` 의 **placeholder 표기차** → 조합 분열.

**진단 순서** (기각하며 좁히기):
1. JOIN 마스터 키 중복 (GROUP BY HAVING>1) — 전 마스터
2. 주차별 갈리는 비피벗 컬럼 (PRICE_EXIST 등)
3. ⭐ **GTT 세션 진단** — GET SP 가 `ON COMMIT PRESERVE ROWS` GTT 사용 시, SP 호출한 **같은 세션**에서
   GTT 를 필드별 `COUNT(DISTINCT ...)` 요약 조회 → **2 이상인 필드 = 원인** (DMF0020: `GT_FTPR_TMPOUTPUT`)
4. 동급 대안: **F12 Network 응답에서 중복 2행 JSON diff** (DB 접속 불필요·즉시)

**교정**: **GTT 적재 시점 정규화** — `CASE WHEN TRIM(x) IS NULL OR TRIM(x) IN ('-','--') THEN '-' ELSE x END`.
적재부가 유일한 안전 지점 (하류 9키 조인이 전부 GTT 참조). raw 테이블 직접 조인 구간(over-range)은 raw 측에 동일식.
**회귀검증 표준**: division 별 (행수, 업무키 DISTINCT, **SUM(가격)**) 전후 비교 — **합계 불변 + 키만 감소 = 무손실 병합 증명**.

## §4. 저장 성공(EVENT=N)인데 화면 미표시

1. **DB 실착지 확인** (기간/작성자로 SELECT) — EVENT=N 이면 반드시 있음
2. **GET 마스터 EXISTS 필터 4종** 검사 — 그 조합이 필터를 통과하는가:
   `SCM_MST_SITE(VALID_YN='Y')` / `SITE(SITE_TYPE='SALES')` / **`SCM_MST_SITE_ITEM(VALID_YN='Y')` ⭐ 최유력** / `SCM_MST_ITEM_SN`
   — Insert 팝업은 Project/Item 을 **각각** 보여주므로 SITE_ITEM **매핑이 없는 조합** 입력이 가능 (사내에도 없으면 시드누락 아님 — 정상 필터)
3. 필터 전부 통과인데 안 보이면 → **정렬 위치**: 신규 행은 저장 전 그리드 맨 위 → 재조회 후 SP 정렬 위치로 이동.
   FE 표준: 저장한 첫 행 키를 ref 에 기억 → 재조회 데이터 로드 후 `scrollIntoView + select` (DMF0020 SalesFuturePrice 참조)

## §4.5. 기존 데이터인데 "신규 폼/기본값" 반환 — 변환 SP 의 찾은 값 미사용 (2026-07-03 추가)

증상: 기존재 데이터 조합으로 조회하는데 SP 가 신규 입력 폼(식별자 NULL·일자 SYSDATE)을 반환.

원인: MSSQL→Oracle 변환 SP 가 **내부에서 찾아낸 식별자(`SELECT ... INTO v_xxx`)를 후속 판정/조회에 쓰지 않고
파라미터 원본(공란)을 계속 사용** — MSSQL 원문의 파라미터 재할당(`SET @p = @v`) 체인이 변환에서 소실된 패턴.
컴파일 VALID + 커서 정상 오픈이라 silent.

진단: SP body 에서 `INTO v_` 로 받은 변수의 **후속 사용처를 추적** — 판정 IF/후속 WHERE 가 v_ 인지 P_ 인지 대조.
교정: `v_xxx := NVL(v_xxx, P_XXX)` 승계 또는 초기화 `v_xxx := P_XXX` 후 전 구간 v_ 통일.
사례: DMF0003_GET_PRPOPUP View_PR — v_request_no 를 찾고도 P_REQUEST_NO(공란)로 판정 → 기존 PR 이 신규 폼으로 반환 (2026-07-03 fix).

## §5. 안티패턴 (이번 사고에서 실제 범한 오진 2건)

| ❌ 오진 | 교훈 |
|---|---|
| `API_URL LIKE '%{MNU_ID}%'` 로 API_M 존재 검사 → "누락" 오판 | API_URL = **SP 명** (메뉴ID 미포함 다수). **API_ID 정확 일치**로 조회. 체인 확정 = `PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(MNU,SHT,BTN)` 1콜 (SELECT INTO — API_M 누락 시 NO_DATA_FOUND) |
| PROC_M 대조를 "위치별 존재"만 비교 → 순서 뒤틀림을 OK 오판 | **위치별 COL_NM 이름까지** 기대값과 대조 (§1 SQL) |
| placeholder 겹침 검사를 `'--'` 만 확인 | `' '`(공백)/NULL 변형 전수 — **값 분포(GROUP BY) 먼저** |

---

## cross-ref

- 진입: `oracle-db-workflow.md` §3 증상표 → 본 hook
- 실전 진단 SQL 원본: `_artifacts/_deploy_packages/DMF0020_CLOUD_20260702/05_DIAGNOSE/9x0_*.sql`, `SYS0012_APPROVAL_20260702/90_DIAGNOSE/900_*.sql`
- 메모리: `feedback_plant_placeholder_pivot_split`, `feedback_api_m_diagnosis_by_api_id`, `feedback_proc_meta_must_match_sp_signature`, `feedback_isnull_to_nvl_null_handling`

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-07-02 | 초안 — DMF0020/DMF0073/SYS0012 사고 5건 통합 정립 |
| 2026-07-03 | §4.5 추가 — 변환 SP 찾은 값 미사용(파라미터 재할당 소실) 패턴 (DMF0003 View_PR) |
