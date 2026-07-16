// ⭐ DMF0042 — 편집/잠금 규칙 엔진 R1~R7 (expressions 103건 조건부잠금 집약 — __asis-mapping__.md 전행 대조).
//   근거(라인 = AS-IS DMF0042_1_BizPlan.cs 3,477줄 정본):
//     R1 행 게이트   : EditButton L646 — EDIT_FLAG=='Y' 행 × Measure∈{Business_Plan, LOC} 만 수량영역 unlock.
//                      (KRW/USD/SalesAmt_*/CAR_QTY/MKT_FCST = SP 파생 — 전체 잠금. InsertRow L1336 동일)
//     R2 버킷 게이트 : EditButton L556~614 — 활성 버킷 축(M_/Q_/Y_)만 편집, 나머지 축 잠금.
//     R3 금년 잠금   : L648~660 — 금년 이전 컬럼 잠금 (기준 = 금주 월요일 GetThisWeekMonday L3023 — FE 산정,
//                      조회 파라미터 p_now_yyyymmdd 와 동일 값).
//     R4 40 유효구간 : L564~614 — 40 && 커서2 VALID_YN=='Y' 시 버킷별 구간(START/END_YYYYMM·YYYYQQ·YYYY)
//                      밖 잠금. 81/82 = 커서2 NULL(lookup DM_LONG_PLAN 미등재) → 구간 게이트 미적용(파리티).
//     R5 Insert 화이트리스트: InsertRow L1218~1409 — 메타 컬럼 전량 잠금 + division별 개방 소수 컬럼만.
//     R6 Incoterms/FcstType 조건 개방: L628~642 — EDIT_FLAG=='Y' && Measure=='Business_Plan' && 40 &&
//                      Incoterms=='' && FcstType=='' 일 때만 unlock.
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

  // ── R4 40 유효구간 (L564~614 — 40 && VALID_YN='Y' 시 버킷별 구간 밖 잠금. 81/82 = window NULL 통과) ──
  if (isDiv40(divisionId) && window?.validYn) {
    if (tag.kind === 'M' && window.startYyyymm && window.endYyyymm) {
      const ym = binding.slice(2);
      if (ym < window.startYyyymm || ym > window.endYyyymm) return { editable: false, isPast };
    }
    if (tag.kind === 'Q' && window.startYyyyqq && window.endYyyyqq) {
      const qq = `${tag.year}${tag.quarter}`;
      if (qq < window.startYyyyqq || qq > window.endYyyyqq) return { editable: false, isPast };
    }
    if (tag.kind === 'Y' && window.startYyyy && window.endYyyy) {
      const y = String(tag.year);
      if (y < window.startYyyy || y > window.endYyyy) return { editable: false, isPast };
    }
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

// ⭐ R6 — 기존행 Incoterms/FcstType 조건 개방 (AS-IS EditButton L628~642 1:1):
//   EDIT_FLAG=='Y' && Measure=='Business_Plan' && 40 && 두 값 모두 공란일 때만.
export const existingRowStaticEditable = (
  binding: string,
  row: BusinessPlanRow,
  divisionId: string
): boolean => {
  if (binding !== 'INCOTERMS' && binding !== 'FCST_TYPE') return false;
  if (!isDiv40(divisionId)) return false;
  const editFlag = typeof row.EDIT_FLAG === 'string' ? row.EDIT_FLAG : '';
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  const inco = typeof row.INCOTERMS === 'string' ? row.INCOTERMS.trim() : '';
  const fcst = typeof row.FCST_TYPE === 'string' ? row.FCST_TYPE.trim() : '';
  return editFlag === 'Y' && measure === EDIT_MEASURE.BUSINESS_PLAN && inco === '' && fcst === '';
};
