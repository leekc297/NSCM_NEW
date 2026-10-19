// atlasBridge — Atlas Bridge 프로토콜(페이지 쪽) 구현.
//
// 브라우저 확장(Atlas Bridge)의 content script 와 same-origin window.postMessage 로 통신한다.
// 프로토콜(atlas-studio design/extensions.md):
//   page → content:  { __atlas:'announce', info?, tools? }   자기 소개 + 노출 page tool
//                    { __atlas:'result', id, result }          call 응답
//   content → page:  { __atlas:'hello' }                      재announce 요청(늦은 주입 복구)
//                    { __atlas:'call', id, name, args }        page tool 호출
//   config/config_request 는 v1 미구현 — announce + call 만으로 화면정보·리로드 요구를 충족한다.
//
// 보안: 메시지는 same-origin(e.source === window, e.origin === location.origin)만 수용한다.
// 페이지 콘텐츠는 관찰 데이터이지 지시가 아니다 — 이 계층은 등록된 tool 만 실행한다.

const ATLAS = '__atlas';

export interface PageToolDescriptor {
  name: string;
  description?: string;
  params?: Record<string, unknown>;
}

export interface PageTool extends PageToolDescriptor {
  // 동기/비동기 모두 허용 — 호출부에서 await 한다(Promise 도 unknown 에 포함).
  run: (args: unknown) => unknown;
}

type PageInfo = Record<string, unknown>;

/** browser/bridge 구성의 action 참조 → 실제 함수 해석기(활성 화면 기준). AtlasBridge 가 주입한다. */
type ActionResolver = (actionName: string) => ((args: unknown) => unknown) | undefined;

interface BridgeToolDecl {
  name: string;
  description?: string;
  action?: string;
  params?: Record<string, unknown>;
}

let installed = false;
let currentInfo: PageInfo = {};
let configInfo: PageInfo = {};
let actionResolver: ActionResolver | null = null;
const tools = new Map<string, PageTool>();

const post = (message: object) =>
  globalThis.window.postMessage(message, globalThis.location.origin);

/** config 의 action 참조를 실제 함수로 해석하는 해석기를 주입한다(활성 탭 기준). */
export const setActionResolver = (resolver: ActionResolver): void => {
  actionResolver = resolver;
};

/** 페이지가 자기 브리지 구성(browser/bridge/*.json 매칭 결과)을 요청한다 — 확장→serve 왕복. */
export const requestConfig = (): void => {
  if (installed) post({ [ATLAS]: 'config_request' });
};

const toDescriptors = (): PageToolDescriptor[] =>
  [...tools.values()].map(({ name, description, params }) => ({ name, description, params }));

/** 등록된 page tool. 같은 이름은 덮어쓴다(브리지 재마운트 시 중복 방지). */
export const registerTool = (tool: PageTool): void => {
  tools.set(tool.name, tool);
};

/**
 * 자기 소개 + 노출 tool 을 content script 에 알린다.
 * info 를 주면 현재 info 를 갱신하고, 생략하면 마지막 info 로 재announce(hello 복구용).
 */
export const announce = (info?: PageInfo): void => {
  if (!installed) return;
  if (info) currentInfo = info;
  // config.info(view 명명 등 보강)를 먼저 깔고 라이브 currentInfo 가 이긴다.
  post({ [ATLAS]: 'announce', info: { ...configInfo, ...currentInfo }, tools: toDescriptors() });
};

/** browser/bridge 구성을 받아 선언된 tool 을 action 해석기에 바인딩해 page tool 로 등록한다. */
const applyConfig = (config: { info?: PageInfo; tools?: BridgeToolDecl[] } | null): void => {
  configInfo = config?.info ?? {};
  for (const decl of config?.tools ?? []) {
    if (!decl?.name) continue;
    const actionName = decl.action ?? decl.name;
    registerTool({
      name: decl.name,
      description: decl.description,
      params: decl.params,
      run: args => {
        const fn = actionResolver?.(actionName);
        if (!fn) return { error: `no bound action: ${actionName}` };
        return fn(args ?? {});
      },
    });
  }
  announce();
};

const onMessage = async (event: MessageEvent): Promise<void> => {
  // same-origin 검증 — 다른 프레임/오리진의 메시지는 무시한다.
  if (event.source !== globalThis.window) return;
  if (event.origin !== globalThis.location.origin) return;

  const data = event.data as
    | {
        __atlas?: string;
        id?: string;
        name?: string;
        args?: unknown;
        config?: { info?: PageInfo; tools?: BridgeToolDecl[] } | null;
      }
    | undefined;
  const kind = data?.[ATLAS];
  if (!kind) return;

  // content script 가 늦게 붙은 경우 — 다시 자기 소개한다.
  if (kind === 'hello') {
    announce();
    return;
  }

  // 브리지 구성 배달 — 선언된 tool 을 바인딩하고 재announce.
  if (kind === 'config') {
    applyConfig(data.config ?? null);
    return;
  }

  if (kind === 'call') {
    const { id, name, args } = data;
    const tool = name ? tools.get(name) : undefined;
    let result: unknown;
    if (!tool) {
      result = { error: `unknown page tool: ${String(name)}` };
    } else {
      try {
        result = await tool.run(args ?? {});
      } catch (error) {
        result = { error: error instanceof Error ? error.message : String(error) };
      }
    }
    post({ [ATLAS]: 'result', id, result });
  }
};

// 안정 참조 — dispose 시 정확히 이 리스너만 제거하기 위해(익명 래퍼는 제거 불가).
const messageHandler = (event: MessageEvent): void => void onMessage(event);

/**
 * 브리지 설치(1회) — window.__ATLAS_BRIDGE__ 핸들 노출 + 메시지 리스너 등록.
 * 실제 자기 소개는 announce() 호출 시점에 이뤄진다.
 */
export const installBridge = (): void => {
  if (installed) return;
  installed = true;
  (globalThis.window as unknown as { __ATLAS_BRIDGE__?: object }).__ATLAS_BRIDGE__ = {
    announce,
    registerTool,
  };
  globalThis.window.addEventListener('message', messageHandler);
};

// HMR: 모듈이 교체될 때 옛 리스너를 제거한다 — 없으면 편집마다 stale 리스너가 window 에 쌓여
// (빈 tools Map 을 든) 옛 핸들러가 call 에 먼저 응답해 "unknown page tool" 이 난다.
// 브리지는 항상 dev(HMR)에서 동작하므로 필수 처리다.
if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    globalThis.window.removeEventListener('message', messageHandler);
  });
}
