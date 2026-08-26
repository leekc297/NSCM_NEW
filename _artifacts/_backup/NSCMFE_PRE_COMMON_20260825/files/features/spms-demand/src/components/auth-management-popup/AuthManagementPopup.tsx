import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';

import { BUTTON_TYPE, CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, InputField, ProgressIndicator } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore, useTabid } from '@shared/stores';

import {
  MENU_ID,
  RESPONSE_SET,
  SHEETS,
} from '../../pages/project-registration/project-registration.constants';
import { collectCheckedRows } from '../../pages/project-registration/project-registration.grid-utils';
import type {
  AuthMgmtUserRow,
  AuthRequestRow,
  OrgTreeRow,
  PopupUserRow,
} from '../../pages/project-registration/project-registration.types';
import { AUTH_TYPE } from '../../pages/project-registration/project-registration.types';

import styles from './AuthManagementPopup.module.scss';
import { buildOrgTree } from './authManagementPopup.utils';
import { OrgTree } from './OrgTree';
import { useAuthManagementPopupStore } from './useAuthManagementPopupStore';

export interface AuthManagementTarget {
  pjtKey: string;
  projectName: string;
}

interface AuthManagementPopupProps extends AuthManagementTarget {
  open: boolean;
  onClose: () => void;
  onSaved: () => void;
}

type RequestDecision = (typeof AUTH_TYPE)[keyof typeof AUTH_TYPE] | 'REJECTED' | 'REJECTED_SAVED';

