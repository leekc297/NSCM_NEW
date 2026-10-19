import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';

import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { PROBLEM_COLUMNS } from '../shipment-plan-fg.columns';
import { LBL, MENU_ID, SHEETS } from '../shipment-plan-fg.constants';
import type { ProblemRow } from '../shipment-plan-fg.types';
import { useShipmentPlanFgStore } from '../useShipmentPlanFgStore';
import { buildColumns } from '../utils/shipment-plan-fg.buildColumns';

interface Props {
  open: boolean;
  modalClose: () => void;
  tabId: string;
}

// 더블클릭 5-가드 통과 후 상세 조회(design 03 §4.5) — 전건 읽기전용(§1.C, §0 INPUT_TP_CD='S').
//   원천 미상 6개 컬럼(design 03 §6#2) — 확인 필요로 남기고 SP 반환분만 채운다.
export const PlanProblemModal = ({ open, modalClose, tabId }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType | null>(null);

  const filters = useShipmentPlanFgStore(s => s.filters[SHEETS.PROBLEM]);
  const staticColumns = useShipmentPlanFgStore(s => s.staticColumns[SHEETS.PROBLEM]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.PROBLEM>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROBLEM,
    tabId,
    filters,
    enabled: open && !!filters,
  });
  const rows = useMemo<ProblemRow[]>(() => (data as { o_rc1?: ProblemRow[] })?.o_rc1 ?? [], [data]);
  const columns = useMemo(() => buildColumns(PROBLEM_COLUMNS, staticColumns), [staticColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={900}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL09997', '_Plan Problem')}</h2>
        </div>
      }
      customContentArea={
        <div>
          <ResultArea title='' count={rows.length} gridRef={gridRef as never}>
            <DataGrid
              gridRef={gridRef as never}
              isReadOnly
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={columns}
              allowMerging={AllowMerging.All}
            />
          </ResultArea>
          <Stack direction='row' justifyContent='flex-end' marginTop={1}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
