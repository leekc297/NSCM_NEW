/**
 * SSP0201 저장 실행체인 — **수정행과 신규행을 한 흐름으로** 처리한다.
 *
 * AS-IS `SaveButton()`(cs:764)은 저장 1회에 변경요청번호를 **한 번만** 채번하고(2단계, L783~794)
 * 그 번호로 수정행 DRAFTING(GetERPInterface 2번 루프)과 신규행 체인(5·6단계)을 모두 처리한다.
 *
 * 종전 TO-BE 는 두 체인이 따로 있었고 `handleSave` 가
 *   `if (inserted.length > 0) { 신규체인; return; }` 로 갈라서, **같이 수정한 기존행이 저장되지 않았다**.
 * 번호도 두 경로가 각각 받아 한 번의 저장이 서로 다른 변경요청번호로 흩어졌다.
 *
 * 순서(이 함수의 계약) — 단계마다 실패하면 **그 자리에서 멈춘다**:
 *   4  변경요청번호 1회 채번. 빈 값이면 아무 저장도 보내지 않는다.
 *   5  수정행(CRUD_TYPE 'I' 아닌 변경행) DRAFTING — 묶음 순차.
 *   6  신규행(CRUD_TYPE 'I') SAVE_NEW -> SEARCH_NEW -> DRAFTING — 순차.
 *      **5가 실패하면 6은 돌지 않는다.**
 *
 * 이 파일은 UI 를 모른다 — alert/toast/재조회는 호출부(화면) 몫이다. 그래서 API 만 mock 하면
 * 흐름 전체를 테스트할 수 있다(shipmentChangeRequestSaveChain.test.ts).
 *
 * 신규행이 수정 묶음에 섞일 염려는 없다:
 *   `draftingModifyGroups` 의 대상 action 은 M/D 뿐이고(묶음 seed), 같은 SO 묶음 **멤버** 자격은
 *   `ERP_SO_NO` 일치를 요구한다. 신규행은 `buildCopiedRow` 가 `ERP_SO_NO` 를 복사하지 않으므로
 *   공백이라 어느 묶음에도 들어가지 않는다. 즉 한 행이 두 경로로 두 번 전송되지 않는다.
 */

import { isInsertedRow } from './shipmentChangeRequestEditLock';
import {
  draftingModifyGroups,
  submitDraftingModifySave,
} from './shipmentChangeRequestModifySave';
import {
  buildNewRowSearchFilterFromRows,
  fetchChangeReqNo,
  fetchNewRowsForDrafting,
  isDraftingTargetsComplete,
  pickOwnNewDraftingTargets,
  submitConfirmNew,
  submitNewDrafting,
} from './shipmentChangeRequestNewSave';

type Row = Record<string, unknown>;

/** 실패한 단계. 호출부가 안내 문구를 고르는 축이다. */
export type SaveChainStage = 'reqNo' | 'modify' | 'new';

export interface SaveChainSession {
  userId: string;
  /** 세션에 부서 필드가 없어 현재는 빈 값(SP 는 APPROVAL_DEPT 갱신에만 쓴다). */
  userDeptId: string;
  /** SEARCH_NEW 라벨 조인용 — 세션 langCd. */
  language: string;
}

export interface SaveChainResult {
  ok: boolean;
  /** 실패 단계. ok 면 undefined. */
  failedStage?: SaveChainStage;
  /** 실패 상세코드 — modify 는 SP RESULT_CODE('X' 등), new 는 CONFIRM_NEW code('N'/'F'). */
  failedCode: string;
  /** 수정 저장 성공 행 수. */
  modifiedCount: number;
  /** 신규 DRAFTING 성공 행 수. */
  createdCount: number;
  /** 성공 토스트 건수 = modifiedCount + createdCount. */
  savedCount: number;
  /**
   * 보낼 것이 아예 없었나(수정 묶음 0 + 신규 0).
   * 변경행이 전부 `CHANGE_TYPE='P'` 이거나 CRUD_TYPE 없이 `EDIT_MAIN='Y'` 만 선 경우다.
   * 이때 호출부는 **clearChanges/재조회를 하지 않아야 한다** — 아무것도 보내지 않았는데
   * 화면을 갈아엎으면 사용자 편집이 조용히 사라진다.
   */
  nothingToSend: boolean;
  /** 실제로 쓴 변경요청번호(두 경로가 같은 번호를 썼는지 확인하는 축). */
  changeReqNo: string;
}

