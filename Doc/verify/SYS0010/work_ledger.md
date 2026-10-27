# 작업 원장 — SYS0010 · 2026-10-26 13:00

> 검사 인스턴스 384건 중 PASS·NA 9건 외 **375건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 2 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 24 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 259 | 실행 → PASS |
| W7 | 기대값 확정 | 87 | 기대 확정 → PASS/FAIL |

- 담당: E2E 259 · 사람 판정 / AS-IS 원문 확인 → 재판정 87 · 하네스 27 · 대조표 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | DESIGN |  |  |  |  |  | 42 | 2 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 42 | 2 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 42 | 2 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 42 | 1 |  |  | 셀 에디터 유형 |
| X-ROW | GEN |  |  |  |  |  |  | 30 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 25 | 1 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 23 | 1 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 2 |  |  |  |  | 16 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B4 | COMBO |  |  |  |  | 5 |  | 6 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 3 |  |  | 6 |  |  | 콤보 후보 정렬 = AS-IS |
| DB-SYN | DB |  |  |  |  | 6 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| F4 | DB |  |  |  |  |  | 6 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D1 | EDIT |  |  |  |  |  | 3 | 3 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 3 |  |  | 행 값 기반 조건부 잠금 |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| C2 | CASCADE |  |  |  |  |  | 5 |  |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 5 |  |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G1 | GEN |  |  |  |  |  | 3 | 2 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 4 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | GEN |  |  |  |  |  | 2 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  |  | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| M4 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 선택값 반영 |
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
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0010-0001 | X-LOC | 메뉴 권한 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (메뉴 권한) |
| WK-SYS0010-0002 | X-LOC | 추가 분기 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (추가 분기) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0010-0003 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 판단불가(대상 단위 PCOL) | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0004 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 판단불가(대상 단위 PCOL) | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0005 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |

## W5 검사기 연결 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0010-0006 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL DIVISION_ID | 판단불가(대상 단위 PCOL) | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0007 | B1 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL FACTORY_ID | 판단불가(대상 단위 PCOL) | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0008 | B1 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL LINE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0009 | B1 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL OPERATION_ID | 판단불가(대상 단위 PCOL) | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0010 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL SCM_SITE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0011 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL DIVISION_ID | 판단불가(대상 단위 PCOL) | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0012 | B2 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL FACTORY_ID | 판단불가(대상 단위 PCOL) | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0013 | B2 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL LINE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0014 | B2 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL OPERATION_ID | 판단불가(대상 단위 PCOL) | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0015 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL SCM_SITE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0016 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL DIVISION_ID | 판단불가(대상 단위 PCOL) | 8 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0017 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL FACTORY_ID | 판단불가(대상 단위 PCOL) | 5 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0018 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL LINE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0019 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL OPERATION_ID | 판단불가(대상 단위 PCOL) | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0020 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL SCM_SITE_ID | 판단불가(대상 단위 PCOL) | 1 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0021 | F2 | SYS0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0010 화면 | 판단불가(대상 단위 SCREEN) | 151 (Save `SCM0003_AFTER_LOOKUP_MASTER_DETAIL) |
| WK-SYS0010-0022 | F6 | SYS0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0010 화면 | 판단불가(대상 단위 SCREEN) | 148 (Save ACT:SCM0003_Lookup.SaveButton ACT:S) |
| WK-SYS0010-0023 | DB-SYN | SCM0003_DELETE_LOOKUP_MASTER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_DELETE_LOOKUP_MASTER | 없음(PROC_M 대응 없음) | 2 (ACT:SCM0003_Lookup.SaveData:498:65 ACT:S) |
| WK-SYS0010-0024 | DB-SYN | SCM0003_DELETE_LOOKUP_MASTER_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_DELETE_LOOKUP_MASTER_DETAIL | 없음(PROC_M 대응 없음) | 2 (ACT:SCM0003_Lookup.SaveData:498:65 ACT:S) |
| WK-SYS0010-0025 | DB-SYN | SCM0003_GET_LOOKUP_MASTER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_GET_LOOKUP_MASTER | 없음(PROC_M 대응 없음) | 6 (`SCM0003_GET_LOOKUP_MASTER` (L320) ACT:S) |
| WK-SYS0010-0026 | DB-SYN | SCM0003_GET_LOOKUP_MASTER_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_GET_LOOKUP_MASTER_DETAIL | 없음(PROC_M 대응 없음) | 6 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0027 | DB-SYN | SCM0003_SAVE_LOOKUP_MASTER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_SAVE_LOOKUP_MASTER | 없음(PROC_M 대응 없음) | 2 (ACT:SCM0003_Lookup.SaveData:498:65 ACT:S) |
| WK-SYS0010-0028 | DB-SYN | SCM0003_SAVE_LOOKUP_MASTER_DETAIL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0003_SAVE_LOOKUP_MASTER_DETAIL | 없음(PROC_M 대응 없음) | 2 (ACT:SCM0003_Lookup.SaveData:498:65 ACT:S) |
| WK-SYS0010-0029 | G03-WIRE | SYS0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0010 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCM0003_Lookup..ctor ACT:SCM0003_Loo) |

