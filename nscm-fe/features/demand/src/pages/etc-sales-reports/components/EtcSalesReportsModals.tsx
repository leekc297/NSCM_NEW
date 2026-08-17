import {
  ColumnLayoutModal,
  ProjectByDivisionModal,
  MeasureSelectModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import type { ColumnLayoutRow } from '@shared/components';

import { VersionModal } from '../../../components';
import { MENU_ID, SHEETS } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow } from '../etc-sales-reports.types';
import { useEtcSalesReportsStore } from '../useEtcSalesReportsStore';
import { saveTitleSet } from '../utils/etc-sales-reports.api';

export type EtcSalesReportsModalKey = 'PROJECT' | 'COLUMN' | 'MEASURE' | 'VERSION';

interface EtcSalesReportsModalsProps {
  divisionId: string;
  mdfType: string;
  openKey: EtcSalesReportsModalKey | null;
  onClose: () => void;
  // Measure 선택 적용 시 Grid 초기화 (조회결과·신규행·편집추적·쿼리캐시 reset — 재조회는 Search 로만).
  //   Column Setting 이 다시 노출되면 그쪽 onSave 에서도 같은 콜백을 호출한다.
  onGridReset: () => void;
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
  onGridReset,
  projectTargetRow,
  onVersionSelect,
}: EtcSalesReportsModalsProps) => {
  const staticColumns = useEtcSalesReportsStore(s => s.staticColumns);
  const applyColumnLayout = useEtcSalesReportsStore(s => s.applyColumnLayout);
  const userColumnLayout = useEtcSalesReportsStore(s => s.userColumnLayout);

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
          // ⭐ [공통 UC-03, hook #132 §2-2] 컬럼 구성이 바뀌면 화면에 남은 결과는 새 구성과
          //   어긋나므로 **그리드를 비운다**(자동 재조회 ⛔ — 재조회는 사용자가 Search 로).
          //   Measure 적용 경로에는 이미 걸려 있었는데 Column 경로만 빠져 있었다(2026-08-15 보완).
          onGridReset();
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
          onGridReset();
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

      {/* Version — DMF0044 와 공유하는 공용 팝업 (AS-IS DMF0044_United_VersionPopup 1본 공유 파리티) */}
      <VersionModal
        open={openKey === 'VERSION'}
        modalClose={onClose}
        menuId={MENU_ID}
        divisionId={divisionId}
        parentReportType={mdfType}
        onSelect={onVersionSelect}
      />
    </>
  );
};
