import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  MODAL_ITEM_BY_DIVISION,
  MODAL_SHEET_ITEM_BY_DIVISION,
} from './item-by-division-modal.constants';
import styles from './ItemByDivisionModal.module.scss';
import { useItemByDivisionModalStore } from './itemByDivisionModalStore';

interface ItemByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  // ⭐ nickName 4번째 인자 추가(옵션, 기존 3-인자 호출과 하위호환). Model 선택 시 Nick Name 도 전달.
  setSelectedValue: (
    items: string,
    itemName?: string,
    itemType?: string,
    nickName?: string
  ) => void;
  preSearchParams: ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>;
  callFromCell: boolean;
  // 호출 화면별 헤더 title 커스터마이즈 (옵션). 기본값: LBL00343 '_ItemByDivisionPopup'
  // 예: DMF0072 NN Master Mapping 에서는 'Model/Nickname Popup' 으로 표시 (사용자 요구 2026-06-02)
  headerTitle?: string;
  // ⭐ 멀티 선택 모드(옵션, default false). true 시 체크박스 컬럼으로 선택(재기동 시 carry/프리체크 없음).
  //   미지정 화면은 기존 동작(MultiRange 선택, dblClick 단건) 그대로 → 회귀 0.
  multiCheckbox?: boolean;
}

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell: _callFromCell,
  headerTitle,
  multiCheckbox = false,
}: ItemByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<FlexGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION, 'o_rc1'>>>();

  const initialized = useItemByDivisionModalStore(state => state.initialized);
  const staticColumns = useItemByDivisionModalStore(state => state.staticColumns);
  const divisionId = useItemByDivisionModalStore(state => state.divisionId);
  const fetchStaticColumns = useItemByDivisionModalStore(state => state.fetchStaticColumns);

  const [divisions, teams, endCustomers, salesSites] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite'],
  });

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>
  >({} as ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>);
  const [itemId, setItemId] = useState<string>();

  const [modalFilters, setModalFilters] = useState<{
    itemId: string;
  }>({
    itemId: '',
  });

  const { data: itemData } = useTabProcQuery<MODAL_ITEM_BY_DIVISION>({
    menuId: MODAL_ITEM_BY_DIVISION,
    sheetName: MODAL_SHEET_ITEM_BY_DIVISION,
    tabId: 'ItemByDivisionModal',
    filters: searchParam,
    enabled: open,
  });

  // useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 체크박스 선택(row.isSelected)이 풀림.
  //   itemData/필터 변경 시에만 재계산 → 체크 후 OK 까지 선택 유지.
  const itemsSource = useMemo(
    () =>
      (itemData?.o_rc1 ?? []).filter(
        item =>
          (item.ITEM_ID ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase()) ||
          (item.ITEM_NAME ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase()) ||
          (item.NICK_NAME ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase())
      ),
    [itemData, modalFilters]
  );

  // 자동필터 해제 — Search 버튼/Enter 시에만 modalFilters 반영 (입력 중 즉시필터 안 함).
  const handleSearch = () => setModalFilters({ itemId: itemId ?? '' });

  const handleSubmit = () => {
    if (multiCheckbox) {
      // 체크박스 모드 — 체크된(row.isSelected) 행의 ITEM_ID 수집.
      const grid = gridRef.current;
      if (!grid) return;
      const ids: string[] = [];
      for (const row of grid.rows) {
        const it = row?.dataItem as { ITEM_ID?: string } | undefined;
        if (row?.isSelected && it?.ITEM_ID) ids.push(it.ITEM_ID);
      }
      setSelectedValue(ids.join(','));
      modalClose();
      return;
    }

    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_ITEM_BY_DIVISION,
      MODAL_SHEET_ITEM_BY_DIVISION,
      'o_rc1'
    >[];

    if (!selections) return;

    const items = selections.map(item => item.ITEM_ID).join(',');

    // 단일 선택이면 Name/Type/NickName 도 함께 전달(dblClick 과 동일). 다중 선택은 첫 행 기준.
    const first = selections[0];
    setSelectedValue(items, first?.ITEM_NAME, first?.ITEM_CLASS_NAME, first?.NICK_NAME);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(
      dataItem.ITEM_ID,
      dataItem.ITEM_NAME,
      dataItem.ITEM_CLASS_NAME,
      dataItem.NICK_NAME
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    // ⭐ 2026-07-03 (사용자 요구) — cell 호출도 Form 호출과 동일하게 preSearchParams 를 그대로 사용.
    //   기존 callFromCell 강제 'ALL' 은 그리드 행 값 cascade(hook #59 §5-G — 클릭 행의 상위 셀 값
    //   전달)를 무시하는 문제. cell 호출처는 값 미보유 시 'ALL' 을 명시 전달 (fallback 방어 포함).
    setSearchParam({
      divisionId: preSearchParams.divisionId,
      deptId: preSearchParams.deptId ?? 'ALL',
      endCustomer: preSearchParams.endCustomer ?? 'ALL',
      salesSite: preSearchParams.salesSite ?? 'ALL',
      projectCode: preSearchParams.projectCode ?? '',
      itemId: '',
    });
    setModalFilters({ itemId: preSearchParams.itemId ?? '' });
    setItemId(preSearchParams.itemId);
    if (!initialized || preSearchParams.divisionId !== divisionId)
      void fetchStaticColumns(preSearchParams.divisionId);
  }, [open]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{headerTitle ?? t('LBL00343', '_ItemByDivisionPopup')}</h2>
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
                    label={t('LBL00001', '_Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        mandatory
                        disabled
                        value={searchParam?.divisionId ?? ''}
                        options={
                          divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00044', '_Team')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        mandatory
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.deptId}
                        options={[
                          ...new Map(
                            (teams ?? [])
                              .filter(item => item.DIVISION_ID === searchParam.divisionId)
                              .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                          ).values(),
                        ].map(item => ({ label: item.NAME, value: item.CODE }))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00080', '_End Customer')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.endCustomer}
                        options={
                          // ⭐ 2026-07-03 — DEPT 관대 통과 + 선택 값 보존 (hook #59 §5-G: 콤보 DEPT
                          //   기준 불일치/NULL 로 선택 값이 옵션 탈락 → disabled 표시가 비는 사고)
                          [
                            ...new Map(
                              endCustomers
                                ?.filter(
                                  item =>
                                    item.DIVISION_ID === searchParam.divisionId &&
                                    (searchParam.deptId === 'ALL' ||
                                      !item.DEPT_ID ||
                                      searchParam.deptId?.split(',').includes(item.DEPT_ID) ||
                                      searchParam.endCustomer?.split(',').includes(item.CODE))
                                )
                                .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                            ).values(),
                          ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00011', '_Sales Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.salesSite}
                        options={[
                          // ⭐ 2026-07-03 — DEPT 관대 통과 + 선택 값 보존 (End Customer 와 동일 사유)
                          ...new Map(
                            (salesSites ?? [])
                              .filter(
                                item =>
                                  item.DIVISION_ID === searchParam.divisionId &&
                                  (searchParam.deptId === 'ALL' ||
                                    !item.DEPT_ID ||
                                    searchParam.deptId?.split(',').includes(item.DEPT_ID) ||
                                    searchParam.salesSite?.split(',').includes(item.CODE))
                              )
                              .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                          ).values(),
                        ].map(item => ({ label: item.NAME, value: item.CODE }))}
                      />
                    )}
                  />
                </Grid>
                {searchParam.divisionId !== '40' && (
                  <Grid size={4}>
                    <FormItem
                      label={t('LBL00327', '_Project')}
                      labelAlign='right'
                      render={() => (
                        <InputField fullWidth disabled value={searchParam.projectCode ?? ''} />
                      )}
                    />
                  </Grid>
                )}
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00003', '_Model/Nickname')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId ?? ''}
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
            <DataGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>>
              gridRef={gridRef}
              isReadOnly
              useCheckbox={multiCheckbox}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={multiCheckbox ? undefined : handleDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
          </div>
        </div>
      }
    />
  );
};
