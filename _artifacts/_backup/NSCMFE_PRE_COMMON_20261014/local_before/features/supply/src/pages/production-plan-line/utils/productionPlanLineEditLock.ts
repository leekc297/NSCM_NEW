// SCP0013 그리드 편집잠금 white-list + 컬럼 가시성 + Fix/Unfix/New enable (design 01 §2 / 03 §2.4/§3).
//   순수 함수 — 조회직후 grid 전체 readOnly, Edit 판정으로 pivot 셀별 해제(beginningEdit).
//   편집 트리거는 행 measure(PROD_PLAN_AMEND) + bucket + 서버 is_editable(GET_PLAN_EDIT_INFO) 종합.

import {
  BUCKET_TYPE,
  CELL_OP_ONLY_COLUMNS,
  DIV40_ONLY_COLUMNS,
  DIVISION_CELL_TYPE,
  DIVISION_EE_PREFIX,
  EDITABLE_MEASURE,
  EE_ELECTRODE_ONLY_COLUMNS,
  EE_ONLY_COLUMNS,
  OP_GROUP_CELL,
  OP_GROUP_ELECTRODE,
  PLAN_TYPE_EXCLUDE_FIX,
} from '../production-plan-line.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// division EE 여부 — 앞2자 'EE'(EE·EE_UC 포함, design 01 B3 Substring(0,2)).
export const isEeDivision = (division: string): boolean =>
  division.slice(0, 2).toUpperCase() === DIVISION_EE_PREFIX;

// ===== pivot 컬럼 분류 (D_/W_/M_/B_) =====
export type PivotKind = 'D' | 'W' | 'M' | 'B' | null;
export const pivotKind = (binding: string): PivotKind => {
  if (/^D_/.test(binding)) return 'D';
  if (/^W_/.test(binding)) return 'W';
  if (/^M_/.test(binding)) return 'M';
  if (/^B_/.test(binding)) return 'B'; // 숨김 보조 컬럼 (design 03 §2.2 cs:408)
  return null;
};
export const isPivotColumn = (binding: string): boolean => pivotKind(binding) !== null;

// ===== bucket × chkSum → pivot 가시성 (design 03 §2.4 표) =====
//   Daily : D_ 표시 / W_·M_ = chkSum
//   Weekly: W_ 표시 / M_ = chkSum / D_ 숨김
//   Monthly: M_ 표시 / D_·W_ 숨김
export const isPivotVisible = (binding: string, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  const kind = pivotKind(binding);
  if (kind === 'B' || kind === null) return false; // B_ 는 항상 숨김
  if (bucket === BUCKET_TYPE.DAILY) {
    if (kind === 'D') return true;
    return chkSum; // W_/M_
  }
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return chkSum; // M_
  }
  // Monthly
  return kind === 'M';
};

// bucket 별 사용자 편집 가능한 pivot kind — SUM 컬럼은 항상 잠금(design 01 F3 / 03 §3 #5/#6).
//   Daily→D_ 편집(W_/M_ SUM 잠금) · Weekly→W_ 편집(M_ SUM 잠금) · Monthly→M_ 편집.
export const editablePivotKindForBucket = (bucket: BUCKET_TYPE): PivotKind => {
  if (bucket === BUCKET_TYPE.DAILY) return 'D';
  if (bucket === BUCKET_TYPE.WEEKLY) return 'W';
  return 'M';
};

// ===== 과거 기간 pivot 잠금 (design 01 F2 startEditIdx / 03 §3 #4) =====
//   cutoff = 이번 주 월요일. tag < cutoff 이면 과거(편집불가). D_=8자리 날짜, W_/M_=앞 6자리 yyyymm.
export const thisWeekMonday = (base: Date = new Date()): string => {
  const d = new Date(base);
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() + (1 - d.getDay())); // 일=0 → 이번 주 월요일
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
};

export const isPastPivot = (binding: string, cutoffYmd: string): boolean => {
  const kind = pivotKind(binding);
  if (kind === null || kind === 'B') return false;
  const tag = binding.slice(2).replace(/[^0-9]/g, '');
  if (kind === 'D') return tag.slice(0, 8) < cutoffYmd.slice(0, 8);
  return tag.slice(0, 6) < cutoffYmd.slice(0, 6); // W_/M_ 은 월 단위 비교
};

