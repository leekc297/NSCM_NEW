/**
 * Model by Division 팝업 (공통 base) — AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyDivisionPopup.
 *
 * SCP0016(WaterfallShipmentPlanFG) 의 "Model" 필드(btnItem_Id)가 여는 팝업이다. 화면 라벨은
 * "Model" 이지만 실체는 Item(=Model) 선택이다. 공통 ItemByDivisionModal(COM0008, AS-IS
 * DM0002_ItembyDivisionPopup)과는 다른 팝업 — 조회조건·컬럼·SP 가 다르므로 supply 자체로 둔다.
 *
 * AS-IS 계약(SCM0002_ItembyDivisionPopup.cs):
 *  - Form_Load(bMultiSelect, division, scmSiteId, project, itemId)
 *    → Division / Project / SCM Site 는 호출 화면 값으로 비활성 표시, Model Code(itemId)만 입력.
 *  - 반환: ItemID(=Model Code), ItemName, ItemType, NickName, ItemClassName
 *
 * TO-BE 조회(실측 2026-09-16):
 *  - menuId=SCM0002 / sheet=ModelPopup / action=SEARCH
 *    → PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP
 *  - 그리드 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS: SCM0002/ModelPopup, base 11컬럼)에서 가져온다.
 *    기존 SCM0002/ItemPopup(=Ex 변형)은 별개 — 건드리지 않는다.
 *  - 필터: division/scmSite 는 'ALL' 센티널(빈값이면 0건), project/item 은 LIKE 부분일치(빈값=전체).
 *    호출 화면이 빈 scmSite 를 넘겨도 조회는 'ALL' 로 보정한다(표시용 필드는 원래 값 유지).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import styles from './ModelByDivisionPopup.module.scss';
import { useModelByDivisionPopupStore } from './modelByDivisionPopupStore';

const MODEL_MENU = 'SCM0002';
const MODEL_SHEET = 'ModelPopup';

type ModelRow = ResponseData<typeof MODEL_MENU, typeof MODEL_SHEET, 'o_rc1'>;
type ModelFilters = ProcRequest<typeof MODEL_MENU, typeof MODEL_SHEET>;

// AS-IS Form_Load 인자 — 호출 화면에서 하드코딩/조회조건으로 넘긴다.
export interface ModelByDivisionPopupParams {
  divisionId?: string;
  projectCode?: string;
  scmSiteId?: string;
  itemId?: string;
}

// AS-IS 반환값 (SCM0002_ItembyDivisionPopup: ItemID/ItemName/ItemType/NickName/ItemClassName).
export interface ModelSelection {
  itemId: string;
  itemName?: string;
  itemType?: string;
  nickName?: string;
  itemClassName?: string;
}

interface ModelByDivisionPopupProps {
  open: boolean;
  onClose: () => void;
  onSelect?: (selected: ModelSelection) => void;
  params?: ModelByDivisionPopupParams;
  /**
   * 다중선택 opt-in (기본 false = 기존 단일선택). AS-IS `Form_Load` 첫 인자 bMultiSelect 자리다.
   *
   * true 면 체크박스 열이 생기고, OK 가 체크된 행들을 AS-IS 와 같은 규약으로 돌려준다 —
   * `SetItem()`(SCM0002_ItembyDivisionPopup.cs:330~357)이 선택행을 필드별로 ',' 로 이어
   * ItemID/ItemName/ItemType/NickName/ItemClassName 에 담는 그 형식이다(행 수만큼 토큰, 위치 대응).
   * 호출 화면은 받은 itemId 를 그대로 조회조건에 넣으면 된다(콤마 목록은 각 화면 GET SP 의 몫).
   *
   * 미지정 호출처(SCP0016/SSP0024 등 기존 4화면)는 동작·반환이 그대로다 — 회귀 0.
   */
  multiSelect?: boolean;
}

