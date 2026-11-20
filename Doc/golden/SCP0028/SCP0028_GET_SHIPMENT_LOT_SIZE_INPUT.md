# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT

- 실행: 2026-11-20 15:04:00
- 파라미터: `{"p_division_id": "40", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_item_id": "MCCM134010A1", "p_user_id": "bpark416"}`
- 종류: GET
- 입력 인자 원천 없음: p_operation_group=operationList ← popItem.GetOperationList(btnInput_Click:278 · 팝업 SCM0002_ShipmentLotSizePopup 선택 결과) · p_from_site=fromSiteList ← popItem.GetFromSiteList(btnInput_Click:279 · 팝업 SCM0002_ShipmentLotSizePopup 선택 결과) · p_to_site=toSiteList ← popItem.GetToSiteList(btnInput_Click:280 · 팝업 SCM0002_ShipmentLotSizePopup 선택 결과) · 실행 기록 없음(TO-BE sqllog_calls.json PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 호출 0 · 차등 검증 diff_summary SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 0 · AS-IS 실측 Doc/asislive/SCP0028 SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT 0)
- 파라미터 값 미정 — param_defaults.json 또는 golden_cases.csv params 보완 (manual=Y 면 빈값도 의도된 값으로 실행)
