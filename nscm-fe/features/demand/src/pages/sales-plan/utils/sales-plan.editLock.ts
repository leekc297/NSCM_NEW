// ⭐ DMF0021 — 편집/잠금 규칙 엔진 R1~R6 (expressions.md 조건부잠금 112건 집약 — __asis-mapping__.md 전행 대조).
//   근거(라인 = AS-IS DMF0021_SalesPlan.cs 5,599줄 정본):
//     R1 행 게이트   : EditButton L952~1094 — SALES_PLAN_ADJUST_YN='N_Y' 행 중
//                      (SalesAmt_LOC×권한)/(Catch_Up 무조건·40 전용)/(RTF_SYS_RP×권한) 만 Unlock.
//     R2 버킷 게이트 : L736(Weekly/Monthly 만)·L1101~1103(Daily 전잠금 MSG00361)·L999~1010
//                      (Monthly↔Weekly 상호배제 [PJ2025-50017])·D_ 항상 잠금(Dsdm_Changed L3937).
//     R3 기간 cutoff : L760~812 — M_: 40=당월 포함(≥, [E20250520-000605])/비40=M+1(＞). W_=당주부터(≥).
//                      Catch_Up=M+3 이후만(L982). RTF_SYS_RP+Monthly=당월 잠금(L1052~1064).
//     R4 과거 잠금   : cutoff 이전 컬럼 = 잠금 + Gray (실적 구간).
//     R5 Insert 화이트리스트: InsertRow L2831~3382 — 참조컬럼 58종 잠금(전부 read-only) + 편집 허용
//                      소수 컬럼만 개방 (아래 insertStaticEditable — 그 외 자동 read-only 1규칙 붕괴).
//     R6 Measure 전환: ComboSelChange L4774~5082 — Catch_Up↔SalesAmt_LOC cutoff 스왑(엔진이 row.MEASURE
//                      실시간 참조로 자동 반영) + FCST_TYPE ETC 고정/개방 + 입력 clear (grid 핸들러 수행).
//   기준일 = MAIN 커서 2(calendar THIS_YYYYMM/THIS_YYYYMMWW) — 클라 시계 금지.
import { BUCKET_TYPE, EDIT_MEASURE } from '../sales-plan.constants';
import type { CalendarInfo, EditAuthInfo, SalesPlanRow } from '../sales-plan.types';

import { isDiv40, isDiv81 } from './sales-plan.division';

// 동적 PIVOT binding 종류 — M_/W_/D_ (B_* 는 항상 숨김 — 동적 컬럼 생성 단계에서 제외).
export type DynKind = 'M' | 'W' | 'D' | null;
export const dynKindOf = (binding: string): DynKind => {
  if (/^M_\d{6}$/.test(binding)) return 'M';
  if (/^W_\d{7,10}$/.test(binding)) return 'W';
  if (/^D_\d{8}$/.test(binding)) return 'D';
  return null;
};

// 주차 tag(yyyymm + ISO주차 가변 자릿수) 파서 — 사전식 비교 오류 방지 (yyyymm, week) 튜플 비교.
export interface WeekTag {
  ym: string; // yyyymm
  wk: number; // ISO week
}
export const parseWeekTag = (tag: string): WeekTag | null => {
  const t = (tag ?? '').replace(/^W_/, '').trim();
  if (!/^\d{7,10}$/.test(t)) return null;
  return { ym: t.slice(0, 6), wk: Number(t.slice(6)) };
};
const cmpWeek = (a: WeekTag, b: WeekTag): number =>
  a.ym === b.ym ? a.wk - b.wk : a.ym < b.ym ? -1 : 1;

// yyyymm + n개월 (Catch_Up M+3 산출)
export const addMonths = (yyyymm: string, n: number): string => {
  if (!/^\d{6}$/.test(yyyymm)) return yyyymm;
  const total = Number(yyyymm.slice(0, 4)) * 12 + (Number(yyyymm.slice(4, 6)) - 1) + n;
  const y = Math.floor(total / 12);
  const m = (total % 12) + 1;
  return `${y}${String(m).padStart(2, '0')}`;
};

// 파셜주차 동일주 판정 — 같은 ISO 주(주차번호 동일)가 두 달에 걸쳐 두 컬럼(W_yyyymm+wk)으로
//   쪼개진 경우, 앞달 조각을 당주 조각과 "같은 주"로 본다(사용자 요구 2026-09-22 해석 B).
//   근거: SPREAD_TITLE 커서 W_ = 'W_'||BASIS_YYYYMM||ISO_WEEK, GROUP BY BASIS_YYYYMM,ISO_WEEK —
//   파셜 두 조각은 ISO_WEEK(wk) 가 같고 BASIS_YYYYMM(ym) 만 직전/직후 월로 다르다.
//   한정: wk 동일 + a.ym 이 b.ym 의 직전 월일 때만(다음 해 같은 주차 오판정 방지).
const isSamePartialWeek = (a: WeekTag, b: WeekTag): boolean =>
  a.wk === b.wk && a.ym !== b.ym && addMonths(a.ym, 1) === b.ym;

