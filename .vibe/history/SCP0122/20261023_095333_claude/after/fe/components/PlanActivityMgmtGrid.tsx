import type { FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, type MutableRefObject } from 'react';

import type { ComboResponse } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  ACTIVITY_CODE_COMBO,
  ADMIN_SHEET_NAME,
  MENU_ID,
  OPMZ_ACTV_NAME,
  SHEETS,
} from '../plan-activity-mgmt.constants';
import type { PlanActivityMgmtRow } from '../plan-activity-mgmt.types';
import { usePlanActivityMgmtStore } from '../usePlanActivityMgmtStore';
import { applyActivitySync, str } from '../utils/plan-activity-mgmt.util';

interface Props {
  gridRef: MutableRefObject<TFlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PlanActivityMgmtRow> | undefined>;
  rows: PlanActivityMgmtRow[];
}

export const PlanActivityMgmtGrid = ({ gridRef, gridFilterRef, editTrackerRef, rows }: Props) => {
  const staticColumns = usePlanActivityMgmtStore(state => state.staticColumns);

  // 셀콤보(OPMZ_ACTV_NAME=ActivityCode) 전량 로드 — DataGrid 가 드롭다운 dataMap 용으로도 같은 콤보를
  //   자동 로드하지만, Auto-Sync(파생 6컬럼 복사)에는 콤보행 전 컬럼이 필요해 화면이 직접 조회한다.
  //   ActivityCode 본문에 @token 없음(flat) — 파라미터 불요.
  const [activityRows] = useTabComboQueries({ filters: [ACTIVITY_CODE_COMBO] });

  // CODE -> 콤보행(7컬럼) 조회맵. Auto-Sync 원천행 추출(filterCalls#2 CODE='<actv_cd>' 등가).
  const activityByCode = useMemo(() => {
    const map = new Map<string, ComboResponse>();
    for (const row of activityRows ?? []) map.set(str(row.CODE), row);
    return map;
  }, [activityRows]);

  // OPMZ_ACTV_NAME 셀콤보 변경 -> OPMZ_ACTV_CD + 파생 5컬럼 Auto-Sync(design 03 §3-R3).
  //   편집(EditTracker M/I) 뒤에 실행돼야 하므로 화면이 cellEditEnded 에 직접 건다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handleCellEditEnded = (sender: TFlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== OPMZ_ACTV_NAME) return;
      const row = sender.rows[e.row]?.dataItem as PlanActivityMgmtRow | undefined;
      if (!row) return;
      // 셀값 = CODE(dataMap value). 콤보행에서 OPMZ_ACTV_CD + 파생 5컬럼 복사.
      const selectedCode = str((row as Record<string, unknown>)[OPMZ_ACTV_NAME]);
      applyActivitySync(row, activityByCode.get(selectedCode));
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(handleCellEditEnded);
    return () => {
      try {
        grid.cellEditEnded.removeHandler(handleCellEditEnded);
      } catch {
        // 언마운트 레이스 — 이미 파괴된 컨트롤이면 정리할 것이 없다.
      }
    };
  }, [gridRef, activityByCode]);

  return (
    <DataGrid<PlanActivityMgmtRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
    />
  );
};
