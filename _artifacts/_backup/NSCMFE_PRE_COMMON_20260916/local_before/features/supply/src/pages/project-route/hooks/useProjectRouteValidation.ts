import { useCallback } from 'react';

import { MSG } from '../project-route.constants';
import type { PlantRow } from '../project-route.types';
import { toYmd8 } from '../utils/projectRoute.plantDerive';

// SCP0006 Plant 저장검증 N1~N9(design/03 §3.4). 전 검증은 VALID_YN='Y' 행만 대상.
//   실패 시 msgId + 하이라이트 대상 셀(row, column) 반환 → 호출부가 alert + 셀 마킹 후 저장 중단.
//   N0(외주 PACKER, MSG00226)은 AS-IS CheckChangedValues 에서 주석-out(ChkPlantOs 셀이벤트로만) →
//   저장검증에는 미포함(design/03 §3.4 N0 비활성).
//
// 그룹 범위 주의(정직): AS-IS checkValidN1~N9 의 정확한 group-by 키는 SP/소스 미확정(라이브 차단,
//   design/03 §6). 본 구현은 "동일 ITEM_ID+SCM_SITE_ID+PROJECT_CODE" 를 한 일정군으로 보고
//   설계 문서의 의미규칙을 재현한다. SP 본문 확인 후 group 키 정합 필요(04_react-gap §gap).

export interface PlantValidationResult {
  ok: boolean;
  msgId?: string;
  invalidCells: { row: PlantRow; column: string }[];
}

interface Period {
  row: PlantRow;
  from: string; // YYYYMMDD (8)
  to: string; // YYYYMMDD (8)
  priority: number;
  plantSiteId: string;
}

const groupKey = (r: PlantRow): string =>
  `${r.ITEM_ID ?? ''}^${r.SCM_SITE_ID ?? ''}^${r.PROJECT_CODE ?? ''}`;

// FROM/TO 는 R-ORG 파생(ORG_*) 우선, 없으면 원 셀에서 8자리 정규화.
const fromOf = (r: PlantRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_FROM_YYYYMMDD) || toYmd8(r.FROM_YYYYMMDD);
const toOf = (r: PlantRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_TO_YYYYMMDD) || toYmd8(r.TO_YYYYMMDD);

// YYYYMMDD +1일. 월/연 경계는 Date 산술로만(컴포넌트만 읽어 tz 무영향, toISOString 금지).
const nextDay = (ymd8: string): string => {
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6)) - 1;
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m, d));
  dt.setUTCDate(dt.getUTCDate() + 1);
  return `${dt.getUTCFullYear()}${String(dt.getUTCMonth() + 1).padStart(2, '0')}${String(
    dt.getUTCDate()
  ).padStart(2, '0')}`;
};

