import { useCallback } from 'react';

import { MSG, OPERATION_GROUP_ELECTRODE } from '../project-route-electrode.constants';
import type { MainRow } from '../project-route-electrode.types';
import { toYmd8 } from '../utils/projectRouteElectrode.derive';

// SCP0027 저장검증(design/03 §3-4). AS-IS SaveData 순차 검증(실패 시 전체 중단)을 재현한다.
//   순서(설계 확정 cs 라인 순): N0 → N1 → N2 → N3 → N4 → N5 → N6 → N7 → N8 → N9.
//   자매 SCP0048 검증엔진과 골격은 같으나 4가지가 다르다:
//     (1) N0(전극아이템 존재, MSG00257) 추가 — 신규행 ITEM_ID 가 전극아이템 목록에 있어야 함.
//     (2) N6(기간 연속성, MSG00217) 추가 — 최대 종료일 제외, 종료일+1 = 다음 시작일 존재.
//     (3) N10(div=81 sales-site)·N11(Warranty PRIORITY≥11) 없음 — 전극 전용 화면.
//     (4) N9 그룹키: OPERATION_GROUP='E' 면 SCM_SITE/PROJECT/ITEM 만(DIVISION 제외), 아니면 DIVISION 포함.
//   검증 대상: VALID_YN='Y' + ACTION_FLAG_DIV ∈ {I,M,D}(수정행)에 한함(design/03 §3-4 주의).
//
// 그룹 범위 주의(정직): AS-IS checkValidN1~N6 의 SP-side group-by 키는 SP 본문 미확정(ora.py query
//   승인 차단, 04_react-gap GAP 참조). 본 구현은 design/03 §3-4 표의 의미규칙("동일
//   Div/Site/Project/Item")을 재현한다. SP 본문 확인 후 group 키 정합 필요.
//
// N0 주의(정직): AS-IS 는 전극아이템 팝업 데이터셋(tblAll)에 대조한다. FE 저장 시점에 그 전체
//   목록을 신뢰성 있게 보유하지 못하므로(셀 팝업이 열렸던 행만 캐시) electrodeItemIds 를
//   optional 로 받아 있을 때만 대조하고, 없으면 N0 를 건너뛴다(BE SAVE SP 가 최종 방어). 04_react-gap 기록.

export interface ElectrodeValidationResult {
  ok: boolean;
  msgId?: string;
  invalidCells: { row: MainRow; column: string }[];
  // N8-a(FROM/TO 공백) 전용 — AS-IS 가 메시지 없이 조용히 저장을 차단하는 분기(자매 SCP0048 동일).
  silent?: boolean;
}

interface Period {
  row: MainRow;
  from: string; // YYYYMMDD (8)
  to: string; // YYYYMMDD (8)
  priority: number;
  plantSiteId: string;
}

// 그룹키(design/03 §3-4). N1~N6 은 "동일 Div/Site/Project/Item"(cs:1144~ 대상행).
//   N9 만 예외: OPERATION_GROUP='E' 면 DIVISION 제외(SCM_SITE/PROJECT/ITEM 키), 아니면 DIVISION 포함.
const groupKey = (r: MainRow): string =>
  `${String(r.DIVISION_ID ?? '')}^${String(r.ITEM_ID ?? '')}^${String(
    r.SCM_SITE_ID ?? ''
  )}^${String(r.PROJECT_CODE ?? '')}`;

// N9 전용 그룹키 — 전극(E)이면 DIVISION 제외.
const groupKeyForN9 = (r: MainRow): string => {
  const base = `${String(r.ITEM_ID ?? '')}^${String(r.SCM_SITE_ID ?? '')}^${String(
    r.PROJECT_CODE ?? ''
  )}`;
  return String(r.OPERATION_GROUP ?? '') === OPERATION_GROUP_ELECTRODE
    ? base
    : `${String(r.DIVISION_ID ?? '')}^${base}`;
};

// FROM/TO 는 R-ORG 파생(ORG_*) 우선, 없으면 원 셀에서 8자리 정규화.
const fromOf = (r: MainRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_FROM_YYYYMMDD) || toYmd8(r.FROM_YYYYMMDD);
const toOf = (r: MainRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_TO_YYYYMMDD) || toYmd8(r.TO_YYYYMMDD);

// 자리수는 맞지만(toYmd8) 실제 달력에 없는 날짜(예: 20261251) 차단 — Date UTC 라운드트립.
const isValidYmd8 = (ymd8: string): boolean => {
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6));
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
};

