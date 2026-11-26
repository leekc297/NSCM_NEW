import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import {
  CustomMergeManager,
  GridUtils,
  paintNegativeText,
  toGridNumber,
} from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, MSG } from '../shipment-plan.constants';
import type { CalendarRow, MainRow, NoteRow } from '../shipment-plan.types';
import { useShipmentPlanStore } from '../useShipmentPlanStore';
import { calcPlanQty, type CalcRow } from '../utils/shipment-plan.calc';
import { createSameCellDblClickGuard } from '../utils/shipment-plan.dblClickGuard';
import { isMainCellEditable } from '../utils/shipment-plan.editLock';
import { LOOKUP_COLUMN, stripComboMeta, useShipmentPlanLookups } from '../utils/shipment-plan.lookups';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  // NOTE 행(Main o_rc2) — SHIP_PLAN_DETAIL 일자셀 파란 StickyNote(■) 원천. AS-IS dtNote(ds.Tables[1]) 등가.
  notes: NoteRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // Main 편집 가능 여부 = canEdit(hasButton('EDIT'))·최신Plan(realFlag). 셀 단위 범위는 isMainCellEditable.
  //   AS-IS EditButton 토글 미이식(convert-core §2.4) — 편집 기본 ON, 권한은 마운트 1회 판정.
  editable: boolean;
  curPlanDate: string;
  // I15 — 저장 시 음수로 판정된 일자셀(행객체 -> 컬럼 binding 집합). AS-IS SaveData_Main 의
  //   `SetBGColor(i, j, i, j, ControlColor.InvalidColor)`(cs L2992) 재현용.
  //   행 식별을 인덱스가 아니라 **행 객체 참조**로 하는 이유: 정렬·필터가 걸리면 AS-IS 의 (i, j)
  //   좌표와 달리 TO-BE 행 인덱스는 흔들린다(cs L3543 주석이 지적하는 바로 그 문제).
  negativeCells: ReadonlyMap<object, ReadonlySet<string>>;
  // Main 셀/BOH_QTY 더블클릭 드릴다운 (03 §3-D) — 페이지가 sheet 전환 + Detail 재조회
  onDrilldown: (row: MainRow, binding: string) => void;
  // 활성 그리드 sticky 전환용 (01 R5 — Main 클릭 시 복귀 핸들러는 배선하지 않는다)
  onCellEdited?: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_') ? 'D' : binding.startsWith('W_') ? 'W' : binding.startsWith('M_') ? 'M' : undefined;

// 파란 StickyNote(■) 매칭 키 — AS-IS SetNote_Display(cs L7069~7077) dtNote LINQ 의 8컬럼 조인과 동일 순서.
//   일자(YYYYMMDD)는 양변 숫자만 남겨 비교(AS-IS 는 note 쪽 YYYYMMDD 를 .Replace("-","") 후 대조).
const noteKey = (...parts: string[]): string => parts.join('|');

// Main o_rc2 note 행 1건 — 툴팁 텍스트 + 하한 가드 수량. AS-IS EditByChange(cs L2118~2119)가 같은
//   행에서 QTY(원 확정수량)·NOEDIT_QTY(DO 발행분 = 입력 하한)를 읽어 하한 가드(MSG00425)에 쓴다.
interface DoNoteEntry {
  note: string; // 'Input Qty(Min) : N' — ■ 호버 툴팁
  qty: number; // 원 확정수량 — 하한 위반 시 되돌릴 값(AS-IS L2124 SetValue(dQty))
  noEditQty: number; // 입력 하한 = DO 발행(입력불가) 수량
}

// SHIP_PLAN_DETAIL D_ 셀의 note 매칭 키 — 대상 셀이 아니면 null. ■ 표시(applyDoNote)와
//   하한 가드(recalcCell·Delete키)가 같은 키를 쓴다.
const noteKeyOf = (
  row: Record<string, unknown> | undefined,
  binding: string
): string | null => {
  if (!row || !binding.startsWith('D_')) return null;
  if (str(row.MEASURE) !== 'SHIP_PLAN_DETAIL' || str(row.TO_SITE).trim() === '') return null;
  return noteKey(
    str(row.DIVISION_ID),
    str(row.FROM_SITE),
    str(row.ITEM_ID),
    str(row.TO_SITE),
    str(row.TRANSPORT_MODE),
    str(row.INCOTERMS),
    str(row.FCST_TYPE),
    binding.slice(2).replace(/\D/g, '')
  );
};

const DO_NOTE_DOT_CLASS = 'ssp0060-do-note-dot';

