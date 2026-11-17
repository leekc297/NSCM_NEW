# 작업 원장 — SCP0041 · 2026-11-14 15:40

> 검사 인스턴스 419건 중 PASS·NA 231건 외 **188건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 25 | 재판정 PASS |
| W5 | 검사기 연결 | 5 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 45 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 113 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 113 · 사람 판정 / AS-IS 원문 확인 → 재판정 37 · 화면 FE 20 · 대조표 8 · 하네스 5 · 사람판정 3 · FE 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 21 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D3 | EDIT |  |  | 12 |  |  |  |  |  | 8 | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  | 3 |  |  |  | 1 |  | 12 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 14 | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  |  |  |  | 14 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-LOC | GEN |  |  |  |  |  |  | 12 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 10 | 컬럼 편집 가능 여부(신규행·기존행) |
| G4 | DESIGN |  |  | 7 |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  |  |  |  |  | 8 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 8 | 무변경 편집 종료 시 연쇄 미발동 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 6 | 그리드 셀 cascade 후보 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 6 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  |  |  |  |  |  | 5 | 콤보 후보 정렬 = AS-IS |
| A6 | GEN |  |  | 3 |  |  |  |  |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 1 |  |  |  | 3 | 팝업 조건 연동(인자) |
| F4 | DB |  |  |  |  |  |  |  |  | 4 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 4 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H6 | POPUP |  |  |  |  | 1 |  |  |  | 2 | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  |  | 3 |  |  | 팝업 선택값 반영 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 3 | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  |  |  |  |  | 2 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  |  |  |  |  | 2 | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  |  |  |  |  | 2 | ALL 옵션·다중선택 사양 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0001 | G4 | COMMON:UC-06 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 G4 6요소: NA:3 · FAIL:2 · NOPATH:1 · FAIL 요 |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0002 | G4 | D00-1-024 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-024: 행 집계 — 대조표 D00-1-024 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 6요소: NA:3 · FAIL:2 · NOPATH:1 · FAIL |  | 1 (D00-1-024) |
| WK-SCP0041-0003 | G4 | D00-1-025 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-1-025: 행 집계 — 대조표 D00-1-025 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G4 6요소: NA:3 · FAIL:2 · NOPATH:1 · FAIL 요 |  | 1 (D00-1-025) |
| WK-SCP0041-0004 | G4 | cboStatus / Status | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboStatus / Status: 원장 V-efeb3e6d SEARCH / E2E smoke labels — 누락 라벨 |  | 4 (D00-1-018 cboStatus (Pack) ACT:SCP0041_S) |
| WK-SCP0041-0005 | G4 | dCalendar (필수) | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — dCalendar (필수): 행 집계 — 대조표 dCalendar (필수) '기간' 의 G4 6요소: NA:3 · FAIL:2 · NOPATH:1 · FAIL 요소: txtInspection / DefPackL |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0006 | G4 | dCalendarCutoff (Pack) | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — dCalendarCutoff (Pack): 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 G4 6요소: NA:3 · FAIL:2 · NOPATH:1 · FAIL 요소: txtInspe |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0007 | G4 | txtInspection / DefPackLabel.INSEPECTION | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — txtInspection / DefPackLabel.INSEPECTION_ID / Inspection: E2E smoke labels — 누락 라벨 |  | 2 (D00-1-016 txtInspection (Pack)) |
| WK-SCP0041-0008 | D3 | D00-2-006 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-2-006: 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS:3 · FAIL 요소: siMain.Lock |  | 1 (D00-2-006) |
| WK-SCP0041-0009 | D3 | D00-3-004 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-3-004: 행 집계 — 대조표 D00-3-004 '§3 LockRange / (전체셀 잠금 iRowStart..iColEnd, true)' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS |  | 1 (D00-3-004) |
| WK-SCP0041-0010 | D3 | D00-3-008 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-3-008: 행 집계 — 대조표 D00-3-008 '§3 LockRange / (iRow, iCol_QTY, true) — 非HOLD 행 잠금' 의 D3 14요소: ERROR:8 · FAIL:3 · PA |  | 1 (D00-3-008) |
| WK-SCP0041-0011 | D3 | SCP0041_StockOSP.EditButton | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — SCP0041_StockOSP.EditButton: 원장 V-f21dd8c5 ASIS / 원장 V-6311f9fe ASIS / 원장 V-4dc694a5 ASIS / 원장 V-b7a11e18 ASIS / 원장 V |  | 13 (ACT:SCP0041_StockOSP.EditButton:259:1 AC) |
| WK-SCP0041-0012 | D3 | [R10] | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — [R10]: 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS:3 · FAIL 요소: siMain.LockRange — 원장 V- |  | 1 ([R10]) |
| WK-SCP0041-0013 | D3 | [R12/R13] | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — [R12/R13]: 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS:3 · FAIL 요소: siMain.Lo |  | 1 ([R12/R13]) |
| WK-SCP0041-0014 | D3 | [R1] | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — [R1]: 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS:3 · FAIL 요소:  |  | 1 ([R1]) |
| WK-SCP0041-0015 | D3 | [R6] | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — [R6]: 행 집계 — 대조표 [R6] 'EditButton 모드토글' 의 D3 14요소: ERROR:8 · FAIL:3 · PASS:3 · FAIL 요소: siMain.LockRange — 원장 V-4dc69 |  | 1 ([R6]) |
| WK-SCP0041-0016 | D3 | `sheet[1] shtPacker "Pack Hold Stock"` | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — `sheet[1] shtPacker "Pack Hold Stock"`: 행 집계 — 대조표 `sheet[1] shtPacker "Pack Hold Stock"` '`<PackHoldStockGrid>` (15컬 |  | 1 (`sheet[1] shtPacker "Pack Hold Stock"`) |
| WK-SCP0041-0017 | D3 | siMain.LockRange | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — siMain.LockRange: 원장 V-4dc694a5 (FX-SCP0041-010) |  | 1 (ACT:SCP0041_StockOSP.EditButton:294:21) |
| WK-SCP0041-0018 | D3 | siMain.LockRange | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — siMain.LockRange: 원장 V-b7a11e18 (FX-SCP0041-011) |  | 1 (ACT:SCP0041_StockOSP.EditButton:295:22) |
| WK-SCP0041-0019 | D3 | siMain.LockRange | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — siMain.LockRange: 원장 V-0bd071e5 (FX-SCP0041-012) |  | 1 (ACT:SCP0041_StockOSP.EditButton:296:23) |
| WK-SCP0041-0020 | A6 | D00-3-013 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-3-013: 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A6 2요소: ERROR:1 · FAIL:1 · FAIL 요소: PKG_SC |  | 1 (D00-3-013) |
| WK-SCP0041-0021 | A6 | D00-3-015 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-3-015: 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A6 2요소: ERROR:1 · FAIL:1 · FAIL 요소: PKG_SC |  | 1 (D00-3-015) |
| WK-SCP0041-0022 | A6 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP: 원장 V-04df217d SP / 정렬대조 PASS AS-IS 키 뒤에 동률 고정 키 추가 ['YYYYMMDD', 'ATTRIBUTE1'] —  |  | 44 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0023 | X-ROW | SCP0041_StockOSP.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0041_StockOSP.FindButton: 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 (FX-SCP0041-088) |  | 1 (ACT:SCP0041_StockOSP.FindButton) |
| WK-SCP0041-0024 | X-ROW | SCP0041_StockOSP.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0041_StockOSP.FindData_Main: 진입점 집계 12검사 — PASS:6 · NA:3 · ERROR:2 · FAIL:1 (FX-SCP0041-090) |  | 7 (ACT:SCP0041_StockOSP.FindData_Main:631:1) |
| WK-SCP0041-0025 | X-ROW | SCP0041_StockOSP.InitControls | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0041_StockOSP.InitControls: 진입점 집계 8검사 — PASS:5 · NA:2 · FAIL:1 (FX-SCP0041-092) |  | 4 (ACT:SCP0041_StockOSP.InitControls:143:3 ) |