// 프로시저 필터는 useMemo로 참조를 고정해 값이 바뀔 때만 재조회한다.
// 프로젝트 권한관리 팝업 — 화면설계서 "권한관리 팝업" 시트.
// 조직도에서 부서를 고르면 그 부서 사용자 목록이 뜨고, 체크한 사용자를 입력/조회 권한 리스트에
// (+) 로 추가한다. 하단 "요청" 리스트의 입력/조회 승인은 OK에서 최종 저장하고, 반려는 확인 Alert
// 이후 즉시 SP를 호출해 성공한 행의 상태를 "반려"로 바꾼다(설계서 §2.1, §2.3, §2.3.1).
export const AuthManagementPopup = ({
  open,
  pjtKey,
  projectName,
  onClose,
  onSaved,
}: AuthManagementPopupProps) => {
  const { t } = useTranslation();
  const tabId = useTabid();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const sesDivisionId = useSessionStore(state => state.session.div ?? '');
  const sesUserId = useSessionStore(state => state.session.userId ?? '');

  const initialized = useAuthManagementPopupStore(state => state.initialized);
  const staticColumns = useAuthManagementPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useAuthManagementPopupStore(state => state.fetchStaticColumns);

  const userGridRef = useRef<FlexGrid<PopupUserRow>>();
  const inputGridRef = useRef<FlexGrid<AuthMgmtUserRow>>();
  const viewGridRef = useRef<FlexGrid<AuthMgmtUserRow>>();
  const requestGridRef = useRef<FlexGrid<AuthRequestRow>>();

  const [selectedDeptId, setSelectedDeptId] = useState('');
  const [authMgmtDraft, setAuthMgmtDraft] = useState<AuthMgmtUserRow[]>([]);
  // 입력/조회 승인과 권한 삭제 연계 반려는 저장 전까지 화면 상태로 보관한다.
  const [requestHandled, setRequestHandled] = useState<Map<string, RequestDecision>>(new Map());
  const [userKeyword, setUserKeyword] = useState('');
  const [appliedUserKeyword, setAppliedUserKeyword] = useState('');

  const deptId = selectedDeptId;
  // 조직/사용자 프로시저의 실제 IN 파라미터와 동일한 필터 구조다.
  // 요청 4: P_SES_DIVISION_ID/P_SES_USER_ID는 팝업 대상 행이 아니라 로그인 세션에서 전달한다.
  const orgFilters = useMemo(() => ({ sesDivisionId, sesUserId }), [sesDivisionId, sesUserId]);
  const userFilters = useMemo(
    () => ({ userInfo: appliedUserKeyword, deptId, sesDivisionId, sesUserId }),
    [appliedUserKeyword, deptId, sesDivisionId, sesUserId]
  );
  const hasUserCondition = !!deptId || !!appliedUserKeyword;
  // 요청 4: 프로젝트별 권한/요청 조회의 P_SES_* 값도 동일한 세션 키로 전달한다.
  const pjtFilters = useMemo(
    () => ({ pjtKey, sesDivisionId, sesUserId }),
    [pjtKey, sesDivisionId, sesUserId]
  );

  // 조직도 — P_SDM1010_GET_POP_USER_ORG(sesDivisionId, sesUserId).
  const { data: orgData, isFetching: isOrgFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP_ORG>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_ORG,
    tabId,
    filters: orgFilters,
    enabled: open && !!sesDivisionId && !!sesUserId,
    queryOptions: { staleTime: 0 },
  });
  // 사용자 목록 — 부서 선택 또는 User ID(Name) 검색 조건이 있을 때 조회한다.
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.POPUP_USER>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_USER,
    tabId,
    filters: userFilters,
    enabled: open && !!sesDivisionId && !!sesUserId && hasUserCondition,
  });
  // 이 프로젝트(pjtCode)에 이미 등록된 입력/조회 권한 리스트 — authMgmtDraft 의 초기값.
  const { data: authWriteData } = useTabProcQuery<MENU_ID, SHEETS.POPUP_AUTH_WRITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_WRITE,
    tabId,
    filters: pjtFilters,
    enabled: open && !!pjtKey,
    queryOptions: { staleTime: 0 },
  });
  const { data: authReadData } = useTabProcQuery<MENU_ID, SHEETS.POPUP_AUTH_READ>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_READ,
    tabId,
    filters: pjtFilters,
    enabled: open && !!pjtKey,
    queryOptions: { staleTime: 0 },
  });
  // 이 프로젝트에 대한 대기 중인 권한 요청 리스트 — 하단 "요청" 그리드. 팝업 열 때마다 최신값 재조회.
  const { data: authReqData } = useTabProcQuery<MENU_ID, SHEETS.POPUP_AUTH_REQ>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_REQ,
    tabId,
    filters: pjtFilters,
    enabled: open && !!pjtKey,
    queryOptions: { staleTime: 0 },
  });
  const { mutateAsync: saveWriteAuth } = useProcMutation<MENU_ID, SHEETS.POPUP_AUTH_WRITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_WRITE,
    tabId,
    onSuccess: () => undefined,
    onError: () => undefined,
  });
  const { mutateAsync: saveReadAuth } = useProcMutation<MENU_ID, SHEETS.POPUP_AUTH_READ>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_READ,
    tabId,
    onSuccess: () => undefined,
    onError: () => undefined,
  });
  const { mutateAsync: rejectRequests } = useProcMutation<MENU_ID, SHEETS.POPUP_AUTH_REQ>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_AUTH_REQ,
    procedureAction: BUTTON_TYPE.REJECT,
    tabId,
    onSuccess: () => undefined,
    onError: () => undefined,
  });

  useEffect(() => {
    if (!open) return;
    if (!initialized) void fetchStaticColumns();
  }, [open, initialized, fetchStaticColumns]);

  // 팝업을 열 때(또는 대상 프로젝트가 바뀔 때) 서버 데이터로 초안을 리셋한다.
  useEffect(() => {
    if (!open) return;
    setSelectedDeptId('');
    setRequestHandled(new Map());
    setUserKeyword('');
    setAppliedUserKeyword('');
  }, [open, pjtKey]);

  // open 도 의존성에 둔다 — 저장 안 하고 닫은 로컬 추가분(authMgmtDraft)은 authWriteData/
  // authReadData 참조가 안 바뀌어도(재조회 안 일어나도) 재오픈 시 서버 원본으로 되돌려야 한다.
  useEffect(() => {
    if (!open) return;
    const writeRows =
      (authWriteData?.authWriteList as unknown as AuthMgmtUserRow[] | undefined) ?? [];
    const readRows = (authReadData?.authReadList as unknown as AuthMgmtUserRow[] | undefined) ?? [];
    setAuthMgmtDraft([
      ...writeRows.map(row => ({ ...row, AUTH_TYPE_CD: AUTH_TYPE.INPUT })),
      ...readRows.map(row => ({ ...row, AUTH_TYPE_CD: AUTH_TYPE.VIEW })),
    ]);
  }, [open, authWriteData, authReadData]);

  const orgTree = useMemo(
    () => buildOrgTree((orgData?.orgList as unknown as OrgTreeRow[] | undefined) ?? []),
    [orgData]
  );
  const userRows = hasUserCondition
    ? ((userData?.userList as unknown as PopupUserRow[] | undefined) ?? [])
    : [];
  const allRequestRows =
    (authReqData?.authRequestList as unknown as AuthRequestRow[] | undefined) ?? [];
  const requestKey = (row: AuthRequestRow) => `${row.DPJT_KEY}|${row.USER_ID}`;
  // useMemo로 참조를 고정 — 아래 formatRequestProcess 가 매 셀마다 이 배열을 itemsSource 로
  // 받는 DataGrid 를 건드리지 않고도(참조 불변) 포탈 트리거용 setState 를 안전하게 부를 수 있게 한다.
  const requestRows = useMemo(
    () =>
      allRequestRows
        .filter(row => {
          const status = requestHandled.get(requestKey(row));
          return status === undefined || status === 'REJECTED_SAVED';
        })
        .map(row =>
          requestHandled.get(requestKey(row)) === 'REJECTED_SAVED'
            ? {
                ...row,
                DPJT_AUTH_STATUS: 'REJECTED',
                DPJT_AUTH_STATUS_NAME: t('LBL00635', '_반려'),
                PROCESS: '',
              }
            : row
        ),
    [allRequestRows, requestHandled, t]
  );

  // authMgmtDraft 는 입력/조회 권한을 한 배열에 AUTH_TYPE_CD 로 같이 담아 두므로, 화면에는
  // 타입별로 걸러서(그리고 제거 마킹된 D 는 감추고) 보여준다.
  const activeAuthRows = (authType: string) =>
    authMgmtDraft.filter(
      row => row.AUTH_TYPE_CD === authType && row.CRUD_TYPE !== CRUD_TYPE.DELETE
    );
  const inputAuthRows = activeAuthRows(AUTH_TYPE.INPUT);
  const viewAuthRows = activeAuthRows(AUTH_TYPE.VIEW);

  const handleSelectDept = (selectedId: string) => {
    setSelectedDeptId(selectedId);
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

  // (+) 버튼 — 체크된 사용자를 입력/조회 권한 리스트에 추가. 이미 있는 사용자면 §메시지 코드대로 알림.
  const handleAddAuth = (authType: string) => {
    const checked = collectCheckedRows(userGridRef.current);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    // 요청 1: 대상 authType 리스트뿐 아니라 반대쪽 리스트(입력/조회는 상호배타 — ↑/↓ 이동 버튼이
    // 전제하는 불변식)와 같은 사용자의 대기중 요청까지 함께 봐야 정합성이 맞는다 — 이미 입력에
    // 있는 사용자를 조회에 또 추가하거나, 요청 그리드에 이미 올라온 사용자를 (+)로 또 추가하면
    // 승인 시 중복이 생긴다.
    // 요청 2: 막을 때 안내 메시지는 지금 누른 버튼(authType) 기준이 아니라, 그 사용자가 실제로
    // 속한 쪽(입력/조회) 기준으로 보여준다 — 조회에 추가하려 했어도 실제로는 입력에 있으면
    // "입력 리스트에 이미 존재합니다"라고 알려야 한다.
    const inputIds = new Set(activeAuthRows(AUTH_TYPE.INPUT).map(row => row.USER_ID));
    const viewIds = new Set(activeAuthRows(AUTH_TYPE.VIEW).map(row => row.USER_ID));
    const pendingAuthTypeByUserId = new Map(
      requestRows.map(row => [row.USER_ID, row.DPJT_AUTH_TYPE])
    );
    const conflict = checked.find(
      user =>
        inputIds.has(user.USER_ID) ||
        viewIds.has(user.USER_ID) ||
        pendingAuthTypeByUserId.has(user.USER_ID)
    );
    if (conflict) {
      const conflictType = inputIds.has(conflict.USER_ID)
        ? AUTH_TYPE.INPUT
        : viewIds.has(conflict.USER_ID)
          ? AUTH_TYPE.VIEW
          : pendingAuthTypeByUserId.get(conflict.USER_ID);
      void setAlert({
        type: 'alert',
        content:
          conflictType === AUTH_TYPE.INPUT
            ? t('MSG00715', '_사용자는 입력 리스트에 이미 존재합니다.')
            : t('MSG00716', '_사용자는 조회 리스트에 이미 존재합니다.'),
      });
      return;
    }
    const additions: AuthMgmtUserRow[] = checked.map(user => ({
      DPJT_KEY: pjtKey,
      USER_ID: user.USER_ID,
      USER_NAME: user.USER_NAME,
      JOB_CODE: user.JOB_CODE,
      JOB_NAME: user.JOB_NAME,
      DEPT_ID: user.DEPT_ID,
      DEPT_NAME: user.DEPT_NAME,
      AUTH_TYPE_CD: authType,
      CRUD_TYPE: CRUD_TYPE.CREATE,
    }));
    setAuthMgmtDraft(prev => [...prev, ...additions]);
  };

  // 제외 버튼 — 신규 추가분(미저장)은 그냥 빼고, 기존 저장분은 CRUD_TYPE=D 로 표시해 저장 시 반영한다.
  //
  // requestHandled 에 대한 처리는 두 갈래로 나뉜다:
  //   1) 이번 세션에 "요청 처리" 버튼(입력/조회)으로 승인해서 이 리스트에 올라온 행을 다시 빼는 경우
  //      — 승인을 취소하는 것뿐이므로 requestHandled 키를 지워 요청 그리드로 되돌린다.
  //   2) 그 외(사용자 목록에서 (+)로 직접 추가했던 사용자 등)를 빼는 경우 — 그 사용자에게 별도의
  //      대기중 요청이 있으면 반려 처리한다(§확인사항 2.5).
  const handleRemoveAuth = (authType: string, grid: FlexGrid<AuthMgmtUserRow> | undefined) => {
    const checked = collectCheckedRows(grid);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    const checkedIds = new Set(checked.map(row => row.USER_ID));
    setAuthMgmtDraft(prev =>
      prev.flatMap(row => {
        if (row.AUTH_TYPE_CD !== authType || !checkedIds.has(row.USER_ID)) return [row];
        if (row.CRUD_TYPE === CRUD_TYPE.CREATE) return [];
        return [{ ...row, CRUD_TYPE: CRUD_TYPE.DELETE }];
      })
    );

    const relatedRequests = allRequestRows.filter(row => checkedIds.has(row.USER_ID));
    // undo 판정은 authType 무관 — handleMoveAuth 로 승인 당시 타입(예: 조회)과 다른 타입(예: 입력)
    // 리스트로 이관된 뒤 거기서 빼는 경우에도 "그 요청을 승인했었다"는 사실 자체는 안 바뀐다.
    // authType 으로 좁히면 이관 후에는 매치가 안 돼 요청 리스트로 영영 안 돌아오는 버그가 났었다
    // (2026-08-18 확인).
    const undoApprovedKeys = relatedRequests
      .filter(row => {
        const status = requestHandled.get(requestKey(row));
        return status !== undefined && status !== 'REJECTED' && status !== 'REJECTED_SAVED';
      })
      .map(requestKey);
    // 반려 판정(§확인사항 2.5)은 지금 빼는 리스트(authType)와 원래 요청한 타입이 같을 때만 —
    // 승인 취소 대상이 아닌, 별도로 존재하는 동일 타입 대기 요청만 반려 처리한다.
    const rejectKeys = relatedRequests
      .filter(
        row =>
          row.DPJT_AUTH_TYPE === authType &&
          !undoApprovedKeys.includes(requestKey(row)) &&
          requestHandled.get(requestKey(row)) !== 'REJECTED_SAVED'
      )
      .map(requestKey);

    if (undoApprovedKeys.length > 0 || rejectKeys.length > 0)
      setRequestHandled(prev => {
        const next = new Map(prev);
        undoApprovedKeys.forEach(requestId => next.delete(requestId));
        rejectKeys.forEach(requestId => next.set(requestId, 'REJECTED'));
        return next;
      });
  };

  const handleMoveAuth = (
    sourceType: string,
    targetType: string,
    grid: FlexGrid<AuthMgmtUserRow> | undefined,
    alreadyExistsMsg: string
  ) => {
    const checked = collectCheckedRows(grid);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }

    const checkedIds = new Set(checked.map(row => row.USER_ID));
    const targetIds = new Set(activeAuthRows(targetType).map(row => row.USER_ID));
    if (checked.some(row => targetIds.has(row.USER_ID))) {
      void setAlert({ type: 'alert', content: alreadyExistsMsg });
      return;
    }

    setAuthMgmtDraft(prev => {
      const restoredIds = new Set(
        prev
          .filter(
            row =>
              row.AUTH_TYPE_CD === targetType &&
              row.CRUD_TYPE === CRUD_TYPE.DELETE &&
              checkedIds.has(row.USER_ID)
          )
          .map(row => row.USER_ID)
      );
      const next = prev.flatMap(row => {
        if (!checkedIds.has(row.USER_ID)) return [row];
        if (
          row.AUTH_TYPE_CD === targetType &&
          row.CRUD_TYPE === CRUD_TYPE.DELETE &&
          restoredIds.has(row.USER_ID)
        )
          return [{ ...row, CRUD_TYPE: '' }];
        if (row.AUTH_TYPE_CD !== sourceType || row.CRUD_TYPE === CRUD_TYPE.DELETE) return [row];
        if (row.CRUD_TYPE === CRUD_TYPE.CREATE) {
          if (restoredIds.has(row.USER_ID)) return [];
          return [{ ...row, AUTH_TYPE_CD: targetType }];
        }
        return [{ ...row, CRUD_TYPE: CRUD_TYPE.DELETE }];
      });
      const movedRows = checked
        .filter(row => row.CRUD_TYPE !== CRUD_TYPE.CREATE)
        .map(
          (row): AuthMgmtUserRow => ({
            ...row,
            AUTH_TYPE_CD: targetType,
            CRUD_TYPE: CRUD_TYPE.CREATE,
          })
        );
      return [...next, ...movedRows];
    });
  };

  const handleApproveRequest = (
    authType: Exclude<RequestDecision, 'REJECTED'>,
    selectedRows?: AuthRequestRow[]
  ) => {
    const checked = selectedRows ?? collectCheckedRows(requestGridRef.current);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    setAuthMgmtDraft(prev => {
      const existingKeys = new Set(
        prev
          .filter(row => row.CRUD_TYPE !== CRUD_TYPE.DELETE)
          .map(row => `${row.USER_ID}|${row.AUTH_TYPE_CD}`)
      );
      // 요청 목록의 DPJT_AUTH_TYPE(WRITE/READ)을 권한 목록 코드로 그대로 사용한다.
      const additions = checked
        .filter(row => !existingKeys.has(`${row.USER_ID}|${authType}`))
        .map(
          (row): AuthMgmtUserRow => ({
            DPJT_KEY: row.DPJT_KEY,
            USER_ID: row.USER_ID,
            USER_NAME: row.USER_NAME,
            JOB_CODE: row.JOB_CODE,
            JOB_NAME: row.JOB_NAME,
            DEPT_ID: row.DEPT_ID,
            DEPT_NAME: row.DEPT_NAME,
            AUTH_TYPE_CD: authType,
            CRUD_TYPE: CRUD_TYPE.CREATE,
          })
        );
      return [...prev, ...additions];
    });
    setRequestHandled(prev => {
      const next = new Map(prev);
      checked.forEach(row => next.set(requestKey(row), authType));
      return next;
    });
  };

  const handleRejectRequest = (selectedRows?: AuthRequestRow[]) => {
    const checked = selectedRows ?? collectCheckedRows(requestGridRef.current);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00718', '_권한 요청을 반려하시겠습니까?'),
      });
      if (!confirmed) return;

      try {
        for (const row of checked) await rejectRequests([{ ...row }]);
        setRequestHandled(prev => {
          const next = new Map(prev);
          checked.forEach(row => next.set(requestKey(row), 'REJECTED_SAVED'));
          return next;
        });
        setToast({ type: 'success', message: t('MSG00623', '_반려 완료') });
        onSaved();
      } catch (err) {
        void setAlert({
          type: 'alert',
          content: (err as Error).message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        });
      }
    })();
  };

  // 요청 그리드 PROCESS 셀 버튼 — 하단 Close/OK 버튼과 같은 <Button> 컴포넌트를 그대로 써서
  // 입력/조회는 OK(appearance='contained' priority='primary'), 반려는 Close(appearance='outlined'
  // priority='normal')와 완전히 같은 스타일이 나오게 한다. Wijmo FlexGrid 셀은 React 트리 밖에서
  // formatItem 이 만드는 순수 DOM이라 <Button> 을 직접 못 앉히므로, formatItem 이 셀 안에 빈
  // 컨테이너 div만 만들어 두고 그 div로 실제 <Button> 들을 createPortal 한다(JSX는 아래 requestPanel
  // 블록 참고). processPortalsRef 는 "요청 키 → 그 셀의 컨테이너 DOM" 맵으로, formatItem(Wijmo 콜백,
  // React 렌더 밖)에서 동기적으로 채우고, 실제 포탈 렌더는 setPortalTick 으로 리렌더를 걸어 수행한다.
  const processPortalsRef = useRef<Map<string, HTMLDivElement>>(new Map());
  const [, setPortalTick] = useState(0);

  const formatRequestProcess = (sender: FlexGrid<AuthRequestRow>, event: FormatItemEventArgs) => {
    if (event.panel.cellType !== CellType.Cell) return;
    if (sender.columns[event.col]?.binding !== 'PROCESS') return;

    const row = GridUtils.getRow(sender, event.row);
    if (!row) return;
    const key = requestKey(row);

    if (requestHandled.get(key) === 'REJECTED_SAVED') {
      processPortalsRef.current.delete(key);
      event.cell.textContent = '';
      return;
    }

    // DataGrid 는 columnGroups 를 매 부모 리렌더마다 통째로 재대입한다(DataGrid.tsx 상단 주석
    // 참고) — 그 말은 event.cell 이 "매 리렌더" 새 DOM 노드로 바뀐다는 뜻이다. 그래서 이미 아는
    // key면 새 컨테이너를 만들지 않고 "같은 컨테이너 객체"를 새 셀로 옮겨 붙이기만 한다(리렌더 유발
    // 없음 — portal 은 컨테이너 참조가 그대로면 리렌더 없이도 새 위치에서 계속 유효하다). 여기서
    // 매번 setState 했다면 리렌더→(다음 렌더에서) 셀 재생성→다시 setState 로 무한루프(깜빡임)가 난다
    // (2026-08-18 확인) — key 가 처음 등장할 때 딱 한 번만 setState 한다.
    const existing = processPortalsRef.current.get(key);
    if (existing) {
      if (event.cell.firstElementChild !== existing) event.cell.replaceChildren(existing);
      return;
    }

    const container = globalThis.document.createElement('div');
    container.className = styles.processButtons;
    event.cell.replaceChildren(container);
    processPortalsRef.current.set(key, container);
    setPortalTick(tick => tick + 1);
  };

  // requestRows 에서 빠진(승인 등으로 처리된) 요청의 포탈 컨테이너를 정리한다.
  useEffect(() => {
    const validKeys = new Set(requestRows.map(requestKey));
    let changed = false;
    processPortalsRef.current.forEach((_, key) => {
      if (!validKeys.has(key)) {
        processPortalsRef.current.delete(key);
        changed = true;
      }
    });
    if (changed) setPortalTick(tick => tick + 1);
  }, [requestRows]);

  const handleSave = async () => {
    const authMgmtRows = authMgmtDraft.filter(row => row.CRUD_TYPE);
    // 권한 삭제에 연계된 반려(§2.5)만 OK 시 처리한다. 반려 버튼은 클릭 시 이미 SP 처리된다.
    const deferredRejectedKeys = [...requestHandled.entries()]
      .filter(([, status]) => status === 'REJECTED')
      .map(([key]) => key);
    const hasApprovedRequests = [...requestHandled.values()].some(
      status => status === AUTH_TYPE.INPUT || status === AUTH_TYPE.VIEW
    );

    if (authMgmtRows.length === 0 && !hasApprovedRequests && deferredRejectedKeys.length === 0) {
      onClose();
      return;
    }

    try {
      if (authMgmtRows.length > 0 || hasApprovedRequests) {
        const buildAuthPayload = (authType: string): AuthMgmtUserRow[] => [
          {
            DPJT_KEY: pjtKey,
            USER_ID: activeAuthRows(authType)
              .map(row => row.USER_ID)
              .join('^'),
            USER_NAME: '',
            JOB_CODE: '',
            JOB_NAME: '',
            DEPT_ID: '',
            DEPT_NAME: '',
            AUTH_TYPE_CD: authType,
            CRUD_TYPE: CRUD_TYPE.MODIFY,
            sesDivisionId,
          },
        ];
        await saveWriteAuth(buildAuthPayload(AUTH_TYPE.INPUT));
        await saveReadAuth(buildAuthPayload(AUTH_TYPE.VIEW));
      }
      for (const row of allRequestRows.filter(item =>
        deferredRejectedKeys.includes(requestKey(item))
      )) {
        await rejectRequests([{ ...row }]);
      }
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      onSaved();
      onClose();
    } catch (err) {
      void setAlert({
        type: 'alert',
        content: (err as Error).message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
    }
  };

  return (
    <CustomDialog
      open={open}
      size={1240}
      height='90vh'
      disableScale
      type='modal'
      position='basic'
      handleClose={onClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00868', '_Project Authority Management')}</h2>
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
          <div className={styles.projectBar}>
            <div className={styles.projectName}>
              <span>{t('LBL00869', '_Project Name')}</span>
              <strong>{projectName}</strong>
            </div>
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
            {/* 조직도(부서 트리) — 노드를 고르면 그 부서 사용자 목록이 오른쪽에 뜬다. */}
            <div className={styles.orgTreePanel}>
              <OrgTree nodes={orgTree} onSelect={handleSelectDept} className={styles.orgTree} />
            </div>
            {/* 사용자 목록 — 선택된 조직 노드 소속 사용자. 체크 후 우측 (+) 버튼으로 권한 리스트에 추가. */}
            <div className={`${styles.gridPanel} ${styles.userPanel}`}>
              <div className={styles.panelTitle}>{t('LBL00866', '_User List')}</div>
              <DataGrid<PopupUserRow>
                gridRef={userGridRef}
                itemsSource={userRows}
                staticColumns={staticColumns[RESPONSE_SET.POPUP_USER]}
                useCheckbox
                isReadOnly
              />
            </div>
            {/* (+) 버튼 2개 — 위: 체크된 사용자를 입력 권한 리스트로, 아래: 조회 권한 리스트로 추가.
                이미 있는 사용자면 §메시지 코드대로 알림만 띄우고 추가하지 않는다(handleAddAuth). */}
            <div className={styles.addButtonColumn}>
              <div className={`${styles.authTransferButtons} ${styles.inputTransferButtons}`}>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  buttonLabel='+'
                  aria-label={t('LBL00109', '_Add Input Authority')}
                  onClick={() => handleAddAuth(AUTH_TYPE.INPUT)}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  buttonLabel='−'
                  aria-label={t('LBL00407', '_Remove Input Authority')}
                  onClick={() => handleRemoveAuth(AUTH_TYPE.INPUT, inputGridRef.current)}
                />
              </div>
              <div className={`${styles.authTransferButtons} ${styles.viewTransferButtons}`}>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  buttonLabel='+'
                  aria-label={t('LBL00109', '_Add View Authority')}
                  onClick={() => handleAddAuth(AUTH_TYPE.VIEW)}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  buttonLabel='−'
                  aria-label={t('LBL00407', '_Remove View Authority')}
                  onClick={() => handleRemoveAuth(AUTH_TYPE.VIEW, viewGridRef.current)}
                />
              </div>
            </div>
            {/* 입력 권한 리스트 — 이 프로젝트를 편집할 수 있는 사용자. (-)는 체크된 행을 뺀다
                (신규 추가분은 즉시 제거, 기존 저장분은 CRUD_TYPE=D 로 표시만 해 저장 시 반영). */}
            <div className={`${styles.gridPanel} ${styles.inputPanel}`}>
              <div className={styles.panelTitle}>{t('LBL00872', '_Input Authority')}</div>
              <DataGrid<AuthMgmtUserRow>
                gridRef={inputGridRef}
                itemsSource={inputAuthRows}
                staticColumns={staticColumns[RESPONSE_SET.POPUP_AUTH_WRITE]}
                useCheckbox
                isReadOnly
                excludeFromDirtyCheck
              />
            </div>
            <div className={styles.authorityMoveButtons}>
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                buttonLabel='↑'
                aria-label={t('LBL00955', '_Move to Input Authority')}
                onClick={() =>
                  handleMoveAuth(
                    AUTH_TYPE.VIEW,
                    AUTH_TYPE.INPUT,
                    viewGridRef.current,
                    t('MSG00715', '_사용자는 입력 리스트에 이미 존재합니다.')
                  )
                }
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                buttonLabel='↓'
                aria-label={t('LBL00956', '_Move to View Authority')}
                onClick={() =>
                  handleMoveAuth(
                    AUTH_TYPE.INPUT,
                    AUTH_TYPE.VIEW,
                    inputGridRef.current,
                    t('MSG00716', '_사용자는 조회 리스트에 이미 존재합니다.')
                  )
                }
              />
            </div>
            {/* 조회 권한 리스트 — 이 프로젝트를 읽기만 할 수 있는 사용자. 동작은 입력 권한과 동일. */}
            <div className={`${styles.gridPanel} ${styles.viewPanel}`}>
              <div className={styles.panelTitle}>{t('LBL00867', '_View Authority')}</div>
              <DataGrid<AuthMgmtUserRow>
                gridRef={viewGridRef}
                itemsSource={viewAuthRows}
                staticColumns={staticColumns[RESPONSE_SET.POPUP_AUTH_READ]}
                useCheckbox
                isReadOnly
                excludeFromDirtyCheck
              />
            </div>
            {/* 권한 요청 리스트 — 입력/조회 승인은 위 권한 리스트로 이동한 뒤 OK에서 저장한다.
                반려는 확인 Alert 이후 즉시 SP 처리하고, 성공한 행을 남겨 상태를 "반려"로 표시한다. */}
            <div className={styles.requestPanel}>
              <div className={styles.panelTitle}>{t('LBL00871', '_Authority Requests')}</div>
              <DataGrid<AuthRequestRow>
                gridRef={requestGridRef}
                itemsSource={requestRows}
                staticColumns={staticColumns[RESPONSE_SET.POPUP_AUTH_REQ]}
                isReadOnly
                formatItem={formatRequestProcess}
              />
              {/* PROCESS 셀 버튼 — formatRequestProcess 가 만들어 둔 컨테이너 div로 실제 <Button> 을
                  portal. 입력/조회는 OK와, 반려는 Close와 완전히 같은 <Button> appearance/priority. */}
              {[...processPortalsRef.current.entries()].flatMap(([key, container]) => {
                const row = requestRows.find((item: AuthRequestRow) => requestKey(item) === key);
                if (!row) return [];
                return [
                  createPortal(
                    <>
                      <Button
                        appearance='contained'
                        priority='primary'
                        size='small'
                        buttonLabel={t('LBL00872', '_입력')}
                        onClick={() => handleApproveRequest(AUTH_TYPE.INPUT, [row])}
                      />
                      <Button
                        appearance='contained'
                        priority='primary'
                        size='small'
                        buttonLabel={t('LBL00867', '_조회')}
                        onClick={() => handleApproveRequest(AUTH_TYPE.VIEW, [row])}
                      />
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={t('LBL00863', '_반려')}
                        onClick={() => handleRejectRequest([row])}
                      />
                    </>,
                    container,
                    key
                  ),
                ];
              })}
            </div>
          </div>
          {/* Close = 미저장 변경분 버리고 닫기 / OK = 권한 리스트·요청 승인 저장 */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={onClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={() => void handleSave()}
            />
          </div>
        </div>
      }
    />
  );
};
