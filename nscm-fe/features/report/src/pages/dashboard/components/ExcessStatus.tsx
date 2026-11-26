import { CellType, FlexGrid, HeadersVisibility, SelectionMode } from '@mescius/wijmo.grid';
import ReportProblemOutlined from '@mui/icons-material/ReportProblemOutlined';
import { useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import type { DashboardBaseFilters } from '../demand-as-dashboard.filters';
import { LBL } from '../demand-as-dashboard.labels';
import styles from '../DemandAsDashboard.module.scss';
import { useDashboardColumnLabels } from '../useDashboardColumnLabels';

import { mapExcess } from './excessStatus.map';

interface ExcessStatusProps {
  tabId: string;
  filters: DashboardBaseFilters;
}

export const ExcessStatus = ({ tabId, filters }: ExcessStatusProps) => {
  const hostRef = useRef<HTMLDivElement>(null);
  const { t } = useTranslation();
  const { labels, header } = useDashboardColumnLabels(SHEETS.EXCESS);

  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.EXCESS>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCESS,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { rows, riskAmount } = useMemo(
    () => mapExcess(data?.o_rc1 ?? [], t(...LBL.excessTotal)),
    [data, t]
  );

  useEffect(() => {
    if (!hostRef.current) return undefined;
    const grid = new FlexGrid(hostRef.current, {
      itemsSource: rows,
      isReadOnly: true,
      selectionMode: SelectionMode.None,
      headersVisibility: HeadersVisibility.Column,
      allowSorting: false,
      autoGenerateColumns: false,
      // 헤더 텍스트는 컬럼 메타(COLUMN_LABEL_NAME)에서 — binding·width·align 은 커스텀 유지.
      columns: [
        { header: header('PRODUCT', '_제품'), binding: 'product', width: '*', align: 'center' },
        { header: header('STOCK', '_현재 재고 (EA)'), binding: 'stock', width: '*', align: 'right' },
        { header: header('DEMAND12M', '_예상 수요 (12M)'), binding: 'demand12m', width: '*', align: 'right' },
        { header: header('EXCESSEA', '_Excess (EA)'), binding: 'excessEa', width: '*', align: 'right' },
        { header: header('EXCESSAMOUNT', '_Excess 금액 (억원)'), binding: 'excessAmount', width: '*', align: 'right' },
      ],
    });

    // 긴 헤더가 잘리지 않게 헤더 행 높이를 키워 2줄 줄바꿈 허용(.gridHost .wj-header white-space:normal).
    grid.columnHeaders.rows.defaultSize = 42;

    grid.formatItem.addHandler((s, e) => {
      if (e.panel.cellType !== CellType.Cell) return;
      // 합계 행은 항상 마지막 행이다(라벨이 i18n 으로 바뀌므로 문구 비교 대신 위치로 판정).
      if (e.row === s.rows.length - 1) {
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
      // 1px 하단 가드: 행 합을 host 높이에 꼭 맞추면 마지막 행 하단 그리드선이 클립 경계에 걸려,
      //   컨트롤 하단 테두리를 제거한 탓에 분수 배율(Windows 125/150%)에서 host 가 커질 때 반올림으로
      //   잘린다. 1px 남겨 하단선을 항상 클립 안쪽에 둔다(ProductStatusGrid 와 동일 패턴).
      const avail = host.clientHeight - grid.columnHeaders.height - 1;
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
  }, [rows, labels]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>{t(...LBL.excessTitle)}</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.excessWrap}>
          <div className={styles.gridHostRel}>
            <div className={styles.gridHost} ref={hostRef} />
          </div>
          <div className={styles.riskBox}>
            <ReportProblemOutlined sx={{ fontSize: 22, color: '#d32f2f' }} />
            <span className={styles.riskBoxLabel}>
              {t(...LBL.excessRiskLabel)}
              <br />
              (12M)
            </span>
            <span className={styles.riskBoxValue}>{riskAmount}</span>
            <span className={styles.riskBoxUnit}>억원</span>
          </div>
        </div>
      </div>
    </div>
  );
};
