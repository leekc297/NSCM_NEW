import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { DIVISION, MENU_ID, SHEETS } from '../../mkt-fcst-01.constants';
import styles from '../../MktFcst01.module.scss';
import { useMktFcst01Store } from '../../useMktFcst01Store';

// Model 검색 · Prod. Country 조건 (설계서 popup-4, 요건 17) — 신규 행 Model 셀을 두 번 누르면 열린다.
//   공용 Model 팝업(COM0008)과 같은 조회 조건 · 결과에 조회 조건 Prod. Country(그 행 값, 수정 불가)와
//   결과 칸 Model Prod. Country 를 더했다. 공용 팝업은 조회 API · 칸 설정이 COM0008 로 고정돼 있어
//   이 화면 전용으로 새로 만들었다(사용자 결정 2026-11-06).
//   조회: modelPopup / SEARCH → PKG_DMF0003_01.P_DMF0003_01_GET_MODEL_POPUP.
//   Prod. Country 가 비었거나 99(N/A) 뿐이면 프로시저가 조건 없이 공용 팝업과 같은 결과를 준다.
//   결과 칸은 칸 설정(프로그램 DMF0003_01 · 시트 modelPopup, 40 은 modelPopup_40)을 따른다.

type ModelRow = ResponseData<MENU_ID, SHEETS.MODEL_POPUP>;
export type ModelPopupParams = ProcRequest<MENU_ID, SHEETS.MODEL_POPUP>;

export interface ModelPopupSelection {
  itemId: string;
  itemName: string;
  nickName: string;
  itemType: string;
}

interface ModelPopupModalProps {
  open: boolean;
  modalClose: () => void;
  // 그 행의 값으로 채운 조회 조건. 열 때마다 이 값으로 다시 시작한다.
  preSearchParams: ModelPopupParams;
  onSelect: (selection: ModelPopupSelection) => void;
}

const toSelection = (row: ModelRow): ModelPopupSelection => ({
  itemId: row.ITEM_ID ?? '',
  itemName: row.ITEM_NAME ?? '',
  nickName: row.NICK_NAME ?? '',
  itemType: row.ITEM_TYPE ?? '',
});

export const ModelPopupModal = ({ open, modalClose, preSearchParams, onSelect }: ModelPopupModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ModelRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const staticColumns = useMktFcst01Store(state => state.staticColumns[SHEETS.MODEL_POPUP]);
  const fetchPopupColumns = useMktFcst01Store(state => state.fetchPopupColumns);

  // 실제 조회 인자 — 열 때 preSearchParams 로 시작하고, Search 는 Model/Nickname 만 바꾼다.
  const [searchParam, setSearchParam] = useState<ModelPopupParams | null>(null);
  const [itemId, setItemId] = useState('');

  const divisionId = preSearchParams.divisionId ?? '';
  useEffect(() => {
    if (!open) {
      setSearchParam(null);
      return;
    }
    setSearchParam(preSearchParams);
    setItemId(preSearchParams.itemId ?? '');
    void fetchPopupColumns(SHEETS.MODEL_POPUP, divisionId);
    // 열 때 한 번만 시작값을 잡는다 — preSearchParams 는 호출부가 렌더마다 새로 만든다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MODEL_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.MODEL_POPUP,
    tabId: 'ModelPopupModal',
    filters: searchParam ?? undefined,
    enabled: open && !!searchParam,
  });
  const itemsSource = useMemo(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [t, itemsSource]);

  const handleSearch = () => {
    setSearchParam(prev => (prev ? { ...prev, itemId } : prev));
  };

  // 이 셀은 Model 한 건만 받는다 — 여러 줄을 골라도 맨 위 행만 쓴다(DMF0003 셀 팝업과 같은 규칙).
  const handleOk = () => {
    const first = (gridRef.current?.selectedItems as ModelRow[] | undefined)?.[0];
    if (!first) return;
    onSelect(toSelection(first));
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row) as ModelRow | undefined;
    if (!row) return;
    onSelect(toSelection(row));
    modalClose();
  };

  // 표시 전용 조건 — 그 행에서 넘어온 값을 그대로 보여 준다(공용 팝업도 이 조건들은 잠겨 있다).
  const readOnlyField = (label: string, value: string | undefined) => (
    <Grid size={4}>
      <FormItem
        className={commonStyles.formItem}
        label={label}
        labelAlign='right'
        render={() => <InputField fullWidth disabled value={value ?? ''} />}
      />
    </Grid>
  );

  return (
    <CustomDialog
      size={1000}
      type='modal'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00343', '_ItemByDivisionPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {readOnlyField(t('LBL00001', '_Div.'), searchParam?.divisionId)}
                {readOnlyField(t('LBL00044', '_Team'), searchParam?.deptId)}
                {readOnlyField(t('LBL00080', '_End Customer'), searchParam?.endCustomer)}
                {readOnlyField(t('LBL00011', '_Sales Site'), searchParam?.salesSite)}
                {divisionId !== DIVISION.MOBILITY &&
                  readOnlyField(t('LBL00012', '_Project'), searchParam?.projectCode)}
                <Grid size={4}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00618', '_Model/Nickname')}
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
                {readOnlyField(t('LBL01232', 'Prod. Country'), searchParam?.prdnCtry)}
              </>
            }
          />
          <div className={styles.modalGridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={isLoading || isFetching}
              placement='parent'
            />
            <ResultArea title='' count={itemsSource.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<ModelRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={itemsSource}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
          </div>
        </div>
      }
    />
  );
};
