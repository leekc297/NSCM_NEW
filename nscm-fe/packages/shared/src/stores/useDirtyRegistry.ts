import { useCallback, useContext, useEffect, useRef } from 'react';

import { t } from '@foundation/i18n';

import { useTabid } from './createStore';
import { DialogScopeContext } from './useDialogStore';
import { useMessageStore } from './useMessageStore';

/**
 * 미저장 변경(dirty) 레지스트리.
 *
 * DataGrid 가 마운트 시 자신의 dirty 판정 함수를 탭/다이얼로그 스코프 키로 등록하고,
 * 이탈 지점(조회·MDI 탭 닫기·다이얼로그 닫기·브라우저 이탈)이 여기서 집계해 confirm 을 띄운다.
 * wingui 의 viewStore.getViewIsUpdated + MSG_5142 confirm 패턴에 해당한다.
 *
 * zustand 가 아닌 모듈 레벨 Map 인 이유: 판정 함수는 이탈 시점에 pull 방식으로만 호출되고
 * 구독/리렌더가 전혀 필요 없다. 상태화하면 grid 인스턴스가 스토어에 들어가 직렬화·수명 문제만 생긴다.
 */
type DirtyCheck = () => boolean;
type DirtyReset = () => void;

const registry = new Map<string, Set<DirtyCheck>>();
const resetRegistry = new Map<string, Set<DirtyReset>>();

/** MDI 탭 단위 키 (TabIdContext 의 tabId) */
export const tabDirtyKey = (tabId: string) => `tab:${tabId}`;
/** 다이얼로그 스코프 단위 키 (DialogScopeContext 의 scopeId) */
export const scopeDirtyKey = (scopeId: string) => `scope:${scopeId}`;

/** 키들에 함수를 등록하고 해제 함수를 돌려준다 — 판정(check)/되돌리기(reset) 공용. */
const registerToKeys = <F>(map: Map<string, Set<F>>, keys: string[], fn: F): (() => void) => {
  for (const key of keys) {
    let functions = map.get(key);
    if (!functions) {
      functions = new Set();
      map.set(key, functions);
    }
    functions.add(fn);
  }
  return () => {
    for (const key of keys) {
      const functions = map.get(key);
      functions?.delete(fn);
      if (functions?.size === 0) map.delete(key);
    }
  };
};

/**
 * dirty 판정 함수를 키들에 등록한다. 반환된 함수로 해제(그리드 언마운트 시).
 * 같은 그리드가 tab 키와 scope 키(다이얼로그 안일 때)에 동시 등록될 수 있다 —
 * 다이얼로그의 편집분도 "탭을 닫으면 사라지는 변경" 이므로 탭 집계에 포함하는 것이 맞다.
 */
export const registerDirtyCheck = (keys: string[], check: DirtyCheck): (() => void) =>
  registerToKeys(registry, keys, check);

/**
 * 미저장 변경 되돌리기 함수를 키들에 등록한다. 등록 규약은 registerDirtyCheck 과 동일.
 *
 * confirm 에서 사용자가 "확인"(= 버리고 진행)을 누르면 이 함수들이 호출된다.
 * 그리드는 DataGrid 가 자동 등록하므로, 화면은 그리드 밖의 미저장 상태(폼 입력, React state 로
 * 관리하는 신규행 등)가 있을 때만 useDirtyReset 으로 추가 등록하면 된다.
 */
export const registerDirtyReset = (keys: string[], reset: DirtyReset): (() => void) =>
  registerToKeys(resetRegistry, keys, reset);

/** 키에 등록된 판정 중 하나라도 dirty 면 true. 판정 함수가 던져도 이탈이 막히지 않게 무시한다. */
export const isDirtyKey = (key: string): boolean => {
  const checks = registry.get(key);
  if (!checks) return false;
  for (const check of checks) {
    try {
      if (check()) return true;
    } catch {
      // 파괴된 grid 인스턴스 등 — dirty 아님으로 취급
    }
  }
  return false;
};

/**
 * 키에 등록된 미저장 변경을 전부 되돌린다. 되돌리기가 던져도 나머지 대상과 이탈을 막지 않는다.
 * 호출 시점은 confirm "확인" 직후 — 그리드가 아직 살아 있을 때여야 한다.
 */
export const discardDirtyKey = (key: string): void => {
  const resets = resetRegistry.get(key);
  if (!resets) return;
  for (const reset of resets) {
    try {
      reset();
    } catch {
      // 파괴된 grid 인스턴스 등 — 되돌릴 대상이 이미 없음
    }
  }
};

