import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { COLUMN, MENU_ID } from '../shipment-change-request-plan.constants';
import type { SubRow } from '../shipment-change-request-plan.types';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  /**
   * 파생 완료된 컬럼셋. 페이지가 만들어 내려준다 — 여기서 로컬 useMemo 로 만들면 같은 컬럼셋이
   * 요청확정의 `saveWithValidation` 에 닿지 않아 메타 필수검증이 조용히 무발동한다
   * (메모리 dynamic-collbl-required-never-reaches-savevalidation).
   */
  columns: RawFlexGridColumnConfig[];
}

/**
 * spdSub "Change Request" (메타 56열 / display=Y 26열, frozen 경계 = INCOTERMS, 2단 헤더).
 *   2단 헤더 depth 는 메타 SMALL_CLASS_LABEL_NAME 이 원천이다 — 하드코딩 금지(hook #87§D).
 *   빈 그리드가 정상일 수 있다: detail WHERE = SHIPMENT_STATUS='D' AND LAST_UPDATED_BY=요청자,
 *   즉 "내가 작성 중인 초안"만 나온다(design 03 §4.3). 0행을 결함으로 오판하지 않는다.
 *
 *   전 컬럼 읽기전용(`isReadOnly`) — AS-IS `FindData_Sub_Draft` 는 조회 직후
 *   `siSub.LockColumn(0, maxCol, true)`(cs:2061)로 전열을 잠그고, 편집을 여는 `SetChangeRequestSOGrid()`
 *   는 호출부가 전부 주석(dead)이다. 그래서 CHK(All) 체크박스를 포함해 어떤 셀도 편집/선택되지 않는다.
 *   과거 편집 게이트(SUB_MODE_EDITABLE_COLUMNS 등)는 dead 코드 오해에 근거해 잘못 열어 둔 것이라 제거했다.
 */
export const ChangeRequestPlanSubGrid = ({ rows, gridRef, gridFilterRef, columns }: Props) => {
  // 인용은 getCombo(`quoteComboParams`)가 처리한다 — 화면은 raw 로 넘긴다(설계 §6.1).
  const comboParams = useMemo(() => ({ mnuId: MENU_ID }), []);

  /**
   * 텍스트 잘림 방지 — 표시 컬럼을 내용(헤더 라벨 + 데이터)에 맞춰 자동 조절한다. extra 8px 여백.
   *   주의: autoSizeColumn(c, header, extra) 의 `header` 는 "c 가 헤더행 인덱스인지"를 뜻한다
   *   (헤더 텍스트 포함 여부가 아니다) — 데이터 컬럼이므로 false 여야 하고, false 로도 컬럼 헤더
   *   라벨과 데이터 셀을 모두 재어 더 넓은 쪽에 맞춘다(공용 gridContextMenu 도 기본값 사용).
   *   주의: deferUpdate 로 감싸면 렌더가 보류돼 셀 측정이 0이 되므로 직접 호출한다. 렌더 전(호스트
   *   미부착/조상 hidden) 호출은 측정이 안 돼 예외로 흘려보내고 다음 트리거(rAF/loadedRows)에서 다시 맞춘다.
   *   숨김열은 건드리지 않는다: REMARKS 등은 colWth:0(width===0)으로 화면에서만 제거한 것이라
   *   autoSize 로 되살리면 안 된다. visible=false(END_CUSTOMER/PROJECT 토글)도 대상 아니다.
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
      // CHK(All) 컬럼 헤더를 체크박스로 표시 — AS-IS 화면과 동일(라벨 'ALL' 텍스트 대신).
      //   그리드가 읽기전용이라 disabled(선택 불가). formatItem 은 렌더마다 재적용되므로 유지된다.
      grid.formatItem.addHandler((sender, e) => {
        if (
          e.panel.cellType === CellType.ColumnHeader &&
          sender.columns[e.col]?.binding === COLUMN.CHK
        ) {
          e.cell.innerHTML =
            '<input type="checkbox" disabled style="margin:auto;cursor:default" aria-label="all" />';
        }
      });
    },
    [autoFitColumns]
  );

  // 컬럼(메타 async 도착·div 토글)·행이 바뀐 뒤 렌더가 끝난 다음 프레임에 폭을 맞춘다.
  //   렌더 전에 재면 셀 폭이 0이라 헤더가 계속 잘린다(특히 빈 그리드는 loadedRows 가 안 와서 이 경로가 필수).
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
      // AS-IS 는 조회 직후 전열 잠금(cs:2061) — CHK(All) 체크박스 포함 어떤 셀도 편집/선택 불가.
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      initialized={handleInitialized}
    />
  );
};
