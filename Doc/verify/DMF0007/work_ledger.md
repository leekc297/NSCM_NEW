# 작업 원장 — DMF0007 · 2026-10-26 12:49

> 검사 인스턴스 149건 중 PASS·NA 3건 외 **146건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 6 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 60 | 실행 → PASS |
| W7 | 기대값 확정 | 78 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 78 · E2E 60 · 하네스 8
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 26 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 2 | 12 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 9 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  | 2 | 9 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 2 | 9 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  |  | 6 |  |  |  | 조회조건 표시·라벨·활성 |
| G1 | GEN |  |  |  |  |  | 6 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 6 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 4 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H5 | DESIGN |  |  |  |  |  | 3 | 2 |  |  | 라벨 명칭 |
| B3 | COMBO |  |  |  | 2 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 배경·글자색 규칙 |
| D5 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 셀 에디터 유형 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 3 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| DB-SYN | DB |  |  |  |  | 1 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| D1 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 행 값 기반 조건부 잠금 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0007-0001 | B3 | clbDivisions / Division / Divisions | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0002 | B3 | clbTeam / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |

## W5 검사기 연결 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0007-0003 | B4 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0004 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0005 | F2 | DMF0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0007 화면 | 판단불가(대상 단위 SCREEN) | 250 (ACT:DMF0007_CustFcstMaster.SaveButton AC) |
| WK-DMF0007-0006 | F6 | DMF0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0007 화면 | 판단불가(대상 단위 SCREEN) | 250 (ACT:DMF0007_CustFcstMaster.SaveButton AC) |
| WK-DMF0007-0007 | DB-SYN | DMF0007_GET_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0007_GET_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0007_CustFcstMaster.FindDataFCST:) |
| WK-DMF0007-0008 | G03-WIRE | DMF0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0007 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:DMF0007_CustFcstMaster..ctor ACT:DMF) |

## W6 검증 실행 (60)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0007-0009 | C1 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0010 | C1 | cboBucketType / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0011 | C1 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0012 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0013 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0014 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0015 | C2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0016 | C2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0017 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0018 | C3 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0019 | C6 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0020 | C6 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0021 | F1 | DMF0007 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0007 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 253 (ACT:DMF0007_CustFcstMaster.DeleteButton ) |
| WK-DMF0007-0022 | F5 | DMF0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0007 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (ACT:DMF0007_CustFcstMaster.DeleteButton ) |
| WK-DMF0007-0023 | F4 | DMF0007_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0007_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 317 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0024 | F4 | PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 285 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0025 | F4 | PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 283 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0026 | F4 | PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DAT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 250 (ACT:DMF0007_CustFcstMaster.SaveButton AC) |
| WK-DMF0007-0027 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0007_CustFcstMaster.InitSpread:33) |
| WK-DMF0007-0028 | G4 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboActive / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0029 | G4 | cboBucketType / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (ACT:DMF0007_CustFcstMaster.DefinePropert) |
| WK-DMF0007-0030 | G4 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0031 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0032 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0033 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0034 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitSpread:33) |
| WK-DMF0007-0035 | H5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — C · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitSpread:33) |
| WK-DMF0007-0036 | H5 | cboBucketType / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: tr |  | 6 (ACT:DMF0007_CustFcstMaster.InitSpread AC) |
| WK-DMF0007-0037 | H5 | clbDivisions / Division / Divisions | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 2 (ACT:DMF0007_CustFcstMaster.CreateSpread ) |
| WK-DMF0007-0038 | I1 | DMF0007 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0007 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 47 (ACT:DMF0007_CustFcstMaster.EditButton:42) |
| WK-DMF0007-0039 | D1 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.EditButton) |
| WK-DMF0007-0040 | D3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — D · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.EditButton) |
| WK-DMF0007-0041 | D5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0007_CustFcstMaster.InitSpread:33) |
| WK-DMF0007-0042 | D6 | DMF0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0007 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:DMF0007_CustFcstMaster.InsertButton ) |
| WK-DMF0007-0043 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 28 (ACT:DMF0007_CustFcstMaster.SaveData:847:) |
| WK-DMF0007-0044 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0007_CustFcstMaster.SaveData:985:) |
| WK-DMF0007-0045 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0007_CustFcstMaster.FindDataFCST:) |
| WK-DMF0007-0046 | E4 | MSG00113 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00113 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0007_CustFcstMaster.EditButton:42) |
| WK-DMF0007-0047 | E4 | MSG00136 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00136 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0048 | E4 | MSG00141 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00141 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0007_CustFcstMaster.SaveData:1000) |
| WK-DMF0007-0049 | E4 | MSG00166 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00166 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0007_CustFcstMaster.SaveData:975:) |
| WK-DMF0007-0050 | E4 | MSG00379 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00379 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0051 | E4 | cboBucketType / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 3 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0052 | A10 | DMF0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0007 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 63 (ACT:DMF0007_CustFcstMaster.DefinePropert) |
| WK-DMF0007-0053 | A6 | DMF0007_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0007_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 70 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0054 | A6 | PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 40 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0055 | A6 | PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 38 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0056 | G1 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboActive / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0057 | G1 | cboBucketType / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0058 | G1 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0059 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0060 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0061 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0007_CustFcstMaster.FindDataFCST ) |
| WK-DMF0007-0062 | G6 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0063 | G6 | cboBucketType / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:DMF0007_CustFcstMaster.DefinePropert) |
| WK-DMF0007-0064 | G6 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0065 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0066 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0067 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0007_CustFcstMaster.InitControls ) |
| WK-DMF0007-0068 | X-REOPEN | DMF0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0007 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 11 (ACT:DMF0007_CustFcstMaster.Dispose ACT:D) |

