# AS-IS 액션 대조표 — FP00410

> 원천: `Doc/asisfacts/screens/FP00410/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 140행 · 메서드 18 · 종류 FLAG 49 · DATA_OP 24 · COMBO_DATA 15 · LIST_REBIND 15 · UI_PROP 7 · RETURN 6 · POPUP 4 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · ENDPOINT 2 · MESSAGE 1 · EXCEL 1 · THROW 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## FP00410_FCS_Aging_Routing.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef883d23 | this.btnSql.Click | FP00410_FCS_Aging_Routing.cs:331 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f4cc9d87 | this.btnSql.Click | FP00410_FCS_Aging_Routing.cs:332 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-14443d96 | this.btnSql.Click | FP00410_FCS_Aging_Routing.cs:334 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00410_FCS_AGING_ROUTING") | 데이터 객체 조작/조회 |  |  |  |
| AC-7eec1f93 | this.btnSql.Click | FP00410_FCS_Aging_Routing.cs:335 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00410_FCS_Aging_Routing.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2a58654 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:227 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-92db830d | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:228 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-21ca3e33 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:228 | if (sDataID.Contains(",")) | FLAG | pSite_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-c6ed73f4 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:229 | else of (sDataID.Contains(",")) | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-bc5be8de | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:230 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-1fbf9925 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:230 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8100a83a | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:231 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ba63fab4 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:234 |  | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c798dda | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:235 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2102403 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:235 | if (sDataID.Contains(",")) | FLAG | pPlant_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-7436a802 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:236 | else of (sDataID.Contains(",")) | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-175b616d | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:237 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-caaba31c | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:237 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7597f3ab | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-58a02564 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:240 |  | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-60225d0b | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:241 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f3b6a4e | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:241 | if (sDataID.Contains(",")) | FLAG | pFactory_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-9ac580f7 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:242 | else of (sDataID.Contains(",")) | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b6172627 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:244 |  | FLAG | dtRouteType | Data_FP.Common_FP(Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-39809a3a | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:244 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74e281b1 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:245 |  | LIST_REBIND | clsCtrl.setListBox | (dtRouteType, cboRouteType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-41cf35ad | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:247 |  | FLAG | dtRoute | Data_FP.Common_FP(Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae84d35a | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:247 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53cd88c8 | cboSite.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoute, cboRoute, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00410_FCS_Aging_Routing.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f32fcb | (진입점 미연결) | FP00410_FCS_Aging_Routing.cs:496 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00410_FCS_Aging_Routing.ClbFactory_SelectedIndexChanged

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be97066 | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:273 |  | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c60fda8 | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:274 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc10e8a | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:274 | if (sDataID.Contains(",")) | FLAG | pFactory_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-f1dcc48a | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:275 | else of (sDataID.Contains(",")) | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-91c384ba | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:277 |  | FLAG | dtRouteType | Data_FP.Common_FP(Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-37db7e1d | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:277 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07044ab9 | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:278 |  | LIST_REBIND | clsCtrl.setListBox | (dtRouteType, cboRouteType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8132ed5 | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:280 |  | FLAG | dtRoute | Data_FP.Common_FP(Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 화면 필드/플래그 변경 |  |  |  |
| AC-93c9aa9c | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:280 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-475bd9e0 | clbFactory.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:281 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoute, cboRoute, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00410_FCS_Aging_Routing.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b8b81c3 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:254 |  | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-567763bd | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:255 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-04c1167a | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:255 | if (sDataID.Contains(",")) | FLAG | pPlant_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e36522 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:256 | else of (sDataID.Contains(",")) | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1dbdec | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:257 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-5fbf79f9 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:257 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26ad7e5b | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-161e5c31 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:260 |  | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b58604a7 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:261 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6986d55 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:261 | if (sDataID.Contains(",")) | FLAG | pFactory_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-0aa21512 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:262 | else of (sDataID.Contains(",")) | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-cc8d69ce | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:264 |  | FLAG | dtRouteType | Data_FP.Common_FP(Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d4f63eb3 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:264 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-afdf5658 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:265 |  | LIST_REBIND | clsCtrl.setListBox | (dtRouteType, cboRouteType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cc03fd81 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:267 |  | FLAG | dtRoute | Data_FP.Common_FP(Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 화면 필드/플래그 변경 |  |  |  |
| AC-24038843 | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:267 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57f332ee | clbPlant.SelectedIndexChanged | FP00410_FCS_Aging_Routing.cs:268 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoute, cboRoute, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00410_FCS_Aging_Routing.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20be6b09 | this.Load | FP00410_FCS_Aging_Routing.cs:287 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ba8b134 | this.Load | FP00410_FCS_Aging_Routing.cs:288 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-22056c17 | this.Load | FP00410_FCS_Aging_Routing.cs:289 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00410_FCS_Aging_Routing.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e3a383 | this.Load | FP00410_FCS_Aging_Routing.cs:139 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28acc63a | this.Load | FP00410_FCS_Aging_Routing.cs:140 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-252153e7 | this.Load | FP00410_FCS_Aging_Routing.cs:141 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0f49f610 | this.Load | FP00410_FCS_Aging_Routing.cs:145 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ec1e9a06 | this.Load | FP00410_FCS_Aging_Routing.cs:146 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b0291ed1 | this.Load | FP00410_FCS_Aging_Routing.cs:147 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00410_FCS_Aging_Routing.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c5de1d | Dispose | FP00410_FCS_Aging_Routing.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00410_FCS_Aging_Routing.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68b0551c | EditButton | FP00410_FCS_Aging_Routing.cs:313 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35ad4c94 | EditButton | FP00410_FCS_Aging_Routing.cs:314 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00410_FCS_Aging_Routing.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2954ff26 | ExcelButton | FP00410_FCS_Aging_Routing.cs:324 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00410_FCS_Aging_Routing.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUTING")] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58b47248 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:418 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00410_FCS_AGING_ROUTING") ⇒ FP_Master.PR_UI_FP00410_FCS_AGING_ROUTING | 엔드포인트 요청 생성 |  |  |  |
| AC-d8ad5e1b | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:419 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-76cbee15 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:420 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3330a821 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:421 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-52d15163 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:422 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-955459c4 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:423 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-e32d30ee | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:425 | try | DATA_OP | request.Parameters["p_division_lt"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cd054c81 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:426 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-fab3b5a8 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:427 | try | DATA_OP | request.Parameters["p_plant_lt"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-3686df49 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:428 | try | DATA_OP | request.Parameters["p_factory_lt"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-0fa4f17b | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:429 | try | DATA_OP | request.Parameters["p_route_type"] | pRouteType.Equals("ALL") ? DBNull.Value : pRouteType | 행/컬럼 값 대입 |  |  |  |
| AC-7141b28f | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:430 | try | DATA_OP | request.Parameters["p_route_id"] | pRoute.Equals("ALL") ? DBNull.Value : pRoute | 행/컬럼 값 대입 |  |  |  |
| AC-e6c14571 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:431 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-36587022 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:432 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-e172fd43 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:434 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4169a427 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:436 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-de630863 | popSql.OnSql [if (programID == "PR_UI_FP00410_FCS_AGING_ROUT… 외 1 | FP00410_FCS_Aging_Routing.cs:443 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00410_FCS_Aging_Routing.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cf23797 | FindButton | FP00410_FCS_Aging_Routing.cs:344 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9126caea | FindButton | FP00410_FCS_Aging_Routing.cs:348 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-65c790dd | FindButton | FP00410_FCS_Aging_Routing.cs:348 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb80b5be | FindButton | FP00410_FCS_Aging_Routing.cs:354 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5d0cb7aa | FindButton | FP00410_FCS_Aging_Routing.cs:367 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e5dd5f2d | FindButton | FP00410_FCS_Aging_Routing.cs:369 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d7e6b6e | FindButton | FP00410_FCS_Aging_Routing.cs:372 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cc52eb22 | FindButton | FP00410_FCS_Aging_Routing.cs:385 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00410_FCS_Aging_Routing.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0a6f46 | this.Load | FP00410_FCS_Aging_Routing.cs:118 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00410_FCS_Aging_Routing.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ddf3bdd | this.Load | FP00410_FCS_Aging_Routing.cs:154 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2ebdad2 | this.Load | FP00410_FCS_Aging_Routing.cs:156 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4fe101b | this.Load | FP00410_FCS_Aging_Routing.cs:159 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-92a33ca2 | this.Load | FP00410_FCS_Aging_Routing.cs:160 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-be12de73 | this.Load | FP00410_FCS_Aging_Routing.cs:161 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-524c1859 | this.Load | FP00410_FCS_Aging_Routing.cs:161 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbc64f73 | this.Load | FP00410_FCS_Aging_Routing.cs:162 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00410_FCS_Aging_Routing.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d6a7084 | this.Load | FP00410_FCS_Aging_Routing.cs:206 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ab43277f | this.Load | FP00410_FCS_Aging_Routing.cs:207 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2d5bbe9d | this.Load | FP00410_FCS_Aging_Routing.cs:208 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00410_FCS_Aging_Routing.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f3da3ca | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:296 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-31c3599c | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:298 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00410_FCS_Aging_Routing.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f72d1f8 | popSql.OnSql | FP00410_FCS_Aging_Routing.cs:458 | if (programID == "PR_UI_FP00410_FCS_AGING_ROUTING") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-1a5ddf38 | popSql.OnSql | FP00410_FCS_Aging_Routing.cs:461 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00410_FCS_Aging_Routing.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a293b5bb | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:171 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-343b011a | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:172 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-749fa6e1 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:172 | if (sDataID.Contains(",")) | FLAG | pDivision_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-00f99b8d | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:173 | else of (sDataID.Contains(",")) | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-5daa03a0 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:174 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8ff81a64 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:174 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-826dfd9a | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2923021 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:178 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-af7ce79e | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:179 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-91876cde | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:179 | if (sDataID.Contains(",")) | FLAG | pSite_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-9187af0a | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:180 | else of (sDataID.Contains(",")) | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-11a70123 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:181 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-213f0ca3 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:181 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2458e483 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b704495a | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:185 |  | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2cda4569 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:186 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-01198c54 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:186 | if (sDataID.Contains(",")) | FLAG | pPlant_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-994e367d | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:187 | else of (sDataID.Contains(",")) | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-24839e60 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:188 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-52cd33a4 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:188 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22a818d3 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fd357211 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:191 |  | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-7af5ae45 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:192 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e728c7b | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:192 | if (sDataID.Contains(",")) | FLAG | pFactory_LT | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-c7737edb | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:193 | else of (sDataID.Contains(",")) | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-37293137 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:195 |  | FLAG | dtRouteType | Data_FP.Common_FP(Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-847b75c3 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:195 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63308357 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtRouteType, cboRouteType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e3bd534c | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:198 |  | FLAG | dtRoute | Data_FP.Common_FP(Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7d2ed584 | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:198 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ROUTE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ROUTE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-196fe4fd | this.Load 외 1 | FP00410_FCS_Aging_Routing.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoute, cboRoute, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