// ===== 행 편집가능 판정 (design 01 F2 — 서버 is_editable + 화면 4규칙 순차) =====
//   (a) 마지막 PlanType 아니면 N / (b) FN 존재하면 N / (c) new_edit_mode=='Y' 면 Y / (d) PlanType=='TE' 면 N.
//   서버 is_editable 기반 + 화면 규칙 override. context 는 조회결과 전체에서 파생(그리드가 계산).
export interface EditContext {
  lastPlanType: string; // 조회결과의 최종 PlanType
  hasFn: boolean; // 조회결과에 PlanType='FN' 존재
}
export const isRowEditable = (row: Row, ctx: EditContext): boolean => {
  if (s(row.MEASURE) !== EDITABLE_MEASURE) return false; // PROD_PLAN_AMEND 행만
  const planType = s(row.PLAN_TYPE);
  let editable = s(row.IS_EDITABLE) === 'Y'; // 서버 base
  if (ctx.lastPlanType && planType !== ctx.lastPlanType) editable = false; // (a)
  if (ctx.hasFn) editable = false; // (b)
  if (s(row.NEW_EDIT_MODE) === 'Y') editable = true; // (c)
  if (planType === 'TE') editable = false; // (d)
  return editable;
};

// pivot 셀 편집 판정 — measure(AMEND) + bucket 편집 kind + 과거 아님 + 행 편집가능 (design 03 §3 #4).
export const isPivotCellEditable = (
  binding: string,
  row: Row,
  bucket: BUCKET_TYPE,
  ctx: EditContext,
  cutoffYmd: string
): boolean => {
  if (!isPivotColumn(binding)) return false; // 고정 컬럼은 전건 잠금(INPUT_TP_CD='S')
  if (pivotKind(binding) !== editablePivotKindForBucket(bucket)) return false; // SUM 컬럼 잠금
  if (isPastPivot(binding, cutoffYmd)) return false; // 과거 기간
  return isRowEditable(row, ctx);
};

// ===== 고정 컬럼 조건 가시성 (design 03 §1 VISIBLE 열 / cs:339~370) =====
//   EE div 만 / div=40 만 / EE+OpGr=E 만 / OpGr=A(Cell) 만 표시. 그 외 division/opGroup 은 숨김.
export interface VisibilityContext {
  division: string;
  operationGroup: string;
}
export const isFixedColumnVisible = (colName: string, ctx: VisibilityContext): boolean => {
  const ee = isEeDivision(ctx.division);
  const div40 = ctx.division === DIVISION_CELL_TYPE;
  const opE = ctx.operationGroup === OP_GROUP_ELECTRODE;
  const opCell = ctx.operationGroup === OP_GROUP_CELL;
  if ((EE_ONLY_COLUMNS as readonly string[]).includes(colName)) return ee;
  if ((DIV40_ONLY_COLUMNS as readonly string[]).includes(colName)) return div40;
  if ((EE_ELECTRODE_ONLY_COLUMNS as readonly string[]).includes(colName)) return ee && opE;
  if ((CELL_OP_ONLY_COLUMNS as readonly string[]).includes(colName)) return opCell;
  return true; // 그 외 컬럼은 기본 가시성 유지
};

// ===== div=40 → CellTypeGr/ExtraSpec enable (design 01 B1/B2) =====
export const isCellTypeExtraSpecEnabled = (division: string): boolean =>
  division === DIVISION_CELL_TYPE;

// ===== opGroup A/P → Electrode ALL+disable (design 01 C1/C2) =====
export const isElectrodeEnabled = (operationGroup: string): boolean =>
  operationGroup !== OP_GROUP_CELL && operationGroup !== 'P';

// ===== Fix/Unfix/New enable (design 01 D1 — 마지막 주차·SEQ·확정/임시 아닌 Plan) =====
//   조건: planDate 마지막(index0) & planType∉{FN,TE} & planSeq 마지막 & 세 값 비어있지 않음.
//   TO-BE 는 콤보 옵션 배열의 첫 항목(최신)과 선택값 비교로 판정.
export interface FixEnableContext {
  planStartYyyymmdd: string; // 선택 planDate (단일 판정 — 다중 중 대표)
  planType: string;
  planSeq: string;
  latestPlanStart: string; // planDate 옵션 첫 항목(최신) CODE
  latestPlanSeq: string; // planSeq 옵션 첫 항목(최신) CODE
}
export const canFixUnfixNew = (ctx: FixEnableContext): boolean => {
  if (!ctx.planStartYyyymmdd || !ctx.planType || !ctx.planSeq) return false;
  if (ctx.planStartYyyymmdd !== ctx.latestPlanStart) return false; // 마지막 주차
  if (ctx.planSeq !== ctx.latestPlanSeq) return false; // 마지막 SEQ
  if ((PLAN_TYPE_EXCLUDE_FIX as readonly string[]).includes(ctx.planType)) return false; // FN/TE 제외
  return true;
};
