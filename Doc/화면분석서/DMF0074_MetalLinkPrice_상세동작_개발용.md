# DMF0074 Metal Link Price (메탈 판가 연동) — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS `GSCM.DM.Forms.UIL\Plan\DMF0074_MetalLinkPrice\DMF0074_MetalLinkPrice.cs` (**실측 760줄**) + `.Designer.cs` (**1,079줄**) 전수 Read.
> ⚠ **줄수 정정 (실측)**: 일부 자료에 "601줄" 로 기재된 것은 **공백 제외 라인 카운트**(PowerShell `Measure-Object -Line` 이 빈 줄을 세지 않음)이며, **물리 라인 = 760**. `Doc\_legacy_source\...\DMF0074_MetalLinkPrice.cs`(601 로 집계됐던 사본)와 GSCM 정본은 **SHA-256 해시 동일**(바이트 동일 파일, LF 760개). 기존 분석 MD(`Doc\_analysis\domain_DM\screens\DMF0074_MetalLinkPrice\*.md`)의 "760줄" 기재가 **정확**함. 전용 팝업도 동일 사유 — 물리 347줄(공백 제외 277).
> **화면 ID / 시트**: `DMF0074` / 그리드 시트명 = **"Metal Link Price"** (`SpdSheet.shtMain` L61). 단계 = **DM(Demand) / Plan**. 2024-07-03 KJJ 신규(메탈 판가 연동), 2024-10-25 [PJ2024-50611] 소형(40) 이동계획 확산 반영. 네임스페이스는 `GSCM.DM.Plan.UIL`(파일 위치는 Forms.UIL — 역대 최소급 초경량 화면).
> **전용 팝업 1종**: `GSCM.DM.Plan.UIL\POPUP\DMF0074_MetalLinkPricePopup.cs`(347줄 — 템플릿 다운로드, division 파라미터) — §4-D 정독 상세. **공용 팝업 4종(호출 계약만)**: `SCM0002_ProjectbyDivisionPopupEx`(L639) / `DM0002_ItembyDivisionPopupEx`(L663) / `DMF0073_VersionBySalesPricePopup`(L682) / `ExcelUploadForm`(L728 — ⭐ DIV=40 시 formId `'DMF0074_40'`).
> **데이터 접근**: 레거시 FoxData. 핵심 엔드포인트 — `DM.DMF0074_GET_METAL_LINK_PRICE`(조회 10 param, FindData L443) / `DM.DMF0000_GET_COMMON_SPREAD_TITLE`(동적 2단 헤더 6 param, GetSpdTitle L745) / (팝업) `DM.DMF0074_GET_METAL_LINK_TEMPLATE`(1 param) / (업로드) `P_DMF0074_EXCEL_UPLOAD`(4 param + OUT). 콤보 chain = `DataService.GetDMInnerTable` 7종(SetChangeControl L100-159). **TO-BE 정본 = `PKG_DMF0074`**(사내 DB **VALID** 실측, 3 SP — `To-be_v2_converted\06_Packages\04_Package_PKG_DMF0074.sql` 4,049줄).
> **범위**: 화면 이벤트/액션 **21 전수**(배선 핸들러 11 + BaseForm override 6 + 헬퍼 4) + 팝업 흐름 **5**.
> **화면 특성 = 조회 전용 + Excel Upload 저장**: 그리드 편집/직접 SAVE **없음**(Insert/Delete/Edit/Save override 전부 빈 몸체 L296-310, 조회 직후 전 컬럼 잠금 L466). 저장 경로는 **Excel Upload 단일**(공용 `ExcelUploadForm` → `SCM_ADM_EXCEL_UPLOAD` 스테이징 → `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD`). 버킷 = 월(`PLAN_YYYYMM`) PIVOT + Measure 4(CONTRACT_UNIT_PRICE / METAL_APPLY_UNIT_PRICE / METAL_REQR_QTY / ENERGY), 헤더 2단(`CreateSheetHeaderColumn(siMain, 2, dtTitle)`).
> **편집제어 = 단일 division-gate (§2)**: TO-BE GET SP 가 `SCM_ADM_USER_MNU_EDIT_AUTH_V` **INNER JOIN**(PKG 실측 **L452** 본조회 / **L837** 템플릿 — ※ 구자료의 L452/837 은 구버전 라인)으로 행을 하드 필터하고 `EDIT_YN` 을 컬럼으로 반환. EDIT_FLAG·ADMIN 판정·시간락 **없음**.

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본 요지는 §6.

---

## 1. 이벤트 · 액션 상세 (21)

> 배선 실측 — Designer 배선 7: `clbEndCustomer.SelectedIndexChanged`(Designer L198) / `clbTeam.SelectedIndexChanged`(L238) / `btnExcelUpload.Click`(L278, Text "Upload") / `btmItem.Click`(L421) / `btnProject.Click`(L457) / `btnSPVer.Click`(L639) / `btnTemplate.Click`(L680, Text "Excel Form"). 코드 배선 4: `this.Load += Form_Load`(ctor L80) / `txtProject.KeyDown`(L247) / `txtItemId.KeyDown`(L248) / `clbDivisions.SelectedIndexChanged`(L249). **clbScmSite / clbPlantSite 는 change 핸들러 없음**(값만 수집). 그리드 spdMain 배선 이벤트 **0**(CellDoubleClick/Changed 등 전무 — 조회 전용).

### ▣ 초기화

#### [1] ctor `DMF0074_MetalLinkPrice()`
- **트리거**: 인스턴스 생성  ·  **소스라인**: `75-81`
- **실제 동작 (실측)**: ① `InitializeComponent()`(77) → ② `this.Load += Form_Load`(80) 배선

#### [2] Form_Load
- **트리거**: Form load  ·  **소스라인**: `83-91`  ·  **호출 메서드**: `new CControl(this)`(85), `InitForm`(BaseForm, 86), `InitControls`(87), `CreateSpread`(88), `DefineProperty`(89), `InitEvent`(90 — **빈 몸체** L284-286)
- **실제 동작 (실측)**: clsCtrl 생성 → InitForm → InitControls → CreateSpread → DefineProperty → InitEvent(no-op) 순차. **자동 조회 없음**(사용자 Find 필요)

