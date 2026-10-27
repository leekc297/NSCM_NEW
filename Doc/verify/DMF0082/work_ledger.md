# 작업 원장 — DMF0082 · 2026-10-26 17:31

> 검사 인스턴스 1833건 중 PASS·NA 512건 외 **1321건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 52 | 구현 위치 실존 |
| W3 | 동작 수정 | 345 | 재판정 PASS |
| W7 | 기대값 확정 | 924 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 908 · FE 268 · 대조표 68 · DB 60 · 화면 FE 12 · 사람판정 3 · DB 메타 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 24 |  |  |  | 126 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| D3 | EDIT |  |  | 86 |  |  |  |  |  |  | 행 값 기반 조건부 잠금 |
| X-LOC | GEN |  | 52 |  |  |  |  | 30 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  |  | 82 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  |  | 76 |  |  | 연쇄 자동 채움 |
| C6 | CASCADE |  |  |  |  |  |  | 69 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G1 | GEN |  |  | 53 |  |  |  | 15 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C2 | CASCADE |  |  | 9 |  |  |  | 51 |  |  | 그리드 셀 cascade 후보 |
| G5 | POPUP |  |  |  |  |  |  | 60 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  |  | 57 |  |  | 팝업 표준·열림 |
| A1 | GEN |  |  |  |  |  |  | 53 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  | 43 |  |  |  | 8 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  |  |  | 43 |  |  | BE 계정 시노님·권한·대상 객체 |
| M4 | POPUP |  |  |  |  |  |  | 43 |  |  | 팝업 선택값 반영 |
| D1 | EDIT |  |  | 14 |  |  |  | 26 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| H2 | DESIGN |  |  | 19 |  |  |  | 17 |  |  | 배경·글자색 규칙 |
| B4 | COMBO |  |  | 13 |  |  |  | 16 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  | 12 |  |  |  | 15 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  |  | 26 |  |  | 라벨 명칭 |
| B3 | COMBO |  |  | 11 |  |  |  | 13 |  |  | 콤보 후보 정렬 = AS-IS |
| D4 | EDIT |  |  | 15 |  |  |  | 9 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| E3 | EDIT |  |  | 12 |  |  |  | 9 |  |  | 필수 입력 검증 |
| A6 | GEN |  |  | 10 |  |  |  | 9 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  |  |  | 19 |  |  | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  |  |  |  |  | 16 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B1 | COMBO |  |  | 3 |  |  |  | 8 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  |  |  | 10 |  |  | 콤보 후보 중복 없음 |
| G6 | GEN |  |  | 7 |  |  |  | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F3 | CRUD |  |  | 6 |  |  |  |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| D5 | EDIT |  |  | 6 |  |  |  |  |  |  | 셀 에디터 유형 |
| E5 | EDIT |  |  |  |  |  |  | 6 |  |  | 콤보 셀 후보 외 값 차단 |
| E2 | EDIT |  |  |  |  |  |  | 2 |  |  | 날짜 형식·유효성 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| J2 | AUTH |  |  |  |  |  |  | 1 |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  |  | 1 |  |  | 조회조건 저장·복원 |
| F1 | CRUD |  |  |  |  |  |  | 1 |  |  | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  | 1 |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  | 1 |  |  | 저장 후 값 보존 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| M3 | POPUP |  |  |  |  |  |  | 1 |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (52)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0001 | X-LOC | A-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A-01) |
| WK-DMF0082-0002 | X-LOC | A-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A-15) |
| WK-DMF0082-0003 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0004 | X-LOC | CRUD:MAIN:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:MAIN:SAVE) |
| WK-DMF0082-0005 | X-LOC | CRUD:MAIN:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:MAIN:SEARCH) |
| WK-DMF0082-0006 | X-LOC | CRUD:MAIN:SEARCH_CURRENT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0007 | X-LOC | CRUD:MAIN:UPDATE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:MAIN:UPDATE) |
| WK-DMF0082-0008 | X-LOC | CRUD:MAIN:UPLOAD | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:MAIN:UPLOAD) |
| WK-DMF0082-0009 | X-LOC | D-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D-07) |
| WK-DMF0082-0010 | X-LOC | DPF-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DPF-01) |
| WK-DMF0082-0011 | X-LOC | DPF-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DPF-02) |
| WK-DMF0082-0012 | X-LOC | DPF-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DPF-04) |
| WK-DMF0082-0013 | X-LOC | E07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E07) |
| WK-DMF0082-0014 | X-LOC | EVENT:E-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EVENT:E-04) |
| WK-DMF0082-0015 | X-LOC | MODAL:MeasureSelectModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/MeasureSelectModal.tsx 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0082-0016 | X-LOC | REQ:1ST-33-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-33-2) |
| WK-DMF0082-0017 | X-LOC | REQ:1ST-33-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-33-3) |
| WK-DMF0082-0018 | X-LOC | REQ:1ST-33-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-33-4) |
| WK-DMF0082-0019 | X-LOC | REQ:1ST-35-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-35-1) |
| WK-DMF0082-0020 | X-LOC | REQ:1ST-36-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-36-1) |
| WK-DMF0082-0021 | X-LOC | REQ:1ST-37-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-37-1) |
| WK-DMF0082-0022 | X-LOC | REQ:1ST-37-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0023 | X-LOC | REQ:1ST-39-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-39-1) |
| WK-DMF0082-0024 | X-LOC | REQ:1ST-39-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0025 | X-LOC | REQ:1ST-39-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-39-3) |
| WK-DMF0082-0026 | X-LOC | REQ:1ST-40-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ColumnSelectDualList.tsx 없음 |  | 1 (REQ:1ST-40-2) |
| WK-DMF0082-0027 | X-LOC | REQ:1ST-41-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-41-1) |
| WK-DMF0082-0028 | X-LOC | REQ:1ST-42-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-42-1) |
| WK-DMF0082-0029 | X-LOC | REQ:1ST-44-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-44-2) |
| WK-DMF0082-0030 | X-LOC | REQ:1ST-45-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-45-1) |
| WK-DMF0082-0031 | X-LOC | REQ:1ST-45-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-45-2) |
| WK-DMF0082-0032 | X-LOC | REQ:1ST-47-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-47-1) |
| WK-DMF0082-0033 | X-LOC | REQ:1ST-47-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-47-2) |
| WK-DMF0082-0034 | X-LOC | REQ:1ST-47-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-47-3) |
| WK-DMF0082-0035 | X-LOC | REQ:1ST-48-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-0036 | X-LOC | REQ:1ST-48-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0037 | X-LOC | REQ:1ST-48-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-48-4) |
| WK-DMF0082-0038 | X-LOC | REQ:1ST-49-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-0039 | X-LOC | REQ:1ST-63-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-63-1) |
| WK-DMF0082-0040 | X-LOC | REQ:1ST-63-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-63-2) |
| WK-DMF0082-0041 | X-LOC | REQ:1ST-63-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-63-3) |
| WK-DMF0082-0042 | X-LOC | REQ:1ST-64-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-64-1) |
| WK-DMF0082-0043 | X-LOC | REQ:1ST-65-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-65-1) |
| WK-DMF0082-0044 | X-LOC | REQ:1ST-65-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-65-2) |
| WK-DMF0082-0045 | X-LOC | REQ:1ST-65-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0046 | X-LOC | REQ:1ST-66-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0047 | X-LOC | REQ:1ST-67-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:1ST-67-1) |
| WK-DMF0082-0048 | X-LOC | REQ:CHAT-20260820-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0049 | X-LOC | REQ:CHAT-20260915-EXLASTUPD | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: procedures.d.ts 없음 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0050 | X-LOC | REQ:CHAT-20260915-PRICEPJTGAP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0051 | X-LOC | S-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S-07) |
| WK-DMF0082-0052 | X-LOC | S-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S-22) |

