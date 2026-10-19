// SCP0013 Fix/Unfix 저장 payload 조립 — AS-IS SaveData_FixInfo(cs:2829~3270) 재현.
//   공용 fix 저장 SP(PKG_SCP0024.P_SCP0024_SAVE_PLAN_FIX_DS, SCP0013 fix/SAVE 배선)의 JSON 계약으로 변환.
//   자매 정본: production-plan-fix/utils/productionPlanFixSave.ts(동일 SP) — 거기와 동일 구조이되
//   편집 measure 가 SCP0013 은 PROD_PLAN_AMEND(코드) 다.
//   계약(각 data[] 행): ACTIVE_FLAG(Fix='M' 서버가 존재여부로 I/M 재판정 / Unfix='D' DELETE),
//     DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE,
//     YYYYMMDD(일), QTY, FIX_REASON, ORIGIN_DIVISION_ID, ELECTRODE_TYPE, BUCKET_TYPE.
//   선택 셀 기반(편집 불요) — AS-IS 는 선택 range × PROD_PLAN_AMEND 행 × 일(D_) 셀을 전송한다.
//   주(W_) SUM 셀 선택은 같은 ISO 주의 D_ 셀 전체로 확장(AS-IS cs:3045~3140). SCP0013 주간 조회는
//   일(D_) 컬럼이 없어 확장 결과가 빈다 → fix 는 Daily 버킷에서 동작(사용자 결정 2026-10-08, (가)).

import type { FlexGrid } from '@mescius/wijmo.grid';

import { EDITABLE_MEASURE } from '../production-plan-line.constants';
import type { FixMode } from '../production-plan-line.types';

import { isoWeek } from './productionPlanLineDerive';
import { pivotKind } from './productionPlanLineEditLock';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// D_/W_ 바인딩 → YYYYMMDD(8자리) 또는 주 태그 숫자. D_ 는 일자 8자리.
const dailyDate = (binding: string): string =>
  binding.slice(2).replace(/[^0-9]/g, '').slice(0, 8);

// W_ 바인딩 주차(2자리 ISO 주) — 'W_'+BASIS_YYYYMM+ISO_WEEK. 6자리 태그면 뒤 2자리 fallback.
const weekNumOfBinding = (binding: string): number => {
  const tag = binding.slice(2).replace(/[^0-9]/g, '');
  return Number(tag.slice(6)) || Number(tag.slice(4, 6));
};

export interface FixSaveEntry {
  ACTIVE_FLAG: string; // Fix='M'(서버가 존재여부로 I/M) / Unfix='D'(DELETE) — SP 는 ACTIVE_FLAG 로만 분기
  DIVISION_ID: string;
  OPERATION_GROUP: string;
  SCM_SITE_ID: string;
  ITEM_ID: string;
  LINE_ID: string;
  OPERATION_ID: string;
  MEASURE: string;
  YYYYMMDD: string;
  QTY: string;
  FIX_REASON: string;
  ORIGIN_DIVISION_ID: string;
  ELECTRODE_TYPE: string;
  BUCKET_TYPE: string;
  FIX_MODE: FixMode; // 확정(F)/해제(U) 마킹 — SP 비소비(ACTIVE_FLAG 가 실제 판별자)
}

const entryOf = (row: Row, dBinding: string, mode: FixMode, reason: string, bucket: string): FixSaveEntry => ({
  ACTIVE_FLAG: mode === 'U' ? 'D' : 'M',
  DIVISION_ID: s(row.DIVISION_ID),
  OPERATION_GROUP: s(row.OPERATION_GROUP),
  SCM_SITE_ID: s(row.SCM_SITE_ID),
  ITEM_ID: s(row.ITEM_ID),
  LINE_ID: s(row.LINE_ID),
  OPERATION_ID: s(row.OPERATION_ID),
  MEASURE: EDITABLE_MEASURE,
  YYYYMMDD: dailyDate(dBinding),
  QTY: s(row[dBinding]) || '0',
  // AS-IS: Fix 는 입력 사유, Unfix 는 빈 사유(cs:1392~1406 / SaveData_FixInfo strReason).
  FIX_REASON: mode === 'F' ? reason : '',
  ORIGIN_DIVISION_ID: s(row.ORIGIN_DIVISION_ID),
  ELECTRODE_TYPE: s(row.ELECTRODE_TYPE),
  // Unfix 는 BUCKET_TYPE 빈값(자매 SCP0024 unfixEntryOf — QTY 덮어쓰기 방지). Fix 는 현재 버킷.
  BUCKET_TYPE: mode === 'U' ? '' : bucket,
  FIX_MODE: mode,
});

const dedupKey = (e: FixSaveEntry): string =>
  [e.DIVISION_ID, e.OPERATION_GROUP, e.SCM_SITE_ID, e.ITEM_ID, e.LINE_ID, e.OPERATION_ID, e.YYYYMMDD, e.ELECTRODE_TYPE].join('|');

// Fix/Unfix payload — 선택 range × PROD_PLAN_AMEND 행에서 (a) D_(일자) 셀은 수량 있을 때만,
//   (b) W_(주 SUM) 셀은 같은 ISO 주의 D_ 셀 전체로 확장해 수량 있는 일자만 수집. M_·타 measure 제외.
//   (업무키+YYYYMMDD)로 중복 제거. AS-IS SaveData_FixInfo 재현.
export const buildFixPayload = (
  grid: FlexGrid | undefined,
  mode: FixMode,
  reason: string,
  bucket: string
): FixSaveEntry[] => {
  if (!grid) return [];
  const ranges = grid.selectedRanges && grid.selectedRanges.length > 0 ? grid.selectedRanges : [grid.selection];
  const out: FixSaveEntry[] = [];
  const seen = new Set<string>();
  const push = (row: Row, dBinding: string) => {
    if (s(row[dBinding]) === '') return; // 수량 없는 셀은 대상 아님(AS-IS 실적 제외)
    const entry = entryOf(row, dBinding, mode, reason, bucket);
    const k = dedupKey(entry);
    if (seen.has(k)) return;
    seen.add(k);
    out.push(entry);
  };
  for (const range of ranges) {
    if (!range || range.row < 0 || range.col < 0) continue;
    for (let r = range.topRow; r <= range.bottomRow; r++) {
      const row = grid.rows[r]?.dataItem as Row | undefined;
      if (!row) continue;
      if (s(row.MEASURE) !== EDITABLE_MEASURE) continue; // PROD_PLAN_AMEND 행만
      const rowKeys = Object.keys(row);
      for (let c = range.leftCol; c <= range.rightCol; c++) {
        const binding = grid.columns[c]?.binding ?? '';
        const kind = pivotKind(binding);
        if (kind === 'D') {
          push(row, binding);
        } else if (kind === 'W') {
          // 주 SUM 선택 → 그 주(YYYYMM+ISO_WEEK)의 일자 셀 전체로 확장(AS-IS cs:3045~3140).
          const yyyymm = binding.slice(2, 8);
          const weekNum = weekNumOfBinding(binding);
          for (const k of rowKeys) {
            if (pivotKind(k) !== 'D') continue;
            const d = k.slice(2);
            if (d.slice(0, 6) === yyyymm && isoWeek(d) === weekNum) push(row, k);
          }
        }
      }
    }
  }
  return out;
};
