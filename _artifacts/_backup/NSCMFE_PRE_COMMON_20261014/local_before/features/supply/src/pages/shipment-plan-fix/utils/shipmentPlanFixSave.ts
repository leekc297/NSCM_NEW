// SCP0025 Unfix payload 조립 — read-only pivot 그리드의 선택 셀을 SAVE SP(P_SCP0025_SAVE_FIX_DATASET) 계약으로 변환.
//   design 03 §4.3(SP JSON_TABLE 실측 14컬럼): ACTIVE_FLAG, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE,
//   BOD_ID, YYYYMMDD, PROJECT_CODE, INCOTERMS, QTY, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE.
//   Unfix = 선택 셀(Ship Plan 행 × D_ 일자 컬럼)에서 행 키를 역산해 ACTIVE_FLAG='D' 로 전송 → SP 가 확정 테이블에서 DELETE.
//   주의: SAVE SP 는 실측상 Unfix 전용(확정 테이블 write = ACTIVE_FLAG='D' DELETE 뿐, Fix-insert 없음, PKG_SCP0025 L749).

import type { FlexGrid } from '@mescius/wijmo.grid';

import { MEASURE_SHIP_PLAN } from '../shipment-plan-fix.constants';

import { getCI, isoWeek } from './shipmentPlanFixDerive';
import { pivotKind } from './shipmentPlanFixVisibility';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// D_ 바인딩 → YYYYMMDD(8자리).
const dailyDate = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '').slice(0, 8);

export interface UnfixEntry {
  ACTIVE_FLAG: string; // 'D' — 확정 해제(SP DELETE 조건)
  DIVISION_ID: string;
  BIZ_TYPE: string;
  ITEM_ID: string;
  TO_SITE: string;
  FROM_SITE: string;
  BOD_ID: string;
  YYYYMMDD: string;
  PROJECT_CODE: string;
  INCOTERMS: string;
  QTY: string;
  ORIGIN_FROM_DIVISION_ID: string;
  ORIGIN_TO_DIVISION_ID: string;
  ELECTRODE_TYPE: string;
}

const entryOf = (row: Row, binding: string): UnfixEntry => ({
  ACTIVE_FLAG: 'D',
  DIVISION_ID: s(getCI(row, 'DIVISION_ID')),
  BIZ_TYPE: s(getCI(row, 'BIZ_TYPE')),
  ITEM_ID: s(getCI(row, 'ITEM_ID')),
  TO_SITE: s(getCI(row, 'TO_SITE')),
  FROM_SITE: s(getCI(row, 'FROM_SITE')),
  BOD_ID: s(getCI(row, 'BOD_ID')),
  YYYYMMDD: dailyDate(binding),
  PROJECT_CODE: s(getCI(row, 'PROJECT_CODE')),
  INCOTERMS: s(getCI(row, 'INCOTERMS')),
  QTY: s(getCI(row, binding)) || '0',
  ORIGIN_FROM_DIVISION_ID: s(getCI(row, 'ORIGIN_FROM_DIVISION_ID')),
  ORIGIN_TO_DIVISION_ID: s(getCI(row, 'ORIGIN_TO_DIVISION_ID')),
  ELECTRODE_TYPE: s(getCI(row, 'ELECTRODE_TYPE')),
});

// 중복 제거 키 = SAVE SP DELETE 고유키(PKG_SCP0025 GET body L752-765)와 동일 grain.
//   6키(div/biz/item/to_site/from_site/bod_id)만 쓰면 incoterms/project_code/origin/electrode 가 다른 별개 lane 이
//   같은 키로 겹쳐 정당한 셀이 누락된다 — SP 가 실제로 삭제 대상을 구분하는 전체 lane 키 + YYYYMMDD 로 판별한다.
const entryKey = (e: UnfixEntry): string =>
  [
    e.DIVISION_ID,
    e.BIZ_TYPE,
    e.ITEM_ID,
    e.TO_SITE,
    e.FROM_SITE,
    e.BOD_ID,
    e.PROJECT_CODE,
    e.INCOTERMS,
    e.ORIGIN_FROM_DIVISION_ID,
    e.ORIGIN_TO_DIVISION_ID,
    e.ELECTRODE_TYPE,
    e.YYYYMMDD,
  ].join('|');

