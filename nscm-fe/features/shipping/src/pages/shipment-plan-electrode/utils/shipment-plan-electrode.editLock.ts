// 편집 잠금 판정 (design 03 §3.1) — formatItem(색)·beginningEdit(e.cancel)·pastingCell 공통 사용.
//   DB SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 전건 'S'(갭#5)라 코드 화이트리스트로 재현 —
//   admin 메타 정비 시 메타(INPUT_TP_CD) 기준으로 전환한다(03 §6-5).

import {
  MAIN_EDITABLE_MEASURE,
  PLAN_DETAIL_EDITABLE_COLUMNS,
  RADIO_SPAN_PREFIX,
  SHEETS,
  type BOH_RADIO,
  type BUCKET_TYPE,
} from '../shipment-plan-electrode.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const PLAN_DETAIL_SET = new Set<string>(PLAN_DETAIL_EDITABLE_COLUMNS);

// 동적 기간칼럼 tag 해체 — [X_|Y_|Z_][D_|W_|M_]yyyyMMdd (03 §2.2).
//   SSP0060(2단 D_/W_/M_)과 달리 span prefix(X_/Y_/Z_)를 먼저 벗겨야 bucket 을 읽을 수 있다.
export type DynSpan = 'X' | 'Y' | 'Z';
export type DynBucket = 'D' | 'W' | 'M';

export interface DynTag {
  span: DynSpan;
  bucket: DynBucket;
  ymd: string; // yyyyMMdd
}

// span+bucket prefix 를 해체. 동적 기간칼럼이 아니면 undefined.
export const parseDynTag = (binding: string): DynTag | undefined => {
  const m = /^([XYZ])_([DWM])_(\d{8})$/.exec(binding);
  if (!m) return undefined;
  return { span: m[1] as DynSpan, bucket: m[2] as DynBucket, ymd: m[3] };
};

// bucket prefix 만 필요할 때 (표시규칙 판정) — span 무관.
export const bucketOf = (binding: string): DynBucket | undefined => parseDynTag(binding)?.bucket;

// 활성 radio → span prefix 문자('X'/'Y'/'Z').
export const activeSpanOf = (radio: BOH_RADIO): DynSpan =>
  RADIO_SPAN_PREFIX[radio].charAt(0) as DynSpan;

/**
 * 동적 기간칼럼 표시 여부 (design 03 §2.2 표):
 *   - 활성 radio(rdButton1/2/3)의 span(X_/Y_/Z_)만 노출, 나머지 span 은 전부 숨김.
 *   - 활성 span 안에서 bucket 표시규칙:
 *       DAILY   : D_ 노출 / W_ chkSum / M_ chkSum
 *       WEEKLY  : D_ 숨김 / W_ 노출   / M_ chkSum
 *       MONTHLY : D_ 숨김 / W_ 숨김   / M_ 노출(chkSum 무관)
 *   - chkPastPeriod = true 이면 tag-date < planDate 인 D_/W_ 는 숨김(SUM/M_ 제외) — 페이지에서 별도 결합.
 */
export const isDynVisible = (
  tag: DynTag,
  activeSpan: DynSpan,
  bucket: BUCKET_TYPE,
  chkSum: boolean
): boolean => {
  if (tag.span !== activeSpan) return false;
  // BUCKET_TYPE enum 값이 완전어('DAILY'/'WEEKLY'/'MONTHLY')라 문자 비교로 판정.
  const b = str(bucket);
  if (b === 'DAILY') return tag.bucket === 'D' ? true : chkSum;
  if (b === 'WEEKLY') return tag.bucket === 'D' ? false : tag.bucket === 'W' ? true : chkSum;
  return tag.bucket === 'M'; // MONTHLY
};

/**
 * Main 셀 편집 가능 판정 (03 §3.1):
 *   canEdit(편집계 권한 · 최신Plan realFlag) + MEASURE=='P_SHIP_PLAN_SIMU_ETD' +
 *   활성 span 의 D_ 컬럼(비-SUM) + curPlanDate <= 일자 <= CONFIRM_DAY 창.
 *   W_/M_(Sum) 컬럼과 비활성 span 은 항상 잠금(03 §2.2).
 *   canEdit = hasButton('INSERT') || hasButton('SAVE') — AS-IS EditButton 은 SwitchLock 잠금토글이라 EDIT 미이식,
 *   EDIT 은 권한 미등록이므로 등록된 편집계 권한으로 게이트(convert-core §2.4 · SCP0048 선례).
 */
export const isMainCellEditable = (
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean,
  activeSpan: DynSpan,
  curPlanDate: string
): boolean => {
  if (!canEdit || !row) return false;
  const tag = parseDynTag(binding);
  if (!tag) return false;
  if (tag.span !== activeSpan) return false;
  if (tag.bucket !== 'D') return false; // W_/M_(Sum) 항상 잠금
  if (str(row.MEASURE) !== MAIN_EDITABLE_MEASURE) return false;
  const confirmDay = str(row.CONFIRM_DAY);
  if (curPlanDate && tag.ymd < curPlanDate) return false;
  if (confirmDay && tag.ymd > confirmDay) return false;
  return true;
};

/**
 * Detail 셀 편집 가능 판정 (03 §3.1):
 *   - Shipment Plan Detail: (canEdit + SHIPMENT_STATUS=='C' && ERP_STATUS!='C') 또는 신규행(CRUD_TYPE='I') +
 *     화이트리스트 컬럼. 신규행은 canEdit·상태 무관 화이트리스트 편집(03 §3.2 InsertRow).
 *   - Stock Detail / Shipment Result / Excel: 전면 read-only.
 *   canEdit = hasButton('INSERT') || hasButton('SAVE') — EDIT 권한 미등록이라 등록된 편집계 권한으로 게이트
 *   (AS-IS EditButton=SwitchLock 잠금토글 미이식, convert-core §2.4 · SCP0048 선례).
 */
export const isDetailCellEditable = (
  sheet: SHEETS,
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean
): boolean => {
  if (!row) return false;
  if (sheet !== SHEETS.PLAN_DETAIL) return false;
  if (!PLAN_DETAIL_SET.has(binding)) return false;
  // 신규행 판정은 공통 CRUD_TYPE 전용(core §2.4 — 자체 행상태 필드 신설 금지)
  if (str(row.CRUD_TYPE) === 'I') return true;
  if (!canEdit) return false;
  return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) !== 'C';
};
