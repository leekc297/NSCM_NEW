// SCP0011 그리드 편집잠금 + pivot 가시성 + EE 분기 (design 01 R2 / 03 §2.5/§3). 자매 SCP0013 editLock 이식.
//   순수 함수 — 조회직후 grid 전체 readOnly, 셀단위 판정(beginningEdit)으로 편집가능 pivot 셀만 해제.
//   편집 트리거 = 행 measure(PROD_PLAN_AMEND) + bucket 편집 kind + 과거 아님 + 서버 is_editable(EDIT_INFO).

import {
  BUCKET_TYPE,
  DIVISION_EE_PREFIX,
  EDITABLE_MEASURE,
  PLAN_TYPE_EXCLUDE_EDIT,
} from '../production-plan.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// division EE 여부 — 앞2자 'EE'(design 02 §5.2 Substring(0,2)).
export const isEeDivision = (division: string): boolean =>
  division.slice(0, 2).toUpperCase() === DIVISION_EE_PREFIX;

// Electrode enable — EE 사업부만(design 02 §4.3). 비EE 는 값 clear + disable.
export const isElectrodeEnabled = (division: string): boolean => isEeDivision(division);

// Item 팝업 division — AS-IS UIUtils.GetAllDivisionCheckedElectrode(cboDivision) 재현(design 02 §4.6).
//   메서드명은 전극과 무관하다(AS-IS 소스 GSCM/06.UIL/GSCM.Utils/UIUtils.cs L150~172 실측):
//   선택 division 이 'EE' 로 시작하면 cboDivision 목록의 실제 사업부 CODE 중 끝 2자가 'UC' 아니고
//   앞 2자가 'EE' 아닌 것만 콤마로 이어 반환(GetAllDivisionsExceptUCEE, L34~54). 그 외는 선택값 그대로.
//   allDivisionCodes = cboDivision 옵션 CODE 전체(권한 반영 목록). Item 후보를 AS-IS 와 같게 맞춘다.
export const divisionForItemPopup = (division: string, allDivisionCodes: readonly string[]): string => {
  if (!isEeDivision(division)) return division;
  const expanded = allDivisionCodes.filter(
    c => c.length >= 2 && c.slice(-2) !== 'UC' && c.slice(0, 2).toUpperCase() !== 'EE'
  );
  return expanded.join(',');
};

// ===== pivot 컬럼 분류 (D_/W_/M_/B_) =====
export type PivotKind = 'D' | 'W' | 'M' | 'B' | null;
export const pivotKind = (binding: string): PivotKind => {
  if (/^D_/.test(binding)) return 'D';
  if (/^W_/.test(binding)) return 'W';
  if (/^M_/.test(binding)) return 'M';
  if (/^B_/.test(binding)) return 'B'; // TO-BE 캘린더 SP 미반환(design 03 §2.1 — 死 분기)
  return null;
};
export const isPivotColumn = (binding: string): boolean => pivotKind(binding) !== null;

// ===== bucket × chkSum → pivot 가시성 (design 03 §2.3 표) =====
//   Daily : D_ 표시 / W_·M_ = chkSum
//   Weekly: W_ 표시 / M_ = chkSum / D_ 숨김
//   Monthly: M_ 표시 / D_·W_ 숨김
export const isPivotVisible = (binding: string, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  const kind = pivotKind(binding);
  if (kind === 'B' || kind === null) return false;
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return chkSum; // M_
  }
  return kind === 'M'; // Monthly
};

// 편집 가능 pivot kind — SCP0011 은 자매 SCP0013 과 달리 D_ 전용 편집이다.
//   design 03 §2.5 열 조건: "D_ 열 중 max(from, edit_start_date) 이상 ~ 끝까지만 unlock. 그 앞 D_ 와
//   모든 W_/M_ 은 잠금" + §3 R8 "SUM 열은 항상 읽기전용"(AS-IS EditButton L703-725 가 D_ 열만 해제).
//   → bucket 과 무관하게 편집 가능한 kind 는 'D' 뿐. Weekly/Monthly 뷰에서는 D_ 가 숨겨지므로 편집하려면
//   Daily 로 전환해야 한다(M3 해소 — 이전 회차는 bucket leaf(W_/M_)를 편집 허용해 R8/§2.5 와 어긋났다).
export const editablePivotKindForBucket = (_bucket: BUCKET_TYPE): PivotKind => 'D';

// ===== 과거 기간 pivot 잠금 (design 03 §2.5 — edit_start_date 이전 잠금) =====
//   cutoff = 이번 주 월요일. D_=8자리 날짜, W_/M_=앞 6자리 yyyymm.
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
  return tag.slice(0, 6) < cutoffYmd.slice(0, 6);
};

