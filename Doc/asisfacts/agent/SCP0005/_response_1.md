=== FILE: analysis.md ===
# SCP0005 Distribution Route — AS-IS 분석서

> 이 문서는 AsisFacts Fact Pack(정적 추출)에 있는 사실만 사용했습니다. 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0005 | Fact Pack |
| 도메인 | SCP | 엔드포인트 접두 `SCP.` 와 프로젝트 `GSCM.SCP.Forms.UIL` |
| 메인 폼 클래스 | `SCP0005_DistributionRoute` | controls.csv |
| 메인 폼 Text | `"Distribution Route"` | props.csv, Designer.cs:555 |
| 공유 팝업 클래스 | `SCP0005_DistributionRoutePopup` | controls.csv |
| 팝업 폼 Text | `"DistributionRoute History"` | props.csv, Popup.Designer.cs:99 |
| 위치 | `Master\SCP0005_DistributionRoute` (마스터 화면) | 파일 경로 |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.cs | SCP0005_DistributionRoute.csproj | 1389 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.Designer.cs | SCP0005_DistributionRoute.csproj | 619 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\Properties\AssemblyInfo.cs | SCP0005_DistributionRoute.csproj | 37 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.cs | GSCM.SCM.Popup.UIL.csproj | 192 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.Designer.cs | GSCM.SCM.Popup.UIL.csproj | 115 |
| legacy | 없음(Fact Pack 본문 기준 0건) | — | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---:|---|---|---:|---|---|---|
| 1 | event:this.Load (팝업) | `Form_Load` > FindData | 171 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | MATCH | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |
| 2 | button:FindButton (팝업) | FindButton > FindData | 171 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | MATCH | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |
| 3 | button:FindButton (메인) | FindButton > FindDataMain | 424 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | SCP0005_GET_DISTRIBUTION_ROUTE |
| 4 | button:FindButton (메인) | FindButton > FindDataReceive | 499 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` | MATCH | SCP0005_GET_DISTRIBUTION_ROUTEID |
| 5 | button:FindButton (메인) | FindButton > GetData_Country | 916 | `SCP.SCP0005_GET_COUNTRY_CITY` | MATCH | SCP0005_GET_COUNTRY_CITY |
| 6 | button:SaveButton | SaveButton > SaveData | 752 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` | MATCH | SCP0005_SAVE_DISTRIBUTION_ROUTE |
| 7 | button:SaveButton | SaveButton > SaveData > FindDataMain | 424 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | SCP0005_GET_DISTRIBUTION_ROUTE |
| 8 | event:this.btnEaxel_Upload.Click | `btnEaxel_Upload_Click` > FindDataMain | 424 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | SCP0005_GET_DISTRIBUTION_ROUTE |
| 9 | (진입점 미연결) | `<field:dtFromCountry>` | 44 | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | BIZ_MATCH | — |
| 10 | (진입점 미연결) | `<field:dtToCountry>` | 46 | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | BIZ_MATCH | — |
| 11 | (진입점 미연결) | `<field:dtYesOrNo>` | 48 | `biz:CommonData.YesOrNo` | BIZ_MATCH | — |
| 12 | (진입점 미연결) | `<field:dtTransMode>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | — |
| 13 | (진입점 미연결) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` | BIZ_MATCH | — |
| 14 | (진입점 미연결) | GetFromSitebyDivision | 1187 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | — |
| 15 | (진입점 미연결) | GetToSitebyDivision | 1195 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | — |
| 16 | (진입점 미연결) | GetBodType | 1207 | `biz:CommonData.CommonDataList` [code=BodType] | BIZ_MATCH | — |
| 17 | (진입점 미연결) | GetTransMode | 1217 | `biz:CommonData.CommonDataList` [code=TransportMode] | BIZ_MATCH | — |

참고
- 9~13번은 클래스 필드 초기화(`<field:…>`)입니다. 정적 파서는 이를 진입점에 연결하지 못했습니다. 실제 호출 시점(폼 생성 시인지 등)은 **확인 필요**입니다.
- 14~17번 메서드(GetFromSitebyDivision, GetToSitebyDivision, GetBodType, GetTransMode)는 호출하는 쪽을 찾지 못했습니다. 미사용인지, 콤보·셀 데이터 바인딩에서 간접 호출되는지는 **확인 필요**입니다.
- `btnFromSrch_Click`(350~351행)·`btnToSrch_Click`(368~369행)은 `popCity.Country`·`popCity.City` 값을 각각 txtFrom*/txtTo* TextBox 에 넣습니다. `popCity` 의 클래스와 그 팝업이 호출하는 엔드포인트는 Fact Pack 에 없어 **확인 필요**입니다.
- `btnExcel_Form_Click`·`spdMain_CellDoubleClick` 은 연결된 엔드포인트가 없습니다. 내부 동작(양식 생성, 이력 팝업 호출 여부)은 **확인 필요**입니다.
- `spdMain_CellDoubleClick` 이 공유 팝업 `SCP0005_DistributionRoutePopup`(이력 조회)을 여는지는 Fact Pack 에 직접 근거가 없어 **확인 필요**입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체(EXEC 전이 포함) / 코드분기 테이블 |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | BIZ_MATCH | 2 | — | UP_FX_GetCommonDataList: SELECT SCM_MST_COUNTRY |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | — | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | 1 | — | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP: SELECT SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | 1 | — | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP: SELECT SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT |
| `biz:CommonData.CommonDataList` [code=BodType] | BIZ_MATCH | 1 | — | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` [code=TransportMode] | BIZ_MATCH | 1 | — | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 2 | — | DB 보강 정보 없음(Data.CallBizData 경유) — **확인 필요** |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | 1 | SCP0005_GET_DISTRIBUTION_ROUTE | SELECT SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL / REF FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` | MATCH | 1 | SCP0005_GET_DISTRIBUTION_ROUTEID | SELECT SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL / REF FN_GET_LOOKUP_CODE_DESC |
| `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` | MATCH | 1 | SCP0005_SAVE_DISTRIBUTION_ROUTE | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_DISTRIBUTION_ROUTE_HIST / UPDATE·INSERT·DELETE·SELECT SCP_MST_DISTRIBUTION_ROUTE / INSERT SCM_SYS_LOG_BATCH, SCP_MST_DISTRIBUTION_ROUTE_H / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SCP.SCP0005_GET_COUNTRY_CITY` | MATCH | 1 | SCP0005_GET_COUNTRY_CITY | SELECT SCM_MST_CITY |
| `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | MATCH | 1 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | SELECT SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE_H, SCM_ADM_LOOKUP_MASTER_DETAIL / REF FN_GET_LOOKUP_CODE_DESC |

