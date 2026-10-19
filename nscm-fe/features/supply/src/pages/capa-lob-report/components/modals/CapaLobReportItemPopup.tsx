import { CapaItemPopup } from 'features/supply/src/components';

import { SHOP_GROUP_ID } from '../../capa-lob-report.constants';
import { useCapaLobReportStore } from '../../useCapaLobReportStore';
import { toStr } from '../../utils/capaLobReport.combos';

interface Props {
  open: boolean;
  onClose: () => void;
}

/**
 * Basic Nickname 팝업 — 도메인 공용 `CapaItemPopup` **얇은 래퍼**(사본·prop 확장 금지, 02 §4.6).
 *
 * AS-IS `btnItemId.Click` -> `ShowItem(_item_id)` -> `pop.Init(true, dtDivision, _division,
 * _shop_group, _item_id)`(cs:1586~1594):
 *   ① `multiSelect = true`  ② Division 콤보 소스  ③ 현재 Division  ④ `_shop_group`(E/A/P)  ⑤ 현재 텍스트
 * 팝업 SP 에는 shop group 파라미터가 없고 팝업이 조회 후 `OPERATION_GROUP` 으로 클라 필터한다 —
 * 그래서 `operationGroup` prop 으로 넘긴다.
 *
 * 반환은 `GetSelectedValuesText("NICK_NAME")` = **`,` join**(distinct·빈값 제외)이고, 선택 0건이면
 * 빈 문자열이라 **기존 값을 유지한다**(덮어쓰지 않음, cs:1606~1611 / 02 V-28).
 * 자매 SCP0105 와 달리 반환 축은 항상 `NICK_NAME` 하나다 — 파라미터가 `p_nick_name` 이고(02 §0 #8)
 * DivisionType 에 따라 `ITEM_ID` 로 갈리는 분기가 이 화면에 없다.
 */
export const CapaLobReportItemPopup = ({ open, onClose }: Props) => {
  const sp = useCapaLobReportStore(state => state.searchParams);
  const setSearchParams = useCapaLobReportStore(state => state.setSearchParams);

  return (
    <CapaItemPopup
      open={open}
      multiSelect
      operationGroup={SHOP_GROUP_ID[sp.divisionType]}
      onClose={onClose}
      // 재오픈 시 직전 검색조건(Division·Nickname)이 유지된다(공통 QA "팝업 재오픈" / 02 V-27).
      params={{ divisionId: sp.divisionId, itemId: sp.nickName }}
      onSelect={(_selected, selectedAll) => {
        // 1번째 인자(첫 행)가 아니라 2번째(전건)를 쓴다 — AS-IS 가 다중선택이다.
        const values = selectedAll
          .map(item => toStr(item.nickName))
          .filter(value => value !== '');
        const picked = Array.from(new Set(values)).join(',');
        if (!picked) return;
        setSearchParams({ nickName: picked });
      }}
    />
  );
};
