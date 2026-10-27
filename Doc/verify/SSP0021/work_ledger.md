# 작업 원장 — SSP0021 · 2026-10-26 12:56

> 검사 인스턴스 991건 중 PASS·NA 141건 외 **850건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 30 | 구현 위치 실존 |
| W3 | 동작 수정 | 3 | 재판정 PASS |
| W4 | 검사기 구현 | 11 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 76 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 289 | 실행 → PASS |
| W7 | 기대값 확정 | 441 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 432 · E2E 289 · 하네스 87 · 대조표 39 · FE 2 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 7건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 88 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 41 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 22 | 24 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 14 | 31 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 44 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  | 30 |  |  |  |  | 10 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  | 15 | 23 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 15 | 23 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 15 | 20 |  |  | 라벨 명칭 |
| G4 | DESIGN |  |  |  |  | 6 | 14 | 13 |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 18 |  | 13 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D1 | EDIT |  |  |  |  |  | 15 | 15 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 15 | 15 |  |  | 행 값 기반 조건부 잠금 |
| G6 | GEN |  |  |  |  |  | 14 | 13 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C2 | CASCADE |  |  |  |  |  | 8 | 16 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 8 | 16 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B3 | COMBO |  |  |  | 11 |  |  | 12 |  |  | 콤보 후보 정렬 = AS-IS |
| F4 | DB |  |  |  |  |  | 19 | 4 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E1 | EDIT |  |  |  |  |  | 13 | 6 |  |  | 숫자 소수자리·정수·부호·범위 |
| M4 | POPUP |  |  |  |  |  | 10 | 8 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 7 |  | 8 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 | 2 | 8 |  |  | 팝업 표준·열림 |
| B1 | COMBO |  |  |  |  | 10 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 10 |  | 1 |  |  | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 7 |  | 4 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 10 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  | 7 | 3 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 9 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-REASON | DESIGN |  |  |  |  |  |  | 9 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C4 | CASCADE |  |  |  |  |  | 7 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| B6 | COMBO |  |  |  |  | 6 |  |  |  |  | ALL 옵션·다중선택 사양 |
| E5 | EDIT |  |  |  |  | 4 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| H3 | DESIGN |  |  |  |  |  | 2 | 2 |  |  | 셀 병합 = AS-IS |
| E3 | EDIT |  |  | 3 |  |  |  |  |  |  | 필수 입력 검증 |
| D4 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
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

## W2 구현 위치 확인 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0001 | X-LOC | Box ID | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Box ID) |
| WK-SSP0021-0002 | X-LOC | Bucket | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Bucket) |
| WK-SSP0021-0003 | X-LOC | CHANGE_REASON_CODE_ALL @lookupType | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CHANGE_REASON_CODE_ALL @lookupType) |
| WK-SSP0021-0004 | X-LOC | Delete | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete) |
| WK-SSP0021-0005 | X-LOC | Division/Company | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Division/Company) |
| WK-SSP0021-0006 | X-LOC | ERP_SO_NO 그룹 동기화 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ERP_SO_NO 그룹 동기화) |
| WK-SSP0021-0007 | X-LOC | Find | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Find) |
| WK-SSP0021-0008 | X-LOC | From Site | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (From Site) |
| WK-SSP0021-0009 | X-LOC | Insert | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Insert) |
| WK-SSP0021-0010 | X-LOC | MEASURE 세로축 표시/개인화 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MEASURE 세로축 표시/개인화) |
| WK-SSP0021-0011 | X-LOC | Measure | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Measure) |
| WK-SSP0021-0012 | X-LOC | Model×2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Model×2) |
| WK-SSP0021-0013 | X-LOC | Period | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Period) |
| WK-SSP0021-0014 | X-LOC | Plan Date | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Plan Date) |
| WK-SSP0021-0015 | X-LOC | Requestor | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Requestor) |
| WK-SSP0021-0016 | X-LOC | Result Type | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Result Type) |
| WK-SSP0021-0017 | X-LOC | SHIP_PLAN 편집 + Simulation | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0018 | X-LOC | Save | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Save) |
| WK-SSP0021-0019 | X-LOC | Shipment Date(period2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Shipment Date(period2)) |
| WK-SSP0021-0020 | X-LOC | Shipment Date(period3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Shipment Date(period3)) |
| WK-SSP0021-0021 | X-LOC | TRANSPORT_MODE 콤보 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (TRANSPORT_MODE 콤보) |
| WK-SSP0021-0022 | X-LOC | bucket 토글 × chkSum | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (bucket 토글 × chkSum) |
| WK-SSP0021-0023 | X-LOC | drill-down | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drill-down) |
| WK-SSP0021-0024 | X-LOC | white-list 편집 5+2열 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0025 | X-LOC | 동적 pivot D_/W_/M_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0026 | X-LOC | 셀콤보 DIVISION_ID(Hold/Result) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0027 | X-LOC | 셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0028 | X-LOC | 토/일 헤더색·MEASURE freeze·병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0029 | X-LOC | 편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0030 | X-LOC | 편집마킹 = CRUD_TYPE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (편집마킹 = CRUD_TYPE) |

