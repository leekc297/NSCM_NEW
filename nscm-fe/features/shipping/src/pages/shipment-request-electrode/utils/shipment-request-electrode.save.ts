// SSP0022 요청상세(spdDetail.shtRequestDetail) 저장 — AS-IS SaveData_Detail(cs:2520~2728) 이식.
//
// 저장 SP = PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST (2026-10-27 DB 실측: 배포·VALID, API_M PROC_SAVE,
//   SCM_ADM_MNU_BTN_MPG_M main/SAVE 등록 완료 — design 00 §0·07_validation-audit §0.5 의 "미배포" 전제는 갱신됨).
//   16 IN(ALL_ARGUMENTS 실측): P_ACTIVE_FLAG·P_DIVISION_ID·P_COMPANY_ID·P_SCM_SITE_ID·P_PLANT_ID·P_MODEL_ID·
//   P_ITEM_ID·P_FROM_SITE·P_TO_SITE·P_ETA_DATE·P_BOD_ID·P_QTY·P_INCOTERMS·P_TRANSPORT_MODE(= 행 단위 '^' 결합)
//   + P_CREATED_BY·DEBUG_MODE(= 스칼라). 본문이 V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ITEM_ID) 로 루프 수를
//   정하고 전 행-파라미터를 '^' 로 split 하므로 **14개 토큰 수가 전부 같아야 한다**(어긋나면 행이 밀린다).
//   결과 커서 o_rc1 1행 = {RESULT_CODE, MSG} — 'S' 성공 / 'X' 표준정보 미등록(route·BOD NULL, AS-IS 'X'=MSG00324)
//   / 'F' 예외(V_ERR_MESSAGE 서버 패스스루, AS-IS 'N'/시스템오류). (PKG_SSP0022 BODY 4301·4670·4691 실측.)
//
// 파라미터명은 SCM_ADM_PROC_M.COL_NM 실측(camelCase) 그대로다. /call-proc 은 세션을 주입하지 않으므로
//   createdBy 를 FE 가 반드시 실어야 한다(메모리 save-procm-colnm-must-match-fe-camelcase-clob).
// 행→인자 대응은 AS-IS SaveData_Detail fold(cs:2604~2621) 실측: plant_id=TO_SITE[0:4] · scm_site_id=TO_SITE ·
//   division=ORIGIN_DIVISION_ID · model/item 대문자 · eta_date=shipment_date 숫자만 · qty 콤마 제거.

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';

import { MEASURE, MENU_ID, SHEETS } from '../shipment-request-electrode.constants';

import { dayOfPivotBinding, isPivotDayXBinding } from './shipment-request-electrode.editLock';

export type SaveRow = Record<string, unknown>;

/** 변경행 판정 액션(Action/CRUD 열). Delete 는 R7 NO-OP 이라 실제로는 I/M 만 들어온다. */
export const CHANGED_ACTIONS = new Set(['I', 'M', 'D']);

/** ITEM_ID 셀 팝업(C1~C4) 선행 필수 컬럼 — 순서 그대로(From Site → To Site → Incoterms → Trans Mode). */
export const PREREQUISITE_COLUMNS = ['FROM_SITE', 'TO_SITE', 'INCOTERMS', 'TRANSPORT_MODE'] as const;

/** 입력 중복(fnValidation, cs:3829~3835) 판정 6키. */
const DUPLICATE_KEY_COLUMNS = ['DIVISION_ID', 'FROM_SITE', 'TO_SITE', 'ITEM_ID', 'MODEL_ID'] as const;

export const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** 날짜 토큰을 8자리 숫자(yyyymmdd)로 — SP 가 8자리 VARCHAR 와 직접 비교한다. */
export const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

const isValidYmd8 = (s: string): boolean => {
  if (!/^\d{8}$/.test(s)) return false;
  const y = Number(s.slice(0, 4));
  const m = Number(s.slice(4, 6));
  const d = Number(s.slice(6, 8));
  return y >= 1900 && y <= 2999 && m >= 1 && m <= 12 && d >= 1 && d <= 31;
};

/** 조회 기간 상한 라벨(일) — 메시지 {0} 표시용. 실제 경계는 from+1년+7일(아래 checkPeriodRange). */
export const MAX_PERIOD_LABEL_DAYS = 371;

