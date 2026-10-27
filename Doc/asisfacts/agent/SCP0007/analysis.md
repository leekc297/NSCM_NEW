# SCP0007 As-is 분석서 (AsisFacts Fact Pack 기준)

> 이 문서는 정적 파서가 만든 Fact Pack에 있는 사실만 썼다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> 주석 처리된 호출(commented_calls)은 0건이다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0007 |
| 도메인 | SCP (프로젝트 경로 `GSCM.SCP.Forms.UIL\Master\SCP0007_BOD`) |
| 메인 폼 클래스 | `SCP0007_BOD` (폼 Text = `"SCP0007_BOD"`, Designer.cs:626) |
| 연동 팝업 클래스 | `SCP0007_DistributionRoutePopup` (폼 Text = `"Distribution Route Popup"`, Designer.cs:640) |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)` |
| 화면에서 쓰는 시트 | `BOD`(메인), `Distribution Route`(팝업) |

### 1-1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.cs | SCP0007_BOD.csproj | 1471 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\SCP0007_BOD.Designer.cs | SCP0007_BOD.csproj | 684 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0007_BOD\Properties\AssemblyInfo.cs | SCP0007_BOD.csproj | 37 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0007_DistributionRoutePopup.cs | GSCM.SCM.Popup.UIL.csproj | 713 |
| shared | 06.UIL\GSCM.SCM.Popup.UIL\SCP0007_DistributionRoutePopup.Designer.cs | GSCM.SCM.Popup.UIL.csproj | 700 |
| legacy | Fact Pack 본문 기준 0건. CSV에도 legacy 행은 없다 | – | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 소속 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---|---|---:|---|---|---|
| F1 | button:FindButton | current | FindButton > GetData_Country | 626 | `SCP.SCP0007_GET_COUNTRY_CITY` | MATCH | SCP0007_GET_COUNTRY_CITY |
| F2 | button:FindButton | current | FindButton > FindData_Main | 553 | `SCP.SCP0007_GET_BOD` | MATCH | SCP0007_GET_BOD |
| F3 | button:SaveButton | current | SaveButton > SaveData_Main | 794 | `SCP.SCP0007_SAVE_BOD` | MATCH | SCP0007_SAVE_BOD |
| F4 | button:SaveButton | current | SaveButton > SaveData_Main > FindData_Main | 553 | `SCP.SCP0007_GET_BOD` | MATCH | SCP0007_GET_BOD (저장 뒤 다시 조회) |
| F5 | event:dsdm.Changed | current | SpdMain_Changed > SetCityCode | 1448 | `SCP.SCP0007_GET_ROUTE_CNT` | MATCH | SCP0007_GET_ROUTE_CNT |
| F6 | event:this.Load | shared(팝업) | Form_Load > FindDataMain | 436 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | SCP0005_GET_DISTRIBUTION_ROUTE |
| F7 | event:this.btnButtonList.UsrButtonList_Click_Detected | shared(팝업) | btnButtonList_UsrButtonList_Click_Detected > FindDataMain | 436 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | 〃 |
| F8 | button:FindButton | shared(팝업) | FindButton > FindDataMain | 436 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | MATCH | 〃 |
| U1 | 진입점 미연결 | current | `<field:dtIncoterms>` | 65 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| U2 | 진입점 미연결 | current | `<field:dtTransMode>` | 66 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| U3 | 진입점 미연결 | current | `<field:dtValidYN>` | 68 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |
| U4 | 진입점 미연결 | current | `<field:dtIncotermsEdit>` | 69 | `biz:CommonData.CommonDataList` [code=incotermsEdit] | BIZ_MATCH | – |
| U5 | 진입점 미연결 | shared | `<field:dtFromCountry>` | 44 | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | BIZ_MATCH | – |
| U6 | 진입점 미연결 | shared | `<field:dtToCountry>` | 46 | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] | BIZ_MATCH | – |
| U7 | 진입점 미연결 | shared | `<field:dtYesOrNo>` | 48 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |
| U8 | 진입점 미연결 | shared | `<field:dtTransMode>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| U9 | 진입점 미연결 | shared | GetDivision | 540 | `biz:CommonData.CommonDataList` [code=MyDivision] | BIZ_MATCH | – |
| U10 | 진입점 미연결 | shared | GetFromSitebyDivision | 549 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | – |
| U11 | 진입점 미연결 | shared | GetToSitebyDivision | 557 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | – |
| U12 | 진입점 미연결 | shared | GetBodType | 569 | `biz:CommonData.CommonDataList` [code=BodType] | BIZ_MATCH | – |
| U13 | 진입점 미연결 | shared | GetTransMode | 579 | `biz:CommonData.CommonDataList` [code=TransportMode] | BIZ_MATCH | – |

