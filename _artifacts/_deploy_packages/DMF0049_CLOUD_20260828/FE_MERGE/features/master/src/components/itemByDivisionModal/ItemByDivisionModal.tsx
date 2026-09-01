import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  SEARCH_POPUP_WIDTH,
  buildEndCustomerOptions,
  buildSalesSiteOptions,
} from '../searchFields/SearchFields.utils';

import {
  DEFAULT_ITEM_MODAL_CONDITIONS,
  DEFAULT_ITEM_TYPE,
  ITEM_MODAL_CONDITION,
  ITEM_TYPE_ALL,
  MODAL_ITEM_BY_DIVISION,
  MODAL_SHEET_ITEM_BY_DIVISION,
  type ItemModalColumn,
  type ItemModalCondition,
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
    itemClassName?: string,
    itemType?: string,
    nickName?: string,
    // DMF0021 (2026-08-14, 통합테스트 1st No.61-④): Team 자동 채움 — Team 은 입력 불가 컬럼이라
    //   선택한 마스터 행의 팀을 그대로 내려줘야 화면에 표시된다. 미사용 호출부는 무시 → 회귀 0.
    deptId?: string,
    deptName?: string
  ) => void;
  preSearchParams: ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>;
  callFromCell: boolean;
  // 호출 화면별 헤더 title 커스터마이즈 (옵션). 기본값: LBL00343 '_ItemByDivisionPopup'
  // 예: DMF0072 NN Master Mapping 에서는 'Model/Nickname Popup' 으로 표시 (사용자 요구 2026-06-02)
  headerTitle?: string;
  // ⭐ 멀티 선택 모드(옵션, default false). true 시 체크박스 컬럼으로 선택(재기동 시 carry/프리체크 없음).
  //   미지정 화면은 기존 동작(MultiRange 선택, dblClick 단건) 그대로 → 회귀 0.
  multiCheckbox?: boolean;
  /**
   * ⭐ 노출할 검색조건(옵션). 미지정이면 DEFAULT_ITEM_MODAL_CONDITIONS = 기존 동작 그대로(회귀 0).
   *
   * 여기 없는 조건은 화면에서 빠질 뿐 **조회 조건에서 빠지는 게 아니다** — Div/Team/EndCustomer/
   * SalesSite/Project 는 전부 disabled 표시용이고 실제 값은 preSearchParams 로 그대로 넘어간다.
   *
   * ITEM_TYPE 은 신설 조건 — 켜면 드롭다운이 뜨고 결과를 Item Type 으로도 거른다.
   *   COM0008 request 에는 itemType 파라미터가 없고 응답에만 ITEM_TYPE/ITEM_TYPE_NAME 이 실려 온다.
   *   따라서 Model 검색어와 **동일하게 클라이언트단에서** 거른다 — BE 변경 없음.
   *   텍스트 입력인 Model 과 달리 드롭다운은 선택 즉시 반영한다(Search 버튼을 기다리지 않는다).
   */
  visibleConditions?: ItemModalCondition[];
  /**
   * ⭐ 결과 그리드에 남길 컬럼(colNm)과 그 순서(옵션). 미지정이면 admin 컬럼 메타 전체(기존 동작).
   *
   * 컬럼 메타는 division 단위(COM0008 fetchStaticColumns)라 호출 화면별로 나눌 수단이 없다.
   * 같은 division 을 쓰는 다른 호출처에 영향을 주지 않으려면 여기서 화면별로 좁힌다.
   * ⚠ 여기 적은 순서대로 배치된다. 그룹 헤더(sClsLblNm/lClsLblNm)가 걸린 컬럼을 떨어뜨려 적으면
   *   같은 그룹이 갈라져 헤더가 두 번 그려지므로 붙여서 적을 것.
   * 메타에 아예 없는(=admin 미등록) 컬럼은 문자열 대신 객체({colNm, colLblNm})로 적으면
   *   응답 데이터를 보고 컬럼을 만들어 낸다 — ItemModalColumnSpec 주석 참고.
   */
  visibleColumns?: ItemModalColumn[];
  /**
   * ⭐ 팝업 가로 폭(px, 옵션). 미지정이면 1000 = 기존 동작 그대로(회귀 0).
   * 검색조건/컬럼을 줄여 연 화면에서 폭까지 좁히라고 둔 opt-in.
   */
  dialogSize?: number;
}

