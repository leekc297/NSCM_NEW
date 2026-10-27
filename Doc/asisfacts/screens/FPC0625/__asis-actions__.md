# AS-IS 액션 대조표 — FPC0625

> 원천: `Doc/asisfacts/screens/FPC0625/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 166행 · 메서드 23 · 종류 DATA_OP 50 · GRID_INIT 31 · FLAG 25 · UI_MISC 13 · RETURN 10 · GRID_LOCK 7 · MESSAGE 6 · ENDPOINT 5 · UI_PROP 4 · GRID_BIND 3 · CALL_EXT 3 · VALUE_SET 3 · POPUP 1 · LIST_BIND 1 · CALL_BASE 1 · VALIDATE 1 · THROW 1 · GRID_SET 1 · ⚠ 의미 확인 필요 4


## FPC0625_AttrOptionEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59bee811 | .ctor | FPC0625_AttrOptionEditPopup.cs:136 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-6f3d8388 | .ctor | FPC0625_AttrOptionEditPopup.cs:137 |  | FLAG | InstanceId | _InstanceId | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e1a9ec | .ctor | FPC0625_AttrOptionEditPopup.cs:138 |  | FLAG | InstanceName | _InstanceName | 화면 필드/플래그 변경 |  |  |  |
| AC-9d7815e0 | .ctor | FPC0625_AttrOptionEditPopup.cs:139 |  | FLAG | OperationId | _OperationID | 화면 필드/플래그 변경 |  |  |  |
| AC-5f51a207 | .ctor | FPC0625_AttrOptionEditPopup.cs:140 |  | FLAG | AttrType | _AttrType | 화면 필드/플래그 변경 |  |  |  |
| AC-6febaae9 | .ctor | FPC0625_AttrOptionEditPopup.cs:141 |  | FLAG | AttrName | _AttrName | 화면 필드/플래그 변경 |  |  |  |

## FPC0625_AttrOptionEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-210737ff | this.btnButtonList.UsrButtonList_Click_Detected | FPC0625_AttrOptionEditPopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-971b17b2 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0625_AttrOptionEditPopup.cs:271 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8e3600bb | this.btnButtonList.UsrButtonList_Click_Detected | FPC0625_AttrOptionEditPopup.cs:272 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ec1ec42 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0625_AttrOptionEditPopup.cs:717 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0625_AttrOptionEditPopup.CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66234216 | (진입점 미연결) | FPC0625_AttrOptionEditPopup.cs:622 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-5aaaf571 | (진입점 미연결) | FPC0625_AttrOptionEditPopup.cs:624 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0625_AttrOptionEditPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f491fc8b | this.Load | FPC0625_AttrOptionEditPopup.cs:128 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c792152 | this.Load | FPC0625_AttrOptionEditPopup.cs:129 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb07f6be | this.Load | FPC0625_AttrOptionEditPopup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-192e212c | this.Load | FPC0625_AttrOptionEditPopup.cs:181 |  | GRID_INIT | this.AddSheet | (spdList, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e24f0b83 | this.Load | FPC0625_AttrOptionEditPopup.cs:182 |  | FLAG | siList | GetSheetInfo(spdList.Name, spdList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdaad760 | this.Load | FPC0625_AttrOptionEditPopup.cs:183 |  | GRID_INIT | siList.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0625_AttrOptionEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba306173 | this.Load | FPC0625_AttrOptionEditPopup.cs:123 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-bb83141f | this.Load | FPC0625_AttrOptionEditPopup.cs:176 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0625_AttrOptionEditPopup.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0463a996 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:243 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-508c2886 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:244 |  | DATA_OP | siList.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FPC0625_AttrOptionEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfed9378 | Dispose | FPC0625_AttrOptionEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-4c3c2b59 | Dispose | FPC0625_AttrOptionEditPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0625_AttrOptionEditPopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / InsertButton [if (fps!=null) ▸ if (siList.IsLock(SpdSheet.shtMain))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac6f43f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0625_AttrOptionEditPopup.cs:253 | if (fps != null) | FLAG | siList | GetSheetInfo(spdList.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-01d33ce1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0625_AttrOptionEditPopup.cs:254 | if (fps != null) | GRID_LOCK | siList.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9eab1856 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0625_AttrOptionEditPopup.cs:256 | if (fps != null) | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.INSTANCE_ID), siList.GetColumnIndex("ATTRIBUTE_NAME"), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d141df6b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0625_AttrOptionEditPopup.cs:257 | if (fps != null) | GRID_LOCK | siList.LockColumn | (siList.GetColumnIndex(DefColumns.UPDATE_ID), siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0625_AttrOptionEditPopup.Find_Data_Item

진입점: this.Load [try ▸ lambda] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-035f9039 | this.Load [try ▸ lambda] 외 2 | FPC0625_AttrOptionEditPopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_material_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_material_list] \| FP\Master… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-622b3866 | this.Load [try ▸ lambda] 외 2 | FPC0625_AttrOptionEditPopup.cs:239 |  | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |

## FPC0625_AttrOptionEditPopup.FindAttrList

진입점: this.Load [try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / SaveButton [if (res.Good()) ▸ if (cnt > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dea57c9 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:369 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0c9a6c8b | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:383 | try | FLAG | dsList | FindAttrList("SELECT", index) | 화면 필드/플래그 변경 |  |  |  |
| AC-e029b776 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:391 | try ▸ else of (!dsList.Good()) | FLAG | siList | GetSheetInfo(spdList.Name, spdList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2134ae4 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:393 | try ▸ else of (!dsList.Good()) | GRID_BIND | siList.Query | (dsList, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-439c4156 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:394 | try ▸ else of (!dsList.Good()) | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b1c3f9f | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:401 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2604f116 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:406 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c5ee4baa | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:413 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-ea0abce3 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:416 | try | FLAG | LastAttrTypeIdx | attrTypeIdx | 화면 필드/플래그 변경 |  |  |  |
| AC-f9ea8ed5 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:417 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | InstanceId | 행/컬럼 값 대입 |  |  |  |
| AC-27451b21 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:418 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | OperationId | 행/컬럼 값 대입 |  |  |  |
| AC-5f2945ea | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:419 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-6b1726b4 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:420 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0cfbe77b | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:426 | try ▸ try | DATA_OP | dsResult.Tables[0].Select().Where(s => s["ATTRIBUTE_TYPE"].SafeString() == AttrType).CopyT… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a24cfbd7 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:426 | try ▸ try | DATA_OP | dsResult.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42a2c0c2 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:428 | try ▸ try | UI_PROP | ret.TableName | "ret" | 속성 TableName 설정 |  |  |  |
| AC-15783f21 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:429 | try ▸ try | DATA_OP | retSet.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-45cfc2df | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:433 | try ▸ catch ((Exception e)) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3fdf2f1d | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:436 | try | RETURN | return retSet; |  | 처리 중단/반환 |  |  |  |
| AC-da6bc165 | this.Load [try] 외 2 | FPC0625_AttrOptionEditPopup.cs:440 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0625_AttrOptionEditPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6b21dea | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:201 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3b8eca25 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:206 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2893eb1c | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:213 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7f6926d9 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:216 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1b307b7 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:218 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c0a835b8 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:226 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-fc750d51 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:232 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FPC0625_AttrOptionEditPopup.FindDataAttrList

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / SaveButton [if (res.Good()) ▸ if (cnt > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fa97a0f | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:321 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a6408545 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:335 | try | FLAG | dsList | FindAttrList("SELECT", LastAttrTypeIdx) | 화면 필드/플래그 변경 |  |  |  |
| AC-42671053 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:339 | try | FLAG | siList | GetSheetInfo(spdList.Name, spdList.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-09578419 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:341 | try | GRID_BIND | siList.Query | (dsList, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3fc15b70 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:342 | try | GRID_LOCK | siList.LockColumn | (0, siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e5aebc6 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:343 | try | CALL_BASE | SetFilter | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8db56faf | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:349 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea94ec9f | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:354 | finally | UI_MISC | siList.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f362808a | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:355 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0625_AttrOptionEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3fb6778 | this.Load | FPC0625_AttrOptionEditPopup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4fa7e90c | this.Load | FPC0625_AttrOptionEditPopup.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-973522f3 | this.Load | FPC0625_AttrOptionEditPopup.cs:151 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-79f1c6d8 | this.Load | FPC0625_AttrOptionEditPopup.cs:153 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0625_AttrOptionEditPopup.GoSave

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb48728 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:449 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siList) | 프레임워크 검증 |  |  |  |
| AC-9a80c880 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:449 | if (!DataUtil.checkRequiredOfSpread(siList)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad0dd76b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:452 |  | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-34c575de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:452 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac0982bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:454 |  | DATA_OP | (siList.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a12a5b5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:456 | if (saveDS == null) | THROW | throw new Exception("Cannot Find Data Source"); |  | 예외 발생 |  |  |  |
| AC-2e70794b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:457 |  | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-650129b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:458 |  | DATA_OP | saveDS.Tables[0].Columns.SafeAdd | (DefColumns.OLD_ATTRIBUTE_LIST, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f51e0c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:459 |  | DATA_OP | saveDS.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-348b2b55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:477 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9cf99b3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:478 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cTable.Rows.Add | (cRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-caf7da5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:490 | for (i <= siList.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | InstanceId | 행/컬럼 값 대입 |  |  |  |
| AC-f0cf0536 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:495 | for (i <= siList.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) ▸ if (src_row != null) | DATA_OP | cRow[DefColumns.INSTANCE_ID] | src_row[DefColumns.INSTANCE_ID].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de4d8e4f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:497 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OPERATION_ID] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2575cbc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:498 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_TYPE] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5a5f435 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:499 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ATTRIBUTE_LIST] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.ATTRIBUTE_LIST)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-143aeb62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:500 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.OLD_ATTRIBUTE_LIST] | old_attr_list | 행/컬럼 값 대입 |  |  |  |
| AC-d7b27780 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:501 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.DESCRIPTION] | siList.GetValue(i, siList.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d42f979 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:502 | for (i <= siList.GetMaxRowIndex()) | DATA_OP | cRow[DefColumns.ACTIVE_FLAG] | active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ae1924eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:509 | if (res.Good()) | CALL_EXT | res.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c1ab418 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:513 | if (res.Good()) ▸ if (cnt > 0) | MESSAGE | MessageBox.Show | ("Save success") | 메시지 표시 |  |  |  |
| AC-9a8a887a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:518 | if (res.Good()) ▸ else of (cnt > 0) | MESSAGE | MessageBox.Show | ("Nothing saveds") | 메시지 표시 |  |  |  |
| AC-fb8c814e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:523 | else of (res.Good()) | MESSAGE | MessageBox.Show | ("Fail to save") | 메시지 표시 |  |  |  |

## FPC0625_AttrOptionEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7980a0f1 | this.Load | FPC0625_AttrOptionEditPopup.cs:168 |  | VALUE_SET | txtInstance.Text | InstanceName | 컨트롤 값 설정 |  |  |  |
| AC-3ac4afe8 | this.Load | FPC0625_AttrOptionEditPopup.cs:169 |  | VALUE_SET | txtOperation.Text | OperationId | 컨트롤 값 설정 |  |  |  |
| AC-0350126d | this.Load | FPC0625_AttrOptionEditPopup.cs:170 |  | VALUE_SET | txtName.Text | AttrName | 컨트롤 값 설정 |  |  |  |

## FPC0625_AttrOptionEditPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / SaveButton [if (res.Good()) ▸ if (cnt > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff206167 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ee5cea1 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:141 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5355c3af | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:193 |  | GRID_INIT | siList.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81d63225 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:194 |  | GRID_INIT | siList.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b96dba92 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:280 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e0c39b1d | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:282 |  | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d19abc13 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:283 |  | GRID_INIT | spreadInfo.AddTextColumn | ("Instance*", "INSTANCE_NAME", FPMerge.None, 210, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-154ee6e9 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:284 |  | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2d1d350 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:285 |  | DATA_OP | dtYesOrNo.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-341c4146 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:288 | for (i < 16) | DATA_OP | dtAttributesNames.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b6fb685 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:289 | for (i < 16) | DATA_OP | dtAttributesNames.Rows.Add | (eachAttr) | 데이터 객체 조작/조회 |  |  |  |
| AC-3566dd6e | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:290 | for (i < 16) | DATA_OP | eachAttr["CODE"] | eachAttr["NAME"] = string.Format("ATTRIBUTE{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-9d5b999d | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:290 | for (i < 16) | DATA_OP | eachAttr["NAME"] | string.Format("ATTRIBUTE{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-0e60293a | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:292 |  | GRID_INIT | spreadInfo.AddComboColumn | ("Attribute Type", DefColumns.ATTRIBUTE_TYPE, FPMerge.None, 100, true, dtAttributesNames, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7490d40e | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:293 |  | GRID_INIT | spreadInfo.AddTextColumn | ("Name", "ATTRIBUTE_NAME", FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-199d6c2d | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:294 |  | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute Option", DefColumns.ATTRIBUTE_LIST, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-393814c2 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:295 |  | GRID_INIT | spreadInfo.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecd5ca47 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:297 |  | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4da030b | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:299 |  | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8059aaaf | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:300 |  | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6055ac37 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:301 |  | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3e5085f | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:302 |  | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10906c34 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:304 |  | GRID_INIT | spreadInfo.Freeze | (0, siList.GetColumnIndex(DefColumns.OPERATION_ID) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-492853f8 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:306 |  | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0625_AttrOptionEditPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-352617bf | (진입점 미연결) | FPC0625_AttrOptionEditPopup.cs:160 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7557e828 | (진입점 미연결) | FPC0625_AttrOptionEditPopup.cs:213 |  | GRID_INIT | siList.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0625_AttrOptionEditPopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert: ▸ if (fps!=null) ▸ if (siList.IsLock(SpdSheet.shtMain))] / InsertButton [if (fps!=null) ▸ if (siList.IsLock(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0ead0f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:630 |  | DATA_OP | siList.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62c03c2e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:661 |  | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_NAME, instance_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b58fe78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:662 |  | DATA_OP | defaultData.Add | (DefColumns.INSTANCE_ID, instance_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bc751fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:663 |  | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, operation_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-486e7227 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:666 |  | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-32766495 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:667 |  | DATA_OP | defaultData.Add | (DefColumns.ATTRIBUTE_TYPE, AttrType) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbe1bd91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:668 |  | DATA_OP | defaultData.Add | ("ATTRIBUTE_NAME", AttrName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f477f0a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:670 |  | GRID_SET | siList.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-34b7da8e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:671 |  | GRID_LOCK | siList.LockRange | (insCell, siList.GetColumnIndex(DefColumns.UPDATE_ID), siList.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0625_AttrOptionEditPopup.SaveAttrList

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2dd67ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:532 |  | UI_PROP | rt.TableName | "RES" | 속성 TableName 설정 |  |  |  |
| AC-665936f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:533 |  | DATA_OP | rt.Columns.SafeAdd | ("RESULT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d58be768 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:534 |  | DATA_OP | rt.Columns.SafeAdd | ("COUNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c380666 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:535 |  | DATA_OP | r.Tables.Add | (rt) | 데이터 객체 조작/조회 |  |  |  |
| AC-309292fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:539 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "save_item_group_list", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_group_list] \| FP\Mast… | 엔드포인트 호출 |  |  |  |
| AC-96831e91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:540 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "delete_item_group_list", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_group_list] \| FP\Ma… | 엔드포인트 호출 |  |  |  |
| AC-9810f7fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:543 | try ▸ if (rSave.Good()) | CALL_EXT | rSave.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-232c60e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:547 | try ▸ if (rRemove.Good()) | CALL_EXT | rRemove.Rows[0]["COUNT"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8bbc9f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:552 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-07eb9605 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:554 |  | DATA_OP | rt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b00b5aab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:557 | if (count > 0) | DATA_OP | rRow["RESULT"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-9b12645a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:558 | if (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-d745ac82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:562 | else of (count > 0) | DATA_OP | rRow["RESULT"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-82f2abd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:563 | else of (count > 0) | DATA_OP | rRow["COUNT"] | count | 행/컬럼 값 대입 |  |  |  |
| AC-e730205b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:565 |  | DATA_OP | rt.Rows.Add | (rRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb655c10 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FPC0625_AttrOptionEditPopup.cs:566 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FPC0625_AttrOptionEditPopup.SetSpreadInit

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / SaveButton [if (res.Good()) ▸ if (cnt > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe7466ff | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:147 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-994d1c00 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:148 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-237154e5 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-229da1f8 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:200 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c892ee7 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:201 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e83bbbd6 | this.Load 외 2 | FPC0625_AttrOptionEditPopup.cs:205 |  | GRID_INIT | siList.SetSheetHeaderColumn_FP | (siList, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0625_AttrOptionEditPopup.spdMain_CellClick

진입점: this.spdMain.CellClick / this.spdList.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12bbc1d0 | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:283 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-c483fb6d | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:284 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d111a95f | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:287 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-4dec9efa | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:728 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b3dee1 | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:729 |  | DATA_OP | siList.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-901c0bec | this.spdMain.CellClick 외 1 | FPC0625_AttrOptionEditPopup.cs:732 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FPC0625_AttrOptionEditPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick / this.spdList.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9efba93 | this.spdMain.CellDoubleClick 외 1 | FPC0625_AttrOptionEditPopup.cs:293 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-9437ccc1 | this.spdMain.CellDoubleClick 외 1 | FPC0625_AttrOptionEditPopup.cs:294 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2cec1687 | this.spdMain.CellDoubleClick 외 1 | FPC0625_AttrOptionEditPopup.cs:297 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-0563f284 | this.spdMain.CellDoubleClick 외 1 | FPC0625_AttrOptionEditPopup.cs:300 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faa82ae0 | this.spdMain.CellDoubleClick 외 1 | FPC0625_AttrOptionEditPopup.cs:310 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0625_AttrOptionEditPopup.txtMaterial_TextChanged

진입점: this.txtMaterial.TextChanged / this.txtInstance.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff8d647a | this.txtMaterial.TextChanged 외 1 | FPC0625_AttrOptionEditPopup.cs:323 |  | DATA_OP | Filter["ITEM_NAME"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-49b88cdc | this.txtMaterial.TextChanged 외 1 | FPC0625_AttrOptionEditPopup.cs:768 |  | DATA_OP | Filter["ITEM_NAME"] | txtInstance.Text | 행/컬럼 값 대입 |  |  |  |

