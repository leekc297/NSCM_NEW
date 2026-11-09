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

    // 붙여넣기(커밋 전) 게이트 — AS-IS SpdMain_ClipboardPasted(cs L724~805) 등가, 신규행만.
    //   SCM_SITE_ID: 붙여넣기는 beginningEdit 의 좁힘 dataMap 스왑을 안 타 컬럼엔 넓은 admin dataMap
    //     (PlantSiteByDivisionSCP0037, CODE->SITE_DESCRIPTION)만 걸려 있다. wijmo 가 표시명->CODE 코어싱에
    //     실패하면 값이 아예 안 들어온다("붙여넣기 무반응", 2026-10-21). 그래서 wijmo 자체 매핑을 끄고
    //     (event.cancel) 붙은 표시명/코드를 그 행 좁힘 후보(div+LT_OPERATION)의 CODE 로 직접 복원해 세팅한다.
    //     무효 site(그 LT Operation 후보 밖)는 세팅 안 함 = AS-IS cs L793 clear 등가.
    //   ITEM_ID: Division/Plant Site 선행 필수 — 없으면 붙여넣기 차단+alert(dblclick 팝업 가드와 동일, cs L645~657).
    const pastingCellHandler = (
      sender: FlexGrid,
      event: { row: number; col: number; data?: unknown; cancel: boolean }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || !isNewRow(row)) return;

      if (binding === 'ITEM_ID') {
        if (s(row.DIVISION_ID).trim() === '') {
          event.cancel = true;
          void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division') });
          return;
        }
        if (s(row.SCM_SITE_ID).trim() === '') {
          event.cancel = true;
          void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Plant Site') });
          return;
        }
        return;
      }

      if (binding === 'SCM_SITE_ID') {
        event.cancel = true; // wijmo 자체 매핑(표시명->CODE) 우회 — 직접 세팅
        const raw = s(event.data).trim();
        if (raw === '') return;
        const candidates = buildCellPlantSiteCandidates(
          plantSourceRef.current.nonOsp,
          plantSourceRef.current.osp,
          s(row.DIVISION_ID),
          s(row.LT_OPERATION)
        );
        const lowered = raw.toLowerCase();
        // 붙은 값이 좁힘 후보의 CODE 거나(엑셀 코드 입력), NAME(좁힘 콤보 표시명)이거나,
        //   admin dataMap 표시명(기존행 복사 = SITE_DESCRIPTION)이면 그 CODE 로 복원한다.
        let code = candidates.find(c => c.CODE.toLowerCase() === lowered)?.CODE ?? '';
        if (code === '') {
          const adminMap = sender.columns[event.col]?.dataMap;
          const viaAdmin = adminMap ? s(adminMap.getKeyValue(raw)).trim() : '';
          if (viaAdmin !== '' && candidates.some(c => c.CODE === viaAdmin)) code = viaAdmin;
          else code = candidates.find(c => c.NAME.toLowerCase() === lowered)?.CODE ?? '';
        }
        if (code !== '') {
          row.SCM_SITE_ID = code;
          row.PLANT_SITE_ID = code; // 항상 SCM_SITE_ID 미러(AS-IS cs L790)
          sender.invalidate();
        }
      }
    };
    g.pastingCell.addHandler(pastingCellHandler as never);

    // 붙여넣기 후처리 — Material(Plant Site 확인 통과분)은 NICK_NAME 비움(붙여넣은 item 은 nick 재조회 없음, cs L800).
    //   SCM_SITE_ID 는 pastingCell 에서 cancel+직접세팅하므로 여기로 오지 않는다.
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (row && binding === 'ITEM_ID' && isNewRow(row)) row.NICK_NAME = '';
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

    // 신규행 ITEM_ID Delete/Backspace 삭제 — AS-IS KeyPress(cs L710)는 타이핑만 막고(e.Handled)
    //   Delete 는 KeyDown 이라 막히지 않아 셀을 비운다. TO-BE 는 ITEM_ID 가 isCellEditable=false(팝업 전용)라
    //   wijmo 기본 Delete 가 안 먹으므로, 신규행 ITEM_ID 선택 상태에서 Delete/Backspace 시 ITEM_ID+NICK_NAME 을
    //   직접 비운다(AS-IS 파생 — ITEM clear 시 Nick 동반, cs L800). 편집 중(LT_DAY 등)이면 기본 동작 유지.
    const keydownHandler = (ev: KeyboardEvent) => {
      if (ev.key !== 'Delete' && ev.key !== 'Backspace') return;
      if (g.activeEditor) return;
      const sel = g.selection;
      if (g.columns[sel.col]?.binding !== 'ITEM_ID') return;
      const row = g.rows[sel.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || !isNewRow(row)) return;
      ev.preventDefault();
      row.ITEM_ID = '';
      row.NICK_NAME = '';
      g.invalidate();
    };
    g.hostElement.addEventListener('keydown', keydownHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastingCell?.removeHandler(pastingCellHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.hostElement?.removeEventListener('keydown', keydownHandler);
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
