import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MAIN_COLUMNS } from '../../sales-future-price.constants';

import styles from './ColumnTitleSetModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  onSave: (settings: ColumnSetting[]) => void;
}

interface ColumnSetting {
  COLUMN_NAME: string;
  COLUMN_LABEL: string;
  VISIBLE: boolean;
  WIDTH: number;
  FROZEN: boolean;
  SORT_ORDER: number;
  ALIGNMENT: string;
  FORMAT: string;
}

// AS-IS DM0002_TitleSetForm_Popup.cs (665줄) — 사용자별 메인 Grid 컬럼 표시·순서·폭·고정 개인화
//   - SP: DMF0002_GET_TITLESET_POPUP / SCM0002_GET_TITLESET_POPUP
//   - Validation: MSG00002 (Visible=Y 컬럼 0개) / MSG00043 (COLUMN_NAME 중복)
//   - Action: 저장 / 초기화 / 닫기 / ↑↓ 순서 변경
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_GridColumnSetting/
export const ColumnTitleSetModal = ({ open, modalClose, onSave }: Props) => {
  const setAlert = useMessageStore.getState().setAlert;

  // 기본값: MAIN_COLUMNS 메타 (현재는 클라이언트 측 — SP 미연동 단계)
  const [settings, setSettings] = useState<ColumnSetting[]>(() =>
    MAIN_COLUMNS.map((c, i) => ({
      COLUMN_NAME: c.key,
      COLUMN_LABEL: c.header,
      VISIBLE: c.visible !== false,
      WIDTH: c.width ?? 100,
      FROZEN: c.freeze ?? false,
      SORT_ORDER: i + 1,
      ALIGNMENT: c.align === 'C' ? 'Center' : c.align === 'R' ? 'Right' : 'Left',
      FORMAT: c.format ?? '',
    })),
  );
  const [selectedIdx, setSelectedIdx] = useState(0);

  const handleUp = () => {
    if (selectedIdx <= 0) return;
    setSettings(prev => {
      const next = [...prev];
      [next[selectedIdx - 1], next[selectedIdx]] = [next[selectedIdx], next[selectedIdx - 1]];
      return next.map((r, i) => ({ ...r, SORT_ORDER: i + 1 }));
    });
    setSelectedIdx(i => i - 1);
  };

  const handleDown = () => {
    if (selectedIdx >= settings.length - 1) return;
    setSettings(prev => {
      const next = [...prev];
      [next[selectedIdx], next[selectedIdx + 1]] = [next[selectedIdx + 1], next[selectedIdx]];
      return next.map((r, i) => ({ ...r, SORT_ORDER: i + 1 }));
    });
    setSelectedIdx(i => i + 1);
  };

  const handleSave = () => {
    // Validation 1 — Visible=Y 컬럼 ≥ 1 (MSG00002)
    if (settings.every(s => !s.VISIBLE)) {
      void setAlert({ type: 'alert', content: '[MSG00002] 최소 1개 컬럼은 표시 상태여야 합니다.' });
      return;
    }
    // Validation 2 — COLUMN_NAME 중복 (MSG00043)
    const seen = new Set<string>();
    for (const s of settings) {
      if (seen.has(s.COLUMN_NAME)) {
        void setAlert({ type: 'alert', content: `[MSG00043] 컬럼명 ${s.COLUMN_NAME} 가 중복됩니다.` });
        return;
      }
      seen.add(s.COLUMN_NAME);
    }
    onSave(settings);
    modalClose();
  };

  const handleReset = () => {
    setSettings(MAIN_COLUMNS.map((c, i) => ({
      COLUMN_NAME: c.key,
      COLUMN_LABEL: c.header,
      VISIBLE: c.visible !== false,
      WIDTH: c.width ?? 100,
      FROZEN: c.freeze ?? false,
      SORT_ORDER: i + 1,
      ALIGNMENT: c.align === 'C' ? 'Center' : c.align === 'R' ? 'Right' : 'Left',
      FORMAT: c.format ?? '',
    })));
  };

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      title='Grid Column Setting'
      width={530}
      height={580}
    >
      <div className={styles.container}>
        <div className={styles.buttonRow}>
          <button type='button' onClick={handleUp} className={styles.moveBtn}>↑</button>
          <button type='button' onClick={handleDown} className={styles.moveBtn}>↓</button>
          <button type='button' onClick={handleSave} className={styles.saveBtn}>저장</button>
          <button type='button' onClick={handleReset} className={styles.resetBtn}>초기화</button>
          <button type='button' onClick={modalClose} className={styles.closeBtn}>닫기</button>
        </div>

        <div className={styles.gridWrap}>
          <FlexGrid
            itemsSource={settings}
            autoGenerateColumns={false}
            selectionMode={1 /* Row */}
            style={{ height: '100%' }}
            selectionChanged={(s, e) => { setSelectedIdx(e.row); }}
            cellEditEnded={(s, e) => {
              const item = s.rows[e.row]?.dataItem as ColumnSetting | undefined;
              if (!item) return;
              setSettings(prev => prev.map((p, i) => i === e.row ? { ...p, ...item } : p));
            }}
          >
            <FlexGridColumn binding='COLUMN_NAME' header='컬럼명' width={130} isReadOnly />
            <FlexGridColumn binding='COLUMN_LABEL' header='표시 라벨' width={120} />
            <FlexGridColumn binding='VISIBLE' header='표시' width={50} dataType={3 /* Boolean */} />
            <FlexGridColumn binding='WIDTH' header='폭' width={60} dataType={2 /* Number */} />
            <FlexGridColumn binding='FROZEN' header='고정' width={50} dataType={3 /* Boolean */} />
            <FlexGridColumn binding='SORT_ORDER' header='순서' width={60} isReadOnly />
            <FlexGridColumn binding='ALIGNMENT' header='정렬' width={80} />
            <FlexGridColumn binding='FORMAT' header='포맷' width={80} />
          </FlexGrid>
        </div>
      </div>
    </CustomDialog>
  );
};
