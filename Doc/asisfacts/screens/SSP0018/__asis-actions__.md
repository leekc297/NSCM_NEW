# AS-IS 액션 대조표 — SSP0018

> 원천: `Doc/asisfacts/screens/SSP0018/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 156행 · 메서드 28 · 종류 DATA_OP 26 · GRID_INIT 18 · FLAG 15 · POPUP 14 · RETURN 14 · GRID_SET 14 · ENDPOINT 13 · UI_PROP 12 · UI_MISC 6 · GRID_LOCK 5 · LIST_REBIND 4 · VALUE_SET 3 · MESSAGE 3 · VALIDATE 3 · GRID_COMBO 2 · GRID_BIND 1 · STATE 1 · CALL_EXT 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 1


## SSP0018_ProductionPlanOSP.btnEaxel_Upload_Click

진입점: this.btnEaxel_Upload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-225a598c | this.btnEaxel_Upload.Click | SSP0018_ProductionPlanOSP.cs:393 |  | POPUP | new ExcelUploadForm2 | ("SSP0018", this.spdMain.ActiveSheet.SheetName, "NUM") | 팝업/폼 생성 |  |  |  |
| AC-34ac1d15 | this.btnEaxel_Upload.Click | SSP0018_ProductionPlanOSP.cs:394 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-4428b8d8 | this.btnEaxel_Upload.Click | SSP0018_ProductionPlanOSP.cs:395 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-89ed5188 | this.btnEaxel_Upload.Click | SSP0018_ProductionPlanOSP.cs:396 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0018_ProductionPlanOSP.btnItemId_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71f8509e | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:510 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-34417e61 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:512 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f3651ff0 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:513 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e2fccfa | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:514 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6ba03728 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:520 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0018_ProductionPlanOSP.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-837cd6ef | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:535 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff2c2a55 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:536 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7df0932 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:541 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-707baab0 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:542 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51334fa2 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:545 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0001", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-a1b2d1a0 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:546 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ee5c36d | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:547 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-db6061df | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:551 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-d9e6c7f2 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:553 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0018_ProductionPlanOSP.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8de7630c | this.Load | SSP0018_ProductionPlanOSP.cs:170 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e1e38ab7 | this.Load | SSP0018_ProductionPlanOSP.cs:172 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-881e4a77 | this.Load | SSP0018_ProductionPlanOSP.cs:173 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0018_ProductionPlanOSP.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e19b4a34 | this.Load | SSP0018_ProductionPlanOSP.cs:128 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-76ed4cf5 | this.Load | SSP0018_ProductionPlanOSP.cs:130 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-7c214514 | this.Load | SSP0018_ProductionPlanOSP.cs:131 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-d93575f5 | this.Load | SSP0018_ProductionPlanOSP.cs:132 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0018_ProductionPlanOSP.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ea2703f | DeleteButton | SSP0018_ProductionPlanOSP.cs:433 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0018_ProductionPlanOSP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b825a4d | Dispose | SSP0018_ProductionPlanOSP.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0018_ProductionPlanOSP.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e3feb5 | EditButton | SSP0018_ProductionPlanOSP.cs:439 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-455fd4f2 | EditButton | SSP0018_ProductionPlanOSP.cs:440 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b88935b2 | EditButton | SSP0018_ProductionPlanOSP.cs:442 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0018_ProductionPlanOSP.FindData_Main

진입점: this.btnEaxel_Upload.Click / FindButton / SaveButton [if (SaveData() == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6261c87 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:775 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-68461d89 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:780 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-60e0b98e | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:780 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3fd7c83 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:782 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a8de1880 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:802 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-26f60c22 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:803 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83ba8bc3 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:807 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0018_GET_PRODUCTION_PLAN_OSP") ⇒ SSP.SSP0018_GET_PRODUCTION_PLAN_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-71d20bdd | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:809 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-408cf2e2 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:811 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3804b640 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:812 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-1d1e53b3 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:813 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f91d8826 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:814 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9fca8fca | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:815 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fd91d4b9 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:816 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f293c36 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:817 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-caae9d3f | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:818 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-c6968348 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:821 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f18de4c | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:822 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f3db687f | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:833 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-752777de | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:834 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-75d3997e | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:838 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c04fe389 | this.btnEaxel_Upload.Click 외 2 | SSP0018_ProductionPlanOSP.cs:845 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0018_ProductionPlanOSP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efb78ff2 | this.Load | SSP0018_ProductionPlanOSP.cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0018_ProductionPlanOSP.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f8b1340 | this.Load | SSP0018_ProductionPlanOSP.cs:162 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-31eb6805 | this.Load | SSP0018_ProductionPlanOSP.cs:163 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5106922e | this.Load | SSP0018_ProductionPlanOSP.cs:165 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85dff398 | this.Load | SSP0018_ProductionPlanOSP.cs:909 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-02c8f2d5 | this.Load | SSP0018_ProductionPlanOSP.cs:910 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-4f603d99 | this.Load | SSP0018_ProductionPlanOSP.cs:911 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-7fa7786b | this.Load | SSP0018_ProductionPlanOSP.cs:912 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-d92f9ad5 | this.Load | SSP0018_ProductionPlanOSP.cs:913 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-160dae93 | this.Load | SSP0018_ProductionPlanOSP.cs:916 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38098fc5 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:875 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-119dfec2 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:876 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc08ce3a | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:879 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47386361 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:891 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-048e6426 | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:885 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c45d76e | (진입점 미연결) | SSP0018_ProductionPlanOSP.cs:897 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.GetSpdTitle

진입점: this.Load / this.btnEaxel_Upload.Click / FindButton / SaveButton [if (SaveData() == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c74db4 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:207 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-0ba79d28 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:208 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2732ffde | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:209 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-d4509947 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:210 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1ab31241 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:210 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0018_ProductionPlanOSP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-252be663 | this.Load | SSP0018_ProductionPlanOSP.cs:138 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d47d35a | this.Load | SSP0018_ProductionPlanOSP.cs:141 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-5601a74b | this.Load | SSP0018_ProductionPlanOSP.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a807d03 | this.Load | SSP0018_ProductionPlanOSP.cs:145 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-d502bc2c | this.Load | SSP0018_ProductionPlanOSP.cs:146 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d75460cc | this.Load | SSP0018_ProductionPlanOSP.cs:150 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a937b1e3 | this.Load | SSP0018_ProductionPlanOSP.cs:152 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-130cea6d | this.Load | SSP0018_ProductionPlanOSP.cs:153 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0018_ProductionPlanOSP.InitSpread

진입점: this.Load / this.btnEaxel_Upload.Click / FindButton / SaveButton [if (SaveData() == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dce9f25 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:184 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-7647f6c2 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:187 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("ProductionPlanOSP", dtPlantSiteByDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-afe4c5cf | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:188 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-9ddd3ff3 | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:194 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7830095d | this.Load 외 4 | SSP0018_ProductionPlanOSP.cs:195 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0018_ProductionPlanOSP.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnEaxel_Upload.Click [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (SaveData() == true) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ac8b91 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:253 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbd4fecd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:257 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33d6ab11 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:261 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4999bbd4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:268 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6591f482 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:269 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1dc8d8a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:274 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f551dc7a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:275 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4cecf31 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:283 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e382b16d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:284 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a0613d7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:294 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf5b62dc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:295 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e9fdf3e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:296 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf5a01cb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0018_ProductionPlanOSP.cs:297 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0018_ProductionPlanOSP.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6e54cf6 | InsertButton | SSP0018_ProductionPlanOSP.cs:454 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4210949b | InsertButton | SSP0018_ProductionPlanOSP.cs:457 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-28ce960a | InsertButton | SSP0018_ProductionPlanOSP.cs:458 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE), dtPlantSiteByDivisio… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0e0594d0 | InsertButton | SSP0018_ProductionPlanOSP.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, pDivisionID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a32786d1 | InsertButton | SSP0018_ProductionPlanOSP.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PLANT_SITE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d2a9824 | InsertButton | SSP0018_ProductionPlanOSP.cs:473 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-656c94a5 | InsertButton | SSP0018_ProductionPlanOSP.cs:475 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-de747839 | InsertButton | SSP0018_ProductionPlanOSP.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0018_ProductionPlanOSP.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-345cd52a | SaveButton | SSP0018_ProductionPlanOSP.cs:567 | else of (SaveData() == true) ▸ if (bSaveCheck == true) | MESSAGE | MessageBox.Show | (errorMsg, errCode, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## SSP0018_ProductionPlanOSP.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae769c8 | SaveButton | SSP0018_ProductionPlanOSP.cs:579 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d57d23e0 | SaveButton | SSP0018_ProductionPlanOSP.cs:581 | if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8180b3e9 | SaveButton | SSP0018_ProductionPlanOSP.cs:582 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-afd1c97e | SaveButton | SSP0018_ProductionPlanOSP.cs:586 | else of (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c8c2f378 | SaveButton | SSP0018_ProductionPlanOSP.cs:589 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-31002ed1 | SaveButton | SSP0018_ProductionPlanOSP.cs:590 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-43c7d6b2 | SaveButton | SSP0018_ProductionPlanOSP.cs:603 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-956f61af | SaveButton | SSP0018_ProductionPlanOSP.cs:662 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0018_SAVE_PRODUCTION_PLAN_OSP") ⇒ SSP.SSP0018_SAVE_PRODUCTION_PLAN_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-37a0730c | SaveButton | SSP0018_ProductionPlanOSP.cs:664 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-228406f9 | SaveButton | SSP0018_ProductionPlanOSP.cs:665 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2965dc8 | SaveButton | SSP0018_ProductionPlanOSP.cs:666 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-494752c0 | SaveButton | SSP0018_ProductionPlanOSP.cs:667 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_model"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-41c9a76c | SaveButton | SSP0018_ProductionPlanOSP.cs:668 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-84b06908 | SaveButton | SSP0018_ProductionPlanOSP.cs:669 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_qtys"] | p_qtys | 행/컬럼 값 대입 |  |  |  |
| AC-83adb2bc | SaveButton | SSP0018_ProductionPlanOSP.cs:670 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_now_date"] | p_now_date | 행/컬럼 값 대입 |  |  |  |
| AC-d2a2841f | SaveButton | SSP0018_ProductionPlanOSP.cs:671 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-44602054 | SaveButton | SSP0018_ProductionPlanOSP.cs:673 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92db5881 | SaveButton | SSP0018_ProductionPlanOSP.cs:684 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | FLAG | errorMsg | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ba8ad5de | SaveButton | SSP0018_ProductionPlanOSP.cs:686 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | FLAG | errCode | dtErr.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6ad15afd | SaveButton | SSP0018_ProductionPlanOSP.cs:688 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | FLAG | errorMsg | += "Error!" + "\n" | 화면 필드/플래그 변경 |  |  |  |
| AC-dc7b8859 | SaveButton | SSP0018_ProductionPlanOSP.cs:689 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxR… | FLAG | errorMsg | += "Msg : " + dtErr.Rows[0]["ERR_MESSAGE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6cc5a3c3 | SaveButton | SSP0018_ProductionPlanOSP.cs:698 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-06847a47 | SaveButton | SSP0018_ProductionPlanOSP.cs:699 | try | RETURN | return returnStatus; |  | 처리 중단/반환 |  |  |  |
| AC-eb90c25f | SaveButton | SSP0018_ProductionPlanOSP.cs:703 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3f2f5d8 | SaveButton | SSP0018_ProductionPlanOSP.cs:704 | catch ((Exception ex)) | FLAG | errorMsg | ex.Message | 화면 필드/플래그 변경 |  |  |  |
| AC-224c2757 | SaveButton | SSP0018_ProductionPlanOSP.cs:705 | catch ((Exception ex)) | FLAG | errCode | ex.Source | 화면 필드/플래그 변경 |  |  |  |
| AC-6795cc88 | SaveButton | SSP0018_ProductionPlanOSP.cs:706 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0018_ProductionPlanOSP.SetChangedControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54c58573 | this.Load 외 1 | SSP0018_ProductionPlanOSP.cs:765 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0018_ProductionPlanOSP.SetImageCell

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77c58353 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | SSP0018_ProductionPlanOSP.cs:497 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0018_ProductionPlanOSP.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.btnEaxel_Upload.Click [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (SaveData() == true) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bb81198 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:723 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-eaab23f7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:728 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-16e96d27 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:735 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9e7a9305 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:739 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ae2dae17 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:744 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f6b1f947 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:751 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-789964fd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0018_ProductionPlanOSP.cs:755 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0018_ProductionPlanOSP.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e264b3e0 | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:326 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4360a6bc | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:339 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_ElectrodeItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-596156c0 | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:340 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (sdivision) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9741f77d | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:341 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f4f9bf14 | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:342 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8a861fda | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:348 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-eeedec43 | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:350 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-e96f5511 | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:356 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE)) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ProductionPlanOSP, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f72799be | this.spdMain.CellDoubleClick | SSP0018_ProductionPlanOSP.cs:356 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE)) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ProductionPlanOSP, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SSP0018_ProductionPlanOSP.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31e682c6 | this.spdMain.EditChange | SSP0018_ProductionPlanOSP.cs:371 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (null == pItemId \|\| "" == pItemId) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-15a66143 | this.spdMain.EditChange | SSP0018_ProductionPlanOSP.cs:375 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == pItemId \|\| "" == pItemId) | DATA_OP | dsItemBinding.Select | ("ITEM_ID = '" + pItemId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8adefd30 | this.spdMain.EditChange | SSP0018_ProductionPlanOSP.cs:379 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == pItemId \|\| "" == pItemId) ▸ if (drs.Length != 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNick_Name) | 그리드 값 설정 |  |  |  |

