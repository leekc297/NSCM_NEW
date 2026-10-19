import {
  BOTTLENECK_FLAG_YES,
  BOTTLENECK_JOIN_KEYS,
  RESPONSE_SET,
} from '../capa-lob-report.constants';
import type { CapaLobBottleneckRow, CapaLobRow } from '../capa-lob-report.types';

import { toStr } from './capaLobReport.combos';

/**
 * GET SP 응답 2커서 소비 (03 R-11 / V-26 / hook #80).
 *
 * `PKG_SCP0108` 이 미배포라 OUT 커서의 실제 파라미터 이름을 실측할 수 없다 — 배포 후 이름이
 * `o_rc1`/`o_rc2` 가 아닐 수 있으므로 **fallback chain** 으로 읽는다(하나만 믿고 `?? []` 로
 * 넘기면 커서 이름이 다를 때 화면이 조용히 0건이 된다).
 */

type UnknownRecord = Record<string, unknown>;

const isRowArray = (value: unknown): value is UnknownRecord[] =>
  Array.isArray(value) && (value.length === 0 || typeof value[0] === 'object');

/** 후보 key 를 순서대로 보고, 없으면 응답에 실린 배열 커서를 등장 순서대로 집어온다. */
const pickCursor = (
  response: unknown,
  preferredKeys: readonly string[],
  fallbackIndex: number
): UnknownRecord[] => {
  if (!response || typeof response !== 'object') return [];
  const source = response as UnknownRecord;

  for (const key of preferredKeys) {
    const candidate = source[key];
    if (isRowArray(candidate)) return candidate;
  }

  const arrays = Object.values(source).filter(isRowArray);
  return arrays[fallbackIndex] ?? [];
};

/**
 * 1번째 커서 = 그리드 데이터(03 §4.2 커서1).
 * `Record<string, unknown>[]` -> 행 타입은 구조 변환이므로 `as unknown as` 경유다(direct cast 는
 * convert-core §4.2 grep 게이트 위반, iter-1 G-13).
 */
export const pickDataRows = (response: unknown): CapaLobRow[] =>
  pickCursor(response, [RESPONSE_SET.DATA, 'O_RC1', 'data'], 0) as unknown as CapaLobRow[];

/** 2번째 커서 = Bottleneck 플래그(키 9축 + 기간별 `'Y'`/null, 03 §4.2 커서2). */
export const pickBottleneckRows = (response: unknown): CapaLobBottleneckRow[] =>
  pickCursor(response, [RESPONSE_SET.BOTTLENECK, 'O_RC2', 'bottleneck'], 1);

/**
 * 키 조인 구분자 — 구분자가 없으면 `('A','BC')` 와 `('AB','C')` 가 같은 키가 되어 병목 색이 다른 행에
 * 칠해질 수 있다. 마스터 코드값에 나타날 수 없는 제어문자(U+0001)를 쓴다.
 * 필수: 소스에 제어문자를 **리터럴로 박지 않는다** — 눈에 보이지 않아 "구분자 없음"으로 오독된다
 * (iter-1 G-14 가 실제로 그렇게 읽혔다). `String.fromCharCode` 로 의도를 드러낸다.
 */
const KEY_DELIMITER = String.fromCharCode(1);

/**
 * 키 조인용 합성 키 — `DV`+`DIVISION_ID`+`SITE_ID`+`COMPANY_ID`+`PLANT_ID`+`LINE_ID`+`NICK_NAME`+
 * `OPERATION_ID`+`ELTR_LN_TP_CD` (03 R-11).
 *
 * AS-IS 는 `_tblBottleneckFlag.Rows[r]` 로 **행 인덱스** 대응인데(cs:1373) **CURRENT SP 는 두 커서
 * 모두 `ORDER BY` 가 없어** 순서 동일이 보장되지 않는다(03 §4.2 A / C-09). 인덱스 대응을 이식하면
 * 병목 색이 엉뚱한 행에 칠해질 수 있으므로 키 조인으로 구현한다(V-23).
 */
export const bottleneckKeyOf = (row: UnknownRecord | undefined): string => {
  if (!row) return '';
  const parts = BOTTLENECK_JOIN_KEYS.map(key => toStr(row[key]));
  // 9축 전건 공백이면 키로 쓰지 않는다 — 구분자만 남은 문자열이 유효 키로 오인돼 엉뚱한 행에
  //   병목 플래그가 매칭된다(구분자 도입 전에는 ''(빈 문자열)이 되어 자연히 걸러졌다).
  if (parts.every(part => part === '')) return '';
  return parts.join(KEY_DELIMITER);
};

/** 2번째 커서를 키 -> 플래그행 Map 으로. 같은 키가 중복되면 first-wins(AS-IS 도 1:1 가정). */
export const buildBottleneckIndex = (
  rows: readonly CapaLobBottleneckRow[]
): Map<string, CapaLobBottleneckRow> => {
  const index = new Map<string, CapaLobBottleneckRow>();
  for (const row of rows) {
    const key = bottleneckKeyOf(row);
    if (!key || index.has(key)) continue;
    index.set(key, row);
  }
  return index;
};

/** 그 (행, 기간컬럼) 셀이 병목인가 — 플래그값이 `'Y'` 일 때만 true(03 R-09). */
export const isBottleneckCell = (
  flagRow: CapaLobBottleneckRow | undefined,
  binding: string
): boolean => !!flagRow && toStr(flagRow[binding]) === BOTTLENECK_FLAG_YES;
