# 작업 원장 — SCP0087 · 2026-10-26 12:54

> 검사 인스턴스 167건 중 PASS·NA 53건 외 **114건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 15 | 구현 위치 실존 |
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 32 | 실행 → PASS |
| W7 | 기대값 확정 | 64 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 62 · E2E 32 · 대조표 17 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 15 |  |  |  |  | 5 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| D1 | EDIT |  |  |  |  |  | 2 | 9 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 2 | 9 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 3 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  |  |  |  |  | 10 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 4 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  | 2 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  |  |  |  | 3 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
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
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (15)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0087-0001 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0087-0002 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0087-0003 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: MdmClassMasterGrid.tsx:71-71 > 49줄 |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0004 | X-LOC | DeleteButton 빈 본문 (삭제 no-op) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton 빈 본문 (삭제 no-op)) |
| WK-SCP0087-0005 | X-LOC | EditButton `RowCount==0` return | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton `RowCount==0` return) |
| WK-SCP0087-0006 | X-LOC | EditButton `fps==null` return | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton `fps==null` return) |
| WK-SCP0087-0007 | X-LOC | Form_Load 자동조회 없음 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Form_Load 자동조회 없음) |
| WK-SCP0087-0008 | X-LOC | InsertButton `return` (삽입 비활성) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton `return` (삽입 비활성)) |
| WK-SCP0087-0009 | X-LOC | SaveButton `fps==null` return | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton `fps==null` return) |
| WK-SCP0087-0010 | X-LOC | SaveData_Main `IsLock==false` 일 때만 저장 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveData_Main `IsLock==false` 일 때만 저장) |
| WK-SCP0087-0011 | X-LOC | SaveData_Main `RowCount==0` return | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveData_Main `RowCount==0` return) |
| WK-SCP0087-0012 | X-LOC | cboUseFlag DataBind(YesOrNo, isAddALL) 기 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboUseFlag DataBind(YesOrNo, isAddALL) 기) |
| WK-SCP0087-0013 | X-LOC | p_use_flag = ALL ? '' : value | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (p_use_flag = ALL ? '' : value) |
| WK-SCP0087-0014 | X-LOC | txtClassId → p_class_id (LIKE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtClassId → p_class_id (LIKE)) |
| WK-SCP0087-0015 | X-LOC | txtClassName → p_class_name (LIKE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtClassName → p_class_name (LIKE)) |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0087-0016 | F2 | SCP0087 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0087 화면 | 판단불가(대상 단위 SCREEN) | 78 (2 3 4 5 SaveButton `fps==null` return Sa) |
| WK-SCP0087-0017 | F6 | SCP0087 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0087 화면 | 판단불가(대상 단위 SCREEN) | 71 (SaveData_Main `RowCount==0` return SaveD) |
| WK-SCP0087-0018 | G03-WIRE | SCP0087 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0087 화면 | 판단불가(대상 단위 SCREEN) | 3 (ACT:SCP0087_MDMClassMaster..ctor ACT:SCP) |

