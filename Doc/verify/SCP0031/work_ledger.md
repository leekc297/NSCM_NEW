# 작업 원장 — SCP0031 · 2026-10-26 12:53

> 검사 인스턴스 493건 중 PASS·NA 195건 외 **298건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 5 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 35 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 84 | 실행 → PASS |
| W7 | 기대값 확정 | 169 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 166 · E2E 84 · 하네스 40 · 대조표 8
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 63 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 5 |  |  |  |  | 19 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 11 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H5 | DESIGN |  |  |  |  |  | 6 | 11 |  |  | 라벨 명칭 |
| E4 | EDIT |  |  |  |  |  | 10 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  | 7 |  | 7 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 1 | 11 |  |  |  | 조회조건 표시·라벨·활성 |
| B3 | COMBO |  |  |  | 5 |  |  | 6 |  |  | 콤보 후보 정렬 = AS-IS |
| G6 | GEN |  |  |  |  |  | 11 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G5 | POPUP |  |  |  |  | 2 |  | 7 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 |  | 7 |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 9 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| M4 | POPUP |  |  |  |  |  | 2 | 7 |  |  | 팝업 선택값 반영 |
| B1 | COMBO |  |  |  |  | 7 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 7 |  | 1 |  |  | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  | 7 |  |  |  |  | ALL 옵션·다중선택 사양 |
| C4 | CASCADE |  |  |  |  |  | 7 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| M3 | POPUP |  |  |  |  |  | 1 | 3 |  |  | 팝업 내부 기능(조회·CRUD) |
| F4 | DB |  |  |  |  |  | 3 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0031-0001 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0031-0002 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0031-0003 | X-LOC | ProgressForm(공통 로딩) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ProgressForm(공통 로딩)) |
| WK-SCP0031-0004 | X-LOC | SCM0002_MaterialByDivisionPopup(btnItem_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_MaterialByDivisionPopup(btnItem_) |
| WK-SCP0031-0005 | X-LOC | SCM0002_TitleSetForm_Popup(btnMeasure) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_TitleSetForm_Popup(btnMeasure)) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0031-0006 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (cboBucketType ACT:SCP0031_GlobalPSI.GetD) |
| WK-SCP0031-0007 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 5 (cboDivision ACT:SCP0031_GlobalPSI.GetDay) |
| WK-SCP0031-0008 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0031_GlobalPSI.GetDayRange ACT:SC) |
| WK-SCP0031-0009 | B3 | clbFromSite / From Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFromSite / From Site | 있음(FE 소스) | 1 (clbFromSite) |
| WK-SCP0031-0010 | B3 | clbToSite / To Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbToSite / To Site | 있음(FE 소스) | 1 (clbToSite) |

