// SSP0045 저장 payload 조립 — SAVE SP 15 파라미터(13개가 '^' 구분 문자열). design 03 §4.3.
//
//   수집 단위는 **행이 아니라 셀**이다(K9). AS-IS 는 `ForeColor.Name == "Red"`(= 사용자가 실제로 바꾼 칸)
//   으로 판정했고, TO-BE 는 그 등가물인 EditTracker 변경 추적을 쓴다. 행 단위로 전 기간을 보내면
//   `DM_PLN_SHIPMENT_REQ_H` 이력이 오염된다(`_H` 는 조건 없이 전건 INSERT).
//
//   SP 루프 길이 주의: SAVE SP 는 `SCM_ARR_SPL_CNT(@p_item_id,'^')` 로 루프 횟수를 정한다.
//   → 13개 배열의 **토큰 수가 전부 같아야 한다**(빈 ITEM_ID 도 토큰은 유지).

import { CRUD_TYPE } from '@foundation/constants';

import {
  COLUMN,
  DUP_KEY_COLUMNS,
  EDITABLE_MEASURE,
} from '../shipment-request-semi.constants';

import { dayOfBinding, isDayBinding } from './shipmentRequestSemi.editLock';

type Row = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

/** 저장 1건 = (행 × 변경된 D_ 기간셀). */
export interface SaveCell {
  activeFlag: string; // 'I'(신규) / 'M'(수정)
  divisionId: string;
  fromSite: string;
  itemId: string;
  incoterms: string;
  transportMode: string;
  toSite: string;
  bodId: string;
  projectCode: string;
  fcstType: string;
  measure: string; // 행 MEASURE — SP 는 INSERT 시 'SHIP_REQ' 리터럴을 쓰지만 파라미터는 그대로 받는다
  yyyymmdd: string; // 컬럼 binding 에서 'D_' 를 뗀 8자리
  qty: string;
  /** 음수 차단 메시지·배경 표시를 위해 원본 행/컬럼을 함께 보관(전송 대상 아님). */
  row: Row;
  binding: string;
}

const identityOf = (row: Row) => ({
  divisionId: str(row[COLUMN.DIVISION_ID]),
  fromSite: str(row[COLUMN.FROM_SITE]),
  itemId: str(row[COLUMN.ITEM_ID]),
  incoterms: str(row[COLUMN.INCOTERMS]),
  transportMode: str(row[COLUMN.TR_MODE]),
  toSite: str(row[COLUMN.TO_SITE]),
  bodId: str(row[COLUMN.BOD_ID]),
  projectCode: str(row[COLUMN.PROJECT_CODE]),
  fcstType: str(row[COLUMN.FCST_TYPE]),
  measure: str(row[COLUMN.MEASURE]),
});

/**
 * 변경 셀 수집 (AS-IS `SaveData` cs:891-937 의 4조건 1:1).
 *   ① 행 CRUD_TYPE 이 'I'(신규) 또는 'M'(수정)
 *   ② 컬럼이 `D_` 기간칼럼
 *   ③ 값이 비어 있지 않음
 *   ④ **실제로 바뀐 셀**만 — 'M' 행은 EditTracker 변경 목록, 'I' 행은 값이 들어간 셀 전부
 *
 * @param changed EditTracker.getOriginalValues() 결과(행 → {binding: 원값}).
 */
export const collectSaveCells = (
  rows: readonly Row[],
  changed: ReadonlyMap<object, Record<string, unknown>>
): SaveCell[] => {
  const out: SaveCell[] = [];
  for (const row of rows) {
    const flag = str(row.CRUD_TYPE);
    if (flag !== CRUD_TYPE.INSERT && flag !== CRUD_TYPE.MODIFY) continue;
    const identity = identityOf(row);
    // 'I' 행은 입력된 기간셀 전량, 'M' 행은 추적된 변경 셀만(셀 단위 의미 유지).
    const bindings =
      flag === CRUD_TYPE.INSERT
        ? Object.keys(row).filter(isDayBinding)
        : Object.keys(changed.get(row) ?? {}).filter(isDayBinding);
    for (const binding of bindings) {
      // 기간셀 값은 숫자 또는 숫자 문자열이다(SP PIVOT `SUM(CASE…)` / 사용자 입력). 다른 타입은
      //   `String()` 이 '[object Object]' 로 무너지므로 애초에 수집 대상에서 뺀다.
      const raw = row[binding];
      if (typeof raw !== 'number' && typeof raw !== 'string') continue;
      if (raw === '') continue;
      out.push({
        activeFlag: flag,
        ...identity,
        yyyymmdd: dayOfBinding(binding),
        qty: String(raw),
        row,
        binding,
      });
    }
  }
  return out;
};

/**
 * 음수 셀 전수 탐지 — 입력은 허용하고 저장 시 전체 중단(design 03 §3.2 R13 / V02).
 *   AS-IS cs:912-917 은 메시지·중단과 함께 `SetBGColor(..., InvalidColor)` 로 **해당 셀을 칠한다**.
 *   그래서 첫 1건이 아니라 전건을 돌려준다 — 호출부가 그리드 배경 표시에 그대로 쓴다(G-23).
 */
export const findNegativeCells = (cells: readonly SaveCell[]): SaveCell[] =>
  cells.filter(cell => {
    const n = Number(String(cell.qty).replace(/,/g, ''));
    return Number.isFinite(n) && n < 0;
  });

