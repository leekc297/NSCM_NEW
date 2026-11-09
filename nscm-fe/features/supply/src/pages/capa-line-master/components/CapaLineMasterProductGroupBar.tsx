import { useMemo } from 'react';

import { PRODUCT_GROUP, type ProductGroup } from '../capa-line-master.constants';
import { useCapaLineMasterStore } from '../useCapaLineMasterStore';

import styles from './CapaLineMasterProductGroupBar.module.scss';

interface RadioItem {
  value: ProductGroup;
  label: string;
}

// AS-IS SCP0114 의 Product Group(rgrpSearchLevel, Designer.cs:589/597~601)은 상단 조회조건이 아니라
//   Level1~3 그리드와 Level4~5 그리드 사이의 라디오 바다. TO-BE 도 상단 SearchArea 가 아니라 이 자리에
//   둔다(사용자 지시 2026-10-30). 조회조건 영역이 아니므로 SearchArea 같은 회색 박스 스타일을 쓰지 않고,
//   컨트롤은 라디오 버튼으로 재현한다(@shared RadioGroup 미제공 -> 네이티브 radio, 정본 SSP0023 UOM Type).
//   정적 3옵션(SP 없음) -> p_shop_group_id E/A/P, 기본 Electrode. 변경 시 sc.shopGroupId 만 갱신하면
//   CapaLineMaster.tsx effect 가 resetForProductGroup(L4·L5 초기화)을 수행한다(동작 보존). 명시 Search 게이트.
//   바 라벨 = LBL00027 "Operation group" — 이 축은 shop_group(E/A/P)을 가르므로, AS-IS 캡션
//   "Product Group"(LBL00088)이 아니라 자매 SCP0104(Line Assign)의 Operation group 라벨과 통일한다
//   (사용자 확정 2026-11-06). 컴포넌트/파일명은 유지하되 표시 라벨만 교체.
export const CapaLineMasterProductGroupBar = () => {
  const { t } = useTranslation();

  const sc = useCapaLineMasterStore(s => s.searchCondition);
  const setSearchCondition = useCapaLineMasterStore(s => s.setSearchCondition);

  // 'Module/Pack' 은 등가 LBL 미존재(LBL00379 는 'Module' 전용) -> 영문 리터럴 유지(hook #114).
  const items = useMemo<RadioItem[]>(
    () => [
      { value: PRODUCT_GROUP.ELECTRODE, label: t('LBL00038', '_Electrode') },
      { value: PRODUCT_GROUP.CELL, label: t('LBL01059', '_Cell') },
      { value: PRODUCT_GROUP.MODULE_PACK, label: 'Module/Pack' },
    ],
    [t]
  );

  return (
    <div className={styles.productGroupBar}>
      <span className={styles.label}>{t('LBL00027', '_Operation Group')}</span>
      <div className={styles.radioGroup}>
        {items.map(item => (
          <label key={item.value} className={styles.radioOption}>
            <input
              type='radio'
              name='scp0114-product-group'
              value={item.value}
              checked={sc.shopGroupId === item.value}
              onChange={() => setSearchCondition({ shopGroupId: item.value })}
            />
            <span>{item.label}</span>
          </label>
        ))}
      </div>
    </div>
  );
};
