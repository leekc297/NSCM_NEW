// AtlasBridge — Atlas 브리지를 앱 셸에 얹는다(MDIContainer 에 1회 마운트, RouterSync 형제).
//
// 하는 일:
//  - 활성 탭(mnuId/routePath/제목)을 info 로 announce → 브라우저 에이전트의 page_info 가
//    announced:true 로 이 화면을 인식한다(URL 만으로는 못 얻는 라이브 화면정보).
//  - reload page tool 등록 → call_page_tool({name:'reload'}) 로 활성 화면 컴포넌트를 remount.
//    이 앱은 F5 를 그리드 재조회로 가로채므로, 이것이 컴포넌트 단위 리로드의 표면이다.
//
// 노출 범위: dev 또는 VITE_ATLAS_BRIDGE 플래그가 켜진 환경에서만 활성(그 외 no-op) — 운영
// 화면에 자동화 표면이 노출되지 않도록. atlas-react 의 automationBridge(dev on/prod off)와 동일.
import { useEffect } from 'react';

import { apiClient } from '@foundation/apis';
import { getViewActions } from '@shared/stores';

import {
  announce,
  installBridge,
  registerTool,
  requestConfig,
  setActionResolver,
} from '../bridge/atlasBridge';

import { useMDIStore } from './useMDIStore';
import { useTabActivation } from './useTabActivation';
import { useViewReload } from './useViewReload';

const BRIDGE_ENABLED = import.meta.env.DEV || import.meta.env.VITE_ATLAS_BRIDGE === 'true';

export const AtlasBridge = () => {
  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const activeTab = tabs[activeIndex];

  // 설치 1회 + reload page tool 등록. reload 는 호출 시점의 활성 탭을 다시 마운트한다
  // (클로저에 탭을 가두지 않고 getState 로 매번 현재 활성 탭을 읽는다).
  useEffect(() => {
    if (!BRIDGE_ENABLED) return;
    installBridge();
    // browser/bridge 구성의 action 참조 → 활성 탭의 registry 액션으로 해석.
    setActionResolver(name => {
      const store = useMDIStore.getState();
      const tabId = store.tabs[store.activeIndex]?.tabId;
      if (!tabId) return undefined;
      return getViewActions(tabId)?.[name];
    });
    registerTool({
      name: 'reload',
      description:
        '활성 화면 컴포넌트를 다시 마운트한다(전체 페이지 reload 아님 — 화면 재초기화·재조회 발생).',
      run: () => {
        const store = useMDIStore.getState();
        const tabId = store.tabs[store.activeIndex]?.tabId;
        if (!tabId) return { ok: false, error: 'no active tab' };
        useViewReload.getState().reload(tabId);
        return { ok: true, tabId };
      },
    });
    // 디버그: 콤보 REST(admin/combo)를 앱 세션으로 직접 호출해 실제 응답을 확인한다.
    // (진단용 — 콤보 목록이 왜 비는지 컬럼 스키마 대조. 조사 끝나면 제거 가능)
    registerTool({
      name: 'debugGetCombo',
      description: '디버그: admin/combo 를 앱 세션으로 호출 — {comboId} 로 행수·키·샘플 반환.',
      run: async args => {
        const comboId = (args as { comboId?: string })?.comboId;
        if (!comboId) return { error: 'comboId required' };
        try {
          const rows = await apiClient.getCombo({ comboId });
          return {
            comboId,
            count: rows.length,
            keys: rows[0] ? Object.keys(rows[0]) : [],
            sample: rows.slice(0, 3),
          };
        } catch (error) {
          return { error: error instanceof Error ? error.message : String(error) };
        }
      },
    });
    // 디버그: 탭 keep-alive 누적 메모리 측정 — JS 힙 + DOM 노드 + 그리드 인스턴스 +
    // 열린 탭 대비 마운트된 탭 수를 한 번에 반환한다. LRU 언마운트 규모 산정용.
    // (진단용 — 측정 끝나면 제거 가능. dev 전용 게이트.)
    registerTool({
      name: 'debugMemory',
      description:
        '디버그: 탭 keep-alive 메모리 측정 — JS 힙(MB)·DOM 노드·그리드 수·마운트 탭/전체 탭 반환.',
      run: () => {
        const mem = (
          performance as unknown as {
            memory?: {
              usedJSHeapSize: number;
              totalJSHeapSize: number;
              jsHeapSizeLimit: number;
            };
          }
        ).memory;
        const toMB = (bytes: number) => Math.round((bytes / 1024 / 1024) * 10) / 10;
        const mdi = useMDIStore.getState();
        const activated = useTabActivation.getState().activated;
        const openTabIds = new Set(mdi.tabs.map(t => t.tabId));
        const mountedTabs = Object.keys(activated).filter(id => openTabIds.has(id)).length;
        return {
          heapUsedMB: mem ? toMB(mem.usedJSHeapSize) : null,
          heapTotalMB: mem ? toMB(mem.totalJSHeapSize) : null,
          heapLimitMB: mem ? toMB(mem.jsHeapSizeLimit) : null,
          domNodes: document.getElementsByTagName('*').length,
          grids: document.querySelectorAll('.wj-flexgrid').length,
          openTabs: mdi.tabs.length,
          mountedTabs,
          activeMnuId: String(mdi.tabs[mdi.activeIndex]?.mnuId ?? ''),
        };
      },
    });
    // browser/bridge/*.json 구성을 요청 — serve 왕복으로 선언된 tool 이 배달된다.
    requestConfig();
  }, []);

  // 활성 탭이 바뀔 때마다 화면 정보 재announce.
  useEffect(() => {
    if (!BRIDGE_ENABLED || !activeTab) return;
    announce({
      app: 'nscm',
      view: String(activeTab.mnuId),
      route: activeTab.routePath ?? activeTab.mnuUrl ?? null,
      title: activeTab.mnuDesc ?? null,
      tabId: activeTab.tabId,
    });
    // 활성 탭의 식별 필드가 바뀔 때만 재announce (activeTab 객체 전체 의존은 불필요한 재실행)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab?.tabId, activeTab?.mnuId, activeTab?.routePath]);

  return null;
};
