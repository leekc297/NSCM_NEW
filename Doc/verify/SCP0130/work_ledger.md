# 작업 원장 — SCP0130 · 2026-10-26 12:55

> 검사 인스턴스 508건 중 PASS·NA 60건 외 **448건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 3 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 8 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 113 | 실행 → PASS |
| W7 | 기대값 확정 | 292 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 7 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 288 · E2E 113 · 하네스 25 · 대조표 12 · 선행 W1 완료 후 E2E 6 · FE 3 · 선행 W1 완료 후 검증 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 8 |  |  |  |  | 49 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 46 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 19 | 13 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H2 | DESIGN |  |  |  |  |  | 8 | 22 | 1 |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 8 | 21 | 1 |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 8 | 21 | 1 |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 6 | 15 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 19 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C3 | CASCADE |  |  |  |  |  | 4 | 11 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 5 | 6 | 1 |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 5 | 6 | 1 |  | 행 값 기반 조건부 잠금 |
| C2 | CASCADE |  |  |  |  |  | 4 | 7 |  |  | 그리드 셀 cascade 후보 |
| D4 | EDIT |  |  |  |  |  | 3 | 8 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| F4 | DB |  |  |  |  |  | 6 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B4 | COMBO |  |  |  |  | 3 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 1 | 3 | 4 |  |  | 조회조건 표시·라벨·활성 |
| E2 | EDIT |  |  |  |  | 7 |  | 1 |  |  | 날짜 형식·유효성 |
| C1 | CASCADE |  |  |  |  |  | 5 | 3 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| M4 | POPUP |  |  |  |  |  | 4 | 4 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 3 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 4 |  |  | 팝업 표준·열림 |
| G6 | GEN |  |  |  |  |  | 3 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| DB-SYN | DB |  |  |  |  | 3 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| D5 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 셀 에디터 유형 |
| B3 | COMBO |  |  |  | 3 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 숫자 소수자리·정수·부호·범위 |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| X-NOTIMPL | GEN | 3 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
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
| H3 | DESIGN |  |  |  |  |  |  |  | 1 |  | 셀 병합 = AS-IS |

## W1 기능 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0001 | X-NOTIMPL | SetActiveCell 포커스 복원(SCP0130-11) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — SetActiveCell 포커스 복원(SCP0130-11) 미구현(선택사항) design 03 §3 자체판정 데이터계약 영향없음 — 필요시만 구현 대상, 이번 회차 미착수 |  | 1 (SetActiveCell 포커스 복원(SCP0130-11)) |
| WK-SCP0130-0002 | X-NOTIMPL | SmartColMerge 병합 대상 컬럼(SCP0130-08) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — SmartColMerge 병합 대상 컬럼(SCP0130-08) 미구현(확인 필요) `.cs` 원문 미확보로 대상 컬럼 특정 불가 |  | 1 (SmartColMerge 병합 대상 컬럼(SCP0130-08)) |
| WK-SCP0130-0003 | X-NOTIMPL | spdSub_ActiveSheetChanging(MSG00129) 편집중 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 미구현(확인 필요) 다중시트 legacy 잔존 여부 미확정 |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |

## W2 구현 위치 확인 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0004 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-01) |
| WK-SCP0130-0005 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0130-0006 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0130-0007 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0130-0008 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0009 | X-LOC | `SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0010 | X-LOC | `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT) |
| WK-SCP0130-0011 | X-LOC | `SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0012 | B3 | ITEM_ID_CHILD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID_CHILD | 있음(SHEET_COLUMNS) | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0013 | B3 | PLANT_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0014 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 2 (Division 그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0015 | B4 | ITEM_ID_CHILD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID_CHILD | 있음(SHEET_COLUMNS) | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0016 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0017 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (Division 그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_) |
| WK-SCP0130-0018 | F2 | SCP0130 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0130 화면 | 판단불가(대상 단위 SCREEN) | 284 (1 9 MSG00001(792/1078, TO-BE 미배선 — 본문 공백) |
| WK-SCP0130-0019 | F6 | SCP0130 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0130 화면 | 판단불가(대상 단위 SCREEN) | 278 (MSG00004(990/1260, 등록 본문공백) `SCP0130_SAV) |
| WK-SCP0130-0020 | DB-SYN | FN_GET_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP FN_GET_DIVISION | 없음(PROC_M 대응 없음) | 1 (Division) |
| WK-SCP0130-0021 | DB-SYN | PKG_SCP0130 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0130 | 없음(PROC_M 대응 없음) | 1 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0022 | DB-SYN | SCP0130_GET_SEARCH_INFO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0130_GET_SEARCH_INFO | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0023 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0024 | E2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0025 | E2 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0026 | E2 | OPMZ_PLAN_GR_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL OPMZ_PLAN_GR_ID | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0027 | E2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0028 | E2 | TO_EXPC_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_EXPC_QTY | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0029 | E2 | TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_YYYYMMDD | 있음(SHEET_COLUMNS) | 2 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) MS) |
| WK-SCP0130-0030 | E2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0031 | G03-WIRE | SCP0130 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0130 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0032 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 17 (10 ACT:SCP0130_ScheduledRecieptInformati) |
| WK-SCP0130-0033 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (13) |
| WK-SCP0130-0034 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0035 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 17 (10 ACT:SCP0130_ScheduledRecieptInformati) |
| WK-SCP0130-0036 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (13) |

