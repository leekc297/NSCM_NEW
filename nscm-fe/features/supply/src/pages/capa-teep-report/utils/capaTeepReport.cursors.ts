import { RESPONSE_SET } from '../capa-teep-report.constants';
import type { CapaTeepRow, SpreadTitleRow } from '../capa-teep-report.types';

/**
 * GET / 헤더 SP 응답 커서 소비 (03 §1.6 / §4.5 · hook #80).
 *
 * 두 SP 모두 **결과셋 1개**다 — `AfterFindData` 가 `lst[0].Tables[0]` 만 쓴다(cs:1502~1508).
 * 자매 SCP0106 처럼 상태별 2~4개가 아니다.
 *
 * `PKG_SCP0107`·`PKG_SCP0104` 가 **미배포**라 OUT 커서의 실제 파라미터 이름을 실측할 수 없다
 * (03 §6-6/§6-7). 배포 후 이름이 `o_rc1` 이 아닐 수 있으므로 **fallback chain** 으로 읽는다 —
 * 상수 하나만 믿고 `?? []` 로 넘기면 커서 이름이 다를 때 화면이 조용히 0건이 된다.
 * 배포 후 `ora.py args` 실측으로 이름이 확정되면 이 파일 한 곳만 정리하면 된다.
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
 * 그리드 데이터 커서.
 * `Record<string, unknown>[]` -> 행 타입은 구조 변환이므로 `as unknown as` 경유다
 * (direct `as XxxRow[]` 는 convert-core §4.2 grep 게이트 위반).
 */
export const pickDataRows = (response: unknown): CapaTeepRow[] =>
  pickCursor(response, [RESPONSE_SET.DATA, 'O_RC1', 'data'], 0) as unknown as CapaTeepRow[];

/** 동적 기간 헤더 커서 — 반환 6컬럼 중 실사용 4건(03 §2.1). */
export const pickSpreadTitleRows = (response: unknown): SpreadTitleRow[] =>
  pickCursor(
    response,
    [RESPONSE_SET.SPREAD_TITLE, 'O_RC1', 'data'],
    0
  ) as unknown as SpreadTitleRow[];
