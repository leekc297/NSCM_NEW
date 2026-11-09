import { MaterialByDivisionModal } from 'features/master/src/components';

import { MENU_ID } from '../capa-speed-plan.constants';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';

interface Props {
  open: boolean;
  onClose: () => void;
}

/**
 * Model/Nickname 팝업 — 사용자 지시 2026-11-09: SCP0105 Material 조회조건을 SSP0014 Model/Nickname
 * 조회조건으로 교체한다. 종전 도메인 공용 `CapaItemPopup`(SCM0002 CAPA item-by-division)을 공용
 * `MaterialByDivisionModal`(COM0013, PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION, SCP0013/SSP0014 정합)로
 * 대체한다. 팝업 행 선택 결과 ITEM_ID(콤마결합)를 `itemId`(GET p_item_id)로 채우고, 빈 선택이면 기존 입력을
 * 덮지 않는다(SSP0014 파리티). Page(CapaSpeedPlan.tsx) 의 `<CapaSpeedPlanItemPopup open onClose>` 배선은 불변이다.
 */
export const CapaSpeedPlanItemPopup = ({ open, onClose }: Props) => {
  const sc = useCapaSpeedPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaSpeedPlanStore(state => state.setSearchCondition);

  return (
    <MaterialByDivisionModal
      open={open}
      modalClose={onClose}
      setSelectedValue={items => {
        if (items) setSearchCondition({ itemId: items });
      }}
      preSearchParams={{
        divisionId: sc.divisionId,
        scpModuleType: MENU_ID,
        operationGroup: '',
        itemId: sc.itemId,
      }}
    />
  );
};
