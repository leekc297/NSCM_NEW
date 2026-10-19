import type { BUCKET_TYPE } from '../production-plan-line.constants';
import { BUCKET_TYPE as BUCKET } from '../production-plan-line.constants';

import { isoWeek } from './productionPlanLineDerive';
import { isPivotVisible, pivotKind } from './productionPlanLineEditLock';

// 드릴다운 가시성 오버라이드 — binding → visible. 비어 있으면 전부 bucket 기본 가시성.
//   AS-IS SpdInfo.SetDblClickColumnShowHide(SpreadInfo.cs) 가 컬럼 Visible 를 직접 토글하던 것을
//   React 상태로 옮긴 것. design 03 §2.4 / §4d #27·#28 / cs:4029~4052 SpdMain_CellDoubleClick.
export type DrilldownState = ReadonlyMap<string, boolean>;

export const EMPTY_DRILLDOWN: DrilldownState = new Map();

// D_ 셀 키 → yyyymmdd, W_/M_ 키 → 숫자 tag. (ProductionPlanLineGrid pivotTag 와 동일)
const tag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// 효과 가시성 = 드릴다운 오버라이드 우선, 없으면 bucket×chkSum 기본.
export const isPivotVisibleWithDrilldown = (
  binding: string,
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  state: DrilldownState
): boolean => {
  const override = state.get(binding);
  return override === undefined ? isPivotVisible(binding, bucket, chkSum) : override;
};

// 헤더 더블클릭 → 자식 컬럼 가시성 토글. 새 DrilldownState 반환(무시/no-op 이면 동일 참조).
//   월(M_) → 그 달의 주(W_) 토글, 접을 때 보이던 일(D_)도 숨김. 주(W_) → 그 주의 일(D_) 토글.
//   가드(cs:4031~4042 SpdMain_CellDoubleClick): !chkAll 이고 (Monthly&M_ 또는 Weekly&W_)면 무시.
export const toggleDrilldown = (
  state: DrilldownState,
  clickedBinding: string,
  allBindings: readonly string[],
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  chkAll: boolean
): DrilldownState => {
  const kind = pivotKind(clickedBinding);
  if (kind !== 'M' && kind !== 'W') return state; // 월/주 헤더만 드릴다운

  // 폼 가드 — 현재 버킷의 leaf 레벨(Monthly=M_, Weekly=W_) 더블클릭은 chkAll 아니면 무시.
  if (
    !chkAll &&
    ((kind === 'M' && bucket === BUCKET.MONTHLY) || (kind === 'W' && bucket === BUCKET.WEEKLY))
  ) {
    return state;
  }

  const eff = (b: string): boolean => isPivotVisibleWithDrilldown(b, bucket, chkSum, state);
  const next = new Map(state);

  if (kind === 'M') {
    const ym = tag(clickedBinding).slice(0, 6);
    for (const b of allBindings) {
      const k = pivotKind(b);
      if (k === 'W' && tag(b).slice(0, 6) === ym) {
        next.set(b, !eff(b)); // 주 토글
      } else if (k === 'D' && tag(b).slice(0, 6) === ym && eff(b)) {
        next.set(b, false); // 접기 시 보이던 일 숨김
      }
    }
    return next;
  }

  // kind === 'W' — 그 주(연도+ISO 주차)의 일만 토글.
  const t = tag(clickedBinding);
  const year = t.slice(0, 4);
  const weekNum = Number(t.slice(6)) || Number(t.slice(4, 6));
  for (const b of allBindings) {
    if (pivotKind(b) !== 'D') continue;
    const d = tag(b);
    if (d.slice(0, 4) === year && isoWeek(d) === weekNum) {
      next.set(b, !eff(b)); // 일 토글
    }
  }
  return next;
};