export const ModelByDivisionPopup = ({
  open,
  onClose,
  onSelect,
  params,
  multiSelect = false,
}: ModelByDivisionPopupProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ModelRow>>();
  // ResultArea 가 헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // 그리드 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS / SCM0002·ModelPopup)에서 가져온다.
  const initialized = useModelByDivisionPopupStore(state => state.initialized);
  const staticColumns = useModelByDivisionPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useModelByDivisionPopupStore(state => state.fetchStaticColumns);

  // Model Code 입력값(팝업에서 유일하게 편집 가능한 조건).
  const [itemId, setItemId] = useState('');
  // 실제 조회 파라미터 — Search/Enter(그리고 오픈) 시에만 갱신하고 그때 프로시저를 재조회한다.
  const [searchParam, setSearchParam] = useState<ModelFilters>({} as ModelFilters);

  // 조회조건 드롭다운 — AS-IS SCM0002_ItembyDivisionPopup 과 동일한 소스로 호출한다(공통 콤보 미사용).
  //   Div  ← SCM0001_GET_DIVISION (파라미터 없음)
  //   Site ← SCM0001_GET_SITE_BY_DIVISION (param: division), 다중선택
  //   ※ 두 조건 모두 AS-IS 에서 비활성(호출 화면 값 표시) — 콤보는 code→name 표시용.
  //   ※ BE makeComboQuery 는 raw 문자열 치환이라 divisionId 는 작은따옴표로 감싸 넘긴다.
  const [divisions] = useTabComboQueries({ filters: [{ comboId: 'SCM0001_GET_DIVISION' }] });
  const [sites] = useTabComboQueries({
    filters: [
      { comboId: 'SCM0001_GET_SITE_BY_DIVISION', divisionId: `'${searchParam.divisionId ?? ''}'` },
    ],
  });

  // 팝업이 열릴 때마다 호출 화면 파라미터로 초기화한다.
  //   division/scmSite 빈값은 'ALL' 센티널로 보정(빈 문자열이면 SP 가 0건).
  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: params?.divisionId || 'ALL',
      scmSiteId: params?.scmSiteId || 'ALL',
      projectCode: params?.projectCode ?? '',
      itemId: params?.itemId ?? '',
    });
    setItemId(params?.itemId ?? '');
    // initialized 가 과거의 빈 조회 결과를 영속(sessionStorage)해 컬럼이 비어버리는 경우가 있어
    // (예: admin 메타 유실 중 한 번 열림), 컬럼이 비어 있으면 재조회한다.
    if (!initialized || staticColumns.length === 0) void fetchStaticColumns();
    // 열릴 때만 초기화한다 — 열려 있는 동안 params 변화로 입력값을 덮지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const {
    data,
    isLoading,
    isFetching,
  } = useTabProcQuery<typeof MODEL_MENU, typeof MODEL_SHEET>({
    menuId: MODEL_MENU,
    sheetName: MODEL_SHEET,
    tabId: 'ModelByDivisionPopup',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 선택이 풀린다.
  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  // Search/Enter = 프로시저 재조회(SP 가 Model Code 부분일치를 처리한다).
  const handleSearch = () => setSearchParam(prev => ({ ...prev, itemId }));

  const confirm = (row: ModelRow) => {
    onSelect?.({
      itemId: String(row.ITEM_ID ?? ''),
      itemName: String(row.ITEM_NAME ?? ''),
      itemType: String(row.ITEM_TYPE ?? ''),
      nickName: String(row.NICK_NAME ?? ''),
      itemClassName: String(row.ITEM_CLASS_NAME ?? ''),
    });
    onClose();
  };

  // 다중선택 확정 — AS-IS SetItem() 다중 분기(cs:330~357) 이식: 체크행을 필드별로 ',' 로 잇는다.
  //   토큰은 중복 제거하지 않는다(행 수 = 토큰 수, 필드 간 위치 대응) — AS-IS 누적과 동일.
  const confirmMany = (picked: ModelRow[]) => {
    const join = (field: keyof ModelRow) =>
      picked.map(row => String(row[field] ?? '')).join(',');
    onSelect?.({
      itemId: join('ITEM_ID'),
      itemName: join('ITEM_NAME'),
      itemType: join('ITEM_TYPE'),
      nickName: join('NICK_NAME'),
      itemClassName: join('ITEM_CLASS_NAME'),
    });
    onClose();
  };

  const handleSubmit = () => {
    if (multiSelect) {
      // 체크행 수집(useCheckbox 모드의 row.isSelected). AS-IS 는 선택 0건이면 조용히 return 한다(cs:361~366).
      const picked: ModelRow[] = [];
      for (const row of gridRef.current?.rows ?? []) {
        if (row?.isSelected) picked.push(row.dataItem as ModelRow);
      }
      if (picked.length === 0) return;
      confirmMany(picked);
      return;
    }
    const selected = gridRef.current?.selectedItems?.[0] as ModelRow | undefined;
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
                        allOption
                        disabled
                        value={String(searchParam.divisionId ?? '')}
                        options={divisions?.map(item => ({ label: item.NAME, value: String(item.CODE) })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00617', 'Project')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={params?.projectCode ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00015', 'Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={params?.scmSiteId ?? ''}
                        options={sites?.map(item => ({ label: item.NAME, value: String(item.CODE) })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00669', 'Model')}
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
              <DataGrid<ModelRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                // 다중선택 opt-in 일 때만 체크박스 열(기본 호출처는 종전 단일선택 그대로).
                useCheckbox={multiSelect}
                staticColumns={staticColumns}
                itemsSource={rows}
                // 더블클릭 = 그 행 하나로 확정(다중 모드에서도 단건 빠른 경로 — ItemByDivisionModal 동형).
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
