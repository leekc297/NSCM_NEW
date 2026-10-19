import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import {
  MENU_ID,
  SCREEN_TEXT,
  SUB_COLUMN,
  SUB_GROUP_LABEL,
} from '../shipment-change-request.constants';
import type { SubRow } from '../shipment-change-request.types';
import { buildSubColumns } from '../utils/shipmentChangeRequestColumns';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  /** 조회조건 Plan Type — 'P' 면 ERP_SO_NO 숨김 + 그룹라벨 Plan/Confirm (AS-IS cs:624~645). */
  changeType: string;
  adminColumns?: RawFlexGridColumnConfig[];
}

// AS-IS spdSub "Change Request" (58열, 전량 읽기전용 siSub.LockColumn(0,max,true) cs:1824).
//   2단 헤더(SetSheetHeaderColumn depth 2, cs:602) — 메타 SMALL_CLASS_LABEL_NAME 이 원천(hook #93 48px).
//   병합은 **헤더 전용**(ColumnHeaders) — 자매 SSP0200·SSP0003 sub 와 동일. 아래 allowMerging 주석 참조.
export const ShipmentChangeRequestSubGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  changeType,
  adminColumns,
}: Props) => {
  const { t } = useTranslation();

  // changeType='P' 분기 그룹라벨. 영문 하드코딩 금지(hook #114) — 미등록 화면 전용 키 + defaultValue.
  const planLabels = useMemo(
    () => ({
      plan: t(SCREEN_TEXT.SUB_GROUP_PLAN, { defaultValue: SUB_GROUP_LABEL.PLAN.confirmed }),
      confirm: t(SCREEN_TEXT.SUB_GROUP_CONFIRM, { defaultValue: SUB_GROUP_LABEL.PLAN.change }),
    }),
    [t]
  );

  const columns = useMemo(
    () => buildSubColumns(adminColumns, changeType, planLabels),
    [adminColumns, changeType, planLabels]
  );
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  /**
   * 헤더/값 잘림 방지 — 표시 컬럼을 내용(헤더 라벨 + 데이터)에 맞춰 자동 조절한다. extra 8px 여백.
   *   58열 2단 헤더라 메타 폭(25~150)으로는 헤더 라벨이 그대로 잘린다(사용자 신고 2026-10-07).
   *   주의: `autoSizeColumn(c, header, extra)` 의 `header` 는 "c 가 헤더행 인덱스인지"를 뜻한다
   *   (헤더 텍스트 포함 여부가 아니다) — 데이터 컬럼이므로 false 여야 하고, false 로도 헤더 라벨과
   *   데이터 셀을 모두 재어 더 넓은 쪽에 맞춘다.
   *   주의: deferUpdate 로 감싸면 렌더가 보류돼 셀 측정이 0 이 되므로 직접 호출한다. 렌더 전(호스트
   *   미부착/조상 hidden) 호출은 측정이 안 돼 예외로 흘려보내고 다음 트리거(rAF/loadedRows)에서 다시 맞춘다.
   *   숨김열은 건드리지 않는다: REMARKS 는 colWth:0(width===0)으로 화면에서만 제거한 것이라 autoSize 로
   *   되살리면 안 된다. visible=false(ERP_SO_NO) 도 대상 아니다.
   */
  const autoFitColumns = useCallback((grid: FlexGridType) => {
    for (let i = 0; i < grid.columns.length; i += 1) {
      const col = grid.columns[i];
      if (!col?.visible || col.width === 0) continue;
      try {
        grid.autoSizeColumn(i, false, 8);
      } catch {
        /* 렌더 전 측정 실패는 무시 — 다음 트리거에서 다시 맞춘다 */
      }
    }
  }, []);

  const handleInitialized = useCallback(
    (grid: FlexGridType) => {
      // 데이터 재로드 시(내부 CollectionView 갱신 포함) 다시 맞춘다. 컬럼 재빌드는 아래 useEffect 가 맡는다.
      grid.loadedRows.addHandler(() => autoFitColumns(grid));
      // CHK 헤더를 체크박스로 표시 — AS-IS CheckBoxCellType + Value=false (cs:606~613).
      //   그리드가 읽기전용이라 disabled(선택 불가). formatItem 은 렌더마다 재적용되므로 유지된다.
      grid.formatItem.addHandler((sender, e) => {
        if (
          e.panel.cellType === CellType.ColumnHeader &&
          sender.columns[e.col]?.binding === SUB_COLUMN.CHK
        ) {
          e.cell.innerHTML =
            '<input type="checkbox" disabled style="margin:auto;cursor:default" aria-label="all" />';
        }
      });
    },
    [autoFitColumns]
  );

  // 컬럼(메타 async 도착·Plan 분기)·행이 바뀐 뒤 렌더가 끝난 다음 프레임에 폭을 맞춘다.
  //   렌더 전에 재면 셀 폭이 0 이라 헤더가 계속 잘린다(특히 빈 그리드는 loadedRows 가 안 와서 이 경로가 필수).
  useEffect(() => {
    const raf = requestAnimationFrame(() => {
      const grid = gridRef.current;
      if (grid) autoFitColumns(grid);
    });
    return () => cancelAnimationFrame(raf);
  }, [columns, rows, autoFitColumns, gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      /* 2단 헤더 그룹라벨(Confirmed/Change 각 7열)을 **가로로 병합**하려면 반드시 헤더 병합 모드여야 한다.
         `AllowMerging.Cells` 는 데이터 셀 전용이고 헤더 병합 경로가 즉시 null 을 반환해
         (mergeManager.ts:167~172 — All/AllHeaders/ColumnHeaders 만 허용) 그룹라벨이 열마다 반복돼 보였다
         (사용자 신고 2026-10-07). 자매 SSP0200 sub(미지정=기본 ColumnHeaders)·SSP0003 sub 와 동일하게 맞춘다.
         부수효과(의도): 데이터 셀 병합이 없어지므로 AS-IS CHK `MergePolicy.None`(cs:615~617) 은 자동 충족된다
         — 컬럼별 allowMerging 을 런타임에 끌 필요가 없다(공용 DataGrid 가 전 컬럼을 그리드 prop 으로 덮어써
         컬럼 재빌드마다 되살아나던 문제도 같이 사라진다. SSP0200 buildSubColumns 주석과 같은 근거).
         트레이드오프: AS-IS `siSub.SmartColMerge()` cs:1831(live) 의 데이터 셀 세로병합은 포기한다 —
         자매 2화면과의 헤더 일치를 우선한 사용자 결정이다. 되살리려면 `AllowMerging.All` 로 올린다. */
      allowMerging={AllowMerging.ColumnHeaders}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      initialized={handleInitialized}
    />
  );
};
