/**
 * Material by Division 공용 팝업 (AS-IS SCM0002_MaterialByDivisionPopup, SCP 27개 화면 공용).
 *
 * 주의: ItemByDivisionModal 과 서로 바꿔 쓰지 말 것. 겉모습은 같은 "Division 스코프 선택 팝업"
 *   이지만 호출 SP·조회조건·그리드 컬럼이 다르다. 잘못 쓰면 에러 없이 다른 목록이 나온다.
 *   화면 변환 시 필드명(txtItemId)·모양으로 추정하지 말고 AS-IS 버튼 핸들러가 실제로 new 하는
 *   팝업 클래스명으로 고른다:
 *     new SCM0002_MaterialByDivisionPopup -> MaterialByDivisionModal (menuId COM0013)  [이 파일]
 *     new DM0002_ItembyDivisionPopup(Ex)  -> ItemByDivisionModal     (menuId COM0008)
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { buildNoColumn, GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { SEARCH_POPUP_WIDTH } from '../searchFields/SearchFields.utils';

import {
  MODAL_MATERIAL_BY_DIVISION,
  MODAL_SHEET_MATERIAL_BY_DIVISION,
} from './material-by-division-modal.constants';
import styles from './MaterialByDivisionModal.module.scss';
import { useMaterialByDivisionModalStore } from './materialByDivisionModalStore';

interface MaterialByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  /**
   * 선택 확정 콜백. AS-IS SetItem 이 넘기던 값과 같은 순서:
   * (Material Code, Description, Class Name, Nickname). 다건 선택 시 Code 는 콤마 결합, 나머지는 첫 행.
   */
  setSelectedValue: (
    items: string,
    itemName?: string,
    itemClassName?: string,
    nickName?: string
  ) => void;
  /**
   * 열 때 넘기는 조회 파라미터.
   * - divisionId: 호출 화면의 Division(단일). 팝업에서 비활성 표시.
   * - scpModuleType: 호출 화면 ID(예: 'SCP0022'). SP 의 Operation Group 분기 기준.
   * - operationGroup: 대개 빈값(호출 화면이 지정하지 않음). 비활성 표시.
   * - itemId: 초기 Material 검색어(대개 빈값).
   */
  preSearchParams: ProcRequest<MODAL_MATERIAL_BY_DIVISION, MODAL_SHEET_MATERIAL_BY_DIVISION>;
  /** 호출처 헤더 title 커스터마이즈(옵션). 기본 'Material by Division'. */
  headerTitle?: string;
  /** 멀티 선택 모드(옵션, default false). true 시 체크박스 컬럼으로 선택. */
  multiCheckbox?: boolean;
  /**
   * Division 검색조건 멀티 표시 모드(옵션, default false).
   * false 면 호출 화면의 단일 divisionId 를 disabled 로 고정 표시(AS-IS SCM0002 계약, 27개+ 화면 공용 기본값).
   * true 면 호출 화면이 넘긴 콤마 결합 divisionId(멀티 조회조건)를 멀티 컨트롤로 그대로 disabled 표시한다.
   *   두 모드 모두 Division 은 disabled(읽기전용, 호출값 미러) — 차이는 단일/멀티 표시뿐이다.
   *   콤보(MyDivision)·조회 SP(PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)는 변경 불필요:
   *   SP 가 P_DIVISION_ID 를 REGEXP_SUBSTR 콤마 split → IN 처리하고, CustomDropdown 멀티도 콤마 문자열을 받는다.
   */
  multiDivision?: boolean;
  /** 팝업 가로 폭(px, 옵션). */
  dialogSize?: number;
}

const DEFAULT_DIALOG_SIZE = SEARCH_POPUP_WIDTH;