## W6 검증 실행 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0087-0019 | J2 | SCP0087 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0087 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 22 (1 2 3 4 5 EditButton `fps==null` return ) |
| WK-SCP0087-0020 | C1 | cboUseFlag / Use Flag / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboUseFlag / Use Flag / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0087_MDMClassMaster.InitControls:) |
| WK-SCP0087-0021 | G3 | SCP0087 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0087 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0087-0022 | K-SA | SCP0087 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0087 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0023 | K4 | SCP0087 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0087 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 4 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0087-0024 | F1 | SCP0087 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0087 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 79 (2 3 4 5 SaveButton `fps==null` return Sa) |
| WK-SCP0087-0025 | F5 | SCP0087 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0087 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton 빈 본문 (삭제 no-op)) |
| WK-SCP0087-0026 | F4 | PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MAST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 101 (ACT:SCP0087_MDMClassMaster.FindButton AC) |
| WK-SCP0087-0027 | F4 | PKG_SCP0087.P_SCP0087_SAVE_MDM_CLASS_MAS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0087.P_SCP0087_SAVE_MDM_CLASS_MASTER_ROW_DA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 69 (ACT:SCP0087_MDMClassMaster.SaveButton AC) |
| WK-SCP0087-0028 | G4 | cboUseFlag / Use Flag / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboUseFlag / Use Flag / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboUseFlag DataBind(YesOrNo, isAddALL) 기) |
| WK-SCP0087-0029 | G4 | txtClassId / Class ID / Class Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtClassId / Class ID / Class Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtClassId → p_class_id (LIKE)) |
| WK-SCP0087-0030 | G4 | txtClassName / Class Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtClassName / Class Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtClassName → p_class_name (LIKE)) |
| WK-SCP0087-0031 | I1 | SCP0087 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0087 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 11 (1 2 3 4 5 COMMON:UC-04 ACT:SCP0087_MDMCl) |
| WK-SCP0087-0032 | SC1 | SCP0087 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0087 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 5 (txtClassId → p_class_id (LIKE) txtClassN) |
| WK-SCP0087-0033 | D1 | ITEM_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0087_MDMClassMaster.EditButton AC) |
| WK-SCP0087-0034 | D1 | PROCESS_DETAIL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROCESS_DETAIL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0087_MDMClassMaster.EditButton:17) |
| WK-SCP0087-0035 | D3 | ITEM_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0087_MDMClassMaster.EditButton AC) |
| WK-SCP0087-0036 | D3 | PROCESS_DETAIL | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROCESS_DETAIL · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0087_MDMClassMaster.EditButton:17) |
| WK-SCP0087-0037 | D6 | SCP0087 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0087 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 9 (EditButton `fps==null` return EditButton) |
| WK-SCP0087-0038 | E4 | CLASS_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CLASS_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (7 COMMON:UC-04) |
| WK-SCP0087-0039 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (2 COMMON:UC-04) |
| WK-SCP0087-0040 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (3 COMMON:UC-04 ACT:SCP0087_MDMClassMaste) |
| WK-SCP0087-0041 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (2 COMMON:UC-04 ACT:SCP0087_MDMClassMaste) |
| WK-SCP0087-0042 | A10 | SCP0087 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0087 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 15 (ACT:SCP0087_MDMClassMaster.DefinePropert) |
| WK-SCP0087-0043 | A6 | PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MAST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 34 (ACT:SCP0087_MDMClassMaster.FindButton AC) |
| WK-SCP0087-0044 | G1 | cboUseFlag / Use Flag / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboUseFlag / Use Flag / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboUseFlag DataBind(YesOrNo, isAddALL) 기) |
| WK-SCP0087-0045 | G1 | txtClassId / Class ID / Class Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtClassId / Class ID / Class Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtClassId → p_class_id (LIKE) ACT:SCP00) |
| WK-SCP0087-0046 | G1 | txtClassName / Class Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtClassName / Class Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtClassName → p_class_name (LIKE) ACT:S) |
| WK-SCP0087-0047 | G6 | cboUseFlag / Use Flag / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboUseFlag / Use Flag / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboUseFlag DataBind(YesOrNo, isAddALL) 기) |
| WK-SCP0087-0048 | G6 | txtClassId / Class ID / Class Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtClassId / Class ID / Class Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtClassId → p_class_id (LIKE)) |
| WK-SCP0087-0049 | G6 | txtClassName / Class Name | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtClassName / Class Name · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtClassName → p_class_name (LIKE)) |
| WK-SCP0087-0050 | X-REOPEN | SCP0087 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0087 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0087_MDMClassMaster.Dispose ACT:S) |

