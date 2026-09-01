// SYS0013 SAVE payload 매퍼 + SQL 파라미터 치환 유틸 — 표준(useProcMutation)과의 유일한 편차 지점.
//
// ⭐ 근거: PKG_SYS0013 SAVE 3종(P_SYS0013_SAVE_QUERY_LIST/SAVE_COLUMNS/SAVE_PARAMETERS)의
//   JSON_TABLE 이 camelCase 키 계약($.crudType / $.dqId / $.dqName ...)으로 파싱한다.
//   그리드 행(UPPER_SNAKE + CRUD_TYPE)을 그대로 보내면 전 컬럼 NULL 파싱되므로,
//   mutate 직전 이 파일의 매퍼로만 변환한다 (분산 금지 — 단일 소스).
import type { ColumnMetaRow, ParameterMetaRow, QueryRow } from './dynamic-query.types';

// unknown 값 안전 stringification — string/number/boolean/bigint 만 통과, 나머지는 default.
const safeStr = (v: unknown, def = ''): string => {
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean' || typeof v === 'bigint') return String(v);
  return def;
};

// SCM_ADM_DQ_LIST — 신규(I) 행은 dqId 미전달 (SP NVL(MAX)+1 채번).
export const toMainPayload = (rows: QueryRow[]) =>
  rows.map(r => ({
    crudType: r.CRUD_TYPE,
    dqId: r.CRUD_TYPE === 'I' || !r.DQ_ID ? undefined : Number(r.DQ_ID),
    divisionId: safeStr(r.DIVISION_ID, '-') || '-',
    dqName: safeStr(r.DQ_NAME),
    description: safeStr(r.DESCRIPTION),
    dqText: safeStr(r.DQ_TEXT),
    validYn: safeStr(r.VALID_YN, 'Y') || 'Y',
    adminOnlyYn: safeStr(r.ADMIN_ONLY_YN, 'Y') || 'Y',
  }));

// SCM_ADM_DQ_COLUMN — 키 = DQ_ID + COLUMN_NAME (SP UPDATE/DELETE WHERE 절).
export const toColumnsPayload = (rows: ColumnMetaRow[]) =>
  rows.map(r => ({
    crudType: r.CRUD_TYPE,
    dqId: Number(r.DQ_ID ?? 0),
    columnName: safeStr(r.COLUMN_NAME),
    valueYn: safeStr(r.VALUE_YN, 'Y') || 'Y',
    valueType: safeStr(r.VALUE_TYPE, 'System.String') || 'System.String',
    aggregate: safeStr(r.AGGREGATE),
    validYn: safeStr(r.VALID_YN, 'Y') || 'Y',
    seqno: safeStr(r.SEQNO, '0') || '0',
  }));

// SCM_ADM_DQ_PARAMETER — 키 = DQ_ID + PARAMETER_ID.
export const toParametersPayload = (rows: ParameterMetaRow[]) =>
  rows.map(r => ({
    crudType: r.CRUD_TYPE,
    dqId: Number(r.DQ_ID ?? 0),
    parameterId: safeStr(r.PARAMETER_ID),
    parameterType: safeStr(r.PARAMETER_TYPE, 'Parameter') || 'Parameter',
    operationId: safeStr(r.OPERATION_ID, '-') || '-',
    validYn: safeStr(r.VALID_YN, 'Y') || 'Y',
    repYn: safeStr(r.REP_YN, 'N') || 'N',
    seqno: safeStr(r.SEQNO, '0') || '0',
    defaultValue: safeStr(r.DEFAULT_VALUE) || null,
  }));

// ── SQL 파라미터 치환 (AS-IS SCM0005 L446-470 WHERE 조립 정합) ──────────────
// =/>/< : 'value' / IN : ('v1','v2',...) / LIKE : '%value%' / 미입력 = ''.
export const buildParamLiteral = (rawValue: string, operationId: string): string => {
  const v = String(rawValue ?? '').trim();
  if (!v) return '\'\'';
  const escape = (s: string) => s.replace(/'/g, '\'\'');
  const op = (operationId || '=').toUpperCase();
  if (op === 'LIKE') return `'%${escape(v)}%'`;
  if (op === 'IN') {
    const items = v
      .split(',')
      .map(x => x.trim())
      .filter(x => x !== '')
      .map(x => `'${escape(x)}'`)
      .join(', ');
    return items ? `(${items})` : '(\'\')';
  }
  return `'${escape(v)}'`;
};

// @PARAM / :PARAM 토큰을 literal 로 사전 치환 (bind 인식 ORA-01008 회피 — AS-IS L687-690 정합).
// 잔존 미매핑 토큰은 '' 강제.
export const substituteParams = (
  sqlText: string,
  parameterValues: Record<string, string>,
  parameterRows: ParameterMetaRow[]
): string => {
  let sql = sqlText;
  for (const [paramId, value] of Object.entries(parameterValues)) {
    const paramRow = parameterRows.find(r => String(r.PARAMETER_ID) === paramId);
    const literal = buildParamLiteral(value, paramRow?.OPERATION_ID ?? '=');
    const tokenAt = paramId.startsWith('@') ? paramId : `@${paramId}`;
    const tokenBind = paramId.startsWith(':') ? paramId : `:${paramId.replace(/^@/, '')}`;
    sql = sql.split(tokenAt).join(literal).split(tokenBind).join(literal);
  }
  return sql.replace(/[:@]PARAM[A-Z0-9_]*/gi, '\'\'');
};

// SQL 텍스트에서 @PARAM_* 토큰 추출 (격차① Parameters 자동채움 — AS-IS 팝업 sParamArray 정합).
export const extractParamTokens = (sqlText: string): string[] => {
  const matches = sqlText.match(/[:@]PARAM[A-Z0-9_]*/gi) ?? [];
  const unique = new Set(matches.map(m => m.replace(/^[:@]/, '').toUpperCase()));
  return [...unique];
};
