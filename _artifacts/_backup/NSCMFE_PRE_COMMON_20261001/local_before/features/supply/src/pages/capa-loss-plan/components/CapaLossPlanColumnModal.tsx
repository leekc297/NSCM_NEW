import { ColumnLayoutModal, toColumnLayoutSettings } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  TITLESET_COLUMN_TYPE,
  type GridSheet,
} from '../capa-loss-plan.constants';
import { useCapaLossPlanStore } from '../useCapaLossPlanStore';

interface Props {
  open: boolean;
  onClose: () => void;
  sheetName: GridSheet;
  divisionId: string;
}

/**
 * 컬럼 설정 — 공용 모달 재사용(화면 사본 금지, 03 V-59 / hook #20·#132).
 *
 * AS-IS `new SCM002_CAPAColumnPopup("SCP0106", _sheet_name, true)` 이다.
 * **인자가 `_sheet_name` 8값**인 것이 핵심이다 — 동적 헤더 SP 는 `_sheet_status` 4값을 쓰는데
 * 팝업은 8값을 쓴다. 두 축이 다른 것을 그대로 재현한다(03 §3.3). 4값으로 맞추면 ASSEMBLY/ELTR
 * 개인화가 한 벌로 섞인다.
 *
 * OK -> AS-IS 는 `BeforeFindData()` 로 **헤더 재구성 + 그리드 비움**을 하고 **재조회는 하지 않는다**
 * (V-60). 조회는 사용자가 다시 누른다.
 */
export const CapaLossPlanColumnModal = ({ open, onClose, sheetName, divisionId }: Props) => {
  const { t } = useTranslation();
  const staticColumns = useCapaLossPlanStore(state => state.staticColumns);
  const originalStaticColumns = useCapaLossPlanStore(state => state.originalStaticColumns);
  const applyColumnLayout = useCapaLossPlanStore(state => state.applyColumnLayout);
  const clearFilters = useCapaLossPlanStore(state => state.clearFilters);

  const columns = staticColumns[sheetName] ?? [];
  const originalColumns = originalStaticColumns[sheetName] ?? [];

  return (
    <ColumnLayoutModal
      open={open}
      modalClose={onClose}
      menuId={MENU_ID}
      // 조회·저장·복원 3점이 같은 sheetName/columnType 을 써야 재진입 복원이 맞는다(nscm-patterns §5-9).
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      columnType={TITLESET_COLUMN_TYPE}
      divisionId={divisionId}
      fallbackColumns={columns.map(column => ({
        key: column.colNm,
        header: column.colLblNm ?? column.colNm,
        width: column.colWth ?? 100,
        display: column.display,
        personalizable: column.personalizable,
      }))}
      title={t('LBL00605', { defaultValue: 'Column Setting' })}
      leftTitle={t('LBL00764', { defaultValue: 'Invisible' })}
      rightTitle={t('LBL00765', { defaultValue: 'Visible' })}
      initialSettings={toColumnLayoutSettings(columns)}
      defaultSettings={toColumnLayoutSettings(originalColumns)}
      onSave={settings => {
        applyColumnLayout(
          sheetName,
          settings.map(setting => ({
            colNm: setting.COLUMN_NAME,
            visible: setting.USER_FLAG === 'Y',
            width: Number(setting.COL_WIDTH ?? 100),
            cellColor: String(setting.CELL_COLOR ?? ''),
            textColor: String(setting.TEXT_COLOR ?? ''),
            order: Number(setting.SORT_ORDER_NO ?? 0),
          }))
        );
        // AS-IS 는 설정 확정 후 그리드를 비우고 헤더를 다시 만든다 — 조회는 사용자가 다시 누른다.
        clearFilters();
        onClose();
      }}
    />
  );
};
