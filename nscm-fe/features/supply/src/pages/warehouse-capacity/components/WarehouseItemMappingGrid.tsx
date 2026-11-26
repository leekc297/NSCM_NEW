import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  attachDigitLimit,
  clearCellText,
  deriveStorLocCode,
  isCellEditable,
  isInvalidPlanGroupRow,
  isStorLocNameVisible,
} from '../utils/warehouseCapacityEditLock';
import { COMBO } from '../warehouse-capacity.constants';

import styles from './WarehouseItemMappingGrid.module.scss';

interface Props {
  rows: WijmoRowItem[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  divisionId: string;
  // WH Name 선택 시 숨김 필수 SCM_SITE_ID/STAGE 를 채우는 조회원 — key `DIVISION_ID|OPMZ_PLAN_GR_ID|WH_NM`.
  warehouseSiteStage: Map<string, { site: string; stage: string }>;
  onFocus: () => void;
}

/**
 * Warehouse Item Mapping 시트(design 03 §1.2, 16컬럼) — DataGrid.
 *
 * 조회(A2): 이 시트는 전용 GET SP(`PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_ITEM_MAPPING`, 9 IN +
 * O_RC1 16컬럼)가 배포돼 있다(gap-resolve iter-2 ALL_ARGUMENTS 실측). 페이지가 `useTabProcQuery`
 * (SHEETS.ITEM_MAPPING)로 조회한 행을 `rows` prop 으로 받아 렌더하며, Insert 신규행도 같은
 * CollectionView 에서 관리된다. 저장(A3)은 페이지 handleSave 가 activeSheet===1 에서
 * `P_SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING` 으로 전송한다.
 *
 * 컬럼은 admin `SCM_MST_SHEET_COLUMNS`(SHEET_NAME='Warehouse Item Mapping', 16행 실측)를 그대로
 * 쓴다. 편집잠금은 WhCapa 시트와 동일 `isCellEditable`(ALWAYS_LOCKED_COLUMNS 공유) — ITEM_ID 는
 * admin 메타 Cell Object 타입(FPTextModal)대로 key-in·더블클릭 팝업을 모두 허용한다(사용자 지시
 * 2026-11-23 — AS-IS 팝업 전용 하드코딩 제거, design 03 §1.2 gridSignals#19 deviation).
 *
 * STOR_LOC_NAME 은 division 에 '81_UC' 가 포함될 때만 표시(AS-IS `.cs:512-532` `SetVisibleSheetColumns`
 * — `SetVisibleSheetColumn(STOR_LOC_NAME, 80, true/false)`로 너비를 직접 덮어씀). admin 메타는
 * VISIBLE_FLAG='N'/COLUMN_WIDTH=0 고정이라(AS-IS 도 동일) 컬럼 목록에서 빼고 넣는 것만으론 안 되고
 * `colWth`/`visible` 을 직접 덮어써야 한다. 이 컬럼에 "East"/"West" 를 입력·붙여넣기하면 STOR_LOC 이
 * `@E`/`@W` 로 파생된다(AS-IS `.cs:1317-1336`/`1388-1406`).
 */
export const WarehouseItemMappingGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  divisionId,
  warehouseSiteStage,
  onFocus,
}: Props) => {
  const dblClickRowRef = useRef<WijmoRowItem | undefined>(undefined);
  const [itemModalOpen, setItemModalOpen] = useState(false);
  // 핸들러가 항상 최신 조회원을 보도록 ref 로 들고 있는다(effect dep 은 adminColumns 로 고정).
  const warehouseSiteStageRef = useRef(warehouseSiteStage);
  warehouseSiteStageRef.current = warehouseSiteStage;

  // OPMZ_PLAN_GR_ID 빈 값 표시(사용자 보고 2026-11-09/10 QA I-06 — WhCapa 와 동일 증상이 Item
  //   Mapping 테이블에도 있음, ora.py 실측). SCP_OPMZ_PLAN_GR_M VALID_YN='Y' 코드만 담은
  //   'PlanGroup_SCP_ALL' 콤보(Form 필터와 동일 원천)로 유효코드 집합을 만들어 화면(formatItem)
  //   에서만 가린다 — DB/프로시저 변경 없음, 저장키·조회조건은 원본 값 그대로.
  const [planGroups] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const validPlanGroupKeys = useMemo(() => {
    const set = new Set<string>();
    for (const r of planGroups ?? []) set.add(`${String(r.DIVISION_ID ?? '')}|${String(r.CODE ?? '')}`);
    return set;
  }, [planGroups]);
  const validPlanGroupKeysRef = useRef(validPlanGroupKeys);
  validPlanGroupKeysRef.current = validPlanGroupKeys;

  const columns = useMemo(() => {
    const cols = adminColumns ?? [];
    const visible = isStorLocNameVisible(divisionId);
    // admin 메타(STOR_LOC_NAME)는 VISIBLE_FLAG='N'/COLUMN_WIDTH=0 고정(AS-IS 도 동일 실측) —
    //   배열에 넣고 빼는 것만으론 그 객체가 들고 있는 colWth:0/visible:false 가 그대로 남아 계속
    //   안 보인다. AS-IS SetVisibleSheetColumn(STOR_LOC_NAME, 80, true/false)처럼 너비를 직접
    //   덮어써야 한다(2026-11-05 사용자 보고 — 81_UC에서도 안 보임).
    return cols.map(c =>
      c.colNm === 'STOR_LOC_NAME' ? { ...c, visible, colWth: visible ? 80 : 0 } : c
    );
  }, [adminColumns, divisionId]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const item = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!item) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // Model(ITEM_ID) 더블클릭 팝업 진입 어포던스 아이콘 — admin 메타(CELL_CONTROL_OBJECT_TYPE_CODE)가
    //   비어 있어 공용 formatPopupIcon 대상이 아니다(사용자 지시 2026-11-05, 위 scss 주석 참고).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding === 'ITEM_ID') {
        e.cell.style.paddingRight = '20px';
        if (!e.cell.querySelector('.popup-icon')) {
          const icon = document.createElement('span');
          icon.className = `popup-icon ${styles.popupIcon}`;
          e.cell.appendChild(icon);
        }
      } else if (e.cell.querySelector('.popup-icon')) {
        e.cell.style.paddingRight = '';
        e.cell.querySelector('.popup-icon')?.remove();
      }

      // STOR_LOC_NAME(Storage Loc) — admin 메타 INPUT_TP_CD='S'(SEARCH_ONLY)라 공용 wrapper
      //   (GridUtils.isEditableCell)가 wj-cell-editable(노란 배경)을 꺼버린다. 실제로는 East/West
      //   타이핑·붙여넣기로 편집 가능한 셀(storLocDeriveHandler)이라 이 화면의 isCellEditable
      //   화이트리스트 기준으로 재대입한다(ShipmentPlanDetailGrid 와 동일 선례 — formatItem 등록
      //   순서가 최종 판정, 사용자 지시 2026-11-05).
      if (binding === 'STOR_LOC_NAME') {
        e.cell.classList.toggle('wj-cell-editable', isCellEditable(binding));
      }

      // OPMZ_PLAN_GR_ID 빈 값 표시 — 유효 Plan Group 집합 밖 코드는 셀 텍스트만 지운다(DataMap 은
      //   건드리지 않아 편집·저장 값은 그대로 원본 코드를 유지한다). clearCellText 는 텍스트 노드만
      //   비워 Wijmo 가 같이 심어 둔 드롭다운 화살표 요소는 남긴다(2026-11-10 실사고 — textContent
      //   전체 초기화는 그 요소까지 지워 편집 진입 후 드롭다운이 안 뜸).
      if (binding === 'OPMZ_PLAN_GR_ID') {
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        if (isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) clearCellText(e.cell);
      }
    };
    g.formatItem.addHandler(formatItemHandler as never);

    // 편집 진입 시에도 빈값으로 시작(사용자 지시 2026-11-10, WhCapa 동형) — 아무것도 새로 고르지
    //   않고 그대로 커밋하면 원본 값을 유지한다(OPMZ_PLAN_GR_ID 는 PRE_KEY_VALUES 구성요소라
    //   빈 문자열로 덮이면 데이터 유실).
    const planGroupPrepareEditHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) return;
      const editor = sender.activeEditor as { value?: string } | null;
      if (editor) editor.value = '';
    };
    g.prepareCellForEdit.addHandler(planGroupPrepareEditHandler as never);

    const planGroupEditEndingHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) return;
      const editor = sender.activeEditor as { value?: string } | null;
      if (!(editor?.value ?? '').trim()) e.cancel = true;
    };
    g.cellEditEnding.addHandler(planGroupEditEndingHandler as never);

    // STOR_LOC_NAME(East/West) → STOR_LOC(@E/@W) 파생(AS-IS ComboSelChange/ClipboardPasted).
    const storLocDeriveHandler = (
      sender: FlexGridType,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'STOR_LOC_NAME') return;
      const row = GridUtils.getRow(sender, e.row) as WijmoRowItem | undefined;
      if (!row) return;
      const code = deriveStorLocCode(row.STOR_LOC_NAME);
      editTrackerRef.current?.storeChange(
        row as never,
        'STOR_LOC' as never,
        row.STOR_LOC as never,
        code as never
      );
      row.STOR_LOC = code;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(storLocDeriveHandler as never);
    g.pastedCell.addHandler(storLocDeriveHandler as never);

    // WH Name 변경 → 숨김 필수 SCM_SITE_ID/STAGE 자동파생(AS-IS SpdMain_ComboSelChange .cs:1298-1314).
    //   창고(DIVISION_ID+OPMZ_PLAN_GR_ID+WH_NM)를 'Warehose' 콤보로 조회해 Site/Stage 를 채운다 —
    //   두 컬럼은 NOT NULL+필수인데 VISIBLE_FLAG=N(숨김)이라 안 채우면 저장 시 ORA-01400.
    //   매치 없으면(그 조합의 창고 미존재) 비워 둔다 — 공통 필수검증이 저장 전에 막는다.
    const whDeriveHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'WH_NM') return;
      const row = GridUtils.getRow(sender, e.row) as WijmoRowItem | undefined;
      if (!row) return;
      const key = `${String(row.DIVISION_ID ?? '')}|${String(row.OPMZ_PLAN_GR_ID ?? '')}|${String(row.WH_NM ?? '')}`;
      const hit = warehouseSiteStageRef.current.get(key);
      if (!hit) return;
      editTrackerRef.current?.storeChange(row as never, 'SCM_SITE_ID' as never, row.SCM_SITE_ID as never, hit.site as never);
      editTrackerRef.current?.storeChange(row as never, 'STAGE' as never, row.STAGE as never, hit.stage as never);
      row.SCM_SITE_ID = hit.site;
      row.STAGE = hit.stage;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(whDeriveHandler as never);
    g.pastedCell.addHandler(whDeriveHandler as never);

    // STOR_PER 정수부 10자리 제한(사용자 요청 2026-11-10).
    const detachDigitLimit = attachDigitLimit(g);

    return () => {
      try {
        detachDigitLimit();
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.formatItem?.removeHandler(formatItemHandler as never);
        g.prepareCellForEdit?.removeHandler(planGroupPrepareEditHandler as never);
        g.cellEditEnding?.removeHandler(planGroupEditEndingHandler as never);
        g.cellEditEnded?.removeHandler(storLocDeriveHandler as never);
        g.pastedCell?.removeHandler(storLocDeriveHandler as never);
        g.cellEditEnded?.removeHandler(whDeriveHandler as never);
        g.pastedCell?.removeHandler(whDeriveHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns]);

  // ITEM_ID 셀 더블클릭 → MaterialByDivisionModal(design 03 §1.2, gridSignals#19 SetText 재현).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row) as WijmoRowItem | undefined;
    if (!row) return;
    dblClickRowRef.current = row;
    setItemModalOpen(true);
  };

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        // cascade(연동 편집) 화면 — undo 시 cellEditEnded 재발화로 연동 셀까지 복원(순수 집계/파생, clear·부작용 없음 확인).
        reapplyEditOnUndo
        itemsSource={rows}
        staticColumns={columns}
        allowMerging={AllowMerging.None}
        gotFocus={onFocus}
        dblClick={handleDblClick}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        preSearchParams={{ divisionId, scpModuleType: 'SCP0133' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            editTrackerRef.current?.storeChange(
              row as never,
              'ITEM_ID' as never,
              row.ITEM_ID as never,
              items as never
            );
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          setItemModalOpen(false);
        }}
      />
    </>
  );
};