## W7 기대값 확정 (64)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0087-0051 | F4 | SCP0087_MDMClassMaster.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0087_MDMClassMaster.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0087_MDMClassMaster.SCM_SYS_LOG_B) |
| WK-SCP0087-0052 | F4 | SaveData_Main `IsLock==false` 일 때만 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveData_Main `IsLock==false` 일 때만 저장: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Main `IsLock==false` 일 때만 저장) |
| WK-SCP0087-0053 | F4 | SaveData_Main `RowCount==0` return | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveData_Main `RowCount==0` return: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Main `RowCount==0` return) |
| WK-SCP0087-0054 | G4 | Form_Load 자동조회 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Form_Load 자동조회 없음: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Form_Load 자동조회 없음) |
| WK-SCP0087-0055 | G4 | p_use_flag = ALL ? '' : value | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — p_use_flag = ALL ? '' : value: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (p_use_flag = ALL ? '' : value) |
| WK-SCP0087-0056 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) 해당없음 — 이  |  | 1 (COMMON:UC-01) |
| WK-SCP0087-0057 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 해당없음 — 조회조건 단일 LIKE 부분일치 AS-IS GET SP(design 02 §2.4 asis.py 실측) |  | 1 (COMMON:UC-06) |
| WK-SCP0087-0058 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0059 | D1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0060 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0061 | D1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 6: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0087-0062 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0063 | D1 | EditButton `RowCount==0` return | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton `RowCount==0` return: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton `RowCount==0` return) |
| WK-SCP0087-0064 | D1 | EditButton `fps==null` return | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton `fps==null` return: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton `fps==null` return) |
| WK-SCP0087-0065 | D1 | SCP0087_MDMClassMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0087_MDMClassMaster.EditButton: 진입점 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0087_MDMClassMaster.EditButton:15) |
| WK-SCP0087-0066 | D1 | SaveData_Main `IsLock==false` 일 때만 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SaveData_Main `IsLock==false` 일 때만 저장: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Main `IsLock==false` 일 때만 저장) |
| WK-SCP0087-0067 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0068 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0069 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0070 | D3 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 6: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0087-0071 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0072 | D3 | EditButton `RowCount==0` return | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton `RowCount==0` return: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton `RowCount==0` return) |
| WK-SCP0087-0073 | D3 | EditButton `fps==null` return | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton `fps==null` return: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EditButton `fps==null` return) |
| WK-SCP0087-0074 | D3 | SCP0087_MDMClassMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0087_MDMClassMaster.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0087_MDMClassMaster.EditButton:15) |
| WK-SCP0087-0075 | D3 | SaveData_Main `IsLock==false` 일 때만 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveData_Main `IsLock==false` 일 때만 저장: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveData_Main `IsLock==false` 일 때만 저장) |
| WK-SCP0087-0076 | E4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 1: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0087-0077 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0087-0078 | E4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 4: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0087-0079 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0087-0080 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (1) |
| WK-SCP0087-0081 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (2) |
| WK-SCP0087-0082 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (6) |
| WK-SCP0087-0083 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0084 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0087-0085 | A1 | Form_Load 자동조회 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Form_Load 자동조회 없음: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Form_Load 자동조회 없음) |
| WK-SCP0087-0086 | A1 | PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MAST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MASTER: 골든 비교 케이스 없음(PKG_SCP0087.P_SCP0087_GET_MDM_CLASS_MASTER — 팝업·보조 SP 는 golde |  | 34 (ACT:SCP0087_MDMClassMaster.FindButton AC) |
| WK-SCP0087-0087 | A1 | cboUseFlag DataBind(YesOrNo, isAddALL) 기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboUseFlag DataBind(YesOrNo, isAddALL) 기본 'Y': 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboUseFlag DataBind(YesOrNo, isAddALL) 기) |
| WK-SCP0087-0088 | A1 | p_use_flag = ALL ? '' : value | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — p_use_flag = ALL ? '' : value: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (p_use_flag = ALL ? '' : value) |
| WK-SCP0087-0089 | A1 | txtClassId → p_class_id (LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtClassId → p_class_id (LIKE): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (txtClassId → p_class_id (LIKE)) |
| WK-SCP0087-0090 | A1 | txtClassName → p_class_name (LIKE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtClassName → p_class_name (LIKE): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (txtClassName → p_class_name (LIKE)) |
| WK-SCP0087-0091 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0087-0092 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0087-0093 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0087-0094 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0087-0095 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0087-0096 | G1 | Form_Load 자동조회 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Form_Load 자동조회 없음: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Form_Load 자동조회 없음) |
| WK-SCP0087-0097 | G1 | p_use_flag = ALL ? '' : value | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — p_use_flag = ALL ? '' : value: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (p_use_flag = ALL ? '' : value) |
| WK-SCP0087-0098 | G6 | Form_Load 자동조회 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Form_Load 자동조회 없음: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Form_Load 자동조회 없음) |
| WK-SCP0087-0099 | G6 | p_use_flag = ALL ? '' : value | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — p_use_flag = ALL ? '' : value: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (p_use_flag = ALL ? '' : value) |
| WK-SCP0087-0100 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0087-0101 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0087-0102 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0087-0103 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0087-0104 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0087-0105 | X-ROW | SCP0087_MDMClassMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.CreateSpread) |
| WK-SCP0087-0106 | X-ROW | SCP0087_MDMClassMaster.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.DefinePropert) |
| WK-SCP0087-0107 | X-ROW | SCP0087_MDMClassMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0087_MDMClassMaster.FindButton) |
| WK-SCP0087-0108 | X-ROW | SCP0087_MDMClassMaster.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0087_MDMClassMaster.FindData_Main) |
| WK-SCP0087-0109 | X-ROW | SCP0087_MDMClassMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.Form_Load) |
| WK-SCP0087-0110 | X-ROW | SCP0087_MDMClassMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.InitControls:) |
| WK-SCP0087-0111 | X-ROW | SCP0087_MDMClassMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.InitSpread) |
| WK-SCP0087-0112 | X-ROW | SCP0087_MDMClassMaster.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0087_MDMClassMaster.InsertButton) |
| WK-SCP0087-0113 | X-ROW | SCP0087_MDMClassMaster.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0087_MDMClassMaster.SCM_SYS_LOG_B) |
| WK-SCP0087-0114 | X-ROW | SCP0087_MDMClassMaster.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0087_MDMClassMaster.SaveData_Main: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0087_MDMClassMaster.SaveData_Main) |
