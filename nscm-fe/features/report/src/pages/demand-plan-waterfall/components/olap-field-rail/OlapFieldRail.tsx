import { PivotFilterEditor, type PivotEngine } from '@mescius/wijmo.olap';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { clsx } from '@shared/clsx';

import type { RowTotalsMode } from '../../demand-plan-waterfall.types';

import styles from './OlapFieldRail.module.scss';
import {
  AGGREGATES,
  aggregateLabel,
  filterFields,
  getField,
  placeField,
  setAggregate,
  snapshotEngine,
  toggleField,
  unplaceField,
  type RailField,
  type RailSnapshot,
  type ZoneId,
} from './olapFieldRail.utils';
import {
  CheckIcon,
  ChevronDownIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  Columns3Icon,
  FilterIcon,
  GripVerticalIcon,
  Rows3Icon,
  SearchIcon,
  SigmaIcon,
  XIcon,
} from './RailIcons';

/**
 * OLAP Field Rail — 디자인 핸드오프 "1a Docked field rail" 재현 (2026-08-27).
 *   `C:\TRANFILE\RECEIVE\React 위즈모 OLAP 디자인 개선\design_handoff_olap_field_panel\README.md`
 *   구성(위→아래): 헤더(Grid layout · Hide ›) / Subtotal 셀렉트 + 필드 검색 / 필드 체크리스트(n/N selected) /
 *   Filters·Columns·Rows·Values 4영역(칩·DnD) / Defer updates + Update.
 *
 *   Wijmo `PivotPanel` 은 쓰지 않는다 — 같은 PivotEngine 의 필드 컬렉션을 레일이 직접 편집하고
 *   (utils.placeField 등), 그리드(OlapPivotGrid)는 같은 엔진을 보므로 즉시 반영된다.
 *   Defer updates = engine.beginUpdate() 로 뷰 갱신을 보류, [Update] = endUpdate → 재계산.
 *   Subtotal 은 화면 store(rowTotals) → OlapPivotGrid prop 경로를 그대로 쓴다(그리드 메타 스트립에 에코).
 */

const ROW_TOTALS_OPTIONS: Array<{ value: RowTotalsMode; label: string }> = [
  { value: 'GrandTotals', label: 'Grand Totals (총계만)' },
  { value: 'Subtotals', label: 'Subtotals (소계 포함)' },
  { value: 'None', label: 'None (합계 없음)' },
];

const ZONE_META: Record<ZoneId, { title: string; icon: () => JSX.Element; size: 'sm' | 'lg' }> = {
  filters: { title: 'Filters', icon: () => <FilterIcon />, size: 'sm' },
  columns: { title: 'Columns', icon: () => <Columns3Icon />, size: 'sm' },
  rows: { title: 'Rows', icon: () => <Rows3Icon />, size: 'lg' },
  values: { title: 'Values', icon: () => <SigmaIcon />, size: 'lg' },
};

interface DragPayload {
  key: string;
}
interface DropTarget {
  zone: ZoneId;
  index: number;
}

/**
 * Filters 영역 칩의 값 필터 편집 팝오버 — wijmo `PivotFilterEditor`(값 체크리스트 + 조건 필터) 를 그대로 마운트한다.
 *   사용자 지시 2026-08-28: "GRID LAYOUT 에서 FILTERS 에 COLUMN 을 이동해도 FILTER 할 수 있는 영역이 보이지 않음".
 *   [Apply] = editor.updateFilter() → field.filter 갱신 → 엔진이 뷰를 재계산 / [Clear] = 필터 해제.
 */
