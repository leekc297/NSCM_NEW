# 작업 원장 — SSP0020 · 2026-10-26 12:56

> 검사 인스턴스 197건 중 PASS·NA 39건 외 **158건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 6 | 구현 위치 실존 |
| W5 | 검사기 연결 | 10 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 63 | 실행 → PASS |
| W7 | 기대값 확정 | 79 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 75 · E2E 63 · 대조표 10 · 하네스 10
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| E4 | EDIT |  |  |  |  |  | 18 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 13 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  | 6 |  |  |  |  | 5 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| F4 | DB |  |  |  |  |  | 7 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A5 | DESIGN |  |  |  |  |  | 1 | 7 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 7 |  |  | 배경·글자색 규칙 |
| A6 | GEN |  |  |  |  |  | 7 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  | 3 | 4 |  |  |  | 조회조건 표시·라벨·활성 |
| G1 | GEN |  |  |  |  |  | 1 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H5 | DESIGN |  |  |  |  |  | 3 | 3 |  |  | 라벨 명칭 |
| DB-SYN | DB |  |  |  |  | 3 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| G6 | GEN |  |  |  |  |  | 4 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| G5 | POPUP |  |  |  |  | 1 |  | 1 |  |  | 팝업 조건 연동(인자) |
| C3 | CASCADE |  |  |  |  |  | 1 | 1 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| H6 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
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

## W2 구현 위치 확인 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0020-0001 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SSP0020-0002 | X-LOC | DeleteButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton) |
| WK-SSP0020-0003 | X-LOC | EditButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton) |
| WK-SSP0020-0004 | X-LOC | FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton) |
| WK-SSP0020-0005 | X-LOC | InsertButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton) |
| WK-SSP0020-0006 | X-LOC | SaveButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton) |

## W5 검사기 연결 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0020-0007 | F2 | SSP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0020 화면 | 판단불가(대상 단위 SCREEN) | 47 (2 6 7 8 9 11 16 17 SaveButton COMMON:UC-) |
| WK-SSP0020-0008 | F6 | SSP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0020 화면 | 판단불가(대상 단위 SCREEN) | 40 (2 3 4 ACT:SSP0020_Delegate.SaveData ACT:) |
| WK-SSP0020-0009 | DB-SYN | SSP0020_GET_DELEGATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0020_GET_DELEGATE | 없음(PROC_M 대응 없음) | 6 (1 ACT:SSP0020_Delegate.FindData_Main:264) |
| WK-SSP0020-0010 | DB-SYN | SSP0020_SAVE_DELEGATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0020_SAVE_DELEGATE | 없음(PROC_M 대응 없음) | 3 (2 ACT:SSP0020_Delegate.SaveData:507:19 A) |
| WK-SSP0020-0011 | DB-SYN | SSP0020_SAVE_UNSET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0020_SAVE_UNSET | 없음(PROC_M 대응 없음) | 6 (3 4 ACT:SSP0020_Delegate.UnSet:657:51 AC) |
| WK-SSP0020-0012 | G4 | btnDelegatee | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnDelegatee | 있음(FE 소스) | 2 (ACT:SSP0020_Delegate.InitEvent ACT:SSP00) |
| WK-SSP0020-0013 | G4 | btnSave | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSave | 있음(FE 소스) | 2 (ACT:SSP0020_Delegate.InitEvent ACT:SSP00) |
| WK-SSP0020-0014 | G4 | btnUnSet | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUnSet | 있음(FE 소스) | 2 (ACT:SSP0020_Delegate.InitEvent ACT:SSP00) |
| WK-SSP0020-0015 | G03-WIRE | SSP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0020 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SSP0020_Delegate..ctor ACT:SSP0020_D) |
| WK-SSP0020-0016 | G5 | txtDelegatee / Delegatee | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtDelegatee / Delegatee | 있음(FE 소스) | 7 (ACT:SSP0020_Delegate.UserPopup ACT:SSP00) |

