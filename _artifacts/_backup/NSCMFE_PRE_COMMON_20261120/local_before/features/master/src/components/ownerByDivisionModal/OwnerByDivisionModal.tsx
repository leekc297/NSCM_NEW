import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog, ResultArea } from '@shared/components';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

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
  const itemsSource = useMemo(() => ownerData?.o_rc1 ?? [], [ownerData]);

  // itemsSource 와 같은 이유로 useMemo — withRowNo 가 매 렌더 새 배열/새 행 객체를 만들면
  //   위 itemsSource useMemo 가 무의미해져 체크박스 선택이 똑같이 풀린다.
  const rows = useMemo(() => withRowNo(itemsSource), [itemsSource]);

  const gridStaticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', 'No')), ...staticColumns],
    [staticColumns, t]
  );

  // Search 버튼/Enter — SP(COM0006)의 P_OWNER_ID 는 현재 죽은 파라미터라 결과가 안 좁혀진다.
  //   추후 SP 연결 시 바로 동작하도록 searchParam.owner 갱신 구조만 살려둔다.
  const handleSearch = () => setSearchParam(prev => ({ ...prev, owner: ownerKeyword }));

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
    // 호출 화면의 owner 검색조건이 입력창 초기값으로 반영됨.
    const initOwner = ownerId ?? preSearchParams.owner ?? '';
    setOwnerKeyword(initOwner);
    // 받은 값으로 바로 조회한다 - 열자마자 필터된 목록이 보여야 한다 (사용자 지정 2026-09-07).
    //   종전에는 빈값으로 조회하고 입력창에만 값을 채워, Search 를 눌러야 좁혀졌다.
    setSearchParam({ ...preSearchParams, owner: initOwner });
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
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
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
            <ResultArea
              title=''
              count={rows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<
                ResponseData<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION, 'o_rc1'>
              >
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox={multiCheckbox}
                // No 는 ROW_NO 데이터 컬럼(buildNoColumn)이 전담한다. rowHeader 를 그대로 두면
                //   체크박스가 없는 단일선택 모드에서 공통 formatEditableColumns 가 rowHeader col 0
                //   에도 행번호를 찍어 No 가 두 개로 보인다. 체크박스 모드는 rowHeader 에 wijmo
                //   Selector 가 살아야 하므로 그때만 rowHeader 를 남긴다.
                headersVisibility={multiCheckbox ? HeadersVisibility.All : HeadersVisibility.Column}
                staticColumns={gridStaticColumns}
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