- 주석 처리된 호출(commented_calls)은 0건입니다.
- 확인 필요 항목(Fact Pack 7장)은 0건입니다.

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 위치 | 연산 | 파일 |
|---|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:98 | += | SCP0005_DistributionRoutePopup.cs (shared) |
| this | Load | `Form_Load` | .ctor:144 | += | SCP0005_DistributionRoute.cs |
| this.btnToSrch | Click | `btnToSrch_Click` | InitializeComponent:244 | += | SCP0005_DistributionRoute.Designer.cs |
| this.btnFromSrch | Click | `btnFromSrch_Click` | InitializeComponent:280 | += | SCP0005_DistributionRoute.Designer.cs |
| this.btnExcel_Form | Click | `btnExcel_Form_Click` | InitializeComponent:327 | += | SCP0005_DistributionRoute.Designer.cs |
| spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | InitEvent:187 | += | SCP0005_DistributionRoute.cs |
| this.btnEaxel_Upload | Click | `btnEaxel_Upload_Click` | InitEvent:189 | += | SCP0005_DistributionRoute.cs |
| dsdm | Changed | `spdMainDataModel_Changed` | InitEvent:192 | += | SCP0005_DistributionRoute.cs |
| dsdm | Changed | `spdMainDataModel_Changed` | spdMainDataModel_Changed:970 | -= | SCP0005_DistributionRoute.cs |
| dsdm | Changed | `spdMainDataModel_Changed` | spdMainDataModel_Changed:1082 | += | SCP0005_DistributionRoute.cs |
| dsdm | Changed | `spdMainDataModel_Changed` | spdMain_CellDoubleClick:1135 | -= | SCP0005_DistributionRoute.cs |
| dsdm | Changed | `spdMainDataModel_Changed` | spdMain_CellDoubleClick:1164 | += | SCP0005_DistributionRoute.cs |

- `spdMainDataModel_Changed` 는 자기 자신 안(970 해제 → 1082 재등록)과 `spdMain_CellDoubleClick` 안(1135 해제 → 1164 재등록)에서 핸들러를 잠시 떼었다가 다시 붙입니다. 셀 값을 바꿀 때 Changed 이벤트가 재귀로 실행되지 않게 막는 구조로 보입니다. 다만 변경하는 셀과 계산식은 **확인 필요**입니다.
- 버튼 이름 `btnEaxel_Upload` 은 원문 철자(Eaxel)를 그대로 옮겼습니다.
- 툴바 버튼 오버라이드 FindButton·SaveButton·EditButton(318행)이 있습니다(flow.csv·grid_code.csv).

## 5. 데이터 컬럼 사용 (`row["COL"]`)

| 메서드 | 줄 | 대상 | 컬럼 |
|---|---:|---|---|
| `<field:UserGroup>` | 60 | UserInfoContext.Current | NowGroupID |
| InitControls | 208 | c | ControlName |
| InitControls | 210 | ManualSearchCondition.Tables[0].Rows[0] | ControlValue |
| SaveData | 871 | dtErr.Rows[0] | ERR_MESSAGE |
| SetCityCode | 1350~1352 | drsFrom[0] | COUNTRY, CITY, CITY_NAME |
| SetCityCode | 1365~1367 | drsTo[0] | COUNTRY, CITY, CITY_NAME |

- SaveData 는 저장 결과에서 `ERR_MESSAGE` 를 읽습니다(871행). 오류 메시지를 표시하는 방식은 **확인 필요**입니다.
- `InitControls` 는 `ManualSearchCondition`(검색조건 저장본)의 ControlName/ControlValue 로 조회조건을 복원합니다. 이에 대응하는 메타는 TB_FX_SearchCondition 32행입니다.
- `SetCityCode` 의 drsFrom/drsTo 출처 DataTable 이 `GetData_Country`(SCP0005_GET_COUNTRY_CITY) 결과인지는 **확인 필요**입니다.

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

| 시트 | 화면 | 생성 | 메타 컬럼 생성 | 연결 규칙 | 표시 컬럼 수(전 division) |
|---|---|---|---|---|---:|
| Distribution Route | 메인 spdMain | AddSheet@CreateSpread:233 | SetSheetHeaderColumn@InitSpread:246 (헤더 2행) | META+코드연결 | 39 |
| POPUP | 팝업 spdMain | AddSheet@CreateSpread:122 | SetSheetHeaderColumn@InitSpread:136 (헤더 2행) | META+코드연결 | 16 |

- 코드 쪽 처리
  - 화면에 직접 정의된 `SetSpreadColumn` 을 FindDataMain:452 와 FindDataReceive:521 에서 호출합니다. 조건은 `if(ds != null && ds.Tables[0].Rows.Count > 0)` 입니다.
  - Designer.cs 515~518행(메인)과 Popup.Designer.cs 65~68행(팝업)에서 ColumnHeader 기본 스타일을 지정합니다(HorizontalAlignment/VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced).
