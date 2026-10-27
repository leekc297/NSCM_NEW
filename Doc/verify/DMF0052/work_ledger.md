# 작업 원장 — DMF0052 · 2026-10-26 12:51

> 검사 인스턴스 276건 중 PASS·NA 58건 외 **218건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 32 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 73 | 실행 → PASS |
| W7 | 기대값 확정 | 112 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 111 · E2E 73 · 하네스 33 · 대조표 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 17건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 34 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| M4 | POPUP |  |  |  |  |  | 9 | 6 |  |  | 팝업 선택값 반영 |
| DB-SYN | DB |  |  |  |  | 13 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 8 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 | 3 | 6 |  |  | 팝업 표준·열림 |
| F4 | DB |  |  |  |  |  | 13 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A5 | DESIGN |  |  |  |  |  | 2 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 12 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 1 | 12 |  |  | 라벨 명칭 |
| A6 | GEN |  |  |  |  |  | 13 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 13 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 5 | 2 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 2 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  |  | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 1 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| E4 | EDIT |  |  |  |  |  | 4 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  | 1 |  |  |  |  | ALL 옵션·다중선택 사양 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| E3 | EDIT |  |  |  |  |  | 1 |  |  |  | 필수 입력 검증 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0052-0001 | B3 | P | 하네스(검증 엔진 _trace.spec.ts) + 구현 확인(TO-BE  | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 P | 없음 | 1 (D00-P-001) |

## W5 검사기 연결 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0052-0002 | B1 | clbEDISender / EDI Sender / EDISender | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbEDISender / EDI Sender / EDISender | 있음(FE 소스) | 1 (D00-1-015) |
| WK-DMF0052-0003 | B2 | clbEDISender / EDI Sender / EDISender | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbEDISender / EDI Sender / EDISender | 있음(FE 소스) | 1 (D00-1-015) |
| WK-DMF0052-0004 | B4 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL P | 없음 | 1 (D00-P-001) |
| WK-DMF0052-0005 | B4 | clbEDISender / EDI Sender / EDISender | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbEDISender / EDI Sender / EDISender | 있음(FE 소스) | 1 (D00-1-015) |
| WK-DMF0052-0006 | B6 | clbEDISender / EDI Sender / EDISender | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbEDISender / EDI Sender / EDISender | 있음(FE 소스) | 1 (D00-1-015) |
| WK-DMF0052-0007 | DB-SYN | DMF0052_GET_DETAIL_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_DETAIL_DATA | 없음(PROC_M 대응 없음) | 3 (D00-4-004 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0008 | DB-SYN | DMF0052_GET_ERP_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_ERP_DATA | 없음(PROC_M 대응 없음) | 3 (D00-4-005 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0009 | DB-SYN | DMF0052_GET_PJT_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_PJT_DATA | 없음(PROC_M 대응 없음) | 4 (D00-4-002 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0010 | DB-SYN | DMF0052_GET_SITE_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_SITE_POPUP | 없음(PROC_M 대응 없음) | 5 (D00-4-008 D00-P-001 ACT:DMF0052_GSCMData) |
| WK-DMF0052-0011 | DB-SYN | DMF0052_GET_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 7 (ACT:DMF0052_EDISummary.FindData_ERPData:) |
| WK-DMF0052-0012 | DB-SYN | DMF0052_GET_STATUS_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_STATUS_DATA | 없음(PROC_M 대응 없음) | 4 (D00-4-003 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0013 | DB-SYN | DMF0052_GET_SUMMARY_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0052_GET_SUMMARY_DATA | 없음(PROC_M 대응 없음) | 4 (D00-4-001 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0014 | DB-SYN | P_DMF0052_GET_DETAIL_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_DETAIL_DATA | 없음(PROC_M 대응 없음) | 1 (D00-4-004) |
| WK-DMF0052-0015 | DB-SYN | P_DMF0052_GET_ERP_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_ERP_DATA | 없음(PROC_M 대응 없음) | 1 (D00-4-005) |
| WK-DMF0052-0016 | DB-SYN | P_DMF0052_GET_PJT_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_PJT_DATA | 없음(PROC_M 대응 없음) | 1 (D00-4-002) |
| WK-DMF0052-0017 | DB-SYN | P_DMF0052_GET_SITE_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_SITE_POPUP | 없음(PROC_M 대응 없음) | 1 (D00-4-008) |
| WK-DMF0052-0018 | DB-SYN | P_DMF0052_GET_STATUS_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_STATUS_DATA | 없음(PROC_M 대응 없음) | 1 (D00-4-003) |
| WK-DMF0052-0019 | DB-SYN | P_DMF0052_GET_SUMMARY_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0052_GET_SUMMARY_DATA | 없음(PROC_M 대응 없음) | 1 (D00-4-001) |
| WK-DMF0052-0020 | G03-WIRE | DMF0052 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0052 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:DMF0052_EDISummary..ctor ACT:DMF0052) |
| WK-DMF0052-0021 | G5 | DMF0052_GSCMDataPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0052_GSCMDataPopup | 판단불가(대상 단위 POPUP) | 4 (D00-P-001 ACT:DMF0052_EDISummary.spdData) |
| WK-DMF0052-0022 | G5 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL P | 없음 | 1 (D00-P-001) |
| WK-DMF0052-0023 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (D00-1-013 D00-2-005) |
| WK-DMF0052-0024 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 2 (D00-1-012 D00-2-004) |
| WK-DMF0052-0025 | G5 | btnRefresh | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnRefresh | 있음(FE 소스) | 5 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0026 | G5 | drpPeriod / Period / From / To / 기간 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND drpPeriod / Period / From / To / 기간 | 있음(FE 소스) | 2 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0027 | G5 | txtItemId / Model / Nickname / Item Id / | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Nickname / Item Id / Model/Nic | 있음(FE 소스) | 3 (D00-1-010 ACT:DMF0052_EDISummary.spdPjt_) |
| WK-DMF0052-0028 | G5 | txtProject / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project | 있음(FE 소스) | 1 (D00-1-011) |
| WK-DMF0052-0029 | H6 | DMF0052_GSCMDataPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0052_GSCMDataPopup | 판단불가(대상 단위 POPUP) | 4 (D00-P-001 ACT:DMF0052_EDISummary.spdData) |
| WK-DMF0052-0030 | H6 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL P | 없음 | 1 (D00-P-001) |
| WK-DMF0052-0031 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (D00-1-013 D00-2-005) |
| WK-DMF0052-0032 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 2 (D00-1-012 D00-2-004) |
| WK-DMF0052-0033 | H6 | btnRefresh | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnRefresh | 있음(FE 소스) | 5 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |

## W6 검증 실행 (73)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0052-0034 | J2 | DMF0052 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0052 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 40 (D00-4-008 D00-P-001 ACT:DMF0052_EDISumma) |
| WK-DMF0052-0035 | C1 | chkToday / Today | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkToday / Today · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-DMF0052-0036 | C1 | clbEDISender / EDI Sender / EDISender | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEDISender / EDI Sender / EDISender · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0052_EDISummary.InitControls:142:) |
| WK-DMF0052-0037 | C4 | chkToday / Today | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkToday / Today · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-DMF0052-0038 | K4 | DMF0052 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0052 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 38 (ACT:DMF0052_EDISummary.BtnRefresh_Click ) |
| WK-DMF0052-0039 | F4 | DMF0052_GET_DETAIL_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_DETAIL_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 36 (D00-4-004 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0040 | F4 | DMF0052_GET_ERP_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_ERP_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 25 (D00-4-005 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0041 | F4 | DMF0052_GET_PJT_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_PJT_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 42 (D00-4-002 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0042 | F4 | DMF0052_GET_SITE_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_SITE_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 26 (D00-4-008 D00-P-001 ACT:DMF0052_GSCMData) |
| WK-DMF0052-0043 | F4 | DMF0052_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 149 (ACT:DMF0052_EDISummary.FindButton ACT:DM) |
| WK-DMF0052-0044 | F4 | DMF0052_GET_STATUS_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_STATUS_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 33 (D00-4-003 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0045 | F4 | DMF0052_GET_SUMMARY_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0052_GET_SUMMARY_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 47 (D00-4-001 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0046 | F4 | P_DMF0052_GET_DETAIL_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_DETAIL_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-004) |
| WK-DMF0052-0047 | F4 | P_DMF0052_GET_ERP_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_ERP_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-005) |
| WK-DMF0052-0048 | F4 | P_DMF0052_GET_PJT_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_PJT_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-002) |
| WK-DMF0052-0049 | F4 | P_DMF0052_GET_SITE_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_SITE_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-008) |
| WK-DMF0052-0050 | F4 | P_DMF0052_GET_STATUS_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_STATUS_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-003) |
| WK-DMF0052-0051 | F4 | P_DMF0052_GET_SUMMARY_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0052_GET_SUMMARY_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4-001) |
| WK-DMF0052-0052 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0053 | A5 | P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — P · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (D00-P-001) |
| WK-DMF0052-0054 | G4 | chkToday / Today | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkToday / Today · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (D00-1-009 ACT:DMF0052_EDISummary.DefineP) |
| WK-DMF0052-0055 | G4 | clbEDISender / EDI Sender / EDISender | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEDISender / EDI Sender / EDISender · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-015 ACT:DMF0052_EDISummary.InitCon) |
| WK-DMF0052-0056 | G4 | drpPeriod / Period / From / To / 기간 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (D00-1-014 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0057 | G4 | txtItemId / Model / Nickname / Item Id / | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-010) |
| WK-DMF0052-0058 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-DMF0052-0059 | H2 | P | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — P · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (D00-P-001) |
| WK-DMF0052-0060 | H4 | DMF0052 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0052 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:DMF0052_GSCMDataPopup.spdMain_TopCha) |
| WK-DMF0052-0061 | H5 | P | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — P · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (D00-P-001) |
| WK-DMF0052-0062 | I1 | DMF0052 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0052 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 3 (ACT:DMF0052_EDISummary.FindData_Main:283) |
| WK-DMF0052-0063 | SC1 | DMF0052 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0052 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 5 (D00-1-009 D00-1-010 D00-1-011 D00-1-014 ) |
| WK-DMF0052-0064 | E3 | P | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — P · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 1 (D00-P-001) |
| WK-DMF0052-0065 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0052_EDISummary.FindData_Main:283) |
| WK-DMF0052-0066 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0052_EDISummary.FindData_Main:292) |
| WK-DMF0052-0067 | E4 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — P · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-P-001) |
| WK-DMF0052-0068 | E4 | drpPeriod / Period / From / To / 기간 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 1 (ACT:DMF0052_EDISummary.FindData_Main:298) |
| WK-DMF0052-0069 | A10 | DMF0052 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0052 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 68 (ACT:DMF0052_EDISummary.DefineProperty AC) |
| WK-DMF0052-0070 | A6 | DMF0052_GET_DETAIL_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_DETAIL_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 36 (D00-4-004 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0071 | A6 | DMF0052_GET_ERP_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_ERP_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 25 (D00-4-005 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0072 | A6 | DMF0052_GET_PJT_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_PJT_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 42 (D00-4-002 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0073 | A6 | DMF0052_GET_SITE_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_SITE_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 26 (D00-4-008 D00-P-001 ACT:DMF0052_GSCMData) |
| WK-DMF0052-0074 | A6 | DMF0052_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 147 (ACT:DMF0052_EDISummary.FindButton ACT:DM) |
| WK-DMF0052-0075 | A6 | DMF0052_GET_STATUS_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_STATUS_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 33 (D00-4-003 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0076 | A6 | DMF0052_GET_SUMMARY_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0052_GET_SUMMARY_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 47 (D00-4-001 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0077 | A6 | P_DMF0052_GET_DETAIL_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_DETAIL_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 1 (D00-4-004) |
| WK-DMF0052-0078 | A6 | P_DMF0052_GET_ERP_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_ERP_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (D00-4-005) |
| WK-DMF0052-0079 | A6 | P_DMF0052_GET_PJT_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_PJT_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (D00-4-002) |
| WK-DMF0052-0080 | A6 | P_DMF0052_GET_SITE_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_SITE_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (D00-4-008) |
| WK-DMF0052-0081 | A6 | P_DMF0052_GET_STATUS_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_STATUS_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 1 (D00-4-003) |
| WK-DMF0052-0082 | A6 | P_DMF0052_GET_SUMMARY_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0052_GET_SUMMARY_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 1 (D00-4-001) |
| WK-DMF0052-0083 | G1 | chkToday / Today | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkToday / Today · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-DMF0052-0084 | G1 | clbEDISender / EDI Sender / EDISender | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEDISender / EDI Sender / EDISender · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (D00-1-015 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0085 | G1 | drpPeriod / Period / From / To / 기간 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 14 (D00-1-014 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0086 | G1 | txtItemId / Model / Nickname / Item Id / | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 11 (D00-1-010 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0087 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 13 (D00-1-011 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0088 | G6 | chkToday / Today | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkToday / Today · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-009 ACT:DMF0052_EDISummary.DefineP) |
| WK-DMF0052-0089 | G6 | clbEDISender / EDI Sender / EDISender | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEDISender / EDI Sender / EDISender · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-015 ACT:DMF0052_EDISummary.InitCon) |
| WK-DMF0052-0090 | G6 | drpPeriod / Period / From / To / 기간 | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-014 ACT:DMF0052_EDISummary.InitCon) |
| WK-DMF0052-0091 | G6 | txtItemId / Model / Nickname / Item Id / | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-010) |
| WK-DMF0052-0092 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-011) |
| WK-DMF0052-0093 | X-REOPEN | DMF0052 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0052 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:DMF0052_EDISummary.Dispose ACT:DMF00) |
| WK-DMF0052-0094 | H6 | drpPeriod / Period / From / To / 기간 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0095 | H6 | txtItemId / Model / Nickname / Item Id / | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (D00-1-010 ACT:DMF0052_EDISummary.spdPjt_) |
| WK-DMF0052-0096 | H6 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-DMF0052-0097 | M3 | DMF0052_GSCMDataPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0052_GSCMDataPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 10 (ACT:DMF0052_GSCMDataPopup..ctor ACT:DMF0) |
| WK-DMF0052-0098 | M4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0099 | M4 | DMF0052_GSCMDataPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0052_GSCMDataPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-P-001 ACT:DMF0052_EDISummary.spdData) |
| WK-DMF0052-0100 | M4 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — P · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-P-001) |
| WK-DMF0052-0101 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-013 D00-2-005) |
| WK-DMF0052-0102 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-012 D00-2-004) |
| WK-DMF0052-0103 | M4 | btnRefresh | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnRefresh · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0104 | M4 | drpPeriod / Period / From / To / 기간 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0105 | M4 | txtItemId / Model / Nickname / Item Id / | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Nickname / Item Id / Model/Nic · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요:  |  | 3 (D00-1-010 ACT:DMF0052_EDISummary.spdPjt_) |
| WK-DMF0052-0106 | M4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-011) |

