// SCP0024 저장 payload 조립 — pivot 그리드(measure-행 × D_/W_/M_ 열)를 SAVE SP 계약(일자별 unpivot)으로 변환.
//   경로 A P_SCP0024_SAVE_PLAN_FIX_DS (JSON CLOB) 각 행 키(design 03 §4.3 SP 주석 실측):
//   ACTIVE_FLAG, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE,
//   YYYYMMDD, QTY, FIX_REASON, ORIGIN_DIVISION_ID, ELECTRODE_TYPE, BUCKET_TYPE.
//   편집 대상 = D_(일자) × Prod Plan measure 행 QTY 셀만(design 03 §3-보강) → 변경 셀만 일자 entry 로 unpivot.
//   주의: 버튼-API 배선(어느 액션이 _DS vs _PROD_PLAN_FIX 호출인지)·PROC_M 파라미터 메타는 convert-sp 소관
//   (skill 2.9, design 03 §6 #7) — 이 payload 는 _DS JSON 계약을 따른다.

import type { FlexGrid } from '@mescius/wijmo.grid';

import type { FixMode } from '../production-plan-fix.constants';
import { MEASURE_PROD_PLAN } from '../production-plan-fix.constants';

import { isoWeek } from './productionPlanFixDerive';
import { pivotKind } from './productionPlanFixEditLock';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// D_ 바인딩 → YYYYMMDD(8자리).
const dailyDate = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '').slice(0, 8);

export interface FixSaveEntry {
  // ACTIVE_FLAG 이 SAVE SP 의 fix/unfix 판별자다(DB 실측 정본 — PKG_SCP0024 body ALL_SOURCE):
  //   != 'D' → 'X' → 기존 fix 행 있으면 'M'(UPDATE) / 없으면 'I'(INSERT) = Fix(확정)
  //   =  'D' → 업무키+YYYYMMDD+ELECTRODE 매칭 DELETE(body:1088-1099, QTY·MEASURE 무관) = Unfix(해제)
  //   FIX_MODE 는 이 SP 가 소비하지 않는다(무시) → 아래 mode 를 ACTIVE_FLAG 로 반영해야 실제 fix/unfix 가 갈린다.
  ACTIVE_FLAG: string; // Fix='M'(비-D, 서버가 존재여부로 I/M 재판정) / Unfix='D'(DELETE)
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
  FIX_MODE: FixMode; // 확정(F)/해제(U) 구분 — 버튼-API 배선 확정 전 payload 마킹(design 03 §6 #7)
}

// dirty(편집) Prod Plan 행 + 변경 셀 기록(EditTracker.getOriginalValues)으로 일자별 저장 entry 를 만든다.
//   changedBindings: 행별로 변경된 컬럼 바인딩 집합(D_ 만 QTY 편집 대상 — W_/M_ 롤업은 파생이라 저장 제외).
export const buildFixSavePayload = (
  dirtyRows: Row[],
  changedByRow: Map<Row, Set<string>>,
  mode: FixMode,
  bucket: string
): FixSaveEntry[] => {
  const out: FixSaveEntry[] = [];
  for (const row of dirtyRows) {
    if (s(row.MEASURE) !== MEASURE_PROD_PLAN) continue; // Prod Plan 행만 저장(Fix Reason 행 제외)
    const changed = changedByRow.get(row);
    // 변경 셀 기록이 있으면 그 D_ 만, 없으면(신규 등) 안전하게 스킵(과다 전송 방지).
    const dBindings = [...(changed ?? new Set<string>())].filter(b => pivotKind(b) === 'D');
    for (const binding of dBindings) {
      out.push({
        // Unfix(mode 'U') = SAVE SP 의 DELETE 분기(ACTIVE_FLAG='D') / Fix(mode 'F') = upsert(비-D 'M').
        //   DB 실측: PKG_SCP0024.P_SCP0024_SAVE_PLAN_FIX_DS body 는 FIX_MODE 를 읽지 않고 ACTIVE_FLAG 로만 분기.
        //   (react-gap-audit L1 — iter-4 까지 mode 무관 'M' 하드코딩이라 Unfix 가 DELETE 대신 UPDATE 를 유발했다.)
        ACTIVE_FLAG: mode === 'U' ? 'D' : 'M',
        DIVISION_ID: s(row.DIVISION_ID),
        OPERATION_GROUP: s(row.OPERATION_GROUP),
        SCM_SITE_ID: s(row.SCM_SITE_ID),
        ITEM_ID: s(row.ITEM_ID),
        LINE_ID: s(row.LINE_ID),
        OPERATION_ID: s(row.OPERATION_ID),
        MEASURE: MEASURE_PROD_PLAN,
        YYYYMMDD: dailyDate(binding),
        QTY: s(row[binding]) || '0',
        FIX_REASON: s(row.FIX_REASON),
        ORIGIN_DIVISION_ID: s(row.ORIGIN_DIVISION_ID),
        ELECTRODE_TYPE: s(row.ELECTRODE_TYPE),
        BUCKET_TYPE: bucket,
        FIX_MODE: mode,
      });
    }
  }
  return out;
};

