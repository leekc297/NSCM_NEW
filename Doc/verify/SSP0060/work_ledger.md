# 작업 원장 — SSP0060 · 2026-10-26 13:00

> 검사 인스턴스 1529건 중 PASS·NA 114건 외 **1415건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 140 | 구현 위치 실존 |
| W4 | 검사기 구현 | 19 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 79 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 539 | 실행 → PASS |
| W7 | 기대값 확정 | 615 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 22 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 575 · E2E 539 · 대조표 180 · 하네스 98 · 선행 W1 완료 후 E2E 22 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 15건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 192 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 140 |  |  |  |  | 34 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 79 | 16 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H2 | DESIGN |  |  |  |  |  | 53 | 1 | 22 |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 55 | 17 |  |  | 라벨 명칭 |
| A5 | DESIGN |  |  |  |  |  | 54 | 17 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| C3 | CASCADE |  |  |  |  |  | 36 | 21 |  |  | 연쇄 자동 채움 |
| D5 | EDIT |  |  |  |  |  | 52 | 3 |  |  | 셀 에디터 유형 |
| D1 | EDIT |  |  |  |  |  | 21 | 24 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 21 | 24 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 45 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  |  |  |  | 32 | 11 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-REASON | DESIGN |  |  |  |  |  |  | 40 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B4 | COMBO |  |  |  |  | 22 |  | 14 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G1 | GEN |  |  |  |  |  | 14 | 22 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  | 17 | 16 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  | 19 |  |  | 13 |  |  | 콤보 후보 정렬 = AS-IS |
| G5 | POPUP |  |  |  |  | 12 |  | 16 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 12 |  | 16 |  |  | 팝업 표준·열림 |
| A6 | GEN |  |  |  |  |  | 19 | 6 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 13 |  | 11 |  |  | BE 계정 시노님·권한·대상 객체 |
| C2 | CASCADE |  |  |  |  |  | 11 | 13 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 11 | 13 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  | 7 | 11 | 3 |  |  | 조회조건 표시·라벨·활성 |
| E1 | EDIT |  |  |  |  |  | 15 | 2 |  |  | 숫자 소수자리·정수·부호·범위 |
| C1 | CASCADE |  |  |  |  |  | 9 | 7 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 10 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C4 | CASCADE |  |  |  |  |  | 1 | 7 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| D4 | EDIT |  |  |  |  |  | 2 | 6 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 중복 없음 |
| M3 | POPUP |  |  |  |  |  | 3 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0001 | X-NOTIMPL | Ra | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — Ra L5503~5510 `CONTAINER` measure 행에서 `LOT_YN=='N'` 이면 FCST_TYPE+1~끝 값 전부 null 미구현(값 규칙) |  | 1 (Ra) |

## W2 구현 위치 확인 (140)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0002 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: organisms/data-grid/DataGrid.tsx 없음 |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0003 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SSP0060-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0005 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0006 | X-LOC | CRUD:DELETE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:DELETE) |
| WK-SSP0060-0007 | X-LOC | CRUD:EDIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:EDIT) |
| WK-SSP0060-0008 | X-LOC | CRUD:INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:INSERT) |
| WK-SSP0060-0009 | X-LOC | CRUD:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:SAVE) |
| WK-SSP0060-0010 | X-LOC | CRUD:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0011 | X-LOC | D00-1-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-007) |
| WK-SSP0060-0012 | X-LOC | D00-1-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-008) |
| WK-SSP0060-0013 | X-LOC | D00-1-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-010) |
| WK-SSP0060-0014 | X-LOC | D00-1-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-011) |
| WK-SSP0060-0015 | X-LOC | D00-1-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-012) |
| WK-SSP0060-0016 | X-LOC | D00-1-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-013) |
| WK-SSP0060-0017 | X-LOC | D00-1-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-014) |
| WK-SSP0060-0018 | X-LOC | D00-1-015 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-015) |
| WK-SSP0060-0019 | X-LOC | D00-1-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-016) |
| WK-SSP0060-0020 | X-LOC | D00-1-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-017) |
| WK-SSP0060-0021 | X-LOC | D00-1-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-018) |
| WK-SSP0060-0022 | X-LOC | D00-1-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-019) |
| WK-SSP0060-0023 | X-LOC | D00-1-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-021) |
| WK-SSP0060-0024 | X-LOC | D00-1-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-022) |
| WK-SSP0060-0025 | X-LOC | D00-1-023 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-023) |
| WK-SSP0060-0026 | X-LOC | D00-1-030~031 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-030~031) |
| WK-SSP0060-0027 | X-LOC | D00-1-032~046 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-032~046) |
| WK-SSP0060-0028 | X-LOC | D00-1-047 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-047) |
| WK-SSP0060-0029 | X-LOC | D00-1-048 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-048) |
| WK-SSP0060-0030 | X-LOC | D00-1-049 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-049) |
| WK-SSP0060-0031 | X-LOC | D00-1-050~051 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-050~051) |
| WK-SSP0060-0032 | X-LOC | D00-1-052 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-052) |
| WK-SSP0060-0033 | X-LOC | D00-1-053 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-053) |
| WK-SSP0060-0034 | X-LOC | D00-1-055 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-055) |
| WK-SSP0060-0035 | X-LOC | D00-1-057 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-057) |
| WK-SSP0060-0036 | X-LOC | D00-1-059 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-059) |
| WK-SSP0060-0037 | X-LOC | D00-1-060 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-060) |
| WK-SSP0060-0038 | X-LOC | D00-1-061 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-061) |
| WK-SSP0060-0039 | X-LOC | D00-1-062 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-062) |
| WK-SSP0060-0040 | X-LOC | D00-1-064 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-064) |
| WK-SSP0060-0041 | X-LOC | D00-1-065~066 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-065~066) |
| WK-SSP0060-0042 | X-LOC | D00-2-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-003) |
| WK-SSP0060-0043 | X-LOC | D00-2-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-004) |
| WK-SSP0060-0044 | X-LOC | D00-2-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-005) |
| WK-SSP0060-0045 | X-LOC | D00-2-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-006) |
| WK-SSP0060-0046 | X-LOC | D00-2-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-007) |
| WK-SSP0060-0047 | X-LOC | D00-2-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-008) |
| WK-SSP0060-0048 | X-LOC | D00-2-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-009) |
| WK-SSP0060-0049 | X-LOC | D00-2-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-010) |
| WK-SSP0060-0050 | X-LOC | D00-2-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-012) |
| WK-SSP0060-0051 | X-LOC | D00-2-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-013) |
| WK-SSP0060-0052 | X-LOC | D00-2-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-014) |
| WK-SSP0060-0053 | X-LOC | D00-2-015 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-015) |
| WK-SSP0060-0054 | X-LOC | D00-2-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-016) |
| WK-SSP0060-0055 | X-LOC | D00-2-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-017) |
| WK-SSP0060-0056 | X-LOC | D00-2-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-018) |
| WK-SSP0060-0057 | X-LOC | D00-2-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-020) |
| WK-SSP0060-0058 | X-LOC | D00-2-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-021) |
| WK-SSP0060-0059 | X-LOC | D00-2-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-022) |
| WK-SSP0060-0060 | X-LOC | D00-2-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-024) |
| WK-SSP0060-0061 | X-LOC | D00-2-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-025) |
| WK-SSP0060-0062 | X-LOC | D00-2b-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-002) |
| WK-SSP0060-0063 | X-LOC | D00-2b-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-004) |
| WK-SSP0060-0064 | X-LOC | D00-2b-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-014) |
| WK-SSP0060-0065 | X-LOC | D00-2b-015~016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0066 | X-LOC | D00-2b-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-018) |
| WK-SSP0060-0067 | X-LOC | D00-2b-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-019) |
| WK-SSP0060-0068 | X-LOC | D00-2b-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-020) |
| WK-SSP0060-0069 | X-LOC | D00-2b-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-021) |
| WK-SSP0060-0070 | X-LOC | D00-2b-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-022) |
| WK-SSP0060-0071 | X-LOC | D00-2b-023 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-023) |
| WK-SSP0060-0072 | X-LOC | D00-2b-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-025) |
| WK-SSP0060-0073 | X-LOC | D00-2b-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-026) |
| WK-SSP0060-0074 | X-LOC | D00-2b-027 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-027) |
| WK-SSP0060-0075 | X-LOC | D00-2b-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-028) |
| WK-SSP0060-0076 | X-LOC | D00-2b-034~035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-034~035) |
| WK-SSP0060-0077 | X-LOC | D00-2b-059 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2b-059) |
| WK-SSP0060-0078 | X-LOC | D00-3-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-001) |
| WK-SSP0060-0079 | X-LOC | D00-3-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-002) |
| WK-SSP0060-0080 | X-LOC | D00-3-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-003) |
| WK-SSP0060-0081 | X-LOC | D00-3-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-004) |
| WK-SSP0060-0082 | X-LOC | D00-3-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-008) |
| WK-SSP0060-0083 | X-LOC | D00-3-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-009) |
| WK-SSP0060-0084 | X-LOC | D00-3-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-010) |
| WK-SSP0060-0085 | X-LOC | D00-3-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-011) |
| WK-SSP0060-0086 | X-LOC | D00-3-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-013) |
| WK-SSP0060-0087 | X-LOC | D00-3-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-014) |
| WK-SSP0060-0088 | X-LOC | D00-3-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-016) |
| WK-SSP0060-0089 | X-LOC | D00-3-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-019) |
| WK-SSP0060-0090 | X-LOC | D00-3-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-020) |
| WK-SSP0060-0091 | X-LOC | D00-3-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-022) |
| WK-SSP0060-0092 | X-LOC | D00-3-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-026) |
| WK-SSP0060-0093 | X-LOC | D00-3-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-028) |
| WK-SSP0060-0094 | X-LOC | D00-3-029 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-029) |
| WK-SSP0060-0095 | X-LOC | D00-4-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-001) |
| WK-SSP0060-0096 | X-LOC | D00-4-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-002) |
| WK-SSP0060-0097 | X-LOC | D00-4-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-003) |
| WK-SSP0060-0098 | X-LOC | D00-4-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-017) |
| WK-SSP0060-0099 | X-LOC | D00-4-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-018) |
| WK-SSP0060-0100 | X-LOC | D00-4-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-019) |
| WK-SSP0060-0101 | X-LOC | D00-4-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-020) |
| WK-SSP0060-0102 | X-LOC | D00-4-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-021) |
| WK-SSP0060-0103 | X-LOC | D00-4-022~023 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-022~023) |
| WK-SSP0060-0104 | X-LOC | D00-4-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-024) |
| WK-SSP0060-0105 | X-LOC | D00-4-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-025) |
| WK-SSP0060-0106 | X-LOC | D00-4-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-026) |
| WK-SSP0060-0107 | X-LOC | D00-4-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4-028) |
| WK-SSP0060-0108 | X-LOC | D00-4a-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-001) |
| WK-SSP0060-0109 | X-LOC | D00-4a-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-002) |
| WK-SSP0060-0110 | X-LOC | D00-4a-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-003) |
| WK-SSP0060-0111 | X-LOC | D00-4a-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-004) |
| WK-SSP0060-0112 | X-LOC | D00-4a-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-005) |
| WK-SSP0060-0113 | X-LOC | D00-4a-006~036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0114 | X-LOC | D00-4b-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-001) |
| WK-SSP0060-0115 | X-LOC | D00-4b-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-007) |
| WK-SSP0060-0116 | X-LOC | D00-4b-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-009) |
| WK-SSP0060-0117 | X-LOC | D00-4b-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-010) |
| WK-SSP0060-0118 | X-LOC | D00-4d-001~002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0119 | X-LOC | D00-4d-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-003) |
| WK-SSP0060-0120 | X-LOC | D00-4d-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-004) |
| WK-SSP0060-0121 | X-LOC | D00-4d-005~006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-005~006) |
| WK-SSP0060-0122 | X-LOC | D00-4d-007~009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-007~009) |
| WK-SSP0060-0123 | X-LOC | D00-4d-010~013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-010~013) |
| WK-SSP0060-0124 | X-LOC | D00-4d-019~030 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-019~030) |
| WK-SSP0060-0125 | X-LOC | D00-4d-033~034 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-033~034) |
| WK-SSP0060-0126 | X-LOC | D00-4d-035~036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-035~036) |
| WK-SSP0060-0127 | X-LOC | D00-4d-037 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-037) |
| WK-SSP0060-0128 | X-LOC | D00-4d-039~040 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-039~040) |
| WK-SSP0060-0129 | X-LOC | D00-4d-041~042 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-041~042) |
| WK-SSP0060-0130 | X-LOC | D00-4d-043 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-043) |
| WK-SSP0060-0131 | X-LOC | D00-4e-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-001) |
| WK-SSP0060-0132 | X-LOC | D00-4e-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-002) |
| WK-SSP0060-0133 | X-LOC | D00-4e-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-003) |
| WK-SSP0060-0134 | X-LOC | D00-4e-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ConfirmDetailModal.tsx 없음 |  | 1 (D00-4e-005) |
| WK-SSP0060-0135 | X-LOC | D00-4e-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-006) |
| WK-SSP0060-0136 | X-LOC | D00-4e-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-008) |
| WK-SSP0060-0137 | X-LOC | MODAL:ConfirmDetailModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ConfirmDetailModal.tsx 없음 |  | 1 (MODAL:ConfirmDetailModal) |
| WK-SSP0060-0138 | X-LOC | Rb | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Rb) |
| WK-SSP0060-0139 | X-LOC | Rc | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Rc) |
| WK-SSP0060-0140 | X-LOC | Rd | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Rd) |
| WK-SSP0060-0141 | X-LOC | Re | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Re) |

