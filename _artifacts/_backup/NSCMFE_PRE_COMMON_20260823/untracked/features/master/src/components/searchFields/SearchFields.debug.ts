/**
 * SearchFields.debug — 조회조건 종속 리셋 추적용 **임시 디버그 훅** (2026-08-23 복구본).
 *
 * ## 왜 있나
 * `CustomerFcstUploadForm` 등 일부 화면이 `logSearchReset` 을 import 하고 `debugLabel` prop 을
 * 넘기는데(원저자 주석: "임시 로컬 디버그 — 확인 끝나면 이 import 와 호출, debugLabel prop 을 지운다")
 * 정작 이 모듈이 리포지토리에 없어 **type-check 가 전 패키지에서 실패**했다(TS2307/TS2322).
 * 화면 코드를 건드리지 않고 컴파일을 복구하기 위해 계약만 되살린 최소 구현이다.
 *
 * ## 동작
 * - 기본 **no-op**. 콘솔 출력 없음 (CLAUDE.md §4 — `console.log` 금지).
 * - 개발 중 확인이 필요할 때만 링 버퍼(최근 200건)에 쌓는다. 브라우저에서
 *   `globalThis.__searchFieldDebug?.dump()` 로 열람, `enable()/disable()` 로 토글.
 * - 프로덕션 번들에서도 부작용 0 (모듈 로드 시 아무것도 하지 않는다).
 *
 * ## 정리 대상
 * 원저자 의도대로 화면에서 `logSearchReset` 호출과 `debugLabel` prop 을 제거하면 이 파일도 삭제한다.
 */

interface SearchResetEntry {
  /** 화면·필드 식별 문자열 (= 컴포넌트에 넘기는 debugLabel 과 같은 규약) */
  label: string;
  /** 리셋 시점의 값 스냅샷 등 임의 payload */
  payload?: unknown;
  /** 기록 순번 (시각은 남기지 않는다 — 재현 로그를 캡처 순서로만 본다) */
  seq: number;
}

const MAX_ENTRIES = 200;
const buffer: SearchResetEntry[] = [];
let enabled = false;
let seq = 0;

const api = {
  enable: () => {
    enabled = true;
  },
  disable: () => {
    enabled = false;
  },
  /** 기록된 항목 스냅샷 (오래된 것부터) */
  dump: (): SearchResetEntry[] => [...buffer],
  clear: () => {
    buffer.length = 0;
    seq = 0;
  },
};

// 브라우저 콘솔에서만 접근하는 핸들 — 전역 오염 최소화를 위해 존재 여부 확인 후 부착
type DebugGlobal = typeof globalThis & { __searchFieldDebug?: typeof api };
const g = globalThis as DebugGlobal;
if (g.__searchFieldDebug === undefined) {
  g.__searchFieldDebug = api;
}

/**
 * 조회조건 종속 리셋 추적. **활성화 전에는 아무 일도 하지 않는다.**
 *
 * @param label   화면/필드 식별자 (예: `'DMF0014 customer-fcst-upload / division change'`)
 * @param payload 리셋 전후 값 등 자유 형식
 */
export const logSearchReset = (label: string, payload?: unknown): void => {
  if (!enabled) return;
  buffer.push({ label, payload, seq: ++seq });
  if (buffer.length > MAX_ENTRIES) buffer.shift();
};

export type { SearchResetEntry };
