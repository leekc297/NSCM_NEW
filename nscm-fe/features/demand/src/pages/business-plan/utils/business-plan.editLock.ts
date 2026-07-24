// ⭐ DMF0042 — 편집/잠금 규칙 엔진 R1~R5+R7 (expressions 103건 조건부잠금 집약 — __asis-mapping__.md 전행 대조).
//   근거(라인 = AS-IS 신정본 base DMF0042_BizPlan.cs 3,563행 — 2026-07-20 최신분석 2본으로 재대조.
//   ⚠ 구정본 _1(3,477행) 기준이던 라인 인용을 신정본으로 전면 갱신 — 2026-07-21 보완):
//     R1 행 게이트   : EditButton L644~ — EDIT_FLAG=='Y' 행 × Measure∈{Business_Plan, LOC} 만 수량영역 unlock.
//                      (KRW/USD/SalesAmt_*/CAR_QTY/MKT_FCST = SP 파생 — 전체 잠금. InsertRow 동일)
//     R2 버킷 게이트 : EditButton L582~637 — 활성 버킷 축(M_/Q_/Y_)만 편집, 나머지 축 잠금.
//     R3 금년 잠금   : L670~689 — 금년 이전 컬럼 잠금 (기준 = 금주 월요일 GetThisWeekMonday — FE 산정,
//                      조회 파라미터 p_now_yyyymmdd 와 동일 값).
//     R4' 버킷축별 유효구간 (2026-07-21 G1 교정 — 신정본 EditButton L582~637 / InsertRow L1406~1461 1:1):
//                      M_  = 40 && VALID_YN=='Y' && 구간 비공란일 때만 구간 밖 잠금 — else 없음(비40 전면 개방, L588).
//                      Q_/Y_ = 40 && VALID_YN=='Y' && 구간 비공란 && 구간 내 에서만 개방 —
//                              그 외 무조건 잠금 (L612~615 / L632~635 else LockColumn).
//                      ⚠ 구현이 "81/82 = 게이트 미적용(통과)"이던 것은 구정본 승계 오류 — 81/82 는 Q_/Y_ 직접입력 불가가 파리티.
//     R5 Insert 화이트리스트: InsertRow — 메타 컬럼 전량 잠금 + division별 개방 소수 컬럼만.
//     (구 R6 삭제 — 2026-07-21 G2: 기존행 Incoterms/FcstType 조건 개방 블록은 신정본 L651~667 이 17행 전체 주석(비활성).
//      L649 LockRange 가 살아 있어 기존행 정적 영역은 예외 없이 전량 잠금 = 파리티.)
//     R7 3색       : 편집 Yellow / 과거 Gray / 기본 White (#95) — Grid formatItem 이 소비.
import { BUCKET_TYPE, EDIT_MEASURE } from '../business-plan.constants';
import type { BusinessPlanRow, CutoffWindow } from '../business-plan.types';

import { isDiv40, isDiv81, isDiv82 } from './business-plan.division';

// 동적 PIVOT binding 종류 — Y_yyyy / Q_yyyy_q / M_yyyymm (B_* 는 kind null → 자동 제외 = 항상 숨김.
//   형식 실측: DMF0042_GET_SPREAD_TITLE L220/235/251 — 'Q_'||YYYY||'_'||분기번호).
export type DynKind = 'Y' | 'Q' | 'M' | null;
export const dynKindOf = (binding: string): DynKind => {
  if (/^Y_\d{4}$/.test(binding)) return 'Y';
  if (/^Q_\d{4}_\d$/.test(binding)) return 'Q';
  if (/^M_\d{6}$/.test(binding)) return 'M';
  return null;
};

// binding → (year, quarter, month) 튜플. 미해당 축은 0.
export interface DynTag {
  kind: 'Y' | 'Q' | 'M';
  year: number;
  quarter: number; // Y_=0 / Q_=1~4 / M_=월의 분기
  month: number; // M_ 만 (1~12)
}
export const parseDynTag = (binding: string): DynTag | null => {
  const kind = dynKindOf(binding);
  if (!kind) return null;
  if (kind === 'Y') return { kind, year: Number(binding.slice(2)), quarter: 0, month: 0 };
  if (kind === 'Q') {
    return { kind, year: Number(binding.slice(2, 6)), quarter: Number(binding.slice(7)), month: 0 };
  }
  const ym = binding.slice(2);
  const month = Number(ym.slice(4, 6));
  return { kind, year: Number(ym.slice(0, 4)), quarter: Math.ceil(month / 3), month };
};

// Q_ 소속 M_ 판정 / Y_ 소속 M_ 판정 (배분·롤업 공유)
export const monthInQuarter = (mTag: DynTag, qTag: DynTag): boolean =>
  mTag.year === qTag.year && mTag.quarter === qTag.quarter;
export const monthInYear = (mTag: DynTag, yTag: DynTag): boolean => mTag.year === yTag.year;

