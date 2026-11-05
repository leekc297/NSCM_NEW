# 작업 원장 — SCP0041 · 2026-10-30 08:16

> 검사 인스턴스 417건 중 PASS·NA 293건 외 **124건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 12 | 재판정 PASS |
| W5 | 검사기 연결 | 11 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 5 | 실행 → PASS |
| W7 | 기대값 확정 | 46 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 50 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 50 · 사람 판정 / AS-IS 원문 확인 → 재판정 38 · 하네스 11 · DB 객체 8 · 대조표 8 · E2E 5 · 화면 FE 4
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  |  |  |  |  |  |  | 26 | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 22 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-ROW | GEN |  |  | 4 |  |  |  | 1 |  | 10 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  |  |  |  | 14 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-LOC | GEN |  |  |  |  |  |  | 12 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REASON | DESIGN |  |  |  |  |  |  | 8 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F4 | DB |  |  | 4 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  | 4 |  |  |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  | 1 | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| M4 | POPUP |  |  |  |  |  |  | 3 |  |  | 팝업 선택값 반영 |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| H6 | POPUP |  |  |  |  | 1 | 1 |  |  |  | 팝업 표준·열림 |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| B3 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B6 | COMBO |  |  |  |  | 1 |  |  |  |  | ALL 옵션·다중선택 사양 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |

