# 작업 원장 — SCP0048 · 2026-10-26 12:53

> 검사 인스턴스 492건 중 PASS·NA 13건 외 **479건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 24 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 39 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 226 | 실행 → PASS |
| W7 | 기대값 확정 | 185 | 기대 확정 → PASS/FAIL |

- 담당: E2E 226 · 사람 판정 / AS-IS 원문 확인 → 재판정 183 · 하네스 44 · 대조표 26
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 53 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 44 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 24 |  |  |  |  | 19 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  | 22 | 8 |  |  | 연쇄 자동 채움 |
| A5 | DESIGN |  |  |  |  |  | 12 | 10 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 12 | 9 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 12 | 9 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 10 | 11 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D1 | EDIT |  |  |  |  |  | 12 | 6 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 12 | 6 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  | 9 | 3 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 9 | 3 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  | 1 | 10 |  |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 7 | 4 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D4 | EDIT |  |  |  |  |  | 8 | 3 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| G6 | GEN |  |  |  |  |  | 10 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| D5 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 셀 에디터 유형 |
| B4 | COMBO |  |  |  |  | 8 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E3 | EDIT |  |  |  |  |  | 1 | 7 |  |  | 필수 입력 검증 |
| DB-SYN | DB |  |  |  |  | 5 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 7 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| M4 | POPUP |  |  |  |  |  | 5 | 1 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  | 5 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| G5 | POPUP |  |  |  |  | 4 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 |  | 1 |  |  | 팝업 표준·열림 |
| E5 | EDIT |  |  |  |  | 4 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| E1 | EDIT |  |  |  |  |  | 3 | 1 |  |  | 숫자 소수자리·정수·부호·범위 |
| A6 | GEN |  |  |  |  |  | 1 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
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
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0048-0001 | X-LOC | ALWAYS_LOCK 감사·파생·키 컬럼 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0002 | X-LOC | DIVISION_ID 셀콤보(신규행 MyDivision) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0003 | X-LOC | R-C1 DIVISION_ID 신규행만 MyDivision | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-C1 DIVISION_ID 신규행만 MyDivision) |
| WK-SCP0048-0004 | X-LOC | R-C5 div=="82" → PLANT_SITE_ID 콤보 비움(.cs | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-C5 div=="82" → PLANT_SITE_ID 콤보 비움(.cs) |
| WK-SCP0048-0005 | X-LOC | R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0006 | X-LOC | R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN → | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0007 | X-LOC | R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0008 | X-LOC | R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 → | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0009 | X-LOC | R-D8 ITEM_ID 셀 더블클릭 → Item 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D8 ITEM_ID 셀 더블클릭 → Item 팝업) |
| WK-SCP0048-0010 | X-LOC | R-L1 Edit 토글 off → 전셀 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0011 | X-LOC | R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN ) |
| WK-SCP0048-0012 | X-LOC | R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0013 | X-LOC | R1 권한 division 0건 → SetDivisionAuthCheck | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 권한 division 0건 → SetDivisionAuthCheck) |
| WK-SCP0048-0014 | X-LOC | VALID_YN 셀콤보(YesOrNo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (VALID_YN 셀콤보(YesOrNo)) |
| WK-SCP0048-0015 | X-LOC | cboOperationGroup (LookupCommon) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboOperationGroup (LookupCommon)) |
| WK-SCP0048-0016 | X-LOC | cboValid (YesOrNo, ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboValid (YesOrNo, ALL)) |
| WK-SCP0048-0017 | X-LOC | clbDivision (`BLUtils.GetDivisionWithout | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0018 | X-LOC | clbPlantSite (division cascade, ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite (division cascade, ALL)) |
| WK-SCP0048-0019 | X-LOC | spdMain gridColumns=0 → DB 메타 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0020 | X-LOC | spdMain(FpSpread 단일 시트) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0048-0021 | X-LOC | txtItemId + btnItemId (Model) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0048-0022 | X-LOC | usrConditionPanel(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel(HidePanel)) |
| WK-SCP0048-0023 | X-LOC | 툴바 Search/Insert/Save/Delete/Excel + Edi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0024 | X-LOC | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0048-0025 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0026 | B3 | OPERATION_GROUP | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0048_ProjectRoute_Warranty.InitCo) |
| WK-SCP0048-0027 | B3 | PLANT_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0028 | B3 | cboOperationGroup / Operation Group | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group | 있음(FE 소스) | 1 (cboOperationGroup (LookupCommon)) |
| WK-SCP0048-0029 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 3 (clbDivision (`BLUtils.GetDivisionWithout) |

