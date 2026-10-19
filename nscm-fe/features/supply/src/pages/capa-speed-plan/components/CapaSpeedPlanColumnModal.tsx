import { ColumnLayoutModal, toColumnLayoutSettings } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  TITLESET_COLUMN_TYPE,
  type GridSheet,
} from '../capa-speed-plan.constants';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';

interface Props {
  open: boolean;
  onClose: () => void;
  sheetName: GridSheet;
  divisionId: string;
}

/**
 * 컬럼 설정 — 공용 모달 재사용(화면 사본 금지). `sheetName` 을 넘겨야 ASSEMBLY/ELTR 설정이
 * 섞이지 않는다(03 §3.3). OK 시 AS-IS 는 `BeforeFindData()` 로 시트를 비우고 헤더를 재구성한다.
 * Page 인라인이던 배선을 분리했다(구조 룰 #9) — 동작은 그대로다.
 */
export const CapaSpeedPlanColumnModal = ({ open, onClose, sheetName, divisionId }: Props) => {
  const { t } = useTranslation();
  const staticColumns = useCapaSpeedPlanStore(state => state.staticColumns);
  const originalStaticColumns = useCapaSpeedPlanStore(state => state.originalStaticColumns);
  const applyColumnLayout = useCapaSpeedPlanStore(state => state.applyColumnLayout);
  const clearFilters = useCapaSpeedPlanStore(state => state.clearFilters);

  return (
    <ColumnLayoutModal
      open={open}
      modalClose={onClose}
      menuId={MENU_ID}
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      columnType={TITLESET_COLUMN_TYPE}
      divisionId={divisionId}
      fallbackColumns={staticColumns[sheetName].map(column => ({
        key: column.colNm,
        header: column.colLblNm ?? column.colNm,
        width: column.colWth ?? 100,
        display: column.display,
        personalizable: column.personalizable,
      }))}
      title={t('LBL00605', '_Column Setting')}
      leftTitle={t('LBL00764', '_Invisible')}
      rightTitle={t('LBL00765', '_Visible')}
      initialSettings={toColumnLayoutSettings(staticColumns[sheetName])}
      defaultSettings={toColumnLayoutSettings(originalStaticColumns[sheetName])}
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
