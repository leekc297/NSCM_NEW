import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  MSG,
  TITLESET_COLUMN_TYPE,
  type GridSheet,
} from '../../capa-teep-report.constants';
import { useCapaTeepReportStore } from '../../useCapaTeepReportStore';

interface Props {
  open: boolean;
  onClose: () => void;
  sheetName: GridSheet;
}

/**
 * 컬럼 설정 — 공용 `ColumnLayoutModal` 얇은 래퍼(**화면 사본 금지**, hook #20/#132 §2-1 / 03 V-33).
 *
 * AS-IS `btnColumn_Click` -> `SCM002_CAPAColumnPopup("SCP0107", _division_type_name, true)`(cs:1767).
 * **`sheetName` 을 반드시 넘긴다** — AS-IS 팝업 인자가 `_division_type_name`(ASSEMBLY/ELTR)이라 시트마다
 * 개인화가 따로다(03 §0.2). 빠지면 두 시트 설정이 한 곳에 뭉친다.
 * `divisionId` 는 넘기지 않는다: 컬럼 메타 50행의 `DIVISION_ID` 가 전건 NULL 이라 division 축이 없다.
 *
 * 선택 목록은 **ASSEMBLY 12 / ELTR 11** 이고 해제 불가(`USER_SELECTABLE_FLAG='N'`)가 3 / 1 이다
 * (03 §0.2 / §1.3 / V-33). 폭 0·`VISIBLE_FLAG='N'` 컬럼은 store 에서 이미 `display:false` 로 내려가
 * 이 목록에 노출되지 않는다.
 *
 * OK 시 AS-IS 는 `BeforeFindData()` 로 **그리드를 비우고 자동 재조회하지 않는다** — 조회는 사용자가
 * 다시 누른다(03 §2.5 #5 / V-34 / hook #132 §2-2).
 *
 * 저장은 **서버 영속**이다 — `ColumnLayoutModal` 은 조회(`fetchTitleSet`)만 하고
 * `SCM_MST_TITLESET_USER` 저장은 호출부 책임이다(자매 SCP0108 iter-1 G-04). AS-IS 는 이 개인화를 실제로
 * 283행 쓰고 있다(ASSEMBLY 161 / ELTR 122, 03 §0.2) — 화면 로컬 store 만 갱신하면 탭을 닫는 순간 사라진다.
 * TO-BE 는 SCP0107분 0행이라 최초 오픈 시 seeding 되는 정상 상태다(goal D-9 = 기존 user 행 이관 여부는
 * 사용자 결정이며 설계·전환 단계 INSERT 금지).
 */
export const CapaTeepReportColumnModal = ({ open, onClose, sheetName }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const queryClient = useQueryClient();
  const staticColumns = useCapaTeepReportStore(state => state.staticColumns);
  const originalStaticColumns = useCapaTeepReportStore(state => state.originalStaticColumns);
  const applyColumnLayout = useCapaTeepReportStore(state => state.applyColumnLayout);
  const clearFilters = useCapaTeepReportStore(state => state.clearFilters);
  const fetchStaticColumns = useCapaTeepReportStore(state => state.fetchStaticColumns);

  return (
    <ColumnLayoutModal
      open={open}
      modalClose={onClose}
      menuId={MENU_ID}
      // 조회·저장·복원 3점이 같은 sheetName/columnType 을 써야 재진입 복원이 맞는다(nscm-patterns §5-9).
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      columnType={TITLESET_COLUMN_TYPE}
      fallbackColumns={staticColumns[sheetName].map(column => ({
        key: column.colNm,
        header: column.colLblNm ?? column.colNm,
        width: column.colWth ?? 100,
        display: column.display,
        // `USER_SELECTABLE_FLAG='N'` -> 해제 불가(ASSEMBLY `OPERATION_NAME`/`ELTR_LN_TP_CD`/
        //   `MEASURE_NAME` 3건 / ELTR `MEASURE_NAME` 1건, 03 §0.2 실측).
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
        // AS-IS `BeforeFindData()` — 그리드를 비우고 헤더를 다시 만든다. 자동 재조회는 없다.
        clearFilters();
        /**
         * 서버 영속 — 저장 계약은 **표시 컬럼만** `sortOrderNo` 1..n(행 존재 = 표시).
         * 실패하면 반드시 알린다(`saveTitleSet` 는 boolean 을 돌려준다 — 무시 금지).
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
              content: t(MSG.SAVE_FAIL, '_Failed to save.'),
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
