# 대조표 ↔ 검증 추적표 v2 — DMF0005 (AS-IS DMF0005) · 2026-11-14T09:39:25

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 0행 (없음) · AS-IS 액션 4256행(진입점 + 전 문장) = **4256행** → 검사 인스턴스 **1422개**
- 행 판정: FAIL 3095 · 미검증 971 · 검증완료 190
- 인스턴스 결과: ERROR 719 · NA 362 · PASS 200 · FAIL 99 · NOPATH 28 · NOT_RUN 7 · REVIEW 7

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 10 | 2 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 5 | 1 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H2 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 3 | 5 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 5 | 0 | 0 | 0 | 7 | 2 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 6 | 48 | 0 | 2 | 42 | 12 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 3 | 1 | 0 | 0 | 8 | 1 | 0 | 7 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 4 | 0 | 0 | 0 | 8 | 1 | 0 | 7 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 2 | 8 | 0 | 0 | 0 | 3 | 0 | 2 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 5 | 0 | 0 | 0 | 15 | 3 | 0 | 6 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 10 | 0 | 0 | 50 | 38 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 25 | 5 | 0 | 0 | 35 | 13 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C6 | Cascade | 있음 | 41 | 0 | 0 | 0 | 34 | 2 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 6 | 0 | 0 | 126 | 52 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 23 | 8 | 0 | 0 | 253 | 29 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 5 | 0 | 0 | 0 | 3 | 21 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E4 | 편집·검증 | 있음 | 0 | 1 | 0 | 0 | 18 | 104 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 2 | 0 | 0 | 0 | 21 | 54 | 0 | 2 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 42 | 0 | 0 | 0 | 35 | 0 | 2 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 15 | 0 | 0 | 0 | 12 | 2 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 22 | 4 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 5 | 0 | 0 | 0 | 0 | 4 | 0 | 2 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 1 | 6 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 2 | 1 | 0 | 0 | 24 | 7 | 5 | 1 | 0 | 0 |
| 동적 생성·조회 | 19 | 48 | 0 | 4 | 51 | 16 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 14 | 9 | 0 | 0 | 31 | 8 | 0 | 22 | 0 | 0 |
| Cascade | 71 | 15 | 0 | 0 | 119 | 53 | 0 | 0 | 0 | 0 |
| 편집·검증 | 29 | 15 | 0 | 0 | 400 | 212 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 4 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 59 | 0 | 0 | 3 | 90 | 60 | 2 | 2 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 6 | 6 | 0 | 0 | 2 | 6 | 0 | 2 | 0 | 0 |

## FAIL 인스턴스

