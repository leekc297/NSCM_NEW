import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../contribute-view.constants';

import styles from './ColumnTitleSetModal.module.scss';

// AS-IS DM0002_TitleSetForm_Popup (.cs) 공통기능 — 컬럼 표시 설정
//
// AS-IS 호출 (DMF0043_Contribute_View.cs L475):
//   DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0043", "ContributeSalesList", true, "40");
//
// AS-IS GetTitleSet (DM0002 .cs L236~255):
//   request = "DM.DMF0002_GET_TITLESET_POPUP"
//   p_program_id  = 'DMF0043'
//   p_sheet_name  = 'ContributeSalesList'
//   p_column_type = 'C' (Column)
//   p_user_id     = (자동)
//   p_division_id = '40'
//
// 결과 컬럼 (DM0002 .cs L165~210):
//   COLUMN_NAME / COLUMN_LABEL_NAME / LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME
//   SORT_METHOD_CODE / SORT_ORDER_NO / USER_SORT_METHOD_CODE / SUB_TOTAL_FLAG / USER_SELECTABLE_FLAG
//   DEFAULT_FLAG ('Y' = 기본 사용 컬럼 / 'N' = 기본 미사용)
//   USER_FLAG    ('Y' = 사용자 선택 사용 / 'N' = 사용자 선택 미사용)
//
// UI (DM0002 .cs L113~210):
//   - Base 그리드 (USER_FLAG='N')  : 좌측 — 미사용 컬럼
//   - User 그리드 (USER_FLAG='Y')  : 우측 — 사용 컬럼
//   - 중앙 버튼: < (User → Base), > (Base → User)
//   - 더블클릭: 다른 쪽으로 이동
//   - 하단: Default (기본값으로 복원, DEFAULT_FLAG 기준), OK (저장 — Phase 2), Cancel
//
// Phase 1 (2026-06-01): SP 호출 + Base/User 분리 + 이동 + onApply trigger
// Phase 2 (후속): SAVE SP (SCM0002_SET_TITLESET_POPUP) + Sort / SubTotal / 정렬 순서

interface TitleSetRow {
  COLUMN_NAME?: string;
  COLUMN_LABEL_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  SORT_METHOD_CODE?: string;
  SORT_ORDER_NO?: string | number;
  USER_SORT_METHOD_CODE?: string;
  SUB_TOTAL_FLAG?: string;
  USER_SELECTABLE_FLAG?: string;
  DEFAULT_FLAG?: string;
  USER_FLAG?: string;
}

interface Props {
  open: boolean;
  onClose: () => void;
  onApply: () => void;            // AS-IS L481~482: DialogResult.OK → InitSpread() (= mainTitle refetch)
}

