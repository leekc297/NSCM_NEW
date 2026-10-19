import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { t } from '@foundation/i18n';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MENU_ID, POPUP_SHEETS } from '../../group-user.constants';
import type { DivisionPopupRow } from '../../group-user.types';

import styles from './DivisionModal.module.scss';
import { useDivisionModalStore } from './divisionModalStore';

interface Props {
  open: boolean;
  onClose: () => void;
  onSelect: (divisionList: DivisionPopupRow[]) => void;
}

export const DivisionModal = ({ open, onClose, onSelect }: Props) => {
  const [searchText, setSearchText] = useState<string>('');

  const gridRef = useRef<FlexGrid<DivisionPopupRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useDivisionModalStore(state => state.filters);
  const setFilters = useDivisionModalStore(state => state.setFilters);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, POPUP_SHEETS.DIVISION_POPUP>({
    menuId: MENU_ID,
    sheetName: POPUP_SHEETS.DIVISION_POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });

  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀림.
  const columns = useMemo(
    () =>
      [
        buildNoColumn(t('LBL00674', 'No')),
        {
          colNm: 'CODE',
          colLblNm: 'CODE',
          display: true,
          visible: true,
          colWth: 290,
        },
        {
          colNm: 'NAME',
          colLblNm: 'NAME',
          display: true,
          visible: true,
          colWth: 400,
        },
      ] as RawFlexGridColumnConfig[],
    []
  );

  // columns 와 같은 이유로 useMemo — withRowNo 가 매 렌더 새 배열/새 행 객체를 만들면
  //   체크박스 선택이 똑같이 풀린다.
  const rows = useMemo(() => withRowNo(data?.o_rc ?? []), [data]);

  const collectCheckedRows = (
    grid: FlexGrid<DivisionPopupRow> | null | undefined
  ): DivisionPopupRow[] => {
    if (!grid) return [];
    const rows: DivisionPopupRow[] = [];
    for (const element of grid.rows) {
      const row = element;
      if (row?.isSelected) rows.push(row.dataItem as DivisionPopupRow);
    }
    return rows;
  };

  // popup close 시 상태 초기화
  useEffect(() => {
    if (open) {
      setFilters({ searchText: '' });
    } else {
      setSearchText('');
      setFilters(undefined);
    }
  }, [open]);

  const handleConfirm = () => {
    const checkedDivisions = collectCheckedRows(gridRef.current);
    onSelect(checkedDivisions);
  };

  const onSearch = () => {
    setFilters({ searchText });
  };

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>{t('MNU00208', '_CommonPopup')}</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={800}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          {/* AS-IS 조회 조건 영역: Division (.cs L116), Period (drpPeriod), Type (clbType), Description (txtDes) */}
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={onSearch}
            conditions={
              <Grid size={8}>
                <FormItem
                  label='Name (Code)'
                  labelAlign='right'
                  labelSize='middle'
                  render={() => (
                    <InputField
                      fullWidth
                      value={searchText}
                      onChange={e => setSearchText(e.target.value)}
                    />
                  )}
                />
              </Grid>
            }
          />
          {/* 버전 리스트 grid — AS-IS InitSpread_X (.cs L156) 의 8 컬럼 매핑 */}
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea
              title=''
              count={rows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MENU_ID, POPUP_SHEETS.DIVISION_POPUP>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={columns}
                useCheckbox
                isReadOnly
              />
            </ResultArea>
          </div>

          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t('LBL00716', '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleConfirm}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
