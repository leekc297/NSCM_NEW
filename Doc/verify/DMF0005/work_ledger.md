# 작업 원장 — DMF0005 · 2026-11-14 09:39

> 검사 인스턴스 1422건 중 PASS·NA 562건 외 **860건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 99 | 재판정 PASS |
| W5 | 검사기 연결 | 28 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 7 | 실행 → PASS |
| W7 | 기대값 확정 | 7 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 719 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 719 · 화면 FE 76 · 하네스 28 · FE 13 · E2E 7 · 사람 판정 / AS-IS 원문 확인 → 재판정 7 · DB 6 · DB 객체 2 · DB 메타 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  | 8 |  |  |  |  |  | 253 | 행 값 기반 조건부 잠금 |
| D1 | EDIT |  |  | 6 |  |  |  |  |  | 126 | 컬럼 편집 가능 여부(신규행·기존행) |
| X-ROW | GEN |  |  | 48 |  |  |  | 2 |  | 42 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C2 | CASCADE |  |  | 10 |  |  |  |  |  | 50 | 그리드 셀 cascade 후보 |
| C3 | CASCADE |  |  | 5 |  |  |  |  |  | 35 | 연쇄 자동 채움 |
| H6 | POPUP |  |  |  |  |  | 2 |  |  | 35 | 팝업 표준·열림 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 34 | 무변경 편집 종료 시 연쇄 미발동 |
| M4 | POPUP |  |  |  |  |  |  | 3 |  | 22 | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 2 |  |  |  | 21 | 팝업 조건 연동(인자) |
| B4 | COMBO |  |  |  |  | 6 |  |  |  | 15 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E4 | EDIT |  |  | 1 |  |  |  |  |  | 18 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| B1 | COMBO |  |  | 1 |  | 7 |  |  |  | 8 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 7 |  |  |  | 8 | 콤보 후보 중복 없음 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 12 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| B3 | COMBO |  |  | 8 |  | 2 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 10 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| F4 | DB |  |  | 6 |  |  |  |  |  | 2 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  | 1 |  | 1 | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| G1 | GEN |  |  |  |  |  |  |  |  | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 3 | 배경·글자색 규칙 |
| D5 | EDIT |  |  |  |  |  |  |  |  | 3 | 셀 에디터 유형 |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| A1 | GEN |  |  |  |  |  |  | 2 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | GEN |  |  |  |  |  |  |  |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| F3 | CRUD |  |  | 1 |  |  |  |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (99)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0005-0001 | J2 | DMF0005 화면 | DB 객체(PKG/SP)(적용 예정) | J2 FAIL 수정 — DMF0005 화면: 원장 V-c807a768 RULE_SCREEN / 원장 V-dab587f4 DEFECT / 원장 V-f6148777 DEFECT / 원장 V-6910d949 DEFECT / 원장 V-96d |  | 110 (ACT:DMF0005_ModelCodeChange.btnButtonLis) |
| WK-DMF0005-0002 | C2 | DIVISION_ID | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DIVISION_ID: 원장 V-dc313343 / 실측[T-ddefab1a]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (FX-DMF0005-1 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0003 | C2 | DIVISION_ID | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DIVISION_ID: 원장 V-8363a287 / 실측[T-e101167c]: 신규행 DIVISION_ID 콤보 후보 없음 — 내 Division 목록 콤보 미구현(D00-3-009) (FX-DMF0005-1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0004 | C2 | DIVISION_ID / Division | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DIVISION_ID / Division: 원장 V-dc313343 ASIS / 원장 V-23d11e91 ASIS / 원장 V-305469f5 ASIS / 원장 V-fec9d837 ASIS / 원장 V-f362 |  | 134 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0005 | C2 | DMF0005_SaleSite_PjtModelMapping.ClbTeam | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChange: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.ClbTeam_S |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.Clb) |
| WK-DMF0005-0006 | C2 | DMF0005_SaleSite_PjtModelMapping.clbDivi | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexCh: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbDivisi |  | 24 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0007 | C2 | DMF0005_SaleSite_PjtModelMapping.clbEndC | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedInde: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbEndCus |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0008 | C2 | DMF0005_SaleSite_PjtModelMapping.shtMain | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.shtMainDataM |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0009 | C2 | DMF0005_SaleSite_PjtModelMapping.spdMain | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdMain_Changed: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdMain_Changed 의 C2  |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0010 | C2 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdSub_Changed: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_Changed 의 C2 3요 |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0011 | C2 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 화면 FE(범위 밖(가이드만)) | C2 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSelChange: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSel |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0012 | C3 | DMF0005_SaleSite_PjtModelMapping.ClbTeam | 화면 FE(범위 밖(가이드만)) | C3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChange: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.ClbTeam_S |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.Clb) |
| WK-DMF0005-0013 | C3 | DMF0005_SaleSite_PjtModelMapping.clbDivi | 화면 FE(범위 밖(가이드만)) | C3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexCh: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbDivisi |  | 24 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0014 | C3 | DMF0005_SaleSite_PjtModelMapping.clbEndC | 화면 FE(범위 밖(가이드만)) | C3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedInde: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbEndCus |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0015 | C3 | SHIPTO_DESCRIPTION / Rep Ship-To | 화면 FE(범위 밖(가이드만)) | C3 FAIL 수정 — SHIPTO_DESCRIPTION / Rep Ship-To: 원장 V-056b1d64 ASIS / 원장 V-9267d4b5 ASIS / 실측[T-b8e9a49a]: 신규행 연쇄 SCM_SITE_ID → SHIP |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0016 | C3 | SOLDTO_DESCRIPTION / Sold-To | 화면 FE(범위 밖(가이드만)) | C3 FAIL 수정 — SOLDTO_DESCRIPTION / Sold-To: 원장 V-d6036625 ASIS / 원장 V-126fbd55 ASIS / 실측[T-f2302b26]: 신규행 연쇄 SCM_SITE_ID → SOLDTO_D |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0017 | B1 | END_CUSTOMER / End Customer | 화면 FE(범위 밖(가이드만)) | B1 FAIL 수정 — END_CUSTOMER / End Customer: 원장 V-35a67f39 COLUMN (FX-DMF0005-017) |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0018 | B3 | DMF0005_SaleSite_PjtModelMapping.GetComm | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetCommonDataLis |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0019 | B3 | DMF0005_SaleSite_PjtModelMapping.GetItem | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.GetItemType: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetItemType 의 B3 9요소: FAI |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0020 | B3 | DMF0005_SaleSite_PjtModelMapping.GetScmS | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.GetScmSiteInfobyDivision: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetScmSiteIn |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0021 | B3 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0022 | B3 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0023 | B3 | SCM_SITE_ID / Sales Site | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — SCM_SITE_ID / Sales Site: 원장 V-ecbd8999 COLUMN (FX-DMF0005-021) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0024 | B3 | clbEndCustomer / End Customer | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — clbEndCustomer / End Customer: 원장 V-060991e4 SEARCH (FX-DMF0005-012) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0025 | B3 | clbTeam / Team | 화면 FE(범위 밖(가이드만)) | B3 FAIL 수정 — clbTeam / Team: 원장 V-9c8958f4 SEARCH (FX-DMF0005-013) |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0026 | F1 | DMF0005 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F1 FAIL 수정 — DMF0005 화면: 원장 V-954c0b8b RULE_SCREEN / 원장 V-d14bcdbf RULE_SCREEN / 원장 V-7ec3cb83 RULE_SCREEN / 원장 V-b5ca73d1 RULE_SC |  | 1665 (ACT:DMF0005_ModelCodeChange.DeleteButton) |
| WK-DMF0005-0027 | F2 | DMF0005 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F2 FAIL 수정 — DMF0005 화면: 원장 V-7f35eef7 RULE_SCREEN / 원장 V-878649d5 RULE_SCREEN / 원장 V-71eea8fa DEFECT / 원장 V-3db841a0 GENERAL / 원장 |  | 1656 (ACT:DMF0005_ModelCodeChange.SaveButton A) |
| WK-DMF0005-0028 | F3 | DMF0005 화면 | 화면 FE(범위 밖(가이드만)) | F3 FAIL 수정 — DMF0005 화면: 원장 V-2b23d040 RULE_SCREEN / 원장 V-91443431 RULE_SCREEN / 원장 V-1b5024bd RULE_SCREEN / 원장 V-8c95d427 RULE_SC |  | 70 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0029 | F6 | DMF0005 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F6 FAIL 수정 — DMF0005 화면: 원장 V-6798ff11 RULE_SCREEN / 원장 V-1c89495c RULE_SCREEN / 원장 V-73aebf0d RULE_SCREEN / 원장 V-1108c1e5 RULE_SC |  | 1656 (ACT:DMF0005_ModelCodeChange.SaveButton A) |
| WK-DMF0005-0030 | F4 | DMF0005_SaleSite_PjtModelMapping.GetComm | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetCommonDataLis |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0031 | F4 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0032 | F4 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0033 | F4 | DMF0005_T_SaleSite_PjtModelMapping.GetCo | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.GetCombo: 진입점 집계 — 대조표 DMF0005_T_SaleSite_PjtModelMapping.GetCombo 의 F4 7요소: FAIL: |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0034 | F4 | PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_ | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP: 실측[T-a14fdc9e]: PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP: 셀을 수정하고 |  | 42 (ACT:DMF0005_ModelCodeChange.SaveButton A) |
| WK-DMF0005-0035 | F4 | PKG_DMF0005.P_DMF0005_SAVE_SALES_SITE_MO | DB(🛠️/🧯 적용 가능) | F4 FAIL 수정 — PKG_DMF0005.P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION: 실측[T-c9b014c3]: PKG_DMF0005.P_DMF0005_SAVE_SALES_SITE_MODEL_P |  | 1614 (ACT:DMF0005_SaleSite_PjtModelMapping.Sav) |
| WK-DMF0005-0036 | G4 | chkDetail / Detail | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — chkDetail / Detail: E2E smoke labels — 누락 라벨 |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Def) |
| WK-DMF0005-0037 | D1 | DEPT_ID / Team | DB 메타(적용 예정) | D1 FAIL 수정 — DEPT_ID / Team: 원장 V-c6d33cd5 COLUMN / 원장 V-6575c118 COLUMN / 실측[T-d2c09b6f]: 기존행 r0 DEPT_ID 편집=false — AS-IS 조건부(행 값 |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0038 | D1 | DMF0005_SaleSite_PjtModelMapping.EditBut | DB 메타(적용 예정) | D1 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.EditButton: 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.EditButton 의 D1 60요소: ERRO |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0039 | D1 | END_CUSTOMER / End Customer | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — END_CUSTOMER / End Customer: 원장 V-13b6f6b8 COLUMN / 원장 V-e04685cd COLUMN / 실측[T-44475804]: 기존행 r0 END_CUSTOMER 편집=fal |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0040 | D1 | ITEM_ID / Model | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — ITEM_ID / Model: 원장 V-5f6b530c COLUMN / 원장 V-0c72f0b3 COLUMN / 원장 V-9666e04d COLUMN / 원장 V-0840bfbc COLUMN / 원장 V-c25 |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0041 | D1 | OWNER / Owner Name | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — OWNER / Owner Name: 원장 V-18ee80f9 COLUMN / 원장 V-aedf3fc3 COLUMN / 원장 V-57c41c2a COLUMN / 원장 V-41882468 COLUMN / 원장 V- |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0042 | D1 | SCM_SITE_ID / Sales Site | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — SCM_SITE_ID / Sales Site: 원장 V-bcd6931a COLUMN / 원장 V-f85ecfbe COLUMN / 원장 V-dd8cb674 COLUMN / 원장 V-28de58de COLUMN / |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0043 | D3 | ATTRIBUTE1 / 양극재 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — ATTRIBUTE1 / 양극재: 원장 V-a73af24a ASIS / 원장 V-d766e6e5 ASIS / 원장 V-b2185c24 ASIS / 원장 V-3b267421 ASIS (FX-DMF0005-032) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0044 | D3 | ATTRIBUTE1,ATTRIBUTE1 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — ATTRIBUTE1,ATTRIBUTE1: 원장 V-d766e6e5 (FX-DMF0005-032) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0045 | D3 | ATTRIBUTE2 / End Cust.(Report | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — ATTRIBUTE2 / End Cust.(Report: 원장 V-ccb7fc69 ASIS / 원장 V-e914ef7f ASIS / 원장 V-6ddc3f41 ASIS / 원장 V-9fbe330c ASIS (FX- |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0046 | D3 | ATTRIBUTE2,ATTRIBUTE2 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — ATTRIBUTE2,ATTRIBUTE2: 원장 V-e914ef7f (FX-DMF0005-033) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0047 | D3 | DMF0005_SaleSite_PjtModelMapping.EditBut | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.EditButton: 원장 V-56561213 ASIS / 원장 V-a5d8e80d ASIS / 원장 V-a27b6577 ASIS / 원장 V-9cce |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0048 | D3 | EDIT_FLAG / Edit Flag | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — EDIT_FLAG / Edit Flag: 원장 V-a5d8e80d ASIS / 원장 V-a27b6577 ASIS / 원장 V-9ccefd53 ASIS / 원장 V-267487d4 ASIS / 원장 V-50218 |  | 259 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0049 | D3 | OWNER / Owner Name | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — OWNER / Owner Name: 원장 V-267487d4 ASIS / 원장 V-4e03b11a ASIS / 원장 V-65d69908 ASIS / 원장 V-d3017ea4 ASIS / 원장 V-5c9f7db9 |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0050 | D3 | OWNER,OWNER | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — OWNER,OWNER: 원장 V-65d69908 / 실측[T-f9153932]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, s |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0051 | E4 | MSG00097 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00097: 실측[T-282bf707]: MSG00097: 위반 대상 CELL_TYPE_82 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (FX-DMF0005-111) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0052 | X-ROW | DMF0005_ModelCodeChange.DeleteButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_ModelCodeChange.DeleteButton: 진입점 집계 3검사 — NA:1 · FAIL:1 · ERROR:1 |  | 2 (ACT:DMF0005_ModelCodeChange.DeleteButton) |
| WK-DMF0005-0053 | X-ROW | DMF0005_ModelCodeChange.SaveButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_ModelCodeChange.SaveButton: 진입점 집계 5검사 — FAIL:4 · NA:1 |  | 1 (ACT:DMF0005_ModelCodeChange.SaveButton:1) |
| WK-DMF0005-0054 | X-ROW | DMF0005_ModelCodeChange.SaveData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_ModelCodeChange.SaveData: 진입점 집계 12검사 — NA:5 · FAIL:4 · PASS:2 · ERROR:1 |  | 39 (ACT:DMF0005_ModelCodeChange.SaveData:182) |
| WK-DMF0005-0055 | X-ROW | DMF0005_ModelCodeChange.btnButtonList_Us | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_ModelCodeChange.btnButtonList_UsrButtonList_Click_De: 진입점 집계 3검사 — ERROR:1 · FAIL:1 · NA:1 (FX-DMF0005-087 |  | 13 (ACT:DMF0005_ModelCodeChange.btnButtonLis) |
| WK-DMF0005-0056 | X-ROW | DMF0005_SaleSite_PjtModelMapping.DefineP | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.DefineProperty: 진입점 집계 6검사 — PASS:2 · NA:1 · FAIL:1 · NOT_RUN:1 · NOPATH:1 (FX-DM |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.Def) |
| WK-DMF0005-0057 | X-ROW | DMF0005_SaleSite_PjtModelMapping.FindDat | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.FindData_Main: 진입점 집계 26검사 — PASS:10 · ERROR:9 · NA:4 · REVIEW:2 · FAIL:1 (FX-DMF |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0058 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InsertR | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.InsertRow: 진입점 집계 103검사 — ERROR:46 · NA:22 · NOPATH:20 · PASS:13 · FAIL:2 (FX-DMF |  | 77 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0059 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InsertR | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain: 진입점 집계 61검사 — ERROR:49 · NA:9 · FAIL:3 (FX-DMF0005-120) |  | 22 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0060 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InsertR | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain40: 진입점 집계 87검사 — ERROR:61 · NA:14 · PASS:6 · FAIL:6 (FX-DM |  | 32 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0061 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InsertR | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.InsertRowLockRangeMain82: 진입점 집계 73검사 — ERROR:62 · NA:8 · FAIL:3 (FX-DMF0005-122) |  | 36 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0062 | X-ROW | DMF0005_SaleSite_PjtModelMapping.SaveDat | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.SaveData: 진입점 집계 62검사 — NA:46 · ERROR:6 · PASS:6 · FAIL:4 |  | 13 (ACT:DMF0005_SaleSite_PjtModelMapping.Sav) |
| WK-DMF0005-0063 | X-ROW | DMF0005_SaleSite_PjtModelMapping.SetChan | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.SetChangeControl: 진입점 집계 16검사 — NA:7 · ERROR:5 · PASS:3 · FAIL:1 (FX-DMF0005-123) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0064 | X-ROW | DMF0005_SaleSite_PjtModelMapping.btnItem | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.btnItemId_Click: 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:1 · FAIL:1 (FX-DMF0005-124) |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0065 | X-ROW | DMF0005_SaleSite_PjtModelMapping.btnMode | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.btnModelChange_Click: 진입점 집계 4검사 — ERROR:3 · FAIL:1 (FX-DMF0005-125) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0066 | X-ROW | DMF0005_SaleSite_PjtModelMapping.btnOwne | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.btnOwner_Click: 진입점 집계 9검사 — PASS:4 · NA:3 · ERROR:1 · FAIL:1 (FX-DMF0005-126) |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0067 | X-ROW | DMF0005_SaleSite_PjtModelMapping.btnProj | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.btnProject_Click: 진입점 집계 9검사 — ERROR:5 · NA:3 · FAIL:1 (FX-DMF0005-127) |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0068 | X-ROW | DMF0005_SaleSite_PjtModelMapping.chkDeta | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.chkDetail_CheckedChanged: 진입점 집계 1검사 — FAIL:1 (FX-DMF0005-128) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.chk) |
| WK-DMF0005-0069 | X-ROW | DMF0005_SaleSite_PjtModelMapping.shtMain | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed: 진입점 집계 45검사 — ERROR:36 · NA:4 · PASS:3 · FAIL:2 (FX-DMF |  | 9 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0070 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdMain | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdMain_ClipboardPasted: 진입점 집계 9검사 — NA:4 · PASS:3 · FAIL:1 · ERROR:1 (FX-DMF000 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0071 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdMain | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdMain_ComboSelChange: 진입점 집계 83검사 — PASS:38 · ERROR:21 · NA:13 · NOPATH:7 · FAI |  | 9 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0072 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdSub_ClipboardPasted: 진입점 집계 9검사 — PASS:4 · NA:3 · FAIL:1 · ERROR:1 (FX-DMF0005 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0073 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_SaleSite_PjtModelMapping.spdSub_ComboSelChange: 진입점 집계 20검사 — PASS:9 · ERROR:6 · NA:3 · FAIL:2 (FX-DMF0005 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0074 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.ClbTe | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChan: 진입점 집계 12검사 — PASS:5 · ERROR:5 · FAIL:1 · NA:1 (FX-D |  | 13 (ACT:DMF0005_T_SaleSite_PjtModelMapping.C) |
| WK-DMF0005-0075 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Defin | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.DefineProperty: 진입점 집계 7검사 — PASS:2 · NA:1 · FAIL:1 · NOT_RUN:1 · ERROR:1 · NOP |  | 19 (ACT:DMF0005_T_SaleSite_PjtModelMapping.D) |
| WK-DMF0005-0076 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Delet | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.DeleteButton: 진입점 집계 3검사 — ERROR:2 · FAIL:1 |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.D) |
| WK-DMF0005-0077 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.EditB | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.EditButton: 진입점 집계 222검사 — ERROR:173 · NA:31 · FAIL:9 · PASS:9 (FX-DMF0005-149) |  | 149 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0078 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.FindD | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.FindData_Main: 진입점 집계 26검사 — PASS:10 · ERROR:9 · NA:4 · REVIEW:2 · FAIL:1 (FX-D |  | 63 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0079 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.GetCo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.GetCombo: 진입점 집계 8검사 — PASS:4 · NOT_RUN:1 · NOPATH:1 · ERROR:1 · FAIL:1 (FX-DMF |  | 17 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0080 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Inser | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.InsertRow: 진입점 집계 89검사 — ERROR:42 · NA:18 · NOPATH:14 · PASS:13 · FAIL:2 (FX-DM |  | 70 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0081 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Inser | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain: 진입점 집계 59검사 — ERROR:47 · NA:9 · FAIL:3 (FX-DMF0005-156) |  | 21 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0082 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Inser | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain40: 진입점 집계 79검사 — ERROR:57 · NA:14 · FAIL:4 · PASS:4 (FX- |  | 29 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0083 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Inser | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.InsertRowLockRangeMain82: 진입점 집계 71검사 — ERROR:60 · NA:8 · FAIL:3 (FX-DMF0005-15 |  | 35 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0084 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.SaveB | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.SaveButton: 진입점 집계 8검사 — FAIL:4 · ERROR:3 · PASS:1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.S) |
| WK-DMF0005-0085 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.SaveD | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.SaveData: 진입점 집계 62검사 — NA:45 · ERROR:7 · PASS:6 · FAIL:4 |  | 770 (ACT:DMF0005_T_SaleSite_PjtModelMapping.S) |
| WK-DMF0005-0086 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.btnIt | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.btnItemId_Click: 진입점 집계 11검사 — PASS:5 · NA:3 · ERROR:2 · FAIL:1 (FX-DMF0005-159 |  | 13 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0087 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.btnMo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.btnModelChange_Click: 진입점 집계 7검사 — ERROR:4 · NA:2 · FAIL:1 (FX-DMF0005-160) |  | 5 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0088 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.btnOw | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.btnOwner_Click: 진입점 집계 11검사 — PASS:5 · NA:3 · ERROR:2 · FAIL:1 (FX-DMF0005-161) |  | 12 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0089 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.btnPr | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.btnProject_Click: 진입점 집계 11검사 — ERROR:7 · NA:3 · FAIL:1 (FX-DMF0005-162) |  | 13 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0090 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.chkDe | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.chkDetail_CheckedChanged: 진입점 집계 2검사 — ERROR:1 · FAIL:1 (FX-DMF0005-163) |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.c) |
| WK-DMF0005-0091 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.clbDi | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.clbDivision_SelectedIndex: 진입점 집계 16검사 — ERROR:7 · PASS:6 · NA:2 · FAIL:1 (FX-D |  | 44 (ACT:DMF0005_T_SaleSite_PjtModelMapping.c) |
| WK-DMF0005-0092 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.clbEn | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIn: 진입점 집계 8검사 — PASS:4 · ERROR:3 · FAIL:1 (FX-DMF0005-1 |  | 8 (ACT:DMF0005_T_SaleSite_PjtModelMapping.c) |
| WK-DMF0005-0093 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.shtMa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.shtMainDataModel_Changed: 진입점 집계 43검사 — ERROR:35 · NA:4 · PASS:3 · FAIL:1 (FX-D |  | 55 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0094 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdMain_Changed: 진입점 집계 36검사 — PASS:15 · NA:12 · ERROR:8 · FAIL:1 (FX-DMF0005-1 |  | 29 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0095 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdMain_ClipboardPasted: 진입점 집계 18검사 — PASS:7 · NA:6 · ERROR:4 · FAIL:1 (FX-DMF |  | 23 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0096 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdMain_ComboSelChange: 진입점 집계 83검사 — PASS:38 · ERROR:21 · NA:13 · NOPATH:7 · F |  | 65 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0097 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdSub_Changed: 진입점 집계 36검사 — PASS:15 · NA:12 · ERROR:8 · FAIL:1 (FX-DMF0005-17 |  | 28 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0098 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdSub_ClipboardPasted: 진입점 집계 18검사 — PASS:7 · NA:6 · ERROR:4 · FAIL:1 (FX-DMF0 |  | 23 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0099 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — DMF0005_T_SaleSite_PjtModelMapping.spdSub_ComboSelChange: 진입점 집계 24검사 — PASS:11 · ERROR:7 · NA:5 · FAIL:1 (FX-DMF0 |  | 22 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |

## W5 검사기 연결 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0005-0100 | B1 | CONTRIBUTION_TYPE / 기여율 구분 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CONTRIBUTION_TYPE / 기여율 구분 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0101 | B1 | CRGE_ORG_NM / Org.Name (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CRGE_ORG_NM / Org.Name (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0102 | B1 | CUST_ENG_NM / End Customer (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CUST_ENG_NM / End Customer (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0103 | B1 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0104 | B1 | OS_CORP / 해외법인 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OS_CORP / 해외법인 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0105 | B1 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL REPORT_GROUP5 / Cyl Gr. (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0106 | B1 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0107 | B2 | CONTRIBUTION_TYPE / 기여율 구분 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CONTRIBUTION_TYPE / 기여율 구분 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0108 | B2 | CRGE_ORG_NM / Org.Name (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CRGE_ORG_NM / Org.Name (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0109 | B2 | CUST_ENG_NM / End Customer (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CUST_ENG_NM / End Customer (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0110 | B2 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0111 | B2 | OS_CORP / 해외법인 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OS_CORP / 해외법인 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0112 | B2 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL REPORT_GROUP5 / Cyl Gr. (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0113 | B2 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0114 | B3 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0115 | B3 | TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL TEAM_ID | 있음(SHEET_COLUMNS) | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0116 | B4 | CONTRIBUTION_TYPE / 기여율 구분 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONTRIBUTION_TYPE / 기여율 구분 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0117 | B4 | CRGE_ORG_NM / Org.Name (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CRGE_ORG_NM / Org.Name (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0118 | B4 | CUST_ENG_NM / End Customer (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CUST_ENG_NM / End Customer (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0119 | B4 | DIVISION_ID / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID / Division | 있음(SHEET_COLUMNS) | 28 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0120 | B4 | OS_CORP / 해외법인 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OS_CORP / 해외법인 | 있음(SHEET_COLUMNS) | 0 () |
| WK-DMF0005-0121 | B4 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL REPORT_GROUP5 / Cyl Gr. (Report | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0122 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Act) |
| WK-DMF0005-0123 | DB-SYN | SCM0001_GET_SITE_INFO_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_INFO_BY_DIVISION | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0124 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 없음 | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0125 | G03-WIRE | DMF0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0005 화면 | 판단불가(대상 단위 SCREEN) | 27 (ACT:DMF0005_ModelCodeChange..ctor ACT:DM) |
| WK-DMF0005-0126 | G5 | cboActive / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboActive / Active | 없음 | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0127 | G5 | clbDivision / Division / Div. / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division / Div. / Div | 있음(FE 소스) | 68 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |

## W6 검증 실행 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0005-0128 | G4 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboActive / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0129 | G4 | clbDivision / Division / Div. / Div | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division / Div. / Div · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 35 (ACT:DMF0005_SaleSite_PjtModelMapping.Def) |
| WK-DMF0005-0130 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0131 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0132 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0133 | H6 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboActive / Active · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0134 | H6 | clbDivision / Division / Div. / Div | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division / Div. / Div · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 68 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |

## W7 기대값 확정 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0005-0135 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0005/DMF0000_GET_COMMO |  | 181 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0136 | A1 | PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0005/DMF0005_GET_ |  | 135 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0137 | X-ROW | DMF0005_SaleSite_PjtModelMapping.ExcelBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_SaleSite_PjtModelMapping.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_ |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.Exc) |
| WK-DMF0005-0138 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_SaleSite_PjtModelMapping.spdMain_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/UI_PROP, 연결된  |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0139 | M4 | DIVISION_ID / Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DIVISION_ID / Division: 검증 엔진이 실행됐으나 이 대상(COL DIVISION_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 23 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0140 | M4 | cboActive / Active | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboActive / Active: 검증 엔진이 실행됐으나 이 대상(COND cboActive)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0141 | M4 | clbDivision / Division / Div. / Div | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — clbDivision / Division / Div. / Div: 검증 엔진이 실행됐으나 이 대상(COND clbDivision)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 68 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |

## W9 도구 오류 (719)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0005-0142 | C2 | CELL_PER_CAR / Cell/Car | 하네스·환경 | C2 도구 오류 — 실측[T-08f5831f]: CELL_PER_CAR 연쇄 원천 해석 불가 — AS-IS shtMainDataModel_Changed:3560 siMain.GetColumnIndex(DefColumns.CELL_PE |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0143 | C2 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | C2 도구 오류 — 실측[T-5094145d]: 원천 CELL_PER_CAR 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검 |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0144 | C2 | CONTRIBUTION_TYPE | 하네스·환경 | C2 도구 오류 — 원장 V-5e2c9938 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0145 | C2 | CONTRIBUTION_TYPE | 하네스·환경 | C2 도구 오류 — 원장 V-3b6a1b1f |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0146 | C2 | CRGE_ORG_NM | 하네스·환경 | C2 도구 오류 — 원장 V-32144eef |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0147 | C2 | CUST_ENG_NM | 하네스·환경 | C2 도구 오류 — 원장 V-29b3b802 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0148 | C2 | DEPT_ID / Team | 하네스·환경 | C2 도구 오류 — 실측[T-43d635bf]: DEPT_ID 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0149 | C2 | DEPT_ID_82 | 하네스·환경 | C2 도구 오류 — 원장 V-41a44d42 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0150 | C2 | DMF0005_SaleSite_PjtModelMapping.shtSubD | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.shtSubDataModel_Changed 의 C2 1요소: ERROR:1 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0151 | C2 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | C2 도구 오류 — 원장 V-23d11e91 ASIS / 원장 V-305469f5 ASIS / 원장 V-fec9d837 ASIS / 원장 V-f362224a ASIS / 원장 V-24a119c4 ASIS / 원장 V-3f009e53  |  | 9 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0152 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-c243dfe5 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0153 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-305469f5 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0154 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-f362224a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0155 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-2be5ecd1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0156 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-33388503 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0157 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-45f2ccff |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0158 | C2 | END_CUSTOMER / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-c243dfe5 ASIS / 원장 V-305469f5 ASIS / 원장 V-f362224a ASIS / 원장 V-3f009e53 ASIS / 원장 V-2be5ecd1 ASIS / 원장 V-33388503  |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0159 | C2 | END_CUSTOMER40 / End Customer | 하네스·환경 | C2 도구 오류 — 실측[T-601876c8]: END_CUSTOMER40 연쇄 원천 해석 불가 — AS-IS spdMain_ComboSelChange:3038 siMain.GetColumnIndex(DefColumns.END_CUS |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0160 | C2 | ITEM_ID / Model | 하네스·환경 | C2 도구 오류 — 실측[T-9ca2e371]: 원천 VMI_LT 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0161 | C2 | LIABILITY_PERIOD / Liablity(Week | 하네스·환경 | C2 도구 오류 — 실측[T-4d15509c]: LIABILITY_PERIOD 연쇄 원천 해석 불가 — AS-IS shtMainDataModel_Changed:3550 siMain.GetColumnIndex(DefColumns.LIA |  | 114 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0162 | C2 | MODULE_PER_CAR / Module/Car | 하네스·환경 | C2 도구 오류 — 실측[T-cce2fa70]: 원천 CELL_PER_CAR 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검 |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0163 | C2 | OS_CORP | 하네스·환경 | C2 도구 오류 — 원장 V-93009550 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0164 | C2 | OS_CORP | 하네스·환경 | C2 도구 오류 — 원장 V-dc36ff9f |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0165 | C2 | PROJECT_CODE / Project Code | 하네스·환경 | C2 도구 오류 — 원장 V-a9e2dad6 ASIS / 원장 V-0da02c33 ASIS / 원장 V-d5fb54fb ASIS / 원장 V-2c11b8f3 ASIS / 원장 V-c1871611 ASIS / 원장 V-ebf311fd  |  | 53 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0166 | C2 | REPORT_GROUP1 | 하네스·환경 | C2 도구 오류 — 원장 V-8d94b084 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0167 | C2 | REPORT_GROUP1 | 하네스·환경 | C2 도구 오류 — 원장 V-78c08ac4 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0168 | C2 | REPORT_GROUP2 | 하네스·환경 | C2 도구 오류 — 원장 V-bd40cc57 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0169 | C2 | REPORT_GROUP2 | 하네스·환경 | C2 도구 오류 — 원장 V-7116e5e1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0170 | C2 | REPORT_GROUP3 | 하네스·환경 | C2 도구 오류 — 원장 V-284ba88a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0171 | C2 | REPORT_GROUP3 | 하네스·환경 | C2 도구 오류 — 원장 V-4200750a |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0172 | C2 | REPORT_GROUP4 | 하네스·환경 | C2 도구 오류 — 원장 V-f7b9839c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0173 | C2 | REPORT_GROUP4 | 하네스·환경 | C2 도구 오류 — 원장 V-7e0e3ebe |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0174 | C2 | REPORT_GROUP5 | 하네스·환경 | C2 도구 오류 — 원장 V-7b3fa49b |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0175 | C2 | REPORT_GROUP5 | 하네스·환경 | C2 도구 오류 — 원장 V-70331e0c |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0176 | C2 | REPORT_GROUP6 | 하네스·환경 | C2 도구 오류 — 원장 V-9207a0ef |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0177 | C2 | REPORT_GROUP6 | 하네스·환경 | C2 도구 오류 — 원장 V-7632f0f3 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0178 | C2 | REPORT_GROUP7 | 하네스·환경 | C2 도구 오류 — 원장 V-f7853294 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0179 | C2 | REPORT_GROUP7 | 하네스·환경 | C2 도구 오류 — 원장 V-7caf9c80 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0180 | C2 | REPORT_GROUP8 | 하네스·환경 | C2 도구 오류 — 원장 V-e219522c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0181 | C2 | REPORT_GROUP8 | 하네스·환경 | C2 도구 오류 — 원장 V-2f377eb6 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0182 | C2 | SHIPTO_CODE / Rep Ship-To | 하네스·환경 | C2 도구 오류 — 실측[T-5382d4bf]: SHIPTO_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0183 | C2 | SHIPTO_DESCRIPTION / Rep Ship-To | 하네스·환경 | C2 도구 오류 — 실측[T-4176533b]: SHIPTO_DESCRIPTION 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0184 | C2 | SOLDTO_CODE / Sold-To | 하네스·환경 | C2 도구 오류 — 실측[T-3f3f89c9]: SOLDTO_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0185 | C2 | SOLDTO_DESCRIPTION / Sold-To | 하네스·환경 | C2 도구 오류 — 실측[T-1e25f9a4]: SOLDTO_DESCRIPTION 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0186 | C2 | TEAM_ID | 하네스·환경 | C2 도구 오류 — 원장 V-62ad4b5f |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0187 | C2 | TEAM_ID | 하네스·환경 | C2 도구 오류 — 원장 V-62ad4b5f ASIS / 원장 V-23d11e91 ASIS / 원장 V-f362224a ASIS / 원장 V-24a119c4 ASIS / 원장 V-3f009e53 ASIS / 원장 V-293c5ef0  |  | 94 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0188 | C2 | TEAM_ID | 하네스·환경 | C2 도구 오류 — 원장 V-23d11e91 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0189 | C2 | TEAM_ID | 하네스·환경 | C2 도구 오류 — 원장 V-293c5ef0 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0190 | C2 | TEAM_ID | 하네스·환경 | C2 도구 오류 — 원장 V-b5874887 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0191 | C2 | VMI_LT | 하네스·환경 | C2 도구 오류 — 실측[T-d725277b]: VMI_LT 연쇄 원천 해석 불가 — AS-IS shtMainDataModel_Changed:3614 siMain.GetColumnIndex(DefColumns.VMI_LT) [swit |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0192 | C3 | BPMS_EXIST / BPMS Exist | 하네스·환경 | C3 도구 오류 — 실측[T-2d1eb23b]: BPMS_EXIST 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:2745 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColum |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0193 | C3 | CELL_PER_CAR / Cell/Car | 하네스·환경 | C3 도구 오류 — 원장 V-85cbe73a ASIS / 원장 V-dd4b103f ASIS / 원장 V-78c84a7f ASIS / 원장 V-5087e39f ASIS / 실측[T-ccc3d591]: CELL_PER_CAR 연쇄 원천  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0194 | C3 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | C3 도구 오류 — 실측[T-7519a6f5]: CELL_PER_MODULE 연쇄 프로브 불가 — 원천 CELL_PER_CAR 신규행 편집 불가(팝업 전용 셀이면 M4 에서 판정) — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검 |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0195 | C3 | CURRENCY / Currency | 하네스·환경 | C3 도구 오류 — 실측[T-2371221f]: CURRENCY 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3385 siMain.SetText(e.Row, siMain.GetColumnInde |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0196 | C3 | DEPT_ID / Team | 하네스·환경 | C3 도구 오류 — 실측[T-6b343b66]: DEPT_ID: 원천 USER_ID/SCM_SITE_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0197 | C3 | DEPT_ID2 / Team | 하네스·환경 | C3 도구 오류 — 실측[T-4efedb01]: DEPT_ID2: 원천 USER_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0198 | C3 | DEPT_ID_82 / Team(Sales | 하네스·환경 | C3 도구 오류 — 실측[T-42077156]: DEPT_ID_82: 원천 USER_ID_82 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0199 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 원장 V-02463f9a ASIS / 원장 V-d6036625 ASIS / 원장 V-fb1dcedc ASIS / 원장 V-056b1d64 ASIS / 원장 V-5dfdfe2a ASIS / 원장 V-e8138a79  |  | 153 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0200 | C3 | DMF0005_SaleSite_PjtModelMapping.SetChan | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.SetChangeControl 의 C3 4요소: ERROR:3 · PASS:1 |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0201 | C3 | DMF0005_SaleSite_PjtModelMapping.shtMain | 하네스·환경 | C3 도구 오류 — 원장 V-85cbe73a ASIS / 원장 V-dd4b103f ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0202 | C3 | DMF0005_SaleSite_PjtModelMapping.shtSubD | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.shtSubDataModel_Changed 의 C3 1요소: ERROR:1 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0203 | C3 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdMain_Changed 의 C3 3요소: ERROR:1 · PASS:1 · NA:1 |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0204 | C3 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_Changed 의 C3 3요소: ERROR:1 · PASS:1 · NA:1 |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0205 | C3 | EDIT_FLAG / Edit Flag | 하네스·환경 | C3 도구 오류 — 실측[T-5b74b5b6]: EDIT_FLAG 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0206 | C3 | INVENTORY_DAY / INVENTORY DAY | 하네스·환경 | C3 도구 오류 — 실측[T-0c6d3b59]: INVENTORY_DAY 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRowLockRangeMain82:2925 siMain.SetValue(rowIndex, siMain.Get |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0207 | C3 | ITEM_CLASS_NAME / Model Type | 하네스·환경 | C3 도구 오류 — 실측[T-4e491a3d]: ITEM_CLASS_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3449 siMain.SetText(e.Row, siMain.GetCol |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0208 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-3d5f4db7]: ITEM_ID 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:2812 siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.Ge |  | 42 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0209 | C3 | ITEM_NAME / Model Name | 하네스·환경 | C3 도구 오류 — 실측[T-525cd2d4]: ITEM_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3443 siMain.SetText(e.Row, siMain.GetColumnInd |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0210 | C3 | ITEM_TYPE / Item Type | 하네스·환경 | C3 도구 오류 — 실측[T-9ba16732]: ITEM_TYPE 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3445 siMain.SetText(e.Row, siMain.GetColumnInd |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0211 | C3 | LIABILITY_PERIOD / Liablity(Week | 하네스·환경 | C3 도구 오류 — 원장 V-85cbe73a ASIS / 원장 V-dd4b103f ASIS / 원장 V-78c84a7f ASIS / 원장 V-5087e39f ASIS / 실측[T-a868856f]: LIABILITY_PERIOD 연쇄 |  | 114 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0212 | C3 | MODULE_PER_CAR | 하네스·환경 | C3 도구 오류 — 원장 V-85cbe73a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0213 | C3 | MODULE_PER_CAR | 하네스·환경 | C3 도구 오류 — 원장 V-78c84a7f |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0214 | C3 | MODULE_PER_CAR / Module/Car | 하네스·환경 | C3 도구 오류 — 원장 V-85cbe73a ASIS / 원장 V-78c84a7f ASIS |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0215 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-525be0d1]: NICK_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3447 siMain.SetText(e.Row, siMain.GetColumnInd |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0216 | C3 | OWNER / Owner Name | 하네스·환경 | C3 도구 오류 — 실측[T-9ec9cc9c]: OWNER: 원천 USER_ID_82/USER_ID 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작 |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0217 | C3 | PRJ_OWNR_ID / Owner(PM | 하네스·환경 | C3 도구 오류 — 실측[T-42dba96e]: PRJ_OWNR_ID 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3506 siMain.SetText(e.Row, siMain.GetColumnI |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0218 | C3 | PROJECT_CODE / Project Code | 하네스·환경 | C3 도구 오류 — 실측[T-087dadb2]: PROJECT_CODE 연쇄 원천 컬럼 해석 불가 — AS-IS FindData_Main:1047 siMain.ActiveSheet.Cells[iRow, siMain.GetColumnI |  | 91 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0219 | C3 | PROJECT_NAME / Project | 하네스·환경 | C3 도구 오류 — 실측[T-2791e321]: PROJECT_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3382 siMain.SetText(e.Row, siMain.GetColumn |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0220 | C3 | PROJECT_OWNER / Project Owner | 하네스·환경 | C3 도구 오류 — 실측[T-0ec6ad89]: PROJECT_OWNER 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3387 siMain.SetText(e.Row, siMain.GetColum |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0221 | C3 | PROJECT_STATUS / Project Status | 하네스·환경 | C3 도구 오류 — 실측[T-470d5502]: PROJECT_STATUS 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3383 siMain.SetText(e.Row, siMain.GetColu |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0222 | C3 | SALES_PLAN_ADJUST_YN / Sales Sync | 하네스·환경 | C3 도구 오류 — 실측[T-a28739af]: SALES_PLAN_ADJUST_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:2742 siMain.SetValue(siMain.ActiveRowIndex, siMai |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0223 | C3 | USER_ID / Owner | 하네스·환경 | C3 도구 오류 — 실측[T-927fab3b]: USER_ID 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3528 siMain.SetText(e.Row, siMain.GetColumnIndex |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0224 | C3 | USER_ID_82 / Owner(Sales | 하네스·환경 | C3 도구 오류 — 실측[T-839979a0]: USER_ID_82 연쇄 원천 컬럼 해석 불가 — AS-IS spdMain_CellDoubleClick:3487 siMain.SetText(e.Row, siMain.GetColumnIn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0225 | C3 | VALID_YN / Active | 하네스·환경 | C3 도구 오류 — 실측[T-ae6564cc]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:2746 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnI |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0226 | C3 | VMI_LT | 하네스·환경 | C3 도구 오류 — 원장 V-dd4b103f ASIS / 원장 V-5087e39f ASIS / 실측[T-9dfe285b]: VMI_LT 연쇄 원천 컬럼 해석 불가 — AS-IS shtMainDataModel_Changed:3614 s |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0227 | C6 | CELL_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-653ef248 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0228 | C6 | CELL_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-eb114dab |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0229 | C6 | CELL_PER_CAR / Cell/Car | 하네스·환경 | C6 도구 오류 — 원장 V-d2222567 ASIS / 원장 V-653ef248 ASIS / 원장 V-0110e5af ASIS / 원장 V-23fdd0de ASIS / 원장 V-54a6810a ASIS / 원장 V-255e2ab8  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0230 | C6 | CELL_PER_MODULE | 하네스·환경 | C6 도구 오류 — 원장 V-0110e5af |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0231 | C6 | CELL_PER_MODULE | 하네스·환경 | C6 도구 오류 — 원장 V-7bdef327 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0232 | C6 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | C6 도구 오류 — 원장 V-0110e5af ASIS / 원장 V-7bdef327 ASIS |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0233 | C6 | DMF0005_SaleSite_PjtModelMapping.ClbTeam | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged 의 C6 68요소: PASS:39 · ERROR:27 · NA:2 |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.Clb) |
| WK-DMF0005-0234 | C6 | DMF0005_SaleSite_PjtModelMapping.clbDivi | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged 의 C6 68요소: PASS:39 · ERROR:27 · NA:2 |  | 24 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0235 | C6 | DMF0005_SaleSite_PjtModelMapping.clbEndC | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged 의 C6 68요소: PASS:39 · ERROR:27 · NA:2 |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0236 | C6 | DMF0005_SaleSite_PjtModelMapping.shtMain | 하네스·환경 | C6 도구 오류 — 원장 V-aa407566 ASIS / 원장 V-d2222567 ASIS / 원장 V-653ef248 ASIS / 원장 V-0110e5af ASIS / 원장 V-23fdd0de ASIS / 원장 V-54a6810a  |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0237 | C6 | DMF0005_SaleSite_PjtModelMapping.shtSubD | 하네스·환경 | C6 도구 오류 — 원장 V-03159b26 ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0238 | C6 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdMain_Changed 의 C6 3요소: PASS:2 · ERROR:1 |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0239 | C6 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_Changed 의 C6 3요소: PASS:2 · ERROR:1 |  | 5 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0240 | C6 | ITEM_ID / Model | 하네스·환경 | C6 도구 오류 — 실측[T-3c42f646]: 원천 VMI_LT 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0241 | C6 | LIABILITY_PERIOD | 하네스·환경 | C6 도구 오류 — 원장 V-aa407566 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0242 | C6 | LIABILITY_PERIOD | 하네스·환경 | C6 도구 오류 — 원장 V-03159b26 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0243 | C6 | LIABILITY_PERIOD | 하네스·환경 | C6 도구 오류 — 원장 V-17a7aba2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0244 | C6 | LIABILITY_PERIOD | 하네스·환경 | C6 도구 오류 — 원장 V-264ca771 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0245 | C6 | LIABILITY_PERIOD / Liablity(Week | 하네스·환경 | C6 도구 오류 — 원장 V-aa407566 ASIS / 원장 V-d2222567 ASIS / 원장 V-653ef248 ASIS / 원장 V-0110e5af ASIS / 원장 V-23fdd0de ASIS / 원장 V-54a6810a  |  | 114 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0246 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-23fdd0de |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0247 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-54a6810a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0248 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-255e2ab8 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0249 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-57092555 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0250 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-db11520f |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0251 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-1f706e88 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0252 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-bffed7e2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0253 | C6 | MODULE_PER_CAR | 하네스·환경 | C6 도구 오류 — 원장 V-7edc7407 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0254 | C6 | MODULE_PER_CAR / Module/Car | 하네스·환경 | C6 도구 오류 — 원장 V-23fdd0de ASIS / 원장 V-54a6810a ASIS / 원장 V-255e2ab8 ASIS / 원장 V-57092555 ASIS / 원장 V-db11520f ASIS / 원장 V-1f706e88  |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0255 | C6 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | C6 도구 오류 — 실측[T-1b3dbb12]: 원천 VMI_LT 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_ve |  | 20 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0256 | C6 | VMI_LT | 하네스·환경 | C6 도구 오류 — 원장 V-1d4d2edc ASIS / 원장 V-81311b40 ASIS |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0257 | C6 | VMI_LT | 하네스·환경 | C6 도구 오류 — 원장 V-1d4d2edc |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0258 | C6 | VMI_LT | 하네스·환경 | C6 도구 오류 — 원장 V-81311b40 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0259 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d2222567 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0260 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7217c84e |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0261 | B1 | DEPT_ID_82 / Team(Sales | 하네스·환경 | B1 도구 오류 — 원장 V-9f36ef71 COLUMN |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0262 | B1 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | B1 도구 오류 — 원장 V-1c1c9bba COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0263 | B1 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | B1 도구 오류 — 원장 V-946c9bc8 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0264 | B1 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | B1 도구 오류 — 원장 V-eb08082a COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0265 | B1 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | B1 도구 오류 — 원장 V-b1dc2281 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0266 | B1 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | B1 도구 오류 — 원장 V-143ac797 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0267 | B1 | REPORT_GROUP7 / 비고1 | 하네스·환경 | B1 도구 오류 — 원장 V-34827b26 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0268 | B1 | REPORT_GROUP8 / 비고2 | 하네스·환경 | B1 도구 오류 — 원장 V-c7ec69b9 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0269 | B2 | DEPT_ID_82 / Team(Sales | 하네스·환경 | B2 도구 오류 — 원장 V-ea8dcd4e COLUMN |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0270 | B2 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | B2 도구 오류 — 원장 V-b105afa0 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0271 | B2 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | B2 도구 오류 — 원장 V-52dfcb39 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0272 | B2 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | B2 도구 오류 — 원장 V-434d808d COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0273 | B2 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | B2 도구 오류 — 원장 V-5ce4bbd1 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0274 | B2 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | B2 도구 오류 — 원장 V-8081664a COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0275 | B2 | REPORT_GROUP7 / 비고1 | 하네스·환경 | B2 도구 오류 — 원장 V-6114fc48 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0276 | B2 | REPORT_GROUP8 / 비고2 | 하네스·환경 | B2 도구 오류 — 원장 V-9d786c60 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0277 | B4 | DMF0005_SaleSite_PjtModelMapping.GetComm | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetCommonDataList_DM 의 B4 23요소: ERROR:10 · NOPATH:6 · PASS:4 · NA:3 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0278 | B4 | DMF0005_SaleSite_PjtModelMapping.GetItem | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetItemType 의 B4 23요소: ERROR:10 · NOPATH:6 · PASS:4 · NA:3 |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0279 | B4 | DMF0005_SaleSite_PjtModelMapping.GetScmS | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.GetScmSiteInfobyDivision 의 B4 23요소: ERROR:10 · NOPATH:6 · PASS:4 · NA:3 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0280 | B4 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CRGE_ORG_NM 의 B4 23요소: ERROR:10 · NOPATH:6 · PASS:4 · NA:3 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0281 | B4 | DMF0005_SaleSite_PjtModelMapping.Get_DDL | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.Get_DDL_SSPM_CUST_ENG_NM 의 B4 23요소: ERROR:10 · NOPATH:6 · PASS:4 · NA:3 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Get) |
| WK-DMF0005-0282 | B4 | END_CUSTOMER / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-97d18cdc COLUMN |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0283 | B4 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | B4 도구 오류 — 원장 V-115e5661 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0284 | B4 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | B4 도구 오류 — 원장 V-b94700b3 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0285 | B4 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | B4 도구 오류 — 원장 V-aca4480c COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0286 | B4 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | B4 도구 오류 — 원장 V-6b8620ab COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0287 | B4 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | B4 도구 오류 — 원장 V-c6244558 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0288 | B4 | REPORT_GROUP7 / 비고1 | 하네스·환경 | B4 도구 오류 — 원장 V-caa8f01e COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0289 | B4 | REPORT_GROUP8 / 비고2 | 하네스·환경 | B4 도구 오류 — 원장 V-c9d4f607 COLUMN |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0290 | B4 | SCM_SITE_ID / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-77be9327 COLUMN |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0291 | B4 | clbEndCustomer / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-3842fd5b SEARCH |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0292 | K4 | DMF0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-3cc99610 RULE_SCREEN / 원장 V-b77434c9 DEFECT / 원장 V-04be49ff GENERAL / 원장 V-f7911b7a GENERAL / 원장 V-711fe575 GENERA |  | 110 (ACT:DMF0005_ModelCodeChange.btnButtonLis) |
| WK-DMF0005-0293 | F5 | DMF0005 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-dea373e5 RULE_SCREEN / 원장 V-4443aec3 RULE_SCREEN / 원장 V-05a48199 RULE_SCREEN / 원장 V-6056ff74 RULE_SCREEN / 원장 V-17 |  | 9 (ACT:DMF0005_ModelCodeChange.DeleteButton) |
| WK-DMF0005-0294 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 하네스·환경 | F4 도구 오류 — 실측[T-305f5726]: PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: DMF0044/unitedVersion/TITLE, DMF0049/unitedVersion/TITLE |  | 1791 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0295 | F4 | PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MOD | 하네스·환경 | F4 도구 오류 — 실측[T-c38f75c6]: PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE: DMF0005/purchase/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝 |  | 1660 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0296 | A5 | COLUMN_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-15df6588]: COLUMN_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0297 | A5 | COLUMN_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-c090d089]: COLUMN_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0298 | A5 | EDIT_FLAG / Edit Flag | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-84fffd67]: EDIT_FLAG: [측정 경로 없음] AS-IS 시트 Production/Purchase 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부  |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0299 | A5 | ITEM_ID_AFTER | 하네스·환경 | A5 도구 오류 — 실측[T-023f26b7]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0300 | A5 | ITEM_ID_BEFORE | 하네스·환경 | A5 도구 오류 — 실측[T-0c837fed]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0301 | A5 | KWH / KWh/Cell | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-c50cef92]: KWH: [측정 경로 없음] AS-IS 시트 Production/Purchase 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T2 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0302 | A5 | LARGE_CLASS_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-a98f6680]: LARGE_CLASS_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0303 | A5 | PROJECT_CODE / Project Code | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-46cc9c53]: PROJECT_CODE: [측정 경로 없음] AS-IS 시트 Production/Purchase 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시  |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0304 | A5 | SMALL_CLASS_LABEL_NAME | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-bcb3c834]: SMALL_CLASS_LABEL_NAME: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T |  | 11 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0305 | A5 | USER_ID / Owner | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-35255dd3]: USER_ID: [측정 경로 없음] AS-IS 시트 Production/Purchase 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측 |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0306 | H2 | DMF0005_SaleSite_PjtModelMapping.CreateS | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.CreateSpread 의 H2 7요소: NA:4 · ERROR:2 · PASS:1 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Cre) |
| WK-DMF0005-0307 | H2 | ITEM_ID_AFTER | 하네스·환경 | H2 도구 오류 — 실측[T-832831c1]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0308 | H2 | ITEM_ID_BEFORE | 하네스·환경 | H2 도구 오류 — 실측[T-37c76cfc]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0309 | H4 | DMF0005 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-c5b335ba RULE_SCREEN / 원장 V-0e700d35 RULE_SCREEN / 원장 V-bff4162c RULE_SCREEN / 원장 V-5e88b17b RULE_SCREEN / 원장 V-90 |  | 20 (ACT:DMF0005_ModelCodeChange.spdMain_TopC) |
| WK-DMF0005-0310 | H5 | COLUMN_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-2fa3609f]: COLUMN_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0311 | H5 | COLUMN_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-f8b38aa3]: COLUMN_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0312 | H5 | DMF0005_SaleSite_PjtModelMapping.CreateS | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.CreateSpread 의 H5 7요소: ERROR:7 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Cre) |
| WK-DMF0005-0313 | H5 | DMF0005_SaleSite_PjtModelMapping.SetSpre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.SetSpreadHeaderSpan 의 H5 4요소: ERROR:4 |  | 15 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0314 | H5 | ITEM_ID_AFTER | 하네스·환경 | H5 도구 오류 — 실측[T-68ca6340]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0315 | H5 | ITEM_ID_BEFORE | 하네스·환경 | H5 도구 오류 — 실측[T-b94e5f86]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0316 | H5 | KWH / KWh/Cell | 하네스·환경 | H5 도구 오류 — 실측[T-6c5f2439]: KWH 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0317 | H5 | LARGE_CLASS_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-d6b37036]: LARGE_CLASS_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0318 | H5 | SMALL_CLASS_LABEL_NAME | 하네스·환경 | H5 도구 오류 — 실측[T-ce24811e]: SMALL_CLASS_LABEL_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 11 (ACT:DMF0005_SaleSite_PjtModelMapping.Set) |
| WK-DMF0005-0319 | I1 | DMF0005 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-957794ad RULE_SCREEN / 원장 V-29e5add7 RULE_SCREEN / 원장 V-15c5e260 RULE_SCREEN / 원장 V-3e5f8f7a DEFECT / 원장 V-40b0a6c |  | 98 (ACT:DMF0005_ModelCodeChange.SaveData:239) |
| WK-DMF0005-0320 | D1 | ACTIVE_FLAG / MDM Active | 하네스·환경 | D1 도구 오류 — 원장 V-597acd88 COLUMN / 원장 V-2cc13de6 COLUMN / 원장 V-60d9729f ASIS / 원장 V-5de1102c ASIS / 원장 V-a093afd1 ASIS / 실측[T-3e0d8 |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0321 | D1 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D1 도구 오류 — 원장 V-60d9729f |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0322 | D1 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D1 도구 오류 — 원장 V-5de1102c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0323 | D1 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D1 도구 오류 — 원장 V-a093afd1 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0324 | D1 | ATTRIBUTE1 / 양극재 | 하네스·환경 | D1 도구 오류 — 원장 V-828c536a COLUMN / 원장 V-345e2b5e COLUMN / 실측[T-48eb7dd0]: 기존행 r0 ATTRIBUTE1 편집=true — AS-IS 조건부(행 값으로 계산 불가): RULES |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0325 | D1 | ATTRIBUTE2 / End Cust.(Report | 하네스·환경 | D1 도구 오류 — 실측[T-84e8e000]: 기존행 r0 ATTRIBUTE2 편집=true — AS-IS 조건부(행 값으로 계산 불가): RULES:[{"g": "COL(EDIT_FLAG)==\"Y\" && !(COL(DIVISI |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0326 | D1 | ATTRIBUTE4 / Destination | 하네스·환경 | D1 도구 오류 — 원장 V-33c69b04 COLUMN / 원장 V-5533916d COLUMN / 원장 V-02db13b0 ASIS / 원장 V-de02a5a3 ASIS / 실측[T-65c42b44]: 기존행 r0 ATTRIBUT |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0327 | D1 | ATTRIBUTE4,ATTRIBUTE4 | 하네스·환경 | D1 도구 오류 — 원장 V-02db13b0 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0328 | D1 | ATTRIBUTE4,ATTRIBUTE4 | 하네스·환경 | D1 도구 오류 — 원장 V-de02a5a3 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0329 | D1 | ATTRIBUTE5 / Cell Model | 하네스·환경 | D1 도구 오류 — 원장 V-637cf025 COLUMN / 원장 V-ee6184fa COLUMN / 원장 V-bd35f418 ASIS / 원장 V-64afb5b5 ASIS / 실측[T-46f83943]: 기존행 r0 ATTRIBUT |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0330 | D1 | ATTRIBUTE5,ATTRIBUTE5 | 하네스·환경 | D1 도구 오류 — 원장 V-bd35f418 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0331 | D1 | ATTRIBUTE5,ATTRIBUTE5 | 하네스·환경 | D1 도구 오류 — 원장 V-64afb5b5 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0332 | D1 | BPMS_EXIST / BPMS Exist | 하네스·환경 | D1 도구 오류 — 원장 V-3961c3d1 COLUMN / 원장 V-6cfc7e72 COLUMN / 원장 V-61f1b754 COLUMN / 원장 V-99a257ac COLUMN / 원장 V-90837410 ASIS / 원장 V-1 |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0333 | D1 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D1 도구 오류 — 원장 V-90837410 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0334 | D1 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D1 도구 오류 — 원장 V-143fcd98 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0335 | D1 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D1 도구 오류 — 원장 V-7b70c5fe |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0336 | D1 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D1 도구 오류 — 원장 V-9c7f7a6d |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0337 | D1 | CELL_S_OP_REPORT / Cell Prod. Site (S&OP | 하네스·환경 | D1 도구 오류 — 원장 V-d1ffc0c2 ASIS / 실측[T-e3ad45ef]: 기존행 r0 CELL_S_OP_REPORT 편집=false — AS-IS 조건부(행 값으로 계산 불가): RULES:[{"g": "COL(EDIT_ |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0338 | D1 | CELL_S_OP_REPORT,CELL_S_OP_REPORT | 하네스·환경 | D1 도구 오류 — 원장 V-d1ffc0c2 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0339 | D1 | CELL_TYPE / Product Group | 하네스·환경 | D1 도구 오류 — 원장 V-03041dca COLUMN / 원장 V-cd2dee53 COLUMN / 원장 V-b9f0a5ab ASIS / 원장 V-0f6acb38 ASIS / 실측[T-f6735a5f]: 기존행 r0 CELL_TYP |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0340 | D1 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-b9f0a5ab |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0341 | D1 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-0f6acb38 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0342 | D1 | CHANGE_REASON / CHANGE REASON | 하네스·환경 | D1 도구 오류 — 원장 V-019cf120 COLUMN / 원장 V-3065253e COLUMN / 실측[T-3382656e]: 기존행 r0 CHANGE_REASON: 현재 그리드에 없음 — 표시 여부는 A5 / 신규행 r0 CHA |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0343 | D1 | CONSENSUS_ESS / ESS Subsidiary | 하네스·환경 | D1 도구 오류 — 원장 V-d564cd5a COLUMN / 원장 V-cffda792 COLUMN / 실측[T-9b2cc8be]: 기존행 r0 CONSENSUS_ESS: 현재 그리드에 없음 — 표시 여부는 A5 / 신규행 r0 CON |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0344 | D1 | CONSENSUS_MKT / MKT | 하네스·환경 | D1 도구 오류 — 원장 V-691643f5 COLUMN / 원장 V-4611241d COLUMN / 실측[T-ce6bf6d4]: 기존행 r0 CONSENSUS_MKT: 현재 그리드에 없음 — 표시 여부는 A5 / 신규행 r0 CON |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0345 | D1 | CONSENSUS_SCM / SCM | 하네스·환경 | D1 도구 오류 — 원장 V-ced71e3d COLUMN / 원장 V-b4efba66 COLUMN / 실측[T-93a8323c]: 기존행 r0 CONSENSUS_SCM: 현재 그리드에 없음 — 표시 여부는 A5 / 신규행 r0 CON |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0346 | D1 | CUSTOMER_MODEL / Customer Model | 하네스·환경 | D1 도구 오류 — 원장 V-4efe1baf COLUMN / 원장 V-f831876c COLUMN / 원장 V-27160478 COLUMN / 원장 V-e03ed4bc COLUMN / 원장 V-802393be ASIS / 원장 V-d |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0347 | D1 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D1 도구 오류 — 원장 V-802393be |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0348 | D1 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D1 도구 오류 — 원장 V-dd7ff954 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0349 | D1 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D1 도구 오류 — 원장 V-5c9de7e6 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0350 | D1 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D1 도구 오류 — 원장 V-870199da |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0351 | D1 | CUST_GROUP / Cust Group | 하네스·환경 | D1 도구 오류 — 원장 V-6958610b COLUMN / 원장 V-2112a98a COLUMN / 실측[T-7cb949d6]: 기존행 r0 CUST_GROUP 편집=true — AS-IS 조건부(행 값으로 계산 불가): RULES |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0352 | D1 | DIVISION_ID / Division | 하네스·환경 | D1 도구 오류 — 원장 V-66827bbd COLUMN / 원장 V-a4a00aee COLUMN / 원장 V-4d9bf7ac COLUMN / 원장 V-bfc69cdc COLUMN / 원장 V-30b0a88f ASIS / 원장 V-b |  | 34 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0353 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-30b0a88f |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0354 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-b0f4e560 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0355 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-8a46c8d3 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0356 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-4cd46ac2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0357 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-ec28b642 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0358 | D1 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D1 도구 오류 — 원장 V-2ca25ad4 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0359 | D1 | ENERGE_WH / Energy(Wh | 하네스·환경 | D1 도구 오류 — 원장 V-84f6823e COLUMN / 원장 V-40a34382 COLUMN / 원장 V-fd83c1a4 ASIS / 실측[T-f898bbb0]: 기존행 r0 ENERGE_WH 편집=false — AS-IS 조건 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0360 | D1 | ENERGE_WH,ENERGE_WH | 하네스·환경 | D1 도구 오류 — 원장 V-fd83c1a4 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0361 | D1 | INVENTORY_DAY / INVENTORY DAY | 하네스·환경 | D1 도구 오류 — 원장 V-5e282115 COLUMN / 원장 V-399f51f3 COLUMN / 실측[T-5811fd6c]: 기존행 r0 INVENTORY_DAY: 현재 그리드에 없음 — 표시 여부는 A5 / 신규행 r0 INV |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0362 | D1 | ITEM_CLASS_NAME / Model Type | 하네스·환경 | D1 도구 오류 — 원장 V-73693a06 COLUMN / 원장 V-4d8c0181 COLUMN / 원장 V-69387bb7 COLUMN / 원장 V-c6430833 COLUMN / 원장 V-a4fd447f ASIS / 원장 V-e |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0363 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-a4fd447f |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0364 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-e6999f45 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0365 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-1bca4930 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0366 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-1e562a89 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0367 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-3bfa3722 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0368 | D1 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-cd1a87a8 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0369 | D1 | ITEM_ID,ITEM_ID | 하네스·환경 | D1 도구 오류 — 원장 V-c25f8d1c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0370 | D1 | ITEM_ID,ITEM_ID | 하네스·환경 | D1 도구 오류 — 원장 V-917b41f2 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0371 | D1 | ITEM_ID,ITEM_ID | 하네스·환경 | D1 도구 오류 — 원장 V-5976e538 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0372 | D1 | ITEM_ID,ITEM_ID | 하네스·환경 | D1 도구 오류 — 원장 V-730d8ccc |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0373 | D1 | ITEM_ID_AFTER | 하네스·환경 | D1 도구 오류 — 실측[T-5ac06b0d]: 팝업 내부 그리드 컬럼 ITEM_ID_AFTER — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.EditButton:1) |
| WK-DMF0005-0374 | D1 | ITEM_ID_BEFORE | 하네스·환경 | D1 도구 오류 — 실측[T-3bd1676f]: 팝업 내부 그리드 컬럼 ITEM_ID_BEFORE — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0005_ModelCodeChange.EditButton A) |
| WK-DMF0005-0375 | D1 | ITEM_NAME / Model Name | 하네스·환경 | D1 도구 오류 — 원장 V-13232e8d COLUMN / 원장 V-d45b5ec2 COLUMN / 원장 V-582801c0 ASIS / 원장 V-e3bd9a2a ASIS / 원장 V-e617c3ad ASIS / 원장 V-94bf3 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0376 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-582801c0 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0377 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-e3bd9a2a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0378 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-e617c3ad |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0379 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-94bf3fa9 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0380 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-210fd302 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0381 | D1 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-a4e61975 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0382 | D1 | ITEM_TYPE / Item Type | 하네스·환경 | D1 도구 오류 — 원장 V-f4f03e25 COLUMN / 원장 V-224789f7 COLUMN / 원장 V-3fc0794f COLUMN / 원장 V-4a7a18ce COLUMN / 원장 V-ed165ec9 ASIS / 원장 V-9 |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0383 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-ed165ec9 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0384 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-914db878 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0385 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-1433fa19 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0386 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-d00f432e |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0387 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-eec7efd1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0388 | D1 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D1 도구 오류 — 원장 V-34bbec01 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0389 | D1 | LAST_UPDATED_BY / Update By | 하네스·환경 | D1 도구 오류 — 원장 V-55d71373 COLUMN / 원장 V-d5b5ecea COLUMN / 원장 V-4623843f COLUMN / 원장 V-29af3a43 COLUMN / 원장 V-70d9b432 ASIS / 원장 V-b |  | 13 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0390 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-70d9b432 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0391 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-b6e04402 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0392 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-2d960c17 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0393 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-24f14a35 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0394 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-85c2ede0 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0395 | D1 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D1 도구 오류 — 원장 V-3fcc68d2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0396 | D1 | LAST_UPDATE_DATE / Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-d8a24723 COLUMN / 원장 V-e36f9e31 COLUMN / 원장 V-82fb9028 COLUMN / 원장 V-0ddb66f3 COLUMN / 원장 V-4b28c5fc ASIS / 원장 V-0 |  | 17 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0397 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-4b28c5fc |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0398 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-00e0a344 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0399 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-c0e9cc82 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0400 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-348345de |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0401 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-a2e220ed |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0402 | D1 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D1 도구 오류 — 원장 V-916e8b2c |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0403 | D1 | MODULE_PER_CAR / Module/Car | 하네스·환경 | D1 도구 오류 — 원장 V-6e5e9f60 COLUMN / 원장 V-d9502e85 COLUMN / 원장 V-badde4c6 COLUMN / 원장 V-dca8b94d COLUMN / 원장 V-1b1b14bf ASIS / 원장 V-f |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0404 | D1 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D1 도구 오류 — 원장 V-1b1b14bf |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0405 | D1 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D1 도구 오류 — 원장 V-f2cffed8 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0406 | D1 | NICK_NAME / Nick Name | 하네스·환경 | D1 도구 오류 — 원장 V-82a0e353 COLUMN / 원장 V-dba09cff COLUMN / 원장 V-db003f21 COLUMN / 원장 V-15b709c3 COLUMN / 원장 V-0e2399bd ASIS / 원장 V-8 |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0407 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-0e2399bd |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0408 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-8de98e0e |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0409 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-5fdb002c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0410 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-4c422a80 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0411 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-670b1c8a |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0412 | D1 | NICK_NAME,NICK_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-636851bd |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0413 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-65e05c15 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0414 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-3cde637b |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0415 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-af84e0dc |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0416 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-8eb7d233 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0417 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-e3490583 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0418 | D1 | OWNER,OWNER | 하네스·환경 | D1 도구 오류 — 원장 V-69a92c89 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0419 | D1 | PROJECT_CODE / Project Code | 하네스·환경 | D1 도구 오류 — 원장 V-b1036689 COLUMN / 원장 V-aae44ed0 COLUMN / 원장 V-04ed5b70 COLUMN / 원장 V-e8cc89ea COLUMN / 실측[T-43079efc]: 기존행 r0 PROJ |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0420 | D1 | PROJECT_INFO / Project | 하네스·환경 | D1 도구 오류 — 원장 V-2a3b6857 COLUMN / 원장 V-35d42273 COLUMN / 실측[T-82f999c8]: 기존행 r0 PROJECT_INFO 편집=true — AS-IS 조건부(행 값으로 계산 불가): RUL |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0421 | D1 | PROJECT_NAME / Project | 하네스·환경 | D1 도구 오류 — 원장 V-c7dfe394 COLUMN / 원장 V-dff85d24 COLUMN / 원장 V-669fb853 COLUMN / 원장 V-c96e0c47 COLUMN / 원장 V-2b30b521 ASIS / 원장 V-3 |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0422 | D1 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-2b30b521 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0423 | D1 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-38fd2d14 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0424 | D1 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-a13bec7b |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0425 | D1 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D1 도구 오류 — 원장 V-06a9bdd1 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0426 | D1 | SALES_COMPANY / Sales Company | 하네스·환경 | D1 도구 오류 — 원장 V-500660a2 COLUMN / 원장 V-48102f42 COLUMN / 원장 V-6fcae448 COLUMN / 원장 V-c25a5fa1 COLUMN / 실측[T-037a1323]: 기존행 r0 SALE |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0427 | D1 | SALES_PLANT / Sales Plant | 하네스·환경 | D1 도구 오류 — 원장 V-273c2ccf COLUMN / 원장 V-dc8c1ca4 COLUMN / 원장 V-75a7c680 COLUMN / 원장 V-32de1ea0 COLUMN / 실측[T-e9098a87]: 기존행 r0 SALE |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0428 | D1 | SHIPTO_CODE / Rep Ship-To | 하네스·환경 | D1 도구 오류 — 원장 V-ad478cc9 COLUMN / 원장 V-763bd9b0 COLUMN / 원장 V-631742ed ASIS / 원장 V-d86fb115 ASIS / 원장 V-ce0d335a ASIS / 원장 V-ac714 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0429 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-631742ed |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0430 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-d86fb115 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0431 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-ce0d335a |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0432 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-ac714fc6 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0433 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-f2d79507 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0434 | D1 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-a2990811 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0435 | D1 | SOLDTO_CODE / Sold-To | 하네스·환경 | D1 도구 오류 — 원장 V-45f93e4b COLUMN / 원장 V-99cdccb4 COLUMN / 원장 V-cc422665 ASIS / 원장 V-4668ff31 ASIS / 원장 V-578d8d86 ASIS / 원장 V-c07a4 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0436 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-cc422665 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0437 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-4668ff31 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0438 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-578d8d86 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0439 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-c07a4d36 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0440 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-678d26b0 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0441 | D1 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D1 도구 오류 — 원장 V-eededa7a |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0442 | D1 | SOLDTO_CUSTOMER / Sold-To Customer | 하네스·환경 | D1 도구 오류 — 원장 V-fd52ccd4 COLUMN / 원장 V-947cffc9 COLUMN / 원장 V-74e01e33 ASIS / 원장 V-65868fda ASIS / 실측[T-02f4a940]: 기존행 r0 SOLDTO_C |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0443 | D1 | SOLDTO_CUSTOMER,SOLDTO_CUSTOMER | 하네스·환경 | D1 도구 오류 — 원장 V-74e01e33 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0444 | D1 | SOLDTO_CUSTOMER,SOLDTO_CUSTOMER | 하네스·환경 | D1 도구 오류 — 원장 V-65868fda |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0445 | D1 | VALID_YN / Active | 하네스·환경 | D1 도구 오류 — 원장 V-7ba316a8 COLUMN / 원장 V-52e9bf90 COLUMN / 원장 V-03fa5d1a COLUMN / 원장 V-7d82f62d COLUMN / 실측[T-a06b78b7]: 기존행 r0 VALI |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0446 | D3 | ACTIVE_FLAG / MDM Active | 하네스·환경 | D3 도구 오류 — 원장 V-dcd919b5 ASIS / 원장 V-5deec30e ASIS / 원장 V-5635001c ASIS / 원장 V-185e9099 ASIS / 실측[T-7cd59b84]: 조건 계산 불가(검사기가 AS-IS |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0447 | D3 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-dcd919b5 / 실측[T-4424c2d0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0448 | D3 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-5deec30e / 실측[T-29357b6d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0449 | D3 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-5635001c / 실측[T-b26e37a1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0450 | D3 | ACTIVE_FLAG,ACTIVE_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-185e9099 / 실측[T-7d32cb47]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0451 | D3 | APPLICATION / Application | 하네스·환경 | D3 도구 오류 — 원장 V-fec6437f ASIS / 원장 V-6b465f9c ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0452 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-6b465f9c |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0453 | D3 | ATTRIBUTE1,ATTRIBUTE1 | 하네스·환경 | D3 도구 오류 — 원장 V-3b267421 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0454 | D3 | ATTRIBUTE2,ATTRIBUTE2 | 하네스·환경 | D3 도구 오류 — 원장 V-6ddc3f41 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0455 | D3 | ATTRIBUTE2,ATTRIBUTE2 | 하네스·환경 | D3 도구 오류 — 원장 V-9fbe330c |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0456 | D3 | ATTRIBUTE4 / Destination | 하네스·환경 | D3 도구 오류 — 원장 V-47a130b8 ASIS / 원장 V-0b082532 ASIS / 실측[T-5334b4b7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetVa |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0457 | D3 | ATTRIBUTE4,ATTRIBUTE4 | 하네스·환경 | D3 도구 오류 — 원장 V-47a130b8 / 실측[T-e67379c2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0458 | D3 | ATTRIBUTE4,ATTRIBUTE4 | 하네스·환경 | D3 도구 오류 — 원장 V-0b082532 / 실측[T-c43fefa8]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0459 | D3 | ATTRIBUTE5 / Cell Model | 하네스·환경 | D3 도구 오류 — 원장 V-9cd00749 ASIS / 원장 V-76f5ecfa ASIS / 실측[T-240d1118]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetVa |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0460 | D3 | ATTRIBUTE5,ATTRIBUTE5 | 하네스·환경 | D3 도구 오류 — 원장 V-9cd00749 / 실측[T-139fc801]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0461 | D3 | ATTRIBUTE5,ATTRIBUTE5 | 하네스·환경 | D3 도구 오류 — 원장 V-76f5ecfa / 실측[T-ef7be8db]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0462 | D3 | BPMS_EXIST / BPMS Exist | 하네스·환경 | D3 도구 오류 — 원장 V-55108311 ASIS / 원장 V-8402fbd7 ASIS / 원장 V-22ed2b66 ASIS / 원장 V-bca0cc2a ASIS / 실측[T-6860415e]: 조건 계산 불가(검사기가 AS-IS |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0463 | D3 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D3 도구 오류 — 원장 V-55108311 / 실측[T-b027db7e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0464 | D3 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D3 도구 오류 — 원장 V-8402fbd7 / 실측[T-2304dc94]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0465 | D3 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D3 도구 오류 — 원장 V-22ed2b66 / 실측[T-21c21346]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0466 | D3 | BPMS_EXIST,BPMS_EXIST | 하네스·환경 | D3 도구 오류 — 원장 V-bca0cc2a / 실측[T-3d3a640e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0467 | D3 | CELL_S_OP_REPORT / Cell Prod. Site (S&OP | 하네스·환경 | D3 도구 오류 — 원장 V-ac11ac70 ASIS / 원장 V-16f4aba4 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0468 | D3 | CELL_S_OP_REPORT,CELL_S_OP_REPORT | 하네스·환경 | D3 도구 오류 — 원장 V-16f4aba4 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0469 | D3 | CHANGE_REASON / CHANGE REASON | 하네스·환경 | D3 도구 오류 — 원장 V-a27e62eb ASIS / 원장 V-3f626eac ASIS / 원장 V-0f1a95c2 ASIS / 원장 V-78539bc5 ASIS / 실측[T-edaba3f1]: 조건 계산 불가(검사기가 AS-IS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0470 | D3 | CHANGE_REASON,CHANGE_REASON | 하네스·환경 | D3 도구 오류 — 원장 V-a27e62eb / 실측[T-fe7466bc]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0471 | D3 | CHANGE_REASON,CHANGE_REASON | 하네스·환경 | D3 도구 오류 — 원장 V-3f626eac / 실측[T-b0981fe4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0472 | D3 | CHANGE_REASON,CHANGE_REASON | 하네스·환경 | D3 도구 오류 — 원장 V-0f1a95c2 / 실측[T-721e9be4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0473 | D3 | CHANGE_REASON,CHANGE_REASON | 하네스·환경 | D3 도구 오류 — 원장 V-78539bc5 / 실측[T-46b9e94e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0474 | D3 | CONSENSUS_ESS / ESS Subsidiary | 하네스·환경 | D3 도구 오류 — 원장 V-c038f46f ASIS / 원장 V-26bed28c ASIS / 원장 V-c7a3f202 ASIS / 원장 V-5dffd518 ASIS / 실측[T-faf2fdf4]: 조건 계산 불가(검사기가 AS-IS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0475 | D3 | CONSENSUS_ESS,CONSENSUS_ESS | 하네스·환경 | D3 도구 오류 — 원장 V-c038f46f / 실측[T-ae33360b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0476 | D3 | CONSENSUS_ESS,CONSENSUS_ESS | 하네스·환경 | D3 도구 오류 — 원장 V-26bed28c / 실측[T-65aa83c5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0477 | D3 | CONSENSUS_ESS,CONSENSUS_ESS | 하네스·환경 | D3 도구 오류 — 원장 V-c7a3f202 / 실측[T-c0e6e544]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0478 | D3 | CONSENSUS_ESS,CONSENSUS_ESS | 하네스·환경 | D3 도구 오류 — 원장 V-5dffd518 / 실측[T-d3382ede]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0479 | D3 | CONSENSUS_MKT / MKT | 하네스·환경 | D3 도구 오류 — 원장 V-06769424 ASIS / 원장 V-6870eb25 ASIS / 원장 V-c3a3f891 ASIS / 원장 V-74fb5497 ASIS / 실측[T-54081fbd]: 조건 계산 불가(검사기가 AS-IS |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0480 | D3 | CONSENSUS_MKT,CONSENSUS_MKT | 하네스·환경 | D3 도구 오류 — 원장 V-06769424 / 실측[T-cd687bc0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0481 | D3 | CONSENSUS_MKT,CONSENSUS_MKT | 하네스·환경 | D3 도구 오류 — 원장 V-6870eb25 / 실측[T-d884c62d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0482 | D3 | CONSENSUS_MKT,CONSENSUS_MKT | 하네스·환경 | D3 도구 오류 — 원장 V-c3a3f891 / 실측[T-aa9b1f2a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0483 | D3 | CONSENSUS_MKT,CONSENSUS_MKT | 하네스·환경 | D3 도구 오류 — 원장 V-74fb5497 / 실측[T-e5319613]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0484 | D3 | CONSENSUS_SCM / SCM | 하네스·환경 | D3 도구 오류 — 원장 V-54faaefa ASIS / 원장 V-007b684e ASIS / 원장 V-55fbf22a ASIS / 원장 V-b33ba922 ASIS / 실측[T-3fe13999]: 조건 계산 불가(검사기가 AS-IS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0485 | D3 | CONSENSUS_SCM,CONSENSUS_SCM | 하네스·환경 | D3 도구 오류 — 원장 V-54faaefa / 실측[T-2696e0be]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0486 | D3 | CONSENSUS_SCM,CONSENSUS_SCM | 하네스·환경 | D3 도구 오류 — 원장 V-007b684e / 실측[T-7c32a402]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0487 | D3 | CONSENSUS_SCM,CONSENSUS_SCM | 하네스·환경 | D3 도구 오류 — 원장 V-55fbf22a / 실측[T-2e85bd34]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0488 | D3 | CONSENSUS_SCM,CONSENSUS_SCM | 하네스·환경 | D3 도구 오류 — 원장 V-b33ba922 / 실측[T-13eea0fa]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0489 | D3 | CUSTOMER_MODEL / Customer Model | 하네스·환경 | D3 도구 오류 — 원장 V-ab839a26 ASIS / 원장 V-8a246db5 ASIS / 원장 V-7bf67a3c ASIS / 원장 V-899a5eb9 ASIS / 원장 V-2654d2d0 ASIS / 원장 V-f55d0c25  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0490 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-ab839a26 / 실측[T-3140c026]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0491 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-8a246db5 / 실측[T-20be0923]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0492 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-899a5eb9 / 실측[T-fe8475b4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0493 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-2654d2d0 / 실측[T-fdba6409]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0494 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-f55d0c25 / 실측[T-38a63ec2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0495 | D3 | CUSTOMER_MODEL,CUSTOMER_MODEL | 하네스·환경 | D3 도구 오류 — 원장 V-c09cde0c / 실측[T-e211d118]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0496 | D3 | CUST_GROUP / Cust Group | 하네스·환경 | D3 도구 오류 — 원장 V-0026b18b ASIS / 원장 V-81d69c8e ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0497 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-81d69c8e |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0498 | D3 | CUST_GROUP_DTL / Cust Group Detail | 하네스·환경 | D3 도구 오류 — 원장 V-17f5d4f5 ASIS / 원장 V-685da39e ASIS / 원장 V-b7727260 ASIS / 원장 V-f77b5d6d ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0499 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-b7727260 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0500 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-f77b5d6d |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0501 | D3 | DEPT_ID / Team | 하네스·환경 | D3 도구 오류 — 원장 V-a27b6577 ASIS / 원장 V-050ea287 ASIS / 원장 V-d01285be ASIS |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0502 | D3 | DEPT_ID,DEPT_ID | 하네스·환경 | D3 도구 오류 — 원장 V-050ea287 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0503 | D3 | DEPT_ID,DEPT_ID | 하네스·환경 | D3 도구 오류 — 원장 V-d01285be |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0504 | D3 | DIVISION_ID / Division | 하네스·환경 | D3 도구 오류 — 원장 V-a5d8e80d ASIS / 원장 V-cb6a1e4c ASIS / 원장 V-36b76597 ASIS / 원장 V-b337a125 ASIS / 원장 V-3c648d34 ASIS / 원장 V-29b1f0c0  |  | 34 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0505 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a5d8e80d / 실측[T-f2a066b7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0506 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-cb6a1e4c / 실측[T-c2cc687a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0507 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-36b76597 / 실측[T-a0a860db]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0508 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-29b1f0c0 / 실측[T-0c209ba9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0509 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-208662de / 실측[T-08d26b0e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0510 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-f53274b0 / 실측[T-8a290566]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0511 | D3 | DIVISION_ID,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-3c648d34 / 실측[T-47ecbb61]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0512 | D3 | DIVISION_ID,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-315307b6 / 실측[T-0164de49]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0513 | D3 | DIVISION_ID,VALID_YN | 하네스·환경 | D3 도구 오류 — 원장 V-b337a125 / 실측[T-05f46cad]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0514 | D3 | DIVISION_ID,VALID_YN | 하네스·환경 | D3 도구 오류 — 원장 V-216ef0bd / 실측[T-2f89c95c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0515 | D3 | EDIT_FLAG3 / Edit Flag | 하네스·환경 | D3 도구 오류 — 원장 V-0026b18b ASIS / 원장 V-55964fbe ASIS / 원장 V-a2329b00 ASIS / 원장 V-2526ae7b ASIS / 원장 V-a73af24a ASIS / 원장 V-ccb7fc69  |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0516 | D3 | END_CUSTOMER / End Customer | 하네스·환경 | D3 도구 오류 — 원장 V-9ccefd53 ASIS / 원장 V-b6776da1 ASIS / 원장 V-d5a34d9f ASIS / 원장 V-11fe8649 ASIS / 실측[T-8babd9be]: 조건 계산 불가(검사기가 AS-IS |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0517 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-9ccefd53 / 실측[T-62228c7a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0518 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-b6776da1 / 실측[T-153410cc]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0519 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-d5a34d9f / 실측[T-0dfb5ad1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0520 | D3 | END_CUSTOMER,END_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-11fe8649 / 실측[T-bcfd8a56]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0521 | D3 | INVENTORY_DAY / INVENTORY DAY | 하네스·환경 | D3 도구 오류 — 원장 V-8cb2c7b8 ASIS / 원장 V-10d8cceb ASIS / 원장 V-d699f4c2 ASIS / 원장 V-e81774f9 ASIS / 실측[T-da2b6703]: 조건 계산 불가(검사기가 AS-IS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0522 | D3 | INVENTORY_DAY,INVENTORY_DAY | 하네스·환경 | D3 도구 오류 — 원장 V-8cb2c7b8 / 실측[T-d9ade022]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0523 | D3 | INVENTORY_DAY,INVENTORY_DAY | 하네스·환경 | D3 도구 오류 — 원장 V-10d8cceb / 실측[T-6853e3e4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0524 | D3 | INVENTORY_DAY,INVENTORY_DAY | 하네스·환경 | D3 도구 오류 — 원장 V-d699f4c2 / 실측[T-7d5de02f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0525 | D3 | INVENTORY_DAY,INVENTORY_DAY | 하네스·환경 | D3 도구 오류 — 원장 V-e81774f9 / 실측[T-0a749a72]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0526 | D3 | ITEM_CLASS_NAME / Model Type | 하네스·환경 | D3 도구 오류 — 원장 V-b11211dd ASIS / 원장 V-a1aac558 ASIS / 원장 V-faca0b06 ASIS / 원장 V-d119aba8 ASIS / 원장 V-db71f275 ASIS / 원장 V-b84c1c14  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0527 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b11211dd / 실측[T-d2561327]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0528 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a1aac558 / 실측[T-e0846d84]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0529 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-faca0b06 / 실측[T-4ba1bfc0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0530 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-d119aba8 / 실측[T-cf9fc350]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0531 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-db71f275 / 실측[T-c48cebe6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0532 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b84c1c14 / 실측[T-8150bed5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0533 | D3 | ITEM_ID / Model | 하네스·환경 | D3 도구 오류 — 원장 V-0b7a8b19 ASIS / 원장 V-de7573f2 ASIS / 원장 V-7e5f8ade ASIS / 원장 V-4efc3359 ASIS / 원장 V-e1e03151 ASIS / 원장 V-0ae3a71d  |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0534 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-0b7a8b19 / 실측[T-e8385b81]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0535 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-de7573f2 / 실측[T-b492ab1e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0536 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-7e5f8ade / 실측[T-61938555]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0537 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-0ae3a71d / 실측[T-9357ba8a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0538 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-989d2ce9 / 실측[T-bb27f808]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0539 | D3 | ITEM_ID,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-2f2dd758 / 실측[T-5374ad6e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0540 | D3 | ITEM_ID_AFTER | 하네스·환경 | D3 도구 오류 — 실측[T-b811f374]: 팝업 내부 컬럼 ITEM_ID_AFTER — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.EditButton:1) |
| WK-DMF0005-0541 | D3 | ITEM_ID_BEFORE | 하네스·환경 | D3 도구 오류 — 실측[T-42c078e6]: 팝업 내부 컬럼 ITEM_ID_BEFORE — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:DMF0005_ModelCodeChange.EditButton A) |
| WK-DMF0005-0542 | D3 | ITEM_NAME / Model Name | 하네스·환경 | D3 도구 오류 — 원장 V-34c3037f ASIS / 원장 V-bd9393cd ASIS / 원장 V-6782067a ASIS / 원장 V-d0d2db4f ASIS / 원장 V-3523584b ASIS / 원장 V-acae9ec8  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0543 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-34c3037f / 실측[T-323e3c1c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0544 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-bd9393cd / 실측[T-7cb5ed2f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0545 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-6782067a / 실측[T-61a4dc0f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0546 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-d0d2db4f / 실측[T-49ce9e85]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0547 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3523584b / 실측[T-e91ed637]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0548 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-acae9ec8 / 실측[T-d290efda]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0549 | D3 | ITEM_TYPE / Item Type | 하네스·환경 | D3 도구 오류 — 원장 V-13369e16 ASIS / 원장 V-dd2d05f5 ASIS / 원장 V-942c3a16 ASIS / 원장 V-4efc3359 ASIS / 원장 V-e1e03151 ASIS / 원장 V-738a00b8  |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0550 | D3 | ITEM_TYPE,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-4efc3359 / 실측[T-087348c7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0551 | D3 | ITEM_TYPE,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-e1e03151 / 실측[T-ca63c7ee]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0552 | D3 | ITEM_TYPE,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-5d8655e2 / 실측[T-191c76f0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0553 | D3 | ITEM_TYPE,ITEM_ID | 하네스·환경 | D3 도구 오류 — 원장 V-f31b1630 / 실측[T-5efa1641]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0554 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-13369e16 / 실측[T-db24b50c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0555 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-dd2d05f5 / 실측[T-1591cb74]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0556 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-942c3a16 / 실측[T-a7f02bc5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0557 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-738a00b8 / 실측[T-e34fc14e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0558 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-d094842a / 실측[T-14542765]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0559 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-4d6ea9ef / 실측[T-af457bfd]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0560 | D3 | LAST_UPDATED_BY / Update By | 하네스·환경 | D3 도구 오류 — 원장 V-41138288 ASIS / 원장 V-05c61670 ASIS / 원장 V-b05187d6 ASIS / 원장 V-9e34dd66 ASIS / 원장 V-3207769b ASIS / 원장 V-01b44d35  |  | 13 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0561 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-41138288 / 실측[T-a4852eaa]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0562 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-05c61670 / 실측[T-06f1a012]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0563 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-b05187d6 / 실측[T-19569dbf]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0564 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-9e34dd66 / 실측[T-11cad1b7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0565 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-3207769b / 실측[T-c2d19c9d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0566 | D3 | LAST_UPDATED_BY,LAST_UPDATED_BY | 하네스·환경 | D3 도구 오류 — 원장 V-01b44d35 / 실측[T-19a4f46b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0567 | D3 | LAST_UPDATE_DATE / Update Date | 하네스·환경 | D3 도구 오류 — 원장 V-b49e5d35 ASIS / 원장 V-883eebbb ASIS / 원장 V-1ddb536b ASIS / 원장 V-f0605e72 ASIS / 원장 V-5b72c093 ASIS / 원장 V-5efbee96  |  | 17 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0568 | D3 | LAST_UPDATE_DATE,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-f0605e72 / 실측[T-8e2dac6b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0569 | D3 | LAST_UPDATE_DATE,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-5b72c093 / 실측[T-c56e18f2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0570 | D3 | LAST_UPDATE_DATE,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-6f59864b / 실측[T-790a0f26]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0571 | D3 | LAST_UPDATE_DATE,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-2e265b6d / 실측[T-41e376ea]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0572 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-b49e5d35 / 실측[T-446f010e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0573 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-883eebbb / 실측[T-a72ad8d4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0574 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-1ddb536b / 실측[T-c5c206b0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0575 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-5efbee96 / 실측[T-30a3ecf9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0576 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-f9f7e13c / 실측[T-a85043ba]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0577 | D3 | LAST_UPDATE_DATE,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-aa0be6aa / 실측[T-ab85dbc9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0578 | D3 | LIABILITY_PERIOD / Liablity(Week | 하네스·환경 | D3 도구 오류 — 원장 V-1ada419c ASIS / 원장 V-140aeb14 ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0579 | D3 | LIABILITY_PERIOD,LIABILITY_PERIOD | 하네스·환경 | D3 도구 오류 — 원장 V-140aeb14 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0580 | D3 | MODULE_PER_CAR / Module/Car | 하네스·환경 | D3 도구 오류 — 원장 V-a4a8d7df ASIS / 원장 V-7bf67a3c ASIS / 원장 V-006bb850 ASIS / 원장 V-2a583741 ASIS |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0581 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-006bb850 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0582 | D3 | NICK_NAME / Nick Name | 하네스·환경 | D3 도구 오류 — 원장 V-d86ab623 ASIS / 원장 V-b35a593c ASIS / 원장 V-174975e0 ASIS / 원장 V-d3017ea4 ASIS / 원장 V-5c9f7db9 ASIS / 원장 V-6d91e09c  |  | 18 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0583 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-d86ab623 / 실측[T-46babd39]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0584 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b35a593c / 실측[T-1163d06c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0585 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-174975e0 / 실측[T-833958f1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0586 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-6d91e09c / 실측[T-fa7e46ea]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0587 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-89bff02f / 실측[T-12664b6d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0588 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-797bbd0e / 실측[T-f37a2c54]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0589 | D3 | NICK_NAME,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-d3017ea4 / 실측[T-0da0134b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0590 | D3 | NICK_NAME,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-5c9f7db9 / 실측[T-c6123016]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0591 | D3 | NICK_NAME,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-5bafb68e / 실측[T-d8b4a40d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0592 | D3 | NICK_NAME,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-ee021700 / 실측[T-d5c85ccd]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0593 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-267487d4 / 실측[T-d63f9454]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0594 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-4e03b11a / 실측[T-0492db59]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0595 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-d4b33fa1 / 실측[T-199073f1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0596 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-aaeb61a5 / 실측[T-014ff1c7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0597 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-f150ed14 / 실측[T-15893cf9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0598 | D3 | PRODUCTION_PROCESS / Production Process | 하네스·환경 | D3 도구 오류 — 원장 V-55964fbe ASIS / 원장 V-d02b18c7 ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0599 | D3 | PRODUCTION_PROCESS,PRODUCTION_PROCESS | 하네스·환경 | D3 도구 오류 — 원장 V-d02b18c7 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0600 | D3 | PROJECT_CODE / Project Code | 하네스·환경 | D3 도구 오류 — 원장 V-8880c14f ASIS / 원장 V-32f720b0 ASIS / 원장 V-0529ac91 ASIS / 원장 V-45c30983 ASIS / 원장 V-b2524d85 ASIS / 원장 V-452f68ec  |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0601 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-8880c14f / 실측[T-db890f33]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0602 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-32f720b0 / 실측[T-72e40979]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0603 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-b2524d85 / 실측[T-276d6fbd]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0604 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-452f68ec / 실측[T-77ab0daa]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0605 | D3 | PROJECT_CODE,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-0529ac91 / 실측[T-51a1fc7c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0606 | D3 | PROJECT_CODE,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-45c30983 / 실측[T-cbe0321f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0607 | D3 | PROJECT_CODE,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-b6b230ec / 실측[T-c62c04d9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0608 | D3 | PROJECT_CODE,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-750aff93 / 실측[T-ad8e6aa9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0609 | D3 | PROJECT_INFO,PROJECT_INFO | 하네스·환경 | D3 도구 오류 — 원장 V-e3402566 / 실측[T-f2abdf79]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0610 | D3 | PROJECT_INFO,PROJECT_INFO | 하네스·환경 | D3 도구 오류 — 원장 V-6dae2093 / 실측[T-b239de7d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0611 | D3 | PROJECT_NAME / Project | 하네스·환경 | D3 도구 오류 — 원장 V-fe4a26f0 ASIS / 원장 V-e2ce11c3 ASIS / 원장 V-2db4c3b6 ASIS / 원장 V-7d7169af ASIS / 실측[T-b341e193]: 조건 계산 불가(검사기가 AS-IS |  | 10 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0612 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-fe4a26f0 / 실측[T-00ccc8b1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0613 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-e2ce11c3 / 실측[T-a554104c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0614 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2db4c3b6 / 실측[T-e1f1eef2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0615 | D3 | PROJECT_NAME,PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-7d7169af / 실측[T-8dd05698]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0616 | D3 | PROJECT_OWNER / Project Owner | 하네스·환경 | D3 도구 오류 — 원장 V-952283ab ASIS / 원장 V-bad1a0a9 ASIS / 원장 V-43c3a214 ASIS / 원장 V-c4fb5418 ASIS / 원장 V-1a8bd269 ASIS / 원장 V-b6488205  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0617 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-952283ab / 실측[T-c18cf9b4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0618 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-bad1a0a9 / 실측[T-1fdc24c3]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0619 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-43c3a214 / 실측[T-f6dfa680]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0620 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-c4fb5418 / 실측[T-820fe716]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0621 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-1a8bd269 / 실측[T-64aae33b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0622 | D3 | PROJECT_OWNER,PROJECT_OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-b6488205 / 실측[T-bf78151b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0623 | D3 | PROJECT_STATUS / Project Status | 하네스·환경 | D3 도구 오류 — 원장 V-e8c66937 ASIS / 원장 V-83f7de0a ASIS / 원장 V-0529ac91 ASIS / 원장 V-45c30983 ASIS / 원장 V-e7f8dc42 ASIS / 원장 V-4eef3b7a  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0624 | D3 | PROJECT_STATUS,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-e8c66937 / 실측[T-f411f1c3]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0625 | D3 | PROJECT_STATUS,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-83f7de0a / 실측[T-35c14d6c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0626 | D3 | PROJECT_STATUS,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-e7f8dc42 / 실측[T-62018cb9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0627 | D3 | PROJECT_STATUS,PROJECT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-4eef3b7a / 실측[T-bf69da59]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0628 | D3 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | D3 도구 오류 — 원장 V-92b137fa ASIS / 원장 V-3f52fcfd ASIS / 원장 V-7e8aee23 ASIS / 원장 V-e8866535 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0629 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-92b137fa / 실측[T-bad387bf]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0630 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-3f52fcfd / 실측[T-776c616e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0631 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-7e8aee23 / 실측[T-cadaf212]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0632 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-e8866535 / 실측[T-e31b068f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0633 | D3 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | D3 도구 오류 — 원장 V-6928018b ASIS / 원장 V-f732f695 ASIS / 원장 V-eeb2e6f9 ASIS / 원장 V-e1f71178 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0634 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-6928018b / 실측[T-d45bd926]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0635 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-f732f695 / 실측[T-b441730c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0636 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-eeb2e6f9 / 실측[T-1e977ea2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0637 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-e1f71178 / 실측[T-6bb8e4d9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0638 | D3 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-b2ed47fc ASIS / 원장 V-cbf5285e ASIS / 원장 V-654e8be9 ASIS / 원장 V-75464ef1 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0639 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-b2ed47fc / 실측[T-d3bdd093]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0640 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-cbf5285e / 실측[T-ada52757]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0641 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-654e8be9 / 실측[T-9ab31597]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0642 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-75464ef1 / 실측[T-8df1c944]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0643 | D3 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-dca447f2 ASIS / 원장 V-596ca861 ASIS / 원장 V-227b1b57 ASIS / 원장 V-8840f2cc ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0644 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-dca447f2 / 실측[T-c8655dc9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0645 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-596ca861 / 실측[T-f3eccdc9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0646 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-227b1b57 / 실측[T-1a73f2e2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0647 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-8840f2cc / 실측[T-73d70ac6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0648 | D3 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | D3 도구 오류 — 원장 V-40a11214 ASIS / 원장 V-d11a4aa7 ASIS / 원장 V-bc6d8d46 ASIS / 원장 V-bd56d364 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0649 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-40a11214 / 실측[T-e3ec00da]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0650 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-d11a4aa7 / 실측[T-096362b0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0651 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-bc6d8d46 / 실측[T-d98efec5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0652 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-bd56d364 / 실측[T-d4bda84e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0653 | D3 | ROUTE / Channel | 하네스·환경 | D3 도구 오류 — 원장 V-8a6a00b2 ASIS / 원장 V-515a718e ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0654 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-515a718e |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0655 | D3 | SALES_COMPANY / Sales Company | 하네스·환경 | D3 도구 오류 — 원장 V-a2329b00 ASIS / 원장 V-c2e797d7 ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0656 | D3 | SALES_COMPANY,SALES_COMPANY | 하네스·환경 | D3 도구 오류 — 원장 V-c2e797d7 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0657 | D3 | SALES_PLANT / Sales Plant | 하네스·환경 | D3 도구 오류 — 원장 V-2526ae7b ASIS / 원장 V-b8830b94 ASIS |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0658 | D3 | SALES_PLANT,SALES_PLANT | 하네스·환경 | D3 도구 오류 — 원장 V-b8830b94 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0659 | D3 | SCM_SITE_ID / Sales Site | 하네스·환경 | D3 도구 오류 — 원장 V-95d3074e ASIS / 원장 V-ecde561b ASIS / 원장 V-a9859b65 ASIS / 원장 V-11778e5a ASIS / 실측[T-211f8264]: 조건 계산 불가(검사기가 AS-IS |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0660 | D3 | SCM_SITE_ID,SCM_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-95d3074e / 실측[T-95afc584]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0661 | D3 | SCM_SITE_ID,SCM_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-ecde561b / 실측[T-c133520d]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0662 | D3 | SCM_SITE_ID,SCM_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a9859b65 / 실측[T-668b60b2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0663 | D3 | SCM_SITE_ID,SCM_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-11778e5a / 실측[T-679f8432]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0664 | D3 | SHIPTO_CODE / Rep Ship-To | 하네스·환경 | D3 도구 오류 — 원장 V-ded45edb ASIS / 원장 V-dd56b826 ASIS / 원장 V-50c574bd ASIS / 원장 V-2c06cbc1 ASIS / 원장 V-1cfcbb59 ASIS / 원장 V-d675d997  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0665 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-ded45edb / 실측[T-da7257aa]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0666 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-dd56b826 / 실측[T-e1115236]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0667 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-50c574bd / 실측[T-54a82c4a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0668 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-2c06cbc1 / 실측[T-75e8353e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0669 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-1cfcbb59 / 실측[T-8bc5fabe]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0670 | D3 | SHIPTO_CODE,SHIPTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-d675d997 / 실측[T-0d14ed67]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0671 | D3 | SHIPTO_DESCRIPTION / Rep Ship-To | 하네스·환경 | D3 도구 오류 — 원장 V-9306d274 ASIS / 원장 V-30a0349f ASIS / 원장 V-8a643791 ASIS / 원장 V-1edebccc ASIS / 원장 V-ae539256 ASIS / 원장 V-cabd94a0  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0672 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-9306d274 / 실측[T-ecbc87ab]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0673 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-30a0349f / 실측[T-d97a562a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0674 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-8a643791 / 실측[T-b33fff8a]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0675 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-1edebccc / 실측[T-3d52072c]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0676 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-ae539256 / 실측[T-f5c12518]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0677 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-cabd94a0 / 실측[T-374bea38]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0678 | D3 | SOLDTO_CODE / Sold-To | 하네스·환경 | D3 도구 오류 — 원장 V-50218cda ASIS / 원장 V-f46e5e26 ASIS / 원장 V-0454dadd ASIS / 원장 V-8beebc5b ASIS / 원장 V-a37d8826 ASIS / 원장 V-a11c70b3  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0679 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-50218cda / 실측[T-628a1e7b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0680 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-f46e5e26 / 실측[T-c27ed0c2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0681 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-0454dadd / 실측[T-0436ca5e]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0682 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-8beebc5b / 실측[T-7767edbb]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0683 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-a37d8826 / 실측[T-d14a6db7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0684 | D3 | SOLDTO_CODE,SOLDTO_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-a11c70b3 / 실측[T-fc0c3de2]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0685 | D3 | SOLDTO_DESCRIPTION / Sold-To | 하네스·환경 | D3 도구 오류 — 원장 V-1d9c9494 ASIS / 원장 V-58aff0d1 ASIS / 원장 V-57ee2b83 ASIS / 원장 V-8e2b42ea ASIS / 원장 V-3a6db85a ASIS / 원장 V-81495fda  |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0686 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-1d9c9494 / 실측[T-ff8621b1]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0687 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-58aff0d1 / 실측[T-b75e94f4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0688 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-57ee2b83 / 실측[T-b4f16104]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0689 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-8e2b42ea / 실측[T-1d41fde8]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0690 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-3a6db85a / 실측[T-9fa38910]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0691 | D3 | SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-81495fda / 실측[T-b2856fcd]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (siMain.GetValue(iRow, siMain.GetColumn |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0692 | D3 | VALID_YN | 하네스·환경 | D3 도구 오류 — 원장 V-b4e6b570 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0693 | D3 | VALID_YN / Active | 하네스·환경 | D3 도구 오류 — 원장 V-b337a125 ASIS / 원장 V-e6fc82e6 ASIS / 원장 V-216ef0bd ASIS / 원장 V-b4e6b570 ASIS |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0694 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-88836071 / 실측[T-939b9170]: siMain.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Sav) |
| WK-DMF0005-0695 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-2c9c076b / 실측[T-ceec5b87]: siMain.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.S) |
| WK-DMF0005-0696 | D3 | siSub.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-92ef51e5 / 실측[T-ac8c3991]: siSub.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0697 | D3 | siSub.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-9f498338 / 실측[T-c05b8fb5]: siSub.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Sav) |
| WK-DMF0005-0698 | D3 | siSub.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-975a30a8 / 실측[T-53f19fe9]: siSub.SwitchLock: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.S) |
| WK-DMF0005-0699 | D5 | DMF0005_SaleSite_PjtModelMapping.CreateS | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.CreateSpread 의 D5 27요소: NA:20 · PASS:5 · ERROR:2 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.Cre) |
| WK-DMF0005-0700 | D5 | ITEM_ID_AFTER | 하네스·환경 | D5 도구 오류 — 실측[T-9b5797e4]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0701 | D5 | ITEM_ID_BEFORE | 하네스·환경 | D5 도구 오류 — 실측[T-f87d997b]: PRJ_OWNR_ID 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0702 | E4 | EDIT_FLAG / Edit Flag | 하네스·환경 | E4 도구 오류 — 원장 V-933c34a5 ASIS / 원장 V-21a5ba1d ASIS / 실측[T-4ea5e697]: MSG00430 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0703 | E4 | ITEM_ID / Model | 하네스·환경 | E4 도구 오류 — 원장 V-27b7f110 ASIS / 원장 V-66d0d650 ASIS / 원장 V-deaaf1d7 ASIS / 실측[T-dbe47dd4]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0704 | E4 | LIABILITY_PERIOD / Liablity(Week | 하네스·환경 | E4 도구 오류 — 원장 V-2d908ca2 ASIS / 원장 V-a08ac994 ASIS / 실측[T-e51483f1]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0705 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-66afd1d0 / 실측[T-e9230582]: MSG00096 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0706 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-66afd1d0 ASIS / 실측[T-399916e8]: MSG00096 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButto |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0707 | E4 | MSG00128 | 하네스·환경 | E4 도구 오류 — 원장 V-80d68e28 / 실측[T-a615c688]: MSG00128 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(s |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0708 | E4 | MSG00128 | 하네스·환경 | E4 도구 오류 — 원장 V-80d68e28 ASIS / 원장 V-da0195ec ASIS / 실측[T-2fe38288]: MSG00128 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0709 | E4 | MSG00128 | 하네스·환경 | E4 도구 오류 — 원장 V-da0195ec / 실측[T-851290bf]: MSG00128 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(s |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0710 | E4 | MSG00130 | 하네스·환경 | E4 도구 오류 — 원장 V-bf22bca4 / 실측[T-c34993d8]: MSG00130 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0711 | E4 | MSG00130 | 하네스·환경 | E4 도구 오류 — 원장 V-bf22bca4 ASIS / 원장 V-80d2d55d ASIS / 원장 V-d0533fc2 ASIS / 원장 V-138c2130 ASIS / 실측[T-588f3744]: MSG00130 — EditButt |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0712 | E4 | MSG00130 | 하네스·환경 | E4 도구 오류 — 원장 V-80d2d55d / 실측[T-e73526e0]: MSG00130 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Edi) |
| WK-DMF0005-0713 | E4 | MSG00130 | 하네스·환경 | E4 도구 오류 — 원장 V-d0533fc2 / 실측[T-e9fb526e]: MSG00130 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0714 | E4 | MSG00130 | 하네스·환경 | E4 도구 오류 — 원장 V-138c2130 / 실측[T-1c5646b4]: MSG00130 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.E) |
| WK-DMF0005-0715 | E4 | MSG00177 | 하네스·환경 | E4 도구 오류 — 원장 V-2d908ca2 / 실측[T-668a715a]: MSG00177 — shtMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0716 | E4 | MSG00177 | 하네스·환경 | E4 도구 오류 — 원장 V-2d908ca2 ASIS / 원장 V-a08ac994 ASIS / 실측[T-f67c28bd]: MSG00177 — shtMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save  |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0717 | E4 | MSG00177 | 하네스·환경 | E4 도구 오류 — 원장 V-a08ac994 / 실측[T-e343d020]: MSG00177 — shtMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0718 | E4 | MSG00471 | 하네스·환경 | E4 도구 오류 — 원장 V-66d0d650 / 실측[T-f4b07b53]: MSG00471 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(s |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0719 | E4 | MSG00471 | 하네스·환경 | E4 도구 오류 — 원장 V-66d0d650 ASIS / 실측[T-517b57cb]: MSG00471 — spdMain_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0720 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 하네스·환경 | A6 도구 오류 — 원장 V-0c2dd96c SP / 원장 V-33ebfb42 SP / 원장 V-e8dd5789 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-ac547fc3]: PKG_DMF0000.P_DMF0000_G |  | 181 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0721 | A6 | PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MOD | 하네스·환경 | A6 도구 오류 — 원장 V-84638646 SP / 정렬대조 PASS AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰  / 실측[T-dd297f08]: PKG_DMF0005.P_DMF0005 |  | 54 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0722 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-d46502d6 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0723 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-35125e61 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0724 | G1 | MSG00358 | 하네스·환경 | G1 도구 오류 — 원장 V-e72b0f26 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0725 | G1 | MSG00358 | 하네스·환경 | G1 도구 오류 — 원장 V-a95bddd2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0726 | G1 | chkEndCust / End Customer(Report) Null / | 하네스·환경 | G1 도구 오류 — 원장 V-6fde8919 SEARCH / E2E smoke cond Checkbox |  | 6 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0727 | G1 | chkProjectInfo / Project Null / Project  | 하네스·환경 | G1 도구 오류 — 원장 V-cde3ec4f SEARCH / E2E smoke cond Checkbox |  | 3 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0728 | G1 | txtProject / Project / PJT | 하네스·환경 | G1 도구 오류 — 원장 V-4deadb98 SEARCH / E2E smoke cond ProjectField |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0729 | X-ROW | DMF0005_ModelCodeChange.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:4 · PASS:2 · NA:1 |  | 7 (ACT:DMF0005_ModelCodeChange.EditButton:1) |
| WK-DMF0005-0730 | X-ROW | DMF0005_ModelCodeChange.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:8 · PASS:1 · NA:1 |  | 6 (ACT:DMF0005_ModelCodeChange.InitSpread A) |
| WK-DMF0005-0731 | X-ROW | DMF0005_ModelCodeChange.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:4 · NA:1 · PASS:1 |  | 7 (ACT:DMF0005_ModelCodeChange.InsertRow AC) |
| WK-DMF0005-0732 | X-ROW | DMF0005_ModelCodeChange.spdMain_TopChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 4 (ACT:DMF0005_ModelCodeChange.spdMain_TopC) |
| WK-DMF0005-0733 | X-ROW | DMF0005_SaleSite_PjtModelMapping.ClbTeam | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Clb) |
| WK-DMF0005-0734 | X-ROW | DMF0005_SaleSite_PjtModelMapping.CreateS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Cre) |
| WK-DMF0005-0735 | X-ROW | DMF0005_SaleSite_PjtModelMapping.FindBut | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — REVIEW:2 · ERROR:2 · PASS:2 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0736 | X-ROW | DMF0005_SaleSite_PjtModelMapping.FindDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:4 · PASS:3 · NA:2 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.Fin) |
| WK-DMF0005-0737 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InitSpr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:3 · ERROR:2 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.Ini) |
| WK-DMF0005-0738 | X-ROW | DMF0005_SaleSite_PjtModelMapping.InsertB | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · PASS:1 · NA:1 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.Ins) |
| WK-DMF0005-0739 | X-ROW | DMF0005_SaleSite_PjtModelMapping.clbDivi | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:3 · PASS:3 (미실행 검사가 남아 판정필요) |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0740 | X-ROW | DMF0005_SaleSite_PjtModelMapping.clbEndC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.clb) |
| WK-DMF0005-0741 | X-ROW | DMF0005_SaleSite_PjtModelMapping.shtSubD | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.sht) |
| WK-DMF0005-0742 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 106검사 — ERROR:58 · PASS:21 · NA:19 · NOT_RUN:6 · NOPATH:2 |  | 21 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0743 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0744 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 70검사 — ERROR:41 · NA:15 · PASS:9 · NOT_RUN:4 · NOPATH:1 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0745 | X-ROW | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0746 | X-ROW | DMF0005_SaleSite_PjtModelMapping.txtProj | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:4 · NA:3 |  | 27 (ACT:DMF0005_SaleSite_PjtModelMapping.txt) |
| WK-DMF0005-0747 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 3 (ACT:DMF0005_T_SaleSite_PjtModelMapping..) |
| WK-DMF0005-0748 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Activ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NA:1 · NOPATH:1 · PASS:1 · ERROR:1 |  | 5 (ACT:DMF0005_T_SaleSite_PjtModelMapping.A) |
| WK-DMF0005-0749 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Creat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 9 (ACT:DMF0005_T_SaleSite_PjtModelMapping.C) |
| WK-DMF0005-0750 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Dispo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:DMF0005_T_SaleSite_PjtModelMapping.D) |
| WK-DMF0005-0751 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.FindB | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:3 · REVIEW:2 · PASS:2 |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0752 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.FindD | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:5 · PASS:3 · NA:2 · REVIEW:1 · NOPATH:1 |  | 27 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0753 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Form_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 8 (ACT:DMF0005_T_SaleSite_PjtModelMapping.F) |
| WK-DMF0005-0754 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.GetIt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:1 · NA:1 · NOPATH:1 · PASS:1 |  | 7 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0755 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.GetSc | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · ERROR:1 |  | 8 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0756 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.GetSp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:4 · ERROR:2 |  | 11 (ACT:DMF0005_T_SaleSite_PjtModelMapping.G) |
| WK-DMF0005-0757 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.InitC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — PASS:11 · NOT_RUN:5 · ERROR:2 · NOPATH:1 |  | 31 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0758 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.InitE | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:2 · NOPATH:1 · NOT_RUN:1 · ERROR:1 |  | 5 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0759 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.InitS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:3 · ERROR:3 |  | 8 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0760 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.Inser | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 5 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0761 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.SetSp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — NA:16 · ERROR:9 |  | 28 (ACT:DMF0005_T_SaleSite_PjtModelMapping.S) |
| WK-DMF0005-0762 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.shtSu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 6 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0763 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — PASS:8 · NA:4 · ERROR:1 |  | 21 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0764 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 75검사 — ERROR:48 · PASS:11 · NA:9 · NOT_RUN:5 · NOPATH:2 |  | 101 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0765 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0766 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdMa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0767 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — PASS:8 · NA:4 · ERROR:1 |  | 21 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0768 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 54검사 — ERROR:39 · NA:9 · PASS:5 · NOT_RUN:1 |  | 58 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0769 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.spdSu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0770 | X-ROW | DMF0005_T_SaleSite_PjtModelMapping.txtPr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:5 · NA:3 |  | 27 (ACT:DMF0005_T_SaleSite_PjtModelMapping.t) |
| WK-DMF0005-0771 | G5 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | G5 도구 오류 — 원장 V-44c10b42 ASIS / 원장 V-84cb0129 ASIS / 원장 V-9764feab ASIS / 원장 V-34119286 ASIS / 원장 V-4e87eea1 ASIS / 원장 V-58b8b086  |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0772 | G5 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | G5 도구 오류 — 원장 V-ef249ac7 ASIS / 원장 V-4bc8644d ASIS / 원장 V-ae787200 ASIS / 원장 V-35a5ce2e ASIS / 원장 V-456083d6 ASIS / 원장 V-975b58b4  |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0773 | G5 | DMF0005_T_SaleSite_PjtModelMapping | 하네스·환경 | G5 도구 오류 — 원장 V-31c9b25d ASIS / 원장 V-5a109816 ASIS / 원장 V-1ff8495d ASIS / 원장 V-a811ce85 ASIS / 원장 V-600d1314 ASIS / 원장 V-6d600275  |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0774 | G5 | new DM0002_ItembySmallDivPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-34119286 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0775 | G5 | new DM0002_ItembySmallDivPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-ae6a5c8a |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0776 | G5 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-35a5ce2e |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0777 | G5 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-e3f3ae4b |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0778 | G5 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-44c10b42 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0779 | G5 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-ef249ac7 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0780 | G5 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-2363aa5f |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0781 | G5 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-2fbb4b34 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0782 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-58b8b086 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0783 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-975b58b4 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0784 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-4ada19b8 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0785 | G5 | popItem.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-7a9e2483 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0786 | G5 | popProject.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-9764feab |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0787 | G5 | popProject.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-ae787200 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0788 | G5 | popProject.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-10ff15b8 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0789 | G5 | popProject.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-de5eb34d |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0790 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a4c0f0a8 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0791 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a811ce85 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0792 | H6 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | H6 도구 오류 — 원장 V-bac758ed ASIS / 원장 V-564bf3f4 ASIS / 원장 V-97639ffb ASIS / 원장 V-9b1ab849 ASIS / 원장 V-5adaac79 ASIS / 원장 V-003c7206  |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0793 | H6 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | H6 도구 오류 — 원장 V-a90fcd94 ASIS / 원장 V-c58d6d37 ASIS / 원장 V-8ba3df60 ASIS / 원장 V-ad987943 ASIS / 원장 V-54ece838 ASIS / 원장 V-911965ad  |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0794 | H6 | DMF0005_T_SaleSite_PjtModelMapping | 하네스·환경 | H6 도구 오류 — 원장 V-1c28ecae ASIS / 원장 V-4ffabc9a ASIS / 원장 V-06285cee ASIS / 원장 V-ef36350c ASIS / 원장 V-0c9f0180 ASIS / 원장 V-62f15aea  |  | 2 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0795 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-ad987943 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0796 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-63a9aa84 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0797 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-bac758ed |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0798 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-a90fcd94 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0799 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-11480620 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0800 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-10771b26 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0801 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-5e829aaf |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0802 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-99b06bc6 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.txt) |
| WK-DMF0005-0803 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-e4c56ee2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0804 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-bd33f642 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.t) |
| WK-DMF0005-0805 | H6 | popItem.Form_Load(true, sDivision, sScmS | 하네스·환경 | H6 도구 오류 — 원장 V-54ece838 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0806 | H6 | popItem.Form_Load(true, sDivision, sScmS | 하네스·환경 | H6 도구 오류 — 원장 V-0de8ec30 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0807 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-911965ad |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0808 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4c829dd7 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0809 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-564bf3f4 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0810 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-c58d6d37 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0811 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-285c61cc |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0812 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-62d2ddbd |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0813 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-6809bb37 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.txt) |
| WK-DMF0005-0814 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-ecea3f68 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.t) |
| WK-DMF0005-0815 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-57471f19 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0816 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-67e3bec2 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0817 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4822d912 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0818 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-97639ffb |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0819 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-8ba3df60 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0820 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-baf25d90 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.txt) |
| WK-DMF0005-0821 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5c6e3174 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0822 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-a59d7f8d |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0823 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-16cb015d |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0824 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-762bfa42 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.t) |
| WK-DMF0005-0825 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-cc1b192c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0826 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-ef36350c |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0827 | M3 | DMF0005_T_SaleSite_PjtModelMapping | 하네스·환경 | M3 도구 오류 — 원장 V-3d43f811 ASIS / 원장 V-3605ac45 ASIS / 원장 V-24a15d58 ASIS / 원장 V-781990f5 ASIS / 원장 V-e5fd8f87 ASIS / 원장 V-8fb9bf1e  |  | 50 (ACT:DMF0005_T_SaleSite_PjtModelMapping..) |
| WK-DMF0005-0828 | M3 | btnProject | 하네스·환경 | M3 도구 오류 — 원장 V-4d53f45c ASIS / 원장 V-24a15d58 ASIS / 실측[T-e022dcdd]: 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7) |  | 7 (ACT:DMF0005_T_SaleSite_PjtModelMapping.I) |
| WK-DMF0005-0829 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-d6b320c9 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0830 | M3 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8dd206e9 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0831 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-a9c3e2d7 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0832 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-9c686707 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0833 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-781990f5 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0834 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8f0424db |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.s) |
| WK-DMF0005-0835 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-4d53f45c |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.btn) |
| WK-DMF0005-0836 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-f87e4d45 |  | 1 (ACT:DMF0005_SaleSite_PjtModelMapping.txt) |
| WK-DMF0005-0837 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-24a15d58 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.b) |
| WK-DMF0005-0838 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-b8e96f47 |  | 1 (ACT:DMF0005_T_SaleSite_PjtModelMapping.t) |
| WK-DMF0005-0839 | M4 | CURRENCY / Currency | 하네스·환경 | M4 도구 오류 — 실측[T-84adc1ba]: [검사기 미검증] CURRENCY: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0840 | M4 | DEPT_ID / Team | 하네스·환경 | M4 도구 오류 — 실측[T-360b4c8e]: [검사기 미검증] DEPT_ID: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0841 | M4 | DEPT_ID2 / Team | 하네스·환경 | M4 도구 오류 — 실측[T-7a50419a]: [검사기 미검증] DEPT_ID2: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0842 | M4 | DEPT_ID_82 / Team(Sales | 하네스·환경 | M4 도구 오류 — 실측[T-cddbb29a]: [검사기 미검증] DEPT_ID_82: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0843 | M4 | DMF0005_SaleSite_PjtModelMapping.spdMain | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdMain_CellDoubleClick 의 M4 26요소: ERROR:20 · NOT_RUN:3 · NA:3 |  | 7 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0844 | M4 | DMF0005_SaleSite_PjtModelMapping.spdSub_ | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0005_SaleSite_PjtModelMapping.spdSub_CellDoubleClick 의 M4 14요소: ERROR:10 · NOT_RUN:2 · NA:2 |  | 2 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0845 | M4 | EDIT_FLAG / Edit Flag | 하네스·환경 | M4 도구 오류 — 실측[T-265edefc]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 92 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0846 | M4 | END_CUSTOMER / End Customer | 하네스·환경 | M4 도구 오류 — 실측[T-60015fbe]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0847 | M4 | END_CUSTOMER40 / End Customer | 하네스·환경 | M4 도구 오류 — 실측[T-de56411b]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0848 | M4 | ITEM_TYPE / Item Type | 하네스·환경 | M4 도구 오류 — 실측[T-b3b485ac]: [검사기 미검증] ITEM_TYPE: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 16 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0849 | M4 | NICK_NAME / Nick Name | 하네스·환경 | M4 도구 오류 — 실측[T-71e6447f]: [검사기 미검증] NICK_NAME: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0850 | M4 | OWNER / Owner Name | 하네스·환경 | M4 도구 오류 — 실측[T-159fb729]: [검사기 미검증] OWNER: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 14 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0851 | M4 | PRJ_OWNR_ID / Owner(PM | 하네스·환경 | M4 도구 오류 — 실측[T-ec229551]: [검사기 미검증] PRJ_OWNR_ID: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0852 | M4 | PROJECT_CODE / Project Code | 하네스·환경 | M4 도구 오류 — 실측[T-8154834e]: [검사기 미검증] PROJECT_CODE: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 154 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0853 | M4 | PROJECT_NAME / Project | 하네스·환경 | M4 도구 오류 — 실측[T-367b7f2d]: [검사기 미검증] PROJECT_NAME: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0854 | M4 | PROJECT_OWNER / Project Owner | 하네스·환경 | M4 도구 오류 — 실측[T-75bf5b05]: [검사기 미검증] PROJECT_OWNER: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0855 | M4 | PROJECT_STATUS / Project Status | 하네스·환경 | M4 도구 오류 — 실측[T-c9788c8a]: [검사기 미검증] PROJECT_STATUS: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 8 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0856 | M4 | SCM_SITE_ID / Sales Site | 하네스·환경 | M4 도구 오류 — 실측[T-1e866ad4]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 12 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0857 | M4 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | M4 도구 오류 — 실측[T-99cdfbe9]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0858 | M4 | TEAM_ID | 하네스·환경 | M4 도구 오류 — 실측[T-e61d0adb]: [검사기 미검증] USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0859 | M4 | USER_ID / Owner | 하네스·환경 | M4 도구 오류 — 실측[T-71e28137]: [검사기 미검증] USER_ID: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 43 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
| WK-DMF0005-0860 | M4 | USER_ID_82 / Owner(Sales | 하네스·환경 | M4 도구 오류 — 실측[T-a577574b]: [검사기 미검증] USER_ID_82: USER_ID 셀 위치 확인 불가(보이는 그리드·탭 순회에서도 그 칸 없음) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:DMF0005_SaleSite_PjtModelMapping.spd) |