export const ColumnTitleSetModal = ({ open, onClose, onApply }: Props) => {
  const setAlert = useMessageStore(s => s.setAlert);
  const baseGridRef = useRef<FlexGridType<TitleSetRow> | null>(null);
  const userGridRef = useRef<FlexGridType<TitleSetRow> | null>(null);

  // AS-IS GetTitleSet (.cs L236): SP DMF0002_GET_TITLESET_POPUP 호출
  // PROC_M COL_NM 정합 (메모: feedback_proc_meta_col_nm_be_auto_keys):
  //   programId / sheetName / columnType / divisionId (sesUserId / mnuId 자동)
  const filters = useMemo(
    () =>
      open
        ? {
            programId: 'DMF0043',
            sheetName: 'ContributeSalesList',
            columnType: 'C',
            divisionId: '40',
          }
        : undefined,
    [open]
  );

  const { data } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.TITLE_SET,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });

  // 전체 row state (USER_FLAG 토글로 Base/User 분리)
  const [rows, setRows] = useState<TitleSetRow[]>([]);

  // SP 결과 → rows state 동기화 (open 시점)
  useEffect(() => {
    if (!open) {
      setRows([]);
      return;
    }
    // SP body 의 OUT cursor 는 o_cursor (PROC_M 등록값)
    const o = (data?.o_cursor ?? data?.o_rc1 ?? []) as TitleSetRow[];
    // ⛔ NUMBER → String cast (메모: feedback_no_type_cast_around_runtime)
    setRows(
      o.map(r => ({
        ...r,
        SORT_ORDER_NO: r.SORT_ORDER_NO != null ? String(r.SORT_ORDER_NO) : '',
      }))
    );
  }, [open, data]);

  // Base / User 분리 (USER_FLAG 기준 — AS-IS .cs L270~271 SetTitleSet 분기와 동일)
  const baseRows = useMemo(() => rows.filter(r => r.USER_FLAG !== 'Y'), [rows]);
  const userRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'Y'), [rows]);

  // AS-IS btnRight_Click (.cs L571): Base 선택 → User 로 이동 (USER_FLAG='Y')
  const handleMoveToUser = () => {
    const g = baseGridRef.current;
    if (!g) return;
    const selected = g.selectedItems as TitleSetRow[];
    if (!selected || selected.length === 0) {
      void setAlert({ type: 'alert', content: '이동할 컬럼을 선택해주세요.' });
      return;
    }
    const targets = new Set(selected);
    setRows(prev =>
      prev.map(r =>
        targets.has(r)
          ? { ...r, USER_FLAG: 'Y' }
          : r
      )
    );
  };

  // AS-IS btnLeft_Click (.cs L575): User 선택 → Base 로 이동 (USER_FLAG='N')
  const handleMoveToBase = () => {
    const g = userGridRef.current;
    if (!g) return;
    const selected = g.selectedItems as TitleSetRow[];
    if (!selected || selected.length === 0) {
      void setAlert({ type: 'alert', content: '제외할 컬럼을 선택해주세요.' });
      return;
    }
    const targets = new Set(selected);
    setRows(prev =>
      prev.map(r => {
        if (!targets.has(r)) return r;
        // AS-IS .cs L631: USER_SELECTABLE_FLAG='N' 은 이동 불가
        if (r.USER_SELECTABLE_FLAG === 'N') {
          return r;
        }
        return { ...r, USER_FLAG: 'N' };
      })
    );
  };

  // AS-IS usrButtonList1 Default (.cs L610~612): SetTitleSet(true) — DEFAULT_FLAG 로 재구성
  const handleResetDefault = () => {
    setRows(prev => prev.map(r => ({ ...r, USER_FLAG: r.DEFAULT_FLAG ?? 'N' })));
    void setAlert({ type: 'alert', content: '기본 컬럼으로 복원되었습니다.' });
  };

  // AS-IS usrButtonList1 OK (.cs L613~615): SaveTitleSet + DialogResult.OK
  //   Phase 1: 저장 SP 미구현 — onApply 만 호출 (mainTitle sheet refetch 트리거)
  //   Phase 2: SCM0002_SET_TITLESET_POPUP 호출 추가
  const handleApply = () => {
    void setAlert({
      type: 'alert',
      content: '컬럼 설정이 적용되었습니다. (저장 SP 미연동 — Phase 2 보강 예정)',
    });
    onApply();
    onClose();
  };

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>컬럼 표시 설정 (AS-IS DM0002)</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContent}>
          <div className={styles.note}>
            Program: DMF0043 / Sheet: ContributeSalesList / Division: 40
            &nbsp;|&nbsp; 전체 {rows.length}개 (사용 {userRows.length} / 미사용 {baseRows.length})
          </div>

          <div className={styles.splitGridArea}>
            {/* AS-IS spdBase (.cs L176): 미사용 컬럼 (Base) */}
            <div className={styles.gridPanel}>
              <div className={styles.panelTitle}>미사용 컬럼 (Base)</div>
              <div className={styles.gridWrapper}>
                <FlexGrid
                  initialized={(g: FlexGridType<TitleSetRow>) => {
                    baseGridRef.current = g;
                    g.isReadOnly = true;
                    g.selectionMode = 1; // Row
                  }}
                  itemsSource={baseRows}
                  autoGenerateColumns={false}
                  className={styles.grid}
                >
                  <FlexGridColumn binding='LARGE_CLASS_LABEL_NAME' header='LargeClass' width={100} />
                  <FlexGridColumn binding='SMALL_CLASS_LABEL_NAME' header='SmallClass' width={100} />
                  <FlexGridColumn binding='COLUMN_LABEL_NAME' header='Column' width={160} />
                  <FlexGridColumn binding='SORT_ORDER_NO' header='Seq' width={50} align='right' />
                </FlexGrid>
              </div>
            </div>

            {/* AS-IS pnlCenterButton (.cs L601): 중앙 이동 버튼 */}
            <div className={styles.centerButtons}>
              <button
                type='button'
                className={styles.moveButton}
                onClick={handleMoveToUser}
                title='Base → User'
                aria-label='Base → User'
              >
                ▶
              </button>
              <button
                type='button'
                className={styles.moveButton}
                onClick={handleMoveToBase}
                title='User → Base'
                aria-label='User → Base'
              >
                ◀
              </button>
            </div>

            {/* AS-IS spdUser (.cs L194): 사용 컬럼 (User) */}
            <div className={styles.gridPanel}>
              <div className={styles.panelTitle}>사용 컬럼 (User)</div>
              <div className={styles.gridWrapper}>
                <FlexGrid
                  initialized={(g: FlexGridType<TitleSetRow>) => {
                    userGridRef.current = g;
                    g.isReadOnly = true;
                    g.selectionMode = 1; // Row
                  }}
                  itemsSource={userRows}
                  autoGenerateColumns={false}
                  className={styles.grid}
                >
                  <FlexGridColumn binding='LARGE_CLASS_LABEL_NAME' header='LargeClass' width={100} />
                  <FlexGridColumn binding='SMALL_CLASS_LABEL_NAME' header='SmallClass' width={100} />
                  <FlexGridColumn binding='COLUMN_LABEL_NAME' header='Column' width={160} />
                  <FlexGridColumn binding='SORT_ORDER_NO' header='Seq' width={50} align='right' />
                </FlexGrid>
              </div>
            </div>
          </div>

          {/* AS-IS usrButtonList1 (.cs L606): Default / OK / Cancel */}
          <div className={styles.actionBar}>
            <button
              type='button'
              className={styles.actionButton}
              onClick={handleResetDefault}
              title='기본 컬럼으로 복원 (DEFAULT_FLAG)'
            >
              기본값
            </button>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={handleApply}
            >
              적용
            </button>
            <button type='button' className={styles.actionButton} onClick={onClose}>
              닫기
            </button>
          </div>
        </div>
      }
    />
  );
};