#### [3] InitControls — 콤보 chain 초기 적재
- **트리거**: Form_Load 내부  ·  **소스라인**: `164-223`  ·  **호출 메서드**: `SetChangeControl`(→[19]), `clsCtrl.setListBox`, `CString.GetCheckedListValue`, `Data.Common(Data.Type.UpperDeptId)`(176)
- **데이터/SP**: `MyDivision` / `UserTeamByDivision` / `EndCustomerByDivision` / `BizType` / `UserSiteByEndCustomer` / `UserPlantSiteByEndCustomer` (모두 `DataService.GetDMInnerTable`)
- **Division 분기**: `sDivision.Substring(0,2)=="81" || sDivision=="82"`(183) → Project/PlantSite 라벨·버튼 **활성**(190-192) / 그 외(40 등) → **비활성** + `txtProject`·`clbPlantSite` clear(202-207). `sDivision.IndexOf("81")!=-1`(215) → `UserPlantSiteByEndCustomer` chain 으로 clbPlantSite 적재(217-218)
- **실제 동작 (실측)**:

    ① 기간 기본값: `drpPeriodMonth.MonthText1 = 당월` / `MonthText2 = +6개월`(167-168)
    ② `SetChangeControl("MyDivision")`(171) → `setListBox(dtDivision, clbDivisions, false)`(172) → `dtDepartment = Data.Common(UpperDeptId, ...)`(176, ⚠ **이후 미사용**)
    ③ `UserTeamByDivision`(178-179) → Team 적재 → **81*/82 분기**(183-208): EndCustomer 적재 + `BizType` 적재(⚠ dtBizType **바인딩 대상 컨트롤 없음** — 호출만) + Project/PlantSite 활성/비활성
    ④ `UserSiteByEndCustomer`(212-213) → Sales Site 적재 → 81* 이면 PlantSite chain(215-219)
    ⑤ **`txtVersion.Text = "Current"`**(222, 버전 기본값 — 조회 필수키)

#### [4] DefineProperty
- **트리거**: Form_Load 내부  ·  **소스라인**: `243-250`
- **실제 동작 (실측)**: ① **`clbDivisions.ControlValues = "ALL"`**(245 — 단일선택 UsrCombo 초기값) → ② `txtProject.KeyDown`(247)·`txtItemId.KeyDown`(248)·`clbDivisions.SelectedIndexChanged`(249) 코드 배선

#### [5] CreateSpread / InitSpread — 동적 2단 PIVOT 헤더
- **트리거**: Form_Load 내부 (+ 조회[11]·Division 변경[6] 시 InitSpread 재호출)  ·  **소스라인**: `CreateSpread 268-275 / InitSpread 277-282 / GetSpdTitle 739-757`
- **데이터/SP**: `DM.DMF0000_GET_COMMON_SPREAD_TITLE` — **6 param**: `p_start_yyyymmdd=""` / `p_end_yyyymmdd=""` / `p_created_by`(UserId) / `p_program_id="DMF0074"` / `p_sheet_name`("Metal Link Price") / `p_division_id`(현재 Division) — **[PJ2024-50611] UI Category 에 적용된 사업부별 컬럼 헤더**
- **실제 동작 (실측)**: ① `AddSheet(spdMain, "Metal Link Price", ..., 2, 1, 30)`(270 — **헤더 2단** + 데이터폭 30) → siMain 확보 → ChangeSheet → ② InitSpread: `dtTitle = GetSpdTitle(...)`(279) → **`siMain.CreateSheetHeaderColumn(siMain, 2, dtTitle)`**(280 — dtTitle 기반 동적 컬럼 생성. 구 `SetSheetHeaderColumn` 은 주석 281)

### ▣ 조회조건 cascade

#### [6] clbDivisions_SelectedIndexChanged  ⭐ Division 전환 (코드 배선 L249)
- **소스라인**: `501-604`  ·  **호출 메서드**: `SetChangeControl`(5종), `clsCtrl.setListBox`, `InitSpread`, `DataService.FP_Log2`
- **Division 분기**: `sDivision.Substring(0,2)=="81" || sDivision=="82"`(523) / `sDivision.IndexOf("81")!=-1`(533) / `sDivision=="82"`(540 — [C20200612-000174])
- **실제 동작 (실측)**:

    ① `blnWork` 가드(506-510, **메시지 없이 silent return** — MSG00137 주석 처리) → `blnWork=true`(512) → `FP_Log2("SpeedUp", "DMF0020", "division_id_changed", "start")`(514, ⚠ 프로그램 라벨이 **"DMF0020" 오기** — DMF0020 에서 복사된 잔재)
    ② `UserTeamByDivision` 재적재(517-518) → **81*/82 분기**(523-548): `EndCustomerByDivision`(sTeam 전달) + `BizType` + Project 활성(530-531); `81*` 이면 `UserPlantSiteByEndCustomer` chain(533-537); **`82` 이면 PlantSite 비활성 + clear**(540-544), 아니면 활성(546-548)
    ③ else(그 외 사업부, 550-563): EndCustomer(raw ControlValues 전달) + BizType + **Project/PlantSite 비활성 + clbPlantSite clear**
    ④ `sEndCustomer = GetCheckedListValue(dtCustomer, ...)`(565, ⚠ **`dtCustomer` 는 전 구간 미적재(항상 null)** — `dtEndCustomer` 를 써야 할 자리. FE 변환 시 dtEndCustomer 기준 매핑) → `UserSiteByEndCustomer` 재적재(567-568)
    ⑤ `txtProject`/`txtItemId`/`txtVersion` **모두 clear**(572-574 — Division 바뀌면 버전 무효, "Current" 재입력 아님 **빈값**) → `InitSpread()`(576, 사업부별 헤더 재생성)
    ⑥ L578-593: "81 사업부만 Upload/Template 버튼 표시" 로직은 **전량 주석**(현행 = 항상 표시) → finally `blnWork=false`(600-603)

#### [7] clbTeam_SelectedIndexChanged (Designer L238)
- **소스라인**: `606-624`
- **실제 동작 (실측)**: ① `clbDivisions.SelectedValue` 앞 2자리 =="81" 또는 =="82"(611) → `EndCustomerByDivision(sDivision, sTeam)` / else `(sDivision, clbTeam.ControlValues)`(617) → EndCustomer 재적재(619) → ② `sEndCustomer = GetCheckedListValue(dtCustomer, ...)`(620, ⚠ 동일 null 버그) → `UserSiteByEndCustomer`(622-623) 로 Sales Site 재적재