// AS-IS SetNote_Display(cs L7056~7095): SHIP_PLAN_DETAIL measure 행의 D_ 일자셀 중 dtNote(=o_rc2) 키 매칭이
//   있으면 셀 우상단에 파란 5×5 인디케이터(NoteIndicatorColor=Blue, Size(5,5)) + 마우스오버 NOTE 말풍선(StickyNote).
//   NOTE = 'Input Qty(Min) : …' = DO 발행(입력불가) 수량 참고. AS-IS 는 EDIT_YN 숫자셀만 호출하나 TO-BE 는
//   EDIT_YN 컬럼 부재(gap-audit G15) — 키 매칭(값이 있는 셀)으로 등가 재현. 셀 DOM 재사용이라 비대상은 원복.
//   title 은 공용 setCellTooltip(dataGridUtils)이 먼저 셀 값으로 설정한다 — 노트 셀만 그 위에 NOTE 로 덮고,
//   비노트 셀은 공용 title(전체 값 툴팁)을 보존해야 하므로 건드리지 않고 ■(dot)만 제거한다.
const applyDoNote = (
  cell: HTMLElement,
  row: Record<string, unknown> | undefined,
  binding: string,
  noteMap: ReadonlyMap<string, DoNoteEntry>
): void => {
  const key = noteKeyOf(row, binding);
  const note = (key ? noteMap.get(key)?.note : '') ?? '';
  const existing = cell.querySelector<HTMLElement>(`.${DO_NOTE_DOT_CLASS}`);
  if (note) {
    cell.title = note; // 공용이 설정한 셀 값 툴팁 위에 NOTE(DO 발행 수량)로 덮는다.
    if (!existing) {
      const dot = document.createElement('span');
      dot.className = DO_NOTE_DOT_CLASS;
      // 우상단 파란 5×5 사각 — pointer-events 차단으로 클릭/편집 진입에 간섭하지 않는다.
      dot.style.cssText =
        'position:absolute;top:0;right:0;width:5px;height:5px;background:#0000ff;pointer-events:none;';
      cell.appendChild(dot);
    }
  } else {
    // 파란점(DO 발행)이 없는 셀에는 호버(툴팁)도 뜨지 않게 한다 — 사용자 지시(2026-10-22):
    //   호버는 "이 셀에 이미 발행돼 취소할 수 없는 DO 수량(= 입력 최소)이 있다"는 신호여야 하므로,
    //   DO 발행건이 포함된 파란점 셀에서만 떠야 한다. 공용 setCellTooltip 이 전 셀에 건 값 툴팁을
    //   나중 등록된 이 핸들러가 비노트 셀에서 비운다(cell 은 매 formatItem 마다 공용이 title 을 다시
    //   세팅하므로 재사용 잔상 없음). ■ 도 함께 제거.
    cell.title = '';
    existing?.remove();
  }
};

// 3단(월>주/SUM>일) 동적 헤더의 행 높이 — GRID-11: nested columns 에 height 를 안 적으면 Wijmo 기본
//   48px 이 단마다 적용돼 헤더가 48×3=144px 로 부풀고(AS-IS FarPoint 는 20px×3≈60px), base 컬럼의
//   세로 span 도 그 높이에 끌려간다(사용자 신고 2026-10-06 "ASIS 랑 Grid1 Header 크기가 다르다").
//   공용 컬럼매핑의 depth 별 높이(ONE 48 / TWO 24 / THREE 16)와 같은 값을 동적 group·leaf 에 명시해
//   총 48px(= 정적 ONE_DEPTH 1행 높이)로 맞춘다 — hook #93 표준.
const DYN_HEADER_ROW_HEIGHT = 18; // 16→18: 3단 헤더가 너무 좁아 상향(사용자 지시 2026-10-15, SSP0005 동일)

// Main 헤더 총높이(px) — 공용 1단 표준(HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH)과 같은 값.
//   정적 18컬럼이 ONE_DEPTH 라 공용 매핑이 거기에 height:48 을 박고, 그 명시값이 동적 3단의
//   height:16 과 `rows.defaultSize` 를 모두 이긴다 → 조회 후 헤더가 48×3 으로 벌어진다
//   (사용자 신고 2026-10-06 "1번 그리드는 헤더가 그대로고 계속 48 크기"). 선례
//   CustFcstWaterfallGrid(L349~378)처럼 실제 렌더된 tier 수로 나눠 헤더 row 높이를 직접 강제한다.
const MAIN_HEADER_HEIGHT = 54; // 48→54(18px/tier): 3단 헤더 가독성 상향(사용자 지시 2026-10-15, SSP0005 동일)

// 편집 가능 셀 배경(AS-IS SwitchLock 해제 셀의 노란 배경)은 공용 wj-cell-editable 클래스(#fff8cd =
//   $wj-editable-cell)로 통일한다 — Detail 그리드(gap-audit J5)와 동일. formatItem 에서 실제
//   편집게이트(isMainCellEditable) 기준으로 클래스를 토글한다(화면 전용 색 상수 미사용).

// 음수 입력 셀 배경 (I15) — AS-IS `ControlColor.InvalidColor` 실측값.
//   GSCM/01.Framework/GSCM.Windows.Forms/Class/ControlColor.cs:55
//     private static Color m_InValidColor = Color.FromArgb(92, 209, 229);
//   즉 빨강이 아니라 시안계(#5CD1E5)다 — 이름만 보고 빨강으로 칠하면 AS-IS 와 달라진다.
const INVALID_CELL_COLOR = '#5CD1E5';

// AS-IS Re_Design(cs L5440~5570) measure 행 배경색 — 행 유형(MEASURE)을 색으로 구분한다(design 03 §3-I).
//   값은 FarPoint Color.FromArgb 실측. α 가 붙은 두 색은 ARGB 의 A=80(=80/255≈0.314) 반투명이다.
//   Rb SHIP_PLAN·TOT_SHIP_PLAN      → MEASURE_NAME~끝 불투명 #A7D5FF (167,213,255)         cs L5515
//   Rc SHIP_PLAN_DETAIL·SHIP_RESULT → TO_SITE~끝 LightSkyBlue α80 (135,206,250,.314)       cs L5521
//   Rd 위 3종 외 measure            → 과거 일자(D_ < planDate) 셀 #A9A9A9 (169,169,169)     cs L5554
//   Re TOT 8종                      → MEASURE_NAME~끝 Yellow α80 (255,255,0,.314)           cs L5569
const MEASURE_BG = {
  PLAN: 'rgb(167, 213, 255)',
  PLAN_DETAIL: 'rgba(135, 206, 250, 0.314)',
  PAST: 'rgb(169, 169, 169)',
  TOT: 'rgba(255, 255, 0, 0.314)',
} as const;

