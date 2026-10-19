import { DataType } from '@mescius/wijmo';
import {
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
  CellType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MENU_ID, REQUEST_CHK_BINDING, SHEETS } from '../capa.constants';
import type { CalendarRow, CapaRow } from '../capa.types';
import { recalcAll, recalcBestWorst } from '../utils/capa.derive';
import { type EditContext, isCellEditable } from '../utils/capa.editLock';

interface CapaGridProps {
  gridRef: MutableRefObject<FlexGrid<CapaRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<CapaRow> | undefined>;
  rows: CapaRow[];
  staticColumns: RawFlexGridColumnConfig[];
  calendar: CalendarRow[];
  divisionId: string;
  editContext: EditContext;
  fromYyyymm: string;
  /** checkRESULT 토글(기본 true=Result) — BEF 계획측/실적측 컬럼 visible 전환(03 Vis6). */
  checkResult: boolean;
  /** checkEmpty — C14 연두 하이라이트 게이트(03 C14). */
  checkEmpty: boolean;
}

// BEF_Mk (+_RESULT) → 당월-k yyyymm/헤더 매핑(03 §2.3·Vis5·§3 V10 — GAP-07·08).
const BEF_MONTH_KS = [1, 2, 3, 4, 5, 6] as const;
const befYyyymm = (k: number): string => dayjs().subtract(k, 'month').format('YYYYMM');
const befHeader = (k: number): string => dayjs().subtract(k, 'month').format('YYYY-MM');
const BEF_M_RESULT_RE = /^BEF_M([1-6])(_RESULT)?$/;

const kindOf = (b: string): 'D' | 'M' | 'Y' | null =>
  /^D_\d{8}$/.test(b) ? 'D' : /^M_\d{6}$/.test(b) ? 'M' : /^Y_\d{4}$/.test(b) ? 'Y' : null;

// 색상(03 §3 C) — 조건부 서식.
const GRAY_BEF = '#f0f0f0'; // C1 BEF 실적 회색
const LIGHT_BLUE = '#add8e6'; // C2/C3 계산행
const GREEN_EMPTY = '#d8e4bc'; // C14 checkEmpty 연두
const GRAY_NORUN = '#f0f0f0'; // C13 No-Run D_ 회색
const YELLOW_EDITABLE = '#ffff99'; // Mail REQ 편집 가능 셀(AS-IS 노란 배경)

const CAL_LOSS = new Set(['XB020', 'XB021', 'XC041', 'XC042', 'XE500', 'M08', 'XD101']);
const NO_RUN_NOT_PM = new Set([
  'EL009',
  'EL010',
  'EL012',
  'EL013',
  'EL014',
  'EL015',
  'EL016',
  'EL017',
  'EL018',
  'EL019',
  'EL020',
  'EL021',
  'EL022',
  'EL023',
  'EL024',
]);

/**
 * SCP0049 메인 그리드(siMain, 03 설계). 고정칼럼 = staticColumns(userTitle).
 * 동적 기간칼럼(D_/M_/Y_) = calendar SP + 맨 뒤 REQUEST_CHK(Mail REQ). D_ 초기 숨김(Vis7) + 월 헤더 더블클릭 드릴다운(Vis8).
 * 편집 = beginningEdit 종합식(capa.editLock — EDIT 모드 토글 미이식). 파생 재계산 = cellEditEnded(capa.derive).
 * 셀 병합 G4(좌측 키) + 헤더 span G5 = 공용 CustomMergeManager + DataGrid 헤더 머지.
 */
