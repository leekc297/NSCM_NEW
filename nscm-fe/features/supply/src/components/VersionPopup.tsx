import { PlaceholderPopup, type SupplyPopupProps } from './PlaceholderPopup';

// Version 팝업 (스켈레톤).
//   호출 라벨: 버1 / 버2 — 화면별 변형은 variant 로 구분한다.
//   실제 구현 시 SearchArea + DataGrid + 조회 SP 로 교체한다.
export const VersionPopup = (props: SupplyPopupProps) => (
  <PlaceholderPopup title='Version' {...props} />
);