## W5 검사기 연결 (35)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0031-0011 | B1 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0031-0012 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0031-0013 | B1 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0031-0014 | B1 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0031-0015 | B1 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0031-0016 | B1 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0031-0017 | B1 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0031-0018 | B2 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0031-0019 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0031-0020 | B2 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0031-0021 | B2 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0031-0022 | B2 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0031-0023 | B2 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0031-0024 | B2 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0031-0025 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 4 (D00-1-006 cboBucketType ACT:SCP0031_Glob) |
| WK-SCP0031-0026 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 6 (D00-1-007 cboDivision ACT:SCP0031_Global) |
| WK-SCP0031-0027 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 3 (D00-1-008 ACT:SCP0031_GlobalPSI.GetDayRa) |
| WK-SCP0031-0028 | B4 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0031-0029 | B4 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0031-0030 | B4 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 2 (D00-1-013 clbFromSite) |
| WK-SCP0031-0031 | B4 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 2 (D00-1-014 clbToSite) |
| WK-SCP0031-0032 | B6 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0031-0033 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0031-0034 | B6 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0031-0035 | B6 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0031-0036 | B6 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0031-0037 | B6 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0031-0038 | B6 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0031-0039 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (cboBucketType ACT:SCP0031_GlobalPSI.GetB) |
| WK-SCP0031-0040 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0031_GlobalPSI.InitEvent ACT:SCP0) |
| WK-SCP0031-0041 | G03-WIRE | SCP0031 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0031 화면 | 판단불가(대상 단위 SCREEN) | 14 (ACT:SCP0031_GlobalPSI..ctor ACT:SCP0031_) |
| WK-SCP0031-0042 | G5 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItem | 없음 | 2 (D00-1-004 SCM0002_MaterialByDivisionPopu) |
| WK-SCP0031-0043 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (D00-2-002 SCM0002_TitleSetForm_Popup(btn) |
| WK-SCP0031-0044 | H6 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItem | 없음 | 2 (D00-1-004 SCM0002_MaterialByDivisionPopu) |
| WK-SCP0031-0045 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (D00-2-002 SCM0002_TitleSetForm_Popup(btn) |

## W6 검증 실행 (84)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0031-0046 | J2 | SCP0031 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0031 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 34 (D00-1-004 D00-2-001 D00-2-008 D00-3-024 ) |
| WK-SCP0031-0047 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-003 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0048 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (D00-2-004 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0049 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-005 ACT:SCP0031_GlobalPSI.RefreshP) |
| WK-SCP0031-0050 | C1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-006 ACT:SCP0031_GlobalPSI.RefreshP) |
| WK-SCP0031-0051 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SCP0031_GlobalPSI.RefreshP) |
| WK-SCP0031-0052 | C1 | chkAll / ALL / All | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkAll / ALL / All · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0031-0053 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SCP0031-0054 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0031_GlobalPSI.SetChangedControl:) |
| WK-SCP0031-0055 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0031_GlobalPSI.SetChangedControl:) |
| WK-SCP0031-0056 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-SCP0031-0057 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0031-0058 | C4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-005) |
| WK-SCP0031-0059 | C4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-SCP0031-0060 | C4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SCP0031-0061 | C4 | chkAll / ALL / All | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkAll / ALL / All · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0031-0062 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SCP0031-0063 | G3 | SCP0031 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0031 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (D00-1-031 COMMON:UC-03 COMMON:UC-05 COMM) |
| WK-SCP0031-0064 | K-SA | SCP0031 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0031 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (D00-1-031) |
| WK-SCP0031-0065 | K4 | SCP0031 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0031 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 23 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-07 A) |
| WK-SCP0031-0066 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (cboBucketType ACT:SCP0031_GlobalPSI.GetB) |
| WK-SCP0031-0067 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 73 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0068 | F4 | PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 74 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0069 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (D00-1-006 ACT:SCP0031_GlobalPSI.DefinePr) |
| WK-SCP0031-0070 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (D00-1-007 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0071 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (D00-1-008 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0072 | G4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-009 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0073 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-010 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0074 | G4 | chkAll / ALL / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkAll / ALL / All · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SCP0031_GlobalPSI.InitEven) |
| WK-SCP0031-0075 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:SCP0031_GlobalPSI.InitEven) |
| WK-SCP0031-0076 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-013) |
| WK-SCP0031-0077 | G4 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbToSite / To Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-014) |
| WK-SCP0031-0078 | G4 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-034) |
| WK-SCP0031-0079 | G4 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-035) |
| WK-SCP0031-0080 | H4 | SCP0031 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0031 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (D00-2-011 D00-3-026 ACT:SCP0031_GlobalPS) |
| WK-SCP0031-0081 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SCP0031_GlobalPSI.SetSpreadColumn AC) |
| WK-SCP0031-0082 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SCP0031-0083 | H5 | cboPlanDate / Plan-date / Plan Date | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 1 (4) |
| WK-SCP0031-0084 | H5 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 |  | 1 (5) |
| WK-SCP0031-0085 | H5 | cboPlanType / Plan-type / Plan Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 1 (6) |
| WK-SCP0031-0086 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCP0031_GlobalPSI.SetSpreadColumn AC) |
| WK-SCP0031-0087 | I1 | SCP0031 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0031 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 16 (D00-4e-001 D00-4e-003 D00-4e-004 D00-4e-) |
| WK-SCP0031-0088 | SC1 | SCP0031 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0031 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 11 (D00-1-006 D00-1-007 D00-1-008 D00-1-009 ) |
| WK-SCP0031-0089 | D6 | SCP0031 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0031 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (COMMON:UC-03) |
| WK-SCP0031-0090 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (D00-4e-003 D00-4e-005 D00-4e-006 D00-4e-) |
| WK-SCP0031-0091 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (D00-4e-003 D00-4e-005 D00-4e-006 D00-4e-) |
| WK-SCP0031-0092 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-4e-004 D00-4e-007 ACT:SCPPlan.Check_) |
| WK-SCP0031-0093 | E4 | MSG00402 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00402 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-001) |
| WK-SCP0031-0094 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SCP0031_GlobalPSI.SetSpreadColumn AC) |
| WK-SCP0031-0095 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 38 (ACT:SCP0031_GlobalPSI.SetChangedControl ) |
| WK-SCP0031-0096 | E4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 3 (ACT:SCP0031_GlobalPSI.SetChangedControl ) |
| WK-SCP0031-0097 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0031_GlobalPSI.SetSpreadColumn AC) |
| WK-SCP0031-0098 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SCP0031_GlobalPSI.SetChangedControl ) |
| WK-SCP0031-0099 | E4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0031_GlobalPSI.SetChangedControl ) |
| WK-SCP0031-0100 | A10 | SCP0031 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0031 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 100 (ACT:SCP0031_GlobalPSI.DefineProperty ACT) |
| WK-SCP0031-0101 | A6 | DM0003_GET_BUCKET_TYPE_CODE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (cboBucketType) |
| WK-SCP0031-0102 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 71 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0103 | A6 | PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 74 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0104 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-006 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0105 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-007 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0106 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-008 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0107 | G1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0108 | G1 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-010 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0109 | G1 | chkAll / ALL / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkAll / ALL / All · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-011 D00-2-008 7 ACT:SCP0031_Global) |
| WK-SCP0031-0110 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0031-0111 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-013 clbFromSite ACT:SCP0031_Global) |
| WK-SCP0031-0112 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-014 clbToSite ACT:SCP0031_GlobalPS) |
| WK-SCP0031-0113 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-034 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0114 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-035 ACT:SCP0031_GlobalPSI.FindData) |
| WK-SCP0031-0115 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (D00-1-006 ACT:SCP0031_GlobalPSI.DefinePr) |
| WK-SCP0031-0116 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-007 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0117 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-008 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0118 | G6 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-009 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0119 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-010 ACT:SCP0031_GlobalPSI.InitCont) |
| WK-SCP0031-0120 | G6 | chkAll / ALL / All | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkAll / ALL / All · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:SCP0031_GlobalPSI.InitEven) |
| WK-SCP0031-0121 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-012 ACT:SCP0031_GlobalPSI.InitEven) |
| WK-SCP0031-0122 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-013) |
| WK-SCP0031-0123 | G6 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-014) |
| WK-SCP0031-0124 | G6 | txtItemId / Material / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Material / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-034) |
| WK-SCP0031-0125 | G6 | txtNickName / Nick Name / Model/Nickname | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-035) |
| WK-SCP0031-0126 | X-REOPEN | SCP0031 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0031 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0031_GlobalPSI.Dispose ACT:SCP003) |
| WK-SCP0031-0127 | M3 | SCPPlan | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCPPlan · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 6 (ACT:SCPPlan.CheckArrayPlanPeriodRange AC) |
| WK-SCP0031-0128 | M4 | btnItem | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItem · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-004 SCM0002_MaterialByDivisionPopu) |
| WK-SCP0031-0129 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-2-002 SCM0002_TitleSetForm_Popup(btn) |