/** dialogSize 미지정 시 폭 — 기존 하드코딩 값 그대로. */
const DEFAULT_DIALOG_SIZE = SEARCH_POPUP_WIDTH;

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell: _callFromCell,
  headerTitle,
  multiCheckbox = false,
  visibleConditions = DEFAULT_ITEM_MODAL_CONDITIONS,
  visibleColumns,
  dialogSize = DEFAULT_DIALOG_SIZE,
}: ItemByDivisionModalProps) => {
  const { t } = useTranslation();

  // 조건 노출 플래그 — JSX 를 짧게 유지하려고 미리 펴 둔다.
  const showCondition = (condition: ItemModalCondition) => visibleConditions.includes(condition);
  const showDivision = showCondition(ITEM_MODAL_CONDITION.DIVISION);
  const showTeam = showCondition(ITEM_MODAL_CONDITION.TEAM);
  const showEndCustomer = showCondition(ITEM_MODAL_CONDITION.END_CUSTOMER);
  const showSalesSite = showCondition(ITEM_MODAL_CONDITION.SALES_SITE);
  const showProject = showCondition(ITEM_MODAL_CONDITION.PROJECT);
  const showModel = showCondition(ITEM_MODAL_CONDITION.MODEL);
  const useItemTypeFilter = showCondition(ITEM_MODAL_CONDITION.ITEM_TYPE);

  // 기본 폭보다 좁게 연 호출처에서는 SearchArea 의 공통 min-width(디자인 토큰)를 푼다.
  //   안 그러면 검색영역이 다이얼로그보다 넓어 그대로 잘려 나간다(Paper 는 overflow:hidden).
  const isNarrowDialog = dialogSize < DEFAULT_DIALOG_SIZE;

  const gridRef =
    useRef<FlexGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION, 'o_rc1'>>>();

  const initialized = useItemByDivisionModalStore(state => state.initialized);
  const staticColumns = useItemByDivisionModalStore(state => state.staticColumns);
  const divisionId = useItemByDivisionModalStore(state => state.divisionId);
  const fetchStaticColumns = useItemByDivisionModalStore(state => state.fetchStaticColumns);

  const [divisions, endCustomers, salesSites, itemTypes] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SalesSite', 'ItemType'],
  });

  // Item Type — 기본값을 state 초기값으로 박지 않는다. 콤보 응답이 늦게 오면 그 시점엔 CODE 를
  //   모르기 때문. 사용자가 아직 안 고른 동안(undefined)은 콤보에서 파생한 기본값을 쓴다.
  const [selectedItemType, setSelectedItemType] = useState<string>();
  const itemTypeOptions = useMemo(
    () => itemTypes?.map((item: ComboResponse) => ({ label: item.NAME, value: item.CODE })) ?? [],
    [itemTypes]
  );
  const defaultItemType = useMemo(
    () =>
      itemTypes?.find(
        (item: ComboResponse) => item.CODE === DEFAULT_ITEM_TYPE || item.NAME === DEFAULT_ITEM_TYPE
      )?.CODE ?? ITEM_TYPE_ALL,
    [itemTypes]
  );
  const itemType = selectedItemType ?? defaultItemType;

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>
  >({} as ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>);

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
      (itemData?.o_rc1 ?? []).filter(item => {
        const keyword = modalFilters.itemId.toLowerCase();
        const matchesKeyword =
          (item.ITEM_ID ?? '').toLowerCase().includes(keyword) ||
          (item.ITEM_NAME ?? '').toLowerCase().includes(keyword) ||
          (item.NICK_NAME ?? '').toLowerCase().includes(keyword);
        if (!matchesKeyword) return false;

        if (!useItemTypeFilter || itemType === ITEM_TYPE_ALL) return true;
        // 콤보 CODE 가 코드(ITEM_TYPE)인지 명칭(ITEM_TYPE_NAME)인지는 admin 메타에 달렸다 — 둘 다 본다.
        return item.ITEM_TYPE === itemType || item.ITEM_TYPE_NAME === itemType;
      }),
    [itemData, modalFilters, useItemTypeFilter, itemType]
  );

  // 호출처가 컬럼을 지정하면 그 목록·순서만 남긴다.
  //   'A|B' 처럼 후보를 나열하면 먼저 잡히는 쪽 하나만 쓴다 — 코드/명칭 컬럼(ITEM_TYPE vs
  //   ITEM_TYPE_NAME) 중 어느 쪽이 실려 있는지 화면 코드에서 알 수 없을 때 쓰라고 둔 장치.
  //   ⚠ admin 메타에 있어도 display=false 면 공통 DataGrid 가 걸러 낸다 — 호출처가 콕 집어 적은
  //     컬럼이니 여기서 display/visible 을 강제로 켠다.
  //   ⚠ 메타에 아예 없는 컬럼(admin 미등록)은 객체 지정({colNm, colLblNm})일 때만 살린다 —
  //     응답 행에 값이 실제로 들어 있는 후보를 골라 컬럼을 만들어 낸다.
  const gridStaticColumns = useMemo(() => {
    if (!visibleColumns) return staticColumns;

    const rows = itemData?.o_rc1 ?? [];
    const hasValue = (colNm: string) =>
      rows.some(row => !!(row as unknown as Record<string, unknown>)[colNm]);

    return visibleColumns
      .map((entry): RawFlexGridColumnConfig | undefined => {
        const spec = typeof entry === 'string' ? { colNm: entry } : entry;
        const candidates = spec.colNm.split('|');
        const meta = candidates.reduce<RawFlexGridColumnConfig | undefined>(
          (found, candidate) => found ?? staticColumns.find(column => column.colNm === candidate),
          undefined
        );
        if (meta) return { ...meta, display: true, visible: true };
        if (typeof entry === 'string') return undefined;

        const binding = candidates.find(hasValue) ?? candidates[0];
        return {
          colNm: binding,
          colLblNm: entry.colLblNm,
          colWth: entry.colWth,
          horzAlgnCd: 'L',
          display: true,
          visible: true,
          // 그룹 라벨을 자기 라벨로 맞춰 둔다 — 다른 컬럼이 2/3단 헤더여도 이 컬럼만 따로 묶인다.
          sClsLblNm: entry.colLblNm,
          lClsLblNm: entry.colLblNm,
        };
      })
      .filter((column): column is RawFlexGridColumnConfig => !!column);
  }, [staticColumns, visibleColumns, itemData]);

  // Search 버튼/Enter = 프로시저 재조회 (사용자 요구 2026-08-11).
  //   구: 입력값을 client-side 필터로만 썼다 → 팝업이 열릴 때 받아 온 행 안에서만 찾을 수 있었고,
  //   그 범위 밖의 Model 은 아무리 검색해도 안 나왔다. 이제 조회 파라미터에 실어 다시 조회한다.
  //   화면 필터도 같은 키워드로 유지 — SP 가 파라미터를 무시하거나 넓게 내려줘도 결과가 좁혀 보인다.
  //   Item Type 은 COM0008 request 에 없는 조건이라 종전대로 client-side 필터다.
  const handleSearch = () => {
    const keyword = itemId ?? '';
    setSearchParam(prev => ({ ...prev, itemId: keyword }));
    setModalFilters({ itemId: keyword });
  };

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
    setSelectedValue(
      items,
      first?.ITEM_NAME,
      first?.ITEM_CLASS_NAME,
      first?.NICK_NAME,
      undefined,
      // 단건 선택일 때만 팀을 넘긴다 — 다건은 어느 팀인지 확정할 수 없다.
      selections.length === 1 ? first?.DEPT_ID : undefined,
      selections.length === 1 ? first?.DEPT_NAME_KO : undefined
    );
    modalClose();
  };

  // ⭐ 더블클릭 = 그 행 하나로 확정 후 닫기 (체크박스 모드 포함 — 2026-08-06 사용자 요청).
  //   구: dblClick={multiCheckbox ? undefined : handleDblClick} 로 체크박스 모드에서 핸들러가
  //   미장착이라 더블클릭해도 부모창에 값이 안 넘어갔다 (OwnerByDivisionModal 동일 조치).
  //   ⚠ 체크박스 모드에서 더블클릭하면 체크해 둔 행들은 무시되고 더블클릭한 행만 전달된다
  //     (여러 건은 체크 후 OK). 단건 선택의 빠른 경로 규약.
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
      dataItem.NICK_NAME,
      undefined,
      dataItem.DEPT_ID,
      dataItem.DEPT_NAME_KO
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
    // 매번 기본값(Product)으로 열린다 — 직전 호출의 선택이 남아 다른 행에 따라붙지 않도록.
    setSelectedItemType(undefined);
    if (!initialized || preSearchParams.divisionId !== divisionId)
      void fetchStaticColumns(preSearchParams.divisionId);
  }, [open]);

  return (
    <CustomDialog
      size={dialogSize}
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
            sx={isNarrowDialog ? { minWidth: 0 } : undefined}
            conditions={
              <>
                {showDivision && (
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
                )}
                {showTeam && (
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
                                // DIVISION_ID 가 공란인 행은 통과시킨다 (SearchFields toOptions
                                // 와 동일 규칙). 엄격 비교만 하면 division 키를 안 채워 주는
                                // 응답에서 목록이 통째로 비어버린다.
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
                )}
                {showEndCustomer && (
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
                )}
                {showSalesSite && (
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
                )}
                {showProject && searchParam.divisionId !== '40' && (
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
                {showModel && (
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
                )}
                {useItemTypeFilter && (
                  <Grid size={4}>
                    <FormItem
                      label={t('LBL00068', '_Item Type')}
                      labelAlign='right'
                      render={() => (
                        <CustomDropdown
                          allOption
                          value={itemType}
                          options={itemTypeOptions}
                          onChange={(_, option) => setSelectedItemType(option)}
                        />
                      )}
                    />
                  </Grid>
                )}
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>>
              gridRef={gridRef}
              isReadOnly
              useCheckbox={multiCheckbox}
              staticColumns={gridStaticColumns}
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
