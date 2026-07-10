# DMF0074 Metal Link Price — AS-IS ↔ TO-BE 매핑 (100%)

> AS-IS 정본: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.cs`
> (물리 760줄 · legacy 사본 SHA-256 동일) + Designer 1,073 + 전용 팝업 `DMF0074_MetalLinkPricePopup.cs`(물리 347).
> 분석 정본: `Doc/화면설계서/DMF0074_MetalLinkPrice_상세동작_개발용.md` (이벤트 21 · Validation 10 · Expression 0)
> + `DMF0074_MetalLinkPrice_UI분석서_v1.0.xlsx` (11시트 · hook #105).
> ⚠ AS-IS asis-mapping 원본 부재 (`Doc/_analysis/_asis_mappings/DM/` 에 DMF0074 없음) — 본 문서가 신규 정본.

## 1. 이벤트/액션 매핑 (21건 — 상세동작 MD §1 1:1)

| # | AS-IS (핸들러/라인) | TO-BE | 상태 |
|---|---|---|---|
| 1 | ctor/Form_Load (L60~) | `MetalLinkPrice.tsx` mount + store 초기화 | ✅ |
| 2 | InitControls — GetDMInnerTable 7종 chain (L100~159) | `useTabComboQueries`(MyDivision/TeambyDivision/EndCustomer/SalesSite/SalesPlant) | ✅ (공용 콤보 대체) |
| 3 | DefineProperty — 기본값 (Period 당월~+6 L167, Version 'Current' L222) | store `initMetalLinkPriceState` | ✅ |
| 4 | CreateSpread/InitSpread — 2단 헤더 (CreateSheetHeaderColumn(2) L280) | `MetalLinkPriceGrid` dynamicColumns 6그룹×7원소 (admin sClsLblNm) | ✅ |
| 5 | clbDivisions SIC (L249) — 하위 5종 reset + Project/PlantSite 활성분기 + Version clear (L574) | Form Division onChange cascade clear | ✅ |
| 6 | clbTeam SIC (L238) — EndCustomer/SalesSite reset | Form Team onChange | ✅ |
| 7 | clbEndCustomer SIC (L198) — SalesSite reset | Form EndCustomer onChange | ✅ |
| 8 | clbScmSite (값 수집만) | Form SalesSite onChange | ✅ |
| 9 | clbPlantSite — 81* 전용 (82/40 비활성+clear) | `isPlantDisabled` | ✅ |
| 10 | FindButton/FindData (L361~495) — 검증 6종 → GET SP → 전셀 잠금 → SmartColMerge | `handleSearch` + validateFind + `useTabProcQuery` + `isReadOnly` | ✅ |
| 11 | Insert/Delete/Edit/Save override — **빈 몸체** | hotkeyConfig `false` (버튼 미노출) | ✅ (AS-IS 1:1) |
| 12 | ExcelButton (L312~356) — ExportFpSpread | SubTitle 공통 EXCEL (`GridAction.excelDownload`) | ✅ |
| 13 | btnProject_Click (L639) — SCM0002_ProjectbyDivisionPopupEx | `ProjectByDivisionModal` (40 비활성) | ✅ |
| 14 | btmItem_Click (L663) — DM0002_ItembyDivisionPopupEx | `ItemByDivisionModal` | ✅ (⭐ 개선: 취소 시 기존값 유지 — AS-IS 는 빈값 덮임 quirk) |
| 15 | btnSPVer_Click (L673~702) — DMF0073_VersionBySalesPricePopup("SP", ±3M) | `MetalLinkVersionModal` (versionType 'SP' · 최대 2 MSG00255) | ✅ |
| 16 | btnTemplate 'Excel Form' (L704~713) — 전용 MetalLinkPricePopup | ⭐ `MetalLinkTemplateModal` (TEMPLATE proc 조회 + Excel export = 템플릿 다운로드) | ✅ |
| 17 | btnExcelUpload_Click (L715~737) — ExcelUploadForm(DIV=40→'DMF0074_40') + MSG00265 재조회 | `FcstUploadModal` menuId 분기 + confirm→refetch | ✅ |
| 18 | GetSpdTitle — DMF0000_GET_COMMON_SPREAD_TITLE (L745) | admin SHEET_COLUMNS sClsLblNm 로 대체 (그룹 라벨 동일 원천 — SPREAD_TITLE proc 불요) | ✅ (등가 대체) |
| 19 | SmartColMerge / LockColumn 전셀 | DataGrid `isReadOnly` + allowMerging='All'(TopLeft) | ✅ |
| 20 | SetChangeControl 콤보 계단 (L100~159) | Form cascade + useTabComboQueries | ✅ |
| 21 | 헬퍼 4종 (GetDayRange 미호출 dead 등) | 미이식 (dead code — §4) | ✅ (재현 금지) |

## 2. Validation 매핑 (10곳 — MSG_M 실측 대사)

| # | AS-IS (라인) | MSG | TO-BE | 상태 |
|---|---|---|---|---|
| 1 | FindData blnWork (L370) | MSG00137 | `isFetching` 가드 | ✅ |
| 2 | Version 공란 (L377) | MSG00283 | validateFind | ✅ |
| 3 | Plan Date 공란 (L387) | AS-IS MSG00002 → **MSG00614** (사내 MSG00002=저장성공 재정의 — 유용 금지) | validateFind | ✅ (ID 재지정) |
| 4 | 날짜 파싱 실패 (L397) | AS-IS MSG00049 (**사내 미등록**) | ⚠ **도달 불가** — TO-BE 월 피커가 비정형 입력 원천 차단 → 미이식 | ✅ (격차 명기) |
| 5 | 기간 역전 (L403) | MSG00108 | validateFind | ✅ |
| 6 | Division 공란 (L421) | MSG00097 | validateFind | ✅ |
| 7 | 버전 3개+ (L692) | MSG00255 | `MetalLinkVersionModal` handleApply | ✅ |
| 8 | 업로드 완료 재조회 (L733) | MSG00265 | FcstUploadModal onUploaded confirm | ✅ |
| 9 | 팝업 Division 공란 (팝업 L170) | MSG00097 | Template modal handleFind + 진입 가드 | ✅ |
| 10 | 팝업 0건 (팝업 L229) | AS-IS MSG00427 (**사내 미등록**) → **MSG00656 신규 채번** (2026-07-10) | Template modal 조회완료 안내 | ✅ (신규 등록) |

## 3. Expression 매핑 (0건)

- AS-IS Expression **0건** (expressions.md 실측 일치 — LockColumn/SmartColMerge 는 그리드 표준속성).

## 4. FE 재현 금지 (AS-IS quirk/dead — 상세동작 MD §7)

| # | 항목 | 사유 |
|---|---|---|
| 1 | `dtCustomer` null 참조 (L565·620) | 전 구간 미적재 버그 — `dtEndCustomer` 로 교정 매핑 |
| 2 | FP_Log2 라벨 "DMF0020" 오기 (L514·570) | DMF0020 복사 잔재 — 로깅은 BE SYS_LOG 표준 |
| 3 | dead code: GetDayRange(미호출)/InitEvent(빈)/dtDepartment·dtBizType(적재만)/DefColumns(빈)/L578~593 주석 | 미이식 |
| 4 | btmItem 취소 시 txtItemId 빈값 덮임 (L670) | TO-BE 빈 반환 시 기존값 유지로 개선 |

## 5. 편집제어 (단일 division-gate — 이중 아님)

- SP `PKG_DMF0074` GET(L452)/TEMPLATE(L837): `SCM_ADM_USER_MNU_EDIT_AUTH_V` INNER JOIN —
  **행 하드필터**(권한 없는 사업부 = 미반환) + `EDIT_YN` 프로젝션(L450/835/852).
- EDIT_FLAG CASE·GET_ADMIN_GROUP·DM_UI_EDITABLE·시간락 = **全無** (grep 0건 실측).
- FE: 중복 필터 없음(SP 소관). 그리드 전셀 읽기전용 — EDIT_YN 으로 셀 열지 않음 (AS-IS 동작 없음).

## 6. 메타 배선 (2026-07-10 — `_artifacts/_deploy_packages/_dmf0074_metal_link_price_fe_20260710/`)

- API_M 7 (main 5 + template + version PROC_SELECT) / PROC_M 19 (main 14 + template 5 — version 9행 기존 공유)
- BTN_MPG 8 (main 5 + template + version + **DMF0074_40 UPLOAD** — DIV=40 excel-upload auth)
- USER_GR 22 (ADMIN/DM ADMIN 전체 · DM Viewer = UPLOAD 미부여)
- EXCEL_COLUMNS STORAGE_SQL_ID 교정 2 (INVALID standalone → `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD`)
- MSG00656 + LBL00762('Excel Form') + LBL00763('Excel Download') 신규 (KO=EN=CN)
- MNU_URL `dmf0074` → `metal-link-price` (3-SET: route-paths.ts / Router.tsx / MNU_M)
- hook #92: SHEET_COLUMNS ATTRIBUTE3 ← DIVISION_ID 복사 (58행 — PROJECT 2열 40 미표시)

## 7. 격차 (정직 표기)

1. SHEET_MEASURE 0 (미등록 — 메저 축 없음, AS-IS 동일)
2. standalone SP 5종 INVALID (운영 = PKG_DMF0074 VALID — 배선은 전부 PKG 경로)
3. MSG00049 미등록 유지 (TO-BE 도달 불가 — §2-4)
4. PKG 내 GTT TRUNCATE 2곳(L153/L1046) mutex hang 위험 (DMF0014 동형) — SP 소관, 별도 과제
