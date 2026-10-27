# 작업 원장 — SCP0005 · 2026-10-26 12:52

> 검사 인스턴스 466건 중 PASS·NA 26건 외 **440건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 32 | 구현 위치 실존 |
| W3 | 동작 수정 | 6 | 재판정 PASS |
| W5 | 검사기 연결 | 31 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 230 | 실행 → PASS |
| W7 | 기대값 확정 | 136 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 4 | 선행 W1 → PASS |

- 담당: E2E 230 · 사람 판정 / AS-IS 원문 확인 → 재판정 134 · 대조표 34 · 하네스 31 · FE 5 · 선행 W1 완료 후 E2E 4 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 10건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 37 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 30 | 6 |  |  | 연쇄 자동 채움 |
| X-LOC | GEN |  | 32 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H2 | DESIGN |  |  |  |  |  | 19 | 11 |  |  | 배경·글자색 규칙 |
| C2 | CASCADE |  |  |  |  |  | 24 | 3 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 24 | 3 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| A5 | DESIGN |  |  |  |  |  | 15 | 11 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 15 | 11 |  |  | 라벨 명칭 |
| E4 | EDIT |  |  |  |  |  | 19 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D5 | EDIT |  |  |  |  |  | 13 | 4 |  |  | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  | 14 | 3 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 13 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 9 | 4 | 3 |  |  | 팝업 표준·열림 |
| A1 | GEN |  |  |  |  |  |  | 14 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 6 | 6 | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 3 | 6 | 2 | 1 |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 행 값 기반 조건부 잠금 |
| G6 | GEN |  |  |  |  |  | 6 | 2 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 5 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E3 | EDIT |  |  | 5 |  |  |  |  |  |  | 필수 입력 검증 |
| A6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 3 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0001 | X-NOTIMPL | dead 콤보(Division/Site/BodType/dtFromCoun | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYesOrNo) 미구현(신설 금지) design 02 §2.4 |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W2 구현 위치 확인 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0002 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0003 | X-LOC | DAYS 최소 1 (MSG00223) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DAYS 최소 1 (MSG00223)) |
| WK-SCP0005-0004 | X-LOC | DB메타 구동(gridColumns=[]) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0005 | X-LOC | DeleteButton(action!=FlagI return) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton(action!=FlagI return)) |
| WK-SCP0005-0006 | X-LOC | EditButton (SwitchLock 편집모드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0007 | X-LOC | FROM/TO City Name 비공백 (MSG00167) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FROM/TO City Name 비공백 (MSG00167)) |
| WK-SCP0005-0008 | X-LOC | FindButton(Search) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton(Search)) |
| WK-SCP0005-0009 | X-LOC | FindDataMain 파라미터 6종 'ALL'→'' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0010 | X-LOC | InsertButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton) |
| WK-SCP0005-0011 | X-LOC | PRIORITY>=1 (MSG00107) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PRIORITY>=1 (MSG00107)) |
| WK-SCP0005-0012 | X-LOC | ProgressForm | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ProgressForm) |
| WK-SCP0005-0013 | X-LOC | R1 숫자셀 범위(cellType) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0014 | X-LOC | R10 TRK→港/Forwarder 7 '-' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0015 | X-LOC | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0016 | X-LOC | R13 LT 5종→LT_SUM, >999 차단·리셋 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R13 LT 5종→LT_SUM, >999 차단·리셋) |
| WK-SCP0005-0017 | X-LOC | R14/R15 저장응답 색칠(99010/99020) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R14/R15 저장응답 색칠(99010/99020)) |
| WK-SCP0005-0018 | X-LOC | R16/R17 클라 검증 색칠 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0019 | X-LOC | R18 Insert/Delete | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0020 | X-LOC | R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0021 | X-LOC | R6 신규행 VALID_YN='Y' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R6 신규행 VALID_YN='Y') |
| WK-SCP0005-0022 | X-LOC | R7 조회 databind | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0023 | X-LOC | R8 ROUTE_ID | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R8 ROUTE_ID) |
| WK-SCP0005-0024 | X-LOC | R9 TRK/AIR→DAYS 7 'Y' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0025 | X-LOC | SaveButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton) |
| WK-SCP0005-0026 | X-LOC | btnEaxel_Upload → ExcelUploadForm2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0027 | X-LOC | btnExcel_Form (Visibility=Never) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnExcel_Form (Visibility=Never)) |
| WK-SCP0005-0028 | X-LOC | cascade(clbFromCountry→City) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0029 | X-LOC | cboValidYN (UsrCombo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0005-0030 | X-LOC | clbTransMode (UsrCheckedList **다중 체크** — | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0031 | X-LOC | txtFromCountry/txtFromCity + btnFromSrch | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0032 | X-LOC | txtToCountry/txtToCity + btnToSrch | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0033 | X-LOC | 메타 필수(INPUT_TP_CD=M/IM) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |

## W3 동작 수정 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0034 | H10 | SCP0005 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0005 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/DistributionRouteGrid.tsx |  | 7 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0035 | E3 | DAYS 최소 1 (MSG00223) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — DAYS 최소 1 (MSG00223): 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (DAYS 최소 1 (MSG00223)) |
| WK-SCP0005-0036 | E3 | PRIORITY | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — PRIORITY: 필수 표시 AS-IS *('Priority*') ↔ TO-BE -('Priority' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차 |  | 1 (PRIORITY>=1 (MSG00107)) |
| WK-SCP0005-0037 | E3 | R16/R17 클라 검증 색칠 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — R16/R17 클라 검증 색칠: 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0038 | E3 | SaveButton | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — SaveButton: 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (SaveButton) |
| WK-SCP0005-0039 | E3 | 메타 필수(INPUT_TP_CD=M/IM) | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — 메타 필수(INPUT_TP_CD=M/IM): 행 집계 — E3 2요소: FAIL:1 · PASS:1 |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |

## W5 검사기 연결 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0040 | F2 | SCP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0005 화면 | 판단불가(대상 단위 SCREEN) | 195 (R14/R15 저장응답 색칠(99010/99020) SaveButton ) |
| WK-SCP0005-0041 | F6 | SCP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0005 화면 | 판단불가(대상 단위 SCREEN) | 193 (ACT:SCP0005_DistributionRoute.SaveButton) |
| WK-SCP0005-0042 | DB-SYN | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0043 | DB-SYN | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0044 | DB-SYN | SCP0005_SAVE_DISTRIBUTION_ROUTE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_SAVE_DISTRIBUTION_ROUTE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0005_DistributionRoute.SaveData:7) |
| WK-SCP0005-0045 | G4 | btnEaxel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnEaxel | 없음 | 2 (ACT:SCP0005_DistributionRoute.InitEvent ) |
| WK-SCP0005-0046 | G4 | btnFromSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnFromSrch | 없음 | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0047 | G4 | btnToSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnToSrch | 없음 | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0048 | G03-WIRE | SCP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0005 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0005_DistributionRoute..ctor ACT:) |
| WK-SCP0005-0049 | G5 | FROM_CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_CITY | 있음(SHEET_COLUMNS) | 36 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0050 | G5 | FROM_CITY_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_CITY_NAME | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0051 | G5 | FROM_COUNTRY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_COUNTRY | 있음(SHEET_COLUMNS) | 35 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0052 | G5 | ROUTE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ROUTE_ID | 있음(SHEET_COLUMNS) | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0053 | G5 | SCP0005_DistributionRoutePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0005_DistributionRoutePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0054 | G5 | TO_CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TO_CITY | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0055 | G5 | TO_CITY_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TO_CITY_NAME | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0056 | G5 | btnFromSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnFromSrch | 없음 | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0057 | G5 | btnToSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnToSrch | 없음 | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0058 | G5 | txtFromCity / From City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtFromCity / From City | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0059 | G5 | txtFromCountry / From Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtFromCountry / From Country | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0060 | G5 | txtToCity / To City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtToCity / To City | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0061 | G5 | txtToCountry / To Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtToCountry / To Country | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0062 | H6 | FROM_CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_CITY | 있음(SHEET_COLUMNS) | 36 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0063 | H6 | FROM_CITY_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_CITY_NAME | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0064 | H6 | FROM_COUNTRY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_COUNTRY | 있음(SHEET_COLUMNS) | 35 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0065 | H6 | ROUTE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ROUTE_ID | 있음(SHEET_COLUMNS) | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0066 | H6 | SCP0005_DistributionRoutePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0005_DistributionRoutePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0067 | H6 | TO_CITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0068 | H6 | TO_CITY_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY_NAME | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0069 | H6 | btnFromSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnFromSrch | 없음 | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0070 | H6 | btnToSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnToSrch | 없음 | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |

## W6 검증 실행 (230)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0071 | J2 | SCP0005 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0005 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 50 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0072 | C1 | cboValidYN / Valid / Valid YN | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValidYN / Valid / Valid YN · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.InitContro) |
| WK-SCP0005-0073 | C1 | clbTransMode / Trans Mode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTransMode / Trans Mode · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0074 | C2 | A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — A_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0075 | C2 | A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — A_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0076 | C2 | A_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — A_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0077 | C2 | DAYS_FRI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_FRI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0078 | C2 | DAYS_MON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_MON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0079 | C2 | DAYS_SAT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_SAT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0080 | C2 | DAYS_SUN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_SUN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0081 | C2 | DAYS_THU | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_THU · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0082 | C2 | DAYS_TUE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_TUE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0083 | C2 | DAYS_WED | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAYS_WED · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0084 | C2 | D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0085 | C2 | D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0086 | C2 | D_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0087 | C2 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0088 | C2 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0089 | C2 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0090 | C2 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0091 | C2 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0092 | C2 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0093 | C2 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0094 | C2 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0095 | C2 | SHIPPING_COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPPING_COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0096 | C2 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0097 | C2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0098 | C3 | A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — A_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0099 | C3 | A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — A_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0100 | C3 | A_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — A_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0101 | C3 | DAYS_FRI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_FRI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0102 | C3 | DAYS_MON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_MON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0103 | C3 | DAYS_SAT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_SAT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0104 | C3 | DAYS_SUN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_SUN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0105 | C3 | DAYS_THU | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_THU · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0106 | C3 | DAYS_TUE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_TUE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0107 | C3 | DAYS_WED | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAYS_WED · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0108 | C3 | D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0109 | C3 | D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0110 | C3 | D_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0111 | C3 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0112 | C3 | FROM_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0113 | C3 | FROM_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0114 | C3 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0115 | C3 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0116 | C3 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0117 | C3 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0118 | C3 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0119 | C3 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0120 | C3 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0121 | C3 | ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0122 | C3 | SHIPPING_COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPPING_COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0123 | C3 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0124 | C3 | TO_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0125 | C3 | TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0126 | C3 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0127 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.InsertRow:) |
| WK-SCP0005-0128 | C4 | clbTransMode / Trans Mode | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbTransMode / Trans Mode · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0129 | C6 | A_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — A_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0130 | C6 | A_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — A_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0131 | C6 | A_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — A_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0132 | C6 | DAYS_FRI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_FRI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0133 | C6 | DAYS_MON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_MON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0134 | C6 | DAYS_SAT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_SAT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0135 | C6 | DAYS_SUN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_SUN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0136 | C6 | DAYS_THU | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_THU · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0137 | C6 | DAYS_TUE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_TUE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0138 | C6 | DAYS_WED | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAYS_WED · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0139 | C6 | D_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0140 | C6 | D_PORT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D_PORT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0141 | C6 | D_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0142 | C6 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0143 | C6 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0144 | C6 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0145 | C6 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0146 | C6 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0147 | C6 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0148 | C6 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0149 | C6 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0150 | C6 | SHIPPING_COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SHIPPING_COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0151 | C6 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0152 | C6 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0153 | G3 | SCP0005 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0005 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0154 | K4 | SCP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0005 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 33 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0155 | F1 | SCP0005 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0005 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 202 (R14/R15 저장응답 색칠(99010/99020) R18 Insert/) |
| WK-SCP0005-0156 | F5 | SCP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0005 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 7 (R18 Insert/Delete DeleteButton(action!=F) |
| WK-SCP0005-0157 | F4 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 10 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0158 | F4 | PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_R | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 242 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0159 | F4 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0160 | F4 | SCP0005_GET_DISTRIBUTION_ROUTEID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0005_GET_DISTRIBUTION_ROUTEID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0161 | F4 | SCP0005_SAVE_DISTRIBUTION_ROUTE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0005_SAVE_DISTRIBUTION_ROUTE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tr |  | 193 (ACT:SCP0005_DistributionRoute.SaveButton) |
| WK-SCP0005-0162 | A5 | FROM_CITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0163 | A5 | FROM_CITY_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_CITY_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0164 | A5 | FROM_COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FROM_COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0165 | A5 | LT_ARRIVAL_INLAND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0166 | A5 | LT_DEPARTURE_INLAND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0167 | A5 | LT_LAY_OFF_CLEARANCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0168 | A5 | LT_SUM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0169 | A5 | LT_VOYAGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0170 | A5 | LT_WAIT_SHIPPING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0171 | A5 | PRIORITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0172 | A5 | ROUTE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ROUTE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0173 | A5 | SHIP_DOC_PREPARATION_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIP_DOC_PREPARATION_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effectiv |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0174 | A5 | TO_CITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0175 | A5 | TO_COUNTRY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_COUNTRY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0176 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R6 신규행 VALID_YN='Y') |
| WK-SCP0005-0177 | G4 | cboValidYN / Valid / Valid YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValidYN / Valid / Valid YN · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboValidYN (UsrCombo) ACT:SCP0005_Distri) |
| WK-SCP0005-0178 | G4 | clbTransMode / Trans Mode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTransMode / Trans Mode · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0179 | G4 | txtFromCity / From City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtFromCity / From City · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0180 | G4 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtFromCountry / From Country · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0181 | G4 | txtToCity / To City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtToCity / To City · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0182 | G4 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtToCountry / To Country · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0183 | H2 | D_PORT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — D_PORT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0184 | H2 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0185 | H2 | FROM_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0186 | H2 | FROM_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FROM_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0187 | H2 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0188 | H2 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0189 | H2 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0190 | H2 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0191 | H2 | LT_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0192 | H2 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0193 | H2 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0194 | H2 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0195 | H2 | ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0196 | H2 | SHIP_DOC_PREPARATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIP_DOC_PREPARATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0197 | H2 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0198 | H2 | TO_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0199 | H2 | TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0200 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0201 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R6 신규행 VALID_YN='Y') |
| WK-SCP0005-0202 | H5 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_CITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0203 | H5 | FROM_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_CITY_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0204 | H5 | FROM_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FROM_COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0205 | H5 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0206 | H5 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0207 | H5 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0208 | H5 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_SUM · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0209 | H5 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_VOYAGE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0210 | H5 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0211 | H5 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRIORITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0212 | H5 | ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ROUTE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0213 | H5 | SHIP_DOC_PREPARATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIP_DOC_PREPARATION_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trac |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0214 | H5 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_CITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0215 | H5 | TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_COUNTRY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0216 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R6 신규행 VALID_YN='Y') |
| WK-SCP0005-0217 | I1 | SCP0005 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0005 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 15 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0218 | SC1 | SCP0005 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0005 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0219 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0220 | D1 | FROM_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FROM_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0221 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0222 | D1 | LT_SUM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LT_SUM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0223 | D1 | ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0224 | D1 | TO_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0225 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0226 | D3 | FROM_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FROM_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0227 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0228 | D3 | LT_SUM | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LT_SUM · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0229 | D3 | ROUTE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ROUTE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0230 | D3 | TO_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0231 | D5 | FROM_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0232 | D5 | FROM_CITY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_CITY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0233 | D5 | FROM_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0234 | D5 | LT_ARRIVAL_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0235 | D5 | LT_DEPARTURE_INLAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DEPARTURE_INLAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0236 | D5 | LT_LAY_OFF_CLEARANCE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_LAY_OFF_CLEARANCE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0237 | D5 | LT_VOYAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_VOYAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0238 | D5 | LT_WAIT_SHIPPING | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_WAIT_SHIPPING · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0239 | D5 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0240 | D5 | ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0241 | D5 | SHIP_DOC_PREPARATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIP_DOC_PREPARATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0242 | D5 | TO_CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0243 | D5 | TO_COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0244 | D6 | SCP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0005 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (R18 Insert/Delete InsertButton COMMON:UC) |
| WK-SCP0005-0245 | E4 | FROM_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_CITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0246 | E4 | FROM_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0247 | E4 | FROM_COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_COUNTRY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0248 | E4 | LT_ARRIVAL_INLAND | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LT_ARRIVAL_INLAND · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0249 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0250 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0251 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0252 | E4 | MSG00107 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00107 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (PRIORITY>=1 (MSG00107) ACT:SCP0005_Distr) |
| WK-SCP0005-0253 | E4 | MSG00167 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00167 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (FROM/TO City Name 비공백 (MSG00167) ACT:SCP) |
| WK-SCP0005-0254 | E4 | MSG00209 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00209 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0255 | E4 | MSG00223 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00223 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (DAYS 최소 1 (MSG00223) ACT:SCP0005_Distrib) |
| WK-SCP0005-0256 | E4 | MSG00265 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00265 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0257 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (FROM/TO City Name 비공백 (MSG00167) DAYS 최소) |
| WK-SCP0005-0258 | E4 | MSG01134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (PRIORITY>=1 (MSG00107)) |
| WK-SCP0005-0259 | E4 | PRIORITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (PRIORITY>=1 (MSG00107)) |
| WK-SCP0005-0260 | E4 | ROUTE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ROUTE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0261 | E4 | TO_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_CITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0262 | E4 | TO_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (FROM/TO City Name 비공백 (MSG00167) ACT:SCP) |
| WK-SCP0005-0263 | E4 | TO_COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_COUNTRY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0264 | A10 | SCP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0005 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 55 (ACT:SCP0005_DistributionRoute.DefineProp) |
| WK-SCP0005-0265 | A6 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 7 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0266 | A6 | PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_R | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 50 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0267 | A6 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0268 | A6 | SCP0005_GET_DISTRIBUTION_ROUTEID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0005_GET_DISTRIBUTION_ROUTEID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0269 | G1 | cboValidYN / Valid / Valid YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValidYN / Valid / Valid YN · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboValidYN (UsrCombo) ACT:SCP0005_Distri) |
| WK-SCP0005-0270 | G1 | clbTransMode / Trans Mode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTransMode / Trans Mode · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0271 | G1 | txtFromCity / From City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtFromCity / From City · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0272 | G1 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtFromCountry / From Country · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0273 | G1 | txtToCity / To City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtToCity / To City · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0274 | G1 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtToCountry / To Country · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0275 | G6 | cboValidYN / Valid / Valid YN | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValidYN / Valid / Valid YN · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboValidYN (UsrCombo) ACT:SCP0005_Distri) |
| WK-SCP0005-0276 | G6 | clbTransMode / Trans Mode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTransMode / Trans Mode · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0277 | G6 | txtFromCity / From City | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtFromCity / From City · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0278 | G6 | txtFromCountry / From Country | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtFromCountry / From Country · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0279 | G6 | txtToCity / To City | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtToCity / To City · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0280 | G6 | txtToCountry / To Country | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtToCountry / To Country · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0281 | X-REOPEN | SCP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0005 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:SCP0005_DistributionRoute.Dispose AC) |
| WK-SCP0005-0282 | H6 | txtFromCity / From City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtFromCity / From City · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0283 | H6 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtFromCountry / From Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0284 | H6 | txtToCity / To City | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtToCity / To City · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0285 | H6 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtToCountry / To Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0286 | M3 | SCP0005_DistributionRoutePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0005_DistributionRoutePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 8 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0287 | M4 | FROM_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_CITY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 36 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0288 | M4 | FROM_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0289 | M4 | FROM_COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_COUNTRY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 35 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0290 | M4 | ROUTE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ROUTE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0291 | M4 | SCP0005_DistributionRoutePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0005_DistributionRoutePopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0292 | M4 | TO_CITY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_CITY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0293 | M4 | TO_CITY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_CITY_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0294 | M4 | TO_COUNTRY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_COUNTRY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0295 | M4 | btnFromSrch | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnFromSrch · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0296 | M4 | btnToSrch | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnToSrch · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0297 | M4 | txtFromCity / From City | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtFromCity / From City · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0298 | M4 | txtFromCountry / From Country | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtFromCountry / From Country · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0299 | M4 | txtToCity / To City | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtToCity / To City · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0300 | M4 | txtToCountry / To Country | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtToCountry / To Country · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |

