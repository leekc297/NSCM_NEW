import {
  ColumnLayoutModal,
  ItemByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import type { ColumnLayoutRow } from '@shared/components';

import { VersionModal } from '../../../components';
import { MENU_ID, SHEETS } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';
import { useSalesReportsStore } from '../useSalesReportsStore';
import { saveTitleSet } from '../utils/sales-reports.api';

import { ExchangeRateModal, MeasureSelectModal, TextboxModal } from './modals';

export type SalesReportsModalKey =
  | 'ITEM'
  | 'COLUMN'
  | 'MEASURE'
  | 'VERSION'
  | 'EXCHANGE'
  | 'TEXTBOX';

interface SalesReportsModalsProps {
  divisionId: string;
  year: string;
  mdfType: string;
  versionNo: string;
  openKey: SalesReportsModalKey | null;
  onClose: () => void;
  // ITEM 셀 팝업 반영 대상 행 (Grid dblclick — 값 '기타매출' 제외)
  itemTargetRow: SalesReportRow | null;
  onVersionSelect: (versionNo: string, label: string) => void;
}

// ⭐ DMF0044 모달 스위치 — United/Exchange/Textbox 전용 3종 + Item(공용)/Column/Measure(공용 승격분).
export const SalesReportsModals = ({
  divisionId,
  year,
  mdfType,
  versionNo,
  openKey,
  onClose,
  itemTargetRow,
  onVersionSelect,
}: SalesReportsModalsProps) => {
  const staticColumns = useSalesReportsStore(s => s.staticColumns);
  const applyColumnLayout = useSalesReportsStore(s => s.applyColumnLayout);
  const userColumnLayout = useSalesReportsStore(s => s.userColumnLayout);

  // ColumnLayoutModal 재진입 복원값 / Default 버튼 기준값 (DMF0003 계약 1:1)
  const labelOf = useMemo(
    () => new Map(staticColumns.map(c => [c.colNm, c.colLblNm ?? c.colNm])),
    [staticColumns]
  );
  const columnLayoutSettings = useMemo<ColumnLayoutRow[]>(
    () =>
      (userColumnLayout ?? []).map(s => ({
        COLUMN_NAME: s.colNm,
        COLUMN_LABEL_NAME: labelOf.get(s.colNm) ?? s.colNm,
        USER_FLAG: s.visible ? 'Y' : 'N',
        SORT_ORDER_NO: s.order,
        COL_WIDTH: s.width,
        CELL_COLOR: s.cellColor,
        TEXT_COLOR: s.textColor,
        isKey: false,
      })),
    [userColumnLayout, labelOf]
  );
  const columnLayoutDefaults = useMemo<ColumnLayoutRow[]>(
    () =>
      staticColumns.map((c, i) => ({
        COLUMN_NAME: c.colNm,
        COLUMN_LABEL_NAME: c.colLblNm ?? c.colNm,
        USER_FLAG: c.visible === false ? 'N' : 'Y',
        SORT_ORDER_NO: i + 1,
        COL_WIDTH: c.colWth ?? 100,
        CELL_COLOR: '',
        TEXT_COLOR: '',
        isKey: false,
      })),
    [staticColumns]
  );
  const applyVisibleMeasures = useSalesReportsStore(s => s.applyVisibleMeasures);
  const staticMeasures = useSalesReportsStore(s => s.staticMeasures);
  const visibleMeasures = useSalesReportsStore(s => s.visibleMeasures);
  const fetchStaticMeasures = useSalesReportsStore(s => s.fetchStaticMeasures);

  return (
    <>
      {/* ITEM_ID 셀 더블클릭 — DM0002_ItembyDivisionPopupEx 대응 (공용 모달 재사용, business-plan 선례) */}
      <ItemByDivisionModal
        open={openKey === 'ITEM'}
        modalClose={onClose}
        setSelectedValue={(
          itemId: string,
          itemName?: string,
          _itemType?: string,
          nickName?: string
        ) => {
          if (itemTargetRow) {
            (itemTargetRow as Record<string, unknown>).ITEM_ID = itemId;
            (itemTargetRow as Record<string, unknown>).NICK_NAME = nickName ?? itemName ?? '';
          }
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            itemId: '',
          } as never
        }
        callFromCell={true}
      />

      {/* ⭐ Column Setting — DMF0003(mkt-fcst) 방식으로 교체 (2026-07-30 사용자 지시).
          공용 ColumnLayoutModal = 표시/순서 + Width/Cell·Text Color 개인화. */}
      <ColumnLayoutModal
        open={openKey === 'COLUMN'}
        modalClose={onClose}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType='C'
        divisionId={divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
        }))}
        title='Column Setting'
        leftTitle='Invisible'
        rightTitle='Visible'
        // 재진입 복원 — 현재 grid 상태(개인화 반영본). 미전달 시 사용자 선택이 원복된다.
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet(
            'C',
            visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          );
          onClose();
        }}
      />

      {/* Measure Select — business-plan 판 복제 (measures/visibleMeasures/onApply 계약) */}
      <MeasureSelectModal
        open={openKey === 'MEASURE'}
        modalClose={onClose}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (ok) void fetchStaticMeasures();
          });
        }}
      />

      {/* Version — DMF0049 와 공유하는 공용 팝업 (AS-IS DMF0044_United_VersionPopup 1본 공유 파리티) */}
      <VersionModal
        open={openKey === 'VERSION'}
        modalClose={onClose}
        menuId={MENU_ID}
        divisionId={divisionId}
        parentReportType={mdfType}
        onSelect={onVersionSelect}
      />

      {/* Exchange Rate — Version 필수 + pending 차단은 부모 게이트 */}
      <ExchangeRateModal
        open={openKey === 'EXCHANGE'}
        modalClose={onClose}
        divisionId={divisionId}
        year={year}
        versionNo={versionNo}
      />

      {/* Textbox — Division 82 전용 */}
      <TextboxModal open={openKey === 'TEXTBOX'} modalClose={onClose} versionNo={versionNo} />
    </>
  );
};
