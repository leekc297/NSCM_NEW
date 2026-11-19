import {
  AllowMerging,
  type CellRangeEventArgs,
  type FlexGrid,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS} from '../formation.constants';
import {
  attachNumberInputBlock,
  EXCEPT_LT_NEGATIVE_BLOCKED_COLUMNS,
  RESPONSE_SET,
  SHEET_INDEX,
} from '../formation.constants';
import { useFormationStore } from '../useFormationStore';

interface FormationExceptLtGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.EXCEPT_LT, RESPONSE_SET.EXCEPT_LT>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const FormationExceptLtGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: FormationExceptLtGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>> | undefined>();
  const staticColumns = useFormationStore(state => state.staticColumns);
  const { setAlert } = useMessageStore.getState();

  const { t } = useTranslation();

  // 편집 진입 시점 셀 값 스냅샷 — 값이 실제로 바뀐 편집에서만 검증/보정한다(빈 셀 클릭 진입-이탈로도
  //   cellEditEnded 가 떠서 값이 강제 보정되는 것을 막는다). FormationGrid 와 동일 규약.
  const preEditRef = useRef<{ row: number; col: number; value: string | number | null | undefined }>();
  const handleBeginEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding ?? '';
    const item = GridUtils.getRow(grid, e.row) as Record<string, unknown> | undefined;
    preEditRef.current = {
      row: e.row,
      col: e.col,
      value: item?.[binding] as string | number | null | undefined,
    };
  };

  // L/T 예외 — LT_FORMATION 은 편집 종료 검증 없음(AS-IS 파리티, 아래 분기 주석 참조),
  //   ADD_LT_FORMATION 은 파싱 실패 시 0 복원. 기간 중복은 저장 시 서버 99010.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;

    // 값이 실제로 바뀌지 않았으면(클릭 진입-이탈·편집 취소 등) 검증/보정하지 않는다.
    const snap = preEditRef.current;
    const nextRaw = (dataItem as Record<string, unknown>)[binding] as
      | string
      | number
      | null
      | undefined;
    if (
      snap &&
      snap.row === e.row &&
      snap.col === e.col &&
      String(snap.value ?? '') === String(nextRaw ?? '')
    ) {
      return;
    }

    const setCell = (col: string, value: string | number) => {
      const record = dataItem as Record<string, unknown>;
      editTrackerRef.current?.storeChange(dataItem, col, record[col] as string | number, value);
      record[col] = value;
    };

    const num = Number((dataItem as Record<string, unknown>)[binding]);
    // Formation L/T (LT_FORMATION) 은 0 포함 어떤 값도 편집 종료 시 검증하지 않는다 — AS-IS 파리티.
    //   AS-IS 는 이 탭(shtExceptLT)의 LT_FORMATION 에 셀 편집 검증을 연결하지 않았다
    //   (CheckDigitValueEntered 는 spdMain·수율 Except 탭에만 LT 검증이 있고, Except LT 시트의
    //    데이터모델 Changed 핸들러도 미연결 — SCP0022_Formation.cs L337/365-366/567). 유일한
    //   제어는 NumberCellType(min 0·정수) 뿐이라 '-'/'.' 는 attachNumberInputBlock 이 입력 시점에
    //   막고, 0 은 그대로 허용된다(보정·경고 없음).
    if (binding === 'ADD_LT_FORMATION') {
      // 이 탭(Except LT)의 Add L/T 는 AS-IS NumberCellType 최소값 0(SCP0022_Formation.cs L338)이라
      //   음수 입력을 막는다 — '-' 는 attachNumberInputBlock 이 입력 시점에 차단
      //   (EXCEPT_LT_NEGATIVE_BLOCKED_COLUMNS). 메인 Formation 그리드(L307, min -9999999999)와 달리
      //   음수 허용이 아니다. 편집 종료 검증은 AS-IS 가 이 탭 LT 컬럼에 연결하지 않아, 파싱 실패 시에만
      //   0 으로 리셋한다(AS-IS ZERO_OR_HIGHER→MSG00085).
      if (Number.isNaN(num)) {
        setCell(binding, 0);
        void setAlert({
          type: 'alert',
          content: t('MSG00085', '_{0} 이상의 값만 입력 가능합니다.').replace('{0}', '0'),
        });
      }
    }
    GridUtils.refreshRow(grid, e.row);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.EXCEPT_LT]}
      allowMerging={AllowMerging.None}
      alternatingRowStep={0}
      gotFocus={() => setActiveTab(SHEET_INDEX.EXCEPT_LT)}
      initialized={grid => attachNumberInputBlock(grid, EXCEPT_LT_NEGATIVE_BLOCKED_COLUMNS)}
      beginningEdit={handleBeginEdit}
      cellEditEnded={handleCellEdit}
    />
  );
};
