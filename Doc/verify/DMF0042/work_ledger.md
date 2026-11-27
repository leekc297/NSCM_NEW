# 작업 원장 — DMF0042 · 2026-11-27 00:28

> 검사 인스턴스 2365건 중 PASS·NA 756건 외 **1609건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 372 | 재판정 PASS |
| W5 | 검사기 연결 | 12 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 13 | 실행 → PASS |
| W7 | 기대값 확정 | 69 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 1143 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 1143 · FE 341 · 사람 판정 / AS-IS 원문 확인 → 재판정 69 · DB 31 · E2E 13 · 하네스 12
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  |  |  |  |  |  |  | 337 | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  | 255 |  |  |  | 5 |  | 48 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 183 | 무변경 편집 종료 시 연쇄 미발동 |
| H6 | POPUP |  |  | 57 |  | 1 |  |  |  | 73 | 팝업 표준·열림 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 78 | 그리드 셀 cascade 후보 |
| E4 | EDIT |  |  | 14 |  |  |  |  |  | 60 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 50 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 47 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  |  | 6 |  | 38 | 팝업 선택값 반영 |
| M3 | POPUP |  |  | 14 |  |  |  |  |  | 29 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| F4 | DB |  |  |  |  |  |  | 2 |  | 41 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G5 | POPUP |  |  | 4 |  | 1 |  |  |  | 31 | 팝업 조건 연동(인자) |
| DB-SYN | DB |  |  |  |  | 4 |  |  |  | 30 | BE 계정 시노님·권한·대상 객체 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 29 | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 27 | 배경·글자색 규칙 |
| B4 | COMBO |  |  | 8 |  | 2 |  |  |  | 11 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 21 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 17 | 라벨 명칭 |
| G4 | DESIGN |  |  | 2 |  |  | 13 | 1 |  |  | 조회조건 표시·라벨·활성 |
| A6 | GEN |  |  | 11 |  |  |  |  |  | 3 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B3 | COMBO |  |  |  |  |  |  |  |  | 14 | 콤보 후보 정렬 = AS-IS |
| D5 | EDIT |  |  | 2 |  |  |  |  |  | 6 | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 2 |  |  |  | 4 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  |  |  | 4 | 콤보 후보 중복 없음 |
| X-LOC | GEN |  |  |  |  |  |  | 4 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 4 | 신규행 기본값·자동세팅·Insert 전제 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 2 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  |  |  |  | 2 | 조회조건 초기 기본값 = AS-IS Form_Load |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  | 1 |  |  |  |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 레이아웃·스크롤·크기 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |

## W3 동작 수정 (372)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0001 | J2 | DMF0042 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | J2 FAIL 수정 — DMF0042 화면: 원장 V-02d642c4 RULE_SCREEN / 원장 V-22a4a892 DEFECT / 원장 V-fcbc1908 GENERAL / 원장 V-49ea4cea GENERAL / 원장 V-a |  | 741 (G1 G2 G4 G8 G9 — 1#1 1#2 1#3 1#4 1#5 1#6) |
| WK-DMF0042-0002 | B4 | CELL_PROD_SITE / Cell Prod Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | B4 FAIL 수정 — CELL_PROD_SITE / Cell Prod Site: 원장 V-736e5e45 COLUMN |  | 0 () |
| WK-DMF0042-0003 | B4 | DMF0042_2_BizPlan.GetBizTypebyDivision | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetBizTypebyDivision: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetBizTypebyDivision 의 B4 18요소: ERROR:10 · NA: |  | 3 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0004 | B4 | DMF0042_2_BizPlan.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetCellColor: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · P |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0005 | B4 | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | FE(repairScope=DB_ONLY — 이번 범위 밖) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetCellIndexBySpanRowCells: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellIndexBySpanRowCells 의 B4 18요소: ER |  | 4 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0006 | B4 | DMF0042_2_BizPlan.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetCellNumbersByRow: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellNumbersByRow 의 B4 18요소: ERROR:10 · NA:4  |  | 14 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0007 | B4 | DMF0042_2_BizPlan.GetCellProdSite | FE(repairScope=DB_ONLY — 이번 범위 밖) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetCellProdSite: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 B4 18요소: ERROR:10 · NA:4 · NOPATH |  | 8 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0008 | B4 | DMF0042_2_BizPlan.GetDayRange | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetDayRange: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PAS |  | 6 (ACT:DMF0042_2_BizPlan.GetDayRange:3091:1) |
| WK-DMF0042-0009 | B4 | DMF0042_2_BizPlan.GetLookupData | DB(🛠️/🧯 적용 가능) | B4 FAIL 수정 — DMF0042_2_BizPlan.GetLookupData: 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetLookupData 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · |  | 3 (ACT:DMF0042_2_BizPlan.GetLookupData:3127) |
| WK-DMF0042-0010 | F1 | DMF0042 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F1 FAIL 수정 — DMF0042 화면: 원장 V-1f2afd11 RULE_SCREEN / 원장 V-eb3408a8 RULE_SCREEN / 원장 V-ef57270d RULE_SCREEN / 원장 V-48f42d7f RULE_SC |  | 1189 (G8 1#15 Delete (F9) Save (F7) 3#1 3#3 22) |
| WK-DMF0042-0011 | F3 | DMF0042 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F3 FAIL 수정 — DMF0042 화면: 원장 V-71d9bb1a RULE_SCREEN / 원장 V-08ebae1c RULE_SCREEN / 원장 V-78dce8d4 RULE_SCREEN / 원장 V-a033d198 RULE_SC |  | 2 (17 Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0012 | F5 | DMF0042 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F5 FAIL 수정 — DMF0042 화면: 원장 V-749baf1a RULE_SCREEN / 원장 V-a8211de7 RULE_SCREEN / 원장 V-dc85b250 RULE_SCREEN / 원장 V-7215060e DEFECT  |  | 42 (Delete (F9) 22 ACT:DMF0042_1_BizPlan.Del) |
| WK-DMF0042-0013 | G4 | cboClosed / Closed | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboClosed / Closed: E2E smoke labels — 누락 라벨 |  | 17 (1#15 ACT:DMF0042_1_BizPlan.InitControls ) |
| WK-DMF0042-0014 | G4 | cboQty / . / Qty | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboQty / . / Qty: E2E smoke labels — 누락 라벨 |  | 1 (1#14) |
| WK-DMF0042-0015 | H4 | DMF0042 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H4 FAIL 수정 — DMF0042 화면: 원장 V-988babf4 RULE_SCREEN / 원장 V-66450783 RULE_SCREEN / 원장 V-d06c548b RULE_SCREEN / 원장 V-a04d6c13 RULE_SC |  | 25 (18 ACT:DMF0042_1_BizPlan.spdMain_TopChan) |
| WK-DMF0042-0016 | D5 | CELL_PROD_SITE / Cell Prod Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | D5 FAIL 수정 — CELL_PROD_SITE / Cell Prod Site: 실측[T-2deb2d76]: CELL_PROD_SITE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=0 dataMap=Y  |  | 4 (ACT:DMF0042_BizPlan.InitSpread ACT:DMF00) |
| WK-DMF0042-0017 | D5 | DMF0042_2_BizPlan.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | D5 FAIL 수정 — DMF0042_2_BizPlan.CreateSpread: 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 D5 23요소: NA:15 · ERROR:4 · PASS:3 · FAI |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0018 | E4 | MSG00002 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00002: 원장 V-e02c62bd ASIS / 원장 V-86dcf637 ASIS / 원장 V-82c08dd4 ASIS / 원장 V-aa9f4ac3 ASIS / 원장 V-64ccae99 ASIS / 원장 |  | 9 (저장 검증 8 (#13~20) Grid 입력 4 (#39~40/41/44) |
| WK-DMF0042-0019 | E4 | MSG00002 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00002: 원장 V-11ab8740 / 실측[T-457f2fad]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나 |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-0020 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-3e41b595 ASIS / 원장 V-119e9de9 ASIS / 원장 V-a097e1c2 ASIS / 원장 V-e3630fbf ASIS / 원장 V-87e8f4da ASIS / 원장 |  | 13 (24 저장 검증 8 (#13~20) ACT:DMF0042_1_BizPla) |
| WK-DMF0042-0021 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-3e41b595 / 실측[T-1115bd5d]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:912:59) |
| WK-DMF0042-0022 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-119e9de9 / 실측[T-ab18b973]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:943:71) |
| WK-DMF0042-0023 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-a097e1c2 / 실측[T-7286563e]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:967:82) |
| WK-DMF0042-0024 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-e3630fbf / 실측[T-5c0369a9]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:912:82) |
| WK-DMF0042-0025 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-87e8f4da / 실측[T-e96fe73c]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1071:137) |
| WK-DMF0042-0026 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-d9b2a1c2 / 실측[T-db01f180]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:955:66) |
| WK-DMF0042-0027 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-10fd120c / 실측[T-544eb0df]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:986:78) |
| WK-DMF0042-0028 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-bca54e32 / 실측[T-eb828187]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1010:89) |
| WK-DMF0042-0029 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-05ed2d14 / 실측[T-523d21c7]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_BizPlan.SaveData:973:59) |
| WK-DMF0042-0030 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-a8a9ff28 / 실측[T-a0aeacff]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_BizPlan.SaveData:1004:71) |
| WK-DMF0042-0031 | E4 | MSG00310 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00310: 원장 V-f0299336 / 실측[T-d535e96c]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) |  | 1 (ACT:DMF0042_BizPlan.SaveData:1028:82) |
| WK-DMF0042-0032 | A6 | 1#9 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 1#9: 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF00 |  | 1 (1#9) |
| WK-DMF0042-0033 | A6 | 20 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 20: 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF |  | 1 (20) |
| WK-DMF0042-0034 | A6 | 25 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 25: 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 1 (25) |
| WK-DMF0042-0035 | A6 | DMF0042_1_RTF.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_1_RTF.FindData: 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF004 |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0036 | A6 | DMF0042_1_RTF.FindDataMain | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PK |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0037 | A6 | DMF0042_2_BizPlan.FindButton | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소 |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0038 | A6 | DMF0042_2_BizPlan.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_2_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PK |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0039 | A6 | DMF0042_3_BizPlan.FindButton | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소 |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0040 | A6 | DMF0042_3_BizPlan.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_3_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PK |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0041 | A6 | Division 분기 33 (사업부분기 전수) | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — Division 분기 33 (사업부분기 전수): 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo'  |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0042 | A6 | PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINES | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA: 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['USER_ID'] ↔ TO- |  | 192 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0043 | X-ROW | DMF0042_1_BizPlan..ctor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan..ctor: 진입점 집계 2검사 — NA:1 · FAIL:1 |  | 3 (ACT:DMF0042_1_BizPlan..ctor:201:1 ACT:DM) |
| WK-DMF0042-0044 | X-ROW | DMF0042_1_BizPlan.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.CreateSpread: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_1_BizPlan.CreateSpread ACT:D) |
| WK-DMF0042-0045 | X-ROW | DMF0042_1_BizPlan.DefineProperty | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.DefineProperty: 진입점 집계 9검사 — PASS:4 · NA:2 · NOT_RUN:2 · FAIL:1 |  | 13 (ACT:DMF0042_1_BizPlan.DefineProperty:327) |
| WK-DMF0042-0046 | X-ROW | DMF0042_1_BizPlan.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.DeleteButton: 진입점 집계 4검사 — FAIL:3 · ERROR:1 |  | 6 (ACT:DMF0042_1_BizPlan.DeleteButton:527:1) |
| WK-DMF0042-0047 | X-ROW | DMF0042_1_BizPlan.Dispose | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.Dispose: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 3 (ACT:DMF0042_1_BizPlan.Dispose:16:1 ACT:D) |
| WK-DMF0042-0048 | X-ROW | DMF0042_1_BizPlan.EditButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.EditButton: 진입점 집계 29검사 — ERROR:22 · PASS:4 · NA:2 · FAIL:1 |  | 48 (ACT:DMF0042_1_BizPlan.EditButton:541:1 A) |
| WK-DMF0042-0049 | X-ROW | DMF0042_1_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.FindButton: 진입점 집계 4검사 — FAIL:2 · REVIEW:1 · PASS:1 |  | 2 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0050 | X-ROW | DMF0042_1_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.FindData: 진입점 집계 29검사 — ERROR:16 · PASS:7 · FAIL:2 · NA:2 · REVIEW:1 · NOT_RUN:1 |  | 64 (ACT:DMF0042_1_BizPlan.FindData:686:1 ACT) |
| WK-DMF0042-0051 | X-ROW | DMF0042_1_BizPlan.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.Form_Load: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 7 (ACT:DMF0042_1_BizPlan.Form_Load ACT:DMF0) |
| WK-DMF0042-0052 | X-ROW | DMF0042_1_BizPlan.GetBizTypebyDivision | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetBizTypebyDivision: 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 |  | 7 (ACT:DMF0042_1_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0053 | X-ROW | DMF0042_1_BizPlan.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_1_BizPlan.GetCellColor ACT:D) |
| WK-DMF0042-0054 | X-ROW | DMF0042_1_BizPlan.GetCellIndexBySpanRowC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetCellIndexBySpanRowCells: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_1_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0055 | X-ROW | DMF0042_1_BizPlan.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetCellNumbersByRow: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_1_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0056 | X-ROW | DMF0042_1_BizPlan.GetCellProdSite | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetCellProdSite: 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 |  | 12 (ACT:DMF0042_1_BizPlan.GetCellProdSite AC) |
| WK-DMF0042-0057 | X-ROW | DMF0042_1_BizPlan.GetDayRange | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetDayRange: 진입점 집계 4검사 — ERROR:2 · FAIL:1 · PASS:1 |  | 8 (ACT:DMF0042_1_BizPlan.GetDayRange ACT:DM) |
| WK-DMF0042-0058 | X-ROW | DMF0042_1_BizPlan.GetFuturePriceInfo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetFuturePriceInfo: 진입점 집계 6검사 — NA:2 · PASS:2 · FAIL:1 · ERROR:1 |  | 9 (ACT:DMF0042_1_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-0059 | X-ROW | DMF0042_1_BizPlan.GetLookupData | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetLookupData: 진입점 집계 4검사 — PASS:1 · FAIL:1 · NA:1 · NOPATH:1 |  | 7 (ACT:DMF0042_1_BizPlan.GetLookupData ACT:) |
| WK-DMF0042-0060 | X-ROW | DMF0042_1_BizPlan.GetSpdTitle | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetSpdTitle: 진입점 집계 8검사 — ERROR:4 · NA:2 · FAIL:1 · PASS:1 |  | 8 (ACT:DMF0042_1_BizPlan.GetSpdTitle:2886:1) |
| WK-DMF0042-0061 | X-ROW | DMF0042_1_BizPlan.GetThisWeekMonday | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.GetThisWeekMonday: 진입점 집계 3검사 — NA:2 · FAIL:1 |  | 10 (ACT:DMF0042_1_BizPlan.GetThisWeekMonday ) |
| WK-DMF0042-0062 | X-ROW | DMF0042_1_BizPlan.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.InitControls: 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 |  | 48 (ACT:DMF0042_1_BizPlan.InitControls:234:1) |
| WK-DMF0042-0063 | X-ROW | DMF0042_1_BizPlan.InitSaveDataTable | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.InitSaveDataTable: 진입점 집계 2검사 — FAIL:1 · PASS:1 |  | 6 (ACT:DMF0042_1_BizPlan.InitSaveDataTable ) |
| WK-DMF0042-0064 | X-ROW | DMF0042_1_BizPlan.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.InitSpread: 진입점 집계 5검사 — PASS:3 · NOT_RUN:1 · FAIL:1 |  | 6 (ACT:DMF0042_1_BizPlan.InitSpread ACT:DMF) |
| WK-DMF0042-0065 | X-ROW | DMF0042_1_BizPlan.InsertButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.InsertButton: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 2 (ACT:DMF0042_1_BizPlan.InsertButton ACT:D) |
| WK-DMF0042-0066 | X-ROW | DMF0042_1_BizPlan.InsertRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.InsertRow: 진입점 집계 198검사 — ERROR:118 · NA:52 · PASS:19 · NOPATH:6 · FAIL:3 |  | 165 (ACT:DMF0042_1_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-0067 | X-ROW | DMF0042_1_BizPlan.MinColumnChk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.MinColumnChk: 진입점 집계 1검사 — FAIL:1 |  | 10 (ACT:DMF0042_1_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-0068 | X-ROW | DMF0042_1_BizPlan.OnShown | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.OnShown: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_1_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-0069 | X-ROW | DMF0042_1_BizPlan.ParameterString | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.ParameterString: 진입점 집계 1검사 — FAIL:1 |  | 17 (ACT:DMF0042_1_BizPlan.ParameterString AC) |
| WK-DMF0042-0070 | X-ROW | DMF0042_1_BizPlan.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.SaveButton: 진입점 집계 6검사 — FAIL:2 · ERROR:2 · PASS:1 · NA:1 |  | 1 (ACT:DMF0042_1_BizPlan.SaveButton:677:1) |
| WK-DMF0042-0071 | X-ROW | DMF0042_1_BizPlan.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.SaveData: 진입점 집계 23검사 — ERROR:10 · FAIL:6 · PASS:5 · NA:2 |  | 180 (ACT:DMF0042_1_BizPlan.SaveData:803:1 ACT) |
| WK-DMF0042-0072 | X-ROW | DMF0042_1_BizPlan.SetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.SetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_1_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-0073 | X-ROW | DMF0042_1_BizPlan.SetSpreadColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.SetSpreadColumn: 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 |  | 19 (ACT:DMF0042_1_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0074 | X-ROW | DMF0042_1_BizPlan.SetSpreadHeaderSpan | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.SetSpreadHeaderSpan: 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 |  | 53 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0075 | X-ROW | DMF0042_1_BizPlan.ValidationCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.ValidationCheck: 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 |  | 7 (ACT:DMF0042_1_BizPlan.ValidationCheck AC) |
| WK-DMF0042-0076 | X-ROW | DMF0042_1_BizPlan.btnColumn_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnColumn_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-0077 | X-ROW | DMF0042_1_BizPlan.btnCutOff_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnCutOff_Click: 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 |  | 11 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-0078 | X-ROW | DMF0042_1_BizPlan.btnExchangeRate_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnExchangeRate_Click: 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 |  | 9 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-0079 | X-ROW | DMF0042_1_BizPlan.btnItemId_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnItemId_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 13 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-0080 | X-ROW | DMF0042_1_BizPlan.btnMeasure_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnMeasure_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-0081 | X-ROW | DMF0042_1_BizPlan.btnOwner_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnOwner_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 12 (ACT:DMF0042_1_BizPlan.btnOwner_Click:294) |
| WK-DMF0042-0082 | X-ROW | DMF0042_1_BizPlan.btnProject_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnProject_Click: 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 |  | 13 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0083 | X-ROW | DMF0042_1_BizPlan.btnReplace_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnReplace_Click: 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 |  | 44 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-0084 | X-ROW | DMF0042_1_BizPlan.btnSetPrice_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.btnSetPrice_Click: 진입점 집계 13검사 — PASS:7 · ERROR:3 · FAIL:2 · NA:1 |  | 11 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0085 | X-ROW | DMF0042_1_BizPlan.cboBucketType_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.cboBucketType_Click: 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 |  | 4 (ACT:DMF0042_1_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-0086 | X-ROW | DMF0042_1_BizPlan.cboBucketType_Selected | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.cboBucketType_SelectedIndexChanged: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_1_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0087 | X-ROW | DMF0042_1_BizPlan.cboDivision_SelectedIn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.cboDivision_SelectedIndexChanged: 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 |  | 47 (ACT:DMF0042_1_BizPlan.cboDivision_Select) |
| WK-DMF0042-0088 | X-ROW | DMF0042_1_BizPlan.chkSum_CheckedChanged | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.chkSum_CheckedChanged: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_1_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0089 | X-ROW | DMF0042_1_BizPlan.clbCustomer_SelectedIn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 8검사 — ERROR:6 · FAIL:1 · PASS:1 |  | 5 (ACT:DMF0042_1_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0090 | X-ROW | DMF0042_1_BizPlan.clbTeam_SelectedIndexC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.clbTeam_SelectedIndexChanged: 진입점 집계 7검사 — ERROR:5 · PASS:1 · FAIL:1 |  | 13 (ACT:DMF0042_1_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0091 | X-ROW | DMF0042_1_BizPlan.fnValidation | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.fnValidation: 진입점 집계 1검사 — FAIL:1 |  | 48 (ACT:DMF0042_1_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-0092 | X-ROW | DMF0042_1_BizPlan.spdMain_CellDoubleClic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.spdMain_CellDoubleClick: 진입점 집계 78검사 — ERROR:38 · NA:23 · FAIL:8 · PASS:5 · NOT_RUN:2 · NOPATH:2 |  | 120 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0093 | X-ROW | DMF0042_1_BizPlan.spdMain_Changed | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.spdMain_Changed: 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 |  | 425 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0094 | X-ROW | DMF0042_1_BizPlan.spdMain_ComboSelChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.spdMain_ComboSelChange: 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0095 | X-ROW | DMF0042_1_BizPlan.spdMain_EditChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.spdMain_EditChange: 진입점 집계 1검사 — FAIL:1 |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_EditChange) |
| WK-DMF0042-0096 | X-ROW | DMF0042_1_BizPlan.spdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.spdMain_TopChange: 진입점 집계 2검사 — FAIL:2 |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-0097 | X-ROW | DMF0042_1_RTF.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.FindData: 진입점 집계 7검사 — ERROR:3 · REVIEW:1 · FAIL:1 · PASS:1 · NA:1 |  | 15 (ACT:DMF0042_1_RTF.FindData ACT:DMF0042_1) |
| WK-DMF0042-0098 | X-ROW | DMF0042_1_RTF.FindDataMain | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 |  | 6 (ACT:DMF0042_1_RTF.FindDataMain ACT:DMF00) |
| WK-DMF0042-0099 | X-ROW | DMF0042_1_RTF.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.SaveButton: 진입점 집계 5검사 — ERROR:4 · FAIL:1 |  | 1 (ACT:DMF0042_1_RTF.SaveButton:379:1) |
| WK-DMF0042-0100 | X-ROW | DMF0042_1_RTF.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.SaveData: 진입점 집계 9검사 — ERROR:5 · PASS:2 · FAIL:1 · NA:1 |  | 63 (ACT:DMF0042_1_RTF.SaveData:388:1 ACT:DMF) |
| WK-DMF0042-0101 | X-ROW | DMF0042_1_RTF.btnButtonList_UsrButtonLis | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.btnButtonList_UsrButtonList_Click_Detected: 진입점 집계 3검사 — ERROR:2 · FAIL:1 |  | 11 (ACT:DMF0042_1_RTF.btnButtonList_UsrButto) |
| WK-DMF0042-0102 | X-ROW | DMF0042_2_BizPlan.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.CreateSpread: 진입점 집계 4검사 — ERROR:3 · FAIL:1 |  | 1 (ACT:DMF0042_2_BizPlan.CreateSpread) |
| WK-DMF0042-0103 | X-ROW | DMF0042_2_BizPlan.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.DeleteButton: 진입점 집계 3검사 — FAIL:2 · ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.DeleteButton:530:5) |
| WK-DMF0042-0104 | X-ROW | DMF0042_2_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 |  | 1 (ACT:DMF0042_2_BizPlan.FindButton) |
| WK-DMF0042-0105 | X-ROW | DMF0042_2_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.FindData: 진입점 집계 30검사 — ERROR:20 · PASS:5 · NA:2 · REVIEW:1 · FAIL:1 · NOT_RUN:1 |  | 10 (ACT:DMF0042_2_BizPlan.FindData:651:2 ACT) |
| WK-DMF0042-0106 | X-ROW | DMF0042_2_BizPlan.GetBizTypebyDivision | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetBizTypebyDivision: 진입점 집계 5검사 — FAIL:1 · ERROR:1 · PASS:1 · NA:1 · NOPATH:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0107 | X-ROW | DMF0042_2_BizPlan.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetCellColor: 진입점 집계 3검사 — ERROR:2 · FAIL:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellColor) |
| WK-DMF0042-0108 | X-ROW | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetCellIndexBySpanRowCells: 진입점 집계 2검사 — FAIL:1 · ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0109 | X-ROW | DMF0042_2_BizPlan.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetCellNumbersByRow: 진입점 집계 2검사 — FAIL:1 · ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0110 | X-ROW | DMF0042_2_BizPlan.GetCellProdSite | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetCellProdSite: 진입점 집계 5검사 — ERROR:3 · FAIL:1 · PASS:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellProdSite) |
| WK-DMF0042-0111 | X-ROW | DMF0042_2_BizPlan.GetDayRange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetDayRange: 진입점 집계 5검사 — ERROR:3 · FAIL:1 · PASS:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetDayRange) |
| WK-DMF0042-0112 | X-ROW | DMF0042_2_BizPlan.GetLookupData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.GetLookupData: 진입점 집계 5검사 — PASS:1 · FAIL:1 · ERROR:1 · NA:1 · NOPATH:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetLookupData) |
| WK-DMF0042-0113 | X-ROW | DMF0042_2_BizPlan.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.InitControls: 진입점 집계 33검사 — PASS:20 · NOT_RUN:9 · ERROR:2 · FAIL:1 · NA:1 |  | 24 (ACT:DMF0042_2_BizPlan.InitControls:228:1) |
| WK-DMF0042-0114 | X-ROW | DMF0042_2_BizPlan.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.SaveData: 진입점 집계 19검사 — ERROR:12 · FAIL:4 · PASS:2 · NA:1 |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1290:248) |
| WK-DMF0042-0115 | X-ROW | DMF0042_2_BizPlan.ValidationCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.ValidationCheck: 진입점 집계 3검사 — PASS:1 · FAIL:1 · ERROR:1 |  | 7 (ACT:DMF0042_2_BizPlan.ValidationCheck AC) |
| WK-DMF0042-0116 | X-ROW | DMF0042_2_BizPlan.btnColumn_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnColumn_Click: 진입점 집계 16검사 — ERROR:6 · PASS:5 · FAIL:3 · NA:2 |  | 2 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-0117 | X-ROW | DMF0042_2_BizPlan.btnCutOff_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnCutOff_Click: 진입점 집계 6검사 — ERROR:3 · FAIL:1 · PASS:1 · NA:1 |  | 4 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-0118 | X-ROW | DMF0042_2_BizPlan.btnExchangeRate_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnExchangeRate_Click: 진입점 집계 12검사 — ERROR:10 · FAIL:1 · PASS:1 |  | 2 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-0119 | X-ROW | DMF0042_2_BizPlan.btnItemId_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnItemId_Click: 진입점 집계 9검사 — FAIL:4 · NA:3 · ERROR:1 · PASS:1 |  | 5 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-0120 | X-ROW | DMF0042_2_BizPlan.btnMeasure_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnMeasure_Click: 진입점 집계 16검사 — ERROR:6 · PASS:5 · FAIL:3 · NA:2 |  | 2 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-0121 | X-ROW | DMF0042_2_BizPlan.btnOwner_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnOwner_Click: 진입점 집계 9검사 — FAIL:4 · NA:3 · ERROR:1 · PASS:1 |  | 5 (ACT:DMF0042_2_BizPlan.btnOwner_Click:317) |
| WK-DMF0042-0122 | X-ROW | DMF0042_2_BizPlan.btnProject_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnProject_Click: 진입점 집계 9검사 — ERROR:4 · NA:3 · FAIL:2 |  | 5 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0123 | X-ROW | DMF0042_2_BizPlan.btnReplace_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnReplace_Click: 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · FAIL:1 |  | 6 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-0124 | X-ROW | DMF0042_2_BizPlan.btnSetPrice_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.btnSetPrice_Click: 진입점 집계 9검사 — PASS:4 · ERROR:3 · FAIL:1 · NA:1 |  | 2 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0125 | X-ROW | DMF0042_2_BizPlan.spdMain_CellDoubleClic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.spdMain_CellDoubleClick: 진입점 집계 93검사 — ERROR:53 · NA:27 · FAIL:7 · PASS:5 · NOT_RUN:1 |  | 31 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0126 | X-ROW | DMF0042_2_BizPlan.spdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.spdMain_TopChange: 진입점 집계 1검사 — FAIL:1 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-0127 | X-ROW | DMF0042_3_BizPlan..ctor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan..ctor: 진입점 집계 2검사 — NA:1 · FAIL:1 |  | 3 (ACT:DMF0042_3_BizPlan..ctor:226:1 ACT:DM) |
| WK-DMF0042-0128 | X-ROW | DMF0042_3_BizPlan.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.CreateSpread: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_3_BizPlan.CreateSpread ACT:D) |
| WK-DMF0042-0129 | X-ROW | DMF0042_3_BizPlan.DefineProperty | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.DefineProperty: 진입점 집계 9검사 — PASS:4 · NOT_RUN:2 · NA:2 · FAIL:1 |  | 13 (ACT:DMF0042_3_BizPlan.DefineProperty:352) |
| WK-DMF0042-0130 | X-ROW | DMF0042_3_BizPlan.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.DeleteButton: 진입점 집계 4검사 — FAIL:3 · ERROR:1 |  | 6 (ACT:DMF0042_3_BizPlan.DeleteButton:553:1) |
| WK-DMF0042-0131 | X-ROW | DMF0042_3_BizPlan.Dispose | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.Dispose: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 3 (ACT:DMF0042_3_BizPlan.Dispose:16:1 ACT:D) |
| WK-DMF0042-0132 | X-ROW | DMF0042_3_BizPlan.EditButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.EditButton: 진입점 집계 29검사 — ERROR:20 · PASS:6 · NA:2 · FAIL:1 |  | 48 (ACT:DMF0042_3_BizPlan.EditButton:567:1 A) |
| WK-DMF0042-0133 | X-ROW | DMF0042_3_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 4검사 — FAIL:2 · REVIEW:1 · ERROR:1 |  | 2 (ACT:DMF0042_3_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0134 | X-ROW | DMF0042_3_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.FindData: 진입점 집계 29검사 — ERROR:18 · PASS:5 · NA:2 · FAIL:2 · NOT_RUN:1 · REVIEW:1 |  | 64 (ACT:DMF0042_3_BizPlan.FindData:712:1 ACT) |
| WK-DMF0042-0135 | X-ROW | DMF0042_3_BizPlan.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.Form_Load: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 7 (ACT:DMF0042_3_BizPlan.Form_Load ACT:DMF0) |
| WK-DMF0042-0136 | X-ROW | DMF0042_3_BizPlan.GetBizTypebyDivision | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetBizTypebyDivision: 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 |  | 7 (ACT:DMF0042_3_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0137 | X-ROW | DMF0042_3_BizPlan.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_3_BizPlan.GetCellColor ACT:D) |
| WK-DMF0042-0138 | X-ROW | DMF0042_3_BizPlan.GetCellIndexBySpanRowC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetCellIndexBySpanRowCells: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_3_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0139 | X-ROW | DMF0042_3_BizPlan.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetCellNumbersByRow: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_3_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0140 | X-ROW | DMF0042_3_BizPlan.GetCellProdSite | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetCellProdSite: 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 |  | 12 (ACT:DMF0042_3_BizPlan.GetCellProdSite AC) |
| WK-DMF0042-0141 | X-ROW | DMF0042_3_BizPlan.GetComboData | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetComboData: 진입점 집계 4검사 — FAIL:1 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 10 (ACT:DMF0042_3_BizPlan.GetComboData ACT:D) |
| WK-DMF0042-0142 | X-ROW | DMF0042_3_BizPlan.GetDayRange | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetDayRange: 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 |  | 8 (ACT:DMF0042_3_BizPlan.GetDayRange ACT:DM) |
| WK-DMF0042-0143 | X-ROW | DMF0042_3_BizPlan.GetFuturePriceInfo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetFuturePriceInfo: 진입점 집계 6검사 — NA:2 · PASS:2 · FAIL:1 · ERROR:1 |  | 9 (ACT:DMF0042_3_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-0144 | X-ROW | DMF0042_3_BizPlan.GetLookupData | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetLookupData: 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 |  | 7 (ACT:DMF0042_3_BizPlan.GetLookupData ACT:) |
| WK-DMF0042-0145 | X-ROW | DMF0042_3_BizPlan.GetSpdTitle | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetSpdTitle: 진입점 집계 8검사 — ERROR:4 · NA:2 · PASS:1 · FAIL:1 |  | 8 (ACT:DMF0042_3_BizPlan.GetSpdTitle:3000:1) |
| WK-DMF0042-0146 | X-ROW | DMF0042_3_BizPlan.GetThisWeekMonday | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.GetThisWeekMonday: 진입점 집계 3검사 — NA:2 · FAIL:1 |  | 10 (ACT:DMF0042_3_BizPlan.GetThisWeekMonday ) |
| WK-DMF0042-0147 | X-ROW | DMF0042_3_BizPlan.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.InitControls: 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 |  | 48 (ACT:DMF0042_3_BizPlan.InitControls:259:1) |
| WK-DMF0042-0148 | X-ROW | DMF0042_3_BizPlan.InitSaveDataTable | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.InitSaveDataTable: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 6 (ACT:DMF0042_3_BizPlan.InitSaveDataTable ) |
| WK-DMF0042-0149 | X-ROW | DMF0042_3_BizPlan.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.InitSpread: 진입점 집계 5검사 — PASS:3 · NOT_RUN:1 · FAIL:1 |  | 7 (ACT:DMF0042_3_BizPlan.InitSpread ACT:DMF) |
| WK-DMF0042-0150 | X-ROW | DMF0042_3_BizPlan.InsertButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.InsertButton: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 2 (ACT:DMF0042_3_BizPlan.InsertButton ACT:D) |
| WK-DMF0042-0151 | X-ROW | DMF0042_3_BizPlan.InsertRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.InsertRow: 진입점 집계 214검사 — ERROR:127 · NA:58 · PASS:23 · NOPATH:3 · FAIL:3 |  | 178 (ACT:DMF0042_3_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-0152 | X-ROW | DMF0042_3_BizPlan.MinColumnChk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.MinColumnChk: 진입점 집계 1검사 — FAIL:1 |  | 10 (ACT:DMF0042_3_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-0153 | X-ROW | DMF0042_3_BizPlan.OnShown | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.OnShown: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_3_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-0154 | X-ROW | DMF0042_3_BizPlan.ParameterString | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.ParameterString: 진입점 집계 1검사 — FAIL:1 |  | 17 (ACT:DMF0042_3_BizPlan.ParameterString AC) |
| WK-DMF0042-0155 | X-ROW | DMF0042_3_BizPlan.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SaveButton: 진입점 집계 5검사 — FAIL:2 · ERROR:2 · NA:1 |  | 1 (ACT:DMF0042_3_BizPlan.SaveButton:703:1) |
| WK-DMF0042-0156 | X-ROW | DMF0042_3_BizPlan.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SaveData: 진입점 집계 21검사 — ERROR:10 · FAIL:6 · PASS:3 · NA:2 |  | 187 (ACT:DMF0042_3_BizPlan.SaveData:829:1 ACT) |
| WK-DMF0042-0157 | X-ROW | DMF0042_3_BizPlan.SetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_3_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-0158 | X-ROW | DMF0042_3_BizPlan.SetComboCol | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SetComboCol: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_3_BizPlan.SetComboCol ACT:DM) |
| WK-DMF0042-0159 | X-ROW | DMF0042_3_BizPlan.SetComboColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SetComboColumn: 진입점 집계 5검사 — NA:2 · ERROR:2 · FAIL:1 |  | 6 (ACT:DMF0042_3_BizPlan.SetComboColumn:293) |
| WK-DMF0042-0160 | X-ROW | DMF0042_3_BizPlan.SetSpreadColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SetSpreadColumn: 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 |  | 19 (ACT:DMF0042_3_BizPlan.SetSpreadColumn:49) |
| WK-DMF0042-0161 | X-ROW | DMF0042_3_BizPlan.SetSpreadHeaderSpan | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.SetSpreadHeaderSpan: 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 |  | 53 (ACT:DMF0042_3_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0162 | X-ROW | DMF0042_3_BizPlan.ValidationCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.ValidationCheck: 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 |  | 7 (ACT:DMF0042_3_BizPlan.ValidationCheck AC) |
| WK-DMF0042-0163 | X-ROW | DMF0042_3_BizPlan.btnColumn_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnColumn_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-0164 | X-ROW | DMF0042_3_BizPlan.btnCutOff_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnCutOff_Click: 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 |  | 11 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-0165 | X-ROW | DMF0042_3_BizPlan.btnExchangeRate_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnExchangeRate_Click: 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 |  | 9 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-0166 | X-ROW | DMF0042_3_BizPlan.btnItemId_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnItemId_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 13 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-0167 | X-ROW | DMF0042_3_BizPlan.btnMeasure_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnMeasure_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-0168 | X-ROW | DMF0042_3_BizPlan.btnOwner_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnOwner_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 12 (ACT:DMF0042_3_BizPlan.btnOwner_Click:305) |
| WK-DMF0042-0169 | X-ROW | DMF0042_3_BizPlan.btnProject_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnProject_Click: 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 |  | 13 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0170 | X-ROW | DMF0042_3_BizPlan.btnReplace_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnReplace_Click: 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 |  | 44 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-0171 | X-ROW | DMF0042_3_BizPlan.btnSetPrice_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.btnSetPrice_Click: 진입점 집계 11검사 — PASS:5 · ERROR:3 · FAIL:2 · NA:1 |  | 11 (ACT:DMF0042_3_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0172 | X-ROW | DMF0042_3_BizPlan.cboBucketType_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.cboBucketType_Click: 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 |  | 4 (ACT:DMF0042_3_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-0173 | X-ROW | DMF0042_3_BizPlan.cboBucketType_Selected | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.cboBucketType_SelectedIndexChanged: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_3_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0174 | X-ROW | DMF0042_3_BizPlan.cboDivision_SelectedIn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.cboDivision_SelectedIndexChanged: 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 |  | 47 (ACT:DMF0042_3_BizPlan.cboDivision_Select) |
| WK-DMF0042-0175 | X-ROW | DMF0042_3_BizPlan.chkSum_CheckedChanged | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.chkSum_CheckedChanged: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_3_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0176 | X-ROW | DMF0042_3_BizPlan.clbCustomer_SelectedIn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 8검사 — ERROR:6 · PASS:1 · FAIL:1 |  | 5 (ACT:DMF0042_3_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0177 | X-ROW | DMF0042_3_BizPlan.clbTeam_SelectedIndexC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.clbTeam_SelectedIndexChanged: 진입점 집계 7검사 — ERROR:5 · FAIL:1 · PASS:1 |  | 13 (ACT:DMF0042_3_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0178 | X-ROW | DMF0042_3_BizPlan.fnValidation | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.fnValidation: 진입점 집계 1검사 — FAIL:1 |  | 48 (ACT:DMF0042_3_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-0179 | X-ROW | DMF0042_3_BizPlan.spdMain_CellDoubleClic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.spdMain_CellDoubleClick: 진입점 집계 78검사 — ERROR:37 · NA:24 · FAIL:8 · PASS:5 · NOT_RUN:2 · NOPATH:2 |  | 120 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0180 | X-ROW | DMF0042_3_BizPlan.spdMain_Changed | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.spdMain_Changed: 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 |  | 425 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0181 | X-ROW | DMF0042_3_BizPlan.spdMain_ComboSelChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.spdMain_ComboSelChange: 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 |  | 16 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0182 | X-ROW | DMF0042_3_BizPlan.spdMain_EditChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.spdMain_EditChange: 진입점 집계 1검사 — FAIL:1 |  | 4 (ACT:DMF0042_3_BizPlan.spdMain_EditChange) |
| WK-DMF0042-0183 | X-ROW | DMF0042_3_BizPlan.spdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.spdMain_TopChange: 진입점 집계 2검사 — FAIL:2 |  | 4 (ACT:DMF0042_3_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-0184 | X-ROW | DMF0042_BizPlan..ctor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan..ctor: 진입점 집계 2검사 — NA:1 · FAIL:1 |  | 3 (ACT:DMF0042_BizPlan..ctor:215:1 ACT:DMF0) |
| WK-DMF0042-0185 | X-ROW | DMF0042_BizPlan.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.CreateSpread: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_BizPlan.CreateSpread ACT:DMF) |
| WK-DMF0042-0186 | X-ROW | DMF0042_BizPlan.DefineProperty | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.DefineProperty: 진입점 집계 9검사 — PASS:4 · NA:2 · NOT_RUN:2 · FAIL:1 |  | 13 (ACT:DMF0042_BizPlan.DefineProperty:341:1) |
| WK-DMF0042-0187 | X-ROW | DMF0042_BizPlan.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.DeleteButton: 진입점 집계 4검사 — FAIL:3 · ERROR:1 |  | 6 (ACT:DMF0042_BizPlan.DeleteButton:551:1 A) |
| WK-DMF0042-0188 | X-ROW | DMF0042_BizPlan.Dispose | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.Dispose: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 3 (ACT:DMF0042_BizPlan.Dispose:16:1 ACT:DMF) |
| WK-DMF0042-0189 | X-ROW | DMF0042_BizPlan.EditButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.EditButton: 진입점 집계 18검사 — ERROR:14 · NA:2 · FAIL:1 · PASS:1 |  | 38 (ACT:DMF0042_BizPlan.EditButton:565:1 ACT) |
| WK-DMF0042-0190 | X-ROW | DMF0042_BizPlan.ExcelButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.ExcelButton: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_BizPlan.ExcelButton ACT:DMF0) |
| WK-DMF0042-0191 | X-ROW | DMF0042_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.FindButton: 진입점 집계 7검사 — PASS:3 · REVIEW:2 · FAIL:2 |  | 2 (ACT:DMF0042_BizPlan.FindButton ACT:DMF00) |
| WK-DMF0042-0192 | X-ROW | DMF0042_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.FindData: 진입점 집계 33검사 — ERROR:16 · PASS:10 · REVIEW:2 · FAIL:2 · NA:2 · NOT_RUN:1 |  | 64 (ACT:DMF0042_BizPlan.FindData:747:1 ACT:D) |
| WK-DMF0042-0193 | X-ROW | DMF0042_BizPlan.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.Form_Load: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 7 (ACT:DMF0042_BizPlan.Form_Load ACT:DMF004) |
| WK-DMF0042-0194 | X-ROW | DMF0042_BizPlan.GetBizTypebyDivision | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetBizTypebyDivision: 진입점 집계 4검사 — NA:1 · NOPATH:1 · PASS:1 · FAIL:1 |  | 7 (ACT:DMF0042_BizPlan.GetBizTypebyDivision) |
| WK-DMF0042-0195 | X-ROW | DMF0042_BizPlan.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_BizPlan.GetCellColor ACT:DMF) |
| WK-DMF0042-0196 | X-ROW | DMF0042_BizPlan.GetCellIndexBySpanRowCel | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetCellIndexBySpanRowCells: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_BizPlan.GetCellIndexBySpanRo) |
| WK-DMF0042-0197 | X-ROW | DMF0042_BizPlan.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetCellNumbersByRow: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_BizPlan.GetCellNumbersByRow ) |
| WK-DMF0042-0198 | X-ROW | DMF0042_BizPlan.GetCellProdSite | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetCellProdSite: 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 |  | 12 (ACT:DMF0042_BizPlan.GetCellProdSite ACT:) |
| WK-DMF0042-0199 | X-ROW | DMF0042_BizPlan.GetDayRange | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetDayRange: 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 |  | 8 (ACT:DMF0042_BizPlan.GetDayRange ACT:DMF0) |
| WK-DMF0042-0200 | X-ROW | DMF0042_BizPlan.GetFuturePriceInfo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetFuturePriceInfo: 진입점 집계 6검사 — PASS:2 · NA:2 · ERROR:1 · FAIL:1 |  | 9 (ACT:DMF0042_BizPlan.GetFuturePriceInfo:3) |
| WK-DMF0042-0201 | X-ROW | DMF0042_BizPlan.GetLookupData | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetLookupData: 진입점 집계 4검사 — FAIL:1 · PASS:1 · NA:1 · NOPATH:1 |  | 7 (ACT:DMF0042_BizPlan.GetLookupData ACT:DM) |
| WK-DMF0042-0202 | X-ROW | DMF0042_BizPlan.GetSpdTitle | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetSpdTitle: 진입점 집계 8검사 — PASS:3 · NA:2 · ERROR:2 · FAIL:1 |  | 8 (ACT:DMF0042_BizPlan.GetSpdTitle:2949:1 A) |
| WK-DMF0042-0203 | X-ROW | DMF0042_BizPlan.GetThisWeekMonday | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.GetThisWeekMonday: 진입점 집계 3검사 — NA:2 · FAIL:1 |  | 10 (ACT:DMF0042_BizPlan.GetThisWeekMonday AC) |
| WK-DMF0042-0204 | X-ROW | DMF0042_BizPlan.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.InitControls: 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 |  | 48 (ACT:DMF0042_BizPlan.InitControls:248:1 A) |
| WK-DMF0042-0205 | X-ROW | DMF0042_BizPlan.InitSaveDataTable | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.InitSaveDataTable: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 6 (ACT:DMF0042_BizPlan.InitSaveDataTable AC) |
| WK-DMF0042-0206 | X-ROW | DMF0042_BizPlan.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.InitSpread: 진입점 집계 9검사 — PASS:6 · FAIL:2 · NOT_RUN:1 |  | 9 (ACT:DMF0042_BizPlan.InitSpread:387:1 ACT) |
| WK-DMF0042-0207 | X-ROW | DMF0042_BizPlan.InsertButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.InsertButton: 진입점 집계 2검사 — PASS:1 · FAIL:1 |  | 2 (ACT:DMF0042_BizPlan.InsertButton ACT:DMF) |
| WK-DMF0042-0208 | X-ROW | DMF0042_BizPlan.InsertRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.InsertRow: 진입점 집계 198검사 — ERROR:118 · NA:52 · PASS:19 · NOPATH:6 · FAIL:3 |  | 165 (ACT:DMF0042_BizPlan.InsertRow ACT:DMF004) |
| WK-DMF0042-0209 | X-ROW | DMF0042_BizPlan.MinColumnChk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.MinColumnChk: 진입점 집계 1검사 — FAIL:1 |  | 10 (ACT:DMF0042_BizPlan.MinColumnChk ACT:DMF) |
| WK-DMF0042-0210 | X-ROW | DMF0042_BizPlan.OnShown | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.OnShown: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_BizPlan.OnShown ACT:DMF0042_) |
| WK-DMF0042-0211 | X-ROW | DMF0042_BizPlan.ParameterString | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.ParameterString: 진입점 집계 1검사 — FAIL:1 |  | 17 (ACT:DMF0042_BizPlan.ParameterString ACT:) |
| WK-DMF0042-0212 | X-ROW | DMF0042_BizPlan.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SaveButton: 진입점 집계 7검사 — FAIL:2 · ERROR:2 · PASS:2 · NA:1 |  | 1 (ACT:DMF0042_BizPlan.SaveButton:701:1) |
| WK-DMF0042-0213 | X-ROW | DMF0042_BizPlan.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SaveData: 진입점 집계 25검사 — ERROR:10 · PASS:7 · FAIL:6 · NA:2 |  | 180 (ACT:DMF0042_BizPlan.SaveData:864:1 ACT:D) |
| WK-DMF0042-0214 | X-ROW | DMF0042_BizPlan.SetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SetCellColor: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:DMF0042_BizPlan.SetCellColor ACT:DMF) |
| WK-DMF0042-0215 | X-ROW | DMF0042_BizPlan.SetComboCol | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SetComboCol: 진입점 집계 1검사 — FAIL:1 |  | 15 (ACT:DMF0042_BizPlan.SetComboCol ACT:DMF0) |
| WK-DMF0042-0216 | X-ROW | DMF0042_BizPlan.SetSpreadColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SetSpreadColumn: 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 |  | 19 (ACT:DMF0042_BizPlan.SetSpreadColumn:492:) |
| WK-DMF0042-0217 | X-ROW | DMF0042_BizPlan.SetSpreadHeaderSpan | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.SetSpreadHeaderSpan: 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 |  | 53 (ACT:DMF0042_BizPlan.SetSpreadHeaderSpan:) |
| WK-DMF0042-0218 | X-ROW | DMF0042_BizPlan.ValidationCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.ValidationCheck: 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 |  | 7 (ACT:DMF0042_BizPlan.ValidationCheck ACT:) |
| WK-DMF0042-0219 | X-ROW | DMF0042_BizPlan.btnColumn_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnColumn_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_BizPlan.btnColumn_Click:2872) |
| WK-DMF0042-0220 | X-ROW | DMF0042_BizPlan.btnCutOff_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnCutOff_Click: 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 |  | 11 (ACT:DMF0042_BizPlan.btnCutOff_Click:2905) |
| WK-DMF0042-0221 | X-ROW | DMF0042_BizPlan.btnExchangeRate_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnExchangeRate_Click: 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 |  | 9 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-0222 | X-ROW | DMF0042_BizPlan.btnItemId_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnItemId_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 13 (ACT:DMF0042_BizPlan.btnItemId_Click:2849) |
| WK-DMF0042-0223 | X-ROW | DMF0042_BizPlan.btnMeasure_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnMeasure_Click: 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-0224 | X-ROW | DMF0042_BizPlan.btnOwner_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnOwner_Click: 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 |  | 12 (ACT:DMF0042_BizPlan.btnOwner_Click:3008:) |
| WK-DMF0042-0225 | X-ROW | DMF0042_BizPlan.btnProject_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnProject_Click: 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 |  | 13 (ACT:DMF0042_BizPlan.btnProject_Click:282) |
| WK-DMF0042-0226 | X-ROW | DMF0042_BizPlan.btnReplace_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnReplace_Click: 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 |  | 44 (ACT:DMF0042_BizPlan.btnReplace_Click:347) |
| WK-DMF0042-0227 | X-ROW | DMF0042_BizPlan.btnSetPrice_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.btnSetPrice_Click: 진입점 집계 15검사 — PASS:9 · ERROR:3 · FAIL:2 · NA:1 |  | 11 (ACT:DMF0042_BizPlan.btnSetPrice_Click:31) |
| WK-DMF0042-0228 | X-ROW | DMF0042_BizPlan.cboBucketType_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.cboBucketType_Click: 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 |  | 4 (ACT:DMF0042_BizPlan.cboBucketType_Click:) |
| WK-DMF0042-0229 | X-ROW | DMF0042_BizPlan.cboBucketType_SelectedIn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.cboBucketType_SelectedIndexChanged: 진입점 집계 1검사 — FAIL:1 |  | 6 (ACT:DMF0042_BizPlan.cboBucketType_Select) |
| WK-DMF0042-0230 | X-ROW | DMF0042_BizPlan.cboDivision_SelectedInde | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.cboDivision_SelectedIndexChanged: 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 |  | 47 (ACT:DMF0042_BizPlan.cboDivision_Selected) |
| WK-DMF0042-0231 | X-ROW | DMF0042_BizPlan.chkSum_CheckedChanged | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.chkSum_CheckedChanged: 진입점 집계 1검사 — FAIL:1 |  | 3 (ACT:DMF0042_BizPlan.chkSum_CheckedChange) |
| WK-DMF0042-0232 | X-ROW | DMF0042_BizPlan.clbCustomer_SelectedInde | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.clbCustomer_SelectedIndexChanged: 진입점 집계 8검사 — ERROR:6 · PASS:1 · FAIL:1 |  | 5 (ACT:DMF0042_BizPlan.clbCustomer_Selected) |
| WK-DMF0042-0233 | X-ROW | DMF0042_BizPlan.clbTeam_SelectedIndexCha | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.clbTeam_SelectedIndexChanged: 진입점 집계 7검사 — ERROR:5 · FAIL:1 · PASS:1 |  | 13 (ACT:DMF0042_BizPlan.clbTeam_SelectedInde) |
| WK-DMF0042-0234 | X-ROW | DMF0042_BizPlan.fnValidation | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.fnValidation: 진입점 집계 1검사 — FAIL:1 |  | 48 (ACT:DMF0042_BizPlan.fnValidation ACT:DMF) |
| WK-DMF0042-0235 | X-ROW | DMF0042_BizPlan.spdMain_CellDoubleClick | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.spdMain_CellDoubleClick: 진입점 집계 78검사 — ERROR:37 · NA:24 · FAIL:8 · PASS:5 · NOPATH:2 · NOT_RUN:2 |  | 120 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0236 | X-ROW | DMF0042_BizPlan.spdMain_Changed | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.spdMain_Changed: 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 |  | 425 (ACT:DMF0042_BizPlan.spdMain_Changed:1865) |
| WK-DMF0042-0237 | X-ROW | DMF0042_BizPlan.spdMain_ComboSelChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.spdMain_ComboSelChange: 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 |  | 16 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0238 | X-ROW | DMF0042_BizPlan.spdMain_EditChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.spdMain_EditChange: 진입점 집계 1검사 — FAIL:1 |  | 4 (ACT:DMF0042_BizPlan.spdMain_EditChange A) |
| WK-DMF0042-0239 | X-ROW | DMF0042_BizPlan.spdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.spdMain_TopChange: 진입점 집계 2검사 — FAIL:2 |  | 4 (ACT:DMF0042_BizPlan.spdMain_TopChange AC) |
| WK-DMF0042-0240 | X-ROW | DMF0042_BizPlan_old..ctor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old..ctor: 진입점 집계 3검사 — FAIL:2 · NA:1 |  | 2 (ACT:DMF0042_BizPlan_old..ctor:187:1 ACT:) |
| WK-DMF0042-0241 | X-ROW | DMF0042_BizPlan_old.CreateSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.CreateSpread: 진입점 집계 2검사 — FAIL:2 |  | 5 (ACT:DMF0042_BizPlan_old.CreateSpread ACT) |
| WK-DMF0042-0242 | X-ROW | DMF0042_BizPlan_old.DefineProperty | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.DefineProperty: 진입점 집계 10검사 — PASS:4 · NA:2 · NOT_RUN:2 · FAIL:2 |  | 17 (ACT:DMF0042_BizPlan_old.DefineProperty:2) |
| WK-DMF0042-0243 | X-ROW | DMF0042_BizPlan_old.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.DeleteButton: 진입점 집계 5검사 — FAIL:4 · ERROR:1 |  | 6 (ACT:DMF0042_BizPlan_old.DeleteButton:498) |
| WK-DMF0042-0244 | X-ROW | DMF0042_BizPlan_old.Dispose | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.Dispose: 진입점 집계 3검사 — FAIL:2 · PASS:1 |  | 3 (ACT:DMF0042_BizPlan_old.Dispose:16:1 ACT) |
| WK-DMF0042-0245 | X-ROW | DMF0042_BizPlan_old.EditButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.EditButton: 진입점 집계 16검사 — ERROR:10 · NA:2 · PASS:2 · FAIL:2 |  | 27 (ACT:DMF0042_BizPlan_old.EditButton:512:1) |
| WK-DMF0042-0246 | X-ROW | DMF0042_BizPlan_old.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.FindButton: 진입점 집계 8검사 — FAIL:3 · PASS:3 · REVIEW:2 |  | 2 (ACT:DMF0042_BizPlan_old.FindButton ACT:D) |
| WK-DMF0042-0247 | X-ROW | DMF0042_BizPlan_old.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.FindData: 진입점 집계 33검사 — ERROR:15 · PASS:10 · FAIL:3 · REVIEW:2 · NA:2 · NOT_RUN:1 |  | 55 (ACT:DMF0042_BizPlan_old.FindData:584:1 A) |
| WK-DMF0042-0248 | X-ROW | DMF0042_BizPlan_old.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.Form_Load: 진입점 집계 3검사 — FAIL:2 · PASS:1 |  | 7 (ACT:DMF0042_BizPlan_old.Form_Load ACT:DM) |
| WK-DMF0042-0249 | X-ROW | DMF0042_BizPlan_old.GetBizTypebyDivision | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetBizTypebyDivision: 진입점 집계 5검사 — FAIL:2 · NA:1 · NOPATH:1 · PASS:1 |  | 7 (ACT:DMF0042_BizPlan_old.GetBizTypebyDivi) |
| WK-DMF0042-0250 | X-ROW | DMF0042_BizPlan_old.GetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetCellColor: 진입점 집계 2검사 — FAIL:2 |  | 6 (ACT:DMF0042_BizPlan_old.GetCellColor ACT) |
| WK-DMF0042-0251 | X-ROW | DMF0042_BizPlan_old.GetCellIndexBySpanRo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetCellIndexBySpanRowCells: 진입점 집계 2검사 — FAIL:2 |  | 5 (ACT:DMF0042_BizPlan_old.GetCellIndexBySp) |
| WK-DMF0042-0252 | X-ROW | DMF0042_BizPlan_old.GetCellNumbersByRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetCellNumbersByRow: 진입점 집계 2검사 — FAIL:2 |  | 15 (ACT:DMF0042_BizPlan_old.GetCellNumbersBy) |
| WK-DMF0042-0253 | X-ROW | DMF0042_BizPlan_old.GetDayRange | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetDayRange: 진입점 집계 5검사 — FAIL:2 · ERROR:2 · PASS:1 |  | 8 (ACT:DMF0042_BizPlan_old.GetDayRange ACT:) |
| WK-DMF0042-0254 | X-ROW | DMF0042_BizPlan_old.GetFuturePriceInfo | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetFuturePriceInfo: 진입점 집계 7검사 — NA:2 · PASS:2 · FAIL:2 · ERROR:1 |  | 9 (ACT:DMF0042_BizPlan_old.GetFuturePriceIn) |
| WK-DMF0042-0255 | X-ROW | DMF0042_BizPlan_old.GetLookupData | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetLookupData: 진입점 집계 5검사 — FAIL:2 · PASS:1 · NA:1 · NOPATH:1 |  | 7 (ACT:DMF0042_BizPlan_old.GetLookupData AC) |
| WK-DMF0042-0256 | X-ROW | DMF0042_BizPlan_old.GetSpdTitle | DB(🛠️/🧯 적용 가능) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetSpdTitle: 진입점 집계 9검사 — PASS:3 · NA:2 · ERROR:2 · FAIL:2 |  | 8 (ACT:DMF0042_BizPlan_old.GetSpdTitle:2154) |
| WK-DMF0042-0257 | X-ROW | DMF0042_BizPlan_old.GetThisWeekMonday | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.GetThisWeekMonday: 진입점 집계 4검사 — FAIL:2 · NA:2 |  | 10 (ACT:DMF0042_BizPlan_old.GetThisWeekMonda) |
| WK-DMF0042-0258 | X-ROW | DMF0042_BizPlan_old.InitControls | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.InitControls: 진입점 집계 37검사 — PASS:19 · NOT_RUN:9 · FAIL:5 · ERROR:4 |  | 42 (ACT:DMF0042_BizPlan_old.InitControls:217) |
| WK-DMF0042-0259 | X-ROW | DMF0042_BizPlan_old.InitSaveDataTable | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.InitSaveDataTable: 진입점 집계 3검사 — FAIL:2 · PASS:1 |  | 6 (ACT:DMF0042_BizPlan_old.InitSaveDataTabl) |
| WK-DMF0042-0260 | X-ROW | DMF0042_BizPlan_old.InitSpread | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.InitSpread: 진입점 집계 3검사 — FAIL:2 · PASS:1 |  | 6 (ACT:DMF0042_BizPlan_old.InitSpread ACT:D) |
| WK-DMF0042-0261 | X-ROW | DMF0042_BizPlan_old.InsertButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.InsertButton: 진입점 집계 3검사 — FAIL:2 · PASS:1 |  | 2 (ACT:DMF0042_BizPlan_old.InsertButton ACT) |
| WK-DMF0042-0262 | X-ROW | DMF0042_BizPlan_old.InsertRow | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.InsertRow: 진입점 집계 177검사 — ERROR:107 · NA:49 · PASS:13 · NOPATH:6 · FAIL:2 |  | 136 (ACT:DMF0042_BizPlan_old.InsertRow ACT:DM) |
| WK-DMF0042-0263 | X-ROW | DMF0042_BizPlan_old.MinColumnChk | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.MinColumnChk: 진입점 집계 2검사 — FAIL:2 |  | 10 (ACT:DMF0042_BizPlan_old.MinColumnChk ACT) |
| WK-DMF0042-0264 | X-ROW | DMF0042_BizPlan_old.OnShown | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.OnShown: 진입점 집계 2검사 — FAIL:2 |  | 3 (ACT:DMF0042_BizPlan_old.OnShown ACT:DMF0) |
| WK-DMF0042-0265 | X-ROW | DMF0042_BizPlan_old.ParameterString | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.ParameterString: 진입점 집계 2검사 — FAIL:2 |  | 17 (ACT:DMF0042_BizPlan_old.ParameterString ) |
| WK-DMF0042-0266 | X-ROW | DMF0042_BizPlan_old.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.SaveButton: 진입점 집계 8검사 — FAIL:3 · ERROR:2 · PASS:2 · NA:1 |  | 1 (ACT:DMF0042_BizPlan_old.SaveButton:575:1) |
| WK-DMF0042-0267 | X-ROW | DMF0042_BizPlan_old.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.SaveData: 진입점 집계 22검사 — ERROR:10 · PASS:7 · FAIL:3 · NA:2 |  | 169 (ACT:DMF0042_BizPlan_old.SaveData:689:1 A) |
| WK-DMF0042-0268 | X-ROW | DMF0042_BizPlan_old.SetCellColor | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.SetCellColor: 진입점 집계 2검사 — FAIL:2 |  | 5 (ACT:DMF0042_BizPlan_old.SetCellColor ACT) |
| WK-DMF0042-0269 | X-ROW | DMF0042_BizPlan_old.SetSpreadColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.SetSpreadColumn: 진입점 집계 12검사 — ERROR:7 · NA:2 · FAIL:2 · PASS:1 |  | 19 (ACT:DMF0042_BizPlan_old.SetSpreadColumn:) |
| WK-DMF0042-0270 | X-ROW | DMF0042_BizPlan_old.SetSpreadHeaderSpan | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.SetSpreadHeaderSpan: 진입점 집계 32검사 — NA:16 · ERROR:14 · FAIL:2 |  | 53 (ACT:DMF0042_BizPlan_old.SetSpreadHeaderS) |
| WK-DMF0042-0271 | X-ROW | DMF0042_BizPlan_old.ValidationCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.ValidationCheck: 진입점 집계 5검사 — FAIL:3 · PASS:1 · ERROR:1 |  | 7 (ACT:DMF0042_BizPlan_old.ValidationCheck ) |
| WK-DMF0042-0272 | X-ROW | DMF0042_BizPlan_old.btnColumn_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnColumn_Click: 진입점 집계 19검사 — FAIL:6 · ERROR:6 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-0273 | X-ROW | DMF0042_BizPlan_old.btnCutOff_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnCutOff_Click: 진입점 집계 9검사 — FAIL:3 · ERROR:3 · NA:2 · PASS:1 |  | 10 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-0274 | X-ROW | DMF0042_BizPlan_old.btnExchangeRate_Clic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnExchangeRate_Click: 진입점 집계 10검사 — ERROR:6 · FAIL:3 · PASS:1 |  | 10 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-0275 | X-ROW | DMF0042_BizPlan_old.btnIncotermsChg_Clic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnIncotermsChg_Click: 진입점 집계 12검사 — FAIL:5 · ERROR:4 · NA:3 |  | 9 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-0276 | X-ROW | DMF0042_BizPlan_old.btnItemId_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnItemId_Click: 진입점 집계 12검사 — FAIL:6 · NA:3 · ERROR:2 · PASS:1 |  | 13 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-0277 | X-ROW | DMF0042_BizPlan_old.btnMeasure_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnMeasure_Click: 진입점 집계 19검사 — FAIL:6 · ERROR:6 · PASS:5 · NA:2 |  | 5 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-0278 | X-ROW | DMF0042_BizPlan_old.btnOwner_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnOwner_Click: 진입점 집계 12검사 — FAIL:6 · NA:3 · ERROR:2 · PASS:1 |  | 12 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-0279 | X-ROW | DMF0042_BizPlan_old.btnProject_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnProject_Click: 진입점 집계 12검사 — FAIL:5 · ERROR:4 · NA:3 |  | 13 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-0280 | X-ROW | DMF0042_BizPlan_old.btnSetPrice_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.btnSetPrice_Click: 진입점 집계 16검사 — PASS:9 · FAIL:3 · ERROR:3 · NA:1 |  | 11 (ACT:DMF0042_BizPlan_old.btnSetPrice_Clic) |
| WK-DMF0042-0281 | X-ROW | DMF0042_BizPlan_old.cboBucketType_Click | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.cboBucketType_Click: 진입점 집계 7검사 — FAIL:3 · ERROR:3 · PASS:1 |  | 4 (ACT:DMF0042_BizPlan_old.cboBucketType_Cl) |
| WK-DMF0042-0282 | X-ROW | DMF0042_BizPlan_old.cboBucketType_Select | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.cboBucketType_SelectedIndexChanged: 진입점 집계 2검사 — FAIL:2 |  | 6 (ACT:DMF0042_BizPlan_old.cboBucketType_Se) |
| WK-DMF0042-0283 | X-ROW | DMF0042_BizPlan_old.cboDivision_Selected | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.cboDivision_SelectedIndexChanged: 진입점 집계 12검사 — FAIL:5 · PASS:5 · ERROR:2 |  | 46 (ACT:DMF0042_BizPlan_old.cboDivision_Sele) |
| WK-DMF0042-0284 | X-ROW | DMF0042_BizPlan_old.chkSum_CheckedChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.chkSum_CheckedChanged: 진입점 집계 2검사 — FAIL:2 |  | 3 (ACT:DMF0042_BizPlan_old.chkSum_CheckedCh) |
| WK-DMF0042-0285 | X-ROW | DMF0042_BizPlan_old.clbCustomer_Selected | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.clbCustomer_SelectedIndexChanged: 진입점 집계 9검사 — ERROR:6 · FAIL:2 · PASS:1 |  | 5 (ACT:DMF0042_BizPlan_old.clbCustomer_Sele) |
| WK-DMF0042-0286 | X-ROW | DMF0042_BizPlan_old.clbTeam_SelectedInde | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.clbTeam_SelectedIndexChanged: 진입점 집계 8검사 — ERROR:5 · FAIL:2 · PASS:1 |  | 12 (ACT:DMF0042_BizPlan_old.clbTeam_Selected) |
| WK-DMF0042-0287 | X-ROW | DMF0042_BizPlan_old.fnValidation | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.fnValidation: 진입점 집계 2검사 — FAIL:2 |  | 52 (ACT:DMF0042_BizPlan_old.fnValidation ACT) |
| WK-DMF0042-0288 | X-ROW | DMF0042_BizPlan_old.spdMain_CellDoubleCl | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.spdMain_CellDoubleClick: 진입점 집계 82검사 — ERROR:38 · NA:24 · FAIL:10 · PASS:5 · NOT_RUN:3 · NOPAT |  | 118 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0289 | X-ROW | DMF0042_BizPlan_old.spdMain_Changed | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.spdMain_Changed: 진입점 집계 41검사 — ERROR:25 · NA:13 · FAIL:2 · PASS:1 |  | 236 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0290 | X-ROW | DMF0042_BizPlan_old.spdMain_ComboSelChan | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.spdMain_ComboSelChange: 진입점 집계 5검사 — ERROR:2 · FAIL:2 · NA:1 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_ComboSel) |
| WK-DMF0042-0291 | X-ROW | DMF0042_BizPlan_old.spdMain_EditChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.spdMain_EditChange: 진입점 집계 2검사 — FAIL:2 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_EditChan) |
| WK-DMF0042-0292 | X-ROW | DMF0042_BizPlan_old.spdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.spdMain_TopChange: 진입점 집계 3검사 — FAIL:3 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_TopChang) |
| WK-DMF0042-0293 | X-ROW | DMF0042_ExchangeRatePopup.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_ExchangeRatePopup.DeleteButton: 진입점 집계 3검사 — FAIL:2 · ERROR:1 |  | 4 (ACT:DMF0042_ExchangeRatePopup.DeleteButt) |
| WK-DMF0042-0294 | X-ROW | DMF0042_ExchangeRatePopup.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_ExchangeRatePopup.SaveButton: 진입점 집계 11검사 — ERROR:7 · FAIL:1 · PASS:1 · REVIEW:1 · NA:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-0295 | X-ROW | DMF0042_ExchangeRatePopup.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_ExchangeRatePopup.SaveData: 진입점 집계 21검사 — ERROR:9 · PASS:5 · FAIL:3 · NA:2 · REVIEW:1 · NOPATH:1 |  | 82 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-0296 | X-ROW | DMF0042_ExchangeRatePopup.btnButtonList_ | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_ExchangeRatePopup.btnButtonList_UsrButtonList_Click_: 진입점 집계 3검사 — ERROR:2 · FAIL:1 |  | 18 (ACT:DMF0042_ExchangeRatePopup.btnButtonL) |
| WK-DMF0042-0297 | X-ROW | DMF0042_ExchangeRatePopup.spdMain_TopCha | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_ExchangeRatePopup.spdMain_TopChange: 진입점 집계 2검사 — FAIL:1 · ERROR:1 |  | 4 (ACT:DMF0042_ExchangeRatePopup.spdMain_To) |
| WK-DMF0042-0298 | G5 | 21 | FE(repairScope=DB_ONLY — 이번 범위 밖) | G5 FAIL 수정 — 21: 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 G5 152요소: NA:116 · ERROR:31 · FAIL:2 · PASS:2 · NOPATH:1  |  | 1 (21) |
| WK-DMF0042-0299 | G5 | 6#6 | FE(repairScope=DB_ONLY — 이번 범위 밖) | G5 FAIL 수정 — 6#6: 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 G5 152요소: NA:116 · ERROR:31 · FAIL:2 · PAS |  | 1 (6#6) |
| WK-DMF0042-0300 | G5 | btnProject | FE(repairScope=DB_ONLY — 이번 범위 밖) | G5 FAIL 수정 — btnProject: 원장 V-519e804c ASIS / 원장 V-e17c91de ASIS / 원장 V-1848a229 ASIS / 원장 V-8d7a1c14 ASIS / 원장 V-14e5f59d ASIS /  |  | 2 (btnProject/btnItemId/btnOwner 3#9) |
| WK-DMF0042-0301 | G5 | txtProject / Project / PJT | FE(repairScope=DB_ONLY — 이번 범위 밖) | G5 FAIL 수정 — txtProject / Project / PJT: 원장 V-5fddf3df SEARCH / 원장 EG-a5542dfc 팝업 실측 SCM0002_ProjectbyDivisionPopupEx COND:Project |  | 1 (3#9) |
| WK-DMF0042-0302 | H6 | 21 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — 21: 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 H6 151요소: ERROR:73 · FAIL:54 · PASS:22 · NA:1 · NOPATH:1  |  | 1 (21) |
| WK-DMF0042-0303 | H6 | 6#6 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — 6#6: 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H6 151요소: ERROR:73 · FAIL:54 · PASS:22 · N |  | 1 (6#6) |
| WK-DMF0042-0304 | H6 | DMF0042_1_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — DMF0042_1_BizPlan: 원장 V-1417ed28 ASIS / 원장 V-699254bf ASIS / 원장 V-1dd724bf ASIS / 원장 V-7ef290e8 ASIS / 원장 V-c02d48d9  |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0305 | H6 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — DMF0042_2_BizPlan.spdMain_CellDoubleClick: 원장 V-6bbd9c1f ASIS / 원장 V-6cecd4cf ASIS / 원장 V-5448b137 ASIS / 원장 V-26c433 |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0306 | H6 | DMF0042_3_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — DMF0042_3_BizPlan: 원장 V-b0a534ca ASIS / 원장 V-dd4b851f ASIS / 원장 V-38555156 ASIS / 원장 V-41d355a1 ASIS / 원장 V-03ff3146  |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0307 | H6 | DMF0042_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — DMF0042_BizPlan: 원장 V-903e172f ASIS / 원장 V-6b20b2e7 ASIS / 원장 V-f2abcf20 ASIS / 원장 V-b56c42ad ASIS / 원장 V-f2c4be03 AS |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0308 | H6 | DMF0042_BizPlan_old | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — DMF0042_BizPlan_old: 원장 V-e8df2085 ASIS / 원장 V-926f8038 ASIS / 원장 V-be24c7f2 ASIS / 원장 V-32aec8b9 ASIS / 원장 V-cf027b3 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0309 | H6 | ITEM_ID / Model | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — ITEM_ID / Model: 원장 V-d9ba3d99 ASIS / 원장 V-1b89c571 ASIS / 원장 V-1841845a ASIS / 원장 V-6bbd9c1f ASIS / 원장 V-5448b137 AS |  | 271 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-0310 | H6 | btnItemId | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — btnItemId: 원장 V-8f152d01 ASIS / 원장 V-d9e8d469 ASIS / 원장 V-1210bb26 ASIS / 원장 V-0e2a72bd ASIS / 원장 V-70c4b471 ASIS / 원 |  | 22 (btnProject/btnItemId/btnOwner 3#10 ACT:D) |
| WK-DMF0042-0311 | H6 | btnOwner | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — btnOwner: 원장 V-d830ece8 ASIS / 원장 V-164c2875 ASIS / 원장 V-ad991fd0 ASIS / 원장 V-1d196413 ASIS / 원장 V-b38b55d4 ASIS / 원장 |  | 22 (btnProject/btnItemId/btnOwner 3#11 ACT:D) |
| WK-DMF0042-0312 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-8f152d01 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-0313 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-d9ba3d99 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0314 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-0e2a72bd |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-0315 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-5448b137 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0316 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-c7c1bd4d |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-0317 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-25aabeee |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0318 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-39cdf70a |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2856) |
| WK-DMF0042-0319 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-3da3fdc9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0320 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-f6b8b38e |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-0321 | H6 | new DM0002_ItembyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0002_ItembyDivisionPopupEx(): 원장 V-27143bcc |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0322 | H6 | new DM0020_OwnerbyDivisionPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0020_OwnerbyDivisionPopup(): 원장 V-d830ece8 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-0323 | H6 | new DM0020_OwnerbyDivisionPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0020_OwnerbyDivisionPopup(): 원장 V-1d196413 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:317) |
| WK-DMF0042-0324 | H6 | new DM0020_OwnerbyDivisionPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0020_OwnerbyDivisionPopup(): 원장 V-e3661a2a |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:306) |
| WK-DMF0042-0325 | H6 | new DM0020_OwnerbyDivisionPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0020_OwnerbyDivisionPopup(): 원장 V-8fd84844 |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3016:) |
| WK-DMF0042-0326 | H6 | new DM0020_OwnerbyDivisionPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — new DM0020_OwnerbyDivisionPopup(): 원장 V-95e84325 |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-0327 | H6 | popItem.Form_Load(false, sDivision, sTea | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sSc: 원장 V-1b89c571 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0328 | H6 | popItem.Form_Load(false, sDivision, sTea | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sSc: 원장 V-26c433fa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0329 | H6 | popItem.Form_Load(false, sDivision, sTea | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sSc: 원장 V-6d74450e |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0330 | H6 | popItem.Form_Load(false, sDivision, sTea | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sSc: 원장 V-10d1a11a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0331 | H6 | popItem.Form_Load(false, sDivision, sTea | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sSc: 원장 V-273c7005 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0332 | H6 | popItem.Form_Load(true, sDivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScm: 원장 V-164c2875 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-0333 | H6 | popItem.Form_Load(true, sDivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScm: 원장 V-b38b55d4 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:318) |
| WK-DMF0042-0334 | H6 | popItem.Form_Load(true, sDivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScm: 원장 V-e9fba552 |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:307) |
| WK-DMF0042-0335 | H6 | popItem.Form_Load(true, sDivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScm: 원장 V-07e182b0 |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3019:) |
| WK-DMF0042-0336 | H6 | popItem.Form_Load(true, sDivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScm: 원장 V-81cfdc94 |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-0337 | H6 | popItem.Form_Load(true, sdivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScm: 원장 V-d9e8d469 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-0338 | H6 | popItem.Form_Load(true, sdivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScm: 원장 V-70c4b471 |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-0339 | H6 | popItem.Form_Load(true, sdivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScm: 원장 V-8b285a32 |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-0340 | H6 | popItem.Form_Load(true, sdivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScm: 원장 V-bb1b832d |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2858) |
| WK-DMF0042-0341 | H6 | popItem.Form_Load(true, sdivision, sTeam | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScm: 원장 V-e239fb10 |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-0342 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-1210bb26 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-0343 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-ad991fd0 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-0344 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-1841845a |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0345 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-868f5891 |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-0346 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-12fa1b10 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:318) |
| WK-DMF0042-0347 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-7880f905 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0348 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-5179558f |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-0349 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-883a7df0 |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:307) |
| WK-DMF0042-0350 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-75dbe2b3 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0351 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-de1d5f8b |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2860) |
| WK-DMF0042-0352 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-5163b15e |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3021:) |
| WK-DMF0042-0353 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-9b10cb34 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0354 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-816e6798 |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-0355 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-78ed1abd |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-0356 | H6 | popItem.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popItem.ShowDialog(): 원장 V-3fa3b8d3 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0357 | H6 | txtItemId / Model / Item Id / Model/Nick | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — txtItemId / Model / Item Id / Model/Nickname / Model / Nickn: 원장 EG-480e08d7 팝업 실측 DM0002_ItembyDivisionPopupEx COND: |  | 1 (3#10) |
| WK-DMF0042-0358 | H6 | txtOwner / Owner | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — txtOwner / Owner: 원장 EG-6891cb81 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner BTN_ORDER / 원장 EG-a4515a49 팝업 실측 DM0020 |  | 1 (3#11) |
| WK-DMF0042-0359 | M3 | DMF0042_1_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — DMF0042_1_BizPlan: 원장 V-fa946da2 ASIS / 원장 V-61b1b3e0 ASIS / 원장 V-d0296cf9 ASIS / 원장 V-675768c9 ASIS / 원장 V-1c96c6d6  |  | 54 (ACT:DMF0042_1_BizPlan..ctor ACT:DMF0042_) |
| WK-DMF0042-0360 | M3 | DMF0042_3_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — DMF0042_3_BizPlan: 원장 V-31ccdc9f ASIS / 원장 V-d5b20abe ASIS / 원장 V-56c78e2b ASIS / 원장 V-1b4aec2a ASIS / 원장 V-8b49f48e  |  | 57 (ACT:DMF0042_3_BizPlan..ctor ACT:DMF0042_) |
| WK-DMF0042-0361 | M3 | DMF0042_BizPlan | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — DMF0042_BizPlan: 원장 V-084a9f65 ASIS / 원장 V-47ddfba8 ASIS / 원장 V-2534f49c ASIS / 원장 V-7189d831 ASIS / 원장 V-4c454807 AS |  | 109 (ACT:DMF0042_BizPlan..ctor ACT:DMF0042_Bi) |
| WK-DMF0042-0362 | M3 | DMF0042_BizPlan_old | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — DMF0042_BizPlan_old: 원장 V-9e2dfac9 ASIS / 원장 V-7e9fa75c ASIS / 원장 V-41d0eafc ASIS / 원장 V-7b310ef6 ASIS / 원장 V-39fc630 |  | 53 (ACT:DMF0042_BizPlan_old..ctor ACT:DMF004) |
| WK-DMF0042-0363 | M3 | btnColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — btnColumn: 원장 V-fa946da2 ASIS / 원장 V-cb73350f ASIS / 원장 V-31ccdc9f ASIS / 원장 V-084a9f65 ASIS / 원장 V-9e2dfac9 ASIS / 원 |  | 12 (ACT:DMF0042_1_BizPlan.InitControls:314:4) |
| WK-DMF0042-0364 | M3 | btnIncotermsChg | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — btnIncotermsChg: 원장 V-7e9fa75c ASIS / 실측[T-67555f4b]: [미검증] 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7 |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-0365 | M3 | btnMeasure | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — btnMeasure: 원장 V-675768c9 ASIS / 원장 V-a61baf50 ASIS / 원장 V-1b4aec2a ASIS / 원장 V-7189d831 ASIS / 원장 V-7b310ef6 ASIS /  |  | 12 (ACT:DMF0042_1_BizPlan.InitControls:315:4) |
| WK-DMF0042-0366 | M3 | btnProject | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — btnProject: 원장 V-f32309f8 ASIS / 원장 V-e2d3e239 ASIS / 원장 V-02175830 ASIS / 원장 V-0679fe5e ASIS / 원장 V-41d17e31 ASIS /  |  | 36 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0367 | M3 | new DM0002_MatsterChgPopup() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new DM0002_MatsterChgPopup(): 원장 V-7e9fa75c |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-0368 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-f32309f8 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0369 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-e2d3e239 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0370 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-02175830 |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-0371 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-0679fe5e |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-0372 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | FE(repairScope=DB_ONLY — 이번 범위 밖) | M3 FAIL 수정 — new SCM0002_ProjectbyDivisionPopupEx(): 원장 V-41d17e31 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |

## W5 검사기 연결 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0373 | B1 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0374 | B1 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0375 | B2 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0376 | B2 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0377 | B4 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0378 | B4 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0379 | DB-SYN | DMF0009_GET_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0009_GET_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0042_3_BizPlan.GetComboData:2951:) |
| WK-DMF0042-0380 | DB-SYN | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0042_ExchangeRatePopup.FindData:4) |
| WK-DMF0042-0381 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 10 (ACT:DMF0042_1_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0382 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 10 (ACT:DMF0042_1_BizPlan.GetLookupData:2907) |
| WK-DMF0042-0383 | G5 | BIZ_TYPE_NAME82 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 PCOL BIZ_TYPE_NAME82 | 판단불가(대상 단위 PCOL) | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0384 | H6 | BIZ_TYPE_NAME82 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 PCOL BIZ_TYPE_NAME82 | 판단불가(대상 단위 PCOL) | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |

## W6 검증 실행 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0385 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 16 (1#8 ACT:DMF0042_1_BizPlan.DefineProperty) |
| WK-DMF0042-0386 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (1#13) |
| WK-DMF0042-0387 | G4 | clbBizType / Biz Type / Biz. Type / Biz. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type / Biz. Type / Biz.Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 31 (1#4 ACT:DMF0042_1_BizPlan.InitControls A) |
| WK-DMF0042-0388 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 16 (1#3 ACT:DMF0042_1_BizPlan.InitControls A) |
| WK-DMF0042-0389 | G4 | clbDivision / Division / Div. / Div | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division / Div. / Div · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 45 (1#1 ACT:DMF0042_1_BizPlan.DefineProperty) |
| WK-DMF0042-0390 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (1#7 ACT:DMF0042_1_BizPlan.InitControls:3) |
| WK-DMF0042-0391 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (1#6 ACT:DMF0042_1_BizPlan.InitControls:3) |
| WK-DMF0042-0392 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 10 (1#5 ACT:DMF0042_1_BizPlan.InitControls A) |
| WK-DMF0042-0393 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 16 (1#2 ACT:DMF0042_1_BizPlan.InitControls A) |
| WK-DMF0042-0394 | G4 | drpPeriod / Period / From / To / 기간 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period / From / To / 기간 · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (1#9 ACT:DMF0042_1_BizPlan.FindData:712:1) |
| WK-DMF0042-0395 | G4 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project / PJT · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (1#10) |
| WK-DMF0042-0396 | G4 | usrMonthFrom / Period / Month From | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrMonthFrom / Period / Month From · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0397 | G4 | usrMonthTo / ~ / Month To | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrMonthTo / ~ / Month To · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |

## W7 기대값 확정 (69)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0398 | F4 | DMF0009_GET_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0009_GET_CODE: 실측[T-448e6bfc]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T8 |  | 2 (ACT:DMF0042_3_BizPlan.GetComboData:2951:) |
| WK-DMF0042-0399 | F4 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE: 실측[T-033f3e69]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.cs |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0400 | G4 | txtItemId / Model / Item Id / Model/Nick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — txtItemId / Model / Item Id / Model/Nickname / Mod: 원장 EG-06652e2b 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nic |  | 1 (1#11) |
| WK-DMF0042-0401 | H5 | usrMonthFrom / Period / Month From | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — usrMonthFrom / Period / Month From: 검증 엔진이 실행됐으나 이 대상(COND usrMonthFrom)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0402 | A1 | 1#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#1: 행 집계 — 대조표 1#1 'clbDivision (단일 콤보)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP A |  | 1 (1#1) |
| WK-DMF0042-0403 | A1 | 1#10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#10: 행 집계 — 대조표 1#10 'txtProject + btnProject' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden  |  | 1 (1#10) |
| WK-DMF0042-0404 | A1 | 1#11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#11: 행 집계 — 대조표 1#11 'txtItemId + btnItemId' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SK |  | 1 (1#11) |
| WK-DMF0042-0405 | A1 | 1#12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#12: 행 집계 — 대조표 1#12 'txtOwner + btnOwner' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP |  | 1 (1#12) |
| WK-DMF0042-0406 | A1 | 1#13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#13: 행 집계 — 대조표 1#13 'chkSum' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1행 ↔  |  | 1 (1#13) |
| WK-DMF0042-0407 | A1 | 1#14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#14: 행 집계 — 대조표 1#14 'cboQty (Qty≥0 — Visible=false dead)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM |  | 1 (1#14) |
| WK-DMF0042-0408 | A1 | 1#15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#15: 행 집계 — 대조표 1#15 'cboClosed (Enabled=false dead)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P —  |  | 1 (1#15) |
| WK-DMF0042-0409 | A1 | 1#2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#2: 행 집계 — 대조표 1#2 'clbTeam' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1행 ↔ T |  | 1 (1#2) |
| WK-DMF0042-0410 | A1 | 1#3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#3: 행 집계 — 대조표 1#3 'clbCustomer' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1행 |  | 1 (1#3) |
| WK-DMF0042-0411 | A1 | 1#4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#4: 행 집계 — 대조표 1#4 'clbBizType' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1행  |  | 1 (1#4) |
| WK-DMF0042-0412 | A1 | 1#5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#5: 행 집계 — 대조표 1#5 'clbSalesSite' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1 |  | 1 (1#5) |
| WK-DMF0042-0413 | A1 | 1#6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#6: 행 집계 — 대조표 1#6 'clbPlantSite' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1 |  | 1 (1#6) |
| WK-DMF0042-0414 | A1 | 1#7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#7: 행 집계 — 대조표 1#7 'clbItemType' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS -1행 |  | 1 (1#7) |
| WK-DMF0042-0415 | A1 | 1#8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#8: 행 집계 — 대조표 1#8 'cboBucketType (M/Q/Y — 기본 Monthly)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P  |  | 1 (1#8) |
| WK-DMF0042-0416 | A1 | 1#9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1#9: 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_D |  | 1 (1#9) |
| WK-DMF0042-0417 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — 대조표 16 'spdMain_ComboSelChange (L1565~1596)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — |  | 1 (16) |
| WK-DMF0042-0418 | A1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 20: 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — go |  | 1 (20) |
| WK-DMF0042-0419 | A1 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 24: 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — g |  | 1 (24) |
| WK-DMF0042-0420 | A1 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 25: 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — gold |  | 1 (25) |
| WK-DMF0042-0421 | A1 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 26: 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P —  |  | 1 (26) |
| WK-DMF0042-0422 | A1 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 27: 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden |  | 1 (27) |
| WK-DMF0042-0423 | A1 | 3#1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3#1: 행 집계 — 대조표 3#1 'Form_Load (L209~217)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP  |  | 1 (3#1) |
| WK-DMF0042-0424 | A1 | 3#13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3#13: 행 집계 — 대조표 3#13 'btnMeasure_Click (L2819~2830)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — g |  | 1 (3#13) |
| WK-DMF0042-0425 | A1 | 3#4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3#4: 행 집계 — 대조표 3#4 'clbTeam_SelectedIndexChanged (L1509~1533)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GE |  | 1 (3#4) |
| WK-DMF0042-0426 | A1 | 3#5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3#5: 행 집계 — 대조표 3#5 'clbCustomer_SelectedIndexChanged (L1535~1547)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 1 (3#5) |
| WK-DMF0042-0427 | A1 | 6#6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6#6: 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_D |  | 1 (6#6) |
| WK-DMF0042-0428 | A1 | 6#7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6#7: 행 집계 — 대조표 6#7 'Ver.Cutoff/Replace 모달 = 목록조회+실행 표준 재구성' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_D |  | 1 (6#7) |
| WK-DMF0042-0429 | A1 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE: 골든 비교 케이스 없음(DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE — 팝업·보조 SP 는 golden_case |  | 40 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0430 | A1 | DMF0042_1_RTF.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_1_RTF.FindData: 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0431 | A1 | DMF0042_1_RTF.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0432 | A1 | DMF0042_2_BizPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DM |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0433 | A1 | DMF0042_2_BizPlan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_2_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0434 | A1 | DMF0042_3_BizPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DM |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0435 | A1 | DMF0042_3_BizPlan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_3_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0436 | A1 | Division 분기 33 (사업부분기 전수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division 분기 33 (사업부분기 전수): 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0437 | A1 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find (F5): 행 집계 — 대조표 Find (F5) 'hotkeyConfig.search → handleSearch (V-S1~S3 + setF' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG |  | 1 (Find (F5)) |
| WK-DMF0042-0438 | A1 | G9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G9: 행 집계 — 대조표 G9 '**CELL_PROD_SITE 콤보(40)** — 조회 표시 코드→한글(ALL)+신규행 유' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF |  | 1 (G9) |
| WK-DMF0042-0439 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT — 팝업·보조  |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:114) |
| WK-DMF0042-0440 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT — 팝업 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0441 | A1 | PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DAT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0042/DMF0042_GET_ |  | 192 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0442 | A1 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP: 골든 비교 케이스 없음(PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP  |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0443 | A1 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP: 골든 비교 케이스 없음(PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_ |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0444 | A1 | PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE: golden DIFF AS-IS 25행 ↔ TO-BE 19행: Doc/golden/DMF0042/DMF0042_GET_SPREAD_TITLE |  | 121 (ACT:DMF0042_BizPlan.FindButton ACT:DMF00) |
| WK-DMF0042-0445 | A1 | btnExchangeRate | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnExchangeRate: 행 집계 — 대조표 btnExchangeRate '커스텀 버튼(LBL00661) → pending 차단(MSG00680 — AS-IS MSG' 의 A1 7요소: REVIEW:7 ·  |  | 1 (btnExchangeRate) |
| WK-DMF0042-0446 | A1 | btnMeasure 'Measure' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnMeasure 'Measure': 행 집계 — 대조표 btnMeasure 'Measure' "커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('" 의 A1 7요소: R |  | 1 (btnMeasure 'Measure') |
| WK-DMF0042-0447 | A1 | btnReplace (ADMIN/DM ADMIN) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnReplace (ADMIN/DM ADMIN): 행 집계 — 대조표 btnReplace (ADMIN/DM ADMIN) "커스텀 버튼 'Replace' — hasButton('REPLACE') 게이트 + pen |  | 1 (btnReplace (ADMIN/DM ADMIN)) |
| WK-DMF0042-0448 | A1 | btnSetPrice (가격환산) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnSetPrice (가격환산): 행 집계 — 대조표 btnSetPrice (가격환산) "커스텀 버튼 'Set Price' → MSG00678 confirm → SET_PRICE(" 의 A1 7요소: REVIE |  | 1 (btnSetPrice (가격환산)) |
| WK-DMF0042-0449 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — 대조표 — '파리티 확인(무변경): 분모0 가드 기구현 / Cutoff 재조회 없음=파리티·Replac' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 1 (—) |
| WK-DMF0042-0450 | A1 | 버튼 가드 6 (#42/43/45/97~99) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 버튼 가드 6 (#42/43/45/97~99): 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-0451 | A1 | 조회 검증 4 (#9~12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 검증 4 (#9~12): 행 집계 — 대조표 조회 검증 4 (#9~12) 'MSG00097(Division)/MSG00108(역전)/MSG00276(6년 초과+보정)' 의 A1 7요소: REVIEW:7 ·  |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-0452 | X-LOC | 3#2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3#2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 (행의 식별자 sDivision 를 화면 소스·프로시저 목록에서 못 찾음) |  | 1 (3#2) |
| WK-DMF0042-0453 | X-LOC | 6#2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6#2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6#2) |
| WK-DMF0042-0454 | X-LOC | 6#7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6#7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6#7) |
| WK-DMF0042-0455 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-DMF0042-0456 | X-ROW | DMF0042_2_BizPlan.MinColumnChk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.MinColumnChk: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0042_2_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-0457 | X-ROW | DMF0042_2_BizPlan.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0042_2_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-0458 | X-ROW | DMF0042_2_BizPlan.ParameterString | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.ParameterString: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:DMF0042_2_BizPlan.ParameterString AC) |
| WK-DMF0042-0459 | X-ROW | DMF0042_2_BizPlan.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 37 (ACT:DMF0042_2_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-0460 | X-ROW | DMF0042_2_BizPlan.spdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_EditChange) |
| WK-DMF0042-0461 | M4 | DMF0042_1_BizPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0042_1_BizPlan: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0042_1_BizPlan)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0462 | M4 | DMF0042_3_BizPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0042_3_BizPlan: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0042_3_BizPlan)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0463 | M4 | DMF0042_BizPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0042_BizPlan: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0042_BizPlan)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0464 | M4 | DMF0042_BizPlan_old | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0042_BizPlan_old: 검증 엔진이 실행됐으나 이 대상(POPUP DMF0042_BizPlan_old)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0465 | M4 | btnProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnProject: 검증 엔진이 실행됐으나 이 대상(BTN btnProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 12 (btnProject/btnItemId/btnOwner 3#9 ACT:DM) |
| WK-DMF0042-0466 | M4 | txtProject / Project / PJT | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtProject / Project / PJT: 검증 엔진이 실행됐으나 이 대상(COND txtProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (3#9) |

## W9 도구 오류 (1143)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0467 | C1 | clbCustomer / End Customer / Customer | 하네스·환경 | C1 도구 오류 — 실측[T-fcbf4239]: 상위 'End Customer' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 20 (ACT:DMF0042_1_BizPlan.InitControls:295:3) |
| WK-DMF0042-0468 | C1 | clbTeam / Team | 하네스·환경 | C1 도구 오류 — 실측[T-1d12f755]: 상위 'Team' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 10 (ACT:DMF0042_1_BizPlan.InitControls:241:6) |
| WK-DMF0042-0469 | C2 | 17 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C2 75요소: ERROR:68 · NA:7 |  | 1 (17) |
| WK-DMF0042-0470 | C2 | 3#14 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 3#14 'spdMain_Changed (L1800~2723) ⭐' 의 C2 75요소: ERROR:68 · NA:7 |  | 1 (3#14) |
| WK-DMF0042-0471 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-16f24a4c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41) |
| WK-DMF0042-0472 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-bc528860 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1271:41) |
| WK-DMF0042-0473 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-57706630 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:993:37) |
| WK-DMF0042-0474 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-eafb5927 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1214:43) |
| WK-DMF0042-0475 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-6a338f10 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1259:41) |
| WK-DMF0042-0476 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-b4a06a5e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1277:43) |
| WK-DMF0042-0477 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-edbdad1a |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20) |
| WK-DMF0042-0478 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-74649ca6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1208:39) |
| WK-DMF0042-0479 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-12b2a8fa |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1336:15) |
| WK-DMF0042-0480 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-1d558d3a |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1354:26) |
| WK-DMF0042-0481 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-23b2ae22 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1227:20) |
| WK-DMF0042-0482 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-9f2c0cc5 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1251:39) |
| WK-DMF0042-0483 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-7cd3a1cf |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1245:20) |
| WK-DMF0042-0484 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-88e25df3 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1269:39) |
| WK-DMF0042-0485 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-4c266218 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:971:20) |
| WK-DMF0042-0486 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-9eb33426 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:991:35) |
| WK-DMF0042-0487 | C2 | DEMAND_OPERATION | 하네스·환경 | C2 도구 오류 — 실측[T-4c8b822f]: 팝업 내부 그리드 컬럼 DEMAND_OPERATION — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 18 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0488 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-bcf69618 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27) |
| WK-DMF0042-0489 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-30492e9e |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1239:27) |
| WK-DMF0042-0490 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-96ed3c12 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1257:27) |
| WK-DMF0042-0491 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-71889896 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:977:23) |
| WK-DMF0042-0492 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-00a512a7 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1194:25) |
| WK-DMF0042-0493 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b9f3c79d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1237:25) |
| WK-DMF0042-0494 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-618f33e6 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1255:25) |
| WK-DMF0042-0495 | C2 | DEPT_ID40 / Team | 하네스·환경 | C2 도구 오류 — 원장 V-00a512a7 ASIS / 원장 V-7ce487e9 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-b9f3c79d ASIS / 원장 V-eaed62c2 ASIS / 원장 V-8171f79d  |  | 34 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0496 | C2 | DEPT_NAME_KO | 하네스·환경 | C2 도구 오류 — 원장 V-0f4cf892 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0497 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-68f00b95 / 실측[T-8bc867f5]: 신규행 DIVISION_ID 콤보 후보 없음 — AS-IS 도 콤보 아님(메타 텍스트 · Insert 때 조회 Division 값 대입) → 같은 동작 |  | 1 (ACT:DMF0042_ExchangeRatePopup.InsertRow:) |
| WK-DMF0042-0498 | C2 | DIVISION_ID / Division | 하네스·환경 | C2 도구 오류 — 원장 V-68f00b95 ASIS |  | 2 (ACT:DMF0042_BizPlan_old.spdMain_ComboSel) |
| WK-DMF0042-0499 | C2 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C2 75요소: ERROR:68 · NA:7 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0500 | C2 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C2 75요소: ERROR:68 · NA:7 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0501 | C2 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C2 75요소: ERROR:68 · NA:7 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0502 | C2 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C2 75요소: ERROR:68 · NA:7 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0503 | C2 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C2 75요소: ERROR:68 · NA:7 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0504 | C2 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_Changed 의 C2 1요소: ERROR:1 |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0505 | C2 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | C2 도구 오류 — 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0506 | C2 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C2 75요소: ERROR:68 · NA:7 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0507 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-2b5ecc16 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29) |
| WK-DMF0042-0508 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-f7d398ae |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1350:22) |
| WK-DMF0042-0509 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-67527be1 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1241:29) |
| WK-DMF0042-0510 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-482c21d4 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1259:29) |
| WK-DMF0042-0511 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-837516a9 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:981:25) |
| WK-DMF0042-0512 | C2 | END_CUSTOMER / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-2b5ecc16 ASIS / 원장 V-f7d398ae ASIS / 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS / 원장 V-67527be1 ASIS / 원장 V-482c21d4  |  | 43 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0513 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-0db507c9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1200:31) |
| WK-DMF0042-0514 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-7ce487e9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0515 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-883d5fc3 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1243:31) |
| WK-DMF0042-0516 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-eaed62c2 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0517 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-dfec9ce3 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1261:31) |
| WK-DMF0042-0518 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-352cec4e |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0519 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-ed8628c3 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:983:27) |
| WK-DMF0042-0520 | C2 | END_CUSTOMER40 / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-0db507c9 ASIS / 원장 V-b05a3528 ASIS / 원장 V-7ce487e9 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-883d5fc3 ASIS / 원장 V-6b239e3a  |  | 49 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0521 | C2 | IMPUTATION_YN | 하네스·환경 | C2 도구 오류 — 실측[T-d1ea5166]: 팝업 내부 그리드 컬럼 IMPUTATION_YN — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 33 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0522 | C2 | MEASURE / Measure | 하네스·환경 | C2 도구 오류 — 실측[T-ec15d598]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 21f6b68a ≠ 현재 e8f5cb42) — 이전 판정 NA 보류: MEASURE: AS-IS 문장이 이 컬 |  | 38 (ACT:DMF0042_1_BizPlan.spdMain_Changed AC) |
| WK-DMF0042-0523 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-cb714874 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24) |
| WK-DMF0042-0524 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-cb714874 ASIS / 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS / 실측[T-4c75d8e5]: SCM_SITE_ID: AS-IS 문장이 이 컬럼을 읽기만 함(후보·값을 |  | 39 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0525 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-5a9af464 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0526 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-e316719e |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0527 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-ca1484f6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1202:33) |
| WK-DMF0042-0528 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b05a3528 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0529 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-2e0bc043 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0530 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-a023207f |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1245:33) |
| WK-DMF0042-0531 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-6b239e3a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0532 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-8171f79d |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0533 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-22c6c547 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1263:33) |
| WK-DMF0042-0534 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b0a7c3a7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0535 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b01e8ad8 |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0536 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-ca95afc3 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:985:29) |
| WK-DMF0042-0537 | C2 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | C2 도구 오류 — 원장 V-ca1484f6 ASIS / 원장 V-b05a3528 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-a023207f ASIS / 원장 V-6b239e3a ASIS / 원장 V-8171f79d  |  | 10 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0538 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-0a94fc5c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35) |
| WK-DMF0042-0539 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-8c171624 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1247:35) |
| WK-DMF0042-0540 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-cc060c9c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1265:35) |
| WK-DMF0042-0541 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-20184eda |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:987:31) |
| WK-DMF0042-0542 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-5fd584a1 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37) |
| WK-DMF0042-0543 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-996ba14d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1249:37) |
| WK-DMF0042-0544 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-c9358c4d |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1267:37) |
| WK-DMF0042-0545 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-d7bd3496 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:989:33) |
| WK-DMF0042-0546 | C2 | VARIATION_FACTOR | 하네스·환경 | C2 도구 오류 — 실측[T-ecc11b18]: 팝업 내부 그리드 컬럼 VARIATION_FACTOR — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0547 | C3 | 17 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C3 155요소: NA:139 · ERROR:16 |  | 1 (17) |
| WK-DMF0042-0548 | C3 | 3#14 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 3#14 'spdMain_Changed (L1800~2723) ⭐' 의 C3 155요소: NA:139 · ERROR:16 |  | 1 (3#14) |
| WK-DMF0042-0549 | C3 | BIZ_TYPE | 하네스·환경 | C3 도구 오류 — 실측[T-e560c235]: BIZ_TYPE: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0550 | C3 | BIZ_TYPE_NAME | 하네스·환경 | C3 도구 오류 — 실측[T-93bf9cb3]: BIZ_TYPE_NAME: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0551 | C3 | BIZ_TYPE_NAME81 / Biz.Type | 하네스·환경 | C3 도구 오류 — 실측[T-f154540d]: BIZ_TYPE_NAME81: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수  |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0552 | C3 | BIZ_UNIT | 하네스·환경 | C3 도구 오류 — 실측[T-a2c8aec3]: BIZ_UNIT: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0553 | C3 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | C3 도구 오류 — 실측[T-f16b1be7]: CELL_PER_MODULE: 원천 ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0554 | C3 | CELL_PER_PACK / Cell/Pack | 하네스·환경 | C3 도구 오류 — 실측[T-9c3ac2fb]: CELL_PER_PACK: 원천 ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0555 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 실측[T-1c39a660]: DIVISION_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:1222 siMain.SetText(iRowNo, siMain.GetColumnIndex(DefColum |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1222:46 ) |
| WK-DMF0042-0556 | C3 | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetCellColor 의 C3 155요소: NA:139 · ERROR:16 |  | 3 (ACT:DMF0042_2_BizPlan.SetCellColor:3493:) |
| WK-DMF0042-0557 | C3 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0558 | C3 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 C3 5요소: NA:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0559 | C3 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C3 155요소: NA:139 · ERROR:16 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0560 | C3 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C3 155요소: NA:139 · ERROR:16 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0561 | C3 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C3 155요소: NA:139 · ERROR:16 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0562 | C3 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C3 155요소: NA:139 · ERROR:16 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0563 | C3 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C3 155요소: NA:139 · ERROR:16 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0564 | C3 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C3 도구 오류 — 원장 V-46afa1eb ASIS / 원장 V-5d8b4218 ASIS / 원장 V-5ca822f9 ASIS / 원장 V-ab59fdc8 ASIS / 원장 V-0fa3bab9 ASIS / 원장 V-fe9dcbd8  |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0565 | C3 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C3 155요소: NA:139 · ERROR:16 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0566 | C3 | Grid 입력 4 (#39~40/41/44) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Grid 입력 4 (#39~40/41/44) 'Red 셀 가드/MSG00289(소수)/MSG00002(paste 재검증)/EditChan' 의 C3 155요소: NA:139 · ERROR:16 |  | 1 (Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0567 | C3 | MEASURE / Measure | 하네스·환경 | C3 도구 오류 — 원장 V-dea3ce34 ASIS / 원장 V-d28cd922 ASIS / 원장 V-0117f869 ASIS / 원장 V-b0a7891b ASIS / 실측[T-f377d869]: MEASURE 연쇄 원천 컬럼 해석 |  | 77 (ACT:DMF0042_1_BizPlan.InsertRow:1328:132) |
| WK-DMF0042-0568 | C3 | MODULE_PER_PACK / Module/Pack | 하네스·환경 | C3 도구 오류 — 실측[T-4d7afe55]: MODULE_PER_PACK: 원천 ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0569 | C3 | PRODUCT_GROUP | 하네스·환경 | C3 도구 오류 — 실측[T-2919b343]: PRODUCT_GROUP: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0570 | C3 | PRODUCT_GROUP_NAME / Product Group Name | 하네스·환경 | C3 도구 오류 — 실측[T-e2734e28]: PRODUCT_GROUP_NAME: 원천 PROJECT_CODE 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동  |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0571 | C3 | PROJECT_NAME / Project | 하네스·환경 | C3 도구 오류 — 실측[T-5356f99e]: PROJECT_NAME: 원천 PROJECT_CODE/PROJECT_CODE82/ITEM_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0572 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-b3cdb1c2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0573 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-46afa1eb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0574 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-288260e0 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0575 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-11d2b717 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1873) |
| WK-DMF0042-0576 | C6 | 17 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C6 177요소: ERROR:173 · NA:4 |  | 1 (17) |
| WK-DMF0042-0577 | C6 | 3#14 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 3#14 'spdMain_Changed (L1800~2723) ⭐' 의 C6 177요소: ERROR:173 · NA:4 |  | 1 (3#14) |
| WK-DMF0042-0578 | C6 | CITY | 하네스·환경 | C6 도구 오류 — 원장 V-187364fa ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0579 | C6 | CITY | 하네스·환경 | C6 도구 오류 — 원장 V-187364fa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0580 | C6 | COUNTRY | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0581 | C6 | COUNTRY | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0582 | C6 | DEMAND_OPERATION | 하네스·환경 | C6 도구 오류 — 실측[T-c3a574e1]: 팝업 내부 그리드 컬럼 DEMAND_OPERATION — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 18 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0583 | C6 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C6 177요소: ERROR:173 · NA:4 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0584 | C6 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C6 177요소: ERROR:173 · NA:4 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0585 | C6 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C6 177요소: ERROR:173 · NA:4 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0586 | C6 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C6 177요소: ERROR:173 · NA:4 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0587 | C6 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C6 177요소: ERROR:173 · NA:4 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0588 | C6 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C6 도구 오류 — 원장 V-0a1d518f ASIS / 원장 V-d23130f7 ASIS / 원장 V-adbaa1ff ASIS / 원장 V-fb2c9dc5 ASIS / 원장 V-c3cce468 ASIS / 원장 V-29e59967  |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0589 | C6 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0590 | C6 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C6 177요소: ERROR:173 · NA:4 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0591 | C6 | END_CUSTOMER / End Customer | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 43 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0592 | C6 | IMPUTATION_YN | 하네스·환경 | C6 도구 오류 — 실측[T-d4cf1ede]: 팝업 내부 그리드 컬럼 IMPUTATION_YN — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 33 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0593 | C6 | MEASURE / Measure | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 ASIS / 원장 V-cadc2ede ASIS / 원장 V-2399d393 ASIS / 원장 V-e0b2a706 ASIS / 실측[T-b0ecefe6]: [재측정 필요] 검사 조건이 바뀐  |  | 38 (ACT:DMF0042_1_BizPlan.spdMain_Changed AC) |
| WK-DMF0042-0594 | C6 | SCM_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 39 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0595 | C6 | SHIPTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-560baf7f ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0596 | C6 | SHIPTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-560baf7f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0597 | C6 | SHIPTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-1b319d46 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0598 | C6 | SHIPTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-1b319d46 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0599 | C6 | SOLDTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-172913c2 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0600 | C6 | SOLDTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-172913c2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0601 | C6 | SOLDTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-dd620832 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0602 | C6 | SOLDTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-dd620832 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0603 | C6 | UNIT_ENERGY / Energy | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 ASIS / 원장 V-cadc2ede ASIS / 원장 V-2399d393 ASIS / 실측[T-4740b5f7]: UNIT_ENERGY: AS-IS 원문(DMF0042_BizPlan.cs |  | 18 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0604 | C6 | VARIATION_FACTOR | 하네스·환경 | C6 도구 오류 — 실측[T-e22b532c]: 팝업 내부 그리드 컬럼 VARIATION_FACTOR — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0605 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7614fc19 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0606 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-98094696 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0607 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7d70355d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0608 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7f1911d3 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0609 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c3bbdde2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0610 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0852f630 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0611 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2658ad65 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0612 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-330f2268 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0613 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7077f3fe |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0614 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-642d797d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0615 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5885f41e |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0616 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-3dca26aa |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0617 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6df9e6f9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0618 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-dad7414b |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0619 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-473071e0 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0620 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-694ec72d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0621 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f6711b82 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0622 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-29675b46 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0623 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fadef0b2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0624 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-160972e4 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0625 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7b2de9cc |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0626 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6ca601d9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0627 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-019de781 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0628 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2406551a |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0629 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1d253b7e |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0630 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cf59e1f5 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0631 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4d7dfec1 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0632 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f908c1b1 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0633 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d23130f7 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0634 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-adbaa1ff |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0635 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fb2c9dc5 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0636 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c3cce468 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0637 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1fd7a706 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0638 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-041c5afa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0639 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d2cd269a |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0640 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d7c80802 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0641 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6ac15ddb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0642 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5ea410a2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0643 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8e39c458 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0644 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f7feb5f4 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0645 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-19289a65 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0646 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-73930660 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0647 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-14e709cb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0648 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ee9f83fd |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0649 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b55a59f2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0650 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c5a505ce |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0651 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-74199cad |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0652 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4cba64eb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0653 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-40a8e25b |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0654 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6105b03a |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0655 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7d23ad76 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0656 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-65cc0471 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0657 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c095fb25 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0658 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-48bb1499 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0659 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2f42a298 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0660 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8942b873 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0661 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-61e12d37 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0662 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-90113d18 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0663 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9c16c17d |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0664 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c365120a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0665 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-e967da30 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0666 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9728dfd9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0667 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b3fa48b7 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0668 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ea340dc9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0669 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-059b533a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0670 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-55d99ff9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0671 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-acbc1fe9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0672 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-47aed639 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0673 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-046281af |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0674 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fa1dc537 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0675 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-554e903c |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0676 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-a7af497a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0677 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d131e2b9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0678 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-de007a20 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0679 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-40a7fcd4 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0680 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cefdc65b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0681 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-df828ae0 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0682 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9ae37f47 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0683 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7f10ecf1 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0684 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-631f8106 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0685 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-88eb7a48 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0686 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0be994b5 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0687 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-71cbba48 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0688 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c5cabeaa |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0689 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4bd8e0bf |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1950) |
| WK-DMF0042-0690 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-083eb5a4 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1977) |
| WK-DMF0042-0691 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d50d66de |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2057) |
| WK-DMF0042-0692 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-34d893af |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2063) |
| WK-DMF0042-0693 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b3d0c504 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2104) |
| WK-DMF0042-0694 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5d90aae0 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2140) |
| WK-DMF0042-0695 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cc1e2799 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2225) |
| WK-DMF0042-0696 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2200f2f9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2231) |
| WK-DMF0042-0697 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6881513f |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2247) |
| WK-DMF0042-0698 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ea2ece32 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2253) |
| WK-DMF0042-0699 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0ea8234c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2275) |
| WK-DMF0042-0700 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9d6199e0 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2310) |
| WK-DMF0042-0701 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7ab7c182 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2315) |
| WK-DMF0042-0702 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d73d2f8b |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2344) |
| WK-DMF0042-0703 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2e69e89c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2382) |
| WK-DMF0042-0704 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1ba2e0b3 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2409) |
| WK-DMF0042-0705 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2bdba5c7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2489) |
| WK-DMF0042-0706 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0df0b7a4 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2495) |
| WK-DMF0042-0707 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6fb4bd9f |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2536) |
| WK-DMF0042-0708 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-88dabf64 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2572) |
| WK-DMF0042-0709 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0b83abe8 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2657) |
| WK-DMF0042-0710 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4a2bdfba |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2663) |
| WK-DMF0042-0711 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d02ffbd7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2679) |
| WK-DMF0042-0712 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-da7b8e60 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2685) |
| WK-DMF0042-0713 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cfb1baae |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2707) |
| WK-DMF0042-0714 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8da318ca |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2742) |
| WK-DMF0042-0715 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ca792127 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2747) |
| WK-DMF0042-0716 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ef473002 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2776) |
| WK-DMF0042-0717 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1d844f60 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0718 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-dd488d85 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0719 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-51cfc3cb |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0720 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2877e7b4 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0721 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-56b8d905 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0722 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-be707f86 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0723 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-196afbfd |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0724 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5f0d2805 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0725 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-a26ecce8 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0726 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-df60eef3 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0727 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-31c22614 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0728 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c42f4056 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0729 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d7b22526 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0730 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-859503bd |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0731 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-547ec5d7 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0732 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7718b4d4 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0733 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-47393edc |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0734 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0735 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-1d9e1a39 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0736 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-c54b23c8 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0737 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-35b1f359 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0738 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-37deac1d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0739 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-0a1d518f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0740 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-29e59967 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0741 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-b4166d47 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0742 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-f7cc2d95 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0743 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-18d92c80 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0744 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2e038f64 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0745 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-cadc2ede |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0746 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-661042ac |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0747 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-9443bc6e |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0748 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-13e5e006 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0749 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-553cd448 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0750 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-1bf77ea9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1873) |
| WK-DMF0042-0751 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2399d393 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1915) |
| WK-DMF0042-0752 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2ec3951a |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2077) |
| WK-DMF0042-0753 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-7a6b582c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2083) |
| WK-DMF0042-0754 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-299ad2ce |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2509) |
| WK-DMF0042-0755 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-90e9acc7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2515) |
| WK-DMF0042-0756 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-e0b2a706 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0757 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2b5b23ae |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0758 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-6931a814 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0759 | B1 | DEPT_ID / Team | 하네스·환경 | B1 도구 오류 — 원장 V-d51669b3 COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0760 | B1 | DEPT_ID40 / Team | 하네스·환경 | B1 도구 오류 — 원장 V-e56876d0 COLUMN |  | 10 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0761 | B1 | END_CUSTOMER / End Customer | 하네스·환경 | B1 도구 오류 — 원장 V-82fa7fcd COLUMN |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0762 | B1 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B1 도구 오류 — 원장 V-1ed1e67b COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0763 | B2 | DEPT_ID / Team | 하네스·환경 | B2 도구 오류 — 원장 V-e484d215 COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0764 | B2 | DEPT_ID40 / Team | 하네스·환경 | B2 도구 오류 — 원장 V-2f93baa7 COLUMN |  | 10 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0765 | B2 | END_CUSTOMER / End Customer | 하네스·환경 | B2 도구 오류 — 원장 V-630f12f5 COLUMN |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0766 | B2 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B2 도구 오류 — 원장 V-5fd779d3 COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0767 | B3 | DEPT_ID40 / Team | 하네스·환경 | B3 도구 오류 — 원장 V-f876020c COLUMN |  | 6 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0768 | B3 | DMF0042_2_BizPlan.GetBizTypebyDivision | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetBizTypebyDivision 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0769 | B3 | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0770 | B3 | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellIndexBySpanRowCells 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 4 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0771 | B3 | DMF0042_2_BizPlan.GetCellNumbersByRow | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellNumbersByRow 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 14 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0772 | B3 | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 8 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0773 | B3 | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 6 (ACT:DMF0042_2_BizPlan.GetDayRange:3091:1) |
| WK-DMF0042-0774 | B3 | DMF0042_2_BizPlan.GetLookupData | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetLookupData 의 B3 9요소: ERROR:6 · NA:2 · PASS:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetLookupData:3127) |
| WK-DMF0042-0775 | B3 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 B3 2요소: NA:1 · ERROR:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3116:4) |
| WK-DMF0042-0776 | B3 | END_CUSTOMER / End Customer | 하네스·환경 | B3 도구 오류 — 원장 V-e541dbde COLUMN |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0777 | B3 | END_CUSTOMER40 / End Customer | 하네스·환경 | B3 도구 오류 — 원장 V-48303ef9 COLUMN |  | 9 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0778 | B3 | clbCustomer / End Customer / Customer | 하네스·환경 | B3 도구 오류 — 원장 V-c230410d SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0779 | B3 | clbDivision / Division / Div. / Div | 하네스·환경 | B3 도구 오류 — 원장 V-b750d715 SEARCH |  | 25 (ACT:DMF0042_1_BizPlan.GetSpdTitle ACT:DM) |
| WK-DMF0042-0780 | B3 | clbTeam / Team | 하네스·환경 | B3 도구 오류 — 원장 V-b1993e7e SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0781 | B4 | DEPT_ID / Team | 하네스·환경 | B4 도구 오류 — 원장 V-1654c4da COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0782 | B4 | DEPT_ID40 / Team | 하네스·환경 | B4 도구 오류 — 원장 V-77065082 COLUMN |  | 16 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0783 | B4 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 B4 2요소: NA:1 · ERROR:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3116:4) |
| WK-DMF0042-0784 | B4 | END_CUSTOMER / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-7b1dc135 COLUMN |  | 9 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0785 | B4 | END_CUSTOMER40 / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-98c561ed COLUMN |  | 23 (16 ACT:DMF0042_1_BizPlan.InsertRow:1200:) |
| WK-DMF0042-0786 | B4 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-d95983fd COLUMN |  | 11 (16 ACT:DMF0042_1_BizPlan.InsertRow:1202:) |
| WK-DMF0042-0787 | B4 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-0a93c616 COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0788 | B4 | clbCustomer / End Customer / Customer | 하네스·환경 | B4 도구 오류 — 원장 V-b7925626 SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0789 | B4 | clbDivision / Division / Div. / Div | 하네스·환경 | B4 도구 오류 — 원장 V-cae3ba60 SEARCH |  | 25 (ACT:DMF0042_1_BizPlan.GetSpdTitle ACT:DM) |
| WK-DMF0042-0790 | B4 | clbSalesSite / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-f75bbb75 SEARCH |  | 1 (3#4) |
| WK-DMF0042-0791 | B4 | clbTeam / Team | 하네스·환경 | B4 도구 오류 — 원장 V-7110b583 SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0792 | K4 | DMF0042 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-9293cc64 DEFECT / 원장 V-12eb1e56 GENERAL / 원장 V-7957f9fb GENERAL / 원장 V-3730a306 GENERAL / 원장 V-9bd9600e GENERAL /  |  | 685 (ACT:DMF0042_1_BizPlan.btnColumn_Click AC) |
| WK-DMF0042-0793 | F2 | DMF0042 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-3ea1f174 RULE_SCREEN / 원장 V-a84bf383 RULE_SCREEN / 원장 V-d54f8c25 GENERAL / 원장 V-ea14357e GENERAL / 원장 V-f74d65c4 G |  | 1145 (1#15 Save (F7) 3#3 24 27 저장 검증 8 (#13~20) |
| WK-DMF0042-0794 | F6 | DMF0042 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-18392b92 RULE_SCREEN / 원장 V-ca74260c RULE_SCREEN / 원장 V-d40ea7a4 RULE_SCREEN / 원장 V-c1acddbc RULE_SCREEN / 원장 V-4d |  | 1140 (G8 3#1 24 ACT:DMF0042_1_BizPlan.SaveButt) |
| WK-DMF0042-0795 | DB-SYN | 1#9 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (1#9) |
| WK-DMF0042-0796 | DB-SYN | 20 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-DMF0042-0797 | DB-SYN | 24 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (24) |
| WK-DMF0042-0798 | DB-SYN | 25 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-DMF0042-0799 | DB-SYN | 3#1 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 3#1 'Form_Load (L209~217)' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (3#1) |
| WK-DMF0042-0800 | DB-SYN | DMF0042_1_BizPlan.GetCellProdSite | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetCellProdSite 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetCellProdSite:33) |
| WK-DMF0042-0801 | DB-SYN | DMF0042_1_BizPlan.GetDayRange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetDayRange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetDayRange:2874:3) |
| WK-DMF0042-0802 | DB-SYN | DMF0042_1_BizPlan.GetSpdTitle | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetSpdTitle 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetSpdTitle:2890:3) |
| WK-DMF0042-0803 | DB-SYN | DMF0042_1_RTF.FindData | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0042_1_RTF.FindData:304:4 ACT:DMF) |
| WK-DMF0042-0804 | DB-SYN | DMF0042_1_RTF.GetSLOC | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSLOC 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.GetSLOC:823:3 ACT:DMF0) |
| WK-DMF0042-0805 | DB-SYN | DMF0042_1_RTF.GetSPlant | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSPlant 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.GetSPlant:805:3 ACT:DM) |
| WK-DMF0042-0806 | DB-SYN | DMF0042_1_RTF.SaveData | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.SaveData 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.SaveData:464:45 ACT:DM) |
| WK-DMF0042-0807 | DB-SYN | DMF0042_2_BizPlan.FindData | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0042_2_BizPlan.FindData:698:27 AC) |
| WK-DMF0042-0808 | DB-SYN | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0809 | DB-SYN | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetDayRange:3098:5) |
| WK-DMF0042-0810 | DB-SYN | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3114:3) |
| WK-DMF0042-0811 | DB-SYN | DMF0042_2_BizPlan.SaveData | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SaveData 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.SaveData:1233:198 ) |
| WK-DMF0042-0812 | DB-SYN | DMF0042_2_BizPlan.btnSetPrice_Click | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.btnSetPrice_Click 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0813 | DB-SYN | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_CellDoubleClick 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0814 | DB-SYN | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_ComboSelChange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0815 | DB-SYN | DMF0042_3_BizPlan.FindData | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0042_3_BizPlan.FindData:761:27 AC) |
| WK-DMF0042-0816 | DB-SYN | DMF0042_3_BizPlan.GetCellProdSite | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetCellProdSite 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetCellProdSite:34) |
| WK-DMF0042-0817 | DB-SYN | DMF0042_3_BizPlan.GetDayRange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetDayRange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetDayRange:2988:3) |
| WK-DMF0042-0818 | DB-SYN | DMF0042_3_BizPlan.GetSpdTitle | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetSpdTitle 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetSpdTitle:3004:3) |
| WK-DMF0042-0819 | DB-SYN | DMF0042_BizPlan.GetCellProdSite | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetCellProdSite 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan.GetCellProdSite:3457) |
| WK-DMF0042-0820 | DB-SYN | DMF0042_BizPlan.GetDayRange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetDayRange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan.GetDayRange:2937:3 A) |
| WK-DMF0042-0821 | DB-SYN | DMF0042_BizPlan_old.GetDayRange | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan_old.GetDayRange 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan_old.GetDayRange:2142) |
| WK-DMF0042-0822 | DB-SYN | DMF0042_ExchangeRatePopup.InitSpread_X | 하네스·환경 | DB-SYN 도구 오류 — 진입점 집계 — 대조표 DMF0042_ExchangeRatePopup.InitSpread_X 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0823 | DB-SYN | Division 분기 33 (사업부분기 전수) | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 DB-SYN 14요소: PASS:10 ·  |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0824 | DB-SYN | G8 | 하네스·환경 | DB-SYN 도구 오류 — 행 집계 — 대조표 G8 '필수값 — **81 에 FCST_TYPE/INCOTERMS 추가**, **82 의 PROJ' 의 DB-SYN 14요소: PASS:10 · NOPATH:4 (미실행 요소가 남아 판정 |  | 1 (G8) |
| WK-DMF0042-0825 | F4 | 1#9 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF000 |  | 1 (1#9) |
| WK-DMF0042-0826 | F4 | 20 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_C |  | 1 (20) |
| WK-DMF0042-0827 | F4 | 24 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_ |  | 1 (24) |
| WK-DMF0042-0828 | F4 | 25 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_COD |  | 1 (25) |
| WK-DMF0042-0829 | F4 | 3#1 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 3#1 'Form_Load (L209~217)' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T- |  | 1 (3#1) |
| WK-DMF0042-0830 | F4 | DMF0042_1_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetCellProdSite 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_COD |  | 2 (ACT:DMF0042_1_BizPlan.GetCellProdSite:33) |
| WK-DMF0042-0831 | F4 | DMF0042_1_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetDayRange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_1_BizPlan.GetDayRange:2874:3) |
| WK-DMF0042-0832 | F4 | DMF0042_1_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetSpdTitle 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_1_BizPlan.GetSpdTitle:2890:3) |
| WK-DMF0042-0833 | F4 | DMF0042_1_RTF.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T-44 |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0834 | F4 | DMF0042_1_RTF.FindDataMain | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[ |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0835 | F4 | DMF0042_1_RTF.GetSLOC | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSLOC 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T-448 |  | 2 (ACT:DMF0042_1_RTF.GetSLOC:823:3 ACT:DMF0) |
| WK-DMF0042-0836 | F4 | DMF0042_1_RTF.GetSPlant | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSPlant 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T-4 |  | 2 (ACT:DMF0042_1_RTF.GetSPlant:805:3 ACT:DM) |
| WK-DMF0042-0837 | F4 | DMF0042_1_RTF.SaveButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.SaveButton 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T- |  | 1 (ACT:DMF0042_1_RTF.SaveButton) |
| WK-DMF0042-0838 | F4 | DMF0042_1_RTF.SaveData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.SaveData 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[T-44 |  | 1 (ACT:DMF0042_1_RTF.SaveData) |
| WK-DMF0042-0839 | F4 | DMF0042_2_BizPlan.FindButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실 |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0840 | F4 | DMF0042_2_BizPlan.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[ |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0841 | F4 | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_COD |  | 2 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0842 | F4 | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_2_BizPlan.GetDayRange:3098:5) |
| WK-DMF0042-0843 | F4 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3114:3) |
| WK-DMF0042-0844 | F4 | DMF0042_2_BizPlan.SaveButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SaveButton 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실 |  | 1 (ACT:DMF0042_2_BizPlan.SaveButton) |
| WK-DMF0042-0845 | F4 | DMF0042_2_BizPlan.SaveData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SaveData 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[ |  | 1 (ACT:DMF0042_2_BizPlan.SaveData) |
| WK-DMF0042-0846 | F4 | DMF0042_2_BizPlan.btnSetPrice_Click | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.btnSetPrice_Click 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_C |  | 2 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0847 | F4 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_CellDoubleClick 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009 |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0848 | F4 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_ComboSelChange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_ |  | 8 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0849 | F4 | DMF0042_3_BizPlan.FindButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실 |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0850 | F4 | DMF0042_3_BizPlan.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측[ |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0851 | F4 | DMF0042_3_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetCellProdSite 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_COD |  | 2 (ACT:DMF0042_3_BizPlan.GetCellProdSite:34) |
| WK-DMF0042-0852 | F4 | DMF0042_3_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetDayRange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_3_BizPlan.GetDayRange:2988:3) |
| WK-DMF0042-0853 | F4 | DMF0042_3_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetSpdTitle 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE —  |  | 2 (ACT:DMF0042_3_BizPlan.GetSpdTitle:3004:3) |
| WK-DMF0042-0854 | F4 | DMF0042_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetCellProdSite 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE  |  | 2 (ACT:DMF0042_BizPlan.GetCellProdSite:3457) |
| WK-DMF0042-0855 | F4 | DMF0042_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetDayRange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE — 실측 |  | 2 (ACT:DMF0042_BizPlan.GetDayRange:2937:3 A) |
| WK-DMF0042-0856 | F4 | DMF0042_BizPlan_old.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan_old.GetDayRange 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GET_CODE  |  | 2 (ACT:DMF0042_BizPlan_old.GetDayRange:2142) |
| WK-DMF0042-0857 | F4 | DMF0042_ExchangeRatePopup.InitSpread_X | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_ExchangeRatePopup.InitSpread_X 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL 요소: DMF0009_GE |  | 1 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0858 | F4 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 F4 14요소: ERROR:6 · NA:4 · P |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0859 | F4 | G8 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 G8 '필수값 — **81 에 FCST_TYPE/INCOTERMS 추가**, **82 의 PROJ' 의 F4 14요소: ERROR:6 · NA:4 · PASS:2 · REVIEW:2 · FAIL |  | 1 (G8) |
| WK-DMF0042-0860 | F4 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 하네스·환경 | F4 도구 오류 — 실측[T-156beb32]: PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT: DMF0003/custDemandInit/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트 |  | 3 (ACT:DMF0042_1_RTF.Select_DpInit_Data:103) |
| WK-DMF0042-0861 | F4 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 하네스·환경 | F4 도구 오류 — 실측[T-dd0458bf]: PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT: DMF0003/custDemandResult/SEARCH — 화면 진입·조회 중 호출 없음(셀 |  | 3 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0862 | F4 | PKG_DMF0042.P_DMF0042_GET_EXCHANGE_PRICE | 하네스·환경 | F4 도구 오류 — 실측[T-6d0484f5]: PKG_DMF0042.P_DMF0042_GET_EXCHANGE_PRICE: DMF0042/Biz Plan/EXCHANGE_RATE, DMF0042/exchangeRate/SEARCH — |  | 10 (ACT:DMF0042_1_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-0863 | F4 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 하네스·환경 | F4 도구 오류 — 실측[T-697412fa]: PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP: DMF0042/futurePrice/SEARCH — 화면 진입·조회 중 호출 없음(셀 이 |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0864 | F4 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 하네스·환경 | F4 도구 오류 — 실측[T-dcdf38c7]: PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA: DMF0042/futurePriceData/SEARCH — 화면 진입·조회 중  |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0865 | F4 | PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCS | 하네스·환경 | F4 도구 오류 — 실측[T-df075610]: PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV: DMF0042/Biz Plan/SET_PRICE — 화면 진입·조회 중 호출 없음(셀 이 |  | 8 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0866 | A5 | 1#14 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 1#14 'cboQty (Qty≥0 — Visible=false dead)' 의 A5 18요소: ERROR:14 · PASS:4 |  | 1 (1#14) |
| WK-DMF0042-0867 | A5 | 1#9 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 A5 18요소: ERROR:14 · PASS:4 |  | 1 (1#9) |
| WK-DMF0042-0868 | A5 | 6#5 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 6#5 "cboQty 비노출 + 'N' 고정" 의 A5 18요소: ERROR:14 · PASS:4 |  | 1 (6#5) |
| WK-DMF0042-0869 | A5 | 6#6 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 A5 18요소: ERROR:14 · PASS:4 |  | 1 (6#6) |
| WK-DMF0042-0870 | A5 | COLUMN_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-92c54a7b]: COLUMN_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0871 | A5 | COLUMN_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-9fb52591]: COLUMN_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0872 | A5 | CURRENCY_UNITCURRENCY | 하네스·환경 | A5 도구 오류 — 실측[T-31b778c5]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0873 | A5 | DEMAND_OPERATION | 하네스·환경 | A5 도구 오류 — 실측[T-c7916301]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 18 (ACT:DMF0042_1_RTF.spdMain_CellClick:931:) |
| WK-DMF0042-0874 | A5 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-b38ac018]: [측정 경로 없음] AS-IS 컬럼 숨김 정보가 원장 칸 상한으로 잘림(T520) |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0875 | A5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | A5 도구 오류 — 실측[T-6ccda6a5]: [측정 경로 없음] AS-IS 컬럼 숨김 정보가 원장 칸 상한으로 잘림(T520) |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0876 | A5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | A5 도구 오류 — 실측[T-9f72ea71]: [측정 경로 없음] AS-IS 컬럼 숨김 정보가 원장 칸 상한으로 잘림(T520) |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0877 | A5 | EXT_INT | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-c49e8271]: EXT_INT: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0878 | A5 | IMPUTATION_YN | 하네스·환경 | A5 도구 오류 — 실측[T-77c71bad]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 12 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0879 | A5 | ITEM_ID / Model | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-a123c4f8]: ITEM_ID: [측정 경로 없음] AS-IS 시트 Biz Plan 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 7 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0880 | A5 | LARGE_CLASS_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-a8802210]: LARGE_CLASS_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0881 | A5 | MEASURE / Measure | 하네스·환경 | A5 도구 오류 — 원장 V-8bd1e823 COLUMN / E2E smoke columns / 실측[T-dd4ddb70]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 c6425b3c ≠ 현재 0fc0 |  | 33 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0882 | A5 | PROJECT_CODE / Project Code | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-6b0dc1ce]: PROJECT_CODE: [측정 경로 없음] AS-IS 시트 Biz Plan 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203 |  | 7 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0883 | A5 | PROJECT_CODE82 / Project Code | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-00b208f9]: PROJECT_CODE82: [측정 경로 없음] AS-IS 시트 Biz Plan 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T2 |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0884 | A5 | SMALL_CLASS_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-068246b1]: SMALL_CLASS_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0885 | A5 | UNIT_CURRENCY | 하네스·환경 | A5 도구 오류 — 실측[T-86b7cd86]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0886 | A5 | VARIATION_FACTOR | 하네스·환경 | A5 도구 오류 — 실측[T-5557d1d2]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:DMF0042_1_RTF.spdMain_CellClick:966:) |
| WK-DMF0042-0887 | H10 | DMF0042 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 16 (G5 1#8 Insert (F8) btnSetPrice (가격환산) bt) |
| WK-DMF0042-0888 | H2 | 1#9 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 1 (1#9) |
| WK-DMF0042-0889 | H2 | 18 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 18 'spdMain_TopChange (L2736~2741)' 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 1 (18) |
| WK-DMF0042-0890 | H2 | 6#6 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 1 (6#6) |
| WK-DMF0042-0891 | H2 | CURRENCY / Currency | 하네스·환경 | H2 도구 오류 — 원장 V-2ea05ec2 COLUMN / 원장 V-01895b79 ASIS / 실측[T-afea2fe9]: CURRENCY: 기존행 편집=false 표시 일치 · 신규행 편집=true 표시 일치 |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0892 | H2 | CURRENCY_UNITCURRENCY | 하네스·환경 | H2 도구 오류 — 실측[T-271985b5]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0893 | H2 | DIVISION_ID / Division | 하네스·환경 | H2 도구 오류 — 원장 V-a9e54fd5 COLUMN / 원장 V-01895b79 ASIS / 실측[T-050d7813]: DIVISION_ID: 기존행 편집=false 표시 일치 · 신규행 편집=false 표시 일치 |  | 5 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0894 | H2 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0895 | H2 | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0896 | H2 | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetCellColor 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 3 (ACT:DMF0042_2_BizPlan.SetCellColor:3493:) |
| WK-DMF0042-0897 | H2 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 H2 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0898 | H2 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 H2 5요소: NA:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0899 | H2 | EditButton 잠금 8 (#6~13) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 EditButton 잠금 8 (#6~13) '좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 /' 의 H2 28요소: ERROR:17 · NA:10 · P |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-0900 | H2 | MEASURE / Measure | 하네스·환경 | H2 도구 오류 — 원장 V-a9402bf5 COLUMN / 실측[T-d741cdad]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 c6425b3c ≠ 현재 0fc03823) — 이전 판정 PASS 보 |  | 33 (InsertRow Measure/수량 잠금 11 (#56~66) ACT:) |
| WK-DMF0042-0901 | H2 | REPORT_GROUP8 | 하네스·환경 | H2 도구 오류 — 실측[T-fb3023e7]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0902 | H2 | SUM 헤더 5 (#1~5) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SUM 헤더 5 (#1~5) 'SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기' 의 H2 28요소: ERROR:17 · NA:10 · PASS:1 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-0903 | H2 | UNIT_CURRENCY | 하네스·환경 | H2 도구 오류 — 실측[T-3abd98ea]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0904 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-1646da51 |  | 1 (ACT:DMF0042_1_BizPlan.DeleteButton:534:5) |
| WK-DMF0042-0905 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-9bc5f9e9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1157:4) |
| WK-DMF0042-0906 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-354f5a34 |  | 1 (ACT:DMF0042_2_BizPlan.DeleteButton:530:5) |
| WK-DMF0042-0907 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-4dcf777c |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1309:4) |
| WK-DMF0042-0908 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-13a04bd9 |  | 1 (ACT:DMF0042_3_BizPlan.DeleteButton:560:5) |
| WK-DMF0042-0909 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-065768b7 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1200:4) |
| WK-DMF0042-0910 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-6124c5b9 |  | 1 (ACT:DMF0042_BizPlan.DeleteButton:558:5) |
| WK-DMF0042-0911 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-bd1900e1 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1218:4) |
| WK-DMF0042-0912 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-bf6cee0c |  | 1 (ACT:DMF0042_BizPlan_old.DeleteButton:505) |
| WK-DMF0042-0913 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-48e07650 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:944:4) |
| WK-DMF0042-0914 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-01895b79 |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-0915 | H5 | 6#6 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H5 19요소: ERROR:13 · PASS:5 · NOT_RUN:1 |  | 1 (6#6) |
| WK-DMF0042-0916 | H5 | COLUMN_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-8b2fd543]: COLUMN_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0917 | H5 | COLUMN_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-f95fa19f]: COLUMN_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0918 | H5 | CURRENCY_UNITCURRENCY | 하네스·환경 | H5 도구 오류 — 실측[T-f48d3681]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0919 | H5 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 H5 19요소: ERROR:13 · PASS:5 · NOT_RUN:1 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0920 | H5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 H5 2요소: PASS:1 · ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0921 | H5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 H5 5요소: ERROR:5 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0922 | H5 | EXT_INT | 하네스·환경 | H5 도구 오류 — 실측[T-2b97de31]: EXT_INT 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0923 | H5 | ITEM_ID / Model | 하네스·환경 | H5 도구 오류 — 실측[T-f8a6807b]: ITEM_ID 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0924 | H5 | LARGE_CLASS_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-d4512ef1]: LARGE_CLASS_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0925 | H5 | MEASURE / Measure | 하네스·환경 | H5 도구 오류 — 실측[T-b9ef46dd]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 c6425b3c ≠ 현재 0fc03823) — 이전 판정 PASS 보류: MEASURE: AS-IS 'Meas |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0926 | H5 | PROJECT_CODE / Project Code | 하네스·환경 | H5 도구 오류 — 실측[T-d6dbef5f]: PROJECT_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0927 | H5 | SMALL_CLASS_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-36be5d33]: SMALL_CLASS_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0928 | H5 | UNIT_CURRENCY | 하네스·환경 | H5 도구 오류 — 실측[T-ab7216ed]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0929 | H5 | chkSum / Sum | 하네스·환경 | H5 도구 오류 — 원장 V-96012b16 SEARCH |  | 12 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0930 | H5 | drpPeriod / Period / From / To / 기간 | 하네스·환경 | H5 도구 오류 — 원장 V-e923a2ac SEARCH |  | 1 (1#9) |
| WK-DMF0042-0931 | H5 | usrMonthTo / ~ / Month To | 하네스·환경 | H5 도구 오류 — 원장 V-bddc7642 SEARCH |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0932 | D3 | 17 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (17) |
| WK-DMF0042-0933 | D3 | 21 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (21) |
| WK-DMF0042-0934 | D3 | 26 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (26) |
| WK-DMF0042-0935 | D3 | 27 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (27) |
| WK-DMF0042-0936 | D3 | 28 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 28 'btnReplace_Click (L3382~3474)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (28) |
| WK-DMF0042-0937 | D3 | 3#6 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 3#6 'cboBucketType_SelectedIndexChanged (L1549~1563)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (3#6) |
| WK-DMF0042-0938 | D3 | 6#1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 6#1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (6#1) |
| WK-DMF0042-0939 | D3 | 6#6 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (6#6) |
| WK-DMF0042-0940 | D3 | ALT_SIM_YN | 하네스·환경 | D3 도구 오류 — 원장 V-3c68f552 ASIS / 실측[T-cc29693c]: ALT_SIM_YN: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1305:71) |
| WK-DMF0042-0941 | D3 | ALT_SIM_YN,ALT_SIM_YN | 하네스·환경 | D3 도구 오류 — 원장 V-3c68f552 / 실측[T-7f8acb5b]: ALT_SIM_YN: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1305:71) |
| WK-DMF0042-0942 | D3 | APPLICATION / Applicaion | 하네스·환경 | D3 도구 오류 — 원장 V-1d51f8e3 ASIS / 원장 V-0ef8b73e ASIS / 원장 V-ba149f1d ASIS / 원장 V-05a40d09 ASIS / 실측[T-8425cfe8]: r0 APPLICATION 그리드에 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1240:57 ) |
| WK-DMF0042-0943 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-1d51f8e3 / 실측[T-9ebe176d]: r0 APPLICATION 그리드에 없음 · r1 APPLICATION 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1240:57) |
| WK-DMF0042-0944 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-0ef8b73e / 실측[T-2009a136]: r0 APPLICATION 그리드에 없음 · r1 APPLICATION 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1285:55) |
| WK-DMF0042-0945 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-ba149f1d / 실측[T-bd1ea934]: r0 APPLICATION 그리드에 없음 · r1 APPLICATION 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1303:57) |
| WK-DMF0042-0946 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-05a40d09 / 실측[T-7ca8081d]: r0 APPLICATION 그리드에 없음 · r1 APPLICATION 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1018:5) |
| WK-DMF0042-0947 | D3 | BIZ_TYPE_NAME40 / Biz.Type | 하네스·환경 | D3 도구 오류 — 원장 V-4472d4e5 ASIS / 원장 V-56553955 ASIS / 원장 V-8e706c56 ASIS / 원장 V-8d8067ec ASIS / 실측[T-2b65fce1]: r0 BIZ_TYPE_NAME40  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1248:63 ) |
| WK-DMF0042-0948 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-4472d4e5 / 실측[T-464af373]: r0 BIZ_TYPE_NAME40 그리드에 없음 · r1 BIZ_TYPE_NAME40 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1248:63) |
| WK-DMF0042-0949 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-56553955 / 실측[T-491a428f]: r0 BIZ_TYPE_NAME40 그리드에 없음 · r1 BIZ_TYPE_NAME40 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1293:61) |
| WK-DMF0042-0950 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-8e706c56 / 실측[T-99cb9e55]: r0 BIZ_TYPE_NAME40 그리드에 없음 · r1 BIZ_TYPE_NAME40 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1311:63) |
| WK-DMF0042-0951 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-8d8067ec / 실측[T-0f867bc3]: r0 BIZ_TYPE_NAME40 그리드에 없음 · r1 BIZ_TYPE_NAME40 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1026:5) |
| WK-DMF0042-0952 | D3 | BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 실측[T-a814a484]: 팝업 내부 컬럼 BIZ_TYPE_NAME82 — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1246:61 ) |
| WK-DMF0042-0953 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-e598ffa6 / 실측[T-29eab919]: BIZ_TYPE_NAME82: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1246:61) |
| WK-DMF0042-0954 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-f0c56291 / 실측[T-8fb68cb8]: BIZ_TYPE_NAME82: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1291:59) |
| WK-DMF0042-0955 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-b7995b55 / 실측[T-4770d10a]: BIZ_TYPE_NAME82: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1309:61) |
| WK-DMF0042-0956 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-6280cccd / 실측[T-0fe96211]: BIZ_TYPE_NAME82: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1024:5) |
| WK-DMF0042-0957 | D3 | CELL_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-39fa15d9 ASIS / 실측[T-9b12b8fc]: CELL_CODE: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1311:77) |
| WK-DMF0042-0958 | D3 | CELL_CODE,CELL_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-39fa15d9 / 실측[T-967f27c1]: CELL_CODE: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1311:77) |
| WK-DMF0042-0959 | D3 | CELL_NAME | 하네스·환경 | D3 도구 오류 — 실측[T-de2e562a]: 팝업 내부 컬럼 CELL_NAME — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1309:75) |
| WK-DMF0042-0960 | D3 | CELL_NAME,CELL_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-0e00d3fa / 실측[T-4aceb757]: CELL_NAME: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1309:75) |
| WK-DMF0042-0961 | D3 | CELL_PER_CAR / Cell/Car | 하네스·환경 | D3 도구 오류 — 원장 V-9e4f5b6e ASIS / 원장 V-1e7f5552 ASIS / 원장 V-c3aa5d2c ASIS / 실측[T-0c0f7500]: r0 CELL_PER_CAR 그리드에 없음 · r1 CELL_PER_CA |  | 4 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0962 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-9e4f5b6e / 실측[T-1180a1e0]: r0 CELL_PER_CAR 그리드에 없음 · r1 CELL_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1323:128) |
| WK-DMF0042-0963 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-1e7f5552 / 실측[T-e40f7ce3]: r0 CELL_PER_CAR 그리드에 없음 · r1 CELL_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1389:141) |
| WK-DMF0042-0964 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-c3aa5d2c / 실측[T-deb65051]: r0 CELL_PER_CAR 그리드에 없음 · r1 CELL_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1386:128) |
| WK-DMF0042-0965 | D3 | CELL_TYPE / Product Group | 하네스·환경 | D3 도구 오류 — 원장 V-9e3e08a6 ASIS / 원장 V-a9cb9213 ASIS / 원장 V-24717eb6 ASIS / 원장 V-a1dc0498 ASIS / 실측[T-f2a616bc]: r0 CELL_TYPE 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1273:86 ) |
| WK-DMF0042-0966 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-9e3e08a6 / 실측[T-70aecba1]: r0 CELL_TYPE 그리드에 없음 · r1 CELL_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1273:86) |
| WK-DMF0042-0967 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-a9cb9213 / 실측[T-05179313]: r0 CELL_TYPE 그리드에 없음 · r1 CELL_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1339:99) |
| WK-DMF0042-0968 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-24717eb6 / 실측[T-fc52b79e]: r0 CELL_TYPE 그리드에 없음 · r1 CELL_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1336:86) |
| WK-DMF0042-0969 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-a1dc0498 / 실측[T-6664cda7]: r0 CELL_TYPE 그리드에 없음 · r1 CELL_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1048:7) |
| WK-DMF0042-0970 | D3 | CITY_NAME / City | 하네스·환경 | D3 도구 오류 — 원장 V-e85aea8e ASIS / 원장 V-a0db4200 ASIS / 원장 V-8ea76ab5 ASIS / 원장 V-2939924d ASIS / 실측[T-6681807f]: r0 CITY_NAME 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1279:92 ) |
| WK-DMF0042-0971 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-e85aea8e / 실측[T-5c82155f]: r0 CITY_NAME 그리드에 없음 · r1 CITY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1279:92) |
| WK-DMF0042-0972 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a0db4200 / 실측[T-28741c01]: r0 CITY_NAME 그리드에 없음 · r1 CITY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1345:105) |
| WK-DMF0042-0973 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8ea76ab5 / 실측[T-3d5c9118]: r0 CITY_NAME 그리드에 없음 · r1 CITY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1342:92) |
| WK-DMF0042-0974 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2939924d / 실측[T-a95bcdc6]: r0 CITY_NAME 그리드에 없음 · r1 CITY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1054:8) |
| WK-DMF0042-0975 | D3 | COUNTRY_NAME / Country | 하네스·환경 | D3 도구 오류 — 원장 V-f1cc012a ASIS / 원장 V-63cd2b88 ASIS / 원장 V-63ee327c ASIS / 원장 V-890aea0a ASIS / 실측[T-c68aff84]: r0 COUNTRY_NAME 그리드 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1277:90 ) |
| WK-DMF0042-0976 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-f1cc012a / 실측[T-204e9aa8]: r0 COUNTRY_NAME 그리드에 없음 · r1 COUNTRY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1277:90) |
| WK-DMF0042-0977 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-63cd2b88 / 실측[T-7a994b8d]: r0 COUNTRY_NAME 그리드에 없음 · r1 COUNTRY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1343:103) |
| WK-DMF0042-0978 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-63ee327c / 실측[T-deb5636b]: r0 COUNTRY_NAME 그리드에 없음 · r1 COUNTRY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1340:90) |
| WK-DMF0042-0979 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-890aea0a / 실측[T-25f1d1e0]: r0 COUNTRY_NAME 그리드에 없음 · r1 COUNTRY_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1052:8) |
| WK-DMF0042-0980 | D3 | CURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-ffb147a3 / 실측[T-0f873123]: r0  → CURRENCY 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → CURRENCY 편집=false (AS-IS 잠 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0981 | D3 | CURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-ce02db1d / 실측[T-55792b6a]: r0  → CURRENCY 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → CURRENCY 편집=false (AS-IS 잠 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0982 | D3 | CURRENCY / Currency | 하네스·환경 | D3 도구 오류 — 원장 V-ffb147a3 ASIS / 원장 V-ce02db1d ASIS / 원장 V-77167e5f ASIS / 실측[T-fad7aa2a]: r0  → CURRENCY 편집=false (AS-IS 잠금 EditBu |  | 6 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0983 | D3 | CURRENCY_UNITCURRENCY | 하네스·환경 | D3 도구 오류 — 실측[T-0e966ad0]: 팝업 내부 컬럼 CURRENCY_UNITCURRENCY — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0984 | D3 | CURRENCY_UNITCURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-0e51f7d4 / 실측[T-1e1b615f]: CURRENCY_UNITCURRENCY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_ExchangeRatePopup.InsertRow:) |
| WK-DMF0042-0985 | D3 | CUST_GROUP / Cust Group | 하네스·환경 | D3 도구 오류 — 원장 V-544ee1e9 ASIS / 원장 V-7bc2022f ASIS / 원장 V-97a51494 ASIS / 원장 V-427fc956 ASIS / 실측[T-7f8d7e9e]: r0 CUST_GROUP 그리드에  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1234:51 ) |
| WK-DMF0042-0986 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-544ee1e9 / 실측[T-856f225b]: r0 CUST_GROUP 그리드에 없음 · r1 CUST_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1234:51) |
| WK-DMF0042-0987 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-7bc2022f / 실측[T-6338151a]: r0 CUST_GROUP 그리드에 없음 · r1 CUST_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1279:49) |
| WK-DMF0042-0988 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-97a51494 / 실측[T-0dce70e8]: r0 CUST_GROUP 그리드에 없음 · r1 CUST_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1297:51) |
| WK-DMF0042-0989 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-427fc956 / 실측[T-ac0a7cf6]: r0 CUST_GROUP 그리드에 없음 · r1 CUST_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1012:4) |
| WK-DMF0042-0990 | D3 | CUST_GROUP_DTL / Cust Group Dtl | 하네스·환경 | D3 도구 오류 — 원장 V-9331f408 ASIS / 원장 V-37dd1366 ASIS / 원장 V-af524574 ASIS / 원장 V-0cf1835d ASIS / 실측[T-24332654]: r0 CUST_GROUP_DTL 그 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1236:53 ) |
| WK-DMF0042-0991 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-9331f408 / 실측[T-2c04a221]: r0 CUST_GROUP_DTL 그리드에 없음 · r1 CUST_GROUP_DTL 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1236:53) |
| WK-DMF0042-0992 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-37dd1366 / 실측[T-decb058c]: r0 CUST_GROUP_DTL 그리드에 없음 · r1 CUST_GROUP_DTL 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1281:51) |
| WK-DMF0042-0993 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-af524574 / 실측[T-84f3ed34]: r0 CUST_GROUP_DTL 그리드에 없음 · r1 CUST_GROUP_DTL 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1299:53) |
| WK-DMF0042-0994 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-0cf1835d / 실측[T-b6c1ee69]: r0 CUST_GROUP_DTL 그리드에 없음 · r1 CUST_GROUP_DTL 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1014:4) |
| WK-DMF0042-0995 | D3 | DMF0042_2_BizPlan.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-412a0479 ASIS / 원장 V-b5eb95a2 ASIS / 원장 V-45a867d9 ASIS / 원장 V-7cab4105 ASIS / 원장 V-18ad7fc4 ASIS / 원장 V-9395d93c  |  | 17 (ACT:DMF0042_2_BizPlan.EditButton:537:1 A) |
| WK-DMF0042-0996 | D3 | DMS_CUSTOMER / End Customer(Report | 하네스·환경 | D3 도구 오류 — 원장 V-bbece189 ASIS / 원장 V-d7540b20 ASIS / 원장 V-f52331b7 ASIS / 원장 V-1fa05ae0 ASIS / 실측[T-6f6fac40]: r0 DMS_CUSTOMER 그리드 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1301:108) |
| WK-DMF0042-0997 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-bbece189 / 실측[T-8fbbc94c]: r0 DMS_CUSTOMER 그리드에 없음 · r1 DMS_CUSTOMER 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1301:108) |
| WK-DMF0042-0998 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-d7540b20 / 실측[T-61efba4a]: r0 DMS_CUSTOMER 그리드에 없음 · r1 DMS_CUSTOMER 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1367:121) |
| WK-DMF0042-0999 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-f52331b7 / 실측[T-56f46f68]: r0 DMS_CUSTOMER 그리드에 없음 · r1 DMS_CUSTOMER 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1364:108) |
| WK-DMF0042-1000 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-1fa05ae0 / 실측[T-afa0d97b]: r0 DMS_CUSTOMER 그리드에 없음 · r1 DMS_CUSTOMER 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1076:1) |
| WK-DMF0042-1001 | D3 | DMS_SALES / Sold To Cust(Report | 하네스·환경 | D3 도구 오류 — 원장 V-2c8afc22 ASIS / 원장 V-35849caf ASIS / 원장 V-243b066e ASIS / 원장 V-18c12ac8 ASIS / 실측[T-3a333ba3]: r0 DMS_SALES 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1299:106) |
| WK-DMF0042-1002 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-2c8afc22 / 실측[T-45918e9e]: r0 DMS_SALES 그리드에 없음 · r1 DMS_SALES 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1299:106) |
| WK-DMF0042-1003 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-35849caf / 실측[T-1ee8b22a]: r0 DMS_SALES 그리드에 없음 · r1 DMS_SALES 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1365:119) |
| WK-DMF0042-1004 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-243b066e / 실측[T-82da5a9b]: r0 DMS_SALES 그리드에 없음 · r1 DMS_SALES 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1362:106) |
| WK-DMF0042-1005 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-18c12ac8 / 실측[T-7b4bc77f]: r0 DMS_SALES 그리드에 없음 · r1 DMS_SALES 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1074:9) |
| WK-DMF0042-1006 | D3 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 D3 355요소: ERROR:320 · PASS: |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-1007 | D3 | EDIT_FLAG / Edit Flag | 하네스·환경 | D3 도구 오류 — 원장 V-ecb223e9 ASIS / 원장 V-030af756 ASIS / 원장 V-f7804a04 ASIS / 원장 V-99adf32c ASIS / 원장 V-1f3693ef ASIS / 실측[T-2ebc9126] |  | 17 (23 InsertRow 메타 잠금 42 (#14~55) ACT:DMF00) |
| WK-DMF0042-1008 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-030af756 / 실측[T-a6945caf]: r0 EDIT_FLAG 그리드에 없음 · r1 EDIT_FLAG 그리드에 없음 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1462:34) |
| WK-DMF0042-1009 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-f7804a04 / 실측[T-87c46880]: r0 EDIT_FLAG 그리드에 없음 · r1 EDIT_FLAG 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1385:139) |
| WK-DMF0042-1010 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-99adf32c / 실측[T-836f680d]: r0 EDIT_FLAG 그리드에 없음 · r1 EDIT_FLAG 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1382:126) |
| WK-DMF0042-1011 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-1f3693ef / 실측[T-8cfab8bb]: r0 EDIT_FLAG 그리드에 없음 · r1 EDIT_FLAG 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1094:1) |
| WK-DMF0042-1012 | D3 | EDI_QTY | 하네스·환경 | D3 도구 오류 — 실측[T-3c3c6da3]: 팝업 내부 컬럼 EDI_QTY — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-1013 | D3 | Edit (F2) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Edit (F2) '등록 제외 — 상시편집 + editLock R1~R7 대체 (DMF0021 선례)' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (Edit (F2)) |
| WK-DMF0042-1014 | D3 | EditButton 잠금 8 (#6~13) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton 잠금 8 (#6~13) '좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 /' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-1015 | D3 | FCST_TYPE / FCST Type | 하네스·환경 | D3 도구 오류 — 원장 V-d0f1c254 ASIS / 원장 V-5d7ebf53 ASIS / 원장 V-c8f6840e ASIS / 원장 V-41b9e6f8 ASIS / 실측[T-867da389]: [재측정 필요] 검사 조건이 바뀐  |  | 8 (ACT:DMF0042_1_BizPlan.EditButton ACT:DMF) |
| WK-DMF0042-1016 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-d0f1c254 / 실측[T-ae5af239]: r0  → FCST_TYPE 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → FCST_TYPE 편집=false (AS-IS |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:635:35) |
| WK-DMF0042-1017 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-5d7ebf53 / 실측[T-e1a9b0a6]: r0  → FCST_TYPE 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → FCST_TYPE 편집=false (AS-IS |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:642:39) |
| WK-DMF0042-1018 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-41b9e6f8 / 실측[T-96bc3421]: r0  → FCST_TYPE 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → FCST_TYPE 편집=false (AS-IS |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:668:39) |
| WK-DMF0042-1019 | D3 | FORECAST_INFO_CELL_MODEL / Cell Model | 하네스·환경 | D3 도구 오류 — 원장 V-a8015b5a ASIS / 원장 V-cffefd2b ASIS / 원장 V-612b6b9f ASIS / 원장 V-42141938 ASIS / 실측[T-4db49889]: r0 FORECAST_INFO_CE |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1281:94 ) |
| WK-DMF0042-1020 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-a8015b5a / 실측[T-f4ad4467]: r0 FORECAST_INFO_CELL_MODEL 그리드에 없음 · r1 FORECAST_INFO_CELL_MODEL 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1281:94) |
| WK-DMF0042-1021 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-cffefd2b / 실측[T-f018bc29]: r0 FORECAST_INFO_CELL_MODEL 그리드에 없음 · r1 FORECAST_INFO_CELL_MODEL 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1347:107) |
| WK-DMF0042-1022 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-612b6b9f / 실측[T-5c2d0383]: r0 FORECAST_INFO_CELL_MODEL 그리드에 없음 · r1 FORECAST_INFO_CELL_MODEL 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1344:94) |
| WK-DMF0042-1023 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-42141938 / 실측[T-fbd32e70]: r0 FORECAST_INFO_CELL_MODEL 그리드에 없음 · r1 FORECAST_INFO_CELL_MODEL 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1056:8) |
| WK-DMF0042-1024 | D3 | FORECAST_INFO_CELL_PACK_COUNT / Cell Pac | 하네스·환경 | D3 도구 오류 — 원장 V-b1da5a43 ASIS / 원장 V-5daea270 ASIS / 원장 V-29035ddb ASIS / 원장 V-9a167a98 ASIS / 실측[T-4327d7b5]: r0 FORECAST_INFO_CE |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1267:80 ) |
| WK-DMF0042-1025 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-b1da5a43 / 실측[T-792d7f4a]: r0 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 · r1 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1267:80) |
| WK-DMF0042-1026 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-5daea270 / 실측[T-44f716fa]: r0 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 · r1 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1333:93) |
| WK-DMF0042-1027 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-29035ddb / 실측[T-a3bb750b]: r0 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 · r1 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1330:80) |
| WK-DMF0042-1028 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-9a167a98 / 실측[T-461dd5a8]: r0 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 · r1 FORECAST_INFO_CELL_PACK_COUNT 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1042:7) |
| WK-DMF0042-1029 | D3 | FORECAST_INFO_PRODUCT_GROUP / Product Gr | 하네스·환경 | D3 도구 오류 — 원장 V-a7ff7075 ASIS / 원장 V-cd28df71 ASIS / 원장 V-6e9c3a44 ASIS / 원장 V-9687ca5f ASIS / 실측[T-64b9f516]: r0 FORECAST_INFO_PR |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1265:78 ) |
| WK-DMF0042-1030 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-a7ff7075 / 실측[T-ba858223]: r0 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 · r1 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1265:78) |
| WK-DMF0042-1031 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-cd28df71 / 실측[T-98f41234]: r0 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 · r1 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1331:91) |
| WK-DMF0042-1032 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-6e9c3a44 / 실측[T-9c5008c0]: r0 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 · r1 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1328:78) |
| WK-DMF0042-1033 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-9687ca5f / 실측[T-e45b475c]: r0 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 · r1 FORECAST_INFO_PRODUCT_GROUP 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1040:7) |
| WK-DMF0042-1034 | D3 | FORECAST_INFO_SPEC / Spec & Version | 하네스·환경 | D3 도구 오류 — 원장 V-50e61286 ASIS / 원장 V-a1f7751a ASIS / 원장 V-c21d758e ASIS / 원장 V-0e00ba65 ASIS / 실측[T-454b5c87]: r0 FORECAST_INFO_SP |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1283:96 ) |
| WK-DMF0042-1035 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-50e61286 / 실측[T-3df859a2]: r0 FORECAST_INFO_SPEC 그리드에 없음 · r1 FORECAST_INFO_SPEC 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1283:96) |
| WK-DMF0042-1036 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-a1f7751a / 실측[T-d1934fc9]: r0 FORECAST_INFO_SPEC 그리드에 없음 · r1 FORECAST_INFO_SPEC 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1349:109) |
| WK-DMF0042-1037 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-c21d758e / 실측[T-1711a807]: r0 FORECAST_INFO_SPEC 그리드에 없음 · r1 FORECAST_INFO_SPEC 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1346:96) |
| WK-DMF0042-1038 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-0e00ba65 / 실측[T-75ac8828]: r0 FORECAST_INFO_SPEC 그리드에 없음 · r1 FORECAST_INFO_SPEC 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1058:8) |
| WK-DMF0042-1039 | D3 | G1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G1 "**비40/무효창 Q_/Y_ 직접입력 잠금** (구현이 개방하던 과잉 교정 — R4' 버킷" 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (G1) |
| WK-DMF0042-1040 | D3 | G2 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G2 '**구 R6 제거** — 기존행 INCO/FCST 조건 개방 블록은 신정본 L651~667' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (G2) |
| WK-DMF0042-1041 | D3 | G4 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G4 'Monthly LOC 편집 시 **Q_ 롤업 = 편집셀값 Int copy** (합산·0 아' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (G4) |
| WK-DMF0042-1042 | D3 | GAP | 하네스·환경 | D3 도구 오류 — 실측[T-165076f8]: 팝업 내부 컬럼 GAP — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-1043 | D3 | INCOTERMS / Rep. Incoterms | 하네스·환경 | D3 도구 오류 — 원장 V-44f1ee40 ASIS / 원장 V-399b852b ASIS / 원장 V-3668a3dd ASIS / 원장 V-17d057f6 ASIS / 실측[T-0a9875a6]: [재측정 필요] 검사 조건이 바뀐  |  | 10 (ACT:DMF0042_1_BizPlan.EditButton ACT:DMF) |
| WK-DMF0042-1044 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-44f1ee40 / 실측[T-12370887]: r0  → INCOTERMS 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → INCOTERMS 편집=false (AS-IS |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:634:34) |
| WK-DMF0042-1045 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-399b852b / 실측[T-3035092d]: r0  → INCOTERMS 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → INCOTERMS 편집=false (AS-IS |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:640:37) |
| WK-DMF0042-1046 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-17d057f6 / 실측[T-6ef864ac]: r0  → INCOTERMS 편집=false (AS-IS 잠금 EditButton:651) OK · r1  → INCOTERMS 편집=false (AS-IS |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:666:37) |
| WK-DMF0042-1047 | D3 | INTERNAL_YN / Internal Txn | 하네스·환경 | D3 도구 오류 — 원장 V-ed09585e ASIS / 원장 V-0631b851 ASIS / 원장 V-fc49dde8 ASIS / 원장 V-fd94ec64 ASIS / 실측[T-3c5b4975]: r0 INTERNAL_YN 그리드에 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1275:88 ) |
| WK-DMF0042-1048 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-0631b851 / 실측[T-f15c7336]: r0 INTERNAL_YN 그리드에 없음 · r1 INTERNAL_YN 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1341:101) |
| WK-DMF0042-1049 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-fc49dde8 / 실측[T-d32ee2dc]: r0 INTERNAL_YN 그리드에 없음 · r1 INTERNAL_YN 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1338:88) |
| WK-DMF0042-1050 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-fd94ec64 / 실측[T-32958988]: r0 INTERNAL_YN 그리드에 없음 · r1 INTERNAL_YN 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1050:8) |
| WK-DMF0042-1051 | D3 | ITEM_CLASS_NAME / Model Type | 하네스·환경 | D3 도구 오류 — 원장 V-8d22101b ASIS / 원장 V-c4b82561 ASIS / 원장 V-970b172c ASIS / 원장 V-782bc8b5 ASIS / 실측[T-8bdf0e5a]: r0 ITEM_CLASS_NAME  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1250:65 ) |
| WK-DMF0042-1052 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8d22101b / 실측[T-f2980ce7]: r0 ITEM_CLASS_NAME 그리드에 없음 · r1 ITEM_CLASS_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1250:65) |
| WK-DMF0042-1053 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c4b82561 / 실측[T-90ca1ed5]: r0 ITEM_CLASS_NAME 그리드에 없음 · r1 ITEM_CLASS_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1295:63) |
| WK-DMF0042-1054 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-970b172c / 실측[T-ee21fae7]: r0 ITEM_CLASS_NAME 그리드에 없음 · r1 ITEM_CLASS_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1313:65) |
| WK-DMF0042-1055 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-782bc8b5 / 실측[T-72ee59bc]: r0 ITEM_CLASS_NAME 그리드에 없음 · r1 ITEM_CLASS_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1028:5) |
| WK-DMF0042-1056 | D3 | ITEM_NAME / Model Name | 하네스·환경 | D3 도구 오류 — 원장 V-2a15cc0b ASIS / 원장 V-e1b4fd41 ASIS / 원장 V-235329a4 ASIS / 원장 V-0bc20709 ASIS / 실측[T-5c88b5b2]: r0 ITEM_NAME 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1252:67 ) |
| WK-DMF0042-1057 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2a15cc0b / 실측[T-38490826]: r0 ITEM_NAME 그리드에 없음 · r1 ITEM_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1252:67) |
| WK-DMF0042-1058 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-e1b4fd41 / 실측[T-294a4168]: r0 ITEM_NAME 그리드에 없음 · r1 ITEM_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1297:65) |
| WK-DMF0042-1059 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-0bc20709 / 실측[T-c7c2a370]: r0 ITEM_NAME 그리드에 없음 · r1 ITEM_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1030:6) |
| WK-DMF0042-1060 | D3 | ITEM_TYPE / Item Type | 하네스·환경 | D3 도구 오류 — 원장 V-9f5f35bf ASIS / 원장 V-bcef4902 ASIS / 원장 V-eeca69ad ASIS / 원장 V-7a4bea94 ASIS / 실측[T-4f6d9edf]: r0 ITEM_TYPE 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1254:69 ) |
| WK-DMF0042-1061 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-9f5f35bf / 실측[T-1a0c885c]: r0 ITEM_TYPE 그리드에 없음 · r1 ITEM_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1254:69) |
| WK-DMF0042-1062 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-bcef4902 / 실측[T-1672f55e]: r0 ITEM_TYPE 그리드에 없음 · r1 ITEM_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1299:67) |
| WK-DMF0042-1063 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-7a4bea94 / 실측[T-0f5be2d8]: r0 ITEM_TYPE 그리드에 없음 · r1 ITEM_TYPE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1032:6) |
| WK-DMF0042-1064 | D3 | KWH | 하네스·환경 | D3 도구 오류 — 실측[T-b10e7121]: 팝업 내부 컬럼 KWH — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1307:73) |
| WK-DMF0042-1065 | D3 | KWH,KWH | 하네스·환경 | D3 도구 오류 — 원장 V-0099668d / 실측[T-c98c4b04]: KWH: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1307:73) |
| WK-DMF0042-1066 | D3 | MDM_PROJECT_NAME / Project Name | 하네스·환경 | D3 도구 오류 — 원장 V-3d0894f1 ASIS / 원장 V-c44471f2 ASIS / 원장 V-8052d91a ASIS / 원장 V-a8b2ddf3 ASIS / 실측[T-bcc43bca]: r0 MDM_PROJECT_NAME |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1285:98 ) |
| WK-DMF0042-1067 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3d0894f1 / 실측[T-a509b50f]: r0 MDM_PROJECT_NAME 그리드에 없음 · r1 MDM_PROJECT_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1285:98) |
| WK-DMF0042-1068 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c44471f2 / 실측[T-ad971628]: r0 MDM_PROJECT_NAME 그리드에 없음 · r1 MDM_PROJECT_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1351:111) |
| WK-DMF0042-1069 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8052d91a / 실측[T-437cf118]: r0 MDM_PROJECT_NAME 그리드에 없음 · r1 MDM_PROJECT_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1348:98) |
| WK-DMF0042-1070 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a8b2ddf3 / 실측[T-8621cc37]: r0 MDM_PROJECT_NAME 그리드에 없음 · r1 MDM_PROJECT_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1060:9) |
| WK-DMF0042-1071 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-a0155f8f / 실측[T-edcb0cc0]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:625:32) |
| WK-DMF0042-1072 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-e90bf7ea / 실측[T-bc25bd85]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:664:46) |
| WK-DMF0042-1073 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-84cd4e69 / 실측[T-c2600864]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:670:48) |
| WK-DMF0042-1074 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-351944d8 / 실측[T-101741b8]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1336:136) |
| WK-DMF0042-1075 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-ba862c36 / 실측[T-88f4ff14]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9a03b335 ≠ 현재 7c69df3e) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:589:24) |
| WK-DMF0042-1076 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-3fbfc321 / 실측[T-09181387]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9a03b335 ≠ 현재 7c69df3e) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:627:32) |
| WK-DMF0042-1077 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-7a695f0e / 실측[T-144ee1b8]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9a03b335 ≠ 현재 7c69df3e) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:633:34) |
| WK-DMF0042-1078 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-751c9e1c / 실측[T-c4a2bf8a]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 9a03b335 ≠ 현재 7c69df3e) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1472:40) |
| WK-DMF0042-1079 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-c1a64ecd / 실측[T-4ee2cc87]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:651:32) |
| WK-DMF0042-1080 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-724297c9 / 실측[T-dc8e9853]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:690:46) |
| WK-DMF0042-1081 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-4f782b7a / 실측[T-a04f8d64]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:696:48) |
| WK-DMF0042-1082 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-714a9f09 / 실측[T-e3bdd8cb]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1400:149) |
| WK-DMF0042-1083 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-5b71d96f / 실측[T-28c32838]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan.EditButton:649:29) |
| WK-DMF0042-1084 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-89038ff4 / 실측[T-deb42344]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan.EditButton:688:36) |
| WK-DMF0042-1085 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-faea4617 / 실측[T-dda83ea2]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan.EditButton:694:38) |
| WK-DMF0042-1086 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-2cba6272 / 실측[T-1c18448a]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1399:136) |
| WK-DMF0042-1087 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-0fdedc9b / 실측[T-a2302f1c]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:548:2) |
| WK-DMF0042-1088 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-177dc1f8 / 실측[T-4870d81a]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 538a0010 ≠ 현재 d631bb1f) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1105:1) |
| WK-DMF0042-1089 | D3 | MEASURE / Measure | 하네스·환경 | D3 도구 오류 — 원장 V-a0155f8f ASIS / 원장 V-e90bf7ea ASIS / 원장 V-84cd4e69 ASIS / 원장 V-2c915447 ASIS / 원장 V-351944d8 ASIS / 원장 V-b2f12416  |  | 53 (InsertRow Measure/수량 잠금 11 (#56~66) ACT:) |
| WK-DMF0042-1090 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-2c915447 / 실측[T-23b45ed6]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 5d27124b ≠ 현재 7ff95051) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1329:133) |
| WK-DMF0042-1091 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-a2177e2d / 실측[T-ebb0d065]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 0e2856d0 ≠ 현재 9f1a21c4) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1467:37) |
| WK-DMF0042-1092 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-d5b6ec2d / 실측[T-9d8cbb6a]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 5d27124b ≠ 현재 7ff95051) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1395:146) |
| WK-DMF0042-1093 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-39a1c0c6 / 실측[T-335523c6]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 5d27124b ≠ 현재 7ff95051) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1392:133) |
| WK-DMF0042-1094 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-c9a77af4 / 실측[T-94080b54]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 5d27124b ≠ 현재 7ff95051) — 이전 판정 PASS 보류: r0   |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1099:1) |
| WK-DMF0042-1095 | D3 | MIN_CAPACITY / Min Capacity | 하네스·환경 | D3 도구 오류 — 원장 V-e1c9e21d ASIS / 원장 V-ed14de64 ASIS / 원장 V-15665443 ASIS / 원장 V-41fb6514 ASIS / 실측[T-e77e4b1b]: r0 MIN_CAPACITY 그리드 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1287:100) |
| WK-DMF0042-1096 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-e1c9e21d / 실측[T-ecbd3814]: r0 MIN_CAPACITY 그리드에 없음 · r1 MIN_CAPACITY 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1287:100) |
| WK-DMF0042-1097 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-ed14de64 / 실측[T-9ced59e4]: r0 MIN_CAPACITY 그리드에 없음 · r1 MIN_CAPACITY 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1353:113) |
| WK-DMF0042-1098 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-15665443 / 실측[T-90cf8925]: r0 MIN_CAPACITY 그리드에 없음 · r1 MIN_CAPACITY 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1350:100) |
| WK-DMF0042-1099 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-41fb6514 / 실측[T-ec851959]: r0 MIN_CAPACITY 그리드에 없음 · r1 MIN_CAPACITY 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1062:9) |
| WK-DMF0042-1100 | D3 | MKT_FCST | 하네스·환경 | D3 도구 오류 — 실측[T-ec19fb1f]: 팝업 내부 컬럼 MKT_FCST — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-1101 | D3 | MODULE_PER_CAR / Module/Car | 하네스·환경 | D3 도구 오류 — 원장 V-28c4c136 ASIS / 원장 V-4cb7603b ASIS / 원장 V-09d17701 ASIS / 실측[T-3998e648]: r0 MODULE_PER_CAR 그리드에 없음 · r1 MODULE_PE |  | 4 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-1102 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-28c4c136 / 실측[T-d9dac50d]: r0 MODULE_PER_CAR 그리드에 없음 · r1 MODULE_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1325:130) |
| WK-DMF0042-1103 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-4cb7603b / 실측[T-69598697]: r0 MODULE_PER_CAR 그리드에 없음 · r1 MODULE_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1391:143) |
| WK-DMF0042-1104 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-09d17701 / 실측[T-338abc5b]: r0 MODULE_PER_CAR 그리드에 없음 · r1 MODULE_PER_CAR 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1388:130) |
| WK-DMF0042-1105 | D3 | NICK_NAME / Nick Name | 하네스·환경 | D3 도구 오류 — 원장 V-05cc7b00 ASIS / 원장 V-c26cf45f ASIS / 원장 V-b3ff4396 ASIS / 원장 V-5189ca5e ASIS / 실측[T-0a7dd87e]: r0 NICK_NAME 그리드에 없 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1256:71 ) |
| WK-DMF0042-1106 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-05cc7b00 / 실측[T-a08812da]: r0 NICK_NAME 그리드에 없음 · r1 NICK_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1256:71) |
| WK-DMF0042-1107 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c26cf45f / 실측[T-d0f377c8]: r0 NICK_NAME 그리드에 없음 · r1 NICK_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1301:69) |
| WK-DMF0042-1108 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-5189ca5e / 실측[T-83c1e144]: r0 NICK_NAME 그리드에 없음 · r1 NICK_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1034:6) |
| WK-DMF0042-1109 | D3 | OWNER / Owner | 하네스·환경 | D3 도구 오류 — 원장 V-9f6dc653 ASIS / 원장 V-785bc64d ASIS / 원장 V-20671d62 ASIS / 원장 V-f9310ca8 ASIS / 실측[T-4cb05227]: r0 OWNER 그리드에 없음 ·  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1238:55 ) |
| WK-DMF0042-1110 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-9f6dc653 / 실측[T-160642aa]: r0 OWNER 그리드에 없음 · r1 OWNER 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1238:55) |
| WK-DMF0042-1111 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-785bc64d / 실측[T-f71dccca]: r0 OWNER 그리드에 없음 · r1 OWNER 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1283:53) |
| WK-DMF0042-1112 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-20671d62 / 실측[T-5c7c1eea]: r0 OWNER 그리드에 없음 · r1 OWNER 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1301:55) |
| WK-DMF0042-1113 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-f9310ca8 / 실측[T-065bc843]: r0 OWNER 그리드에 없음 · r1 OWNER 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1016:4) |
| WK-DMF0042-1114 | D3 | PLANT_SITE_ID / Plant Site | 하네스·환경 | D3 도구 오류 — 원장 V-cb187025 ASIS / 원장 V-df6ad4cd ASIS / 원장 V-d86bfeaf ASIS / 원장 V-a1af73f4 ASIS / 실측[T-de5eda4c]: r0 PLANT_SITE_ID 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1260:74 ) |
| WK-DMF0042-1115 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-cb187025 / 실측[T-f0de8ff5]: r0 PLANT_SITE_ID 그리드에 없음 · r1 PLANT_SITE_ID 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1260:74) |
| WK-DMF0042-1116 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-d86bfeaf / 실측[T-7e370346]: r0 PLANT_SITE_ID 그리드에 없음 · r1 PLANT_SITE_ID 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1323:74) |
| WK-DMF0042-1117 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a1af73f4 / 실측[T-69376a8d]: r0 PLANT_SITE_ID 그리드에 없음 · r1 PLANT_SITE_ID 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1036:6) |
| WK-DMF0042-1118 | D3 | PRIORITY / Priority | 하네스·환경 | D3 도구 오류 — 원장 V-c9d3ede6 ASIS / 원장 V-e42a1dc7 ASIS / 원장 V-b593741e ASIS / 원장 V-4ab3656e ASIS / 실측[T-1830ffe6]: r0 PRIORITY 그리드에 없음 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1297:104) |
| WK-DMF0042-1119 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-c9d3ede6 / 실측[T-a76e89cb]: r0 PRIORITY 그리드에 없음 · r1 PRIORITY 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1297:104) |
| WK-DMF0042-1120 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-e42a1dc7 / 실측[T-863b698c]: r0 PRIORITY 그리드에 없음 · r1 PRIORITY 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1363:117) |
| WK-DMF0042-1121 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-b593741e / 실측[T-93bb6d88]: r0 PRIORITY 그리드에 없음 · r1 PRIORITY 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1360:104) |
| WK-DMF0042-1122 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-4ab3656e / 실측[T-f58baf27]: r0 PRIORITY 그리드에 없음 · r1 PRIORITY 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1072:9) |
| WK-DMF0042-1123 | D3 | PRODUCT_GROUP_NAME / Product Group Name | 하네스·환경 | D3 도구 오류 — 원장 V-3d74f8e5 ASIS / 원장 V-3696216c ASIS / 원장 V-653bb94f ASIS / 원장 V-bfb38f64 ASIS / 실측[T-2ca5c56e]: r0 PRODUCT_GROUP_NA |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1269:82 ) |
| WK-DMF0042-1124 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3d74f8e5 / 실측[T-f36cbe42]: r0 PRODUCT_GROUP_NAME 그리드에 없음 · r1 PRODUCT_GROUP_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1269:82) |
| WK-DMF0042-1125 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3696216c / 실측[T-7f201878]: r0 PRODUCT_GROUP_NAME 그리드에 없음 · r1 PRODUCT_GROUP_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1335:95) |
| WK-DMF0042-1126 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-653bb94f / 실측[T-d7acc073]: r0 PRODUCT_GROUP_NAME 그리드에 없음 · r1 PRODUCT_GROUP_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1332:82) |
| WK-DMF0042-1127 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-bfb38f64 / 실측[T-26fb0637]: r0 PRODUCT_GROUP_NAME 그리드에 없음 · r1 PRODUCT_GROUP_NAME 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1044:7) |
| WK-DMF0042-1128 | D3 | PROJECT_CODE / Project Code | 하네스·환경 | D3 도구 오류 — 원장 V-a6c1f595 ASIS / 원장 V-989e15cf ASIS / 원장 V-3a364fa4 ASIS / 원장 V-35c0b257 ASIS / 원장 V-83df1cdf ASIS / 실측[T-ff8d932d] |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1230:49 ) |
| WK-DMF0042-1129 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-a6c1f595 / 실측[T-7e7b1910]: r0 PROJECT_CODE 그리드에 없음 · r1 PROJECT_CODE 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1230:49) |
| WK-DMF0042-1130 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-989e15cf / 실측[T-7bc3c099]: r0 PROJECT_CODE 그리드에 없음 · r1 PROJECT_CODE 그리드에 없음 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1373:32) |
| WK-DMF0042-1131 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-35c0b257 / 실측[T-27b80e0b]: r0 PROJECT_CODE 그리드에 없음 · r1 PROJECT_CODE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1293:49) |
| WK-DMF0042-1132 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-83df1cdf / 실측[T-7f1bbd94]: r0 PROJECT_CODE 그리드에 없음 · r1 PROJECT_CODE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1008:4) |
| WK-DMF0042-1133 | D3 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | D3 도구 오류 — 원장 V-26387f91 ASIS / 원장 V-f191bccd ASIS / 원장 V-3a2d9c41 ASIS / 원장 V-3184e58e ASIS / 실측[T-a5804d7f]: r0 REPORT_GROUP1 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1303:110) |
| WK-DMF0042-1134 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-26387f91 / 실측[T-cac37b49]: r0 REPORT_GROUP1 그리드에 없음 · r1 REPORT_GROUP1 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1303:110) |
| WK-DMF0042-1135 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-f191bccd / 실측[T-3f874674]: r0 REPORT_GROUP1 그리드에 없음 · r1 REPORT_GROUP1 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1369:123) |
| WK-DMF0042-1136 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-3a2d9c41 / 실측[T-606f0a2f]: r0 REPORT_GROUP1 그리드에 없음 · r1 REPORT_GROUP1 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1366:110) |
| WK-DMF0042-1137 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-3184e58e / 실측[T-736e8597]: r0 REPORT_GROUP1 그리드에 없음 · r1 REPORT_GROUP1 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1078:1) |
| WK-DMF0042-1138 | D3 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | D3 도구 오류 — 원장 V-009626f1 ASIS / 원장 V-2def49d9 ASIS / 원장 V-627a5b35 ASIS / 원장 V-ff9466de ASIS / 실측[T-84f0ddfe]: r0 REPORT_GROUP2 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1305:112) |
| WK-DMF0042-1139 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-009626f1 / 실측[T-56809876]: r0 REPORT_GROUP2 그리드에 없음 · r1 REPORT_GROUP2 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1305:112) |
| WK-DMF0042-1140 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-2def49d9 / 실측[T-671fa93a]: r0 REPORT_GROUP2 그리드에 없음 · r1 REPORT_GROUP2 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1371:125) |
| WK-DMF0042-1141 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-627a5b35 / 실측[T-6e6ff791]: r0 REPORT_GROUP2 그리드에 없음 · r1 REPORT_GROUP2 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1368:112) |
| WK-DMF0042-1142 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-ff9466de / 실측[T-01bd6043]: r0 REPORT_GROUP2 그리드에 없음 · r1 REPORT_GROUP2 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1080:1) |
| WK-DMF0042-1143 | D3 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-acee7688 ASIS / 원장 V-0c7d515b ASIS / 원장 V-2a129cf7 ASIS / 원장 V-dd7349fe ASIS / 실측[T-19db93f2]: r0 REPORT_GROUP3 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1307:114) |
| WK-DMF0042-1144 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-acee7688 / 실측[T-58230675]: r0 REPORT_GROUP3 그리드에 없음 · r1 REPORT_GROUP3 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1307:114) |
| WK-DMF0042-1145 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-0c7d515b / 실측[T-4ed921d5]: r0 REPORT_GROUP3 그리드에 없음 · r1 REPORT_GROUP3 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1373:127) |
| WK-DMF0042-1146 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-2a129cf7 / 실측[T-0b1fd755]: r0 REPORT_GROUP3 그리드에 없음 · r1 REPORT_GROUP3 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1370:114) |
| WK-DMF0042-1147 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-dd7349fe / 실측[T-5a7a7592]: r0 REPORT_GROUP3 그리드에 없음 · r1 REPORT_GROUP3 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1082:1) |
| WK-DMF0042-1148 | D3 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-83f1c624 ASIS / 원장 V-964cfe20 ASIS / 원장 V-8b902401 ASIS / 원장 V-c8fd9b5c ASIS / 실측[T-871d80e5]: r0 REPORT_GROUP4 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1309:116) |
| WK-DMF0042-1149 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-83f1c624 / 실측[T-10d742a7]: r0 REPORT_GROUP4 그리드에 없음 · r1 REPORT_GROUP4 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1309:116) |
| WK-DMF0042-1150 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-964cfe20 / 실측[T-458db195]: r0 REPORT_GROUP4 그리드에 없음 · r1 REPORT_GROUP4 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1375:129) |
| WK-DMF0042-1151 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-8b902401 / 실측[T-8c4808a7]: r0 REPORT_GROUP4 그리드에 없음 · r1 REPORT_GROUP4 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1372:116) |
| WK-DMF0042-1152 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-c8fd9b5c / 실측[T-54119c62]: r0 REPORT_GROUP4 그리드에 없음 · r1 REPORT_GROUP4 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1084:1) |
| WK-DMF0042-1153 | D3 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스·환경 | D3 도구 오류 — 원장 V-ca8d2269 ASIS / 원장 V-71d9b608 ASIS / 원장 V-89d56c4a ASIS / 원장 V-1f3c1331 ASIS / 실측[T-b83bd83d]: REPORT_GROUP5: AS-I |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1311:118) |
| WK-DMF0042-1154 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-ca8d2269 / 실측[T-d102c347]: REPORT_GROUP5: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1311:118) |
| WK-DMF0042-1155 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-71d9b608 / 실측[T-1090376b]: REPORT_GROUP5: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1377:131) |
| WK-DMF0042-1156 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-89d56c4a / 실측[T-a4eb21ce]: REPORT_GROUP5: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1374:118) |
| WK-DMF0042-1157 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-1f3c1331 / 실측[T-08d91d71]: REPORT_GROUP5: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1086:1) |
| WK-DMF0042-1158 | D3 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | D3 도구 오류 — 원장 V-e3aad76c ASIS / 원장 V-ad5123e2 ASIS / 원장 V-0df6c30a ASIS / 원장 V-0f94ad4e ASIS / 실측[T-64b6949c]: r0 REPORT_GROUP6 그리 |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1313:120) |
| WK-DMF0042-1159 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-e3aad76c / 실측[T-3b425e72]: r0 REPORT_GROUP6 그리드에 없음 · r1 REPORT_GROUP6 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1313:120) |
| WK-DMF0042-1160 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-ad5123e2 / 실측[T-4bc65e78]: r0 REPORT_GROUP6 그리드에 없음 · r1 REPORT_GROUP6 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1379:133) |
| WK-DMF0042-1161 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-0df6c30a / 실측[T-298ec1d4]: r0 REPORT_GROUP6 그리드에 없음 · r1 REPORT_GROUP6 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1376:120) |
| WK-DMF0042-1162 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-0f94ad4e / 실측[T-0ff70cc9]: r0 REPORT_GROUP6 그리드에 없음 · r1 REPORT_GROUP6 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1088:1) |
| WK-DMF0042-1163 | D3 | REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 실측[T-3fe3ea73]: 팝업 내부 컬럼 REPORT_GROUP7 — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1315:122) |
| WK-DMF0042-1164 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-dafde4cc / 실측[T-3e1556ff]: REPORT_GROUP7: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1381:135) |
| WK-DMF0042-1165 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-f064c63e / 실측[T-e55b9edb]: REPORT_GROUP7: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1378:122) |
| WK-DMF0042-1166 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-570efe83 / 실측[T-15647a5e]: REPORT_GROUP7: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1090:1) |
| WK-DMF0042-1167 | D3 | REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 실측[T-96b1a679]: 팝업 내부 컬럼 REPORT_GROUP8 — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-1168 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-9cdb17e7 / 실측[T-5f39251c]: REPORT_GROUP8: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1383:137) |
| WK-DMF0042-1169 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-6d987603 / 실측[T-71b26ee5]: REPORT_GROUP8: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1380:124) |
| WK-DMF0042-1170 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-ca2a7a46 / 실측[T-63bc0d6c]: REPORT_GROUP8: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1092:1) |
| WK-DMF0042-1171 | D3 | RESULT | 하네스·환경 | D3 도구 오류 — 실측[T-423b2d78]: 팝업 내부 컬럼 RESULT — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-1172 | D3 | ROUTE / Route | 하네스·환경 | D3 도구 오류 — 원장 V-6d5663da ASIS / 원장 V-4bf17a94 ASIS / 원장 V-fe8e9952 ASIS / 원장 V-209dc917 ASIS / 실측[T-ecf3b994]: r0 ROUTE 그리드에 없음 ·  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1242:59 ) |
| WK-DMF0042-1173 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-6d5663da / 실측[T-da40b0b8]: r0 ROUTE 그리드에 없음 · r1 ROUTE 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1242:59) |
| WK-DMF0042-1174 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-4bf17a94 / 실측[T-187de213]: r0 ROUTE 그리드에 없음 · r1 ROUTE 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1287:57) |
| WK-DMF0042-1175 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-fe8e9952 / 실측[T-223304d5]: r0 ROUTE 그리드에 없음 · r1 ROUTE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1305:59) |
| WK-DMF0042-1176 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-209dc917 / 실측[T-a95ce591]: r0 ROUTE 그리드에 없음 · r1 ROUTE 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1020:5) |
| WK-DMF0042-1177 | D3 | SHIPTO_DESCRIPTION / Ship To Description | 하네스·환경 | D3 도구 오류 — 원장 V-67dd5ea3 ASIS / 원장 V-de09a2ea ASIS / 원장 V-fec48d73 ASIS / 원장 V-dd6c8aab ASIS / 실측[T-88c599e0]: r0 SHIPTO_DESCRIPTI |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1271:84 ) |
| WK-DMF0042-1178 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-67dd5ea3 / 실측[T-e3b162b5]: r0 SHIPTO_DESCRIPTION 그리드에 없음 · r1 SHIPTO_DESCRIPTION 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1271:84) |
| WK-DMF0042-1179 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-de09a2ea / 실측[T-804d85d0]: r0 SHIPTO_DESCRIPTION 그리드에 없음 · r1 SHIPTO_DESCRIPTION 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1337:97) |
| WK-DMF0042-1180 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-fec48d73 / 실측[T-07025cee]: r0 SHIPTO_DESCRIPTION 그리드에 없음 · r1 SHIPTO_DESCRIPTION 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1334:84) |
| WK-DMF0042-1181 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-dd6c8aab / 실측[T-7725e18f]: r0 SHIPTO_DESCRIPTION 그리드에 없음 · r1 SHIPTO_DESCRIPTION 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1046:7) |
| WK-DMF0042-1182 | D3 | SUM 헤더 5 (#1~5) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 SUM 헤더 5 (#1~5) 'SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기' 의 D3 355요소: ERROR:320 · PASS:35 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-1183 | D3 | VERSION_NO / Version | 하네스·환경 | D3 도구 오류 — 원장 V-e8878792 ASIS / 원장 V-8ab94674 ASIS / 원장 V-4c527254 ASIS / 원장 V-76947a02 ASIS / 실측[T-883b94ae]: r0 VERSION_NO 그리드에  |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1263:76 ) |
| WK-DMF0042-1184 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-e8878792 / 실측[T-803bbe72]: r0 VERSION_NO 그리드에 없음 · r1 VERSION_NO 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1263:76) |
| WK-DMF0042-1185 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-8ab94674 / 실측[T-99736c97]: r0 VERSION_NO 그리드에 없음 · r1 VERSION_NO 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1329:89) |
| WK-DMF0042-1186 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-76947a02 / 실측[T-baf4455d]: r0 VERSION_NO 그리드에 없음 · r1 VERSION_NO 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1038:6) |
| WK-DMF0042-1187 | D3 | VMI_YN / VMI | 하네스·환경 | D3 도구 오류 — 원장 V-1f73066c ASIS / 원장 V-43855815 ASIS / 원장 V-9dbc3120 ASIS / 원장 V-57f8e51f ASIS / 실측[T-841f7d1b]: r0 VMI_YN 그리드에 없음 · |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1289:102) |
| WK-DMF0042-1188 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-1f73066c / 실측[T-8be5b6a0]: r0 VMI_YN 그리드에 없음 · r1 VMI_YN 그리드에 없음 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1289:102) |
| WK-DMF0042-1189 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-43855815 / 실측[T-967decfa]: r0 VMI_YN 그리드에 없음 · r1 VMI_YN 그리드에 없음 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1355:115) |
| WK-DMF0042-1190 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-9dbc3120 / 실측[T-1c0a294e]: r0 VMI_YN 그리드에 없음 · r1 VMI_YN 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1352:102) |
| WK-DMF0042-1191 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-57f8e51f / 실측[T-b7fe7f32]: r0 VMI_YN 그리드에 없음 · r1 VMI_YN 그리드에 없음 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1064:9) |
| WK-DMF0042-1192 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e326549b / 실측[T-68894fb2]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:561:11) |
| WK-DMF0042-1193 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-6034d283 / 실측[T-e36c2cb9]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:569:14) |
| WK-DMF0042-1194 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-363e14bc / 실측[T-bad7c2d7]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:577:17) |
| WK-DMF0042-1195 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-fab6bc61 / 실측[T-17c7c425]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:585:20) |
| WK-DMF0042-1196 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-92a7fbc9 / 실측[T-0c7e1b96]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:590:21) |
| WK-DMF0042-1197 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-77a5a56b / 실측[T-7225ada7]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:597:24) |
| WK-DMF0042-1198 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ffa97ddf / 실측[T-b96152cd]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:605:27) |
| WK-DMF0042-1199 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-02c37671 / 실측[T-4f12fcd4]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:610:28) |
| WK-DMF0042-1200 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-af42cc69 / 실측[T-bb718cd9]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:129) |
| WK-DMF0042-1201 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-770aab80 / 실측[T-e2c1d284]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-1202 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-b5eb95a2 / 실측[T-d7304470]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:557:11) |
| WK-DMF0042-1203 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-45a867d9 / 실측[T-b9c25b1d]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:563:15) |
| WK-DMF0042-1204 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-7cab4105 / 실측[T-2b214540]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:566:16) |
| WK-DMF0042-1205 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-18ad7fc4 / 실측[T-f588604e]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:572:19) |
| WK-DMF0042-1206 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-9395d93c / 실측[T-13b805f5]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:575:20) |
| WK-DMF0042-1207 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-1877323e / 실측[T-0ca42acf]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:587:11) |
| WK-DMF0042-1208 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f5ef5906 / 실측[T-ed2fbecf]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:595:14) |
| WK-DMF0042-1209 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-35b9641a / 실측[T-797d4672]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:603:17) |
| WK-DMF0042-1210 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a43d2526 / 실측[T-158d82f7]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:611:20) |
| WK-DMF0042-1211 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ecd9625c / 실측[T-00d4a0b1]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:616:21) |
| WK-DMF0042-1212 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-8cb9df36 / 실측[T-dfb2bc1b]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:623:24) |
| WK-DMF0042-1213 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-3d7ded35 / 실측[T-002a52c5]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:631:27) |
| WK-DMF0042-1214 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-462f92ad / 실측[T-d3cc2ecc]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:636:28) |
| WK-DMF0042-1215 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f7af37e1 / 실측[T-05afad88]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:585:8) |
| WK-DMF0042-1216 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d327cc68 / 실측[T-cc14475d]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:593:11) |
| WK-DMF0042-1217 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-504cddb6 / 실측[T-79d4a990]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:601:14) |
| WK-DMF0042-1218 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-c15b5f82 / 실측[T-04dd4a33]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:609:17) |
| WK-DMF0042-1219 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-67544cbf / 실측[T-0b2475b6]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:614:18) |
| WK-DMF0042-1220 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f54ca620 / 실측[T-3b492b01]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:621:21) |
| WK-DMF0042-1221 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ff842882 / 실측[T-fbded8d7]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:629:24) |
| WK-DMF0042-1222 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-cd2ca248 / 실측[T-403a2e41]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:634:25) |
| WK-DMF0042-1223 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ea268706 / 실측[T-497ea9b6]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:530:1) |
| WK-DMF0042-1224 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-c490a7a9 / 실측[T-ba613147]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:535:1) |
| WK-DMF0042-1225 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ca712f4a / 실측[T-395b2912]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:540:1) |
| WK-DMF0042-1226 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a8a42c6a / 실측[T-4dc77227]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:656:45) |
| WK-DMF0042-1227 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b869716e / 실측[T-07469d91]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1346:140) |
| WK-DMF0042-1228 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-0cefb37e / 실측[T-ccbae93b]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1354:143) |
| WK-DMF0042-1229 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-94b41182 / 실측[T-0279354d]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1362:146) |
| WK-DMF0042-1230 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d2a94b62 / 실측[T-17c8c7dc]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1370:149) |
| WK-DMF0042-1231 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a7668366 / 실측[T-a1aff0f0]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1375:150) |
| WK-DMF0042-1232 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-341fe976 / 실측[T-b4d4df64]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1382:153) |
| WK-DMF0042-1233 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-e1f381b3 / 실측[T-75de2e37]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1390:156) |
| WK-DMF0042-1234 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-10275333 / 실측[T-f1fd46f6]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1395:157) |
| WK-DMF0042-1235 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b2f12416 / 실측[T-8b900530]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1406:162) |
| WK-DMF0042-1236 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-22b95950 / 실측[T-10d3e351]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:605:31) |
| WK-DMF0042-1237 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d0c9b7a4 / 실측[T-10211fdd]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1482:44) |
| WK-DMF0042-1238 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-8b4b3e70 / 실측[T-95b510a1]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1488:47) |
| WK-DMF0042-1239 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a7705144 / 실측[T-91cef592]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1493:48) |
| WK-DMF0042-1240 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6b30d62b / 실측[T-8e33fb17]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1500:51) |
| WK-DMF0042-1241 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-362e38a7 / 실측[T-7a28f2cd]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1505:52) |
| WK-DMF0042-1242 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-60014812 / 실측[T-6c7a9df6]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1518:58) |
| WK-DMF0042-1243 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-8c87cf7f / 실측[T-19430da1]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:682:45) |
| WK-DMF0042-1244 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-74f78bd1 / 실측[T-0bf1d98f]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1410:153) |
| WK-DMF0042-1245 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d30e9cb3 / 실측[T-59778f6e]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1418:156) |
| WK-DMF0042-1246 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a0084413 / 실측[T-6e0887b9]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1426:159) |
| WK-DMF0042-1247 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a622a2a8 / 실측[T-e70fce9d]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1434:162) |
| WK-DMF0042-1248 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a5a16a23 / 실측[T-1bbfc721]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1439:163) |
| WK-DMF0042-1249 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b76a9bf9 / 실측[T-8c4ff3f0]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1446:166) |
| WK-DMF0042-1250 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-66fb1927 / 실측[T-1a769e77]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1454:169) |
| WK-DMF0042-1251 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-c48d01f8 / 실측[T-19799537]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1459:170) |
| WK-DMF0042-1252 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-61b90dcd / 실측[T-077b4405]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1470:175) |
| WK-DMF0042-1253 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5b798614 / 실측[T-888d0c75]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.EditButton:680:35) |
| WK-DMF0042-1254 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-7355779d / 실측[T-21dd3f94]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1409:140) |
| WK-DMF0042-1255 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5d8eb272 / 실측[T-9b04d507]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1417:143) |
| WK-DMF0042-1256 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a9a92c1e / 실측[T-9fb49e04]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1425:146) |
| WK-DMF0042-1257 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-910b4706 / 실측[T-227f39c8]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1433:149) |
| WK-DMF0042-1258 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6f4157d9 / 실측[T-8da80a80]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1438:150) |
| WK-DMF0042-1259 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-349ba015 / 실측[T-c073d2f2]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1445:153) |
| WK-DMF0042-1260 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-31ba5170 / 실측[T-c98b5e19]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1453:156) |
| WK-DMF0042-1261 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-26b2f700 / 실측[T-03425c29]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1458:157) |
| WK-DMF0042-1262 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5eea7981 / 실측[T-9ca54592]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1469:162) |
| WK-DMF0042-1263 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-c91585f3 / 실측[T-4f1e073e]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:560:2) |
| WK-DMF0042-1264 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6131c08d / 실측[T-a032facb]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:567:2) |
| WK-DMF0042-1265 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b317b3cb / 실측[T-02c9cb2e]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1115:1) |
| WK-DMF0042-1266 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-514d937b / 실측[T-b32fb436]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1121:1) |
| WK-DMF0042-1267 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-fe3265fe / 실측[T-d23e43d1]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1127:1) |
| WK-DMF0042-1268 | D3 | 버튼 가드 6 (#42/43/45/97~99) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 D3 355요소: ERROR:320 · PASS: |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-1269 | D4 | 21 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 D4 3요소: ERROR:2 · PASS:1 |  | 1 (21) |
| WK-DMF0042-1270 | D4 | FCST_TYPE / FCST Type | 하네스·환경 | D4 도구 오류 — 실측[T-212a5359]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 f6bdd754 ≠ 현재 d3cca89c) — 이전 판정 PASS 보류: 신규행 FCST_TYPE='' — A |  | 1 (G8) |
| WK-DMF0042-1271 | D4 | INCOTERMS / Rep. Incoterms | 하네스·환경 | D4 도구 오류 — 실측[T-af492ecc]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 f712e7a2 ≠ 현재 0a927829) — 이전 판정 PASS 보류: 신규행 INCOTERMS='' — A |  | 1 (G8) |
| WK-DMF0042-1272 | D4 | Insert (F8) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Insert (F8) 'hotkeyConfig.insert → handleInsert (Measure 블록 삽입 ' 의 D4 3요소: ERROR:2 · PASS:1 |  | 1 (Insert (F8)) |
| WK-DMF0042-1273 | D5 | CURRENCY_UNITCURRENCY | 하네스·환경 | D5 도구 오류 — 실측[T-0a678bbb]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1274 | D5 | DIVISION_ID / Division | 하네스·환경 | D5 도구 오류 — 실측[T-3b2bdc77]: DIVISION_ID: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [40] 을  |  | 5 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-1275 | D5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 D5 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1276 | D5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 D5 5요소: NA:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-1277 | D5 | MEASURE / Measure | 하네스·환경 | D5 도구 오류 — 원장 V-281c4075 COLUMN / 실측[T-48ec57da]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 8d3508c7 ≠ 현재 3577d393) — 이전 판정 PASS 보 |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-1278 | D5 | UNIT_CURRENCY | 하네스·환경 | D5 도구 오류 — 실측[T-bb6befa4]: ITEM_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1279 | E4 | MEASURE / Measure | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS / 원장 V-545c61a8 ASIS / 실측[T-80d5620d]: [미검증] MSG00113: 위반  |  | 36 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-1280 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-e02c62bd / 실측[T-4b527397]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_1_BizPlan.ValidationCheck:27) |
| WK-DMF0042-1281 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-86dcf637 / 실측[T-c43fdef5]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_2_BizPlan.ValidationCheck:29) |
| WK-DMF0042-1282 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-82c08dd4 / 실측[T-edf1f7e1]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_3_BizPlan.ValidationCheck:27) |
| WK-DMF0042-1283 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-aa9f4ac3 / 실측[T-6dbe9fd6]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_BizPlan.ValidationCheck:2791) |
| WK-DMF0042-1284 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-64ccae99 / 실측[T-ec5092cd]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_BizPlan_old.ValidationCheck:) |
| WK-DMF0042-1285 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-92830b3d / 실측[T-fe9b6a44]: MSG00002 — ValidationCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Validatio |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:5) |
| WK-DMF0042-1286 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-9ac1dcbf ASIS / 원장 V-c9457d29 ASIS / 원장 V-49247b0f ASIS / 원장 V-ba4a4e6b ASIS / 원장 V-8a7111a9 ASIS / 원장 V-bde38c44  |  | 7 (저장 검증 8 (#13~20) ACT:DMF0042_1_BizPlan.S) |
| WK-DMF0042-1287 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-9ac1dcbf / 실측[T-9a6c7a20]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1143:179) |
| WK-DMF0042-1288 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-c9457d29 / 실측[T-546139c5]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1295:250) |
| WK-DMF0042-1289 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-49247b0f / 실측[T-9b7d6588]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1186:186) |
| WK-DMF0042-1290 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-ba4a4e6b / 실측[T-ddd7cebb]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_BizPlan.SaveData:1204:179) |
| WK-DMF0042-1291 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8a7111a9 / 실측[T-5b3abdd3]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:930:168) |
| WK-DMF0042-1292 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-bde38c44 / 실측[T-7ffb198c]: [미검증] MSG00004: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'else of (sRet !=  |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:5) |
| WK-DMF0042-1293 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-f94b3ae0 ASIS / 원장 V-0061079c ASIS / 원장 V-5b412dc3 ASIS / 원장 V-d536761c ASIS / 원장 V-ead4c1e1 ASIS / 실측[T-4927d0b1] |  | 7 (24 저장 검증 8 (#13~20) ACT:DMF0042_1_BizPla) |
| WK-DMF0042-1294 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-f94b3ae0 / 실측[T-3f1f525c]: [미검증] MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (fnValidation( |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1093:149) |
| WK-DMF0042-1295 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-0061079c / 실측[T-5745662d]: [미검증] MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (fnValidation( |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1225:194) |
| WK-DMF0042-1296 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-5b412dc3 / 실측[T-da0773d5]: [미검증] MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (fnValidation( |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1136:156) |
| WK-DMF0042-1297 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-d536761c / 실측[T-2e9d7587]: [미검증] MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (fnValidation( |  | 1 (ACT:DMF0042_BizPlan.SaveData:1154:149) |
| WK-DMF0042-1298 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-ead4c1e1 / 실측[T-c79fd7af]: [미검증] MSG00043: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (fnValidation( |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:885:137) |
| WK-DMF0042-1299 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-6df9806b / 실측[T-2a572fb4]: [미검증] MSG00096: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'switch (UserInfoC |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-1300 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-6df9806b ASIS / 실측[T-91d9f839]: [미검증] MSG00096: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'switch (User |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-1301 | E4 | MSG00097 | 하네스·환경 | E4 도구 오류 — 실측[T-0dd9b237]: [폼 저장형 시나리오 5건] ERROR: [측정 경로 없음] G16 MSG00097: 조회영역 칸 'Division' 없음 ‖ ERROR: [측정 경로 없음] G20 MSG00097:  |  | 7 (20 조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan) |
| WK-DMF0042-1302 | E4 | MSG00108 | 하네스·환경 | E4 도구 오류 — 실측[T-b91cc8ca]: [폼 저장형 시나리오 5건] ERROR: [측정 경로 없음] G17 MSG00108: 조회영역 칸 'Division' 없음 ‖ ERROR: [측정 경로 없음] G21 MSG00108:  |  | 6 (조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan.Fi) |
| WK-DMF0042-1303 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-78f9b9a5 ASIS / 원장 V-e3a95858 ASIS / 원장 V-44c6fbdc ASIS / 원장 V-efd838b0 ASIS / 원장 V-8b380a5c ASIS / 원장 V-0cb9d4fa  |  | 11 (Insert (F8) 저장 검증 8 (#13~20) ACT:DMF0042) |
| WK-DMF0042-1304 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-78f9b9a5 / 실측[T-c393f0cb]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:548:4) |
| WK-DMF0042-1305 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-e3a95858 / 실측[T-0adb327f]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:810:4) |
| WK-DMF0042-1306 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-44c6fbdc / 실측[T-74d9ddfc]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:544:4) |
| WK-DMF0042-1307 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-efd838b0 / 실측[T-7b008706]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:788:4) |
| WK-DMF0042-1308 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-8b380a5c / 실측[T-f07af8f0]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:574:4) |
| WK-DMF0042-1309 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-0cb9d4fa / 실측[T-df4e32f6]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:836:4) |
| WK-DMF0042-1310 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-54761c50 / 실측[T-597c98e8]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_BizPlan.SaveData:871:4) |
| WK-DMF0042-1311 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-1ca62479 / 실측[T-6ddc58c5]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:517:3) |
| WK-DMF0042-1312 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-eefa930d / 실측[T-622c3b08]: MSG00113 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:696:4) |
| WK-DMF0042-1313 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-a7450372 ASIS / 원장 V-e83fd292 ASIS / 원장 V-76e7b693 ASIS / 원장 V-7dfd4189 ASIS / 원장 V-ed525b64 ASIS / 실측[T-e92b3f44] |  | 8 (btnExchangeRate 26 버튼 가드 6 (#42/43/45/97) |
| WK-DMF0042-1314 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-a7450372 / 실측[T-3ecb744a]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1315 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-e83fd292 / 실측[T-73830019]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1316 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-76e7b693 / 실측[T-76034f82]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1317 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-7dfd4189 / 실측[T-b5128068]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1318 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-ed525b64 / 실측[T-fcdfa0cd]: MSG00142 — btnExchangeRate_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1319 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-57c69aef ASIS / 원장 V-034982a8 ASIS / 원장 V-61fabbab ASIS / 원장 V-394a8240 ASIS / 원장 V-29f09ecf ASIS / 실측[T-e4eed2ba] |  | 8 (1#8 3#7 버튼 가드 6 (#42/43/45/97~99) ACT:DM) |
| WK-DMF0042-1320 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-57c69aef / 실측[T-146eb456]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(cboBu |  | 1 (ACT:DMF0042_1_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1321 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-034982a8 / 실측[T-0c2c141c]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(cboBu |  | 1 (ACT:DMF0042_2_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1322 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-61fabbab / 실측[T-63413ea5]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(cboBu |  | 1 (ACT:DMF0042_3_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1323 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-394a8240 / 실측[T-c14cf0ce]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(cboBu |  | 1 (ACT:DMF0042_BizPlan.cboBucketType_Click:) |
| WK-DMF0042-1324 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-29f09ecf / 실측[T-a2b77e07]: MSG00227 — cboBucketType_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(cboBu |  | 1 (ACT:DMF0042_BizPlan_old.cboBucketType_Cl) |
| WK-DMF0042-1325 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-9e32aa7e ASIS / 원장 V-c148f2fc ASIS / 원장 V-1e24d9fe ASIS / 원장 V-6b3077b3 ASIS / 원장 V-421dc349 ASIS / 실측[T-1dbabb7d] |  | 6 (저장 검증 8 (#13~20) ACT:DMF0042_1_BizPlan.S) |
| WK-DMF0042-1326 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-9e32aa7e / 실측[T-f4a45dc6]: [미검증] MSG00275: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iCount == 0)' |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1087:146) |
| WK-DMF0042-1327 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-c148f2fc / 실측[T-2bde85df]: [미검증] MSG00275: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iCount == 0)' |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1219:191) |
| WK-DMF0042-1328 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-1e24d9fe / 실측[T-72a7caa4]: [미검증] MSG00275: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iCount == 0)' |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1130:153) |
| WK-DMF0042-1329 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-6b3077b3 / 실측[T-b52ef197]: [미검증] MSG00275: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iCount == 0)' |  | 1 (ACT:DMF0042_BizPlan.SaveData:1148:146) |
| WK-DMF0042-1330 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-421dc349 / 실측[T-a950924d]: [미검증] MSG00275: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iCount == 0)' |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:879:134) |
| WK-DMF0042-1331 | E4 | MSG00276 | 하네스·환경 | E4 도구 오류 — 실측[T-97969c38]: [폼 저장형 시나리오 5건] ERROR: [측정 경로 없음] G18 MSG00276: 조회영역 칸 'Division' 없음 ‖ ERROR: [측정 경로 없음] G22 MSG00276:  |  | 6 (조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan.Fi) |
| WK-DMF0042-1332 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS / 원장 V-545c61a8 ASIS / 실측[T-596431de]: MSG00289 — spdMain_ |  | 6 (3#14 Grid 입력 4 (#39~40/41/44) ACT:DMF004) |
| WK-DMF0042-1333 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 / 실측[T-de226687]: MSG00289 — spdMain_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMain_C |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1334 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-b64b7fd8 / 실측[T-b260dc8a]: MSG00289 — spdMain_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMain_C |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-1335 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-b8eeaeb8 / 실측[T-9ecb20bc]: MSG00289 — spdMain_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMain_C |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1916) |
| WK-DMF0042-1336 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-545c61a8 / 실측[T-c79940b4]: MSG00289 — spdMain_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMain_C |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-1337 | E4 | UNIT_ENERGY / Energy | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS / 실측[T-dd5dd920]: [미검증] MSG00113: 위반 입력 자동 생성 불가(검사기 한계 —  |  | 3 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1338 | E4 | drpPeriod / Period / From / To / 기간 | 하네스·환경 | E4 도구 오류 — 실측[T-408da82c]: [폼 저장형 시나리오 5건] ERROR: [측정 경로 없음] G18 MSG00276: 조회영역 칸 'Division' 없음 ‖ ERROR: [측정 경로 없음] G22 MSG00276:  |  | 5 (ACT:DMF0042_1_BizPlan.FindData:711:13 AC) |
| WK-DMF0042-1339 | A6 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 하네스·환경 | A6 도구 오류 — 원장 V-725111a2 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-fac1aec3]: [A6 팝업·셀 이벤트 SP 정적·골든 대조 T605] 정 |  | 40 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1340 | A6 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 하네스·환경 | A6 도구 오류 — 원장 V-12d38f2f SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-5a4fc37b]: [A6 팝업·셀 이벤트 SP 정적·골든 대 |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1341 | A6 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 하네스·환경 | A6 도구 오류 — 원장 V-bfa5da80 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-5f784c33]: [A6 팝업·셀 이벤트 SP 정적·골든 대 |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1342 | G1 | 16 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 16 'spdMain_ComboSelChange (L1565~1596)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (16) |
| WK-DMF0042-1343 | G1 | 20 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (20) |
| WK-DMF0042-1344 | G1 | 24 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (24) |
| WK-DMF0042-1345 | G1 | 26 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (26) |
| WK-DMF0042-1346 | G1 | 27 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (27) |
| WK-DMF0042-1347 | G1 | 3#1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 3#1 'Form_Load (L209~217)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (3#1) |
| WK-DMF0042-1348 | G1 | 3#13 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 3#13 'btnMeasure_Click (L2819~2830)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (3#13) |
| WK-DMF0042-1349 | G1 | 6#6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (6#6) |
| WK-DMF0042-1350 | G1 | 6#7 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 6#7 'Ver.Cutoff/Replace 모달 = 목록조회+실행 표준 재구성' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (6#7) |
| WK-DMF0042-1351 | G1 | DMF0042_2_BizPlan.FindButton | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (ACT:DMF0042_2_BizPlan.FindButton:513:1) |
| WK-DMF0042-1352 | G1 | DMF0042_2_BizPlan.FindData | 하네스·환경 | G1 도구 오류 — 원장 V-94f9af94 ASIS / 원장 V-d5c81478 ASIS / 원장 V-e72422d9 ASIS / 원장 V-19257fab ASIS |  | 33 (ACT:DMF0042_2_BizPlan.FindData:649:1 ACT) |
| WK-DMF0042-1353 | G1 | Find (F5) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Find (F5) 'hotkeyConfig.search → handleSearch (V-S1~S3 + setF' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (Find (F5)) |
| WK-DMF0042-1354 | G1 | G9 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 G9 '**CELL_PROD_SITE 콤보(40)** — 조회 표시 코드→한글(ALL)+신규행 유' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (G9) |
| WK-DMF0042-1355 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-16b773e6 |  | 1 (ACT:DMF0042_1_BizPlan.FindData:697:6) |
| WK-DMF0042-1356 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-94f9af94 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:660:6) |
| WK-DMF0042-1357 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-a9b5158e |  | 1 (ACT:DMF0042_3_BizPlan.FindData:723:6) |
| WK-DMF0042-1358 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-30437554 |  | 1 (ACT:DMF0042_BizPlan.FindData:758:6) |
| WK-DMF0042-1359 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-ddec28e1 |  | 1 (ACT:DMF0042_BizPlan_old.FindData:595:6) |
| WK-DMF0042-1360 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-2e9eedeb |  | 1 (ACT:DMF0042_1_BizPlan.FindData:705:10) |
| WK-DMF0042-1361 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-d5c81478 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:668:10) |
| WK-DMF0042-1362 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-48fe12e3 |  | 1 (ACT:DMF0042_3_BizPlan.FindData:731:10) |
| WK-DMF0042-1363 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-0b438463 |  | 1 (ACT:DMF0042_BizPlan.FindData:766:10) |
| WK-DMF0042-1364 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-50db9387 |  | 1 (ACT:DMF0042_BizPlan_old.FindData:603:10) |
| WK-DMF0042-1365 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-d5eba555 |  | 1 (ACT:DMF0042_1_BizPlan.FindData:711:13) |
| WK-DMF0042-1366 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-e72422d9 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:674:13) |
| WK-DMF0042-1367 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-c621a149 |  | 1 (ACT:DMF0042_3_BizPlan.FindData:737:13) |
| WK-DMF0042-1368 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-53ee84c8 |  | 1 (ACT:DMF0042_BizPlan.FindData:772:13) |
| WK-DMF0042-1369 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-c6fad0ce |  | 1 (ACT:DMF0042_BizPlan_old.FindData:609:13) |
| WK-DMF0042-1370 | G1 | btnExchangeRate | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnExchangeRate '커스텀 버튼(LBL00661) → pending 차단(MSG00680 — AS-IS MSG' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (btnExchangeRate) |
| WK-DMF0042-1371 | G1 | btnMeasure 'Measure' | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnMeasure 'Measure' "커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('" 의 G1 37요소: ERROR:27 · PASS:5 · NA: |  | 1 (btnMeasure 'Measure') |
| WK-DMF0042-1372 | G1 | btnReplace (ADMIN/DM ADMIN) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnReplace (ADMIN/DM ADMIN) "커스텀 버튼 'Replace' — hasButton('REPLACE') 게이트 + pend" 의 G1 37요소: ERROR:27 · PASS: |  | 1 (btnReplace (ADMIN/DM ADMIN)) |
| WK-DMF0042-1373 | G1 | btnSetPrice (가격환산) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnSetPrice (가격환산) "커스텀 버튼 'Set Price' → MSG00678 confirm → SET_PRICE(" 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (btnSetPrice (가격환산)) |
| WK-DMF0042-1374 | G1 | cboClosed / Closed | 하네스·환경 | G1 도구 오류 — 원장 V-5fd5e439 SEARCH / E2E smoke cond CustomDropdown |  | 1 (1#15) |
| WK-DMF0042-1375 | G1 | cboQty / . / Qty | 하네스·환경 | G1 도구 오류 — 원장 V-47d0fa5c SEARCH / E2E smoke cond Checkbox |  | 9 (1#14 ACT:DMF0042_1_BizPlan.FindData ACT:) |
| WK-DMF0042-1376 | G1 | chkSum / Sum | 하네스·환경 | G1 도구 오류 — 원장 V-3003995f SEARCH / E2E smoke cond checkbox |  | 1 (1#13) |
| WK-DMF0042-1377 | G1 | clbCustomer / End Customer / Customer | 하네스·환경 | G1 도구 오류 — 원장 V-fb2332bd SEARCH / E2E smoke cond combo |  | 11 (1#3 ACT:DMF0042_1_BizPlan.FindData ACT:D) |
| WK-DMF0042-1378 | G1 | clbPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-5de2413f SEARCH / E2E smoke cond combo |  | 11 (1#6 ACT:DMF0042_1_BizPlan.FindData ACT:D) |
| WK-DMF0042-1379 | G1 | clbSalesSite / Sales Site | 하네스·환경 | G1 도구 오류 — 원장 V-7c19a4f5 SEARCH / E2E smoke cond combo |  | 13 (1#5 3#4 3#5 ACT:DMF0042_1_BizPlan.FindDa) |
| WK-DMF0042-1380 | G1 | clbTeam / Team | 하네스·환경 | G1 도구 오류 — 원장 V-05dfb57c SEARCH / E2E smoke cond combo |  | 16 (1#2 ACT:DMF0042_1_BizPlan.FindData ACT:D) |
| WK-DMF0042-1381 | G1 | drpPeriod / Period / From / To / 기간 | 하네스·환경 | G1 도구 오류 — 원장 V-95d4ea5a SEARCH / E2E smoke cond period |  | 51 (1#9 ACT:DMF0042_1_BizPlan.FindData ACT:D) |
| WK-DMF0042-1382 | G1 | txtItemId / Model / Item Id / Model/Nick | 하네스·환경 | G1 도구 오류 — 원장 V-2e568cb1 SEARCH / 원장 EG-60391707 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nickname FILTER_ROWS / 원장 EG-c58e |  | 11 (1#11 ACT:DMF0042_1_BizPlan.FindData ACT:) |
| WK-DMF0042-1383 | G1 | txtOwner / Owner | 하네스·환경 | G1 도구 오류 — 원장 V-35491d16 SEARCH / 원장 EG-1481578c 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner FILTER_ROWS / 원장 EG-ba915b34 팝업 실측 D |  | 11 (1#12 ACT:DMF0042_1_BizPlan.FindData ACT:) |
| WK-DMF0042-1384 | G1 | txtProject / Project / PJT | 하네스·환경 | G1 도구 오류 — 원장 V-82cee496 SEARCH |  | 11 (1#10 ACT:DMF0042_1_BizPlan.FindData ACT:) |
| WK-DMF0042-1385 | G1 | usrMonthTo / ~ / Month To | 하네스·환경 | G1 도구 오류 — 원장 V-47d0fa5c SEARCH / E2E smoke cond Checkbox |  | 3 (ACT:DMF0042_ExchangeRatePopup.FindData A) |
| WK-DMF0042-1386 | G1 | — | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 — '파리티 확인(무변경): 분모0 가드 기구현 / Cutoff 재조회 없음=파리티·Replac' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (—) |
| WK-DMF0042-1387 | G1 | 버튼 가드 6 (#42/43/45/97~99) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 G1 37요소: ERROR:27 · PASS:5  |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-1388 | G1 | 조회 검증 4 (#9~12) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회 검증 4 (#9~12) 'MSG00097(Division)/MSG00108(역전)/MSG00276(6년 초과+보정)' 의 G1 37요소: ERROR:27 · PASS:5 · NA:5 |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-1389 | G6 | usrMonthFrom / Period / Month From | 하네스·환경 | G6 도구 오류 — 실측[T-0b9e5f7a]: 공용 팝업 내부 조건(usrMonthFrom) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1390 | G6 | usrMonthTo / ~ / Month To | 하네스·환경 | G6 도구 오류 — 실측[T-07e36228]: 공용 팝업 내부 조건(usrMonthTo) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1391 | X-ROW | DMF0042_1_RTF..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 2 (ACT:DMF0042_1_RTF..ctor:106:1 ACT:DMF004) |
| WK-DMF0042-1392 | X-ROW | DMF0042_1_RTF.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:DMF0042_1_RTF.CreateSpread ACT:DMF00) |
| WK-DMF0042-1393 | X-ROW | DMF0042_1_RTF.DMF0003_CustDemandAnalysis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_1_RTF.DMF0003_CustDemandAnal) |
| WK-DMF0042-1394 | X-ROW | DMF0042_1_RTF.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — PASS:1 · ERROR:1 · NA:1 |  | 3 (ACT:DMF0042_1_RTF.DefineProperty ACT:DMF) |
| WK-DMF0042-1395 | X-ROW | DMF0042_1_RTF.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:DMF0042_1_RTF.Dispose:16:1 ACT:DMF00) |
| WK-DMF0042-1396 | X-ROW | DMF0042_1_RTF.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:DMF0042_1_RTF.EditButton ACT:DMF0042) |
| WK-DMF0042-1397 | X-ROW | DMF0042_1_RTF.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 12 (ACT:DMF0042_1_RTF.Form_Load ACT:DMF0042_) |
| WK-DMF0042-1398 | X-ROW | DMF0042_1_RTF.GetSLOC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · PASS:1 |  | 12 (ACT:DMF0042_1_RTF.GetSLOC ACT:DMF0042_1_) |
| WK-DMF0042-1399 | X-ROW | DMF0042_1_RTF.GetSPlant | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · PASS:1 |  | 12 (ACT:DMF0042_1_RTF.GetSPlant ACT:DMF0042_) |
| WK-DMF0042-1400 | X-ROW | DMF0042_1_RTF.GetSplit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_1_RTF.GetSplit ACT:DMF0042_1) |
| WK-DMF0042-1401 | X-ROW | DMF0042_1_RTF.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:DMF0042_1_RTF.InitControls ACT:DMF00) |
| WK-DMF0042-1402 | X-ROW | DMF0042_1_RTF.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 38검사 — ERROR:21 · NA:14 · PASS:3 |  | 36 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-1403 | X-ROW | DMF0042_1_RTF.Select_DpInit_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — NA:14 · ERROR:7 · PASS:3 · REVIEW:1 |  | 59 (ACT:DMF0042_1_RTF.Select_DpInit_Data ACT) |
| WK-DMF0042-1404 | X-ROW | DMF0042_1_RTF.Select_DpResult_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — NA:14 · ERROR:7 · PASS:3 · REVIEW:1 |  | 58 (ACT:DMF0042_1_RTF.Select_DpResult_Data A) |
| WK-DMF0042-1405 | X-ROW | DMF0042_1_RTF.Select_In_De_Demand | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 24 (ACT:DMF0042_1_RTF.Select_In_De_Demand AC) |
| WK-DMF0042-1406 | X-ROW | DMF0042_1_RTF.sheetSetting | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 4 (ACT:DMF0042_1_RTF.sheetSetting ACT:DMF00) |
| WK-DMF0042-1407 | X-ROW | DMF0042_1_RTF.spdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NA:2 |  | 38 (ACT:DMF0042_1_RTF.spdMain_CellClick ACT:) |
| WK-DMF0042-1408 | X-ROW | DMF0042_1_RTF.spdMain_ComboCloseUp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:9 · NA:3 |  | 35 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-1409 | X-ROW | DMF0042_1_RTF.spdMain_KeyUp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_1_RTF.spdMain_KeyUp ACT:DMF0) |
| WK-DMF0042-1410 | X-ROW | DMF0042_1_RTF.spdMain_LeaveCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_1_RTF.spdMain_LeaveCell ACT:) |
| WK-DMF0042-1411 | X-ROW | DMF0042_2_BizPlan.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:4 · NOT_RUN:2 · NA:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0042_2_BizPlan.DefineProperty:318) |
| WK-DMF0042-1412 | X-ROW | DMF0042_2_BizPlan.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0042_2_BizPlan.InitSpread) |
| WK-DMF0042-1413 | X-ROW | DMF0042_2_BizPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 49검사 — ERROR:27 · NA:15 · PASS:7 |  | 60 (ACT:DMF0042_2_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-1414 | X-ROW | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · NA:1 |  | 2 (ACT:DMF0042_2_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-1415 | X-ROW | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:11 · NA:2 · PASS:1 |  | 8 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1416 | X-ROW | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-1417 | X-ROW | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:5 · PASS:5 |  | 13 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-1418 | X-ROW | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-1419 | X-ROW | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:9 · PASS:1 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-1420 | X-ROW | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:8 · PASS:1 |  | 3 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-1421 | X-ROW | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 60검사 — ERROR:40 · NA:20 |  | 33 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-1422 | X-ROW | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 54검사 — NA:27 · ERROR:26 · PASS:1 |  | 6 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-1423 | X-ROW | DMF0042_ExchangeRatePopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 2 (ACT:DMF0042_ExchangeRatePopup..ctor:74:1) |
| WK-DMF0042-1424 | X-ROW | DMF0042_ExchangeRatePopup.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.CreateSpre) |
| WK-DMF0042-1425 | X-ROW | DMF0042_ExchangeRatePopup.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 10 (ACT:DMF0042_ExchangeRatePopup.DefineProp) |
| WK-DMF0042-1426 | X-ROW | DMF0042_ExchangeRatePopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:DMF0042_ExchangeRatePopup.Dispose:16) |
| WK-DMF0042-1427 | X-ROW | DMF0042_ExchangeRatePopup.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — PASS:6 · ERROR:5 · NA:2 |  | 25 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-1428 | X-ROW | DMF0042_ExchangeRatePopup.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:6 · REVIEW:4 |  | 3 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1429 | X-ROW | DMF0042_ExchangeRatePopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — ERROR:7 · REVIEW:4 · PASS:4 · NA:1 · NOPATH:1 |  | 39 (ACT:DMF0042_ExchangeRatePopup.FindData:3) |
| WK-DMF0042-1430 | X-ROW | DMF0042_ExchangeRatePopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 8 (ACT:DMF0042_ExchangeRatePopup.Form_Load ) |
| WK-DMF0042-1431 | X-ROW | DMF0042_ExchangeRatePopup.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_ExchangeRatePopup.GetCellCol) |
| WK-DMF0042-1432 | X-ROW | DMF0042_ExchangeRatePopup.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:3 · ERROR:3 · NOT_RUN:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.InitContro) |
| WK-DMF0042-1433 | X-ROW | DMF0042_ExchangeRatePopup.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:15 · PASS:7 · NOT_RUN:3 · REVIEW:1 · NOPATH:1 |  | 30 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1434 | X-ROW | DMF0042_ExchangeRatePopup.InitSpread_X | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:3 · ERROR:3 |  | 35 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1435 | X-ROW | DMF0042_ExchangeRatePopup.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:DMF0042_ExchangeRatePopup.InsertButt) |
| WK-DMF0042-1436 | X-ROW | DMF0042_ExchangeRatePopup.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:6 · NA:4 · PASS:2 |  | 18 (ACT:DMF0042_ExchangeRatePopup.InsertRow ) |
| WK-DMF0042-1437 | X-ROW | DMF0042_ExchangeRatePopup.LoadData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:2 · ERROR:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.LoadData A) |
| WK-DMF0042-1438 | X-ROW | DMF0042_ExchangeRatePopup.mOK | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_ExchangeRatePopup.mOK ACT:DM) |
| WK-DMF0042-1439 | G5 | DMF0042_1_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-8304b5b2 ASIS / 원장 V-a18cedef ASIS / 원장 V-8c22dd59 ASIS / 원장 V-d287ea11 ASIS / 원장 V-b0b18d13 ASIS / 원장 V-34b78b6b  |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1440 | G5 | DMF0042_3_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-67e1d2b3 ASIS / 원장 V-533fa8e8 ASIS / 원장 V-09514ccd ASIS / 원장 V-efc55908 ASIS / 원장 V-8a21db8f ASIS / 원장 V-fa48bf61  |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1441 | G5 | DMF0042_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-09b2354c ASIS / 원장 V-a562dbe3 ASIS / 원장 V-40972618 ASIS / 원장 V-d0b478c2 ASIS / 원장 V-1cef95c2 ASIS / 원장 V-4b221c76  |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1442 | G5 | DMF0042_BizPlan_old | 하네스·환경 | G5 도구 오류 — 원장 V-bd913a0f ASIS / 원장 V-26080023 ASIS / 원장 V-7ca5414e ASIS / 원장 V-ec8f7299 ASIS / 원장 V-96b128c7 ASIS / 원장 V-9e1eb29d  |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1443 | G5 | DMF0042_ExchangeRatePopup | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 ASIS / 원장 V-b0060baf ASIS / 원장 V-efc55908 ASIS / 원장 V-d0b478c2 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1444 | G5 | ITEM_ID / Model | 하네스·환경 | G5 도구 오류 — 원장 V-33911c19 ASIS / 원장 V-9c138f8b ASIS / 원장 V-e6f1d35b ASIS / 원장 V-239f9218 ASIS / 원장 V-c4fe4567 ASIS / 원장 V-c860313e  |  | 271 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-1445 | G5 | btnCutOff | 하네스·환경 | G5 도구 오류 — 원장 V-8c22dd59 ASIS / 원장 V-1c078df1 ASIS / 원장 V-09514ccd ASIS / 원장 V-40972618 ASIS / 원장 V-7ca5414e ASIS |  | 1 (27) |
| WK-DMF0042-1446 | G5 | btnExchangeRate | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 ASIS / 원장 V-b0b18d13 ASIS / 원장 V-b0060baf ASIS / 원장 V-549f5646 ASIS / 원장 V-efc55908 ASIS / 원장 V-8a21db8f  |  | 1 (26) |
| WK-DMF0042-1447 | G5 | btnItemId | 하네스·환경 | G5 도구 오류 — 원장 V-34b78b6b ASIS / 원장 V-4c9f9912 ASIS / 원장 V-af37c62c ASIS / 원장 V-8c214ac8 ASIS / 원장 V-9b693258 ASIS / 원장 V-6350a467  |  | 2 (btnProject/btnItemId/btnOwner 3#10) |
| WK-DMF0042-1448 | G5 | btnReplace | 하네스·환경 | G5 도구 오류 — 원장 V-eea1d3ba ASIS / 원장 V-731389b5 ASIS / 원장 V-546e5d43 ASIS / 원장 V-5f26da35 ASIS |  | 1 (28) |
| WK-DMF0042-1449 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1450 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-b0060baf |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1451 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-efc55908 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1452 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-d0b478c2 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1453 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-e6f1d35b |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1454 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-8c22dd59 |  | 1 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1455 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-b0b18d13 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1456 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-eea1d3ba |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1457 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-1c078df1 |  | 1 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1458 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-549f5646 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1459 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-731389b5 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1460 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-09514ccd |  | 1 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1461 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-8a21db8f |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1462 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-546e5d43 |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1463 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-40972618 |  | 1 (ACT:DMF0042_BizPlan.btnCutOff_Click:2923) |
| WK-DMF0042-1464 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-1cef95c2 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1465 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-5f26da35 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:355) |
| WK-DMF0042-1466 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-7ca5414e |  | 1 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1467 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-ec8f7299 |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1468 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스·환경 | G5 도구 오류 — 원장 V-1a454605 SEARCH / 원장 EG-b5af24ee 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nickname DIV_FIXED / 원장 EG-be81ef |  | 1 (3#10) |
| WK-DMF0042-1469 | G5 | txtOwner / Owner | 하네스·환경 | G5 도구 오류 — 원장 V-a3967a98 SEARCH / 원장 EG-e548c3fd 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner DIV_FIXED / 원장 EG-c0bf9d6d 팝업 실측 DM0 |  | 1 (3#11) |
| WK-DMF0042-1470 | H6 | DMF0042_ExchangeRatePopup | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 ASIS / 원장 V-d7dd8ff5 ASIS / 원장 V-41d355a1 ASIS / 원장 V-b56c42ad ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1471 | H6 | PROJECT_CODE / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-94591724 ASIS / 원장 V-addb38a8 ASIS / 원장 V-da6826d9 ASIS / 원장 V-6bbd9c1f ASIS / 원장 V-831155be ASIS / 원장 V-3bf44110  |  | 215 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-1472 | H6 | PROJECT_CODE82 / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-5c44599d ASIS / 원장 V-a24593e0 ASIS / 원장 V-88f0ade7 ASIS / 원장 V-93cdbd29 ASIS / 원장 V-01698a4b ASIS / 원장 V-9806662b  |  | 1 (3#15) |
| WK-DMF0042-1473 | H6 | btnCutOff | 하네스·환경 | H6 도구 오류 — 원장 V-1dd724bf ASIS / 원장 V-538d180a ASIS / 원장 V-38555156 ASIS / 원장 V-f2abcf20 ASIS / 원장 V-be24c7f2 ASIS |  | 21 (27 ACT:DMF0042_1_BizPlan.btnColumn_Click) |
| WK-DMF0042-1474 | H6 | btnExchangeRate | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 ASIS / 원장 V-c02d48d9 ASIS / 원장 V-d7dd8ff5 ASIS / 원장 V-9f2b5927 ASIS / 원장 V-41d355a1 ASIS / 원장 V-03ff3146  |  | 21 (26 ACT:DMF0042_1_BizPlan.btnColumn_Click) |
| WK-DMF0042-1475 | H6 | btnProject | 하네스·환경 | H6 도구 오류 — 원장 V-926405f0 ASIS / 원장 V-99d60d99 ASIS / 원장 V-260c75c6 ASIS / 원장 V-1af3bc3d ASIS / 원장 V-127be395 ASIS / 원장 V-68a856f1  |  | 22 (btnProject/btnItemId/btnOwner 3#9 ACT:DM) |
| WK-DMF0042-1476 | H6 | btnReplace | 하네스·환경 | H6 도구 오류 — 원장 V-9f2394e9 ASIS / 원장 V-8c9c8509 ASIS / 원장 V-b603d031 ASIS / 원장 V-e1c57710 ASIS |  | 21 (28 ACT:DMF0042_1_BizPlan.btnColumn_Click) |
| WK-DMF0042-1477 | H6 | new DM0002_MatsterChgPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-cf027b3b |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1478 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1479 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-d7dd8ff5 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1480 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-41d355a1 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1481 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-b56c42ad |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1482 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-926405f0 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1483 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-94591724 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1484 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-5c44599d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1485 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-1af3bc3d |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1486 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-831155be |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1487 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-fc39508c |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1488 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-0fe103d1 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1489 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-93cdbd29 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1490 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-ad3cf845 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1491 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-f0013a5a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1492 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-ae045e5c |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1493 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-fecea1f5 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1494 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-27791849 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1495 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-add7124d |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1496 | H6 | popAdjst.Form_Load(true, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-1dc2dcf5 |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1497 | H6 | popAdjst.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-bce797b1 |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1498 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-addb38a8 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1499 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-a24593e0 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1500 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-3bf44110 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1501 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-9cfaf9f4 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1502 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-01698a4b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1503 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-a0df5abc |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1504 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-24a743ce |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1505 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-8435df85 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1506 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-37a0d36c |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1507 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-99d60d99 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1508 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-127be395 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1509 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-c1eeb83b |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1510 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-ac6948f9 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1511 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-f42f338b |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1512 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-260c75c6 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1513 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-da6826d9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1514 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-88f0ade7 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1515 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-68a856f1 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1516 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-14b9b3fb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1517 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-99c4b743 |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1518 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-983f0408 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1519 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9806662b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1520 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-404870f2 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1521 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-c9035f1f |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1522 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-24ba7a9a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1523 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6da216e3 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1524 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-26d4c6d6 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1525 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-03456d5d |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1526 | H6 | popup.Form_Load(sDIVISION_ID, sPROJECT_C | 하네스·환경 | H6 도구 오류 — 원장 V-6bbd9c1f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1527 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1dd724bf |  | 1 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1528 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-c02d48d9 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1529 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9f2394e9 |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1530 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-538d180a |  | 1 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1531 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9f2b5927 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1532 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-8c9c8509 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1533 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6cecd4cf |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1534 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-38555156 |  | 1 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1535 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-03ff3146 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1536 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-b603d031 |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1537 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f2abcf20 |  | 1 (ACT:DMF0042_BizPlan.btnCutOff_Click:2923) |
| WK-DMF0042-1538 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f2c4be03 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1539 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-e1c57710 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:355) |
| WK-DMF0042-1540 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-be24c7f2 |  | 1 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1541 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-32aec8b9 |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1542 | H6 | txtProject / Project / PJT | 하네스·환경 | H6 도구 오류 — E2E smoke cond popup |  | 1 (3#9) |
| WK-DMF0042-1543 | M3 | DMF0042_1_RTF | 하네스·환경 | M3 도구 오류 — 실측[T-e9b7b699]: [미검증] 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7) |  | 25 (ACT:DMF0042_1_RTF..ctor ACT:DMF0042_1_RT) |
| WK-DMF0042-1544 | M3 | DMF0042_ExchangeRatePopup | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 ASIS / 원장 V-d9311d6a ASIS / 원장 V-d5b20abe ASIS / 원장 V-47ddfba8 ASIS / 실측[T-7b198add]: [미검증] 팝업을 여는 트리거 셀을 |  | 27 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1545 | M3 | btnExchangeRate | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 ASIS / 원장 V-d9311d6a ASIS / 원장 V-d5b20abe ASIS / 원장 V-47ddfba8 ASIS / 실측[T-eebcc6e8]: [미검증] 팝업을 여는 트리거 셀을 |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1546 | M3 | btnItemId | 하네스·환경 | M3 도구 오류 — 원장 V-d0296cf9 ASIS / 원장 V-07843a25 ASIS / 원장 V-56c78e2b ASIS / 원장 V-2534f49c ASIS / 원장 V-41d0eafc ASIS / 원장 EG-4636aa8b |  | 4 (ACT:DMF0042_1_BizPlan.btnItemId_Click AC) |
| WK-DMF0042-1547 | M3 | btnOwner | 하네스·환경 | M3 도구 오류 — 원장 V-1c96c6d6 ASIS / 원장 V-2a3cca60 ASIS / 원장 V-8b49f48e ASIS / 원장 V-4c454807 ASIS / 원장 V-39fc6309 ASIS / 원장 EG-ddc06bd1 |  | 4 (ACT:DMF0042_1_BizPlan.btnOwner_Click ACT) |
| WK-DMF0042-1548 | M3 | btnSetPrice | 하네스·환경 | M3 도구 오류 — 실측[T-60f858b4]: [미검증] 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7) |  | 4 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click ) |
| WK-DMF0042-1549 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-675768c9 |  | 1 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1550 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-7189d831 |  | 1 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-1551 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-7b310ef6 |  | 1 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-1552 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-fa946da2 |  | 1 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1553 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-084a9f65 |  | 1 (ACT:DMF0042_BizPlan.btnColumn_Click:2872) |
| WK-DMF0042-1554 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-9e2dfac9 |  | 1 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-1555 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | M3 도구 오류 — 원장 V-a61baf50 |  | 1 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-1556 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | M3 도구 오류 — 원장 V-cb73350f |  | 1 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-1557 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | M3 도구 오류 — 원장 V-1b4aec2a |  | 1 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1558 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | M3 도구 오류 — 원장 V-31ccdc9f |  | 1 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1559 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1560 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-d9311d6a |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1561 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-d5b20abe |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1562 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-47ddfba8 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1563 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-a1e299fa |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1564 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-9bea4449 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1565 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-8bcd645c |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1566 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-55e298ba |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1567 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-d1823927 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1568 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-1d043b2b |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1569 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-ac72aa62 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1570 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-1eb70f98 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1571 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-0092a45a |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1572 | M4 | 21 | 하네스·환경 | M4 도구 오류 — 실측[T-dbf286e0]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (21) |
| WK-DMF0042-1573 | M4 | 6#6 | 하네스·환경 | M4 도구 오류 — 실측[T-6c1e980c]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (6#6) |
| WK-DMF0042-1574 | M4 | BIZ_TYPE | 하네스·환경 | M4 도구 오류 — 실측[T-29050ebe]: [검사기 미검증] BIZ_TYPE: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1575 | M4 | BIZ_TYPE_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-af79c235]: [검사기 미검증] BIZ_TYPE_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1576 | M4 | BIZ_TYPE_NAME81 / Biz.Type | 하네스·환경 | M4 도구 오류 — 실측[T-b32e08fe]: [검사기 미검증] BIZ_TYPE_NAME81: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지  |  | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1577 | M4 | BIZ_TYPE_NAME82 | 하네스·환경 | M4 도구 오류 — 실측[T-485d2d42]: [검사기 미검증] BIZ_TYPE_NAME82: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지  |  | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1578 | M4 | BIZ_UNIT | 하네스·환경 | M4 도구 오류 — 실측[T-5e4b1dc8]: [검사기 미검증] BIZ_UNIT: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1579 | M4 | CELL_CAPA | 하네스·환경 | M4 도구 오류 — 실측[T-01ea874b]: [검사기 미검증] CELL_CAPA: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1580 | M4 | CELL_CORP_ID | 하네스·환경 | M4 도구 오류 — 실측[T-04f45ee3]: [검사기 미검증] CELL_CORP_ID: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1581 | M4 | CELL_NICK_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-f3f6566d]: [검사기 미검증] CELL_NICK_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1582 | M4 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | M4 도구 오류 — 실측[T-fafa39bd]: [검사기 미검증] CELL_PER_MODULE: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지  |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1583 | M4 | CELL_PER_PACK / Cell/Pack | 하네스·환경 | M4 도구 오류 — 실측[T-2fdd4776]: [검사기 미검증] CELL_PER_PACK: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1584 | M4 | COMPANY_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-a6aae925]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1585 | M4 | DEPT_ID / Team | 하네스·환경 | M4 도구 오류 — 실측[T-6cf7023a]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 33 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1586 | M4 | DIVISION_ID / Division | 하네스·환경 | M4 도구 오류 — 실측[T-42346f6e]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1587 | M4 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_CellDoubleClick 의 M4 33요소: ERROR:26 · NA:6 · NOT_RUN:1 |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1588 | M4 | EE_CORP_ID | 하네스·환경 | M4 도구 오류 — 실측[T-2299b54b]: [검사기 미검증] EE_CORP_ID: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1589 | M4 | END_CUSTOMER / End Customer | 하네스·환경 | M4 도구 오류 — 실측[T-7bd581e5]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 37 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1590 | M4 | END_CUSTOMER40 / End Customer | 하네스·환경 | M4 도구 오류 — 실측[T-22903807]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1591 | M4 | INCOTERMS / Rep. Incoterms | 하네스·환경 | M4 도구 오류 — 실측[T-5b3a6c34]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 6155b1ef ≠ 현재 9230fb03) — 이전 판정 FAIL 보류: PROJECT_CODE82 셀 위치  |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1592 | M4 | ITEM_ID / Model | 하네스·환경 | M4 도구 오류 — 실측[T-f3f177fa]: [검사기 미검증] ITEM_ID: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 271 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-1593 | M4 | ITEM_ID40 / Model | 하네스·환경 | M4 도구 오류 — 실측[T-ab8d6a98]: [검사기 미검증] ITEM_ID40: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 166 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1594 | M4 | ITEM_NAME / Model Name | 하네스·환경 | M4 도구 오류 — 실측[T-5507047c]: [검사기 미검증] ITEM_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1595 | M4 | ITEM_NICK_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-95cf0e31]: [검사기 미검증] ITEM_NICK_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1596 | M4 | MEASURE / Measure | 하네스·환경 | M4 도구 오류 — 실측[T-31464c91]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 ca8b5baf ≠ 현재 16ef04dd) — 이전 판정 FAIL 보류: PROJECT_CODE 셀 위치 확인 |  | 11 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1597 | M4 | MODULE_PER_PACK / Module/Pack | 하네스·환경 | M4 도구 오류 — 실측[T-643183ef]: [검사기 미검증] MODULE_PER_PACK: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지  |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1598 | M4 | PACK_CORP_ID | 하네스·환경 | M4 도구 오류 — 실측[T-39bd0f78]: [검사기 미검증] PACK_CORP_ID: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1599 | M4 | PRODUCT_GROUP | 하네스·환경 | M4 도구 오류 — 실측[T-5526976e]: [검사기 미검증] PRODUCT_GROUP: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1600 | M4 | PRODUCT_GROUP_NAME / Product Group Name | 하네스·환경 | M4 도구 오류 — 실측[T-fed3fcc8]: [검사기 미검증] PRODUCT_GROUP_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1601 | M4 | PROJECT_CODE / Project Code | 하네스·환경 | M4 도구 오류 — 실측[T-4ac39ba3]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 215 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-1602 | M4 | PROJECT_CODE82 / Project Code | 하네스·환경 | M4 도구 오류 — 실측[T-31a755cd]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 134 (3#15 ACT:DMF0042_1_BizPlan.spdMain_CellD) |
| WK-DMF0042-1603 | M4 | PROJECT_NAME / Project | 하네스·환경 | M4 도구 오류 — 실측[T-20fa45be]: [검사기 미검증] PROJECT_NAME: PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 34 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1604 | M4 | SCM_SITE_ID | 하네스·환경 | M4 도구 오류 — 실측[T-9b6294f2]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 5 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1605 | M4 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | M4 도구 오류 — 실측[T-9d14bd37]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1606 | M4 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | M4 도구 오류 — 실측[T-1f510aca]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1607 | M4 | SCM_SITE_ID82 / Sales Site | 하네스·환경 | M4 도구 오류 — 실측[T-88614ff5]: [검사기 미검증] PROJECT_CODE82 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1608 | M4 | btnItemId | 하네스·환경 | M4 도구 오류 — 원장 EG-b5d6caf8 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nickname SELECT_MODE / 원장 EG-63fe6597 팝업 실측 DM0002_Itemb |  | 12 (btnProject/btnItemId/btnOwner 3#10 ACT:D) |
| WK-DMF0042-1609 | M4 | btnOwner | 하네스·환경 | M4 도구 오류 — 원장 EG-030419e3 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner SELECT_MODE / 원장 EG-1740c97e 팝업 실측 DM0020_OwnerbyDivisionPo |  | 12 (btnProject/btnItemId/btnOwner 3#11 ACT:D) |
