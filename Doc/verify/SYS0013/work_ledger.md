# 작업 원장 — SYS0013 · 2026-10-26 13:00

> 검사 인스턴스 283건 중 PASS·NA 20건 외 **263건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 18 | 구현 위치 실존 |
| W5 | 검사기 연결 | 12 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 103 | 실행 → PASS |
| W7 | 기대값 확정 | 130 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 127 · E2E 103 · 대조표 21 · 하네스 12
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 46 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| M4 | POPUP |  |  |  |  |  | 10 | 12 |  |  | 팝업 선택값 반영 |
| A5 | DESIGN |  |  |  |  |  | 16 | 5 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 16 | 5 |  |  | 라벨 명칭 |
| X-LOC | GEN |  | 18 |  |  |  |  | 2 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 14 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 10 | 5 |  |  | 연쇄 자동 채움 |
| G5 | POPUP |  |  |  |  | 1 |  | 12 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  | 12 |  |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 3 | 4 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 3 | 4 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 7 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  |  |  |  | 4 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G1 | GEN |  |  |  |  |  | 3 | 3 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| DB-SYN | DB |  |  |  |  | 4 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  |  | 4 |  |  |  | 조회조건 표시·라벨·활성 |
| C1 | CASCADE |  |  |  |  |  | 2 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D4 | EDIT |  |  |  |  |  | 2 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
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

## W2 구현 위치 확인 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0013-0001 | X-LOC | 1.10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.10) |
| WK-SYS0013-0002 | X-LOC | 1.11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.11) |
| WK-SYS0013-0003 | X-LOC | 1.2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.2) |
| WK-SYS0013-0004 | X-LOC | 1.3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.3) |
| WK-SYS0013-0005 | X-LOC | 1.4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.4) |
| WK-SYS0013-0006 | X-LOC | 1.5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.5) |
| WK-SYS0013-0007 | X-LOC | 1.6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.6) |
| WK-SYS0013-0008 | X-LOC | 1.7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.7) |
| WK-SYS0013-0009 | X-LOC | 1.9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1.9) |
| WK-SYS0013-0010 | X-LOC | 2.1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.1) |
| WK-SYS0013-0011 | X-LOC | 2.10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.10) |
| WK-SYS0013-0012 | X-LOC | 2.11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.11) |
| WK-SYS0013-0013 | X-LOC | 2.12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.12) |
| WK-SYS0013-0014 | X-LOC | 2.2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.2) |
| WK-SYS0013-0015 | X-LOC | 2.4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.4) |
| WK-SYS0013-0016 | X-LOC | 2.5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.5) |
| WK-SYS0013-0017 | X-LOC | 2.6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.6) |
| WK-SYS0013-0018 | X-LOC | 2.8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2.8) |

## W5 검사기 연결 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0013-0019 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0020 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0021 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0022 | F2 | SYS0013 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0013 화면 | 판단불가(대상 단위 SCREEN) | 103 (1.4 1.6 2.8 ACT:SCM0005_DynamicQueryList) |
| WK-SYS0013-0023 | F6 | SYS0013 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0013 화면 | 판단불가(대상 단위 SCREEN) | 100 (ACT:SCM0005_DynamicQueryList.SaveButton ) |
| WK-SYS0013-0024 | DB-SYN | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 없음(PROC_M 대응 없음) | 6 (ACT:SCM0005_DynamicQueryList.GroupData:6) |
| WK-SYS0013-0025 | DB-SYN | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 없음(PROC_M 대응 없음) | 20 (ACT:SCM0005_DynamicQueryList.FindData:34) |
| WK-SYS0013-0026 | DB-SYN | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | 없음(PROC_M 대응 없음) | 17 (ACT:SCM0005_DynamicQueryList.FindData:34) |
| WK-SYS0013-0027 | DB-SYN | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | 없음(PROC_M 대응 없음) | 6 (ACT:SCM0005_DynamicQueryList.ParameterDa) |
| WK-SYS0013-0028 | G03-WIRE | SYS0013 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0013 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCM0005_DynamicQueryList..ctor ACT:S) |
| WK-SYS0013-0029 | G5 | SCM0005_DynamicQueryListPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCM0005_DynamicQueryListPopUp | 판단불가(대상 단위 POPUP) | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0030 | H6 | SCM0005_DynamicQueryListPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCM0005_DynamicQueryListPopUp | 판단불가(대상 단위 POPUP) | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |

