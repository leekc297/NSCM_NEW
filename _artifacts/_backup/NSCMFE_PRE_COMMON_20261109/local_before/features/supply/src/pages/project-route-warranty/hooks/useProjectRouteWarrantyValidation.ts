import { useCallback } from 'react';

import {
  isSalesSitePopupDivision,
  MSG,
  OPERATION_GROUP_WARRANTY,
} from '../project-route-warranty.constants';
import type { MainRow } from '../project-route-warranty.types';
import { toYmd8 } from '../utils/projectRouteWarranty.derive';

// SCP0048 저장검증(design/03 §4.3). AS-IS SaveData 순차 검증(실패 시 전체 중단)을 재현한다.
//   순서(설계 확정): N1 → N2 → N5 → N3 → N4 → N7 → N8 → N9 → N10 → N11.
//   자매 SCP0006 검증엔진과 규칙 골격은 같으나 3가지가 다르다:
//     (1) N6(기간 연속성) 없음 — SCP0048 검증표에 미포함.
//     (2) 그룹키에 DIVISION_ID 포함 — AS-IS 가 "동일 DIV/SITE/PROJECT/ITEM" 을 한 일정군으로 본다
//         (design/03 §4.3 표 N1~N5 대상행). SCP0006 은 DIVISION 을 키에 넣지 않았다.
//     (3) N10(div=81 SCM_SITE_ID/PROJECT_CODE 필수) · N11(Warranty PRIORITY≥11) 추가.
//   N1~N9 는 VALID_YN='Y' 행만 대상, N10 은 편집행(I/M/D) 전체, N11 은 Warranty·Y 행.
//
// 그룹 범위 주의(정직): AS-IS checkValidN1~N5 의 정확한 group-by 키는 SP/소스 미확정(ora.py query
//   승인 차단, 04_react-gap GAP 참조). 본 구현은 design/03 §4.3 표의 의미규칙("동일
//   DIV/SITE/PROJECT/ITEM")을 재현한다. SP 본문 확인 후 group 키 정합 필요.

export interface WarrantyValidationResult {
  ok: boolean;
  msgId?: string;
  // msgId 문구의 {0} 치환 인자(예: N10 의 "[Sales Site Code, Project] 값은 필수…"). 없으면 치환 생략.
  msgArg?: string;
  invalidCells: { row: MainRow; column: string }[];
  // N8-a(FROM/TO 공백) 전용 — AS-IS 가 메시지 없이 조용히 저장을 차단하는 분기(자매 SCP0006 동일).
  silent?: boolean;
}

interface Period {
  row: MainRow;
  from: string; // YYYYMMDD (8)
  to: string; // YYYYMMDD (8)
  priority: number;
  plantSiteId: string;
  changed: boolean; // CRUD_TYPE ∈ {I,M,D} — AS-IS 바깥 루프 "수정된 것만" 기준행 여부
}

// 그룹키 = DIVISION_ID^ITEM_ID^SCM_SITE_ID^PROJECT_CODE(design/03 §4.3 표 대상행 "동일
//   DIV/SITE/PROJECT/ITEM"). 자매 SCP0006 대비 DIVISION_ID 가 추가된 점이 SCP0048 고유.
const groupKey = (r: MainRow): string =>
  `${String(r.DIVISION_ID ?? '')}^${String(r.ITEM_ID ?? '')}^${String(
    r.SCM_SITE_ID ?? ''
  )}^${String(r.PROJECT_CODE ?? '')}`;

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

// div=81 필수 체크의 "미입력" 판정(N10). '/'(NO_VALUE_PLACEHOLDER)는 null 회피용 기본값이자
//   그 자체로 유효한 저장값이라 미입력이 아니다(사용자 확인 2026-10-19). 공백/null 과 AS-IS 기존
//   placeholder '-'(DB 레거시 데이터)만 미입력으로 본다.
const isSalesSiteBlank = (v: unknown): boolean => {
  const s = String(v ?? '').trim();
  return s === '' || s === '-';
};

// AS-IS checkValidN1~N11 바깥 루프 가드 "수정된 것만"(action ∈ {FlagI,FlagM,FlagD}) 재현.
//   조회만 하고 미변경한 행은 기준행(검사 주체)에서 제외된다 — 비교 상대(안쪽 루프)로는 여전히 쓰인다.
const isChangedAction = (r: MainRow): boolean => {
  const c = String(r.CRUD_TYPE ?? '');
  return c === 'I' || c === 'M' || c === 'D';
};

