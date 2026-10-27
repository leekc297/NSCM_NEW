# 작업 원장 — SCM0019 · 2026-10-26 12:51

> 검사 인스턴스 177건 중 PASS·NA 69건 외 **108건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 3 | 구현 위치 실존 |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 32 | 실행 → PASS |
| W7 | 기대값 확정 | 64 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 61 · E2E 32 · 하네스 9 · 대조표 6
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 3 |  |  |  |  | 8 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 7 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 2 | 9 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  |  |  |  |  | 11 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D1 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 행 값 기반 조건부 잠금 |
| B4 | COMBO |  |  |  |  | 1 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| F4 | DB |  |  |  |  |  | 2 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  |  |  |  | 2 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 2 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B1 | COMBO |  |  |  |  | 1 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  | 1 |  |  | 콤보 후보 중복 없음 |
| E2 | EDIT |  |  |  |  | 2 |  |  |  |  | 날짜 형식·유효성 |
| A6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B6 | COMBO |  |  |  |  | 1 |  |  |  |  | ALL 옵션·다중선택 사양 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C1 | CASCADE |  |  |  |  |  | 1 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0019-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx 없음, nscm-fe/packages/share |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0002 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-SCM0019-0003 | X-LOC | D00-1-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/ScpIfBlockingForm.tsx:91-91 > 90줄 |  | 1 (D00-1-002) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0019-0004 | B1 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCM0019-0005 | B2 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCM0019-0006 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCM0019-0007 | B6 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCM0019-0008 | F2 | SCM0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCM0019 화면 | 판단불가(대상 단위 SCREEN) | 48 (D00-4d-002 COMMON:UC-04 SaveButton ACT:S) |
| WK-SCM0019-0009 | F6 | SCM0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCM0019 화면 | 판단불가(대상 단위 SCREEN) | 46 (SaveButton ACT:SCM0019_SCP_Interface_Blo) |
| WK-SCM0019-0010 | E2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-3-002) |
| WK-SCM0019-0011 | E2 | PLAN_START_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL PLAN_START_YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (D00-3-002) |
| WK-SCM0019-0012 | G03-WIRE | SCM0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCM0019 화면 | 판단불가(대상 단위 SCREEN) | 3 (ACT:SCM0019_SCP_Interface_Blocking..ctor) |

## W6 검증 실행 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0019-0013 | J2 | SCM0019 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCM0019 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 15 (D00-1-003 D00-3-003 D00-4d-001 D00-4d-00) |
| WK-SCM0019-0014 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.InitC) |
| WK-SCM0019-0015 | G3 | SCM0019 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCM0019 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (D00-1-003 COMMON:UC-02 COMMON:UC-04 COMM) |
| WK-SCM0019-0016 | K-SA | SCM0019 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCM0019 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (D00-1-003 COMMON:UC-02) |
| WK-SCM0019-0017 | K4 | SCM0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCM0019 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 4 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCM0019-0018 | F1 | SCM0019 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCM0019 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 50 (D00-4d-002 D00-4d-004 COMMON:UC-04 SaveB) |
| WK-SCM0019-0019 | F5 | SCM0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCM0019 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (D00-4d-004 DeleteButton) |
| WK-SCM0019-0020 | F4 | PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_BLOCKING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 74 (ACT:SCM0019_SCP_Interface_Blocking.FindB) |
| WK-SCM0019-0021 | F4 | PKG_SCM0019.P_SCM0019_SAVE_SCP_INTERFACE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0019.P_SCM0019_SAVE_SCP_INTERFACE_BLOCKING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 45 (ACT:SCM0019_SCP_Interface_Blocking.SaveB) |
| WK-SCM0019-0022 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-001 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0023 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-002) |
| WK-SCM0019-0024 | I1 | SCM0019 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCM0019 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 5 (D00-4d-001 COMMON:UC-02 COMMON:UC-04 ACT) |
| WK-SCM0019-0025 | SC1 | SCM0019 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCM0019 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 4 (D00-1-001 D00-1-002 D00-1-003 D00-1-007) |
| WK-SCM0019-0026 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-002 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0027 | D1 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-002 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0028 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-002 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0029 | D3 | PLAN_START_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-002 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0030 | D6 | SCM0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCM0019 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (D00-4d-003 InsertButton) |
| WK-SCM0019-0031 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SCM0019-0032 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.SaveD) |
| WK-SCM0019-0033 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 ACT:SCM0019_SCP_Interface_B) |
| WK-SCM0019-0034 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-001) |
| WK-SCM0019-0035 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SCM0019-0036 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0037 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCM0019_SCP_Interface_Blocking.SetCh) |
| WK-SCM0019-0038 | A10 | SCM0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCM0019 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 16 (ACT:SCM0019_SCP_Interface_Blocking.Form_) |
| WK-SCM0019-0039 | A6 | PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_BLOCKING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 31 (ACT:SCM0019_SCP_Interface_Blocking.FindB) |
| WK-SCM0019-0040 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-001 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0041 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-002 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0042 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-001 ACT:SCM0019_SCP_Interface_Bloc) |
| WK-SCM0019-0043 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-002) |
| WK-SCM0019-0044 | X-REOPEN | SCM0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCM0019 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCM0019_SCP_Interface_Blocking.Dispo) |

