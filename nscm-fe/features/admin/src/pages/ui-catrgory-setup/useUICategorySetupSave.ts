import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import { useMutation, useQueryClient } from '@foundation/query-client';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from './ui-category-setup.constants';

/**
 * 이 화면 전용 저장 뮤테이션 — 공통 useProcMutation 을 쓰지 않는 이유.
 *
 * 저장이 실패했는데도 "성공적으로 저장되었습니다!" 토스트가 뜨고 재조회로 넘어가는 문제가 있다
 * (2026-09-16 리포트 — SP 가 ORA-20001 로 막았는데 화면은 성공으로 보였다).
 * 원인은 axios 에러 인터셉터가 HTTP 500 을 reject 가 아니라 **성공 응답으로 되돌려 보내는** 데 있다
 * (packages/foundation/src/apis/axios-interceptors.ts 의 `case 500: return error.response`).
 * 에러 인터셉터에서 값을 반환하면 axios 는 그 요청을 성공으로 처리하고, 그 경로는 성공 인터셉터를
 * 다시 타지 않으므로 code / O_RESULT_CURSOR 검사도 건너뛴다 -> mutationFn 정상 resolve ->
 * useProcMutation 의 onSuccess(토스트 + invalidateQueries) 가 그대로 실행된다.
 *
 * 인터셉터는 전 화면 공용이라 손대지 않고, 이 화면에서만 apiClient.post 로 직접 호출해
 * **HTTP 상태코드를 보고** 실패를 판정한다 — apiClient.callMutationProc 은 response.data 만
 * 돌려주기 때문에 그걸 쓰면 status 가 사라진다.
 *
 * 나머지 동작(성공 토스트 / 실패 alert / 저장 후 재조회)은 useProcMutation 과 동일하게 맞췄다.
 * 정본 = features/master/src/pages/sales-site-project-model/useSalesSiteProjectModelSave.ts.
 */
export const useUICategorySetupSave = <
  S extends SheetName<MENU_ID>,
  RS extends ResponseKeys<MENU_ID, S> = ResponseKeys<MENU_ID, S>,
>({
  sheetName,
  tabId,
}: {
  sheetName: S;
  tabId: string;
}) => {
  const { t } = useTranslation();
  const { setToast, setAlert } = useMessageStore.getState();
  const queryClient = useQueryClient();

  return useMutation({
    mutationKey: [tabId, sheetName, BUTTON_TYPE.SAVE, {}],
    // 저장은 멱등하지 않다 — 실패분 재전송은 중복 insert 로 이어질 수 있어 재시도하지 않는다.
    retry: 0,

    mutationFn: async (data: ResponseData<MENU_ID, S, RS>[]) => {
      const response = await apiClient.post<MutateResponse, MutateRequest<MENU_ID, S, RS>>(
        `${MENU_ID}/${sheetName}/${BUTTON_TYPE.SAVE}/call-proc`,
        { data }
      );

      // 500 응답 본문은 타입 보장이 없다(빈 본문/다른 스키마 가능) -> 전부 옵셔널로 접근한다.
      const result = response.data?.result as MutateResponse | undefined;
      const errMsg = typeof result?.errMsg === 'string' ? result.errMsg : '';

      // 500/403 은 인터셉터가 성공으로 되돌리므로 status 를 직접 본다.
      // code / errMsg 는 200 으로 내려오는 실패까지 걸러내기 위한 보조 판정.
      if (response.status >= 400 || Number(response.data?.code) || errMsg) {
        throw new Error(
          errMsg || response.data?.message || t('MSG00003', '_저장에 실패하였습니다.')
        );
      }

      return response.data;
    },
    onSuccess: () => {
      // 두 시트(column/measure)가 한 조회 응답에 함께 실리므로 탭 전체를 무효화한다.
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    },
    onError: (error: Error) => {
      void setAlert({
        type: 'alert',
        content: error.message || t('MSG00003', '_저장에 실패하였습니다.'),
      });
    },
  });
};
