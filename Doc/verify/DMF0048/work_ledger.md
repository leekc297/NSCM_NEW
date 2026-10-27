# 작업 원장 — DMF0048 · 2026-10-26 12:50

> 검사 인스턴스 544건 중 PASS·NA 39건 외 **505건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 42 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 136 | 실행 → PASS |
| W7 | 기대값 확정 | 295 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 292 · E2E 136 · 대조표 45 · 하네스 32
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 9건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 96 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 42 |  |  |  |  | 3 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 16 | 14 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| B3 | COMBO |  |  |  | 5 |  |  | 22 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 5 |  | 22 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 8 | 15 |  |  | 연쇄 자동 채움 |
| F4 | DB |  |  |  |  |  | 14 | 8 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G1 | GEN |  |  |  |  |  | 14 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C1 | CASCADE |  |  |  |  |  | 8 | 11 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A1 | GEN |  |  |  |  |  |  | 19 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| DB-SYN | DB |  |  |  |  | 9 |  | 8 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 11 | 6 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| H2 | DESIGN |  |  |  |  |  | 1 | 14 |  |  | 배경·글자색 규칙 |
| G4 | DESIGN |  |  |  |  |  | 14 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 14 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C2 | CASCADE |  |  |  |  |  | 2 | 10 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 2 | 10 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D3 | EDIT |  |  |  |  |  | 2 | 9 |  |  | 행 값 기반 조건부 잠금 |
| H5 | DESIGN |  |  |  |  |  | 5 | 5 |  |  | 라벨 명칭 |
| G5 | POPUP |  |  |  |  | 6 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 | 1 | 1 |  |  | 팝업 표준·열림 |
| A5 | DESIGN |  |  |  |  |  | 1 | 6 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| M3 | POPUP |  |  |  |  |  | 6 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| M4 | POPUP |  |  |  |  |  | 5 | 1 |  |  | 팝업 선택값 반영 |
| D1 | EDIT |  |  |  |  |  | 2 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D5 | EDIT |  |  |  |  |  | 1 | 3 |  |  | 셀 에디터 유형 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (42)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0048-0001 | X-LOC | (Excel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((Excel)) |
| WK-DMF0048-0002 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-DMF0048-0003 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 0 () |
| WK-DMF0048-0004 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 0 () |
| WK-DMF0048-0005 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-DMF0048-0006 | X-LOC | 12~19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12~19) |
| WK-DMF0048-0007 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-DMF0048-0008 | X-LOC | 14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (14) |
| WK-DMF0048-0009 | X-LOC | 15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (15) |
| WK-DMF0048-0010 | X-LOC | 16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (16) |
| WK-DMF0048-0011 | X-LOC | 17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (17) |
| WK-DMF0048-0012 | X-LOC | 18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (18) |
| WK-DMF0048-0013 | X-LOC | 19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (19) |
| WK-DMF0048-0014 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-DMF0048-0015 | X-LOC | 20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 0 () |
| WK-DMF0048-0016 | X-LOC | 21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (21) |
| WK-DMF0048-0017 | X-LOC | 22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (22) |
| WK-DMF0048-0018 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-DMF0048-0019 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-DMF0048-0020 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-DMF0048-0021 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-DMF0048-0022 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-DMF0048-0023 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-DMF0048-0024 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-DMF0048-0025 | X-LOC | COLUMN_SETUP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COLUMN_SETUP) |
| WK-DMF0048-0026 | X-LOC | EXCEL(F12) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EXCEL(F12)) |
| WK-DMF0048-0027 | X-LOC | FE 신규 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: MeasureSelectModal.tsx 없음 |  | 1 (FE 신규) |
| WK-DMF0048-0028 | X-LOC | INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2)) |
| WK-DMF0048-0029 | X-LOC | MEASURE_SELECT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MEASURE_SELECT) |
| WK-DMF0048-0030 | X-LOC | SEARCH(F5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SEARCH(F5)) |
| WK-DMF0048-0031 | X-LOC | SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET() |
| WK-DMF0048-0032 | X-LOC | `DM.DMF0003_GET_BUCKET_TYPE_CODE` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DM.DMF0003_GET_BUCKET_TYPE_CODE`) |
| WK-DMF0048-0033 | X-LOC | `DM.DMF0048_GET_DM_PLN_SALES_MONITORING` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0034 | X-LOC | `DM.DMF0048_GET_SPREAD_TITLE` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DM.DMF0048_GET_SPREAD_TITLE`) |
| WK-DMF0048-0035 | X-LOC | `DM.PR_GET_DAY_RANGE` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0036 | X-LOC | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`) |
| WK-DMF0048-0037 | X-LOC | `SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_CUSTOMER_BY_DIVISION`) |
| WK-DMF0048-0038 | X-LOC | `SCM.SCM0001_GET_DIVISION` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_DIVISION`) |
| WK-DMF0048-0039 | X-LOC | `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0040 | X-LOC | `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0041 | X-LOC | `SCM.SCM0001_GET_SITE_BY_DIVISION` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_SITE_BY_DIVISION`) |
| WK-DMF0048-0042 | X-LOC | `SCM.SCM0001_GET_TEAM_BY_DIVISION` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM.SCM0001_GET_TEAM_BY_DIVISION`) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0048-0043 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |
| WK-DMF0048-0044 | B3 | clbCustomer / End Customer / Customer | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbCustomer / End Customer / Customer | 있음(FE 소스) | 2 (ACT:DMF0048_SalesPlanMonitoring.clbCusto) |
| WK-DMF0048-0045 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |
| WK-DMF0048-0046 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 3 (ACT:DMF0048_SalesPlanMonitoring.clbDivis) |
| WK-DMF0048-0047 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 5 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0048-0048 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |
| WK-DMF0048-0049 | B4 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 2 (ACT:DMF0048_SalesPlanMonitoring.clbCusto) |
| WK-DMF0048-0050 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |
| WK-DMF0048-0051 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 3 (ACT:DMF0048_SalesPlanMonitoring.clbDivis) |
| WK-DMF0048-0052 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 5 (ACT:DMF0048_SalesMonitoring.GetSpdTitle ) |
| WK-DMF0048-0053 | F2 | DMF0048 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0048 화면 | 판단불가(대상 단위 SCREEN) | 2 (12~19 INSERT(F8)/DELETE(F9)/SAVE(F7)/EDI) |
| WK-DMF0048-0054 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0048_SalesPlanMonitoring.GetBucke) |
| WK-DMF0048-0055 | DB-SYN | DMF0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (`DM.DMF0003_GET_BUCKET_TYPE_CODE` ACT:DM) |
| WK-DMF0048-0056 | DB-SYN | DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0021_GET_SALES_PLAN_MEASUREINFO2 | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0048_SalesPlanMonitoring.GetSALES) |
| WK-DMF0048-0057 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 7 (`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` A) |
| WK-DMF0048-0058 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 7 (`SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` A) |
| WK-DMF0048-0059 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 5 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0060 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 5 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0061 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 5 (`SCM.SCM0001_GET_SITE_BY_DIVISION` ACT:D) |
| WK-DMF0048-0062 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 5 (`SCM.SCM0001_GET_TEAM_BY_DIVISION` ACT:D) |
| WK-DMF0048-0063 | G03-WIRE | DMF0048 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0048 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:DMF0048_SalesMonitoring..ctor ACT:DM) |
| WK-DMF0048-0064 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (1) |
| WK-DMF0048-0065 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-DMF0048-0066 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (1) |
| WK-DMF0048-0067 | G5 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnOwner | 있음(FE 소스) | 1 (2) |
| WK-DMF0048-0068 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 1 (9) |
| WK-DMF0048-0069 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 10 (ACT:DMF0048_SalesMonitoring.btnColumn_Cl) |
| WK-DMF0048-0070 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (1) |
| WK-DMF0048-0071 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-DMF0048-0072 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (1) |
| WK-DMF0048-0073 | H6 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnOwner | 있음(FE 소스) | 1 (2) |
| WK-DMF0048-0074 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 1 (9) |

