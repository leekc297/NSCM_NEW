import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LABEL, MENU_ID, SHEETS } from '../../production-plan-line.constants';
import type { LoadRow } from '../../production-plan-line.types';
import { useProductionPlanLineStore } from '../../useProductionPlanLineStore';

interface Props {
  open: boolean;
  modalClose: () => void;
}

// design 01 §P — Load 팝업. 부모 조회조건 주입(setLoadFilter), 완전 읽기전용(col1~ 잠금), Find/Close.
//   반환 컬럼(P_SCP0013_LINE_LOAD_POPUP)은 동적 pivot 포함 — 런타임 확정(design 03 §6 확인필요).
//   최소 식별 컬럼만 정적 표기(자동생성으로 나머지 노출).
const LOAD_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: LABEL.DIVISION, colWth: 70 },
  { colNm: 'SCM_SITE_DESCRIPTION', colLblNm: LABEL.PLANT_SITE, colWth: 120 },
  { colNm: 'LINE_ID', colLblNm: LABEL.LINE, colWth: 90 },
  { colNm: 'ITEM_ID', colLblNm: LABEL.MATERIAL, colWth: 130 },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const ProductionPlanLineLoadModal = ({ open, modalClose }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType<LoadRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const filters = useProductionPlanLineStore(s => s.filters[SHEETS.LOAD]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.LOAD>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOAD,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });
  const rows = useMemo<LoadRow[]>(() => (data as { o_rc1?: LoadRow[] })?.o_rc1 ?? [], [data]);

  // 팝업 그리드는 완전 읽기전용 (design 01 P3 LockColumn(1,maxCol,true) — col0 선택만).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={1000}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{LABEL.LOAD}</h2>
        </div>
      }
      customContentArea={
        <div>
          <ResultArea title='' count={rows.length} gridRef={gridRef as never} gridFilterRef={gridFilterRef}>
            <DataGrid
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
              isReadOnly
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={LOAD_COLUMNS}
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
