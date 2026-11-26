import { CellType, FlexGrid, HeadersVisibility, SelectionMode } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import type { DashboardBaseFilters } from '../demand-as-dashboard.filters';
import { LBL } from '../demand-as-dashboard.labels';
import { ACTION_LABEL_CODE, ACTION_LABEL_FALLBACK } from '../demand-as-dashboard.rules';
import type { ActionTone, ProductStatusRow, StatusDot } from '../demand-as-dashboard.types';
import styles from '../DemandAsDashboard.module.scss';
import { useDashboardColumnLabels } from '../useDashboardColumnLabels';

import { mapProductStatus } from './productStatusGrid.map';

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

interface ProductStatusGridProps {
  tabId: string;
  filters: DashboardBaseFilters;
}

export const ProductStatusGrid = ({ tabId, filters }: ProductStatusGridProps) => {
  const hostRef = useRef<HTMLDivElement>(null);
  const { t } = useTranslation();
  const { labels, header } = useDashboardColumnLabels(SHEETS.PRODUCT_STATUS);

  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.PRODUCT_STATUS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRODUCT_STATUS,
    tabId,
    filters,
    enabled: !!filters,
  });

  const mapped = useMemo(() => mapProductStatus(data?.o_rc1 ?? []), [data]);

  // 권고 Action 라벨은 FE 하드코딩이 아니라 actionCode → i18n 메시지로 해석한다(언어 변경 시 재해석).
  //   미등록 상태면 fallback('_생산 필요' 등)이 보인다. 코드 등록 SQL: design/05_register_msg.sql.
  const rows = useMemo<ProductStatusRow[]>(
    () =>
      mapped.map(r => ({
        product: r.product,
        oem: r.oem,
        bizType: r.bizType,
        stock: r.stock,
        cover: r.cover,
        shortageMonth: r.shortageMonth,
        actionTone: r.actionTone,
        status: r.status,
        action: r.actionCode
          ? t(ACTION_LABEL_CODE[r.actionCode], ACTION_LABEL_FALLBACK[r.actionCode])
          : '-',
      })),
    [mapped, t]
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
      //   Inventory Cover 헤더가 길어 star 가중치로 넓게, 짧은 컬럼은 좁게 배분(패널 폭에 맞춰 스케일).
      columns: [
        { header: header('PRODUCT', '_제품'), binding: 'product', width: '0.8*', align: 'center' },
        { header: header('OEM', '_OEM'), binding: 'oem', width: '0.8*', align: 'center' },
        { header: header('BIZTYPE', '_Biz Type'), binding: 'bizType', width: '0.9*', align: 'center' },
        { header: header('STOCK', '_현재 재고 (EA)'), binding: 'stock', width: '1.1*', align: 'right' },
        { header: header('COVER', '_Inventory Cover (개월)'), binding: 'cover', width: '1.9*', align: 'center' },
        { header: header('SHORTAGEMONTH', '_예상 부족월'), binding: 'shortageMonth', width: '1*', align: 'center' },
        { header: header('ACTION', '_권고 Action'), binding: 'action', width: '1.1*', align: 'center' },
        { header: header('STATUS', '_상태'), binding: 'status', width: 56, align: 'center' },
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
      // 1px 하단 가드: 행 합을 host 높이에 꼭 맞추면 마지막 행의 하단 그리드선이 클립 경계
      //   (panel overflow:hidden)에 걸린다. 컨트롤 하단 테두리를 제거해(.wj-content border-bottom:none)
      //   이 그리드선이 곧 테두리라, 분수 배율(Windows 125/150%)에서 host 가 커질 때 반올림으로
      //   경계 밖으로 밀려 잘린다. 1px 남겨 하단선을 항상 클립 안쪽에 둔다(여백 1px 는 눈에 안 띔).
      const avail = host.clientHeight - grid.columnHeaders.height - 1;
      if (avail <= n) return;
      const base = Math.floor(avail / n);
      grid.rows.defaultSize = base;
      // floor 나머지를 마지막 행이 흡수 → 바닥 여백 1px 고정(오버플로 없음).
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
        <span className={styles.panelTitle}>{t(...LBL.productStatusTitle)}</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.gridHost} ref={hostRef} />
      </div>
      <div className={styles.gridFoot}>
        <span>※ {t(...LBL.productStatusFootNote)}</span>
        <span className={styles.moreLink}>{t(...LBL.more)} ›</span>
      </div>
    </div>
  );
};
