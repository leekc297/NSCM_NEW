import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  MSG,
  TITLESET_COLUMN_TYPE,
  type GridSheet,
} from '../../capa-lob-report.constants';
import { useCapaLobReportStore } from '../../useCapaLobReportStore';

interface Props {
  open: boolean;
  onClose: () => void;
  sheetName: GridSheet;
}

/**
 * 컬럼 설정 — 공용 `ColumnLayoutModal` 얇은 래퍼(화면 사본 금지, hook #20/#132 §2-1 / 03 R-15).
 *
 * AS-IS `btnColumn_Click` -> `SCM002_CAPAColumnPopup("SCP0108", _sheet_name, true)`(cs:1614~1623).
 * **`sheetName` 을 반드시 넘긴다** — 빠지면 CURRENT/CUTOFF 개인화가 한 곳에 뭉친다(03 V-36).
 * `divisionId` 는 넘기지 않는다: 컬럼 메타 44행의 `DIVISION_ID` 가 전건 NULL 이라 division 축이 없다.
 *
 * OK 시 AS-IS 는 `BeforeFindData()` 로 **그리드를 비우고 자동 재조회하지 않는다** — 조회는 사용자가
 * 다시 누른다(03 §2.6 / R-16 / V-35 / hook #132 §2-2).
 *
 * 저장은 **서버 영속**이다 — `ColumnLayoutModal` 은 `fetchTitleSet`(조회)만 하고 `SCM_MST_TITLESET_USER`
 * 저장은 호출부 책임이다(iter-1 G-04). AS-IS 는 이 개인화를 실제로 154행 쓰고 있다(CURRENT 88 / CUTOFF 66).
 * 화면 로컬 store 만 갱신하면 탭을 닫는 순간 설정이 사라진다.
 */
export const CapaLobReportColumnModal = ({ open, onClose, sheetName }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const queryClient = useQueryClient();
  const staticColumns = useCapaLobReportStore(state => state.staticColumns);
  const originalStaticColumns = useCapaLobReportStore(state => state.originalStaticColumns);
  const applyColumnLayout = useCapaLobReportStore(state => state.applyColumnLayout);
  const clearFilters = useCapaLobReportStore(state => state.clearFilters);
  const fetchStaticColumns = useCapaLobReportStore(state => state.fetchStaticColumns);

  return (
    <ColumnLayoutModal
      open={open}
      modalClose={onClose}
      menuId={MENU_ID}
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      columnType={TITLESET_COLUMN_TYPE}
      // 폭 0 컬럼은 store 에서 이미 `display:false` 로 내려가 있어 이 목록에 노출되지 않는다(03 V-06).
      fallbackColumns={staticColumns[sheetName].map(column => ({
        key: column.colNm,
        header: column.colLblNm ?? column.colNm,
        width: column.colWth ?? 100,
        display: column.display,
        personalizable: column.personalizable,
      }))}
      title={t('LBL00605', { defaultValue: 'Column Setting' })}
      leftTitle={t('LBL00764', { defaultValue: 'Invisible' })}
      rightTitle={t('LBL00765', { defaultValue: 'Visible' })}
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
        clearFilters();
        /**
         * 서버 영속 — 저장 계약은 **표시 컬럼만** `sortOrderNo` 1..n(행 존재 = 표시, `titleSetApi` 주석).
         * 실패하면 반드시 사용자에게 알린다(`saveTitleSet` 는 boolean 을 돌려준다 — 무시 금지).
         * 전역 `staleTime=Infinity` 라 invalidate 없이는 팝업의 titleSet 재조회가 일어나지 않는다.
         */
        const visible = settings.filter(setting => setting.USER_FLAG === 'Y');
        void saveTitleSet({
          menuId: MENU_ID,
          sheetName: ADMIN_SHEET_NAME[sheetName],
          columnType: TITLESET_COLUMN_TYPE,
          rows: visible.map((setting, index) => ({
            name: setting.COLUMN_NAME,
            sortOrderNo: index + 1,
            colWidth: Number(setting.COL_WIDTH ?? 100),
            cellColor: String(setting.CELL_COLOR ?? ''),
            textColor: String(setting.TEXT_COLOR ?? ''),
          })),
        }).then(ok => {
          if (!ok) {
            void setAlert({
              type: 'alert',
              content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
            });
            return;
          }
          void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          void fetchStaticColumns();
        });
        onClose();
      }}
    />
  );
};