## W6 검증 실행 (259)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0010-0030 | J2 | SYS0010 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SYS0010 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 19 (Find Insert Delete Edit Save `SCM0003_AF) |
| WK-SYS0010-0031 | C1 | cboLookupGroup / System / Lookup Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboLookupGroup / System / Lookup Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitControls:133:1) |
| WK-SYS0010-0032 | C1 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitControls:134:2) |
| WK-SYS0010-0033 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0034 | C2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 15 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0035 | C2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0036 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0037 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0038 | C3 | ATTRIBUTE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0039 | C3 | ATTRIBUTE10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE10 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0040 | C3 | ATTRIBUTE11 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE11 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0041 | C3 | ATTRIBUTE12 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE12 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0042 | C3 | ATTRIBUTE13 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE13 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0043 | C3 | ATTRIBUTE14 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE14 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0044 | C3 | ATTRIBUTE15 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE15 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0045 | C3 | ATTRIBUTE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0046 | C3 | ATTRIBUTE3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0047 | C3 | ATTRIBUTE4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0048 | C3 | ATTRIBUTE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0049 | C3 | ATTRIBUTE6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE6 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0050 | C3 | ATTRIBUTE7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE7 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0051 | C3 | ATTRIBUTE8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE8 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0052 | C3 | ATTRIBUTE9 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ATTRIBUTE9 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0053 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 20 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0054 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 15 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0055 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0056 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0057 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0058 | C3 | SEGMENT1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEGMENT1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0059 | C3 | SEGMENT2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEGMENT2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0060 | C3 | SEGMENT3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEGMENT3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0061 | C3 | SEGMENT4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEGMENT4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0062 | C3 | SEGMENT5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEGMENT5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0063 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0064 | C6 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 15 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0065 | C6 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0066 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0067 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0068 | K4 | SYS0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SYS0010 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 8 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0069 | F1 | SYS0010 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0010 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 159 (Delete Save `SCM0003_AFTER_LOOKUP_MASTER) |
| WK-SYS0010-0070 | F5 | SYS0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0010 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (Delete ACT:SCM0003_Lookup.DeleteButton A) |
| WK-SYS0010-0071 | F4 | SCM0003_DELETE_LOOKUP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_DELETE_LOOKUP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 142 (ACT:SCM0003_Lookup.SaveButton ACT:SCM000) |
| WK-SYS0010-0072 | F4 | SCM0003_DELETE_LOOKUP_MASTER_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_DELETE_LOOKUP_MASTER_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 142 (ACT:SCM0003_Lookup.SaveButton ACT:SCM000) |
| WK-SYS0010-0073 | F4 | SCM0003_GET_LOOKUP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_GET_LOOKUP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 165 (`SCM0003_GET_LOOKUP_MASTER` (L320) ACT:S) |
| WK-SYS0010-0074 | F4 | SCM0003_GET_LOOKUP_MASTER_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_GET_LOOKUP_MASTER_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 172 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0075 | F4 | SCM0003_SAVE_LOOKUP_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_SAVE_LOOKUP_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 143 (ACT:SCM0003_Lookup.SaveButton ACT:SCM000) |
| WK-SYS0010-0076 | F4 | SCM0003_SAVE_LOOKUP_MASTER_DETAIL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0003_SAVE_LOOKUP_MASTER_DETAIL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 143 (ACT:SCM0003_Lookup.SaveButton ACT:SCM000) |
| WK-SYS0010-0077 | A5 | ATTRIBUTE1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0078 | A5 | ATTRIBUTE10 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE10 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0079 | A5 | ATTRIBUTE11 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE11 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0080 | A5 | ATTRIBUTE12 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE12 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0081 | A5 | ATTRIBUTE13 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE13 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0082 | A5 | ATTRIBUTE14 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE14 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0083 | A5 | ATTRIBUTE15 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE15 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0084 | A5 | ATTRIBUTE2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE2 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0085 | A5 | ATTRIBUTE3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE3 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0086 | A5 | ATTRIBUTE4 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE4 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0087 | A5 | ATTRIBUTE5 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE5 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0088 | A5 | ATTRIBUTE6 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE6 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0089 | A5 | ATTRIBUTE7 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE7 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0090 | A5 | ATTRIBUTE8 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE8 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0091 | A5 | ATTRIBUTE9 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ATTRIBUTE9 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0092 | A5 | CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0093 | A5 | CREATION_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0094 | A5 | DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0095 | A5 | DISPLAY_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DISPLAY_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:229:60) |
| WK-SYS0010-0096 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0097 | A5 | FACTORY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0098 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0099 | A5 | LAST_UPDATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0100 | A5 | LAST_UPDATE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0101 | A5 | LINE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0102 | A5 | LOOKUP_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LOOKUP_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0103 | A5 | LOOKUP_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LOOKUP_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0104 | A5 | LOOKUP_TYPE_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LOOKUP_TYPE_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0105 | A5 | OPERATION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0106 | A5 | PROJECT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0107 | A5 | SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0108 | A5 | SEGMENT1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0109 | A5 | SEGMENT1_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT1_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:237:66) |
| WK-SYS0010-0110 | A5 | SEGMENT2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT2 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0111 | A5 | SEGMENT2_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT2_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:238:67) |
| WK-SYS0010-0112 | A5 | SEGMENT3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT3 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0113 | A5 | SEGMENT3_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT3_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:239:68) |
| WK-SYS0010-0114 | A5 | SEGMENT4 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT4 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0115 | A5 | SEGMENT4_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT4_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:240:69) |
| WK-SYS0010-0116 | A5 | SEGMENT5 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT5 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0117 | A5 | SEGMENT5_KEY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEGMENT5_KEY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0003_Lookup.InitSpread:241:70) |
| WK-SYS0010-0118 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0119 | G4 | cboLookupGroup / System / Lookup Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboLookupGroup / System / Lookup Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0003_Lookup.InitControls ACT:SCM0) |
| WK-SYS0010-0120 | G4 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0003_Lookup.InitControls ACT:SCM0) |
| WK-SYS0010-0121 | H2 | ATTRIBUTE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0122 | H2 | ATTRIBUTE10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE10 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0123 | H2 | ATTRIBUTE11 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE11 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0124 | H2 | ATTRIBUTE12 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE12 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0125 | H2 | ATTRIBUTE13 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE13 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0126 | H2 | ATTRIBUTE14 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE14 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0127 | H2 | ATTRIBUTE15 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE15 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0128 | H2 | ATTRIBUTE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0129 | H2 | ATTRIBUTE3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0130 | H2 | ATTRIBUTE4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0131 | H2 | ATTRIBUTE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0132 | H2 | ATTRIBUTE6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE6 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0133 | H2 | ATTRIBUTE7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE7 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0134 | H2 | ATTRIBUTE8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE8 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0135 | H2 | ATTRIBUTE9 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ATTRIBUTE9 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0136 | H2 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0137 | H2 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0138 | H2 | DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0139 | H2 | DISPLAY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DISPLAY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:229:60) |
| WK-SYS0010-0140 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0141 | H2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0142 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0143 | H2 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0144 | H2 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0145 | H2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0146 | H2 | LOOKUP_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LOOKUP_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0147 | H2 | LOOKUP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LOOKUP_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0148 | H2 | LOOKUP_TYPE_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LOOKUP_TYPE_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0149 | H2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0150 | H2 | PROJECT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0151 | H2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0152 | H2 | SEGMENT1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0153 | H2 | SEGMENT1_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT1_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:237:66) |
| WK-SYS0010-0154 | H2 | SEGMENT2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0155 | H2 | SEGMENT2_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT2_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:238:67) |
| WK-SYS0010-0156 | H2 | SEGMENT3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0157 | H2 | SEGMENT3_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT3_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:239:68) |
| WK-SYS0010-0158 | H2 | SEGMENT4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0159 | H2 | SEGMENT4_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT4_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:240:69) |
| WK-SYS0010-0160 | H2 | SEGMENT5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0161 | H2 | SEGMENT5_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEGMENT5_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:241:70) |
| WK-SYS0010-0162 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0163 | H5 | ATTRIBUTE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0164 | H5 | ATTRIBUTE10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE10 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0165 | H5 | ATTRIBUTE11 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE11 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0166 | H5 | ATTRIBUTE12 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE12 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0167 | H5 | ATTRIBUTE13 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE13 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0168 | H5 | ATTRIBUTE14 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE14 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0169 | H5 | ATTRIBUTE15 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE15 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0170 | H5 | ATTRIBUTE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE2 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0171 | H5 | ATTRIBUTE3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE3 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0172 | H5 | ATTRIBUTE4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE4 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0173 | H5 | ATTRIBUTE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE5 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0174 | H5 | ATTRIBUTE6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE6 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0175 | H5 | ATTRIBUTE7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE7 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0176 | H5 | ATTRIBUTE8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE8 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0177 | H5 | ATTRIBUTE9 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ATTRIBUTE9 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0178 | H5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0179 | H5 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATION_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0180 | H5 | DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0181 | H5 | DISPLAY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DISPLAY_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:229:60) |
| WK-SYS0010-0182 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0183 | H5 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FACTORY_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0184 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0185 | H5 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0186 | H5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0187 | H5 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LINE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0188 | H5 | LOOKUP_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LOOKUP_GROUP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0189 | H5 | LOOKUP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LOOKUP_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0190 | H5 | LOOKUP_TYPE_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LOOKUP_TYPE_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0191 | H5 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0192 | H5 | PROJECT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0193 | H5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCM_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0194 | H5 | SEGMENT1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0195 | H5 | SEGMENT1_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT1_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:237:66) |
| WK-SYS0010-0196 | H5 | SEGMENT2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT2 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0197 | H5 | SEGMENT2_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT2_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:238:67) |
| WK-SYS0010-0198 | H5 | SEGMENT3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT3 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0199 | H5 | SEGMENT3_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT3_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:239:68) |
| WK-SYS0010-0200 | H5 | SEGMENT4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT4 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0201 | H5 | SEGMENT4_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT4_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:240:69) |
| WK-SYS0010-0202 | H5 | SEGMENT5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT5 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0203 | H5 | SEGMENT5_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEGMENT5_KEY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:241:70) |
| WK-SYS0010-0204 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0205 | I1 | SYS0010 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0010 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 8 (MSG00004 MSG00002 MSG00060 ACT:SCM0003_L) |
| WK-SYS0010-0206 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCM0003_Lookup.EditButton ACT:SCM000) |
| WK-SYS0010-0207 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.EditButton:282:5 ACT:) |
| WK-SYS0010-0208 | D1 | LOOKUP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LOOKUP_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.EditButton ACT:SCM000) |
| WK-SYS0010-0209 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCM0003_Lookup.EditButton ACT:SCM000) |
| WK-SYS0010-0210 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.EditButton:282:5 ACT:) |
| WK-SYS0010-0211 | D3 | LOOKUP_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LOOKUP_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.EditButton ACT:SCM000) |
| WK-SYS0010-0212 | D5 | ATTRIBUTE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0213 | D5 | ATTRIBUTE10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE10 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0214 | D5 | ATTRIBUTE11 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE11 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0215 | D5 | ATTRIBUTE12 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE12 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0216 | D5 | ATTRIBUTE13 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE13 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0217 | D5 | ATTRIBUTE14 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE14 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0218 | D5 | ATTRIBUTE15 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE15 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0219 | D5 | ATTRIBUTE2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0220 | D5 | ATTRIBUTE3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0221 | D5 | ATTRIBUTE4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0222 | D5 | ATTRIBUTE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0223 | D5 | ATTRIBUTE6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE6 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0224 | D5 | ATTRIBUTE7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE7 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0225 | D5 | ATTRIBUTE8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE8 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0226 | D5 | ATTRIBUTE9 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ATTRIBUTE9 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0227 | D5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0228 | D5 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0229 | D5 | DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0230 | D5 | DISPLAY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DISPLAY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:229:60) |
| WK-SYS0010-0231 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0232 | D5 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0233 | D5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0234 | D5 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0235 | D5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0236 | D5 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0237 | D5 | LOOKUP_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOOKUP_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0238 | D5 | LOOKUP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOOKUP_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0239 | D5 | LOOKUP_TYPE_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LOOKUP_TYPE_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0240 | D5 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0241 | D5 | PROJECT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0242 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0243 | D5 | SEGMENT1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0244 | D5 | SEGMENT1_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT1_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:237:66) |
| WK-SYS0010-0245 | D5 | SEGMENT2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0246 | D5 | SEGMENT2_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT2_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:238:67) |
| WK-SYS0010-0247 | D5 | SEGMENT3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0248 | D5 | SEGMENT3_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT3_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:239:68) |
| WK-SYS0010-0249 | D5 | SEGMENT4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0250 | D5 | SEGMENT4_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT4_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:240:69) |
| WK-SYS0010-0251 | D5 | SEGMENT5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0252 | D5 | SEGMENT5_KEY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEGMENT5_KEY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0003_Lookup.InitSpread:241:70) |
| WK-SYS0010-0253 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitSpread ACT:SCM000) |
| WK-SYS0010-0254 | D6 | SYS0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0010 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 9 (Insert 추가 분기 ACT:SCM0003_Lookup.InsertBu) |
| WK-SYS0010-0255 | E4 | ATTRIBUTE1 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE1 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0256 | E4 | ATTRIBUTE10 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE10 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0257 | E4 | ATTRIBUTE11 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE11 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0258 | E4 | ATTRIBUTE12 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE12 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0259 | E4 | ATTRIBUTE13 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE13 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0260 | E4 | ATTRIBUTE14 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE14 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0261 | E4 | ATTRIBUTE15 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE15 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0262 | E4 | ATTRIBUTE2 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE2 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0263 | E4 | ATTRIBUTE3 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE3 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0264 | E4 | ATTRIBUTE4 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE4 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0265 | E4 | ATTRIBUTE5 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE5 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0266 | E4 | ATTRIBUTE6 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE6 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0267 | E4 | ATTRIBUTE7 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE7 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0268 | E4 | ATTRIBUTE8 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE8 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0269 | E4 | ATTRIBUTE9 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ATTRIBUTE9 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0270 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00002 ACT:SCM0003_Lookup.EssentialChe) |
| WK-SYS0010-0271 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00004 ACT:SCM0003_Lookup.SaveData:507) |
| WK-SYS0010-0272 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00060 ACT:SCM0003_Lookup.CheckValidat) |
| WK-SYS0010-0273 | E4 | SEGMENT1 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEGMENT1 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0274 | E4 | SEGMENT2 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEGMENT2 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0275 | E4 | SEGMENT3 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEGMENT3 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0276 | E4 | SEGMENT4 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEGMENT4 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0277 | E4 | SEGMENT5 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEGMENT5 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0003_Lookup.SetColumInfo ACT:SCM0) |
| WK-SYS0010-0278 | A10 | SYS0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0010 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 103 (ACT:SCM0003_Lookup.Form_Load ACT:SCM0003) |
| WK-SYS0010-0279 | A6 | SCM0003_GET_LOOKUP_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0003_GET_LOOKUP_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 24 (`SCM0003_GET_LOOKUP_MASTER` (L320) ACT:S) |
| WK-SYS0010-0280 | A6 | SCM0003_GET_LOOKUP_MASTER_DETAIL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0003_GET_LOOKUP_MASTER_DETAIL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 31 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0281 | G1 | cboLookupGroup / System / Lookup Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboLookupGroup / System / Lookup Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0003_Lookup.FindData_Main ACT:SCM) |
| WK-SYS0010-0282 | G1 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0003_Lookup.FindData_Main ACT:SCM) |
| WK-SYS0010-0283 | G1 | txtLookupType / Lookup Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtLookupType / Lookup Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0003_Lookup.FindData_Main ACT:SCM) |
| WK-SYS0010-0284 | G6 | cboLookupGroup / System / Lookup Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboLookupGroup / System / Lookup Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.InitControls ACT:SCM0) |
| WK-SYS0010-0285 | G6 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCM0003_Lookup.InitControls ACT:SCM0) |
| WK-SYS0010-0286 | X-REOPEN | SYS0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0010 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:SCM0003_Lookup.Dispose ACT:SCM0003_L) |
| WK-SYS0010-0287 | M3 | SCM0003_ProductionCapacityInsertPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCM0003_ProductionCapacityInsertPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 13 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0288 | M4 | LOOKUP_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — LOOKUP_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCM0003_Lookup.SpdMain_CellDoubleCli) |

## W7 기대값 확정 (87)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0010-0289 | C3 | SCM0003_Lookup.SetColumInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM0003_Lookup.SetColumInfo: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0003_Lookup.SetColumInfo:712:1 AC) |
| WK-SYS0010-0290 | B3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 1: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SYS0010-0291 | B3 | 2026-06-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 2026-06-04: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (2026-06-04) |
| WK-SYS0010-0292 | B3 | MSG00060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — MSG00060: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (MSG00060) |
| WK-SYS0010-0293 | B3 | `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L633): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6) |
| WK-SYS0010-0294 | B3 | `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0295 | B3 | `SCM0003_GET_LOOKUP_MASTER` (L320) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER` (L320): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_GET_LOOKUP_MASTER` (L320)) |
| WK-SYS0010-0296 | B4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 1: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SYS0010-0297 | B4 | 2026-06-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 2026-06-04: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (2026-06-04) |
| WK-SYS0010-0298 | B4 | MSG00060 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — MSG00060: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00060) |
| WK-SYS0010-0299 | B4 | `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L633): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6) |
| WK-SYS0010-0300 | B4 | `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0301 | B4 | `SCM0003_GET_LOOKUP_MASTER` (L320) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER` (L320): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (`SCM0003_GET_LOOKUP_MASTER` (L320)) |
| WK-SYS0010-0302 | DB-SYN | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Find: 행 집계 — DB-SYN 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SYS0010-0303 | DB-SYN | SCM0003_Lookup.DoAfterSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0003_Lookup.DoAfterSave: 진입점 집계 — DB-SYN 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0003_Lookup.DoAfterSave:633:3 ACT) |
| WK-SYS0010-0304 | DB-SYN | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — Save: 행 집계 — DB-SYN 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-SYS0010-0305 | F4 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Find: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SYS0010-0306 | F4 | SCM0003_Lookup.DoAfterSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0003_Lookup.DoAfterSave: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0003_Lookup.DoAfterSave:633:3 ACT) |
| WK-SYS0010-0307 | F4 | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — Save: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-SYS0010-0308 | A5 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Edit: 행 집계 — A5 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-SYS0010-0309 | A5 | SCM0003_Lookup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCM0003_Lookup.CreateSpread: 진입점 집계 — A5 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCM0003_Lookup.CreateSpread:148:1 AC) |
| WK-SYS0010-0310 | H2 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Edit: 행 집계 — H2 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-SYS0010-0311 | H2 | SCM0003_Lookup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCM0003_Lookup.CreateSpread: 진입점 집계 — H2 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCM0003_Lookup.CreateSpread:148:1 AC) |
| WK-SYS0010-0312 | H5 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Edit: 행 집계 — H5 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-SYS0010-0313 | H5 | SCM0003_Lookup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCM0003_Lookup.CreateSpread: 진입점 집계 — H5 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCM0003_Lookup.CreateSpread:148:1 AC) |
| WK-SYS0010-0314 | D1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SYS0010-0315 | D1 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-SYS0010-0316 | D1 | SCM0003_Lookup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCM0003_Lookup.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0003_Lookup.EditButton:279:3 ACT:) |
| WK-SYS0010-0317 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SYS0010-0318 | D3 | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Edit) |
| WK-SYS0010-0319 | D3 | SCM0003_Lookup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCM0003_Lookup.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0003_Lookup.EditButton:279:3 ACT:) |
| WK-SYS0010-0320 | D5 | SCM0003_Lookup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCM0003_Lookup.CreateSpread: 진입점 집계 — D5 42요소: NOT_RUN:42 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCM0003_Lookup.CreateSpread:148:1 AC) |
| WK-SYS0010-0321 | E4 | SCM0003_Lookup.SetColumInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0003_Lookup.SetColumInfo: 진입점 집계 — E4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0003_Lookup.SetColumInfo:712:1 AC) |
| WK-SYS0010-0322 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (2) |
| WK-SYS0010-0323 | A1 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Find) |
| WK-SYS0010-0324 | A1 | SCM0003_GET_LOOKUP_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0003_GET_LOOKUP_MASTER: 골든 비교 케이스 없음(SCM0003_GET_LOOKUP_MASTER — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 24 (`SCM0003_GET_LOOKUP_MASTER` (L320) ACT:S) |
| WK-SYS0010-0325 | A1 | SCM0003_GET_LOOKUP_MASTER_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0003_GET_LOOKUP_MASTER_DETAIL: 골든 비교 케이스 없음(SCM0003_GET_LOOKUP_MASTER_DETAIL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 31 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0326 | A6 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — Find: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SYS0010-0327 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SYS0010-0328 | G1 | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Find: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Find) |
| WK-SYS0010-0329 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SYS0010-0330 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SYS0010-0331 | X-LOC | 2026-06-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2026-06-04: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2026-06-04) |
| WK-SYS0010-0332 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SYS0010-0333 | X-LOC | DataModel.Changed grep 결과 0 건 (cascade 없 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DataModel.Changed grep 결과 0 건 (cascade 없음): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DataModel.Changed grep 결과 0 건 (cascade 없) |
| WK-SYS0010-0334 | X-LOC | Delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Delete: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Delete) |
| WK-SYS0010-0335 | X-LOC | Edit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit) |
| WK-SYS0010-0336 | X-LOC | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel) |
| WK-SYS0010-0337 | X-LOC | Find | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Find: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Find) |
| WK-SYS0010-0338 | X-LOC | Insert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert) |
| WK-SYS0010-0339 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SYS0010-0340 | X-LOC | MSG00004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00004: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00004) |
| WK-SYS0010-0341 | X-LOC | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Save) |
| WK-SYS0010-0342 | X-LOC | `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L633): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L6) |
| WK-SYS0010-0343 | X-LOC | `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) |
| WK-SYS0010-0344 | X-LOC | `SCM0003_GET_LOOKUP_MASTER` (L320) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM0003_GET_LOOKUP_MASTER` (L320): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM0003_GET_LOOKUP_MASTER` (L320)) |
| WK-SYS0010-0345 | X-ROW | DataModel.Changed grep 결과 0 건 (cascade 없 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DataModel.Changed grep 결과 0 건 (cascade 없음): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DataModel.Changed grep 결과 0 건 (cascade 없) |
| WK-SYS0010-0346 | X-ROW | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Excel: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Excel) |
| WK-SYS0010-0347 | X-ROW | SCM0003_Lookup.CheckValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.CheckValidation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCM0003_Lookup.CheckValidation ACT:S) |
| WK-SYS0010-0348 | X-ROW | SCM0003_Lookup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0003_Lookup.CreateSpread) |
| WK-SYS0010-0349 | X-ROW | SCM0003_Lookup.DoAfterSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.DoAfterSave: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCM0003_Lookup.DoAfterSave ACT:SCM00) |
| WK-SYS0010-0350 | X-ROW | SCM0003_Lookup.EssentialCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.EssentialCheck: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SCM0003_Lookup.EssentialCheck ACT:SC) |
| WK-SYS0010-0351 | X-ROW | SCM0003_Lookup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCM0003_Lookup.FindButton) |
| WK-SYS0010-0352 | X-ROW | SCM0003_Lookup.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.FindData_Main: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · NOPATH:1 |  | 2 (ACT:SCM0003_Lookup.FindData_Main:332:16 ) |
| WK-SYS0010-0353 | X-ROW | SCM0003_Lookup.FindData_Sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.FindData_Sub: 진입점 집계 5검사 — NOT_RUN:3 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:SCM0003_Lookup.FindData_Sub ACT:SCM0) |
| WK-SYS0010-0354 | X-ROW | SCM0003_Lookup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0003_Lookup.Form_Load) |
| WK-SYS0010-0355 | X-ROW | SCM0003_Lookup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0003_Lookup.InitControls:133:1 AC) |
| WK-SYS0010-0356 | X-ROW | SCM0003_Lookup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.InitSpread: 진입점 집계 141검사 — NOT_RUN:141 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0003_Lookup.InitSpread) |
| WK-SYS0010-0357 | X-ROW | SCM0003_Lookup.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0003_Lookup.InsertButton) |
| WK-SYS0010-0358 | X-ROW | SCM0003_Lookup.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.InsertRow: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCM0003_Lookup.InsertRow ACT:SCM0003) |
| WK-SYS0010-0359 | X-ROW | SCM0003_Lookup.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.SaveData: 진입점 집계 18검사 — NOT_RUN:10 · NOPATH:8 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0003_Lookup.SaveData:411:2 ACT:SC) |
| WK-SYS0010-0360 | X-ROW | SCM0003_Lookup.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_Lookup.SpdMain_CellDoubleClick: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0003_Lookup.SpdMain_CellDoubleCli) |
| WK-SYS0010-0361 | X-ROW | SCM0003_ProductionCapacityInsertPopup..c | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0362 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Bt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.BtnButtonLis: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0363 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Cr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0364 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Di | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0365 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Ed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.EditButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0366 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Es | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.EssentialChe: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0367 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Fo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0368 | X-ROW | SCM0003_ProductionCapacityInsertPopup.In | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.InitControls: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0369 | X-ROW | SCM0003_ProductionCapacityInsertPopup.In | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.InitSpread: 진입점 집계 30검사 — NOT_RUN:30 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0370 | X-ROW | SCM0003_ProductionCapacityInsertPopup.In | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0371 | X-ROW | SCM0003_ProductionCapacityInsertPopup.In | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.InsertRow: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0372 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Ok | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.OkButtonClic: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0373 | X-ROW | SCM0003_ProductionCapacityInsertPopup.Sp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0003_ProductionCapacityInsertPopup.SpdMain_Comb: 진입점 집계 39검사 — NOT_RUN:21 · NOPATH:15 · TODO:3 (미실행 검사가 남아 판정필요) |  | 19 (ACT:SCM0003_ProductionCapacityInsertPopu) |
| WK-SYS0010-0374 | X-ROW | 메뉴 권한 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 메뉴 권한: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (메뉴 권한) |
| WK-SYS0010-0375 | M4 | SCM0003_Lookup.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0003_Lookup.SpdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0003_Lookup.SpdMain_CellDoubleCli) |
