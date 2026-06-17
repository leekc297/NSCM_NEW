import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';

import type { MeasureMeta } from '../../mkt-forecast-master.types';

import styles from './MeasureSelectModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  /** 현재 선택된 Measure 목록 (부모 store) */
  defaultSelected: string[];
  /** 적용 시 선택된 Measure 목록 callback */
  onApply: (selected: string[]) => void;
  divisionId: string;
  // ⭐ master hook §5 / child hook ui-category-setup-column-meta §8 —
  //   admin SYS0004 UI Category Setup Measure 탭 `SCM_MST_SHEET_MEASURE` 동적 fetch 결과.
  //   DB 1차 source 표준 (사용자 결정 2026-06-15 — FE ALL_MEASURES 하드코딩 완전 제거).
  staticMeasures?: MeasureMeta[];
}

interface MeasureRow {
  MEASURE_CODE: string;
  MEASURE_NAME: string;
  EDITABLE_YN: 'Y' | 'N';  // AS-IS L1954 + L2909: MKT_FCST 만 사용자 입력 가능 (MKT_FCST_RP 는 자동/SSP sync)
  SORT_ORDER_NO: number;
}

// AS-IS DMF0003_1_MktFcst.cs L4916 btnMeasure_Click — Measure 선택 popup
// SCM_MST_SHEET_MEASURE 의 PROGRAM_ID='DMF0003' SHEET_NAME='main' Measure 목록을
// USER_INQUIRY_COLUMN_TYPE_CODE='M' 로 SCM_MST_TITLESET_USER 에 등록
//
// ⭐ master hook §5 — Measure 동적 fetch 표준 (사용자 결정 2026-06-15)
//   1차 source = SCM_MST_SHEET_MEASURE (admin SYS0004 UI Category Setup)
//   FE 하드코딩 (ALL_MEASURES) 완전 제거 — admin 변경이 화면에 즉시 반영
//
// 사용자 명시 요구 (2026-06-07): "양쪽 2개 Grid 위치 이동 방식 (Grid Column 과 같이)"
// → 공용 ColumnSettingModal dual-grid 패턴 + 선택된 Measure 만 grid filter

