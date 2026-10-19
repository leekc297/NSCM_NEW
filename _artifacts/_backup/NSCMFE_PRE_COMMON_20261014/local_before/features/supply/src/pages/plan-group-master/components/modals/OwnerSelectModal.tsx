import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ArrowChevron2Icon, ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { LBL, OWNER_POPUP_MENU_ID, OWNER_POPUP_SHEETS } from './owner-select-modal.constants';
import styles from './OwnerSelectModal.module.scss';
import { useOwnerSelectModalStore } from './ownerSelectModalStore';

export type OwnerRow = ResponseData<OWNER_POPUP_MENU_ID, OWNER_POPUP_SHEETS.OWNER, 'o_rc1'>;

interface OwnerSelectModalProps {
  open: boolean;
  modalClose: () => void;
  /** 부모(SCP0121_PlanGroupMaster) division — AS-IS 생성자 sDivision → p_division_id. */
  divisionId: string;
  /** 기선택 owner UserID CSV — AS-IS 생성자 sOwner → p_owner_id(초기 User 그리드 채움). */
  ownerId?: string;
  /** OK 확정 반환 — AS-IS SaveTitleSet: owner=UserID CSV, userNameEn=USER_NAME_EN CSV. */
  onConfirm: (value: { owner: string; userNameEn: string }) => void;
}

// 이동 후 대상 그리드 SORT_ORDER_NO 오름차순 정렬(AS-IS SetTitleSet cs L440-446, design 01 R3/R4).
const sortBySortOrder = (rows: OwnerRow[]): OwnerRow[] =>
  [...rows].sort((a, b) => Number(a.SORT_ORDER_NO) - Number(b.SORT_ORDER_NO));

/**
 * AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0121_PlanGroupMaster/SCP0121_OwnerPopup.cs
 *
 * 좌(Owner Base 후보) / 우(Owner User 선택) 두 그리드 셔틀 팝업. 데이터 SP 는 2 커서를 서버에서
 * Base/User 로 분리(p_owner_id NOT IN / IN)하므로, 이동은 공통 OwnerModal(COM0004, 단일커서 클라분리)과
 * 달리 두 그리드의 실제 행 목록(baseRows/userRows)을 클라에서 옮기는 방식으로 재현한다.
 * 초기 open 은 두 그리드 모두 바인딩, Find 재조회는 Base 만 교체하고 User 는 유지한다(design 01 R1/R2).
 */
