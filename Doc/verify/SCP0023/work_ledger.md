# 작업 원장 — SCP0023 · 2026-10-26 12:53

> 검사 인스턴스 202건 중 PASS·NA 83건 외 **119건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 17 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 8 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 40 | 실행 → PASS |
| W7 | 기대값 확정 | 52 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 51 · E2E 40 · 대조표 18 · 하네스 9 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 18 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 17 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 13 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 4 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 8 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G4 | DESIGN |  |  |  |  | 1 | 4 | 3 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 4 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B4 | COMBO |  |  |  |  | 1 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 2 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 1 |  |  | 1 |  |  | 콤보 후보 정렬 = AS-IS |
| G5 | POPUP |  |  |  |  | 2 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 |  |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 2 |  |  |  | 팝업 선택값 반영 |
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
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W2 구현 위치 확인 (17)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0001 | X-LOC | (AS-IS 없음) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((AS-IS 없음)) |
| WK-SCP0023-0002 | X-LOC | CboDivision_SelectedIndexChanged → Plant | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0003 | X-LOC | CheckDigitValueEntered (Daily<1→1, MSG00 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CheckDigitValueEntered (Daily<1→1, MSG00) |
| WK-SCP0023-0004 | X-LOC | InsertButton/DeleteButton = NO-OP (빈 본문) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton/DeleteButton = NO-OP (빈 본문)) |
| WK-SCP0023-0005 | X-LOC | LockColumn(0,nick_name)+(created_by,last | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(0,nick_name)+(created_by,last) |
| WK-SCP0023-0006 | X-LOC | LockColumn(1,max) 조회후 전체 lock (뷰) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(1,max) 조회후 전체 lock (뷰)) |
| WK-SCP0023-0007 | X-LOC | SaveButton 확인(MSG00012)→성공(MSG00020)→재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0008 | X-LOC | SaveData (action I/M/D, daily_capa_qty·v | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveData (action I/M/D, daily_capa_qty·v) |
| WK-SCP0023-0009 | X-LOC | SwitchLock EditButton (편집 진입) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SwitchLock EditButton (편집 진입)) |
| WK-SCP0023-0010 | X-LOC | cboDivision (BLUtils.GetDivisionWithoutE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0011 | X-LOC | checkRequiredOfSearch (Division 필수) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0012 | X-LOC | checkValidN (Plant Total 필수, MSG00258) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkValidN (Plant Total 필수, MSG00258)) |
| WK-SCP0023-0013 | X-LOC | clbPlantSite (PlantSiteByDivisionOSP, OS | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite (PlantSiteByDivisionOSP, OS) |
| WK-SCP0023-0014 | X-LOC | item_id '-'→'Total' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (item_id '-'→'Total') |
| WK-SCP0023-0015 | X-LOC | spdMain 13열 (SetSheetHeaderColumn + Spre | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain 13열 (SetSheetHeaderColumn + Spre) |
| WK-SCP0023-0016 | X-LOC | txtItemId + btnItemId (SCM0002 팝업) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0017 | X-LOC | txtNickName (LIKE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtNickName (LIKE)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0018 | H10 | SCP0023 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0023 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useOutsourcingCapacityValidation.ts |  | 9 (checkRequiredOfSearch (Division 필수) Chec) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0019 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (cboDivision (BLUtils.GetDivisionWithoutE) |

## W5 검사기 연결 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0020 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0021 | F2 | SCP0023 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0023 화면 | 판단불가(대상 단위 SCREEN) | 49 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0022 | F6 | SCP0023 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0023 화면 | 판단불가(대상 단위 SCREEN) | 48 (SaveData (action I/M/D, daily_capa_qty·v) |
| WK-SCP0023-0023 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (txtItemId + btnItemId (SCM0002 팝업) ACT:S) |
| WK-SCP0023-0024 | G03-WIRE | SCP0023 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0023 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:SCP0023_OutsourcingCapacity..ctor AC) |
| WK-SCP0023-0025 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0026 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0027 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (txtItemId + btnItemId (SCM0002 팝업)) |

## W6 검증 실행 (40)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0028 | J2 | SCP0023 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0023 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 27 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0029 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0023_OutsourcingCapacity.InitCont) |
| WK-SCP0023-0030 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0023_OutsourcingCapacity.SetChang) |
| WK-SCP0023-0031 | G3 | SCP0023 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0023 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0023-0032 | K-SA | SCP0023 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0023 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (COMMON:UC-02) |
| WK-SCP0023-0033 | K4 | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0023-0034 | F1 | SCP0023 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0023 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 51 (SaveData (action I/M/D, daily_capa_qty·v) |
| WK-SCP0023-0035 | F3 | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (CheckDigitValueEntered (Daily<1→1, MSG00) |
| WK-SCP0023-0036 | F5 | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (InsertButton/DeleteButton = NO-OP (빈 본문)) |
| WK-SCP0023-0037 | F4 | PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 86 (ACT:SCP0023_OutsourcingCapacity.FindButt) |
| WK-SCP0023-0038 | F4 | PKG_SCP0023.P_SCP0023_SAVE_OUTSOURCING_C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0023.P_SCP0023_SAVE_OUTSOURCING_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 47 (ACT:SCP0023_OutsourcingCapacity.SaveButt) |
| WK-SCP0023-0039 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0040 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbPlantSite (PlantSiteByDivisionOSP, OS) |
| WK-SCP0023-0041 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0042 | G4 | txtNickName / Nick Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtNickName / Nick Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtNickName (LIKE)) |
| WK-SCP0023-0043 | I1 | SCP0023 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0023 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 10 (checkRequiredOfSearch (Division 필수) Chec) |
| WK-SCP0023-0044 | SC1 | SCP0023 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0023 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0045 | D6 | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (InsertButton/DeleteButton = NO-OP (빈 본문)) |
| WK-SCP0023-0046 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0047 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0048 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (CheckDigitValueEntered (Daily<1→1, MSG00) |
| WK-SCP0023-0049 | E4 | MSG00258 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00258 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (checkValidN (Plant Total 필수, MSG00258) C) |
| WK-SCP0023-0050 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0051 | E4 | MSG00617 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00617 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0052 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0023_OutsourcingCapacity.SetChang) |
| WK-SCP0023-0053 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0023_OutsourcingCapacity.SetChang) |
| WK-SCP0023-0054 | A10 | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 26 (ACT:SCP0023_OutsourcingCapacity.DefinePr) |
| WK-SCP0023-0055 | A6 | PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CAPA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 41 (ACT:SCP0023_OutsourcingCapacity.FindButt) |
| WK-SCP0023-0056 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0057 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbPlantSite (PlantSiteByDivisionOSP, OS) |
| WK-SCP0023-0058 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtItemId + btnItemId (SCM0002 팝업) ACT:S) |
| WK-SCP0023-0059 | G1 | txtNickName / Nick Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtNickName (LIKE) ACT:SCP0023_Outsourci) |
| WK-SCP0023-0060 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0061 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbPlantSite (PlantSiteByDivisionOSP, OS) |
| WK-SCP0023-0062 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0063 | G6 | txtNickName / Nick Name | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtNickName / Nick Name · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtNickName (LIKE)) |
| WK-SCP0023-0064 | X-REOPEN | SCP0023 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0023 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0023_OutsourcingCapacity.Dispose ) |
| WK-SCP0023-0065 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0066 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0067 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |

## W7 기대값 확정 (52)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0023-0068 | C1 | CboDivision_SelectedIndexChanged → Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CboDivision_SelectedIndexChanged → PlantSite 재조회: 행 집계 — C1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0069 | B3 | SCP0023_OutsourcingCapacity.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0023_OutsourcingCapacity.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0023_OutsourcingCapacity.GetSpdTi) |
| WK-SCP0023-0070 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0023-0071 | B4 | SCP0023_OutsourcingCapacity.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0023_OutsourcingCapacity.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0023_OutsourcingCapacity.GetSpdTi) |
| WK-SCP0023-0072 | F4 | SaveData (action I/M/D, daily_capa_qty·v | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveData (action I/M/D, daily_capa_qty·valid_yn): 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveData (action I/M/D, daily_capa_qty·v) |
| WK-SCP0023-0073 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 5요소: NOT_RUN:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0023-0074 | G4 | CboDivision_SelectedIndexChanged → Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — CboDivision_SelectedIndexChanged → PlantSite 재조회: 행 집계 — G4 5요소: NOT_RUN:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0075 | G4 | checkRequiredOfSearch (Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — checkRequiredOfSearch (Division 필수): 행 집계 — G4 5요소: NOT_RUN:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0076 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter) 해당없음 — 이 화면은 Insert 미노출 |  | 1 (COMMON:UC-01) |
| WK-SCP0023-0077 | E4 | SCP0023_OutsourcingCapacity.SetChangedCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0023_OutsourcingCapacity.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0023-0078 | E4 | SaveData (action I/M/D, daily_capa_qty·v | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveData (action I/M/D, daily_capa_qty·valid_yn): 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SaveData (action I/M/D, daily_capa_qty·v) |
| WK-SCP0023-0079 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-02) |
| WK-SCP0023-0080 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0023-0081 | A1 | CboDivision_SelectedIndexChanged → Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboDivision_SelectedIndexChanged → PlantSite 재조회: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0082 | A1 | LockColumn(1,max) 조회후 전체 lock (뷰) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LockColumn(1,max) 조회후 전체 lock (뷰): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (LockColumn(1,max) 조회후 전체 lock (뷰)) |
| WK-SCP0023-0083 | A1 | PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CAPA: 골든 비교 케이스 없음(PKG_SCP0023.P_SCP0023_GET_OUTSOURCING_CAPA — 팝업·보조 SP 는 golde |  | 41 (ACT:SCP0023_OutsourcingCapacity.FindButt) |
| WK-SCP0023-0084 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0023-0085 | A1 | P_SCP0023_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0023_GET: 골든 비교 케이스 없음(P_SCP0023_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0023-0086 | A1 | SaveButton 확인(MSG00012)→성공(MSG00020)→재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveButton 확인(MSG00012)→성공(MSG00020)→재조회: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0087 | A1 | cboDivision (BLUtils.GetDivisionWithoutE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (BLUtils.GetDivisionWithoutEE, ATTRIBU: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (cboDivision (BLUtils.GetDivisionWithoutE) |
| WK-SCP0023-0088 | A1 | checkRequiredOfSearch (Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch (Division 필수): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0089 | A1 | clbPlantSite (PlantSiteByDivisionOSP, OS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (PlantSiteByDivisionOSP, OSP_YN='Y'): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (clbPlantSite (PlantSiteByDivisionOSP, OS) |
| WK-SCP0023-0090 | A1 | txtItemId + btnItemId (SCM0002 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId (SCM0002 팝업): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (txtItemId + btnItemId (SCM0002 팝업)) |
| WK-SCP0023-0091 | A1 | txtNickName (LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtNickName (LIKE): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (txtNickName (LIKE)) |
| WK-SCP0023-0092 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0023-0093 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0023-0094 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0023-0095 | G1 | CboDivision_SelectedIndexChanged → Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CboDivision_SelectedIndexChanged → PlantSite 재조회: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0096 | G1 | LockColumn(1,max) 조회후 전체 lock (뷰) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LockColumn(1,max) 조회후 전체 lock (뷰): 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(1,max) 조회후 전체 lock (뷰)) |
| WK-SCP0023-0097 | G1 | SaveButton 확인(MSG00012)→성공(MSG00020)→재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SaveButton 확인(MSG00012)→성공(MSG00020)→재조회: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton 확인(MSG00012)→성공(MSG00020)→재조회) |
| WK-SCP0023-0098 | G1 | checkRequiredOfSearch (Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — checkRequiredOfSearch (Division 필수): 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0099 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0023-0100 | G6 | CboDivision_SelectedIndexChanged → Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — CboDivision_SelectedIndexChanged → PlantSite 재조회: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → Plant) |
| WK-SCP0023-0101 | G6 | checkRequiredOfSearch (Division 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — checkRequiredOfSearch (Division 필수): 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (checkRequiredOfSearch (Division 필수)) |
| WK-SCP0023-0102 | X-ROW | SCP0023_OutsourcingCapacity.BtnItemId_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.BtnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0023_OutsourcingCapacity.BtnItemI) |
| WK-SCP0023-0103 | X-ROW | SCP0023_OutsourcingCapacity.CboDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.CboDivision_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.CboDivis) |
| WK-SCP0023-0104 | X-ROW | SCP0023_OutsourcingCapacity.CheckDigitVa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.CheckDigitValueEntered: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0023_OutsourcingCapacity.CheckDig) |
| WK-SCP0023-0105 | X-ROW | SCP0023_OutsourcingCapacity.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.CreateSp) |
| WK-SCP0023-0106 | X-ROW | SCP0023_OutsourcingCapacity.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0023_OutsourcingCapacity.DefinePr) |
| WK-SCP0023-0107 | X-ROW | SCP0023_OutsourcingCapacity.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.EditButt) |
| WK-SCP0023-0108 | X-ROW | SCP0023_OutsourcingCapacity.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0023_OutsourcingCapacity.FindButt) |
| WK-SCP0023-0109 | X-ROW | SCP0023_OutsourcingCapacity.FindData_Mai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.FindData_Main: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0023_OutsourcingCapacity.FindData) |
| WK-SCP0023-0110 | X-ROW | SCP0023_OutsourcingCapacity.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.Form_Loa) |
| WK-SCP0023-0111 | X-ROW | SCP0023_OutsourcingCapacity.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.GetSpdTitle: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.GetSpdTi) |
| WK-SCP0023-0112 | X-ROW | SCP0023_OutsourcingCapacity.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0023_OutsourcingCapacity.InitCont) |
| WK-SCP0023-0113 | X-ROW | SCP0023_OutsourcingCapacity.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.InitSpre) |
| WK-SCP0023-0114 | X-ROW | SCP0023_OutsourcingCapacity.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.InitSpread_2: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0023_OutsourcingCapacity.InitSpre) |
| WK-SCP0023-0115 | X-ROW | SCP0023_OutsourcingCapacity.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.SaveData: 진입점 집계 10검사 — NOT_RUN:6 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0023_OutsourcingCapacity.SaveData) |
| WK-SCP0023-0116 | X-ROW | SCP0023_OutsourcingCapacity.SetChangedCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0023_OutsourcingCapacity.SetChang) |
| WK-SCP0023-0117 | X-ROW | SCP0023_OutsourcingCapacity.SpdMain_Chan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.SpdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0023_OutsourcingCapacity.SpdMain_) |
| WK-SCP0023-0118 | X-ROW | SCP0023_OutsourcingCapacity.SpdMain_Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0023_OutsourcingCapacity.SpdMain_) |
| WK-SCP0023-0119 | X-ROW | SCP0023_OutsourcingCapacity.checkValidN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0023_OutsourcingCapacity.checkValidN: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 28 (ACT:SCP0023_OutsourcingCapacity.checkVal) |
