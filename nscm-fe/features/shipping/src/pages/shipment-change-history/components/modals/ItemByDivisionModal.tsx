/**
 * SSP0019 Item by Division 선택 팝업 (AS-IS SCM0002_ItembyDivisionPopup, design 02 §4.6 cs:214~233).
 *
 * Model 조회조건 버튼(btnItemId)에서 열리는 품목 선택 팝업. 반환 ITEM_ID -> Model 텍스트(콤마 다중 가능).
 * 팝업 division 파라미터 = 조회조건 Division·From Site(scmSite) 선택값 사전필터(cs:223).
 *
 * 주의: 공용 features/master ItemByDivisionModal 과 겉모습은 같지만 화면 경계(Hard Boundary, convert-core §2.2)상
 *   feature 간 직접 import 를 금지하므로 화면 폴더에 로컬 구성한다(자매 shipment-semi-dept-day 동일 방식).
 * 주의: SCM0002/PKG_SSP0019 팝업 SP 미배포(goal.md ②) -> 조회 런타임 미완. 배선 완비, 실행은 convert-sp 배포 후.
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { LBL, MENU_ID, SHEETS } from '../../shipment-change-history.constants';
import type { PopupRow } from '../../shipment-change-history.types';

import styles from './ItemByDivisionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행 전달 — 부모가 ITEM_ID 추출(Model 텍스트 채움).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 02 §4.6): divisionId(체크 division) / scmSite(From Site) / itemId(Model seed).
  preSearchParams: { divisionId?: string; scmSite?: string; itemId?: string };
}

const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 160, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 140, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Item', colWth: 140, horzAlgnCd: 'L', visible: true, display: true },
];

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [itemId, setItemId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);

  useEffect(() => {
    if (!open) return;
    // 열자마자 컨텍스트로 조회 (design 02 §4.6 — 조회조건 Division/From Site/Model 사전필터).
    setItemId(preSearchParams.itemId ?? '');
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      scmSite: preSearchParams.scmSite ?? '',
      itemId: preSearchParams.itemId ?? '',
    } as unknown as ProcRequest<MENU_ID, SHEETS.POPUP>);
  }, [open, preSearchParams.divisionId, preSearchParams.scmSite, preSearchParams.itemId]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SSP0019_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as unknown as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    setFilters(prev => ({ ...(prev ?? {}), itemId }) as unknown as ProcRequest<MENU_ID, SHEETS.POPUP>);
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as PopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as PopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
  };

  return (
    <CustomDialog
      size={720}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.ITEM_POPUP, '_Item Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t(LBL.MODEL, '_Model')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId}
                        onChange={e => setItemId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                headersVisibility={HeadersVisibility.Column}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t(LBL.OK, '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
