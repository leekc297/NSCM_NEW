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
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
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
  /**
   * 선택 확정. 1번째 인자는 **첫 행**(단일선택 호출부의 기존 계약 그대로),
   * 2번째 인자는 선택된 전건이다 — 기존 호출부는 2번째를 받지 않으므로 동작이 바뀌지 않는다.
   */
  onSelect?: (selected: CapaItemSelection, selectedAll: CapaItemSelection[]) => void;
  params?: CapaItemPopupParams;
  /**
   * 다중선택 여부 — AS-IS `Init(bMultiSelect, …)` 1번 인자.
   * 기본값 `false` = 기존 단일선택(SCP0104). SCP0105 는 `true`(AS-IS cs:3130 `multiSelect=true`).
   */
  multiSelect?: boolean;
  /**
   * `OPERATION_GROUP` 필터 — AS-IS `Init(…, shop_group, …)` 4번 인자.
   * 팝업 SP 에는 shop group 파라미터가 없고(`P_DIVISION_ID`/`P_ITEM_ID` 2개뿐) AS-IS 도 조회 후
   * `DBUtils.GetAndFilterString(["OPERATION_GROUP"], [shop_group], true)` 로 거른다
   * (SCM0002_CAPAItemPopup.cs:301~303). 그래서 여기서도 클라 필터다.
   * 미지정 = 필터 없음(기존 호출부 동작 보존).
   */
  operationGroup?: string;
}

export const CapaItemPopup = ({
  open,
  onClose,
  onSelect,
  params,
  multiSelect = false,
  operationGroup,
}: CapaItemPopupProps) => {
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

  // useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 선택(row.isSelected)이 풀린다.
  //   `OPERATION_GROUP` 필터는 행번호를 매기기 **전에** 건다 — 걸러진 뒤에 No. 가 이어져야 한다.
  const rows = useMemo(() => {
    const source = data?.o_rc1 ?? [];
    const filtered = operationGroup
      ? source.filter(row => row.OPERATION_GROUP === operationGroup)
      : source;
    return withRowNo(filtered);
  }, [data, operationGroup]);

  /**
   * No. 컬럼은 `ROW_NO` 데이터 컬럼(`buildNoColumn`)이 전담한다 — 원천 메타
   * (`SCM_MST_SHEET_COLUMNS` SCM0002/CapaItemPopup)는 6컬럼뿐이라 `withRowNo` 가 넣는 값을
   * 표시할 자리가 없다. 단일선택 모드는 rowHeader 를 숨기므로(headersVisibility=Column) 이 컬럼이
   * 유일한 행번호이고, 체크박스 모드는 rowHeader col 0 을 wijmo Selector 가 쓰므로 역시 필요하다.
   * `ItemByDivisionModal`(master) 과 같은 규약이다.
   */
  const gridStaticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', 'No')), ...staticColumns],
    [staticColumns, t]
  );

  // Search/Enter = 프로시저 재조회(SP 가 Item 부분일치를 처리한다).
  const handleSearch = () => setSearchParam(prev => ({ ...prev, itemId }));

  const toSelection = (row: CapaRow): CapaItemSelection => ({
    itemId: row.ITEM_ID,
    itemName: row.ITEM_NAME,
    nickName: row.NICK_NAME,
    operationGroup: row.OPERATION_GROUP,
    operationId: row.OPERATION_ID,
  });

  const confirm = (picked: CapaRow[]) => {
    if (picked.length === 0) return;
    const selections = picked.map(toSelection);
    onSelect?.(selections[0], selections);
    onClose();
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (multiSelect) {
      // 체크박스 모드 — 체크된(row.isSelected) 행 전건. ItemByDivisionModal 과 동일 규약.
      const checked: CapaRow[] = [];
      for (const row of grid.rows) {
        const item = row?.dataItem as CapaRow | undefined;
        if (row?.isSelected && item) checked.push(item);
      }
      confirm(checked);
      return;
    }
    const selected = grid.selectedItems?.[0] as CapaRow | undefined;
    confirm(selected ? [selected] : []);
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기(체크박스 모드 포함 — 체크해 둔 행은 무시되고
  //   더블클릭한 행만 넘어간다. 여러 건은 체크 후 OK. ItemByDivisionModal 과 같은 단건 빠른 경로).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (row) confirm([row]);
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
                useCheckbox={multiSelect}
                // No 는 위 `gridStaticColumns` 의 ROW_NO 컬럼이 전담한다. 단일선택 모드에서 rowHeader
                //   를 남기면 공용 formatEditableColumns 가 col 0 에도 행번호를 찍어 No 가 두 개로
                //   보인다. 체크박스 모드만 rowHeader(= wijmo Selector) 를 살린다.
                headersVisibility={
                  multiSelect ? HeadersVisibility.All : HeadersVisibility.Column
                }
                staticColumns={gridStaticColumns}
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