// Re(노랑) 대상 TOT 8종 — AS-IS cs L5565~5566 그대로. TOT_SHIP_PLAN 은 제외다(Rb 파랑 대상).
const RE_TOT_MEASURES: ReadonlySet<string> = new Set([
  'TOT_SHIP_REQ',
  'TOT_SHIP_AVAL',
  'TOT_SHIP_AVAL_GAP',
  'TOT_INTN_MOVEMENT',
  'TOT_CONTAINER',
  'TOT_PROD_PLAN',
  'TOT_WH_STOCK',
  'TOT_BALANCE',
]);

/**
 * AS-IS Re_Design(cs L5512~5570) 의 measure 행 배경색을 셀 1개 기준으로 재현한다.
 *   AS-IS 는 한 행을 순회하며 Rb→Rc→Rd→Re 순으로 BackColor 를 덮어쓰므로(뒤가 이김) 같은 순서로
 *   평가해 마지막 값을 돌려준다. 색이 없으면 '' (기본 흰 배경 — DOM 재사용 잔상 방지용 명시 비우기).
 *   편집 가능 셀(노랑, wj-cell-editable)은 호출부에서 제외한다 — AS-IS 도 편집셀은 별도 색이다.
 */
const measureRowBackground = (
  measure: string,
  col: number,
  measureNameCol: number,
  toSiteCol: number,
  binding: string,
  planDate: string
): string => {
  let bg = '';
  // Rb — SHIP_PLAN·TOT_SHIP_PLAN: MEASURE_NAME~끝 불투명 파랑
  if (
    (measure === 'SHIP_PLAN' || measure === 'TOT_SHIP_PLAN') &&
    measureNameCol >= 0 &&
    col >= measureNameCol
  )
    bg = MEASURE_BG.PLAN;
  // Rc — SHIP_PLAN_DETAIL·SHIP_RESULT: TO_SITE~끝 반투명 하늘색
  if (
    (measure === 'SHIP_PLAN_DETAIL' || measure === 'SHIP_RESULT') &&
    toSiteCol >= 0 &&
    col >= toSiteCol
  )
    bg = MEASURE_BG.PLAN_DETAIL;
  // Rd — 위 3종 외 measure 의 과거 일자(D_ < planDate) 셀: 진한 회색
  if (
    measure !== 'SHIP_PLAN' &&
    measure !== 'SHIP_PLAN_DETAIL' &&
    measure !== 'SHIP_RESULT' &&
    binding.startsWith('D_') &&
    planDate &&
    binding.slice(2) < planDate
  )
    bg = MEASURE_BG.PAST;
  // Re — TOT 8종: MEASURE_NAME~끝 반투명 노랑(Rd 회색을 덮는다 — AS-IS 는 Re 가 뒤 순서)
  if (RE_TOT_MEASURES.has(measure) && measureNameCol >= 0 && col >= measureNameCol)
    bg = MEASURE_BG.TOT;
  return bg;
};

// 확정구간 배경 (AS-IS Re_Design cs L5468~5478 "확정일자 구분 처리") — CONFIRM_DAY 가 있는 행의
//   startIdx(FCST_TYPE+1)~CONFIRM_DAY 컬럼 구간을 행별 BACK_COLOR 로 칠한다. BACK_COLOR 는 서버가
//   내리는 "r,g,b" 문자열 = SCM_MST_SHEET_MEASURE.ATTRIBUTE3(PKG_SSP0060 L3891 `C.ATTRIBUTE3 AS
//   BACK_COLOR`, DB 실측 전 measure 242,242,242 = 옅은 회색 #F2F2F2).
//   AS-IS 는 이 색을 Re_Design 맨 앞(L5468)에 깔고 뒤의 measure 색(Rb/Rc/Rd/Re)이 덮으므로, 결국
//   **measure 색이 없는 행**(SHIP_REQ·SHIP_AVAL·CONTAINER·WH_STOCK 등 비특수·비TOT)의 확정구간
//   일자셀에만 보인다. 그래서 호출부는 measureRowBackground()=='' 일 때만 이 값을 쓴다
//   (사용자 지시 2026-10-21 "배경색 없는 셀에만, AS-IS 그대로"). 과거(< planStart)는 Rd 회색이
//   이미 선점(bg != '')하므로 여기 닿지 않는다 — 상한(CONFIRM_DAY)만 본다.
const parseRgb = (raw: string): string => {
  const p = raw.split(',').map(s => s.trim());
  if (p.length !== 3 || p.some(v => v === '' || Number.isNaN(Number(v)))) return '';
  return `rgb(${Number(p[0])}, ${Number(p[1])}, ${Number(p[2])})`;
};

const confirmWindowBackground = (
  row: Record<string, unknown> | undefined,
  binding: string
): string => {
  if (!row || !binding.startsWith('D_')) return '';
  const confirmDay = str(row.CONFIRM_DAY).trim();
  if (!confirmDay || binding.slice(2) > confirmDay) return '';
  return parseRgb(str(row.BACK_COLOR).trim());
};

// AS-IS MergePolicy.Always 컬럼 (cs L651~656) — 좌측 컬럼과 무관하게 같은 값이면 세로 병합한다.
//   나머지 base 컬럼은 FPMerge.Restricted(= 공용 CustomMergeManager 의 좌측 누적키)와 같다.
const ALWAYS_MERGE_BINDINGS: ReadonlySet<string> = new Set([
  'PSI',
  'MEASURE_NAME',
  'TO_SITE',
  'TRANSPORT_MODE',
  'INCOTERMS',
  'FCST_TYPE',
]);

