# AS-IS 액션 대조표 — FPC0108

> 원천: `Doc/asisfacts/screens/FPC0108/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 33행 · 메서드 12 · 종류 GRID_INIT 6 · GRID_SET 6 · FLAG 5 · UI_MISC 4 · CALL_EXT 3 · POPUP 2 · STATE 2 · UI_PROP 1 · ENDPOINT 1 · LIST_BIND 1 · CALL_BASE 1 · DATA_OP 1 · ⚠ 의미 확인 필요 4


## FPC0108_btn_setupinfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b6caa4 | .ctor | FPC0108_btn_setupinfoPopup.cs:120 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-4351d880 | .ctor | FPC0108_btn_setupinfoPopup.cs:122 |  | FLAG | INSTANCE_ID | param | 화면 필드/플래그 변경 |  |  |  |
| AC-0dc9c562 | .ctor | FPC0108_btn_setupinfoPopup.cs:124 |  | FLAG | this.Title | "Setup Color Info" | 화면 필드/플래그 변경 |  |  |  |

## FPC0108_btn_setupinfoPopup.btnClose_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ffbab69 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:320 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0108_btn_setupinfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f6fb9bc | this.Load | FPC0108_btn_setupinfoPopup.cs:159 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0108_btn_setupinfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbc34a0a | this.Load | FPC0108_btn_setupinfoPopup.cs:154 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0108_btn_setupinfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c62745cb | Dispose | FPC0108_btn_setupinfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0108_btn_setupinfoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c75d5ad | FindButton | FPC0108_btn_setupinfoPopup.cs:199 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-03c1474a | FindButton | FPC0108_btn_setupinfoPopup.cs:200 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cd3c66bb | FindButton | FPC0108_btn_setupinfoPopup.cs:202 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0108_btn_setupinfoPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-792484b8 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:236 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-42dec847 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:236 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-32849705 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:240 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a11bf017 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:248 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-223e872b | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:253 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_SetupColor_P", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f2a4db7e | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:256 | try | LIST_BIND | spdMain.DataSource | colorInfo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-3e2ec02d | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:260 | try ▸ for (i < spdMain.Sheets[0].Rows.Count) | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66ca46c3 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:262 | try ▸ for (i < spdMain.Sheets[0].Rows.Count) | GRID_SET | spdMain.ActiveSheet.Cells[i, 0].BackColor | color | 그리드 속성/값 설정 |  |  |  |
| AC-fc00af55 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:263 | try ▸ for (i < spdMain.Sheets[0].Rows.Count) | GRID_SET | spdMain.ActiveSheet.Cells[i, 0].Text | string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-fc0b423f | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:265 | try | GRID_SET | spdMain.ActiveSheet.Columns[0].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-90c1fd79 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:266 | try | GRID_SET | spdMain.ActiveSheet.Columns[1].Width | 250 | 그리드 속성/값 설정 |  |  |  |
| AC-4030f7ee | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:267 | try | GRID_SET | spdMain.ActiveSheet.ColumnHeaderVisible | false | 그리드 속성/값 설정 |  |  |  |
| AC-384996c1 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:268 | try | GRID_SET | spdMain.ActiveSheet.RowHeader.Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-871dccf4 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:280 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; //this.btnC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a90c8f2 | this.Load 외 1 | FPC0108_btn_setupinfoPopup.cs:283 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0108_btn_setupinfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cbd9648 | this.Load | FPC0108_btn_setupinfoPopup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b4e6898 | this.Load | FPC0108_btn_setupinfoPopup.cs:132 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0108_btn_setupinfoPopup.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80709384 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:170 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7af82a48 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:173 | if (Filter["CONFIRM_AREA"].ToString() != "BUILDING") | GRID_INIT | siMain.SetColumnHeader | (0, 1, "Plan Group") | 그리드 재구성/초기화 |  |  |  |

## FPC0108_btn_setupinfoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aef48a7 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:185 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0108_btn_setupinfoPopup.SetFilter

진입점: this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dca4bcc | this.Load [try] 외 1 | FPC0108_btn_setupinfoPopup.cs:190 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FPC0108_btn_setupinfoPopup.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a23fb8 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:179 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c558e997 | (진입점 미연결) | FPC0108_btn_setupinfoPopup.cs:180 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

