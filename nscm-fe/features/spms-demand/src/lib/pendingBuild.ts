import { createStandardStore } from '@shared/stores';

import type { SelectedBuild } from '../components/sample-status-tree/sampleStatusTree.utils';

// ⭐ SPMS 공통 — 화면 간 빌드 인계 (2026-09-04 요청).
//   ProcessFlow 단계 클릭으로 다른 단계 화면(/view/:mnuId)으로 넘어갈 때, 지금 보고 있던 빌드를 실어
//   보내 넘어간 화면이 그 빌드를 바로 선택(Tree 강조 + 조회)하게 한다.
//   MDI 는 keep-alive 라 URL/마운트로는 전달할 수 없다 — 탭 무관 전역 store 1개로 인계한다.
//   menuId 로 수신 화면을 지정한다 — SDM2010/SDM2020 이 동시에 마운트돼 있어도 지정된 화면만 소비한다.
//   소비 = 수신 화면이 읽은 즉시 clear (1회성).

export interface PendingBuild {
  /** 수신 화면 메뉴 ID (예 'SDM2020') */
  menuId: string;
  build: SelectedBuild;
}

interface State {
  pending: PendingBuild | null;
}

interface Action {
  setPendingBuild: (pending: PendingBuild) => void;
  clearPendingBuild: () => void;
}

export const usePendingBuildStore = createStandardStore<State & Action>(
  set => ({
    pending: null,
    setPendingBuild: pending =>
      set(state => {
        state.pending = pending;
      }),
    clearPendingBuild: () =>
      set(state => {
        state.pending = null;
      }),
  }),
  'spms-pending-build'
);

/** 수신 화면용 — 내 메뉴 앞으로 온 빌드만 (아니면 null) */
export const takePendingBuild = (menuId: string): SelectedBuild | null => {
  const { pending, clearPendingBuild } = usePendingBuildStore.getState();
  if (!pending || pending.menuId !== menuId) return null;
  clearPendingBuild();
  return pending.build;
};