export const useProjectRouteValidation = () => {
  const validatePlantSave = useCallback((rows: PlantRow[]): PlantValidationResult => {
    const targets = rows.filter(r => String(r.VALID_YN ?? '') === 'Y');
    const fail = (msgId: string, cells: { row: PlantRow; column: string }[]): PlantValidationResult => ({
      ok: false,
      msgId,
      invalidCells: cells,
    });

    // N7 — PRIORITY 양수(< 1 금지). (MSG00107)
    for (const r of targets) {
      const p = Number(r.PRIORITY);
      if (Number.isNaN(p) || p < 1) return fail(MSG.N7_PRIORITY_POSITIVE, [{ row: r, column: 'PRIORITY' }]);
    }

    // N8 — FROM <= TO 순서 + 처리가능 날짜범위(>= 17530101). (MSG00108 / MSG00048)
    for (const r of targets) {
      const f = fromOf(r);
      const t = toOf(r);
      if (f && f < '17530101') return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'FROM_YYYYMMDD' }]);
      if (t && t < '17530101') return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'TO_YYYYMMDD' }]);
      if (f && t && f > t)
        return fail(MSG.N8_DATE_ORDER, [
          { row: r, column: 'FROM_YYYYMMDD' },
          { row: r, column: 'TO_YYYYMMDD' },
        ]);
    }

    // 그룹별 기간 검증(N1~N6, N9).
    const groups = new Map<string, Period[]>();
    for (const r of targets) {
      const list = groups.get(groupKey(r)) ?? [];
      list.push({
        row: r,
        from: fromOf(r),
        to: toOf(r),
        priority: Number(r.PRIORITY),
        plantSiteId: String(r.PLANT_SITE_ID ?? ''),
      });
      groups.set(groupKey(r), list);
    }

    for (const periods of groups.values()) {
      // N1 — 시작일자 동일한데 종료일자 다른 행. (MSG00101, mark TO)
      for (let i = 0; i < periods.length; i++) {
        for (let j = i + 1; j < periods.length; j++) {
          if (periods[i].from && periods[i].from === periods[j].from && periods[i].to !== periods[j].to) {
            return fail(MSG.N1_END_OVERLAP, [
              { row: periods[i].row, column: 'TO_YYYYMMDD' },
              { row: periods[j].row, column: 'TO_YYYYMMDD' },
            ]);
          }
        }
      }
      // N2 — 종료일자 동일한데 시작일자 다른 행. (MSG00102, mark FROM)
      for (let i = 0; i < periods.length; i++) {
        for (let j = i + 1; j < periods.length; j++) {
          if (periods[i].to && periods[i].to === periods[j].to && periods[i].from !== periods[j].from) {
            return fail(MSG.N2_START_OVERLAP, [
              { row: periods[i].row, column: 'FROM_YYYYMMDD' },
              { row: periods[j].row, column: 'FROM_YYYYMMDD' },
            ]);
          }
        }
      }
      // N3 — FROM·TO 동일 + PLANT_SITE_ID 중복. (MSG00103)
      for (let i = 0; i < periods.length; i++) {
        for (let j = i + 1; j < periods.length; j++) {
          if (
            periods[i].from === periods[j].from &&
            periods[i].to === periods[j].to &&
            periods[i].plantSiteId === periods[j].plantSiteId
          ) {
            return fail(MSG.N3_PLANT_DUP, [
              { row: periods[i].row, column: 'PLANT_SITE_ID' },
              { row: periods[j].row, column: 'PLANT_SITE_ID' },
            ]);
          }
        }
      }
      // N4 — FROM·TO 동일 + PRIORITY 중복. (MSG00104)
      for (let i = 0; i < periods.length; i++) {
        for (let j = i + 1; j < periods.length; j++) {
          if (
            periods[i].from === periods[j].from &&
            periods[i].to === periods[j].to &&
            periods[i].priority === periods[j].priority
          ) {
            return fail(MSG.N4_PRIORITY_DUP, [
              { row: periods[i].row, column: 'PRIORITY' },
              { row: periods[j].row, column: 'PRIORITY' },
            ]);
          }
        }
      }
      // N5 — 서로 다른 기간의 FROM/TO 가 타 일정 기간 사이에 겹침(중첩). (MSG00105)
      for (let i = 0; i < periods.length; i++) {
        for (let j = 0; j < periods.length; j++) {
          if (i === j || !periods[i].from || !periods[i].to || !periods[j].from || !periods[j].to) continue;
          const iSame = periods[i].from === periods[j].from && periods[i].to === periods[j].to;
          if (iSame) continue; // 완전 동일 기간은 N3/N4 소관
          const startInside = periods[i].from > periods[j].from && periods[i].from < periods[j].to;
          const endInside = periods[i].to > periods[j].from && periods[i].to < periods[j].to;
          if (startInside || endInside) {
            return fail(MSG.N5_PERIOD_OVERLAP, [
              { row: periods[i].row, column: 'FROM_YYYYMMDD' },
              { row: periods[i].row, column: 'TO_YYYYMMDD' },
            ]);
          }
        }
      }
      // N6 — 기간 연속성: 최대 종료일을 제외한 각 기간은 (종료일+1 = 다른 행 시작일) 이어야 함. (MSG00106)
      const withDates = periods.filter(p => p.from && p.to);
      if (withDates.length > 1) {
        const maxTo = withDates.reduce((m, p) => (p.to > m ? p.to : m), withDates[0].to);
        for (const p of withDates) {
          if (p.to === maxTo) continue;
          const need = nextDay(p.to);
          const hasNext = withDates.some(q => q !== p && q.from === need);
          if (!hasNext) {
            return fail(MSG.N6_PERIOD_CONTINUITY, [{ row: p.row, column: 'TO_YYYYMMDD' }]);
          }
        }
      }
      // N9 — 각 (FROM,TO) 기간에 PRIORITY=1 행 존재. (MSG00110)
      const byPeriod = new Map<string, Period[]>();
      for (const p of withDates) {
        const k = `${p.from}^${p.to}`;
        byPeriod.set(k, [...(byPeriod.get(k) ?? []), p]);
      }
      for (const list of byPeriod.values()) {
        if (!list.some(p => p.priority === 1)) {
          return fail(MSG.N9_PRIORITY_ONE, list.map(p => ({ row: p.row, column: 'PRIORITY' })));
        }
      }
    }

    return { ok: true, invalidCells: [] };
  }, []);

  return { validatePlantSave };
};