// ⭐ cutoff 기준 — 금주 월요일 (AS-IS GetThisWeekMonday L3023~3042 1:1. 조회 p_now_yyyymmdd 와 동일 원천).
export interface BizPlanCutoff {
  nowYyyymmdd: string; // 금주 월요일
  thisMonth: string; // yyyymm
  thisYear: number;
  thisQuarter: number;
}
export const buildCutoff = (nowYyyymmdd: string): BizPlanCutoff | null => {
  if (!/^\d{8}$/.test(nowYyyymmdd)) return null;
  const month = Number(nowYyyymmdd.slice(4, 6));
  return {
    nowYyyymmdd,
    thisMonth: nowYyyymmdd.slice(0, 6),
    thisYear: Number(nowYyyymmdd.slice(0, 4)),
    thisQuarter: Math.ceil(month / 3),
  };
};

// ⭐ 40 편집 유효구간 (커서2 — VALID_YN='Y' 시 버킷별 START/END. 81/82 NULL 방어 = 게이트 미적용)
export interface ValidWindow {
  validYn: boolean;
  startYyyymm: string;
  endYyyymm: string;
  startYyyyqq: string; // 'yyyyq' 5자리 (SP L1094 REPLACE(CALENDAR_YYYYQQ,'Q',''))
  endYyyyqq: string;
  startYyyy: string;
  endYyyy: string;
}
export const buildValidWindow = (calendar: CutoffWindow | null): ValidWindow | null => {
  if (!calendar) return null;
  // 타입 안전 string 변환 — string/number 만 (객체는 ''. no-base-to-string 회피)
  const s = (v: unknown): string =>
    typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';
  return {
    validYn: s(calendar.VALID_YN) === 'Y',
    startYyyymm: s(calendar.START_YYYYMM),
    endYyyymm: s(calendar.END_YYYYMM),
    startYyyyqq: s(calendar.START_YYYYQQ),
    endYyyyqq: s(calendar.END_YYYYQQ),
    startYyyy: s(calendar.START_YYYY),
    endYyyy: s(calendar.END_YYYY),
  };
};

export interface DynCellState {
  editable: boolean; // 최종 편집 가능 (Yellow)
  isPast: boolean; // 과거 실적 구간 (Gray — 컬럼 차원, 행 게이트와 무관)
}

const LOCKED: DynCellState = { editable: false, isPast: false };

// ⭐ 동적 셀(Y_/Q_/M_) 편집 가능 여부 — R1~R4 종합 (formatItem 배경색 + beginningEdit cancel 공유).
export const evalBizPlanDynCell = (params: {
  binding: string;
  row: BusinessPlanRow | undefined;
  divisionId: string;
  bucketType: BUCKET_TYPE;
  cutoff: BizPlanCutoff | null;
  window: ValidWindow | null;
}): DynCellState => {
  const { binding, row, divisionId, bucketType, cutoff, window } = params;
  const tag = parseDynTag(binding);
  if (!tag) return LOCKED;
  if (!cutoff) return LOCKED;

  // ── 과거(Gray) 판정 — 컬럼 차원 (Yearly 배분 실적구간 스킵 L2206/2232 과 동일 기준) ──
  const isPast = ((): boolean => {
    if (tag.kind === 'M') return binding.slice(2) < cutoff.thisMonth;
    if (tag.kind === 'Q') {
      return tag.year * 10 + tag.quarter < cutoff.thisYear * 10 + cutoff.thisQuarter;
    }
    return tag.year < cutoff.thisYear;
  })();

  // ── R2 버킷 게이트 — 활성 버킷 축만 편집 (EditButton L556~614: Monthly=M_ 외 lock 등.
  //    BUCKET_TYPE 값('M'/'Q'/'Y') = DynKind 문자열 — enum↔union 직접 비교 회피 매핑) ──
  const activeKind: 'Y' | 'Q' | 'M' =
    bucketType === BUCKET_TYPE.YEARLY ? 'Y' : bucketType === BUCKET_TYPE.QUARTERLY ? 'Q' : 'M';
  if (tag.kind !== activeKind) return { editable: false, isPast };

  // ── R1 행 게이트 — EDIT_FLAG(기존행) × Measure∈{Business_Plan, LOC} (L616~664) ──
  const measure = typeof row?.MEASURE === 'string' ? row.MEASURE : '';
  const isInsert = row?.CRUD_TYPE === 'I';
  if (!isInsert) {
    const editFlag = typeof row?.EDIT_FLAG === 'string' ? row.EDIT_FLAG : '';
    if (editFlag !== 'Y') return { editable: false, isPast };
  }
  if (measure !== EDIT_MEASURE.BUSINESS_PLAN && measure !== EDIT_MEASURE.LOC) {
    return { editable: false, isPast };
  }

  // ── R3 금년 이전 잠금 (L648~660 — 금년 이후 컬럼만 unlock) ──
  if (tag.year < cutoff.thisYear) return { editable: false, isPast };

  // ── R4' 버킷축별 유효구간 (2026-07-21 G1 교정 — 신정본 EditButton L582~637 / InsertRow L1406~1461 1:1) ──
  //   R2 통과 후이므로 tag.kind === 활성 버킷 축.
  //   M_  : 40+유효창(비공란)일 때만 구간 밖 잠금 — else 없음 = 비40/무효창 전면 개방 (L588 if only).
  //   Q_/Y_: "40 && VALID_YN=='Y' && start/end 비공란 && 구간 내" 에서만 개방 — 그 외 무조건 잠금
  //          (L612~615 / L632~635 else LockColumn — 81/82 는 커서2 0행이라 항상 else = 잠금).
  //   비교: M=6자/Q='yyyyq' 5자/Y=4자 고정폭 문자열 = 수치 비교와 동치.
  if (tag.kind === 'M') {
    if (isDiv40(divisionId) && window?.validYn && window.startYyyymm && window.endYyyymm) {
      const ym = binding.slice(2);
      if (ym < window.startYyyymm || ym > window.endYyyymm) return { editable: false, isPast };
    }
  } else {
    const start = tag.kind === 'Q' ? window?.startYyyyqq : window?.startYyyy;
    const end = tag.kind === 'Q' ? window?.endYyyyqq : window?.endYyyy;
    if (!isDiv40(divisionId) || !window?.validYn || !start || !end) {
      return { editable: false, isPast };
    }
    const v = tag.kind === 'Q' ? `${tag.year}${tag.quarter}` : String(tag.year);
    if (v < start || v > end) return { editable: false, isPast };
  }

  return { editable: true, isPast };
};