// ⭐ cutoff 묶음 — 모든 잠금 판정의 기준값 (MAIN 커서 2 원천. null = 미조회 → 전 잠금).
export interface SalesPlanCutoff {
  thisMonth: string; // yyyymm (calendar THIS_YYYYMM — 'M_' prefix 유입 시 정규화)
  thisWeek: WeekTag | null; // calendar THIS_YYYYMMWW
  catchUpMonth: string; // 당월 + 3 (Catch_Up 입력 개시월 — AS-IS L982 M+3 이후)
}

export const buildCutoff = (calendar: CalendarInfo | null): SalesPlanCutoff | null => {
  const rawMonth = (calendar?.THIS_YYYYMM ?? '').toString().replace(/^M_/, '').trim();
  if (!/^\d{6}$/.test(rawMonth)) return null;
  return {
    thisMonth: rawMonth,
    thisWeek: parseWeekTag((calendar?.THIS_YYYYMMWW ?? '').toString()),
    catchUpMonth: addMonths(rawMonth, 3),
  };
};

// measure 편집권한 (MAIN 커서 3 — 대문자 컬럼 실측 확정)
export interface MeasureAuth {
  salesAmtLoc: boolean;
  rtfSysRp: boolean;
}
export const buildMeasureAuth = (editAuth: EditAuthInfo | null): MeasureAuth => ({
  salesAmtLoc: (editAuth?.EDIT_AUTH_SALESAMT_LOC ?? '') === 'Y',
  rtfSysRp: (editAuth?.EDIT_AUTH_RTF_SYS_RP ?? '') === 'Y',
});

export interface DynCellState {
  editable: boolean; // 최종 편집 가능 (Yellow)
  isPast: boolean; // 과거 실적 구간 (Gray — 컬럼 차원, 행 게이트와 무관)
}

const LOCKED: DynCellState = { editable: false, isPast: false };

