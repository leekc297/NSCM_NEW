import {
  ColumnSettingModal,
  type ColumnSettingRow,
  ProjectByDivisionModal,
} from 'features/master/src/components';

import { MENU_ID, SHEETS } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow } from '../etc-sales-reports.types';
import { useEtcSalesReportsStore } from '../useEtcSalesReportsStore';
import { saveTitleSet } from '../utils/etc-sales-reports.api';
import { toCellStr } from '../utils/etc-sales-reports.gridCombos';

import { MeasureSelectModal, UnitedVersionModal } from './modals';

export type EtcSalesReportsModalKey = 'PROJECT' | 'COLUMN' | 'MEASURE' | 'VERSION';

interface EtcSalesReportsModalsProps {
  divisionId: string;
  mdfType: string;
  openKey: EtcSalesReportsModalKey | null;
  onClose: () => void;
  // PROJECT 셀 팝업 반영 대상 행 (Grid dblclick — SCM0002 ETC=true)
  projectTargetRow: EtcSalesReportRow | null;
  onVersionSelect: (versionNo: string, label: string) => void;
}

// ⭐ DMF0049 모달 스위치 — United(공유)/Project(SCM0002 ETC=true)/Column/Measure.
export const EtcSalesReportsModals = ({
  divisionId,
  mdfType,
  openKey,
  onClose,
  projectTargetRow,
  onVersionSelect,
}: EtcSalesReportsModalsProps) => {
  const applyColumnVisibility = useEtcSalesReportsStore(s => s.applyColumnVisibility);
  const applyVisibleMeasures = useEtcSalesReportsStore(s => s.applyVisibleMeasures);
  const staticMeasures = useEtcSalesReportsStore(s => s.staticMeasures);
  const visibleMeasures = useEtcSalesReportsStore(s => s.visibleMeasures);
  const fetchStaticMeasures = useEtcSalesReportsStore(s => s.fetchStaticMeasures);

  return (
    <>
      {/* PROJECT_CODE 셀 더블클릭 — SCM0002_ProjectbyDivisionPopupEx ETC=true 대응 (공용 모달 etc 확장) */}
      <ProjectByDivisionModal
        open={openKey === 'PROJECT'}
        modalClose={onClose}
        setSelectedValue={(projectCode: string, projectName?: string) => {
          if (projectTargetRow) {
            (projectTargetRow as Record<string, unknown>).PROJECT_CODE = projectCode;
            (projectTargetRow as Record<string, unknown>).PROJECT_NAME = projectName ?? '';
          }
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: '',
            etc: 'Y',
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

    </>
  );
};
