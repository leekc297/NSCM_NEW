import { CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { COMBO } from '../safety-stock.constants';
import type { MainRow } from '../safety-stock.types';
import { isMainCellEditable } from '../utils/safetyStockEditLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  itemModalOpen: boolean;
  onItemModalOpenChange: (open: boolean) => void;
}

/**
 * 메인 그리드 — design/03_grid-columns.md §3.1 white-list 재현. TO-BE 는 EditButton 편집모드
 * 토글을 이식하지 않으므로(§11 전 화면 공통 결정) 기존행은 상시 read-only, 신규행만 편집 가능
 * (판정 로직은 utils/safetyStockEditLock.ts `isMainCellEditable` 단일 진실원 — 공용 `isCellEditable`
 * prop 부재, DataGrid 는 조건부 편집을 `beginningEdit`/`pastingCell` 로 위임).
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/01_layout.md §2 L9,
 * 02_search-combo.md §4.6 확정 재사용) — gridSignals#12 SetText 재현. buttonGuards#4·#5
 * (헤더 더블클릭 제외 / 잠금 또는 (신규아님&&비편집모드) 시 팝업 차단)를 재현하되, TO-BE 는
 * "비편집모드" 축이 상시 참(Edit 미이식)이라 실질 조건은 "신규행만 허용"으로 단순화된다.
 *
 * 셀 콤보 5칼럼 중 VALUE_TYPE/SCM_SITE_ID/STAGE/VALID_YN 4개는 `SCM_ADM_CMBO_SQL_M` 전건
 * 미등록 상태(03_grid-columns.md §1.1) — `staticColumns`(admin fetch)를 그대로 반영하면 드롭다운
 * 후보가 비어 렌더될 수 있다(콤보 등록은 admin 소관, 화면이 하드코딩으로 메우지 않는다 —
 * convert-core §2.3/§2.6). GAP-11 잔존(DB 갭, 코드로 메우지 않음).
 *
 * OPMZ_PLAN_GR_ID 는 `PlanGroup` SQL_ID 등록은 됐으나 PARAM2(행 좁힘 바인딩) 미설정이라
 * 공용 DataGrid 표준 경로로는 전체 PlanGroup 이 Division 무관하게 노출된다(runtime-parity-gate
 * v2 GAP-11). AS-IS 는 조회조건 Division 필터가 적용된 상태를 재사용하므로(§3.2 AS-IS 원문
 * spdMain_CellClick 근거), 화면 로컬에서 조회조건 `divisionId` 기준 클라이언트 필터 DataMap 을
 * 직접 배선한다 — DB 메타(PARAM2)는 그대로 두고 화면 코드만으로 처리(기존 `IntegrationPsiGrid.tsx`
 * LINE_ID 콤보와 동일 패턴, `[[wijmo-columngroups-recreate-datamap]]` 규약: 공용 DataGrid 가
 * 콤보 응답 시마다 dataMap 을 메타 기반으로 재대입하므로 `updatedLayout` 마다 재부착해야 유지된다).
 */
export const SafetyStockGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  itemModalOpen,
  onItemModalOpenChange,
}: Props) => {
  const dblClickRowRef = useRef<MainRow | undefined>(undefined);

  // AS-IS SpdMain_ClipboardPasted(.cs:1111~1131) 파생 1건 재현(goal.md v2 ④-6) — OPMZ_PLAN_GR_ID
  //   컬럼에 NAME 텍스트를 붙여넣으면 dtPlanGroup 에서 NAME 매칭으로 CODE 를 역조회해 치환한다.
  //   TO_YYYYMMDD 리셋 로직은 AS-IS SpdMain_EditChange 가 이벤트 미배선(dead code, ④-7)이라 이관
  //   대상이 아니다 — 재현하지 않는다.
  const [planGroups] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupsRef = useRef(planGroups);
  planGroupsRef.current = planGroups;

  // GAP-11(runtime-parity-gate v2) — OPMZ_PLAN_GR_ID 그리드 셀 콤보를 조회조건 Division 기준으로
  //   클라이언트 필터링(DB PARAM2 미설정은 갭으로 남김, 화면 코드만으로 처리).
  //   DIVISION_ID 없는 행(공통)은 항상 후보에 포함 — SafetyStockForm 조회조건 콤보와 동일 규칙.
  const planGroupDataMap = useMemo(() => {
    const filtered = (planGroups ?? []).filter(
      item => !item.DIVISION_ID || item.DIVISION_ID === divisionId
    );
    if (filtered.length === 0) return null;
    return new DataMap(filtered, 'CODE', 'NAME');
  }, [planGroups, divisionId]);

  // 공용 DataGrid 가 콤보 응답마다 admin 메타 기반 dataMap 으로 재대입하므로, layout 재적용마다
  //   위 필터링 dataMap 을 다시 덮어써야 유지된다([[wijmo-columngroups-recreate-datamap]] 규약,
  //   IntegrationPsiGrid.tsx LINE_ID 선례와 동일 처리).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      if (!planGroupDataMap) return;
      const col = g.columns.getColumn('OPMZ_PLAN_GR_ID');
      if (col && col.dataMap !== planGroupDataMap) col.dataMap = planGroupDataMap;
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, planGroupDataMap]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row || !isMainCellEditable(binding, row)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // gridSignals#14(.cs:1123~1125) — OPMZ_PLAN_GR_ID 붙여넣기 시 NAME->CODE 역조회 치환.
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) return;
      const pastedText = String(row.OPMZ_PLAN_GR_ID ?? '');
      if (pastedText === '') return;
      const matched = planGroupsRef.current?.find(item => item.NAME === pastedText);
      if (!matched || matched.CODE === pastedText) return;
      editTrackerRef.current?.storeChange(row, 'OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID, matched.CODE);
      row.OPMZ_PLAN_GR_ID = matched.CODE;
      sender.invalidate();
    };
    g.pastedCell.addHandler(pastedCellHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // buttonGuards#4 — 헤더 더블클릭 제외. buttonGuards#5(신규행만 허용 — 위 헤더 주석 참조).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    if (row.CRUD_TYPE !== 'I' && row.CRUD_TYPE !== 'C') return; // 기존행 = 팝업 차단(Edit 미이식)
    dblClickRowRef.current = row;
    onItemModalOpenChange(true);
  };

  return (
    <>
      <DataGrid<MainRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => onItemModalOpenChange(false)}
        preSearchParams={{ divisionId, scpModuleType: 'SCP0128' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            // gridSignals#12 SetText(e.Row, ITEM_ID, sItemId) 재현.
            editTrackerRef.current?.storeChange(row, 'ITEM_ID', row.ITEM_ID, items);
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          onItemModalOpenChange(false);
        }}
      />
    </>
  );
};