#### [8] clbEndCustomer_SelectedIndexChanged (Designer L198)
- **소스라인**: `626-630`
- **실제 동작 (실측)**: `UserSiteByEndCustomer(clbDivisions.ControlValues, "", clbEndCustomer.ControlValues)`(628) → Sales Site 재적재(629). PlantSite chain 재호출은 **없음**(Division 변경 시에만)

#### [9] txtProject_KeyDown (코드 배선 L247)
- **소스라인**: `252-258`  ·  Enter 입력 시 `btnProject_Click(null, null)`(256) 호출 — 팝업 열기와 동일

#### [10] txtItemId_KeyDown (코드 배선 L248)
- **소스라인**: `260-266`  ·  Enter 입력 시 `btmItem_Click(null, null)`(264) 호출

### ▣ CRUD 버튼 (BaseForm override)

#### [11] FindButton (override) → FindData()  ⭐ 메인 조회
- **트리거**: Find toolbar / F5  ·  **소스라인**: `291-294(override) / FindData 361-495 (async void)`
- **데이터/SP**: `DM.DMF0074_GET_METAL_LINK_PRICE` — **10 param**(443-457): `p_division_id`(dtDivision 매핑값) / `p_dept_id` / `p_end_customer` / `p_scm_site_id` / `p_project_code` / `p_item_id` / `p_plant_site_id` / `p_from_yyyymmdd`·`p_to_yyyymmdd`(MonthText "-" 제거 = YYYYMM) / `p_version_type`. **CommandTimeout 10분**(445). TO-BE = `PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE`(+`P_USER_ID`/`P_MENU_ID` 자동, dual OUT `O_RC1`(데이터)+`O_RESULT_CURSOR`(성공 JSON))
- **MSG**: MSG00137 / MSG00283 / MSG00002 / MSG00049 / MSG00108 / MSG00097 (→ §5 실측 대사)
- **실제 동작 (실측)**:

    ① **Validation 6종 순차**(→§5): `blnWork` 이중실행 가드 **MSG00137**(370) → 버전 공란 **MSG00283**(377) → `blnWork=true`(382) → 기간 공란 **MSG00002 {"Plan Date"}**(387) → 날짜 파싱 실패 **MSG00049**(397) → 시작>종료 **MSG00108**(403) → Division 공란 **MSG00097**(421). ⚠ MSG00283/00002/00049/00108 return 경로는 `blnWork` 원복이 finally(491)에서만 — 377 은 `blnWork=true` 이전이라 안전
    ② `CanModelChange=false`(425) → ProgressForm 표시(426) → **`InitSpread()`**(428, 사업부별 헤더 재생성) → `SearchStartTime()`(432)
    ③ `FoxAsyncProxy.ExecuteAsync` 로 `DM.DMF0074_GET_METAL_LINK_PRICE` 호출(436-463) → `siMain.Query(ds)`(465)
    ④ **`siMain.LockColumn(0, GetMaxColumnIndex(), true)`**(466 — **전 컬럼 잠금 = 조회 전용 그리드**) → `SearchEndTime()`(467) → **`siMain.SmartColMerge()`**(469 — 좌측 dimension 세로 자동 머지) → `UIEndTime()`(472) → `CanModelChange=true` + `blnWork=false`(474-476)
    ⑤ catch: `GMessageBoxForException`(480) + `blnWork=false` + `this.Visible` 이면 rethrow(485-486); finally: `CanModelChange=true`/`blnWork=false`/`prg.Close()`(488-493)

#### [12] Insert / Delete / Edit / Save Button (override 4종) — **전부 빈 몸체**
- **소스라인**: `296-310`  ·  **실제 동작 (실측)**: no-op. **이 화면은 그리드 편집·행추가·직접 저장이 없음** — TO-BE 공통버튼 hotkeyConfig 에서 insert/delete/save(+edit) **hidden** 처리 대상

#### [13] ExcelButton (override) — Excel 다운로드
- **트리거**: Excel toolbar / F12  ·  **소스라인**: `312-356`
- **실제 동작 (실측)**: ① `SimpleExcelExportOption` 구성(314-328: Merge=None / Border=All / AheadZero=Hide·AmendZero=Show / NullToZero=false / `AmendDecimalFormat="#,##0;[Red]-#,##0"`) → ② `SimplexelService.ExportFpSpread(fps, exportOption)`(337, 파일명 `DMF0074_MetalLinkPrice_{yyyyMMddHHmmss}.xlsx`) → finally `MessageService.CloseProgress()`(346)

### ▣ 액션 버튼 (팝업 5)

#### [14] btnProject_Click — Project 선택 팝업 (Designer L457)
- **소스라인**: `632-651`  ·  **팝업**: `SCM0002_ProjectbyDivisionPopupEx` (→ §4-A)
- **실제 동작 (실측)**: ① Division(매핑값)/Team/EndCustomer/ScmSite/현재 Project 수집(634-638) → `popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject)`(640) → CenterParent 모달(641-642) → ② `popProject.ProjectCode != ""` 이면 `txtProject.Text = ProjectCode`(647-650, 빈 반환 시 기존값 유지)

#### [15] btmItem_Click — Item(Model) 선택 팝업 (Designer L421)
- **소스라인**: `653-671`  ·  **팝업**: `DM0002_ItembyDivisionPopupEx` (→ §4-B)
- **실제 동작 (실측)**: ① Division/Team/EndCustomer/Project/ScmSite/현재 ItemId 수집(656-661) → `popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId)`(666) 모달 → ② **`txtItemId.Text = popItem.ItemID`**(670 — [14]와 달리 **무조건 대입**: 취소 시 빈값으로 덮일 수 있음, AS-IS 동작 그대로)

#### [16] btnSPVer_Click — 버전 선택 팝업 (Designer L639)
- **소스라인**: `673-702`  ·  **팝업**: `DMF0073_VersionBySalesPricePopup` (→ §4-C)  ·  **MSG**: MSG00255
- **실제 동작 (실측)**: ① `Data.MultiTimeZone(TimeZone)` 기준 오늘 ±3개월 = sStartDate/sEndDate(678-680) → `popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate)`(683 — **버전유형 "SP" 고정** = Sales Price 버전) 모달 → ② `sVersions != ""` 이면 콤마 split(689): **길이 > 2 → MSG00255 후 미반영 return**(690-694, 버전 최대 2개) / else `txtVersion.Text = sVersions`(697)

