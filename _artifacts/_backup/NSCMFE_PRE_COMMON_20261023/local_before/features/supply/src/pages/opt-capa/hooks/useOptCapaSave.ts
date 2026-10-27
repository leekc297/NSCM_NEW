import { apiClient } from '@foundation/apis';

import { MENU_ID, type GridSheet } from '../opt-capa.constants';

export interface OptCapaSaveResult {
  ok: boolean;
  /** 실패 사유 — BE 가 준 message 가 있으면 그것, 없으면 호출부가 기본 문구를 쓴다. */
  message?: string;
}

/**
 * 시트별 저장 — AS-IS `SaveButton` 의 `_sActiveSheetName` 8분기(cs:937-975) 이식.
 *
 * ## 공용 `useProcMutation` 을 쓰지 않는다 (2026-09-26 gap-resolve iter-1, RP-1 해소)
 * SAVE SP 8종의 IN 파라미터가 `sesUserId` 1건(VARCHAR)을 뺀 **전건 `DATA_TP_CD='CLOB'`** 이고
 * (`SCM_ADM_PROC_M` 실측), BE `execBtn` 은 **`JVARCHAR` 만** `'^'`-폴딩하고 `CLOB` 은
 * `params.get(COL_NM)` 을 그대로 바인드한다(`GeneralServiceImpl:34-49` · `BaseService:670`).
 * 그래서 `useProcMutation`(→ `{data:[rows]}` raw 전송)으로 보내면 전 파라미터가 NULL 로 바인딩돼
 * **오류 없이 0건 저장 + 성공 토스트**가 된다(`05_runtime-parity.md` RP-1 / 메모리
 * `save-proc-per-column-caret-fold-fe`). 이 화면은 FE 가 컬럼별로 접은 평면 payload
 * (`buildFlatSavePayload`)를 `call-proc` 으로 직접 보내야 성립한다.
 *
 * 자매 정본: SCP0005 `distributionRoute.saveRequest.ts` · SCP0006 `projectRoute.plantSaveRequest.ts`.
 * 두 화면 모두 같은 이유로 공용 훅 대신 `apiClient.post` 직접 호출을 쓴다(공용 훅 금지의 명시 예외).
 *
 * 훅이 아니라 순수 함수다 — 시트 8개를 조건부로 훅 호출할 수 없어 iter-4 는 `useProcMutation` 8개를
 * 만들어 골라 썼는데, 직접 호출로 바꾸면 그 제약 자체가 사라진다.
 */
/**
 * ## SP 실패는 **공용 `responseInterceptor` 가 throw 로 올린다** — 화면이 다시 판정하지 않는다
 *
 * `PKG_SCP0126` 의 SAVE 8종은 예외를 `RAISE` 하지 않고 `P_RESULT_ERR(O_RESULT_CURSOR, V_MSG)` 로
 * **정상 종료**하며(BODY:3360-3365 외 7곳) 결과 커서에 `CODE='-1'`/`MSG`/`RESULT_CODE='F'` 를 담는다
 * (`P_RESULT_ERR` BODY:147-159 · 성공은 `P_RESULT_OK` BODY:130-143 의 `'0'`/`'SUCCESS'`/`'S'`).
 * BE 는 그 커서를 `result.O_RESULT_CURSOR` 로 올리고(`BaseService.java:684-687` → `:95-99`)
 * `GeneralController.callProc` 은 무조건 `successResponseEntity` 라 **envelope `code` 는 0** 이다.
 *
 * 그런데 그 다음 단에서 공용 `responseInterceptor`(`packages/foundation/src/apis/axios-interceptors.ts:29-34`)가
 * `Number(result?.O_RESULT_CURSOR?.[0]?.CODE)` 가 truthy 면 `throw new Error(MSG, {cause: resultRow})` 한다.
 * `CODE='-1'` → `Number('-1')=-1`(truthy) → throw / `'0'` → 0(falsy) → 통과.
 * **즉 SP 롤백은 아래 `catch` 로 들어오고 `MSG` 가 그대로 사용자 메시지가 된다.**
 *
 * 그래서 화면에 커서 CODE 판정을 다시 두지 않는다 — 같은 사실을 두 곳에 두면 admin/공용 규약이
 * 바뀔 때 한쪽만 따라간다(hook #130). 메모리 `scp0125-save-failure-shows-success-toast` 는
 * **스칼라 OUT**(`O_RESULT_CODE`)만 돌려주는 화면의 함정이고 — 그 값은 응답에 구조적으로 부재하다 —
 * 이 화면은 CURSOR(`PROC_RESULT`)라 그 memory 의 적용 범위 밖이다.
 */
export const submitOptCapaSave = async (
  sheet: GridSheet,
  payload: Record<string, string>
): Promise<OptCapaSaveResult> => {
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${sheet}/SAVE/call-proc`,
      payload
    );
    // 전송 계층 false-success 차단 — 인터셉터가 403/500 은 resolve 한다(`responseErrorInterceptor:57-59`).
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason = (res.data as { message?: string })?.message?.trim();
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (error) {
    // SP 롤백(`CODE='-1'`)이 여기로 온다 — 위 주석 참조. `error.message` = SP 의 `V_MSG`.
    return { ok: false, message: error instanceof Error ? error.message : undefined };
  }
};
