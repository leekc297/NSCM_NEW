import {
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ALWAYS_LOCKED_COLUMNS,
  COMBO,
  INVALID_CELL_BG_COLOR,
  isSalesSitePopupDivision,
  LOCK_ON_NON_WARRANTY,
  LOCK_ON_WARRANTY_EXISTING,
  MSG,
  OPERATION_GROUP_WARRANTY,
} from '../project-route-warranty.constants';
import type { MainRow } from '../project-route-warranty.types';
import { deriveTactTimeFlag } from '../utils/projectRouteWarranty.derive';

interface Props {
  gridRef: MutableRefObject<FlexGrid<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  // 조회조건 division — 셀 콤보(PLANT_SITE_ID) 재조회 bind + 신규행 DIVISION_ID 기본.
  divisionId: string;
  // Edit 토글(R-L1) — false 면 전 셀 편집 잠금. true 라도 R-L2/R-L3·ALWAYS_LOCKED 는 개별 잠금.
  editMode: boolean;
  // 저장검증 실패 셀(design/03 §3.4 R-B1/R-B2). dataItem 참조 + 컬럼 binding 으로 식별해 배경 강조.
  invalidCells: { row: MainRow; column: string }[];
  // ITEM_ID 셀 더블클릭 → Item 팝업(R-D8). div=81 SCM_SITE_ID/PROJECT_CODE 셀 → SalesSite 팝업(R-D6).
  onItemCellDblClick: (row: MainRow) => void;
  onSalesSiteCellDblClick: (row: MainRow) => void;
  gotFocus?: () => void;
}