#### [17] btnTemplate_Click — 템플릿 다운로드 전용 팝업 (Designer L680, Text "Excel Form")
- **소스라인**: `704-713`  ·  **팝업**: `DMF0074_MetalLinkPricePopup` (→ §4-D 정독)
- **실제 동작 (실측)**: ① 구 방식 `MenuEtcFileDownButton("DMF0074_MetalLinkPrice_Templete.xlsx")` 은 **주석**(707 — 정적 파일 다운로드 폐기) → ② `new DMF0074_MetalLinkPricePopup(현재 Division 매핑값)`(710) CenterParent 모달(711-712). 반환값 사용 없음(팝업 내부에서 Excel 저장 완결)

#### [18] btnExcelUpload_Click  ⭐ 저장 유일 경로 (Designer L278, Text "Upload")
- **소스라인**: `715-737`  ·  **팝업**: `ExcelUploadForm` (→ §4-E)  ·  **MSG**: MSG00265
- **Division 분기**: **`현재 Division == "40"` 이면 `strForm = "DMF0074_40"`**(721-726, [PJ2024-50611] 소형 전용 업로드 폼 ID — 컬럼 카탈로그가 다름) / 그 외 `"DMF0074"`
- **실제 동작 (실측)**: ① formId 결정(721-726) → `new ExcelUploadForm(strForm, spdMain.ActiveSheet.SheetName)`(728) → **`frm.SaveExceptError = true`**(729 — 오류 행 제외하고 정상 행만 저장) → CenterParent 모달(730-731) → ② 닫힌 후 **MSG00265 confirm(Yes/No)**(733) → **Yes 면 `FindData()` 재조회**(735)

### ▣ 내부 헬퍼 (호출메서드 1-depth)

#### [19] SetChangeControl (FILTER_PART)
- **소스라인**: `100-159`  ·  **SP**: `DataService.GetDMInnerTable(트리거명, Filter)` — Filter 공통키 `GROUP_ID`/`USER_ID`(102-103)
- **케이스 7**: `MyDivision`(→dtDivision) / `UserTeamByDivision`(+DIVISION_ID→dtTeam) / `EndCustomerByDivision`(+DIVISION_ID,DEPT_ID→dtEndCustomer) / `BizType`(+DIVISION_ID→dtBizType, ⚠ 결과 미사용) / `UserSiteByEndCustomer`(+DIVISION_ID,DEPT_ID,END_CUSTOMER→dtSalesSite) / `UserPlantSiteByDivision`(→dtPlantSite, ⚠ **호출부 없음 — dead case**) / `UserPlantSiteByEndCustomer`(+DIVISION_ID,END_CUSTOMER→dtPlantSiteByEndCustomer, 81* 전용)

#### [20] GetSpdTitle
- **소스라인**: `739-757`  ·  **SP**: `DM.DMF0000_GET_COMMON_SPREAD_TITLE`(6 param — [5] 참조). InitSpread 가 유일 호출처

#### [21] GetDayRange — ⚠ **미호출 dead code**
- **소스라인**: `225-239`  ·  **SP**: `DM.PR_GET_DAY_RANGE`(p_created_by, p_month=6) — 본문 어디서도 호출하지 않음. **TO-BE 이관 불필요**(API_M 등록 대상 아님). ※ 기존 `source_links.md` 의 "실호출 4건" 집계에는 포함되어 있으나 실제 런타임 도달 불가

> ※ **비활성/미사용 멤버 총정리**: `InitEvent`(빈) / `GetDayRange`(미호출) / `dtDepartment`(적재만) / `dtBizType`(적재만) / `dtPlantSite`+`UserPlantSiteByDivision` case(dead) / `dtCustomer`(**선언만, 항상 null — L565·620 에서 참조되는 잠재 버그**) / L578-593 Upload 버튼 가시성 분기(주석) / `DefColumns` struct(빈 — 동적 PIVOT). 우클릭 컨텍스트 메뉴·그리드 이벤트 없음.

---

## 2. ⭐ 편집제어(단일 division-gate) + 저장 구조 (FE 구현 판정 로직)

### 2.1 편집제어 — AS-IS 는 "전체 잠금", TO-BE 는 "행 하드필터 + EDIT_YN"

| 층 | AS-IS (화면) | TO-BE (PKG_DMF0074 실측) |
|---|---|---|
| 그리드 잠금 | 조회 직후 `LockColumn(0, max, true)`(L466) — **전 셀 읽기전용**. EditButton 빈 몸체 → 편집 진입 자체 없음 | FE 도 동일: 그리드 전 셀 읽기전용 유지 |
| 행 필터 | (없음 — WinForms 는 SP 결과 그대로) | **`INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY ON EDY.USER_ID=P_USER_ID AND EDY.MNU_ID=P_MENU_ID AND EDY.UNIT_ID=행.DIVISION_ID`** — 본조회 PKG **L452**, 템플릿 **L837**. 사용자×메뉴×사업부 권한 행이 뷰에 없으면 **해당 사업부 행이 결과에서 통째로 탈락**(hard filter) |
| EDIT_YN | (없음) | 두 커서 모두 `EDY.EDIT_YN` 을 마지막 컬럼으로 반환(L525 / L910·927) |
| EDIT_FLAG / ADMIN / 시간락 | **없음** | **없음** — DMF0044 류의 행별 EDIT_FLAG·Measure·현재월 분기 게이트가 이 화면에는 존재하지 않음 |

**FE 구현 판정 로직 (명문화)**:
1. 그리드는 **항상 읽기전용**(셀 편집 UI 없음). `EDIT_YN` 으로 셀을 여는 로직을 만들지 말 것 — AS-IS 에 대응 동작이 없다.
2. `EDIT_YN` 의 실효 용도 = **Upload/Excel Form 버튼 활성 판단 근거**(해당 Division 에 편집권한 'Y' 인 사용자만 업로드 수행이 의미 있음) + 데이터 표시용. 행 접근 통제는 SP 의 INNER JOIN 이 이미 수행하므로 FE 중복 필터 불요.
3. 조회 파라미터에 `P_USER_ID`/`P_MENU_ID` 가 반드시 실려야 행 필터가 동작(BE 가 sesUserId/mnuId 자동 주입 — PROC_M 시그니처에 포함 필수).

### 2.2 저장 구조 — 그리드 직접 SAVE 없음, Excel Upload 단일 경로

