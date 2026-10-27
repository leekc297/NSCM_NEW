# 작업 원장 — DMF0068 · 2026-10-26 12:51

> 검사 인스턴스 383건 중 PASS·NA 37건 외 **346건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 46 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 21 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 104 | 실행 → PASS |
| W7 | 기대값 확정 | 173 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 173 · E2E 104 · 대조표 46 · 하네스 22 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 9건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 46 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 42 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 30 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G5 | POPUP |  |  |  |  | 4 |  | 15 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 | 1 | 15 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 4 | 15 |  |  | 팝업 선택값 반영 |
| E3 | EDIT |  |  |  |  |  | 1 | 14 |  |  | 필수 입력 검증 |
| G1 | GEN |  |  |  |  |  | 6 | 9 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 15 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H2 | DESIGN |  |  |  |  |  | 1 | 13 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 10 | 4 |  |  | 라벨 명칭 |
| A5 | DESIGN |  |  |  |  |  | 9 | 4 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| F4 | DB |  |  |  |  |  | 10 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 6 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  | 1 | 6 | 1 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 6 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 1 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 3 | 3 |  |  | 연쇄 자동 채움 |
| A6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  | 1 | 3 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| E2 | EDIT |  |  |  |  | 1 |  |  |  |  | 날짜 형식·유효성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (46)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-DMF0068-0002 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-DMF0068-0003 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-DMF0068-0004 | X-LOC | 3단 헤더 동적 구성(미호출) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3단 헤더 동적 구성(미호출)) |
| WK-DMF0068-0005 | X-LOC | MSG00002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00002) |
| WK-DMF0068-0006 | X-LOC | MSG00004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00004) |
| WK-DMF0068-0007 | X-LOC | MSG00049 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00049) |
| WK-DMF0068-0008 | X-LOC | MSG00084 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00084) |
| WK-DMF0068-0009 | X-LOC | MSG00096 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00096) |
| WK-DMF0068-0010 | X-LOC | MSG00105 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00105) |
| WK-DMF0068-0011 | X-LOC | MSG00108 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00108) |
| WK-DMF0068-0012 | X-LOC | MSG00113 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00113) |
| WK-DMF0068-0013 | X-LOC | MSG00260 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00260) |
| WK-DMF0068-0014 | X-LOC | MSG00279 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00279) |
| WK-DMF0068-0015 | X-LOC | MSG00283 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00283) |
| WK-DMF0068-0016 | X-LOC | MSG00284 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00284) |
| WK-DMF0068-0017 | X-LOC | MSG00307 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00307) |
| WK-DMF0068-0018 | X-LOC | MSG00415 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00415) |
| WK-DMF0068-0019 | X-LOC | Measure 셀 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Measure 셀 잠금) |
| WK-DMF0068-0020 | X-LOC | `DMF0068_DEL_ORDERLIST` (FoxQuery 경유) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DMF0068_DEL_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0021 | X-LOC | `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP`) |
| WK-DMF0068-0022 | X-LOC | `DMF0068_GET_LOOKUPPROJECT` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DMF0068_GET_LOOKUPPROJECT`) |
| WK-DMF0068-0023 | X-LOC | `DMF0068_GET_ORDERLIST` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DMF0068_GET_ORDERLIST`) |
| WK-DMF0068-0024 | X-LOC | `DMF0068_SAVE_ORDERLIST` (FoxQuery 경유) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DMF0068_SAVE_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0025 | X-LOC | `DeleteButton` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DeleteButton`) |
| WK-DMF0068-0026 | X-LOC | `EditButton` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`EditButton`) |
| WK-DMF0068-0027 | X-LOC | `ExcelButton` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ExcelButton`) |
| WK-DMF0068-0028 | X-LOC | `FindButton` → `FindData` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0029 | X-LOC | `Form_Load` → InitControls / CreateSprea | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Form_Load` → InitControls / CreateSprea) |
| WK-DMF0068-0030 | X-LOC | `InsertButton` → `InsertRow` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`InsertButton` → `InsertRow`) |
| WK-DMF0068-0031 | X-LOC | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0032 | X-LOC | `SaveButton` → `SaveData` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SaveButton` → `SaveData`) |
| WK-DMF0068-0033 | X-LOC | `btnSPVer.Click` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnSPVer.Click`) |
| WK-DMF0068-0034 | X-LOC | `btnSPVer_Click` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnSPVer_Click`) |
| WK-DMF0068-0035 | X-LOC | 버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일) |
| WK-DMF0068-0036 | X-LOC | 범위 밖 월 0 처리 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (범위 밖 월 0 처리) |
| WK-DMF0068-0037 | X-LOC | 범위 밖 월 0 처리가 두 번째 월부터 시작 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (범위 밖 월 0 처리가 두 번째 월부터 시작) |
| WK-DMF0068-0038 | X-LOC | 사업부 미보유 시 화면이 빈 그리드로 열림 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (사업부 미보유 시 화면이 빈 그리드로 열림) |
| WK-DMF0068-0039 | X-LOC | 사업부 판정이 '포함' 비교라 140·401 도 통과 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (사업부 판정이 '포함' 비교라 140·401 도 통과) |
| WK-DMF0068-0040 | X-LOC | 월 컬럼 11~154 하드코딩 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (월 컬럼 11~154 하드코딩) |
| WK-DMF0068-0041 | X-LOC | 조회 직후 전 컬럼 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (조회 직후 전 컬럼 잠금) |
| WK-DMF0068-0042 | X-LOC | 조회에도 편집 권한을 요구 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (조회에도 편집 권한을 요구) |
| WK-DMF0068-0043 | X-LOC | 짝수 행 기간 잠금 + 윗행 Formula 복사 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (짝수 행 기간 잠금 + 윗행 Formula 복사) |
| WK-DMF0068-0044 | X-LOC | 편집 진입 시 컬럼 2·5·8 이후 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (편집 진입 시 컬럼 2·5·8 이후 잠금) |
| WK-DMF0068-0045 | X-LOC | 행 추가 시 둘째 행 3셀 잠금·백색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (행 추가 시 둘째 행 3셀 잠금·백색) |
| WK-DMF0068-0046 | X-LOC | 화면단 실적/계획/잔고 재계산(주석) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (화면단 실적/계획/잔고 재계산(주석)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0047 | H10 | DMF0068 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — DMF0068 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: DemandManager.tsx |  | 14 (MSG00415 MSG00096 MSG00283 MSG00002 MSG0) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0048 | B3 | txtVersion / Version | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtVersion / Version | 있음(FE 소스) | 3 (ACT:DMF0068_DemandManager40.GetLookupPro) |

## W5 검사기 연결 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0049 | B1 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 0 () |
| WK-DMF0068-0050 | B2 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 0 () |
| WK-DMF0068-0051 | B4 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 3 (ACT:DMF0068_DemandManager40.GetLookupPro) |
| WK-DMF0068-0052 | F2 | DMF0068 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0068 화면 | 판단불가(대상 단위 SCREEN) | 129 (`SaveButton` → `SaveData` MSG00002 MSG00) |
| WK-DMF0068-0053 | F6 | DMF0068 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0068 화면 | 판단불가(대상 단위 SCREEN) | 127 (`SaveButton` → `SaveData` `DMF0068_SAVE_) |
| WK-DMF0068-0054 | DB-SYN | DM0000_GET_COMMON_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0000_GET_COMMON_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0068_VersionPopup.GetSpdTitle:319) |
| WK-DMF0068-0055 | DB-SYN | DMF0068_SAVE_ORDERLIST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0068_SAVE_ORDERLIST | 없음(PROC_M 대응 없음) | 1 (`DMF0068_SAVE_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0056 | DB-SYN | P_DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DIVISION_ID | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0068_DemandManager40.SaveData:105) |
| WK-DMF0068-0057 | DB-SYN | P_USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_USER_ID | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0068_DemandManager40.SaveData:105) |
| WK-DMF0068-0058 | DB-SYN | P_VERSION_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_VERSION_NO | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0068_DemandManager40.SaveData:105) |
| WK-DMF0068-0059 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 3 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type) AC) |
| WK-DMF0068-0060 | G4 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSPVer | 없음 | 1 (2) |
| WK-DMF0068-0061 | E2 | YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 PCOL YYYYMMDD | 판단불가(대상 단위 PCOL) | 1 (MSG00049) |
| WK-DMF0068-0062 | G03-WIRE | DMF0068 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0068 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:DMF0068_DemandManager40..ctor ACT:DM) |
| WK-DMF0068-0063 | G5 | DMF0068_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0068_VersionPopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0068_DemandManager40.btnSPVer_Cli) |
| WK-DMF0068-0064 | G5 | YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 PCOL YYYYMMDD | 판단불가(대상 단위 PCOL) | 1 (MSG00049) |
| WK-DMF0068-0065 | G5 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnSPVer | 없음 | 2 (2 `btnSPVer_Click`) |
| WK-DMF0068-0066 | G5 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 1 (1) |
| WK-DMF0068-0067 | H6 | DMF0068_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0068_VersionPopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0068_DemandManager40.btnSPVer_Cli) |
| WK-DMF0068-0068 | H6 | YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 PCOL YYYYMMDD | 판단불가(대상 단위 PCOL) | 1 (MSG00049) |
| WK-DMF0068-0069 | H6 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnSPVer | 없음 | 2 (2 `btnSPVer_Click`) |