## W3 동작 수정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0001 | F4 | D00-3-013 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — D00-3-013: 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 F4 5요소: NA:3 · PASS:1 · FAIL:1 · FAIL 요소:  |  | 1 (D00-3-013) |
| WK-SCP0041-0002 | F4 | D00-3-015 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — D00-3-015: 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 F4 5요소: NA:3 · PASS:1 · FAIL:1 · FAIL 요소:  |  | 1 (D00-3-015) |
| WK-SCP0041-0003 | F4 | SCP0040_SAVE_CHARACTERISTIC_CAPA | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0040_SAVE_CHARACTERISTIC_CAPA: 실측[T-18becd50]: SCP0040_SAVE_CHARACTERISTIC_CAPA: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-B |  | 37 (ACT:SCP0041_StockOSP.SaveData ACT:SCP004) |
| WK-SCP0041-0004 | F4 | [R3] | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — [R3]: 행 집계 — 대조표 [R3] 'SaveButton Pack 탭만 SaveDataPacker' 의 F4 5요소: NA:3 · PASS:1 · FAIL:1 · FAIL 요소: SCP0040_SAVE_CH |  | 1 ([R3]) |
| WK-SCP0041-0005 | A6 | D00-3-013 | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — D00-3-013: 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SCP0041.P_SC |  | 1 (D00-3-013) |
| WK-SCP0041-0006 | A6 | D00-3-015 | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — D00-3-015: 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A6 2요소: FAIL:2 · FAIL 요소: PKG_SCP0041.P_SC |  | 1 (D00-3-015) |
| WK-SCP0041-0007 | A6 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: 원장 V-960823ee SP / 정렬대조 FAIL 2번째 키부터 다름: AS-IS ['CUTOFF_DATE', 'DIR', 'PLA |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0008 | A6 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP: 원장 V-04df217d SP / 정렬대조 FAIL 2번째 키부터 다름: AS-IS ['SCM_SITE_ID', 'ITEM_ID'] ↔ TO-  |  | 44 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0009 | X-ROW | SCP0041_StockOSP.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0041_StockOSP.FindButton: 진입점 집계 6검사 — REVIEW:2 · FAIL:2 · NA:1 · PASS:1 (FX-SCP0041-034) |  | 1 (ACT:SCP0041_StockOSP.FindButton) |
| WK-SCP0041-0010 | X-ROW | SCP0041_StockOSP.FindData_Main | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0041_StockOSP.FindData_Main: 진입점 집계 12검사 — PASS:5 · NA:3 · ERROR:2 · REVIEW:1 · FAIL:1 (FX-SCP0041-037) |  | 7 (ACT:SCP0041_StockOSP.FindData_Main:631:1) |
| WK-SCP0041-0011 | X-ROW | SCP0041_StockOSP.FindData_Pack | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0041_StockOSP.FindData_Pack: 진입점 집계 14검사 — NA:6 · PASS:4 · ERROR:2 · REVIEW:1 · FAIL:1 (FX-SCP0041-038) |  | 7 (ACT:SCP0041_StockOSP.FindData_Pack:704:1) |
| WK-SCP0041-0012 | X-ROW | SCP0041_StockOSP.SaveData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0041_StockOSP.SaveData: 진입점 집계 11검사 — NA:5 · PASS:4 · FAIL:1 · NOPATH:1 (FX-SCP0041-040) |  | 1 (ACT:SCP0041_StockOSP.SaveData:356:22) |

## W5 검사기 연결 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0013 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0014 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0015 | B3 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision (필수)) |
| WK-SCP0041-0016 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (D00-1-002 cboDivision (필수)) |
| WK-SCP0041-0017 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0018 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0041_StockOSP.GetLookupData:165:3) |
| WK-SCP0041-0019 | DB-SYN | SCP0040_SAVE_CHARACTERISTIC_CAPA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0040_SAVE_CHARACTERISTIC_CAPA | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0041_StockOSP.SaveData:354:20 ACT) |
| WK-SCP0041-0020 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (txtItemId + btnItemId ACT:SCP0041_StockO) |
| WK-SCP0041-0021 | G03-WIRE | SCP0041 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0041 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCP0041_StockOSP..ctor ACT:SCP0041_S) |
| WK-SCP0041-0022 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0023 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W6 검증 실행 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0024 | K-SA | SCP0041 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0041 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (D00-1-024 `usrConditionPanel1` (조건 패널)) |
| WK-SCP0041-0025 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (D00-1-002 cboDivision (필수) ACT:SCP0041_S) |
| WK-SCP0041-0026 | G4 | txtInspection / DefPackLabel.INSEPECTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtInspection / DefPackLabel.INSEPECTION_ID / Insp · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (D00-1-016 txtInspection (Pack)) |
| WK-SCP0041-0027 | SC1 | SCP0041 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0041 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 16 (D00-1-002 D00-1-004 D00-1-006 D00-1-016 ) |
| WK-SCP0041-0028 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W7 기대값 확정 (46)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0029 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRowVisibleUnderFilter) — INSERT 버튼 DB 미등록(hasButto |  | 1 (COMMON:UC-01) |
| WK-SCP0041-0030 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) — AS-IS SCP0041_StockOS |  | 1 (COMMON:UC-02) |
| WK-SCP0041-0031 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) 공용 SubTitle excelFileName 위 |  | 1 (COMMON:UC-05) |
| WK-SCP0041-0032 | X-REASON | COMMON:UC-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-07 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 (rebindFilterColumns) 공용 DataGrid gridFilterRef 위임 필터 유지·rebind  |  | 1 (COMMON:UC-07) |
| WK-SCP0041-0033 | X-REASON | D00-1-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-028 §1 components / Container — Designer IContainer(컴포넌트 트레이) — 런타임 UI 아님, React 대응 없음 해당없음 |  | 1 (D00-1-028) |
| WK-SCP0041-0034 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 — AS-IS 조회모드 전열잠금 = EditButton 모드토글의 일부(R12 |  | 1 (D00-3-014) |
| WK-SCP0041-0035 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 §4b Data.CallBizCommonData / PERIOD_DEFAULT / dt — AS-IS 기간 기본값(PERIOD_DEFAULT) 프리셋 — TO-BE PeriodFi |  | 1 (D00-4b-005) |
| WK-SCP0041-0036 | X-REASON | MODAL:FPModal | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:FPModal AS-IS 화면에 별도 FPModal(범용 조회 팝업) 사용 없음 — Model 조회는 ItemByDivisionModal(COM0008) 단일 — AS-IS SCP0041_ |  | 1 (MODAL:FPModal) |
| WK-SCP0041-0037 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_ |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0038 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — 대조표 D00-1-008 '§1 btnItemId / UsrButton' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PAC |  | 1 (D00-1-008) |
| WK-SCP0041-0039 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — 대조표 D00-2-001 '§2 ActiveSheet / CellChanged' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET |  | 1 (D00-2-001) |
| WK-SCP0041-0040 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — 대조표 D00-2-003 '§2 btnItemId / Click' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK —  |  | 1 (D00-2-003) |
| WK-SCP0041-0041 | A1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-013: 행 집계 — 대조표 D00-3-013 '§3 Query / (ds) — FindData_Main 결과 바인딩' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_S |  | 1 (D00-3-013) |
| WK-SCP0041-0042 | A1 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-015: 행 집계 — 대조표 D00-3-015 '§3 Query / (ds) — FindData_Pack 결과 바인딩' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_S |  | 1 (D00-3-015) |
| WK-SCP0041-0043 | A1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — 대조표 MODAL:ItemByDivisionModal 'AS-IS txtItemId/btnItemId Item 조회 팝업 (COM0008, des' 의 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0041-0044 | A1 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_PACK_HOLD |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0045 | A1 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0041/SCP0041_GET_STOCK_OSP.md —  |  | 44 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0046 | A1 | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R10]: 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKI |  | 1 ([R10]) |
| WK-SCP0041-0047 | A1 | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R12/R13]: 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PA |  | 1 ([R12/R13]) |
| WK-SCP0041-0048 | A1 | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R1]: 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP00 |  | 1 ([R1]) |
| WK-SCP0041-0049 | A1 | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R2]: 행 집계 — 대조표 [R2] 'FindButton 탭분기 조회' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden SKIP A |  | 1 ([R2]) |
| WK-SCP0041-0050 | A1 | `sheet[0] shtMain "Osp Stock"` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `sheet[0] shtMain "Osp Stock"`: 행 집계 — 대조표 `sheet[0] shtMain "Osp Stock"` '`<OspStockGrid>` (조회 전용 14컬럼)' 의 A1 2요소: RE |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0051 | A1 | cboDivision (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (필수): 행 집계 — 대조표 cboDivision (필수) '`GetDivisionWithoutEE(false,"")` cs:48' 의 A1 2요소: REVIEW:2 · FAIL 요소: P |  | 1 (cboDivision (필수)) |
| WK-SCP0041-0052 | A1 | cboStatus (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboStatus (Pack): 행 집계 — 대조표 cboStatus (Pack) 'PACKER_HOLD_STATUS' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041 |  | 1 (cboStatus (Pack)) |
| WK-SCP0041-0053 | A1 | clbPlantSite (Osp) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Osp): 행 집계 — 대조표 clbPlantSite (Osp) '`CommonAll(...OSP1)` cs:50 + `SaleSiteByDivision1`' 의 A1 2요소: REVIE |  | 1 (clbPlantSite (Osp)) |
| WK-SCP0041-0054 | A1 | clbPlantSite (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Pack): 행 집계 — 대조표 clbPlantSite (Pack) '`CommonAll(...PackerHoldStock1)` cs:51' 의 A1 2요소: REVIEW:2 · FAIL |  | 1 (clbPlantSite (Pack)) |
| WK-SCP0041-0055 | A1 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendar (필수): 행 집계 — 대조표 dCalendar (필수) '기간' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PACK — golden S |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0056 | A1 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0057 | A1 | txtInspection (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtInspection (Pack): 행 집계 — 대조표 txtInspection (Pack) '텍스트' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_GET_PA |  | 1 (txtInspection (Pack)) |
| WK-SCP0041-0058 | A1 | txtItemId + btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId: 행 집계 — 대조표 txtItemId + btnItemId 'Item 팝업' 의 A1 2요소: REVIEW:2 · FAIL 요소: PKG_SCP0041.P_SCP0041_ |  | 1 (txtItemId + btnItemId) |
| WK-SCP0041-0059 | X-LOC | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R10]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R10]) |
| WK-SCP0041-0060 | X-LOC | [R11] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R11]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R11]) |
| WK-SCP0041-0061 | X-LOC | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R12/R13]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R12/R13]) |
| WK-SCP0041-0062 | X-LOC | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R1]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R1]) |
| WK-SCP0041-0063 | X-LOC | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R2]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R2]) |
| WK-SCP0041-0064 | X-LOC | [R3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R3]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R3]) |
| WK-SCP0041-0065 | X-LOC | [R4] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R4]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R4]) |
| WK-SCP0041-0066 | X-LOC | [R5] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R5]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R5]) |
| WK-SCP0041-0067 | X-LOC | [R6] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R6]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R6]) |
| WK-SCP0041-0068 | X-LOC | [R7] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R7]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R7]) |
| WK-SCP0041-0069 | X-LOC | [R8] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R8]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R8]) |
| WK-SCP0041-0070 | X-LOC | [R9] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R9]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R9]) |
| WK-SCP0041-0071 | X-ROW | SCP0041_StockOSP.SpdMain_SheetTabClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SpdMain_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0041_StockOSP.SpdMain_SheetTabCli) |
| WK-SCP0041-0072 | M4 | btnExcel | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnExcel: 검증 엔진이 실행됐으나 이 대상(BTN btnExcel)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0073 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0074 | M4 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname: 검증 엔진이 실행됐으나 이 대상(COND txtItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진  |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W9 도구 오류 (50)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0075 | D3 | D00-2-006 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-006 '§2 spdMain / EditChange' 의 D3 10요소: ERROR:10 |  | 1 (D00-2-006) |
| WK-SCP0041-0076 | D3 | D00-3-004 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-004 '§3 LockRange / (전체셀 잠금 iRowStart..iColEnd, true)' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-004) |
| WK-SCP0041-0077 | D3 | D00-3-005 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-005 '§3 LockRange / (iRow, iCol_QTY, false) — HOLD 행 편집' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-005) |
| WK-SCP0041-0078 | D3 | D00-3-006 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-006 '§3 LockRange / (iRow, DATE_FORECAST_START, false) ' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-006) |
| WK-SCP0041-0079 | D3 | D00-3-007 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-007 '§3 LockRange / (iRow, DATE_FORECAST_FINISH, false)' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-007) |
| WK-SCP0041-0080 | D3 | D00-3-008 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-008 '§3 LockRange / (iRow, iCol_QTY, true) — 非HOLD 행 잠금' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-008) |
| WK-SCP0041-0081 | D3 | D00-3-009 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-009 '§3 LockRange / (iRow, DATE_FORECAST_START, true) —' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-009) |
| WK-SCP0041-0082 | D3 | D00-3-010 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-010 '§3 LockRange / (iRow, DATE_FORECAST_FINISH, true) ' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-010) |
| WK-SCP0041-0083 | D3 | D00-3-018 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-018 '§3 SetValue / (e.Row, DATE_FORECAST_FINISH, START_' 의 D3 10요소: ERROR:10 |  | 1 (D00-3-018) |
| WK-SCP0041-0084 | D3 | SCP0041_StockOSP.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-f21dd8c5 ASIS / 원장 V-6311f9fe ASIS / 원장 V-4dc694a5 ASIS / 원장 V-b7a11e18 ASIS / 원장 V-0bd071e5 ASIS / 원장 V-61c0e8ad  |  | 18 (ACT:SCP0041_StockOSP.EditButton:259:1 AC) |
| WK-SCP0041-0085 | D3 | [R10] | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 D3 10요소: ERROR:10 |  | 1 ([R10]) |
| WK-SCP0041-0086 | D3 | [R11] | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 [R11] 'HOLD 행만 QTY/DATE_FORECAST_START/FINISH 편집' 의 D3 10요소: ERROR:10 |  | 1 ([R11]) |
| WK-SCP0041-0087 | D3 | [R12/R13] | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 D3 10요소: ERROR:10 |  | 1 ([R12/R13]) |
| WK-SCP0041-0088 | D3 | [R1] | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 D3 10요소: ERROR:10 |  | 1 ([R1]) |
| WK-SCP0041-0089 | D3 | [R6] | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 [R6] 'EditButton 모드토글' 의 D3 10요소: ERROR:10 |  | 1 ([R6]) |
| WK-SCP0041-0090 | D3 | `sheet[1] shtPacker "Pack Hold Stock"` | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 `sheet[1] shtPacker "Pack Hold Stock"` '`<PackHoldStockGrid>` (15컬럼, HOLD행 편집)' 의 D3 10요소: ERROR:10 |  | 1 (`sheet[1] shtPacker "Pack Hold Stock"`) |
| WK-SCP0041-0091 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e629fc2b |  | 1 (ACT:SCP0041_StockOSP.FindData_Main:682:3) |
| WK-SCP0041-0092 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-801f3bf2 |  | 1 (ACT:SCP0041_StockOSP.FindData_Pack:765:4) |
| WK-SCP0041-0093 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6311f9fe |  | 1 (ACT:SCP0041_StockOSP.EditButton:281:15) |
| WK-SCP0041-0094 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-4dc694a5 |  | 1 (ACT:SCP0041_StockOSP.EditButton:294:21) |
| WK-SCP0041-0095 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b7a11e18 |  | 1 (ACT:SCP0041_StockOSP.EditButton:295:22) |
| WK-SCP0041-0096 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-0bd071e5 |  | 1 (ACT:SCP0041_StockOSP.EditButton:296:23) |
| WK-SCP0041-0097 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-61c0e8ad |  | 1 (ACT:SCP0041_StockOSP.EditButton:300:24) |
| WK-SCP0041-0098 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-11f81d97 |  | 1 (ACT:SCP0041_StockOSP.EditButton:301:25) |
| WK-SCP0041-0099 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6759278b |  | 1 (ACT:SCP0041_StockOSP.EditButton:302:26) |
| WK-SCP0041-0100 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-f21dd8c5 |  | 1 (ACT:SCP0041_StockOSP.EditButton:269:6) |
| WK-SCP0041-0101 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0102 | G1 | D00-1-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-008 '§1 btnItemId / UsrButton' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (D00-1-008) |
| WK-SCP0041-0103 | G1 | D00-1-024 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-024 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (D00-1-024) |
| WK-SCP0041-0104 | G1 | D00-1-025 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-025 '§1 usrLayoutControl2 / UsrLayoutControl' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (D00-1-025) |
| WK-SCP0041-0105 | G1 | D00-2-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-001 '§2 ActiveSheet / CellChanged' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (D00-2-001) |
| WK-SCP0041-0106 | G1 | D00-2-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-003 '§2 btnItemId / Click' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (D00-2-003) |
| WK-SCP0041-0107 | G1 | [R10] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R10] '탭 전환 시 조건세트/기간 재계산' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 ([R10]) |
| WK-SCP0041-0108 | G1 | [R12/R13] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R12/R13] '조회 후 전열 LockColumn (조회모드)' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 ([R12/R13]) |
| WK-SCP0041-0109 | G1 | [R1] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R1] 'dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 ([R1]) |
| WK-SCP0041-0110 | G1 | [R2] | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 [R2] 'FindButton 탭분기 조회' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 ([R2]) |
| WK-SCP0041-0111 | G1 | `sheet[0] shtMain "Osp Stock"` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `sheet[0] shtMain "Osp Stock"` '`<OspStockGrid>` (조회 전용 14컬럼)' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0112 | G1 | clbPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-0d8620f2 SEARCH |  | 7 (D00-1-004 clbPlantSite (Osp) clbPlantSit) |
| WK-SCP0041-0113 | G1 | dCalendar (필수) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 dCalendar (필수) '기간' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0114 | G1 | dCalendarCutoff (Pack) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 dCalendarCutoff (Pack) '기간' 의 G1 7요소: NA:5 · PASS:1 · ERROR:1 |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0115 | X-ROW | SCP0041_StockOSP.ActiveSheet_CellChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NA:9 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0116 | X-ROW | SCP0041_StockOSP.CboDivision_SelectedInd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0117 | X-ROW | SCP0041_StockOSP.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CreateSpread) |
| WK-SCP0041-0118 | X-ROW | SCP0041_StockOSP.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:9 · NOT_RUN:1 |  | 1 (ACT:SCP0041_StockOSP.EditButton) |
| WK-SCP0041-0119 | X-ROW | SCP0041_StockOSP.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:4 · NA:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0041_StockOSP.InitControls:143:3 ) |
| WK-SCP0041-0120 | X-ROW | SCP0041_StockOSP.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.SetChangedControl A) |
| WK-SCP0041-0121 | X-ROW | SCP0041_StockOSP.SetSelectMenu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0041_StockOSP.SetSelectMenu ACT:S) |
| WK-SCP0041-0122 | X-ROW | SCP0041_StockOSP.SetSpreadInit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · NA:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetSpreadInit) |
| WK-SCP0041-0123 | X-ROW | SCP0041_StockOSP.SetTabIndex | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetTabIndex) |
| WK-SCP0041-0124 | X-ROW | SCP0041_StockOSP.setPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.setPeriod ACT:SCP00) |
