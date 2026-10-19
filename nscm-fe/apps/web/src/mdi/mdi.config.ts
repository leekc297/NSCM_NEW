/**
 * MDI 탭 열기 모드.
 * - 'multi' : 메뉴 클릭마다 새 탭 생성(고객 요구 — 현행). 같은 메뉴가 여러 탭으로 열림.
 * - 'single': 메뉴 1개 ↔ 탭 1개. 이미 열린 메뉴를 다시 클릭하면 기존 탭으로 포커스.
 *
 * keep-alive 렌더링과 URL 미러(#/view/:mnuId)는 두 모드 모두 동일하게 동작한다
 * (URL 은 mnuId 만 담고, 활성 탭 식별은 MDI 스토어의 activeIndex 가 담당).
 */
export type MdiTabMode = 'multi' | 'single';

export const MDI_TAB_MODE: MdiTabMode = 'multi';

/**
 * 동시에 마운트(keep-alive)로 살려두는 탭 상한.
 *
 * ViewContainer 는 활성화된 적 있는 탭을 keep-alive 로 계속 마운트해 두는데, 무거운 그리드
 * 화면이 누적되면 CollectionView(행 데이터)가 JS 힙에 계속 상주해 메모리가 쌓인다
 * (실측: 열어서 본 탭은 예외 없이 전부 마운트 유지, 그리드 인스턴스가 탭과 1:1로 증가).
 * 이 상한을 넘으면 가장 오래 활성화되지 않은(LRU) 탭부터 언마운트해 메모리를 회수한다.
 *
 * 언마운트해도 검색조건/필터/컬럼설정은 탭 스토어(모듈 레벨 Map)에, 결과 데이터는 react-query
 * 캐시에 살아있어 재방문 시 그대로 복원된다. 잃는 것은 그리드 스크롤 위치 정도이며,
 * 미저장 편집(dirty) 탭은 언마운트 대상에서 제외한다(useTabActivation).
 */
export const MAX_MOUNTED_TABS = 8;
