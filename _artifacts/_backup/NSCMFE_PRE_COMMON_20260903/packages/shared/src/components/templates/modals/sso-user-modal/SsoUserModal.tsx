import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import type { DialogNavigationSize } from '@shared/lges';
import { Grid } from '@shared/mui';

import { POPUP_ID, SHEETS } from './sso-user-modal.constants';
import styles from './SsoUserModal.module.scss';
import { useSsoUserModalStore } from './useSsoUserModalStore';

interface SsoUserModalProps {
  size?: DialogNavigationSize;
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (userId: string, userNm: string, userEngNm: string) => void;
  initialUser?: string;
}

export const SsoUserModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialUser = '',
}: SsoUserModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<POPUP_ID, SHEETS.SSO_USER>> | undefined>();

  const initialized = useSsoUserModalStore(state => state.initialized);
  const staticColumns = useSsoUserModalStore(state => state.staticColumns);
  const fetchStaticColumns = useSsoUserModalStore(state => state.fetchStaticColumns);

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0010 은 user 를 IN
  //   파라미터로 받는다 — configs/types/procedures.d.ts COM0010.ssoUser.request 참고)
  const [searchParam, setSearchParam] = useState<{
    user: string;
  }>({
    user: initialUser,
  });

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [userInput, setUserInput] = useState<string>(initialUser);

  const { data } = useTabProcQuery<POPUP_ID, SHEETS.SSO_USER>({
    menuId: POPUP_ID,
    sheetName: SHEETS.SSO_USER,
    tabId: POPUP_ID,
    filters: searchParam,
    enabled: true,
  });

  // 필터링은 프로시저(user 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => data?.o_rc ?? [], [data]);

  const handleSearch = () => {
    setSearchParam({
      user: userInput,
    });
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.USER_ID, dataItem.USER_NM, dataItem.USER_ENG_NM);

    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      user: initialUser,
    });
    setUserInput(initialUser);
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
          <h2 className='headerTitle'>{t('LBL00352', '_User Popup')}</h2>
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
                  label={t('LBL00339', '_User ID(Name)')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={userInput}
                      onChange={event => setUserInput(event.target.value)}
                      onKeyDown={e => e.key === 'Enter' && handleSearch()}
                    />
                  )}
                  labelSize='long'
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<POPUP_ID, SHEETS.SSO_USER>>
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
