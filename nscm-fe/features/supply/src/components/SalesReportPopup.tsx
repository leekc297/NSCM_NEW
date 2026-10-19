import { PlaceholderPopup, type SupplyPopupProps } from './PlaceholderPopup';

// Sales Report 팝업 (스켈레톤).
//   호출 라벨: 세1 — 실제 구현 시 SearchArea + DataGrid + 조회 SP 로 교체한다.
export const SalesReportPopup = (props: SupplyPopupProps) => (
  <PlaceholderPopup title='Sales Report' {...props} />
);
