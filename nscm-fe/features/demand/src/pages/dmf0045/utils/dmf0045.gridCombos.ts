// DMF0045 — 셀 편집 후처리 + 셀 팝업 반환 채움 헬퍼.
//   금지: 이 파일에서 DataMap 을 만들어 col.dataMap 에 붙이지 말 것. 셀 콤보(Incoterms/FCST_TYPE)
//   의 후보·표시는 컬럼 메타(cellCboDataTp=SQL_ID)가 단일 원천이고 공용 DataGrid 가 만든다.
//   행 상태로 후보를 더 좁혀야 하면 기존 맵의 getDisplayValues 만 덮는다(ShipmentRequestGrid
//   installMeasureCandidateFilter — MEASURE 재조회형은 division/scmSite 스코프 CMBO).
//
//   셀 팝업 반환값 → 다중 컬럼 채움은 ShipmentRequestModals 가 setSelectedValue 안에서 직접
//   patch 를 조립해 applyToInsertRow 로 반영한다(sales-plan 정본 — 반환 positional 을 화면이
//   바인딩에 매핑). 별도 POPUP_FILL_MAP 헬퍼는 두지 않는다(반환 계약이 모달마다 달라 단일 맵으로
//   접기 어렵고, 채움 로직이 모달과 떨어지면 계약 변경 시 어긋난다).

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
