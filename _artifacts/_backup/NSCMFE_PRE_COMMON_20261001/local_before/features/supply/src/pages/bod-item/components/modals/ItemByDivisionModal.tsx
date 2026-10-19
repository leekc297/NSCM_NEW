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

import { LBL, MENU_ID, POPUP_SHEET } from '../../bod-item.constants';
import type { ItemPopupRow } from '../../bod-item.types';

import styles from './ItemByDivisionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 선택 행 전달 — btnItemId(다건→ItemID CSV) / 그리드 셀(단건→키 채움) 용도는 부모가 판단. */
  setSelectedValue: (rows: ItemPopupRow[]) => void;
  preSearchParams: { divisionId: string; scmSite: string; itemId: string };
  /** 셀 호출(단건, 헤더 체크박스 없음) vs 버튼 호출(다건 체크). */
  callFromCell: boolean;
}

// AS-IS SCM0002_ItembyDivisionPopup 그리드(02 §4.6) — division/site/item/model/nick.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 70, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE_CODE', colLblNm: 'From Site', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Material', colWth: 110, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 110, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 120, horzAlgnCd: 'L', visible: true, display: true },
];

/**
 * Item-by-division 검색 팝업(로컬) — AS-IS SCM0002_ItembyDivisionPopup(02 §4.6). btnItemId(다건 선택 →
 * 부모가 ItemID CSV 로 조립) + Excluded ITEM_ID 셀 더블클릭(단건) 공용.
 * 주의: 조회 SP(itemPopup)는 PKG_SCP0030 에 미배포(convert-sp 후속) — 배선 완비, 런타임 데이터는 SP 배포 후.
 */
export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ItemPopupRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [keyword, setKeyword] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, typeof POPUP_SHEET.ITEM> | undefined>(
    undefined
  );

  useEffect(() => {
    if (!open) return;
    setKeyword(preSearchParams.itemId ?? '');
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      scmSite: preSearchParams.scmSite ?? '',
      itemId: preSearchParams.itemId ?? '',
    });
  }, [open, preSearchParams.divisionId, preSearchParams.scmSite, preSearchParams.itemId]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, typeof POPUP_SHEET.ITEM>({
    menuId: MENU_ID,
    sheetName: POPUP_SHEET.ITEM,
    tabId: 'SCP0030_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as unknown as ItemPopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', { defaultValue: 'No' })), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    setFilters(prev => ({ ...(prev ?? { divisionId: '', scmSite: '' }), itemId: keyword }));
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as ItemPopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as ItemPopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
  };

  return (
    <CustomDialog
      size={780}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00343', { defaultValue: 'Item by Division' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t(LBL.DIVISION, { defaultValue: 'Division' })}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={preSearchParams.divisionId ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t(LBL.MODEL, { defaultValue: 'Model' })}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={keyword}
                        onChange={e => setKeyword(e.target.value)}
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
              <DataGrid<ItemPopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox={!callFromCell}
                headersVisibility={callFromCell ? HeadersVisibility.Column : HeadersVisibility.All}
                staticColumns={staticColumns}
                itemsSource={rows}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel='OK'
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
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
