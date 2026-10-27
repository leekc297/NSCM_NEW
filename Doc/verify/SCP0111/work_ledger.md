# 작업 원장 — SCP0111 · 2026-10-26 12:55

> 검사 인스턴스 217건 중 PASS·NA 73건 외 **144건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 14 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 50 | 실행 → PASS |
| W7 | 기대값 확정 | 78 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 78 · E2E 50 · 하네스 16
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 7건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 36 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 13 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  | 10 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G1 | GEN |  |  |  |  |  | 6 | 3 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| DB-SYN | DB |  |  |  |  | 7 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| B3 | COMBO |  |  |  | 2 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 2 | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| A1 | GEN |  |  |  |  |  |  | 5 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0001 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange A) |
| WK-SCP0111-0002 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange A) |

## W5 검사기 연결 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0003 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange A) |
| WK-SCP0111-0004 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange A) |
| WK-SCP0111-0005 | F2 | SCP0111 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0111 화면 | 판단불가(대상 단위 SCREEN) | 377 (일반 저장 ADMIN 저장 SaveButton InsertButton 필) |
| WK-SCP0111-0006 | F6 | SCP0111 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0111 화면 | 판단불가(대상 단위 SCREEN) | 368 (일반 저장 ADMIN 저장 ACT:SCP0111_IntegrationPS) |
| WK-SCP0111-0007 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0008 | DB-SYN | P_SCP0111_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_GET | 없음(PROC_M 대응 없음) | 1 (메인 조회) |
| WK-SCP0111-0009 | DB-SYN | P_SCP0111_GET_ESS_PACK_LINE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_GET_ESS_PACK_LINE | 없음(PROC_M 대응 없음) | 1 (ESS Pack Line) |
| WK-SCP0111-0010 | DB-SYN | P_SCP0111_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE | 없음(PROC_M 대응 없음) | 1 (일반 저장) |
| WK-SCP0111-0011 | DB-SYN | P_SCP0111_SAVE_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE_ADMIN | 없음(PROC_M 대응 없음) | 1 (ADMIN 저장) |
| WK-SCP0111-0012 | DB-SYN | SCP0111_GET_ESS_PACK_LINE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0111_GET_ESS_PACK_LINE | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0013 | DB-SYN | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0111_IntegrationPSI.SaveData:1379) |
| WK-SCP0111-0014 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |
| WK-SCP0111-0015 | G4 | btnNickName | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNickName | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |
| WK-SCP0111-0016 | G03-WIRE | SCP0111 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0111 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SCP0111_IntegrationPSI..ctor ACT:SCP) |