// YYYYMMDD +1일 → YYYYMMDD(N6 연속성). UTC 로 계산해 월/연 롤오버 처리.
const nextDay = (ymd8: string): string => {
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6));
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m - 1, d + 1));
  const yy = String(dt.getUTCFullYear()).padStart(4, '0');
  const mm = String(dt.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(dt.getUTCDate()).padStart(2, '0');
  return `${yy}${mm}${dd}`;
};

export const useProjectRouteElectrodeValidation = () => {
  // electrodeItemIds: 셀 팝업 등에서 확보한 전극아이템 ID 집합(대문자). 있으면 N0 대조, 없으면 skip.
  const validateElectrodeSave = useCallback(
    (rows: MainRow[], electrodeItemIds?: Set<string>): ElectrodeValidationResult => {
      const fail = (
        msgId: string,
        cells: { row: MainRow; column: string }[]
      ): ElectrodeValidationResult => ({ ok: false, msgId, invalidCells: cells });
      const failSilent = (
        cells: { row: MainRow; column: string }[]
      ): ElectrodeValidationResult => ({
        ok: false,
        invalidCells: cells,
        silent: true,
      });

      // 검증 대상: VALID_YN='Y' 행.
      const targets = rows.filter(r => String(r.VALID_YN ?? '') === 'Y');

      // N0(MSG00257) — 신규행 ITEM_ID 가 전극아이템 목록에 존재. electrodeItemIds 있을 때만 대조.
      if (electrodeItemIds && electrodeItemIds.size > 0) {
        for (const r of rows) {
          if (r.CRUD_TYPE !== 'I') continue;
          const itemId = String(r.ITEM_ID ?? '')
            .trim()
            .toUpperCase();
          if (itemId && !electrodeItemIds.has(itemId))
            return fail(MSG.N0_ELECTRODE_ITEM, [{ row: r, column: 'ITEM_ID' }]);
        }
      }

      // 그룹별 기간(N1~N6 공용).
      const groups = new Map<string, Period[]>();
      for (const r of targets) {
        const list = groups.get(groupKey(r)) ?? [];
        list.push({
          row: r,
          from: fromOf(r),
          to: toOf(r),
          priority: Number(r.PRIORITY),
          plantSiteId: String(r.PLANT_SITE_ID_B ?? r.PLANT_SITE_ID ?? ''),
        });
        groups.set(groupKey(r), list);
      }

      // N1(MSG00212) — 시작일 동일·종료일 상이(중첩 종료일). mark TO.
      for (const periods of groups.values()) {
        for (let i = 0; i < periods.length; i++) {
          for (let j = i + 1; j < periods.length; j++) {
            if (
              periods[i].from &&
              periods[i].from === periods[j].from &&
              periods[i].to !== periods[j].to
            ) {
              return fail(MSG.N1_END_OVERLAP, [
                { row: periods[i].row, column: 'TO_YYYYMMDD' },
                { row: periods[j].row, column: 'TO_YYYYMMDD' },
              ]);
            }
          }
        }
      }

      // N2(MSG00213) — 종료일 동일·시작일 상이(중첩 시작일). mark FROM.
      for (const periods of groups.values()) {
        for (let i = 0; i < periods.length; i++) {
          for (let j = i + 1; j < periods.length; j++) {
            if (
              periods[i].to &&
              periods[i].to === periods[j].to &&
              periods[i].from !== periods[j].from
            ) {
              return fail(MSG.N2_START_OVERLAP, [
                { row: periods[i].row, column: 'FROM_YYYYMMDD' },
                { row: periods[j].row, column: 'FROM_YYYYMMDD' },
              ]);
            }
          }
        }
      }

      // N3(MSG00214) — FROM·TO 동일 + PLANT_SITE_ID 중복(Plant Site 중복).
      for (const periods of groups.values()) {
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
      }

      // N4(MSG00215) — FROM·TO 동일 + PRIORITY 중복(Priority 중복).
      for (const periods of groups.values()) {
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
      }

      // N5(MSG00216) — 서로 다른 기간의 FROM/TO 가 타 일정 기간 내부에 걸침(중첩기간).
      //   AS-IS cs:1405~1478. 경계 포함(>=/<=). 완전 동일 기간은 N3/N4 소관이라 제외.
      for (const periods of groups.values()) {
        for (let i = 0; i < periods.length; i++) {
          for (let j = 0; j < periods.length; j++) {
            if (i === j || !periods[i].from || !periods[i].to || !periods[j].from || !periods[j].to)
              continue;
            const same = periods[i].from === periods[j].from && periods[i].to === periods[j].to;
            if (same) continue;
            const startInside =
              periods[i].from >= periods[j].from && periods[i].from <= periods[j].to;
            const endInside = periods[i].to >= periods[j].from && periods[i].to <= periods[j].to;
            const contains = periods[i].to >= periods[j].to && periods[i].from <= periods[j].from;
            if (startInside || endInside || contains) {
              return fail(MSG.N5_PERIOD_OVERLAP, [
                { row: periods[i].row, column: 'FROM_YYYYMMDD' },
                { row: periods[i].row, column: 'TO_YYYYMMDD' },
              ]);
            }
          }
        }
      }

      // N6(MSG00217) — 기간 연속성. 각 그룹에서 최대 종료일 행 제외, 나머지 행의 (종료일+1)이
      //   같은 그룹의 어떤 시작일과 일치해야 한다(cs:1482~1558). 불일치 시 실패.
      for (const periods of groups.values()) {
        const valid = periods.filter(p => p.from && p.to);
        if (valid.length < 2) continue;
        const maxTo = valid.reduce((m, p) => (p.to > m ? p.to : m), valid[0].to);
        const starts = new Set(valid.map(p => p.from));
        for (const p of valid) {
          if (p.to === maxTo) continue; // 최대 종료일 행은 후속 기간 없음 — 제외
          if (!starts.has(nextDay(p.to)))
            return fail(MSG.N6_CONTINUITY, [
              { row: p.row, column: 'FROM_YYYYMMDD' },
              { row: p.row, column: 'TO_YYYYMMDD' },
            ]);
        }
      }

      // N7(MSG00107) — PRIORITY 양의 정수(<1 금지).
      for (const r of targets) {
        const p = Number(r.PRIORITY);
        if (Number.isNaN(p) || p < 1)
          return fail(MSG.N7_PRIORITY_POSITIVE, [{ row: r, column: 'PRIORITY' }]);
      }

      // N8 — FROM/TO 공백이면 무언 차단(N8-a), 그 외 자리수·범위·순서(MSG00219/00048).
      for (const r of targets) {
        const f = fromOf(r);
        const tv = toOf(r);
        if (!f || !tv)
          return failSilent([
            { row: r, column: 'FROM_YYYYMMDD' },
            { row: r, column: 'TO_YYYYMMDD' },
          ]);
        if (!isValidYmd8(f)) return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'FROM_YYYYMMDD' }]);
        if (!isValidYmd8(tv)) return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'TO_YYYYMMDD' }]);
        if (f < '17530101') return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'FROM_YYYYMMDD' }]);
        if (tv < '17530101') return fail(MSG.N8_DATE_RANGE, [{ row: r, column: 'TO_YYYYMMDD' }]);
        if (f > tv)
          return fail(MSG.N8_DATE_ORDER, [
            { row: r, column: 'FROM_YYYYMMDD' },
            { row: r, column: 'TO_YYYYMMDD' },
          ]);
      }

      // N9(MSG00220) — 동일기간에 PRIORITY=1 행 존재. 그룹키는 E면 DIVISION 제외(groupKeyForN9).
      const n9groups = new Map<string, Period[]>();
      for (const r of targets) {
        const k = groupKeyForN9(r);
        const list = n9groups.get(k) ?? [];
        list.push({
          row: r,
          from: fromOf(r),
          to: toOf(r),
          priority: Number(r.PRIORITY),
          plantSiteId: String(r.PLANT_SITE_ID_B ?? r.PLANT_SITE_ID ?? ''),
        });
        n9groups.set(k, list);
      }
      for (const periods of n9groups.values()) {
        const byPeriod = new Map<string, Period[]>();
        for (const p of periods) {
          if (!p.from || !p.to) continue;
          const k = `${p.from}^${p.to}`;
          byPeriod.set(k, [...(byPeriod.get(k) ?? []), p]);
        }
        for (const list of byPeriod.values()) {
          if (!list.some(p => p.priority === 1)) {
            return fail(
              MSG.N9_PRIORITY_ONE,
              list.map(p => ({ row: p.row, column: 'PRIORITY' }))
            );
          }
        }
      }

      return { ok: true, invalidCells: [] };
    },
    []
  );

  return { validateElectrodeSave };
};
