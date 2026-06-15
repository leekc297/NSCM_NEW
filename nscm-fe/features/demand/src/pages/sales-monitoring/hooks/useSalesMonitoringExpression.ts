import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect } from 'react';

import type { SalesMonitoringMeta, SalesMonitoringRow } from '../sales-monitoring.types';

// AS-IS DMF0048_SalesMonitoring.cs expressions.md 7 건 정밀 매핑:
//   SUM 헤더 5 (L1350, L1356, L1364, L1376, L1378 SetSpreadHeaderSpan "SUM")
//   합계 변수 2 (L1456 iMonthlySum 계산 / L1461 SetText)
//
// 본 hook 은 Grid 후속 처리:
//   1) chkSum 옵션 시 SUM 컬럼 visibility toggle (W_/M_ 가 SUM 컬럼)
//   2) chkColor 옵션 시 setResultPeriod logic (실적 구간 Gainsboro 회색 / 계획 구간 White)
//      AS-IS L856~949 setResultPeriod — Bucket 별 분기:
//        Daily   : D_ 컬럼 중 sPre_YYYYMMDD 까지 회색
//        Weekly  : W_ 컬럼 중 pre_YYYYMMWW 까지 회색
//        Monthly : M_ 컬럼 중 sResult_YYYYMM 까지 회색
//   3) Dsdm_Changed cellEditEnded — D_ 컬럼 편집 시 Weekly+Monthly SUM 자동 재계산
//      AS-IS L1422~1473 — W_ / M_ 컬럼의 SUM 자동 갱신 (Weekly 7 일 합 / Monthly 한 달 합)
interface Options {
  gridRef: React.RefObject<FlexGridType<SalesMonitoringRow> | null>;
  meta?: SalesMonitoringMeta;
  showColor: boolean;
  showSum: boolean;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
}

