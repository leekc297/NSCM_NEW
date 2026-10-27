# 작업 원장 — DMF0045 · 2026-10-26 12:50

> 검사 인스턴스 485건 중 PASS·NA 101건 외 **384건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 28 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 44 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 118 | 실행 → PASS |
| W7 | 기대값 확정 | 192 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 190 · E2E 118 · 하네스 46 · 대조표 30
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 40 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 28 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 19 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D1 | EDIT |  |  |  |  |  | 3 | 17 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 17 |  |  | 행 값 기반 조건부 잠금 |
| C3 | CASCADE |  |  |  |  |  | 5 | 14 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 10 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 2 | 10 | 2 |  |  | 조회조건 표시·라벨·활성 |
| B4 | COMBO |  |  |  |  | 7 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G5 | POPUP |  |  |  |  | 7 |  | 5 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 | 2 | 5 |  |  | 팝업 표준·열림 |
| G6 | GEN |  |  |  |  |  | 10 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| M4 | POPUP |  |  |  |  |  | 7 | 5 |  |  | 팝업 선택값 반영 |
| C2 | CASCADE |  |  |  |  |  | 2 | 9 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 2 | 9 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| H2 | DESIGN |  |  |  |  |  | 3 | 7 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 4 | 6 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B1 | COMBO |  |  |  |  | 6 |  | 2 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 6 |  | 2 |  |  | 콤보 후보 중복 없음 |
| A5 | DESIGN |  |  |  |  |  | 2 | 6 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D5 | EDIT |  |  |  |  |  | 2 | 6 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 7 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B6 | COMBO |  |  |  |  | 6 |  |  |  |  | ALL 옵션·다중선택 사양 |
| D4 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| B3 | COMBO |  |  |  | 2 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| C4 | CASCADE |  |  |  |  |  | 5 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F4 | DB |  |  |  |  |  | 5 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
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
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| E1 | EDIT |  |  |  |  |  | 1 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0045-0001 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: store/useShipmentRequestStore.ts 없음 |  | 1 (COMMON:UC-03) |
| WK-DMF0045-0002 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: store/useShipmentRequestStore.ts 없음 |  | 1 (COMMON:UC-06) |
| WK-DMF0045-0003 | X-LOC | D00-2-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.searchCombos.ts 없음 |  | 1 (D00-2-008) |
| WK-DMF0045-0004 | X-LOC | D00-2-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.searchCombos.ts 없음 |  | 1 (D00-2-009) |
| WK-DMF0045-0005 | X-LOC | D00-2-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.merge.ts 없음, Grid.tsx 없음 |  | 1 (D00-2-012) |
| WK-DMF0045-0006 | X-LOC | D00-3-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.merge.ts 없음 |  | 1 (D00-3-001) |
| WK-DMF0045-0007 | X-LOC | D00-3-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-002) |
| WK-DMF0045-0008 | X-LOC | D00-3-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-003) |
| WK-DMF0045-0009 | X-LOC | D00-3-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-004) |
| WK-DMF0045-0010 | X-LOC | D00-3-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-005) |
| WK-DMF0045-0011 | X-LOC | D00-3-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-006) |
| WK-DMF0045-0012 | X-LOC | D00-3-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-3-007) |
| WK-DMF0045-0013 | X-LOC | D00-3-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.merge.ts 없음 |  | 1 (D00-3-009) |
| WK-DMF0045-0014 | X-LOC | D00-3-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.bohFrontFill.ts 없음 |  | 1 (D00-3-010) |
| WK-DMF0045-0015 | X-LOC | D00-3-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.recalc.ts 없음 |  | 1 (D00-3-011) |
| WK-DMF0045-0016 | X-LOC | D00-3-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.save.ts 없음 |  | 1 (D00-3-020) |
| WK-DMF0045-0017 | X-LOC | D00-3-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.merge.ts 없음 |  | 1 (D00-3-021) |
| WK-DMF0045-0018 | X-LOC | D00-4d-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-001) |
| WK-DMF0045-0019 | X-LOC | D00-4d-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-004) |
| WK-DMF0045-0020 | X-LOC | D00-4d-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.editLock.ts 없음 |  | 1 (D00-4d-010) |
| WK-DMF0045-0021 | X-LOC | D00-4d-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-011) |
| WK-DMF0045-0022 | X-LOC | D00-4d-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-012) |
| WK-DMF0045-0023 | X-LOC | D00-4d-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-013) |
| WK-DMF0045-0024 | X-LOC | D00-4d-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-014) |
| WK-DMF0045-0025 | X-LOC | D00-4d-015 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-015) |
| WK-DMF0045-0026 | X-LOC | D00-4d-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-016) |
| WK-DMF0045-0027 | X-LOC | D00-4d-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-017) |
| WK-DMF0045-0028 | X-LOC | D00-4d-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/dmf0045.validate.ts 없음 |  | 1 (D00-4d-018) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0045-0029 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 3 (ACT:DMF0045_ShipmentRequest.GetSpdTitle ) |
| WK-DMF0045-0030 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0045_ShipmentRequest.GetSpdTitle ) |