export type PeriodError = 'EMPTY' | 'ORDER' | 'MAX';

/**
 * 조회 기간 범위 검증 — AS-IS 공통 DateUtil.Check_PeriodDate(cs:2103 drpPeriod / 2251·2395·2942 drpPeriod2)
 *   등가. SSP0022 감사(07)는 공통 유틸이라 화면 소스에 MSG 리터럴이 없어 이 검증을 누락했다.
 *   공백 → 'EMPTY'(MSG00665) / from>to → 'ORDER'(MSG00108) / 상한 초과 → 'MAX'(MSG01187, {0}=371). 유효=null.
 *   상한은 고정 371일이 아니라 from + 1캘린더연 + 7일이며 경계 포함(>=)이다(윤년 보정, DateUtil.cs:122→140,
 *   자매 shipment-request-semi/pack 선례). 고정 371 로 계산하면 윤년 2/29 포함 구간에서 AS-IS 보다 엄격해진다.
 */
export const checkPeriodRange = (fromRaw: string, toRaw: string): PeriodError | null => {
  const from = ymd8(fromRaw);
  const to = ymd8(toRaw);
  if (from.length < 8 || to.length < 8) return 'EMPTY';
  if (from > to) return 'ORDER';
  const toDay = (ymd: string) => dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`);
  const limit = toDay(from).add(1, 'year').add(7, 'day').format('YYYYMMDD');
  return to >= limit ? 'MAX' : null;
};

/** 활성 그리드 sourceCollection 에서 변경행(I/M/D)만 추린다. */
export const collectChangedRows = (rows: SaveRow[]): SaveRow[] =>
  rows.filter(r => CHANGED_ACTIONS.has(str(r.CRUD_TYPE)));

/**
 * Insert 신규행 기본값 — AS-IS InsertRow(cs:1447-1472)는 DIVISION_ID 만 SetValue 하고 EDIT_FLAG 는 설정하지 않는다.
 *   필수: EDIT_FLAG 에 'N' 을 넣지 않는다 — 공용 GridAction.addRowSet 는 `itemsSource.every(EDIT_FLAG==='N')`
 *   이면 행추가를 차단한다(gridAction.ts:822-824). 신규행에 'N' 을 박으면 빈 그리드에 한 행 추가 후 둘째부터,
 *   조회 데이터가 전부 'N' 이면 첫 행부터 추가가 막힌다(2026-11-04 사용자 지적, AS-IS 에 없는 비충실 값이 원인).
 *   CRUD_TYPE='I' 는 addRowSet 이 부여하고, 신규행 편집범위는 editLock 의 isNewRow(CRUD_TYPE) 가 판정하므로
 *   EDIT_FLAG 는 신규행에 불필요하다(기존행 EDIT_FLAG 분기는 조회로 내려온 행에만 적용).
 */
export const buildNewRow = (divisionId: string): SaveRow => ({
  DIVISION_ID: divisionId,
  ORIGIN_DIVISION_ID: divisionId,
});

/**
 * ITEM_ID 셀 선행필수(C1~C4, cs:1015~1042 / 869~897) — 첫 번째로 빠진 선행 컬럼 binding 을 돌려준다.
 *   모두 채워졌으면 null. AS-IS 는 각각 MSG00098 "First, select {0}" 를 띄우고 차단한다.
 */
export const firstMissingPrerequisite = (row: SaveRow): (typeof PREREQUISITE_COLUMNS)[number] | null => {
  for (const col of PREREQUISITE_COLUMNS) {
    if (str(row[col]).trim() === '') return col;
  }
  return null;
};

/** S3 날짜형식(cs:2575~2584) — SHIPMENT_DATE 가 유효 날짜가 아닌 첫 행. 공백은 필수검증 소관이라 건너뛴다. */
export const findInvalidShipmentDate = (rows: SaveRow[]): SaveRow | undefined =>
  rows.find(r => {
    const raw = str(r.SHIPMENT_DATE).trim();
    return raw !== '' && !isValidYmd8(ymd8(raw));
  });

/**
 * S4 출하일 < 확정일(ConfirmDayChk, cs:4042~4068) — ConfirmDay > ShipmentDate 인 첫 행과 그 ConfirmDay.
 *   ConfirmDay 가 비었거나(제약 없음) 유효하지 않으면 건너뛴다(AS-IS 는 parse 예외를 차단으로 보지만,
 *   빈 ConfirmDay 로 전 행을 막는 것은 과차단이라 등가 범위에서 완화 — 04_react-gap 기록 대상).
 */
export const findConfirmDayViolation = (
  rows: SaveRow[]
): { row: SaveRow; confirmDay: string } | undefined => {
  for (const r of rows) {
    const confirmDay = ymd8(r.CONFIRM_DAY);
    const shipDate = ymd8(r.SHIPMENT_DATE);
    if (!isValidYmd8(confirmDay) || !isValidYmd8(shipDate)) continue;
    if (confirmDay > shipDate) return { row: r, confirmDay };
  }
  return undefined;
};

/**
 * S2 입력 중복(fnValidation, cs:3815~3853) — 신규행('I') 중 6키(Div+FromSite+ToSite+Item+Model+출하일)가
 *   다른 행과 겹치면 true. 날짜는 포맷 차를 피해 yyyymmdd 로 정규화해 비교한다.
 */
export const hasDuplicate = (source: SaveRow[]): boolean => {
  const keyOf = (r: SaveRow): string =>
    [...DUPLICATE_KEY_COLUMNS.map(c => str(r[c])), ymd8(r.SHIPMENT_DATE)].join('');
  const counts = new Map<string, number>();
  for (const r of source) {
    const k = keyOf(r);
    counts.set(k, (counts.get(k) ?? 0) + 1);
  }
  return source.some(r => str(r.CRUD_TYPE) === 'I' && (counts.get(keyOf(r)) ?? 0) > 1);
};

export interface SaveContext {
  companyId: string;
  userId: string;
}

// 행 단위 '^'-결합 14 인자 ← 요청상세 행 컬럼(AS-IS fold cs:2604~2621). companyId 는 화면값을 행 수만큼 반복한다
//   (SP 가 전 행-파라미터를 같은 길이로 split 하므로).
const ROW_PARAM_SOURCE: { param: string; get: (r: SaveRow, ctx: SaveContext) => string }[] = [
  { param: 'activeFlag', get: r => str(r.CRUD_TYPE) },
  { param: 'divisionId', get: r => str(r.ORIGIN_DIVISION_ID) || str(r.DIVISION_ID) },
  { param: 'companyId', get: (_r, ctx) => ctx.companyId },
  { param: 'scmSiteId', get: r => str(r.TO_SITE) },
  { param: 'plantId', get: r => str(r.TO_SITE).slice(0, 4) },
  { param: 'modelId', get: r => str(r.MODEL_ID).toUpperCase() },
  { param: 'itemId', get: r => str(r.ITEM_ID).toUpperCase() },
  { param: 'fromSite', get: r => str(r.FROM_SITE) },
  { param: 'toSite', get: r => str(r.TO_SITE) },
  { param: 'etaDate', get: r => ymd8(r.SHIPMENT_DATE) },
  { param: 'bodId', get: r => str(r.BOD_ID) },
  { param: 'qty', get: r => str(r.SHIPMENT_QTY).replace(/,/g, '') },
  { param: 'incoterms', get: r => str(r.INCOTERMS) },
  { param: 'transportMode', get: r => str(r.TRANSPORT_MODE) },
];

export const buildSavePayload = (rows: SaveRow[], ctx: SaveContext): Record<string, string> => {
  const payload: Record<string, string> = {};
  for (const { param, get } of ROW_PARAM_SOURCE) {
    payload[param] = rows.map(r => get(r, ctx)).join('^');
  }
  // 스칼라 인자(PROC_M VARCHAR2) — 행 단위가 아니다.
  payload.createdBy = ctx.userId;
  payload.debugMode = 'N';
  return payload;
};

export interface SaveResult {
  /** o_rc1 RESULT_CODE — 'S' 성공 / 'X' 표준정보 미등록 / 'F' 서버오류 / '' 통신·래퍼 오류. */
  code: 'S' | 'X' | 'F' | '';
  /** 'F'·'X' 경로의 서버 MSG 또는 HTTP/BE 오류 문구. */
  message: string;
  /** 통신·false-success 판정. false 면 code 를 신뢰할 수 없다. */
  ok: boolean;
}

// 커서 결과는 열 순서를 보장하지 않으므로 RESULT_CODE/MSG 를 이름으로 읽는다(대/소문자 폴백).
const readCode = (row: Record<string, unknown> | undefined): string =>
  row ? str(row.RESULT_CODE ?? row.result_code ?? Object.values(row)[0]) : '';
const readMsg = (row: Record<string, unknown> | undefined): string =>
  row ? str(row.MSG ?? row.msg ?? '') : '';

/**
 * '^'-폴딩 payload 를 P_SSP0022_SAVE_SHIPMENT_REQUEST 로 POST 하고 o_rc1 결과를 해석한다.
 *   HTTP 200·code:0 이어도 o_rc1 첫 칸이 'S' 가 아니면 저장되지 않았다(AS-IS cs:2665~2706).
 *   인터셉터가 500/403 도 resolve 하므로 status/code 분기가 없으면 실패가 성공으로 샌다.
 *   요청상세(spdDetail)와 ETA 요청팝업(ShipmentRequestInsertModal)이 같은 SP 를 공유한다.
 */
export const postShipmentRequestSave = async (
  payload: Record<string, string>
): Promise<SaveResult> => {
  const res = await apiClient.post<Record<string, Record<string, unknown>[]>>(
    `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
    payload
  );
  if (res.status >= 400 || Number(res.data?.code)) {
    return { ok: false, code: '', message: str((res.data as { message?: string })?.message) };
  }
  const first = res.data.result?.o_rc1?.[0];
  const code = readCode(first);
  return { ok: true, code: (code as SaveResult['code']) || '', message: readMsg(first) };
};