// Main 병합 매니저 — 공용 CustomMergeManager 는 전 컬럼을 좌측 누적키(Restricted)로만 병합해,
//   AS-IS 가 MergePolicy.Always 로 잡아 둔 6컬럼이 상위 컬럼(Model/From Site 등) 차이로 갈라진다
//   (사용자 신고 2026-10-06 "1번 그리드에 셀 병합도 덜 되어 있어"). 그 6컬럼만 값 기준으로
//   병합하고 나머지는 공용 동작에 그대로 위임한다. 빈 셀·신규행(CRUD_TYPE='I') 제외는 공용 규칙 유지.
class ShipmentPlanMainMergeManager extends CustomMergeManager {
  constructor(grid: FlexGridType) {
    super(grid as never);
  }

  override getMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    const binding = panel.columns[currentCol]?.binding ?? '';
    if (
      panel.cellType !== CellType.Cell ||
      !ALWAYS_MERGE_BINDINGS.has(binding) ||
      !panel.columns[currentCol]?.allowMerging ||
      currentRow < 0 ||
      currentRow >= panel.rows.length
    ) {
      return super.getMergedRange(panel, currentRow, currentCol);
    }

    const cellAt = (row: number): WijmoPrimitive =>
      panel.getCellData(row, currentCol, false) as WijmoPrimitive;
    const value = cellAt(currentRow);
    if (value === null || value === undefined || (typeof value === 'string' && value.trim() === ''))
      return null;

    const isInsert = (row: number): boolean =>
      (panel.rows[row]?.dataItem as Record<string, unknown> | undefined)?.CRUD_TYPE ===
      CRUD_TYPE.INSERT;
    if (isInsert(currentRow)) return null;

    // 공용 구현과 동일하게 현재 뷰포트 안에서만 확장한다(전 행 스캔은 셀마다 O(n) 이라 렌더가 늦다).
    const minRow = panel.viewRange.row;
    const maxRow = Math.min(panel.viewRange.row2, panel.rows.length - 1);
    const rng = new CellRange(currentRow, currentCol);
    while (rng.row > minRow) {
      const r = rng.row - 1;
      if (cellAt(r) !== value || isInsert(r)) break;
      rng.row--;
    }
    while (rng.row2 < maxRow) {
      const r = rng.row2 + 1;
      if (cellAt(r) !== value || isInsert(r)) break;
      rng.row2++;
    }
    return rng.isSingleCell ? null : rng;
  }
}

// Bucket/chkSum 표시규칙 (design 03 §2.3 표 그대로)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M'; // Monthly — M_ 항상, D_/W_ 숨김(chkSum 무관)
};