## W6 검증 실행 (136)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0048-0075 | J2 | DMF0048 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0048 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 116 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0076 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0077 | C1 | clbBizType / Biz.Type / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0078 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0079 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0080 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0081 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0082 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0083 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0084 | C2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0085 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 71 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0086 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0087 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:DMF0048_SalesMonitoring.SetChangeCon) |
| WK-DMF0048-0088 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0089 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0090 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 91 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0091 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:DMF0048_SalesMonitoring.FindData:799) |
| WK-DMF0048-0092 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0093 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0094 | C6 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0095 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 71 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0096 | K4 | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 108 (ACT:DMF0048_SalesMonitoring.btnColumn_Cl) |
| WK-DMF0048-0097 | F1 | DMF0048 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0048 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 2 (12~19 INSERT(F8)/DELETE(F9)/SAVE(F7)/EDI) |
| WK-DMF0048-0098 | F5 | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2)) |
| WK-DMF0048-0099 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0048_SalesPlanMonitoring.GetBucke) |
| WK-DMF0048-0100 | F4 | DMF0002_GET_TITLESET_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0002_GET_TITLESET_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (1) |
| WK-DMF0048-0101 | F4 | DMF0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (`DM.DMF0003_GET_BUCKET_TYPE_CODE` ACT:DM) |
| WK-DMF0048-0102 | F4 | DMF0021_GET_SALES_PLAN_MEASUREINFO2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0021_GET_SALES_PLAN_MEASUREINFO2 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 2 (ACT:DMF0048_SalesPlanMonitoring.GetSALES) |
| WK-DMF0048-0103 | F4 | PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 2 (ACT:DMF0048_SalesPlanMonitoring.GetSALES) |
| WK-DMF0048-0104 | F4 | PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 248 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0105 | F4 | PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 248 (`DM.DMF0048_GET_SPREAD_TITLE` ACT:DMF004) |
| WK-DMF0048-0106 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 7 (`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` A) |
| WK-DMF0048-0107 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 7 (`SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` A) |
| WK-DMF0048-0108 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (`SCM.SCM0001_GET_DIVISION` ACT:DMF0048_S) |
| WK-DMF0048-0109 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 5 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0110 | F4 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 5 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0111 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 5 (`SCM.SCM0001_GET_SITE_BY_DIVISION` ACT:D) |
| WK-DMF0048-0112 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 5 (`SCM.SCM0001_GET_TEAM_BY_DIVISION` ACT:D) |
| WK-DMF0048-0113 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0114 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0115 | G4 | cboUnitYN / Unit YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboUnitYN / Unit YN · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0048_SalesPlanMonitoring.InitCont) |
| WK-DMF0048-0116 | G4 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkColor / Color · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0117 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0118 | G4 | clbBizType / Biz.Type / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0119 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0120 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0121 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0122 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0123 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0124 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0125 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 28 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0126 | G4 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0127 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0128 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0129 | H4 | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.spdMain_TopC) |
| WK-DMF0048-0130 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 12 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0131 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 65 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0132 | H5 | chkColor / Color | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkColor / Color · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 36 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0133 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0134 | H5 | drpPeriod / Period | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — drpPeriod / Period · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 18 (ACT:DMF0048_SalesMonitoring.InitSpread A) |
| WK-DMF0048-0135 | I1 | DMF0048 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0048 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 14 (ACT:DMF0048_SalesMonitoring.FindData:625) |
| WK-DMF0048-0136 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:735) |
| WK-DMF0048-0137 | D1 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0048-0138 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:735) |
| WK-DMF0048-0139 | D3 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — S · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0048-0140 | D5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 12 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0141 | D6 | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (8 INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) |
| WK-DMF0048-0142 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:DMF0048_SalesMonitoring.SetChangeCon) |
| WK-DMF0048-0143 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0144 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0145 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 20 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0146 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:671) |
| WK-DMF0048-0147 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:638) |
| WK-DMF0048-0148 | E4 | MSG00137 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00137 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:625) |
| WK-DMF0048-0149 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0048_SalesMonitoring.FindData:645) |
| WK-DMF0048-0150 | E4 | MSG00227 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00227 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0048_SalesMonitoring.cboBucketTyp) |
| WK-DMF0048-0151 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0152 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0153 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0048_SalesMonitoring.SetSaveData ) |
| WK-DMF0048-0154 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 95 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0155 | E4 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 36 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0156 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0157 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0048_SalesMonitoring.FindData:645) |
| WK-DMF0048-0158 | A10 | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 176 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0159 | A6 | DMF0002_GET_TITLESET_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0002_GET_TITLESET_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 1 (1) |
| WK-DMF0048-0160 | A6 | DMF0003_GET_BUCKET_TYPE_CODE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0003_GET_BUCKET_TYPE_CODE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (`DM.DMF0003_GET_BUCKET_TYPE_CODE`) |
| WK-DMF0048-0161 | A6 | PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_M | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 248 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0162 | A6 | PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 244 (`DM.DMF0048_GET_SPREAD_TITLE` ACT:DMF004) |
| WK-DMF0048-0163 | A6 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 1 (`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`) |
| WK-DMF0048-0164 | A6 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 1 (`SCM.SCM0001_GET_CUSTOMER_BY_DIVISION`) |
| WK-DMF0048-0165 | A6 | SCM0001_GET_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 1 (`SCM.SCM0001_GET_DIVISION`) |
| WK-DMF0048-0166 | A6 | SCM0001_GET_LOOKUP_VALUES | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 1 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0167 | A6 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0168 | A6 | SCM0001_GET_SITE_BY_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (`SCM.SCM0001_GET_SITE_BY_DIVISION`) |
| WK-DMF0048-0169 | A6 | SCM0001_GET_TEAM_BY_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (`SCM.SCM0001_GET_TEAM_BY_DIVISION`) |
| WK-DMF0048-0170 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 37 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0171 | G1 | cboUnitYN / Unit YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboUnitYN / Unit YN · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0048_SalesPlanMonitoring.FindData) |
| WK-DMF0048-0172 | G1 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkColor / Color · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 12 (ACT:DMF0048_SalesMonitoring.FindData:765) |
| WK-DMF0048-0173 | G1 | clbBizType / Biz.Type / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0174 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0175 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0176 | G1 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbItemType / Item Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0177 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0178 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0179 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0180 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 16 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0181 | G1 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0182 | G1 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtOwner / Owner · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0183 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0048_SalesMonitoring.FindData ACT) |
| WK-DMF0048-0184 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0185 | G6 | cboUnitYN / Unit YN | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboUnitYN / Unit YN · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0048_SalesPlanMonitoring.InitCont) |
| WK-DMF0048-0186 | G6 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0187 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0188 | G6 | clbBizType / Biz.Type / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz.Type / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0189 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0190 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 13 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0191 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0192 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0193 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0194 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0195 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 26 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0196 | G6 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0197 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0198 | X-REOPEN | DMF0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0048 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 33 (ACT:DMF0048_SalesMonitoring.Dispose ACT:) |
| WK-DMF0048-0199 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 10 (ACT:DMF0048_SalesMonitoring.btnColumn_Cl) |
| WK-DMF0048-0200 | M3 | DMF0048_SalesPlanMonitoring | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0048_SalesPlanMonitoring · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 34 (ACT:DMF0048_SalesPlanMonitoring..ctor AC) |
| WK-DMF0048-0201 | M3 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0048_SalesPlanMonitoring.btnColum) |
| WK-DMF0048-0202 | M3 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesPlanMonitoring.btnItemI) |
| WK-DMF0048-0203 | M3 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0048_SalesPlanMonitoring.btnMeasu) |
| WK-DMF0048-0204 | M3 | btnOwner | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnOwner · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0048_SalesPlanMonitoring.btnOwner) |
| WK-DMF0048-0205 | M3 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 4 (ACT:DMF0048_SalesPlanMonitoring.btnProje) |
| WK-DMF0048-0206 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (1) |
| WK-DMF0048-0207 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0048-0208 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (1) |
| WK-DMF0048-0209 | M4 | btnOwner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnOwner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (2) |
| WK-DMF0048-0210 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (9) |

