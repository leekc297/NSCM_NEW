import { CellType, DataMap, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByPlantSiteModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { COMBO, MAIN_COLUMNS, MSG } from '../operation-lt.constants';
import type { OperationLTRow, PlantSiteSource } from '../operation-lt.types';
import { applyInvFlagVisible, buildColumns } from '../utils/operation-lt.columns';
import {
  applyItemSelect,
  applyScmSiteChange,
  isCellEditable,
  isItemPopupCell,
  isNewRow,
} from '../utils/operation-lt.editLock';
import { buildCellPlantSiteCandidates, toPlantSiteSource } from '../utils/operation-lt.plantSite';

interface Props {
  rows: OperationLTRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // Edit 진입 여부 — false 면 조회직후 전체 readOnly (design 01 R2/R3).
  editMode: boolean;
  // LT Operation=PRE_INSP 조건부 INV_FLAG 컬럼 Visible (design 01 R6 / 03 §2).
  showInvFlag: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// LT(Day) 셀 입력 제약 — AS-IS SetReNumerCellType(siMain, LT_DAY, 1, 0, 100) 재현
//   (SCP0037_OperationLT.cs L242 = NumberCellType Min=1 / DecimalPlaces=0).
//   AS-IS NumberCellType 은 범위 밖 값을 1 로 자동 변환하지 않고 입력을 거부한다 —
//   0 보다 큰 정수가 아니면 MSG00699 알림 후 편집 전 값으로 되돌린다
//   (형제 FormationGrid LT_FORMATION 과 동일한 거부 규약). 빈값은 공백 차단(저장검증)에 맡긴다.
// 0 보다 큰 정수인가 (빈값은 거부 대상 아님 — 저장검증이 담당, MSG00699 문구와 일치).
const isValidLtDay = (raw: unknown): boolean => {
  const text = s(raw).trim();
  if (text === '') return true;
  const n = Number(text);
  return Number.isInteger(n) && n > 0;
};

export const OperationLTGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  editMode,
  showInvFlag,
  adminColumns,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const [openItem, setOpenItem] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  const columns = useMemo(
    () => applyInvFlagVisible(buildColumns(MAIN_COLUMNS, adminColumns), showInvFlag),
    [adminColumns, showInvFlag]
  );

  // 신규행 SCM_SITE_ID 셀콤보 원본 — PlantByDivisionOperNonOsp1_SCP_ALL(OSP_YN='N') ∪
  //   PlantByDivisionOperOsp21_SCP_ALL(OSP_YN='Y'). 조회영역과 동일 콤보(getCombo 세션 캐시 공유).
  const [plantNonOsp, plantOsp] = useTabComboQueries({
    filters: [COMBO.PLANT_NONOSP, COMBO.PLANT_OSP],
  });
  const plantSource = useMemo<{ nonOsp: PlantSiteSource[]; osp: PlantSiteSource[] }>(
    () => ({ nonOsp: toPlantSiteSource(plantNonOsp), osp: toPlantSiteSource(plantOsp) }),
    [plantNonOsp, plantOsp]
  );
  const plantSourceRef = useRef(plantSource);
  plantSourceRef.current = plantSource;

  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;

  // SCM_SITE_ID 컬럼 원본 dataMap(admin auto-combo) 보존 — 편집 진입 시 행별 후보로 스왑, 종료 시 원복.
  const scmSiteOriginalMap = useRef<DataMap | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전체 readOnly, Edit 진입 시 white-list 로 셀별 해제 (design 01 R2/R3 / 03 §3-1).
    const beginningEditHandler = (
      sender: FlexGrid,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editModeRef.current) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      if (!isCellEditable(binding, row)) {
        e.cancel = true;
        return;
      }
      // 신규행 SCM_SITE_ID 셀콤보 — 행 DIVISION_ID+LT_OPERATION 종속 후보로 dataMap 스왑
      //   (PARAM2/9/10 미이관 → FE 재현, design 03 §3-2·§6#1).
      if (binding === 'SCM_SITE_ID' && isNewRow(row)) {
        const col = sender.columns[e.col];
        if (scmSiteOriginalMap.current === null) scmSiteOriginalMap.current = col.dataMap;
        const candidates = buildCellPlantSiteCandidates(
          plantSourceRef.current.nonOsp,
          plantSourceRef.current.osp,
          s(row.DIVISION_ID),
          s(row.LT_OPERATION)
        );
        col.dataMap = new DataMap(
          candidates.map(c => ({ CODE: c.CODE, NAME: c.NAME })),
          'CODE',
          'NAME'
        );
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 파생 Auto-Sync (design 03 §3-3) + SCM_SITE_ID dataMap 원복.
    const cellEditEndedHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (row && binding === 'SCM_SITE_ID') {
        // SCM_SITE_ID 선택 -> PLANT_SITE_ID 미러 + ITEM_ID/NICK_NAME clear.
        applyScmSiteChange(row, s(row.SCM_SITE_ID));
      }
      // LT(Day) 입력 거부 — 0 보다 큰 정수가 아니면 MSG00699 알림 후 값을 비운다(자동 1 변환 금지).
      //   빈값으로 되돌려 저장검증(필수값)이 재차 막게 한다 — 형제 FormationGrid LT_FORMATION 거부 규약.
      if (row && binding === 'LT_DAY' && !isValidLtDay(row.LT_DAY)) {
        row.LT_DAY = '';
        void setAlert({ type: 'alert', content: t(MSG.LT_DAY_POSITIVE_INT, '_0보다 큰 정수를 입력하십시오.') });
      }
      // dataMap 원복 — 편집 종료 후 표시는 admin 전체 매핑을 쓴다(편집/표시 이원화).
      if (binding === 'SCM_SITE_ID' && scmSiteOriginalMap.current !== null) {
        sender.columns[e.col].dataMap = scmSiteOriginalMap.current;
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // 붙여넣기 파생 + SCM_SITE_ID 유효성 검증 (design 03 §3-3 #36~39, AS-IS cs L793~817).
    //   신규행 SCM_SITE_ID 붙여넣기 값이 그 행 후보(div+LT_OPERATION 종속)에 없으면 clear 후 파생 —
    //   무효 site 가 PLANT_SITE_ID 로 미러되는 것을 차단(콤보 편집이 주 경로, 붙여넣기 부수 경로 보강).
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (row && binding === 'SCM_SITE_ID' && isNewRow(row)) {
        const pasted = s(row.SCM_SITE_ID);
        if (pasted !== '') {
          const candidates = buildCellPlantSiteCandidates(
            plantSourceRef.current.nonOsp,
            plantSourceRef.current.osp,
            s(row.DIVISION_ID),
            s(row.LT_OPERATION)
          );
          if (!candidates.some(c => c.CODE === pasted)) row.SCM_SITE_ID = '';
        }
      }
      cellEditEndedHandler(sender, e);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // 신규행 ITEM_ID 셀 -> Item 팝업(ItemByPlantSiteModal COM0014). 인라인 편집은 beginningEdit 이 취소.
    //   가드: division / plant site 선행 필수(MSG required, design 03 §3-4 guard#7/#8).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || !isItemPopupCell(binding, row)) return;
      if (s(row.DIVISION_ID).trim() === '') {
        void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division') });
        return;
      }
      if (s(row.SCM_SITE_ID).trim() === '') {
        void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Plant Site') });
        return;
      }
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={columns}
        gotFocus={onFocus}
      />
      {/* 그리드 셀 Item 팝업 — ItemByPlantSiteModal(COM0014). division + SCM_SITE_ID 로 좁혀 조회.
          ItemByDivisionModal(COM0008)·MaterialByDivisionModal(COM0013)과 대체 금지. */}
      <ItemByPlantSiteModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId, _itemName, _cls, _type, nickName) => {
          const row = GridUtils.getRow(gridRef.current, clickedRow) as
            | Record<string, unknown>
            | undefined;
          if (!row || s(row.CRUD_TYPE) !== CRUD_TYPE.INSERT) return;
          applyItemSelect(row, itemId, s(nickName));
          GridUtils.refreshRow(gridRef.current, clickedRow);
        }}
        preSearchParams={{
          divisionId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.DIVISION_ID
          ),
          scmSiteId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.SCM_SITE_ID
          ),
          itemId: '',
        }}
      />
    </>
  );
};
