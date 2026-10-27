import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { DIVISION_EE_ONLY_COLUMNS, MAIN_COLUMNS, FREEZE_ANCHOR_COLUMN } from '../shipment-plan-semi.columns';
import { BUCKET_TYPE, INVENTORY_MEASURE, MEASURE, MSG, QTY_MAX, QTY_MIN } from '../shipment-plan-semi.constants';
import type { FixInfoRow, MainColumnMeta, MainRow } from '../shipment-plan-semi.types';
import { buildColumns } from '../utils/shipment-plan-semi.buildColumns';
import { distributeWeeklyToDailyBindings } from '../utils/shipment-plan-semi.deptDayDistribute';
import { dynColKindOf, isMainCellEditable, isQtyInRange, pickField, type MainEditContext } from '../utils/shipment-plan-semi.editLock';
import { type HeaderKey, ShipmentPlanSemiHeaderMergeManager } from '../utils/shipment-plan-semi.headerMerge';

// 헤더 전체 높이 캡 — tier 수(2~3단: 월/주/일)와 무관하게 총 높이를 이 값으로 고정하고 각 헤더 행에 분배한다
//   (SCP0013 ProductionPlanLineGrid 와 동일). 없으면 공용 매핑이 tier 마다 고정 높이를 박아 3단일 때 헤더가 커진다.
const HEADER_TOTAL_HEIGHT = 48;

export interface SpreadTitleRow {
  COLUMN_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  COLUMN_LABEL_NAME?: string;
  SORT_ORDER_NO?: number;
  BASIS_START_DATE?: string;
  DAY_CODE?: string;
}

