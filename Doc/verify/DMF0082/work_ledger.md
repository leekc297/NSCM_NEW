# 작업 원장 — DMF0082 · 2026-10-31 15:40

> 검사 인스턴스 1840건 중 PASS·NA 1307건 외 **533건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 188 | 재판정 PASS |
| W5 | 검사기 연결 | 68 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 6 | 실행 → PASS |
| W7 | 기대값 확정 | 158 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 113 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 142 · 하네스·환경 113 · 사람판정 88 · 하네스 68 · 화면 FE 46 · DB 객체 41 · 대조표 16 · DB 메타 13 · E2E 6
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 53 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 1 |  |  | 46 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  |  | 4 |  | 39 | 팝업 선택값 반영 |
| F4 | DB |  |  | 41 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-ROW | GEN |  |  | 22 |  |  |  | 10 |  | 6 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G5 | POPUP |  |  | 20 |  | 18 |  |  |  |  | 팝업 조건 연동(인자) |
| X-LOC | GEN |  |  |  |  |  |  | 30 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  | 16 |  |  |  | 8 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B4 | COMBO |  |  | 13 |  | 8 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  | 12 |  | 7 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| G4 | DESIGN |  |  | 17 |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| H6 | POPUP |  |  |  |  | 14 | 4 |  |  |  | 팝업 표준·열림 |
| E3 | EDIT |  |  |  |  |  |  | 18 |  |  | 필수 입력 검증 |
| A6 | GEN |  |  |  |  |  |  | 17 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 16 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D4 | EDIT |  |  | 15 |  |  |  |  |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| H2 | DESIGN |  |  | 14 |  |  |  |  |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 10 | 라벨 명칭 |
| C2 | CASCADE |  |  | 8 |  |  |  |  |  |  | 그리드 셀 cascade 후보 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 8 | 연쇄 자동 채움 |
| B1 | COMBO |  |  | 3 |  | 4 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  |  |  | 3 | 콤보 후보 중복 없음 |
| D5 | EDIT |  |  | 6 |  |  |  |  |  |  | 셀 에디터 유형 |
| DB-SYN | DB |  |  |  |  | 5 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  | 4 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| E2 | EDIT |  |  |  |  | 2 |  |  |  |  | 날짜 형식·유효성 |
| G3 | COMMON |  |  | 1 |  |  |  |  |  |  | 조회조건 저장·복원 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |

## W3 동작 수정 (188)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0001 | C2 | DIVISION_ID / Division | 화면 FE(적용 예정) | C2 FAIL 수정 — DIVISION_ID / Division: 실측[T-0d37e73a]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (FX-DMF0082-632) |  | 6 (D-17 D-18 HANDLER:spdMain_ComboSelChange) |
| WK-DMF0082-0002 | C2 | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | 화면 FE(적용 예정) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedIndexChanged: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.cboBucketType_Select |  | 29 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0003 | C2 | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 화면 FE(적용 예정) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged 의 C2 50요소:  |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0004 | C2 | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 화면 FE(적용 예정) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexChanged: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIn |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0005 | C2 | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 화면 FE(적용 예정) | C2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChanged: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChang |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0006 | C2 | E01 | 화면 FE(적용 예정) | C2 FAIL 수정 — E01: 행 집계 — 대조표 E01 'spdMain_Changed — 셀 값 변경·배분 엔진 (md §1)' 의 C2 50요소: NA:49 · FAIL:1 · FAIL 요소: DIVISION_ID / Divis |  | 1 (E01) |
| WK-DMF0082-0007 | C2 | HANDLER:spdMain_Changed | 화면 FE(적용 예정) | C2 FAIL 수정 — HANDLER:spdMain_Changed: 행 집계 — 대조표 HANDLER:spdMain_Changed 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:5537` (라이브 834행)' 의 C2 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0082-0008 | C2 | REQ:1ST-48-3 | 화면 FE(적용 예정) | C2 FAIL 수정 — REQ:1ST-48-3: 행 집계 — 대조표 REQ:1ST-48-3 "잔존 데이터 저장 시 '수정 데이터 없음' 팝업 해소" 의 C2 50요소: NA:49 · FAIL:1 · FAIL 요소: DIVISION_I |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0009 | B1 | A-11 | 화면 FE(적용 예정) | B1 FAIL 수정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 B1 16요소: PASS:7 · NOPATH:4 · NA:4 · FAIL: |  | 1 (A-11) |
| WK-DMF0082-0010 | B1 | COMMON:UC-05 | 화면 FE(적용 예정) | B1 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B1 16요소: PASS:7 · NOPATH |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0011 | B1 | CURRENCY / Currency | 화면 FE(적용 예정) | B1 FAIL 수정 — CURRENCY / Currency: 원장 V-a1173add COLUMN (FX-DMF0082-155) |  | 4 (M-08 ACT:DMF0082_FcstNPrice_Mgmt.InsertR) |
| WK-DMF0082-0012 | B3 | A-11 | 화면 FE(적용 예정) | B3 FAIL 수정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 B3 16요소: NOPATH:7 · NA:4 · PASS:3 · FAIL: |  | 1 (A-11) |
| WK-DMF0082-0013 | B3 | DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivi | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision 의 B3 16요소: NO |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetBizTypeby) |
| WK-DMF0082-0014 | B3 | DMF0082_FcstNPrice_Mgmt.GetBucketType | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetBucketType 의 B3 16요소: NOPATH:7 · NA:4  |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0015 | B3 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook 의 B3 16요소: NOPATH |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0016 | B3 | DMF0082_FcstNPrice_Mgmt.GetDayRange | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetDayRange 의 B3 16요소: NOPATH:7 · NA:4 · PA |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0017 | B3 | DMF0082_FcstNPrice_Mgmt.GetFcstType | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetFcstType 의 B3 1요소: FAIL:1 · FAIL 요소: FCS |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0018 | B3 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetLookupValues 의 B3 16요소: NOPATH:7 · N |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0019 | B3 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite 의 B3 16요소: NOPATH:7 · NA:4 ·  |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0020 | B3 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite40 의 B3 16요소: NOPATH:7 · NA: |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0021 | B3 | DMF0082_FcstNPrice_Mgmt.getDayOfWeek | 화면 FE(적용 예정) | B3 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.getDayOfWeek: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.getDayOfWeek 의 B3 16요소: NOPATH:7 · NA:4 ·  |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.getDayOfWeek) |
| WK-DMF0082-0022 | B3 | FCST_TYPE / FCST Type | 화면 FE(적용 예정) | B3 FAIL 수정 — FCST_TYPE / FCST Type: 원장 V-c7a4b5d8 COLUMN (FX-DMF0082-122) |  | 4 (F-09 ACT:DMF0082_FcstNPrice_Mgmt.GetFcst) |
| WK-DMF0082-0023 | B3 | clbCustomer / End Customer / Customer | 화면 FE(적용 예정) | B3 FAIL 수정 — clbCustomer / End Customer / Customer: 원장 V-5537bfe4 SEARCH (FX-DMF0082-060) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-0024 | B4 | A-11 | DB 메타(적용 예정) | B4 FAIL 수정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 B4 23요소: NOPATH:8 · PASS:7 · NA:6 · FAIL: |  | 1 (A-11) |
| WK-DMF0082-0025 | B4 | CELL_PROD_SITE_ID / Cell Prod Site | DB 메타(적용 예정) | B4 FAIL 수정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-48949855 COLUMN (FX-DMF0082-151) |  | 9 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow:26) |
| WK-DMF0082-0026 | B4 | COMMON:UC-05 | DB 메타(적용 예정) | B4 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B4 23요소: NOPATH:8 · PASS |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0027 | B4 | DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivi | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetBizTypebyDivision 의 B4 23요소: NO |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.GetBizTypeby) |
| WK-DMF0082-0028 | B4 | DMF0082_FcstNPrice_Mgmt.GetBucketType | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetBucketType 의 B4 23요소: NOPATH:8 · PASS: |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0029 | B4 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook 의 B4 23요소: NOPATH |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0030 | B4 | DMF0082_FcstNPrice_Mgmt.GetDayRange | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetDayRange 의 B4 23요소: NOPATH:8 · PASS:7 ·  |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0031 | B4 | DMF0082_FcstNPrice_Mgmt.GetFcstType | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetFcstType 의 B4 1요소: FAIL:1 · FAIL 요소: FCS |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0032 | B4 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetLookupValues 의 B4 23요소: NOPATH:8 · P |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0033 | B4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite 의 B4 23요소: NOPATH:8 · PASS:7  |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0034 | B4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite40 의 B4 23요소: NOPATH:8 · PAS |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0035 | B4 | DMF0082_FcstNPrice_Mgmt.getDayOfWeek | DB 메타(적용 예정) | B4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.getDayOfWeek: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.getDayOfWeek 의 B4 23요소: NOPATH:8 · PASS:7  |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.getDayOfWeek) |
| WK-DMF0082-0036 | B4 | FCST_TYPE / FCST Type | DB 메타(적용 예정) | B4 FAIL 수정 — FCST_TYPE / FCST Type: 원장 V-67e34115 COLUMN (FX-DMF0082-123) |  | 5 (F-03 F-09 ACT:DMF0082_FcstNPrice_Mgmt.Ge) |
| WK-DMF0082-0037 | G3 | DMF0082 화면 | 사람판정(사람판정 대기) | G3 FAIL 수정 — DMF0082 화면: 원장 V-38a8a336 RULE_SCREEN / 원장 V-2228e415 GENERAL / 원장 V-d76edf68 GENERAL / 원장 V-431e5cf4 GENERAL / 원장 V- |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0082-0038 | F4 | A-15 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL  |  | 1 (A-15) |
| WK-DMF0082-0039 | F4 | CRUD:E02:SAVE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — CRUD:E02:SAVE: 행 집계 — 대조표 CRUD:E02:SAVE '[SAVE] §2 SetSaveData / SetSaveDataRemove (저장 버퍼, ' 의 F4 16요소: NA:10 · PASS: |  | 1 (CRUD:E02:SAVE) |
| WK-DMF0082-0040 | F4 | CRUD:E04:SAVE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — CRUD:E04:SAVE: 행 집계 — 대조표 CRUD:E04:SAVE '[SAVE] §4 SaveData (F7, SaveButton L1612~L1615 → S' 의 F4 16요소: NA:10 · PASS: |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0041 | F4 | CRUD:E05:SEARCH | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — CRUD:E05:SEARCH: 행 집계 — 대조표 CRUD:E05:SEARCH '[SEARCH] §5 FindData (F5, FindButton L671~L676 → F' 의 F4 16요소: NA:10 · P |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0042 | F4 | D-14 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — D-14: 행 집계 — 대조표 D-14 'SetSaveData / `sDivision == "40"`' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUT |  | 1 (D-14) |
| WK-DMF0082-0043 | F4 | D-15 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — D-15: 행 집계 — 대조표 D-15 'SetSaveData / `(=="40" \\' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUREPRICE |  | 1 (D-15) |
| WK-DMF0082-0044 | F4 | D-16 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — D-16: 행 집계 — 대조표 D-16 'SetSaveDataRemove / `sDivision == "40"`' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_G |  | 1 (D-16) |
| WK-DMF0082-0045 | F4 | DMF0003_GET_BUCKET_TYPE_CODE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0003_GET_BUCKET_TYPE_CODE: 실측[T-786235be]: DMF0003_GET_BUCKET_TYPE_CODE: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0046 | F4 | DMF0082_FcstNPrice_Mgmt.GetCustomsHandbo | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetCustomsHandbook 의 F4 16요소: NA:10  |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetCustomsHa) |
| WK-DMF0082-0047 | F4 | DMF0082_FcstNPrice_Mgmt.GetDayRange | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetDayRange: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetDayRange 의 F4 16요소: NA:10 · PASS:3 · FAI |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetDayRange:) |
| WK-DMF0082-0048 | F4 | DMF0082_FcstNPrice_Mgmt.GetFcstType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFcstType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetFcstType 의 F4 16요소: NA:10 · PASS:3 · FAI |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFcstType:) |
| WK-DMF0082-0049 | F4 | DMF0082_FcstNPrice_Mgmt.GetFuturePriceIn | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetFuturePriceInfo 의 F4 16요소: NA:10  |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0050 | F4 | DMF0082_FcstNPrice_Mgmt.GetIncotermsType | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetIncotermsType: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetIncotermsType 의 F4 16요소: NA:10 · PA |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0051 | F4 | DMF0082_FcstNPrice_Mgmt.GetLookupValues | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetLookupValues: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetLookupValues 의 F4 16요소: NA:10 · PASS |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetLookupVal) |
| WK-DMF0082-0052 | F4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite 의 F4 16요소: NA:10 · PASS:3 · F |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0053 | F4 | DMF0082_FcstNPrice_Mgmt.GetSalesSite40 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetSalesSite40: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.GetSalesSite40 의 F4 16요소: NA:10 · PASS:3 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetSalesSite) |
| WK-DMF0082-0054 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetDa | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetDayRange: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetDayRange 의 F4 16요소 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0055 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetFu | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetFuturePriceInfo: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetFuturePrice |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0056 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetMe | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCountInfo: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetMeasureCou |  | 4 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0057 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetSa | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFromTo: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetSaveDateFrom |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0058 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetSp | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetSpdTitle 의 F4 16요소 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0059 | F4 | DMF0082_SaveSalesFuturePrice_Popup.GetWe | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.GetWeekData: 진입점 집계 — 대조표 DMF0082_SaveSalesFuturePrice_Popup.GetWeekData 의 F4 16요소 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0060 | F4 | DP-06 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DP-06: 행 집계 — 대조표 DP-06 'SaveData / `sDIVISION_ID=="40"` → PROJECT_CODE=END' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAI |  | 1 (DP-06) |
| WK-DMF0082-0061 | F4 | DP-07 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — DP-07: 행 집계 — 대조표 DP-07 'SaveData 필수메시지 / `=="40"` → "[End Customer]" / `81' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAI |  | 1 (DP-07) |
| WK-DMF0082-0062 | F4 | E02 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E02: 행 집계 — 대조표 E02 'SetSaveData/SetSaveDataRemove — 저장 버퍼 (md §2)' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POP |  | 1 (E02) |
| WK-DMF0082-0063 | F4 | E04 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E04: 행 집계 — 대조표 E04 'SaveData(F7)+fnValidation (md §4)' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUR |  | 1 (E04) |
| WK-DMF0082-0064 | F4 | E05 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — E05: 행 집계 — 대조표 E05 'FindData(F5) 조회+Draw (md §5)' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUREPRIC |  | 1 (E05) |
| WK-DMF0082-0065 | F4 | F-02 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — F-02: 행 집계 — 대조표 F-02 'FindData(캐시) / 조회 성공 시' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUREPRICE_IN |  | 1 (F-02) |
| WK-DMF0082-0066 | F4 | F-05 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — F-05: 행 집계 — 대조표 F-05 'SetSaveData / SetSaveDataRemove / `sFcstType==""`' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요 |  | 1 (F-05) |
| WK-DMF0082-0067 | F4 | F-06 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — F-06: 행 집계 — 대조표 F-06 '저장 SP / `p_fcst_type` ^연결 전달' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUREPR |  | 1 (F-06) |
| WK-DMF0082-0068 | F4 | HANDLER:FindData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행)' 의 F4 16요소: NA:10 ·  |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0069 | F4 | HANDLER:SaveData | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — HANDLER:SaveData: 행 집계 — 대조표 HANDLER:SaveData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:2025` (라이브 164행)' 의 F4 16요소: NA:10 · |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0070 | F4 | M-11 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — M-11: 행 집계 — 대조표 M-11 'LOC / fnValidation / Validation / SetSaveData' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: P |  | 1 (M-11) |
| WK-DMF0082-0071 | F4 | M-12 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — M-12: 행 집계 — 대조표 M-12 'LOC / SetSaveData 필터' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL 요소: POPUP_GET_FUTUREPRICE_INFO |  | 1 (M-12) |
| WK-DMF0082-0072 | F4 | P-24 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — P-24: 행 집계 — 대조표 P-24 '조회기간 기본값 / PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) ' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL  |  | 1 (P-24) |
| WK-DMF0082-0073 | F4 | PKG_DMF0082 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_DMF0082: 실측[T-3052e069]: PKG_DMF0082: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인) — 화면 진입·조회 중 호출 없음 (FX-DMF00 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0074 | F4 | PL-36 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PL-36: 행 집계 — 대조표 PL-36 '`LockColumn(0, maxCol, true)` / FindData — 조회 직후 전' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAI |  | 1 (PL-36) |
| WK-DMF0082-0075 | F4 | POPUP_GET_FUTUREPRICE_INFO | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — POPUP_GET_FUTUREPRICE_INFO: 실측[T-d7c7bae7]: POPUP_GET_FUTUREPRICE_INFO: (PROC_M 배선 없음 — AS-IS 엔드포인트의 TO-BE 프로시저 배선 확인 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0076 | F4 | S-07 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — S-07: 행 집계 — 대조표 S-07 '조회 SP / `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SA' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL  |  | 1 (S-07) |
| WK-DMF0082-0077 | F4 | S-19 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — S-19: 행 집계 — 대조표 S-19 '중복 검사 / fnValidation: I행 기준 3행(Measure 세트) 단위(iRow' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL  |  | 1 (S-19) |
| WK-DMF0082-0078 | F4 | S-24 | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — S-24: 행 집계 — 대조표 S-24 '저장 후 / isSaveOK=true, panel1 숨김, FindData(false) 재' 의 F4 16요소: NA:10 · PASS:3 · FAIL:3 · FAIL  |  | 1 (S-24) |
| WK-DMF0082-0079 | A5 | A-15 | 사람판정(사람판정 대기) | A5 FAIL 수정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 · F |  | 1 (A-15) |
| WK-DMF0082-0080 | A5 | B | 사람판정(사람판정 대기) | A5 FAIL 수정 — B: E2E smoke columns / 실측[T-1de02830]: B 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0081 | A5 | COMMON:UC-07 | 사람판정(사람판정 대기) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 27요소: PASS:14 · REVIE |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0082 | A5 | CRUD:MAIN:SAVE | 사람판정(사람판정 대기) | A5 FAIL 수정 — CRUD:MAIN:SAVE: 행 집계 — 대조표 CRUD:MAIN:SAVE "저장 (16+1 IN '^' bulk)" 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 · FAIL 요소: L |  | 1 (CRUD:MAIN:SAVE) |
| WK-DMF0082-0083 | A5 | D | 사람판정(사람판정 대기) | A5 FAIL 수정 — D: E2E smoke columns / 실측[T-36faad38]: D 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 1 (EVENT:E-15) |
| WK-DMF0082-0084 | A5 | DPF-01 | 사람판정(사람판정 대기) | A5 FAIL 수정 — DPF-01: 행 집계 — 대조표 DPF-01 '`DM.DMF0082_GET_SPREAD_TITLE` p_division_id' 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 · FAIL |  | 1 (DPF-01) |
| WK-DMF0082-0085 | A5 | DPF-04 | 사람판정(사람판정 대기) | A5 FAIL 수정 — DPF-04: 행 집계 — 대조표 DPF-04 '`DM0002_TitleSetForm_Popup` division (Column/Measu' 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 |  | 1 (DPF-04) |
| WK-DMF0082-0086 | A5 | HANDLER:btnSavePricePeriod_Click | 사람판정(사람판정 대기) | A5 FAIL 수정 — HANDLER:btnSavePricePeriod_Click: 행 집계 — 대조표 HANDLER:btnSavePricePeriod_Click 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3455 |  | 1 (HANDLER:btnSavePricePeriod_Click) |
| WK-DMF0082-0087 | A5 | L7 `titleSet` 시트 | 사람판정(사람판정 대기) | A5 FAIL 수정 — L7 `titleSet` 시트: 행 집계 — 대조표 L7 `titleSet` 시트 '해소' 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 · FAIL 요소: L — E2E smoke co |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0088 | A5 | MODAL:SavePricePeriodModal | 사람판정(사람판정 대기) | A5 FAIL 수정 — MODAL:SavePricePeriodModal: 행 집계 — 대조표 MODAL:SavePricePeriodModal 'Price Batch Input (기간 판가 일괄 저장)' 의 A5 27요소: PASS:1 |  | 1 (MODAL:SavePricePeriodModal) |
| WK-DMF0082-0089 | A5 | MODAL:VersionSelectModal | 사람판정(사람판정 대기) | A5 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — 대조표 MODAL:VersionSelectModal '버전 선택 팝업' 의 A5 27요소: PASS:14 · REVIEW:8 · FAIL:5 · FAI |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0090 | A5 | N | 사람판정(사람판정 대기) | A5 FAIL 수정 — N: E2E smoke columns / 실측[T-77cfe411]: N 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 2 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) ) |
| WK-DMF0082-0091 | A5 | P | 사람판정(사람판정 대기) | A5 FAIL 수정 — P: E2E smoke columns / 실측[T-a6165ce9]: P 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 1 (P-12) |
| WK-DMF0082-0092 | A5 | REQ:CHAT-20260820-1 | 사람판정(사람판정 대기) | A5 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — 대조표 REQ:CHAT-20260820-1 'DMF0082 81 Division 컬럼의 AS-IS 대조 기준 = DMF0003 MAIN' 의 A5 27요소: P |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0093 | A5 | REQ:CHAT-20260915-EXLASTUPD | 사람판정(사람판정 대기) | A5 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼  |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0094 | A5 | S | 사람판정(사람판정 대기) | A5 FAIL 수정 — S: E2E smoke columns / 실측[T-1c2d1ecc]: S 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 3 (S-07 S-24 EVENT:E-04) |
| WK-DMF0082-0095 | G4 | A-11 | 사람판정(사람판정 대기) | G4 FAIL 수정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 G4 13요소: FAIL:11 · NOPATH:2 · FAIL 요소: cb |  | 1 (A-11) |
| WK-DMF0082-0096 | G4 | COMMON:UC-06 | 사람판정(사람판정 대기) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G4 13요소: FAIL:11 · NOPATH:2 · FA |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0097 | G4 | DP-01 | 사람판정(사람판정 대기) | G4 FAIL 수정 — DP-01: 행 집계 — 대조표 DP-01 'InitControls / `81prefix \\' 의 G4 13요소: FAIL:11 · NOPATH:2 · FAIL 요소: cboBucketType / Bucket |  | 1 (DP-01) |
| WK-DMF0082-0098 | G4 | EVENT:E-14 | 사람판정(사람판정 대기) | G4 FAIL 수정 — EVENT:E-14: 행 집계 — 대조표 EVENT:E-14 '*(AS-IS 없음)* 상위 변경 → **모달 조회조건 종속 컬럼 연쇄 초기화**' 의 G4 13요소: FAIL:11 · NOPATH:2 · FAI |  | 1 (EVENT:E-14) |
| WK-DMF0082-0099 | G4 | HANDLER:Form_Load | 사람판정(사람판정 대기) | G4 FAIL 수정 — HANDLER:Form_Load: 행 집계 — 대조표 HANDLER:Form_Load 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:312` (라이브 8행)' 의 G4 13요소: FAIL:11  |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0100 | G4 | REQ:1ST-37-2 | 사람판정(사람판정 대기) | G4 FAIL 수정 — REQ:1ST-37-2: 행 집계 — 대조표 REQ:1ST-37-2 '전체 조회조건 정상 동작 점검 (★)' 의 G4 13요소: FAIL:11 · NOPATH:2 · FAIL 요소: cboBucketType / |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0101 | G4 | cboBucketType / Bucket / Bucket Type | 사람판정(사람판정 대기) | G4 FAIL 수정 — cboBucketType / Bucket / Bucket Type: E2E smoke labels (FX-DMF0082-1262) |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.DefineProper) |
| WK-DMF0082-0102 | G4 | chkSum / Sum | 사람판정(사람판정 대기) | G4 FAIL 수정 — chkSum / Sum: E2E smoke labels (FX-DMF0082-1353) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0103 | G4 | clbBizType / Biz Type / Biz. Type | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbBizType / Biz Type / Biz. Type: E2E smoke labels (FX-DMF0082-1350) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0104 | G4 | clbCustomer / End Customer / Customer | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbCustomer / End Customer / Customer: E2E smoke labels (FX-DMF0082-1349) |  | 7 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0105 | G4 | clbDivision / Division / Div. | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbDivision / Division / Div.: E2E smoke labels (FX-DMF0082-1347) |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0106 | G4 | clbDivisions / Division / Divisions | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbDivisions / Division / Divisions: E2E smoke labels (FX-DMF0082-1598) |  | 12 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0107 | G4 | clbSalesSite / Sales Site | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbSalesSite / Sales Site: E2E smoke labels (FX-DMF0082-1351) |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0108 | G4 | clbTeam / Team | 사람판정(사람판정 대기) | G4 FAIL 수정 — clbTeam / Team: E2E smoke labels (FX-DMF0082-1348) |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0109 | G4 | drpDateTime / Date Time | 사람판정(사람판정 대기) | G4 FAIL 수정 — drpDateTime / Date Time: E2E smoke labels (FX-DMF0082-1597) |  | 21 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0110 | G4 | drpPeriod / Period / From / To / 기간 | 사람판정(사람판정 대기) | G4 FAIL 수정 — drpPeriod / Period / From / To / 기간: E2E smoke labels (FX-DMF0082-1286) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:170) |
| WK-DMF0082-0111 | G4 | txtVersion / Version | 사람판정(사람판정 대기) | G4 FAIL 수정 — txtVersion / Version: E2E smoke labels (FX-DMF0082-1352) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0112 | H2 | A-15 | 화면 FE(적용 예정) | H2 FAIL 수정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 · FAIL |  | 1 (A-15) |
| WK-DMF0082-0113 | H2 | CELL_PROD_SITE_ID / Cell Prod Site | 화면 FE(적용 예정) | H2 FAIL 수정 — CELL_PROD_SITE_ID / Cell Prod Site: 원장 V-a35fb514 COLUMN / 실측[T-13ca144b]: CELL_PROD_SITE_ID: 기존행 편집=false 표시 일치 · 신규 |  | 2 (E08-C EVENT:E-07) |
| WK-DMF0082-0114 | H2 | COMMON:UC-07 | 화면 FE(적용 예정) | H2 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H2 42요소: NA:30 · PASS:10 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0115 | H2 | DMF0082_FcstNPrice_Mgmt.CreateSpread | 화면 FE(적용 예정) | H2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.CreateSpread 의 H2 42요소: NA:30 · PASS:10 ·  |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0116 | H2 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 화면 FE(적용 예정) | H2 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan 의 H2 42요소: NA:3 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0117 | H2 | DP-11 | 화면 FE(적용 예정) | H2 FAIL 수정 — DP-11: 행 집계 — 대조표 DP-11 'usrButton1_Click(Project 팝업) / `SelectedValue != "' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 · FA |  | 1 (DP-11) |
| WK-DMF0082-0118 | H2 | DPF-01 | 화면 FE(적용 예정) | H2 FAIL 수정 — DPF-01: 행 집계 — 대조표 DPF-01 '`DM.DMF0082_GET_SPREAD_TITLE` p_division_id' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 · FAIL 요소 |  | 1 (DPF-01) |
| WK-DMF0082-0119 | H2 | DPF-04 | 화면 FE(적용 예정) | H2 FAIL 수정 — DPF-04: 행 집계 — 대조표 DPF-04 '`DM0002_TitleSetForm_Popup` division (Column/Measu' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 ·  |  | 1 (DPF-04) |
| WK-DMF0082-0120 | H2 | HANDLER:btnItemId_Click | 화면 FE(적용 예정) | H2 FAIL 수정 — HANDLER:btnItemId_Click: 행 집계 — 대조표 HANDLER:btnItemId_Click 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3373` (라이브 17행)' 의 H2  |  | 1 (HANDLER:btnItemId_Click) |
| WK-DMF0082-0121 | H2 | ITEM_ID / Model | 화면 FE(적용 예정) | H2 FAIL 수정 — ITEM_ID / Model: 원장 V-d9d2a8c3 COLUMN / 원장 V-280085f3 ASIS / 실측[T-48c20115]: ITEM_ID: 기존행 편집=false 표시 일치 · 신규행 편집 불가인 |  | 3 (E08-C EVENT:E-07 EVENT:E-10) |
| WK-DMF0082-0122 | H2 | L7 `titleSet` 시트 | 화면 FE(적용 예정) | H2 FAIL 수정 — L7 `titleSet` 시트: 행 집계 — 대조표 L7 `titleSet` 시트 '해소' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 · FAIL 요소: ITEM_ID / Model — 원 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0123 | H2 | MODAL:VersionSelectModal | 화면 FE(적용 예정) | H2 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — 대조표 MODAL:VersionSelectModal '버전 선택 팝업' 의 H2 42요소: NA:30 · PASS:10 · FAIL:2 · FAIL 요 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0124 | H2 | REQ:CHAT-20260820-1 | 화면 FE(적용 예정) | H2 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — 대조표 REQ:CHAT-20260820-1 'DMF0082 81 Division 컬럼의 AS-IS 대조 기준 = DMF0003 MAIN' 의 H2 42요소: N |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0125 | H2 | REQ:CHAT-20260915-EXLASTUPD | 화면 FE(적용 예정) | H2 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼  |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0126 | D4 | C | 사람판정(사람판정 대기) | D4 FAIL 수정 — C: 원장 V-784d4aa4 ASIS / 원장 V-9b36903b ASIS / 실측[T-83ce85d5]: 신규행 C='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (F |  | 1 (E08-C) |
| WK-DMF0082-0127 | D4 | COMMON:UC-01 | 사람판정(사람판정 대기) | D4 FAIL 수정 — COMMON:UC-01: 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (ke' 의 D4 21요소: NA:10 · PASS:8  |  | 1 (COMMON:UC-01) |
| WK-DMF0082-0128 | D4 | COMMON:UC-03 | 사람판정(사람판정 대기) | D4 FAIL 수정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 D4 21요소: NA:10 · PASS:8  |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0129 | D4 | CRUD:E06:INSERT | 사람판정(사람판정 대기) | D4 FAIL 수정 — CRUD:E06:INSERT: 행 집계 — 대조표 CRUD:E06:INSERT '[INSERT] §6 InsertRow / DeleteButton' 의 D4 21요소: NA:10 · PASS:8 · FAIL:3 |  | 1 (CRUD:E06:INSERT) |
| WK-DMF0082-0130 | D4 | E06 | 사람판정(사람판정 대기) | D4 FAIL 수정 — E06: 행 집계 — 대조표 E06 '§6 InsertRow / DeleteButton' 의 D4 21요소: NA:10 · PASS:8 · FAIL:3 · FAIL 요소: C — 원장 V-784d4aa4 ASI |  | 1 (E06) |
| WK-DMF0082-0131 | D4 | E06-A | 사람판정(사람판정 대기) | D4 FAIL 수정 — E06-A: 행 집계 — 대조표 E06-A 'InsertRow — 시드 10키 복사 (md §6-A)' 의 D4 21요소: NA:10 · PASS:8 · FAIL:3 · FAIL 요소: C — 원장 V-784d |  | 1 (E06-A) |
| WK-DMF0082-0132 | D4 | HANDLER:InsertRow | 사람판정(사람판정 대기) | D4 FAIL 수정 — HANDLER:InsertRow: 행 집계 — 대조표 HANDLER:InsertRow 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:2492` (라이브 170행)' 의 D4 21요소: NA:10 |  | 1 (HANDLER:InsertRow) |
| WK-DMF0082-0133 | D4 | HANDLER:cboBucketType_Click | 사람판정(사람판정 대기) | D4 FAIL 수정 — HANDLER:cboBucketType_Click: 행 집계 — 대조표 HANDLER:cboBucketType_Click 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3361` (라이브 10행 |  | 1 (HANDLER:cboBucketType_Click) |
| WK-DMF0082-0134 | D4 | I | 화면 FE(적용 예정) | D4 FAIL 수정 — I: 원장 V-9b36903b ASIS / 실측[T-e525d615]: 신규행 I='' — AS-IS InsertButton 은 이 컬럼에 값을 넣지 않음(기대 빈값) (FX-DMF0082-415) |  | 3 (P-15 E01-A CRUD:MAIN:INSERT) |
| WK-DMF0082-0135 | D4 | InsertButton 전제 isCurVersion | 화면 FE(적용 예정) | D4 FAIL 수정 — InsertButton 전제 isCurVersion: 원장 V-9b36903b (FX-DMF0082-415) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InsertButton) |
| WK-DMF0082-0136 | D4 | L2P `hotkey DELETE` 권한 0그룹 | 사람판정(사람판정 대기) | D4 FAIL 수정 — L2P `hotkey DELETE` 권한 0그룹: 행 집계 — 대조표 L2P `hotkey DELETE` 권한 0그룹 '정상' 의 D4 21요소: NA:10 · PASS:8 · FAIL:3 · FAIL 요소:  |  | 1 (L2P `hotkey DELETE` 권한 0그룹) |
| WK-DMF0082-0137 | D4 | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | 사람판정(사람판정 대기) | D4 FAIL 수정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 행 집계 — 대조표 L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL '정상' 의 D4 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-0138 | D4 | REQ:1ST-38-1 | 사람판정(사람판정 대기) | D4 FAIL 수정 — REQ:1ST-38-1: 행 집계 — 대조표 REQ:1ST-38-1 '중복 Validation 을 행 추가 시점이 아닌 저장 버튼 클릭 시점에 수행' 의 D4 21요소: NA:10 · PASS:8 · FAIL: |  | 1 (REQ:1ST-38-1) |
| WK-DMF0082-0139 | D4 | REQ:CHAT-20260820-1 | 사람판정(사람판정 대기) | D4 FAIL 수정 — REQ:CHAT-20260820-1: 행 집계 — 대조표 REQ:CHAT-20260820-1 'DMF0082 81 Division 컬럼의 AS-IS 대조 기준 = DMF0003 MAIN' 의 D4 21요소: N |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0140 | D4 | REQ:CHAT-20260915-EXLASTUPD | 사람판정(사람판정 대기) | D4 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼  |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0141 | D5 | A-11 | 화면 FE(적용 예정) | D5 FAIL 수정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 D5 15요소: NA:7 · PASS:6 · FAIL:2 · FAIL 요소 |  | 1 (A-11) |
| WK-DMF0082-0142 | D5 | COMMON:UC-05 | 화면 FE(적용 예정) | D5 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 D5 15요소: NA:7 · PASS:6 · |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0143 | D5 | DIVISION_ID / Division | 화면 FE(적용 예정) | D5 FAIL 수정 — DIVISION_ID / Division: 원장 V-09e00564 COLUMN / 실측[T-0230a46d]: DIVISION_ID: AS-IS COMBO(cell_rules) ↔ TO-BE dataType= |  | 1 (E01-A) |
| WK-DMF0082-0144 | D5 | DMF0082_FcstNPrice_Mgmt.CreateSpread | 화면 FE(적용 예정) | D5 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.CreateSpread: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.CreateSpread 의 D5 15요소: NA:7 · PASS:6 · FA |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0145 | D5 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 화면 FE(적용 예정) | D5 FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan 의 D5 15요소: NA:7 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0146 | D5 | MEASURE / Measure | 화면 FE(적용 예정) | D5 FAIL 수정 — MEASURE / Measure: 실측[T-22cd82b1]: MEASURE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=1 dataMap=Y — AS-IS TEXT 에디터가 아님  |  | 5 (M-08 E01-A ACT:DMF0082_SaveSalesFuturePr) |
| WK-DMF0082-0147 | X-ROW | DMF0082_FcstNPrice_Mgmt.DefineProperty | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.DefineProperty: 진입점 집계 4검사 — PASS:2 · WARN:1 · FAIL:1 (FX-DMF0082-1263) |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.DefineProper) |
| WK-DMF0082-0148 | X-ROW | DMF0082_FcstNPrice_Mgmt.FindData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.FindData: 진입점 집계 34검사 — NA:17 · PASS:13 · REVIEW:2 · FAIL:1 · ERROR:1 (FX-DMF0082-1283) |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.FindData:166) |
| WK-DMF0082-0149 | X-ROW | DMF0082_FcstNPrice_Mgmt.GetBucketType | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.GetBucketType: 진입점 집계 5검사 — NOPATH:3 · FAIL:1 · PASS:1 (FX-DMF0082-1291) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0150 | X-ROW | DMF0082_FcstNPrice_Mgmt.InitControls | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InitControls: 진입점 집계 27검사 — PASS:14 · FAIL:9 · NA:2 · NOPATH:2 (FX-DMF0082-1356) |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0151 | X-ROW | DMF0082_FcstNPrice_Mgmt.InsertButton | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InsertButton: 진입점 집계 2검사 — PASS:1 · FAIL:1 (FX-DMF0082-1361) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.InsertButton) |
| WK-DMF0082-0152 | X-ROW | DMF0082_FcstNPrice_Mgmt.InsertRow | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.InsertRow: 진입점 집계 24검사 — NA:14 · PASS:8 · FAIL:2 (FX-DMF0082-1363) |  | 136 (ACT:DMF0082_FcstNPrice_Mgmt.InsertRow AC) |
| WK-DMF0082-0153 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetChangeControl | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetChangeControl: 진입점 집계 14검사 — NA:11 · PASS:2 · FAIL:1 (FX-DMF0082-1392) |  | 6 (ACT:DMF0082_FcstNPrice_Mgmt.SetChangeCon) |
| WK-DMF0082-0154 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetSpreadColumn | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.SetSpreadColumn: 진입점 집계 16검사 — NA:11 · NOT_RUN:4 · FAIL:1 (FX-DMF0082-1406) |  | 14 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadCol) |
| WK-DMF0082-0155 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnColumn_Click | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.btnColumn_Click: 진입점 집계 9검사 — NA:4 · PASS:1 · FAIL:1 · ERROR:1 · NOT_RUN:1 · NOPATH:1 (FX- |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-0156 | X-ROW | DMF0082_FcstNPrice_Mgmt.btnMeasure_Click | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.btnMeasure_Click: 진입점 집계 9검사 — NA:4 · PASS:2 · NOT_RUN:1 · NOPATH:1 · FAIL:1 (FX-DMF0082-1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-0157 | X-ROW | DMF0082_FcstNPrice_Mgmt.cboBucketType_Se | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.cboBucketType_SelectedIndexChanged: 진입점 집계 12검사 — NA:10 · WARN:1 · FAIL:1 (FX-DMF0082-1436 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.cboBucketTyp) |
| WK-DMF0082-0158 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_CellDoub | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick: 진입점 집계 35검사 — NA:20 · NOT_RUN:6 · NOPATH:3 · ERROR:3 · PASS:2 · F |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0159 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_Changed | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_Changed: 진입점 집계 107검사 — NA:94 · PASS:6 · NOPATH:4 · FAIL:2 · WARN:1 (FX-DMF0082-14 |  | 23 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0160 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_Clipboar | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_FcstNPrice_Mgmt.spdMain_ClipboardPasted: 진입점 집계 34검사 — NA:30 · PASS:3 · FAIL:1 (FX-DMF0082-1547) |  | 8 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Clip) |
| WK-DMF0082-0161 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Defin | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.DefineProperty: 진입점 집계 7검사 — NA:3 · FAIL:2 · PASS:1 · WARN:1 (FX-DMF0082-1599) |  | 10 (ACT:DMF0082_SaveSalesFuturePrice_Popup.D) |
| WK-DMF0082-0162 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.FindD | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.FindData: 진입점 집계 36검사 — NA:24 · PASS:7 · REVIEW:2 · NOT_RUN:1 · FAIL:1 · NOPATH |  | 137 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0163 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.Form_ | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.Form_Load: 진입점 집계 8검사 — NA:3 · FAIL:3 · PASS:2 (FX-DMF0082-1638) |  | 18 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0164 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitC | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.InitControls: 진입점 집계 21검사 — PASS:9 · FAIL:6 · NA:6 (FX-DMF0082-1664) |  | 28 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0165 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitS | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.InitSpread: 진입점 집계 5검사 — NA:2 · PASS:1 · FAIL:1 · NOT_RUN:1 (FX-DMF0082-1667) |  | 9 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0166 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.SetSp | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.SetSpreadColumn: 진입점 집계 7검사 — NA:3 · PASS:2 · FAIL:1 · REVIEW:1 (FX-DMF0082-168 |  | 26 (ACT:DMF0082_SaveSalesFuturePrice_Popup.S) |
| WK-DMF0082-0167 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.drpDa | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.drpDateTime_ValueChange: 진입점 집계 2검사 — FAIL:1 · NA:1 (FX-DMF0082-1687) |  | 7 (ACT:DMF0082_SaveSalesFuturePrice_Popup.d) |
| WK-DMF0082-0168 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.usrBu | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — DMF0082_SaveSalesFuturePrice_Popup.usrButton1_Click: 진입점 집계 11검사 — NA:7 · PASS:1 · NOT_RUN:1 · NOPATH:1 · FAIL:1 ( |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-0169 | G5 | A-15 | 사람판정(사람판정 대기) | G5 FAIL 수정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FA |  | 1 (A-15) |
| WK-DMF0082-0170 | G5 | C | 사람판정(사람판정 대기) | G5 FAIL 수정 — C: 원장 V-4066740e ASIS / 원장 V-f1f53096 ASIS / 원장 V-7c7fba0d ASIS / 원장 V-df4713dd ASIS / 원장 V-cffce3cc ASIS / 원장 V-724a |  | 1 (E08-C) |
| WK-DMF0082-0171 | G5 | DP-11 | 사람판정(사람판정 대기) | G5 FAIL 수정 — DP-11: 행 집계 — 대조표 DP-11 'usrButton1_Click(Project 팝업) / `SelectedValue != "' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 ·  |  | 1 (DP-11) |
| WK-DMF0082-0172 | G5 | DPF-03 | 사람판정(사람판정 대기) | G5 FAIL 수정 — DPF-03: 행 집계 — 대조표 DPF-03 '`DMF0000_ExchangeRatePopup.LoadData` division' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAI |  | 1 (DPF-03) |
| WK-DMF0082-0173 | G5 | DPF-04 | 사람판정(사람판정 대기) | G5 FAIL 수정 — DPF-04: 행 집계 — 대조표 DPF-04 '`DM0002_TitleSetForm_Popup` division (Column/Measu' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6  |  | 1 (DPF-04) |
| WK-DMF0082-0174 | G5 | E08 | 사람판정(사람판정 대기) | G5 FAIL 수정 — E08: 행 집계 — 대조표 E08 '§8 헤더/셀 더블클릭 (spdMain_CellDoubleClick, L3534~L3833' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL |  | 1 (E08) |
| WK-DMF0082-0175 | G5 | F | 사람판정(사람판정 대기) | G5 FAIL 수정 — F: 원장 V-4066740e ASIS / 원장 V-f1f53096 ASIS / 원장 V-7c7fba0d ASIS / 원장 V-b6da1505 ASIS / 원장 V-401954f0 ASIS / 원장 V-724a |  | 3 (F-09 F-10 S-23) |
| WK-DMF0082-0176 | G5 | HANDLER:spdMain_CellDoubleClick | 사람판정(사람판정 대기) | G5 FAIL 수정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — 대조표 HANDLER:spdMain_CellDoubleClick 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3534`  |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0082-0177 | G5 | M | 사람판정(사람판정 대기) | G5 FAIL 수정 — M: 원장 V-4066740e ASIS / 원장 V-7c7fba0d ASIS / 원장 V-df4713dd ASIS / 원장 V-cffce3cc ASIS / 원장 V-724aba5c ASIS / 원장 V-acc9 |  | 1 (M-25) |
| WK-DMF0082-0178 | G5 | MODAL:ExchangeRateModal | 사람판정(사람판정 대기) | G5 FAIL 수정 — MODAL:ExchangeRateModal: 행 집계 — 대조표 MODAL:ExchangeRateModal '환율 팝업 (AS-IS DMF0000_ExchangeRatePopup 1:1)' 의 G5 54요소:  |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0179 | G5 | MODAL:VersionSelectModal | 사람판정(사람판정 대기) | G5 FAIL 수정 — MODAL:VersionSelectModal: 행 집계 — 대조표 MODAL:VersionSelectModal '버전 선택 팝업' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0180 | G5 | REQ:1ST-48-1 | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:1ST-48-1: 행 집계 — 대조표 REQ:1ST-48-1 '환율 팝업 Save 버튼 데이터 수정 건수 표기 제거' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL 요소 |  | 1 (REQ:1ST-48-1) |
| WK-DMF0082-0181 | G5 | REQ:1ST-48-2 | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:1ST-48-2: 행 집계 — 대조표 REQ:1ST-48-2 '환율 팝업 Close 후 재오픈 시 수정 데이터 잔존 해소' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-0182 | G5 | REQ:1ST-48-3 | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:1ST-48-3: 행 집계 — 대조표 REQ:1ST-48-3 "잔존 데이터 저장 시 '수정 데이터 없음' 팝업 해소" 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL 요소 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0183 | G5 | REQ:1ST-49-1 | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:1ST-49-1: 행 집계 — 대조표 REQ:1ST-49-1 '수량·판가 입력 후 저장 시 미입력 팝업 오탐 해소' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL 요소: |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-0184 | G5 | REQ:1ST-66-1 | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:1ST-66-1: 행 집계 — 대조표 REQ:1ST-66-1 '81: 팝업 UI Search 클릭 시 데이터 조회' 의 G5 54요소: NA:30 · NOPATH:18 · FAIL:6 · FAIL 요소: |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0185 | G5 | REQ:CHAT-20260915-EXLASTUPD | 사람판정(사람판정 대기) | G5 FAIL 수정 — REQ:CHAT-20260915-EXLASTUPD: 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼  |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0186 | G5 | S | 사람판정(사람판정 대기) | G5 FAIL 수정 — S: 원장 V-4066740e ASIS / 원장 V-d4c116f2 ASIS / 원장 V-054b6b7b ASIS / 원장 V-f1f53096 ASIS / 원장 V-a3609e7a ASIS / 원장 V-7c7f |  | 3 (S-07 S-23 S-25) |
| WK-DMF0082-0187 | G5 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람판정(사람판정 대기) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.shtMain, f: 원장 V-7c7fba0d (FX-DMF0082-225) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnMeasure_C) |
| WK-DMF0082-0188 | G5 | new DM0002_TitleSetForm_Popup("DMF0082", | 사람판정(사람판정 대기) | G5 FAIL 수정 — new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.shtMain, t: 원장 V-4066740e (FX-DMF0082-210) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |

## W5 검사기 연결 (68)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0189 | B1 | F | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL F | 있음(FE 소스) | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0190 | B1 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL I | 있음(FE 소스) | 6 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0191 | B1 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL M | 있음(FE 소스) | 1 (M-08) |
| WK-DMF0082-0192 | B1 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 1 (F-02) |
| WK-DMF0082-0193 | B2 | F | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL F | 있음(FE 소스) | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0194 | B2 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL I | 있음(FE 소스) | 6 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0195 | B2 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL M | 있음(FE 소스) | 1 (M-08) |
| WK-DMF0082-0196 | B2 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 1 (F-02) |
| WK-DMF0082-0197 | B3 | B | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL B | 있음(FE 소스) | 1 (E01-B) |
| WK-DMF0082-0198 | B3 | F | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL F | 있음(FE 소스) | 1 (F-09) |
| WK-DMF0082-0199 | B3 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL I | 있음(FE 소스) | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Chan) |
| WK-DMF0082-0200 | B3 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL P | 있음(FE 소스) | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0201 | B3 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL S | 있음(FE 소스) | 1 (S-08) |
| WK-DMF0082-0202 | B3 | drpDateTime / Date Time | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND drpDateTime / Date Time | 있음(FE 소스) | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0203 | B3 | drpPeriod / Period / From / To / 기간 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND drpPeriod / Period / From / To / 기간 | 있음(FE 소스) | 5 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0204 | B4 | B | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL B | 있음(FE 소스) | 1 (E01-B) |
| WK-DMF0082-0205 | B4 | F | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL F | 있음(FE 소스) | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0206 | B4 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL I | 있음(FE 소스) | 8 (M-08 E01-A ACT:DMF0082_FcstNPrice_Mgmt.s) |
| WK-DMF0082-0207 | B4 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL M | 있음(FE 소스) | 1 (M-08) |
| WK-DMF0082-0208 | B4 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL P | 있음(FE 소스) | 1 (ACT:DMF0082_FcstNPrice_Mgmt.GetIncoterms) |
| WK-DMF0082-0209 | B4 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL S | 있음(FE 소스) | 2 (F-02 S-08) |
| WK-DMF0082-0210 | B4 | drpDateTime / Date Time | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpDateTime / Date Time | 있음(FE 소스) | 11 (ACT:DMF0082_SaveSalesFuturePrice_Popup.G) |
| WK-DMF0082-0211 | B4 | drpPeriod / Period / From / To / 기간 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period / From / To / 기간 | 있음(FE 소스) | 5 (ACT:DMF0082_FcstNPrice_Mgmt.GetFuturePri) |
| WK-DMF0082-0212 | DB-SYN | DMF0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0082_FcstNPrice_Mgmt.GetBucketTyp) |
| WK-DMF0082-0213 | DB-SYN | PKG_DMF0082 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_DMF0082 | 없음(PROC_M 대응 없음) | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0214 | DB-SYN | POPUP_GET_FUTUREPRICE_INFO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP POPUP_GET_FUTUREPRICE_INFO | 없음(PROC_M 대응 없음) | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0215 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 3 (DPF-09 ACT:DMF0082_FcstNPrice_Mgmt.GetBi) |
| WK-DMF0082-0216 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0217 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0218 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:DMF0082_FcstNPrice_Mgmt.InitControls) |
| WK-DMF0082-0219 | E2 | P | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL P | 있음(FE 소스) | 4 (P-01 P-10 P-22 P-24) |
| WK-DMF0082-0220 | E2 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 1 (S-20) |
| WK-DMF0082-0221 | E5 | F | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL F | 있음(FE 소스) | 3 (F-02 F-03 F-09) |
| WK-DMF0082-0222 | E5 | I | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL I | 있음(FE 소스) | 2 (M-08 E01-A) |
| WK-DMF0082-0223 | E5 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL M | 있음(FE 소스) | 1 (M-08) |
| WK-DMF0082-0224 | E5 | S | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL S | 있음(FE 소스) | 1 (F-02) |
| WK-DMF0082-0225 | G5 | AUTHORITY_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL AUTHORITY_YN | 있음(SHEET_COLUMNS) | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-0226 | G5 | BIZ_TYPE / Biz Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL BIZ_TYPE / Biz Type | 있음(SHEET_COLUMNS) | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-0227 | G5 | CELL_PROD_SITE_ID / Cell Prod Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL CELL_PROD_SITE_ID / Cell Prod Site | 있음(SHEET_COLUMNS) | 1 (E08-C) |
| WK-DMF0082-0228 | G5 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-0229 | G5 | FCST_TYPE / FCST Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FCST_TYPE / FCST Type | 있음(SHEET_COLUMNS) | 2 (F-09 F-10) |
| WK-DMF0082-0230 | G5 | ITEM_CLASS_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_CLASS_NAME | 있음(SHEET_COLUMNS) | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-0231 | G5 | ITEM_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_ID / Model | 있음(SHEET_COLUMNS) | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-0232 | G5 | ITEM_NAME / Model Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_NAME / Model Name | 있음(SHEET_COLUMNS) | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-0233 | G5 | ITEM_TYPE / Item Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL ITEM_TYPE / Item Type | 있음(SHEET_COLUMNS) | 1 (EVENT:E-10) |
| WK-DMF0082-0234 | G5 | MEASURE / Measure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL MEASURE / Measure | 있음(SHEET_COLUMNS) | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-0235 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-0236 | G5 | OWNER / Owner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL OWNER / Owner | 있음(SHEET_COLUMNS) | 1 (EVENT:E-09) |
| WK-DMF0082-0237 | G5 | PROJECT_CODE / Project Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PROJECT_CODE / Project Code | 있음(SHEET_COLUMNS) | 1 (EVENT:E-09) |
| WK-DMF0082-0238 | G5 | PROJECT_NAME / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL PROJECT_NAME / Project | 있음(SHEET_COLUMNS) | 2 (PL-26 EVENT:E-09) |
| WK-DMF0082-0239 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 59 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0240 | G5 | clbDivision / Division / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division / Div. | 있음(FE 소스) | 4 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-0241 | G5 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-0242 | G5 | drpPeriod / Period / From / To / 기간 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND drpPeriod / Period / From / To / 기간 | 있음(FE 소스) | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0243 | H6 | AUTHORITY_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL AUTHORITY_YN | 있음(SHEET_COLUMNS) | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-0244 | H6 | BIZ_TYPE / Biz Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL BIZ_TYPE / Biz Type | 있음(SHEET_COLUMNS) | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-0245 | H6 | CELL_PROD_SITE_ID / Cell Prod Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CELL_PROD_SITE_ID / Cell Prod Site | 있음(SHEET_COLUMNS) | 1 (E08-C) |
| WK-DMF0082-0246 | H6 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-0247 | H6 | FCST_TYPE / FCST Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FCST_TYPE / FCST Type | 있음(SHEET_COLUMNS) | 2 (F-09 F-10) |
| WK-DMF0082-0248 | H6 | ITEM_CLASS_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_CLASS_NAME | 있음(SHEET_COLUMNS) | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-0249 | H6 | ITEM_ID / Model | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID / Model | 있음(SHEET_COLUMNS) | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-0250 | H6 | ITEM_NAME / Model Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_NAME / Model Name | 있음(SHEET_COLUMNS) | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-0251 | H6 | ITEM_TYPE / Item Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_TYPE / Item Type | 있음(SHEET_COLUMNS) | 1 (EVENT:E-10) |
| WK-DMF0082-0252 | H6 | MEASURE / Measure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MEASURE / Measure | 있음(SHEET_COLUMNS) | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-0253 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-0254 | H6 | OWNER / Owner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL OWNER / Owner | 있음(SHEET_COLUMNS) | 1 (EVENT:E-09) |
| WK-DMF0082-0255 | H6 | PROJECT_CODE / Project Code | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE / Project Code | 있음(SHEET_COLUMNS) | 1 (EVENT:E-09) |
| WK-DMF0082-0256 | H6 | PROJECT_NAME / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_NAME / Project | 있음(SHEET_COLUMNS) | 2 (PL-26 EVENT:E-09) |

## W6 검증 실행 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0257 | SC1 | DMF0082 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0082 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 6 (A-11 DP-01 COMMON:UC-06 REQ:1ST-37-2 EVE) |
| WK-DMF0082-0258 | G1 | drpDateTime / Date Time | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpDateTime / Date Time · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0259 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 59 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0260 | H6 | clbDivision / Division / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division / Div. · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-0261 | H6 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.u) |
| WK-DMF0082-0262 | H6 | drpPeriod / Period / From / To / 기간 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |

## W7 기대값 확정 (158)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0263 | A5 | AS_FROM_SITE / AS From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — AS_FROM_SITE / AS From Site: E2E smoke columns / 실측[T-434b143f]: AS_FROM_SITE: AS-IS(Div 40) '선택' ↔ TO-BE 표시=N — AS-IS |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0264 | A5 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — BIZ_TYPE / Biz Type: E2E smoke columns / 실측[T-aa4da160]: BIZ_TYPE 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0265 | A5 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E: E2E smoke columns / 실측[T-bec9c069]: E 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장  |  | 13 (EVENT:E-03 EVENT:E-04 EVENT:E-05 EVENT:E) |
| WK-DMF0082-0266 | A5 | L | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — L: E2E smoke columns / 실측[T-6ea227e8]: L 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상(작업 원장  |  | 2 (L-14 PL-00) |
| WK-DMF0082-0267 | A5 | MEASURE / Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — MEASURE / Measure: 원장 V-bea468af COLUMN / E2E smoke columns |  | 5 (EVENT:E-05 EVENT:E-08 ACT:DMF0082_SaveSa) |
| WK-DMF0082-0268 | A5 | PLANT_SITE_ID / Plant Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PLANT_SITE_ID / Plant Site: E2E smoke columns / 실측[T-92be0c5b]: PLANT_SITE_ID 표시=N — AS-IS Division 별 표시 정보 없음(grid_ef |  | 2 (REQ:1ST-39-2 EVENT:E-04) |
| WK-DMF0082-0269 | A5 | PROJECT_CODE / Project Code | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PROJECT_CODE / Project Code: E2E smoke columns / 실측[T-311617a7]: PROJECT_CODE 표시=N — AS-IS Division 별 표시 정보 없음(grid_ef |  | 1 (EVENT:E-09) |
| WK-DMF0082-0270 | A5 | PROJECT_NAME / Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — PROJECT_NAME / Project: E2E smoke columns / 실측[T-cbda9166]: PROJECT_NAME 표시=N — AS-IS Division 별 표시 정보 없음(grid_effecti |  | 1 (EVENT:E-09) |
| WK-DMF0082-0271 | H5 | drpDateTime / Date Time | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — drpDateTime / Date Time: 검증 엔진이 실행됐으나 이 대상(COND drpDateTime)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 8 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0272 | X-REASON | D-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D-02 OnShown / `sDivision == "40"` ForecastPriceForm BucketField 기본값 AS-IS 40 고정 화면의 Weekly 강제. TO-BE 는 divisio |  | 1 (D-02) |
| WK-DMF0082-0273 | X-REASON | DP-13 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — DP-13 Dsdm_Changed / SetExchangeValues / `81prefix` → PROJECT/ITEM 변경 시 PlantSite 콤보 (⚠ 이벤트 미배선… — AS-IS 원문이 ** |  | 1 (DP-13) |
| WK-DMF0082-0274 | X-REASON | E07-A | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E07-A §7-A spdMain_KeyUp (활성 신로직 L8384~L8425) — AS-IS 본문 = Ctrl+V 를 감지해 `fps.ActiveSheet.ClipboardPaste()` 를 ** |  | 1 (E07-A) |
| WK-DMF0082-0275 | X-REASON | EVENT:E-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — EVENT:E-01 DIVISION_ID → TEAM_ID 콤보 재조회 (`ComboSelChange` .cs:8217) — 트리거 `DIVISION_ID` **INPUT_TP_CD='S'**(조회전 |  | 1 (EVENT:E-01) |
| WK-DMF0082-0276 | X-REASON | EVENT:E-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — EVENT:E-02 DIVISION/TEAM → END_CUSTOMER 콤보 재조회 (.cs:8226~8231) — 트리거 둘 다 **INPUT_TP_CD='S'** — 발생 불가 해당없음 |  | 1 (EVENT:E-02) |
| WK-DMF0082-0277 | X-REASON | F-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — F-07 비교팝업 SP / `p_fcst_type` 전달 — SSP 비교 팝업(DMF0003_GET_MKT_FCST_COMPARE_POPUP) — E08-B·D-09 와 동일 보류(2026-07-20 |  | 1 (F-07) |
| WK-DMF0082-0278 | X-REASON | HANDLER:clbDivision_SelectedIndexChanged | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:clbDivision_SelectedIndexChanged AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3039` (라이브 2행) · **사문(빈 몸통)** — AS-I |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0082-0279 | X-REASON | HANDLER:spdMain_EditChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_EditChange AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8375` (라이브 4행) — AS-IS 본문 4행 = `bPasteContinue` 플래 |  | 1 (HANDLER:spdMain_EditChange) |
| WK-DMF0082-0280 | X-REASON | HANDLER:spdMain_KeyUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_KeyUp AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8384` (라이브 29행) — AS-IS 본문 = Ctrl+V 감지해 `fps.ActiveShee |  | 1 (HANDLER:spdMain_KeyUp) |
| WK-DMF0082-0281 | X-REASON | HANDLER:spdMain_TopChange | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:spdMain_TopChange AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8488` (5행) — `SmartColMerge()` 재계산 공용 `DataGrid` +  |  | 1 (HANDLER:spdMain_TopChange) |
| WK-DMF0082-0282 | X-REASON | HANDLER:txtVersion_KeyDown | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:txtVersion_KeyDown AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3419` (라이브 3행) · **사문(빈 몸통)** — AS-IS 본문 3행 = `btn |  | 1 (HANDLER:txtVersion_KeyDown) |
| WK-DMF0082-0283 | X-REASON | M-23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M-23 MKT_FCST / spdMain_CellDoubleClick — SSP 동기수량 비교 팝업 — D-09·E08-B 동일 보류 제외 |  | 1 (M-23) |
| WK-DMF0082-0284 | X-REASON | MODAL:DMF0003_SspSyncPopUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:DMF0003_SspSyncPopUp AS-IS 팝업 (분석 md) — 제외 — E08-B 와 동일(SSP 동기화 계열 보류) 제외 |  | 1 (MODAL:DMF0003_SspSyncPopUp) |
| WK-DMF0082-0285 | X-REASON | P-09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-09 12월 마지막주 W01+ 보정 / else: `Period 시작월 >= 당주월` 이면 당주컬럼 이후 W_ 전부 추가 (E20251202-000637 — 12월 … components/Fore |  | 1 (P-09) |
| WK-DMF0082-0286 | X-REASON | P-14 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-14 버킷 전환 시 Lock 복원 / Edit 상태(`!IsLock`)면: 이벤트 해제 → **이전 버킷(sBfBucket)으로 되돌려 EditButton() 실행(… — AS-IS 는 버킷 전환 |  | 1 (P-14) |
| WK-DMF0082-0287 | X-REASON | REQ:1ST-34-1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — REQ:1ST-34-1 모든 컬럼 추가 후 조회 시 Measure 영역이 화면에서 보여야 함  VISUAL 보류 — 육안 확인 필요 (원장 REQ 축, 사용자 확인 대기) 제외 |  | 1 (REQ:1ST-34-1) |
| WK-DMF0082-0288 | E3 | BIZ_TYPE / Biz Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — BIZ_TYPE / Biz Type: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=True |  | 1 (E04) |
| WK-DMF0082-0289 | E3 | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CRUD:E04:SAVE: 행 집계 — 대조표 CRUD:E04:SAVE '[SAVE] §4 SaveData (F7, SaveButton L1612~L1615 → S' 의 E3 14요소: NOT_RUN:8 · PA |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0082-0290 | E3 | D | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — D: 검증 엔진이 실행됐으나 이 대상(COL D)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 7 (D-03 D-04 D-05 D-10 D-11 D-19 CRUD:MAIN:) |
| WK-DMF0082-0291 | E3 | DP-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DP-02: 행 집계 — 대조표 DP-02 'EditButton / `=="40"`' 의 E3 14요소: NOT_RUN:8 · PASS:5 · REVIEW:1 · FAIL 요소: BIZ_TYPE / Biz Typ |  | 1 (DP-02) |
| WK-DMF0082-0292 | E3 | DP-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DP-04: 행 집계 — 대조표 DP-04 'EditButton / `=="82"`' 의 E3 14요소: NOT_RUN:8 · PASS:5 · REVIEW:1 · FAIL 요소: BIZ_TYPE / Biz Typ |  | 1 (DP-04) |
| WK-DMF0082-0293 | E3 | DP-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DP-08: 행 집계 — 대조표 DP-08 'fnValidation / `81prefix\\' 의 E3 14요소: NOT_RUN:8 · PASS:5 · REVIEW:1 · FAIL 요소: BIZ_TYPE / Bi |  | 1 (DP-08) |
| WK-DMF0082-0294 | E3 | E | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E: 검증 엔진이 실행됐으나 이 대상(COL E)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (EVENT:E-11) |
| WK-DMF0082-0295 | E3 | E01-B1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E01-B1: 행 집계 — 대조표 E01-B1 'Daily 버킷 D_ 셀 수정 (md §1-B1)' 의 E3 14요소: NOT_RUN:8 · PASS:5 · REVIEW:1 · FAIL 요소: BIZ_TYPE / |  | 1 (E01-B1) |
| WK-DMF0082-0296 | E3 | F | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — F: 검증 엔진이 실행됐으나 이 대상(COL F)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 2 (F-04 F-08) |
| WK-DMF0082-0297 | E3 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행)' 의 E3 14요소: NOT_RUN:8 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0298 | E3 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — HANDLER:SaveData: 행 집계 — 대조표 HANDLER:SaveData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:2025` (라이브 164행)' 의 E3 14요소: NOT_RUN: |  | 1 (HANDLER:SaveData) |
| WK-DMF0082-0299 | E3 | I | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — I: 검증 엔진이 실행됐으나 이 대상(COL I)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 5 (E04 D-04 S-17 S-18 S-19) |
| WK-DMF0082-0300 | E3 | M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — M: 검증 엔진이 실행됐으나 이 대상(COL M)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 4 (E04 M-10 M-11 S-17) |
| WK-DMF0082-0301 | E3 | N | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — N: 검증 엔진이 실행됐으나 이 대상(COL N)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (REQ:CHAT-20260915-PRICEPJTGAP) |
| WK-DMF0082-0302 | E3 | P | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — P: 검증 엔진이 실행됐으나 이 대상(COL P)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 1 (REQ:1ST-36-1) |
| WK-DMF0082-0303 | E3 | REQ:1ST-38-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — REQ:1ST-38-1: 행 집계 — 대조표 REQ:1ST-38-1 '중복 Validation 을 행 추가 시점이 아닌 저장 버튼 클릭 시점에 수행' 의 E3 14요소: NOT_RUN:8 · PASS:5 · RE |  | 1 (REQ:1ST-38-1) |
| WK-DMF0082-0304 | E3 | REQ:1ST-41-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — REQ:1ST-41-1: 행 집계 — 대조표 REQ:1ST-41-1 'Current 버전 Measure 입력 — MKT_FCST/SCM_FCST(룩업 통제)·U' 의 E3 14요소: NOT_RUN:8 · PASS |  | 1 (REQ:1ST-41-1) |
| WK-DMF0082-0305 | E3 | S | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — S: 검증 엔진이 실행됐으나 이 대상(COL S)을 판정하지 못함 — 필수 입력 검증 시나리오 수동 확인 또는 엔진 확장 |  | 5 (S-02 S-11 S-17 S-18 S-19) |
| WK-DMF0082-0306 | A1 | A-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-11: 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082. |  | 1 (A-11) |
| WK-DMF0082-0307 | A1 | A-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-13: 행 집계 — 대조표 A-13 '팝업 행 권한 / `AUTHORITY_YN != "Y"` && Action 빈값' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF |  | 1 (A-13) |
| WK-DMF0082-0308 | A1 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (A-15) |
| WK-DMF0082-0309 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 A1 12요소: REVIEW:12 · FAIL |  | 1 (COMMON:UC-02) |
| WK-DMF0082-0310 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 12요소: REVIEW:12 · FAIL |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0311 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0312 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 12요소: REVIEW:12 · FAIL |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0313 | A1 | CRUD:E05:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E05:SEARCH: 행 집계 — 대조표 CRUD:E05:SEARCH '[SEARCH] §5 FindData (F5, FindButton L671~L676 → F' 의 A1 12요소: REVIEW:12  |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0314 | A1 | D-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D-17: 행 집계 — 대조표 D-17 'spdMain_ComboSelChange(Division 셀) / `clbDivision.' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (D-17) |
| WK-DMF0082-0315 | A1 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 골든 비교 케이스 없음(DMF0073_GET_VERSION_SALESPRICE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0316 | A1 | DMF0082_FcstNPrice_Mgmt.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0082_FcstNPrice_Mgmt.Draw: 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.Draw 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_ |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.Draw:1810:10) |
| WK-DMF0082-0317 | A1 | DP-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DP-01: 행 집계 — 대조표 DP-01 'InitControls / `81prefix \\' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN — |  | 1 (DP-01) |
| WK-DMF0082-0318 | A1 | DP-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DP-04: 행 집계 — 대조표 DP-04 'EditButton / `=="82"`' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN — golde |  | 1 (DP-04) |
| WK-DMF0082-0319 | A1 | E01-A | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-A: 행 집계 — 대조표 E01-A "Insert 행 키 셀 처리(sAction='I' 캐스케이드) (md §1-A)" 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_D |  | 1 (E01-A) |
| WK-DMF0082-0320 | A1 | E01-B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-B: 행 집계 — 대조표 E01-B '수량 변경 — 버킷 요일비트 산출 (md §1-B)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN  |  | 1 (E01-B) |
| WK-DMF0082-0321 | A1 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E05: 행 집계 — 대조표 E05 'FindData(F5) 조회+Draw (md §5)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN — go |  | 1 (E05) |
| WK-DMF0082-0322 | A1 | E07-B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E07-B: 행 집계 — 대조표 E07-B '§7-B spdMain_ClipboardPasted (L7864~L8199)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF |  | 1 (E07-B) |
| WK-DMF0082-0323 | A1 | E08-C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E08-C: 행 집계 — 대조표 E08-C 'Insert 행 키 셀 더블클릭 — 검색 팝업 (md §8-C)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GE |  | 1 (E08-C) |
| WK-DMF0082-0324 | A1 | EVENT:E-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-03: 행 집계 — 대조표 EVENT:E-03 'END_CUSTOMER → SCM_SITE_ID 콤보 재조회 (.cs:8294)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_D |  | 1 (EVENT:E-03) |
| WK-DMF0082-0325 | A1 | EVENT:E-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-12: 행 집계 — 대조표 EVENT:E-12 '붙여넣기 1행→N행 키 승계 + 콤보 재조회 (.cs:7918~8047)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF00 |  | 1 (EVENT:E-12) |
| WK-DMF0082-0326 | A1 | EVENT:E-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EVENT:E-14: 행 집계 — 대조표 EVENT:E-14 '*(AS-IS 없음)* 상위 변경 → **모달 조회조건 종속 컬럼 연쇄 초기화**' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_ |  | 1 (EVENT:E-14) |
| WK-DMF0082-0327 | A1 | F-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F-02: 행 집계 — 대조표 F-02 'FindData(캐시) / 조회 성공 시' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN — golden |  | 1 (F-02) |
| WK-DMF0082-0328 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행)' 의 A1 12요소: REVIEW:12 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0329 | A1 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:Form_Load: 행 집계 — 대조표 HANDLER:Form_Load 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:312` (라이브 8행)' 의 A1 12요소: REVIEW:12 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0330 | A1 | HANDLER:clbCustomer_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbCustomer_SelectedIndexChanged: 행 집계 — 대조표 HANDLER:clbCustomer_SelectedIndexChanged 'AS-IS `DMF0082_FcstNPri |  | 1 (HANDLER:clbCustomer_SelectedIndexChanged) |
| WK-DMF0082-0331 | A1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — 대조표 HANDLER:clbTeam_SelectedIndexChanged 'AS-IS `DMF0082_FcstNPrice_Mgmt. |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0082-0332 | A1 | L-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-03: 행 집계 — 대조표 L-03 '`LockColumn(0, maxCol, true)` / Draw() — 조회 직후 전 컬' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (L-03) |
| WK-DMF0082-0333 | A1 | M-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — M-21: 행 집계 — 대조표 M-21 'LOC/POINT3 vs INTEGER / Draw()(조회 직후 NOTATION 스왑)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082. |  | 1 (M-21) |
| WK-DMF0082-0334 | A1 | MODAL:ForecastTemplateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ForecastTemplateModal: 행 집계 — 대조표 MODAL:ForecastTemplateModal 'Excel Form 템플릿 다운로드 (81 전용)' 의 A1 12요소: REVIEW:12 |  | 1 (MODAL:ForecastTemplateModal) |
| WK-DMF0082-0335 | A1 | P-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-04: 행 집계 — 대조표 P-04 '당주 녹색 보더(Weekly/Monthly) / `count >= 2`(동일 주차명 복수)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (P-04) |
| WK-DMF0082-0336 | A1 | P-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-23: 행 집계 — 대조표 P-23 '기본 버킷요일 / 행 BUCKET 빈값/"0000000" → DEFAULT_BUCKET_D' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (P-23) |
| WK-DMF0082-0337 | A1 | P-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-24: 행 집계 — 대조표 P-24 '조회기간 기본값 / PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) ' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (P-24) |
| WK-DMF0082-0338 | A1 | PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPU | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA — 팝업·보조 SP |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0339 | A1 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA — 팝업·보조 SP 는 golden_case |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0340 | A1 | PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH — 팝업·보조 SP 는 golden_cases.cs |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0341 | A1 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0082/DMF0082_GET_MAIN_DATA.md —  |  | 67 (A-01 CRUD:MAIN:SEARCH DPF-02 ACT:DMF0082) |
| WK-DMF0082-0342 | A1 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: 골든 비교 케이스 없음(PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT — 팝업·보조 SP 는 gol |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0343 | A1 | PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0082/DMF0082_GET_SPREAD_TITLE |  | 62 (DPF-01 ACT:DMF0082_FcstNPrice_Mgmt.FindB) |
| WK-DMF0082-0344 | A1 | PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0082/DMF0082_POPUP_ |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0345 | A1 | PL-33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PL-33: 행 집계 — 대조표 PL-33 '`LockRange(iRow, MEASURE, iRow, "W_"+전주컬럼, true)` ' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF00 |  | 1 (PL-33) |
| WK-DMF0082-0346 | A1 | PL-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PL-36: 행 집계 — 대조표 PL-36 '`LockColumn(0, maxCol, true)` / FindData — 조회 직후 전' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF00 |  | 1 (PL-36) |
| WK-DMF0082-0347 | A1 | POPUP_GET_FUTUREPRICE_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — POPUP_GET_FUTUREPRICE_INFO: 골든 비교 케이스 없음(POPUP_GET_FUTUREPRICE_INFO — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0348 | A1 | REQ:1ST-37-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-37-2: 행 집계 — 대조표 REQ:1ST-37-2 '전체 조회조건 정상 동작 점검 (★)' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0349 | A1 | REQ:1ST-39-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-39-1: 행 집계 — 대조표 REQ:1ST-39-1 '81/81_JV: Cell Prod Site 컬럼 미조회 + 컬럼 셋팅에서도 제외' 의 A1 12요소: REVIEW:12 · FAIL 요소:  |  | 1 (REQ:1ST-39-1) |
| WK-DMF0082-0350 | A1 | REQ:1ST-39-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-39-2: 행 집계 — 대조표 REQ:1ST-39-2 '81/81_JV: Plant Site·AS From Site 컬럼 조회' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DM |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0351 | A1 | REQ:1ST-66-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:1ST-66-1: 행 집계 — 대조표 REQ:1ST-66-1 '81: 팝업 UI Search 클릭 시 데이터 조회' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0352 | A1 | S-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-01: 행 집계 — 대조표 S-01 '재진입 차단 / `blnWork == true`' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF0082_GET_MAIN — go |  | 1 (S-01) |
| WK-DMF0082-0353 | A1 | S-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-07: 행 집계 — 대조표 S-07 '조회 SP / `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SA' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (S-07) |
| WK-DMF0082-0354 | A1 | S-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-24: 행 집계 — 대조표 S-24 '저장 후 / isSaveOK=true, panel1 숨김, FindData(false) 재' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082 |  | 1 (S-24) |
| WK-DMF0082-0355 | A1 | S-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S-25: 행 집계 — 대조표 S-25 '① 동일 통화 / `sBaseER == sTargetER` → 입력값 그대로' 의 A1 12요소: REVIEW:12 · FAIL 요소: PKG_DMF0082.P_DMF00 |  | 1 (S-25) |
| WK-DMF0082-0356 | A1 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0082/SCM0001_GET_BIZ_TYPE_BY_DIVISI |  | 1 (DPF-09) |
| WK-DMF0082-0357 | A1 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 골든 비교 케이스 없음(SCM0001_GET_LOOKUP_VALUES — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 140 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0358 | A1 | UP_FX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UP_FX: 골든 비교 케이스 없음(UP_FX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D-07) |
| WK-DMF0082-0359 | A6 | A-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — A-15: 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 ·  |  | 1 (A-15) |
| WK-DMF0082-0360 | A6 | CRUD:E05:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:E05:SEARCH: 행 집계 — 대조표 CRUD:E05:SEARCH '[SEARCH] §5 FindData (F5, FindButton L671~L676 → F' 의 A6 11요소: NOT_RUN:6  |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0361 | A6 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 검증 엔진이 실행됐으나 이 대상(SP DMF0073_GET_VERSION_SALESPRICE)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬  |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0362 | A6 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E05: 행 집계 — 대조표 E05 'FindData(F5) 조회+Draw (md §5)' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 · NA:1 · FAIL 요소: SCM0001_ |  | 1 (E05) |
| WK-DMF0082-0363 | A6 | F-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — F-02: 행 집계 — 대조표 F-02 'FindData(캐시) / 조회 성공 시' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 · NA:1 · FAIL 요소: SCM0001_GET_ |  | 1 (F-02) |
| WK-DMF0082-0364 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행)' 의 A6 11요소: NOT_RUN:6 |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0365 | A6 | P-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P-24: 행 집계 — 대조표 P-24 '조회기간 기본값 / PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) ' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 ·  |  | 1 (P-24) |
| WK-DMF0082-0366 | A6 | PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPU | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA: 검증 엔진이 실행됐으나 이 대상(SP PKG_DMF0000.P_DMF0000_SAVE_EXC)을 판정하지 못함 — 결과 행 정 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0367 | A6 | PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA: 검증 엔진이 실행됐으나 이 대상(SP PKG_DMF0003.P_DMF0003_GET_MKT_)을 판정하지 못함 — 결과 행 정렬 순서 —  |  | 1 (REQ:1ST-65-3) |
| WK-DMF0082-0368 | A6 | PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH: 검증 엔진이 실행됐으나 이 대상(SP PKG_DMF0082.P_DMF0082_GET_BUTT)을 판정하지 못함 — 결과 행 정렬 순서 — AS |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0369 | A6 | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT: 검증 엔진이 실행됐으나 이 대상(SP PKG_DMF0082.P_DMF0082_GET_MAIN)을 판정하지 못함 — 결과 행 정렬 순 |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0370 | A6 | PL-36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PL-36: 행 집계 — 대조표 PL-36 '`LockColumn(0, maxCol, true)` / FindData — 조회 직후 전' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2  |  | 1 (PL-36) |
| WK-DMF0082-0371 | A6 | POPUP_GET_FUTUREPRICE_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — POPUP_GET_FUTUREPRICE_INFO: 검증 엔진이 실행됐으나 이 대상(SP POPUP_GET_FUTUREPRICE_INFO)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL O |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0372 | A6 | S-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — S-07: 행 집계 — 대조표 S-07 '조회 SP / `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SA' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 ·  |  | 1 (S-07) |
| WK-DMF0082-0373 | A6 | S-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — S-24: 행 집계 — 대조표 S-24 '저장 후 / isSaveOK=true, panel1 숨김, FindData(false) 재' 의 A6 11요소: NOT_RUN:6 · PASS:2 · REVIEW:2 ·  |  | 1 (S-24) |
| WK-DMF0082-0374 | A6 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_BIZ_TYPE_BY_DIVISION: 원장 V-6efaa083 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e49d6326 |  | 1 (DPF-09) |
| WK-DMF0082-0375 | A6 | SCM0001_GET_LOOKUP_VALUES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0001_GET_LOOKUP_VALUES: 원장 V-57eed966 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e8712333]: SCM0 |  | 140 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0376 | G03-WIRE | DMF0082 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — DMF0082 화면: 게이트 G03 As-is 이벤트 chkSum.CheckedChanged → chkSum / 게이트 G03 As-is 이벤트 btnMeasure.Click → btnMeasure_  |  | 17 (ACT:DMF0082_FcstNPrice_Mgmt..ctor ACT:DM) |
| WK-DMF0082-0377 | X-LOC | AS_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS_FROM_SITE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS_FROM_SITE) |
| WK-DMF0082-0378 | X-LOC | AsIncotermsEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AsIncotermsEdit: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AsIncotermsEdit) |
| WK-DMF0082-0379 | X-LOC | BizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizType) |
| WK-DMF0082-0380 | X-LOC | BizTypeByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BizTypeByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BizTypeByDivision) |
| WK-DMF0082-0381 | X-LOC | CELL_PROD_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CELL_PROD_SITE_ID: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CELL_PROD_SITE_ID) |
| WK-DMF0082-0382 | X-LOC | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CurrencyList: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CurrencyList) |
| WK-DMF0082-0383 | X-LOC | CustomsHandbook | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CustomsHandbook: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CustomsHandbook) |
| WK-DMF0082-0384 | X-LOC | DOM_EXP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DOM_EXP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DOM_EXP) |
| WK-DMF0082-0385 | X-LOC | DefaultBucketDay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DefaultBucketDay: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DefaultBucketDay) |
| WK-DMF0082-0386 | X-LOC | DeptId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeptId: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeptId) |
| WK-DMF0082-0387 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-DMF0082-0388 | X-LOC | EndCustomerByDivision40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivision40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivision40) |
| WK-DMF0082-0389 | X-LOC | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivisionDept: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0082-0390 | X-LOC | FCST_TYPE_NOT_FREE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FCST_TYPE_NOT_FREE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FCST_TYPE_NOT_FREE) |
| WK-DMF0082-0391 | X-LOC | FcstPriceEditMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstPriceEditMeasure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstPriceEditMeasure) |
| WK-DMF0082-0392 | X-LOC | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstType) |
| WK-DMF0082-0393 | X-LOC | FcstTypeByUserGroupDMF0082 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstTypeByUserGroupDMF0082: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstTypeByUserGroupDMF0082) |
| WK-DMF0082-0394 | X-LOC | FromSiteByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FromSiteByDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FromSiteByDivision) |
| WK-DMF0082-0395 | X-LOC | Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Incoterms: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Incoterms) |
| WK-DMF0082-0396 | X-LOC | ItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ItemType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ItemType) |
| WK-DMF0082-0397 | X-LOC | L2P `hotkey DELETE` 권한 0그룹 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L2P `hotkey DELETE` 권한 0그룹: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L2P `hotkey DELETE` 권한 0그룹) |
| WK-DMF0082-0398 | X-LOC | L3 `futurePriceInfo/EDIT`·`/INSERT` API_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L3 `futurePriceInfo/EDIT`·`/INSERT` API_) |
| WK-DMF0082-0399 | X-LOC | L7 `titleSet` 시트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L7 `titleSet` 시트: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0400 | X-LOC | Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Measure: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Measure) |
| WK-DMF0082-0401 | X-LOC | PlantByDivisionCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantByDivisionCompany: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantByDivisionCompany) |
| WK-DMF0082-0402 | X-LOC | SalesBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SalesBucket: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SalesBucket) |
| WK-DMF0082-0403 | X-LOC | SiteByEndCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SiteByEndCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SiteByEndCustomer) |
| WK-DMF0082-0404 | X-LOC | SoldCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SoldCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SoldCustomer) |
| WK-DMF0082-0405 | X-LOC | TeambyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TeambyDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TeambyDivision) |
| WK-DMF0082-0406 | X-LOC | YesOrNo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — YesOrNo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (YesOrNo) |
| WK-DMF0082-0407 | X-ROW | DMF0082_FcstNPrice_Mgmt.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 15 (ACT:DMF0082_FcstNPrice_Mgmt.ExcelButton ) |
| WK-DMF0082-0408 | X-ROW | DMF0082_FcstNPrice_Mgmt.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.FindButton: 진입점 집계 6검사 — PASS:4 · REVIEW:2 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.FindButton) |
| WK-DMF0082-0409 | X-ROW | DMF0082_FcstNPrice_Mgmt.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/VALUE_SET, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.OnShown ACT:) |
| WK-DMF0082-0410 | X-ROW | DMF0082_FcstNPrice_Mgmt.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLAG/FLOW/LOCAL/RETURN/ST |  | 89 (ACT:DMF0082_FcstNPrice_Mgmt.fnValidation) |
| WK-DMF0082-0411 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_EditChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Edit) |
| WK-DMF0082-0412 | X-ROW | DMF0082_FcstNPrice_Mgmt.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/FLAG/LOCAL/RETURN/UI_PROP, 연 |  | 19 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_KeyU) |
| WK-DMF0082-0413 | X-ROW | DMF0082_FcstNPrice_Mgmt.txtVersion_KeyDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_FcstNPrice_Mgmt.txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.txtVersion_K) |
| WK-DMF0082-0414 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup..ctor: 진입점 집계 2검사 — WARN:1 · NA:1 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup..) |
| WK-DMF0082-0415 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.FindB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.FindButton: 진입점 집계 4검사 — NA:2 · REVIEW:2 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.F) |
| WK-DMF0082-0416 | X-ROW | DMF0082_SaveSalesFuturePrice_Popup.InitE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup.InitEvent: 진입점 집계 3검사 — WARN:1 · PASS:1 · NA:1 |  | 2 (ACT:DMF0082_SaveSalesFuturePrice_Popup.I) |
| WK-DMF0082-0417 | M4 | DMF0082_SaveSalesFuturePrice_Popup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0082_SaveSalesFuturePrice_Popup: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0082_SaveSalesFuturePrice_P)을 판정하지 못함 — 팝업 선택값 반영 시나리오  |  | 1 (DPF-05) |
| WK-DMF0082-0418 | M4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 검증 엔진이 실행됐으나 이 대상(COND cboBucketType)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 59 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0419 | M4 | clbDivision / Division / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division / Div.: 검증 엔진이 실행됐으나 이 대상(COND clbDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0420 | M4 | drpPeriod / Period / From / To / 기간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drpPeriod / Period / From / To / 기간: 검증 엔진이 실행됐으나 이 대상(COND drpPeriod)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |

## W9 도구 오류 (113)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0082-0421 | C3 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan 의 C3 63요소: NA:62 · ERROR:1 |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0422 | C3 | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.chkSum_CheckedChanged 의 C3 63요소: NA:62 · ERROR:1 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0423 | C3 | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.clbCustomer_SelectedIndexChanged 의 C3 63요소: NA:62 · ERROR:1 |  | 3 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0424 | C3 | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.clbTeam_SelectedIndexChanged 의 C3 63요소: NA:62 · ERROR:1 |  | 4 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0425 | C3 | E01 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 E01 'spdMain_Changed — 셀 값 변경·배분 엔진 (md §1)' 의 C3 63요소: NA:62 · ERROR:1 |  | 1 (E01) |
| WK-DMF0082-0426 | C3 | HANDLER:spdMain_Changed | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 HANDLER:spdMain_Changed 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:5537` (라이브 834행)' 의 C3 63요소: NA:62 · ERROR:1 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0082-0427 | C3 | REQ:1ST-48-3 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 REQ:1ST-48-3 "잔존 데이터 저장 시 '수정 데이터 없음' 팝업 해소" 의 C3 63요소: NA:62 · ERROR:1 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0428 | C3 | VMI_YN / VMI | 하네스·환경 | C3 도구 오류 — 실측[T-25377caa]: [검사기 미검증] VMI_YN: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 1 (E01-A) |
| WK-DMF0082-0429 | B2 | A-11 | 하네스·환경 | B2 도구 오류 — 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 B2 16요소: PASS:8 · NOPATH:4 · NA:3 · ERROR:1 |  | 1 (A-11) |
| WK-DMF0082-0430 | B2 | COMMON:UC-05 | 하네스·환경 | B2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gr' 의 B2 16요소: PASS:8 · NOPATH:4 · NA:3 · ERRO |  | 1 (COMMON:UC-05) |
| WK-DMF0082-0431 | B2 | clbSalesSite / Sales Site | 하네스·환경 | B2 도구 오류 — 원장 V-109d306f SEARCH |  | 1 (E01-A) |
| WK-DMF0082-0432 | H5 | A-15 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 |  | 1 (A-15) |
| WK-DMF0082-0433 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실 |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0434 | H5 | DMF0082_FcstNPrice_Mgmt.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.CreateSpread 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0435 | H5 | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderSpan 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0436 | H5 | DPF-01 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 DPF-01 '`DM.DMF0082_GET_SPREAD_TITLE` p_division_id' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 판정필요 |  | 1 (DPF-01) |
| WK-DMF0082-0437 | H5 | DPF-04 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 DPF-04 '`DM0002_TitleSetForm_Popup` division (Column/Measu' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가  |  | 1 (DPF-04) |
| WK-DMF0082-0438 | H5 | L7 `titleSet` 시트 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 L7 `titleSet` 시트 '해소' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (L7 `titleSet` 시트) |
| WK-DMF0082-0439 | H5 | MODAL:VersionSelectModal | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 MODAL:VersionSelectModal '버전 선택 팝업' 의 H5 28요소: NA:15 · PASS:12 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0440 | H5 | REQ:CHAT-20260820-1 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 REQ:CHAT-20260820-1 'DMF0082 81 Division 컬럼의 AS-IS 대조 기준 = DMF0003 MAIN' 의 H5 28요소: NA:15 · PASS:12 · NOT_RU |  | 1 (REQ:CHAT-20260820-1) |
| WK-DMF0082-0441 | H5 | REQ:CHAT-20260915-EXLASTUPD | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼 추가' 의 H5 28요소: NA:15 · PASS:12  |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0442 | G1 | A-01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-01 '메인 조회 SP / `p_user_group = UserInfoContext.Current' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (A-01) |
| WK-DMF0082-0443 | G1 | A-11 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-11 '조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (A-11) |
| WK-DMF0082-0444 | G1 | A-13 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-13 '팝업 행 권한 / `AUTHORITY_YN != "Y"` && Action 빈값' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (A-13) |
| WK-DMF0082-0445 | G1 | A-15 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A-15 '팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_b' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (A-15) |
| WK-DMF0082-0446 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠" 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_ |  | 1 (COMMON:UC-02) |
| WK-DMF0082-0447 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_ |  | 1 (COMMON:UC-03) |
| WK-DMF0082-0448 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (COMMON:UC-06) |
| WK-DMF0082-0449 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_ |  | 1 (COMMON:UC-07) |
| WK-DMF0082-0450 | G1 | CRUD:E05:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:E05:SEARCH '[SEARCH] §5 FindData (F5, FindButton L671~L676 → F' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · N |  | 1 (CRUD:E05:SEARCH) |
| WK-DMF0082-0451 | G1 | CRUD:MAIN:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:MAIN:SEARCH '버전 조회 (GET_MAIN_DATA)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (CRUD:MAIN:SEARCH) |
| WK-DMF0082-0452 | G1 | CRUD:MAIN:SEARCH_CURRENT | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:MAIN:SEARCH_CURRENT 'Current 조회' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (CRUD:MAIN:SEARCH_CURRENT) |
| WK-DMF0082-0453 | G1 | D-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D-07 'InsertRow / `sDivision == "40"`' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (D-07) |
| WK-DMF0082-0454 | G1 | DP-01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 DP-01 'InitControls / `81prefix \\' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (DP-01) |
| WK-DMF0082-0455 | G1 | DP-04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 DP-04 'EditButton / `=="82"`' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (DP-04) |
| WK-DMF0082-0456 | G1 | DPF-01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 DPF-01 '`DM.DMF0082_GET_SPREAD_TITLE` p_division_id' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (DPF-01) |
| WK-DMF0082-0457 | G1 | DPF-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 DPF-02 '`DM.DMF0082_GET_MAIN_DATA` p_division_id + p_user_' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (DPF-02) |
| WK-DMF0082-0458 | G1 | E01-B | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 E01-B '수량 변경 — 버킷 요일비트 산출 (md §1-B)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (E01-B) |
| WK-DMF0082-0459 | G1 | E05 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 E05 'FindData(F5) 조회+Draw (md §5)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (E05) |
| WK-DMF0082-0460 | G1 | E07-B | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 E07-B '§7-B spdMain_ClipboardPasted (L7864~L8199)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (E07-B) |
| WK-DMF0082-0461 | G1 | E08-C | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 E08-C 'Insert 행 키 셀 더블클릭 — 검색 팝업 (md §8-C)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (E08-C) |
| WK-DMF0082-0462 | G1 | EVENT:E-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 EVENT:E-03 'END_CUSTOMER → SCM_SITE_ID 콤보 재조회 (.cs:8294)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (EVENT:E-03) |
| WK-DMF0082-0463 | G1 | EVENT:E-12 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 EVENT:E-12 '붙여넣기 1행→N행 키 승계 + 콤보 재조회 (.cs:7918~8047)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (EVENT:E-12) |
| WK-DMF0082-0464 | G1 | EVENT:E-14 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 EVENT:E-14 '*(AS-IS 없음)* 상위 변경 → **모달 조회조건 종속 컬럼 연쇄 초기화**' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (EVENT:E-14) |
| WK-DMF0082-0465 | G1 | F-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 F-02 'FindData(캐시) / 조회 성공 시' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (F-02) |
| WK-DMF0082-0466 | G1 | HANDLER:FindData | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 HANDLER:FindData 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · N |  | 1 (HANDLER:FindData) |
| WK-DMF0082-0467 | G1 | HANDLER:Form_Load | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 HANDLER:Form_Load 'AS-IS `DMF0082_FcstNPrice_Mgmt.cs:312` (라이브 8행)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NO |  | 1 (HANDLER:Form_Load) |
| WK-DMF0082-0468 | G1 | L-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 L-03 '`LockColumn(0, maxCol, true)` / Draw() — 조회 직후 전 컬' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (L-03) |
| WK-DMF0082-0469 | G1 | M-21 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 M-21 'LOC/POINT3 vs INTEGER / Draw()(조회 직후 NOTATION 스왑)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (M-21) |
| WK-DMF0082-0470 | G1 | MODAL:ForecastTemplateModal | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 MODAL:ForecastTemplateModal 'Excel Form 템플릿 다운로드 (81 전용)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (MODAL:ForecastTemplateModal) |
| WK-DMF0082-0471 | G1 | MODAL:VersionSelectModal | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 MODAL:VersionSelectModal '버전 선택 팝업' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0472 | G1 | P-04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 P-04 '당주 녹색 보더(Weekly/Monthly) / `count >= 2`(동일 주차명 복수)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (P-04) |
| WK-DMF0082-0473 | G1 | P-23 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 P-23 '기본 버킷요일 / 행 BUCKET 빈값/"0000000" → DEFAULT_BUCKET_D' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (P-23) |
| WK-DMF0082-0474 | G1 | P-24 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 P-24 '조회기간 기본값 / PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) ' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (P-24) |
| WK-DMF0082-0475 | G1 | PL-33 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 PL-33 '`LockRange(iRow, MEASURE, iRow, "W_"+전주컬럼, true)` ' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (PL-33) |
| WK-DMF0082-0476 | G1 | PL-36 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 PL-36 '`LockColumn(0, maxCol, true)` / FindData — 조회 직후 전' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (PL-36) |
| WK-DMF0082-0477 | G1 | REQ:1ST-37-2 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 REQ:1ST-37-2 '전체 조회조건 정상 동작 점검 (★)' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (REQ:1ST-37-2) |
| WK-DMF0082-0478 | G1 | REQ:1ST-39-1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 REQ:1ST-39-1 '81/81_JV: Cell Prod Site 컬럼 미조회 + 컬럼 셋팅에서도 제외' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (REQ:1ST-39-1) |
| WK-DMF0082-0479 | G1 | REQ:1ST-39-2 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 REQ:1ST-39-2 '81/81_JV: Plant Site·AS From Site 컬럼 조회' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (REQ:1ST-39-2) |
| WK-DMF0082-0480 | G1 | REQ:1ST-66-1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 REQ:1ST-66-1 '81: 팝업 UI Search 클릭 시 데이터 조회' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0481 | G1 | REQ:CHAT-20260915-EXLASTUPD | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 REQ:CHAT-20260915-EXLASTUPD '환율 모달 그리드에 Last Update Date / Last Update By 컬럼 추가' 의 G1 23요소: NA:17 · PASS:4 · |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0482 | G1 | S-01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 S-01 '재진입 차단 / `blnWork == true`' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (S-01) |
| WK-DMF0082-0483 | G1 | S-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 S-07 '조회 SP / `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SA' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (S-07) |
| WK-DMF0082-0484 | G1 | S-24 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 S-24 '저장 후 / isSaveOK=true, panel1 숨김, FindData(false) 재' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (S-24) |
| WK-DMF0082-0485 | G1 | S-25 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 S-25 '① 동일 통화 / `sBaseER == sTargetER` → 입력값 그대로' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (S-25) |
| WK-DMF0082-0486 | G1 | cboQty /   / Qty | 하네스·환경 | G1 도구 오류 — 원장 V-af739211 SEARCH / E2E smoke cond Checkbox |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.FindData ACT) |
| WK-DMF0082-0487 | G1 | 버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02) '변경' 의 G1 23요소: NA:17 · PASS:4 · ERROR:1 · NOT_RUN:1 |  | 1 (버튼 노출 원천 = `buttonAuth` 시트 (2026-10-02)) |
| WK-DMF0082-0488 | X-ROW | DMF0082_FcstNPrice_Mgmt.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.CreateSpread) |
| WK-DMF0082-0489 | X-ROW | DMF0082_FcstNPrice_Mgmt.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — NA:12 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0082_FcstNPrice_Mgmt.EditButton A) |
| WK-DMF0082-0490 | X-ROW | DMF0082_FcstNPrice_Mgmt.SetSpreadHeaderS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:4 · NA:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.SetSpreadHea) |
| WK-DMF0082-0491 | X-ROW | DMF0082_FcstNPrice_Mgmt.chkSum_CheckedCh | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.chkSum_Check) |
| WK-DMF0082-0492 | X-ROW | DMF0082_FcstNPrice_Mgmt.clbCustomer_Sele | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.clbCustomer_) |
| WK-DMF0082-0493 | X-ROW | DMF0082_FcstNPrice_Mgmt.clbTeam_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.clbTeam_Sele) |
| WK-DMF0082-0494 | M3 | new DM0002_TitleSetForm_Popup("DMF0082", | 하네스·환경 | M3 도구 오류 — 원장 V-febf1d3d |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.btnColumn_Cl) |
| WK-DMF0082-0495 | M4 | A-15 | 하네스·환경 | M4 도구 오류 — 실측[T-9fe9521f]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (A-15) |
| WK-DMF0082-0496 | M4 | AUTHORITY_YN | 하네스·환경 | M4 도구 오류 — 실측[T-86478670]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (A-13 A-14 PL-21 PL-22) |
| WK-DMF0082-0497 | M4 | B | 하네스·환경 | M4 도구 오류 — 실측[T-777018cb]: [검사기 미검증] B: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (S-23) |
| WK-DMF0082-0498 | M4 | BIZ_TYPE / Biz Type | 하네스·환경 | M4 도구 오류 — 실측[T-1ea07967]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (E08-C EVENT:E-09) |
| WK-DMF0082-0499 | M4 | C | 하네스·환경 | M4 도구 오류 — 실측[T-bf936914]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (E08-C) |
| WK-DMF0082-0500 | M4 | CELL_PROD_SITE_ID / Cell Prod Site | 하네스·환경 | M4 도구 오류 — 실측[T-02c36bb3]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (E08-C) |
| WK-DMF0082-0501 | M4 | DIVISION_ID / Division | 하네스·환경 | M4 도구 오류 — 실측[T-c39d976a]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (PL-20 PL-24 PL-25) |
| WK-DMF0082-0502 | M4 | DMF0082_FcstNPrice_Mgmt.spdMain_CellDoub | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0082_FcstNPrice_Mgmt.spdMain_CellDoubleClick 의 M4 5요소: NOT_RUN:3 · ERROR:2 |  | 68 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0503 | M4 | DP-11 | 하네스·환경 | M4 도구 오류 — 실측[T-b2ff9d43]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (DP-11) |
| WK-DMF0082-0504 | M4 | DPF-03 | 하네스·환경 | M4 도구 오류 — 실측[T-8a3aebd8]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (DPF-03) |
| WK-DMF0082-0505 | M4 | DPF-04 | 하네스·환경 | M4 도구 오류 — 실측[T-73f1ebeb]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (DPF-04) |
| WK-DMF0082-0506 | M4 | E | 하네스·환경 | M4 도구 오류 — 실측[T-faee532b]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (EVENT:E-09 EVENT:E-10 EVENT:E-11 EVENT:E) |
| WK-DMF0082-0507 | M4 | E08 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 E08 '§8 헤더/셀 더블클릭 (spdMain_CellDoubleClick, L3534~L3833' 의 M4 28요소: ERROR:24 · NOT_RUN:4 |  | 1 (E08) |
| WK-DMF0082-0508 | M4 | F | 하네스·환경 | M4 도구 오류 — 실측[T-f1185f2a]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (F-09 F-10 S-23) |
| WK-DMF0082-0509 | M4 | FCST_TYPE / FCST Type | 하네스·환경 | M4 도구 오류 — 실측[T-88d69247]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (F-09 F-10) |
| WK-DMF0082-0510 | M4 | HANDLER:spdMain_CellDoubleClick | 하네스·환경 | M4 도구 오류 — 실측[T-a9a865d1]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0082-0511 | M4 | I | 하네스·환경 | M4 도구 오류 — 실측[T-b2c8145c]: [검사기 미검증] I: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (A-14 PL-22 PL-25) |
| WK-DMF0082-0512 | M4 | INCOTERMS / Incoterms | 하네스·환경 | M4 도구 오류 — 실측[T-5949a109]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0513 | M4 | ITEM_CLASS_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-05630509]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (PL-29 EVENT:E-10) |
| WK-DMF0082-0514 | M4 | ITEM_ID / Model | 하네스·환경 | M4 도구 오류 — 실측[T-19b6985b]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (E08-C EVENT:E-10) |
| WK-DMF0082-0515 | M4 | ITEM_NAME / Model Name | 하네스·환경 | M4 도구 오류 — 실측[T-a638a5d7]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (PL-30 EVENT:E-10) |
| WK-DMF0082-0516 | M4 | ITEM_TYPE / Item Type | 하네스·환경 | M4 도구 오류 — 실측[T-e94c190c]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (EVENT:E-10) |
| WK-DMF0082-0517 | M4 | L | 하네스·환경 | M4 도구 오류 — 실측[T-af6b896f]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 23 (PL-00 PL-01 PL-02 PL-03 PL-04 PL-19 PL-2) |
| WK-DMF0082-0518 | M4 | M | 하네스·환경 | M4 도구 오류 — 실측[T-58300b4f]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (M-25) |
| WK-DMF0082-0519 | M4 | MEASURE / Measure | 하네스·환경 | M4 도구 오류 — 실측[T-cead534a]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 8 (PL-19 PL-20 PL-21 PL-25 PL-31 PL-33 PL-3) |
| WK-DMF0082-0520 | M4 | MODAL:ExchangeRateModal | 하네스·환경 | M4 도구 오류 — 실측[T-ca247cf6]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0082-0521 | M4 | MODAL:VersionSelectModal | 하네스·환경 | M4 도구 오류 — 실측[T-d7e12c34]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (MODAL:VersionSelectModal) |
| WK-DMF0082-0522 | M4 | N | 하네스·환경 | M4 도구 오류 — 실측[T-d23e8446]: [검사기 미검증] N: P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0082_FcstNPrice_Mgmt.spdMain_Cell) |
| WK-DMF0082-0523 | M4 | NICK_NAME / Nick Name | 하네스·환경 | M4 도구 오류 — 실측[T-ad12996f]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (PL-32 EVENT:E-10) |
| WK-DMF0082-0524 | M4 | OWNER / Owner | 하네스·환경 | M4 도구 오류 — 실측[T-191fe4f6]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0525 | M4 | PROJECT_CODE / Project Code | 하네스·환경 | M4 도구 오류 — 실측[T-9c60f2b5]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (EVENT:E-09) |
| WK-DMF0082-0526 | M4 | PROJECT_NAME / Project | 하네스·환경 | M4 도구 오류 — 실측[T-f3586ca4]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (PL-26 EVENT:E-09) |
| WK-DMF0082-0527 | M4 | REQ:1ST-48-1 | 하네스·환경 | M4 도구 오류 — 실측[T-88b1365b]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:1ST-48-1) |
| WK-DMF0082-0528 | M4 | REQ:1ST-48-2 | 하네스·환경 | M4 도구 오류 — 실측[T-5c31e912]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:1ST-48-2) |
| WK-DMF0082-0529 | M4 | REQ:1ST-48-3 | 하네스·환경 | M4 도구 오류 — 실측[T-ccd59cc4]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:1ST-48-3) |
| WK-DMF0082-0530 | M4 | REQ:1ST-49-1 | 하네스·환경 | M4 도구 오류 — 실측[T-53d5ec68]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:1ST-49-1) |
| WK-DMF0082-0531 | M4 | REQ:1ST-66-1 | 하네스·환경 | M4 도구 오류 — 실측[T-2158d250]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:1ST-66-1) |
| WK-DMF0082-0532 | M4 | REQ:CHAT-20260915-EXLASTUPD | 하네스·환경 | M4 도구 오류 — 실측[T-a330d47a]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (REQ:CHAT-20260915-EXLASTUPD) |
| WK-DMF0082-0533 | M4 | S | 하네스·환경 | M4 도구 오류 — 실측[T-a70112d1]: [검사기 미검증] P 셀 위치 확인 불가 — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (S-07 S-23 S-25) |