// W_ 바인딩 주차(2자리 ISO 주) — colId 'W_'+BASIS_YYYYMM+ISO_WEEK(뒤 2자리). 6자리 태그(구형)면 뒤 2자리 fallback.
const weekNumOfBinding = (binding: string): number => {
  const tag = binding.slice(2).replace(/[^0-9]/g, '');
  return Number(tag.slice(6)) || Number(tag.slice(4, 6));
};

// Unfix entry — AS-IS SaveData_FixInfo_U(cs:1392-1406) 재현: FIX_REASON 은 빈값(strReason=""), QTY 는 셀 값.
//   BUCKET_TYPE 은 빈값 — AS-IS 는 p_bucket_type 을 채우지 않는다. 'WEEKLY' 를 보내면 SAVE SP 가 QTY 를
//   PROD_PLAN_AMEND 값으로 덮어써(PKG_SCP0024 body 923-954) Fix 이력(_FIX_H) 수량이 AS-IS 와 달라진다.
const unfixEntryOf = (row: Row, dBinding: string): FixSaveEntry => ({
  ACTIVE_FLAG: 'D',
  DIVISION_ID: s(row.DIVISION_ID),
  OPERATION_GROUP: s(row.OPERATION_GROUP),
  SCM_SITE_ID: s(row.SCM_SITE_ID),
  ITEM_ID: s(row.ITEM_ID),
  LINE_ID: s(row.LINE_ID),
  OPERATION_ID: s(row.OPERATION_ID),
  MEASURE: MEASURE_PROD_PLAN,
  YYYYMMDD: dailyDate(dBinding),
  QTY: s(row[dBinding]) || '0',
  FIX_REASON: '',
  ORIGIN_DIVISION_ID: s(row.ORIGIN_DIVISION_ID),
  ELECTRODE_TYPE: s(row.ELECTRODE_TYPE),
  BUCKET_TYPE: '',
  FIX_MODE: 'U',
});

const unfixKey = (e: FixSaveEntry): string =>
  [e.DIVISION_ID, e.OPERATION_GROUP, e.SCM_SITE_ID, e.ITEM_ID, e.LINE_ID, e.OPERATION_ID, e.YYYYMMDD, e.ELECTRODE_TYPE].join('|');

// Unfix payload — 그리드 선택 셀 기반(dirty 불요). AS-IS SaveData_FixInfo_U(cs:1249-1544) 재현:
//   선택 range × Prod Plan measure 행에서 (a) D_(일자) 셀은 수량이 있을 때만(빈값 Pass, cs:1366-1369)
//   ACTIVE_FLAG='D' entry, (b) W_(주 SUM) 셀은 같은 ISO 주의 D_ 셀 전체로 확장해 수량 있는 일자만
//   수집(cs:1409-1464). M_·Fix Reason 행은 대상 아님. (업무키+YYYYMMDD)로 중복 제거.
//   자매 정본: SCP0025 shipment-plan-fix buildUnfixPayload(selectedRanges 순회) — W_ 확장·빈값 skip 은
//   SCP0024 AS-IS 고유 사양이라 추가.
export const buildUnfixPayload = (grid: FlexGrid | undefined): FixSaveEntry[] => {
  if (!grid) return [];
  const ranges = grid.selectedRanges && grid.selectedRanges.length > 0 ? grid.selectedRanges : [grid.selection];
  const out: FixSaveEntry[] = [];
  const seen = new Set<string>();
  const push = (row: Row, dBinding: string) => {
    if (s(row[dBinding]) === '') return; // 수량 없는 셀은 해제 대상 아님(AS-IS cs:1366-1369)
    const entry = unfixEntryOf(row, dBinding);
    const k = unfixKey(entry);
    if (seen.has(k)) return;
    seen.add(k);
    out.push(entry);
  };
  for (const range of ranges) {
    if (!range || range.row < 0 || range.col < 0) continue;
    for (let r = range.topRow; r <= range.bottomRow; r++) {
      const row = grid.rows[r]?.dataItem as Row | undefined;
      if (!row) continue;
      if (s(row.MEASURE) !== MEASURE_PROD_PLAN) continue; // Prod Plan 행만(cs:1337)
      const rowKeys = Object.keys(row);
      for (let c = range.leftCol; c <= range.rightCol; c++) {
        const binding = grid.columns[c]?.binding ?? '';
        const kind = pivotKind(binding);
        if (kind === 'D') {
          push(row, binding);
        } else if (kind === 'W') {
          // 주 SUM 선택 → 그 주의 일자 셀 전체로 확장(AS-IS cs:1409-1464)
          // W_ 는 (BASIS_YYYYMM, ISO_WEEK) 단위라 월에 걸친 주는 월별로 컬럼이 갈린다(PKG_SCP0024 GET SP) —
          //   연도가 아닌 월(YYYYMM)까지 비교해 선택한 W_ 아래 일자만 수집한다(AS-IS 컬럼 인접성과 동일).
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
