// viewRegistry — DB 메뉴 정보 → 화면 컴포넌트(lazy) 해석.
//
// 화면 모듈은 파일시스템(features/*/src/pages/*)에서 빌드타임에 자동 수집하고,
// "어떤 메뉴가 어떤 화면인지"는 DB 가 내려주는 메뉴 정보로 결정한다.
// 실제 코드 로딩은 탭을 여는 시점의 lazy — 세션 로딩 시엔 매핑만 구성된다.
//
// 해석 순서(resolveView):
//   1. menu.routePath (SCM_ADM_MNU_M.ROUTE_PATH, 'domain/pageDir' — PR_GET_MENU_LIST_V2 부터 제공)
//   2. menu.mnuUrl 마지막 세그먼트 (+ URL_ALIASES 보정) — V2 미배포 환경용 이행기 폴백
//
// 새 화면 등록 = 페이지 폴더 추가 + DB ROUTE_PATH 등록 (프론트 코드 수정 불필요).
// 각 화면은 PageProps({ tabId, title, menu })를 받는다. ViewContainer 가 탭별로 주입.
import { lazy, type ComponentType, type LazyExoticComponent } from 'react';

import type { PageProps } from '@foundation/models';

// PageProps<M> 의 본문은 M 에 의존하지 않으므로(구조가 동일) 하나로 취급한다.
export type AnyPage = ComponentType<PageProps<MenuId>>;
type LazyPage = LazyExoticComponent<AnyPage>;
type PageModule = Record<string, unknown>;

// features/<도메인>/src/pages/<페이지폴더>/index.ts 전체를 lazy 로더로 수집.
// glob 은 빌드타임 정적 분석이라 페이지 추가/삭제가 자동 반영된다.
const PAGE_MODULES = import.meta.glob<PageModule>('../../../../features/*/src/pages/*/index.ts');

// 조회 key: '<도메인>/<페이지폴더>' (ROUTE_PATH 형식) 및 '<페이지폴더>' 단독(mnuUrl 폴백용) 둘 다 등록.
const loaders = new Map<string, () => Promise<PageModule>>();
for (const [file, loader] of Object.entries(PAGE_MODULES)) {
  const matched = file.match(/features\/([^/]+)\/src\/pages\/([^/]+)\/index\.ts$/);
  if (!matched) continue;
  const [, domain, pageDir] = matched;
  loaders.set(`${domain}/${pageDir}`, loader);
  if (loaders.has(pageDir)) {
    console.warn(
      `[viewRegistry] 페이지 폴더명 중복: '${pageDir}' — ROUTE_PATH('<도메인>/${pageDir}')로만 조회 가능`
    );
  } else {
    loaders.set(pageDir, loader);
  }
}

/** mnuUrl 폴백 전용: DB MNU_URL ↔ 실제 페이지 폴더명이 다른 예외 (ROUTE_PATH 사용 시 불필요) */
const URL_ALIASES: Record<string, string> = {
  'ui-category': 'ui-catrgory-setup', // SYS0004 (폴더명 오타가 굳어진 케이스)
  'customer-fcst-master': 'customer-forecast-master', // DMF0007
};

/** 페이지 index.ts 는 화면 컴포넌트 1개를 export 한다(named 또는 default). */
const pickComponent = (module: PageModule, key: string): AnyPage => {
  const component =
    module.default ??
    Object.values(module).find(
      v => typeof v === 'function' || (typeof v === 'object' && v !== null)
    );
  if (!component) throw new Error(`[viewRegistry] '${key}' 모듈에 컴포넌트 export 가 없습니다`);
  return component as AnyPage;
};

// lazy() 인스턴스는 key 별로 1회만 생성 — 매 렌더마다 새로 만들면 keep-alive 탭이 리마운트된다.
const lazyCache = new Map<string, LazyPage>();

const findLoader = (menu: {
  routePath?: string | null;
  mnuUrl?: string | null;
}): [key: string, loader: () => Promise<PageModule>] | undefined => {
  const routePath = menu.routePath?.replace(/^\/+|\/+$/g, '');
  const urlLeaf = menu.mnuUrl?.split('/').filter(Boolean).pop();

  const candidates = [routePath, urlLeaf, urlLeaf && URL_ALIASES[urlLeaf]];
  for (const key of candidates) {
    if (!key) continue;
    const loader = loaders.get(key);
    if (loader) return [key, loader];
  }
  return undefined;
};

/**
 * DB 메뉴 정보(routePath/mnuUrl)로 화면 컴포넌트를 조회.
 * 매칭되는 페이지 모듈이 없으면 undefined (ViewContainer 가 빈 화면 처리).
 */
export const resolveView = (menu: {
  routePath?: string | null;
  mnuUrl?: string | null;
}): LazyPage | undefined => {
  const found = findLoader(menu);
  if (!found) return undefined;

  const [key, loader] = found;
  let page = lazyCache.get(key);
  if (!page) {
    page = lazy(() => loader().then(m => ({ default: pickComponent(m, key) })));
    lazyCache.set(key, page);
  }
  return page;
};

/**
 * 캐시된 lazy 인스턴스를 폐기한다 — 재시도용.
 *
 * React.lazy 는 로더 promise 가 한 번 reject 되면 그 실패를 영구 캐시한다.
 * dev 서버 재시작/중단, 일시적 500 등으로 모듈 fetch 가 실패하면
 * ('Failed to fetch dynamically imported module') 같은 인스턴스를 다시 렌더해도
 * 재요청 없이 계속 같은 에러를 던진다 → 새로고침 외엔 복구 불가.
 * 캐시를 비워 다음 resolveView 가 새 lazy 인스턴스(= 새 import 요청)를 만들게 한다.
 */
export const resetView = (menu: { routePath?: string | null; mnuUrl?: string | null }): void => {
  const found = findLoader(menu);
  if (found) lazyCache.delete(found[0]);
};