## W3 동작 수정 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0031 | E3 | COMMON:UC-04 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — COMMON:UC-04: 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (COMMON:UC-04) |
| WK-SSP0021-0032 | E3 | TRANSPORT_MODE | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — TRANSPORT_MODE: 필수 표시 AS-IS *('Trans Mode*') ↔ TO-BE -('Trans Mode' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfS |  | 2 (D00-4d-005 D00-4d-020) |
| WK-SSP0021-0033 | E3 | 음수 검증 셀 색(시안 #5CD1E5) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — 음수 검증 셀 색(시안 #5CD1E5): 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |

## W4 검사기 구현 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0034 | B3 | CHANGE_REASON_CODE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_REASON_CODE | 있음(SHEET_COLUMNS) | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0035 | B3 | CHANGE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0036 | B3 | CONFIRM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM_ID | 있음(SHEET_COLUMNS) | 15 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0037 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 9 (셀콤보 DIVISION_ID(Hold/Result) ACT:SSP0021) |
| WK-SSP0021-0038 | B3 | EDIT_MAIN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0039 | B3 | ERP_SO_NO | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ERP_SO_NO | 있음(SHEET_COLUMNS) | 8 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0040 | B3 | SHIPMENT_CONFIRM_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_CONFIRM_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0041 | B3 | SHIPMENT_DATE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0042 | B3 | SHIPMENT_STATUS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0043 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0021_ShipmentPlan.GetSpdTitle ACT) |
| WK-SSP0021-0044 | B3 | drpPeriod2 / Shipment Date / Period2 / P | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod2 / Shipment Date / Period2 / Period | 있음(FE 소스) | 3 (ACT:SSP0021_ShipmentPlan.GetSpdTitle ACT) |

## W5 검사기 연결 (76)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0045 | B1 | CHANGE_REASON_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CHANGE_REASON_CODE | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0046 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0047 | B1 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0048 | B1 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0049 | B1 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0021-0050 | B1 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SSP0021-0051 | B1 | clbCompany_ID / Company / Company_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbCompany_ID / Company / Company_ID | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0021-0052 | B1 | clbDivision_ID / Division / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision_ID / Division / Division_ID | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SSP0021-0053 | B1 | clbPlantSite / From Site / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / From Site / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SSP0021-0054 | B1 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0055 | B2 | CHANGE_REASON_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CHANGE_REASON_CODE | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0056 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0057 | B2 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0058 | B2 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0059 | B2 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0021-0060 | B2 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SSP0021-0061 | B2 | clbCompany_ID / Company / Company_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbCompany_ID / Company / Company_ID | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0021-0062 | B2 | clbDivision_ID / Division / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision_ID / Division / Division_ID | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SSP0021-0063 | B2 | clbPlantSite / From Site / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / From Site / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SSP0021-0064 | B2 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0065 | B4 | CHANGE_REASON_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_REASON_CODE | 있음(SHEET_COLUMNS) | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0066 | B4 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0067 | B4 | CONFIRM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM_ID | 있음(SHEET_COLUMNS) | 15 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0068 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 9 (셀콤보 DIVISION_ID(Hold/Result) ACT:SSP0021) |
| WK-SSP0021-0069 | B4 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0070 | B4 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 8 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0071 | B4 | SHIPMENT_CONFIRM_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_CONFIRM_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0072 | B4 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0073 | B4 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0074 | B4 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0075 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0021-0076 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SSP0021-0077 | B4 | clbCompany_ID / Company / Company_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCompany_ID / Company / Company_ID | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0021-0078 | B4 | clbDivision_ID / Division / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision_ID / Division / Division_ID | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SSP0021-0079 | B4 | clbPlantSite / From Site / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / From Site / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SSP0021-0080 | B4 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0081 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0021_ShipmentPlan.GetSpdTitle ACT) |
| WK-SSP0021-0082 | B4 | drpPeriod2 / Shipment Date / Period2 / P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod2 / Shipment Date / Period2 / Period | 있음(FE 소스) | 3 (ACT:SSP0021_ShipmentPlan.GetSpdTitle ACT) |
| WK-SSP0021-0083 | B6 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0021-0084 | B6 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SSP0021-0085 | B6 | clbCompany_ID / Company / Company_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbCompany_ID / Company / Company_ID | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0021-0086 | B6 | clbDivision_ID / Division / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbDivision_ID / Division / Division_ID | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SSP0021-0087 | B6 | clbPlantSite / From Site / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / From Site / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SSP0021-0088 | B6 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SSP0021-0089 | F2 | SSP0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0021 화면 | 판단불가(대상 단위 SCREEN) | 203 (D00-4d-005 D00-4d-006 D00-4d-020 COMMON:) |
| WK-SSP0021-0090 | F6 | SSP0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0021 화면 | 판단불가(대상 단위 SCREEN) | 198 (Save ACT:SSP0021_ShipmentPlan.SaveButton) |
| WK-SSP0021-0091 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0092 | DB-SYN | SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck:3) |
| WK-SSP0021-0093 | DB-SYN | SSP0021_GET_ERP_SO_NO_CNT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_GET_ERP_SO_NO_CNT | 없음(PROC_M 대응 없음) | 8 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0094 | DB-SYN | SSP0021_GET_SHIPMENT_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_GET_SHIPMENT_FROM_SITE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0095 | DB-SYN | SSP0021_GET_SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_GET_SHIPMENT_STATUS | 없음(PROC_M 대응 없음) | 8 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0096 | DB-SYN | SSP0021_SAVE_HOLD_STOCK_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_SAVE_HOLD_STOCK_DATA | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0097 | DB-SYN | SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 없음(PROC_M 대응 없음) | 6 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4290) |
| WK-SSP0021-0098 | G4 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemID2 | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0099 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0100 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0101 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0102 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0103 | G4 | btnSimulation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSimulation | 있음(FE 소스) | 2 (ACT:SSP0021_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0021-0104 | E5 | CHANGE_REASON_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL CHANGE_REASON_CODE | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0105 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0106 | E5 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0107 | E5 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0108 | G03-WIRE | SSP0021 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0021 화면 | 판단불가(대상 단위 SCREEN) | 32 (ACT:SSP0021_ShipmentPlan..ctor ACT:SSP00) |
| WK-SSP0021-0109 | G5 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0110 | G5 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0111 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0112 | G5 | REMARKS2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL REMARKS2 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0113 | G5 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0114 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 1 (Model×2) |
| WK-SSP0021-0115 | G5 | txtModel2 / Model / Model2 / Model/Nickn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtModel2 / Model / Model2 / Model/Nickname | 있음(FE 소스) | 1 (Model×2) |
| WK-SSP0021-0116 | H6 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0117 | H6 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0118 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (D00-2-016) |
| WK-SSP0021-0119 | H6 | REMARKS2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0120 | H6 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |

## W6 검증 실행 (289)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0121 | J2 | SSP0021 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0021 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 147 (D00-1-009 D00-1-012 D00-1-013 D00-1-015 ) |
| WK-SSP0021-0122 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0123 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-008 ACT:SSP0021_ShipmentPlan.Plan_) |
| WK-SSP0021-0124 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SSP0021-0125 | C1 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-010 ACT:SSP0021_ShipmentPlan.SetCh) |
| WK-SSP0021-0126 | C1 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-011 ACT:SSP0021_ShipmentPlan.SetCh) |
| WK-SSP0021-0127 | C1 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0128 | C1 | clbResultType / Result Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbResultType / Result Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InitControls:47) |
| WK-SSP0021-0129 | C1 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-4d-025) |
| WK-SSP0021-0130 | C1 | drpPeriod2 / Shipment Date / Period2 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-012) |
| WK-SSP0021-0131 | C2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0132 | C2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0133 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0134 | C2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0135 | C2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0136 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0137 | C2 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0138 | C2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0139 | C3 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 36 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0140 | C3 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 15 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0141 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0021_ShipmentPlan.InsertRow:2198:) |
| WK-SSP0021-0142 | C3 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 34 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0143 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0144 | C3 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2199:) |
| WK-SSP0021-0145 | C3 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2200:) |
| WK-SSP0021-0146 | C3 | FROM_SITE_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2200:) |
| WK-SSP0021-0147 | C3 | HOLD_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — HOLD_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2207:) |
| WK-SSP0021-0148 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2201:) |
| WK-SSP0021-0149 | C3 | LOT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LOT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.Re_Design:4777:) |
| WK-SSP0021-0150 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SSP0021_ShipmentPlan.EditButton:2443) |
| WK-SSP0021-0151 | C3 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0152 | C3 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0153 | C3 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0154 | C3 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0155 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InsertRow:2202:) |
| WK-SSP0021-0156 | C3 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.InitSpread:627:) |
| WK-SSP0021-0157 | C3 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0158 | C3 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0159 | C3 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 15 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0160 | C3 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 44 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0161 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SSP0021-0162 | C4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SSP0021-0163 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SSP0021-0164 | C4 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SSP0021-0165 | C4 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-011) |
| WK-SSP0021-0166 | C4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-4d-025) |
| WK-SSP0021-0167 | C4 | drpPeriod2 / Shipment Date / Period2 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-012) |
| WK-SSP0021-0168 | C6 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 27 (D00-4d-007 D00-4d-017 ACT:SSP0021_Shipme) |
| WK-SSP0021-0169 | C6 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (D00-4d-012 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0170 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0171 | C6 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (D00-4d-009 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0172 | C6 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0173 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0174 | C6 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0175 | C6 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (D00-2-018 D00-4d-020 ACT:SSP0021_Shipmen) |
| WK-SSP0021-0176 | G3 | SSP0021 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0021 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 10 (D00-1-021 D00-1-028 D00-1-030 COMMON:UC-) |
| WK-SSP0021-0177 | K-SA | SSP0021 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0021 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (D00-1-021 D00-1-028 D00-1-030) |
| WK-SSP0021-0178 | K4 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 99 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0021-0179 | F1 | SSP0021 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0021 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 204 (D00-4d-005 D00-4d-006 D00-4d-020 COMMON:) |
| WK-SSP0021-0180 | F3 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 105 (D00-2-017 D00-2-024 D00-4d-014 D00-4d-01) |
| WK-SSP0021-0181 | F5 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (Delete) |
| WK-SSP0021-0182 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0183 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 662 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0184 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0185 | F4 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0186 | F4 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0187 | F4 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0188 | F4 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0189 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVIS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 3 (Division/Company ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0190 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 265 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0191 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 269 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0192 | F4 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0193 | F4 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0194 | F4 | PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 196 (ACT:SSP0021_ShipmentPlan.SaveButton ACT:) |
| WK-SSP0021-0195 | F4 | SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck:3) |
| WK-SSP0021-0196 | F4 | SSP0021_GET_ERP_SO_NO_CNT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_GET_ERP_SO_NO_CNT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 201 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0197 | F4 | SSP0021_GET_SHIPMENT_FROM_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_GET_SHIPMENT_FROM_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 2 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0198 | F4 | SSP0021_GET_SHIPMENT_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_GET_SHIPMENT_STATUS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 201 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0199 | F4 | SSP0021_SAVE_HOLD_STOCK_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_SAVE_HOLD_STOCK_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 196 (ACT:SSP0021_ShipmentPlan.SaveButton ACT:) |
| WK-SSP0021-0200 | F4 | SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 6 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4290) |
| WK-SSP0021-0201 | A5 | BOH_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOH_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0202 | A5 | BOH_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0203 | A5 | CHANGE_REASON_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0204 | A5 | CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0205 | A5 | CONFIRM_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SSP0021_ShipmentPlan.Re_Design:4766:) |
| WK-SSP0021-0206 | A5 | DAY_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0207 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0208 | A5 | EDIT_MAIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0209 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0210 | A5 | ERP_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0211 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 19 (토/일 헤더색·MEASURE freeze·병합 MEASURE 세로축 표시) |
| WK-SSP0021-0212 | A5 | PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PSI · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (D00-1-023 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0213 | A5 | REMARKS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0214 | A5 | SHIPMENT_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0215 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (TRANSPORT_MODE 콤보) |
| WK-SSP0021-0216 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (D00-1-003 ACT:SSP0021_ShipmentPlan.Defin) |
| WK-SSP0021-0217 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 16 (D00-1-006 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0218 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-004 ACT:SSP0021_ShipmentPlan.InitE) |
| WK-SSP0021-0219 | G4 | clbCompany_ID / Company / Company_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (D00-1-010 ACT:SSP0021_ShipmentPlan.Form_) |
| WK-SSP0021-0220 | G4 | clbDivision_ID / Division / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-001 ACT:SSP0021_ShipmentPlan.InitE) |
| WK-SSP0021-0221 | G4 | clbPlantSite / From Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-002) |
| WK-SSP0021-0222 | G4 | clbResultType / Result Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbResultType / Result Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0223 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 11 (D00-1-007 ACT:SSP0021_ShipmentPlan.Contr) |
| WK-SSP0021-0224 | G4 | drpPeriod2 / Shipment Date / Period2 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 14 (D00-1-019 Shipment Date(period2) ACT:SSP) |
| WK-SSP0021-0225 | G4 | drpPeriod3 / Shipment Date / Period3 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-020 Shipment Date(period3) ACT:SSP) |
| WK-SSP0021-0226 | G4 | txtBoxID / Box ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtBoxID / Box ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-017) |
| WK-SSP0021-0227 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (D00-1-008 Model×2) |
| WK-SSP0021-0228 | G4 | txtModel2 / Model / Model2 / Model/Nickn | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (D00-1-018 Model×2) |
| WK-SSP0021-0229 | G4 | txtRequestor / Requestor | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestor / Requestor · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-014) |
| WK-SSP0021-0230 | H2 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0231 | H2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0232 | H2 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0233 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0234 | H2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0235 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ERP_SO_NO 그룹 동기화 ACT:SSP0021_ShipmentPla) |
| WK-SSP0021-0236 | H2 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0237 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (토/일 헤더색·MEASURE freeze·병합 MEASURE 세로축 표시) |
| WK-SSP0021-0238 | H2 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-1-023 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0239 | H2 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0240 | H2 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0241 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0242 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0243 | H2 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0244 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (TRANSPORT_MODE 콤보 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0245 | H3 | DAY_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DAY_CODE · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0246 | H3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0247 | H4 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (ACT:SSP0021_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0021-0248 | H5 | BOH_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOH_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0249 | H5 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOH_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0250 | H5 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0251 | H5 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DAY_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (토/일 헤더색·MEASURE freeze·병합) |
| WK-SSP0021-0252 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0253 | H5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_MAIN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0254 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ERP_SO_NO 그룹 동기화) |
| WK-SSP0021-0255 | H5 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_STATUS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0256 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 19 (토/일 헤더색·MEASURE freeze·병합 MEASURE 세로축 표시) |
| WK-SSP0021-0257 | H5 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PSI · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (D00-1-023 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0258 | H5 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0259 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (TRANSPORT_MODE 콤보) |
| WK-SSP0021-0260 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0261 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (bucket 토글 × chkSum ACT:SSP0021_ShipmentP) |
| WK-SSP0021-0262 | H5 | clbDivision_ID / Division / Division_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) |  | 3 (D00-2-011 ACT:SSP0021_ShipmentPlan.InitS) |
| WK-SSP0021-0263 | I1 | SSP0021 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0021 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 51 (D00-4d-004 D00-4d-013 D00-4d-025 COMMON:) |
| WK-SSP0021-0264 | SC1 | SSP0021 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0021 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 30 (D00-1-001 D00-1-002 D00-1-003 D00-1-004 ) |
| WK-SSP0021-0265 | D1 | BACK_COLOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BACK_COLOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0266 | D1 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2476) |
| WK-SSP0021-0267 | D1 | CONFIRM_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONFIRM_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0268 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0269 | D1 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0270 | D1 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0271 | D1 | HOLD_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — HOLD_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton:2485) |
| WK-SSP0021-0272 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0273 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2488) |
| WK-SSP0021-0274 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 10 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0275 | D1 | MODEL_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MODEL_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2474) |
| WK-SSP0021-0276 | D1 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0277 | D1 | REQUESTOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REQUESTOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2473) |
| WK-SSP0021-0278 | D1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0279 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0280 | D3 | BACK_COLOR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BACK_COLOR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0281 | D3 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2476) |
| WK-SSP0021-0282 | D3 | CONFIRM_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONFIRM_DAY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0283 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0284 | D3 | EDIT_MAIN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDIT_MAIN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (편집마킹 = CRUD_TYPE) |
| WK-SSP0021-0285 | D3 | ERP_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0286 | D3 | HOLD_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — HOLD_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton:2485) |
| WK-SSP0021-0287 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0288 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2488) |
| WK-SSP0021-0289 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 10 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0290 | D3 | MODEL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MODEL_USER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2474) |
| WK-SSP0021-0291 | D3 | REMARKS3 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REMARKS3 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0292 | D3 | REQUESTOR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REQUESTOR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2473) |
| WK-SSP0021-0293 | D3 | SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0294 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.EditButton ACT:) |
| WK-SSP0021-0295 | D4 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert) |
| WK-SSP0021-0296 | D5 | BOH_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — BOH_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0297 | D5 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0298 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (셀콤보 DIVISION_ID(Hold/Result)) |
| WK-SSP0021-0299 | D5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0300 | D5 | PSI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PSI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0021-0301 | D5 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REA) |
| WK-SSP0021-0302 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (D00-2-018 TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0303 | D6 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-03 Insert ACT:SSP) |
| WK-SSP0021-0304 | E1 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 9 (D00-4d-017 ACT:SSP0021_ShipmentPlan.SpdD) |
| WK-SSP0021-0305 | E1 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0306 | E1 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 12 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0307 | E1 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0308 | E1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (ACT:SSP0021_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0021-0309 | E1 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0310 | E1 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0311 | E1 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0312 | E1 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0313 | E1 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0314 | E1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0315 | E1 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 9 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0316 | E1 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0317 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0318 | E4 | ERP_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ERP_STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-004 편집 가드(ERP_STATUS='C'/TRANSPOR) |
| WK-SSP0021-0319 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0320 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0321 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0322 | E4 | MSG00047 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00047 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0323 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0324 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2377) |
| WK-SSP0021-0325 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0326 | E4 | MSG00189 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00189 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE) |
| WK-SSP0021-0327 | E4 | MSG00194 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00194 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0328 | E4 | MSG00197 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00197 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0329 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0330 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.checkValidN:291) |
| WK-SSP0021-0331 | E4 | MSG00247 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00247 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0332 | E4 | MSG00248 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00248 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.GetShipmentStat) |
| WK-SSP0021-0333 | E4 | MSG00249 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00249 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.GetShipmentStat) |
| WK-SSP0021-0334 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2369) |
| WK-SSP0021-0335 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0021-0336 | E4 | MSG00278 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00278 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0337 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4381) |
| WK-SSP0021-0338 | E4 | MSG00285 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00285 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0339 | E4 | MSG00286 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00286 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0340 | E4 | MSG00287 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00287 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0341 | E4 | MSG00292 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00292 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.Simulation:6096) |
| WK-SSP0021-0342 | E4 | MSG00306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck:3) |
| WK-SSP0021-0343 | E4 | MSG00312 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00312 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.EditButton:2457) |
| WK-SSP0021-0344 | E4 | MSG00313 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00313 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0021-0345 | E4 | MSG00324 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00324 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0021_ShipmentPlan.NewNonSoNo:4358) |
| WK-SSP0021-0346 | E4 | MSG00404 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00404 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0347 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SSP0021-0348 | E4 | MSG01291 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01291 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-013) |
| WK-SSP0021-0349 | E4 | MSG01401 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01401 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-004) |
| WK-SSP0021-0350 | E4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0351 | E4 | TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-005 D00-4d-020 ACT:SSP0021_Shipme) |
| WK-SSP0021-0352 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0353 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 1 (ACT:SSP0021_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0021-0354 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0355 | E4 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 2 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0356 | E4 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지 |  | 3 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0357 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-025 ACT:SSP0021_ShipmentPlan.Find) |
| WK-SSP0021-0358 | A10 | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 234 (ACT:SSP0021_ShipmentPlan.DefineProperty ) |
| WK-SSP0021-0359 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 464 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0360 | A6 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0361 | A6 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0362 | A6 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0363 | A6 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0364 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVIS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 1 (Division/Company) |
| WK-SSP0021-0365 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 70 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0366 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 74 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0367 | A6 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0368 | A6 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE  |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0369 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-003 D00-2-007) |
| WK-SSP0021-0370 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 24 (D00-1-006 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0371 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-004) |
| WK-SSP0021-0372 | G1 | clbCompany_ID / Company / Company_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 22 (D00-1-010 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0373 | G1 | clbDivision_ID / Division / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 17 (D00-1-001 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0374 | G1 | clbPlantSite / From Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 17 (D00-1-002 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0375 | G1 | clbResultType / Result Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbResultType / Result Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0376 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-007 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0377 | G1 | drpPeriod2 / Shipment Date / Period2 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-019 Shipment Date(period2) ACT:SSP) |
| WK-SSP0021-0378 | G1 | drpPeriod3 / Shipment Date / Period3 / P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-020 Shipment Date(period3) ACT:SSP) |
| WK-SSP0021-0379 | G1 | txtBoxID / Box ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtBoxID / Box ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-017 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0380 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-008 Model×2 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0381 | G1 | txtModel2 / Model / Model2 / Model/Nickn | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 16 (D00-1-018 Model×2 ACT:SSP0021_ShipmentPl) |
| WK-SSP0021-0382 | G1 | txtRequestor / Requestor | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequestor / Requestor · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-014 ACT:SSP0021_ShipmentPlan.FindD) |
| WK-SSP0021-0383 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (D00-1-003 ACT:SSP0021_ShipmentPlan.Defin) |
| WK-SSP0021-0384 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (D00-1-006 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0385 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-004 ACT:SSP0021_ShipmentPlan.InitE) |
| WK-SSP0021-0386 | G6 | clbCompany_ID / Company / Company_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCompany_ID / Company / Company_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (D00-1-010 ACT:SSP0021_ShipmentPlan.Form_) |
| WK-SSP0021-0387 | G6 | clbDivision_ID / Division / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision_ID / Division / Division_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-001 ACT:SSP0021_ShipmentPlan.InitE) |
| WK-SSP0021-0388 | G6 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-002) |
| WK-SSP0021-0389 | G6 | clbResultType / Result Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbResultType / Result Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-016 ACT:SSP0021_ShipmentPlan.InitC) |
| WK-SSP0021-0390 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SSP0021-0391 | G6 | drpPeriod2 / Shipment Date / Period2 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod2 / Shipment Date / Period2 / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-019 Shipment Date(period2) ACT:SSP) |
| WK-SSP0021-0392 | G6 | drpPeriod3 / Shipment Date / Period3 / P | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod3 / Shipment Date / Period3 / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-020 Shipment Date(period3) ACT:SSP) |
| WK-SSP0021-0393 | G6 | txtBoxID / Box ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtBoxID / Box ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-017) |
| WK-SSP0021-0394 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (D00-1-008 Model×2) |
| WK-SSP0021-0395 | G6 | txtModel2 / Model / Model2 / Model/Nickn | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (D00-1-018 Model×2) |
| WK-SSP0021-0396 | G6 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-014) |
| WK-SSP0021-0397 | X-REOPEN | SSP0021 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0021 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 36 (ACT:SSP0021_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0021-0398 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (Model×2) |
| WK-SSP0021-0399 | H6 | txtModel2 / Model / Model2 / Model/Nickn | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (Model×2) |
| WK-SSP0021-0400 | M4 | BOH_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BOH_QTY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 20 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0401 | M4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0402 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0403 | M4 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0404 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-2-016 ACT:SSP0021_ShipmentPlan.SpdDe) |
| WK-SSP0021-0405 | M4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 25 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0406 | M4 | REMARKS2 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — REMARKS2 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0407 | M4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0408 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (Model×2) |
| WK-SSP0021-0409 | M4 | txtModel2 / Model / Model2 / Model/Nickn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtModel2 / Model / Model2 / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (Model×2) |

