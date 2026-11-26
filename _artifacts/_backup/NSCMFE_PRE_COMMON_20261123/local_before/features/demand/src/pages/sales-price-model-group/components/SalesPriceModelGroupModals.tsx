import type { FlexGrid } from '@mescius/wijmo.grid';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, isInsertRow } from '@foundation/utils';
import { type ColumnLayoutRow, ColumnLayoutModal, saveTitleSet } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from '../sales-price-model-group.constants';
import type { ModelGroupRow } from '../sales-price-model-group.types';
import { cellOf, modelGroupsOf, sameBundle } from '../utils/sales-price-model-group.util';

import { ExchangeRateModal } from './modals/ExchangeRateModal';
import { PriceBatchInputModal } from './modals/PriceBatchInputModal';

// 팝업마다 열림 상태를 따로 둔다(POP-10).
interface ModalSwitch {
  open: boolean;
  close: () => void;
}

interface Props {
  columnSetting: ModalSwitch;
  priceBatch: ModalSwitch;
  exchangeRate: ModalSwitch;
  projectCell: ModalSwitch;
  itemCell: ModalSwitch;
  popupRow: ModelGroupRow | null;
  gridRef: MutableRefObject<FlexGrid<ModelGroupRow> | null>;
  editTrackerRef: MutableRefObject<EditTracker<ModelGroupRow> | undefined>;
  divisionId: string;
  mainFromYyyymmdd: string;
  mainToYyyymmdd: string;
  endCustomers: string[];
  staticColumns: RawFlexGridColumnConfig[];
  originalStaticColumns: RawFlexGridColumnConfig[];
  onColumnSettingSaved: () => void;
  onBatchSaved: () => void;
}

// ColumnLayoutModal 행 — 표시 여부는 그리드와 같은 visible 기준.
const toLayoutRows = (cols: RawFlexGridColumnConfig[]): ColumnLayoutRow[] =>
  cols.map((c, i) => {
    const label = c.colLblNm ?? c.colNm;
    return {
      COLUMN_NAME: c.colNm,
      COLUMN_LABEL_NAME: label,
      USER_FLAG: c.visible === false ? 'N' : 'Y',
      SORT_ORDER_NO: i + 1,
      COL_WIDTH: c.colWth ?? 100,
      CELL_COLOR: c.cellColor ?? '',
      TEXT_COLOR: c.textColor ?? '',
      isKey: label.trim().endsWith('*'),
    };
  });

// 화면 팝업 모음 — Column Setting(공용), 셀 팝업 Project(COM0005) · Model Group(COM0008), Price Batch Input · Exchange Rate(전용).
export const SalesPriceModelGroupModals = ({
  columnSetting,
  priceBatch,
  exchangeRate,
  projectCell,
  itemCell,
  popupRow,
  gridRef,
  editTrackerRef,
  divisionId,
  mainFromYyyymmdd,
  mainToYyyymmdd,
  endCustomers,
  staticColumns,
  originalStaticColumns,
  onColumnSettingSaved,
  onBatchSaved,
}: Props) => {
  const { t } = useTranslation();

  // Exchange Rate 팝업 기본 기간 = 메인 조회 기간의 연월 (원천 DMF0020 과 같음).
  const exchangePeriod = useMemo(
    () => ({ start: mainFromYyyymmdd.slice(0, 6), end: mainToYyyymmdd.slice(0, 6) }),
    [mainFromYyyymmdd, mainToYyyymmdd]
  );

  // 셀 팝업 선택 → 같은 신규 묶음 3행에 값을 넣는다(POP-11: 칸마다 storeChange 후 대입, 신규 행만).
  const applyToBundle = (values: Record<string, string>) => {
    const g = gridRef.current;
    if (!g || !popupRow || !isInsertRow(popupRow)) return;
    for (const item of g.collectionView.items) {
      if (!sameBundle(item, popupRow)) continue;
      for (const [binding, value] of Object.entries(values)) {
        editTrackerRef.current?.storeChange(item, binding, item[binding], value);
        item[binding] = value;
      }
    }
    g.invalidate(true);
  };

  // 팝업 조건 = 누른 행의 상위 칸 값 (POP-09 셀 호출).
  const cellPreSearch = useMemo(
    () => ({
      divisionId: cellOf(popupRow ?? undefined, 'DIVISION_ID') || divisionId,
      deptId: 'ALL',
      endCustomer: cellOf(popupRow ?? undefined, 'END_CUSTOMER') || 'ALL',
      salesSite: cellOf(popupRow ?? undefined, 'SCM_SITE_ID') || 'ALL',
      projectCode: cellOf(popupRow ?? undefined, 'PROJECT_CODE'),
    }),
    [popupRow, divisionId]
  );

  return (
    <>
      <ColumnLayoutModal
        open={columnSetting.open}
        modalClose={columnSetting.close}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={divisionId}
        initialSettings={toLayoutRows(staticColumns)}
        defaultSettings={toLayoutRows(originalStaticColumns)}
        onSave={settings => {
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              void useMessageStore
                .getState()
                .setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_저장 중 오류가 발생했습니다.') });
              return;
            }
            onColumnSettingSaved();
          });
        }}
      />

      <ProjectByDivisionModal
        open={projectCell.open}
        modalClose={projectCell.close}
        setSelectedValue={(projectCode, projectName) =>
          // Project 를 바꾸면 Model Group · Team 은 옛 Project 기준이라 비운다(설계서 R48).
          applyToBundle({
            PROJECT_CODE: projectCode?.split(',')[0] ?? '',
            PROJECT_NAME: projectName ?? '',
            MDL_GR: '',
            DEPT_ID: '',
          })
        }
        preSearchParams={{ ...cellPreSearch, etc: 'N' } as never}
        callFromCell={false}
      />

      <ItemByDivisionModal
        open={itemCell.open}
        modalClose={itemCell.close}
        setSelectedValue={(itemIds, _name, _class, _nick, _type, deptId) =>
          // 고른 Model 의 Model Group(앞 12자리)과 Team(SCM_MST_SITE_ITEM.DEPT_ID)을 넣는다(설계서 R45 · I50).
          applyToBundle({ MDL_GR: modelGroupsOf(itemIds)[0] ?? '', DEPT_ID: deptId ?? '' })
        }
        preSearchParams={{ ...cellPreSearch, itemId: '' } as never}
        callFromCell={false}
      />

      <PriceBatchInputModal
        open={priceBatch.open}
        modalClose={priceBatch.close}
        divisionId={divisionId}
        mainFromYyyymmdd={mainFromYyyymmdd}
        endCustomers={endCustomers}
        onSaved={onBatchSaved}
      />

      <ExchangeRateModal
        open={exchangeRate.open}
        modalClose={exchangeRate.close}
        divisionId={divisionId}
        defaultPeriod={exchangePeriod}
      />
    </>
  );
};