- **division별 차이: 없음.** 14개 division(40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC)에서 Distribution Route 39컬럼, POPUP 16컬럼으로 모두 같습니다. 판단불가 분기는 0건입니다.
- 필수(USER_SELECTABLE_FLAG='N') 컬럼은 두 시트 모두 `ROUTE_ID` 하나이고, 나머지는 모두 '기본'입니다.
- 실제 SP 실행 결과와 맞춰 본 시트가 없습니다(grid 단계 미실행 또는 시트명 불일치). 메타 컬럼과 SP 출력 컬럼이 정확히 일치하는지는 **확인 필요**입니다.

## 7. 확인 필요 항목

| # | 항목 | 사유 |
|---:|---|---|
| 1 | 필드 초기화 biz 호출 5건(44·46·48·49·51행)의 실행 시점 | 정적 파서상 진입점 미연결 |
| 2 | GetFromSitebyDivision / GetToSitebyDivision / GetBodType / GetTransMode 호출 여부 | 호출자를 찾지 못함 |
| 3 | `popCity` 팝업의 클래스와 엔드포인트 | Fact Pack 에 없음 |
| 4 | `spdMain_CellDoubleClick` → 이력 팝업(SCP0005_DistributionRoutePopup) 호출 여부와 전달 파라미터 | 직접 근거 없음 |
| 5 | `btnExcel_Form_Click` 동작(양식 생성 방식) | 엔드포인트 없음. SCM_ADM_EXCEL_COLUMNS 메타 1행과의 관계도 확인 필요 |
| 6 | `btnEaxel_Upload_Click` 업로드 후 FindDataMain 을 호출하는 맥락(업로드 데이터 저장 경로) | 흐름상 조회 SP 만 연결됨 |
| 7 | FindButton 하나에서 FindDataMain / FindDataReceive / GetData_Country 3개 경로로 갈라지는 분기 조건 | 조건식이 Fact Pack 에 없음 |
| 8 | SaveButton:333 의 SaveData 호출을 4-2 표는 `PersonalSettingPopup.SaveData`(프레임워크)로 매핑함 | flow.csv 는 같은 경로를 화면 자체 SaveData(752)로 연결. 파서 매핑 충돌 |
| 9 | `CString.GetCheckedListValue`(FindDataMain:404)의 대상 컨트롤 | clbTransMode 로 추정되지만 미확인 |
| 10 | `biz:CommonData.YesOrNo` 의 데이터 출처 | DB 보강 없음 |
| 11 | `usrLayoutControl1`(657×184, parent 미지정)의 실사용 여부 | controls.csv 에 parent 가 비어 있음 |
| 12 | Grid 2단 헤더의 그룹명(From/To/Departure/Arrival 등) | 메타 ATTRIBUTE 원문이 Fact Pack 본문에 없음 |

=== FILE: source_links.md ===
# SCP0005 소스 링크 표

> 경로는 AS-IS 소스 루트(`06.UIL\…`) 기준 상대경로입니다. 줄 번호는 Fact Pack 의 정적 추출값입니다.

약칭
- **M** = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.cs`
- **MD** = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0005_DistributionRoute\SCP0005_DistributionRoute.Designer.cs`
- **P** = `06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.cs`
- **PD** = `06.UIL\GSCM.SCM.Popup.UIL\SCP0005_DistributionRoutePopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 14건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | `<field:dtFromCountry>` | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] (Data.Common → Data.CallBizCommonData) |
| M | `<field:dtToCountry>` | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| M | `<field:dtYesOrNo>` | 48 | biz:CommonData.YesOrNo (Data.Common → Data.CallBizData) |
| M | `<field:dtTransMode>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] |
| M | `<field:dtValidYN>` | 51 | biz:CommonData.YesOrNo |
| M | FindDataMain | 424 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE |
| M | FindDataReceive | 499 | SCP.SCP0005_GET_DISTRIBUTION_ROUTEID |
| M | SaveData | 752 | SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE |
| M | GetData_Country | 916 | SCP.SCP0005_GET_COUNTRY_CITY |
| M | GetFromSitebyDivision | 1187 | biz:CommonData.CommonDataList [code=FromSiteByDivision] |
| M | GetToSitebyDivision | 1195 | biz:CommonData.CommonDataList [code=ToSiteByDivision] |
| M | GetBodType | 1207 | biz:CommonData.CommonDataList [code=BodType] |
| M | GetTransMode | 1217 | biz:CommonData.CommonDataList [code=TransportMode] |
| P | FindData | 171 | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| P | .ctor | 98 | `this.Load += Form_Load` |
| M | .ctor | 144 | `this.Load += Form_Load` |
| MD | InitializeComponent | 244 | `this.btnToSrch.Click += btnToSrch_Click` |
| MD | InitializeComponent | 280 | `this.btnFromSrch.Click += btnFromSrch_Click` |
| MD | InitializeComponent | 327 | `this.btnExcel_Form.Click += btnExcel_Form_Click` |
| M | InitEvent | 187 | `spdMain.CellDoubleClick += spdMain_CellDoubleClick` |
| M | InitEvent | 189 | `this.btnEaxel_Upload.Click += btnEaxel_Upload_Click` |
| M | InitEvent | 192 | `dsdm.Changed += spdMainDataModel_Changed` |
| M | spdMainDataModel_Changed | 970 | `dsdm.Changed -= spdMainDataModel_Changed` |
| M | spdMainDataModel_Changed | 1082 | `dsdm.Changed += spdMainDataModel_Changed` |
| M | spdMain_CellDoubleClick | 1135 | `dsdm.Changed -= spdMainDataModel_Changed` |
| M | spdMain_CellDoubleClick | 1164 | `dsdm.Changed += spdMainDataModel_Changed` |