```
① [Upload 버튼 L715] Division==40 ? formId='DMF0074_40' : 'DMF0074' (L721-726)
② [공용 ExcelUploadForm] 파일 선택·파싱 → SCM_ADM_EXCEL_UPLOAD 스테이징 적재 (SaveExceptError=true L729: 오류행 제외 저장)
③ [PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD] (P_MODE, P_CREATED_BY, P_PROGRAM_ID, P_SHEET_NAME, O_RESULT_CURSOR) — PKG L965-4040 실측:
   ③-1 GTT TRUNCATE: GT_DM74_TMP_METAL_LINK_PRICE (L1046, EXECUTE IMMEDIATE)  ⚠ 아래 위험 참조
   ③-2 P_MODE=0(검증): SCM_ADM_EXCEL_UPLOAD 스테이징 행 검증 → 오류 행 UPDATE 로 ERROR 마킹 (L1153-1204~)
   ③-3 P_MODE>0(본처리): 스테이징 → GT_DM74_TMP_EXCEL_UPLOAD_FINAL MERGE(L3107) → GT_DM74_TMP_METAL_LINK_PRICE INSERT(L3687)
        → MERGE INTO DM_BPS_METAL_LINK_PRICE(L3837-) + 이력 INSERT INTO DM_BPS_METAL_LINK_PRICE_H(L3940-)
④ [화면 복귀] MSG00265 confirm → Yes 시 FindData() 재조회 (L733-736)
```

- ⚠ **PKG 내부 `EXECUTE IMMEDIATE 'TRUNCATE TABLE ...GTT'`** 가 GET(L153)·UPLOAD(L1046) 양쪽에 존재. 주석은 "이 시점 이전 일반 테이블 DML 없음 → TRUNCATE" 라 하나, **동시 세션 mutex 경합 hang 위험**(DMF0014 Excel Upload Lock 사고 동형 — hook `sp-gtt-truncate-mutex-contention`). TO-BE 적용 전 DELETE 전환 검토 의무.
- 테이블: `DM_BPS_METAL_LINK_PRICE`(Current 마스터) / `DM_BPS_METAL_LINK_PRICE_C`(버전 이력 — 조회 HISTORY 분기 원천) / `DM_BPS_METAL_LINK_PRICE_H`(업로드 이력).

### 2.3 조회 SP 버전 분기 (PKG 실측)