// D_(일자) 셀 1건을 payload 에 추가한다. 수량이 빈 셀은 건너뛴다 —
//   AS-IS SaveData_FixInfo_U(cs L998 "수량이 없을 경우 Pass")와 동일. 빈 셀은 확정행이 없어 SP DELETE 가 no-op 이므로
//   보내지 않는 것이 선택셀 전부가 빈 경우의 "대상 없음" 판정(Page handleUnfix payload.length===0)과도 정합한다.
const pushDaily = (row: Row, binding: string, out: UnfixEntry[], seen: Set<string>): void => {
  if (s(getCI(row, binding)) === '') return;
  const entry = entryOf(row, binding);
  const k = entryKey(entry);
  if (seen.has(k)) return;
  seen.add(k);
  out.push(entry);
};

// pivot 바인딩의 소속 (월 ym, ISO 주) — buildPivotColumns 의 월>주 그룹핑과 동일 규칙으로 W_/D_ 를 같은 주로 묶는다.
//   W_ colId = 'W_' || BASIS_YYYYMM(6) || ISO_WEEK(2) → ym=tag.slice(0,6), week=tag.slice(6,8)(인코딩된 ISO_WEEK).
//   D_ colId = 'D_' || YYYYMMDD(8) → ym=날짜 월, week=isoWeek(날짜). (동일 주에서 두 ISO 주번호 일치 — derive 주석 참조.)
const weekOf = (binding: string): { ym: string; week: number } | null => {
  const kind = pivotKind(binding);
  const tag = binding.slice(2);
  if (kind === 'W') return { ym: tag.slice(0, 6), week: Number(tag.slice(6, 8)) };
  if (kind === 'D') return { ym: tag.slice(0, 6), week: isoWeek(tag) };
  return null;
};

// 그리드 선택 셀 → Unfix entry 배열. Ship Plan 행만 대상(Fix Reason 행 제외).
//   D_(일자) 셀은 그대로, W_(주 SUM) 셀은 그 주에 속한 D_ 일자 셀로 전개한다 —
//   AS-IS SaveData_FixInfo_U(cs L1027-1067): W_ 선택 시 다음 D_ 들을 다음 W_/M_ 전까지 순회하며 비어있지 않은 일자를 추가.
//   WEEKLY 버킷은 D_ 컬럼이 렌더되지 않아(visibility) W_ 만 선택 가능하므로 이 전개가 없으면 주간 Unfix 가 무동작이 된다.
//   TO-BE 는 컬럼 인접이 아니라 행 dataItem 의 D_ 키에서 (월 ym + ISO 주) 일치로 주 구성원을 찾는다(전 버킷 데이터 상주).
//   M_(월 SUM) 셀은 대상 아님(AS-IS 도 D_/W_ 만 처리). selectedRanges 전체를 순회하되 lane 고유키+YYYYMMDD 로 중복 제거.
export const buildUnfixPayload = (grid: FlexGrid | undefined): UnfixEntry[] => {
  if (!grid) return [];
  const ranges = grid.selectedRanges && grid.selectedRanges.length > 0 ? grid.selectedRanges : [grid.selection];
  const out: UnfixEntry[] = [];
  const seen = new Set<string>();
  for (const range of ranges) {
    if (!range || range.row < 0 || range.col < 0) continue;
    for (let r = range.topRow; r <= range.bottomRow; r++) {
      const row = grid.rows[r]?.dataItem as Row | undefined;
      if (!row) continue;
      if (s(getCI(row, 'MEASURE')) !== MEASURE_SHIP_PLAN) continue; // Ship Plan 행만(Fix Reason 행 제외)
      for (let c = range.leftCol; c <= range.rightCol; c++) {
        const binding = grid.columns[c]?.binding ?? '';
        const kind = pivotKind(binding);
        if (kind === 'D') {
          pushDaily(row, binding, out, seen);
        } else if (kind === 'W') {
          // W_(주 SUM) 선택 → 그 주에 속한 D_ 일자 셀 전개(AS-IS cs L1027-1067).
          const wk = weekOf(binding);
          if (!wk) continue;
          for (const key of Object.keys(row)) {
            if (pivotKind(key) !== 'D') continue;
            const dwk = weekOf(key);
            if (!dwk || dwk.ym !== wk.ym || dwk.week !== wk.week) continue;
            pushDaily(row, key, out, seen);
          }
        }
        // M_(월 SUM) 등 그 외는 대상 아님.
      }
    }
  }
  return out;
};
