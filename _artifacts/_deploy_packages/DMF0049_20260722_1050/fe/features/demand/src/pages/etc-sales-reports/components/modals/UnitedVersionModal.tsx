import { CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, REPORT_TYPE, SHEETS, VERSION_ACTION } from '../../etc-sales-reports.constants';
import type { UnitedVersionRow } from '../../etc-sales-reports.types';
import styles from '../../EtcSalesReports.module.scss';
import {
  callTransfer,
  callVersionAction,
  callVersionActionBp,
} from '../../utils/etc-sales-reports.api';
import { toCellStr } from '../../utils/etc-sales-reports.gridCombos';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  mdfType: string; // REPORT_SP_W / REPORT_BP_M — 액션 SP 분기 + 채택 게이트
  onSelect: (versionNo: string, label: string) => void; // txtSPVersion 주입
}

// 버전 목록 grid 컬럼 (P_DMF0044_GET_SALES_VERSION_POPUP 커서 — 조회 전용)
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 80 },
  { key: 'VERSION_NO', header: 'Version No', width: 150 },
  { key: 'VERSION_TYPE', header: 'Type', width: 110 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 240 },
  { key: 'SEND_YN', header: 'Send', width: 60 },
  { key: 'YYYYMMDD', header: 'Date', width: 100 },
];

