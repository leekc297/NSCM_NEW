import { useEffect, useMemo, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, InputField } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../sales-reports.constants';
import type { TextboxRow } from '../../sales-reports.types';
import styles from '../../SalesReports.module.scss';
import { callSaveTextboxRow } from '../../utils/sales-reports.api';
import { toCellStr } from '../../utils/sales-reports.gridCombos';

interface Props {
  open: boolean;
  modalClose: () => void;
  versionNo: string;
}

// ⭐ Textbox 팝업 (Division 82 전용) — AS-IS DMF0044_SalesReport_TextboxPopup(453행):
//   조회 = GET_TEXTBOX (⭐ OUT 4커서 — data=행별 13개월 코멘트 / rc2 'MONDAY'=13개월 컬럼 시작월).
//   저장 = SAVE_TEXTBOX 16키(P_VERSION_NO/P_YYYYMM/P_DESCRIPTION1~13 — 1행분).
//   ⭐ 정책③(2026-07-22 교정): AS-IS 는 행 반복 변수 덮어쓰기로 "마지막 행만 저장"되는 구조적 결함 —
//   TO-BE 는 수정 행별 SP 반복 호출 (SP 무수정, 전 수정 행 저장).
export const TextboxModal = ({ open, modalClose, versionNo }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const [edited, setEdited] = useState<Record<number, Record<string, string>>>({});
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (open) setEdited({});
  }, [open]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({ versionNo, userId: sesUserId, mnuId: MENU_ID }),
    [versionNo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.TEXTBOX>({
    menuId: MENU_ID,
    sheetName: SHEETS.TEXTBOX,
    tabId: MENU_ID,
    filters,
    enabled: open && versionNo !== '',
  });
  const rows = useMemo<TextboxRow[]>(
    () => ((data as { data?: TextboxRow[] } | undefined)?.data ?? []),
    [data]
  );

  const descKeys = useMemo(
    () => Array.from({ length: 13 }, (_, i) => `DESCRIPTION${i + 1}`),
    []
  );

  const valueOf = (rowIdx: number, key: string): string =>
    edited[rowIdx]?.[key] ?? toCellStr((rows[rowIdx] as Record<string, unknown>)?.[key]);

  const setValue = (rowIdx: number, key: string, v: string) =>
    setEdited(prev => ({ ...prev, [rowIdx]: { ...prev[rowIdx], [key]: v } }));

  // ⭐ 저장 — 수정 행별 반복 호출 (정책③ 교정)
  const handleSave = async () => {
    if (saving) return;
    const targets = Object.keys(edited).map(Number);
    if (targets.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    setSaving(true);
    try {
      for (const rowIdx of targets) {
        const row = rows[rowIdx] as Record<string, unknown> | undefined;
        if (!row) continue;
        const payload: Record<string, string> = {
          versionNo,
          yyyymm: toCellStr(row.YYYYMM),
        };
        descKeys.forEach((k, i) => {
          payload[`description${i + 1}`] = valueOf(rowIdx, k);
        });
        const res = await callSaveTextboxRow(payload);
        if (!res.ok) {
          void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.') });
          return;
        }
      }
      void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
      setEdited({});
      void refetch?.();
    } finally {
      setSaving(false);
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
          <h2 className='headerTitle'>Text</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.textboxTableWrapper}>
            <table className={styles.textboxTable}>
              <thead>
                <tr>
                  <th>YYYYMM</th>
                  {descKeys.map(k => (
                    <th key={k}>{k.replace('DESCRIPTION', 'D')}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {rows.map((row, rowIdx) => (
                  <tr key={toCellStr((row as Record<string, unknown>).YYYYMM) || rowIdx}>
                    <td>{toCellStr((row as Record<string, unknown>).YYYYMM)}</td>
                    {descKeys.map(k => (
                      <td key={k}>
                        <InputField
                          value={valueOf(rowIdx, k)}
                          onChange={e => setValue(rowIdx, k, e.target.value)}
                        />
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button appearance='contained' priority='primary' size='medium' buttonLabel='Save'
              disabled={saving} onClick={() => void handleSave()} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
          </div>
        </div>
      }
    />
  );
};
