import { useMemo } from 'react';

import { CascadeDropdown } from '@shared/components';

import { buildPlanVersionTree, type PlanVersionLevel } from './planVersionTree';

export type { PlanVersionLevel } from './planVersionTree';

export interface PlanVersionCascadeProps {
  // 종속 콤보 단계 목록(순서 = 열 순서). 참조 안정화를 위해 호출부에서 useMemo 로 감싸 넘긴다.
  levels: PlanVersionLevel[];
  // 전량 콤보라 DIVISION_ID 로 먼저 거른다.
  divisionId: string;
  // 선택값(name 키 객체) — 예: { planDate, planType, planSeq }.
  value: Record<string, string>;
  onChange: (value: Record<string, string>) => void;
  // CascadeDropdown 패스스루(레이아웃/라벨).
  gridSize?: number;
  variant?: 'horizontal' | 'vertical';
  labelAlign?: 'left' | 'right';
  formItemClassName?: string;
}

/**
 * Plan 버전 종속 콤보(공유) — Plan Date → Plan Type → Seq 처럼 반환 컬럼으로 이어지는 전량 콤보를
 * 하나의 컬럼 팝업(CascadeDropdown)으로 보여준다. levels 길이로 단계 수가 정해져 2개/3개/N개를 모두
 * 지원한다. 선택값 매핑(store 1-요소 배열 등)과 기본값 effect 는 호출 화면이 value/onChange 로 담당한다.
 */
export const PlanVersionCascade = ({
  levels,
  divisionId,
  value,
  onChange,
  gridSize,
  variant,
  labelAlign,
  formItemClassName,
}: PlanVersionCascadeProps) => {
  const tree = useMemo(() => buildPlanVersionTree(levels, divisionId), [levels, divisionId]);
  const cascadeLevels = useMemo(
    () => levels.map(l => ({ name: l.name, label: l.label, required: l.required })),
    [levels]
  );

  return (
    <CascadeDropdown
      tree={tree}
      levels={cascadeLevels}
      value={value}
      onChange={onChange}
      gridSize={gridSize}
      variant={variant}
      labelAlign={labelAlign}
      formItemClassName={formItemClassName}
    />
  );
};
