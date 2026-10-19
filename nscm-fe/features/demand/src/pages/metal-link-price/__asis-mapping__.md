# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0074_MetalLinkPrice_상세동작_개발용.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | §1 이벤트 · 액션 상세 (21) | IT-01~IT-21 (이벤트·액션 21 원자 축) — features/demand/src/pages/metal-link-price/ 전반 |  | 구현 |
| E02 | §2 ⭐ 편집제어(단일 division-gate) + 저장 구조 (FE 구현 판정 로직) | ED-01~ED-07 (편집제어·저장구조 축) |  | 구현 |
| E02-1 | §2.1 편집제어 — AS-IS 는 "전체 잠금", TO-BE 는 "행 하드필터 + EDIT_YN" | ED-01~ED-06 — 그리드 전셀 읽기전용 + SP INNER JOIN 하드필터 + EDIT_YN |  | 구현 |
| E02-2 | §2.2 저장 구조 — 그리드 직접 SAVE 없음, Excel Upload 단일 경로 | ED-07 — features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:285~320 (Excel Upload 2-Step 단일 저장경로) |  | 구현 |
| E02-3 | §2.3 조회 SP 버전 분기 (PKG 실측) | PKG_DMF0074 GET SP 버전 분기 — versionType 'Current' vs 버전NO (store:92 전달) |  | 구현 |
| E03 | §3 버튼 · 컨트롤 인벤토리 — AS-IS 실측 | BT-01~BT-08 + CT-01~CT-09 (버튼·컨트롤 인벤토리 축) |  | 구현 |
| E03-1 | §3.1 버튼 (7 = toolbar 유효 2 + 화면 5) | BT-01~BT-08 |  | 구현 |
| E03-2 | §3.2 조회조건 컨트롤 (9) | CT-01~CT-09 |  | 구현 |
| E04 | §4 팝업 흐름 ①→②③ (5) | PU-01~PU-05 (팝업 흐름 축) |  | 구현 |
| E05 | §5 Validation 6건 매핑 (MSG_M 실측 대사) + Expression 0건 | VA-01~VA-10 + XP-00 |  | 구현 |
| E05-1 | §5.1 Validation — 기존 `validation.md` 6건 대조 + **사내 MSG_M(KO) 실측 문구** (2026-07-10 ora.py) | VA-01~VA-10 (MSG_M 실측 대사 완료 — MSG00002→00614 / 00049 도달불가 / 00427→00656) |  | 구현 |
| E05-2 | §5.2 Expression — **0건 명기** | XP-00 — Expression 0건 | AS-IS expressions.md 대조 0건 (조회전용 화면) | 해당없음 |
| E06 | §6 ② User 관점 변환 요지 (시트 5 반영용) | 사용자 관점 요지 — UI분석서 v1.0 시트5 반영분 | 분석 문서 서술 절(구현 대상 아님) | 해당없음 |
| E06-1 | §6.1 화면 성격 | §6.1 화면 성격 — 조회전용 + 엑셀 업로드 단일 수정경로 | 동상 | 해당없음 |
| E06-2 | §6.2 조회 | §6.2 조회 서술 — CT/VA 축이 구현 근거 보유 | 동상 | 해당없음 |
| E06-3 | §6.3 템플릿 다운로드 · 업로드 | §6.3 템플릿·업로드 서술 — PU-04/PU-05 가 구현 근거 보유 | 동상 | 해당없음 |
| E07 | §7 격차 (TO-BE 이관 관점) — 2026-07-10 사내 DB·FE 실측 | GP-01~GP-09 (격차 축 — 2026-08-18 현재 상태로 갱신) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E02:SAVE | [SAVE] §2 ⭐ 편집제어(단일 division-gate) + 저장 구조 (FE 구현 판정 로직) | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:285~320 (FcstUploadModal onSave → P_MODE=1) | 그리드 직접 SAVE 경로 없음 — 저장은 Excel Upload 2단계가 유일(AS-IS 파리티). 2026-08-16 원장 적재 왕복 실측 PASS | 구현 |
| MODAL:ItemByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PU-02 — @master/components ItemByDivisionModal 재사용 |  | 구현 |
| MODAL:MetalLinkTemplateModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PU-04 — features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx |  | 구현 |
| MODAL:MetalLinkVersionModal | FE 실존 모달 (components/modals/MetalLinkVersionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | PU-03 — features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | AS-IS DMF0073_VersionBySalesPricePopup 대응 (분석 md §4-C 근거 존재) | 구현 |
| MODAL:ProjectByDivisionModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PU-01 — @master/components ProjectByDivisionModal 재사용 |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | — | AS-IS 코드의 `ShowDialog()` 호출문(WinForms 모달 표시 API)이 팝업명으로 오추출된 행 — 개별 팝업은 PU-01~PU-05 가 보유 | 해당없음 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 이 화면은 신규행 Insert 기능이 없다(AS-IS InsertButton 빈 override → hotkeyConfig.insert=false). 필터×신규행 상호작용 자체가 성립하지 않음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | — | 그리드 편집 경로가 없어(전 셀 읽기전용) '수정 중 데이터'가 존재하지 않는다 — MSG00703 confirm 대상 아님 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | Column/Measure 설정 모달 미보유 화면(그리드는 admin SHEET_COLUMNS 고정 PIVOT). AS-IS 에도 컬럼 설정 UI 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | components/fcst-upload-modal/FcstUploadModal.tsx:165~175,247 (Toast — 검증완료 MSG00659 / 저장완료 MSG00606·MSG00265) | 업로드가 이 화면의 유일한 CRUD — 완료 알림은 공용 모달 Toast 가 담당(Alert 아님) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | — | 그리드에 콤보(dataMap) 셀이 없다 — 전 컬럼 SEARCH_ONLY 텍스트(Grid:111,137). Code→Name 변환 대상 컬럼 부재 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | features/demand/src/pages/metal-link-price/useMetalLinkPriceStore.ts:88~89 (projectCode/itemId raw 전달) + PKG_DMF0074 GET 토큰 분해(B1/B2 서브쿼리 LIKE) | Key-in 조회조건 = Project·Model 2종. AS-IS raw 전달 계약 유지 | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx:6 import + :263~268 rebindFilterColumns (정본 DMF0042 BusinessPlanGrid.tsx:715 동형) | ⭐ 2026-08-18 보완 — 미적용 상태였음. 조회마다 DataGrid key 재마운트 + 메탈 42 dynamicColumns 재생성이라 끊긴 Column 참조 재바인딩 필요 | 구현 |

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

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 18개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0074_MetalLinkPrice.cs:300` (라이브 2행) · **사문(빈 몸통)** | IT-12 참조 | AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티 | 구현 |
| HANDLER:EditButton | AS-IS `DMF0074_MetalLinkPrice.cs:304` (라이브 2행) · **사문(빈 몸통)** | IT-12 참조 | AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티 | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0074_MetalLinkPrice.cs:312` (라이브 25행) | IT-13 참조 |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0074_MetalLinkPrice.cs:291` (라이브 3행) · **사문(빈 몸통)** | IT-11 참조 | AS-IS 는 FindData() 호출 3행 래퍼 — 실체는 FindData(IT-11) | 구현 |
| HANDLER:FindData | AS-IS `DMF0074_MetalLinkPrice.cs:361` (라이브 96행) | IT-11 참조 |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0074_MetalLinkPrice.cs:83` (라이브 8행) | IT-02 참조 |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0074_MetalLinkPrice.cs:296` (라이브 2행) · **사문(빈 몸통)** | IT-12 참조 | AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티 | 구현 |
| HANDLER:SaveButton | AS-IS `DMF0074_MetalLinkPrice.cs:308` (라이브 2행) · **사문(빈 몸통)** | IT-12 참조 | AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티 | 구현 |
| HANDLER:btmItem_Click | AS-IS `DMF0074_MetalLinkPrice.cs:653` (라이브 13행) | IT-15 참조 |  | 구현 |
| HANDLER:btnExcelUpload_Click | AS-IS `DMF0074_MetalLinkPrice.cs:715` (라이브 15행) | IT-18 참조 |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0074_MetalLinkPrice.cs:632` (라이브 16행) | IT-14 참조 |  | 구현 |
| HANDLER:btnSPVer_Click | AS-IS `DMF0074_MetalLinkPrice.cs:673` (라이브 23행) | IT-16 참조 |  | 구현 |
| HANDLER:btnTemplate_Click | AS-IS `DMF0074_MetalLinkPrice.cs:704` (라이브 5행) | IT-17 참조 |  | 구현 |
| HANDLER:clbDivisions_SelectedIndexChanged | AS-IS `DMF0074_MetalLinkPrice.cs:501` (라이브 64행) | IT-06 참조 |  | 구현 |
| HANDLER:clbEndCustomer_SelectedIndexChanged | AS-IS `DMF0074_MetalLinkPrice.cs:626` (라이브 4행) | IT-08 참조 |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0074_MetalLinkPrice.cs:606` (라이브 16행) | IT-07 참조 |  | 구현 |
| HANDLER:txtItemId_KeyDown | AS-IS `DMF0074_MetalLinkPrice.cs:260` (라이브 6행) | components/MetalLinkPriceForm.tsx (Model/Nickname InputField onKeyDown → openModalOnEnter → setOpenModelByDivisionModal) | 2026-10-06 이식 — IT-10 참조 | 구현 |
| HANDLER:txtProject_KeyDown | AS-IS `DMF0074_MetalLinkPrice.cs:252` (라이브 6행) | components/MetalLinkPriceForm.tsx (Project InputField onKeyDown → openModalOnEnter → setOpenPrjByDivisionModal) | 2026-10-06 이식 — IT-09 참조 | 구현 |


## 이벤트·액션 원자 축 (md §1 [1]~[21] 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| IT-01 | [1] ctor DMF0074_MetalLinkPrice() — 폼 생성 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:39 (컴포넌트 진입) |  | 구현 |
| IT-02 | [2] Form_Load — InitForm/InitControls/DefineProperty/CreateSpread chain | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:79~83 (mount useEffect — clearFilters + fetchStaticColumns) |  | 구현 |
| IT-03 | [3] InitControls — GetDMInnerTable 콤보 chain 초기 적재(7종) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:41~43 (MyDivision/EndCustomer/SalesSite) + TeamField:89 + PlantSiteField:253 | AS-IS 화면 전용 GetDMInnerTable 7종 → 공용 CMBO/카탈로그 필드로 대체(DMF0074 자체 CMBO 등록 0). 동일 원천 조회이므로 등가 | 구현 |
| IT-04 | [4] DefineProperty — 기본값(Period 당월~+6, Version 'Current') | features/demand/src/pages/metal-link-price/useMetalLinkPriceStore.ts:47~49 (initMetalLinkPriceState) |  | 구현 |
| IT-05 | [5] CreateSpread/InitSpread — 동적 2단 PIVOT 헤더(6그룹×7원소) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx:46~78 (mergedColumns — admin sClsLblNm 그룹) |  | 구현 |
| IT-06 | [6] clbDivisions SIC — 하위 5종 reset + Project/PlantSite 활성분기 + Version clear + InitSpread | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:69~81 (reset+version clear) + MetalLinkPrice.tsx:88~95 (컬럼 재조회·그리드 초기화) |  | 구현 |
| IT-07 | [7] clbTeam SIC — EndCustomer/SalesSite reset | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:92~95 |  | 구현 |
| IT-08 | [8] clbEndCustomer SIC — SalesSite reset | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:120~123 |  | 구현 |
| IT-09 | [9] txtProject_KeyDown — Enter 시 Project 팝업 | components/MetalLinkPriceForm.tsx (openModalOnEnter — Project InputField onKeyDown) | 2026-10-06 사용자 지시로 이식(Sales Plan 과 동일 동작). 종전 "SearchArea Enter=조회 충돌" 사유는 실측 결과 성립하지 않음 — SearchArea 전역 단축키는 F5 만 바인딩. Enter 는 preventDefault 후 팝업만 연다. 한글 조합 중 Enter 무시. 검색 아이콘 버튼 진입도 그대로 유지 | 구현 |
| IT-10 | [10] txtItemId_KeyDown — Enter 시 Item 팝업 | components/MetalLinkPriceForm.tsx (openModalOnEnter — Model/Nickname InputField onKeyDown) | 2026-10-06 이식 — IT-09 와 동일 방식. 검색 아이콘 버튼 진입도 그대로 유지 | 구현 |
| IT-11 | [11] FindButton override → FindData() — 검증 6 + 조회 + 전체잠금 + SmartColMerge | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:98~145 (validateFind+handleSearch) + components/MetalLinkPriceGrid.tsx (isReadOnly + 세로 머지) |  | 구현 |
| IT-12 | [12] Insert/Delete/Edit/Save override 4종 — 전부 빈 몸체 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:157~164 (hotkeyConfig insert/delete/save=false) | AS-IS 빈 몸체 = 기능 없음 → 버튼 미노출이 1:1 파리티 | 구현 |
| IT-13 | [13] ExcelButton override — 그리드 Excel 다운로드 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:220 (excelFileName=MAIN_EXCEL_PREFIX — SubTitle 공통 EXCEL, BTN 배선 DMF0074_main_EXCEL) |  | 구현 |
| IT-14 | [14] btnProject_Click — SCM0002_ProjectbyDivisionPopupEx → txtProject | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:63,182 계열 ProjectByDivisionModal (Form:176~184 트리거) |  | 구현 |
| IT-15 | [15] btmItem_Click — DM0002_ItembyDivisionPopupEx → txtItemId | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:202~207 + ItemByDivisionModal | ⭐ AS-IS 는 취소 시 빈값 덮임(quirk L670) — TO-BE 는 기존값 유지로 개선(재현 금지 대상) | 구현 |
| IT-16 | [16] btnSPVer_Click — DMF0073_VersionBySalesPricePopup(SP, ±3M) → 최대 2개 | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx:114(versionType 'SP_W'),145~157(최대2 MSG00255) | AS-IS 'SP' 는 카테고리였으나 TO-BE VERSION_TYPE 정확토큰이 'SP_W' — 2026-07-10 실측 정정 | 구현 |
| IT-17 | [17] btnTemplate 'Excel Form' — 전용 MetalLinkPricePopup | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx (전체) + MetalLinkPrice.tsx:169~197 진입 게이트 |  | 구현 |
| IT-18 | [18] btnExcelUpload 'Upload' — ExcelUploadForm(DIV40→formId 분기) → SP → 재조회 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:151~154(formId 분기),285~320(FcstUploadModal 2-Step onSave/onUploaded) |  | 구현 |
| IT-19 | [19] SetChangeControl(FILTER_PART) — Project/PlantSite 활성 분기 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:48~50(isProjectDisabled) + 253~259(PlantSiteField division) |  | 구현 |
| IT-20 | [20] GetSpdTitle — DMF0000_GET_COMMON_SPREAD_TITLE 로 2단 헤더 라벨 취득 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx:62~63 (admin SHEET_COLUMNS sClsLblNm) | 동일 원천(admin 컬럼 메타)을 직접 소비 — 별도 SPREAD_TITLE SP 불요(등가 대체) | 구현 |
| IT-21 | [21] GetDayRange — ⚠ 미호출 dead code | — | AS-IS 에서 호출되지 않는 사문 메서드 — 이관 대상 아님(파리티) | 해당없음 |

## 버튼 인벤토리 축 (md §3.1 7 + toolbar 빈 override)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| BT-01 | Find(toolbar) — 검증 6 + 조회 + 전체잠금 + SmartColMerge | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:158 (hotkeyConfig.search=handleSearch, hasButton('SEARCH')) |  | 구현 |
| BT-02 | Excel(toolbar) — SimplexelService Export | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:220 excelFileName (BTN EXCEL 배선·권한 3행 실측) |  | 구현 |
| BT-03 | Insert/Delete/Edit/Save(toolbar) — 빈 override, TO-BE hidden | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:159~162 | AS-IS 기능 없음 → 미노출 1:1 | 구현 |
| BT-04 | btnProject '...' — Project 팝업 (81*/82 만 활성) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:176~184 (disabled=isProjectDisabled) |  | 구현 |
| BT-05 | btmItem '...' — Item 팝업 (Always) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:202~207 |  | 구현 |
| BT-06 | btnSPVer '...' — 버전 팝업(최대 2, MSG00255) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:234~239 + modals/MetalLinkVersionModal.tsx:145 |  | 구현 |
| BT-07 | btnTemplate 'Excel Form' — 템플릿 전용 팝업 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:182~197 customButtons (division 미선택 시 MSG00097 차단 169~178) | 게이트 코드가 정본 DMF0082 의 hasButton('FORM_DATA') 와 달리 hasButton('SEARCH') — 배선 실측이 template_SEARCH 라 정합(버튼코드명 차이는 결함 아님) | 구현 |
| BT-08 | btnExcelUpload 'Upload' — DIV40 formId 분기 + 완료 후 재조회 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:163 (hotkeyConfig.upload=hasButton('UPLOAD')) + 285~320 |  | 구현 |

## 조회조건 컨트롤 축 (md §3.2 9)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| CT-01 | clbDivisions — Division 단일선택 필수, 초기 ALL, SIC cascade | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:59~88 |  | 구현 |
| CT-02 | clbTeam — Team 멀티(ALL), UserTeamByDivision, SIC→하위 reset | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:89~97 (공용 TeamField) |  | 구현 |
| CT-03 | clbEndCustomer — End Customer 멀티(ALL), SIC→SalesSite reset | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:98~130 |  | 구현 |
| CT-04 | clbScmSite — Sales Site 멀티(ALL), 값 수집만(핸들러 없음) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:131~162 |  | 구현 |
| CT-05 | clbPlantSite — Plant Site 멀티, 81* 만 활성(82/기타 비활성+clear) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:253~259 (공용 PlantSiteField — division 게이트 내장) |  | 구현 |
| CT-06 | txtProject(+btnProject) — Project, 81*/82 만 활성 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:163~190 |  | 구현 |
| CT-07 | txtItemId(+btmItem) — Model/Nickname | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:191~213 |  | 구현 |
| CT-08 | drpPeriodMonth — Plan Date 월범위, 기본 당월~+6 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:214~220 (PeriodField) + useMetalLinkPriceStore.ts:47~48 |  | 구현 |
| CT-09 | txtVersion(+btnSPVer) — 기본 'Current', Division 변경 시 clear, 조회 필수키 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx:221~245 + useMetalLinkPriceStore.ts:49 + Form:79(clear) |  | 구현 |

## 팝업 흐름 축 (md §4 A~E)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| PU-01 | A. SCM0002_ProjectbyDivisionPopupEx — Division/Team/EndCust/Site 필터 → ProjectCode 반환, 빈값 아닐 때만 반영 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx ProjectByDivisionModal 사용 (@master/components 재사용) |  | 구현 |
| PU-02 | B. DM0002_ItembyDivisionPopupEx — 조건 기반 Item 목록 → ItemID 반환 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx ItemByDivisionModal 사용 | AS-IS 무조건 덮임(L670) → TO-BE 취소 시 유지 개선 | 구현 |
| PU-03 | C. DMF0073_VersionBySalesPricePopup — SP 버전 ±3개월, 3개+ MSG00255 미반영 | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx:103~157 |  | 구현 |
| PU-04 | D. DMF0074_MetalLinkPricePopup — 템플릿 전용(자동조회 없음 → Find → 전컬럼잠금 → Excel export = 템플릿 다운로드, 0건 MSG00427) | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx:68~118(Search 게이트),121~145(export),94~106(0건 안내 MSG00656) | AS-IS MSG00427 은 사내 MSG_M 미등록 → 2026-07-10 MSG00656 신규 채번으로 대체(§5.1 대사 완료) | 구현 |
| PU-05 | E. ExcelUploadForm — formId 분기(40→DMF0074_40) + SaveExceptError + 완료 confirm 재조회 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:151~154,285~320 (공용 FcstUploadModal) | 완료 피드백은 hook #132(Alert 금지·Toast) 표준에 따라 공용 모달의 Toast(MSG00606/MSG00265)로 수행 — AS-IS confirm(Yes/No) 대신 자동 재조회. 표준 우선 의도적 편차 | 구현 |

## Validation 전수 축 (md §5.1 10곳) + Expression

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| VA-01 | FindData MSG00137 — 이전 작업 실행 중 가드 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:100~103 |  | 구현 |
| VA-02 | FindData MSG00283 — Version 공란 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:105~108 |  | 구현 |
| VA-03 | FindData Plan Date 필수 — AS-IS MSG00002 는 사내 실문구가 '저장 성공' 이라 사용 금지 → MSG00614 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:111~117 (MSG.REQUIRED_VALUE=MSG00614) | MSG ID 대사 결과 교체 — hook msg-id-asis-tobe-conversion 적용 | 구현 |
| VA-04 | FindData MSG00049 — 날짜 형식 오류(사내 미등록) | — | TO-BE 월 피커(PeriodField)가 비정형 입력을 원천 차단 → 도달 불가. 사내 MSG_M 미등록이 정상 | 해당없음 |
| VA-05 | FindData MSG00108 — 기간 역전(시작>종료) | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:119~125 |  | 구현 |
| VA-06 | FindData MSG00097 — Division 필수 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:127~133 |  | 구현 |
| VA-07 | btnSPVer MSG00255 — 버전 3개+ 차단 | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx:145~150 |  | 구현 |
| VA-08 | btnExcelUpload MSG00265 — 업로드 완료 재조회 안내 | features/demand/src/pages/metal-link-price/components/fcst-upload-modal/FcstUploadModal.tsx:171~175 (공용 모달 Toast) | DMF0074 자체 상수 MSG.UPLOAD_DONE 은 사문(공용 모달이 담당) — 보완목록 R-2 로 정리 대상 | 구현 |
| VA-09 | 팝업D FindData MSG00097 — Division 필수 | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx:110~117 |  | 구현 |
| VA-10 | 팝업D FindData MSG00427 — 0건(MRF:Y 버전 없음) 안내 | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx:94~106 (MSG00656) | AS-IS MSG00427 사내 미등록 → MSG00656 신규 채번 대체 | 구현 |
| XP-00 | Expression 0건 명기 — SetValue Auto-Sync/조건부 LockRange 없음 | — | expressions.md 대조 결과 0건. 조회 후 일괄 LockColumn/SmartColMerge 는 expression 이 아닌 그리드 표준 속성(isReadOnly + 세로 머지로 재현) | 해당없음 |

## 편집제어·저장구조 축 (md §2.1 4층 + FE 판정 3)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| ED-01 | §2.1 그리드 잠금 — 조회 직후 전 셀 읽기전용(LockColumn L466) | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx (isReadOnly 그리드 — 셀 편집 UI 없음) |  | 구현 |
| ED-02 | §2.1 행 필터 — SP 가 EDIT_AUTH_V INNER JOIN 으로 무권한 division 행 통째 탈락(PKG L452/L837) | SCM_MGR.PKG_DMF0074 BODY (GET L452 / TEMPLATE L837) — FE 중복 필터 없음 | 서버측 하드필터 — FE 구현 불요가 설계 판정 | 구현 |
| ED-03 | §2.1 EDIT_YN 반환(커서 마지막 컬럼) | GET/TEMPLATE 커서 EDIT_YN — FE 는 표시/버튼 판단 근거로만 사용 |  | 구현 |
| ED-04 | §2.1 EDIT_FLAG/ADMIN/시간락 — 이 화면에는 없음 | — | DMF0044 류 행별 EDIT_FLAG·현재월 게이트가 AS-IS·TO-BE 모두 부재 — 만들면 오구현 | 해당없음 |
| ED-05 | §2.1-FE판정1 그리드 항상 읽기전용 — EDIT_YN 으로 셀 여는 로직 금지 | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx (편집 셀 타입 미사용) |  | 구현 |
| ED-06 | §2.1-FE판정2 EDIT_YN 실효 용도 = Upload/Excel Form 의미 판단 + 표시 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:157~164 (버튼 권한은 hasButton, 행 접근은 SP 필터) |  | 구현 |
| ED-07 | §2.2 저장 = 그리드 직접 SAVE 없음, Excel Upload 단일 경로(2단: 검증 P_MODE=0 → 적재 P_MODE=1) | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:285~320 (onSave=P_MODE 1) — 2026-08-16 실측 왕복 검증 완료 |  | 구현 |

## 격차 축 (md §7 — 2026-07-10 기준 → 2026-08-18 현재 상태로 갱신)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| GP-01 | FE 미개발(metal-link-price 폴더 부재) | features/demand/src/pages/metal-link-price/ 13파일 구현 완료(2026-07-10) | 해소됨 | 구현 |
| GP-02 | 메타 배선 0 (API_M/PROC_M/MNU_BTN/SHEET_MEASURE) | 사내 실측 2026-08-18: API_M 8 / PROC_M 24 / MNU_BTN 9 / USER_GR_BTN 24 / EXCEL_COLUMNS 2 배선 완료 | SHEET_MEASURE 는 이 화면이 measure 개인화를 쓰지 않아 0행이 정상(조회전용 PIVOT) | 구현 |
| GP-03 | standalone SP 5종 INVALID — 정본은 PKG_DMF0074 | 이관 패키지 제외 명시 (_deploy_packages/DMF0074_CLOUD_20260818/_README.md §3) | 변환 중간 잔재 — API_M 배선은 전부 PKG 참조로 실측 확인 | 제외 |
| GP-04 | MD 줄수 오기 정정(.cs 물리 760줄) | 분석 md 각주 반영 완료 | 문서 사항 | 해당없음 |
| GP-05 | MSG 3건 대사 함정(MSG00002/00049/00427) | VA-03/VA-04/VA-10 참조 — MSG00614/도달불가/MSG00656 으로 각각 정리 완료 |  | 구현 |
| GP-06 | PKG GTT TRUNCATE 위험(GET L153·UPLOAD L1046 외 총 17개소) — 동시세션 mutex 경합 hang | SCM_MGR.PKG_DMF0074 BODY — TRUNCATE 17건 전량 `DELETE FROM` 전환 (마커 [E20260818-GTTDEL]). 2026-08-18 사내 적용 완료(PACKAGE/BODY VALID·에러 0). 회귀 실측: 업로드 26케이스 PASS 23/FAIL 3 (정정 전과 동일·원장 불변 5.2s) + E2E 조회 40/81/82 = 5/3,771/368행·템플릿 413행 동일(13.2s) | | 구현 |
| GP-07 | AS-IS 코드 quirk 4종(dtCustomer null·FP_Log2 라벨오기·dead code·btmItem 빈값덮임) | TO-BE 재현 금지 — IT-15 개선 반영 | quirk 는 이관 대상 아님 | 제외 |
| GP-08 | 공통버튼 정책 — insert/delete/save hidden + search/excel 노출 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:157~164 |  | 구현 |
| GP-09 | 자체 버튼 3종(Excel Form/Upload/버전) 표준 배치 | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx:182~197(customButtons) + Form:234~239(Version 필드 내 트리거) |  | 구현 |

## Excel Upload SP Validation 축 (PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD — xlsx v1.1 실측 49판정)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
|---|---|---|---|---|
| EV-001 | [C2] Div — Div 값이 공란(NULL) → `NULL DIVISION.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-002 | [C2] Plan Date — Plan Date 값이 공란(NULL) → `NULL PLAN DATE.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-003 | [C2] End Customer — End Customer 값이 공란(NULL) → `NULL END CUSTOMER.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-004 | [C2] Project Code — Project Code 값이 공란(NULL) → `NULL PROJECT CODE.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-005 | [C2] Sales Site — Sales Site 값이 공란(NULL) → `NULL SALES SITE.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-006 | [C2] Currency — Currency 값이 공란(NULL) → `NULL CURRENCY.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-007 | [C2] FCST type — FCST type 값이 공란(NULL) → `NULL FCST TYPE.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-008 | [C2] Metal Link — Metal Link 값이 공란(NULL) → `NULL Metal Link.` | PKG_DMF0074 BODY L1260 (실측 PASS) |  | 구현 |
| EV-009 | [C3] Div — 해당 division 에 금주 Sales Plan Waterfall(SP_W) 의 Monthly Rolling Forecast='Y' 버전이 없음 → `There is no version of Monthly Rolling Forest:Y in Sales Plan Waterfall this week.` | PKG_DMF0074 BODY L1308 (실측 미검증) | 테스트 계정 조회 시 40 만 버전 보유 → 40 은 통과. 81/82 는 RESULT_C 0행 | 구현 |
| EV-010 | [C4] Key_* 7종 — Key 7종이 전부 공란 → `NULL APPLY PRICE TYPE CODE.` | PKG_DMF0074 BODY L1330 (실측 PASS) |  | 구현 |
| EV-011 | [C5] Key_Ni — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Ni', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Ni` | PKG_DMF0074 BODY L1357 (실측 PASS) |  | 구현 |
| EV-012 | [C6] Key_Co — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Co', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Co` | PKG_DMF0074 BODY L1380 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-013 | [C7] Key_Li2CO3 — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Li2Co3', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Li2CO3` | PKG_DMF0074 BODY L1403 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-014 | [C8] Key_LIOH — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='LIOH', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : LIOH` | PKG_DMF0074 BODY L1426 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-015 | [C9] Key_Al — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Al', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Al` | PKG_DMF0074 BODY L1449 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-016 | [C10] Key_Mn — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Mn', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Mn` | PKG_DMF0074 BODY L1472 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-017 | [C11] Key_Cu — 값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='Cu', SEG3=입력값, VALID_YN='Y') 에 미등재 → `Invalid KEY CODE : Cu` | PKG_DMF0074 BODY L1495 (실측 미검증(동일 패턴)) | 40 의 Ni 유효코드 실측 = M035 / M036 | 구현 |
| EV-018 | [C12] Div·Plan Date·End Customer·Project Code·Model Code·Sales Site·Currency·FCST type — 동일 8키 조합이 파일 내 2행 이상 → `Duplication Model.` | PKG_DMF0074 BODY L1531 (실측 PASS(정정 후)) |  | 구현 |
| EV-019 | [C13] Plan Date — 6자리 숫자(YYYYMM)가 아니거나 월이 01~12 범위 밖 → `Invalid Date Format.` | PKG_DMF0074 BODY L1579 (실측 PASS) |  | 구현 |
| EV-020 | [C14] Plan Date — 당월(SYSDATE YYYYMM)보다 과거 → `Past Date.` | PKG_DMF0074 BODY L1598 (실측 PASS) |  | 구현 |
| EV-021 | [C15] End Customer — LOOKUP 'END_CUSTOMER'(SEG1=Div, SEG2=입력값, VALID_YN='Y') 미등재 → `Invalid END CUSTOMER.` | PKG_DMF0074 BODY L1623 (실측 PASS) |  | 구현 |
| EV-022 | [C15] Project Code — SCM_MST_PROJECT(DIVISION_ID, PROJECT_CODE) 미등재 → `Invalid PROJECT CODE.` | PKG_DMF0074 BODY L1639 (실측 미검증) | 40 은 대상 외 | 구현 |
| EV-023 | [C16] Model Code — SCM_MST_SITE ⋈ SCM_MST_SITE_ITEM 조합(Div, Project Code, Site, Item, VALID_YN='Y') 미존재 → `Invalid MODEL.` | PKG_DMF0074 BODY L1662 (실측 PASS(정정 후)) |  | 구현 |
| EV-024 | [C17] Model Code — 82 사업부에서 ENERGY 값이 없는 모델 → `Invalid MODEL : NULL ENERGY` | PKG_DMF0074 BODY L1693 (실측 정정됨(82 데이터 미보유로 미실행)) | 결함 D1 동일 원인·동일 정정 | 구현 |
| EV-025 | [C18] Model Code — DM_MST_ITEM_SINGLE_V.ITEM_TYPE 이 '제품(P)' 이 아님 → `Invalid MODEL : TYPE P.` | PKG_DMF0074 BODY L1716 (실측 정정됨(케이스 미구성)) | 결함 D1 동일 원인·동일 정정 | 구현 |
| EV-026 | [C19] Model Code·Sales Site·Currency·FCST type — 금주 MRF 버전의 DM_PLN_SALES_PLAN_RESULT_C 에 (Div, Project/EndCust, Item, Site, Currency, FCST type) 조합이 없음 → `Invalid Sales Plan Waterfall MODEL.` | PKG_DMF0074 BODY L1737 (실측 PASS) |  | 구현 |
| EV-027 | [C20] Metal Link — UPPER(값) 이 'Y'/'N' 이 아님 → `Invalid Metal Link.` | PKG_DMF0074 BODY L1816 (실측 PASS) |  | 구현 |
| EV-028 | [C21] Sales Site — SCM_MST_SITE(Div, Site, VALID_YN='Y') 미등재 → `Invalid Sales Site.` | PKG_DMF0074 BODY L1833 (실측 PASS(마스킹)) |  | 구현 |
| EV-029 | [C22] Currency — DM_MST_EXCHANGE_RATE(Div, UNIT_CURRENCY) 미등재 → `Invalid CURRENCY.` | PKG_DMF0074 BODY L1854 (실측 PASS(마스킹)) |  | 구현 |
| EV-030 | [C23] FCST type — LOOKUP 'SALES_TYPE_CODE'(SEG2=입력값, SEG4<>'FREE', VALID_YN='Y') 미등재 → `Invalid FCST TYPE.` | PKG_DMF0074 BODY L1876 (실측 PASS(마스킹)) |  | 구현 |
| EV-031 | [C24] Exception — 값이 있고 UPPER(값) 이 'Y'/'N' 이 아님 → `Invalid EXCEPTION.` | PKG_DMF0074 BODY L1899 (실측 PASS(정정 후)) |  | 구현 |
| EV-032 | [C26] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Ni — Key_Ni 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Ni : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항 | PKG_DMF0074 BODY L1942 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-033 | [C27] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Co — Key_Co 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Co : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항 | PKG_DMF0074 BODY L1973 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-034 | [C28] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Li2CO3 — Key_Li2CO3 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Li2CO3 : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (F | PKG_DMF0074 BODY L2004 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-035 | [C29] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_LIOH — Key_LIOH 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - LIOH : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼 | PKG_DMF0074 BODY L2035 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-036 | [C30] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Al — Key_Al 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Al : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항 | PKG_DMF0074 BODY L2066 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-037 | [C31] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Mn — Key_Mn 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Mn : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항 | PKG_DMF0074 BODY L2097 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-038 | [C32] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Cu — Key_Cu 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨 → `NEED EMPTY VALUE - Cu : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항 | PKG_DMF0074 BODY L2128 (실측 미검증) | 동일 패턴 형제 블록 — 케이스 미구성 | 구현 |
| EV-039 | [C33] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Ni — Key_Ni 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Ni : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2173 (실측 PASS(Ni)) |  | 구현 |
| EV-040 | [C34] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Co — Key_Co 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Co : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2203 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-041 | [C35] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Li2CO3 — Key_Li2CO3 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Li2CO3 : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2233 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-042 | [C36] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_LIOH — Key_LIOH 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL LIOH : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2263 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-043 | [C37] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Al — Key_Al 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Al : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2293 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-044 | [C38] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Mn — Key_Mn 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Mn : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2323 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-045 | [C39] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_Cu — Key_Cu 가 유효코드인데 5개 값 중 하나라도 공란 → `NULL Cu : (Period(Fr)/Period(To)/Contract Price/Change Price/Metal Index (Fr) 중 먼저 걸린 항목명)` | PKG_DMF0074 BODY L2353 (실측 미검증(동일 패턴)) | [PJ2024-50461] 81 사업부는 광물 미입력 체크 제외 | 구현 |
| EV-046 | [C40] PeriodFr/To·ContractPrice·ChangePrice·MetalIndex 전 35열 — 값이 있으나 숫자 형식(^-?[0-9]+(\.[0-9]+)?$) 아님 → `Invalid NUMERIC.` | PKG_DMF0074 BODY L2395 (실측 PASS) |  | 구현 |
| EV-047 | [C41] PeriodFr/To·ContractPrice·ChangePrice 28열 — 숫자이지만 음수 → `Negative Number.` | PKG_DMF0074 BODY L2455 (실측 PASS) |  | 구현 |
| EV-048 | [C42] PeriodFr/To 14열 — 12 초과이거나 소수점 포함 → `Invalid INTEGER 0 ~ 12.` | PKG_DMF0074 BODY L2509 (실측 PASS) |  | 구현 |
| EV-049 | [C43] PeriodFr_* / PeriodTo_* 7쌍 — PeriodFr <= PeriodTo (From 이 To 보다 크지 않음) → `From Value must be larger than To Value.` | PKG_DMF0074 BODY L2554 (실측 PASS) |  | 구현 |
