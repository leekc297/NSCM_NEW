# AS-IS 액션 대조표 — FPC0608

> 원천: `Doc/asisfacts/screens/FPC0608/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 254행 · 메서드 17 · 종류 FLAG 70 · DATA_OP 65 · VALUE_CLEAR 20 · UI_PROP 15 · VALUE_SET 15 · POPUP 14 · RETURN 11 · MESSAGE 10 · UI_MISC 9 · STATE 7 · COMBO_DATA 5 · LIST_REBIND 5 · CALL_EXT 3 · ENDPOINT 3 · LIST_BIND 2 · ⚠ 의미 확인 필요 3


## FPC0608_MemoAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8de4277 | .ctor | FPC0608_MemoAddPopup.cs:95 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f3b4b123 | .ctor | FPC0608_MemoAddPopup.cs:96 |  | FLAG | _sMemoType | sMemoType | 화면 필드/플래그 변경 |  |  |  |

## FPC0608_MemoAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ccfad8d | this.btnClose.Click | FPC0608_MemoAddPopup.cs:206 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0608_MemoAddPopup.btnEquipment_Click

진입점: this.btnEquipment.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b5eeb5a | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:699 | if (string.IsNullOrEmpty(txtLine.Text)) | MESSAGE | MessageBox.Show | ("Please insert Line value") | 메시지 표시 |  |  |  |
| AC-a90a4c07 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:700 | if (string.IsNullOrEmpty(txtLine.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd2c16a8 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:704 |  | FLAG | _sFactory | txtBuilding.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-b3f13214 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:705 |  | FLAG | _sOperation | txtOperation.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-d3bc9b4a | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:706 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-44cd9d29 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:707 |  | FLAG | _sLine | txtLine.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-13c95cc5 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:708 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4cd3335 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:709 |  | FLAG | _sElectrodeType | txtElectrodType.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-7c7d9389 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:715 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ee53f0dc | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:717 |  | POPUP | new FPC0595_EquipmentPopup | () | 팝업/폼 생성 |  |  |  |
| AC-98d422ad | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:718 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-c544f54b | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:720 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-840508de | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:721 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-a2b0ba84 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:722 |  | DATA_OP | popup.Filter["PLANT_ID"] | _sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-1de12a0d | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:723 |  | DATA_OP | popup.Filter["FACTORY_ID"] | _sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-604193e5 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:724 |  | DATA_OP | popup.Filter["OPERATION_ID"] | _sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-f000f6a2 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:725 |  | DATA_OP | popup.Filter["LINE_ID"] | _sLine | 행/컬럼 값 대입 |  |  |  |
| AC-93d1ac94 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:727 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cd524339 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:729 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ecca6ab9 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:734 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sEquipment | txtEquipment.Text = data["EQUIPMENT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-551ac183 | this.btnEquipment.Click | FPC0608_MemoAddPopup.cs:734 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtEquipment.Text | data["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FPC0608_MemoAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc2d6adf | this.btnLine.Click | FPC0608_MemoAddPopup.cs:653 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-052c8a55 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:654 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-096d2c40 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:658 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-705973ae | this.btnLine.Click | FPC0608_MemoAddPopup.cs:659 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e823e456 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:665 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a37f4b5f | this.btnLine.Click | FPC0608_MemoAddPopup.cs:667 |  | POPUP | new FPC0596_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-3c9fc46f | this.btnLine.Click | FPC0608_MemoAddPopup.cs:668 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-52aa9f34 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:669 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-f0b17a2f | this.btnLine.Click | FPC0608_MemoAddPopup.cs:670 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-da2e2490 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:671 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-0278ea81 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:672 |  | DATA_OP | popup.Filter["ITEM_ID"] | _sItem | 행/컬럼 값 대입 |  |  |  |
| AC-cf9dace6 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:674 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d38e3200 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:676 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4c1042f1 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:681 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-175f3383 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:682 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sFactory | txtBuilding.Text = data["FACTORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-80347b84 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:682 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-61bf7486 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:683 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sOperation | txtOperation.Text = data["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-950c7c68 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:683 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8629ab0c | this.btnLine.Click | FPC0608_MemoAddPopup.cs:684 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sLine | txtLine.Text = data["LINE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-55ff99df | this.btnLine.Click | FPC0608_MemoAddPopup.cs:684 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7a165c65 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:685 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-425db985 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:685 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6f1b7530 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:689 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-21e8a4f5 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:689 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-705d9031 | this.btnLine.Click | FPC0608_MemoAddPopup.cs:691 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-19e2e56e | this.btnLine.Click | FPC0608_MemoAddPopup.cs:691 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |

## FPC0608_MemoAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b93015e | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:426 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd458d8c | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:431 | if (string.IsNullOrEmpty(_sInstance)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-269ee345 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:432 | if (string.IsNullOrEmpty(_sInstance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b10037d3 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:436 |  | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7c3fb3b | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:439 |  | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-75ef0c36 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:443 | foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-54bd7509 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:446 | if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-89475c05 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:448 | else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9c465e53 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:455 | if (_sInstanceType == "E3") | POPUP | new FPC0596_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de35e43b | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:456 | if (_sInstanceType == "E3") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-e3855f28 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:457 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-6d7413c6 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:458 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-78c9e926 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:459 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-d7061928 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:461 | if (_sInstanceType == "E3") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e78217a | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:463 | if (_sInstanceType == "E3") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b69627c3 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:476 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | new FPC0595_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-49619acc | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:477 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-93b4c746 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:478 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-468c80d9 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:479 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2451043d | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:480 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-2c659f10 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:482 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c84115bf | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:484 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1f8b1162 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:495 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-a089beb7 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:502 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a19f7ed5 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:505 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | new FPC0602_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1f1c0ae4 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:506 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-5f03e842 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:507 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-febc81bb | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:508 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5b78cf51 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:509 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-9f5825a5 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:510 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-73ccb859 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:512 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-62786bc5 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:514 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d972084d | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:526 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-ffbd8045 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:532 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") ▸ if (fc … | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e245c16a | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:534 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | new FPC0601_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5e4a9924 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:535 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-dadb0089 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:536 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-96a383ba | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:537 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-53d07626 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:538 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-8ccfc9ad | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:539 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b8a18232 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:541 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-28f287a4 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:543 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a7496270 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:556 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | FLAG | _sFormOperation | "F6000" | 화면 필드/플래그 변경 |  |  |  |
| AC-741cb227 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:562 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ed93967b | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:564 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | new FPC0621_LineCN2ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3517ee6b | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:565 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-8359c4ea | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:566 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-486543f8 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:567 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["FORM_OPERATION_ID"] | _sFormOperation | 행/컬럼 값 대입 |  |  |  |
| AC-dd68d8c3 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:569 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1f14e426 | this.btnMaterial.Click | FPC0608_MemoAddPopup.cs:571 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0608_MemoAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-139571de | this.btnSave.Click | FPC0608_MemoAddPopup.cs:196 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b83fa70a | this.btnSave.Click | FPC0608_MemoAddPopup.cs:200 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0608_MemoAddPopup.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea56a65 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:330 | if (dtInstance.Rows.Count >0) | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b45eaf2 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:332 | if (dtInstance.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d3bcdac | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:335 | if (dtInstance.Rows.Count >0) | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6622c8cb | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:339 | if (dtInstance.Rows.Count >0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0aa44a97 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:342 | if (dtInstance.Rows.Count >0) ▸ if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a4a4dc90 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:344 | if (dtInstance.Rows.Count >0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-87877514 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:348 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-86459d3e | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:348 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-0c153db9 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:349 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e830a84f | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:350 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b13f99af | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:354 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e8e2e21b | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:355 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e13f8f81 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:356 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9c77d0a8 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:361 | if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-7dcf411e | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:362 | if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc3c627 | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:364 | if (_sInstanceType == "F") | STATE | cboProdType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-20e80c8b | cboInstance.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:368 | else of (_sInstanceType == "F") | STATE | cboProdType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0608_MemoAddPopup.cboMarket_changed

진입점: cboMarket.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e92081c | cboMarket.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:375 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FPC0608_MemoAddPopup.cboProdtype_changed

진입점: cboProdType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b139c73 | cboProdType.SelectedIndexChanged | FPC0608_MemoAddPopup.cs:380 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FPC0608_MemoAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26baae48 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:217 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("You need to select Item") | 메시지 표시 |  |  |  |
| AC-440a2234 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:218 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-38ebfffe | this.btnSave.Click | FPC0608_MemoAddPopup.cs:222 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line") | 메시지 표시 |  |  |  |
| AC-43733dbd | this.btnSave.Click | FPC0608_MemoAddPopup.cs:223 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ae0a8091 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:227 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | MESSAGE | MessageBox.Show | ("You need to select Equipment") | 메시지 표시 |  |  |  |
| AC-f8053e9a | this.btnSave.Click | FPC0608_MemoAddPopup.cs:228 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f017c7c7 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:230 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b147a0e | this.btnSave.Click | FPC0608_MemoAddPopup.cs:233 | if (string.IsNullOrWhiteSpace(_sProductionType)) | MESSAGE | MessageBox.Show | ("You need to select Production Type") | 메시지 표시 |  |  |  |
| AC-68fcf6ad | this.btnSave.Click | FPC0608_MemoAddPopup.cs:234 | if (string.IsNullOrWhiteSpace(_sProductionType)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-87fb6e75 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:237 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-afe99425 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:240 | if (string.IsNullOrWhiteSpace(_sMarket)) | MESSAGE | MessageBox.Show | ("You need to Market") | 메시지 표시 |  |  |  |
| AC-94d57e8a | this.btnSave.Click | FPC0608_MemoAddPopup.cs:241 | if (string.IsNullOrWhiteSpace(_sMarket)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5feb931e | this.btnSave.Click | FPC0608_MemoAddPopup.cs:253 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | MESSAGE | MessageBox.Show | ("Select Material") | 메시지 표시 |  |  |  |
| AC-f013bb49 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:254 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d81fd6d2 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:257 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0608_MemoAddPopup.ClearVariable

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eb75b40 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:402 |  | FLAG | _sCompany | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-27c920a7 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:403 |  | FLAG | _sDivision | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-81f04730 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:404 |  | FLAG | _sSite | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-7db7186e | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:405 |  | FLAG | _sPlant | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-68201e85 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:406 |  | FLAG | _sFactory | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec25982 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:407 |  | FLAG | _sOperation | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-36384b59 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:408 |  | FLAG | _sLine | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-33428100 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:409 |  | FLAG | _sEquipment | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-432cf8de | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:410 |  | FLAG | _sModel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a8332620 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:411 |  | FLAG | _sItem | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2d9a6f3f | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:412 |  | FLAG | _sNickName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8ca4a5e6 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:413 |  | FLAG | _sMarket | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-87ac1551 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:414 |  | FLAG | _sProductionType | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3a93806c | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:415 |  | FLAG | _sMemo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-65494c62 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:416 |  | FLAG | _sElectrodeType | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FPC0608_MemoAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5707e7ed | Dispose | FPC0608_MemoAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0608_MemoAddPopup.drpPeriod_ValueChanged

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed975d2f | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:388 |  | VALUE_CLEAR | txtModel.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-beab0079 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:389 |  | VALUE_CLEAR | txtItem.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-966b02db | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:390 |  | VALUE_CLEAR | txtEquipment.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-c2364013 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:391 |  | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-892d0cd6 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:392 |  | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-7c2e332a | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:393 |  | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-318ad415 | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:394 |  | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-5d7dd59b | this.drpPeriod.ValueChanged | FPC0608_MemoAddPopup.cs:395 |  | VALUE_CLEAR | txtMemo.Text | string.Empty | 컨트롤 값 비움 |  |  |  |

## FPC0608_MemoAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e903220d | this.Load | FPC0608_MemoAddPopup.cs:109 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d2cf96ac | this.Load | FPC0608_MemoAddPopup.cs:111 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0608_MemoAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e700edb6 | this.Load | FPC0608_MemoAddPopup.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2677ca76 | this.Load | FPC0608_MemoAddPopup.cs:126 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-342f22eb | this.Load | FPC0608_MemoAddPopup.cs:128 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9f8fe9b0 | this.Load | FPC0608_MemoAddPopup.cs:134 | if (Filter["INSTANCE_ID"].SafeString()=="") | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-2ea91d1b | this.Load | FPC0608_MemoAddPopup.cs:134 | if (Filter["INSTANCE_ID"].SafeString()=="") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb74a874 | this.Load | FPC0608_MemoAddPopup.cs:135 | if (Filter["INSTANCE_ID"].SafeString()=="") | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-88d20b33 | this.Load | FPC0608_MemoAddPopup.cs:136 | if (Filter["INSTANCE_ID"].SafeString()=="") | VALUE_CLEAR | cboInstance.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-858bc5ea | this.Load | FPC0608_MemoAddPopup.cs:140 | else of (Filter["INSTANCE_ID"].SafeString()=="") | FLAG | dtInstance | DataService.FP_ExecuteQuery2("PICAlarm", "get_instance_info", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_info] \| FP\Common… | 화면 필드/플래그 변경 |  |  |  |
| AC-b6ed63f7 | this.Load | FPC0608_MemoAddPopup.cs:140 | else of (Filter["INSTANCE_ID"].SafeString()=="") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "get_instance_info", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_info] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6be21587 | this.Load | FPC0608_MemoAddPopup.cs:141 | else of (Filter["INSTANCE_ID"].SafeString()=="") | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-afe17ca2 | this.Load | FPC0608_MemoAddPopup.cs:142 | else of (Filter["INSTANCE_ID"].SafeString()=="") | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a98092b6 | this.Load | FPC0608_MemoAddPopup.cs:145 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1fc09f38 | this.Load | FPC0608_MemoAddPopup.cs:145 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-86fbd78f | this.Load | FPC0608_MemoAddPopup.cs:147 |  | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-751c6a31 | this.Load | FPC0608_MemoAddPopup.cs:148 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d9ab6c5 | this.Load | FPC0608_MemoAddPopup.cs:153 | foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-33326405 | this.Load | FPC0608_MemoAddPopup.cs:157 | foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-20412fab | this.Load | FPC0608_MemoAddPopup.cs:160 |  | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-114435e6 | this.Load | FPC0608_MemoAddPopup.cs:161 |  | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-825450d1 | this.Load | FPC0608_MemoAddPopup.cs:163 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7cfb18b6 | this.Load | FPC0608_MemoAddPopup.cs:164 |  | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-ec3406d1 | this.Load | FPC0608_MemoAddPopup.cs:166 |  | FLAG | dtMarket | Data_FP.Common_FP(Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9fd1c910 | this.Load | FPC0608_MemoAddPopup.cs:166 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45a64bb3 | this.Load | FPC0608_MemoAddPopup.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cboMarket, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-a06275c5 | this.Load | FPC0608_MemoAddPopup.cs:168 |  | VALUE_CLEAR | cboMarket.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-01586ed2 | this.Load | FPC0608_MemoAddPopup.cs:174 |  | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sStartday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e8bed84b | this.Load | FPC0608_MemoAddPopup.cs:177 |  | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FPC0608_MemoAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4e0457c | this.btnSave.Click | FPC0608_MemoAddPopup.cs:265 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", sStartDate, sStartDate, sEndDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-918af1fc | this.btnSave.Click | FPC0608_MemoAddPopup.cs:275 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00608_AMEND_MEMO") ⇒ FP_Planning.PR_UI_FP00608_AMEND_MEMO | 엔드포인트 요청 생성 |  |  |  |
| AC-a1e5bb10 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:276 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7582c756 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:278 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-0097b858 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:279 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | "MERGE" | 행/컬럼 값 대입 |  |  |  |
| AC-85ffbd81 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:280 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3998a35e | this.btnSave.Click | FPC0608_MemoAddPopup.cs:281 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9191730d | this.btnSave.Click | FPC0608_MemoAddPopup.cs:282 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-9d8626f7 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:283 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_company_id"] | _sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-7e040582 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:284 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c52b2f89 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:285 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-facb73ff | this.btnSave.Click | FPC0608_MemoAddPopup.cs:286 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_plant_id"] | _sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-7e765dd7 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:287 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | _sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-1498be0e | this.btnSave.Click | FPC0608_MemoAddPopup.cs:288 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_operation_id"] | _sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-c7d28c28 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:289 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_line_id"] | _sLine | 행/컬럼 값 대입 |  |  |  |
| AC-408fcf91 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:290 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_electrode_type"] | _sElectrodeType | 행/컬럼 값 대입 |  |  |  |
| AC-769e9385 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:291 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_equipment_id"] | _sEquipment | 행/컬럼 값 대입 |  |  |  |
| AC-6403123b | this.btnSave.Click | FPC0608_MemoAddPopup.cs:292 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_market"] | _sMarket | 행/컬럼 값 대입 |  |  |  |
| AC-04aa9df0 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:293 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_production_type"] | _sProductionType | 행/컬럼 값 대입 |  |  |  |
| AC-abadb988 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:294 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_top_item_id"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-7146b476 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:295 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_item_id"] | _sItem | 행/컬럼 값 대입 |  |  |  |
| AC-c950ce0e | this.btnSave.Click | FPC0608_MemoAddPopup.cs:296 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_nick_name"] | _sNickName | 행/컬럼 값 대입 |  |  |  |
| AC-6e8e656f | this.btnSave.Click | FPC0608_MemoAddPopup.cs:297 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-1f937092 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:298 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_memo"] | txtMemo.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-994da4b5 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:299 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_memo_type"] | _sMemoType | 행/컬럼 값 대입 |  |  |  |
| AC-abfddc9a | this.btnSave.Click | FPC0608_MemoAddPopup.cs:300 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aad22ee2 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:301 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec58a186 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:303 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-53c75bb9 | this.btnSave.Click | FPC0608_MemoAddPopup.cs:313 | if (dtRange != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0608_MemoAddPopup.SetValueByPopupData

진입점: this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f7392d5 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:587 | if (data != null) | FLAG | _sDivision | data["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cb106f4b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:588 | if (data != null) | FLAG | _sSite | data["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-de6a520e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:589 | if (data != null) | FLAG | _sItem | txtItem.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-83d33cde | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:589 | if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9fb32c1d | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:593 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbd513af | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:593 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e73ea27e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:597 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["MODEL_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ce176b5 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:597 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d2342f45 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:600 | if (data != null) | FLAG | dtProdType | DataCommon.GetUserFormCodeData(_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fbc092bc | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:600 | if (data != null) | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04d91c0e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:601 | if (data != null) | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55df4581 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:602 | if (data != null) | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7a50403 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:606 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-388df040 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:608 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ if (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-f0a866ab | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:610 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ else of (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93cb30ee | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:612 | if (data != null) | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30019794 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:613 | if (data != null) | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-2b23e410 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:614 | if (data != null) | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9a2f937c | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:615 | if (data != null) | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-a4f23754 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:619 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd73d37 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:621 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cbc28417 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:625 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-9f8e85b6 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:625 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-c58720f6 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:627 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0cc1dca8 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:627 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0e675f60 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:629 | if (data != null) | FLAG | _sFactory | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2ce0fecd | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:630 | if (data != null) | FLAG | _sOperation | txtOperation.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9fc0b487 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:630 | if (data != null) | VALUE_CLEAR | txtOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4eeef236 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:631 | if (data != null) | FLAG | _sLine | txtLine.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4ec7ea4b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:631 | if (data != null) | VALUE_CLEAR | txtLine.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6454af9a | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:632 | if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-79753192 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:632 | if (data != null) | VALUE_CLEAR | txtElectrodType.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1acbd660 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:636 | if (data != null) ▸ if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-4c03cd3e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:637 | if (data != null) ▸ if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-9b46111e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:641 | if (data != null) ▸ else of (_sInstanceType == "F") | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-285ee579 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FPC0608_MemoAddPopup.cs:642 | if (data != null) ▸ else of (_sInstanceType == "F") | FLAG | _sProductionType | "" | 화면 필드/플래그 변경 |  |  |  |

