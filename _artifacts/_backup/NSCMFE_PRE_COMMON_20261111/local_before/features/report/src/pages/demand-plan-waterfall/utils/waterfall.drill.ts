import { BUCKET2_TYPE, BUCKET_TYPE, GUBUN, type Gubun } from '../demand-plan-waterfall.constants';

import { dynKindOf } from './waterfall.periods';

export interface HeaderDrillInput {
  gubun: Gubun;
  /** 현재 조회조건 bucket (AS-IS fBucket — 조회 시점 버킷) */
  bucket: string;
  /** 화면에 등록된 기간 컬럼 binding — TITLE SP SORT_ORDER_NO 순서 그대로 (AS-IS 스프레드 컬럼 순서) */
  dynBindings: string[];
  /** 현재 표시 상태 */
  isVisible: (binding: string) => boolean;
  /** 더블클릭된 헤더의 leaf binding */
  clicked: string;
}

/**
 * 헤더 더블클릭 드릴다운 — AS-IS `spdMain_CellDoubleClick(e.ColumnHeader)` 1:1.
 *
 * MKT·SALES (DMF0035 .cs:1632-1680 / DMF0022 .cs:1700-1748)
 *   M_ 클릭 : 클릭 컬럼부터 순회하며 W_ 토글 / (bucket=DAILY) D_ 는 보이면 접기만 /
 *             (그 외 bucket) M_ 은 숨겨져 있으면 펼침 → 다음 컬럼이 M_ 이면 중단
 *   W_ 클릭 : (bucket=DAILY) D_ 토글 → 다음 컬럼이 W_ 이면 중단
 *
 * BIZ (DMF0051 .cs:1019-1060) — 계층이 반대 방향으로 배열돼 있어 walk 도 반대다
 *   M_ 클릭 : Q_ 토글 / (bucket=MONTHLY) M_ 은 보이면 접기만 / Y_ 는 숨겨져 있으면 펼침
 *             → 다음 컬럼이 Y_ 이면 중단
 *   Q_ 클릭 : (bucket=MONTHLY) M_ 토글 → 다음 컬럼이 Q_ 이면 중단
 *
 * @returns 바꿀 binding → 새 visible 값 (대상 없으면 빈 Map)
 */
export const walkHeaderDrill = ({
  gubun,
  bucket,
  dynBindings,
  isVisible,
  clicked,
}: HeaderDrillInput): Map<string, boolean> => {
  const patch = new Map<string, boolean>();
  const start = dynBindings.indexOf(clicked);
  if (start < 0) return patch;

  const clickedKind = dynKindOf(clicked);
  const nextKind = (i: number): string | null =>
    i + 1 < dynBindings.length ? dynKindOf(dynBindings[i + 1]) : null;
  const flip = (b: string): void => {
    patch.set(b, !isVisible(b));
  };

  if (gubun === GUBUN.BIZ_PLAN) {
    const isMonthly = bucket === BUCKET2_TYPE.MONTHLY;
    if (clickedKind === 'M') {
      for (let i = start; i < dynBindings.length; i += 1) {
        const b = dynBindings[i];
        const k = dynKindOf(b);
        if (k === 'Q') flip(b);
        else if (isMonthly) {
          if (k === 'M' && isVisible(b)) patch.set(b, false);
        } else if (k === 'Y') {
          if (!isVisible(b)) patch.set(b, true);
        }
        if (nextKind(i) === 'Y') break;
      }
    } else if (clickedKind === 'Q') {
      for (let i = start; i < dynBindings.length; i += 1) {
        const b = dynBindings[i];
        if (isMonthly && dynKindOf(b) === 'M') flip(b);
        if (nextKind(i) === 'Q') break;
      }
    }
    return patch;
  }

  const isDaily = bucket === BUCKET_TYPE.DAILY;
  if (clickedKind === 'M') {
    for (let i = start; i < dynBindings.length; i += 1) {
      const b = dynBindings[i];
      const k = dynKindOf(b);
      if (k === 'W') flip(b);
      else if (isDaily) {
        if (k === 'D' && isVisible(b)) patch.set(b, false);
      } else if (k === 'M') {
        if (!isVisible(b)) patch.set(b, true);
      }
      if (nextKind(i) === 'M') break;
    }
  } else if (clickedKind === 'W') {
    for (let i = start; i < dynBindings.length; i += 1) {
      const b = dynBindings[i];
      if (isDaily && dynKindOf(b) === 'D') flip(b);
      if (nextKind(i) === 'W') break;
    }
  }
  return patch;
};
