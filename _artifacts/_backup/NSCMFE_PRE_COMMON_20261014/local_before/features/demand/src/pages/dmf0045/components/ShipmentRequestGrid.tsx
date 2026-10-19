import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import styles from 'features/demand/src/pages/dmf0045/ShipmentRequest.module.scss';
import { type MutableRefObject, type Ref, useCallback, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, keepRowVisibleUnderFilter, paintNegativeText } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { isoWeeksOfMonth } from '@shared/lib/bucket-distribution';

import { BUCKET_TYPE, MENU_ID } from '../dmf0045.constants';
import type { ActiveSheet, ShipmentRequestRow, SpreadTitleRow } from '../dmf0045.types';
import {
  dynKindOf,
  evalShipmentDynCell,
  insertStaticEditable,
  isInsertModalCell,
} from '../utils/dmf0045.editLock';
import { toCellStr } from '../utils/dmf0045.gridCombos';
import {
  getDynKey,
  getMonthWeekKeysInRange,
  HierarchicalMergeManager,
} from '../utils/dmf0045.merge';
import { dayCodeToMask, expandBucketToDays } from '../utils/dmf0045.recalc';

import type { ShipmentModalKey } from './ShipmentRequestModals';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위. 표시 규칙/드릴다운 판정용 (sales-plan 동일).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

interface ShipmentRequestGridProps {
  rows: ShipmentRequestRow[];
  gridRef: Ref<FlexGridType<ShipmentRequestRow>>;
  // tabId 는 Props 계약상 유지(부모 전달) — 그리드 내부 조회가 없어 소비하지 않는다.
  tabId: string;
  // F4 Filter — 피처가 FlexGridFilter 직접 소유. 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적(Red 마킹 단일 소스) + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  divisionId: string;
  bucketType: BUCKET_TYPE;
  // Sum 체크박스 — 상위 버킷 합계 컬럼(M_/W_) 표시 토글 (AS-IS chkSum — 조회 없이 즉시 반영).
  sumYn: boolean;
  activeSheet: ActiveSheet;
  // 조회 기간 — GET_SPREAD_TITLE 이 월 시작 주만 내려줄 때 월경계 주차 binding 보완용.
  startYyyymmdd: string;
  endYyyymmdd: string;
  // admin SYS0004 UI Category Setup 동적 메타 (SHEET_COLUMNS — division 서버 필터, 하드코딩 fallback 없음).
  staticColumns: RawFlexGridColumnConfig[];
  // P_DMF0045_GET_SPREAD_TITLE 결과 — 동적 3단 헤더(라벨/정렬/구조)의 1차 소스.
  spreadTitle: SpreadTitleRow[];
  // 셀 모달 3종 — PROJECT_CODE(SCM0002) / TR_MODE(DMF0046 BOD) / ITEM_ID(DMF0047). 신규행(I)만.
  onPopupCellDblClick: (modalKey: ShipmentModalKey, row: ShipmentRequestRow) => void;
}

// 숫자 변환 — 콤마 제거, 비숫자 0.
const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// MEASURE_COLOR 콤마 RGB → CSS rgb() (design 03 §3 cs 662-681 — Measure 셀 글자색).
//   'r,g,b' 3요소만 인정. 그 외(빈값/형식오류)는 '' 로 무시 — 잘못된 색을 조용히 만들지 않는다.
const measureColorToCss = (raw: unknown): string => {
  const parts = toCellStr(raw)
    .split(',')
    .map(p => p.trim());
  if (parts.length !== 3) return '';
  if (parts.some(p => !/^\d{1,3}$/.test(p) || Number(p) > 255)) return '';
  return `rgb(${parts[0]}, ${parts[1]}, ${parts[2]})`;
};