## W6 검증 실행 (104)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0070 | J2 | DMF0068 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0068 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 40 (1 2 3 `FindButton` → `FindData` `InsertB) |
| WK-DMF0068-0071 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitControls:11) |
| WK-DMF0068-0072 | C1 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitControls:12) |
| WK-DMF0068-0073 | C3 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.SetItem:346:8) |
| WK-DMF0068-0074 | C3 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0075 | C3 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0068_VersionPopup.SetItem ACT:DMF) |
| WK-DMF0068-0076 | K4 | DMF0068 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0068 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 20 (ACT:DMF0068_DemandManager40.btnSPVer_Cli) |
| WK-DMF0068-0077 | F1 | DMF0068 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0068 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 138 (`DeleteButton` `SaveButton` → `SaveData`) |
| WK-DMF0068-0078 | F5 | DMF0068 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0068 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 10 (`DeleteButton` `SaveButton` → `SaveData`) |
| WK-DMF0068-0079 | F4 | DM0000_GET_COMMON_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 2 (ACT:DMF0068_VersionPopup.GetSpdTitle:319) |
| WK-DMF0068-0080 | F4 | DMF0068_SAVE_ORDERLIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0068_SAVE_ORDERLIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`DMF0068_SAVE_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0081 | F4 | PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 24 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP` ACT) |
| WK-DMF0068-0082 | F4 | PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 3 (`DMF0068_GET_LOOKUPPROJECT` ACT:DMF0068_) |
| WK-DMF0068-0083 | F4 | PKG_DMF0068.P_DMF0068_GET_ORDERLIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 208 (`DMF0068_GET_ORDERLIST` ACT:DMF0068_Dema) |
| WK-DMF0068-0084 | F4 | PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSON · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 1 (`DMF0068_SAVE_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0085 | F4 | P_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DIVISION_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 123 (ACT:DMF0068_DemandManager40.SaveButton A) |
| WK-DMF0068-0086 | F4 | P_USER_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_USER_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 123 (ACT:DMF0068_DemandManager40.SaveButton A) |
| WK-DMF0068-0087 | F4 | P_VERSION_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_VERSION_NO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 123 (ACT:DMF0068_DemandManager40.SaveButton A) |
| WK-DMF0068-0088 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type) AC) |
| WK-DMF0068-0089 | A5 | CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0090 | A5 | CREATION_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0091 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0092 | A5 | EDIT_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0093 | A5 | VERSION_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0094 | A5 | VERSION_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0095 | A5 | VERSION_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0096 | A5 | VER_CRE_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VER_CRE_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0097 | A5 | YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0098 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0068_VersionPopup.InitControls AC) |
| WK-DMF0068-0099 | G4 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbType / Report Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0068_VersionPopup.InitControls AC) |
| WK-DMF0068-0100 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0068_VersionPopup.Form_Load ACT:D) |
| WK-DMF0068-0101 | G4 | drpPeriodMonth / Period / Period Month | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriodMonth / Period / Period Month · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (3 ACT:DMF0068_DemandManager40.InitContro) |
| WK-DMF0068-0102 | G4 | txtDes / Des | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtDes / Des · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0068_VersionPopup.InitSpread_X AC) |
| WK-DMF0068-0103 | G4 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtVersion / Version · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (1) |
| WK-DMF0068-0104 | H2 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0105 | H5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0106 | H5 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATION_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0107 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0108 | H5 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0109 | H5 | VERSION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0110 | H5 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0111 | H5 | VERSION_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0112 | H5 | VER_CRE_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VER_CRE_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0113 | H5 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.InitSpread_X:16) |
| WK-DMF0068-0114 | H5 | drpPeriodMonth / Period / Period Month | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — drpPeriodMonth / Period / Period Month · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective))  |  | 3 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0115 | I1 | DMF0068 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0068 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 41 (MSG00415 MSG00096 MSG00283 MSG00002 MSG0) |
| WK-DMF0068-0116 | SC1 | DMF0068 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0068 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 4 (1 2 3 `EditButton`) |
| WK-DMF0068-0117 | D5 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0118 | D6 | DMF0068 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0068 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (`InsertButton` → `InsertRow` 행 추가 시 둘째 행) |
| WK-DMF0068-0119 | E3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 1 (MSG00049) |
| WK-DMF0068-0120 | E4 | CREATION_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CREATION_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0068_VersionPopup.SetItem:346:8) |
| WK-DMF0068-0121 | E4 | EDIT_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — EDIT_FLAG · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0122 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (MSG00002 ACT:DMF0068_DemandManager40.Fin) |
| WK-DMF0068-0123 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00004 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0124 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00049 ACT:DMF0068_DemandManager40.Fin) |
| WK-DMF0068-0125 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00084 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0126 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00096 ACT:DMF0068_DemandManager40.Edi) |
| WK-DMF0068-0127 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00105 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0128 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00108 ACT:DMF0068_DemandManager40.Fin) |
| WK-DMF0068-0129 | E4 | MSG00113 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00113 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00113 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0130 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00260 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0131 | E4 | MSG00279 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00279 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (MSG00279 ACT:DMF0068_VersionPopup.SetIte) |
| WK-DMF0068-0132 | E4 | MSG00283 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00283 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00283 ACT:DMF0068_DemandManager40.Fin) |
| WK-DMF0068-0133 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00284 ACT:DMF0068_DemandManager40.Sav) |
| WK-DMF0068-0134 | E4 | MSG00307 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00307 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00307 ACT:DMF0068_DemandManager40.Fin) |
| WK-DMF0068-0135 | E4 | MSG00415 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00415 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00415 ACT:DMF0068_DemandManager40.Edi) |
| WK-DMF0068-0136 | E4 | MSG00611 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00611 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00049) |
| WK-DMF0068-0137 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00002) |
| WK-DMF0068-0138 | E4 | MSG00618 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00618 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00284) |
| WK-DMF0068-0139 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00004) |
| WK-DMF0068-0140 | E4 | MSG00699 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00699 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00084) |
| WK-DMF0068-0141 | E4 | MSG00700 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00700 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00105) |
| WK-DMF0068-0142 | E4 | MSG00701 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00701 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00279) |
| WK-DMF0068-0143 | E4 | MSG00702 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00702 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00415) |
| WK-DMF0068-0144 | E4 | MSG01081 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01081 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00049) |
| WK-DMF0068-0145 | E4 | MSG01135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00108) |
| WK-DMF0068-0146 | E4 | VERSION_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VERSION_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0068_VersionPopup.SetItem ACT:DMF) |
| WK-DMF0068-0147 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00049) |
| WK-DMF0068-0148 | E4 | drpPeriodMonth / Period / Period Month | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriodMonth / Period / Period Month · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 5 (ACT:DMF0068_DemandManager40.FindData:592) |
| WK-DMF0068-0149 | E4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (ACT:DMF0068_DemandManager40.FindData:587) |
| WK-DMF0068-0150 | A10 | DMF0068 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0068 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 61 (ACT:DMF0068_DemandManager40.DefineProper) |
| WK-DMF0068-0151 | A6 | PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 24 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP` ACT) |
| WK-DMF0068-0152 | A6 | PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 1 (`DMF0068_GET_LOOKUPPROJECT`) |
| WK-DMF0068-0153 | A6 | PKG_DMF0068.P_DMF0068_GET_ORDERLIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 86 (`DMF0068_GET_ORDERLIST` ACT:DMF0068_Dema) |
| WK-DMF0068-0154 | A6 | SCM0001_GET_LOOKUP_VALUES | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0155 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0068_VersionPopup.FindData ACT:DM) |
| WK-DMF0068-0156 | G1 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbType / Report Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0068_VersionPopup.FindData ACT:DM) |
| WK-DMF0068-0157 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0068_VersionPopup.FindData ACT:DM) |
| WK-DMF0068-0158 | G1 | drpPeriodMonth / Period / Period Month | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriodMonth / Period / Period Month · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 14 (3 ACT:DMF0068_DemandManager40.FindData A) |
| WK-DMF0068-0159 | G1 | txtDes / Des | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDes / Des · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0068_VersionPopup.FindData ACT:DM) |
| WK-DMF0068-0160 | G1 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (1 ACT:DMF0068_DemandManager40.FindData A) |
| WK-DMF0068-0161 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0068_VersionPopup.InitControls AC) |
| WK-DMF0068-0162 | G6 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0068_VersionPopup.InitControls AC) |
| WK-DMF0068-0163 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0068_VersionPopup.Form_Load ACT:D) |
| WK-DMF0068-0164 | G6 | drpPeriodMonth / Period / Period Month | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriodMonth / Period / Period Month · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (3 ACT:DMF0068_DemandManager40.InitContro) |
| WK-DMF0068-0165 | G6 | txtDes / Des | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtDes / Des · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0068_VersionPopup.InitSpread_X AC) |
| WK-DMF0068-0166 | G6 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (1) |
| WK-DMF0068-0167 | X-REOPEN | DMF0068 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0068 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 15 (ACT:DMF0068_DemandManager40.Dispose ACT:) |
| WK-DMF0068-0168 | H6 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtVersion / Version · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (1) |
| WK-DMF0068-0169 | M3 | DMF0068_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0068_VersionPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 16 (ACT:DMF0068_VersionPopup..ctor ACT:DMF00) |
| WK-DMF0068-0170 | M4 | DMF0068_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0068_VersionPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0068_VersionPopup.spdMain_CellDou) |
| WK-DMF0068-0171 | M4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MSG00049) |
| WK-DMF0068-0172 | M4 | btnSPVer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnSPVer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (2 `btnSPVer_Click`) |
| WK-DMF0068-0173 | M4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (1) |