## W6 검증 실행 (103)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0013-0031 | J2 | SYS0013 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SYS0013 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 26 (1.1 1.2 1.3 1.4 1.5 1.6 2.2 2.4 2.5 2.6 ) |
| WK-SYS0013-0032 | C1 | clbRole / Role | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbRole / Role · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0033 | C1 | clbRoleResult / Role / Role Result | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbRoleResult / Role / Role Result · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0034 | C3 | COMUMNS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMUMNS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0035 | C3 | DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0036 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0037 | C3 | DQ_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DQ_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0038 | C3 | DQ_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DQ_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0039 | C3 | PARAMETERS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PARAMETERS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0040 | C3 | POPUPFLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — POPUPFLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0041 | C3 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — QUERY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0042 | C3 | ROLE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ROLE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0043 | C3 | ROLE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ROLE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0044 | K4 | SYS0013 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SYS0013 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 15 (ACT:SCM0005_DynamicQueryListPopUp.btnBut) |
| WK-SYS0013-0045 | F1 | SYS0013 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0013 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 110 (1.4 1.6 2.5 2.8 ACT:SCM0005_DynamicQuery) |
| WK-SYS0013-0046 | F5 | SYS0013 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0013 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (1.4 2.5 ACT:SCM0005_DynamicQueryList.Del) |
| WK-SYS0013-0047 | F4 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 65 (ACT:SCM0005_DynamicQueryList.GroupData:6) |
| WK-SYS0013-0048 | F4 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 279 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0049 | F4 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 215 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0050 | F4 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 65 (ACT:SCM0005_DynamicQueryList.ParameterDa) |
| WK-SYS0013-0051 | A5 | ADMIN_ONLY_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ADMIN_ONLY_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0052 | A5 | COMUMNS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COMUMNS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0053 | A5 | CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0054 | A5 | CREATION_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATION_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0055 | A5 | DESC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DESC · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0056 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0057 | A5 | DQ_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DQ_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0058 | A5 | DQ_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DQ_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0059 | A5 | LAST_UPDATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0060 | A5 | LAST_UPDATE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0061 | A5 | PARAMETERS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PARAMETERS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0062 | A5 | POPUPFLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — POPUPFLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0063 | A5 | QUERY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — QUERY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0064 | A5 | ROLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ROLE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0065 | A5 | ROLE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ROLE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0066 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0067 | G4 | clbRole / Role | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbRole / Role · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0068 | G4 | clbRoleResult / Role / Role Result | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbRoleResult / Role / Role Result · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0069 | G4 | txtDescription / Description | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtDescription / Description · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0070 | G4 | txtReportName / Role / Report Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtReportName / Role / Report Name · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0071 | H5 | ADMIN_ONLY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ADMIN_ONLY_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0072 | H5 | COMUMNS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COMUMNS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0073 | H5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0074 | H5 | CREATION_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATION_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0075 | H5 | DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DESC · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0076 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0077 | H5 | DQ_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DQ_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0078 | H5 | DQ_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DQ_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0079 | H5 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0080 | H5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0081 | H5 | PARAMETERS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PARAMETERS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0082 | H5 | POPUPFLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — POPUPFLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0083 | H5 | QUERY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — QUERY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0084 | H5 | ROLE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ROLE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0085 | H5 | ROLE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ROLE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0086 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0087 | I1 | SYS0013 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0013 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 5 (1.4 ① SQL 사전검증+컬럼 자동추출 ACT:SCM0005_Dynam) |
| WK-SYS0013-0088 | D1 | ADMIN_ONLY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ADMIN_ONLY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCM0005_DynamicQueryList.EditButton:) |
| WK-SYS0013-0089 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.EditButton ) |
| WK-SYS0013-0090 | D1 | ROLE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ROLE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.EditButton ) |
| WK-SYS0013-0091 | D3 | ADMIN_ONLY_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ADMIN_ONLY_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCM0005_DynamicQueryList.EditButton:) |
| WK-SYS0013-0092 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.EditButton ) |
| WK-SYS0013-0093 | D3 | ROLE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ROLE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.EditButton ) |
| WK-SYS0013-0094 | D4 | ADMIN_ONLY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ADMIN_ONLY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (1.3) |
| WK-SYS0013-0095 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (1.3) |
| WK-SYS0013-0096 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0097 | D6 | SYS0013 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0013 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (1.3 2.4 ACT:SCM0005_DynamicQueryList.Ins) |
| WK-SYS0013-0098 | E4 | DESC | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESC · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0099 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0100 | E4 | DQ_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DQ_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0101 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0005_DynamicQueryList.SaveData:92) |
| WK-SYS0013-0102 | E4 | MSG00148 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00148 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (① SQL 사전검증+컬럼 자동추출 ACT:SCM0005_DynamicQu) |
| WK-SYS0013-0103 | E4 | MSG00654 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00654 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (1.4) |
| WK-SYS0013-0104 | E4 | MSG00655 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00655 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (① SQL 사전검증+컬럼 자동추출) |
| WK-SYS0013-0105 | E4 | QUERY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — QUERY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0106 | E4 | ROLE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ROLE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0107 | E4 | clbRole / Role | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbRole / Role · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0108 | E4 | clbRoleResult / Role / Role Result | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbRoleResult / Role / Role Result · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0109 | E4 | txtDescription / Description | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtDescription / Description · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정)  |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0110 | E4 | txtDescrptionResult / Description / Desc | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtDescrptionResult / Description / Descrption Res · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0111 | E4 | txtReportName / Role / Report Name | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReportName / Role / Report Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0112 | A10 | SYS0013 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0013 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 91 (ACT:SCM0005_DynamicQueryList.DefinePrope) |
| WK-SYS0013-0113 | A6 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 61 (ACT:SCM0005_DynamicQueryListPopUp.FindDa) |
| WK-SYS0013-0114 | A6 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 179 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0115 | A6 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 115 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0116 | A6 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 61 (ACT:SCM0005_DynamicQueryListPopUp.FindDa) |
| WK-SYS0013-0117 | G1 | clbRole / Role | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbRole / Role · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (ACT:SCM0005_DynamicQueryList.FindData AC) |
| WK-SYS0013-0118 | G1 | txtDescription / Description | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDescription / Description · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (ACT:SCM0005_DynamicQueryList.FindData AC) |
| WK-SYS0013-0119 | G1 | txtReportName / Role / Report Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtReportName / Role / Report Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SCM0005_DynamicQueryListPopUp.FindDa) |
| WK-SYS0013-0120 | G6 | clbRole / Role | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbRole / Role · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0121 | G6 | clbRoleResult / Role / Role Result | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbRoleResult / Role / Role Result · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0122 | X-REOPEN | SYS0013 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0013 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 21 (ACT:SCM0005_DynamicQueryList.Dispose ACT) |
| WK-SYS0013-0123 | M3 | SCM0005_DynamicQueryListPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCM0005_DynamicQueryListPopUp · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 24 (ACT:SCM0005_DynamicQueryListPopUp..ctor ) |
| WK-SYS0013-0124 | M4 | COMUMNS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COMUMNS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0125 | M4 | DESC | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DESC · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0126 | M4 | DQ_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DQ_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0127 | M4 | DQ_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DQ_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0128 | M4 | PARAMETERS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PARAMETERS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0129 | M4 | POPUPFLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — POPUPFLAG · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0130 | M4 | QUERY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — QUERY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0131 | M4 | ROLE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ROLE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0132 | M4 | ROLE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ROLE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0133 | M4 | SCM0005_DynamicQueryListPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM0005_DynamicQueryListPopUp · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |

## W7 기대값 확정 (130)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0013-0134 | C1 | 1.11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 1.11: 행 집계 — C1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (1.11) |
| WK-SYS0013-0135 | C3 | 2.11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 2.11: 행 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.11) |
| WK-SYS0013-0136 | C3 | 2.12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 2.12: 행 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.12) |
| WK-SYS0013-0137 | C3 | SCM0005_DynamicQueryList.DsdmGroup_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM0005_DynamicQueryList.DsdmGroup_Changed: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0005_DynamicQueryList.DsdmGroup_C) |
| WK-SYS0013-0138 | C3 | SCM0005_DynamicQueryList.DsdmWhere_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM0005_DynamicQueryList.DsdmWhere_Changed: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0005_DynamicQueryList.DsdmWhere_C) |
| WK-SYS0013-0139 | C3 | SCM0005_DynamicQueryList.Setting_ViewTab | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM0005_DynamicQueryList.Setting_ViewTab: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0140 | DB-SYN | SCM0005_DynamicQueryListPopUp.mSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0005_DynamicQueryListPopUp.mSave: 진입점 집계 — DB-SYN 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.mSave:) |
| WK-SYS0013-0141 | F4 | SCM0005_DynamicQueryList.FindData_Result | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0005_DynamicQueryList.FindData_Result: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCM0005_DynamicQueryList.FindData_Re) |
| WK-SYS0013-0142 | F4 | SCM0005_DynamicQueryListPopUp.mSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0005_DynamicQueryListPopUp.mSave: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.mSave:) |
| WK-SYS0013-0143 | A5 | 1.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1.10: 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (1.10) |
| WK-SYS0013-0144 | A5 | 1.9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1.9: 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (1.9) |
| WK-SYS0013-0145 | A5 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2.4: 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0146 | A5 | 2.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2.5: 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (2.5) |
| WK-SYS0013-0147 | A5 | SCM0005_DynamicQueryList.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCM0005_DynamicQueryList.CreateSpread: 진입점 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCM0005_DynamicQueryList.CreateSprea) |
| WK-SYS0013-0148 | H5 | 1.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1.10: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (1.10) |
| WK-SYS0013-0149 | H5 | 1.9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1.9: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (1.9) |
| WK-SYS0013-0150 | H5 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2.4: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0151 | H5 | 2.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2.5: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (2.5) |
| WK-SYS0013-0152 | H5 | SCM0005_DynamicQueryList.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCM0005_DynamicQueryList.CreateSpread: 진입점 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCM0005_DynamicQueryList.CreateSprea) |
| WK-SYS0013-0153 | X-REASON | 1.8 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 1.8 fpGroup_CellDoubleClick (L1122) 미구현 — AS-IS 원본이 무동작(빈 핸들러) 해당없음(원본 no-op) |  | 1 (1.8) |
| WK-SYS0013-0154 | X-REASON | 2.3 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 2.3 FindButton (L193) AS-IS 원본 무동작 해당없음(원본 no-op) |  | 1 (2.3) |
| WK-SYS0013-0155 | X-REASON | 2.9 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 2.9 fpWhere_CellDoubleClick (L707) AS-IS 원본 무동작 해당없음(원본 no-op) |  | 1 (2.9) |
| WK-SYS0013-0156 | D1 | 1.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 1.5: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1.5) |
| WK-SYS0013-0157 | D1 | 2.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2.2: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2.2) |
| WK-SYS0013-0158 | D1 | 2.6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2.6: 행 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2.6) |
| WK-SYS0013-0159 | D1 | SCM0005_DynamicQueryList.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCM0005_DynamicQueryList.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0005_DynamicQueryList.EditButton:) |
| WK-SYS0013-0160 | D3 | 1.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1.5: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1.5) |
| WK-SYS0013-0161 | D3 | 2.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2.2: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2.2) |
| WK-SYS0013-0162 | D3 | 2.6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2.6: 행 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (2.6) |
| WK-SYS0013-0163 | D3 | SCM0005_DynamicQueryList.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCM0005_DynamicQueryList.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0005_DynamicQueryList.EditButton:) |
| WK-SYS0013-0164 | D4 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 2.4: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0165 | D5 | SCM0005_DynamicQueryList.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCM0005_DynamicQueryList.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCM0005_DynamicQueryList.CreateSprea) |
| WK-SYS0013-0166 | E4 | 2.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2.10: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (2.10) |
| WK-SYS0013-0167 | E4 | 2.8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2.8: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (2.8) |
| WK-SYS0013-0168 | E4 | SCM0005_DynamicQueryList.Setting_ViewTab | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0005_DynamicQueryList.Setting_ViewTab: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0169 | A1 | 1.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1.1: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (1.1) |
| WK-SYS0013-0170 | A1 | 1.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1.2: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (1.2) |
| WK-SYS0013-0171 | A1 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS: 골든 비교 케이스 없음(DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS — 팝업·보조 SP 는 golden_ca |  | 63 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0172 | A1 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST: 골든 비교 케이스 없음(DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST — 팝업·보조 SP 는 golden_cases.cs |  | 179 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0173 | A1 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2: 골든 비교 케이스 없음(DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 — 팝업·보조 SP 는 golden_cases. |  | 115 (ACT:SCM0005_DynamicQueryList.FindButton ) |
| WK-SYS0013-0174 | A1 | DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS: 골든 비교 케이스 없음(DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS — 팝업·보조 SP 는 gol |  | 63 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0175 | A1 | SCM0005_DynamicQueryList.FindData_Result | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0005_DynamicQueryList.FindData_Result: 진입점 집계 — A1 4요소: REVIEW:4 |  | 21 (ACT:SCM0005_DynamicQueryList.FindData_Re) |
| WK-SYS0013-0176 | A6 | SCM0005_DynamicQueryList.FindData_Result | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0005_DynamicQueryList.FindData_Result: 진입점 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCM0005_DynamicQueryList.FindData_Re) |
| WK-SYS0013-0177 | G1 | 1.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1.1: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1.1) |
| WK-SYS0013-0178 | G1 | 1.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1.2: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1.2) |
| WK-SYS0013-0179 | G1 | SCM0005_DynamicQueryList.FindData_Result | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM0005_DynamicQueryList.FindData_Result: 진입점 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCM0005_DynamicQueryList.FindData_Re) |
| WK-SYS0013-0180 | X-LOC | ① SQL 사전검증+컬럼 자동추출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ① SQL 사전검증+컬럼 자동추출: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (① SQL 사전검증+컬럼 자동추출) |
| WK-SYS0013-0181 | X-LOC | ② 실행이력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ② 실행이력: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (② 실행이력) |
| WK-SYS0013-0182 | X-ROW | SCM0005_DynamicQueryList.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.CreateSpread: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0005_DynamicQueryList.CreateSprea) |
| WK-SYS0013-0183 | X-ROW | SCM0005_DynamicQueryList.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryList.DefinePrope) |
| WK-SYS0013-0184 | X-ROW | SCM0005_DynamicQueryList.DsdmGroup_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.DsdmGroup_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryList.DsdmGroup_C) |
| WK-SYS0013-0185 | X-ROW | SCM0005_DynamicQueryList.DsdmWhere_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.DsdmWhere_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryList.DsdmWhere_C) |
| WK-SYS0013-0186 | X-ROW | SCM0005_DynamicQueryList.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCM0005_DynamicQueryList.FindButton) |
| WK-SYS0013-0187 | X-ROW | SCM0005_DynamicQueryList.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.FindData: 진입점 집계 11검사 — NOT_RUN:7 · REVIEW:2 · NOPATH:2 |  | 16 (ACT:SCM0005_DynamicQueryList.FindData:33) |
| WK-SYS0013-0188 | X-ROW | SCM0005_DynamicQueryList.FindData_Result | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.FindData_Result: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0005_DynamicQueryList.FindData_Re) |
| WK-SYS0013-0189 | X-ROW | SCM0005_DynamicQueryList.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0005_DynamicQueryList.Form_Load) |
| WK-SYS0013-0190 | X-ROW | SCM0005_DynamicQueryList.GroupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.GroupData: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCM0005_DynamicQueryList.GroupData A) |
| WK-SYS0013-0191 | X-ROW | SCM0005_DynamicQueryList.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryList.InitControl) |
| WK-SYS0013-0192 | X-ROW | SCM0005_DynamicQueryList.InitSpread_Grou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InitSpread_Group: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0193 | X-ROW | SCM0005_DynamicQueryList.InitSpread_Regi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InitSpread_Register: 진입점 집계 33검사 — NOT_RUN:33 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0194 | X-ROW | SCM0005_DynamicQueryList.InitSpread_Resu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InitSpread_Result: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0195 | X-ROW | SCM0005_DynamicQueryList.InitSpread_Wher | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InitSpread_Where: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0005_DynamicQueryList.InitSpread_) |
| WK-SYS0013-0196 | X-ROW | SCM0005_DynamicQueryList.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0005_DynamicQueryList.InsertButto) |
| WK-SYS0013-0197 | X-ROW | SCM0005_DynamicQueryList.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.InsertRow: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCM0005_DynamicQueryList.InsertRow A) |
| WK-SYS0013-0198 | X-ROW | SCM0005_DynamicQueryList.ParameterData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.ParameterData: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCM0005_DynamicQueryList.ParameterDa) |
| WK-SYS0013-0199 | X-ROW | SCM0005_DynamicQueryList.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.SaveData: 진입점 집계 10검사 — NOT_RUN:6 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0005_DynamicQueryList.SaveData:78) |
| WK-SYS0013-0200 | X-ROW | SCM0005_DynamicQueryList.Setting_ViewTab | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.Setting_ViewTab: 진입점 집계 20검사 — NOT_RUN:13 · REVIEW:4 · NOPATH:3 |  | 17 (ACT:SCM0005_DynamicQueryList.Setting_Vie) |
| WK-SYS0013-0201 | X-ROW | SCM0005_DynamicQueryList.Substitute | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.Substitute: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 27 (ACT:SCM0005_DynamicQueryList.Substitute ) |
| WK-SYS0013-0202 | X-ROW | SCM0005_DynamicQueryList.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryList.spdMain_CellDoubleClick: 진입점 집계 33검사 — NOT_RUN:28 · REVIEW:3 · NOPATH:2 |  | 17 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0203 | X-ROW | SCM0005_DynamicQueryListPopUp..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp..ctor:) |
| WK-SYS0013-0204 | X-ROW | SCM0005_DynamicQueryListPopUp.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.CreateSpread: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCM0005_DynamicQueryListPopUp.Create) |
| WK-SYS0013-0205 | X-ROW | SCM0005_DynamicQueryListPopUp.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.Define) |
| WK-SYS0013-0206 | X-ROW | SCM0005_DynamicQueryListPopUp.DeleteButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.DeleteButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.Delete) |
| WK-SYS0013-0207 | X-ROW | SCM0005_DynamicQueryListPopUp.Delete_But | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.Delete_Button: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0005_DynamicQueryListPopUp.Delete) |
| WK-SYS0013-0208 | X-ROW | SCM0005_DynamicQueryListPopUp.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.Dispos) |
| WK-SYS0013-0209 | X-ROW | SCM0005_DynamicQueryListPopUp.Dsdm_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.Dsdm_Changed: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.Dsdm_C) |
| WK-SYS0013-0210 | X-ROW | SCM0005_DynamicQueryListPopUp.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.EditButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCM0005_DynamicQueryListPopUp.EditBu) |
| WK-SYS0013-0211 | X-ROW | SCM0005_DynamicQueryListPopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.FindData: 진입점 집계 20검사 — NOT_RUN:14 · REVIEW:3 · NOPATH:3 |  | 62 (ACT:SCM0005_DynamicQueryListPopUp.FindDa) |
| WK-SYS0013-0212 | X-ROW | SCM0005_DynamicQueryListPopUp.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCM0005_DynamicQueryListPopUp.Form_L) |
| WK-SYS0013-0213 | X-ROW | SCM0005_DynamicQueryListPopUp.GroupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.GroupData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryListPopUp.GroupD) |
| WK-SYS0013-0214 | X-ROW | SCM0005_DynamicQueryListPopUp.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.InitCo) |
| WK-SYS0013-0215 | X-ROW | SCM0005_DynamicQueryListPopUp.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.InitSpread_Group: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryListPopUp.InitSp) |
| WK-SYS0013-0216 | X-ROW | SCM0005_DynamicQueryListPopUp.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.InitSpread_Where: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryListPopUp.InitSp) |
| WK-SYS0013-0217 | X-ROW | SCM0005_DynamicQueryListPopUp.InsertButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0005_DynamicQueryListPopUp.Insert) |
| WK-SYS0013-0218 | X-ROW | SCM0005_DynamicQueryListPopUp.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.InsertRow: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCM0005_DynamicQueryListPopUp.Insert) |
| WK-SYS0013-0219 | X-ROW | SCM0005_DynamicQueryListPopUp.LoadData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.LoadDa) |
| WK-SYS0013-0220 | X-ROW | SCM0005_DynamicQueryListPopUp.ParameterD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.ParameterData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryListPopUp.Parame) |
| WK-SYS0013-0221 | X-ROW | SCM0005_DynamicQueryListPopUp.SetItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.SetItem: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 33 (ACT:SCM0005_DynamicQueryListPopUp.SetIte) |
| WK-SYS0013-0222 | X-ROW | SCM0005_DynamicQueryListPopUp.btnButtonL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.btnButtonList_UsrBut: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCM0005_DynamicQueryListPopUp.btnBut) |
| WK-SYS0013-0223 | X-ROW | SCM0005_DynamicQueryListPopUp.fpWhere_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.fpWhere_CellDoubleCl: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0005_DynamicQueryListPopUp.fpWher) |
| WK-SYS0013-0224 | X-ROW | SCM0005_DynamicQueryListPopUp.fpWhere_Co | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.fpWhere_ComboSelChan: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0005_DynamicQueryListPopUp.fpWher) |
| WK-SYS0013-0225 | X-ROW | SCM0005_DynamicQueryListPopUp.mSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.mSave: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCM0005_DynamicQueryListPopUp.mSave ) |
| WK-SYS0013-0226 | X-ROW | SCM0005_DynamicQueryListPopUp.spdMain_Co | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0005_DynamicQueryListPopUp.spdMain_ComboSelChan: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0005_DynamicQueryListPopUp.spdMai) |
| WK-SYS0013-0227 | X-ROW | ② 실행이력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ② 실행이력: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (② 실행이력) |
| WK-SYS0013-0228 | G5 | 1.7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 1.7: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (1.7) |
| WK-SYS0013-0229 | G5 | 2.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.1: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.1) |
| WK-SYS0013-0230 | G5 | 2.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.10: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.10) |
| WK-SYS0013-0231 | G5 | 2.11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.11: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.11) |
| WK-SYS0013-0232 | G5 | 2.12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.12: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.12) |
| WK-SYS0013-0233 | G5 | 2.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.2: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.2) |
| WK-SYS0013-0234 | G5 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.4: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0235 | G5 | 2.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.5: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.5) |
| WK-SYS0013-0236 | G5 | 2.6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.6: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.6) |
| WK-SYS0013-0237 | G5 | 2.8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 2.8: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.8) |
| WK-SYS0013-0238 | G5 | SCM0005_DynamicQueryList.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0005_DynamicQueryList.spdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0239 | G5 | ① SQL 사전검증+컬럼 자동추출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ① SQL 사전검증+컬럼 자동추출: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (① SQL 사전검증+컬럼 자동추출) |
| WK-SYS0013-0240 | H6 | 1.7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 1.7: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (1.7) |
| WK-SYS0013-0241 | H6 | 2.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.1: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.1) |
| WK-SYS0013-0242 | H6 | 2.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.10: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.10) |
| WK-SYS0013-0243 | H6 | 2.11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.11: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.11) |
| WK-SYS0013-0244 | H6 | 2.12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.12: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.12) |
| WK-SYS0013-0245 | H6 | 2.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.2: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.2) |
| WK-SYS0013-0246 | H6 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.4: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0247 | H6 | 2.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.5: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.5) |
| WK-SYS0013-0248 | H6 | 2.6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.6: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.6) |
| WK-SYS0013-0249 | H6 | 2.8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 2.8: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2.8) |
| WK-SYS0013-0250 | H6 | SCM0005_DynamicQueryList.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0005_DynamicQueryList.spdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0251 | H6 | ① SQL 사전검증+컬럼 자동추출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ① SQL 사전검증+컬럼 자동추출: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (① SQL 사전검증+컬럼 자동추출) |
| WK-SYS0013-0252 | M4 | 1.7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 1.7: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (1.7) |
| WK-SYS0013-0253 | M4 | 2.1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.1: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.1) |
| WK-SYS0013-0254 | M4 | 2.10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.10: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.10) |
| WK-SYS0013-0255 | M4 | 2.11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.11: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.11) |
| WK-SYS0013-0256 | M4 | 2.12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.12: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.12) |
| WK-SYS0013-0257 | M4 | 2.2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.2: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.2) |
| WK-SYS0013-0258 | M4 | 2.4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.4: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.4) |
| WK-SYS0013-0259 | M4 | 2.5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.5: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.5) |
| WK-SYS0013-0260 | M4 | 2.6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.6: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.6) |
| WK-SYS0013-0261 | M4 | 2.8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2.8: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2.8) |
| WK-SYS0013-0262 | M4 | SCM0005_DynamicQueryList.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0005_DynamicQueryList.spdMain_CellDoubleClick: 진입점 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0005_DynamicQueryList.spdMain_Cel) |
| WK-SYS0013-0263 | M4 | ① SQL 사전검증+컬럼 자동추출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ① SQL 사전검증+컬럼 자동추출: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (① SQL 사전검증+컬럼 자동추출) |
