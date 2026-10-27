import { Aggregate, Globalize, toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type Column,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  GroupRow,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BUCKET_PREFIX,
  BUCKET_TYPE,
  FOOTER_BG_COLOR,
  FOOTER_FORMAT,
  FOOTER_LABEL,
  MAIN_COLUMNS,
  MENU_ID,
  SHEETS,
} from '../sales-monitoring.constants';
import type {
  CurrentWeekInfo,
  SalesMonitoringRow,
  SpreadTitleRow,
} from '../sales-monitoring.types';
import styles from '../SalesMonitoring.module.scss';
import { dynKindOf, getDynKey, HierarchicalMergeManager } from '../utils/sales-monitoring.merge';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위 (AS-IS SetSpreadColumn 표시 매트릭스 판정)
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// 자동 콤보 바인드 파라미터 — MEASURE 등 FPComboBox 콤보 SQL 의 @mnuId 해소용 (안정 참조).
//   admin 'Measure' 콤보(WHERE PROGRAM_ID=@mnuId)가 DataGrid 자동 dataMap 으로 코드→명칭 표시되도록.
//   ⚠ BE makeComboQuery 는 raw 치환(문자열 리터럴은 caller 가 quote) — BE resolveComboBoxDataMaps 도
//     "'"+mnuId+"'" 로 wrap. 따라서 문자열 값은 작은따옴표로 감싸 전달 → PROGRAM_ID = 'DMF0048'.
const COMBO_PARAMS = { mnuId: `'${MENU_ID}'` };

interface Props {
  rows: SalesMonitoringRow[];
  gridRef: Ref<FlexGridType<SalesMonitoringRow>>;
  // F4 Filter — 피처 소유 FlexGridFilter (동적 M_/W_/D_ 컬럼 필터 제외)
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  divisionId?: string;
  bucketType?: BUCKET_TYPE;
  // Sum 체크박스 — 상위 합계(M_/W_) 컬럼 표시 토글 (AS-IS chkSum → SetSpreadColumn L1189)
  sumYn?: boolean;
  // Color 체크박스 — 과거(실적) 구간 회색 표시 (AS-IS chkColor → setResultPeriod L856)
  colorYn?: boolean;
  // admin SYS0004 동적 컬럼 메타 (SCM_MST_SHEET_COLUMNS 54행)
  staticColumns?: RawFlexGridColumnConfig[];
  // DMF0048_GET_SPREAD_TITLE 결과 — 동적 PIVOT 기간 컬럼(라벨/정렬/구조) 1차 소스
  spreadTitle?: SpreadTitleRow[];
  // 메인 SP o_rc2 — 현재 월/주 binding (THIS_YYYYMM/THIS_YYYYMMWW) — 헤더 강조/과거 판정
  currentWeekInfo?: CurrentWeekInfo | null;
}

// FlexGridColumn 렌더링용 통합 column meta
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  // BE DISPLAY_FLAG — "표시 컬럼 세트" 판정 (PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST 실측:
  //   개인화(TITLESET_USER) 있으면 개인화 기준, 없으면 DEFAULT_FLAG AS DISPLAY_FLAG — L197).
  //   2026-07-04 사용자 지시: 최초 조회 = DEFAULT_FLAG='Y' 만 표시 (AS-IS SPREAD_TITLE ELSE 분기 1:1).
  display: boolean;
  // admin SCM_MST_SHEET_COLUMNS.FIXED_FLAG — 컬럼 고정(freeze) 여부 (2026-07-04 사용자 지시:
  //   AS-IS Freeze(0, MEASURE+1) 하드코드 재현 해제 → 메타 위임. 현재 사내 데이터 전행 공란 = 고정 0)
  fixed: boolean;
  scale?: number;
  // hook #92 — admin DIVISION_ID(콤마 토큰 리스트) 가시성
  _divisionAllow?: string;
  // admin CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE — 공유 DataGrid 자동 콤보 dataMap 트리거.
  //   cellCtrlObjTpCd===COMBO && cellCboDataTp 이면 DataGrid 가 useTabComboQueries 로 코드→명칭 자동 매핑.
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

