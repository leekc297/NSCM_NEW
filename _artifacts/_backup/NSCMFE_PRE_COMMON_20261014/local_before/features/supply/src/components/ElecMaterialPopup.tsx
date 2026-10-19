/**
 * Elec Material 팝업 (supply 전용) — AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopupEE.
 *
 * SCP0095(GlobalPSI_Elec) 의 Material 필드(btnItem_Id)가 여는 팝업. 전극(Elec) Material 선택이다.
 * 모1(ModelByDivisionPopup)과 같은 SCM0002 메뉴의 다른 sheet(ElecPopup) — SP·조건·컬럼이 다르다.
 *
 * AS-IS 계약(SCM0002_ItembyDivisionPopupEE.cs):
 *  - Form_Load(multiSelect, division, company, itemId)
 *    → Division 비활성 표시, Company 는 활성(변경 가능), Material Code(itemId) 입력.
 *  - 반환: ItemID(=Material Code), ItemName, NickName, ItemClassName
 *
 * TO-BE 조회(실측 2026-09-16):
 *  - menuId=SCM0002 / sheet=ElecPopup / action=SEARCH → PKG_SCM0002.P_SCM0002_GET_ITEM_ELEC
 *  - 필터: division/company 는 'ALL' 센티널(빈값 0건), company 는 SITE.COMPANY_ID 기준, item 은 LIKE/IN.
 *  - Division 은 AS-IS 대로 '81,82,40'(전극 사업부) 하드코딩으로 넘어온다.
 *  - 그리드 컬럼은 admin 메타(SCM0002/ElecPopup, 7컬럼)에서 가져온다.
 *  - Company 콤보는 COMPANY_EE (CODE=COMPANY_NAME, NAME=COMPANY_ID) — proc 는 COMPANY_ID 로 거르므로
 *    옵션을 {label: CODE(회사명), value: NAME(회사ID)} 로 매핑한다(일반 매핑과 반대).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useElecMaterialPopupStore } from './elecMaterialPopupStore';
import styles from './ModelByDivisionPopup.module.scss';

const ELEC_MENU = 'SCM0002';
const ELEC_SHEET = 'ElecPopup';

// 전극 Material 조회(SP p_division_id)는 AS-IS 대로 division 을 '81,82,40'(전극 사업부)로 고정한다.
//   ※ 조회 전용 — 조회조건 Division 드롭다운은 parent 가 넘긴 값(표시용)을 그대로 보여준다.
const ELEC_QUERY_DIVISION = '81,82,40';

type ElecRow = ResponseData<typeof ELEC_MENU, typeof ELEC_SHEET, 'o_rc1'>;
type ElecFilters = ProcRequest<typeof ELEC_MENU, typeof ELEC_SHEET>;

// AS-IS Form_Load 인자 — 호출 화면에서 하드코딩/조회조건으로 넘긴다.
export interface ElecMaterialPopupParams {
  divisionId?: string;
  companyId?: string;
  itemId?: string;
}

// AS-IS 반환값 (SCM0002_ItembyDivisionPopupEE: ItemID/ItemName/NickName/ItemClassName).
export interface ElecMaterialSelection {
  itemId: string;
  itemName?: string;
  nickName?: string;
  itemClassName?: string;
}

interface ElecMaterialPopupProps {
  open: boolean;
  onClose: () => void;
  onSelect?: (selected: ElecMaterialSelection) => void;
  params?: ElecMaterialPopupParams;
}

export const ElecMaterialPopup = ({
  open,
  onClose,
  onSelect,
  params,
}: ElecMaterialPopupProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ElecRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // 그리드 컬럼은 admin 메타(SCM0002/ElecPopup)에서 가져온다.
  const initialized = useElecMaterialPopupStore(state => state.initialized);
  const staticColumns = useElecMaterialPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useElecMaterialPopupStore(state => state.fetchStaticColumns);

  // 편집 가능한 조건 — Company(드롭다운)·Material Code(입력). Search 시 조회 파라미터에 반영.
  const [companyId, setCompanyId] = useState('');
  const [itemId, setItemId] = useState('');
  const [searchParam, setSearchParam] = useState<ElecFilters>({} as ElecFilters);

  // Division 콤보 — AS-IS 와 동일 소스(SCM0001_GET_DIVISION). 표시용(parent 값 선택), 비활성.
  const [divisions] = useTabComboQueries({ filters: [{ comboId: 'SCM0001_GET_DIVISION' }] });
  // Company 콤보 — 전극 회사 목록(COMPANY_EE). CODE=회사명, NAME=회사ID.
  const [companies] = useTabComboQueries({ filters: [{ comboId: 'COMPANY_EE' }] });

  useEffect(() => {
    if (!open) return;
    const initCompany = params?.companyId || 'ALL';
    setSearchParam({
      // 조회는 전극 사업부 고정('81,82,40') — 화면 표시(Division 드롭다운)와 별개.
      divisionId: ELEC_QUERY_DIVISION,
      companyId: initCompany,
      itemId: params?.itemId ?? '',
    });
    setCompanyId(initCompany);
    setItemId(params?.itemId ?? '');
    if (!initialized) void fetchStaticColumns();
    // 열릴 때만 초기화한다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const {
    data,
    isLoading,
    isFetching,
  } = useTabProcQuery<typeof ELEC_MENU, typeof ELEC_SHEET>({
    menuId: ELEC_MENU,
    sheetName: ELEC_SHEET,
    tabId: 'ElecMaterialPopup',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  // Search/Enter = Company/Material Code 를 조회 파라미터에 반영해 재조회. 빈 company 는 'ALL'.
  const handleSearch = () =>
    setSearchParam(prev => ({ ...prev, companyId: companyId || 'ALL', itemId }));

  const confirm = (row: ElecRow) => {
    onSelect?.({
      itemId: row.ITEM_ID,
      itemName: row.ITEM_NAME,
      nickName: row.NICK_NAME,
      itemClassName: row.ITEM_CLASS_NAME,
    });
    onClose();
  };

  const handleSubmit = () => {
    const selected = gridRef.current?.selectedItems?.[0] as ElecRow | undefined;
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
          <h2 className='headerTitle'>Model by DivisionPopup</h2>
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
                        value={params?.divisionId ?? ''}
                        options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00047', 'Company')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={companyId}
                        // COMPANY_EE: CODE=회사명, NAME=회사ID. proc 는 COMPANY_ID 로 거르므로 value=NAME.
                        options={companies?.map(item => ({ label: item.CODE, value: item.NAME })) ?? []}
                        onChange={(_, value) => setCompanyId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00021', 'Material')}
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
              <DataGrid<ElecRow>
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