const FilterEditorPopover = ({
  engine,
  fieldKey,
  onClose,
  onApplied,
}: {
  engine: PivotEngine;
  fieldKey: string;
  onClose: () => void;
  onApplied: () => void;
}) => {
  const { t } = useTranslation();
  const hostRef = useRef<HTMLDivElement | null>(null);
  const editorRef = useRef<PivotFilterEditor | null>(null);
  useEffect(() => {
    const field = getField(engine, fieldKey);
    if (!hostRef.current || !field) return;
    const editor = new PivotFilterEditor(hostRef.current, field);
    editorRef.current = editor;
    return () => {
      editorRef.current = null;
      editor.dispose();
    };
  }, [engine, fieldKey]);
  return (
    <div className={styles.filterPop} role='dialog' onMouseDown={e => e.stopPropagation()}>
      <div ref={hostRef} className={styles.filterHost} />
      <div className={styles.filterActions}>
        <button
          type='button'
          className={styles.btnGhost}
          onClick={() => {
            editorRef.current?.clearEditor();
            editorRef.current?.updateFilter();
            onApplied();
            onClose();
          }}
        >
          {t('', 'Clear')}
        </button>
        <span className={styles.spacer} />
        <button type='button' className={styles.btnGhost} onClick={onClose}>
          {t('', 'Cancel')}
        </button>
        <button
          type='button'
          className={styles.btnPrimary}
          onClick={() => {
            editorRef.current?.updateFilter();
            onApplied();
            onClose();
          }}
        >
          {t('', 'Apply')}
        </button>
      </div>
    </div>
  );
};

interface OlapFieldRailProps {
  /** 그리드가 공유하는 PivotEngine — 조회 전엔 null (필드 없음 안내) */
  engine: PivotEngine | null;
  rowTotals: RowTotalsMode;
  onRowTotalsChange: (mode: RowTotalsMode) => void;
  open: boolean;
  onToggleOpen: (open: boolean) => void;
}

