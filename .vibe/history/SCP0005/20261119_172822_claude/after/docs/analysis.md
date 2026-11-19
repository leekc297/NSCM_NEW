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