## W4 검사기 구현 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0142 | B3 | CHANGE_REQ_NO | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0143 | B3 | CHANGE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0144 | B3 | CONFIRM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM_ID | 있음(SHEET_COLUMNS) | 28 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0145 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 14 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0146 | B3 | EDIT_MAIN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0147 | B3 | ERP_SO_NO | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ERP_SO_NO | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0148 | B3 | FCST_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FCST_TYPE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0149 | B3 | FROM_SITE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FROM_SITE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0150 | B3 | INCOTERMS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 INCOTERMS | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0151 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0152 | B3 | NEW_SHIPMENT_DATE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 NEW_SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0153 | B3 | PRODUCT_LEVEL1 | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PRODUCT_LEVEL1 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0154 | B3 | SHIPMENT_CONFIRM_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_CONFIRM_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0155 | B3 | SHIPMENT_DATE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 9 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0156 | B3 | TO_SITE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 TO_SITE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0157 | B3 | TRANSPORT_MODE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0158 | B3 | chkTotPSI / Total PSI / Tot PSI | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkTotPSI / Total PSI / Tot PSI | 있음(FE 소스) | 4 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0159 | B3 | clbResultType / Result Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SSP0060-0160 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0060_ShipmentPlan.GetSpdTitle ACT) |

## W5 검사기 연결 (79)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0161 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0162 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0163 | B1 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0164 | B1 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0165 | B1 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0166 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0167 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0168 | B2 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0169 | B2 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0170 | B2 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0171 | B4 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0172 | B4 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0173 | B4 | CONFIRM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM_ID | 있음(SHEET_COLUMNS) | 28 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0174 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 15 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0175 | B4 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0176 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0177 | B4 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0178 | B4 | FCST_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FCST_TYPE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0179 | B4 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0180 | B4 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0181 | B4 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0182 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0183 | B4 | NEW_SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NEW_SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0184 | B4 | PRODUCT_LEVEL1 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PRODUCT_LEVEL1 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0185 | B4 | SHIPMENT_CONFIRM_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_CONFIRM_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0186 | B4 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 9 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0187 | B4 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0188 | B4 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0189 | B4 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0190 | B4 | chkTotPSI / Total PSI / Tot PSI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkTotPSI / Total PSI / Tot PSI | 있음(FE 소스) | 4 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0191 | B4 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SSP0060-0192 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0060_ShipmentPlan.GetSpdTitle ACT) |
| WK-SSP0060-0193 | F2 | SSP0060 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0060 화면 | 판단불가(대상 단위 SCREEN) | 530 (D00-2b-003 D00-2b-021 D00-2b-022 D00-2b-) |
| WK-SSP0060-0194 | F6 | SSP0060 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0060 화면 | 판단불가(대상 단위 SCREEN) | 516 (D00-4-002 D00-4-003 I2 ACT:SSP0060_Shipm) |
| WK-SSP0060-0195 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (D00-4-017 ACT:SSP0060_ShipmentPlan.GetBu) |
| WK-SSP0060-0196 | DB-SYN | PKG_COM0000 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_COM0000 | 없음(PROC_M 대응 없음) | 1 (D00-4-028) |
| WK-SSP0060-0197 | DB-SYN | PKG_SSP0300 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SSP0300 | 없음(PROC_M 대응 없음) | 1 (D00-4e-004) |
| WK-SSP0060-0198 | DB-SYN | P_PROCEDURE_KEY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROCEDURE_KEY | 없음(PROC_M 대응 없음) | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0199 | DB-SYN | P_SEQUENCE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SEQUENCE | 없음(PROC_M 대응 없음) | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0200 | DB-SYN | P_SSP0060_GET_CALENDAR | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0060_GET_CALENDAR | 없음(PROC_M 대응 없음) | 1 (D00-4-028) |
| WK-SSP0060-0201 | DB-SYN | P_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_TYPE | 없음(PROC_M 대응 없음) | 1 (D00-4-022~023) |
| WK-SSP0060-0202 | DB-SYN | SSP0002_GET_NERP_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0002_GET_NERP_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0203 | DB-SYN | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0204 | DB-SYN | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0205 | DB-SYN | SSP0060_GET_ERP_SO_NO_CNT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_GET_ERP_SO_NO_CNT | 없음(PROC_M 대응 없음) | 15 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0206 | DB-SYN | SSP0060_GET_SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_GET_SHIPMENT_STATUS | 없음(PROC_M 대응 없음) | 15 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0207 | DB-SYN | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 없음(PROC_M 대응 없음) | 6 (ACT:SSP0060_ShipmentPlan.NewNonSoNo:4928) |
| WK-SSP0060-0208 | G4 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemID2 | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0209 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0210 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 없음 | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0211 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0212 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0213 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0214 | G4 | btnSimulation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSimulation | 없음 | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0215 | G03-WIRE | SSP0060 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0060 화면 | 판단불가(대상 단위 SCREEN) | 42 (ACT:SSP0060_ShipmentPlan..ctor ACT:SSP00) |
| WK-SSP0060-0216 | G5 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0217 | G5 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 5 (D00-2-018 MODAL:OrderDetailPopup ACT:SSP) |
| WK-SSP0060-0218 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 79 (D00-2-018 D00-3-015 ACT:SSP0060_Shipment) |
| WK-SSP0060-0219 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-015) |
| WK-SSP0060-0220 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 47 (D00-2-018 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0221 | G5 | REMARKS2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL REMARKS2 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0222 | G5 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0223 | G5 | SSP0060_ShipmentPlanConfirmDetailPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SSP0060_ShipmentPlanConfirmDetailPopup | 판단불가(대상 단위 POPUP) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0224 | G5 | SSP0060_ShipmentPlanRequestPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SSP0060_ShipmentPlanRequestPopup | 판단불가(대상 단위 POPUP) | 3 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0225 | G5 | btnId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnId | 있음(FE 소스) | 1 (D00-4e-004) |
| WK-SSP0060-0226 | G5 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemID2 | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0060-0227 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SSP0060-0228 | H6 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0229 | H6 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 5 (D00-2-018 MODAL:OrderDetailPopup ACT:SSP) |
| WK-SSP0060-0230 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 79 (D00-2-018 D00-3-015 ACT:SSP0060_Shipment) |
| WK-SSP0060-0231 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (D00-3-015) |
| WK-SSP0060-0232 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 47 (D00-2-018 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0233 | H6 | REMARKS2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0234 | H6 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0235 | H6 | SSP0060_ShipmentPlanConfirmDetailPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SSP0060_ShipmentPlanConfirmDetailPopup | 판단불가(대상 단위 POPUP) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0236 | H6 | SSP0060_ShipmentPlanRequestPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SSP0060_ShipmentPlanRequestPopup | 판단불가(대상 단위 POPUP) | 3 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0237 | H6 | btnId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnId | 있음(FE 소스) | 1 (D00-4e-004) |
| WK-SSP0060-0238 | H6 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemID2 | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0060-0239 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (D00-1-004) |

## W6 검증 실행 (539)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0240 | J2 | SSP0060 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0060 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 220 (D00-1-003 D00-1-004 D00-1-007 D00-1-008 ) |
| WK-SSP0060-0241 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InitControls:46) |
| WK-SSP0060-0242 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0060-0243 | C1 | chkSum / Sum(Week) / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SSP0060-0244 | C1 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0245 | C1 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0246 | C1 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0247 | C1 | clbProductLevel11 / Product Level1 / Pro | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbProductLevel11 / Product Level1 / Product Level · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 0 () |
| WK-SSP0060-0248 | C1 | clbProductLevel12 / Product Level1 / Pro | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbProductLevel12 / Product Level1 / Product Level · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 0 () |
| WK-SSP0060-0249 | C1 | clbResultType / Result Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbResultType / Result Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InitControls:49) |
| WK-SSP0060-0250 | C2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 26 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0251 | C2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0252 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0253 | C2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0254 | C2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0255 | C2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0256 | C2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0257 | C2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0258 | C2 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0259 | C2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0260 | C2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0261 | C3 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 37 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0262 | C3 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0263 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread:671:) |
| WK-SSP0060-0264 | C3 | DIFF_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIFF_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Cal) |
| WK-SSP0060-0265 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InsertRow:2546:) |
| WK-SSP0060-0266 | C3 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 35 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0267 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0268 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 24 (ACT:SSP0060_ShipmentPlan.InitSpread:666:) |
| WK-SSP0060-0269 | C3 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0270 | C3 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0271 | C3 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlan.InitSpread:656:) |
| WK-SSP0060-0272 | C3 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.InsertRow:2547:) |
| WK-SSP0060-0273 | C3 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2548:) |
| WK-SSP0060-0274 | C3 | FROM_SITE_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2548:) |
| WK-SSP0060-0275 | C3 | HOLD_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — HOLD_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2555:) |
| WK-SSP0060-0276 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0060_ShipmentPlan.InitSpread:655:) |
| WK-SSP0060-0277 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0278 | C3 | LOT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.Re_Design:5490:) |
| WK-SSP0060-0279 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlan.EditByChange:21) |
| WK-SSP0060-0280 | C3 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InitSpread:652:) |
| WK-SSP0060-0281 | C3 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0282 | C3 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0283 | C3 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0284 | C3 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0285 | C3 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0286 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InsertRow:2550:) |
| WK-SSP0060-0287 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0288 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0289 | C3 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InitSpread:651:) |
| WK-SSP0060-0290 | C3 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0291 | C3 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0292 | C3 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (D00-3-013 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0293 | C3 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (I1-paste ACT:SSP0060_ShipmentPlan.InitSp) |
| WK-SSP0060-0294 | C3 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0295 | C3 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 48 (ACT:SSP0060_ShipmentPlan.InitSpread:654:) |
| WK-SSP0060-0296 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0297 | C4 | chkSum / Sum(Week) / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SSP0060-0298 | C6 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 26 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0299 | C6 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0300 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0301 | C6 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0302 | C6 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0303 | C6 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0304 | C6 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0305 | C6 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0306 | C6 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0307 | C6 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-013) |
| WK-SSP0060-0308 | C6 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0309 | G3 | SSP0060 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0060 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 8 (D00-1-064 COMMON:UC-01 COMMON:UC-02 COMM) |
| WK-SSP0060-0310 | K-SA | SSP0060 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0060 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (D00-1-064 COMMON:UC-02) |
| WK-SSP0060-0311 | K4 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 162 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0060-0312 | F1 | SSP0060 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0060 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 533 (D00-2b-003 D00-2b-021 D00-2b-022 D00-2b-) |
| WK-SSP0060-0313 | F3 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 106 (I1-paste I22 ACT:SSP0060_ShipmentPlan.Sp) |
| WK-SSP0060-0314 | F5 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (D00-4a-004 CRUD:DELETE I1-delete) |
| WK-SSP0060-0315 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (D00-4-017 ACT:SSP0060_ShipmentPlan.GetBu) |
| WK-SSP0060-0316 | F4 | PKG_COM0000 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-028) |
| WK-SSP0060-0317 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 914 (D00-4-028 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0318 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (D00-4-030 ACT:SSP0060_ShipmentPlan.GetSS) |
| WK-SSP0060-0319 | F4 | PKG_SSP0020.P_USER_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-0320 | F4 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0321 | F4 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0322 | F4 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0323 | F4 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0324 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVIS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 3 (D00-4-001 ACT:SSP0060_ShipmentPlan.SetCh) |
| WK-SSP0060-0325 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 401 (D00-4-018 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0326 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 337 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0327 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0328 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-0329 | F4 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0330 | F4 | PKG_SSP0060.P_SSP0060_SAVE_HOLD_STOCK_DA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_SAVE_HOLD_STOCK_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 241 (ACT:SSP0060_ShipmentPlan.SaveButton ACT:) |
| WK-SSP0060-0331 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_PLAN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_PLAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 96 (D00-4-002 ACT:SSP0060_ShipmentPlan.SaveB) |
| WK-SSP0060-0332 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 422 (D00-4-003 ACT:SSP0060_ShipmentPlan.SaveB) |
| WK-SSP0060-0333 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.Non) |
| WK-SSP0060-0334 | F4 | PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0335 | F4 | PKG_SSP0300 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0300 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4e-004) |
| WK-SSP0060-0336 | F4 | P_PROCEDURE_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PROCEDURE_KEY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0337 | F4 | P_SEQUENCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SEQUENCE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0338 | F4 | P_SSP0060_GET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SSP0060_GET_CALENDAR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-028) |
| WK-SSP0060-0339 | F4 | P_SSP0300_GET_ORDER_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SSP0300_GET_ORDER_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4e-004) |
| WK-SSP0060-0340 | F4 | P_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_TYPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-022~023) |
| WK-SSP0060-0341 | F4 | SSP0002_GET_NERP_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0002_GET_NERP_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0342 | F4 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_GET_SSP_PLAN_PROCESSING_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 181 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0343 | F4 | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0344 | F4 | SSP0060_GET_ERP_SO_NO_CNT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0060_GET_ERP_SO_NO_CNT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 431 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0345 | F4 | SSP0060_GET_SHIPMENT_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0060_GET_SHIPMENT_STATUS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 431 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0346 | F4 | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 6 (ACT:SSP0060_ShipmentPlan.NewNonSoNo:4928) |
| WK-SSP0060-0347 | A5 | BOH_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOH_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0348 | A5 | BOH_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0349 | A5 | CHANGE_REASON_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0350 | A5 | CHANGE_REASON_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0351 | A5 | CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 11 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0352 | A5 | CONFIRM_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 0 () |
| WK-SSP0060-0353 | A5 | CONFIRM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0354 | A5 | DIFF_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIFF_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0355 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0356 | A5 | EDIT_MAIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0357 | A5 | EDIT_REMARKS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_REMARKS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0358 | A5 | ELECTRODE_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0359 | A5 | ELECTRODE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ELECTRODE_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0360 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0361 | A5 | ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0362 | A5 | ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0363 | A5 | FCST_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 25 (D00-3-002 ACT:SSP0060_ShipmentPlan.InitS) |
| WK-SSP0060-0364 | A5 | FROM_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0365 | A5 | FROM_SITE_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Di |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0366 | A5 | INCOTERMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0367 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0368 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0369 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (D00-3-002) |
| WK-SSP0060-0370 | A5 | MEASURE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0371 | A5 | NEW_A_COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_A_COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0372 | A5 | NEW_A_PORT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_A_PORT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0373 | A5 | NEW_BOD_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_BOD_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0374 | A5 | NEW_D_COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_D_COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0375 | A5 | NEW_D_PORT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_D_PORT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0376 | A5 | NEW_ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0377 | A5 | NEW_ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0378 | A5 | NEW_LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0379 | A5 | NEW_ROUTE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0380 | A5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0381 | A5 | NEW_SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0382 | A5 | NEW_TO_CITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TO_CITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0383 | A5 | NEW_TO_COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TO_COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0384 | A5 | NEW_TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0385 | A5 | NEW_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0386 | A5 | NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0387 | A5 | ORIGIN_FROM_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective  |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0388 | A5 | ORIGIN_TO_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Di |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0389 | A5 | PRODUCT_LEVEL1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRODUCT_LEVEL1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0390 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0391 | A5 | PROJECT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0392 | A5 | PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PSI · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0393 | A5 | REMARKS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0394 | A5 | REMARKS2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0395 | A5 | REMARKS3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0396 | A5 | SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0397 | A5 | SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0398 | A5 | TO_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0399 | A5 | TO_SITE_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0400 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0401 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SSP0060_ShipmentPlan.DefineProperty ) |
| WK-SSP0060-0402 | G4 | cboChangeReason / Change Reason | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeReason / Change Reason · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0403 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:SSP0060_ShipmentPlan.InitControls AC) |
| WK-SSP0060-0404 | G4 | chkSum / Sum(Week) / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0405 | G4 | chkTotPSI / Total PSI / Tot PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkTotPSI / Total PSI / Tot PSI · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0406 | G4 | clbCompany_ID / Company / Company_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SSP0060_ShipmentPlan.Form_Load ACT:S) |
| WK-SSP0060-0407 | G4 | clbDivision_ID / Division / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0408 | G4 | clbResultType / Result Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbResultType / Result Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.InitControls AC) |
| WK-SSP0060-0409 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (ACT:SSP0060_ShipmentPlan.ControlClear:55) |
| WK-SSP0060-0410 | G4 | drpPeriod2 / Shipment Date / Period2 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (ACT:SSP0060_ShipmentPlan.ControlClear:55) |
| WK-SSP0060-0411 | G4 | drpPeriod3 / Shipment Date / Period3 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SSP0060_ShipmentPlan.InitControls) |
| WK-SSP0060-0412 | H2 | BACK_COLOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BACK_COLOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (확정구간 스타일) |
| WK-SSP0060-0413 | H2 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0414 | H2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0415 | H2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0416 | H2 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0417 | H2 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0418 | H2 | DIFF_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIFF_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0419 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0420 | H2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0421 | H2 | EDIT_REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0422 | H2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0423 | H2 | ELECTRODE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ELECTRODE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0424 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0425 | H2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0426 | H2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0427 | H2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (D00-3-002 Ra ACT:SSP0060_ShipmentPlan.In) |
| WK-SSP0060-0428 | H2 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0429 | H2 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0430 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0431 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0432 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0433 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-3-002) |
| WK-SSP0060-0434 | H2 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (Rb Re ACT:SSP0060_ShipmentPlan.InitSprea) |
| WK-SSP0060-0435 | H2 | NEW_A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_A_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0436 | H2 | NEW_A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_A_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0437 | H2 | NEW_BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0438 | H2 | NEW_D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_D_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0439 | H2 | NEW_D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_D_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0440 | H2 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0441 | H2 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0442 | H2 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0443 | H2 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0444 | H2 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0445 | H2 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0446 | H2 | NEW_TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0447 | H2 | NEW_TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TO_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0448 | H2 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0449 | H2 | NEW_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0450 | H2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0451 | H2 | ORIGIN_FROM_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0452 | H2 | ORIGIN_TO_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0453 | H2 | PRODUCT_LEVEL1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRODUCT_LEVEL1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0454 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0455 | H2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0456 | H2 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0457 | H2 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0458 | H2 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0459 | H2 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0460 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0461 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0462 | H2 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (Rc ACT:SSP0060_ShipmentPlan.InitSpread A) |
| WK-SSP0060-0463 | H2 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0464 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0465 | H4 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0060-0466 | H5 | BOH_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOH_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 12 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0467 | H5 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOH_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0468 | H5 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0469 | H5 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0470 | H5 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0471 | H5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CONFIRM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0472 | H5 | DIFF_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIFF_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0473 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0474 | H5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_MAIN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0475 | H5 | EDIT_REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_REMARKS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0476 | H5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0477 | H5 | ELECTRODE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ELECTRODE_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0478 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0479 | H5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0480 | H5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0481 | H5 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FCST_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 25 (D00-3-002 ACT:SSP0060_ShipmentPlan.InitS) |
| WK-SSP0060-0482 | H5 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_SITE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0483 | H5 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0484 | H5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INCOTERMS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0485 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0486 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0487 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (D00-3-002) |
| WK-SSP0060-0488 | H5 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0489 | H5 | NEW_A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_A_COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0490 | H5 | NEW_A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_A_PORT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0491 | H5 | NEW_BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_BOD_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0492 | H5 | NEW_D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_D_COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0493 | H5 | NEW_D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_D_PORT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0494 | H5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0495 | H5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0496 | H5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0497 | H5 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ROUTE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0498 | H5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0499 | H5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0500 | H5 | NEW_TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TO_CITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0501 | H5 | NEW_TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TO_COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0502 | H5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0503 | H5 | NEW_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0504 | H5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NICK_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0505 | H5 | ORIGIN_FROM_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0506 | H5 | ORIGIN_TO_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0507 | H5 | PRODUCT_LEVEL1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRODUCT_LEVEL1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0508 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0509 | H5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0510 | H5 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PSI · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0511 | H5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARKS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0512 | H5 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARKS2 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0513 | H5 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARKS3 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0514 | H5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0515 | H5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0516 | H5 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_SITE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0517 | H5 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0518 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0519 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0520 | H5 | chkSum / Sum(Week) / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0521 | I1 | SSP0060 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0060 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 111 (D00-2-014 D00-2b-002 D00-2b-003 D00-2b-0) |
| WK-SSP0060-0522 | SC1 | SSP0060 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0060 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 3 (D00-4e-001 D00-4e-008 COMMON:UC-06) |
| WK-SSP0060-0523 | D1 | BACK_COLOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BACK_COLOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (확정구간 스타일) |
| WK-SSP0060-0524 | D1 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0525 | D1 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0526 | D1 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0527 | D1 | CONFIRM_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONFIRM_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-023 편집 가능 일자(노랑) ACT:SSP0060_Shipm) |
| WK-SSP0060-0528 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 10 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0529 | D1 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0530 | D1 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0531 | D1 | HOLD_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — HOLD_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton:2874) |
| WK-SSP0060-0532 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0533 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0534 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0535 | D1 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0536 | D1 | MKT_OWNER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MKT_OWNER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0537 | D1 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0538 | D1 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0539 | D1 | ORIGIN_TO_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0540 | D1 | PRODUCT_LEVEL1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRODUCT_LEVEL1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0541 | D1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0542 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0543 | D1 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-2-004 I1-paste ACT:SSP0060_ShipmentP) |
| WK-SSP0060-0544 | D3 | BACK_COLOR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BACK_COLOR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (확정구간 스타일) |
| WK-SSP0060-0545 | D3 | CHANGE_REASON_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REASON_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0546 | D3 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0547 | D3 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0548 | D3 | CONFIRM_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONFIRM_DAY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-023 편집 가능 일자(노랑) ACT:SSP0060_Shipm) |
| WK-SSP0060-0549 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 10 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0550 | D3 | ERP_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0551 | D3 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0552 | D3 | HOLD_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — HOLD_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton:2874) |
| WK-SSP0060-0553 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0554 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0555 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0556 | D3 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0557 | D3 | MKT_OWNER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MKT_OWNER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0558 | D3 | NEW_SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0559 | D3 | NEW_SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0560 | D3 | ORIGIN_TO_DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0561 | D3 | PRODUCT_LEVEL1 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRODUCT_LEVEL1 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0562 | D3 | SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0563 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0564 | D3 | TO_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-2-004 I1-paste ACT:SSP0060_ShipmentP) |
| WK-SSP0060-0565 | D4 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-009) |
| WK-SSP0060-0566 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Model(ITEM_ID) 그룹 경계 검정 실선) |
| WK-SSP0060-0567 | D5 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0568 | D5 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0569 | D5 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0570 | D5 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0571 | D5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0572 | D5 | DIFF_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIFF_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0573 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0574 | D5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0575 | D5 | EDIT_REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EDIT_REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0576 | D5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0577 | D5 | ELECTRODE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ELECTRODE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0578 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0579 | D5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0580 | D5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0581 | D5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0582 | D5 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0583 | D5 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0584 | D5 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0585 | D5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0586 | D5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0587 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0588 | D5 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0589 | D5 | NEW_A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_A_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0590 | D5 | NEW_A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_A_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0591 | D5 | NEW_BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0592 | D5 | NEW_D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_D_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0593 | D5 | NEW_D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_D_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0594 | D5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0595 | D5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0596 | D5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0597 | D5 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0598 | D5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0599 | D5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0600 | D5 | NEW_TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0601 | D5 | NEW_TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TO_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0602 | D5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0603 | D5 | NEW_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0604 | D5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0605 | D5 | ORIGIN_FROM_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0606 | D5 | ORIGIN_TO_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ORIGIN_TO_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0607 | D5 | PRODUCT_LEVEL1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PRODUCT_LEVEL1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0608 | D5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0609 | D5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0610 | D5 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0611 | D5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0612 | D5 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0613 | D5 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0614 | D5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0615 | D5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0616 | D5 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0617 | D5 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0618 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0619 | D6 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 9 (D00-3-022 D00-4a-005 CRUD:INSERT 음수 = 빨간) |
| WK-SSP0060-0620 | E1 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 8 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0621 | E1 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0622 | E1 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 12 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0623 | E1 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 13 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0624 | E1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0060-0625 | E1 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0626 | E1 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0627 | E1 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0628 | E1 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0629 | E1 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0630 | E1 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0631 | E1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0632 | E1 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 9 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0633 | E1 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (I1-paste ACT:SSP0060_ShipmentPlan.SpdMai) |
| WK-SSP0060-0634 | E1 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0635 | E4 | CHANGE_REASON_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0636 | E4 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 3 (D00-2b-004 ACT:SSP0060_ShipmentPlanConfi) |
| WK-SSP0060-0637 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0638 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0639 | E4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0640 | E4 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0641 | E4 | FROM_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_SITE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0642 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0643 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0644 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-022 D00-2b-026) |
| WK-SSP0060-0645 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-023 D00-2b-028) |
| WK-SSP0060-0646 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (D00-2b-022 D00-2b-026 ACT:SSP0060_Shipme) |
| WK-SSP0060-0647 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-2b-015~016 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0648 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-0649 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-2b-006~008 D00-2b-009~012 D00-4d-019) |
| WK-SSP0060-0650 | E4 | MSG00047 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00047 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0651 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0652 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-021 ACT:SSP0060_ShipmentPlan.Save) |
| WK-SSP0060-0653 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (D00-2b-006~008 D00-2b-009~012 ACT:SSP006) |
| WK-SSP0060-0654 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-025 ACT:SSP0060_ShipmentPlan.Save) |
| WK-SSP0060-0655 | E4 | MSG00170 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00170 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-018 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0656 | E4 | MSG00189 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00189 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-2b-002 ACT:SSP0060_ShipmentPlan.GetS) |
| WK-SSP0060-0657 | E4 | MSG00194 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00194 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0658 | E4 | MSG00197 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00197 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0659 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0660 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.checkValidN:355) |
| WK-SSP0060-0661 | E4 | MSG00225 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00225 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-021) |
| WK-SSP0060-0662 | E4 | MSG00247 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00247 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0663 | E4 | MSG00248 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00248 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.GetShipmentStat) |
| WK-SSP0060-0664 | E4 | MSG00249 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00249 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.GetShipmentStat) |
| WK-SSP0060-0665 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-017 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0666 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0060-0667 | E4 | MSG00275 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00275 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0668 | E4 | MSG00278 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00278 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-2b-003 ACT:SSP0060_ShipmentPlan.SpdD) |
| WK-SSP0060-0669 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (D00-2b-023 D00-2b-028 ACT:SSP0060_Shipme) |
| WK-SSP0060-0670 | E4 | MSG00285 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00285 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-2b-034~035 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0671 | E4 | MSG00286 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00286 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0672 | E4 | MSG00287 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00287 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-004 ACT:SSP0060_ShipmentPlan.SpdD) |
| WK-SSP0060-0673 | E4 | MSG00291 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00291 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0674 | E4 | MSG00292 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00292 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-059 ACT:SSP0060_ShipmentPlan.Simu) |
| WK-SSP0060-0675 | E4 | MSG00306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0676 | E4 | MSG00312 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00312 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-020 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0677 | E4 | MSG00313 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00313 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0060-0678 | E4 | MSG00324 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00324 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (D00-2b-027 ACT:SSP0060_ShipmentPlan.NewN) |
| WK-SSP0060-0679 | E4 | MSG00404 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00404 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0680 | E4 | MSG00424 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00424 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-019 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0681 | E4 | MSG00425 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00425 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-014 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0682 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-003) |
| WK-SSP0060-0683 | E4 | MSG00666 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00666 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-014) |
| WK-SSP0060-0684 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-0685 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0060-0686 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0060-0687 | E4 | MSG01185 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01185 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-2b-018 D00-2b-020 I06 R7b 이전 Plan) |
| WK-SSP0060-0688 | E4 | MSG01201 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01201 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-027) |
| WK-SSP0060-0689 | E4 | MSG01261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-017 I19 MSG 문구 역조회) |
| WK-SSP0060-0690 | E4 | MSG01274 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01274 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-019) |
| WK-SSP0060-0691 | E4 | MSG01289 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01289 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-034~035) |
| WK-SSP0060-0692 | E4 | MSG01291 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01291 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2b-004) |
| WK-SSP0060-0693 | E4 | MSG01295 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01295 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-059 D00-3-033) |
| WK-SSP0060-0694 | E4 | MSG01401 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01401 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-2b-002 D00-4d-004) |
| WK-SSP0060-0695 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0696 | E4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0697 | E4 | TO_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_SITE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0698 | E4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0699 | E4 | TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0700 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0701 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0702 | E4 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0703 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 1 (ACT:SSP0060_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0060-0704 | E4 | chkSum / Sum(Week) / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 3 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0705 | E4 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 2 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0706 | E4 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지 |  | 3 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0707 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0060_ShipmentPlan.FindData_Main:5) |
| WK-SSP0060-0708 | E4 | txtAppDeptName / Dept Name / App Dept Na | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) →  |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0709 | E4 | txtApproval / Approval | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtApproval / Approval · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0710 | E4 | txtReasonDetail / Reason Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReasonDetail / Reason Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0711 | E4 | txtRequestDeptName / Company / Request D | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestDeptName / Company / Request Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청  |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0712 | E4 | txtRequestNo / Request No | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestNo / Request No · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0713 | E4 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0714 | A10 | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 416 (ACT:SSP0060_ShipmentPlan.DefineProperty ) |
| WK-SSP0060-0715 | A6 | DM0003_GET_BUCKET_TYPE_CODE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (D00-4-017) |
| WK-SSP0060-0716 | A6 | PKG_COM0000 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (D00-4-028) |
| WK-SSP0060-0717 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 583 (D00-4-028 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0718 | A6 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (D00-4-030) |
| WK-SSP0060-0719 | A6 | PKG_SSP0020.P_USER_CHECK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-0720 | A6 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0721 | A6 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0722 | A6 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0723 | A6 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0724 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVIS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 1 (D00-4-001) |
| WK-SSP0060-0725 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 72 (D00-4-018 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0726 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 97 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0727 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0728 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-0729 | A6 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE  |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0730 | A6 | PKG_SSP0300 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0300 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (D00-4e-004) |
| WK-SSP0060-0731 | A6 | P_SSP0060_GET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SSP0060_GET_CALENDAR · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (D00-4-028) |
| WK-SSP0060-0732 | A6 | P_SSP0300_GET_ORDER_DETAIL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SSP0300_GET_ORDER_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 1 (D00-4e-004) |
| WK-SSP0060-0733 | A6 | P_TYPE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_TYPE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (D00-4-022~023) |
| WK-SSP0060-0734 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 26 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0735 | G1 | clbCompany_ID / Company / Company_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 22 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0736 | G1 | clbDivision_ID / Division / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 18 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0737 | G1 | clbPlantSite / From Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 18 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0738 | G1 | clbProductLevel11 / Product Level1 / Pro | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbProductLevel11 / Product Level1 / Product Level · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_Main A) |
| WK-SSP0060-0739 | G1 | clbProductLevel12 / Product Level1 / Pro | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbProductLevel12 / Product Level1 / Product Level · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 16 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0740 | G1 | clbResultType / Result Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbResultType / Result Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0060_ShipmentPlan.FindData_Shipme) |
| WK-SSP0060-0741 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Main A) |
| WK-SSP0060-0742 | G1 | drpPeriod2 / Shipment Date / Period2 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0743 | G1 | drpPeriod3 / Shipment Date / Period3 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Shipme) |
| WK-SSP0060-0744 | G1 | txtBoxID / Box ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtBoxID / Box ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-0745 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_Main A) |
| WK-SSP0060-0746 | G1 | txtModel2 / Model / Model2 / Model/Nickn | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 16 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0747 | G1 | txtRequestor / Requestor | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequestor / Requestor · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0748 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.DefineProperty ) |
| WK-SSP0060-0749 | G6 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0750 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:SSP0060_ShipmentPlan.InitControls AC) |
| WK-SSP0060-0751 | G6 | chkSum / Sum(Week) / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum(Week) / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0752 | G6 | chkTotPSI / Total PSI / Tot PSI | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkTotPSI / Total PSI / Tot PSI · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0753 | G6 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SSP0060_ShipmentPlan.Form_Load ACT:S) |
| WK-SSP0060-0754 | G6 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0755 | G6 | clbResultType / Result Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbResultType / Result Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitControls AC) |
| WK-SSP0060-0756 | G6 | drpPeriod2 / Shipment Date / Period2 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0757 | G6 | drpPeriod3 / Shipment Date / Period3 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.InitControls) |
| WK-SSP0060-0758 | X-REOPEN | SSP0060 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0060 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 69 (ACT:SSP0060_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0060-0759 | M3 | SSP0060_ShipmentPlanConfirmDetailPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SSP0060_ShipmentPlanConfirmDetailPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0760 | M3 | SSP0060_ShipmentPlanRequestPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SSP0060_ShipmentPlanRequestPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 34 (ACT:SSP0060_ShipmentPlanRequestPopup..ct) |
| WK-SSP0060-0761 | M3 | btnAutoSet | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnAutoSet · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0762 | M4 | BOH_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BOH_QTY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 25 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0763 | M4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0764 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0765 | M4 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (D00-2-018 MODAL:OrderDetailPopup ACT:SSP) |
| WK-SSP0060-0766 | M4 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 30 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0767 | M4 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0768 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 79 (D00-2-018 D00-3-015 ACT:SSP0060_Shipment) |
| WK-SSP0060-0769 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-3-015 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0770 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 47 (D00-2-018 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0771 | M4 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0772 | M4 | REMARKS2 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — REMARKS2 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0773 | M4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0774 | M4 | SSP0060_ShipmentPlanRequestPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SSP0060_ShipmentPlanRequestPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0775 | M4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0776 | M4 | btnId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-4e-004) |
| WK-SSP0060-0777 | M4 | btnItemID2 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemID2 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-003) |
| WK-SSP0060-0778 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-004) |