export const SalesMonitoringGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  divisionId,
  bucketType = BUCKET_TYPE.MONTHLY,
  sumYn = false,
  colorYn = false,
  staticColumns,
  spreadTitle,
  currentWeekInfo,
}: Props) => {
  const bucketPrefix = BUCKET_PREFIX[bucketType];

  // formatItem(대형 effect deps 미포함)이 최신값을 참조하도록 ref 미러 (mkt-fcst 패턴)
  const currentWeekInfoRef = useRef(currentWeekInfo);
  currentWeekInfoRef.current = currentWeekInfo;
  const colorYnRef = useRef(colorYn);
  colorYnRef.current = colorYn;

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 DataGrid 는 colWth/display 만 옮기고 색은 안 넘기므로 formatItem 이 직접 적용한다
  //   (mkt-fcst/forecast-price 선례 동일). ref 로 최신 맵 전달 — 핸들러 재등록 불필요.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    (staticColumns ?? []).forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

  // ⭐ admin staticColumns 우선 + MAIN_COLUMNS fallback 병합 (BE 실패 시 화면 작동 보장 — visible fallback 손실 금지)
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    if (!staticColumns || staticColumns.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>(c => ({
        binding: c.key,
        header: c.header,
        width: c.width ?? 100,
        align: c.align ?? 'L',
        visible: c.visible !== false,
        display: c._default === true, // fallback — DEFAULT_FLAG='Y' 스냅샷 (최초 기본 표시 세트)
        fixed: false, // fallback — 메타 미응답 시에도 고정 없음 (admin FIXED_FLAG 위임 정책)
        scale: c.scale,
        _divisionAllow: c._divisionAllow,
        cellCtrlObjTpCd: c._ctrlType as CELL_CONTROL_TYPE | undefined,
        cellCboDataTp: c._comboKey,
      }));
    }
    return staticColumns.map(col => {
      const fb = MAIN_COLUMNS.find(m => m.key === col.colNm);
      return {
        binding: col.colNm,
        header: col.colLblNm || fb?.header || col.colNm,
        width: col.colWth ?? fb?.width ?? 100,
        align: col.horzAlgnCd ?? fb?.align ?? 'L',
        visible: col.visible !== false,
        display: col.display === true, // BE 계산값 (개인화 있으면 개인화 / 없으면 DEFAULT_FLAG)
        fixed: col.fixed === true, // admin FIXED_FLAG='Y' 시에만 고정
        scale: col.scale ?? fb?.scale,
        // hook #92 — 1순위 ATTRIBUTE3(정식 복사값), 2순위 ATTRIBUTE1, 3순위 fallback 스냅샷 토큰
        _divisionAllow: col.attribute3?.trim() || col.attribute1?.trim() || fb?._divisionAllow,
        // admin 콤보 메타 승계 (없으면 MAIN_COLUMNS fallback) → DataGrid 자동 dataMap
        cellCtrlObjTpCd: col.cellCtrlObjTpCd ?? (fb?._ctrlType as CELL_CONTROL_TYPE | undefined),
        cellCboDataTp: col.cellCboDataTp ?? fb?._comboKey,
      } as MergedColumnMeta;
    });
  }, [staticColumns]);

  // 표시 컬럼 판정 3중 (2026-07-04 사용자 지시 — 최초 조회 DEFAULT='Y' + DIVISION 적용):
  //   ① display (BE: 개인화 있으면 개인화 / 없으면 DEFAULT_FLAG='Y' — AS-IS SPREAD_TITLE 정본 1:1)
  //   ② visible (VISIBLE_FLAG — 'N' = 숨김 데이터 컬럼)
  //   ③ division 토큰 (hook #92 — 콤마 토큰 정확 일치, substring 금지)
  const visibleColumns = useMemo(
    () =>
      mergedColumns.filter(c => {
        if (!c.display) return false;
        if (!c.visible) return false;
        const allow = c._divisionAllow?.trim();
        if (!allow) return true;
        if (!divisionId) return true;
        return allow
          .split(',')
          .map(s => s.trim())
          .includes(divisionId);
      }),
    [mergedColumns, divisionId]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.binding), [visibleColumns]);

  // ⭐ 동적 기간 컬럼 메타 — GET_SPREAD_TITLE 결과 1차 소스, 부재 시 데이터 row 키 union fallback
  type DynColMeta = {
    binding: string;
    kind: 'M' | 'W' | 'D';
    large: string;
    small: string;
    leaf: string;
    sort: number;
  };
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => !!dynKindOf(r.COLUMN_NAME ?? ''));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: r.COLUMN_NAME,
          kind: dynKindOf(r.COLUMN_NAME)!,
          large: r.LARGE_CLASS_LABEL_NAME ?? '',
          small: r.SMALL_CLASS_LABEL_NAME ?? '',
          leaf: r.COLUMN_LABEL_NAME ?? '',
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (dynKindOf(k)) set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>(b => {
      const dyn = getDynKey(b);
      return {
        binding: b,
        kind: dyn.kind!,
        large: dyn.ym,
        small: dyn.sub,
        leaf: dyn.leaf,
        sort: 0,
      };
    });
  }, [spreadTitle, rows]);

  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // AS-IS SetSpreadColumn 표시 매트릭스 (L1189~1222) 1:1:
  //   Daily  : D_=표시 / W_·M_=chkSum   → summary = rank<D
  //   Weekly : W_=표시 / D_=숨김 / M_=chkSum
  //   Monthly: M_=표시 / D_·W_=숨김
  const summaryBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] < DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  const hiddenBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] > DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );

  // ⭐ DataGrid wrapper 의무 — 컬럼 고정(freeze)은 admin FIXED_FLAG 위임 (2026-07-04 사용자 지시로
  //   AS-IS Freeze(0, MEASURE+1) 하드코드 재현을 해제. 현재 메타 전행 공란 = 고정 0. admin 에서
  //   FIXED_FLAG='Y' 등록 시 화면 수정 없이 즉시 반영 — wrapper 가 fixed findLastIndex+1 로 계산)
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        colNm: c.binding,
        colLblNm: c.header,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        // read-only 화면 — 전 컬럼 'S' (사내 SHEET_COLUMNS INPUT_TP_CD 실측 전행 'S')
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        scale: c.scale,
        // ⭐ 콤보 메타 승계 → 공유 DataGrid 자동 dataMap (MEASURE 등 FPComboBox 컬럼 코드→명칭 자동 표시).
        //   inputTpCd='S'(읽기전용)여도 dataMap 은 표시 매핑만 담당 — 편집화되지 않음.
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // ⭐ 동적 PIVOT 컬럼 — 3단 nested (대상년월 → 주차/SUM → leaf/SUM). AS-IS SetSpreadHeaderSpan 1:1:
  //   kind M: 2단='SUM'/3단='SUM' (세로 머지) / kind W: 2단=주차·3단='SUM' / kind D: 2단=주차·3단=일자
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    type SubBucket = Map<string, LeafCol[]>;
    type LargeBucket = { label: string; subs: SubBucket; order: number };
    const largeMap = new Map<string, LargeBucket>();
    const kindRank = { M: 0, W: 1, D: 2 } as const;
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey =
        m.kind === 'M'
          ? 'SUM'
          : m.kind === 'W'
            ? (
                m.small ||
                (/^W_\d{7,9}$/.test(m.binding) && !/^W_\d{8}$/.test(m.binding)
                  ? `W${m.binding.slice(8)}`
                  : getDynKey(m.binding).sub)
              ).trim() || 'SUM'
            : (m.small || getDynKey(m.binding).sub).trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)!.push({
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf || m.small || 'SUM' : 'SUM',
        align: 'right',
        format: 'n3',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // (height 미지정 — hook #93 P-B 원칙1: 높이 조작은 아래 불변식 effect 단일 출처, 중복 금지)
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // read-only
        _ctrlType: CELL_CONTROL_TYPE.NUMBER, // B-4 — Excel export 시 숫자 타입 (AS-IS FPNumber 1:1)
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas]);

  // 과거(실적) 구간 판정 — AS-IS setResultPeriod(L856~948) 1:1: 현재 기간 이전 컬럼 = Gainsboro,
  //   현재 월(M_)은 White 예외. 판정 입력 = o_rc2(THIS_YYYYMM/THIS_YYYYMMWW) + 오늘.
  const isPastBinding = (binding: string): boolean => {
    const cw = currentWeekInfoRef.current;
    const kind = dynKindOf(binding);
    if (!kind) return false;
    const todayYmd = dayjs().format('YYYYMMDD'); // 로컬 날짜 (A-3 — toISOString UTC 하루 어긋남 금지)
    if (kind === 'D') return binding.slice(2) < todayYmd;
    const thisYm = (cw?.BASIS_YYYYMM ?? todayYmd.slice(0, 6)).trim();
    if (kind === 'M') return binding.slice(2) < thisYm;
    // W_yyyymm+ISO_WEEK — (년월, 주차) 튜플 비교
    const ym = binding.slice(2, 8);
    const wk = Number(binding.slice(8) || 0);
    const thisWk = Number((cw?.ISO_WEEK ?? '0').trim() || 0);
    return ym < thisYm || (ym === thisYm && wk < thisWk);
  };

  // ⭐ grid 핸들러 + mergeManager useEffect 등록 (deps=[staticColumns, dynamicColumns] 규약)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGridType<SalesMonitoringRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;

      // 하단 합계 줄 — AS-IS InitSpreadFooterSum(.cs L419~421) 1:1: 기간 컬럼은 {0:#,##0.###} 서식,
      //   LightGray 배경. 라벨 셀(정적 컬럼)은 배경만 맞춘다. 집계값은 아래 footer effect 의
      //   col.aggregate=Sum 이 CollectionView 필터 적용 뷰로 계산한 값(숨긴 행 제외)이다.
      if (e.panel.cellType === CellType.ColumnFooter) {
        e.cell.style.backgroundColor = FOOTER_BG_COLOR;
        const footerBinding = col.binding ?? '';
        if (dynKindOf(footerBinding)) {
          e.cell.style.textAlign = 'right';
          const n = toGridNumber(e.panel.getCellData(e.row, e.col, false));
          e.cell.textContent = Globalize.format(n, FOOTER_FORMAT);
        }
        return;
      }

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        const binding = col.binding ?? '';
        const cw = currentWeekInfoRef.current;
        const lastHeaderRow = e.panel.rows.length - 1;
        // 현재기간 rail 의 헤더 구간 — 당주(W_) 헤더 왼쪽에도 같은 선을 그어 아래 데이터셀 border-left 와
        //   한 줄로 이어지게 한다. 미대상 셀은 removeProperty 로 리셋 (Wijmo 셀 재활용 잔상 제거) →
        //   아래 주말 헤더 early return 보다 먼저 세팅해야 재활용된 셀에 선이 남지 않는다.
        if (dynKindOf(binding) === 'W' && binding === (cw?.THIS_YYYYMMWW ?? '').trim()) {
          e.cell.style.setProperty('border-left', '2px solid #1e8449', 'important');
        } else {
          e.cell.style.removeProperty('border-left');
        }
        // ⭐ D_ leaf(일자) 헤더 주말 색 — AS-IS SetSpreadHeaderSpan L1340~1343 (토=Blue/일=Red)
        if (e.row === lastHeaderRow && /^D_\d{8}$/.test(binding)) {
          const d = binding.slice(2);
          const dow = new Date(
            Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8))
          ).getUTCDay();
          if (dow === 6) {
            e.cell.style.color = '#1e56c8';
            return;
          }
          if (dow === 0) {
            e.cell.style.color = '#c0392b';
            return;
          }
        }
        // ⭐ AS-IS chkColor=false 경로 (SetSpreadColumn L1224~1286) — 현재 월/주 헤더 초록 Bold.
        //   chkColor=true 시 헤더 강조 해제 (AS-IS L1287~1291 ResetForeColor/ResetFont).
        const isCurrentPeriod =
          !colorYnRef.current &&
          !!binding &&
          (binding === (cw?.THIS_YYYYMM ?? '').trim() ||
            binding === (cw?.THIS_YYYYMMWW ?? '').trim());
        e.cell.style.color = isCurrentPeriod ? '#1e8449' : e.cell.style.color || '';
        e.cell.style.fontWeight = isCurrentPeriod ? '700' : '';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = col.binding ?? '';
      if (!binding) return;

      // 현재기간 rail — 당주(W_ = o_rc2 THIS_YYYYMMWW) 컬럼 데이터셀 왼쪽 초록 2px 세로선 1줄.
      //   당월 M_ SUM·당일 D_ 는 제외. Color 체크박스는 화면에서 제거됐으므로 무조건 그린다.
      //   헤더 rail 과 동일하게 inline style 단일 소스 (CSS 클래스는 Wijmo 셀 border 에 밀려 미적용).
      //   미대상 셀은 removeProperty 로 리셋 — 정적 컬럼 포함 전 셀이 이 줄을 지나므로 재활용 잔상 없음.
      if (
        dynKindOf(binding) === 'W' &&
        binding === (currentWeekInfoRef.current?.THIS_YYYYMMWW ?? '').trim()
      ) {
        e.cell.style.setProperty('border-left', '2px solid #1e8449', 'important');
      } else {
        e.cell.style.removeProperty('border-left');
      }

      // ⭐ Color 체크 시 과거(실적) 구간 회색 (AS-IS setResultPeriod 1:1 — 현재 월 White 예외는
      //   isPastBinding 의 '<' 비교가 자연 보장). #95 — 잠금 Gray 는 특수 목적 셀만 허용 → 본
      //   화면의 Gray = AS-IS 실적구간 표시 기능 그 자체 (read-only 화면, 편집 Yellow 없음).
      if (dynKindOf(binding)) {
        const gray = colorYnRef.current && isPastBinding(binding);
        toggleClass(e.cell, 'wj-cell-non-editable', gray);
        return;
      }
      // 식별 컬럼 — 클래스 없는 White (#95)
      toggleClass(e.cell, 'wj-cell-non-editable', false);
      toggleClass(e.cell, 'wj-cell-editable', false);

      // ⭐ 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 대상 (동적 기간 컬럼은 위에서 return).
      //   read-only 화면이라 편집 하이라이트와 경합 없음. 미지정 시 removeProperty 필수 —
      //   Wijmo 셀 재활용으로 이전 컬럼 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      if (personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };
    g.formatItem.addHandler(formatHandler);

    // read-only 가드 — 전 셀 편집 차단 (wrapper 'S' 처리 + 명시 cancel 이중 방어.
    //   AS-IS: FindButton/ExcelButton 만 override, 저장 스택 데드코드 — 사용자 확정 2026-07-04)
    const beginningEditHandler = (_s: FlexGridType<SalesMonitoringRow>, e: { cancel: boolean }) => {
      e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Scroll 시 머지 그룹 재계산 — AS-IS spdMain_TopChange(SmartColMerge L1122) 1:1 + viewport sticky #38
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 + HierarchicalMergeManager =====
    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new HierarchicalMergeManager(fixedBindings);
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, fixedBindings]);

  // ⭐ hook #93 P-B v2 — 다단 헤더 총높이 48px "불변식" (DMF0020 PriceBatchInput 재발 fix 표준,
  //   2026-07-02 검증분 1:1). 컬럼설정 OK → DataGrid key 변경 → 그리드 인스턴스 교체 시 updatedLayout
  //   핸들러가 죽은 인스턴스에 잔존해 비대화가 재발하는 사고를 rAF 상시 감시로 원초 차단:
  //   (a) gridRef.current 교체 감지 → 살아있는 인스턴스에 핸들러 이관
  //   (b) 존재 행 높이 = 48/실제 행수 + defaultSize 동시 강제 (정적 컬럼 잔여 48 정규화 포함)
  //   목표 상태면 early-exit (프레임당 속성 비교 수준). 높이 조작은 본 effect 단일 출처 (#93 6.6).
  //   ⚠ wrapper `headerRowHeight` prop 단독(defaultSize만)은 정적 잔여로 무효 — #93 검증 보강 명시.
  useEffect(() => {
    let raf = 0;
    let attached: FlexGridType<SalesMonitoringRow> | null = null;
    const normalize = (g: FlexGridType<SalesMonitoringRow>) => {
      const hdr = g.columnHeaders?.rows;
      if (!hdr || hdr.length === 0) return;
      const per = Math.max(1, Math.round(48 / hdr.length));
      let changed = false;
      if (Math.round(hdr.defaultSize) !== per) {
        hdr.defaultSize = per;
        changed = true;
      }
      for (let i = 0; i < hdr.length; i++) {
        if (Math.round(hdr[i].height ?? 0) !== per) {
          hdr[i].height = per;
          changed = true;
        }
      }
      if (changed) g.invalidate(false);
    };
    const onLayout = () => {
      if (attached) normalize(attached);
    };
    const tick = () => {
      const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
      if (g && g !== attached) {
        try {
          attached?.updatedLayout?.removeHandler(onLayout);
        } catch {
          /* dead instance */
        }
        g.updatedLayout.addHandler(onLayout);
        attached = g;
      }
      if (g) normalize(g);
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout?.removeHandler(onLayout);
      } catch {
        /* dead instance */
      }
    };
  }, [gridRef]);

  // ⭐ Sum 체크박스 — 동적 컬럼 visible 매트릭스 (AS-IS SetSpreadColumn 1:1 — 활성 bucket=표시 /
  //   상위 합계=sumYn / 하위=숨김). wrapper columnGroups 재적용이 visible 을 덮을 수 있어
  //   updatedLayout 마다 재적용 (mkt-fcst 동일 가드 패턴). 헤더 드릴다운 없음 — AS-IS
  //   spdMain_CellDoubleClick 은 빈 핸들러 (.cs L1385~1388).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
    if (!g) return;
    const summarySet = new Set(summaryBindings);
    const hiddenSet = new Set(hiddenBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다 — Column
      //   객체의 커스텀 플래그는 wijmo 생성자가 `_` 로 시작하는 키를 무시해 전달되지 않는다).
      const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        // Hide Column 으로 숨긴 컬럼은 sum 재계산 대상에서 제외 — 숨김 유지.
        if (userHiddenColumns?.has(b)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
        const want = summarySet.has(b) ? sumYn : hiddenSet.has(b) ? false : true;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, hiddenBindings, dynBindings, gridRef]);

  // 하단 합계 줄 — AS-IS InitSpreadFooterSum(.cs L408~425) 1:1. 기간 컬럼(M_/W_/D_)만 Aggregate.Sum,
  //   좌측 첫 컬럼 라벨 'Sum'. 집계는 Wijmo CollectionView.getAggregate 가 필터 적용 뷰로 계산하므로
  //   F4 필터로 숨긴 행은 자동 제외(= AS-IS SumIgnoreHidden). 조회 결과가 없으면 footer 를 빼서
  //   헤더만 남긴다(형제 CustFcstWaterfallGrid 동일 처리). 공용 DataGrid 가 staticColumns/
  //   dynamicColumns 변경 때 컬럼 객체를 다시 만들어 aggregate 가 사라질 수 있어 updatedLayout 마다
  //   재적용한다(위 applyDynVisibility 와 같은 가드 패턴, 변경 없으면 invalidate 하지 않는다).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
    if (!g) return;
    const hasData = rows.length > 0;
    if (!hasData) {
      if (g.columnFooters.rows.length > 0) g.columnFooters.rows.clear();
      return;
    }
    // 라벨을 쓴 첫 컬럼 객체 — footer 라벨 값은 Column 객체 단위로 저장되므로 wrapper 가 컬럼을
    //   다시 만들면 다시 써야 한다. 값 read-back 비교 대신 객체 동일성으로 판정해 재진입 루프를 막는다.
    let labeledCol: Column | null = null;
    const applyFooter = () => {
      let changed = false;
      if (g.columnFooters.rows.length === 0) {
        g.columnFooters.rows.push(new GroupRow());
        changed = true;
      }
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const want = dynKindOf(col.binding ?? '') ? Aggregate.Sum : Aggregate.None;
        if (col.aggregate !== want) {
          col.aggregate = want;
          changed = true;
        }
      }
      // 라벨은 기간 컬럼이 아닌 첫 컬럼에만 쓴다(기간 컬럼이면 집계값이 우선이라 라벨이 안 보인다).
      const firstCol = g.columns[0] ?? null;
      if (firstCol && firstCol !== labeledCol && !dynKindOf(firstCol.binding ?? '')) {
        g.columnFooters.setCellData(0, 0, FOOTER_LABEL, false, false);
        labeledCol = firstCol;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyFooter);
    applyFooter();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyFooter);
      } catch {
        /* unmount race */
      }
    };
  }, [rows, mainStaticColumns, mainDynamicColumns, gridRef]);

  // 현재 주/월 헤더 강조 + Color 토글 — 응답/토글 갱신 시 formatItem 재실행
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
    g?.invalidate(true);
  }, [currentWeekInfo, colorYn, gridRef]);

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesMonitoringRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const onFilterApplied = () => g.invalidate(true);

    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef]);

  return (
    // <div className={styles.gridContainer}>
    <DataGrid
      className={styles.grid}
      gridRef={gridRef as never}
      staticColumns={mainStaticColumns}
      dynamicColumns={mainDynamicColumns}
      comboParams={COMBO_PARAMS}
      // 이 그리드의 셀 콤보에 시트 스코프 sheetName 을 함께 실어 @sheetName 을 해소한다(mnuId 와 짝).
      sheetName={SHEETS.MAIN}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      // allowSorting prop 은 넘기지 않는다 - grid.allowSorting 이 truthy 면 wijmo
      //   _MouseHandler._mousedown 이 헤더 클릭 시 열 전체 선택(_mouseSelect)을 건너뛴다.
      //   공용 정렬(F3 스위치 + 헤더 클릭 + 아이콘)은 이 prop 없이도 그대로 동작한다.
      allowMerging={AllowMerging.All}
      isReadOnly={true}
    />
    // </div>
  );
};
