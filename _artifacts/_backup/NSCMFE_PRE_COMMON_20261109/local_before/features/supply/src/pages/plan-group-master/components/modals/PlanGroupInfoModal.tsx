import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils, safeString } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useSaveWithValidation, useTabComboQueries } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { DIVISION_COMBO_ID, MENU_ID, MSG } from '../../plan-group-master.constants';

import { OwnerSelectModal } from './OwnerSelectModal';
import styles from './PlanGroupInfoModal.module.scss';
import { usePlanGroupInfoModalStore } from './planGroupInfoModalStore';

// 등록 팝업 그리드 컬럼(AS-IS SCP0121_PlanGroupInfoPopup / admin sheet 'PlanGroupInfoPopup').
const COL = {
  PLAN_GR_ID: 'OPMZ_PLAN_GR_ID',
  PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  PLAN_GR_DESC: 'OPMZ_PLAN_GR_DESC',
  TGT_DIVS_CD: 'OPMZ_TGT_DIVS_CD',
  OWNER: 'OWNER',
  OWNER_NAME: 'OWNER_NAME',
  VALID_YN: 'VALID_YN',
} as const;

const DELIM = '^';

// 팝업 GET/SAVE 라우팅(SCM_ADM_MNU_BTN_MPG_M SHT_NM='planGroupPopup'). 세션(sesUserId 등)은 BE 자동주입.
const GET_URL = `/${MENU_ID}/planGroupPopup/SEARCH/call-proc`;
const SAVE_URL = `/${MENU_ID}/planGroupPopup/SAVE/call-proc`;

type PopupRow = WijmoRowItem;

const str = (v: unknown): string => safeString(v).trim();
const isInsertRow = (row: PopupRow): boolean =>
  row.CRUD_TYPE === CRUD_TYPE.CREATE || row.CRUD_TYPE === CRUD_TYPE.INSERT;

interface PlanGroupInfoModalProps {
  open: boolean;
  division: string;
  divisionText: string;
  modalClose: () => void;
  // OK(등록 반영) 시 호출 — 부모가 GET_SEARCH_INFO 재조회 + PlanGroup 콤보/셀콤보 invalidate (R3, 02 §4.6).
  onRegistered: () => void;
}

/**
 * Plan Group 등록 팝업 (btnPlanGroupReg → AS-IS SCP0121_PlanGroupInfoPopup).
 *   GET: PKG_SCP0121.P_SCP0121_GET_PLAN_GROUP_POPUP(division). SAVE: P_SCP0121_SAVE_PLAN_GR_POPUP
 *   (crudType/planGroupId/name/desc/tgtDivsCd/owner/ownerName/validYn '^'-fold + division + sesUserId).
 *   CRUD: 신규행 'I'(PLAN_GR_ID 는 SP 생성), 기존행 'M'. 삭제는 VALID_YN='N'. Owner 셀 더블클릭 → OwnerSelectModal.
 */
