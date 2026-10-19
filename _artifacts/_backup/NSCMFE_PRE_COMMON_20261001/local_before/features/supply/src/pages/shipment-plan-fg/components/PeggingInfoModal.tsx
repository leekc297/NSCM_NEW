import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';

import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { DIVISION_EE_ONLY_COLUMNS, PEGGING_COLUMNS } from '../shipment-plan-fg.columns';
import { MENU_ID, SHEETS } from '../shipment-plan-fg.constants';
import type { MainColumnMeta, PeggingRow } from '../shipment-plan-fg.types';
import { useShipmentPlanFgStore } from '../useShipmentPlanFgStore';
import { buildColumns } from '../utils/shipment-plan-fg.buildColumns';

interface Props {
  open: boolean;
  modalClose: () => void;
  tabId: string;
  division: string;
}

// 더블클릭 5-가드 통과 후 상세 조회(design 03 §4.5) — 전건 읽기전용(§1.B, §0 INPUT_TP_CD='S').
//   원천 미상 8개 컬럼(design 03 §6#1) — 확인 필요로 남기고 SP 반환분만 채운다.
export const PeggingInfoModal = ({ open, modalClose, tabId, division }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType | null>(null);

  const filters = useShipmentPlanFgStore(s => s.filters[SHEETS.PEGGING]);
  const staticColumns = useShipmentPlanFgStore(s => s.staticColumns[SHEETS.PEGGING]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.PEGGING>({
    menuId: MENU_ID,
    sheetName: SHEETS.PEGGING,
    tabId,
    filters,
    enabled: open && !!filters,
  });
  const rows = useMemo<PeggingRow[]>(() => (data as { o_rc1?: PeggingRow[] })?.o_rc1 ?? [], [data]);
  // division EE* 조건부 visible(gap-resolve iter-1 NEW4 수정) — AS-IS `.cs:729-739`(design 03 §3 R-A)
  //   "메인+Pegging 서브 동일 규칙 반복"을 Main 의 infoColumns 패턴(ShipmentPlanFgGrid.tsx)과 동일하게
  //   이식한다. 이전엔 PEGGING_COLUMNS 정적 상수를 그대로 buildColumns 에 넘겨 division 전환에
  //   반응하지 않았다(항상 visible=true 고정).
  const infoColumns = useMemo<MainColumnMeta[]>(() => {
    const isEE = division.startsWith('EE');
    return PEGGING_COLUMNS.map(c =>
      (DIVISION_EE_ONLY_COLUMNS as readonly string[]).includes(c.key) ? { ...c, visible: isEE } : c
    );
  }, [division]);
  const columns = useMemo(() => buildColumns(infoColumns, staticColumns), [infoColumns, staticColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={1100}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL09996', { defaultValue: 'Pegging Info' })}</h2>
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
              buttonLabel={t('LBL00627', { defaultValue: 'Close' })}
              onClick={modalClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