interface Props {
  rows: MainRow[];
  spreadTitle: SpreadTitleRow[];
  fixInfoRows: FixInfoRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  division: string;
  planStartYyyymmdd: string;
  toYyyymmdd: string;
  bucketType: BUCKET_TYPE;
  planEditable: boolean; // GET SP o_rc2 IS_EDITABLE='Y' — plan-level 편집가능 게이트(과거주 플랜 전면 잠금)
  chkSum: boolean;
  onFocus: () => void;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// D_YYYYMMDD 바인딩의 요일(0=일..6=토) — 주말 헤더 색 판정(AS-IS .cs:510-512 DAY_CODE 기반과 등가).
const dayOfWeekOf = (yyyymmdd: string): number =>
  new Date(Number(yyyymmdd.slice(0, 4)), Number(yyyymmdd.slice(4, 6)) - 1, Number(yyyymmdd.slice(6, 8))).getDay();

// 헤더 Bold 대상(AS-IS .cs:385-386 — To Site·Trans Mode 컬럼 헤더만 Bold).
const BOLD_HEADER_BINDINGS = new Set(['T0_SITE_DESCRIPTION', 'transport_mode']);

// Fix 하이라이트 행 단위 매칭 키 — AS-IS Set_FixCellColor(.cs:1193)는 key_idx+TO_SITE+bod_id 로 행을
//   특정한 뒤 그 행의 해당 일자 셀만 칠한다. 날짜만 매칭하면 같은 날짜의 다른 행까지 전부 녹색이 된다.
const FIX_KEY_SEP = '~#~'; // 데이터에 등장하지 않는 구분자
const fixRowKey = (keyIdx: string, toSite: string, bodId: string): string =>
  `${keyIdx}${FIX_KEY_SEP}${toSite}${FIX_KEY_SEP}${bodId}`;

export const ShipmentPlanSemiGrid = ({
  rows,
  spreadTitle,
  fixInfoRows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  division,
  planStartYyyymmdd,
  toYyyymmdd,
  bucketType,
  planEditable,
  chkSum,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  // 정보컬럼 — admin 메타 우선, division 조건부 hidden 은 런타임 오버레이(design 03 §1 R-A)
  const infoColumns = useMemo<MainColumnMeta[]>(() => {
    const isEE = division.startsWith('EE');
    return MAIN_COLUMNS.map(c => {
      if ((DIVISION_EE_ONLY_COLUMNS as readonly string[]).includes(c.key)) {
        return { ...c, visible: isEE };
      }
      return c;
    });
  }, [division]);
  const staticColumns = useMemo(() => buildColumns(infoColumns, adminColumns), [infoColumns, adminColumns]);

  // 동적 D_/W_/M_ pivot 컬럼 — 헤더구조는 spreadTitle(calendar SP, Bucket 무관 항상 전체) 기준(design 03 §2.1~§2.3)
  const dynColMetas = useMemo(
    () =>
      spreadTitle
        .map(r => {
          const binding = s(r.COLUMN_NAME);
          const kind = dynColKindOf(binding);
          if (!kind) return null;
          return {
            binding,
            kind,
            large: s(r.LARGE_CLASS_LABEL_NAME),
            small: s(r.SMALL_CLASS_LABEL_NAME),
            leaf: s(r.COLUMN_LABEL_NAME) || binding,
            sort: Number(r.SORT_ORDER_NO ?? 0),
            weekStart: s(r.BASIS_START_DATE),
          };
        })
        .filter((m): m is NonNullable<typeof m> => m !== null),
    [spreadTitle]
  );

  const weekOrMonthStart = useMemo(() => {
    const map = new Map<string, string>();
    dynColMetas.forEach(m => {
      if (m.weekStart) map.set(m.binding, m.weekStart);
    });
    return map;
  }, [dynColMetas]);

  // W_ binding -> 그 주에 속한 7개 D_ binding 목록(design 03 §3.3 R-DeptDist 분배용) — weekStart 매칭.
  const weekToDayBindings = useMemo(() => {
    const map = new Map<string, string[]>();
    const dBindings = dynColMetas.filter(m => m.kind === 'D');
    dynColMetas
      .filter(m => m.kind === 'W')
      .forEach(w => {
        const days = dBindings.filter(d => weekOrMonthStart.get(d.binding) === w.weekStart).map(d => d.binding);
        if (days.length > 0) map.set(w.binding, days);
      });
    return map;
  }, [dynColMetas, weekOrMonthStart]);

  // W_ binding 오름차순 목록(design 03 §3.1 Weekly 동일주차 반복 방어, R-K §6#7) — calendar SP 가
  //   이미 SORT_ORDER_NO(BASIS_START_DATE 기준) 오름차순으로 내려주므로 dynColMetas 필터만으로 충분.
  const weekBindingsAsc = useMemo(
    () => dynColMetas.filter(m => m.kind === 'W').map(m => m.binding),
    [dynColMetas]
  );

  // Bucket x chkSum -> visible 토글(design 03 §2.4) — SCP0009 와 달리 chkAll 예외 없음(§0.2, 죽은 코드).
  const isDynVisible = (kind: 'D' | 'W' | 'M'): boolean => {
    if (bucketType === BUCKET_TYPE.DAILY) return kind === 'D' || (kind === 'M' && chkSum);
    if (bucketType === BUCKET_TYPE.WEEKLY) return kind === 'W' || (kind === 'M' && chkSum);
    return kind === 'M'; // Monthly — M_ 만
  };

  // 3-span 헤더(대/소/일) — Wijmo 중첩 columns 병합. 자매 shipment-plan-fg 와 동일 구조로 맞춘다(공용 SP 공유).
  //   AS-IS 파리티(design 03 §2.3): 대분류는 월 단위(binding 의 yyyymm), 합계 컬럼(W_/M_) 맨 아래 단 라벨은 'SUM'.
  //   월 합계(M_)는 소분류 그룹 없이 월 그룹 바로 아래 리프로 둔다 — 단수가 얕은 컬럼은 Wijmo 가 남은 헤더 행을
  //   세로로 채우므로 Monthly 가 AS-IS 처럼 2단(월 / SUM)으로 보인다. (이전엔 M_ 를 'SUM' 소그룹에 '월' 리프로
  //   넣고 largeKey 도 slice(0,8)('M_YYYYMM') 로 잡아 '월 / SUM / 월' 3단 중복 헤더로 깨져 보였다.)
  const dynamicColumns = useMemo(() => {
    type LeafCol = { binding: string; header: string; sort: number; visible: boolean };
    type LargeBucket = { label: string; order: number; monthSums: LeafCol[]; subs: Map<string, LeafCol[]> };
    const toLeafConfig = (l: LeafCol) => ({
      binding: l.binding,
      header: l.header,
      align: 'right',
      width: 90,
      allowDragging: false,
      allowMerging: false,
      allowSorting: false,
      visible: l.visible,
      format: '#,##0.##',
    });
    const largeMap = new Map<string, LargeBucket>();
    dynColMetas.forEach(m => {
      const largeKey = m.binding.slice(2, 8); // 접두 제거한 yyyymm — D/W/M 모두 같은 달끼리 묶인다(displayRows 와 동일).
      const bucket: LargeBucket = largeMap.get(largeKey) ?? {
        label: m.large,
        order: m.sort,
        monthSums: [],
        subs: new Map<string, LeafCol[]>(),
      };
      largeMap.set(largeKey, bucket);
      const leaf: LeafCol = {
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf : 'SUM',
        sort: m.sort,
        visible: isDynVisible(m.kind),
      };
      if (m.kind === 'M') {
        bucket.monthSums.push(leaf); // 월 그룹 바로 아래 리프(소그룹 없음)
        return;
      }
      const subKey = m.small || 'SUM';
      const leafCols: LeafCol[] = bucket.subs.get(subKey) ?? [];
      bucket.subs.set(subKey, leafCols);
      leafCols.push(leaf);
    });
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [
          ...bucket.monthSums.sort((a, b) => a.sort - b.sort).map(toLeafConfig),
          ...[...bucket.subs.entries()]
            .sort((a, b) => (a[1][0]?.sort ?? 0) - (b[1][0]?.sort ?? 0))
            .map(([subLabel, leafCols]) => ({
              header: subLabel,
              align: 'center',
              columns: leafCols.sort((a, b) => a.sort - b.sort).map(toLeafConfig),
            })),
        ],
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, bucketType, chkSum]);

  // 동적 헤더 병합 키(binding -> {ym,sub}) — 매니저는 1회만 생성(super 가 grid 이벤트 바인딩)하고 ref 로 최신 맵 전달.
  const headerKeyMap = useMemo(() => {
    const map = new Map<string, HeaderKey>();
    dynColMetas.forEach(m => {
      map.set(m.binding, { ym: m.binding.slice(2, 8), sub: m.kind === 'M' ? 'SUM' : m.small || 'SUM' });
    });
    return map;
  }, [dynColMetas]);
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;

  // 동적 컬럼 헤더 병합(월/주 가로 + 월합계 M_ 세로 2단) — 공용 CustomMergeManager 를 SEMI 전용으로 교체(자매 FG 동일).
  //   없으면 Monthly 에서 숨겨진 W_ 'SUM' 때문에 M_ 의 SUM 이 2·3단에 중복돼 보인다. 정적 info 컬럼·데이터 셀
  //   병합은 super 에 위임하므로 기존 SmartColMerge(세로 병합)는 유지된다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g || g.mergeManager instanceof ShipmentPlanSemiHeaderMergeManager) return;
    g.mergeManager = new ShipmentPlanSemiHeaderMergeManager(
      g as FlexGridType<WijmoRowItem>,
      () => headerKeyRef.current
    );
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // INVENTORY 행 후처리(design 03 §2.5) — 초기 로드 시 W_/M_ 값을 그 주/월의 마지막 D_ 값으로 덮어쓴다.
  const displayRows = useMemo<MainRow[]>(() => {
    if (rows.length === 0) return rows;
    const dBindings = dynColMetas.filter(m => m.kind === 'D').sort((a, b) => a.binding.localeCompare(b.binding));
    if (dBindings.length === 0) return rows;
    return rows.map(row => {
      const r = row as unknown as Record<string, unknown>;
      if (s(pickField(r, 'MEASURE')) !== INVENTORY_MEASURE) return row;
      const next = { ...r };
      weekToDayBindings.forEach((dayBindings, wBinding) => {
        const sorted = [...dayBindings].sort();
        const lastDay = sorted[sorted.length - 1];
        if (lastDay) next[wBinding] = r[lastDay];
      });
      // M_ — 그 달의 마지막 D_ 값(월별 그룹은 binding 앞 8자리 M_YYYYMM 로 근사 매칭)
      const monthGroups = new Map<string, string[]>();
      dBindings.forEach(d => {
        const monthKey = `M_${d.binding.slice(2, 8)}`;
        const list = monthGroups.get(monthKey) ?? [];
        list.push(d.binding);
        monthGroups.set(monthKey, list);
      });
      monthGroups.forEach((days, mBinding) => {
        const sorted = [...days].sort();
        const lastDay = sorted[sorted.length - 1];
        if (lastDay) next[mBinding] = r[lastDay];
      });
      return next as unknown as MainRow;
    });
  }, [rows, dynColMetas, weekToDayBindings]);

  // Fix 정보(O_RC3) — 행 단위(KEY_IDX+TO_SITE+BOD_ID)+날짜 매칭(AS-IS Set_FixCellColor .cs:1193).
  //   o_rc3 의 YYYYMMDD 는 'D_'||원본일자 접두가 붙어 와(PKG_SCP0010 L3008) 떼어 순수 8자리로 담는다.
  //   fixedDayKeys = 'rowKey~#~YYYYMMDD', fixedWeekKeys = 'rowKey~#~주시작일'(Weekly 는 그 주 W_ 셀까지 확산).
  const { fixedDayKeys, fixedWeekKeys } = useMemo(() => {
    const dayKeys = new Set<string>();
    const weekKeys = new Set<string>();
    fixInfoRows.forEach(r => {
      const date = String(r.YYYYMMDD ?? '').replace(/^D_/, '');
      if (!date) return;
      const rk = fixRowKey(s(r.KEY_IDX), s(r.TO_SITE), s(r.BOD_ID));
      dayKeys.add(`${rk}${FIX_KEY_SEP}${date}`);
      const weekStart = weekOrMonthStart.get(`D_${date}`);
      if (weekStart) weekKeys.add(`${rk}${FIX_KEY_SEP}${weekStart}`);
    });
    return { fixedDayKeys: dayKeys, fixedWeekKeys: weekKeys };
  }, [fixInfoRows, weekOrMonthStart]);

  const editCtxRef = useRef<MainEditContext>({
    bucketType,
    division,
    planStartYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    planEditable,
    weekOrMonthStart,
    weekBindingsAsc,
  });
  editCtxRef.current = {
    bucketType,
    division,
    planStartYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    planEditable,
    weekOrMonthStart,
    weekBindingsAsc,
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집잠금(정보컬럼 전건 잠금 + R-K SHIP_PLAN_AMEND 판정) — beginningEdit 게이트.
    const beginningEditHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // cancel 을 양방향으로 세팅한다 — 공통 DataGrid setEditableColumns 가 beginningEdit 에서
      //   cancel=!GridUtils.isEditableCell(=동적 D_ 컬럼은 _inputEditType 없어 항상 false)로 먼저 막으므로,
      //   true 만 세우면 편집가능 셀을 풀 수 없다. 이 핸들러가 공통보다 나중 등록(useEffect)이라 마지막에
      //   이김 — 편집가능이면 cancel=false 로 덮어 per-cell 편집을 허용한다.
      e.cancel = !row || !isMainCellEditable(binding, row, editCtxRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Weekly 셀(W_) 입력 시 Dept Day 요일 자동분배(design 03 §3.3 R-DeptDist, 이 화면 고유) +
    //   저장 값 검증(cellEditEnded) — 음수/상한 초과(design 03 §4.3 MSG00084/MSG00317).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const kind = dynColKindOf(binding);
      if (!kind) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const qty = Number(row[binding]);
      if (!Number.isFinite(qty)) return;
      let clamped = qty;
      if (!isQtyInRange(qty, QTY_MIN, QTY_MAX)) {
        if (qty < QTY_MIN) {
          setToast({ type: 'error', message: t(MSG.QTY_NEGATIVE, '_Value must not be negative.') });
          clamped = QTY_MIN;
        } else {
          setToast({ type: 'error', message: t(MSG.QTY_MAX, '_Value exceeds maximum(99999999).') });
          clamped = QTY_MAX;
        }
        row[binding] = clamped;
      }
      if (kind === 'W') {
        const dayBindings = weekToDayBindings.get(binding);
        const deptDayVal = pickField(row as Record<string, unknown>, 'DEPT_DAY');
        const deptDay = typeof deptDayVal === 'string' ? deptDayVal : 'X';
        if (dayBindings) {
          const distributed = distributeWeeklyToDailyBindings(dayBindings, deptDay, clamped);
          Object.entries(distributed).forEach(([dBinding, value]) => {
            row[dBinding] = value;
          });
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // Fix 하이라이트(D_ 매칭 + Weekly 는 W_ 헤더까지 확산, design 03 §4.2) + SHIP_PLAN_AMEND 입력밴드(R-G)
    //   + 헤더 스타일(To Site·Trans Mode Bold / 주말 요일 헤더색, AS-IS .cs:385-386·510-512) — formatItem.
    const formatItemHandler = (
      sender: FlexGridType,
      e: {
        panel: { cellType?: number; columns: { binding: string }[]; rows: { dataItem: unknown }[] };
        col: number;
        row: number;
        cell: HTMLElement;
      }
    ) => {
      const binding = e.panel?.columns?.[e.col]?.binding ?? '';
      if (e.panel?.cellType === CellType.ColumnHeader) {
        // 공통 CSS(.wj-colheaders .wj-header { font-weight:400 !important })가 인라인 bold 를 덮으므로
        //   inline !important 로 올려야 실제 적용된다(AS-IS .cs:385-386 To Site·Trans Mode 헤더만 Bold).
        if (BOLD_HEADER_BINDINGS.has(binding)) e.cell.style.setProperty('font-weight', 'bold', 'important');
        // 주말 요일 헤더 글자색 — Daily 의 D_ 리프(요일) 행만(토=파랑/일=빨강).
        if (binding.startsWith('D_') && e.row === e.panel.rows.length - 1) {
          const dow = dayOfWeekOf(binding.slice(2));
          if (dow === 6) e.cell.style.color = 'blue';
          else if (dow === 0) e.cell.style.color = 'red';
        }
        // Fix 녹색은 데이터 셀에만 칠한다(AS-IS 는 헤더를 칠하지 않음) — 헤더 분기는 여기서 종료.
      }
      // Fix 하이라이트(녹색)·편집가능(노란) 둘 다 데이터 셀 단위. AS-IS Set_FixCellColor(.cs:1193)는
      //   행(KEY_IDX+TO_SITE+BOD_ID)을 특정한 뒤 그 행의 해당 일자 셀만 칠한다 — 날짜만 매칭하면 같은
      //   날짜의 다른 행까지 전부 녹색이 된다(division 전반 fix 수천 건).
      const dataItem = e.panel?.rows?.[e.row]?.dataItem as Record<string, unknown> | undefined;
      // Fix 녹색은 SHIP_PLAN_AMEND(수정계획) 행에만(AS-IS .cs:1186 measure=="SHIP_PLAN_AMEND"). 한 품목의
      //   Ship Req/Plan/Amend 3행은 KEY_IDX+TO_SITE+BOD_ID 가 같아, measure 게이트가 없으면 전부 칠해진다.
      const isAmendRow = !!dataItem && s(pickField(dataItem, 'MEASURE')) === MEASURE.SHIP_PLAN_AMEND;
      const fixRk = dataItem
        ? fixRowKey(s(pickField(dataItem, 'KEY_IDX')), s(pickField(dataItem, 'TO_SITE')), s(pickField(dataItem, 'BOD_ID')))
        : '';
      if (isAmendRow && binding.startsWith('D_') && fixedDayKeys.has(`${fixRk}${FIX_KEY_SEP}${binding.slice(2)}`)) {
        e.cell.style.backgroundColor = 'rgb(188,229,92)';
        e.cell.classList.remove('wj-cell-editable');
        return;
      }
      if (isAmendRow && binding.startsWith('W_') && fixedWeekKeys.has(`${fixRk}${FIX_KEY_SEP}${weekOrMonthStart.get(binding) ?? ''}`)) {
        e.cell.style.backgroundColor = 'rgb(188,229,92)';
        e.cell.classList.remove('wj-cell-editable');
        return;
      }
      // 편집가능 셀 = 노란색(공통 wj-cell-editable, 자매 CapaMobilityIt/WorkingTime/SalesPlan 동일 패턴).
      //   판정은 beginningEdit 게이트와 동일한 isMainCellEditable 이라 "노란 셀 = 실제 입력 가능" 일치.
      const editable = !!dataItem && isMainCellEditable(binding, dataItem, editCtxRef.current);
      e.cell.classList.toggle('wj-cell-editable', editable);
    };
    g.formatItem.addHandler(formatItemHandler as never);

    // 인접 정보컬럼 세로 병합(SmartColMerge, R-I) — Freeze 경계(measure_label) 이전까지만.
    g.columns.forEach(col => {
      const binding = col.binding ?? '';
      col.allowMerging = binding !== '' && binding !== FREEZE_ANCHOR_COLUMN && !dynColKindOf(binding);
    });
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatItemHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns, bucketType, fixedDayKeys, fixedWeekKeys, weekOrMonthStart, weekToDayBindings]);

  // 헤더 행 높이 고정 — tier 수로 HEADER_TOTAL_HEIGHT 를 나눠 각 헤더 row 에 직접 쓴다(공용 매핑이 명시
  //   height 를 박아 defaultSize 가 무시되므로). 컬럼그룹 재대입마다 되돌아가 updatedLayout 에 재적용.
  //   effect 가 아니라 DataGrid init 콜백으로 처리해 init 순서 레이스(헤더 리셋)를 피한다(SCP0013 동일).
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    const applyHeaderHeight = () => {
      const hdrRows = grid.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      const targetHeight = Math.round(HEADER_TOTAL_HEIGHT / hdrRows.length);
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== targetHeight) {
          hdrRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== targetHeight) {
        hdrRows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    applyHeaderHeight();
    grid.updatedLayout.addHandler(applyHeaderHeight);
  }, []);

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={displayRows as unknown as WijmoRowItem[]}
        staticColumns={staticColumns}
        dynamicColumns={dynamicColumns as unknown as FlexGridColumnConfig[]}
        allowMerging={AllowMerging.All}
        initialized={handleGridInitialized}
        gotFocus={onFocus}
      />
    </>
  );
};