## W5 검사기 연결 (39)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0048-0030 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0048-0031 | B1 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 PCOL I | 판단불가(대상 단위 PCOL) | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0032 | B1 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0033 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 5 (COMMON:UC-05 ACT:SCP0048_ProjectRoute_Wa) |
| WK-SCP0048-0034 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0048-0035 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0048-0036 | B2 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 PCOL I | 판단불가(대상 단위 PCOL) | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0037 | B2 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0038 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 5 (COMMON:UC-05 ACT:SCP0048_ProjectRoute_Wa) |
| WK-SCP0048-0039 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0048-0040 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0048-0041 | B4 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 PCOL I | 판단불가(대상 단위 PCOL) | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0042 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0043 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0048_ProjectRoute_Warranty.InitCo) |
| WK-SCP0048-0044 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 7 (COMMON:UC-05 ACT:SCP0048_ProjectRoute_Wa) |
| WK-SCP0048-0045 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0048-0046 | B4 | cboOperationGroup / Operation Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group | 있음(FE 소스) | 1 (cboOperationGroup (LookupCommon)) |
| WK-SCP0048-0047 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 3 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0048 | F2 | SCP0048 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0048 화면 | 판단불가(대상 단위 SCREEN) | 133 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0049 | F6 | SCP0048 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0048 화면 | 판단불가(대상 단위 SCREEN) | 116 (P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 ) |
| WK-SCP0048-0050 | DB-SYN | DM0000_GET_COMMON_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0000_GET_COMMON_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 5 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0051 | DB-SYN | P_DEBUG_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DEBUG_MODE | 없음(PROC_M 대응 없음) | 1 (P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 ) |
| WK-SCP0048-0052 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetEnd) |
| WK-SCP0048-0053 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetDiv) |
| WK-SCP0048-0054 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetTea) |
| WK-SCP0048-0055 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (txtItemId + btnItemId (Model) ACT:SCP004) |
| WK-SCP0048-0056 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0048-0057 | E5 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 PCOL I | 판단불가(대상 단위 PCOL) | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0058 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0048-0059 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0048-0060 | G03-WIRE | SCP0048 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0048 화면 | 판단불가(대상 단위 SCREEN) | 18 (ACT:SCP0048_ItembyDivisionPopupEx..ctor ) |
| WK-SCP0048-0061 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 14 (R-D8 ITEM_ID 셀 더블클릭 → Item 팝업 ACT:SCP004) |
| WK-SCP0048-0062 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 17 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0063 | G5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 18 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0064 | G5 | SCP0048_ItembyDivisionPopupEx | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0048_ItembyDivisionPopupEx | 판단불가(대상 단위 POPUP) | 4 (ACT:SCP0048_ItembyDivisionPopupEx.spdMai) |
| WK-SCP0048-0065 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 14 (R-D8 ITEM_ID 셀 더블클릭 → Item 팝업 ACT:SCP004) |
| WK-SCP0048-0066 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 17 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0067 | H6 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 18 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0068 | H6 | SCP0048_ItembyDivisionPopupEx | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0048_ItembyDivisionPopupEx | 판단불가(대상 단위 POPUP) | 4 (ACT:SCP0048_ItembyDivisionPopupEx.spdMai) |

