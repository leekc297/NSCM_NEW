// DMF0045 — BOH(기초재고) 앞채움 파생 표시 (design 03 §3 line 144 — AS-IS Set_SumValues).
//   measure ∈ {WH_BOH_PLAN, WH_BOH_REQ} 행은 "첫 D_ 값"을 선행 M_/W_ 합계 컬럼에 복사한다.
//   BOH 는 기간 합계가 아니라 기초 재고 스냅샷이라, 상위 버킷(M_/W_) 에도 같은 기초값을 표기한다
//   (AS-IS 는 로드 후 Set_SumValues 로 파생 표기 — 저장 대상 아님, 순수 표시 파생).
//
//   순수 함수: 조회 rows 를 받아 BOH 행의 M_/W_ 셀에 첫 D_ 값을 채운 "새 rows" 를 돌려준다.
//   원본 rows 는 변형하지 않는다(React memo 참조 안정성 — mainData 캐시 객체 보존). BOH 가 아닌
//   행은 원본 참조 그대로 통과시켜 불필요한 재생성/머지 재계산을 막는다.
import { BOH_MEASURES } from '../dmf0045.constants';
import type { ShipmentRequestRow } from '../dmf0045.types';

import { dynKindOf } from './dmf0045.editLock';

const BOH_SET = new Set<string>(BOH_MEASURES);

// 행에서 가장 이른 D_ 컬럼의 값 — binding(D_yyyymmdd) 오름차순 첫 실값. 값이 하나도 없으면 null.
const firstDayValue = (row: ShipmentRequestRow): number | null => {
  const rec = row as Record<string, unknown>;
  let firstBinding = '';
  for (const key of Object.keys(rec)) {
    if (dynKindOf(key) !== 'D') continue;
    if (rec[key] == null || rec[key] === '') continue;
    if (!firstBinding || key < firstBinding) firstBinding = key;
  }
  if (!firstBinding) return null;
  const raw = rec[firstBinding];
  const n = typeof raw === 'number' ? raw : Number(raw);
  return Number.isFinite(n) ? n : null;
};

// BOH 앞채움 적용 — 대상 measure 행만 선행 M_/W_ 셀을 첫 D_ 값으로 복사한 새 객체로 교체.
//   대상 아님/첫 D_ 값 없음이면 원본 행 참조를 그대로 반환(no-op).
export const applyBohFrontFill = (rows: ShipmentRequestRow[]): ShipmentRequestRow[] => {
  if (rows.length === 0) return rows;
  let changed = false;
  const out = rows.map(row => {
    const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
    if (!BOH_SET.has(measure)) return row;
    const boh = firstDayValue(row);
    if (boh == null) return row;
    const next = { ...(row as Record<string, unknown>) };
    for (const key of Object.keys(next)) {
      const kind = dynKindOf(key);
      if (kind === 'M' || kind === 'W') next[key] = boh;
    }
    changed = true;
    return next as ShipmentRequestRow;
  });
  // 변경 행이 없으면 원본 배열 참조 유지(memo 안정성).
  return changed ? out : rows;
};