## 3. Grid 생성 / 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| P | CreateSpread | 122 | AddSheet `POPUP` (args: … ¦ POPUP ¦ POPUP ¦ 2 ¦ 1 ¦ 30) |
| P | CreateSpread | 123 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| P | CreateSpread | 125 | ChangeSheet |
| P | InitSpread | 134 | InitSheet — `if(spreadInfo.SheetName == "POPUP")` |
| P | InitSpread | 136 | SetSheetHeaderColumn(spreadInfo, 2) — 메타 컬럼 생성 |
| PD | InitializeComponent | 65~68 | ColumnHeader 기본 스타일(HorizontalAlignment/NoteIndicatorColor/Parent/VerticalAlignment) |
| M | CreateSpread | 233 | AddSheet `Distribution Route` (args: … ¦ Distribution Route ¦ Distribution Route ¦ 2 ¦ 1 ¦ 30) |
| M | CreateSpread | 234 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| M | CreateSpread | 236 | ChangeSheet |
| M | InitSpread | 245 | InitSheet — `if(spreadInfo.SheetName == "Distribution Route")` |
| M | InitSpread | 246 | SetSheetHeaderColumn(spreadInfo, 2) — 메타 컬럼 생성 |
| M | EditButton | 318 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) — `if(this.fps != null) ⟫ if(fps.Name == "spdMain")` |
| M | SaveButton | 333 | SaveData 호출(4-2 표에서 PersonalSettingPopup.SaveData 로 매핑됨 — 확인 필요) |
| M | FindDataMain | 404 | CString.GetCheckedListValue — 메타 컬럼 CODE |
| M | FindDataMain | 452 | local:SetSpreadColumn(siMain) — `if(ds != null && ds.Tables[0].Rows.Count > 0)` |
| M | FindDataReceive | 521 | local:SetSpreadColumn(siMain) — 같은 조건 |
| MD | InitializeComponent | 515~518 | ColumnHeader 기본 스타일 |

## 4. 컨트롤 값 / 데이터 컬럼 사용 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | `<field:UserGroup>` | 60 | UserInfoContext.Current["NowGroupID"] |
| M | CSafeSetText | 162 | `ctl.Text = text` |
| M | InitControls | 208 | c["ControlName"] |
| M | InitControls | 210 | ManualSearchCondition.Tables[0].Rows[0]["ControlValue"] |
| M | btnFromSrch_Click | 350 | `txtFromCountry.Text = popCity.Country` |
| M | btnFromSrch_Click | 351 | `txtFromCity.Text = popCity.City` |
| M | btnToSrch_Click | 368 | `txtToCountry.Text = popCity.Country` |
| M | btnToSrch_Click | 369 | `txtToCity.Text = popCity.City` |
| M | SaveData | 871 | dtErr.Rows[0]["ERR_MESSAGE"] |
| M | SetCityCode | 1350~1352 | drsFrom[0]["COUNTRY" / "CITY" / "CITY_NAME"] |
| M | SetCityCode | 1365~1367 | drsTo[0]["COUNTRY" / "CITY" / "CITY_NAME"] |

## 5. 컨트롤 선언 위치 (Designer)

| 파일 | 줄 | 컨트롤 | 유형 |
|---|---:|---|---|
| PD | 31 | spdMain | FarPoint.Win.Spread.FpSpread |
| PD | 32 | spdMain_Sheet1 | SheetView |
| MD | 33 | usrLayoutControl1 | UsrLayoutControl |
| MD | 34 | layoutControlGroup1 | LayoutControlGroup |
| MD | 35 | usrConditionPanel1 | UsrConditionPanel |
| MD | 36 | usrLayoutControl2 | UsrLayoutControl |
| MD | 37 | cboValidYN | UsrCombo |
| MD | 38 | clbTransMode | UsrCheckedList |
| MD | 39 | btnToSrch | UsrButton |
| MD | 40 | btnFromSrch | UsrButton |
| MD | 41~44 | txtFromCountry, txtFromCity, txtToCountry, txtToCity | TextBox |
| MD | 45 | btnEaxel_Upload | SimpleButton |
| MD | 46 | btnExcel_Form | SimpleButton |
| MD | 47~59 | layoutControlGroup2, emptySpaceItem1/4, layoutControlItem1~10 | DevExpress Layout |
| MD | 60 | spdMain | FpSpread |
| MD | 61 | spdMain_Sheet1 | SheetView |
| MD | 62 | imageList1 | ImageList |

=== FILE: web_components.md ===
# SCP0005 웹 컴포넌트 매핑 (WinForms → React/Wijmo)

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

라벨은 props.csv 의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | 1227×65, Dock Top, UsrPanelType=HidePanel | 조회조건 패널(접기/펼치기) | |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | 168×20 | ComboBox(단일 선택) | 데이터 후보: dtValidYN = biz:CommonData.YesOrNo (확인 필요) |
| clbTransMode | UsrCheckedList | `Trans Mode` (layoutControlItem4) | 149×21 | MultiSelect(체크 리스트) | GetCheckedListValue(CODE)@FindDataMain:404 — 대상 컨트롤 확인 필요 |
| txtFromCountry | TextBox | `From Country` (layoutControlItem5) | 139×25 | InputText | btnFromSrch_Click 에서 popCity.Country 로 채움 |
| txtFromCity | TextBox | `From City` (layoutControlItem2) | 142×25 | InputText | btnFromSrch_Click 에서 popCity.City 로 채움 |
| btnFromSrch | UsrButton | layoutControlItem7 Text=`"layoutControlItem6"`(원문). 버튼 자체 Text 는 Fact Pack 에 없음 | 39×25 | 검색(돋보기) 버튼 → City 팝업 | |
| txtToCountry | TextBox | `To Country` (layoutControlItem1) | 169×25 | InputText | btnToSrch_Click 에서 popCity.Country 로 채움 |
| txtToCity | TextBox | `To City` (layoutControlItem8) | 177×25 | InputText | btnToSrch_Click 에서 popCity.City 로 채움 |
| btnToSrch | UsrButton | layoutControlItem6 Text 없음. 버튼 Text 는 Fact Pack 에 없음 | 39×25 | 검색(돋보기) 버튼 → City 팝업 | |
| btnEaxel_Upload | SimpleButton | `Upload` | 76×22 | Button(Excel 업로드) | |
| btnExcel_Form | SimpleButton | `Excel Form` | 87×22 | Button(Excel 양식) | |
| spdMain (메인) | FpSpread | 시트 `Distribution Route` | 1227×492, Dock Fill | Wijmo FlexGrid | 2단 헤더 |
| spdMain (팝업) | FpSpread | 시트 `POPUP`, 폼 Text `DistributionRoute History` | 1387×589, Dock Fill | Wijmo FlexGrid(팝업 내) | 2단 헤더 |
| emptySpaceItem1 / emptySpaceItem4 | EmptySpaceItem | — | 61×29 / 783×25 | 레이아웃 여백 | |
| usrLayoutControl1 / layoutControlGroup1 | UsrLayoutControl / Group | — | 657×184 | — | parent 미지정. 실사용 여부 확인 필요 |
| imageList1 | ImageList | — | — | 아이콘 리소스 | 용도 확인 필요 |

