# 작업 원장 — DMF0043 · 2026-10-26 12:50

> 검사 인스턴스 426건 중 PASS·NA 13건 외 **413건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 19 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 156 | 실행 → PASS |
| W7 | 기대값 확정 | 237 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 237 · E2E 156 · 하네스 20
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 12건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 94 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| F4 | DB |  |  |  |  |  | 21 | 6 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-LOC | GEN |  |  |  |  |  |  | 27 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 22 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 17 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 14 | 5 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A6 | GEN |  |  |  |  |  | 17 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A5 | DESIGN |  |  |  |  |  | 9 | 7 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 11 | 5 |  |  | 라벨 명칭 |
| DB-SYN | DB |  |  |  |  | 10 |  | 4 |  |  | BE 계정 시노님·권한·대상 객체 |
| H2 | DESIGN |  |  |  |  |  | 3 | 10 |  |  | 배경·글자색 규칙 |
| D3 | EDIT |  |  |  |  |  | 4 | 8 |  |  | 행 값 기반 조건부 잠금 |
| C3 | CASCADE |  |  |  |  |  | 3 | 7 |  |  | 연쇄 자동 채움 |
| C1 | CASCADE |  |  |  |  |  | 9 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  |  | 8 |  |  |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  |  |  |  | 3 | 5 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G6 | GEN |  |  |  |  |  | 8 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C2 | CASCADE |  |  |  |  |  | 1 | 5 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 1 | 5 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| E3 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 필수 입력 검증 |
| M3 | POPUP |  |  |  |  |  | 6 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| B3 | COMBO |  |  |  | 1 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 3 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 |  | 1 |  |  | 팝업 표준·열림 |
| C4 | CASCADE |  |  |  |  |  | 4 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| D4 | EDIT |  |  |  |  |  | 1 | 3 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | EDIT |  |  |  |  |  | 1 | 3 |  |  | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  | 3 | 1 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0043-0001 | B3 | DM_BIZ_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DM_BIZ_TYPE | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0043_Contribute_View.InitControls) |

## W5 검사기 연결 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0043-0002 | B4 | DM_BIZ_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DM_BIZ_TYPE | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0003 | F2 | DMF0043 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0043 화면 | 판단불가(대상 단위 SCREEN) | 143 (Protected override (§G) 5 7 ACT:DMF0043_) |
| WK-DMF0043-0004 | F6 | DMF0043 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0043 화면 | 판단불가(대상 단위 SCREEN) | 141 (5 ACT:DMF0043_ContributeRatePopup.SaveBu) |
| WK-DMF0043-0005 | DB-SYN | DM0000_GET_COMMON_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0000_GET_COMMON_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0043_VersionPopup.GetSpdTitle:318) |
| WK-DMF0043-0006 | DB-SYN | P_DMF0043_MAIN_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_MAIN_GET | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0007 | DB-SYN | P_DMF0043_MAIN_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_MAIN_SAVE | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0008 | DB-SYN | P_DMF0043_MAIN_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_MAIN_TITLE | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0009 | DB-SYN | P_DMF0043_RATE_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_RATE_POPUP | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0010 | DB-SYN | P_DMF0043_VERSION_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_VERSION_GET | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0011 | DB-SYN | P_DMF0043_VERSION_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_VERSION_POPUP | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0012 | DB-SYN | P_DMF0043_VERSION_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_VERSION_SAVE | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0013 | DB-SYN | P_DMF0043_YEAR_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DMF0043_YEAR_POPUP | 없음(PROC_M 대응 없음) | 0 () |
| WK-DMF0043-0014 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0043_Contribute_Main.GetLookupDat) |
| WK-DMF0043-0015 | G5 | DMF0043_ContributeRatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0043_ContributeRatePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0043_Contribute_Main.btnCutOff_Cl) |
| WK-DMF0043-0016 | G5 | DMF0043_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0043_VersionPopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0043_Contribute_View.btnSPVer_Cli) |
| WK-DMF0043-0017 | G5 | btnCutOff | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnCutOff | 없음 | 0 () |
| WK-DMF0043-0018 | H6 | DMF0043_ContributeRatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0043_ContributeRatePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0043_Contribute_Main.btnCutOff_Cl) |
| WK-DMF0043-0019 | H6 | DMF0043_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0043_VersionPopup | 판단불가(대상 단위 POPUP) | 2 (ACT:DMF0043_Contribute_View.btnSPVer_Cli) |
| WK-DMF0043-0020 | H6 | btnCutOff | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnCutOff | 없음 | 0 () |

