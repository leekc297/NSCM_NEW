import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { type ReactNode, useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import {
  AUTH_STATUS,
  AUTH_TYPE,
  MENU_ID,
  MSG,
  REQ_ACTION_ATTR,
  REQ_DECISION,
  SHEETS,
} from '../../project-reg.constants';
import type {
  AuthRegTarget,
  OrgTreeRow,
  Pop1AuthRow,
  Pop1ReqRow,
  Pop1UserRow,
} from '../../project-reg.types';
import styles from '../../ProjectReg.module.scss';
import { useProjectRegStore } from '../../useProjectRegStore';
import {
  callRejectAuthReq,
  callSaveAuthRead,
  callSaveAuthWrite,
} from '../../utils/project-reg.api';
import {
  addUsersToList,
  applyRequestDecision,
  type AuthDomain,
  buildAuthUserIds,
  buildRejectUserIds,
  type DecisionMap,
  moveUsersBetweenLists,
  removeUsersFromList,
} from '../../utils/project-reg.authPopup';

// ⭐ SDM1010 권한관리 모달 (TAB1 DPJT_ATUH_REG_STR 셀 — 메타 FPModal/ATTRIBUTE1='ProjectAuthRegModal').
//   ⭐ 신본 PKG_SDM1010 §6~§13 재배선 (2026-08-13 — 계약 결정 9. 목업 레이아웃·행내 버튼 UI 유지):
//   [헤더바] * Project Name + User ID(Name) 검색 + Search(F5)
//   [본문] 조직도 트리(§6 — UPPER_DEPT_ID) | 사용자 목록(§7 — 부서 모드/검색 모드 배타) |
//          입력=POP1_GRID2(§8 WRITE) → [∨][∧] → 조회=POP1_GRID3(§9 READ) →
//          요청=POP1_GRID4(§10 — REQUEST 행만 처리 버튼 활성, REJECT·NULL 이력 포함 표시)
//   pending 원칙(설계 2.2.1/2.3.1): 모든 조작 로컬 — OK 시 ①WRITE replace-set ②READ replace-set
//   ('^' 전체 목록 — 포함=CONFIRM(요청 승인 포함)/요청자 제외=REJECT/무요청 제외=소거 §11·§12)
//   ③반려 pending = §13 단건 반복. 성공 판정 = CODE '0'+EVENT 합산 (0 = 성공 토스트 금지).
//   공용 CustomDialog customContentArea 사용 → 자체 footer 의무 (P9).

interface Props {
  open: boolean;
  target: AuthRegTarget | null;
  modalClose: () => void;
  // OK 저장 성공 → 메인 TAB1 재조회 (권한등록 상태 TAG 갱신 — setFilter 경로)
  onSaved: () => void;
}

interface TreeNode {
  id: string;
  name: string;
  children: TreeNode[];
}

export const ProjectAuthRegModal = ({ open, target, modalClose, onSaved }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const staticColumns = useProjectRegStore(s => s.staticColumns);
  const fetchStaticColumns = useProjectRegStore(s => s.fetchStaticColumns);

  const dpjtKey = target?.dpjtKey ?? '';
  const userGridRef = useRef<FlexGridType<Pop1UserRow>>(undefined);
  const inputGridRef = useRef<FlexGridType<Pop1AuthRow>>(undefined);
  const readGridRef = useRef<FlexGridType<Pop1AuthRow>>(undefined);
  const reqGridRef = useRef<FlexGridType<Pop1ReqRow>>(undefined);

  const [selectedDeptId, setSelectedDeptId] = useState('');
  const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());
  // User ID(Name) 검색 — 입력값과 조회 적용값 분리 (Search(F5)/Enter 로 적용).
  //   ⭐ §7 분기: deptId 有 = 부서 모드(userInfo 무시) / 無 = userInfo 부분일치(NULL=0행)
  //   → 트리 클릭 = deptId 전달 + userInfo '' / 헤더 검색 = deptId '' (계약 결정 9 — 상호 배타)
  const [userNameInput, setUserNameInput] = useState('');
  const [appliedUserName, setAppliedUserName] = useState('');
  // pending 권한 리스트 — OK 전까지 로컬만 (Close/X = 폐기, 설계 2.2.1/2.3.1)
  const [inputList, setInputList] = useState<Pop1AuthRow[]>([]);
  const [readList, setReadList] = useState<Pop1AuthRow[]>([]);
  // pending 요청 처리 — USER_ID → {APPROVE(부여 도메인)/REJECT} (P-21/P-22 — §10 행 식별 = USER_ID)
  const [decisions, setDecisions] = useState<DecisionMap>({});
  const [saving, setSaving] = useState(false);

  // 열 때마다 초기화 + 모달 시트 메타 fetch (SHEET_COLUMNS — POP1_TREE/GRID1/2/3/4)
  useEffect(() => {
    if (!open) return;
    setSelectedDeptId('');
    setExpandedIds(new Set());
    setUserNameInput('');
    setAppliedUserName('');
    setInputList([]);
    setReadList([]);
    setDecisions({});
    setSaving(false);
    void fetchStaticColumns([
      SHEETS.POP1_TREE,
      SHEETS.POP1_GRID1,
      SHEETS.POP1_GRID2,
      SHEETS.POP1_GRID3,
      SHEETS.POP1_GRID4,
    ]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // ===== 조회 — filters 는 useMemo 참조 안정화 (인라인 객체 금지) =====
  //   미사용 IN 파라미터(sesDivisionId)도 PROC_M 등재분은 시그니처 충족 위해 '' 전달 (§18-8)
  const treeFilters = useMemo(() => ({ sesDivisionId: '' }), []);
  const keyFilters = useMemo(() => ({ dpjtKey, sesDivisionId: '' }), [dpjtKey]);
  const userFilters = useMemo(
    () =>
      selectedDeptId !== ''
        ? { userInfo: '', deptId: selectedDeptId, sesDivisionId: '' } // 부서 모드
        : { userInfo: appliedUserName, deptId: '', sesDivisionId: '' }, // 검색 모드
    [selectedDeptId, appliedUserName]
  );

  const { data: treeData } = useTabProcQuery<MENU_ID, SHEETS.POP1_TREE>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP1_TREE,
    tabId: `${MENU_ID}_POP1`,
    filters: treeFilters,
    enabled: open,
  });
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.POP1_GRID1>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP1_GRID1,
    tabId: `${MENU_ID}_POP1`,
    filters: userFilters,
    // 확인사항 1.1 — 조회 조건(부서/User ID·Name) 전무 시 그리드 미출력 (§7 NULL=0행과 동치)
    enabled: open && (selectedDeptId !== '' || appliedUserName !== ''),
  });
  // 입력(WRITE) 권한자 — §8 GET_POP_PJT_AUTH_WRITE
  const { data: writeData } = useTabProcQuery<MENU_ID, SHEETS.POP1_GRID2>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP1_GRID2,
    tabId: `${MENU_ID}_POP1`,
    filters: keyFilters,
    enabled: open && dpjtKey !== '',
    queryOptions: { staleTime: 0 },
  });
  // 조회(READ) 권한자 — §9 GET_POP_PJT_AUTH_READ (신본 분리 원천 — 구 GRID2 통합 반환 폐지)
  const { data: readData } = useTabProcQuery<MENU_ID, SHEETS.POP1_GRID3>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP1_GRID3,
    tabId: `${MENU_ID}_POP1`,
    filters: keyFilters,
    enabled: open && dpjtKey !== '',
    queryOptions: { staleTime: 0 },
  });
  // 요청·이력 — §10 GET_POP_PJT_AUTH_REQ (REQUEST + REJECT·NULL 상태 행 포함)
  const { data: reqData } = useTabProcQuery<MENU_ID, SHEETS.POP1_GRID4>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP1_GRID4,
    tabId: `${MENU_ID}_POP1`,
    filters: keyFilters,
    enabled: open && dpjtKey !== '',
    queryOptions: { staleTime: 0 },
  });

  // 기존 권한 리스트 → 입력(WRITE)/조회(READ) pending 초기값 (§8/§9 분리 커서 그대로)
  useEffect(() => {
    setInputList(writeData?.data ?? []);
  }, [writeData]);
  useEffect(() => {
    setReadList(readData?.data ?? []);
  }, [readData]);

  const userRows = useMemo<Pop1UserRow[]>(
    () => (selectedDeptId !== '' || appliedUserName !== '' ? (userData?.data ?? []) : []),
    [userData, selectedDeptId, appliedUserName]
  );
  const reqRows = useMemo<Pop1ReqRow[]>(() => reqData?.data ?? [], [reqData]);

  // ===== User ID(Name) 검색 — Search(F5)/Enter (목업 헤더바). 검색 모드 진입 = 부서 선택 해제 =====
  const applyUserSearch = (value: string) => {
    setSelectedDeptId('');
    setAppliedUserName(value.trim());
  };
  const handleUserSearch = () => applyUserSearch(userNameInput);
  useEffect(() => {
    if (!open) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'F5') return;
      e.preventDefault();
      const next = (document.getElementById('authPopupUserName') as HTMLInputElement | null)?.value;
      if (next != null) applyUserSearch(next);
    };
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [open]);

  // ===== 조직도 트리 구성 (§6 커서 — DEPT_ID/UPPER_DEPT_ID walk. LEVEL_NO/ORGN 은 미사용) =====
  const treeRoots = useMemo<TreeNode[]>(() => {
    const rows: OrgTreeRow[] = treeData?.data ?? [];
    const byId = new Map<string, TreeNode>();
    rows.forEach(r => {
      const id = String(r.DEPT_ID ?? '');
      if (id !== '') byId.set(id, { id, name: String(r.DEPT_NAME ?? id), children: [] });
    });
    const roots: TreeNode[] = [];
    rows.forEach(r => {
      const node = byId.get(String(r.DEPT_ID ?? ''));
      if (!node) return;
      const parent = byId.get(String(r.UPPER_DEPT_ID ?? ''));
      if (parent && parent !== node) parent.children.push(node);
      else roots.push(node);
    });
    return roots;
  }, [treeData]);

  const toggleExpand = (id: string) => {
    setExpandedIds(prev => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  // 트리 노드 선택 = 부서 모드 (userInfo 적용값 해제 — §7 부서 모드는 userInfo 무시 계약이지만
  //   FE 상태도 배타로 유지해 재검색 시 혼선 방지)
  const selectDept = (id: string) => {
    setSelectedDeptId(id);
    setAppliedUserName('');
  };

  const renderTree = (nodes: TreeNode[]): ReactNode => (
    <ul className={styles.treeList}>
      {nodes.map(node => (
        <li key={node.id}>
          <div
            className={`${styles.treeNode} ${selectedDeptId === node.id ? styles.treeNodeSelected : ''}`}
          >
            {node.children.length > 0 ? (
              <button
                type='button'
                className={styles.treeToggle}
                onClick={() => toggleExpand(node.id)}
              >
                {expandedIds.has(node.id) ? '−' : '＋'}
              </button>
            ) : (
              <span className={styles.treeToggle} />
            )}
            <button
              type='button'
              className={styles.treeLabel}
              onClick={() => selectDept(node.id)}
            >
              {node.name}
            </button>
          </div>
          {node.children.length > 0 && expandedIds.has(node.id)
            ? renderTree(node.children)
            : null}
        </li>
      ))}
    </ul>
  );

  // ===== 리스트 조작 — 순수함수(utils/project-reg.authPopup) 위임, 실패 msgId = alert =====
  const collectChecked = <T,>(g: FlexGridType<T> | undefined): T[] => {
    if (!g) return [];
    const picked: T[] = [];
    for (const row of g.rows) {
      if (row?.isSelected) picked.push(row.dataItem as T);
    }
    return picked;
  };

  const listState = () => ({ inputList, readList, decisions });
  const applyResult = (r: {
    ok: boolean;
    msgId?: string;
    inputList: Pop1AuthRow[];
    readList: Pop1AuthRow[];
    decisions: DecisionMap;
  }) => {
    if (!r.ok) {
      if (r.msgId) void setAlert({ type: 'alert', content: t(r.msgId, '_처리할 수 없습니다.') });
      return;
    }
    setInputList(r.inputList);
    setReadList(r.readList);
    setDecisions(r.decisions);
  };

  // [+] 사용자 목록 체크 → 입력/조회 리스트 추가 (MSG00716/717)
  const handleAdd = (domain: AuthDomain) =>
    applyResult(addUsersToList(listState(), collectChecked(userGridRef.current), domain));
  // [−] 입력/조회 리스트 체크 행 제외 (요청 승인 추가분이면 결정도 원복.
  //   기존 권한자 제외 확정은 OK replace-set 담당 — 목록 제외 = 소거/반려 §11·§12)
  const handleRemove = (domain: AuthDomain) => {
    const g = domain === AUTH_TYPE.WRITE ? inputGridRef.current : readGridRef.current;
    applyResult(removeUsersFromList(listState(), collectChecked(g), domain));
  };
  // [∨] 입력→조회 / [∧] 조회→입력 이동 (도착 중복 가드)
  const handleMove = (toDomain: AuthDomain) => {
    const g = toDomain === AUTH_TYPE.WRITE ? readGridRef.current : inputGridRef.current;
    applyResult(moveUsersBetweenLists(listState(), collectChecked(g), toDomain));
  };

  // ===== 요청 grid — 행내 처리 버튼 [✓입력][✓조회][x반려] (메타 attribute1='REQ_ACTION') =====
  const reqStateRef = useRef({ inputList, readList, decisions });
  reqStateRef.current = { inputList, readList, decisions };
  const reqRowsRef = useRef(reqRows);
  reqRowsRef.current = reqRows;

  useEffect(() => {
    const g = reqGridRef.current;
    if (!g || !open) return;
    const actionBinding = (staticColumns[SHEETS.POP1_GRID4] ?? []).find(
      c => c.attribute1 === REQ_ACTION_ATTR
    )?.colNm;

    const formatHandler = (_s: FlexGridType<Pop1ReqRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      const row = g.rows[e.row]?.dataItem as Pop1ReqRow | undefined;
      if (!row) return;
      const reqUser = String(row.USER_ID ?? '');
      const decision = reqStateRef.current.decisions[reqUser];
      // 처리 컬럼(§10 PROCESS — SP '' 리터럴) — 버튼 3종. ⭐ DPJT_AUTH_STATUS='REQUEST' 행만 활성
      //   (REJECT·NULL 이력 행은 표시만 — 계약 결정 9)
      if (binding === actionBinding && actionBinding) {
        const requestable = String(row.DPJT_AUTH_STATUS ?? '') === AUTH_STATUS.REQUEST;
        e.cell.textContent = '';
        const mk = (act: string, label: string, cls: string, active: boolean) => {
          const b = document.createElement('button');
          b.type = 'button';
          b.dataset.act = act;
          b.dataset.user = reqUser;
          b.className = `${styles.reqActionBtn} ${cls} ${active ? styles.reqActionBtnActive : ''}`;
          b.textContent = label;
          b.disabled = !requestable;
          e.cell.appendChild(b);
        };
        // 리터럴 = 목업 표기 (LBL 미채번 — 신규 채번 금지 관행)
        mk(AUTH_TYPE.WRITE, '✓ 입력', styles.reqActionBtnApprove, decision?.status === REQ_DECISION.APPROVE && decision.authType === AUTH_TYPE.WRITE);
        mk(AUTH_TYPE.READ, '✓ 조회', styles.reqActionBtnApprove, decision?.status === REQ_DECISION.APPROVE && decision.authType === AUTH_TYPE.READ);
        mk('REJECT', 'x 반려', styles.reqActionBtnReject, decision?.status === REQ_DECISION.REJECT);
        return;
      }
      // 상태 컬럼(§10 DPJT_AUTH_STATUS_NAME) — pending 결정 pill (승인 Green / 반려 Red — 설계 2.3.
      //   FE pending 시각화 — 커서 색 컬럼 없음. 미결정 행은 커서 상태명 그대로)
      if (binding === 'DPJT_AUTH_STATUS_NAME' && decision) {
        e.cell.textContent = '';
        const pill = document.createElement('span');
        const approved = decision.status === REQ_DECISION.APPROVE;
        pill.className = `${styles.tag} ${approved ? styles.tagGreen : styles.tagRed}`;
        pill.textContent = approved ? '승인' : '반려';
        e.cell.appendChild(pill);
      }
    };
    g.formatItem.addHandler(formatHandler);

    const clickHandler = (ev: MouseEvent) => {
      const btn = (ev.target as HTMLElement).closest(
        `button[data-act]`
      ) as HTMLButtonElement | null;
      if (!btn || btn.disabled) return;
      const reqUser = btn.dataset.user ?? '';
      const row = reqRowsRef.current.find(r => String(r.USER_ID ?? '') === reqUser);
      if (!row) return;
      applyResult(
        applyRequestDecision(reqStateRef.current, row, btn.dataset.act as AuthDomain | 'REJECT')
      );
      g.invalidate();
    };
    g.hostElement.addEventListener('click', clickHandler);

    g.invalidate(true);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, reqRows, staticColumns[SHEETS.POP1_GRID4]]);

  // pending 결정/리스트 변경 시 요청 grid 재도색 (버튼 활성 표시·상태 pill)
  useEffect(() => {
    reqGridRef.current?.invalidate();
  }, [decisions, inputList, readList]);

  // ===== OK — ①WRITE replace-set ②READ replace-set ③반려 단건 반복 → EVENT 합산 판정 =====
  //   ⚠ §11/§12 교차 소거 결함(§18-9② — WRITE 저장이 무요청 READ 권한자를 소거·역도 동일)은
  //     발신처 확인 대상 — FE 는 항상 **두 리스트를 연속 저장**해 최종 화면 상태와 원장을 일치시킨다
  //     (①에서 소거된 READ 가 ②목록 포함으로 즉시 CONFIRM 복원 — 연속 호출이 자체 보정).
  const handleOk = async () => {
    if (saving || dpjtKey === '') return;
    setSaving(true);
    try {
      const writeIds = buildAuthUserIds(inputList);
      const readIds = buildAuthUserIds(readList);
      const rejectIds = buildRejectUserIds(decisions);
      // 최종·초기 둘 다 빈 리스트 = no-op — '' 단독 '^' payload (§0.2 빈 토큰) 회피
      const needWrite = writeIds.length > 0 || (writeData?.data ?? []).length > 0;
      const needRead = readIds.length > 0 || (readData?.data ?? []).length > 0;

      let totalEvent = 0;
      let called = false;
      const fail = (message?: string) => {
        void setAlert({
          type: 'alert',
          content: message || t(MSG.SAVE_ERROR, '_저장에 실패하였습니다.'),
        });
        // 중도 실패 — 앞선 호출은 SP 내부 COMMIT(§0.3) 확정: 메인 TAG 정합 재조회
        if (totalEvent > 0) onSaved();
      };
      if (needWrite) {
        called = true;
        const r = await callSaveAuthWrite(dpjtKey, writeIds);
        if (!r.ok) return fail(r.message);
        totalEvent += r.event;
      }
      if (needRead) {
        called = true;
        const r = await callSaveAuthRead(dpjtKey, readIds);
        if (!r.ok) return fail(r.message);
        totalEvent += r.event;
      }
      for (const userId of rejectIds) {
        called = true;
        const r = await callRejectAuthReq(dpjtKey, userId);
        if (!r.ok) return fail(r.message);
        totalEvent += r.event;
      }

      if (called && totalEvent === 0) {
        // EVENT 0 — 처리된 행 없음 (허위성공 방지: 성공 토스트 금지). pending 유지한 채 안내
        setToast({ type: 'default', message: '처리된 권한 변경이 없습니다.' });
        return;
      }
      if (called) {
        // ⭐ 저장 성공 = Toast (hook #132 — Alert 금지) + 메인 TAB1 재조회 (권한등록 상태 TAG 갱신)
        setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
        onSaved();
      }
      modalClose();
    } finally {
      setSaving(false);
    }
  };

  const iconBtn = (label: string, onClick: () => void, title: string) => (
    <button
      type='button'
      className={styles.iconBtn}
      onClick={onClick}
      disabled={saving}
      title={title}
    >
      {label}
    </button>
  );

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      height='57.6vh' // 2026-08-13 사용자 지시 — 기존 72vh 의 80%
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* 모달 타이틀 = 목업 '권한관리' (LBL 미채번 — 리터럴) */}
          <h2 className='headerTitle'>권한관리</h2>
        </div>
      }
      customContentArea={
        <div className={styles.authModalWrapper}>
          {/* ===== 헤더바 (목업) — * Project Name | User ID(Name) 검색 | Search(F5) ===== */}
          <div className={styles.authSearchBar}>
            <span className={styles.authProjectName}>
              {`* Project Name : ${target?.dpjtName ?? ''}`}
            </span>
            <span className={styles.authSearchSpacer} />
            {/* 라벨 = 목업 표기 (LBL 미채번 — 리터럴) */}
            <label className={styles.authSearchLabel} htmlFor='authPopupUserName'>
              User ID(Name)
            </label>
            <input
              id='authPopupUserName'
              className={styles.authSearchInput}
              value={userNameInput}
              disabled={saving}
              onChange={e => setUserNameInput(e.target.value)}
              onKeyDown={e => {
                if (e.key === 'Enter') handleUserSearch();
              }}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='small'
              buttonLabel={t('LBL00112', '_Search(F5)')}
              disabled={saving}
              onClick={handleUserSearch}
            />
          </div>

          <div className={styles.authModalBody}>
            {/* 좌측 — 조직도 트리 (POP1_TREE §6) */}
            <div className={styles.treePanel}>{renderTree(treeRoots)}</div>

            {/* 가운데 — 사용자 목록 (POP1_GRID1 §7, 세로 전체) */}
            <div className={styles.userPanel}>
              <div className={styles.gridTitle}>사용자 목록</div>
              <div className={`${styles.modalGridWrapper} ${styles.authGrid}`}>
                <DataGrid<Pop1UserRow>
                  gridRef={userGridRef}
                  itemsSource={userRows}
                  staticColumns={staticColumns[SHEETS.POP1_GRID1] ?? []}
                  autoGenerateColumns={false}
                  allowSorting={false}
                  useCheckbox={true}
                  isReadOnly={true}
                />
              </div>
            </div>

            {/* 우측 — [+][−]|입력 → ∨∧ → [+][−]|조회 → 요청 (목업 배치) */}
            <div className={styles.authRightArea}>
              <div className={styles.midBtnCol}>
                {iconBtn('＋', () => handleAdd(AUTH_TYPE.WRITE), '사용자 목록 → 입력')}
                {iconBtn('－', () => handleRemove(AUTH_TYPE.WRITE), '입력 리스트에서 제외')}
              </div>
              <div className={styles.blockWithTitle}>
                <div className={styles.gridTitle}>입력</div>
                <div className={`${styles.modalGridWrapper} ${styles.authGrid}`}>
                  <DataGrid<Pop1AuthRow>
                    gridRef={inputGridRef}
                    itemsSource={inputList}
                    staticColumns={staticColumns[SHEETS.POP1_GRID2] ?? []}
                    autoGenerateColumns={false}
                    allowSorting={false}
                    useCheckbox={true}
                    isReadOnly={true}
                  />
                </div>
              </div>

              <div />
              <div className={styles.moveRow}>
                {iconBtn('∨', () => handleMove(AUTH_TYPE.READ), '입력 → 조회 이동')}
                {iconBtn('∧', () => handleMove(AUTH_TYPE.WRITE), '조회 → 입력 이동')}
              </div>

              <div className={styles.midBtnCol}>
                {iconBtn('＋', () => handleAdd(AUTH_TYPE.READ), '사용자 목록 → 조회')}
                {iconBtn('－', () => handleRemove(AUTH_TYPE.READ), '조회 리스트에서 제외')}
              </div>
              <div className={styles.blockWithTitle}>
                <div className={styles.gridTitle}>조회</div>
                <div className={`${styles.modalGridWrapper} ${styles.authGrid}`}>
                  <DataGrid<Pop1AuthRow>
                    gridRef={readGridRef}
                    itemsSource={readList}
                    staticColumns={staticColumns[SHEETS.POP1_GRID3] ?? []}
                    autoGenerateColumns={false}
                    allowSorting={false}
                    useCheckbox={true}
                    isReadOnly={true}
                  />
                </div>
              </div>

              <div />
              <div className={`${styles.blockWithTitle} ${styles.blockSpacedTop}`}>
                <div className={styles.gridTitle}>요청</div>
                <div className={`${styles.modalGridWrapper} ${styles.authGrid}`}>
                  <DataGrid<Pop1ReqRow>
                    gridRef={reqGridRef}
                    itemsSource={reqRows}
                    staticColumns={staticColumns[SHEETS.POP1_GRID4] ?? []}
                    autoGenerateColumns={false}
                    allowSorting={false}
                    isReadOnly={true}
                  />
                </div>
              </div>
            </div>
          </div>

          {/* 자체 footer (P9 — customContentArea 사용 시 의무) */}
          <div className={styles.modalButtonWrapper}>
            {/* Close = LBL00627 (LBL00062 는 'From Date' — 오배정 실측 정정 계보) */}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              disabled={saving}
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              disabled={saving}
              onClick={() => void handleOk()}
            />
          </div>
        </div>
      }
    />
  );
};
