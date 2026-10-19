import { useMemo } from 'react';

import type { ProcessTabDataProps } from '@shared/lges';

import { ProcessFlow } from '../../../components/process-flow';

// SDM1010 프로세스 흐름 바 — 설계서 프로세스 영역
//   (생산요청 → 계획수율 → Spec. → 생산량확정 → 요청품의 → 제작품의 → 생산반영).
// 단계별 건수를 내려줄 SP 가 아직 없어 단계 정의/기본 건수는 설계서 캡처 값으로 두고,
// SP 연동 시 페이지가 steps 로 실건수를 내려준다. 단계 상태는 건수에서 파생한다
// (완료 = current ≥ total, 진행 = current > 0, 대기 = 0건). 도넛 % 는 LGES ProcessTabItem 이
// current/total 로 자체 계산하므로 여기서 만들지 않는다.

export interface ProjectProcessStep {
  /** 단계명 — 라벨 코드(LBL) 확정 시 t() 로 교체 */
  name: string;
  /** 완료 건수 */
  current: number;
  /** 전체 건수 */
  total: number;
  /** 지연 건수 — SDM 공통 ProcessFlow 래퍼가 표시 영역을 숨기지만 계약상 전달은 유지 */
  delay?: number;
}

// 설계서 캡처 기준 기본값 — SP 연동 전 화면 확인용
const DEFAULT_STEPS: ProjectProcessStep[] = [
  { name: '생산요청', current: 1, total: 1 },
  { name: '계획수율', current: 1, total: 2 },
  { name: 'Spec.', current: 0, total: 2 },
  { name: '생산량확정', current: 0, total: 2 },
  { name: '요청품의', current: 0, total: 2 },
  { name: '제작품의', current: 0, total: 2 },
  { name: '생산반영', current: 0, total: 2 },
];

type StepStatus = ProcessTabDataProps['item']['status'];

const statusOf = (step: ProjectProcessStep): StepStatus => {
  if (step.total > 0 && step.current >= step.total) return 'done';
  if (step.current > 0) return 'inProgress';
  return 'standBy';
};

interface Props {
  steps?: ProjectProcessStep[];
}

export const ProjectProcessFlow = ({ steps = DEFAULT_STEPS }: Props) => {
  const data = useMemo<ProcessTabDataProps[]>(
    () =>
      steps.map((step, index) => ({
        id: index,
        item: {
          status: statusOf(step),
          tabName: step.name,
          currentAmount: step.current,
          totalAmount: step.total,
          delay: step.delay ?? 0,
        },
        contents: null,
      })),
    [steps]
  );

  return <ProcessFlow data={data} hoverStyleDisabled />;
};