## W7 기대값 확정 (64)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0019-0045 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCM0019-0046 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCM0019-0047 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCM0019-0048 | B4 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-002: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCM0019-0049 | B4 | YN 셀콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — YN 셀콤보: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (YN 셀콤보) |
| WK-SCM0019-0050 | F4 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCM0019-0051 | F4 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCM0019-0052 | G4 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-003: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SCM0019-0053 | G4 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-007: 행 집계 — G4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-007) |
| WK-SCM0019-0054 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) — 조회조건에 key-in 텍스트 입력 없음(Division=체크리스트 콤보, Period=날짜 p |  | 1 (COMMON:UC-06) |
| WK-SCM0019-0055 | X-REASON | D00-1-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-012 §1 emptySpaceItem1 / EmptySpaceItem — DevExpress 여백 필러(시각 전용) — 대응 컨트롤 없음 해당없음 |  | 1 (D00-1-012) |
| WK-SCM0019-0056 | X-REASON | D00-3-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-004 §3 LockColumn / 전열(0~max) 잠금(true) — 조회직후 — 조회직후 전열잠금 = EditButton 편집모드 OFF 상태(토글로 해제) — ANL-06 토글 어포 |  | 1 (D00-3-004) |
| WK-SCM0019-0057 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0058 | D1 | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton) |
| WK-SCM0019-0059 | D1 | SCM0019_SCP_Interface_Blocking.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCM0019_SCP_Interface_Blocking.EditButton: 진입점 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0019_SCP_Interface_Blocking.EditB) |
| WK-SCM0019-0060 | D1 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SaveButton: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCM0019-0061 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0062 | D3 | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton) |
| WK-SCM0019-0063 | D3 | SCM0019_SCP_Interface_Blocking.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCM0019_SCP_Interface_Blocking.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0019_SCP_Interface_Blocking.EditB) |
| WK-SCM0019-0064 | D3 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveButton: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCM0019-0065 | E4 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-002: 행 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCM0019-0066 | E4 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — FindButton: 행 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCM0019-0067 | E4 | SCM0019_SCP_Interface_Blocking.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0019_SCP_Interface_Blocking.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0019_SCP_Interface_Blocking.SetCh) |
| WK-SCM0019-0068 | E4 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton: 행 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCM0019-0069 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0070 | A1 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-04: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-04) |
| WK-SCM0019-0071 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCM0019-0072 | A1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-003: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-1-003) |
| WK-SCM0019-0073 | A1 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-003: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-003) |
| WK-SCM0019-0074 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-4d-001) |
| WK-SCM0019-0075 | A1 | Division(조회) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division(조회): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Division(조회)) |
| WK-SCM0019-0076 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (FindButton) |
| WK-SCM0019-0077 | A1 | PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_BLOCKING: 골든 비교 케이스 없음(PKG_SCM0019.P_SCM0019_GET_SCP_INTERFACE_BLOCKING — 팝업·보 |  | 31 (ACT:SCM0019_SCP_Interface_Blocking.FindB) |
| WK-SCM0019-0078 | A6 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCM0019-0079 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCM0019-0080 | G1 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-04: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCM0019-0081 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCM0019-0082 | G1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-003: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SCM0019-0083 | G1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-007: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-007) |
| WK-SCM0019-0084 | G1 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-003: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SCM0019-0085 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCM0019-0086 | G1 | Division(조회) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Division(조회): 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Division(조회)) |
| WK-SCM0019-0087 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCM0019-0088 | G6 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-003: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-003) |
| WK-SCM0019-0089 | G6 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-007: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-007) |
| WK-SCM0019-0090 | X-LOC | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton) |
| WK-SCM0019-0091 | X-LOC | Division(조회) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division(조회): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division(조회)) |
| WK-SCM0019-0092 | X-LOC | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton) |
| WK-SCM0019-0093 | X-LOC | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton) |
| WK-SCM0019-0094 | X-LOC | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton) |
| WK-SCM0019-0095 | X-LOC | Period 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Period 기본값: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Period 기본값) |
| WK-SCM0019-0096 | X-LOC | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton) |
| WK-SCM0019-0097 | X-LOC | YN 셀콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — YN 셀콤보: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (YN 셀콤보) |
| WK-SCM0019-0098 | X-ROW | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-010) |
| WK-SCM0019-0099 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SCM0019-0100 | X-ROW | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-001) |
| WK-SCM0019-0101 | X-ROW | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-003) |
| WK-SCM0019-0102 | X-ROW | SCM0019_SCP_Interface_Blocking.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.Creat) |
| WK-SCM0019-0103 | X-ROW | SCM0019_SCP_Interface_Blocking.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.FindB) |
| WK-SCM0019-0104 | X-ROW | SCM0019_SCP_Interface_Blocking.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.FindData: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:1 · PASS:1 |  | 6 (ACT:SCM0019_SCP_Interface_Blocking.FindD) |
| WK-SCM0019-0105 | X-ROW | SCM0019_SCP_Interface_Blocking.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.Form_) |
| WK-SCM0019-0106 | X-ROW | SCM0019_SCP_Interface_Blocking.InitContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0019_SCP_Interface_Blocking.InitC) |
| WK-SCM0019-0107 | X-ROW | SCM0019_SCP_Interface_Blocking.InitSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0019_SCP_Interface_Blocking.InitS) |
| WK-SCM0019-0108 | X-ROW | SCM0019_SCP_Interface_Blocking.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0019_SCP_Interface_Blocking.SetChangedPeriod: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0019_SCP_Interface_Blocking.SetCh) |