// SCP0048 단일 그리드(spdMain) — 31 컬럼 DB 메타 구동. 편집은 조건부(R-L1~R-L5), 파생 R-D1~D8.
//   셀콤보: VALID_YN(정적 YesOrNo 자동) / PLANT_SITE_ID(ElecRoutePlantByOperation_SCP 3-bind,
//   comboParams re-seat) / DIVISION_ID(신규행 전용 MyDivision, getDisplayValues insert-only).
export const ProjectRouteWarrantyGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  editMode,
  invalidCells,
  onItemCellDblClick,
  onSalesSiteCellDblClick,
  gotFocus,
}: Props) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore.getState();

  // PLANT_SITE_ID 셀 콤보(design/03 §3.1 R-C2~C5). bind @divisionId·@operationGroup·@itemId.
  //   AS-IS 는 셀 진입 시점의 행 ITEM_ID/opGroup 으로 재조회하나(행별), 정적 콤보 메타로는 행별
  //   재조회를 표현할 수 없어(04_react-gap GAP-3) 조회조건 division 을 공통 bind 로 실어 re-seat 한다.
  //   R-C3(ITEM_ID 변경 시 opGroup="W" 고정)에 맞춰 operationGroup 은 Warranty 고정으로 bind.
  //   값은 홑따옴표 규약(nscm-patterns §3.3, makeComboQuery @토큰 치환).
  const comboParams = useMemo(
    () => ({
      divisionId: `'${divisionId}'`,
      operationGroup: `'${OPERATION_GROUP_WARRANTY}'`,
      itemId: '\'\'',
    }),
    [divisionId]
  );

  // DIVISION_ID 신규행 전용 콤보(design/03 §3.1 R-C1) — MyDivision(ATTRIBUTE3<>'EE') 사전로드.
  //   메타에 없는 코드 콤보라 FE 가 DataMap 을 만들어 컬럼에 붙인다. getDisplayValues 를 덮어
  //   신규행(CRUD_TYPE='I')에서만 후보를 노출하고 조회행은 빈 후보(편집불가 동등)로 둔다
  //   (insert-only 하드코딩 패턴, sales-plan.gridCombos 준용). PARAM9 메타 금지.
  const [myDivisionRaw] = useTabComboQueries({ filters: [COMBO.CELL_DIVISION] });
  const divisionDataMap = useMemo(() => {
    const rows = (myDivisionRaw ?? []).filter(
      (r: ComboResponse) => String(r.ATTRIBUTE3 ?? '') !== 'EE'
    );
    if (rows.length === 0) return null;
    const map = new DataMap(rows, 'CODE', 'NAME');
    const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
    map.getDisplayValues = (item?: unknown): string[] => {
      const all = [...new Set(allDisplayValues(item))];
      // 행 컨텍스트 없는 호출(필터 패널 등)은 전체 유지 — 비우면 필터가 죽는다.
      if (!item) return all;
      return (item as MainRow).CRUD_TYPE === 'I' ? all : [];
    };
    return map;
  }, [myDivisionRaw]);

  // DIVISION_ID 컬럼에 신규행 전용 DataMap 부착(DataGrid 가 컬럼을 (재)생성할 때마다 재부착).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !divisionDataMap) return;
    const attach = () => {
      const col = grid.getColumn('DIVISION_ID');
      if (col && col.dataMap !== divisionDataMap) col.dataMap = divisionDataMap;
    };
    grid.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        grid.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, divisionDataMap]);

  // 조건부 편집 잠금(design/03 §3.3). INPUT_TP_CD 전건 'S' 라 메타로 표현 불가 → beginningEdit
  //   override(GAP-4). R-L1(Edit 토글 off → 전잠금) / ALWAYS_LOCKED(감사·파생·키) /
  //   R-L2(opGroup≠"W" → PLANT_SITE_ID~VALID_YN) / R-L3(W & PRIORITY_SEQ≠"" 기존행 →
  //   PLANT_SITE_ID~PROJECT_CODE). 신규행(CRUD_TYPE='I')은 DIVISION_ID 편집 허용(R-C1).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const alwaysLocked: readonly string[] = ALWAYS_LOCKED_COLUMNS;
    const lockNonWarranty: readonly string[] = LOCK_ON_NON_WARRANTY;
    const lockWarrantyExisting: readonly string[] = LOCK_ON_WARRANTY_EXISTING;
    const beginningEditHandler = (s: FlexGrid<MainRow>, e: { cancel: boolean; row: number; col: number }) => {
      if (!editMode) {
        e.cancel = true;
        return;
      }
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      const isInsert = row?.CRUD_TYPE === 'I';
      // 신규행은 DIVISION_ID 편집 허용, 그 외 ALWAYS_LOCKED 는 항상 잠금.
      if (binding === 'DIVISION_ID') {
        if (!isInsert) e.cancel = true;
        return;
      }
      if (alwaysLocked.includes(binding)) {
        e.cancel = true;
        return;
      }
      const opGroup = String(row?.OPERATION_GROUP ?? '');
      const prioritySeq = String(row?.PRIORITY_SEQ ?? '');
      // R-L2 — Warranty 아닌 행: PLANT_SITE_ID~VALID_YN 잠금.
      if (opGroup !== OPERATION_GROUP_WARRANTY && lockNonWarranty.includes(binding)) {
        e.cancel = true;
        return;
      }
      // R-L3 — Warranty 기존행(PRIORITY_SEQ 존재): PLANT_SITE_ID~PROJECT_CODE 잠금.
      if (
        opGroup === OPERATION_GROUP_WARRANTY &&
        prioritySeq !== '' &&
        lockWarrantyExisting.includes(binding)
      ) {
        e.cancel = true;
      }
    };
    grid.beginningEdit.addHandler(beginningEditHandler);
    return () => {
      try {
        grid.beginningEdit.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, editMode]);

  // 저장검증 실패 셀 배경 강조(design/03 §3.4 R-B1/R-B2, AS-IS SetBGColor(InvalidColor)).
  //   뷰행 index 로 DOM 을 직접 칠하면 스크롤 시 셀 DOM 이 재활용돼 강조가 어긋난다 → formatItem 이
  //   재도색할 때마다 dataItem 참조 + 컬럼 binding 으로 다시 판정한다(BodGrid saveError 패턴 준용).
  //   effect 클로저가 최신 invalidCells 를 보도록 ref 로 보관하고, 값이 바뀌면 invalidate 로 재도색한다.
  const invalidCellsRef = useRef(invalidCells);
  invalidCellsRef.current = invalidCells;
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<MainRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      const dataItem = GridUtils.getRow(s, e.row) as MainRow | undefined;
      if (!dataItem) return;
      // 매칭 시 배경 강조, 아니면 해제(셀 DOM 재사용 대비 항상 재설정).
      const isInvalid = invalidCellsRef.current.some(
        c => c.row === dataItem && c.column === binding
      );
      e.cell.style.backgroundColor = isInvalid ? INVALID_CELL_BG_COLOR : '';
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => {
      try {
        grid.formatItem.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, invalidCells]);

  // 파생(design/03 §3.2). PLANT_SITE_ID 변경 → TACT_TIME_FLAG(R-D1, last-char). VALID_YN 되돌림은
  //   MSG.VALID_REVERT alert 를 내야 해 여기서는 값 복원만 하지 않고 파생만 담당한다 —
  //   R-D3(되돌림)·R-D4(DIVISION 변경 clear)는 값 세팅 + alert 조합이라 handleCellEdit 에서 처리한다.
  const handleCellEdit = (grid: FlexGrid<MainRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    const record = dataItem as Record<string, unknown>;

    // R-D3 — VALID_YN 을 opGroup≠W 행에서 'Y' 로 바꾸려 하고 원본(ORG_VALID_YN)이 'N' 이면
    //   수정 불가로 'N' 되돌림 + MSG.VALID_REVERT. Warranty(W) 행은 자유 편집.
    if (binding === 'VALID_YN') {
      const opGroup = String(record.OPERATION_GROUP ?? '');
      const orgValidYn = String(record.ORG_VALID_YN ?? '');
      if (opGroup !== OPERATION_GROUP_WARRANTY && String(record.VALID_YN ?? '') === 'Y' && orgValidYn === 'N') {
        editTrackerRef.current?.storeChange(dataItem, 'VALID_YN', 'Y', 'N');
        record.VALID_YN = 'N';
        GridUtils.refreshRow(grid, e.row);
        void setAlert({
          type: 'alert',
          content: t(MSG.VALID_REVERT, '_Valid 값을 수정할 수 없습니다.'),
        });
      }
      return;
    }

    // R-D1 — PLANT_SITE_ID 선택 시 표시문자열 마지막문자 = TACT_TIME_FLAG.
    if (binding === 'PLANT_SITE_ID') {
      const flag = deriveTactTimeFlag(record.PLANT_SITE_ID);
      editTrackerRef.current?.storeChange(
        dataItem,
        'TACT_TIME_FLAG',
        record.TACT_TIME_FLAG as string,
        flag
      );
      record.TACT_TIME_FLAG = flag;
      GridUtils.refreshRow(grid, e.row);
      return;
    }

    // R-D4 — DIVISION_ID 변경 시 PLANT_SITE_ID/ITEM_ID/NICK_NAME clear, SCM_SITE_ID/PROJECT_CODE 는
    //   비-81 이면 "-"(R-D5). div=81 이면 팝업으로 채우므로 여기선 clear 만.
    if (binding === 'DIVISION_ID') {
      const clears: [string, string][] = [
        ['PLANT_SITE_ID', ''],
        ['ITEM_ID', ''],
        ['NICK_NAME', ''],
      ];
      const div = String(record.DIVISION_ID ?? '');
      if (!isSalesSitePopupDivision(div)) {
        clears.push(['SCM_SITE_ID', '-'], ['PROJECT_CODE', '-']);
      }
      for (const [col, val] of clears) {
        editTrackerRef.current?.storeChange(dataItem, col, record[col] as string, val);
        record[col] = val;
      }
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // 더블클릭 팝업(design/03 R-G3/R-D6~D8). ITEM_ID → Item 팝업, div=81 의 SCM_SITE_ID/PROJECT_CODE
  //   → SalesSite 팝업. Rows<=0(R-G3) 이면 무반응.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || grid.rows.length <= 0) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    const row = grid.rows[ht.row]?.dataItem as MainRow | undefined;
    if (!row) return;
    if (binding === 'ITEM_ID') {
      onItemCellDblClick(row);
      return;
    }
    if (binding === 'SCM_SITE_ID' || binding === 'PROJECT_CODE') {
      if (isSalesSitePopupDivision(String(row.DIVISION_ID ?? ''))) onSalesSiteCellDblClick(row);
    }
  };

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      comboParams={comboParams}
      cellEditEnded={handleCellEdit}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