// Main(PSI) 그리드 — base 18컬럼(admin 메타) + D_/W_/M_ 동적(서버 wide pivot + calendar 3단 헤더).
//   편집 표면은 동적 D_ 셀만(SHIP_PLAN_DETAIL 행 + 확정구간 curPlanDate~CONFIRM_DAY 일자 — AS-IS 그대로,
//   사용자 결정 2026-10-21. 판정·근거는 utils/shipment-plan.editLock.ts isMainCellEditable).
//   W_/M_(Sum) 컬럼은 항상 잠금(03 §2.3). 병합 = base 전 컬럼(AS-IS 메타 구동 FPMerge.Restricted,
//   framework SpreadInfo.cs:1295 + SmartColMerge) + Always 6컬럼(L651~656)은 그 부분집합 — 동적
//   D_/W_/M_ 만 병합 제외(FPMerge.None 재현, gap-audit I4).
export const ShipmentPlanMainGrid = ({
  rows,
  calendar,
  notes,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  chkSum,
  editable,
  curPlanDate,
  negativeCells,
  onDrilldown,
  onCellEdited,
}: Props) => {
  // FCST_TYPE 은 화면이 formatItem 으로 code->name 표시하므로 자동 콤보 메타를 벗긴다(빈 dataMap 충돌 방지).
  const columns = useMemo(
    () => stripComboMeta(adminColumns, new Set([LOOKUP_COLUMN.FCST_TYPE])),
    [adminColumns]
  );

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback (forecast-price 패턴)
  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!kindOf(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => ({
          binding: str(r.COLUMN_NAME),
          kind: kindOf(str(r.COLUMN_NAME)) as DynKind,
          large: str(r.LARGE_CLASS_LABEL_NAME),
          small: str(r.SMALL_CLASS_LABEL_NAME),
          leaf: str(r.COLUMN_LABEL_NAME),
          dayCode: str(r.DAY_CODE),
          sort: str(r.SORT_ORDER_NO),
        }))
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (kindOf(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => ({
      binding: b,
      kind: kindOf(b) as DynKind,
      large: b.slice(2, 8),
      small: '',
      leaf: b.slice(8),
      dayCode: '',
      sort: b,
    }));
  }, [calendar, rows]);

  // D_ 일자 binding 오름차순 — CalcPlanQty 전파/저장 diff 의 축
  const dayBindings = useMemo(
    () => dynColMetas.filter(m => m.kind === 'D').map(m => m.binding).sort(),
    [dynColMetas]
  );
  const dayBindingsRef = useRef(dayBindings);
  dayBindingsRef.current = dayBindings;

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (03 §2.2)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      const code = meta.dayCode.toUpperCase();
      if (meta.kind !== 'D') return;
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일 — forecast-price dynamicColumns 패턴 축약)
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2 };
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf || 'SUM' : 'SUM',
        align: 'right',
        width: 80,
        height: DYN_HEADER_ROW_HEIGHT,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSum),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
    const leafKind = (b: string): DynKind => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: DYN_HEADER_ROW_HEIGHT,
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: DYN_HEADER_ROW_HEIGHT,
            allowSorting: false,
            allowMerging: false,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas, bucketType, chkSum]);

  // 활성 그리드 전환 — 프레임워크 parity(BaseForm.FpSpread_CellClick 무조건 전환) 배선용
  const setActiveGrid = useShipmentPlanStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;

  // FCST_TYPE 셀 code->name 표시(SALES_TYPE_CODE lookup) — 자동 콤보가 @lookupType 을 못 실어 코드 노출되던 것.
  const { fcstTypeMap } = useShipmentPlanLookups();
  const fcstTypeMapRef = useRef(fcstTypeMap);
  fcstTypeMapRef.current = fcstTypeMap;

  // DO 하한 가드(MSG00666) 경고용 — formatItem/핸들러는 deps 재등록이 드물어 ref 로 읽는다.
  const { t } = useTranslation();
  const tRef = useRef(t);
  tRef.current = t;
  const setAlertRef = useRef(useMessageStore.getState().setAlert);
  setAlertRef.current = useMessageStore.getState().setAlert;

  const editableRef = useRef(editable);
  editableRef.current = editable;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const rowsRef = useRef(rows);
  rowsRef.current = rows;
  // formatItem 핸들러는 deps 가 바뀔 때만 재등록되므로, 매 렌더 갱신되는 값은 ref 로 읽는다.
  const negativeCellsRef = useRef(negativeCells);
  negativeCellsRef.current = negativeCells;
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;
  const onCellEditedRef = useRef(onCellEdited);
  onCellEditedRef.current = onCellEdited;

  // NOTE(파란 StickyNote) 조회 Map — 키 8컬럼 + 일자(YYYYMMDD 숫자) → NOTE. AS-IS SetNote_Display dtNote LINQ 등가.
  //   필수 게이트: NOEDIT_QTY > 0 인 셀만 — o_rc2 는 QTY>0 인 모든 (키,일자)에 NOTE('Input Qty(Min) : 0' 포함)를
  //   돌려주므로, 텍스트 존재만으로 찍으면 Plan 셀 전부에 점이 생긴다(2026-10-21 신고). AS-IS 는 EDIT_YN_<날짜>가
  //   숫자인 셀(= DO 발행/확정으로 '입력 최소'가 실재하는 셀)만 SetNote_Display 를 호출하는데, TO-BE wide 커서엔
  //   EDIT_YN 페어 컬럼이 없다(gap-audit G15). 그 게이트의 등가 = NOEDIT_QTY(입력불가/DO 발행 수량) > 0 이다.
  const noteMap = useMemo(() => {
    const m = new Map<string, DoNoteEntry>();
    notes.forEach(n => {
      const rec = n as Record<string, unknown>;
      const noEditQty = Number(rec.NOEDIT_QTY);
      if (!(noEditQty > 0)) return;
      const text = str(rec.NOTE);
      if (!text) return;
      m.set(
        noteKey(
          str(rec.DIVISION_ID),
          str(rec.FROM_SITE),
          str(rec.ITEM_ID),
          str(rec.TO_SITE),
          str(rec.TRANSPORT_MODE),
          str(rec.INCOTERMS),
          str(rec.FCST_TYPE),
          str(rec.YYYYMMDD).replace(/\D/g, '')
        ),
        { note: text, qty: Number(rec.QTY) || 0, noEditQty }
      );
    });
    return m;
  }, [notes]);
  const noteMapRef = useRef(noteMap);
  noteMapRef.current = noteMap;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 더블클릭 판정기 — 수명이 아래 click/dblclick 리스너와 같아야 하므로 effect 안에서 만든다.
    const dblClickGuard = createSameCellDblClickGuard();

    // 셀 병합 — base 전 컬럼 허용(FPMerge.Restricted 등가, I4) / 동적 D_/W_/M_ 만 제외(FPMerge.None).
    //   wrapper 는 allowMerging prop 이 켜지면 전 컬럼 true 를 씌우므로 동적 컬럼만 도로 false.
    //   주의: 이 플래그는 **셀** 병합만 가른다 — 헤더 병합은 그리드 레벨 allowMerging(=All)이 결정하고
    //   컬럼별 플래그를 보지 않는다(CustomMergeManager._getColumnHeaderMergedRange).
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !kindOf(binding);
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    // AS-IS MergePolicy.Always 6컬럼(cs L651~656) 재현 — 공용 매니저는 좌측 누적키 전용이라
    //   그 6컬럼이 상위 컬럼 차이로 갈라진다. 그리드 인스턴스당 1회만 교체(생성자가 grid 이벤트를
    //   구독하므로 effect 재실행마다 새로 만들지 않는다 — RequestPlantPanel 선례).
    if (!(g.mergeManager instanceof ShipmentPlanMainMergeManager)) {
      g.mergeManager = new ShipmentPlanMainMergeManager(g);
    }

    // 헤더 총높이 고정 — 정적 ONE_DEPTH 의 명시 height(48)가 동적 16 과 defaultSize 를 모두 이겨
    //   조회 후 48×3 으로 벌어지는 것을 실제 tier 수로 나눠 되돌린다(선례 CustFcstWaterfallGrid).
    //   목표값과 같으면 skip → updatedLayout 무한 루프 방지.
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = MAIN_HEADER_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    // 편집 잠금 — beginningEdit(e.cancel) + formatItem(편집가능 Yellow, hook #95)
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      // 헤더 토/일 색 (03 §2.2)
      if (e.panel === sender.columnHeaders) {
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;

      // 음수 = 빨간 글자 — AS-IS 프레임워크 전역 파리티(화면 코드가 아니라 공통 숫자셀 속성).
      //   GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs 가 NumberCellType 을 만들 때마다
      //   `NegativeRed = true` 를 박는다(L2675·2904·3087·3680·3860·4058 … + SpreadExtension.cs:38).
      //   즉 SSP0060 .cs 에 NegativeRed 가 0 hit 인 것은 "없다"가 아니라 "프레임워크가 전역으로 한다"다.
      //   필수: 분기 return 앞에서 전 셀에 1회 적용한다 — Wijmo 가 셀 DOM 을 재사용하므로
      //   조건부로만 칠하면 스크롤 후 엉뚱한 셀에 잔상이 남는다(paintNegativeText 가 해제까지 담당).
      //   값 원천은 실제 그리는 원값(getCellData false) — 문자/코드/날짜 셀은 toGridNumber 가 0 을
      //   돌려 음수 판정에서 자연히 빠진다. 자매 SSP0015 와 동일 정본 유틸 사용.
      paintNegativeText(e.cell, toGridNumber(sender.cells.getCellData(e.row, e.col, false)));

      // Model(ITEM_ID) 그룹 경계 — AS-IS Re_Design(cs L5553~5562):
      //     string strTmp_ItemID = GetValue(i, ITEM_ID);
      //     if (sItemID != strTmp_ItemID) {
      //       range1 = Cells[i, ITEM_ID, i, ColumnCount - 1];
      //       range1.Border = bevelbrdr;          // cs L286: Black, 1px, top-only
      //       sItemID = strTmp_ItemID;
      //     }
      //   ITEM_ID 가 바뀌는 행의 상단에 ITEM_ID 열~끝까지 검정 실선. bevelbrdr 의 네 bool 인자
      //   (false, true, false, false) 가 left/top/right/bottom 이라 **top 만** 그린다.
      //   그룹 '사이'만 — 0번째 행(최상단)은 제외한다(자매 SSP0015 6e99a19e 와 동일 처리).
      //   경계가 아닌 셀은 border 를 지운다(셀 DOM 재사용 잔상 방지).
      //   판정 기준은 **직전 '표시' 행**이다 — AS-IS 는 스프레드 행을 순회하므로, 정렬·필터가 걸린
      //   TO-BE 에서 데이터 배열 순서로 판정하면 화면에 보이는 경계와 어긋난다.
      const itemIdCol = sender.columns.getColumn('ITEM_ID')?.index ?? -1;
      let isItemBoundary = false;
      if (itemIdCol >= 0 && e.row > 0 && row) {
        const prev = GridUtils.getRow(sender, e.row - 1) as Record<string, unknown> | undefined;
        // prev 가 데이터 행이 아니면(그룹행 등) 경계로 보지 않는다 — AS-IS 에는 그룹행이 없다.
        if (prev) isItemBoundary = str(prev.ITEM_ID) !== str(row.ITEM_ID);
      }
      if (isItemBoundary && e.col >= itemIdCol) {
        e.cell.style.borderTop = '1px solid #000';
      } else {
        e.cell.style.removeProperty('border-top');
      }

      // FCST_TYPE code->name 표시(마지막 등록 핸들러라 wrapper 텍스트 뒤에 최종 확정).
      if (binding === LOOKUP_COLUMN.FCST_TYPE) {
        const code = str(row?.[binding]);
        if (code) e.cell.textContent = fcstTypeMapRef.current[code] ?? code;
      }
      const editable = isMainCellEditable(
        row,
        binding,
        editableRef.current,
        curPlanDateRef.current
      );
      // I15 — 음수 판정 셀은 편집색보다 우선한다. AS-IS SaveData_Main(cs L2990~2995)은 음수를
      //   만나면 그 셀에 InvalidColor 를 칠하고 MSG00084 후 즉시 return 하므로, 칠해진 셀은
      //   편집 가능 셀(노랑)이면서 동시에 invalid 다 — 나중에 칠한 invalid 가 보여야 맞다.
      //   인라인 배경은 공용 wj-cell-editable 클래스(#fff8cd)를 이기므로 invalid 는 그대로 표시된다.
      if (negativeCellsRef.current.get(row as object)?.has(binding)) {
        e.cell.style.backgroundColor = INVALID_CELL_COLOR;
        return;
      }
      // 편집색 시각 계층 — Detail 그리드(J5)와 동일하게 공용 wj-cell-editable 클래스로 통일한다.
      //   공용 wrapper formatItem(dataGridUtils.formatEditableColumns)은 동적 D_/W_/M_ 컬럼의 메타
      //   (_inputEditType=OPTIONAL)만 보고 클래스를 붙여, 확정구간·W_/M_(Sum)·비SHIP_PLAN_DETAIL 등
      //   실제로 잠긴 셀에도 노란 배경이 샜다(사용자 신고 2026-10-13). wrapper 보다 나중에 등록된 이
      //   핸들러가 실제 편집게이트(isMainCellEditable) 기준으로 클래스를 재대입해 최종 판정으로 덮는다.
      e.cell.classList.toggle('wj-cell-editable', editable);
      // measure 행 배경(Re_Design, 03 §3-I) — 편집색(노랑)이 우선하므로 편집 가능 셀은 제외하고,
      //   그 외 셀만 행 유형 색으로 칠한다. 색이 없는 셀은 '' 로 비워 DOM 재사용 잔상을 막는다
      //   (이전 invalid 인라인 도색도 함께 해제된다).
      if (editable) {
        e.cell.style.backgroundColor = '';
      } else {
        const measureNameCol = sender.columns.getColumn('MEASURE_NAME')?.index ?? -1;
        const toSiteCol = sender.columns.getColumn('TO_SITE')?.index ?? -1;
        const measureBg = measureRowBackground(
          str(row?.MEASURE),
          e.col,
          measureNameCol,
          toSiteCol,
          binding,
          curPlanDateRef.current
        );
        // measure 색이 있으면 그것, 없으면 확정구간 BACK_COLOR(AS-IS 레이어링 — measure 색이 위, 없을 때만 보임).
        e.cell.style.backgroundColor = measureBg || confirmWindowBackground(row, binding);
      }

      // 파란 StickyNote(■) — DO 발행(입력불가) 수량 참고. SHIP_PLAN_DETAIL D_ 일자셀 + o_rc2 키 매칭 시만.
      //   textContent 조작(FCST_TYPE)은 D_ 셀 대상이 아니라 자식 span 과 충돌하지 않는다. 비대상 원복 포함.
      applyDoNote(e.cell, row, binding, noteMapRef.current);
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 (I1 — memory datagrid-paste-editability-pastingcell-gap):
    //   wrapper 의 pastingCell 은 _inputEditType 만 보므로 OPTIONAL 인 동적 셀 전체가 열린다.
    //   동적(D_/W_/M_) 컬럼은 편집창 판정으로 verdict 를 덮어쓴다(wijmo Event 는 등록 순서 호출 —
    //   화면 핸들러가 wrapper 뒤에 실행되어 최종 판정이 된다). base 컬럼은 wrapper 판정('S' 차단) 유지.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집/붙여넣기 반영 — CalcPlanQty 5산식 전파 (03 §3-A. EditTracker 'M' 마킹은 wrapper 가 수행.
    //   붙여넣기도 AS-IS SpdMain_ClipboardPasted(L994~1029)가 EditByChange 로 동일 재계산)
    const recalcCell = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!binding.startsWith('D_')) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      // DO 하한 가드 (AS-IS EditByChange cs L2101~2126 — D00-2b-014 MSG00425 이식 2026-10-22):
      //   이 셀의 note 행(o_rc2 ■)이 있으면 NOEDIT_QTY(= DO 발행분)가 입력 하한이다. 미만 입력이면
      //   경고(MSG00666 "최소입력수량 이상") 후 원 확정수량(QTY)으로 되돌린다(AS-IS SetValue(dQty)).
      //   하한 이상 증감은 그대로 통과 — 파란 ■ 는 완전 잠금이 아니라 하한 표시다(증가는 신규 Confirm,
      //   하한 이상 감소는 비DO 확정분 차감 — SAVE_SHIPMENT_PLAN 증감 분기).
      //   AS-IS 게이트는 EDIT_YN 숫자이나 TO-BE 는 EDIT_YN 부재(G15) — note 존재(NOEDIT_QTY>0)가
      //   등가 게이트다(■ 표시와 동일 기준). 원복이 원본값과 같아지면 저장 diff 에서 자연 제외된다.
      let reverted = false;
      const key = noteKeyOf(row, binding);
      const entry = key ? noteMapRef.current.get(key) : undefined;
      if (entry && toGridNumber(row[binding]) < entry.noEditQty) {
        row[binding] = entry.qty;
        reverted = true;
        void setAlertRef.current({
          type: 'alert',
          content: tRef.current(
            MSG.BELOW_LOCKED_QTY,
            '__A value smaller than the actual quantity cannot be entered.'
          ),
        });
      }
      const changes = calcPlanQty(
        rowsRef.current as unknown as CalcRow[],
        dayBindingsRef.current,
        row as CalcRow,
        binding
      );
      if (changes.length > 0 || reverted) sender.collectionView?.refresh();
      onCellEditedRef.current?.();
    };
    g.cellEditEnded.addHandler(recalcCell);
    g.pastedCell.addHandler(recalcCell);

    // Delete 키 (I1 — AS-IS spdMain_KeyUp L2462~2521: 선택 범위의 D_ 셀 "0" 세팅 + EditByChange).
    //   wijmo 기본 Delete(_deleteRange)는 isRequired 만 보고 편집게이트를 안 타므로 캡처 단계에서
    //   가로채 편집가능(isMainCellEditable) D_ 셀만 0 세팅 + EditTracker 기록 + 재계산으로 재현한다.
    //   주의: AS-IS KeyUp 은 잠금 여부를 안 보지만(락 무시 SetValue) 저장 게이트(IsLock)와 결합하면
    //   편집모드 셀만 저장에 도달 — TO-BE 는 gap-audit I1 expect 대로 편집가능 셀 한정으로 재현.
    const deleteKeyHandler = (ev: KeyboardEvent) => {
      if (ev.key !== 'Delete' || ev.altKey || ev.ctrlKey || ev.metaKey || ev.shiftKey) return;
      if (g.activeEditor) return; // 셀 편집기 열림 — 문자 삭제 기본 동작 유지
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      ev.preventDefault();
      ev.stopPropagation();
      const tracker = editTrackerRef.current;
      const touched: { row: Record<string, unknown>; binding: string }[] = [];
      let blockedByFloor = false;
      for (let r = sel.topRow; r <= sel.bottomRow; r += 1) {
        const row = GridUtils.getRow(g, r) as Record<string, unknown> | undefined;
        if (!row) continue;
        for (let c = sel.leftCol; c <= sel.rightCol; c += 1) {
          const binding = g.columns[c]?.binding ?? '';
          if (!binding.startsWith('D_')) continue;
          if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current))
            continue;
          // DO 하한 가드 — 0 세팅은 하한(NOEDIT_QTY>0) 미만이므로 차단(현재값 유지, 경고는 루프 뒤 1회).
          //   AS-IS KeyUp 은 0 세팅 후 EditByChange 가 MSG00425+QTY 원복 — 편집시점 가드가 하한 이상을
          //   이미 보장하므로 현재값 유지가 등가다(셀마다 경고 반복만 1회로 합친다).
          const floorKey = noteKeyOf(row, binding);
          if (floorKey && noteMapRef.current.get(floorKey)) {
            blockedByFloor = true;
            continue;
          }
          const original = row[binding] as WijmoPrimitive;
          if (Number(original ?? 0) === 0) continue;
          row[binding] = 0;
          tracker?.storeChange(row as WijmoRowItem, binding, original, 0);
          touched.push({ row, binding });
        }
      }
      if (blockedByFloor) {
        void setAlertRef.current({
          type: 'alert',
          content: tRef.current(
            MSG.BELOW_LOCKED_QTY,
            '__A value smaller than the actual quantity cannot be entered.'
          ),
        });
      }
      if (touched.length > 0) {
        // AS-IS 는 셀마다 EditByChange → CalcPlanQty — 셀 단위로 동일 재현(그룹 다수 선택 대응)
        touched.forEach(({ row, binding }) =>
          calcPlanQty(
            rowsRef.current as unknown as CalcRow[],
            dayBindingsRef.current,
            row as CalcRow,
            binding
          )
        );
        g.collectionView?.refresh();
      }
    };
    g.hostElement.addEventListener('keydown', deleteKeyHandler, true);

    // 더블클릭 — BOH_QTY(BOH_TYPE 분기) / 데이터 셀(MEASURE 분기, AS-IS e.Column>=FCST_TYPE+1 이라
    //   D_ 뿐 아니라 W_/M_ Sum 셀도 대상 — gap-audit I10) 드릴다운 (03 §3-D)
    //   가드: 직전 두 클릭이 **같은 셀**일 때만 더블클릭으로 인정한다(AS-IS FarPoint
    //   CellDoubleClick 등가). 셀을 바꿔 가며 연속 클릭하면 브라우저가 dblclick 을 두 셀의 최근접
    //   공통 조상(= hostElement)에 디스패치해 드릴다운 조회가 나가던 것을 막는다
    //   (2026-10-12 사용자 보고 — utils/shipment-plan.dblClickGuard.ts 주석에 근거).
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if (!dblClickGuard.accepts({ row: ht.row, col: ht.col })) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'BOH_QTY' && !kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row, binding);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 활성 그리드 전환 — AS-IS 프레임워크 BaseForm.FpSpread_CellClick(L2303~2305)이 모든 스프레드
    //   클릭에서 fps 를 무조건 전환한다(설계 01 R5 의 "sticky·복귀 없음"은 화면 코드만 본 판정 —
    //   iter-2 프레임워크 실측으로 정정, __asis-mapping__ 참조). Main 클릭 시 'main' 복귀 배선.
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 필수: early return 보다 먼저 기록한다 — 헤더·빈 영역 클릭을 null 로 남겨야
      //   "헤더 클릭 → 셀 클릭" 이 같은 셀 2회로 오인되지 않는다.
      const isCell = ht.cellType === CellType.Cell;
      dblClickGuard.track(isCell ? { row: ht.row, col: ht.col } : null);
      if (!isCell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.updatedLayout?.removeHandler(applyHeaderHeight);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(recalcCell);
        g.pastedCell?.removeHandler(recalcCell);
        g.hostElement?.removeEventListener('keydown', deleteKeyHandler, true);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns]);

  // lookup(FCST_TYPE) 늦게 도착 시 재도색 — formatItem 이 이름으로 다시 쓴다.
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fcstTypeMap]);

  // NOTE(o_rc2) 가 본문 조회와 별도 커서라 늦게 반영될 수 있다 — 도착/변경 시 재도색해 ■ 를 그린다.
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noteMap]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // All = 셀 + 컬럼헤더 병합. Cells 단독이면 공용 매니저의 헤더 병합 분기가 통째로 꺼져
      //   (`_getColumnHeaderMergedRange` 가 All/AllHeaders/ColumnHeaders 일 때만 동작) base 컬럼이
      //   동적 3단 헤더를 세로로 못 덮고 같은 글자가 칸칸이 갈라진다 — AS-IS 는 ColumnHeaderSpan 으로
      //   같은 내용을 한 칸으로 묶는다(cs L920~949, 사용자 요청 2026-10-06). Doc/new_rules GRID-11
      //   금지 항목("AllowMerging.Cells 단독으로 헤더 머지 풀림")과 자매 3단 화면(global-psi-elec·
      //   demand-plan-waterfall·cust-fcst-waterfall) 전부 All 을 쓴다.
      //   셀 병합 범위는 위 applyMerge 의 컬럼별 allowMerging 이 그대로 가른다(동적 컬럼 제외 유지).
      allowMerging={AllowMerging.All}
    />
  );
};