// ⭐ United Version 팝업 — AS-IS DMF0044_United_VersionPopup(727행) 1:1:
//   조회(GET_SALES_VERSION_POPUP, 기간 기본 당월-1~+5개월) + 버전 채택(더블클릭/OK —
//   Type∈{REPORT_SP_W, REPORT_BP_M} 만) + 액션 5종(SEND_YN 게이트):
//   Transfer('T' MSG00685 SEND_YN=N만) / Cancel('C' MSG00686 Y만) / Delete('D' MSG00687 N·C만, MSG00683 confirm)
//   / Copy('CP' MSG00682 confirm — SP_W 계열=SAVE_SALES_PLAN_VERSION_COPY / BP 계열=SAVE_BIZ_PLAN 분기 L300~304).
export const UnitedVersionModal = ({ open, modalClose, divisionId, mdfType, onSelect }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<UnitedVersionRow>>(undefined);

  const [sdt, setSdt] = useState('');
  const [edt, setEdt] = useState('');
  const [description, setDescription] = useState('');
  const [selectedIdx, setSelectedIdx] = useState(-1);
  const [running, setRunning] = useState(false);

  useEffect(() => {
    if (open) {
      // 기본 기간 = 당월-1 ~ +5개월 (AS-IS Form_Load 기본값)
      setSdt(dayjs().subtract(1, 'month').startOf('month').format('YYYYMMDD'));
      setEdt(dayjs().add(5, 'month').endOf('month').format('YYYYMMDD'));
      setDescription('');
      setSelectedIdx(-1);
      setRunning(false);
    }
  }, [open]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId,
      sdt,
      edt,
      versionType: mdfType,
      description,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, sdt, edt, mdfType, description, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.UNITED_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.UNITED_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open && sdt !== '' && edt !== '',
  });
  const versionRows = useMemo<UnitedVersionRow[]>(
    () => ((data as { data?: UnitedVersionRow[] } | undefined)?.data ?? []),
    [data]
  );

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      VERSION_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          fixed: false,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })
      ),
    []
  );

  const selectedRow = versionRows[selectedIdx];

  // 버전 채택 — Type∈{REPORT_SP_W, REPORT_BP_M} 만 (AS-IS 더블클릭 게이트)
  const adopt = (row: UnitedVersionRow | undefined) => {
    if (!row) return;
    const vt = toCellStr(row.VERSION_TYPE);
    if (vt !== REPORT_TYPE.SP_W && vt !== REPORT_TYPE.BP_M) return;
    const versionNo = toCellStr(row.VERSION_NO);
    onSelect(versionNo, `${versionNo} ${toCellStr(row.VERSION_DESCRIPTION)}`.trim());
    modalClose();
  };

  // 행 선택 추적 + 더블클릭 채택 + No. 코너 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    const selHandler = () => setSelectedIdx(g.selection?.row ?? -1);
    const dblHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells) return;
      adopt(g.rows[ht.row]?.dataItem as UnitedVersionRow | undefined);
    };
    g.formatItem.addHandler(formatHandler);
    g.selectionChanged.addHandler(selHandler);
    g.hostElement.addEventListener('dblclick', dblHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.selectionChanged?.removeHandler(selHandler);
        g.hostElement?.removeEventListener('dblclick', dblHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, versionRows]);

  // ⭐ 액션 실행 공통 — SEND_YN 게이트 + confirm + SP 분기 (SP_W=SALES_PLAN / 그 외=BIZ_PLAN, L300~304)
  const runAction = async (action: string) => {
    if (running || !selectedRow) return;
    const sendYn = toCellStr(selectedRow.SEND_YN);
    const versionNo = toCellStr(selectedRow.VERSION_NO);
    const versionType = toCellStr(selectedRow.VERSION_TYPE);
    const desc = toCellStr(selectedRow.VERSION_DESCRIPTION);

    // SEND_YN 게이트 (MSG00685/686/687 — AS-IS 00318/319/320)
    if (action === VERSION_ACTION.TRANSFER && sendYn !== 'N') {
      void setAlert({ type: 'alert', content: t(MSG.SEND_ONLY_N, '_SEND_YN 이 N인 값만 전송할 수 있습니다.') });
      return;
    }
    if (action === VERSION_ACTION.CANCEL && sendYn !== 'Y') {
      void setAlert({ type: 'alert', content: t(MSG.CANCEL_ONLY_Y, '_SEND_YN 이 Y인 값만 취소할 수 있습니다.') });
      return;
    }
    if (action === VERSION_ACTION.DELETE && sendYn !== 'N' && sendYn !== 'C') {
      void setAlert({ type: 'alert', content: t(MSG.DELETE_ONLY_NC, '_SEND_YN 이 N 또는 C 인 값만 삭제할 수 있습니다.') });
      return;
    }
    // confirm (Delete=MSG00683 / Copy=MSG00682 / Cancel=MSG00684)
    const confirmMsg =
      action === VERSION_ACTION.DELETE
        ? t(MSG.DELETE_CONFIRM, '_삭제 하시겠습니까?')
        : action === VERSION_ACTION.COPY
          ? t(MSG.COPY_PLAN_ONLY, '_실적은 포함하지 않고, 계획만 복사하시겠습니까?')
          : action === VERSION_ACTION.CANCEL
            ? t(MSG.CANCEL_CONFIRM, '_취소하시겠습니까?')
            : '';
    if (confirmMsg) {
      const confirmed = await setAlert({ type: 'confirm', content: confirmMsg });
      if (!confirmed) return;
    }

    setRunning(true);
    try {
      let res;
      if (action === VERSION_ACTION.TRANSFER || action === VERSION_ACTION.CANCEL) {
        res = await callTransfer({ divisionId, versionNo, versionType, actionType: action });
      } else if (versionType === REPORT_TYPE.SP_W) {
        res = await callVersionAction({
          divisionId,
          versionNo,
          versionDescription: desc,
          resultDate: '',
          actionType: action,
          mvPlanYyyymm: '',
          updateYn: 'N',
        });
      } else {
        // BP 계열 분기 (AS-IS L300~304 — SAVE_BIZ_PLAN_VERSION_COPY 5 IN)
        res = await callVersionActionBp({
          divisionId,
          versionNo,
          versionDescription: desc,
          actionType: action,
        });
      }
      if (!res.ok) {
        void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.') });
        return;
      }
      void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
      void refetch?.();
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={980}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Version</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                <Grid size={5}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.modalFieldRow}>
                        <InputField value={sdt} onChange={e => setSdt(e.target.value)} placeholder='YYYYMMDD' />
                        <span>~</span>
                        <InputField value={edt} onChange={e => setEdt(e.target.value)} placeholder='YYYYMMDD' />
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00799', '_Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField value={description} onChange={e => setDescription(e.target.value)} />
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<UnitedVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={() => adopt(selectedRow)}
            />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Transfer'
              disabled={running} onClick={() => void runAction(VERSION_ACTION.TRANSFER)} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Cancel Transfer'
              disabled={running} onClick={() => void runAction(VERSION_ACTION.CANCEL)} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Version Copy'
              disabled={running} onClick={() => void runAction(VERSION_ACTION.COPY)} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Version Delete'
              disabled={running} onClick={() => void runAction(VERSION_ACTION.DELETE)} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
          </div>
        </div>
      }
    />
  );
};
