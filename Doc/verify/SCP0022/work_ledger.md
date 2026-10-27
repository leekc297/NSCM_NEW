# 작업 원장 — SCP0022 · 2026-10-26 12:53

> 검사 인스턴스 260건 중 PASS·NA 112건 외 **148건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W5 | 검사기 연결 | 6 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 42 | 실행 → PASS |
| W7 | 기대값 확정 | 97 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 2 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 97 · E2E 42 · 하네스 6 · 선행 W1 완료 후 E2E 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 45 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 28 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 18 | 8 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 7 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 3 | 3 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  |  |  |  | 5 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G5 | POPUP |  |  |  |  | 1 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  | 2 |  |  | 팝업 표준·열림 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M4 | POPUP |  |  |  |  |  | 1 | 2 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 1 | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G6 | GEN |  |  |  |  |  | 1 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| H2 | DESIGN |  |  |  |  |  |  |  | 1 |  | 배경·글자색 규칙 |
| E3 | EDIT |  |  |  |  |  |  |  | 1 |  | 필수 입력 검증 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0022-0001 | X-NOTIMPL | 겹침행 셀 색상(InvalidColor) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — 겹침행 셀 색상(InvalidColor) 미구현(잔여·저) 클라 pre-check MSG00105 로 저장 차단·서버 rollback 으로 무결성 보장. 시각 하이라이트만 잔여(사용자 축) |  | 1 (겹침행 셀 색상(InvalidColor)) |

## W5 검사기 연결 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0022-0002 | F2 | SCP0022 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0022 화면 | 판단불가(대상 단위 SCREEN) | 70 (MSG00108 MSG00048 MSG00105 MSG00020 / MS) |
| WK-SCP0022-0003 | F6 | SCP0022 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0022 화면 | 판단불가(대상 단위 SCREEN) | 61 (ACT:SCP0022_Formation.SaveButton ACT:SCP) |
| WK-SCP0022-0004 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0022_Formation.InitEvent ACT:SCP0) |
| WK-SCP0022-0005 | G03-WIRE | SCP0022 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0022 화면 | 판단불가(대상 단위 SCREEN) | 17 (ACT:SCP0022_Formation..ctor ACT:SCP0022_) |
| WK-SCP0022-0006 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (검색조건) |
| WK-SCP0022-0007 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (검색조건) |

