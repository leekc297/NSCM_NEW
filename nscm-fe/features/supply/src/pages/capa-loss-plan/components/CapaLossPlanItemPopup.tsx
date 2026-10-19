import { CapaItemPopup } from 'features/supply/src/components';

import { DIVISION_TYPE, SHOP_GROUP_ID } from '../capa-loss-plan.constants';
import { useCapaLossPlanStore } from '../useCapaLossPlanStore';
import { toStr } from '../utils/capaLossPlan.combos';

interface Props {
  open: boolean;
  onClose: () => void;
}

/**
 * Item 팝업 — 도메인 공용 `CapaItemPopup` 재사용(사본 생성 금지, convert-core §2.2).
 *
 * AS-IS `btnItemId_Click`(cs:4337~4345) 은
 * `Init(multiSelect=true, dtDivision, _division, _shop_group, _item_id)` 로 연다 —
 * 그래서 `multiSelect` + `operationGroup` 을 넘긴다. 팝업 SP 에는 shop group 파라미터가 없고
 * AS-IS 도 조회 후 `OPERATION_GROUP IN (...)` 클라 필터를 걸므로 공용 컴포넌트도 클라 필터다(02 §4.6).
 *
 * goal.md BLK-6 은 "`CapaItemPopup` 이 단일선택 + `OPERATION_GROUP` 필터 없음" 을 FAIL 로 적었으나,
 * **이 세션 실측 결과 이미 해소돼 있다** — 자매 SCP0105 전환 때 기본값 보존 prop 2종
 * (`multiSelect = false`, `operationGroup?`)으로 확장됐고 `onSelect` 2번째 인자로 전건을 준다.
 * 따라서 이 화면은 **소비만** 하고 공용 컴포넌트를 건드리지 않는다(Hard Boundary 유지).
 *
 * 반환값은 DivisionType 으로 갈린다: Cell/Module-Pack = `NICK_NAME` / Electrode = `ITEM_ID`.
 * 빈값 제외 + Distinct 후 `,` join 하고, **결과가 비면 기존 값을 유지**한다(AS-IS 동일).
 *
 * 주의(convert-sp 인계): GET SP 는 이 값을 `p_nick_name` -> `A.MDL_NM` 단일 컬럼으로 매칭한다.
 * ELTR 축은 팝업이 `ITEM_ID` 를 주는데 서버는 `MDL_NM` 과 비교하므로 값이 다르면 **Item 조건이
 * 항상 0건**이 된다(goal BLK-15 미검증). 임의 보정하지 않고 AS-IS 그대로 옮겼다.
 */
export const CapaLossPlanItemPopup = ({ open, onClose }: Props) => {
  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaLossPlanStore(state => state.setSearchCondition);

  return (
    <CapaItemPopup
      open={open}
      multiSelect
      operationGroup={SHOP_GROUP_ID[sc.divisionType]}
      onClose={onClose}
      params={{ divisionId: sc.divisionId, itemId: sc.nickName }}
      onSelect={(_selected, selectedAll) => {
        const values = selectedAll
          .map(item =>
            sc.divisionType === DIVISION_TYPE.ELTR ? toStr(item.itemId) : toStr(item.nickName)
          )
          .filter(value => value !== '');
        const picked = Array.from(new Set(values)).join(',');
        if (!picked) return;
        setSearchCondition({ nickName: picked });
      }}
    />
  );
};