/**
 * 요청상세 저장 실행 — 변경행을 '^'-폴딩(buildSavePayload)해 저장한다.
 */
export const submitShipmentRequestSave = async (
  rows: SaveRow[],
  ctx: SaveContext
): Promise<SaveResult> => postShipmentRequestSave(buildSavePayload(rows, ctx));

// ── 메인 pivot(spdMain) 저장 — AS-IS SaveData(cs:2729-2924) 이식 ──
//   요청상세 저장(위)과 **같은 SP**(P_SSP0022_SAVE_SHIPMENT_REQUEST)·엔드포인트를 쓰나, 수집 단위가 다르다:
//   요청상세는 '행', 메인은 '셀'(= R_SHIP_REQ_ETA 행 × 변경된 X_D_ 일 셀, cs:2775-2813). AS-IS 는
//   `ForeColor.Name=="Red"`(사용자가 실제로 바꾼 칸)로 판정했고, TO-BE 는 그 등가물인 EditTracker 변경 추적을 쓴다.
//   메인 저장은 요청상세와 달리 **저장 전 확인창이 없다**(cs:2729-2924 전 구간 GMessageBox(Yes/No) 없음 — R12).

/** 메인 pivot 저장 1건 = (R_SHIP_REQ_ETA 행 × 변경된 X_D_ 일 셀). */
export interface MainSaveCell {
  activeFlag: string; // 행 CRUD_TYPE — 조회된 기존 행 인라인 편집이라 실질 'M'
  divisionId: string; // AS-IS p_division_id = TEMPCOLUMN(cs:2796)
  bodId: string;
  incoterms: string;
  transportMode: string;
  plantId: string;
  scmSiteId: string;
  fromSite: string;
  toSite: string;
  modelId: string;
  itemId: string;
  etaDate: string; // X_D_ 뒤 yyyymmdd(= 그 셀의 날짜, cs:2789 strDayName)
  qty: string;
}