## W7 기대값 확정 (112)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0052-0107 | B3 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4-008: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0108 | B3 | DMF0052_EDISummary.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0052_EDISummary.GetEdiSender: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0052_EDISummary.GetEdiSender:779:) |
| WK-DMF0052-0109 | B3 | DMF0052_EDISummary.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0052_EDISummary.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.GetSpdTitle:694:2) |
| WK-DMF0052-0110 | B4 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4-008: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0111 | B4 | DMF0052_EDISummary.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0052_EDISummary.GetEdiSender: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0052_EDISummary.GetEdiSender:779:) |
| WK-DMF0052-0112 | B4 | DMF0052_EDISummary.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0052_EDISummary.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.GetSpdTitle:694:2) |
| WK-DMF0052-0113 | DB-SYN | DMF0052_EDISummary.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0052_EDISummary.GetEdiSender: 진입점 집계 — DB-SYN 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0052_EDISummary.GetEdiSender:783:) |
| WK-DMF0052-0114 | F4 | DMF0052_EDISummary.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0052_EDISummary.GetEdiSender: 진입점 집계 — F4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0052_EDISummary.GetEdiSender:783:) |
| WK-DMF0052-0115 | A5 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-003: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-DMF0052-0116 | A5 | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-005: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-005) |
| WK-DMF0052-0117 | A5 | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-027: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-027) |
| WK-DMF0052-0118 | A5 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-029: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-DMF0052-0119 | A5 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-006: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-DMF0052-0120 | A5 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-001: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0121 | A5 | D00-5-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-002: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-002) |
| WK-DMF0052-0122 | A5 | D00-5-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-003: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-003) |
| WK-DMF0052-0123 | A5 | D00-5-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-005: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-005) |
| WK-DMF0052-0124 | A5 | D00-5-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-006: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-006) |
| WK-DMF0052-0125 | A5 | D00-5-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-5-007: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-007) |
| WK-DMF0052-0126 | A5 | DMF0052_EDISummary.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0052_EDISummary.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.CreateSpread:158:) |
| WK-DMF0052-0127 | H2 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-003: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-DMF0052-0128 | H2 | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-005: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-005) |
| WK-DMF0052-0129 | H2 | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-027: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-027) |
| WK-DMF0052-0130 | H2 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-029: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-DMF0052-0131 | H2 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-006: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-DMF0052-0132 | H2 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-001: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0133 | H2 | D00-5-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-002: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-002) |
| WK-DMF0052-0134 | H2 | D00-5-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-003: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-003) |
| WK-DMF0052-0135 | H2 | D00-5-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-005: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-005) |
| WK-DMF0052-0136 | H2 | D00-5-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-006: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-006) |
| WK-DMF0052-0137 | H2 | D00-5-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-5-007: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-007) |
| WK-DMF0052-0138 | H2 | DMF0052_EDISummary.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0052_EDISummary.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.CreateSpread:158:) |
| WK-DMF0052-0139 | H5 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-003: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-DMF0052-0140 | H5 | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-005: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-005) |
| WK-DMF0052-0141 | H5 | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-027: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-027) |
| WK-DMF0052-0142 | H5 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-029: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-DMF0052-0143 | H5 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-006: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-DMF0052-0144 | H5 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-001: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0145 | H5 | D00-5-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-002: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-002) |
| WK-DMF0052-0146 | H5 | D00-5-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-003: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-003) |
| WK-DMF0052-0147 | H5 | D00-5-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-005: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-005) |
| WK-DMF0052-0148 | H5 | D00-5-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-006: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-006) |
| WK-DMF0052-0149 | H5 | D00-5-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-5-007: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-007) |
| WK-DMF0052-0150 | H5 | DMF0052_EDISummary.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0052_EDISummary.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.CreateSpread:158:) |
| WK-DMF0052-0151 | X-REASON | D00-4-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-006 §4 DM.DMF0052_GET_SPREAD_TITLE / DMF0052_GET_SPREAD_TITLE  그리드 헤더 메타 → /admin/menu/{MENU}/column(SCM_ |  | 1 (D00-4-006) |
| WK-DMF0052-0152 | A1 | DMF0052_GET_DETAIL_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_DETAIL_DATA: 골든 비교 케이스 없음(DMF0052_GET_DETAIL_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 36 (D00-4-004 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0153 | A1 | DMF0052_GET_ERP_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_ERP_DATA: 골든 비교 케이스 없음(DMF0052_GET_ERP_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 25 (D00-4-005 ACT:DMF0052_EDISummary.FindDat) |
| WK-DMF0052-0154 | A1 | DMF0052_GET_PJT_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_PJT_DATA: 골든 비교 케이스 없음(DMF0052_GET_PJT_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 42 (D00-4-002 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0155 | A1 | DMF0052_GET_SITE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_SITE_POPUP: 골든 비교 케이스 없음(DMF0052_GET_SITE_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 26 (D00-4-008 D00-P-001 ACT:DMF0052_GSCMData) |
| WK-DMF0052-0156 | A1 | DMF0052_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_SPREAD_TITLE: 골든 비교 케이스 없음(DMF0052_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 147 (ACT:DMF0052_EDISummary.FindButton ACT:DM) |
| WK-DMF0052-0157 | A1 | DMF0052_GET_STATUS_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_STATUS_DATA: 골든 비교 케이스 없음(DMF0052_GET_STATUS_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 33 (D00-4-003 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0158 | A1 | DMF0052_GET_SUMMARY_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0052_GET_SUMMARY_DATA: 골든 비교 케이스 없음(DMF0052_GET_SUMMARY_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 47 (D00-4-001 ACT:DMF0052_EDISummary.FindBut) |
| WK-DMF0052-0159 | A1 | P_DMF0052_GET_DETAIL_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_DETAIL_DATA: 골든 비교 케이스 없음(P_DMF0052_GET_DETAIL_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (D00-4-004) |
| WK-DMF0052-0160 | A1 | P_DMF0052_GET_ERP_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_ERP_DATA: 골든 비교 케이스 없음(P_DMF0052_GET_ERP_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-005) |
| WK-DMF0052-0161 | A1 | P_DMF0052_GET_PJT_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_PJT_DATA: 골든 비교 케이스 없음(P_DMF0052_GET_PJT_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-002) |
| WK-DMF0052-0162 | A1 | P_DMF0052_GET_SITE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_SITE_POPUP: 골든 비교 케이스 없음(P_DMF0052_GET_SITE_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (D00-4-008) |
| WK-DMF0052-0163 | A1 | P_DMF0052_GET_STATUS_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_STATUS_DATA: 골든 비교 케이스 없음(P_DMF0052_GET_STATUS_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 1 (D00-4-003) |
| WK-DMF0052-0164 | A1 | P_DMF0052_GET_SUMMARY_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0052_GET_SUMMARY_DATA: 골든 비교 케이스 없음(P_DMF0052_GET_SUMMARY_DATA — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (D00-4-001) |
| WK-DMF0052-0165 | G1 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4-008: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0166 | G1 | D00-P-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-P-001: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-P-001) |
| WK-DMF0052-0167 | X-ROW | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-008) |
| WK-DMF0052-0168 | X-ROW | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-002) |
| WK-DMF0052-0169 | X-ROW | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-008) |
| WK-DMF0052-0170 | X-ROW | DMF0052_EDISummary.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.CreateSpread) |
| WK-DMF0052-0171 | X-ROW | DMF0052_EDISummary.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0052_EDISummary.DefineProperty:15) |
| WK-DMF0052-0172 | X-ROW | DMF0052_EDISummary.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindButton: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:4 |  | 1 (ACT:DMF0052_EDISummary.FindButton) |
| WK-DMF0052-0173 | X-ROW | DMF0052_EDISummary.FindData_ERPData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindData_ERPData: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:2 · NOPATH:2 |  | 1 (ACT:DMF0052_EDISummary.FindData_ERPData:) |
| WK-DMF0052-0174 | X-ROW | DMF0052_EDISummary.FindData_GSCMData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindData_GSCMData: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:2 · NOPATH:2 |  | 7 (ACT:DMF0052_EDISummary.FindData_GSCMData) |
| WK-DMF0052-0175 | X-ROW | DMF0052_EDISummary.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindData_Main: 진입점 집계 18검사 — NOT_RUN:14 · REVIEW:2 · NOPATH:2 |  | 6 (ACT:DMF0052_EDISummary.FindData_Main:272) |
| WK-DMF0052-0176 | X-ROW | DMF0052_EDISummary.FindData_Pjt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindData_Pjt: 진입점 집계 13검사 — NOT_RUN:9 · REVIEW:2 · NOPATH:2 |  | 8 (ACT:DMF0052_EDISummary.FindData_Pjt:356:) |
| WK-DMF0052-0177 | X-ROW | DMF0052_EDISummary.FindData_Status | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.FindData_Status: 진입점 집계 13검사 — NOT_RUN:9 · REVIEW:2 · NOPATH:2 |  | 3 (ACT:DMF0052_EDISummary.FindData_Status:4) |
| WK-DMF0052-0178 | X-ROW | DMF0052_EDISummary.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.Form_Load) |
| WK-DMF0052-0179 | X-ROW | DMF0052_EDISummary.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.GetEdiSender: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.GetEdiSender) |
| WK-DMF0052-0180 | X-ROW | DMF0052_EDISummary.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.GetSpdTitle: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.GetSpdTitle) |
| WK-DMF0052-0181 | X-ROW | DMF0052_EDISummary.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.InitControls: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0052_EDISummary.InitControls:142:) |
| WK-DMF0052-0182 | X-ROW | DMF0052_EDISummary.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.InitSpread) |
| WK-DMF0052-0183 | X-ROW | DMF0052_EDISummary.InitSpreadFooterSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.InitSpreadFooterS) |
| WK-DMF0052-0184 | X-ROW | DMF0052_EDISummary.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.btnItemId_Click:7) |
| WK-DMF0052-0185 | X-ROW | DMF0052_EDISummary.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.btnProject_Click:) |
| WK-DMF0052-0186 | X-ROW | DMF0052_EDISummary.btnRefresh_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.btnRefresh_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0052_EDISummary.btnRefresh_Click:) |
| WK-DMF0052-0187 | X-ROW | DMF0052_EDISummary.chkToday_CheckedChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.chkToday_CheckedChanged: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_EDISummary.chkToday_CheckedC) |
| WK-DMF0052-0188 | X-ROW | DMF0052_EDISummary.spdData_ActiveSheetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.spdData_ActiveSheetChanging: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/STATE/UI_PROP, 연결된 요소 검사 없음 |  | 9 (ACT:DMF0052_EDISummary.spdData_ActiveShe) |
| WK-DMF0052-0189 | X-ROW | DMF0052_EDISummary.spdData_CellDoubleCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.spdData_CellDoubleClick: 진입점 집계 9검사 — REVIEW:3 · NOPATH:3 · NOT_RUN:3 |  | 3 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0190 | X-ROW | DMF0052_EDISummary.spdPjt_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_EDISummary.spdPjt_CellDoubleClick: 진입점 집계 11검사 — NOT_RUN:5 · REVIEW:3 · NOPATH:3 |  | 10 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0191 | X-ROW | DMF0052_GSCMDataPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0052_GSCMDataPopup..ctor:73:1 ACT) |
| WK-DMF0052-0192 | X-ROW | DMF0052_GSCMDataPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_GSCMDataPopup.CreateSpread A) |
| WK-DMF0052-0193 | X-ROW | DMF0052_GSCMDataPopup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0052_GSCMDataPopup.DefineProperty) |
| WK-DMF0052-0194 | X-ROW | DMF0052_GSCMDataPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0052_GSCMDataPopup.Dispose:16:1 A) |
| WK-DMF0052-0195 | X-ROW | DMF0052_GSCMDataPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:DMF0052_GSCMDataPopup.FindButton ACT) |
| WK-DMF0052-0196 | X-ROW | DMF0052_GSCMDataPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.FindData: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · NOPATH:1 |  | 22 (ACT:DMF0052_GSCMDataPopup.FindData ACT:D) |
| WK-DMF0052-0197 | X-ROW | DMF0052_GSCMDataPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0052_GSCMDataPopup.Form_Load ACT:) |
| WK-DMF0052-0198 | X-ROW | DMF0052_GSCMDataPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0052_GSCMDataPopup.InitSpread ACT) |
| WK-DMF0052-0199 | X-ROW | DMF0052_GSCMDataPopup.btnButtonList_UsrB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.btnButtonList_UsrButtonList_: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0052_GSCMDataPopup.btnButtonList_) |
| WK-DMF0052-0200 | X-ROW | DMF0052_GSCMDataPopup.spdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0052_GSCMDataPopup.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0052_GSCMDataPopup.spdMain_TopCha) |
| WK-DMF0052-0201 | G5 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-001: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-DMF0052-0202 | G5 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-007: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-DMF0052-0203 | G5 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4-008: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0204 | G5 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-5-001: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0205 | G5 | DMF0052_EDISummary.spdData_CellDoubleCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0052_EDISummary.spdData_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0206 | G5 | DMF0052_EDISummary.spdPjt_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0052_EDISummary.spdPjt_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0207 | H6 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-001: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-DMF0052-0208 | H6 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-007: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-DMF0052-0209 | H6 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4-008: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0210 | H6 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-5-001: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0211 | H6 | DMF0052_EDISummary.spdData_CellDoubleCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0052_EDISummary.spdData_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0212 | H6 | DMF0052_EDISummary.spdPjt_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0052_EDISummary.spdPjt_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
| WK-DMF0052-0213 | M4 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-001: 행 집계 — M4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-DMF0052-0214 | M4 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-007: 행 집계 — M4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-DMF0052-0215 | M4 | D00-4-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4-008: 행 집계 — M4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4-008) |
| WK-DMF0052-0216 | M4 | D00-5-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-5-001: 행 집계 — M4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-5-001) |
| WK-DMF0052-0217 | M4 | DMF0052_EDISummary.spdData_CellDoubleCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0052_EDISummary.spdData_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0052_EDISummary.spdData_CellDoubl) |
| WK-DMF0052-0218 | M4 | DMF0052_EDISummary.spdPjt_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0052_EDISummary.spdPjt_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0052_EDISummary.spdPjt_CellDouble) |
