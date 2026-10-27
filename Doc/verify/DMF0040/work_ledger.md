# 작업 원장 — DMF0040 · 2026-10-26 12:50

> 검사 인스턴스 585건 중 PASS·NA 151건 외 **434건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 7 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 28 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 108 | 실행 → PASS |
| W7 | 기대값 확정 | 287 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 271 · E2E 108 · 하네스 32 · 대조표 23
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 14건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 86 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 14 | 14 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 1 | 13 | 9 |  |  | 조회조건 표시·라벨·활성 |
| E4 | EDIT |  |  |  |  |  | 18 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G6 | GEN |  |  |  |  |  | 13 | 9 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 9 | 12 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A1 | GEN |  |  |  |  |  |  | 21 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  | 4 |  | 15 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 4 |  |  | 14 |  |  | 콤보 후보 정렬 = AS-IS |
| F4 | DB |  |  |  |  |  | 12 | 6 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C3 | CASCADE |  |  |  |  |  | 1 | 16 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 2 | 14 |  |  | 배경·글자색 규칙 |
| X-REASON | DESIGN |  |  |  |  |  |  | 16 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| DB-SYN | DB |  |  |  |  | 8 |  | 6 |  |  | BE 계정 시노님·권한·대상 객체 |
| H5 | DESIGN |  |  |  |  |  | 4 | 10 |  |  | 라벨 명칭 |
| X-LOC | GEN |  | 7 |  |  |  |  | 6 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  | 2 | 11 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G5 | POPUP |  |  |  |  | 7 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 6 | 1 | 4 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 6 | 4 |  |  | 팝업 선택값 반영 |
| A6 | GEN |  |  |  |  |  | 2 | 5 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0040-0001 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-DMF0040-0002 | X-LOC | E13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E13) |
| WK-DMF0040-0003 | X-LOC | HANDLER:ExcelButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0040-0004 | X-LOC | HANDLER:spdMain_KeyUp | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0040-0005 | X-LOC | REQ:CHAT-20260828-UM05-DMF0040 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM05-DMF0040) |
| WK-DMF0040-0006 | X-LOC | REQ:CHAT-20260828-UM08-DMF0040 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM08-DMF0040) |
| WK-DMF0040-0007 | X-LOC | UM-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: data-grid/DataGrid.tsx 없음 |  | 1 (UM-06) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0040-0008 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:DMF0040_MktFcst_Comparison.GetSpdTit) |
| WK-DMF0040-0009 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 4 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0010 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 7 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0011 | B3 | txtVersion / Version | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtVersion / Version | 있음(FE 소스) | 2 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |

## W5 검사기 연결 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0040-0012 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:DMF0040_MktFcst_Comparison.GetSpdTit) |
| WK-DMF0040-0013 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 4 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0014 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 7 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0015 | B4 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 2 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0016 | F2 | DMF0040 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0040 화면 | 판단불가(대상 단위 SCREEN) | 2 (E16 COMMON:UC-03) |
| WK-DMF0040-0017 | DB-SYN | DMF0003_GET_QTY_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_QTY_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetQtyDat) |
| WK-DMF0040-0018 | DB-SYN | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetBucket) |
| WK-DMF0040-0019 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetBizTyp) |
| WK-DMF0040-0020 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetCustom) |
| WK-DMF0040-0021 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetItemTy) |
| WK-DMF0040-0022 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetPlantS) |
| WK-DMF0040-0023 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetScmSit) |
| WK-DMF0040-0024 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0040_MktFcst_Comparison.GetTeamby) |
| WK-DMF0040-0025 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0026 | G03-WIRE | DMF0040 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0040 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:DMF0040_MktFcst_Comparison..ctor ACT) |
| WK-DMF0040-0027 | G5 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL C | 있음(FE 소스) | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0028 | G5 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL D | 있음(FE 소스) | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0029 | G5 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL P | 있음(FE 소스) | 1 (P-03) |
| WK-DMF0040-0030 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 1 (E15) |
| WK-DMF0040-0031 | G5 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnOwner | 없음 | 1 (E21) |
| WK-DMF0040-0032 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 없음 | 1 (E14) |
| WK-DMF0040-0033 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0040_MktFcst_Comparison.btnColumn) |
| WK-DMF0040-0034 | H6 | C | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL C | 있음(FE 소스) | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0035 | H6 | D | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL D | 있음(FE 소스) | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0036 | H6 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL P | 있음(FE 소스) | 1 (P-03) |
| WK-DMF0040-0037 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 1 (E15) |
| WK-DMF0040-0038 | H6 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnOwner | 없음 | 1 (E21) |
| WK-DMF0040-0039 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 없음 | 1 (E14) |

