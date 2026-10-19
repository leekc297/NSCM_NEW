/**
 * CAPA Item 팝업 (supply 전용) — AS-IS GSCM.SCM.Popup.UIL.SCM0002_CAPAItemPopup.
 *
 * SCP0104(CAPA_Line_Assign) 의 Model 필드가 여는 팝업(아1). 화면 라벨은 "Model" 이지만 실체는
 * CAPA Item 선택이다. 공통 COM 팝업이 아니라 SCM0002 고유 — 조회조건·컬럼·SP 가 다르므로 supply 자체로 둔다.
 *
 * AS-IS 계약(SCM0002_CAPAItemPopup.cs):
 *  - Init(bMultiSelect, dtDivision, division, shop_group, item)
 *    → Division 은 호출 화면 값으로 비활성 표시, Item(Model Code)만 입력.
 *  - SP: SCM0002_GET_CAPA_ITEM_POPUP(@p_division_id,@p_item_id) → FN_SCM0002_GET_CAPA_ITEM_POPUP
 *  - 반환: 호출 화면(division type)에 따라 NickName 또는 ItemID → 두 값 모두 넘겨 parent 가 고른다.
 *
 * TO-BE 조회(실측 2026-09-16):
 *  - menuId=SCM0002 / sheet=CapaItemPopup / action=SEARCH → PKG_SCM0002.P_SCM0002_GET_CAPA_ITEM_POPUP
 *  - 그리드 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS: SCM0002/CapaItemPopup, 6컬럼)에서 가져온다.
 *  - 필터: division 은 'ALL' 센티널(빈값 보정), item 은 콤마 IN / LIKE(ITEM_ID or NICK_NAME).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useCapaItemPopupStore } from './capaItemPopupStore';
import styles from './ModelByDivisionPopup.module.scss';

const CAPA_MENU = 'SCM0002';
const CAPA_SHEET = 'CapaItemPopup';

type CapaRow = ResponseData<typeof CAPA_MENU, typeof CAPA_SHEET, 'o_rc1'>;
type CapaFilters = ProcRequest<typeof CAPA_MENU, typeof CAPA_SHEET>;

// AS-IS Init 인자 — 호출 화면에서 조회조건으로 넘긴다.
export interface CapaItemPopupParams {
  divisionId?: string;
  itemId?: string;
}

// AS-IS 반환값 (division type 에 따라 NickName 또는 ItemID → 둘 다 노출).
export interface CapaItemSelection {
  itemId: string;
  itemName?: string;
  nickName?: string;
  operationGroup?: string;
  operationId?: string;
}

interface CapaItemPopupProps {
  open: boolean;
  onClose: () => void;
  onSelect?: (selected: CapaItemSelection) => void;
  params?: CapaItemPopupParams;
}

export const CapaItemPopup = ({ open, onClose, onSelect, params }: CapaItemPopupProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<CapaRow>>();
  // ResultArea 가 헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // 그리드 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS / SCM0002·CapaItemPopup)에서 가져온다.
  const initialized = useCapaItemPopupStore(state => state.initialized);
  const staticColumns = useCapaItemPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useCapaItemPopupStore(state => state.fetchStaticColumns);

  // Item 입력값 — 팝업에서 유일하게 편집 가능한 조건.
  const [itemId, setItemId] = useState('');
  // 실제 조회 파라미터 — Search/Enter(그리고 오픈) 시에만 갱신하고 그때 프로시저를 재조회한다.
  const [searchParam, setSearchParam] = useState<CapaFilters>({} as CapaFilters);

  // Division 콤보 — AS-IS 와 동일 소스(SCM0001_GET_DIVISION). 표시용(parent 값 선택), 비활성.
  const [divisions] = useTabComboQueries({ filters: [{ comboId: 'SCM0001_GET_DIVISION' }] });

  // 팝업이 열릴 때마다 호출 화면 파라미터로 초기화한다. division 빈값은 'ALL' 센티널로 보정.
  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: params?.divisionId || 'ALL',
      itemId: params?.itemId ?? '',
    });
    setItemId(params?.itemId ?? '');
    if (!initialized) void fetchStaticColumns();
    // 열릴 때만 초기화한다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<typeof CAPA_MENU, typeof CAPA_SHEET>({
    menuId: CAPA_MENU,
    sheetName: CAPA_SHEET,
    tabId: 'CapaItemPopup',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 선택이 풀린다.
  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  // Search/Enter = 프로시저 재조회(SP 가 Item 부분일치를 처리한다).
  const handleSearch = () => setSearchParam(prev => ({ ...prev, itemId }));

  const confirm = (row: CapaRow) => {
    onSelect?.({
      itemId: row.ITEM_ID,
      itemName: row.ITEM_NAME,
      nickName: row.NICK_NAME,
      operationGroup: row.OPERATION_GROUP,
      operationId: row.OPERATION_ID,
    });
    onClose();
  };

  const handleSubmit = () => {
    const selected = gridRef.current?.selectedItems?.[0] as CapaRow | undefined;
    if (!selected) return;
    confirm(selected);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (row) confirm(row);
  };

  return (
    <CustomDialog
      size={900}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Item by DivisionPopup</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={searchParam.divisionId ?? ''}
                        options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL01142', 'Item')}
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
              <DataGrid<CapaRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={rows}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
