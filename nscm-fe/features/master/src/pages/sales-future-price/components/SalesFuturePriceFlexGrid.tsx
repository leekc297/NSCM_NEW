import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, type Ref } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { BUCKET_TYPE, MAIN_COLUMNS } from '../sales-future-price.constants';
import type { FuturePriceRow } from '../sales-future-price.types';
import styles from '../SalesFuturePrice.module.scss';
import type { MeasureMeta } from '../useSalesFuturePriceStore';

interface Props {
  rows: FuturePriceRow[];
  gridRef: Ref<FlexGridType<FuturePriceRow>>;
  onPopupCellDblClick?: (modalKey: string, row: FuturePriceRow) => void;
  divisionId?: string;
  bucketType?: BUCKET_TYPE;
  // ⭐ master hook §2.5 — admin SYS0004 UI Category Setup 동적 메타 (전체 속성 반영)
  staticColumns?: RawFlexGridColumnConfig[];
  staticMeasures?: MeasureMeta[];
}

// FlexGridColumn 렌더링용 통합 column meta
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  fixed: boolean;
  scale?: number;
  _ctrlType?:
    | 'FPText'
    | 'FPModal'
    | 'FPComboBox'
    | 'FPCheckBox'
    | 'FPDate'
    | 'FPDateTime'
    | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
  _comboKey?: string;
}

// SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과는 wide format —
//   28 fixed cols + 동적 W_YYYYMMDD 또는 M_YYYYMM cols
// FE 가 동적 col binding 을 결과 keys 에서 추출

const getDynKey = (
  binding: string
): { kind: 'W' | 'M' | null; ym: string; mmdd: string; wk: string } => {
  if (/^W_\d{8}$/.test(binding)) {
    const d = binding.slice(2);
    const y = Number(d.slice(0, 4));
    const m = Number(d.slice(4, 6)) - 1;
    const dd = Number(d.slice(6, 8));
    const date = new Date(Date.UTC(y, m, dd));
    const dn = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dn);
    const yStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    const wk = Math.ceil(((date.getTime() - yStart.getTime()) / 86400000 + 1) / 7);
    return {
      kind: 'W',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      mmdd: `${d.slice(4, 6)}${d.slice(6, 8)}`,
      wk: `W${String(wk).padStart(2, '0')}`,
    };
  }
  if (/^M_\d{6}$/.test(binding)) {
    const d = binding.slice(2);
    return { kind: 'M', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, mmdd: '', wk: '' };
  }
  return { kind: null, ym: '', mmdd: '', wk: '' };
};