export const CapaGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  rows,
  staticColumns,
  calendar,
  divisionId,
  editContext,
  fromYyyymm,
  checkResult,
  checkEmpty,
}: CapaGridProps) => {
  // 월 헤더 더블클릭 드릴다운 상태 — 펼친 월(M_yyyymm) 집합.
  const drilledMonthsRef = useRef<Set<string>>(new Set());
  const editContextRef = useRef(editContext);
  editContextRef.current = editContext;
  const fromRef = useRef(fromYyyymm);
  fromRef.current = fromYyyymm;
  const checkEmptyRef = useRef(checkEmpty);
  checkEmptyRef.current = checkEmpty;

  // BEF 컬럼 동적 헤더(당월-k "yyyy-MM") + visible 계산(GAP-06·07 — 03 §2.3·Vis5·Vis6).
  //   계획측(BEF_Mk/BEST/WORST) = checkResult=false 시 노출, 실적측(*_RESULT) = checkResult=true 시.
  //   BEF_Mk 는 당월-k ≥ From월 일 때만(From월 초과 과거월 숨김).
  const transformBefColumn = (c: RawFlexGridColumnConfig): RawFlexGridColumnConfig => {
    const m = BEF_M_RESULT_RE.exec(c.colNm);
    if (m) {
      const k = Number(m[1]);
      const isResult = !!m[2];
      const visible = isResult === checkResult && befYyyymm(k) >= fromYyyymm;
      return { ...c, colLblNm: befHeader(k), visible };
    }
    if (c.colNm === 'BEF_BEST' || c.colNm === 'BEF_WORST') return { ...c, visible: !checkResult };
    if (c.colNm === 'BEF_BEST_RESULT' || c.colNm === 'BEF_WORST_RESULT')
      return { ...c, visible: checkResult };
    return c;
  };

  // BEF 헤더/visible 변환.
  const transformedColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => staticColumns.map(transformBefColumn),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [staticColumns, checkResult, fromYyyymm]
  );

  // 동적 기간칼럼(calendar) → FlexGridColumnConfig. D_ 는 초기 숨김(Vis7), 드릴다운 시 노출(Vis8).
  //   REQUEST_CHK 는 AS-IS 처럼 기간칼럼 뒤 마지막에 붙인다(03 §1.1-D, cs:1471 AddCheckColumn).
  //   dataType Boolean + isRequired true: 값 없음(null)을 미정(indeterminate) 아닌 미체크로 그린다.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const periodColumns = [...calendar]
      .sort((a, b) => Number(a.SORT_ORDER_NO) - Number(b.SORT_ORDER_NO))
      .map<FlexGridColumnConfig>(c => {
        const binding = c.COLUMN_NAME;
        const kind = kindOf(binding);
        const isDay = kind === 'D';
        const month = kind === 'D' ? `M_${binding.slice(2, 8)}` : '';
        return {
          binding,
          header: c.COLUMN_LABEL_NAME,
          width: 70,
          align: 'R',
          format: 'n2',
          allowMerging: false,
          allowSorting: false,
          _dynamic: true,
          // D_ 는 소속 월이 드릴다운된 경우에만 표시.
          visible: isDay ? drilledMonthsRef.current.has(month) : true,
        };
      });
    return [
      ...periodColumns,
      {
        binding: REQUEST_CHK_BINDING,
        header: 'Mail REQ',
        width: 60,
        align: 'center',
        allowMerging: false,
        allowSorting: false,
        dataType: DataType.Boolean,
        isRequired: true,
        _ctrlType: CELL_CONTROL_TYPE.CHECKBOX,
      },
    ];
  }, [calendar]);

  // 그리드 이벤트 배선 — 편집 잠금/파생 재계산/조건부 서식/월 드릴다운.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 좌측 키 세로 병합(G4) + 헤더 span(G5). 공용 CustomMergeManager 가 CRUD_TYPE='I' 제외 처리.
    if (!(g.mergeManager instanceof CustomMergeManager)) {
      g.mergeManager = new CustomMergeManager<CapaRow>(g);
    }

    const dataRowOf = (row: number): CapaRow | undefined =>
      (g.rows[row]?.dataItem as CapaRow | undefined) ?? undefined;
    const bindingOf = (col: number): string => g.columns[col]?.binding ?? '';

    // CONFIRM_FLAG 셀 클릭 시각 피드백(AS-IS SpdMain_CellClick, cs:2412 — ForeColor=Red, 값은 불변).
    //   클릭된 (row,binding) 집합 — rows 변경(재조회) 시 effect 재실행으로 자연히 리셋(AS-IS 재조회 시 그리드 재바인딩과 등가).
    const confirmFlagClicked = new Set<number>();

    // C14 제외 집합(03 C14 cs:721~732): LA001(LINE ASSIGN priority) 값이 0/9 인 (ITEM × 기간) 조합.
    //   대응 LA002/LA003 0셀은 "입력 필요"가 아니므로 연두 하이라이트에서 제외한다.
    const la001ExcludeSet = new Set<string>();
    for (const r of rows) {
      if (String(r.LOSS_CODE ?? '') !== 'LA001') continue;
      const item = String(r.ITEM_ID ?? '');
      for (const key of Object.keys(r)) {
        if (!/^[DMY]_\d{4,8}$/.test(key)) continue;
        const v = Number(String(r[key] ?? '').replace(/,/g, ''));
        if (v === 0 || v === 9) la001ExcludeSet.add(`${item}|${key}`);
      }
    }

    // 편집 잠금(03 §3 종합식) — 편집 불가 셀은 진입 취소.
    //   공용 DataGrid 의 beginningEdit(setEditableColumns)가 먼저 돌아 `_inputEditType` 이 편집형(O/M)이 아닌
    //   컬럼(INPUT_TP_CD 전건 'S', Mail REQ 동적 컬럼)을 전부 cancel=true 로 만든다. 이 핸들러가 뒤에 등록되므로
    //   취소만 세우지 말고 종합식 결과로 덮어써야 편집 가능 셀이 열린다(pastingCell 과 동일 판정).
    const beginningEdit = (_s: FlexGrid<CapaRow>, e: CellRangeEventArgs) => {
      const row = dataRowOf(e.row);
      if (!row) return;
      e.cancel = !isCellEditable(row, bindingOf(e.col), editContextRef.current);
    };

    // 붙여넣기도 같은 편집 게이트 — INPUT_TP_CD 전건 'S'(editLock 방식)라 공용 pastingCell 기본핸들러가
    //   모든 붙여넣기를 취소하므로, beginningEdit 와 동일 판정을 재지정해 편집 가능 셀만 붙여넣기 허용한다
    //   (memory sheet-columns-input-tp-all-search-only-grid-readonly — AS-IS SpdMain_ClipboardPasted 는
    //   빈 본문 no-op 이나 FpSpread 기본 붙여넣기가 잠금 안 된 편집 셀에 동작한 것과 파리티).
    const pastingCell = (_s: FlexGrid<CapaRow>, e: CellRangeEventArgs) => {
      const row = dataRowOf(e.row);
      if (!row || !isCellEditable(row, bindingOf(e.col), editContextRef.current)) e.cancel = true;
    };

    // 파생 즉시 재계산(03 §3 V) — M_/Y_ 편집 시 계산행 갱신(D_ 편집은 파생 없음).
    const cellEditEnded = (_s: FlexGrid<CapaRow>, e: CellRangeEventArgs) => {
      const binding = bindingOf(e.col);
      const kind = kindOf(binding);
      if (kind === 'M' || kind === 'Y') {
        recalcAll(rows, [binding]);
        g.invalidate();
      }
    };

    // 조건부 서식(03 §3 C1/C2/C3/C4/C13/C14).
    const formatItem = (_s: FlexGrid<CapaRow>, e: FormatItemEventArgs) => {
      const binding = bindingOf(e.col);
      if (e.panel.cellType === CellType.ColumnHeader) {
        // C4 D_ 헤더 요일색 — 토=파랑/일=빨강(calendar DAY_CODE).
        const cal = calendar.find(c => c.COLUMN_NAME === binding);
        if (cal?.DAY_CODE === '7') e.cell.style.color = 'blue';
        else if (cal?.DAY_CODE === '1') e.cell.style.color = 'red';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const row = dataRowOf(e.row);
      if (!row) return;
      const loss = String(row.LOSS_CODE ?? '');
      // 체크박스 칼럼 — 잠금은 beginningEdit 취소뿐이라 Wijmo 가 체크박스를 활성으로 그려 눌리면 시각적으로
      //   토글된다. 편집 불가 셀은 체크박스를 disabled 로 그려 클릭을 막는다(AS-IS 잠금 셀 회색과 동일).
      //   Mail REQ 편집 가능 셀은 AS-IS 처럼 노란 배경(Spread 의 잠금 해제 셀 표시).
      if (binding === 'CONFIRM_FLAG' || binding === REQUEST_CHK_BINDING) {
        const editable = isCellEditable(row, binding, editContextRef.current);
        const cb = e.cell.querySelector<HTMLInputElement>('input[type="checkbox"]');
        if (cb) cb.disabled = !editable;
        if (binding === REQUEST_CHK_BINDING && editable) e.cell.style.backgroundColor = YELLOW_EDITABLE;
      }
      // CONFIRM_FLAG 클릭 피드백(AS-IS SpdMain_CellClick) — 다른 조건부 서식과 독립적으로 우선 적용.
      if (binding === 'CONFIRM_FLAG' && confirmFlagClicked.has(e.row)) {
        e.cell.style.color = 'red';
      }
      // C1 BEF 실적 영역 회색.
      if (binding.startsWith('BEF_')) {
        e.cell.style.backgroundColor = GRAY_BEF;
        return;
      }
      // C2/C3 계산행(CAL/M08) LightBlue.
      if (CAL_LOSS.has(loss) && (String(row.DATA_TABLE ?? '') === 'CAL' || loss === 'M08')) {
        e.cell.style.backgroundColor = LIGHT_BLUE;
        return;
      }
      // C13 No-Run(≠EL011) 행 D_ 셀 회색(월단위 입력 전용).
      if (kindOf(binding) === 'D' && NO_RUN_NOT_PM.has(loss)) {
        e.cell.style.backgroundColor = GRAY_NORUN;
        return;
      }
      // C14 checkEmpty 체크 시에만 LA002/LA003 0값 셀 연두(입력 필요 표시 — GAP-14).
      //   대응 LA001 priority 0/9 (ITEM×기간) 조합은 제외(cs:721~732, GAP-14 완전 해소).
      if (
        checkEmptyRef.current &&
        (loss === 'LA002' || loss === 'LA003') &&
        kindOf(binding) &&
        Number(String(row[binding] ?? '0').replace(/,/g, '')) === 0 &&
        !la001ExcludeSet.has(`${String(row.ITEM_ID ?? '')}|${binding}`)
      ) {
        e.cell.style.backgroundColor = GREEN_EMPTY;
      }
      // TACT TIME 행(LA002) 기간셀 = 소수 4자리 표기(03 §1 O — 컬럼 format 'n2' 위 행단위 재포맷).
      //   편집 중(activeEditor)에는 재포맷하지 않는다 — 에디터 입력을 덮어쓰지 않기 위함.
      if (loss === 'LA002' && kindOf(binding) && !g.activeEditor) {
        const raw = String(row[binding] ?? '');
        const n = Number(raw.replace(/,/g, ''));
        if (raw.trim() !== '' && Number.isFinite(n)) {
          e.cell.textContent = n.toLocaleString('en-US', {
            minimumFractionDigits: 4,
            maximumFractionDigits: 4,
          });
        }
      }
    };

    // 월 헤더 더블클릭 → 그 월 D_ 드릴다운 토글(Vis8).
    const dblclick = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const binding = bindingOf(ht.col);
      if (kindOf(binding) !== 'M') return;
      const month = binding; // M_yyyymm
      const set = drilledMonthsRef.current;
      if (set.has(month)) set.delete(month);
      else set.add(month);
      const ym = month.slice(2, 8);
      for (const col of g.columns) {
        const b = col.binding ?? '';
        if (b.startsWith('D_') && b.slice(2, 8) === ym) col.visible = set.has(month);
      }
      g.invalidate();
    };

    // CONFIRM_FLAG 셀 클릭 → ForeColor=Red 피드백(AS-IS SpdMain_CellClick, cs:2412. 값 변경 없음).
    const click = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if (bindingOf(ht.col) !== 'CONFIRM_FLAG') return;
      confirmFlagClicked.add(ht.row);
      g.invalidate();
    };

    g.beginningEdit.addHandler(beginningEdit);
    g.pastingCell.addHandler(pastingCell);
    g.cellEditEnded.addHandler(cellEditEnded);
    g.formatItem.addHandler(formatItem);
    g.hostElement.addEventListener('dblclick', dblclick);
    g.hostElement.addEventListener('click', click);
    return () => {
      g.beginningEdit.removeHandler(beginningEdit);
      g.pastingCell.removeHandler(pastingCell);
      g.cellEditEnded.removeHandler(cellEditEnded);
      g.formatItem.removeHandler(formatItem);
      g.hostElement.removeEventListener('dblclick', dblclick);
      g.hostElement.removeEventListener('click', click);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns, calendar, rows]);

  // 조회 직후 파생 재계산 + Best/Worst 재산출(03 §3 V3~V10 — 서버값 위에 클라 수렴).
  useEffect(() => {
    if (rows.length === 0) return;
    const periodBindings = calendar.map(c => c.COLUMN_NAME);
    recalcAll(rows, periodBindings);
    // GAP-08: BEF_Mk → 당월-k yyyymm 매핑으로 From월 게이트 정상화(계획측 값 기준 Best/Worst 재산출).
    const befMonthMap: Record<string, string> = {};
    for (const k of BEF_MONTH_KS) befMonthMap[`BEF_M${k}`] = befYyyymm(k);
    recalcBestWorst(rows, befMonthMap, fromRef.current);
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows, calendar]);

  return (
    <DataGrid<CapaRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={transformedColumns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'`, divisionId: `'${divisionId}'` }}
      sheetName={SHEETS.CAPA}
      useHotkey
    />
  );
};
