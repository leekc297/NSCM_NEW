// SCP0125 그리드 1개를 5탭이 시트 파라미터로 재사용한다. 화면이 직접 담당하는 것은
//   (a) 편집 4계층(beginningEdit / pastingCell / formatItem / 저장 필수검증은 페이지)
//   (b) 파생 D1~D4 (cellEditEnded + pastedCell 양쪽)
//   (c) 셀 팝업 2종(Project=U06 / Item=U07) 뿐이다. 컬럼·정렬·소수자리·셀유형은 admin 메타 구동이다.
//
// AS-IS 근거: cs:2072~2074(CellClick·D07) · cs:2174~2231(CellDoubleClick·D09/D10 + G40/G41) ·
//             cs:2235~2290(ClipboardPasted·D16 + G42~G44) · cs:2300~2370(ComboSelChange·D17 + G45~G48)

import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { ModelByDivisionPopup, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { buildColumns } from '../utils/workbench.columns';
import { deriveOnCellChange, type DeriveSources } from '../utils/workbench.derive';
import { isCellEditable, isInsertRow } from '../utils/workbench.editLock';
import type { CellComboRows } from '../utils/workbench.gridCombos';
import {
  ADMIN_SHEET_NAME,
  COL,
  DATE_COLUMN,
  EDITABLE_ON_INSERT_ROW,
  MENU_ID,
} from '../workbench.constants';
import type { TABS } from '../workbench.constants';
import type { WorkbenchRow } from '../workbench.types';

interface Props {
  tab: TABS;
  rows: WorkbenchRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  comboRows: CellComboRows;
  deriveSources: DeriveSources;
  /** `hasButton('EDIT')` — 화면 오픈 시 1회 확정되는 편집 권한(규범 convert-core §2.4, 모드 토글 아님). */
  canEdit: boolean;
  /** 조회조건에서 확정된 division — 편집잠금·팝업 파라미터·동적 컬럼 표시의 입력. */
  divisionId: string;
  onFocus: () => void;
}

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** Due Date 셀 표시 포맷 — 공용 `getFormat`(columnMapping.ts)이 전 화면 날짜 컬럼에 전역으로
 *  `yyyy.MM.dd`(점)를 적용하므로, 이 화면 `DUE_DATE` 셀만 설계서(03 §514 = `YYYY-MM-DD`)대로
 *  하이픈 표기로 덮어쓴다. 표시 override 일 뿐이라 저장 payload(원본 값 기준 `toYyyymmdd`,
 *  workbench.save.ts)에는 영향이 없다. 분기는 `toYyyymmdd` 와 동일하고 출력만 하이픈이다. */
const toDisplayDate = (value: unknown): string => {
  if (value instanceof Date) return dayjs(value).format('YYYY-MM-DD');
  const text = str(value).trim();
  if (!text) return '';
  const digits = text.replace(/[^0-9]/g, '');
  if (digits.length >= 8) return `${digits.slice(0, 4)}-${digits.slice(4, 6)}-${digits.slice(6, 8)}`;
  const parsed = dayjs(text);
  return parsed.isValid() ? parsed.format('YYYY-MM-DD') : text;
};

// Wijmo 는 셀 DOM 을 재사용하므로 조건 미해당 시에도 항상 클래스를 해제한다(hook #95 §1-4).
const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

/** 팝업 셀 — `PROJECT_CODE`(U06) · `ITEM_ID`(U07). AS-IS `CellDoubleClick`(cs:2174~2231)은
 *  시트를 가리지 않고 더블클릭 컬럼이 이 둘이면 팝업을 연다 — `PROJECT_CODE` 는 MKT FCST/STOCK/
 *  Stock(Elec) 3탭, `ITEM_ID` 는 5탭 전부에 존재한다(design 03 §정정 2026-10-01: 종전 'STOCK 팝업
 *  배선 없음' 은 분석 오류). 탭 범위는 신규행 편집가능 집합(`EDITABLE_ON_INSERT_ROW`)으로 스코프한다. */
const isPopupCell = (tab: TABS, binding: string): boolean =>
  (binding === COL.PROJECT_CODE || binding === COL.ITEM_ID) &&
  EDITABLE_ON_INSERT_ROW[tab].includes(binding);

export const WorkbenchGrid = ({
  tab,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  comboRows,
  deriveSources,
  canEdit,
  divisionId,
  onFocus,
}: Props) => {
  // 동적 컬럼 표시(V1~V5)는 폭 0 으로 재현한다. deps 가 division·메타·콤보라 재평가 트리거
  //   4곳(mount / 조회마다 / Division 변경 / 탭 전환)이 자동으로 커버된다(03 §2.2 D-7).
  const columns = useMemo(
    () => buildColumns(tab, staticColumns, divisionId, comboRows),
    [tab, staticColumns, divisionId, comboRows]
  );

  // 셀 콤보 @토큰(@mnuId) 해소 — 메타 자동 콤보(`FcstType`/`YesOrNo`)가 쓴다.
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  const [clickedRow, setClickedRow] = useState(-1);
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // 핸들러는 grid 생성 후 1회 등록이라 ref 로 최신값을 본다(stale closure 방지).
  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;
  const divisionRef = useRef(divisionId);
  divisionRef.current = divisionId;
  const deriveRef = useRef(deriveSources);
  deriveRef.current = deriveSources;

  /** 파생 결과를 EditTracker 에 기록하고 행에 반영한다(D1~D4 공통 경로). */
  const applyDerived = (grid: FlexGridType, rowIndex: number, binding: string) => {
    const dataItem = GridUtils.getRow(grid, rowIndex) as Record<string, unknown> | undefined;
    if (!dataItem) return;
    const derived = deriveOnCellChange(tab, binding, dataItem, deriveRef.current);
    const entries = Object.entries(derived);
    if (entries.length === 0) return;
    for (const [key, value] of entries) {
      editTrackerRef.current?.storeChange(dataItem as never, key, dataItem[key] as never, value);
      dataItem[key] = value;
    }
    GridUtils.refreshRow(grid, rowIndex);
  };

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // ③ 시각 강조 — 편집가능 셀에 편집색(hook #95). AS-IS 잠금색은 White 라 회색 전면칠 금지.
    //
    // ⑤ 팝업 셀도 편집색(노란)을 입힌다 — 사용자 결정 2026-10-01. 종전에는 편집색 대신 팝업
    //   아이콘만 붙였으나(hook #95 §1 "노란칸인데 못 고치는" 혼란 회피 의도), 다른 편집셀과
    //   색이 달라 편집 가능으로 안 보인다는 피드백에 따라 편집색 + 아이콘을 함께 건다. 인라인
    //   편집은 여전히 아래 `beginningEdit` 가 취소하고(nscm-patterns §5-16) 값 입력은 더블클릭
    //   팝업뿐이다 — 겹쳐 뜨는 OpenInNew 아이콘이 "타이핑이 아니라 팝업" 신호를 유지한다.
    //   아이콘 조건은 팝업이 실제로 열리는 조건과 같게 맞춘다(`canEdit` + 신규행 = 아래 dblclick 가드).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const popupCell = isPopupCell(tab, binding);
      // 팝업 셀도 편집 가능하면 편집색을 받는다(popup 여부로 배제하지 않는다 — 위 주석 ⑤).
      toggleClass(
        e.cell,
        'wj-cell-editable',
        isCellEditable(tab, binding, row, canEditRef.current, divisionRef.current)
      );
      toggleClass(e.cell, 'wj-cell-popup', popupCell && canEditRef.current && isInsertRow(row));
      toggleClass(e.cell, 'wj-cell-non-editable', false);
      // Due Date 만 하이픈 표기로 덮어쓴다(위 `toDisplayDate` 주석 — 공용 전역 포맷은 점 표기).
      //   DUE_DATE 는 팝업/아이콘 셀이 아니라 셀에 자식 DOM 이 없으므로 textContent 교체가 안전하다.
      //   단, **편집 중인 셀은 건드리지 않는다** — 그 셀의 편집기(마스크 입력/달력) DOM 을 textContent 로
      //   덮어쓰면 입력이 막힌다(2026-10-08 회귀 수정).
      // 대상은 Due Date 만이 아니라 탭별 날짜 컬럼(DATE_COLUMN) 전체다.
      // if (binding === COL.DUE_DATE) {
      if (binding && binding === DATE_COLUMN[tab]) {
        const editRange = sender.editRange;
        const underEdit = !!editRange && editRange.row === e.row && editRange.col === e.col;
        // if (!underEdit) e.cell.textContent = toDisplayDate(row?.[COL.DUE_DATE]);
        if (!underEdit) e.cell.textContent = toDisplayDate(row?.[binding]);
      }
    };
    grid.formatItem.addHandler(formatItemHandler);

    // ① 인라인 편집 — 공용 DataGrid 기본(INPUT_TP_CD='S' 라 전 셀 차단)을 **마지막에** 재지정한다.
    //   팝업 셀은 인라인 편집 대신 더블클릭 팝업이어야 하므로 여기서 편집 진입을 취소한다(§5-16).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 팝업 셀의 인라인 편집 허용 여부는 메타 cellCtrlObjTpCd 로 가른다(공용 dataGridUtils
      //   cellEditHandler 와 같은 기준). FPTextModal = 키인 + 더블클릭 팝업 동시 허용이라 취소하지 않고
      //   아래 편집 게이트로 넘긴다. FPModal(또는 미지정)은 더블클릭 팝업 전용이라 편집 진입을 막는다(§5-16).
      const ctrlType = columns.find(column => column.colNm === binding)?.cellCtrlObjTpCd;
      if (isPopupCell(tab, binding) && ctrlType !== CELL_CONTROL_TYPE.TEXT_MODAL) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(tab, binding, row, canEditRef.current, divisionRef.current);
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    // ② 붙여넣기 — 같은 게이트를 건다. 이걸 빼면 AS-IS ClipboardPasted 로직(R18/E07)이 전부 죽는다.
    //
    // 필수: **양방향**으로 재지정한다(`cancel = !editable`). 단방향(`if (!editable) cancel = true`)이면
    //   공용 기본 핸들러가 먼저 세운 `cancel` 이 그대로 남아 붙여넣기가 전면 차단된다 —
    //   `dataGridUtils.defaultEditHandler` 가 `cancel = !GridUtils.isEditableCell(...)` 을 세우고,
    //   그 판정은 `INPUT_TP_CD='S'`(이 화면 102행 전건)를 무조건 false 로 돌린다. 차단되면
    //   `pastedCell` 이 발화하지 않아 파생 D1·D2·D4 의 Paste 경로(P-2·P-6)까지 같이 죽는다.
    //   팝업 셀은 여기서 제외하지 않는다 — 인라인 편집 진입만 막고(위 `beginningEdit`),
    //   AS-IS ClipboardPasted 는 그 컬럼에도 붙여넣기를 허용한다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !isCellEditable(tab, binding, row, canEditRef.current, divisionRef.current);
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    // 붙여넣기 완료 후 파생(G42~G44) — 콤보 경로와 **같은 함수**를 부른다.
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      applyDerived(sender, e.row, binding);
    };
    grid.pastedCell.addHandler(pastedCellHandler);

    // 더블클릭 팝업(D09 헤더 제외 / D10 신규행 한정).
    //   AS-IS D10 은 `IsLock == false`(조회모드 아님)를 전제했다 — 규범 §2.4 로 모드가 사라졌으므로
    //   그 축은 `canEdit`(EDIT 권한) + 신규행 여부로 재표현한다(goal.md §8 "조회모드 전제 가드").
    const dblClickHandler = (event: MouseEvent) => {
      if (!canEditRef.current) return;
      const hit = grid.hitTest(event);
      if (hit.cellType !== CellType.Cell) return; // D09
      const binding = str(GridUtils.getBinding(grid, hit.col));
      const row = GridUtils.getRow(grid, hit.row) as Record<string, unknown> | undefined;
      if (!binding || !isInsertRow(row)) return; // D10
      if (!isPopupCell(tab, binding)) return;

      setClickedRow(hit.row);
      if (binding === COL.PROJECT_CODE) setOpenProjectModal(true);
      else setOpenItemModal(true);
    };
    grid.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.pastedCell?.removeHandler(pastedCellHandler);
        grid.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // `gridRef.current` 를 deps 에 둔다 — grid 인스턴스가 columns 변화 없이 재생성되면(리마운트 등)
    //   이 재지정이 따라 붙지 않아 공용 `setEditableColumns` 의 `INPUT_TP_CD='S'` 전면 차단만 남는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, gridRef.current]);

  /** 셀 값을 EditTracker 경유로 채운다(팝업 반환값 주입 G40/G41). */
  const setCellValue = (binding: string, value: string) => {
    const grid = gridRef.current;
    if (!grid || !value) return; // AS-IS 도 반환값이 공백이면 미대입(cs:2208·2225)
    const dataItem = GridUtils.getRow(grid, clickedRow) as Record<string, unknown> | undefined;
    if (!dataItem || !isInsertRow(dataItem)) return;
    editTrackerRef.current?.storeChange(
      dataItem as never,
      binding,
      dataItem[binding] as never,
      value
    );
    dataItem[binding] = value;
    GridUtils.refreshRow(grid, clickedRow);
  };

  const clickedItem = GridUtils.getRow(gridRef.current, clickedRow) as
    | Record<string, unknown>
    | undefined;

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={columns}
        sheetName={ADMIN_SHEET_NAME[tab]}
        comboParams={comboParams}
        gotFocus={onFocus}
        cellEditEnded={(grid, args) => {
          // ComboSelChange 등가(G45~G48) — 편집 종료 시 파생을 적용한다.
          const binding = str(GridUtils.getBinding(grid, args.col));
          if (binding) applyDerived(grid, args.row, binding);
        }}
      />

      {/* U06 Project 팝업 — 파라미터 원천은 **클릭한 행**의 division·scmSite·project (cs:2184~2211).
          AS-IS 가 실제로 넘기는 'ALL' 리터럴은 그대로 유지한다(임의 하드코딩이 아님, hook #130 §2 ③).
          AS-IS CellDoubleClick 은 시트 무관이라 PROJECT_CODE 보유 3탭(MKT FCST/STOCK/Stock(Elec))에서 뜬다. */}
      {EDITABLE_ON_INSERT_ROW[tab].includes(COL.PROJECT_CODE) && (
        <ProjectByDivisionModal
          open={openProjectModal}
          modalClose={() => setOpenProjectModal(false)}
          setSelectedValue={projects => setCellValue(COL.PROJECT_CODE, projects)}
          callFromCell
          preSearchParams={{
            divisionId: str(clickedItem?.[COL.DIVISION_ID]) || divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: str(clickedItem?.[COL.SCM_SITE_ID]),
            etc: '',
            projectCode: str(clickedItem?.[COL.PROJECT_CODE]),
          }}
        />
      )}

      {/* U07 Item(Model) 팝업 — AS-IS `SCM0002_ItembyDivisionPopup`(cs:2218)의 1:1 TO-BE 이식본은
          `ModelByDivisionPopup`(SP PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP, 메타 SCM0002/
          ModelPopup)이다. 공용 `ItemByDivisionModal`(COM0008 = AS-IS DM0002 이식본)은 SP·조회조건·컬럼이
          달라 재사용 금지 — 사용자 지적 2026-10-01 로 design 02 §4.6 매핑 오류를 정정했다. division
          원천은 조회조건이다(행 값 아님, cs:2215 `cboDivision.ControlValues`).
          AS-IS Form_Load(true, division, "", "", "") = scmSite/project/item 전부 빈값.
          AS-IS CellDoubleClick 은 시트 무관이라 ITEM_ID 보유 5탭 전부에서 뜬다. */}
      {EDITABLE_ON_INSERT_ROW[tab].includes(COL.ITEM_ID) && (
        <ModelByDivisionPopup
          open={openItemModal}
          onClose={() => setOpenItemModal(false)}
          onSelect={selected => setCellValue(COL.ITEM_ID, selected.itemId)}
          params={{
            divisionId,
            projectCode: '',
            scmSiteId: '',
            itemId: '',
          }}
        />
      )}
    </>
  );
};
