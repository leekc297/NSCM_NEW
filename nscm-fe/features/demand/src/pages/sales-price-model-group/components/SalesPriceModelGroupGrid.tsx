import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, isInsertRow, safeString } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../sales-price-model-group.constants';
import {
  AUTO_MAPPED_COLUMNS,
  GRID_CASCADE_CLEAR,
  MEASURE_CODE,
  MSG,
  PRC_RPSN,
  SHEETS,
} from '../sales-price-model-group.constants';
import type { ModelGroupRow } from '../sales-price-model-group.types';
import { buildPeriodColumns, periodBindingsOf } from '../utils/sales-price-model-group.grid';
import { attachHeaderHeightNormalizer } from '../utils/sales-price-model-group.grid';
import { keepMergeManager, ModelGroupMergeManager } from '../utils/sales-price-model-group.grid';
import { convertLocPrice, type ExchangeRateMap } from '../utils/sales-price-model-group.util';
import { isPastPeriodKey, isPeriodKey } from '../utils/sales-price-model-group.util';
import { cellOf, numberOf, sameBundle } from '../utils/sales-price-model-group.util';
import { originBundleKeyOf } from '../utils/sales-price-model-group.util';

import styles from './SalesPriceModelGroupGrid.module.scss';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ModelGroupRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ModelGroupRow> | undefined>;
  data: ModelGroupRow[];
  staticColumns: RawFlexGridColumnConfig[];
  periodKeys: string[];
  // 동적 컬럼 너비(px) — 시간축 SP COLUMN_WIDTH 최우선. 미지정이면 buildPeriodColumns 기본값(90).
  periodColumnWidth?: number;
  bucketType: BUCKET_TYPE;
  divisionId: string;
  monday: string;
  rateMap: ExchangeRateMap;
  siteEndCustomerMap: Map<string, string>;
  onPopupCellDblClick: (modalKey: string, row: ModelGroupRow) => void;
}

const isAutoMapped = (binding: string) => (AUTO_MAPPED_COLUMNS as readonly string[]).includes(binding);
const isPopupColumn = (meta?: RawFlexGridColumnConfig) =>
  meta?.cellCtrlObjTpCd === CELL_CONTROL_TYPE.TEXT_MODAL ||
  meta?.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MODAL;

// 더블클릭 판정 — 공용 DataGrid 가 첫 클릭에 셀을 다시 그려 브라우저 dblclick 이 오지 않는다(원천 DMF0020 과 같은 방식).
const DBLCLICK_MS = 400;