export const OwnerSelectModal = ({
  open,
  modalClose,
  divisionId,
  ownerId,
  onConfirm,
}: OwnerSelectModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const baseGridRef = useRef<FlexGrid<OwnerRow>>();
  const userGridRef = useRef<FlexGrid<OwnerRow>>();
  const baseFilterRef = useRef<FlexGridFilter | undefined>();
  const userFilterRef = useRef<FlexGridFilter | undefined>();

  const staticColumn = useOwnerSelectModalStore(state => state.staticColumn);
  const fetchStaticColumns = useOwnerSelectModalStore(state => state.fetchStaticColumns);

  // 두 그리드의 실제 행 목록(클라 상태) — 이동 셔틀의 진실원.
  const [baseRows, setBaseRows] = useState<OwnerRow[]>([]);
  const [userRows, setUserRows] = useState<OwnerRow[]>([]);

  // 입력 중 검색어 — Find 눌러야 조회 조건(searchParam)에 반영된다.
  const [userInput, setUserInput] = useState('');

  // 실제 발사 조건. filters 참조가 바뀔 때만 useTabProcQuery 가 재조회한다(nscm-patterns §5-1/2).
  const [searchParam, setSearchParam] = useState<{
    divisionId: string;
    search: string;
    ownerId: string;
  }>({ divisionId, search: '', ownerId: ownerId ?? '' });

  // 초기 조회(GetOwnerData(true)) vs Find 재조회(false) 구분 — 초기만 User 그리드까지 바인딩.
  const isInitialLoadRef = useRef(true);

  // 이동 직후 대상 그리드에서 활성화할 행 — 삽입행 시각 표시(AS-IS SetTitleSet activeRow 이동, design 01 R7).
  const pendingActivateRef = useRef<{ target: 'base' | 'user'; id: string } | null>(null);

  const filters = useMemo(() => (open ? searchParam : undefined), [open, searchParam]);

  const { data, isLoading, isFetching } = useTabProcQuery<
    OWNER_POPUP_MENU_ID,
    OWNER_POPUP_SHEETS.OWNER
  >({
    menuId: OWNER_POPUP_MENU_ID,
    sheetName: OWNER_POPUP_SHEETS.OWNER,
    tabId: OWNER_POPUP_MENU_ID,
    filters,
    enabled: !!filters,
  });
  const loading = isLoading || isFetching;

  // 서버 응답 바인딩 — o_rc1=Base 후보, o_rc2=User 기선택.
  useEffect(() => {
    if (!data) return;
    const base = sortBySortOrder(data.o_rc1 ?? []);
    if (isInitialLoadRef.current) {
      setBaseRows(base);
      setUserRows(sortBySortOrder(data.o_rc2 ?? []));
      isInitialLoadRef.current = false;
    } else {
      // Find 재조회: Base 만 교체, User 는 클라 상태 유지(design 01 R2 / 03 §4).
      setBaseRows(base);
    }
  }, [data]);

  // 팝업 오픈 시 초기화 — 검색어 비우고 부모가 넘긴 division/owner 로 초기 조회.
  useEffect(() => {
    if (!open) return;
    isInitialLoadRef.current = true;
    setUserInput('');
    setSearchParam({ divisionId, search: '', ownerId: ownerId ?? '' });
    if (staticColumn.length === 0) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const candidateCount = baseRows.length;
  const selectedCount = userRows.length;

  // 선택행(없으면 활성행 1건 자동선택) 추출 — AS-IS cs L355-356(선택 없으면 ActiveRow).
  const pickRows = (grid: FlexGrid<OwnerRow> | undefined): OwnerRow[] => {
    if (!grid) return [];
    const selected = (grid.selectedItems ?? []) as unknown as OwnerRow[];
    if (selected.length > 0) return selected;
    const active = GridUtils.getRow(grid, grid.selection.row);
    return active ? [active] : [];
  };

  // Base->User / User->Base 공통 이동. 원본 제거 + 대상 SORT_ORDER_NO 정렬(design 01 R3/R4/R7).
  const moveRows = (from: 'base' | 'user', rows: OwnerRow[]) => {
    if (rows.length === 0) return;
    const ids = new Set(rows.map(row => row.UserID));
    // 이동 후 대상 그리드에서 방금 옮긴 행을 활성화한다(AS-IS 는 activeRow+1 삽입 후 그 행 선택, design 01 R7).
    // 최종 순서는 sortBySortOrder 로 확정되므로 위치가 아니라 시각적 활성화만 재현한다.
    pendingActivateRef.current = { target: from === 'base' ? 'user' : 'base', id: rows[0].UserID };
    if (from === 'base') {
      setBaseRows(prev => prev.filter(row => !ids.has(row.UserID)));
      setUserRows(prev => sortBySortOrder([...prev, ...rows]));
    } else {
      setUserRows(prev => prev.filter(row => !ids.has(row.UserID)));
      setBaseRows(prev => sortBySortOrder([...prev, ...rows]));
    }
  };

  // 이동 직후(대상 rows 갱신 시) 옮긴 행을 대상 그리드에서 선택·스크롤한다 — 삽입행 시각 표시(design 01 R7, GAP-02).
  useEffect(() => {
    const pending = pendingActivateRef.current;
    if (!pending) return;
    pendingActivateRef.current = null;
    const grid = pending.target === 'base' ? baseGridRef.current : userGridRef.current;
    const rows = pending.target === 'base' ? baseRows : userRows;
    if (!grid) return;
    const index = rows.findIndex(row => row.UserID === pending.id);
    if (index < 0) return;
    grid.select(index, 0);
    grid.scrollIntoView(index, 0);
  }, [baseRows, userRows]);

  const handleMoveToUser = () => {
    moveRows('base', pickRows(baseGridRef.current));
    baseGridRef.current?.select(-1, -1);
  };

  const handleMoveToBase = () => {
    moveRows('user', pickRows(userGridRef.current));
    userGridRef.current?.select(-1, -1);
  };

  // 더블클릭 이동 — 클릭한 셀의 행 1건만 이동(AS-IS spdBase/spdUser_CellDoubleClick).
  const handleDblClick = (from: 'base' | 'user') => (mouseEvent: MouseEvent) => {
    const grid = from === 'base' ? baseGridRef.current : userGridRef.current;
    if (!grid) return;
    const hit = grid.hitTest(mouseEvent);
    if (hit.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, hit.row);
    if (row) moveRows(from, [row]);
  };

  // OK — User 0행이면 MSG00071 후 차단, 아니면 owner/userNameEn CSV 반환(design 01 R5).
  const handleConfirm = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00071', 'No rows selected.') });
      return;
    }
    onConfirm({
      owner: userRows.map(row => row.UserID).join(','),
      userNameEn: userRows.map(row => row.USER_NAME_EN).join(','),
    });
    modalClose();
  };

  // Find — 재조회 전 현재 User 그리드 UserID CSV 를 p_owner_id 로 재전달(기선택 유지, design 02 §3).
  const handleSearch = () => {
    setSearchParam({
      divisionId,
      search: userInput,
      ownerId: userRows.map(row => row.UserID).join(','),
    });
  };

  return (
    <CustomDialog
      open={open}
      size={850}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_MULTI_OWNER_SET', 'Multi Owner Set')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <Grid size={4}>
                <FormItem
                  label={t(LBL.USER_ID_NAME, 'User ID(Name)')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={userInput}
                      onChange={event => setUserInput(event.target.value)}
                      onKeyDown={event => event.key === 'Enter' && handleSearch()}
                    />
                  )}
                />
              </Grid>
            }
          />
          <div className={styles.transferBody}>
            <div className={styles.gridPane}>
              <ProgressIndicator
                shape='circular'
                apprearance='infinite'
                open={loading}
                placement='parent'
              />
              <ResultArea
                title={t('LBL_OWNER_BASE', 'Owner Base')}
                count={candidateCount}
                gridRef={baseGridRef}
                gridFilterRef={baseFilterRef}
              >
                <DataGrid<OwnerRow>
                  gridRef={baseGridRef}
                  gridFilterRef={baseFilterRef}
                  itemsSource={baseRows}
                  staticColumns={staticColumn}
                  autoGenerateColumns={false}
                  isReadOnly
                  className={styles.grid}
                  dblClick={handleDblClick('base')}
                />
              </ResultArea>
            </div>
            <div className={styles.moveButtons}>
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                iconComponent={<ArrowChevron2Icon appearance='single' direction='right' />}
                onClick={handleMoveToUser}
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                iconComponent={<ArrowChevron2Icon appearance='single' direction='left' />}
                onClick={handleMoveToBase}
              />
            </div>
            <div className={styles.gridPane}>
              <ResultArea
                title={t('LBL_OWNER_USER', 'Owner User')}
                count={selectedCount}
                gridRef={userGridRef}
                gridFilterRef={userFilterRef}
              >
                <DataGrid<OwnerRow>
                  gridRef={userGridRef}
                  gridFilterRef={userFilterRef}
                  itemsSource={userRows}
                  staticColumns={staticColumn}
                  autoGenerateColumns={false}
                  isReadOnly
                  className={styles.grid}
                  dblClick={handleDblClick('user')}
                />
              </ResultArea>
            </div>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, 'OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={loading}
              onClick={handleConfirm}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CANCEL, 'Cancel')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