export const OlapFieldRail = ({
  engine,
  rowTotals,
  onRowTotalsChange,
  open,
  onToggleOpen,
}: OlapFieldRailProps) => {
  const { t } = useTranslation();

  // ── 엔진 스냅샷 (필드/영역) — 엔진 이벤트에 따라 재촬영 ──
  const [snap, setSnap] = useState<RailSnapshot>({
    fields: [],
    zones: { filters: [], columns: [], rows: [], values: [] },
  });
  const refresh = useCallback(() => {
    if (engine) setSnap(snapshotEngine(engine));
  }, [engine]);
  useEffect(() => {
    if (!engine) return;
    refresh();
    engine.viewDefinitionChanged.addHandler(refresh);
    engine.updatedView.addHandler(refresh);
    return () => {
      engine.viewDefinitionChanged.removeHandler(refresh);
      engine.updatedView.removeHandler(refresh);
    };
  }, [engine, refresh]);

  // ── Defer updates — engine.beginUpdate 로 보류, Update 로 커밋 ──
  const [defer, setDefer] = useState(false);
  const [pendingCount, setPendingCount] = useState(0);
  const deferRef = useRef(false);
  const afterEdit = useCallback(() => {
    // [E20260831-W39] VERSION_NO 말미 고정 (정적→VERSION→동적).
    // [E20260831-W45] MEASURE 위치 강제(구 MEASROW 말미 고정)·드래그 봉인 해제 (사용자 지시 "메저 COLUMN FIX 해제") —
    //   MEASURE 축 자체는 필수 유지(X 제거 버튼만 계속 숨김), 위치는 자유 이동.
    if (engine) {
      const rows = engine.rowFields;
      for (const pin of ['VERSION_NO']) {
        for (let i = 0; i < rows.length; i += 1) {
          if (String(rows[i].binding) === pin && i !== rows.length - 1) {
            const f = rows[i];
            rows.removeAt(i);
            rows.push(f);
            break;
          }
        }
      }
    }
    if (deferRef.current) setPendingCount(n => n + 1);
    refresh();
  }, [engine, refresh]);
  const handleDeferChange = (on: boolean) => {
    if (!engine) return;
    deferRef.current = on;
    setDefer(on);
    if (on) engine.beginUpdate();
    else {
      engine.endUpdate(); // 보류분 즉시 반영
      setPendingCount(0);
    }
  };
  const handleUpdate = () => {
    if (!engine || !deferRef.current) return;
    engine.endUpdate();
    engine.beginUpdate(); // 계속 보류 모드 유지
    setPendingCount(0);
  };
  // 언마운트/엔진 교체 시 보류 해제 — 엔진이 isUpdating 에 갇히지 않게
  useEffect(
    () => () => {
      if (engine && deferRef.current) {
        engine.endUpdate();
        deferRef.current = false;
      }
    },
    [engine]
  );

  // ── [E20260831-RAILSPLIT] 섹션 세로 리사이즈 (컨트롤·Fields — null=기본 flex 배분) ──
  const [controlsH, setControlsH] = useState<number | null>(null);
  const [fieldsH, setFieldsH] = useState<number | null>(null);
  const startSplit = (e: React.PointerEvent<HTMLDivElement>, which: 'controls' | 'fields') => {
    e.preventDefault();
    const section = e.currentTarget.previousElementSibling as HTMLElement | null;
    if (!section) return;
    const startY = e.clientY;
    const startH = section.getBoundingClientRect().height;
    const move = (ev: PointerEvent) => {
      const h = Math.max(48, Math.min(600, startH + (ev.clientY - startY)));
      (which === 'controls' ? setControlsH : setFieldsH)(h);
    };
    const up = () => {
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
  };

  // ── 검색 ──
  const [query, setQuery] = useState('');
  // [E20260831-MEASURE] MEASURE 는 OLAP 필수 행 축 — 레일 Fields 목록에서 제외(체크 해제·이동 대상 아님.
  //   사용자 지시 2026-08-31 "우측 Layout 에 Measure 는 제외 + OLAP GRID 에 MEASURE 필수")
  const visibleFields = useMemo(
    () => filterFields(snap.fields, query).filter(f => f.binding !== 'MEASURE'),
    [snap.fields, query]
  );
  const selectedCount = snap.fields.filter(f => f.zone).length;

  // ── DnD (HTML5 — ColumnLayoutList 패턴) ──
  const dragRef = useRef<DragPayload | null>(null);
  const [dragKey, setDragKey] = useState<string | null>(null);
  const [dropAt, setDropAt] = useState<DropTarget | null>(null);
  const endDrag = () => {
    dragRef.current = null;
    setDragKey(null);
    setDropAt(null);
  };
  const startDrag = (key: string) => {
    dragRef.current = { key };
    setDragKey(key);
  };
  const dropTo = (zone: ZoneId, index: number) => {
    const p = dragRef.current;
    endDrag();
    if (!p || !engine) return;
    placeField(engine, p.key, zone, index);
    afterEdit();
  };
  const onZoneDragOver = (zone: ZoneId, index: number) => (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (!dropAt || dropAt.zone !== zone || dropAt.index !== index) setDropAt({ zone, index });
  };

  // ── 값 칩 집계 메뉴 ──
  const [aggMenuKey, setAggMenuKey] = useState<string | null>(null);
  useEffect(() => {
    if (!aggMenuKey) return;
    const close = () => setAggMenuKey(null);
    window.addEventListener('mousedown', close);
    return () => window.removeEventListener('mousedown', close);
  }, [aggMenuKey]);

  // ── Filters 칩 필터 편집 팝오버 (사용자 지시 2026-08-28) ──
  const [filterKey, setFilterKey] = useState<string | null>(null);
  useEffect(() => {
    if (!filterKey) return;
    const close = () => setFilterKey(null);
    window.addEventListener('mousedown', close);
    return () => window.removeEventListener('mousedown', close);
  }, [filterKey]);

  if (!open) {
    return (
      <aside className={clsx(styles.rail, styles.railCollapsed)} aria-label='Grid layout (collapsed)'>
        <button
          type='button'
          className={styles.reopen}
          title={t('', 'Show Grid Layout')}
          onClick={() => onToggleOpen(true)}
        >
          <ChevronLeftIcon />
        </button>
      </aside>
    );
  }

  // [E20260831-W45] MEASURE 칩 = 드래그 허용(위치 고정 해제) / 제거(X)만 봉인 — OLAP 필수 행 축 유지
  const renderChip = (f: RailField, zone: ZoneId, index: number) => (
    <div
      key={f.key}
      className={clsx(styles.chip, { [styles.dragging]: dragKey === f.key })}
      draggable
      onDragStart={() => startDrag(f.key)}
      onDragEnd={endDrag}
      onDragOver={onZoneDragOver(zone, index)}
      onDrop={e => {
        e.preventDefault();
        e.stopPropagation();
        dropTo(zone, index);
      }}
    >
      {zone !== 'values' && (
        <span className={styles.grip}>
          <GripVerticalIcon />
        </span>
      )}
      <span className={styles.chipName}>{f.name}</span>
      {zone === 'filters' && (
        <span className={styles.agg} onMouseDown={e => e.stopPropagation()}>
          <button
            type='button'
            className={clsx(styles.agg, { [styles.on]: f.filterActive })}
            title={t('', 'Edit filter')}
            onClick={() => setFilterKey(k => (k === f.key ? null : f.key))}
          >
            <FilterIcon />
            {f.filterActive ? ' •' : ''}
          </button>
          {filterKey === f.key && engine && (
            <FilterEditorPopover
              engine={engine}
              fieldKey={f.key}
              onClose={() => setFilterKey(null)}
              onApplied={afterEdit}
            />
          )}
        </span>
      )}
      {zone === 'values' && (
        <span style={undefined} className={styles.agg} onMouseDown={e => e.stopPropagation()}>
          <button
            type='button'
            className={styles.agg}
            onClick={() => setAggMenuKey(k => (k === f.key ? null : f.key))}
          >
            {aggregateLabel(f.aggregate)} <ChevronDownIcon />
          </button>
          {aggMenuKey === f.key && (
            <div className={styles.aggMenu} role='menu'>
              {AGGREGATES.map(a => (
                <button
                  type='button'
                  key={a.value}
                  className={clsx({ [styles.on]: a.value === f.aggregate })}
                  onClick={() => {
                    if (engine) setAggregate(engine, f.key, a.value);
                    setAggMenuKey(null);
                    afterEdit();
                  }}
                >
                  {a.label}
                </button>
              ))}
            </div>
          )}
        </span>
      )}
      {f.binding !== 'MEASURE' && (
        <button
          type='button'
          className={styles.x}
          title={t('', 'Remove')}
          onClick={() => {
            if (engine) unplaceField(engine, f.key);
            afterEdit();
          }}
        >
          <XIcon />
        </button>
      )}
    </div>
  );

  const renderZone = (zone: ZoneId) => {
    const meta = ZONE_META[zone];
    const items = snap.zones[zone];
    const over = dropAt?.zone === zone;
    return (
      <div key={zone} className={clsx(styles.zone, styles[meta.size])}>
        <div className={styles.zoneHead}>
          {meta.icon()}
          {meta.title}
        </div>
        <div
          className={clsx(styles.zoneBody, { [styles.over]: over })}
          onDragOver={onZoneDragOver(zone, items.length)}
          onDrop={e => {
            e.preventDefault();
            dropTo(zone, items.length);
          }}
        >
          {items.length === 0 ? (
            <div className={styles.dropzone}>{t('', 'Drop field')}</div>
          ) : (
            items.map((f, i) => (
              <div key={f.key}>
                {over && dropAt?.index === i && <div className={styles.insertLine} />}
                {renderChip(f, zone, i)}
              </div>
            ))
          )}
          {over && items.length > 0 && dropAt?.index === items.length && (
            <div className={styles.insertLine} />
          )}
        </div>
      </div>
    );
  };

  return (
    <aside className={styles.rail} aria-label='Grid layout'>
      {/* 1. 헤더 */}
      <div className={styles.head}>
        <span className={styles.kicker}>{t('', 'Grid layout')}</span>
        <button type='button' className={styles.btnGhost} onClick={() => onToggleOpen(false)}>
          {t('', 'Hide')} <ChevronRightIcon />
        </button>
      </div>

      {/* 2. 컨트롤 — Subtotal / Search */}
      <div
        className={styles.controls}
        style={controlsH == null ? undefined : { flex: `0 0 ${controlsH}px`, overflowY: 'auto' }}
      >
        <label className={styles.field}>
          <span className={styles.lbl}>{t('', 'Subtotal')}</span>
          <span className={styles.selWrap}>
            <select
              value={rowTotals}
              onChange={e => onRowTotalsChange(e.target.value as RowTotalsMode)}
            >
              {ROW_TOTALS_OPTIONS.map(o => (
                <option key={o.value} value={o.value}>
                  {o.label}
                </option>
              ))}
            </select>
            <span className={styles.chev}>
              <ChevronDownIcon />
            </span>
          </span>
        </label>
        <div className={styles.search}>
          <span className={styles.ico}>
            <SearchIcon />
          </span>
          <input
            type='text'
            value={query}
            placeholder={t('', 'Search fields')}
            onChange={e => setQuery(e.target.value)}
          />
        </div>
      </div>

      {/* [E20260831-RAILSPLIT] 컨트롤 ↕ Fields 스플릿바 (사용자 지시 2026-08-31 — 3 섹션 사이 사이즈 조절) */}
      <div
        className={styles.splitbar}
        role='separator'
        aria-orientation='horizontal'
        onPointerDown={e => startSplit(e, 'controls')}
      />

      {/* 3. 필드 목록 */}
      <div
        className={styles.fieldList}
        style={fieldsH == null ? undefined : { flex: `0 0 ${fieldsH}px` }}
      >
        <div className={styles.fieldListHead}>
          <span className={styles.lbl}>{t('', 'Fields')}</span>
          <span className={styles.count}>
            {selectedCount} / {snap.fields.length} {t('', 'selected')}
          </span>
        </div>
        <div className={styles.fieldListScroll}>
          {!engine ? (
            <div className={styles.empty}>
              {t('', 'Run a search first — the layout editor uses the current pivot data.')}
            </div>
          ) : (
            visibleFields.map(f => (
              <div
                key={f.key}
                className={clsx(styles.fitem, { [styles.dragging]: dragKey === f.key })}
                draggable
                onDragStart={() => startDrag(f.key)}
                onDragEnd={endDrag}
              >
                <button
                  type='button'
                  role='checkbox'
                  aria-checked={!!f.zone}
                  className={clsx(styles.cb, { [styles.on]: !!f.zone })}
                  onClick={() => {
                    toggleField(engine, f);
                    afterEdit();
                  }}
                >
                  <CheckIcon />
                </button>
                <span className={styles.badge} title={f.type}>
                  {f.type === 'measure' ? 'Σ' : 'D'}
                </span>
                <span className={styles.fname} title={f.name}>
                  {f.name}
                </span>
                <span className={styles.spacer} />
                <span className={styles.grip}>
                  <GripVerticalIcon />
                </span>
              </div>
            ))
          )}
        </div>
      </div>

      {/* [E20260831-RAILSPLIT] Fields ↕ 레이아웃(Filters/Columns/Rows/Values) 스플릿바 */}
      <div
        className={styles.splitbar}
        role='separator'
        aria-orientation='horizontal'
        onPointerDown={e => startSplit(e, 'fields')}
      />

      {/* 4. 레이아웃 영역 */}
      <div className={styles.zones}>
        {renderZone('filters')}
        {renderZone('columns')}
        {renderZone('rows')}
        {renderZone('values')}
      </div>

      {/* 5. 푸터 */}
      <div className={styles.foot}>
        <label className={styles.check}>
          <button
            type='button'
            role='checkbox'
            aria-checked={defer}
            className={clsx(styles.cb, { [styles.on]: defer })}
            onClick={() => handleDeferChange(!defer)}
            disabled={!engine}
          >
            <CheckIcon />
          </button>
          {t('', 'Defer updates')}
        </label>
        <button
          type='button'
          className={styles.btnPrimary}
          disabled={!defer || !engine}
          onClick={handleUpdate}
        >
          {t('', 'Update')}
          {defer && pendingCount > 0 && <span className={styles.pending}>• {pendingCount}</span>}
        </button>
      </div>
    </aside>
  );
};

/** 그리드 팬 상단 메타 스트립 — 현재 Subtotal 모드 + 차원/측정값/행 수 (핸드오프 §Pivot grid pane). */
export const OlapGridMeta = ({
  engine,
  rowTotals,
  rowCount,
}: {
  engine: PivotEngine | null;
  rowTotals: RowTotalsMode;
  rowCount: number;
}) => {
  const label = ROW_TOTALS_OPTIONS.find(o => o.value === rowTotals)?.label ?? rowTotals;
  const dims = engine
    ? engine.rowFields.length + engine.columnFields.length + engine.filterFields.length
    : 0;
  const measures = engine ? engine.valueFields.length : 0;
  return (
    <div className={styles.gridMeta}>
      <span className={styles.kicker}>{label}</span>
      <span className={styles.vr} />
      <span>
        {dims} dimensions · {measures} measure · {rowCount.toLocaleString()} rows
      </span>
    </div>
  );
};