## W7 기대값 확정 (169)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0031-0130 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0031-0131 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0031-0132 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0031-0133 | B3 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-005: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-005) |
| WK-SCP0031-0134 | B3 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-006: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-006) |
| WK-SCP0031-0135 | B3 | SCP0031_GlobalPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0031_GlobalPSI.GetBucketType: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.GetBucketType:803:) |
| WK-SCP0031-0136 | B3 | SCP0031_GlobalPSI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0031_GlobalPSI.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.GetDayRange:837:1 ) |
| WK-SCP0031-0137 | B3 | SCP0031_GlobalPSI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0031_GlobalPSI.GetSpdTitle: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0031_GlobalPSI.GetSpdTitle:823:1 ) |
| WK-SCP0031-0138 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0031-0139 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0031-0140 | B4 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-005: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-005) |
| WK-SCP0031-0141 | B4 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-006: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-006) |
| WK-SCP0031-0142 | B4 | SCP0031_GlobalPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0031_GlobalPSI.GetBucketType: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.GetBucketType:803:) |
| WK-SCP0031-0143 | B4 | SCP0031_GlobalPSI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0031_GlobalPSI.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.GetDayRange:837:1 ) |
| WK-SCP0031-0144 | B4 | SCP0031_GlobalPSI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0031_GlobalPSI.GetSpdTitle: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0031_GlobalPSI.GetSpdTitle:823:1 ) |
| WK-SCP0031-0145 | H5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 10: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0031-0146 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0031-0147 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0031-0148 | H5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-032: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0031-0149 | H5 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-011: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SCP0031-0150 | H5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-001: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0031-0151 | H5 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-023: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0031-0152 | H5 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-024: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0031-0153 | H5 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-026: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-026) |
| WK-SCP0031-0154 | H5 | SCP0031_GlobalPSI.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0031_GlobalPSI.CreateSpread: 진입점 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0031_GlobalPSI.CreateSpread:232:1) |
| WK-SCP0031-0155 | H5 | SCP0031_GlobalPSI.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0031_GlobalPSI.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.SetSpreadColumn:35) |
| WK-SCP0031-0156 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 경로  |  | 1 (COMMON:UC-02) |
| WK-SCP0031-0157 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)  해당없음 — 조회조건 전부 콤보/날짜/팝업 단일값(Material=팝업 반환, NickName=단 |  | 1 (COMMON:UC-06) |
| WK-SCP0031-0158 | X-REASON | D00-3-025 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-025 §3 SetDblClickColumnShowHide / 817  pivot 드릴다운 컬럼 show/hide — 공용 DataGrid pivot 컬럼 collapse 미제공(자매 SC |  | 1 (D00-3-025) |
| WK-SCP0031-0159 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0031-0160 | E4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 3: 행 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0031-0161 | E4 | 4~8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 4~8: 행 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (4~8) |
| WK-SCP0031-0162 | E4 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4b-007: 행 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SCP0031-0163 | E4 | SCP0031_GlobalPSI.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0031_GlobalPSI.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.SetSpreadColumn:35) |
| WK-SCP0031-0164 | E4 | SCP0031_GlobalPSI.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0031_GlobalPSI.Set_MeasureColor: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0031_GlobalPSI.Set_MeasureColor:7) |
| WK-SCP0031-0165 | E4 | SCP0031_GlobalPSI.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0031_GlobalPSI.Set_SumValues: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 45 (ACT:SCP0031_GlobalPSI.Set_SumValues:634:) |
| WK-SCP0031-0166 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SCP0031-0167 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (11) |
| WK-SCP0031-0168 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (3) |
| WK-SCP0031-0169 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (7) |
| WK-SCP0031-0170 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-03) |
| WK-SCP0031-0171 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0031-0172 | A1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-004: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-004) |
| WK-SCP0031-0173 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-001) |
| WK-SCP0031-0174 | A1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-008: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-008) |
| WK-SCP0031-0175 | A1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-024: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-024) |
| WK-SCP0031-0176 | A1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4f-003: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4f-003) |
| WK-SCP0031-0177 | A1 | DM0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE: 골든 비교 케이스 없음(DM0003_GET_BUCKET_TYPE_CODE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (cboBucketType) |
| WK-SCP0031-0178 | A1 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ShowDialog: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0179 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 71 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0180 | A1 | PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI: 골든 비교 케이스 없음(PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI — 팝업·보조 SP 는 golden_cases.csv  |  | 74 (ACT:SCP0031_GlobalPSI.FindButton ACT:SCP) |
| WK-SCP0031-0181 | A1 | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (clbFromSite) |
| WK-SCP0031-0182 | A1 | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (clbToSite) |
| WK-SCP0031-0183 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0031-0184 | G1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 11: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0031-0185 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0031-0186 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0031-0187 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0031-0188 | G1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-004: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0031-0189 | G1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-001: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0031-0190 | G1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-024: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0031-0191 | G1 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4f-003: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SCP0031-0192 | G1 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:ShowDialog: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0193 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0031-0194 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0031-0195 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0031-0196 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0031-0197 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0031-0198 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0031-0199 | X-LOC | 4~8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4~8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4~8) |
| WK-SCP0031-0200 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0031-0201 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0031-0202 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0031-0203 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0031-0204 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0031-0205 | X-LOC | cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboBucketType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboBucketType) |
| WK-SCP0031-0206 | X-LOC | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDivision) |
| WK-SCP0031-0207 | X-LOC | cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanDate: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanDate) |
| WK-SCP0031-0208 | X-LOC | cboPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanSeq: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanSeq) |
| WK-SCP0031-0209 | X-LOC | cboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanType) |
| WK-SCP0031-0210 | X-LOC | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbFromSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbFromSite) |
| WK-SCP0031-0211 | X-LOC | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbToSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbToSite) |
| WK-SCP0031-0212 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0031-0213 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (8) |
| WK-SCP0031-0214 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SCP0031-0215 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0031-0216 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SCP0031-0217 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0031-0218 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0031-0219 | X-ROW | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-016) |
| WK-SCP0031-0220 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0031-0221 | X-ROW | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-006) |
| WK-SCP0031-0222 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SCP0031-0223 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SCP0031-0224 | X-ROW | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-009) |
| WK-SCP0031-0225 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SCP0031-0226 | X-ROW | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-011) |
| WK-SCP0031-0227 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SCP0031-0228 | X-ROW | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-013) |
| WK-SCP0031-0229 | X-ROW | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-014) |
| WK-SCP0031-0230 | X-ROW | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-022) |
| WK-SCP0031-0231 | X-ROW | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-002) |
| WK-SCP0031-0232 | X-ROW | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-003) |
| WK-SCP0031-0233 | X-ROW | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-004) |
| WK-SCP0031-0234 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0031-0235 | X-ROW | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-002) |
| WK-SCP0031-0236 | X-ROW | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-003) |
| WK-SCP0031-0237 | X-ROW | D00-4f-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4f-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4f-001) |
| WK-SCP0031-0238 | X-ROW | SCP0031_GlobalPSI.BtnItem_Id_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0031_GlobalPSI.BtnItem_Id_Click:9) |
| WK-SCP0031-0239 | X-ROW | SCP0031_GlobalPSI.CboBucketType_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CboBucketType_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CboBucketType_Sele) |
| WK-SCP0031-0240 | X-ROW | SCP0031_GlobalPSI.CboDivision_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CboDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CboDivision_Select) |
| WK-SCP0031-0241 | X-ROW | SCP0031_GlobalPSI.CboPlanDate_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CboPlanDate_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CboPlanDate_Select) |
| WK-SCP0031-0242 | X-ROW | SCP0031_GlobalPSI.CboPlanSeq_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CboPlanSeq_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CboPlanSeq_Selecte) |
| WK-SCP0031-0243 | X-ROW | SCP0031_GlobalPSI.CboPlanType_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CboPlanType_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CboPlanType_Select) |
| WK-SCP0031-0244 | X-ROW | SCP0031_GlobalPSI.ChkAll_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.ChkAll_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.ChkAll_CheckedChan) |
| WK-SCP0031-0245 | X-ROW | SCP0031_GlobalPSI.ChkSum_CheckedChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.ChkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.ChkSum_CheckedChan) |
| WK-SCP0031-0246 | X-ROW | SCP0031_GlobalPSI.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.CreateSpread) |
| WK-SCP0031-0247 | X-ROW | SCP0031_GlobalPSI.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.DefineProperty:167) |
| WK-SCP0031-0248 | X-ROW | SCP0031_GlobalPSI.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_BASE/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0031_GlobalPSI.ExcelButton ACT:SC) |
| WK-SCP0031-0249 | X-ROW | SCP0031_GlobalPSI.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0031_GlobalPSI.FindButton) |
| WK-SCP0031-0250 | X-ROW | SCP0031_GlobalPSI.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.FindData_Main: 진입점 집계 23검사 — NOT_RUN:19 · REVIEW:2 · PASS:2 |  | 15 (ACT:SCP0031_GlobalPSI.FindData_Main:524:) |
| WK-SCP0031-0251 | X-ROW | SCP0031_GlobalPSI.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.Form_Load) |
| WK-SCP0031-0252 | X-ROW | SCP0031_GlobalPSI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.GetBucketType) |
| WK-SCP0031-0253 | X-ROW | SCP0031_GlobalPSI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.GetSpdTitle) |
| WK-SCP0031-0254 | X-ROW | SCP0031_GlobalPSI.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.InitControls: 진입점 집계 13검사 — NOT_RUN:13 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0031_GlobalPSI.InitControls:195:1) |
| WK-SCP0031-0255 | X-ROW | SCP0031_GlobalPSI.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.InitSpread) |
| WK-SCP0031-0256 | X-ROW | SCP0031_GlobalPSI.InitSpreadDateColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0031_GlobalPSI.InitSpreadDateColu) |
| WK-SCP0031-0257 | X-ROW | SCP0031_GlobalPSI.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0031_GlobalPSI.RefreshPlanDate AC) |
| WK-SCP0031-0258 | X-ROW | SCP0031_GlobalPSI.RefreshPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.RefreshPlanSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0031_GlobalPSI.RefreshPlanSeq ACT) |
| WK-SCP0031-0259 | X-ROW | SCP0031_GlobalPSI.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.RefreshPlanType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0031_GlobalPSI.RefreshPlanType AC) |
| WK-SCP0031-0260 | X-ROW | SCP0031_GlobalPSI.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.SetChangedControl: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0031_GlobalPSI.SetChangedControl ) |
| WK-SCP0031-0261 | X-ROW | SCP0031_GlobalPSI.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0031_GlobalPSI.SetSpreadColumn AC) |
| WK-SCP0031-0262 | X-ROW | SCP0031_GlobalPSI.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.Set_MeasureColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.Set_MeasureColor A) |
| WK-SCP0031-0263 | X-ROW | SCP0031_GlobalPSI.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0031_GlobalPSI.Set_SumValues ACT:) |
| WK-SCP0031-0264 | X-ROW | SCP0031_GlobalPSI.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.SpdMain_CellDouble) |
| WK-SCP0031-0265 | X-ROW | SCP0031_GlobalPSI.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0031_GlobalPSI.SpdMain_TopChange ) |
| WK-SCP0031-0266 | X-ROW | SCP0031_GlobalPSI.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0031_GlobalPSI.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0031_GlobalPSI.btnMeasure_Click:8) |
| WK-SCP0031-0267 | X-ROW | SCPPlan.CheckArrayPlanPeriodRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCPPlan.CheckArrayPlanPeriodRange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 19 (ACT:SCPPlan.CheckArrayPlanPeriodRange AC) |
| WK-SCP0031-0268 | X-ROW | SCPPlan.CheckPlanPeriodRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCPPlan.CheckPlanPeriodRange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCPPlan.CheckPlanPeriodRange ACT:SCP) |
| WK-SCP0031-0269 | X-ROW | SCPPlan.Check_PeriodDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCPPlan.Check_PeriodDate: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCPPlan.Check_PeriodDate ACT:SCPPlan) |
| WK-SCP0031-0270 | X-ROW | SCPPlan.Check_PeriodDate_New | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCPPlan.Check_PeriodDate_New: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SCPPlan.Check_PeriodDate_New ACT:SCP) |
| WK-SCP0031-0271 | X-ROW | SCPPlan.GetPeriodRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCPPlan.GetPeriodRange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCPPlan.GetPeriodRange ACT:SCPPlan.G) |
| WK-SCP0031-0272 | X-ROW | cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboPlanDate: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboPlanDate) |
| WK-SCP0031-0273 | X-ROW | cboPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboPlanSeq: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboPlanSeq) |
| WK-SCP0031-0274 | X-ROW | cboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboPlanType) |
| WK-SCP0031-0275 | G5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 10: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0031-0276 | G5 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4f-002: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-002) |
| WK-SCP0031-0277 | G5 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4f-003: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SCP0031-0278 | G5 | MODAL:GlobalPsiModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:GlobalPsiModals: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiModals) |
| WK-SCP0031-0279 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0280 | G5 | ProgressForm(공통 로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm(공통 로딩): 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(공통 로딩)) |
| WK-SCP0031-0281 | G5 | SCP0031_GlobalPSI.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0031_GlobalPSI.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.SpdMain_CellDouble) |
| WK-SCP0031-0282 | H6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 10: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0031-0283 | H6 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4f-002: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-002) |
| WK-SCP0031-0284 | H6 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4f-003: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SCP0031-0285 | H6 | MODAL:GlobalPsiModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:GlobalPsiModals: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiModals) |
| WK-SCP0031-0286 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0287 | H6 | ProgressForm(공통 로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm(공통 로딩): 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(공통 로딩)) |
| WK-SCP0031-0288 | H6 | SCP0031_GlobalPSI.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0031_GlobalPSI.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.SpdMain_CellDouble) |
| WK-SCP0031-0289 | M3 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4f-002: 행 집계 — M3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-002) |
| WK-SCP0031-0290 | M3 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4f-003: 행 집계 — M3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SCP0031-0291 | M3 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — MODAL:ShowDialog: 행 집계 — M3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0292 | M4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 10: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0031-0293 | M4 | D00-4f-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4f-002: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-002) |
| WK-SCP0031-0294 | M4 | D00-4f-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4f-003: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4f-003) |
| WK-SCP0031-0295 | M4 | MODAL:GlobalPsiModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:GlobalPsiModals: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiModals) |
| WK-SCP0031-0296 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0031-0297 | M4 | ProgressForm(공통 로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm(공통 로딩): 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(공통 로딩)) |
| WK-SCP0031-0298 | M4 | SCP0031_GlobalPSI.SpdMain_CellDoubleClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0031_GlobalPSI.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0031_GlobalPSI.SpdMain_CellDouble) |
