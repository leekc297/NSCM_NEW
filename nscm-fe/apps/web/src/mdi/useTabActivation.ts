// useTabActivation — 지연 마운트(lazy keep-alive) + LRU 언마운트 이력.
//
// ViewContainer 는 이 이력(activated)에 있는 탭만 마운트한다. 탭은 처음 활성화되는 순간
// 마운트되고, 그 뒤로는 keep-alive 로 계속 살아있다(다시 클릭해도 재조회 없음).
//
// 다만 무한정 쌓으면 무거운 그리드가 누적돼 메모리가 계속 증가하므로(실측: 그리드 인스턴스가
// 탭과 1:1로 증가), MAX_MOUNTED_TABS 를 넘으면 가장 오래 활성화되지 않은(LRU) 탭부터
// 언마운트한다. mru 배열이 활성화 최신순(앞이 가장 최근)을 담는다.
//   - 활성 탭(방금 activate 된 tabId)과 보호 대상(dirty 탭)은 언마운트하지 않는다.
//   - 언마운트해도 검색조건/필터/컬럼은 탭 스토어(모듈 Map)에, 결과는 react-query 캐시에
//     살아있어 재방문 시 복원된다(mdi.config MAX_MOUNTED_TABS 주석 참고).
//
// 이 스토어는 의도적으로 영속화하지 않는다(createStandardStore = sessionStorage 미저장).
//  - 저장하면 새로고침 후 "이전에 열어봤던 모든 탭"이 다시 마운트되어(→ 전부 컬럼/그리드 조회)
//    지연 마운트가 무의미해진다. 새로고침 시 활성 탭 하나만 조회되게 하려면 이력이 초기화돼야 한다.
//  - 모듈 레벨 스토어라 ViewContainer 리마운트(홈 ↔ /view 라우트 전환)에도 이력이 유지되고,
//    페이지 새로고침 시에만(모듈 재평가) 초기화된다.
import { createStandardStore } from '@shared/stores';

import { MAX_MOUNTED_TABS } from './mdi.config';

interface TabActivationState {
  /** 마운트된 탭 id 집합 (Record 로 얕은 비교/불변 갱신) */
  activated: Record<string, true>;
  /** 활성화 최신순 — mru[0] 이 가장 최근. LRU 언마운트는 뒤(오래된 것)부터 고른다. */
  mru: string[];
  /**
   * 탭을 활성화(마운트 대상 등록)하고, 상한 초과 시 LRU 언마운트한다.
   * @param protectedIds 언마운트에서 제외할 탭(예: dirty 탭). 활성 탭(tabId)은 항상 보호된다.
   */
  activate: (tabId: string, protectedIds?: readonly string[]) => void;
  /** 탭을 닫을 때 이력에서 제거 */
  deactivate: (tabId: string) => void;
  /** 열린 탭 목록에 맞춰 이력을 정리 — 닫힌 탭을 제거해 LRU 카운트가 열린 탭만 세게 한다. */
  pruneTo: (openTabIds: readonly string[]) => void;
}

export const useTabActivation = createStandardStore<TabActivationState>(
  set => ({
    activated: {},
    mru: [],
    activate: (tabId, protectedIds = []) =>
      set(state => {
        // MRU 갱신 — tabId 를 맨 앞으로.
        const prev = state.mru.indexOf(tabId);
        if (prev !== -1) state.mru.splice(prev, 1);
        state.mru.unshift(tabId);
        state.activated[tabId] = true;

        // 상한 초과 시 LRU 언마운트 — mru 뒤(오래된 것)부터, 활성 탭과 보호 대상은 건너뛴다.
        const protectedSet = new Set(protectedIds);
        for (
          let i = state.mru.length - 1;
          i >= 0 && Object.keys(state.activated).length > MAX_MOUNTED_TABS;
          i--
        ) {
          const candidate = state.mru[i];
          if (candidate === tabId) continue; // 방금 활성화된 탭(= 활성 탭) 보호
          if (protectedSet.has(candidate)) continue; // dirty 등 보호 대상
          if (!state.activated[candidate]) {
            state.mru.splice(i, 1); // 이미 언마운트된 잔재 정리
            continue;
          }
          delete state.activated[candidate];
          state.mru.splice(i, 1);
        }
      }),
    deactivate: tabId =>
      set(state => {
        delete state.activated[tabId];
        const idx = state.mru.indexOf(tabId);
        if (idx !== -1) state.mru.splice(idx, 1);
      }),
    pruneTo: openTabIds =>
      set(state => {
        const open = new Set(openTabIds);
        for (const id of Object.keys(state.activated)) {
          if (!open.has(id)) delete state.activated[id];
        }
        state.mru = state.mru.filter(id => open.has(id));
      }),
  }),
  'tab-activation'
);