export const useProjectRouteWarrantyValidation = () => {
  const validateWarrantySave = useCallback((rows: MainRow[]): WarrantyValidationResult => {
    const fail = (
      msgId: string,
      cells: { row: MainRow; column: string }[],
      msgArg?: string
    ): WarrantyValidationResult => ({ ok: false, msgId, msgArg, invalidCells: cells });
    const failSilent = (cells: { row: MainRow; column: string }[]): WarrantyValidationResult => ({
      ok: false,
      invalidCells: cells,
      silent: true,
    });

    // N1~N9 비교대상(안쪽 루프): VALID_YN='Y' 전체. 기준행(바깥 루프)은 추가로 변경행(I/M/D) 필터를
    //   건다(Period.changed) — AS-IS 가 "수정된 것만" 기준으로 "전체 Y행"과 비교하는 비대칭 구조.
    //   N10/N11 은 별도(아래).
    const targets = rows.filter(r => String(r.VALID_YN ?? '') === 'Y');

    // 그룹별 기간(N1~N5, N9 공용).
    const groups = new Map<string, Period[]>();
    for (const r of targets) {
      const list = groups.get(groupKey(r)) ?? [];
      list.push({
        row: r,
        from: fromOf(r),
        to: toOf(r),
        priority: Number(r.PRIORITY),
        plantSiteId: String(r.PLANT_SITE_ID_B ?? r.PLANT_SITE_ID ?? ''),
        changed: isChangedAction(r),
      });
      groups.set(groupKey(r), list);
    }

    // N1(MSG01223) — 시작일자 동일한데 종료일자 다른 행(중첩 종료일자). mark TO.
    //   기준행 i 는 변경행(changed)만, 비교상대 j 는 전체 Y 행(i≠j) — AS-IS cs:1089~1135.
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].changed) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
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

    // N2(MSG01224) — 종료일자 동일한데 시작일자 다른 행(중첩 시작일자). mark FROM.
    //   기준행 i 는 변경행(changed)만, 비교상대 j 는 전체 Y 행(i≠j) — AS-IS cs:1156~.
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].changed) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
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

    // N5(MSG01226/01227) — 서로 다른 기간의 FROM/TO 가 타 일정 기간 사이에 겹침(중첩기간).
    //   AS-IS cs:1399-1472 정합. 그룹은 이미 DIV/SITE/PROJECT/ITEM 동일이라 PLANT/PRIORITY 로 분기한다.
    //   경계 포함(>=/<=): AS-IS 는 nORG_FROM >= cp_FROM && nORG_FROM <= cp_TO 형태라 경계 접촉도 겹침.
    //   분기:
    //     - PLANT 동일         → 중첩기간(MSG01227).
    //     - PLANT 상이+PRIORITY 동일 → Priority 중복(MSG01226).
    //     - PLANT 상이+PRIORITY 상이 → 통과.
    //   비교조건 A(cs:1399): i.from 또는 i.to 가 [j.from, j.to] 경계 포함 안에 든다.
    //   비교조건 B(cs:1427): i 가 j 를 완전 포함(i.to >= j.to && i.from <= j.from).
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].changed) continue; // 기준행은 변경행만(AS-IS cs:1355~)
        for (let j = 0; j < periods.length; j++) {
          if (i === j || !periods[i].from || !periods[i].to || !periods[j].from || !periods[j].to)
            continue;
          const same = periods[i].from === periods[j].from && periods[i].to === periods[j].to;
          if (same) continue; // 완전 동일 기간(MERGE_DATE 동일)은 AS-IS 에서도 제외 — N3/N4 소관
          const startInside = periods[i].from >= periods[j].from && periods[i].from <= periods[j].to;
          const endInside = periods[i].to >= periods[j].from && periods[i].to <= periods[j].to;
          const contains = periods[i].to >= periods[j].to && periods[i].from <= periods[j].from;
          if (!startInside && !endInside && !contains) continue;
          const samePlant = periods[i].plantSiteId === periods[j].plantSiteId;
          if (samePlant) {
            return fail(MSG.N5_PERIOD_OVERLAP_ALT, [
              { row: periods[i].row, column: 'FROM_YYYYMMDD' },
              { row: periods[i].row, column: 'TO_YYYYMMDD' },
            ]);
          }
          if (periods[i].priority === periods[j].priority) {
            return fail(MSG.N5_PERIOD_OVERLAP, [
              { row: periods[i].row, column: 'PRIORITY' },
              { row: periods[j].row, column: 'PRIORITY' },
            ]);
          }
          // PLANT 상이 + PRIORITY 상이 → 통과(AS-IS isPass=true).
        }
      }
    }

    // N3(MSG01225) — FROM·TO 동일 + PLANT_SITE_ID 동일(Plant Site 중복). AS-IS cs:1257~1259.
    //   기준행 i 는 변경행만, 비교상대 j 는 전체 Y 행(i≠j).
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].changed) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
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

    // N4(MSG01226) — FROM·TO 동일 + PLANT 상이 + PRIORITY 동일(Priority 중복). AS-IS cs:1322~1324
    //   (PLANT_SITE_ID != cp_PLANT_SITE_ID && PRIORITY == cp_PRIORITY). 기준행 i 는 변경행만.
    for (const periods of groups.values()) {
      for (let i = 0; i < periods.length; i++) {
        if (!periods[i].changed) continue;
        for (let j = 0; j < periods.length; j++) {
          if (i === j) continue;
          if (
            periods[i].from === periods[j].from &&
            periods[i].to === periods[j].to &&
            periods[i].plantSiteId !== periods[j].plantSiteId &&
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

    // 기준행(변경행 ∩ VALID='Y') — N7~N9·N11 공용. AS-IS 는 각 규칙 바깥 루프에서 "수정된 것만".
    const changedTargets = targets.filter(isChangedAction);

    // N7(MSG01134) — PRIORITY 양의 정수(<1 금지).
    for (const r of changedTargets) {
      const p = Number(r.PRIORITY);
      if (Number.isNaN(p) || p < 1)
        return fail(MSG.N7_PRIORITY_POSITIVE, [{ row: r, column: 'PRIORITY' }]);
    }

    // N8 — FROM/TO 공백이면 무언 차단(N8-a), 그 외 자리수·범위·순서(N8-b/c, MSG01230/01080).
    for (const r of changedTargets) {
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

    // N9(MSG01231) — 각 (FROM,TO) 기간에 PRIORITY=1 행 존재.
    //   design/03 §4.3: "opGroup≠W 시 checkRows=0 & PRIORITY≠1" — Warranty(W) 행은 이 검사 제외
    //   (W 는 PRIORITY≥11 규칙(N11)을 따르므로 P=1 강제 대상이 아니다).
    for (const periods of groups.values()) {
      const nonWarranty = periods.filter(
        p => String(p.row.OPERATION_GROUP ?? '') !== OPERATION_GROUP_WARRANTY && p.from && p.to
      );
      const byPeriod = new Map<string, Period[]>();
      for (const p of nonWarranty) {
        const k = `${p.from}^${p.to}`;
        byPeriod.set(k, [...(byPeriod.get(k) ?? []), p]);
      }
      for (const list of byPeriod.values()) {
        // AS-IS: 기준행(변경행)이 PRIORITY≠1 이고 그 기간에 PRIORITY=1 행이 하나도 없을 때만 실패.
        //   미변경행만 있는 기간은 검사 대상이 아니다(조회만 한 기존 데이터는 그대로 저장 허용).
        const hasPriorityOne = list.some(p => p.priority === 1);
        if (hasPriorityOne) continue;
        if (list.some(p => p.changed && p.priority !== 1)) {
          return fail(
            MSG.N9_PRIORITY_ONE,
            list.map(p => ({ row: p.row, column: 'PRIORITY' }))
          );
        }
      }
    }

    // N10 — div=81 은 SCM_SITE_ID·PROJECT_CODE 필수(공백/"-"/"/" 불가).
    //   대상: 편집행 I/M/D 전체(AS-IS cs:1680 은 변경행만 검사, VALID 로 거르지 않는다).
    //   메시지: AS-IS 는 MSG00002 에 "Salse Site Code, Project" 를 넣어 "~필수" 로 썼으나, TO-BE DB
    //   의 MSG00002 는 "저장되었습니다"(성공문구)라 충돌한다(ora.py 실측 2026-10-19). 문구기준
    //   재매핑으로 표준 필수문구 MSG00429("{0} 값은 필수 입력 항목입니다.")에 항목명을 치환해 쓴다.
    for (const r of rows) {
      if (!isChangedAction(r)) continue;
      if (!isSalesSitePopupDivision(String(r.DIVISION_ID ?? ''))) continue;
      if (isSalesSiteBlank(r.SCM_SITE_ID))
        return fail(MSG.N10_SALES_SITE_REQUIRED, [{ row: r, column: 'SCM_SITE_ID' }], MSG.N10_SALES_SITE_LABEL);
      if (isSalesSiteBlank(r.PROJECT_CODE))
        return fail(MSG.N10_SALES_SITE_REQUIRED, [{ row: r, column: 'PROJECT_CODE' }], MSG.N10_SALES_SITE_LABEL);
    }

    // N11(MSG01319) — Warranty(opGroup=W) 행은 PRIORITY≥11. 대상: 변경행 I/M/D · VALID_YN=Y.
    for (const r of changedTargets) {
      if (String(r.OPERATION_GROUP ?? '') !== OPERATION_GROUP_WARRANTY) continue;
      if (Number(r.PRIORITY) < 11)
        return fail(MSG.N11_WARRANTY_PRIORITY, [{ row: r, column: 'PRIORITY' }]);
    }

    return { ok: true, invalidCells: [] };
  }, []);

  return { validateWarrantySave };
};