## W5 검사기 연결 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0026 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0041_StockOSP.GetLookupData:165:3) |
| WK-SCP0041-0027 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (txtItemId + btnItemId ACT:SCP0041_StockO) |
| WK-SCP0041-0028 | G03-WIRE | SCP0041 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0041 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCP0041_StockOSP..ctor ACT:SCP0041_S) |
| WK-SCP0041-0029 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0030 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W7 기대값 확정 (45)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0031 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRowVisibleUnderFilter) — INSERT 버튼 DB 미등록(hasButto |  | 1 (COMMON:UC-01) |
| WK-SCP0041-0032 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) — AS-IS SCP0041_StockOS |  | 1 (COMMON:UC-02) |
| WK-SCP0041-0033 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) 공용 SubTitle excelFileName 위 |  | 1 (COMMON:UC-05) |
| WK-SCP0041-0034 | X-REASON | COMMON:UC-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-07 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 (rebindFilterColumns) 공용 DataGrid gridFilterRef 위임 필터 유지·rebind  |  | 1 (COMMON:UC-07) |
| WK-SCP0041-0035 | X-REASON | D00-1-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-028 §1 components / Container — Designer IContainer(컴포넌트 트레이) — 런타임 UI 아님, React 대응 없음 해당없음 |  | 1 (D00-1-028) |
| WK-SCP0041-0036 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 — AS-IS 조회모드 전열잠금 = EditButton 모드토글의 일부(R12 |  | 1 (D00-3-014) |
| WK-SCP0041-0037 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 §4b Data.CallBizCommonData / PERIOD_DEFAULT / dt — AS-IS 기간 기본값(PERIOD_DEFAULT) 프리셋 — TO-BE PeriodFi |  | 1 (D00-4b-005) |
| WK-SCP0041-0038 | X-REASON | MODAL:FPModal | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:FPModal AS-IS 화면에 별도 FPModal(범용 조회 팝업) 사용 없음 — Model 조회는 ItemByDivisionModal(COM0008) 단일 — AS-IS SCP0041_ |  | 1 (MODAL:FPModal) |
| WK-SCP0041-0039 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_S |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0040 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — 대조표 D00-1-008 '§1 btnItemId / UsrButton' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP004 |  | 1 (D00-1-008) |
| WK-SCP0041-0041 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 ActiveSheet / CellChanged' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SC |  | 1 (D00-2-001) |
| WK-SCP0041-0042 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — 대조표 D00-2-003 '§2 btnItemId / Click' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP0041_GE |  | 1 (D00-2-003) |
| WK-SCP0041-0043 | A1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-013: 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SC |  | 1 (D00-3-013) |
| WK-SCP0041-0044 | A1 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-015: 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SC |  | 1 (D00-3-015) |
| WK-SCP0041-0045 | A1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — 대조표 MODAL:ItemByDivisionModal 'AS-IS txtItemId/btnItemId Item 조회 팝업 (COM0008, des' 의 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0041-0046 | A1 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD_S |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0047 | A1 | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R10]: 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — g |  | 1 ([R10]) |
| WK-SCP0041-0048 | A1 | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R12/R13]: 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP00 |  | 1 ([R12/R13]) |
| WK-SCP0041-0049 | A1 | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R1]: 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP004 |  | 1 ([R1]) |
| WK-SCP0041-0050 | A1 | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R2]: 행 집계 — 대조표 [R2] 'FindButton 탭분기 조회' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — gold |  | 1 ([R2]) |
| WK-SCP0041-0051 | A1 | `sheet[0] shtMain "Osp Stock"` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `sheet[0] shtMain "Osp Stock"`: 행 집계 — 대조표 `sheet[0] shtMain "Osp Stock"` '`<OspStockGrid>` (조회 전용 14컬럼)' 의 A1 2요소: RE |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0052 | A1 | cboDivision (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (필수): 행 집계 — 대조표 cboDivision (필수) '`GetDivisionWithoutEE(false,"")` cs:48' 의 A1 2요소: REVIEW:1 · PASS:1 · F |  | 1 (cboDivision (필수)) |
| WK-SCP0041-0053 | A1 | cboStatus (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboStatus (Pack): 행 집계 — 대조표 cboStatus (Pack) 'PACKER_HOLD_STATUS' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041. |  | 1 (cboStatus (Pack)) |
| WK-SCP0041-0054 | A1 | clbPlantSite (Osp) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Osp): 행 집계 — 대조표 clbPlantSite (Osp) '`CommonAll(...OSP1)` cs:50 + `SaleSiteByDivision1`' 의 A1 2요소: REVIE |  | 1 (clbPlantSite (Osp)) |
| WK-SCP0041-0055 | A1 | clbPlantSite (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Pack): 행 집계 — 대조표 clbPlantSite (Pack) '`CommonAll(...PackerHoldStock1)` cs:51' 의 A1 2요소: REVIEW:1 · PASS |  | 1 (clbPlantSite (Pack)) |
| WK-SCP0041-0056 | A1 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendar (필수): 행 집계 — 대조표 dCalendar (필수) '기간' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0057 | A1 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SC |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0058 | A1 | txtInspection (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtInspection (Pack): 행 집계 — 대조표 txtInspection (Pack) '텍스트' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P_SCP00 |  | 1 (txtInspection (Pack)) |
| WK-SCP0041-0059 | A1 | txtItemId + btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId: 행 집계 — 대조표 txtItemId + btnItemId 'Item 팝업' 의 A1 2요소: REVIEW:1 · PASS:1 · FAIL 요소: PKG_SCP0041.P |  | 1 (txtItemId + btnItemId) |
| WK-SCP0041-0060 | X-LOC | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R10]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R10]) |
| WK-SCP0041-0061 | X-LOC | [R11] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R11]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R11]) |
| WK-SCP0041-0062 | X-LOC | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R12/R13]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R12/R13]) |
| WK-SCP0041-0063 | X-LOC | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R1]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R1]) |
| WK-SCP0041-0064 | X-LOC | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R2]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R2]) |
| WK-SCP0041-0065 | X-LOC | [R3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R3]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R3]) |
| WK-SCP0041-0066 | X-LOC | [R4] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R4]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R4]) |
| WK-SCP0041-0067 | X-LOC | [R5] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R5]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R5]) |
| WK-SCP0041-0068 | X-LOC | [R6] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R6]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R6]) |
| WK-SCP0041-0069 | X-LOC | [R7] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R7]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R7]) |
| WK-SCP0041-0070 | X-LOC | [R8] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R8]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R8]) |
| WK-SCP0041-0071 | X-LOC | [R9] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R9]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R9]) |
| WK-SCP0041-0072 | X-ROW | SCP0041_StockOSP.SpdMain_SheetTabClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SpdMain_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0041_StockOSP.SpdMain_SheetTabCli) |
| WK-SCP0041-0073 | M4 | btnExcel | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnExcel: 검증 엔진이 실행됐으나 이 대상(BTN btnExcel)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0074 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0075 | M4 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname / Nic: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인  |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W9 도구 오류 (113)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0076 | J2 | SCP0041 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-96780ea0 RULE_SCREEN / 원장 V-91d40c8c DEFECT / 원장 V-c1a664dd GENERAL / 원장 V-5dc74136 GENERAL / 원장 V-6efd63c3 GENERA |  | 47 (D00-1-008 D00-2-001 D00-2-003 D00-2-006 ) |
| WK-SCP0041-0077 | C2 | D00-2-006 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 C2 2요소: ERROR:2 |  | 1 (D00-2-006) |
| WK-SCP0041-0078 | C2 | D00-4d-006 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d ActiveSheet_CellChanged / (검증)' 의 C2 2요소: ERROR:2 |  | 1 (D00-4d-006) |
| WK-SCP0041-0079 | C2 | DATE_FORECAST_FINISH / 예상 완료일 | 하네스·환경 | C2 도구 오류 — 실측[T-6263579b]: DATE_FORECAST_FINISH 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업  |  | 7 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0080 | C2 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | C2 도구 오류 — 실측[T-438de9e7]: DATE_FORECAST_START 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원 |  | 19 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0081 | C2 | SCP0041_StockOSP.ActiveSheet_CellChanged | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.ActiveSheet_CellChanged 의 C2 2요소: ERROR:2 |  | 3 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0082 | C2 | SCP0041_StockOSP.CboDivision_SelectedInd | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.CboDivision_SelectedIndexChanged 의 C2 2요소: ERROR:2 |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0083 | C3 | D00-2-006 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 C3 5요소: ERROR:5 |  | 1 (D00-2-006) |
| WK-SCP0041-0084 | C3 | D00-4d-006 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d ActiveSheet_CellChanged / (검증)' 의 C3 5요소: ERROR:5 |  | 1 (D00-4d-006) |
| WK-SCP0041-0085 | C3 | DATE_FORECAST_FINISH / 예상 완료일 | 하네스·환경 | C3 도구 오류 — 원장 V-ec062c3c ASIS / 실측[T-95829f1b]: DATE_FORECAST_FINISH 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 8 (D00-3-018 ACT:SCP0041_StockOSP.ActiveShe) |
| WK-SCP0041-0086 | C3 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | C3 도구 오류 — 원장 V-3ef75a17 ASIS / 원장 V-ec062c3c ASIS / 실측[T-deb39169]: DATE_FORECAST_START 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검 |  | 20 (D00-3-017 ACT:SCP0041_StockOSP.ActiveShe) |
| WK-SCP0041-0087 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 실측[T-946ef2f2]: DIVISION_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0041_StockOSP.SetChangedControl A) |
| WK-SCP0041-0088 | C3 | SCP0041_StockOSP.ActiveSheet_CellChanged | 하네스·환경 | C3 도구 오류 — 원장 V-3ef75a17 ASIS / 원장 V-ec062c3c ASIS |  | 3 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0089 | C3 | SCP0041_StockOSP.CboDivision_SelectedInd | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.CboDivision_SelectedIndexChanged 의 C3 5요소: ERROR:5 |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0090 | C3 | SCP0041_StockOSP.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.SetChangedControl 의 C3 1요소: ERROR:1 |  | 5 (ACT:SCP0041_StockOSP.SetChangedControl:5) |
| WK-SCP0041-0091 | C3 | SCP0041_StockOSP.SetSelectMenu | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.SetSelectMenu 의 C3 5요소: ERROR:5 |  | 2 (ACT:SCP0041_StockOSP.SetSelectMenu:600:3) |
| WK-SCP0041-0092 | C3 | SCP0041_StockOSP.SetSpreadInit | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.SetSpreadInit 의 C3 5요소: ERROR:5 |  | 7 (ACT:SCP0041_StockOSP.SetSpreadInit:201:1) |
| WK-SCP0041-0093 | C3 | SCP0041_StockOSP.SetTabIndex | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.SetTabIndex 의 C3 5요소: ERROR:5 |  | 1 (ACT:SCP0041_StockOSP.SetTabIndex:516:1) |
| WK-SCP0041-0094 | C3 | SCP0041_StockOSP.setPeriod | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.setPeriod 의 C3 5요소: ERROR:5 |  | 15 (ACT:SCP0041_StockOSP.setPeriod:540:1 ACT) |
| WK-SCP0041-0095 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-3ef75a17 |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0096 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-ec062c3c |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0097 | C6 | D00-2-006 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 C6 4요소: ERROR:4 |  | 1 (D00-2-006) |
| WK-SCP0041-0098 | C6 | D00-4d-006 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-006 '§4d ActiveSheet_CellChanged / (검증)' 의 C6 4요소: ERROR:4 |  | 1 (D00-4d-006) |
| WK-SCP0041-0099 | C6 | DATE_FORECAST_FINISH / 예상 완료일 | 하네스·환경 | C6 도구 오류 — 원장 V-76b3910a ASIS |  | 7 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0100 | C6 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | C6 도구 오류 — 원장 V-b38f6029 ASIS / 원장 V-76b3910a ASIS |  | 19 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0101 | C6 | SCP0041_StockOSP.ActiveSheet_CellChanged | 하네스·환경 | C6 도구 오류 — 원장 V-b38f6029 ASIS / 원장 V-76b3910a ASIS |  | 3 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0102 | C6 | SCP0041_StockOSP.CboDivision_SelectedInd | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.CboDivision_SelectedIndexChanged 의 C6 4요소: ERROR:4 |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0103 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-b38f6029 |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0104 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-76b3910a |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0105 | B1 | cboStatus / Status | 하네스·환경 | B1 도구 오류 — 원장 V-42b19fc5 SEARCH |  | 1 (D00-1-018) |
| WK-SCP0041-0106 | B1 | clbPlantSite / Plant Site | 하네스·환경 | B1 도구 오류 — 원장 V-da32d38c SEARCH |  | 1 (D00-1-004) |
| WK-SCP0041-0107 | B2 | cboStatus / Status | 하네스·환경 | B2 도구 오류 — 원장 V-fb4dc8d9 SEARCH |  | 1 (D00-1-018) |
| WK-SCP0041-0108 | B2 | clbPlantSite / Plant Site | 하네스·환경 | B2 도구 오류 — 원장 V-9d579035 SEARCH |  | 1 (D00-1-004) |
| WK-SCP0041-0109 | B3 | D00-4b-002 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-002 '§4b Data.Common / PlantSiteByDivisionOSP / dtPlant' 의 B3 3요소: PASS:1 · NA:1 · ERROR:1 |  | 1 (D00-4b-002) |
| WK-SCP0041-0110 | B3 | D00-4b-003 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 D00-4b-003 '§4b Data.Common / SaleSiteByDivision / dtSalesSite' 의 B3 3요소: PASS:1 · NA:1 · ERROR:1 |  | 1 (D00-4b-003) |
| WK-SCP0041-0111 | B3 | SCP0041_StockOSP.GetDayRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.GetDayRange 의 B3 3요소: PASS:1 · NA:1 · ERROR:1 |  | 12 (ACT:SCP0041_StockOSP.GetDayRange:571:1 A) |
| WK-SCP0041-0112 | B3 | SCP0041_StockOSP.GetLookupData | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.GetLookupData 의 B3 3요소: PASS:1 · NA:1 · ERROR:1 |  | 3 (ACT:SCP0041_StockOSP.GetLookupData:161:1) |
| WK-SCP0041-0113 | B3 | cboStatus / Status | 하네스·환경 | B3 도구 오류 — 원장 V-b347447e SEARCH |  | 1 (cboStatus (Pack)) |
| WK-SCP0041-0114 | B4 | D00-4b-002 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-002 '§4b Data.Common / PlantSiteByDivisionOSP / dtPlant' 의 B4 4요소: ERROR:2 · PASS:1 · NA:1 |  | 1 (D00-4b-002) |
| WK-SCP0041-0115 | B4 | D00-4b-003 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4b-003 '§4b Data.Common / SaleSiteByDivision / dtSalesSite' 의 B4 4요소: ERROR:2 · PASS:1 · NA:1 |  | 1 (D00-4b-003) |
| WK-SCP0041-0116 | B4 | SCP0041_StockOSP.GetDayRange | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.GetDayRange 의 B4 4요소: ERROR:2 · PASS:1 · NA:1 |  | 12 (ACT:SCP0041_StockOSP.GetDayRange:571:1 A) |
| WK-SCP0041-0117 | B4 | SCP0041_StockOSP.GetLookupData | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.GetLookupData 의 B4 4요소: ERROR:2 · PASS:1 · NA:1 |  | 3 (ACT:SCP0041_StockOSP.GetLookupData:161:1) |
| WK-SCP0041-0118 | B4 | cboStatus / Status | 하네스·환경 | B4 도구 오류 — 원장 V-60514544 SEARCH |  | 2 (D00-1-018 cboStatus (Pack)) |
| WK-SCP0041-0119 | B4 | clbPlantSite / Plant Site | 하네스·환경 | B4 도구 오류 — 원장 V-9accdaca SEARCH |  | 1 (D00-1-004) |
| WK-SCP0041-0120 | B6 | cboStatus / Status | 하네스·환경 | B6 도구 오류 — 원장 V-9e37a6e8 SEARCH |  | 1 (D00-1-018) |
| WK-SCP0041-0121 | B6 | clbPlantSite / Plant Site | 하네스·환경 | B6 도구 오류 — 원장 V-500401fe SEARCH |  | 1 (D00-1-004) |
| WK-SCP0041-0122 | K4 | SCP0041 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-3b2f9a5e GENERAL / 원장 V-9c9c471c GENERAL / 원장 V-9785cca0 GENERAL / 원장 V-02af727c GENERAL / 원장 V-76bf79e8 GENERAL / |  | 21 (COMMON:UC-04 COMMON:UC-06 ACT:SCP0041_St) |
| WK-SCP0041-0123 | F1 | SCP0041 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-0b5a869f RULE_SCREEN / 원장 V-8f681535 RULE_SCREEN / 원장 V-eff0720f RULE_SCREEN / 원장 V-bbf60923 RULE_SCREEN / 원장 V-7b |  | 131 (D00-4d-007 [R3] [R5] ACT:SCP0041_StockOS) |
| WK-SCP0041-0124 | F2 | SCP0041 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-ea812103 RULE_SCREEN / 원장 V-ba0a54c1 RULE_SCREEN / 원장 V-48b38c31 GENERAL / 원장 V-3f08a3fb GENERAL / 원장 V-4e41abd6 G |  | 130 (D00-4d-007 [R3] ACT:SCP0041_StockOSP.Sav) |
| WK-SCP0041-0125 | F6 | SCP0041 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-43fed03c RULE_SCREEN / 원장 V-ec183f5d RULE_SCREEN / 원장 V-51868439 RULE_SCREEN / 원장 V-be579f78 RULE_SCREEN / 원장 V-ab |  | 129 ([R3] ACT:SCP0041_StockOSP.SaveButton ACT) |
| WK-SCP0041-0126 | F4 | D00-3-013 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 F4 5요소: NA:3 · ERROR:1 · PASS:1 |  | 1 (D00-3-013) |
| WK-SCP0041-0127 | F4 | D00-3-015 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 F4 5요소: NA:3 · ERROR:1 · PASS:1 |  | 1 (D00-3-015) |
| WK-SCP0041-0128 | F4 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | 하네스·환경 | F4 도구 오류 — 실측[T-6d061dde]: PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: SCP0041/Pack Hold Stock/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조 |  | 142 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0129 | F4 | [R3] | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 [R3] 'SaveButton Pack 탭만 SaveDataPacker' 의 F4 5요소: NA:3 · ERROR:1 · PASS:1 |  | 1 ([R3]) |
| WK-SCP0041-0130 | H10 | SCP0041 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 2 (COMMON:UC-04 COMMON:UC-06) |
| WK-SCP0041-0131 | I1 | SCP0041 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-ece54378 RULE_SCREEN / 원장 V-13c629dd RULE_SCREEN / 원장 V-3385ba4d RULE_SCREEN / 원장 V-9ed492ea DEFECT / 원장 V-c37843b |  | 10 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0132 | D1 | D00-2-006 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 (D00-2-006) |
| WK-SCP0041-0133 | D1 | D00-3-004 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-004 '§3 LockRange / (전체셀 잠금 iRowStart..iColEnd, true)' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 (D00-3-004) |
| WK-SCP0041-0134 | D1 | D00-3-008 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-008 '§3 LockRange / (iRow, iCol_QTY, true) — 非HOLD 행 잠금' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 (D00-3-008) |
| WK-SCP0041-0135 | D1 | QTY / 수량 | 하네스·환경 | D1 도구 오류 — 원장 V-4772525d COLUMN / 원장 V-4ec909d8 COLUMN / 원장 V-fdbbc387 COLUMN / 실측[T-6033f854]: 기존행 r0 QTY 편집=false — AS-IS 조건부(행  |  | 4 (D00-3-005 [R11] ACT:SCP0041_StockOSP.Edi) |
| WK-SCP0041-0136 | D1 | SCP0041_StockOSP.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SCP0041_StockOSP.EditButton 의 D1 4요소: PASS:3 · ERROR:1 |  | 13 (ACT:SCP0041_StockOSP.EditButton:259:1 AC) |
| WK-SCP0041-0137 | D1 | [R10] | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 ([R10]) |
| WK-SCP0041-0138 | D1 | [R12/R13] | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 ([R12/R13]) |
| WK-SCP0041-0139 | D1 | [R1] | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 ([R1]) |
| WK-SCP0041-0140 | D1 | [R6] | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 [R6] 'EditButton 모드토글' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 ([R6]) |
| WK-SCP0041-0141 | D1 | `sheet[1] shtPacker "Pack Hold Stock"` | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `sheet[1] shtPacker "Pack Hold Stock"` '`<PackHoldStockGrid>` (15컬럼, HOLD행 편집)' 의 D1 4요소: PASS:3 · ERROR:1 |  | 1 (`sheet[1] shtPacker "Pack Hold Stock"`) |
| WK-SCP0041-0142 | D3 | DATE_FORECAST_FINISH / 예상 완료일 | 하네스·환경 | D3 도구 오류 — 실측[T-0895b158]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (iFocusTabIndex == 1) / if (fps.Name.Equals(spdMain.Nam |  | 5 (D00-3-007 D00-3-010 D00-3-018 ACT:SCP004) |
| WK-SCP0041-0143 | D3 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | D3 도구 오류 — 실측[T-e17cb897]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (iFocusTabIndex == 1) / if (fps.Name.Equals(spdMain.Nam |  | 5 (D00-3-006 D00-3-009 [R11] ACT:SCP0041_St) |
| WK-SCP0041-0144 | D3 | DIR / Status | 하네스·환경 | D3 도구 오류 — 실측[T-661cfc87]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (iFocusTabIndex == 1) / if (fps.Name.Equals(spdMain.Nam |  | 3 (ACT:SCP0041_StockOSP.EditButton ACT:SCP0) |
| WK-SCP0041-0145 | D3 | QTY / 수량 | 하네스·환경 | D3 도구 오류 — 실측[T-2a35e5e9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (iFocusTabIndex == 1) / if (fps.Name.Equals(spdMain.Nam |  | 4 (D00-3-005 [R11] ACT:SCP0041_StockOSP.Edi) |
| WK-SCP0041-0146 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e629fc2b / 실측[T-c8d1a38c]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SCP0041_StockOSP.FindData_Main:682:3) |
| WK-SCP0041-0147 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-801f3bf2 / 실측[T-a3e4628d]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SCP0041_StockOSP.FindData_Pack:765:4) |
| WK-SCP0041-0148 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6311f9fe |  | 1 (ACT:SCP0041_StockOSP.EditButton:281:15) |
| WK-SCP0041-0149 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-f21dd8c5 |  | 1 (ACT:SCP0041_StockOSP.EditButton:269:6) |
| WK-SCP0041-0150 | D4 | DATE_FORECAST_FINISH / 예상 완료일 | 하네스·환경 | D4 도구 오류 — 실측[T-c66055ab]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-018) |
| WK-SCP0041-0151 | D4 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | D4 도구 오류 — 실측[T-3772a577]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (D00-3-017) |
| WK-SCP0041-0152 | D4 | [R4] | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 [R4] 'InsertButton NO-OP `{ }`' 의 D4 2요소: ERROR:2 |  | 1 ([R4]) |
| WK-SCP0041-0153 | E4 | DATE_FORECAST_START / 예상 시작일 | 하네스·환경 | E4 도구 오류 — 원장 V-6e4cb1a9 ASIS / 실측[T-9f028f9c]: DATE_FORECAST_START: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0154 | E4 | MSG00108 | 하네스·환경 | E4 도구 오류 — 원장 V-6e4cb1a9 / 실측[T-b409f0b8]: MSG00108 — ActiveSheet_CellChanged 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(A |  | 1 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0155 | E4 | MSG00108 | 하네스·환경 | E4 도구 오류 — 원장 V-6e4cb1a9 ASIS / 원장 V-5d212d92 ASIS / 실측[T-221e8255]: MSG00108 — ActiveSheet_CellChanged 경로 메시지(저장 전 검증 아님 · Save 진 |  | 2 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0156 | E4 | MSG00108 | 하네스·환경 | E4 도구 오류 — 원장 V-5d212d92 / 실측[T-50cc9349]: MSG00108 — ActiveSheet_CellChanged 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(A |  | 1 (ACT:SCP0041_StockOSP.SaveDataPacker:463:) |
| WK-SCP0041-0157 | A6 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | 하네스·환경 | A6 도구 오류 — 원장 V-960823ee SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-f527876e]: PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: 화면 진입·조회 경로에서 이 SP |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0158 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0159 | G1 | D00-1-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-008 '§1 btnItemId / UsrButton' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (D00-1-008) |
| WK-SCP0041-0160 | G1 | D00-1-024 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-024 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (D00-1-024) |
| WK-SCP0041-0161 | G1 | D00-1-025 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-025 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (D00-1-025) |
| WK-SCP0041-0162 | G1 | D00-2-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-001 '§2 ActiveSheet / CellChanged' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (D00-2-001) |
| WK-SCP0041-0163 | G1 | D00-2-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 btnItemId / Click' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (D00-2-003) |
| WK-SCP0041-0164 | G1 | [R10] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 ([R10]) |
| WK-SCP0041-0165 | G1 | [R12/R13] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 ([R12/R13]) |
| WK-SCP0041-0166 | G1 | [R1] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 ([R1]) |
| WK-SCP0041-0167 | G1 | [R2] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R2] 'FindButton 탭분기 조회' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 ([R2]) |
| WK-SCP0041-0168 | G1 | `sheet[0] shtMain "Osp Stock"` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `sheet[0] shtMain "Osp Stock"` '`<OspStockGrid>` (조회 전용 14컬럼)' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0169 | G1 | cboStatus / Status | 하네스·환경 | G1 도구 오류 — 원장 V-74ccd764 SEARCH / E2E smoke cond CustomDropdown |  | 4 (D00-1-018 cboStatus (Pack) ACT:SCP0041_S) |
| WK-SCP0041-0170 | G1 | dCalendar (필수) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 dCalendar (필수) '기간' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0171 | G1 | dCalendarCutoff (Pack) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 G1 7요소: NA:4 · PASS:2 · ERROR:1 |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0172 | X-ROW | SCP0041_StockOSP.ActiveSheet_CellChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:17 · NA:1 |  | 3 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0173 | X-ROW | SCP0041_StockOSP.BtnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NA:2 |  | 5 (ACT:SCP0041_StockOSP.BtnItemId_Click:872) |
| WK-SCP0041-0174 | X-ROW | SCP0041_StockOSP.CboDivision_SelectedInd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0175 | X-ROW | SCP0041_StockOSP.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CreateSpread) |
| WK-SCP0041-0176 | X-ROW | SCP0041_StockOSP.FindData_Pack | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:5 · NA:4 · PASS:4 · REVIEW:1 |  | 7 (ACT:SCP0041_StockOSP.FindData_Pack:704:1) |
| WK-SCP0041-0177 | X-ROW | SCP0041_StockOSP.SaveDataPacker | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:7 · NA:5 · PASS:3 |  | 5 (ACT:SCP0041_StockOSP.SaveDataPacker:449:) |
| WK-SCP0041-0178 | X-ROW | SCP0041_StockOSP.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:4 · ERROR:2 · PASS:1 |  | 1 (ACT:SCP0041_StockOSP.SetChangedControl:5) |
| WK-SCP0041-0179 | X-ROW | SCP0041_StockOSP.SetSelectMenu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0041_StockOSP.SetSelectMenu ACT:S) |
| WK-SCP0041-0180 | X-ROW | SCP0041_StockOSP.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:5 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetSpreadInit) |
| WK-SCP0041-0181 | X-ROW | SCP0041_StockOSP.SetTabIndex | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetTabIndex) |
| WK-SCP0041-0182 | X-ROW | SCP0041_StockOSP.btnExcelUpload_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 4 (ACT:SCP0041_StockOSP.btnExcelUpload_Clic) |
| WK-SCP0041-0183 | X-ROW | SCP0041_StockOSP.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.setPeriod ACT:SCP00) |
| WK-SCP0041-0184 | G5 | btnExcel | 하네스·환경 | G5 도구 오류 — 원장 V-b7524b16 ASIS |  | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0185 | G5 | frm.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-b7524b16 |  | 1 (ACT:SCP0041_StockOSP.btnExcelUpload_Clic) |
| WK-SCP0041-0186 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스·환경 | G5 도구 오류 — 원장 V-485f1c37 SEARCH |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0187 | H6 | btnExcel | 하네스·환경 | H6 도구 오류 — 원장 V-11bb57e5 ASIS |  | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0188 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-11bb57e5 |  | 1 (ACT:SCP0041_StockOSP.btnExcelUpload_Clic) |
