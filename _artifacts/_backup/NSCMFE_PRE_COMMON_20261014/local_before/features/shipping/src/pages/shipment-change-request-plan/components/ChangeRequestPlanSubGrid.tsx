import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  MENU_ID,
  SHIPMENT_STATUS_REQUESTED,
  SUB_MODE_EDITABLE_COLUMNS,
  SUB_REQUESTED_LOCKED_COLUMNS,
  SUB_SEARCH_TYPE_ONLY_COLUMNS,
} from '../shipment-change-request-plan.constants';
import type { SubRow } from '../shipment-change-request-plan.types';
import { str, type GridRowData } from '../utils/shipmentChangeRequestPlanDerive';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  /** 화면 오픈 시 1회 결정되는 권한(편집모드 기본 ON — 모드토글 미이식, convert-core §2.4). */
  canEdit: boolean;
  /**
   * 파생 완료된 컬럼셋. 페이지가 만들어 내려준다 — 여기서 로컬 useMemo 로 만들면 같은 컬럼셋이
   * 요청확정의 `saveWithValidation` 에 닿지 않아 메타 필수검증이 조용히 무발동한다
   * (메모리 dynamic-collbl-required-never-reaches-savevalidation).
   */
  columns: RawFlexGridColumnConfig[];
}

const MODE_EDITABLE = new Set<string>(SUB_MODE_EDITABLE_COLUMNS);
const SEARCH_TYPE_ONLY = new Set<string>(SUB_SEARCH_TYPE_ONLY_COLUMNS);
const REQUESTED_LOCKED = new Set<string>(SUB_REQUESTED_LOCKED_COLUMNS);

/**
 * spdSub "Change Request" (메타 56열 / display=Y 26열, frozen 경계 = INCOTERMS, 2단 헤더).
 *   2단 헤더 depth 는 메타 SMALL_CLASS_LABEL_NAME 이 원천이다 — 하드코딩 금지(hook #87§D).
 *   빈 그리드가 정상일 수 있다: detail WHERE = SHIPMENT_STATUS='D' AND LAST_UPDATED_BY=요청자,
 *   즉 "내가 작성 중인 초안"만 나온다(design 03 §4.3). 0행을 결함으로 오판하지 않는다.
 *   CHK 헤더 전체선택은 AS-IS 에서 동작 여부가 불명(spdSub 이벤트 배선 0건, §6 #15) — 미구현으로 둔다.
 */
export const ChangeRequestPlanSubGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  canEdit,
  columns,
}: Props) => {
  // 인용은 getCombo(`quoteComboParams`)가 처리한다 — 화면은 raw 로 넘긴다(설계 §6.1).
  const comboParams = useMemo(() => ({ mnuId: MENU_ID }), []);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    /**
     * 행·모드 조건 편집 게이트 — design 03 §3.5 R-31⑤(`SetChangeRequestSOGrid`).
     *   열 축(StringAction~NEW_ETA 전열 잠금)은 `INPUT_TP_CD` 메타가 원천이고 공용 DataGrid 가 판정한다
     *   — 여기서 컬럼 화이트리스트를 다시 두지 않는다(hook #130).
     *
     *   AS-IS 3분기 중 TO-BE 에서 도달 가능한 것은 `sShipStatus≠'R' & SearchType≠'E'` 하나다:
     *     - `sShipStatus` 는 요청확정/취소 실행체인이 세팅하는 화면 변수이고 그 경로가 아직 미배선이다.
     *     - `SearchType='E'`(전극 조회) 원천 SP 도 미이관이다.
     *   그래서 `NEW_SHIPMENT_DATE` 는 잠금 유지가 현 시점 패리티다(04 확인필요로 보고).
     */
    const editGate = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      if (!canEdit) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as GridRowData | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      // 요청완료 상태 행은 일자·수량을 잠근다(§3.5 1행).
      if (str(row.SHIPMENT_STATUS) === SHIPMENT_STATUS_REQUESTED && REQUESTED_LOCKED.has(binding)) {
        e.cancel = true;
        return;
      }
      if (SEARCH_TYPE_ONLY.has(binding)) {
        e.cancel = true;
        return;
      }
      if (!MODE_EDITABLE.has(binding)) e.cancel = true;
    };
    grid.beginningEdit.addHandler(editGate);
    grid.pastingCell.addHandler(editGate);

    return () => {
      try {
        grid.beginningEdit?.removeHandler(editGate);
        grid.pastingCell?.removeHandler(editGate);
      } catch {
        /* unmount race */
      }
    };
  }, [columns, canEdit, gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
    />
  );
};
