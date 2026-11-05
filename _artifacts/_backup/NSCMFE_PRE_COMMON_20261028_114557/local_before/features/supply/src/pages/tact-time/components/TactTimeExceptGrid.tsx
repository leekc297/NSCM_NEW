import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { TACT_MODE } from '../tact-time.constants';
import { EXCEPT_COLUMNS, MAX_TACT_TIME_FALLBACK, MSG } from '../tact-time.constants';
import type { ExceptRow } from '../tact-time.types';
import { buildColumns } from '../utils/tactTimeColumns';
import { clampTactTime, deriveTactTimeFromDaily } from '../utils/tactTimeDerive';
import { isExceptCellEditable } from '../utils/tactTimeEditLock';

interface Props {
  rows: ExceptRow[];
  parentMode: TACT_MODE;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  editMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

export const TactTimeExceptGrid = ({
  rows,
  parentMode,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  editMode,
  adminColumns,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  // 모드별 계산 컬럼(Packer=TACT_TIME, Plant=DAILY_CAPACITY)은 메타가 O 여도 조회전용으로 표시한다.
  const columns = useMemo(
    () =>
      buildColumns(EXCEPT_COLUMNS, adminColumns).map(c =>
        (c.colNm === 'TACT_TIME' || c.colNm === 'DAILY_CAPACITY') &&
        !isExceptCellEditable(c.colNm, parentMode)
          ? { ...c, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY }
          : c
      ),
    [adminColumns, parentMode]
  );

  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;
  const parentModeRef = useRef(parentMode);
  parentModeRef.current = parentMode;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editModeRef.current) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isExceptCellEditable(binding, parentModeRef.current)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // DAILY_CAPACITY 변경 -> TACT_TIME 파생 (Packer 부모, cs:2680) + TACT_TIME clamp (cs:2879 MSG00203).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: number) => {
        tracker?.storeChange(row as never, key, row[key] as never, value as never);
        row[key] = value;
      };
      if (binding === 'DAILY_CAPACITY') {
        setCell('TACT_TIME', deriveTactTimeFromDaily(row.DAILY_CAPACITY));
      }
      if (binding === 'TACT_TIME') {
        const { value, clamped } = clampTactTime(row.TACT_TIME, MAX_TACT_TIME_FALLBACK);
        if (clamped) {
          setCell('TACT_TIME', value);
          setToast({ type: 'error', message: t(MSG.TACT_MAX_CLAMP, '_Tact Time out of range.') });
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 하단 Except 그리드 셀 병합 — AS-IS siExcept.SmartColMerge() 이식(cs:242 등).
    //   상단 그리드와 동일 규약: 공용 CustomMergeManager 가 좌측 누적 키로 선행 식별컬럼만
    //   계층 병합하고 신규행(CRUD_TYPE='I')은 제외. AllowMerging.All 은 DataGrid prop 로 지정.
    // Start/End Date 표시 형식 = 편집기(InputDate) 'yyyy-MM-dd' 와 일치시킨다(이 화면 한정).
    //   공용 getFormat 은 FPDate 표시를 'yyyy.MM.dd'(점)로 주는데, 달력 선택 후 점 형식으로 바뀌어
    //   편집중(대시)과 어긋난다. 전역은 유지하고 여기서만 대시로 덮는다.
    for (let i = 0; i < g.columns.length; i++) {
      g.columns[i].allowMerging = true;
      const binding = g.columns[i].binding;
      if (binding === 'TACT_TIME_START_DATE' || binding === 'TACT_TIME_END_DATE') {
        g.columns[i].format = 'yyyy-MM-dd';
      }
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
    // rows 포함: 더블클릭 조회로 데이터가 들어올 때 현재 그리드에 핸들러를 다시 건다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, rows]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
