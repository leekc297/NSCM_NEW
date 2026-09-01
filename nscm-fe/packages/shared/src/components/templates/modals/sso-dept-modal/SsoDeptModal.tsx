import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import type { DialogNavigationSize } from '@shared/lges';
import { Grid } from '@shared/mui';

import { SHEETS, POPUP_ID } from './sso-dept-modal.constants';
import styles from './SsoDeptModal.module.scss';
import { useSsoDeptModalStore } from './useSsoDeptModalStore';

interface SsoDeptModalProps {
  size?: DialogNavigationSize;
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (deptId: string, deptNm: string) => void;
  initialDept?: string;
}

export const SsoDeptModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialDept = '',
}: SsoDeptModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<POPUP_ID, SHEETS.SSO_DEPT>> | undefined>();

  const initialized = useSsoDeptModalStore(state => state.initialized);
  const staticColumns = useSsoDeptModalStore(state => state.staticColumns);
  const fetchStaticColumns = useSsoDeptModalStore(state => state.fetchStaticColumns);

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0011 은 department 를
  //   IN 파라미터로 받는다 — configs/types/procedures.d.ts COM0011.ssoDept.request 참고)
  const [searchParam, setSearchParam] = useState<{
    department: string;
  }>({
    department: initialDept,
  });

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [deptInput, setDeptInput] = useState<string>(initialDept);

  const { data } = useTabProcQuery<POPUP_ID, SHEETS.SSO_DEPT>({
    menuId: POPUP_ID,
    sheetName: SHEETS.SSO_DEPT,
    tabId: POPUP_ID,
    filters: searchParam,
    enabled: true,
  });

  // 필터링은 프로시저(department 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => data?.o_rc ?? [], [data]);

  const handleSearch = () => {
    setSearchParam({
      department: deptInput,
    });
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.DEPT_ID, dataItem.DEPT_NM);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      department: initialDept,
    });
    setDeptInput(initialDept);
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={size}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00353', '_Dept Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00722', '_Search')}
            onSearch={handleSearch}
            conditions={
              <Grid size={8}>
                <FormItem
                  label={t('LBL00338', '_Dept ID(Name)')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={deptInput}
                      onChange={event => setDeptInput(event.target.value)}
                      onKeyDown={e => e.key === 'Enter' && handleSearch()}
                    />
                  )}
                  labelSize='long'
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<POPUP_ID, SHEETS.SSO_DEPT>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
        </div>
      }
    />
  );
};