## W5 검사기 연결 (44)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0045-0031 | B1 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-DMF0045-0032 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-DMF0045-0033 | B1 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (D00-1-009) |
| WK-DMF0045-0034 | B1 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-DMF0045-0035 | B1 | clbSalesSite / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbSalesSite / Sales Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-DMF0045-0036 | B1 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (D00-1-013) |
| WK-DMF0045-0037 | B2 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-DMF0045-0038 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-DMF0045-0039 | B2 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (D00-1-009) |
| WK-DMF0045-0040 | B2 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-DMF0045-0041 | B2 | clbSalesSite / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbSalesSite / Sales Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-DMF0045-0042 | B2 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (D00-1-013) |
| WK-DMF0045-0043 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-DMF0045-0044 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 4 (D00-1-007 ACT:DMF0045_ShipmentRequest.Ge) |
| WK-DMF0045-0045 | B4 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (D00-1-009) |
| WK-DMF0045-0046 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-DMF0045-0047 | B4 | clbSalesSite / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSalesSite / Sales Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-DMF0045-0048 | B4 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (D00-1-013) |
| WK-DMF0045-0049 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0045_ShipmentRequest.GetSpdTitle ) |
| WK-DMF0045-0050 | B6 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-DMF0045-0051 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-DMF0045-0052 | B6 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (D00-1-009) |
| WK-DMF0045-0053 | B6 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-DMF0045-0054 | B6 | clbSalesSite / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbSalesSite / Sales Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-DMF0045-0055 | B6 | clbTeam / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbTeam / Team | 있음(FE 소스) | 1 (D00-1-013) |
| WK-DMF0045-0056 | F2 | DMF0045 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0045 화면 | 판단불가(대상 단위 SCREEN) | 116 (D00-3-020 D00-4d-002 D00-4d-005 D00-4d-0) |
| WK-DMF0045-0057 | F6 | DMF0045 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0045 화면 | 판단불가(대상 단위 SCREEN) | 108 (ACT:DMF0045_ShipmentRequest.SaveButton A) |
| WK-DMF0045-0058 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0045_ShipmentRequest.GetBucketTyp) |
| WK-DMF0045-0059 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0045_ShipmentRequest.GetBizTypeby) |
| WK-DMF0045-0060 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:DMF0045_ShipmentRequest.InitControls) |
| WK-DMF0045-0061 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:DMF0045_ShipmentRequest.InitControls) |
| WK-DMF0045-0062 | G03-WIRE | DMF0045 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0045 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:DMF0045_ShipmentRequest..ctor ACT:DM) |
| WK-DMF0045-0063 | G5 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL P | 있음(FE 소스) | 1 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0064 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0065 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (D00-1-003 D00-2-002 MODAL:ShipmentReques) |
| WK-DMF0045-0066 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0067 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 없음 | 3 (D00-1-005 D00-2-004 MODAL:ShipmentReques) |
| WK-DMF0045-0068 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0069 | G5 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0070 | H6 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL P | 있음(FE 소스) | 1 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0071 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0072 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (D00-1-003 D00-2-002 MODAL:ShipmentReques) |
| WK-DMF0045-0073 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0074 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 없음 | 3 (D00-1-005 D00-2-004 MODAL:ShipmentReques) |

