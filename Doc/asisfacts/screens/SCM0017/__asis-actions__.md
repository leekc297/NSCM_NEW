# AS-IS 액션 대조표 — SCM0017

> 원천: `Doc/asisfacts/screens/SCM0017/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 42행 · 메서드 9 · 종류 POPUP 8 · GRID_INIT 6 · UI_PROP 5 · UI_MISC 5 · ENDPOINT 3 · DATA_OP 3 · VALUE_SET 2 · FLAG 2 · VALIDATE 2 · RETURN 2 · GRID_BIND 1 · GRID_LOCK 1 · MESSAGE 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 0


## SCM0017_ValidationBOM.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-533ff5d4 | this.btnItemId.Click | SCM0017_ValidationBOM.cs:235 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de4bec35 | this.btnItemId.Click | SCM0017_ValidationBOM.cs:237 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1bbb1ac4 | this.btnItemId.Click | SCM0017_ValidationBOM.cs:238 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cac4441d | this.btnItemId.Click | SCM0017_ValidationBOM.cs:239 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cb0ede2d | this.btnItemId.Click | SCM0017_ValidationBOM.cs:244 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCM0017_ValidationBOM.BtnProject_Click

진입점: this.btnProjectID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b6a8708 | this.btnProjectID.Click | SCM0017_ValidationBOM.cs:253 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-db4b031a | this.btnProjectID.Click | SCM0017_ValidationBOM.cs:254 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0278953e | this.btnProjectID.Click | SCM0017_ValidationBOM.cs:255 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aa8776bd | this.btnProjectID.Click | SCM0017_ValidationBOM.cs:256 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a9132147 | this.btnProjectID.Click | SCM0017_ValidationBOM.cs:261 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCM0017_ValidationBOM.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aba6613d | this.Load | SCM0017_ValidationBOM.cs:115 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-484a0194 | this.Load | SCM0017_ValidationBOM.cs:116 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-20e833d3 | this.Load | SCM0017_ValidationBOM.cs:117 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0017_ValidationBOM.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-272e98d7 | this.Load | SCM0017_ValidationBOM.cs:97 |  | UI_PROP | usrConditionPanel1.Height | 50 | 속성 Height 설정 |  |  |  |

## SCM0017_ValidationBOM.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7ff989c | Dispose | SCM0017_ValidationBOM.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0017_ValidationBOM.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8dc944c | FindButton | SCM0017_ValidationBOM.cs:161 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-7b11256c | FindButton | SCM0017_ValidationBOM.cs:161 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-876f904d | FindButton | SCM0017_ValidationBOM.cs:163 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c7bc802f | FindButton | SCM0017_ValidationBOM.cs:167 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-48011e25 | FindButton | SCM0017_ValidationBOM.cs:179 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-427b004c | FindButton | SCM0017_ValidationBOM.cs:180 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Validation.WSL/FoxDataSer… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c34c6a2d | FindButton | SCM0017_ValidationBOM.cs:184 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0017_GET_VALIDATION_BOM") ⇒ SCM.SCM0017_GET_VALIDATION_BOM | 엔드포인트 요청 생성 |  |  |  |
| AC-cab0034a | FindButton | SCM0017_ValidationBOM.cs:185 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-448b8470 | FindButton | SCM0017_ValidationBOM.cs:186 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-c7863661 | FindButton | SCM0017_ValidationBOM.cs:187 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | pProject | 행/컬럼 값 대입 |  |  |  |
| AC-74edd68b | FindButton | SCM0017_ValidationBOM.cs:188 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-151e7305 | FindButton | SCM0017_ValidationBOM.cs:190 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-50916aaf | FindButton | SCM0017_ValidationBOM.cs:192 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-55c3e4d0 | FindButton | SCM0017_ValidationBOM.cs:199 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-53d4f4e0 | FindButton | SCM0017_ValidationBOM.cs:200 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e6d78425 | FindButton | SCM0017_ValidationBOM.cs:203 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-98d3dfd1 | FindButton | SCM0017_ValidationBOM.cs:206 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f51b585c | FindButton | SCM0017_ValidationBOM.cs:208 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7250185d | FindButton | SCM0017_ValidationBOM.cs:210 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a1dd8c4 | FindButton | SCM0017_ValidationBOM.cs:213 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCM0017_ValidationBOM.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bc3b005 | this.Load | SCM0017_ValidationBOM.cs:79 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0017_ValidationBOM.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75b596a9 | this.Load | SCM0017_ValidationBOM.cs:103 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-59a7560e | this.Load | SCM0017_ValidationBOM.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb208ace | this.Load | SCM0017_ValidationBOM.cs:107 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0017_ValidationBOM.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af47f264 | this.Load 외 1 | SCM0017_ValidationBOM.cs:124 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1ae01c60 | this.Load 외 1 | SCM0017_ValidationBOM.cs:125 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e2c5b3bf | this.Load 외 1 | SCM0017_ValidationBOM.cs:126 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

