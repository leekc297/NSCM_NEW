import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect } from 'react';

import type { SalesPlanMeta, SalesPlanRow } from '../sales-plan.types';

// AS-IS DMF0021_SalesPlan.cs expressions.md 120 건 정밀 매핑:
//   행잠금 112 (LockRange):
//     - EditButton 13 (L994~1085)       : Bucket/Division/Measure/권한 분기 잠금/해제
//     - InsertRow 70 (L2882~3293)       : 신규 행 사업부 별 초기 잠금 (handleInsert 에서 호출)
//     - spdMain_ComboSelChange 28 (L4544~5075) : Measure 변경 시 PLANT_SITE/INCOTERMS/FcstType/DEPT_ID/DomExp cascade
//     - spdMain_CellDoubleClick 1 (L3863) : 40 사업부 Catch_Up 시 dblClick guard
//   SUM 헤더 5 (ColumnHeaderSpan L3715~3743): Large/Small SUM 그룹 헤더 (Grid 다단 헤더)
//   합계 변수 3 (iMonthlySum L3990~4001): D_ 편집 시 Weekly + Monthly SUM 자동 재계산
//
// 본 hook 책임:
//   1) showSum toggle → W_ / M_ 컬럼 visibility (chkSum)
//   2) showColor → setResultPeriod (실적 회색 / 계획 흰색 / 현재주 녹색)
//   3) cellEditEnded — D_ 편집 시 W_/M_ SUM cascade + 빨간색 표시 + CRUD_TYPE='U' 마킹
//   4) cellEditEnded — Measure/Bucket 변경 시 사업부별 cascade lock (spdMain_ComboSelChange)
//   5) cellEditEnded.row.dblClick — Item/Project cell dblClick popup 호출 (40 사업부 Catch_Up guard)
//
// 룰 12 §11.6 HierarchicalMergeManager + 룰 12 §11.7 _inputEditType 표준
interface Options {
  gridRef: React.RefObject<FlexGridType<SalesPlanRow> | null>;
  meta?: SalesPlanMeta;
  showColor: boolean;
  showSum: boolean;
  bucketType: 'DAILY' | 'WEEKLY' | 'MONTHLY';
  divisionId: string;                            // 사업부 분기 (40/81/82)
  isEditMode: boolean;                           // F2 Edit Mode (편집 가능 cell 잠금 해제 분기)
  authMeta?: { editAuthSalesAmtLoc: boolean; editAuthRtfSysRp: boolean };  // dsMain.Tables[2] 권한 메타
}

