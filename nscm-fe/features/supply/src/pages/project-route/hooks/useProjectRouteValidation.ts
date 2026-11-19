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
  // N8-a(design/03 §3 N8-a, L2031-2034) 전용 — AS-IS 가 메시지 없이 조용히 저장을 차단하는 유일한 분기.
  silent?: boolean;
}

// N1~N9 규칙 자체는 SCP0006 본 그리드와 Input All 팝업(SCM0002_ProjectRouteListSavePopup)이
//   완전히 동일(AS-IS 소스 실측)하지만, 두 화면의 문구(=MSG 코드)는 다르다 — 팝업은 "리스트 확인 후
//   입력하십시오" 접미가 붙는 별도 문구다(TO-BE MSG01223~01228/01231, N7/N8순서/날짜범위만 본화면과
//   공유). 규칙 엔진은 공유하고 메시지ID만 주입받는다 — 기본값은 SCP0006 자신의 맵이라 기존 호출부는
//   인자 생략 시 동작 100% 동일.
export interface PlantValidationMsgIds {
  n1EndOverlap: string;
  n2StartOverlap: string;
  n3PlantDup: string;
  n4PriorityDup: string;
  n5PeriodOverlap: string;
  n6PeriodContinuity: string;
  n7PriorityPositive: string;
  n8DateOrder: string;
  n8DateRange: string;
  n8DateFormat: string;
  n9PriorityOne: string;
}

const DEFAULT_MSG_IDS: PlantValidationMsgIds = {
  n1EndOverlap: MSG.N1_END_OVERLAP,
  n2StartOverlap: MSG.N2_START_OVERLAP,
  n3PlantDup: MSG.N3_PLANT_DUP,
  n4PriorityDup: MSG.N4_PRIORITY_DUP,
  n5PeriodOverlap: MSG.N5_PERIOD_OVERLAP,
  n6PeriodContinuity: MSG.N6_PERIOD_CONTINUITY,
  n7PriorityPositive: MSG.N7_PRIORITY_POSITIVE,
  n8DateOrder: MSG.N8_DATE_ORDER,
  n8DateRange: MSG.N8_DATE_RANGE,
  n8DateFormat: MSG.N8_DATE_FORMAT,
  n9PriorityOne: MSG.N9_PRIORITY_ONE,
};

interface Period {
  row: PlantRow;
  from: string; // YYYYMMDD (8)
  to: string; // YYYYMMDD (8)
  priority: number;
  plantSiteId: string;
  // 위반 '주체' 여부(AS-IS N1~N9 바깥 루프 action=I/M/D 필터 등가). true 인 행만 위반 주체가 되고,
  //   비교 상대(안쪽 j)는 주체 여부와 무관하게 전체를 본다. baseRows(기존 일정)는 isSubject=false 로
  //   들어와, "신규 행이 기존/다른 신규와 충돌하는가"만 검사하고 기존끼리는 트집잡지 않는다.
  //   baseRows 미지정(메인 화면)이면 모든 행 isSubject=true → 기존 all-pairs 동작 그대로.
  isSubject: boolean;
}

const groupKey = (r: PlantRow): string =>
  `${String(r.ITEM_ID ?? '')}^${String(r.SCM_SITE_ID ?? '')}^${String(r.PROJECT_CODE ?? '')}`;

// FROM/TO 는 R-ORG 파생(ORG_*) 우선, 없으면 원 셀에서 8자리 정규화.
const fromOf = (r: PlantRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_FROM_YYYYMMDD) || toYmd8(r.FROM_YYYYMMDD);
const toOf = (r: PlantRow): string =>
  toYmd8((r as Record<string, unknown>).ORG_TO_YYYYMMDD) || toYmd8(r.TO_YYYYMMDD);