## W6 검증 실행 (226)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0048-0069 | J2 | SCP0048 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0048 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 61 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0070 | C1 | cboOperationGroup / Operation Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.InitCo) |
| WK-SCP0048-0071 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.InitCo) |
| WK-SCP0048-0072 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0073 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0074 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0075 | C1 | clbScmSite / Sales Site / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0076 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0077 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0078 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0079 | C2 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — N · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0080 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0081 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0082 | C2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0083 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0084 | C2 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0085 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0086 | C3 | ACTION_FLAG_DIV | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ACTION_FLAG_DIV · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0087 | C3 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.SetIte) |
| WK-SCP0048-0088 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0089 | C3 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0090 | C3 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.SetIte) |
| WK-SCP0048-0091 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 18 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0092 | C3 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — N · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0093 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0094 | C3 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0095 | C3 | ORG_FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0096 | C3 | ORG_TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0097 | C3 | ORG_VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0098 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0099 | C3 | PLANT_SITE_ID_B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID_B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0100 | C3 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0101 | C3 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0102 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0103 | C3 | ROW_COLOR_INDEX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ROW_COLOR_INDEX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0104 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0105 | C3 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0106 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0107 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0108 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0109 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0110 | C6 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — N · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0111 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0112 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0113 | C6 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0114 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0115 | C6 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0116 | C6 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0117 | G3 | SCP0048 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0048 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (usrConditionPanel(HidePanel) COMMON:UC-0) |
| WK-SCP0048-0118 | K-SA | SCP0048 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0048 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (usrConditionPanel(HidePanel) COMMON:UC-0) |
| WK-SCP0048-0119 | K4 | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 26 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0048-0120 | F1 | SCP0048 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0048 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 143 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0121 | F3 | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 19 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 ACT:SCP0048) |
| WK-SCP0048-0122 | F5 | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 12 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0123 | F4 | DM0000_GET_COMMON_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 24 (ACT:SCP0048_ItembyDivisionPopupEx.FindBu) |
| WK-SCP0048-0124 | F4 | PKG_SCP0048.P_SCP0048_SAVE_PROJECTROUTE_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0048.P_SCP0048_SAVE_PROJECTROUTE_WARRANTY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 1 (P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 ) |
| WK-SCP0048-0125 | F4 | P_DEBUG_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DEBUG_MODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 ) |
| WK-SCP0048-0126 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetEnd) |
| WK-SCP0048-0127 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetDiv) |
| WK-SCP0048-0128 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetDiv) |
| WK-SCP0048-0129 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.GetTea) |
| WK-SCP0048-0130 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (DIVISION_ID 셀콤보(신규행 MyDivision) PLANT_SI) |
| WK-SCP0048-0131 | A5 | I | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — I · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (DIVISION_ID 셀콤보(신규행 MyDivision) R-C1 DIV) |
| WK-SCP0048-0132 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0133 | A5 | N | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — N · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0134 | A5 | NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0135 | A5 | OPERATION_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0136 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0137 | A5 | PRIORITY_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0138 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0139 | A5 | SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0140 | A5 | TACT_TIME_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0141 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (VALID_YN 셀콤보(YesOrNo) R-D3 VALID_YN 되돌림() |
| WK-SCP0048-0142 | G4 | cboOperationGroup / Operation Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboOperationGroup (LookupCommon) ACT:SCP) |
| WK-SCP0048-0143 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboValid (YesOrNo, ALL) ACT:SCP0048_Proj) |
| WK-SCP0048-0144 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0145 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0146 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbPlantSite (division cascade, ALL)) |
| WK-SCP0048-0147 | G4 | clbScmSite / Sales Site / Scm Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0148 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0149 | G4 | txtItemID / Plant Site / Item ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemID / Plant Site / Item ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0150 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0048-0151 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0152 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (DIVISION_ID 셀콤보(신규행 MyDivision) PLANT_SI) |
| WK-SCP0048-0153 | H2 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (DIVISION_ID 셀콤보(신규행 MyDivision) R-C1 DIV) |
| WK-SCP0048-0154 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0155 | H2 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — N · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0156 | H2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0157 | H2 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0158 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0159 | H2 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0160 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0161 | H2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0162 | H2 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0163 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (VALID_YN 셀콤보(YesOrNo) R-D3 VALID_YN 되돌림() |
| WK-SCP0048-0164 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (DIVISION_ID 셀콤보(신규행 MyDivision) PLANT_SI) |
| WK-SCP0048-0165 | H5 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — I · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (DIVISION_ID 셀콤보(신규행 MyDivision) R-C1 DIV) |
| WK-SCP0048-0166 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0167 | H5 | N | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — N · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0168 | H5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NICK_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0169 | H5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_GROUP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0170 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0171 | H5 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRIORITY_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0172 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0173 | H5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCM_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0174 | H5 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TACT_TIME_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마) |
| WK-SCP0048-0175 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (VALID_YN 셀콤보(YesOrNo) R-D3 VALID_YN 되돌림() |
| WK-SCP0048-0176 | I1 | SCP0048 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0048 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 34 (R1 권한 division 0건 → SetDivisionAuthCheck) |
| WK-SCP0048-0177 | SC1 | SCP0048 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0048 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 5 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0178 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0179 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (R-C1 DIVISION_ID 신규행만 MyDivision R-C5 di) |
| WK-SCP0048-0180 | D1 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R-C1 DIVISION_ID 신규행만 MyDivision) |
| WK-SCP0048-0181 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0182 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0183 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0184 | D1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN ) |
| WK-SCP0048-0185 | D1 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0186 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0187 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.Insert) |
| WK-SCP0048-0188 | D1 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0189 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN ) |
| WK-SCP0048-0190 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0191 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (R-C1 DIVISION_ID 신규행만 MyDivision R-C5 di) |
| WK-SCP0048-0192 | D3 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — I · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-C1 DIVISION_ID 신규행만 MyDivision) |
| WK-SCP0048-0193 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0194 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0195 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0196 | D3 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN ) |
| WK-SCP0048-0197 | D3 | PRIORITY_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRIORITY_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0198 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SIT) |
| WK-SCP0048-0199 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.Insert) |
| WK-SCP0048-0200 | D3 | TACT_TIME_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TACT_TIME_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0201 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN ) |
| WK-SCP0048-0202 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (DIVISION_ID 셀콤보(신규행 MyDivision) R-D4 DIV) |
| WK-SCP0048-0203 | D4 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0048-0204 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0205 | D4 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0206 | D4 | P | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — P · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert(신규행, opGroup P/A silent 차단)) |
| WK-SCP0048-0207 | D4 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0208 | D4 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0209 | D4 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM) |
| WK-SCP0048-0210 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0048-0211 | D5 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — I · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) ACT:SCP0) |
| WK-SCP0048-0212 | D5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0213 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (COMMON:UC-05 ACT:SCP0048_ProjectRoute_Wa) |
| WK-SCP0048-0214 | D5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0215 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0216 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0048-0217 | D6 | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0218 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0219 | E1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0220 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0221 | E3 | I | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E3 실행 — I · 검사기 있음(_verify.spec(@verify) 화면 단위 · _trace.spec(@trace) W4b 컬럼 단위(필수 공란 Save → 메시지, 저장 차단)) — 실행 필요 |  | 1 (Save) |
| WK-SCP0048-0222 | E4 | ACTION_FLAG_DIV | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ACTION_FLAG_DIV · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0223 | E4 | CURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CURRENCY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.SetIte) |
| WK-SCP0048-0224 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0225 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0226 | E4 | I | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — I · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (Save ACT:SCP0048_ItembyDivisionPopupEx.S) |
| WK-SCP0048-0227 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0228 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (AS-IS MSG00002→TO-BE MSG00429 ACT:SCP004) |
| WK-SCP0048-0229 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0230 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0231 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048/MSG00219 ACT:SCP0048_ProjectRou) |
| WK-SCP0048-0232 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0233 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R1 권한 division 0건 → SetDivisionAuthCheck) |
| WK-SCP0048-0234 | E4 | MSG00107 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00107 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00107 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0235 | E4 | MSG00147 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00147 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0048_ItembyDivisionPopupEx.Form_L) |
| WK-SCP0048-0236 | E4 | MSG00211 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00211 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0237 | E4 | MSG00212 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00212 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00212 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0238 | E4 | MSG00213 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00213 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00213 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0239 | E4 | MSG00214 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00214 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00214 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0240 | E4 | MSG00215 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00215 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00215 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0241 | E4 | MSG00216 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00216 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0242 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048/MSG00219 ACT:SCP0048_ProjectRou) |
| WK-SCP0048-0243 | E4 | MSG00220 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00220 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00220 ACT:SCP0048_ProjectRoute_Warran) |
| WK-SCP0048-0244 | E4 | MSG00259 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00259 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0245 | E4 | MSG00322 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00322 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (AS-IS MSG00322→TO-BE MSG01319 ACT:SCP004) |
| WK-SCP0048-0246 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (AS-IS MSG00002→TO-BE MSG00429) |
| WK-SCP0048-0247 | E4 | MSG01222 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01222 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0248 | E4 | MSG01319 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01319 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (AS-IS MSG00322→TO-BE MSG01319) |
| WK-SCP0048-0249 | E4 | N | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — N · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0250 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0251 | E4 | ORG_FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0252 | E4 | ORG_TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0253 | E4 | ORG_VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0254 | E4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0255 | E4 | PLANT_SITE_ID_B | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID_B · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0256 | E4 | PRIORITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (AS-IS MSG00322→TO-BE MSG01319 ACT:SCP004) |
| WK-SCP0048-0257 | E4 | PRIORITY_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY_SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0258 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (AS-IS MSG00002→TO-BE MSG00429 ACT:SCP004) |
| WK-SCP0048-0259 | E4 | ROW_COLOR_INDEX | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ROW_COLOR_INDEX · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0260 | E4 | S | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — S · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0261 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (AS-IS MSG00002→TO-BE MSG00429 ACT:SCP004) |
| WK-SCP0048-0262 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0263 | E4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN →) |
| WK-SCP0048-0264 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0265 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0266 | A10 | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 82 (ACT:SCP0048_ItembyDivisionPopupEx.Define) |
| WK-SCP0048-0267 | A6 | DM0000_GET_COMMON_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 22 (ACT:SCP0048_ItembyDivisionPopupEx.FindBu) |
| WK-SCP0048-0268 | G1 | cboOperationGroup / Operation Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboOperationGroup (LookupCommon) ACT:SCP) |
| WK-SCP0048-0269 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboValid (YesOrNo, ALL) ACT:SCP0048_Proj) |
| WK-SCP0048-0270 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0271 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0272 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (clbPlantSite (division cascade, ALL) ACT) |
| WK-SCP0048-0273 | G1 | clbScmSite / Sales Site / Scm Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0274 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0275 | G1 | txtItemID / Plant Site / Item ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemID / Plant Site / Item ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0276 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtItemId + btnItemId (Model) ACT:SCP004) |
| WK-SCP0048-0277 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0278 | G6 | cboOperationGroup / Operation Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboOperationGroup (LookupCommon) ACT:SCP) |
| WK-SCP0048-0279 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboValid (YesOrNo, ALL) ACT:SCP0048_Proj) |
| WK-SCP0048-0280 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 10 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0281 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0282 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbPlantSite (division cascade, ALL)) |
| WK-SCP0048-0283 | G6 | clbScmSite / Sales Site / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0284 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0285 | G6 | txtItemID / Plant Site / Item ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemID / Plant Site / Item ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0286 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0048-0287 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0288 | X-REOPEN | SCP0048 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0048 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:SCP0048_ItembyDivisionPopupEx.Dispos) |
| WK-SCP0048-0289 | M3 | SCP0048_ItembyDivisionPopupEx | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0048_ItembyDivisionPopupEx · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 20 (ACT:SCP0048_ItembyDivisionPopupEx..ctor ) |
| WK-SCP0048-0290 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0291 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (R-D8 ITEM_ID 셀 더블클릭 → Item 팝업 ACT:SCP004) |
| WK-SCP0048-0292 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 17 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0293 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 18 (R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 →) |
| WK-SCP0048-0294 | M4 | SCP0048_ItembyDivisionPopupEx | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0048_ItembyDivisionPopupEx · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.spdMai) |

