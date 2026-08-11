import { useEffect, useMemo, useState } from 'react';

import { type DualListColumn, ColumnSelectDualList, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import type { MeasureMeta } from '../../useForecastPriceStore';

import styles from './MeasureSelectModal.module.scss';

// Measure 선택 모달 (AS-IS DMF0082 btnMeasure_Click → DM0002_TitleSetForm_Popup measure 모드).
//   sales-monitoring MeasureSelectModal 표준 1:1 — dual list(ColumnSelectDualList) 좌측=비표시/우측=표시,
//   체크 다중선택 + ▶/◀ 이동 + 우측 D&D 순서 + Default/Cancel/OK.
//   데이터 = SCM_MST_SHEET_MEASURE(PROGRAM_ID='DMF0082' SHEET_NAME='FcstNPrice') 동적 fetch
//   (useForecastPriceStore.staticMeasures — display/personalizable = BE boolean 메타. 우측 Visible = display true).

interface MeasureDualRow {
  colNm: string;
  colLblNm: string;
  sClsLblNm: string;
  userFlag: string;
  personalizable: string;
  display: string;
  sortOrderNo: number;
  [key: string]: string | number;
}

interface MeasureSelectModalProps {
  open: boolean;
  modalClose: () => void;
  measures: MeasureMeta[];
  visibleMeasures: string[] | null;
  onApply: (measureCodes: string[] | null) => void;
}

export const MeasureSelectModal = ({
  open,
  modalClose,
  measures,
  visibleMeasures,
  onApply,
}: MeasureSelectModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // ⭐ BE GridMeasure DTO 는 display/personalizable 를 boolean 으로 내려준다 → boolean 기준으로 'Y'/'N' 정규화.
  //    (구: === 'Y' 문자열 비교 → boolean true 와 불일치 → 전 measure 'N' → 우측 Visible 그리드 0개 사고)
  const sourceRows = useMemo(
    () =>
      measures.map(m => ({
        colNm: m.colNm,
        colLblNm: m.colLblNm || m.colNm,
        sClsLblNm: m.sClsLblNm ?? '',
        personalizable: m.personalizable === false ? 'N' : 'Y',
        display: m.display ? 'Y' : 'N',
      })),
    [measures]
  );

  const buildRows = (useVisibleOverride: boolean): MeasureDualRow[] => {
    let seq = 0;
    return sourceRows.map(r => {
      const byDefault = r.display === 'Y';
      const flag =
        r.personalizable !== 'Y' || !useVisibleOverride || visibleMeasures === null
          ? byDefault
          : visibleMeasures.includes(r.colNm);
      seq += flag ? 1 : 0;
      return { ...r, userFlag: flag ? 'Y' : 'N', sortOrderNo: flag ? seq : 0 };
    });
  };

  const [rows, setRows] = useState<MeasureDualRow[]>([]);
  const [checkedLeft, setCheckedLeft] = useState<Set<string>>(new Set());
  const [checkedRight, setCheckedRight] = useState<Set<string>>(new Set());

  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  useEffect(() => {
    if (open && rows.length === 0 && sourceRows.length > 0) {
      setRows(buildRows(true));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, sourceRows, visibleMeasures, rows.length]);

  const baseRows = useMemo(() => rows.filter(r => r.userFlag === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.userFlag === 'Y').sort((a, b) => a.sortOrderNo - b.sortOrderNo),
    [rows]
  );

  const isSelectable = (key: string) => rows.find(r => r.colNm === key)?.personalizable === 'Y';

  const toggleLeft = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedLeft(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleRight = (key: string) => {
    if (!isSelectable(key)) return;
    setCheckedRight(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };
  const toggleAllLeft = (checked: boolean) =>
    setCheckedLeft(
      checked
        ? new Set(baseRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
        : new Set()
    );
  const toggleAllRight = (checked: boolean) =>
    setCheckedRight(
      checked
        ? new Set(userRows.filter(r => r.personalizable === 'Y').map(r => r.colNm))
        : new Set()
    );

  // ⭐ Class 컬럼 제거 (2026-08-11 — 통합테스트 1st No.40 사용자 요구 "Measure Code, Measure Name만")
  const MEASURE_COLUMNS: DualListColumn<MeasureDualRow>[] = [
    { key: 'colNm', header: 'Measure Code', width: 120, align: 'left' },
    { key: 'colLblNm', header: 'Measure Name', align: 'left' },
  ];

  const moveToUser = () => {
    if (checkedLeft.size === 0) {
      void setAlert({ type: 'alert', content: '좌측 measure 선택' });
      return;
    }
    setRows(prev => {
      let maxSeq = Math.max(0, ...prev.filter(r => r.userFlag === 'Y').map(r => r.sortOrderNo));
      return prev.map(r => {
        if (r.userFlag === 'N' && checkedLeft.has(r.colNm)) {
          maxSeq += 1;
          return { ...r, userFlag: 'Y', sortOrderNo: maxSeq };
        }
        return r;
      });
    });
    setCheckedLeft(new Set());
  };

  const moveToBase = () => {
    if (checkedRight.size === 0) {
      void setAlert({ type: 'alert', content: '우측 measure 선택' });
      return;
    }
    setRows(prev =>
      prev.map(r =>
        r.userFlag === 'Y' && checkedRight.has(r.colNm)
          ? { ...r, userFlag: 'N', sortOrderNo: 0 }
          : r
      )
    );
    setCheckedRight(new Set());
  };

  const reorderRight = (orderedKeys: string[]) =>
    setRows(prev =>
      prev.map(r => {
        if (r.userFlag !== 'Y') return r;
        const idx = orderedKeys.indexOf(r.colNm);
        return idx === -1 ? r : { ...r, sortOrderNo: idx + 1 };
      })
    );

  const handleDefault = () => {
    setRows(buildRows(false));
    setCheckedLeft(new Set());
    setCheckedRight(new Set());
  };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    const selected = userRows.map(r => r.colNm);
    onApply(selected.length === rows.length ? null : selected);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={840}
      handleClose={modalClose}
      disableButtonCancel
      title={t('LBL00712', '_Measure')}
      customContentArea={
        <div className={styles.measureDualContainer}>
          <ColumnSelectDualList<MeasureDualRow>
            leftItems={baseRows}
            rightItems={userRows}
            leftColumns={MEASURE_COLUMNS}
            rightColumns={MEASURE_COLUMNS}
            itemKey='colNm'
            checkedLeft={checkedLeft}
            checkedRight={checkedRight}
            onToggleLeft={toggleLeft}
            onToggleRight={toggleRight}
            onToggleAllLeft={toggleAllLeft}
            onToggleAllRight={toggleAllRight}
            onMoveRight={moveToUser}
            onMoveLeft={moveToBase}
            onReorderRight={reorderRight}
          />

          <div className={styles.measureActionBar}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Default'
              onClick={handleDefault}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