export const isTabDirty = (tabId: string): boolean => isDirtyKey(tabDirtyKey(tabId));
export const isScopeDirty = (scopeId: string): boolean => isDirtyKey(scopeDirtyKey(scopeId));

/** 열린 모든 탭/스코프 중 dirty 존재 여부 — beforeunload 용 */
export const isAnyDirty = (): boolean => [...registry.keys()].some(isDirtyKey);

/**
 * 이탈 상황별 미저장 변경 confirm 메시지.
 * 메시지 코드는 백엔드 admin/message 테이블 기준이며 pnpm gen:i18n 으로 동기화된다.
 * 주의: t() 는 호출 시점에 평가해야 한다 — 모듈 로드 시점에는 locale 이 아직 안 붙어 있다.
 */
const dirtyConfirmMessage = {
  /** 조회(F5/조회 버튼) — 조회는 그리드 데이터를 통째로 덮어쓴다 */
  //   2026-08-13 정정: MSG00704 를 쓰고 있었으나 사내 카탈로그에서 그 ID 는 이미 무관한 메시지
  //   ("Sales Plan Cutoff 완료 후에만 RTF[R+P] 수정이 가능합니다.")가 점유 중이다. 신규 채번한
  //   줄 알았던 ID 가 실제로는 선점돼 있어, 편집 중 조회를 누르는 전 화면에서 엉뚱한 문장이 떴다.
  //   의도한 문구가 실제로 등록된 ID 는 MSG00703 이다 (사내 실측 2026-08-13).
  //
  //   주의: fallback(2번째 인자)은 ID 가 카탈로그에 없을 때만 쓰인다. ID 가 살아 있으면서 내용만
  //   다르면 fallback 이 아니라 남의 문구가 그대로 출력되므로, 화면만 보고는 원인을 찾기 어렵다.
  //   ID 를 바꿀 때는 반드시 사내 admin/message 실제 내용을 확인할 것.
  search: () => t('MSG00703', '_수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?'),
  /** 화면 닫기 — MDI 탭 닫기, 다이얼로그 닫기 */
  //   조회와 같은 ID 를 공유한다 — "이 화면을 닫으시겠습니까?" 문구는 사내 카탈로그에 아직 없다.
  //   그래서 닫기 상황에도 조회 문구가 나온다. 닫기 전용 메시지가 채번되면 그 ID 로 교체할 것.
  close: () => t('MSG00703', '_작업중인 데이터가 있습니다. 이 화면을 닫으시겠습니까?'),
} as const;

export type DirtyConfirmKind = keyof typeof dirtyConfirmMessage;

/**
 * dirty 면 상황에 맞는 confirm 을 띄우고 사용자의 선택을 반환한다. dirty 아니면 즉시 true.
 * 사용처: 조회 실행 전(SubTitle/SearchArea), MDI 탭 닫기 전, 다이얼로그 닫기 전.
 *
 * 확인을 누르면 등록된 변경을 실제로 되돌린다 — confirm 문구가 "작업중인 데이터를 버린다" 는
 * 뜻이기 때문. 되돌리지 않으면 그리드가 넘겨받은 배열(화면 useMemo 결과 · react-query 캐시
 * 배열)에 편집분이 남아, 팝업 재오픈·탭 재진입 때 버린 신규행이 되살아난다.
 */
export const confirmIfDirtyKey = async (key: string, kind: DirtyConfirmKind): Promise<boolean> => {
  if (!isDirtyKey(key)) return true;
  const confirmed = await useMessageStore.getState().setAlert({
    type: 'confirm',
    content: dirtyConfirmMessage[kind](),
  });
  if (confirmed) discardDirtyKey(key);
  return confirmed;
};

export const confirmIfTabDirty = (tabId: string) => confirmIfDirtyKey(tabDirtyKey(tabId), 'close');
export const confirmIfScopeDirty = (scopeId: string) =>
  confirmIfDirtyKey(scopeDirtyKey(scopeId), 'close');

/**
 * 여러 탭을 한 번에 닫을 때(모두 닫기/다른 탭 닫기) — 하나라도 dirty 면 confirm 1회.
 */