## W6 검증 실행 (113)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0037 | J2 | SCP0130 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0130 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 43 (1 2 7 8 9 10 MSG00001(792/1078, TO-BE 미배) |
| WK-SCP0130-0038 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0039 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0040 | C1 | clbChildMaterial / Material / Child Mate | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbChildMaterial / Material / Child Material · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0041 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0042 | C1 | clbSite / Plant Site / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / Plant Site / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0043 | C2 | ITEM_ID_CHILD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID_CHILD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0044 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0045 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0046 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0047 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0048 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0049 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0050 | C3 | TO_EXPC_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_EXPC_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0051 | G3 | SCP0130 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0130 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (`usrLayoutControl2`/`layoutControlGroup2) |
| WK-SCP0130-0052 | K-SA | SCP0130 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0130 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (`usrLayoutControl2`/`layoutControlGroup2) |
| WK-SCP0130-0053 | K4 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0130-0054 | F1 | SCP0130 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0130 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 291 (1 7 9 MSG00001(792/1078, TO-BE 미배선 — 본문 ) |
| WK-SCP0130-0055 | F3 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 10 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0056 | F5 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (1 7 TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02) ) |
| WK-SCP0130-0057 | F4 | FN_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — FN_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (Division) |
| WK-SCP0130-0058 | F4 | PKG_SCP0130 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0130 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0059 | F4 | PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECIEPT_INFORM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 332 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0060 | F4 | PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 333 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0061 | F4 | PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_REC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFOR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 277 (`SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT) |
| WK-SCP0130-0062 | F4 | SCP0130_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0130_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0063 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0064 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (21 ACT:SCP0130_ScheduledRecieptInformati) |
| WK-SCP0130-0065 | A5 | ITEM_ID_CHILD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID_CHILD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0066 | A5 | OPMZ_PLAN_GR_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (22 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0067 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0068 | A5 | PRE_KEY_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0069 | A5 | TO_EXPC_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_EXPC_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (1 ACT:SCP0130_ScheduledRecieptInformatio) |
| WK-SCP0130-0070 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (Valid(조회조건) 그리드 셀 `PLANT_SITE_ID`/`ITEM_) |
| WK-SCP0130-0071 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0072 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0073 | G4 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0074 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0075 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (21) |
| WK-SCP0130-0076 | H2 | ITEM_ID_CHILD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID_CHILD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0077 | H2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (22 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0078 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0079 | H2 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0080 | H2 | TO_EXPC_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_EXPC_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (1 ACT:SCP0130_ScheduledRecieptInformatio) |
| WK-SCP0130-0081 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (Valid(조회조건) 그리드 셀 `PLANT_SITE_ID`/`ITEM_) |
| WK-SCP0130-0082 | H4 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (12 ACT:SCP0130_ScheduledRecieptInformati) |
| WK-SCP0130-0083 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0084 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (21) |
| WK-SCP0130-0085 | H5 | ITEM_ID_CHILD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID_CHILD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0086 | H5 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (22 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0087 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0088 | H5 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0089 | H5 | TO_EXPC_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_EXPC_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (1 ACT:SCP0130_ScheduledRecieptInformatio) |
| WK-SCP0130-0090 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (Valid(조회조건) 그리드 셀 `PLANT_SITE_ID`/`ITEM_) |
| WK-SCP0130-0091 | I1 | SCP0130 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0130 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 37 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) MS) |
| WK-SCP0130-0092 | SC1 | SCP0130 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0130 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 4 (13,14,17 조회조건 7논리조건(8컨트롤) Valid(조회조건) 조회) |
| WK-SCP0130-0093 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0094 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (9,10,12,15,16,18,19 ACT:SCP0130_Schedule) |
| WK-SCP0130-0095 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (10) |
| WK-SCP0130-0096 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0097 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (9,10,12,15,16,18,19 ACT:SCP0130_Schedule) |
| WK-SCP0130-0098 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0099 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (9,10,12,15,16,18,19 ACT:SCP0130_Schedule) |
| WK-SCP0130-0100 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (10) |
| WK-SCP0130-0101 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0102 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (9,10,12,15,16,18,19 ACT:SCP0130_Schedule) |
| WK-SCP0130-0103 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0104 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (21) |
| WK-SCP0130-0105 | D4 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (22 SpdMain_ClipboardPasted 파생 로직(SCP0130) |
| WK-SCP0130-0106 | D5 | TO_EXPC_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_EXPC_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0107 | D6 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 8 (13,14,17 SpdMain_ClipboardPasted 파생 로직(S) |
| WK-SCP0130-0108 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0109 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (SpdMain_ClipboardPasted 파생 로직(SCP0130-10) |
| WK-SCP0130-0110 | E1 | TO_EXPC_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_EXPC_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (1 TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02)) |
| WK-SCP0130-0111 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) Sp) |
| WK-SCP0130-0112 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0113 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) AC) |
| WK-SCP0130-0114 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00004(990/1260, 등록 본문공백) ACT:SCP0130_) |
| WK-SCP0130-0115 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0116 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00046(835/873/1111/1146, 미등록) i18n 갭() |
| WK-SCP0130-0117 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00050(907/1179, 미등록) ACT:SCP0130_Sche) |
| WK-SCP0130-0118 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00085(890/913/1162/1185/1594, 등록 TODO) |
| WK-SCP0130-0119 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00129(1515, 등록) spdSub_ActiveSheetCha) |
| WK-SCP0130-0120 | E4 | MSG00160 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00160 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00160(1599, 미등록) ACT:SCP0130_Schedule) |
| WK-SCP0130-0121 | E4 | MSG00165 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00165 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((literal, msgId 없음, 900/1172)) |
| WK-SCP0130-0122 | E4 | MSG00193 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00193 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00193(1590, 미등록) ACT:SCP0130_Schedule) |
| WK-SCP0130-0123 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00260(1097, 등록 본문존재) ACT:SCP0130_Sche) |
| WK-SCP0130-0124 | E4 | OPMZ_PLAN_GR_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) Sp) |
| WK-SCP0130-0125 | E4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0126 | E4 | TO_EXPC_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_EXPC_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (1 MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0127 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백) MS) |
| WK-SCP0130-0128 | E4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0129 | E4 | usrButton1 / Button1 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — usrButton1 / Button1 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (`usrButton1`(x0/y0/tab0, 용도불명) From Date) |
| WK-SCP0130-0130 | A10 | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 59 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0131 | A6 | FN_GET_DIVISION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — FN_GET_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (Division) |
| WK-SCP0130-0132 | A6 | PKG_SCP0130 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0130 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0133 | A6 | PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECIEPT_INFORM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 57 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0134 | A6 | PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 58 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0135 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0136 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0137 | G1 | clbChildMaterial / Material / Child Mate | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbChildMaterial / Material / Child Material · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0138 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0139 | G1 | clbSite / Plant Site / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / Plant Site / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0140 | G1 | txtItemId / Parent Model / Item Id / Mod | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Parent Model / Item Id / Model/Nicknam · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0141 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0142 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0143 | G6 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0144 | X-REOPEN | SCP0130 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0130 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0145 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0146 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 17 (10 ACT:SCP0130_ScheduledRecieptInformati) |
| WK-SCP0130-0147 | M4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0148 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (13) |
| WK-SCP0130-0149 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |

