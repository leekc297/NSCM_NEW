import type { Columns, Parameters } from './dynamic-query.types';

// 작은따옴표 문자열 리터럴('' 이스케이프 포함)을 자리표시자로 잠시 빼둔다(mask).
const NUL = '';
const maskStringLiterals = (sql: string): { masked: string; literals: string[] } => {
  const literals: string[] = [];
  const masked = sql.replace(/'(?:[^']|'')*'/g, m => {
    literals.push(m);
    return `${NUL}L${literals.length - 1}${NUL}`;
  });
  return { masked, literals };
};

const unmask = (s: string, literals: string[]): string =>
  s.replace(new RegExp(`${NUL}L(\\d+)${NUL}`, 'g'), (_, i: string) => literals[Number(i)]);

const escapeRegExp = (s: string): string => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

const YYYYMMDD_RE = /^\d{8}$/;

export const isYyyymmdd = (value: string): boolean => YYYYMMDD_RE.test(value);

// 달력 기준 개월 수 차이(일자 미달분은 내림) — 예: 20260101~20260401 = 3개월, 20260101~20260402 = 3개월, 20260101~20260331 = 2개월.
export const monthsBetweenYyyymmdd = (fromYyyymmdd: string, toYyyymmdd: string): number => {
  const fromYear = Number(fromYyyymmdd.slice(0, 4));
  const fromMonth = Number(fromYyyymmdd.slice(4, 6));
  const fromDay = Number(fromYyyymmdd.slice(6, 8));
  const toYear = Number(toYyyymmdd.slice(0, 4));
  const toMonth = Number(toYyyymmdd.slice(4, 6));
  const toDay = Number(toYyyymmdd.slice(6, 8));

  let months = (toYear - fromYear) * 12 + (toMonth - fromMonth);
  if (toDay < fromDay) months -= 1;
  return months;
};

export const findParamTokens = (sql: string): string[] => {
  const { masked } = maskStringLiterals(sql);
  const matches = masked.match(/[@:]\w+/g) ?? [];
  const seen = new Set<string>();
  return matches
    .map(tok => tok.slice(1))
    .filter(name => (seen.has(name.toUpperCase()) ? false : (seen.add(name.toUpperCase()), true)));
};

export const toAtToken = (id: string | null | undefined): string => {
  const name = String(id ?? '')
    .trim()
    .replace(/^[@:]/, '');
  return name ? `@${name}` : '';
};

export const replaceParamToken = (sql: string, name: string, value: string): string => {
  const { masked, literals } = maskStringLiterals(sql);
  const re = new RegExp(`[@:]${escapeRegExp(name)}\\b`, 'g');
  return unmask(masked.replace(re, value), literals);
};

export const reconcileColumns = (
  parsed: { name: string; type: string }[],
  prev: Columns[],
  dqId: number | string
): Columns[] => {
  const prevByName = new Map(prev.map(c => [c.COLUMN_NAME.toUpperCase(), c]));
  const parsedNames = new Set(parsed.map(c => c.name.toUpperCase()));

  const rows: Columns[] = parsed.map((col, idx) => {
    const existing = prevByName.get(col.name.toUpperCase());
    // 미저장 신규 세션 행('I') 은 그대로 'I', 그 외 기존 행은 재정의됐으므로 'M'. 없던 컬럼은 신규 'I'.
    const crudType = !existing ? 'I' : existing.CRUD_TYPE === 'I' ? 'I' : 'M';
    return {
      DQ_ID: dqId,
      COLUMN_NAME: col.name,
      // 기존 행이 있으면 사용자가 정한 표시/집계 설정을 보존, 없으면 기본값.
      VALUE_YN: existing?.VALUE_YN ?? 'Y',
      VALUE_TYPE: col.type,
      VALID_YN: existing?.VALID_YN ?? 'Y',
      SEQNO: String(idx + 1),
      AGGREGATE: existing?.AGGREGATE ?? '',
      CRUD_TYPE: crudType,
    };
  });

  // 파싱 결과에서 사라진 저장분 컬럼 → 'D' 로 삭제 지시(미저장 신규는 제외).
  const deleted: Columns[] = prev
    .filter(c => !parsedNames.has(c.COLUMN_NAME.toUpperCase()) && c.CRUD_TYPE !== 'I')
    .map(c => ({ ...c, CRUD_TYPE: 'D' }));

  return [...rows, ...deleted];
};

export const reconcileParameters = (
  tokens: string[],
  prev: Parameters[],
  dqId: number | string
): Parameters[] => {
  // 비교는 정규화된 '@name' 대문자로. (기존 DB 는 ':name' 로 저장돼도 조회 시 '@name' 로 정규화됨)
  const key = (id: string) => toAtToken(id).toUpperCase();
  const prevByName = new Map(prev.map(p => [key(p.PARAMETER_ID), p]));
  const parsedKeys = new Set(tokens.map(t => key(t)));

  const rows: Parameters[] = tokens.map((name, idx) => {
    const at = toAtToken(name);
    const existing = prevByName.get(at.toUpperCase());
    const crudType = !existing ? 'I' : existing.CRUD_TYPE === 'I' ? 'I' : 'M';
    return {
      DQ_ID: dqId,
      PARAMETER_ID: at,
      PARAMETER_TYPE: existing?.PARAMETER_TYPE ?? 'Parameter',
      OPERATION_ID: existing?.OPERATION_ID ?? '-',
      VALID_YN: existing?.VALID_YN ?? 'Y',
      REP_YN: existing?.REP_YN ?? '-',
      SEQNO: String(idx + 1),
      CRUD_TYPE: crudType,
    };
  });

  const deleted: Parameters[] = prev
    .filter(p => !parsedKeys.has(key(p.PARAMETER_ID)) && p.CRUD_TYPE !== 'I')
    .map(p => ({ ...p, PARAMETER_ID: toAtToken(p.PARAMETER_ID), CRUD_TYPE: 'D' }));

  return [...rows, ...deleted];
};
