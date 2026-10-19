import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type RefObject, useEffect, useState } from 'react';

/**
 * 그리드에 F4/헤더 필터가 적용되면 실제로 화면에 보이는 건수를, 미적용이면 조회 건수(dataCount)를
 * 반환한다. SubTitle.tsx 의 상단 툴바 건수 배지에 쓰던 로직을 공용 훅으로 뽑아, ResultArea 처럼
 * 그리드별로 건수를 표시하는 다른 곳에서도 재사용한다.
 *
 * gridRef 를 안 주거나(.current 가 아직 없어도) 필터 구독을 하지 않고, 기존 정적 표시와 동일하게
 * dataCount 그대로(0 이면 숨김 처리로 undefined) 반환한다 — gridRef/gridFilterRef 를 넘기지 않는
 * 호출부는 이 훅이 생기기 전과 동작이 완전히 같다.
 */
export const useFilteredGridCount = (
  gridRef: RefObject<FlexGrid | undefined> | undefined,
  gridFilterRef: RefObject<FlexGridFilter | undefined> | undefined,
  dataCount: number
): number | undefined => {
  // 필터 적용 시 collectionView 기준 필터된 건수, 미적용 시 null (dataCount 사용)
  const [filteredCount, setFilteredCount] = useState<number | null>(null);

  useEffect(() => {
    const gridInstance = gridRef?.current;
    if (!gridInstance) {
      setFilteredCount(null);
      return;
    }

    // 현재 collectionView 기준으로 필터된 건수 재계산
    const recompute = () => {
      const collectionView = gridInstance.collectionView;
      if (!collectionView) return;
      const total = collectionView.sourceCollection?.length ?? 0;
      const visible = collectionView.items?.length ?? 0;
      // 필터가 행을 숨기고 있으면 필터된 건수, 아니면 null(=dataCount 사용)
      setFilteredCount(visible < total ? visible : null);
    };

    // Wijmo는 itemsSource(배열) 변경 시 collectionView를 새 인스턴스로 교체하므로
    // 교체될 때마다 collectionChanged 핸들러를 다시 붙여준다.
    let boundView: FlexGrid['collectionView'] | undefined;
    const bindView = () => {
      const collectionView = gridInstance.collectionView;
      if (collectionView === boundView) {
        recompute();
        return;
      }
      boundView?.collectionChanged.removeHandler(recompute);
      boundView = collectionView;
      boundView?.collectionChanged.addHandler(recompute);
      recompute();
    };

    gridInstance.itemsSourceChanged.addHandler(bindView);
    gridFilterRef?.current?.filterChanged.addHandler(recompute);
    bindView();

    return () => {
      gridInstance.itemsSourceChanged.removeHandler(bindView);
      gridFilterRef?.current?.filterChanged.removeHandler(recompute);
      boundView?.collectionChanged.removeHandler(recompute);
    };
  }, [gridRef?.current, gridFilterRef?.current, dataCount]);

  // 필터 적용 시엔 0건이어도 명시 표시, 미적용 시엔 dataCount가 0이면 숨김
  return filteredCount !== null ? filteredCount : dataCount === 0 ? undefined : dataCount;
};