## W7 기대값 확정 (78)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0007-0069 | C2 | DMF0007_CustFcstMaster.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.cboBucketType_SelectedIndex: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0007_CustFcstMaster.cboBucketType) |
| WK-DMF0007-0070 | C2 | DMF0007_CustFcstMaster.clbDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.clbDivision_SelectedIndexCh: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0071 | C2 | DMF0007_CustFcstMaster.clbDivisions_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.clbDivisions_SelectedIndexC: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0007_CustFcstMaster.clbDivisions_) |
| WK-DMF0007-0072 | C2 | DMF0007_CustFcstMaster.clbEndCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.clbEndCustomer_SelectedInde: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0007_CustFcstMaster.clbEndCustome) |
| WK-DMF0007-0073 | C2 | DMF0007_CustFcstMaster.clbTeam_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.clbTeam_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.clbTeam_Selec) |
| WK-DMF0007-0074 | C2 | DMF0007_CustFcstMaster.shtMainFCSTDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.shtMainFCSTDataModel_Change: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 93 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0075 | C2 | DMF0007_CustFcstMaster.shtMainPSIDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.shtMainPSIDataModel_Changed: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 28 (ACT:DMF0007_CustFcstMaster.shtMainPSIDat) |
| WK-DMF0007-0076 | C2 | DMF0007_CustFcstMaster.spdMain_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ActiveSheetChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0007_CustFcstMaster.spdMain_Activ) |
| WK-DMF0007-0077 | C2 | DMF0007_CustFcstMaster.spdMain_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ComboSelChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.spdMain_Combo) |
| WK-DMF0007-0078 | C3 | DMF0007_CustFcstMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.SetChangeControl: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0007_CustFcstMaster.SetChangeCont) |
| WK-DMF0007-0079 | C3 | DMF0007_CustFcstMaster.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.SetSaveData: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 32 (ACT:DMF0007_CustFcstMaster.SetSaveData:1) |
| WK-DMF0007-0080 | C3 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0081 | C3 | DMF0007_CustFcstMaster.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.cboBucketType_SelectedIndex: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0007_CustFcstMaster.cboBucketType) |
| WK-DMF0007-0082 | C3 | DMF0007_CustFcstMaster.clbDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.clbDivision_SelectedIndexCh: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0083 | C3 | DMF0007_CustFcstMaster.clbDivisions_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.clbDivisions_SelectedIndexC: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0007_CustFcstMaster.clbDivisions_) |
| WK-DMF0007-0084 | C3 | DMF0007_CustFcstMaster.clbEndCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.clbEndCustomer_SelectedInde: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0007_CustFcstMaster.clbEndCustome) |
| WK-DMF0007-0085 | C3 | DMF0007_CustFcstMaster.clbTeam_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.clbTeam_SelectedIndexChange: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.clbTeam_Selec) |
| WK-DMF0007-0086 | C3 | DMF0007_CustFcstMaster.shtMainFCSTDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.shtMainFCSTDataModel_Change: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 93 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0087 | C3 | DMF0007_CustFcstMaster.shtMainPSIDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.shtMainPSIDataModel_Changed: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 28 (ACT:DMF0007_CustFcstMaster.shtMainPSIDat) |
| WK-DMF0007-0088 | C3 | DMF0007_CustFcstMaster.spdMain_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ActiveSheetChanged: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0007_CustFcstMaster.spdMain_Activ) |
| WK-DMF0007-0089 | C3 | DMF0007_CustFcstMaster.spdMain_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ComboSelChange: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.spdMain_Combo) |
| WK-DMF0007-0090 | C6 | DMF0007_CustFcstMaster.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.cboBucketType_SelectedIndex: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0007_CustFcstMaster.cboBucketType) |
| WK-DMF0007-0091 | C6 | DMF0007_CustFcstMaster.clbDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.clbDivision_SelectedIndexCh: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0092 | C6 | DMF0007_CustFcstMaster.clbDivisions_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.clbDivisions_SelectedIndexC: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0007_CustFcstMaster.clbDivisions_) |
| WK-DMF0007-0093 | C6 | DMF0007_CustFcstMaster.clbEndCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.clbEndCustomer_SelectedInde: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0007_CustFcstMaster.clbEndCustome) |
| WK-DMF0007-0094 | C6 | DMF0007_CustFcstMaster.clbTeam_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.clbTeam_SelectedIndexChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.clbTeam_Selec) |
| WK-DMF0007-0095 | C6 | DMF0007_CustFcstMaster.shtMainFCSTDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.shtMainFCSTDataModel_Change: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 93 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0096 | C6 | DMF0007_CustFcstMaster.shtMainPSIDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.shtMainPSIDataModel_Changed: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 28 (ACT:DMF0007_CustFcstMaster.shtMainPSIDat) |
| WK-DMF0007-0097 | C6 | DMF0007_CustFcstMaster.spdMain_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ActiveSheetChanged: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0007_CustFcstMaster.spdMain_Activ) |
| WK-DMF0007-0098 | C6 | DMF0007_CustFcstMaster.spdMain_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ComboSelChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.spdMain_Combo) |
| WK-DMF0007-0099 | B3 | DMF0007_CustFcstMaster.GetCustFcstMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0007_CustFcstMaster.GetCustFcstMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0100 | B3 | DMF0007_CustFcstMaster.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0007_CustFcstMaster.GetSpdTitle: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0007_CustFcstMaster.GetSpdTitle:1) |
| WK-DMF0007-0101 | B4 | DMF0007_CustFcstMaster.GetCustFcstMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0007_CustFcstMaster.GetCustFcstMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0102 | B4 | DMF0007_CustFcstMaster.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0007_CustFcstMaster.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0007_CustFcstMaster.GetSpdTitle:1) |
| WK-DMF0007-0103 | DB-SYN | DMF0007_CustFcstMaster.GetCustFcstMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0007_CustFcstMaster.GetCustFcstMeasure: 진입점 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0104 | F4 | DMF0007_CustFcstMaster.GetCustFcstMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0007_CustFcstMaster.GetCustFcstMeasure: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0007_CustFcstMaster.GetCustFcstMe) |
| WK-DMF0007-0105 | A5 | DMF0007_CustFcstMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0007_CustFcstMaster.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.CreateSpread:) |
| WK-DMF0007-0106 | A5 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0107 | H2 | DMF0007_CustFcstMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0007_CustFcstMaster.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.CreateSpread:) |
| WK-DMF0007-0108 | H2 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0109 | H5 | DMF0007_CustFcstMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0007_CustFcstMaster.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.CreateSpread:) |
| WK-DMF0007-0110 | H5 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0111 | D1 | DMF0007_CustFcstMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0007_CustFcstMaster.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 36 (ACT:DMF0007_CustFcstMaster.EditButton:41) |
| WK-DMF0007-0112 | D3 | DMF0007_CustFcstMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0007_CustFcstMaster.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 36 (ACT:DMF0007_CustFcstMaster.EditButton:41) |
| WK-DMF0007-0113 | D5 | DMF0007_CustFcstMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0007_CustFcstMaster.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0007_CustFcstMaster.CreateSpread:) |
| WK-DMF0007-0114 | D5 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0115 | E4 | DMF0007_CustFcstMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0007_CustFcstMaster.SetChangeControl: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 12 (ACT:DMF0007_CustFcstMaster.SetChangeCont) |
| WK-DMF0007-0116 | E4 | DMF0007_CustFcstMaster.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0007_CustFcstMaster.SetSaveData: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 32 (ACT:DMF0007_CustFcstMaster.SetSaveData:1) |
| WK-DMF0007-0117 | E4 | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0118 | A1 | DMF0007_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0007_GET_SPREAD_TITLE: 골든 비교 케이스 없음(DMF0007_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 70 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0119 | A1 | PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA: 골든 비교 케이스 없음(PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA — 팝업·보조 SP 는 golden_ca |  | 40 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0120 | A1 | PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA: 골든 비교 케이스 없음(PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA — 팝업·보조 SP 는 golden_case |  | 38 (ACT:DMF0007_CustFcstMaster.FindButton AC) |
| WK-DMF0007-0121 | X-ROW | DMF0007_CustFcstMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.CreateSpread: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.CreateSpread) |
| WK-DMF0007-0122 | X-ROW | DMF0007_CustFcstMaster.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0007_CustFcstMaster.DefinePropert) |
| WK-DMF0007-0123 | X-ROW | DMF0007_CustFcstMaster.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된  |  | 15 (ACT:DMF0007_CustFcstMaster.ExcelButton A) |
| WK-DMF0007-0124 | X-ROW | DMF0007_CustFcstMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.FindButton: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:DMF0007_CustFcstMaster.FindButton) |
| WK-DMF0007-0125 | X-ROW | DMF0007_CustFcstMaster.FindDataFCST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.FindDataFCST: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 5 (ACT:DMF0007_CustFcstMaster.FindDataFCST:) |
| WK-DMF0007-0126 | X-ROW | DMF0007_CustFcstMaster.FindDataPSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.FindDataPSI: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · NOPATH:1 · PASS:1 |  | 5 (ACT:DMF0007_CustFcstMaster.FindDataPSI:6) |
| WK-DMF0007-0127 | X-ROW | DMF0007_CustFcstMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0007_CustFcstMaster.Form_Load ACT) |
| WK-DMF0007-0128 | X-ROW | DMF0007_CustFcstMaster.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.GetSpdTitle) |
| WK-DMF0007-0129 | X-ROW | DMF0007_CustFcstMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.InitControls: 진입점 집계 19검사 — NOT_RUN:19 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0007_CustFcstMaster.InitControls:) |
| WK-DMF0007-0130 | X-ROW | DMF0007_CustFcstMaster.InitSaveDataTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.InitSaveDataT) |
| WK-DMF0007-0131 | X-ROW | DMF0007_CustFcstMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.InitSpread: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.InitSpread) |
| WK-DMF0007-0132 | X-ROW | DMF0007_CustFcstMaster.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.InsertButton) |
| WK-DMF0007-0133 | X-ROW | DMF0007_CustFcstMaster.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/COMBO_DATA/DATA_OP/ENTRY/EXPR/GRID_CO |  | 37 (ACT:DMF0007_CustFcstMaster.InsertRow ACT) |
| WK-DMF0007-0134 | X-ROW | DMF0007_CustFcstMaster.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.SaveData: 진입점 집계 17검사 — NOT_RUN:11 · NOPATH:3 · PASS:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0007_CustFcstMaster.SaveData:979:) |
| WK-DMF0007-0135 | X-ROW | DMF0007_CustFcstMaster.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0007_CustFcstMaster.SetChangeCont) |
| WK-DMF0007-0136 | X-ROW | DMF0007_CustFcstMaster.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.SetSaveData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.SetSaveData) |
| WK-DMF0007-0137 | X-ROW | DMF0007_CustFcstMaster.SetSpreadColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.SetSpreadColor: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.SetSpreadColo) |
| WK-DMF0007-0138 | X-ROW | DMF0007_CustFcstMaster.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.cboBucketType_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.cboBucketType) |
| WK-DMF0007-0139 | X-ROW | DMF0007_CustFcstMaster.clbDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.clbDivision_SelectedIndexCh: 진입점 집계 11검사 — NOT_RUN:6 · REVIEW:3 · NOPATH:1 · TODO:1 |  | 4 (ACT:DMF0007_CustFcstMaster.clbDivision_S) |
| WK-DMF0007-0140 | X-ROW | DMF0007_CustFcstMaster.clbDivisions_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.clbDivisions_SelectedIndexC: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.clbDivisions_) |
| WK-DMF0007-0141 | X-ROW | DMF0007_CustFcstMaster.clbEndCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.clbEndCustomer_SelectedInde: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.clbEndCustome) |
| WK-DMF0007-0142 | X-ROW | DMF0007_CustFcstMaster.clbTeam_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.clbTeam_SelectedIndexChange: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0007_CustFcstMaster.clbTeam_Selec) |
| WK-DMF0007-0143 | X-ROW | DMF0007_CustFcstMaster.shtMainFCSTDataMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.shtMainFCSTDataModel_Change: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0007_CustFcstMaster.shtMainFCSTDa) |
| WK-DMF0007-0144 | X-ROW | DMF0007_CustFcstMaster.shtMainPSIDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.shtMainPSIDataModel_Changed: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0007_CustFcstMaster.shtMainPSIDat) |
| WK-DMF0007-0145 | X-ROW | DMF0007_CustFcstMaster.spdMain_ActiveShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0007_CustFcstMaster.spdMain_Activ) |
| WK-DMF0007-0146 | X-ROW | DMF0007_CustFcstMaster.spdMain_ComboSelC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0007_CustFcstMaster.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0007_CustFcstMaster.spdMain_Combo) |