/**
 * 변경 셀 수집 — AS-IS SaveData 루프(cs:2775-2813)의 조건 1:1.
 *   ① 행 CRUD_TYPE 이 'I'/'M' (cs:2784 — 메인 pivot 은 신규행 경로가 없어 실질 'M')
 *   ② 컬럼이 X_D_ 일 셀 (cs:2781)
 *   ③ 값이 비어있지 않음 (cs:2793)
 *   ④ **실제로 바뀐 셀**만 — AS-IS ForeColor=="Red", TO-BE EditTracker 변경 목록(semi K9 동형)
 *   방어 가드: MEASURE==='R_SHIP_REQ_ETA' — 편집 게이트(isShipmentPsiCellEditable)가 이 행만 열지만
 *   붙여넣기·직접입력 우회 대비로 수집 단계에서도 재확인한다(editLock 과 동일 축).
 *
 * @param changed EditTracker.getOriginalValues() 결과(행 객체 → {binding: 원값}).
 */
export const collectMainSaveCells = (
  rows: readonly SaveRow[],
  changed: ReadonlyMap<object, Record<string, unknown>>
): MainSaveCell[] => {
  const out: MainSaveCell[] = [];
  for (const row of rows) {
    const flag = str(row.CRUD_TYPE);
    if (flag !== 'I' && flag !== 'M') continue;
    if (str(row.MEASURE) !== MEASURE.SHIP_REQ_ETA) continue;
    const bindings = Object.keys(changed.get(row) ?? {}).filter(isPivotDayXBinding);
    for (const binding of bindings) {
      const raw = row[binding];
      if (typeof raw !== 'number' && typeof raw !== 'string') continue;
      const qty = String(raw).replace(/,/g, '').trim();
      if (qty === '') continue; // 비공백만(cs:2793)
      out.push({
        activeFlag: flag,
        // AS-IS p_division_id = TEMPCOLUMN(ORIGIN division). 미존재 시 폴백(ETA 모달 DIVISION_ORG 동일 체인).
        divisionId: str(row.TEMPCOLUMN) || str(row.ORIGIN_FROM_DIVISION_ID) || str(row.DIVISION_ID),
        bodId: str(row.BOD_ID),
        incoterms: str(row.INCOTERMS),
        transportMode: str(row.TRANSPORT_MODE),
        plantId: str(row.PLANT_ID),
        scmSiteId: str(row.SCM_SITE_ID),
        fromSite: str(row.FROM_SITE),
        toSite: str(row.TO_SITE),
        // AS-IS 메인 SaveData 는 Model/Item 을 ToUpper 하지 않는다(cs:2804-2805 raw) — 요청상세 fold 와 다름.
        modelId: str(row.MODEL_ID),
        itemId: str(row.ITEM_ID),
        etaDate: dayOfPivotBinding(binding),
        qty,
      });
    }
  }
  return out;
};