export const ShipmentRequestGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  divisionId,
  bucketType,
  sumYn,
  activeSheet,
  startYyyymmdd,
  endYyyymmdd,
  staticColumns,
  spreadTitle,
  onPopupCellDblClick,
}: ShipmentRequestGridProps) => {
  const division = divisionId ?? '';
  // 필터 예외 재등록(reapplyInsertRowVisibility)이 최신 rows 를 보게 하는 미러.
  const rowsRef = useRef<ShipmentRequestRow[]>([]);
  rowsRef.current = rows;

  // MEASURE 콤보 개방 게이트 — 빈 그리드에 넣은 유일한 행일 때만 열린다(AS-IS cs 1012
  //   GetMaxRowIndex()==0 = 삽입 후 총 1행). 조회결과가 있거나 신규행이 2개 이상이면 잠금(SHIP_REQ 고정).
  //   wijmo 핸들러가 초기화 useEffect 클로저에 갇히므로 최신 rows 를 rowsRef 로 읽는다(stale 방지).
  const isSoleRow = (): boolean => rowsRef.current.length === 1;

  const bucketPrefix =
    bucketType === BUCKET_TYPE.MONTHLY ? 'M' : bucketType === BUCKET_TYPE.DAILY ? 'D' : 'W';

  // 정적 컬럼 — admin(UI Category Setup) 메타 100% 주도. 하드코딩/화이트리스트 금지.
  //   FE 는 VISIBLE_FLAG(admin 관리 노출) + DISPLAY_FLAG(사용자 Column Setup 선택) 만 반영.
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.colNm), [visibleColumns]);
  const staticBindingSet = useMemo(() => new Set(fixedBindings), [fixedBindings]);

  // 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 DataGrid 는 colWth/display 만 옮기고 색은 안 넘기므로 formatItem 이 직접 적용한다.
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

  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        ...c,
        visible: true,
        display: true,
      })),
    [visibleColumns]
  );

  // 금지: 여기서 DataMap 을 만들어 col.dataMap 에 붙이지 말 것. 셀 콤보(Incoterms/FCST_TYPE/Measure)
  //   의 후보·표시·행별 좁힘은 전부 컬럼 메타(cellCboDataTp / PARAM2 / PARAM9 / PARAM10)가 단일
  //   원천이고 공용 DataGrid 가 그 메타대로 만든다. 화면이 col.dataMap 을 덮으면 그 설정이 무효가 된다.
  //   MEASURE 재조회형(division/scmSite 스코프)도 comboParams.divisionId 로 공용 계층이 해소한다 —
  //   design 03 §6 의 재조회 SQL 스코프는 확인필요(추측 narrowing 금지, __asis-mapping__ 기록).

  // 동적 기간 컬럼 메타 — GET_SPREAD_TITLE 를 1차 소스로 사용 (DB_* 는 kindOf null 로 자동 제외 = 항상 숨김).
  type DynColMeta = {
    binding: string;
    kind: 'M' | 'W' | 'D';
    large: string;
    small: string;
    leaf: string;
    sort: number;
  };
  // 동적 컬럼 fallback(spreadTitle 부재 시)만 rows 를 쓴다 — 그것도 '동적 키 집합' 만 본다.
  //   rows 배열 자체를 dep 에 두면 행추가마다 참조가 바뀌어 columnGroups 가 새 참조가 되고
  //   Wijmo 가 전 컬럼을 재생성 → 다단 헤더 높이가 한 프레임 깜빡인다(sales-plan 2026-09-02 리포트).
  //   따라서 배열 대신 동적 키 서명(내용이 바뀔 때만 값이 바뀌는 문자열)에만 의존시킨다.
  const rowDynKeySig = useMemo(() => {
    if ((spreadTitle?.length ?? 0) > 0) return ''; // spreadTitle 우선 경로 — rows 미참조
    if (!rows || rows.length === 0) return '';
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (/^M_\d{6}$/.test(k) || /^W_\d{7,10}$/.test(k) || /^D_\d{8}$/.test(k)) set.add(k);
      }
    }
    return [...set].sort().join(',');
  }, [spreadTitle, rows]);
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
      /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;
    // (1) GET_SPREAD_TITLE 우선
    const titleMetas = (spreadTitle ?? []).flatMap<DynColMeta>(r => {
      const binding = String(r.COLUMN_NAME ?? '');
      const kind = kindOf(binding);
      if (!kind) return [];
      return [
        {
          binding,
          kind,
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        },
      ];
    });
    if (titleMetas.length > 0) {
      // AS-IS 는 월 경계 주차를 양쪽 월에 모두 표시한다. TO-BE SP 가 주 시작 월에만
      //   반환하는 경우 조회기간에서 누락 binding 만 보완한다.
      if (titleMetas.some(meta => meta.kind === 'W')) {
        const existing = new Set(titleMetas.map(meta => meta.binding));
        const largeLabelByMonth = new Map(
          titleMetas.map(meta => [meta.binding.slice(2, 8), meta.large] as const)
        );
        const maxSort = Math.max(...titleMetas.map(meta => meta.sort), 0);
        getMonthWeekKeysInRange(startYyyymmdd, endYyyymmdd).forEach((binding, index) => {
          if (existing.has(binding)) return;
          const ym = binding.slice(2, 8);
          titleMetas.push({
            binding,
            kind: 'W',
            large: largeLabelByMonth.get(ym) || `${ym.slice(0, 4)}-${ym.slice(4)}`,
            small: `W${binding.slice(8)}`,
            leaf: '',
            sort: maxSort + index + 1,
          });
        });
      }
      return titleMetas.sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    // (2) fallback — 데이터 row 키 union (라벨 = binding 파생). rowDynKeySig 이 정렬·중복제거 완료.
    if (!rowDynKeySig) return [];
    return rowDynKeySig.split(',').flatMap<DynColMeta>(binding => {
      const kind = kindOf(binding);
      if (!kind) return [];
      const dyn = getDynKey(binding);
      return [{ binding, kind, large: dyn.ym, small: dyn.sub, leaf: dyn.leaf, sort: 0 }];
    });
  }, [spreadTitle, rowDynKeySig, startYyyymmdd, endYyyymmdd]);

  // binding 순서 목록 + 표시 규칙 rank 분리 (활성 bucket=표시 / 상위 합계=sumYn / 하위=드릴 전용).
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // 정렬된 D_ binding 목록 — SHIP_FROZEN 선두 D_ 잠금 판정 기준(오름차순).
  const dOrderedDayBindings = useMemo<string[]>(
    () =>
      dynColMetas
        .filter(m => m.kind === 'D')
        .map(m => m.binding)
        .sort(),
    [dynColMetas]
  );
  const dOrderedDayBindingsRef = useRef<string[]>(dOrderedDayBindings);
  dOrderedDayBindingsRef.current = dOrderedDayBindings;
  const summaryBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] < DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  const drillBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] > DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  // 드릴 오버라이드(binding → visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // DefaultBucketDay 적용요일 — W_/M_ 입력분을 하위 D_ 로 전개할 때 배분 요일(design 03 §2.4/§6).
  //   콤보 SQL_ID='DefaultBucketDay'(@divisionId,@bucketType) = LOOKUP DEFAULT_BUCKET_DAY 실측
  //   (40→MON, 81*/82→FRI). CODE=요일코드(SEGMENT3). 미조회/미등록이면 dayCodeToMask 가 무마스크로
  //   떨어져 공용 유틸 fallback(월요일/첫 일자)을 따른다 — 추측 마스크를 만들지 않는다.
  const [defaultBucketDayCombo] = useTabComboQueries({
    filters: [{ comboId: 'DefaultBucketDay', divisionId: division, bucketType }],
    enabled: !!division,
  });
  const bucketDayMask = dayCodeToMask(
    (defaultBucketDayCombo as Array<{ CODE?: string }> | undefined)?.[0]?.CODE
  );
  // 핸들러 설치 effect(cellEditEnded)가 콤보 조회 완료 전에 실행될 수 있어 ref 로 최신값을 읽는다
  //   (dOrderedDayBindingsRef 동일 패턴 — 재설치 없이 최신 마스크 참조).
  const bucketDayMaskRef = useRef<string>(bucketDayMask);
  bucketDayMaskRef.current = bucketDayMask;

  // 동적 PIVOT 컬럼 — 3단 nested (대상년월 → 주차/SUM → leaf). 라벨 = GET_SPREAD_TITLE 제공값.
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    type SubBucket = Map<string, LeafCol[]>;
    type LargeBucket = { label: string; subs: SubBucket; order: number };
    const largeMap = new Map<string, LargeBucket>();
    const kindRank = { M: 0, W: 1, D: 2 } as const; // sub 내 leaf 순서 — 합계(W) 먼저, 일자(D) 다음
    dynColMetas.forEach((m, idx) => {
      // 1단 그룹 키 = binding 의 yyyymm (라벨은 large). 라벨만으로 묶으면 동명 월 충돌 → binding 기준.
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      // 2단 키 — kind 기반. W 는 SP small('Wxx') 우선, 없으면 binding 파생.
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
      let subColumns = bucket.subs.get(subKey);
      if (!subColumns) {
        subColumns = [];
        bucket.subs.set(subKey, subColumns);
      }
      subColumns.push({
        binding: m.binding,
        // 3단(leaf) 라벨 — M/W 합계는 'SUM' / D=일자(m.leaf).
        header: m.kind === 'D' ? m.leaf || m.small || 'SUM' : 'SUM',
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48, // 다단 헤더 높이(#93) — wrapper 가 staticColumns 만 자동 처리, 동적은 명시 의무.
        _display: true,
        format: '#,##0.###',
      });
    });
    // sub 정렬: 'SUM'(월합계) 최우선 → 주차 오름차순. leaf 정렬: 합계(M/W) 먼저 → 일자 binding 순.
    //   주차는 숫자 크기가 아니라 그 달의 실제 시간순으로 놓는다 (연말·연초 W53→W01 역전 방지).
    const subOrder = (label: string, leafCols: LeafCol[]): number => {
      if (label === 'SUM') return -1;
      const ym = leafCols[0]?.binding.slice(2, 8) ?? '';
      const week = Number(label.replace(/\D/g, '') || 0);
      const chronologicalIndex = isoWeeksOfMonth(ym).findIndex(item => item.isoWeek === week);
      return chronologicalIndex >= 0 ? chronologicalIndex : week;
    };
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: 48,
        columns: [...bucket.subs.entries()]
          .sort(([a, aCols], [b, bCols]) => subOrder(a, aCols) - subOrder(b, bCols))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: 48,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas]);

  // grid 핸들러 + mergeManager useEffect 등록.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // 홀짝 zebra (#95)
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGridType<ShipmentRequestRow>, e: FormatItemEventArgs) => {
      // #108 — No. 코너 헤더 (TopLeft 단일 라벨)
      if (e.panel.cellType === CellType.TopLeft) {
        const label = e.col === 0 ? 'No.' : '';
        if (e.cell.textContent !== label) e.cell.textContent = label;
        e.cell.style.textAlign = 'center';
        return;
      }
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;

      const binding = col.binding;
      // 음수 = 빨간 글자 (그리드 공통 규약. 정본 @foundation/utils paintNegativeText).
      //   필수: 진입 직후 한 번만 칠한다 — 아래 분기들이 각자 return 하므로 분기 안에서 부르면
      //   정적/동적 어디에도 안 걸리는 컬럼이 통째로 빠진다.
      paintNegativeText(e.cell, toNumber(e.panel.getCellData(e.row, e.col, false)));
      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: ShipmentRequestRow })
        ?.dataItem;
      const isDyn = !staticBindingSet.has(binding) && !!dynKindOf(binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';

      if (isDyn) {
        // editLock R1~R4 — 편집가능 Yellow / 비편집 measure 음영 Gray / 그 외 White (#95).
        const state = evalShipmentDynCell({
          binding,
          row: rowItem,
          bucketType,
          dOrderedDayBindings: dOrderedDayBindingsRef.current,
        });
        toggleClass(e.cell, 'wj-cell-editable', state.editable);
        // 비편집 measure 행(화이트리스트 밖) = Gray 음영 (design 03 §3 — 컬럼이 아니라 행 차원).
        toggleClass(e.cell, 'wj-cell-non-editable', state.shaded);
        // 변경 셀 Red (EditTracker 단일 소스 + 신규 행 입력 셀)
        const tracked =
          rowItem &&
          (
            editTrackerRef?.current?.getOriginalValues() as
              | Map<ShipmentRequestRow, Record<string, unknown>>
              | undefined
          )?.get(rowItem)?.[binding] !== undefined;
        const insertInput = isInsert && rowItem?.[binding] != null && rowItem?.[binding] !== '';
        toggleClass(e.cell, 'sp-cell-changed', !!tracked || !!insertInput);
        return;
      }

      // MEASURE 셀 — indent 보존(콤보 dataMap 계층) + MEASURE_COLOR 콤마 RGB 글자색(cs 662-681).
      if (binding === 'MEASURE') {
        e.cell.style.whiteSpace = 'pre';
        const measureColor = measureColorToCss(rowItem?.MEASURE_COLOR);
        if (measureColor) e.cell.style.setProperty('color', measureColor, 'important');
        else e.cell.style.removeProperty('color');
      }

      // 정적 셀 — Insert 행 화이트리스트(R5) = Yellow. 모달 셀 아이콘 (PROJECT_CODE/TR_MODE/ITEM_ID).
      if (rowItem && isInsert) {
        const isModalCell = isInsertModalCell(binding, rowItem, division);
        const editable =
          insertStaticEditable(binding, rowItem, division, isSoleRow()) ||
          isModalCell;
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        toggleClass(e.cell, 'wj-cell-popup', false); // wrapper 자동 토글 무력화 (전용 span 사용)
        if (isModalCell) {
          const cellEl = e.cell;
          cellEl.style.cursor = 'pointer';
          cellEl.style.paddingRight = '20px';
          if (!cellEl.querySelector('.popup-icon')) {
            const icon = document.createElement('span');
            icon.className = `popup-icon ${styles.popupIcon}`;
            cellEl.appendChild(icon);
          }
        } else {
          e.cell.querySelector('.popup-icon')?.remove();
        }
      } else if (binding !== 'MEASURE') {
        toggleClass(e.cell, 'wj-cell-editable', false);
        e.cell.querySelector('.popup-icon')?.remove();
      }

      // 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return).
      //   우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color. inline !important 라 클래스보다
      //   세므로 편집 가능 Insert 셀에는 배경을 칠하지 않는다.
      const personalColor = colorMetaRef.current.get(binding);
      const insertEditable =
        !!rowItem &&
        isInsert &&
        (insertStaticEditable(binding, rowItem, division, isSoleRow()) ||
          isInsertModalCell(binding, rowItem, division));
      if (!insertEditable && personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      // 글자색 우선순위: MEASURE 는 위에서 MEASURE_COLOR 로 이미 처리(여기서 건드리지 않는다) >
      //   음수 빨강 > 개인화 Text Color. 3분기로 처리 — 단순 personalColor 유무로 갈라 쓰면
      //   else 의 removeProperty 가 음수색을 도로 지운다.
      if (binding === 'MEASURE') {
        // MEASURE 글자색은 MEASURE_COLOR 전담 — 개인화/음수색 미적용.
      } else if (toNumber(rowItem?.[binding]) < 0) {
        paintNegativeText(e.cell, -1);
      } else if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };
    g.formatItem.addHandler(formatHandler);

    // ===== 편집 시작 — R5 정적 화이트리스트 + R1~R4 동적 판정 =====
    //   금지: 여기서 col.dataMap 을 갈아끼우지 말 것. 행별 후보는 컬럼 메타(cellCboDataTp)를 보고
    //   공용 계층이 getDisplayValues(행) 로 처리한다.
    const beginningEditHandler = (
      s: FlexGridType<ShipmentRequestRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as ShipmentRequestRow | undefined;

      if (staticBindingSet.has(binding)) {
        // 정적 셀 — Insert 행 화이트리스트만 (기존 행 키 컬럼 잠금).
        if (!row || row.CRUD_TYPE !== 'I' || !insertStaticEditable(binding, row, division, isSoleRow())) {
          e.cancel = true;
          return;
        }
        // 모달 전용 셀(PROJECT_CODE/TR_MODE/ITEM_ID)은 직접 타이핑 차단 — dblclick 팝업으로만 값 입력.
        if (isInsertModalCell(binding, row, division)) {
          e.cancel = true;
          return;
        }
        e.cancel = false;
        return;
      }
      // 동적 셀 — R1~R4 종합. FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper read-only 보다 우선.
      if (dynKindOf(binding)) {
        const state = evalShipmentDynCell({
          binding,
          row,
          bucketType,
          dOrderedDayBindings: dOrderedDayBindingsRef.current,
        });
        e.cancel = !state.editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기 게이트 — 편집 가드와 동일 판정.
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ===== 편집 종료 — 동적 셀 정수 절삭 + EditTracker 재판정 =====
    const cellEditEndedHandler = (
      s: FlexGridType<ShipmentRequestRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as ShipmentRequestRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;

      // 동적 셀 — 값 정규화(정수 절삭 — 저장은 D_ 정수. design 03 §2.4) + EditTracker 재판정.
      const editedKind = dynKindOf(binding);
      if (editedKind) {
        const measure = toCellStr(row.MEASURE);
        // MEASURE 빈 행 숫자 입력 롤백 (measure 없는 행은 값 셀이 무의미).
        if (!measure) {
          rec[binding] = null;
          s.invalidate(true);
          return;
        }
        rec[binding] = Math.trunc(toNumber(rec[binding]));

        // 비-insert 행 변경을 추적한다 — 최종값 기준 재판정. 원본은 EditTracker 실기록에서 가져온다.
        //   저장(dmf0045.save)은 D_ 만 수집하므로, W_/M_ 편집분은 아래에서 하위 D_ 로 전개해 추적한다.
        //   W_/M_ 셀 자체 추적은 저장에 영향이 없으나(비-D_ 무시), 표시 합계 = 하위 D_ 합이라 유지한다.
        const trackChange = (b: string, finalVal: number | null): void => {
          if (row.CRUD_TYPE === 'I') return; // 신규행은 값 존재만으로 저장 대상 — 추적 불필요
          const tracker = editTrackerRef?.current;
          if (!tracker) return;
          const recorded = tracker.getOriginalValues().get(row as never);
          const hasOriginal = !!recorded && b in recorded;
          const original = hasOriginal ? (recorded[b] as never) : (finalVal as never);
          tracker.storeChange(row as never, b, original, finalVal as never);
        };
        trackChange(binding, (rec[binding] ?? null) as number | null);

        // W_/M_ 입력 → 하위 D_ 전개 (design 03 §2.4). 컬럼 인접으로 D_ 귀속, 총합 보존 정수 분배.
        //   적용요일 = DefaultBucketDay 콤보 마스크(division별 MON/FRI). 미조회 시 월요일/첫 일자 fallback.
        if (editedKind === 'W' || editedKind === 'M') {
          const { updates } = expandBucketToDays({
            editedBinding: binding,
            qty: Math.trunc(toNumber(rec[binding])),
            dynBindings,
            applicableMask: bucketDayMaskRef.current,
          });
          for (const u of updates) {
            rec[u.binding] = u.qty;
            trackChange(u.binding, u.qty);
          }
        }
        s.invalidate(true);
        return;
      }

      // 정적 셀 값 후처리: 저장 전개(save-unfold)·셀 팝업 채움(모달 applyToInsertRow)이 담당 —
      //   여기서는 머지 재계산만(정적 키 컬럼 변경 시 좌측 세로 머지 갱신).
      if (staticBindingSet.has(binding) && fixedBindings.includes(binding)) {
        s.invalidate(true);
        window.requestAnimationFrame(() => s.invalidate(true));
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    // 붙여넣기 후 처리 — 셀 편집과 동일 후처리.
    const pastedCellHandler = (
      s: FlexGridType<ShipmentRequestRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      cellEditEndedHandler(s, e);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ===== 더블클릭 — 헤더 드릴다운 + 셀 모달 =====
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 헤더 — M_ 헤더: 해당 월 구간 W_ 토글 + 보이는 D_ 접기 / W_ 헤더: 해당 주 D_ 토글.
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = dynKindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const targetCol = g.getColumn(target);
          if (!targetCol) return;
          if (hideOnly && !targetCol.visible) return; // AS-IS: D_ 는 보이는 경우만 접기 (M_ 드릴)
          drillVisRef.current.set(target, hideOnly ? false : !targetCol.visible);
        };
        for (let i = idx + 1; i < dynBindings.length; i++) {
          const target = dynBindings[i];
          const tk = dynKindOf(target);
          if (hk === 'M') {
            if (tk === 'M') break;
            if (tk === 'W') flip(target, false);
            else if (tk === 'D') flip(target, true);
          } else {
            if (tk === 'W' || tk === 'M') break;
            if (tk === 'D') flip(target, false);
          }
        }
        applyDynVisibilityRef.current?.();
        return;
      }
      if (ht.cellType !== CellType.Cell) return;
      // 데이터 셀 — 신규(I) 행만 (AS-IS 조기 가드 IsLock || Action!='I').
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as ShipmentRequestRow | undefined;
      if (!row || row.CRUD_TYPE !== 'I') return;
      // PROJECT_CODE 셀(SCM0002, 40 제외) / TR_MODE 셀(DMF0046 BOD) / ITEM_ID 셀(DMF0047).
      //   판정은 formatItem 의 Yellow/아이콘 과 동일 함수 (isInsertModalCell) 로 통일.
      if (!isInsertModalCell(binding, row, division)) return;
      const modalKey: ShipmentModalKey =
        binding === 'PROJECT_CODE' ? 'PROJECT' : binding === 'TR_MODE' ? 'BOD' : 'ITEM';
      onPopupCellDblClick(modalKey, row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // Scroll 시 머지 그룹 재계산 (viewport sticky #38)
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 + HierarchicalMergeManager (utils/dmf0045.merge.ts) =====
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
        g.pastingCell?.removeHandler(beginningEditHandler as never);
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.pastedCell?.removeHandler(pastedCellHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
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
  }, [visibleColumns, dynBindings, fixedBindings, onPopupCellDblClick, division, bucketType]);

  // hook #93 — 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const rowCount = headerRows.length;
      const per = Math.round(48 / rowCount);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };

    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef]);

  // Sum 체크박스 + 헤더 드릴다운 — 동적 컬럼 visible 통합 적용 (AS-IS SetSpreadColumn + 더블클릭 1:1).
  //   규칙: 활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 — 드릴 오버라이드 우선.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g) return;
    // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다).
      const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        if (userHiddenColumns?.has(b)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, drillBindings, dynBindings, visibleColumns, gridRef]);

  // 필터 상태에서 Insert — 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다.
  const reapplyInsertRowVisibility = useCallback((): boolean => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g || g.columns.length === 0) return false;
    const insertRows = rowsRef.current.filter(r => r.CRUD_TYPE === 'I');
    if (insertRows.length === 0) return false;
    insertRows.forEach(row => keepRowVisibleUnderFilter(g as never, row as never));
    return true;
  }, [gridRef]);

  // F4 Filter — 피처 소유 FlexGridFilter (필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<ShipmentRequestRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    // 금지: 여기서 새 FlexGridFilter 를 만들면 안 된다 (필터 걸고 행추가 시 필터 풀림 원인).
    //   DataGrid 에 gridFilterRef 를 넘겨 인스턴스를 공유하고, 없을 때만 안전망으로 만든다.
    if (!gridFilterRef.current) {
      const created = new FlexGridFilter(g);
      created.filterColumns = [''];
      gridFilterRef.current = created;
    }
    const f = gridFilterRef.current;

    let raf = 0;
    const onFilterApplied = () => {
      g.invalidate(true);
      if (!reapplyInsertRowVisibility()) return;
      window.cancelAnimationFrame(raf);
      raf = window.requestAnimationFrame(() => {
        reapplyInsertRowVisibility();
        g.collectionView?.refresh();
      });
    };
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      window.cancelAnimationFrame(raf);
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, gridRef, gridFilterRef, reapplyInsertRowVisibility]);

  return (
    <DataGrid
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      staticColumns={mainStaticColumns}
      dynamicColumns={mainDynamicColumns}
      // 셀 콤보 SQL 이 요구하는 화면 단위 파라미터 — divisionId(스코프) / mnuId('Measure' @mnuId 비관대형).
      comboParams={{ divisionId: `'${division || 'ALL'}'`, mnuId: `'${MENU_ID}'` }}
      // 셀 콤보에 시트 스코프 sheetName 을 함께 실어 @sheetName 을 해소한다(mnuId 와 짝).
      sheetName={activeSheet}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowMerging={AllowMerging.All}
      useAggregationRow={false}
    />
  );
};