export const PlanGroupInfoModal = ({
  open,
  division,
  divisionText,
  modalClose,
  onRegistered,
}: PlanGroupInfoModalProps) => {
  const { t } = useTranslation();
  const { setToast, setAlert } = useMessageStore.getState();
  const { saveWithValidation } = useSaveWithValidation();

  const gridRef = useRef<FlexGrid<PopupRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const editTrackerRef = useRef<EditTracker<PopupRow>>();
  const savingRef = useRef<boolean>(false);
  const ownerRowRef = useRef<number>(-1);

  const staticColumns = usePlanGroupInfoModalStore(state => state.staticColumns);
  const fetchStaticColumns = usePlanGroupInfoModalStore(state => state.fetchStaticColumns);

  const [rows, setRows] = useState<PopupRow[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [openOwner, setOpenOwner] = useState<boolean>(false);

  // 좌상단 Division 표시명(AS-IS '81 Automotive Battery') — Division_SCP 콤보 NAME(react-query 캐시 재사용).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: DIVISION_COMBO_ID, mnuId: MENU_ID }],
  });
  const divisionName =
    str((divisions ?? []).find(item => String(item.CODE) === division)?.NAME) ||
    divisionText ||
    division;

  const fetchRows = async () => {
    if (!division) return;
    setLoading(true);
    try {
      const res = await apiClient.post<{ o_rc1?: PopupRow[] }>(GET_URL, { divisionId: division });
      setRows(res.data.result?.o_rc1 ?? []);
    } finally {
      setLoading(false);
    }
  };

  // 팝업 오픈 시 컬럼 메타 + 그리드 조회. division 이 바뀌어도 열려 있는 동안 재조회(상위 Division 반영).
  //   컬럼 메타는 항상 재조회한다 — store 가 persist(sessionStorage) 라 과거 메타(콤보 변경 전)가 남아
  //   하드 새로고침으로도 안 지워져 Type 콤보 등 메타 변경이 반영 안 되던 문제(2026-10-15).
  useEffect(() => {
    if (!open) return;
    void fetchStaticColumns();
    void fetchRows();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, division]);

  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    // 신규행 기본 VALID_YN='Y' (AS-IS InsertRow). PLAN_GR_ID 는 빈값(SP 채번), 메타 'S' 라 잠김.
    GridAction.addRow(grid, { [COL.VALID_YN]: 'Y' } as Partial<PopupRow>, 'above', true);
  };

  const performSave = async (dirty: PopupRow[]) => {
    const join = (pick: (r: PopupRow) => string): string => dirty.map(pick).join(DELIM);
    const payload = {
      crudType: join(r => (isInsertRow(r) ? CRUD_TYPE.INSERT : CRUD_TYPE.MODIFY)),
      divisionId: division, // 단일
      planGroupId: join(r => str(r[COL.PLAN_GR_ID])),
      planGroupName: join(r => str(r[COL.PLAN_GR_NAME])),
      planGroupDesc: join(r => str(r[COL.PLAN_GR_DESC])),
      tgtDivsCd: join(r => str(r[COL.TGT_DIVS_CD])),
      owner: join(r => str(r[COL.OWNER])),
      ownerName: join(r => str(r[COL.OWNER_NAME])),
      validYn: join(r => str(r[COL.VALID_YN]) || 'Y'),
    };
    savingRef.current = true;
    try {
      const res = await apiClient.post<{ code?: string | number; message?: string }>(
        SAVE_URL,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        void setAlert({
          type: 'alert',
          content: res.data?.message ?? t(MSG.SAVE_FAIL, '_An error occurred while saving.'),
        });
        return;
      }
      void setToast({
        type: 'success',
        message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace('{0}', String(dirty.length)),
      });
      editTrackerRef.current?.clearChanges();
      await fetchRows();
      onRegistered(); // 부모 조회조건/셀콤보 갱신 (R3).
    } finally {
      savingRef.current = false;
    }
  };

  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid || savingRef.current) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as PopupRow[];
    const dirty = source.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      void setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 공용 필수검증(NAME='M' 등) — 실패 시 "[컬럼] 값은 필수 입력 항목입니다." 후 중단.
    saveWithValidation(dirty, staticColumns, () => void performSave(dirty));
  };

  // Owner 셀 더블클릭 → OwnerSelectModal (AS-IS SpdMain_CellDoubleClick → SCP0121_OwnerPopup).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    if (GridUtils.getBinding(grid, ht.col) !== COL.OWNER) return;
    ownerRowRef.current = ht.row;
    setOpenOwner(true);
  };

  const handleOwnerConfirm = ({ owner, userNameEn }: { owner: string; userNameEn: string }) => {
    const grid = gridRef.current;
    const item = GridUtils.getRow(grid, ownerRowRef.current);
    if (!grid || !item) return;
    editTrackerRef.current?.storeChange(item, COL.OWNER, str(item[COL.OWNER]), owner);
    item[COL.OWNER] = owner;
    item[COL.OWNER_NAME] = userNameEn;
    GridUtils.refreshRow(grid, ownerRowRef.current);
  };

  const ownerCurrent = str(GridUtils.getRow(gridRef.current, ownerRowRef.current)?.[COL.OWNER]);

  return (
    <>
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
            <h2 className='headerTitle'>Plan Group Info</h2>
          </div>
        }
        customContentArea={
          <div className={styles.dialogContent}>
            <div className={styles.toolbar}>
              {/* AS-IS 좌상단 Division 표시(예: '81 Automotive Battery'). */}
              <span className={styles.divLabel}>{divisionName}</span>
            </div>
            <div className={styles.gridWrap}>
              <ProgressIndicator
                shape='circular'
                apprearance='infinite'
                open={loading}
                placement='parent'
              />
              <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
                <DataGrid<PopupRow>
                  gridRef={gridRef}
                  gridFilterRef={gridFilterRef}
                  editTrackerRef={editTrackerRef}
                  itemsSource={rows}
                  staticColumns={staticColumns}
                  comboParams={{ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }}
                  className={styles.grid}
                  dblClick={handleDblClick}
                />
              </ResultArea>
            </div>
            <div className={styles.footer}>
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00121', 'Insert')}
                onClick={handleInsert}
              />
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                disabled={loading}
                onClick={handleSave}
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00627', 'Close')}
                onClick={modalClose}
              />
            </div>
          </div>
        }
      />
      <OwnerSelectModal
        open={openOwner}
        modalClose={() => setOpenOwner(false)}
        divisionId={division}
        ownerId={ownerCurrent}
        onConfirm={handleOwnerConfirm}
      />
    </>
  );
};