/**
 * MainSaveCell[] → SAVE SP payload(camelCase, '^'-폴딩 13 + createdBy/debugMode 스칼라).
 *   AS-IS p_company_id 는 스칼라(cs:2834)지만, SP 가 `SCM_ARR_SPL_CNT(p_item_id,'^')` 로 루프 수를 정하므로
 *   **모든 배열의 토큰 수가 같아야** 밀리지 않는다 — companyId 를 셀 수만큼 반복해 정합을 보장한다(요청상세 fold 동일 방침).
 */
export const buildMainSavePayload = (
  cells: readonly MainSaveCell[],
  ctx: SaveContext
): Record<string, string> => {
  const join = (sel: (c: MainSaveCell) => string): string => cells.map(sel).join('^');
  return {
    activeFlag: join(c => c.activeFlag),
    divisionId: join(c => c.divisionId),
    companyId: join(() => ctx.companyId),
    scmSiteId: join(c => c.scmSiteId),
    plantId: join(c => c.plantId),
    modelId: join(c => c.modelId),
    itemId: join(c => c.itemId),
    fromSite: join(c => c.fromSite),
    toSite: join(c => c.toSite),
    etaDate: join(c => c.etaDate),
    bodId: join(c => c.bodId),
    incoterms: join(c => c.incoterms),
    transportMode: join(c => c.transportMode),
    qty: join(c => c.qty),
    createdBy: ctx.userId,
    debugMode: 'N',
  };
};

/**
 * 메인 pivot 저장 실행 — 변경 X_D_ 셀을 수집·'^'-폴딩해 저장한다. 변경 셀 0건이면 저장하지 않고 count=0 반환
 *   (호출부가 MSG00005 "변경/추가된 데이터가 없습니다" 안내, AS-IS cs:2905-2908).
 */
export const submitMainSave = async (
  rows: readonly SaveRow[],
  changed: ReadonlyMap<object, Record<string, unknown>>,
  ctx: SaveContext
): Promise<{ result: SaveResult; count: number }> => {
  const cells = collectMainSaveCells(rows, changed);
  if (cells.length === 0) return { result: { ok: true, code: '', message: '' }, count: 0 };
  const result = await postShipmentRequestSave(buildMainSavePayload(cells, ctx));
  return { result, count: cells.length };
};
