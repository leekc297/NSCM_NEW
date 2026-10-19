import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

import {
  LOOKUP,
  MAIN_COLUMNS,
  MENU_ID,
  OPERATION_GROUP_WARRANTY_CODE,
  OPERATION_GROUP_WARRANTY_NAME,
  USER_POPUP_NAME_COLUMN,
} from '../shipment-model-pic.constants';
import type { MainRow } from '../shipment-model-pic.types';
import { buildColumns } from '../utils/shipmentModelPicColumns';
import { isUserPopupColumn } from '../utils/shipmentModelPicEditLock';
import { lookupUserName } from '../utils/shipmentModelPicUserLookup';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
  // EDIT 권한(AS-IS `IsLock` 가드의 권한축 치환) — false 면 그리드 전체 readonly + 팝업 오픈 차단.
  canEdit: boolean;
  // 이미지셀(USER 계열 7) 더블클릭 -> 페이지가 UserInfoPopup 오픈(row/binding 기억). design 03 §1.1.
  onUserCellDblClick: (row: Record<string, unknown>, binding: string) => void;
  onFocus: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS spdMain "Shipment Model PIC" (단일 그리드 21열). 조회=전체 lock, Edit=SwitchLock 편집셀만 unlock.
export const ShipmentModelPicGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  adminColumns,
  canEdit,
  onUserCellDblClick,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 키인 이름 파생용 — 팝업 handleUserSelected 와 동일하게 KO=국문명 / 그 외=영문명.
  const langCd = useSessionStore(s => s.session.langCd);

  // 자동 콤보 셀의 @토큰 해소 — getCombo funnel 이 인용 처리(pre-quote idempotent, nscm-patterns §3.3).
  //   FROM_SITE=PlantSiteByDivision `@divisionId` / VALID_YN=YesOrNo(파라미터 없음) /
  //   OPERATION_GROUP=LookupCommon `@lookupType`.
  //   lookupType 은 컬럼 메타 ATTRIBUTE1 에 등록돼 있으나 공용 DataGrid 가 ATTRIBUTE1 을 콤보
  //   파라미터로 싣는 경로가 없어(`[[grid-cell-combo-lookuptype-token-not-transmitted]]`), 미전달 시
  //   BE makeComboQuery 가 '' 로 치환해 LOOKUP_TYPE='' → 0행이 된다. 그리드 단위 comboParams 로 공급한다
  //   (이 화면은 @lookupType 을 쓰는 셀 콤보가 OPERATION_GROUP 하나뿐이라 단일값 공급이 안전하다).
  const comboParams = useMemo(
    () => ({
      mnuId: `'${MENU_ID}'`,
      divisionId: `'${division}'`,
      lookupType: `'${LOOKUP.OPERATION_GROUP}'`,
    }),
    [division]
  );

  // OPERATION_GROUP 표시 매핑 — lookup NAME(P/A/E) + 클라 W=Warranty (AS-IS cs:183-187 하드코딩).
  const [operationGroupData] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.OPERATION_GROUP }],
  });
  const opGroupNameMap = useMemo(() => {
    const m = new Map<string, string>();
    (operationGroupData ?? []).forEach(r => m.set(str(r.CODE), str(r.NAME)));
    m.set(OPERATION_GROUP_WARRANTY_CODE, OPERATION_GROUP_WARRANTY_NAME);
    return m;
  }, [operationGroupData]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // OPERATION_GROUP 셀 표시 — 코드 -> NAME + center (design 03 §3 R3-W).
    //   메타 콤보(LookupCommon + @lookupType)가 P/A/E 는 dataMap 으로 풀지만 `W` 는 lookup 미등록이라
    //   (실측 3행: P/A/E) 코드 원문이 남는다 — AS-IS 도 같은 이유로 셀유형을 바꿔가며 우회했다
    //   (cs:354 주석 [C20200324-000461]). 여기서 W->Warranty 를 덮어 마무리한다. P/A/E 는 dataMap 과
    //   같은 lookup NAME 이라 값이 어긋나지 않는다.
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPERATION_GROUP') return;
      const raw = str(sender.getCellData(e.row, e.col, false));
      if (!raw) return;
      e.cell.textContent = opGroupNameMap.get(raw) ?? raw;
      e.cell.style.textAlign = 'center';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집 게이트는 화면이 재정의하지 않는다 — 공용 DataGrid 의 setEditableColumns(dataGridUtils)가
    //   컬럼메타 INPUT_TP_CD 로 판정한다(M/O = 편집, S = 잠금). DB 실측 9열 편집(USER_ID='M',
    //   PART_LEADER/TEAM_LEADER/MAIL_USER1~5/VALID_YN='O') + 12열 'S' 잠금 = AS-IS LockColumn
    //   (cs:274~278) 집합과 1:1 일치하므로 메타만으로 파리티가 달성된다(design 03 §1.1, hook #130).
    //   주의: 팝업 8열은 AS-IS 도 TextCellType(cs:162)이라 키인이 가능했고 TO-BE 메타도 FPTextModal
    //   (키인 + 모달 동시 허용)이다 — 화면이 인라인 편집을 취소하면 AS-IS 보다 좁아진다.

    // ID 셀(USER_ID/PART_LEADER/TEAM_LEADER) 편집 시 짝 이름 컬럼 파생은 아래 별도 useEffect
    //   (cellEditEnded/pastedCell → deriveName)에서 처리한다 — 삭제 시 이름 동반 삭제, 키인·붙여넣기
    //   시 이름 자동 채움(사용자 지시 2026-09-29). `USER_ID` 는 여전히 `INPUT_TP_CD='M'`(필수)이라
    //   ID 를 비우면 공용 필수검증이 저장을 막는다(이름만 비고 저장은 차단 — A-5/공용검증).

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, opGroupNameMap]);

  // 이름 짝이 있는 ID 셀(USER_ID/PART_LEADER/TEAM_LEADER) 직접 키인·붙여넣기·삭제 시 짝 이름 컬럼을
  //   팝업 선택과 동일하게 유지한다(사용자 지시 2026-09-29). 팝업(handleUserSelected)은 ID+이름을
  //   함께 세팅하는데 키인·삭제 경로에는 그 파생이 없어 이름이 어긋나거나 남는 문제를 맞춘다.
  //   - ID 삭제(빈값) → 짝 이름 컬럼도 함께 비운다.
  //   - ID 키인·붙여넣기 → 팝업과 같은 COM0010/ssoUser 조회로 이름을 채운다(무매칭 시 이름 비움).
  //   이름 컬럼은 조회전용('S')이라 SAVE payload 에 안 실리고 표시 목적이므로 EditTracker 마킹 없이
  //   행에 직접 쓴다(handleUserSelected 와 동일). 편집 자체가 isReadOnly 로 게이트되므로 별도 가드 불요.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const deriveName = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const nameCol = USER_POPUP_NAME_COLUMN[binding];
      if (!nameCol) return; // 이름 짝이 있는 3열만 (MAIL_USER1~5 는 짝 이름 컬럼 없음)
      const row = GridUtils.getRow(g, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const id = str(row[binding]).trim();
      if (!id) {
        // 삭제: 이름도 함께 비운다.
        row[nameCol] = '';
        sender.invalidate();
        return;
      }
      void lookupUserName(id, langCd).then(res => {
        if (res.status === 'defer') return; // 조회 실패 — 기존 이름 유지
        row[nameCol] = res.status === 'match' ? res.name : ''; // 무매칭(잘못된 ID)은 이름 비움
        sender.invalidate();
      });
    };
    g.cellEditEnded.addHandler(deriveName);
    g.pastedCell.addHandler(deriveName);

    return () => {
      try {
        g.cellEditEnded?.removeHandler(deriveName);
        g.pastedCell?.removeHandler(deriveName);
      } catch {
        /* unmount race */
      }
    };
    // columns 를 deps 에 포함해야 한다 — gridRef.current 는 DataGrid 가 FlexGrid initialized 이후의
    //   자체 effect(DataGrid.tsx)에서 세팅하므로, 부모 마운트 시점엔 아직 undefined 다. columns 는
    //   admin 컬럼메타가 async 로드될 때 바뀌며(그땐 그리드 준비 완료) 이 effect 를 재실행시켜 핸들러가
    //   확실히 붙는다(formatItem effect 와 동일 신호). langCd 만 두면 마운트 1회로 끝나 미부착된다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, langCd]);

  // 이미지셀(USER 계열 8) 더블클릭 -> UserInfoPopup(AS-IS cs:626~831). 그리드가 기본 편집 가능이라
  //   조회 직후 바로 동작한다.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!isUserPopupColumn(binding)) return;
    // AS-IS cs:628 `if (siMain.IsLock(SheetName) == false)` 의 권한축 치환 — 권한 없으면 팝업 미오픈.
    if (!canEdit) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    // 같은 더블클릭이 연 인라인 에디터를 먼저 닫는다. FPTextModal 은 키인도 허용되는 셀이라
    //   에디터가 열린 채 팝업이 뜨면, 팝업이 row[binding] 에 쓴 값을 뒤늦게 닫히는 에디터가
    //   편집 전 값으로 덮어쓸 수 있다(팝업 선택이 조용히 사라지는 경로).
    g.finishEditing(true);
    onUserCellDblClick(row, binding);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={!canEdit}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // AS-IS SmartColMerge(cs:223,364,622) 재현 — 동일값 셀 세로 병합. CustomMergeManager 는
      //   좌→우 누적 키라 Division -> Operation Group -> From Site 계층으로 병합되고(상위 컬럼이
      //   모두 같아야 하위가 붙는다), Model 이하 값이 다른 컬럼은 실제로 병합되지 않는다(design 03 §3).
      allowMerging={AllowMerging.Cells}
      dblClick={handleDblClick}
      gotFocus={onFocus}
    />
  );
};