- `P_VERSION_TYPE LIKE '%CURRENT%'`(L158) → `DM_BPS_METAL_LINK_PRICE`(Current)에서 GTT 적재 / **ELSE**(L263) → `DM_BPS_METAL_LINK_PRICE_C` + `VERSION_NO IN (콤마 토큰에서 "(...)" suffix 제거한 버전들)`(L366-379)
- DIV=40 특칙: `SITE_ITEM` 조인·END_CUSTOMER 필터에서 **`DIVISION_ID='40' 이면 END_CUSTOMER↔PROJECT_CODE 를 맞바꿔 비교**(L201·246 외) — 소형은 Project 개념을 End Customer 로 대체
- O_RC1 = 월 PIVOT 결과(BASE 14 컬럼 + FROM/TO_PERIOD·CONTRACT_UNIT·METAL_APPLY·METAL_REQR 각 1~7 + **EDIT_YN**), 광물 7종(Ni/Co/Li2Co3/LIOH/Al/Mn/Cu) 키값은 `SCM_ADM_LOOKUP_MASTER_DETAIL 'METAL_KEY_VALUE'` LEFT JOIN(L538-565). O_RESULT_CURSOR = `'0'/'SUCCESS'` JSON(L575-576)

---

## 3. 버튼 · 컨트롤 인벤토리 — AS-IS 실측

### 3.1 버튼 (7 = toolbar 유효 2 + 화면 5)

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/분기 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find (toolbar) | toolbar | FindData(): 검증 6 + async 조회 + 전체잠금 + SmartColMerge | DM.DMF0074_GET_METAL_LINK_PRICE | MSG00137/00283/00002/00049/00108/00097 | Always | 291-294 / 361-495 |
| 2 | Excel (toolbar) | toolbar | SimplexelService Export | (로컬) | — | Always | 312-356 |
| — | Insert/Delete/Edit/Save (toolbar) | toolbar | **빈 override (기능 없음)** | — | — | TO-BE hidden | 296-310 |
| 3 | btnProject '...' | 조회조건 | Project 팝업 → txtProject | SCM0002_ProjectbyDivisionPopupEx | — | **81*/82 만 활성** | 457(D) / 632-651 |
| 4 | btmItem '...' | 조회조건 | Item 팝업 → txtItemId | DM0002_ItembyDivisionPopupEx | — | Always | 421(D) / 653-671 |
| 5 | btnSPVer '...' | Version 필드 | 버전 팝업(SP, ±3개월) → txtVersion (최대 2개) | DMF0073_VersionBySalesPricePopup | MSG00255 | Always | 639(D) / 673-702 |
| 6 | btnTemplate 'Excel Form' | 조회조건 우측 | 템플릿 다운로드 전용 팝업 | DMF0074_MetalLinkPricePopup | — | Always (81 한정 로직 주석) | 680(D) / 704-713 |
| 7 | btnExcelUpload 'Upload' | 조회조건 우측 | Excel 업로드(스테이징→SP) → confirm 재조회 | ExcelUploadForm → P_DMF0074_EXCEL_UPLOAD | MSG00265 | Always; **DIV=40 → formId 'DMF0074_40'** | 278(D) / 715-737 |

### 3.2 조회조건 컨트롤 (9)

| # | 컨트롤 | 라벨(Designer) | 유형 | 기본값/소스 | Cascade/분기 | 라인(Designer) |
|---|---|---|---|---|---|---|
| 1 | clbDivisions | Division | **UsrCombo 단일선택**(DropDownList) | MyDivision; 초기 "ALL"(L245) | SIC(코드 L249) → 콤보 5종 reset + Project/PlantSite 활성 분기 + 버전 clear + InitSpread | 537-569 |
| 2 | clbTeam | Team | UsrCheckedList (ALL) | UserTeamByDivision | SIC(D L238) → EndCustomer/SalesSite reset | 200-238 |
| 3 | clbEndCustomer | End Customer | UsrCheckedList (ALL) | EndCustomerByDivision | SIC(D L198) → SalesSite reset | 160-198 |
| 4 | clbScmSite | Sales Site | UsrCheckedList (ALL) | UserSiteByEndCustomer | 핸들러 없음 (값 수집만) | 280-317 |
| 5 | clbPlantSite | Plant Site | UsrCheckedList (ALL) | UserPlantSiteByEndCustomer (**81\* 만**) | 핸들러 없음; 82/기타 비활성+clear | 459-496 |
| 6 | txtProject (+btnProject) | Project | UsrMultiLineEditor | "" | Enter → 팝업(L247); 81*/82 만 활성 | 319-352 |
| 7 | txtItemId (+btmItem) | Model / Nickname | UsrMultiLineEditor | "" | Enter → 팝업(L248) | 353-386 |
| 8 | drpPeriodMonth | Plan Date | UsrMonthRangePicker | 당월 ~ +6개월(L167-168) | 조회 p_from/to_yyyymmdd (YYYYMM) | 498-535 |
| 9 | txtVersion (+btnSPVer) | Version | UsrMultiLineEditor | **"Current"**(L222); Division 변경 시 **""**(L574) | 조회 필수키; CURRENT vs 버전 분기 | 571-603 |

> 그리드 `spdMain`(FpSpread, 시트 "Metal Link Price", **2단 헤더** + 동적 PIVOT 30폭, Designer 931-980). BASE 좌측 고정 14 컬럼(DIVISION_ID/DEPT_ID/FCST_TYPE/SCM_SITE_ID/END_CUSTOMER/PROJECT_CODE/PROJECT_NAME/PLANT_SITE_ID/ITEM_ID/METAL_KIND_CODE/CURRENCY/METAL_EXCEPTION_YN/METAL_LINK_YN/APPLY_PRICE_TYPE_CODE) + 월별 Measure 4(CONTRACT_UNIT_PRICE/METAL_APPLY_UNIT_PRICE/METAL_REQR_QTY/ENERGY). imageList1 'edit.png'(D 982-986) 는 미사용 잔재. 폼 ClientSize 1334×623.

---

## 4. 팝업 흐름 ①→②③ (5)

### A. SCM0002_ProjectbyDivisionPopupEx — Project 선택 (btnProject, L639)
- **진입**: `Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject)`(L640) → CenterParent ShowDialog  ·  **반환**: `ProjectCode`
- **흐름**: ① Division/Team/EndCustomer/SalesSite 필터로 Project 목록 조회(팝업 내부 SP) → ② 선택 후 닫힘 → ③ `ProjectCode != ""` 일 때만 `txtProject` 반영(L647-650)  ·  **TO-BE**: `@master/components` `ProjectByDivisionModal` 재사용

### B. DM0002_ItembyDivisionPopupEx — Item(Model) 선택 (btmItem, L663)
- **진입**: `Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId)`(L666) → ShowDialog  ·  **반환**: `ItemID`
- **흐름**: ① 조건 기반 Item 목록 조회 → ② 선택/닫힘 → ③ **무조건 `txtItemId = popItem.ItemID`**(L670 — 취소 시 빈값 덮임 주의)  ·  **TO-BE**: `ItemByDivisionModal` 재사용

### C. DMF0073_VersionBySalesPricePopup — Sales Price 버전 선택 (btnSPVer, L682)
- **진입**: `Form_Load(true, "SP", sDivision, 오늘-3개월, 오늘+3개월)`(L683 — 버전유형 "SP" 고정, MultiTimeZone 기준) → ShowDialog  ·  **반환**: `sVersions`(콤마 연결)
- **흐름**: ① 기간 내 SP 버전 목록 조회(DMF0073 화면의 공용 팝업) → ② 선택(복수 가능) 닫힘 → ③ 콤마 split 길이 **> 2 → MSG00255**("버전은 최대 2개까지") 미반영 / 1~2개 → `txtVersion` 반영(L687-701). "Current" 는 수동 텍스트 상태로도 유효(기본값)  ·  **TO-BE**: DMF0020 계열 버전 모달 재사용 검토

### D. DMF0074_MetalLinkPricePopup — 템플릿 다운로드 전용 (btnTemplate, L710) ⭐ 정독 (347줄 물리 / 공백 제외 277)
- **원천**: `GSCM.DM.Plan.UIL\POPUP\DMF0074_MetalLinkPricePopup.cs`(347) + `.Designer.cs`(357). 2024-07-17 KJJ 신규, [PJ2024-50611] 사업부별 컬럼 헤더
- **진입**: `new DMF0074_MetalLinkPricePopup(pDivId)`(ctor L66-72 — division 파라미터 저장 + `Load += Form_Load`) → ShowDialog
- **흐름**:
  ① **Form_Load(L74-83)**: InitForm → InitControls(L89-101: `Data.Common(MyDivision)` 으로 자체 Division 콤보 적재 후 **부모 division 으로 선택 고정** L99) → DefineProperty(L103-107: **`IsPopup=true`** — 권한 체크 패스) → CreateSpread(L111-126: 시트 "Metal Link Price" **2단 헤더** + `DMF0000_GET_COMMON_SPREAD_TITLE`(p_program_id="DMF0074", L281-299) — 메인과 동일 카탈로그). **자동 조회 없음**(`//FindData()` 주석 L82)
  ② **Find(버튼리스트 L249-267 Find → FindButton L132-136 → FindData L159-245)**: Division 공란 → **MSG00097**(L170) → `DM.DMF0074_GET_METAL_LINK_TEMPLATE`(**p_division_id 단일 param**, timeout 10분, L197-201; TO-BE = `PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE` — `DM_MST_VERSION` 의 DIV별 **최신 SP_W 버전** 기준(PKG L666-692) `DM_PLN_SALES_PLAN_C` 로 업로드 대상 조합 생성, Measure 열은 `'-'` placeholder, **EDIT_YN 포함·EDIT_AUTH_V INNER JOIN** PKG L837) → `Query` + **전 컬럼 잠금**(L210) + `SmartColMerge`(L213) → **0건이면 MSG00427**(L229 — "이번주 Sales Plan Waterfall에 Monthly Rolling Forecast:Y인 버전이 존재하지 않습니다" ⚠ NSCM MSG_M **미등록**, §5)
  ③ **Excel(버튼리스트 → ExcelButton L301-345)**: `SimplexelService.ExportFpSpread` 로 조회 결과를 xlsx 저장 — **이 Export 가 곧 "템플릿 다운로드"**. **OK** → `mOK()`(blnOK=true) + Close(L256-259, 반환값은 호출부 미사용) / **Close** → 닫기. 보조: `spdMain_TopChange`(L274-279) 스크롤 시 SmartColMerge 재적용
