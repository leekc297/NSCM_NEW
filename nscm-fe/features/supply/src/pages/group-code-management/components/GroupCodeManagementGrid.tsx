import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ALARM_MASS_COLUMN, GRID_SHEET_NAME, MENU_ID } from '../group-code-management.constants';
import type { GroupCodeRow } from '../group-code-management.types';
import {
  isCellEditable,
  isPicPopupCell,
  isRtfGubunCell,
  PIC_ID_COLUMN,
} from '../utils/group-code-management.editLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<GroupCodeRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<GroupCodeRow> | undefined>;
  data: GroupCodeRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  isEditMode: boolean;
  // PIC_ID 셀 더블클릭 -> 페이지가 UserInfoPopup 오픈(row 기억). 팝업/검증은 페이지 소유(§3-3).
  onPicCellDblClick: (row: GroupCodeRow) => void;
  // PIC_ID 셀 키인 종료 -> 페이지가 SCP0050 검증(미등록이면 셀 클리어+MSG00251). AS-IS SpdMain_Change→CheckUser.
  onPicCellEdited: (row: GroupCodeRow) => void;
  // GROUP_CODE5(82) 셀 더블클릭 -> 페이지가 RTFGubun 팝업 오픈(row 기억). AS-IS CommonDataSCPPopup(§3-3).
  onRtfCellDblClick: (row: GroupCodeRow) => void;
}

// 2단 헤더(상=대분류 그룹 / 하=컬럼 라벨) 중 아래(컬럼 라벨) 단 높이(px). 긴 라벨("Replacement code",
//   "GPLM Cell Conversion factor" 등)이 2줄로 감싸지며 잘리는 문제 → 아래 단만 2줄이 들어가게 높인다.
//   공통 DataGrid.headerRowHeight(=columnHeaders.rows.defaultSize)는 전역 조밀 행높이에 덮여 안 먹으므로
//   (실측 단 17px), 아래 bottom header row 의 .height 를 명시 설정해 강제한다(아래 updatedLayout 핸들러).
const BOTTOM_HEADER_ROW_HEIGHT = 34;

// Div/Operation/Model Type 식별 컬럼 세로 병합 대상 (사용자 요구 2026-10-12). CustomMergeManager 가
//   좌→우 누적키로 병합하므로 Div > Operation > Model Type 순 계층 span 이 된다(세 컬럼은 좌측 연속 10/20/30).
//   Model Type 바인딩은 division 별 상이(40=MODEL_TYPE_NAME_40, 81*=BIZ_TYPE — DB 실측)라 양쪽 다 포함.
const MERGE_BINDINGS = new Set<string>([
  'DIVISION_ID',
  'OPERATION_ID',
  'MODEL_TYPE_NAME_40',
  'BIZ_TYPE',
]);

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Wijmo 는 셀 DOM 을 재사용하므로 조건 미해당 시에도 항상 클래스/스타일을 해제한다(잔상 방지).
const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