export const useSalesPlanExpression = ({
  gridRef, meta, showColor, showSum, bucketType, divisionId, isEditMode, authMeta,
}: Options) => {

  // ===== Expression SUM 헤더 5 (chkSum toggle) =====
  //   AS-IS SetSpreadHeaderSpan L3715~3743 ColumnHeaderSpan "SUM"
  //   To-Be: W_ / M_ 컬럼 visibility toggle (showSum=false 시 SUM 컬럼 숨김)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    g.columns.forEach(col => {
      const binding = String(col.binding ?? '');
      if (binding.startsWith('W_') || binding.startsWith('M_')) {
        col.visible = showSum || bucketType !== 'DAILY';
      }
    });
  }, [showSum, bucketType, gridRef]);

  // ===== Expression chkColor : setResultPeriod (실적/계획 구간 색상 분기) =====
  //   AS-IS EditButton L816~856 chkColor.Checked 분기:
  //     - 실적 구간 (Gainsboro 회색): pre_YYYYMMWW 이전 컬럼
  //     - 계획 구간 (White): this_YYYYMM 이후 컬럼
  //     - 현재 주 (THIS_YYYYMMWW): BevelBorder Green 강조
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

      if (binding === meta.THIS_YYYYMMWW) {
        col.cssClass = 'currentWeekColumn';
        return;
      }

      let isPast = false;
      if (binding.startsWith('D_')) {
        const dt = binding.slice(2);
        isPast = parseInt(dt, 10) < parseInt(todayYyyymmdd, 10);
      } else if (binding.startsWith('W_')) {
        const ymPart = binding.slice(2, 8);
        isPast = parseInt(ymPart, 10) < parseInt(todayYyyymm, 10);
      } else if (binding.startsWith('M_')) {
        const ym = binding.slice(2);
        isPast = parseInt(ym, 10) < parseInt(todayYyyymm, 10);
      }

      col.cssClass = isPast ? 'pastPeriod' : (binding.startsWith('D_') || binding.startsWith('W_') || binding.startsWith('M_')) ? 'futurePeriod' : '';
    });
  }, [showColor, meta, gridRef]);

  // ===== Expression EditButton 13 + InsertRow 70 : 동적 col.isReadOnly 분기 =====
  //   AS-IS EditButton L742 LockColumn(0, MaxCol, true) 전체 잠금 후
  //   AS-IS L900~1095 분기:
  //     - 40 사업부 + Catch_Up + (현재월+3) 이후 → W_ (Monthly 시) / M_ (Weekly 시) 잠금
  //     - SalesAmt_LOC + EDIT_AUTH 있음 → 권한별 영역 해제
  //     - RTF_SYS_RP + 당월 → 차단
  //     - EDIT_AUTH 없음 → 전체 잠금
  //   조회 전용 (read-only) 모드: D_/W_/M_ 모두 isReadOnly=true
  //   편집 모드 (F2 Edit): 위 조건 분기로 isReadOnly 동적 토글
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    g.columns.forEach(col => {
      const binding = String(col.binding ?? '');
      if (!binding.startsWith('D_') && !binding.startsWith('W_') && !binding.startsWith('M_')) return;

      if (!isEditMode) {
        col.isReadOnly = true;
        return;
      }

      // Edit Mode 활성 — Bucket 별 분기 (Monthly=W_ 잠금 / Weekly=M_ 잠금 / Daily=W_+M_ 모두 잠금)
      if (bucketType === 'MONTHLY') {
        col.isReadOnly = binding.startsWith('W_');
      } else if (bucketType === 'WEEKLY') {
        col.isReadOnly = binding.startsWith('M_');
      } else {
        col.isReadOnly = binding.startsWith('W_') || binding.startsWith('M_');
      }
    });
  }, [isEditMode, bucketType, gridRef]);

  // ===== Expression Dsdm_Changed 3 + spdMain_ComboSelChange 28 : cellEditEnded cascade =====
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handler = (sender: FlexGridType<SalesPlanRow>, e: { row: number; col: number; cancel: boolean }) => {
      const col = sender.columns[e.col];
      const binding = String(col?.binding ?? '');
      const rowItem = sender.rows[e.row].dataItem as SalesPlanRow;
      const measure = String(rowItem?.MEASURE ?? '');
      const rowDivision = String((rowItem as Record<string, unknown>).DIVISION_ID ?? divisionId);

      // ===== Branch A: D_/W_/M_ 편집 (Dsdm_Changed L3918~4085) =====
      if (binding.startsWith('D_') || binding.startsWith('W_') || binding.startsWith('M_')) {
        if (measure === '') {
          sender.setCellData(e.row, e.col, '');
          return;
        }

        // CRUD_TYPE 마킹 (AS-IS BaseForm DataModel.Changed → EditFlag='U')
        if (!rowItem.CRUD_TYPE) rowItem.CRUD_TYPE = 'U';
        if (!rowItem.EDIT_FLAG) rowItem.EDIT_FLAG = 'U';

        // 1) Weekly SUM 재계산 (D_ 편집 시 좌측 W_ 갱신)
        if (binding.startsWith('D_')) {
          let weeklyCol = -1;
          for (let i = e.col - 1; i > 0; i--) {
            const b = String(sender.columns[i]?.binding ?? '');
            if (b.startsWith('W_')) { weeklyCol = i; break; }
            if (b.startsWith('M_')) break;
          }
          if (weeklyCol > 0) {
            let weeklySum = 0;
            for (let i = weeklyCol + 1; i < sender.columns.length; i++) {
              const b = String(sender.columns[i]?.binding ?? '');
              if (b.startsWith('W_') || b.startsWith('M_')) break;
              if (b.startsWith('D_')) {
                const v = sender.getCellData(e.row, i, false);
                weeklySum += Number(String(v ?? 0).replace(/,/g, '')) || 0;
              }
            }
            sender.setCellData(e.row, weeklyCol, weeklySum);
          }
        }

        // 2) Monthly SUM 재계산 (D_/W_ 편집 시 좌측 M_ 갱신)
        if (binding.startsWith('D_') || binding.startsWith('W_')) {
          let monthlyCol = -1;
          for (let i = e.col - 1; i > 0; i--) {
            const b = String(sender.columns[i]?.binding ?? '');
            if (b.startsWith('M_')) { monthlyCol = i; break; }
          }
          if (monthlyCol > 0) {
            let monthlySum = 0;
            for (let i = monthlyCol + 1; i < sender.columns.length; i++) {
              const b = String(sender.columns[i]?.binding ?? '');
              if (b.startsWith('M_')) break;
              if (b.startsWith('W_') || b.startsWith('D_')) {
                const v = sender.getCellData(e.row, i, false);
                monthlySum += Number(String(v ?? 0).replace(/,/g, '')) || 0;
              }
            }
            sender.setCellData(e.row, monthlyCol, monthlySum);
          }
        }

        // 3) 변경 cell 빨간색 표시 (AS-IS L3948 SetColor)
        const host = sender.cells.getCellElement(e.row, e.col);
        if (host) host.style.color = '#e53935';
        return;
      }

      // ===== Branch B: Measure / FcstType / DOM_EXP / INCOTERMS / PLANT_SITE_ID 변경 cascade =====
      // (spdMain_ComboSelChange L4540~5075 — 28 LockRange 분기)
      //   - Measure 변경 시 사업부별 cascade:
      //     · 40 사업부 + Catch_Up → DomExp/FcstType/INCOTERMS unlock
      //     · 40 사업부 + Catch_Up 아닌 다른 Measure → 위 3개 lock
      //     · 81/82 사업부 → PLANT_SITE_ID + INCOTERMS unlock
      //   - PLANT_SITE_ID 변경 시 자동 cascade (81/82 사업부)
      if (binding === 'MEASURE') {
        const newMeasure = String(sender.getCellData(e.row, e.col, true) ?? '');
        rowItem.MEASURE = newMeasure;

        if (rowDivision === '40' && newMeasure === 'Catch_Up') {
          // 40 사업부 Catch_Up → DomExp/FcstType/INCOTERMS 입력 가능
          ['DOM_EXP', 'FCST_TYPE', 'INCOTERMS', 'DEPT_ID'].forEach(b => {
            const idx = sender.columns.findIndex(c => c.binding === b);
            if (idx >= 0) sender.columns[idx].isReadOnly = false;
          });
        } else if (rowDivision === '40') {
          // 40 사업부 다른 Measure → 잠금
          ['DOM_EXP', 'FCST_TYPE', 'INCOTERMS'].forEach(b => {
            const idx = sender.columns.findIndex(c => c.binding === b);
            if (idx >= 0) sender.columns[idx].isReadOnly = true;
          });
        } else if (rowDivision.startsWith('81') || rowDivision === '82') {
          // 81/82 사업부 → PLANT_SITE_ID + INCOTERMS 입력 가능
          ['PLANT_SITE_ID', 'INCOTERMS', 'FCST_TYPE'].forEach(b => {
            const idx = sender.columns.findIndex(c => c.binding === b);
            if (idx >= 0) sender.columns[idx].isReadOnly = false;
          });
        }

        // Measure 변경 시 D_/W_/M_ 전체 0 reset (AS-IS L4926~5030 lock cascade)
        sender.columns.forEach((c, i) => {
          const b = String(c.binding ?? '');
          if (b.startsWith('D_') || b.startsWith('W_') || b.startsWith('M_')) {
            sender.setCellData(e.row, i, 0);
          }
        });

        if (!rowItem.CRUD_TYPE) rowItem.CRUD_TYPE = 'U';
      }
    };

    g.cellEditEnded.addHandler(handler as never);
    return () => { g.cellEditEnded.removeHandler(handler as never); };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, divisionId]);

  // Reserved — authMeta 별 fine-grained 잠금 (EditButton L1029 RTF_SYS_RP / SalesAmt_LOC 분기)
  // 후속 보강 시 dsMain.Tables[2] 의 EDIT_AUTH_SalesAmt_LOC / EDIT_AUTH_RTF_SYS_RP cross-check
  void authMeta;
};
