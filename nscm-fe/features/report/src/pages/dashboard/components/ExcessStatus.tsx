import { CellType, FlexGrid, HeadersVisibility, SelectionMode } from '@mescius/wijmo.grid';
import ReportProblemOutlined from '@mui/icons-material/ReportProblemOutlined';
import { useEffect, useRef } from 'react';

import type { ExcessRow } from '../demand-as-dashboard.mock';
import { EXCESS_RISK_AMOUNT, EXCESS_ROWS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

export const ExcessStatus = () => {
  const hostRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    const grid = new FlexGrid(hostRef.current, {
      itemsSource: EXCESS_ROWS,
      isReadOnly: true,
      selectionMode: SelectionMode.None,
      headersVisibility: HeadersVisibility.Column,
      allowSorting: false,
      autoGenerateColumns: false,
      columns: [
        { header: '제품', binding: 'product', width: '*', align: 'center' },
        { header: '현재 재고 (EA)', binding: 'stock', width: '*', align: 'right' },
        { header: '예상 수요 (12M)', binding: 'demand12m', width: '*', align: 'right' },
        { header: 'Excess (EA)', binding: 'excessEa', width: '*', align: 'right' },
        { header: 'Excess 금액 (억원)', binding: 'excessAmount', width: '*', align: 'right' },
      ],
    });

    // 긴 헤더가 잘리지 않게 헤더 행 높이를 키워 2줄 줄바꿈 허용(.gridHost .wj-header white-space:normal).
    grid.columnHeaders.rows.defaultSize = 42;

    grid.formatItem.addHandler((s, e) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const row = s.rows[e.row].dataItem as ExcessRow;
      if (row.product === '합계') {
        e.cell.style.fontWeight = '700';
        e.cell.style.background = '#f7f9fc';
      }
      // Excess 금액(억원) 컬럼 값은 강조색(#d72e16).
      if (s.columns[e.col].binding === 'excessAmount') {
        e.cell.style.color = '#d72e16';
      }
    });

    const host = hostRef.current;
    // 행 아래 여백이 생기지 않도록 사용 가능한 높이를 행 수로 나눠 채운다(위험금액 박스와 높이 일치).
    //   refresh()로 동기 확정 후 측정(invalidate는 비동기라 stale), 마지막 행이 floor 나머지를 흡수.
    const fit = () => {
      grid.refresh();
      const n = grid.rows.length;
      if (n === 0) return;
      const avail = host.clientHeight - grid.columnHeaders.height;
      if (avail <= n) return;
      const base = Math.floor(avail / n);
      grid.rows.defaultSize = base;
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
        <span className={styles.panelTitle}>Excess / 과재고 현황</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.excessWrap}>
          <div className={styles.gridHostRel}>
            <div className={styles.gridHost} ref={hostRef} />
          </div>
          <div className={styles.riskBox}>
            <ReportProblemOutlined sx={{ fontSize: 22, color: '#d32f2f' }} />
            <span className={styles.riskBoxLabel}>
              예상 폐기 위험 금액
              <br />
              (12M)
            </span>
            <span className={styles.riskBoxValue}>{EXCESS_RISK_AMOUNT}</span>
            <span className={styles.riskBoxUnit}>억원</span>
          </div>
        </div>
      </div>
    </div>
  );
};