// ============================================================================
// ⭐ R5 — Insert 행 정적 컬럼 화이트리스트 (AS-IS InsertRow L1218~1409 메타 전량 잠금 붕괴 —
//   아래 개방 컬럼 외 전부 자동 read-only. division별 콤보/팝업 바인딩 L1175~1214 대응).
//   팝업 셀(PROJECT_CODE/PROJECT_CODE82/ITEM_ID/ITEM_ID40)은 직접 입력 차단 — dblclick 모달 전용.
// ============================================================================
export const insertStaticEditable = (
  binding: string,
  row: BusinessPlanRow,
  divisionId: string
): boolean => {
  const d40 = isDiv40(divisionId);
  const d81 = isDiv81(divisionId);
  const d82 = isDiv82(divisionId);
  void row;
  switch (binding) {
    case 'DEPT_ID':
      return !d40; // 81·82 콤보 (L1195)
    case 'DEPT_ID40':
      return d40; // 40 콤보 (L1193)
    case 'END_CUSTOMER':
      return !d40;
    case 'END_CUSTOMER40':
      return d40; // 40 콤보 (EndCustomerByDivision40)
    case 'SCM_SITE_ID40':
      return d40;
    case 'SCM_SITE_ID81':
      return d81;
    case 'SCM_SITE_ID82':
      return d82;
    case 'INCOTERMS':
      return !d82; // 40·81 (IncotermsEdit 콤보)
    case 'INCOTERMS82':
      return d82;
    case 'FCST_TYPE':
      return !d82; // DM_LOOKUP_DIV 콤보 (82 는 FCST_TYPE 미사용 — SaveData 공란 ' ')
    case 'CELL_PROD_SITE':
      return d40; // [C20220513-000327] 40 전용 콤보 (L1213)
    case 'PLANT_SITE_ID':
      return d81; // 81 만 개방 (L1259 — 81 아니면 lock)
    case 'UNIT_ENERGY':
      return d82; // 82 에너지 원단위 (직접 입력)
    case 'ITEM_USE':
      return d82;
    case 'CURRENCY':
      return true; // CURRENCY_LIST 콤보 (L1184)
    default:
      return false; // 메타/파생 컬럼 전부 read-only (R5 붕괴 규칙. MEASURE 는 블록 삽입 고정 — 잠금)
  }
};

// (구 R6 existingRowStaticEditable 삭제 — 2026-07-21 G2 교정)
//   신정본 base EditButton L651~667: "Business Plan 일 경우만 Incoterms 등의 컬럼을 열어준다" 블록이
//   17행 전체 주석(비활성)이고 L649 LockRange(정적 영역 전량 잠금)만 활성 —
//   기존행 INCOTERMS/FCST_TYPE 은 예외 없이 잠금이 파리티. (구정본 _1 의 활성 블록을 승계했던 오류 제거.)
//   ⚠ 파리티 수용 리스크: 40 기존행 INCO/FCST 공란이면 수량 수정 후 저장 시 필수값 alert(MSG00429)
//   dead-end — AS-IS(MSG00310) 동일 동작.
