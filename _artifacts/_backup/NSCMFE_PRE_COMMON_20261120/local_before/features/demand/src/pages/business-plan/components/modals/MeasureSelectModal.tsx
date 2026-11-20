import { useEffect, useMemo, useState } from 'react';

import { type DualListColumn, ColumnSelectDualList, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import styles from '../../BusinessPlan.module.scss';
import type { MeasureMeta } from '../../useBusinessPlanStore';

// ⭐ Measure 선택 모달 (AS-IS btnMeasure_Click → DM0002_TitleSetForm_Popup 'Measure' 모드, L2819~2830).
//   DMF0021 MeasureSelectModal 1:1 형태 — 좌측 = 비표시(Base) / 우측 = 표시(User) dual list.
//   데이터: staticMeasures = SCM_MST_SHEET_MEASURE('Biz Plan', 9건) 동적 fetch. 0건 = 빈 목록
//   (하드코딩 fallback 금지). OK → titleSet 'M' 영구 저장 → 메인 SP measure 필터 반영.

// dual list 행 — ColumnSelectDualList 제약(Record<string, string | number>) 상 boolean 금지 → 'Y'/'N'.
interface MeasureDualRow {
  /** measure 코드 (COLUMN_NAME) — 행 고유키 */
  colNm: string;
  /** measure 표시명 (COLUMN_LABEL_NAME) */
  colLblNm: string;
  /** 소분류 라벨 (SMALL_CLASS_LABEL_NAME) */
  sClsLblNm: string;
  /** 'Y'=표시(우측) / 'N'=비표시(좌측) */
  userFlag: string;
  /** USER_SELECTABLE_FLAG — 'N' 이면 체크/이동 불가(기본측 고정) */
  personalizable: string;
  /** DEFAULT_FLAG — Default reset 시 표시 기본값 */
  display: string;
  /** 우측 표시 순서 */
  sortOrderNo: number;
  [key: string]: string | number;
}

interface MeasureSelectModalProps {
  open: boolean;
  modalClose: () => void;
  /** 동적 fetch measure (SCM_MST_SHEET_MEASURE) — admin 적재가 정본 (fallback 없음). */
  measures: MeasureMeta[];
  /** 현재 표시 중인 measure 코드 목록(null = 전체). 모달 재진입 시 좌/우 상태 복원. */
  visibleMeasures: string[] | null;
  /** OK — 표시할 measure 코드 목록(전체 선택 시 null) 적용. */
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

  const sourceRows = useMemo(
    () =>
      measures.length > 0
        ? measures.map(m => ({
            colNm: m.colNm,
            colLblNm: m.colLblNm || m.colNm,
            sClsLblNm: m.sClsLblNm ?? '',
            personalizable: (m.personalizable ?? true) ? 'Y' : 'N',
            display: (m.display ?? false) ? 'Y' : 'N',
          }))
        : [], // 하드코딩 fallback 금지 — 메타 0건 = 빈 목록 (admin 적재가 정본)
    [measures]
  );

  // visibleMeasures 미설정(null) 시 display(DEFAULT_FLAG) 기본, 설정 시 그 목록으로 표시측 복원.
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

  // popup 닫힐 때 rows/체크 reset — 재진입 시 visibleMeasures 로 재구성.
  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  // popup open 시점 1회만 setRows (사용자 이동 결과 보존 — 무조건 setRows 시 원복 사고).
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

  const MEASURE_COLUMNS: DualListColumn<MeasureDualRow>[] = [
    { key: 'sClsLblNm', header: 'Class', width: 70, align: 'left' },
    { key: 'colNm', header: 'Measure Code', width: 120, align: 'left' },
    { key: 'colLblNm', header: 'Measure Name', align: 'left' },
  ];

  const moveToUser = () => {
    if (checkedLeft.size === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
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
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
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
      size={1260}
      handleClose={modalClose}
      disableButtonCancel
      title={t('LBL00310', '_Measure')}
      customContentArea={
        <div className={styles.measureDualContainer}>
          <ColumnSelectDualList<MeasureDualRow>
            leftItems={baseRows}
            rightItems={userRows}
            leftColumns={MEASURE_COLUMNS}
            rightColumns={MEASURE_COLUMNS}
            leftTitle={t('LBL00764', 'Invisible')}
            rightTitle={t('LBL00765', 'Visible')}
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
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
