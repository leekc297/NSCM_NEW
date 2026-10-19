import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import type { DialogNavigationSize } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
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
  // 호출 화면 구분값 — COM0010 프로시저 ssoUserYn 파라미터로 전달된다.
  //   Y = SSO 사용자(SCM_MST_SSO_USER_INFO) 기준 — SYS0002 User.
  //   N = 등록 사용자(SCM_ADM_USER_M) 기준 — 기본값, SYS0014 Group User.
  ssoUserYn?: 'Y' | 'N';
}

export const SsoUserModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialUser = '',
  ssoUserYn = 'N',
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
    ssoUserYn: string;
  }>({
    user: initialUser,
    ssoUserYn,
  });

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [userInput, setUserInput] = useState<string>(initialUser);

  const { data, isLoading, isFetching } = useTabProcQuery<POPUP_ID, SHEETS.SSO_USER>({
    menuId: POPUP_ID,
    sheetName: SHEETS.SSO_USER,
    tabId: POPUP_ID,
    filters: searchParam,
    enabled: true,
  });
  const loading = isLoading || isFetching;

  // 필터링은 프로시저(user 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => data?.o_rc ?? [], [data]);

  const handleSearch = () => {
    setSearchParam({
      user: userInput,
      ssoUserYn,
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

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<POPUP_ID, SHEETS.SSO_USER>[];
    if (!selections?.length) return;

    setSelectedValue(selections[0].USER_ID, selections[0].USER_NM, selections[0].USER_ENG_NM);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      user: initialUser,
      ssoUserYn,
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
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <DataGrid<ResponseData<POPUP_ID, SHEETS.SSO_USER>>
              gridRef={gridRef}
              isReadOnly
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