// AS-IS SCP0080 spdMain(division 별 7 FpSpread -> TO-BE 단일 DataGrid + 동적 컬럼셋).
//   화면이 직접 담당(03_grid-columns.md §3):
//     (a) 편집토글 락 — beginningEdit/pastingCell. division 별 편집가능 컬럼만 unlock(§3-2 R-LOCK-*).
//     (b) AlarmByStatusMass 경고 — formatItem. STATUS_MASS='Y' + 대상셀 공백 시 노랑 배경(§3-4 R-ALARM-MASS).
//     (c) 셀 팝업 — PIC_ID 더블클릭 시 페이지로 라우팅(§3-3 R-POPUP-PIC, 편집모드 게이트 R-DBLCLICK-GATE).
//   셀 콤보 4종(ALL_Y_TYPE/ALL_V_TYPE/ESS_CATEGORY/SEQ_NUMBER)은 admin 메타 구동이라 DataGrid 자동 배선
//     (PARAM 배선 없는 정적 리스트 — §1 비고, 하드코딩 금지).
export const GroupCodeManagementGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  isEditMode,
  onPicCellDblClick,
  onPicCellEdited,
  onRtfCellDblClick,
}: Props) => {
  // 셀콤보 @토큰(@mnuId) 해소 — ALL_Y_TYPE 등 정적콤보도 메타 구동이다. 값은 인용(pre-quote).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 핸들러는 columns/상태 변경 시 재등록하되, 최신 상태는 ref 로 읽어 stale closure 방지.
  const editModeRef = useRef(isEditMode);
  editModeRef.current = isEditMode;
  const divisionRef = useRef(divisionId);
  divisionRef.current = divisionId;
  // 핸들러가 useEffect(1회 등록) 클로저에 갇히지 않게 최신 콜백을 ref 로 읽는다.
  const onPicCellEditedRef = useRef(onPicCellEdited);
  onPicCellEditedRef.current = onPicCellEdited;
  // PIC_ID 편집 시작값 — cellEditEnded 에서 실제 변경(키인)만 검증하기 위한 비교 기준(AS-IS 는 값변경에만 검증).
  const picEditStartRef = useRef('');

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const editableAt = (col: number): boolean =>
      isCellEditable({
        binding: g.columns[col]?.binding ?? '',
        divisionId: divisionRef.current,
        editMode: editModeRef.current,
      });

    // (b) AlarmByStatusMass 대상 컬럼 — 81 GROUP_CODE1 / 82 GROUP_CODE8. base/40 은 미적용.
    const alarmColumn =
      divisionRef.current === '82'
        ? ALARM_MASS_COLUMN.power
        : divisionRef.current.startsWith('81')
          ? ALARM_MASS_COLUMN.ess
          : '';

    // 편집가능 셀 배경 표시 + AlarmByStatusMass 경고 배경. 재사용 셀이라 미해당 시 반드시 원복.
    const formatItemHandler = (
      sender: FlexGridType<GroupCodeRow>,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      toggleClass(e.cell, 'wj-cell-editable', editableAt(e.col));

      if (alarmColumn && binding === alarmColumn) {
        const row = sender.rows[e.row]?.dataItem as GroupCodeRow | undefined;
        const warn = str(row?.STATUS_MASS) === 'Y' && str(row?.[alarmColumn]).trim() === '';
        // AS-IS SetColumnStyleByCondition(..., Color.Yellow) 와 동일한 순정 노랑(#FFFF00). 옅은 앰버는
        //   흰/alt 행 배경에 묻혀 사실상 안 보였음(사용자 피드백 2026-10-12).
        e.cell.style.backgroundColor = warn ? '#ffff00' : '';
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // (a) 편집 진입 게이트 — 공용 DataGrid 의 메타 판정 뒤 화면이 최종 재지정(양방향).
    //   division 별 편집가능 컬럼만 열고 나머지는 락(조회모드는 전 셀 락).
    const beginningEditHandler = (
      sender: FlexGridType<GroupCodeRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editableAt(e.col)) {
        e.cancel = true;
        return;
      }
      // PIC_ID 편집 시작값 기억 — cellEditEnded 에서 실제 변경 여부 판정에 쓴다.
      if ((sender.columns[e.col]?.binding ?? '') === PIC_ID_COLUMN) {
        picEditStartRef.current = String(sender.getCellData(e.row, e.col, false) ?? '');
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // (a) 붙여넣기도 같은 게이트 — 락 셀에 값이 들어가면 안 된다.
    const pastingCellHandler = (
      sender: FlexGridType<GroupCodeRow>,
      e: { cancel: boolean; col: number }
    ) => {
      if (!editableAt(e.col)) e.cancel = true;
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // R-KEYBLOCK — AS-IS IsESSEdit + spdMain_KeyPress(cs:1493/1725): 82 division 의 GROUP_CODE5 는
    //   편집모드에서 사용자 키인을 막고 RTFGubun 팝업 입력만 허용한다. ESC 만 통과(편집 취소).
    //   capture 단계에서 문자/편집시작 키를 차단한다(Ctrl/Meta/Alt 조합은 복사·붙여넣기 등이라 통과).
    const keyDownBlockHandler = (ev: KeyboardEvent) => {
      if (!editModeRef.current || divisionRef.current !== '82') return;
      const sel = g.selection;
      if (!sel || sel.col < 0) return;
      const binding = g.columns[sel.col]?.binding ?? '';
      if (!isRtfGubunCell(binding, divisionRef.current)) return;
      if (ev.key === 'Escape' || ev.ctrlKey || ev.metaKey || ev.altKey) return;
      // 편집을 여는 키(문자 1글자 / F2 / Enter / Space / Backspace / Delete)는 전부 차단.
      ev.preventDefault();
      ev.stopPropagation();
    };
    g.hostElement.addEventListener('keydown', keyDownBlockHandler, true);

    // PIC_ID 키인 종료 -> 페이지가 SCP0050(CAPA PIC = SSP planner 등록) 검증. AS-IS SpdMain_Change→CheckUser
    //   (cs:1400/1409): 미등록 USER_ID 면 PIC_ID·PIC_NAME 셀 클리어 + MSG00251. 팝업 경로는 handleUserSelected.
    const cellEditEndedHandler = (
      sender: FlexGridType<GroupCodeRow>,
      e: { row: number; col: number }
    ) => {
      if ((sender.columns[e.col]?.binding ?? '') !== PIC_ID_COLUMN) return;
      const row = sender.rows[e.row]?.dataItem as GroupCodeRow | undefined;
      if (!row) return;
      // 값 변경이 없으면(더블클릭으로 팝업만 연 경우 등) 검증 스킵 — AS-IS 는 값 변경 시에만 CheckUser.
      if (str((row as Record<string, unknown>)[PIC_ID_COLUMN]) === picEditStartRef.current) return;
      onPicCellEditedRef.current(row);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // 붙여넣기(paste)는 cellEditEnded 를 타지 않으므로 별도 검증 — AS-IS SpdMain_Change 는 붙여넣기
    //   값변경에도 발화한다(cs:1400). pastedCell(붙여넣기 후)에서 PIC_ID 면 동일 검증을 돌린다
    //   (붙여넣기는 값 변경이 전제라 change-detection 불필요).
    const pastedCellHandler = (
      sender: FlexGridType<GroupCodeRow>,
      e: { row: number; col: number }
    ) => {
      if ((sender.columns[e.col]?.binding ?? '') !== PIC_ID_COLUMN) return;
      const row = sender.rows[e.row]?.dataItem as GroupCodeRow | undefined;
      if (row) onPicCellEditedRef.current(row);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // 2단 헤더 아래(컬럼 라벨) 단 높이 강제 — 긴 라벨이 2줄로 감싸지며 잘리는 문제. 전역 조밀 행높이가
    //   columnHeaders.rows.defaultSize 를 덮어 공통 headerRowHeight(=defaultSize)는 안 먹으므로(실측 17px),
    //   bottom header row 의 .height 를 명시 설정한다. columnGroups 재적용(updatedLayout)마다 리셋되므로
    //   매 layout 갱신에 재적용하고, 이미 목표 높이면 skip(무한 refresh 방지).
    const applyBottomHeaderHeight = () => {
      const hr = g.columnHeaders?.rows;
      if (!hr || hr.length === 0) return;
      const last = hr.length - 1;
      if (Math.round(hr[last]?.height ?? Number.NaN) !== BOTTOM_HEADER_ROW_HEIGHT) {
        hr[last].height = BOTTOM_HEADER_ROW_HEIGHT;
      }
    };
    g.updatedLayout.addHandler(applyBottomHeaderHeight);
    applyBottomHeaderHeight();

    // Div/Operation/Model Type 세로 병합 — 대상 컬럼에 allowMerging=true 를 부여(grid.allowMerging=All 과 함께
    //   CustomMergeManager 가 좌누적키 계층병합 수행). 컬럼 재구성(updatedLayout)마다 재적용(division 전환 대응).
    const applyCellMerge = () => {
      g.columns.forEach(col => {
        if (MERGE_BINDINGS.has(col.binding ?? '')) col.allowMerging = true;
      });
    };
    g.updatedLayout.addHandler(applyCellMerge);
    applyCellMerge();

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.updatedLayout?.removeHandler(applyBottomHeaderHeight);
        g.updatedLayout?.removeHandler(applyCellMerge);
        g.hostElement?.removeEventListener('keydown', keyDownBlockHandler, true);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, divisionId, isEditMode]);

  // (c) 셀 더블클릭 -> 페이지로 라우팅(편집모드 게이트, §3-3 R-DBLCLICK-GATE).
  //   PIC_ID(공통 UserInfoPopup) / GROUP_CODE5+82(RTFGubun CommonDataSCPPopup). AS-IS spdMain_CellDoubleClick.
  const handleDblClick = (event: MouseEvent) => {
    const g = gridRef.current;
    if (!g || !isEditMode) return;
    const ht = g.hitTest(event);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    const row = GridUtils.getRow(g, ht.row) as GroupCodeRow | undefined;
    if (!row) return;
    if (isPicPopupCell(binding)) {
      onPicCellDblClick(row);
    } else if (isRtfGubunCell(binding, divisionId)) {
      onRtfCellDblClick(row);
    }
  };

  return (
    <DataGrid<GroupCodeRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={!isEditMode}
      itemsSource={data}
      staticColumns={staticColumns}
      comboParams={comboParams}
      // Div/Operation/Model Type 세로 병합 활성 — All 은 2단 헤더 병합(기본 ColumnHeaders) 유지 + 셀 병합 추가.
      //   실제 병합 컬럼은 위 useEffect 가 col.allowMerging 으로 한정(MERGE_BINDINGS).
      allowMerging={AllowMerging.All}
      sheetName={GRID_SHEET_NAME}
      excelFileName='GroupCodeManagement'
      dblClick={handleDblClick}
    />
  );
};
