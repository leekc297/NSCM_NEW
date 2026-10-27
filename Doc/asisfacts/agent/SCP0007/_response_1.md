=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SCP0007 소스 링크 표

> 경로 기준: `06.UIL/` (GSCM AS-IS 소스 루트). 줄 번호는 Fact Pack 추출값이다.
> 약어: **BOD.cs** = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs`, **BOD.Designer.cs** = 같은 폴더의 Designer, **POP.cs** = `06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs`, **POP.Designer.cs** = 같은 폴더의 Designer

## 1. 엔드포인트 호출 지점 (전수 18건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L65](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L65) | `<field:dtIncoterms>` | 65 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [BOD.cs#L66](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L66) | `<field:dtTransMode>` | 66 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [BOD.cs#L68](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L68) | `<field:dtValidYN>` | 68 | biz:CommonData.YesOrNo |
| [BOD.cs#L69](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L69) | `<field:dtIncotermsEdit>` | 69 | biz:CommonData.CommonDataList [code=incotermsEdit] |
| [BOD.cs#L553](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L553) | FindData_Main | 553 | SCP.SCP0007_GET_BOD |
| [BOD.cs#L626](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L626) | GetData_Country | 626 | SCP.SCP0007_GET_COUNTRY_CITY |
| [BOD.cs#L794](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L794) | SaveData_Main | 794 | SCP.SCP0007_SAVE_BOD |
| [BOD.cs#L1448](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1448) | SetCityCode | 1448 | SCP.SCP0007_GET_ROUTE_CNT |
| [POP.cs#L44](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L44) | `<field:dtFromCountry>` | 44 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| [POP.cs#L46](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L46) | `<field:dtToCountry>` | 46 | biz:CommonData.CommonDataList [code=COUNTRY_MST] |
| [POP.cs#L48](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L48) | `<field:dtYesOrNo>` | 48 | biz:CommonData.YesOrNo |
| [POP.cs#L49](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L49) | `<field:dtTransMode>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] |
| [POP.cs#L436](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L436) | FindDataMain | 436 | SCP.SCP0005_GET_DISTRIBUTION_ROUTE |
| [POP.cs#L540](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L540) | GetDivision | 540 | biz:CommonData.CommonDataList [code=MyDivision] |
| [POP.cs#L549](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L549) | GetFromSitebyDivision | 549 | biz:CommonData.CommonDataList [code=FromSiteByDivision] |
| [POP.cs#L557](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L557) | GetToSitebyDivision | 557 | biz:CommonData.CommonDataList [code=ToSiteByDivision] |
| [POP.cs#L569](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L569) | GetBodType | 569 | biz:CommonData.CommonDataList [code=BodType] |
| [POP.cs#L579](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L579) | GetTransMode | 579 | biz:CommonData.CommonDataList [code=TransportMode] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L157](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L157) | .ctor | 157 | this.Load += Form_Load |
| [BOD.cs#L176](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L176) | InitEvent | 176 | clbDivision.SelectedIndexChanged += cboDivision_SelectedIndexChanged |
| [BOD.cs#L178](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L178) | InitEvent | 178 | spdMain.CellDoubleClick += spdMain_CellDoubleClick |
| [BOD.cs#L179](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L179) | InitEvent | 179 | spdMain.TopChange += SpdMain_TopChange |
| [BOD.cs#L180](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L180) | InitEvent | 180 | spdMain.ComboSelChange += SpdMain_ComboSelChange |
| [BOD.cs#L181](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L181) | InitEvent | 181 | spdMain.ClipboardPasted += SpdMain_ClipboardPasted |
| [BOD.cs#L182](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L182) | InitEvent | 182 | spdMain.KeyPress += SpdMain_KeyPress |
| [BOD.cs#L183](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L183) | InitEvent | 183 | spdMain.EditChange += SpdMain_EditChange |
| [BOD.cs#L186](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L186) | InitEvent | 186 | dsdm.Changed += SpdMain_Changed |
| [BOD.cs#L1073](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1073) | spdMain_CellDoubleClick | 1073 | dsdm.Changed -= SpdMain_Changed |
| [BOD.cs#L1104](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1104) | spdMain_CellDoubleClick | 1104 | dsdm.Changed += SpdMain_Changed |
| [BOD.cs#L1284](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1284) | SpdMain_Changed | 1284 | dsdm.Changed -= SpdMain_Changed |
| [BOD.cs#L1315](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1315) | SpdMain_Changed | 1315 | dsdm.Changed += SpdMain_Changed |
| [POP.Designer.cs#L168](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L168) | InitializeComponent | 168 | btnToSrch.Click += btnToSrch_Click |
| [POP.Designer.cs#L238](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L238) | InitializeComponent | 238 | btnFromSrch.Click += btnFromSrch_Click |
| [POP.Designer.cs#L394](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.Designer.cs#L394) | InitializeComponent | 394 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| [POP.cs#L149](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L149) | .ctor | 149 | this.Load += Form_Load |
| [POP.cs#L201](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L201) | InitEvent | 201 | spdMain.CellDoubleClick += spdMain_CellDoubleClick |
| [POP.cs#L203](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L203) | InitEvent | 203 | dsdm.Changed += spdMainDataModel_Changed |
| [POP.cs#L489](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L489) | spdMainDataModel_Changed | 489 | dsdm.Changed -= spdMainDataModel_Changed |
| [POP.cs#L521](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L521) | spdMainDataModel_Changed | 521 | dsdm.Changed += spdMainDataModel_Changed |

## 3. Grid 구성 / 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L262](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L262) | CreateSpread | 262 | AddSheet("BOD", 2, 1, 30) |
| [BOD.cs#L271](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L271) | InitSpread | 271 | InitSheet(siMain.SheetName) |
| [BOD.cs#L275](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L275) | InitSpread | 275 | SetSheetHeaderColumn(siMain, 2): 메타 컬럼 생성 |
| [BOD.cs#L277](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L277) | InitSpread | 277 | CellType = cellTypeImage |
| [BOD.cs#L338](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L338) | InitSpread | 338 | SAFETY_STOCK Visible = false |
| [BOD.cs#L240](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L240) | SetChangeControl | 240 | GetCheckedListValue (CODE) |
| [BOD.cs#L517](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L517) | FindData_Main | 517, 518, 530~534 | GetCheckedListValue (CODE): 조회 파라미터 |
| [BOD.cs#L387](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L387) | InsertButton | 387 | SetCellTypeCombo DIVISION_ID ← dtMyDivision |
| [BOD.cs#L424](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L424) | InsertButton | 424, 425 | SetCellTypeCombo INCOTERMS / INCOTERMS_SSP ← dtIncotermsEdit |
| [BOD.cs#L450](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L450) | EditButton | 450 | GetSheetInfo |
| [BOD.cs#L476](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L476) | EditButton | 476 | drsTo[0]["SITE_TYPE"] |
| [BOD.cs#L484](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L484) | EditButton | 484, 490 | SetCellTypeCombo INCOTERMS_SSP (incotermsEdit / LookupCommon "INCOTERMS") |
| [BOD.cs#L1146](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1146) | SpdMain_ComboSelChange | 1146, 1154 | SetCellTypeCombo TO_SITE_CODE ← dtToSiteOfSpd |
| [POP.cs#L247](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L247) | CreateSpread | 247 | AddSheet("Distribution Route", 2, 1, 30) |
| [POP.cs#L264](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L264) | InitSpread | 264~297 | 하드코딩 Add*Column 33개 |
| [POP.cs#L301](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L301) | InitSpread | 301~335 | ColumnHeaderSpan 2단 헤더 |

## 4. DB 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [BOD.cs#L55](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L55) | `<field:dtFromSiteAll>` | 55 | UserInfoContext.Current.NowGroupID |
| [BOD.cs#L60](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L60) | `<field:dtFromSiteOfSpdAll>` | 60 | NowGroupID |
| [BOD.cs#L63](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L63) | `<field:dtToSiteOfSpdAll1>` / `2` | 63, 64 | NowGroupID |
| [BOD.cs#L930](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L930) | SaveData_Main | 930 | dtErr.Rows[0]["ERR_MESSAGE"] |
| [BOD.cs#L1068](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1068) | spdMain_CellDoubleClick | 1068~1089 | dr: ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~SUN, VALID_YN, LT_SUM, LT_TYPE |
| [BOD.cs#L1140](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1140) | SpdMain_ComboSelChange | 1140, 1165, 1176 | dr: OSP_YN, CITY |
| [BOD.cs#L1218](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1218) | SpdMain_ClipboardPasted | 1218, 1245, 1255 | dr: OSP_YN, CITY |
| [BOD.cs#L1344](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1344) | SpdMain_EditChange | 1344 | drsTo[0]["SITE_TYPE"] |
| [BOD.cs#L1368](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1368) | SetCityCode | 1368~1383 | drsFrom: COUNTRY, CITY / drsTo: COUNTRY, CITY, VMI_YN, SITE_TYPE |
| [BOD.cs#L1460](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs#L1460) | SetCityCode | 1460 | ds.Tables[0].Rows[0]["route_cnt"] |
| [POP.cs#L58](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L58) | `<field:UserGroup>` | 58 | NowGroupID |
| [POP.cs#L214](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L214) | InitControls | 214~229 | 조건 컨트롤 Enabled=false, Text ← sFromCountry/sFromCity/sToCountry/sToCity |
| [POP.cs#L689](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L689) | btnFromSrch_Click | 689, 690 | txtFromCountry/City ← popCity.Country/City |
| [POP.cs#L707](06.UIL/GSCM.SCM.Popup.UIL/SCP0007_DistributionRoutePopup.cs#L707) | btnToSrch_Click | 707, 708 | txtToCountry/City ← popCity.Country/City |

=== FILE: web_components.md ===
# SCP0007 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

### 1-1. 메인 화면 조회조건 (SCP0007_BOD, usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | 라벨(LayoutControlItem.Text 원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList2 | `Div` (layoutDivision) | 223×21 | 멀티선택 콤보(Wijmo MultiSelect). 변경 이벤트 `cboDivision_SelectedIndexChanged` 대응 |
| clbFromSite | UsrCheckedList2 | `From Site` (layoutFrom) | 202×21 | 멀티선택 콤보 |
| clbToSite | UsrCheckedList2 | `To Site` (layoutToSite) | 200×21 | 멀티선택 콤보 |
| clbIncoterms | UsrCheckedList2 | `Incoterms` (layoutIncoterms) | 148×21 | 멀티선택 콤보 |
| clbTransMode | UsrCheckedList2 | `Trans Mode` (layoutTransMode) | 175×21 | 멀티선택 콤보 |
| clbIncotermsSSP | UsrCheckedList2 | `SSP Incoterms` (layoutSSPIncoterms) | 123×21 | 멀티선택 콤보 |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | 215×20 | 단일 콤보(Wijmo ComboBox) |
| cboInputStatus | UsrCombo | `Input Status` (layoutControlItem1) | 185×20 | 단일 콤보. 값 `"C"`/`"R"` 분기가 코드에 있다(InsertButton) |
| spdMain (Sheet `BOD`) | FpSpread | – | 1168×523 | Wijmo FlexGrid (2단 컬럼 헤더) |

### 1-2. 팝업 (SCP0007_DistributionRoutePopup, 폼 Text `Distribution Route Popup`)
| AS-IS 컨트롤 | 유형 | 라벨 원문 | 크기 | 초기 상태 | TO-BE 후보 |
|---|---|---|---|---|---|
| txtFromCountry | UsrMultiLineEditor | `From Country` | 185×21 | Enabled=false, Text=sFromCountry | 읽기전용 텍스트 |
| txtFromCity | UsrMultiLineEditor | `From City` | 186×21 | Enabled=false, Text=sFromCity | 읽기전용 텍스트 |
| btnFromSrch | UsrButton | (layoutControlItem9, Text 없음) | 39×25 | Enabled=false | 도시 검색 버튼 → popCity 결과(Country/City) 반영 |
| txtToCountry | UsrMultiLineEditor | `" To Country"`(앞 공백 포함 원문) | 187×21 | Enabled=false, Text=sToCountry | 읽기전용 텍스트 |
| txtToCity | UsrMultiLineEditor | `" To City"`(앞 공백 포함 원문) | 186×21 | Enabled=false, Text=sToCity | 읽기전용 텍스트 |
| btnToSrch | UsrButton | (layoutControlItem10, Text 없음) | 39×25 | Enabled=false | 도시 검색 버튼 |
| clbTransMode | UsrCheckedList | `Trans Mode` | 170×21 | Enabled=false | 멀티선택 콤보(읽기전용) |
| btnButtonList | UsrButtonList | (layoutControlItem6, Text 없음) | 215×25 | – | 팝업 버튼 바 → `btnButtonList_UsrButtonList_Click_Detected` |
| spdMain (Sheet `Distribution Route`) | FpSpread | – | 1084×335 | – | Wijmo FlexGrid (2단 헤더) |

## 2. 화면 배치
props.csv에는 SplitContainer(Orientation / SplitterDistance)가 없다. 화면은 Dock으로 나뉜다.

| 화면 | 상단 | 하단 | 상/하 비율(높이 기준) |
|---|---|---|---|
| SCP0007_BOD | usrConditionPanel1, Dock=Top, 1168×69, UsrPanelType=HidePanel | spdMain, Dock=Fill, 1168×523 | 약 11.7% : 88.3% (69 : 523) |
| Distribution Route Popup | usrConditionPanel1, Dock=Top, 1084×78, HidePanel | spdMain, Dock=Fill, 1084×335 | 약 18.9% : 81.1% (78 : 335) |

- 좌/우 분할은 없다. 조회조건은 상단 패널 하나, Grid는 하단 하나로 구성된다.
- 메인 조회조건은 2행이다. 행 높이는 약 24~25px(LayoutControlItem 크기 263×25, 263×24 등)이고, 각 행에 4개 항목이 있다. 실제로 어느 행에 어떤 항목이 배치되는지는 Location 값이 Fact Pack에 없어 **확인 필요**다.

## 3. 시트별 Grid 컬럼

### 3-1. 시트 `BOD` (META+코드연결, 메타 SCM_MST_SHEET_COLUMNS 39행)
14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 표시 34개 / 숨김 5개로 같다.

| # | 컬럼 | 라벨(메타) | 표시(전 division) | 코드 오버라이드 |
|---:|---|---|---|---|
| 1 | AFTER_LEAD_TIME | Additional Lead Time | 기본 | – |
| 2 | BEFORE_LEAD_TIME | Before | 숨김 | – |
| 3 | BOD_ID | BOD_ID | 기본 | – |
| 4 | BOD_VALID | BOD Valid* | 기본 | – |
| 5 | CREATED_BY | Created By | 기본 | – |
| 6 | CREATION_DATE | Creation Date | 기본 | – |
| 7 | CUSTOMER | Customer | 기본 | – |
| 8 | DAYS_FRI | Fri | 기본 | – |
| 9 | DAYS_MON | Mon | 기본 | – |
| 10 | DAYS_SAT | Sat | 기본 | – |
| 11 | DAYS_SUN | Sun | 기본 | – |
| 12 | DAYS_THU | Thu | 기본 | – |
| 13 | DAYS_TUE | Tue | 기본 | – |
| 14 | DAYS_WED | Wed | 기본 | – |
| 15 | DIS_TOTAL_LEAD_TIME | Distribution Total Lead Time | 기본 | – |
| 16 | DIVISION_ID | Division* | 기본 | InsertButton:387 셀 콤보 ← dtMyDivision(`BLUtils.GetDivisionWithoutEE`) |
| 17 | FROM_CITY | From City | 기본 | – |
| 18 | FROM_COUNTRY | FROM_COUNTRY | 숨김 | – |
| 19 | FROM_SITE_CODE | From Site* | 기본 | ComboSelChange 기준 컬럼 |
| 20 | FROM_YYYYMMDD | FROM* | 기본 | – |
| 21 | INCOTERMS | Incoterms* | 기본 | InsertButton:424 셀 콤보 ← dtIncotermsEdit |
| 22 | INCOTERMS_SSP | Incoterms SSP* | 기본 | InsertButton:425 / EditButton:484·490 셀 콤보 (TO SITE_TYPE=PLANT일 때) |
| 23 | LAST_UPDATE_DATE | Last Update Date | 기본 | – |
| 24 | LAST_UPDATED_BY | Last Updated By | 기본 | – |
| 25 | LEAD_TIME | Lead Time | 기본 | – |
| 26 | LT_TYPE | L/T Type | 기본 | – |
| 27 | PRIORITY | Priority* | 기본 | – |
| 28 | REMARKS | Remarks | 기본 | – |
| 29 | ROUTE_CHK | ROUTE_CHK | 숨김 | – |
| 30 | ROUTE_CNT | Route Count | 기본 | SetCityCode의 `route_cnt` 결과와 관련된 것으로 보임(**확인 필요**) |
| 31 | ROUTE_ID | Route Id* | 기본 | – |
| 32 | ROUTE_VALID | Route Valid | 기본 | – |
| 33 | SAFETY_STOCK | Safety Stock | 숨김 | InitSpread:338 Visible=false(→숨김) |
| 34 | TO_CITY | To City | 기본 | – |
| 35 | TO_COUNTRY | TO_COUNTRY | 숨김 | – |
| 36 | TO_SITE_CODE | To Site* | 기본 | ComboSelChange:1146·1154 셀 콤보 ← dtToSiteOfSpd(필터) |
| 37 | TO_YYYYMMDD | TO* | 기본 | – |
| 38 | TRANSPORT_MODE | Trans Mode | 기본 | – |
| 39 | VMI_YN | To Site VMI | 기본 | – |

- 메타 컬럼 속성(폭·정렬·콤보유형·FIXED·대문자 등)은 SetSheetHeaderColumn이 읽는 ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG 등이 결정한다. 행별 값은 `dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv`를 봐야 한다(본 Fact Pack에는 값이 없다).
- 컬럼 헤더는 2행이다(`SetSheetHeaderColumn(siMain, 2)`, AddSheet 인자 2).
- InitSpread:277 `CellType = cellTypeImage`가 적용되는 컬럼은 **확인 필요**다.
- 표시 순서는 위 표처럼 알파벳순이다. 실제 순서(메타 정렬 컬럼)는 **확인 필요**다.

### 3-2. 시트 `Distribution Route` (코드 하드코딩 전용, 메타 없음, 팝업)
| # | 필드 | 헤더 | API | 폭 | bVisible(코드 인자) | 정렬 | 비고 |
|---:|---|---|---|---:|---|---|---|
| 1 | ROUTE_ID | Route Id | AddTextColumn | 60 | true | Right | 헤더 0행 2칸 병합 |
| 2 | LT_TYPE | L/T Type | AddTextColumn | 80 | true | Center | 0행 2칸 병합 |
| 3 | VALID_YN | Valid | AddComboColumn(dtYesOrNo) | 50 | true | Center | 0행 2칸 병합 |
| 4 | FROM_CITY_NAME | City Name | AddTextColumn | 130 | true | Left | 1행 |
| 5 | FROM_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 6 | FROM_CITY | City | AddExTextColumn(max 3) | 50 | true | Center | 1행 |
| 7 | TRANSPORT_MODE_NAME | Trans Mode | AddTextColumn | 60 | true | Center | 원문 인자 `DefColumns.TRANSPORT_MODE` |
| 8 | PRIORITY | Priority | AddNumTextColumn | 60 | true | Right | 0행 2칸 병합 |
| 9~15 | DAYS_MON~DAYS_SUN | Mon~Sun | AddComboColumn(dtYesOrNo) | 40 | **false** | Center | 표시 여부 **확인 필요** |
| 16 | DAYS | Departure Days | AddTextColumn | 140 | true | Left | 0행 2칸 병합 |
| 17 | D_PORT_NAME | Port | AddTextColumn | 80 | true | Left | 319: 0행 1칸 "Port" |
| 18 | D_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 19 | D_PORT_CODE | Port Code | AddExTextColumn(max 3) | 70 | true | Center | 1행 |
| 20 | A_PORT_NAME | Port | AddTextColumn | 80 | true | Left | 1행 |
| 21 | A_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 22 | A_PORT_CODE | Port Code | AddExTextColumn(max 3) | 70 | true | Center | 1행 |
| 23 | SHIPPING_COMPANY | Shipping Company | AddExTextColumn(max 3) | 80 | true | Center | 0행 2칸 병합 |
| 24 | TO_CITY_NAME | City Name | AddTextColumn | 130 | true | Left | 1행 |
| 25 | TO_COUNTRY | Country | AddExTextColumn(max 2) | 50 | true | Center | 1행 |
| 26 | TO_CITY | City | AddExTextColumn(max 3) | 50 | true | Center | 1행 |
| 27 | SHIP_DOC_PREPARATION_DATE | Shipping Document Preparation Data | AddDateColumn | 120 | true | Center | 0행 2칸 병합 |
| 28 | LT_DEPARTURE_INLAND | Departure Inland | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 29 | LT_WAIT_SHIPPING | Waiting For Shipping | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 30 | LT_VOYAGE | Sea/Air Ferry | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 31 | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 32 | LT_ARRIVAL_INLAND | Arrival Inland | AddNumTextColumn | 100 | true | Right | 0행 1칸 |
| 33 | LT_SUM | Sum | AddNumTextColumn | 100 | true | Right | 0행 2칸 병합 |

- grid_effective는 14개 division 모두 33개(코드추가)로 집계했다. DAYS_MON~SUN 7개는 코드 인자가 bVisible=false여서 실제 표시 수와 다를 수 있다(**확인 필요**).
- CAppSetting.StringAction 컬럼에 헤더 "A"(0행 2칸, 301줄)가 있다.
- From/Depart/Arrive/To 그룹의 상단 헤더 문구(302, 311~317줄)는 Fact Pack에 없다(**확인 필요**).
- division별 표시 차이는 없다.

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | 의미 |
|---|---|---|
| `BOD` | META+코드연결 | 메타 시트를 코드가 AddSheet/ChangeSheet로 쓰고, 컬럼은 SetSheetHeaderColumn이 메타로 만든다. 코드는 숨김 처리와 셀 콤보만 덧씌운다 |
| `Distribution Route` | 코드 하드코딩 전용(메타 없음) | 팝업 InitSpread에서 Add*Column으로만 구성한다. 메타 행은 없다 |

- 시트 간 데이터 연결: 메인 `spdMain_CellDoubleClick`(BOD.cs:1068~1089)이 `Distribution Route`와 같은 컬럼명(ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_*, VALID_YN, LT_SUM, LT_TYPE)을 `dr`에서 읽는다. 팝업에서 고른 경로를 BOD 행에 반영하는 연결로 보이지만, 팝업 호출문과 대상 컬럼 매핑은 Fact Pack에 없어 **확인 필요**다.

=== FILE: oracle_migration.md ===
# SCP0007 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 호출 지점 | 참조 객체(EXEC 전이 포함) | 사실 기반 난이도 |
|---|---|---|---|---|
| `SCP0007_GET_BOD` | SCP.SCP0007_GET_BOD | FindData_Main:553 (조회, 저장 뒤 재조회) | STRING_SPLIT, **DYNAMIC@SCP0007_GET_BOD** | 중~상. 동적 SQL이라 참조 테이블과 결과 컬럼을 정적으로 확정하지 못함 |
| `SCP0007_GET_COUNTRY_CITY` | SCP.SCP0007_GET_COUNTRY_CITY | GetData_Country:626 | SELECT SCM_MST_SITE, STRING_SPLIT | 하. 단일 테이블 + STRING_SPLIT |
| `SCP0007_SAVE_BOD` | SCP.SCP0007_SAVE_BOD | SaveData_Main:794 | 아래 1-1 참조 | 상. 참조 24건, 하위 EXEC 4개, 임시테이블, MERGE/DELETE/INSERT/UPDATE |
| `SCP0007_GET_ROUTE_CNT` | SCP.SCP0007_GET_ROUTE_CNT | SetCityCode:1448 | SELECT SCP_MST_DISTRIBUTION_ROUTE | 하. 단일 테이블 |
| `SCP0005_GET_DISTRIBUTION_ROUTE` | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 팝업 FindDataMain:436 | SELECT SCM_MST_CITY, SCP_MST_DISTRIBUTION_ROUTE, SCM_ADM_LOOKUP_MASTER_DETAIL, REF FN_GET_LOOKUP_CODE_DESC, STRING_SPLIT | 중. 함수 1개 + STRING_SPLIT. SCP0005 화면과 공유하는 SP |

### 1-1. `SCP0007_SAVE_BOD` EXEC 체인 / 참조 상세
| 구분 | 객체 |
|---|---|
| EXEC(하위 SP) | PR_SCP_MST_BOD_HIST, PR_SCP_MST_BOD_ITEM, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| MERGE | SCP_MST_BOD |
| DELETE | SCP_MST_BOD |
| INSERT | SCP_MST_BOD_ITEM, SCP_MST_BOD_H, SCM_SYS_LOG_BATCH, #TMP_SCM_MST_SITE_ITEM |
| UPDATE | SCP_MST_BOD_ITEM, X(별칭, 실제 대상 **확인 필요**) |
| SELECT | SCP_MST_BOD, SCP_MST_BOD_ITEM, SCP_MST_DISTRIBUTION_ROUTE, SCM_MST_SITE_ITEM, SCP_MST_FINAL_ITEM_V, SCM_MST_SITE, #TMP_SCM_MST_SITE_ITEM |
| REF(함수/객체) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_NEXT_DAY, STRING_SPLIT |

- 화면은 저장 뒤 `dtErr.Rows[0]["ERR_MESSAGE"]`(SaveData_Main:930)를 읽는다. Oracle 전환본도 오류 메시지 결과셋 계약(컬럼명 ERR_MESSAGE)을 유지해야 하는지 **확인 필요**하다.

## 2. 공통코드 분기 (biz:CommonData → UP_FX_GetCommonDataList)

| code | 호출 위치 | 분기 SP | 참조 테이블 |
|---|---|---|---|
| BodType | 팝업 GetBodType:569 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| COUNTRY_MST | 팝업 dtFromCountry:44, dtToCountry:46 | UP_FX_GetCommonDataList | SCM_MST_COUNTRY |
| FromSiteByDivision | 팝업 GetFromSitebyDivision:549 | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, STRING_SPLIT |
| ToSiteByDivision | 팝업 GetToSitebyDivision:557 | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, STRING_SPLIT |
| incotermsEdit | 메인 dtIncotermsEdit:69 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| LookupCommon | 메인 dtIncoterms:65, dtTransMode:66 / 팝업 dtTransMode:49 / EditButton:490 (`"INCOTERMS"`) | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| MyDivision | 팝업 GetDivision:540 | UP_FX_GetCommonDataList | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION |
| TransportMode | 팝업 GetTransMode:579 | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER_DETAIL |
| (YesOrNo) | 메인 dtValidYN:68 / 팝업 dtYesOrNo:48 | `Data.CallBizData` (CommonDataList 아님) | DB 보강 없음. 원천 **확인 필요** |

- LookupCommon의 lookup 마스터 코드값은 EditButton:490의 `"INCOTERMS"`만 확인된다. dtIncoterms(65)와 dtTransMode(66, 49)에 넘기는 코드값은 Fact Pack에 없다(**확인 필요**).

## 3. FoxQuery 미등록 / 직접호출 SP
- FoxQuery 엔드포인트 5개(`SCP.SCP0007_GET_BOD`, `SCP.SCP0007_GET_COUNTRY_CITY`, `SCP.SCP0007_SAVE_BOD`, `SCP.SCP0007_GET_ROUTE_CNT`, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`)는 모두 **MATCH**이고, 미등록 건은 0건이다.
- 확인 필요 0건, 주석 처리된 호출 0건.
- 엔드포인트를 특정하지 못한 데이터 로딩:
  - 메인 필드 dtFromSiteAll(55), dtFromSiteOfSpdAll(60), dtToSiteOfSpdAll1(63), dtToSiteOfSpdAll2(64): `NowGroupID`를 읽지만 호출 엔드포인트가 endpoints.csv에 없다.
  - InsertButton:387 `BLUtils.GetDivisionWithoutEE(false, "")`: 원천 SP **확인 필요**.

## 4. Oracle 전환 시 확인 포인트 (Fact Pack 근거)
| # | 대상 | 근거 | 확인 포인트 |
|---|---|---|---|
| 1 | STRING_SPLIT | SCP0007_GET_BOD, GET_COUNTRY_CITY, SAVE_BOD, SCP0005_GET_DISTRIBUTION_ROUTE, UP_FX_GetCommonDataList(_SCP) | MSSQL 전용 함수다. 멀티선택 조회조건(GetCheckedListValue: FindData_Main 517/518/530~534)의 구분자 문자열을 Oracle에서 분해하는 방식으로 대체해야 한다 |
| 2 | 동적 SQL | DYNAMIC@SCP0007_GET_BOD | 동적 문자열 안의 MSSQL 구문(함수·TOP·+연결 등)은 원문을 확인해야 알 수 있다. 결과 컬럼과 BOD 메타 39개 컬럼을 대조해야 한다 |
| 3 | 임시테이블 | #TMP_SCM_MST_SITE_ITEM (SAVE_BOD) | Oracle GTT 등으로 대체 필요. DDL 확보 필요 |
| 4 | MERGE / DELETE | SCP_MST_BOD (SAVE_BOD) | MERGE ON 키와 PK가 일치하는지 실측해야 한다 |
| 5 | UPDATE:X | SAVE_BOD | 별칭 기반 UPDATE(FROM 조인형 가능성)의 실제 대상 테이블과 구문 확인 |
| 6 | 하위 SP 체인 | PR_SCP_MST_BOD_HIST, PR_SCP_MST_BOD_ITEM, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN | 하위 SP 각각의 전환 상태와 트랜잭션(COMMIT) 경계 확인 |
| 7 | 함수 | FN_NEXT_DAY, FN_GET_LOOKUP_CODE_DESC, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | Oracle 대응 함수가 있는지 확인 |
| 8 | 뷰 | SCP_MST_FINAL_ITEM_V | 뷰가 Oracle에 있는지 확인 |
| 9 | 결과 컬럼 대소문자 | SetCityCode:1460 `route_cnt`(소문자) | Oracle은 별칭을 대문자로 반환하므로, 화면이 기대하는 키 이름을 확인해야 한다 |
| 10 | 공유 SP | SCP0005_GET_DISTRIBUTION_ROUTE | SCP0005 화면과 같은 SP를 쓴다. 수정하면 양쪽에 영향이 있다 |
| 11 | 공통코드 SP 2종 | UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | FromSite/ToSiteByDivision이 두 SP 중 어느 쪽을 타는지 분기 조건 확인 |

## 5. 메타 데이터 이관 대상 (화면 ID 포함 행)
| 메타 테이블 | 행 수 |
|---|---:|
| dbo.SCM_MST_SHEET_COLUMNS | 39 |
| dbo.TB_FX_SearchCondition | 473 |
| dbo.TB_FX_Favorite | 71 |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 65 |
| dbo.TB_FX_GroupMenuAuth | 13 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 8 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 |
| dbo.TB_FX_MenuItemInfo | 1 |
| dbo.TB_FX_ProgramInfo | 1 |

=== FILE: tobe_design.md ===
# SCP0007 TO-BE 설계 기초 (As-is 사실 기반)

## 1. 조회조건 (컨트롤 기준)
| 순서(Designer 선언 순) | 조건명(원문) | AS-IS 컨트롤 | 유형 | 값 원천 후보 | 비고 |
|---:|---|---|---|---|---|
| 1 | Div | clbDivision | 멀티 체크리스트 | **확인 필요**(메인 화면 Division 원천 엔드포인트가 Fact Pack에 없음) | 변경 시 `cboDivision_SelectedIndexChanged`. 동작 **확인 필요** |
| 2 | SSP Incoterms | clbIncotermsSSP | 멀티 체크리스트 | **확인 필요** | GetCheckedListValue(CODE) |
| 3 | Trans Mode | clbTransMode | 멀티 체크리스트 | dtTransMode(LookupCommon)일 가능성. **확인 필요** | 〃 |
| 4 | Incoterms | clbIncoterms | 멀티 체크리스트 | dtIncoterms(LookupCommon)일 가능성. **확인 필요** | 〃 |
| 5 | To Site | clbToSite | 멀티 체크리스트 | **확인 필요**(NowGroupID 사용 필드 존재) | 〃 |
| 6 | From Site | clbFromSite | 멀티 체크리스트 | dtFromSiteAll(NowGroupID). 원천 **확인 필요** | 〃 |
| 7 | Valid | cboValidYN | 단일 콤보 | dtValidYN(`biz:CommonData.YesOrNo`)일 가능성 | – |
| 8 | Input Status | cboInputStatus | 단일 콤보 | **확인 필요** | 값 `"C"`일 때 InsertButton 셀 콤보 설정, `"R"` 분기 존재 |

- 멀티선택 값은 GetCheckedListValue(CODE)로 FindData_Main(517, 518, 530~534)과 SetChangeControl(240)에 넘긴다. 어느 컨트롤이 어느 SP 파라미터로 가는지는 **확인 필요**다.
- 실제 화면 배치 순서는 Designer 선언 순과 다를 수 있다(Location 미추출).

## 2. 액션별 호출 API 후보
| 액션 | AS-IS 진입점 | AS-IS 호출 | TO-BE API 후보 |
|---|---|---|---|
| 조회 | FindButton | GetData_Country → `SCP0007_GET_COUNTRY_CITY`, FindData_Main → `SCP0007_GET_BOD` (순서 **확인 필요**) | 조회 call-proc 2건(Oracle 전환 SP) |
| 저장 | SaveButton | SaveData_Main → `SCP0007_SAVE_BOD` → 오류 시 ERR_MESSAGE 표시 → FindData_Main 재조회 | 저장 call-proc 1건 + 결과 메시지 판정 + 재조회 |
| 행 추가 | InsertButton | 엔드포인트 없음. DIVISION_ID, INCOTERMS, INCOTERMS_SSP 셀 콤보 설정(Input Status=`C`, 시트 `BOD`, 잠금 아님) | FE 그리드 행 추가 + 셀 콤보 데이터(Division, incotermsEdit) |
| 수정 | EditButton | 엔드포인트 없음. TO SITE_TYPE=`PLANT` 행의 INCOTERMS_SSP 콤보를 boolEditChange에 따라 incotermsEdit / LookupCommon `INCOTERMS`로 전환 | FE 셀 편집 제어 |
| From/To Site 변경 | dsdm.Changed → `SpdMain_Changed` > SetCityCode | `SCP0007_GET_ROUTE_CNT` → route_cnt. From/To의 COUNTRY, CITY, VMI_YN, SITE_TYPE 설정 | 셀 변경 시 Route 건수 조회 API |
| From Site 콤보 선택 | `SpdMain_ComboSelChange` | 엔드포인트 없음. TO_SITE_CODE 콤보를 필터 재바인딩(`sFromSite == "E"`, `"A" && OSP_YN == "Y"`) | FE 필터 로직(원천 To Site 목록) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | 엔드포인트 없음. OSP_YN, CITY 참조 | FE paste 처리 |
| 편집 변경 | `SpdMain_EditChange` | 엔드포인트 없음. TO SITE_TYPE 참조 | FE 셀 편집 처리 |
| 셀 더블클릭 | `spdMain_CellDoubleClick` | Route 관련 컬럼(ROUTE_ID 등) 반영. 팝업 호출은 **확인 필요** | Distribution Route 팝업 연동 |
| 팝업 로드/조회 | 팝업 `Form_Load`, FindButton, `btnButtonList_UsrButtonList_Click_Detected` | `SCP0005_GET_DISTRIBUTION_ROUTE` | 팝업 조회 call-proc |
| 팝업 도시 검색 | `btnFromSrch_Click`, `btnToSrch_Click` | popCity 결과(Country/City) → 텍스트 반영. 초기 Enabled=false | 도시 선택 팝업(초기 비활성) |
| 기타 | `SpdMain_TopChange`, `SpdMain_KeyPress`, 팝업 `spdMain_CellDoubleClick`, `spdMainDataModel_Changed` | 엔드포인트 없음 | 동작 **확인 필요** |

## 3. division별 Grid 변형 요약
| 시트 | 40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC |
|---|---|
| BOD | 모두 표시 34 / 숨김 5 (BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY). 차이 없음 |
| Distribution Route | 모두 33(코드추가). 차이 없음. DAYS_MON~SUN bVisible=false 7개는 **확인 필요** |

- division에 따라 표시를 바꾸는 코드 분기는 없다. 다만 DIVISION_ID 셀 콤보는 `GetDivisionWithoutEE`로 EE 계열을 빼는 것으로 보인다. 함수명에서 추정한 것이므로 **확인 필요**다.

## 4. 권한(C/R/U/D) 관련 사실
- TB_FX_GroupMenuAuth에 SCP0007 관련 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있다. 그룹별 C/R/U/D 값은 Fact Pack에 없다(**확인 필요**).
- 코드상 확인된 버튼 핸들러: FindButton(R), SaveButton(U/C/D 포함 여부 **확인 필요**), InsertButton(C), EditButton(U). DeleteButton 등 삭제 버튼은 Fact Pack에 없다.
- 저장 SP는 SCP_MST_BOD에 MERGE와 DELETE를 모두 실행하므로 저장 한 번에 C/U/D가 함께 처리될 수 있다. 행 상태별 분기는 **확인 필요**다.
- 사용자 그룹 기반 데이터 범위: `UserInfoContext.Current.NowGroupID`(메인 필드 55/60/63/64, 팝업 58), 공통코드 FromSiteByDivision/ToSiteByDivision/MyDivision의 TB_FX_USERGROUPAUTHEXTENTION 참조.
- 시트 잠금 검사: `siMain.IsLock(siMain.SheetName)`(InsertButton, ComboSelChange).

## 5. 미확정 사항
1. SCP0007_GET_BOD 동적 SQL의 결과 컬럼과 BOD 메타 39개 컬럼의 일치 여부(결과 시트 매칭 없음)
2. 메인 조회조건 각 체크리스트의 데이터 원천 엔드포인트(Division, From/To Site, Incoterms, SSP Incoterms, Trans Mode, Input Status)
3. FindButton 안에서의 호출 순서
4. 메인 더블클릭 → 팝업 호출 방식, 팝업 생성자 인자, 반환 컬럼 매핑
5. Distribution Route DAYS_* 7개 컬럼의 실제 표시 여부와 상단 그룹 헤더 문구
6. InitSpread:277 cellTypeImage 대상 컬럼
7. SAVE_BOD의 UPDATE:X 대상, 하위 SP 4종 전환 상태, #TMP 임시테이블 대체
8. `biz:CommonData.YesOrNo` 원천, `BLUtils.GetDivisionWithoutEE` 원천
9. TB_FX_GroupMenuAuth 13행의 권한 값, TB_FX_SearchCondition 473행의 조회조건 저장 구조
10. `route_cnt` 결과 키 대소문자, ERR_MESSAGE 결과셋 계약