## W6 검증 실행 (156)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0043-0021 | J2 | DMF0043 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0043 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 67 (작성·갱신 Protected override (§G) 1 2 3 4 5 ) |
| WK-DMF0043-0022 | C1 | chkYear / 년도별 / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkYear / 년도별 / Year · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0023 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitControls:11) |
| WK-DMF0043-0024 | C1 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitControls:12) |
| WK-DMF0043-0025 | C1 | clbYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbYear / Year · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0043_ContributeRatePopup.InitCont) |
| WK-DMF0043-0026 | C1 | usrBiz / Biz | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrBiz / Biz · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0027 | C1 | usrDiscard / Discard | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrDiscard / Discard · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0028 | C1 | usrHis / His | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrHis / His · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0029 | C1 | usrType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0030 | C1 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0043_Contribute_Main.InitControls) |
| WK-DMF0043-0031 | C2 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (4) |
| WK-DMF0043-0032 | C3 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.SetItem:345:8) |
| WK-DMF0043-0033 | C3 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (4 ACT:DMF0043_Contribute_Main.SetSpreadC) |
| WK-DMF0043-0034 | C3 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0043_VersionPopup.SetItem ACT:DMF) |
| WK-DMF0043-0035 | C4 | chkYear / 년도별 / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkYear / 년도별 / Year · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0036 | C4 | usrDiscard / Discard | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — usrDiscard / Discard · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0037 | C4 | usrHis / His | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — usrHis / His · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0038 | C4 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0039 | C6 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (4) |
| WK-DMF0043-0040 | G3 | DMF0043 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0043 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 0 () |
| WK-DMF0043-0041 | K-SA | DMF0043 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — DMF0043 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 0 () |
| WK-DMF0043-0042 | K4 | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 56 (ACT:DMF0043_ContributeRatePopup.btnButto) |
| WK-DMF0043-0043 | F1 | DMF0043 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0043 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 147 (Protected override (§G) 3 5 7 9 ACT:DMF0) |
| WK-DMF0043-0044 | F5 | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 5 (Protected override (§G) 3 9 ACT:DMF0043_) |
| WK-DMF0043-0045 | F4 | DM0000_GET_COMMON_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 2 (ACT:DMF0043_VersionPopup.GetSpdTitle:318) |
| WK-DMF0043-0046 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 67 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0047 | F4 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 118 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0048 | F4 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RAT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 67 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0049 | F4 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 47 (ACT:DMF0043_ContributeRatePopup.GetYearD) |
| WK-DMF0043-0050 | F4 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 43 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0051 | F4 | PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 26 (ACT:DMF0043_VersionPopup.FindButton ACT:) |
| WK-DMF0043-0052 | F4 | PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 118 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0053 | F4 | PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_D | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 2 (ACT:DMF0043_Contribute_Main.GetVersionDa) |
| WK-DMF0043-0054 | F4 | PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 43 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0055 | F4 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 85 (ACT:DMF0043_Contribute_Main.SaveButton A) |
| WK-DMF0043-0056 | F4 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 47 (ACT:DMF0043_ContributeRatePopup.SaveButt) |
| WK-DMF0043-0057 | F4 | P_DMF0043_MAIN_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_MAIN_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0058 | F4 | P_DMF0043_MAIN_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_MAIN_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0059 | F4 | P_DMF0043_MAIN_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_MAIN_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0060 | F4 | P_DMF0043_RATE_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_RATE_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0061 | F4 | P_DMF0043_VERSION_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_VERSION_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0062 | F4 | P_DMF0043_VERSION_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_VERSION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0063 | F4 | P_DMF0043_VERSION_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_VERSION_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0064 | F4 | P_DMF0043_YEAR_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DMF0043_YEAR_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-DMF0043-0065 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 6 (ACT:DMF0043_Contribute_Main.GetLookupDat) |
| WK-DMF0043-0066 | A5 | CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0067 | A5 | CREATION_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0068 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0069 | A5 | EDIT_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0070 | A5 | VERSION_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0071 | A5 | VERSION_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0072 | A5 | VERSION_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0073 | A5 | VER_CRE_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VER_CRE_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0074 | A5 | YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0075 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0043_VersionPopup.InitControls AC) |
| WK-DMF0043-0076 | G4 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbType / Report Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_VersionPopup.InitControls AC) |
| WK-DMF0043-0077 | G4 | clbYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbYear / Year · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_ContributeRatePopup.InitCont) |
| WK-DMF0043-0078 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_VersionPopup.Form_Load ACT:D) |
| WK-DMF0043-0079 | G4 | txtDes / Des | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtDes / Des · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0043_VersionPopup.InitSpread_X AC) |
| WK-DMF0043-0080 | G4 | usrBiz / Biz | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrBiz / Biz · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0081 | G4 | usrType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrType / Report Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0043_Contribute_View.DefineProper) |
| WK-DMF0043-0082 | G4 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrYear / Year · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0043_Contribute_Main.DefineProper) |
| WK-DMF0043-0083 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (작성·갱신) |
| WK-DMF0043-0084 | H2 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0085 | H2 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0086 | H4 | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:DMF0043_ContributeRatePopup.spdMain_) |
| WK-DMF0043-0087 | H5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0088 | H5 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATION_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0089 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0090 | H5 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDIT_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0091 | H5 | VERSION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0092 | H5 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0093 | H5 | VERSION_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0094 | H5 | VER_CRE_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VER_CRE_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0095 | H5 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.InitSpread_X:16) |
| WK-DMF0043-0096 | H5 | chkYear / 년도별 / Year | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkYear / 년도별 / Year · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0097 | H5 | usrYear / Year | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — usrYear / Year · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0043_Contribute_Main.InitSpread A) |
| WK-DMF0043-0098 | I1 | DMF0043 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0043 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 17 (ACT:DMF0043_ContributeRatePopup.FindData) |
| WK-DMF0043-0099 | D1 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (4 ACT:DMF0043_Contribute_Main.EditButton) |
| WK-DMF0043-0100 | D1 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0101 | D1 | VER_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VER_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0043_ContributeRatePopup.EditButt) |
| WK-DMF0043-0102 | D3 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — C · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (작성·갱신) |
| WK-DMF0043-0103 | D3 | EDIT_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDIT_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (4 ACT:DMF0043_Contribute_Main.EditButton) |
| WK-DMF0043-0104 | D3 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — S · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0105 | D3 | VER_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VER_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0043_ContributeRatePopup.EditButt) |
| WK-DMF0043-0106 | D4 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (작성·갱신) |
| WK-DMF0043-0107 | D5 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0108 | D6 | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (작성·갱신 Protected override (§G) 2 ACT:DMF0) |
| WK-DMF0043-0109 | E3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — C · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 2 (작성·갱신 Validation (§C)) |
| WK-DMF0043-0110 | E4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (작성·갱신 Validation (§C)) |
| WK-DMF0043-0111 | E4 | CREATION_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CREATION_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_VersionPopup.SetItem:345:8) |
| WK-DMF0043-0112 | E4 | EDIT_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — EDIT_FLAG · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0113 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0043_ContributeRatePopup.SaveData) |
| WK-DMF0043-0114 | E4 | MSG00019 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00019 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_ContributeRatePopup.FindData) |
| WK-DMF0043-0115 | E4 | MSG00266 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00266 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_Contribute_Main.chkYear_Chec) |
| WK-DMF0043-0116 | E4 | MSG00279 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00279 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:DMF0043_VersionPopup.SetItem ACT:DMF) |
| WK-DMF0043-0117 | E4 | MSG00283 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00283 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_Contribute_View.FindData:337) |
| WK-DMF0043-0118 | E4 | MSG00303 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00303 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_Contribute_Main.SaveData:344) |
| WK-DMF0043-0119 | E4 | MSG00307 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00307 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_Contribute_View.FindData:385) |
| WK-DMF0043-0120 | E4 | MSG00308 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00308 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_Contribute_Main.SaveData:351) |
| WK-DMF0043-0121 | E4 | MSG01306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-DMF0043-0122 | E4 | MSG01310 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01310 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-DMF0043-0123 | E4 | VERSION_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VERSION_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0043_VersionPopup.SetItem ACT:DMF) |
| WK-DMF0043-0124 | E4 | chkYear / 년도별 / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkYear / 년도별 / Year · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 10 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0125 | E4 | clbYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbYear / Year · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0043_ContributeRatePopup.FindData) |
| WK-DMF0043-0126 | E4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (ACT:DMF0043_Contribute_View.FindData:337) |
| WK-DMF0043-0127 | A10 | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 124 (ACT:DMF0043_ContributeRatePopup.DefinePr) |
| WK-DMF0043-0128 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 20 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0129 | A6 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 36 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0130 | A6 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RAT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE  |  | 22 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0131 | A6 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE  |  | 0 () |
| WK-DMF0043-0132 | A6 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_S | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 43 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0133 | A6 | PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 26 (ACT:DMF0043_VersionPopup.FindButton ACT:) |
| WK-DMF0043-0134 | A6 | PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 34 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0135 | A6 | PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_D | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 0 () |
| WK-DMF0043-0136 | A6 | PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 41 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0137 | A6 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 0 () |
| WK-DMF0043-0138 | A6 | P_DMF0043_MAIN_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_MAIN_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 0 () |
| WK-DMF0043-0139 | A6 | P_DMF0043_MAIN_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_MAIN_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 0 () |
| WK-DMF0043-0140 | A6 | P_DMF0043_RATE_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_RATE_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 0 () |
| WK-DMF0043-0141 | A6 | P_DMF0043_VERSION_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_VERSION_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 0 () |
| WK-DMF0043-0142 | A6 | P_DMF0043_VERSION_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_VERSION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 0 () |
| WK-DMF0043-0143 | A6 | P_DMF0043_VERSION_SAVE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_VERSION_SAVE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 0 () |
| WK-DMF0043-0144 | A6 | P_DMF0043_YEAR_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DMF0043_YEAR_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 0 () |
| WK-DMF0043-0145 | G1 | chkM / [M$] / M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkM / [M$] / M · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0146 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_VersionPopup.FindData ACT:DM) |
| WK-DMF0043-0147 | G1 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbType / Report Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_VersionPopup.FindData ACT:DM) |
| WK-DMF0043-0148 | G1 | clbYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbYear / Year · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0043_ContributeRatePopup.FindData) |
| WK-DMF0043-0149 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0043_VersionPopup.FindData ACT:DM) |
| WK-DMF0043-0150 | G1 | txtDes / Des | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDes / Des · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_VersionPopup.FindData ACT:DM) |
| WK-DMF0043-0151 | G1 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0152 | G1 | usrBiz / Biz | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrBiz / Biz · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0153 | G1 | usrChk / Chk | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrChk / Chk · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0154 | G1 | usrCust / 고객군 / Cust | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrCust / 고객군 / Cust · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0155 | G1 | usrDiscard / Discard | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrDiscard / Discard · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_Main.FindData ACT) |
| WK-DMF0043-0156 | G1 | usrHis / His | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrHis / His · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_Main.FindData ACT) |
| WK-DMF0043-0157 | G1 | usrType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrType / Report Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0043_Contribute_View.FindData ACT) |
| WK-DMF0043-0158 | G1 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrYear / Year · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0043_Contribute_Main.FindData ACT) |
| WK-DMF0043-0159 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0043_VersionPopup.InitControls AC) |
| WK-DMF0043-0160 | G6 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0043_VersionPopup.InitControls AC) |
| WK-DMF0043-0161 | G6 | clbYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbYear / Year · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0043_ContributeRatePopup.InitCont) |
| WK-DMF0043-0162 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0043_VersionPopup.Form_Load ACT:D) |
| WK-DMF0043-0163 | G6 | txtDes / Des | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtDes / Des · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0043_VersionPopup.InitSpread_X AC) |
| WK-DMF0043-0164 | G6 | usrBiz / Biz | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrBiz / Biz · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0165 | G6 | usrType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:DMF0043_Contribute_View.DefineProper) |
| WK-DMF0043-0166 | G6 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0043_Contribute_Main.DefineProper) |
| WK-DMF0043-0167 | X-REOPEN | DMF0043 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0043 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 31 (ACT:DMF0043_ContributeRatePopup.Dispose ) |
| WK-DMF0043-0168 | M3 | DMF0043_ContributeRatePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0043_ContributeRatePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 20 (ACT:DMF0043_ContributeRatePopup..ctor AC) |
| WK-DMF0043-0169 | M3 | DMF0043_Contribute_View | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0043_Contribute_View · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 21 (ACT:DMF0043_Contribute_View..ctor ACT:DM) |
| WK-DMF0043-0170 | M3 | DMF0043_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0043_VersionPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 18 (ACT:DMF0043_Contribute_View.btnSPVer_Cli) |
| WK-DMF0043-0171 | M3 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0043_Contribute_View.btnColumn_Cl) |
| WK-DMF0043-0172 | M3 | btnCutOff | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnCutOff · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0043_Contribute_View.btnCutOff_Cl) |
| WK-DMF0043-0173 | M3 | btnSPVer | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnSPVer · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0043_Contribute_View.btnSPVer_Cli) |
| WK-DMF0043-0174 | M4 | DMF0043_ContributeRatePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0043_ContributeRatePopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-DMF0043-0175 | M4 | DMF0043_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0043_VersionPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0043_VersionPopup.spdMain_CellDou) |
| WK-DMF0043-0176 | M4 | btnCutOff | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnCutOff · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |

## W7 기대값 확정 (237)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0043-0177 | C2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 8: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0043-0178 | C2 | DMF0043_Contribute_Main.chkYear_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0043_Contribute_Main.chkYear_CheckedChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.chkYear_Chec) |
| WK-DMF0043-0179 | C2 | DMF0043_Contribute_Main.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0043_Contribute_Main.spdMain_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.spdMain_Chan) |
| WK-DMF0043-0180 | C2 | DMF0043_Contribute_Main.usrHis_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0043_Contribute_Main.usrHis_CheckedChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.usrHis_Check) |
| WK-DMF0043-0181 | C2 | DMF0043_Contribute_Main.usrYear_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0043_Contribute_Main.usrYear_SelectedIndexChang: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrYear_Sele) |
| WK-DMF0043-0182 | C3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 8: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0043-0183 | C3 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0184 | C3 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0185 | C3 | DMF0043_Contribute_Main.chkYear_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.chkYear_CheckedChanged: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.chkYear_Chec) |
| WK-DMF0043-0186 | C3 | DMF0043_Contribute_Main.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.spdMain_Changed: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.spdMain_Chan) |
| WK-DMF0043-0187 | C3 | DMF0043_Contribute_Main.usrHis_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.usrHis_CheckedChanged: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.usrHis_Check) |
| WK-DMF0043-0188 | C3 | DMF0043_Contribute_Main.usrYear_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0043_Contribute_Main.usrYear_SelectedIndexChang: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrYear_Sele) |
| WK-DMF0043-0189 | C6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 8: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0043-0190 | C6 | DMF0043_Contribute_Main.chkYear_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0043_Contribute_Main.chkYear_CheckedChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.chkYear_Chec) |
| WK-DMF0043-0191 | C6 | DMF0043_Contribute_Main.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0043_Contribute_Main.spdMain_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.spdMain_Chan) |
| WK-DMF0043-0192 | C6 | DMF0043_Contribute_Main.usrHis_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0043_Contribute_Main.usrHis_CheckedChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.usrHis_Check) |
| WK-DMF0043-0193 | C6 | DMF0043_Contribute_Main.usrYear_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0043_Contribute_Main.usrYear_SelectedIndexChang: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrYear_Sele) |
| WK-DMF0043-0194 | B3 | DMF0043_Contribute_Main.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0043_Contribute_Main.GetCellColor: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_Main.GetCellColor) |
| WK-DMF0043-0195 | B3 | DMF0043_Contribute_Main.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0043_Contribute_Main.GetCellIndexBySpanRowCells: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.GetCellIndex) |
| WK-DMF0043-0196 | B3 | DMF0043_Contribute_Main.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0043_Contribute_Main.GetLookupData: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.GetLookupDat) |
| WK-DMF0043-0197 | B3 | DMF0043_Contribute_Main.GetVersionData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0043_Contribute_Main.GetVersionData: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.GetVersionDa) |
| WK-DMF0043-0198 | B4 | DMF0043_Contribute_Main.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0043_Contribute_Main.GetCellColor: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_Main.GetCellColor) |
| WK-DMF0043-0199 | B4 | DMF0043_Contribute_Main.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0043_Contribute_Main.GetCellIndexBySpanRowCells: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.GetCellIndex) |
| WK-DMF0043-0200 | B4 | DMF0043_Contribute_Main.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0043_Contribute_Main.GetLookupData: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.GetLookupDat) |
| WK-DMF0043-0201 | B4 | DMF0043_Contribute_Main.GetVersionData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0043_Contribute_Main.GetVersionData: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.GetVersionDa) |
| WK-DMF0043-0202 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 21요소: PASS:11 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0043-0203 | DB-SYN | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 2: 행 집계 — DB-SYN 21요소: PASS:11 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0204 | DB-SYN | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 3: 행 집계 — DB-SYN 21요소: PASS:11 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0205 | DB-SYN | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 5: 행 집계 — DB-SYN 21요소: PASS:11 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-DMF0043-0206 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0043-0207 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0208 | F4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 3: 행 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0209 | F4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 5: 행 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-DMF0043-0210 | F4 | DMF0043_Contribute_View.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0043_Contribute_View.SaveButton: 진입점 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_View.SaveButton) |
| WK-DMF0043-0211 | F4 | DMF0043_Contribute_View.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0043_Contribute_View.SaveData: 진입점 집계 — F4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_View.SaveData) |
| WK-DMF0043-0212 | A5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0213 | A5 | 6 (+1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 6 (+1): 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (6 (+1)) |
| WK-DMF0043-0214 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0215 | A5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 9: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0043-0216 | A5 | DMF0043_Contribute_Main.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0043_Contribute_Main.CreateSpread: 진입점 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.CreateSpread) |
| WK-DMF0043-0217 | A5 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0218 | A5 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0219 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0220 | H2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0221 | H2 | 6 (+1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6 (+1): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (6 (+1)) |
| WK-DMF0043-0222 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0223 | H2 | DMF0043_Contribute_Main.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0043_Contribute_Main.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.CreateSpread) |
| WK-DMF0043-0224 | H2 | DMF0043_Contribute_Main.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0043_Contribute_Main.GetCellColor: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_Main.GetCellColor) |
| WK-DMF0043-0225 | H2 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0226 | H2 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0227 | H2 | Expression (§D) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Expression (§D): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Expression (§D)) |
| WK-DMF0043-0228 | H2 | 분석 자료 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 분석 자료: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (분석 자료) |
| WK-DMF0043-0229 | H5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3: 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0230 | H5 | 6 (+1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 6 (+1): 행 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (6 (+1)) |
| WK-DMF0043-0231 | H5 | DMF0043_Contribute_Main.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0043_Contribute_Main.CreateSpread: 진입점 집계 — H5 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.CreateSpread) |
| WK-DMF0043-0232 | H5 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0233 | H5 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0234 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0235 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0236 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0043-0237 | D1 | DMF0043_Contribute_Main.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0043_Contribute_Main.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.EditButton:1) |
| WK-DMF0043-0238 | D1 | Protected override (§G) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Protected override (§G): 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Protected override (§G)) |
| WK-DMF0043-0239 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0240 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0241 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0242 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0043-0243 | D3 | DMF0043_Contribute_Main.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0043_Contribute_Main.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_Main.EditButton:1) |
| WK-DMF0043-0244 | D3 | Expression (§D) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Expression (§D): 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Expression (§D)) |
| WK-DMF0043-0245 | D3 | Protected override (§G) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Protected override (§G): 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Protected override (§G)) |
| WK-DMF0043-0246 | D3 | 분석 자료 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 분석 자료: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (분석 자료) |
| WK-DMF0043-0247 | D4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 2: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-DMF0043-0248 | D4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 4: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0249 | D4 | Protected override (§G) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Protected override (§G): 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Protected override (§G)) |
| WK-DMF0043-0250 | D5 | DMF0043_Contribute_Main.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0043_Contribute_Main.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_Main.CreateSpread) |
| WK-DMF0043-0251 | D5 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0252 | D5 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0253 | E3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 1: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0254 | E3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 2: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0255 | E3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 3: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0256 | E3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 4: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0257 | E3 | 분석 자료 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 분석 자료: 행 집계 — E3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (분석 자료) |
| WK-DMF0043-0258 | E4 | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0259 | E4 | DMF0043_Contribute_Main.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0043_Contribute_Main.SetSpreadHeaderSpan: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0043_Contribute_Main.SetSpreadHea) |
| WK-DMF0043-0260 | E4 | 분석 자료 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 분석 자료: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (분석 자료) |
| WK-DMF0043-0261 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (1) |
| WK-DMF0043-0262 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 18요소: REVIEW:18 |  | 0 () |
| WK-DMF0043-0263 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 18요소: REVIEW:18 |  | 1 (6) |
| WK-DMF0043-0264 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 18요소: REVIEW:18 |  | 0 () |
| WK-DMF0043-0265 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 20 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0266 | A1 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA — 팝업·보조 SP |  | 36 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0267 | A1 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_RATE_POPUP — 팝업·보조  |  | 22 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0268 | A1 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP — 팝업·보조  |  | 0 () |
| WK-DMF0043-0269 | A1 | PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_CONTRIBUTION_SALES_LIST — 팝업 |  | 43 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0270 | A1 | PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP — 팝업·보 |  | 26 (ACT:DMF0043_VersionPopup.FindButton ACT:) |
| WK-DMF0043-0271 | A1 | PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE — 팝업·보조 SP 는 gol |  | 34 (ACT:DMF0043_Contribute_Main.FindButton A) |
| WK-DMF0043-0272 | A1 | PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_D | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA — 팝업·보조 SP 는 gol |  | 0 () |
| WK-DMF0043-0273 | A1 | PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_GET_SALES_LIST_SPREAD_TITLE — 팝업 |  | 41 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0274 | A1 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO —  |  | 0 () |
| WK-DMF0043-0275 | A1 | PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER: 골든 비교 케이스 없음(PKG_DMF0043.P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER — 팝업·보 |  | 0 () |
| WK-DMF0043-0276 | A1 | P_DMF0043_MAIN_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_MAIN_GET: 골든 비교 케이스 없음(P_DMF0043_MAIN_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0277 | A1 | P_DMF0043_MAIN_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_MAIN_TITLE: 골든 비교 케이스 없음(P_DMF0043_MAIN_TITLE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0278 | A1 | P_DMF0043_RATE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_RATE_POPUP: 골든 비교 케이스 없음(P_DMF0043_RATE_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0279 | A1 | P_DMF0043_VERSION_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_VERSION_GET: 골든 비교 케이스 없음(P_DMF0043_VERSION_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0280 | A1 | P_DMF0043_VERSION_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_VERSION_POPUP: 골든 비교 케이스 없음(P_DMF0043_VERSION_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0281 | A1 | P_DMF0043_VERSION_SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_VERSION_SAVE: 골든 비교 케이스 없음(P_DMF0043_VERSION_SAVE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0282 | A1 | P_DMF0043_YEAR_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DMF0043_YEAR_POPUP: 골든 비교 케이스 없음(P_DMF0043_YEAR_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-DMF0043-0283 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0043-0284 | G03-WIRE | DMF0043 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — DMF0043 화면: 게이트 G03 As-is 이벤트 chkYear.CheckedChanged → chkYe / 게이트 G03 As-is 이벤트 usrDiscard.Click → usrDiscard_  |  | 18 (ACT:DMF0043_ContributeRatePopup..ctor AC) |
| WK-DMF0043-0285 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-DMF0043-0286 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0287 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0288 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0043-0289 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0043-0290 | X-LOC | (+Form_Load) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (+Form_Load): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((+Form_Load)) |
| WK-DMF0043-0291 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-DMF0043-0292 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-DMF0043-0293 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0043-0294 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-DMF0043-0295 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0043-0296 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-DMF0043-0297 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-DMF0043-0298 | X-LOC | 6 (+1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6 (+1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6 (+1)) |
| WK-DMF0043-0299 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-DMF0043-0300 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-DMF0043-0301 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-DMF0043-0302 | X-LOC | API SP 호출 (§B) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — API SP 호출 (§B): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (API SP 호출 (§B)) |
| WK-DMF0043-0303 | X-LOC | As-Is 원본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — As-Is 원본: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (As-Is 원본) |
| WK-DMF0043-0304 | X-LOC | Button (§E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Button (§E): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Button (§E)) |
| WK-DMF0043-0305 | X-LOC | Event handler (§A) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Event handler (§A): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Event handler (§A)) |
| WK-DMF0043-0306 | X-LOC | Expression (§D) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Expression (§D): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Expression (§D)) |
| WK-DMF0043-0307 | X-LOC | Grid 컬럼 (BASE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Grid 컬럼 (BASE): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Grid 컬럼 (BASE)) |
| WK-DMF0043-0308 | X-LOC | POPUP (§F) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — POPUP (§F): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (POPUP (§F)) |
| WK-DMF0043-0309 | X-LOC | Protected override (§G) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Protected override (§G): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Protected override (§G)) |
| WK-DMF0043-0310 | X-LOC | Validation (§C) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Validation (§C): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Validation (§C)) |
| WK-DMF0043-0311 | X-LOC | 매핑 양식 출처 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 매핑 양식 출처: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (매핑 양식 출처) |
| WK-DMF0043-0312 | X-LOC | 분석 자료 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 분석 자료: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (분석 자료) |
| WK-DMF0043-0313 | X-LOC | 작성·갱신 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 작성·갱신: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (작성·갱신) |
| WK-DMF0043-0314 | X-LOC | 폴더 (TO-BE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 폴더 (TO-BE): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (폴더 (TO-BE)) |
| WK-DMF0043-0315 | X-LOC | 화면 ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 화면 ID: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (화면 ID) |
| WK-DMF0043-0316 | X-LOC | 화면 명 (TO-BE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 화면 명 (TO-BE): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (화면 명 (TO-BE)) |
| WK-DMF0043-0317 | X-ROW | (+Form_Load) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — (+Form_Load): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 ((+Form_Load)) |
| WK-DMF0043-0318 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0043-0319 | X-ROW | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (10) |
| WK-DMF0043-0320 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0043-0321 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0043-0322 | X-ROW | API SP 호출 (§B) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — API SP 호출 (§B): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (API SP 호출 (§B)) |
| WK-DMF0043-0323 | X-ROW | As-Is 원본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — As-Is 원본: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (As-Is 원본) |
| WK-DMF0043-0324 | X-ROW | Button (§E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Button (§E): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Button (§E)) |
| WK-DMF0043-0325 | X-ROW | DMF0043_ContributeRatePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup..ctor: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 2 (ACT:DMF0043_ContributeRatePopup..ctor:70) |
| WK-DMF0043-0326 | X-ROW | DMF0043_ContributeRatePopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_ContributeRatePopup.CreateSp) |
| WK-DMF0043-0327 | X-ROW | DMF0043_ContributeRatePopup.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0043_ContributeRatePopup.DefinePr) |
| WK-DMF0043-0328 | X-ROW | DMF0043_ContributeRatePopup.DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.DeleteButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_ContributeRatePopup.DeleteBu) |
| WK-DMF0043-0329 | X-ROW | DMF0043_ContributeRatePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_ContributeRatePopup.Dispose:) |
| WK-DMF0043-0330 | X-ROW | DMF0043_ContributeRatePopup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.EditButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0043_ContributeRatePopup.EditButt) |
| WK-DMF0043-0331 | X-ROW | DMF0043_ContributeRatePopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0043_ContributeRatePopup.FindButt) |
| WK-DMF0043-0332 | X-ROW | DMF0043_ContributeRatePopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.FindData: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 |  | 19 (ACT:DMF0043_ContributeRatePopup.FindData) |
| WK-DMF0043-0333 | X-ROW | DMF0043_ContributeRatePopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0043_ContributeRatePopup.Form_Loa) |
| WK-DMF0043-0334 | X-ROW | DMF0043_ContributeRatePopup.GetYearData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.GetYearData: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0043_ContributeRatePopup.GetYearD) |
| WK-DMF0043-0335 | X-ROW | DMF0043_ContributeRatePopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_ContributeRatePopup.InitCont) |
| WK-DMF0043-0336 | X-ROW | DMF0043_ContributeRatePopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.InitSpread: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0043_ContributeRatePopup.InitSpre) |
| WK-DMF0043-0337 | X-ROW | DMF0043_ContributeRatePopup.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_ContributeRatePopup.InsertBu) |
| WK-DMF0043-0338 | X-ROW | DMF0043_ContributeRatePopup.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.InsertRow: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0043_ContributeRatePopup.InsertRo) |
| WK-DMF0043-0339 | X-ROW | DMF0043_ContributeRatePopup.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.SaveButton: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_ContributeRatePopup.SaveButt) |
| WK-DMF0043-0340 | X-ROW | DMF0043_ContributeRatePopup.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.SaveData: 진입점 집계 16검사 — NOT_RUN:10 · PASS:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 44 (ACT:DMF0043_ContributeRatePopup.SaveData) |
| WK-DMF0043-0341 | X-ROW | DMF0043_ContributeRatePopup.btnButtonLis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.btnButtonList_UsrButto: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 16 (ACT:DMF0043_ContributeRatePopup.btnButto) |
| WK-DMF0043-0342 | X-ROW | DMF0043_ContributeRatePopup.spdMain_TopC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_ContributeRatePopup.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0043_ContributeRatePopup.spdMain_) |
| WK-DMF0043-0343 | X-ROW | DMF0043_Contribute_Main.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.CreateSpread) |
| WK-DMF0043-0344 | X-ROW | DMF0043_Contribute_Main.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.DefineProperty: 진입점 집계 4검사 — NOT_RUN:3 · WARN:1 |  | 2 (ACT:DMF0043_Contribute_Main.DefineProper) |
| WK-DMF0043-0345 | X-ROW | DMF0043_Contribute_Main.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0043_Contribute_Main.ExcelButton ) |
| WK-DMF0043-0346 | X-ROW | DMF0043_Contribute_Main.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0043_Contribute_Main.FindButton) |
| WK-DMF0043-0347 | X-ROW | DMF0043_Contribute_Main.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.FindData: 진입점 집계 14검사 — NOT_RUN:9 · REVIEW:2 · PASS:2 · WARN:1 |  | 7 (ACT:DMF0043_Contribute_Main.FindData:268) |
| WK-DMF0043-0348 | X-ROW | DMF0043_Contribute_Main.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.Form_Load) |
| WK-DMF0043-0349 | X-ROW | DMF0043_Contribute_Main.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.GetCellColor: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.GetCellColor) |
| WK-DMF0043-0350 | X-ROW | DMF0043_Contribute_Main.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.GetCellIndexBySpanRowCells: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.GetCellIndex) |
| WK-DMF0043-0351 | X-ROW | DMF0043_Contribute_Main.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.GetLookupData: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.GetLookupDat) |
| WK-DMF0043-0352 | X-ROW | DMF0043_Contribute_Main.GetVersionData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.GetVersionData: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.GetVersionDa) |
| WK-DMF0043-0353 | X-ROW | DMF0043_Contribute_Main.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.InitControls) |
| WK-DMF0043-0354 | X-ROW | DMF0043_Contribute_Main.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.InitSpread: 진입점 집계 7검사 — NOT_RUN:6 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.InitSpread) |
| WK-DMF0043-0355 | X-ROW | DMF0043_Contribute_Main.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/COMBO_DATA/DATA_OP/ENTRY/EXPR/GRID_COMBO/UI_MIS |  | 10 (ACT:DMF0043_Contribute_Main.InsertRow AC) |
| WK-DMF0043-0356 | X-ROW | DMF0043_Contribute_Main.RetConType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.RetConType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0043_Contribute_Main.RetConType A) |
| WK-DMF0043-0357 | X-ROW | DMF0043_Contribute_Main.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.SaveData: 진입점 집계 14검사 — NOT_RUN:9 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_Main.SaveData:339) |
| WK-DMF0043-0358 | X-ROW | DMF0043_Contribute_Main.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.SetSpreadColumn: 진입점 집계 14검사 — NOT_RUN:8 · REVIEW:6 |  | 6 (ACT:DMF0043_Contribute_Main.SetSpreadCol) |
| WK-DMF0043-0359 | X-ROW | DMF0043_Contribute_Main.ValidChk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.ValidChk: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연 |  | 45 (ACT:DMF0043_Contribute_Main.ValidChk ACT) |
| WK-DMF0043-0360 | X-ROW | DMF0043_Contribute_Main.ValidChk2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.ValidChk2: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 23 (ACT:DMF0043_Contribute_Main.ValidChk2 AC) |
| WK-DMF0043-0361 | X-ROW | DMF0043_Contribute_Main.YearSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.YearSet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0043_Contribute_Main.YearSet ACT:) |
| WK-DMF0043-0362 | X-ROW | DMF0043_Contribute_Main.btnCutOff_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.btnCutOff_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_Main.btnCutOff_Cl) |
| WK-DMF0043-0363 | X-ROW | DMF0043_Contribute_Main.chkYear_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.chkYear_CheckedChanged: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.chkYear_Chec) |
| WK-DMF0043-0364 | X-ROW | DMF0043_Contribute_Main.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.spdMain_Changed: 진입점 집계 4검사 — NOT_RUN:3 · WARN:1 |  | 2 (ACT:DMF0043_Contribute_Main.spdMain_Chan) |
| WK-DMF0043-0365 | X-ROW | DMF0043_Contribute_Main.usrDiscard_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.usrDiscard_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrDiscard_C) |
| WK-DMF0043-0366 | X-ROW | DMF0043_Contribute_Main.usrHis_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.usrHis_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrHis_Check) |
| WK-DMF0043-0367 | X-ROW | DMF0043_Contribute_Main.usrYear_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_Main.usrYear_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0043_Contribute_Main.usrYear_Sele) |
| WK-DMF0043-0368 | X-ROW | DMF0043_Contribute_View..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View..ctor: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 2 (ACT:DMF0043_Contribute_View..ctor:85:1 A) |
| WK-DMF0043-0369 | X-ROW | DMF0043_Contribute_View.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_View.CreateSpread) |
| WK-DMF0043-0370 | X-ROW | DMF0043_Contribute_View.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.DefineProperty: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0043_Contribute_View.DefineProper) |
| WK-DMF0043-0371 | X-ROW | DMF0043_Contribute_View.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_View.Dispose:16:1) |
| WK-DMF0043-0372 | X-ROW | DMF0043_Contribute_View.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.EditButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_View.EditButton A) |
| WK-DMF0043-0373 | X-ROW | DMF0043_Contribute_View.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.ExcelButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:DMF0043_Contribute_View.ExcelButton ) |
| WK-DMF0043-0374 | X-ROW | DMF0043_Contribute_View.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0043_Contribute_View.FindButton A) |
| WK-DMF0043-0375 | X-ROW | DMF0043_Contribute_View.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.FindData: 진입점 집계 21검사 — NOT_RUN:17 · REVIEW:2 · PASS:2 |  | 40 (ACT:DMF0043_Contribute_View.FindData:335) |
| WK-DMF0043-0376 | X-ROW | DMF0043_Contribute_View.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0043_Contribute_View.Form_Load AC) |
| WK-DMF0043-0377 | X-ROW | DMF0043_Contribute_View.GetCellIndexBySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.GetCellIndexBySpanRowCells: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_View.GetCellIndex) |
| WK-DMF0043-0378 | X-ROW | DMF0043_Contribute_View.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.GetLookupData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0043_Contribute_View.GetLookupDat) |
| WK-DMF0043-0379 | X-ROW | DMF0043_Contribute_View.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.InitControls: 진입점 집계 13검사 — NOT_RUN:11 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0043_Contribute_View.InitControls) |
| WK-DMF0043-0380 | X-ROW | DMF0043_Contribute_View.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.InitSpread: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0043_Contribute_View.InitSpread A) |
| WK-DMF0043-0381 | X-ROW | DMF0043_Contribute_View.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_Contribute_View.InsertButton) |
| WK-DMF0043-0382 | X-ROW | DMF0043_Contribute_View.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.InsertRow: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_View.InsertRow AC) |
| WK-DMF0043-0383 | X-ROW | DMF0043_Contribute_View.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.SaveButton: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · REVIEW:1 |  | 1 (ACT:DMF0043_Contribute_View.SaveButton:2) |
| WK-DMF0043-0384 | X-ROW | DMF0043_Contribute_View.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.SaveData: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · REVIEW:1 |  | 5 (ACT:DMF0043_Contribute_View.SaveData:415) |
| WK-DMF0043-0385 | X-ROW | DMF0043_Contribute_View.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.SetSpreadHeaderSpan: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 50 (ACT:DMF0043_Contribute_View.SetSpreadHea) |
| WK-DMF0043-0386 | X-ROW | DMF0043_Contribute_View.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_Contribute_View.btnColumn_Cl) |
| WK-DMF0043-0387 | X-ROW | DMF0043_Contribute_View.btnCutOff_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.btnCutOff_Click: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_Contribute_View.btnCutOff_Cl) |
| WK-DMF0043-0388 | X-ROW | DMF0043_Contribute_View.btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_Contribute_View.btnSPVer_Click: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0043_Contribute_View.btnSPVer_Cli) |
| WK-DMF0043-0389 | X-ROW | DMF0043_VersionPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup..ctor: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 2 (ACT:DMF0043_VersionPopup..ctor:88:1 ACT:) |
| WK-DMF0043-0390 | X-ROW | DMF0043_VersionPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_VersionPopup.CreateSpread AC) |
| WK-DMF0043-0391 | X-ROW | DMF0043_VersionPopup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_VersionPopup.DefineProperty ) |
| WK-DMF0043-0392 | X-ROW | DMF0043_VersionPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_VersionPopup.Dispose:16:1 AC) |
| WK-DMF0043-0393 | X-ROW | DMF0043_VersionPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:DMF0043_VersionPopup.FindButton ACT:) |
| WK-DMF0043-0394 | X-ROW | DMF0043_VersionPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.FindData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 23 (ACT:DMF0043_VersionPopup.FindData:208:1 ) |
| WK-DMF0043-0395 | X-ROW | DMF0043_VersionPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0043_VersionPopup.Form_Load:96:1 ) |
| WK-DMF0043-0396 | X-ROW | DMF0043_VersionPopup.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.GetLookupData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0043_VersionPopup.GetLookupData A) |
| WK-DMF0043-0397 | X-ROW | DMF0043_VersionPopup.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.GetSpdTitle: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0043_VersionPopup.GetSpdTitle ACT) |
| WK-DMF0043-0398 | X-ROW | DMF0043_VersionPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.InitControls: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0043_VersionPopup.InitControls:11) |
| WK-DMF0043-0399 | X-ROW | DMF0043_VersionPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_VersionPopup.InitSpread ACT:) |
| WK-DMF0043-0400 | X-ROW | DMF0043_VersionPopup.InitSpread_X | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.InitSpread_X: 진입점 집계 20검사 — NOT_RUN:20 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0043_VersionPopup.InitSpread_X:15) |
| WK-DMF0043-0401 | X-ROW | DMF0043_VersionPopup.SetItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.SetItem: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0043_VersionPopup.SetItem:333:1 A) |
| WK-DMF0043-0402 | X-ROW | DMF0043_VersionPopup.btnButtonList_UsrBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.btnButtonList_UsrButtonList_C: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0043_VersionPopup.btnButtonList_U) |
| WK-DMF0043-0403 | X-ROW | DMF0043_VersionPopup.spdMain_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.spdMain_CellDoubleClick: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0043_VersionPopup.spdMain_CellDou) |
| WK-DMF0043-0404 | X-ROW | DMF0043_VersionPopup.txtItemID_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0043_VersionPopup.txtItemID_KeyDown: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0043_VersionPopup.txtItemID_KeyDo) |
| WK-DMF0043-0405 | X-ROW | Event handler (§A) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Event handler (§A): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Event handler (§A)) |
| WK-DMF0043-0406 | X-ROW | Grid 컬럼 (BASE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Grid 컬럼 (BASE): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Grid 컬럼 (BASE)) |
| WK-DMF0043-0407 | X-ROW | 매핑 양식 출처 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 매핑 양식 출처: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (매핑 양식 출처) |
| WK-DMF0043-0408 | X-ROW | 폴더 (TO-BE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 폴더 (TO-BE): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (폴더 (TO-BE)) |
| WK-DMF0043-0409 | X-ROW | 화면 ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 화면 ID: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (화면 ID) |
| WK-DMF0043-0410 | X-ROW | 화면 명 (TO-BE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 화면 명 (TO-BE): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (화면 명 (TO-BE)) |
| WK-DMF0043-0411 | G5 | POPUP (§F) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — POPUP (§F): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (POPUP (§F)) |
| WK-DMF0043-0412 | H6 | POPUP (§F) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — POPUP (§F): 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (POPUP (§F)) |
| WK-DMF0043-0413 | M4 | POPUP (§F) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — POPUP (§F): 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (POPUP (§F)) |
