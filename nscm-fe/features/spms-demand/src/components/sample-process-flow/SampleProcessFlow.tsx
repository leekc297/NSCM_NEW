import { useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';

import { useSessionStore } from '@shared/stores';

import { usePendingBuildStore } from '../../lib/pendingBuild';
import { ProcessFlow } from '../process-flow';
import type { SelectedBuild } from '../sample-status-tree/sampleStatusTree.utils';

import {
  findProcessIndex,
  type SampleProcessRow,
  toProcessMenuId,
  toProcessTabData,
} from './sampleProcessFlow.utils';

// SPMS 공통 — 샘플 현황 Process 흐름 바 (생산요청 → 계획수율 → Spec. → 생산량 확정 → 요청품의 →
// 제작품의 → 계획반영). SDM2010/SDM2020 이 공유한다.
//   단계 정의·건수·상태는 P_SDMxxxx_GET_PJT_SAMPLE_PROCESS 커서가 단일 원천 — FE 는 단계명을 하드코딩하지
//   않고 상태도 재파생하지 않는다 (sampleProcessFlow.utils). 현재 화면 단계는 선택 표시(selectedIndex).
//   ⭐ 단계 클릭 = 그 단계 화면으로 이동 (커서 ATTRIBUTE1 = 메뉴 ID). MDI 탭 열기/전환은 앱 셸의
//     '/view/:mnuId' 딥링크 계약이 담당한다 — 이미 열려 있으면 그 탭을 활성화하고, 없으면 새로 연다
//     (apps/web RouterSync). 여기서 MDI 스토어를 직접 건드리지 않는 이유다.

interface Props {
  rows: SampleProcessRow[];
  /** 현재 화면이 담당하는 단계 코드 (예: SDM2020 = 'PLAN_YIELD') — 해당 단계를 선택 표시 */
  currentProcess?: string;
  /** 현재 선택 빌드 — 단계 클릭 이동 시 넘어가는 화면에 인계해 그 화면이 바로 선택하게 한다 (lib/pendingBuild) */
  build?: SelectedBuild;
}

export const SampleProcessFlow = ({ rows, currentProcess, build }: Props) => {
  const navigate = useNavigate();
  const findMenuPath = useSessionStore(state => state.findMenuPath);
  const setPendingBuild = usePendingBuildStore(state => state.setPendingBuild);

  const data = useMemo(() => toProcessTabData(rows), [rows]);
  const selectedIndex = useMemo(
    () => findProcessIndex(rows, currentProcess),
    [rows, currentProcess]
  );

  const handleSelect = useCallback(
    (index: number) => {
      const menuId = toProcessMenuId(rows[index]);
      if (!menuId) return; // 메뉴가 안 붙은 단계 — 클릭 무시
      // 권한 없는 메뉴로 보내면 셸이 탭을 못 열어 빈 화면이 된다 — 세션 메뉴에 있을 때만 이동
      if (!findMenuPath(menuId)) return;
      if (build) setPendingBuild({ menuId, build }); // 이동 전에 실어 둔다 — 수신 화면이 마운트/활성화되며 소비
      void navigate(`/view/${encodeURIComponent(menuId)}`);
    },
    [rows, build, findMenuPath, setPendingBuild, navigate]
  );

  if (data.length === 0) return null;
  return <ProcessFlow data={data} selectedIndex={selectedIndex} onSelect={handleSelect} />;
};