## W6 검증 실행 (118)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0045-0075 | J2 | DMF0045 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0045 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 62 (D00-1-001 D00-1-015 D00-2-008 D00-2-011 ) |
| WK-DMF0045-0076 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-005 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0077 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-006 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0078 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-DMF0045-0079 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (D00-2-008 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0080 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.InitControls) |
| WK-DMF0045-0081 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0045_ShipmentRequest.InitControls) |
| WK-DMF0045-0082 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-009 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0083 | C2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0084 | C2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0085 | C3 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0086 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (D00-2-013 ACT:DMF0045_ShipmentRequest.cb) |
| WK-DMF0045-0087 | C3 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0088 | C3 | T | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — T · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0089 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.SetSaveData ) |
| WK-DMF0045-0090 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-005) |
| WK-DMF0045-0091 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-DMF0045-0092 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-DMF0045-0093 | C4 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-DMF0045-0094 | C4 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-DMF0045-0095 | C6 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0096 | C6 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0097 | G3 | DMF0045 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0045 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 8 (D00-1-044 COMMON:UC-01 COMMON:UC-02 COMM) |
| WK-DMF0045-0098 | K-SA | DMF0045 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — DMF0045 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (D00-1-044) |
| WK-DMF0045-0099 | K4 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 51 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0045-0100 | F1 | DMF0045 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0045 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 119 (D00-3-020 D00-4d-002 D00-4d-005 D00-4d-0) |
| WK-DMF0045-0101 | F3 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (D00-2-013) |
| WK-DMF0045-0102 | F5 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 4 (D00-3-020 ACT:DMF0045_ShipmentRequest.De) |
| WK-DMF0045-0103 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0045_ShipmentRequest.GetBucketTyp) |
| WK-DMF0045-0104 | F4 | PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 183 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0105 | F4 | PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 183 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0106 | F4 | PKG_DMF0045.P_DMF0045_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0045.P_DMF0045_SAVE_SHIPMENT_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 108 (ACT:DMF0045_ShipmentRequest.SaveButton A) |
| WK-DMF0045-0107 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0045_ShipmentRequest.GetBizTypeby) |
| WK-DMF0045-0108 | A5 | B | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — B · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0109 | A5 | T | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — T · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0110 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0111 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-007 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0112 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-DMF0045-0113 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-009 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0114 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0115 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0116 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-013 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0117 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0118 | G4 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-042) |
| WK-DMF0045-0119 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-043) |
| WK-DMF0045-0120 | H2 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0121 | H2 | S | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — S · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0045_ShipmentRequest.SaveData:939) |
| WK-DMF0045-0122 | H2 | T | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — T · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0123 | H4 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (D00-2-012 ACT:DMF0045_ShipmentRequest.sp) |
| WK-DMF0045-0124 | H5 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — B · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0125 | H5 | T | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — T · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0126 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0127 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0128 | I1 | DMF0045 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0045 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 36 (D00-2-005 D00-4d-001 D00-4d-002 D00-4d-0) |
| WK-DMF0045-0129 | SC1 | DMF0045 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0045 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 12 (D00-1-006 D00-1-007 D00-1-008 D00-1-009 ) |
| WK-DMF0045-0130 | D1 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-004 ACT:DMF0045_ShipmentRequest.Ed) |
| WK-DMF0045-0131 | D1 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-004) |
| WK-DMF0045-0132 | D1 | M | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — M · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-004) |
| WK-DMF0045-0133 | D3 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — D · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-004 ACT:DMF0045_ShipmentRequest.Ed) |
| WK-DMF0045-0134 | D3 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — I · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-004) |
| WK-DMF0045-0135 | D3 | M | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — M · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-004) |
| WK-DMF0045-0136 | D4 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-020) |
| WK-DMF0045-0137 | D5 | B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0138 | D5 | T | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — T · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0139 | D6 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (COMMON:UC-01 COMMON:UC-03 ACT:DMF0045_Sh) |
| WK-DMF0045-0140 | E1 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (D00-2-013) |
| WK-DMF0045-0141 | E4 | B | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — B · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0142 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 17 (D00-4d-010 D00-4d-011 D00-4d-012 D00-4d-) |
| WK-DMF0045-0143 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-005 D00-4d-008 ACT:DMF0045_Shipme) |
| WK-DMF0045-0144 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-008 ACT:DMF0045_ShipmentRequest.S) |
| WK-DMF0045-0145 | E4 | MSG00042 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00042 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-007 ACT:DMF0045_ShipmentRequest.S) |
| WK-DMF0045-0146 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0045_ShipmentRequest.SaveData:820) |
| WK-DMF0045-0147 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-004 ACT:DMF0045_ShipmentRequest.S) |
| WK-DMF0045-0148 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-004) |
| WK-DMF0045-0149 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-001 ACT:DMF0045_ShipmentRequest.F) |
| WK-DMF0045-0150 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-010 ACT:DMF0045_ShipmentRequest.s) |
| WK-DMF0045-0151 | E4 | MSG00227 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00227 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-2-005) |
| WK-DMF0045-0152 | E4 | MSG00618 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00618 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-007) |
| WK-DMF0045-0153 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-DMF0045-0154 | E4 | N | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — N · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-007 ACT:DMF0045_ShipmentRequest.S) |
| WK-DMF0045-0155 | E4 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — S · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-4d-005 ACT:DMF0045_ShipmentRequest.S) |
| WK-DMF0045-0156 | E4 | T | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — T · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0157 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0045_ShipmentRequest.SetSaveData ) |
| WK-DMF0045-0158 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 19 (D00-2-005 ACT:DMF0045_ShipmentRequest.Se) |
| WK-DMF0045-0159 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0160 | A10 | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 79 (ACT:DMF0045_ShipmentRequest.DefineProper) |
| WK-DMF0045-0161 | A6 | PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 77 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0162 | A6 | PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 74 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0163 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-006) |
| WK-DMF0045-0164 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0165 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-DMF0045-0166 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-009 D00-2-008 ACT:DMF0045_Shipment) |
| WK-DMF0045-0167 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0168 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0169 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-013 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0170 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0171 | G1 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-042 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0172 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-043 ACT:DMF0045_ShipmentRequest.Fi) |
| WK-DMF0045-0173 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-006 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0174 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-007 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0175 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-008) |
| WK-DMF0045-0176 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-009 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0177 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0178 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-012 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0179 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-013 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0180 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-015 ACT:DMF0045_ShipmentRequest.In) |
| WK-DMF0045-0181 | G6 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-042) |
| WK-DMF0045-0182 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-043) |
| WK-DMF0045-0183 | X-REOPEN | DMF0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0045 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:DMF0045_ShipmentRequest.Dispose ACT:) |
| WK-DMF0045-0184 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0185 | H6 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — drpPeriod / Period · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0186 | M4 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — P · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0187 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0188 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-1-003 D00-2-002 MODAL:ShipmentReques) |
| WK-DMF0045-0189 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ShipmentRequestModals) |
| WK-DMF0045-0190 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-1-005 D00-2-004 MODAL:ShipmentReques) |
| WK-DMF0045-0191 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0192 | M4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |

## W7 기대값 확정 (192)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0045-0193 | C2 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-011: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0194 | C2 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-019: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-DMF0045-0195 | C2 | DMF0045_ShipmentRequest.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.cboBucketType_SelectedInde: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.cboBucketTyp) |
| WK-DMF0045-0196 | C2 | DMF0045_ShipmentRequest.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.cboDivision_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0197 | C2 | DMF0045_ShipmentRequest.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.chkSum_CheckedChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.chkSum_Check) |
| WK-DMF0045-0198 | C2 | DMF0045_ShipmentRequest.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.clbCustomer_SelectedIndexC: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.clbCustomer_) |
| WK-DMF0045-0199 | C2 | DMF0045_ShipmentRequest.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.clbTeam_SelectedIndexChang: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.clbTeam_Sele) |
| WK-DMF0045-0200 | C2 | DMF0045_ShipmentRequest.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.spdMain_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 237 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0201 | C2 | DMF0045_ShipmentRequest.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0045_ShipmentRequest.spdMain_ComboSelChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0045_ShipmentRequest.spdMain_Comb) |
| WK-DMF0045-0202 | C3 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-011: 행 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0203 | C3 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-019: 행 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-DMF0045-0204 | C3 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0205 | C3 | DMF0045_ShipmentRequest.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.SetSaveData: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0045_ShipmentRequest.SetSaveData:) |
| WK-DMF0045-0206 | C3 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0207 | C3 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0208 | C3 | DMF0045_ShipmentRequest.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.Set_SumValues: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 28 (ACT:DMF0045_ShipmentRequest.Set_SumValue) |
| WK-DMF0045-0209 | C3 | DMF0045_ShipmentRequest.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.cboBucketType_SelectedInde: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.cboBucketTyp) |
| WK-DMF0045-0210 | C3 | DMF0045_ShipmentRequest.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.cboDivision_SelectedIndexC: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0211 | C3 | DMF0045_ShipmentRequest.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.chkSum_CheckedChanged: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.chkSum_Check) |
| WK-DMF0045-0212 | C3 | DMF0045_ShipmentRequest.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.clbCustomer_SelectedIndexC: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.clbCustomer_) |
| WK-DMF0045-0213 | C3 | DMF0045_ShipmentRequest.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.clbTeam_SelectedIndexChang: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.clbTeam_Sele) |
| WK-DMF0045-0214 | C3 | DMF0045_ShipmentRequest.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.spdMain_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 237 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0215 | C3 | DMF0045_ShipmentRequest.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0045_ShipmentRequest.spdMain_ComboSelChange: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0045_ShipmentRequest.spdMain_Comb) |
| WK-DMF0045-0216 | C6 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-011: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0217 | C6 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-019: 행 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-DMF0045-0218 | C6 | DMF0045_ShipmentRequest.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.cboBucketType_SelectedInde: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.cboBucketTyp) |
| WK-DMF0045-0219 | C6 | DMF0045_ShipmentRequest.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.cboDivision_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0220 | C6 | DMF0045_ShipmentRequest.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.chkSum_CheckedChanged: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.chkSum_Check) |
| WK-DMF0045-0221 | C6 | DMF0045_ShipmentRequest.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.clbCustomer_SelectedIndexC: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.clbCustomer_) |
| WK-DMF0045-0222 | C6 | DMF0045_ShipmentRequest.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.clbTeam_SelectedIndexChang: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.clbTeam_Sele) |
| WK-DMF0045-0223 | C6 | DMF0045_ShipmentRequest.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.spdMain_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 237 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0224 | C6 | DMF0045_ShipmentRequest.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0045_ShipmentRequest.spdMain_ComboSelChange: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0045_ShipmentRequest.spdMain_Comb) |
| WK-DMF0045-0225 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0226 | B1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — D00-2-011: 행 집계 — B1 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0227 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0228 | B2 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — D00-2-011: 행 집계 — B2 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0229 | B3 | DMF0045_ShipmentRequest.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0045_ShipmentRequest.GetBizTypebyDivision: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.GetBizTypeby) |
| WK-DMF0045-0230 | B3 | DMF0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0045_ShipmentRequest.GetBucketType: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.GetBucketTyp) |
| WK-DMF0045-0231 | B3 | DMF0045_ShipmentRequest.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0045_ShipmentRequest.GetSpdTitle: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.GetSpdTitle:) |
| WK-DMF0045-0232 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0233 | B4 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-2-011: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0234 | B4 | DMF0045_ShipmentRequest.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0045_ShipmentRequest.GetBizTypebyDivision: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.GetBizTypeby) |
| WK-DMF0045-0235 | B4 | DMF0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0045_ShipmentRequest.GetBucketType: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.GetBucketTyp) |
| WK-DMF0045-0236 | B4 | DMF0045_ShipmentRequest.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0045_ShipmentRequest.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.GetSpdTitle:) |
| WK-DMF0045-0237 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0238 | A5 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-040: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-DMF0045-0239 | A5 | DMF0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0045_ShipmentRequest.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0045_ShipmentRequest.CreateSpread) |
| WK-DMF0045-0240 | A5 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0241 | A5 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0242 | A5 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0243 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 12요소: NOT_RUN:10 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0045-0244 | G4 | D00-1-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-044: 행 집계 — G4 12요소: NOT_RUN:10 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-044) |
| WK-DMF0045-0245 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0246 | H2 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-040: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-DMF0045-0247 | H2 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-012: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-DMF0045-0248 | H2 | DMF0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0045_ShipmentRequest.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0045_ShipmentRequest.CreateSpread) |
| WK-DMF0045-0249 | H2 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0250 | H2 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0251 | H2 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0252 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0253 | H5 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-040: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-DMF0045-0254 | H5 | DMF0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0045_ShipmentRequest.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0045_ShipmentRequest.CreateSpread) |
| WK-DMF0045-0255 | H5 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0256 | H5 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0257 | H5 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0258 | X-REASON | D00-1-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-014 §1 components / System.ComponentModel.Container  WinForms designer 아티팩트(IContainer) — TO-BE 무관 해당없음 |  | 1 (D00-1-014) |
| WK-DMF0045-0259 | X-REASON | D00-4d-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-003 §4d MSG00043 / !fnValidation() utils/dmf0045.save.ts:6-9 (중복검사 SP 내장 — SAVE SP fnValidation 재구현 금지)  |  | 1 (D00-4d-003) |
| WK-DMF0045-0260 | D1 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-1-001: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-DMF0045-0261 | D1 | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-1-015: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-015) |
| WK-DMF0045-0262 | D1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-011: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0263 | D1 | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-002: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-DMF0045-0264 | D1 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-003: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-DMF0045-0265 | D1 | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-005: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-005) |
| WK-DMF0045-0266 | D1 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-006: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-DMF0045-0267 | D1 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-007: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-DMF0045-0268 | D1 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-008: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-DMF0045-0269 | D1 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-012: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-012) |
| WK-DMF0045-0270 | D1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-013: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-DMF0045-0271 | D1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-014: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-DMF0045-0272 | D1 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-015: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-015) |
| WK-DMF0045-0273 | D1 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-016: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-DMF0045-0274 | D1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-017: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-DMF0045-0275 | D1 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-018: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-DMF0045-0276 | D1 | DMF0045_ShipmentRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0045_ShipmentRequest.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0045_ShipmentRequest.EditButton:4) |
| WK-DMF0045-0277 | D3 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-001: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-DMF0045-0278 | D3 | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-015: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-015) |
| WK-DMF0045-0279 | D3 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-011: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0280 | D3 | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-002: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-DMF0045-0281 | D3 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-003: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-DMF0045-0282 | D3 | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-005: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-005) |
| WK-DMF0045-0283 | D3 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-006: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-DMF0045-0284 | D3 | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-007: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-007) |
| WK-DMF0045-0285 | D3 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-008: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-DMF0045-0286 | D3 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-012: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-012) |
| WK-DMF0045-0287 | D3 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-013: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-DMF0045-0288 | D3 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-014: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-DMF0045-0289 | D3 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-015: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-015) |
| WK-DMF0045-0290 | D3 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-016: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-DMF0045-0291 | D3 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-017: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-DMF0045-0292 | D3 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-018: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-DMF0045-0293 | D3 | DMF0045_ShipmentRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0045_ShipmentRequest.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 47 (ACT:DMF0045_ShipmentRequest.EditButton:4) |
| WK-DMF0045-0294 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-DMF0045-0295 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0045-0296 | D4 | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-010: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-010) |
| WK-DMF0045-0297 | D4 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-011: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-DMF0045-0298 | D4 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-019: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-DMF0045-0299 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0045-0300 | D5 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-2-011: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-DMF0045-0301 | D5 | DMF0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0045_ShipmentRequest.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0045_ShipmentRequest.CreateSpread) |
| WK-DMF0045-0302 | D5 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0303 | D5 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0304 | D5 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0305 | E4 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-002: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-DMF0045-0306 | E4 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-009: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-DMF0045-0307 | E4 | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0308 | E4 | DMF0045_ShipmentRequest.SetSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0045_ShipmentRequest.SetSaveData: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0045_ShipmentRequest.SetSaveData:) |
| WK-DMF0045-0309 | E4 | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0310 | E4 | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0311 | E4 | DMF0045_ShipmentRequest.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0045_ShipmentRequest.Set_SumValues: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 28 (ACT:DMF0045_ShipmentRequest.Set_SumValue) |
| WK-DMF0045-0312 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-DMF0045-0313 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-DMF0045-0314 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-DMF0045-0315 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-DMF0045-0316 | A1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-008: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-2-008) |
| WK-DMF0045-0317 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4d-001) |
| WK-DMF0045-0318 | A1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-002: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4d-002) |
| WK-DMF0045-0319 | A1 | PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST: 골든 비교 케이스 없음(PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST — 팝업·보조 SP 는 golde |  | 77 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0320 | A1 | PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 74 (ACT:DMF0045_ShipmentRequest.FindButton A) |
| WK-DMF0045-0321 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-DMF0045-0322 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0045-0323 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0045-0324 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0045-0325 | G1 | D00-1-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-044: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-044) |
| WK-DMF0045-0326 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-DMF0045-0327 | G1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-002: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-DMF0045-0328 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0045-0329 | G6 | D00-1-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-044: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-044) |
| WK-DMF0045-0330 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-DMF0045-0331 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-DMF0045-0332 | X-ROW | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-001) |
| WK-DMF0045-0333 | X-ROW | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-003) |
| WK-DMF0045-0334 | X-ROW | DMF0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.CreateSpread) |
| WK-DMF0045-0335 | X-ROW | DMF0045_ShipmentRequest.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0045_ShipmentRequest.DefineProper) |
| WK-DMF0045-0336 | X-ROW | DMF0045_ShipmentRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.EditButton: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 5 (ACT:DMF0045_ShipmentRequest.EditButton:4) |
| WK-DMF0045-0337 | X-ROW | DMF0045_ShipmentRequest.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0045_ShipmentRequest.FindButton) |
| WK-DMF0045-0338 | X-ROW | DMF0045_ShipmentRequest.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.FindData: 진입점 집계 19검사 — NOT_RUN:15 · REVIEW:2 · PASS:2 |  | 11 (ACT:DMF0045_ShipmentRequest.FindData:579) |
| WK-DMF0045-0339 | X-ROW | DMF0045_ShipmentRequest.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.Form_Load) |
| WK-DMF0045-0340 | X-ROW | DMF0045_ShipmentRequest.GetBizTypebyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.GetBizTypebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.GetBizTypeby) |
| WK-DMF0045-0341 | X-ROW | DMF0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.GetBucketTyp) |
| WK-DMF0045-0342 | X-ROW | DMF0045_ShipmentRequest.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InitControls: 진입점 집계 23검사 — NOT_RUN:21 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0045_ShipmentRequest.InitControls) |
| WK-DMF0045-0343 | X-ROW | DMF0045_ShipmentRequest.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.InitEvent) |
| WK-DMF0045-0344 | X-ROW | DMF0045_ShipmentRequest.InitSaveDataTabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InitSaveDataTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.InitSaveData) |
| WK-DMF0045-0345 | X-ROW | DMF0045_ShipmentRequest.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.InitSpread) |
| WK-DMF0045-0346 | X-ROW | DMF0045_ShipmentRequest.InitSpreadFooter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.InitSpreadFo) |
| WK-DMF0045-0347 | X-ROW | DMF0045_ShipmentRequest.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.InsertButton) |
| WK-DMF0045-0348 | X-ROW | DMF0045_ShipmentRequest.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/COMBO_DATA/DATA_OP/ENTRY/EXPR/GRID_COMBO/GRID_L |  | 48 (ACT:DMF0045_ShipmentRequest.InsertRow AC) |
| WK-DMF0045-0349 | X-ROW | DMF0045_ShipmentRequest.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/VALUE_SET, 연결된 요소 검사 없음 |  | 6 (ACT:DMF0045_ShipmentRequest.OnShown ACT:) |
| WK-DMF0045-0350 | X-ROW | DMF0045_ShipmentRequest.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.SaveData: 진입점 집계 19검사 — NOT_RUN:14 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0045_ShipmentRequest.SaveData:803) |
| WK-DMF0045-0351 | X-ROW | DMF0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.SetImageCell: 진입점 집계 12검사 — REVIEW:6 · NOT_RUN:6 |  | 1 (ACT:DMF0045_ShipmentRequest.SetImageCell) |
| WK-DMF0045-0352 | X-ROW | DMF0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:16 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0045_ShipmentRequest.SetSpreadCol) |
| WK-DMF0045-0353 | X-ROW | DMF0045_ShipmentRequest.SetSpreadHeaderS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.SetSpreadHeaderSpan: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.SetSpreadHea) |
| WK-DMF0045-0354 | X-ROW | DMF0045_ShipmentRequest.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.Set_SumValue) |
| WK-DMF0045-0355 | X-ROW | DMF0045_ShipmentRequest.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.btnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.btnColumn_Cl) |
| WK-DMF0045-0356 | X-ROW | DMF0045_ShipmentRequest.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.btnItemId_Cl) |
| WK-DMF0045-0357 | X-ROW | DMF0045_ShipmentRequest.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.btnMeasure_C) |
| WK-DMF0045-0358 | X-ROW | DMF0045_ShipmentRequest.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0045_ShipmentRequest.btnProject_C) |
| WK-DMF0045-0359 | X-ROW | DMF0045_ShipmentRequest.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.cboBucketType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.cboBucketTyp) |
| WK-DMF0045-0360 | X-ROW | DMF0045_ShipmentRequest.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.cboDivision_SelectedIndexC: 진입점 집계 10검사 — NOT_RUN:7 · REVIEW:3 |  | 4 (ACT:DMF0045_ShipmentRequest.cboDivision_) |
| WK-DMF0045-0361 | X-ROW | DMF0045_ShipmentRequest.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0045_ShipmentRequest.chkSum_Check) |
| WK-DMF0045-0362 | X-ROW | DMF0045_ShipmentRequest.clbCustomer_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.clbCustomer_SelectedIndexC: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.clbCustomer_) |
| WK-DMF0045-0363 | X-ROW | DMF0045_ShipmentRequest.clbTeam_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.clbTeam_SelectedIndexChang: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0045_ShipmentRequest.clbTeam_Sele) |
| WK-DMF0045-0364 | X-ROW | DMF0045_ShipmentRequest.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 24 (ACT:DMF0045_ShipmentRequest.fnValidation) |
| WK-DMF0045-0365 | X-ROW | DMF0045_ShipmentRequest.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.spdMain_CellDoubleClick: 진입점 집계 14검사 — NOT_RUN:7 · NOPATH:4 · REVIEW:3 |  | 27 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0366 | X-ROW | DMF0045_ShipmentRequest.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.spdMain_Changed: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 30 (ACT:DMF0045_ShipmentRequest.spdMain_Chan) |
| WK-DMF0045-0367 | X-ROW | DMF0045_ShipmentRequest.spdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0045_ShipmentRequest.spdMain_Comb) |
| WK-DMF0045-0368 | X-ROW | DMF0045_ShipmentRequest.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0045_ShipmentRequest.spdMain_KeyU) |
| WK-DMF0045-0369 | X-ROW | DMF0045_ShipmentRequest.spdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0045_ShipmentRequest.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0045_ShipmentRequest.spdMain_TopC) |
| WK-DMF0045-0370 | G5 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-010: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-DMF0045-0371 | G5 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-010: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-DMF0045-0372 | G5 | DMF0045_ShipmentRequest.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0045_ShipmentRequest.spdMain_CellDoubleClick: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 84 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0373 | G5 | MODAL:BodItemRouteModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:BodItemRouteModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:BodItemRouteModal) |
| WK-DMF0045-0374 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-DMF0045-0375 | H6 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-010: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-DMF0045-0376 | H6 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-010: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-DMF0045-0377 | H6 | DMF0045_ShipmentRequest.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0045_ShipmentRequest.spdMain_CellDoubleClick: 진입점 집계 — H6 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 84 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0378 | H6 | MODAL:BodItemRouteModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:BodItemRouteModal: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:BodItemRouteModal) |
| WK-DMF0045-0379 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 7요소: NOPATH:5 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-DMF0045-0380 | M4 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-010: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-DMF0045-0381 | M4 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-010: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-DMF0045-0382 | M4 | DMF0045_ShipmentRequest.spdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0045_ShipmentRequest.spdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 84 (ACT:DMF0045_ShipmentRequest.spdMain_Cell) |
| WK-DMF0045-0383 | M4 | MODAL:BodItemRouteModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:BodItemRouteModal: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:BodItemRouteModal) |
| WK-DMF0045-0384 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