export const MaterialByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  headerTitle,
  multiCheckbox = false,
  multiDivision = false,
  dialogSize = DEFAULT_DIALOG_SIZE,
}: MaterialByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<
      FlexGrid<
        ResponseData<MODAL_MATERIAL_BY_DIVISION, MODAL_SHEET_MATERIAL_BY_DIVISION, 'o_rc1'>
      >
    >();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useMaterialByDivisionModalStore(state => state.initialized);
  const staticColumns = useMaterialByDivisionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useMaterialByDivisionModalStore(state => state.fetchStaticColumns);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_MATERIAL_BY_DIVISION, MODAL_SHEET_MATERIAL_BY_DIVISION>
  >({} as ProcRequest<MODAL_MATERIAL_BY_DIVISION, MODAL_SHEET_MATERIAL_BY_DIVISION>);
  const [itemId, setItemId] = useState<string>();

  const {
    data: itemData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_MATERIAL_BY_DIVISION>({
    menuId: MODAL_MATERIAL_BY_DIVISION,
    sheetName: MODAL_SHEET_MATERIAL_BY_DIVISION,
    tabId: 'MaterialByDivisionModal',
    filters: searchParam,
    enabled: open && !!searchParam.divisionId,
  });
  const loading = isLoading || isFetching;

  // 매 렌더 새 배열이면 그리드 re-bind → 체크 선택 풀림. itemData 변경 시에만 재계산.
  const rows = useMemo(() => withRowNo(itemData?.o_rc1 ?? []), [itemData]);

  const gridStaticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', 'No')), ...staticColumns],
    [staticColumns, t]
  );

  // Search 버튼/Enter = 프로시저 재조회(입력한 Material 검색어를 조건에 실어 다시 조회).
  const handleSearch = () => {
    setSearchParam(prev => ({ ...prev, itemId: itemId ?? '' }));
  };

  const emit = (row?: {
    ITEM_ID?: string;
    ITEM_NAME?: string;
    ITEM_CLASS_NAME?: string;
    NICK_NAME?: string;
  }) => {
    setSelectedValue(
      row?.ITEM_ID ?? '',
      row?.ITEM_NAME,
      row?.ITEM_CLASS_NAME,
      row?.NICK_NAME
    );
  };

  const handleSubmit = () => {
    if (multiCheckbox) {
      const grid = gridRef.current;
      if (!grid) return;
      const selected: {
        ITEM_ID?: string;
        ITEM_NAME?: string;
        ITEM_CLASS_NAME?: string;
        NICK_NAME?: string;
      }[] = [];
      for (const row of grid.rows) {
        const it = row?.dataItem as { ITEM_ID?: string } | undefined;
        if (row?.isSelected && it?.ITEM_ID) selected.push(it);
      }
      const items = selected.map(it => it.ITEM_ID).join(',');
      // Code 는 콤마 결합, 나머지 부가값은 첫 행 기준(AS-IS SetItem 다중선택 규약).
      setSelectedValue(items, selected[0]?.ITEM_NAME, selected[0]?.ITEM_CLASS_NAME, selected[0]?.NICK_NAME);
      modalClose();
      return;
    }

    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_MATERIAL_BY_DIVISION,
      MODAL_SHEET_MATERIAL_BY_DIVISION,
      'o_rc1'
    >[];
    if (!selections) return;
    const items = selections.map(item => item.ITEM_ID).join(',');
    const first = selections[0];
    setSelectedValue(items, first?.ITEM_NAME, first?.ITEM_CLASS_NAME, first?.NICK_NAME);
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기(AS-IS spdMain_CellDoubleClick).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    emit(dataItem);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: preSearchParams.divisionId,
      operationGroup: preSearchParams.operationGroup ?? '',
      itemId: preSearchParams.itemId ?? '',
      scpModuleType: preSearchParams.scpModuleType,
    });
    setItemId(preSearchParams.itemId);
    if (!initialized) void fetchStaticColumns();
    // 열 때마다 preSearchParams 로 초기화. open 만 의존.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  return (
    <CustomDialog
      size={dialogSize}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업이 MuiDialog-container 밖에 append 돼 FocusTrap 과 충돌하는 것 방지.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>
            {headerTitle ?? t('LBL_MATERIAL_BY_DIVISION_POPUP', 'Material by Division')}
          </h2>
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
                    render={() =>
                      // multiDivision 옵트인: 콤마 결합 divisionId 를 멀티 컨트롤로 disabled 표시.
                      //   단일 모드와 동일하게 읽기전용(호출 화면 조회조건 미러) — 표시만 멀티다.
                      //   CustomDropdown 멀티는 콤마 결합 문자열을 value 로 받으므로 그대로 넘긴다.
                      // 미옵트인(기본): 단일 divisionId 를 disabled 고정 표시(AS-IS 계약).
                      multiDivision ? (
                        <CustomDropdown
                          multiple
                          mandatory
                          disabled
                          value={searchParam?.divisionId ?? ''}
                          options={
                            divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                          }
                        />
                      ) : (
                        <CustomDropdown
                          mandatory
                          disabled
                          value={searchParam?.divisionId ?? ''}
                          options={
                            divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                          }
                        />
                      )
                    }
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL_OPERATION_GROUP', 'Operation Group')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={searchParam.operationGroup ?? ''} />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00021', '_Material')}
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
              <DataGrid<
                ResponseData<MODAL_MATERIAL_BY_DIVISION, MODAL_SHEET_MATERIAL_BY_DIVISION>
              >
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox={multiCheckbox}
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