툴바 버튼: FindButton(조회), SaveButton(저장), EditButton(318행)이 폼 오버라이드로 존재합니다(flow.csv / grid_code.csv).

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 항목 없음). 배치는 Dock 기반입니다.

| 영역 | 컨트롤 | Dock | Size | 높이 비율 |
|---|---|---|---|---|
| 상단 | usrConditionPanel1(내부 usrLayoutControl2 1227×65 Fill) | Top | 1227×65 | 65 / 557 ≈ 11.7% |
| 하단 | spdMain(Distribution Route) | Fill | 1227×492 | 492 / 557 ≈ 88.3% |

- 상/하 2단 구조이고 좌/우 분할은 없습니다. 비율은 Designer Size 값으로 계산한 것이며, 실행 시 크기는 창 크기에 따라 달라집니다.
- 조회조건 배치(layoutControlGroup2 1227×74). 각 LayoutControlItem 크기 순서이며, 정확한 행·열 좌표는 Fact Pack 에 없어 **확인 필요**입니다.
  - 1행 후보(높이 25): Valid(202) · Trans Mode(222) · emptySpaceItem4(783)
  - 2행 후보(높이 29): From Country(222) · From City(202) · [btnFromSrch](43) · To Country(240) · To City(225) · [btnToSrch](43) · Upload(80) · Excel Form(91) · emptySpaceItem1(61)
- 팝업 `SCP0005_DistributionRoutePopup`: spdMain 1387×589 Dock Fill 단일 그리드입니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 SCM_MST_SHEET_COLUMNS. 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y'. 14개 division 모두 같습니다.

### 3-1. 시트 `Distribution Route` (39컬럼, 메인 spdMain)

| # | COLUMN_NAME | 라벨(원문) | 구분 | 출처 |
|---:|---|---|---|---|
| 1 | ROUTE_ID | Route Id | **필수** | META |
| 2 | FROM_COUNTRY | Country* | 기본 | META |
| 3 | FROM_CITY | City* | 기본 | META |
| 4 | FROM_CITY_NAME | City Name | 기본 | META |
| 5 | TO_COUNTRY | Country* | 기본 | META |
| 6 | TO_CITY | City* | 기본 | META |
| 7 | TO_CITY_NAME | City Name | 기본 | META |
| 8 | D_COUNTRY | Country* | 기본 | META |
| 9 | D_PORT_CODE | Port Code* | 기본 | META |
| 10 | D_PORT_NAME | Port* | 기본 | META |
| 11 | A_COUNTRY | Country* | 기본 | META |
| 12 | A_PORT_CODE | Port Code* | 기본 | META |
| 13 | A_PORT_NAME | Port* | 기본 | META |
| 14 | TRANSPORT_MODE | Trans Mode* | 기본 | META |
| 15 | SHIPPING_COMPANY | Forwarder* | 기본 | META |
| 16 | PRIORITY | Priority* | 기본 | META |
| 17 | LT_TYPE | L/T Type* | 기본 | META |
| 18 | VALID_YN | Valid* | 기본 | META |
| 19 | LT_DEPARTURE_INLAND | Departure Inland | 기본 | META |
| 20 | LT_WAIT_SHIPPING | Waiting For Shipping | 기본 | META |
| 21 | LT_VOYAGE | Voyage | 기본 | META |
| 22 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 기본 | META |
| 23 | LT_ARRIVAL_INLAND | Arrival Inland | 기본 | META |
| 24 | LT_SUM | Total L/T | 기본 | META |
| 25 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Date | 기본 | META |
| 26 | One_SEGMENT_COST | Pick Up Cost | 기본 | META |
| 27 | Two_SEGMENT_COST | Freight Cost | 기본 | META |
| 28 | Three_SEGMENT_COST | Delivery Cost | 기본 | META |
| 29 | DAYS_MON | Mon | 기본 | META |
| 30 | DAYS_TUE | Tue | 기본 | META |
| 31 | DAYS_WED | Wed | 기본 | META |
| 32 | DAYS_THU | Thu | 기본 | META |
| 33 | DAYS_FRI | Fri | 기본 | META |
| 34 | DAYS_SAT | Sat | 기본 | META |
| 35 | DAYS_SUN | Sun | 기본 | META |
| 36 | CREATED_BY | Created By | 기본 | META |
| 37 | CREATION_DATE | Creation Date | 기본 | META |
| 38 | LAST_UPDATED_BY | Last Updated By | 기본 | META |
| 39 | LAST_UPDATE_DATE | Last Update Date | 기본 | META |

> 위 표의 행 순서는 의미 단위로 묶어 보기 쉽게 정렬한 것이며, **화면 컬럼 순서가 아닙니다**. 실제 순서(메타 정렬 컬럼)와 2단 헤더 그룹명(ATTRIBUTE1~5 등)은 Fact Pack 본문에 없어 **확인 필요**입니다. `Country*` 라벨이 4개 컬럼(FROM/TO/D/A_COUNTRY)에 겹치는 것으로 보아 상위 그룹 헤더로 구분하는 구조로 보이지만, 근거는 SetSheetHeaderColumn 의 iColumnHeaderRowCount=2 뿐입니다.

