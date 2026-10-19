import { PlaceholderPopup, type SupplyPopupProps } from './PlaceholderPopup';

// Owner by Division 팝업 (스켈레톤).
//   호출 라벨: 오1 — 실제 구현 시 SearchArea + DataGrid + 조회 SP 로 교체한다.
export const OwnerByDivisionPopup = (props: SupplyPopupProps) => (
  <PlaceholderPopup title='Owner by Division' {...props} />
);
