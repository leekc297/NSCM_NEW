// 드릴다운 가시성 오버라이드 — 헤더 더블클릭으로 월→주→일 전개/접기(design 03 §2.3 R18 /
//   AS-IS SetDblClickColumnShowHide). 자매 SCP0013 drilldown 이식. binding → visible 오버라이드 맵.

import { BUCKET_TYPE } from '../production-plan.constants';

import { isoWeek } from './productionPlanDerive';
import { isPivotVisible, pivotKind } from './productionPlanEditLock';

export type DrilldownState = ReadonlyMap<string, boolean>;
export const EMPTY_DRILLDOWN: DrilldownState = new Map();

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

// 헤더 더블클릭 → 자식 컬럼 가시성 토글. 가드(design 03 §2.3 / §3 R19, AS-IS SetDblClickColumnShowHide
//   cs L3042-3053): !chkAll 이고 현재 버킷 leaf(Monthly M_/Weekly W_) 더블클릭이면 무시. chkAll 체크 시엔
//   동일 단위 더블클릭도 토글 허용(M4 해소 — 이전 회차는 chkAll 무관하게 상시 무시했다).
export const toggleDrilldown = (
  state: DrilldownState,
  clickedBinding: string,
  allBindings: readonly string[],
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  chkAll: boolean
): DrilldownState => {
  const kind = pivotKind(clickedBinding);
  if (kind !== 'M' && kind !== 'W') return state;
  if (
    !chkAll &&
    ((kind === 'M' && bucket === BUCKET_TYPE.MONTHLY) ||
      (kind === 'W' && bucket === BUCKET_TYPE.WEEKLY))
  ) {
    return state;
  }

  const eff = (b: string): boolean => isPivotVisibleWithDrilldown(b, bucket, chkSum, state);
  const next = new Map(state);

  if (kind === 'M') {
    const ym = tag(clickedBinding).slice(0, 6);
    for (const b of allBindings) {
      const k = pivotKind(b);
      if (k === 'W' && tag(b).slice(0, 6) === ym) next.set(b, !eff(b));
      else if (k === 'D' && tag(b).slice(0, 6) === ym && eff(b)) next.set(b, false);
    }
    return next;
  }

  const t = tag(clickedBinding);
  const ym = t.slice(0, 6); // 주 묶음은 달 단위(월에 걸친 주는 달별 분리)
  const weekNum = Number(t.slice(6)) || Number(t.slice(4, 6));
  for (const b of allBindings) {
    if (pivotKind(b) !== 'D') continue;
    const d = tag(b);
    if (d.slice(0, 6) === ym && isoWeek(d) === weekNum) next.set(b, !eff(b));
  }
  return next;
};