### 3-2. 시트 `POPUP` (16컬럼, 이력 팝업 spdMain)

| # | COLUMN_NAME | 라벨(원문) | 구분 |
|---:|---|---|---|
| 1 | ROUTE_ID | Route Id | **필수** |
| 2 | LT_DEPARTURE_INLAND | Departure Inland | 기본 |
| 3 | LT_WAIT_SHIPPING | Waiting For Shipping | 기본 |
| 4 | LT_VOYAGE | Voyage | 기본 |
| 5 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 기본 |
| 6 | LT_ARRIVAL_INLAND | Arrival Inland | 기본 |
| 7 | LT_SUM | Total L/T | 기본 |
| 8 | DAYS_MON | Mon | 기본 |
| 9 | DAYS_TUE | Tue | 기본 |
| 10 | DAYS_WED | Wed | 기본 |
| 11 | DAYS_THU | Thu | 기본 |
| 12 | DAYS_FRI | Fri | 기본 |
| 13 | DAYS_SAT | Sat | 기본 |
| 14 | DAYS_SUN | Sun | 기본 |
| 15 | LAST_UPDATED_BY | Last Updated By | 기본 |
| 16 | LAST_UPDATE_DATE | Last Update Date | 기본 |

> 이 표도 실제 컬럼 순서가 아닙니다. 순서는 **확인 필요**입니다.

### 3-3. 코드 하드코딩 / 표시 변경

- 하드코딩으로 추가하는 컬럼은 없습니다(grid_effective 의 source 가 전부 META).
- 표시/라벨 변경은 Designer 의 ColumnHeader 기본 스타일 4건만 있습니다(메인 515~518행, 팝업 65~68행: HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced).
- 화면이 직접 정의한 `SetSpreadColumn(siMain)` 을 조회 후(조회 결과 1행 이상일 때) 호출합니다(FindDataMain:452, FindDataReceive:521). 내부에서 컬럼 속성을 바꾸는지는 grid_code.csv 에 전개된 내용이 없어 **확인 필요**입니다.

### 3-4. division별 표시 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Distribution Route | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 | 39 |
| POPUP | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |

division에 따른 차이는 없습니다. 판단불가 분기는 0건입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 연결 방식 |
|---|---|---|
| Distribution Route | META+코드연결 | 메인 CreateSpread:233 AddSheet → InitSpread:245~246 `SheetName == "Distribution Route"` 조건으로 SetSheetHeaderColumn |
| POPUP | META+코드연결 | 팝업 CreateSpread:122 AddSheet → InitSpread:134~136 `SheetName == "POPUP"` 조건으로 SetSheetHeaderColumn |

- 메인 시트 하나(spdMain)에 두 조회 경로가 같이 바인딩됩니다: FindDataMain(SCP0005_GET_DISTRIBUTION_ROUTE)과 FindDataReceive(SCP0005_GET_DISTRIBUTION_ROUTEID).
- POPUP 시트는 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID(이력 테이블 SCP_MST_DISTRIBUTION_ROUTE_H) 결과를 보여줍니다. 두 시트의 공통 필수 컬럼은 `ROUTE_ID` 입니다. 메인 → 팝업으로 넘기는 키가 ROUTE_ID 인지와 팝업을 띄우는 이벤트는 **확인 필요**입니다.

=== FILE: oracle_migration.md ===
# SCP0005 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 유형 | 참조 테이블 | 참조 함수/REF | EXEC 체인 |
|---|---|---|---|---|---|
| SCP0005_GET_DISTRIBUTION_ROUTE | M FindDataMain:424 | 조회 | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT | — |
| SCP0005_GET_DISTRIBUTION_ROUTEID | M FindDataReceive:499 | 조회 | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC | — |
| SCP0005_SAVE_DISTRIBUTION_ROUTE | M SaveData:752 | 저장 | SCP_MST_DISTRIBUTION_ROUTE (UPDATE/INSERT/DELETE/SELECT), SCM_SYS_LOG_BATCH (INSERT), SCP_MST_DISTRIBUTION_ROUTE_H (INSERT) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST |
| SCP0005_GET_COUNTRY_CITY | M GetData_Country:916 | 조회 | SCM_MST_CITY (SELECT) | — | — |
| SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | P FindData:171 | 조회(이력) | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE_H, SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | FN_GET_LOOKUP_CODE_DESC | — |

5개 SP 모두 FoxQuery 매칭 상태가 `MATCH` 입니다(`SCP.` 쿼리 ID 등록 확인).

### 1-1. EXEC 전이 체인 (SAVE)

```
SCP0005_SAVE_DISTRIBUTION_ROUTE
 ├─ REF  SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL       (배열 문자열 분해)
 ├─ DML  SCP_MST_DISTRIBUTION_ROUTE  UPDATE / INSERT / DELETE / SELECT
 ├─ EXEC PR_SCP_MST_DISTRIBUTION_ROUTE_HIST
 │        └─ (전이) INSERT SCP_MST_DISTRIBUTION_ROUTE_H
 └─ EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN
          └─ (전이) INSERT SCM_SYS_LOG_BATCH
```

> 전이 표시(└─)의 소속은 Fact Pack 의 objects 목록이 SP 단위로 평탄화되어 있어 객체명으로 대응시킨 것입니다. 실제로 어느 하위 프로시저가 INSERT 하는지는 원문에서 **확인 필요**입니다.
> 저장 결과는 화면에서 `dtErr.Rows[0]["ERR_MESSAGE"]`(SaveData:871)로 읽습니다. 따라서 오류 결과셋(ERR_MESSAGE 컬럼)을 반환하는 계약을 Oracle 쪽에서도 유지해야 합니다.

## 2. 공통코드 분기 (biz:CommonData)

