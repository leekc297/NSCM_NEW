import { describe, it, expect } from 'vitest';

import { resetView, resolveView } from './viewRegistry';

// resolveView 는 lazy 컴포넌트를 반환할 뿐 실제 모듈 로딩은 렌더 시점 — 테스트는 매칭 규칙만 검증한다.
describe('viewRegistry (DB 메뉴 정보 기반 화면 해석)', () => {
  it('routePath(SCM_ADM_MNU_M.ROUTE_PATH)가 1순위로 매칭된다', () => {
    expect(resolveView({ routePath: 'master/sales-site' })).toBeDefined();
    expect(resolveView({ routePath: 'admin/ui-catrgory-setup' })).toBeDefined(); // 별칭 불필요
    expect(resolveView({ routePath: '/master/sales-site/' })).toBeDefined(); // 슬래시 정규화
  });

  it('routePath 가 없으면 mnuUrl 마지막 세그먼트로 폴백한다 (V2 미배포 이행기)', () => {
    expect(resolveView({ mnuUrl: 'master/demand-master/sales-site' })).toBeDefined();
    expect(resolveView({ mnuUrl: 'menu-management' })).toBeDefined();
  });

  it('mnuUrl 폴백 시 폴더명 예외는 URL_ALIASES 로 보정한다', () => {
    expect(resolveView({ mnuUrl: 'ui-category' })).toBeDefined(); // SYS0004
    expect(resolveView({ mnuUrl: 'customer-fcst-master' })).toBeDefined(); // DMF0007
  });

  it('routePath 가 잘못돼도 mnuUrl 폴백으로 찾는다', () => {
    expect(resolveView({ routePath: 'no/such-page', mnuUrl: 'sales-site' })).toBeDefined();
  });

  it('아무것도 매칭되지 않으면 undefined 를 반환한다', () => {
    expect(resolveView({ routePath: null, mnuUrl: 'no-such-page' })).toBeUndefined();
    expect(resolveView({})).toBeUndefined();
  });

  it('같은 화면은 같은 lazy 인스턴스를 반환한다 (keep-alive 탭 리마운트 방지)', () => {
    const a = resolveView({ routePath: 'master/sales-site' });
    const b = resolveView({ routePath: 'master/sales-site', mnuUrl: 'a/b/c' });
    expect(a).toBe(b);
  });

  // React.lazy 는 reject 된 로더를 영구 캐시하므로, 재시도가 실제 재요청이 되려면
  // 새 lazy 인스턴스가 나와야 한다.
  it('resetView 후에는 새 lazy 인스턴스를 반환한다 (모듈 로드 실패 재시도)', () => {
    const before = resolveView({ routePath: 'demand/forecast-price' });
    resetView({ routePath: 'demand/forecast-price' });
    const after = resolveView({ routePath: 'demand/forecast-price' });

    expect(before).toBeDefined();
    expect(after).toBeDefined();
    expect(after).not.toBe(before);
  });

  it('resetView 는 mnuUrl 별칭 경로로도 캐시를 비운다', () => {
    const before = resolveView({ mnuUrl: 'ui-category' }); // SYS0004 별칭
    resetView({ mnuUrl: 'ui-category' });
    expect(before).toBeDefined();
    expect(resolveView({ mnuUrl: 'ui-category' })).not.toBe(before);
  });

  it('매칭되지 않는 메뉴의 resetView 는 아무 일도 하지 않는다', () => {
    expect(() => resetView({ routePath: 'no/such-page' })).not.toThrow();
    expect(() => resetView({})).not.toThrow();
  });
});
