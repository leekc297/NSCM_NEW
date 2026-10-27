// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is Spread Expression/계산식 100% 적용 (룰 09) — expressions.md 127건. E-nnn 마커는 게이트(check.js V01)가 센다.
export interface AsisExpressionRule { id: string; asisLine: number; kind: string; apply: () => void; }

export const SHIPMENTPLANMOBILITYIT_EXPRESSIONS: AsisExpressionRule[] = [
  // E-001 [자동동기화/Auto-Sync] L1565 SpdDetail_LeaveCell siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-001', asisLine: 1565, kind: 'SpdDetail_LeaveCell', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-002 [자동동기화/Auto-Sync] L1571 SpdDetail_LeaveCell siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-002', asisLine: 1571, kind: 'SpdDetail_LeaveCell', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-003 [자동동기화/Auto-Sync] L1588 SpdDetail_LeaveCell siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-003', asisLine: 1588, kind: 'SpdDetail_LeaveCell', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-004 [계산식] L1913 EditButton siDetail.USER_MOD_RELEASE_DATE
  //   As-is: "2999-12-31"
  { id: 'E-004', asisLine: 1913, kind: 'EditButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-005 [자동동기화/Auto-Sync] L6289 Validation_Check siDetail.CHANGE_REASON_CODE
  //   As-is: "T07"
  { id: 'E-005', asisLine: 6289, kind: 'Validation_Check', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-006 [자동동기화/Auto-Sync] L6290 Validation_Check siDetail.CHANGE_REASON_DETAIL
  //   As-is: "Default"
  { id: 'E-006', asisLine: 6290, kind: 'Validation_Check', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-007 [자동동기화/Auto-Sync] L7481 shtDetail_Change siDetail.SHIPMENT_DATE
  //   As-is: sNewShipDate
  { id: 'E-007', asisLine: 7481, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-008 [자동동기화/Auto-Sync] L7499 shtDetail_Change siDetail.EDIT_REMARKS
  //   As-is: "Y"
  { id: 'E-008', asisLine: 7499, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-009 [자동동기화/Auto-Sync] L7507 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-009', asisLine: 7507, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-010 [자동동기화/Auto-Sync] L7517 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-010', asisLine: 7517, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-011 [자동동기화/Auto-Sync] L7525 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-011', asisLine: 7525, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-012 [자동동기화/Auto-Sync] L7536 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-012', asisLine: 7536, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-013 [자동동기화/Auto-Sync] L7546 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-013', asisLine: 7546, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-014 [자동동기화/Auto-Sync] L7565 shtDetail_Change siDetail.CHANGE_REASON_DETAIL
  //   As-is: ""
  { id: 'E-014', asisLine: 7565, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-015 [자동동기화/Auto-Sync] L7570 shtDetail_Change siDetail.CHANGE_REASON_DETAIL
  //   As-is: ""
  { id: 'E-015', asisLine: 7570, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-016 [자동동기화/Auto-Sync] L7577 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-016', asisLine: 7577, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-017 [자동동기화/Auto-Sync] L7587 shtDetail_Change siDetail.CHANGE_REASON_CODE
  //   As-is: sNewChangeReasonCode
  { id: 'E-017', asisLine: 7587, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-018 [자동동기화/Auto-Sync] L7588 shtDetail_Change siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-018', asisLine: 7588, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-019 [자동동기화/Auto-Sync] L7589 shtDetail_Change siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-019', asisLine: 7589, kind: 'shtDetail_Change', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-020 [자동동기화/Auto-Sync] L7601 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-020', asisLine: 7601, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-021 [자동동기화/Auto-Sync] L7611 (unknown) siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-021', asisLine: 7611, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-022 [자동동기화/Auto-Sync] L7612 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-022', asisLine: 7612, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-023 [계산식] L7639 InsertRow siDetail.DIVISION_ID
  //   As-is: siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION
  { id: 'E-023', asisLine: 7639, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-024 [계산식] L7640 InsertRow siDetail.FROM_SITE
  //   As-is: siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SIT
  { id: 'E-024', asisLine: 7640, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-025 [계산식] L7641 InsertRow siDetail.FROM_SITE_NM
  //   As-is: siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FROM_SIT
  { id: 'E-025', asisLine: 7641, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-026 [계산식] L7642 InsertRow siDetail.ITEM_ID
  //   As-is: siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID
  { id: 'E-026', asisLine: 7642, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-027 [계산식] L7643 InsertRow siDetail.NICK_NAME
  //   As-is: siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAM
  { id: 'E-027', asisLine: 7643, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-028 [자동동기화/Auto-Sync] L7648 InsertRow siDetail.HOLD_YYYYMMDD
  //   As-is: DateTime.Now.ToShortDateString(
  { id: 'E-028', asisLine: 7648, kind: 'InsertRow', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-029 [자동동기화/Auto-Sync] L8523 SpdDetail_CellClick siDetail.TRANSPORT_MODE
  //   As-is: sTransMode
  { id: 'E-029', asisLine: 8523, kind: 'SpdDetail_CellClick', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-030 [자동동기화/Auto-Sync] L8661 spdDetail_ComboSelChange siDetail.NEW_ROUTE_ID
  //   As-is: sRouteID
  { id: 'E-030', asisLine: 8661, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-031 [자동동기화/Auto-Sync] L8662 spdDetail_ComboSelChange siDetail.NEW_BOD_ID
  //   As-is: sBodID
  { id: 'E-031', asisLine: 8662, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-032 [자동동기화/Auto-Sync] L8663 spdDetail_ComboSelChange siDetail.NEW_INCOTERMS
  //   As-is: sIncoterms
  { id: 'E-032', asisLine: 8663, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-033 [자동동기화/Auto-Sync] L8664 spdDetail_ComboSelChange siDetail.NEW_D_COUNTRY
  //   As-is: sDCountry
  { id: 'E-033', asisLine: 8664, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-034 [자동동기화/Auto-Sync] L8665 spdDetail_ComboSelChange siDetail.NEW_D_PORT_CODE
  //   As-is: sDPortCode
  { id: 'E-034', asisLine: 8665, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-035 [자동동기화/Auto-Sync] L8666 spdDetail_ComboSelChange siDetail.NEW_A_COUNTRY
  //   As-is: sACountry
  { id: 'E-035', asisLine: 8666, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-036 [자동동기화/Auto-Sync] L8667 spdDetail_ComboSelChange siDetail.NEW_A_PORT_CODE
  //   As-is: sAPortCode
  { id: 'E-036', asisLine: 8667, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-037 [자동동기화/Auto-Sync] L8668 spdDetail_ComboSelChange siDetail.NEW_TO_COUNTRY
  //   As-is: sToCountry
  { id: 'E-037', asisLine: 8668, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-038 [자동동기화/Auto-Sync] L8669 spdDetail_ComboSelChange siDetail.NEW_TO_CITY
  //   As-is: sToCity
  { id: 'E-038', asisLine: 8669, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-039 [자동동기화/Auto-Sync] L8670 spdDetail_ComboSelChange siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-039', asisLine: 8670, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-040 [자동동기화/Auto-Sync] L8671 spdDetail_ComboSelChange siDetail.NEW_LT_DAY
  //   As-is: dLT
  { id: 'E-040', asisLine: 8671, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-041 [자동동기화/Auto-Sync] L8672 spdDetail_ComboSelChange siDetail.NEW_CUSTOMER_LT
  //   As-is: dLT
  { id: 'E-041', asisLine: 8672, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-042 [자동동기화/Auto-Sync] L8673 spdDetail_ComboSelChange siDetail.NEW_TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-042', asisLine: 8673, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-043 [자동동기화/Auto-Sync] L8674 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-043', asisLine: 8674, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-044 [자동동기화/Auto-Sync] L8684 spdDetail_ComboSelChange siDetail.TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-044', asisLine: 8684, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-045 [자동동기화/Auto-Sync] L8686 spdDetail_ComboSelChange siDetail.NEW_ROUTE_ID
  //   As-is: sRouteID
  { id: 'E-045', asisLine: 8686, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-046 [자동동기화/Auto-Sync] L8687 spdDetail_ComboSelChange siDetail.NEW_BOD_ID
  //   As-is: sBodID
  { id: 'E-046', asisLine: 8687, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-047 [자동동기화/Auto-Sync] L8688 spdDetail_ComboSelChange siDetail.NEW_INCOTERMS
  //   As-is: sIncoterms
  { id: 'E-047', asisLine: 8688, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-048 [자동동기화/Auto-Sync] L8689 spdDetail_ComboSelChange siDetail.NEW_D_COUNTRY
  //   As-is: sDCountry
  { id: 'E-048', asisLine: 8689, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-049 [자동동기화/Auto-Sync] L8690 spdDetail_ComboSelChange siDetail.NEW_D_PORT_CODE
  //   As-is: sDPortCode
  { id: 'E-049', asisLine: 8690, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-050 [자동동기화/Auto-Sync] L8691 spdDetail_ComboSelChange siDetail.NEW_A_COUNTRY
  //   As-is: sACountry
  { id: 'E-050', asisLine: 8691, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-051 [자동동기화/Auto-Sync] L8692 spdDetail_ComboSelChange siDetail.NEW_A_PORT_CODE
  //   As-is: sAPortCode
  { id: 'E-051', asisLine: 8692, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-052 [자동동기화/Auto-Sync] L8693 spdDetail_ComboSelChange siDetail.NEW_TO_COUNTRY
  //   As-is: sToCountry
  { id: 'E-052', asisLine: 8693, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-053 [자동동기화/Auto-Sync] L8694 spdDetail_ComboSelChange siDetail.NEW_TO_CITY
  //   As-is: sToCity
  { id: 'E-053', asisLine: 8694, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-054 [자동동기화/Auto-Sync] L8695 spdDetail_ComboSelChange siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-054', asisLine: 8695, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-055 [자동동기화/Auto-Sync] L8696 spdDetail_ComboSelChange siDetail.NEW_LT_DAY
  //   As-is: dLT
  { id: 'E-055', asisLine: 8696, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-056 [자동동기화/Auto-Sync] L8697 spdDetail_ComboSelChange siDetail.NEW_CUSTOMER_LT
  //   As-is: dLT
  { id: 'E-056', asisLine: 8697, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-057 [자동동기화/Auto-Sync] L8698 spdDetail_ComboSelChange siDetail.NEW_TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-057', asisLine: 8698, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-058 [자동동기화/Auto-Sync] L8699 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-058', asisLine: 8699, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-059 [자동동기화/Auto-Sync] L8710 spdDetail_ComboSelChange siMain.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-059', asisLine: 8710, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-060 [자동동기화/Auto-Sync] L8722 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "N"
  { id: 'E-060', asisLine: 8722, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-061 [자동동기화/Auto-Sync] L8723 spdDetail_ComboSelChange siDetail.CHANGE_REASON_DETAIL
  //   As-is: ""
  { id: 'E-061', asisLine: 8723, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-062 [자동동기화/Auto-Sync] L8728 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-062', asisLine: 8728, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-063 [자동동기화/Auto-Sync] L8742 spdDetail_ComboSelChange siDetail.CHANGE_REASON_CODE
  //   As-is: sNewChangeReasonCode
  { id: 'E-063', asisLine: 8742, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-064 [자동동기화/Auto-Sync] L8743 spdDetail_ComboSelChange siDetail.CHANGE_REASON_DETAIL
  //   As-is: ""
  { id: 'E-064', asisLine: 8743, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-065 [자동동기화/Auto-Sync] L8744 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "N"
  { id: 'E-065', asisLine: 8744, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-066 [자동동기화/Auto-Sync] L8749 spdDetail_ComboSelChange siDetail.CHANGE_REASON_CODE
  //   As-is: sNewChangeReasonCode
  { id: 'E-066', asisLine: 8749, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-067 [자동동기화/Auto-Sync] L8750 spdDetail_ComboSelChange siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-067', asisLine: 8750, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-068 [자동동기화/Auto-Sync] L8751 spdDetail_ComboSelChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-068', asisLine: 8751, kind: 'spdDetail_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-069 [자동동기화/Auto-Sync] L8794 SpdDetail_EditChange siDetail.NEW_ETD
  //   As-is: sDate
  { id: 'E-069', asisLine: 8794, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-070 [자동동기화/Auto-Sync] L8795 SpdDetail_EditChange siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-070', asisLine: 8795, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-071 [자동동기화/Auto-Sync] L8796 SpdDetail_EditChange siDetail.NEW_SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-071', asisLine: 8796, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-072 [자동동기화/Auto-Sync] L8797 SpdDetail_EditChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-072', asisLine: 8797, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-073 [자동동기화/Auto-Sync] L8807 SpdDetail_EditChange siDetail.SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-073', asisLine: 8807, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-074 [자동동기화/Auto-Sync] L8810 SpdDetail_EditChange siDetail.NEW_ETD
  //   As-is: sDate
  { id: 'E-074', asisLine: 8810, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-075 [자동동기화/Auto-Sync] L8811 SpdDetail_EditChange siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-075', asisLine: 8811, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-076 [자동동기화/Auto-Sync] L8812 SpdDetail_EditChange siDetail.NEW_SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-076', asisLine: 8812, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-077 [자동동기화/Auto-Sync] L8813 SpdDetail_EditChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-077', asisLine: 8813, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-078 [자동동기화/Auto-Sync] L8842 SpdDetail_EditChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-078', asisLine: 8842, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-079 [자동동기화/Auto-Sync] L8852 SpdDetail_EditChange siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-079', asisLine: 8852, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-080 [자동동기화/Auto-Sync] L8854 SpdDetail_EditChange siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-080', asisLine: 8854, kind: 'SpdDetail_EditChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-081 [자동동기화/Auto-Sync] L8932 SpdDetail_ClipboardPasted siDetail.NEW_ROUTE_ID
  //   As-is: sRouteID
  { id: 'E-081', asisLine: 8932, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-082 [자동동기화/Auto-Sync] L8933 SpdDetail_ClipboardPasted siDetail.NEW_BOD_ID
  //   As-is: sBodID
  { id: 'E-082', asisLine: 8933, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-083 [자동동기화/Auto-Sync] L8934 SpdDetail_ClipboardPasted siDetail.NEW_INCOTERMS
  //   As-is: sIncoterms
  { id: 'E-083', asisLine: 8934, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-084 [자동동기화/Auto-Sync] L8935 SpdDetail_ClipboardPasted siDetail.NEW_D_COUNTRY
  //   As-is: sDCountry
  { id: 'E-084', asisLine: 8935, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-085 [자동동기화/Auto-Sync] L8936 SpdDetail_ClipboardPasted siDetail.NEW_D_PORT_CODE
  //   As-is: sDPortCode
  { id: 'E-085', asisLine: 8936, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-086 [자동동기화/Auto-Sync] L8937 SpdDetail_ClipboardPasted siDetail.NEW_A_COUNTRY
  //   As-is: sACountry
  { id: 'E-086', asisLine: 8937, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-087 [자동동기화/Auto-Sync] L8938 SpdDetail_ClipboardPasted siDetail.NEW_A_PORT_CODE
  //   As-is: sAPortCode
  { id: 'E-087', asisLine: 8938, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-088 [자동동기화/Auto-Sync] L8939 SpdDetail_ClipboardPasted siDetail.NEW_TO_COUNTRY
  //   As-is: sToCountry
  { id: 'E-088', asisLine: 8939, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-089 [자동동기화/Auto-Sync] L8940 SpdDetail_ClipboardPasted siDetail.NEW_TO_CITY
  //   As-is: sToCity
  { id: 'E-089', asisLine: 8940, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-090 [자동동기화/Auto-Sync] L8941 SpdDetail_ClipboardPasted siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-090', asisLine: 8941, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-091 [자동동기화/Auto-Sync] L8942 SpdDetail_ClipboardPasted siDetail.NEW_LT_DAY
  //   As-is: dLT
  { id: 'E-091', asisLine: 8942, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-092 [자동동기화/Auto-Sync] L8943 SpdDetail_ClipboardPasted siDetail.NEW_TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-092', asisLine: 8943, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-093 [자동동기화/Auto-Sync] L8944 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-093', asisLine: 8944, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-094 [자동동기화/Auto-Sync] L8954 SpdDetail_ClipboardPasted siDetail.TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-094', asisLine: 8954, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-095 [자동동기화/Auto-Sync] L8956 SpdDetail_ClipboardPasted siDetail.NEW_ROUTE_ID
  //   As-is: sRouteID
  { id: 'E-095', asisLine: 8956, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-096 [자동동기화/Auto-Sync] L8957 SpdDetail_ClipboardPasted siDetail.NEW_BOD_ID
  //   As-is: sBodID
  { id: 'E-096', asisLine: 8957, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-097 [자동동기화/Auto-Sync] L8958 SpdDetail_ClipboardPasted siDetail.NEW_INCOTERMS
  //   As-is: sIncoterms
  { id: 'E-097', asisLine: 8958, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-098 [자동동기화/Auto-Sync] L8959 SpdDetail_ClipboardPasted siDetail.NEW_D_COUNTRY
  //   As-is: sDCountry
  { id: 'E-098', asisLine: 8959, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-099 [자동동기화/Auto-Sync] L8960 SpdDetail_ClipboardPasted siDetail.NEW_D_PORT_CODE
  //   As-is: sDPortCode
  { id: 'E-099', asisLine: 8960, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-100 [자동동기화/Auto-Sync] L8961 SpdDetail_ClipboardPasted siDetail.NEW_A_COUNTRY
  //   As-is: sACountry
  { id: 'E-100', asisLine: 8961, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-101 [자동동기화/Auto-Sync] L8962 SpdDetail_ClipboardPasted siDetail.NEW_A_PORT_CODE
  //   As-is: sAPortCode
  { id: 'E-101', asisLine: 8962, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-102 [자동동기화/Auto-Sync] L8963 SpdDetail_ClipboardPasted siDetail.NEW_TO_COUNTRY
  //   As-is: sToCountry
  { id: 'E-102', asisLine: 8963, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-103 [자동동기화/Auto-Sync] L8964 SpdDetail_ClipboardPasted siDetail.NEW_TO_CITY
  //   As-is: sToCity
  { id: 'E-103', asisLine: 8964, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-104 [자동동기화/Auto-Sync] L8965 SpdDetail_ClipboardPasted siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-104', asisLine: 8965, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-105 [자동동기화/Auto-Sync] L8966 SpdDetail_ClipboardPasted siDetail.NEW_LT_DAY
  //   As-is: dLT
  { id: 'E-105', asisLine: 8966, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-106 [자동동기화/Auto-Sync] L8967 SpdDetail_ClipboardPasted siDetail.NEW_TRANSPORT_MODE
  //   As-is: sNewTransMode
  { id: 'E-106', asisLine: 8967, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-107 [자동동기화/Auto-Sync] L8968 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-107', asisLine: 8968, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-108 [자동동기화/Auto-Sync] L9007 SpdDetail_ClipboardPasted siDetail.SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-108', asisLine: 9007, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-109 [자동동기화/Auto-Sync] L9008 SpdDetail_ClipboardPasted siDetail.NEW_ETD
  //   As-is: sDate
  { id: 'E-109', asisLine: 9008, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-110 [자동동기화/Auto-Sync] L9009 SpdDetail_ClipboardPasted siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-110', asisLine: 9009, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-111 [자동동기화/Auto-Sync] L9010 SpdDetail_ClipboardPasted siDetail.NEW_SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-111', asisLine: 9010, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-112 [자동동기화/Auto-Sync] L9011 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-112', asisLine: 9011, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-113 [자동동기화/Auto-Sync] L9021 SpdDetail_ClipboardPasted siDetail.SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-113', asisLine: 9021, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-114 [자동동기화/Auto-Sync] L9023 SpdDetail_ClipboardPasted siDetail.NEW_ETD
  //   As-is: sDate
  { id: 'E-114', asisLine: 9023, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-115 [자동동기화/Auto-Sync] L9024 SpdDetail_ClipboardPasted siDetail.NEW_ETA
  //   As-is: sEta
  { id: 'E-115', asisLine: 9024, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-116 [자동동기화/Auto-Sync] L9025 SpdDetail_ClipboardPasted siDetail.NEW_SHIPMENT_DATE
  //   As-is: sDate
  { id: 'E-116', asisLine: 9025, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-117 [자동동기화/Auto-Sync] L9026 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-117', asisLine: 9026, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-118 [자동동기화/Auto-Sync] L9034 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-118', asisLine: 9034, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-119 [자동동기화/Auto-Sync] L9040 SpdDetail_ClipboardPasted siDetail.EDIT_REMARKS
  //   As-is: "Y"
  { id: 'E-119', asisLine: 9040, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-120 [자동동기화/Auto-Sync] L9041 SpdDetail_ClipboardPasted siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-120', asisLine: 9041, kind: 'SpdDetail_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-121 [자동동기화/Auto-Sync] L9067 (unknown) siMain.CHANGE_REASON_CODE
  //   As-is: sNewChangeReasonCode
  { id: 'E-121', asisLine: 9067, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-122 [자동동기화/Auto-Sync] L9068 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-122', asisLine: 9068, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-123 [자동동기화/Auto-Sync] L9081 (unknown) siDetail.CHANGE_REASON_CODE
  //   As-is: sNewChangeReasonCode
  { id: 'E-123', asisLine: 9081, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-124 [자동동기화/Auto-Sync] L9082 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-124', asisLine: 9082, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-125 [자동동기화/Auto-Sync] L9096 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-125', asisLine: 9096, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-126 [자동동기화/Auto-Sync] L9107 (unknown) siDetail.CHANGE_REASON_DETAIL
  //   As-is: sNewChangeReasonDetail
  { id: 'E-126', asisLine: 9107, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-127 [자동동기화/Auto-Sync] L9109 (unknown) siDetail.EDIT_MAIN
  //   As-is: "Y"
  { id: 'E-127', asisLine: 9109, kind: '(unknown)', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
];
