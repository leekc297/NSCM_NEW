# 작업 원장 — SSP0201 · 2026-10-26 13:00

> 검사 인스턴스 833건 중 PASS·NA 31건 외 **802건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 39 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 13 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 67 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 367 | 실행 → PASS |
| W7 | 기대값 확정 | 315 | 기대 확정 → PASS/FAIL |

- 담당: E2E 367 · 사람 판정 / AS-IS 원문 확인 → 재판정 309 · 하네스 80 · 대조표 45 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 39 |  |  |  |  | 49 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 72 | 14 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 69 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 36 | 12 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 23 | 13 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 24 | 11 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 24 | 10 |  |  | 라벨 명칭 |
| D1 | EDIT |  |  |  |  |  | 22 | 10 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 22 | 10 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 27 | 2 |  |  | 셀 에디터 유형 |
| G1 | GEN |  |  |  |  |  | 11 | 17 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 7 | 9 | 11 |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 18 |  | 7 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A1 | GEN |  |  |  |  |  |  | 24 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  | 19 | 4 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 19 | 4 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G6 | GEN |  |  |  |  |  | 9 | 11 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 13 |  |  | 6 |  |  | 콤보 후보 정렬 = AS-IS |
| F4 | DB |  |  |  |  |  | 13 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B1 | COMBO |  |  |  |  | 11 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 11 |  | 1 |  |  | 콤보 후보 중복 없음 |
| H3 | DESIGN |  |  |  |  |  | 1 | 9 |  |  | 셀 병합 = AS-IS |
| M4 | POPUP |  |  |  |  |  | 6 | 2 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 5 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 |  | 2 |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 5 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D4 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| A6 | GEN |  |  |  |  |  | 6 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E5 | EDIT |  |  |  |  | 4 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| E1 | EDIT |  |  |  |  |  | 5 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
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

## W2 구현 위치 확인 (39)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0001 | X-LOC | From/To Site 선행필수(MSG00098) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (From/To Site 선행필수(MSG00098)) |
| WK-SSP0201-0002 | X-LOC | REASON_CODE 없이 DETAIL (MSG00287) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REASON_CODE 없이 DETAIL (MSG00287)) |
| WK-SSP0201-0003 | X-LOC | SHIPMENT_STATUS=='R' (MSG00174 요청완료) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SHIPMENT_STATUS=='R' (MSG00174 요청완료)) |
| WK-SSP0201-0004 | X-LOC | SSP0201 sub | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (SSP0201 sub) |
| WK-SSP0201-0005 | X-LOC | SaveButton !IsLock (편집모드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton !IsLock (편집모드)) |
| WK-SSP0201-0006 | X-LOC | Validation_Check() 본문(Qty/Date/Mode→Chan | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Validation_Check() 본문(Qty/Date/Mode→Chan) |
| WK-SSP0201-0007 | X-LOC | bolChang_Flag==false (MSG00133 수정없음) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (bolChang_Flag==false (MSG00133 수정없음)) |
| WK-SSP0201-0008 | X-LOC | btnAdd/btnDel/btnSave/dtDate/btnChangeRe | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnAdd/btnDel/btnSave/dtDate/btnChangeRe) |
| WK-SSP0201-0009 | X-LOC | btnApprovalUser (승인자검색 R7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnApprovalUser (승인자검색 R7)) |
| WK-SSP0201-0010 | X-LOC | btnNew(R10)/btnCancel(R9)/btnChangeRe2(R | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnNew(R10)/btnCancel(R9)/btnChangeRe2(R) |
| WK-SSP0201-0011 | X-LOC | cboChangeType (Plan Type, 기본 C) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboChangeType (Plan Type, 기본 C)) |
| WK-SSP0201-0012 | X-LOC | cboStatus (Status, P제외+ALL선두) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboStatus (Status, P제외+ALL선두)) |
| WK-SSP0201-0013 | X-LOC | cellType (19) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cellType (19)) |
| WK-SSP0201-0014 | X-LOC | checkRequired 4항목(승인자/제목/변경사유/사유상세) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequired 4항목(승인자/제목/변경사유/사유상세)) |
| WK-SSP0201-0015 | X-LOC | checkRequiredOfSpread(siMain) 메타 필수 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSpread(siMain) 메타 필수) |
| WK-SSP0201-0016 | X-LOC | chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP) |
| WK-SSP0201-0017 | X-LOC | clbDivision_ID (Division, "40"고정 disable | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision_ID (Division, "40"고정 disable) |
| WK-SSP0201-0018 | X-LOC | clbFromSite / clbToSite (다중+ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite / clbToSite (다중+ALL)) |
| WK-SSP0201-0019 | X-LOC | color (30) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (color (30)) |
| WK-SSP0201-0020 | X-LOC | dataSource (3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dataSource (3)) |
| WK-SSP0201-0021 | X-LOC | drpPeriod (기간, 30일 기본) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod (기간, 30일 기본)) |
| WK-SSP0201-0022 | X-LOC | erp_status=='C' (MSG00189) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (erp_status=='C' (MSG00189)) |
| WK-SSP0201-0023 | X-LOC | lock (39) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (lock (39)) |
| WK-SSP0201-0024 | X-LOC | merge (5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (merge (5)) |
| WK-SSP0201-0025 | X-LOC | other (7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (other (7)) |
| WK-SSP0201-0026 | X-LOC | span (28) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (span (28)) |
| WK-SSP0201-0027 | X-LOC | spdMain (FpSpread "Shipment Change Reque | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0028 | X-LOC | spdSub (FpSpread "Change Request" 58열, 읽 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdSub (FpSpread "Change Request" 58열, 읽) |
| WK-SSP0201-0029 | X-LOC | txtRequest (Model, 다건) + btnItemId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtRequest (Model, 다건) + btnItemId) |
| WK-SSP0201-0030 | X-LOC | txtRequestNo (hidden R5) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtRequestNo (hidden R5)) |
| WK-SSP0201-0031 | X-LOC | txtSoNo (ERP SO No, 다건) / txtConfirmId ( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtSoNo (ERP SO No, 다건) / txtConfirmId () |
| WK-SSP0201-0032 | X-LOC | txtTitle/txtApproval/txtAppDeptName/cboC | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtTitle/txtApproval/txtAppDeptName/cboC) |
| WK-SSP0201-0033 | X-LOC | usrConditionPanel1 (접기/펼침) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1 (접기/펼침)) |
| WK-SSP0201-0034 | X-LOC | value (108) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (value (108)) |
| WK-SSP0201-0035 | X-LOC | visible (18) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (visible (18)) |
| WK-SSP0201-0036 | X-LOC | 데이터 셀 병합 `_getCellMergedRange` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: mergeManager.ts 없음 |  | 1 (데이터 셀 병합 `_getCellMergedRange`) |
| WK-SSP0201-0037 | X-LOC | 수량합계==0 (MSG00202) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (수량합계==0 (MSG00202)) |
| WK-SSP0201-0038 | X-LOC | 출하일 하한/상한(MSG00201/00194, dBaseDate) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (출하일 하한/상한(MSG00201/00194, dBaseDate)) |
| WK-SSP0201-0039 | X-LOC | 컬럼 헤더 병합 `_getColumnHeaderMergedRange` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: mergeManager.ts 없음 |  | 1 (컬럼 헤더 병합 `_getColumnHeaderMergedRange`) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0040 | H10 | SSP0201 화면 | DB(🛠️/🧯 적용 가능) | H10 FAIL 수정 — SSP0201 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/ShipmentChangeRequestMainGrid.tsx |  | 11 (BtnCancel_Click (R9) bolChang_Flag==fals) |

## W4 검사기 구현 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0041 | B3 | ATTRIBUTE10 | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.GetNew) |
| WK-SSP0201-0042 | B3 | CHANGE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0043 | B3 | CONFIRM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM_ID | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0044 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 9 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0045 | B3 | EDIT_MAIN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 EDIT_MAIN | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0046 | B3 | ERP_SO_NO | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ERP_SO_NO | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0047 | B3 | FROM_SITE_DESCRIPTION | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0048 | B3 | SHIPMENT_DATE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0049 | B3 | SHIPMENT_STATUS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0050 | B3 | TO_SITE_DESCRIPTION | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.Insert) |
| WK-SSP0201-0051 | B3 | cboChangeType / Change Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType (Plan Type, 기본 C)) |
| WK-SSP0201-0052 | B3 | cboStatus / Status | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboStatus / Status | 있음(FE 소스) | 1 (cboStatus (Status, P제외+ALL선두)) |
| WK-SSP0201-0053 | B3 | clbDivision_ID / Div / Division_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |

## W5 검사기 연결 (67)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0054 | B1 | ATTRIBUTE10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0055 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0056 | B1 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0057 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0058 | B1 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0059 | B1 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0060 | B1 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0061 | B1 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0062 | B1 | TO_SITE_SHIPTO_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_SHIPTO_CODE | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0063 | B1 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0064 | B1 | clbDivision_ID / Div / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 1 (ACT:SSP0201_ShipmentChangeRequest.Insert) |
| WK-SSP0201-0065 | B2 | ATTRIBUTE10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0066 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0067 | B2 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0068 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0069 | B2 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0070 | B2 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0071 | B2 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0072 | B2 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0073 | B2 | TO_SITE_SHIPTO_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_SHIPTO_CODE | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0074 | B2 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0075 | B2 | clbDivision_ID / Div / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 1 (ACT:SSP0201_ShipmentChangeRequest.Insert) |
| WK-SSP0201-0076 | B4 | ATTRIBUTE10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 6 (main ACT:SSP0201_ShipmentChangeRequest.G) |
| WK-SSP0201-0077 | B4 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0078 | B4 | CONFIRM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM_ID | 있음(SHEET_COLUMNS) | 12 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0079 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 14 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0080 | B4 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 3 (main ACT:SSP0201_ShipmentChangeRequest.G) |
| WK-SSP0201-0081 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0082 | B4 | ERP_SO_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ERP_SO_NO | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0083 | B4 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0084 | B4 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 9 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0085 | B4 | SHIPMENT_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_DATE | 있음(SHEET_COLUMNS) | 7 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0086 | B4 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0087 | B4 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0088 | B4 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0089 | B4 | TO_SITE_SHIPTO_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_SHIPTO_CODE | 있음(SHEET_COLUMNS) | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0090 | B4 | TRANSPORT_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0091 | B4 | cboChangeType / Change Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType (Plan Type, 기본 C)) |
| WK-SSP0201-0092 | B4 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (cboStatus (Status, P제외+ALL선두)) |
| WK-SSP0201-0093 | B4 | clbDivision_ID / Div / Division_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision_ID / Div / Division_ID | 있음(FE 소스) | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0094 | F2 | SSP0201 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0201 화면 | 판단불가(대상 단위 SCREEN) | 330 (btnAdd/btnDel/btnSave/dtDate/btnChangeRe) |
| WK-SSP0201-0095 | F6 | SSP0201 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0201 화면 | 판단불가(대상 단위 SCREEN) | 322 (`PKG_SSP0201` ACT:SSP0201_ShipmentChange) |
| WK-SSP0201-0096 | DB-SYN | PKG_SSP0201 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SSP0201 | 없음(PROC_M 대응 없음) | 1 (`PKG_SSP0201`) |
| WK-SSP0201-0097 | DB-SYN | SSP0201_GET_ERP_SO_NO_CNT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0201_GET_ERP_SO_NO_CNT | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0098 | DB-SYN | SSP0201_GET_SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0201_GET_SHIPMENT_STATUS | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0099 | G4 | btnApprovalUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApprovalUser | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0100 | G4 | btnCancel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCancel | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0101 | G4 | btnChangeRe | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnChangeRe | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0102 | G4 | btnChangeRe2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnChangeRe2 | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0103 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0104 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0105 | G4 | btnSave | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSave | 있음(FE 소스) | 2 (ACT:SSP0201_ShipmentChangeRequest.InitEv) |
| WK-SSP0201-0106 | E5 | ATTRIBUTE10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL ATTRIBUTE10 | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0107 | E5 | EDIT_MAIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL EDIT_MAIN | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0108 | E5 | FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL FROM_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0109 | E5 | TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL TO_SITE | 있음(SHEET_COLUMNS) | 1 (main) |
| WK-SSP0201-0110 | G03-WIRE | SSP0201 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0201 화면 | 판단불가(대상 단위 SCREEN) | 23 (ACT:SSP0201_ShipmentChangeRequest..ctor ) |
| WK-SSP0201-0111 | G5 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0112 | G5 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0113 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 62 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0114 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 32 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0115 | G5 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0116 | H6 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0117 | H6 | FROM_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0118 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 62 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0119 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 32 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0120 | H6 | TO_SITE_DESCRIPTION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_SITE_DESCRIPTION | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |

## W6 검증 실행 (367)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0121 | J2 | SSP0201 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0201 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 150 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0122 | C1 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0123 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0124 | C1 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0125 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0126 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0127 | C2 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0128 | C2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 24 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0129 | C2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0130 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0131 | C2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (그리드 셀 편집(cellEditEnded/beginningEdit) va) |
| WK-SSP0201-0132 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0133 | C2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0134 | C2 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0135 | C2 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 32 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0136 | C2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 34 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0137 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0138 | C2 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0139 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0140 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0141 | C2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0142 | C2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0143 | C2 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 25 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0144 | C2 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0145 | C2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 69 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0146 | C3 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0147 | C3 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 28 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0148 | C3 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0149 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0150 | C3 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0151 | C3 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0152 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 43 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0153 | C3 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 22 (그리드 셀 편집(cellEditEnded/beginningEdit) va) |
| WK-SSP0201-0154 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0155 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0156 | C3 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0157 | C3 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 38 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0158 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 34 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0159 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 19 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0160 | C3 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0161 | C3 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0162 | C3 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0163 | C3 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0164 | C3 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0165 | C3 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0166 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0167 | C3 | PLAN_CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0168 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0169 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0170 | C3 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0171 | C3 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0172 | C3 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0173 | C3 | REQUEST_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0174 | C3 | REQUEST_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0175 | C3 | REQUEST_USER_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0176 | C3 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 21 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0177 | C3 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0178 | C3 | STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetSta) |
| WK-SSP0201-0179 | C3 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 30 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0180 | C3 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0181 | C3 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 72 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0182 | C6 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0183 | C6 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 24 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0184 | C6 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0185 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 36 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0186 | C6 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (그리드 셀 편집(cellEditEnded/beginningEdit) va) |
| WK-SSP0201-0187 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0188 | C6 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0189 | C6 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0190 | C6 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 32 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0191 | C6 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 34 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0192 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0193 | C6 | NEW_ROUTE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NEW_ROUTE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0194 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0195 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0196 | C6 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0197 | C6 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0198 | C6 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 25 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0199 | C6 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0200 | C6 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 69 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0201 | G3 | SSP0201 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0201 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 15 (usrConditionPanel1 (접기/펼침) COMMON:UC-04 ) |
| WK-SSP0201-0202 | K-SA | SSP0201 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0201 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 12 (usrConditionPanel1 (접기/펼침) `PlanType1`(C) |
| WK-SSP0201-0203 | K4 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 119 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-07 A) |
| WK-SSP0201-0204 | F1 | SSP0201 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0201 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 331 (btnAdd/btnDel/btnSave/dtDate/btnChangeRe) |
| WK-SSP0201-0205 | F3 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 17 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0206 | F5 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (DeleteButton (R12 NO-OP) 실행체인 차단 사유 P-2) |
| WK-SSP0201-0207 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (drpPeriod (기간, 30일 기본) ACT:SSP0201_Shipm) |
| WK-SSP0201-0208 | F4 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 31 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0209 | F4 | PKG_SSP0201 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`PKG_SSP0201`) |
| WK-SSP0201-0210 | F4 | PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_RE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAF · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 4 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0211 | F4 | PKG_SSP0201.P_SSP0201_GET_CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_GET_CHANGE_REQ_NO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 164 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0212 | F4 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 368 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0213 | F4 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 207 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0214 | F4 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTIN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 383 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0215 | F4 | PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_CONF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 163 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0216 | F4 | PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_REQUEST_COMPLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 156 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0217 | F4 | PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 6 (ACT:SSP0201_ShipmentChangeRequest.NewNon) |
| WK-SSP0201-0218 | F4 | SSP0201_GET_ERP_SO_NO_CNT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0201_GET_ERP_SO_NO_CNT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 164 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0219 | F4 | SSP0201_GET_SHIPMENT_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0201_GET_SHIPMENT_STATUS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 164 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0220 | A5 | CHANGE_REASON_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 0 () |
| WK-SSP0201-0221 | A5 | CHANGE_REASON_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 0 () |
| WK-SSP0201-0222 | A5 | CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0223 | A5 | CHK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (**G-2** ACT:SSP0201_ShipmentChangeReques) |
| WK-SSP0201-0224 | A5 | CONFIRM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0225 | A5 | EDIT_MAIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0226 | A5 | END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0227 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (**G-5** ACT:SSP0201_ShipmentChangeReques) |
| WK-SSP0201-0228 | A5 | ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0229 | A5 | ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0230 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0231 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0232 | A5 | NEW_ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0233 | A5 | NEW_ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0234 | A5 | NEW_LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0235 | A5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0236 | A5 | NEW_SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0237 | A5 | NEW_TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0238 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0239 | A5 | PROJECT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0240 | A5 | REMARKS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0241 | A5 | SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0242 | A5 | SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0243 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0244 | G4 | cboChangeReason / Change Reason | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeReason / Change Reason · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0245 | G4 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeType / Change Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 47 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0246 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0247 | G4 | clbDivision_ID / Div / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0248 | G4 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0249 | G4 | dtDate / Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — dtDate / Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0250 | G4 | txtRequestDeptName / Dept Name / Request | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0251 | G4 | txtRequestor / Requestor | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtRequestor / Requestor · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0252 | G4 | txtSoNo / SO No / So No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtSoNo / SO No / So No · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (`lblSONo`(SO No)) |
| WK-SSP0201-0253 | H2 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0254 | H2 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0255 | H2 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (**G-2** ACT:SSP0201_ShipmentChangeReques) |
| WK-SSP0201-0256 | H2 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0257 | H2 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0258 | H2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0259 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0260 | H2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0261 | H2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0262 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0263 | H2 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0264 | H2 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0265 | H2 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0266 | H2 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0267 | H2 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0268 | H2 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0269 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0270 | H2 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0271 | H2 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0272 | H2 | REMARKS2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARKS2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0273 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0274 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0275 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0276 | H3 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (**G-3**) |
| WK-SSP0201-0277 | H4 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0278 | H5 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0279 | H5 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0280 | H5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (**G-2** ACT:SSP0201_ShipmentChangeReques) |
| WK-SSP0201-0281 | H5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CONFIRM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0282 | H5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_MAIN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0283 | H5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — END_CUSTOMER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0284 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0285 | H5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0286 | H5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0287 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0288 | H5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0289 | H5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0290 | H5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0291 | H5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0292 | H5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0293 | H5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0294 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0295 | H5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0296 | H5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARKS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0297 | H5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0298 | H5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0299 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0300 | H5 | cboChangeType / Change Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboChangeType / Change Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: tr |  | 42 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0301 | H5 | clbDivision_ID / Div / Division_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 |  | 8 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0302 | I1 | SSP0201 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0201 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 80 (BtnCancel_Click (R9) bolChang_Flag==fals) |
| WK-SSP0201-0303 | SC1 | SSP0201 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0201 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 12 (P-4 `PlanType1`(Change Type 콤보) `lblSONo) |
| WK-SSP0201-0304 | D1 | CHANGE_REASON_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REASON_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0305 | D1 | CHANGE_REASON_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0306 | D1 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0307 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 9 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0308 | D1 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0309 | D1 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0310 | D1 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0311 | D1 | ERP_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0312 | D1 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0313 | D1 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0314 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0315 | D1 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0316 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0317 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0318 | D1 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0319 | D1 | REMARKS3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REMARKS3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0320 | D1 | REQUESTOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REQUESTOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0321 | D1 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0322 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0323 | D1 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0324 | D1 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0325 | D1 | TO_SITE_SOLDTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_SITE_SOLDTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0326 | D3 | CHANGE_REASON_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REASON_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0327 | D3 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-SSP0201-0328 | D3 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0329 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 9 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0330 | D3 | EDIT_MAIN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDIT_MAIN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0331 | D3 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0332 | D3 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0333 | D3 | ERP_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0334 | D3 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0335 | D3 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0336 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0337 | D3 | NEW_ETA | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NEW_ETA · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0338 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0339 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0340 | D3 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0341 | D3 | REMARKS3 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REMARKS3 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0342 | D3 | REQUESTOR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REQUESTOR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0343 | D3 | SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0344 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0345 | D3 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0346 | D3 | TO_SITE_SHIPTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0347 | D3 | TO_SITE_SOLDTO_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_SITE_SOLDTO_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0348 | D4 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (**G-5**) |
| WK-SSP0201-0349 | D5 | ATTRIBUTE10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE10 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (main) |
| WK-SSP0201-0350 | D5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0351 | D5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0352 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0353 | D5 | EDIT_MAIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EDIT_MAIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (main) |
| WK-SSP0201-0354 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0355 | D5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0356 | D5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0357 | D5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0358 | D5 | FROM_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (main) |
| WK-SSP0201-0359 | D5 | FROM_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0360 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0361 | D5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0362 | D5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0363 | D5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0364 | D5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0365 | D5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0366 | D5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0367 | D5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0368 | D5 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0369 | D5 | REMARKS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REMARKS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0370 | D5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0371 | D5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0372 | D5 | TO_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (main) |
| WK-SSP0201-0373 | D5 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0374 | D5 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0375 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0376 | D6 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (InsertButton (R11) 실행체인 차단 사유 P-5 main a) |
| WK-SSP0201-0377 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0378 | E1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0379 | E1 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (**수량 소수자리**) |
| WK-SSP0201-0380 | E1 | TO_SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0381 | E1 | TO_SITE_SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_SITE_SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0382 | E4 | CHANGE_REASON_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0383 | E4 | CHANGE_REASON_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REASON_DETAIL · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0384 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0385 | E4 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0386 | E4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0387 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0388 | E4 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0389 | E4 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0390 | E4 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요 |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0391 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0392 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0393 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.checkR) |
| WK-SSP0201-0394 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.BtnSav) |
| WK-SSP0201-0395 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0396 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 17 (From/To Site 선행필수(MSG00098) ACT:SSP0201_) |
| WK-SSP0201-0397 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (bolChang_Flag==false (MSG00133 수정없음) ACT) |
| WK-SSP0201-0398 | E4 | MSG00173 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00173 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0399 | E4 | MSG00174 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00174 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (SHIPMENT_STATUS=='R' (MSG00174 요청완료) ACT) |
| WK-SSP0201-0400 | E4 | MSG00189 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00189 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (erp_status=='C' (MSG00189) ACT:SSP0201_S) |
| WK-SSP0201-0401 | E4 | MSG00194 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00194 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.BtnCha) |
| WK-SSP0201-0402 | E4 | MSG00195 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00195 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.BtnCan) |
| WK-SSP0201-0403 | E4 | MSG00197 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00197 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0404 | E4 | MSG00198 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00198 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0405 | E4 | MSG00201 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00201 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (출하일 하한/상한(MSG00201/00194, dBaseDate) ACT) |
| WK-SSP0201-0406 | E4 | MSG00202 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00202 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (수량합계==0 (MSG00202) ACT:SSP0201_ShipmentC) |
| WK-SSP0201-0407 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0408 | E4 | MSG00247 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00247 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0409 | E4 | MSG00248 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00248 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0410 | E4 | MSG00249 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00249 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0411 | E4 | MSG00261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0412 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.chkERP) |
| WK-SSP0201-0413 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0414 | E4 | MSG00286 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00286 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0415 | E4 | MSG00287 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00287 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (REASON_CODE 없이 DETAIL (MSG00287) ACT:SSP) |
| WK-SSP0201-0416 | E4 | MSG00293 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00293 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.NonSoN) |
| WK-SSP0201-0417 | E4 | MSG00306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0418 | E4 | MSG00316 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00316 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0419 | E4 | MSG00324 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00324 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0420 | E4 | MSG00328 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00328 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0421 | E4 | MSG00353 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00353 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0422 | E4 | MSG00359 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00359 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0423 | E4 | MSG00468 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00468 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0424 | E4 | MSG00684 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00684 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (BtnCancel_Click (R9)) |
| WK-SSP0201-0425 | E4 | NEW_ETA | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_ETA · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0426 | E4 | NEW_SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0427 | E4 | NEW_SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0428 | E4 | NEW_TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0429 | E4 | NEW_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NEW_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0201_ShipmentChangeRequest.BtnCha) |
| WK-SSP0201-0430 | E4 | PLAN_CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLAN_CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0431 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0432 | E4 | REMARKS2 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REMARKS2 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0433 | E4 | REMARKS3 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REMARKS3 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0434 | E4 | REQUEST_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_TIME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0435 | E4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0436 | E4 | REQUEST_USER_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0437 | E4 | SHIPMENT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.GetNew) |
| WK-SSP0201-0438 | E4 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 15 (SHIPMENT_STATUS=='R' (MSG00174 요청완료) ACT) |
| WK-SSP0201-0439 | E4 | STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetSta) |
| WK-SSP0201-0440 | E4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0441 | E4 | TRANSPORT_MODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TRANSPORT_MODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0442 | E4 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0443 | E4 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 10 (ACT:SSP0201_ShipmentChangeRequest.BtnCha) |
| WK-SSP0201-0444 | E4 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0445 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0446 | E4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0447 | E4 | txtAppDeptName / Dept Name / App Dept Na | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) →  |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0448 | E4 | txtApproval / Approval | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtApproval / Approval · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0449 | E4 | txtReasonDetail / Reason Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReasonDetail / Reason Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0450 | E4 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0451 | E4 | txtRequestNo / Request No | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestNo / Request No · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 12 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0452 | E4 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0453 | E4 | txtTitle / Title | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtTitle / Title · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0454 | A10 | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 146 (ACT:SSP0201_ShipmentChangeRequest.Define) |
| WK-SSP0201-0455 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (drpPeriod (기간, 30일 기본)) |
| WK-SSP0201-0456 | A6 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 31 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0457 | A6 | PKG_SSP0201 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0201 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (`PKG_SSP0201`) |
| WK-SSP0201-0458 | A6 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 50 (ACT:SSP0201_ShipmentChangeRequest.FindBu) |
| WK-SSP0201-0459 | A6 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 45 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0460 | A6 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTIN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 65 (ACT:SSP0201_ShipmentChangeRequest.FindBu) |
| WK-SSP0201-0461 | G1 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboChangeType / Change Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 12 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0462 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0463 | G1 | clbDivision_ID / Div / Division_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0464 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0465 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0466 | G1 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 9 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0467 | G1 | txtAppDeptName / Dept Name / App Dept Na | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0468 | G1 | txtApproval / Approval | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtApproval / Approval · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 10 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0469 | G1 | txtConfirmId / Confirm Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtConfirmId / Confirm Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0470 | G1 | txtRequest / sItemId / Request | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequest / sItemId / Request · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0471 | G1 | txtSoNo / SO No / So No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSoNo / SO No / So No · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (`lblSONo`(SO No) ACT:SSP0201_ShipmentCha) |
| WK-SSP0201-0472 | G6 | cboChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0473 | G6 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 47 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0474 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0475 | G6 | clbDivision_ID / Div / Division_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision_ID / Div / Division_ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 12 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0476 | G6 | drpPeriod / Shipment Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0477 | G6 | dtDate / Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — dtDate / Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0478 | G6 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0479 | G6 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0480 | G6 | txtSoNo / SO No / So No | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtSoNo / SO No / So No · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (`lblSONo`(SO No)) |
| WK-SSP0201-0481 | X-REOPEN | SSP0201 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0201 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 20 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0482 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0483 | M4 | FROM_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0484 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 62 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0485 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0486 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 32 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0487 | M4 | TO_SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — TO_SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |

## W7 기대값 확정 (315)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0201-0488 | C1 | CboChangeType_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CboChangeType_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CboChangeType_SelectedIndexChanged) |
| WK-SSP0201-0489 | C1 | clbDivision_ID_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — clbDivision_ID_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision_ID_SelectedIndexChanged) |
| WK-SSP0201-0490 | C2 | REASON_CODE 없이 DETAIL (MSG00287) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — REASON_CODE 없이 DETAIL (MSG00287): 행 집계 — C2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (REASON_CODE 없이 DETAIL (MSG00287)) |
| WK-SSP0201-0491 | C2 | SSP0201_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0201_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0201_ShipmentChangeRequest.CboCha) |
| WK-SSP0201-0492 | C2 | SSP0201_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0493 | C2 | SSP0201_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SSP0201_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C2 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.clbDiv) |
| WK-SSP0201-0494 | C3 | REASON_CODE 없이 DETAIL (MSG00287) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — REASON_CODE 없이 DETAIL (MSG00287): 행 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (REASON_CODE 없이 DETAIL (MSG00287)) |
| WK-SSP0201-0495 | C3 | SSP0201_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0201_ShipmentChangeRequest.CboCha) |
| WK-SSP0201-0496 | C3 | SSP0201_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetBut) |
| WK-SSP0201-0497 | C3 | SSP0201_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0498 | C3 | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0499 | C3 | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0500 | C3 | SSP0201_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangedControl: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0201-0501 | C3 | SSP0201_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetMainStatus: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0502 | C3 | SSP0201_ShipmentChangeRequest.SetStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SetStatus: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SetSta) |
| WK-SSP0201-0503 | C3 | SSP0201_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0504 | C3 | SSP0201_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C3 36요소: NOT_RUN:36 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.clbDiv) |
| WK-SSP0201-0505 | C3 | SSP0201_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0201_ShipmentChangeRequest.setEndCustomer: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0506 | C6 | REASON_CODE 없이 DETAIL (MSG00287) | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — REASON_CODE 없이 DETAIL (MSG00287): 행 집계 — C6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (REASON_CODE 없이 DETAIL (MSG00287)) |
| WK-SSP0201-0507 | C6 | SSP0201_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0201_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 — C6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0201_ShipmentChangeRequest.CboCha) |
| WK-SSP0201-0508 | C6 | SSP0201_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 — C6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0509 | C6 | SSP0201_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SSP0201_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 — C6 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.clbDiv) |
| WK-SSP0201-0510 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0511 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0512 | B3 | SSP0201_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetDayRange: 진입점 집계 — B3 13요소: TODO:13 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.GetDay) |
| WK-SSP0201-0513 | B3 | SSP0201_ShipmentChangeRequest.GetERPInte | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetERPInterface: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0514 | B3 | SSP0201_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 — B3 13요소: TODO:13 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0515 | B3 | SSP0201_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 — B3 13요소: TODO:13 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0516 | B3 | SSP0201_ShipmentChangeRequest.GetNewERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetNewERPInterface: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SSP0201_ShipmentChangeRequest.GetNew) |
| WK-SSP0201-0517 | B3 | SSP0201_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0201_ShipmentChangeRequest.GetShipmentStatusChk: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0518 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0519 | B4 | SSP0201_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetDayRange: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.GetDay) |
| WK-SSP0201-0520 | B4 | SSP0201_ShipmentChangeRequest.GetERPInte | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetERPInterface: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SSP0201_ShipmentChangeRequest.GetERP) |
| WK-SSP0201-0521 | B4 | SSP0201_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0522 | B4 | SSP0201_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 — B4 18요소: NOPATH:18 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0523 | B4 | SSP0201_ShipmentChangeRequest.GetNewERPI | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetNewERPInterface: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SSP0201_ShipmentChangeRequest.GetNew) |
| WK-SSP0201-0524 | B4 | SSP0201_ShipmentChangeRequest.GetShipmen | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0201_ShipmentChangeRequest.GetShipmentStatusChk: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SSP0201_ShipmentChangeRequest.GetShi) |
| WK-SSP0201-0525 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0526 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0201-0527 | A5 | SSP0201 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0201 main: 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 main) |
| WK-SSP0201-0528 | A5 | SSP0201 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0201 sub: 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 sub) |
| WK-SSP0201-0529 | A5 | SSP0201_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0201_ShipmentChangeRequest.CreateSpread: 진입점 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0201_ShipmentChangeRequest.Create) |
| WK-SSP0201-0530 | A5 | SSP0202 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0202 main: 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0202 main) |
| WK-SSP0201-0531 | A5 | merge (5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — merge (5): 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (merge (5)) |
| WK-SSP0201-0532 | A5 | other (7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — other (7): 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (other (7)) |
| WK-SSP0201-0533 | A5 | spdMain (FpSpread "Shipment Change Reque | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain (FpSpread "Shipment Change Request" 65열): 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0534 | A5 | spdSub (FpSpread "Change Request" 58열, 읽 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdSub (FpSpread "Change Request" 58열, 읽기전용): 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (FpSpread "Change Request" 58열, 읽) |
| WK-SSP0201-0535 | A5 | txtRequestNo (hidden R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — txtRequestNo (hidden R5): 행 집계 — A5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (txtRequestNo (hidden R5)) |
| WK-SSP0201-0536 | G4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 1: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0201-0537 | G4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 2: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0201-0538 | G4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 3: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0201-0539 | G4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 4: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0201-0540 | G4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 5: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SSP0201-0541 | G4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 6: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0201-0542 | G4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 7: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SSP0201-0543 | G4 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — P-4: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
| WK-SSP0201-0544 | G4 | `PlanType1`(Change Type 콤보) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `PlanType1`(Change Type 콤보): 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (`PlanType1`(Change Type 콤보)) |
| WK-SSP0201-0545 | G4 | `chkSingleProcess` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `chkSingleProcess`: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (`chkSingleProcess`) |
| WK-SSP0201-0546 | G4 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — —: 행 집계 — G4 16요소: NOT_RUN:9 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-SSP0201-0547 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0548 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0201-0549 | H2 | SSP0201 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0201 main: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 main) |
| WK-SSP0201-0550 | H2 | SSP0201 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0201 sub: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 sub) |
| WK-SSP0201-0551 | H2 | SSP0201_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0201_ShipmentChangeRequest.CreateSpread: 진입점 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0201_ShipmentChangeRequest.Create) |
| WK-SSP0201-0552 | H2 | SSP0202 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0202 main: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (SSP0202 main) |
| WK-SSP0201-0553 | H2 | btnApprovalUser (승인자검색 R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — btnApprovalUser (승인자검색 R7): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (btnApprovalUser (승인자검색 R7)) |
| WK-SSP0201-0554 | H2 | color (30) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — color (30): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (color (30)) |
| WK-SSP0201-0555 | H2 | main formatItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — main formatItem: 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (main formatItem) |
| WK-SSP0201-0556 | H2 | merge (5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — merge (5): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (merge (5)) |
| WK-SSP0201-0557 | H2 | other (7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — other (7): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (other (7)) |
| WK-SSP0201-0558 | H2 | spdMain (FpSpread "Shipment Change Reque | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain (FpSpread "Shipment Change Request" 65열): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0559 | H2 | spdSub (FpSpread "Change Request" 58열, 읽 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdSub (FpSpread "Change Request" 58열, 읽기전용): 행 집계 — H2 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (FpSpread "Change Request" 58열, 읽) |
| WK-SSP0201-0560 | H3 | SSP0201 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SSP0201 main: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 main) |
| WK-SSP0201-0561 | H3 | SSP0201 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SSP0201 sub: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 sub) |
| WK-SSP0201-0562 | H3 | SSP0202 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SSP0202 main: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSP0202 main) |
| WK-SSP0201-0563 | H3 | SSP0202 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — SSP0202 sub: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SSP0202 sub) |
| WK-SSP0201-0564 | H3 | main 데이터셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — main 데이터셀 병합: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (main 데이터셀 병합) |
| WK-SSP0201-0565 | H3 | merge (5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — merge (5): 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (merge (5)) |
| WK-SSP0201-0566 | H3 | sub 데이터셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — sub 데이터셀 병합: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (sub 데이터셀 병합) |
| WK-SSP0201-0567 | H3 | 데이터 셀 병합 `_getCellMergedRange` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — 데이터 셀 병합 `_getCellMergedRange`: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (데이터 셀 병합 `_getCellMergedRange`) |
| WK-SSP0201-0568 | H3 | 컬럼 헤더 병합 `_getColumnHeaderMergedRange` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — 컬럼 헤더 병합 `_getColumnHeaderMergedRange`: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 헤더 병합 `_getColumnHeaderMergedRange`) |
| WK-SSP0201-0569 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0570 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0201-0571 | H5 | SSP0201 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0201 main: 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 main) |
| WK-SSP0201-0572 | H5 | SSP0201 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0201 sub: 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0201 sub) |
| WK-SSP0201-0573 | H5 | SSP0201_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0201_ShipmentChangeRequest.CreateSpread: 진입점 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0201_ShipmentChangeRequest.Create) |
| WK-SSP0201-0574 | H5 | SSP0202 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0202 main: 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SSP0202 main) |
| WK-SSP0201-0575 | H5 | merge (5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — merge (5): 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (merge (5)) |
| WK-SSP0201-0576 | H5 | other (7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — other (7): 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (other (7)) |
| WK-SSP0201-0577 | H5 | spdMain (FpSpread "Shipment Change Reque | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain (FpSpread "Shipment Change Request" 65열): 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0578 | H5 | spdSub (FpSpread "Change Request" 58열, 읽 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdSub (FpSpread "Change Request" 58열, 읽기전용): 행 집계 — H5 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (spdSub (FpSpread "Change Request" 58열, 읽) |
| WK-SSP0201-0579 | X-REASON | **Insert Multiple 팝업** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **Insert Multiple 팝업** 있음(btnInsertMultiple cs:2924 + `InsertMultipleModal`) **NOT FOUND** — `btnInsertMultiple |  | 1 (**Insert Multiple 팝업**) |
| WK-SSP0201-0580 | X-REASON | **SO 주문상세 드릴다운** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **SO 주문상세 드릴다운** 있음(ERP_SO_NO 더블클릭 → `SSP0300_OrderDetailPopup`, cs:4858~4878) **NOT FOUND** — `SpdMain_CellDou |  | 1 (**SO 주문상세 드릴다운**) |
| WK-SSP0201-0581 | X-REASON | **조회조건 콤보 `'ALL'` 전송** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **조회조건 콤보 `'ALL'` 전송** 8c440da7 에서 `''` → `'ALL'` 로 교정 — **미이식(이식하면 결함)**. `PKG_SSP0201` body 는 `V_x_YN := CASE |  | 1 (**조회조건 콤보 `'ALL'` 전송**) |
| WK-SSP0201-0582 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm - 편집 중 재조회 confirm 은 공용 편집가드 패턴 소관(화면 고유 배선 없음). 편집모드 stat |  | 1 (COMMON:UC-02) |
| WK-SSP0201-0583 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 - Column/Measure 설정 버튼 없음(SSP0201 Measure 0건,  |  | 1 (COMMON:UC-03) |
| WK-SSP0201-0584 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 - 조회조건에 자유 key-in 콤마 다중검색 필드 없음 — Division/Site/Plan Type/Status=콤 |  | 1 (COMMON:UC-06) |
| WK-SSP0201-0585 | D1 | EditButton (toolbarOverride, R1 SwitchLo | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton (toolbarOverride, R1 SwitchLock): 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (toolbarOverride, R1 SwitchLo) |
| WK-SSP0201-0586 | D1 | P-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P-1: 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (P-1) |
| WK-SSP0201-0587 | D1 | SSP0201_ShipmentChangeRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0201_ShipmentChangeRequest.EditButton: 진입점 집계 — D1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0588 | D1 | SaveButton !IsLock (편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SaveButton !IsLock (편집모드): 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton !IsLock (편집모드)) |
| WK-SSP0201-0589 | D1 | erp_status=='C' (MSG00189) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — erp_status=='C' (MSG00189): 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (erp_status=='C' (MSG00189)) |
| WK-SSP0201-0590 | D1 | lock (39) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — lock (39): 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (lock (39)) |
| WK-SSP0201-0591 | D1 | main formatItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — main formatItem: 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (main formatItem) |
| WK-SSP0201-0592 | D1 | spdMain (FpSpread "Shipment Change Reque | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — spdMain (FpSpread "Shipment Change Request" 65열): 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0593 | D1 | sub 전량 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — sub 전량 읽기전용: 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (sub 전량 읽기전용) |
| WK-SSP0201-0594 | D1 | 실행체인 차단 사유 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 실행체인 차단 사유: 행 집계 — D1 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0595 | D3 | EditButton (toolbarOverride, R1 SwitchLo | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton (toolbarOverride, R1 SwitchLock): 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (toolbarOverride, R1 SwitchLo) |
| WK-SSP0201-0596 | D3 | P-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P-1: 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (P-1) |
| WK-SSP0201-0597 | D3 | SSP0201_ShipmentChangeRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0201_ShipmentChangeRequest.EditButton: 진입점 집계 — D3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0201_ShipmentChangeRequest.EditBu) |
| WK-SSP0201-0598 | D3 | SaveButton !IsLock (편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveButton !IsLock (편집모드): 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton !IsLock (편집모드)) |
| WK-SSP0201-0599 | D3 | erp_status=='C' (MSG00189) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — erp_status=='C' (MSG00189): 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (erp_status=='C' (MSG00189)) |
| WK-SSP0201-0600 | D3 | lock (39) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — lock (39): 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (lock (39)) |
| WK-SSP0201-0601 | D3 | main formatItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — main formatItem: 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (main formatItem) |
| WK-SSP0201-0602 | D3 | spdMain (FpSpread "Shipment Change Reque | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — spdMain (FpSpread "Shipment Change Request" 65열): 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread "Shipment Change Reque) |
| WK-SSP0201-0603 | D3 | sub 전량 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — sub 전량 읽기전용: 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (sub 전량 읽기전용) |
| WK-SSP0201-0604 | D3 | 실행체인 차단 사유 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 실행체인 차단 사유: 행 집계 — D3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0605 | D4 | InsertButton (R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — InsertButton (R11): 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton (R11)) |
| WK-SSP0201-0606 | D4 | P-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — P-5: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (P-5) |
| WK-SSP0201-0607 | D4 | main autoFit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — main autoFit: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (main autoFit) |
| WK-SSP0201-0608 | D4 | merge (5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — merge (5): 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (merge (5)) |
| WK-SSP0201-0609 | D4 | 실행체인 차단 사유 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 실행체인 차단 사유: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0610 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0611 | D5 | SSP0201_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0201_ShipmentChangeRequest.CreateSpread: 진입점 집계 — D5 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0201_ShipmentChangeRequest.Create) |
| WK-SSP0201-0612 | E4 | SSP0201_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SetBut) |
| WK-SSP0201-0613 | E4 | SSP0201_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0614 | E4 | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0615 | E4 | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0616 | E4 | SSP0201_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0201-0617 | E4 | SSP0201_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetMainStatus: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0618 | E4 | SSP0201_ShipmentChangeRequest.SetStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.SetStatus: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SSP0201_ShipmentChangeRequest.SetSta) |
| WK-SSP0201-0619 | E4 | SSP0201_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0201_ShipmentChangeRequest.setEndCustomer: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0620 | E4 | SaveButton !IsLock (편집모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton !IsLock (편집모드): 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton !IsLock (편집모드)) |
| WK-SSP0201-0621 | E4 | SaveButton/BtnSave_Click (R8/R14) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton/BtnSave_Click (R8/R14): 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton/BtnSave_Click (R8/R14)) |
| WK-SSP0201-0622 | E4 | Validation_Check() 본문(Qty/Date/Mode→Chan | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Validation_Check() 본문(Qty/Date/Mode→ChangeReason): 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (Validation_Check() 본문(Qty/Date/Mode→Chan) |
| WK-SSP0201-0623 | E4 | checkRequired 4항목(승인자/제목/변경사유/사유상세) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkRequired 4항목(승인자/제목/변경사유/사유상세): 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (checkRequired 4항목(승인자/제목/변경사유/사유상세)) |
| WK-SSP0201-0624 | E4 | checkRequiredOfSpread(siMain) 메타 필수 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — checkRequiredOfSpread(siMain) 메타 필수: 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSpread(siMain) 메타 필수) |
| WK-SSP0201-0625 | E4 | chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP BLOCK_YN=: 행 집계 — E4 72요소: NOT_RUN:72 (미실행 요소가 남아 판정필요) |  | 1 (chkERPIFBlockYn (R8, SSPBlockCheckIF_SCP) |
| WK-SSP0201-0626 | E5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — COMMON:UC-05: 행 집계 — E5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0201-0627 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (1) |
| WK-SSP0201-0628 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (2) |
| WK-SSP0201-0629 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (3) |
| WK-SSP0201-0630 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (4) |
| WK-SSP0201-0631 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (5) |
| WK-SSP0201-0632 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (6) |
| WK-SSP0201-0633 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (7) |
| WK-SSP0201-0634 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (COMMON:UC-07) |
| WK-SSP0201-0635 | A1 | FindButton (R13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (R13): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (FindButton (R13)) |
| WK-SSP0201-0636 | A1 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-4: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (P-4) |
| WK-SSP0201-0637 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (drpPeriod (기간, 30일 기본)) |
| WK-SSP0201-0638 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0639 | A1 | PKG_SSP0026.P_SSP0026_GET_BOD_ITEM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0026.P_SSP0026_GET_BOD_ITEM: 골든 비교 케이스 없음(PKG_SSP0026.P_SSP0026_GET_BOD_ITEM — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 31 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0640 | A1 | PKG_SSP0201 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0201: 골든 비교 케이스 없음(PKG_SSP0201 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`PKG_SSP0201`) |
| WK-SSP0201-0641 | A1 | PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_RE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAF: 골든 비교 케이스 없음(PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTIN |  | 1 (BtnCancel_Click (R9)) |
| WK-SSP0201-0642 | A1 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST: 골든 비교 케이스 없음(PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST — 팝업 |  | 50 (ACT:SSP0201_ShipmentChangeRequest.FindBu) |
| WK-SSP0201-0643 | A1 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_: 골든 비교 케이스 없음(PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N — |  | 45 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0644 | A1 | PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTIN: 골든 비교 케이스 없음(PKG_SSP0201.P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTING — |  | 65 (ACT:SSP0201_ShipmentChangeRequest.FindBu) |
| WK-SSP0201-0645 | A1 | `PlanType1`(Change Type 콤보) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `PlanType1`(Change Type 콤보): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (`PlanType1`(Change Type 콤보)) |
| WK-SSP0201-0646 | A1 | `chkSingleProcess` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `chkSingleProcess`: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (`chkSingleProcess`) |
| WK-SSP0201-0647 | A1 | `lblSONo`(SO No) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `lblSONo`(SO No): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (`lblSONo`(SO No)) |
| WK-SSP0201-0648 | A1 | cellType (19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cellType (19): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cellType (19)) |
| WK-SSP0201-0649 | A1 | clbDivision_ID_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision_ID_SelectedIndexChanged: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (clbDivision_ID_SelectedIndexChanged) |
| WK-SSP0201-0650 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (—) |
| WK-SSP0201-0651 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0201-0652 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0201-0653 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0201-0654 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0201-0655 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SSP0201-0656 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0201-0657 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SSP0201-0658 | G1 | BtnCancel_Click (R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BtnCancel_Click (R9): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (BtnCancel_Click (R9)) |
| WK-SSP0201-0659 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0201-0660 | G1 | FindButton (R13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (R13): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (R13)) |
| WK-SSP0201-0661 | G1 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — P-4: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
| WK-SSP0201-0662 | G1 | `PlanType1`(Change Type 콤보) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `PlanType1`(Change Type 콤보): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`PlanType1`(Change Type 콤보)) |
| WK-SSP0201-0663 | G1 | `chkSingleProcess` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `chkSingleProcess`: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`chkSingleProcess`) |
| WK-SSP0201-0664 | G1 | cellType (19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cellType (19): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (cellType (19)) |
| WK-SSP0201-0665 | G1 | clbDivision_ID_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — clbDivision_ID_SelectedIndexChanged: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision_ID_SelectedIndexChanged) |
| WK-SSP0201-0666 | G1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — —: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-SSP0201-0667 | G1 | 실행체인 차단 사유 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 실행체인 차단 사유: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0668 | G6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 1: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0201-0669 | G6 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 2: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0201-0670 | G6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 3: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0201-0671 | G6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 4: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0201-0672 | G6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 5: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SSP0201-0673 | G6 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 6: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0201-0674 | G6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 7: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SSP0201-0675 | G6 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — P-4: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
| WK-SSP0201-0676 | G6 | `PlanType1`(Change Type 콤보) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `PlanType1`(Change Type 콤보): 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (`PlanType1`(Change Type 콤보)) |
| WK-SSP0201-0677 | G6 | `chkSingleProcess` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `chkSingleProcess`: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (`chkSingleProcess`) |
| WK-SSP0201-0678 | G6 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — —: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-SSP0201-0679 | X-LOC | **G-1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-1**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-1**) |
| WK-SSP0201-0680 | X-LOC | **G-2** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-2**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-2**) |
| WK-SSP0201-0681 | X-LOC | **G-3** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-3**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-3**) |
| WK-SSP0201-0682 | X-LOC | **G-4** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-4**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-4**) |
| WK-SSP0201-0683 | X-LOC | **G-5** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-5**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-5**) |
| WK-SSP0201-0684 | X-LOC | **G-6** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **G-6**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**G-6**) |
| WK-SSP0201-0685 | X-LOC | **수량 소수자리** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **수량 소수자리**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**수량 소수자리**) |
| WK-SSP0201-0686 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SSP0201-0687 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SSP0201-0688 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SSP0201-0689 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SSP0201-0690 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SSP0201-0691 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SSP0201-0692 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SSP0201-0693 | X-LOC | BtnApprovalUser_Click (R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BtnApprovalUser_Click (R7): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BtnApprovalUser_Click (R7)) |
| WK-SSP0201-0694 | X-LOC | BtnCancel_Click (R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BtnCancel_Click (R9): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BtnCancel_Click (R9)) |
| WK-SSP0201-0695 | X-LOC | BtnChangeRe_Click (R14 checkRequired) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BtnChangeRe_Click (R14 checkRequired): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BtnChangeRe_Click (R14 checkRequired)) |
| WK-SSP0201-0696 | X-LOC | BtnNew_Click (R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BtnNew_Click (R10): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BtnNew_Click (R10)) |
| WK-SSP0201-0697 | X-LOC | CboChangeType_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CboChangeType_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CboChangeType_SelectedIndexChanged) |
| WK-SSP0201-0698 | X-LOC | DeleteButton (R12 NO-OP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton (R12 NO-OP): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton (R12 NO-OP)) |
| WK-SSP0201-0699 | X-LOC | EditButton (toolbarOverride, R1 SwitchLo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton (toolbarOverride, R1 SwitchLock): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton (toolbarOverride, R1 SwitchLo) |
| WK-SSP0201-0700 | X-LOC | FindButton (R13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton (R13): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton (R13)) |
| WK-SSP0201-0701 | X-LOC | InsertButton (R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton (R11): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton (R11)) |
| WK-SSP0201-0702 | X-LOC | P-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P-1) |
| WK-SSP0201-0703 | X-LOC | P-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P-2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P-2) |
| WK-SSP0201-0704 | X-LOC | P-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P-3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P-3) |
| WK-SSP0201-0705 | X-LOC | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P-4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P-4) |
| WK-SSP0201-0706 | X-LOC | P-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P-5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P-5) |
| WK-SSP0201-0707 | X-LOC | SSP0201 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0201 main: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0201 main) |
| WK-SSP0201-0708 | X-LOC | SSP0202 main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0202 main: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0202 main) |
| WK-SSP0201-0709 | X-LOC | SSP0202 sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSP0202 sub: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSP0202 sub) |
| WK-SSP0201-0710 | X-LOC | SaveButton/BtnSave_Click (R8/R14) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton/BtnSave_Click (R8/R14): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton/BtnSave_Click (R8/R14)) |
| WK-SSP0201-0711 | X-LOC | `PKG_SSP0201` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SSP0201`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SSP0201`) |
| WK-SSP0201-0712 | X-LOC | `PlanType1`(Change Type 콤보) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PlanType1`(Change Type 콤보): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PlanType1`(Change Type 콤보)) |
| WK-SSP0201-0713 | X-LOC | `chkSingleProcess` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `chkSingleProcess`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`chkSingleProcess`) |
| WK-SSP0201-0714 | X-LOC | `lblSONo`(SO No) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `lblSONo`(SO No): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`lblSONo`(SO No)) |
| WK-SSP0201-0715 | X-LOC | clbDivision_ID_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbDivision_ID_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbDivision_ID_SelectedIndexChanged) |
| WK-SSP0201-0716 | X-LOC | main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main) |
| WK-SSP0201-0717 | X-LOC | main autoFit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main autoFit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main autoFit) |
| WK-SSP0201-0718 | X-LOC | main formatItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main formatItem: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main formatItem) |
| WK-SSP0201-0719 | X-LOC | main 단일 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main 단일 헤더: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main 단일 헤더) |
| WK-SSP0201-0720 | X-LOC | main 데이터셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main 데이터셀 병합: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main 데이터셀 병합) |
| WK-SSP0201-0721 | X-LOC | sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sub: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sub) |
| WK-SSP0201-0722 | X-LOC | sub 2단 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sub 2단 헤더: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sub 2단 헤더) |
| WK-SSP0201-0723 | X-LOC | sub 데이터셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sub 데이터셀 병합: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sub 데이터셀 병합) |
| WK-SSP0201-0724 | X-LOC | sub 전량 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sub 전량 읽기전용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sub 전량 읽기전용) |
| WK-SSP0201-0725 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-SSP0201-0726 | X-LOC | 그리드 셀 편집(cellEditEnded/beginningEdit) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 셀 편집(cellEditEnded/beginningEdit): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 셀 편집(cellEditEnded/beginningEdit)) |
| WK-SSP0201-0727 | X-LOC | 실행체인 차단 사유 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 실행체인 차단 사유: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (실행체인 차단 사유) |
| WK-SSP0201-0728 | X-ROW | **G-1** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **G-1**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**G-1**) |
| WK-SSP0201-0729 | X-ROW | **G-4** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **G-4**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**G-4**) |
| WK-SSP0201-0730 | X-ROW | **G-6** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **G-6**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**G-6**) |
| WK-SSP0201-0731 | X-ROW | **P-6** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **P-6**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**P-6**) |
| WK-SSP0201-0732 | X-ROW | BtnApprovalUser_Click (R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BtnApprovalUser_Click (R7): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BtnApprovalUser_Click (R7)) |
| WK-SSP0201-0733 | X-ROW | BtnChangeRe_Click (R14 checkRequired) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BtnChangeRe_Click (R14 checkRequired): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BtnChangeRe_Click (R14 checkRequired)) |
| WK-SSP0201-0734 | X-ROW | BtnNew_Click (R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BtnNew_Click (R10): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BtnNew_Click (R10)) |
| WK-SSP0201-0735 | X-ROW | SSP0201_ShipmentChangeRequest.Backup_Val | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.Backup_Value: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0201_ShipmentChangeRequest.Backup) |
| WK-SSP0201-0736 | X-ROW | SSP0201_ShipmentChangeRequest.BtnApprova | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.BtnApprovalUser_Clic: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0201_ShipmentChangeRequest.BtnApp) |
| WK-SSP0201-0737 | X-ROW | SSP0201_ShipmentChangeRequest.BtnChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.BtnChangeRe_Click: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.BtnCha) |
| WK-SSP0201-0738 | X-ROW | SSP0201_ShipmentChangeRequest.BtnNew_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.BtnNew_Click: 진입점 집계 42검사 — NOT_RUN:28 · NOPATH:13 · TODO:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0201_ShipmentChangeRequest.BtnNew) |
| WK-SSP0201-0739 | X-ROW | SSP0201_ShipmentChangeRequest.CboChangeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.CboChangeType_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.CboCha) |
| WK-SSP0201-0740 | X-ROW | SSP0201_ShipmentChangeRequest.Change_ReV | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.Change_ReValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 15 (ACT:SSP0201_ShipmentChangeRequest.Change) |
| WK-SSP0201-0741 | X-ROW | SSP0201_ShipmentChangeRequest.ClearReque | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.ClearRequestInfo: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG/VALUE_CLEAR/VALUE_SET, 연결된 요소  |  | 10 (ACT:SSP0201_ShipmentChangeRequest.ClearR) |
| WK-SSP0201-0742 | X-ROW | SSP0201_ShipmentChangeRequest.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.Create) |
| WK-SSP0201-0743 | X-ROW | SSP0201_ShipmentChangeRequest.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.Define) |
| WK-SSP0201-0744 | X-ROW | SSP0201_ShipmentChangeRequest.DeleteData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.DeleteDataDrafting: 진입점 집계 10검사 — NOT_RUN:7 · PASS:3 (미실행 검사가 남아 판정필요) |  | 42 (ACT:SSP0201_ShipmentChangeRequest.Delete) |
| WK-SSP0201-0745 | X-ROW | SSP0201_ShipmentChangeRequest.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0201_ShipmentChangeRequest.FindBu) |
| WK-SSP0201-0746 | X-ROW | SSP0201_ShipmentChangeRequest.FindData_B | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.FindData_BOD: 진입점 집계 12검사 — NOT_RUN:7 · NOPATH:3 · REVIEW:1 · PASS:1 |  | 3 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0747 | X-ROW | SSP0201_ShipmentChangeRequest.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.FindData_Main: 진입점 집계 14검사 — NOT_RUN:12 · REVIEW:1 · PASS:1 |  | 5 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0748 | X-ROW | SSP0201_ShipmentChangeRequest.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.FindData_Main_Nonasy: 진입점 집계 13검사 — NOT_RUN:11 · REVIEW:1 · PASS:1 |  | 6 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0749 | X-ROW | SSP0201_ShipmentChangeRequest.FindData_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.FindData_Sub_Draft: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 6 (ACT:SSP0201_ShipmentChangeRequest.FindDa) |
| WK-SSP0201-0750 | X-ROW | SSP0201_ShipmentChangeRequest.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.Form_L) |
| WK-SSP0201-0751 | X-ROW | SSP0201_ShipmentChangeRequest.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetDay) |
| WK-SSP0201-0752 | X-ROW | SSP0201_ShipmentChangeRequest.GetErpIFCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpIFCheck: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0753 | X-ROW | SSP0201_ShipmentChangeRequest.GetErpSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.GetErpSoNoCnt: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.GetErp) |
| WK-SSP0201-0754 | X-ROW | SSP0201_ShipmentChangeRequest.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.InitControls: 진입점 집계 20검사 — NOT_RUN:20 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0201_ShipmentChangeRequest.InitCo) |
| WK-SSP0201-0755 | X-ROW | SSP0201_ShipmentChangeRequest.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.InitSpread: 진입점 집계 90검사 — NOT_RUN:90 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0201_ShipmentChangeRequest.InitSp) |
| WK-SSP0201-0756 | X-ROW | SSP0201_ShipmentChangeRequest.InsertButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.Insert) |
| WK-SSP0201-0757 | X-ROW | SSP0201_ShipmentChangeRequest.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.InsertRow: 진입점 집계 38검사 — NOT_RUN:20 · NOPATH:15 · TODO:3 (미실행 검사가 남아 판정필요) |  | 52 (ACT:SSP0201_ShipmentChangeRequest.Insert) |
| WK-SSP0201-0758 | X-ROW | SSP0201_ShipmentChangeRequest.NewNonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.NewNonSoNo: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 132 (ACT:SSP0201_ShipmentChangeRequest.NewNon) |
| WK-SSP0201-0759 | X-ROW | SSP0201_ShipmentChangeRequest.NonSoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.NonSoNo: 진입점 집계 6검사 — NOT_RUN:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 129 (ACT:SSP0201_ShipmentChangeRequest.NonSoN) |
| WK-SSP0201-0760 | X-ROW | SSP0201_ShipmentChangeRequest.SSP_Main_V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SSP_Main_Validation: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 128 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0761 | X-ROW | SSP0201_ShipmentChangeRequest.SSP_Main_V | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SSP_Main_Validation_: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SSP0201_ShipmentChangeRequest.SSP_Ma) |
| WK-SSP0201-0762 | X-ROW | SSP0201_ShipmentChangeRequest.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SaveButton: 진입점 집계 27검사 — NOT_RUN:18 · PASS:5 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SaveBu) |
| WK-SSP0201-0763 | X-ROW | SSP0201_ShipmentChangeRequest.SaveDataDr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SaveDataDrafting: 진입점 집계 17검사 — NOT_RUN:12 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0201_ShipmentChangeRequest.SaveDa) |
| WK-SSP0201-0764 | X-ROW | SSP0201_ShipmentChangeRequest.SetButtonV | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetButtonVisual: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0201_ShipmentChangeRequest.SetBut) |
| WK-SSP0201-0765 | X-ROW | SSP0201_ShipmentChangeRequest.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeControl: 진입점 집계 6검사 — REVIEW:2 · NOT_RUN:2 · NOPATH:1 · TODO:1 |  | 6 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0766 | X-ROW | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestInfo: 진입점 집계 20검사 — NOT_RUN:18 · REVIEW:2 |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0767 | X-ROW | SSP0201_ShipmentChangeRequest.SetChangeR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangeRequestSOGr: 진입점 집계 18검사 — NOT_RUN:16 · REVIEW:2 |  | 22 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0768 | X-ROW | SSP0201_ShipmentChangeRequest.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SetCha) |
| WK-SSP0201-0769 | X-ROW | SSP0201_ShipmentChangeRequest.SetMainSta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SetMainStatus: 진입점 집계 20검사 — NOT_RUN:18 · REVIEW:2 |  | 20 (ACT:SSP0201_ShipmentChangeRequest.SetMai) |
| WK-SSP0201-0770 | X-ROW | SSP0201_ShipmentChangeRequest.SoNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SoNo: 진입점 집계 6검사 — NOT_RUN:5 · PASS:1 (미실행 검사가 남아 판정필요) |  | 145 (ACT:SSP0201_ShipmentChangeRequest.SoNo A) |
| WK-SSP0201-0771 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CellClick: 진입점 집계 23검사 — NOT_RUN:11 · NOPATH:11 · TODO:1 (미실행 검사가 남아 판정필요) |  | 75 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0772 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CellDoubleCl: 진입점 집계 23검사 — NOT_RUN:15 · NOPATH:8 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0773 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_ClipboardPas: 진입점 집계 13검사 — NOT_RUN:10 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0774 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Co | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_ComboSelChan: 진입점 집계 94검사 — NOT_RUN:77 · NOPATH:13 · TODO:4 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0775 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Cu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_CursorChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0776 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_Ed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_EditChange: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 52 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0777 | X-ROW | SSP0201_ShipmentChangeRequest.SpdMain_To | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0201_ShipmentChangeRequest.SpdMai) |
| WK-SSP0201-0778 | X-ROW | SSP0201_ShipmentChangeRequest.btnItemId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0201_ShipmentChangeRequest.btnIte) |
| WK-SSP0201-0779 | X-ROW | SSP0201_ShipmentChangeRequest.checkRequi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.checkRequired: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SSP0201_ShipmentChangeRequest.checkR) |
| WK-SSP0201-0780 | X-ROW | SSP0201_ShipmentChangeRequest.chkERPIFBl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.chkERPIFBlockYn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0201_ShipmentChangeRequest.chkERP) |
| WK-SSP0201-0781 | X-ROW | SSP0201_ShipmentChangeRequest.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.clbDivision_ID_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0201_ShipmentChangeRequest.clbDiv) |
| WK-SSP0201-0782 | X-ROW | SSP0201_ShipmentChangeRequest.setEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.setEndCustomer: 진입점 집계 16검사 — NOT_RUN:11 · NOPATH:3 · REVIEW:2 |  | 3 (ACT:SSP0201_ShipmentChangeRequest.setEnd) |
| WK-SSP0201-0783 | X-ROW | SSP0201_ShipmentChangeRequest.shtMain_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0201_ShipmentChangeRequest.shtMain_Change: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 65 (ACT:SSP0201_ShipmentChangeRequest.shtMai) |
| WK-SSP0201-0784 | X-ROW | btnNew(R10)/btnCancel(R9)/btnChangeRe2(R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — btnNew(R10)/btnCancel(R9)/btnChangeRe2(R14): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (btnNew(R10)/btnCancel(R9)/btnChangeRe2(R) |
| WK-SSP0201-0785 | X-ROW | clbDivision_ID (Division, "40"고정 disable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbDivision_ID (Division, "40"고정 disabled R3): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbDivision_ID (Division, "40"고정 disable) |
| WK-SSP0201-0786 | X-ROW | clbFromSite / clbToSite (다중+ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbFromSite / clbToSite (다중+ALL): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbFromSite / clbToSite (다중+ALL)) |
| WK-SSP0201-0787 | X-ROW | dataSource (3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — dataSource (3): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (dataSource (3)) |
| WK-SSP0201-0788 | X-ROW | main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — main: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SSP0201-0789 | X-ROW | main 단일 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — main 단일 헤더: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (main 단일 헤더) |
| WK-SSP0201-0790 | X-ROW | span (28) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — span (28): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (span (28)) |
| WK-SSP0201-0791 | X-ROW | sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — sub: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (sub) |
| WK-SSP0201-0792 | X-ROW | sub 2단 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — sub 2단 헤더: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (sub 2단 헤더) |
| WK-SSP0201-0793 | X-ROW | txtRequest (Model, 다건) + btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtRequest (Model, 다건) + btnItemId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtRequest (Model, 다건) + btnItemId) |
| WK-SSP0201-0794 | X-ROW | txtSoNo (ERP SO No, 다건) / txtConfirmId ( | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtSoNo (ERP SO No, 다건) / txtConfirmId (Confirm ID: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtSoNo (ERP SO No, 다건) / txtConfirmId () |
| WK-SSP0201-0795 | X-ROW | txtTitle/txtApproval/txtAppDeptName/cboC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtTitle/txtApproval/txtAppDeptName/cboChangeReaso: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtTitle/txtApproval/txtAppDeptName/cboC) |
| WK-SSP0201-0796 | X-ROW | visible (18) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — visible (18): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (visible (18)) |
| WK-SSP0201-0797 | G5 | P-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — P-3: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (P-3) |
| WK-SSP0201-0798 | G5 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — P-4: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
| WK-SSP0201-0799 | H6 | P-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — P-3: 행 집계 — H6 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (P-3) |
| WK-SSP0201-0800 | H6 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — P-4: 행 집계 — H6 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
| WK-SSP0201-0801 | M4 | P-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — P-3: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (P-3) |
| WK-SSP0201-0802 | M4 | P-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — P-4: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (P-4) |