## W7 기대값 확정 (173)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0068-0174 | C3 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0175 | C3 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0176 | C3 | 짝수 행 기간 잠금 + 윗행 Formula 복사 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 짝수 행 기간 잠금 + 윗행 Formula 복사: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (짝수 행 기간 잠금 + 윗행 Formula 복사) |
| WK-DMF0068-0177 | B3 | DMF0068_DemandManager40.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0068_DemandManager40.GetCellIndexBySpanRowCells: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0068_DemandManager40.GetCellIndex) |
| WK-DMF0068-0178 | B3 | DMF0068_DemandManager40.GetCellNumbersBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0068_DemandManager40.GetCellNumbersByRow: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0068_DemandManager40.GetCellNumbe) |
| WK-DMF0068-0179 | B3 | DMF0068_DemandManager40.GetLookupProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0068_DemandManager40.GetLookupProject: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0068_DemandManager40.GetLookupPro) |
| WK-DMF0068-0180 | B3 | `DMF0068_GET_LOOKUPPROJECT` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `DMF0068_GET_LOOKUPPROJECT`: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (`DMF0068_GET_LOOKUPPROJECT`) |
| WK-DMF0068-0181 | B3 | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM0001_GET_LOOKUP_VALUES` (팝업 Type): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0182 | B4 | DMF0068_DemandManager40.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0068_DemandManager40.GetCellIndexBySpanRowCells: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0068_DemandManager40.GetCellIndex) |
| WK-DMF0068-0183 | B4 | DMF0068_DemandManager40.GetCellNumbersBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0068_DemandManager40.GetCellNumbersByRow: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0068_DemandManager40.GetCellNumbe) |
| WK-DMF0068-0184 | B4 | DMF0068_DemandManager40.GetLookupProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0068_DemandManager40.GetLookupProject: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0068_DemandManager40.GetLookupPro) |
| WK-DMF0068-0185 | B4 | `DMF0068_GET_LOOKUPPROJECT` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `DMF0068_GET_LOOKUPPROJECT`: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (`DMF0068_GET_LOOKUPPROJECT`) |
| WK-DMF0068-0186 | B4 | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM0001_GET_LOOKUP_VALUES` (팝업 Type): 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0187 | DB-SYN | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `FindButton` → `FindData`: 행 집계 — DB-SYN 10요소: NOPATH:6 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0188 | DB-SYN | `SaveButton` → `SaveData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `SaveButton` → `SaveData`: 행 집계 — DB-SYN 10요소: NOPATH:6 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (`SaveButton` → `SaveData`) |
| WK-DMF0068-0189 | F4 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `FindButton` → `FindData`: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0190 | F4 | `SaveButton` → `SaveData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `SaveButton` → `SaveData`: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`SaveButton` → `SaveData`) |
| WK-DMF0068-0191 | A5 | DMF0068_DemandManager40.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0068_DemandManager40.CreateSpread: 진입점 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.CreateSpread) |
| WK-DMF0068-0192 | A5 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0193 | A5 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0194 | A5 | 사업부 미보유 시 화면이 빈 그리드로 열림 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 사업부 미보유 시 화면이 빈 그리드로 열림: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (사업부 미보유 시 화면이 빈 그리드로 열림) |
| WK-DMF0068-0195 | G4 | `EditButton` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `EditButton`: 행 집계 — G4 7요소: NOT_RUN:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton`) |
| WK-DMF0068-0196 | H2 | 3단 헤더 동적 구성(미호출) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3단 헤더 동적 구성(미호출): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3단 헤더 동적 구성(미호출)) |
| WK-DMF0068-0197 | H2 | DMF0068_DemandManager40.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0068_DemandManager40.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.CreateSpread) |
| WK-DMF0068-0198 | H2 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0199 | H2 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0200 | H2 | Measure 셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Measure 셀 잠금: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Measure 셀 잠금) |
| WK-DMF0068-0201 | H2 | 범위 밖 월 0 처리 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 범위 밖 월 0 처리: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (범위 밖 월 0 처리) |
| WK-DMF0068-0202 | H2 | 사업부 미보유 시 화면이 빈 그리드로 열림 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 사업부 미보유 시 화면이 빈 그리드로 열림: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (사업부 미보유 시 화면이 빈 그리드로 열림) |
| WK-DMF0068-0203 | H2 | 월 컬럼 11~154 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 월 컬럼 11~154 하드코딩: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (월 컬럼 11~154 하드코딩) |
| WK-DMF0068-0204 | H2 | 조회 직후 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 조회 직후 전 컬럼 잠금: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회 직후 전 컬럼 잠금) |
| WK-DMF0068-0205 | H2 | 짝수 행 기간 잠금 + 윗행 Formula 복사 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 짝수 행 기간 잠금 + 윗행 Formula 복사: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (짝수 행 기간 잠금 + 윗행 Formula 복사) |
| WK-DMF0068-0206 | H2 | 편집 진입 시 컬럼 2·5·8 이후 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 편집 진입 시 컬럼 2·5·8 이후 잠금: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (편집 진입 시 컬럼 2·5·8 이후 잠금) |
| WK-DMF0068-0207 | H2 | 행 추가 시 둘째 행 3셀 잠금·백색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 행 추가 시 둘째 행 3셀 잠금·백색: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (행 추가 시 둘째 행 3셀 잠금·백색) |
| WK-DMF0068-0208 | H2 | 화면단 실적/계획/잔고 재계산(주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 화면단 실적/계획/잔고 재계산(주석): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (화면단 실적/계획/잔고 재계산(주석)) |
| WK-DMF0068-0209 | H5 | DMF0068_DemandManager40.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0068_DemandManager40.CreateSpread: 진입점 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.CreateSpread) |
| WK-DMF0068-0210 | H5 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0211 | H5 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0212 | H5 | 사업부 미보유 시 화면이 빈 그리드로 열림 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 사업부 미보유 시 화면이 빈 그리드로 열림: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (사업부 미보유 시 화면이 빈 그리드로 열림) |
| WK-DMF0068-0213 | D5 | DMF0068_DemandManager40.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0068_DemandManager40.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.CreateSpread) |
| WK-DMF0068-0214 | D5 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0215 | D5 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0216 | E3 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00002: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00002) |
| WK-DMF0068-0217 | E3 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00004: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004) |
| WK-DMF0068-0218 | E3 | MSG00084 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00084: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00084) |
| WK-DMF0068-0219 | E3 | MSG00096 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00096: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00096) |
| WK-DMF0068-0220 | E3 | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00105: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00105) |
| WK-DMF0068-0221 | E3 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00108: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00108) |
| WK-DMF0068-0222 | E3 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00113: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00113) |
| WK-DMF0068-0223 | E3 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00260: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00260) |
| WK-DMF0068-0224 | E3 | MSG00279 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00279: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279) |
| WK-DMF0068-0225 | E3 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00283: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00283) |
| WK-DMF0068-0226 | E3 | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00284: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00284) |
| WK-DMF0068-0227 | E3 | MSG00307 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00307: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00307) |
| WK-DMF0068-0228 | E3 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00415: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00415) |
| WK-DMF0068-0229 | E3 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — `FindButton` → `FindData`: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0230 | E4 | DMF0068_DemandManager40.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0068_DemandManager40.SetSpreadHeaderSpan: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0068_DemandManager40.SetSpreadHea) |
| WK-DMF0068-0231 | E4 | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0232 | E4 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `FindButton` → `FindData`: 행 집계 — E4 30요소: NOT_RUN:30 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0233 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (1) |
| WK-DMF0068-0234 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (2) |
| WK-DMF0068-0235 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (3) |
| WK-DMF0068-0236 | A1 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00002: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (MSG00002) |
| WK-DMF0068-0237 | A1 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00415: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (MSG00415) |
| WK-DMF0068-0238 | A1 | PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP: 골든 비교 케이스 없음(PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP — 팝업·보 |  | 24 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP` ACT) |
| WK-DMF0068-0239 | A1 | PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT: 골든 비교 케이스 없음(PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT — 팝업·보조 SP 는 golden_case |  | 1 (`DMF0068_GET_LOOKUPPROJECT`) |
| WK-DMF0068-0240 | A1 | PKG_DMF0068.P_DMF0068_GET_ORDERLIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST: 골든 비교 케이스 없음(PKG_DMF0068.P_DMF0068_GET_ORDERLIST — 팝업·보조 SP 는 golden_cases.csv 에  |  | 86 (`DMF0068_GET_ORDERLIST` ACT:DMF0068_Dema) |
| WK-DMF0068-0241 | A1 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 골든 비교 케이스 없음(SCM0001_GET_LOOKUP_VALUES — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0242 | A1 | `EditButton` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `EditButton`: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (`EditButton`) |
| WK-DMF0068-0243 | A1 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `FindButton` → `FindData`: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0244 | A1 | `SaveButton` → `SaveData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SaveButton` → `SaveData`: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (`SaveButton` → `SaveData`) |
| WK-DMF0068-0245 | A1 | 월 컬럼 11~154 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 월 컬럼 11~154 하드코딩: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (월 컬럼 11~154 하드코딩) |
| WK-DMF0068-0246 | A1 | 조회 직후 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 직후 전 컬럼 잠금: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (조회 직후 전 컬럼 잠금) |
| WK-DMF0068-0247 | A1 | 조회에도 편집 권한을 요구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회에도 편집 권한을 요구: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (조회에도 편집 권한을 요구) |
| WK-DMF0068-0248 | A6 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `FindButton` → `FindData`: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0249 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-DMF0068-0250 | G1 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00002: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MSG00002) |
| WK-DMF0068-0251 | G1 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00415: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MSG00415) |
| WK-DMF0068-0252 | G1 | `EditButton` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `EditButton`: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton`) |
| WK-DMF0068-0253 | G1 | `FindButton` → `FindData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `FindButton` → `FindData`: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton` → `FindData`) |
| WK-DMF0068-0254 | G1 | `SaveButton` → `SaveData` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SaveButton` → `SaveData`: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`SaveButton` → `SaveData`) |
| WK-DMF0068-0255 | G1 | 월 컬럼 11~154 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 월 컬럼 11~154 하드코딩: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (월 컬럼 11~154 하드코딩) |
| WK-DMF0068-0256 | G1 | 조회 직후 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회 직후 전 컬럼 잠금: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (조회 직후 전 컬럼 잠금) |
| WK-DMF0068-0257 | G1 | 조회에도 편집 권한을 요구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회에도 편집 권한을 요구: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (조회에도 편집 권한을 요구) |
| WK-DMF0068-0258 | G6 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 2: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-DMF0068-0259 | G6 | `EditButton` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `EditButton`: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton`) |
| WK-DMF0068-0260 | X-ROW | DMF0068_DemandManager40.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0068_DemandManager40.CreateSpread) |
| WK-DMF0068-0261 | X-ROW | DMF0068_DemandManager40.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_DemandManager40.DefineProper) |
| WK-DMF0068-0262 | X-ROW | DMF0068_DemandManager40.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.EditButton: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_DemandManager40.EditButton A) |
| WK-DMF0068-0263 | X-ROW | DMF0068_DemandManager40.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0068_DemandManager40.ExcelButton ) |
| WK-DMF0068-0264 | X-ROW | DMF0068_DemandManager40.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:DMF0068_DemandManager40.FindButton) |
| WK-DMF0068-0265 | X-ROW | DMF0068_DemandManager40.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.FindData: 진입점 집계 17검사 — NOT_RUN:15 · REVIEW:1 · PASS:1 |  | 10 (ACT:DMF0068_DemandManager40.FindData:618) |
| WK-DMF0068-0266 | X-ROW | DMF0068_DemandManager40.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0068_DemandManager40.Form_Load) |
| WK-DMF0068-0267 | X-ROW | DMF0068_DemandManager40.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.GetCellIndexBySpanRowCells: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0068_DemandManager40.GetCellIndex) |
| WK-DMF0068-0268 | X-ROW | DMF0068_DemandManager40.GetCellNumbersBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.GetCellNumbersByRow: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0068_DemandManager40.GetCellNumbe) |
| WK-DMF0068-0269 | X-ROW | DMF0068_DemandManager40.GetLookupProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.GetLookupProject: 진입점 집계 7검사 — NOT_RUN:2 · REVIEW:2 · NOPATH:1 · TODO:1 · PASS:1 |  | 1 (ACT:DMF0068_DemandManager40.GetLookupPro) |
| WK-DMF0068-0270 | X-ROW | DMF0068_DemandManager40.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0068_DemandManager40.InitControls) |
| WK-DMF0068-0271 | X-ROW | DMF0068_DemandManager40.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0068_DemandManager40.InitSpread A) |
| WK-DMF0068-0272 | X-ROW | DMF0068_DemandManager40.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0068_DemandManager40.InsertButton) |
| WK-DMF0068-0273 | X-ROW | DMF0068_DemandManager40.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.InsertRow: 진입점 집계 3검사 — NOPATH:3 (미실행 검사가 남아 판정필요) |  | 44 (ACT:DMF0068_DemandManager40.InsertRow AC) |
| WK-DMF0068-0274 | X-ROW | DMF0068_DemandManager40.MonthAgeFind | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.MonthAgeFind: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 16 (ACT:DMF0068_DemandManager40.MonthAgeFind) |
| WK-DMF0068-0275 | X-ROW | DMF0068_DemandManager40.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.SaveData: 진입점 집계 22검사 — NOT_RUN:16 · NOPATH:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_DemandManager40.SaveData:831) |
| WK-DMF0068-0276 | X-ROW | DMF0068_DemandManager40.SetSpreadMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.SetSpreadMonth: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0068_DemandManager40.SetSpreadMon) |
| WK-DMF0068-0277 | X-ROW | DMF0068_DemandManager40.btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.btnSPVer_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0068_DemandManager40.btnSPVer_Cli) |
| WK-DMF0068-0278 | X-ROW | DMF0068_DemandManager40.dtMeasureB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.dtMeasureB: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 7 (ACT:DMF0068_DemandManager40.dtMeasureB A) |
| WK-DMF0068-0279 | X-ROW | DMF0068_DemandManager40.dtMeasureS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_DemandManager40.dtMeasureS: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 7 (ACT:DMF0068_DemandManager40.dtMeasureS A) |
| WK-DMF0068-0280 | X-ROW | DMF0068_VersionPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0068_VersionPopup..ctor:88:1 ACT:) |
| WK-DMF0068-0281 | X-ROW | DMF0068_VersionPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0068_VersionPopup.CreateSpread AC) |
| WK-DMF0068-0282 | X-ROW | DMF0068_VersionPopup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_VersionPopup.DefineProperty ) |
| WK-DMF0068-0283 | X-ROW | DMF0068_VersionPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_VersionPopup.Dispose:16:1 AC) |
| WK-DMF0068-0284 | X-ROW | DMF0068_VersionPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:DMF0068_VersionPopup.FindButton ACT:) |
| WK-DMF0068-0285 | X-ROW | DMF0068_VersionPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.FindData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 20 (ACT:DMF0068_VersionPopup.FindData:208:1 ) |
| WK-DMF0068-0286 | X-ROW | DMF0068_VersionPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0068_VersionPopup.Form_Load:96:1 ) |
| WK-DMF0068-0287 | X-ROW | DMF0068_VersionPopup.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.GetLookupData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0068_VersionPopup.GetLookupData A) |
| WK-DMF0068-0288 | X-ROW | DMF0068_VersionPopup.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.GetSpdTitle: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0068_VersionPopup.GetSpdTitle ACT) |
| WK-DMF0068-0289 | X-ROW | DMF0068_VersionPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.InitControls: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0068_VersionPopup.InitControls:11) |
| WK-DMF0068-0290 | X-ROW | DMF0068_VersionPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0068_VersionPopup.InitSpread ACT:) |
| WK-DMF0068-0291 | X-ROW | DMF0068_VersionPopup.InitSpread_X | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.InitSpread_X: 진입점 집계 20검사 — NOT_RUN:20 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0068_VersionPopup.InitSpread_X:15) |
| WK-DMF0068-0292 | X-ROW | DMF0068_VersionPopup.SetItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.SetItem: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0068_VersionPopup.SetItem:334:1 A) |
| WK-DMF0068-0293 | X-ROW | DMF0068_VersionPopup.btnButtonList_UsrBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.btnButtonList_UsrButtonList_C: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0068_VersionPopup.btnButtonList_U) |
| WK-DMF0068-0294 | X-ROW | DMF0068_VersionPopup.spdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.spdMain_CellDoubleClick: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0068_VersionPopup.spdMain_CellDou) |
| WK-DMF0068-0295 | X-ROW | DMF0068_VersionPopup.txtItemID_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0068_VersionPopup.txtItemID_KeyDown: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0068_VersionPopup.txtItemID_KeyDo) |
| WK-DMF0068-0296 | X-ROW | `DMF0068_DEL_ORDERLIST` (FoxQuery 경유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `DMF0068_DEL_ORDERLIST` (FoxQuery 경유): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`DMF0068_DEL_ORDERLIST` (FoxQuery 경유)) |
| WK-DMF0068-0297 | X-ROW | `Form_Load` → InitControls / CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `Form_Load` → InitControls / CreateSpread / SetSpr: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`Form_Load` → InitControls / CreateSprea) |
| WK-DMF0068-0298 | X-ROW | `btnSPVer.Click` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `btnSPVer.Click`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`btnSPVer.Click`) |
| WK-DMF0068-0299 | X-ROW | 버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일) |
| WK-DMF0068-0300 | X-ROW | 범위 밖 월 0 처리가 두 번째 월부터 시작 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 범위 밖 월 0 처리가 두 번째 월부터 시작: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (범위 밖 월 0 처리가 두 번째 월부터 시작) |
| WK-DMF0068-0301 | X-ROW | 사업부 판정이 '포함' 비교라 140·401 도 통과 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 사업부 판정이 '포함' 비교라 140·401 도 통과: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (사업부 판정이 '포함' 비교라 140·401 도 통과) |
| WK-DMF0068-0302 | G5 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00002: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00002) |
| WK-DMF0068-0303 | G5 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00004: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004) |
| WK-DMF0068-0304 | G5 | MSG00084 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00084: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00084) |
| WK-DMF0068-0305 | G5 | MSG00096 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00096: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00096) |
| WK-DMF0068-0306 | G5 | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00105: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00105) |
| WK-DMF0068-0307 | G5 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00108: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00108) |
| WK-DMF0068-0308 | G5 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00113: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00113) |
| WK-DMF0068-0309 | G5 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00260: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00260) |
| WK-DMF0068-0310 | G5 | MSG00279 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00279: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279) |
| WK-DMF0068-0311 | G5 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00283: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00283) |
| WK-DMF0068-0312 | G5 | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00284: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00284) |
| WK-DMF0068-0313 | G5 | MSG00307 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00307: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00307) |
| WK-DMF0068-0314 | G5 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00415: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00415) |
| WK-DMF0068-0315 | G5 | `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `DMF0068_GET_CONT_VIEW_VERSIONPOPUP`: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP`) |
| WK-DMF0068-0316 | G5 | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `SCM0001_GET_LOOKUP_VALUES` (팝업 Type): 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0317 | H6 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00002: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00002) |
| WK-DMF0068-0318 | H6 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00004: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004) |
| WK-DMF0068-0319 | H6 | MSG00084 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00084: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00084) |
| WK-DMF0068-0320 | H6 | MSG00096 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00096: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00096) |
| WK-DMF0068-0321 | H6 | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00105: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00105) |
| WK-DMF0068-0322 | H6 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00108: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00108) |
| WK-DMF0068-0323 | H6 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00113: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00113) |
| WK-DMF0068-0324 | H6 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00260: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00260) |
| WK-DMF0068-0325 | H6 | MSG00279 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00279: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279) |
| WK-DMF0068-0326 | H6 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00283: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00283) |
| WK-DMF0068-0327 | H6 | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00284: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00284) |
| WK-DMF0068-0328 | H6 | MSG00307 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00307: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00307) |
| WK-DMF0068-0329 | H6 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00415: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00415) |
| WK-DMF0068-0330 | H6 | `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `DMF0068_GET_CONT_VIEW_VERSIONPOPUP`: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP`) |
| WK-DMF0068-0331 | H6 | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `SCM0001_GET_LOOKUP_VALUES` (팝업 Type): 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
| WK-DMF0068-0332 | M4 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00002: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00002) |
| WK-DMF0068-0333 | M4 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00004: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004) |
| WK-DMF0068-0334 | M4 | MSG00084 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00084: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00084) |
| WK-DMF0068-0335 | M4 | MSG00096 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00096: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00096) |
| WK-DMF0068-0336 | M4 | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00105: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00105) |
| WK-DMF0068-0337 | M4 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00108: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00108) |
| WK-DMF0068-0338 | M4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00113: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00113) |
| WK-DMF0068-0339 | M4 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00260: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00260) |
| WK-DMF0068-0340 | M4 | MSG00279 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00279: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279) |
| WK-DMF0068-0341 | M4 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00283: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00283) |
| WK-DMF0068-0342 | M4 | MSG00284 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00284: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00284) |
| WK-DMF0068-0343 | M4 | MSG00307 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00307: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00307) |
| WK-DMF0068-0344 | M4 | MSG00415 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00415: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00415) |
| WK-DMF0068-0345 | M4 | `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `DMF0068_GET_CONT_VIEW_VERSIONPOPUP`: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`DMF0068_GET_CONT_VIEW_VERSIONPOPUP`) |
| WK-DMF0068-0346 | M4 | `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `SCM0001_GET_LOOKUP_VALUES` (팝업 Type): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0001_GET_LOOKUP_VALUES` (팝업 Type)) |