/**
 * 저장 필수검증 — AS-IS `checkRequiredOfSpread`(cs:870 → `DataUtil.cs:29-58`)의 1:1 대응.
 *
 *   AS-IS 규칙 그대로다: **컬럼 라벨이 `*` 로 끝나는 컬럼**이 `I`/`M` 행에서 공백이면 차단한다.
 *   대상 목록을 코드에 박지 않고 admin 컬럼 메타(`SCM_MST_SHEET_COLUMNS.COLUMN_LABEL_NAME`)에서
 *   매번 도출하는 이유가 여기 있다 — AS-IS 도 라벨의 `*` 를 읽어 판정한다(하드코딩 목록 아님).
 *   실측 기준 대상 7컬럼: Division* / Model*(ITEM_ID) / From Site* / To Site* / Trans Mode* /
 *   Incoterms* / Measure*(MEASURE).
 *
 *   필수: 이 검증은 공용 `useSaveWithValidation` 을 **대체하지 않고 보완**한다. 이 화면은
 *   컬럼메타 18행이 전건 `INPUT_TP_CD='S'` 라 공용 훅의 `isEditableForRow` 가 항상 false 가 되어
 *   메타 필수검사가 통째로 무발동이다(K11 / U5, 메모리 input-tp-cd-search-only-kills-save-validation).
 *
 * @returns 첫 번째 위반 컬럼의 binding 과 표시 라벨(`*` 제거). 없으면 null.
 */
export const findMissingRequired = (
  rows: readonly Row[],
  columns: readonly { colNm?: string; colLblNm?: string }[]
): { binding: string; label: string } | null => {
  const required = columns
    .filter(column => !!column.colNm && (column.colLblNm ?? '').trim().endsWith('*'))
    .map(column => ({
      binding: String(column.colNm),
      label: (column.colLblNm ?? '').trim().replace(/\*+$/, '').trim(),
    }));
  if (required.length === 0) return null;
  for (const row of rows) {
    const flag = str(row.CRUD_TYPE);
    if (flag !== CRUD_TYPE.INSERT && flag !== CRUD_TYPE.MODIFY) continue;
    for (const column of required) {
      if (!str(row[column.binding])) return column;
    }
  }
  return null;
};

/**
 * 9키 중복 검사 (`checkValidN0` cs:1372-1462 / V09).
 *
 *   대상 = **그리드 전 행**이다. AS-IS cs:1391-1407 의 수집 루프는 `siMain` 의 모든 행 중
 *   `MEASURE=='SHIP_REQ'` 인 행을 **CRUD 상태와 무관하게** dsInput 에 담고, cs:1409-1459 가 그
 *   전체 집합을 O(n²) 자기비교한다. 즉 신규행이 **조회로 내려온 기존 행**과 키가 겹쳐도 차단된다.
 *   (cs:1404 의 `dsInput.Tables[0].Rows` 는 저장 payload 가 아니라 이 수집 루프 내부다 — iter-2 까지
 *   이를 payload 로 오독해 대상을 dirty(I/M) 행으로 좁혔고, 기존 행과의 중복이 통과했다: H-02.)
 *   `MEASURE='SHIP_REQ'` 필터가 AS-IS 의 유일한 수집 조건이다.
 *   AS-IS 는 O(n²) 비교지만 결과가 같은 Set 으로 구현한다.
 *   반환 = 중복 키 문자열(안내 메시지에 덧붙인다) / 없으면 null.
 */
export const findDuplicateKey = (rows: readonly Row[]): string | null => {
  const seen = new Set<string>();
  for (const row of rows) {
    if (str(row[COLUMN.MEASURE]) !== EDITABLE_MEASURE) continue;
    const key = DUP_KEY_COLUMNS.map(c => str(row[c])).join('|');
    if (seen.has(key)) return key;
    seen.add(key);
  }
  return null;
};

/**
 * SaveCell[] → SAVE SP payload. 13개 '^' 문자열 + `createdBy` + `debugMode`.
 *   키명은 `SCM_ADM_PROC_M.COL_NM` 과 정합해야 한다 — `PKG_SSP0045` 미배포라 AS-IS 인자명 기준 camelCase 로 둔다.
 *   (배포 후 `all_arguments` 실측으로 확정 — design 02 §7.2 R5.)
 *   감사키 회피: 배열 payload 의 `createdBy` 는 BE 가 세션 단일값으로 덮어쓰므로 스칼라로 보낸다(nscm-patterns §5-11).
 */
export const buildSavePayload = (
  cells: readonly SaveCell[],
  sessionUserId: string
): Record<string, string> => {
  const join = (sel: (c: SaveCell) => string): string => cells.map(sel).join('^');
  return {
    activeFlag: join(c => c.activeFlag),
    divisionId: join(c => c.divisionId),
    fromSite: join(c => c.fromSite),
    itemId: join(c => c.itemId),
    incoterms: join(c => c.incoterms),
    transportMode: join(c => c.transportMode),
    toSite: join(c => c.toSite),
    bodId: join(c => c.bodId),
    measure: join(c => c.measure),
    yyyymmdd: join(c => c.yyyymmdd),
    qty: join(c => c.qty),
    projectCode: join(c => c.projectCode),
    fcstType: join(c => c.fcstType),
    createdBy: sessionUserId,
    debugMode: 'F',
  };
};