- **TO-BE**: 신규 `MetalLinkTemplateModal`(조회 + xlsx 다운로드 2 액션 경량 모달)

### E. ExcelUploadForm — Excel 업로드 (btnExcelUpload, L728) ⭐ DIV=40 분기
- **진입**: `new ExcelUploadForm(strForm, sheetName)` — **`strForm = Division=="40" ? "DMF0074_40" : "DMF0074"`**(L721-726) + `SaveExceptError=true`(L729) → ShowDialog
- **흐름**: ① 공용 폼이 formId 별 컬럼 카탈로그 기준으로 파일 파싱·검증 → `SCM_ADM_EXCEL_UPLOAD` 스테이징 적재 → ② `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD` 호출(검증 P_MODE=0 → 본처리 P_MODE>0; §2.2 ③) → ③ 폼 닫힘 → **MSG00265 confirm** Yes → `FindData()` 재조회(L733-736)
- **TO-BE**: 공용 ExcelUpload 모달 재사용 + formId 분기 유지. ⚠ BE `@SystemLog` 예외 시 2회 실행 방어(SP 배치 dedup — 메모리 `feedback_be_systemlog_aspect_double_execution`) + GTT TRUNCATE→DELETE 전환 검토(§2.2)

---

## 5. Validation 6건 매핑 (MSG_M 실측 대사) + Expression 0건

### 5.1 Validation — 기존 `validation.md` 6건 대조 + **사내 MSG_M(KO) 실측 문구** (2026-07-10 ora.py)

> 기존 validation.md 는 FindData 내 6건만 집계(정확). 아래 표는 **화면 전체 GMessageBox 전수 10곳**(main 8 + popup 2)으로 확장, NSCM `SCM_ADM_MSG_M` 실문구와 대사. ⚠ **AS-IS 주석 문구 ≠ NSCM 실문구** 인 항목 3건 — MSG ID 그대로 옮기면 오문구 노출 (메모리 `feedback_msg_id_text_reconciliation`).

| # | Handler | MSG | AS-IS 의도(코드 주석) | **NSCM MSG_M 실측(KO)** | 판정 / TO-BE 매핑 | Line |
|---:|---|---|---|---|---|---:|
| 1 | FindData | MSG00137 | 연속 작업 가드 | "이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요." | ✅ 사용 (※ 구 validation.md 의 "필수 컬럼을 입력하세요" 는 **오기**) — TanStack `isFetching` 가드 | 370 |
| 2 | FindData | MSG00283 | Version 선택 후 조회 | "버전을 선택하세요." | ✅ 사용 — 조회 validator | 377 |
| 3 | FindData | MSG00002 {"Plan Date"} | "{0} 값은 필수 입력입니다" | ⚠ **"성공적으로 저장되었습니다."** (의미 전혀 다름) | ❌ **MSG00002 사용 금지** → **MSG00614** "{0} 값은 필수 입력입니다." (또는 MSG00429) 채택 | 387 |
| 4 | FindData | MSG00049 | "유효한 날짜 형식이 아닙니다. {0}" | ⚠ **미등록** (MSG_M 에 없음) | ❌ → **MSG00611** "유효한 날짜 형식이 아닙니다. (YYYYMMDD)" 채택 또는 신규 등록(4단 의무) | 397 |
| 5 | FindData | MSG00108 | 시작일자 > 종료일자 | "조회 기간이 잘못되었습니다 (시작일 > 종료일)." | ✅ 사용 — dayjs `.isAfter` | 403 |
| 6 | FindData | MSG00097 | Division 필수 | "Division 을 선택하세요." | ✅ 사용 — required validator | 421 |
| +7 | btnSPVer_Click | MSG00255 | 버전 3개 이상 선택 차단 | "버전은 최대 2개까지 선택할 수 있습니다." | ✅ 사용 (※ 코드 주석 "읽기전용" 은 오기) — 버전 모달 OK 가드 | 692 |
| +8 | btnExcelUpload_Click | MSG00265 | 업로드 후 재조회 confirm | "Excel 업로드가 완료되었습니다. 재조회합니다." | ✅ 사용 — **confirm(Yes/No)** 필요, Yes→refetch | 733 |
| +9 | (팝업 D) FindData | MSG00097 | Division 필수 | (위와 동일) | ✅ | 팝업 170 |
| +10 | (팝업 D) FindData | MSG00427 | 0건 안내(MRF:Y 버전 없음) | ⚠ **미등록** | ❌ → 신규 등록 필요("이번주 Sales Plan Waterfall에 Monthly Rolling Forecast:Y인 버전이 존재하지 않습니다") 또는 유사 MSG 대사 후 지정 | 팝업 229 |

- 예외 공통: `GMessageBoxForException`(main L480 / popup L234) → TO-BE 표준 오류 토스트 + `SCM_COM_SYS_LOG`.

### 5.2 Expression — **0건 명기**