export const MeasureSelectModal = ({ open, onClose, defaultSelected, onApply, divisionId: _divisionId, staticMeasures = [] }: Props) => {
  // admin SYS0004 동적 fetch 결과를 MeasureRow 로 변환
  //   ⭐ BE GridMeasure DTO 는 colNm/colLblNm camelCase 반환. UPPER_SNAKE 접근 시 undefined.
  //   AS-IS 'MKT_FCST' 만 editable (L1954+L2909). 그 외 모두 Read-only.
  const allMeasures = useMemo<MeasureRow[]>(() => {
    return staticMeasures.map<MeasureRow>(m => ({
      MEASURE_CODE: m.colNm,
      MEASURE_NAME: m.colLblNm ?? m.colNm,
      EDITABLE_YN:  m.colNm === 'MKT_FCST' ? 'Y' : 'N',
      SORT_ORDER_NO: 0,
    }));
  }, [staticMeasures]);
  const baseGridRef = useRef<FlexGridType<MeasureRow> | null>(null);
  const userGridRef = useRef<FlexGridType<MeasureRow> | null>(null);

  const [hiddenRows, setHiddenRows] = useState<MeasureRow[]>([]);
  const [selectedRows, setSelectedRows] = useState<MeasureRow[]>([]);
  const [baseSel, setBaseSel] = useState<MeasureRow | null>(null);
  const [userSel, setUserSel] = useState<MeasureRow | null>(null);

  useEffect(() => {
    if (!open) return;
    // 사용자 명시 요구 (2026-06-07): popup 적용한 Measure 를 다음 재진입 시 기억
    //   - useEffect deps 는 [open, allMeasures] — allMeasures 가 staticMeasures fetch 후 채워질 때 재로딩
    //   - open=true 전환 시 store 의 selectedMeasures (defaultSelected) 기준 reload
    //   - 적용 (handleApply) → onApply(setSelectedMeasures) → store 갱신 → sessionStorage persist → 재오픈 시 복원
    const selected = defaultSelected
      .map((code, i) => {
        const m = allMeasures.find(x => x.MEASURE_CODE === code);
        return m ? { ...m, SORT_ORDER_NO: i + 1 } : null;
      })
      .filter((x): x is MeasureRow => x !== null);
    const hidden = allMeasures
      .filter(m => !defaultSelected.includes(m.MEASURE_CODE))
      .map(m => ({ ...m, SORT_ORDER_NO: 0 }));
    setSelectedRows(selected);
    setHiddenRows(hidden);
    setBaseSel(null);
    setUserSel(null);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, allMeasures]);

  const sortedSelected = useMemo(
    () => [...selectedRows].sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO),
    [selectedRows],
  );

  // Wijmo selectedItems fallback — selectionChanged 의 closure stale state 회피
  const getBaseSel = (): MeasureRow | null => {
    if (baseSel) return baseSel;
    const g = baseGridRef.current;
    return (g?.selectedItems[0] as MeasureRow | undefined) ?? null;
  };
  const getUserSel = (): MeasureRow | null => {
    if (userSel) return userSel;
    const g = userGridRef.current;
    return (g?.selectedItems[0] as MeasureRow | undefined) ?? null;
  };

  const moveToUser = () => {
    const sel = getBaseSel();
    if (!sel) return;
    setHiddenRows(prev => prev.filter(r => r.MEASURE_CODE !== sel.MEASURE_CODE));
    setSelectedRows(prev => {
      const maxSeq = Math.max(0, ...prev.map(r => r.SORT_ORDER_NO));
      return [...prev, { ...sel, SORT_ORDER_NO: maxSeq + 1 }];
    });
    setBaseSel(null);
  };

  const moveToBase = () => {
    const sel = getUserSel();
    if (!sel) return;
    setSelectedRows(prev => prev.filter(r => r.MEASURE_CODE !== sel.MEASURE_CODE));
    setHiddenRows(prev => [...prev, { ...sel, SORT_ORDER_NO: 0 }]);
    setUserSel(null);
  };

  const handleApply = () => {
    // 선택된 Measure 만 부모 store 에 전달 (sort 순서 보존)
    onApply(sortedSelected.map(r => r.MEASURE_CODE));
    onClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={800}
      handleClose={onClose}
      disableButtonCancel
      customHeaderTitle={
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 12, height: 12, background: '#1976d2', borderRadius: '50%' }} />
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>Measure 선택</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container} style={{ height: 480 }}>
          <div className={styles.dualGrid}>
            {/* 좌측 Base grid (Hidden / 미선택) */}
            <div className={styles.sideGrid}>
              <div className={styles.sideTitle}>Hidden Measures</div>
              <div className={styles.sideGridBody}>
                <FlexGrid
                  initialized={(g: FlexGridType<MeasureRow>) => { baseGridRef.current = g; }}
                  itemsSource={hiddenRows}
                  autoGenerateColumns={false}
                  selectionMode={3}
                  headersVisibility='Column'
                  selectionChanged={(s) => { setBaseSel((s.selectedItems[0] as MeasureRow | undefined) ?? null); }}
                  style={{ height: '100%' }}
                >
                  <FlexGridColumn binding='MEASURE_CODE' header='Code'     width={140} align='left'   isReadOnly />
                  <FlexGridColumn binding='MEASURE_NAME' header='Name'     width='*'   align='left'   isReadOnly />
                  <FlexGridColumn binding='EDITABLE_YN' header='Editable' width={70}  align='center' isReadOnly />
                </FlexGrid>
              </div>
            </div>

            {/* 중앙 이동 버튼 */}
            <div className={styles.centerBtns}>
              <button type='button' onClick={moveToUser} className={styles.arrowBtn} title='우측 추가'>▶</button>
              <button type='button' onClick={moveToBase} className={styles.arrowBtn} title='좌측 제거'>◀</button>
            </div>

            {/* 우측 User grid (Selected / 표시) */}
            <div className={styles.sideGrid}>
              <div className={styles.sideTitle}>Selected Measures (AS-IS: MKT_FCST 만 입력 가능)</div>
              <div className={styles.sideGridBody}>
                <FlexGrid
                  initialized={(g: FlexGridType<MeasureRow>) => { userGridRef.current = g; }}
                  itemsSource={sortedSelected}
                  autoGenerateColumns={false}
                  selectionMode={3}
                  headersVisibility='Column'
                  selectionChanged={(s) => { setUserSel((s.selectedItems[0] as MeasureRow | undefined) ?? null); }}
                  style={{ height: '100%' }}
                >
                  <FlexGridColumn binding='SORT_ORDER_NO' header='No'       width={60}  align='center' isReadOnly />
                  <FlexGridColumn binding='MEASURE_CODE'  header='Code'     width={140} align='left'   isReadOnly />
                  <FlexGridColumn binding='MEASURE_NAME'  header='Name'     width='*'   align='left'   isReadOnly />
                  <FlexGridColumn binding='EDITABLE_YN'   header='Editable' width={70}  align='center' isReadOnly />
                </FlexGrid>
              </div>
            </div>
          </div>

          <div className={styles.bottomRow}>
            <span className={styles.hint}>{hiddenRows.length} hidden / {sortedSelected.length} selected</span>
            <Button variant='contained' onClick={handleApply}>적용</Button>
            <Button variant='outlined' onClick={onClose}>취소</Button>
          </div>
        </div>
      }
    />
  );
};