const result = (over: Partial<SaveChainResult>): SaveChainResult => ({
  ok: false,
  failedCode: '',
  modifiedCount: 0,
  createdCount: 0,
  savedCount: 0,
  nothingToSend: false,
  changeReqNo: '',
  ...over,
});

export const runSaveChain = async (
  rows: Row[],
  session: SaveChainSession
): Promise<SaveChainResult> => {
  const inserted = rows.filter(isInsertedRow);
  // 수정 묶음 = NonSoNo(행별) + SoNo(같은 SO). CHANGE_TYPE='P' 와 미변경 행은 여기서 빠진다.
  const modifyGroups = draftingModifyGroups(rows);

  if (modifyGroups.length === 0 && inserted.length === 0) {
    return result({ nothingToSend: true });
  }

  // ── 4) 변경요청번호 1회 채번 ────────────────────────────────────────────────
  //   두 경로가 **같은 번호**를 쓴다(AS-IS 동일). 빈 값이면 저장을 시작하지 않는다 —
  //   번호 없이 들어간 ERP 전송행은 되돌릴 경로가 없다.
  const changeReqNo = await fetchChangeReqNo(session.userId);
  if (!changeReqNo) return result({ failedStage: 'reqNo' });

  // ── 5) 수정행 저장 ─────────────────────────────────────────────────────────
  let modifiedCount = 0;
  for (const group of modifyGroups) {
    const modify = await submitDraftingModifySave(group, {
      userId: session.userId,
      userDeptId: session.userDeptId,
      changeReqNo,
    });
    if (modify.outcome !== 'ok') {
      // 신규행은 **시작하지 않는다** — 수정이 깨진 채로 신규를 더 만들면 복구가 어려워진다.
      return result({
        failedStage: 'modify',
        failedCode: modify.code,
        modifiedCount,
        savedCount: modifiedCount,
        changeReqNo,
      });
    }
    modifiedCount += modify.rowCount;
  }

  // ── 6) 신규행 저장 ─────────────────────────────────────────────────────────
  let createdCount = 0;
  if (inserted.length > 0) {
    const partial = { modifiedCount, savedCount: modifiedCount, changeReqNo };

    //   timeZone: TO-BE UserSession 에 타임존 필드가 없다 — 빈 값(SP 가 FN_MULTY_TIME 으로 보정).
    const { code } = await submitConfirmNew(inserted, { userId: session.userId, timeZone: '' });
    if (code !== 'S') {
      return result({ ...partial, failedStage: 'new', failedCode: code });
    }

    //   CONFIRM_ID 를 받으러 신규 전용 조회. 조회조건은 저장한 행에서 만든다(화면 기간 무관).
    const { rows: newRows, outcome } = await fetchNewRowsForDrafting(
      buildNewRowSearchFilterFromRows(inserted, session.language)
    );
    const targets =
      outcome === 'fail' ? [] : pickOwnNewDraftingTargets(newRows, inserted, session.userId);
    //   건수를 못 채우면 DRAFTING 을 시작하지도 않는다(일부만 기록되면 하위 그리드가 반쪽이 된다).
    if (outcome === 'fail' || !isDraftingTargetsComplete(targets, inserted.length)) {
      return result({ ...partial, failedStage: 'new' });
    }

    //   순차 호출 — 행마다 ERP 전송행을 적재하므로 동시에 쏘면 순서가 뒤섞인다.
    for (const row of targets) {
      const ok = await submitNewDrafting(row, changeReqNo, {
        userId: session.userId,
        userDeptId: session.userDeptId,
      });
      if (!ok) {
        return result({
          failedStage: 'new',
          modifiedCount,
          createdCount,
          savedCount: modifiedCount + createdCount,
          changeReqNo,
        });
      }
      createdCount += 1;
    }
  }

  return {
    ok: true,
    failedCode: '',
    modifiedCount,
    createdCount,
    savedCount: modifiedCount + createdCount,
    nothingToSend: false,
    changeReqNo,
  };
};
