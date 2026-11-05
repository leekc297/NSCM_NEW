# 작업 원장 — SCP0007 · 2026-10-29 14:48

> 검사 인스턴스 1127건 중 PASS·NA 1042건 외 **85건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 32 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 36 | 재판정 PASS |
| W7 | 기대값 확정 | 14 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 3 | 원인 해소 → 재판정 |

- 담당: FE 34 · 화면 FE 28 · 사람 판정 / AS-IS 원문 확인 → 재판정 14 · DB 객체 4 · 하네스·환경 3 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-NOTIMPL | GEN | 32 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| C6 | CASCADE |  |  | 17 |  |  |  |  |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| X-ROW | GEN |  |  | 11 |  |  |  |  |  | 3 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 14 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | GEN |  |  | 4 |  |  |  |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E2 | EDIT |  |  | 2 |  |  |  |  |  |  | 날짜 형식·유효성 |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |

## W1 기능 구현 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0001 | X-NOTIMPL | D00-2-006 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-2-006 §2 spdMain / EditChange — AS-IS `SpdMain_EditChange`(cs:1328-1353)의 2가지 동작 중 INCOTERMS_SSP 동기화(`BodGrid.t |  | 1 (D00-2-006) |
| WK-SCP0007-0002 | X-NOTIMPL | D00-2-007 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-2-007 §2 spdMain / KeyPress — AS-IS `SpdMain_KeyPress`(cs:1322-1327)가 `ActiveColumnIndex==ROUTE_ID`일 때 `e.Handl |  | 1 (D00-2-007) |
| WK-SCP0007-0003 | X-NOTIMPL | D00-3-009 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-009 §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision) — **신규 발견**: 신규행에서 DIVISION_ID를 "내 division 목록" 콤보로 제한하 |  | 1 (D00-3-009) |
| WK-SCP0007-0004 | X-NOTIMPL | D00-3-034 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — D00-3-034 §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncotermsEdit) `SCM_MST_SHEET_COLUMNS.INCOTERMS_SSP.ATTRIBUTE9= |  | 1 (D00-3-034) |
| WK-SCP0007-0005 | X-NOTIMPL | D00-3-036 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-036 §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterms) — D00-3-034와 동일 근거(EditButton 진입 시 원래 콤보로 복귀) — TO-B |  | 1 (D00-3-036) |
| WK-SCP0007-0006 | X-NOTIMPL | D00-3-043 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-043 §3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidColor) — **신규 발견**: 저장 실패(SP 응답 errCode 99010/99020/99030/ |  | 1 (D00-3-043) |
| WK-SCP0007-0007 | X-NOTIMPL | D00-3-044 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-044 §3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,InvalidColor) — D00-3-043과 동일 결함(errCode 99030/99040 분기) --  |  | 1 (D00-3-044) |
| WK-SCP0007-0008 | X-NOTIMPL | D00-3-045 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-045 §3 SetBGColor / (TRANSPORT_MODE,InvalidColor) — D00-3-043과 동일 결함(errCode 99010 분기) -- 고위험, D00-3-043과 동일  |  | 1 (D00-3-045) |
| WK-SCP0007-0009 | X-NOTIMPL | D00-3-046 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-046 §3 SetBGColor / (PRIORITY,InvalidColor) — D00-3-043과 동일 결함(errCode 99020 분기) -- 고위험, D00-3-043과 동일 사유 미구현 |  | 1 (D00-3-046) |
| WK-SCP0007-0010 | X-NOTIMPL | D00-3-065 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-065 §3 SetActiveCell / (e.Row,e.Column) — Route 팝업 선택 후 커서를 해당 셀로 이동시키는 UX 동작 — `Bod.tsx handleRouteSelect`에  |  | 1 (D00-3-065) |
| WK-SCP0007-0011 | X-NOTIMPL | D00-3-066 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-066 §3 ShowCell / (0,0,e.Row,e.Column,Center,Right) — 위와 동일(선택 셀을 화면 중앙으로 스크롤) -- 저위험, D00-3-065와 동일 사유 미구현 |  | 1 (D00-3-066) |
| WK-SCP0007-0012 | X-NOTIMPL | D00-3-067 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-067 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — FROM_SITE_CODE 변경 시(`sFromSite=='E'`) TO_SITE  |  | 1 (D00-3-067) |
| WK-SCP0007-0013 | X-NOTIMPL | D00-3-068 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-068 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — `sFromSite=='A' && OSP_YN=='Y'` 분기(`ToSiteByDi |  | 1 (D00-3-068) |
| WK-SCP0007-0014 | X-NOTIMPL | D00-3-069 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-069 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — 그 외 분기(`ToSiteByDivision1_SCP_ALL`) — 위와 동일 결함 |  | 1 (D00-3-069) |
| WK-SCP0007-0015 | X-NOTIMPL | D00-3-074 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-074 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — `SpdMain_ClipboardPasted`(붙여넣기)의 동일 3분기 — D00-3 |  | 1 (D00-3-074) |
| WK-SCP0007-0016 | X-NOTIMPL | D00-3-075 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-075 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — 위와 동일(G16) -- 중위험, G16 미구현 |  | 1 (D00-3-075) |
| WK-SCP0007-0017 | X-NOTIMPL | D00-3-076 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-3-076 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — 위와 동일(G16) -- 중위험, G16 미구현 |  | 1 (D00-3-076) |
| WK-SCP0007-0018 | X-NOTIMPL | D00-4b-009 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4b-009 §4b SpdMain_EditChange / event / spdMain.EditChange — INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현, ROUT |  | 1 (D00-4b-009) |
| WK-SCP0007-0019 | X-NOTIMPL | D00-4b-010 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4b-010 §4b SpdMain_KeyPress / event / spdMain.KeyPress — D00-2-007과 동일(신규 발견, ROUTE_ID 직접 편집 차단 없음) -- 중위험 미구현 |  | 1 (D00-4b-010) |
| WK-SCP0007-0020 | X-NOTIMPL | D00-4c-011 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4c-011 §4c (없음) / GMessageBox / errCode in {99010..99040} — D00-3-043~046과 동일 결함 — errCode별 구체 메시지(중복기간/중첩기간 등) |  | 1 (D00-4c-011) |
| WK-SCP0007-0021 | X-NOTIMPL | D00-4d-005 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — D00-4d-005 §4d Data_SCP.CommonAll / FromSiteByDivision1 — **신규 중요 발견**: 그리드 FROM_SITE_CODE 셀 콤보 전용 원천(`dtFromSiteOf |  | 1 (D00-4d-005) |
| WK-SCP0007-0022 | X-NOTIMPL | D00-4d-006 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4d-006 §4d Data_SCP.CommonAll / ToSiteBOD1 — 그리드 TO_SITE_CODE 셀 콤보 원천(`dtToSiteOfSpd`) 중 하나(`sFromSite=='E'` 분기 |  | 1 (D00-4d-006) |
| WK-SCP0007-0023 | X-NOTIMPL | D00-4d-007 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4d-007 §4d Data_SCP.CommonAll / ToSiteByDivisionPlant1 — 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(`sFromSite=='A'&&OSP` 분기 |  | 1 (D00-4d-007) |
| WK-SCP0007-0024 | X-NOTIMPL | D00-4d-008 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4d-008 §4d Data_SCP.CommonAll / ToSiteByDivision1 — 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(그 외 분기) — G16과 동일 -- 중위험, G16 |  | 1 (D00-4d-008) |
| WK-SCP0007-0025 | X-NOTIMPL | D00-4e-005 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-005 §4e dtFromSiteOfSpdAll / FindData_Main — D00-4d-005와 동일(그리드 FROM_SITE 콤보 division 필터) — 콤보 자체가 미배선이라 필터도 |  | 1 (D00-4e-005) |
| WK-SCP0007-0026 | X-NOTIMPL | D00-4e-006 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-006 §4e dtToSiteOfSpdAll / FindData_Main — D00-4d-006과 동일(G16) -- G16과 결합 미구현 |  | 1 (D00-4e-006) |
| WK-SCP0007-0027 | X-NOTIMPL | D00-4e-007 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-007 §4e dtToSiteOfSpdAll / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-007) |
| WK-SCP0007-0028 | X-NOTIMPL | D00-4e-008 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-008 §4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-008) |
| WK-SCP0007-0029 | X-NOTIMPL | D00-4e-009 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-009 §4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-009) |
| WK-SCP0007-0030 | X-NOTIMPL | D00-4e-010 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-010 §4e dtToSiteOfSpdAll / SpdMain_ClipboardPasted — G16과 동일(붙여넣기 경로) -- G16과 결합 미구현 |  | 1 (D00-4e-010) |
| WK-SCP0007-0031 | X-NOTIMPL | D00-4e-011 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-011 §4e dtToSiteOfSpdAll1 / SpdMain_ClipboardPasted — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-011) |
| WK-SCP0007-0032 | X-NOTIMPL | D00-4e-012 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | 대조표 미구현 행 구현 — D00-4e-012 §4e dtToSiteOfSpdAll2 / SpdMain_ClipboardPasted — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-012) |

