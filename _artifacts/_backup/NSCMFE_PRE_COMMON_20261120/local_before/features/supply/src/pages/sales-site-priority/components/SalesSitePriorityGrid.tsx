import { type CellRangeEventArgs, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { COMBO } from '../sales-site-priority.constants';
import type { SalesSitePriorityRow } from '../sales-site-priority.types';
import {
  findPlanGroupCodeByName,
  isPlanGroupCodeInCombo,
  toCascadeSource,
} from '../utils/sales-site-priority.cascadeCombo';
import { applyItemSelect, isCellEditable, isItemPopupCell, s } from '../utils/sales-site-priority.editLock';

interface Props {
  rows: SalesSitePriorityRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

// design 03 §1.1: 그리드 셀콤보 SQL_ID 리터럴 3종(PlanGroup/ScmSite/ValidYn)이 admin 메타
//   CELL_COMBO_DATA_TYPE 에 실려 있으면 공용 DataGrid 자동콤보 경로가 처리한다(§04 콤보_TO-BE.md §4).
//   OPMZ_PLAN_GR_ID(filterCalls#6)·SCM_SITE_ID 둘 다 division cascade PARAM2='DIVISION_ID:DIVISION_ID'
//   가 admin 메타(SCM_MST_SHEET_COLUMNS.ATTRIBUTE2)에 등록돼 있다(gap-resolve iter-1, ora.py 실측 확인).
export const SalesSitePriorityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const [openItem, setOpenItem] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  // Plan Group 붙여넣기 NAME->CODE 역변환용 원본(AS-IS dtPlanGroupAll, l1062). 조회조건과 별도로
  //   그리드 단독 fetch — 화면 전역 division 이 아니라 붙여넣기 대상 행의 DIVISION_ID 로 좁힌다.
  const [planGroupsRaw] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupSource = useMemo(() => toCascadeSource(planGroupsRaw), [planGroupsRaw]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 white-list — DIVISION_ID·감사4칸·PRE_KEY_VALUES 항상 잠금, ITEM_ID 는 인라인 입력 허용(AS-IS 동일).
    const beginningEditHandler = (
      sender: FlexGrid,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isCellEditable(binding)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // PRIO_RANK 는 1 이상의 정수만 허용 — 편집 중 숫자(0~9) 이외의 문자는 셀에 남지 않게 막는다(AS-IS 등가).
    //   AS-IS 메타는 PRIO_RANK 가 FPNumber/DATA_SCALE_NUMBER=NULL 이고, FarPoint NumberCellType 은
    //   DecimalPlaces 미지정 시 기본 0 이라 소수·문자 입력이 애초에 안 된다(asis.py 실측). TO-BE 공통
    //   columnMapping 은 scale==null 이면 편집기를 안 붙여 소수·텍스트가 입력되므로(구조적 갭) 이 화면에서 막는다.
    //
    //   구현 주의(2026-11-10 dom_listeners 실측): Wijmo 기본 그리드 에디터(input.wj-grid-editor, type=tel)는
    //   keydown/keypress 단계에서 값을 직접 editor.value 에 써넣어 beforeinput.preventDefault 와 host keydown
    //   capture 를 모두 우회한다(Wijmo core 가 같은 요소에 더 먼저 등록된 capture keydown 다수를 가진다).
    //   그래서 '선제 차단'은 이 에디터에서 신뢰할 수 없다 — 대신 값이 반영된 직후 input 이벤트에서 숫자 외
    //   문자를 즉시 제거하는 sanitize 를 주력으로 쓴다. 동기 제거라 렌더 전에 값이 정리돼 화면에 글자가 남지
    //   않는다. 붙여넣기·IME 조합확정(insertFromPaste/insertCompositionText)도 같은 input 경로라 함께 걸린다.
    //   붙여넣기 Plan Group 변환 등 다른 경로는 저장검증(Number.isInteger, MSG01190)이 막는 이중 안전망.
    const sanitizePrioInput = (ev: Event) => {
      const el = ev.target as HTMLInputElement;
      const cleaned = el.value.replace(/\D/g, '');
      if (cleaned === el.value) return;
      const caret = (el.selectionStart ?? el.value.length) - (el.value.length - cleaned.length);
      el.value = cleaned;
      const pos = Math.max(0, caret);
      el.setSelectionRange(pos, pos);
    };
    const prepareEditHandler = (_s: FlexGrid, e: CellRangeEventArgs) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      // Plan Group 편집 진입 시 숨긴 코드(비활성 Plan Group) 노출 차단 — AS-IS FarPoint 등가.
      //   AS-IS ComboBoxCellType 은 EditorValue=ItemData 라 저장값이 콤보 후보(ItemData)에 없으면
      //   매칭 인덱스가 없어 에디터가 미선택(빈) 상태로 열린다(SpreadInfo.LoadCombo l6046~6067).
      //   반면 Wijmo 는 편집 진입 시 셀 원문(dataItem.OPMZ_PLAN_GR_ID=숨긴 코드 PG0004 등)을
      //   에디터 input 에 그대로 채워 코드가 노출된다. formatItem 으로 가린 셀과 같은 판정
      //   (isPlanGroupCodeInCombo)으로, 미매칭이면 에디터 초기값을 비워 AS-IS 처럼 빈 상태로 연다.
      //   값 자체(dataItem)는 건드리지 않으므로 사용자가 다른 코드를 고르지 않으면 원 저장값이 유지된다.
      if (binding === 'OPMZ_PLAN_GR_ID') {
        const row = _s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
        const editor = _s.activeEditor;
        if (
          row &&
          editor &&
          !isPlanGroupCodeInCombo(planGroupSource, s(row.DIVISION_ID), s(row.OPMZ_PLAN_GR_ID))
        ) {
          editor.value = '';
        }
        return;
      }
      if (binding !== 'PRIO_RANK') return;
      const el = _s.activeEditor;
      if (!el) return;
      // 같은 editor input 이 재사용되며 같은 함수 참조라 브라우저가 중복 등록을 제거 — 리스너가 쌓이지 않는다.
      el.addEventListener('input', sanitizePrioInput);
    };
    g.prepareCellForEdit.addHandler(prepareEditHandler);

    // 붙여넣기 Plan Group 표시명(NAME) -> 코드(CODE) 변환(AS-IS SpdMain_ClipboardPasted l1050~1070,
    //   validations#10~#12/events#5 — 원본 확인 결과 붙여넣기 이벤트가 하는 일은 이 변환뿐이다.
    //   From/To 검증은 붙여넣기 경로에 없다, __asis-mapping__.md 갱신).
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const pastedName = s(row.OPMZ_PLAN_GR_ID);
      if (!pastedName) return;
      const matchedCode = findPlanGroupCodeByName(planGroupSource, s(row.DIVISION_ID), pastedName);
      if (matchedCode !== undefined) {
        row.OPMZ_PLAN_GR_ID = matchedCode;
        GridUtils.refreshRow(sender, e.row);
      }
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // Plan Group 셀 표시 등가(AS-IS FarPoint ComboBoxCellType) — 셀 저장값이 그 행 DIVISION_ID 로
    //   좁힌 활성 콤보 후보에 없으면 빈칸으로 그린다. DataMap.getDisplayValue 가 미매칭 코드를 원문
    //   그대로 돌려 비활성(VALID_YN='N') Plan Group 코드가 노출되는 것을 이 화면 한정으로 가린다
    //   (isPlanGroupCodeInCombo). 데이터(dataItem.OPMZ_PLAN_GR_ID)는 건드리지 않고 셀 텍스트만 비운다.
    //
    //   주의: 편집 진입(더블클릭 등) 시점에도 formatItem 이 같은 셀로 다시 불린다. 그때 cell DOM 을
    //   비우면 Wijmo 가 그 셀에 붙이는 콤보 에디터까지 날려 드롭다운이 안 열린다(회귀). editRange 가
    //   이 셀을 가리키면(=지금 편집 중) 표시를 건드리지 않고 에디터를 그대로 둔다 — AS-IS 도 빈칸 셀을
    //   클릭하면 콤보가 정상 펼쳐진다(SetComboDataRow, 저장값이 리스트에 없으면 미선택 상태로 열림).
    const formatItemHandler = (
      _s: FlexGrid,
      e: { panel: { cellType: CellType }; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel.cellType !== CellType.Cell) return;
      if (_s.columns[e.col]?.binding !== 'OPMZ_PLAN_GR_ID') return;
      if (_s.editRange?.contains(e.row, e.col)) return; // 편집 중 셀은 에디터 보존
      const row = _s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (!isPlanGroupCodeInCombo(planGroupSource, s(row.DIVISION_ID), s(row.OPMZ_PLAN_GR_ID))) {
        e.cell.textContent = '';
        e.cell.title = ''; // 셀 텍스트와 함께 코드가 툴팁(title)으로 새는 것도 막는다.
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // ITEM_ID 셀 더블클릭 -> MaterialByDivisionModal(design 02 §4.6, gridSignals#13).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupCell(binding)) return;
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.prepareCellForEdit?.removeHandler(prepareEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, planGroupSource]);

  return (
    <>
      <DataGrid<SalesSitePriorityRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={adminColumns ?? []}
        // SCM_SITE_ID 그리드 셀 콤보는 admin 메타 CELL_COMBO_DATA_TYPE='ScmSite'(AS-IS SCP0128 포팅,
        //   SALES+PLANT, DIVISION_ID 반환)를 쓰며 division 좁힘은 ATTRIBUTE2 PARAM2='DIVISION_ID:DIVISION_ID'
        //   cascade 가 행별 DIVISION_ID 로 처리한다. ScmSite 는 @siteType 를 받지 않으므로 이전 comboParams
        //   siteType='SALES' 는 무효 no-op(그리드가 SiteMasterAll_SCP 를 쓴다는 스테일 가정의 잔재)이라 제거.
        gotFocus={onFocus}
      />
      {/* 그리드 셀 Item 팝업 — MaterialByDivisionModal(COM0013), 조회영역과 동일 팝업 재사용(design 02 §4.6). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          const row = GridUtils.getRow(gridRef.current, clickedRow) as
            | Record<string, unknown>
            | undefined;
          if (!row) return;
          applyItemSelect(row, items);
          GridUtils.refreshRow(gridRef.current, clickedRow);
        }}
        preSearchParams={{
          divisionId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.DIVISION_ID
          ),
          itemId: '',
        }}
      />
    </>
  );
};