## W7 기대값 확정 (185)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0048-0295 | C2 | SCP0048_ProjectRoute_Warranty.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0048_ProjectRoute_Warranty.ClbDivision_Selected: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.ClbDiv) |
| WK-SCP0048-0296 | C2 | SCP0048_ProjectRoute_Warranty.cboOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0048_ProjectRoute_Warranty.cboOperationGroup_Se: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.cboOpe) |
| WK-SCP0048-0297 | C2 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0298 | C3 | SCP0048_ProjectRoute_Warranty.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.ClbDivision_Selected: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.ClbDiv) |
| WK-SCP0048-0299 | C3 | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedControl: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0048-0300 | C3 | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedPeriod: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0301 | C3 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0302 | C3 | SCP0048_ProjectRoute_Warranty.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetOrgData: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0303 | C3 | SCP0048_ProjectRoute_Warranty.cboOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.cboOperationGroup_Se: 진입점 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.cboOpe) |
| WK-SCP0048-0304 | C3 | SCP0048_ProjectRoute_Warranty.set_ValidD | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0048_ProjectRoute_Warranty.set_ValidDataSet: 진입점 집계 — C3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0305 | C3 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — C3 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0306 | C6 | SCP0048_ProjectRoute_Warranty.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0048_ProjectRoute_Warranty.ClbDivision_Selected: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.ClbDiv) |
| WK-SCP0048-0307 | C6 | SCP0048_ProjectRoute_Warranty.cboOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0048_ProjectRoute_Warranty.cboOperationGroup_Se: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.cboOpe) |
| WK-SCP0048-0308 | C6 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0309 | DB-SYN | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0310 | DB-SYN | SCP0048_ProjectRoute_Warranty.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0048_ProjectRoute_Warranty.SaveData: 진입점 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0311 | F4 | SCP0048_ProjectRoute_Warranty.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindButton: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.FindBu) |
| WK-SCP0048-0312 | F4 | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0313 | F4 | SCP0048_ProjectRoute_Warranty.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SaveButton: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SaveBu) |
| WK-SCP0048-0314 | F4 | SCP0048_ProjectRoute_Warranty.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SaveData: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0315 | A5 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0316 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0048-0317 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0048-0318 | A5 | R-L1 Edit 토글 off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-L1 Edit 토글 off → 전셀 잠금: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0319 | A5 | SCP0048_ProjectRoute_Warranty.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0048_ProjectRoute_Warranty.CreateSpread: 진입점 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.Create) |
| WK-SCP0048-0320 | A5 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0321 | A5 | cboOperationGroup (LookupCommon) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — cboOperationGroup (LookupCommon): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (cboOperationGroup (LookupCommon)) |
| WK-SCP0048-0322 | A5 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0323 | A5 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0048-0324 | A5 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0325 | H2 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0326 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0048-0327 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0048-0328 | H2 | R-L1 Edit 토글 off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-L1 Edit 토글 off → 전셀 잠금: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0329 | H2 | SCP0048_ProjectRoute_Warranty.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0048_ProjectRoute_Warranty.CreateSpread: 진입점 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.Create) |
| WK-SCP0048-0330 | H2 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0331 | H2 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0332 | H2 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0048-0333 | H2 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — H2 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0334 | H5 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0335 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0048-0336 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0048-0337 | H5 | R-L1 Edit 토글 off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-L1 Edit 토글 off → 전셀 잠금: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0338 | H5 | SCP0048_ProjectRoute_Warranty.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0048_ProjectRoute_Warranty.CreateSpread: 진입점 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.Create) |
| WK-SCP0048-0339 | H5 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0340 | H5 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0341 | H5 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0048-0342 | H5 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — H5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0343 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 — 해당없음: 이 화면은 Column/Measure 설정 UI(Colum |  | 1 (COMMON:UC-03) |
| WK-SCP0048-0344 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 — 해당없음: 조회조건 Model 은 단일 품번 픽커(ItemByDivisionModal, callFromCell= |  | 1 (COMMON:UC-06) |
| WK-SCP0048-0345 | D1 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0346 | D1 | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0347 | D1 | R-L1 Edit 토글 off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-L1 Edit 토글 off → 전셀 잠금: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0348 | D1 | SCP0048_ProjectRoute_Warranty.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0048_ProjectRoute_Warranty.EditButton: 진입점 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0349 | D1 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0350 | D1 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0351 | D3 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0048-0352 | D3 | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0353 | D3 | R-L1 Edit 토글 off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-L1 Edit 토글 off → 전셀 잠금: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-L1 Edit 토글 off → 전셀 잠금) |
| WK-SCP0048-0354 | D3 | SCP0048_ProjectRoute_Warranty.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0048_ProjectRoute_Warranty.EditButton: 진입점 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0048_ProjectRoute_Warranty.EditBu) |
| WK-SCP0048-0355 | D3 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0356 | D3 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0357 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0048-0358 | D4 | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0359 | D4 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0360 | D5 | SCP0048_ProjectRoute_Warranty.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0048_ProjectRoute_Warranty.CreateSpread: 진입점 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.Create) |
| WK-SCP0048-0361 | D5 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0362 | E1 | 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동: 행 집계 — E1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (파생(R-D1/R-D3/R-D4) 붙여넣기에도 발동) |
| WK-SCP0048-0363 | E3 | MSG00048/MSG00219 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00048/MSG00219: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00048/MSG00219) |
| WK-SCP0048-0364 | E3 | MSG00107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00107: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00107) |
| WK-SCP0048-0365 | E3 | MSG00212 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00212: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00212) |
| WK-SCP0048-0366 | E3 | MSG00213 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00213: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00213) |
| WK-SCP0048-0367 | E3 | MSG00214 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00214: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00214) |
| WK-SCP0048-0368 | E3 | MSG00215 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00215: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00215) |
| WK-SCP0048-0369 | E3 | MSG00220 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — MSG00220: 행 집계 — E3 4요소: PASS:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MSG00220) |
| WK-SCP0048-0370 | E4 | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0048-0371 | E4 | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedPeriod: 진입점 집계 — E4 44요소: NOT_RUN:44 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0372 | E4 | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0373 | E4 | SCP0048_ProjectRoute_Warranty.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetOrgData: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0374 | E4 | SCP0048_ProjectRoute_Warranty.set_ValidD | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0048_ProjectRoute_Warranty.set_ValidDataSet: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0048_ProjectRoute_Warranty.set_Va) |
| WK-SCP0048-0375 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0048-0376 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0048-0377 | A1 | DM0000_GET_COMMON_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(DM0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 22 (ACT:SCP0048_ItembyDivisionPopupEx.FindBu) |
| WK-SCP0048-0378 | A1 | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0379 | A1 | PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperation_SCP 3-: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0380 | A1 | PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선, 비면 PLANT: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선) |
| WK-SCP0048-0381 | A1 | R1 권한 division 0건 → SetDivisionAuthCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R1 권한 division 0건 → SetDivisionAuthCheck: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R1 권한 division 0건 → SetDivisionAuthCheck) |
| WK-SCP0048-0382 | A1 | SCP0048_ProjectRoute_Warranty.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindButton: 진입점 집계 — A1 1요소: REVIEW:1 |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.FindBu) |
| WK-SCP0048-0383 | A1 | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 — A1 1요소: REVIEW:1 |  | 24 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0384 | A1 | Search(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Search(F5): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (Search(F5)) |
| WK-SCP0048-0385 | A1 | cboOperationGroup (LookupCommon) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperationGroup (LookupCommon): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboOperationGroup (LookupCommon)) |
| WK-SCP0048-0386 | A1 | cboValid (YesOrNo, ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValid (YesOrNo, ALL): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboValid (YesOrNo, ALL)) |
| WK-SCP0048-0387 | A1 | clbDivision (`BLUtils.GetDivisionWithout | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision (`BLUtils.GetDivisionWithoutEE` 2단계): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (clbDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0048-0388 | A1 | clbPlantSite (division cascade, ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (division cascade, ALL): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (clbPlantSite (division cascade, ALL)) |
| WK-SCP0048-0389 | A1 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0390 | A1 | txtItemId + btnItemId (Model) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId (Model): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0048-0391 | A1 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0392 | A6 | SCP0048_ProjectRoute_Warranty.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindButton: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.FindBu) |
| WK-SCP0048-0393 | A6 | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0394 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0048-0395 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0048-0396 | G1 | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0397 | G1 | PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperation_SCP 3-: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0048-0398 | G1 | PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선, 비면 PLANT: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선) |
| WK-SCP0048-0399 | G1 | R1 권한 division 0건 → SetDivisionAuthCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R1 권한 division 0건 → SetDivisionAuthCheck: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R1 권한 division 0건 → SetDivisionAuthCheck) |
| WK-SCP0048-0400 | G1 | SCP0048_ProjectRoute_Warranty.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindButton: 진입점 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.FindBu) |
| WK-SCP0048-0401 | G1 | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0402 | G1 | Search(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Search(F5): 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Search(F5)) |
| WK-SCP0048-0403 | G1 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0048-0404 | G1 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0048-0405 | X-LOC | AS-IS MSG00002→TO-BE MSG00429 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS MSG00002→TO-BE MSG00429: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS MSG00002→TO-BE MSG00429) |
| WK-SCP0048-0406 | X-LOC | AS-IS MSG00322→TO-BE MSG01319 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS MSG00322→TO-BE MSG01319: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS MSG00322→TO-BE MSG01319) |
| WK-SCP0048-0407 | X-LOC | Delete('I'행만, 알림 없음) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Delete('I'행만, 알림 없음): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Delete('I'행만, 알림 없음)) |
| WK-SCP0048-0408 | X-LOC | Edit 토글(SwitchLock, R-L1/R-G2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit 토글(SwitchLock, R-L1/R-G2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit 토글(SwitchLock, R-L1/R-G2)) |
| WK-SCP0048-0409 | X-LOC | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel) |
| WK-SCP0048-0410 | X-LOC | ITEM_ID `.ToUpper()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ITEM_ID `.ToUpper()`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ITEM_ID `.ToUpper()`) |
| WK-SCP0048-0411 | X-LOC | Insert(신규행, opGroup P/A silent 차단) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert(신규행, opGroup P/A silent 차단): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert(신규행, opGroup P/A silent 차단)) |
| WK-SCP0048-0412 | X-LOC | MSG00048/MSG00219 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00048/MSG00219: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00048/MSG00219) |
| WK-SCP0048-0413 | X-LOC | MSG00107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00107: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00107) |
| WK-SCP0048-0414 | X-LOC | MSG00212 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00212: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00212) |
| WK-SCP0048-0415 | X-LOC | MSG00213 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00213: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00213) |
| WK-SCP0048-0416 | X-LOC | MSG00214 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00214: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00214) |
| WK-SCP0048-0417 | X-LOC | MSG00215 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00215: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00215) |
| WK-SCP0048-0418 | X-LOC | MSG00220 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00220: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00220) |
| WK-SCP0048-0419 | X-LOC | PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선, 비면 PLANT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B 우선) |
| WK-SCP0048-0420 | X-LOC | PRIORITY_SEQ 빈값 → 'M'→'I' 승격 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PRIORITY_SEQ 빈값 → 'M'→'I' 승격: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PRIORITY_SEQ 빈값 → 'M'→'I' 승격) |
| WK-SCP0048-0421 | X-LOC | P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 args = 14 : 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 ) |
| WK-SCP0048-0422 | X-LOC | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Save) |
| WK-SCP0048-0423 | X-LOC | Search(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Search(F5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Search(F5)) |
| WK-SCP0048-0424 | X-ROW | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Excel: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Excel) |
| WK-SCP0048-0425 | X-ROW | SCP0048_ItembyDivisionPopupEx..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx..ctor:) |
| WK-SCP0048-0426 | X-ROW | SCP0048_ItembyDivisionPopupEx.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0048_ItembyDivisionPopupEx.Create) |
| WK-SCP0048-0427 | X-ROW | SCP0048_ItembyDivisionPopupEx.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.Define) |
| WK-SCP0048-0428 | X-ROW | SCP0048_ItembyDivisionPopupEx.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.Dispos) |
| WK-SCP0048-0429 | X-ROW | SCP0048_ItembyDivisionPopupEx.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.FindBu) |
| WK-SCP0048-0430 | X-ROW | SCP0048_ItembyDivisionPopupEx.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.FindData: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · NOPATH:1 |  | 19 (ACT:SCP0048_ItembyDivisionPopupEx.FindDa) |
| WK-SCP0048-0431 | X-ROW | SCP0048_ItembyDivisionPopupEx.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0048_ItembyDivisionPopupEx.Form_L) |
| WK-SCP0048-0432 | X-ROW | SCP0048_ItembyDivisionPopupEx.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.GetDivision: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0048_ItembyDivisionPopupEx.GetDiv) |
| WK-SCP0048-0433 | X-ROW | SCP0048_ItembyDivisionPopupEx.GetDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.GetDivisionbyScmSite: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0048_ItembyDivisionPopupEx.GetDiv) |
| WK-SCP0048-0434 | X-ROW | SCP0048_ItembyDivisionPopupEx.GetEndCust | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.GetEndCustomerbyDivi: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0048_ItembyDivisionPopupEx.GetEnd) |
| WK-SCP0048-0435 | X-ROW | SCP0048_ItembyDivisionPopupEx.GetSpdTitl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.GetSpdTitle: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0048_ItembyDivisionPopupEx.GetSpd) |
| WK-SCP0048-0436 | X-ROW | SCP0048_ItembyDivisionPopupEx.GetTeambyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.GetTeambyDivision: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0048_ItembyDivisionPopupEx.GetTea) |
| WK-SCP0048-0437 | X-ROW | SCP0048_ItembyDivisionPopupEx.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.InitControls: 진입점 집계 20검사 — NOT_RUN:18 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCP0048_ItembyDivisionPopupEx.InitCo) |
| WK-SCP0048-0438 | X-ROW | SCP0048_ItembyDivisionPopupEx.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0048_ItembyDivisionPopupEx.InitSp) |
| WK-SCP0048-0439 | X-ROW | SCP0048_ItembyDivisionPopupEx.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.InitSpread_X: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.InitSp) |
| WK-SCP0048-0440 | X-ROW | SCP0048_ItembyDivisionPopupEx.SetItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.SetItem: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCP0048_ItembyDivisionPopupEx.SetIte) |
| WK-SCP0048-0441 | X-ROW | SCP0048_ItembyDivisionPopupEx.btnButtonL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.btnButtonList_UsrBut: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0048_ItembyDivisionPopupEx.btnBut) |
| WK-SCP0048-0442 | X-ROW | SCP0048_ItembyDivisionPopupEx.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.clbDivision_Selected: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.clbDiv) |
| WK-SCP0048-0443 | X-ROW | SCP0048_ItembyDivisionPopupEx.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.spdMain_CellDoubleCl: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ItembyDivisionPopupEx.spdMai) |
| WK-SCP0048-0444 | X-ROW | SCP0048_ItembyDivisionPopupEx.txtItemID_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ItembyDivisionPopupEx.txtItemID_KeyDown: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0048_ItembyDivisionPopupEx.txtIte) |
| WK-SCP0048-0445 | X-ROW | SCP0048_ProjectRoute_Warranty.ClbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.ClbDivision_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.ClbDiv) |
| WK-SCP0048-0446 | X-ROW | SCP0048_ProjectRoute_Warranty.ClearUsrCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET,  |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.ClearU) |
| WK-SCP0048-0447 | X-ROW | SCP0048_ProjectRoute_Warranty.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.Create) |
| WK-SCP0048-0448 | X-ROW | SCP0048_ProjectRoute_Warranty.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.Define) |
| WK-SCP0048-0449 | X-ROW | SCP0048_ProjectRoute_Warranty.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.FindBu) |
| WK-SCP0048-0450 | X-ROW | SCP0048_ProjectRoute_Warranty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.FindData: 진입점 집계 11검사 — NOT_RUN:6 · REVIEW:3 · NOPATH:2 |  | 6 (ACT:SCP0048_ProjectRoute_Warranty.FindDa) |
| WK-SCP0048-0451 | X-ROW | SCP0048_ProjectRoute_Warranty.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.Form_L) |
| WK-SCP0048-0452 | X-ROW | SCP0048_ProjectRoute_Warranty.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.InitControls: 진입점 집계 14검사 — NOT_RUN:10 · NOPATH:3 · TODO:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.InitCo) |
| WK-SCP0048-0453 | X-ROW | SCP0048_ProjectRoute_Warranty.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.InitSp) |
| WK-SCP0048-0454 | X-ROW | SCP0048_ProjectRoute_Warranty.InsertButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.Insert) |
| WK-SCP0048-0455 | X-ROW | SCP0048_ProjectRoute_Warranty.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.InsertRow: 진입점 집계 16검사 — NOT_RUN:13 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCP0048_ProjectRoute_Warranty.Insert) |
| WK-SCP0048-0456 | X-ROW | SCP0048_ProjectRoute_Warranty.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SaveData: 진입점 집계 10검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:1 |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SaveDa) |
| WK-SCP0048-0457 | X-ROW | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0458 | X-ROW | SCP0048_ProjectRoute_Warranty.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetChangedPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetCha) |
| WK-SCP0048-0459 | X-ROW | SCP0048_ProjectRoute_Warranty.SetImageCe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetImageCell: 진입점 집계 30검사 — NOT_RUN:24 · REVIEW:6 |  | 3 (ACT:SCP0048_ProjectRoute_Warranty.SetIma) |
| WK-SCP0048-0460 | X-ROW | SCP0048_ProjectRoute_Warranty.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SetOrgData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:2 |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SetOrg) |
| WK-SCP0048-0461 | X-ROW | SCP0048_ProjectRoute_Warranty.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SpdMain_CellClick: 진입점 집계 10검사 — NOT_RUN:5 · NOPATH:4 · TODO:1 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0462 | X-ROW | SCP0048_ProjectRoute_Warranty.SpdMain_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.SpdMain_ClipboardPas: 진입점 집계 8검사 — NOT_RUN:7 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0048_ProjectRoute_Warranty.SpdMai) |
| WK-SCP0048-0463 | X-ROW | SCP0048_ProjectRoute_Warranty.btnItemId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0048_ProjectRoute_Warranty.btnIte) |
| WK-SCP0048-0464 | X-ROW | SCP0048_ProjectRoute_Warranty.cboOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.cboOperationGroup_Se: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0048_ProjectRoute_Warranty.cboOpe) |
| WK-SCP0048-0465 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN1: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0466 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN10: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 27 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0467 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN11: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0468 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN2: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0469 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN3: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 39 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0470 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN4: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 40 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0471 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN5: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 74 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0472 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN7: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0473 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN8: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0474 | X-ROW | SCP0048_ProjectRoute_Warranty.checkValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.checkValidN9: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 29 (ACT:SCP0048_ProjectRoute_Warranty.checkV) |
| WK-SCP0048-0475 | X-ROW | SCP0048_ProjectRoute_Warranty.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.spdMain_CellDoubleCl: 진입점 집계 25검사 — NOT_RUN:14 · NOPATH:8 · REVIEW:3 |  | 7 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0476 | X-ROW | SCP0048_ProjectRoute_Warranty.spdMain_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0048_ProjectRoute_Warranty.spdMain_Change: 진입점 집계 24검사 — NOT_RUN:16 · NOPATH:6 · TODO:2 (미실행 검사가 남아 판정필요) |  | 62 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0477 | G5 | SCP0048_ProjectRoute_Warranty.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0048_ProjectRoute_Warranty.spdMain_CellDoubleCl: 진입점 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0478 | H6 | SCP0048_ProjectRoute_Warranty.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0048_ProjectRoute_Warranty.spdMain_CellDoubleCl: 진입점 집계 — H6 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
| WK-SCP0048-0479 | M4 | SCP0048_ProjectRoute_Warranty.spdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0048_ProjectRoute_Warranty.spdMain_CellDoubleCl: 진입점 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0048_ProjectRoute_Warranty.spdMai) |