// ⭐ 동적 셀(M_/W_/D_) 편집 가능 여부 — R1~R4 종합 (formatItem 배경색 + beginningEdit cancel 공유).
export const evalSalesPlanDynCell = (params: {
  binding: string;
  row: SalesPlanRow | undefined;
  divisionId: string;
  bucketType: BUCKET_TYPE;
  cutoff: SalesPlanCutoff | null;
  auth: MeasureAuth;
}): DynCellState => {
  const { binding, row, divisionId, bucketType, cutoff, auth } = params;
  const kind = dynKindOf(binding);
  if (!kind) return LOCKED;
  if (!cutoff) return LOCKED; // 기준일 미도착(미조회) — 전 잠금

  // ── 과거(Gray) 판정 — 컬럼 차원 (행 게이트와 독립. AS-IS 실적구간 Gainsboro/과거 잠금) ──
  const isPast = ((): boolean => {
    if (kind === 'M') return binding.slice(2) < cutoff.thisMonth;
    if (kind === 'W') {
      const w = parseWeekTag(binding);
      if (!w || !cutoff.thisWeek) return false;
      // 파셜 앞달 조각(당주와 같은 ISO 주)은 과거 아님 — 당주와 함께 취급(해석 B).
      if (isSamePartialWeek(w, cutoff.thisWeek)) return false;
      return cmpWeek(w, cutoff.thisWeek) < 0;
    }
    return binding.slice(2, 8) < cutoff.thisMonth; // D_ — 당월 이전 일자
  })();

  // ── R2 버킷 게이트 — Daily 전잠금 / D_ 항상 잠금 / Monthly↔Weekly 상호배제 ──
  if (bucketType === BUCKET_TYPE.DAILY) return { editable: false, isPast };
  if (kind === 'D') return { editable: false, isPast };
  if (bucketType === BUCKET_TYPE.MONTHLY && kind === 'W') return { editable: false, isPast };
  if (bucketType === BUCKET_TYPE.WEEKLY && kind === 'M') return { editable: false, isPast };

  // ── R1 행 게이트 — measure × 권한 (+기존행 SALES_PLAN_ADJUST_YN='N_Y') ──
  const measure = typeof row?.MEASURE === 'string' ? row.MEASURE : '';
  const fcstType = typeof row?.FCST_TYPE === 'string' ? row.FCST_TYPE : '';
  const isInsert = row?.CRUD_TYPE === 'I';
  if (!isInsert) {
    const adjustYn = typeof row?.SALES_PLAN_ADJUST_YN === 'string' ? row.SALES_PLAN_ADJUST_YN : '';
    if (adjustYn !== 'N_Y') return { editable: false, isPast };
  }
  const measureGate =
    // ⭐ [E20260331-000648] SalesAmt_LOC = FCST_TYPE='ETC' 행만 편집 (AS-IS L968 / §7.1(2)).
    //   Insert 행은 FCST_TYPE=ETC 강제라 무영향 — 기존 비-ETC 행만 잠금.
    (measure === EDIT_MEASURE.SALES_AMT_LOC && auth.salesAmtLoc && fcstType === 'ETC') ||
    (measure === EDIT_MEASURE.CATCH_UP && isDiv40(divisionId)) ||
    // ⭐ [E20260331-000648] RTF_SYS_RP 편집 = div 40 또는 81 만 (AS-IS L1041-1045 / §7.1(3)).
    //   40→40+81 확장. 82 는 RTF 편집 대상 아님(권한 있어도 잠금).
    (measure === EDIT_MEASURE.RTF_SYS_RP &&
      auth.rtfSysRp &&
      (isDiv40(divisionId) || isDiv81(divisionId)));
  if (!measureGate) return { editable: false, isPast };

  // ── R3/R4 기간 cutoff ──
  if (kind === 'M') {
    const tag = binding.slice(2);
    if (measure === EDIT_MEASURE.CATCH_UP) {
      // Catch_Up = M+3 이후만 (AS-IS L982)
      return { editable: tag >= cutoff.catchUpMonth, isPast };
    }
    if (measure === EDIT_MEASURE.RTF_SYS_RP) {
      // RTF_SYS_RP + Monthly = 당월 잠금 (AS-IS L1052~1064 [E20250520-000605])
      return { editable: tag > cutoff.thisMonth, isPast };
    }
    // SalesAmt_LOC — 40=당월 포함(≥, L766) / 비40=익월부터(＞, L783)
    const editable = isDiv40(divisionId) ? tag >= cutoff.thisMonth : tag > cutoff.thisMonth;
    return { editable, isPast };
  }
  // kind === 'W' — 당주부터(≥, L798). Catch_Up 은 M+3 이후 월의 주차만.
  const w = parseWeekTag(binding);
  if (!w || !cutoff.thisWeek) return { editable: false, isPast };
  // 파셜주차 예외(해석 B) — 당주가 두 달에 걸친 파셜이면 앞달 조각(예: 당주 W_20261040 의
  //   W_20260940)도 같은 주로 보아 함께 개방한다. cmpWeek 는 월을 먼저 비교해 앞달 조각을 과거로
  //   잠그므로, 이 예외를 당주-이전 컷보다 먼저 둔다.
  const isPartnerOfThisWeek = isSamePartialWeek(w, cutoff.thisWeek);
  if (!isPartnerOfThisWeek && cmpWeek(w, cutoff.thisWeek) < 0) return { editable: false, isPast };
  if (measure === EDIT_MEASURE.CATCH_UP && w.ym < cutoff.catchUpMonth) {
    return { editable: false, isPast };
  }
  return { editable: true, isPast };
};