## W6 검증 실행 (50)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0017 | J2 | SCP0111 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0111 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 43 (메인 조회 일반 저장 ADMIN 저장 FindButton SaveButt) |
| WK-SCP0111-0018 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0111_IntegrationPSI.InitControls:) |
| WK-SCP0111-0019 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0111_IntegrationPSI.RefreshPlanDa) |
| WK-SCP0111-0020 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0111_IntegrationPSI.RefreshPlanTy) |
| WK-SCP0111-0021 | K4 | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 27 (ACT:SCP0111_IntegrationPSI.BtnCellItem_I) |
| WK-SCP0111-0022 | F1 | SCP0111 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0111 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 378 (일반 저장 ADMIN 저장 SaveButton InsertButton D) |
| WK-SCP0111-0023 | F5 | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton) |
| WK-SCP0111-0024 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0025 | F4 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 422 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0026 | F4 | PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 366 (일반 저장 ACT:SCP0111_IntegrationPSI.SaveBut) |
| WK-SCP0111-0027 | F4 | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 1 (ADMIN 저장) |
| WK-SCP0111-0028 | F4 | P_SCP0111_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0111_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (메인 조회) |
| WK-SCP0111-0029 | F4 | P_SCP0111_GET_ESS_PACK_LINE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0111_GET_ESS_PACK_LINE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (ESS Pack Line) |
| WK-SCP0111-0030 | F4 | P_SCP0111_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0111_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (일반 저장) |
| WK-SCP0111-0031 | F4 | P_SCP0111_SAVE_ADMIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0111_SAVE_ADMIN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (ADMIN 저장) |
| WK-SCP0111-0032 | F4 | SCP0111_GET_ESS_PACK_LINE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0111_GET_ESS_PACK_LINE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0033 | F4 | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0111_SAVE_INTEGRATION_PSI_ADMIN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 365 (ACT:SCP0111_IntegrationPSI.SaveButton AC) |
| WK-SCP0111-0034 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0035 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0036 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0037 | H4 | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0038 | I1 | SCP0111 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0111 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 24 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0039 | D6 | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (InsertButton 대상 행 미선택 ACT:SCP0111_Integr) |
| WK-SCP0111-0040 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (필수값 공백(15건) OPERATION_GROUP NAME→CODE lo) |
| WK-SCP0111-0041 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (저장 성공) |
| WK-SCP0111-0042 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (저장 실패) |
| WK-SCP0111-0043 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (저장 대상 변경 없음 ACT:SCP0111_IntegrationPSI.S) |
| WK-SCP0111-0044 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (필수값 공백(15건) OPERATION_GROUP NAME→CODE lo) |
| WK-SCP0111-0045 | E4 | MSG00014 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00014 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (대상 행 미선택) |
| WK-SCP0111-0046 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0047 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (신규행 중복(INSERT_KEY_COLS) ACT:SCP0111_Inte) |
| WK-SCP0111-0048 | E4 | MSG00344 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00344 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (조회기간 from>to 금지 ACT:SCP0111_IntegrationP) |
| WK-SCP0111-0049 | E4 | MSG00453 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00453 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (Line 미지정("-") 저장 확인 ACT:SCP0111_Integrat) |
| WK-SCP0111-0050 | E4 | MSG01434 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01434 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0051 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 6 (ACT:SCP0111_IntegrationPSI.SetChangedCon) |
| WK-SCP0111-0052 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0053 | A10 | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 52 (ACT:SCP0111_IntegrationPSI.DefinePropert) |
| WK-SCP0111-0054 | A6 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 58 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0055 | A6 | P_SCP0111_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0111_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (메인 조회) |
| WK-SCP0111-0056 | A6 | P_SCP0111_GET_ESS_PACK_LINE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0111_GET_ESS_PACK_LINE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (ESS Pack Line) |
| WK-SCP0111-0057 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0058 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0059 | G1 | chkQty / Qty < 0 / Qty / Qty ＜ 0 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkQty / Qty < 0 / Qty / Qty ＜ 0 · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0060 | G1 | txtCellItemId / Cell Model / Cell Item I | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtCellItemId / Cell Model / Cell Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0061 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0062 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0063 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0064 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0065 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0066 | X-REOPEN | SCP0111 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0111 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SCP0111_IntegrationPSI.Dispose ACT:S) |