- U1~U8은 필드 초기화식(`<field:…>`)이다. 파서는 이를 "진입점 미연결"로 분류했다. 실제로 언제 실행되는지는 **확인 필요**다.
- U9~U13은 팝업의 메서드다. 어느 경로에서 호출되는지 Fact Pack에 없다(**확인 필요**).
- F1과 F2 사이의 호출 순서(FindButton 안에서 GetData_Country와 FindData_Main 중 무엇이 먼저인지)는 Fact Pack에 없다(**확인 필요**).

## 3. 엔드포인트 전체 표

| 엔드포인트 | code | 상태 | 호출 수 | SP / SQL | 참조 객체(EXEC 전이 포함) / DB 보강 |
|---|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` | BodType | BIZ_MATCH | 1 | – | 코드분기 UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` | COUNTRY_MST | BIZ_MATCH | 2 | – | 코드분기 UP_FX_GetCommonDataList: SELECT SCM_MST_COUNTRY |
| `biz:CommonData.CommonDataList` | FromSiteByDivision | BIZ_MATCH | 1 | – | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP: SELECT SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT |
| `biz:CommonData.CommonDataList` | incotermsEdit | BIZ_MATCH | 1 | – | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` | LookupCommon | BIZ_MATCH | 3 | – | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` | MyDivision | BIZ_MATCH | 1 | – | UP_FX_GetCommonDataList: SELECT SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | BIZ_MATCH | 1 | – | UP_FX_GetCommonDataList / _SCP: SELECT SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, REF STRING_SPLIT |
| `biz:CommonData.CommonDataList` | TransportMode | BIZ_MATCH | 1 | – | UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | – | BIZ_MATCH | 2 | – | DB 보강 없음. 원천 **확인 필요** |
| `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | – | MATCH | 1 | SP SCP0005_GET_DISTRIBUTION_ROUTE | SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL, FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT |
| `SCP.SCP0007_GET_BOD` | – | MATCH | 1 | SP SCP0007_GET_BOD | STRING_SPLIT, **DYNAMIC@SCP0007_GET_BOD**(동적 SQL이라 참조 테이블을 정적으로 확정하지 못함) |
| `SCP.SCP0007_GET_COUNTRY_CITY` | – | MATCH | 1 | SP SCP0007_GET_COUNTRY_CITY | SCM_MST_SITE, STRING_SPLIT |
| `SCP.SCP0007_GET_ROUTE_CNT` | – | MATCH | 1 | SP SCP0007_GET_ROUTE_CNT | SCP_MST_DISTRIBUTION_ROUTE |
| `SCP.SCP0007_SAVE_BOD` | – | MATCH | 1 | SP SCP0007_SAVE_BOD | MERGE/SELECT/DELETE SCP_MST_BOD, INSERT/UPDATE/SELECT SCP_MST_BOD_ITEM, INSERT SCP_MST_BOD_H, INSERT SCM_SYS_LOG_BATCH, SELECT SCP_MST_DISTRIBUTION_ROUTE·SCM_MST_SITE_ITEM·SCP_MST_FINAL_ITEM_V·SCM_MST_SITE, #TMP_SCM_MST_SITE_ITEM, EXEC PR_SCP_MST_BOD_HIST·PR_SCP_MST_BOD_ITEM·PR_SCM_SYS_LOG_BATCH·PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL·FN_NEXT_DAY·STRING_SPLIT, UPDATE:X |

호출 경로 요약:
- `biz:CommonData.CommonDataList`: `Data.Common[case Type.*] > Data.CallBizCommonData`
- `biz:CommonData.YesOrNo`: `Data.Common[case Type.YesOrNo] > Data.CallBizData`

## 4. 이벤트 배선 표

### 4-1. 메인 폼 (current, SCP0007_BOD.cs)
| 대상 | 이벤트 | 핸들러 | 위치 | op |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:157 | += |
| clbDivision | SelectedIndexChanged | `cboDivision_SelectedIndexChanged` | InitEvent:176 | += |
| spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | InitEvent:178 | += |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:179 | += |
| spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:180 | += |
| spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:181 | += |
| spdMain | KeyPress | `SpdMain_KeyPress` | InitEvent:182 | += |
| spdMain | EditChange | `SpdMain_EditChange` | InitEvent:183 | += |
| dsdm | Changed | `SpdMain_Changed` | InitEvent:186 | += |
| dsdm | Changed | `SpdMain_Changed` | spdMain_CellDoubleClick:1073 / 1104 | -= / += |
| dsdm | Changed | `SpdMain_Changed` | SpdMain_Changed:1284 / 1315 | -= / += |

### 4-2. 팝업 (shared, SCP0007_DistributionRoutePopup)
| 대상 | 이벤트 | 핸들러 | 위치 | op |
|---|---|---|---|---|
| this.btnToSrch | Click | `btnToSrch_Click` | Designer InitializeComponent:168 | += |
| this.btnFromSrch | Click | `btnFromSrch_Click` | Designer InitializeComponent:238 | += |
| this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Designer InitializeComponent:394 | += |
| this | Load | `Form_Load` | .ctor:149 | += |
| spdMain | CellDoubleClick | `spdMain_CellDoubleClick` | InitEvent:201 | += |
| dsdm | Changed | `spdMainDataModel_Changed` | InitEvent:203 | += |
| dsdm | Changed | `spdMainDataModel_Changed` | spdMainDataModel_Changed:489 / 521 | -= / += |

- `SpdMain_Changed`와 `spdMainDataModel_Changed`는 핸들러 안에서 자기 자신을 해제(-=)했다가 다시 등록(+=)한다.
- 메인 `spdMain_CellDoubleClick`도 1073(-=)과 1104(+=) 사이에서 `SpdMain_Changed`를 해제한다.

## 5. 핸들러별 확인된 동작 (meta_reads / grid_code 기준)

| 핸들러/메서드 | 줄 | 확인된 사실 |
|---|---|---|
| `spdMain_CellDoubleClick` (메인) | 1068~1089 | `dr`에서 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~DAYS_SUN, VALID_YN, LT_SUM, LT_TYPE를 읽는다. 이 컬럼명은 팝업 `Distribution Route` 시트 컬럼과 같다. 팝업을 띄우는 호출문은 Fact Pack에 없다(**확인 필요**) |
| `SpdMain_ComboSelChange` | 1140~1176 | `dr`에서 OSP_YN, CITY를 읽는다. FROM_SITE_CODE 컬럼을 바꾸면 TO_SITE_CODE 셀 콤보를 다시 바인딩한다(1146, 1154). 분기 조건은 `sFromSite == "E"`, `sFromSite == "A" && sOspYn == "Y"` |
| `SpdMain_ClipboardPasted` | 1218~1255 | `dr`에서 OSP_YN, CITY를 읽는다 |
| `SpdMain_EditChange` | 1344 | `drsTo[0]`에서 SITE_TYPE을 읽는다 |
| `SpdMain_Changed` > SetCityCode | 1368~1460 | drsFrom의 COUNTRY·CITY와 drsTo의 COUNTRY·CITY·VMI_YN·SITE_TYPE을 읽은 뒤 `SCP.SCP0007_GET_ROUTE_CNT`(1448)를 호출하고, 결과 `route_cnt`(1460)를 읽는다 |
| SaveData_Main | 794, 930 | `SCP.SCP0007_SAVE_BOD`를 호출하고 `dtErr.Rows[0]["ERR_MESSAGE"]`를 읽은 뒤 FindData_Main으로 다시 조회한다 |
| InsertButton | 387, 424, 425 | 조건 `strSel_InputStatus == "C"`, `siMain.SheetName == "BOD"`, 시트 잠금이 아닐 때 DIVISION_ID(dtMyDivision ← `BLUtils.GetDivisionWithoutEE`), INCOTERMS·INCOTERMS_SSP(dtIncotermsEdit) 셀 콤보를 설정한다 |
| EditButton | 450~490 | 행 루프에서 `drsTo[0]["SITE_TYPE"]`(476)이 `"PLANT"`이면 INCOTERMS_SSP 콤보를 설정한다. `boolEditChange == true`이면 dtIncotermsEdit, 아니면 `LookupCommon "INCOTERMS"` |
| `cboDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdMain_KeyPress`, `Form_Load`(메인) | – | 연결된 엔드포인트가 Fact Pack에 없다. 내부 동작은 **확인 필요** |
| `btnFromSrch_Click` / `btnToSrch_Click` (팝업) | 689~690 / 707~708 | `popCity.Country`와 `popCity.City`를 txtFrom*/txtTo*에 넣는다. 팝업 InitControls(214~222)에서 이 컨트롤들은 Enabled=false다 |

## 6. Grid 구성 방식

**`HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)`**

| 시트 | 소속 | 연결 규칙 | 구성 |
|---|---|---|---|
| BOD | current | META+코드연결 | `CreateSpread:262 AddSheet("BOD")` → `InitSpread:275 SetSheetHeaderColumn(siMain, 2)`로 SCM_MST_SHEET_COLUMNS 메타 39행을 쓴다. 코드에서 덧씌우는 것: InitSpread:277 `CellType = cellTypeImage`, InitSpread:338 `SAFETY_STOCK Visible = false`, Insert/Edit/ComboSelChange의 셀 콤보 재설정 |
| Distribution Route | shared | 코드 하드코딩 전용(메타 없음) | `CreateSpread:247 AddSheet("Distribution Route")` → InitSpread:264~297에서 Add*Column 33개, 301~335에서 ColumnHeaderSpan으로 2단 헤더 |

### 6-1. division별 차이
- BOD: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 34개(필수+기본 34 / 선택 0)로 같다. 숨김 5개(BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY)도 모든 division에서 같다.
- Distribution Route: 모든 division에서 33개(코드추가)로 같다.
- 정적으로 판단하지 못한 분기 조건은 0건이다. division에 따라 표시가 달라지는 코드 분기는 Fact Pack에 없다.

## 7. 확인 필요 항목
1. `SCP.SCP0007_GET_BOD`는 동적 SQL(DYNAMIC)이라 참조 테이블과 결과 컬럼을 정적으로 확정하지 못했다.
2. 결과 시트 매칭이 없다("실제 SP 실행 결과와 매칭되는 시트가 없습니다"). BOD 메타 39개 컬럼과 SP 결과 컬럼이 일치하는지 실행해서 대조해야 한다.
3. 필드 dtFromSiteAll(55), dtFromSiteOfSpdAll(60), dtToSiteOfSpdAll1(63), dtToSiteOfSpdAll2(64)는 `NowGroupID`를 읽는다. 그런데 이 필드들이 호출하는 엔드포인트가 endpoints.csv에 없다.
4. `BLUtils.GetDivisionWithoutEE`(InsertButton:387)의 원천 엔드포인트가 Fact Pack에 없다.
5. `biz:CommonData.YesOrNo`의 데이터 원천(DB 보강 없음).
6. Distribution Route의 DAYS_MON~DAYS_SUN 7개는 코드 인자에서 bVisible=`false`인데, grid_effective에는 "코드추가"(표시)로 33개에 포함돼 있다. 실제로 화면에 보이는 컬럼 수는 26개일 수 있다.
7. Distribution Route의 TRANSPORT_MODE_NAME 컬럼은 원문 인자가 `DefColumns.TRANSPORT_MODE`다. 상수가 실제로 어떤 값으로 해석되는지 확인해야 한다.
8. ColumnHeaderSpan의 302번 줄과 311~317번 줄은 Fact Pack에 없다. 상단 그룹 헤더 문구를 확인해야 한다.
9. InitSpread:277 `CellType = cellTypeImage`가 어느 컬럼에 적용되는지 알 수 없다.
10. 메인 `spdMain_CellDoubleClick`이 팝업을 여는 방식과 팝업 생성자 인자(sFromCountry, sFromCity, sToCountry, sToCity)를 넘기는 방식.
11. `SCP0007_SAVE_BOD`의 `UPDATE:X`: 별칭 X가 실제로 어느 테이블인지.