export const SalesPriceModelGroupGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  periodKeys,
  periodColumnWidth,
  bucketType,
  divisionId,
  monday,
  rateMap,
  siteEndCustomerMap,
  onPopupCellDblClick,
}: Props) => {
  const { t } = useTranslation();

  // 이벤트 핸들러가 최신 값을 보도록 ref 로 둔다(핸들러는 컬럼이 바뀔 때만 다시 건다).
  const rateMapRef = useRef(rateMap);
  rateMapRef.current = rateMap;
  const siteEcMapRef = useRef(siteEndCustomerMap);
  siteEcMapRef.current = siteEndCustomerMap;
  const editingRef = useRef<{ binding: string; oldVal: unknown } | null>(null);
  // LOC 수정으로 화면이 다시 계산해 덮어쓴 KRW · USD 칸의 원래 값. 공용 EditTracker 는 사용자가 고친 칸만
  //   기록하므로 따로 둔다. 조회 결과가 바뀌면 비운다.
  const siblingOriginalsRef = useRef(new WeakMap<ModelGroupRow, Record<string, WijmoPrimitive>>());
  // 기존 묶음 Currency 변경 (2026-11-12, 화면인계_DMF0083_Currency수정 F1 ~ F6).
  //   noticed : 변경 범위 안내(MSG01429)를 이미 본 묶음 — 묶음당 한 번만 띄운다. 첫 진입은 안내만 띄우고
  //             다음 진입부터 편집기를 연다(편집기와 알림이 한 동작에 겹치면 콤보가 닫힌다, DMF0020_01 과 같은 방식).
  //   changeable : 묶음별 "Currency 를 바꿀 수 있는가" 판정값 — 칸을 그릴 때마다 묶음을 다시 훑지 않게 둔다.
  //   둘 다 조회 결과가 바뀌면 비우고, changeable 은 값을 고칠 때마다 비운다(LOC 를 넣으면 판정이 바뀐다).
  const currencyNoticedRef = useRef(new Set<string>());
  const currencyChangeableRef = useRef(new Map<string, boolean>());
  useEffect(() => {
    siblingOriginalsRef.current = new WeakMap();
    currencyNoticedRef.current = new Set();
    currencyChangeableRef.current = new Map();
  }, [data]);

  const visibleStatic = useMemo(
    () => staticColumns.filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const metaOf = useMemo(() => new Map(visibleStatic.map(c => [c.colNm, c])), [visibleStatic]);
  const fixedBindings = useMemo(() => visibleStatic.map(c => c.colNm), [visibleStatic]);
  // 묶음 머지 대상 = Measure 앞 고정 칸 (Measure 와 기간 칸은 행마다 다르다).
  const mergeBindings = useMemo(() => {
    const at = fixedBindings.indexOf('MEASURE');
    return at < 0 ? fixedBindings : fixedBindings.slice(0, at);
  }, [fixedBindings]);
  const fixedRef = useRef(fixedBindings);
  fixedRef.current = fixedBindings;
  const mergeRef = useRef(mergeBindings);
  mergeRef.current = mergeBindings;
  const mergeManager = useMemo(
    () => new ModelGroupMergeManager(() => mergeRef.current, () => fixedRef.current),
    []
  );

  const periodBindings = useMemo(
    () => periodBindingsOf(periodKeys, data, bucketType),
    [periodKeys, data, bucketType]
  );
  const periodColumns = useMemo(
    // 너비 미지정(undefined)이면 buildPeriodColumns 기본 매개변수(90)가 적용된다.
    () => buildPeriodColumns(periodBindings, bucketType, periodColumnWidth),
    [periodBindings, bucketType, periodColumnWidth]
  );
  // 셀 콤보의 @divisionId (TeambyDivision 등). 행 값으로 좁히는 조건은 컬럼 메타 ATTRIBUTE2 가 맡는다.
  const comboParams = useMemo(() => ({ divisionId: `'${divisionId}'` }), [divisionId]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // LOC 칸을 열 수 있는가 — LOC 행 · 이번 주 이후 · Price Master Representative = Y (설계서 W_ I57, [사업부별 분기] G5).
    const canEditLoc = (row: ModelGroupRow | undefined, binding: string): boolean =>
      !g.isReadOnly &&
      cellOf(row, 'MEASURE') === MEASURE_CODE.LOC &&
      !isPastPeriodKey(binding, monday) &&
      cellOf(row, 'PRC_RPSN') === PRC_RPSN.YES;

    // 기존 묶음의 Currency 를 바꿀 수 있는가 — 묶음의 현재 Price Master Representative 가 Y 일 때만(판가와 같은 기준).
    //   Y = 통화 · 판가 변경 가능, N = 둘 다 변경 불가 (2026-11-23 개발 서버 요청. 종전 "이번 주 이후 값이 있는 묶음만"
    //   조건은 폐기 — Y 면 값이 없어도 연다. 0 만 남긴 채 통화만 바꿔 저장하면 save 의 NO_PRICE(MSG00328) 검사가 막는다).
    //   Y 에서 통화를 바꾼 뒤 N 으로 돌려도 바꾼 통화는 되돌리지 않는다(사용자 결정 2026-11-23) — 저장은 utils/save 의
    //   N 묶음 통화 변경 경로(writeCurrencyWeeksN)가 맡는다.
    const canChangeCurrency = (row: ModelGroupRow): boolean => {
      const key = originBundleKeyOf(row);
      const cached = currencyChangeableRef.current.get(key);
      if (cached !== undefined) return cached;
      const loc = (g.collectionView?.items ?? []).find(
        item => cellOf(item, 'MEASURE') === MEASURE_CODE.LOC && sameBundle(item, row)
      );
      const result = cellOf(loc, 'PRC_RPSN') === PRC_RPSN.YES;
      currencyChangeableRef.current.set(key, result);
      return result;
    };

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const row = (e.panel.rows[e.row] as unknown as { dataItem?: ModelGroupRow })?.dataItem;
      if (isPeriodKey(binding)) {
        const past = isPastPeriodKey(binding, monday);
        toggleClass(e.cell, 'wj-cell-editable', !past && canEditLoc(row, binding));
        toggleClass(e.cell, 'wj-cell-non-editable', past);
        return;
      }
      // 자동 입력 칸은 신규 행이어도 노랗게 칠하지 않는다(메타 IO 를 화면이 막는다, 설계서 R45 · R46).
      if (isAutoMapped(binding)) {
        toggleClass(e.cell, 'wj-cell-editable', false);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
      }
      // 기존 묶음 Currency — 바꿀 수 없는 묶음(Price Master Representative N)은 입력 칸으로 칠하지 않는다.
      if (binding === 'CURRENCY' && row && !isInsertRow(row) && !canChangeCurrency(row)) {
        toggleClass(e.cell, 'wj-cell-editable', false);
      }
    };

    const beginningEdit = (s: FlexGrid<ModelGroupRow>, e: { cancel: boolean; row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as ModelGroupRow | undefined;
      if (s.isReadOnly) {
        e.cancel = true;
        return;
      }
      if (isPeriodKey(binding)) {
        if (!canEditLoc(row, binding)) {
          e.cancel = true;
          return;
        }
        if (cellOf(row, 'CURRENCY') === '') {
          e.cancel = true;
          void useMessageStore
            .getState()
            .setAlert({ type: 'alert', content: t(MSG.CURRENCY_EMPTY, '_Currency를 입력하세요.') });
          return;
        }
        e.cancel = false;
      } else if (isAutoMapped(binding) || isPopupColumn(metaOf.get(binding))) {
        // Team · End Customer 는 자동 입력, Project Code · Model Group 은 팝업으로만 고른다(설계서 R48 · I50).
        e.cancel = true;
        return;
      } else if (binding === 'CURRENCY' && row && !isInsertRow(row)) {
        // 기존 묶음 Currency — 칸 설정(입력 구분 M)이 열어 준 경우에만 온다. 공용 판정이 이미 막았으면 그대로 둔다.
        if (e.cancel) return;
        if (!canChangeCurrency(row)) {
          e.cancel = true;
          return;
        }
        const noticeKey = originBundleKeyOf(row);
        if (!currencyNoticedRef.current.has(noticeKey)) {
          currencyNoticedRef.current.add(noticeKey);
          e.cancel = true;
          void useMessageStore.getState().setAlert({
            type: 'alert',
            content: t(
              MSG.CURRENCY_CHANGE_SCOPE,
              '_화면에 조회된 기간의 데이터만 Currency가 변경됩니다. 기간을 확인하시고 Currency 변경을 진행해주세요.'
            ),
          });
          return;
        }
      }
      editingRef.current = { binding, oldVal: row?.[binding] };
    };

    const pastingCell = (s: FlexGrid<ModelGroupRow>, e: { cancel: boolean; row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as ModelGroupRow | undefined;
      if (s.isReadOnly || isAutoMapped(binding) || isPopupColumn(metaOf.get(binding))) {
        e.cancel = true;
        return;
      }
      // 기존 묶음 Currency 는 붙여넣기로 바꾸지 않는다 — 안내 · 묶음 전파 · 재계산이 편집 흐름에 묶여 있다.
      if (binding === 'CURRENCY' && row && !isInsertRow(row)) {
        e.cancel = true;
        return;
      }
      if (!isPeriodKey(binding)) return;
      e.cancel = !canEditLoc(row, binding) || cellOf(row, 'CURRENCY') === '';
    };

    // 묶음의 LOC 수정분 되돌리기 — 조회된 묶음은 원래 값으로(수정 표시도 풀림), 신규 묶음은 빈 값으로.
    const revertLocEdits = (bundle: ModelGroupRow[]) => {
      const loc = bundle.find(item => cellOf(item, 'MEASURE') === MEASURE_CODE.LOC);
      if (!loc) return;
      const siblings = bundle.filter(item => item !== loc);
      if (isInsertRow(loc)) {
        for (const key of Object.keys(loc).filter(isPeriodKey)) {
          loc[key] = null;
          for (const item of siblings) item[key] = null;
        }
        return;
      }
      const tracker = editTrackerRef.current;
      const changed = { ...(tracker?.getOriginalValues().get(loc) ?? {}) };
      for (const key of Object.keys(changed).filter(isPeriodKey)) {
        tracker?.storeChange(loc, key, loc[key], changed[key]);
        loc[key] = changed[key];
      }
      for (const item of siblings) {
        const kept = siblingOriginalsRef.current.get(item);
        if (!kept) continue;
        for (const [key, value] of Object.entries(kept)) item[key] = value;
        siblingOriginalsRef.current.delete(item);
      }
    };

    const cellEditEnded = (s: FlexGrid<ModelGroupRow>, e: { row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as ModelGroupRow | undefined;
      const prev = editingRef.current;
      editingRef.current = null;
      if (!row) return;
      const items = s.collectionView.items;
      const bundle = items.filter(item => sameBundle(item, row));
      // 값이 바뀌었으니 Currency 변경 가능 판정을 다시 한다.
      currencyChangeableRef.current.clear();

      // (1) LOC 칸 → 같은 묶음 KRW · USD 를 그 달 환율로 다시 계산 (설계서 W_ I57, [Measure 규칙] E4).
      //   덮어쓰기 전 값을 처음 한 번만 기억한다 — N 으로 바꿀 때 되돌린다((2) 참조).
      if (isPeriodKey(binding)) {
        const loc = numberOf(row[binding]);
        for (const item of bundle) {
          const measure = cellOf(item, 'MEASURE');
          if (item === row || measure === MEASURE_CODE.LOC) continue;
          const kept = siblingOriginalsRef.current.get(item) ?? {};
          if (!(binding in kept)) kept[binding] = item[binding] ?? null;
          siblingOriginalsRef.current.set(item, kept);
          item[binding] =
            loc === null
              ? null
              : convertLocPrice(
                  rateMapRef.current,
                  cellOf(row, 'DIVISION_ID'),
                  cellOf(row, 'CURRENCY'),
                  measure,
                  binding.slice(2, 8),
                  loc
                );
        }
        s.invalidate(true);
        return;
      }

      const newVal = row[binding];
      const changed = prev?.binding === binding && safeString(prev.oldVal) !== safeString(newVal);

      // (2) Price Master Representative — 묶음 단위 한 값 (설계서 PRC_RPSN I51). 묶음 전 행에 같은 값과 수정 표시를 남긴다.
      //   머지 셀이라 그리드가 다른 행에도 새 값을 이미 써 넣었을 수 있다 — 원본은 편집 시작 때 잡은 값을 쓴다.
      //   편집한 행 자신은 공용 EditTracker 가 먼저 기록했으므로 다시 기록하지 않는다.
      if (binding === 'PRC_RPSN') {
        for (const item of bundle) {
          if (item === row) continue;
          if (!isInsertRow(item)) {
            const original = prev?.binding === binding ? prev.oldVal : item[binding];
            editTrackerRef.current?.storeChange(item, binding, original as WijmoPrimitive, newVal);
          }
          item[binding] = newVal;
        }
        // N 으로 바꾸면 이 묶음의 LOC 는 저장되지 않는다(Y → N 은 PRC_RPSN 만 바뀜, 설계서 R51).
        //   화면에 고친 숫자가 잠긴 채 남지 않도록 LOC 와 다시 계산한 KRW · USD 를 원래 값으로 되돌린다(사용자 결정 2026-11-06).
        if (cellOf(row, 'PRC_RPSN') !== PRC_RPSN.YES) revertLocEdits(bundle);
        s.invalidate(true);
        return;
      }

      // (2b) 기존 묶음 Currency — 묶음 전 행에 새 통화, 조회된 이번 주 이후 칸의 KRW · USD 를 새 통화 환율로 다시 계산.
      //   저장도 이 칸들만 새 통화로 보낸다 — 조회 기간 밖 · 지난 주는 옛 통화로 남는다(MSG01429, 프로시저 3-0).
      //   저장은 utils/save 가 맡는다: 묶음 전 행의 CURRENCY 변경 기록이 "통화를 바꾼 묶음" 표식이다.
      //   Currency 칸은 묶음 3행이 머지된 한 칸이라 그리드가 형제 행에도 새 값을 이미 써 넣었을 수 있다 —
      //   묶음은 조회 시점 묶음 키로 찾고(sameBundle), 원래 값은 편집 시작 때 잡아 둔 값을 쓴다.
      if (binding === 'CURRENCY' && !isInsertRow(row)) {
        if (prev?.binding !== 'CURRENCY') return;
        const tracker = editTrackerRef.current;
        const oldCur = safeString(prev.oldVal).trim();
        const newCur = cellOf(row, 'CURRENCY');
        // 빈 통화로는 바꾸지 않는다 — 통화는 묶음 키라 비우면 저장할 수 없다. 묶음 전체를 직전 값으로 되돌린다.
        if (newCur === '') {
          for (const item of bundle) {
            tracker?.storeChange(item, 'CURRENCY', oldCur, oldCur);
            item.CURRENCY = oldCur;
          }
          s.invalidate(true);
          return;
        }
        if (newCur === oldCur) return;
        for (const item of bundle) {
          // 편집한 행은 공용 EditTracker 가 먼저 기록했다 — 여기서 다시 기록하면 직전 값이 원본으로 잡힌다.
          if (item !== row) tracker?.storeChange(item, 'CURRENCY', oldCur, newCur);
          item.CURRENCY = newCur;
        }
        const loc = bundle.find(item => cellOf(item, 'MEASURE') === MEASURE_CODE.LOC);
        if (loc) {
          const locChanges = tracker?.getOriginalValues().get(loc);
          // 조회 시점 통화로 되돌아왔는가 — 그러면 LOC 를 고치지 않은 칸의 KRW · USD 는 조회된 값으로 되돌린다.
          const backToOrigin = !(locChanges && 'CURRENCY' in locChanges);
          const division = cellOf(loc, 'DIVISION_ID');
          for (const key of Object.keys(loc)) {
            if (!isPeriodKey(key) || isPastPeriodKey(key, monday)) continue; // 지난 칸은 옛 통화 그대로
            const price = numberOf(loc[key]);
            const locEdited = !!locChanges && key in locChanges;
            for (const item of bundle) {
              const measure = cellOf(item, 'MEASURE');
              if (item === loc || measure === MEASURE_CODE.LOC) continue;
              const kept = siblingOriginalsRef.current.get(item) ?? {};
              if (backToOrigin && !locEdited) {
                if (key in kept) {
                  item[key] = kept[key];
                  delete kept[key];
                }
                continue;
              }
              if (price === null) continue; // 가격이 없는 칸은 바꿀 값이 없다
              if (!(key in kept)) kept[key] = item[key] ?? null;
              siblingOriginalsRef.current.set(item, kept);
              item[key] = convertLocPrice(rateMapRef.current, division, newCur, measure, key.slice(2, 8), price);
            }
          }
        }
        s.invalidate(true);
        return;
      }

      // (3) 신규 행 고정 칸 — 묶음 3행에 같은 값, 상위 칸이 바뀌면 하위 칸을 비운다.
      if (!isInsertRow(row)) return;
      for (const item of bundle) item[binding] = newVal;
      if (changed) {
        const clear = GRID_CASCADE_CLEAR[binding] ?? [];
        for (const item of bundle) for (const col of clear) item[col] = '';
        if (binding === 'SCM_SITE_ID') {
          const endCustomer = siteEcMapRef.current.get(safeString(newVal).trim()) ?? '';
          for (const item of bundle) item.END_CUSTOMER = endCustomer;
        }
      }
      s.invalidate(true);
    };

    // 신규 행의 팝업 칸(Project Code · Model Group)을 두 번 누르면 공용 팝업을 연다(POP-10 신규 행 가드).
    let lastClick = { ts: 0, row: -1, col: -1 };
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      const isDouble =
        ht.cellType === CellType.Cell &&
        ht.row === lastClick.row &&
        ht.col === lastClick.col &&
        ev.timeStamp - lastClick.ts < DBLCLICK_MS;
      lastClick = isDouble ? { ts: 0, row: -1, col: -1 } : { ts: ev.timeStamp, row: ht.row, col: ht.col };
      if (!isDouble || g.isReadOnly) return;
      const meta = metaOf.get(g.columns[ht.col]?.binding ?? '');
      const row = g.rows[ht.row]?.dataItem as ModelGroupRow | undefined;
      if (!meta || !isPopupColumn(meta) || !isInsertRow(row) || !row) return;
      if (meta.attribute1) onPopupCellDblClick(meta.attribute1, row);
    };

    // 머지는 보이는 행 안에서만 계산하므로 스크롤하면 다시 그린다(GRID-10).
    const onScroll = () => g.invalidate();

    g.formatItem.addHandler(formatHandler);
    g.beginningEdit.addHandler(beginningEdit);
    g.pastingCell.addHandler(pastingCell);
    g.cellEditEnded.addHandler(cellEditEnded);
    g.pastedCell.addHandler(cellEditEnded);
    g.scrollPositionChanged.addHandler(onScroll);
    g.hostElement.addEventListener('click', clickHandler);
    g.invalidate(true);

    return () => {
      g.formatItem.removeHandler(formatHandler);
      g.beginningEdit.removeHandler(beginningEdit);
      g.pastingCell.removeHandler(pastingCell);
      g.cellEditEnded.removeHandler(cellEditEnded);
      g.pastedCell.removeHandler(cellEditEnded);
      g.scrollPositionChanged.removeHandler(onScroll);
      g.hostElement?.removeEventListener('click', clickHandler);
    };
  }, [gridRef, editTrackerRef, metaOf, monday, onPopupCellDblClick, t, periodColumns]);

  // 머리글 행 높이 — 총 48px 를 실제 머리글 행 수로 나눈다(UI-04 깊이 불일치 화면의 단일 효과).
  useEffect(() => {
    const g = gridRef.current;
    return g ? attachHeaderHeightNormalizer(g as never) : undefined;
  }, [gridRef, periodColumns, visibleStatic]);

  // 묶음 머지 유지 — 미저장 변경 되돌리기 등 공용 경로가 머지를 기본값으로 바꾸면 다시 건다(keepMergeManager 주석).
  useEffect(() => {
    const g = gridRef.current;
    return g ? keepMergeManager(g as never, mergeManager) : undefined;
  }, [gridRef, mergeManager, periodColumns]);

  return (
    <DataGrid<ModelGroupRow>
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={periodColumns}
      autoGenerateColumns={false}
      comboParams={comboParams}
      sheetName={SHEETS.MAIN}
      saveAuth={{ sheetName: SHEETS.MAIN }}
      allowMerging={AllowMerging.All}
      mergeManager={mergeManager}
    />
  );
};