## W7 기대값 확정 (292)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0150 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0151 | C1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 8: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0152 | C1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 9: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0130-0153 | C2 | SCP0130_ScheduledRecieptInformation.CboD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboDivision_Se: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0154 | C2 | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanGroup_S: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0155 | C2 | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanSeq_Sel: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0156 | C2 | SCP0130_ScheduledRecieptInformation.ClbD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.ClbDivision_Se: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0157 | C2 | SCP0130_ScheduledRecieptInformation.Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.DatePicker_Val: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0158 | C2 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Active: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0159 | C2 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Change: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0160 | C3 | SCP0130_ScheduledRecieptInformation.CboD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboDivision_Se: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0161 | C3 | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanGroup_S: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0162 | C3 | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanSeq_Sel: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0163 | C3 | SCP0130_ScheduledRecieptInformation.ClbD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.ClbDivision_Se: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0164 | C3 | SCP0130_ScheduledRecieptInformation.Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.DatePicker_Val: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0165 | C3 | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetCellFocus_E: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0166 | C3 | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetChangedCont: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0167 | C3 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0168 | C3 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Active: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0169 | C3 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Change: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0170 | C3 | SCP0130_ScheduledRecieptInformation.setD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0130_ScheduledRecieptInformation.setDatePicker: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0171 | B3 | SCP0130_ScheduledRecieptInformation.GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetDivisionChe: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0172 | B3 | SCP0130_ScheduledRecieptInformation.GetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetSearchInfo: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0173 | B4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 2: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0174 | B4 | SCP0130_ScheduledRecieptInformation.GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetDivisionChe: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0175 | B4 | SCP0130_ScheduledRecieptInformation.GetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetSearchInfo: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0176 | B4 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0177 | B4 | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0178 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 6요소: NOPATH:3 · PASS:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0179 | DB-SYN | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 2: 행 집계 — DB-SYN 6요소: NOPATH:3 · PASS:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0180 | DB-SYN | MSG00004(990/1260, 등록 본문공백) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — MSG00004(990/1260, 등록 본문공백): 행 집계 — DB-SYN 6요소: NOPATH:3 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004(990/1260, 등록 본문공백)) |
| WK-SCP0130-0181 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0182 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0183 | F4 | MSG00004(990/1260, 등록 본문공백) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — MSG00004(990/1260, 등록 본문공백): 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MSG00004(990/1260, 등록 본문공백)) |
| WK-SCP0130-0184 | A5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 11: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0130-0185 | A5 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 13,14,17: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0186 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0187 | A5 | 2,3,5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2,3,5: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2,3,5) |
| WK-SCP0130-0188 | A5 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 20: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-SCP0130-0189 | A5 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 23: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (23) |
| WK-SCP0130-0190 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0130-0191 | A5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 5: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0192 | A5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 6: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0130-0193 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0130-0194 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0130-0195 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0196 | A5 | InsertButton 사전조건 가드(SCP0130-13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — InsertButton 사전조건 가드(SCP0130-13): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드(SCP0130-13)) |
| WK-SCP0130-0197 | A5 | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — MSG00129(1515, 등록): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0198 | A5 | Plan Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Plan Group: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Plan Group) |
| WK-SCP0130-0199 | A5 | SCP0130_ScheduledRecieptInformation.Crea | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0130_ScheduledRecieptInformation.CreateSpread: 진입점 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0200 | A5 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0201 | A5 | formatItem(wj-cell-editable 시각 강조, SCP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — formatItem(wj-cell-editable 시각 강조, SCP0130-06): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (formatItem(wj-cell-editable 시각 강조, SCP01) |
| WK-SCP0130-0202 | A5 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0203 | A5 | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0204 | A5 | 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운)) |
| WK-SCP0130-0205 | G4 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 13,14,17: 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0206 | G4 | Valid(조회조건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Valid(조회조건): 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Valid(조회조건)) |
| WK-SCP0130-0207 | G4 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0208 | G4 | 조회조건 Site/Child Material 콤보 배선(SCP0130-0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건 Site/Child Material 콤보 배선(SCP0130-03): 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 Site/Child Material 콤보 배선(SCP0130-0) |
| WK-SCP0130-0209 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0130-0210 | H2 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 12: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0130-0211 | H2 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 13,14,17: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0212 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0213 | H2 | 2,3,5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2,3,5: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2,3,5) |
| WK-SCP0130-0214 | H2 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 20: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-SCP0130-0215 | H2 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 23: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (23) |
| WK-SCP0130-0216 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0130-0217 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0218 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0130-0219 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0130-0220 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0130-0221 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0222 | H2 | InsertButton 사전조건 가드(SCP0130-13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — InsertButton 사전조건 가드(SCP0130-13): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드(SCP0130-13)) |
| WK-SCP0130-0223 | H2 | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — MSG00129(1515, 등록): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0224 | H2 | Plan Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Plan Group: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Plan Group) |
| WK-SCP0130-0225 | H2 | SCP0130_ScheduledRecieptInformation.Crea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0130_ScheduledRecieptInformation.CreateSpread: 진입점 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0226 | H2 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0227 | H2 | formatItem(wj-cell-editable 시각 강조, SCP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — formatItem(wj-cell-editable 시각 강조, SCP0130-06): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (formatItem(wj-cell-editable 시각 강조, SCP01) |
| WK-SCP0130-0228 | H2 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0229 | H2 | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0230 | H2 | 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운)) |
| WK-SCP0130-0231 | H5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 11: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0130-0232 | H5 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 13,14,17: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0233 | H5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0234 | H5 | 2,3,5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2,3,5: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2,3,5) |
| WK-SCP0130-0235 | H5 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 20: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-SCP0130-0236 | H5 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 23: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (23) |
| WK-SCP0130-0237 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0130-0238 | H5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 5: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0239 | H5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 6: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0130-0240 | H5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 7: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0130-0241 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0130-0242 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0243 | H5 | InsertButton 사전조건 가드(SCP0130-13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — InsertButton 사전조건 가드(SCP0130-13): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드(SCP0130-13)) |
| WK-SCP0130-0244 | H5 | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — MSG00129(1515, 등록): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0245 | H5 | Plan Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Plan Group: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Plan Group) |
| WK-SCP0130-0246 | H5 | SCP0130_ScheduledRecieptInformation.Crea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0130_ScheduledRecieptInformation.CreateSpread: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0247 | H5 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0248 | H5 | formatItem(wj-cell-editable 시각 강조, SCP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — formatItem(wj-cell-editable 시각 강조, SCP0130-06): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (formatItem(wj-cell-editable 시각 강조, SCP01) |
| WK-SCP0130-0249 | H5 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0250 | H5 | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0251 | H5 | 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운)) |
| WK-SCP0130-0252 | X-REASON | 24 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 24 SetActiveCell(1605) 순수 UX(포커스 복원) — 데이터 계약 영향 없음, 미구현해도 무방(design 03 §3 판정) 해당없음(UX 선택사항) |  | 1 (24) |
| WK-SCP0130-0253 | X-REASON | 6 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 6 SetSheetHeaderColumnSCP siObj(462) 정체 미상(design 03 §6-1) 확인 필요 |  | 0 () |
| WK-SCP0130-0254 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 콤마 다중조회 해당없음 — Item ID 는 팝업 단일선택 해당없음 |  | 1 (COMMON:UC-06) |
| WK-SCP0130-0255 | X-REASON | static(`components`,`emptySpaceItem*`) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — static(`components`,`emptySpaceItem*`) 비시각 — 매핑 대상 아님 해당없음 |  | 1 (static(`components`,`emptySpaceItem*`)) |
| WK-SCP0130-0256 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0257 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0258 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0259 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0130-0260 | D1 | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — MSG00129(1515, 등록): 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0261 | D1 | SCP0130_ScheduledRecieptInformation.Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0130_ScheduledRecieptInformation.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0262 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0263 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0264 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0265 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0130-0266 | D3 | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — MSG00129(1515, 등록): 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0267 | D3 | SCP0130_ScheduledRecieptInformation.Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0130_ScheduledRecieptInformation.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0268 | D4 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 13,14,17: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0269 | D4 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 23: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (23) |
| WK-SCP0130-0270 | D4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 5: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0271 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0130-0272 | D4 | From Date 기본값 자동세팅(react-gap-audit issue | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — From Date 기본값 자동세팅(react-gap-audit issue ID `SCP01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (From Date 기본값 자동세팅(react-gap-audit issue) |
| WK-SCP0130-0273 | D4 | InsertButton 사전조건 가드(SCP0130-13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — InsertButton 사전조건 가드(SCP0130-13): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드(SCP0130-13)) |
| WK-SCP0130-0274 | D4 | InsertButton 실동작 판정 자체(NO-OP 여부) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — InsertButton 실동작 판정 자체(NO-OP 여부): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 실동작 판정 자체(NO-OP 여부)) |
| WK-SCP0130-0275 | D4 | formatItem(wj-cell-editable 시각 강조, SCP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — formatItem(wj-cell-editable 시각 강조, SCP0130-06): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (formatItem(wj-cell-editable 시각 강조, SCP01) |
| WK-SCP0130-0276 | D5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 2: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0130-0277 | D5 | SCP0130_ScheduledRecieptInformation.Crea | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0130_ScheduledRecieptInformation.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0278 | D5 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0279 | D5 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0280 | D5 | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0281 | E1 | (literal, msgId 없음, 900/1172) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — (literal, msgId 없음, 900/1172): 행 집계 — E1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 ((literal, msgId 없음, 900/1172)) |
| WK-SCP0130-0282 | E2 | From Date 기본값 자동세팅(react-gap-audit issue | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — From Date 기본값 자동세팅(react-gap-audit issue ID `SCP01: 행 집계 — E2 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (From Date 기본값 자동세팅(react-gap-audit issue) |
| WK-SCP0130-0283 | E4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 1: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0284 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0285 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0286 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0130-0287 | E4 | InsertButton 사전조건 가드(SCP0130-13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — InsertButton 사전조건 가드(SCP0130-13): 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드(SCP0130-13)) |
| WK-SCP0130-0288 | E4 | InsertButton 실동작 판정 자체(NO-OP 여부) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — InsertButton 실동작 판정 자체(NO-OP 여부): 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 실동작 판정 자체(NO-OP 여부)) |
| WK-SCP0130-0289 | E4 | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetCellFocus_E: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0290 | E4 | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetChangedCont: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0291 | E4 | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0292 | E4 | SCP0130_ScheduledRecieptInformation.setD | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0130_ScheduledRecieptInformation.setDatePicker: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0293 | E4 | `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION`(PRE_*: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT) |
| WK-SCP0130-0294 | E4 | `SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지, PRE_* 포함: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지) |
| WK-SCP0130-0295 | E4 | 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운): 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운)) |
| WK-SCP0130-0296 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (1) |
| WK-SCP0130-0297 | A1 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13,14,17: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (13,14,17) |
| WK-SCP0130-0298 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (9) |
| WK-SCP0130-0299 | A1 | 9,10,12,15,16,18,19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9,10,12,15,16,18,19: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0300 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-02) |
| WK-SCP0130-0301 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0302 | A1 | FN_GET_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FN_GET_DIVISION: 골든 비교 케이스 없음(FN_GET_DIVISION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (Division) |
| WK-SCP0130-0303 | A1 | PKG_SCP0130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0130: 골든 비교 케이스 없음(PKG_SCP0130 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0304 | A1 | PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECIEPT_INFORM: 골든 비교 케이스 없음(PKG_SCP0130.P_SCP0130_GET_SCHEDULED_RECIEPT_INFORMATI |  | 57 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0305 | A1 | PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM: 골든 비교 케이스 없음(PKG_SCP0130.P_SCP0130_GET_VIRTUAL_BOM — 팝업·보조 SP 는 golden_cases.cs |  | 58 (`SCP0130_GET_VIRTUAL_BOM`(7파라미터: Divisio) |
| WK-SCP0130-0306 | A1 | PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_REC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFOR: 골든 비교 케이스 없음(PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT |  | 1 (`SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT) |
| WK-SCP0130-0307 | A1 | TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02)) |
| WK-SCP0130-0308 | A1 | Valid(조회조건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Valid(조회조건): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (Valid(조회조건)) |
| WK-SCP0130-0309 | A1 | Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite`: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit) |
| WK-SCP0130-0310 | A1 | i18n 갭(MSG00046/050/160/193 미등록, SCP0130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — i18n 갭(MSG00046/050/160/193 미등록, SCP0130-12): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (i18n 갭(MSG00046/050/160/193 미등록, SCP0130) |
| WK-SCP0130-0311 | A1 | 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0312 | A1 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0313 | A1 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0314 | A1 | 조회조건 Site/Child Material 콤보 배선(SCP0130-0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 Site/Child Material 콤보 배선(SCP0130-03): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (조회조건 Site/Child Material 콤보 배선(SCP0130-0) |
| WK-SCP0130-0315 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0316 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0130-0317 | G1 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 13,14,17: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0318 | G1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0130-0319 | G1 | 9,10,12,15,16,18,19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9,10,12,15,16,18,19: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0320 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0130-0321 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0130-0322 | G1 | TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02)) |
| WK-SCP0130-0323 | G1 | Valid(조회조건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Valid(조회조건): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Valid(조회조건)) |
| WK-SCP0130-0324 | G1 | Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite`: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit) |
| WK-SCP0130-0325 | G1 | `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION`(PRE_*: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMAT) |
| WK-SCP0130-0326 | G1 | i18n 갭(MSG00046/050/160/193 미등록, SCP0130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — i18n 갭(MSG00046/050/160/193 미등록, SCP0130-12): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (i18n 갭(MSG00046/050/160/193 미등록, SCP0130) |
| WK-SCP0130-0327 | G1 | 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0328 | G1 | 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 그리드 셀 콤보 `PlanGroup`(SCP0130-01): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (그리드 셀 콤보 `PlanGroup`(SCP0130-01)) |
| WK-SCP0130-0329 | G1 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0330 | G1 | 조회조건 Site/Child Material 콤보 배선(SCP0130-0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건 Site/Child Material 콤보 배선(SCP0130-03): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 Site/Child Material 콤보 배선(SCP0130-0) |
| WK-SCP0130-0331 | G6 | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 13,14,17: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (13,14,17) |
| WK-SCP0130-0332 | G6 | Valid(조회조건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Valid(조회조건): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Valid(조회조건)) |
| WK-SCP0130-0333 | G6 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0334 | G6 | 조회조건 Site/Child Material 콤보 배선(SCP0130-0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건 Site/Child Material 콤보 배선(SCP0130-03): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 Site/Child Material 콤보 배선(SCP0130-0) |
| WK-SCP0130-0335 | X-LOC | (literal, msgId 없음, 900/1172) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (literal, msgId 없음, 900/1172): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((literal, msgId 없음, 900/1172)) |
| WK-SCP0130-0336 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0130-0337 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0130-0338 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0130-0339 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0130-0340 | X-LOC | 13,14,17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13,14,17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13,14,17) |
| WK-SCP0130-0341 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0130-0342 | X-LOC | 2,3,5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2,3,5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2,3,5) |
| WK-SCP0130-0343 | X-LOC | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 20: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (20) |
| WK-SCP0130-0344 | X-LOC | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (21) |
| WK-SCP0130-0345 | X-LOC | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 23: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (23) |
| WK-SCP0130-0346 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0130-0347 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0130-0348 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0130-0349 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0130-0350 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0130-0351 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0130-0352 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0130-0353 | X-LOC | 9,10,12,15,16,18,19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9,10,12,15,16,18,19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9,10,12,15,16,18,19) |
| WK-SCP0130-0354 | X-LOC | Child Material | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Child Material: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Child Material) |
| WK-SCP0130-0355 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SCP0130-0356 | X-LOC | InsertButton 실동작 판정 자체(NO-OP 여부) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton 실동작 판정 자체(NO-OP 여부): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton 실동작 판정 자체(NO-OP 여부)) |
| WK-SCP0130-0357 | X-LOC | MSG00001(792/1078, TO-BE 미배선 — 본문 공백) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00001(792/1078, TO-BE 미배선 — 본문 공백): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00001(792/1078, TO-BE 미배선 — 본문 공백)) |
| WK-SCP0130-0358 | X-LOC | MSG00004(990/1260, 등록 본문공백) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00004(990/1260, 등록 본문공백): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00004(990/1260, 등록 본문공백)) |
| WK-SCP0130-0359 | X-LOC | MSG00046(835/873/1111/1146, 미등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00046(835/873/1111/1146, 미등록): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00046(835/873/1111/1146, 미등록)) |
| WK-SCP0130-0360 | X-LOC | MSG00050(907/1179, 미등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00050(907/1179, 미등록): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00050(907/1179, 미등록)) |
| WK-SCP0130-0361 | X-LOC | MSG00085(890/913/1162/1185/1594, 등록 TODO | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085(890/913/1162/1185/1594, 등록 TODO): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085(890/913/1162/1185/1594, 등록 TODO) |
| WK-SCP0130-0362 | X-LOC | MSG00129(1515, 등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00129(1515, 등록): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00129(1515, 등록)) |
| WK-SCP0130-0363 | X-LOC | MSG00160(1599, 미등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00160(1599, 미등록): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00160(1599, 미등록)) |
| WK-SCP0130-0364 | X-LOC | MSG00193(1590, 미등록) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00193(1590, 미등록): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00193(1590, 미등록)) |
| WK-SCP0130-0365 | X-LOC | MSG00260(1097, 등록 본문존재) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00260(1097, 등록 본문존재): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00260(1097, 등록 본문존재)) |
| WK-SCP0130-0366 | X-LOC | Plan Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Plan Group: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Plan Group) |
| WK-SCP0130-0367 | X-LOC | Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Site: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Site) |
| WK-SCP0130-0368 | X-LOC | Valid(조회조건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Valid(조회조건): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Valid(조회조건)) |
| WK-SCP0130-0369 | X-LOC | Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit) |
| WK-SCP0130-0370 | X-LOC | Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite` 도메인 불일치: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit) |
| WK-SCP0130-0371 | X-LOC | `OPMZ_PLAN_GR_ID` 필수 라벨(*) vs `INPUT_TP_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `OPMZ_PLAN_GR_ID` 필수 라벨(*) vs `INPUT_TP_CD='S'` 불일: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`OPMZ_PLAN_GR_ID` 필수 라벨(*) vs `INPUT_TP_) |
| WK-SCP0130-0372 | X-LOC | `PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH_INFO/SVAE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH) |
| WK-SCP0130-0373 | X-LOC | `spdMain`/`spdMain_Sheet1`(2 sheetNm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `spdMain`/`spdMain_Sheet1`(2 sheetNm): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`spdMain`/`spdMain_Sheet1`(2 sheetNm)) |
| WK-SCP0130-0374 | X-LOC | `usrButton1`(x0/y0/tab0, 용도불명) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrButton1`(x0/y0/tab0, 용도불명): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrButton1`(x0/y0/tab0, 용도불명)) |
| WK-SCP0130-0375 | X-LOC | `usrButton1`(용도불명, SCP0130-07) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrButton1`(용도불명, SCP0130-07): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrButton1`(용도불명, SCP0130-07)) |
| WK-SCP0130-0376 | X-LOC | `usrLayoutControl2`/`layoutControlGroup2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrLayoutControl2`/`layoutControlGroup2`/`pnlCond: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrLayoutControl2`/`layoutControlGroup2) |
| WK-SCP0130-0377 | X-LOC | i18n 갭(MSG00046/050/160/193 미등록, SCP0130 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — i18n 갭(MSG00046/050/160/193 미등록, SCP0130-12): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (i18n 갭(MSG00046/050/160/193 미등록, SCP0130) |
| WK-SCP0130-0378 | X-LOC | 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox)) |
| WK-SCP0130-0379 | X-LOC | 그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`VALID_YN`(S: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`V) |
| WK-SCP0130-0380 | X-LOC | 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SC: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`V) |
| WK-SCP0130-0381 | X-LOC | 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운)) |
| WK-SCP0130-0382 | X-LOC | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건 7논리조건(8컨트롤): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0383 | X-LOC | 조회조건 Site/Child Material 콤보 배선(SCP0130-0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건 Site/Child Material 콤보 배선(SCP0130-03): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회조건 Site/Child Material 콤보 배선(SCP0130-0) |
| WK-SCP0130-0384 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (3) |
| WK-SCP0130-0385 | X-ROW | Child Material | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Child Material: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Child Material) |
| WK-SCP0130-0386 | X-ROW | SCP0130_ScheduledRecieptInformation.CboD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboDivision_Se: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0387 | X-ROW | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanGroup_S: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0388 | X-ROW | SCP0130_ScheduledRecieptInformation.CboP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CboPlanSeq_Sel: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0389 | X-ROW | SCP0130_ScheduledRecieptInformation.Chec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CheckDigitValu: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0390 | X-ROW | SCP0130_ScheduledRecieptInformation.ClbD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.ClbDivision_Se: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0391 | X-ROW | SCP0130_ScheduledRecieptInformation.Copy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CopyPlantSite: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/FLAG/LOCAL, 연결된 요 |  | 11 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0392 | X-ROW | SCP0130_ScheduledRecieptInformation.Crea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0393 | X-ROW | SCP0130_ScheduledRecieptInformation.Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.DatePicker_Val: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0394 | X-ROW | SCP0130_ScheduledRecieptInformation.Defi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0395 | X-ROW | SCP0130_ScheduledRecieptInformation.Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0396 | X-ROW | SCP0130_ScheduledRecieptInformation.Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.FindData_Main: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 8 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0397 | X-ROW | SCP0130_ScheduledRecieptInformation.Form | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0398 | X-ROW | SCP0130_ScheduledRecieptInformation.GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetDivisionChe: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0399 | X-ROW | SCP0130_ScheduledRecieptInformation.GetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.GetSearchInfo: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0400 | X-ROW | SCP0130_ScheduledRecieptInformation.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0401 | X-ROW | SCP0130_ScheduledRecieptInformation.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.InitCurrentCel: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0402 | X-ROW | SCP0130_ScheduledRecieptInformation.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0403 | X-ROW | SCP0130_ScheduledRecieptInformation.Inse | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0404 | X-ROW | SCP0130_ScheduledRecieptInformation.Inse | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0405 | X-ROW | SCP0130_ScheduledRecieptInformation.Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.RefreshDivisio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0406 | X-ROW | SCP0130_ScheduledRecieptInformation.Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.RefreshPlanGro: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0407 | X-ROW | SCP0130_ScheduledRecieptInformation.Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.RefreshSiteByD: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0408 | X-ROW | SCP0130_ScheduledRecieptInformation.Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.RefreshSiteByP: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0409 | X-ROW | SCP0130_ScheduledRecieptInformation.Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SaveData: 진입점 집계 17검사 — NOT_RUN:12 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0410 | X-ROW | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetCellFocus_E: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0411 | X-ROW | SCP0130_ScheduledRecieptInformation.SetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetChangedCont: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0412 | X-ROW | SCP0130_ScheduledRecieptInformation.SetS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0413 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Active: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0414 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_CellDo: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0415 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Change: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0416 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_Clipbo: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0417 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_EditCh: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0418 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_EditMo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/RETURN, 연결된 요 |  | 4 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0419 | X-ROW | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_TopCha: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0420 | X-ROW | SCP0130_ScheduledRecieptInformation.Vali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.ValidateUserIn: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0421 | X-ROW | SCP0130_ScheduledRecieptInformation.btnI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.btnItemId_Clic: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0422 | X-ROW | SCP0130_ScheduledRecieptInformation.setD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.setDatePicker: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0423 | X-ROW | SCP0130_ScheduledRecieptInformation.spdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.spdMain_CellCl: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0424 | X-ROW | SCP0130_ScheduledRecieptInformation.spdS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0130_ScheduledRecieptInformation.spdSub_ActiveS: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0425 | X-ROW | Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Site: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Site) |
| WK-SCP0130-0426 | X-ROW | Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite` 도메인 불일치: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSit) |
| WK-SCP0130-0427 | X-ROW | `PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH_INFO/SVAE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH) |
| WK-SCP0130-0428 | X-ROW | `spdMain`/`spdMain_Sheet1`(2 sheetNm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `spdMain`/`spdMain_Sheet1`(2 sheetNm): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`spdMain`/`spdMain_Sheet1`(2 sheetNm)) |
| WK-SCP0130-0429 | X-ROW | `usrButton1`(용도불명, SCP0130-07) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `usrButton1`(용도불명, SCP0130-07): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`usrButton1`(용도불명, SCP0130-07)) |
| WK-SCP0130-0430 | G5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 4: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0431 | G5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 5: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0130-0432 | G5 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_CellDo: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0433 | G5 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0434 | H6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 4: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0435 | H6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 5: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0130-0436 | H6 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_CellDo: 진입점 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0437 | H6 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |
| WK-SCP0130-0438 | M4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 4: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0130-0439 | M4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 5: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0130-0440 | M4 | SCP0130_ScheduledRecieptInformation.SpdM | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0130_ScheduledRecieptInformation.SpdMain_CellDo: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0130_ScheduledRecieptInformation.) |
| WK-SCP0130-0441 | M4 | 조회조건 7논리조건(8컨트롤) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 조회조건 7논리조건(8컨트롤): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 7논리조건(8컨트롤)) |

## W8 구현 후 검증 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0130-0442 | A5 | spdSub_ActiveSheetChanging(MSG00129) 편집중 | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 구현 후 검증 · 대상 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SC |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |
| WK-SCP0130-0443 | H2 | spdSub_ActiveSheetChanging(MSG00129) 편집중 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 구현 후 검증 · 대상 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SC |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |
| WK-SCP0130-0444 | H3 | SmartColMerge 병합 대상 컬럼(SCP0130-08) | 선행 W1 완료 후 E2E | H3 — 대조표 미구현 행 SmartColMerge 병합 대상 컬럼(SCP0130-08) 구현 후 검증 · 대상 SmartColMerge 병합 대상 컬럼(SCP0130-08) |  | 1 (SmartColMerge 병합 대상 컬럼(SCP0130-08)) |
| WK-SCP0130-0445 | H5 | spdSub_ActiveSheetChanging(MSG00129) 편집중 | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 구현 후 검증 · 대상 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SC |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |
| WK-SCP0130-0446 | D1 | spdSub_ActiveSheetChanging(MSG00129) 편집중 | 선행 W1 완료 후 E2E | D1 — 대조표 미구현 행 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 구현 후 검증 · 대상 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SC |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |
| WK-SCP0130-0447 | D3 | spdSub_ActiveSheetChanging(MSG00129) 편집중 | 선행 W1 완료 후 E2E | D3 — 대조표 미구현 행 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) 구현 후 검증 · 대상 spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SC |  | 1 (spdSub_ActiveSheetChanging(MSG00129) 편집중) |
| WK-SCP0130-0448 | X-ROW | SetActiveCell 포커스 복원(SCP0130-11) | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 SetActiveCell 포커스 복원(SCP0130-11) 구현 후 검증 · 대상 SetActiveCell 포커스 복원(SCP0130-11) |  | 1 (SetActiveCell 포커스 복원(SCP0130-11)) |
