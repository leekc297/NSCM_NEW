# AS-IS 액션 대조표 — FP00608

> 원천: `Doc/asisfacts/screens/FP00608/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1102행 · 메서드 89 · 종류 DATA_OP 400 · FLAG 132 · UI_PROP 85 · RETURN 73 · GRID_SET 64 · STATE 41 · GRID_LOCK 37 · MESSAGE 35 · POPUP 34 · UI_MISC 33 · ENDPOINT 26 · CALL_EXT 25 · VALUE_CLEAR 20 · GRID_INIT 18 · VALUE_SET 16 · COMBO_DATA 13 · LIST_REBIND 11 · THROW 11 · CALL_BASE 7 · GRID_COMBO 6 · GRID_BIND 5 · VALIDATE 3 · LIST_BIND 2 · EXCEL 2 · STATE_RESET 1 · GRID_STYLE 1 · FOCUS 1 · ⚠ 의미 확인 필요 32


## FP00608_MemoAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3d97dad | .ctor | FP00608_MemoAddPopup.cs:95 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f42c1226 | .ctor | FP00608_MemoAddPopup.cs:96 |  | FLAG | _sMemoType | sMemoType | 화면 필드/플래그 변경 |  |  |  |

## FP00608_MemoAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd32fc0c | this.btnClose.Click | FP00608_MemoAddPopup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00608_MemoAddPopup.btnEquipment_Click

진입점: this.btnEquipment.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6057c20 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:685 | if (string.IsNullOrEmpty(txtLine.Text)) | MESSAGE | MessageBox.Show | ("Please insert Line value") | 메시지 표시 |  |  |  |
| AC-6c9b1392 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:686 | if (string.IsNullOrEmpty(txtLine.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7f10427 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:690 |  | FLAG | _sFactory | txtBuilding.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-b1bd6247 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:691 |  | FLAG | _sOperation | txtOperation.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-975b7112 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:692 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-26cb7011 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:693 |  | FLAG | _sLine | txtLine.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-e5f6ab2c | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:694 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-15d2a284 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:695 |  | FLAG | _sElectrodeType | txtElectrodType.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc525b6 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:701 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e5359c9b | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:703 |  | POPUP | new FP00595_EquipmentPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8cdc0f55 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:704 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-5ecfd67d | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:706 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-54724cb1 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:707 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-64aba12b | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:708 |  | DATA_OP | popup.Filter["PLANT_ID"] | _sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-abb1ba04 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:709 |  | DATA_OP | popup.Filter["FACTORY_ID"] | _sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-7a85927f | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:710 |  | DATA_OP | popup.Filter["OPERATION_ID"] | _sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-b79d885e | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:711 |  | DATA_OP | popup.Filter["LINE_ID"] | _sLine | 행/컬럼 값 대입 |  |  |  |
| AC-fdfa6a61 | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:713 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9991281b | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:715 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13c442cd | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:720 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sEquipment | txtEquipment.Text = data["EQUIPMENT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-223268bf | this.btnEquipment.Click | FP00608_MemoAddPopup.cs:720 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtEquipment.Text | data["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP00608_MemoAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c94cdff | this.btnLine.Click | FP00608_MemoAddPopup.cs:639 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-9f121b0f | this.btnLine.Click | FP00608_MemoAddPopup.cs:640 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d768a5de | this.btnLine.Click | FP00608_MemoAddPopup.cs:644 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-3c1e9fd7 | this.btnLine.Click | FP00608_MemoAddPopup.cs:645 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad982fc0 | this.btnLine.Click | FP00608_MemoAddPopup.cs:651 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-42970560 | this.btnLine.Click | FP00608_MemoAddPopup.cs:653 |  | POPUP | new FP00596_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-7ec4fa77 | this.btnLine.Click | FP00608_MemoAddPopup.cs:654 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-fa1cfbf8 | this.btnLine.Click | FP00608_MemoAddPopup.cs:655 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-9237bc70 | this.btnLine.Click | FP00608_MemoAddPopup.cs:656 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-db2adabe | this.btnLine.Click | FP00608_MemoAddPopup.cs:657 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-50fad73b | this.btnLine.Click | FP00608_MemoAddPopup.cs:658 |  | DATA_OP | popup.Filter["ITEM_ID"] | _sItem | 행/컬럼 값 대입 |  |  |  |
| AC-40ca9335 | this.btnLine.Click | FP00608_MemoAddPopup.cs:660 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8918edaf | this.btnLine.Click | FP00608_MemoAddPopup.cs:662 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-17abbffe | this.btnLine.Click | FP00608_MemoAddPopup.cs:667 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb3c59e1 | this.btnLine.Click | FP00608_MemoAddPopup.cs:668 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sFactory | txtBuilding.Text = data["FACTORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9872c2f | this.btnLine.Click | FP00608_MemoAddPopup.cs:668 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-16d7b1ea | this.btnLine.Click | FP00608_MemoAddPopup.cs:669 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sOperation | txtOperation.Text = data["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7d159fb | this.btnLine.Click | FP00608_MemoAddPopup.cs:669 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-802ac396 | this.btnLine.Click | FP00608_MemoAddPopup.cs:670 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sLine | txtLine.Text = data["LINE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e297ffc7 | this.btnLine.Click | FP00608_MemoAddPopup.cs:670 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-636d5e6b | this.btnLine.Click | FP00608_MemoAddPopup.cs:671 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c2522eb | this.btnLine.Click | FP00608_MemoAddPopup.cs:671 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-67b61aea | this.btnLine.Click | FP00608_MemoAddPopup.cs:675 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d98a1e | this.btnLine.Click | FP00608_MemoAddPopup.cs:675 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-1de9a66c | this.btnLine.Click | FP00608_MemoAddPopup.cs:677 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-8ee9b16c | this.btnLine.Click | FP00608_MemoAddPopup.cs:677 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00608_MemoAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb9ce8b | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:412 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-45994630 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:417 | if (string.IsNullOrEmpty(_sInstance)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30de8b53 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:418 | if (string.IsNullOrEmpty(_sInstance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6e3346c | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:422 |  | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98168ae4 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:425 |  | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4160a07a | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:429 | foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-657ab3a3 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:432 | if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-39490489 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:434 | else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9ce2906c | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:441 | if (_sInstanceType == "E3") | POPUP | new FP00596_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d14b80c5 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:442 | if (_sInstanceType == "E3") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-65f363f4 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:443 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-5eb0ee8d | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:444 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9630b158 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:445 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-1f001c32 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:447 | if (_sInstanceType == "E3") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f4aef0d | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:449 | if (_sInstanceType == "E3") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-799e485f | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:462 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | new FP00595_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fd1bd0c2 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:463 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-cc7e917c | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:464 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-63b4b212 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:465 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b40421eb | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:466 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-7289034c | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:468 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2e330783 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:470 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b04c7f0a | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:481 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-1201f916 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:488 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3fd0268c | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:491 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | new FP00602_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-60a9238b | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:492 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-e0bd271b | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:493 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e83ae5ca | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:494 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-b71db185 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:495 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-a951dfdd | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:496 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-910512ae | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:498 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c4008d3e | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:500 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3fbf1649 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:512 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-ca8620a6 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:518 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") ▸ if (fc … | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3c916085 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:520 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | new FP00601_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6873beef | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:521 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-20c05071 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:522 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-31f1b423 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:523 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-59f5ed53 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:524 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-68d7a41a | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:525 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2df1fb12 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:527 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6ddfca7 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:529 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0711504f | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:542 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | FLAG | _sFormOperation | "F6000" | 화면 필드/플래그 변경 |  |  |  |
| AC-21248d59 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:548 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-84732e17 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:550 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | new FP00621_LineCN2ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dd1dd6f4 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:551 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-37af1aab | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:552 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-2e82a4aa | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:553 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["FORM_OPERATION_ID"] | _sFormOperation | 행/컬럼 값 대입 |  |  |  |
| AC-cc37bd82 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:555 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-19c10750 | this.btnMaterial.Click | FP00608_MemoAddPopup.cs:557 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00608_MemoAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfd420dc | this.btnSave.Click | FP00608_MemoAddPopup.cs:182 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d02663df | this.btnSave.Click | FP00608_MemoAddPopup.cs:186 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00608_MemoAddPopup.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3260785c | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:316 | if (dtInstance.Rows.Count >0) | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a6ede2a | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:318 | if (dtInstance.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b9d6b24 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:321 | if (dtInstance.Rows.Count >0) | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b87631bb | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:325 | if (dtInstance.Rows.Count >0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-76967d03 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:328 | if (dtInstance.Rows.Count >0) ▸ if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b25eaa91 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:330 | if (dtInstance.Rows.Count >0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-21d59b8b | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:334 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-0968fd82 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:334 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-76748cd2 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:335 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71549346 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:336 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-273b91b3 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:340 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-094a868c | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:341 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c47bde0 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:342 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-60f5b7c2 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:347 | if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-ca8c8b95 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:348 | if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-c4af11ff | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:350 | if (_sInstanceType == "F") | STATE | cboProdType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2f6b4a67 | cboInstance.SelectedIndexChanged | FP00608_MemoAddPopup.cs:354 | else of (_sInstanceType == "F") | STATE | cboProdType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00608_MemoAddPopup.cboMarket_changed

진입점: cboMarket.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b88d3fc8 | cboMarket.SelectedIndexChanged | FP00608_MemoAddPopup.cs:361 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FP00608_MemoAddPopup.cboProdtype_changed

진입점: cboProdType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6076b60 | cboProdType.SelectedIndexChanged | FP00608_MemoAddPopup.cs:366 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FP00608_MemoAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c7a6b17 | this.btnSave.Click | FP00608_MemoAddPopup.cs:203 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("You need to select Item") | 메시지 표시 |  |  |  |
| AC-7085dd47 | this.btnSave.Click | FP00608_MemoAddPopup.cs:204 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-022616ab | this.btnSave.Click | FP00608_MemoAddPopup.cs:208 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line") | 메시지 표시 |  |  |  |
| AC-3f4572ab | this.btnSave.Click | FP00608_MemoAddPopup.cs:209 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-df79fc20 | this.btnSave.Click | FP00608_MemoAddPopup.cs:213 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | MESSAGE | MessageBox.Show | ("You need to select Equipment") | 메시지 표시 |  |  |  |
| AC-b600056c | this.btnSave.Click | FP00608_MemoAddPopup.cs:214 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-04b534ad | this.btnSave.Click | FP00608_MemoAddPopup.cs:216 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4e5b185 | this.btnSave.Click | FP00608_MemoAddPopup.cs:219 | if (string.IsNullOrWhiteSpace(_sProductionType)) | MESSAGE | MessageBox.Show | ("You need to select Production Type") | 메시지 표시 |  |  |  |
| AC-049cac3b | this.btnSave.Click | FP00608_MemoAddPopup.cs:220 | if (string.IsNullOrWhiteSpace(_sProductionType)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-01742659 | this.btnSave.Click | FP00608_MemoAddPopup.cs:223 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-39e20780 | this.btnSave.Click | FP00608_MemoAddPopup.cs:226 | if (string.IsNullOrWhiteSpace(_sMarket)) | MESSAGE | MessageBox.Show | ("You need to Market") | 메시지 표시 |  |  |  |
| AC-98c391b8 | this.btnSave.Click | FP00608_MemoAddPopup.cs:227 | if (string.IsNullOrWhiteSpace(_sMarket)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-63e8d1cb | this.btnSave.Click | FP00608_MemoAddPopup.cs:239 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | MESSAGE | MessageBox.Show | ("Select Material") | 메시지 표시 |  |  |  |
| AC-4bf93c7d | this.btnSave.Click | FP00608_MemoAddPopup.cs:240 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-615650ac | this.btnSave.Click | FP00608_MemoAddPopup.cs:243 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00608_MemoAddPopup.ClearVariable

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7b6e2c1 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:388 |  | FLAG | _sCompany | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c08317e3 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:389 |  | FLAG | _sDivision | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-566aa98b | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:390 |  | FLAG | _sSite | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d071d0be | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:391 |  | FLAG | _sPlant | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-16370502 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:392 |  | FLAG | _sFactory | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ae3facd3 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:393 |  | FLAG | _sOperation | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-71ea3a3f | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:394 |  | FLAG | _sLine | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-afd77697 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:395 |  | FLAG | _sEquipment | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-69dfed66 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:396 |  | FLAG | _sModel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d589ff76 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:397 |  | FLAG | _sItem | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2738d857 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:398 |  | FLAG | _sNickName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-86b78550 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:399 |  | FLAG | _sMarket | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dc116268 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:400 |  | FLAG | _sProductionType | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0dfd331d | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:401 |  | FLAG | _sMemo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-d525abfb | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:402 |  | FLAG | _sElectrodeType | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP00608_MemoAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b834cc4 | Dispose | FP00608_MemoAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00608_MemoAddPopup.drpPeriod_ValueChanged

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0514863 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:374 |  | VALUE_CLEAR | txtModel.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-d0b9c280 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:375 |  | VALUE_CLEAR | txtItem.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-94e5cc3e | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:376 |  | VALUE_CLEAR | txtEquipment.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-416d4ff0 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:377 |  | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-670ed7d0 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:378 |  | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-21347bf3 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:379 |  | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-2d9188a6 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:380 |  | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-9f2d8284 | this.drpPeriod.ValueChanged | FP00608_MemoAddPopup.cs:381 |  | VALUE_CLEAR | txtMemo.Text | string.Empty | 컨트롤 값 비움 |  |  |  |

## FP00608_MemoAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f3808d | this.Load | FP00608_MemoAddPopup.cs:109 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-48bbc9a1 | this.Load | FP00608_MemoAddPopup.cs:111 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00608_MemoAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ccf11d2 | this.Load | FP00608_MemoAddPopup.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-134dd1fe | this.Load | FP00608_MemoAddPopup.cs:127 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-04773786 | this.Load | FP00608_MemoAddPopup.cs:127 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2a974a5 | this.Load | FP00608_MemoAddPopup.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-72e4fe32 | this.Load | FP00608_MemoAddPopup.cs:129 |  | VALUE_CLEAR | cboInstance.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-708c88f1 | this.Load | FP00608_MemoAddPopup.cs:131 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c5471828 | this.Load | FP00608_MemoAddPopup.cs:131 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a44aaf8 | this.Load | FP00608_MemoAddPopup.cs:133 |  | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e538d2d | this.Load | FP00608_MemoAddPopup.cs:134 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-212d918e | this.Load | FP00608_MemoAddPopup.cs:139 | foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-a3c23f1a | this.Load | FP00608_MemoAddPopup.cs:143 | foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9895202 | this.Load | FP00608_MemoAddPopup.cs:146 |  | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6de631f | this.Load | FP00608_MemoAddPopup.cs:147 |  | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-4b22e555 | this.Load | FP00608_MemoAddPopup.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6726babe | this.Load | FP00608_MemoAddPopup.cs:150 |  | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-98997697 | this.Load | FP00608_MemoAddPopup.cs:152 |  | FLAG | dtMarket | Data_FP.Common_FP(Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e0e5ee2 | this.Load | FP00608_MemoAddPopup.cs:152 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c364c4e8 | this.Load | FP00608_MemoAddPopup.cs:153 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cboMarket, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-2769ce8e | this.Load | FP00608_MemoAddPopup.cs:154 |  | VALUE_CLEAR | cboMarket.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-529a7471 | this.Load | FP00608_MemoAddPopup.cs:160 |  | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sStartday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1c0add02 | this.Load | FP00608_MemoAddPopup.cs:163 |  | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00608_MemoAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d8c186d | this.btnSave.Click | FP00608_MemoAddPopup.cs:251 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", sStartDate, sStartDate, sEndDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e38c823d | this.btnSave.Click | FP00608_MemoAddPopup.cs:261 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00608_AMEND_MEMO") ⇒ FP_Planning.PR_UI_FP00608_AMEND_MEMO | 엔드포인트 요청 생성 |  |  |  |
| AC-a6b2c78c | this.btnSave.Click | FP00608_MemoAddPopup.cs:262 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4f868acf | this.btnSave.Click | FP00608_MemoAddPopup.cs:264 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-feadcb26 | this.btnSave.Click | FP00608_MemoAddPopup.cs:265 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_flag"] | "MERGE" | 행/컬럼 값 대입 |  |  |  |
| AC-adb633ec | this.btnSave.Click | FP00608_MemoAddPopup.cs:266 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e5eabd54 | this.btnSave.Click | FP00608_MemoAddPopup.cs:267 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-866793d4 | this.btnSave.Click | FP00608_MemoAddPopup.cs:268 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_instance_id"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-d4556392 | this.btnSave.Click | FP00608_MemoAddPopup.cs:269 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_company_id"] | _sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-a8a17ea2 | this.btnSave.Click | FP00608_MemoAddPopup.cs:270 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_division_id"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dbc6c98d | this.btnSave.Click | FP00608_MemoAddPopup.cs:271 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_site_id"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-f5252a8c | this.btnSave.Click | FP00608_MemoAddPopup.cs:272 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_plant_id"] | _sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-9d0854e7 | this.btnSave.Click | FP00608_MemoAddPopup.cs:273 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_factory_id"] | _sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-e1fd9a00 | this.btnSave.Click | FP00608_MemoAddPopup.cs:274 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_operation_id"] | _sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-0b76f290 | this.btnSave.Click | FP00608_MemoAddPopup.cs:275 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_line_id"] | _sLine | 행/컬럼 값 대입 |  |  |  |
| AC-611f36f2 | this.btnSave.Click | FP00608_MemoAddPopup.cs:276 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_electrode_type"] | _sElectrodeType | 행/컬럼 값 대입 |  |  |  |
| AC-4713e95e | this.btnSave.Click | FP00608_MemoAddPopup.cs:277 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_equipment_id"] | _sEquipment | 행/컬럼 값 대입 |  |  |  |
| AC-a9079511 | this.btnSave.Click | FP00608_MemoAddPopup.cs:278 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_market"] | _sMarket | 행/컬럼 값 대입 |  |  |  |
| AC-8e2292a1 | this.btnSave.Click | FP00608_MemoAddPopup.cs:279 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_production_type"] | _sProductionType | 행/컬럼 값 대입 |  |  |  |
| AC-d58e0315 | this.btnSave.Click | FP00608_MemoAddPopup.cs:280 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_top_item_id"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-2d190c9a | this.btnSave.Click | FP00608_MemoAddPopup.cs:281 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_item_id"] | _sItem | 행/컬럼 값 대입 |  |  |  |
| AC-853f02f5 | this.btnSave.Click | FP00608_MemoAddPopup.cs:282 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_nick_name"] | _sNickName | 행/컬럼 값 대입 |  |  |  |
| AC-5d39feea | this.btnSave.Click | FP00608_MemoAddPopup.cs:283 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-cefc2c50 | this.btnSave.Click | FP00608_MemoAddPopup.cs:284 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_memo"] | txtMemo.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1bf8d162 | this.btnSave.Click | FP00608_MemoAddPopup.cs:285 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_memo_type"] | _sMemoType | 행/컬럼 값 대입 |  |  |  |
| AC-6bc11965 | this.btnSave.Click | FP00608_MemoAddPopup.cs:286 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e44a77f0 | this.btnSave.Click | FP00608_MemoAddPopup.cs:287 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | req.Parameters["p_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7fc3b656 | this.btnSave.Click | FP00608_MemoAddPopup.cs:289 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c5d5e58 | this.btnSave.Click | FP00608_MemoAddPopup.cs:299 | if (dtRange != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00608_MemoAddPopup.SetValueByPopupData

진입점: this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f98e288 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:573 | if (data != null) | FLAG | _sDivision | data["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b86125b3 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:574 | if (data != null) | FLAG | _sSite | data["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bd3fba7f | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:575 | if (data != null) | FLAG | _sItem | txtItem.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-358c8fb5 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:575 | if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-aea98266 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:579 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cc4286cf | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:579 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1f339c73 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:583 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["MODEL_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7080c57f | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:583 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6e82c17b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:586 | if (data != null) | FLAG | dtProdType | DataCommon.GetUserFormCodeData(_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3d28b88e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:586 | if (data != null) | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b81a4d6 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:587 | if (data != null) | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb88b5ef | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:588 | if (data != null) | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45705522 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:592 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8f2cb17e | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:594 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ if (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-7b912719 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:596 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ else of (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-997c3679 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:598 | if (data != null) | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a41f3ebe | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:599 | if (data != null) | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9cd1aa24 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:600 | if (data != null) | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-90866eb0 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:601 | if (data != null) | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-7f6fbba8 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:605 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5466fb0d | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:607 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eff1a956 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:611 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-d551eb73 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:611 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-ffadfc52 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:613 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c15094c1 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:613 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-93786823 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:615 | if (data != null) | FLAG | _sFactory | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e60329b0 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:616 | if (data != null) | FLAG | _sOperation | txtOperation.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-82170edc | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:616 | if (data != null) | VALUE_CLEAR | txtOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-81370e68 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:617 | if (data != null) | FLAG | _sLine | txtLine.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1b31abd2 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:617 | if (data != null) | VALUE_CLEAR | txtLine.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-238eab83 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:618 | if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7ed40f51 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:618 | if (data != null) | VALUE_CLEAR | txtElectrodType.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6f3aa63c | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:622 | if (data != null) ▸ if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7464157a | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:623 | if (data != null) ▸ if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-63de9a57 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:627 | if (data != null) ▸ else of (_sInstanceType == "F") | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-250bb3a1 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP00608_MemoAddPopup.cs:628 | if (data != null) ▸ else of (_sInstanceType == "F") | FLAG | _sProductionType | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00608_PlanAmend_Memo.btnExcel_Click

진입점: this.btnExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-305d6875 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2548 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-11260373 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2549 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf438aba | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2556 |  | DATA_OP | Filter["PLAN_DATE"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-120e17ea | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2557 |  | DATA_OP | Filter["UI_END_DATE"] | pEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-6d9ac19b | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2560 |  | POPUP | new FP00608_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-4f2aa3cd | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2564 |  | UI_PROP | rowPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-eef4241f | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2564 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04f5126b | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2568 |  | GRID_SET | rowPopup.KeyColumns["INSTANCE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a97ca00c | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2569 |  | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5168b910 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2570 |  | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f337366e | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2571 |  | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-386b19b7 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2572 |  | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2727af84 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2573 |  | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3884a35c | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2574 |  | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7558ea7c | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2576 |  | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f31f8518 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2578 |  | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-86e57bbf | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2579 |  | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-73eca6c2 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2581 |  | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-01311bb6 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2582 |  | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-43427382 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2584 |  | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a83c241b | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2599 |  | DATA_OP | rowPopup.ColumnTitle["INSTANCE_ID"] | "Instance" | 행/컬럼 값 대입 |  |  |  |
| AC-2e165b3d | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2600 |  | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-94da04fa | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2601 |  | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-0c96253f | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2602 |  | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-070018e7 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2603 |  | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-7508ff6d | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2604 |  | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-931b7f90 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2605 |  | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-6fb3cf8f | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2606 |  | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-55d2d1f9 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2608 |  | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-41432f66 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2609 |  | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-7d7a7198 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2610 |  | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-4525d781 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2611 |  | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-19c432cf | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2613 |  | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-fc19fe84 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2614 |  | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-836c0615 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2616 |  | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-1a7e7422 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2619 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Memo Date" | 행/컬럼 값 대입 |  |  |  |
| AC-36a466b9 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2620 |  | DATA_OP | rowPopup.ColumnTitle["MEMO_RANGE"] | "Line or Material" | 행/컬럼 값 대입 |  |  |  |
| AC-750e5335 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2621 |  | DATA_OP | rowPopup.ColumnTitle["MEMO_TYPE"] | "Memo Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f6e73bf7 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2622 |  | DATA_OP | rowPopup.ColumnTitle["MEMO"] | "Memo" | 행/컬럼 값 대입 |  |  |  |
| AC-474750e2 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2624 |  | DATA_OP | rowPopup.ColumnTitle[DefColumns.ATTR2_TXT] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-953fc7ba | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2625 |  | DATA_OP | rowPopup.ColumnTitle[DefColumns.ATTR1_TXT] | "Model Change" | 행/컬럼 값 대입 |  |  |  |
| AC-f7a87ea5 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2627 |  | DATA_OP | rowPopup.ColumnTitle["UPDATE_ID"] | "Update User" | 행/컬럼 값 대입 |  |  |  |
| AC-eb911b5e | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2628 |  | DATA_OP | rowPopup.ColumnTitle["UPDATE_TIME"] | "Update Time" | 행/컬럼 값 대입 |  |  |  |
| AC-b758a250 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2630 |  | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-3e66decf | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2631 |  | DATA_OP | rowPopup.ColumnTitle["EDIT_FLAG"] | "Edit" | 행/컬럼 값 대입 |  |  |  |
| AC-cd6f0352 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["DIVISION_ID"] | rowPopup.ColumnWidth["SITE_ID"] = rowPopup.ColumnWidth["LINE_NAME"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-6c1a8470 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["SITE_ID"] | rowPopup.ColumnWidth["LINE_NAME"] = rowPopup.ColumnWidth["ITEM_ID"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-d18e6439 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["LINE_NAME"] | rowPopup.ColumnWidth["ITEM_ID"] = rowPopup.ColumnWidth["NICK_NAME"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-fec6d799 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["ITEM_ID"] | rowPopup.ColumnWidth["NICK_NAME"] = rowPopup.ColumnWidth["PRODUCTION_TYPE"] = 100 | 행/컬럼 값 대입 |  |  |  |
| AC-4cceb3d2 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["NICK_NAME"] | rowPopup.ColumnWidth["PRODUCTION_TYPE"] = 100 | 행/컬럼 값 대입 |  |  |  |
| AC-7b3f99fa | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2634 |  | DATA_OP | rowPopup.ColumnWidth["PRODUCTION_TYPE"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-be4035d9 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2635 |  | DATA_OP | rowPopup.ColumnWidth["MEMO"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-f12df852 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2637 |  | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-005913cc | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2639 |  | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-b0478aba | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2640 |  | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-fe329610 | this.btnExcel.Click | FP00608_PlanAmend_Memo.cs:2641 |  | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00608_PlanAmend_Memo.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9720fd59 | this.btnSql.Click | FP00608_PlanAmend_Memo.cs:1468 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2a1480c0 | this.btnSql.Click | FP00608_PlanAmend_Memo.cs:1469 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3bd8bfd6 | this.btnSql.Click | FP00608_PlanAmend_Memo.cs:1471 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00608_AMEND_MEMO_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0626f6b | this.btnSql.Click | FP00608_PlanAmend_Memo.cs:1472 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00608_AMEND_MEMO_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-80344c3a | this.btnSql.Click | FP00608_PlanAmend_Memo.cs:1473 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00608_PlanAmend_Memo.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aed904e | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2702 | try ▸ if (popup == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "No Data to save") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c4bca11 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2702 | try ▸ if (popup == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "No Data to save"); |  | 처리 중단/반환 |  |  |  |
| AC-77d6bfb5 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2704 | try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56aa58c9 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2706 | try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4b6eb1 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2707 | try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52a34e86 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2719 | try ▸ if (Save_Data_Momo_Excel(data) == true) | UI_PROP | popup.validation | null | 속성 validation 설정 |  |  |  |
| AC-954de27c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2720 | try ▸ if (Save_Data_Momo_Excel(data) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-68148c42 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2722 | try ▸ if (Save_Data_Momo_Excel(data) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c394367b | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2722 | try ▸ if (Save_Data_Momo_Excel(data) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-22c3813c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2728 | catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03070b7c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2728 | catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-b17d8fb4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2730 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Unknown error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-628b0afb | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2730 |  | RETURN | return DataService.CreateResultDataSet(false, 0, "Unknown error"); |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96927e3a | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2656 |  | DATA_OP | Filter["PLAN_DATE"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-766dba2c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2657 |  | DATA_OP | Filter["UI_END_DATE"] | pEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-61919a06 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2667 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-58421797 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2678 | if (popup != null) ▸ if (m.Good()) ▸ foreach (DataRow r in m.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "-") | DATA_OP | r["MEMO_RANGE"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-9ddebd09 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2682 | if (popup != null) ▸ if (m.Good()) ▸ foreach (DataRow r in m.Tables[0].Rows) ▸ else of (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "… | DATA_OP | r["MEMO_RANGE"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-fa67a9e7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2686 | if (popup != null) ▸ if (m.Good()) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("INSTANCE_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "OPERATION_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a73a97c5 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2690 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-bc4311fc | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2693 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e873201f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2972 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-877d1cf6 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2975 | if (data.Good()) | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef4e0e24 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2978 | if (data.Good()) | DATA_OP | Filter["GUID"] | g.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52ff3879 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2980 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("GUID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ded456d2 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2983 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["GUID"] | g.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef8f1230 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2987 | if (data.Good()) ▸ try | ENDPOINT | DataService.FP_PseudoBatch | ("MemoExcel", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-e3db6058 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2988 | if (data.Good()) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("MemoExcel", "find_Excel_buffer_validation", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6795a331 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2993 | if (data.Good()) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-cae40b87 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2998 | if (data.Good()) ▸ finally | ENDPOINT | DataService.FP_ExecuteNonQuery | ("MemoExcel", "delete_validation_buffer", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] \|… | 엔드포인트 호출 |  |  |  |
| AC-2eafb3a0 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3001 | if (data.Good()) | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-8d47508e | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3003 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.CboSite_SelectedIndexChanged

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b37a3604 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1546 |  | DATA_OP | Filter["SITE_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-6af3f1ba | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1547 |  | FLAG | dtPlantByDivision | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-62046567 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1547 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f6ba2384 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1548 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.ClbDivision_SelectedIndexChanged

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3d7a912 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1537 |  | DATA_OP | Filter["DIVISION_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-2445a65f | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1538 |  | FLAG | dtSiteByDivision | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba415d1c | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1538 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9cef98ed | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1539 |  | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.ClbFactory_SelectedIndexChanged

진입점: this.Load [try] / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25ec8b39 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1562 |  | DATA_OP | Filter["FACTORY_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-c3cf9a82 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1563 |  | FLAG | dtOperationByBuilding | DataService.GetInnerTable( "OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e453c486 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1563 |  | COMBO_DATA | DataService.GetInnerTable | ( "OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-bbabb570 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1564 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ec4e0e0 | clbLine.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:274 |  | DATA_OP | Filter["LINE_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |

## FP00608_PlanAmend_Memo.ClbOperation_SelectedIndexChanged

진입점: this.Load [try] / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39c2420a | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1570 |  | DATA_OP | Filter["OPERATION_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-06f895d0 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1571 |  | FLAG | dtLineByOperation | DataService.GetInnerTable( "LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-815e1d55 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1571 |  | COMBO_DATA | DataService.GetInnerTable | ( "LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f8929990 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1572 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.ClbPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9cc4e1b | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1554 |  | DATA_OP | Filter["PLANT_ID"] | sDataID | 행/컬럼 값 대입 |  |  |  |
| AC-a9e7f995 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1555 |  | FLAG | dtBuildingBySitePlant | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6872fe2 | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1555 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-88db537e | this.Load [try] 외 1 | FP00608_PlanAmend_Memo.cs:1556 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d03aec5a | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:284 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b1ac7e59 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:285 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00608_PlanAmend_Memo.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b09c3fc | this.Load | FP00608_PlanAmend_Memo.cs:294 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c19d3ca9 | this.Load | FP00608_PlanAmend_Memo.cs:295 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f23a1fb7 | this.Load | FP00608_PlanAmend_Memo.cs:297 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00608_PlanAmend_Memo.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0f8580c | this.Load | FP00608_PlanAmend_Memo.cs:231 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-9d8709a6 | this.Load | FP00608_PlanAmend_Memo.cs:233 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-35f8bf9e | this.Load | FP00608_PlanAmend_Memo.cs:234 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-b9137830 | this.Load | FP00608_PlanAmend_Memo.cs:235 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3fb5f8b9 | this.Load | FP00608_PlanAmend_Memo.cs:237 |  | FLAG | cellTypeDef | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |

## FP00608_PlanAmend_Memo.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c384b15f | DeleteButton | FP00608_PlanAmend_Memo.cs:600 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00608_PlanAmend_Memo.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e8b95a8 | Dispose | FP00608_PlanAmend_Memo.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00608_PlanAmend_Memo.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8176315e | EditButton | FP00608_PlanAmend_Memo.cs:544 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3fce318e | EditButton | FP00608_PlanAmend_Memo.cs:548 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f46621f4 | EditButton | FP00608_PlanAmend_Memo.cs:560 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-61cd7076 | EditButton | FP00608_PlanAmend_Memo.cs:564 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ATTR1_TXT), siMain.GetColumnIndex(DefColumns.ATTR1_TXT),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e14f53a | EditButton | FP00608_PlanAmend_Memo.cs:565 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ATTR2_TXT), siMain.GetColumnIndex(DefColumns.ATTR2_TXT),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aff656ad | EditButton | FP00608_PlanAmend_Memo.cs:567 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MEMO), siMain.GetColumnIndex(DefColumns.MEMO), IsLock) | 그리드 편집 잠금/해제 |  |  |  |

## FP00608_PlanAmend_Memo.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2ae5213 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3027 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee86ae24 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3028 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdd58282 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3030 |  | FLAG | clicked_row | siMain.ActiveSheet.Rows[cRow].Tag as DataRow | 화면 필드/플래그 변경 |  |  |  |
| AC-e9f36917 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3032 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fbabd91 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3056 | if (cCol== attr2_idx && attr2_idx > -1) ▸ if (string.IsNullOrWhiteSpace(cateids)) | GRID_SET | siMain.SetValue | (cRow, attr2_idx, "") | 그리드 값 설정 |  |  |  |
| AC-246ba7b0 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3065 | else of (cCol== attr2_idx && attr2_idx > -1) ▸ if (cCol == attr1_idx && attr1_idx > -1) ▸ if (s_instance_id_tmp != copy_buf_instance_id \|\|… | FLAG | copy_buf_ModelChangeTable | GetModelChangeTable(s_instance_id_tmp) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb55b87f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3066 | else of (cCol== attr2_idx && attr2_idx > -1) ▸ if (cCol == attr1_idx && attr1_idx > -1) ▸ if (s_instance_id_tmp != copy_buf_instance_id \|\|… | FLAG | copy_buf_instance_id | s_instance_id_tmp | 화면 필드/플래그 변경 |  |  |  |
| AC-1ce71b5c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:3072 | else of (cCol== attr2_idx && attr2_idx > -1) ▸ if (cCol == attr1_idx && attr1_idx > -1) ▸ if (string.IsNullOrWhiteSpace(model_change_id)) | GRID_SET | siMain.SetValue | (cRow, attr1_idx, model_change_id) | 그리드 값 설정 |  |  |  |

## FP00608_PlanAmend_Memo.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca661353 | ExcelButton | FP00608_PlanAmend_Memo.cs:846 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00608_PlanAmend_Memo.Find_Data_Memo

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d52cc01 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1001 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivision = CString.GetCheckedListValue(dtMyDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1496d2c | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1021 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00608_AMEND_MEMO") ⇒ FP_Planning.PR_UI_FP00608_AMEND_MEMO | 엔드포인트 요청 생성 |  |  |  |
| AC-5dfde0d5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1022 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-77aaadf1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1023 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-120a4aac | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1024 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae924078 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1025 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e941e8a2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1027 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6133cbd1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1028 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-af8b2370 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1029 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c61cc8f4 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1030 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-9e502f15 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1031 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-2ba9f3d3 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1032 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactory | 행/컬럼 값 대입 |  |  |  |
| AC-cd5d6211 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1033 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-7b09f890 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1034 | try | DATA_OP | request.Parameters["p_line_id"] | pLine | 행/컬럼 값 대입 |  |  |  |
| AC-aca0434a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1035 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-260a0c29 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1036 | try | DATA_OP | request.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e321c5ef | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1037 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d6de6aa | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1038 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfc01f7f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1039 | try | DATA_OP | request.Parameters["p_top_item_id"] | pModel | 행/컬럼 값 대입 |  |  |  |
| AC-9100dcbd | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1040 | try | DATA_OP | request.Parameters["p_item_id"] | pItem | 행/컬럼 값 대입 |  |  |  |
| AC-074de507 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1041 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f0ab7fa | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1042 | try | DATA_OP | request.Parameters["p_plan_date"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-f715ec1a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1043 | try | DATA_OP | request.Parameters["p_memo"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97d7bd90 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1044 | try | DATA_OP | request.Parameters["p_memo_type"] | pMemoType | 행/컬럼 값 대입 |  |  |  |
| AC-36b132cd | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1045 | try | DATA_OP | request.Parameters["p_start_date"] | pStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-5d6d5efb | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1046 | try | DATA_OP | request.Parameters["p_end_date"] | pEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-63715002 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1048 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bac58e91 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1052 | try ▸ if (dsMain!=null) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | (DefColumns.ATTR2_TXT, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99f79e96 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1053 | try ▸ if (dsMain!=null) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | (DefColumns.ATTR1_TXT, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b185916 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1054 | try ▸ if (dsMain!=null) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("EDIT_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3b64c0b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1059 | try ▸ if (dsMain.Good()) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f521c3a3 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1060 | try ▸ if (dsMain.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9bd51353 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1064 | try ▸ if (dsMain.Good()) | DATA_OP | coteInfo.Select | ("SEGMENT1 = 'ETC'") | 데이터 객체 조작/조회 |  |  |  |
| AC-baaeec73 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1067 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | coteInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97e463c2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1071 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["LOOKUP_TYPE_CODE"] | "CAPA_UI_LOSS_TYPE_DEFINIT" | 행/컬럼 값 대입 |  |  |  |
| AC-eee80342 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1072 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT1"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-6b3ed80b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1073 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT2"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0ea25b4b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1074 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT3"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-e7b931bf | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1075 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT4"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-fff5a41e | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1076 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT5"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-58d96d0b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1077 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SORT_ORDER"] | "900" | 행/컬럼 값 대입 |  |  |  |
| AC-c5b99a91 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1078 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-81ca0e79 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1079 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["VALUE_DESCRIPTION"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-b6f209b9 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1080 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE1"] | "No-Load" | 행/컬럼 값 대입 |  |  |  |
| AC-3df71867 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1081 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE2"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-4a33c9e7 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1082 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97226103 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1083 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE4"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-9ba396b0 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1084 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80d3cce1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1085 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE6"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9ca1dda | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1086 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE7"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7fd4a867 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1087 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE8"] | "60" | 행/컬럼 값 대입 |  |  |  |
| AC-2044c2a3 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1088 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE9"] | "Min" | 행/컬럼 값 대입 |  |  |  |
| AC-633898dd | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1089 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE10"] | "#F1F1F1" | 행/컬럼 값 대입 |  |  |  |
| AC-85240b5a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1090 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE11"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dfa2acb8 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1091 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE12"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c0e8f63 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1092 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE13"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4279968 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1093 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE14"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2252353 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1094 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE15"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03d2bc4b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1095 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-539eba47 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1096 | try ▸ if (dsMain.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | coteInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a73872 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1102 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | DATA_OP | r["ATTR2_TXT"] | GetCateText(coteInfo, r["ATTR2"].SafeString()) | 행/컬럼 값 대입 |  |  |  |
| AC-9b5990fb | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1113 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | DATA_OP | r["ATTR1_TXT"] | s_attr1_txt | 행/컬럼 값 대입 |  |  |  |
| AC-ada36223 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1117 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(equipment_txt)) | DATA_OP | r["EQUIPMENT_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-43769190 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1121 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "-") | DATA_OP | r["MEMO_RANGE"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-35f310d9 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1125 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ else of (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "-") | DATA_OP | r["MEMO_RANGE"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-67f7f309 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1127 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | DATA_OP | r["EDIT_FLAG"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0ad73704 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1130 | try | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |
| AC-77432485 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:1135 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.Find_Data_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-950485ed | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:852 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ec85493 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:856 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6acce97c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:859 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e7e7482d | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:859 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9367b92f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:865 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-569be208 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:868 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-beebb3cb | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:875 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Memo("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-68f5ea80 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:881 | try ▸ if (!ds.Good()) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0eae12a0 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:890 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-315ad4ad | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:893 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-949475f6 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:895 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-90e3da7b | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:899 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09983607 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:911 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-ab46293d | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:920 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-942816a4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:922 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f6d2ada | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:922 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00608_PlanAmend_Memo.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d183aa0 | this.Load | FP00608_PlanAmend_Memo.cs:124 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00608_PlanAmend_Memo.GetCateId

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ for (i <= siMain.GetMaxRowIndex())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b7f6398 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:394 | if (!cate.Good()) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-864531ea | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:397 | if (string.IsNullOrWhiteSpace(text)) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-ff7dd53a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:403 | if (cates != null && cates.Length > 0) ▸ for (i < cates.Length) | DATA_OP | cate.Select | ("ATTRIBUTE2='" + cates[i].SafeString() + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a947ade2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:416 | if (cates != null && cates.Length > 0) | RETURN | return cates_string; |  | 처리 중단/반환 |  |  |  |
| AC-84dba0aa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:418 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.GetCateTable

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cf7a9af | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2411 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f45b4515 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2412 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cb162ac8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2414 | if (!coteInfo.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3eb8e599 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2415 |  | DATA_OP | coteInfo.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-207b1d73 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2416 |  | DATA_OP | coteInfo.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b4e4dbd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2420 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["CODE"] | cate["SEGMENT1"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ff22a9f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2421 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["NAME"] | cate["ATTRIBUTE2"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d79c6536 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2422 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["ATTRIBUTE2"].SafeString().ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e67e7252 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … | FP00608_PlanAmend_Memo.cs:2425 |  | RETURN | return coteInfo; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.GetCateText

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / popSql.OnSql [if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT") ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10252748 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:424 | if (string.IsNullOrWhiteSpace(text)) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-4fe71eeb | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:430 | if (cates!=null && cates.Length > 0) ▸ for (i < cates.Length) | DATA_OP | cate.Select | ("SEGMENT1='" + cates[i].SafeString() + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-57e41eef | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:443 | if (cates!=null && cates.Length > 0) | RETURN | return cates_string; |  | 처리 중단/반환 |  |  |  |
| AC-0ce3e95f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:445 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.GetModelChange

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ for (i <= siMain.GetMaxRowIndex())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-341d75a5 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:368 | if (modelchange.Good()) | DATA_OP | modelchange.Select | ("UI_DESC='" + text + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd853eda | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:371 | if (modelchange.Good()) ▸ if (rows!=null && rows.Length > 0) | RETURN | return rows[0]["CODE"].SafeString(); |  | 처리 중단/반환 |  |  |  |
| AC-540702da | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:373 | if (modelchange.Good()) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-ca0dae1e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | FP00608_PlanAmend_Memo.cs:375 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.GetModelChangeTable

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (modelChangeTable == null \|\| instance_id != s_instance_id_tmp)] / popSql.OnSql [if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT") ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (modelChangeTable == null \|\| instance_id != s_instance_id_tmp)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Go…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec4067e5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2431 |  | DATA_OP | Filter["INSTANCE_ID"] | Instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-7373b74b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2432 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("AmendMemo", "find_SetupColor_P_ID", Filter.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] \| FP\Com… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-88c1f0fe | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2437 |  | DATA_OP | modeChange.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-be2b2f87 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2438 |  | DATA_OP | modeChange.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-91965d64 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2442 | foreach (DataRow cate in modeChange.Rows) | DATA_OP | cate["CODE"] | cate["COLOR_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0b917ef | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2443 | foreach (DataRow cate in modeChange.Rows) | DATA_OP | cate["NAME"] | cate["UI_COLOR"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0767350 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:2445 |  | RETURN | return modeChange; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.GetModelChangeText

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / popSql.OnSql [if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT") ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c31b3e3 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:382 | if (modelchange.Good()) | DATA_OP | modelchange.Select | ("CODE='" + model_id + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9956d2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:385 | if (modelchange.Good()) ▸ if (rows != null && rows.Length > 0) | RETURN | return rows[0]["UI_DESC"].SafeString(); |  | 처리 중단/반환 |  |  |  |
| AC-b29dd2a6 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:387 | if (modelchange.Good()) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-e910dffe | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:389 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c56dd4c9 | this.Load | FP00608_PlanAmend_Memo.cs:156 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-06758281 | this.Load | FP00608_PlanAmend_Memo.cs:158 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-efc08371 | this.Load | FP00608_PlanAmend_Memo.cs:160 | try | FLAG | dtMyDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-138ab748 | this.Load | FP00608_PlanAmend_Memo.cs:160 | try | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b8336413 | this.Load | FP00608_PlanAmend_Memo.cs:163 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-c127ad30 | this.Load | FP00608_PlanAmend_Memo.cs:166 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-963f1087 | this.Load | FP00608_PlanAmend_Memo.cs:173 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-980d258e | this.Load | FP00608_PlanAmend_Memo.cs:176 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-ea835eca | this.Load | FP00608_PlanAmend_Memo.cs:177 | try | FLAG | this._sMemoType | "DPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-5f17071c | this.Load | FP00608_PlanAmend_Memo.cs:183 | try | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sEndday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8a42ff26 | this.Load | FP00608_PlanAmend_Memo.cs:198 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-065cd4fa | this.Load | FP00608_PlanAmend_Memo.cs:199 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-395c570b | this.Load | FP00608_PlanAmend_Memo.cs:200 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bc06f8bd | this.Load | FP00608_PlanAmend_Memo.cs:203 | try | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83992e48 | this.Load | FP00608_PlanAmend_Memo.cs:205 | try ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnExcel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-45ade680 | this.Load | FP00608_PlanAmend_Memo.cs:206 | try ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ba3ba32b | this.Load | FP00608_PlanAmend_Memo.cs:211 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-9b390d02 | this.Load | FP00608_PlanAmend_Memo.cs:213 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-a9a0a177 | this.Load | FP00608_PlanAmend_Memo.cs:217 | try ▸ if (_sSaveAuth == "N") | STATE | btnExcel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-89032b92 | this.Load | FP00608_PlanAmend_Memo.cs:218 | try ▸ if (_sSaveAuth == "N") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1ffbc6f5 | this.Load | FP00608_PlanAmend_Memo.cs:224 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee769960 | this.Load | FP00608_PlanAmend_Memo.cs:250 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-449d58d7 | this.Load | FP00608_PlanAmend_Memo.cs:251 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-cdd2ce13 | this.Load | FP00608_PlanAmend_Memo.cs:252 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-577e508a | this.Load | FP00608_PlanAmend_Memo.cs:253 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e8a66a16 | this.Load | FP00608_PlanAmend_Memo.cs:254 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00608_PlanAmend_Memo.InitSpread

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / this.Load / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2eb28693 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:309 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ee780f1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:310 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4cb21577 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:314 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a0c9240 | InsertButton | FP00608_PlanAmend_Memo.cs:660 | if (fps != null) ▸ if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acf9e5f3 | InsertButton | FP00608_PlanAmend_Memo.cs:674 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a45479e9 | InsertButton | FP00608_PlanAmend_Memo.cs:727 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9b5a32a1 | InsertButton | FP00608_PlanAmend_Memo.cs:731 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7abd921d | InsertButton | FP00608_PlanAmend_Memo.cs:732 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f9d4b514 | InsertButton | FP00608_PlanAmend_Memo.cs:733 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.LINE_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-aad6b17c | InsertButton | FP00608_PlanAmend_Memo.cs:737 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-8f96200d | InsertButton | FP00608_PlanAmend_Memo.cs:742 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MARKET)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8e0f749f | InsertButton | FP00608_PlanAmend_Memo.cs:743 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-45af48c6 | InsertButton | FP00608_PlanAmend_Memo.cs:744 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEMO_RANGE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-df2ff4ec | InsertButton | FP00608_PlanAmend_Memo.cs:749 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-ed2a949d | InsertButton | FP00608_PlanAmend_Memo.cs:751 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEMO_RANGE)].Value | "Material" | 그리드 속성/값 설정 |  |  |  |
| AC-63aeafda | InsertButton | FP00608_PlanAmend_Memo.cs:753 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1850aef7 | InsertButton | FP00608_PlanAmend_Memo.cs:754 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SITE_ID), siMain.GetColumnIndex(DefColumns.SITE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9fc4f29d | InsertButton | FP00608_PlanAmend_Memo.cs:755 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PLANT_ID), siMain.GetColumnIndex(DefColumns.PLA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c51f6fc9 | InsertButton | FP00608_PlanAmend_Memo.cs:757 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ea876e0 | InsertButton | FP00608_PlanAmend_Memo.cs:758 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe18b16f | InsertButton | FP00608_PlanAmend_Memo.cs:759 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cb7c3ffd | InsertButton | FP00608_PlanAmend_Memo.cs:760 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.MARKET), siMain.GetColumnIndex(DefColumns.MARKE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-592ef31a | InsertButton | FP00608_PlanAmend_Memo.cs:761 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9333fc8 | InsertButton | FP00608_PlanAmend_Memo.cs:762 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcf6434f | InsertButton | FP00608_PlanAmend_Memo.cs:763 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetColumnIndex(DefColumns.ITEM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f851309 | InsertButton | FP00608_PlanAmend_Memo.cs:766 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.MEMO_RANGE), siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f690c271 | InsertButton | FP00608_PlanAmend_Memo.cs:767 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.MEMO), siMain.GetColumnIndex(DefColumns.MEMO), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d0e83ad | InsertButton | FP00608_PlanAmend_Memo.cs:770 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ATTR1_TXT), siMain.GetColumnIndex(DefColumns.AT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db543f42 | InsertButton | FP00608_PlanAmend_Memo.cs:771 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ATTR2_TXT), siMain.GetColumnIndex(DefColumns.AT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8dde906c | InsertButton | FP00608_PlanAmend_Memo.cs:773 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88cd8f8d | InsertButton | FP00608_PlanAmend_Memo.cs:774 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.UP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a00bcbea | InsertButton | FP00608_PlanAmend_Memo.cs:775 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.UPDATE_TIME), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-31a95d86 | InsertButton | FP00608_PlanAmend_Memo.cs:776 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_NAME), siMain.GetColumnIndex(DefColumns.LI… | 그리드 편집 잠금/해제 |  |  |  |

## FP00608_PlanAmend_Memo.Insert_Row_Dialog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9556f936 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:629 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e1952862 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:632 |  | POPUP | new FPC0608_MemoAddPopup | (this._sMemoType) | 팝업/폼 생성 |  |  |  |
| AC-e6e43906 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:633 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-40c8f99e | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:634 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00608_PlanAmend_Memo.rdoGroup1_SelectedIndexChanged

진입점: this.rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f627105 | this.rdoGroup1.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:2314 | if (radioGroup.SelectedIndex == 0) | FLAG | this._sMemoType | "DPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa95c5d | this.rdoGroup1.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:2318 | else of (radioGroup.SelectedIndex == 0) ▸ if (radioGroup.SelectedIndex == 1) | FLAG | this._sMemoType | "WPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-777d43a0 | this.rdoGroup1.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:2322 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ if (radioGroup.SelectedIndex == 2) | FLAG | this._sMemoType | "MPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-d07933ae | this.rdoGroup1.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:2326 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ else of (radioGroup.SelectedIndex == 2) ▸ if (radioGroup… | FLAG | this._sMemoType | "MRP" | 화면 필드/플래그 변경 |  |  |  |
| AC-4c7e1655 | this.rdoGroup1.SelectedIndexChanged | FP00608_PlanAmend_Memo.cs:2330 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ else of (radioGroup.SelectedIndex == 2) ▸ else of (radio… | FLAG | this._sMemoType | "WO" | 화면 필드/플래그 변경 |  |  |  |

## FP00608_PlanAmend_Memo.RefreshHeader

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27b9e52f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FP00608_PlanAmend_Memo.cs:952 | if (!dsMain.Good()) | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a3fe6423 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FP00608_PlanAmend_Memo.cs:956 | else of (!dsMain.Good()) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-93862d06 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FP00608_PlanAmend_Memo.cs:967 | else of (!dsMain.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (r!=null) ▸ if (freq > 0) | UI_PROP | row.Height | 20 * (freq + 1) | 속성 Height 설정 |  |  |  |
| AC-ce3ae9ee | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FP00608_PlanAmend_Memo.cs:971 | else of (!dsMain.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (r!=null) ▸ else of (freq > 0) | UI_PROP | row.Height | 30 | 속성 Height 설정 |  |  |  |

## FP00608_PlanAmend_Memo.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bbd5f5c | popSql.OnSql | FP00608_PlanAmend_Memo.cs:2349 | if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-548316ca | popSql.OnSql | FP00608_PlanAmend_Memo.cs:2355 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01a2a393 | SaveButton | FP00608_PlanAmend_Memo.cs:1146 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-365620eb | SaveButton | FP00608_PlanAmend_Memo.cs:1148 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eed9a3e8 | SaveButton | FP00608_PlanAmend_Memo.cs:1152 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39b1c281 | SaveButton | FP00608_PlanAmend_Memo.cs:1153 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b40b9ee | SaveButton | FP00608_PlanAmend_Memo.cs:1156 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2ebfc9c8 | SaveButton | FP00608_PlanAmend_Memo.cs:1163 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8ada571c | SaveButton | FP00608_PlanAmend_Memo.cs:1165 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b0f37aa9 | SaveButton | FP00608_PlanAmend_Memo.cs:1166 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a38c195f | SaveButton | FP00608_PlanAmend_Memo.cs:1180 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a9a345c | SaveButton | FP00608_PlanAmend_Memo.cs:1185 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { drResult.Count}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b39d1ff9 | SaveButton | FP00608_PlanAmend_Memo.cs:1194 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (drResult.Success) | MESSAGE | MessageBox.Show | (errorMsg) | 메시지 표시 |  |  |  |
| AC-6137e93b | SaveButton | FP00608_PlanAmend_Memo.cs:1199 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1501a460 | SaveButton | FP00608_PlanAmend_Memo.cs:1203 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b0fd3e66 | SaveButton | FP00608_PlanAmend_Memo.cs:1204 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a68bea61 | SaveButton | FP00608_PlanAmend_Memo.cs:1209 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00608_PlanAmend_Memo.Save_Data_Momo

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27f22bbe | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1218 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e1e46bb2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1255 | try | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-cebb1728 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1256 | try | UI_PROP | dtSave.TableName | "SaveTable" | 속성 TableName 설정 |  |  |  |
| AC-ee880ae4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1257 | try | DATA_OP | dtSave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b2424f7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1258 | try | DATA_OP | dtSave.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-158c4c5f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1259 | try | DATA_OP | dtSave.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bccbb448 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1260 | try | DATA_OP | dtSave.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4043ddc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1261 | try | DATA_OP | dtSave.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f422ad9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1262 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a898690b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1263 | try | DATA_OP | dtSave.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a45d3dd9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1264 | try | DATA_OP | dtSave.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a9f3dfc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1265 | try | DATA_OP | dtSave.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b66bd8b2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1266 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82f7c714 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1267 | try | DATA_OP | dtSave.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-954ec753 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1268 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4a08a5d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1269 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f086cbff | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1270 | try | DATA_OP | dtSave.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1a9f000 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1271 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-78fd5c09 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1272 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c75d9fa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1273 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6003f629 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1274 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d409892d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1275 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR1", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d78c1258 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1276 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR2", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ba285dd | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1277 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR1_TXT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19968b43 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1278 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR2_TXT", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4db3a55d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1280 | try | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f792d40b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1328 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(s_line_id)) | MESSAGE | MessageBox.Show | (err) | 메시지 표시 |  |  |  |
| AC-bae58a17 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1329 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(s_line_id)) | THROW | throw new Exception(err); |  | 예외 발생 |  |  |  |
| AC-14c2ddb3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1334 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(s_memo_range)) | MESSAGE | MessageBox.Show | (err) | 메시지 표시 |  |  |  |
| AC-d5353a11 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1335 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(s_memo_range)) | THROW | throw new Exception(err); |  | 예외 발생 |  |  |  |
| AC-5d22119a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1340 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (s_memo_range.ToUpper() == "MATERIAL" && string.IsNullOrWhiteSpace(s_item_id)) | MESSAGE | MessageBox.Show | (err) | 메시지 표시 |  |  |  |
| AC-29047c44 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1341 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (s_memo_range.ToUpper() == "MATERIAL" && string.IsNullOrWhiteSpace(s_item_id)) | THROW | throw new Exception(err); |  | 예외 발생 |  |  |  |
| AC-82ac18f0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1346 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dtDelete.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a734b6f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1347 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dtDelete.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-60149491 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1348 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | s_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6962a66b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1349 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.COMPANY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-fff5c5ab | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1350 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5aa5af2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1351 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SITE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SITE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ebd6eba | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1352 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PLANT_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-207f25b6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1353 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.FACTORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-973e51df | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1354 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-9615d543 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1355 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.LINE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d63e9ce3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1356 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ELECTRODE_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fe3a375 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1357 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.EQUIPMENT_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d65d0e1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1359 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MARKET] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MARKET)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c290f1e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1360 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PRODUCTION_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-f750ad98 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1361 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.TOP_ITEM_ID] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5407823 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1362 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ITEM_ID] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef66440b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1363 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PLAN_DATE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-bce5a9de | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1364 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MEMO] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEMO)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-a30f759a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1365 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MEMO_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEMO_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-f31f2530 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1366 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ATTR1] | s_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-5e027e7c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1367 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ATTR2] | s_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-efe8beac | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1368 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bf9a4e10 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1372 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-880f4948 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1373 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-82322f28 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1374 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7d12d14 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1375 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.COMPANY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-6bdd31e8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1376 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-d3001ba2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1377 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SITE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SITE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-eaf9ede5 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1378 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PLANT_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-3991aabb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1379 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.FACTORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-019b086c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1380 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-21b195eb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1381 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.LINE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-806721e0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1382 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ELECTRODE_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef7c4b06 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1383 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.EQUIPMENT_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c1b7b16 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1385 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MARKET] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MARKET)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-8152636c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1386 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PRODUCTION_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-95281cd7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1387 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.TOP_ITEM_ID] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe141bfa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1388 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ITEM_ID] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-f93d67bf | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1389 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.PLAN_DATE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_DATE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-73594c45 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1391 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | memo.Contains | ("\r\r\n") | 데이터 객체 조작/조회 |  |  |  |
| AC-6071b730 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1395 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MEMO] | memo | 행/컬럼 값 대입 |  |  |  |
| AC-deaa3ba6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1397 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.MEMO_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEMO_TYPE)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-7f70e80b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1398 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ATTR1] | s_attr1 | 행/컬럼 값 대입 |  |  |  |
| AC-6915f42a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1399 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.ATTR2] | s_attr2 | 행/컬럼 값 대입 |  |  |  |
| AC-95638f20 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1400 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d80fd2dc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1411 | try ▸ if (iCount > 0) ▸ if (dsDelete.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("AmendMemo", "delete_amend_memo", dsDelete) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-c59a1487 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1412 | try ▸ if (iCount > 0) ▸ if (dsDelete.Good()) | CALL_EXT | DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81cfd404 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1416 | try ▸ if (iCount > 0) ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("AmendMemo", "fetch_amend_memo", dsSave) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] \| FP\Common\A… | 엔드포인트 호출 |  |  |  |
| AC-c722700a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1417 | try ▸ if (iCount > 0) ▸ if (dsSave.Good()) | CALL_EXT | DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-497f0bf2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1423 | try ▸ if (iCount > 0) ▸ if (drA != null && drB == null) | UI_PROP | drResult.Success | drA.Success | 속성 Success 설정 |  |  |  |
| AC-8d358990 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1424 | try ▸ if (iCount > 0) ▸ if (drA != null && drB == null) | UI_PROP | drResult.Count | drA.Count | 속성 Count 설정 |  |  |  |
| AC-6238d2b9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1425 | try ▸ if (iCount > 0) ▸ if (drA != null && drB == null) | UI_PROP | drResult.Message | drA.Message | 속성 Message 설정 |  |  |  |
| AC-61eda8fe | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1429 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ if (drB != null && drA == null) | UI_PROP | drResult.Success | drB.Success | 속성 Success 설정 |  |  |  |
| AC-e425b9f1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1430 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ if (drB != null && drA == null) | UI_PROP | drResult.Count | drB.Count | 속성 Count 설정 |  |  |  |
| AC-0ef23ecc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1431 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ if (drB != null && drA == null) | UI_PROP | drResult.Message | drB.Message | 속성 Message 설정 |  |  |  |
| AC-67302b91 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1435 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ else of (drB != null && drA == null) | UI_PROP | drResult.Success | drA.Success && drB.Success | 속성 Success 설정 |  |  |  |
| AC-e2467c1b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1436 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ else of (drB != null && drA == null) | UI_PROP | drResult.Count | drA.Count + drB.Count | 속성 Count 설정 |  |  |  |
| AC-94802a3a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1437 | try ▸ if (iCount > 0) ▸ else of (drA != null && drB == null) ▸ else of (drB != null && drA == null) | UI_PROP | drResult.Message | drA.Message + "\r\n" + drB.Message | 속성 Message 설정 |  |  |  |
| AC-bde7b7b4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1439 | try ▸ if (iCount > 0) | RETURN | return drResult; |  | 처리 중단/반환 |  |  |  |
| AC-297b23c8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1443 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99b6e275 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1444 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-dc119689 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP00608_PlanAmend_Memo.cs:1450 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.Save_Data_Momo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2f5bd8a | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2737 | if (!dsSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6ed91ee7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2778 | try | DATA_OP | dtSave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-239c9dc4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2779 | try | DATA_OP | dtSave.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2405799c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2780 | try | DATA_OP | dtSave.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-200dcddd | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2781 | try | DATA_OP | dtSave.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8cf0fa2 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2782 | try | DATA_OP | dtSave.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-daf8cfd2 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2783 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c60af842 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2784 | try | DATA_OP | dtSave.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f27b3f7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2785 | try | DATA_OP | dtSave.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ca1c31 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2786 | try | DATA_OP | dtSave.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1eb0c724 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2787 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e447a42c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2788 | try | DATA_OP | dtSave.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5dfa304 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2789 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4ec07db | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2790 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a96a903 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2791 | try | DATA_OP | dtSave.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-228e2664 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2792 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2902ce03 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2793 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dff04506 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2794 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a717d0d8 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2795 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc6998ec | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2796 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO_RANGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86bc2a27 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2797 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR1", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d13cc02c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2798 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR2", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65872332 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2799 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR3", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f8a2b20 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2800 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR4", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5162e7c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2801 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR5", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e4a3803 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2816 | try ▸ if (dsSave.Good()) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5fabbcf6 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2817 | try ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-51e06cee | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2819 | try ▸ if (dsSave.Good()) | DATA_OP | coteInfo.Select | ("SEGMENT1 = 'ETC'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bbeb329 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2822 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | coteInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e87e761 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2826 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["LOOKUP_TYPE_CODE"] | "CAPA_UI_LOSS_TYPE_DEFINIT" | 행/컬럼 값 대입 |  |  |  |
| AC-f510823b | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2827 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT1"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-843182a1 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2828 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT2"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-095f4e1f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2829 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT3"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-387fcab7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2830 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT4"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-58ed3356 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2831 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SEGMENT5"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-cf808bd3 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2832 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["SORT_ORDER"] | "900" | 행/컬럼 값 대입 |  |  |  |
| AC-3689128c | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2833 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-86170cb4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2834 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["VALUE_DESCRIPTION"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-6ce006ef | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2835 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE1"] | "No-Load" | 행/컬럼 값 대입 |  |  |  |
| AC-8ed14530 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2836 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE2"] | "Etc" | 행/컬럼 값 대입 |  |  |  |
| AC-5d5cbaa4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2837 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86d0f60d | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2838 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE4"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e214ed99 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2839 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d74dc5be | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2840 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE6"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8582beb8 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2841 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE7"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b770bed5 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2842 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE8"] | "60" | 행/컬럼 값 대입 |  |  |  |
| AC-b2cec300 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2843 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE9"] | "Min" | 행/컬럼 값 대입 |  |  |  |
| AC-91ed83a7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2844 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE10"] | "#F1F1F1" | 행/컬럼 값 대입 |  |  |  |
| AC-df6c6967 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2845 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE11"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6de24b01 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2846 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE12"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-041684cb | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2847 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE13"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6108e0e8 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2848 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE14"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-316915d8 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2849 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["ATTRIBUTE15"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eea81119 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2850 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | nn["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ff2edd9 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2851 | try ▸ if (dsSave.Good()) ▸ if (rowsEtc.Length < 1) | DATA_OP | coteInfo.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2130cf8b | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2861 | try ▸ if (dsSave.Good()) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) | DATA_OP | r["ATTR2"] | GetCateId(coteInfo, attr2_Text) | 행/컬럼 값 대입 |  |  |  |
| AC-c8dfdf53 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2869 | try ▸ if (dsSave.Good()) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) | DATA_OP | r["ATTR1"] | GetModelChange(modelChangeTable, attr1_Text) | 행/컬럼 값 대입 |  |  |  |
| AC-f6f688b2 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2872 | try ▸ if (dsSave.Good()) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ce394f4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2873 | try ▸ if (dsSave.Good()) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d5f9b7a | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2878 | try ▸ if (dsSave.Good()) ▸ try | DATA_OP | dsSave.Tables[0].AsEnumerable() .Where(row => row.Field<string>("EDIT_FLAG") != "D").CopyT… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-80f910d4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2879 | try ▸ if (dsSave.Good()) ▸ try ▸ lambda | DATA_OP | row.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-930f3f57 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2881 | try ▸ if (dsSave.Good()) ▸ try | UI_PROP | dtSavePart.TableName | "save" | 속성 TableName 설정 |  |  |  |
| AC-acffa450 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2887 | try ▸ if (dsSave.Good()) ▸ try | DATA_OP | dsSave.Tables[0].AsEnumerable() .Where(row => row.Field<string>("EDIT_FLAG").SafeString().… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-def4103f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2888 | try ▸ if (dsSave.Good()) ▸ try ▸ lambda | DATA_OP | row.Field | ("EDIT_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-79dbb8c1 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2890 | try ▸ if (dsSave.Good()) ▸ try | UI_PROP | dtRemovePart.TableName | "remove" | 속성 TableName 설정 |  |  |  |
| AC-6e5edce6 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2899 | try ▸ if (dsSave.Good()) ▸ if (dtSavePart.Good()) | ENDPOINT | DataService.FP_UpdateBatch2 | ("AmendMemo", "fetch_amend_memo", dtSavePart) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] \| FP\Common\A… | 엔드포인트 호출 |  |  |  |
| AC-1d0082cb | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2904 | try ▸ if (dsSave.Good()) ▸ if (dtRemovePart.Good()) | ENDPOINT | DataService.FP_UpdateBatch2 | ("AmendMemo", "delete_amend_memo_excel", dtRemovePart) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_amend_memo_excel] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-ecc243c7 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2905 | try ▸ if (dsSave.Good()) | CALL_EXT | DataService.ReadResult | (dtResult2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03ef16b6 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2906 | try ▸ if (dsSave.Good()) | CALL_EXT | DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c1d742f | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2909 | try ▸ if (dsSave.Good()) ▸ if (remR.Success &&remR.Count >0 \|\| editR.Success && editR.Count > 0) | UI_PROP | drB.Success | true | 속성 Success 설정 |  |  |  |
| AC-45a1f104 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2911 | try ▸ if (dsSave.Good()) ▸ if (remR.Success &&remR.Count >0 \|\| editR.Success && editR.Count > 0) ▸ if (editR.Success) | UI_PROP | drB.Count | += editR.Count | 속성 Count 설정 |  |  |  |
| AC-2a9a0bdc | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2913 | try ▸ if (dsSave.Good()) ▸ if (remR.Success &&remR.Count >0 \|\| editR.Success && editR.Count > 0) ▸ if (remR.Success) | UI_PROP | drB.Count | += remR.Count | 속성 Count 설정 |  |  |  |
| AC-7286125e | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2932 | try | UI_PROP | drResult.Success | drB.Success | 속성 Success 설정 |  |  |  |
| AC-38356f4d | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2933 | try | UI_PROP | drResult.Count | drB.Count | 속성 Count 설정 |  |  |  |
| AC-bf9a192a | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2934 | try | UI_PROP | drResult.Message | drB.Message | 속성 Message 설정 |  |  |  |
| AC-499137db | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2936 | try | RETURN | return drResult.Success; |  | 처리 중단/반환 |  |  |  |
| AC-212b8cec | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2947 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6294ab9 | SaveButton | FP00608_PlanAmend_Memo.cs:607 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ecd91a01 | SaveButton | FP00608_PlanAmend_Memo.cs:608 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4d0b4b7c | SaveButton | FP00608_PlanAmend_Memo.cs:610 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00608_PlanAmend_Memo.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c16f5f3 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2957 |  | DATA_OP | BohSet["PLAN_DATE"] | popupFilter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ecf66f4 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2958 |  | DATA_OP | BohSet["MASTER_ID"] | popupFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-65067133 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2959 |  | DATA_OP | BohSet["PLAN_ID"] | popupFilter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1b9075e | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2960 |  | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-c98d3407 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2963 | if (string.IsNullOrWhiteSpace(popupFilter["FP_PLAN_ID"])) | DATA_OP | BohSet["PLAN_ID"] | data.Tables[0].Rows[0]["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bad94999 | (진입점 미연결) | FP00608_PlanAmend_Memo.cs:2968 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00608_PlanAmend_Memo.SelectLine

진입점: this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action == CAppSetting.FlagI) ▸ switch (colname) case DefColumns.OPERATION_ID: ▸ if (string.IsNullOrWhiteSpace(sLine))] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (colname) case DefColumns.OPERATION_ID: ▸ if (string.IsNullOrWhiteSpace(sLine))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ee7f0d6 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2002 | if (string.IsNullOrWhiteSpace(instance)) | MESSAGE | MessageBox.Show | ("Select Instance, first") | 메시지 표시 |  |  |  |
| AC-c51d8521 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2003 | if (string.IsNullOrWhiteSpace(instance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5fda89d | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2005 |  | POPUP | new FPC0123_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-7bed80d5 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2006 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-6e5ac36f | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2007 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-b26c9af8 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2013 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-d58d6b30 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2016 |  | DATA_OP | popup.Filter["DIVISION_ID"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-120ca44c | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2017 |  | DATA_OP | popup.Filter["SITE_ID"] | site | 행/컬럼 값 대입 |  |  |  |
| AC-d126d53f | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2018 |  | DATA_OP | popup.Filter["PLANT_ID"] | plant | 행/컬럼 값 대입 |  |  |  |
| AC-01a70e49 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2019 |  | DATA_OP | popup.Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fcd02ff5 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2021 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-af0dee1e | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2023 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bbd44f7c | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2031 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_INIT | siMain.SetCellTypeText | (row, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f0f9a0bd | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2032 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_SET | siMain.SetText | (row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), dRow[DefColumns.OPERATION_ID].SafeSt… | 그리드 값 설정 |  |  |  |
| AC-6f4c8677 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2033 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_SET | siMain.SetText | (row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), dRow[DefColumns.FACTORY_ID].SafeString… | 그리드 값 설정 |  |  |  |
| AC-612fc642 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2034 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_SET | siMain.SetText | (row, siMain.GetColumnIndex(DefColumns.LINE_ID), dRow[DefColumns.LINE_ID].SafeString()) | 그리드 값 설정 |  |  |  |
| AC-ad297a75 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2035 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_SET | siMain.SetText | (row, siMain.GetColumnIndex(DefColumns.LINE_NAME), dRow[DefColumns.LINE_NAME].SafeString()… | 그리드 값 설정 |  |  |  |
| AC-e1b9b3f4 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … 외 1 | FP00608_PlanAmend_Memo.cs:2036 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (dRow != null) | GRID_SET | siMain.SetText | (row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), electrod_type) | 그리드 값 설정 |  |  |  |

## FP00608_PlanAmend_Memo.SetSpreadInit

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca48f8b2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:323 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff0c0ac8 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:324 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e7c87dfa | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:329 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0bf8e5bb | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:330 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97ead123 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:333 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7fa0ca57 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:334 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MEMO_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3417caac | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:335 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-17102539 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FP00608_PlanAmend_Memo.cs:336 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00608_PlanAmend_Memo.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b04272e3 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1596 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a56de2b0 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1598 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c48236aa | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1745 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-a8d72c02 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1746 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("OPERATION", "operation_of_line", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=operation_of_line] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3ecd70d6 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1753 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), dtOperation) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3e921676 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1875 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00608_PlanAmend_Memo", "MEMO_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f131692 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1888 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.MEMO_RANGE), dtRange) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-45b4ea91 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1896 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-037bcb34 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1897 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-117bc5fc | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1898 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-4a823a5c | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1899 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-27dfcb1e | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1900 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["OPERATION_ID"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-3e0c3efb | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1901 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-4e4e5e03 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1902 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00599" + "_" + "find_FPProdType").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2c3ec980 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1904 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dtProdType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34042f67 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1905 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dash["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2252257a | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1906 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dash["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-4b85032a | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1907 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dtProdType.Rows.Add | (dash) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b339601 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1909 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), dtProdType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-192becc0 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1917 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-651300cc | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1918 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("EQUIPMENT", "equipment_of_line", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=equipment_of_line] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e8df4b78 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1925 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID), dtEquipment) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a5160921 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1955 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-66241cb3 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1956 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-d10ed281 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1957 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-efcc3bb4 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1958 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-e2e269b8 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1959 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["OPERATION_ID"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-dfbe93fa | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1960 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | Filter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-20367277 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1961 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01950_ETC").ToUpper(), Filter, UserInfo.UserId, "SELECT", "MARKET") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ad9f7a36 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1963 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dtMarket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe77f82d | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1964 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dash["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8fab4edd | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1965 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dash["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-46693eb3 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1966 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | DATA_OP | dtMarket.Rows.Add | (dash) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a4019a4 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1968 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (action… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.MARKET), dtMarket) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-038001f0 | this.spdMain.CellClick | FP00608_PlanAmend_Memo.cs:1993 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32ffc507 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2061 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c04548eb | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2063 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f98ca9d4 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2103 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-cd6ddb95 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2106 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | POPUP | new GSCM.FP.Common.UIL.FPC0122_InstancePopup | () | 팝업/폼 생성 |  |  |  |
| AC-78ef3a32 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2107 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popInstance.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-64a62fcb | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2108 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | POPUP | popInstance.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-108190ba | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2122 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.INSTANCE_ID), pInstance) | 그리드 값 설정 |  |  |  |
| AC-8f193517 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2123 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), pCompany) | 그리드 값 설정 |  |  |  |
| AC-9168be5f | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2124 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), pDivision) | 그리드 값 설정 |  |  |  |
| AC-5108d9bb | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2125 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), pSite) | 그리드 값 설정 |  |  |  |
| AC-fce3c497 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2126 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pPlant) | 그리드 값 설정 |  |  |  |
| AC-fb94fca1 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2128 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MEMO_TYPE), this._sMemoType) | 그리드 값 설정 |  |  |  |
| AC-1fa9c61d | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2146 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | Filter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-af8b9de8 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2147 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("OPERATION", "operation_of_line", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=operation_of_line] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-996c4b12 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2154 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), dtOperation) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-27634c9f | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2250 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | POPUP | new FPC0124_CateColorEditPopup | () | 팝업/폼 생성 |  |  |  |
| AC-edff3cb1 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2251 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-07b7d9da | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2252 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-2442d900 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2253 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | popup.Filter["INSTANCE_ID"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-6a10b562 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2256 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | popup.Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a046a018 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2257 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | popup.Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-44afb9d3 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2258 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | popup.Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-fd7a1433 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2259 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | DATA_OP | popup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-481490e9 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2263 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | MESSAGE | MessageBox.Show | ("Select Instance, first") | 메시지 표시 |  |  |  |
| AC-e9b90672 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2264 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4c7e1dc | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2266 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-10f35632 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2267 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popup.ModelChange | sAttr1 | 속성 ModelChange 설정 |  |  |  |
| AC-bcb929d2 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2268 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | UI_PROP | popup.Category | sAttr2 | 속성 Category 설정 |  |  |  |
| AC-647d590d | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2270 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a02b7dce | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2285 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ATTR2_TXT), category_txt) | 그리드 값 설정 |  |  |  |
| AC-7902f7a4 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2286 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ switch (co… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ATTR1_TXT), modelchange_txt) | 그리드 값 설정 |  |  |  |
| AC-ed0186d0 | this.spdMain.CellDoubleClick | FP00608_PlanAmend_Memo.cs:2301 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00608_PlanAmend_Memo.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026e72e7 | this.spdMain.Change | FP00608_PlanAmend_Memo.cs:2380 | if (string.IsNullOrWhiteSpace(selected_column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9aed9c6e | this.spdMain.Change | FP00608_PlanAmend_Memo.cs:2383 | if (sp == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fc675b6 | this.spdMain.Change | FP00608_PlanAmend_Memo.cs:2391 | switch (selected_column) case DefColumns.ATTR1_TXT: case DefColumns.ATTR2_TXT: | CALL_EXT | sp.CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00608_PlanAmend_Memo.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfa917ff | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2479 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-86a92a07 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2480 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MARKET)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-fed98b54 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2481 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-71d5c99b | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2482 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-d44db5e1 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2483 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-8d8110e1 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2484 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME)].Value | "-" | 그리드 속성/값 설정 |  |  |  |
| AC-1b4621d3 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2491 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f486b93 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2492 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MARKET), iRow, siMain.GetColumnIndex(DefColumns.MA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea1d168b | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2493 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0f57733 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2494 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-835f7f5b | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2495 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3b80952 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2496 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5587f739 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2498 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].CellType | cellTypeDef | 그리드 속성/값 설정 |  |  |  |
| AC-9e4b0e54 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2499 | switch (selected_column) case "MEMO_RANGE": ▸ if (value == "LINE") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MARKET)].CellType | cellTypeDef | 그리드 속성/값 설정 |  |  |  |
| AC-e82f895b | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2509 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-407eb25c | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2510 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-64b6aa5d | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2511 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MARKET)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-19b26bd6 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2512 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-abe88b99 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2513 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-a587bec3 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2514 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e68ea4cd | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2518 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.EQUIPMENT_ID), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1073d4ea | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2519 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MARKET), iRow, siMain.GetColumnIndex(DefColumns.MA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ec95501 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2520 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c011027d | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2521 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.TOP_ITEM_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a484d0f2 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2522 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-222d931e | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2525 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b4b63420 | this.spdMain.ComboSelChange | FP00608_PlanAmend_Memo.cs:2526 | switch (selected_column) case "MEMO_RANGE": ▸ else of (value == "LINE") ▸ if (value=="MATERIAL") | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MARKET)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## FP00608_PlanAmend_Memo.UIFindData

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cba43561 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:453 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e38a4b8b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:454 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d47ddf1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:457 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d191eb69 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:462 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0f809739 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:472 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-63386d4e | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:474 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-849b42c8 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:481 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-344f3e42 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:482 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Memo("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d54a14a5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:482 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Memo("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fde44a87 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:486 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-baec41c6 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:487 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a3258b8f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:491 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3faef9c2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:492 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-efe3e812 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:498 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-95a45856 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:502 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae50aa22 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:507 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-68076377 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:509 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d7f49f58 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:513 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-03cd39ed | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:520 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7584d5d5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:524 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-18db563a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 3 | FP00608_PlanAmend_Memo.cs:525 | finally | GRID_LOCK | siMain.LockColumn | (0, siMain.ActiveSheet.Columns.Count - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00608_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d1f0888 | .ctor | FP00608_RowExcelPopup.cs:137 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-69b26d45 | .ctor | FP00608_RowExcelPopup.cs:138 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-7c4e150c | .ctor | FP00608_RowExcelPopup.cs:139 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fc587e82 | .ctor | FP00608_RowExcelPopup.cs:140 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00608_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e7e9f6d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:211 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2d93ef8c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:212 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2ecf372a | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:213 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0a4ab845 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:214 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5a50142e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:216 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-8689cbbf | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:216 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9f1c7c06 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:217 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-b9adb259 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:217 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-02ce633d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:218 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-4ac079bd | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:218 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-de2652ea | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:219 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b09b2e7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:219 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fe6b85ba | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:228 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-eb86aeb3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:229 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-5731add8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:230 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-a14e5013 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00608_RowExcelPopup.cs:231 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00608_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adb3faf2 | this.btnClose.Click | FP00608_RowExcelPopup.cs:795 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00608_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adcf2c38 | this.btnDownload.Click | FP00608_RowExcelPopup.cs:777 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-f01568d1 | this.btnDownload.Click | FP00608_RowExcelPopup.cs:778 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00608_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52dc7066 | this.btnFind.Click | FP00608_RowExcelPopup.cs:768 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31cac584 | this.btnFind.Click | FP00608_RowExcelPopup.cs:769 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00608_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ed90ee | this.Load | FP00608_RowExcelPopup.cs:259 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-60cfdd31 | this.Load | FP00608_RowExcelPopup.cs:260 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbea491f | this.Load | FP00608_RowExcelPopup.cs:261 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00608_RowExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a532f30c | dateRange.ValueChanged | FP00608_RowExcelPopup.cs:800 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-32d58067 | dateRange.ValueChanged | FP00608_RowExcelPopup.cs:801 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00608_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93a1c28a | (진입점 미연결) | FP00608_RowExcelPopup.cs:731 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec9e1968 | (진입점 미연결) | FP00608_RowExcelPopup.cs:731 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00608_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31cea03 | this.Load | FP00608_RowExcelPopup.cs:254 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00608_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b2570e0 | Dispose | FP00608_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00608_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-602c5e05 | (진입점 미연결) | FP00608_RowExcelPopup.cs:694 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00608_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a8a01e | FindButton | FP00608_RowExcelPopup.cs:301 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c69f96ef | FindButton | FP00608_RowExcelPopup.cs:302 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8bedc3d8 | FindButton | FP00608_RowExcelPopup.cs:304 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00608_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fb1fbef | this.Load 외 2 | FP00608_RowExcelPopup.cs:343 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a23302d5 | this.Load 외 2 | FP00608_RowExcelPopup.cs:344 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-549fc5ed | this.Load 외 2 | FP00608_RowExcelPopup.cs:344 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4402f0d | this.Load 외 2 | FP00608_RowExcelPopup.cs:348 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-69f1d0be | this.Load 외 2 | FP00608_RowExcelPopup.cs:349 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e29eb7e9 | this.Load 외 2 | FP00608_RowExcelPopup.cs:351 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1160b390 | this.Load 외 2 | FP00608_RowExcelPopup.cs:352 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9fa4c48e | this.Load 외 2 | FP00608_RowExcelPopup.cs:353 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e5f91850 | this.Load 외 2 | FP00608_RowExcelPopup.cs:354 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-60e16326 | this.Load 외 2 | FP00608_RowExcelPopup.cs:355 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-86e9560f | this.Load 외 2 | FP00608_RowExcelPopup.cs:356 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a389f6f1 | this.Load 외 2 | FP00608_RowExcelPopup.cs:363 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-294c2727 | this.Load 외 2 | FP00608_RowExcelPopup.cs:368 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-841524e1 | this.Load 외 2 | FP00608_RowExcelPopup.cs:370 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-0969b38f | this.Load 외 2 | FP00608_RowExcelPopup.cs:371 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7fa64356 | this.Load 외 2 | FP00608_RowExcelPopup.cs:372 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-49fb217a | this.Load 외 2 | FP00608_RowExcelPopup.cs:374 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed22f2e1 | this.Load 외 2 | FP00608_RowExcelPopup.cs:376 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6ca1cf8 | this.Load 외 2 | FP00608_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderFromDataSource(siMain, set, Co… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc15fa63 | this.Load 외 2 | FP00608_RowExcelPopup.cs:379 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-b1db6b78 | this.Load 외 2 | FP00608_RowExcelPopup.cs:379 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-7b281123 | this.Load 외 2 | FP00608_RowExcelPopup.cs:385 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-91b66f13 | this.Load 외 2 | FP00608_RowExcelPopup.cs:386 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-40fabb57 | this.Load 외 2 | FP00608_RowExcelPopup.cs:387 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-ba3f0f6f | this.Load 외 2 | FP00608_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fee041a0 | this.Load 외 2 | FP00608_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-41800269 | this.Load 외 2 | FP00608_RowExcelPopup.cs:397 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1e3b9532 | this.Load 외 2 | FP00608_RowExcelPopup.cs:398 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4588bd55 | this.Load 외 2 | FP00608_RowExcelPopup.cs:407 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaa8c4a7 | this.Load 외 2 | FP00608_RowExcelPopup.cs:410 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92a0dcf6 | this.Load 외 2 | FP00608_RowExcelPopup.cs:411 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7edfd213 | this.Load 외 2 | FP00608_RowExcelPopup.cs:412 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d3b9ac61 | this.Load 외 2 | FP00608_RowExcelPopup.cs:413 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2bba6738 | this.Load 외 2 | FP00608_RowExcelPopup.cs:414 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b2590b99 | this.Load 외 2 | FP00608_RowExcelPopup.cs:415 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00608_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081ae780 | this.Load | FP00608_RowExcelPopup.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0904ebf | this.Load | FP00608_RowExcelPopup.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00608_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-092e4de0 | (진입점 미연결) | FP00608_RowExcelPopup.cs:668 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-c053c4df | (진입점 미연결) | FP00608_RowExcelPopup.cs:669 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-64d5e97c | (진입점 미연결) | FP00608_RowExcelPopup.cs:670 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-d57d32b9 | (진입점 미연결) | FP00608_RowExcelPopup.cs:671 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-2c6c2ef1 | (진입점 미연결) | FP00608_RowExcelPopup.cs:672 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-45d69d71 | (진입점 미연결) | FP00608_RowExcelPopup.cs:673 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-98258e8b | (진입점 미연결) | FP00608_RowExcelPopup.cs:674 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dfd00ba1 | (진입점 미연결) | FP00608_RowExcelPopup.cs:676 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-f620e98b | (진입점 미연결) | FP00608_RowExcelPopup.cs:677 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-45313830 | (진입점 미연결) | FP00608_RowExcelPopup.cs:681 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0655a8aa | (진입점 미연결) | FP00608_RowExcelPopup.cs:682 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00608_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45d8ead4 | this.Load | FP00608_RowExcelPopup.cs:189 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-d1ce01c2 | this.Load | FP00608_RowExcelPopup.cs:190 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-4d014b6f | this.Load | FP00608_RowExcelPopup.cs:194 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-2b58fb85 | this.Load | FP00608_RowExcelPopup.cs:195 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-8a6e9fb8 | this.Load | FP00608_RowExcelPopup.cs:198 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a9f6b1ab | this.Load | FP00608_RowExcelPopup.cs:199 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0869129f | this.Load | FP00608_RowExcelPopup.cs:201 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00608_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95e4dcc2 | this.Load | FP00608_RowExcelPopup.cs:271 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f84aaef | this.Load | FP00608_RowExcelPopup.cs:272 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00608_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57ae785a | (진입점 미연결) | FP00608_RowExcelPopup.cs:292 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00608_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2835a82 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:703 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd88b2d5 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:703 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c11bb547 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:705 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-63af1c65 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:706 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-19308288 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:707 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-021bccfe | this.btnUpload.Click | FP00608_RowExcelPopup.cs:709 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d5c7f2ce | this.btnUpload.Click | FP00608_RowExcelPopup.cs:711 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a68b2ce0 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-889f8c5f | this.btnUpload.Click | FP00608_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ff0aa14 | this.btnUpload.Click | FP00608_RowExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0fa27f0a | this.btnUpload.Click | FP00608_RowExcelPopup.cs:721 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b8ac6e5e | this.btnUpload.Click | FP00608_RowExcelPopup.cs:723 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00608_RowExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-091ebcfe | this.radioMPP.CheckedChanged | FP00608_RowExcelPopup.cs:807 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-90c4cc7d | this.radioMPP.CheckedChanged | FP00608_RowExcelPopup.cs:809 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00608_RowExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19502c29 | this.radioWPP.CheckedChanged | FP00608_RowExcelPopup.cs:816 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d6b63ac4 | this.radioWPP.CheckedChanged | FP00608_RowExcelPopup.cs:818 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00608_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9df2efc8 | this.btnSave.Click | FP00608_RowExcelPopup.cs:428 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-c20ad959 | this.btnSave.Click | FP00608_RowExcelPopup.cs:429 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33fca7fe | this.btnSave.Click | FP00608_RowExcelPopup.cs:433 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-d5de868b | this.btnSave.Click | FP00608_RowExcelPopup.cs:434 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c955ce7a | this.btnSave.Click | FP00608_RowExcelPopup.cs:438 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-af142b46 | this.btnSave.Click | FP00608_RowExcelPopup.cs:438 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-474bda4e | this.btnSave.Click | FP00608_RowExcelPopup.cs:443 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dfdcefb5 | this.btnSave.Click | FP00608_RowExcelPopup.cs:444 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9f7dbb57 | this.btnSave.Click | FP00608_RowExcelPopup.cs:445 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b8418f9 | this.btnSave.Click | FP00608_RowExcelPopup.cs:446 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0a2d3203 | this.btnSave.Click | FP00608_RowExcelPopup.cs:447 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9b977f27 | this.btnSave.Click | FP00608_RowExcelPopup.cs:448 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8b8de2b6 | this.btnSave.Click | FP00608_RowExcelPopup.cs:456 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-95a1147d | this.btnSave.Click | FP00608_RowExcelPopup.cs:459 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-7150ffee | this.btnSave.Click | FP00608_RowExcelPopup.cs:461 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b8103d7 | this.btnSave.Click | FP00608_RowExcelPopup.cs:464 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2100976 | this.btnSave.Click | FP00608_RowExcelPopup.cs:469 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-e2340e1d | this.btnSave.Click | FP00608_RowExcelPopup.cs:470 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-c0a643ea | this.btnSave.Click | FP00608_RowExcelPopup.cs:477 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-690d76f3 | this.btnSave.Click | FP00608_RowExcelPopup.cs:478 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7ddd4050 | this.btnSave.Click | FP00608_RowExcelPopup.cs:479 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-997bc17c | this.btnSave.Click | FP00608_RowExcelPopup.cs:480 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fbeaa5a3 | this.btnSave.Click | FP00608_RowExcelPopup.cs:481 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-386279aa | this.btnSave.Click | FP00608_RowExcelPopup.cs:482 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e32427a5 | this.btnSave.Click | FP00608_RowExcelPopup.cs:483 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8b55e047 | this.btnSave.Click | FP00608_RowExcelPopup.cs:484 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12e6260c | this.btnSave.Click | FP00608_RowExcelPopup.cs:487 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-28df7d6a | this.btnSave.Click | FP00608_RowExcelPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9de95079 | this.btnSave.Click | FP00608_RowExcelPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bef5d55 | this.btnSave.Click | FP00608_RowExcelPopup.cs:526 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-660dbc77 | this.btnSave.Click | FP00608_RowExcelPopup.cs:528 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c2688df | this.btnSave.Click | FP00608_RowExcelPopup.cs:531 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3473cba8 | this.btnSave.Click | FP00608_RowExcelPopup.cs:533 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) … | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-33b2758a | this.btnSave.Click | FP00608_RowExcelPopup.cs:538 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-185b6318 | this.btnSave.Click | FP00608_RowExcelPopup.cs:540 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de6460fa | this.btnSave.Click | FP00608_RowExcelPopup.cs:543 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bde6a417 | this.btnSave.Click | FP00608_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9cea52c | this.btnSave.Click | FP00608_RowExcelPopup.cs:549 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9b3e41a | this.btnSave.Click | FP00608_RowExcelPopup.cs:552 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-58b14171 | this.btnSave.Click | FP00608_RowExcelPopup.cs:556 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10dfd2be | this.btnSave.Click | FP00608_RowExcelPopup.cs:569 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-663297ac | this.btnSave.Click | FP00608_RowExcelPopup.cs:571 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-71a82a8d | this.btnSave.Click | FP00608_RowExcelPopup.cs:573 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8854fcf | this.btnSave.Click | FP00608_RowExcelPopup.cs:577 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-71aed272 | this.btnSave.Click | FP00608_RowExcelPopup.cs:592 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-27af5510 | this.btnSave.Click | FP00608_RowExcelPopup.cs:593 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-80a59f8a | this.btnSave.Click | FP00608_RowExcelPopup.cs:597 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-382421c6 | this.btnSave.Click | FP00608_RowExcelPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4c8ceea9 | this.btnSave.Click | FP00608_RowExcelPopup.cs:604 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-7b7a7946 | this.btnSave.Click | FP00608_RowExcelPopup.cs:626 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-bce30243 | this.btnSave.Click | FP00608_RowExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-020502b9 | this.btnSave.Click | FP00608_RowExcelPopup.cs:628 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6776cdd4 | this.btnSave.Click | FP00608_RowExcelPopup.cs:634 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-3e5b39d2 | this.btnSave.Click | FP00608_RowExcelPopup.cs:638 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-e68cd224 | this.btnSave.Click | FP00608_RowExcelPopup.cs:644 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:"+e.Message )) | 메시지 표시 |  |  |  |
| AC-a6ffefee | this.btnSave.Click | FP00608_RowExcelPopup.cs:645 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ec84473c | this.btnSave.Click | FP00608_RowExcelPopup.cs:650 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-daeadf53 | this.btnSave.Click | FP00608_RowExcelPopup.cs:651 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e7c794d9 | this.btnSave.Click | FP00608_RowExcelPopup.cs:652 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cb101ff7 | this.btnSave.Click | FP00608_RowExcelPopup.cs:653 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28b11e7c | this.btnSave.Click | FP00608_RowExcelPopup.cs:654 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-30dd34eb | this.btnSave.Click | FP00608_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00608_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a558897e | this.Load | FP00608_RowExcelPopup.cs:284 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5cfd4193 | this.Load | FP00608_RowExcelPopup.cs:285 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00608_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f6e0173 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:239 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-51eb2c19 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:240 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e36d6df4 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:241 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-51809077 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:245 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6ba7c4a0 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:246 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-10931936 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00608_RowExcelPopup.cs:247 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

