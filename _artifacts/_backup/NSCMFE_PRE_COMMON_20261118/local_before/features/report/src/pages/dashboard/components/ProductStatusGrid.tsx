import { CellType, FlexGrid, HeadersVisibility, SelectionMode } from '@mescius/wijmo.grid';
import { useEffect, useRef } from 'react';

import type { ActionTone, ProductStatusRow, StatusDot } from '../demand-as-dashboard.mock';
import { PRODUCT_STATUS_ROWS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

const ACTION_CLASS: Record<ActionTone, string> = {
  keep: styles.actionKeep,
  review: styles.actionReview,
  produce: styles.actionProduce,
};
const DOT_CLASS: Record<StatusDot, string> = {
  green: styles.dotGreen,
  orange: styles.dotOrange,
  red: styles.dotRed,
};

export const ProductStatusGrid = () => {
  const hostRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    const grid = new FlexGrid(hostRef.current, {
      itemsSource: PRODUCT_STATUS_ROWS,
      isReadOnly: true,
      selectionMode: SelectionMode.None,
      headersVisibility: HeadersVisibility.Column,
      allowSorting: false,
      autoGenerateColumns: false,
      // Inventory Cover 헤더가 길어 star 가중치로 넓게, 짧은 컬럼은 좁게 배분(패널 폭에 맞춰 스케일).
      columns: [
        { header: '제품', binding: 'product', width: '0.8*', align: 'center' },
        { header: 'OEM', binding: 'oem', width: '0.8*', align: 'center' },
        { header: 'Biz Type', binding: 'bizType', width: '0.9*', align: 'center' },
        { header: '현재 재고 (EA)', binding: 'stock', width: '1.1*', align: 'right' },
        { header: 'Inventory Cover (개월)', binding: 'cover', width: '1.9*', align: 'center' },
        { header: '예상 부족월', binding: 'shortageMonth', width: '1*', align: 'center' },
        { header: '권고 Action', binding: 'action', width: '1.1*', align: 'center' },
        { header: '상태', binding: 'status', width: 56, align: 'center' },
      ],
    });

    grid.formatItem.addHandler((s, e) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col].binding;
      const row = s.rows[e.row].dataItem as ProductStatusRow;
      if (binding === 'action') {
        e.cell.innerHTML = `<span class="${styles.actionBadge} ${ACTION_CLASS[row.actionTone]}">${row.action}</span>`;
      } else if (binding === 'status') {
        e.cell.innerHTML = `<span class="${styles.statusDot} ${DOT_CLASS[row.status]}"></span>`;
      }
    });

    const host = hostRef.current;
    // 행이 적어 아래에 빈 공간이 생기지 않도록, 사용 가능한 높이(host - 헤더)를 행 수로 나눠
    //   행 높이를 채운다(auto-fill). 형제 Heat Map(table height:100%)과 같은 높이로 맞춘다.
    //   주의: grid.invalidate()는 레이아웃을 비동기로 예약하므로 직후 columnHeaders.height를
    //   읽으면 stale → avail 과소계산 → 행이 덜 늘어나 아래 여백이 남는다. refresh()로 동기
    //   확정 후 측정한다. 호스트 크기가 확정된 다음 프레임(rAF)에 맞춰 재실행.
    const fit = () => {
      grid.refresh();
      const n = grid.rows.length;
      if (n === 0) return;
      const avail = host.clientHeight - grid.columnHeaders.height;
      if (avail <= n) return;
      const base = Math.floor(avail / n);
      grid.rows.defaultSize = base;
      // floor 나머지를 마지막 행이 흡수 → 바닥 여백 0(오버플로도 없음).
      grid.rows[n - 1].height = base + (avail - base * n);
    };
    let raf = 0;
    const schedule = () => {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(fit);
    };
    schedule();
    const observer = new ResizeObserver(schedule);
    observer.observe(host);
    return () => {
      cancelAnimationFrame(raf);
      observer.disconnect();
      grid.dispose();
    };
  }, []);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>제품별 현황</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.gridHost} ref={hostRef} />
      </div>
      <div className={styles.gridFoot}>
        <span>※ Inventory Cover = 현재 재고 / 월평균 수요(예측)</span>
        <span className={styles.moreLink}>더보기 ›</span>
      </div>
    </div>
  );
};
