// 편집 잠금 판정 (design 03 §3.1) — formatItem(색)·beginningEdit(e.cancel)·pastingCell 공통 사용.
//   DB SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 전건 'S'(갭#5)라 코드 화이트리스트로 재현 —
//   admin 메타 정비 시 메타(INPUT_TP_CD) 기준으로 전환한다(03 §6-5).

import {
  MAIN_EDITABLE_MEASURE,
  PLAN_DETAIL_EDITABLE_COLUMNS,
  PLAN_DETAIL_INSERT_EDITABLE_COLUMNS,
  RADIO_SPAN_PREFIX,
  SHEETS,
  type BOH_RADIO,
  type BUCKET_TYPE,
} from '../shipment-plan-electrode.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const PLAN_DETAIL_SET = new Set<string>(PLAN_DETAIL_EDITABLE_COLUMNS);
// 신규행은 기존행보다 좁다 — AS-IS LockRange 로 REMARKS2/REMARKS/FACTORY_ID/DOM_EXP/CHANGE_REASON*/CONFIRM_QTY_* 가 잠긴다.
const PLAN_DETAIL_INSERT_SET = new Set<string>(PLAN_DETAIL_INSERT_EDITABLE_COLUMNS);

// 동적 기간칼럼 tag 해체 — [X_|Y_|Z_][D_|W_|M_]yyyyMMdd (03 §2.2).
//   SSP0060(2단 D_/W_/M_)과 달리 span prefix(X_/Y_/Z_)를 먼저 벗겨야 bucket 을 읽을 수 있다.
export type DynSpan = 'X' | 'Y' | 'Z';
export type DynBucket = 'D' | 'W' | 'M';

export interface DynTag {
  span: DynSpan;
  bucket: DynBucket;
  ymd: string; // D_/W_ = yyyyMMdd(8) · M_ = yyyyMM(6)
}

// span+bucket prefix 를 해체. 동적 기간칼럼이 아니면 undefined.
//   주의: M_(월) 은 yyyyMM(6자리), W_/D_ 는 yyyyMMdd(8자리) — bucket 별 자리수가 다르다(CALENDAR SP 실측).
//   8자리로만 받으면 M_ 전건이 누락돼 Monthly 버킷 동적헤더가 통째로 비게 된다(ymd 비교는 전부 bucket 가드 뒤).
export const parseDynTag = (binding: string): DynTag | undefined => {
  const m = /^([XYZ])_(M_\d{6}|[DW]_\d{8})$/.exec(binding);
  if (!m) return undefined;
  const [bucket, ymd] = m[2].split('_');
  return { span: m[1] as DynSpan, bucket: bucket as DynBucket, ymd };
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
 * Main 셀 편집 가능 판정 (AS-IS EditButton cs:2136-2153):
 *   canEdit(편집계 권한 · 최신Plan realFlag) + MEASURE=='P_SHIP_PLAN_SIMU_ETD' +
 *   활성 span 의 D_ 컬럼(비-SUM) + planStart(curPlanDate) <= 일자 <= periodTo(조회 기간 종료) 창.
 *   W_/M_(Sum) 컬럼과 비활성 span 은 항상 잠금(03 §2.2).
 *   주의: 편집 상한은 periodTo(drpPeriod.Text2) 다 — CONFIRM_DAY 가 아니다. AS-IS cs:2142 는
 *     planStart 열부터 X_D_<drpPeriod.Text2> 열까지 LockRange(false)로 개방하고 CONFIRM_DAY 는
 *     배경색 범위(cs:2124)·과거일 회색(cs:2128)에만 쓴다. 설계 03 §3.1 의 'confirm_day 상한'은
 *     소스와 모순된 stale 기술이라 periodTo 로 교정(소스 정본, 2026-10-15).
 *   canEdit = hasButton('INSERT') || hasButton('SAVE') — AS-IS EditButton 은 SwitchLock 잠금토글이라 EDIT 미이식,
 *   EDIT 은 권한 미등록이므로 등록된 편집계 권한으로 게이트(convert-core §2.4 · SCP0048 선례).
 */
export const isMainCellEditable = (
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean,
  activeSpan: DynSpan,
  curPlanDate: string,
  periodTo: string
): boolean => {
  if (!canEdit || !row) return false;
  const tag = parseDynTag(binding);
  if (!tag) return false;
  if (tag.span !== activeSpan) return false;
  // AS-IS cs:2111 은 X_D_(UOM·Daily)만 편집 개방 — Cell(Y_)·Pancake(Z_) 환산 칸은 잠금
  if (tag.span !== 'X') return false;
  if (tag.bucket !== 'D') return false; // W_/M_(Sum) 항상 잠금
  if (str(row.MEASURE) !== MAIN_EDITABLE_MEASURE) return false;
  if (curPlanDate && tag.ymd < curPlanDate) return false;
  if (periodTo && tag.ymd > periodTo) return false;
  return true;
};

/**
 * Detail 셀 편집 가능 판정 (03 §3.1 · §3.2):
 *   - Shipment Plan Detail 기존행: canEdit + SHIPMENT_STATUS=='C' && ERP_STATUS!='C' + 편집 화이트리스트
 *     (PLAN_DETAIL_EDITABLE_COLUMNS 8개 — EditButton 선택적 unlock, cs:2244~2269).
 *   - Shipment Plan Detail 신규행(CRUD_TYPE='I'): canEdit·상태 무관하되 신규행 전용 화이트리스트
 *     (PLAN_DETAIL_INSERT_EDITABLE_COLUMNS 6개 — LockRange 3개 + 필수 콤보 PACKAGE_TYPE·FACTORY_ID·DOM_EXP, 결함 B5).
 *     AS-IS InsertRow 는 값 복사 후 LockRange(cs:2024~2029)로
 *     REMARKS2·REMARKS·FACTORY_ID·DOM_EXP·CHANGE_REASON 계열·CONFIRM_QTY 계열을 잠그므로 기존행보다 좁다 —
 *     기존행에서 열리는 셀이라도 복사한 신규행에서는 편집 불가(2026-10-15 소스 실측 교정).
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
  // 신규행 판정은 공통 CRUD_TYPE 전용(core §2.4 — 자체 행상태 필드 신설 금지).
  //   신규행은 LockRange 로 좁아진 전용 화이트리스트, canEdit·상태 무관.
  if (str(row.CRUD_TYPE) === 'I') return PLAN_DETAIL_INSERT_SET.has(binding);
  if (!PLAN_DETAIL_SET.has(binding)) return false;
  if (!canEdit) return false;
  return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) !== 'C';
};
