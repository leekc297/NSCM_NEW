import { CRUD_TYPE } from '@foundation/constants';
import { safeString } from '@foundation/utils';

/**
 * 신규 매핑 중복 검사 — AS-IS DMF0006_CustomerModelMapping.cs L518~535 1:1.
 *
 * AS-IS 는 저장 전 신규(I) 행마다 DM_MST_CUSTOMER_MODEL 을 DIVISION_ID, CUSTOMER_PROJECT_CODE,
 * CUSTOMER_MODEL, SCM_SITE_ID 4키로 조회해 1건이라도 있으면 MSG00060 에
 * "[Division], [Sales Site], [Customer PJT], [Customer MODEL]" 을 넣어 안내하고 저장을 중단했다.
 * 4키는 원장 PK(PK_DM_MST_CUSTOMER_MODEL)와 같다.
 *
 * 왜 화면이 막아야 하는가. TO-BE 저장 SP(PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA)
 * 신규(I) 분기는 같은 키 행을 먼저 지우고 INSERT 한다(본문 L478~488). 화면 검사가 없으면 기존 매핑의
 * PJT Code, Model, 환산수량, 최초 등록자와 등록일시가 신규 행 값으로 조용히 바뀐다. SP 는 손대지
 * 않기로 했다(사용자 결정 2026-10-07) — SP 오류는 BE 가 "Sql Error" 로 바꿔 안내가 되지 않는다.
 *
 * TO-BE 는 두 겹으로 본다.
 *   ① 그리드 안: 신규 행의 4키가 그리드의 다른 행(조회된 기존 행, 다른 신규 행)과 같으면 중복.
 *      AS-IS 는 원장만 봤지만, 같은 키 신규 2행을 함께 저장하면 SP 안에서 뒤 행이 앞 행을 덮는다.
 *   ② 원장: 신규 행의 키마다 조회 SP 로 원장을 읽어 4키 정확 일치 행이 있으면 중복. 조회 SP 는
 *      Customer PJT / Model 을 UPPER LIKE 부분일치로 거르므로 결과를 여기서 정확 일치로 다시 거른다.
 */

export const MAPPING_KEY_BINDINGS = [
  'DIVISION_ID',
  'SCM_SITE_ID',
  'CUSTOMER_PROJECT_CODE',
  'CUSTOMER_MODEL',
] as const;
export type MappingKeyBinding = (typeof MAPPING_KEY_BINDINGS)[number];

/** AS-IS MSG00060 인자 원문 — 중복 키 이름 나열(.cs L533). */
export const DUPLICATE_KEY_LABELS = '[Division], [Sales Site], [Customer PJT], [Customer MODEL]';

type KeyRow = Partial<Record<MappingKeyBinding, unknown>> & { CRUD_TYPE?: unknown };

const cellText = (value: unknown): string => safeString(value).trim();

/** 4키 결합 문자열. 한 키라도 비어 있으면 '' — 필수값 검증이 따로 맡고, 여기서 비교하지 않는다. */
export const mappingKeyOf = (row: KeyRow): string => {
  const parts = MAPPING_KEY_BINDINGS.map(binding => cellText(row[binding]));
  if (parts.some(part => part === '')) return '';
  return parts.join('\u0001');
};

export const isNewRow = (row: KeyRow): boolean => row.CRUD_TYPE === CRUD_TYPE.INSERT;

export interface DuplicateHit<T> {
  /** 중복으로 판정된 신규 행 */
  row: T;
  /** 어디서 겹쳤는가 — 그리드 안 다른 행 / 원장 */
  source: 'grid' | 'ledger';
}

/**
 * ① 그리드 안 중복 — 신규 행의 키가 그리드의 다른 행과 같으면 그 신규 행을 돌려준다(첫 건).
 *   같은 키 신규 2행은 뒤 행이 걸린다. 키가 비어 있는 행은 건너뛴다.
 */
export const findGridDuplicate = <T extends KeyRow>(rows: readonly T[]): DuplicateHit<T> | null => {
  const seen = new Map<string, T>();
  for (const row of rows) {
    const key = mappingKeyOf(row);
    if (key === '') continue;
    const prior = seen.get(key);
    if (prior) {
      // 둘 중 신규 행을 중복으로 보고한다 — 기존 행 2건이 같은 키일 수는 없다(PK).
      if (isNewRow(row)) return { row, source: 'grid' };
      if (isNewRow(prior)) return { row: prior, source: 'grid' };
      continue;
    }
    seen.set(key, row);
  }
  return null;
};

/** 신규 행의 키 목록(중복 제거, 빈 키 제외) — 원장 조회 1회가 키 1개를 맡는다. */
export const newRowKeys = <T extends KeyRow>(rows: readonly T[]): Map<string, T> => {
  const keys = new Map<string, T>();
  for (const row of rows) {
    if (!isNewRow(row)) continue;
    const key = mappingKeyOf(row);
    if (key === '' || keys.has(key)) continue;
    keys.set(key, row);
  }
  return keys;
};

/**
 * ② 원장 중복 — 조회 결과(부분일치 포함)에서 4키가 정확히 같은 행이 있는가.
 *   조회 SP 가 UPPER LIKE 로 거르므로 여기서 정확 일치로 좁힌다(AS-IS 는 = 비교).
 */
export const ledgerHasKey = (ledgerRows: readonly KeyRow[], key: string): boolean =>
  key !== '' && ledgerRows.some(row => mappingKeyOf(row) === key);

/**
 * 원장 조회 결과 상태.
 *   - 'clear'     : 모든 신규 키가 원장에 없음 → 저장 진행
 *   - 'duplicate' : 원장에 같은 키 존재 → MSG00060 후 중단
 *   - 'error'     : 조회 자체 실패 → 판단할 수 없으므로 저장을 보내지 않는다(SP 가 덮어쓰기 때문)
 */
export type LedgerCheck<T> =
  | { status: 'clear' }
  | { status: 'duplicate'; hit: DuplicateHit<T> }
  | { status: 'error' };

/**
 * 신규 행 키마다 fetch 로 원장을 읽어 정확 일치를 찾는다. 첫 중복에서 멈춘다.
 *   fetch 는 호출부가 조회 SP(SEARCH) 호출로 넘긴다 — 이 모듈은 DOM·API 를 모른다.
 */
export const findLedgerDuplicate = async <T extends KeyRow>(
  rows: readonly T[],
  fetch: (row: T) => Promise<readonly KeyRow[]>
): Promise<LedgerCheck<T>> => {
  for (const [key, row] of newRowKeys(rows)) {
    let ledgerRows: readonly KeyRow[];
    try {
      ledgerRows = await fetch(row);
    } catch {
      return { status: 'error' };
    }
    if (ledgerHasKey(ledgerRows, key)) return { status: 'duplicate', hit: { row, source: 'ledger' } };
  }
  return { status: 'clear' };
};

/** MSG00060 알림 본문 — 메시지 뒤에 AS-IS 키 이름 나열과 해당 행의 키 값을 붙인다. */
export const duplicateAlertContent = (message: string, row: KeyRow): string => {
  const values = MAPPING_KEY_BINDINGS.map(binding => cellText(row[binding])).join(' / ');
  return `${message}\n${DUPLICATE_KEY_LABELS}\n${values}`;
};