## W6 검증 실행 (42)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0022-0008 | J2 | SCP0022 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0022 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 31 (상단 그리드 하단 탭1 하단 탭2 탭 전환 MSG00071 MSG0010) |
| WK-SCP0022-0009 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0022_Formation.InitControls:241:4) |
| WK-SCP0022-0010 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0022_Formation.SetChangedControl:) |
| WK-SCP0022-0011 | K4 | SCP0022 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0022 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 12 (ACT:SCP0022_Formation.btnItemId_Click AC) |
| WK-SCP0022-0012 | F1 | SCP0022 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0022 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 80 (하단 탭1 하단 탭2 MSG00108 MSG00048 MSG00105 M) |
| WK-SCP0022-0013 | F5 | SCP0022 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0022 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 11 (하단 탭1 하단 탭2 버튼 API(2.8) 버튼 게이팅(FE) ACT:S) |
| WK-SCP0022-0014 | F4 | PKG_SCP0022.P_SCP0022_GET_FORMATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 107 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0015 | F4 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 45 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0016 | F4 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 44 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0017 | F4 | PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXCEPT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 11 (ACT:SCP0022_Formation.SaveButton ACT:SCP) |
| WK-SCP0022-0018 | F4 | PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0022.P_SCP0022_SAVE_FORMATION_EXCEPT_LT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 11 (ACT:SCP0022_Formation.SaveButton ACT:SCP) |
| WK-SCP0022-0019 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0022_Formation.InitControls ACT:S) |
| WK-SCP0022-0020 | I1 | SCP0022 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0022 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 43 (탭 전환 MSG00203({1,100})→MSG01037 MSG00193) |
| WK-SCP0022-0021 | D6 | SCP0022 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0022 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 19 (상단 그리드 하단 탭1 하단 탭2 MSG00071 신규행 상속(Div/P) |
| WK-SCP0022-0022 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00020 / MSG00004) |
| WK-SCP0022-0023 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00020 / MSG00004 ACT:SCP0022_Formatio) |
| WK-SCP0022-0024 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00020 / MSG00004 ACT:SCP0022_Formatio) |
| WK-SCP0022-0025 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00043 ACT:SCP0022_Formation.SaveExcep) |
| WK-SCP0022-0026 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00048 MSG 라벨 ACT:SCP0022_Formation.ch) |
| WK-SCP0022-0027 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (MSG00049(형식) ACT:SCP0022_Formation.check) |
| WK-SCP0022-0028 | E4 | MSG00071 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00071 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00071 ACT:SCP0022_Formation.InsertBut) |
| WK-SCP0022-0029 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00085 ACT:SCP0022_Formation.ValidateU) |
| WK-SCP0022-0030 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00105 MSG00043 기간 겹침 색상(InvalidColor)) |
| WK-SCP0022-0031 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00108 ACT:SCP0022_Formation.checkVali) |
| WK-SCP0022-0032 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (탭 전환 MSG00129 ACT:SCP0022_Formation.SpdE) |
| WK-SCP0022-0033 | E4 | MSG00160 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00160 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0022_Formation.ValidateUserInput:) |
| WK-SCP0022-0034 | E4 | MSG00193 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00193 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00193→MSG00699 ACT:SCP0022_Formation.) |
| WK-SCP0022-0035 | E4 | MSG00203 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00203 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00203({1,100})→MSG01037 ACT:SCP0022_F) |
| WK-SCP0022-0036 | E4 | MSG00699 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00699 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00193→MSG00699) |
| WK-SCP0022-0037 | E4 | MSG01037 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01037 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00203({1,100})→MSG01037) |
| WK-SCP0022-0038 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0022_Formation.SetChangedControl ) |
| WK-SCP0022-0039 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0022_Formation.SetChangedControl ) |
| WK-SCP0022-0040 | A10 | SCP0022 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0022 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 58 (ACT:SCP0022_Formation.DefineProperty ACT) |
| WK-SCP0022-0041 | A6 | PKG_SCP0022.P_SCP0022_GET_FORMATION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 46 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0042 | A6 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 35 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0043 | A6 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 34 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0044 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0022_Formation.FindData_Except AC) |
| WK-SCP0022-0045 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0022_Formation.FindData_Except AC) |
| WK-SCP0022-0046 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0022_Formation.FindData_Except AC) |
| WK-SCP0022-0047 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0022_Formation.InitControls ACT:S) |
| WK-SCP0022-0048 | X-REOPEN | SCP0022 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0022 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 10 (ACT:SCP0022_Formation.Dispose ACT:SCP002) |
| WK-SCP0022-0049 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (검색조건) |