## W6 검증 실행 (63)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0020-0017 | J2 | SSP0020 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0020 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 42 (1 2 6 7 8 9 11 16 17 FindButton InsertBu) |
| WK-SSP0020-0018 | C3 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0020_Delegate.InitSpread:216:13 A) |
| WK-SSP0020-0019 | G3 | SSP0020 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0020 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (6 SaveButton COMMON:UC-04 COMMON:UC-07) |
| WK-SSP0020-0020 | K-SA | SSP0020 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0020 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (6 SaveButton) |
| WK-SSP0020-0021 | K4 | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 28 (COMMON:UC-04 COMMON:UC-07 ACT:SSP0020_De) |
| WK-SSP0020-0022 | F1 | SSP0020 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0020 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 50 (2 3 4 6 7 8 9 11 16 17 DeleteButton Save) |
| WK-SSP0020-0023 | F5 | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton) |
| WK-SSP0020-0024 | F4 | PKG_SSP0020.P_GET_DELEGATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_GET_DELEGATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (1) |
| WK-SSP0020-0025 | F4 | PKG_SSP0020.P_SAVE_DELEGATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_SAVE_DELEGATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (2) |
| WK-SSP0020-0026 | F4 | PKG_SSP0020.P_SAVE_UNSET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_SAVE_UNSET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (3) |
| WK-SSP0020-0027 | F4 | PKG_SSP0020.P_USER_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (5) |
| WK-SSP0020-0028 | F4 | SSP0020_GET_DELEGATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0020_GET_DELEGATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 45 (1 ACT:SSP0020_Delegate.FindButton ACT:SS) |
| WK-SSP0020-0029 | F4 | SSP0020_SAVE_DELEGATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0020_SAVE_DELEGATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 38 (2 ACT:SSP0020_Delegate.SaveData ACT:SSP0) |
| WK-SSP0020-0030 | F4 | SSP0020_SAVE_UNSET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0020_SAVE_UNSET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 6 (3 4 ACT:SSP0020_Delegate.UnSet:657:51 AC) |
| WK-SSP0020-0031 | A5 | CHK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0020_Delegate.InitSpread ACT:SSP0) |
| WK-SSP0020-0032 | G4 | chkAll / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkAll / All · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0033 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0034 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0035 | G4 | txtDelegatee / Delegatee | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtDelegatee / Delegatee · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0036 | H2 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0020_Delegate.InitSpread ACT:SSP0) |
| WK-SSP0020-0037 | H4 | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 3 (ACT:SSP0020_Delegate.SpdMain_TopChange A) |
| WK-SSP0020-0038 | H5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0020_Delegate.InitSpread ACT:SSP0) |
| WK-SSP0020-0039 | H5 | chkAll / All | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkAll / All · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SSP0020-0040 | H5 | clbDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SSP0020-0041 | I1 | SSP0020 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0020 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 30 (7 8 9 10 11 12 13 14 15 16 17 ACT:SSP002) |
| WK-SSP0020-0042 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0020_Delegate.FindData_Main:294:2) |
| WK-SSP0020-0043 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0020_Delegate.FindData_Main:294:2) |
| WK-SSP0020-0044 | D5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0020_Delegate.InitSpread ACT:SSP0) |
| WK-SSP0020-0045 | D6 | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (InsertButton) |
| WK-SSP0020-0046 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (11 15) |
| WK-SSP0020-0047 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (9 13 ACT:SSP0020_Delegate.SaveData:523:3) |
| WK-SSP0020-0048 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (8) |
| WK-SSP0020-0049 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:42) |
| WK-SSP0020-0050 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:38) |
| WK-SSP0020-0051 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:39) |
| WK-SSP0020-0052 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (10 14 ACT:SSP0020_Delegate.SaveData:528:) |
| WK-SSP0020-0053 | E4 | MSG00296 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00296 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:44) |
| WK-SSP0020-0054 | E4 | MSG00297 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00297 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (7 ACT:SSP0020_Delegate.Validation_Check:) |
| WK-SSP0020-0055 | E4 | MSG00298 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00298 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:37) |
| WK-SSP0020-0056 | E4 | MSG00299 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00299 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (8 ACT:SSP0020_Delegate.Validation_Check:) |
| WK-SSP0020-0057 | E4 | MSG00300 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00300 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (12 ACT:SSP0020_Delegate.BtnUnSet_Click:5) |
| WK-SSP0020-0058 | E4 | MSG00301 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00301 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (17 ACT:SSP0020_Delegate.UserName_Search:) |
| WK-SSP0020-0059 | E4 | MSG00302 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00302 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (16 ACT:SSP0020_Delegate.UserName_Search:) |
| WK-SSP0020-0060 | E4 | MSG00305 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00305 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0020_Delegate.Validation_Check:37) |
| WK-SSP0020-0061 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (9 13) |
| WK-SSP0020-0062 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 3 (ACT:SSP0020_Delegate.Validation_Check:42) |
| WK-SSP0020-0063 | E4 | txtDelegatee / Delegatee | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtDelegatee / Delegatee · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 1 (ACT:SSP0020_Delegate.Validation_Check:37) |
| WK-SSP0020-0064 | A10 | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 59 (ACT:SSP0020_Delegate.DefineProperty ACT:) |
| WK-SSP0020-0065 | A6 | PKG_SSP0020.P_GET_DELEGATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_GET_DELEGATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 1 (1) |
| WK-SSP0020-0066 | A6 | PKG_SSP0020.P_SAVE_DELEGATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_SAVE_DELEGATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (2) |
| WK-SSP0020-0067 | A6 | PKG_SSP0020.P_SAVE_UNSET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_SAVE_UNSET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (3) |
| WK-SSP0020-0068 | A6 | PKG_SSP0020.P_USER_CHECK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0020.P_USER_CHECK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (5) |
| WK-SSP0020-0069 | A6 | SSP0020_GET_DELEGATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0020_GET_DELEGATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 43 (1 ACT:SSP0020_Delegate.FindButton ACT:SS) |
| WK-SSP0020-0070 | A6 | SSP0020_SAVE_DELEGATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0020_SAVE_DELEGATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 1 (2) |
| WK-SSP0020-0071 | A6 | SSP0020_SAVE_UNSET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0020_SAVE_UNSET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 2 (3 4) |
| WK-SSP0020-0072 | G1 | txtDelegatee / Delegatee | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDelegatee / Delegatee · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 0 () |
| WK-SSP0020-0073 | G6 | chkAll / All | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkAll / All · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0074 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0075 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0076 | G6 | txtDelegatee / Delegatee | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtDelegatee / Delegatee · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0077 | X-REOPEN | SSP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0020 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SSP0020_Delegate.Dispose ACT:SSP0020) |
| WK-SSP0020-0078 | H6 | txtDelegatee / Delegatee | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtDelegatee / Delegatee · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 7 (ACT:SSP0020_Delegate.UserPopup ACT:SSP00) |
| WK-SSP0020-0079 | M4 | txtDelegatee / Delegatee | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtDelegatee / Delegatee · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 7 (ACT:SSP0020_Delegate.UserPopup ACT:SSP00) |

