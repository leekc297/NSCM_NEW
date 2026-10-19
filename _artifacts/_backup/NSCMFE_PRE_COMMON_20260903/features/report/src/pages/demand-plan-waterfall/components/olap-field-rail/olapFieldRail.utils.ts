import type { PivotEngine, PivotField, PivotFieldCollection } from '@mescius/wijmo.olap';

/**
 * OLAP Field Rail — 순수 유틸 (PivotEngine ↔ 레일 상태 모델).
 *   디자인 핸드오프 `design_handoff_olap_field_panel/README.md` §State Management 를 따르되,
 *   진실의 원천은 **PivotEngine 의 필드 컬렉션**이다(rowFields/columnFields/filterFields/valueFields).
 *   레일은 엔진을 스냅샷해 그리고, 편집은 엔진 컬렉션에 바로 쓴다 → 같은 엔진을 쓰는 그리드가 즉시 반영.
 */

export type ZoneId = 'filters' | 'columns' | 'rows' | 'values';
export const ZONES: readonly ZoneId[] = ['filters', 'columns', 'rows', 'values'];

/** wijmo Aggregate 열거값 (wijmo.Aggregate — Sum=1 / Cnt=2 / Avg=3 / Max=4). 레일이 노출하는 4종만. */
export const AGGREGATES = [
  { value: 1, label: 'Sum' },
  { value: 3, label: 'Average' },
  { value: 4, label: 'Max' },
  { value: 2, label: 'Count' },
] as const;
export type AggregateValue = (typeof AGGREGATES)[number]['value'];
export const aggregateLabel = (value: number): string =>
  AGGREGATES.find(a => a.value === value)?.label ?? 'Sum';

/** wijmo DataType.Number = 2 — 숫자 필드를 측정값(Σ)으로 본다. */
const DATA_TYPE_NUMBER = 2;

export interface RailField {
  /** 엔진 필드 키 = header (PivotFieldCollection.getField 는 header 로 조회) */
  key: string;
  name: string;
  type: 'dimension' | 'measure';
  /** 배치된 영역 (없으면 미선택) */
  zone: ZoneId | null;
  /** 값 영역일 때 집계 */
  aggregate: number;
  /** Filters 영역 — 값 필터가 걸려 있는가 (PivotField.filter.isActive). 사용자 지시 2026-08-28 필터 편집 UI */
  filterActive: boolean;
  /** [E20260831-MEASURE] 원본 바인딩 컬럼 — MEASURE 축 고정 판정용 (header 표기와 무관한 안정 키) */
  binding: string;
}

export interface RailSnapshot {
  fields: RailField[];
  zones: Record<ZoneId, RailField[]>;
}

const collectionOf = (engine: PivotEngine, zone: ZoneId): PivotFieldCollection =>
  zone === 'filters'
    ? engine.filterFields
    : zone === 'columns'
      ? engine.columnFields
      : zone === 'rows'
        ? engine.rowFields
        : engine.valueFields;

const toArray = (c: PivotFieldCollection): PivotField[] => {
  const out: PivotField[] = [];
  for (let i = 0; i < c.length; i += 1) out.push(c[i]);
  return out;
};

const zoneOfField = (engine: PivotEngine, field: PivotField): ZoneId | null => {
  for (const z of ZONES) {
    if (toArray(collectionOf(engine, z)).includes(field)) return z;
  }
  return null;
};

/** 엔진 → 레일 스냅샷. 필드 목록 순서 = engine.fields 등록 순서(= titleset 순). */
export const snapshotEngine = (engine: PivotEngine): RailSnapshot => {
  const fields = toArray(engine.fields).map<RailField>(f => ({
    key: f.header,
    name: f.header,
    type: Number(f.dataType) === DATA_TYPE_NUMBER ? 'measure' : 'dimension',
    zone: zoneOfField(engine, f),
    aggregate: Number(f.aggregate),
    filterActive: !!f.filter?.isActive,
    binding: String(f.binding ?? ''),
  }));
  const byKey = new Map(fields.map(f => [f.key, f]));
  const zones = Object.fromEntries(
    ZONES.map(z => [
      z,
      toArray(collectionOf(engine, z))
        .map(f => byKey.get(f.header))
        .filter((f): f is RailField => !!f),
    ])
  ) as Record<ZoneId, RailField[]>;
  return { fields, zones };
};

/** 레일 밖(팝오버)에서 필드 객체가 필요할 때 — 필터 편집기 생성용 */
export const getField = (engine: PivotEngine, key: string): PivotField | null =>
  toArray(engine.fields).find(f => f.header === key) ?? null;

const findField = (engine: PivotEngine, key: string): PivotField | null => {
  const all = toArray(engine.fields);
  return all.find(f => f.header === key) ?? null;
};

/** 모든 영역에서 제거 (엔진 컬렉션 직접 편집). */
const removeFromZones = (engine: PivotEngine, field: PivotField) => {
  for (const z of ZONES) {
    const c = collectionOf(engine, z);
    const idx = toArray(c).indexOf(field);
    if (idx >= 0) c.removeAt(idx);
  }
};

/**
 * 필드를 영역의 index 위치에 배치(다른 영역/같은 영역에서 이동 포함).
 *   index 생략 = 맨 뒤. 같은 영역 안 이동은 제거 후 보정된 index 로 삽입한다.
 */
export const placeField = (engine: PivotEngine, key: string, zone: ZoneId, index?: number) => {
  const field = findField(engine, key);
  if (!field) return;
  engine.deferUpdate(() => {
    const target = collectionOf(engine, zone);
    const before = toArray(target).indexOf(field);
    removeFromZones(engine, field);
    let at = index ?? target.length;
    if (before >= 0 && index !== undefined && before < index) at -= 1; // 같은 영역 앞→뒤 이동 보정
    at = Math.max(0, Math.min(at, target.length));
    target.insert(at, field);
  });
};

/** 영역에서 제거(= 미선택). */
export const unplaceField = (engine: PivotEngine, key: string) => {
  const field = findField(engine, key);
  if (!field) return;
  engine.deferUpdate(() => removeFromZones(engine, field));
};

/** 체크박스 토글 — 차원은 Rows, 측정값은 Values 에 덧붙인다(핸드오프 §Interactions). */
export const toggleField = (engine: PivotEngine, f: RailField) => {
  if (f.zone) unplaceField(engine, f.key);
  else placeField(engine, f.key, f.type === 'measure' ? 'values' : 'rows');
};

export const setAggregate = (engine: PivotEngine, key: string, aggregate: AggregateValue) => {
  const field = findField(engine, key);
  if (!field) return;
  engine.deferUpdate(() => {
    field.aggregate = aggregate as unknown as PivotField['aggregate'];
  });
};

/** 검색 — 부분일치·대소문자 무시. 체크된 필드는 목록에서 빠져도 영역엔 남는다. */
export const filterFields = (fields: readonly RailField[], query: string): RailField[] => {
  const q = query.trim().toLowerCase();
  if (!q) return [...fields];
  return fields.filter(f => f.name.toLowerCase().includes(q));
};