## W7 기대값 확정 (615)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0779 | C1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-008: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-008) |
| WK-SSP0060-0780 | C1 | D00-2-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-009: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-009) |
| WK-SSP0060-0781 | C1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-011: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SSP0060-0782 | C1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-012: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SSP0060-0783 | C1 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-013: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0060-0784 | C1 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-014: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0060-0785 | C1 | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — I8: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (I8) |
| WK-SSP0060-0786 | C2 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-020: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-0787 | C2 | D00-2-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-025: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-025) |
| WK-SSP0060-0788 | C2 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-011: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SSP0060-0789 | C2 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-019: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SSP0060-0790 | C2 | D00-4d-001~002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-001~002: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0791 | C2 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0792 | C2 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0793 | C2 | SSP0060_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0794 | C2 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0795 | C2 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0796 | C2 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0797 | C2 | SSP0060_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0798 | C2 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0799 | C3 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-020: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-0800 | C3 | D00-2-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-025: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-025) |
| WK-SSP0060-0801 | C3 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-011: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SSP0060-0802 | C3 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-019: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SSP0060-0803 | C3 | D00-4d-001~002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-001~002: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0804 | C3 | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — I22: 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (I22) |
| WK-SSP0060-0805 | C3 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0806 | C3 | SSP0060_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetChangeControl: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlan.SetChangeContro) |
| WK-SSP0060-0807 | C3 | SSP0060_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetChangedControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0808 | C3 | SSP0060_ShipmentPlan.SetEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetEndCustomer: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0809 | C3 | SSP0060_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetLockSumColumn: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.SetLockSumColum) |
| WK-SSP0060-0810 | C3 | SSP0060_ShipmentPlan.SetNote_Display | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetNote_Display: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0811 | C3 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0812 | C3 | SSP0060_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.Set_SumValues: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SSP0060_ShipmentPlan.Set_SumValues:5) |
| WK-SSP0060-0813 | C3 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0814 | C3 | SSP0060_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0815 | C3 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0816 | C3 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0817 | C3 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0818 | C3 | SSP0060_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0819 | C3 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0820 | C4 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-008: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-008) |
| WK-SSP0060-0821 | C4 | D00-2-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-009: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-009) |
| WK-SSP0060-0822 | C4 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-011: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SSP0060-0823 | C4 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-012: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SSP0060-0824 | C4 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-013: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0060-0825 | C4 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-014: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0060-0826 | C4 | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — I8: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (I8) |
| WK-SSP0060-0827 | C6 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-020: 행 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-0828 | C6 | D00-2-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-025: 행 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-025) |
| WK-SSP0060-0829 | C6 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-011: 행 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SSP0060-0830 | C6 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-019: 행 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SSP0060-0831 | C6 | D00-4d-001~002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-001~002: 행 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0832 | C6 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0833 | C6 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0834 | C6 | SSP0060_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0835 | C6 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0836 | C6 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0837 | C6 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0838 | C6 | SSP0060_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0839 | C6 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0840 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0841 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0842 | B3 | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — I8: 행 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 1 (I8) |
| WK-SSP0060-0843 | B3 | SSP0060_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetBucketType: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.GetBucketType:5) |
| WK-SSP0060-0844 | B3 | SSP0060_ShipmentPlan.GetERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetERPInterface: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0845 | B3 | SSP0060_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheck: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0846 | B3 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0847 | B3 | SSP0060_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0848 | B3 | SSP0060_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt:4) |
| WK-SSP0060-0849 | B3 | SSP0060_ShipmentPlan.GetFilteredDs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetFilteredDs: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.GetFilteredDs:5) |
| WK-SSP0060-0850 | B3 | SSP0060_ShipmentPlan.GetNERPCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetNERPCode: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0851 | B3 | SSP0060_ShipmentPlan.GetNewERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetNewERPInterface: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0852 | B3 | SSP0060_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetSSPUserCheck: 진입점 집계 — B3 19요소: TODO:19 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-0853 | B3 | SSP0060_ShipmentPlan.GetShipmentStatusCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetShipmentStatusChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0060_ShipmentPlan.GetShipmentStat) |
| WK-SSP0060-0854 | B3 | SSP0060_ShipmentPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0060_ShipmentPlan.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0060-0855 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0856 | B4 | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — I8: 행 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 1 (I8) |
| WK-SSP0060-0857 | B4 | SSP0060_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetBucketType: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.GetBucketType:5) |
| WK-SSP0060-0858 | B4 | SSP0060_ShipmentPlan.GetERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetERPInterface: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0859 | B4 | SSP0060_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheck: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0860 | B4 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0861 | B4 | SSP0060_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0862 | B4 | SSP0060_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt:4) |
| WK-SSP0060-0863 | B4 | SSP0060_ShipmentPlan.GetFilteredDs | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetFilteredDs: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.GetFilteredDs:5) |
| WK-SSP0060-0864 | B4 | SSP0060_ShipmentPlan.GetNERPCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetNERPCode: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0865 | B4 | SSP0060_ShipmentPlan.GetNewERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetNewERPInterface: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0866 | B4 | SSP0060_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetSSPUserCheck: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-0867 | B4 | SSP0060_ShipmentPlan.GetShipmentStatusCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetShipmentStatusChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0060_ShipmentPlan.GetShipmentStat) |
| WK-SSP0060-0868 | B4 | SSP0060_ShipmentPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0060_ShipmentPlan.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0060-0869 | DB-SYN | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:SEARCH: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0870 | DB-SYN | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-002: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0060-0871 | DB-SYN | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-003: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0060-0872 | DB-SYN | D00-4a-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-004: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-004) |
| WK-SSP0060-0873 | DB-SYN | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-005: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-005) |
| WK-SSP0060-0874 | DB-SYN | D00-4a-006~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-006~036: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0875 | DB-SYN | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — I2: 행 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (I2) |
| WK-SSP0060-0876 | DB-SYN | SSP0060_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0060_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0060-0877 | DB-SYN | SSP0060_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0878 | DB-SYN | SSP0060_ShipmentPlanRequestPopup.ChkConf | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.ChkConfirmChangeT: 진입점 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0879 | DB-SYN | SSP0060_ShipmentPlanRequestPopup.GetErpI | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetErpIFCheckNew: 진입점 집계 — DB-SYN 32요소: PASS:19 · NOPATH:13 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0880 | F4 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:SEARCH: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0881 | F4 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-002: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0060-0882 | F4 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-003: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0060-0883 | F4 | D00-4a-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-004: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-004) |
| WK-SSP0060-0884 | F4 | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-005: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-005) |
| WK-SSP0060-0885 | F4 | D00-4a-006~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-006~036: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0886 | F4 | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — I2: 행 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (I2) |
| WK-SSP0060-0887 | F4 | SSP0060_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0060-0888 | F4 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0889 | F4 | SSP0060_ShipmentPlanRequestPopup.ChkConf | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.ChkConfirmChangeT: 진입점 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0890 | F4 | SSP0060_ShipmentPlanRequestPopup.GetErpI | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetErpIFCheckNew: 진입점 집계 — F4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0891 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0892 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0893 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0894 | A5 | D00-1-054 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-054: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-054) |
| WK-SSP0060-0895 | A5 | D00-1-057 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-057: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-057) |
| WK-SSP0060-0896 | A5 | D00-2b-015~016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2b-015~016: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0897 | A5 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-029: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SSP0060-0898 | A5 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4a-003: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0060-0899 | A5 | I14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — I14: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (I14) |
| WK-SSP0060-0900 | A5 | I16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — I16: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (I16) |
| WK-SSP0060-0901 | A5 | I16 Measure 시트변형 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — I16 Measure 시트변형: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0902 | A5 | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — I9: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (I9) |
| WK-SSP0060-0903 | A5 | SSP0060_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0060_ShipmentPlan.CreateSpread: 진입점 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0904 | A5 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0905 | A5 | 메타 SQL 3종(18/19/20) 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 메타 SQL 3종(18/19/20) 적용: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0906 | A5 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0907 | A5 | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 음수 = 빨간 글자: 행 집계 — A5 54요소: NOT_RUN:54 (미실행 요소가 남아 판정필요) |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0908 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0060-0909 | G4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4e-001: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-0910 | G4 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4e-008: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-0911 | H2 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0912 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0913 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0914 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0915 | H5 | D00-1-054 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-054: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-054) |
| WK-SSP0060-0916 | H5 | D00-1-057 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-057: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-057) |
| WK-SSP0060-0917 | H5 | D00-2b-015~016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2b-015~016: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0918 | H5 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-029: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SSP0060-0919 | H5 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4a-003: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0060-0920 | H5 | I14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — I14: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (I14) |
| WK-SSP0060-0921 | H5 | I16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — I16: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (I16) |
| WK-SSP0060-0922 | H5 | I16 Measure 시트변형 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — I16 Measure 시트변형: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0923 | H5 | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — I9: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (I9) |
| WK-SSP0060-0924 | H5 | SSP0060_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0060_ShipmentPlan.CreateSpread: 진입점 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0925 | H5 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0926 | H5 | 메타 SQL 3종(18/19/20) 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 메타 SQL 3종(18/19/20) 적용: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0927 | H5 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0928 | H5 | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 음수 = 빨간 글자: 행 집계 — H5 55요소: NOT_RUN:55 (미실행 요소가 남아 판정필요) |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0929 | X-REASON | BOH FIGURE 더블클릭 드릴 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BOH FIGURE 더블클릭 드릴 해당없음 `FIGURE` 0 hit — SSP0060 은 `BOH_TYPE`(7 hit) 체계다 |  | 1 (BOH FIGURE 더블클릭 드릴) |
| WK-SSP0060-0930 | X-REASON | D00-2-023 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-023 SpdDetail_TopChange  [WINFORMS] 스크롤 병합 재적용 — 공용 CustomMergeManager 자동 해당없음 |  | 1 (D00-2-023) |
| WK-SSP0060-0931 | X-REASON | D00-2-027 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-027 spdMain_KeyDown  [WINFORMS] FarPoint InputMap 커스텀 — Wijmo 기본 키맵 등가 해당없음 |  | 1 (D00-2-027) |
| WK-SSP0060-0932 | X-REASON | D00-2-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-028 spdMain_KeyUp  [WINFORMS] 동상 해당없음 |  | 1 (D00-2-028) |
| WK-SSP0060-0933 | X-REASON | D00-2-029 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-029 SpdMain_TopChange  [WINFORMS] SmartColMerge 재적용 — 공용 병합 매니저 자동 해당없음 |  | 1 (D00-2-029) |
| WK-SSP0060-0934 | X-REASON | D00-2b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-005 MSG00047 dr null 가드  React Query 미도착 = 빈 그리드, null 역참조 경로 없음 해당없음 |  | 1 (D00-2b-005) |
| WK-SSP0060-0935 | X-REASON | D00-2b-029~030 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-029~030 HoldStock 저장 반환 2종 handleSave holdStock 안내 alert HoldStock 저장 SP 미존재(TO-BE/AS-IS 실측) — convert-s |  | 1 (D00-2b-029~030) |
| WK-SSP0060-0936 | X-REASON | D00-2b-031~033 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-031~033 MSG00219/267/194 ERP 차단·정합  [SP-CHAIN] 제외 |  | 1 (D00-2b-031~033) |
| WK-SSP0060-0937 | X-REASON | D00-2b-036~057 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-036~057 ERP Drafting 체인 메시지 22종(MSG00247/049/404/197/204/324/284/248/249/189/306 등)  [SP-CHAIN] NonSoNo/ |  | 1 (D00-2b-036~057) |
| WK-SSP0060-0938 | X-REASON | D00-2b-058 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-058 MSG00313 PlanDate 최신 불일치  콤보 캐시(staleTime 0)와 서버 재대조 배선 보류 — 04 확인필요(MSG01315 예약) 제외 |  | 1 (D00-2b-058) |
| WK-SSP0060-0939 | X-REASON | D00-3-005~007 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-005~007 Footer Sum/포맷/배경색  Footer 합계는 AS-IS Detail 전용 표시 — 공용 DataGrid 미배선, 04 확인필요 제외 |  | 1 (D00-3-005~007) |
| WK-SSP0060-0940 | X-REASON | D00-3-018 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-018 헤더 체크박스 전체선택 토글  대상 컬럼(CHECK_NEED_YN 추정) 메타 미배선 — 04 확인필요 제외 |  | 1 (D00-3-018) |
| WK-SSP0060-0941 | X-REASON | D00-3-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-021 SmartColMerge 재적용 공용 병합 매니저 자동 공용 DataGrid 병합 매니저가 자동 재적용 — 화면 코드 불요 해당없음 |  | 1 (D00-3-021) |
| WK-SSP0060-0942 | X-REASON | D00-3-024 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-024 저장 실패 셀 InvalidColor  Main 저장 음수는 저장 전 차단(MSG00225)이라 실패색 경로 미발생 — 셀 단위 표기는 04 확인필요 제외 |  | 1 (D00-3-024) |
| WK-SSP0060-0943 | X-REASON | D00-3-025 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-025 GetViewRowFromModelRow  Wijmo collectionView 인덱스 공용 처리 해당없음 |  | 1 (D00-3-025) |
| WK-SSP0060-0944 | X-REASON | D00-3-030 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-030 조회 후 액티브셀 지정  UX 배관 — Wijmo 기본 포커스 해당없음 |  | 1 (D00-3-030) |
| WK-SSP0060-0945 | X-REASON | D00-3-032 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-032 StickyNote 셀 메모 유지  AS-IS EDIT_YN 노트 표시 — TO-BE wide 커서에 EDIT_YN 부재(실측), 04 확인필요 제외 |  | 1 (D00-3-032) |
| WK-SSP0060-0946 | X-REASON | D00-4-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-004 SSP0060_SAVE_HOLD_STOCK_DATA handleSave holdStock 안내 SP 미존재(TO-BE/AS-IS 실측) — convert-sp 후속. API/BTN  |  | 1 (D00-4-004) |
| WK-SSP0060-0947 | X-REASON | D00-4-005~016 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-005~016 ERP Drafting 하위 SP 12종(§4 #5~16)  [SP-CHAIN] 제외 |  | 1 (D00-4-005~016) |
| WK-SSP0060-0948 | X-REASON | D00-4-029 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-029 SCM_SSP_CHECK_CONFIRM_CHANGETIME  [SP-CHAIN] 동시편집 검증 — Confirm 저장 SP 내부 처리 여부 convert-sp 확인 제외 |  | 1 (D00-4-029) |
| WK-SSP0060-0949 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 SSPBlockCheckIF  [SP-CHAIN] ERP 차단 플래그 — Drafting 경로 전용 제외 |  | 1 (D00-4b-005) |
| WK-SSP0060-0950 | X-REASON | D00-4b-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-006 Plan_Infor(검증용 Tmp)  MSG00313 대조 경로 보류(D00-2b-058) 제외 |  | 1 (D00-4b-006) |
| WK-SSP0060-0951 | X-REASON | D00-4b-008 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-008 ShipmentPlanToSite  Detail TO_SITE 셀콤보용 — 컬럼 메타 배선 축(PARAM 등재)은 [META-GAP] 계열, 04 확인필요 제외 |  | 1 (D00-4b-008) |
| WK-SSP0060-0952 | X-REASON | D00-4b-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-012 EndCustomerByItemForSSP  [META-GAP] 콤보 SQL `EndCustomerByItemForSSP_SCP` 는 등록됨 — 컬럼메타 CTRL/CMBO/A2 미 |  | 1 (D00-4b-012) |
| WK-SSP0060-0953 | X-REASON | I07 Plan Date Packer | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I07 Plan Date Packer 해당없음 `PlanDateShip` 0 hit / `Packer` 0 hit |  | 1 (I07 Plan Date Packer) |
| WK-SSP0060-0954 | X-REASON | I08 GetDayRange offset31 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I08 GetDayRange offset31 해당없음 SSP0060 에 `GetDayRange("A"/"P")` 부재. drpPeriod/2 는 ControlClear L557~560 **공백**,  |  | 1 (I08 GetDayRange offset31) |
| WK-SSP0060-0955 | X-REASON | I10 PACKER_PAST | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I10 PACKER_PAST 해당없음 `Packer` 0 / `_PAST` 0 hit |  | 1 (I10 PACKER_PAST) |
| WK-SSP0060-0956 | X-REASON | I13 Comments(sticky) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I13 Comments(sticky) 해당없음 `CommentsPopup` 0 hit |  | 1 (I13 Comments(sticky)) |
| WK-SSP0060-0957 | X-REASON | I14 PROD_DATE/LOT 셀타입 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I14 PROD_DATE/LOT 셀타입 해당없음 `SetCellTypeDateToText` 0 hit |  | 1 (I14 PROD_DATE/LOT 셀타입) |
| WK-SSP0060-0958 | X-REASON | I15 USER_MOD Blue | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I15 USER_MOD Blue 해당없음 `USER_MOD` 0 hit |  | 1 (I15 USER_MOD Blue) |
| WK-SSP0060-0959 | X-REASON | I17 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I17 EDIT_YN 셀 노트(StickyNote) 미배선 — wide 커서에 EDIT_YN 부재(실측) SP 확장(convert-sp) 또는 미이관 확정 — SP/사용자 축 제외 |  | 1 (I17) |
| WK-SSP0060-0960 | X-REASON | I18 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I18 HoldStock 탭 상시 노출 정책 상시 노출 재현 AS-IS 런타임 거동 확인 필요 — 사용자 축 제외 |  | 1 (I18) |
| WK-SSP0060-0961 | X-REASON | I19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I19 토/일 DAY_CODE 실값 변경 없음 PROC_M 등재(convert-sp) 후 call-proc 실행값 확인 — SP 축 제외 |  | 1 (I19) |
| WK-SSP0060-0962 | X-REASON | I20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I20 BtnItemID2_Click plantSite 전달(.cs L1031~1045) 공용 ItemByDivisionModal 계약(preSearchParams 에 plantSite 없음 — CO |  | 1 (I20) |
| WK-SSP0060-0963 | X-REASON | I21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I21 Confirm payload 키 ↔ PROC_M COL_NM 정합 변경 없음 convert-sp PROC_M 등재 시 확정 — SP 축 제외 |  | 1 (I21) |
| WK-SSP0060-0964 | X-REASON | I7 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I7 Form_Load FindString(sUserCompany_NM)(.cs L329~334) — 원천 SSP InnerTable MyCompanyID 첫 행 선택만 재현 TO-BE 세션(User |  | 1 (I7) |
| WK-SSP0060-0965 | X-REASON | Production 파란 노트 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Production 파란 노트 해당없음 `SetProdNote` 0 hit |  | 1 (Production 파란 노트) |
| WK-SSP0060-0966 | X-REASON | Production(PROD_PLAN)·PROD_DATE 표시 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Production(PROD_PLAN)·PROD_DATE 표시 해당없음 SSP0060 의 PROD_PLAN(L6925·7858·7914)·PROD_DATE(L6726)는 **주/월 합계 계산 규칙** |  | 1 (Production(PROD_PLAN)·PROD_DATE 표시) |
| WK-SSP0060-0967 | X-REASON | WH In Plan Detail 검색조건 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — WH In Plan Detail 검색조건 해당없음 해당 시트 자체가 없다(CreateSpread 6시트) |  | 1 (WH In Plan Detail 검색조건) |
| WK-SSP0060-0968 | X-REASON | WH_IN 기간셀 → Comments 팝업 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — WH_IN 기간셀 → Comments 팝업 해당없음 `WH_IN` 0 hit · `CommentsPopup` 0 hit |  | 1 (WH_IN 기간셀 → Comments 팝업) |
| WK-SSP0060-0969 | D1 | CRUD:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CRUD:EDIT: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:EDIT) |
| WK-SSP0060-0970 | D1 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-020: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-0971 | D1 | D00-2b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-002: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-002) |
| WK-SSP0060-0972 | D1 | D00-2b-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-014: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-014) |
| WK-SSP0060-0973 | D1 | D00-2b-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-017: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-017) |
| WK-SSP0060-0974 | D1 | D00-2b-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-018: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-018) |
| WK-SSP0060-0975 | D1 | D00-2b-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-019: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-019) |
| WK-SSP0060-0976 | D1 | D00-2b-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2b-020: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-020) |
| WK-SSP0060-0977 | D1 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-019: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SSP0060-0978 | D1 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-022: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SSP0060-0979 | D1 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-028: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-028) |
| WK-SSP0060-0980 | D1 | D00-3-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-033: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-033) |
| WK-SSP0060-0981 | D1 | D00-4a-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4a-001: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-001) |
| WK-SSP0060-0982 | D1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-004: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SSP0060-0983 | D1 | D00-4d-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-038: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-038) |
| WK-SSP0060-0984 | D1 | D00-4d-039~040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-039~040: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-039~040) |
| WK-SSP0060-0985 | D1 | D00-4d-041~042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-041~042: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-041~042) |
| WK-SSP0060-0986 | D1 | I1-delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — I1-delete: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I1-delete) |
| WK-SSP0060-0987 | D1 | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — I2: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I2) |
| WK-SSP0060-0988 | D1 | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — I22: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I22) |
| WK-SSP0060-0989 | D1 | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — I9: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I9) |
| WK-SSP0060-0990 | D1 | NEW-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — NEW-1: 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (NEW-1) |
| WK-SSP0060-0991 | D1 | SSP0060_ShipmentPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0060_ShipmentPlan.EditButton: 진입점 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 52 (ACT:SSP0060_ShipmentPlan.EditButton:2714) |
| WK-SSP0060-0992 | D1 | 편집 불가(하늘색 Rc) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 편집 불가(하늘색 Rc): 행 집계 — D1 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-0993 | D3 | CRUD:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CRUD:EDIT: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:EDIT) |
| WK-SSP0060-0994 | D3 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-020: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-0995 | D3 | D00-2b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-002: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-002) |
| WK-SSP0060-0996 | D3 | D00-2b-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-014: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-014) |
| WK-SSP0060-0997 | D3 | D00-2b-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-017: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-017) |
| WK-SSP0060-0998 | D3 | D00-2b-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-018: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-018) |
| WK-SSP0060-0999 | D3 | D00-2b-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-019: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-019) |
| WK-SSP0060-1000 | D3 | D00-2b-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2b-020: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-020) |
| WK-SSP0060-1001 | D3 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-019: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SSP0060-1002 | D3 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-022: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SSP0060-1003 | D3 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-028: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-028) |
| WK-SSP0060-1004 | D3 | D00-3-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-033: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-033) |
| WK-SSP0060-1005 | D3 | D00-4a-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4a-001: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-001) |
| WK-SSP0060-1006 | D3 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-004: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SSP0060-1007 | D3 | D00-4d-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-038: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-038) |
| WK-SSP0060-1008 | D3 | D00-4d-039~040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-039~040: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-039~040) |
| WK-SSP0060-1009 | D3 | D00-4d-041~042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-041~042: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-041~042) |
| WK-SSP0060-1010 | D3 | I1-delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — I1-delete: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I1-delete) |
| WK-SSP0060-1011 | D3 | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — I2: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I2) |
| WK-SSP0060-1012 | D3 | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — I22: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I22) |
| WK-SSP0060-1013 | D3 | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — I9: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (I9) |
| WK-SSP0060-1014 | D3 | NEW-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — NEW-1: 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (NEW-1) |
| WK-SSP0060-1015 | D3 | SSP0060_ShipmentPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0060_ShipmentPlan.EditButton: 진입점 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 52 (ACT:SSP0060_ShipmentPlan.EditButton:2714) |
| WK-SSP0060-1016 | D3 | 편집 불가(하늘색 Rc) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 편집 불가(하늘색 Rc): 행 집계 — D3 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-1017 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0060-1018 | D4 | CRUD:INSERT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CRUD:INSERT: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:INSERT) |
| WK-SSP0060-1019 | D4 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-022: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SSP0060-1020 | D4 | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-4a-005: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-005) |
| WK-SSP0060-1021 | D4 | I3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — I3: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (I3) |
| WK-SSP0060-1022 | D4 | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 음수 = 빨간 글자: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-1023 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 52요소: NOT_RUN:52 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0060-1024 | D5 | SSP0060_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0060_ShipmentPlan.CreateSpread: 진입점 집계 — D5 52요소: NOT_RUN:52 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-1025 | D5 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-1026 | E1 | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — I22: 행 집계 — E1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (I22) |
| WK-SSP0060-1027 | E1 | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 음수 = 빨간 글자: 행 집계 — E1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-1028 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SSP0060-1029 | E4 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-2-014: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0060-1030 | E4 | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4b-011: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-011) |
| WK-SSP0060-1031 | E4 | D00-4d-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-037: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-037) |
| WK-SSP0060-1032 | E4 | I04 저장 payload 오염 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — I04 저장 payload 오염: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (I04 저장 payload 오염) |
| WK-SSP0060-1033 | E4 | I16 Measure 시트변형 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — I16 Measure 시트변형: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-1034 | E4 | SSP0060_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetChangeControl: 진입점 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlan.SetChangeContro) |
| WK-SSP0060-1035 | E4 | SSP0060_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-1036 | E4 | SSP0060_ShipmentPlan.SetEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetEndCustomer: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-1037 | E4 | SSP0060_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetLockSumColumn: 진입점 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.SetLockSumColum) |
| WK-SSP0060-1038 | E4 | SSP0060_ShipmentPlan.SetNote_Display | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetNote_Display: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-1039 | E4 | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-1040 | E4 | SSP0060_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0060_ShipmentPlan.Set_SumValues: 진입점 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SSP0060_ShipmentPlan.Set_SumValues:5) |
| WK-SSP0060-1041 | E4 | type-check / lint / vitest | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — type-check / lint / vitest: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (type-check / lint / vitest) |
| WK-SSP0060-1042 | E4 | 메타 SQL 3종(18/19/20) 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 메타 SQL 3종(18/19/20) 적용: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-1043 | E4 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo: 행 집계 — E4 79요소: NOT_RUN:79 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-1044 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (COMMON:UC-02) |
| WK-SSP0060-1045 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (COMMON:UC-03) |
| WK-SSP0060-1046 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (COMMON:UC-06) |
| WK-SSP0060-1047 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-1048 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-1049 | A1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-003: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-1-003) |
| WK-SSP0060-1050 | A1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-004: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-1-004) |
| WK-SSP0060-1051 | A1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-007: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-1-007) |
| WK-SSP0060-1052 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-1-008) |
| WK-SSP0060-1053 | A1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-004: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-2-004) |
| WK-SSP0060-1054 | A1 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-006: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-2-006) |
| WK-SSP0060-1055 | A1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-011: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-2-011) |
| WK-SSP0060-1056 | A1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-012: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-2-012) |
| WK-SSP0060-1057 | A1 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-020: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-2-020) |
| WK-SSP0060-1058 | A1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-014: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-3-014) |
| WK-SSP0060-1059 | A1 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-028: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-3-028) |
| WK-SSP0060-1060 | A1 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-029: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-3-029) |
| WK-SSP0060-1061 | A1 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-002: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4a-002) |
| WK-SSP0060-1062 | A1 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-003: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4a-003) |
| WK-SSP0060-1063 | A1 | D00-4a-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-004: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4a-004) |
| WK-SSP0060-1064 | A1 | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-005: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4a-005) |
| WK-SSP0060-1065 | A1 | D00-4a-006~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-006~036: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4a-006~036) |
| WK-SSP0060-1066 | A1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-001: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4e-001) |
| WK-SSP0060-1067 | A1 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-008: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (D00-4e-008) |
| WK-SSP0060-1068 | A1 | DM0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE: 골든 비교 케이스 없음(DM0003_GET_BUCKET_TYPE_CODE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (D00-4-017) |
| WK-SSP0060-1069 | A1 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — I10: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (I10) |
| WK-SSP0060-1070 | A1 | I19 MSG 문구 역조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — I19 MSG 문구 역조회: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-1071 | A1 | PKG_COM0000 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000: 골든 비교 케이스 없음(PKG_COM0000 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-028) |
| WK-SSP0060-1072 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 583 (D00-4-028 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-1073 | A1 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: 골든 비교 케이스 없음(PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST — 팝업·보조 SP 는 golden_ca |  | 1 (D00-4-030) |
| WK-SSP0060-1074 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-1075 | A1 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK — 팝업·보조 SP 는 golden_cases.csv  |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1076 | A1 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_MES_STOCK — 팝업·보조 SP 는 golden_cases.csv 에  |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1077 | A1 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL — 팝업·보조 SP 는 golde |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1078 | A1 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL — 팝업·보조 SP 는 golden_cases.cs |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1079 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION — 팝업·보조 SP 는 gol |  | 1 (D00-4-001) |
| WK-SSP0060-1080 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN — 팝업·보조 SP 는 golden_case |  | 72 (D00-4-018 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-1081 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL — 팝업·보조 SP |  | 97 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1082 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DR |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1083 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT — 팝업·보조 SP 는 golden_ |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-1084 | A1 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL — 팝업·보조  |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-1085 | A1 | PKG_SSP0300 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0300: 골든 비교 케이스 없음(PKG_SSP0300 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4e-004) |
| WK-SSP0060-1086 | A1 | P_SSP0060_GET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0060_GET_CALENDAR: 골든 비교 케이스 없음(P_SSP0060_GET_CALENDAR — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-028) |
| WK-SSP0060-1087 | A1 | P_SSP0300_GET_ORDER_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0300_GET_ORDER_DETAIL: 골든 비교 케이스 없음(P_SSP0300_GET_ORDER_DETAIL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (D00-4e-004) |
| WK-SSP0060-1088 | A1 | P_TYPE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TYPE: 골든 비교 케이스 없음(P_TYPE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-022~023) |
| WK-SSP0060-1089 | A6 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:SEARCH: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-1090 | A6 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-002: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0060-1091 | A6 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-003: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SSP0060-1092 | A6 | D00-4a-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-004: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-004) |
| WK-SSP0060-1093 | A6 | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-005: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-005) |
| WK-SSP0060-1094 | A6 | D00-4a-006~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-006~036: 행 집계 — A6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-006~036) |
| WK-SSP0060-1095 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0060-1096 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0060-1097 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0060-1098 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0060-1099 | G1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:SEARCH: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-1100 | G1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-003: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SSP0060-1101 | G1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-004: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SSP0060-1102 | G1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-007: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-007) |
| WK-SSP0060-1103 | G1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-008: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SSP0060-1104 | G1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-004: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SSP0060-1105 | G1 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-006: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SSP0060-1106 | G1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-011: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SSP0060-1107 | G1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-012: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SSP0060-1108 | G1 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-020: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-020) |
| WK-SSP0060-1109 | G1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-014: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SSP0060-1110 | G1 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-028: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-028) |
| WK-SSP0060-1111 | G1 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-029: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SSP0060-1112 | G1 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4a-002: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0060-1113 | G1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4e-001: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-1114 | G1 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4e-008: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-1115 | G1 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — I10: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (I10) |
| WK-SSP0060-1116 | G1 | I19 MSG 문구 역조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — I19 MSG 문구 역조회: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-1117 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0060-1118 | G6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4e-001: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-1119 | G6 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4e-008: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-1120 | X-LOC | AS-IS `LGCE_SCMDEV`(asis.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS `LGCE_SCMDEV`(asis.py): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS `LGCE_SCMDEV`(asis.py)) |
| WK-SSP0060-1121 | X-LOC | I02 ERP IF 연쇄 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I02 ERP IF 연쇄: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I02 ERP IF 연쇄) |
| WK-SSP0060-1122 | X-LOC | I04 TransMode EE 치환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I04 TransMode EE 치환: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I04 TransMode EE 치환) |
| WK-SSP0060-1123 | X-LOC | I04 저장 payload 오염 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I04 저장 payload 오염: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I04 저장 payload 오염) |
| WK-SSP0060-1124 | X-LOC | I06 R7a GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I06 R7a GetSSPUserCheck: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I06 R7a GetSSPUserCheck) |
| WK-SSP0060-1125 | X-LOC | I1-delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I1-delete: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I1-delete) |
| WK-SSP0060-1126 | X-LOC | I1-paste | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I1-paste: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I1-paste) |
| WK-SSP0060-1127 | X-LOC | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I10) |
| WK-SSP0060-1128 | X-LOC | I12 Requestor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I12 Requestor 팝업: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-1129 | X-LOC | I13 SSP0300 OrderDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I13 SSP0300 OrderDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I13 SSP0300 OrderDetail) |
| WK-SSP0060-1130 | X-LOC | I14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I14) |
| WK-SSP0060-1131 | X-LOC | I15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I15) |
| WK-SSP0060-1132 | X-LOC | I15 음수 InvalidColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I15 음수 InvalidColor: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I15 음수 InvalidColor) |
| WK-SSP0060-1133 | X-LOC | I16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I16) |
| WK-SSP0060-1134 | X-LOC | I16 Measure 시트변형 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I16 Measure 시트변형: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-1135 | X-LOC | I19 MSG 문구 역조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I19 MSG 문구 역조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-1136 | X-LOC | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I2) |
| WK-SSP0060-1137 | X-LOC | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I22) |
| WK-SSP0060-1138 | X-LOC | I3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I3) |
| WK-SSP0060-1139 | X-LOC | I4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I4) |
| WK-SSP0060-1140 | X-LOC | I5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I5) |
| WK-SSP0060-1141 | X-LOC | I6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I6) |
| WK-SSP0060-1142 | X-LOC | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I8) |
| WK-SSP0060-1143 | X-LOC | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I9) |
| WK-SSP0060-1144 | X-LOC | Model(ITEM_ID) 그룹 경계 검정 실선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Model(ITEM_ID) 그룹 경계 검정 실선: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Model(ITEM_ID) 그룹 경계 검정 실선) |
| WK-SSP0060-1145 | X-LOC | NEW-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — NEW-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (NEW-1) |
| WK-SSP0060-1146 | X-LOC | TO-BE `ZIOUI1`(ora.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TO-BE `ZIOUI1`(ora.py): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TO-BE `ZIOUI1`(ora.py)) |
| WK-SSP0060-1147 | X-LOC | type-check / lint / vitest | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — type-check / lint / vitest: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (type-check / lint / vitest) |
| WK-SSP0060-1148 | X-LOC | 메타 SQL 3종(18/19/20) 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메타 SQL 3종(18/19/20) 적용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-1149 | X-LOC | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-1150 | X-LOC | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 음수 = 빨간 글자: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-1151 | X-LOC | 편집 가능 일자(노랑) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 편집 가능 일자(노랑): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (편집 가능 일자(노랑)) |
| WK-SSP0060-1152 | X-LOC | 편집 불가(하늘색 Rc) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 편집 불가(하늘색 Rc): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-1153 | X-LOC | 확정구간 스타일 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 확정구간 스타일: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (확정구간 스타일) |
| WK-SSP0060-1154 | X-ROW | AS-IS `LGCE_SCMDEV`(asis.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS-IS `LGCE_SCMDEV`(asis.py): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS-IS `LGCE_SCMDEV`(asis.py)) |
| WK-SSP0060-1155 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SSP0060-1156 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SSP0060-1157 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SSP0060-1158 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SSP0060-1159 | X-ROW | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-009) |
| WK-SSP0060-1160 | X-ROW | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-010) |
| WK-SSP0060-1161 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SSP0060-1162 | X-ROW | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-012) |
| WK-SSP0060-1163 | X-ROW | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-013) |
| WK-SSP0060-1164 | X-ROW | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-014) |
| WK-SSP0060-1165 | X-ROW | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-015: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-015) |
| WK-SSP0060-1166 | X-ROW | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-016) |
| WK-SSP0060-1167 | X-ROW | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-017: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-017) |
| WK-SSP0060-1168 | X-ROW | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-018: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-018) |
| WK-SSP0060-1169 | X-ROW | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-021: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-021) |
| WK-SSP0060-1170 | X-ROW | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-022) |
| WK-SSP0060-1171 | X-ROW | D00-1-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-023: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-023) |
| WK-SSP0060-1172 | X-ROW | D00-1-030~031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-030~031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-030~031) |
| WK-SSP0060-1173 | X-ROW | D00-1-032~046 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-032~046: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-032~046) |
| WK-SSP0060-1174 | X-ROW | D00-1-047 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-047: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-047) |
| WK-SSP0060-1175 | X-ROW | D00-1-048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-048: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-048) |
| WK-SSP0060-1176 | X-ROW | D00-1-049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-049: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-049) |
| WK-SSP0060-1177 | X-ROW | D00-1-050~051 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-050~051: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-050~051) |
| WK-SSP0060-1178 | X-ROW | D00-1-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-052: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-052) |
| WK-SSP0060-1179 | X-ROW | D00-1-053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-053: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-053) |
| WK-SSP0060-1180 | X-ROW | D00-1-055 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-055: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-055) |
| WK-SSP0060-1181 | X-ROW | D00-1-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-056: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-056) |
| WK-SSP0060-1182 | X-ROW | D00-1-058 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-058: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-058) |
| WK-SSP0060-1183 | X-ROW | D00-1-059 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-059: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-059) |
| WK-SSP0060-1184 | X-ROW | D00-1-060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-060: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-060) |
| WK-SSP0060-1185 | X-ROW | D00-1-061 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-061: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-061) |
| WK-SSP0060-1186 | X-ROW | D00-1-062 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-062: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-062) |
| WK-SSP0060-1187 | X-ROW | D00-1-065~066 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-065~066: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-065~066) |
| WK-SSP0060-1188 | X-ROW | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-001) |
| WK-SSP0060-1189 | X-ROW | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-002) |
| WK-SSP0060-1190 | X-ROW | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-003) |
| WK-SSP0060-1191 | X-ROW | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-005) |
| WK-SSP0060-1192 | X-ROW | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-007) |
| WK-SSP0060-1193 | X-ROW | D00-2-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-016) |
| WK-SSP0060-1194 | X-ROW | D00-2-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-017: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-017) |
| WK-SSP0060-1195 | X-ROW | D00-2-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-022) |
| WK-SSP0060-1196 | X-ROW | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-003) |
| WK-SSP0060-1197 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SSP0060-1198 | X-ROW | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-020: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-020) |
| WK-SSP0060-1199 | X-ROW | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-026: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-026) |
| WK-SSP0060-1200 | X-ROW | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-031) |
| WK-SSP0060-1201 | X-ROW | D00-3-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-034: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-034) |
| WK-SSP0060-1202 | X-ROW | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-001) |
| WK-SSP0060-1203 | X-ROW | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-007) |
| WK-SSP0060-1204 | X-ROW | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-009) |
| WK-SSP0060-1205 | X-ROW | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-010) |
| WK-SSP0060-1206 | X-ROW | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-003) |
| WK-SSP0060-1207 | X-ROW | D00-4d-010~013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-010~013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-010~013) |
| WK-SSP0060-1208 | X-ROW | D00-4d-033~034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-033~034: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-033~034) |
| WK-SSP0060-1209 | X-ROW | D00-4d-035~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-035~036: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-035~036) |
| WK-SSP0060-1210 | X-ROW | D00-4d-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-043: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-043) |
| WK-SSP0060-1211 | X-ROW | I02 ERP IF 연쇄 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I02 ERP IF 연쇄: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I02 ERP IF 연쇄) |
| WK-SSP0060-1212 | X-ROW | I04 TransMode EE 치환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I04 TransMode EE 치환: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I04 TransMode EE 치환) |
| WK-SSP0060-1213 | X-ROW | I06 R7a GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I06 R7a GetSSPUserCheck: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I06 R7a GetSSPUserCheck) |
| WK-SSP0060-1214 | X-ROW | I11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I11) |
| WK-SSP0060-1215 | X-ROW | I13 SSP0300 OrderDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I13 SSP0300 OrderDetail: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I13 SSP0300 OrderDetail) |
| WK-SSP0060-1216 | X-ROW | I15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I15) |
| WK-SSP0060-1217 | X-ROW | I15 음수 InvalidColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I15 음수 InvalidColor: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I15 음수 InvalidColor) |
| WK-SSP0060-1218 | X-ROW | I5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I5) |
| WK-SSP0060-1219 | X-ROW | I6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — I6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (I6) |
| WK-SSP0060-1220 | X-ROW | MODAL:ColumnSettingModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ColumnSettingModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ColumnSettingModal) |
| WK-SSP0060-1221 | X-ROW | MODAL:ConfirmDetailModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ConfirmDetailModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ConfirmDetailModal) |
| WK-SSP0060-1222 | X-ROW | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ItemByDivisionModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0060-1223 | X-ROW | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ProjectByDivisionModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SSP0060-1224 | X-ROW | MODAL:RequestorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:RequestorModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:RequestorModal) |
| WK-SSP0060-1225 | X-ROW | SSP0060_ShipmentPlan.BtnItemID2_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.BtnItemID2_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0060-1226 | X-ROW | SSP0060_ShipmentPlan.BtnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.BtnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0060-1227 | X-ROW | SSP0060_ShipmentPlan.BtnNew_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.BtnNew_Click: 진입점 집계 24검사 — NOT_RUN:15 · NOPATH:9 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-1228 | X-ROW | SSP0060_ShipmentPlan.BtnRequestor_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.BtnRequestor_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0060_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0060-1229 | X-ROW | SSP0060_ShipmentPlan.BtnSearch_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.BtnSearch_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlan.BtnSearch_Click) |
| WK-SSP0060-1230 | X-ROW | SSP0060_ShipmentPlan.CalcPlanQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.CalcPlanQty: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/GRID_SET/LOCAL/ |  | 163 (ACT:SSP0060_ShipmentPlan.CalcPlanQty ACT) |
| WK-SSP0060-1231 | X-ROW | SSP0060_ShipmentPlan.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소  |  | 104 (ACT:SSP0060_ShipmentPlan.CalculateSum AC) |
| WK-SSP0060-1232 | X-ROW | SSP0060_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0060-1233 | X-ROW | SSP0060_ShipmentPlan.ControlClear | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.ControlClear: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.ControlClear AC) |
| WK-SSP0060-1234 | X-ROW | SSP0060_ShipmentPlan.Convert_Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Convert_Requestor: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0060_ShipmentPlan.Convert_Request) |
| WK-SSP0060-1235 | X-ROW | SSP0060_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.CreateSpread) |
| WK-SSP0060-1236 | X-ROW | SSP0060_ShipmentPlan.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlan.DefineProperty:) |
| WK-SSP0060-1237 | X-ROW | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-1238 | X-ROW | SSP0060_ShipmentPlan.EditByChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.EditByChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 32 (ACT:SSP0060_ShipmentPlan.EditByChange AC) |
| WK-SSP0060-1239 | X-ROW | SSP0060_ShipmentPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0060_ShipmentPlan.FindButton) |
| WK-SSP0060-1240 | X-ROW | SSP0060_ShipmentPlan.FindData_Detail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_Detail: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-1241 | X-ROW | SSP0060_ShipmentPlan.FindData_MES_stock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_MES_stock: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-1242 | X-ROW | SSP0060_ShipmentPlan.FindData_MES_stock_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_MES_stock_Detail: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-1243 | X-ROW | SSP0060_ShipmentPlan.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_Main: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:2 |  | 8 (ACT:SSP0060_ShipmentPlan.FindData_Main:5) |
| WK-SSP0060-1244 | X-ROW | SSP0060_ShipmentPlan.FindData_Shipment_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_Shipment_Result: 진입점 집계 18검사 — NOT_RUN:14 · REVIEW:2 · PASS:2 |  | 11 (ACT:SSP0060_ShipmentPlan.FindData_Shipme) |
| WK-SSP0060-1245 | X-ROW | SSP0060_ShipmentPlan.FindData_Stock_Deta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_Stock_Detail: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Stock_) |
| WK-SSP0060-1246 | X-ROW | SSP0060_ShipmentPlan.FindData_hold_stock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_hold_stock: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 10 (ACT:SSP0060_ShipmentPlan.FindData_hold_s) |
| WK-SSP0060-1247 | X-ROW | SSP0060_ShipmentPlan.FindData_oWMS_Detai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.FindData_oWMS_Detail: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0060-1248 | X-ROW | SSP0060_ShipmentPlan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Form_Load: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.Form_Load:333:9) |
| WK-SSP0060-1249 | X-ROW | SSP0060_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetBucketType) |
| WK-SSP0060-1250 | X-ROW | SSP0060_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheck: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck) |
| WK-SSP0060-1251 | X-ROW | SSP0060_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-1252 | X-ROW | SSP0060_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-1253 | X-ROW | SSP0060_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt) |
| WK-SSP0060-1254 | X-ROW | SSP0060_ShipmentPlan.GetNERPCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetNERPCode: 진입점 집계 9검사 — NOPATH:4 · NOT_RUN:4 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode) |
| WK-SSP0060-1255 | X-ROW | SSP0060_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.GetSSPUserCheck: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-1256 | X-ROW | SSP0060_ShipmentPlan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InitControls: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0060_ShipmentPlan.InitControls:46) |
| WK-SSP0060-1257 | X-ROW | SSP0060_ShipmentPlan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InitSpread: 진입점 집계 45검사 — NOT_RUN:45 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-1258 | X-ROW | SSP0060_ShipmentPlan.InitSpreadDateColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InitSpreadDateColumn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlan.InitSpreadDateC) |
| WK-SSP0060-1259 | X-ROW | SSP0060_ShipmentPlan.InitSpreadFooterSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.InitSpreadFoote) |
| WK-SSP0060-1260 | X-ROW | SSP0060_ShipmentPlan.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.InsertButton) |
| WK-SSP0060-1261 | X-ROW | SSP0060_ShipmentPlan.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.InsertRow: 진입점 집계 21검사 — NOT_RUN:21 (미실행 검사가 남아 판정필요) |  | 123 (ACT:SSP0060_ShipmentPlan.InsertRow ACT:S) |
| WK-SSP0060-1262 | X-ROW | SSP0060_ShipmentPlan.Measure_SearchIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Measure_SearchIdx: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:SSP0060_ShipmentPlan.Measure_SearchI) |
| WK-SSP0060-1263 | X-ROW | SSP0060_ShipmentPlan.NewNonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.NewNonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 132 (ACT:SSP0060_ShipmentPlan.NewNonSoNo ACT:) |
| WK-SSP0060-1264 | X-ROW | SSP0060_ShipmentPlan.NonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.NonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 126 (ACT:SSP0060_ShipmentPlan.NonSoNo ACT:SSP) |
| WK-SSP0060-1265 | X-ROW | SSP0060_ShipmentPlan.Plan_Current_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Plan_Current_Check: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0060_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0060-1266 | X-ROW | SSP0060_ShipmentPlan.Re_Design | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Re_Design: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 64 (ACT:SSP0060_ShipmentPlan.Re_Design ACT:S) |
| WK-SSP0060-1267 | X-ROW | SSP0060_ShipmentPlan.SaveData_Detail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SaveData_Detail: 진입점 집계 23검사 — NOT_RUN:14 · PASS:5 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-1268 | X-ROW | SSP0060_ShipmentPlan.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SaveData_Main: 진입점 집계 16검사 — NOT_RUN:9 · NOPATH:4 · PASS:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0060_ShipmentPlan.SaveData_Main:2) |
| WK-SSP0060-1269 | X-ROW | SSP0060_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0060_ShipmentPlan.SetChangeContro) |
| WK-SSP0060-1270 | X-ROW | SSP0060_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetChangedControl: 진입점 집계 11검사 — NOT_RUN:8 · REVIEW:2 · PASS:1 |  | 3 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-1271 | X-ROW | SSP0060_ShipmentPlan.SetEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetEndCustomer: 진입점 집계 14검사 — NOT_RUN:9 · NOPATH:3 · REVIEW:2 |  | 3 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-1272 | X-ROW | SSP0060_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.SetLockSumColum) |
| WK-SSP0060-1273 | X-ROW | SSP0060_ShipmentPlan.SetNote_Display | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetNote_Display: 진입점 집계 18검사 — NOT_RUN:16 · REVIEW:2 |  | 4 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-1274 | X-ROW | SSP0060_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:6 |  | 7 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-1275 | X-ROW | SSP0060_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.Set_SumValues A) |
| WK-SSP0060-1276 | X-ROW | SSP0060_ShipmentPlan.ShipmentResult_GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.ShipmentResult_GetDayRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0060_ShipmentPlan.ShipmentResult_) |
| WK-SSP0060-1277 | X-ROW | SSP0060_ShipmentPlan.Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Simulation: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 195 (ACT:SSP0060_ShipmentPlan.Simulation ACT:) |
| WK-SSP0060-1278 | X-ROW | SSP0060_ShipmentPlan.SoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 141 (ACT:SSP0060_ShipmentPlan.SoNo ACT:SSP006) |
| WK-SSP0060-1279 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 67 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-1280 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_CellClick: 진입점 집계 12검사 — NOPATH:7 · NOT_RUN:4 · TODO:1 (미실행 검사가 남아 판정필요) |  | 58 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-1281 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_CellDoubleClick: 진입점 집계 31검사 — NOT_RUN:21 · NOPATH:10 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-1282 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ClipboardPasted: 진입점 집계 27검사 — NOT_RUN:27 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-1283 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_ComboSelChange: 진입점 집계 21검사 — NOT_RUN:21 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-1284 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_EditChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_EditChange: 진입점 집계 12검사 — NOT_RUN:10 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 50 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-1285 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_SheetTabC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된 요소 검사  |  | 15 (ACT:SSP0060_ShipmentPlan.SpdDetail_Sheet) |
| WK-SSP0060-1286 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0060-1287 | X-ROW | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-1288 | X-ROW | SSP0060_ShipmentPlan.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SSP0060_ShipmentPlan.SpdMain_Change ) |
| WK-SSP0060-1289 | X-ROW | SSP0060_ShipmentPlan.SpdMain_ClipboardPa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_ClipboardPasted: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0060-1290 | X-ROW | SSP0060_ShipmentPlan.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.SpdMain_TopChan) |
| WK-SSP0060-1291 | X-ROW | SSP0060_ShipmentPlan.Validation_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Validation_Check: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 106 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-1292 | X-ROW | SSP0060_ShipmentPlan.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.btnItemId_Click) |
| WK-SSP0060-1293 | X-ROW | SSP0060_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-1294 | X-ROW | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 4 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-1295 | X-ROW | SSP0060_ShipmentPlan.checkValidN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.checkValidN: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SSP0060_ShipmentPlan.checkValidN ACT) |
| WK-SSP0060-1296 | X-ROW | SSP0060_ShipmentPlan.chkERPIFBlockYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.chkERPIFBlockYn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0060_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0060-1297 | X-ROW | SSP0060_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-1298 | X-ROW | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-1299 | X-ROW | SSP0060_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 10검사 — NOT_RUN:9 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-1300 | X-ROW | SSP0060_ShipmentPlan.shtDetail_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.shtDetail_Change: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 71 (ACT:SSP0060_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0060-1301 | X-ROW | SSP0060_ShipmentPlan.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.spdMain_KeyUp: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SSP0060_ShipmentPlan.spdMain_KeyUp A) |
| WK-SSP0060-1302 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.. | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1303 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.CreateSprea: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1304 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.D | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.DefinePrope: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1305 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.D | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1306 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1307 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.FindDataMai: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 22 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1308 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1309 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.I | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.InitSpread: 진입점 집계 190검사 — NOT_RUN:190 (미실행 검사가 남아 판정필요) |  | 71 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1310 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.SetChangeRe: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1311 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.b | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanConfirmDetailPopup.btnButtonLi: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-1312 | X-ROW | SSP0060_ShipmentPlanRequestPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup..ct) |
| WK-SSP0060-1313 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CalcPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.CalcPlanQty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlanRequestPopup.Cal) |
| WK-SSP0060-1314 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkConf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.ChkConfirmChangeT: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-1315 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.ChkERPIFBlockYn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-1316 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkEngP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.ChkEngProcessing: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-1317 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CopyFro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.CopyFromAutoSet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 19 (ACT:SSP0060_ShipmentPlanRequestPopup.Cop) |
| WK-SSP0060-1318 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0060_ShipmentPlanRequestPopup.Cre) |
| WK-SSP0060-1319 | X-ROW | SSP0060_ShipmentPlanRequestPopup.DefineP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Def) |
| WK-SSP0060-1320 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Dis) |
| WK-SSP0060-1321 | X-ROW | SSP0060_ShipmentPlanRequestPopup.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.EditButton: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-1322 | X-ROW | SSP0060_ShipmentPlanRequestPopup.FindBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Fin) |
| WK-SSP0060-1323 | X-ROW | SSP0060_ShipmentPlanRequestPopup.FindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.FindData_Main: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 24 (ACT:SSP0060_ShipmentPlanRequestPopup.Fin) |
| WK-SSP0060-1324 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Form_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.For) |
| WK-SSP0060-1325 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetERPInterface: 진입점 집계 20검사 — NOT_RUN:10 · NOPATH:6 · TODO:4 (미실행 검사가 남아 판정필요) |  | 106 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-1326 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetErpIFCheck: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필 |  | 17 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-1327 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetErpIFCheckNew: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 111 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-1328 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetErpSoNoCnt: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-1329 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetShip | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.GetShipmentStatus: 진입점 집계 10검사 — NOT_RUN:7 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 31 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-1330 | X-ROW | SSP0060_ShipmentPlanRequestPopup.InitCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-1331 | X-ROW | SSP0060_ShipmentPlanRequestPopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.InitSpread: 진입점 집계 194검사 — NOT_RUN:194 (미실행 검사가 남아 판정필요) |  | 71 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-1332 | X-ROW | SSP0060_ShipmentPlanRequestPopup.NonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.NonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 111 (ACT:SSP0060_ShipmentPlanRequestPopup.Non) |
| WK-SSP0060-1333 | X-ROW | SSP0060_ShipmentPlanRequestPopup.RowSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.RowSave_Check: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.Row) |
| WK-SSP0060-1334 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SSP0060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.SSP0060_ShipmentP: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.SSP) |
| WK-SSP0060-1335 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SaveBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.SaveButton: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-1336 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.SaveData: 진입점 집계 18검사 — NOT_RUN:12 · NOPATH:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 177 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-1337 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.SoNo: 진입점 집계 7검사 — NOT_RUN:6 · PASS:1 (미실행 검사가 남아 판정필요) |  | 76 (ACT:SSP0060_ShipmentPlanRequestPopup.SoN) |
| WK-SSP0060-1338 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Validat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.Validation_Check: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Val) |
| WK-SSP0060-1339 | X-ROW | SSP0060_ShipmentPlanRequestPopup.btnAuto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.btnAutoSet_Click: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-1340 | X-ROW | SSP0060_ShipmentPlanRequestPopup.btnButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.btnButtonList_Usr: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-1341 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.spdMain_Change: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-1342 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.spdMain_Clipboard: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-1343 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.spdMain_KeyDown: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-1344 | X-ROW | SSP0060_ShipmentPlanRequestPopup.usrButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlanRequestPopup.usrButtonList1_Us: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.usr) |
| WK-SSP0060-1345 | X-ROW | TO-BE `ZIOUI1`(ora.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — TO-BE `ZIOUI1`(ora.py): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (TO-BE `ZIOUI1`(ora.py)) |
| WK-SSP0060-1346 | G5 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-024: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0060-1347 | G5 | D00-2b-006~008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2b-006~008: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-006~008) |
| WK-SSP0060-1348 | G5 | D00-2b-009~012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2b-009~012: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-009~012) |
| WK-SSP0060-1349 | G5 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-3-016: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-SSP0060-1350 | G5 | D00-4d-019~030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-019~030: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019~030) |
| WK-SSP0060-1351 | G5 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-001: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-1352 | G5 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-002: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0060-1353 | G5 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-003: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0060-1354 | G5 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-005: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SSP0060-1355 | G5 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-006: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SSP0060-1356 | G5 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-007: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SSP0060-1357 | G5 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-008: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-1358 | G5 | D00-4e-009~021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-009~021: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-009~021) |
| WK-SSP0060-1359 | G5 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — I10: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (I10) |
| WK-SSP0060-1360 | G5 | I12 Requestor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — I12 Requestor 팝업: 행 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-1361 | G5 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — G5 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-1362 | H6 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-024: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0060-1363 | H6 | D00-2b-006~008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2b-006~008: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-006~008) |
| WK-SSP0060-1364 | H6 | D00-2b-009~012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2b-009~012: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-009~012) |
| WK-SSP0060-1365 | H6 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-3-016: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-SSP0060-1366 | H6 | D00-4d-019~030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-019~030: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019~030) |
| WK-SSP0060-1367 | H6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-001: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-1368 | H6 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-002: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0060-1369 | H6 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-003: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0060-1370 | H6 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-005: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SSP0060-1371 | H6 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-006: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SSP0060-1372 | H6 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-007: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SSP0060-1373 | H6 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-008: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-1374 | H6 | D00-4e-009~021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-009~021: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-009~021) |
| WK-SSP0060-1375 | H6 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — I10: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (I10) |
| WK-SSP0060-1376 | H6 | I12 Requestor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — I12 Requestor 팝업: 행 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-1377 | H6 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — H6 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-1378 | M4 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-024: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0060-1379 | M4 | D00-2b-006~008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2b-006~008: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-006~008) |
| WK-SSP0060-1380 | M4 | D00-2b-009~012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2b-009~012: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-2b-009~012) |
| WK-SSP0060-1381 | M4 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-3-016: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-SSP0060-1382 | M4 | D00-4d-019~030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-019~030: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019~030) |
| WK-SSP0060-1383 | M4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-001: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SSP0060-1384 | M4 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-002: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0060-1385 | M4 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-003: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0060-1386 | M4 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-005: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SSP0060-1387 | M4 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-006: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SSP0060-1388 | M4 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-007: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SSP0060-1389 | M4 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-008: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SSP0060-1390 | M4 | D00-4e-009~021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-009~021: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-009~021) |
| WK-SSP0060-1391 | M4 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — I10: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (I10) |
| WK-SSP0060-1392 | M4 | I12 Requestor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — I12 Requestor 팝업: 행 집계 — M4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-1393 | M4 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |

## W8 구현 후 검증 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-1394 | H2 | COMMON:UC-01 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 COMMON:UC-01 |  | 1 (COMMON:UC-01) |
| WK-SSP0060-1395 | H2 | COMMON:UC-05 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-1396 | H2 | COMMON:UC-07 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 COMMON:UC-07 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-1397 | H2 | D00-1-054 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-1-054 |  | 1 (D00-1-054) |
| WK-SSP0060-1398 | H2 | D00-1-057 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-1-057 |  | 1 (D00-1-057) |
| WK-SSP0060-1399 | H2 | D00-2b-015~016 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-2b-015~016 |  | 1 (D00-2b-015~016) |
| WK-SSP0060-1400 | H2 | D00-2b-021 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-2b-021 |  | 1 (D00-2b-021) |
| WK-SSP0060-1401 | H2 | D00-3-010 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-3-010 |  | 1 (D00-3-010) |
| WK-SSP0060-1402 | H2 | D00-3-014 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-3-014 |  | 1 (D00-3-014) |
| WK-SSP0060-1403 | H2 | D00-3-029 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-3-029 |  | 1 (D00-3-029) |
| WK-SSP0060-1404 | H2 | D00-4a-003 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 D00-4a-003 |  | 1 (D00-4a-003) |
| WK-SSP0060-1405 | H2 | I14 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 I14 |  | 1 (I14) |
| WK-SSP0060-1406 | H2 | I16 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 I16 |  | 1 (I16) |
| WK-SSP0060-1407 | H2 | I16 Measure 시트변형 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 I16 Measure 시트변형 |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-1408 | H2 | I9 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 I9 |  | 1 (I9) |
| WK-SSP0060-1409 | H2 | LOT_YN | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 Ra 구현 후 검증 · 대상 LOT_YN |  | 1 (Ra) |
| WK-SSP0060-1410 | H2 | Rd | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 Rd |  | 1 (Rd) |
| WK-SSP0060-1411 | H2 | SSP0060_ShipmentPlan.CreateSpread | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 SSP0060_ShipmentPlan.CreateSpread |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-1412 | H2 | 메타 SQL 3종(18/19/20) 적용 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 메타 SQL 3종(18/19/20) 적용 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-1413 | H2 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-1414 | H2 | 음수 = 빨간 글자 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 음수 = 빨간 글자 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-1415 | H2 | 편집 불가(하늘색 Rc) | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행  구현 후 검증 · 대상 편집 불가(하늘색 Rc) |  | 1 (편집 불가(하늘색 Rc)) |