## W3 동작 수정 (345)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0053 | C2 | DIVISION_ID / Div | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — DIVISION_ID / Div: 실측[T-0d37e73a]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) |  | 6 (D-17 D-18 HANDLER:spdMain_ComboSelChange) |
| WK-DMF0082-0054 | C2 | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedIndexChanged: 진입점 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 29 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0055 | C2 | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged: 진입점 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0056 | C2 | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexChanged: 진입점 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0057 | C2 | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChanged: 진입점 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0058 | C2 | E01 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — E01: 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 1 (E01) |
| WK-DMF0082-0059 | C2 | HANDLER:spdMain_Changed | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — HANDLER:spdMain_Changed: 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0082-0060 | C2 | INCOTERMS / Incoterms | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — INCOTERMS / Incoterms: 실측[T-38610295]: To Site 후보에 PLANT/SALES 타입이 모두 없음(PLANT '' · SALES '', 후보 0) — 사이트 타입 분기 재현 불가 |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0082-0061 | C2 | REQ:1ST-48-3 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | C2 FAIL 수정 — REQ:1ST-48-3: 행 집계 — C2 51요소: REVIEW:49 · FAIL:2 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0062 | B1 | A-11 | DB(🛠️/🧯 적용 가능) | B1 FAIL 수정 — A-11: 행 집계 — B1 15요소: REVIEW:8 · PASS:6 · FAIL:1 |  | 1 (A-11) |
| WK-DMF0082-0063 | B1 | COMMON:UC-05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B1 FAIL 수정 — COMMON:UC-05: 행 집계 — B1 15요소: REVIEW:8 · PASS:6 · FAIL:1 |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0064 | B1 | CURRENCY / Currency | 화면 FE(범위 밖(가이드만)) | B1 FAIL 수정 — CURRENCY / Currency: 원장 V-a1173add COLUMN (FX-DMF0082-071) |  | 4 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.InsertR) |
| WK-DMF0082-0065 | B3 | A-11 | DB(🛠️/🧯 적용 가능) | B3 FAIL 수정 — A-11: 행 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 1 (A-11) |
| WK-DMF0082-0066 | B3 | DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivi | DB(🛠️/🧯 적용 가능) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetBizTypeby) |
| WK-DMF0082-0067 | B3 | DMF0082_FcstNPrice_Mgmt.GetBucketType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0068 | B3 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0069 | B3 | DMF0082_FcstNPrice_Mgmt.GetDayRange | DB(🛠️/🧯 적용 가능) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0070 | B3 | DMF0082_FcstNPrice_Mgmt.GetFcstType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — B3 1요소: FAIL:1 |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0071 | B3 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | DB(🛠️/🧯 적용 가능) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0072 | B3 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0073 | B3 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0074 | B3 | DMF0082_FcstNPrice_Mgmt.getDayOfWeek | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.getDayOfWeek: 진입점 집계 — B3 15요소: REVIEW:10 · PASS:3 · FAIL:1 · NA:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.getDayOfWeek) |
| WK-DMF0082-0075 | B3 | FCST_TYPE / FCST Type | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — FCST_TYPE / FCST Type: 원장 V-c7a4b5d8 COLUMN (FX-DMF0082-048) |  | 4 (F-09 ACT:DMF0082_FcstNPrice_Mgmt.GetFcst) |
| WK-DMF0082-0076 | B4 | A-11 | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — A-11: 행 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 1 (A-11) |
| WK-DMF0082-0077 | B4 | CELL_PROD_SITE_ID / Cell Prod Site | DB 메타(적용 예정) | B4 FAIL 수정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-48949855 COLUMN (FX-DMF0082-067) |  | 9 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0078 | B4 | COMMON:UC-05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — COMMON:UC-05: 행 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0079 | B4 | DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivi | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetBizTypeby) |
| WK-DMF0082-0080 | B4 | DMF0082_FcstNPrice_Mgmt.GetBucketType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0081 | B4 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0082 | B4 | DMF0082_FcstNPrice_Mgmt.GetDayRange | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0083 | B4 | DMF0082_FcstNPrice_Mgmt.GetFcstType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — B4 1요소: FAIL:1 |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0084 | B4 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0085 | B4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0086 | B4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0087 | B4 | DMF0082_FcstNPrice_Mgmt.getDayOfWeek | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.getDayOfWeek: 진입점 집계 — B4 21요소: REVIEW:13 · PASS:6 · FAIL:2 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.getDayOfWeek) |
| WK-DMF0082-0088 | B4 | FCST_TYPE / FCST Type | DB 메타(적용 예정) | B4 FAIL 수정 — FCST_TYPE / FCST Type: 원장 V-67e34115 COLUMN (FX-DMF0082-049) |  | 5 (F-03 F-09 ACT:DMF0082_FcstNPrice_Mgmt.Ge) |
| WK-DMF0082-0089 | F3 | CELL_PROD_SITE_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — CELL_PROD_SITE_ID: 원장 V-47e9c264 / 실측[T-3de77b09]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0090 | F3 | CELL_PROD_SITE_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — CELL_PROD_SITE_ID: 원장 V-08ef7bac / 실측[T-f27b6802]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0091 | F3 | DMF0082 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — DMF0082 화면: 원장 V-034eeb35 DEFECT / 실측[T-030c97ce]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 87 (E07 E07-B M-24 E01-A EVENT:E-12 HANDLER:) |
| WK-DMF0082-0092 | F3 | I | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — I: 원장 V-c531688d / 실측[T-f039cc4d]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0093 | F3 | M | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — M: 원장 V-e9f9f028 / 실측[T-bf2105e6]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0094 | F3 | M | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F3 FAIL 수정 — M: 원장 V-fb001d96 / 실측[T-969cc043]: M 원본 값 있는 행/신규행 셀 위치 확인 불가(값 '') |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0095 | F5 | DMF0082 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F5 FAIL 수정 — DMF0082 화면: 원장 V-870c8e49 RULE_SCREEN / 원장 V-890e2cd5 DEFECT / 원장 V-f53564eb DEFECT / 원장 V-efa6ed8d CONFIRMED / 실측[T- |  | 136 (E06 A-03 A-04 A-05 A-06 D-16 E06-B M-01 ) |
| WK-DMF0082-0096 | F4 | A-15 | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — A-15: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (A-15) |
| WK-DMF0082-0097 | F4 | CRUD:E02:SAVE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — CRUD:E02:SAVE: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (CRUD:E02:SAVE) |
| WK-DMF0082-0098 | F4 | CRUD:E04:SAVE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — CRUD:E04:SAVE: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0099 | F4 | CRUD:E05:SEARCH | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — CRUD:E05:SEARCH: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0100 | F4 | D-14 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — D-14: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (D-14) |
| WK-DMF0082-0101 | F4 | D-15 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — D-15: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (D-15) |
| WK-DMF0082-0102 | F4 | D-16 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — D-16: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (D-16) |
| WK-DMF0082-0103 | F4 | DMF0003_GET_BUCKET_TYPE_CODE | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — DMF0003_GET_BUCKET_TYPE_CODE: 실측[T-786235be]: DMF0003_GET_BUCKET_TYPE_CODE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0104 | F4 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0105 | F4 | DMF0082_FcstNPrice_Mgmt.GetDayRange | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0106 | F4 | DMF0082_FcstNPrice_Mgmt.GetFcstType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0107 | F4 | DMF0082_FcstNPrice_Mgmt.GetFuturePriceIn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0108 | F4 | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0109 | F4 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0110 | F4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0111 | F4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0112 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetDa | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetDayRange: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0113 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetFu | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetFuturePriceInfo: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0114 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetMe | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCountInfo: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0115 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetSa | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFromTo: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0116 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetSp | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0117 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetWe | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetWeekData: 진입점 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0118 | F4 | DP-06 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DP-06: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (DP-06) |
| WK-DMF0082-0119 | F4 | DP-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — DP-07: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (DP-07) |
| WK-DMF0082-0120 | F4 | E02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — E02: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (E02) |
| WK-DMF0082-0121 | F4 | E04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — E04: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (E04) |
| WK-DMF0082-0122 | F4 | E05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — E05: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (E05) |
| WK-DMF0082-0123 | F4 | F-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — F-02: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (F-02) |
| WK-DMF0082-0124 | F4 | F-05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — F-05: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (F-05) |
| WK-DMF0082-0125 | F4 | F-06 | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — F-06: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (F-06) |
| WK-DMF0082-0126 | F4 | HANDLER:FindData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — HANDLER:FindData: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0127 | F4 | HANDLER:SaveData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — HANDLER:SaveData: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0128 | F4 | M-11 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — M-11: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (M-11) |
| WK-DMF0082-0129 | F4 | M-12 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — M-12: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (M-12) |
| WK-DMF0082-0130 | F4 | P-24 | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — P-24: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (P-24) |
| WK-DMF0082-0131 | F4 | PKG_DMF0082 | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — PKG_DMF0082: 실측[T-3052e069]: PKG_DMF0082: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0132 | F4 | PL-36 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — PL-36: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (PL-36) |
| WK-DMF0082-0133 | F4 | POPUP_GET_FUTUREPRICE_INFO | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — POPUP_GET_FUTUREPRICE_INFO: 실측[T-d7c7bae7]: POPUP_GET_FUTUREPRICE_INFO: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0134 | F4 | S-07 | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — S-07: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (S-07) |
| WK-DMF0082-0135 | F4 | S-19 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — S-19: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (S-19) |
| WK-DMF0082-0136 | F4 | S-24 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F4 FAIL 수정 — S-24: 행 집계 — F4 16요소: REVIEW:8 · FAIL:5 · PASS:3 |  | 1 (S-24) |
| WK-DMF0082-0137 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 실측[T-ed359344]: SCM0001_GET_BIZ_TYPE_BY_DIVISION: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-B |  | 3 (DPF-09 ACT:DMF0082_FcstNPrice_Mgmt.GetBi) |
| WK-DMF0082-0138 | F4 | SCM0001_GET_LOOKUP_VALUES | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — SCM0001_GET_LOOKUP_VALUES: 실측[T-3a17dded]: SCM0001_GET_LOOKUP_VALUES: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인)  |  | 376 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0139 | A5 | A-15 | DB(🛠️/🧯 적용 가능) | A5 FAIL 수정 — A-15: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (A-15) |
| WK-DMF0082-0140 | A5 | COMMON:UC-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0141 | A5 | CRUD:MAIN:SAVE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — CRUD:MAIN:SAVE: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (CRUD:MAIN:SAVE) |
| WK-DMF0082-0142 | A5 | DPF-01 | DB(🛠️/🧯 적용 가능) | A5 FAIL 수정 — DPF-01: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (DPF-01) |
| WK-DMF0082-0143 | A5 | DPF-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — DPF-04: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (DPF-04) |
| WK-DMF0082-0144 | A5 | HANDLER:btnSavePricePeriod_Click | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — HANDLER:btnSavePricePeriod_Click: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (HANDLER:btnSavePricePeriod_Click) |
| WK-DMF0082-0145 | A5 | L7 `titleSet` 시트 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — L7 `titleSet` 시트: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0146 | A5 | MEASURE / Measure | 사람판정(사람판정 대기) | A5 FAIL 수정 — MEASURE / Measure: 원장 V-bea468af COLUMN / 실측[T-f839cdb9]: MEASURE: AS-IS(Div 40) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE |  | 5 (EVENT:E-05 EVENT:E-08 ACT:DMF0082_SaveSa) |
| WK-DMF0082-0147 | A5 | MODAL:SavePricePeriodModal | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — MODAL:SavePricePeriodModal: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (MODAL:SavePricePeriodModal) |
| WK-DMF0082-0148 | A5 | MODAL:VersionSelectModal | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A5 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0149 | A5 | REQ:CHAT-20260820-1 | DB(🛠️/🧯 적용 가능) | A5 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0150 | A5 | REQ:CHAT-20260915-EXLASTUPD | DB(🛠️/🧯 적용 가능) | A5 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — A5 26요소: REVIEW:15 · PASS:10 · FAIL:1 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0151 | H2 | A-15 | DB(🛠️/🧯 적용 가능) | H2 FAIL 수정 — A-15: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (A-15) |
| WK-DMF0082-0152 | H2 | CELL_PROD_SITE_ID / Cell Prod Site | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-a35fb514 COLUMN / 실측[T-13ca144b]: CELL_PROD_SITE_ID: 기존행 편집 불가인데 노랑 · 신규행 편집 |  | 2 (E08-C EVENT:E-07) |
| WK-DMF0082-0153 | H2 | COMMON:UC-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — COMMON:UC-07: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0154 | H2 | CURRENCY / Currency | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — CURRENCY / Currency: 원장 V-9cfe3f33 COLUMN / 실측[T-6d4e5f78]: CURRENCY: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (FX-DMF0082- |  | 1 (EVENT:E-08) |
| WK-DMF0082-0155 | H2 | DMF0082_FcstNPrice_Mgmt.CreateSpread | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0156 | H2 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0157 | H2 | DP-11 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — DP-11: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (DP-11) |
| WK-DMF0082-0158 | H2 | DPF-01 | DB(🛠️/🧯 적용 가능) | H2 FAIL 수정 — DPF-01: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (DPF-01) |
| WK-DMF0082-0159 | H2 | DPF-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — DPF-04: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (DPF-04) |
| WK-DMF0082-0160 | H2 | END_CUSTOMER / End Customer | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — END_CUSTOMER / End Customer: 원장 V-7d068c94 COLUMN / 실측[T-221120c7]: END_CUSTOMER: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치  |  | 1 (EVENT:E-03) |
| WK-DMF0082-0161 | H2 | HANDLER:btnItemId_Click | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — HANDLER:btnItemId_Click: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0082-0162 | H2 | INCOTERMS / Incoterms | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — INCOTERMS / Incoterms: 원장 V-d5552a30 COLUMN / 실측[T-bb06ef86]: INCOTERMS: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (FX-DMF00 |  | 2 (EVENT:E-05 EVENT:E-06) |
| WK-DMF0082-0163 | H2 | ITEM_ID / Model | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — ITEM_ID / Model: 원장 V-d9d2a8c3 COLUMN / 원장 V-280085f3 ASIS / 실측[T-48c20115]: ITEM_ID: 기존행 편집 불가인데 노랑 · 신규행 편집 불가인데 노랑 |  | 3 (E08-C EVENT:E-07 EVENT:E-10) |
| WK-DMF0082-0164 | H2 | L7 `titleSet` 시트 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — L7 `titleSet` 시트: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0165 | H2 | MEASURE / Measure | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — MEASURE / Measure: 원장 V-5e7446f0 COLUMN / 실측[T-37ba23e2]: MEASURE: 기존행 편집 불가인데 노랑 · 신규행 편집=true 표시 일치 (FX-DMF0082-080 |  | 7 (L-06 L-10 EVENT:E-05 EVENT:E-08 ACT:DMF0) |
| WK-DMF0082-0166 | H2 | MODAL:VersionSelectModal | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H2 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0167 | H2 | REQ:CHAT-20260820-1 | DB(🛠️/🧯 적용 가능) | H2 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0168 | H2 | REQ:CHAT-20260915-EXLASTUPD | DB(🛠️/🧯 적용 가능) | H2 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — H2 41요소: REVIEW:17 · NA:15 · FAIL:7 · PASS:2 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0169 | H2 | SCM_SITE_ID / Sales Site | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SCM_SITE_ID / Sales Site: 원장 V-edfc2808 COLUMN / 원장 V-280085f3 ASIS / 실측[T-4dc83538]: SCM_SITE_ID: 기존행 편집 불가인데 노랑 · 신 |  | 1 (EVENT:E-03) |
| WK-DMF0082-0170 | D1 | A-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — A-07: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (A-07) |
| WK-DMF0082-0171 | D1 | A-08 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — A-08: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (A-08) |
| WK-DMF0082-0172 | D1 | A-09 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — A-09: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (A-09) |
| WK-DMF0082-0173 | D1 | A-10 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — A-10: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (A-10) |
| WK-DMF0082-0174 | D1 | AsIncotermsEdit | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — AsIncotermsEdit: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (AsIncotermsEdit) |
| WK-DMF0082-0175 | D1 | DMF0082_FcstNPrice_Mgmt.EditButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.EditButton: 진입점 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0176 | D1 | DP-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — DP-02: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (DP-02) |
| WK-DMF0082-0177 | D1 | DP-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — DP-03: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (DP-03) |
| WK-DMF0082-0178 | D1 | DP-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — DP-04: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (DP-04) |
| WK-DMF0082-0179 | D1 | HANDLER:EditButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — HANDLER:EditButton: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (HANDLER:EditButton) |
| WK-DMF0082-0180 | D1 | HANDLER:btnSavePricePeriod_Click | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — HANDLER:btnSavePricePeriod_Click: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (HANDLER:btnSavePricePeriod_Click) |
| WK-DMF0082-0181 | D1 | INCOTERMS / Incoterms | 사람판정(사람판정 대기) | D1 FAIL 수정 — INCOTERMS / Incoterms: 원장 V-935ea8c1 COLUMN / 원장 V-296593a6 COLUMN / 실측[T-02513beb]: To Site 후보에서 PLANT('')/비PLANT('' |  | 2 (M-24 E01-A) |
| WK-DMF0082-0182 | D1 | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D1 FAIL 수정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-0183 | D1 | MODAL:ExchangeRateModal | DB(🛠️/🧯 적용 가능) | D1 FAIL 수정 — MODAL:ExchangeRateModal: 행 집계 — D1 30요소: REVIEW:26 · NA:3 · FAIL:1 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0184 | D3 | A-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — A-07: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (A-07) |
| WK-DMF0082-0185 | D3 | A-08 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — A-08: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (A-08) |
| WK-DMF0082-0186 | D3 | A-09 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — A-09: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (A-09) |
| WK-DMF0082-0187 | D3 | A-10 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — A-10: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (A-10) |
| WK-DMF0082-0188 | D3 | AUTHORITY_YN | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — AUTHORITY_YN: 원장 V-999595f0 ASIS / 원장 V-f52613e6 ASIS / 원장 V-550094ae ASIS / 원장 V-719c6960 ASIS / 원장 V-ad8773f4 ASIS  |  | 39 (A-13 A-14 PL-21 PL-22 ACT:DMF0082_SaveSa) |
| WK-DMF0082-0189 | D3 | AsIncotermsEdit | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — AsIncotermsEdit: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (AsIncotermsEdit) |
| WK-DMF0082-0190 | D3 | B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — B: 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 ASIS / 원장 V-f97c3dcb ASIS / 원장 V-cae669c8 ASIS / 원장 V-819c9996 ASIS / 실측[T-e150 |  | 1 (E07-B) |
| WK-DMF0082-0191 | D3 | B,B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — B,B: 원장 V-f97c3dcb / 실측[T-39d482f3]: B: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0192 | D3 | B,B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — B,B: 원장 V-cae669c8 / 실측[T-1d00e28b]: B: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0193 | D3 | B,B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — B,B: 원장 V-819c9996 / 실측[T-8c082d02]: B: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0194 | D3 | CURRENCY / Currency | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — CURRENCY / Currency: 원장 V-0bf11310 ASIS / 실측[T-b3a6c9e2]: CURRENCY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여 |  | 1 (EVENT:E-08) |
| WK-DMF0082-0195 | D3 | D | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — D: 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-f700acb7 ASIS / 원장 V-f7261ea0 ASIS / 원장 V-db62 |  | 4 (D-03 D-07 D-18 REQ:1ST-43-1) |
| WK-DMF0082-0196 | D3 | DEPT_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DEPT_ID: 원장 V-f7261ea0 ASIS / 실측[T-4161c6ef]: DEPT_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0197 | D3 | DEPT_ID,DEPT_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DEPT_ID,DEPT_ID: 원장 V-f7261ea0 / 실측[T-4ef0d8ca]: DEPT_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0198 | D3 | DEPT_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DEPT_NAME: 원장 V-db62ed6d ASIS / 실측[T-0df0fb2d]: DEPT_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서  |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0199 | D3 | DEPT_NAME,DEPT_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DEPT_NAME,DEPT_NAME: 원장 V-db62ed6d / 실측[T-6e9dd991]: DEPT_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0200 | D3 | DIVISION_ID / Div | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DIVISION_ID / Div: 원장 V-f700acb7 ASIS / 원장 V-4554bac9 ASIS / 원장 V-719c6960 ASIS / 원장 V-ad8773f4 ASIS / 실측[T-490630d8] |  | 12 (D-18 PL-20 PL-24 PL-25 E01-A EVENT:E-04 ) |
| WK-DMF0082-0201 | D3 | DIVISION_ID,DIVISION_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DIVISION_ID,DIVISION_ID: 원장 V-f700acb7 / 실측[T-b4814131]: DIVISION_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0202 | D3 | DIVISION_ID,DIVISION_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DIVISION_ID,DIVISION_ID: 원장 V-719c6960 / 실측[T-0cd61159]: DIVISION_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0203 | D3 | DIVISION_ID,MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DIVISION_ID,MEASURE: 원장 V-4554bac9 / 실측[T-973bc3be]: DIVISION_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0204 | D3 | DIVISION_ID,MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DIVISION_ID,MEASURE: 원장 V-ad8773f4 / 실측[T-3aadd66a]: DIVISION_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0205 | D3 | DMF0082_FcstNPrice_Mgmt.EditButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.EditButton: 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 실측[T-866a5b0d]: 진입 |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0206 | D3 | DP-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DP-02: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (DP-02) |
| WK-DMF0082-0207 | D3 | DP-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DP-03: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (DP-03) |
| WK-DMF0082-0208 | D3 | DP-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — DP-04: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (DP-04) |
| WK-DMF0082-0209 | D3 | E | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — E: 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-2282146b ASIS / 원장 V-c6ee1d63 ASIS / 원장 V-9e8c6818 ASIS / 원장 V-0bf1 |  | 4 (EVENT:E-04 EVENT:E-08 EVENT:E-11 EVENT:E) |
| WK-DMF0082-0210 | D3 | END_CUSTOMER / End Customer | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — END_CUSTOMER / End Customer: 원장 V-c9d3eb1a ASIS / 실측[T-4f885e74]: END_CUSTOMER: AS-IS 에 행 조건 잠금(lock_rules ROW_COND)  |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0211 | D3 | END_CUSTOMER,END_CUSTOMER | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — END_CUSTOMER,END_CUSTOMER: 원장 V-c9d3eb1a / 실측[T-02d3d033]: END_CUSTOMER: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0212 | D3 | F | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — F: 원장 V-c03c107d ASIS / 원장 V-e885c307 ASIS / 원장 V-0bf11310 ASIS / 원장 V-f700acb7 ASIS / 원장 V-f7261ea0 ASIS / 원장 V-db62 |  | 2 (F-01 M-04) |
| WK-DMF0082-0213 | D3 | HANDLER:EditButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — HANDLER:EditButton: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (HANDLER:EditButton) |
| WK-DMF0082-0214 | D3 | HANDLER:btnSavePricePeriod_Click | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — HANDLER:btnSavePricePeriod_Click: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (HANDLER:btnSavePricePeriod_Click) |
| WK-DMF0082-0215 | D3 | I | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — I: 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-c7d7 |  | 6 (A-14 PL-22 PL-25 S-14 E01-A ACT:DMF0082_) |
| WK-DMF0082-0216 | D3 | ITEM_CLASS_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_CLASS_NAME: 원장 V-de6fefba ASIS / 원장 V-d98cbb9f ASIS / 실측[T-e8e7ac0f]: ITEM_CLASS_NAME: AS-IS 에 행 조건 잠금(lock_rule |  | 5 (PL-29 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0217 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_CLASS_NAME,ITEM_CLASS_NAME: 원장 V-de6fefba / 실측[T-557b392b]: ITEM_CLASS_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0218 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_CLASS_NAME,ITEM_CLASS_NAME: 원장 V-d98cbb9f / 실측[T-4f2bcf9d]: ITEM_CLASS_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0219 | D3 | ITEM_ID / Model | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_ID / Model: 원장 V-0c79b76f ASIS / 실측[T-fd4d50d9]: ITEM_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0220 | D3 | ITEM_ID,ITEM_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_ID,ITEM_ID: 원장 V-0c79b76f / 실측[T-d82cacca]: ITEM_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0221 | D3 | ITEM_NAME / Model Name | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_NAME / Model Name: 원장 V-65bbf7d5 ASIS / 원장 V-f452433d ASIS / 실측[T-6b64805f]: ITEM_NAME: AS-IS 에 행 조건 잠금(lock_rul |  | 5 (PL-30 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0222 | D3 | ITEM_NAME,ITEM_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_NAME,ITEM_NAME: 원장 V-65bbf7d5 / 실측[T-053d4eaf]: ITEM_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0223 | D3 | ITEM_NAME,ITEM_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — ITEM_NAME,ITEM_NAME: 원장 V-f452433d / 실측[T-c20b0dab]: ITEM_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0224 | D3 | L | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — L: 원장 V-8243243b ASIS / 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-2282 |  | 37 (L-01 L-02 L-03 L-04 L-05 L-06 L-07 L-08 ) |
| WK-DMF0082-0225 | D3 | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-0226 | D3 | M | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — M: 원장 V-8243243b ASIS / 원장 V-c03c107d ASIS / 원장 V-e36b7206 ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-2282 |  | 13 (E03 L-12 M-03 M-04 M-05 M-06 M-07 M-09 M) |
| WK-DMF0082-0227 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-6103516a / 실측[T-b768e3bd]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0228 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-0bf11310 / 실측[T-537897b3]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0229 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-999595f0 / 실측[T-9f12a49d]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0230 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-3a196c6d / 실측[T-1ee00db0]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0231 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-0215b8b1 / 실측[T-8d5ea684]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0232 | D3 | MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE: 원장 V-39848305 / 실측[T-ae194ecd]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type) case F |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0233 | D3 | MEASURE / Measure | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE / Measure: 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-423cd9a1 ASIS / 원장 V-4554bac9 ASIS / 원장 V-999595f0  |  | 29 (A-02 L-06 L-10 M-09 PL-19 PL-20 PL-21 PL) |
| WK-DMF0082-0234 | D3 | MEASURE,MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE,MEASURE: 원장 V-423cd9a1 / 실측[T-22b52450]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0235 | D3 | MEASURE,MEASURE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — MEASURE,MEASURE: 원장 V-e5914055 / 실측[T-cd3e9431]: 조건 계산 불가: if (sAction == CAppSetting.StringI) / try / switch (e.Type |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0236 | D3 | MODAL:ExchangeRateModal | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — MODAL:ExchangeRateModal: 행 집계 — D3 79요소: FAIL:73 · NA:6 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0237 | D3 | N | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — N: 원장 V-c7a9409a ASIS / 원장 V-0bf11310 ASIS / 원장 V-c7d705d0 ASIS / 원장 V-154a022d ASIS / 원장 V-826a02fb ASIS / 원장 V-f700 |  | 5 (E03 E07-B 버튼 노출 원천 = `buttonAuth` 시트 (20) |
| WK-DMF0082-0238 | D3 | NICK_NAME / Nick Name | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — NICK_NAME / Nick Name: 원장 V-16bb2eee ASIS / 원장 V-07303a9b ASIS / 실측[T-20413ada]: NICK_NAME: AS-IS 에 행 조건 잠금(lock_rule |  | 5 (PL-32 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0239 | D3 | NICK_NAME,NICK_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — NICK_NAME,NICK_NAME: 원장 V-16bb2eee / 실측[T-9c761c8f]: NICK_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0240 | D3 | NICK_NAME,NICK_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — NICK_NAME,NICK_NAME: 원장 V-07303a9b / 실측[T-40fb6cfa]: NICK_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0241 | D3 | P | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — P: 원장 V-0bf11310 ASIS / 원장 V-6f20d1e8 ASIS / 원장 V-2ba348a5 ASIS / 원장 V-c7d705d0 ASIS / 원장 V-154a022d ASIS / 원장 V-39d5 |  | 5 (P-03 P-06 P-07 P-08 P-10) |
| WK-DMF0082-0242 | D3 | P,P | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — P,P: 원장 V-6f20d1e8 / 실측[T-209287f7]: 조건 계산 불가: if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2)  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0243 | D3 | P,P | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — P,P: 원장 V-2ba348a5 / 실측[T-b773cd9c]: 조건 계산 불가: if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2)  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0244 | D3 | P,P | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — P,P: 원장 V-39d5c265 / 실측[T-ef682386]: 조건 계산 불가: if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2)  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0245 | D3 | P,P | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — P,P: 원장 V-af265b50 / 실측[T-e1c01485]: 조건 계산 불가: if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2)  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0246 | D3 | PROJECT_CODE / Project Code | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — PROJECT_CODE / Project Code: 원장 V-98cd8436 ASIS / 실측[T-4c0cdc13]: PROJECT_CODE: AS-IS 에 행 조건 잠금(lock_rules ROW_COND)  |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0247 | D3 | PROJECT_CODE,PROJECT_CODE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — PROJECT_CODE,PROJECT_CODE: 원장 V-98cd8436 / 실측[T-4c92dca3]: PROJECT_CODE: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0248 | D3 | PROJECT_NAME / Project | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — PROJECT_NAME / Project: 원장 V-d9c042fa ASIS / 원장 V-d702fad5 ASIS / 실측[T-ec363efd]: PROJECT_NAME: AS-IS 에 행 조건 잠금(lock_ |  | 6 (PL-26 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0249 | D3 | PROJECT_NAME,PROJECT_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — PROJECT_NAME,PROJECT_NAME: 원장 V-d9c042fa / 실측[T-1c39661f]: PROJECT_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0250 | D3 | PROJECT_NAME,PROJECT_NAME | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — PROJECT_NAME,PROJECT_NAME: 원장 V-d702fad5 / 실측[T-87c6d2eb]: PROJECT_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0251 | D3 | S | DB(🛠️/🧯 적용 가능) | D3 FAIL 수정 — S: 원장 V-c03c107d ASIS / 원장 V-e885c307 ASIS / 원장 V-c7a9409a ASIS / 원장 V-6103516a ASIS / 원장 V-0bf11310 ASIS / 원장 V-6f20 |  | 5 (S-12 S-13 S-14 S-15 EVENT:E-04) |
| WK-DMF0082-0252 | D3 | SCM_SITE_ID / Sales Site | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — SCM_SITE_ID / Sales Site: 원장 V-b24d6ff8 ASIS / 실측[T-e1e055f8]: SCM_SITE_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — |  | 13 (E01-A ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0253 | D3 | SCM_SITE_ID,SCM_SITE_ID | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — SCM_SITE_ID,SCM_SITE_ID: 원장 V-b24d6ff8 / 실측[T-8ff2c90e]: SCM_SITE_ID: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0254 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-8243243b / 실측[T-834da954]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.Draw:1812:12) |
| WK-DMF0082-0255 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-c7d705d0 / 실측[T-657b2db4]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0256 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-154a022d / 실측[T-2991ff29]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0257 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-826a02fb / 실측[T-bea75bef]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0258 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-e1a0f68c / 실측[T-fdc3313c]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0259 | D3 | siMain.LockColumn | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn: 원장 V-650ce160 / 실측[T-2271c634]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0260 | D3 | siMain.LockColumn2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockColumn2: 원장 V-e36b7206 / 실측[T-ad2ca1e4]: siMain.LockColumn2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0261 | D3 | siMain.LockRange | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange: 원장 V-f52613e6 / 실측[T-b40f020d]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0262 | D3 | siMain.LockRange | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange: 원장 V-550094ae / 실측[T-fdb5152a]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0263 | D3 | siMain.LockRange2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange2: 원장 V-c7a9409a / 실측[T-78307038]: siMain.LockRange2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:27) |
| WK-DMF0082-0264 | D3 | siMain.LockRange2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange2: 원장 V-2282146b / 실측[T-64a52903]: siMain.LockRange2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0265 | D3 | siMain.LockRange2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange2: 원장 V-c6ee1d63 / 실측[T-9375454b]: siMain.LockRange2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0266 | D3 | siMain.LockRange2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.LockRange2: 원장 V-9e8c6818 / 실측[T-3a6477d0]: siMain.LockRange2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0267 | D3 | siMain.SetLockFlag | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.SetLockFlag: 원장 V-c03c107d / 실측[T-4ab90941]: siMain.SetLockFlag: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0268 | D3 | siMain.SetLockFlag | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.SetLockFlag: 원장 V-e885c307 / 실측[T-8fb88c57]: siMain.SetLockFlag: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0269 | D3 | siMain.SwitchLock | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D3 FAIL 수정 — siMain.SwitchLock: 원장 V-5b23be70 / 실측[T-4b4b7eea]: siMain.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0270 | D4 | C | 사람판정(사람판정 대기) | D4 FAIL 수정 — C: 원장 V-784d4aa4 ASIS / 원장 V-9b36903b ASIS / 실측[T-83ce85d5]: 신규행 C='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (F |  | 1 (E08-C) |
| WK-DMF0082-0271 | D4 | COMMON:UC-01 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — COMMON:UC-01: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (COMMON:UC-01) |
| WK-DMF0082-0272 | D4 | COMMON:UC-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — COMMON:UC-03: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0273 | D4 | CRUD:E06:INSERT | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — CRUD:E06:INSERT: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (CRUD:E06:INSERT) |
| WK-DMF0082-0274 | D4 | E06 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — E06: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (E06) |
| WK-DMF0082-0275 | D4 | E06-A | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — E06-A: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (E06-A) |
| WK-DMF0082-0276 | D4 | HANDLER:InsertRow | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — HANDLER:InsertRow: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (HANDLER:InsertRow) |
| WK-DMF0082-0277 | D4 | HANDLER:cboBucketType_Click | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — HANDLER:cboBucketType_Click: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (HANDLER:cboBucketType_Click) |
| WK-DMF0082-0278 | D4 | I | 화면 FE(범위 밖(가이드만)) | D4 FAIL 수정 — I: 원장 V-9b36903b ASIS / 실측[T-e525d615]: 신규행 I='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (FX-DMF0082-192) |  | 3 (P-15 E01-A CRUD:MAIN:INSERT) |
| WK-DMF0082-0279 | D4 | InsertButton 전제 isCurVersion | 화면 FE(범위 밖(가이드만)) | D4 FAIL 수정 — InsertButton 전제 isCurVersion: 원장 V-9b36903b / 실측[T-2c241473]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(I |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InsertButton) |
| WK-DMF0082-0280 | D4 | L2P `hotkey DELETE` 권한 0그룹 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — L2P `hotkey DELETE` 권한 0그룹: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (L2P `hotkey DELETE` 권한 0그룹) |
| WK-DMF0082-0281 | D4 | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-0282 | D4 | REQ:1ST-38-1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D4 FAIL 수정 — REQ:1ST-38-1: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (REQ:1ST-38-1) |
| WK-DMF0082-0283 | D4 | REQ:CHAT-20260820-1 | DB(🛠️/🧯 적용 가능) | D4 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0284 | D4 | REQ:CHAT-20260915-EXLASTUPD | DB(🛠️/🧯 적용 가능) | D4 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — D4 20요소: REVIEW:9 · PASS:8 · FAIL:3 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0285 | D5 | A-11 | DB(🛠️/🧯 적용 가능) | D5 FAIL 수정 — A-11: 행 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 |  | 1 (A-11) |
| WK-DMF0082-0286 | D5 | COMMON:UC-05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D5 FAIL 수정 — COMMON:UC-05: 행 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0287 | D5 | DIVISION_ID / Div | 화면 FE(범위 밖(가이드만)) | D5 FAIL 수정 — DIVISION_ID / Div: 원장 V-09e00564 COLUMN / 실측[T-0230a46d]: DIVISION_ID: AS-IS COMBO(cell_rules) ↔ TO-BE dataType=1 dat |  | 1 (E01-A) |
| WK-DMF0082-0288 | D5 | DMF0082_FcstNPrice_Mgmt.CreateSpread | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D5 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0289 | D5 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D5 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — D5 15요소: NA:8 · PASS:5 · FAIL:2 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0290 | D5 | MEASURE / Measure | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D5 FAIL 수정 — MEASURE / Measure: 실측[T-22cd82b1]: MEASURE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=1 dataMap=Y — AS-IS TEXT 에디터가 아님 |  | 5 (M-08 E01-A ACT:DMF0082_SaveSalesFuturePr) |
| WK-DMF0082-0291 | D6 | DMF0082 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | D6 FAIL 수정 — DMF0082 화면: 실측[T-33ab5070]: 조회 2158행 · r1 셀 클릭 후 Insert → 신규행 맨 위(0) · 행 2158→2159 — AS-IS SpreadInfo.Insert(): 활성 행  |  | 27 (E06 D-06 E06-A E08-C F-03 L-10 L-14 M-22) |
| WK-DMF0082-0292 | E3 | CRUD:E04:SAVE | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — CRUD:E04:SAVE: 실측[T-6a3d2db5]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0293 | E3 | CURRENCY / Currency | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — CURRENCY / Currency: 필수 표시 AS-IS *('Currency*') ↔ TO-BE -('Currency' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOf |  | 3 (D-05 D-19 M-10) |
| WK-DMF0082-0294 | E3 | DP-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — DP-02: 실측[T-62637cb3]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (DP-02) |
| WK-DMF0082-0295 | E3 | DP-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — DP-04: 실측[T-8716611b]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (DP-04) |
| WK-DMF0082-0296 | E3 | DP-08 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — DP-08: 실측[T-9553cf3c]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (DP-08) |
| WK-DMF0082-0297 | E3 | E01-B1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — E01-B1: 실측[T-f1796be5]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (E01-B1) |
| WK-DMF0082-0298 | E3 | END_CUSTOMER / End Customer | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — END_CUSTOMER / End Customer: 필수 표시 AS-IS *('End Customer*') ↔ TO-BE -('End Customer' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 |  | 1 (D-11) |
| WK-DMF0082-0299 | E3 | HANDLER:FindData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — HANDLER:FindData: 실측[T-2ee0e938]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0300 | E3 | HANDLER:SaveData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — HANDLER:SaveData: 실측[T-4ad3e083]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0301 | E3 | PROJECT_CODE / Project Code | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — PROJECT_CODE / Project Code: 필수 표시 AS-IS *('Project Code*') ↔ TO-BE -('Project Code' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 |  | 2 (D-10 S-18) |
| WK-DMF0082-0302 | E3 | REQ:1ST-38-1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — REQ:1ST-38-1: 실측[T-f723492f]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (REQ:1ST-38-1) |
| WK-DMF0082-0303 | E3 | REQ:1ST-41-1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E3 FAIL 수정 — REQ:1ST-41-1: 실측[T-7e7d1b54]: 행 집계 — E3 14요소: NOT_RUN:8 · FAIL:3 · PASS:2 · REVIEW:1 |  | 1 (REQ:1ST-41-1) |
| WK-DMF0082-0304 | A6 | A-15 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — A-15: 실측[T-9ea3507c]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (A-15) |
| WK-DMF0082-0305 | A6 | CRUD:E05:SEARCH | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — CRUD:E05:SEARCH: 실측[T-3bf12ddb]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0306 | A6 | E05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — E05: 실측[T-186dadfa]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (E05) |
| WK-DMF0082-0307 | A6 | F-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — F-02: 실측[T-0aca18f0]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (F-02) |
| WK-DMF0082-0308 | A6 | HANDLER:FindData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — HANDLER:FindData: 실측[T-65112855]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0309 | A6 | P-24 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — P-24: 실측[T-19e2aa13]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (P-24) |
| WK-DMF0082-0310 | A6 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA: 원장 V-20e289c9 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['SORT_ORDER_NO'] ↔ TO-BE ['TO_N  |  | 67 (A-01 CRUD:MAIN:SEARCH DPF-02 ACT:DMF0082) |
| WK-DMF0082-0311 | A6 | PL-36 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — PL-36: 실측[T-1cd782b7]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (PL-36) |
| WK-DMF0082-0312 | A6 | S-07 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — S-07: 실측[T-b72b45a9]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (S-07) |
| WK-DMF0082-0313 | A6 | S-24 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | A6 FAIL 수정 — S-24: 실측[T-515232e6]: 행 집계 — A6 11요소: NOT_RUN:7 · REVIEW:2 · FAIL:1 · PASS:1 |  | 1 (S-24) |
| WK-DMF0082-0314 | G1 | A-01 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — A-01: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (A-01) |
| WK-DMF0082-0315 | G1 | A-11 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — A-11: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (A-11) |
| WK-DMF0082-0316 | G1 | A-13 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — A-13: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (A-13) |
| WK-DMF0082-0317 | G1 | A-15 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — A-15: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (A-15) |
| WK-DMF0082-0318 | G1 | COMMON:UC-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — COMMON:UC-02: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (COMMON:UC-02) |
| WK-DMF0082-0319 | G1 | COMMON:UC-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — COMMON:UC-03: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0320 | G1 | COMMON:UC-06 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — COMMON:UC-06: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0321 | G1 | COMMON:UC-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — COMMON:UC-07: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0322 | G1 | CRUD:E05:SEARCH | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — CRUD:E05:SEARCH: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0323 | G1 | CRUD:MAIN:SEARCH | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — CRUD:MAIN:SEARCH: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (CRUD:MAIN:SEARCH) |
| WK-DMF0082-0324 | G1 | CRUD:MAIN:SEARCH_CURRENT | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — CRUD:MAIN:SEARCH_CURRENT: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0325 | G1 | D-07 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — D-07: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (D-07) |
| WK-DMF0082-0326 | G1 | DP-01 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — DP-01: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (DP-01) |
| WK-DMF0082-0327 | G1 | DP-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — DP-04: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (DP-04) |
| WK-DMF0082-0328 | G1 | DPF-01 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — DPF-01: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (DPF-01) |
| WK-DMF0082-0329 | G1 | DPF-02 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — DPF-02: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (DPF-02) |
| WK-DMF0082-0330 | G1 | E01-A | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — E01-A: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (E01-A) |
| WK-DMF0082-0331 | G1 | E01-B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — E01-B: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (E01-B) |
| WK-DMF0082-0332 | G1 | E05 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — E05: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (E05) |
| WK-DMF0082-0333 | G1 | E07-B | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — E07-B: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (E07-B) |
| WK-DMF0082-0334 | G1 | E08-C | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — E08-C: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (E08-C) |
| WK-DMF0082-0335 | G1 | EVENT:E-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — EVENT:E-03: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (EVENT:E-03) |
| WK-DMF0082-0336 | G1 | EVENT:E-12 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — EVENT:E-12: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (EVENT:E-12) |
| WK-DMF0082-0337 | G1 | EVENT:E-14 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — EVENT:E-14: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (EVENT:E-14) |
| WK-DMF0082-0338 | G1 | F-02 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — F-02: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (F-02) |
| WK-DMF0082-0339 | G1 | HANDLER:FindData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — HANDLER:FindData: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0340 | G1 | HANDLER:Form_Load | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — HANDLER:Form_Load: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0341 | G1 | HANDLER:clbCustomer_SelectedIndexChanged | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0082-0342 | G1 | HANDLER:clbTeam_SelectedIndexChanged | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0082-0343 | G1 | L-03 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — L-03: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (L-03) |
| WK-DMF0082-0344 | G1 | M-21 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — M-21: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (M-21) |
| WK-DMF0082-0345 | G1 | MODAL:ForecastTemplateModal | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — MODAL:ForecastTemplateModal: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (MODAL:ForecastTemplateModal) |
| WK-DMF0082-0346 | G1 | MODAL:VersionSelectModal | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0347 | G1 | P-04 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — P-04: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (P-04) |
| WK-DMF0082-0348 | G1 | P-23 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — P-23: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (P-23) |
| WK-DMF0082-0349 | G1 | P-24 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — P-24: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (P-24) |
| WK-DMF0082-0350 | G1 | PL-33 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — PL-33: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (PL-33) |
| WK-DMF0082-0351 | G1 | PL-36 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — PL-36: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (PL-36) |
| WK-DMF0082-0352 | G1 | REQ:1ST-37-2 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — REQ:1ST-37-2: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0353 | G1 | REQ:1ST-39-1 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — REQ:1ST-39-1: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (REQ:1ST-39-1) |
| WK-DMF0082-0354 | G1 | REQ:1ST-39-2 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — REQ:1ST-39-2: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0355 | G1 | REQ:1ST-66-1 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — REQ:1ST-66-1: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0356 | G1 | REQ:CHAT-20260915-EXLASTUPD | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0357 | G1 | S-01 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — S-01: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (S-01) |
| WK-DMF0082-0358 | G1 | S-07 | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — S-07: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (S-07) |
| WK-DMF0082-0359 | G1 | S-24 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — S-24: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (S-24) |
| WK-DMF0082-0360 | G1 | S-25 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — S-25: 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (S-25) |
| WK-DMF0082-0361 | G1 | clbDivision / Division | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — clbDivision / Division: 원장 V-c1efd948 SEARCH |  | 3 (D-17 ACT:DMF0082_FcstNPrice_Mgmt.FindDat) |
| WK-DMF0082-0362 | G1 | clbDivisions / Division / Divisions | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G1 FAIL 수정 — clbDivisions / Division / Divisions: 원장 V-c1efd948 SEARCH |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0363 | G1 | clbTeam / Team | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — clbTeam / Team: 원장 V-8d4c7bcb SEARCH |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0364 | G1 | txtItemId / Model / Nickname / Item Id | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — txtItemId / Model / Nickname / Item Id: 원장 V-a795197a SEARCH |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0365 | G1 | txtVersion / Version | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — txtVersion / Version: 원장 V-2507864c SEARCH |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0366 | G1 | 버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) | DB(🛠️/🧯 적용 가능) | G1 FAIL 수정 — 버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02): 행 집계 — G1 23요소: REVIEW:15 · FAIL:5 · NA:2 · PASS:1 |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0367 | G6 | chkSum / Sum | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — chkSum / Sum: 실측[T-fea529cf]: 조회조건 chkSum(Sum) 칸 없음 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0368 | G6 | clbBizType / Biz Type | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — clbBizType / Biz Type: 실측[T-0b7b1272]: AS-IS 다중 체크리스트(선택 없음 = 전체) ↔ TO-BE 초기 '​' |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0369 | G6 | clbCustomer / End Customer / Customer | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — clbCustomer / End Customer / Customer: 실측[T-69f06ebd]: AS-IS 다중 체크리스트(선택 없음 = 전체) ↔ TO-BE 초기 '​' |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0370 | G6 | clbDivision / Division | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — clbDivision / Division: 실측[T-df9f27cc]: 조회조건 clbDivision(Division) 칸 없음 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0371 | G6 | clbSalesSite / Sales Site | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — clbSalesSite / Sales Site: 실측[T-59deef1c]: AS-IS 다중 체크리스트(선택 없음 = 전체) ↔ TO-BE 초기 '​' |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0372 | G6 | clbTeam / Team | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — clbTeam / Team: 실측[T-a062a959]: AS-IS 다중 체크리스트(선택 없음 = 전체) ↔ TO-BE 초기 '​' |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0373 | G6 | txtVersion / Version | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | G6 FAIL 수정 — txtVersion / Version: 실측[T-e1c19df5]: 조회조건 txtVersion(Version) 칸 없음 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0374 | X-ROW | DMF0082_FcstNPrice_Mgmt.DeleteButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.DeleteButton: 진입점 집계 13검사 — REVIEW:11 · FAIL:1 · PASS:1 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0375 | X-ROW | DMF0082_FcstNPrice_Mgmt.Draw | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.Draw: 진입점 집계 4검사 — REVIEW:3 · FAIL:1 |  | 102 (ACT:DMF0082_FcstNPrice_Mgmt.Draw ACT:DMF) |
| WK-DMF0082-0376 | X-ROW | DMF0082_FcstNPrice_Mgmt.EditButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.EditButton: 진입점 집계 14검사 — REVIEW:7 · FAIL:4 · NA:2 · PASS:1 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton A) |
| WK-DMF0082-0377 | X-ROW | DMF0082_FcstNPrice_Mgmt.FindButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.FindButton: 실측[T-b9427555]: 진입점 집계 6검사 — REVIEW:2 · NOT_RUN:2 · FAIL:1 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindButton) |
| WK-DMF0082-0378 | X-ROW | DMF0082_FcstNPrice_Mgmt.FindData | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.FindData: 실측[T-4db7283f]: 진입점 집계 34검사 — NOT_RUN:27 · PASS:3 · REVIEW:2 · FAIL:1 · TODO:1 |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:166) |
| WK-DMF0082-0379 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivi | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision: 진입점 집계 5검사 — REVIEW:3 · PASS:1 · FAIL:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetBizTypeby) |
| WK-DMF0082-0380 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetBucketType | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 5검사 — REVIEW:3 · PASS:1 · FAIL:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0381 | X-ROW | DMF0082_FcstNPrice_Mgmt.InitControls | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InitControls: 진입점 집계 27검사 — REVIEW:11 · PASS:9 · FAIL:7 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0382 | X-ROW | DMF0082_FcstNPrice_Mgmt.InsertButton | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InsertButton: 진입점 집계 2검사 — FAIL:2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertButton) |
| WK-DMF0082-0383 | X-ROW | DMF0082_FcstNPrice_Mgmt.InsertRow | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InsertRow: 진입점 집계 24검사 — REVIEW:12 · PASS:8 · FAIL:3 · NA:1 |  | 136 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow AC) |
| WK-DMF0082-0384 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetLockRange | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetLockRange: 진입점 집계 15검사 — REVIEW:9 · FAIL:5 · NA:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0385 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_Changed | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_Changed: 진입점 집계 107검사 — REVIEW:92 · PASS:6 · FAIL:5 · NA:3 · WARN:1 |  | 23 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0386 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_Clipboar | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_ClipboardPasted: 진입점 집계 34검사 — REVIEW:19 · FAIL:7 · NA:5 · PASS:3 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0387 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_ComboSel | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_ComboSelChange: 진입점 집계 29검사 — REVIEW:22 · PASS:5 · FAIL:2 |  | 20 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0388 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Dsdm_ | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.Dsdm_Changed: 진입점 집계 39검사 — REVIEW:32 · NA:6 · FAIL:1 |  | 56 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0389 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.EditB | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.EditButton: 진입점 집계 75검사 — FAIL:49 · REVIEW:21 · NA:4 · PASS:1 |  | 110 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0390 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.FindB | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.FindButton: 진입점 집계 4검사 — REVIEW:3 · FAIL:1 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0391 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.FindD | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.FindData: 진입점 집계 36검사 — REVIEW:22 · PASS:6 · FAIL:5 · NA:3 |  | 137 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0392 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Form_ | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.Form_Load: 진입점 집계 8검사 — REVIEW:6 · PASS:1 · FAIL:1 |  | 18 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0393 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetLo | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetLookupValues: 진입점 집계 4검사 — REVIEW:2 · FAIL:1 · PASS:1 |  | 18 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0394 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitC | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.InitControls: 진입점 집계 15검사 — REVIEW:7 · PASS:6 · FAIL:2 |  | 28 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0395 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SaveB | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.SaveButton: 진입점 집계 6검사 — REVIEW:5 · FAIL:1 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0396 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SaveD | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.SaveData: 진입점 집계 25검사 — REVIEW:21 · PASS:3 · FAIL:1 |  | 231 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0397 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SetSp | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.SetSpreadColumn: 진입점 집계 7검사 — REVIEW:3 · FAIL:3 · PASS:1 |  | 26 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |

## W7 기대값 확정 (924)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0398 | J2 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | J2 기대값 확정 — DMF0082 화면: 원장 V-be795c75 RULE_SCREEN / 원장 V-a3230a78 DEFECT / 원장 V-85fe4fa7 CONFIRMED |  | 272 (E02 E03 E04 E05 E06 A-01 A-02 A-03 A-04 ) |
| WK-DMF0082-0399 | C2 | AS_FROM_SITE / AS From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — AS_FROM_SITE / AS From Site: 실측[T-813ce510]: AS_FROM_SITE 연쇄 원천 해석 불가 — AS-IS spdMain_Changed:5615 siMain.GetColumnInd |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0400 | C2 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — BUCKET: 실측[T-1e8621a9]: 원천 S 신규행 편집 불가 |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0401 | C2 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — C: 원장 V-e5dc7973 / 실측[T-d1a94110]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:25) |
| WK-DMF0082-0402 | C2 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — C: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-8c624a0f ASIS / 원장 V-8da42 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0403 | C2 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — C: 원장 V-a4f0db51 / 실측[T-a1366829]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0404 | C2 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — C: 원장 V-5ae1fc43 / 실측[T-d12f8c55]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0405 | C2 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID: 원장 V-85681c5a / 실측[T-b07c7e25]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0406 | C2 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID: 원장 V-cd46b5e2 / 실측[T-346b1d0a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0407 | C2 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID: 원장 V-9a027e2b / 실측[T-16ee9fba]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0408 | C2 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID: 원장 V-6e3db6f1 / 실측[T-217b532b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0409 | C2 | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID: 원장 V-6fd08c20 / 실측[T-c90356fe]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0410 | C2 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-85681c5a ASIS / 원장 V-cd46b5e2 ASIS / 원장 V-9a027e2b ASIS / 원장 V-6e3db6f1 ASIS  |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0411 | C2 | CURRENCY | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CURRENCY: 원장 V-3adba0f7 / 실측[T-89f6d8f1]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@ver |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0412 | C2 | CURRENCY | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CURRENCY: 원장 V-8da422a0 / 실측[T-9ebdd6a9]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@ver |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0413 | C2 | CURRENCY | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CURRENCY: 원장 V-8579c986 / 실측[T-e39bb4e4]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@ver |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0414 | C2 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — CURRENCY / Currency: 원장 V-3adba0f7 ASIS / 원장 V-8da422a0 ASIS / 원장 V-8579c986 ASIS / 실측[T-70e3d94f]: CURRENCY 연쇄 원천 해석  |  | 9 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.spdMain) |
| WK-DMF0082-0415 | C2 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-07917ef7 ASIS / 원장 V-ae066 |  | 8 (D-10 D-11 D-12 D-13 D-17 D-18 ACT:DMF008) |
| WK-DMF0082-0416 | C2 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D: 원장 V-bddd2e5b / 실측[T-f4c87cbd]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:25) |
| WK-DMF0082-0417 | C2 | DMF0082_FcstNPrice_Mgmt.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_Changed: 진입점 집계 — C2 14요소: REVIEW:14 |  | 330 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0418 | C2 | DMF0082_FcstNPrice_Mgmt.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_ComboSelChange: 진입점 집계 — C2 9요소: REVIEW:9 |  | 50 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0419 | C2 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — E: 원장 V-8da422a0 ASIS / 원장 V-8579c986 ASIS / 원장 V-209a77cd ASIS / 원장 V-cd46b5e2 ASIS / 원장 V-e14aed38 ASIS / 원장 V-25bad |  | 2 (EVENT:E-03 ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0420 | C2 | END_CUSTOMER / End Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — END_CUSTOMER / End Customer: 실측[T-eae02ccf]: END_CUSTOMER 연쇄 원천 해석 불가 — AS-IS  |  | 4 (D-11 D-17 EVENT:E-03 HANDLER:spdMain_Com) |
| WK-DMF0082-0421 | C2 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — F: 원장 V-10dd2eba ASIS / 원장 V-8da422a0 ASIS / 원장 V-8579c986 ASIS / 원장 V-209a77cd ASIS / 원장 V-cd46b5e2 ASIS / 원장 V-e14ae |  | 1 (F-04) |
| WK-DMF0082-0422 | C2 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — F: 원장 V-10dd2eba / 실측[T-de1e96f3]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:25) |
| WK-DMF0082-0423 | C2 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-83cf257b]: FCST_TYPE 연쇄 원천 해석 불가 — AS-IS  |  | 1 (F-04) |
| WK-DMF0082-0424 | C2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — I: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-10dd2eba ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-07917 |  | 125 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.spdMain) |
| WK-DMF0082-0425 | C2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — I: 원장 V-4436e2c3 / 실측[T-022bda72]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:25) |
| WK-DMF0082-0426 | C2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — I: 원장 V-07917ef7 / 실측[T-4a455e85]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0427 | C2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — I: 원장 V-8c624a0f / 실측[T-21743952]: 검사 대상 아님 — 대조표 D-09 가 spdMain_CellDoubleClick 를 '제외'(사유: SSP 동기수량 비교 팝업 — 2026-07-2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0428 | C2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — I: 원장 V-63a114b3 / 실측[T-1514a858]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0429 | C2 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — ITEM_ID / Model: 원장 V-25bad5f0 ASIS / 실측[T-abbaa5a8]: 원천 PROJECT_CODE 신규행 편집 불가 |  | 4 (HANDLER:spdMain_ComboSelChange ACT:DMF00) |
| WK-DMF0082-0430 | C2 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — L: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-10dd2eba ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-07917 |  | 4 (L-06 L-07 L-08 L-09) |
| WK-DMF0082-0431 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-10dd2eba ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-07917 |  | 16 (M-08 M-09 M-13 M-14 M-15 M-16 M-17 M-18 ) |
| WK-DMF0082-0432 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-ae066e94 / 실측[T-4c56db01]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0433 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-209a77cd / 실측[T-5b6a2b35]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0434 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-ece45ff9 / 실측[T-5b19ba5c]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0435 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-d8960064 / 실측[T-f538a34a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0436 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-f498b15f / 실측[T-eb0d7e5e]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0437 | C2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M: 원장 V-d8423f48 / 실측[T-324b647a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0438 | C2 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — MEASURE / Measure: 원장 V-8da422a0 ASIS / 원장 V-8579c986 ASIS / 실측[T-0961a15c]: MEASURE 연쇄 원천 해석 불가 — AS-IS spdMain_Chang |  | 42 (L-06 M-08 M-09 ACT:DMF0082_FcstNPrice_Mg) |
| WK-DMF0082-0439 | C2 | PLANT_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — PLANT_SITE_ID: 원장 V-e14aed38 / 실측[T-dcd0099e]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재 코 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0440 | C2 | PLANT_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — PLANT_SITE_ID: 원장 V-25bad5f0 / 실측[T-bfc3ca5b]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재 코 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0441 | C2 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — PLANT_SITE_ID / Plant Site: 원장 V-e14aed38 ASIS / 원장 V-25bad5f0 ASIS / 실측[T-139e3dd1]: 원천 PROJECT_CODE 신규행 편집 불가 |  | 4 (D-18 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0442 | C2 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — PROJECT_CODE / Project Code: 원장 V-e14aed38 ASIS / 원장 V-25bad5f0 ASIS / 실측[T-58c2c5d9]: 원천 ITEM_ID 신규행 편집 불가 |  | 11 (D-10 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0443 | C2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — S: 원장 V-06110e53 / 실측[T-e0f13fdb]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:25) |
| WK-DMF0082-0444 | C2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — S: 원장 V-4436e2c3 ASIS / 원장 V-bddd2e5b ASIS / 원장 V-10dd2eba ASIS / 원장 V-e5dc7973 ASIS / 원장 V-06110e53 ASIS / 원장 V-07917 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0445 | C2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — S: 원장 V-f66fb5bd / 실측[T-26f89b41]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0446 | C2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — S: 원장 V-7e8182d3 / 실측[T-a4ae1ed4]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0447 | C2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — S: 원장 V-15156d7e / 실측[T-b57b4c57]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0448 | C2 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCM_SITE_ID / Sales Site: 실측[T-f8857a60]: SCM_SITE_ID 연쇄 원천 해석 불가 — AS-IS  |  | 2 (EVENT:E-03 HANDLER:spdMain_ComboSelChang) |
| WK-DMF0082-0449 | C2 | T | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — T: 원장 V-9867be7a / 실측[T-ea201ff1]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify) /  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0450 | C3 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — B: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 5 (E07-B ACT:DMF0082_FcstNPrice_Mgmt.SetSpr) |
| WK-DMF0082-0451 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-668a5a93 ASIS / 원장 V-eec1e5d9 ASIS / 원장 V-9ea0917b ASIS / 원장 V-f2b5dd51 ASIS / 원장 V-c66d4441 ASIS / 원장 V- |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0452 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-668a5a93 / 실측[T-d90a2b6b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0453 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-eec1e5d9 / 실측[T-2bdb62c8]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0454 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-9ea0917b / 실측[T-ae81a72d]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0455 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-f2b5dd51 / 실측[T-a15ab232]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0456 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-c66d4441 / 실측[T-61328609]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0457 | C3 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — BUCKET: 원장 V-9950935b / 실측[T-30cba3c0]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0458 | C3 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — C: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0459 | C3 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-03873d39 ASIS / 원장 V-661573f0 ASIS / 원장 V-7fdcd22d ASIS / 실측[T-5ed0694e]: CEL |  | 25 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0460 | C3 | CELL_PROD_SITE_ID,CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CELL_PROD_SITE_ID,CELL_PROD_SITE_ID: 원장 V-03873d39 / 실측[T-943e2851]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0461 | C3 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — CURRENCY / Currency: 실측[T-850232b3]: CURRENCY 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:2664 siMain.SetValue(iActRow, siMain.Ge |  | 15 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.InsertR) |
| WK-DMF0082-0462 | C3 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 12 (D-10 D-11 D-12 D-13 D-17 D-18 ACT:DMF008) |
| WK-DMF0082-0463 | C3 | DEPT_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DEPT_ID: 실측[T-9b0cc867]: DEPT_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-0464 | C3 | DMF0082_FcstNPrice_Mgmt.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetChangeControl: 진입점 집계 — C3 3요소: REVIEW:2 · NA:1 |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-0465 | C3 | DMF0082_FcstNPrice_Mgmt.SetEditList | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetEditList: 진입점 집계 — C3 1요소: REVIEW:1 |  | 31 (ACT:DMF0082_FcstNPrice_Mgmt.SetEditList:) |
| WK-DMF0082-0466 | C3 | DMF0082_FcstNPrice_Mgmt.SetLockRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetLockRange: 진입점 집계 — C3 3요소: REVIEW:3 |  | 32 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0467 | C3 | DMF0082_FcstNPrice_Mgmt.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSaveData: 진입점 집계 — C3 3요소: REVIEW:3 |  | 55 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData:) |
| WK-DMF0082-0468 | C3 | DMF0082_FcstNPrice_Mgmt.SetSaveDataRemov | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSaveDataRemove: 진입점 집계 — C3 1요소: REVIEW:1 |  | 25 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveDataR) |
| WK-DMF0082-0469 | C3 | DMF0082_FcstNPrice_Mgmt.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadColumn: 진입점 집계 — C3 1요소: REVIEW:1 |  | 12 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0470 | C3 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0471 | C3 | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedInde: 진입점 집계 — C3 4요소: REVIEW:4 |  | 29 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0472 | C3 | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged: 진입점 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0473 | C3 | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexC: 진입점 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0474 | C3 | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChang: 진입점 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0475 | C3 | DMF0082_FcstNPrice_Mgmt.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_Changed: 진입점 집계 — C3 33요소: REVIEW:32 · NA:1 |  | 330 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0476 | C3 | DMF0082_FcstNPrice_Mgmt.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_ComboSelChange: 진입점 집계 — C3 5요소: REVIEW:5 |  | 50 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0477 | C3 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E: 원장 V-668a5a93 ASIS / 원장 V-eec1e5d9 ASIS / 원장 V-144344f3 ASIS / 원장 V-7d5031a4 ASIS / 원장 V-7ea48dd6 ASIS / 원장 V-3388a |  | 3 (EVENT:E-03 EVENT:E-12 ACT:DMF0082_FcstNP) |
| WK-DMF0082-0478 | C3 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E01: 행 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 1 (E01) |
| WK-DMF0082-0479 | C3 | END_CUSTOMER / End Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — END_CUSTOMER / End Customer: 실측[T-248a2a81]: END_CUSTOMER 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 7 (D-11 D-17 EVENT:E-03 HANDLER:spdMain_Com) |
| WK-DMF0082-0480 | C3 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — F: 원장 V-668a5a93 ASIS / 원장 V-eec1e5d9 ASIS / 원장 V-144344f3 ASIS / 원장 V-7d5031a4 ASIS / 원장 V-7ea48dd6 ASIS / 원장 V-3388a |  | 1 (F-04) |
| WK-DMF0082-0481 | C3 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-d046707d]: FCST_TYPE 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 1 (F-04) |
| WK-DMF0082-0482 | C3 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0082-0483 | C3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — I: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 130 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.D) |
| WK-DMF0082-0484 | C3 | I,I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — I,I: 원장 V-ebab0b3c / 실측[T-a18fba92]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0485 | C3 | INCOTERMS / Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — INCOTERMS / Incoterms: 실측[T-0002c916]: INCOTERMS 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 3 (M-24 E01-A HANDLER:spdMain_ComboSelChang) |
| WK-DMF0082-0486 | C3 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — L: 실측[T-8f80bdf6]: L 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 4 (L-06 L-07 L-08 L-09) |
| WK-DMF0082-0487 | C3 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — M: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 24 (M-08 M-09 M-13 M-14 M-15 M-16 M-17 M-18 ) |
| WK-DMF0082-0488 | C3 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — MEASURE / Measure: 원장 V-144344f3 ASIS / 원장 V-661573f0 ASIS / 원장 V-a8e89e4c ASIS / 원장 V-710c08fd ASIS / 원장 V-344223e3 A |  | 54 (L-06 M-08 M-09 E01-A ACT:DMF0082_FcstNPr) |
| WK-DMF0082-0489 | C3 | MEASURE,MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — MEASURE,MEASURE: 원장 V-661573f0 / 실측[T-5b11bdae]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) —  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0490 | C3 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — N: 원장 V-668a5a93 ASIS / 원장 V-eec1e5d9 ASIS / 원장 V-7d5031a4 ASIS / 원장 V-7ea48dd6 ASIS / 원장 V-3388ac32 ASIS / 원장 V-dbbfc |  | 4 (E07 E07-B EVENT:E-12 HANDLER:spdMain_Cli) |
| WK-DMF0082-0491 | C3 | REQ:1ST-48-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — REQ:1ST-48-3: 행 집계 — C3 65요소: REVIEW:60 · NA:5 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0492 | C3 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — S: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 원장 V-d74cfd8b ASIS / 원장 V-668a5a93 ASIS / 원장 V-eec1e |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0493 | C3 | S,S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — S,S: 원장 V-ecc3018d / 실측[T-8fa6b243]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: 원장 행  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0494 | C3 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM_SITE_ID / Sales Site: 실측[T-828da07f]: SCM_SITE_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 3 (E01-A EVENT:E-03 HANDLER:spdMain_ComboSe) |
| WK-DMF0082-0495 | C3 | VMI_YN / VMI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — VMI_YN / VMI: 실측[T-25377caa]: VMI_YN 연쇄 원천 컬럼 해석 불가 — AS-IS  |  | 1 (E01-A) |
| WK-DMF0082-0496 | C3 | YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — YYYYMMDD: 원장 V-52d95c85 ASIS / 원장 V-cae9fa96 ASIS / 원장 V-2bdb5e3c ASIS / 실측[T-bf53938e]: YYYYMMDD 연쇄 원천 컬럼 해석 불가 — AS- |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData ) |
| WK-DMF0082-0497 | C3 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(": 원장 V-52d95c85 / 실측[T-06df7aae]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0498 | C3 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(s: 원장 V-2bdb5e3c / 실측[T-d1d2fff5]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0499 | C3 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(t: 원장 V-cae9fa96 / 실측[T-6bd4fb76]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0500 | C3 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(t: 원장 V-d74cfd8b / 실측[T-aa24bc2d]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0501 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-144344f3 / 실측[T-12ee7f06]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0502 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-7d5031a4 / 실측[T-bdad6248]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0503 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-7ea48dd6 / 실측[T-b216a44e]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0504 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-3388ac32 / 실측[T-59438699]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0505 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-dbbfceda / 실측[T-ff71330b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0506 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-83cbbe3f / 실측[T-578d6e2b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0507 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-2a791517 / 실측[T-e8bed6c9]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0508 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-fa6fed10 / 실측[T-7e08a315]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0509 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-025b5930 / 실측[T-a9115840]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0510 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-52f9e8b4 / 실측[T-61e92e54]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0511 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-bf447734 / 실측[T-8624081a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0512 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-5c3c5b11 / 실측[T-fcfcddff]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0513 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-0348689e / 실측[T-5a45110c]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0514 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-38164435 / 실측[T-a9b14203]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0515 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-ef9945ee / 실측[T-773cbfa1]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0516 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-8db421ae / 실측[T-9a3d4568]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0517 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-284fbef5 / 실측[T-4df24cef]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0518 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-92ff8e77 / 실측[T-c9a28111]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0519 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-c88b3a3e / 실측[T-79060d62]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0520 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-d4e9170b / 실측[T-79ea47e5]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0521 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-2ebb6825 / 실측[T-c87b3680]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0522 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-a8e89e4c / 실측[T-5f854cca]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0523 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-710c08fd / 실측[T-b5c9a71e]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0524 | C3 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetText: 원장 V-344223e3 / 실측[T-2cb9f646]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0525 | C3 | siMain.SetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — siMain.SetValue: 원장 V-7fdcd22d / 실측[T-c99492a6]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) —  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0526 | C6 | AS_FROM_SITE / AS From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — AS_FROM_SITE / AS From Site: 실측[T-e4b402bd]: AS_FROM_SITE 연쇄 원천 해석 불가 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0527 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-b90fc28f ASIS / 원장 V-8f8df76a ASIS / 원장 V-74685f57 ASIS / 원장 V-84dbc938 ASIS / 원장 V-01d95263 ASIS / 원장 V- |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0528 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-b90fc28f / 실측[T-684022d6]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0529 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-8f8df76a / 실측[T-1264e8b0]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0530 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-74685f57 / 실측[T-8c14e312]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0531 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-84dbc938 / 실측[T-03bb08de]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0532 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-01d95263 / 실측[T-48ece565]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0533 | C6 | BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — BUCKET: 원장 V-628bae47 / 실측[T-e8a8a5bc]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verif |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0534 | C6 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — C: 원장 V-cab4a763 ASIS / 원장 V-6ddbc2dc ASIS / 원장 V-7dc92384 ASIS / 원장 V-e5cbcb2b ASIS / 원장 V-b90fc28f ASIS / 원장 V-8f8df |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0535 | C6 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-8c197919 ASIS / 원장 V-55ae599f ASIS / 원장 V-bfc29a36 ASIS / 실측[T-0d8b3510]: CEL |  | 10 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0536 | C6 | CELL_PROD_SITE_ID,CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CELL_PROD_SITE_ID,CELL_PROD_SITE_ID: 원장 V-8c197919 / 실측[T-800319ea]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0537 | C6 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — CURRENCY / Currency: 실측[T-8553fdf6]: CURRENCY 연쇄 원천 해석 불가 |  | 9 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.spdMain) |
| WK-DMF0082-0538 | C6 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D: 원장 V-cab4a763 ASIS / 원장 V-6ddbc2dc ASIS / 원장 V-7dc92384 ASIS / 원장 V-e5cbcb2b ASIS / 원장 V-b90fc28f ASIS / 원장 V-8f8df |  | 8 (D-10 D-11 D-12 D-13 D-17 D-18 ACT:DMF008) |
| WK-DMF0082-0539 | C6 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DIVISION_ID / Div: 실측[T-52567bb0]: DIVISION_ID 연쇄 원천 해석 불가 |  | 6 (D-17 D-18 HANDLER:spdMain_ComboSelChange) |
| WK-DMF0082-0540 | C6 | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedInde: 진입점 집계 — C6 4요소: REVIEW:4 |  | 29 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0541 | C6 | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged: 진입점 집계 — C6 60요소: REVIEW:60 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0542 | C6 | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexC: 진입점 집계 — C6 60요소: REVIEW:60 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0543 | C6 | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChang: 진입점 집계 — C6 60요소: REVIEW:60 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0544 | C6 | DMF0082_FcstNPrice_Mgmt.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_Changed: 진입점 집계 — C6 33요소: REVIEW:33 |  | 330 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0545 | C6 | DMF0082_FcstNPrice_Mgmt.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_ComboSelChange: 진입점 집계 — C6 5요소: REVIEW:5 |  | 50 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Comb) |
| WK-DMF0082-0546 | C6 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E: 원장 V-b90fc28f ASIS / 원장 V-8f8df76a ASIS / 원장 V-d63a7242 ASIS / 원장 V-5e63d70f ASIS / 원장 V-bfa2c84e ASIS / 원장 V-315fc |  | 2 (EVENT:E-03 ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0547 | C6 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E01: 행 집계 — C6 60요소: REVIEW:60 |  | 1 (E01) |
| WK-DMF0082-0548 | C6 | END_CUSTOMER / End Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — END_CUSTOMER / End Customer: 실측[T-14f4a514]: END_CUSTOMER 연쇄 원천 해석 불가 |  | 4 (D-11 D-17 EVENT:E-03 HANDLER:spdMain_Com) |
| WK-DMF0082-0549 | C6 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — F: 원장 V-b90fc28f ASIS / 원장 V-8f8df76a ASIS / 원장 V-d63a7242 ASIS / 원장 V-5e63d70f ASIS / 원장 V-bfa2c84e ASIS / 원장 V-315fc |  | 1 (F-04) |
| WK-DMF0082-0550 | C6 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-6986e3e1]: FCST_TYPE 연쇄 원천 해석 불가 |  | 1 (F-04) |
| WK-DMF0082-0551 | C6 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C6 60요소: REVIEW:60 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0082-0552 | C6 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — I: 원장 V-cab4a763 ASIS / 원장 V-6ddbc2dc ASIS / 원장 V-7dc92384 ASIS / 원장 V-e5cbcb2b ASIS / 원장 V-b90fc28f ASIS / 원장 V-8f8df |  | 125 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.spdMain) |
| WK-DMF0082-0553 | C6 | I,I | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — I,I: 원장 V-b347bc7a / 실측[T-cdb22d40]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0554 | C6 | INCOTERMS / Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — INCOTERMS / Incoterms: 실측[T-0831c1b1]: INCOTERMS 연쇄 원천 해석 불가 |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0082-0555 | C6 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — ITEM_ID / Model: 실측[T-17cc4d7c]: 원천 PROJECT_CODE 신규행 편집 불가 |  | 4 (HANDLER:spdMain_ComboSelChange ACT:DMF00) |
| WK-DMF0082-0556 | C6 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — L: 실측[T-91935390]: L 연쇄 원천 해석 불가 |  | 4 (L-06 L-07 L-08 L-09) |
| WK-DMF0082-0557 | C6 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — M: 원장 V-cab4a763 ASIS / 원장 V-6ddbc2dc ASIS / 원장 V-7dc92384 ASIS / 원장 V-e5cbcb2b ASIS / 원장 V-b90fc28f ASIS / 원장 V-8f8df |  | 16 (M-08 M-09 M-13 M-14 M-15 M-16 M-17 M-18 ) |
| WK-DMF0082-0558 | C6 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — MEASURE / Measure: 원장 V-d63a7242 ASIS / 원장 V-55ae599f ASIS / 원장 V-046ad505 ASIS / 원장 V-300736d4 ASIS / 원장 V-3d4cbf88 A |  | 42 (L-06 M-08 M-09 ACT:DMF0082_FcstNPrice_Mg) |
| WK-DMF0082-0559 | C6 | MEASURE,MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — MEASURE,MEASURE: 원장 V-55ae599f / 실측[T-6a27530c]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0560 | C6 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — PLANT_SITE_ID / Plant Site: 실측[T-2ad209d3]: 원천 PROJECT_CODE 신규행 편집 불가 |  | 4 (D-18 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0561 | C6 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-7376ce77]: 원천 ITEM_ID 신규행 편집 불가 |  | 11 (D-10 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0562 | C6 | REQ:1ST-48-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — REQ:1ST-48-3: 행 집계 — C6 60요소: REVIEW:60 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0563 | C6 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — S: 원장 V-cab4a763 ASIS / 원장 V-6ddbc2dc ASIS / 원장 V-7dc92384 ASIS / 원장 V-e5cbcb2b ASIS / 원장 V-b90fc28f ASIS / 원장 V-8f8df |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0564 | C6 | S,S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — S,S: 원장 V-85ae1344 / 실측[T-9526ad9b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실행(@verify)  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0565 | C6 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCM_SITE_ID / Sales Site: 실측[T-5c810299]: SCM_SITE_ID 연쇄 원천 해석 불가 |  | 2 (EVENT:E-03 HANDLER:spdMain_ComboSelChang) |
| WK-DMF0082-0566 | C6 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(": 원장 V-cab4a763 / 실측[T-955fc633]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0567 | C6 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(s: 원장 V-7dc92384 / 실측[T-6aa1a44a]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0568 | C6 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(t: 원장 V-6ddbc2dc / 실측[T-1052d423]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0569 | C6 | siMain.ActiveSheet.Columns[siMain.GetCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.ActiveSheet.Columns[siMain.GetColumnIndex(t: 원장 V-e5cbcb2b / 실측[T-ae2fab3a]: 검사기 있음(_verify.spec(@verify) · _tr |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0570 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-d63a7242 / 실측[T-d902d12c]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0571 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-5e63d70f / 실측[T-6dc6bd03]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0572 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-bfa2c84e / 실측[T-8218b322]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0573 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-315fc7d7 / 실측[T-33f7c221]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0574 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-5d1aa878 / 실측[T-0bc53d46]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0575 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-77ec557e / 실측[T-0c1d422d]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0576 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-91ef8614 / 실측[T-8459dcb4]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0577 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-32b4e126 / 실측[T-58104e54]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0578 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-20f94e44 / 실측[T-6639569f]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0579 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-6c4e7515 / 실측[T-7900a47a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0580 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-ef9d6e49 / 실측[T-3cda37d7]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0581 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-0c4f141b / 실측[T-b979de25]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0582 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-84df9dda / 실측[T-6cab4a7c]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0583 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-d48ae44e / 실측[T-b9d0b75b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0584 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-b9360686 / 실측[T-72cfe5ff]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0585 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-377c8e65 / 실측[T-5c60c2eb]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0586 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-0d455ab7 / 실측[T-0db934c4]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0587 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-a52dd22a / 실측[T-1ed45233]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0588 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-12e855ce / 실측[T-b43791a6]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0589 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-fe8fefca / 실측[T-702ebb95]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0590 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-dfc3154a / 실측[T-7c18757b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 실 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0591 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-046ad505 / 실측[T-c087c8ba]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0592 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-300736d4 / 실측[T-816fca95]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0593 | C6 | siMain.SetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetText: 원장 V-3d4cbf88 / 실측[T-d9bf3b72]: 검사 대상 아님 — 대조표 DP-13 가 Dsdm_Changed 를 '제외'(사유: AS-IS 원문이 **이벤트 미배선(잠재  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0594 | C6 | siMain.SetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — siMain.SetValue: 원장 V-bfc29a36 / 실측[T-76c97692]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0595 | B1 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — DIVISION_ID / Div: 원장 V-f7d83343 COLUMN |  | 1 (E01-A) |
| WK-DMF0082-0596 | B1 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — F: 실측[T-5e2cd5b9]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0597 | B1 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — I: 실측[T-e2b81798]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 6 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0598 | B1 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — M: 실측[T-6453f206]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (M-08) |
| WK-DMF0082-0599 | B1 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — PLANT_SITE_ID / Plant Site: 원장 V-d1acd3b0 COLUMN |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0600 | B1 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-eff4010b]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trac |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0601 | B1 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — S: 실측[T-1118fe15]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (F-02) |
| WK-DMF0082-0602 | B1 | VMI_YN / VMI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — VMI_YN / VMI: 원장 V-60e6b0b4 COLUMN |  | 1 (E01-A) |
| WK-DMF0082-0603 | B2 | A-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — A-11: 행 집계 — B2 15요소: REVIEW:8 · PASS:7 |  | 1 (A-11) |
| WK-DMF0082-0604 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 15요소: REVIEW:8 · PASS:7 |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0605 | B2 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — DIVISION_ID / Div: 원장 V-80d18c75 COLUMN |  | 1 (E01-A) |
| WK-DMF0082-0606 | B2 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — F: 실측[T-7381a541]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0607 | B2 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — I: 실측[T-fc9758bd]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 6 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0608 | B2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — M: 실측[T-c13fc0a7]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (M-08) |
| WK-DMF0082-0609 | B2 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — PLANT_SITE_ID / Plant Site: 원장 V-94f004ed COLUMN |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0610 | B2 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-ac148bda]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trac |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0611 | B2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — S: 실측[T-18f1dc1d]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (F-02) |
| WK-DMF0082-0612 | B2 | VMI_YN / VMI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — VMI_YN / VMI: 원장 V-6d2bc1dd COLUMN |  | 1 (E01-A) |
| WK-DMF0082-0613 | B3 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B: 실측[T-fa0c6a34]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 1 (E01-B) |
| WK-DMF0082-0614 | B3 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — CURRENCY / Currency: 원장 V-dd956481 COLUMN |  | 6 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0615 | B3 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DIVISION_ID / Div: 원장 V-f93f3f9a COLUMN |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0616 | B3 | DMF0082_FcstNPrice_Mgmt.GetFuturePriceIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo: 진입점 집계 — B3 1요소: REVIEW:1 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0617 | B3 | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 — B3 1요소: REVIEW:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0618 | B3 | DMF0082_FcstNPrice_Mgmt.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSpdTitle: 진입점 집계 — B3 2요소: REVIEW:1 · PASS:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetSpdTitle:) |
| WK-DMF0082-0619 | B3 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — F: 실측[T-5324f40f]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 1 (F-09) |
| WK-DMF0082-0620 | B3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — I: 실측[T-c6477149]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0621 | B3 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — P: 실측[T-7a5d09ed]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0622 | B3 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-6d704335]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0623 | B3 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — S: 실측[T-98f0b3b7]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 1 (S-08) |
| WK-DMF0082-0624 | B3 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — drpDateTime / Date Time: 실측[T-3aa9c7d4]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0625 | B3 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — drpPeriod / Period: 실측[T-d5b14054]: 검사기 미구현(검증 엔진 확장 대상): 콤보 후보 정렬 = AS-IS |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0626 | B4 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B: 실측[T-88a3732b]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 1 (E01-B) |
| WK-DMF0082-0627 | B4 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CURRENCY / Currency: 원장 V-1e68b236 COLUMN |  | 10 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.InsertR) |
| WK-DMF0082-0628 | B4 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DIVISION_ID / Div: 원장 V-8b6fcf9f COLUMN |  | 5 (E01-A ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0629 | B4 | DMF0082_FcstNPrice_Mgmt.GetFuturePriceIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo: 진입점 집계 — B4 1요소: REVIEW:1 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0630 | B4 | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 — B4 1요소: REVIEW:1 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0631 | B4 | DMF0082_FcstNPrice_Mgmt.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSpdTitle: 진입점 집계 — B4 2요소: REVIEW:1 · PASS:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetSpdTitle:) |
| WK-DMF0082-0632 | B4 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — F: 실측[T-0d5cd837]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0633 | B4 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — I: 실측[T-b80aaa0c]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 8 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0634 | B4 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — M: 실측[T-f22f7ff9]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 1 (M-08) |
| WK-DMF0082-0635 | B4 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — P: 실측[T-b2867cbd]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0636 | B4 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — PLANT_SITE_ID / Plant Site: 원장 V-08c9c060 COLUMN |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0637 | B4 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-bcd52cd5]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace  |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0638 | B4 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — S: 실측[T-9b11e237]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사기( |  | 2 (F-02 S-08) |
| WK-DMF0082-0639 | B4 | VMI_YN / VMI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — VMI_YN / VMI: 원장 V-c5321dd5 COLUMN |  | 1 (E01-A) |
| WK-DMF0082-0640 | B4 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — drpDateTime / Date Time: 실측[T-fc9d8c9d]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는  |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0641 | B4 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — drpPeriod / Period: 실측[T-2962ff45]: 검사기(combo_oracle.py(W1))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledge |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0642 | G3 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G3 기대값 확정 — DMF0082 화면: 원장 V-38a8a336 RULE_SCREEN / 원장 V-73a61f7a CONFIRMED |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0082-0643 | F1 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F1 기대값 확정 — DMF0082 화면: 원장 V-2e024804 RULE_SCREEN / 원장 V-9e902224 DEFECT / 원장 V-30c59d4d DEFECT / 원장 V-22eb624c DEFECT / 원장 V-58bf |  | 534 (E02 E04 E06 A-03 A-04 A-05 A-06 A-15 D-0) |
| WK-DMF0082-0644 | F2 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F2 기대값 확정 — DMF0082 화면: 원장 V-24f1e2df RULE_SCREEN / 원장 V-7ae57de1 DEFECT |  | 398 (E02 E04 D-03 D-04 D-14 D-15 D-16 DP-04 D) |
| WK-DMF0082-0645 | F6 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F6 기대값 확정 — DMF0082 화면: 원장 V-1bdd1cf9 RULE_SCREEN / 원장 V-da2cd575 DEFECT / 원장 V-8c5715f2 DEFECT |  | 370 (E02 E04 A-15 D-14 D-15 D-16 DP-06 DP-07 ) |
| WK-DMF0082-0646 | DB-SYN | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — A-15: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (A-15) |
| WK-DMF0082-0647 | DB-SYN | CRUD:E02:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E02:SAVE: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (CRUD:E02:SAVE) |
| WK-DMF0082-0648 | DB-SYN | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E04:SAVE: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0649 | DB-SYN | CRUD:E05:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E05:SEARCH: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0650 | DB-SYN | D-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D-14: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (D-14) |
| WK-DMF0082-0651 | DB-SYN | D-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D-15: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (D-15) |
| WK-DMF0082-0652 | DB-SYN | D-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D-16: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (D-16) |
| WK-DMF0082-0653 | DB-SYN | DMF0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0003_GET_BUCKET_TYPE_CODE: 실측[T-c8d289e3]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0654 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0655 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0656 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetFcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0657 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetFuturePriceIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0658 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0659 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0660 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetSalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0661 | DB-SYN | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0662 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetDayRange: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0663 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetFu | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetFuturePriceI: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0664 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetMe | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCount: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0665 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetSa | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFrom: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0666 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0667 | DB-SYN | DMF0082_SaveSalesFuturePrice_Popup.GetWe | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetWeekData: 진입점 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0668 | DB-SYN | DP-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DP-06: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (DP-06) |
| WK-DMF0082-0669 | DB-SYN | DP-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DP-07: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (DP-07) |
| WK-DMF0082-0670 | DB-SYN | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E02: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (E02) |
| WK-DMF0082-0671 | DB-SYN | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E04: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (E04) |
| WK-DMF0082-0672 | DB-SYN | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E05: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (E05) |
| WK-DMF0082-0673 | DB-SYN | F-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — F-02: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (F-02) |
| WK-DMF0082-0674 | DB-SYN | F-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — F-05: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (F-05) |
| WK-DMF0082-0675 | DB-SYN | F-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — F-06: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (F-06) |
| WK-DMF0082-0676 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0677 | DB-SYN | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:SaveData: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0678 | DB-SYN | M-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — M-11: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (M-11) |
| WK-DMF0082-0679 | DB-SYN | M-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — M-12: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (M-12) |
| WK-DMF0082-0680 | DB-SYN | P-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — P-24: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (P-24) |
| WK-DMF0082-0681 | DB-SYN | PKG_DMF0082 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — PKG_DMF0082: 실측[T-a93f7966]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 led |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0682 | DB-SYN | PL-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — PL-36: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (PL-36) |
| WK-DMF0082-0683 | DB-SYN | POPUP_GET_FUTUREPRICE_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — POPUP_GET_FUTUREPRICE_INFO: 실측[T-46efc329]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0684 | DB-SYN | S-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — S-07: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (S-07) |
| WK-DMF0082-0685 | DB-SYN | S-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — S-19: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (S-19) |
| WK-DMF0082-0686 | DB-SYN | S-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — S-24: 행 집계 — DB-SYN 16요소: PASS:11 · REVIEW:5 |  | 1 (S-24) |
| WK-DMF0082-0687 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 실측[T-c1c69594]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔 |  | 3 (DPF-09 ACT:DMF0082_FcstNPrice_Mgmt.GetBi) |
| WK-DMF0082-0688 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 실측[T-70c735bd]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요 |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0689 | F4 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 실측[T-681bc8bc]: DMF0073_GET_VERSION_SALESPRICE: DMF0020/version/SEARCH, DMF0035/versio |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0690 | F4 | PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPU | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: 실측[T-014e5d49]: PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: DMF008 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0691 | F4 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP: 실측[T-b5735f85]: PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP: DM |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0692 | F4 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 실측[T-d6810ba0]: PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: DMF0003/Mkt Fcst/COL |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0693 | F4 | PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD: 실측[T-eb47ee88]: PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD: DMF0082/FcstNPrice/UPLOAD, DMF |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0694 | F4 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURR | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: 실측[T-dda90ac3]: PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: DMF0082/Fcst |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0695 | F4 | PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPR | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO: 실측[T-a00415aa]: PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO: DM |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0696 | F4 | PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA: 실측[T-e6df381c]: PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA: DMF0082/FcstNPrice/SAVE, D |  | 352 (S-22 REQ:CHAT-20260915-PRICEPJTGAP DPF-1) |
| WK-DMF0082-0697 | A5 | AS_FROM_SITE / AS From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — AS_FROM_SITE / AS From Site: 실측[T-434b143f]: AS_FROM_SITE: AS-IS(Div 40) '선택' ↔ TO-BE 표시=N — AS-IS 코드 추가 컬럼의 표시 여부는 원문 |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0698 | A5 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — B: 실측[T-1de02830]: B 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0699 | A5 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — BIZ_TYPE / Biz Type: 실측[T-aa4da160]: BIZ_TYPE 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 1 (EVENT:E-09) |
| WK-DMF0082-0700 | A5 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D: 실측[T-36faad38]: D 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 1 (EVENT:E-15) |
| WK-DMF0082-0701 | A5 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E: 실측[T-bec9c069]: E 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 13 (EVENT:E-03 EVENT:E-04 EVENT:E-05 EVENT:E) |
| WK-DMF0082-0702 | A5 | ITEM_NAME / Model Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ITEM_NAME / Model Name: 실측[T-61df5478]: ITEM_NAME: AS-IS(Div 40) '선택' ↔ TO-BE 표시=N — AS-IS 코드 추가 컬럼의 표시 여부는 원문 확인(Init |  | 1 (EVENT:E-10) |
| WK-DMF0082-0703 | A5 | ITEM_TYPE / Item Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ITEM_TYPE / Item Type: 실측[T-3628bf4e]: ITEM_TYPE: AS-IS(Div 40) '선택' ↔ TO-BE 표시=N — AS-IS 코드 추가 컬럼의 표시 여부는 원문 확인(InitS |  | 1 (EVENT:E-10) |
| WK-DMF0082-0704 | A5 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — L: 실측[T-6ea227e8]: L 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 2 (L-14 PL-00) |
| WK-DMF0082-0705 | A5 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — N: 실측[T-77cfe411]: N 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 2 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) ) |
| WK-DMF0082-0706 | A5 | OWNER / Owner | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — OWNER / Owner: 실측[T-65da905c]: OWNER: AS-IS(Div 40) '선택' ↔ TO-BE 표시=N — AS-IS 코드 추가 컬럼의 표시 여부는 원문 확인(InitSpread 가 Visi |  | 1 (EVENT:E-09) |
| WK-DMF0082-0707 | A5 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — P: 실측[T-a6165ce9]: P 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 1 (P-12) |
| WK-DMF0082-0708 | A5 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PLANT_SITE_ID / Plant Site: 실측[T-92be0c5b]: PLANT_SITE_ID 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 2 (REQ:1ST-39-2 EVENT:E-04) |
| WK-DMF0082-0709 | A5 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-311617a7]: PROJECT_CODE 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 1 (EVENT:E-09) |
| WK-DMF0082-0710 | A5 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PROJECT_NAME / Project: 실측[T-cbda9166]: PROJECT_NAME 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 1 (EVENT:E-09) |
| WK-DMF0082-0711 | A5 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — S: 실측[T-1c2d1ecc]: S 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) |  | 3 (S-07 S-24 EVENT:E-04) |
| WK-DMF0082-0712 | G4 | A-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — A-11: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (A-11) |
| WK-DMF0082-0713 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0714 | G4 | DP-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — DP-01: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (DP-01) |
| WK-DMF0082-0715 | G4 | EVENT:E-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — EVENT:E-14: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (EVENT:E-14) |
| WK-DMF0082-0716 | G4 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — HANDLER:Form_Load: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0717 | G4 | REQ:1ST-37-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — REQ:1ST-37-2: 행 집계 — G4 13요소: REVIEW:13 |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0718 | G4 | btnColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — btnColumn: 실측[T-2abe8903]: 검사기(smoke 화면 열림(labels)·_verify)는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger. |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0719 | G4 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — btnMeasure: 실측[T-965a8b4b]: 검사기(smoke 화면 열림(labels)·_verify)는 있으나 이 대상(BTN)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0720 | G4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 실측[T-44442445]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.DefineProper) |
| WK-DMF0082-0721 | G4 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — chkSum / Sum: 실측[T-124c05e1]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_verify)가 이 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0722 | G4 | clbBizType / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbBizType / Biz Type: 실측[T-dfcf7638]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_v |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0723 | G4 | clbCustomer / End Customer / Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbCustomer / End Customer / Customer: 실측[T-7618544d]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke  |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0724 | G4 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbDivision / Division: 실측[T-62b53f5b]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_ |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0725 | G4 | clbDivisions / Division / Divisions | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbDivisions / Division / Divisions: 실측[T-f36de5dc]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 |  | 12 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0726 | G4 | clbSalesSite / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbSalesSite / Sales Site: 실측[T-9a904c00]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0727 | G4 | clbTeam / Team | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — clbTeam / Team: 실측[T-20f1994f]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_verify)가 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0728 | G4 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — drpDateTime / Date Time: 실측[T-676451ad]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)· |  | 21 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0729 | G4 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — drpPeriod / Period: 실측[T-1b3d0f40]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_veri |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:170) |
| WK-DMF0082-0730 | G4 | txtVersion / Version | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — txtVersion / Version: 실측[T-762604a0]: 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke / 검사기(smoke 화면 열림(labels)·_ve |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0731 | H2 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C: 원장 V-b28b8f22 ASIS / 원장 V-c01f87b1 ASIS / 원장 V-6889f9e7 ASIS / 원장 V-6e6a3a41 ASIS / 원장 V-94bc8e2f ASIS / 원장 V-0466c |  | 1 (E08-C) |
| WK-DMF0082-0732 | H2 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D: 원장 V-e0adbcbc ASIS / 원장 V-280085f3 ASIS / 실측[T-88dca8fc]: D 현재 그리드에 없음 |  | 1 (EVENT:E-15) |
| WK-DMF0082-0733 | H2 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E: 원장 V-c006158e ASIS / 실측[T-93f0b38a]: E 현재 그리드에 없음 |  | 13 (EVENT:E-03 EVENT:E-04 EVENT:E-05 EVENT:E) |
| WK-DMF0082-0734 | H2 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — L: 원장 V-e0adbcbc ASIS / 원장 V-c006158e ASIS / 원장 V-280085f3 ASIS / 실측[T-b23c0748]: L 현재 그리드에 없음 |  | 15 (L-01 L-02 L-03 L-04 L-05 L-06 L-07 L-08 ) |
| WK-DMF0082-0735 | H2 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — M: 원장 V-c01f87b1 ASIS / 원장 V-6889f9e7 ASIS / 원장 V-6e6a3a41 ASIS / 원장 V-94bc8e2f ASIS / 원장 V-e0adbcbc ASIS / 원장 V-40839 |  | 1 (L-12) |
| WK-DMF0082-0736 | H2 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — N: 원장 V-e0adbcbc ASIS / 원장 V-280085f3 ASIS / 실측[T-2748e74e]: N 현재 그리드에 없음 |  | 2 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) ) |
| WK-DMF0082-0737 | H2 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — PROJECT_CODE / Project Code: 원장 V-2d6e550e COLUMN / 원장 V-280085f3 ASIS / 실측[T-3bf24ac4]: PROJECT_CODE 현재 그리드에 없음 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0738 | H2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — S: 원장 V-b28b8f22 ASIS / 원장 V-c01f87b1 ASIS / 원장 V-6889f9e7 ASIS / 원장 V-6e6a3a41 ASIS / 원장 V-94bc8e2f ASIS / 원장 V-0466c |  | 4 (S-07 S-09 S-16 EVENT:E-04) |
| WK-DMF0082-0739 | H2 | siMain.ActiveSheet.SetActiveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.ActiveSheet.SetActiveCell: 원장 V-cd8e2ff6 / 실측[T-b571b437]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0740 | H2 | siMain.SetBGColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SetBGColor: 원장 V-c01f87b1 / 실측[T-b3ebaddd]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.Draw:1960:85) |
| WK-DMF0082-0741 | H2 | siMain.SetBGColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SetBGColor: 원장 V-6889f9e7 / 실측[T-4e3cf9c8]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.Draw:1966:87) |
| WK-DMF0082-0742 | H2 | siMain.SetBGColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SetBGColor: 원장 V-10b80925 / 실측[T-c52da463]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0743 | H2 | siMain.SetBGColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SetBGColor: 원장 V-29828be5 / 실측[T-942afff5]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0744 | H2 | siMain.SetBGColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SetBGColor: 원장 V-c006158e / 실측[T-e94c0c05]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장  |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0745 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SpreadObject.ActiveSheet.SetActiveCell: 원장 V-280085f3 / 실측[T-e5731995]: 검사기 있음(_verify.spec(@verify) · _trace.s |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0746 | H2 | siMain.SpreadObject.SetViewportTopRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — siMain.SpreadObject.SetViewportTopRow: 원장 V-e0adbcbc / 실측[T-72bf2955]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@tra |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:217) |
| WK-DMF0082-0747 | H2 | sv.SetActiveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — sv.SetActiveCell: 원장 V-b28b8f22 / 실측[T-763cf7b9]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: 원장 행 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0748 | H5 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A-15: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (A-15) |
| WK-DMF0082-0749 | H5 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — B: 실측[T-98fb280d]: B 현재 그리드에 없음 — 표시 여부는 A5 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0750 | H5 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — BIZ_TYPE / Biz Type: 실측[T-7a939f3a]: BIZ_TYPE 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0751 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0752 | H5 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D: 실측[T-ae09a5e5]: D 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-15) |
| WK-DMF0082-0753 | H5 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DIVISION_ID / Div: 실측[T-e68cce4b]: DIVISION_ID: AS-IS 'Division' ↔ TO-BE 헤더 'Div' — 메타 라벨(SHEET_COLUMNS 'Div')대로 표시됨.  |  | 1 (EVENT:E-04) |
| WK-DMF0082-0754 | H5 | DMF0082_FcstNPrice_Mgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0755 | H5 | DMF0082_FcstNPrice_Mgmt.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadColumn: 진입점 집계 — H5 3요소: REVIEW:3 |  | 12 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0756 | H5 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0757 | H5 | DPF-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DPF-01: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (DPF-01) |
| WK-DMF0082-0758 | H5 | DPF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DPF-04: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (DPF-04) |
| WK-DMF0082-0759 | H5 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E: 실측[T-fcd4d00f]: E 현재 그리드에 없음 — 표시 여부는 A5 |  | 13 (EVENT:E-03 EVENT:E-04 EVENT:E-05 EVENT:E) |
| WK-DMF0082-0760 | H5 | ITEM_TYPE / Item Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ITEM_TYPE / Item Type: 실측[T-b3dc4e5b]: ITEM_TYPE 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-10) |
| WK-DMF0082-0761 | H5 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — L: 실측[T-27ee69ef]: L 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (L-14 PL-00) |
| WK-DMF0082-0762 | H5 | L7 `titleSet` 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — L7 `titleSet` 시트: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0763 | H5 | MODAL:VersionSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — MODAL:VersionSelectModal: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0764 | H5 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — N: 실측[T-dfcb49ab]: N 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) ) |
| WK-DMF0082-0765 | H5 | OWNER / Owner | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — OWNER / Owner: 실측[T-c6e3569b]: OWNER 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0766 | H5 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — PLANT_SITE_ID / Plant Site: 실측[T-c67a9b75]: PLANT_SITE_ID 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-04) |
| WK-DMF0082-0767 | H5 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-9f95f399]: PROJECT_CODE 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0768 | H5 | REQ:CHAT-20260820-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260820-1: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0769 | H5 | REQ:CHAT-20260915-EXLASTUPD | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — H5 27요소: REVIEW:15 · PASS:8 · NA:4 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0770 | H5 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — S: 실측[T-2adf20ed]: S 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (S-07 EVENT:E-04) |
| WK-DMF0082-0771 | H5 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — cboBucketType / Bucket / Bucket Type: 원장 V-c066a4e0 SEARCH / 실측[T-5eefdd4f]: 검사기 있음(_verify·SC 게이트 · _trace.spec(@trac |  | 18 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0772 | H5 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum: 원장 V-a524d16a SEARCH / 실측[T-83f8f9e0]: 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(g |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0773 | H5 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — drpDateTime / Date Time: 실측[T-4d0d25bf]: 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effectiv |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0774 | SC1 | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — DMF0082 화면: 실측[T-1e7a67de]: 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke / 검사기(check.js SC1·smoke 기준표 순서)가 이 대상을  |  | 6 (A-11 DP-01 COMMON:UC-06 REQ:1ST-37-2 EVE) |
| WK-DMF0082-0775 | X-REASON | D-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D-02 OnShown / `sDivision == "40"` ForecastPriceForm BucketField 기본값 AS-IS 40 고정 화면의 Weekly 강제. TO-BE 는 divisio |  | 1 (D-02) |
| WK-DMF0082-0776 | X-REASON | DP-13 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — DP-13 Dsdm_Changed / SetExchangeValues / `81prefix` → PROJECT/ITEM 변경 시 PlantSite 콤보 (⚠ 이벤트 미배선… — AS-IS 원문이 ** |  | 1 (DP-13) |
| WK-DMF0082-0777 | X-REASON | E07-A | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E07-A §7-A spdMain_KeyUp (활성 신로직 L8384~L8425) — AS-IS 본문 = Ctrl+V 를 감지해 `fps.ActiveSheet.ClipboardPaste()` 를 ** |  | 1 (E07-A) |
| WK-DMF0082-0778 | X-REASON | EVENT:E-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — EVENT:E-01 DIVISION_ID → TEAM_ID 콤보 재조회 (`ComboSelChange` .cs:8217) — 트리거 `DIVISION_ID` **INPUT_TP_CD='S'**(조회전 |  | 1 (EVENT:E-01) |
| WK-DMF0082-0779 | X-REASON | EVENT:E-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — EVENT:E-02 DIVISION/TEAM → END_CUSTOMER 콤보 재조회 (.cs:8226~8231) — 트리거 둘 다 **INPUT_TP_CD='S'** — 발생 불가 해당없음 |  | 1 (EVENT:E-02) |
| WK-DMF0082-0780 | X-REASON | F-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — F-07 비교팝업 SP / `p_fcst_type` 전달 — SSP 비교 팝업(DMF0003_GET_MKT_FCST_COMPARE_POPUP) — E08-B·D-09 와 동일 보류(2026-07-20 |  | 1 (F-07) |
| WK-DMF0082-0781 | X-REASON | HANDLER:clbDivision_SelectedIndexChanged | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:clbDivision_SelectedIndexChanged AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3039` (라이브 2행) · **사문(빈 몸통)** — AS-I |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0082-0782 | X-REASON | HANDLER:spdMain_EditChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_EditChange AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8375` (라이브 4행) — AS-IS 본문 4행 = `bPasteContinue` 플래 |  | 1 (HANDLER:spdMain_EditChange) |
| WK-DMF0082-0783 | X-REASON | HANDLER:spdMain_KeyUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_KeyUp AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8384` (라이브 29행) — AS-IS 본문 = Ctrl+V 감지해 `fps.ActiveShee |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0082-0784 | X-REASON | HANDLER:spdMain_TopChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_TopChange AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8488` (5행) — `SmartColMerge()` 재계산 공용 `DataGrid` +  |  | 1 (HANDLER:spdMain_TopChange) |
| WK-DMF0082-0785 | X-REASON | HANDLER:txtVersion_KeyDown | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:txtVersion_KeyDown AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3419` (라이브 3행) · **사문(빈 몸통)** — AS-IS 본문 3행 = `btn |  | 1 (HANDLER:txtVersion_KeyDown) |
| WK-DMF0082-0786 | X-REASON | M-23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M-23 MKT_FCST / spdMain_CellDoubleClick — SSP 동기수량 비교 팝업 — D-09·E08-B 동일 보류 제외 |  | 1 (M-23) |
| WK-DMF0082-0787 | X-REASON | MODAL:DMF0003_SspSyncPopUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:DMF0003_SspSyncPopUp AS-IS 팝업 (분석 md) — 제외 — E08-B 와 동일(SSP 동기화 계열 보류) 제외 |  | 1 (MODAL:DMF0003_SspSyncPopUp) |
| WK-DMF0082-0788 | X-REASON | P-09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-09 12월 마지막주 W01+ 보정 / else: `Period 시작월 >= 당주월` 이면 당주컬럼 이후 W_ 전부 추가 (E20251202-000637 — 12월 … components/Fore |  | 1 (P-09) |
| WK-DMF0082-0789 | X-REASON | P-14 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-14 버킷 전환 시 Lock 복원 / Edit 상태(`!IsLock`)면: 이벤트 해제 → **이전 버킷(sBfBucket)으로 되돌려 EditButton() 실행(… — AS-IS 는 버킷 전환 |  | 1 (P-14) |
| WK-DMF0082-0790 | X-REASON | REQ:1ST-34-1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — REQ:1ST-34-1 모든 컬럼 추가 후 조회 시 Measure 영역이 화면에서 보여야 함  VISUAL 보류 — 육안 확인 필요 (원장 REQ 축, 사용자 확인 대기) 제외 |  | 1 (REQ:1ST-34-1) |
| WK-DMF0082-0791 | D1 | AUTHORITY_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — AUTHORITY_YN: 실측[T-d355a7d5]: AUTHORITY_YN AS-IS 편집 기대(edit_expect) 없음 |  | 39 (A-13 A-14 PL-21 PL-22 ACT:DMF0082_SaveSa) |
| WK-DMF0082-0792 | D1 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — B: 실측[T-749b5ba3]: B AS-IS 편집 기대(edit_expect) 없음 |  | 1 (E07-B) |
| WK-DMF0082-0793 | D1 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-f34a0ad8 COLUMN / 원장 V-cf328045 COLUMN / 실측[T-d20fe156]: 기존행 r0 CELL_PROD_SIT |  | 1 (D-07) |
| WK-DMF0082-0794 | D1 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CURRENCY / Currency: 원장 V-29b4458d COLUMN / 원장 V-cbd5eca8 COLUMN / 실측[T-85aa9bf1]: 기존행 r0 CURRENCY 편집=false — AS-IS 기대 |  | 1 (EVENT:E-08) |
| WK-DMF0082-0795 | D1 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D: 실측[T-02f62346]: D AS-IS 편집 기대(edit_expect) 없음 |  | 4 (D-03 D-07 D-18 REQ:1ST-43-1) |
| WK-DMF0082-0796 | D1 | DEPT_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DEPT_ID: 실측[T-99956d68]: DEPT_ID AS-IS 편집 기대(edit_expect) 없음 |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0797 | D1 | DEPT_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DEPT_NAME: 실측[T-9ff91e06]: DEPT_NAME AS-IS 편집 기대(edit_expect) 없음 |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0798 | D1 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DIVISION_ID / Div: 원장 V-911bf07e COLUMN / 원장 V-109b0929 COLUMN / 실측[T-21147f5f]: 기존행 r0 DIVISION_ID 편집=false — AS-IS 기 |  | 12 (D-18 PL-20 PL-24 PL-25 E01-A EVENT:E-04 ) |
| WK-DMF0082-0799 | D1 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E: 실측[T-46add1d9]: E AS-IS 편집 기대(edit_expect) 없음 |  | 4 (EVENT:E-04 EVENT:E-08 EVENT:E-11 EVENT:E) |
| WK-DMF0082-0800 | D1 | END_CUSTOMER / End Customer | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — END_CUSTOMER / End Customer: 원장 V-f1dc970f COLUMN / 원장 V-1b8f9552 COLUMN / 실측[T-ce933766]: 기존행 r0 END_CUSTOMER 편집=fals |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0801 | D1 | END_CUSTOMER40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — END_CUSTOMER40: 실측[T-e76ddf24]: END_CUSTOMER40 AS-IS 편집 기대(edit_expect) 없음 |  | 6 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0802 | D1 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — F: 실측[T-7679a99a]: F AS-IS 편집 기대(edit_expect) 없음 |  | 2 (F-01 M-04) |
| WK-DMF0082-0803 | D1 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — FCST_TYPE / FCST Type: 원장 V-c7098b2f COLUMN / 원장 V-ae8ae895 COLUMN / 실측[T-eb9064b5]: 기존행 r0 FCST_TYPE 편집=false — AS-IS |  | 1 (F-01) |
| WK-DMF0082-0804 | D1 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — I: 실측[T-cc8e3ad0]: I AS-IS 편집 기대(edit_expect) 없음 |  | 6 (A-14 PL-22 PL-25 S-14 E01-A ACT:DMF0082_) |
| WK-DMF0082-0805 | D1 | ITEM_CLASS_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ITEM_CLASS_NAME: 실측[T-bef0aa78]: ITEM_CLASS_NAME AS-IS 편집 기대(edit_expect) 없음 |  | 5 (PL-29 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0806 | D1 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ITEM_ID / Model: 원장 V-e882435f COLUMN / 원장 V-0195a281 COLUMN / 실측[T-752b0a22]: 기존행 r0 ITEM_ID 편집=false — AS-IS 기대 미식별( |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0807 | D1 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L: 실측[T-1e95eb6f]: L AS-IS 편집 기대(edit_expect) 없음 |  | 37 (L-01 L-02 L-03 L-04 L-05 L-06 L-07 L-08 ) |
| WK-DMF0082-0808 | D1 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — M: 실측[T-abd92e8a]: M AS-IS 편집 기대(edit_expect) 없음 |  | 13 (E03 L-12 M-03 M-04 M-05 M-06 M-07 M-09 M) |
| WK-DMF0082-0809 | D1 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — MEASURE / Measure: 원장 V-71fa15c3 COLUMN / 원장 V-578e8084 COLUMN / 실측[T-36a5ee5c]: 기존행 r0 MEASURE 편집=false — AS-IS 조건부(행 |  | 29 (A-02 L-06 L-10 M-09 PL-19 PL-20 PL-21 PL) |
| WK-DMF0082-0810 | D1 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — N: 실측[T-f4fb8c70]: N AS-IS 편집 기대(edit_expect) 없음 |  | 5 (E03 E07-B 버튼 노출 원천 = `buttonAuth` 시트 (20) |
| WK-DMF0082-0811 | D1 | NICK_NAME / Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — NICK_NAME / Nick Name: 원장 V-6c1a19c4 COLUMN / 원장 V-02ebb2d1 COLUMN / 실측[T-48da0d0b]: 기존행 r0 NICK_NAME 편집=false — AS-IS |  | 5 (PL-32 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0812 | D1 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — PLANT_SITE_ID / Plant Site: 원장 V-0d694557 COLUMN / 원장 V-c861e67e COLUMN / 실측[T-fc0aa6af]: PLANT_SITE_ID AS-IS 편집 기대(ed |  | 2 (D-18 EVENT:E-04) |
| WK-DMF0082-0813 | D1 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — PROJECT_CODE / Project Code: 원장 V-6363303f COLUMN / 원장 V-449cf8f9 COLUMN / 실측[T-e79b60d8]: PROJECT_CODE AS-IS 편집 기대(ed |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0814 | D1 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — PROJECT_NAME / Project: 원장 V-1f0d791c COLUMN / 원장 V-4f005094 COLUMN / 실측[T-7c7f292e]: PROJECT_NAME AS-IS 편집 기대(edit_ex |  | 6 (PL-26 ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0815 | D1 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — S: 실측[T-f29eee83]: S AS-IS 편집 기대(edit_expect) 없음 |  | 5 (S-12 S-13 S-14 S-15 EVENT:E-04) |
| WK-DMF0082-0816 | D1 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCM_SITE_ID / Sales Site: 원장 V-f7efae13 COLUMN / 원장 V-66c2ebfa COLUMN / 실측[T-b49d90f5]: 기존행 r0 SCM_SITE_ID 편집=false —  |  | 13 (E01-A ACT:DMF0082_SaveSalesFuturePrice_P) |
| WK-DMF0082-0817 | D4 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 실측[T-828ff27d]: 신규행 CELL_PROD_SITE_ID='NJ01-A' — AS-IS InsertButton 은 이 컬럼에 값을 넣지  |  | 1 (E08-C) |
| WK-DMF0082-0818 | D4 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — DIVISION_ID / Div: 실측[T-6ec049e4]: 신규행 DIVISION_ID='40' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움:  |  | 2 (D-06 E01-A) |
| WK-DMF0082-0819 | D4 | DOM_EXP / Customs Handbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — DOM_EXP / Customs Handbook: 실측[T-9df81b4b]: 신규행 DOM_EXP='E' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을  |  | 1 (D-06) |
| WK-DMF0082-0820 | D4 | EditButton 전제 isCurVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — EditButton 전제 isCurVersion: 원장 V-784d4aa4 / 실측[T-1aca7fd3]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(Inse |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0821 | D4 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-aeb9de38]: 신규행 FCST_TYPE='MPS' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채 |  | 1 (F-03) |
| WK-DMF0082-0822 | D4 | INCOTERMS / Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — INCOTERMS / Incoterms: 실측[T-fa3c3f82]: 신규행 INCOTERMS='DAP' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채 |  | 2 (M-24 E01-A) |
| WK-DMF0082-0823 | D4 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — ITEM_ID / Model: 실측[T-4ceabd70]: 신규행 ITEM_ID='MCSS22561-C1' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을  |  | 1 (E08-C) |
| WK-DMF0082-0824 | D4 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — MEASURE / Measure: 실측[T-93cd0933]: 신규행 MEASURE='MKT_FCST' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) — TO-BE 가 값을 채움 |  | 3 (L-10 M-22 E01-A) |
| WK-DMF0082-0825 | D4 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — SCM_SITE_ID / Sales Site: 실측[T-c5a4000c]: 신규행 SCM_SITE_ID='BYD Electronics_CN_SZX' — AS-IS InsertButton 은 이 컬럼에 값을 넣지  |  | 1 (E01-A) |
| WK-DMF0082-0826 | E2 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — P: 실측[T-0970e60a]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 4 (P-01 P-10 P-22 P-24) |
| WK-DMF0082-0827 | E2 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — S: 실측[T-bb4bf7d4]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (S-20) |
| WK-DMF0082-0828 | E3 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — BIZ_TYPE / Biz Type: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=True |  | 1 (E04) |
| WK-DMF0082-0829 | E3 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — D: 실측[T-03c96ce4]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 7 (D-03 D-04 D-05 D-10 D-11 D-19 CRUD:MAIN:) |
| WK-DMF0082-0830 | E3 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E: 실측[T-8cc8d60a]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 1 (EVENT:E-11) |
| WK-DMF0082-0831 | E3 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — F: 실측[T-f7aa6aef]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 2 (F-04 F-08) |
| WK-DMF0082-0832 | E3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — I: 실측[T-b9d83057]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 5 (E04 D-04 S-17 S-18 S-19) |
| WK-DMF0082-0833 | E3 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — M: 실측[T-b992601a]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 4 (E04 M-10 M-11 S-17) |
| WK-DMF0082-0834 | E3 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — N: 실측[T-367205a7]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0835 | E3 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — P: 실측[T-6fb9dbda]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 1 (REQ:1ST-36-1) |
| WK-DMF0082-0836 | E3 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — S: 실측[T-a1825537]: 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필 |  | 5 (S-02 S-11 S-17 S-18 S-19) |
| WK-DMF0082-0837 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-793311a7 / 실측[T-e6e18688]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:218) |
| WK-DMF0082-0838 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-e81cfaad / 실측[T-9155e903]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:219) |
| WK-DMF0082-0839 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-d9d0ac5d / 실측[T-f0fddc0b]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:220) |
| WK-DMF0082-0840 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-9f8c3e97 / 실측[T-2474cb2a]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData:) |
| WK-DMF0082-0841 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-e2b8dfa4 / 실측[T-59ba28ff]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0842 | E4 | (동적 메시지) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — (동적 메시지): 원장 V-c5c528f4 / 실측[T-bbe33fd6]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0843 | E4 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 실측[T-347cb7e9]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Sav |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData ) |
| WK-DMF0082-0844 | E4 | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E04:SAVE: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0845 | E4 | CURRENCY / Currency | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CURRENCY / Currency: 실측[T-c743219d]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 8 (D-05 D-19 M-10 ACT:DMF0082_FcstNPrice_Mg) |
| WK-DMF0082-0846 | E4 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D: 원장 V-8827ca05 ASIS / 원장 V-f9c04435 ASIS / 원장 V-d5565d2c ASIS / 원장 V-216f7d98 ASIS / 원장 V-c85805ab ASIS / 원장 V-a45b8 |  | 13 (D-03 D-04 D-05 D-10 D-11 D-12 D-19 CRUD:) |
| WK-DMF0082-0847 | E4 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DIVISION_ID / Div: 원장 V-644e54ce ASIS / 실측[T-85c7af83]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + |  | 9 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-0848 | E4 | DMF0082_FcstNPrice_Mgmt.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSaveData: 진입점 집계 — E4 5요소: REVIEW:5 |  | 55 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData:) |
| WK-DMF0082-0849 | E4 | DP-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DP-04: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (DP-04) |
| WK-DMF0082-0850 | E4 | DP-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DP-07: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (DP-07) |
| WK-DMF0082-0851 | E4 | DP-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DP-08: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (DP-08) |
| WK-DMF0082-0852 | E4 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E: 원장 V-d9d0ac5d ASIS / 원장 V-1d89cf89 ASIS / 원장 V-4f2a5d74 ASIS / 실측[T-a567b495]: E: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 |  | 1 (EVENT:E-11) |
| WK-DMF0082-0853 | E4 | E01-B1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E01-B1: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (E01-B1) |
| WK-DMF0082-0854 | E4 | END_CUSTOMER40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — END_CUSTOMER40: 원장 V-ae960713 ASIS / 실측[T-0fbc20db]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Sa |  | 3 (DP-09 S-18 ACT:DMF0082_SaveSalesFuturePr) |
| WK-DMF0082-0855 | E4 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F: 원장 V-9488a297 ASIS / 원장 V-1d89cf89 ASIS / 원장 V-e2b8dfa4 ASIS / 원장 V-c5c528f4 ASIS / 실측[T-1dd7ccd3]: MSG00464 — Dele |  | 3 (F-04 F-08 S-23) |
| WK-DMF0082-0856 | E4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:FindData: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0857 | E4 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:SaveData: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0858 | E4 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — I: 원장 V-8827ca05 ASIS / 원장 V-f9c04435 ASIS / 원장 V-d5565d2c ASIS / 원장 V-216f7d98 ASIS / 원장 V-c85805ab ASIS / 원장 V-37d8e |  | 11 (E04 D-04 P-15 S-17 S-18 S-19 ACT:DMF0082) |
| WK-DMF0082-0859 | E4 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — M: 원장 V-8827ca05 ASIS / 원장 V-f9c04435 ASIS / 원장 V-d5565d2c ASIS / 원장 V-216f7d98 ASIS / 원장 V-c85805ab ASIS / 원장 V-37d8e |  | 11 (E04 M-02 M-10 M-11 S-17 ACT:DMF0082_Fcst) |
| WK-DMF0082-0860 | E4 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MEASURE / Measure: 원장 V-1d89cf89 ASIS / 실측[T-41a27014]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + |  | 9 (ACT:DMF0082_FcstNPrice_Mgmt.SetEditList ) |
| WK-DMF0082-0861 | E4 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00002: 원장 V-37d8e51e / 실측[T-a23350c7]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:205) |
| WK-DMF0082-0862 | E4 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00002: 원장 V-37d8e51e ASIS / 원장 V-6a7a0afe ASIS / 원장 V-644e54ce ASIS / 실측[T-d27c392f]: MSG00002: 위반 입력 자동 생성 불가 — gu |  | 23 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:205) |
| WK-DMF0082-0863 | E4 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00002: 원장 V-6a7a0afe / 실측[T-dd3fc1b4]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.ValidationCh) |
| WK-DMF0082-0864 | E4 | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00002: 원장 V-644e54ce / 실측[T-c8b350c3]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0865 | E4 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00004: 원장 V-a45b8069 ASIS / 원장 V-b1d3ac5a ASIS / 실측[T-3ed36798]: MSG00004: 위반 입력 자동 생성 불가 — guard 'if (response.Dat |  | 4 (S-16 S-23 ACT:DMF0082_FcstNPrice_Mgmt.Sa) |
| WK-DMF0082-0866 | E4 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00004: 원장 V-a45b8069 / 실측[T-cdd719cd]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:217) |
| WK-DMF0082-0867 | E4 | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00004: 원장 V-b1d3ac5a / 실측[T-36ca0f48]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0868 | E4 | MSG00012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00012: 원장 V-5d847397 / 실측[T-4fd2b9ac]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:212) |
| WK-DMF0082-0869 | E4 | MSG00012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00012: 원장 V-5d847397 ASIS / 실측[T-860be1f7]: MSG00012: 위반 입력 자동 생성 불가 — guard 'if (iCount > 0)' (변수→컬럼 {}) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:212) |
| WK-DMF0082-0870 | E4 | MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00043: 원장 V-ea369869 ASIS / 원장 V-7d03ebc5 ASIS / 실측[T-960a0afa]: MSG00043: 위반 입력 자동 생성 불가 — guard 'if (!bInputCheck |  | 4 (DP-10 S-19 ACT:DMF0082_FcstNPrice_Mgmt.S) |
| WK-DMF0082-0871 | E4 | MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00043: 원장 V-ea369869 / 실측[T-513338a7]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:206) |
| WK-DMF0082-0872 | E4 | MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00043: 원장 V-7d03ebc5 / 실측[T-2daf10f8]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0873 | E4 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00097: 실측[T-52bb6359]: MSG00097 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:167) |
| WK-DMF0082-0874 | E4 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00108: 실측[T-5d943304]: MSG00108 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 4 (P-16 S-02 ACT:DMF0082_FcstNPrice_Mgmt.Fi) |
| WK-DMF0082-0875 | E4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00113: 원장 V-c85805ab ASIS / 원장 V-ae960713 ASIS / 원장 V-5ea27838 ASIS / 원장 V-f02eb445 ASIS / 실측[T-f8194c2d]: MSG00113 |  | 7 (D-03 DP-02 S-11 ACT:DMF0082_FcstNPrice_M) |
| WK-DMF0082-0876 | E4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00113: 원장 V-c85805ab / 실측[T-df386427]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0877 | E4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00113: 원장 V-ae960713 / 실측[T-92ca0982]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0878 | E4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00113: 원장 V-5ea27838 / 실측[T-5687a43a]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0879 | E4 | MSG00113 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00113: 원장 V-f02eb445 / 실측[T-cc88a5e4]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0880 | E4 | MSG00133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00133: 원장 V-4f2a5d74 ASIS / 실측[T-1f50d9be]: MSG00133: 위반 입력 자동 생성 불가 — guard 'if (isEdit==false)' (변수→컬럼 {}) |  | 2 (S-16 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0881 | E4 | MSG00133 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00133: 원장 V-4f2a5d74 / 실측[T-6ed1c38e]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0882 | E4 | MSG00137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00137: 원장 V-1b172a17 ASIS / 실측[T-a1a1558b]: MSG00137 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 3 (S-01 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0883 | E4 | MSG00137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00137: 원장 V-1b172a17 / 실측[T-5e698c60]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0884 | E4 | MSG00142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00142: 원장 V-d98f3085 / 실측[T-6deafa4f]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-0885 | E4 | MSG00142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00142: 원장 V-d98f3085 ASIS / 실측[T-19f215d4]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(btnExc |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-0886 | E4 | MSG00164 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00164: 실측[T-d710d23e]: MSG00164 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 2 (P-17 ACT:DMF0082_FcstNPrice_Mgmt.FindDat) |
| WK-DMF0082-0887 | E4 | MSG00227 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00227: 원장 V-9488a297 ASIS / 실측[T-30300f80]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(cboBucke |  | 3 (P-15 HANDLER:cboBucketType_Click ACT:DMF) |
| WK-DMF0082-0888 | E4 | MSG00227 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00227: 원장 V-9488a297 / 실측[T-56e3890d]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0889 | E4 | MSG00259 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00259: 원장 V-1c66a7d6 / 실측[T-9c9506d0]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0890 | E4 | MSG00259 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00259: 원장 V-1c66a7d6 ASIS / 실측[T-3afcab94]: MSG00259 — EditButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(EditButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton:1) |
| WK-DMF0082-0891 | E4 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00260: 원장 V-1d89cf89 ASIS / 실측[T-6c776f85]: MSG00260 — spdMain_Changed 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(spdMain_Chan |  | 4 (D-12 REQ:1ST-38-1 EVENT:E-11 ACT:DMF0082) |
| WK-DMF0082-0892 | E4 | MSG00260 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00260: 원장 V-1d89cf89 / 실측[T-dc93c35d]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0893 | E4 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00283: 실측[T-d90ed5ef]: MSG00283 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 2 (P-18 ACT:DMF0082_FcstNPrice_Mgmt.FindDat) |
| WK-DMF0082-0894 | E4 | MSG00330 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00330: 실측[T-36799c3c]: MSG00330 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 2 (S-04 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0895 | E4 | MSG00408 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00408: 원장 V-b19b75fc / 실측[T-cccbbdcf]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-0896 | E4 | MSG00408 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00408: 원장 V-b19b75fc ASIS / 실측[T-b317a527]: MSG00408 — btnSavePricePeriod_Click 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-0897 | E4 | MSG00409 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00409: 실측[T-08a6665e]: MSG00409 — FindData 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(FindData)에서 판정 |  | 2 (S-03 ACT:DMF0082_SaveSalesFuturePrice_Po) |
| WK-DMF0082-0898 | E4 | MSG00449 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00449: 원장 V-4826fbcc / 실측[T-7644b2ae]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:207) |
| WK-DMF0082-0899 | E4 | MSG00449 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00449: 원장 V-4826fbcc ASIS / 원장 V-e9150dcc ASIS / 실측[T-fbc7508d]: MSG00449: 위반 입력 자동 생성 불가 — guard 'if (!bInputCheck |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:207) |
| WK-DMF0082-0900 | E4 | MSG00449 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00449: 원장 V-e9150dcc / 실측[T-0f50fab2]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:221) |
| WK-DMF0082-0901 | E4 | MSG00464 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00464: 원장 V-8827ca05 ASIS / 원장 V-f9c04435 ASIS / 원장 V-d5565d2c ASIS / 원장 V-216f7d98 ASIS / 실측[T-1a3db18d]: MSG00464 |  | 5 (A-03 ACT:DMF0082_FcstNPrice_Mgmt.DeleteB) |
| WK-DMF0082-0902 | E4 | MSG00464 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00464: 원장 V-8827ca05 / 실측[T-a854fd03]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0903 | E4 | MSG00464 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00464: 원장 V-f9c04435 / 실측[T-5403fff9]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0904 | E4 | MSG00464 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00464: 원장 V-d5565d2c / 실측[T-17877c76]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0905 | E4 | MSG00464 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MSG00464: 원장 V-216f7d98 / 실측[T-3afbbe24]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.DeleteButton) |
| WK-DMF0082-0906 | E4 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — N: 원장 V-37d8e51e ASIS / 원장 V-ea369869 ASIS / 원장 V-4826fbcc ASIS / 원장 V-5d847397 ASIS / 원장 V-a45b8069 ASIS / 원장 V-79331 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0907 | E4 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — P: 원장 V-6a7a0afe ASIS / 원장 V-1d89cf89 ASIS / 실측[T-1acde8eb]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(D |  | 5 (P-15 P-16 P-17 P-18 REQ:1ST-36-1) |
| WK-DMF0082-0908 | E4 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — PROJECT_CODE / Project Code: 원장 V-5ea27838 ASIS / 원장 V-f02eb445 ASIS / 원장 V-644e54ce ASIS / 실측[T-fba3877d]: 검사기 있음(_tr |  | 2 (D-10 S-18) |
| WK-DMF0082-0909 | E4 | REQ:1ST-41-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — REQ:1ST-41-1: 행 집계 — E4 83요소: REVIEW:73 · NA:10 |  | 1 (REQ:1ST-41-1) |
| WK-DMF0082-0910 | E4 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — S: 원장 V-37d8e51e ASIS / 원장 V-ea369869 ASIS / 원장 V-4826fbcc ASIS / 원장 V-5d847397 ASIS / 원장 V-a45b8069 ASIS / 원장 V-79331 |  | 11 (S-01 S-02 S-03 S-04 S-05 S-11 S-16 S-17 ) |
| WK-DMF0082-0911 | E4 | SCM_SITE_ID / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM_SITE_ID / Sales Site: 원장 V-ae960713 ASIS / 원장 V-5ea27838 ASIS / 원장 V-f02eb445 ASIS / 원장 V-644e54ce ASIS / 실측[T-153 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0912 | E4 | YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — YYYYMMDD: 원장 V-9f8c3e97 ASIS / 실측[T-77a15e81]: 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청  |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.SetSaveData ) |
| WK-DMF0082-0913 | E4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 실측[T-1e0bd34e]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteBu |  | 33 (ACT:DMF0082_FcstNPrice_Mgmt.SetLockRange) |
| WK-DMF0082-0914 | E4 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — chkSum / Sum: 실측[T-e605a0ab]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0915 | E4 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — clbDivision / Division: 실측[T-5dfd41f7]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 6 (D-03 D-04 D-05 D-12 D-19 ACT:DMF0082_Fcs) |
| WK-DMF0082-0916 | E4 | clbDivisions / Division / Divisions | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — clbDivisions / Division / Divisions: 실측[T-ace70a16]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteBut |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.E) |
| WK-DMF0082-0917 | E4 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — drpPeriod / Period: 실측[T-addc4e9b]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:170) |
| WK-DMF0082-0918 | E4 | txtVersion / Version | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — txtVersion / Version: 실측[T-5e94c362]: MSG00464 — DeleteButton 경로 메시지(저장 전 검증 아님) — 해당 동작 시나리오(DeleteButton)에서 판정 |  | 2 (P-18 ACT:DMF0082_FcstNPrice_Mgmt.FindDat) |
| WK-DMF0082-0919 | E5 | A-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — A-11: 행 집계 — E5 11요소: PASS:7 · REVIEW:4 |  | 1 (A-11) |
| WK-DMF0082-0920 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 11요소: PASS:7 · REVIEW:4 |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0921 | E5 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — F: 실측[T-cd1c5bac]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0922 | E5 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — I: 실측[T-b8aeb13b]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 2 (M-08 E01-A) |
| WK-DMF0082-0923 | E5 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — M: 실측[T-b30daccb]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (M-08) |
| WK-DMF0082-0924 | E5 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — S: 실측[T-66b9b050]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / 검사 |  | 1 (F-02) |
| WK-DMF0082-0925 | A1 | A-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-11: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (A-11) |
| WK-DMF0082-0926 | A1 | A-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-13: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (A-13) |
| WK-DMF0082-0927 | A1 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-15: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (A-15) |
| WK-DMF0082-0928 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (COMMON:UC-02) |
| WK-DMF0082-0929 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0930 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0931 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0932 | A1 | CRUD:E05:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E05:SEARCH: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0933 | A1 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D-17: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (D-17) |
| WK-DMF0082-0934 | A1 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 골든 비교 케이스 없음(DMF0073_GET_VERSION_SALESPRICE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0935 | A1 | DMF0082_FcstNPrice_Mgmt.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0082_FcstNPrice_Mgmt.Draw: 진입점 집계 — A1 12요소: REVIEW:12 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.Draw:1810:10) |
| WK-DMF0082-0936 | A1 | DP-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DP-01: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (DP-01) |
| WK-DMF0082-0937 | A1 | DP-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DP-04: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (DP-04) |
| WK-DMF0082-0938 | A1 | E01-A | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-A: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E01-A) |
| WK-DMF0082-0939 | A1 | E01-B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-B: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E01-B) |
| WK-DMF0082-0940 | A1 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E05: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E05) |
| WK-DMF0082-0941 | A1 | E07-B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E07-B: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E07-B) |
| WK-DMF0082-0942 | A1 | E08-C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E08-C: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E08-C) |
| WK-DMF0082-0943 | A1 | EVENT:E-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-03: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (EVENT:E-03) |
| WK-DMF0082-0944 | A1 | EVENT:E-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-12: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (EVENT:E-12) |
| WK-DMF0082-0945 | A1 | EVENT:E-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-14: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (EVENT:E-14) |
| WK-DMF0082-0946 | A1 | F-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F-02: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (F-02) |
| WK-DMF0082-0947 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0948 | A1 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:Form_Load: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0949 | A1 | HANDLER:clbCustomer_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0082-0950 | A1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0082-0951 | A1 | L-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-03: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (L-03) |
| WK-DMF0082-0952 | A1 | M-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — M-21: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (M-21) |
| WK-DMF0082-0953 | A1 | MODAL:ForecastTemplateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ForecastTemplateModal: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (MODAL:ForecastTemplateModal) |
| WK-DMF0082-0954 | A1 | P-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-04: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (P-04) |
| WK-DMF0082-0955 | A1 | P-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-23: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (P-23) |
| WK-DMF0082-0956 | A1 | P-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-24: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (P-24) |
| WK-DMF0082-0957 | A1 | PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPU | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA — 팝업·보조 SP |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0958 | A1 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA — 팝업·보조 SP 는 golden_case |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0959 | A1 | PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH — 팝업·보조 SP 는 golden_cases.cs |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0960 | A1 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — 팝업·보조 SP 는 golden_cases.csv 에  |  | 67 (A-01 CRUD:MAIN:SEARCH DPF-02 ACT:DMF0082) |
| WK-DMF0082-0961 | A1 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT — 팝업·보조 SP 는 gol |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0962 | A1 | PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 62 (DPF-01 ACT:DMF0082_FcstNPrice_Mgmt.FindB) |
| WK-DMF0082-0963 | A1 | PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO — 팝업·보 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0964 | A1 | PL-33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PL-33: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (PL-33) |
| WK-DMF0082-0965 | A1 | PL-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PL-36: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (PL-36) |
| WK-DMF0082-0966 | A1 | POPUP_GET_FUTUREPRICE_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — POPUP_GET_FUTUREPRICE_INFO: 골든 비교 케이스 없음(POPUP_GET_FUTUREPRICE_INFO — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0967 | A1 | REQ:1ST-37-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-37-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0968 | A1 | REQ:1ST-39-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-39-1: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:1ST-39-1) |
| WK-DMF0082-0969 | A1 | REQ:1ST-39-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-39-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0970 | A1 | REQ:1ST-66-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-66-1: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0971 | A1 | S-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-01: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (S-01) |
| WK-DMF0082-0972 | A1 | S-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-07: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (S-07) |
| WK-DMF0082-0973 | A1 | S-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-24: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (S-24) |
| WK-DMF0082-0974 | A1 | S-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-25: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (S-25) |
| WK-DMF0082-0975 | A1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 골든 비교 케이스 없음(SCM0001_GET_BIZ_TYPE_BY_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 1 (DPF-09) |
| WK-DMF0082-0976 | A1 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 골든 비교 케이스 없음(SCM0001_GET_LOOKUP_VALUES — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 140 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0977 | A1 | UP_FX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UP_FX: 골든 비교 케이스 없음(UP_FX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D-07) |
| WK-DMF0082-0978 | A6 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 실측[T-64816636]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0979 | A6 | PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPU | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: 실측[T-628f141b]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORD |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0980 | A6 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 실측[T-9af55d25]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY,  |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0981 | A6 | PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH: 실측[T-0af06f4f]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, AL |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0982 | A6 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: 실측[T-212e8ba7]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER  |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0983 | A6 | PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO: 원장 V-f6b28c55 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음(결과 순서 미정) — 동일 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0984 | A6 | POPUP_GET_FUTUREPRICE_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — POPUP_GET_FUTUREPRICE_INFO: 실측[T-1735227c]: 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0985 | A6 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 원장 V-6efaa083 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e49d6326 |  | 1 (DPF-09) |
| WK-DMF0082-0986 | A6 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 원장 V-57eed966 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e8712333]: SCM0 |  | 140 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0987 | G03-WIRE | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — DMF0082 화면: 게이트 G03 As-is 이벤트 chkSum.CheckedChanged → chkSum / 게이트 G03 As-is 이벤트 btnMeasure.Click → btnMeasure_  |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt..ctor ACT:DM) |
| WK-DMF0082-0988 | G1 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00097: 원장 V-8312abb9 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:167) |
| WK-DMF0082-0989 | G1 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00097: 원장 V-d3e5f015 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0990 | G1 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00108: 원장 V-cdbca720 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:169) |
| WK-DMF0082-0991 | G1 | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00108: 원장 V-defee7f2 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0992 | G1 | MSG00137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00137: 원장 V-20134ea1 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0993 | G1 | MSG00164 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00164: 원장 V-27752513 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:170) |
| WK-DMF0082-0994 | G1 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00283: 원장 V-4181aa4b |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:168) |
| WK-DMF0082-0995 | G1 | MSG00330 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00330: 원장 V-b810e5fd |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0996 | G1 | MSG00409 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00409: 원장 V-12cc51f5 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0997 | G1 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboBucketType / Bucket / Bucket Type: 원장 V-14f105ed SEARCH |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0998 | G1 | cboQty /   / Qty | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboQty /   / Qty: 원장 V-af739211 SEARCH |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0999 | G1 | clbBizType / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — clbBizType / Biz Type: 원장 V-2d1005c0 SEARCH |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-1000 | G1 | clbSalesSite / Sales Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — clbSalesSite / Sales Site: 원장 V-3b5d0fe5 SEARCH |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-1001 | G1 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — drpDateTime / Date Time: 실측[T-00252b43]: 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke / 검사기(smoke 조회조건 동작·_verify)가 이  |  | 7 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-1002 | G1 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — drpPeriod / Period: 원장 V-8995a3a0 SEARCH |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-1003 | G6 | clbDivisions / Division / Divisions | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — clbDivisions / Division / Divisions: 실측[T-13c532f5]: 공용 팝업 내부 조건(clbDivisions) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-1004 | G6 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — drpDateTime / Date Time: 실측[T-13912755]: 공용 팝업 내부 조건(drpDateTime) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) |  | 18 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-1005 | X-LOC | AS_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS_FROM_SITE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS_FROM_SITE) |
| WK-DMF0082-1006 | X-LOC | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AsIncotermsEdit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AsIncotermsEdit) |
| WK-DMF0082-1007 | X-LOC | BizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizType) |
| WK-DMF0082-1008 | X-LOC | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizTypeByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizTypeByDivision) |
| WK-DMF0082-1009 | X-LOC | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CELL_PROD_SITE_ID: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0082-1010 | X-LOC | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CurrencyList: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CurrencyList) |
| WK-DMF0082-1011 | X-LOC | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CustomsHandbook: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CustomsHandbook) |
| WK-DMF0082-1012 | X-LOC | DOM_EXP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DOM_EXP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DOM_EXP) |
| WK-DMF0082-1013 | X-LOC | DefaultBucketDay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DefaultBucketDay: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DefaultBucketDay) |
| WK-DMF0082-1014 | X-LOC | DeptId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeptId: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeptId) |
| WK-DMF0082-1015 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-DMF0082-1016 | X-LOC | EndCustomerByDivision40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivision40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivision40) |
| WK-DMF0082-1017 | X-LOC | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivisionDept: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0082-1018 | X-LOC | FCST_TYPE_NOT_FREE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FCST_TYPE_NOT_FREE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FCST_TYPE_NOT_FREE) |
| WK-DMF0082-1019 | X-LOC | FcstPriceEditMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstPriceEditMeasure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstPriceEditMeasure) |
| WK-DMF0082-1020 | X-LOC | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstType) |
| WK-DMF0082-1021 | X-LOC | FcstTypeByUserGroupDMF0082 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstTypeByUserGroupDMF0082: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstTypeByUserGroupDMF0082) |
| WK-DMF0082-1022 | X-LOC | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FromSiteByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FromSiteByDivision) |
| WK-DMF0082-1023 | X-LOC | Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Incoterms: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Incoterms) |
| WK-DMF0082-1024 | X-LOC | ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ItemType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ItemType) |
| WK-DMF0082-1025 | X-LOC | L2P `hotkey DELETE` 권한 0그룹 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L2P `hotkey DELETE` 권한 0그룹: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L2P `hotkey DELETE` 권한 0그룹) |
| WK-DMF0082-1026 | X-LOC | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-1027 | X-LOC | L7 `titleSet` 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L7 `titleSet` 시트: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-1028 | X-LOC | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Measure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Measure) |
| WK-DMF0082-1029 | X-LOC | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantByDivisionCompany: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantByDivisionCompany) |
| WK-DMF0082-1030 | X-LOC | SalesBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesBucket: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesBucket) |
| WK-DMF0082-1031 | X-LOC | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SiteByEndCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SiteByEndCustomer) |
| WK-DMF0082-1032 | X-LOC | SoldCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SoldCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SoldCustomer) |
| WK-DMF0082-1033 | X-LOC | TeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TeambyDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TeambyDivision) |
| WK-DMF0082-1034 | X-LOC | YesOrNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — YesOrNo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (YesOrNo) |
| WK-DMF0082-1035 | X-ROW | AS_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS_FROM_SITE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS_FROM_SITE) |
| WK-DMF0082-1036 | X-ROW | BizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BizType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BizType) |
| WK-DMF0082-1037 | X-ROW | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BizTypeByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BizTypeByDivision) |
| WK-DMF0082-1038 | X-ROW | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CELL_PROD_SITE_ID: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0082-1039 | X-ROW | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CurrencyList: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CurrencyList) |
| WK-DMF0082-1040 | X-ROW | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CustomsHandbook: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CustomsHandbook) |
| WK-DMF0082-1041 | X-ROW | DMF0082_FcstNPrice_Mgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 4검사 — REVIEW:3 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-1042 | X-ROW | DMF0082_FcstNPrice_Mgmt.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.DefineProperty: 진입점 집계 4검사 — PASS:2 · REVIEW:1 · WARN:1 |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.DefineProper) |
| WK-DMF0082-1043 | X-ROW | DMF0082_FcstNPrice_Mgmt.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0082_FcstNPrice_Mgmt.ExcelButton ) |
| WK-DMF0082-1044 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-1045 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange) |
| WK-DMF0082-1046 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 7검사 — REVIEW:6 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-1047 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetLookupValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-1048 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetSalesSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-1049 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-1050 | X-ROW | DMF0082_FcstNPrice_Mgmt.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/VALUE_SET, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.OnShown ACT:) |
| WK-DMF0082-1051 | X-ROW | DMF0082_FcstNPrice_Mgmt.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SaveData: 진입점 집계 26검사 — REVIEW:19 · PASS:7 |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.SaveData:213) |
| WK-DMF0082-1052 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetChangeControl: 진입점 집계 8검사 — REVIEW:4 · NA:4 |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-1053 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadColumn: 진입점 집계 16검사 — REVIEW:11 · NA:4 · PASS:1 |  | 14 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-1054 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 6검사 — REVIEW:4 · PASS:1 · NA:1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-1055 | X-ROW | DMF0082_FcstNPrice_Mgmt.ValidationCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.ValidationCheck: 진입점 집계 3검사 — REVIEW:2 · PASS:1 |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.ValidationCh) |
| WK-DMF0082-1056 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnColumn_Click: 진입점 집계 8검사 — REVIEW:7 · PASS:1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1057 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnExchangeRate_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnExchangeRate_Click: 진입점 집계 9검사 — REVIEW:7 · PASS:2 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-1058 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnItemId_Click: 진입점 집계 8검사 — REVIEW:7 · PASS:1 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1059 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnMeasure_Click: 진입점 집계 8검사 — REVIEW:7 · PASS:1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-1060 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnSavePricePeri | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnSavePricePeriod_Click: 진입점 집계 11검사 — REVIEW:9 · PASS:2 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-1061 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnVersion_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.btnVersion_Click: 진입점 집계 8검사 — NA:6 · REVIEW:1 · PASS:1 |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.btnVersion_C) |
| WK-DMF0082-1062 | X-ROW | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedInde: 진입점 집계 12검사 — REVIEW:11 · WARN:1 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-1063 | X-ROW | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged: 진입점 집계 3검사 — REVIEW:3 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-1064 | X-ROW | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexC: 진입점 집계 4검사 — REVIEW:3 · PASS:1 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-1065 | X-ROW | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChang: 진입점 집계 5검사 — REVIEW:3 · PASS:2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-1066 | X-ROW | DMF0082_FcstNPrice_Mgmt.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLAG/FLOW/LOCAL/RETURN/ST |  | 89 (ACT:DMF0082_FcstNPrice_Mgmt.fnValidation) |
| WK-DMF0082-1067 | X-ROW | DMF0082_FcstNPrice_Mgmt.getDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.getDayOfWeek: 진입점 집계 2검사 — REVIEW:2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.getDayOfWeek) |
| WK-DMF0082-1068 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick: 진입점 집계 32검사 — REVIEW:16 · NA:14 · PASS:2 |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1069 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_EditChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Edit) |
| WK-DMF0082-1070 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/FLAG/LOCAL/RETURN/UI_PROP, 연 |  | 19 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_KeyU) |
| WK-DMF0082-1071 | X-ROW | DMF0082_FcstNPrice_Mgmt.txtVersion_KeyDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.txtVersion_K) |
| WK-DMF0082-1072 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup..ctor: 진입점 집계 2검사 — WARN:1 · REVIEW:1 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup..) |
| WK-DMF0082-1073 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Creat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.CreateSpread: 진입점 집계 1검사 — REVIEW:1 |  | 5 (ACT:DMF0082_SaveSalesFuturePrice_Popup.C) |
| WK-DMF0082-1074 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Defin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.DefineProperty: 진입점 집계 7검사 — REVIEW:5 · PASS:1 · WARN:1 |  | 10 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-1075 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Dispo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.Dispose: 진입점 집계 2검사 — PASS:1 · REVIEW:1 |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-1076 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetCellColor: 진입점 집계 1검사 — REVIEW:1 |  | 6 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1077 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetCellIndexByS: 진입점 집계 1검사 — REVIEW:1 |  | 5 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1078 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetCellNumbersB: 진입점 집계 1검사 — REVIEW:1 |  | 15 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1079 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetDayRange: 진입점 집계 4검사 — REVIEW:3 · PASS:1 |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1080 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetEx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetExchangeRate: 진입점 집계 5검사 — REVIEW:5 |  | 22 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1081 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetFu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetFuturePriceI: 진입점 집계 6검사 — REVIEW:5 · PASS:1 |  | 9 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1082 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetMe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCount: 진입점 집계 4검사 — REVIEW:3 · PASS:1 |  | 9 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1083 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetSa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFrom: 진입점 집계 8검사 — REVIEW:5 · PASS:3 |  | 15 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1084 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle: 진입점 집계 8검사 — REVIEW:5 · PASS:3 |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1085 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.GetWe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.GetWeekData: 진입점 집계 4검사 — REVIEW:3 · PASS:1 |  | 7 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-1086 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.InitEvent: 진입점 집계 3검사 — WARN:1 · PASS:1 · REVIEW:1 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-1087 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.InitSpread: 진입점 집계 5검사 — REVIEW:4 · PASS:1 |  | 9 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-1088 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.LoadD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.LoadData: 진입점 집계 1검사 — REVIEW:1 |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.L) |
| WK-DMF0082-1089 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SetEx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.SetExchangeValu: 진입점 집계 9검사 — REVIEW:8 · NA:1 |  | 26 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-1090 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SetSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.SetSpreadHeader: 진입점 집계 1검사 — REVIEW:1 |  | 49 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-1091 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.btnBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.btnButtonList_U: 진입점 집계 3검사 — REVIEW:2 · PASS:1 |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.b) |
| WK-DMF0082-1092 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.cboBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.cboBucketType_S: 진입점 집계 1검사 — REVIEW:1 |  | 6 (ACT:DMF0082_SaveSalesFuturePrice_Popup.c) |
| WK-DMF0082-1093 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.clbDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.clbDivisions_Se: 진입점 집계 2검사 — REVIEW:1 · PASS:1 |  | 14 (ACT:DMF0082_SaveSalesFuturePrice_Popup.c) |
| WK-DMF0082-1094 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.drpDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.drpDateTime_Loa: 진입점 집계 2검사 — REVIEW:2 |  | 5 (ACT:DMF0082_SaveSalesFuturePrice_Popup.d) |
| WK-DMF0082-1095 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.drpDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.drpDateTime_Val: 진입점 집계 2검사 — REVIEW:2 |  | 7 (ACT:DMF0082_SaveSalesFuturePrice_Popup.d) |
| WK-DMF0082-1096 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.fnVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.fnValidation: 진입점 집계 1검사 — REVIEW:1 |  | 48 (ACT:DMF0082_SaveSalesFuturePrice_Popup.f) |
| WK-DMF0082-1097 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.umltP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.umltProject_Key: 진입점 집계 1검사 — REVIEW:1 |  | 3 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1098 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.usrBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.usrButton1_Clic: 진입점 집계 10검사 — REVIEW:9 · PASS:1 |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1099 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.usrBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.usrButton2_Clic: 진입점 집계 9검사 — REVIEW:8 · PASS:1 |  | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1100 | X-ROW | DOM_EXP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DOM_EXP: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DOM_EXP) |
| WK-DMF0082-1101 | X-ROW | DPF-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DPF-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DPF-06) |
| WK-DMF0082-1102 | X-ROW | DPF-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DPF-07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DPF-07) |
| WK-DMF0082-1103 | X-ROW | DPF-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DPF-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DPF-08) |
| WK-DMF0082-1104 | X-ROW | DefaultBucketDay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DefaultBucketDay: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DefaultBucketDay) |
| WK-DMF0082-1105 | X-ROW | DeptId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DeptId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DeptId) |
| WK-DMF0082-1106 | X-ROW | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Division: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Division) |
| WK-DMF0082-1107 | X-ROW | E01-B2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-B2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-B2) |
| WK-DMF0082-1108 | X-ROW | E01-B3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-B3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-B3) |
| WK-DMF0082-1109 | X-ROW | E01-B4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-B4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-B4) |
| WK-DMF0082-1110 | X-ROW | E08-A | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E08-A: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E08-A) |
| WK-DMF0082-1111 | X-ROW | EndCustomerByDivision40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EndCustomerByDivision40: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EndCustomerByDivision40) |
| WK-DMF0082-1112 | X-ROW | FCST_TYPE_NOT_FREE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FCST_TYPE_NOT_FREE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FCST_TYPE_NOT_FREE) |
| WK-DMF0082-1113 | X-ROW | FcstPriceEditMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FcstPriceEditMeasure: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FcstPriceEditMeasure) |
| WK-DMF0082-1114 | X-ROW | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FcstType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FcstType) |
| WK-DMF0082-1115 | X-ROW | FcstTypeByUserGroupDMF0082 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FcstTypeByUserGroupDMF0082: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FcstTypeByUserGroupDMF0082) |
| WK-DMF0082-1116 | X-ROW | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FromSiteByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FromSiteByDivision) |
| WK-DMF0082-1117 | X-ROW | HANDLER:SetEditList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:SetEditList: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:SetEditList) |
| WK-DMF0082-1118 | X-ROW | HANDLER:btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnColumn_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnColumn_Click) |
| WK-DMF0082-1119 | X-ROW | HANDLER:btnExchangeRate_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnExchangeRate_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnExchangeRate_Click) |
| WK-DMF0082-1120 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0082-1121 | X-ROW | HANDLER:btnVersion_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnVersion_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnVersion_Click) |
| WK-DMF0082-1122 | X-ROW | Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Incoterms: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Incoterms) |
| WK-DMF0082-1123 | X-ROW | ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ItemType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ItemType) |
| WK-DMF0082-1124 | X-ROW | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Measure: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Measure) |
| WK-DMF0082-1125 | X-ROW | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-02) |
| WK-DMF0082-1126 | X-ROW | P-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-11) |
| WK-DMF0082-1127 | X-ROW | P-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-19) |
| WK-DMF0082-1128 | X-ROW | P-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-21) |
| WK-DMF0082-1129 | X-ROW | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — PlantByDivisionCompany: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (PlantByDivisionCompany) |
| WK-DMF0082-1130 | X-ROW | REQ:1ST-34-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-34-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-34-2) |
| WK-DMF0082-1131 | X-ROW | REQ:1ST-35-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-35-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-35-1) |
| WK-DMF0082-1132 | X-ROW | REQ:1ST-37-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-37-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-37-1) |
| WK-DMF0082-1133 | X-ROW | REQ:1ST-39-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-39-3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-39-3) |
| WK-DMF0082-1134 | X-ROW | REQ:1ST-40-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-40-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-40-2) |
| WK-DMF0082-1135 | X-ROW | REQ:1ST-41-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-41-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-41-2) |
| WK-DMF0082-1136 | X-ROW | REQ:1ST-41-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-41-3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-41-3) |
| WK-DMF0082-1137 | X-ROW | REQ:1ST-42-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-42-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-42-1) |
| WK-DMF0082-1138 | X-ROW | REQ:1ST-44-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-44-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-44-1) |
| WK-DMF0082-1139 | X-ROW | REQ:1ST-45-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-45-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-45-2) |
| WK-DMF0082-1140 | X-ROW | REQ:1ST-46-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-46-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-46-1) |
| WK-DMF0082-1141 | X-ROW | REQ:1ST-46-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-46-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-46-2) |
| WK-DMF0082-1142 | X-ROW | REQ:1ST-48-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-48-4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-48-4) |
| WK-DMF0082-1143 | X-ROW | REQ:1ST-63-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-63-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-63-1) |
| WK-DMF0082-1144 | X-ROW | REQ:1ST-63-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-63-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-63-2) |
| WK-DMF0082-1145 | X-ROW | REQ:1ST-63-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-63-3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-63-3) |
| WK-DMF0082-1146 | X-ROW | REQ:1ST-64-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-64-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-64-1) |
| WK-DMF0082-1147 | X-ROW | REQ:1ST-65-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-65-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-65-1) |
| WK-DMF0082-1148 | X-ROW | REQ:1ST-65-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-65-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-65-2) |
| WK-DMF0082-1149 | X-ROW | REQ:1ST-67-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:1ST-67-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:1ST-67-1) |
| WK-DMF0082-1150 | X-ROW | S-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-06) |
| WK-DMF0082-1151 | X-ROW | S-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-10) |
| WK-DMF0082-1152 | X-ROW | S-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-21) |
| WK-DMF0082-1153 | X-ROW | S-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-26: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-26) |
| WK-DMF0082-1154 | X-ROW | S-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-27: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-27) |
| WK-DMF0082-1155 | X-ROW | S-28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S-28: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S-28) |
| WK-DMF0082-1156 | X-ROW | SalesBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SalesBucket: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SalesBucket) |
| WK-DMF0082-1157 | X-ROW | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SiteByEndCustomer: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SiteByEndCustomer) |
| WK-DMF0082-1158 | X-ROW | SoldCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SoldCustomer: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SoldCustomer) |
| WK-DMF0082-1159 | X-ROW | TeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — TeambyDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (TeambyDivision) |
| WK-DMF0082-1160 | X-ROW | YesOrNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — YesOrNo: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (YesOrNo) |
| WK-DMF0082-1161 | G5 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A-15: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (A-15) |
| WK-DMF0082-1162 | G5 | AUTHORITY_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — AUTHORITY_YN: 실측[T-908a7761]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py  |  | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-1163 | G5 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — B: 원장 V-5ec0229b ASIS / 원장 V-df4713dd ASIS |  | 1 (S-23) |
| WK-DMF0082-1164 | G5 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BIZ_TYPE / Biz Type: 실측[T-824d7c8a]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 led |  | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-1165 | G5 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — C: 원장 V-4066740e ASIS / 원장 V-f1f53096 ASIS / 원장 V-7c7fba0d ASIS / 원장 V-df4713dd ASIS / 원장 V-cffce3cc ASIS / 원장 V-724ab |  | 1 (E08-C) |
| WK-DMF0082-1166 | G5 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 실측[T-96e4b2b6]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필 |  | 1 (E08-C) |
| WK-DMF0082-1167 | G5 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DIVISION_ID / Div: 실측[T-f096b2ba]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledge |  | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-1168 | G5 | DMF0082_FcstNPrice_Mgmt.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick: 진입점 집계 — G5 10요소: NA:6 · REVIEW:4 |  | 116 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1169 | G5 | DMF0082_SaveSalesFuturePrice_Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup: 원장 V-b6da1505 ASIS / 원장 V-762e6112 ASIS / 원장 V-f8bfb908 ASIS / 원장 V-bad04a7d ASIS  |  | 2 (DPF-05 ACT:DMF0082_FcstNPrice_Mgmt.btnSa) |
| WK-DMF0082-1170 | G5 | DP-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DP-11: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (DP-11) |
| WK-DMF0082-1171 | G5 | DPF-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DPF-03: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (DPF-03) |
| WK-DMF0082-1172 | G5 | DPF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DPF-04: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (DPF-04) |
| WK-DMF0082-1173 | G5 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E: 원장 V-958c81bf ASIS / 원장 V-f1f53096 ASIS / 원장 V-401954f0 ASIS / 원장 V-cffce3cc ASIS / 원장 V-724aba5c ASIS / 원장 V-824ee |  | 4 (EVENT:E-09 EVENT:E-10 EVENT:E-11 EVENT:E) |
| WK-DMF0082-1174 | G5 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E08: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (E08) |
| WK-DMF0082-1175 | G5 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — F: 원장 V-4066740e ASIS / 원장 V-f1f53096 ASIS / 원장 V-7c7fba0d ASIS / 원장 V-b6da1505 ASIS / 원장 V-401954f0 ASIS / 원장 V-724ab |  | 3 (F-09 F-10 S-23) |
| WK-DMF0082-1176 | G5 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-c2ff318a]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 l |  | 2 (F-09 F-10) |
| WK-DMF0082-1177 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0082-1178 | G5 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — I: 원장 V-f1f53096 ASIS / 원장 V-a3609e7a ASIS / 원장 V-df4713dd ASIS / 원장 V-cffce3cc ASIS / 원장 V-724aba5c ASIS / 원장 V-acc9c |  | 3 (A-14 PL-22 PL-25) |
| WK-DMF0082-1179 | G5 | ITEM_CLASS_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ITEM_CLASS_NAME: 실측[T-b498dcfb]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger. |  | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-1180 | G5 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ITEM_ID / Model: 실측[T-ee75640e]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger. |  | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-1181 | G5 | ITEM_NAME / Model Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ITEM_NAME / Model Name: 실측[T-b479e720]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는  |  | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-1182 | G5 | ITEM_TYPE / Item Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ITEM_TYPE / Item Type: 실측[T-75c25d97]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 l |  | 1 (EVENT:E-10) |
| WK-DMF0082-1183 | G5 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — L: 원장 V-762e6112 ASIS |  | 23 (PL-00 PL-01 PL-02 PL-03 PL-04 PL-19 PL-2) |
| WK-DMF0082-1184 | G5 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — M: 원장 V-4066740e ASIS / 원장 V-7c7fba0d ASIS / 원장 V-df4713dd ASIS / 원장 V-cffce3cc ASIS / 원장 V-724aba5c ASIS / 원장 V-acc9c |  | 1 (M-25) |
| WK-DMF0082-1185 | G5 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MEASURE / Measure: 실측[T-2be591ed]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledge |  | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-1186 | G5 | MODAL:ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ExchangeRateModal: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-1187 | G5 | MODAL:VersionSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:VersionSelectModal: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-1188 | G5 | NICK_NAME / Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — NICK_NAME / Nick Name: 실측[T-c26f9ed6]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 l |  | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-1189 | G5 | OWNER / Owner | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — OWNER / Owner: 실측[T-ae105280]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py |  | 1 (EVENT:E-09) |
| WK-DMF0082-1190 | G5 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-5c04a62d]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trac |  | 1 (EVENT:E-09) |
| WK-DMF0082-1191 | G5 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PROJECT_NAME / Project: 실측[T-fef3b0b2]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는  |  | 2 (PL-26 EVENT:E-09) |
| WK-DMF0082-1192 | G5 | REQ:1ST-48-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:1ST-48-1: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:1ST-48-1) |
| WK-DMF0082-1193 | G5 | REQ:1ST-48-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:1ST-48-2: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-1194 | G5 | REQ:1ST-48-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:1ST-48-3: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-1195 | G5 | REQ:1ST-49-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:1ST-49-1: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-1196 | G5 | REQ:1ST-66-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:1ST-66-1: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-1197 | G5 | REQ:CHAT-20260915-EXLASTUPD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — G5 54요소: REVIEW:45 · NA:9 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-1198 | G5 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — S: 원장 V-4066740e ASIS / 원장 V-d4c116f2 ASIS / 원장 V-054b6b7b ASIS / 원장 V-f1f53096 ASIS / 원장 V-a3609e7a ASIS / 원장 V-7c7fb |  | 3 (S-07 S-23 S-25) |
| WK-DMF0082-1199 | G5 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — cboBucketType / Bucket / Bucket Type: 실측[T-5755edd0]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1200 | G5 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — clbDivision / Division: 실측[T-b09076c8]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1201 | G5 | clbDivisions / Division / Divisions | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — clbDivisions / Division / Divisions: 실측[T-a6e0f9ca]: 검사기(_verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1202 | G5 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — drpPeriod / Period: 원장 V-47c06da9 SEARCH |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1203 | G5 | frm.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — frm.ShowDialog(): 원장 V-d4c116f2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1204 | G5 | frm.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — frm.ShowDialog(): 원장 V-4f013564 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-1205 | G5 | new DM0002_ItembyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-958c81bf |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1206 | G5 | new DM0002_ItembyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-94c018ac |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1207 | G5 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.: 원장 V-7c7fba0d |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-1208 | G5 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.: 원장 V-4066740e |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1209 | G5 | new DMF0082_SaveSalesFuturePrice_Popup() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new DMF0082_SaveSalesFuturePrice_Popup(): 원장 V-b6da1505 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-1210 | G5 | new POPUP.DMF0000_ExchangeRatePopup() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new POPUP.DMF0000_ExchangeRatePopup(): 원장 V-72d2e811 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-1211 | G5 | new SCM0002_ProjectbyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-f8bfb908 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1212 | G5 | popItem.Form_Load(true, sDivision, sTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popItem.Form_Load(true, sDivision, sTeam, sEndCust: 원장 V-65ed96fb |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1213 | G5 | popItem.Form_Load(true, sdivision, sTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popItem.Form_Load(true, sdivision, sTeam, sEndCust: 원장 V-f1f53096 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1214 | G5 | popItem.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popItem.ShowDialog(): 원장 V-a3609e7a |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1215 | G5 | popItem.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popItem.ShowDialog(): 원장 V-5544d062 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1216 | G5 | popProject.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popProject.ShowDialog(): 원장 V-bad04a7d |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1217 | G5 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popup.ShowDialog(): 원장 V-054b6b7b |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-1218 | G5 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popup.ShowDialog(): 원장 V-8b5d7ff3 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-1219 | G5 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popup.ShowDialog(): 원장 V-df4713dd |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1220 | G5 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popup.ShowDialog(): 원장 V-762e6112 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-1221 | H6 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A-15: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (A-15) |
| WK-DMF0082-1222 | H6 | AUTHORITY_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — AUTHORITY_YN: 실측[T-2b9fe6e8]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또 |  | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-1223 | H6 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BIZ_TYPE / Biz Type: 실측[T-c0dad842]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@ |  | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-1224 | H6 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — C: 원장 V-08fa5fdb ASIS / 원장 V-19fb304e ASIS / 원장 V-6d2a3ccb ASIS / 원장 V-5d60f816 ASIS / 원장 V-d2db9b53 ASIS / 원장 V-b6404 |  | 1 (E08-C) |
| WK-DMF0082-1225 | H6 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 실측[T-4b1617f8]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음  |  | 1 (E08-C) |
| WK-DMF0082-1226 | H6 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DIVISION_ID / Div: 실측[T-00380580]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tr |  | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-1227 | H6 | DMF0082_SaveSalesFuturePrice_Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup: 원장 V-b30d0d7a ASIS / 원장 V-35c80d19 ASIS / 원장 V-809cbf80 ASIS / 원장 V-01e85514 ASIS  |  | 2 (DPF-05 ACT:DMF0082_FcstNPrice_Mgmt.btnSa) |
| WK-DMF0082-1228 | H6 | DP-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DP-11: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (DP-11) |
| WK-DMF0082-1229 | H6 | DPF-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DPF-03: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (DPF-03) |
| WK-DMF0082-1230 | H6 | DPF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DPF-04: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (DPF-04) |
| WK-DMF0082-1231 | H6 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E: 원장 V-f540463e ASIS / 원장 V-19fb304e ASIS / 원장 V-44bcd6bd ASIS / 원장 V-d2db9b53 ASIS / 원장 V-b6404ff9 ASIS / 원장 V-085a2 |  | 4 (EVENT:E-09 EVENT:E-10 EVENT:E-11 EVENT:E) |
| WK-DMF0082-1232 | H6 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E08: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (E08) |
| WK-DMF0082-1233 | H6 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — F: 원장 V-08fa5fdb ASIS / 원장 V-19fb304e ASIS / 원장 V-6d2a3ccb ASIS / 원장 V-b30d0d7a ASIS / 원장 V-44bcd6bd ASIS / 원장 V-b6404 |  | 3 (F-09 F-10 S-23) |
| WK-DMF0082-1234 | H6 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-382a67fc]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요 |  | 2 (F-09 F-10) |
| WK-DMF0082-1235 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0082-1236 | H6 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — I: 원장 V-19fb304e ASIS / 원장 V-5d090ce4 ASIS / 원장 V-5d60f816 ASIS / 원장 V-d2db9b53 ASIS / 원장 V-b6404ff9 ASIS / 원장 V-7f498 |  | 3 (A-14 PL-22 PL-25) |
| WK-DMF0082-1237 | H6 | ITEM_CLASS_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ITEM_CLASS_NAME: 실측[T-1cf85815]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trac |  | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-1238 | H6 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ITEM_ID / Model: 실측[T-2ae1f484]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trac |  | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-1239 | H6 | ITEM_NAME / Model Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ITEM_NAME / Model Name: 실측[T-a9cd4765]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필 |  | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-1240 | H6 | ITEM_TYPE / Item Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ITEM_TYPE / Item Type: 실측[T-1fa0729e]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요 |  | 1 (EVENT:E-10) |
| WK-DMF0082-1241 | H6 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — L: 원장 V-35c80d19 ASIS |  | 23 (PL-00 PL-01 PL-02 PL-03 PL-04 PL-19 PL-2) |
| WK-DMF0082-1242 | H6 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — M: 원장 V-08fa5fdb ASIS / 원장 V-6d2a3ccb ASIS / 원장 V-5d60f816 ASIS / 원장 V-d2db9b53 ASIS / 원장 V-b6404ff9 ASIS / 원장 V-7f498 |  | 1 (M-25) |
| WK-DMF0082-1243 | H6 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MEASURE / Measure: 실측[T-bf6aa4be]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@tr |  | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-1244 | H6 | MODAL:ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ExchangeRateModal: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-1245 | H6 | MODAL:VersionSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:VersionSelectModal: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-1246 | H6 | NICK_NAME / Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — NICK_NAME / Nick Name: 실측[T-95c6975a]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요 |  | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-1247 | H6 | OWNER / Owner | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — OWNER / Owner: 실측[T-1a919342]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace  |  | 1 (EVENT:E-09) |
| WK-DMF0082-1248 | H6 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-999d4340]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 |  | 1 (EVENT:E-09) |
| WK-DMF0082-1249 | H6 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PROJECT_NAME / Project: 실측[T-1654a4ca]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필 |  | 2 (PL-26 EVENT:E-09) |
| WK-DMF0082-1250 | H6 | REQ:1ST-48-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:1ST-48-1: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:1ST-48-1) |
| WK-DMF0082-1251 | H6 | REQ:1ST-48-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:1ST-48-2: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-1252 | H6 | REQ:1ST-48-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:1ST-48-3: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-1253 | H6 | REQ:1ST-49-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:1ST-49-1: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-1254 | H6 | REQ:1ST-66-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:1ST-66-1: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-1255 | H6 | REQ:CHAT-20260915-EXLASTUPD | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — H6 54요소: REVIEW:43 · NA:11 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-1256 | H6 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — S: 원장 V-08fa5fdb ASIS / 원장 V-0ee8d4fe ASIS / 원장 V-78da03c8 ASIS / 원장 V-19fb304e ASIS / 원장 V-5d090ce4 ASIS / 원장 V-6d2a3 |  | 3 (S-07 S-23 S-25) |
| WK-DMF0082-1257 | H6 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — cboBucketType / Bucket / Bucket Type: 실측[T-540bdafa]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / 검사기(_ |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1258 | H6 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — clbDivision / Division: 실측[T-5fa805dc]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / 검사기(_verify.spec(@v |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1259 | H6 | clbDivisions / Division / Divisions | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — clbDivisions / Division / Divisions: 실측[T-b4424962]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / 검사기(_v |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1260 | H6 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — drpPeriod / Period: 실측[T-eca57fe6]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / 검사기(_verify.spec(@verif |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1261 | H6 | frm.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — frm.ShowDialog(): 원장 V-0ee8d4fe |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1262 | H6 | frm.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — frm.ShowDialog(): 원장 V-46c5d8e8 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-1263 | H6 | new DM0002_ItembyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-f540463e |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1264 | H6 | new DM0002_ItembyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-787efdcd |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1265 | H6 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.: 원장 V-6d2a3ccb |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-1266 | H6 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.: 원장 V-08fa5fdb |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-1267 | H6 | new DMF0082_SaveSalesFuturePrice_Popup() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new DMF0082_SaveSalesFuturePrice_Popup(): 원장 V-b30d0d7a |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-1268 | H6 | new POPUP.DMF0000_ExchangeRatePopup() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new POPUP.DMF0000_ExchangeRatePopup(): 원장 V-a16ed1c3 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-1269 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-809cbf80 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1270 | H6 | popItem.Form_Load(true, sDivision, sTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popItem.Form_Load(true, sDivision, sTeam, sEndCust: 원장 V-1d6190d2 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1271 | H6 | popItem.Form_Load(true, sdivision, sTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popItem.Form_Load(true, sdivision, sTeam, sEndCust: 원장 V-19fb304e |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1272 | H6 | popItem.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popItem.ShowDialog(): 원장 V-5d090ce4 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnItemId_Cl) |
| WK-DMF0082-1273 | H6 | popItem.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popItem.ShowDialog(): 원장 V-dacdff2c |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1274 | H6 | popProject.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popProject.ShowDialog(): 원장 V-01e85514 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-1275 | H6 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popup.ShowDialog(): 원장 V-78da03c8 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnExchangeR) |
| WK-DMF0082-1276 | H6 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popup.ShowDialog(): 원장 V-265cf573 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnSavePrice) |
| WK-DMF0082-1277 | H6 | popup.ShowDialog() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popup.ShowDialog(): 원장 V-35c80d19 |  | 1 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-1278 | M3 | DMF0082_SaveSalesFuturePrice_Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup: 실측[T-c4fe41b4]: 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: t |  | 38 (ACT:DMF0082_SaveSalesFuturePrice_Popup..) |
| WK-DMF0082-1279 | M4 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A-15: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (A-15) |
| WK-DMF0082-1280 | M4 | AUTHORITY_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — AUTHORITY_YN: 실측[T-86478670]: P 셀 위치 확인 불가 |  | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-1281 | M4 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — B: 실측[T-777018cb]: B: P 셀 위치 확인 불가 — 팝업 선택 자체가 안 돼 판정 불가 |  | 1 (S-23) |
| WK-DMF0082-1282 | M4 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BIZ_TYPE / Biz Type: 실측[T-1ea07967]: P 셀 위치 확인 불가 |  | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-1283 | M4 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — C: 실측[T-bf936914]: P 셀 위치 확인 불가 |  | 1 (E08-C) |
| WK-DMF0082-1284 | M4 | CELL_PROD_SITE_ID / Cell Prod Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CELL_PROD_SITE_ID / Cell Prod Site: 실측[T-02c36bb3]: P 셀 위치 확인 불가 |  | 1 (E08-C) |
| WK-DMF0082-1285 | M4 | DIVISION_ID / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DIVISION_ID / Div: 실측[T-c39d976a]: P 셀 위치 확인 불가 |  | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-1286 | M4 | DMF0082_FcstNPrice_Mgmt.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick: 진입점 집계 — M4 5요소: REVIEW:5 |  | 116 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1287 | M4 | DMF0082_SaveSalesFuturePrice_Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup: 실측[T-0997cd08]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필 |  | 1 (DPF-05) |
| WK-DMF0082-1288 | M4 | DP-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DP-11: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (DP-11) |
| WK-DMF0082-1289 | M4 | DPF-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DPF-03: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (DPF-03) |
| WK-DMF0082-1290 | M4 | DPF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DPF-04: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (DPF-04) |
| WK-DMF0082-1291 | M4 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E: 실측[T-faee532b]: P 셀 위치 확인 불가 |  | 4 (EVENT:E-09 EVENT:E-10 EVENT:E-11 EVENT:E) |
| WK-DMF0082-1292 | M4 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E08: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (E08) |
| WK-DMF0082-1293 | M4 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — F: 실측[T-f1185f2a]: P 셀 위치 확인 불가 |  | 3 (F-09 F-10 S-23) |
| WK-DMF0082-1294 | M4 | FCST_TYPE / FCST Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — FCST_TYPE / FCST Type: 실측[T-88d69247]: P 셀 위치 확인 불가 |  | 2 (F-09 F-10) |
| WK-DMF0082-1295 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0082-1296 | M4 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — I: 실측[T-b2c8145c]: I: P 셀 위치 확인 불가 — 팝업 선택 자체가 안 돼 판정 불가 |  | 3 (A-14 PL-22 PL-25) |
| WK-DMF0082-1297 | M4 | INCOTERMS / Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — INCOTERMS / Incoterms: 실측[T-5949a109]: P 셀 위치 확인 불가 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1298 | M4 | ITEM_CLASS_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_CLASS_NAME: 실측[T-05630509]: P 셀 위치 확인 불가 |  | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-1299 | M4 | ITEM_ID / Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID / Model: 실측[T-19b6985b]: P 셀 위치 확인 불가 |  | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-1300 | M4 | ITEM_NAME / Model Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_NAME / Model Name: 실측[T-a638a5d7]: P 셀 위치 확인 불가 |  | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-1301 | M4 | ITEM_TYPE / Item Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_TYPE / Item Type: 실측[T-e94c190c]: P 셀 위치 확인 불가 |  | 1 (EVENT:E-10) |
| WK-DMF0082-1302 | M4 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — L: 실측[T-af6b896f]: P 셀 위치 확인 불가 |  | 23 (PL-00 PL-01 PL-02 PL-03 PL-04 PL-19 PL-2) |
| WK-DMF0082-1303 | M4 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — M: 실측[T-58300b4f]: P 셀 위치 확인 불가 |  | 1 (M-25) |
| WK-DMF0082-1304 | M4 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MEASURE / Measure: 실측[T-cead534a]: P 셀 위치 확인 불가 |  | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-1305 | M4 | MODAL:ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ExchangeRateModal: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-1306 | M4 | MODAL:VersionSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:VersionSelectModal: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-1307 | M4 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — N: 실측[T-d23e8446]: N: P 셀 위치 확인 불가 — 팝업 선택 자체가 안 돼 판정 불가 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1308 | M4 | NICK_NAME / Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — NICK_NAME / Nick Name: 실측[T-ad12996f]: P 셀 위치 확인 불가 |  | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-1309 | M4 | OWNER / Owner | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — OWNER / Owner: 실측[T-191fe4f6]: P 셀 위치 확인 불가 |  | 1 (EVENT:E-09) |
| WK-DMF0082-1310 | M4 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PROJECT_CODE / Project Code: 실측[T-9c60f2b5]: P 셀 위치 확인 불가 |  | 1 (EVENT:E-09) |
| WK-DMF0082-1311 | M4 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PROJECT_NAME / Project: 실측[T-f3586ca4]: P 셀 위치 확인 불가 |  | 2 (PL-26 EVENT:E-09) |
| WK-DMF0082-1312 | M4 | REQ:1ST-48-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:1ST-48-1: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:1ST-48-1) |
| WK-DMF0082-1313 | M4 | REQ:1ST-48-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:1ST-48-2: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-1314 | M4 | REQ:1ST-48-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:1ST-48-3: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-1315 | M4 | REQ:1ST-49-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:1ST-49-1: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-1316 | M4 | REQ:1ST-66-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:1ST-66-1: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-1317 | M4 | REQ:CHAT-20260915-EXLASTUPD | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — M4 28요소: REVIEW:28 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-1318 | M4 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — S: 실측[T-a70112d1]: P 셀 위치 확인 불가 |  | 3 (S-07 S-23 S-25) |
| WK-DMF0082-1319 | M4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 실측[T-907f1759]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1320 | M4 | clbDivision / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division: 실측[T-5fb08437]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace / 검 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-1321 | M4 | drpPeriod / Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drpPeriod / Period: 실측[T-8415bbca]: 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace / 검사기(_ |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