- `expressions.md` 대조 결과 일치: SetValue Auto-Sync / SetSpreadHeaderSpan / 조건부 LockRange 류 **0건**. 조회 후 일괄 `LockColumn(0,max,true)`(L466)·`SmartColMerge()`(L469) 는 expression 이 아닌 그리드 표준 속성 — TO-BE 는 `isReadOnly` 그리드 + 좌측 dimension 세로 머지(HierarchicalMergeManager, hook #38)로 재현. PIVOT 동적 컬럼은 `visible:true` 명시(메모리 `feedback_grid_dynamic_column_visible_excel`).

---

## 6. ② User 관점 변환 요지 (시트 5 반영용)

### 6.1 화면 성격
- **Metal Link Price(메탈 판가 연동)** 는 메탈(Ni/Co/Li2Co3/LIOH/Al/Mn/Cu) 가격과 연동된 판가 정보를 **월 단위로 조회**하고, 수정은 **엑셀 업로드로만** 하는 화면. 그리드에서 직접 고치는 기능은 없다.
- 사업부에 따라 조건이 달라진다: **81 계열/82** 는 Project 검색을 쓸 수 있고, **81 계열**만 Plant Site 를 고를 수 있다(82는 잠김). **소형(40)** 은 Project 대신 End Customer 를 키로 쓰며, 엑셀 업로드 양식도 소형 전용(`DMF0074_40`)이 따로 있다.

### 6.2 조회
- 기간(당월~6개월 기본)과 **버전**(기본 "Current")을 확인하고 조회한다. 버전은 '...' 버튼으로 최근 ±3개월의 Sales Price 버전 중 **최대 2개**까지 고를 수 있다(3개 이상 고르면 안내 후 무시).
- 사업부를 바꾸면 팀→고객→사이트가 연쇄 갱신되고 Project/Model/버전 입력이 비워지므로 버전을 다시 지정해야 한다. 필수값(버전·기간·사업부)이 빠지면 각각 안내 메시지가 뜨고 조회되지 않는다.
- 조회 결과는 읽기전용이며 왼쪽 기준열은 같은 값끼리 세로로 합쳐 보인다. 내 계정에 **편집권한이 없는 사업부의 행은 아예 조회되지 않는다**(서버 권한 필터).

### 6.3 템플릿 다운로드 · 업로드
- **Excel Form**: 전용 창이 열리고, 조회를 누르면 최신 주간 Sales Plan 버전 기준의 업로드 대상 목록(사업부별 양식)이 나온다. Excel 버튼으로 내려받아 값을 채운다. 대상 버전이 없으면 "MRF:Y 버전 없음" 안내가 뜬다.
- **Upload**: 채운 파일을 업로드하면 서버가 검증 후 정상 행만 저장한다(오류 행 제외 옵션). 완료되면 "재조회합니다" 확인 후 화면이 갱신된다.

---

## 7. 격차 (TO-BE 이관 관점) — 2026-07-10 사내 DB·FE 실측

| 구분 | 내용 (전부 실측) |
|---|---|
| **FE 미개발** | `nscm-fe/features/demand/src/pages/` 실측 5 폴더(customer-fcst-upload/forecast-price/menu-templates/mkt-fcst/sales-monitoring) — **metal-link-price 부재**. `__asis-mapping__.md` 도 부재(분석 8 MD 중 asis-mapping 격차). 신규 화면 작성 필요(자매 표준 = DMF0020 SalesFuturePrice). |
| **메타 배선 0** | `SCM_ADM_API_M` **0** / `SCM_ADM_PROC_M` **0** / `SCM_ADM_MNU_BTN_MPG_M` **0** / `SCM_MST_SHEET_MEASURE` **0** (LIKE '%DMF0074%' 실측). 단 **`SCM_ADM_MNU_M` 1행 등록됨**(MNU_ID=DMF0074 / UPPR=Demand_Plan / MNU_URL=dmf0074 / UNIT_TP_CD='D' / USE_YN='Y') + **`SCM_MST_SHEET_COLUMNS` 58행 존재**(PROGRAM_ID=DMF0074, SHEET_NAME='Metal Link Price'). → API·PROC·BTN·MEASURE 4종 배선 작업 필요(hook #98). |
| **standalone SP 5종 INVALID** | 사내 실측: `DMF0074_EXCEL_UPLOAD` / `DMF0074_EXCEL_UPLOAD_KJJ_TEST` / `DMF0074_EXCEL_UPLOAD_TEST2` / `DMF0074_GET_METAL_LINK_TEMPLATE` / `P_DMF0074_GET_METAL_LINK_PRICE` = **INVALID**(standalone PROCEDURE). **정본은 `PKG_DMF0074`(spec+body VALID)** — standalone 은 변환 중간 잔재로 API_M 배선 시 절대 참조 금지. `DMF0074_GET_METAL_LINK_PRICE`(standalone) 은 VALID 이나 역시 PKG 정본 원칙. |
| **MD 줄수 오기 정정** | 지시/일부 자료의 ".cs 601줄" = **공백 제외 카운트**. 물리 실측 **760줄**(LF 760, legacy 사본과 해시 동일). 기존 분석 MD 의 760 기재가 정확 — "760 이 오기" 라는 전제가 오히려 오류. Designer 1,079(공백 제외 1,073) / 전용 팝업 347(공백 제외 277). |
| **MSG 3건 대사 함정** | MSG00002(사내 실문구="성공적으로 저장되었습니다" — 필수입력 아님 → MSG00614 대체) / MSG00049·MSG00427 **미등록**(MSG00611 대체 또는 신규 4단 등록). §5.1 전수 대사 완료. |
| **PKG GTT TRUNCATE 위험** | `PKG_DMF0074` L153(GET)·L1046(UPLOAD) `EXECUTE IMMEDIATE TRUNCATE` — 동시 세션 mutex 경합 hang 사고 동형(DMF0014). DELETE 전환 검토 후 적용 권고. |
| **AS-IS 코드 quirk (FE 재현 금지 대상)** | ① `dtCustomer` null 참조(L565·620 — dtEndCustomer 로 교정) ② `FP_Log2` 라벨 "DMF0020" 오기(L514·570) ③ `GetDayRange`/`UserPlantSiteByDivision`/`dtDepartment`/`dtBizType` dead code ④ btmItem 취소 시 txtItemId 빈값 덮임(L670) — TO-BE 는 빈 반환 시 유지로 개선 검토. |
| **공통버튼** | insert/delete/save(edit) hidden + search/excel 만 노출(hotkeyConfig). 자체 버튼 3종(Excel Form/Upload/버전)은 표준 배치(SubTitle customButtons + Version 필드 내 트리거). |

---

> **실측 근거**: 본 문서의 라인·파라미터·MSG·분기는 ① `DMF0074_MetalLinkPrice.cs`(물리 760줄, legacy 사본과 SHA-256 동일) + `.Designer.cs`(1,079줄) 전수 Read, ② 전용 팝업 `DMF0074_MetalLinkPricePopup.cs`(347줄)+Designer(357줄) 전수 Read, ③ 공용 팝업 4종 호출부 실측, ④ `PKG_DMF0074`(To-be_v2_converted, 4,049줄) 핵심부 Read + 사내 Oracle 실측(오브젝트 STATUS / MNU_M / SHEET_COLUMNS 58 / API·PROC·BTN·MEASURE 0 / MSG_M KO 실문구 — 2026-07-10 ora.py), ⑤ 기존 분석 자료 8 MD(analysis/events/validation 6/expressions 0/popup_list 5/sp_list/source_links/tobe_design) 대조 결과이며, 주석(비활성) 코드(L578-593 버튼 가시성 / L707 정적 템플릿 / GetDayRange 등)는 별도 명시하고 활성 코드만 기술함. 편집제어 단일 division-gate(EDIT_AUTH_V INNER JOIN L452·L837 + EDIT_YN)는 hook #105 §2.5-3 표준에 따라 개발자 재현 관점으로 기술함.
