// ⭐ SPMS 표준 — 저장/액션 벌크 payload (SDM1010 확정 표준. 화면군 밖 공용 승격 보류 — SDM 내부 전용).
//   다중 변경행을 행 배열이 아닌 **컬럼별 '^' 구분 문자열 1건**으로 접어 useProcMutation 으로 보낸다.
//
//   왜 1건으로 접는가 (표준 근거 — SDM1010 실측):
//   nscm-be MapUtils.cvtJsonToJVarchar 는 JVARCHAR 컬럼을 data[].length 만큼 순회해 조인하는데,
//   sesUserId^ 는 그 순회 횟수만큼 세션 유저ID를 반복 조인해 채운다. SP 는 P_SES_USER_ID 를
//   루프 밖에서 스칼라 한 번만 받으므로, data 를 원본 N행 배열 그대로 보내면 N>=2 일 때
//   sesUserId 가 "user^user" 캐럿 문자열째로 MGMT_USER_ID/CREATED_BY 에 들어가 조회 SP 의
//   USER_ID JOIN 에서 행이 통째로 사라진다. FE 가 미리 '^' 조인해 data 길이를 1로 접으면
//   BE 는 1회만 순회하고 sesUserId 도 스칼라 그대로 채워진다.
//
//   빈 값 = ' '(공백 1칸) 센티널: SP 의 '^' 파서(REGEXP_SUBSTR [^\^]+)는 빈 토큰을 건너뛰어
//   행 정렬이 밀린다 — '' 금지, 공백으로 자리를 지킨다.
import dayjs from '@foundation/dayjs';

import { toText } from './call-proc';

export const BULK_SEP = '^' as const;
export const BULK_EMPTY = ' ' as const;

// 셀 값 → '^' 토큰. DATE 컬럼 = SP TO_DATE(..., 'YYYY-MM-DD HH24:MI:SS') 마스크 호환 변환
//   (파싱 불가 값은 원문 유지 — SP 가드 몫). boolean 은 문자열화(FPCheckBox 실측 계보).
//   비스칼라 값(toText '')은 빈 값과 동일하게 ' ' 센티널 — 빈 토큰 행밀림 방지.
const toBulkToken = (value: unknown, isDate: boolean): string => {
  if (value == null || value === '') return BULK_EMPTY;
  if (typeof value === 'boolean') return String(value);
  if (isDate) {
    const parsed = dayjs(value as string | number | Date);
    if (parsed.isValid()) return parsed.format('YYYY-MM-DD HH:mm:ss');
  }
  const text = toText(value);
  return text === '' ? BULK_EMPTY : text;
};

/**
 * 저장(SAVE) 표준 payload — N행을 '^' 벌크 1건으로 접는다.
 *
 * @param rows     저장 대상 변경행 (CRUD_TYPE 마킹된 행 — 대상 filter 는 호출부 몫)
 * @param keys     SP IN 파라미터로 실제 소비되는 컬럼 (PROC_M COL_NM 1:1 — 화면 상수로 정의)
 * @param dateKeys keys 중 DATE 파라미터 컬럼 ('YYYY-MM-DD HH:mm:ss' 변환 대상)
 *
 * keys 외 나머지 필드는 전부 '' 로 비운다 — ResponseData 타입상 전 필드가 필요하지만
 * SP 미소비 값이 Payload 에 실값처럼 찍혀 헷갈리는 것을 막는다 (SDM1010 결정 승계).
 */
export const buildBulkSavePayload = <Row extends Record<string, unknown>>(
  rows: Row[],
  keys: readonly (keyof Row & string)[],
  dateKeys: readonly (keyof Row & string)[] = []
): Row[] => {
  if (rows.length === 0) return [];
  const dateKeySet = new Set<string>(dateKeys);
  const payload = Object.fromEntries(Object.keys(rows[0]).map(key => [key, ''])) as Row;
  for (const key of keys) {
    payload[key] = rows
      .map(row => toBulkToken(row[key], dateKeySet.has(key)))
      .join(BULK_SEP) as Row[typeof key];
  }
  return [payload];
};

/**
 * 액션(REQUEST/CANCEL 등 버튼) 표준 payload — 키 컬럼만 '^' 조인해 1건으로 접는다.
 * 나머지 필드는 rows[0] 값을 승계한다 (SP 가 키 외 값은 첫 행 기준으로만 소비 — SDM1010 결정 승계).
 */
export const buildBulkActionPayload = <Row extends Record<string, unknown>>(
  rows: Row[],
  keys: readonly (keyof Row & string)[]
): Row[] => {
  if (rows.length === 0) return [];
  const joined = Object.fromEntries(
    keys.map(key => [key, rows.map(row => toText(row[key])).join(BULK_SEP)])
  ) as Partial<Row>;
  return [{ ...rows[0], ...joined }];
};
