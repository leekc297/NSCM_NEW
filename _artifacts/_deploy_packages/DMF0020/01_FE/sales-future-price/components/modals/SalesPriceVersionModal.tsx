import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './SalesPriceVersionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  onApply: (versionIds: string) => void;
}

interface VersionRow {
  VERSION_ID: string;
  VERSION_NAME: string;
  VERSION_TYPE: string;
  CREATE_DT: string;
  CREATE_BY: string;
  DIVISION_ID: string;
  REMARK: string;
  CHK?: boolean;
}

// AS-IS DMF0073_VersionBySalesPricePopup.cs (459줄) — Sales Price Version 선택 (최대 2개)
//   - Filter: Division / Period From / Period To / type='SP' (hidden) / Day/Week/Manual chk / Description
//   - Validation: MSG00255 (선택 > 2개) + Silent Guard (Day/Week/Manual 모두 미선택)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_Version/
export const SalesPriceVersionModal = ({ open, modalClose, defaultDivision, onApply }: Props) => {
  const setAlert = useMessageStore.getState().setAlert;

  const [divisionId, setDivisionId] = useState(defaultDivision);
  const [periodFrom, setPeriodFrom] = useState('');
  const [periodTo, setPeriodTo] = useState('');
  const [chkDay, setChkDay] = useState(false);
  const [chkWeek, setChkWeek] = useState(true);   // 기본 Checked (Sales Price)
  const [chkManual, setChkManual] = useState(false);
  const [description, setDescription] = useState('');
  const [selected, setSelected] = useState<string[]>([]);

  useEffect(() => { if (open) setDivisionId(defaultDivision); }, [open, defaultDivision]);

  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    filters: {
      divisionId,
      periodFrom,
      periodTo,
      type: 'SP',
      flagDay: chkDay ? 'Y' : 'N',
      flagWeek: chkWeek ? 'Y' : 'N',
      flagManual: chkManual ? 'Y' : 'N',
      description,
    } as never,
    enabled: false,   // Find 버튼으로 명시 trigger
  });

  const rows = (data?.o_rc1 ?? []) as VersionRow[];

  const handleFind = () => {
    if (!chkDay && !chkWeek && !chkManual) {
      // Silent Guard — 빈 결과 반환
      return;
    }
    refetch?.();
  };

  const handleApply = () => {
    if (selected.length > 2) {
      void setAlert({ type: 'alert', content: '[MSG00255] Version 은 최대 2개까지 선택할 수 있습니다 (읽기전용).' });
      return;
    }
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: 'Version 을 선택해주세요.' });
      return;
    }
    onApply(selected.join(','));
    modalClose();
  };

  const toggleSelection = (verId: string) => {
    setSelected(prev => prev.includes(verId) ? prev.filter(v => v !== verId) : [...prev, verId]);
  };

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      title='VersionBySalesPrice Popup'
      width={870}
      height={520}
    >
      <div className={styles.container}>
        <div className={styles.filterRow}>
          <label>
            Division
            <select value={divisionId} onChange={e => setDivisionId(e.target.value)}>
              <option value='40'>40</option>
              <option value='81'>81</option>
              <option value='82'>82</option>
            </select>
          </label>
          <label>
            Period From <input type='text' value={periodFrom} onChange={e => setPeriodFrom(e.target.value)} placeholder='YYYYMM' />
          </label>
          <label>
            Period To <input type='text' value={periodTo} onChange={e => setPeriodTo(e.target.value)} placeholder='YYYYMM' />
          </label>
          <label><input type='checkbox' checked={chkDay} onChange={e => setChkDay(e.target.checked)} /> Day</label>
          <label><input type='checkbox' checked={chkWeek} onChange={e => setChkWeek(e.target.checked)} /> Week</label>
          <label><input type='checkbox' checked={chkManual} onChange={e => setChkManual(e.target.checked)} /> Manual</label>
          <label>
            Description <input type='text' value={description} onChange={e => setDescription(e.target.value)} />
          </label>
        </div>

        <div className={styles.buttonRow}>
          <button type='button' onClick={handleFind} className={styles.findBtn}>Find</button>
          <button type='button' onClick={handleApply} className={styles.applyBtn}>Apply</button>
          <button type='button' onClick={modalClose} className={styles.closeBtn}>Close</button>
          <span className={styles.hint}>Sales Price Version 최대 2개 선택 가능</span>
        </div>

        <div className={styles.gridWrap}>
          <FlexGrid
            itemsSource={rows.map(r => ({ ...r, CHK: selected.includes(r.VERSION_ID) }))}
            autoGenerateColumns={false}
            style={{ height: '100%' }}
            cellEditEnded={(s, e) => {
              const item = s.rows[e.row]?.dataItem as VersionRow | undefined;
              if (item) toggleSelection(item.VERSION_ID);
            }}
          >
            <FlexGridColumn binding='CHK' header='✓' width={40} dataType={3 /* Boolean */} />
            <FlexGridColumn binding='VERSION_ID' header='Version ID' width={110} isReadOnly />
            <FlexGridColumn binding='VERSION_NAME' header='Version Name' width={200} isReadOnly />
            <FlexGridColumn binding='VERSION_TYPE' header='Type' width={80} isReadOnly />
            <FlexGridColumn binding='CREATE_DT' header='생성일' width={140} isReadOnly />
            <FlexGridColumn binding='CREATE_BY' header='작성자' width={100} isReadOnly />
            <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} isReadOnly />
            <FlexGridColumn binding='REMARK' header='Remark' width={180} isReadOnly />
          </FlexGrid>
        </div>
      </div>
    </CustomDialog>
  );
};
