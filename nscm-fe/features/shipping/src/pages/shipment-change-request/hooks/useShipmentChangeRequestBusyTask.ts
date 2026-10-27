import { useMutation } from '@foundation/query-client';

/**
 * 저장/취소/요청완료처럼 **사용자 조작을 막아야 하는 비동기 작업**을 공용 busy 스피너에 물린다.
 *
 * 왜 필요한가(사용자 요청 2026-10-13 "저장되는 도중 조회할 때처럼 스피너가 동작해야 할 것 같다"):
 *   전역 스피너는 `MDIContainer` 의 `useIsBusy([tabId])` 가 켠다. 그 훅은 react-query 의
 *   `useIsFetching`/`useIsMutating` **카운터만** 센다(query-client.ts:161~173). 조회는
 *   `useTabProcQuery` 로 react-query 를 타므로 자동으로 잡히지만, 이 화면의 저장 체인은
 *   `apiClient.post` **직호출**이라(PROC_M 에 JVARCHAR 가 없어 공용 `useProcMutation` 을 못 쓴다
 *   — ShipmentChangeRequest.tsx 헤더 주석) 두 카운터 어디에도 올라가지 않았다. 그래서 저장 중에
 *   화면이 멀쩡해 보이고 다른 버튼을 누를 수 있었다.
 *
 *   -> 작업을 `useMutation` 으로 감싸고 `mutationKey` 를 **`[tabId, …]`** 로 둔다.
 *      `useIsMutating({ mutationKey: [tabId] })` 는 **접두 일치**라 이 키가 그대로 집계된다.
 *
 * 주의 — `retry: 0` 이 필수다:
 *   query-client 의 mutation 기본값이 **`retry: 1`**(query-client.ts:155~157)이다. 그대로 두면
 *   저장 체인이 실패했을 때 **한 번 더 실행**된다 — 신규행이 중복 채번·중복 적재되고, 이미 성공한
 *   앞 단계(CONFIRM_NEW 등)가 두 번 돌아 ERP 전송행까지 번진다. 재시도는 사용자 판단이어야 한다.
 */
export const useShipmentChangeRequestBusyTask = (tabId: string) => {
  const { mutateAsync } = useMutation({
    // 접두가 tabId 라 useIsBusy([tabId]) 에 잡힌다. 뒤 세그먼트는 다른 화면/용도와의 충돌 방지용.
    mutationKey: [tabId, 'ssp0201', 'busy'],
    mutationFn: (task: () => Promise<void>) => task(),
    retry: 0,
  });

  /**
   * `task` 를 스피너로 감싸 실행한다. 반환 Promise 는 **항상 resolve** 한다 —
   *   호출부가 `void` 로 띄우므로 reject 가 새면 unhandled rejection 이 된다.
   *   각 핸들러가 이미 자기 실패를 alert 로 번역하고 있어, 여기서는 삼키고 흐름만 끝낸다.
   */
  return (task: () => Promise<void>): Promise<void> =>
    mutateAsync(task).catch(() => undefined);
};
