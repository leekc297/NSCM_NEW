// SCP0013 그리드 편집잠금 white-list + 컬럼 가시성 + Fix/Unfix/New enable (design 01 §2 / 03 §2.4/§3).
//   순수 함수 — 조회직후 grid 전체 readOnly, Edit 판정으로 pivot 셀별 해제(beginningEdit).
//   편집 트리거는 행 measure(PROD_PLAN_AMEND) + bucket + 서버 is_editable(GET_PLAN_EDIT_INFO) 종합.

import {
  BUCKET_TYPE,
  CELL_OP_ONLY_COLUMNS,
  DIVISION_CELL_TYPE,
  DIVISION_EE_PREFIX,
  EDITABLE_MEASURE,
  EE_ELECTRODE_ONLY_COLUMNS,
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

// ===== EDIT_INFO(GET_PLAN_EDIT_INFO) 행별 편집판정 원천 (M4c — design 01 F2 / 03 §3 파생 cs:688~782) =====
//   서버 is_editable 는 메인 GET O_RC1 이 아니라 전용 SP(editInfo/SEARCH)가 CP_KEY 로 반환한다
//   (O_RC1 은 IS_EDITABLE 미반환 — ora.py 2026-10-03 PKG body 실측). 페이지가 CP_KEY→엔트리 맵을 만들어 주입.
export interface EditInfoEntry {
  isEditable: string; // Y/N (MA+confirm+날짜 / SE+날짜 / PR+날짜 → Y, else N)
  newEditMode: string; // SP 리터럴 'Y' 고정 — 비소비
  editStartDate: string; // YYYYMMDD
}
export type EditInfoMap = Map<string, EditInfoEntry>;

// fix 셀 매칭키 = 8필드 concat (AS-IS Set_FixCellColor cs:3592~3598, O_RC2 와 동일 필드).
//   origin_division_id/electrode_type 는 O_RC2 가 NVL '-' 하므로 그리드행도 공백→'-' 로 정규화해 매칭.
export const buildFixKey = (row: Record<string, unknown>): string => {
  const dash = (k: string): string => {
    const v = s(row[k]);
    return v === '' ? '-' : v;
  };
  return (
    s(row.DIVISION_ID) +
    s(row.OPERATION_GROUP) +
    s(row.SCM_SITE_ID) +
    s(row.ITEM_ID) +
    s(row.LINE_ID) +
    s(row.OPERATION_ID) +
    dash('ORIGIN_DIVISION_ID') +
    dash('ELECTRODE_TYPE')
  );
};

// ===== 행 편집가능 판정 (design 01 F2 — 서버 is_editable + 화면 3규칙 순차) =====
//   (a) 마지막 PlanType 아니면 N / (b) FN 존재하면 N / (d) PlanType=='TE' 면 N.
//   서버 is_editable(editInfo CP_KEY 조인) 기반 + 화면 규칙 override. context 는 조회결과 전체에서 파생.
export interface EditContext {
  lastPlanType: string; // 조회결과의 최종 PlanType
  hasFn: boolean; // 조회결과에 PlanType='FN' 존재
}
export const isRowEditable = (row: Row, ctx: EditContext, editInfo: EditInfoMap): boolean => {
  if (s(row.MEASURE) !== EDITABLE_MEASURE) return false; // PROD_PLAN_AMEND 행만
  const info = editInfo.get(s(row.CP_KEY));
  if (!info) return false; // EDIT_INFO 미반환 버전 = 편집불가(서버 is_editable 원천 없음)
  let editable = info.isEditable === 'Y'; // 서버 base (GET_PLAN_EDIT_INFO, CP_KEY 조인)
  const planType = s(row.PLAN_TYPE);
  if (ctx.lastPlanType && planType !== ctx.lastPlanType) editable = false; // (a)
  if (ctx.hasFn) editable = false; // (b)
  // (c) new_edit_mode: AS-IS 는 '플랜 실행오류 재편집' 예외(new_edit_mode='Y'→허용)지만, TO-BE SP 가
  //   NEW_EDIT_MODE 를 리터럴 'Y' 로 고정 반환(PKG body LINE 862, ora.py 2026-10-03)해 그대로 적용하면
  //   IS_EDITABLE 게이트가 전부 무력화된다 → 상수 'Y' 는 비소비하고 IS_EDITABLE 을 유지한다(04_react-gap 정직보고).
  if (planType === 'TE') editable = false; // (d)
  return editable;
};

// pivot 셀 편집 판정 — measure(AMEND) + bucket 편집 kind + 과거 아님 + 행 편집가능 (design 03 §3 #4).
export const isPivotCellEditable = (
  binding: string,
  row: Row,
  bucket: BUCKET_TYPE,
  ctx: EditContext,
  cutoffYmd: string,
  editInfo: EditInfoMap
): boolean => {
  if (!isPivotColumn(binding)) return false; // 고정 컬럼은 전건 잠금(INPUT_TP_CD='S')
  if (pivotKind(binding) !== editablePivotKindForBucket(bucket)) return false; // SUM 컬럼 잠금
  // 편집시작 = max(cutoff, 서버 EDIT_START_DATE) — design 03 §3.6 #33 (L8). editInfo 가 CP_KEY 별
  //   서버 편집시작일을 주면 그 이전 셀은 잠근다(항상 더 보수적). 빈 값이면 cutoff(이번 주 월요일) 유지.
  const editStartDate = editInfo.get(s(row.CP_KEY))?.editStartDate ?? '';
  const effectiveCutoff = editStartDate > cutoffYmd ? editStartDate : cutoffYmd;
  if (isPastPivot(binding, effectiveCutoff)) return false; // 과거/편집시작 전 기간
  return isRowEditable(row, ctx, editInfo);
};

// ===== 고정 컬럼 조건 가시성 (design 03 §1 VISIBLE 열 / cs:339~370) =====
//   division 기반 가시성(EE 계열 전용 / div=40 전용)은 SCM_MST_SHEET_COLUMNS.DIVISION_ID 로 데이터화
//   되어 서버(PR_GET_SHEET_COLUMN_LIST)가 현재 division 에 맞는 컬럼만 반환한다(하드코딩 제거).
//   이 함수는 그 테이블에 축이 없는 opGroup 조건만 처리한다:
//     - CELL_ID/UNIT: Operation Group=Electrode 전용 (EE 계열 조건은 DIVISION_ID 서버 필터가 담당)
//   MODEL_ID 는 제외 — AS-IS SetColumnModelVisible(opGroup A/P 토글)이 cs:373 주석 처리로 미호출되는
//   dead code 라 opGroup 게이트를 적용하지 않는다(Model 은 div 40·81·82 서버 메타대로 항상 표시).
export interface VisibilityContext {
  division: string;
  operationGroup: string;
}
export const isFixedColumnVisible = (colName: string, ctx: VisibilityContext): boolean => {
  const opE = ctx.operationGroup === OP_GROUP_ELECTRODE;
  const opCell = ctx.operationGroup === OP_GROUP_CELL;
  if ((EE_ELECTRODE_ONLY_COLUMNS as readonly string[]).includes(colName)) return opE;
  if ((CELL_OP_ONLY_COLUMNS as readonly string[]).includes(colName)) return opCell;
  return true; // 그 외 컬럼은 기본 가시성 유지(division 필터는 서버 DIVISION_ID 가 담당)
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
