import { CapaItemPopup } from 'features/supply/src/components';

import { DIVISION_TYPE, SHOP_GROUP_ID } from '../capa-speed-plan.constants';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';
import { toStr } from '../utils/capaSpeedPlan.combos';

interface Props {
  open: boolean;
  onClose: () => void;
}

/**
 * Item 팝업 — 도메인 공용 `CapaItemPopup` 재사용(사본 생성 금지, convert-core §2.2).
 * AS-IS `btnItem_Click`(cs:3128~3164)은 `Init(multiSelect=true, dtDivision, _division,
 * _shop_group, _item_id)` 로 연다 — 그래서 `multiSelect` + `operationGroup` 을 넘긴다.
 * 두 prop 은 기본값이 기존 동작(단일선택·필터 없음)이라 SCP0104 호출부는 영향받지 않는다.
 * 반환값은 DivisionType 으로 갈린다: Cell/Module·Pack = NICK_NAME / Electrode = ITEM_ID.
 * AS-IS `GetSelectedValues`(SCM0002:133~148)는 빈값 제외 + **Distinct** 후
 * `string.Join(",")` 한다(cs:150~165) — 중복 토큰이 `p_item_id` 를 불리지 않게 같은 순서로 맞춘다.
 * 빈 결과면 기존 값을 유지한다(AS-IS cs:3138~3164).
 * Page 인라인이던 배선을 분리했다(구조 룰 #9) — 동작은 그대로다.
 */
export const CapaSpeedPlanItemPopup = ({ open, onClose }: Props) => {
  const sc = useCapaSpeedPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaSpeedPlanStore(state => state.setSearchCondition);

  return (
    <CapaItemPopup
      open={open}
      multiSelect
      operationGroup={SHOP_GROUP_ID[sc.divisionType]}
      onClose={onClose}
      params={{ divisionId: sc.divisionId, itemId: sc.itemId }}
      onSelect={(_selected, selectedAll) => {
        const values = selectedAll
          .map(item =>
            sc.divisionType === DIVISION_TYPE.ELTR ? toStr(item.itemId) : toStr(item.nickName)
          )
          .filter(value => value !== '');
        const picked = Array.from(new Set(values)).join(',');
        if (!picked) return;
        setSearchCondition({ itemId: picked });
      }}
    />
  );
};
