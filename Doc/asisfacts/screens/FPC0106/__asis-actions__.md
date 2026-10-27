# AS-IS 액션 대조표 — FPC0106

> 원천: `Doc/asisfacts/screens/FPC0106/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 30행 · 메서드 11 · 종류 GRID_INIT 7 · FLAG 5 · UI_MISC 4 · STATE 4 · POPUP 2 · CALL_EXT 2 · CALL_BASE 2 · UI_PROP 1 · COMBO_DATA 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 4


## FPC0106_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0538cd8f | .ctor | FPC0106_PlanInfoPopup.cs:117 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-815cedb0 | .ctor | FPC0106_PlanInfoPopup.cs:118 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0106_PlanInfoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e881fff2 | this.btnClose.Click | FPC0106_PlanInfoPopup.cs:306 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0106_PlanInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5abdbf3a | this.Load | FPC0106_PlanInfoPopup.cs:155 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-068acaef | this.Load | FPC0106_PlanInfoPopup.cs:156 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-74b34eb1 | this.Load | FPC0106_PlanInfoPopup.cs:157 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0106_PlanInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30ecf2d3 | this.Load | FPC0106_PlanInfoPopup.cs:150 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0106_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d06b797f | Dispose | FPC0106_PlanInfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0106_PlanInfoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89e6e404 | FindButton | FPC0106_PlanInfoPopup.cs:190 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7d574e22 | FindButton | FPC0106_PlanInfoPopup.cs:191 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-84576698 | FindButton | FPC0106_PlanInfoPopup.cs:193 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0106_PlanInfoPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0170042 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:227 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-864fce98 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:227 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9df91d0 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:231 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c4786aee | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:232 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de45ce65 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:239 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a54c67f7 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:244 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LATEST_RELEASE_PLAN_INFO, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LATEST_RELEASE_PLAN_INFO] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca062dcf | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:250 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-842bbe67 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:252 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f63861a3 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:253 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-04d1cf4f | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:263 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca87e84d | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:266 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-324e82a2 | this.Load 외 1 | FPC0106_PlanInfoPopup.cs:267 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0106_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c8ddafb | this.Load | FPC0106_PlanInfoPopup.cs:126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-37289506 | this.Load | FPC0106_PlanInfoPopup.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0106_PlanInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-073857da | this.Load | FPC0106_PlanInfoPopup.cs:166 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a0c4af1f | this.Load | FPC0106_PlanInfoPopup.cs:169 | if (Filter["CONFIRM_AREA"].ToString() != "BUILDING") | GRID_INIT | siMain.SetColumnHeader | (0, 1, "Plan Group") | 그리드 재구성/초기화 |  |  |  |

## FPC0106_PlanInfoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab3bb00a | (진입점 미연결) | FPC0106_PlanInfoPopup.cs:181 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0106_PlanInfoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e90f178 | this.Load | FPC0106_PlanInfoPopup.cs:175 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34f90d08 | this.Load | FPC0106_PlanInfoPopup.cs:176 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

