import dayjs from '@foundation/dayjs';

import { EDIT_AUTH_GROUP, REQUEST_CHK_BINDING, REQUEST_CHK_LOSS_CODES } from '../capa.constants';
import type { CapaRow } from '../capa.types';

/**
 * 편집 판정 컨텍스트 — Version 상태·세션 사용자·권한 그룹·LANE_QTY 후보 수.
 * EDIT 모드 토글은 미이식(convert-core §2.4, asis_to_tobe §11): editMode state 없이 아래 종합식만 사용.
 */
export interface EditContext {
  isCurrentVersion: boolean; // bRealFlag 등가 — Version='Current' 선택 시에만 편집 전제 성립
  userId: string;
  groupId: string;
  /** 행 LANE_QTY 셀 콤보 후보 수(>0 이어야 개방). 미배선 시 0. */
  laneQtyCandidateCountOf: (row: CapaRow) => number;
}

const USER_ID_KEYS = [
  'USER_ID_1',
  'USER_ID_2',
  'USER_ID_3',
  'USER_ID_4',
  'USER_ID_5',
  'USER_ID_6',
  'USER_ID_7',
  'USER_ID_8',
  'USER_ID_9',
  'USER_ID_10',
] as const;

/** 행 담당자 권한 — 그룹이 SCM PI Admin 이거나 사용자가 USER_ID_1~10 에 포함(cs:568-572). */
export const hasRowEditAuth = (row: CapaRow, ctx: EditContext): boolean => {
  if (ctx.groupId === EDIT_AUTH_GROUP) return true;
  const uid = ctx.userId.trim();
  if (uid === '') return false;
  return USER_ID_KEYS.some(k => String(row[k] ?? '').trim() === uid);
};

const kindOfPeriod = (binding: string): 'D' | 'M' | 'Y' | null =>
  /^D_\d{8}$/.test(binding) ? 'D' : /^M_\d{6}$/.test(binding) ? 'M' : /^Y_\d{4}$/.test(binding) ? 'Y' : null;

/**
 * 기간칼럼 편집 판정(§3 L7~L10) — 행 DATA_TABLE 별 경계.
 *   WORK_CALENDAR 행: M_ ≥ 당월+4 · D_ ≥ 당일 · Y_ 개방
 *   LOSS(SCM_LOSS_M) 행: M_·Y_ 만(D_ 불가 — L10)
 *   그 외(LINE ASSIGN·TACT·YIELD): 전 기간 개방
 */
const isPeriodCellEditable = (row: CapaRow, binding: string, today: dayjs.Dayjs): boolean => {
  const kind = kindOfPeriod(binding);
  if (!kind) return false;
  const dataTable = String(row.DATA_TABLE ?? '');
  if (dataTable === 'SCM_WORK_CALENDAR_M') {
    if (kind === 'Y') return true;
    if (kind === 'M') return binding.slice(2, 8) >= today.add(4, 'month').format('YYYYMM');
    return binding.slice(2) >= today.format('YYYYMMDD'); // D_ ≥ 당일
  }
  if (dataTable === 'SCM_LOSS_M') return kind !== 'D'; // LOSS 행은 D_ 불가
  return true; // LINE ASSIGN / TACT / YIELD 행 — 전 기간
};

/** BEF 실적 영역(조회 전용) — 편집 차단(§3 종합식 주석 · §5-3). */
const isBefColumn = (binding: string): boolean => binding.startsWith('BEF_');

/**
 * 셀 편집 허용 종합식(03 §3 — beginningEdit / formatItem 공용).
 * INPUT_TP_CD 는 전 컬럼 'S' 라 메타 단독 판정 불가(hook #130) — 이 함수가 행×셀 실시간 판정.
 */
export const isCellEditable = (row: CapaRow, binding: string, ctx: EditContext): boolean => {
  // 전제 3종: bRealFlag(Current) ∧ EDITORBLE_YN='Y' ∧ LOSS_CODE≠'LA999'.
  if (!ctx.isCurrentVersion) return false;
  if (String(row.EDITORBLE_YN ?? '') !== 'Y') return false;
  if (String(row.LOSS_CODE ?? '') === 'LA999') return false;

  // REQUEST_CHK — LA001/LA002/LA003 행만(권한 무관, cs:563-566).
  if (binding === REQUEST_CHK_BINDING) {
    return (REQUEST_CHK_LOSS_CODES as readonly string[]).includes(String(row.LOSS_CODE ?? ''));
  }

  if (isBefColumn(binding)) return false;

  // 이하 권한 행에서만 개방.
  if (!hasRowEditAuth(row, ctx)) return false;

  if (binding === 'CONFIRM_FLAG') return String(row.ROW_RANKING ?? '') === '1';
  if (binding === 'LANE_QTY') {
    return String(row.CATEGORY_ID ?? '') === 'LINE ASSIGN' && ctx.laneQtyCandidateCountOf(row) > 0;
  }
  return isPeriodCellEditable(row, binding, dayjs());
};