## W7 기대값 확정 (295)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0048-0211 | C1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 10: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0212 | C1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 11: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0213 | C1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 14: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-DMF0048-0214 | C1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 15: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-DMF0048-0215 | C1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 16: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-DMF0048-0216 | C1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 17: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-DMF0048-0217 | C1 | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 18: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (18) |
| WK-DMF0048-0218 | C1 | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 19: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (19) |
| WK-DMF0048-0219 | C1 | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 21: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (21) |
| WK-DMF0048-0220 | C1 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 22: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (22) |
| WK-DMF0048-0221 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0222 | C2 | DMF0048_SalesMonitoring.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.Dsdm_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0223 | C2 | DMF0048_SalesMonitoring.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.cboBucketType_SelectedInde: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0048_SalesMonitoring.cboBucketTyp) |
| WK-DMF0048-0224 | C2 | DMF0048_SalesMonitoring.cboKRW_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.cboKRW_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboKRW_Selec) |
| WK-DMF0048-0225 | C2 | DMF0048_SalesMonitoring.cboLOC_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.cboLOC_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboLOC_Selec) |
| WK-DMF0048-0226 | C2 | DMF0048_SalesMonitoring.cboUSD_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.cboUSD_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboUSD_Selec) |
| WK-DMF0048-0227 | C2 | DMF0048_SalesMonitoring.chkColor_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.chkColor_CheckedChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkColor_Che) |
| WK-DMF0048-0228 | C2 | DMF0048_SalesMonitoring.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.chkSum_CheckedChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkSum_Check) |
| WK-DMF0048-0229 | C2 | DMF0048_SalesMonitoring.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.clbCustomer_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0230 | C2 | DMF0048_SalesMonitoring.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.clbDivision_SelectedIndexC: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0048_SalesMonitoring.clbDivision_) |
| WK-DMF0048-0231 | C2 | DMF0048_SalesMonitoring.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0048_SalesMonitoring.clbTeam_SelectedIndexChang: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0048_SalesMonitoring.clbTeam_Sele) |
| WK-DMF0048-0232 | C3 | DMF0048_SalesMonitoring.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.Dsdm_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0233 | C3 | DMF0048_SalesMonitoring.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0048_SalesMonitoring.SetChangeCon) |
| WK-DMF0048-0234 | C3 | DMF0048_SalesMonitoring.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.SetSaveData: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesMonitoring.SetSaveData:) |
| WK-DMF0048-0235 | C3 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0236 | C3 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0237 | C3 | DMF0048_SalesMonitoring.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.cboBucketType_SelectedInde: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0048_SalesMonitoring.cboBucketTyp) |
| WK-DMF0048-0238 | C3 | DMF0048_SalesMonitoring.cboKRW_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.cboKRW_SelectedIndexChange: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboKRW_Selec) |
| WK-DMF0048-0239 | C3 | DMF0048_SalesMonitoring.cboLOC_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.cboLOC_SelectedIndexChange: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboLOC_Selec) |
| WK-DMF0048-0240 | C3 | DMF0048_SalesMonitoring.cboUSD_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.cboUSD_SelectedIndexChange: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboUSD_Selec) |
| WK-DMF0048-0241 | C3 | DMF0048_SalesMonitoring.chkColor_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.chkColor_CheckedChanged: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkColor_Che) |
| WK-DMF0048-0242 | C3 | DMF0048_SalesMonitoring.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.chkSum_CheckedChanged: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkSum_Check) |
| WK-DMF0048-0243 | C3 | DMF0048_SalesMonitoring.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.clbCustomer_SelectedIndexC: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0244 | C3 | DMF0048_SalesMonitoring.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.clbDivision_SelectedIndexC: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0048_SalesMonitoring.clbDivision_) |
| WK-DMF0048-0245 | C3 | DMF0048_SalesMonitoring.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.clbTeam_SelectedIndexChang: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0048_SalesMonitoring.clbTeam_Sele) |
| WK-DMF0048-0246 | C3 | DMF0048_SalesMonitoring.setResultPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0048_SalesMonitoring.setResultPeriod: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.setResultPer) |
| WK-DMF0048-0247 | C6 | DMF0048_SalesMonitoring.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.Dsdm_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0248 | C6 | DMF0048_SalesMonitoring.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.cboBucketType_SelectedInde: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0048_SalesMonitoring.cboBucketTyp) |
| WK-DMF0048-0249 | C6 | DMF0048_SalesMonitoring.cboKRW_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.cboKRW_SelectedIndexChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboKRW_Selec) |
| WK-DMF0048-0250 | C6 | DMF0048_SalesMonitoring.cboLOC_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.cboLOC_SelectedIndexChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboLOC_Selec) |
| WK-DMF0048-0251 | C6 | DMF0048_SalesMonitoring.cboUSD_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.cboUSD_SelectedIndexChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.cboUSD_Selec) |
| WK-DMF0048-0252 | C6 | DMF0048_SalesMonitoring.chkColor_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.chkColor_CheckedChanged: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkColor_Che) |
| WK-DMF0048-0253 | C6 | DMF0048_SalesMonitoring.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.chkSum_CheckedChanged: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkSum_Check) |
| WK-DMF0048-0254 | C6 | DMF0048_SalesMonitoring.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.clbCustomer_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.clbCustomer_) |
| WK-DMF0048-0255 | C6 | DMF0048_SalesMonitoring.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.clbDivision_SelectedIndexC: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0048_SalesMonitoring.clbDivision_) |
| WK-DMF0048-0256 | C6 | DMF0048_SalesMonitoring.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0048_SalesMonitoring.clbTeam_SelectedIndexChang: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0048_SalesMonitoring.clbTeam_Sele) |
| WK-DMF0048-0257 | B3 | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0258 | B3 | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivisionAsync: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0259 | B3 | DMF0048_SalesMonitoring.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetBucketType: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetBucketTyp) |
| WK-DMF0048-0260 | B3 | DMF0048_SalesMonitoring.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetCellColor: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetCellColor) |
| WK-DMF0048-0261 | B3 | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0262 | B3 | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivisionAsync: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0263 | B3 | DMF0048_SalesMonitoring.GetDataTableMear | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetDataTableMeargeForDate: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0048_SalesMonitoring.GetDataTable) |
| WK-DMF0048-0264 | B3 | DMF0048_SalesMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetDayRange: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetDayRange:) |
| WK-DMF0048-0265 | B3 | DMF0048_SalesMonitoring.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetDivision:) |
| WK-DMF0048-0266 | B3 | DMF0048_SalesMonitoring.GetEndCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetEndCustomerbyDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetEndCustom) |
| WK-DMF0048-0267 | B3 | DMF0048_SalesMonitoring.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetItemType: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetItemType:) |
| WK-DMF0048-0268 | B3 | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomer: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0269 | B3 | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomerA: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0270 | B3 | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0271 | B3 | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivisionAsync: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0272 | B3 | DMF0048_SalesMonitoring.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetSpdTitle:) |
| WK-DMF0048-0273 | B3 | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivision: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0274 | B3 | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivisionAsync: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0275 | B3 | DMF0048_SalesMonitoring.GetThisWeekMonda | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0048_SalesMonitoring.GetThisWeekMonday: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesMonitoring.GetThisWeekM) |
| WK-DMF0048-0276 | B3 | `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemType): 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0277 | B3 | `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER`: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0278 | B3 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM.SCM0001_GET_SITE_BY_DIVISION`: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_SITE_BY_DIVISION`) |
| WK-DMF0048-0279 | B4 | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0280 | B4 | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivisionAsync: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0281 | B4 | DMF0048_SalesMonitoring.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetBucketType: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetBucketTyp) |
| WK-DMF0048-0282 | B4 | DMF0048_SalesMonitoring.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetCellColor: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetCellColor) |
| WK-DMF0048-0283 | B4 | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0284 | B4 | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivisionAsync: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0285 | B4 | DMF0048_SalesMonitoring.GetDataTableMear | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetDataTableMeargeForDate: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0048_SalesMonitoring.GetDataTable) |
| WK-DMF0048-0286 | B4 | DMF0048_SalesMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetDayRange: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetDayRange:) |
| WK-DMF0048-0287 | B4 | DMF0048_SalesMonitoring.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetDivision:) |
| WK-DMF0048-0288 | B4 | DMF0048_SalesMonitoring.GetEndCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetEndCustomerbyDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.GetEndCustom) |
| WK-DMF0048-0289 | B4 | DMF0048_SalesMonitoring.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetItemType: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetItemType:) |
| WK-DMF0048-0290 | B4 | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomer: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0291 | B4 | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomerA: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0292 | B4 | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0293 | B4 | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivisionAsync: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0294 | B4 | DMF0048_SalesMonitoring.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetSpdTitle: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetSpdTitle:) |
| WK-DMF0048-0295 | B4 | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivision: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0296 | B4 | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivisionAsync: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0297 | B4 | DMF0048_SalesMonitoring.GetThisWeekMonda | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0048_SalesMonitoring.GetThisWeekMonday: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesMonitoring.GetThisWeekM) |
| WK-DMF0048-0298 | B4 | `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemType): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0299 | B4 | `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER`: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0300 | B4 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM.SCM0001_GET_SITE_BY_DIVISION`: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM.SCM0001_GET_SITE_BY_DIVISION`) |
| WK-DMF0048-0301 | DB-SYN | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 4: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0302 | DB-SYN | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 5: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0303 | DB-SYN | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 6: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0304 | DB-SYN | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 7: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0305 | DB-SYN | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 8: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0306 | DB-SYN | DMF0048_SalesMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0048_SalesMonitoring.GetDayRange: 진입점 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetDayRange:) |
| WK-DMF0048-0307 | DB-SYN | DMF0048_SalesPlanMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0048_SalesPlanMonitoring.GetDayRange: 진입점 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesPlanMonitoring.GetDayRa) |
| WK-DMF0048-0308 | DB-SYN | `DM.PR_GET_DAY_RANGE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `DM.PR_GET_DAY_RANGE`: 행 집계 — DB-SYN 14요소: NOPATH:9 · PASS:5 (미실행 요소가 남아 판정필요) |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0309 | F4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 4: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0310 | F4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 5: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0311 | F4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 6: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0312 | F4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 7: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0313 | F4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 8: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0314 | F4 | DMF0048_SalesMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0048_SalesMonitoring.GetDayRange: 진입점 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.GetDayRange:) |
| WK-DMF0048-0315 | F4 | DMF0048_SalesPlanMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0048_SalesPlanMonitoring.GetDayRange: 진입점 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesPlanMonitoring.GetDayRa) |
| WK-DMF0048-0316 | F4 | `DM.PR_GET_DAY_RANGE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `DM.PR_GET_DAY_RANGE`: 행 집계 — F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0317 | A5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0048-0318 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0048-0319 | A5 | DMF0048_SalesMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0048_SalesMonitoring.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.CreateSpread) |
| WK-DMF0048-0320 | A5 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0321 | A5 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0322 | A5 | INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2)) |
| WK-DMF0048-0323 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0048-0324 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0325 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0326 | H2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-DMF0048-0327 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-DMF0048-0328 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-DMF0048-0329 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0048-0330 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-DMF0048-0331 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0048-0332 | H2 | DMF0048_SalesMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0048_SalesMonitoring.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.CreateSpread) |
| WK-DMF0048-0333 | H2 | DMF0048_SalesMonitoring.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0048_SalesMonitoring.GetCellColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.GetCellColor) |
| WK-DMF0048-0334 | H2 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0335 | H2 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0336 | H2 | DMF0048_SalesMonitoring.chkColor_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0048_SalesMonitoring.chkColor_CheckedChanged: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.chkColor_Che) |
| WK-DMF0048-0337 | H5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0048-0338 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0339 | H5 | DMF0048_SalesMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0048_SalesMonitoring.CreateSpread: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.CreateSpread) |
| WK-DMF0048-0340 | H5 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0341 | H5 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0342 | X-REASON | 10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 10 Dsdm_Changed L1398 (silent) `e.Column/Row < 0` 가드 N/A — read-only (편집 이벤트 없음) |  | 1 (10) |
| WK-DMF0048-0343 | X-REASON | 11 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 11 Dsdm_Changed L1413 (silent) MEASURE 공란 가드 N/A — read-only |  | 1 (11) |
| WK-DMF0048-0344 | X-REASON | 23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 23 cboBucketType_Click L2173 MSG00227 Insert 행 존재 시 Bucket 변경 불가 N/A — read-only (Insert 미지원). MSG 상수는 기록 보존 |  | 1 (23) |
| WK-DMF0048-0345 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0048-0346 | D1 | INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2): 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2)) |
| WK-DMF0048-0347 | D3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0348 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0349 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-DMF0048-0350 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-DMF0048-0351 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-DMF0048-0352 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0048-0353 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-DMF0048-0354 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0048-0355 | D3 | INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2): 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2)) |
| WK-DMF0048-0356 | D5 | DMF0048_SalesMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0048_SalesMonitoring.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.CreateSpread) |
| WK-DMF0048-0357 | D5 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0358 | D5 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0359 | E4 | 12~19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 12~19: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (12~19) |
| WK-DMF0048-0360 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0361 | E4 | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 21: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (21) |
| WK-DMF0048-0362 | E4 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 22: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (22) |
| WK-DMF0048-0363 | E4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 3: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0364 | E4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 6: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0365 | E4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 8: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0366 | E4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 9: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0048-0367 | E4 | DMF0048_SalesMonitoring.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0048_SalesMonitoring.SetChangeControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0048_SalesMonitoring.SetChangeCon) |
| WK-DMF0048-0368 | E4 | DMF0048_SalesMonitoring.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0048_SalesMonitoring.SetSaveData: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesMonitoring.SetSaveData:) |
| WK-DMF0048-0369 | E4 | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0370 | E4 | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0371 | E4 | DMF0048_SalesMonitoring.setResultPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0048_SalesMonitoring.setResultPeriod: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.setResultPer) |
| WK-DMF0048-0372 | E4 | SEARCH(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SEARCH(F5): 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (SEARCH(F5)) |
| WK-DMF0048-0373 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 11요소: REVIEW:11 |  | 0 () |
| WK-DMF0048-0374 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 11요소: REVIEW:11 |  | 0 () |
| WK-DMF0048-0375 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 11요소: REVIEW:11 |  | 0 () |
| WK-DMF0048-0376 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 11요소: REVIEW:11 |  | 0 () |
| WK-DMF0048-0377 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 11요소: REVIEW:11 |  | 0 () |
| WK-DMF0048-0378 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 11요소: REVIEW:11 |  | 1 (8) |
| WK-DMF0048-0379 | A1 | DMF0002_GET_TITLESET_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0002_GET_TITLESET_POPUP: 골든 비교 케이스 없음(DMF0002_GET_TITLESET_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (1) |
| WK-DMF0048-0380 | A1 | DMF0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0003_GET_BUCKET_TYPE_CODE: 골든 비교 케이스 없음(DMF0003_GET_BUCKET_TYPE_CODE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (`DM.DMF0003_GET_BUCKET_TYPE_CODE`) |
| WK-DMF0048-0381 | A1 | PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING: 골든 비교 케이스 없음(PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING — 팝업 |  | 248 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0382 | A1 | PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 244 (`DM.DMF0048_GET_SPREAD_TITLE` ACT:DMF004) |
| WK-DMF0048-0383 | A1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_BIZ_TYPE_BY_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 1 (`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`) |
| WK-DMF0048-0384 | A1 | SCM0001_GET_CUSTOMER_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_CUSTOMER_BY_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_CUSTOMER_BY_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 1 (`SCM.SCM0001_GET_CUSTOMER_BY_DIVISION`) |
| WK-DMF0048-0385 | A1 | SCM0001_GET_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SCM.SCM0001_GET_DIVISION`) |
| WK-DMF0048-0386 | A1 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 골든 비교 케이스 없음(SCM0001_GET_LOOKUP_VALUES — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (`SCM.SCM0001_GET_LOOKUP_VALUES` (ItemTyp) |
| WK-DMF0048-0387 | A1 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER: 골든 비교 케이스 없음(SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER — 팝업·보조 SP 는 golden_cases. |  | 1 (`SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTO) |
| WK-DMF0048-0388 | A1 | SCM0001_GET_SITE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_SITE_BY_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_SITE_BY_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (`SCM.SCM0001_GET_SITE_BY_DIVISION`) |
| WK-DMF0048-0389 | A1 | SCM0001_GET_TEAM_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_TEAM_BY_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_TEAM_BY_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (`SCM.SCM0001_GET_TEAM_BY_DIVISION`) |
| WK-DMF0048-0390 | A1 | SEARCH(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SEARCH(F5): 행 집계 — A1 11요소: REVIEW:11 |  | 1 (SEARCH(F5)) |
| WK-DMF0048-0391 | A1 | `DM.PR_GET_DAY_RANGE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `DM.PR_GET_DAY_RANGE`: 행 집계 — A1 11요소: REVIEW:11 |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0392 | A6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 4: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0393 | A6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 5: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0394 | A6 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 6: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0395 | A6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 7: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0396 | A6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 8: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0397 | A6 | `DM.PR_GET_DAY_RANGE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `DM.PR_GET_DAY_RANGE`: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0398 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0399 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0048-0400 | G1 | SEARCH(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SEARCH(F5): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SEARCH(F5)) |
| WK-DMF0048-0401 | G1 | `DM.DMF0048_GET_DM_PLN_SALES_MONITORING` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `DM.DMF0048_GET_DM_PLN_SALES_MONITORING`: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (`DM.DMF0048_GET_DM_PLN_SALES_MONITORING`) |
| WK-DMF0048-0402 | G1 | `DM.DMF0048_GET_SPREAD_TITLE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `DM.DMF0048_GET_SPREAD_TITLE`: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (`DM.DMF0048_GET_SPREAD_TITLE`) |
| WK-DMF0048-0403 | G1 | `DM.PR_GET_DAY_RANGE` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `DM.PR_GET_DAY_RANGE`: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (`DM.PR_GET_DAY_RANGE`) |
| WK-DMF0048-0404 | X-LOC | BE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BE) |
| WK-DMF0048-0405 | X-LOC | DB SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DB SP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DB SP) |
| WK-DMF0048-0406 | X-LOC | DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DB 메타: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DB 메타) |
| WK-DMF0048-0407 | X-ROW | (Excel) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — (Excel): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 ((Excel)) |
| WK-DMF0048-0408 | X-ROW | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (12) |
| WK-DMF0048-0409 | X-ROW | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (13) |
| WK-DMF0048-0410 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0048-0411 | X-ROW | BE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BE) |
| WK-DMF0048-0412 | X-ROW | COLUMN_SETUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — COLUMN_SETUP: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (COLUMN_SETUP) |
| WK-DMF0048-0413 | X-ROW | DB SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DB SP: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DB SP) |
| WK-DMF0048-0414 | X-ROW | DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DB 메타: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DB 메타) |
| WK-DMF0048-0415 | X-ROW | DMF0048_SalesMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.CreateSpread: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.CreateSpread) |
| WK-DMF0048-0416 | X-ROW | DMF0048_SalesMonitoring.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.DefineProperty: 진입점 집계 12검사 — NOT_RUN:11 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesMonitoring.DefineProper) |
| WK-DMF0048-0417 | X-ROW | DMF0048_SalesMonitoring.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.Dsdm_Changed: 진입점 집계 6검사 — NOT_RUN:3 · REVIEW:3 |  | 3 (ACT:DMF0048_SalesMonitoring.Dsdm_Changed) |
| WK-DMF0048-0418 | X-ROW | DMF0048_SalesMonitoring.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0048_SalesMonitoring.ExcelButton ) |
| WK-DMF0048-0419 | X-ROW | DMF0048_SalesMonitoring.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0048_SalesMonitoring.FindButton) |
| WK-DMF0048-0420 | X-ROW | DMF0048_SalesMonitoring.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.FindData: 진입점 집계 32검사 — NOT_RUN:28 · REVIEW:2 · PASS:2 |  | 15 (ACT:DMF0048_SalesMonitoring.FindData:618) |
| WK-DMF0048-0421 | X-ROW | DMF0048_SalesMonitoring.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.Form_Load) |
| WK-DMF0048-0422 | X-ROW | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0423 | X-ROW | DMF0048_SalesMonitoring.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetBizTypebyDivisionAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetBizTypeby) |
| WK-DMF0048-0424 | X-ROW | DMF0048_SalesMonitoring.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetBucketTyp) |
| WK-DMF0048-0425 | X-ROW | DMF0048_SalesMonitoring.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetCellColor: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetCellColor) |
| WK-DMF0048-0426 | X-ROW | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0427 | X-ROW | DMF0048_SalesMonitoring.GetCustomerbyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetCustomerbyDivisionAsync: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetCustomerb) |
| WK-DMF0048-0428 | X-ROW | DMF0048_SalesMonitoring.GetDataTableMear | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetDataTableMeargeForDate: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetDataTable) |
| WK-DMF0048-0429 | X-ROW | DMF0048_SalesMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetDayRange) |
| WK-DMF0048-0430 | X-ROW | DMF0048_SalesMonitoring.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetDivision) |
| WK-DMF0048-0431 | X-ROW | DMF0048_SalesMonitoring.GetEndCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetEndCustomerbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetEndCustom) |
| WK-DMF0048-0432 | X-ROW | DMF0048_SalesMonitoring.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetItemType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetItemType) |
| WK-DMF0048-0433 | X-ROW | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomer: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0434 | X-ROW | DMF0048_SalesMonitoring.GetPlantSitebyEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetPlantSitebyEndCustomerA: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetPlantSite) |
| WK-DMF0048-0435 | X-ROW | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0436 | X-ROW | DMF0048_SalesMonitoring.GetScmSitebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetScmSitebyDivisionAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetScmSiteby) |
| WK-DMF0048-0437 | X-ROW | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0438 | X-ROW | DMF0048_SalesMonitoring.GetTeambyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetTeambyDivisionAsync: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetTeambyDiv) |
| WK-DMF0048-0439 | X-ROW | DMF0048_SalesMonitoring.GetThisWeekMonda | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.GetThisWeekMonday: 진입점 집계 4검사 — NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.GetThisWeekM) |
| WK-DMF0048-0440 | X-ROW | DMF0048_SalesMonitoring.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.InitControls: 진입점 집계 33검사 — NOT_RUN:33 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0048_SalesMonitoring.InitControls) |
| WK-DMF0048-0441 | X-ROW | DMF0048_SalesMonitoring.InitSaveDataTabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.InitSaveData) |
| WK-DMF0048-0442 | X-ROW | DMF0048_SalesMonitoring.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.InitSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.InitSpread A) |
| WK-DMF0048-0443 | X-ROW | DMF0048_SalesMonitoring.InitSpreadFooter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.InitSpreadFo) |
| WK-DMF0048-0444 | X-ROW | DMF0048_SalesMonitoring.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.SetChangeControl: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 7 (ACT:DMF0048_SalesMonitoring.SetChangeCon) |
| WK-DMF0048-0445 | X-ROW | DMF0048_SalesMonitoring.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadColumn: 진입점 집계 18검사 — NOT_RUN:12 · REVIEW:6 |  | 21 (ACT:DMF0048_SalesMonitoring.SetSpreadCol) |
| WK-DMF0048-0446 | X-ROW | DMF0048_SalesMonitoring.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.SetSpreadHeaderSpan: 진입점 집계 12검사 — REVIEW:6 · NOT_RUN:6 |  | 1 (ACT:DMF0048_SalesMonitoring.SetSpreadHea) |
| WK-DMF0048-0447 | X-ROW | DMF0048_SalesMonitoring.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.btnColumn_Cl) |
| WK-DMF0048-0448 | X-ROW | DMF0048_SalesMonitoring.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.btnItemId_Cl) |
| WK-DMF0048-0449 | X-ROW | DMF0048_SalesMonitoring.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.btnMeasure_C) |
| WK-DMF0048-0450 | X-ROW | DMF0048_SalesMonitoring.btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.btnOwner_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesMonitoring.btnOwner_Cli) |
| WK-DMF0048-0451 | X-ROW | DMF0048_SalesMonitoring.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.btnProject_Click: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.btnProject_C) |
| WK-DMF0048-0452 | X-ROW | DMF0048_SalesMonitoring.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.cboBucketType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesMonitoring.cboBucketTyp) |
| WK-DMF0048-0453 | X-ROW | DMF0048_SalesMonitoring.cboKRW_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.cboKRW_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.cboKRW_Selec) |
| WK-DMF0048-0454 | X-ROW | DMF0048_SalesMonitoring.cboLOC_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.cboLOC_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.cboLOC_Selec) |
| WK-DMF0048-0455 | X-ROW | DMF0048_SalesMonitoring.cboUSD_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.cboUSD_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.cboUSD_Selec) |
| WK-DMF0048-0456 | X-ROW | DMF0048_SalesMonitoring.chkColor_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.chkColor_CheckedChanged: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.chkColor_Che) |
| WK-DMF0048-0457 | X-ROW | DMF0048_SalesMonitoring.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.chkSum_Check) |
| WK-DMF0048-0458 | X-ROW | DMF0048_SalesMonitoring.clbDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.clbDivision_SelectedIndexC: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.clbDivision_) |
| WK-DMF0048-0459 | X-ROW | DMF0048_SalesMonitoring.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.clbTeam_SelectedIndexChang: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0048_SalesMonitoring.clbTeam_Sele) |
| WK-DMF0048-0460 | X-ROW | DMF0048_SalesMonitoring.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 52 (ACT:DMF0048_SalesMonitoring.fnValidation) |
| WK-DMF0048-0461 | X-ROW | DMF0048_SalesMonitoring.setResultPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.setResultPeriod: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0048_SalesMonitoring.setResultPer) |
| WK-DMF0048-0462 | X-ROW | DMF0048_SalesMonitoring.spdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesMonitoring.spdMain_TopC) |
| WK-DMF0048-0463 | X-ROW | DMF0048_SalesMonitoring.txtItemId_KeyDow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.txtItemId_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0048_SalesMonitoring.txtItemId_Ke) |
| WK-DMF0048-0464 | X-ROW | DMF0048_SalesMonitoring.txtProject_KeyDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesMonitoring.txtProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0048_SalesMonitoring.txtProject_K) |
| WK-DMF0048-0465 | X-ROW | DMF0048_SalesPlanMonitoring..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0048_SalesPlanMonitoring..ctor:19) |
| WK-DMF0048-0466 | X-ROW | DMF0048_SalesPlanMonitoring.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.CreateSpread: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0048_SalesPlanMonitoring.CreateSp) |
| WK-DMF0048-0467 | X-ROW | DMF0048_SalesPlanMonitoring.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.DefineProperty: 진입점 집계 13검사 — NOT_RUN:12 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0048_SalesPlanMonitoring.DefinePr) |
| WK-DMF0048-0468 | X-ROW | DMF0048_SalesPlanMonitoring.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesPlanMonitoring.Dispose:) |
| WK-DMF0048-0469 | X-ROW | DMF0048_SalesPlanMonitoring.Dsdm_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.Dsdm_Changed: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 45 (ACT:DMF0048_SalesPlanMonitoring.Dsdm_Cha) |
| WK-DMF0048-0470 | X-ROW | DMF0048_SalesPlanMonitoring.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0048_SalesPlanMonitoring.FindButt) |
| WK-DMF0048-0471 | X-ROW | DMF0048_SalesPlanMonitoring.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.FindData: 진입점 집계 34검사 — NOT_RUN:30 · REVIEW:2 · PASS:2 |  | 124 (ACT:DMF0048_SalesPlanMonitoring.FindData) |
| WK-DMF0048-0472 | X-ROW | DMF0048_SalesPlanMonitoring.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesPlanMonitoring.Form_Loa) |
| WK-DMF0048-0473 | X-ROW | DMF0048_SalesPlanMonitoring.GetBizTypeby | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetBizTypebyDivision: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0048_SalesPlanMonitoring.GetBizTy) |
| WK-DMF0048-0474 | X-ROW | DMF0048_SalesPlanMonitoring.GetBucketTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetBucketType: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesPlanMonitoring.GetBucke) |
| WK-DMF0048-0475 | X-ROW | DMF0048_SalesPlanMonitoring.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetDayRange: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0048_SalesPlanMonitoring.GetDayRa) |
| WK-DMF0048-0476 | X-ROW | DMF0048_SalesPlanMonitoring.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetItemType: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0048_SalesPlanMonitoring.GetItemT) |
| WK-DMF0048-0477 | X-ROW | DMF0048_SalesPlanMonitoring.GetSALESPLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetSALESPLAN_MEASUREIn: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesPlanMonitoring.GetSALES) |
| WK-DMF0048-0478 | X-ROW | DMF0048_SalesPlanMonitoring.GetSALESPLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetSALESPLAN_MEASUREIn: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesPlanMonitoring.GetSALES) |
| WK-DMF0048-0479 | X-ROW | DMF0048_SalesPlanMonitoring.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.GetSpdTitle: 진입점 집계 8검사 — NOT_RUN:3 · NOPATH:2 · TODO:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0048_SalesPlanMonitoring.GetSpdTi) |
| WK-DMF0048-0480 | X-ROW | DMF0048_SalesPlanMonitoring.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.InitControls: 진입점 집계 34검사 — NOT_RUN:32 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 41 (ACT:DMF0048_SalesPlanMonitoring.InitCont) |
| WK-DMF0048-0481 | X-ROW | DMF0048_SalesPlanMonitoring.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesPlanMonitoring.InitSpre) |
| WK-DMF0048-0482 | X-ROW | DMF0048_SalesPlanMonitoring.InitSpreadFo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.InitSpreadFooterSum: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesPlanMonitoring.InitSpre) |
| WK-DMF0048-0483 | X-ROW | DMF0048_SalesPlanMonitoring.SetSpreadCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.SetSpreadColumn: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 19 (ACT:DMF0048_SalesPlanMonitoring.SetSprea) |
| WK-DMF0048-0484 | X-ROW | DMF0048_SalesPlanMonitoring.SetSpreadHea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.SetSpreadHeaderSpan: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 55 (ACT:DMF0048_SalesPlanMonitoring.SetSprea) |
| WK-DMF0048-0485 | X-ROW | DMF0048_SalesPlanMonitoring.btnColumn_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.btnColumn_Click: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesPlanMonitoring.btnColum) |
| WK-DMF0048-0486 | X-ROW | DMF0048_SalesPlanMonitoring.btnItemId_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.btnItemId_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesPlanMonitoring.btnItemI) |
| WK-DMF0048-0487 | X-ROW | DMF0048_SalesPlanMonitoring.btnMeasure_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.btnMeasure_Click: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0048_SalesPlanMonitoring.btnMeasu) |
| WK-DMF0048-0488 | X-ROW | DMF0048_SalesPlanMonitoring.btnOwner_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.btnOwner_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0048_SalesPlanMonitoring.btnOwner) |
| WK-DMF0048-0489 | X-ROW | DMF0048_SalesPlanMonitoring.btnProject_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.btnProject_Click: 진입점 집계 7검사 — NOT_RUN:6 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0048_SalesPlanMonitoring.btnProje) |
| WK-DMF0048-0490 | X-ROW | DMF0048_SalesPlanMonitoring.cboBucketTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.cboBucketType_Click: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesPlanMonitoring.cboBucke) |
| WK-DMF0048-0491 | X-ROW | DMF0048_SalesPlanMonitoring.cboBucketTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.cboBucketType_Selected: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0048_SalesPlanMonitoring.cboBucke) |
| WK-DMF0048-0492 | X-ROW | DMF0048_SalesPlanMonitoring.chkSum_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.chkSum_CheckedChanged: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesPlanMonitoring.chkSum_C) |
| WK-DMF0048-0493 | X-ROW | DMF0048_SalesPlanMonitoring.clbCustomer_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.clbCustomer_SelectedIn: 진입점 집계 6검사 — NOPATH:2 · TODO:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesPlanMonitoring.clbCusto) |
| WK-DMF0048-0494 | X-ROW | DMF0048_SalesPlanMonitoring.clbDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.clbDivision_SelectedIn: 진입점 집계 11검사 — NOT_RUN:9 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 38 (ACT:DMF0048_SalesPlanMonitoring.clbDivis) |
| WK-DMF0048-0495 | X-ROW | DMF0048_SalesPlanMonitoring.clbTeam_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.clbTeam_SelectedIndexC: 진입점 집계 10검사 — NOT_RUN:4 · NOPATH:3 · TODO:3 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0048_SalesPlanMonitoring.clbTeam_) |
| WK-DMF0048-0496 | X-ROW | DMF0048_SalesPlanMonitoring.spdMain_TopC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0048_SalesPlanMonitoring.spdMain_) |
| WK-DMF0048-0497 | X-ROW | DMF0048_SalesPlanMonitoring.txtItemId_Ke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.txtItemId_KeyDown: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesPlanMonitoring.txtItemI) |
| WK-DMF0048-0498 | X-ROW | DMF0048_SalesPlanMonitoring.txtProject_K | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0048_SalesPlanMonitoring.txtProject_KeyDown: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0048_SalesPlanMonitoring.txtProje) |
| WK-DMF0048-0499 | X-ROW | EXCEL(F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EXCEL(F12): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EXCEL(F12)) |
| WK-DMF0048-0500 | X-ROW | FE 수정 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FE 수정: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FE 수정) |
| WK-DMF0048-0501 | X-ROW | MEASURE_SELECT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MEASURE_SELECT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MEASURE_SELECT) |
| WK-DMF0048-0502 | X-ROW | SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET( | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET(F10): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET() |
| WK-DMF0048-0503 | G5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 8: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0504 | H6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 8: 행 집계 — H6 6요소: NOPATH:5 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0048-0505 | M4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 8: 행 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
