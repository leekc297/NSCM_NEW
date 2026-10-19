import { toCellStr } from '../demand-manager.constants';
import type { DemandManagerRow } from '../demand-manager.types';

// DMF0068 — 한 건 = Measure 2행 1세트이고 병합 판정이 그룹 키(KEYVALUE2) 하나로 끝난다
//   (utils/demand-manager.merge.ts pairRange). 삽입 위치·정렬 고정·세트 단위 삭제는
//   공용 GridAction.addRowSet/removeRow 의 groupKey 옵션으로 처리한다
//   (packages/foundation/src/utils/gridAction.ts) — 이 파일은 그 groupKey 함수만 제공한다.

/** 세트 그룹 키 — 조회행은 KEYVALUE2, 신규행은 INSERT_GROUP_ID. 빈 값이면 그룹 없음. */
export const groupKeyOf = (row: DemandManagerRow | undefined): string =>
  row ? toCellStr(row.KEYVALUE2 ?? row.INSERT_GROUP_ID) : '';