## W7 기대값 확정 (136)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0301 | C2 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0302 | C2 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — C2 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0303 | C2 | SCP0005_DistributionRoute.spdMainDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0005_DistributionRoute.spdMainDataModel_Changed: 진입점 집계 — C2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0304 | C3 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — C3 30요소: NOT_RUN:30 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0305 | C3 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — C3 30요소: NOT_RUN:30 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0306 | C3 | SCP0005_DistributionRoute.SetCityCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0005_DistributionRoute.SetCityCode: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0307 | C3 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0308 | C3 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0309 | C3 | SCP0005_DistributionRoute.spdMainDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0005_DistributionRoute.spdMainDataModel_Changed: 진입점 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0310 | C6 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0311 | C6 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — C6 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0312 | C6 | SCP0005_DistributionRoute.spdMainDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0005_DistributionRoute.spdMainDataModel_Changed: 진입점 집계 — C6 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0313 | DB-SYN | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — DB-SYN 5요소: NOPATH:3 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0314 | F4 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0315 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0316 | A5 | DB메타 구동(gridColumns=[]) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DB메타 구동(gridColumns=[]): 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0317 | A5 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0318 | A5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0319 | A5 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0320 | A5 | R18 Insert/Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R18 Insert/Delete: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0321 | A5 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R7 조회 databind: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R7 조회 databind) |
| WK-SCP0005-0322 | A5 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0323 | A5 | SCP0005_DistributionRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0324 | A5 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0325 | A5 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0326 | G4 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — G4 9요소: NOT_RUN:6 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0327 | G4 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — G4 9요소: NOT_RUN:6 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0328 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0329 | H2 | DB메타 구동(gridColumns=[]) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DB메타 구동(gridColumns=[]): 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0330 | H2 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0331 | H2 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0332 | H2 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0333 | H2 | R18 Insert/Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R18 Insert/Delete: 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0334 | H2 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R7 조회 databind: 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R7 조회 databind) |
| WK-SCP0005-0335 | H2 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0336 | H2 | SCP0005_DistributionRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 — H2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0337 | H2 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0338 | H2 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0339 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0340 | H5 | DB메타 구동(gridColumns=[]) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DB메타 구동(gridColumns=[]): 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0341 | H5 | R10 TRK→港/Forwarder 7 '-' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0342 | H5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0343 | H5 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0344 | H5 | R18 Insert/Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R18 Insert/Delete: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0345 | H5 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R7 조회 databind: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R7 조회 databind) |
| WK-SCP0005-0346 | H5 | R9 TRK/AIR→DAYS 7 'Y' | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0347 | H5 | SCP0005_DistributionRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0348 | H5 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0349 | H5 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0350 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회  Measure 0(정적 39컬럼, SHEET_MEASURE 실측 0). Colum |  | 1 (COMMON:UC-03) |
| WK-SCP0005-0351 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 다중입력 전건 조회  TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(design 03 §4.1) 지원. From/To |  | 1 (COMMON:UC-06) |
| WK-SCP0005-0352 | D1 | EditButton (SwitchLock 편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton (SwitchLock 편집모드): 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0353 | D1 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0354 | D1 | SCP0005_DistributionRoute.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0005_DistributionRoute.EditButton: 진입점 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0355 | D3 | EditButton (SwitchLock 편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton (SwitchLock 편집모드): 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0356 | D3 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0357 | D3 | SCP0005_DistributionRoute.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0005_DistributionRoute.EditButton: 진입점 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0358 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0005-0359 | D5 | SCP0005_DistributionRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 — D5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0360 | D5 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0361 | D5 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0362 | E4 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0363 | E4 | SCP0005_DistributionRoute.SetCityCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0005_DistributionRoute.SetCityCode: 진입점 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0364 | E4 | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0365 | E4 | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0366 | E4 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0005-0367 | E4 | 메타 필수(INPUT_TP_CD=M/IM) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 메타 필수(INPUT_TP_CD=M/IM): 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |
| WK-SCP0005-0368 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0369 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (FindButton(Search)) |
| WK-SCP0005-0370 | A1 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — A1 4요소: REVIEW:4 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0371 | A1 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: 골든 비교 케이스 없음(PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY — 팝업·보조 SP 는 golden_cases. |  | 7 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0372 | A1 | PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE: 골든 비교 케이스 없음(PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE — 팝업·보조 SP 는 g |  | 50 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0373 | A1 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R7 조회 databind: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0374 | A1 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: 골든 비교 케이스 없음(SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID — 팝업·보조 SP 는 golden_ca |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0375 | A1 | SCP0005_GET_DISTRIBUTION_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_ROUTEID: 골든 비교 케이스 없음(SCP0005_GET_DISTRIBUTION_ROUTEID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0376 | A1 | btnEaxel_Upload → ExcelUploadForm2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnEaxel_Upload → ExcelUploadForm2: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0377 | A1 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0378 | A1 | cboValidYN (UsrCombo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValidYN (UsrCombo): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0005-0379 | A1 | clbTransMode (UsrCheckedList **다중 체크** — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode (UsrCheckedList **다중 체크** — Designer : 행 집계 — A1 4요소: REVIEW:4 |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0380 | A1 | txtFromCountry/txtFromCity + btnFromSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtFromCountry/txtFromCity + btnFromSrch: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0381 | A1 | txtToCountry/txtToCity + btnToSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtToCountry/txtToCity + btnToSrch: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0382 | A6 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0383 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0384 | G1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton(Search): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(Search)) |
| WK-SCP0005-0385 | G1 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0386 | G1 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R7 조회 databind: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R7 조회 databind) |
| WK-SCP0005-0387 | G1 | btnEaxel_Upload → ExcelUploadForm2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnEaxel_Upload → ExcelUploadForm2: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0388 | G1 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0389 | G6 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0390 | G6 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0391 | X-ROW | SCP0005_DistributionRoute.CSafeSetText | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.CSafeSetText: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0005_DistributionRoute.CSafeSetTe) |
| WK-SCP0005-0392 | X-ROW | SCP0005_DistributionRoute.CheckValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.CheckValid: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 39 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0393 | X-ROW | SCP0005_DistributionRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0394 | X-ROW | SCP0005_DistributionRoute.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.DefineProp) |
| WK-SCP0005-0395 | X-ROW | SCP0005_DistributionRoute.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.FindButton: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0396 | X-ROW | SCP0005_DistributionRoute.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.FindDataMain: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 6 (ACT:SCP0005_DistributionRoute.FindDataMa) |
| WK-SCP0005-0397 | X-ROW | SCP0005_DistributionRoute.FindDataReceiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.FindDataReceive: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · NOPATH:1 |  | 7 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0398 | X-ROW | SCP0005_DistributionRoute.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.Form_Load) |
| WK-SCP0005-0399 | X-ROW | SCP0005_DistributionRoute.GetBodType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetBodType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.GetBodType) |
| WK-SCP0005-0400 | X-ROW | SCP0005_DistributionRoute.GetData_Countr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetData_Country: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoute.GetData_Co) |
| WK-SCP0005-0401 | X-ROW | SCP0005_DistributionRoute.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetDivision: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.GetDivisio) |
| WK-SCP0005-0402 | X-ROW | SCP0005_DistributionRoute.GetFromSitebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetFromSitebyDivision: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.GetFromSit) |
| WK-SCP0005-0403 | X-ROW | SCP0005_DistributionRoute.GetToSitebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetToSitebyDivision: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.GetToSiteb) |
| WK-SCP0005-0404 | X-ROW | SCP0005_DistributionRoute.GetTransMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.GetTransMode: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.GetTransMo) |
| WK-SCP0005-0405 | X-ROW | SCP0005_DistributionRoute.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoute.InitContro) |
| WK-SCP0005-0406 | X-ROW | SCP0005_DistributionRoute.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.InitEvent: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.InitEvent) |
| WK-SCP0005-0407 | X-ROW | SCP0005_DistributionRoute.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.InitSpread: 진입점 집계 29검사 — NOT_RUN:29 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0408 | X-ROW | SCP0005_DistributionRoute.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.InsertButt) |
| WK-SCP0005-0409 | X-ROW | SCP0005_DistributionRoute.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.InsertRow: 진입점 집계 13검사 — NOT_RUN:13 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0005_DistributionRoute.InsertRow ) |
| WK-SCP0005-0410 | X-ROW | SCP0005_DistributionRoute.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.SaveData: 진입점 집계 22검사 — NOT_RUN:18 · NOPATH:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.SaveData:6) |
| WK-SCP0005-0411 | X-ROW | SCP0005_DistributionRoute.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 36검사 — NOT_RUN:30 · REVIEW:6 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0412 | X-ROW | SCP0005_DistributionRoute.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.SetSpreadColumn: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0413 | X-ROW | SCP0005_DistributionRoute.btnEaxel_Uploa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.btnEaxel_Upload_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0414 | X-ROW | SCP0005_DistributionRoute.btnFromSrch_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.btnFromSrch_Click: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0415 | X-ROW | SCP0005_DistributionRoute.btnToSrch_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.btnToSrch_Click: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0416 | X-ROW | SCP0005_DistributionRoute.checkCtiyCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.checkCtiyCode: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0005_DistributionRoute.checkCtiyC) |
| WK-SCP0005-0417 | X-ROW | SCP0005_DistributionRoute.spdMainDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.spdMainDataModel_Changed: 진입점 집계 76검사 — NOT_RUN:72 · REVIEW:3 · NOPATH:1 |  | 21 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0418 | X-ROW | SCP0005_DistributionRoute.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 진입점 집계 35검사 — NOT_RUN:17 · NOPATH:15 · REVIEW:3 |  | 11 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0419 | X-ROW | SCP0005_DistributionRoutePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0420 | X-ROW | SCP0005_DistributionRoutePopup.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0005_DistributionRoutePopup.Creat) |
| WK-SCP0005-0421 | X-ROW | SCP0005_DistributionRoutePopup.DefinePro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0005_DistributionRoutePopup.Defin) |
| WK-SCP0005-0422 | X-ROW | SCP0005_DistributionRoutePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoutePopup.Dispo) |
| WK-SCP0005-0423 | X-ROW | SCP0005_DistributionRoutePopup.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0424 | X-ROW | SCP0005_DistributionRoutePopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.FindData: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · NOPATH:1 |  | 12 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0425 | X-ROW | SCP0005_DistributionRoutePopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0005_DistributionRoutePopup.Form_) |
| WK-SCP0005-0426 | X-ROW | SCP0005_DistributionRoutePopup.InitSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoutePopup.InitSpread: 진입점 집계 30검사 — NOT_RUN:30 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0005_DistributionRoutePopup.InitS) |
| WK-SCP0005-0427 | X-ROW | btnExcel_Form (Visibility=Never) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — btnExcel_Form (Visibility=Never): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (btnExcel_Form (Visibility=Never)) |
| WK-SCP0005-0428 | G5 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm: 행 집계 — G5 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0005-0429 | G5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — G5 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0430 | G5 | SCP0005_DistributionRoute.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 진입점 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0431 | H6 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm: 행 집계 — H6 13요소: NOPATH:9 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0005-0432 | H6 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — H6 13요소: NOPATH:9 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0433 | H6 | SCP0005_DistributionRoute.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 진입점 집계 — H6 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0434 | M4 | ProgressForm | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm: 행 집계 — M4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm) |
| WK-SCP0005-0435 | M4 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — M4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0436 | M4 | SCP0005_DistributionRoute.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 진입점 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W8 구현 후 검증 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0437 | G4 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0438 | A1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0439 | G1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0440 | G6 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