## W7 기대값 확정 (79)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0020-0080 | C3 | SSP0020_Delegate.chkAll_CheckStateChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0020_Delegate.chkAll_CheckStateChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0020_Delegate.chkAll_CheckStateCh) |
| WK-SSP0020-0081 | DB-SYN | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — FindButton: 행 집계 — DB-SYN 7요소: PASS:4 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SSP0020-0082 | DB-SYN | SSP0020_Delegate.UserName_Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SSP0020_Delegate.UserName_Search: 진입점 집계 — DB-SYN 7요소: PASS:4 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0020_Delegate.UserName_Search:781) |
| WK-SSP0020-0083 | F4 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SSP0020-0084 | F4 | SSP0020_Delegate.UserName_Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0020_Delegate.UserName_Search: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0020_Delegate.UserName_Search:781) |
| WK-SSP0020-0085 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0020-0086 | A5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 6: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0020-0087 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0020-0088 | A5 | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DeleteButton: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (DeleteButton) |
| WK-SSP0020-0089 | A5 | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — InsertButton: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton) |
| WK-SSP0020-0090 | A5 | SSP0020_Delegate.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0020_Delegate.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0020_Delegate.CreateSpread:181:1 ) |
| WK-SSP0020-0091 | A5 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SaveButton: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SSP0020-0092 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0020-0093 | H2 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 16: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SSP0020-0094 | H2 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 17: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-SSP0020-0095 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0020-0096 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0020-0097 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0020-0098 | H2 | SSP0020_Delegate.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0020_Delegate.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0020_Delegate.CreateSpread:181:1 ) |
| WK-SSP0020-0099 | H5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 6: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SSP0020-0100 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0020-0101 | H5 | SSP0020_Delegate.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0020_Delegate.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0020_Delegate.CreateSpread:181:1 ) |
| WK-SSP0020-0102 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지한 채 추가행 노출  그리드 신규행 Insert 없는 화면 — 전 칼럼 LockColumn 읽기전용, toolbar Insert n |  | 1 (COMMON:UC-01) |
| WK-SSP0020-0103 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 조회 시 'MSG00703' confirm  그리드 인라인 편집 없음(전 칼럼 읽기전용) → dirty '수정 중' 상태 자체가 없음 해당없음 |  | 1 (COMMON:UC-02) |
| WK-SSP0020-0104 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 Code 아닌 Name 출력  그리드 셀 콤보 0건(FPComboBox 0) + 사용자 컬럼은 SP 가 '이름(id)' 표시조립(Cod |  | 1 (COMMON:UC-05) |
| WK-SSP0020-0105 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 다중입력 전건 조회  key-in 조회조건 없는 화면 — GET=p_user_id/p_language 만, 입력영역(Division/Period/De |  | 1 (COMMON:UC-06) |
| WK-SSP0020-0106 | D1 | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (EditButton) |
| WK-SSP0020-0107 | D3 | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (EditButton) |
| WK-SSP0020-0108 | D5 | SSP0020_Delegate.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0020_Delegate.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0020_Delegate.CreateSpread:181:1 ) |
| WK-SSP0020-0109 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0020-0110 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SSP0020-0111 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 7요소: REVIEW:7 |  | 0 () |
| WK-SSP0020-0112 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (16) |
| WK-SSP0020-0113 | A1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 17: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (17) |
| WK-SSP0020-0114 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 7요소: REVIEW:7 |  | 0 () |
| WK-SSP0020-0115 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (COMMON:UC-07) |
| WK-SSP0020-0116 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 7요소: REVIEW:7 |  | 1 (FindButton) |
| WK-SSP0020-0117 | A1 | PKG_SSP0020.P_GET_DELEGATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_GET_DELEGATE: 골든 비교 케이스 없음(PKG_SSP0020.P_GET_DELEGATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (1) |
| WK-SSP0020-0118 | A1 | PKG_SSP0020.P_SAVE_DELEGATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_SAVE_DELEGATE: 골든 비교 케이스 없음(PKG_SSP0020.P_SAVE_DELEGATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (2) |
| WK-SSP0020-0119 | A1 | PKG_SSP0020.P_SAVE_UNSET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_SAVE_UNSET: 골든 비교 케이스 없음(PKG_SSP0020.P_SAVE_UNSET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (3) |
| WK-SSP0020-0120 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (5) |
| WK-SSP0020-0121 | A1 | SSP0020_GET_DELEGATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0020_GET_DELEGATE: 골든 비교 케이스 없음(SSP0020_GET_DELEGATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 43 (1 ACT:SSP0020_Delegate.FindButton ACT:SS) |
| WK-SSP0020-0122 | A1 | SSP0020_SAVE_DELEGATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0020_SAVE_DELEGATE: 골든 비교 케이스 없음(SSP0020_SAVE_DELEGATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (2) |
| WK-SSP0020-0123 | A1 | SSP0020_SAVE_UNSET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0020_SAVE_UNSET: 골든 비교 케이스 없음(SSP0020_SAVE_UNSET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 2 (3 4) |
| WK-SSP0020-0124 | A6 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton: 행 집계 — A6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SSP0020-0125 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0020-0126 | G1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 16: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SSP0020-0127 | G1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 17: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-SSP0020-0128 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0020-0129 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0020-0130 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SSP0020-0131 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SSP0020-0132 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SSP0020-0133 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SSP0020-0134 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SSP0020-0135 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SSP0020-0136 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SSP0020-0137 | X-ROW | SSP0020_Delegate.BtnSave_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.BtnSave_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.BtnSave_Click:359:8) |
| WK-SSP0020-0138 | X-ROW | SSP0020_Delegate.BtnUnSet_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.BtnUnSet_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.BtnUnSet_Click:571:) |
| WK-SSP0020-0139 | X-ROW | SSP0020_Delegate.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.CreateSpread) |
| WK-SSP0020-0140 | X-ROW | SSP0020_Delegate.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0020_Delegate.DefineProperty ACT:) |
| WK-SSP0020-0141 | X-ROW | SSP0020_Delegate.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0020_Delegate.FindButton) |
| WK-SSP0020-0142 | X-ROW | SSP0020_Delegate.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.FindData_Main: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:1 · NOPATH:1 |  | 13 (ACT:SSP0020_Delegate.FindData_Main ACT:S) |
| WK-SSP0020-0143 | X-ROW | SSP0020_Delegate.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.Form_Load) |
| WK-SSP0020-0144 | X-ROW | SSP0020_Delegate.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.InitControls: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0020_Delegate.InitControls:141:6 ) |
| WK-SSP0020-0145 | X-ROW | SSP0020_Delegate.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.InitEvent: 진입점 집계 5검사 — NOPATH:4 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.InitEvent) |
| WK-SSP0020-0146 | X-ROW | SSP0020_Delegate.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.InitSpread: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0020_Delegate.InitSpread ACT:SSP0) |
| WK-SSP0020-0147 | X-ROW | SSP0020_Delegate.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.SaveData: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0020_Delegate.SaveData:482:9 ACT:) |
| WK-SSP0020-0148 | X-ROW | SSP0020_Delegate.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0020_Delegate.SpdMain_CellClick A) |
| WK-SSP0020-0149 | X-ROW | SSP0020_Delegate.SpdMain_SheetTabClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.SpdMain_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 6 (ACT:SSP0020_Delegate.SpdMain_SheetTabCli) |
| WK-SSP0020-0150 | X-ROW | SSP0020_Delegate.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.SpdMain_TopChange) |
| WK-SSP0020-0151 | X-ROW | SSP0020_Delegate.UnSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.UnSet: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 110 (ACT:SSP0020_Delegate.UnSet ACT:SSP0020_D) |
| WK-SSP0020-0152 | X-ROW | SSP0020_Delegate.UserName_Search | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.UserName_Search: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0020_Delegate.UserName_Search ACT) |
| WK-SSP0020-0153 | X-ROW | SSP0020_Delegate.UserPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.UserPopup: 진입점 집계 7검사 — REVIEW:3 · NOT_RUN:3 · NOPATH:1 |  | 9 (ACT:SSP0020_Delegate.UserPopup:823:2 ACT) |
| WK-SSP0020-0154 | X-ROW | SSP0020_Delegate.Validation_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.Validation_Check: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 60 (ACT:SSP0020_Delegate.Validation_Check AC) |
| WK-SSP0020-0155 | X-ROW | SSP0020_Delegate.chkAll_CheckStateChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0020_Delegate.chkAll_CheckStateChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0020_Delegate.chkAll_CheckStateCh) |
| WK-SSP0020-0156 | G5 | SSP0020_Delegate.UserPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SSP0020_Delegate.UserPopup: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0020_Delegate.UserPopup:821:1 ACT) |
| WK-SSP0020-0157 | H6 | SSP0020_Delegate.UserPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SSP0020_Delegate.UserPopup: 진입점 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0020_Delegate.UserPopup:821:1 ACT) |
| WK-SSP0020-0158 | M4 | SSP0020_Delegate.UserPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0020_Delegate.UserPopup: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0020_Delegate.UserPopup:821:1 ACT) |