## W7 기대값 확정 (78)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0067 | B3 | OPERATION_GROUP NAME→CODE lookup 부재 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — OPERATION_GROUP NAME→CODE lookup 부재: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (OPERATION_GROUP NAME→CODE lookup 부재) |
| WK-SCP0111-0068 | B3 | SCP0111_IntegrationPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0111_IntegrationPSI.GetBucketType: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0069 | B3 | SCP0111_IntegrationPSI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0111_IntegrationPSI.GetDayRange: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange:1) |
| WK-SCP0111-0070 | B3 | SCP0111_IntegrationPSI.GetEssPackLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0071 | B4 | OPERATION_GROUP NAME→CODE lookup 부재 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — OPERATION_GROUP NAME→CODE lookup 부재: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (OPERATION_GROUP NAME→CODE lookup 부재) |
| WK-SCP0111-0072 | B4 | SCP0111_IntegrationPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0111_IntegrationPSI.GetBucketType: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0073 | B4 | SCP0111_IntegrationPSI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0111_IntegrationPSI.GetDayRange: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.GetDayRange:1) |
| WK-SCP0111-0074 | B4 | SCP0111_IntegrationPSI.GetEssPackLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0075 | E4 | ESS 파생검증 D1/D2 불일치 경고 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — ESS 파생검증 D1/D2 불일치 경고: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0076 | E4 | SCP0111_IntegrationPSI.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0111_IntegrationPSI.SetCalendar: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI.SetCalendar:3) |
| WK-SCP0111-0077 | E4 | SCP0111_IntegrationPSI.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0111_IntegrationPSI.SetChangedPeriod: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0078 | E4 | SCP0111_IntegrationPSI.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0111_IntegrationPSI.SetSpreadColumn: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0079 | E4 | SCP0111_IntegrationPSI.SetVisibleSheetCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0111_IntegrationPSI.SetVisibleSheetColumns: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0080 | E4 | SCP0111_IntegrationPSI.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0111_IntegrationPSI.Set_MeasureColor: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0111_IntegrationPSI.Set_MeasureCo) |
| WK-SCP0111-0081 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (FindButton) |
| WK-SCP0111-0082 | A1 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI: 골든 비교 케이스 없음(PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI — 팝업·보조 SP 는 golden_ |  | 58 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0083 | A1 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET: 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (메인 조회) |
| WK-SCP0111-0084 | A1 | P_SCP0111_GET_ESS_PACK_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET_ESS_PACK_LINE: 골든 비교 케이스 없음(P_SCP0111_GET_ESS_PACK_LINE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (ESS Pack Line) |
| WK-SCP0111-0085 | A1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0086 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0111-0087 | G1 | 메인 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 메인 조회: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (메인 조회) |
| WK-SCP0111-0088 | G1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0089 | X-LOC | (공용) Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (공용) Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((공용) Excel) |
| WK-SCP0111-0090 | X-LOC | ADMIN 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN 저장) |
| WK-SCP0111-0091 | X-LOC | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton) |
| WK-SCP0111-0092 | X-LOC | ESS Pack Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS Pack Line: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS Pack Line) |
| WK-SCP0111-0093 | X-LOC | ESS 파생검증 D1/D2 불일치 경고 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS 파생검증 D1/D2 불일치 경고: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0094 | X-LOC | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton) |
| WK-SCP0111-0095 | X-LOC | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton) |
| WK-SCP0111-0096 | X-LOC | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton) |
| WK-SCP0111-0097 | X-LOC | Line 미지정("-") 저장 확인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Line 미지정("-") 저장 확인: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0098 | X-LOC | OPERATION_GROUP NAME→CODE lookup 부재 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OPERATION_GROUP NAME→CODE lookup 부재: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OPERATION_GROUP NAME→CODE lookup 부재) |
| WK-SCP0111-0099 | X-LOC | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton) |
| WK-SCP0111-0100 | X-LOC | 대상 행 미선택 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 대상 행 미선택: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (대상 행 미선택) |
| WK-SCP0111-0101 | X-LOC | 메인 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메인 조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메인 조회) |
| WK-SCP0111-0102 | X-LOC | 신규행 중복(INSERT_KEY_COLS) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 신규행 중복(INSERT_KEY_COLS): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (신규행 중복(INSERT_KEY_COLS)) |
| WK-SCP0111-0103 | X-LOC | 일반 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 일반 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (일반 저장) |
| WK-SCP0111-0104 | X-LOC | 저장 대상 변경 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 대상 변경 없음: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 대상 변경 없음) |
| WK-SCP0111-0105 | X-LOC | 저장 성공 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 성공: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 성공) |
| WK-SCP0111-0106 | X-LOC | 저장 실패 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 실패: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 실패) |
| WK-SCP0111-0107 | X-LOC | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회기간 from>to 금지: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0108 | X-LOC | 필수값 공백(15건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수값 공백(15건): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수값 공백(15건)) |
| WK-SCP0111-0109 | X-ROW | (공용) Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — (공용) Excel: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 ((공용) Excel) |
| WK-SCP0111-0110 | X-ROW | SCP0111_IntegrationPSI.BtnCellItem_Id_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.BtnCellItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI.BtnCellItem_I) |
| WK-SCP0111-0111 | X-ROW | SCP0111_IntegrationPSI.BtnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.BtnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0111_IntegrationPSI.BtnItemId_Cli) |
| WK-SCP0111-0112 | X-ROW | SCP0111_IntegrationPSI.BtnNickName_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.BtnNickName_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0111_IntegrationPSI.BtnNickName_C) |
| WK-SCP0111-0113 | X-ROW | SCP0111_IntegrationPSI.CboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.CboDivision_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0114 | X-ROW | SCP0111_IntegrationPSI.CboPlanDate_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.CboPlanDate_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0115 | X-ROW | SCP0111_IntegrationPSI.CboPlanSeq_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.CboPlanSeq_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanSeq_Se) |
| WK-SCP0111-0116 | X-ROW | SCP0111_IntegrationPSI.CboPlanType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.CboPlanType_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0117 | X-ROW | SCP0111_IntegrationPSI.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CreateSpread) |
| WK-SCP0111-0118 | X-ROW | SCP0111_IntegrationPSI.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.DefinePropert) |
| WK-SCP0111-0119 | X-ROW | SCP0111_IntegrationPSI.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0120 | X-ROW | SCP0111_IntegrationPSI.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0111_IntegrationPSI.FindButton) |
| WK-SCP0111-0121 | X-ROW | SCP0111_IntegrationPSI.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.FindData_Main: 진입점 집계 13검사 — NOT_RUN:11 · REVIEW:1 · PASS:1 |  | 8 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0122 | X-ROW | SCP0111_IntegrationPSI.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.Form_Load) |
| WK-SCP0111-0123 | X-ROW | SCP0111_IntegrationPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0124 | X-ROW | SCP0111_IntegrationPSI.GetEssPackLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0125 | X-ROW | SCP0111_IntegrationPSI.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.InitControls: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.InitControls:) |
| WK-SCP0111-0126 | X-ROW | SCP0111_IntegrationPSI.InitFromToDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.InitFromToDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.InitFromToDat) |
| WK-SCP0111-0127 | X-ROW | SCP0111_IntegrationPSI.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.InitSpread AC) |
| WK-SCP0111-0128 | X-ROW | SCP0111_IntegrationPSI.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.InsertButton) |
| WK-SCP0111-0129 | X-ROW | SCP0111_IntegrationPSI.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/FLAG/GRID_LOCK/GRID_SET/LOCAL, 연결된 요 |  | 60 (ACT:SCP0111_IntegrationPSI.InsertRow ACT) |
| WK-SCP0111-0130 | X-ROW | SCP0111_IntegrationPSI.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.OnShown ACT:S) |
| WK-SCP0111-0131 | X-ROW | SCP0111_IntegrationPSI.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0111_IntegrationPSI.RefreshPlanDa) |
| WK-SCP0111-0132 | X-ROW | SCP0111_IntegrationPSI.RefreshPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.RefreshPlanSeq: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.RefreshPlanSe) |
| WK-SCP0111-0133 | X-ROW | SCP0111_IntegrationPSI.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.RefreshPlanType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0111_IntegrationPSI.RefreshPlanTy) |
| WK-SCP0111-0134 | X-ROW | SCP0111_IntegrationPSI.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SaveData: 진입점 집계 15검사 — NOT_RUN:10 · NOPATH:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0111_IntegrationPSI.SaveData:1105) |
| WK-SCP0111-0135 | X-ROW | SCP0111_IntegrationPSI.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SetCalendar: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetCalendar A) |
| WK-SCP0111-0136 | X-ROW | SCP0111_IntegrationPSI.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SetChangedControl: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.SetChangedCon) |
| WK-SCP0111-0137 | X-ROW | SCP0111_IntegrationPSI.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0138 | X-ROW | SCP0111_IntegrationPSI.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SetSpreadColumn: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0139 | X-ROW | SCP0111_IntegrationPSI.SetVisibleSheetCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SetVisibleSheetColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
| WK-SCP0111-0140 | X-ROW | SCP0111_IntegrationPSI.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.Set_MeasureColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.Set_MeasureCo) |
| WK-SCP0111-0141 | X-ROW | SCP0111_IntegrationPSI.SpdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.SpdMain_CellD) |
| WK-SCP0111-0142 | X-ROW | SCP0111_IntegrationPSI.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0143 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI._defaultDataModel_Changed: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
| WK-SCP0111-0144 | X-ROW | SCP0111_IntegrationPSI.spdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLAG/GRID_SE |  | 34 (ACT:SCP0111_IntegrationPSI.spdMain_CellC) |
