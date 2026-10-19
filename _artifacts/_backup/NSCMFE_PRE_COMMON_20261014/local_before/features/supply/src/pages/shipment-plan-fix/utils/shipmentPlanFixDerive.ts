// SCP0025 pivot 파생 순수 함수 — read-only 화면이라 편집 롤업(SUM 재집계)은 없다.
//   isoWeek: 3단 헤더 주 span 라벨/그룹핑용. mergeFixReason: O_RC2(Fix Reason 상세)를 Fix Reason 행 D_ 셀에 매핑.

import { MEASURE_FIX_REASON } from '../shipment-plan-fix.constants';

import { pivotKind } from './shipmentPlanFixVisibility';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// ISO 8601 주차 (월요일 기준) — 3단 헤더 주 span 라벨/그룹핑용 (자매 SCP0024 isoWeek 동일).
export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// 행 키 컬럼 — O_RC1(Fix Reason 행)과 O_RC2(Fix Reason 상세)의 매칭 키. 대소문자 무시로 접근(getCI).
//   AS-IS 정합(GSCM SCP0025_ShipmentPlanFix.cs Set_FixReason): FG 행은 division/biz/item/to_site/from_site/
//   incoterms/project_code/transport_mode/lt_total/yyyymmdd/bod_id 로 dtFixReason 를 필터한다(cs L664).
//   O_RC1 메인 pivot 은 이 전체 컬럼을 GROUP BY 하므로(PKG_SCP0025 GET body L112-127) 같은 6키를 공유하되
//   incoterms/project_code/origin/electrode 가 다른 별개 행이 나올 수 있다 — 6키만으로는 서로 다른 lane 의
//   Fix Reason 이 뒤섞인다. SAVE SP DELETE 의 고유키(GET body L752-765)와 동일하게 lane 고유키로 매칭한다.
//   transport_mode/lt_total 은 BOD 마스터(bod_id) 종속이라 DELETE 키에도 없어 제외(중복 판별에 불필요).
//   null 처리 대칭: O_RC1 Fix Reason 행과 O_RC2 모두 origin/electrode 는 NVL '-'(GET L115-118 vs L323-326),
//   incoterms/project_code 는 원값(GET L120-121 vs L328-329)이라 양측 동일 값 → 확장해도 기존 매칭을 깨지 않는다.
const KEY_COLS = [
  'DIVISION_ID',
  'BIZ_TYPE',
  'ITEM_ID',
  'TO_SITE',
  'FROM_SITE',
  'BOD_ID',
  'INCOTERMS',
  'PROJECT_CODE',
  'ORIGIN_FROM_DIVISION_ID',
  'ORIGIN_TO_DIVISION_ID',
  'ELECTRODE_TYPE',
];

// 케이스 무시 컬럼 읽기 — O_RC1(소문자 alias)·O_RC2(문서상 대문자)의 케이스 차이를 흡수한다.
export const getCI = (row: Row, name: string): unknown => {
  if (name in row) return row[name];
  const lower = name.toLowerCase();
  const upper = name.toUpperCase();
  if (lower in row) return row[lower];
  if (upper in row) return row[upper];
  const hit = Object.keys(row).find(k => k.toLowerCase() === lower);
  return hit ? row[hit] : undefined;
};

// 구분자 '|' 로 조인 — 인접 키 컬럼 값이 이어붙어 생기는 concatenation 충돌 방지(shipmentPlanFixSave entryKey 와 동일).
//   구성(reasonByKey)·조회 모두 이 함수를 쓰므로 구분자 변경은 매칭 결과 불변(내부 정합), 충돌만 제거한다.
const rowKey = (row: Row): string => KEY_COLS.map(c => s(getCI(row, c))).join('|');

// O_RC2(Fix Reason 상세: 키 + YYYYMMDD + FIX_REASON, pivot 아닌 원시 행)을 O_RC1 의 Fix Reason 행 D_ 셀에 매핑한다.
//   design 03 §2.3 R-H. 원본 행을 변형하지 않도록 얕은 복사 후 D_<yyyymmdd> 셀에 사유 텍스트를 채운다.
//   (O_RC2 정확 컬럼 케이스는 문서 기준 — 런타임 파리티에서 최종 대사, design 03 §6 #1.)
export const mergeFixReason = (rc1: Row[], rc2: Row[]): Row[] => {
  if (rc1.length === 0) return rc1;
  // 키 → (YYYYMMDD → FIX_REASON) 인덱스 구성.
  const reasonByKey = new Map<string, Map<string, string>>();
  for (const r of rc2) {
    const ymd = s(getCI(r, 'YYYYMMDD')).replace(/[^0-9]/g, '').slice(0, 8);
    const reason = s(getCI(r, 'FIX_REASON'));
    if (!ymd) continue;
    const k = rowKey(r);
    let m = reasonByKey.get(k);
    if (!m) {
      m = new Map();
      reasonByKey.set(k, m);
    }
    m.set(ymd, reason);
  }
  if (reasonByKey.size === 0) return rc1;

  return rc1.map(row => {
    if (s(getCI(row, 'MEASURE')) !== MEASURE_FIX_REASON) return row;
    const m = reasonByKey.get(rowKey(row));
    if (!m || m.size === 0) return row;
    const next: Row = { ...row };
    for (const binding of Object.keys(next)) {
      if (pivotKind(binding) !== 'D') continue;
      const ymd = binding.slice(2).replace(/[^0-9]/g, '').slice(0, 8);
      const reason = m.get(ymd);
      if (reason !== undefined && reason !== '') next[binding] = reason;
    }
    return next;
  });
};