## W7 기대값 확정 (441)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0021-0410 | C2 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-013: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0021-0411 | C2 | D00-2-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-017: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-017) |
| WK-SSP0021-0412 | C2 | D00-2-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-019: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-019) |
| WK-SSP0021-0413 | C2 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-001: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0021-0414 | C2 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-002: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SSP0021-0415 | C2 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-008: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SSP0021-0416 | C2 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-013: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SSP0021-0417 | C2 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-016: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SSP0021-0418 | C2 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-018: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SSP0021-0419 | C2 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0420 | C2 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0421 | C2 | SSP0021_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0422 | C2 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0423 | C2 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0424 | C2 | SSP0021_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0425 | C2 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0426 | C3 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-013: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0021-0427 | C3 | D00-2-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-017: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-017) |
| WK-SSP0021-0428 | C3 | D00-2-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-019: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-019) |
| WK-SSP0021-0429 | C3 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-024: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0021-0430 | C3 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-001: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0021-0431 | C3 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-002: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SSP0021-0432 | C3 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-008: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SSP0021-0433 | C3 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-013: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SSP0021-0434 | C3 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-014: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SSP0021-0435 | C3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-015: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0021-0436 | C3 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-016: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SSP0021-0437 | C3 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-018: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SSP0021-0438 | C3 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0439 | C3 | SSP0021_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.SetChangeControl: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0021_ShipmentPlan.SetChangeContro) |
| WK-SSP0021-0440 | C3 | SSP0021_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.SetChangedControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0441 | C3 | SSP0021_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.SetLockSumColumn: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.SetLockSumColum) |
| WK-SSP0021-0442 | C3 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0443 | C3 | SSP0021_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.Set_SumValues: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SSP0021_ShipmentPlan.Set_SumValues:4) |
| WK-SSP0021-0444 | C3 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0445 | C3 | SSP0021_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0446 | C3 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0447 | C3 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0448 | C3 | SSP0021_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0449 | C3 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0450 | C6 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-013: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0021-0451 | C6 | D00-2-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-017: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-017) |
| WK-SSP0021-0452 | C6 | D00-2-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-019: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-019) |
| WK-SSP0021-0453 | C6 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-001: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0021-0454 | C6 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-002: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SSP0021-0455 | C6 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-008: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SSP0021-0456 | C6 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-013: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SSP0021-0457 | C6 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-016: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SSP0021-0458 | C6 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-018: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SSP0021-0459 | C6 | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0460 | C6 | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0461 | C6 | SSP0021_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0462 | C6 | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0463 | C6 | SSP0021_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0464 | C6 | SSP0021_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0465 | C6 | SSP0021_ShipmentPlan.clbDivision_ID_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0021_ShipmentPlan.clbDivision_ID_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0021_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0021-0466 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0467 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0468 | B3 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Bucket: 행 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 1 (Bucket) |
| WK-SSP0021-0469 | B3 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Result Type: 행 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 1 (Result Type) |
| WK-SSP0021-0470 | B3 | SSP0021_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetBucketType: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0471 | B3 | SSP0021_ShipmentPlan.GetERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetERPInterface: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0472 | B3 | SSP0021_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheck: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck:3) |
| WK-SSP0021-0473 | B3 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0474 | B3 | SSP0021_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0475 | B3 | SSP0021_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt:3) |
| WK-SSP0021-0476 | B3 | SSP0021_ShipmentPlan.GetNewERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetNewERPInterface: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0477 | B3 | SSP0021_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetSSPUserCheck: 진입점 집계 — B3 11요소: TODO:11 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0478 | B3 | SSP0021_ShipmentPlan.GetShipmentStatusCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetShipmentStatusChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0021_ShipmentPlan.GetShipmentStat) |
| WK-SSP0021-0479 | B3 | SSP0021_ShipmentPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0021_ShipmentPlan.GetSpdTitle: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0021-0480 | B4 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Bucket: 행 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 1 (Bucket) |
| WK-SSP0021-0481 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0482 | B4 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Result Type: 행 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 1 (Result Type) |
| WK-SSP0021-0483 | B4 | SSP0021_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetBucketType: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.GetBucketType:4) |
| WK-SSP0021-0484 | B4 | SSP0021_ShipmentPlan.GetERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetERPInterface: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 85 (ACT:SSP0021_ShipmentPlan.GetERPInterface) |
| WK-SSP0021-0485 | B4 | SSP0021_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheck: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck:3) |
| WK-SSP0021-0486 | B4 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0487 | B4 | SSP0021_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0488 | B4 | SSP0021_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt:3) |
| WK-SSP0021-0489 | B4 | SSP0021_ShipmentPlan.GetNewERPInterface | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetNewERPInterface: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0021_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0021-0490 | B4 | SSP0021_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetSSPUserCheck: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0491 | B4 | SSP0021_ShipmentPlan.GetShipmentStatusCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetShipmentStatusChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0021_ShipmentPlan.GetShipmentStat) |
| WK-SSP0021-0492 | B4 | SSP0021_ShipmentPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0021_ShipmentPlan.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0021-0493 | DB-SYN | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Find: 행 집계 — DB-SYN 19요소: PASS:12 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SSP0021-0494 | DB-SYN | SSP0021_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0021_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 — DB-SYN 19요소: PASS:12 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0021-0495 | DB-SYN | SSP0021_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — DB-SYN 19요소: PASS:12 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0496 | DB-SYN | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Save: 행 집계 — DB-SYN 19요소: PASS:12 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-SSP0021-0497 | F4 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Find: 행 집계 — F4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SSP0021-0498 | F4 | SSP0021_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0021_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 — F4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0021-0499 | F4 | SSP0021_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 — F4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0500 | F4 | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Save: 행 집계 — F4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-SSP0021-0501 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0502 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0503 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0504 | A5 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-024: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SSP0021-0505 | A5 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-025: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SSP0021-0506 | A5 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-026: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0021-0507 | A5 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-011: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SSP0021-0508 | A5 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-014: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0021-0509 | A5 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R10: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SSP0021-0510 | A5 | R2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R2: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R2) |
| WK-SSP0021-0511 | A5 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R3: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SSP0021-0512 | A5 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R4: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SSP0021-0513 | A5 | SHIP_PLAN 편집 + Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SHIP_PLAN 편집 + Simulation: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0514 | A5 | SSP0021_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0021_ShipmentPlan.CreateSpread: 진입점 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0515 | A5 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0516 | A5 | bucket 토글 × chkSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — bucket 토글 × chkSum: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (bucket 토글 × chkSum) |
| WK-SSP0021-0517 | A5 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — drill-down: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
| WK-SSP0021-0518 | A5 | white-list 편집 5+2열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — white-list 편집 5+2열: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0519 | A5 | 동적 pivot D_/W_/M_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 동적 pivot D_/W_/M_: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0520 | A5 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 이벤트: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0521 | A5 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 조회: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (조회) |
| WK-SSP0021-0522 | A5 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 합계: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합계) |
| WK-SSP0021-0523 | A5 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 헤더: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (헤더) |
| WK-SSP0021-0524 | G4 | Box ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Box ID: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Box ID) |
| WK-SSP0021-0525 | G4 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Bucket: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Bucket) |
| WK-SSP0021-0526 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0527 | G4 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-021: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0021-0528 | G4 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-028: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SSP0021-0529 | G4 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-029: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SSP0021-0530 | G4 | Division/Company | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Division/Company: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Division/Company) |
| WK-SSP0021-0531 | G4 | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — From Site: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (From Site) |
| WK-SSP0021-0532 | G4 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Measure: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0533 | G4 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Period: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Period) |
| WK-SSP0021-0534 | G4 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Plan Date: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Plan Date) |
| WK-SSP0021-0535 | G4 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Requestor: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0536 | G4 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Result Type: 행 집계 — G4 20요소: NOT_RUN:14 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Result Type) |
| WK-SSP0021-0537 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0538 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0539 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0540 | H2 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-024: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SSP0021-0541 | H2 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-025: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SSP0021-0542 | H2 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-026: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0021-0543 | H2 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-011: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SSP0021-0544 | H2 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-014: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0021-0545 | H2 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R10: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SSP0021-0546 | H2 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R3: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SSP0021-0547 | H2 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R4: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SSP0021-0548 | H2 | SHIP_PLAN 편집 + Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SHIP_PLAN 편집 + Simulation: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0549 | H2 | SSP0021_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0021_ShipmentPlan.CreateSpread: 진입점 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0550 | H2 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0551 | H2 | bucket 토글 × chkSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — bucket 토글 × chkSum: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (bucket 토글 × chkSum) |
| WK-SSP0021-0552 | H2 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — drill-down: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
| WK-SSP0021-0553 | H2 | white-list 편집 5+2열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — white-list 편집 5+2열: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0554 | H2 | 동적 pivot D_/W_/M_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 동적 pivot D_/W_/M_: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0555 | H2 | 음수 검증 셀 색(시안 #5CD1E5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 음수 검증 셀 색(시안 #5CD1E5): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |
| WK-SSP0021-0556 | H2 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 이벤트: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0557 | H2 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 조회: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (조회) |
| WK-SSP0021-0558 | H2 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 합계: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합계) |
| WK-SSP0021-0559 | H2 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 헤더: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (헤더) |
| WK-SSP0021-0560 | H3 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — 이벤트: 행 집계 — H3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0021-0561 | H3 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — 헤더: 행 집계 — H3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (헤더) |
| WK-SSP0021-0562 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0563 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0564 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0565 | H5 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-024: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SSP0021-0566 | H5 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-025: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SSP0021-0567 | H5 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-026: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0021-0568 | H5 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-014: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SSP0021-0569 | H5 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R10: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SSP0021-0570 | H5 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R3: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SSP0021-0571 | H5 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R4: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SSP0021-0572 | H5 | SHIP_PLAN 편집 + Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SHIP_PLAN 편집 + Simulation: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0573 | H5 | SSP0021_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0021_ShipmentPlan.CreateSpread: 진입점 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0574 | H5 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0575 | H5 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — drill-down: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
| WK-SSP0021-0576 | H5 | white-list 편집 5+2열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — white-list 편집 5+2열: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0577 | H5 | 동적 pivot D_/W_/M_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 동적 pivot D_/W_/M_: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (동적 pivot D_/W_/M_) |
| WK-SSP0021-0578 | H5 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 이벤트: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0579 | H5 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 조회: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (조회) |
| WK-SSP0021-0580 | H5 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 합계: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합계) |
| WK-SSP0021-0581 | H5 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 헤더: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (헤더) |
| WK-SSP0021-0582 | X-REASON | D00-1-053 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-053 §1 emptySpaceItem2 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-053) |
| WK-SSP0021-0583 | X-REASON | D00-1-054 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-054 §1 emptySpaceItem3 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-054) |
| WK-SSP0021-0584 | X-REASON | D00-1-055 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-055 §1 emptySpaceItem5 / EmptySpaceItem — DevExpress 여백 아이템 — TO-BE 무등가 해당없음 |  | 1 (D00-1-055) |
| WK-SSP0021-0585 | X-REASON | D00-2-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-021 §2 spdDetail / TopChange — FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 제외 |  | 1 (D00-2-021) |
| WK-SSP0021-0586 | X-REASON | D00-2-025 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-025 §2 spdMain / TopChange — FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 제외 |  | 1 (D00-2-025) |
| WK-SSP0021-0587 | X-REASON | D00-4b-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-001 §4b Data_SCP.Common / SSPBlockCheckIF / dtERPBlockYnIF — ERP IF 블록 여부 사전체크 — Drafting/ERP IF 하위 SP 체 |  | 1 (D00-4b-001) |
| WK-SSP0021-0588 | X-REASON | D00-4d-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-021 §4d SpdDetail_CellClick / `e.Column == CHANGE_REQ_NO` — CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanReque |  | 1 (D00-4d-021) |
| WK-SSP0021-0589 | X-REASON | D00-4d-022 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-022 §4d SpdDetail_CellClick / `IsNullOrWhiteSpace(sRequestNo)` — CHANGE_REQ_NO 공백 시 팝업 미진입 가드 — 상위 팝업(D0 |  | 1 (D00-4d-022) |
| WK-SSP0021-0590 | X-REASON | Edit | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Edit 권한+모드토글 미이식(R6) 미이식(근거) |  | 1 (Edit) |
| WK-SSP0021-0591 | D1 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-013: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0021-0592 | D1 | D00-2-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-019: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-019) |
| WK-SSP0021-0593 | D1 | D00-2-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-023: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-023) |
| WK-SSP0021-0594 | D1 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-024: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0021-0595 | D1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-001: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0021-0596 | D1 | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-003: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-003) |
| WK-SSP0021-0597 | D1 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-011: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SSP0021-0598 | D1 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-015: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0021-0599 | D1 | R7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R7: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R7) |
| WK-SSP0021-0600 | D1 | R8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R8: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R8) |
| WK-SSP0021-0601 | D1 | R9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R9: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R9) |
| WK-SSP0021-0602 | D1 | SHIP_PLAN 편집 + Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SHIP_PLAN 편집 + Simulation: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0603 | D1 | SSP0021_ShipmentPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0021_ShipmentPlan.EditButton: 진입점 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0021_ShipmentPlan.EditButton:2363) |
| WK-SSP0021-0604 | D1 | white-list 편집 5+2열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — white-list 편집 5+2열: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0605 | D1 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 이벤트: 행 집계 — D1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0606 | D3 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-013: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SSP0021-0607 | D3 | D00-2-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-019: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-019) |
| WK-SSP0021-0608 | D3 | D00-2-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-023: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-023) |
| WK-SSP0021-0609 | D3 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-024: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0021-0610 | D3 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-001: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SSP0021-0611 | D3 | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-003: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-003) |
| WK-SSP0021-0612 | D3 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-011: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SSP0021-0613 | D3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-015: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0021-0614 | D3 | R7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R7: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R7) |
| WK-SSP0021-0615 | D3 | R8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R8: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R8) |
| WK-SSP0021-0616 | D3 | R9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R9: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R9) |
| WK-SSP0021-0617 | D3 | SHIP_PLAN 편집 + Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SHIP_PLAN 편집 + Simulation: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (SHIP_PLAN 편집 + Simulation) |
| WK-SSP0021-0618 | D3 | SSP0021_ShipmentPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0021_ShipmentPlan.EditButton: 진입점 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0021_ShipmentPlan.EditButton:2363) |
| WK-SSP0021-0619 | D3 | white-list 편집 5+2열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — white-list 편집 5+2열: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (white-list 편집 5+2열) |
| WK-SSP0021-0620 | D3 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 이벤트: 행 집계 — D3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0621 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SSP0021-0622 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0623 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0624 | D5 | SSP0021_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0021_ShipmentPlan.CreateSpread: 진입점 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SSP0021_ShipmentPlan.CreateSpread:54) |
| WK-SSP0021-0625 | D5 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0626 | E1 | D00-2-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-2-017: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-017) |
| WK-SSP0021-0627 | E1 | D00-2-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-2-024: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-024) |
| WK-SSP0021-0628 | E1 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-014: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SSP0021-0629 | E1 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-015: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SSP0021-0630 | E1 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-016: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SSP0021-0631 | E1 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-4d-018: 행 집계 — E1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SSP0021-0632 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 41요소: NOT_RUN:41 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SSP0021-0633 | E4 | SSP0021_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0021_ShipmentPlan.SetChangeControl: 진입점 집계 — E4 41요소: NOT_RUN:41 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0021_ShipmentPlan.SetChangeContro) |
| WK-SSP0021-0634 | E4 | SSP0021_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0021_ShipmentPlan.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0635 | E4 | SSP0021_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0021_ShipmentPlan.SetLockSumColumn: 진입점 집계 — E4 41요소: NOT_RUN:41 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.SetLockSumColum) |
| WK-SSP0021-0636 | E4 | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0637 | E4 | SSP0021_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0021_ShipmentPlan.Set_SumValues: 진입점 집계 — E4 41요소: NOT_RUN:41 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SSP0021_ShipmentPlan.Set_SumValues:4) |
| WK-SSP0021-0638 | E4 | 음수 검증 셀 색(시안 #5CD1E5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 음수 검증 셀 색(시안 #5CD1E5): 행 집계 — E4 41요소: NOT_RUN:41 (미실행 요소가 남아 판정필요) |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |
| WK-SSP0021-0639 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0021-0640 | A1 | Box ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Box ID: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Box ID) |
| WK-SSP0021-0641 | A1 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Bucket: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Bucket) |
| WK-SSP0021-0642 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-02) |
| WK-SSP0021-0643 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0644 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0645 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0646 | A1 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-009: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-009) |
| WK-SSP0021-0647 | A1 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-012: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-012) |
| WK-SSP0021-0648 | A1 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-013: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-013) |
| WK-SSP0021-0649 | A1 | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-015: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-015) |
| WK-SSP0021-0650 | A1 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-021: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-021) |
| WK-SSP0021-0651 | A1 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-028: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-028) |
| WK-SSP0021-0652 | A1 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-029: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-1-029) |
| WK-SSP0021-0653 | A1 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-005: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-2-005) |
| WK-SSP0021-0654 | A1 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-007: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-2-007) |
| WK-SSP0021-0655 | A1 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Find) |
| WK-SSP0021-0656 | A1 | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — From Site: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (From Site) |
| WK-SSP0021-0657 | A1 | MEASURE 세로축 표시/개인화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MEASURE 세로축 표시/개인화: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (MEASURE 세로축 표시/개인화) |
| WK-SSP0021-0658 | A1 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Measure: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Measure) |
| WK-SSP0021-0659 | A1 | Model×2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model×2: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Model×2) |
| WK-SSP0021-0660 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 464 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0661 | A1 | PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_HOLD_STOCK — 팝업·보조 SP 는 golden_cases.csv  |  | 54 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0662 | A1 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_MES_STOCK — 팝업·보조 SP 는 golden_cases.csv 에  |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0663 | A1 | PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_MES_STOCK_DETAIL — 팝업·보조 SP 는 golde |  | 60 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0664 | A1 | PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_OWMS_DETAIL — 팝업·보조 SP 는 golden_cases.cs |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0665 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION — 팝업·보조 SP 는 gol |  | 1 (Division/Company) |
| WK-SSP0021-0666 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN — 팝업·보조 SP 는 golden_case |  | 70 (ACT:SSP0021_ShipmentPlan.FindButton ACT:) |
| WK-SSP0021-0667 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN_DETAIL — 팝업·보조 SP |  | 74 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0668 | A1 | PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_SHIPMENT_RESULT — 팝업·보조 SP 는 golden_ |  | 55 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0669 | A1 | PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL: 골든 비교 케이스 없음(PKG_SSP0021.P_SSP0021_GET_STOCK_LOCATION_DETAIL — 팝업·보조  |  | 56 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0670 | A1 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Period: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Period) |
| WK-SSP0021-0671 | A1 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plan Date: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Plan Date) |
| WK-SSP0021-0672 | A1 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R3: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R3) |
| WK-SSP0021-0673 | A1 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R4: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R4) |
| WK-SSP0021-0674 | A1 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Requestor: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Requestor) |
| WK-SSP0021-0675 | A1 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Result Type: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Result Type) |
| WK-SSP0021-0676 | A1 | Shipment Date(period2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Shipment Date(period2): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Shipment Date(period2)) |
| WK-SSP0021-0677 | A1 | Shipment Date(period3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Shipment Date(period3): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (Shipment Date(period3)) |
| WK-SSP0021-0678 | A1 | TransMode 행단위 cascade 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — TransMode 행단위 cascade 재조회: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0679 | A1 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 이벤트: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (이벤트) |
| WK-SSP0021-0680 | A1 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (조회) |
| WK-SSP0021-0681 | A1 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 합계: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (합계) |
| WK-SSP0021-0682 | A1 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 헤더: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (헤더) |
| WK-SSP0021-0683 | A1 | 확정구간(CONFIRM_DAY) 조회전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 확정구간(CONFIRM_DAY) 조회전용: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0684 | A6 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Find: 행 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SSP0021-0685 | G1 | Box ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Box ID: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Box ID) |
| WK-SSP0021-0686 | G1 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Bucket: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Bucket) |
| WK-SSP0021-0687 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SSP0021-0688 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0021-0689 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0690 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0021-0691 | G1 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-009: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SSP0021-0692 | G1 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-012: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SSP0021-0693 | G1 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-013: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SSP0021-0694 | G1 | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-015: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-015) |
| WK-SSP0021-0695 | G1 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-021: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0021-0696 | G1 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-028: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SSP0021-0697 | G1 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-029: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SSP0021-0698 | G1 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-005: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0021-0699 | G1 | Division/Company | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Division/Company: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Division/Company) |
| WK-SSP0021-0700 | G1 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Find: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SSP0021-0701 | G1 | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — From Site: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (From Site) |
| WK-SSP0021-0702 | G1 | MEASURE 세로축 표시/개인화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MEASURE 세로축 표시/개인화: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (MEASURE 세로축 표시/개인화) |
| WK-SSP0021-0703 | G1 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Measure: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0704 | G1 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Period: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Period) |
| WK-SSP0021-0705 | G1 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plan Date: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Plan Date) |
| WK-SSP0021-0706 | G1 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R3: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SSP0021-0707 | G1 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R4: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SSP0021-0708 | G1 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Requestor: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0709 | G1 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Result Type: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Result Type) |
| WK-SSP0021-0710 | G1 | TransMode 행단위 cascade 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — TransMode 행단위 cascade 재조회: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0711 | G1 | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 이벤트: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (이벤트) |
| WK-SSP0021-0712 | G1 | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (조회) |
| WK-SSP0021-0713 | G1 | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 합계: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (합계) |
| WK-SSP0021-0714 | G1 | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 헤더: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (헤더) |
| WK-SSP0021-0715 | G1 | 확정구간(CONFIRM_DAY) 조회전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 확정구간(CONFIRM_DAY) 조회전용: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0716 | G6 | Box ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Box ID: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Box ID) |
| WK-SSP0021-0717 | G6 | Bucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Bucket: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Bucket) |
| WK-SSP0021-0718 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0021-0719 | G6 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-021: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SSP0021-0720 | G6 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-028: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SSP0021-0721 | G6 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-029: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SSP0021-0722 | G6 | Division/Company | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Division/Company: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Division/Company) |
| WK-SSP0021-0723 | G6 | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — From Site: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (From Site) |
| WK-SSP0021-0724 | G6 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Measure: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0725 | G6 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Period: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Period) |
| WK-SSP0021-0726 | G6 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Plan Date: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Plan Date) |
| WK-SSP0021-0727 | G6 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Requestor: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0728 | G6 | Result Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Result Type: 행 집계 — G6 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (Result Type) |
| WK-SSP0021-0729 | X-LOC | OrderDetail 팝업(SSP0300) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OrderDetail 팝업(SSP0300): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0730 | X-LOC | R7a USER_CHECK 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R7a USER_CHECK 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R7a USER_CHECK 가드) |
| WK-SSP0021-0731 | X-LOC | TransMode 행단위 cascade 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TransMode 행단위 cascade 재조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TransMode 행단위 cascade 재조회) |
| WK-SSP0021-0732 | X-LOC | 같은 셀 더블클릭 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 같은 셀 더블클릭 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (같은 셀 더블클릭 가드) |
| WK-SSP0021-0733 | X-LOC | 음수 검증 셀 색(시안 #5CD1E5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 음수 검증 셀 색(시안 #5CD1E5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (음수 검증 셀 색(시안 #5CD1E5)) |
| WK-SSP0021-0734 | X-LOC | 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 이벤트: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (이벤트) |
| WK-SSP0021-0735 | X-LOC | 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회) |
| WK-SSP0021-0736 | X-LOC | 합계 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 합계: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (합계) |
| WK-SSP0021-0737 | X-LOC | 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 헤더: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (헤더) |
| WK-SSP0021-0738 | X-LOC | 확정구간(CONFIRM_DAY) 조회전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 확정구간(CONFIRM_DAY) 조회전용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (확정구간(CONFIRM_DAY) 조회전용) |
| WK-SSP0021-0739 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SSP0021-0740 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SSP0021-0741 | X-ROW | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-027: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-027) |
| WK-SSP0021-0742 | X-ROW | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-031) |
| WK-SSP0021-0743 | X-ROW | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-001) |
| WK-SSP0021-0744 | X-ROW | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-002) |
| WK-SSP0021-0745 | X-ROW | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-003) |
| WK-SSP0021-0746 | X-ROW | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-004) |
| WK-SSP0021-0747 | X-ROW | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-006) |
| WK-SSP0021-0748 | X-ROW | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-020: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-020) |
| WK-SSP0021-0749 | X-ROW | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-003) |
| WK-SSP0021-0750 | X-ROW | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-004) |
| WK-SSP0021-0751 | X-ROW | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-005) |
| WK-SSP0021-0752 | X-ROW | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-010) |
| WK-SSP0021-0753 | X-ROW | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-024: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-024) |
| WK-SSP0021-0754 | X-ROW | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R1) |
| WK-SSP0021-0755 | X-ROW | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R5) |
| WK-SSP0021-0756 | X-ROW | R7a USER_CHECK 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R7a USER_CHECK 가드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R7a USER_CHECK 가드) |
| WK-SSP0021-0757 | X-ROW | SSP0021_ShipmentPlan.BtnItemID2_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.BtnItemID2_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0021-0758 | X-ROW | SSP0021_ShipmentPlan.BtnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.BtnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0021-0759 | X-ROW | SSP0021_ShipmentPlan.BtnRequestor_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.BtnRequestor_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0021_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0021-0760 | X-ROW | SSP0021_ShipmentPlan.BtnSearch_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.BtnSearch_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0021_ShipmentPlan.BtnSearch_Click) |
| WK-SSP0021-0761 | X-ROW | SSP0021_ShipmentPlan.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소 검사 없음 |  | 104 (ACT:SSP0021_ShipmentPlan.CalculateSum AC) |
| WK-SSP0021-0762 | X-ROW | SSP0021_ShipmentPlan.ChkConfirmChangeTim | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.ChkConfirmChangeTime: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0021_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0021-0763 | X-ROW | SSP0021_ShipmentPlan.ControlClear | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.ControlClear: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0021_ShipmentPlan.ControlClear AC) |
| WK-SSP0021-0764 | X-ROW | SSP0021_ShipmentPlan.Convert_Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Convert_Requestor: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0021_ShipmentPlan.Convert_Request) |
| WK-SSP0021-0765 | X-ROW | SSP0021_ShipmentPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.CreateSpread) |
| WK-SSP0021-0766 | X-ROW | SSP0021_ShipmentPlan.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0021_ShipmentPlan.DefineProperty:) |
| WK-SSP0021-0767 | X-ROW | SSP0021_ShipmentPlan.DrpPeriod2_ValueCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.DrpPeriod2_ValueChanged: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0021-0768 | X-ROW | SSP0021_ShipmentPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.EditButton: 진입점 집계 35검사 — NOT_RUN:33 · REVIEW:2 |  | 2 (ACT:SSP0021_ShipmentPlan.EditButton:2435) |
| WK-SSP0021-0769 | X-ROW | SSP0021_ShipmentPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0021_ShipmentPlan.FindButton) |
| WK-SSP0021-0770 | X-ROW | SSP0021_ShipmentPlan.FindData_Detail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_Detail: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Detail) |
| WK-SSP0021-0771 | X-ROW | SSP0021_ShipmentPlan.FindData_MES_stock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_MES_stock: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0772 | X-ROW | SSP0021_ShipmentPlan.FindData_MES_stock_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_MES_stock_Detail: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_MES_st) |
| WK-SSP0021-0773 | X-ROW | SSP0021_ShipmentPlan.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_Main: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 9 (ACT:SSP0021_ShipmentPlan.FindData_Main:4) |
| WK-SSP0021-0774 | X-ROW | SSP0021_ShipmentPlan.FindData_Shipment_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_Shipment_Result: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Shipme) |
| WK-SSP0021-0775 | X-ROW | SSP0021_ShipmentPlan.FindData_Stock_Deta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_Stock_Detail: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_Stock_) |
| WK-SSP0021-0776 | X-ROW | SSP0021_ShipmentPlan.FindData_hold_stock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_hold_stock: 진입점 집계 13검사 — NOT_RUN:9 · REVIEW:2 · PASS:2 |  | 10 (ACT:SSP0021_ShipmentPlan.FindData_hold_s) |
| WK-SSP0021-0777 | X-ROW | SSP0021_ShipmentPlan.FindData_oWMS_Detai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.FindData_oWMS_Detail: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 5 (ACT:SSP0021_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0021-0778 | X-ROW | SSP0021_ShipmentPlan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Form_Load: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.Form_Load:312:9) |
| WK-SSP0021-0779 | X-ROW | SSP0021_ShipmentPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.GetBucketType) |
| WK-SSP0021-0780 | X-ROW | SSP0021_ShipmentPlan.GetErpIFCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheck: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.GetErpIFCheck) |
| WK-SSP0021-0781 | X-ROW | SSP0021_ShipmentPlan.GetErpIFCheckNew | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0782 | X-ROW | SSP0021_ShipmentPlan.GetErpIFCheckNew_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetErpIFCheckNew_: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0021-0783 | X-ROW | SSP0021_ShipmentPlan.GetErpSoNoCnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetErpSoNoCnt: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.GetErpSoNoCnt) |
| WK-SSP0021-0784 | X-ROW | SSP0021_ShipmentPlan.GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.GetSSPUserCheck: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0021-0785 | X-ROW | SSP0021_ShipmentPlan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InitControls: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0021_ShipmentPlan.InitControls:44) |
| WK-SSP0021-0786 | X-ROW | SSP0021_ShipmentPlan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InitSpread: 진입점 집계 17검사 — NOT_RUN:17 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.InitSpread:609:) |
| WK-SSP0021-0787 | X-ROW | SSP0021_ShipmentPlan.InitSpreadDateColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InitSpreadDateColumn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0021_ShipmentPlan.InitSpreadDateC) |
| WK-SSP0021-0788 | X-ROW | SSP0021_ShipmentPlan.InitSpreadFooterSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.InitSpreadFoote) |
| WK-SSP0021-0789 | X-ROW | SSP0021_ShipmentPlan.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.InsertButton) |
| WK-SSP0021-0790 | X-ROW | SSP0021_ShipmentPlan.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.InsertRow: 진입점 집계 21검사 — NOT_RUN:21 (미실행 검사가 남아 판정필요) |  | 121 (ACT:SSP0021_ShipmentPlan.InsertRow ACT:S) |
| WK-SSP0021-0791 | X-ROW | SSP0021_ShipmentPlan.Measure_SearchIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Measure_SearchIdx: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:SSP0021_ShipmentPlan.Measure_SearchI) |
| WK-SSP0021-0792 | X-ROW | SSP0021_ShipmentPlan.NewNonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.NewNonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 132 (ACT:SSP0021_ShipmentPlan.NewNonSoNo ACT:) |
| WK-SSP0021-0793 | X-ROW | SSP0021_ShipmentPlan.NonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.NonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 126 (ACT:SSP0021_ShipmentPlan.NonSoNo ACT:SSP) |
| WK-SSP0021-0794 | X-ROW | SSP0021_ShipmentPlan.Plan_Current_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Plan_Current_Check: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0021_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0021-0795 | X-ROW | SSP0021_ShipmentPlan.Re_Design | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Re_Design: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 27 (ACT:SSP0021_ShipmentPlan.Re_Design ACT:S) |
| WK-SSP0021-0796 | X-ROW | SSP0021_ShipmentPlan.SaveData_Detail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SaveData_Detail: 진입점 집계 23검사 — NOT_RUN:14 · NOPATH:5 · PASS:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0021_ShipmentPlan.SaveData_Detail) |
| WK-SSP0021-0797 | X-ROW | SSP0021_ShipmentPlan.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0021_ShipmentPlan.SetChangeContro) |
| WK-SSP0021-0798 | X-ROW | SSP0021_ShipmentPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SetChangedControl: 진입점 집계 11검사 — NOT_RUN:8 · REVIEW:2 · PASS:1 |  | 3 (ACT:SSP0021_ShipmentPlan.SetChangedContr) |
| WK-SSP0021-0799 | X-ROW | SSP0021_ShipmentPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.SetLockSumColum) |
| WK-SSP0021-0800 | X-ROW | SSP0021_ShipmentPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:6 |  | 7 (ACT:SSP0021_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0021-0801 | X-ROW | SSP0021_ShipmentPlan.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.Set_SumValues A) |
| WK-SSP0021-0802 | X-ROW | SSP0021_ShipmentPlan.ShipmentResult_GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.ShipmentResult_GetDayRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0021_ShipmentPlan.ShipmentResult_) |
| WK-SSP0021-0803 | X-ROW | SSP0021_ShipmentPlan.Simulation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Simulation: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 194 (ACT:SSP0021_ShipmentPlan.Simulation ACT:) |
| WK-SSP0021-0804 | X-ROW | SSP0021_ShipmentPlan.SoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SoNo: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 141 (ACT:SSP0021_ShipmentPlan.SoNo ACT:SSP002) |
| WK-SSP0021-0805 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 55 (ACT:SSP0021_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0021-0806 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_CellClick: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 49 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0021-0807 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_CellDoubleClick: 진입점 집계 13검사 — NOT_RUN:7 · NOPATH:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0021-0808 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ClipboardPasted: 진입점 집계 27검사 — NOT_RUN:27 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0021_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0021-0809 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_ComboSelChange: 진입점 집계 21검사 — NOT_RUN:21 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0021_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0021-0810 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_EditChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_EditChange: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 36 (ACT:SSP0021_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0021-0811 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_SheetTabC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된 요소 검사  |  | 15 (ACT:SSP0021_ShipmentPlan.SpdDetail_Sheet) |
| WK-SSP0021-0812 | X-ROW | SSP0021_ShipmentPlan.SpdDetail_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdDetail_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0021-0813 | X-ROW | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0814 | X-ROW | SSP0021_ShipmentPlan.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_Change: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.SpdMain_Change ) |
| WK-SSP0021-0815 | X-ROW | SSP0021_ShipmentPlan.SpdMain_ClipboardPa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_ClipboardPasted: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0021_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0021-0816 | X-ROW | SSP0021_ShipmentPlan.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0021_ShipmentPlan.SpdMain_TopChan) |
| WK-SSP0021-0817 | X-ROW | SSP0021_ShipmentPlan.Validation_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.Validation_Check: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 106 (ACT:SSP0021_ShipmentPlan.Validation_Chec) |
| WK-SSP0021-0818 | X-ROW | SSP0021_ShipmentPlan.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0021_ShipmentPlan.btnItemId_Click) |
| WK-SSP0021-0819 | X-ROW | SSP0021_ShipmentPlan.cboBucketType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.cboBucketType_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.cboBucketType_S) |
| WK-SSP0021-0820 | X-ROW | SSP0021_ShipmentPlan.cboPlanDate_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.cboPlanDate_SelectedIndexChan: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 4 (ACT:SSP0021_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0021-0821 | X-ROW | SSP0021_ShipmentPlan.checkValidN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.checkValidN: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SSP0021_ShipmentPlan.checkValidN ACT) |
| WK-SSP0021-0822 | X-ROW | SSP0021_ShipmentPlan.chkERPIFBlockYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.chkERPIFBlockYn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0021_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0021-0823 | X-ROW | SSP0021_ShipmentPlan.chkSum_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0021-0824 | X-ROW | SSP0021_ShipmentPlan.clbCompanyID_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.clbCompanyID_SelectedIndexCha: 진입점 집계 13검사 — NOT_RUN:10 · NOPATH:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0021_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0021-0825 | X-ROW | SSP0021_ShipmentPlan.shtDetail_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0021_ShipmentPlan.shtDetail_Change: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 71 (ACT:SSP0021_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0021-0826 | X-ROW | 같은 셀 더블클릭 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 같은 셀 더블클릭 가드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (같은 셀 더블클릭 가드) |
| WK-SSP0021-0827 | G5 | D00-2-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-022: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-022) |
| WK-SSP0021-0828 | G5 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-023: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SSP0021-0829 | G5 | MODAL:RequestorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:RequestorModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0830 | G5 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Measure: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0831 | G5 | OrderDetail 팝업(SSP0300) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — OrderDetail 팝업(SSP0300): 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0832 | G5 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Requestor: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0833 | G5 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0834 | G5 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — drill-down: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
| WK-SSP0021-0835 | H6 | D00-2-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-022: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-022) |
| WK-SSP0021-0836 | H6 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-023: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SSP0021-0837 | H6 | MODAL:RequestorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:RequestorModal: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0838 | H6 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Measure: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0839 | H6 | OrderDetail 팝업(SSP0300) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — OrderDetail 팝업(SSP0300): 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0840 | H6 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Requestor: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0841 | H6 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0842 | H6 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — drill-down: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
| WK-SSP0021-0843 | M4 | D00-2-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-022: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-022) |
| WK-SSP0021-0844 | M4 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-023: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SSP0021-0845 | M4 | MODAL:RequestorModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:RequestorModal: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:RequestorModal) |
| WK-SSP0021-0846 | M4 | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Measure: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Measure) |
| WK-SSP0021-0847 | M4 | OrderDetail 팝업(SSP0300) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — OrderDetail 팝업(SSP0300): 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (OrderDetail 팝업(SSP0300)) |
| WK-SSP0021-0848 | M4 | Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Requestor: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Requestor) |
| WK-SSP0021-0849 | M4 | SSP0021_ShipmentPlan.SpdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0021_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0021_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0021-0850 | M4 | drill-down | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drill-down: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (drill-down) |
