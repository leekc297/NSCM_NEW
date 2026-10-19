import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  SEARCH_POPUP_WIDTH,
  buildEndCustomerOptions,
  buildSalesSiteOptions,
} from '../searchFields/SearchFields.utils';

import {
  MODAL_OWNER_BY_DIVISION,
  MODAL_SHEET_OWNER_BY_DIVISION,
} from './owner-by-division-modal.constants';
import styles from './OwnerByDivisionModal.module.scss';
import { useOwnerByDivisionModalStore } from './ownerByDivisionModalStore';

interface OwnerByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  // DMF0008 (2026-07-08): cell dblClick 시 OWNER(코드) + USER_NM(이름) 자동 채움 의무 — optional 추가 인자
  setSelectedValue: (owners: string, ownerNames?: string) => void;
  preSearchParams: ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>;
  ownerId?: string;
  // ⭐ 멀티 선택 모드(옵션). true 시 체크박스 컬럼으로 선택(재기동 시 carry/프리체크 없음).
  multiCheckbox?: boolean;
}

export const OwnerByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  ownerId = undefined,
  multiCheckbox = false,
}: OwnerByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<
      FlexGrid<ResponseData<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION, 'o_rc1'>>
    >();

  const initialized = useOwnerByDivisionModalStore(state => state.initialized);
  const staticColumns = useOwnerByDivisionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useOwnerByDivisionModalStore(state => state.fetchStaticColumns);

  // 2026-08-22 콤보 통일 — End Customer 는 division 무관 'EndCustomer' 단일이다.
  //   종전 40 전용 'EndCustomerByDivision40' 스왑은 폐지했다 (호출 화면의 조회조건도
  //   같은 콤보를 쓰므로 여기서만 다른 원천을 쓰면 라벨이 안 맞는다).
  const [divisions, endCustomers, salesSites] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SalesSite'],
  });

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>
  >({} as ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>);

  // Team 콤보는 divisionId 파라미터를 받아야 한다 (SearchFields TeamField 와 같은 계약).
  //   미전달 = 'ALL' 분기라 division 40 의 팀은 아예 반환되지 않는다 (40 은 owner 경로 전용
  //   분기 — 40 SALES 사이트는 DEPT 미배정 설계). 그러면 호출 화면 조회조건에서 넘어온 Team
  //   값이 options 에 없어 selectedOptions 가 비고, CustomDropdown 이 placeholder 'ALL' 만
  //   보여준다 — 값은 전달됐는데 화면만 ALL 로 보이던 원인.
  // 주의: BE makeComboQuery 는 raw 문자열 치환이라 작은따옴표를 포함해 넘긴다.
  // divisionId 가 바뀌면 쿼리키가 바뀌어 자동 재조회된다.
  const [teams] = useTabComboQueries({
    filters: [{ comboId: 'TeambyDivision', divisionId: `'${searchParam.divisionId ?? ''}'` }],
  });

  const [modalFilters, setModalFilters] = useState<{
    owner: string;
  }>({ owner: '' });
  const [ownerKeyword, setOwnerKeyword] = useState('');

  const {
    data: ownerData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_OWNER_BY_DIVISION>({
    menuId: MODAL_OWNER_BY_DIVISION,
    sheetName: MODAL_SHEET_OWNER_BY_DIVISION,
    tabId: 'OwnerByDivisionModal',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀림.
  const itemsSource = useMemo(
    () =>
      (ownerData?.o_rc1 ?? []).filter(owner =>
        (owner.OWNER ?? '').toLowerCase().includes(modalFilters.owner.toLowerCase())
      ),
    [ownerData, modalFilters]
  );

  // 자동필터 해제 — Search 버튼/Enter 시에만 modalFilters 반영 (입력 중 즉시필터 안 함).
  const handleSearch = () => setModalFilters({ owner: ownerKeyword });

  const handleSubmit = () => {
    if (multiCheckbox) {
      // 체크박스 모드 — 체크된(row.isSelected) 행의 OWNER(코드) + USER_NM(이름) 수집.
      const grid = gridRef.current;
      if (!grid) return;
      const ids: string[] = [];
      const names: string[] = [];
      for (const row of grid.rows) {
        const it = row?.dataItem as { OWNER?: string; USER_NM?: string } | undefined;
        if (row?.isSelected && it?.OWNER) {
          ids.push(it.OWNER);
          names.push(it.USER_NM ?? '');
        }
      }
      setSelectedValue(ids.join(','), names.join(','));
      modalClose();
      return;
    }

    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_OWNER_BY_DIVISION,
      MODAL_SHEET_OWNER_BY_DIVISION,
      'o_rc1'
    >[];

    if (!selections) return;

    const owners = selections.map(item => item.OWNER).join(',');
    const ownerNames = selections.map(item => item.USER_NM ?? '').join(',');

    setSelectedValue(owners, ownerNames);
    modalClose();
  };

  // ⭐ 더블클릭 = 그 행 하나로 확정 후 닫기 (체크박스 모드 포함 — 2026-08-06 사용자 요청).
  //   구: dblClick={multiCheckbox ? undefined : handleDblClick} 로 체크박스 모드에서 핸들러 자체가
  //   미장착이라 더블클릭해도 부모창에 값이 안 넘어갔다.
  //   ⚠ 체크박스 모드에서 더블클릭하면 이미 체크해 둔 행들은 무시되고 더블클릭한 행만 전달된다
  //     (여러 건을 넘기려면 체크 후 OK). 단건 선택의 빠른 경로로만 쓰는 규약.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.OWNER, dataItem.USER_NM ?? '');
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    // ownerId 가 undefined 일 때 preSearchParams.owner fallback — DMF0005 가 prop 생략해도
    // 호출 화면의 owner 검색조건이 modal filter 로 반영됨. feat/dmf0020-sales-future-price
    // 머지 시 동일 패턴이라 conflict 0 + DMF0005 ownerId prop 주석 사고 사전 차단.
    setModalFilters({ owner: ownerId ?? preSearchParams.owner ?? '' });
    setOwnerKeyword(ownerId ?? preSearchParams.owner ?? '');
    setSearchParam({ ...preSearchParams, owner: '' });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      // ⭐ 1200 → SEARCH_POPUP_WIDTH(900) — Model/Project 팝업과 폭 통일 (2026-08-06 사용자 요청).
      //   CustomDialog 가 DIALOG_SCALE(1.5) 을 곱하므로 실제 폭 1800px → 1350px.
      size={SEARCH_POPUP_WIDTH}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00336', '_OwnerByDivisionPopup')}</h2>
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
                              // DIVISION_ID 가 공란인 행은 통과시킨다 (SearchFields toOptions 와
                              // 동일 규칙). 엄격 비교만 하면 division 키를 안 채워 주는 응답에서
                              // 목록이 통째로 비어버린다.
                              .filter(
                                item =>
                                  !searchParam.divisionId ||
                                  !item.DIVISION_ID ||
                                  item.DIVISION_ID === searchParam.divisionId
                              )
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
                        options={buildEndCustomerOptions({
                          rows: endCustomers,
                          divisionId: searchParam.divisionId,
                          deptId: searchParam.deptId,
                          selected: searchParam.endCustomer,
                        })}
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
                        options={buildSalesSiteOptions({
                          rows: salesSites,
                          divisionId: searchParam.divisionId,
                          deptId: searchParam.deptId,
                          selected: searchParam.salesSite,
                        })}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00082', '_Owner')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={ownerKeyword}
                        onChange={e => setOwnerKeyword(e.target.value)}
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
            <DataGrid<ResponseData<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION, 'o_rc1'>>
              gridRef={gridRef}
              isReadOnly
              useCheckbox={multiCheckbox}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
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