// ============================================================================
// ⭐ R5 — Insert 행 정적 컬럼 화이트리스트 (AS-IS InsertRow L2881~3133 잠금 68건 붕괴 —
//   아래 개방 컬럼 외 전부 자동 read-only. expressions #14~#84 대응).
//   DIVISION_ID = 조회조건 자동 세팅 + 잠금(L2881) / DEPT_ID = 전 Div 콤보(메타 TeamByDivision, Catch_Up 시 잠금 L4911) /
//   MEASURE = 40 콤보(L2925~2935) — 단 후보가 2건 이상일 때만 개방 (아래 measureCandidateCount) /
//   FCST_TYPE = ETC 고정 잠금(L2944) — Catch_Up 시 개방(L4903) /
//   DOM_EXP·INCOTERMS = Catch_Up 시만 개방(L4877/4896) / PLANT_SITE_ID = 전 Div 잠금(표시 전용) /
//   TEXT = 81 / TEXT4082 = 40·82 / CELL_PROD_SITE_ID = 40 (L2919) / CURRENCY 콤보(L3000) /
//   ITEM_ID = 콤보(40+Catch_Up 은 모달 전용 — 직접 입력 차단 L4870).
// ============================================================================
export const insertStaticEditable = (
  binding: string,
  row: SalesPlanRow,
  divisionId: string,
  // MEASURE 콤보 개방 게이트 — measureInfo(GET_SALES_PLAN_MEASUREINFO) 후보 개수.
  //   40 은 AS-IS 상 콤보였으나 현재 후보가 SalesAmt_LOC 1건뿐이라 콤보를 열 이유가 없다
  //   (기본값 INSERT_DEFAULT_MEASURE 로 이미 채워짐 = 81/82 와 동일하게 고정 표시).
  //   후보가 2건 이상으로 늘면 자동으로 다시 콤보 개방 (2026-09-03 사용자 확정 — 데이터 종속).
  measureCandidateCount = 0
): boolean => {
  const d40 = isDiv40(divisionId);
  const d81 = isDiv81(divisionId);
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  const catchUp = measure === EDIT_MEASURE.CATCH_UP;
  switch (binding) {
    case 'TEAM_NAME':
      // Team = 팀명 셀 팝업 편집 (사용자 요구). Catch_Up 시만 잠금(AS-IS L4911). 직접 타이핑이
      //   아니라 dblclick 팝업이지만, 팝업으로 값이 들어가므로 표시는 편집 가능(Yellow)이어야 한다
      //   (isInsertModalCell 과 짝). 실제 값 세팅은 DEPT_ID(코드)+TEAM_NAME(명) 짝으로 이뤄진다.
      return !catchUp;
    case 'END_CUSTOMER':
      return !d40;
    case 'END_CUSTOMER40':
      return d40;
    case 'SCM_SITE_ID':
      return true;
    case 'ITEM_ID':
      return !(d40 && catchUp); // 40+Catch_Up = 모달 전용 (dblclick)
    case 'TEXT':
      return d81;
    case 'TEXT4082':
      return !d81;
    case 'MEASURE':
      // 40 이라도 후보가 1건 이하면 고를 게 없어 콤보를 열지 않는다 (81/82 처럼 고정 표시).
      return d40 && measureCandidateCount >= 2;
    case 'CURRENCY':
      return true;
    case 'CELL_PROD_SITE_ID':
      return d40;
    case 'PLANT_SITE_ID':
      // [2026-09-01 정정] 전 Div 입력 불가 — FROM_SITE_ID 와 같은 표시 전용 컴럼이다.
      //   종전 81 개방은 AS-IS 오독. 근거(DMF0021_SalesPlan.cs 정본 5,643줄):
      //     · InsertRow L3023~3024 — 신규행 PLANT_SITE_ID 무조건 LockRange(true).
      //     · 81 unlock(L4581~4586)은 spdMain_ComboSelChange 의 `e.Column == DIVISION_ID` 분기 안 —
      //       그리드 Division 셀을 직접 바꿀 때만 동는다. 그런데 InsertRow L2916 이 Division 셀을
      //       잠그고(조회조건 값 고정) TO-BE 도 DIVISION_ID 를 열지 않으므로 도달 불가 경로다.
      //     · Measure 분기의 PLANT_SITE_ID 개방/잠금 2곳(L4920~4928, L5022~5029)은 전부 주석.
      //     · L4247 주석 [PJ2024-50611] "PlantSiteId는 입력 안받으므로 체크에서 제외".
      //   값-필수도 아니다(requiredFieldsFor 주석 [E20260512-000502]) — 81 은 컴럼-존재 체크만 한다.
      return false;
    case 'DOM_EXP':
    case 'INCOTERMS':
    case 'FCST_TYPE':
      return d40 && catchUp;
    default:
      return false; // 참조컬럼 58종 등 그 외 전부 read-only (R5 붕괴 규칙)
  }
};

// R5 보조 — Insert 행 모달 전용 입력 셀 (직접 타이핑 불가, dblclick 팝업으로만 값 입력).
//   PROJECT_CODE = 81·82 (AS-IS spdMain_CellDoubleClick L3834) / ITEM_ID = 40+Catch_Up (L3863).
//   insertStaticEditable 은 false 를 유지해야 한다(직접 편집 차단) — 대신 표시(Yellow)와 팝업
//   아이콘 판정에 이 함수를 쓴다. mkt-fcst FPModal 셀과 동일 계약(팝업 입력 = 편집 가능 Yellow).
export const isInsertModalCell = (
  binding: string,
  row: SalesPlanRow,
  divisionId: string
): boolean => {
  if (row.CRUD_TYPE !== 'I') return false;
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  if (binding === 'PROJECT_CODE') return !isDiv40(divisionId);
  if (binding === 'ITEM_ID') return isDiv40(divisionId) && measure === EDIT_MEASURE.CATCH_UP;
  // TEAM_NAME(Team) — 팀명 표시 컬럼에 팝업을 단다(사용자 요구). 코드(DEPT_ID)는 admin 메타에서
  //   숨김이라 화면 표시·팝업은 TEAM_NAME 한 셀로 통일하고, 선택 시 DEPT_ID(코드)+TEAM_NAME(명)을
  //   짝으로 세팅한다(하위 파생·저장은 여전히 DEPT_ID 를 읽는다). Catch_Up 은 AS-IS L4911 대로
  //   잠금이라 모달 셀도 아니다(insertStaticEditable 도 !catchUp 로 일치).
  if (binding === 'TEAM_NAME') return measure !== EDIT_MEASURE.CATCH_UP;
  return false;
};