## W3 동작 수정 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0033 | J2 | SCP0007 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | J2 FAIL 수정 — SCP0007 화면: 원장 V-fa13aa48 RULE_SCREEN / 원장 V-dcfc0ab3 GENERAL / 원장 V-db4554fa GENERAL / 원장 V-5d584349 GENERAL / 원장 V- |  | 77 (D00-2-002 D00-2-004 D00-2-008 D00-2-005 ) |
| WK-SCP0007-0034 | C6 | D00-2-004 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-2-004: 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6 · FAIL 요소: TO_SITE_C |  | 1 (D00-2-004) |
| WK-SCP0007-0035 | C6 | D00-2-005 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6 · FAIL 요소: TO_SITE_CO |  | 1 (D00-2-005) |
| WK-SCP0007-0036 | C6 | D00-4b-003 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-4b-003: 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6 · |  | 1 (D00-4b-003) |
| WK-SCP0007-0037 | C6 | D00-4b-008 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-4b-008: 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C6 22요소: FAIL:8 · NA:8 · PAS |  | 1 (D00-4b-008) |
| WK-SCP0007-0038 | C6 | D00-4e-007 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-4e-007: 행 집계 — 대조표 D00-4e-007 '§4e dtToSiteOfSpdAll / SpdMain_ComboSelChange' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6 · |  | 1 (D00-4e-007) |
| WK-SCP0007-0039 | C6 | D00-4e-008 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-4e-008: 행 집계 — 대조표 D00-4e-008 '§4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6  |  | 1 (D00-4e-008) |
| WK-SCP0007-0040 | C6 | D00-4e-009 | 화면 FE(적용 예정) | C6 FAIL 수정 — D00-4e-009: 행 집계 — 대조표 D00-4e-009 '§4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange' 의 C6 22요소: FAIL:8 · NA:8 · PASS:6  |  | 1 (D00-4e-009) |
| WK-SCP0007-0041 | C6 | FROM_SITE_CODE / From Site | 화면 FE(적용 예정) | C6 FAIL 수정 — FROM_SITE_CODE / From Site: 원장 V-c667b133 ASIS / 원장 V-21c28614 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V- |  | 38 (D00-4f-012 ACT:SCP0007_BOD.SpdMain_Chang) |
| WK-SCP0007-0042 | C6 | INCOTERMS / Incoterms | 화면 FE(적용 예정) | C6 FAIL 수정 — INCOTERMS / Incoterms: 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (FX-SCP0007-004) |  | 1 (D00-3-081) |
| WK-SCP0007-0043 | C6 | INCOTERMS_SSP / Incoterms SSP | 화면 FE(적용 예정) | C6 FAIL 수정 — INCOTERMS_SSP / Incoterms SSP: 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (FX-SCP0007-004) |  | 1 (D00-3-081) |
| WK-SCP0007-0044 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(적용 예정) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-c667b133 (FX-SCP0007-004) |  | 1 (ACT:SCP0007_BOD.SetCityCode:1411:28) |
| WK-SCP0007-0045 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(적용 예정) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-3778a5ce (FX-SCP0007-005) |  | 1 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0046 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(적용 예정) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-f1677353 (FX-SCP0007-006) |  | 1 (ACT:SCP0007_BOD.SpdMain_EditChange:1348:) |
| WK-SCP0007-0047 | C6 | SCP0007_BOD.SpdMain_Changed | 화면 FE(적용 예정) | C6 FAIL 수정 — SCP0007_BOD.SpdMain_Changed: 진입점 집계 — 대조표 SCP0007_BOD.SpdMain_Changed 의 C6 1요소: FAIL:1 · FAIL 요소: FROM_SITE_CODE / Fr |  | 15 (ACT:SCP0007_BOD.SpdMain_Changed:1279:1 A) |
| WK-SCP0007-0048 | C6 | SCP0007_BOD.cboDivision_SelectedIndexCha | 화면 FE(적용 예정) | C6 FAIL 수정 — SCP0007_BOD.cboDivision_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C6 22요소: FA |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
| WK-SCP0007-0049 | C6 | TO_SITE_CODE / To Site | 화면 FE(적용 예정) | C6 FAIL 수정 — TO_SITE_CODE / To Site: 원장 V-c667b133 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V-d433bae7 ASIS / 원장 V-f167 |  | 18 (D00-2-002 D00-4f-012 ACT:SCP0007_BOD.Spd) |
| WK-SCP0007-0050 | C6 | VMI_YN / To Site VMI | 화면 FE(적용 예정) | C6 FAIL 수정 — VMI_YN / To Site VMI: 원장 V-3778a5ce ASIS (FX-SCP0007-005) |  | 3 (ACT:SCP0007_BOD.SpdMain_ComboSelChange A) |
| WK-SCP0007-0051 | F1 | SCP0007 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | F1 FAIL 수정 — SCP0007 화면: 원장 V-45c17570 RULE_SCREEN / 원장 V-18244356 DEFECT / 원장 V-0ec717c6 GENERAL / 원장 V-616fa081 GENERAL / 원장 V-f |  | 190 (D00-2-007 D00-3-007 D00-3-043 D00-4a-003) |
| WK-SCP0007-0052 | E2 | FROM_YYYYMMDD / FROM | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E2 FAIL 수정 — FROM_YYYYMMDD / FROM: 원장 V-9a934f52 COLUMN |  | 2 (D00-3-014 D00-3-041) |
| WK-SCP0007-0053 | E2 | TO_YYYYMMDD / TO | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | E2 FAIL 수정 — TO_YYYYMMDD / TO: 원장 V-cac6a100 COLUMN |  | 3 (D00-3-015 D00-3-042 D00-3-044) |
| WK-SCP0007-0054 | A6 | D00-3-040 | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — D00-3-040: 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0007.P_SCP |  | 1 (D00-3-040) |
| WK-SCP0007-0055 | A6 | D00-4e-005 | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — D00-4e-005: 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소 |  | 1 (D00-4e-005) |
| WK-SCP0007-0056 | A6 | D00-4e-006 | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — D00-4e-006: 행 집계 — 대조표 D00-4e-006 '§4e dtToSiteOfSpdAll / FindData_Main' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소:  |  | 1 (D00-4e-006) |
| WK-SCP0007-0057 | A6 | PKG_SCP0007.P_SCP0007_GET_BOD | DB 객체(PKG/SP)(적용 예정) | A6 FAIL 수정 — PKG_SCP0007.P_SCP0007_GET_BOD: 원장 V-1db4f99c SP / 원장 V-2fdb9660 SP / 정렬대조 PASS 분기 키 순서 동일 (가드 IF( ISNULL(@p_input_sta |  | 58 (D00-4a-001 ACT:SCP0007_BOD.FindButton AC) |
| WK-SCP0007-0058 | X-ROW | SCP0007_BOD.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.FindButton: 진입점 집계 6검사 — REVIEW:2 · PASS:2 · FAIL:1 · NA:1 (FX-SCP0007-049) |  | 1 (ACT:SCP0007_BOD.FindButton) |
| WK-SCP0007-0059 | X-ROW | SCP0007_BOD.FindData_Main | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.FindData_Main: 진입점 집계 17검사 — PASS:12 · NA:3 · REVIEW:1 · FAIL:1 (FX-SCP0007-050) |  | 8 (ACT:SCP0007_BOD.FindData_Main:510:1 ACT:) |
| WK-SCP0007-0060 | X-ROW | SCP0007_BOD.SaveData_Main | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SaveData_Main: 진입점 집계 39검사 — PASS:35 · NA:3 · FAIL:1 (FX-SCP0007-051) |  | 5 (ACT:SCP0007_BOD.SaveData_Main:677:26 ACT) |
| WK-SCP0007-0061 | X-ROW | SCP0007_BOD.SetCityCode | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SetCityCode: 진입점 집계 43검사 — PASS:26 · NA:16 · FAIL:1 (FX-SCP0007-052) |  | 1 (ACT:SCP0007_BOD.SetCityCode:1411:28) |
| WK-SCP0007-0062 | X-ROW | SCP0007_BOD.SpdMain_Changed | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_Changed: 진입점 집계 7검사 — PASS:5 · FAIL:2 (FX-SCP0007-054) |  | 1 (ACT:SCP0007_BOD.SpdMain_Changed:1310:18) |
| WK-SCP0007-0063 | X-ROW | SCP0007_BOD.SpdMain_ClipboardPasted | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_ClipboardPasted: 진입점 집계 39검사 — PASS:26 · NA:12 · FAIL:1 (FX-SCP0007-055) |  | 3 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0064 | X-ROW | SCP0007_BOD.SpdMain_ComboSelChange | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_ComboSelChange: 진입점 집계 47검사 — PASS:36 · NA:8 · FAIL:3 (FX-SCP0007-056) |  | 2 (ACT:SCP0007_BOD.SpdMain_ComboSelChange:1) |
| WK-SCP0007-0065 | X-ROW | SCP0007_BOD.SpdMain_EditChange | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_EditChange: 진입점 집계 5검사 — PASS:4 · FAIL:1 (FX-SCP0007-057) |  | 11 (ACT:SCP0007_BOD.SpdMain_EditChange ACT:S) |
| WK-SCP0007-0066 | X-ROW | SCP0007_DistributionRoutePopup.btnButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_DistributionRoutePopup.btnButtonList_UsrButtonList_C: 진입점 집계 3검사 — PASS:2 · FAIL:1 (FX-SCP0007-060) |  | 10 (ACT:SCP0007_DistributionRoutePopup.btnBu) |
| WK-SCP0007-0067 | X-ROW | SCP0007_DistributionRoutePopup.btnFromSr | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_DistributionRoutePopup.btnFromSrch_Click: 진입점 집계 20검사 — PASS:13 · NA:6 · FAIL:1 (FX-SCP0007-061) |  | 9 (ACT:SCP0007_DistributionRoutePopup.btnFr) |
| WK-SCP0007-0068 | X-ROW | SCP0007_DistributionRoutePopup.btnToSrch | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0007_DistributionRoutePopup.btnToSrch_Click: 진입점 집계 20검사 — PASS:13 · NA:6 · FAIL:1 (FX-SCP0007-062) |  | 9 (ACT:SCP0007_DistributionRoutePopup.btnTo) |

## W7 기대값 확정 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0069 | A1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 A1 5요 |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SCP0007-0070 | A1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-008: 행 집계 — 대조표 D00-2-008 '§2 this / Load → Form_Load (InitForm·InitControls·' 의 A1 5요소: REVIEW:2 · PASS:2 · NA: |  | 1 (D00-2-008) |
| WK-SCP0007-0071 | A1 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-009: 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 |  | 1 (D00-3-009) |
| WK-SCP0007-0072 | A1 | D00-3-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-036: 행 집계 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterm' 의 A1 5요소: REVIEW:2 · PASS:2 · NA: |  | 1 (D00-3-036) |
| WK-SCP0007-0073 | A1 | D00-3-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-040: 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SC |  | 1 (D00-3-040) |
| WK-SCP0007-0074 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAI |  | 1 (D00-4b-001) |
| WK-SCP0007-0075 | A1 | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-003: 행 집계 — 대조표 D00-4d-003 '§4d Data_SCP.CommonAll / FromSiteByDivision1Ex' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1  |  | 1 (D00-4d-003) |
| WK-SCP0007-0076 | A1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-004: 행 집계 — 대조표 D00-4d-004 '§4d Data_SCP.CommonAll / ToSiteBOD1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소:  |  | 1 (D00-4d-004) |
| WK-SCP0007-0077 | A1 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-005: 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 ·  |  | 1 (D00-4d-005) |
| WK-SCP0007-0078 | A1 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-009: 행 집계 — 대조표 D00-4d-009 '§4d Data.Common / LookupCommon(INCOTERMS)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAI |  | 1 (D00-4d-009) |
| WK-SCP0007-0079 | A1 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-005: 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요 |  | 1 (D00-4e-005) |
| WK-SCP0007-0080 | A1 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-006: 행 집계 — 대조표 D00-4e-006 '§4e dtToSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: |  | 1 (D00-4e-006) |
| WK-SCP0007-0081 | A1 | PKG_SCP0007.P_SCP0007_GET_BOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0007.P_SCP0007_GET_BOD: golden DIFF AS-IS 6487행 ↔ TO-BE 8121행: Doc/golden/SCP0007/SCP0007_GET_BOD.md — 같은 조건 건수 |  | 58 (D00-4a-001 ACT:SCP0007_BOD.FindButton AC) |
| WK-SCP0007-0082 | A1 | PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY: golden DIFF AS-IS 1415행 ↔ TO-BE 1394행: Doc/golden/SCP0007/SCP0007_GET_COUNTRY_ |  | 4 (D00-4a-002 ACT:SCP0007_BOD.FindButton AC) |

## W9 도구 오류 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0083 | X-ROW | SCP0007_BOD.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0007_BOD.CreateSpread) |
| WK-SCP0007-0084 | X-ROW | SCP0007_BOD.SetChangeControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:4 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0007_BOD.SetChangeControl ACT:SCP) |
| WK-SCP0007-0085 | X-ROW | SCP0007_BOD.cboDivision_SelectedIndexCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