// ===== EDIT_INFO(P_SCP0011_GET_PLAN_EDIT_INFO) 편집판정 컨텍스트 (design 03 §2.5 / 01 R2-e) =====
//   DB 실측(gap-resolve iter-1, ora.py PKG_SCP0011 body): 이 SP 는 CP_KEY 를 반환하지 않는다. 선택
//   plan version(division+planType+seq+planName)으로 필터해 0/1행 단일 편집컨텍스트를 돌려준다 — 반환
//   컬럼은 EDIT_START_DATE·IS_EDITABLE('Y' 상수)·DATE_CHK·PLAN_TYPE_ORDER 등. 그래서 그리드행 조인
//   키(CP_KEY)가 아니라 그리드 전체에 적용되는 단일 컨텍스트로 쓴다(이전 CP_KEY 맵은 항상 비어 편집
//   死였음 — gap-resolve CS2 해소). 편집창은 editStartDate(이 날짜 이상 D_ 셀)로 좁힌다.
export interface EditInfoEntry {
  isEditable: string; // Y/N (서버 판정 — 현재 SP 는 'Y' 상수, 실제 편집창은 editStartDate 로 좁힘)
  editStartDate: string; // YYYYMMDD (편집 시작일)
}

// ===== 행 편집가능 판정 (design 03 §2.5 — 서버 is_editable + 화면 PlanType 규칙) =====
//   measure=PROD_PLAN_AMEND 행만. (a)마지막 PlanType 아님 N / (b)FN 존재 N / (c)PlanType=TE N.
export interface EditContext {
  canEdit: boolean; // mount 시 hasButton('SAVE') 1회 (editMode state 금지 — convert-core §2.4)
  lastPlanType: string; // 조회결과의 최종 PlanType
  hasFn: boolean; // 조회결과에 PlanType='FN' 존재
}
export const isRowEditable = (row: Row, ctx: EditContext, editInfo: EditInfoEntry | null): boolean => {
  if (!ctx.canEdit) return false; // 편집 권한 없음
  if (s(row.MEASURE) !== EDITABLE_MEASURE) return false; // PROD_PLAN_AMEND 행만
  if (!editInfo) return false; // EDIT_INFO 미반환 = 편집불가(서버 편집컨텍스트 원천 없음, 안전측)
  let editable = editInfo.isEditable === 'Y';
  const planType = s(row.PLAN_TYPE);
  if (ctx.lastPlanType && planType !== ctx.lastPlanType) editable = false; // (a)
  if (ctx.hasFn) editable = false; // (b)
  if ((PLAN_TYPE_EXCLUDE_EDIT as readonly string[]).includes(planType)) editable = false; // (c) FN/TE
  return editable;
};

// pivot 셀 편집 판정 — measure(AMEND) + bucket 편집 kind + 과거 아님(edit_start_date) + 행 편집가능.
export const isPivotCellEditable = (
  binding: string,
  row: Row,
  bucket: BUCKET_TYPE,
  ctx: EditContext,
  cutoffYmd: string,
  editInfo: EditInfoEntry | null
): boolean => {
  if (!isPivotColumn(binding)) return false; // 고정 컬럼 전건 잠금(INPUT_TP_CD='S')
  if (pivotKind(binding) !== editablePivotKindForBucket(bucket)) return false; // SUM 컬럼 잠금
  // 편집시작 = max(cutoff, 서버 EDIT_START_DATE) — 둘 중 보수적. (design 03 §2.5 / 01 R2-e)
  const editStartDate = editInfo?.editStartDate ?? '';
  const effectiveCutoff = editStartDate > cutoffYmd ? editStartDate : cutoffYmd;
  if (isPastPivot(binding, effectiveCutoff)) return false;
  return isRowEditable(row, ctx, editInfo);
};

// ===== EE 전용 고정컬럼 가시성 (design 03 §3 R2 — ORIGIN_DIVISION_ID/ELECTRODE_TYPE 는 EE 사업부만) =====
export const isFixedColumnVisible = (eeOnly: boolean | undefined, division: string): boolean =>
  eeOnly ? isEeDivision(division) : true;

// ===== 조회결과에서 편집 컨텍스트 파생 (design 01 R2 / 03 §2.5) =====
export const deriveEditContext = (rows: Row[], canEdit: boolean): EditContext => {
  let lastPlanType = '';
  let hasFn = false;
  for (const r of rows) {
    const pt = s(r.PLAN_TYPE);
    if (pt) lastPlanType = pt;
    if (pt === 'FN') hasFn = true;
  }
  return { canEdit, lastPlanType, hasFn };
};
