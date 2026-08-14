import { flushSync } from 'react-dom';

import { clearPersistedCache, useQueryClient } from '@foundation/query-client';

import { resetAllStores } from '../stores/storeRegistry';

export const useClearAppData = () => {
  const queryClient = useQueryClient();

  /**
   * 로그아웃 후 로컬 상태 전체 정리 —
   * 열린 탭/스토어 + react-query 캐시 + sessionStorage + 영속 캐시(IndexedDB).
   *
   * queryClient.clear() 는 "마운트된 옵저버가 있는" 쿼리를 재조회시킨다(캐시가 사라지니 다시 받는다).
   * 호출부는 서버 세션(/user/logout)을 이미 끊은 상태라 그 재조회는 전부 401 이 되고,
   * retry:1 때문에 요청은 2배로 나가며 전역 onError 알림까지 뜬다.
   *
   * 실제로 새던 건 홈 쿼리(useHomeNotices/useSystemAdmins)다. 이 훅들은 조기 반환보다 위에서
   * 호출되므로 로그아웃 후에도 계속 마운트돼 있고, enabled:isLogin 이 false 로 바뀌는 것은
   * "다음 렌더"다. clearAllData 는 logout() 의 set 과 같은 tick 이라 그 커밋 전에 실행된다
   * → 아직 enabled:true 인 옵저버가 재조회한다.
   * (MDI 탭 페이지 쿼리는 탭이 닫히며 언마운트가 먼저 이겨서 원래도 재조회되지 않았다.)
   *
   * flushSync 로 스토어 리셋과 (직전 logout 의) isLogin=false 를 먼저 커밋해
   * 언마운트/enabled:false 를 확정한 뒤 캐시를 비운다.
   *
   * 마지막 clearPersistedCache 는 IndexedDB 레코드 자체를 지운다. queryClient.clear() 만으로는
   * 영속 구독자가 "빈 상태"를 덮어쓸 뿐 레코드가 남고, sessionStorage.clear() 로 캐시 키의
   * 시드(rq-session-id)까지 날아가서 다음 새로고침 때 새 키가 생기면 그 레코드는 회수되지 않는다.
   * 순서 중요: clear() 가 유발하는 write 보다 뒤에 있어야 삭제가 되살아나지 않는다.
   */
  const clearAllData = async () => {
    flushSync(() => {
      resetAllStores();
    });
    queryClient.clear();
    sessionStorage.clear();
    await clearPersistedCache();
  };

  return { clearAllData };
};