export const SalesFuturePriceFlexGrid = ({
  rows,
  gridRef,
  onPopupCellDblClick,
  divisionId,
  bucketType = BUCKET_TYPE.WEEKLY,
  staticColumns,
  staticMeasures,
}: Props) => {
  const bucketPrefix = bucketType === BUCKET_TYPE.MONTHLY ? 'M' : 'W';
  void staticMeasures; // measure 는 SalesFuturePrice.tsx 의 handleInsert 에서 사용

  // ⭐ master hook §4 — admin SYS0004 staticColumns 가 있으면 전체 속성 사용,
  //   없으면 MAIN_COLUMNS hardcode fallback (BE 실패 시 화면 작동 보장)
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    if (!staticColumns || staticColumns.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>(c => ({
        binding: c.key,
        header: c.header,
        width: c.width ?? 100,
        align: c.align ?? 'C',
        visible: true,
        fixed: false,
        _ctrlType: c._ctrlType,
        _inputEditType: c._inputEditType,
        _modalKey: c._modalKey,
        _comboKey: c._comboKey,
      }));
    }
    return staticColumns.map(sc => {
      const fb = MAIN_COLUMNS.find(m => m.key === sc.colNm);
      return {
        binding: sc.colNm,
        header: sc.colLblNm || fb?.header || sc.colNm,
        width: sc.colWth ?? fb?.width ?? 100,
        align: sc.horzAlgnCd ?? fb?.align ?? 'C',
        visible: sc.visible !== false,
        fixed: sc.fixed === true,
        scale: sc.scale,
        _ctrlType: sc.cellCtrlObjTpCd ?? fb?._ctrlType,
        _inputEditType: sc.inputTpCd ?? fb?._inputEditType,
        _modalKey: sc.attribute1 ?? fb?._modalKey,
        _comboKey: sc.attribute2 ?? fb?._comboKey,
      } as MergedColumnMeta;
    });
  }, [staticColumns]);

  // visible=true 만 화면에 노출
  const visibleColumns = useMemo(() => mergedColumns.filter(c => c.visible), [mergedColumns]);
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.binding), [visibleColumns]);

  // ===== Grid 내 combo column dropdown — useTabComboQueries + Wijmo DataMap =====
  //   AS-IS .cs L2029/L2034/L2036/L2038/L2055/L2013 SetCellTypeCombo 정확 매핑
  //   Phase C (2026-06-03): FcstType / CustomsHandbook SCM_ADM_CMBO_SQL_M 등록 완료 → 8종 dropdown
  const divParam = divisionId ?? '40';
  const [divQ, teamQ, ecQ, ssQ, incoQ, currQ, fcstQ, customsQ, bizQ] = useTabComboQueries({
    filters: [
      'MyDivision',
      'TeambyDivision',
      'EndCustomerByDivisionDept',
      'SiteByEndCustomer',
      'Incoterms',
      'CurrencyList',
      { comboId: 'FcstType', divisionId: divParam },
      { comboId: 'CustomsHandbook', divisionId: divParam },
      { comboId: 'BizType', divisionId: divParam },
    ],
  });
  type ComboItem = { CODE?: string; NAME?: string };
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (q: ComboItem[] | undefined): DataMap | null => {
      const arr = q ?? [];
      if (arr.length === 0) return null;
      return new DataMap(arr, 'CODE', 'NAME');
    };
    return {
      DIVISION_ID: make(divQ as never),
      DEPT_ID: make(teamQ as never),
      END_CUSTOMER: make(ecQ as never),
      SCM_SITE_ID: make(ssQ as never),
      INCOTERMS: make(incoQ as never),
      CURRENCY: make(currQ as never),
      FCST_TYPE: make(fcstQ as never),
      DOM_EXP: make(customsQ as never),
      BIZ_TYPE_NAME: make(bizQ as never),
    };
  }, [divQ, teamQ, ecQ, ssQ, incoQ, currQ, fcstQ, customsQ, bizQ]);

  // 동적 컬럼 keys 추출 — SP 결과 모든 row 의 union
  //   Bucket=W → W_yyyymmdd 중 월요일 (주 시작일) 만 / Bucket=M → M_yyyymm 만
  //   (사용자 요구 2026-06-12: "Bucket week 일때 주의 시작일만 나오도록")
  const dynBindings = useMemo<string[]>(() => {
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    const matchPrefix = bucketPrefix === 'M' ? /^M_\d+$/ : /^W_\d+$/;
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (!matchPrefix.test(k)) continue;
        if (bucketPrefix === 'W') {
          const d = k.slice(2);
          const dt = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
          if (dt.getUTCDay() !== 1) continue; // 1 = Monday (주 시작일)
        }
        set.add(k);
      }
    }
    return [...set].sort();
  }, [rows, bucketPrefix]);

  useEffect(() => {
    const g = gridRef && 'current' in gridRef ? gridRef.current : null;
    if (!g) return;
    // 동적 cols 추가 후 combo dataMap 적용 + column.height 16 강제 (THREE_DEPTH 정합).
    //   ⭐ 정적 col 의 wrapper-부여 height=48 (ONE_DEPTH fallback) override — row 0 (group row) 시각 두께 fix.
    for (let i = 0; i < g.columns.length; i++) {
      const col = g.columns[i];
      const binding = col.binding ?? '';
      const dm = dataMaps[binding];
      if (dm) col.dataMap = dm;
      // ⚠ Wijmo `Column` 타입에 height 속성 정의 없음 — runtime 시 col 객체에 동적 부여 (wijmo grid 가 인식).
      (col as unknown as { height: number }).height = 16;
    }
    // columnHeader rows 도 16 강제 (dynBindings 변경 → row push 시 default 로 복귀 방지)
    //   null guard — grid mount race (gridRef.current 존재하나 columnHeaders 미초기화)
    if (g.columnHeaders?.rows) {
      g.columnHeaders.rows.defaultSize = 16;
      for (let i = 0; i < g.columnHeaders.rows.length; i++) {
        g.columnHeaders.rows[i].height = 16;
      }
    }
    g.invalidate(true);
  }, [dynBindings, dataMaps, gridRef]);

  // ⭐ 룰 #60 — DataGrid wrapper 의무. visibleColumns + dynBindings → staticColumns + dynamicColumns prop.
  //    initialized prop 미사용 (wrapper 의 자동 기능 보존 — `{...gridProps}` override 회피).
  //    복합 로직 (3단 헤더 / formatItem / beginningEdit / cellEditEnded / mergeManager / dblclick / scroll)
  //    은 useEffect 로 분리 등록 + cleanup.
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        colNm: c.binding,
        colLblNm: c.header,
        // ⭐ ROOT CAUSE fix (2026-06-21) — sCls/lCls 메타 전달 누락 → wrapper 가 항상 ONE_DEPTH 처리.
        //   DMF0007 reference: SHEET_COLUMNS.SMALL_CLASS_LABEL_NAME=COLUMN_LABEL_NAME → wrapper TWO_DEPTH.
        //   visibleColumns 의 c._sClsLblNm 는 wrapper 의 toLeafColumn (foundation/columnMapping.ts L159) 보존 field.
        sClsLblNm: (c as { _sClsLblNm?: string })._sClsLblNm,
        lClsLblNm: (c as { _lClsLblNm?: string })._lClsLblNm,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        inputTpCd:
          c._inputEditType === 'S'
            ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
            : c._inputEditType === 'M'
              ? CELL_INPUT_EDIT_TYPE.MANDATORY
              : c._inputEditType === 'IM'
                ? CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY
                : c._inputEditType === 'IO'
                  ? CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY
                  : CELL_INPUT_EDIT_TYPE.OPTIONAL,
        scale: c.scale,
      })),
    [visibleColumns]
  );
  // ⭐ 3단 nested (사용자 요구 2026-06-21 유지) — year-month → week → day.
  //   1단 group  = 대상년월 ('YYYY-MM') / Monthly: ymLabel.
  //   2단 group  = 주차 ('Wxx', ISO week native Date) / Monthly: 'SUM'.
  //   3단 leaf   = 일자 ('MMDD') / Monthly: ''.
  //   DMF0007 표준 leaf prop (visible:true/_inputEditType:OPTIONAL/_display:true) 정확 적용.
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynBindings.length === 0) return [];
    const isoWeek = (yyyymmdd: string): number => {
      const d = new Date(
        Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
      );
      const day = d.getUTCDay() || 7;
      d.setUTCDate(d.getUTCDate() + 4 - day);
      const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
      return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
    };
    type YmBucket = { ymLabel: string; weeks: Map<string, FlexGridColumnConfig[]> };
    const ymMap = new Map<string, YmBucket>();
    for (const b of dynBindings) {
      const isMonthly = b.startsWith('M_');
      const ymd = b.slice(2);
      const ym = ymd.slice(0, 6);
      const ymLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
      const mmdd = isMonthly ? '' : ymd.slice(4, 8);
      const wLabel = isMonthly ? 'SUM' : `W${isoWeek(ymd)}`;
      let bucket = ymMap.get(ym);
      if (!bucket) {
        bucket = { ymLabel, weeks: new Map() };
        ymMap.set(ym, bucket);
      }
      if (!bucket.weeks.has(wLabel)) bucket.weeks.set(wLabel, []);
      bucket.weeks.get(wLabel)!.push({
        binding: b,
        header: mmdd,
        align: 'right',
        format: 'n3',
        width: 90,
        height: 16,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    }
    // ⭐ THREE_DEPTH=16 — columnMapping.ts `HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH` 와 정합.
    //   group / sub-group / leaf 모두 height:16 → 3단 × 16 = 48px (= 정적 col 1단 영역 동일).
    //   누락 시 Wijmo group cell 의 default padding 으로 시각적 두께 불균형 (사용자 보고 2026-06-21).
    return [...ymMap.values()].map(bucket => ({
      header: bucket.ymLabel,
      align: 'center',
      height: 16,
      columns: [...bucket.weeks.entries()].map(([wLabel, dayCols]) => ({
        header: wLabel,
        align: 'center',
        height: 16,
        columns: dayCols,
      })),
    }));
  }, [dynBindings]);

  // ⭐ grid 핸들러 + mergeManager useEffect 분리 등록.
  //    DataGrid wrapper 의 자동 기능 (setEditableColumns / setSortableColumns / formatItem default 등) 보존.
  //    deps = [visibleColumns, dynBindings] — column 변경 시 handler 재등록 (closure 정합).
  //    null guard 강화 — DataGrid wrapper 의 initialized handler 시점 vs useEffect timing 차이.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<FuturePriceRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // ===== column header row size — DMF0007 표준 HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH=16 (foundation/columnMapping.ts L29) =====
    //   ⭐ ROOT CAUSE fix (2026-06-21, 사용자 보고 "동적 3단 헤더 높이 줄어들지 않음"):
    //     mainStaticColumns 에 sCls/lCls 메타 없음 → wrapper `mapRawColumnsToWijmoColumns` ONE_DEPTH 판정
    //     → 정적 col 마다 column.height=48 부여 → Wijmo 가 columnHeader row 높이를 max(column.height) 로 결정
    //     → row 0 (group row) = 48px → 사용자 시각적 두께 불균형.
    //   fix: mount 후 모든 leaf column 의 height 16 강제 override + row.height 16 강제 + invalidate(true).
    g.columnHeaders.rows.defaultSize = 16;
    for (let i = 0; i < g.columnHeaders.rows.length; i++) {
      g.columnHeaders.rows[i].height = 16;
    }
    for (let i = 0; i < g.columns.length; i++) {
      (g.columns[i] as unknown as { height: number }).height = 16;
    }

    const formatHandler = (_s: FlexGridType<FuturePriceRow>, e: FormatItemEventArgs) => {
            const col = e.panel.columns[e.col];
            if (!col) return;

            if (e.panel.cellType === CellType.ColumnHeader) {
              // 동적 W/M = Wijmo nested 자동 (group cell + leaf).
              // 정적 column verticalSpan = mergeManager 의 ColumnHeader 분기로 row 0~2 merge.
              e.cell.style.textAlign = 'center';
              return;
            }

            if (e.panel.cellType !== CellType.Cell) return;
            if (!col.binding) return;
            const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: FuturePriceRow })
              ?.dataItem;
            const meta = visibleColumns.find(c => c.binding === col.binding);
            const isDyn = !meta && /^[WM]_/.test(col.binding);
            const isInsert = rowItem?.CRUD_TYPE === 'I';
            const isLocRow = String(rowItem?.MEASURE ?? '') === 'LOC';

            // 동적 col — LOC row 만 editable (AS-IS L2108: Measure='LOC' 가 아니면 LockRange2)
            if (isDyn) {
              if (isLocRow) toggleClass(e.cell, 'wj-cell-editable', true);
              else toggleClass(e.cell, 'wj-cell-non-editable', true);
              return;
            }

            // ⭐ v4 (2026-06-21) — sticky content 는 mergeManager viewport row 제한 패턴이 native 처리.
            //   v3 deprecated (.merge-content div wrap + translateY) 제거됨.
            //   hook `wijmo-merge-sticky-content.md` §3 viewport row 제한 패턴 참조.

            // Fixed col cell coloring
            //   Insert row 의 IM (필수) + IO (옵션) 모두 editable (사용자 요구 2026-06-03 v3)
            //   MEASURE 는 'S' (read-only, RTF/KRW/USD/LOC 고정)
            //   FPModal (popup) 은 cell 우측에 🔍 돋보기 아이콘 표시 + dblClick popup
            if (meta) {
              const editableForInsert =
                isInsert && (meta._inputEditType === 'IM' || meta._inputEditType === 'IO');
              if (editableForInsert) {
                toggleClass(e.cell, 'wj-cell-editable', true);
                if (meta._ctrlType === 'FPModal') {
                  const cellEl = e.cell;
                  cellEl.style.cursor = 'pointer';
                  cellEl.title = `${meta.header} 팝업 (더블클릭)`;
                  // 🔍 돋보기 아이콘 (AS-IS cellTypeImage 동등)
                  cellEl.style.position = 'relative';
                  cellEl.style.paddingRight = '20px';
                  const existingIcon = cellEl.querySelector('.popup-icon');
                  if (!existingIcon) {
                    const icon = document.createElement('span');
                    icon.className = 'popup-icon';
                    icon.textContent = '🔍';
                    icon.style.cssText =
                      'position:absolute;right:4px;top:50%;transform:translateY(-50%);font-size:11px;pointer-events:none;opacity:0.65;';
                    cellEl.appendChild(icon);
                  }
                }
              } else {
                toggleClass(e.cell, 'wj-cell-non-editable', true);
              }
            }
          };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 시 row 단위 제어 — Insert row 만 fixed cols 편집 허용
    //   FPModal popup cell 은 직접 입력 차단 (dblClick popup 만 허용)
    //   동적 col 은 LOC row 만 편집 허용 (AS-IS .cs L2108)
    const beginningEditHandler = (s: FlexGridType<FuturePriceRow>, e: { cancel: boolean; row: number; col: number }) => {
            const col = s.columns[e.col];
            const binding = col.binding ?? '';
            const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
            const isInsert = row?.CRUD_TYPE === 'I';
            const meta = visibleColumns.find(c => c.binding === binding);

            // Fixed col — Insert row 의 IM/IO + popup 차단
            if (meta) {
              if (!isInsert) {
                e.cancel = true;
                return;
              }
              if (meta._ctrlType === 'FPModal') {
                e.cancel = true;
                return;
              }
              if (meta._inputEditType === 'S') {
                e.cancel = true;
                return;
              }
              return;
            }
            // Dynamic col — LOC row 만 편집 허용
            if (/^[WM]_/.test(binding)) {
              if (String(row?.MEASURE ?? '') !== 'LOC') e.cancel = true;
            }
          };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Insert row 편집 종료 시 — 같은 INSERT_GROUP_ID 4 measure row 의 좌측 fixed cols 동기화
    const cellEditEndedHandler = (s: FlexGridType<FuturePriceRow>, e: { row: number; col: number }) => {
            const col = s.columns[e.col];
            const binding = col.binding ?? '';
            const meta = visibleColumns.find(c => c.binding === binding);
            if (!meta) return;
            const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
            if (!row || row.CRUD_TYPE !== 'I') return;
            const gid = row.INSERT_GROUP_ID;
            if (!gid) return;
            const newVal = (row as Record<string, unknown>)[binding];
            const view = s.collectionView;
            const items = view.items;
            for (const item of items) {
              if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid && item !== row) {
                (item as Record<string, unknown>)[binding] = newVal;
              }
            }
            s.invalidate(true);
          };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    const dblclickHandler = (ev: MouseEvent) => {
            const ht = g.hitTest(ev);
            if (ht.cellType !== CellType.Cell) return;
            const col = g.columns[ht.col];
            const meta = visibleColumns.find(c => c.binding === col.binding);
            if (meta?._ctrlType !== 'FPModal' || meta._inputEditType !== 'IM') return;
            const row = g.rows[ht.row].dataItem as FuturePriceRow | undefined;
            if (!row || row.CRUD_TYPE !== 'I') return;
            if (meta._modalKey) onPopupCellDblClick?.(meta._modalKey, row);
          };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // ⭐ v4 (2026-06-21) — Scroll 시 머지 그룹 재계산 trigger.
    //   hook `wijmo-merge-sticky-content.md` §3.1 패턴:
    //     scrollPositionChanged → g.invalidate() → mergeManager 가 새 viewRange.row/row2 로
    //     머지 범위 재계산 → 새 viewport 첫 row 가 머지 그룹 top → cell content 항상 표시.
    //   v3 deprecated (adjustMergedContent + translateY 보정) 제거됨.
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 (Wijmo API: g.allowMerging + g.mergeManager) =====
          //   AllowMerging.All = ColumnHeaders | RowHeaders | Cells (헤더 + 데이터 cell 모두)
          g.allowMerging = AllowMerging.All;

          // 좌측 fixed cols + 동적 cols ColumnHeader 의 allowMerging 강제 (column 단위 flag)
          for (let i = 0; i < g.columns.length; i++) {
            g.columns[i].allowMerging = true;
          }

          // MergeManager subclass — 헤더 + Cell 계층 머지 (사용자 요구 2026-06-03 v5):
          //   Wijmo cell merge 유지 (시각 통합) — getMergedRange 가 같은 그룹 range 반환
          //   추가: scrollPositionChanged event 로 머지 cell content 를 viewport 안 visible 영역 의 top 으로 강제 조정 (아래)
          class HierarchicalMergeManager extends MergeManager {
            getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
              const col = panel.columns[c];
              if (!col) return null;
              const binding = col.binding ?? '';

              // ===== ① Data Cell — 좌측 fixed cols 계층 머지 (v4 viewport row 제한 패턴) =====
              //   hook `wijmo-merge-sticky-content.md` v4 (2026-06-18 표준):
              //     머지 그룹 확장 범위 = `panel.viewRange.row ~ row2` (현재 viewport 안만).
              //     scroll 시 새 viewport 첫 row 가 머지 그룹 top → cell content 항상 표시 (sticky 효과).
              //   v3 deprecated 패턴 (.merge-content div wrap + translateY 보정) 제거 완료.
              if (panel.cellType === CellType.Cell && fixedBindings.includes(binding)) {
                const view = panel.rows;
                const rowItem = (i: number): Record<string, unknown> | undefined =>
                  (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
                const cur = rowItem(r);
                if (!cur) return null;
                const fixedIdx = fixedBindings.indexOf(binding);
                const leftBindings = fixedBindings.slice(0, fixedIdx + 1);
                const sameRow = (a: number, b: number): boolean => {
                  const ra = rowItem(a);
                  const rb = rowItem(b);
                  if (!ra || !rb) return false;
                  return leftBindings.every(
                    k =>
                      ((ra as Record<string, string>)[k] ?? '') ===
                      ((rb as Record<string, string>)[k] ?? '')
                  );
                };
                const minRow = panel.viewRange.row;
                const maxRow = panel.viewRange.row2;
                let r1 = r,
                  r2 = r;
                while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
                while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
                if (r1 === r2) return null;
                return new CellRange(r1, c, r2, c);
              }

              // ===== ② ColumnHeader — 정적 column verticalSpan + 동적 column horizontal merge =====
              //   사용자 요구 (2026-06-21):
              //     (a) 정적 column = row 0~last verticalSpan (시각적 1단)
              //     (b) 동적 column W = row 0 (YYYY-MM 같은 ym 의 leaf 전체 span) + row 1 (Wxx 같은 wk+ym 의 leaf 전체 span)
              if (panel.cellType === CellType.ColumnHeader) {
                if (fixedBindings.includes(binding)) {
                  return new CellRange(0, c, panel.rows.length - 1, c);
                }
                const dyn = getDynKey(binding);
                if (dyn.kind === 'W') {
                  if (r === 0) {
                    let c1 = c, c2 = c;
                    while (c1 > 0) {
                      const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                      if (p.kind === 'W' && p.ym === dyn.ym) c1--;
                      else break;
                    }
                    while (c2 < panel.columns.length - 1) {
                      const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                      if (n.kind === 'W' && n.ym === dyn.ym) c2++;
                      else break;
                    }
                    return new CellRange(0, c1, 0, c2);
                  }
                  if (r === 1) {
                    let c1 = c, c2 = c;
                    while (c1 > 0) {
                      const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                      if (p.kind === 'W' && p.wk === dyn.wk && p.ym === dyn.ym) c1--;
                      else break;
                    }
                    while (c2 < panel.columns.length - 1) {
                      const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                      if (n.kind === 'W' && n.wk === dyn.wk && n.ym === dyn.ym) c2++;
                      else break;
                    }
                    return new CellRange(1, c1, 1, c2);
                  }
                }
              }
              return null;
            }
          }
    g.mergeManager = new HierarchicalMergeManager();

    // ⭐ columnHeader row push (3단) + mergeManager 변경 → invalidate 의무.
    //   사용자 보고 (2026-06-21): 좌측 정적 column 높이 = 동적 3단 column 총 높이 정합 안 됨.
    //   원인: useEffect 가 grid 초기 render 이후 실행 → row push 가 화면에 즉시 반영 안 됨.
    //   fix: invalidate(true) — Wijmo 가 columnHeader row 수 (3) 재계산 + mergeManager 의 row 0~2 정적 column verticalSpan 재적용.
    g.invalidate(true);

    return () => {
      // cleanup 시점에 grid 가 unmount 됐을 수도 — null safe.
      try { g.formatItem?.removeHandler(formatHandler); } catch { /* unmount race */ }
      try { g.beginningEdit?.removeHandler(beginningEditHandler); } catch { /* unmount race */ }
      try { g.cellEditEnded?.removeHandler(cellEditEndedHandler); } catch { /* unmount race */ }
      try { g.hostElement?.removeEventListener('dblclick', dblclickHandler); } catch { /* unmount race */ }
      try { g.scrollPositionChanged?.removeHandler(handleScrollInvalidate); } catch { /* unmount race */ }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, onPopupCellDblClick]);

  return (
    <div className={styles.gridContainer}>
      <DataGrid
        // ⭐ key prop — staticColumns 의 sCls/lCls 메타 변경 시 wrapper re-mount 강제.
        //   mappedStaticColumns 는 useMemo 없이 매 render 계산 — 그러나 Wijmo grid 의 columnGroups 변경 시
        //   columnHeader rows 재계산 안 함 (cache). key 변경 시 grid 새 mount → 정상 재계산.
        key={mainStaticColumns.map(c => `${c.colNm}|${c.sClsLblNm ?? ''}|${c.lClsLblNm ?? ''}`).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        style={{ height: '100%' }}
      />
    </div>
  );
};