## W7 기대값 확정 (97)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0022-0050 | E4 | DB 메타 게이트(ora.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DB 메타 게이트(ora.py): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (DB 메타 게이트(ora.py)) |
| WK-SCP0022-0051 | E4 | FE 소스 대조 + grep 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — FE 소스 대조 + grep 게이트: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (FE 소스 대조 + grep 게이트) |
| WK-SCP0022-0052 | E4 | SCP0022_Formation.SetCellFocus_ERROR | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0022_Formation.SetCellFocus_ERROR: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SetCellFocus_ERROR) |
| WK-SCP0022-0053 | E4 | SCP0022_Formation.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0022_Formation.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SetChangedControl:) |
| WK-SCP0022-0054 | E4 | SCP0022_Formation.setTotalYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0022_Formation.setTotalYield: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0022_Formation.setTotalYield:1849) |
| WK-SCP0022-0055 | E4 | lint(formation 폴더) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — lint(formation 폴더): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (lint(formation 폴더)) |
| WK-SCP0022-0056 | E4 | type-check(supply 도메인) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — type-check(supply 도메인): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (type-check(supply 도메인)) |
| WK-SCP0022-0057 | E4 | 브라우저 시각·조작 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 시각·조작: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작) |
| WK-SCP0022-0058 | A1 | ORG_* 5키 왕복(기간키 변경) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ORG_* 5키 왕복(기간키 변경): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (ORG_* 5키 왕복(기간키 변경)) |
| WK-SCP0022-0059 | A1 | PKG_SCP0022.P_SCP0022_GET_FORMATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0022.P_SCP0022_GET_FORMATION: 골든 비교 케이스 없음(PKG_SCP0022.P_SCP0022_GET_FORMATION — 팝업·보조 SP 는 golden_cases.csv 에  |  | 46 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0060 | A1 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT: 골든 비교 케이스 없음(PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT — 팝업·보조 SP 는 golde |  | 35 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0061 | A1 | PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT: 골든 비교 케이스 없음(PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT — 팝업·보조 SP 는 |  | 34 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0062 | A1 | Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plant Site: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (Plant Site) |
| WK-SCP0022-0063 | A1 | 검색조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 검색조건: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SCP0022-0064 | A1 | 버튼 게이팅(FE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 버튼 게이팅(FE): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (버튼 게이팅(FE)) |
| WK-SCP0022-0065 | G1 | ORG_* 5키 왕복(기간키 변경) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ORG_* 5키 왕복(기간키 변경): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ORG_* 5키 왕복(기간키 변경)) |
| WK-SCP0022-0066 | G1 | Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plant Site: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Plant Site) |
| WK-SCP0022-0067 | G1 | 버튼 게이팅(FE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 버튼 게이팅(FE): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (버튼 게이팅(FE)) |
| WK-SCP0022-0068 | X-LOC | DB 메타 게이트(ora.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DB 메타 게이트(ora.py): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DB 메타 게이트(ora.py)) |
| WK-SCP0022-0069 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SCP0022-0070 | X-LOC | FE 소스 대조 + grep 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FE 소스 대조 + grep 게이트: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FE 소스 대조 + grep 게이트) |
| WK-SCP0022-0071 | X-LOC | MSG 라벨 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG 라벨: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG 라벨) |
| WK-SCP0022-0072 | X-LOC | MSG00020 / MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00020 / MSG00004: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00020 / MSG00004) |
| WK-SCP0022-0073 | X-LOC | MSG00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00043: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00043) |
| WK-SCP0022-0074 | X-LOC | MSG00049(형식) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00049(형식): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00049(형식)) |
| WK-SCP0022-0075 | X-LOC | MSG00085 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085) |
| WK-SCP0022-0076 | X-LOC | MSG00193→MSG00699 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00193→MSG00699: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00193→MSG00699) |
| WK-SCP0022-0077 | X-LOC | MSG00203({1,100})→MSG01037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00203({1,100})→MSG01037: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00203({1,100})→MSG01037) |
| WK-SCP0022-0078 | X-LOC | Material(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Material(Item): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Material(Item)) |
| WK-SCP0022-0079 | X-LOC | Measure(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Measure(2.75): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Measure(2.75)) |
| WK-SCP0022-0080 | X-LOC | ORG_* 5키 왕복(기간키 변경) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ORG_* 5키 왕복(기간키 변경): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ORG_* 5키 왕복(기간키 변경)) |
| WK-SCP0022-0081 | X-LOC | PKG_SCP0022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PKG_SCP0022: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PKG_SCP0022) |
| WK-SCP0022-0082 | X-LOC | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge) |
| WK-SCP0022-0083 | X-LOC | lint(formation 폴더) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — lint(formation 폴더): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (lint(formation 폴더)) |
| WK-SCP0022-0084 | X-LOC | setTotalYield 파생 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — setTotalYield 파생: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (setTotalYield 파생) |
| WK-SCP0022-0085 | X-LOC | type-check(supply 도메인) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — type-check(supply 도메인): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (type-check(supply 도메인)) |
| WK-SCP0022-0086 | X-LOC | 권한(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 권한(2.8): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (권한(2.8)) |
| WK-SCP0022-0087 | X-LOC | 그리드 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 콤보: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 콤보) |
| WK-SCP0022-0088 | X-LOC | 기간 겹침 색상(InvalidColor) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 기간 겹침 색상(InvalidColor): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (기간 겹침 색상(InvalidColor)) |
| WK-SCP0022-0089 | X-LOC | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메뉴 등록(2.7): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0022-0090 | X-LOC | 버튼 API(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 버튼 API(2.8): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (버튼 API(2.8)) |
| WK-SCP0022-0091 | X-LOC | 브라우저 시각·조작 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 시각·조작: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 시각·조작) |
| WK-SCP0022-0092 | X-LOC | 상속셀·키·감사 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 상속셀·키·감사 잠금: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (상속셀·키·감사 잠금) |
| WK-SCP0022-0093 | X-LOC | 컬럼 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 컬럼 메타(2.75): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (컬럼 메타(2.75)) |
| WK-SCP0022-0094 | X-LOC | 콤보(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 콤보(2.76): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (콤보(2.76)) |
| WK-SCP0022-0095 | X-LOC | 편집가능 셀 white-list | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 편집가능 셀 white-list: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (편집가능 셀 white-list) |
| WK-SCP0022-0096 | X-ROW | Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Layout: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Layout) |
| WK-SCP0022-0097 | X-ROW | Measure(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Measure(2.75): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Measure(2.75)) |
| WK-SCP0022-0098 | X-ROW | SCP0022_Formation.CboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.CboDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.CboDivision_Select) |
| WK-SCP0022-0099 | X-ROW | SCP0022_Formation.CheckDigitValueEntered | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.CheckDigitValueEntered: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 53 (ACT:SCP0022_Formation.CheckDigitValueEnt) |
| WK-SCP0022-0100 | X-ROW | SCP0022_Formation.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.CreateSpread) |
| WK-SCP0022-0101 | X-ROW | SCP0022_Formation.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0022_Formation.DefineProperty ACT) |
| WK-SCP0022-0102 | X-ROW | SCP0022_Formation.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.EditButton) |
| WK-SCP0022-0103 | X-ROW | SCP0022_Formation.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.FindButton: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 7 (ACT:SCP0022_Formation.FindButton ACT:SCP) |
| WK-SCP0022-0104 | X-ROW | SCP0022_Formation.FindData_Except | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.FindData_Except: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · PASS:1 |  | 1 (ACT:SCP0022_Formation.FindData_Except:17) |
| WK-SCP0022-0105 | X-ROW | SCP0022_Formation.FindData_ExceptLT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.FindData_ExceptLT: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · PASS:1 |  | 1 (ACT:SCP0022_Formation.FindData_ExceptLT:) |
| WK-SCP0022-0106 | X-ROW | SCP0022_Formation.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0022_Formation.FindData_Main:1665) |
| WK-SCP0022-0107 | X-ROW | SCP0022_Formation.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.Form_Load) |
| WK-SCP0022-0108 | X-ROW | SCP0022_Formation.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0022_Formation.InitControls:237:2) |
| WK-SCP0022-0109 | X-ROW | SCP0022_Formation.InitCurrentCellFocusIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.InitCurrentCellFocusIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.InitCurrentCellFoc) |
| WK-SCP0022-0110 | X-ROW | SCP0022_Formation.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.InitSpread) |
| WK-SCP0022-0111 | X-ROW | SCP0022_Formation.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.InsertButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.InsertButton) |
| WK-SCP0022-0112 | X-ROW | SCP0022_Formation.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_LOCK/GRID_SET/LOCAL, 연결된 요소 검 |  | 45 (ACT:SCP0022_Formation.InsertRow ACT:SCP0) |
| WK-SCP0022-0113 | X-ROW | SCP0022_Formation.ReturnStringDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.ReturnStringDate: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0022_Formation.ReturnStringDate A) |
| WK-SCP0022-0114 | X-ROW | SCP0022_Formation.SaveExcept | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SaveExcept: 진입점 집계 8검사 — NOT_RUN:6 · PASS:2 (미실행 검사가 남아 판정필요) |  | 93 (ACT:SCP0022_Formation.SaveExcept ACT:SCP) |
| WK-SCP0022-0115 | X-ROW | SCP0022_Formation.SaveExceptLT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SaveExceptLT: 진입점 집계 8검사 — NOT_RUN:6 · PASS:2 (미실행 검사가 남아 판정필요) |  | 91 (ACT:SCP0022_Formation.SaveExceptLT ACT:S) |
| WK-SCP0022-0116 | X-ROW | SCP0022_Formation.SetCellFocus_ERROR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SetCellFocus_ERROR: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0022_Formation.SetCellFocus_ERROR) |
| WK-SCP0022-0117 | X-ROW | SCP0022_Formation.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0022_Formation.SetChangedControl ) |
| WK-SCP0022-0118 | X-ROW | SCP0022_Formation.SpdExcept_ActiveSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdExcept_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SpdExcept_ActiveSh) |
| WK-SCP0022-0119 | X-ROW | SCP0022_Formation.SpdExcept_ActiveSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdExcept_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0022_Formation.SpdExcept_ActiveSh) |
| WK-SCP0022-0120 | X-ROW | SCP0022_Formation.SpdExcept_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdExcept_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SpdExcept_Changed) |
| WK-SCP0022-0121 | X-ROW | SCP0022_Formation.SpdExcept_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdExcept_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0022_Formation.SpdExcept_EditChan) |
| WK-SCP0022-0122 | X-ROW | SCP0022_Formation.SpdExcept_EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdExcept_EditModeOff: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0022_Formation.SpdExcept_EditMode) |
| WK-SCP0022-0123 | X-ROW | SCP0022_Formation.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0022_Formation.SpdMain_CellClick ) |
| WK-SCP0022-0124 | X-ROW | SCP0022_Formation.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SpdMain_CellDouble) |
| WK-SCP0022-0125 | X-ROW | SCP0022_Formation.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0022_Formation.SpdMain_Changed) |
| WK-SCP0022-0126 | X-ROW | SCP0022_Formation.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0022_Formation.SpdMain_EditChange) |
| WK-SCP0022-0127 | X-ROW | SCP0022_Formation.SpdMain_EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.SpdMain_EditModeOff: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0022_Formation.SpdMain_EditModeOf) |
| WK-SCP0022-0128 | X-ROW | SCP0022_Formation.ValidateUserInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.ValidateUserInput: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0022_Formation.ValidateUserInput ) |
| WK-SCP0022-0129 | X-ROW | SCP0022_Formation.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0022_Formation.btnItemId_Click:18) |
| WK-SCP0022-0130 | X-ROW | SCP0022_Formation.checkValidLTN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidLTN0: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 22 (ACT:SCP0022_Formation.checkValidLTN0 ACT) |
| WK-SCP0022-0131 | X-ROW | SCP0022_Formation.checkValidLTN5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidLTN5: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 41 (ACT:SCP0022_Formation.checkValidLTN5 ACT) |
| WK-SCP0022-0132 | X-ROW | SCP0022_Formation.checkValidLTN8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidLTN8: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCP0022_Formation.checkValidLTN8 ACT) |
| WK-SCP0022-0133 | X-ROW | SCP0022_Formation.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidN0: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 22 (ACT:SCP0022_Formation.checkValidN0 ACT:S) |
| WK-SCP0022-0134 | X-ROW | SCP0022_Formation.checkValidN5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidN5: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 41 (ACT:SCP0022_Formation.checkValidN5 ACT:S) |
| WK-SCP0022-0135 | X-ROW | SCP0022_Formation.checkValidN8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.checkValidN8: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCP0022_Formation.checkValidN8 ACT:S) |
| WK-SCP0022-0136 | X-ROW | SCP0022_Formation.setTotalYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0022_Formation.setTotalYield: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0022_Formation.setTotalYield ACT:) |
| WK-SCP0022-0137 | X-ROW | 권한(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 권한(2.8): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (권한(2.8)) |
| WK-SCP0022-0138 | X-ROW | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 메뉴 등록(2.7): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0022-0139 | X-ROW | 컬럼 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 컬럼 메타(2.75): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (컬럼 메타(2.75)) |
| WK-SCP0022-0140 | X-ROW | 콤보(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 콤보(2.76): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (콤보(2.76)) |
| WK-SCP0022-0141 | G5 | Material(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Material(Item): 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Material(Item)) |
| WK-SCP0022-0142 | G5 | SCP0022_Formation.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0022_Formation.SpdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0022_Formation.SpdMain_CellDouble) |
| WK-SCP0022-0143 | H6 | Material(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Material(Item): 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Material(Item)) |
| WK-SCP0022-0144 | H6 | SCP0022_Formation.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0022_Formation.SpdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0022_Formation.SpdMain_CellDouble) |
| WK-SCP0022-0145 | M4 | Material(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Material(Item): 행 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Material(Item)) |
| WK-SCP0022-0146 | M4 | SCP0022_Formation.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0022_Formation.SpdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0022_Formation.SpdMain_CellDouble) |

## W8 구현 후 검증 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0022-0147 | H2 | 겹침행 셀 색상(InvalidColor) | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 겹침행 셀 색상(InvalidColor) 구현 후 검증 · 대상 겹침행 셀 색상(InvalidColor) |  | 1 (겹침행 셀 색상(InvalidColor)) |
| WK-SCP0022-0148 | E3 | 겹침행 셀 색상(InvalidColor) | 선행 W1 완료 후 E2E | E3 — 대조표 미구현 행 겹침행 셀 색상(InvalidColor) 구현 후 검증 · 대상 겹침행 셀 색상(InvalidColor) |  | 1 (겹침행 셀 색상(InvalidColor)) |
