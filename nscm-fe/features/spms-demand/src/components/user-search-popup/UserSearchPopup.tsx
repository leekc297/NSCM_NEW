import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, InputField, ProgressIndicator } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore, useTabid } from '@shared/stores';

import { collectCheckedRows, DataGrid, restoreMultiRangeSelection } from '../../lib/grid';
import {
  MENU_ID,
  RESPONSE_SET,
  SHEETS,
} from '../../pages/project-registration/project-registration.constants';
import type {
  OrgTreeRow,
  PopupUserRow,
} from '../../pages/project-registration/project-registration.types';
import {
  buildOrgTree,
  collectDeptPathIds,
} from '../auth-management-popup/authManagementPopup.utils';
import { OrgTree } from '../auth-management-popup/OrgTree';
import { useAuthManagementPopupStore } from '../auth-management-popup/useAuthManagementPopupStore';

import styles from './UserSearchPopup.module.scss';

interface UserSearchPopupProps {
  open: boolean;
  onClose: () => void;
  /** 선택 확정(Checked+OK 또는 더블클릭) 시 한 명의 사용자를 넘긴다 */
  onSelect: (user: PopupUserRow) => void;
}

// SPMS 공용 사용자 검색 팝업 — 조직도(부서 트리) + 사용자 목록에서 **한 명**을 고른다.
// 조직/사용자 조회는 AuthManagementPopup 과 동일하게 SDM1010 POPUP_ORG/POPUP_USER 시트를
// 재사용한다(팝업 SP·컬럼 메타 소유 = SDM1010 — 재사용 화면에서 MENU_ID 를 바꾸지 않는다).
// §확인 사항: 1.1 사용자는 한 명만 선택(마지막 Checked 한 개만 유지) /
//   1.2 선택(Checked)&OK 또는 행 더블클릭 = 동일 동작(선택 확정 + 닫기).
export const UserSearchPopup = ({ open, onClose, onSelect }: UserSearchPopupProps) => {
  const { t } = useTranslation();
  const tabId = useTabid();
  const setAlert = useMessageStore(state => state.setAlert);
  const sesDivisionId = useSessionStore(state => state.session.div ?? '');
  const sesUserId = useSessionStore(state => state.session.userId ?? '');

  // 컬럼 메타는 AuthManagementPopup 스토어 재사용 — 같은 POPUP_USER 시트 메타를 쓴다.
  const initialized = useAuthManagementPopupStore(state => state.initialized);
  const staticColumns = useAuthManagementPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useAuthManagementPopupStore(state => state.fetchStaticColumns);

  const userGridRef = useRef<FlexGridType<PopupUserRow>>();
  const [selectedDeptId, setSelectedDeptId] = useState('');
  const [userKeyword, setUserKeyword] = useState('');
  const [appliedUserKeyword, setAppliedUserKeyword] = useState('');

  const orgFilters = useMemo(() => ({ sesDivisionId, sesUserId }), [sesDivisionId, sesUserId]);
  const userFilters = useMemo(
    () => ({ userInfo: appliedUserKeyword, deptId: selectedDeptId, sesDivisionId, sesUserId }),
    [appliedUserKeyword, selectedDeptId, sesDivisionId, sesUserId]
  );
  const hasUserCondition = !!selectedDeptId || !!appliedUserKeyword;

  const { data: orgData, isFetching: isOrgFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP_ORG>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_ORG,
    tabId,
    filters: orgFilters,
    enabled: open && !!sesDivisionId && !!sesUserId,
    queryOptions: { staleTime: 0 },
  });
  // 세션 사용자의 부서 — 조직도 기본 선택/펼침 기준 (AuthManagementPopup 동일)
  const sesDeptId = String(
    ((orgData?.orgList as unknown as OrgTreeRow[] | undefined) ?? [])[0]?.SES_DEPT_ID ?? ''
  ).trim();
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.POPUP_USER>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_USER,
    tabId,
    filters: userFilters,
    enabled: open && !!sesDivisionId && !!sesUserId && hasUserCondition,
  });

  useEffect(() => {
    if (!open) return;
    if (!initialized) void fetchStaticColumns();
  }, [open, initialized, fetchStaticColumns]);

  // 열 때(재오픈 포함) 조건·체크 리셋 — 부서는 세션 사용자 부서로 시작
  useEffect(() => {
    if (!open) return;
    setSelectedDeptId(sesDeptId);
    setUserKeyword('');
    setAppliedUserKeyword('');
    userGridRef.current?.rows.forEach(row => {
      row.isSelected = false;
    });
  }, [open, sesDeptId]);

  const orgTree = useMemo(
    () => buildOrgTree((orgData?.orgList as unknown as OrgTreeRow[] | undefined) ?? [], sesDeptId),
    [orgData, sesDeptId]
  );
  const defaultExpandedDeptIds = useMemo(
    () => collectDeptPathIds(orgTree, sesDeptId),
    [orgTree, sesDeptId]
  );
  // 참조 고정 — 매 렌더 새 배열이면 DataGrid 가 컬렉션을 리로드해 깜빡인다
  const userRows = useMemo<PopupUserRow[]>(
    () =>
      hasUserCondition ? ((userData?.userList as unknown as PopupUserRow[] | undefined) ?? []) : [],
    [hasUserCondition, userData]
  );

  // 선택 확정 — 최신 onSelect/onClose 를 ref 로 참조 (initialized 핸들러는 그리드당 1회 등록)
  const pickRef = useRef<(user: PopupUserRow) => void>(() => undefined);
  pickRef.current = user => {
    onSelect(user);
    onClose();
  };

  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    restoreMultiRangeSelection(grid);
    const g = grid as FlexGridType<PopupUserRow>;
    // §1.1.1 — 공용 Selector 가 체크를 토글한 다음 틱에 "마지막 한 개만" 남긴다.
    //   셀 클릭 등 체크 수가 늘지 않는 클릭은 건드리지 않는다(1개 이하 = 그대로).
    //   헤더 전체선택은 클릭 행이 없어 전부 해제된다 — 단일 선택 팝업이라 의도된 동작.
    g.hostElement.addEventListener('click', ev => {
      const ht = g.hitTest(ev);
      setTimeout(() => {
        const checkedRows = g.rows.filter(row => row.isSelected);
        if (checkedRows.length <= 1) return;
        const keep =
          ht.row >= 0 && (ht.panel === g.rowHeaders || ht.panel === g.cells)
            ? g.rows[ht.row]
            : undefined;
        checkedRows.forEach(row => {
          if (row !== keep) row.isSelected = false;
        });
        g.invalidate();
      });
    });
    // §1.2.1 — 더블클릭 = 선택(Checked)&OK 동일 동작
    g.hostElement.addEventListener('dblclick', ev => {
      const ht = g.hitTest(ev);
      if (ht.panel !== g.cells || ht.row < 0) return;
      const user = g.rows[ht.row]?.dataItem as PopupUserRow | undefined;
      if (user) pickRef.current(user);
    });
  }, []);

  const handleSelectDept = (deptId: string) => {
    setSelectedDeptId(deptId);
    setUserKeyword('');
    setAppliedUserKeyword('');
  };

  const handleSearchUser = () => {
    const keyword = userKeyword.trim();
    if (!keyword) {
      void setAlert({
        type: 'alert',
        content: t('MSG00717', '_사용자ID 혹은 이름을 입력해주세요.'),
      });
      return;
    }
    setSelectedDeptId('');
    setAppliedUserKeyword(keyword);
  };

  const handleOk = () => {
    const checked = collectCheckedRows<PopupUserRow>(userGridRef.current);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    pickRef.current(checked[0]);
  };

  return (
    <CustomDialog
      open={open}
      size={680}
      height={640}
      disableScale
      type='modal'
      position='basic'
      handleClose={onClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* i18n 코드 미채번 — 임의 채번 금지 관행상 리터럴 (T-3 계열) */}
          <h2 className='headerTitle'>사용자 조회</h2>
        </div>
      }
      customContentArea={
        <div className={styles.wrapper}>
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={isOrgFetching}
            placement='parent'
          />
          <div className={styles.searchBar}>
            <div className={styles.userSearch}>
              <span>{t('LBL00339', '_User ID(Name)')}</span>
              <InputField
                value={userKeyword}
                onChange={event => setUserKeyword(event.target.value)}
                onKeyDown={event => {
                  if (event.key === 'Enter') handleSearchUser();
                }}
              />
              <Button
                appearance='contained'
                priority='normal'
                size='medium'
                iconComponent={<FunctionSearchIcon appearance='lined' iconSize={20} />}
                onClick={handleSearchUser}
              >
                {t('LBL00664', 'Search')}
              </Button>
            </div>
          </div>
          <div className={styles.workspace}>
            <div className={styles.orgTreePanel}>
              <OrgTree
                nodes={orgTree}
                onSelect={handleSelectDept}
                defaultExpandedDeptIds={defaultExpandedDeptIds}
                className={styles.orgTree}
              />
            </div>
            <div className={styles.userPanel}>
              <div className={styles.panelTitle}>{t('LBL00866', '_User List')}</div>
              {/* DataGrid(memo) — itemsSource/initialized 참조 고정 전제 (userRows useMemo ✓) */}
              <DataGrid<PopupUserRow>
                gridRef={userGridRef}
                itemsSource={userRows}
                staticColumns={staticColumns[RESPONSE_SET.POPUP_USER]}
                useCheckbox
                isReadOnly
                initialized={handleGridInitialized}
              />
            </div>
          </div>
          {/* 저장 없이 닫기는 헤더 X — 하단은 OK 단독 (AuthManagementPopup 동일) */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