| 호출 | code | 처리 SP | 참조 테이블 | 호출 위치 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` | COUNTRY_MST | UP_FX_GetCommonDataList | SCM_MST_COUNTRY | dtFromCountry:44, dtToCountry:46 |
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | dtTransMode:49 |
| `biz:CommonData.CommonDataList` | FromSiteByDivision | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+REF STRING_SPLIT) | GetFromSitebyDivision:1187 |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+REF STRING_SPLIT) | GetToSitebyDivision:1195 |
| `biz:CommonData.CommonDataList` | BodType | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | GetBodType:1207 |
| `biz:CommonData.CommonDataList` | TransportMode | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL | GetTransMode:1217 |
| `biz:CommonData.YesOrNo` | — | (Data.CallBizData) | DB 보강 없음 — **확인 필요** | dtYesOrNo:48, dtValidYN:51 |

- LookupCommon 에 넘기는 LOOKUP 마스터 코드값(예: Trans Mode 그룹 코드)은 Fact Pack 에 없어 **확인 필요**입니다.
- FromSiteByDivision / ToSiteByDivision 와 GetBodType / GetTransMode 는 호출자가 확인되지 않았습니다(진입점 미연결). 전환 대상에 넣을지는 원문 확인 후 결정해야 합니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| 구분 | 건수 | 내용 |
|---|---:|---|
| FoxQuery 미등록 SP | 0 | 5개 SP 모두 MATCH |
| 직접 SQL / 직접 호출 | 0 | Fact Pack 에 없음 |
| 주석 처리됨 호출 | 0 | commented_calls 0건 |
| Biz 공통 호출 | 9 | biz:CommonData.CommonDataList 7건, biz:CommonData.YesOrNo 2건 |

## 4. Oracle 전환 시 확인 포인트

| # | 포인트 | 근거 | 대상 |
|---:|---|---|---|
| 1 | `STRING_SPLIT`(MSSQL 전용) 치환 필요 | REF:STRING_SPLIT | SCP0005_GET_DISTRIBUTION_ROUTE, UP_FX_GetCommonDataList(_SCP) |
| 2 | `FN_GET_LOOKUP_CODE_DESC` 함수의 Oracle 존재/동등성 | REF | GET_DISTRIBUTION_ROUTE / ROUTEID / HISTORY_ROUTEID |
| 3 | `SCM_ARR_SPL_CNT` / `SCM_ARR_SPL_VAL` 배열 분해 함수의 Oracle 구현 | REF | SAVE_DISTRIBUTION_ROUTE |
| 4 | 하위 프로시저 `PR_SCP_MST_DISTRIBUTION_ROUTE_HIST`, `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` 이행 여부 | EXEC 체인 | SAVE_DISTRIBUTION_ROUTE |
| 5 | 저장 SP 의 트랜잭션 경계(본 테이블 DML + 이력 INSERT + 로그 INSERT) | 한 SP 안 DML 3종 + 하위 EXEC 2건 | SAVE_DISTRIBUTION_ROUTE |
| 6 | 오류 반환 결과셋(`ERR_MESSAGE`) 형식 | SaveData:871 | SAVE_DISTRIBUTION_ROUTE |
| 7 | 메인 조회 SP 2종(ROUTE / ROUTEID)의 출력 컬럼이 같은 시트(39컬럼 메타)와 맞는지 | 둘 다 같은 spdMain 에 SetSpreadColumn | GET_DISTRIBUTION_ROUTE, GET_DISTRIBUTION_ROUTEID |
| 8 | 이력 SP 출력 컬럼과 POPUP 메타 16컬럼의 일치 | grid 단계 SP 매칭 미실행 | GET_DISTRIBUTION_HISTORY_ROUTEID |
| 9 | 메타 행 이관: SCM_MST_SHEET_COLUMNS 55행(39+16), TB_FX_SearchCondition 32행, SCM_ADM_EXCEL_COLUMNS 1행, TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 16행 | Fact Pack 8장 | 메타 |
| 10 | SCM_ADM_DB_SCRIPT_BACKUP 20행 | 화면 ID 가 값으로 들어간 행. 내용(SP 변경 이력 여부)은 **확인 필요** | 참고 |
| 11 | 각 SP 의 파라미터 목록, 그리고 FindDataMain 의 CheckedList(CODE) 다중값을 STRING_SPLIT 으로 받는지 | GetCheckedListValue@404 + REF STRING_SPLIT | GET_DISTRIBUTION_ROUTE — 파라미터 원문 **확인 필요** |

## 5. 난이도 (사실 근거)

| SP | 근거 | 상대 난이도 |
|---|---|---|
| SCP0005_SAVE_DISTRIBUTION_ROUTE | 참조 객체 11개, DML 4종(UPDATE/INSERT/DELETE + 이력·로그 INSERT), 하위 EXEC 2건, 배열 분해 함수 2종 | 5개 중 가장 높음 |
| SCP0005_GET_DISTRIBUTION_ROUTE | 참조 6개, MSSQL 전용 STRING_SPLIT 포함 | 중간 |
| SCP0005_GET_DISTRIBUTION_ROUTEID | 참조 5개, MSSQL 전용 함수 없음 | 낮음~중간 |
| SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 참조 5개, MSSQL 전용 함수 없음 | 낮음~중간 |
| SCP0005_GET_COUNTRY_CITY | 참조 2개(SCM_MST_CITY 단일) | 낮음 |

> 위 순위는 Fact Pack 의 참조 객체 수와 MSSQL 전용 키워드 유무만으로 매긴 것입니다. SP 본문의 줄 수와 동적 SQL 여부는 Fact Pack 에 없어 **미측정**입니다.

=== FILE: tobe_design.md ===
# SCP0005 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순 | 라벨(원문) | AS-IS 컨트롤 | TO-BE 형태 후보 | 데이터 출처 후보 | 비고 |
|---:|---|---|---|---|---|
| 1 | Valid | cboValidYN (UsrCombo) | 단일 Combo | biz:CommonData.YesOrNo (dtValidYN:51) | 기본값은 **확인 필요** |
| 2 | Trans Mode | clbTransMode (UsrCheckedList) | 다중 선택 | biz:CommonData.CommonDataList [code=LookupCommon] (dtTransMode:49) | 조회 시 GetCheckedListValue(CODE) 후보 |
| 3 | From Country | txtFromCountry (TextBox) | Input + 검색 팝업 | btnFromSrch → popCity.Country | |
| 4 | From City | txtFromCity (TextBox) | Input + 검색 팝업 | btnFromSrch → popCity.City | |
| 5 | To Country | txtToCountry (TextBox) | Input + 검색 팝업 | btnToSrch → popCity.Country | |
| 6 | To City | txtToCity (TextBox) | Input + 검색 팝업 | btnToSrch → popCity.City | |

- 조회조건 저장/복원은 `InitControls` 가 ManualSearchCondition 의 ControlName/ControlValue 로 수행합니다(메타 TB_FX_SearchCondition 32행).
- 조회조건 패널 유형은 HidePanel(접힘 가능)입니다.
- 위 '순'은 라벨을 나열한 순서일 뿐 실제 화면 배치 순서가 아닙니다. 배치 좌표는 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | AS-IS 엔드포인트 | TO-BE API 후보 | 비고 |
|---|---|---|---|---|
| 화면 로드 | `Form_Load`(.ctor:144) | 필드 초기화 biz 5건(진입점 미연결) | 공통코드 조회(COUNTRY_MST, LookupCommon, YesOrNo) | 로드 시 호출 여부 확인 필요 |
| 조회 | FindButton > FindDataMain | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 조회 API(목록) | |
| 조회(수신) | FindButton > FindDataReceive | SCP.SCP0005_GET_DISTRIBUTION_ROUTEID | Route ID 단건/수신 조회 API | 분기 조건 확인 필요 |
| 조회(국가·도시) | FindButton > GetData_Country | SCP.SCP0005_GET_COUNTRY_CITY | 국가/도시 조회 API | SetCityCode 와의 관계 확인 필요 |
| 저장 | SaveButton > SaveData | SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE | 저장 API(추가/수정/삭제 통합) | 저장 후 FindDataMain 재조회 |
| 편집 | EditButton(318) | — | — | 동작 확인 필요 |
| Excel 업로드 | `btnEaxel_Upload_Click` | 이후 SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 업로드 처리 + 조회 API | 업로드 데이터를 저장하는 경로 확인 필요 |
| Excel 양식 | `btnExcel_Form_Click` | — | Excel 양식 다운로드(공통) | SCM_ADM_EXCEL_COLUMNS 1행 |
| From 도시 검색 | `btnFromSrch_Click` | popCity(확인 필요) | 도시 선택 팝업 | |
| To 도시 검색 | `btnToSrch_Click` | popCity(확인 필요) | 도시 선택 팝업 | |
| 셀 더블클릭 | `spdMain_CellDoubleClick` | — (1135~1164 Changed 핸들러 해제/재등록) | 셀 팝업/값 설정 | 이력 팝업 호출 여부 확인 필요 |
| 셀 값 변경 | `spdMainDataModel_Changed` | — | 셀 편집 후 처리(cellEditEnded 계열) | 변경 셀·계산 로직 확인 필요 |
| 이력 팝업 조회 | 팝업 `Form_Load` / FindButton > FindData | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 이력 조회 API | 팝업 Text "DistributionRoute History" |

> 'TO-BE API 후보' 열은 역할만 적었습니다. 실제 URL과 메서드명은 TO-BE BE 명명 규약에 따르며 Fact Pack 범위 밖입니다.

## 3. division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 | division 차이 | 필수 컬럼 |
|---|---:|---|---|
| Distribution Route | 39 | 없음(14개 division 동일) | ROUTE_ID |
| POPUP | 16 | 없음(14개 division 동일) | ROUTE_ID |

- 코드 분기로 컬럼을 표시하거나 숨기는 곳은 없습니다(판단불가 0건).
- 그리드 헤더는 2단입니다(SetSheetHeaderColumn iColumnHeaderRowCount=2).

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 |
| 사용자 그룹 참조 | `<field:UserGroup>` 가 UserInfoContext.Current["NowGroupID"] 를 읽음(60행) |
| 사이트 권한 | FromSiteByDivision/ToSiteByDivision 공통코드가 TB_FX_USERGROUPAUTHEXTENTION 을 참조. 단, 호출자는 진입점 미연결 |
| C/U/D | 저장 SP 하나가 SCP_MST_DISTRIBUTION_ROUTE 에 INSERT/UPDATE/DELETE 를 모두 수행 |
| R | 조회 SP 4종(ROUTE, ROUTEID, COUNTRY_CITY, HISTORY_ROUTEID) |
| 그룹별 C/R/U/D 플래그 값 | TB_FX_GroupMenuAuth 행의 내용이 Fact Pack 본문에 없음 — **확인 필요** |

## 5. 미확정 사항

1. FindButton 하나에서 FindDataMain / FindDataReceive / GetData_Country 로 갈라지는 조건
2. 필드 초기화 biz 호출 5건과 미연결 메서드 4건(GetFromSitebyDivision, GetToSitebyDivision, GetBodType, GetTransMode)의 실제 사용 여부
3. `popCity` 팝업의 정체와 사용하는 엔드포인트
4. `spdMain_CellDoubleClick` 과 `spdMainDataModel_Changed` 의 내부 로직(이력 팝업 호출, 셀 계산)
5. Excel 업로드의 저장 경로, Excel 양식 생성 방식
6. SaveButton:333 의 SaveData 매핑 충돌(PersonalSettingPopup.SaveData vs 화면 SaveData:752)
7. 그리드 컬럼 순서와 2단 헤더 그룹명
8. 각 SP 의 파라미터 목록과 출력 컬럼(메타 39/16컬럼과의 일치)
9. `biz:CommonData.YesOrNo` 의 데이터 출처
10. usrLayoutControl1(657×184, parent 미지정)과 imageList1 의 용도
11. TB_FX_GroupMenuAuth 그룹별 권한 값