// N8-format(사용자 지시 2026-09-23) — toYmd8 는 "8자리 숫자인지"만 보고 "20261251"(12월 51일)
//   처럼 자리수는 맞지만 실제 달력에 없는 날짜도 통과시킨다. 그 값이 저장까지 통과했다가 조회 시
//   SP 의 TO_DATE 변환 에러로만 드러나는 문제라, Date 라운드트립으로 실존 여부를 확인한다(overflow
//   되면 getUTC* 가 입력과 달라짐 — 예: 12월 51일 → 다음해 1/2월로 넘어감).
const isValidYmd8 = (ymd8: string): boolean => {
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6));
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
};

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
  const validatePlantSave = useCallback(
    (
      rows: PlantRow[],
      msgIds: PlantValidationMsgIds = DEFAULT_MSG_IDS,
      // AS-IS Input All 팝업(SCM0002)의 dsValiChkBinding = dsFullBinding(기존 전체 일정, O_RC2) +
      //   신규 체크 행. N1~N9 는 바깥 루프를 신규/수정행(action=I/M/D)만 돌고 안쪽 비교는 전체를 본다.
      //   baseRows 에 기존 전체 일정을 넘기면 "신규 × 기존" 충돌까지 AS-IS 등가로 검사한다. 메인
      //   SCP0006 화면은 baseRows 를 안 넘겨(기본 []) 기존 all-pairs 동작 그대로 — 영향 없음.
      baseRows: PlantRow[] = []
    ): PlantValidationResult => {
    // rows = 위반 주체(신규/수정 — 메인 화면은 변경행, 팝업은 체크행). baseRows = 비교 전용 기존 일정.
    const subjects = rows.filter(r => String(r.VALID_YN ?? '') === 'Y');
    // N7/N8(자기 자신만 보는 검사)·그룹 빌드의 '전체' = 주체 + 기존. Valid='Y' 만.
    const targets = [...rows, ...baseRows].filter(r => String(r.VALID_YN ?? '') === 'Y');
    const subjectSet = new Set<PlantRow>(subjects);
    const fail = (msgId: string, cells: { row: PlantRow; column: string }[]): PlantValidationResult => ({
      ok: false,
      msgId,
      invalidCells: cells,
    });
    // N8-a 전용 — MessageHelper 호출 없는 AS-IS 무언 차단(design/03 §3 N8-a) 재현.
    const failSilent = (cells: { row: PlantRow; column: string }[]): PlantValidationResult => ({
      ok: false,
      invalidCells: cells,
      silent: true,
    });

    // 그룹별 기간 준비(N1~N6, N9 공용 — 실제 판정은 순서대로 아래에서 진행). targets = 주체+기존 전체.
    const groups = new Map<string, Period[]>();
    for (const r of targets) {
      const list = groups.get(groupKey(r)) ?? [];
      list.push({
        row: r,
        from: fromOf(r),
        to: toOf(r),
        priority: Number(r.PRIORITY),
        plantSiteId: String(r.PLANT_SITE_ID ?? ''),
        isSubject: subjectSet.has(r), // 신규/변경행만 위반 주체(AS-IS 바깥 루프 action 필터 등가)
      });
      groups.set(groupKey(r), list);
    }

    // G4 교정(04_impl-gap-audit): AS-IS CheckChangedValues()(L930-938)는 N1→N2→...→N9 순서로
    //   전건을 순차 AND 단락평가한다 — TO-BE 는 N7/N8 을 먼저 돌던 기존 순서를 N1~N9 그대로 맞춘다
    //   (조건식·msgId 자체는 기존과 동일, 실행 순서만 재배열).

    // N1~N6·N9 는 AS-IS 처럼 바깥 루프(위반 주체 i)를 isSubject(신규/변경행)로 제한하고, 안쪽 비교(j)는
    //   전체(기존+신규)를 i≠j 전순회한다. baseRows 미지정(메인 화면)은 모든 행 isSubject=true 라
    //   전순회가 종전 i<j 대칭쌍과 같은 위반을 검출 — 동작 불변. (팝업만 기존 일정이 비교 상대로 합류.)

    // N1 — 시작일자 동일한데 종료일자 다른 행. (본화면 MSG01129, mark TO)
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].isSubject) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
          if (periods[i].from && periods[i].from === periods[j].from && periods[i].to !== periods[j].to) {
            return fail(msgIds.n1EndOverlap, [
              { row: periods[i].row, column: 'TO_YYYYMMDD' },
              { row: periods[j].row, column: 'TO_YYYYMMDD' },
            ]);
          }
        }
      }
    }

    // N2 — 종료일자 동일한데 시작일자 다른 행. (본화면 MSG01130, mark FROM)
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].isSubject) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
          if (periods[i].to && periods[i].to === periods[j].to && periods[i].from !== periods[j].from) {
            return fail(msgIds.n2StartOverlap, [
              { row: periods[i].row, column: 'FROM_YYYYMMDD' },
              { row: periods[j].row, column: 'FROM_YYYYMMDD' },
            ]);
          }
        }
      }
    }

    // N3 — FROM·TO 동일 + PLANT_SITE_ID 중복. (본화면 MSG01131)
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].isSubject) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
          if (
            periods[i].from === periods[j].from &&
            periods[i].to === periods[j].to &&
            periods[i].plantSiteId === periods[j].plantSiteId
          ) {
            return fail(msgIds.n3PlantDup, [
              { row: periods[i].row, column: 'PLANT_SITE_ID' },
              { row: periods[j].row, column: 'PLANT_SITE_ID' },
            ]);
          }
        }
      }
    }

    // N4 — FROM·TO 동일 + PRIORITY 중복. (본화면 MSG01132)
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].isSubject) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
          if (
            periods[i].from === periods[j].from &&
            periods[i].to === periods[j].to &&
            periods[i].priority === periods[j].priority
          ) {
            return fail(msgIds.n4PriorityDup, [
              { row: periods[i].row, column: 'PRIORITY' },
              { row: periods[j].row, column: 'PRIORITY' },
            ]);
          }
        }
      }
    }

    // N5 — 서로 다른 기간의 FROM/TO 가 타 일정 기간 사이에 겹침(중첩). (본화면 MSG00700)
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].isSubject) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j || !periods[i].from || !periods[i].to || !periods[j].from || !periods[j].to) continue;
          const iSame = periods[i].from === periods[j].from && periods[i].to === periods[j].to;
          if (iSame) continue; // 완전 동일 기간은 N3/N4 소관
          const startInside = periods[i].from > periods[j].from && periods[i].from < periods[j].to;
          const endInside = periods[i].to > periods[j].from && periods[i].to < periods[j].to;
          if (startInside || endInside) {
            return fail(msgIds.n5PeriodOverlap, [
              { row: periods[i].row, column: 'FROM_YYYYMMDD' },
              { row: periods[i].row, column: 'TO_YYYYMMDD' },
            ]);
          }
        }
      }
    }

    // N6 — 기간 연속성: 최대 종료일을 제외한 각 기간은 (종료일+1 = 다른 행 시작일) 이어야 함. (본화면 MSG01133)
    //   AS-IS: 바깥 주체행(I/M/D)만 검사, maxTo·"다음 시작일 존재" 비교는 그룹 전체(기존+신규) 대상.
    for (const periods of groups.values()) {
      const withDates = periods.filter(p => p.from && p.to);
      if (withDates.length > 1) {
        const maxTo = withDates.reduce((m, p) => (p.to > m ? p.to : m), withDates[0].to);
        for (const p of withDates) {
          if (!p.isSubject) continue;
          if (p.to === maxTo) continue;
          const need = nextDay(p.to);
          const hasNext = withDates.some(q => q !== p && q.from === need);
          if (!hasNext) {
            return fail(msgIds.n6PeriodContinuity, [{ row: p.row, column: 'TO_YYYYMMDD' }]);
          }
        }
      }
    }

    // N7 — PRIORITY 양수(< 1 금지). (본화면 MSG01134) AS-IS: 주체행(I/M/D)만 검사(자기 자신 검증).
    for (const r of subjects) {
      const p = Number(r.PRIORITY);
      if (Number.isNaN(p) || p < 1) return fail(msgIds.n7PriorityPositive, [{ row: r, column: 'PRIORITY' }]);
    }

    // N8-a — FROM/TO 공백이면 메시지 없이 즉시 저장 차단(design/03 §3 N8-a, L2031-2034 — 다른 N1~N9
    //   전 분기와 달리 AS-IS 가 MessageHelper 를 호출하지 않는 유일한 무언(無言) 차단 분기).
    // N8-b/c — FROM <= TO 순서 + 처리가능 날짜범위(>= 17530101). (본화면 MSG01135 / MSG01080)
    //   AS-IS: 주체행(I/M/D)만 검사(자기 자신 검증, L1309). 기존 일정은 이미 저장돼 검증 불요.
    for (const r of subjects) {
      const f = fromOf(r);
      const t = toOf(r);
      if (!f || !t)
        return failSilent([
          { row: r, column: 'FROM_YYYYMMDD' },
          { row: r, column: 'TO_YYYYMMDD' },
        ]);
      // N8-format — 자리수는 맞지만(toYmd8) 실제 달력에 없는 날짜(예: 20261251) 차단.
      if (!isValidYmd8(f)) return fail(msgIds.n8DateFormat, [{ row: r, column: 'FROM_YYYYMMDD' }]);
      if (!isValidYmd8(t)) return fail(msgIds.n8DateFormat, [{ row: r, column: 'TO_YYYYMMDD' }]);
      if (f < '17530101') return fail(msgIds.n8DateRange, [{ row: r, column: 'FROM_YYYYMMDD' }]);
      if (t < '17530101') return fail(msgIds.n8DateRange, [{ row: r, column: 'TO_YYYYMMDD' }]);
      if (f > t)
        return fail(msgIds.n8DateOrder, [
          { row: r, column: 'FROM_YYYYMMDD' },
          { row: r, column: 'TO_YYYYMMDD' },
        ]);
    }

    // N9 — 각 (FROM,TO) 기간에 PRIORITY=1 행 존재. (본화면 MSG01137)
    //   AS-IS: 바깥 주체행(I/M/D)이 속한 기간만 검사(L1372). PRIORITY=1 존재 판정은 전체(기존+신규,
    //   dsValiChkBinding.Select, L1387) 대상 — 기존 일정에 이미 Priority 1 이 있으면 통과. 검사 대상
    //   기간을 '주체행이 하나라도 있는 기간'으로 제한해, 신규가 안 건드린 기존 기간은 트집잡지 않는다.
    for (const periods of groups.values()) {
      const withDates = periods.filter(p => p.from && p.to);
      const byPeriod = new Map<string, Period[]>();
      for (const p of withDates) {
        const k = `${p.from}^${p.to}`;
        byPeriod.set(k, [...(byPeriod.get(k) ?? []), p]);
      }
      for (const list of byPeriod.values()) {
        if (!list.some(p => p.isSubject)) continue; // 주체행이 없는 기존-전용 기간은 검사 제외
        if (!list.some(p => p.priority === 1)) {
          return fail(msgIds.n9PriorityOne, list.map(p => ({ row: p.row, column: 'PRIORITY' })));
        }
      }
    }

      return { ok: true, invalidCells: [] };
    },
    []
  );

  return { validatePlantSave };
};