export const confirmIfTabsDirty = async (tabIds: string[]): Promise<boolean> => {
  if (!tabIds.some(isTabDirty)) return true;
  const confirmed = await useMessageStore.getState().setAlert({
    type: 'confirm',
    content: dirtyConfirmMessage.close(),
  });
  if (confirmed) tabIds.forEach(tabId => discardDirtyKey(tabDirtyKey(tabId)));
  return confirmed;
};

/**
 * 화면용 편의 훅 — 그리드 외의 미저장 상태(폼 입력, 별도 편집 UI 등)를 dirty 집계에 참여시킨다.
 * 현재 탭 키(+다이얼로그 안이면 스코프 키)에 자동 등록되고 언마운트 시 해제된다.
 * DataGrid 는 이미 내부에서 자동 등록하므로 그리드에는 쓸 필요 없다.
 *
 * @param check   dirty 면 true. 매 렌더 새 함수여도 된다(ref 로 최신 참조 유지).
 * @param enabled false 면 등록 해제 (기본 true)
 *
 * @example
 * // 폼 값이 조회 시점과 다르면 이탈 confirm 대상
 * useDirtyCheck(() => form.formState.isDirty);
 */
export const useDirtyCheck = (check: DirtyCheck, enabled = true): void => {
  const tabId = useTabid();
  const scopeId = useContext(DialogScopeContext);

  const checkRef = useRef(check);
  checkRef.current = check;

  useEffect(() => {
    if (!enabled) return;
    const keys = [tabDirtyKey(tabId)];
    if (scopeId !== null) keys.push(scopeDirtyKey(scopeId));
    return registerDirtyCheck(keys, () => checkRef.current());
  }, [tabId, scopeId, enabled]);
};

/**
 * 다이얼로그용 "가드된 닫기" — 미저장 변경이 있으면 confirm 을 거치고, 확인이면 되돌린 뒤 닫는다.
 *
 * CustomDialog 의 헤더 X 버튼은 이미 같은 가드를 타지만, 화면이 직접 만든 Close/Cancel 버튼은
 * modalClose 를 그대로 불러 가드를 지나친다(확인도 없고 편집분도 남는다).
 *
 * 사용 위치 주의: 반드시 다이얼로그 **안에서 렌더되는 컴포넌트** 에서 호출해야 한다.
 *   DialogScopeContext.Provider 는 CustomDialog 안에 있으므로, CustomDialog 를 렌더하는
 *   화면 본문에서 호출하면 스코프가 null 이라 가드 없이 그대로 닫힌다.
 *   (버튼을 작은 컴포넌트로 감싸 customContentArea 안에서 렌더하면 된다.)
 *
 * 다이얼로그 밖(스코프 없음)에서 호출하면 가드 없이 close 를 그대로 부른다.
 */
export const useGuardedDialogClose = (close: () => void): (() => void) => {
  const scopeId = useContext(DialogScopeContext);
  const closeRef = useRef(close);
  closeRef.current = close;

  return useCallback(() => {
    if (scopeId === null) {
      closeRef.current();
      return;
    }
    void confirmIfScopeDirty(scopeId).then(confirmed => {
      if (confirmed) closeRef.current();
    });
  }, [scopeId]);
};

/**
 * 화면용 편의 훅 — 이탈 confirm 에서 "확인" 을 눌렀을 때 그리드 밖의 미저장 상태를 함께 되돌린다.
 * 등록 스코프는 useDirtyCheck 과 동일(현재 탭 + 다이얼로그 안이면 스코프).
 * 그리드 자체는 DataGrid 가 자동 등록하므로 여기에 쓸 필요가 없다.
 *
 * @param reset   되돌리기. 매 렌더 새 함수여도 된다(ref 로 최신 참조 유지).
 * @param enabled false 면 등록 해제 (기본 true)
 *
 * @example
 * // 신규행을 React state 로 관리하는 화면 — 그리드만 정리하면 다음 렌더에 state 가 다시 넣는다
 * useDirtyReset(() => setInsertedRows([]));
 */
export const useDirtyReset = (reset: DirtyReset, enabled = true): void => {
  const tabId = useTabid();
  const scopeId = useContext(DialogScopeContext);

  const resetRef = useRef(reset);
  resetRef.current = reset;

  useEffect(() => {
    if (!enabled) return;
    const keys = [tabDirtyKey(tabId)];
    if (scopeId !== null) keys.push(scopeDirtyKey(scopeId));
    return registerDirtyReset(keys, () => resetRef.current());
  }, [tabId, scopeId, enabled]);
};