## W6 검증 실행 (108)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0040-0040 | J2 | DMF0040 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0040 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 85 (E02-2 E09 E11 E16 A-01 MODAL:ComparisonV) |
| WK-DMF0040-0041 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0042 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0043 | C1 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0044 | C1 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0045 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0046 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0047 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0048 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0049 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0050 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.SetAmount) |
| WK-DMF0040-0051 | G3 | DMF0040 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0040 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0040-0052 | K4 | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 72 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0040-0053 | F1 | DMF0040 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0040 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 2 (E16 COMMON:UC-03) |
| WK-DMF0040-0054 | F3 | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (E13) |
| WK-DMF0040-0055 | F4 | DMF0003_GET_QTY_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_QTY_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetQtyDat) |
| WK-DMF0040-0056 | F4 | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_REPORT_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetBucket) |
| WK-DMF0040-0057 | F4 | PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 105 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0058 | F4 | PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 104 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0059 | F4 | PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0060 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetBizTyp) |
| WK-DMF0040-0061 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetCustom) |
| WK-DMF0040-0062 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetDivisi) |
| WK-DMF0040-0063 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetItemTy) |
| WK-DMF0040-0064 | F4 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetPlantS) |
| WK-DMF0040-0065 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetScmSit) |
| WK-DMF0040-0066 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetTeamby) |
| WK-DMF0040-0067 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0068 | A5 | D | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — D · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0069 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 14 (ACT:DMF0040_MktFcst_Comparison.DefinePro) |
| WK-DMF0040-0070 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0071 | G4 | cboQTY / QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboQTY / QTY · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0072 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0073 | G4 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0074 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0075 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0076 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0077 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0078 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0079 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData:) |
| WK-DMF0040-0080 | G4 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0081 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0082 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0083 | H2 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — D · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0084 | H4 | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (E12 HANDLER:spdMain_TopChange ACT:DMF004) |
| WK-DMF0040-0085 | H5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — C · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0086 | H5 | D | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — D · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0087 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 26 (ACT:DMF0040_MktFcst_Comparison.InitSprea) |
| WK-DMF0040-0088 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (ACT:DMF0040_MktFcst_Comparison.InitSprea) |
| WK-DMF0040-0089 | I1 | DMF0040 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0040 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 11 (A-01 A-02 A-03 P-02 MODAL:ComparisonVers) |
| WK-DMF0040-0090 | SC1 | DMF0040 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0040 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 9 (MODAL:ComparisonVersionModal COMMON:UC-0) |
| WK-DMF0040-0091 | D6 | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (E11 COMMON:UC-03) |
| WK-DMF0040-0092 | E4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MODAL:ComparisonVersionModal ACT:DMF0040) |
| WK-DMF0040-0093 | E4 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — D · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0094 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (A-01 ACT:DMF0040_MktFcst_Comparison.Find) |
| WK-DMF0040-0095 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (A-02 ACT:DMF0040_MktFcst_Comparison.Find) |
| WK-DMF0040-0096 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0040_MktFcst_Comparison.EditButto) |
| WK-DMF0040-0097 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (A-03 ACT:DMF0040_MktFcst_Comparison.Find) |
| WK-DMF0040-0098 | E4 | MSG00255 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00255 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (P-02 MODAL:ComparisonVersionModal ACT:DM) |
| WK-DMF0040-0099 | E4 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — P · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-02) |
| WK-DMF0040-0100 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0101 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0102 | E4 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetAmount) |
| WK-DMF0040-0103 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0104 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0105 | E4 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0106 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (A-03 ACT:DMF0040_MktFcst_Comparison.Find) |
| WK-DMF0040-0107 | E4 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0108 | E4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0109 | E4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (G-01) |
| WK-DMF0040-0110 | A10 | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 82 (ACT:DMF0040_MktFcst_Comparison.DefinePro) |
| WK-DMF0040-0111 | A6 | PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 105 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0112 | A6 | PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 102 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0113 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0114 | G1 | cboDiff / . / Diff | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDiff / . / Diff · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0115 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0116 | G1 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBizType / Biz Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0117 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0118 | G1 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbItemType / Item Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0119 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0120 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0121 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0122 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0123 | G1 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0124 | G1 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtOwner / Owner · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0125 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0126 | G1 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.FindData ) |
| WK-DMF0040-0127 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 14 (ACT:DMF0040_MktFcst_Comparison.DefinePro) |
| WK-DMF0040-0128 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 10 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0129 | G6 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0130 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0131 | G6 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0132 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0133 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0134 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0135 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0136 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0137 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0138 | G6 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0139 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0140 | X-REOPEN | DMF0040 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0040 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 17 (ACT:DMF0040_MktFcst_Comparison.Dispose A) |
| WK-DMF0040-0141 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0040_MktFcst_Comparison.btnColumn) |
| WK-DMF0040-0142 | M4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0143 | M4 | D | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — D · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0144 | M4 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — P · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (P-03) |
| WK-DMF0040-0145 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E15) |
| WK-DMF0040-0146 | M4 | btnOwner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnOwner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E21) |
| WK-DMF0040-0147 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E14) |

