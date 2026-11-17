# 작업 원장 — SCP0007 · 2026-11-14 09:55

> 검사 인스턴스 1118건 중 PASS·NA 904건 외 **214건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 32 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 41 | 재판정 PASS |
| W7 | 기대값 확정 | 1 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 19 | 선행 W1 → PASS |
| W9 | 도구 오류 | 121 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 121 · 화면 FE 38 · FE 30 · 선행 W1 완료 후 E2E 19 · 사람판정 3 · DB 2 · 사람 판정 / AS-IS 원문 확인 → 재판정 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-NOTIMPL | GEN | 32 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 24 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 24 | 라벨 명칭 |
| D3 | EDIT |  |  | 9 |  |  |  |  |  | 13 | 행 값 기반 조건부 잠금 |
| C6 | CASCADE |  |  | 14 |  |  |  |  | 3 | 3 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | EDIT |  |  | 4 |  |  |  |  |  | 15 | 컬럼 편집 가능 여부(신규행·기존행) |
| X-ROW | GEN |  |  | 8 |  |  |  |  |  | 11 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  | 6 | 10 | 연쇄 자동 채움 |
| C2 | CASCADE |  |  |  |  |  |  |  | 3 | 10 | 그리드 셀 cascade 후보 |
| A6 | GEN |  |  | 3 |  |  |  |  | 1 |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  |  |  |  |  |  | 3 |  | 숫자 소수자리·정수·부호·범위 |
| B4 | COMBO |  |  |  |  |  |  |  |  | 3 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E2 | EDIT |  |  | 2 |  |  |  |  |  |  | 날짜 형식·유효성 |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| C4 | CASCADE |  |  |  |  |  |  | 1 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| DB-SYN | DB |  |  |  |  |  |  |  | 1 |  | BE 계정 시노님·권한·대상 객체 |
| F4 | DB |  |  |  |  |  |  |  | 1 |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A1 | GEN |  |  |  |  |  |  |  | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W1 기능 구현 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0001 | X-NOTIMPL | D00-2-006 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-2-006 §2 spdMain / EditChange — AS-IS `SpdMain_EditChange`(cs:1328-1353)의 2가지 동작 중 INCOTERMS_SSP 동기화(`BodGrid.t |  | 1 (D00-2-006) |
| WK-SCP0007-0002 | X-NOTIMPL | D00-2-007 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-2-007 §2 spdMain / KeyPress — AS-IS `SpdMain_KeyPress`(cs:1322-1327)가 `ActiveColumnIndex==ROUTE_ID`일 때 `e.Handl |  | 1 (D00-2-007) |
| WK-SCP0007-0003 | X-NOTIMPL | D00-3-009 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-009 §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision) — **신규 발견**: 신규행에서 DIVISION_ID를 "내 division 목록" 콤보로 제한하 |  | 1 (D00-3-009) |
| WK-SCP0007-0004 | X-NOTIMPL | D00-3-034 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — D00-3-034 §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncotermsEdit) `SCM_MST_SHEET_COLUMNS.INCOTERMS_SSP.ATTRIBUTE9= |  | 1 (D00-3-034) |
| WK-SCP0007-0005 | X-NOTIMPL | D00-3-036 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-036 §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterms) — D00-3-034와 동일 근거(EditButton 진입 시 원래 콤보로 복귀) — TO-B |  | 1 (D00-3-036) |
| WK-SCP0007-0006 | X-NOTIMPL | D00-3-043 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-043 §3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidColor) — **신규 발견**: 저장 실패(SP 응답 errCode 99010/99020/99030/ |  | 1 (D00-3-043) |
| WK-SCP0007-0007 | X-NOTIMPL | D00-3-044 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-044 §3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,InvalidColor) — D00-3-043과 동일 결함(errCode 99030/99040 분기) --  |  | 1 (D00-3-044) |
| WK-SCP0007-0008 | X-NOTIMPL | D00-3-045 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-045 §3 SetBGColor / (TRANSPORT_MODE,InvalidColor) — D00-3-043과 동일 결함(errCode 99010 분기) -- 고위험, D00-3-043과 동일  |  | 1 (D00-3-045) |
| WK-SCP0007-0009 | X-NOTIMPL | D00-3-046 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-046 §3 SetBGColor / (PRIORITY,InvalidColor) — D00-3-043과 동일 결함(errCode 99020 분기) -- 고위험, D00-3-043과 동일 사유 미구현 |  | 1 (D00-3-046) |
| WK-SCP0007-0010 | X-NOTIMPL | D00-3-065 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-065 §3 SetActiveCell / (e.Row,e.Column) — Route 팝업 선택 후 커서를 해당 셀로 이동시키는 UX 동작 — `Bod.tsx handleRouteSelect`에  |  | 1 (D00-3-065) |
| WK-SCP0007-0011 | X-NOTIMPL | D00-3-066 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-066 §3 ShowCell / (0,0,e.Row,e.Column,Center,Right) — 위와 동일(선택 셀을 화면 중앙으로 스크롤) -- 저위험, D00-3-065와 동일 사유 미구현 |  | 1 (D00-3-066) |
| WK-SCP0007-0012 | X-NOTIMPL | D00-3-067 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-067 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — FROM_SITE_CODE 변경 시(`sFromSite=='E'`) TO_SITE  |  | 1 (D00-3-067) |
| WK-SCP0007-0013 | X-NOTIMPL | D00-3-068 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-068 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — `sFromSite=='A' && OSP_YN=='Y'` 분기(`ToSiteByDi |  | 1 (D00-3-068) |
| WK-SCP0007-0014 | X-NOTIMPL | D00-3-069 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-069 §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) — 그 외 분기(`ToSiteByDivision1_SCP_ALL`) — 위와 동일 결함 |  | 1 (D00-3-069) |
| WK-SCP0007-0015 | X-NOTIMPL | D00-3-074 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-074 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — `SpdMain_ClipboardPasted`(붙여넣기)의 동일 3분기 — D00-3 |  | 1 (D00-3-074) |
| WK-SCP0007-0016 | X-NOTIMPL | D00-3-075 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-075 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — 위와 동일(G16) -- 중위험, G16 미구현 |  | 1 (D00-3-075) |
| WK-SCP0007-0017 | X-NOTIMPL | D00-3-076 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-3-076 §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) — 위와 동일(G16) -- 중위험, G16 미구현 |  | 1 (D00-3-076) |
| WK-SCP0007-0018 | X-NOTIMPL | D00-4b-009 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4b-009 §4b SpdMain_EditChange / event / spdMain.EditChange — INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현, ROUT |  | 1 (D00-4b-009) |
| WK-SCP0007-0019 | X-NOTIMPL | D00-4b-010 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4b-010 §4b SpdMain_KeyPress / event / spdMain.KeyPress — D00-2-007과 동일(신규 발견, ROUTE_ID 직접 편집 차단 없음) -- 중위험 미구현 |  | 1 (D00-4b-010) |
| WK-SCP0007-0020 | X-NOTIMPL | D00-4c-011 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4c-011 §4c (없음) / GMessageBox / errCode in {99010..99040} — D00-3-043~046과 동일 결함 — errCode별 구체 메시지(중복기간/중첩기간 등) |  | 1 (D00-4c-011) |
| WK-SCP0007-0021 | X-NOTIMPL | D00-4d-005 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — D00-4d-005 §4d Data_SCP.CommonAll / FromSiteByDivision1 — **신규 중요 발견**: 그리드 FROM_SITE_CODE 셀 콤보 전용 원천(`dtFromSiteOf |  | 1 (D00-4d-005) |
| WK-SCP0007-0022 | X-NOTIMPL | D00-4d-006 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4d-006 §4d Data_SCP.CommonAll / ToSiteBOD1 — 그리드 TO_SITE_CODE 셀 콤보 원천(`dtToSiteOfSpd`) 중 하나(`sFromSite=='E'` 분기 |  | 1 (D00-4d-006) |
| WK-SCP0007-0023 | X-NOTIMPL | D00-4d-007 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4d-007 §4d Data_SCP.CommonAll / ToSiteByDivisionPlant1 — 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(`sFromSite=='A'&&OSP` 분기 |  | 1 (D00-4d-007) |
| WK-SCP0007-0024 | X-NOTIMPL | D00-4d-008 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4d-008 §4d Data_SCP.CommonAll / ToSiteByDivision1 — 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(그 외 분기) — G16과 동일 -- 중위험, G16 |  | 1 (D00-4d-008) |
| WK-SCP0007-0025 | X-NOTIMPL | D00-4e-005 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-005 §4e dtFromSiteOfSpdAll / FindData_Main — D00-4d-005와 동일(그리드 FROM_SITE 콤보 division 필터) — 콤보 자체가 미배선이라 필터도 |  | 1 (D00-4e-005) |
| WK-SCP0007-0026 | X-NOTIMPL | D00-4e-006 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-006 §4e dtToSiteOfSpdAll / FindData_Main — D00-4d-006과 동일(G16) -- G16과 결합 미구현 |  | 1 (D00-4e-006) |
| WK-SCP0007-0027 | X-NOTIMPL | D00-4e-007 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-007 §4e dtToSiteOfSpdAll / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-007) |
| WK-SCP0007-0028 | X-NOTIMPL | D00-4e-008 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-008 §4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-008) |
| WK-SCP0007-0029 | X-NOTIMPL | D00-4e-009 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-009 §4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-009) |
| WK-SCP0007-0030 | X-NOTIMPL | D00-4e-010 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-010 §4e dtToSiteOfSpdAll / SpdMain_ClipboardPasted — G16과 동일(붙여넣기 경로) -- G16과 결합 미구현 |  | 1 (D00-4e-010) |
| WK-SCP0007-0031 | X-NOTIMPL | D00-4e-011 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-011 §4e dtToSiteOfSpdAll1 / SpdMain_ClipboardPasted — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-011) |
| WK-SCP0007-0032 | X-NOTIMPL | D00-4e-012 | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — D00-4e-012 §4e dtToSiteOfSpdAll2 / SpdMain_ClipboardPasted — G16과 동일 -- G16과 결합 미구현 |  | 1 (D00-4e-012) |

## W3 동작 수정 (41)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0033 | C6 | D00-2-004 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — D00-2-004: 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소: |  | 1 (D00-2-004) |
| WK-SCP0007-0034 | C6 | D00-2-005 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · ERROR:3 · FAIL 요소:  |  | 1 (D00-2-005) |
| WK-SCP0007-0035 | C6 | D00-4b-003 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — D00-4b-003: 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C6 22요소: FAIL:8 · PASS:7 · NA:4 · |  | 1 (D00-4b-003) |
| WK-SCP0007-0036 | C6 | D00-4b-008 | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — D00-4b-008: 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C6 22요소: FAIL:8 · PASS:7 · N |  | 1 (D00-4b-008) |
| WK-SCP0007-0037 | C6 | FROM_SITE_CODE / From Site | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — FROM_SITE_CODE / From Site: 원장 V-c667b133 ASIS / 원장 V-21c28614 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V- |  | 38 (D00-4f-012 ACT:SCP0007_BOD.SpdMain_Chang) |
| WK-SCP0007-0038 | C6 | INCOTERMS / Incoterms | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — INCOTERMS / Incoterms: 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (FX-SCP0007-016) |  | 1 (D00-3-081) |
| WK-SCP0007-0039 | C6 | INCOTERMS_SSP / Incoterms SSP | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — INCOTERMS_SSP / Incoterms SSP: 원장 V-c667b133 ASIS / 원장 V-3778a5ce ASIS / 원장 V-f1677353 ASIS (FX-SCP0007-016) |  | 1 (D00-3-081) |
| WK-SCP0007-0040 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-c667b133 (FX-SCP0007-016) |  | 1 (ACT:SCP0007_BOD.SetCityCode:1411:28) |
| WK-SCP0007-0041 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-3778a5ce (FX-SCP0007-017) |  | 1 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0042 | C6 | INCOTERMS_SSP,INCOTERMS | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — INCOTERMS_SSP,INCOTERMS: 원장 V-f1677353 (FX-SCP0007-018) |  | 1 (ACT:SCP0007_BOD.SpdMain_EditChange:1348:) |
| WK-SCP0007-0043 | C6 | SCP0007_BOD.SpdMain_Changed | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0007_BOD.SpdMain_Changed: 진입점 집계 — 대조표 SCP0007_BOD.SpdMain_Changed 의 C6 1요소: FAIL:1 · FAIL 요소: FROM_SITE_CODE / Fr |  | 15 (ACT:SCP0007_BOD.SpdMain_Changed:1279:1 A) |
| WK-SCP0007-0044 | C6 | SCP0007_BOD.cboDivision_SelectedIndexCha | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — SCP0007_BOD.cboDivision_SelectedIndexChanged: 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C6 22요소: FA |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
| WK-SCP0007-0045 | C6 | TO_SITE_CODE / To Site | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — TO_SITE_CODE / To Site: 원장 V-c667b133 ASIS / 원장 V-1c76f13c ASIS / 원장 V-3778a5ce ASIS / 원장 V-d433bae7 ASIS / 원장 V-f167 |  | 18 (D00-2-002 D00-4f-012 ACT:SCP0007_BOD.Spd) |
| WK-SCP0007-0046 | C6 | VMI_YN / To Site VMI | 화면 FE(범위 밖(가이드만)) | C6 FAIL 수정 — VMI_YN / To Site VMI: 원장 V-3778a5ce ASIS / 실측[T-d054bd9b]: VMI_YN: 편집 가능한 콤보 후보 2건 — AS-IS 도 이 컬럼을 콤보로 선언(META FPComb |  | 3 (ACT:SCP0007_BOD.SpdMain_ComboSelChange A) |
| WK-SCP0007-0047 | F2 | SCP0007 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0007 화면: 원장 V-1c2b5816 RULE_SCREEN / 원장 V-db344fe6 RULE_SCREEN / 원장 V-b34c30a9 RULE_SCREEN / 원장 V-f28f2ce5 GENERAL |  | 181 (D00-2-007 D00-3-043 D00-4b-002 D00-4b-00) |
| WK-SCP0007-0048 | D1 | D00-2-004 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — D00-2-004: 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요 |  | 1 (D00-2-004) |
| WK-SCP0007-0049 | D1 | D00-2-005 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요소 |  | 1 (D00-2-005) |
| WK-SCP0007-0050 | D1 | D00-3-040 | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — D00-3-040: 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D1 33요소: ERROR:15 · NA:11 · PASS:6 · FAIL:1 · FAIL 요소: ROUT |  | 1 (D00-3-040) |
| WK-SCP0007-0051 | D1 | ROUTE_ID / Route Id | 화면 FE(범위 밖(가이드만)) | D1 FAIL 수정 — ROUTE_ID / Route Id: 원장 V-dde703c0 COLUMN / 원장 V-86d76779 COLUMN / 실측[T-803c75b2]: 기존행 r0 ROUTE_ID 편집=false (AS-IS 편집 |  | 6 (D00-2-006 D00-2-007 D00-3-023 D00-4b-009) |
| WK-SCP0007-0052 | D3 | D00-2-004 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-2-004: 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요 |  | 1 (D00-2-004) |
| WK-SCP0007-0053 | D3 | D00-2-005 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-2-005: 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소 |  | 1 (D00-2-005) |
| WK-SCP0007-0054 | D3 | D00-3-040 | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — D00-3-040: 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 D3 40요소: NA:21 · ERROR:12 · FAIL:6 · PASS:1 · FAIL 요소: INCO |  | 1 (D00-3-040) |
| WK-SCP0007-0055 | D3 | INCOTERMS / Incoterms | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS / Incoterms: 원장 V-b30dd3c6 ASIS / 원장 V-4dfc32a3 ASIS / 실측[T-cd892e67]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & |  | 9 (D00-3-025 D00-3-081 D00-3-082 D00-3-085 ) |
| WK-SCP0007-0056 | D3 | INCOTERMS,INCOTERMS | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS,INCOTERMS: 원장 V-b30dd3c6 / 실측[T-943eabe5]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES |  | 1 (ACT:SCP0007_BOD.SetCityCode:1415:29) |
| WK-SCP0007-0057 | D3 | INCOTERMS,INCOTERMS | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS,INCOTERMS: 원장 V-4dfc32a3 / 실측[T-f660d450]: r1 FROM_SITE_CODE='HQ06-A' 비어있지 않음 & TO_SITE 'Alte_KR_SEL'=SALES |  | 1 (ACT:SCP0007_BOD.SetCityCode:1423:32) |
| WK-SCP0007-0058 | D3 | INCOTERMS_SSP / Incoterms SSP | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS_SSP / Incoterms SSP: 원장 V-9a793d94 ASIS / 원장 V-eb4a5d7f ASIS / 원장 V-69447e5a ASIS / 원장 V-3b5c0b42 ASIS / 원장 |  | 23 (D00-2-006 D00-3-026 D00-3-033 D00-3-034 ) |
| WK-SCP0007-0059 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS_SSP,INCOTERMS_SSP: 원장 V-3b5c0b42 / 실측[T-aa95f6d2]: r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자 |  | 1 (ACT:SCP0007_BOD.SetCityCode:1418:30) |
| WK-SCP0007-0060 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | 화면 FE(범위 밖(가이드만)) | D3 FAIL 수정 — INCOTERMS_SSP,INCOTERMS_SSP: 원장 V-004d10db / 실측[T-0c3aaaf4]: r0 TO_SITE ''=(빈 값 → 유형 없음: AS-IS strTO_SITE_TYPE 도 빈 문자 |  | 1 (ACT:SCP0007_BOD.SetCityCode:1427:34) |
| WK-SCP0007-0061 | E2 | FROM_YYYYMMDD / FROM | 화면 FE(범위 밖(가이드만)) | E2 FAIL 수정 — FROM_YYYYMMDD / FROM: 원장 V-9a934f52 COLUMN (FX-SCP0007-014) |  | 2 (D00-3-014 D00-3-041) |
| WK-SCP0007-0062 | E2 | TO_YYYYMMDD / TO | 화면 FE(범위 밖(가이드만)) | E2 FAIL 수정 — TO_YYYYMMDD / TO: 원장 V-cac6a100 COLUMN (FX-SCP0007-015) |  | 3 (D00-3-015 D00-3-042 D00-3-044) |
| WK-SCP0007-0063 | A6 | D00-3-040 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-3-040: 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_SCP0007.P_SCP |  | 1 (D00-3-040) |
| WK-SCP0007-0064 | A6 | D00-4e-005 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4e-005: 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A6 5요소: NA:3 · FAIL:1 · PASS:1 · FAIL 요소 |  | 1 (D00-4e-005) |
| WK-SCP0007-0065 | A6 | PKG_SCP0007.P_SCP0007_GET_BOD | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0007.P_SCP0007_GET_BOD: 원장 V-1db4f99c SP / 원장 V-2fdb9660 SP / 정렬대조 PASS 분기 키 순서 동일 (가드 IF( ISNULL(@p_input_sta |  | 58 (D00-4a-001 ACT:SCP0007_BOD.FindButton AC) |
| WK-SCP0007-0066 | X-ROW | SCP0007_BOD.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.FindButton: 진입점 집계 6검사 — PASS:4 · FAIL:1 · NA:1 (FX-SCP0007-085) |  | 1 (ACT:SCP0007_BOD.FindButton) |
| WK-SCP0007-0067 | X-ROW | SCP0007_BOD.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.FindData_Main: 진입점 집계 17검사 — PASS:12 · NA:3 · FAIL:1 · ERROR:1 (FX-SCP0007-086) |  | 8 (ACT:SCP0007_BOD.FindData_Main:510:1 ACT:) |
| WK-SCP0007-0068 | X-ROW | SCP0007_BOD.SaveData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SaveData_Main: 진입점 집계 39검사 — PASS:34 · ERROR:3 · FAIL:1 · NA:1 (FX-SCP0007-087) |  | 5 (ACT:SCP0007_BOD.SaveData_Main:677:26 ACT) |
| WK-SCP0007-0069 | X-ROW | SCP0007_BOD.SetCityCode | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SetCityCode: 진입점 집계 43검사 — PASS:17 · NA:14 · FAIL:7 · ERROR:5 (FX-SCP0007-088) |  | 1 (ACT:SCP0007_BOD.SetCityCode:1411:28) |
| WK-SCP0007-0070 | X-ROW | SCP0007_BOD.SpdMain_Changed | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_Changed: 진입점 집계 7검사 — PASS:5 · FAIL:2 (FX-SCP0007-094) |  | 1 (ACT:SCP0007_BOD.SpdMain_Changed:1310:18) |
| WK-SCP0007-0071 | X-ROW | SCP0007_BOD.SpdMain_ClipboardPasted | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_ClipboardPasted: 진입점 집계 39검사 — PASS:20 · NA:12 · ERROR:6 · FAIL:1 (FX-SCP0007-095) |  | 3 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0072 | X-ROW | SCP0007_BOD.SpdMain_ComboSelChange | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_ComboSelChange: 진입점 집계 47검사 — PASS:31 · NA:7 · ERROR:6 · FAIL:3 (FX-SCP0007-096) |  | 2 (ACT:SCP0007_BOD.SpdMain_ComboSelChange:1) |
| WK-SCP0007-0073 | X-ROW | SCP0007_BOD.SpdMain_EditChange | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0007_BOD.SpdMain_EditChange: 진입점 집계 5검사 — PASS:3 · ERROR:1 · FAIL:1 (FX-SCP0007-097) |  | 11 (ACT:SCP0007_BOD.SpdMain_EditChange ACT:S) |

## W7 기대값 확정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0074 | C4 | clbDivision / Div / Division / Div. | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — clbDivision / Div / Division / Div.: 실측[T-d8e292ff]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] 조회 1 |  | 2 (D00-2-001 D00-4b-012) |

## W8 구현 후 검증 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0075 | C2 | D00-4e-007 | 선행 W1 완료 후 E2E | C2 — 대조표 미구현 행 D00-4e-007 구현 후 검증 · 대상 D00-4e-007 |  | 1 (D00-4e-007) |
| WK-SCP0007-0076 | C2 | D00-4e-008 | 선행 W1 완료 후 E2E | C2 — 대조표 미구현 행 D00-4e-008 구현 후 검증 · 대상 D00-4e-008 |  | 1 (D00-4e-008) |
| WK-SCP0007-0077 | C2 | D00-4e-009 | 선행 W1 완료 후 E2E | C2 — 대조표 미구현 행 D00-4e-009 구현 후 검증 · 대상 D00-4e-009 |  | 1 (D00-4e-009) |
| WK-SCP0007-0078 | C3 | D00-4e-007 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-007 구현 후 검증 · 대상 D00-4e-007 |  | 1 (D00-4e-007) |
| WK-SCP0007-0079 | C3 | D00-4e-008 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-008 구현 후 검증 · 대상 D00-4e-008 |  | 1 (D00-4e-008) |
| WK-SCP0007-0080 | C3 | D00-4e-009 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-009 구현 후 검증 · 대상 D00-4e-009 |  | 1 (D00-4e-009) |
| WK-SCP0007-0081 | C3 | D00-4e-010 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-010 구현 후 검증 · 대상 D00-4e-010 |  | 1 (D00-4e-010) |
| WK-SCP0007-0082 | C3 | D00-4e-011 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-011 구현 후 검증 · 대상 D00-4e-011 |  | 1 (D00-4e-011) |
| WK-SCP0007-0083 | C3 | D00-4e-012 | 선행 W1 완료 후 E2E | C3 — 대조표 미구현 행 D00-4e-012 구현 후 검증 · 대상 D00-4e-012 |  | 1 (D00-4e-012) |
| WK-SCP0007-0084 | C6 | D00-4e-007 | 선행 W1 완료 후 E2E | C6 — 대조표 미구현 행 D00-4e-007 구현 후 검증 · 대상 D00-4e-007 |  | 1 (D00-4e-007) |
| WK-SCP0007-0085 | C6 | D00-4e-008 | 선행 W1 완료 후 E2E | C6 — 대조표 미구현 행 D00-4e-008 구현 후 검증 · 대상 D00-4e-008 |  | 1 (D00-4e-008) |
| WK-SCP0007-0086 | C6 | D00-4e-009 | 선행 W1 완료 후 E2E | C6 — 대조표 미구현 행 D00-4e-009 구현 후 검증 · 대상 D00-4e-009 |  | 1 (D00-4e-009) |
| WK-SCP0007-0087 | DB-SYN | D00-4e-006 | 선행 W1 완료 후 E2E | DB-SYN — 대조표 미구현 행 D00-4e-006 구현 후 검증 · 대상 D00-4e-006 |  | 1 (D00-4e-006) |
| WK-SCP0007-0088 | F4 | D00-4e-006 | 선행 W1 완료 후 E2E | F4 — 대조표 미구현 행 D00-4e-006 구현 후 검증 · 대상 D00-4e-006 |  | 1 (D00-4e-006) |
| WK-SCP0007-0089 | E1 | D00-4e-010 | 선행 W1 완료 후 E2E | E1 — 대조표 미구현 행 D00-4e-010 구현 후 검증 · 대상 D00-4e-010 |  | 1 (D00-4e-010) |
| WK-SCP0007-0090 | E1 | D00-4e-011 | 선행 W1 완료 후 E2E | E1 — 대조표 미구현 행 D00-4e-011 구현 후 검증 · 대상 D00-4e-011 |  | 1 (D00-4e-011) |
| WK-SCP0007-0091 | E1 | D00-4e-012 | 선행 W1 완료 후 E2E | E1 — 대조표 미구현 행 D00-4e-012 구현 후 검증 · 대상 D00-4e-012 |  | 1 (D00-4e-012) |
| WK-SCP0007-0092 | A1 | D00-4e-006 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 D00-4e-006 구현 후 검증 · 대상 D00-4e-006 |  | 1 (D00-4e-006) |
| WK-SCP0007-0093 | A6 | D00-4e-006 | 선행 W1 완료 후 E2E | A6 — 대조표 미구현 행 D00-4e-006 구현 후 검증 · 대상 D00-4e-006 |  | 1 (D00-4e-006) |

## W9 도구 오류 (121)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0007-0094 | J2 | SCP0007 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-be6d3489 RULE_SCREEN / 원장 V-ee45a85f DEFECT / 원장 V-dcfc0ab3 GENERAL / 원장 V-db4554fa GENERAL / 원장 V-5d584349 GENERA |  | 76 (D00-2-002 D00-2-004 D00-2-005 D00-2-006 ) |
| WK-SCP0007-0095 | C2 | D00-2-004 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C2 22요소: PASS:14 · ERROR:5 · NA:3 |  | 1 (D00-2-004) |
| WK-SCP0007-0096 | C2 | D00-2-005 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C2 22요소: PASS:14 · ERROR:5 · NA:3 |  | 1 (D00-2-005) |
| WK-SCP0007-0097 | C2 | D00-4b-003 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C2 22요소: PASS:14 · ERROR:5 · NA:3 |  | 1 (D00-4b-003) |
| WK-SCP0007-0098 | C2 | D00-4b-008 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C2 22요소: PASS:14 · ERROR:5 · NA:3 |  | 1 (D00-4b-008) |
| WK-SCP0007-0099 | C2 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C2 도구 오류 — 실측[T-0b02b494]: LT_ARRIVAL_INLAND 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장  |  | 14 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0100 | C2 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C2 도구 오류 — 실측[T-f0eb3a39]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0101 | C2 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C2 도구 오류 — 실측[T-89fdd118]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0102 | C2 | LT_SUM / Sum | 하네스·환경 | C2 도구 오류 — 실측[T-13ea8289]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0103 | C2 | LT_VOYAGE / Sea/Air Ferry | 하네스·환경 | C2 도구 오류 — 실측[T-c2e315f7]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0104 | C2 | SCP0007_BOD.cboDivision_SelectedIndexCha | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C2 22요소: PASS:14 · ERROR:5 · NA:3 |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
| WK-SCP0007-0105 | C3 | D00-2-004 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-004 '§2 spdMain / ClipboardPasted' 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (D00-2-004) |
| WK-SCP0007-0106 | C3 | D00-2-005 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-005 '§2 spdMain / ComboSelChange' 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (D00-2-005) |
| WK-SCP0007-0107 | C3 | D00-4b-003 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4b-003 '§4b SpdMain_Changed / event(dsdm.Changed) / —' 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (D00-4b-003) |
| WK-SCP0007-0108 | C3 | D00-4b-007 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4b-007 '§4b SpdMain_ClipboardPasted / event / spdMain.Clip' 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (D00-4b-007) |
| WK-SCP0007-0109 | C3 | D00-4b-008 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4b-008 '§4b SpdMain_ComboSelChange / event / spdMain.Combo' 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (D00-4b-008) |
| WK-SCP0007-0110 | C3 | INCOTERMS / Incoterms | 하네스·환경 | C3 도구 오류 — 원장 V-6f31804a ASIS / 원장 V-c21de22c ASIS / 원장 V-b1d46bfe ASIS / 실측[T-a450d1fa]: INCOTERMS 연쇄 원천 컬럼 해석 불가 — AS-IS SetCity |  | 14 (D00-3-081 D00-3-082 ACT:SCP0007_BOD.SetC) |
| WK-SCP0007-0111 | C3 | SCP0007_BOD.SetChangeControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0007_BOD.SetChangeControl 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 5 (ACT:SCP0007_BOD.SetChangeControl:241:2 A) |
| WK-SCP0007-0112 | C3 | SCP0007_BOD.cboDivision_SelectedIndexCha | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0007_BOD.cboDivision_SelectedIndexChanged 의 C3 47요소: PASS:34 · NA:10 · ERROR:3 |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
| WK-SCP0007-0113 | C3 | TRANSPORT_MODE_NAME / Trans Mode | 하네스·환경 | C3 도구 오류 — 실측[T-56dbc6b7]: TRANSPORT_MODE_NAME 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D00-3-052 ACT:SCP0007_BOD.spdMain_CellDo) |
| WK-SCP0007-0114 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-29694300]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D00-3-061 ACT:SCP0007_BOD.spdMain_CellDo) |
| WK-SCP0007-0115 | C6 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C6 도구 오류 — 실측[T-04d357ca]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0116 | C6 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C6 도구 오류 — 실측[T-8e51113d]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0117 | C6 | LT_VOYAGE / Sea/Air Ferry | 하네스·환경 | C6 도구 오류 — 실측[T-7dcd6534]: 원천 LT_ARRIVAL_INLAND 신규행 편집 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
| WK-SCP0007-0118 | B4 | D00-4d-010 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 D00-4d-010 '§4d Data.Common / LookupCommon(TRANSPORT_MODE_CODE' 의 B4 15요소: PASS:13 · ERROR:2 |  | 1 (D00-4d-010) |
| WK-SCP0007-0119 | B4 | TO_SITE_CODE / To Site | 하네스·환경 | B4 도구 오류 — 원장 V-27aad163 COLUMN |  | 15 (D00-3-067 D00-3-068 D00-3-069 D00-3-074 ) |
| WK-SCP0007-0120 | B4 | clbToSite / To Site | 하네스·환경 | B4 도구 오류 — 원장 V-a865d23d SEARCH |  | 1 (D00-1-007) |
| WK-SCP0007-0121 | K4 | SCP0007 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-f5cda3c6 GENERAL / 원장 V-3c2034a5 GENERAL / 원장 V-0b24aeda GENERAL / 원장 V-af816db0 GENERAL / 원장 V-59ae8896 GENERAL / |  | 32 (COMMON:UC-04 ACT:SCP0007_DistributionRou) |
| WK-SCP0007-0122 | F1 | SCP0007 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-9bef7e21 RULE_SCREEN / 원장 V-a7eaacf2 RULE_SCREEN / 원장 V-b4659a1e RULE_SCREEN / 원장 V-592e9315 RULE_SCREEN / 원장 V-2e |  | 190 (D00-2-007 D00-3-007 D00-3-043 D00-4a-003) |
| WK-SCP0007-0123 | F3 | SCP0007 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-e07c8896 RULE_SCREEN / 원장 V-82e46624 RULE_SCREEN / 원장 V-e5dead79 RULE_SCREEN / 원장 V-4857bcd3 RULE_SCREEN / 원장 V-95 |  | 52 (D00-2-002 D00-2-004 D00-3-074 D00-3-077 ) |
| WK-SCP0007-0124 | F5 | SCP0007 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-f6cdcac7 RULE_SCREEN / 원장 V-d3badecc RULE_SCREEN / 원장 V-a01490c5 RULE_SCREEN / 원장 V-5c72efc2 DEFECT / 원장 V-911ed67 |  | 9 (D00-3-007 D00-4b-004 D00-4f-001 CRUD:D00) |
| WK-SCP0007-0125 | F6 | SCP0007 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-7a8752bb RULE_SCREEN / 원장 V-1b1a7484 RULE_SCREEN / 원장 V-c027ab6f RULE_SCREEN / 원장 V-fa7c647c RULE_SCREEN / 원장 V-73 |  | 174 (D00-4a-003 ACT:SCP0007_BOD.SaveButton AC) |
| WK-SCP0007-0126 | A5 | A_COUNTRY / Country | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-1b2f9627]: A_COUNTRY: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0127 | A5 | A_PORT_CODE / Port Code | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-bba4a45b]: A_PORT_CODE: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0128 | A5 | A_PORT_NAME / Port | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-2709b4dd]: A_PORT_NAME: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0129 | A5 | D00-1-009 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-009 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-1-009) |
| WK-SCP0007-0130 | A5 | D00-1-026 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-026 '§1 spdMain / FpSpread' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-1-026) |
| WK-SCP0007-0131 | A5 | D00-1-027 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-027 '§1 spdMain_Sheet1 / SheetView' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-1-027) |
| WK-SCP0007-0132 | A5 | D00-3-038 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-038 '§3 Query / (ds)' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-3-038) |
| WK-SCP0007-0133 | A5 | D00-4b-011 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4b-011 '§4b SpdMain_TopChange / event / spdMain.TopChange' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-4b-011) |
| WK-SCP0007-0134 | A5 | D00-4e-005 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A5 47요소: PASS:29 · ERROR:18 |  | 1 (D00-4e-005) |
| WK-SCP0007-0135 | A5 | DAYS / Departure Days | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-f0a3fc3a]: DAYS: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T2 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0136 | A5 | D_COUNTRY / Country | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-b8622c4f]: D_COUNTRY: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0137 | A5 | D_PORT_CODE / Port Code | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-d2e5af4e]: D_PORT_CODE: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0138 | A5 | D_PORT_NAME / Port | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-384ba7e5]: D_PORT_NAME: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0139 | A5 | FROM_CITY_NAME / City Name | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-9820d58c]: FROM_CITY_NAME: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0140 | A5 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-5bbed7f7]: LT_ARRIVAL_INLAND: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0141 | A5 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-f7c4def7]: LT_DEPARTURE_INLAND: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0142 | A5 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-1193f9a4]: LT_LAY_OFF_CLEARANCE: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못 |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0143 | A5 | LT_SUM / Sum | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-28345a12]: LT_SUM: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정( |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0144 | A5 | LT_VOYAGE / Sea/Air Ferry | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-2d550338]: LT_VOYAGE: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미 |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0145 | A5 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-501ad94e]: LT_WAIT_SHIPPING: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 —  |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0146 | A5 | SHIPPING_COMPANY / Shipping Company | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-41363be5]: SHIPPING_COMPANY: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 —  |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0147 | A5 | SHIP_DOC_PREPARATION_DATE / Shipping Doc | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-8bc99e0f]: SHIP_DOC_PREPARATION_DATE: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0148 | A5 | TO_CITY_NAME / City Name | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-0457cabc]: TO_CITY_NAME: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여 |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0149 | A5 | VALID_YN / Valid | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-ef689490]: VALID_YN: [측정 경로 없음] AS-IS 시트 Distribution Route 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측 |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0150 | H4 | SCP0007 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-8300240e RULE_SCREEN / 원장 V-5ae9da74 RULE_SCREEN / 원장 V-04ff42a2 RULE_SCREEN / 원장 V-9653e5f1 RULE_SCREEN / 원장 V-15 |  | 5 (D00-4b-011 ACT:SCP0007_BOD.SpdMain_TopCh) |
| WK-SCP0007-0151 | H5 | A_COUNTRY / Country | 하네스·환경 | H5 도구 오류 — 실측[T-2d356064]: A_COUNTRY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0152 | H5 | A_PORT_CODE / Port Code | 하네스·환경 | H5 도구 오류 — 실측[T-990bc1ba]: A_PORT_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0153 | H5 | A_PORT_NAME / Port | 하네스·환경 | H5 도구 오류 — 실측[T-1e0bcedb]: A_PORT_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0154 | H5 | D00-1-026 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-026 '§1 spdMain / FpSpread' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 1 (D00-1-026) |
| WK-SCP0007-0155 | H5 | D00-1-027 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-027 '§1 spdMain_Sheet1 / SheetView' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 1 (D00-1-027) |
| WK-SCP0007-0156 | H5 | D00-3-038 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-038 '§3 Query / (ds)' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 1 (D00-3-038) |
| WK-SCP0007-0157 | H5 | D00-4b-011 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4b-011 '§4b SpdMain_TopChange / event / spdMain.TopChange' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 1 (D00-4b-011) |
| WK-SCP0007-0158 | H5 | D00-4e-005 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 1 (D00-4e-005) |
| WK-SCP0007-0159 | H5 | DAYS / Departure Days | 하네스·환경 | H5 도구 오류 — 실측[T-50028f5a]: DAYS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0160 | H5 | D_COUNTRY / Country | 하네스·환경 | H5 도구 오류 — 실측[T-41e12afa]: D_COUNTRY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0161 | H5 | D_PORT_CODE / Port Code | 하네스·환경 | H5 도구 오류 — 실측[T-f6c82837]: D_PORT_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0162 | H5 | D_PORT_NAME / Port | 하네스·환경 | H5 도구 오류 — 실측[T-f8e3e358]: D_PORT_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0163 | H5 | FROM_CITY_NAME / City Name | 하네스·환경 | H5 도구 오류 — 실측[T-003722b9]: FROM_CITY_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0164 | H5 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | H5 도구 오류 — 실측[T-bb87fc99]: LT_ARRIVAL_INLAND 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0165 | H5 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | H5 도구 오류 — 실측[T-a907b055]: LT_DEPARTURE_INLAND 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0166 | H5 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | H5 도구 오류 — 실측[T-773c43f8]: LT_LAY_OFF_CLEARANCE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0167 | H5 | LT_SUM / Sum | 하네스·환경 | H5 도구 오류 — 실측[T-4f21b16a]: LT_SUM 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0168 | H5 | LT_VOYAGE / Sea/Air Ferry | 하네스·환경 | H5 도구 오류 — 실측[T-9b7daee2]: LT_VOYAGE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0169 | H5 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | H5 도구 오류 — 실측[T-0d88fcfc]: LT_WAIT_SHIPPING 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0170 | H5 | SCP0007_BOD.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0007_BOD.CreateSpread 의 H5 47요소: PASS:25 · ERROR:18 · NA:4 |  | 4 (ACT:SCP0007_BOD.CreateSpread:262:1 ACT:S) |
| WK-SCP0007-0171 | H5 | SHIPPING_COMPANY / Shipping Company | 하네스·환경 | H5 도구 오류 — 실측[T-fa37c95b]: SHIPPING_COMPANY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0172 | H5 | SHIP_DOC_PREPARATION_DATE / Shipping Doc | 하네스·환경 | H5 도구 오류 — 실측[T-4d56b06c]: SHIP_DOC_PREPARATION_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0173 | H5 | TO_CITY_NAME / City Name | 하네스·환경 | H5 도구 오류 — 실측[T-9459f809]: TO_CITY_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0174 | H5 | VALID_YN / Valid | 하네스·환경 | H5 도구 오류 — 실측[T-3f9bdd6a]: VALID_YN 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0175 | I1 | SCP0007 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-56426162 RULE_SCREEN / 원장 V-07363844 RULE_SCREEN / 원장 V-0999953e RULE_SCREEN / 원장 V-7d16e81a DEFECT / 원장 V-a2c5cdd |  | 28 (D00-3-043 D00-4c-001 D00-4c-003 D00-4c-0) |
| WK-SCP0007-0176 | D1 | BOD_ID | 하네스·환경 | D1 도구 오류 — 원장 V-4be70d81 COLUMN / 원장 V-970cb5a6 COLUMN / 원장 V-cac08731 ASIS / 실측[T-493c02bd]: 기존행 r0 BOD_ID 편집=false (AS-IS 잠금) /  |  | 3 (D00-3-023 ACT:SCP0007_BOD.EditButton:455) |
| WK-SCP0007-0177 | D1 | CREATED_BY / Created By | 하네스·환경 | D1 도구 오류 — 원장 V-a1e0b68c COLUMN / 원장 V-6819078a COLUMN / 실측[T-4b111f46]: 기존행 r0 CREATED_BY 편집=false (AS-IS 잠금) / 신규행 r0 CREATED_BY |  | 1 (D00-3-024) |
| WK-SCP0007-0178 | D1 | CREATION_DATE / Creation Date | 하네스·환경 | D1 도구 오류 — 원장 V-ab648ca9 COLUMN / 원장 V-25f9e72a COLUMN / 실측[T-6321e1ff]: 기존행 r0 CREATION_DATE 편집=false (AS-IS 잠금) / 신규행 r0 CREATIO |  | 1 (D00-3-024) |
| WK-SCP0007-0179 | D1 | CUSTOMER / Customer | 하네스·환경 | D1 도구 오류 — 원장 V-6a47f3f3 COLUMN / 원장 V-8d9077b4 COLUMN / 실측[T-2fac9dc2]: 기존행 r0 CUSTOMER 편집=false (AS-IS 잠금) / 신규행 r0 CUSTOMER 편집= |  | 2 (D00-3-018 ACT:SCP0007_BOD.InsertButton:4) |
| WK-SCP0007-0180 | D1 | DAYS_MON / Mon | 하네스·환경 | D1 도구 오류 — 원장 V-67047a63 COLUMN / 원장 V-88600a28 COLUMN / 실측[T-f3dd1f7e]: 기존행 r0 DAYS_MON 편집=false (AS-IS 잠금) / 신규행 r0 DAYS_MON 편집= |  | 1 (D00-3-023) |
| WK-SCP0007-0181 | D1 | DIS_TOTAL_LEAD_TIME / Distribution Total | 하네스·환경 | D1 도구 오류 — 원장 V-fe0b86f7 COLUMN / 원장 V-d87afc29 COLUMN / 실측[T-05b0ab4d]: 기존행 r0 DIS_TOTAL_LEAD_TIME 편집=false (AS-IS 잠금) / 신규행 r0 D |  | 1 (D00-3-023) |
| WK-SCP0007-0182 | D1 | DIVISION_ID / Division | 하네스·환경 | D1 도구 오류 — 원장 V-dd1002b1 COLUMN / 원장 V-126bbe5d COLUMN / 원장 V-0659d173 ASIS / 실측[T-810a9f00]: 기존행 r0 DIVISION_ID 편집=false (AS-IS 잠 |  | 5 (D00-3-009 D00-3-017 ACT:SCP0007_BOD.Edit) |
| WK-SCP0007-0183 | D1 | FROM_CITY / From City | 하네스·환경 | D1 도구 오류 — 원장 V-d24bec3a COLUMN / 원장 V-a68bc49e COLUMN / 실측[T-c9911ada]: 기존행 r0 FROM_CITY 편집=false (AS-IS 잠금) / 신규행 r0 FROM_CITY 편 |  | 3 (D00-3-019 D00-3-070 ACT:SCP0007_BOD.Inse) |
| WK-SCP0007-0184 | D1 | LAST_UPDATED_BY / Last Updated By | 하네스·환경 | D1 도구 오류 — 원장 V-c3a7e99f COLUMN / 원장 V-81ee1263 COLUMN / 실측[T-5b6584e2]: 기존행 r0 LAST_UPDATED_BY 편집=false (AS-IS 잠금) / 신규행 r0 LAST_ |  | 1 (D00-3-024) |
| WK-SCP0007-0185 | D1 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-4b520566 COLUMN / 원장 V-1f8e733e COLUMN / 실측[T-c96f5600]: 기존행 r0 LAST_UPDATE_DATE 편집=false (AS-IS 잠금) / 신규행 r0 LAST |  | 1 (D00-3-024) |
| WK-SCP0007-0186 | D1 | LEAD_TIME / Lead Time | 하네스·환경 | D1 도구 오류 — 원장 V-a8bd7cd1 COLUMN / 원장 V-a9f5ee58 COLUMN / 실측[T-bf111d89]: 기존행 r0 LEAD_TIME 편집=false (AS-IS 잠금) / 신규행 r0 LEAD_TIME 편 |  | 1 (D00-3-023) |
| WK-SCP0007-0187 | D1 | LT_TYPE / L/T Type | 하네스·환경 | D1 도구 오류 — 원장 V-3e4eaf26 COLUMN / 원장 V-da491280 COLUMN / 원장 V-cac08731 ASIS / 실측[T-7e51487e]: 기존행 r0 LT_TYPE 편집=false (AS-IS 잠금) / |  | 3 (D00-3-023 ACT:SCP0007_BOD.EditButton ACT) |
| WK-SCP0007-0188 | D1 | ROUTE_CNT / Route Count | 하네스·환경 | D1 도구 오류 — 원장 V-579f88c9 COLUMN / 원장 V-13b579be COLUMN / 원장 V-af7b6f2f ASIS / 실측[T-23315fab]: 기존행 r0 ROUTE_CNT 편집=false (AS-IS 잠금) |  | 4 (D00-3-022 ACT:SCP0007_BOD.EditButton ACT) |
| WK-SCP0007-0189 | D1 | ROUTE_VALID / Route Valid | 하네스·환경 | D1 도구 오류 — 원장 V-7e7aaad5 COLUMN / 원장 V-dadb820d COLUMN / 원장 V-59103228 ASIS / 실측[T-d1c736a8]: 기존행 r0 ROUTE_VALID 편집=false (AS-IS 잠 |  | 4 (D00-3-024 ACT:SCP0007_BOD.EditButton ACT) |
| WK-SCP0007-0190 | D1 | TO_CITY / To City | 하네스·환경 | D1 도구 오류 — 원장 V-54d6fc78 COLUMN / 원장 V-2e9475c4 COLUMN / 실측[T-18808384]: 기존행 r0 TO_CITY 편집=false (AS-IS 잠금) / 신규행 r0 TO_CITY 편집=fa |  | 2 (D00-3-020 ACT:SCP0007_BOD.InsertButton:4) |
| WK-SCP0007-0191 | D3 | FROM_SITE_CODE / From Site | 하네스·환경 | D3 도구 오류 — 원장 V-b30dd3c6 ASIS / 원장 V-3b5c0b42 ASIS / 원장 V-4dfc32a3 ASIS / 원장 V-004d10db ASIS / 원장 V-df27b39b ASIS / 원장 V-90f8f008  |  | 3 (D00-4f-012 ACT:SCP0007_BOD.SpdMain_Combo) |
| WK-SCP0007-0192 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | 하네스·환경 | D3 도구 오류 — 원장 V-9a793d94 |  | 1 (ACT:SCP0007_BOD.EditButton:482:20) |
| WK-SCP0007-0193 | D3 | INCOTERMS_SSP,INCOTERMS_SSP | 하네스·환경 | D3 도구 오류 — 원장 V-69447e5a |  | 1 (ACT:SCP0007_BOD.EditButton:496:24) |
| WK-SCP0007-0194 | D3 | SAFETY_STOCK / Safety Stock | 하네스·환경 | D3 도구 오류 — 원장 V-58b49478 ASIS / 원장 V-df27b39b ASIS / 원장 V-90f8f008 ASIS / 원장 V-c16aafeb ASIS / 원장 V-0746a4d0 ASIS / 원장 V-28803102  |  | 17 (D00-3-021 D00-3-032 D00-3-072 D00-3-073 ) |
| WK-SCP0007-0195 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-df27b39b / 실측[T-cae6b37c]: r0 SAFETY_STOCK 그리드에 없음 · r1 SAFETY_STOCK 그리드에 없음 · r69 SAFETY_STOCK 그리드에 없음 · r0 SAFET |  | 1 (ACT:SCP0007_BOD.SetCityCode:1433:36) |
| WK-SCP0007-0196 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-90f8f008 / 실측[T-bbf7ef8b]: r0 SAFETY_STOCK 그리드에 없음 · r1 SAFETY_STOCK 그리드에 없음 · r69 SAFETY_STOCK 그리드에 없음 · r0 SAFET |  | 1 (ACT:SCP0007_BOD.SetCityCode:1437:37) |
| WK-SCP0007-0197 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-c16aafeb |  | 1 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0198 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-0746a4d0 |  | 1 (ACT:SCP0007_BOD.SpdMain_ClipboardPasted:) |
| WK-SCP0007-0199 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-28803102 |  | 1 (ACT:SCP0007_BOD.SpdMain_ComboSelChange:1) |
| WK-SCP0007-0200 | D3 | SAFETY_STOCK,SAFETY_STOCK | 하네스·환경 | D3 도구 오류 — 원장 V-15da4a34 |  | 1 (ACT:SCP0007_BOD.SpdMain_ComboSelChange:1) |
| WK-SCP0007-0201 | D3 | SCP0007_BOD.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-58b49478 ASIS / 원장 V-9a793d94 ASIS / 원장 V-eb4a5d7f ASIS / 원장 V-69447e5a ASIS |  | 8 (ACT:SCP0007_BOD.EditButton:441:1 ACT:SCP) |
| WK-SCP0007-0202 | D3 | TO_SITE_CODE / To Site | 하네스·환경 | D3 도구 오류 — 원장 V-c16aafeb ASIS / 원장 V-0746a4d0 ASIS / 원장 V-28803102 ASIS / 원장 V-15da4a34 ASIS / 실측[T-6b68ac55]: TO_SITE_CODE: AS-IS |  | 6 (D00-2-002 D00-4f-012 ACT:SCP0007_BOD.Edi) |
| WK-SCP0007-0203 | D3 | VMI_YN / To Site VMI | 하네스·환경 | D3 도구 오류 — 원장 V-58b49478 ASIS / 원장 V-df27b39b ASIS / 원장 V-90f8f008 ASIS / 원장 V-c16aafeb ASIS / 원장 V-0746a4d0 ASIS / 원장 V-28803102  |  | 11 (D00-3-021 D00-3-032 D00-3-072 D00-3-073 ) |
| WK-SCP0007-0204 | X-ROW | SCP0007_BOD.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0007_BOD.CreateSpread) |
| WK-SCP0007-0205 | X-ROW | SCP0007_BOD.SetChangeControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:4 · PASS:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0007_BOD.SetChangeControl ACT:SCP) |
| WK-SCP0007-0206 | X-ROW | SCP0007_BOD.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0007_BOD.SpdMain_TopChange ACT:SC) |
| WK-SCP0007-0207 | X-ROW | SCP0007_BOD.cboDivision_SelectedIndexCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0007_BOD.cboDivision_SelectedInde) |
| WK-SCP0007-0208 | X-ROW | SCP0007_BOD.spdMain_CellDoubleClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 57검사 — PASS:52 · NA:3 · ERROR:2 |  | 15 (ACT:SCP0007_BOD.spdMain_CellDoubleClick:) |
| WK-SCP0007-0209 | X-ROW | SCP0007_DistributionRoutePopup.InitSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 134검사 — PASS:56 · NA:42 · ERROR:36 |  | 71 (ACT:SCP0007_DistributionRoutePopup.InitS) |
| WK-SCP0007-0210 | X-ROW | SCP0007_DistributionRoutePopup.SetRoute | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:5 · ERROR:1 · PASS:1 |  | 28 (ACT:SCP0007_DistributionRoutePopup.SetRo) |
| WK-SCP0007-0211 | X-ROW | SCP0007_DistributionRoutePopup.btnButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · PASS:1 |  | 10 (ACT:SCP0007_DistributionRoutePopup.btnBu) |
| WK-SCP0007-0212 | X-ROW | SCP0007_DistributionRoutePopup.btnFromSr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — PASS:12 · NA:6 · ERROR:2 |  | 9 (ACT:SCP0007_DistributionRoutePopup.btnFr) |
| WK-SCP0007-0213 | X-ROW | SCP0007_DistributionRoutePopup.btnToSrch | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — PASS:12 · NA:6 · ERROR:2 |  | 9 (ACT:SCP0007_DistributionRoutePopup.btnTo) |
| WK-SCP0007-0214 | X-ROW | SCP0007_DistributionRoutePopup.spdMainDa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — NA:9 · ERROR:8 · PASS:2 |  | 25 (ACT:SCP0007_DistributionRoutePopup.spdMa) |