- F1|SCREEN — 원장 V-954c0b8b RULE_SCREEN / 원장 V-d14bcdbf RULE_SCREEN / 원장 V-7ec3cb83 RULE_SCREEN / 원장 V-b5ca73d1 RULE_SCREEN / 원장 V-c31ca33a DEFECT / 원장 V-e1545822 DEFECT / 원장 (대조표 1665행)
- X-ROW|ENTRY:DMF0005_ModelCodeChange.DeleteButton — 진입점 집계 3검사 — NA:1 · FAIL:1 · ERROR:1 (대조표 2행)
- F2|SCREEN — 원장 V-7f35eef7 RULE_SCREEN / 원장 V-878649d5 RULE_SCREEN / 원장 V-71eea8fa DEFECT / 원장 V-3db841a0 GENERAL / 원장 V-cab8903b GENERAL / 원장 V-09fc6db9 GENERAL / 원장 V-5792 (대조표 1656행)
- F4|SP:P_DMF0005_SAVE_MODEL_CHANGE_POPUP — 실측[T-a14fdc9e]: PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP: 셀을 수정하고 Save 를 눌렀는데 modelChange/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 '[Team] 값은 필수 입력 항목입니다. C (대조표 42행)
- F6|SCREEN — 원장 V-6798ff11 RULE_SCREEN / 원장 V-1c89495c RULE_SCREEN / 원장 V-73aebf0d RULE_SCREEN / 원장 V-1108c1e5 RULE_SCREEN / 원장 V-51334598 RULE_SCREEN / 원장 V-512014f6 RULE_S (대조표 1656행)
- X-ROW|ENTRY:DMF0005_ModelCodeChange.SaveButton — 진입점 집계 5검사 — FAIL:4 · NA:1 (대조표 1행)
- X-ROW|ENTRY:DMF0005_ModelCodeChange.SaveData — 진입점 집계 12검사 — NA:5 · FAIL:4 · PASS:2 · ERROR:1 (대조표 43행)
- J2|SCREEN — 원장 V-c807a768 RULE_SCREEN / 원장 V-dab587f4 DEFECT / 원장 V-f6148777 DEFECT / 원장 V-6910d949 DEFECT / 원장 V-96d5f27c DEFECT / 원장 V-f8f24494 GENERAL / 원장 V-e1016231 GE (대조표 110행)
- X-ROW|ENTRY:DMF0005_ModelCodeChange.btnButtonList_UsrButtonList_Click_Detected — 진입점 집계 3검사 — ERROR:1 · FAIL:1 · NA:1 (대조표 13행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged 의 C2 89요소: ERROR:48 · NA:38 · FAIL:3 · FAIL 요소: DIVISION_ID — 원장 V-dc313343 / 실측[T-dd (대조표 7행)
- C3|ENTRY:DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged 의 C3 67요소: ERROR:30 · PASS:23 · NA:12 · FAIL:2 · FAIL 요소: SOLDTO_DESCRIPTION / Sold-T (대조표 7행)
- G4|COND:chkDetail — E2E smoke labels — 누락 라벨 (대조표 10행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.DefineProperty — 진입점 집계 6검사 — PASS:2 · NA:1 · FAIL:1 · NOT_RUN:1 · NOPATH:1 (대조표 18행)
- D1|COL:DEPT_ID — 원장 V-c6d33cd5 COLUMN / 원장 V-6575c118 COLUMN / 실측[T-d2c09b6f]: 기존행 r0 DEPT_ID 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[{"g": "COL(EDIT_FLAG)==\"Y\" && COL(DIVIS (대조표 6행)
- D1|COL:END_CUSTOMER — 원장 V-13b6f6b8 COLUMN / 원장 V-e04685cd COLUMN / 실측[T-44475804]: 기존행 r0 END_CUSTOMER 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[{"g": "COL(EDIT_FLAG)==\"Y\" && COL( (대조표 6행)
- D1|COL:OWNER — 원장 V-18ee80f9 COLUMN / 원장 V-aedf3fc3 COLUMN / 원장 V-57c41c2a COLUMN / 원장 V-41882468 COLUMN / 원장 V-65e05c15 ASIS / 원장 V-3cde637b ASIS / 원장 V-af84e0dc ASIS / 원장 V- (대조표 18행)
- D1|COL:SCM_SITE_ID — 원장 V-bcd6931a COLUMN / 원장 V-f85ecfbe COLUMN / 원장 V-dd8cb674 COLUMN / 원장 V-28de58de COLUMN / 실측[T-e7bcaf27]: 기존행 r0 SCM_SITE_ID 편집=false — AS-IS 조건부(행 값으로 계산 불가) (대조표 8행)
- D1|COL:ITEM_ID — 원장 V-5f6b530c COLUMN / 원장 V-0c72f0b3 COLUMN / 원장 V-9666e04d COLUMN / 원장 V-0840bfbc COLUMN / 원장 V-c25f8d1c ASIS / 원장 V-917b41f2 ASIS / 원장 V-5976e538 ASIS / 원장 V- (대조표 16행)
- D3|COL:OWNER — 원장 V-267487d4 ASIS / 원장 V-4e03b11a ASIS / 원장 V-65d69908 ASIS / 원장 V-d3017ea4 ASIS / 원장 V-5c9f7db9 ASIS / 원장 V-d4b33fa1 ASIS / 원장 V-aaeb61a5 ASIS / 원장 V-f150ed14 (대조표 18행)
- D3|COL:EDIT_FLAG — 원장 V-a5d8e80d ASIS / 원장 V-a27b6577 ASIS / 원장 V-9ccefd53 ASIS / 원장 V-267487d4 ASIS / 원장 V-50218cda ASIS / 원장 V-1d9c9494 ASIS / 원장 V-ded45edb ASIS / 원장 V-9306d274 (대조표 259행)
- D1|ENTRY:DMF0005_SaleSite_PjtModelMapping.EditButton — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.EditButton 의 D1 60요소: ERROR:33 · NA:22 · FAIL:5 · FAIL 요소: DEPT_ID / Team — 원장 V-c6d33cd5 COLUMN / 원장 V-6575c118 C (대조표 20행)
- D3|ENTRY:DMF0005_SaleSite_PjtModelMapping.EditButton — 원장 V-56561213 ASIS / 원장 V-a5d8e80d ASIS / 원장 V-a27b6577 ASIS / 원장 V-9ccefd53 ASIS / 원장 V-267487d4 ASIS / 원장 V-50218cda ASIS / 원장 V-1d9c9494 ASIS / 원장 V-ded45edb (대조표 20행)
- D3|LEDGER:V-65d69908 — 원장 V-65d69908 / 실측[T-f9153932]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)) / if (sDivis (대조표 1행)
- D3|COL:ATTRIBUTE1 — 원장 V-a73af24a ASIS / 원장 V-d766e6e5 ASIS / 원장 V-b2185c24 ASIS / 원장 V-3b267421 ASIS (대조표 4행)
- D3|COL:ATTRIBUTE2 — 원장 V-ccb7fc69 ASIS / 원장 V-e914ef7f ASIS / 원장 V-6ddc3f41 ASIS / 원장 V-9fbe330c ASIS (대조표 4행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.FindData_Main — 진입점 집계 26검사 — PASS:10 · ERROR:9 · NA:4 · REVIEW:2 · FAIL:1 (대조표 15행)
- E4|MSG:MSG00097 — 실측[T-282bf707]: MSG00097: 위반 대상 CELL_TYPE_82 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 2행)
- B3|ENTRY:DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM 의 B3 9요소: FAIL:3 · NA:3 · NOPATH:2 · PASS:1 · FAIL 요소: clbEndCustomer / End Customer — 원장 V-0 (대조표 9행)
- F4|ENTRY:DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM 의 F4 7요소: FAIL:2 · NA:2 · ERROR:2 · PASS:1 · FAIL 요소: PKG_DMF0005.P_DMF0005_SAVE_MOD — 실측[T-a (대조표 2행)
- B3|ENTRY:DMF0005_SaleSite_PjtModelMapping.GetItemType — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetItemType 의 B3 9요소: FAIL:3 · NA:3 · NOPATH:2 · PASS:1 · FAIL 요소: clbEndCustomer / End Customer — 원장 V-060991e4 S (대조표 4행)
- B3|ENTRY:DMF0005_SaleSite_PjtModelMapping.GetScmSiteInfobyDivision — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetScmSiteInfobyDivision 의 B3 9요소: FAIL:3 · NA:3 · NOPATH:2 · PASS:1 · FAIL 요소: clbEndCustomer / End Customer — 원장 (대조표 5행)
- B3|ENTRY:DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM 의 B3 9요소: FAIL:3 · NA:3 · NOPATH:2 · PASS:1 · FAIL 요소: clbEndCustomer / End Customer — 원장 (대조표 9행)
- F4|ENTRY:DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM 의 F4 7요소: FAIL:2 · NA:2 · ERROR:2 · PASS:1 · FAIL 요소: PKG_DMF0005.P_DMF0005_SAVE_MOD — 실측 (대조표 2행)
- B3|ENTRY:DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM 의 B3 9요소: FAIL:3 · NA:3 · NOPATH:2 · PASS:1 · FAIL 요소: clbEndCustomer / End Customer — 원장 (대조표 9행)
- F4|ENTRY:DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM 의 F4 7요소: FAIL:2 · NA:2 · ERROR:2 · PASS:1 · FAIL 요소: PKG_DMF0005.P_DMF0005_SAVE_MOD — 실측 (대조표 2행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.InsertRow — 진입점 집계 103검사 — ERROR:46 · NA:22 · NOPATH:20 · PASS:13 · FAIL:2 (대조표 106행)
- C2|LEDGER:V-dc313343 — 원장 V-dc313343 / 실측[T-ddefab1a]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (대조표 1행)
- B1|COL:END_CUSTOMER — 원장 V-35a67f39 COLUMN (대조표 6행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain — 진입점 집계 61검사 — ERROR:49 · NA:9 · FAIL:3 (대조표 22행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain40 — 진입점 집계 87검사 — ERROR:61 · NA:14 · PASS:6 · FAIL:6 (대조표 32행)
- D3|LEDGER:V-d766e6e5 — 원장 V-d766e6e5 (대조표 1행)
- D3|LEDGER:V-e914ef7f — 원장 V-e914ef7f (대조표 1행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain82 — 진입점 집계 73검사 — ERROR:62 · NA:8 · FAIL:3 (대조표 37행)
- F4|SP:P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION — 실측[T-c9b014c3]: PKG_DMF0005.P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION: 셀을 수정하고 Save 를 눌렀는데 production/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 '[Team] 값은 필수 입력  (대조표 1614행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.SaveData — 진입점 집계 62검사 — NA:46 · ERROR:6 · PASS:6 · FAIL:4 (대조표 17행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.SetChangeControl — 진입점 집계 16검사 — NA:7 · ERROR:5 · PASS:3 · FAIL:1 (대조표 4행)
- B3|COND:clbEndCustomer — 원장 V-060991e4 SEARCH (대조표 1행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.btnItemId_Click — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.btnModelChange_Click — 진입점 집계 4검사 — ERROR:3 · FAIL:1 (대조표 4행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.btnOwner_Click — 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.btnProject_Click — 진입점 집계 9검사 — ERROR:5 · NA:3 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.chkDetail_CheckedChanged — 진입점 집계 1검사 — FAIL:1 (대조표 4행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged 의 C2 89요소: ERROR:48 · NA:38 · FAIL:3 · FAIL 요소: DIVISION_ID — 원장 V-dc313343 / 실측[ (대조표 24행)
- C3|ENTRY:DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged 의 C3 67요소: ERROR:30 · PASS:23 · NA:12 · FAIL:2 · FAIL 요소: SOLDTO_DESCRIPTION / So (대조표 24행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged 의 C2 89요소: ERROR:48 · NA:38 · FAIL:3 · FAIL 요소: DIVISION_ID — 원장 V-dc313343 /  (대조표 3행)
- C3|ENTRY:DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged 의 C3 67요소: ERROR:30 · PASS:23 · NA:12 · FAIL:2 · FAIL 요소: SOLDTO_DESCRIPTION / (대조표 3행)
- C2|COL:DIVISION_ID — 원장 V-dc313343 ASIS / 원장 V-23d11e91 ASIS / 원장 V-305469f5 ASIS / 원장 V-fec9d837 ASIS / 원장 V-f362224a ASIS / 원장 V-24a119c4 ASIS / 원장 V-3f009e53 ASIS / 원장 V-8363a287 (대조표 151행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed 의 C2 9요소: ERROR:6 · NA:2 · FAIL:1 · FAIL 요소: DIVISION_ID / Division — 원장 V-dc313343 ASIS  (대조표 4행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed — 진입점 집계 45검사 — ERROR:36 · NA:4 · PASS:3 · FAIL:2 (대조표 9행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdMain_Changed — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdMain_Changed 의 C2 3요소: NA:2 · FAIL:1 · FAIL 요소: DIVISION_ID / Division — 원장 V-dc313343 ASIS / 원장 V-23d11e91 ASI (대조표 5행)
- B3|COL:SCM_SITE_ID — 원장 V-ecbd8999 COLUMN (대조표 2행)
- F3|SCREEN — 원장 V-2b23d040 RULE_SCREEN / 원장 V-91443431 RULE_SCREEN / 원장 V-1b5024bd RULE_SCREEN / 원장 V-8c95d427 RULE_SCREEN / 원장 V-a93d97ce RULE_SCREEN / 원장 V-3a093adc RULE_S (대조표 76행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdMain_ClipboardPasted — 진입점 집계 9검사 — NA:4 · PASS:3 · FAIL:1 · ERROR:1 (대조표 1행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdMain_ComboSelChange — 진입점 집계 83검사 — PASS:38 · ERROR:21 · NA:13 · NOPATH:7 · FAIL:4 (대조표 9행)
- C3|COL:SOLDTO_DESCRIPTION — 원장 V-d6036625 ASIS / 원장 V-126fbd55 ASIS / 실측[T-f2302b26]: 신규행 연쇄 SCM_SITE_ID → SOLDTO_DESCRIPTION: SCM_SITE_ID='1X Technologies_US_PAO' → SOLDTO_DESCRIPTION=''  (대조표 4행)
- C3|COL:SHIPTO_DESCRIPTION — 원장 V-056b1d64 ASIS / 원장 V-9267d4b5 ASIS / 실측[T-b8e9a49a]: 신규행 연쇄 SCM_SITE_ID → SHIPTO_DESCRIPTION: SCM_SITE_ID='1X Technologies_US_PAO' → SHIPTO_DESCRIPTION=''  (대조표 4행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdSub_Changed — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_Changed 의 C2 3요소: NA:2 · FAIL:1 · FAIL 요소: DIVISION_ID / Division — 원장 V-dc313343 ASIS / 원장 V-23d11e91 ASIS (대조표 5행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdSub_ClipboardPasted — 진입점 집계 9검사 — PASS:4 · NA:3 · FAIL:1 · ERROR:1 (대조표 1행)
- C2|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSelChange — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSelChange 의 C2 5요소: ERROR:2 · NA:2 · FAIL:1 · FAIL 요소: DIVISION_ID / Division — 원장 V-dc313343 ASIS / 원 (대조표 6행)
- X-ROW|ENTRY:DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSelChange — 진입점 집계 20검사 — PASS:9 · ERROR:6 · NA:3 · FAIL:2 (대조표 1행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged — 진입점 집계 12검사 — PASS:5 · ERROR:5 · FAIL:1 · NA:1 (대조표 15행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.DefineProperty — 진입점 집계 7검사 — PASS:2 · NA:1 · FAIL:1 · NOT_RUN:1 · ERROR:1 · NOPATH:1 (대조표 37행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.DeleteButton — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.EditButton — 진입점 집계 222검사 — ERROR:173 · NA:31 · FAIL:9 · PASS:9 (대조표 149행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.FindData_Main — 진입점 집계 26검사 — PASS:10 · ERROR:9 · NA:4 · REVIEW:2 · FAIL:1 (대조표 79행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.GetCombo — 진입점 집계 8검사 — PASS:4 · NOT_RUN:1 · NOPATH:1 · ERROR:1 · FAIL:1 (대조표 19행)
- F4|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.GetCombo — 진입점 집계 — 대조표 DMF0005_T_SaleSite_PjtModelMapping.GetCombo 의 F4 7요소: FAIL:2 · NA:2 · ERROR:2 · PASS:1 · FAIL 요소: PKG_DMF0005.P_DMF0005_SAVE_MOD — 실측[T-a14fdc9e]:  (대조표 2행)
- B3|COND:clbTeam — 원장 V-9c8958f4 SEARCH (대조표 1행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.InsertRow — 진입점 집계 89검사 — ERROR:42 · NA:18 · NOPATH:14 · PASS:13 · FAIL:2 (대조표 172행)
- C2|LEDGER:V-8363a287 — 원장 V-8363a287 / 실측[T-e101167c]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (대조표 1행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain — 진입점 집계 59검사 — ERROR:47 · NA:9 · FAIL:3 (대조표 41행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain40 — 진입점 집계 79검사 — ERROR:57 · NA:14 · FAIL:4 · PASS:4 (대조표 57행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain82 — 진입점 집계 71검사 — ERROR:60 · NA:8 · FAIL:3 (대조표 70행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.SaveButton — 진입점 집계 8검사 — FAIL:4 · ERROR:3 · PASS:1 (대조표 1행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.SaveData — 진입점 집계 62검사 — NA:45 · ERROR:7 · PASS:6 · FAIL:4 (대조표 787행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.btnItemId_Click — 진입점 집계 11검사 — PASS:5 · NA:3 · ERROR:2 · FAIL:1 (대조표 22행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.btnModelChange_Click — 진입점 집계 7검사 — ERROR:4 · NA:2 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.btnOwner_Click — 진입점 집계 11검사 — PASS:5 · NA:3 · ERROR:2 · FAIL:1 (대조표 21행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.btnProject_Click — 진입점 집계 11검사 — ERROR:7 · NA:3 · FAIL:1 (대조표 22행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.chkDetail_CheckedChanged — 진입점 집계 2검사 — ERROR:1 · FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged — 진입점 집계 16검사 — ERROR:7 · PASS:6 · NA:2 · FAIL:1 (대조표 68행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged — 진입점 집계 8검사 — PASS:4 · ERROR:3 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.shtMainDataModel_Changed — 진입점 집계 43검사 — ERROR:35 · NA:4 · PASS:3 · FAIL:1 (대조표 64행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdMain_Changed — 진입점 집계 36검사 — PASS:15 · NA:12 · ERROR:8 · FAIL:1 (대조표 33행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdMain_ClipboardPasted — 진입점 집계 18검사 — PASS:7 · NA:6 · ERROR:4 · FAIL:1 (대조표 27행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdMain_ComboSelChange — 진입점 집계 83검사 — PASS:38 · ERROR:21 · NA:13 · NOPATH:7 · FAIL:4 (대조표 84행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdSub_Changed — 진입점 집계 36검사 — PASS:15 · NA:12 · ERROR:8 · FAIL:1 (대조표 32행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdSub_ClipboardPasted — 진입점 집계 18검사 — PASS:7 · NA:6 · ERROR:4 · FAIL:1 (대조표 27행)
- X-ROW|ENTRY:DMF0005_T_SaleSite_PjtModelMapping.spdSub_ComboSelChange — 진입점 집계 24검사 — PASS:11 · ERROR:7 · NA:5 · FAIL:1 (대조표 26행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbTeam — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbEndCustomer — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbSalesSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:cboActive — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- H6|COND:cboActive — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:clbDivision — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