## W7 기대값 확정 (287)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0040-0148 | C1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E02: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0040-0149 | C1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E03: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0040-0150 | C1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E04: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0040-0151 | C1 | E09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E09: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E09) |
| WK-DMF0040-0152 | C1 | E18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E18: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E18) |
| WK-DMF0040-0153 | C1 | HANDLER:cboBucketType_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboBucketType_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboBucketType_SelectedIndexChang) |
| WK-DMF0040-0154 | C1 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-DMF0040-0155 | C1 | HANDLER:cboQTY_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboQTY_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboQTY_SelectedIndexChanged) |
| WK-DMF0040-0156 | C1 | HANDLER:chkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:chkSum_CheckedChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:chkSum_CheckedChanged) |
| WK-DMF0040-0157 | C1 | HANDLER:clbCustomer_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0040-0158 | C1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0040-0159 | C1 | UM-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — UM-03: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (UM-03) |
| WK-DMF0040-0160 | C3 | DMF0040_MktFcst_Comparison.ClbPlantSite_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.ClbPlantSite_SelectedIn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.ClbPlantS) |
| WK-DMF0040-0161 | C3 | DMF0040_MktFcst_Comparison.ClbSalesSite_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.ClbSalesSite_SelectedIn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.ClbSalesS) |
| WK-DMF0040-0162 | C3 | DMF0040_MktFcst_Comparison.SetAmountCalc | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.SetAmountCalculating: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0040_MktFcst_Comparison.SetAmount) |
| WK-DMF0040-0163 | C3 | DMF0040_MktFcst_Comparison.SetChangeCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0040_MktFcst_Comparison.SetChange) |
| WK-DMF0040-0164 | C3 | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0165 | C3 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0166 | C3 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0167 | C3 | DMF0040_MktFcst_Comparison.TxtProject_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.TxtProject_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.TxtProjec) |
| WK-DMF0040-0168 | C3 | DMF0040_MktFcst_Comparison.cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.cboBucketType_SelectedI: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0040_MktFcst_Comparison.cboBucket) |
| WK-DMF0040-0169 | C3 | DMF0040_MktFcst_Comparison.cboDivision_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.cboDivision_SelectedInd: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 33 (ACT:DMF0040_MktFcst_Comparison.cboDivisi) |
| WK-DMF0040-0170 | C3 | DMF0040_MktFcst_Comparison.cboQTY_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.cboQTY_SelectedIndexCha: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.cboQTY_Se) |
| WK-DMF0040-0171 | C3 | DMF0040_MktFcst_Comparison.chkSum_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.chkSum_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.chkSum_Ch) |
| WK-DMF0040-0172 | C3 | DMF0040_MktFcst_Comparison.clbCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.clbCustomer_SelectedInd: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0040_MktFcst_Comparison.clbCustom) |
| WK-DMF0040-0173 | C3 | DMF0040_MktFcst_Comparison.clbTeam_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.clbTeam_SelectedIndexCh: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0040_MktFcst_Comparison.clbTeam_S) |
| WK-DMF0040-0174 | C3 | DMF0040_MktFcst_Comparison.spdMain_Combo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_ComboSelChange: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0175 | C3 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E13: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E13) |
| WK-DMF0040-0176 | B3 | DMF0040_MktFcst_Comparison.GetBizTypebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetBizTypebyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetBizTyp) |
| WK-DMF0040-0177 | B3 | DMF0040_MktFcst_Comparison.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetBucketType: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetBucket) |
| WK-DMF0040-0178 | B3 | DMF0040_MktFcst_Comparison.GetCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetCustomerbyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.GetCustom) |
| WK-DMF0040-0179 | B3 | DMF0040_MktFcst_Comparison.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetDayRange: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.GetDayRan) |
| WK-DMF0040-0180 | B3 | DMF0040_MktFcst_Comparison.GetDefaultVer | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetDefaultVersion: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0181 | B3 | DMF0040_MktFcst_Comparison.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetDivisi) |
| WK-DMF0040-0182 | B3 | DMF0040_MktFcst_Comparison.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetItemType: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetItemTy) |
| WK-DMF0040-0183 | B3 | DMF0040_MktFcst_Comparison.GetLastWeekSu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetLastWeekSunDayByDate: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0040_MktFcst_Comparison.GetLastWe) |
| WK-DMF0040-0184 | B3 | DMF0040_MktFcst_Comparison.GetPlantSiteb | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetPlantSitebyEndCustom: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.GetPlantS) |
| WK-DMF0040-0185 | B3 | DMF0040_MktFcst_Comparison.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetQtyData: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetQtyDat) |
| WK-DMF0040-0186 | B3 | DMF0040_MktFcst_Comparison.GetScmSitebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetScmSitebyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.GetScmSit) |
| WK-DMF0040-0187 | B3 | DMF0040_MktFcst_Comparison.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetSpdTit) |
| WK-DMF0040-0188 | B3 | DMF0040_MktFcst_Comparison.GetTeambyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetTeambyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetTeamby) |
| WK-DMF0040-0189 | B3 | DMF0040_MktFcst_Comparison.GetThisWeekMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0040_MktFcst_Comparison.GetThisWeekMonday: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0040_MktFcst_Comparison.GetThisWe) |
| WK-DMF0040-0190 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0040-0191 | B4 | DMF0040_MktFcst_Comparison.GetBizTypebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetBizTypebyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetBizTyp) |
| WK-DMF0040-0192 | B4 | DMF0040_MktFcst_Comparison.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetBucketType: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetBucket) |
| WK-DMF0040-0193 | B4 | DMF0040_MktFcst_Comparison.GetCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetCustomerbyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.GetCustom) |
| WK-DMF0040-0194 | B4 | DMF0040_MktFcst_Comparison.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetDayRange: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.GetDayRan) |
| WK-DMF0040-0195 | B4 | DMF0040_MktFcst_Comparison.GetDefaultVer | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetDefaultVersion: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0196 | B4 | DMF0040_MktFcst_Comparison.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetDivisi) |
| WK-DMF0040-0197 | B4 | DMF0040_MktFcst_Comparison.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetItemType: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetItemTy) |
| WK-DMF0040-0198 | B4 | DMF0040_MktFcst_Comparison.GetLastWeekSu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetLastWeekSunDayByDate: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0040_MktFcst_Comparison.GetLastWe) |
| WK-DMF0040-0199 | B4 | DMF0040_MktFcst_Comparison.GetPlantSiteb | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetPlantSitebyEndCustom: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.GetPlantS) |
| WK-DMF0040-0200 | B4 | DMF0040_MktFcst_Comparison.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetQtyData: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetQtyDat) |
| WK-DMF0040-0201 | B4 | DMF0040_MktFcst_Comparison.GetScmSitebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetScmSitebyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.GetScmSit) |
| WK-DMF0040-0202 | B4 | DMF0040_MktFcst_Comparison.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetSpdTitle: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetSpdTit) |
| WK-DMF0040-0203 | B4 | DMF0040_MktFcst_Comparison.GetTeambyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetTeambyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.GetTeamby) |
| WK-DMF0040-0204 | B4 | DMF0040_MktFcst_Comparison.GetThisWeekMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0040_MktFcst_Comparison.GetThisWeekMonday: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0040_MktFcst_Comparison.GetThisWe) |
| WK-DMF0040-0205 | DB-SYN | D-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D-03: 행 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (D-03) |
| WK-DMF0040-0206 | DB-SYN | DMF0040_MktFcst_Comparison.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0040_MktFcst_Comparison.GetDayRange: 진입점 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetDayRan) |
| WK-DMF0040-0207 | DB-SYN | E02-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E02-5: 행 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (E02-5) |
| WK-DMF0040-0208 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0040-0209 | DB-SYN | HANDLER:FindData:NegativeRed | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData:NegativeRed: 행 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData:NegativeRed) |
| WK-DMF0040-0210 | DB-SYN | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — UM-05: 행 집계 — DB-SYN 12요소: NOPATH:8 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0040-0211 | F4 | D-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D-03: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D-03) |
| WK-DMF0040-0212 | F4 | DMF0040_MktFcst_Comparison.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0040_MktFcst_Comparison.GetDayRange: 진입점 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.GetDayRan) |
| WK-DMF0040-0213 | F4 | E02-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E02-5: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (E02-5) |
| WK-DMF0040-0214 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0040-0215 | F4 | HANDLER:FindData:NegativeRed | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData:NegativeRed: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData:NegativeRed) |
| WK-DMF0040-0216 | F4 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — UM-05: 행 집계 — F4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0040-0217 | A5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-03: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0040-0218 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0040-0219 | A5 | DMF0040_MktFcst_Comparison.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0040_MktFcst_Comparison.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.CreateSpr) |
| WK-DMF0040-0220 | A5 | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0221 | A5 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0222 | A5 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0223 | A5 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E13: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E13) |
| WK-DMF0040-0224 | A5 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0040-0225 | A5 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-06: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0040-0226 | A5 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-07: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0040-0227 | A5 | UM-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-12: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-12) |
| WK-DMF0040-0228 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0040-0229 | G4 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterBizType (#3): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0040-0230 | G4 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0040-0231 | G4 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0040-0232 | G4 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterMyDivision (#0): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0040-0233 | G4 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0040-0234 | G4 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0040-0235 | G4 | MODAL:ComparisonVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — MODAL:ComparisonVersionModal: 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0236 | G4 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G4 14요소: NOT_RUN:13 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0040-0237 | H2 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-03: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0040-0238 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0040-0239 | H2 | DMF0040_MktFcst_Comparison.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0040_MktFcst_Comparison.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.CreateSpr) |
| WK-DMF0040-0240 | H2 | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0241 | H2 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0242 | H2 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0243 | H2 | E12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E12: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E12) |
| WK-DMF0040-0244 | H2 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E13: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E13) |
| WK-DMF0040-0245 | H2 | E14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E14: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E14) |
| WK-DMF0040-0246 | H2 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:FindData: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0040-0247 | H2 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0040-0248 | H2 | HANDLER:spdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:spdMain_TopChange: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_TopChange) |
| WK-DMF0040-0249 | H2 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — UM-06: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0040-0250 | H2 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — UM-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0040-0251 | H5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-03: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0040-0252 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0040-0253 | H5 | DMF0040_MktFcst_Comparison.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0040_MktFcst_Comparison.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.CreateSpr) |
| WK-DMF0040-0254 | H5 | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0255 | H5 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0256 | H5 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0257 | H5 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E13: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E13) |
| WK-DMF0040-0258 | H5 | HANDLER:spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:spdMain_KeyUp: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0040-0259 | H5 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-06: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0040-0260 | H5 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0040-0261 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 기능  |  | 1 (COMMON:UC-02) |
| WK-DMF0040-0262 | X-REASON | D-09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D-09 1164 / spdMain_ComboSelChange  제외 — Insert 행 전제 사문 (읽기 전용) 제외 |  | 1 (D-09) |
| WK-DMF0040-0263 | X-REASON | D-10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D-10 1439 / fnValidation  제외 — Insert 행 전제 사문 (fnValidation 9키 중복 검사 — 저장 경로 없음) 제외 |  | 1 (D-10) |
| WK-DMF0040-0264 | X-REASON | E05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E05 ClbSalesSite_SelectedIndexChanged (L1112) / E06. ClbPlantSite_SelectedIndexChanged (L1117…  제외 — E05~E08 은  |  | 1 (E05) |
| WK-DMF0040-0265 | X-REASON | E08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E08 SetClbVersion (L1132~1139)  제외 — 사문 메서드 (로컬 변수만 읽고 종료, 구 로직 제거 잔재) 제외 |  | 1 (E08) |
| WK-DMF0040-0266 | X-REASON | E10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E10 spdMain_ComboSelChange (L1163~1172)  제외 — Insert 행 전제 사문 (읽기 전용 화면 — 편집 진입 불가) 제외 |  | 1 (E10) |
| WK-DMF0040-0267 | X-REASON | HANDLER:ClbPlantSite_SelectedIndexChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:ClbPlantSite_SelectedIndexChanged AS-IS `DMF0040_MktFcst_Comparison.cs:1117` (라이브 3행) · **사문(빈 몸통)**  제 |  | 1 (HANDLER:ClbPlantSite_SelectedIndexChange) |
| WK-DMF0040-0268 | X-REASON | HANDLER:ClbSalesSite_SelectedIndexChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:ClbSalesSite_SelectedIndexChanged AS-IS `DMF0040_MktFcst_Comparison.cs:1112` (라이브 3행) · **사문(빈 몸통)**  제 |  | 1 (HANDLER:ClbSalesSite_SelectedIndexChange) |
| WK-DMF0040-0269 | X-REASON | HANDLER:DeleteButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:DeleteButton AS-IS `DMF0040_MktFcst_Comparison.cs:584` (라이브 2행) · **사문(빈 몸통)**  제외 — 빈 몸통 (읽기 전용) — hot |  | 1 (HANDLER:DeleteButton) |
| WK-DMF0040-0270 | X-REASON | HANDLER:EditButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:EditButton AS-IS `DMF0040_MktFcst_Comparison.cs:589` (라이브 7행)  해당없음 — 읽기전용 통보(MSG00109)뿐. TO-BE 는 편집 진입 |  | 1 (HANDLER:EditButton) |
| WK-DMF0040-0271 | X-REASON | HANDLER:InsertButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:InsertButton AS-IS `DMF0040_MktFcst_Comparison.cs:579` (라이브 2행) · **사문(빈 몸통)**  제외 — 빈 몸통. insert:false |  | 1 (HANDLER:InsertButton) |
| WK-DMF0040-0272 | X-REASON | HANDLER:SaveButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:SaveButton AS-IS `DMF0040_MktFcst_Comparison.cs:598` (라이브 2행) · **사문(빈 몸통)**  제외 — 빈 몸통. save:false 미노출 |  | 1 (HANDLER:SaveButton) |
| WK-DMF0040-0273 | X-REASON | HANDLER:TxtItemId_Enter | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:TxtItemId_Enter AS-IS `DMF0040_MktFcst_Comparison.cs:1127` (라이브 3행) · **사문(빈 몸통)**  제외 — 사문 (SetClbVers |  | 1 (HANDLER:TxtItemId_Enter) |
| WK-DMF0040-0274 | X-REASON | HANDLER:TxtProject_Changed | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:TxtProject_Changed AS-IS `DMF0040_MktFcst_Comparison.cs:1122` (라이브 3행) · **사문(빈 몸통)**  제외 — 사문 (동일) 제외 |  | 1 (HANDLER:TxtProject_Changed) |
| WK-DMF0040-0275 | X-REASON | HANDLER:spdMain_ComboSelChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_ComboSelChange AS-IS `DMF0040_MktFcst_Comparison.cs:1162` (라이브 9행)  제외 — Insert 전제 사문 (E10) 제외 |  | 1 (HANDLER:spdMain_ComboSelChange) |
| WK-DMF0040-0276 | X-REASON | P-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-01 588~595 / EditButton (F2)  해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false — MSG00109 표시 상황 부재 |  | 1 (P-01) |
| WK-DMF0040-0277 | E4 | DMF0040_MktFcst_Comparison.SetAmountCalc | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0040_MktFcst_Comparison.SetAmountCalculating: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0040_MktFcst_Comparison.SetAmount) |
| WK-DMF0040-0278 | E4 | DMF0040_MktFcst_Comparison.SetChangeCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0040_MktFcst_Comparison.SetChangeControl: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 17 (ACT:DMF0040_MktFcst_Comparison.SetChange) |
| WK-DMF0040-0279 | E4 | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0280 | E4 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0281 | E4 | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 54 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0282 | A1 | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-01: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (A-01) |
| WK-DMF0040-0283 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-DMF0040-0284 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-DMF0040-0285 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-DMF0040-0286 | A1 | D-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D-03) |
| WK-DMF0040-0287 | A1 | E02-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02-2: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (E02-2) |
| WK-DMF0040-0288 | A1 | E02-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02-5: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (E02-5) |
| WK-DMF0040-0289 | A1 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterBizType (#3): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterBizType (#3)) |
| WK-DMF0040-0290 | A1 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0040-0291 | A1 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0040-0292 | A1 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterMyDivision (#0): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0040-0293 | A1 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0040-0294 | A1 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0040-0295 | A1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindButton: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (HANDLER:FindButton) |
| WK-DMF0040-0296 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (HANDLER:FindData) |
| WK-DMF0040-0297 | A1 | HANDLER:FindData:NegativeRed | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData:NegativeRed: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (HANDLER:FindData:NegativeRed) |
| WK-DMF0040-0298 | A1 | MODAL:ComparisonVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ComparisonVersionModal: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0299 | A1 | PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON: 골든 비교 케이스 없음(PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON — 팝업·보조 SP 는 |  | 105 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0300 | A1 | PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0040.P_DMF0040_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 102 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0301 | A1 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0040-0302 | A1 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UM-05: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (UM-05) |
| WK-DMF0040-0303 | A6 | D-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D-03: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D-03) |
| WK-DMF0040-0304 | A6 | E02-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E02-5: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E02-5) |
| WK-DMF0040-0305 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0040-0306 | A6 | HANDLER:FindData:NegativeRed | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData:NegativeRed: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData:NegativeRed) |
| WK-DMF0040-0307 | A6 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — UM-05: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0040-0308 | G1 | A-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A-01: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (A-01) |
| WK-DMF0040-0309 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0040-0310 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0040-0311 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0040-0312 | G1 | E02-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E02-2: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E02-2) |
| WK-DMF0040-0313 | G1 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterBizType (#3): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0040-0314 | G1 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0040-0315 | G1 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0040-0316 | G1 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterMyDivision (#0): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0040-0317 | G1 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0040-0318 | G1 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0040-0319 | G1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindButton: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0040-0320 | G1 | MODAL:ComparisonVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:ComparisonVersionModal: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0321 | G1 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0040-0322 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0040-0323 | G6 | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterBizType (#3): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterBizType (#3)) |
| WK-DMF0040-0324 | G6 | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterEndCustomerByDivision (#2): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0040-0325 | G6 | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterFromSiteByDivision (#5): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0040-0326 | G6 | FilterMyDivision (#0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterMyDivision (#0): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterMyDivision (#0)) |
| WK-DMF0040-0327 | G6 | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterSiteByEndCustomer (#4): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0040-0328 | G6 | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FilterTeambyDivision (#1): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0040-0329 | G6 | MODAL:ComparisonVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — MODAL:ComparisonVersionModal: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ComparisonVersionModal) |
| WK-DMF0040-0330 | G6 | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — ReportBucketType / QtyType / ItemType: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0040-0331 | X-LOC | FilterBizType (#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterBizType (#3): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterBizType (#3)) |
| WK-DMF0040-0332 | X-LOC | FilterEndCustomerByDivision (#2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterEndCustomerByDivision (#2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterEndCustomerByDivision (#2)) |
| WK-DMF0040-0333 | X-LOC | FilterFromSiteByDivision (#5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterFromSiteByDivision (#5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterFromSiteByDivision (#5)) |
| WK-DMF0040-0334 | X-LOC | FilterSiteByEndCustomer (#4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterSiteByEndCustomer (#4): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterSiteByEndCustomer (#4)) |
| WK-DMF0040-0335 | X-LOC | FilterTeambyDivision (#1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FilterTeambyDivision (#1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FilterTeambyDivision (#1)) |
| WK-DMF0040-0336 | X-LOC | ReportBucketType / QtyType / ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ReportBucketType / QtyType / ItemType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ReportBucketType / QtyType / ItemType) |
| WK-DMF0040-0337 | X-ROW | D-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-01) |
| WK-DMF0040-0338 | X-ROW | D-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-02) |
| WK-DMF0040-0339 | X-ROW | D-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-04) |
| WK-DMF0040-0340 | X-ROW | D-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-05) |
| WK-DMF0040-0341 | X-ROW | D-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-06) |
| WK-DMF0040-0342 | X-ROW | D-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-07) |
| WK-DMF0040-0343 | X-ROW | D-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-08) |
| WK-DMF0040-0344 | X-ROW | DMF0040_MktFcst_Comparison.ClbPlantSite_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.ClbPlantSite_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.ClbPlantS) |
| WK-DMF0040-0345 | X-ROW | DMF0040_MktFcst_Comparison.ClbSalesSite_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.ClbSalesSite_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.ClbSalesS) |
| WK-DMF0040-0346 | X-ROW | DMF0040_MktFcst_Comparison.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.CreateSpr) |
| WK-DMF0040-0347 | X-ROW | DMF0040_MktFcst_Comparison.DefinePropert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.DefinePro) |
| WK-DMF0040-0348 | X-ROW | DMF0040_MktFcst_Comparison.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.EditButto) |
| WK-DMF0040-0349 | X-ROW | DMF0040_MktFcst_Comparison.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP,  |  | 15 (ACT:DMF0040_MktFcst_Comparison.ExcelButt) |
| WK-DMF0040-0350 | X-ROW | DMF0040_MktFcst_Comparison.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0040_MktFcst_Comparison.FindButto) |
| WK-DMF0040-0351 | X-ROW | DMF0040_MktFcst_Comparison.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.FindData: 진입점 집계 29검사 — NOT_RUN:25 · REVIEW:2 · PASS:2 |  | 14 (ACT:DMF0040_MktFcst_Comparison.FindData:) |
| WK-DMF0040-0352 | X-ROW | DMF0040_MktFcst_Comparison.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.Form_Load) |
| WK-DMF0040-0353 | X-ROW | DMF0040_MktFcst_Comparison.GetBizTypebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetBizTypebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetBizTyp) |
| WK-DMF0040-0354 | X-ROW | DMF0040_MktFcst_Comparison.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetBucket) |
| WK-DMF0040-0355 | X-ROW | DMF0040_MktFcst_Comparison.GetCustomerby | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetCustomerbyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetCustom) |
| WK-DMF0040-0356 | X-ROW | DMF0040_MktFcst_Comparison.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetDayRan) |
| WK-DMF0040-0357 | X-ROW | DMF0040_MktFcst_Comparison.GetDefaultVer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetDefaultVersion: 진입점 집계 11검사 — NOPATH:3 · TODO:3 · REVIEW:2 · NOT_RUN:2 · PASS:1 |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetDefaul) |
| WK-DMF0040-0358 | X-ROW | DMF0040_MktFcst_Comparison.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetDivisi) |
| WK-DMF0040-0359 | X-ROW | DMF0040_MktFcst_Comparison.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetItemType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetItemTy) |
| WK-DMF0040-0360 | X-ROW | DMF0040_MktFcst_Comparison.GetLastWeekSu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetLastWeekSunDayByDate: 진입점 집계 4검사 — NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetLastWe) |
| WK-DMF0040-0361 | X-ROW | DMF0040_MktFcst_Comparison.GetPlantSiteb | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetPlantSitebyEndCustom: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetPlantS) |
| WK-DMF0040-0362 | X-ROW | DMF0040_MktFcst_Comparison.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetQtyData: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetQtyDat) |
| WK-DMF0040-0363 | X-ROW | DMF0040_MktFcst_Comparison.GetScmSitebyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetScmSitebyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetScmSit) |
| WK-DMF0040-0364 | X-ROW | DMF0040_MktFcst_Comparison.GetTeambyDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetTeambyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetTeamby) |
| WK-DMF0040-0365 | X-ROW | DMF0040_MktFcst_Comparison.GetThisWeekMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.GetThisWeekMonday: 진입점 집계 4검사 — NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.GetThisWe) |
| WK-DMF0040-0366 | X-ROW | DMF0040_MktFcst_Comparison.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.InitControls: 진입점 집계 37검사 — NOT_RUN:36 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0040_MktFcst_Comparison.InitContr) |
| WK-DMF0040-0367 | X-ROW | DMF0040_MktFcst_Comparison.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.InitSpread: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.InitSprea) |
| WK-DMF0040-0368 | X-ROW | DMF0040_MktFcst_Comparison.InitSpreadFoo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.InitSprea) |
| WK-DMF0040-0369 | X-ROW | DMF0040_MktFcst_Comparison.SetAmountCalc | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetAmountCalculating: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetAmount) |
| WK-DMF0040-0370 | X-ROW | DMF0040_MktFcst_Comparison.SetChangeCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0040_MktFcst_Comparison.SetChange) |
| WK-DMF0040-0371 | X-ROW | DMF0040_MktFcst_Comparison.SetClbVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetClbVersion: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.SetClbVer) |
| WK-DMF0040-0372 | X-ROW | DMF0040_MktFcst_Comparison.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0373 | X-ROW | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeader: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0374 | X-ROW | DMF0040_MktFcst_Comparison.SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.SetSpread) |
| WK-DMF0040-0375 | X-ROW | DMF0040_MktFcst_Comparison.TxtItemId_Ent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.TxtItemId_Enter: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0040_MktFcst_Comparison.TxtItemId) |
| WK-DMF0040-0376 | X-ROW | DMF0040_MktFcst_Comparison.TxtProject_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.TxtProject_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.TxtProjec) |
| WK-DMF0040-0377 | X-ROW | DMF0040_MktFcst_Comparison.btnColumn_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.btnColumn) |
| WK-DMF0040-0378 | X-ROW | DMF0040_MktFcst_Comparison.btnItemId_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.btnItemId) |
| WK-DMF0040-0379 | X-ROW | DMF0040_MktFcst_Comparison.btnMeasure_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.btnMeasur) |
| WK-DMF0040-0380 | X-ROW | DMF0040_MktFcst_Comparison.btnOwner_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnOwner_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.btnOwner_) |
| WK-DMF0040-0381 | X-ROW | DMF0040_MktFcst_Comparison.btnProject_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0040_MktFcst_Comparison.btnProjec) |
| WK-DMF0040-0382 | X-ROW | DMF0040_MktFcst_Comparison.btnVersion_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.btnVersion_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0040_MktFcst_Comparison.btnVersio) |
| WK-DMF0040-0383 | X-ROW | DMF0040_MktFcst_Comparison.cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.cboBucketType_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.cboBucket) |
| WK-DMF0040-0384 | X-ROW | DMF0040_MktFcst_Comparison.cboDivision_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.cboDivision_SelectedInd: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.cboDivisi) |
| WK-DMF0040-0385 | X-ROW | DMF0040_MktFcst_Comparison.cboQTY_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.cboQTY_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.cboQTY_Se) |
| WK-DMF0040-0386 | X-ROW | DMF0040_MktFcst_Comparison.chkSum_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.chkSum_Ch) |
| WK-DMF0040-0387 | X-ROW | DMF0040_MktFcst_Comparison.clbCustomer_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.clbCustomer_SelectedInd: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.clbCustom) |
| WK-DMF0040-0388 | X-ROW | DMF0040_MktFcst_Comparison.clbTeam_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.clbTeam_SelectedIndexCh: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0040_MktFcst_Comparison.clbTeam_S) |
| WK-DMF0040-0389 | X-ROW | DMF0040_MktFcst_Comparison.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 21 (ACT:DMF0040_MktFcst_Comparison.fnValidat) |
| WK-DMF0040-0390 | X-ROW | DMF0040_MktFcst_Comparison.spdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0391 | X-ROW | DMF0040_MktFcst_Comparison.spdMain_Combo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0392 | X-ROW | DMF0040_MktFcst_Comparison.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0040_MktFcst_Comparison.spdMain_K) |
| WK-DMF0040-0393 | X-ROW | DMF0040_MktFcst_Comparison.spdMain_TopCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0040_MktFcst_Comparison.spdMain_T) |
| WK-DMF0040-0394 | X-ROW | DMF0040_MktFcst_Comparison.txtVersion_Ke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0040_MktFcst_Comparison.txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0040_MktFcst_Comparison.txtVersio) |
| WK-DMF0040-0395 | X-ROW | E02-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E02-3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E02-3) |
| WK-DMF0040-0396 | X-ROW | E02-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E02-4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E02-4) |
| WK-DMF0040-0397 | X-ROW | E17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E17) |
| WK-DMF0040-0398 | X-ROW | E19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E19) |
| WK-DMF0040-0399 | X-ROW | E22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E22) |
| WK-DMF0040-0400 | X-ROW | G-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-04) |
| WK-DMF0040-0401 | X-ROW | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0040-0402 | X-ROW | HANDLER:btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnColumn_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnColumn_Click) |
| WK-DMF0040-0403 | X-ROW | HANDLER:btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnItemId_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0040-0404 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0040-0405 | X-ROW | HANDLER:btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnOwner_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnOwner_Click) |
| WK-DMF0040-0406 | X-ROW | HANDLER:btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnProject_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0040-0407 | X-ROW | HANDLER:btnVersion_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnVersion_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnVersion_Click) |
| WK-DMF0040-0408 | X-ROW | HANDLER:txtVersion_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:txtVersion_KeyDown) |
| WK-DMF0040-0409 | X-ROW | REQ:CHAT-20260828-UM01-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM01-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM01-DMF0040) |
| WK-DMF0040-0410 | X-ROW | REQ:CHAT-20260828-UM02-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM02-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM02-DMF0040) |
| WK-DMF0040-0411 | X-ROW | REQ:CHAT-20260828-UM03-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM03-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM03-DMF0040) |
| WK-DMF0040-0412 | X-ROW | REQ:CHAT-20260828-UM04-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM04-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM04-DMF0040) |
| WK-DMF0040-0413 | X-ROW | REQ:CHAT-20260828-UM05-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM05-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM05-DMF0040) |
| WK-DMF0040-0414 | X-ROW | REQ:CHAT-20260828-UM06-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM06-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM06-DMF0040) |
| WK-DMF0040-0415 | X-ROW | REQ:CHAT-20260828-UM07-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM07-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM07-DMF0040) |
| WK-DMF0040-0416 | X-ROW | REQ:CHAT-20260828-UM08-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM08-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM08-DMF0040) |
| WK-DMF0040-0417 | X-ROW | REQ:CHAT-20260828-UM11-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM11-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM11-DMF0040) |
| WK-DMF0040-0418 | X-ROW | REQ:CHAT-20260828-UM12-DMF0040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM12-DMF0040: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM12-DMF0040) |
| WK-DMF0040-0419 | X-ROW | UM-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-01) |
| WK-DMF0040-0420 | X-ROW | UM-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-02) |
| WK-DMF0040-0421 | X-ROW | UM-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-08) |
| WK-DMF0040-0422 | X-ROW | UM-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-11) |
| WK-DMF0040-0423 | G5 | DMF0040_MktFcst_Comparison.spdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_CellDoubleClick: 진입점 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0424 | G5 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E11: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0040-0425 | G5 | E20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E20: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (E20) |
| WK-DMF0040-0426 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0040-0427 | H6 | DMF0040_MktFcst_Comparison.spdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_CellDoubleClick: 진입점 집계 — H6 7요소: NOPATH:6 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0428 | H6 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E11: 행 집계 — H6 7요소: NOPATH:6 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0040-0429 | H6 | E20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E20: 행 집계 — H6 7요소: NOPATH:6 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E20) |
| WK-DMF0040-0430 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 7요소: NOPATH:6 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0040-0431 | M4 | DMF0040_MktFcst_Comparison.spdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0040_MktFcst_Comparison.spdMain_CellDoubleClick: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 31 (ACT:DMF0040_MktFcst_Comparison.spdMain_C) |
| WK-DMF0040-0432 | M4 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E11: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E11) |
| WK-DMF0040-0433 | M4 | E20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E20: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E20) |
| WK-DMF0040-0434 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