export const useSalesMonitoringExpression = ({
  gridRef, meta, showColor, showSum, bucketType,
}: Options) => {

  // ===== Expression 1~5 : SUM 헤더 (chkSum toggle) =====
  //   AS-IS L1350/L1356/L1364/L1376/L1378 ColumnHeaderSpan SetSpreadHeaderSpan "SUM"
  //   To-Be: W_ / M_ 컬럼 visibility toggle (showSum=false 시 SUM 컬럼 숨김)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    g.columns.forEach(col => {
      const binding = String(col.binding ?? '');
      // W_ / M_ 는 SUM 합산 컬럼 (각 주 / 월 단위)
      // showSum=true 시 SUM 컬럼 visible, false 시 숨김 (D_ 만 표시)
      if (binding.startsWith('W_') || binding.startsWith('M_')) {
        col.visible = showSum || bucketType !== 'DAILY';   // Daily 가 아니면 항상 visible
      }
    });
  }, [showSum, bucketType, gridRef]);

  // ===== Expression chkColor : setResultPeriod (실적/계획 구간 색상 분기) =====
  //   AS-IS L856~949 setResultPeriod:
  //     - 실적 구간 (Gainsboro 회색): sResult_YYYYMMDD 이전 컬럼
  //     - 계획 구간 (White): sResult_YYYYMMDD 이후 컬럼
  //     - 현재 주 (THIS_YYYYMMWW): BevelBorder Green 강조 (이미 currentWeekColumn cssClass)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (!showColor || !meta) {
      g.columns.forEach(col => { col.cssClass = ''; });
      return;
    }

    const todayYyyymmdd = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const todayYyyymm = todayYyyymmdd.slice(0, 6);

    g.columns.forEach(col => {
      const binding = String(col.binding ?? '');

      // 1) 현재 주 (THIS_YYYYMMWW) — 녹색 BevelBorder
      if (binding === meta.THIS_YYYYMMWW) {
        col.cssClass = 'currentWeekColumn';
        return;
      }

      // 2) 실적 구간 (Gainsboro 회색) — 오늘 이전
      let isPast = false;
      if (binding.startsWith('D_')) {
        const dt = binding.slice(2);
        isPast = parseInt(dt, 10) < parseInt(todayYyyymmdd, 10);
      } else if (binding.startsWith('W_')) {
        // W_yyyymmww 형식 — yyyymm 부분 비교
        const ymPart = binding.slice(2, 8);
        isPast = parseInt(ymPart, 10) < parseInt(todayYyyymm, 10);
      } else if (binding.startsWith('M_')) {
        const ym = binding.slice(2);
        isPast = parseInt(ym, 10) < parseInt(todayYyyymm, 10);
      }

      col.cssClass = isPast ? 'pastPeriod' : (binding.startsWith('D_') || binding.startsWith('W_') || binding.startsWith('M_')) ? 'futurePeriod' : '';
    });
  }, [showColor, meta, gridRef]);

  // ===== Expression 6~7 : Dsdm_Changed cellEditEnded (Weekly + Monthly SUM 자동 계산) =====
  //   AS-IS L1422~1473 — D_ 컬럼 편집 시:
  //     1) D_ 의 좌측 인접 W_ 컬럼 갱신 (Weekly SUM)
  //     2) D_ 의 좌측 인접 M_ 컬럼 갱신 (Monthly SUM = 해당 월 모든 W_ 합)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handler = (sender: FlexGridType<SalesMonitoringRow>, e: { row: number; col: number; cancel: boolean }) => {
      const col = sender.columns[e.col];
      const binding = String(col?.binding ?? '');
      // D_ 컬럼만 편집 가능 (AS-IS L1409)
      if (!binding.startsWith('D_')) return;

      const rowItem = sender.rows[e.row].dataItem as SalesMonitoringRow;
      const measure = String(rowItem?.MEASURE ?? '');
      if (measure === '') {
        sender.setCellData(e.row, e.col, '');
        return;
      }

      // CRUD_TYPE 마킹 (AS-IS BaseForm DataModel.Changed → EditFlag='U')
      if (!rowItem.CRUD_TYPE) rowItem.CRUD_TYPE = 'U';

      // 1) Weekly SUM 재계산 (D_ 의 좌측 W_ 찾아서 D_ 합 update)
      //    AS-IS L1428~1440 : for(iCol = e.col; iCol > 0; iCol--) { W_ 찾으면 break }
      let weeklyCol = -1;
      for (let i = e.col - 1; i > 0; i--) {
        const b = String(sender.columns[i]?.binding ?? '');
        if (b.startsWith('W_')) { weeklyCol = i; break; }
        if (b.startsWith('M_')) break;
      }
      if (weeklyCol > 0) {
        // 해당 W_ 컬럼 다음 (=현재 weekly 시작) ~ 다음 W_ / M_ 까지의 D_ 합
        let weeklySum = 0;
        for (let i = weeklyCol + 1; i <= sender.columns.length - 1; i++) {
          const b = String(sender.columns[i]?.binding ?? '');
          if (b.startsWith('W_') || b.startsWith('M_')) break;
          if (b.startsWith('D_')) {
            const v = sender.getCellData(e.row, i, false);
            weeklySum += Number(String(v ?? 0).replace(/,/g, '')) || 0;
          }
        }
        sender.setCellData(e.row, weeklyCol, weeklySum);
      }

      // 2) Monthly SUM 재계산 (D_ 의 좌측 M_ 찾아서 W_ 합 update)
      //    AS-IS L1443~1464 : Monthly SUM = sum of W_ in that month
      let monthlyCol = -1;
      for (let i = e.col - 1; i > 0; i--) {
        const b = String(sender.columns[i]?.binding ?? '');
        if (b.startsWith('M_')) { monthlyCol = i; break; }
      }
      if (monthlyCol > 0) {
        let monthlySum = 0;
        for (let i = monthlyCol + 1; i <= sender.columns.length - 1; i++) {
          const b = String(sender.columns[i]?.binding ?? '');
          if (b.startsWith('M_')) break;
          if (b.startsWith('W_')) {
            const v = sender.getCellData(e.row, i, false);
            monthlySum += Number(String(v ?? 0).replace(/,/g, '')) || 0;
          }
        }
        sender.setCellData(e.row, monthlyCol, monthlySum);
      }
    };

    g.cellEditEnded.addHandler(handler as never);
    return () => { g.cellEditEnded.removeHandler(handler as never); };
  }, [gridRef]);
};
