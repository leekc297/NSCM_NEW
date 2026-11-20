/**
 * Item by Plant Site 공용 팝업 (AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyPlantSitePopup, menuId COM0014).
 *
 * AS-IS 에서 이 팝업을 쓰는 화면은 셋 — SCP0036 JigItem / SCP0037 OperationLT / SSP0100 LTManagement.
 *   전부 그리드 셀(ITEM_ID) 더블클릭에서 열며, 클릭 행의 division + SCM_SITE_ID 로 좁혀 조회한다.
 *   Div·SCM Site 는 AS-IS 가 Enabled=false 로 고정 표시(L162/164)하고 Item 텍스트만 입력받는다 →
 *   여기서도 Div/SCM Site 는 비활성 표시, Item 만 조회 입력으로 둔다.
 *
 * 주의: ItemByDivisionModal(COM0008)·MaterialByDivisionModal(COM0013) 과 바꿔 쓰지 말 것 — SP·조회조건·컬럼이 다르다.
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog, ResultArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { SEARCH_POPUP_WIDTH } from '../searchFields/SearchFields.utils';

import {
  ITEM_BY_PLANT_SITE_COLUMNS,
  MODAL_ITEM_BY_PLANT_SITE,
  MODAL_SHEET_ITEM_BY_PLANT_SITE,
} from './item-by-plant-site-modal.constants';
import styles from './ItemByPlantSiteModal.module.scss';
import { useItemByPlantSiteModalStore } from './itemByPlantSiteModalStore';

interface ItemByPlantSiteModalProps {
  open: boolean;
  modalClose: () => void;
  // 선택 결과 — AS-IS 는 ItemID/NickName 을 돌려준다. COM0008 과 같은 인자 순서(단건)로 맞춰
  //   호출처가 동일 핸들러 형태로 받을 수 있게 한다.
  setSelectedValue: (
    itemId: string,
    itemName?: string,
    itemClassName?: string,
    itemType?: string,
    nickName?: string
  ) => void;
  preSearchParams: ProcRequest<MODAL_ITEM_BY_PLANT_SITE, MODAL_SHEET_ITEM_BY_PLANT_SITE>;
  // 호출 화면별 헤더 title 커스터마이즈(옵션). 기본값 'Item by Plant Site Popup'.
  headerTitle?: string;
}

export const ItemByPlantSiteModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  headerTitle,
}: ItemByPlantSiteModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<
      FlexGrid<ResponseData<MODAL_ITEM_BY_PLANT_SITE, MODAL_SHEET_ITEM_BY_PLANT_SITE, 'o_rc1'>>
    >();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useItemByPlantSiteModalStore(state => state.initialized);
  const staticColumns = useItemByPlantSiteModalStore(state => state.staticColumns);
  const divisionId = useItemByPlantSiteModalStore(state => state.divisionId);
  const fetchStaticColumns = useItemByPlantSiteModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_ITEM_BY_PLANT_SITE, MODAL_SHEET_ITEM_BY_PLANT_SITE>
  >({} as ProcRequest<MODAL_ITEM_BY_PLANT_SITE, MODAL_SHEET_ITEM_BY_PLANT_SITE>);
  const [itemId, setItemId] = useState<string>();

  // Div / Site 콤보 — AS-IS SCM0002_ItembyPlantSitePopup 와 동일 소스(둘 다 비활성 표시, 넘어온 값 선택).
  //   Div  = SCM0001_GET_DIVISION (AS-IS GetDivision, 파라미터 없음·권한/EE 필터 없는 전체 division)
  //   Site = SCM0001_GET_FROM_SITE_BY_DIVISION (AS-IS GetDivisionbyScmSite, divisionId cascade)
  //   divisionId 는 BE makeComboQuery raw 치환이라 작은따옴표를 포함해 넘긴다(공통 콤보 계약).
  const [divisions, sites] = useTabComboQueries({
    filters: [
      { comboId: 'SCM0001_GET_DIVISION' },
      {
        comboId: 'SCM0001_GET_FROM_SITE_BY_DIVISION',
        divisionId: `'${searchParam.divisionId ?? ''}'`,
      },
    ],
  });

  const {
    data: itemData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_ITEM_BY_PLANT_SITE>({
    menuId: MODAL_ITEM_BY_PLANT_SITE,
    sheetName: MODAL_SHEET_ITEM_BY_PLANT_SITE,
    tabId: 'ItemByPlantSiteModal',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo(itemData?.o_rc1 ?? []), [itemData]);

  // admin 컬럼 메타(SHEET_COLUMNS, PROGRAM_ID=COM0012) 우선, 미배포면 constants 고정 컬럼 fallback.
  //   (admin 우선 + constants fallback 공통 패턴.)
  const gridStaticColumns = useMemo(() => {
    const noColumn = buildNoColumn(t('LBL00674', 'No'));
    if (staticColumns.length > 0) return [noColumn, ...staticColumns];

    const fallback = ITEM_BY_PLANT_SITE_COLUMNS.map(
      (col): RawFlexGridColumnConfig => ({
        colNm: col.colNm,
        colLblNm: col.colLblNm,
        colWth: col.colWth,
        horzAlgnCd: col.colNm === 'DIVISION_ID' || col.colNm === 'ITEM_TYPE' ? 'C' : 'L',
        display: true,
        visible: true,
        // 그룹 라벨을 자기 라벨로 맞춰 2/3단 헤더 분할을 막는다(COM0008 동일 처리).
        sClsLblNm: col.colLblNm,
        lClsLblNm: col.colLblNm,
      })
    );
    return [noColumn, ...fallback];
  }, [staticColumns, t]);

  // Item 검색어로 재조회(Search/Enter). SP 가 ITEM_ID/ITEM_NAME LIKE 로 거른다.
  const handleSearch = () => {
    setSearchParam(prev => ({ ...prev, itemId: itemId ?? '' }));
  };

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_ITEM_BY_PLANT_SITE,
      MODAL_SHEET_ITEM_BY_PLANT_SITE,
      'o_rc1'
    >[];
    const first = selections?.[0];
    if (!first) return;
    setSelectedValue(
      first.ITEM_ID,
      first.ITEM_NAME,
      first.ITEM_CLASS_NAME,
      first.ITEM_TYPE,
      first.NICK_NAME
    );
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기.
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
      dataItem.ITEM_TYPE,
      dataItem.NICK_NAME
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    // division·scmSite 는 SP 가 ='ALL' OR IN(...) 로 가드하므로 빈값은 'ALL' 센티널로 보낸다.
    //   item 은 LIKE '%'||..||'%' 라 빈값=전체. assignYn 은 호출처 지정값(미지정 시 '' = 우선순위 미적용).
    setSearchParam({
      divisionId: preSearchParams.divisionId || 'ALL',
      scmSiteId: preSearchParams.scmSiteId || 'ALL',
      itemId: preSearchParams.itemId ?? '',
      assignYn: preSearchParams.assignYn ?? '',
    });
    setItemId(preSearchParams.itemId);
    if (!initialized || preSearchParams.divisionId !== divisionId)
      void fetchStaticColumns(preSearchParams.divisionId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  return (
    <CustomDialog
      size={SEARCH_POPUP_WIDTH}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{headerTitle ?? 'Item by DivisionPopup'}</h2>
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
                    label={t('LBL00015', '_Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={searchParam?.scmSiteId ?? ''}
                        options={sites?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL01142', '_Item')}
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
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<ResponseData<MODAL_ITEM_BY_PLANT_SITE, MODAL_SHEET_ITEM_BY_PLANT_SITE>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                headersVisibility={HeadersVisibility.Column}
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
