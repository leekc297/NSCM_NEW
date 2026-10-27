# AS-IS 액션 대조표 — SSP0022

> 원천: `Doc/asisfacts/screens/SSP0022/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1144행 · 메서드 105 · 종류 DATA_OP 208 · GRID_SET 177 · RETURN 125 · FLAG 112 · UI_PROP 103 · GRID_INIT 98 · ENDPOINT 51 · MESSAGE 50 · POPUP 35 · CALL_EXT 30 · UI_MISC 29 · GRID_LOCK 24 · COMBO_DATA 21 · VALUE_SET 15 · LIST_REBIND 12 · VALIDATE 12 · GRID_COMBO 11 · CALL_BASE 10 · VALUE_CLEAR 6 · GRID_BIND 5 · STATE 4 · GRID_STYLE 4 · LIST_CLEAR 2 · ⚠ 의미 확인 필요 40


## FPMaskCellType.CanBeOverflown

진입점: CanBeOverflown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80499343 | CanBeOverflown | SSP0022_ShipmentRequestElectrode.cs:4496 |  | RETURN | return base.CanBeOverflown(); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.CanOverflow

진입점: CanOverflow

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f092fcf | CanOverflow | SSP0022_ShipmentRequestElectrode.cs:4506 |  | RETURN | return base.CanOverflow(); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Clone

진입점: Clone

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba4f6b9 | Clone | SSP0022_ShipmentRequestElectrode.cs:4511 |  | RETURN | return base.Clone(); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Deserialize

진입점: Deserialize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e43ceeea | Deserialize | SSP0022_ShipmentRequestElectrode.cs:4588 |  | RETURN | return base.Deserialize(r); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Equals

진입점: Equals

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86330e53 | Equals | SSP0022_ShipmentRequestElectrode.cs:4593 |  | RETURN | return base.Equals(obj); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Format

진입점: Format

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04606772 | Format | SSP0022_ShipmentRequestElectrode.cs:4683 | if (m == null) | CALL_BASE | ToHorizontalAlignment | (FarPoint.Win.Spread.CellHorizontalAlignment.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7977567 | Format | SSP0022_ShipmentRequestElectrode.cs:4702 | if (type_of == typeof(string)) ▸ if (Double.TryParse(m.ToString(), out out_double) == true) ▸ if (omitZero == true && out_double == 0) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-bb2e0397 | Format | SSP0022_ShipmentRequestElectrode.cs:4703 | if (type_of == typeof(string)) ▸ if (Double.TryParse(m.ToString(), out out_double) == true) | RETURN | return base.Format(out_double); |  | 처리 중단/반환 |  |  |  |
| AC-45598241 | Format | SSP0022_ShipmentRequestElectrode.cs:4705 | if (type_of == typeof(string)) | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-a2304ae3 | Format | SSP0022_ShipmentRequestElectrode.cs:4712 | else of (type_of == typeof(string)) ▸ if (type_of == typeof(Int16)) ▸ if (omitZero == true && (int)m == 0) | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-19e3e98e | Format | SSP0022_ShipmentRequestElectrode.cs:4714 | else of (type_of == typeof(string)) ▸ if (type_of == typeof(Int16)) | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-0fccd6bc | Format | SSP0022_ShipmentRequestElectrode.cs:4721 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ if (type_of == typeof(Int32)) ▸ if (omitZero == true && (int)m ==… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-a750d720 | Format | SSP0022_ShipmentRequestElectrode.cs:4723 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ if (type_of == typeof(Int32)) | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-286cf319 | Format | SSP0022_ShipmentRequestElectrode.cs:4730 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ if (type_of == typeof(Decima… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-54eb871f | Format | SSP0022_ShipmentRequestElectrode.cs:4732 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ if (type_of == typeof(Decima… | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-381c33fd | Format | SSP0022_ShipmentRequestElectrode.cs:4739 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ else of (type_of == typeof(D… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-8a420859 | Format | SSP0022_ShipmentRequestElectrode.cs:4741 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ else of (type_of == typeof(D… | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-8fef1c99 | Format | SSP0022_ShipmentRequestElectrode.cs:4748 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ else of (type_of == typeof(D… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |
| AC-1569b824 | Format | SSP0022_ShipmentRequestElectrode.cs:4750 | else of (type_of == typeof(string)) ▸ else of (type_of == typeof(Int16)) ▸ else of (type_of == typeof(Int32)) ▸ else of (type_of == typeof(D… | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |
| AC-e5869e77 | Format | SSP0022_ShipmentRequestElectrode.cs:4753 |  | RETURN | return base.Format(m); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetEditorControl

진입점: GetEditorControl

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9714dde | GetEditorControl | SSP0022_ShipmentRequestElectrode.cs:4531 |  | RETURN | return base.GetEditorControl(appearance, zoomFactor); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetEditorValue

진입점: GetEditorValue

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07a2a9cc | GetEditorValue | SSP0022_ShipmentRequestElectrode.cs:4537 |  | RETURN | return x; |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetErrorIconBound

진입점: GetErrorIconBound

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e936444c | GetErrorIconBound | SSP0022_ShipmentRequestElectrode.cs:4542 |  | RETURN | return base.GetErrorIconBound(g, appearance, cellRectangle, zoomFactor); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetHashCode

진입점: GetHashCode

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b60a3f87 | GetHashCode | SSP0022_ShipmentRequestElectrode.cs:4598 |  | RETURN | return base.GetHashCode(); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetPreferredSize

진입점: GetPreferredSize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb5ac20 | GetPreferredSize | SSP0022_ShipmentRequestElectrode.cs:4547 |  | RETURN | return base.GetPreferredSize(editor); |  | 처리 중단/반환 |  |  |  |
| AC-034f8279 | GetPreferredSize | SSP0022_ShipmentRequestElectrode.cs:4608 |  | RETURN | return base.GetPreferredSize(g, size, appearance, value, zoomFactor); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.GetReservedCursor

진입점: GetReservedCursor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2d4e1c4 | GetReservedCursor | SSP0022_ShipmentRequestElectrode.cs:4552 |  | RETURN | return base.GetReservedCursor(o); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.IsPropertySupported

진입점: IsPropertySupported

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df0ac97b | IsPropertySupported | SSP0022_ShipmentRequestElectrode.cs:4618 |  | RETURN | return base.IsPropertySupported(propertyName); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.IsReservedKey

진입점: IsReservedKey

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee894531 | IsReservedKey | SSP0022_ShipmentRequestElectrode.cs:4557 |  | RETURN | return base.IsReservedKey(e); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.IsReservedLocation

진입점: IsReservedLocation

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0856de38 | IsReservedLocation | SSP0022_ShipmentRequestElectrode.cs:4562 |  | RETURN | return base.IsReservedLocation(g, x, y, rc, appearance, value, zoomFactor); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.IsValid

진입점: IsValid

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff08732a | IsValid | SSP0022_ShipmentRequestElectrode.cs:4573 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Parse

진입점: Parse

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f65ba7 | Parse | SSP0022_ShipmentRequestElectrode.cs:4517 | if (s == null) | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-195bd582 | Parse | SSP0022_ShipmentRequestElectrode.cs:4519 | if (s == "0") | RETURN | return s; |  | 처리 중단/반환 |  |  |  |
| AC-fc097a37 | Parse | SSP0022_ShipmentRequestElectrode.cs:4521 |  | RETURN | return a; |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.Serialize

진입점: Serialize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db4bcb4d | Serialize | SSP0022_ShipmentRequestElectrode.cs:4623 |  | RETURN | return base.Serialize(w); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.SetParseFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fe6c711 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4784 | if (info is NumberFormatInfo) | UI_PROP | x.NumberDecimalDigits | 2 | 속성 NumberDecimalDigits 설정 |  |  |  |
| AC-dc4a6aa8 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4785 | if (info is NumberFormatInfo) | DATA_OP | x.NativeDigits[8] | "K" | 행/컬럼 값 대입 |  |  |  |

## FPMaskCellType.StopEditing

진입점: StopEditing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f65470 | StopEditing | SSP0022_ShipmentRequestElectrode.cs:4652 |  | RETURN | return base.StopEditing(); |  | 처리 중단/반환 |  |  |  |

## FPMaskCellType.ToString

진입점: ToString

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cbf988e | ToString | SSP0022_ShipmentRequestElectrode.cs:4669 |  | RETURN | return base.ToString(); |  | 처리 중단/반환 |  |  |  |

## SSP0022_BodItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-639d51e4 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0022_BodItemPopup.cs:316 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ee0ea68e | this.btnButtonList.UsrButtonList_Click_Detected | SSP0022_BodItemPopup.cs:319 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_BodItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d5ad9d4 | this.Load | SSP0022_BodItemPopup.cs:196 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a35233c4 | this.Load | SSP0022_BodItemPopup.cs:197 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e890303b | this.Load | SSP0022_BodItemPopup.cs:198 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_BodItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-331651f1 | this.Load | SSP0022_BodItemPopup.cs:191 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0022_BodItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a4c92f4 | Dispose | SSP0022_BodItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0022_BodItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-864d0183 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:254 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c9c4cc97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:258 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_ITEM_POPUP") ⇒ SSP.SSP0022_GET_ITEM_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-5c56854e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:259 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dc4c89c0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:260 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | clbFromSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0e7258f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:261 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-6816b317 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:262 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-933083ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:263 | lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-d3d6c74d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:264 | lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-e473715a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:265 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransport | 행/컬럼 값 대입 |  |  |  |
| AC-e1480371 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:266 | lambda | DATA_OP | request.Parameters["P_PLAN_START_YYYYMMDD"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-95491185 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:268 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8cdb05d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:270 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5d0cdacb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:274 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a646d08b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:275 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9fea1427 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:279 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-108130dd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:285 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | itemID | this.dtFindData.Rows[0][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0d4e37ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:286 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | modelID | this.dtFindData.Rows[0][DefColumns.ModelId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d973bd5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:287 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | incoterms | this.dtFindData.Rows[0][DefColumns.Incoterms].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-21e0b601 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:288 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | transport | this.dtFindData.Rows[0][DefColumns.Transport].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1848a4f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:289 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bodId | this.dtFindData.Rows[0][DefColumns.BodId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f199797a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:290 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | confirmDay | this.dtFindData.Rows[0][DefColumns.ConfirmDay].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-22eaa7a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:291 | if (!string.IsNullOrEmpty(txtItemID.Text)) ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_BodItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdf5b126 | this.Load | SSP0022_BodItemPopup.cs:142 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-aca157a7 | this.Load | SSP0022_BodItemPopup.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-93e443c8 | this.Load | SSP0022_BodItemPopup.cs:151 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-ba51a1c9 | this.Load | SSP0022_BodItemPopup.cs:152 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-1c831037 | this.Load | SSP0022_BodItemPopup.cs:153 |  | FLAG | sFromSiteId | _FromSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-a6d650ad | this.Load | SSP0022_BodItemPopup.cs:154 |  | FLAG | sToSiteId | _ToSiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-094ecc2e | this.Load | SSP0022_BodItemPopup.cs:155 |  | FLAG | sItemId | _ItemID | 화면 필드/플래그 변경 |  |  |  |
| AC-f3709d50 | this.Load | SSP0022_BodItemPopup.cs:156 |  | FLAG | sPlanDate | _planDate | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff107a7 | this.Load | SSP0022_BodItemPopup.cs:157 |  | FLAG | sBodId | _bodId | 화면 필드/플래그 변경 |  |  |  |
| AC-a53d4b6b | this.Load | SSP0022_BodItemPopup.cs:158 |  | FLAG | sIncoterms | _incoterms | 화면 필드/플래그 변경 |  |  |  |
| AC-968f5caf | this.Load | SSP0022_BodItemPopup.cs:159 |  | FLAG | sTransport | _transmode | 화면 필드/플래그 변경 |  |  |  |

## SSP0022_BodItemPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6419a795 | this.Load | SSP0022_BodItemPopup.cs:395 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d2dc822d | this.Load | SSP0022_BodItemPopup.cs:397 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e8b6c86 | this.Load | SSP0022_BodItemPopup.cs:400 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0022_BodItemPopup.GetDivisionbyScmSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d26edf61 | this.Load | SSP0022_BodItemPopup.cs:409 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d74a0d6c | this.Load | SSP0022_BodItemPopup.cs:410 |  | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-fa5f4f4c | this.Load | SSP0022_BodItemPopup.cs:411 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-5e322a21 | this.Load | SSP0022_BodItemPopup.cs:412 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-2d576686 | this.Load | SSP0022_BodItemPopup.cs:414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7f8eab33 | this.Load | SSP0022_BodItemPopup.cs:417 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0022_BodItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3391ffca | this.Load | SSP0022_BodItemPopup.cs:167 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-15af18df | this.Load | SSP0022_BodItemPopup.cs:168 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b18f70ac | this.Load | SSP0022_BodItemPopup.cs:170 |  | FLAG | dtScmSite | GetDivisionbyScmSite(sDivision, CAppSetting.StringALL, CAppSetting.StringALL) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0538c66 | this.Load | SSP0022_BodItemPopup.cs:173 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantByElectordeShipFromSite, false, sDivision, null) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3480bdd | this.Load | SSP0022_BodItemPopup.cs:173 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipFromSite, false, sDivision, null) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b9f3edc | this.Load | SSP0022_BodItemPopup.cs:174 |  | FLAG | dtToSite | Data.Common(Data.Type.PlantByElectordeShipToSite, false, sDivision, null) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-21df3574 | this.Load | SSP0022_BodItemPopup.cs:174 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite, false, sDivision, null) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e7dfb79 | this.Load | SSP0022_BodItemPopup.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9521bbf1 | this.Load | SSP0022_BodItemPopup.cs:176 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55bb585f | this.Load | SSP0022_BodItemPopup.cs:178 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-2c64edfe | this.Load | SSP0022_BodItemPopup.cs:179 |  | VALUE_SET | clbFromSite.ControlValues | sFromSiteId | 컨트롤 값 설정 |  |  |  |
| AC-0095ea61 | this.Load | SSP0022_BodItemPopup.cs:180 |  | VALUE_SET | clbToSite.ControlValues | sToSiteId | 컨트롤 값 설정 |  |  |  |
| AC-311b5fc9 | this.Load | SSP0022_BodItemPopup.cs:181 |  | VALUE_SET | txtItemID.Text | sItemId | 컨트롤 값 설정 |  |  |  |
| AC-2ad1ef37 | this.Load | SSP0022_BodItemPopup.cs:183 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4660d8a | this.Load | SSP0022_BodItemPopup.cs:184 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6f8b4b95 | this.Load | SSP0022_BodItemPopup.cs:185 |  | STATE | clbToSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0022_BodItemPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b38afe5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:205 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c1f86fa8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:207 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb11454b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:208 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.Division, FPMerge.None, 60, true ,FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f138492 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:209 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DivisionName, DefColumns.DivisionName, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35b7499e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:210 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ModelId, DefColumns.ModelId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26e9032d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:211 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e382f81 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:212 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Incoterms, DefColumns.Incoterms, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b34f5726 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:213 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Transport, DefColumns.Transport, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f8508e4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:214 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.BodId, DefColumns.BodId, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c662b985 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SSP0022_BodItemPopup.cs:215 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ConfirmDay, DefColumns.ConfirmDay, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_BodItemPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bad0594d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:340 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce6a2ca7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:342 |  | FLAG | itemID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d7629c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:343 |  | FLAG | modelID | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a8238461 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:344 |  | FLAG | incoterms | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-04cc59e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:345 |  | FLAG | transport | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-91cd916e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:361 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-779ba194 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:365 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | itemID | itemID + "," + this.dtFindData.Rows[iRow][DefColumns.ItemId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-00ca24e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:373 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a297e88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:378 | else of (bMulltiSelect) | FLAG | itemID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-60eec44e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:379 | else of (bMulltiSelect) | FLAG | modelID | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ModelId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-37909f59 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:380 | else of (bMulltiSelect) | FLAG | incoterms | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbcbc23 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:381 | else of (bMulltiSelect) | FLAG | transport | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Transport)) | 화면 필드/플래그 변경 |  |  |  |
| AC-fde9df06 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:382 | else of (bMulltiSelect) | FLAG | bodId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BodId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-3bf12351 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SSP0022_BodItemPopup.cs:383 | else of (bMulltiSelect) | FLAG | confirmDay | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ConfirmDay)) | 화면 필드/플래그 변경 |  |  |  |

## SSP0022_BodItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8249f543 | this.spdMain.CellDoubleClick | SSP0022_BodItemPopup.cs:333 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BodItemValidChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b027b889 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4143 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK") ⇒ SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-b64bed99 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4144 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-613d9214 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4145 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3f70957 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4146 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-5f593960 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4147 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-99e67381 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4149 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7bd71bf4 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4157 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0e847a5e | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4162 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fff4621d | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4164 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfc07b5a | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4169 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e5d93fe9 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4175 | catch ((System.Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cedc4ebe | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4178 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BodItemValidChk_main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-234c9ab3 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4094 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK") ⇒ SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-cabea309 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4095 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4591b8dd | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4096 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-67333556 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4097 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-20f9c3d0 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4098 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1be3337 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4100 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc6b3e16 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4108 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4db0d213 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4113 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60db0f34 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4115 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ec4bbc0 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4120 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8d47630d | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4124 | catch ((System.Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a563475d | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:4126 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.btnExcelFormDownload_Click

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99845b76 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:4211 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acebf5f1 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:4212 |  | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestElectrode.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f6fb89 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4188 |  | POPUP | new ExcelUploadForm | ("SSP0022", "Shipment Request(Electrode)") | 팝업/폼 생성 |  |  |  |
| AC-a0b7e62c | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4189 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-df9b7bc4 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4190 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-60e95b18 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4191 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d2c1d882 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4193 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46157863 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4195 | if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a090a135 | this.btnExcelUpload.Click | SSP0022_ShipmentRequestElectrode.cs:4196 | if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestElectrode.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fbd5f2e | this.btnItemId.Click | SSP0022_ShipmentRequestElectrode.cs:1760 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-14e7758e | this.btnItemId.Click | SSP0022_ShipmentRequestElectrode.cs:1762 |  | POPUP | popItem.Form_Load | (true, sDivision_ID, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e81420d5 | this.btnItemId.Click | SSP0022_ShipmentRequestElectrode.cs:1763 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-07f9aba6 | this.btnItemId.Click | SSP0022_ShipmentRequestElectrode.cs:1764 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b1f45d00 | this.btnItemId.Click | SSP0022_ShipmentRequestElectrode.cs:1770 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76b46cc2 | this.btnItemID2.Click | SSP0022_ShipmentRequestElectrode.cs:1780 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-932920cd | this.btnItemID2.Click | SSP0022_ShipmentRequestElectrode.cs:1782 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a0932ad3 | this.btnItemID2.Click | SSP0022_ShipmentRequestElectrode.cs:1783 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b652458e | this.btnItemID2.Click | SSP0022_ShipmentRequestElectrode.cs:1784 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f7a5a0a4 | this.btnItemID2.Click | SSP0022_ShipmentRequestElectrode.cs:1790 | if (popItem.ItemID != "") | VALUE_SET | txtItemld2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12ccbb8c | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1300 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb97dc40 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1305 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0cde15c | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1306 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b864f741 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1311 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f9d6f28 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1312 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb189751 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1315 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0022", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-f2e705b7 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1316 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a66d3bb3 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1317 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3fa85955 | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1321 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-dfead62f | this.btnMeasure.Click | SSP0022_ShipmentRequestElectrode.cs:1331 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b483464e | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3748 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8161b6cf | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3750 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-46e59873 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3751 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-90386889 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3752 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5b26402f | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3753 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-24c6f315 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3754 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-a02b4725 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3756 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-62b904e1 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3758 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-863a366d | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3764 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-1c3426a2 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3768 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-0dfb9bb5 | this.btnRequestor.Click | SSP0022_ShipmentRequestElectrode.cs:3772 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60903b09 | this.btnSearch.Click | SSP0022_ShipmentRequestElectrode.cs:3785 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57bab654 | this.btnSearch.Click | SSP0022_ShipmentRequestElectrode.cs:3786 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-431f219d | this.btnSearch.Click | SSP0022_ShipmentRequestElectrode.cs:3805 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3437f006 | this.btnSearch.Click | SSP0022_ShipmentRequestElectrode.cs:3806 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestElectrode.cboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e1cfc1e | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3697 | if (cboPlanDate.ControlValues != null) | DATA_OP | dtPlanDate.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0703aea1 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3697 | if (cboPlanDate.ControlValues != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-88753dd3 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3708 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-b334a4f7 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3709 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-591a5ba5 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3710 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(sPlanDate) | 속성 Value1 설정 |  |  |  |
| AC-cc04ad74 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3711 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value2 | Convert.ToDateTime(dr["TO_DATE"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-980700cf | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3717 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-dc81fa13 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3718 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtItemld2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-99a71ed7 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3736 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-272801b3 | cboPlanDate.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3740 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ else of (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0022_ShipmentRequestElectrode.clbCompanyID_SelectedIndexChanged

진입점: clbCompany_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-771a2441 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3664 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantEE, false, strSelDivision_ID, strSelCompany_ID) ⇒ biz:CommonData.CommonDataList [code=PlantEE] | 화면 필드/플래그 변경 |  |  |  |
| AC-23a0c05e | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3664 |  | COMBO_DATA | Data.Common | (Data.Type.PlantEE, false, strSelDivision_ID, strSelCompany_ID) ⇒ biz:CommonData.CommonDataList [code=PlantEE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4742e19d | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3665 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a9284393 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3670 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.Plan_InforElectrode, false, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-95344d0d | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3670 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_InforElectrode, false, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f3dfc31 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3671 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c3e24204 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3672 |  | VALUE_CLEAR | cboPlanDate.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b164c405 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3679 |  | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2570dec2 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3680 |  | VALUE_CLEAR | txtItemld2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-610a5b78 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3681 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-2164f71c | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3682 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-692e911b | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3683 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-122f1ee2 | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3684 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-765166db | clbCompany_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3688 | if (cboPlanDate.Items.Count > 0) | VALUE_SET | cboPlanDate.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.clbDivision_ID_SelectedIndexChanged

진입점: clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0d6cc3b | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3640 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a5eba8 | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3642 | if (dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).Count() > 0) | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ca9f7ad | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3642 | if (dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).Count() > 0) | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-22036544 | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3644 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e10e9bfb | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3648 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e26462b5 | clbDivision_ID.SelectedIndexChanged | SSP0022_ShipmentRequestElectrode.cs:3649 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.ConfirmDayChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7b729cb | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.… | SSP0022_ShipmentRequestElectrode.cs:4061 | try ▸ if (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e2403d70 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.… | SSP0022_ShipmentRequestElectrode.cs:4066 | try ▸ else of (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00323", new object[] { sConfirmDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95eb5151 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.… | SSP0022_ShipmentRequestElectrode.cs:4067 | try ▸ else of (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f319ef83 | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.… | SSP0022_ShipmentRequestElectrode.cs:4071 | catch ((System.Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cf47275f | SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.… | SSP0022_ShipmentRequestElectrode.cs:4072 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.ControlClear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-182c392a | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:555 |  | CALL_EXT | clbCompany_ID.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9561496 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:556 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-09e3e7f2 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:557 |  | LIST_CLEAR | clbCellType.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-1a7041df | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:560 |  | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b065bee | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:561 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-4d729b68 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:562 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-bf163d40 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:563 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-5a63e011 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:564 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b29dec17 | this.Load | SSP0022_ShipmentRequestElectrode.cs:571 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3515c489 | this.Load | SSP0022_ShipmentRequestElectrode.cs:572 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtStockDetail, SpdSheet.shtStockDetail, 3, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10069b83 | this.Load | SSP0022_ShipmentRequestElectrode.cs:573 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtRequestDetail, SpdSheet.shtRequestDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0ce40b1 | this.Load | SSP0022_ShipmentRequestElectrode.cs:574 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtRequestDetail_Excel, SpdSheet.shtRequestDetail_Excel, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dc98d601 | this.Load | SSP0022_ShipmentRequestElectrode.cs:577 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-d13962ef | this.Load | SSP0022_ShipmentRequestElectrode.cs:580 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-f70882a0 | this.Load | SSP0022_ShipmentRequestElectrode.cs:581 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9128b6f | this.Load | SSP0022_ShipmentRequestElectrode.cs:584 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtRequestDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bfaf72a | this.Load | SSP0022_ShipmentRequestElectrode.cs:585 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30270669 | this.Load | SSP0022_ShipmentRequestElectrode.cs:589 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtRequestDetail_Excel) | 화면 필드/플래그 변경 |  |  |  |
| AC-65e0296a | this.Load | SSP0022_ShipmentRequestElectrode.cs:590 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7a1791e | this.Load | SSP0022_ShipmentRequestElectrode.cs:593 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5e7c7ae | this.Load | SSP0022_ShipmentRequestElectrode.cs:596 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_ShipmentRequestElectrode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe15529e | this.Load | SSP0022_ShipmentRequestElectrode.cs:432 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-ad55bff0 | this.Load | SSP0022_ShipmentRequestElectrode.cs:434 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0b2ad3d7 | this.Load | SSP0022_ShipmentRequestElectrode.cs:435 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-63ec9e29 | this.Load | SSP0022_ShipmentRequestElectrode.cs:436 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-0800cc1e | this.Load | SSP0022_ShipmentRequestElectrode.cs:438 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b155299c | Dispose | SSP0022_ShipmentRequestElectrode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d88f0af | EditButton | SSP0022_ShipmentRequestElectrode.cs:1510 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d863c57f | EditButton | SSP0022_ShipmentRequestElectrode.cs:1511 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7ec1ac3 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1519 | if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1832056c | EditButton | SSP0022_ShipmentRequestElectrode.cs:1520 | if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6660a38 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1523 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b589e322 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1525 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-85058191 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1526 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a9455076 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1538 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID), i, siMain.ActiveSheet.ColumnCount - 1, tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eef57285 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1557 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-38732039 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1576 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-332af387 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1581 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Shee… | GRID_LOCK | siMain.LockRange | (i, j, i, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5be7c711 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1604 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3c9733ec | EditButton | SSP0022_ShipmentRequestElectrode.cs:1624 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MEASURE) + 2, i, siMain.ActiveSheet.ColumnCount - 1, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4c1c14b | EditButton | SSP0022_ShipmentRequestElectrode.cs:1639 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-c8bae4bc | EditButton | SSP0022_ShipmentRequestElectrode.cs:1677 | if (fps.Name == "spdMain") ▸ if (bEdit_Auth == true) ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd2c288 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1687 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockDetail) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64168886 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1688 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockDetail) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d325699 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1697 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (bRea… | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c414ff2 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1698 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (bRea… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2463e8a4 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1705 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-81e62c1a | EditButton | SSP0022_ShipmentRequestElectrode.cs:1706 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bce1f9ae | EditButton | SSP0022_ShipmentRequestElectrode.cs:1711 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (bEdi… | FLAG | bEdit_Mode_Detail | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ab1ff0f3 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1715 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of … | FLAG | bEdit_Mode_Detail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec21111 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1733 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (siDe… | GRID_LOCK | siDetail.LockRange2 | (i, 0, i, siDetail.GetColumnIndex(DefColumns.REQUEST_DATE), true, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ecc360b8 | EditButton | SSP0022_ShipmentRequestElectrode.cs:1738 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (siDe… | GRID_LOCK | siDetail.LockRange2 | (i, 0, i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), true, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-09a7614f | EditButton | SSP0022_ShipmentRequestElectrode.cs:1739 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (siDe… | GRID_LOCK | siDetail.LockRange2 | (i, siDetail.GetColumnIndex(DefColumns.REQUESTOR), i, siDetail.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금 전환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.ExportExcel

진입점: this.formDown.Click [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dfab4bd | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4222 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9c8bc3c | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4229 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f92de048 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4236 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a61a5224 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4243 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ad78514 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4245 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3ca1472 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4248 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-95c05ffe | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4284 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97dbf429 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4289 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-7b43bf91 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4294 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2bceac5 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4296 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-210805e8 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4309 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a0151b0 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4321 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-93e601bf | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4322 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-e118d738 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4331 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-f2c97d93 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4332 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-5b9c44b5 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4338 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-11bae1b8 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4351 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-8388721f | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4360 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-2af0970c | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4367 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb3cd436 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4372 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-46243730 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4374 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-0c97f00d | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4378 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-d0cfcae6 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4380 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-cb1a0d2c | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4383 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-ff6f711e | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4385 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-097e977a | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4390 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-a2c6d561 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4401 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e3bb355 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4403 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f6bdf4f | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4407 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-304b83b2 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4408 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-51c0de95 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4409 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-38c10dcf | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4410 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-1bc449c4 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4411 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0c924f55 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4418 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9834547d | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4419 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2ab02a5 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4421 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-db875e64 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4425 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-981f3343 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4431 | catch ((System.Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d24d1f1 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4435 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9afd3560 | this.formDown.Click [finally] | SSP0022_ShipmentRequestElectrode.cs:4438 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0022_ShipmentRequestElectrode.FindData_BOD

진입점: this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (!string.IsNullOrEmpty(sItemId))] / this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFromSite != "" && sToSite != "")) ▸ if (action == "I") ▸ if (popItem.ItemID != "" && popItem.ModelID != "") ▸ if (!string.IsNullOrEmpty(sItemId))] / this.spdDetail.ClipboardPasted [if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-204c71d7 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3903 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88a18846 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3907 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_ITEM_POPUP") ⇒ SSP.SSP0022_GET_ITEM_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-fa077606 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3908 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision | 행/컬럼 값 대입 |  |  |  |
| AC-153400d5 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3909 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-4bab17d3 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3910 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-f844c9d4 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3911 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-57cc8f63 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3912 | lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-bb22ba04 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3913 | lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-52f15e64 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3914 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransport | 행/컬럼 값 대입 |  |  |  |
| AC-6c998bf7 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3915 | lambda | DATA_OP | request.Parameters["P_PLAN_START_YYYYMMDD"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-a133ed3b | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3916 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2f8e384d | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3918 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7e62d9f0 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3922 |  | FLAG | dtFindData_BOD | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-de0abf67 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3954 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID), sdivision_Org) | 그리드 값 설정 |  |  |  |
| AC-eaac4d23 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3955 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-fd8bfce8 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3956 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), sTransport) | 그리드 값 설정 |  |  |  |
| AC-c5573384 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3957 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.BOD_ID), sBodId) | 그리드 값 설정 |  |  |  |
| AC-77a74c60 | this.spdDetail.ComboSelChange [if (e.Column == siDetail.GetC… 외 2 | SSP0022_ShipmentRequestElectrode.cs:3958 | if (dtFindData_BOD.Rows.Count > 0) | GRID_SET | siDetail.SetValue | (row, siDetail.GetColumnIndex(DefColumns.CONFIRM_DAY), sConfirmDay) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.FindData_Detail

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0941f3 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2403 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d587a5a8 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2408 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5c88f099 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2408 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83c2da6b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2416 | try | FLAG | iTopRow | siDetail.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2afde9c6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2416 | try | CALL_EXT | siDetail.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cf9a88e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2418 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ec63ec1c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2419 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-f68216eb | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2419 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-601fb260 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2479 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6ea71dda | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2480 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b32b347c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2484 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_STOCK_DETAIL") ⇒ SSP.SSP0022_GET_STOCK_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-daf60899 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2486 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-08867dbb | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2488 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eaacc5da | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2489 | try ▸ lambda | DATA_OP | req.Parameters["P_COMPANY_ID"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-74332d3c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2490 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ca07d7d7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2491 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aee21ee9 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2492 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7bcf53ad | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2493 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-814cf604 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2494 | try ▸ lambda | DATA_OP | req.Parameters["P_CELL_TYPE"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-60cd2550 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2495 | try ▸ lambda | DATA_OP | req.Parameters["P_LOT_ID"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-da65b215 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2496 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f968b17d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2497 | try ▸ lambda | DATA_OP | req.Parameters["P_MODEL_ID"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-e09aaf8b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2498 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-1e5171eb | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2499 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb16ad43 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2501 | try ▸ lambda | DATA_OP | req.Parameters["P_PROGRAM_ID"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4c8a917 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2502 | try ▸ lambda | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-0ea03af0 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2503 | try ▸ lambda | DATA_OP | req.Parameters["P_REAL_FLAG"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8653fbd9 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2504 | try ▸ lambda | DATA_OP | req.Parameters["P_MY_MODEL_CHK"] | p_my_model_chk | 행/컬럼 값 대입 |  |  |  |
| AC-a1b552c8 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2505 | try ▸ lambda | DATA_OP | req.Parameters["P_PART_LEADER_CHK"] | p_part_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-83880be5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2506 | try ▸ lambda | DATA_OP | req.Parameters["P_TEAM_LEADER_CHK"] | p_team_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-65793d52 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2507 | try ▸ lambda | DATA_OP | req.Parameters["P_DELEGATE_CHK"] | p_delegate_chk | 행/컬럼 값 대입 |  |  |  |
| AC-2f6b6ecd | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2508 | try ▸ lambda | DATA_OP | req.Parameters["P_NON_CHK"] | p_non_chk | 행/컬럼 값 대입 |  |  |  |
| AC-1cc78615 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2510 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3511aec | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2511 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b0aace1b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2519 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-58898a04 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2520 | try | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5c350e68 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2522 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7a47e92 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2534 | try | CALL_EXT | siDetail.SetDecimal | (iwms_q, iwms_q, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-291d36b3 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2535 | try | CALL_EXT | siDetail.SetDecimal | (owms_q, owms_q, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e37d875f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2536 | try | CALL_EXT | siDetail.SetDecimal | (mes_q, mes_q, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3571f53 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2537 | try | CALL_EXT | siDetail.SetDecimal | (total_q, total_q, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16d462df | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2539 | try | CALL_EXT | siDetail.SetDecimal | (iwms_qty_pcm, iwms_qty_pcm, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a9261de | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2540 | try | CALL_EXT | siDetail.SetDecimal | (mes_qty_pcm, mes_qty_pcm, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-87c04c38 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2541 | try | CALL_EXT | siDetail.SetDecimal | (owms_qty_pcm, owms_qty_pcm, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4972ef3b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2542 | try | CALL_EXT | siDetail.SetDecimal | (total_qty_pcm, total_qty_pcm, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd587220 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2544 | try | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9edffb8d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2558 | finally | GRID_STYLE | siDetail.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-7b7c2b4b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] | SSP0022_ShipmentRequestElectrode.cs:2559 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.FindData_Main

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd179da9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2105 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-06cf8ce1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2111 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e11b21e6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2111 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbaadfb3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2119 | try | FLAG | iTopRow | siMain.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-104ce4f7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2119 | try | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d5869d3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2120 | try | FLAG | iLeftCol | siMain.SpreadObject.GetViewportLeftColumn(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c00fe98b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2120 | try | CALL_EXT | siMain.SpreadObject.GetViewportLeftColumn | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d61e01b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2124 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-93d620fb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2125 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-be646d73 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2125 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d08903b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2180 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9ad58bf2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2181 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-357cdd34 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2185 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_SHIPMENT_PSI") ⇒ SSP.SSP0022_GET_SHIPMENT_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-9fae74a5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2187 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-872de3f8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2189 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-07eb9ff6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2190 | try ▸ lambda | DATA_OP | req.Parameters["P_COMPANY_ID"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a8c99e0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2191 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1db5ba6b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2192 | try ▸ lambda | DATA_OP | req.Parameters["P_CELL_TYPE"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-783f743a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2193 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-af647d40 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2194 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-45109742 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2195 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b7d2f9df | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2196 | try ▸ lambda | DATA_OP | req.Parameters["P_MODEL_ID"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-2393d732 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2197 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e839d2e0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2198 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-b0e6033b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2199 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e047fe0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2200 | try ▸ lambda | DATA_OP | req.Parameters["P_PROGRAM_ID"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-57c9824c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2201 | try ▸ lambda | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-c501bfe6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2202 | try ▸ lambda | DATA_OP | req.Parameters["P_REAL_FLAG"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0081c4fd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2203 | try ▸ lambda | DATA_OP | req.Parameters["P_MY_MODEL_CHK"] | p_my_model_chk | 행/컬럼 값 대입 |  |  |  |
| AC-cfbe304b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2204 | try ▸ lambda | DATA_OP | req.Parameters["P_PART_LEADER_CHK"] | p_part_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-558bec6b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2205 | try ▸ lambda | DATA_OP | req.Parameters["P_TEAM_LEADER_CHK"] | p_team_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-2ba6dd3a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2206 | try ▸ lambda | DATA_OP | req.Parameters["P_DELEGATE_CHK"] | p_delegate_chk | 행/컬럼 값 대입 |  |  |  |
| AC-7bf8b6e2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2207 | try ▸ lambda | DATA_OP | req.Parameters["P_NON_CHK"] | p_non_chk | 행/컬럼 값 대입 |  |  |  |
| AC-c13cadee | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2209 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e9b4e60 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2210 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2e2d14eb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2221 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6d154ad1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2223 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3ef997a7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2225 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1aa2beb7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2231 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae035072 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2239 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-01b459f7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2244 | finally | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-1fbfd287 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2245 | finally | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, iLeftCol) | 그리드 표시 설정 |  |  |  |
| AC-0f7ae0ee | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:2250 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.FindData_Request_Detail

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1)] / SaveButton [else of (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e570723 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2257 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ac4f5f63 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2262 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a9563352 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2262 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62bf127c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2270 | try | FLAG | iTopRow | siDetail.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-046d93f5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2270 | try | CALL_EXT | siDetail.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-511147d8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2272 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-58a9034b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2273 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-4b67a282 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2273 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f52d434a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2334 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-492ef2a1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2335 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ab160b0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2339 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_REQUEST_DETAIL") ⇒ SSP.SSP0022_GET_REQUEST_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-3891c53c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2341 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fc0b68c2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2343 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2105275 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2344 | try ▸ lambda | DATA_OP | req.Parameters["P_COMPANY_ID"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6256821 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2345 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ef07d9c5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2346 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1bc0b51d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2347 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a141a4a5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2348 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d13fad0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2349 | try ▸ lambda | DATA_OP | req.Parameters["P_CELL_TYPE"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-2249d81c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2350 | try ▸ lambda | DATA_OP | req.Parameters["P_LOT_ID"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-c14a4789 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2351 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e6547f2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2352 | try ▸ lambda | DATA_OP | req.Parameters["P_MODEL_ID"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-ac758a20 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2353 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f054343d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2354 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fb50306 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2355 | try ▸ lambda | DATA_OP | req.Parameters["P_REQUESTOR_ID"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-12573269 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2356 | try ▸ lambda | DATA_OP | req.Parameters["P_PROGRAM_ID"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-9bd50960 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2357 | try ▸ lambda | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-71347921 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2358 | try ▸ lambda | DATA_OP | req.Parameters["P_REAL_FLAG"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c2b7cbe2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2359 | try ▸ lambda | DATA_OP | req.Parameters["P_MY_MODEL_CHK"] | p_my_model_chk | 행/컬럼 값 대입 |  |  |  |
| AC-1e2ad9b6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2360 | try ▸ lambda | DATA_OP | req.Parameters["P_PART_LEADER_CHK"] | p_part_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-aa327eed | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2361 | try ▸ lambda | DATA_OP | req.Parameters["P_TEAM_LEADER_CHK"] | p_team_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-1e9fc415 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2362 | try ▸ lambda | DATA_OP | req.Parameters["P_DELEGATE_CHK"] | p_delegate_chk | 행/컬럼 값 대입 |  |  |  |
| AC-dcb86fd4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2363 | try ▸ lambda | DATA_OP | req.Parameters["P_NON_CHK"] | p_non_chk | 행/컬럼 값 대입 |  |  |  |
| AC-3e9d0702 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2365 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2daeb6ca | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2366 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3abb32a1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2374 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-de436584 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2376 | try | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c9a88890 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2378 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f66d884 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2381 | try | CALL_EXT | siDetail.SetDecimal | (qty, qty, 3, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e88935d6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2382 | try | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34c8ee01 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2397 | finally | GRID_STYLE | siDetail.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-821afaaf | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 2 | SSP0022_ShipmentRequestElectrode.cs:2398 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.FindData_Request_Detail_DownLoad

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20fd4c40 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2971 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b5b2be55 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2976 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c09f7f6a | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2976 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dcfc1bf | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2984 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fe475e0f | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2985 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-1031111d | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:2985 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62a1f745 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3038 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-58b7302b | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3039 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61dfbc84 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3043 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN") ⇒ SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | 엔드포인트 요청 생성 |  |  |  |
| AC-50ba3a06 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3045 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-eef49266 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3047 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bdc94bec | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3048 | try ▸ lambda | DATA_OP | req.Parameters["P_COMPANY_ID"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a437770 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3049 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fc286a02 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3050 | try ▸ lambda | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a7419a8b | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3051 | try ▸ lambda | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-14629106 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3052 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-0fb807fb | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3053 | try ▸ lambda | DATA_OP | req.Parameters["P_CELL_TYPE"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-35f99674 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3054 | try ▸ lambda | DATA_OP | req.Parameters["P_LOT_ID"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-531419f5 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3055 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebf7120c | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3056 | try ▸ lambda | DATA_OP | req.Parameters["P_MODEL_ID"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f17b5fe | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3057 | try ▸ lambda | DATA_OP | req.Parameters["P_NICK_NAME"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-f0883bc0 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3058 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eec2224d | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3059 | try ▸ lambda | DATA_OP | req.Parameters["P_REQUESTOR_ID"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-9cd4c77f | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3060 | try ▸ lambda | DATA_OP | req.Parameters["P_PROGRAM_ID"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-cdf10891 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3061 | try ▸ lambda | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-47548058 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3062 | try ▸ lambda | DATA_OP | req.Parameters["P_REAL_FLAG"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f67b04c0 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3063 | try ▸ lambda | DATA_OP | req.Parameters["P_MY_MODEL_CHK"] | p_my_model_chk | 행/컬럼 값 대입 |  |  |  |
| AC-b73a3832 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3064 | try ▸ lambda | DATA_OP | req.Parameters["P_PART_LEADER_CHK"] | p_part_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-866a109f | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3065 | try ▸ lambda | DATA_OP | req.Parameters["P_TEAM_LEADER_CHK"] | p_team_leader_chk | 행/컬럼 값 대입 |  |  |  |
| AC-f1715059 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3066 | try ▸ lambda | DATA_OP | req.Parameters["P_DELEGATE_CHK"] | p_delegate_chk | 행/컬럼 값 대입 |  |  |  |
| AC-90fac2f3 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3067 | try ▸ lambda | DATA_OP | req.Parameters["P_NON_CHK"] | p_non_chk | 행/컬럼 값 대입 |  |  |  |
| AC-d6b1a8fe | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3069 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16640e93 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3070 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-df76b7a2 | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3076 | try | GRID_BIND | siSub.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5b29609f | this.formDown.Click | SSP0022_ShipmentRequestElectrode.cs:3084 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.fnValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7c189d1 | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name … | SSP0022_ShipmentRequestElectrode.cs:3857 | if (iValidation > 0) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-e0ed117f | SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name … | SSP0022_ShipmentRequestElectrode.cs:3860 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd7b33db | this.Load | SSP0022_ShipmentRequestElectrode.cs:353 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bcb00b2e | this.Load | SSP0022_ShipmentRequestElectrode.cs:362 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_CLEAR | clbCompany_ID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b6d59a16 | this.Load | SSP0022_ShipmentRequestElectrode.cs:363 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aec2f41a | this.Load | SSP0022_ShipmentRequestElectrode.cs:364 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58e27702 | this.Load | SSP0022_ShipmentRequestElectrode.cs:2096 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6d575eb0 | this.Load | SSP0022_ShipmentRequestElectrode.cs:2097 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-680d6e1d | this.Load | SSP0022_ShipmentRequestElectrode.cs:2100 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.GetSpdTitle

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK) ▸ try] / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b79ca137 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3869 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN") ⇒ SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-744524fb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3872 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4ff60976 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3873 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-80a7f39b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3875 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4bcec549 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3875 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0022_ShipmentRequestElectrode.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4c26d63 | EditButton | SSP0022_ShipmentRequestElectrode.cs:4448 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-aa2df450 | EditButton | SSP0022_ShipmentRequestElectrode.cs:4452 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-643a303e | EditButton | SSP0022_ShipmentRequestElectrode.cs:4453 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce67f249 | EditButton | SSP0022_ShipmentRequestElectrode.cs:4454 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3b1deacf | EditButton | SSP0022_ShipmentRequestElectrode.cs:4455 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2f1543f | EditButton | SSP0022_ShipmentRequestElectrode.cs:4459 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61681047 | EditButton | SSP0022_ShipmentRequestElectrode.cs:4463 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestElectrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d36fbe9 | this.Load | SSP0022_ShipmentRequestElectrode.cs:456 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-50c43c30 | this.Load | SSP0022_ShipmentRequestElectrode.cs:459 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd9b8a9c | this.Load | SSP0022_ShipmentRequestElectrode.cs:462 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ee48306 | this.Load | SSP0022_ShipmentRequestElectrode.cs:463 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtStockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-297e8b11 | this.Load | SSP0022_ShipmentRequestElectrode.cs:465 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-9e1285d2 | this.Load | SSP0022_ShipmentRequestElectrode.cs:468 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-996532ae | this.Load | SSP0022_ShipmentRequestElectrode.cs:469 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1d82305c | this.Load | SSP0022_ShipmentRequestElectrode.cs:472 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dc833428 | this.Load | SSP0022_ShipmentRequestElectrode.cs:477 | if (drPgmAuthId != null) | FLAG | bEdit_Auth | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5ccc2842 | this.Load | SSP0022_ShipmentRequestElectrode.cs:482 | else of (drPgmAuthId != null) | FLAG | bEdit_Auth | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a9276a65 | this.Load | SSP0022_ShipmentRequestElectrode.cs:488 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa81ff77 | this.Load | SSP0022_ShipmentRequestElectrode.cs:489 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-3316e0f6 | this.Load | SSP0022_ShipmentRequestElectrode.cs:490 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f4ef247 | this.Load | SSP0022_ShipmentRequestElectrode.cs:491 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7c1d01d3 | this.Load | SSP0022_ShipmentRequestElectrode.cs:493 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-2141bafd | this.Load | SSP0022_ShipmentRequestElectrode.cs:496 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d3ed9475 | this.Load | SSP0022_ShipmentRequestElectrode.cs:497 |  | UI_PROP | layoutControlItem22.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a3556984 | this.Load | SSP0022_ShipmentRequestElectrode.cs:498 |  | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7276c1f4 | this.Load | SSP0022_ShipmentRequestElectrode.cs:499 |  | UI_PROP | layoutControlItem25.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-bf40811a | this.Load | SSP0022_ShipmentRequestElectrode.cs:501 |  | UI_PROP | layoutControlItem20.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3695d546 | this.Load | SSP0022_ShipmentRequestElectrode.cs:502 |  | UI_PROP | layoutControlItem29.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-979635e4 | this.Load | SSP0022_ShipmentRequestElectrode.cs:505 |  | VALUE_SET | chkMyModel.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6c69fa8a | this.Load | SSP0022_ShipmentRequestElectrode.cs:511 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) | DATA_OP | dtMyModelChk.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43431441 | this.Load | SSP0022_ShipmentRequestElectrode.cs:514 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) ▸ if (dr != null) | VALUE_SET | chkMyModel.Checked | true | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.InitSpread

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK) ▸ try] / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c047aeeb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:607 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-f019d199 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:609 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-1458943c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:618 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71bab9ed | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:621 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-18b6b343 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:628 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-78e672ed | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:629 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9062af2 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:630 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-34d4d2f4 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:631 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ec716dac | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:632 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a16389f1 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:633 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-de680a34 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:634 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5f9fd26b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:635 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e927b2e6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:636 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-adf24014 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:642 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-32862cfb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:643 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-24b6bff0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:644 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-238c0387 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:645 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-abb0bdd9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:646 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bda0c845 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:647 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-52d18a9b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:648 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b2809a31 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:649 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-53d7a028 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:650 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8d2a396a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:655 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f373df5a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:656 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-364f74ad | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:657 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6d4785f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:658 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2f9e2b92 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:659 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7c837b78 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:660 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-55790d6d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:661 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5500673f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:662 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dea50dae | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:663 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cebead70 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:669 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-751e0f1d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:671 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-c6785011 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:683 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45486162 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:684 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-51ef4723 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:692 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3471d1a9 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:694 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e6689dc8 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:696 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64cb1450 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:697 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f507c262 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:705 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ else of (spdInfo.SheetName == Spd… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1cc76e1f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:707 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ else of (spdInfo.SheetName == Spd… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-15896778 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:709 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtStockDetail) ▸ else of (spdInfo.SheetName == Spd… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestElectrode.InitSpreadDateColumn

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ee36cb6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:716 | if (string.IsNullOrWhiteSpace(cboPlanDate.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f30930b7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:736 |  | UI_MISC | spdInfo.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6346e197 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:753 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d9133e0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:759 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11961758 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:763 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-85d2ed71 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:770 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ffd693b | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:771 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e6d3b24 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:776 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73dcdc9a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:777 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2198708 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:785 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelNam… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84a72d67 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:786 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelNam… | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddcf6243 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:796 | try | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71cb45a0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:797 | try | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32e1eaae | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:798 | try | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6f28443 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:799 | try | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8e66d50 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:807 | finally | UI_MISC | spdInfo.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0022_ShipmentRequestElectrode.InitSpreadFooterSum

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail)] / this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtStockDetail)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ else of (spdInfo.She…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e644df | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3603 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8fa2d1b5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3604 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-c239f50a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3621 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-020b01de | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3622 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-535da788 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3623 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-1999a62d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 8 | SSP0022_ShipmentRequestElectrode.cs:3624 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80c9e97f | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1473 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c67e2325 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1476 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | FLAG | dtFromSiteDetail | Data.Common(Data.Type.PlantByElectordeShipFromSite, false, CString.GetCheckedListValue(dtM… ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-933e5423 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1476 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipFromSite, false, CString.GetCheckedListValue(dtMyDivision, … ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d8556c7 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1477 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | FLAG | dtToSiteDetail | Data.Common(Data.Type.PlantByElectordeShipToSite, false, CString.GetCheckedListValue(dtMyD… ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-2b4a3a21 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1477 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite, false, CString.GetCheckedListValue(dtMyDivision, cl… ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bd3b5a0 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1479 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), CString.GetChec… | 그리드 값 설정 |  |  |  |
| AC-346550b0 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1481 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE), dtFromSiteDetail) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c3413c48 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1482 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.TO_SITE), dtToSiteDetail) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b7166cf9 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1485 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_SET | siDetail.ActiveSheet.Cells[siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITE… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f30beb0c | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1488 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.MODEL_ID), siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6ad932b | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1489 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.NICK_NAME), siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-83a4c3e8 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1490 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d574705 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1491 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REQUESTOR), siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-506aee96 | InsertButton | SSP0022_ShipmentRequestElectrode.cs:1492 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtReques…) | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REQUEST_DATE), siDetail.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Plan_Current_Check

진입점: this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == 0)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK) ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)] / FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] / SaveButton …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a877875 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3546 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_InforElectrode, false, strCompanyID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1dec312 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3557 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00313", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-458adac3 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3564 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59d97e70 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3570 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d41a6a56 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3576 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17d5aaaf | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3578 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-83a9cd69 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3579 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-608a2e29 | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3580 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(sPlanDate) | 속성 Value1 설정 |  |  |  |
| AC-6654caea | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3581 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-2c719a6a | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3582 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1567e4c | this.formDown.Click [try ▸ if (cboPlanDate.SelectedIndex == … 외 5 | SSP0022_ShipmentRequestElectrode.cs:3583 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (Tmp_dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0022_ShipmentRequestElectrode.rdButton_Changed

진입점: this.rdButton1.CheckedChanged / this.rdButton2.CheckedChanged / this.rdButton3.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a626ca6f | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1823 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7e6cd4c9 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1824 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a75961f8 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1825 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4562db7 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1826 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-35067b89 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1827 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8dac38e4 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1828 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8a6c99e8 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1829 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2c862612 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1830 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-dc68292d | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1831 | if (rdButton1.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1c1f2281 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1837 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e3daebf4 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1838 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ff43fe5c | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1839 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-deced449 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1840 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-abffb205 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1841 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-118fb655 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1842 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1020a9bb | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1843 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7d925708 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1844 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fc91b778 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1845 | if (rdButton2.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1e381a3b | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1850 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-832b90a8 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1851 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9a961699 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1852 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_PCM)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2c920463 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1853 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fbcea42f | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1854 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dc8c7394 | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1855 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY_CELL)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1f5fb39d | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1856 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TOT_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67895e3c | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1857 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0cb54b0e | this.rdButton1.CheckedChanged 외 2 | SSP0022_ShipmentRequestElectrode.cs:1858 | if (rdButton3.Checked == true) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Re_Design

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ finally] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK) ▸ finally] / FindButton [finally] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7996e9d3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3496 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE) - 1].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-310ee11c | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3500 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SaveData

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1bdf171 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2775 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-134c12ab | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2779 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-68b13a1a | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2784 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fd103d4 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2787 | try ▸ if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-cd28a5ec | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2787 | try ▸ if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6400dad5 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2792 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c580d78 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2793 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71876fd5 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2860 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e0359cd | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2863 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_SAVE_SHIPMENT_REQUEST") ⇒ SSP.SSP0022_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-edf16813 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2866 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-14843cc2 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2868 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ea550be | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2873 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9e9d6c90 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2875 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-191575b9 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2876 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-86771c3b | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2877 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-b431fb02 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2878 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-586acfc5 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2879 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-af7df28b | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2880 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | sModelId | 행/컬럼 값 대입 |  |  |  |
| AC-a671377b | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2881 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-eadeeccb | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2882 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sFromSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-28624183 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2883 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sToSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d102abac | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2884 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_eta_date"] | sEtaDate | 행/컬럼 값 대입 |  |  |  |
| AC-35245dcc | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2885 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-92c3eaac | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2886 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c7785762 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2887 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-24b4c12e | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2888 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-f36774fb | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2889 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-39ba79d7 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2890 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-572ea5a3 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2892 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4ca2924 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2892 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-7992cb4d | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2903 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8a66c01d | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2904 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d998216b | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2920 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e66de1b8 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2921 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51b57347 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2926 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a454198 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2928 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c35ecf7c | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2942 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e90b310e | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2943 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17ab81d0 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2950 | try ▸ if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99723633 | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2956 | catch ((System.Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7cee839f | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2957 | catch ((System.Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54e6e82c | SaveButton [if (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2963 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SaveData_Detail

진입점: SaveButton [else of (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caf7c262 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2565 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef6c9483 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2569 | try | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d59dea37 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2593 | try ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-becd3ad7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2596 | try ▸ if (fps.Name == "spdDetail") | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-7e486e0f | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2596 | try ▸ if (fps.Name == "spdDetail") ▸ if (!DataUtil.checkRequiredOfSpread(siDetail)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0c88a96 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2601 | try ▸ if (fps.Name == "spdDetail") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-587cc9be | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2602 | try ▸ if (fps.Name == "spdDetail") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-768eb7ba | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2625 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ else of (DateTime.TryParse(siDetail.GetText(i, siDetail.… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-705c7a8d | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2626 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ else of (DateTime.TryParse(siDetail.GetText(i, siDetail.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb0b8c62 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2643 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (!ConfirmDayChk(i)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3f399221 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2644 | try ▸ if (fps.Name == "spdDetail") ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (!ConfirmDayChk(i)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9d02d94 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2669 | try ▸ if (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e212e462 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2671 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_SAVE_SHIPMENT_REQUEST") ⇒ SSP.SSP0022_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-3ee78318 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2674 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-55ad369d | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2678 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd3c92a7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2683 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-16c52499 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2685 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3c7b636e | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2686 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8b7d258 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2687 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-9be8f50b | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2688 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-52886d65 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2689 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-10c1b537 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2690 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e20c123 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2691 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec14a044 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2692 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ae61f279 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2693 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-75095df9 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2694 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_eta_date"] | p_shipment_date.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-33e4adb7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2695 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8971aa3a | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2696 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e8c4c00f | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2697 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-cb547466 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2698 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-969ae9b4 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2699 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5466c150 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2700 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5c4eadac | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2702 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f7dee17 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2702 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-217009a7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2713 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34e5e058 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2726 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Ta… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7fa88688 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2731 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Ta… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e8babe3 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2733 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Ta… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee2ed60e | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2746 | try ▸ if (fps.Name == "spdDetail") ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Ta… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ee33bd5 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2754 | try ▸ if (fps.Name == "spdDetail") ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5edec916 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2760 | catch ((System.Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-855cb608 | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2761 | catch ((System.Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-549e539b | SaveButton [else of (fps.Name == "spdMain")] | SSP0022_ShipmentRequestElectrode.cs:2767 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Set_Sum_Inventory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0940a36 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:3312 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure ==… | GRID_SET | siMain.SetValue | (i, j, R_INV_SHIP_REQ_QTY) | 그리드 값 설정 |  |  |  |
| AC-e33e2c11 | (진입점 미연결) | SSP0022_ShipmentRequestElectrode.cs:3349 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure ==… | GRID_SET | siMain.SetValue | (i, j, R_INV_SHIP_REQ_QTY) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.Set_Sum_Values

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ finally] / this.spdMain.CellDoubleClick [if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") ▸ if (popup.DialogResult == DialogResult.OK) ▸ finally] / FindButton [finally] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa5df2d | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3130 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_REQ") ▸ for (k <= siMain.Get… | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_REQ_TEMP, intSumInvReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-1c48175e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3136 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_REQ") ▸ for (k <= siMain.Get… | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_REQ_TEMP3, intTotInvReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-565a50fb | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3145 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_REQ") | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_REQ_TEMP, intSumInvReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-556a2f97 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3159 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_PLAN") ▸ for (k <= siMain.Ge… | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_PLAN_TEMP, intSumInvPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-4829ca22 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3165 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_PLAN") ▸ for (k <= siMain.Ge… | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_PLAN_TEMP3, intTotInvPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-9bcf1828 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 3 | SSP0022_ShipmentRequestElectrode.cs:3174 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (j <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "R_INV_SHIP_PLAN") | GRID_SET | siMain.SetValue | (j, R_INV_SHIP_PLAN_TEMP, intSumInvPlan_Qty) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-126fae97 | this.Load | SSP0022_ShipmentRequestElectrode.cs:379 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b5b1799 | this.Load | SSP0022_ShipmentRequestElectrode.cs:380 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9d4a4a25 | this.Load | SSP0022_ShipmentRequestElectrode.cs:386 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7dc89803 | this.Load | SSP0022_ShipmentRequestElectrode.cs:386 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-89ebcb72 | this.Load | SSP0022_ShipmentRequestElectrode.cs:391 | switch (triggerControl) case "Div_Company": | FLAG | dtCompany | DataService.GetSSPInnerTable("Div_Company", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-736b7ed2 | this.Load | SSP0022_ShipmentRequestElectrode.cs:391 | switch (triggerControl) case "Div_Company": | COMBO_DATA | DataService.GetSSPInnerTable | ("Div_Company", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5905b44b | this.Load | SSP0022_ShipmentRequestElectrode.cs:396 | switch (triggerControl) case "Div_CompanyEE": | FLAG | dtCompany | DataService.GetSSPInnerTable("Div_CompanyEE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee72b8fd | this.Load | SSP0022_ShipmentRequestElectrode.cs:396 | switch (triggerControl) case "Div_CompanyEE": | COMBO_DATA | DataService.GetSSPInnerTable | ("Div_CompanyEE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1c12752c | this.Load | SSP0022_ShipmentRequestElectrode.cs:401 | switch (triggerControl) case "MyCompanyID": | FLAG | dtMyCompany | DataService.GetSSPInnerTable("MyCompanyID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e529fe9e | this.Load | SSP0022_ShipmentRequestElectrode.cs:401 | switch (triggerControl) case "MyCompanyID": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyCompanyID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b1fd2705 | this.Load | SSP0022_ShipmentRequestElectrode.cs:406 | switch (triggerControl) case "CellTypeGr": | FLAG | dtCellType | DataService.GetSSPInnerTable("CellTypeGr", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b956007e | this.Load | SSP0022_ShipmentRequestElectrode.cs:406 | switch (triggerControl) case "CellTypeGr": | COMBO_DATA | DataService.GetSSPInnerTable | ("CellTypeGr", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-327418da | this.Load | SSP0022_ShipmentRequestElectrode.cs:411 | switch (triggerControl) case "MyModelChk": | FLAG | dtMyModelChk | DataService.GetSSPInnerTable("MyModelChk", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-63a7ed14 | this.Load | SSP0022_ShipmentRequestElectrode.cs:411 | switch (triggerControl) case "MyModelChk": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyModelChk", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7d1c0df2 | this.Load | SSP0022_ShipmentRequestElectrode.cs:416 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a303c52 | this.Load | SSP0022_ShipmentRequestElectrode.cs:416 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b575b0a0 | this.Load | SSP0022_ShipmentRequestElectrode.cs:421 | switch (triggerControl) case "PgmAuthId": | FLAG | dtPgmAuthId | DataService.GetSSPInnerTable("PgmAuthId", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d76c6d21 | this.Load | SSP0022_ShipmentRequestElectrode.cs:421 | switch (triggerControl) case "PgmAuthId": | COMBO_DATA | DataService.GetSSPInnerTable | ("PgmAuthId", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0022_ShipmentRequestElectrode.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f5f9141 | this.Load | SSP0022_ShipmentRequestElectrode.cs:527 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2b045c8e | this.Load | SSP0022_ShipmentRequestElectrode.cs:528 | if (dtMyDivision.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7ee33ab | this.Load | SSP0022_ShipmentRequestElectrode.cs:530 |  | FLAG | dtMyDivision | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-793f8a1c | this.Load | SSP0022_ShipmentRequestElectrode.cs:530 |  | DATA_OP | dtMyDivision.Select().Where(c => c["CODE"].ToString() != "EE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d494c2d2 | this.Load | SSP0022_ShipmentRequestElectrode.cs:530 |  | DATA_OP | dtMyDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e60e924 | this.Load | SSP0022_ShipmentRequestElectrode.cs:533 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8136585d | this.Load | SSP0022_ShipmentRequestElectrode.cs:534 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellType, clbCellType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9569bf30 | this.Load | SSP0022_ShipmentRequestElectrode.cs:543 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99afc2e0 | this.Load | SSP0022_ShipmentRequestElectrode.cs:543 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-44e82c74 | this.Load | SSP0022_ShipmentRequestElectrode.cs:544 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6fdb4401 | this.Load | SSP0022_ShipmentRequestElectrode.cs:548 |  | FLAG | sUserCompany_NM | dtMyCompany.Rows[0]["NAME"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SetSpreadColumn

진입점: this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.rdButton1.CheckedChanged / this.rdButton2.CheckedChanged / this.rdButton3.CheckedChanged / this.chkSum.CheckedChanged / this.chkPastPeriod.CheckedChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84f9dc52 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1904 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ef6751b6 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1909 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 \|\| siMai… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5e4f4bb7 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1917 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b819da55 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1922 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-931036e5 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1930 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d080c27e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1934 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c0b156a | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1938 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b78c4eee | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1946 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e879cb63 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1950 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdButton1.Checked == true) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d9cab0dc | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1961 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ if (siMain.GetColumnTag(iC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-84f91b38 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1965 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (siMain.GetColumnT… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8cd36286 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1973 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ if (cboBucketType.ControlV… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-12fc21de | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1978 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ if (cboBucketType.ControlV… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-48267bdd | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1986 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (cboBucketType.Con… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7e856938 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1990 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (cboBucketType.Con… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-09564094 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:1995 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (cboBucketType.Con… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a54f5dce | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2003 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (cboBucketType.Con… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c03312d3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2007 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ if (rdButton2.Checked == true) ▸ else of (cboBucketType.Con… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5acf0e88 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2017 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6765a554 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2021 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cdadb91f | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2029 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a6d448cf | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2034 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9fc12c4e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2042 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a84f2924 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2046 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-74144da0 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2051 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ba4c75e3 | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2059 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1017d3cc | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2063 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdButton1.Checked == true) ▸ else of (rdButton2.Checked == true) ▸ if (rdButton3.Checked… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e1725a5e | this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MS… 외 14 | SSP0022_ShipmentRequestElectrode.cs:2081 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (!chkPastPeriod.Checked) ▸ else of (siMain.ActiveSheet.ColumnHeader.Cells[2, iCol].Value.ToStr… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkPastPeriod.Checked | 그리드 속성/값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d161c022 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1361 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem27.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5fcf502e | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1362 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem26.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f99c6c9c | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1363 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem28.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6a6fe1a3 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1364 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5e6e1a41 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1366 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-569941ac | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1367 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") | UI_PROP | layoutControlItem25.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c85c1d41 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1372 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem27.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5409a236 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1373 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem26.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-77feb9cc | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1374 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem28.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7c46ccf0 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1375 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-72654b4a | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1377 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b00e7444 | this.spdDetail.ActiveSheetChanged | SSP0022_ShipmentRequestElectrode.cs:1378 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Stock Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Active… | UI_PROP | layoutControlItem25.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f448e7aa | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1040 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ccd356b | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1042 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c23ea71b | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1047 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4901fd4e | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1049 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2708a164 | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1054 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Incoterms") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c3504f2 | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1056 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-184f50e8 | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1061 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Trans Mode") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f584d99f | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1063 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (string… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5274034d | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1070 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | POPUP | new SSP0022_BodItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1602a2ac | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1072 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | POPUP | popItem.Form_Load | (false, sdivision, sFromSite, sToSite, sItemId, sPlanDate, sBodId, sIncoterms, sTransport) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6c0aa374 | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1073 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-adea85ef | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1074 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c952db9c | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1085 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-35d2b25a | this.spdDetail.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1086 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if ((sFrom… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.MODEL_ID), sModelID) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4083deac | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:894 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da659dbe | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:896 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-16bf1615 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:897 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18ea61b4 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:902 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d375944 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:903 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-03009555 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:904 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed1be03d | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:909 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Incoterms") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-821d882b | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:910 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6a713a93 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:911 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bf67e4e | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:916 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Trans Mode") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cd9584b | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:917 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c342bb3d | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:918 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ecc82104 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:925 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | new SSP0022_BodItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-087316ea | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:927 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | popItem.Form_Load | (false, sdivision, sFromSite, sToSite, sItemId, sPlanDate, sBodId, sIncoterms, sTransport) | 팝업 초기화(인자 전달) |  |  |  |
| AC-82066de8 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:928 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d27fa606 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:929 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-df5406f6 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:940 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-253eb602 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:941 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.MODEL_ID), sModelID) | 그리드 값 설정 |  |  |  |
| AC-dfde1b56 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:954 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-7e98e3c2 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:955 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-c8e7da1a | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:956 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d4c52c60 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:957 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-301afaf0 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:968 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-97718d9b | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:969 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-596f164e | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:970 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-31ae3114 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:971 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-466116e2 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:980 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f514d16 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:982 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb2aa92 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:995 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-143ac9d6 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:996 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-16bd3be9 | this.spdDetail.ClipboardPasted | SSP0022_ShipmentRequestElectrode.cs:997 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ for (iRow < e.CellRan… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b45a7165 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1110 | if (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-a6f397be | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1111 | if (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-ca0b3475 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1112 | if (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-70429a12 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1113 | if (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (!string.IsNullOrEmpty(sItemId)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-ba69236d | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1124 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (!st… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-22921638 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1125 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (!st… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-98998149 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1126 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (!st… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-14dd8d33 | this.spdDetail.ComboSelChange | SSP0022_ShipmentRequestElectrode.cs:1127 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.FROM_SITE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE)) ▸ if (!st… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b672dee | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1343 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec2e9f0c | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1344 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a73e938e | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1348 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b727d129 | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1349 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-931941b6 | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1353 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2c1032f | this.spdDetail.SheetTabClick | SSP0022_ShipmentRequestElectrode.cs:1354 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtRequestDetail_Excel) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdDetail_TopChange

진입점: this.spdDetail.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db024ab9 | this.spdDetail.TopChange | SSP0022_ShipmentRequestElectrode.cs:1450 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a3feaba | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1393 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f660014 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1394 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f2d7ac1 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1402 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | POPUP | new SSP0022_ShipmentRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fef3bec5 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1404 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._UserID | UserInfo.UserId | 속성 _UserID 설정 |  |  |  |
| AC-53eb5766 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1405 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision_ID.ControlValues) | 속성 _pDivision 설정 |  |  |  |
| AC-76b75ea7 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1406 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pPlanDate | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues) | 속성 _pPlanDate 설정 |  |  |  |
| AC-e3c3c5a3 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1407 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pCompanyId | CString.GetCheckedListValue(dtCompany, clbCompany_ID.ControlValues) | 속성 _pCompanyId 설정 |  |  |  |
| AC-f7b2e0dd | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1408 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pScmSiteId | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 속성 _pScmSiteId 설정 |  |  |  |
| AC-3ddc24a3 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1409 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pPlantId | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 속성 _pPlantId 설정 |  |  |  |
| AC-f0ffea8a | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1410 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pModelId | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID)).ToString() | 속성 _pModelId 설정 |  |  |  |
| AC-bac1f5a5 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1411 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pItemId | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 속성 _pItemId 설정 |  |  |  |
| AC-7111c492 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1412 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pFromSite | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 속성 _pFromSite 설정 |  |  |  |
| AC-c6607e1a | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1413 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pToSite | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE)).ToString() | 속성 _pToSite 설정 |  |  |  |
| AC-68fe8615 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1414 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pIncoterms | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString() | 속성 _pIncoterms 설정 |  |  |  |
| AC-c220408e | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1415 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pTransMode | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)).ToString() | 속성 _pTransMode 설정 |  |  |  |
| AC-e8e5dde5 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1417 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pBodId | "" | 속성 _pBodId 설정 |  |  |  |
| AC-0d49b185 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1418 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pConfirmDay | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY)).ToString() | 속성 _pConfirmDay 설정 |  |  |  |
| AC-a67112b5 | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1419 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._TimeZone | UserInfoContext.Current[UserInfoProperites.TimeZone] | 속성 _TimeZone 설정 |  |  |  |
| AC-35093f8a | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1420 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8da6042d | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1421 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | UI_PROP | popup._pDivision_org | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TEMPCOLUMN)).ToString() | 속성 _pDivision_org 설정 |  |  |  |
| AC-adbe3e8d | this.spdMain.CellDoubleClick | SSP0022_ShipmentRequestElectrode.cs:1429 | if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE) - 1) ▸ if (strMeasure == "R_SHIP_REQ_ETA") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c600250 | this.spdMain.Change | SSP0022_ShipmentRequestElectrode.cs:1284 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d2099b9e | this.spdMain.Change | SSP0022_ShipmentRequestElectrode.cs:1285 |  | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SSP0022_ShipmentRequestElectrode.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa9c4bfb | this.spdMain.TopChange | SSP0022_ShipmentRequestElectrode.cs:1443 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_ShipmentRequestPopup.BodItemValidChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1602a173 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:770 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK") ⇒ SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-57033429 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:771 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe10f8cf | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:772 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-70f8b4a1 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:773 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-2f4e51e0 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:774 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b201752a | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:777 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51bd3f0c | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:785 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9a16cfea | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:790 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3452751e | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:792 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-97318087 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:797 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7077a096 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:801 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f00fb892 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:803 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.BodValidChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6cea8bb | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:663 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_BOD_VALID_CHECK") ⇒ SSP.SSP0002_GET_BOD_VALID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-f95705b1 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:664 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7bdb511b | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:665 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-defa6896 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:666 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-82a8e85d | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:667 | try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-8e95b65d | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:668 | try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-ae0223cd | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:669 | try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-0510e209 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:671 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-deb169a3 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:679 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-63137a8b | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:684 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6334e9ce | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:686 | try ▸ else of (ds.Tables[0].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7c2619e | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:692 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1540d4d4 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:698 | try ▸ if (ds.Tables[1].Rows.Count > 0) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1740e28d | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:703 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58c38fac | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:705 | try ▸ else of (ds.Tables[1].Rows.Count > 0) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-77a65b3d | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:709 | try ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-20243e8b | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:716 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2fb1c870 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:718 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-206e9b6f | this.btnButtonList.UsrButtonList_Click_Detected | SSP0022_ShipmentRequestPopup.cs:819 | if (buttonItem.UserType == ButtonListType.Save) ▸ if (!bSaveCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f9ac92c | this.btnButtonList.UsrButtonList_Click_Detected | SSP0022_ShipmentRequestPopup.cs:826 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4154788b | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1240 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantByElectordeShipFromSite, false, _pDivision, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-11d9464b | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1240 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipFromSite, false, _pDivision, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d8f742f | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1241 |  | FLAG | dtFromSite_Copy | dtFromSite.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-39243f08 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1241 |  | DATA_OP | dtFromSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7690fc5 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1242 |  | FLAG | dtToSite | Data.Common(Data.Type.PlantByElectordeShipToSite, false, _pDivision, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-a730d812 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1242 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite, false, _pDivision, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-65bfe21d | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1246 |  | FLAG | dtIncoterms | Data.Common(Data.Type.Incoterms) ⇒ biz:CommonData.CommonDataList [code=Incoterms] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ea61849 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1246 |  | COMBO_DATA | Data.Common | (Data.Type.Incoterms) ⇒ biz:CommonData.CommonDataList [code=Incoterms] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56710b26 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1247 |  | FLAG | dtTransMode | Data.Common(Data.Type.TransportMode) ⇒ biz:CommonData.CommonDataList [code=TransportMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-24cd1f1d | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1247 |  | COMBO_DATA | Data.Common | (Data.Type.TransportMode) ⇒ biz:CommonData.CommonDataList [code=TransportMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d35f1f6 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1258 | if (_pToSite == "" \|\| _pToSite == "-") ▸ if (dtToSite.Rows.Count > 0) | FLAG | _pToSite | dtToSite.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-91884380 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1263 | if (dtFromSite_Copy.Rows.Count == 1) | FLAG | _pFromSite | dtFromSite_Copy.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-873a1fcb | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1272 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-58ad7a0f | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1273 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtFromSite_Copy) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-75579b09 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1275 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-76880160 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1276 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fc9fd070 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1277 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncoterms) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8ff449c9 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1278 |  | GRID_COMBO | siMain.SetCellTypeCombo | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d82ce6a9 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1281 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.DIVISION_ID), _pDivision) | 그리드 값 설정 |  |  |  |
| AC-11cb8e30 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1282 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), _pScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-8f88a0fe | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1283 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.MODEL_ID), _pModelId) | 그리드 값 설정 |  |  |  |
| AC-a6b48835 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1284 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.ITEM_ID), _pItemId) | 그리드 값 설정 |  |  |  |
| AC-8abbfc12 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1285 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE), _pFromSite) | 그리드 값 설정 |  |  |  |
| AC-4895a6de | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1286 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.TO_SITE), _pToSite) | 그리드 값 설정 |  |  |  |
| AC-60624e1c | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1287 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS), _pIncoterms) | 그리드 값 설정 |  |  |  |
| AC-8e00f6a5 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1288 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), _pTransMode) | 그리드 값 설정 |  |  |  |
| AC-9d0180ef | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1289 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.BOD_ID), _pBodId) | 그리드 값 설정 |  |  |  |
| AC-17a3a487 | this.clbDivision.SelectedIndexChanged | SSP0022_ShipmentRequestPopup.cs:1290 |  | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY), _pConfirmDay) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.ConfirmDayChk

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47ba7a97 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:734 | try ▸ if (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ca6f4f3d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:739 | try ▸ else of (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00323", new object[] { sConfirmDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de459bc9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:740 | try ▸ else of (DateTime.Parse(sConfirmDay) <= DateTime.Parse(sShipmentDay)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-77213c7e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:746 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-586d66f5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:748 | catch ((Exception ex)) ▸ if (MessageHelper.GMessageBox("MSG00324") == DialogResult.Yes) | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b96afbe | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:752 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2cd7c450 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:754 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9198a5ec | this.Load | SSP0022_ShipmentRequestPopup.cs:212 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 32) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a1a033fe | this.Load | SSP0022_ShipmentRequestPopup.cs:213 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab995ea2 | this.Load | SSP0022_ShipmentRequestPopup.cs:214 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0022_ShipmentRequestPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21de8928 | this.Load | SSP0022_ShipmentRequestPopup.cs:185 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-eaa1cd6f | this.Load | SSP0022_ShipmentRequestPopup.cs:187 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f103c167 | this.Load | SSP0022_ShipmentRequestPopup.cs:188 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-ed022192 | this.Load | SSP0022_ShipmentRequestPopup.cs:189 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd3cfee4 | Dispose | SSP0022_ShipmentRequestPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0022_ShipmentRequestPopup.FindData

진입점: this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" && _pToSite != "")] / spdMain.ComboSelChange [else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_SITE))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfc208e3 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:358 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20d5a417 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:362 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_GET_ITEM_POPUP") ⇒ SSP.SSP0022_GET_ITEM_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-80930f26 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:363 | lambda | DATA_OP | request.Parameters["p_division_id"] | sdivision_Org | 행/컬럼 값 대입 |  |  |  |
| AC-4ddf2d12 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:364 | lambda | DATA_OP | request.Parameters["p_from_site_id"] | sFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-80d9a60c | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:365 | lambda | DATA_OP | request.Parameters["p_to_site_id"] | sToSite | 행/컬럼 값 대입 |  |  |  |
| AC-a2073884 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:366 | lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-aa259b34 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:367 | lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-2d35fc4c | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:368 | lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3d1a4537 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:369 | lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransport | 행/컬럼 값 대입 |  |  |  |
| AC-69b10b5b | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:370 | lambda | DATA_OP | request.Parameters["P_PLAN_START_YYYYMMDD"] | _pPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-ab566047 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:371 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1924580d | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:373 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5873dc79 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:379 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-0ac6df74 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:429 | if (dtFindData.Rows.Count > 0) | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID), sdivision_Org) | 그리드 값 설정 |  |  |  |
| AC-bd92f3bc | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:430 | if (dtFindData.Rows.Count > 0) | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-bd008378 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:431 | if (dtFindData.Rows.Count > 0) | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sTransport) | 그리드 값 설정 |  |  |  |
| AC-2e801e3c | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:432 | if (dtFindData.Rows.Count > 0) | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.BOD_ID), sBodId) | 그리드 값 설정 |  |  |  |
| AC-609b09b5 | this.clbDivision.SelectedIndexChanged [if (_pFromSite != "" … 외 1 | SSP0022_ShipmentRequestPopup.cs:433 | if (dtFindData.Rows.Count > 0) | GRID_SET | siMain.SetValue | (0, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY), sConfirmDay) | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e9b155b | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:1340 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-6a39e8d2 | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:1343 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597befc8 | this.Load | SSP0022_ShipmentRequestPopup.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bc8cd586 | this.Load | SSP0022_ShipmentRequestPopup.cs:158 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-95155e91 | this.Load | SSP0022_ShipmentRequestPopup.cs:169 |  | VALUE_SET | clbDivision.ControlValues | _pDivision | 컨트롤 값 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcbd7047 | this.Load | SSP0022_ShipmentRequestPopup.cs:1225 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH") ⇒ SCP.GET_DATE_RANGE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-ec9a2562 | this.Load | SSP0022_ShipmentRequestPopup.cs:1227 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-61dbec72 | this.Load | SSP0022_ShipmentRequestPopup.cs:1228 |  | DATA_OP | request.Parameters["p_offset_day"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-3997b82d | this.Load | SSP0022_ShipmentRequestPopup.cs:1229 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-3d57942b | this.Load | SSP0022_ShipmentRequestPopup.cs:1230 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2e33e85 | this.Load | SSP0022_ShipmentRequestPopup.cs:1233 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ecb420e | this.Load | SSP0022_ShipmentRequestPopup.cs:194 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3facc35e | this.Load | SSP0022_ShipmentRequestPopup.cs:197 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-0123a443 | this.Load | SSP0022_ShipmentRequestPopup.cs:202 |  | FLAG | dBaseDate | Convert.ToDateTime(dtTime).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-55026d55 | this.Load | SSP0022_ShipmentRequestPopup.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-317da7cb | this.Load | SSP0022_ShipmentRequestPopup.cs:206 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0022_ShipmentRequestPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b1fe55 | this.Load | SSP0022_ShipmentRequestPopup.cs:223 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b179bc71 | this.Load | SSP0022_ShipmentRequestPopup.cs:256 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-35d5efa8 | this.Load | SSP0022_ShipmentRequestPopup.cs:257 |  | GRID_INIT | siMain.AddComboColumn | ("Div*", DefColumns.DIVISION_ID, FPMerge.None, 100, true, dtDivision, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5583d6f | this.Load | SSP0022_ShipmentRequestPopup.cs:259 |  | GRID_INIT | siMain.AddComboColumn | ("SCM Site*", DefColumns.SCM_SITE_ID, FPMerge.None, 130, false, dtFromSite_Copy, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42c281be | this.Load | SSP0022_ShipmentRequestPopup.cs:260 |  | GRID_INIT | siMain.AddComboColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 130, false, dtFromSite_Copy, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5fef75e | this.Load | SSP0022_ShipmentRequestPopup.cs:261 |  | GRID_INIT | siMain.AddComboColumn | ("From Site*", DefColumns.FROM_SITE, FPMerge.None, 130, true, dtFromSite, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf30bfde | this.Load | SSP0022_ShipmentRequestPopup.cs:262 |  | GRID_INIT | siMain.AddComboColumn | ("To Site*", DefColumns.TO_SITE, FPMerge.None, 130, true, dtToSite, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28289c80 | this.Load | SSP0022_ShipmentRequestPopup.cs:263 |  | GRID_INIT | siMain.AddTextColumn | ("Model*", DefColumns.MODEL_ID, FPMerge.None, 150, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48c0dad1 | this.Load | SSP0022_ShipmentRequestPopup.cs:264 |  | GRID_INIT | siMain.AddTextColumn | ("Material*", DefColumns.ITEM_ID, FPMerge.None, 150, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54a43235 | this.Load | SSP0022_ShipmentRequestPopup.cs:265 |  | GRID_INIT | siMain.AddTextColumn | ("Nick Name", DefColumns.NICK_NAME, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0d13fed | this.Load | SSP0022_ShipmentRequestPopup.cs:266 |  | GRID_INIT | siMain.AddDateColumn | ("Shipment Date*", DefColumns.SHIPMENT_DATE, FPMerge.None, 80, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f89b5104 | this.Load | SSP0022_ShipmentRequestPopup.cs:267 |  | GRID_INIT | siMain.AddNumColumn | ("Qty* ", DefColumns.SHIPMENT_QTY, FPMerge.None, 60, true, FPHAlign.Right, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bce8316 | this.Load | SSP0022_ShipmentRequestPopup.cs:268 |  | GRID_INIT | siMain.AddComboColumn | ("Incoterms*", DefColumns.INCOTERMS, FPMerge.None, 70, true, dtIncoterms, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-990abbb7 | this.Load | SSP0022_ShipmentRequestPopup.cs:269 |  | GRID_INIT | siMain.AddComboColumn | ("Trans Mode* ", DefColumns.TRANSPORT_MODE, FPMerge.None, 70, true, dtTransMode, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f1d1f83 | this.Load | SSP0022_ShipmentRequestPopup.cs:270 |  | GRID_INIT | siMain.AddNumColumn | ("L/T(Day)", DefColumns.LT, FPMerge.None, 60, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab873643 | this.Load | SSP0022_ShipmentRequestPopup.cs:271 |  | GRID_INIT | siMain.AddDateColumn | ("ETD", DefColumns.ETD, FPMerge.None, 80, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6daec83c | this.Load | SSP0022_ShipmentRequestPopup.cs:272 |  | GRID_INIT | siMain.AddDateColumn | ("ETA", DefColumns.ETA, FPMerge.None, 80, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac379378 | this.Load | SSP0022_ShipmentRequestPopup.cs:274 |  | GRID_INIT | siMain.AddTextColumn | ("ROUTE_ID", DefColumns.ROUTE_ID, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e426b6af | this.Load | SSP0022_ShipmentRequestPopup.cs:275 |  | GRID_INIT | siMain.AddTextColumn | ("BOD_ID", DefColumns.BOD_ID, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91d9f40d | this.Load | SSP0022_ShipmentRequestPopup.cs:276 |  | GRID_INIT | siMain.AddTextColumn | ("CONFIRM_DAY", DefColumns.CONFIRM_DAY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8f53115 | this.Load | SSP0022_ShipmentRequestPopup.cs:277 |  | GRID_INIT | siMain.AddTextColumn | ("D_COUNTRY", DefColumns.D_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cc9b7a9 | this.Load | SSP0022_ShipmentRequestPopup.cs:278 |  | GRID_INIT | siMain.AddTextColumn | ("D_PORT_CODE", DefColumns.D_PORT_CODE, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9fa10d4 | this.Load | SSP0022_ShipmentRequestPopup.cs:279 |  | GRID_INIT | siMain.AddTextColumn | ("A_COUNTRY", DefColumns.A_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6523c659 | this.Load | SSP0022_ShipmentRequestPopup.cs:280 |  | GRID_INIT | siMain.AddTextColumn | ("A_PORT_CODE", DefColumns.A_PORT_CODE, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d64b5a21 | this.Load | SSP0022_ShipmentRequestPopup.cs:281 |  | GRID_INIT | siMain.AddTextColumn | ("TO_COUNTRY", DefColumns.TO_COUNTRY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-159badf8 | this.Load | SSP0022_ShipmentRequestPopup.cs:282 |  | GRID_INIT | siMain.AddTextColumn | ("TO_CITY", DefColumns.TO_CITY, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0db3aba4 | this.Load | SSP0022_ShipmentRequestPopup.cs:284 |  | GRID_INIT | siMain.AddTextColumn | ("ELECTRODE_YN", DefColumns.ELECTRODE_YN, FPMerge.None, 100, false, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3b85774 | this.Load | SSP0022_ShipmentRequestPopup.cs:285 |  | GRID_INIT | siMain.AddTextColumn | ("ORIGIN_FROM_DIVISION_ID", DefColumns.ORIGIN_FROM_DIVISION_ID, FPMerge.None, 100, false, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1772133 | this.Load | SSP0022_ShipmentRequestPopup.cs:289 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.SHIPMENT_QTY), 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0022_ShipmentRequestPopup.InsertRow

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cac08ede | this.Load | SSP0022_ShipmentRequestPopup.cs:321 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb3b883c | this.Load | SSP0022_ShipmentRequestPopup.cs:322 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-346ace19 | this.Load | SSP0022_ShipmentRequestPopup.cs:324 |  | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74d3c30b | this.Load | SSP0022_ShipmentRequestPopup.cs:327 |  | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금 전환 |  |  |  |
| AC-88b5c527 | this.Load | SSP0022_ShipmentRequestPopup.cs:328 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-20b42c22 | this.Load | SSP0022_ShipmentRequestPopup.cs:329 |  | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LT), siMain.GetColumnIndex(DefColumns.ETA), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec8e5659 | this.Load | SSP0022_ShipmentRequestPopup.cs:330 |  | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.MODEL_ID), siMain.GetColumnIndex(DefColumns.MOD… | 그리드 편집 잠금 전환 |  |  |  |
| AC-09ce3fd5 | this.Load | SSP0022_ShipmentRequestPopup.cs:331 |  | GRID_LOCK | siMain.LockRange3 | (insCell, siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetColumnIndex(DefColumns.ITEM… | 그리드 편집 잠금 전환 |  |  |  |

## SSP0022_ShipmentRequestPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d44bfa10 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:488 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-be21cb0e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:490 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-09f5c59f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:491 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c24f0b91 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:494 | try ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d217165b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:506 | try ▸ else of (DateTime.TryParse(siMain.GetText(0, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)).ToString(), out temp) == true) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84a6c1a4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:507 | try ▸ else of (DateTime.TryParse(siMain.GetText(0, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)).ToString(), out temp) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-449bd290 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:531 | try ▸ if (!ConfirmDayChk()) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6d6e9db0 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:532 | try ▸ if (!ConfirmDayChk()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df92ea98 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:537 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc13a428 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:539 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0022_SAVE_SHIPMENT_REQUEST") ⇒ SSP.SSP0022_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-b88199b3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:542 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c007c6fe | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:556 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4005c9f1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:561 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ead8c33e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:563 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | 'M' | 행/컬럼 값 대입 |  |  |  |
| AC-6ec425e3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:564 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | _pDivision_org | 행/컬럼 값 대입 |  |  |  |
| AC-44095b1e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:565 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_company_id"] | _pCompanyId | 행/컬럼 값 대입 |  |  |  |
| AC-9047a7c7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:566 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ee7cee4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:567 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | _pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-b5349a61 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:568 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3d80f00 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:569 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-71025189 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:570 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ef7da961 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:571 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-0a702299 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:572 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_eta_date"] | p_shipment_date.Replace("-","") | 행/컬럼 값 대입 |  |  |  |
| AC-1c98c240 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:573 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-3273a646 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:574 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-72d39a8c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:575 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-0dabffb3 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:576 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-08b29ec2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:577 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | _UserID | 행/컬럼 값 대입 |  |  |  |
| AC-401c68b1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:578 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-21ebaa14 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:580 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f13b57e7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:580 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-3da23be4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:591 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-138cddcf | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:593 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-df0157e5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:603 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70dfb2e5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:609 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b6ebf54 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:611 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c6dd8c7 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:625 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd1ed1c4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:634 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9bff0dbe | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:635 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ae0b2e4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:640 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7510cb50 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:641 | catch ((Exception ex)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-043785f1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0022_ShipmentRequestPopup.cs:642 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0022_ShipmentRequestPopup.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e3e7dde | (진입점 미연결) | SSP0022_ShipmentRequestPopup.cs:340 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-571015e3 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:943 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtFromSite | Data.Common(Data.Type.PlantByElectordeShipFromSite, false, sDivisionID, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-b97c8cfe | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:943 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipFromSite, false, sDivisionID, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipFromSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c624f4d4 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:944 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtFromSite_Copy | dtFromSite.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d583b24d | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:944 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | DATA_OP | dtFromSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6673cdb4 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:945 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtToSite | Data.Common(Data.Type.PlantByElectordeShipToSite, false, sDivisionID, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 화면 필드/플래그 변경 |  |  |  |
| AC-ea6e2515 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:945 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.Common | (Data.Type.PlantByElectordeShipToSite, false, sDivisionID, _pCompanyId) ⇒ biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c40b54e | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:949 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (dtToSite.Rows.Count == 1) | FLAG | sGlobalToSite | dtToSite.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-653ff551 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:952 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE), dtFromSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a8fd18bf | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:953 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), dtFromSite_Copy) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8dc8262f | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:954 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), dtToSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-150e81f0 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:956 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-642dfe32 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:957 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE), sGlobalToSite) | 그리드 값 설정 |  |  |  |
| AC-2bd2b85d | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:958 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-487a5f85 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:959 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODEL_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d428d243 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:960 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-ec076e5c | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:961 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-878221de | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:962 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-d1699ff6 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:963 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LT), "") | 그리드 값 설정 |  |  |  |
| AC-1a85140b | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:964 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETD), "") | 그리드 값 설정 |  |  |  |
| AC-d24fe327 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:965 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ETA), "") | 그리드 값 설정 |  |  |  |
| AC-2e6d62a9 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:966 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7ba1e827 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:967 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-4cbc395a | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:982 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-77a3eb13 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:983 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-5a7eef54 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:984 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-41410f9d | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:985 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ if … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-7d6832c8 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:991 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ els… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-d99f9127 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:992 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ els… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-edce7a58 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:993 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ els… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.BOD_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fcb5de27 | spdMain.ComboSelChange | SSP0022_ShipmentRequestPopup.cs:994 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_ID)) ▸ els… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CONFIRM_DAY), "") | 그리드 값 설정 |  |  |  |

## SSP0022_ShipmentRequestPopup.SpdMain_EditChange

진입점: spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7442b3ab | spdMain.EditChange | SSP0022_ShipmentRequestPopup.cs:1049 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00394241 | spdMain.EditChange | SSP0022_ShipmentRequestPopup.cs:1058 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-672e52dc | spdMain.EditChange | SSP0022_ShipmentRequestPopup.cs:1059 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), "") | 그리드 값 설정 |  |  |  |
| AC-210c844d | spdMain.EditChange | SSP0022_ShipmentRequestPopup.cs:1060 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) ▸ if (dBaseDate > dDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d66d7ccc | spdMain.EditChange | SSP0022_ShipmentRequestPopup.cs:1062 | if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |

