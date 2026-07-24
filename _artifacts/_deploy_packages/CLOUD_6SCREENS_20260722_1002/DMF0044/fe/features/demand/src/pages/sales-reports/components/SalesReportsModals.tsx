import {
  ColumnSettingModal,
  type ColumnSettingRow,
  ItemByDivisionModal,
} from 'features/master/src/components';

import { MENU_ID, SHEETS } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';
import { useSalesReportsStore } from '../useSalesReportsStore';
import { saveTitleSet } from '../utils/sales-reports.api';
import { toCellStr } from '../utils/sales-reports.gridCombos';

import { ExchangeRateModal, MeasureSelectModal, TextboxModal, UnitedVersionModal } from './modals';

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
  const applyColumnVisibility = useSalesReportsStore(s => s.applyColumnVisibility);
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
        setSelectedValue={(itemId: string, itemName?: string, _itemType?: string, nickName?: string) => {
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

      {/* Column Setting — 공용 (leftTitle/rightTitle 확장판) */}
      <ColumnSettingModal
        open={openKey === 'COLUMN'}
        modalClose={onClose}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType='C'
        divisionId={divisionId}
        title='Column Setting'
        leftTitle='Invisible'
        rightTitle='Visible'
        onSave={(settings: ColumnSettingRow[]) => {
          const keys = settings.map(s => toCellStr((s as Record<string, unknown>).COLUMN_NAME));
          applyColumnVisibility(keys.filter(Boolean));
          void saveTitleSet(
            'C',
            keys.filter(Boolean).map((name, i) => ({ name, sortOrderNo: i + 1 }))
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

      {/* United Version — Version 주입 (btnSPVer '...') */}
      <UnitedVersionModal
        open={openKey === 'VERSION'}
        modalClose={onClose}
        divisionId={divisionId}
        mdfType={mdfType}
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
