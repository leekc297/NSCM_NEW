import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { buildLeafColumnDataMap, GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  CELL_COMBO_COLUMNS,
  DIVISION_EXCLUSIVE,
  EE_DIVISION,
  FIXED_DIVISION,
  ITEM_POPUP_COLUMN,
  MENU_ID,
  PLAN_TOGGLE_COLUMNS,
  PLAN_TYPE_PLAN,
  PROJECT_POPUP_COLUMN,
  SCREEN_TEXT,
} from '../shipment-change-request.constants';
import type { MainRow } from '../shipment-change-request.types';
import { buildColumns } from '../utils/shipmentChangeRequestColumns';
import {
  applyAutoReasonCode,
  applyChangeReasonCode,
  clearBodDerived,
  firstMissingIncotermsPrereq,
  firstMissingToSitePrereq,
  firstMissingTransportModePrereq,
  isReasonCodeMissing,
  markPropagated,
  propagateChangeReason,
  setEditMain,
  shipmentDateDerivedOf,
  soGroupRows,
  STATUS_PROPAGATION,
  T07_TRIGGER_COLUMNS,
  trackedWriter,
  VALUE_PROPAGATION,
  writeShipmentDateDerived,
  type PrereqLabel,
  type ShipmentDateDerived,
} from '../utils/shipmentChangeRequestDerive';
import {
  isEndCustomerDivision,
  isEndCustomerLockedOnInsert,
  isInsertedRow,
  isRowEditable,
} from '../utils/shipmentChangeRequestEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  changeType: string;
  // EDIT 권한 축(모드 토글 아님) — AS-IS SwitchLock 상태기계는 미이식(편집 기본 ON, convert-core §2.4).
  canEdit: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  /** 화면 주입 셀콤보 dataMap — 컬럼ID -> 후보행(From/To Site). 값=site_id / 표시=설명. */
  cellDataMaps: Record<string, ComboResponse[] | undefined>;
  // 이미지셀(ITEM_ID/PROJECT_CODE) 더블클릭 -> 페이지가 팝업 오픈(row/binding 기억). design 03 §1.1.
  onPopupCellDblClick: (row: Record<string, unknown>, binding: string) => void;
  // End Customer 후보를 그 행 기준으로 재조회·1건 자동확정(AS-IS setEndCustomer cs:5766). To Site 편집 시.
  onEndCustomerSourceChanged: (row: Record<string, unknown>) => void;
  // 활성 셀이 신규행 END_CUSTOMER 로 이동할 때 — 그 행 기준으로 드롭다운 슬롯 동기 교체(자동확정 없음).
  //   공유 dataMap 슬롯이 다른 행 후보로 덮여 있던 것을 포커스마다 맞춘다(행별 셀 콤보 등가).
  onEndCustomerCellFocus: (row: Record<string, unknown>) => void;
  // 변경 차단·선행값 안내 alert. defaultValue 미등록 시 fallback 문구, arg 는 "{0}" 치환값(MSG00098).
  onBlockedEdit: (msgKey: string, defaultValue?: string, arg?: string) => void;
  // 그리드 포커스 획득 시 — 공통 툴바 Sort(F3)/Filter(F4) 타깃을 이 그리드로(페이지가 추적).
  onGridFocus?: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const POPUP_COLUMNS = new Set<string>([ITEM_POPUP_COLUMN, PROJECT_POPUP_COLUMN]);

// AS-IS spdMain "Shipment Change Request" (65열). 편집 기본 ON — 행 상태/컬럼 화이트리스트(editLock)로만 잠근다.
export const ShipmentChangeRequestMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  changeType,
  canEdit,
  adminColumns,
  cellDataMaps,
  onPopupCellDblClick,
  onEndCustomerSourceChanged,
  onEndCustomerCellFocus,
  onBlockedEdit,
  onGridFocus,
}: Props) => {
  const { t } = useTranslation();
  // staticColumns = admin 메타(단일 헤더). + Division 40/EE 상호배타 가시성을 **여기서** 굽는다
  //   (design 03 §2 #2, AS-IS cs:579-592): 40/EE 면 END_CUSTOMER 노출·PROJECT_CODE/NAME 숨김, 그 외 반대.
  //   주의: 사후 effect 로 Wijmo 컬럼 visible 을 토글하면 공용 DataGrid 의 columnGroups 재빌드가
  //   메타값으로 되돌려 토글이 무효화된다(자매 dataMap effect 와 달리 updatedLayout 재부착이 없던 버그 —
  //   div 40 고정인데 Project* 가 계속 노출됐다). staticColumns 에 실으면 DataGrid 가 매 재빌드마다
  //   존중한다(메타 visible:false 컬럼이 항상 숨겨지는 것과 동일 경로).
  const columns = useMemo(() => {
    const base = buildColumns(adminColumns, false);
    const isEndCustomerDiv = division === FIXED_DIVISION || division === EE_DIVISION;
    return base.map(col => {
      if (col.colNm === DIVISION_EXCLUSIVE.END_CUSTOMER) {
        return { ...col, visible: isEndCustomerDiv };
      }
      if (
        col.colNm === DIVISION_EXCLUSIVE.PROJECT_CODE ||
        col.colNm === DIVISION_EXCLUSIVE.PROJECT_NAME
      ) {
        return { ...col, visible: !isEndCustomerDiv };
      }
      return col;
    });
  }, [adminColumns, division]);

  /**
   * From/To Site 셀콤보 dataMap — `값=site_id / 표시=SITE_DESCRIPTION`.
   *   이게 없으면 신규행 복제값(코드)이 `IN00142000_40-P` 처럼 날것으로 보인다
   *   (사용자 신고 2026-10-13). 복제가 코드를 넣는 것은 저장 계약상 **정상**이고, 고칠 축은 표시다.
   *
   *   `buildColumns` 가 dataMap 을 굽지 않는 이유와 짝이다 — 여기서 메모이즈해 두고 아래 effect 가
   *   `col.dataMap =` 한 줄로 붙인다(columnGroups 재빌드 없음 = 깜빡임 없음).
   */
  const siteDataMaps = useMemo(() => {
    const build = (binding: string) => {
      const cfg = columns.find(c => c.colNm === binding);
      const comboRows = cellDataMaps[binding];
      return cfg && comboRows ? buildLeafColumnDataMap({ ...cfg, dataMap: comboRows }) : undefined;
    };
    return {
      [CELL_COMBO_COLUMNS.FROM_SITE_DESCRIPTION]: build(
        CELL_COMBO_COLUMNS.FROM_SITE_DESCRIPTION
      ),
      [CELL_COMBO_COLUMNS.TO_SITE_DESCRIPTION]: build(CELL_COMBO_COLUMNS.TO_SITE_DESCRIPTION),
      // End Customer 는 포커스 행마다 재조회된 후보(cellDataMaps[END_CUSTOMER])로 같은 슬롯을 교체한다.
      //   From/To 와 달리 행별이지만, 한 번에 한 행만 편집하므로 컬럼 dataMap 1개를 스왑하는 것으로 족하다
      //   (자매 SSP0200 미러). 미조회면 cellDataMaps 가 undefined 라 build 가 undefined 를 돌려준다.
      [CELL_COMBO_COLUMNS.END_CUSTOMER]: build(CELL_COMBO_COLUMNS.END_CUSTOMER),
    };
  }, [columns, cellDataMaps]);

  // columnGroups 재대입(구조 변경)마다 col.dataMap 이 지워지므로 updatedLayout 에서 재부착한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const attach = () => {
      for (const binding of Object.values(CELL_COMBO_COLUMNS)) {
        const col = g.getColumn(binding);
        const map = siteDataMaps[binding] ?? null; // Wijmo Column.dataMap 은 DataMap | null
        if (col && col.dataMap !== map) col.dataMap = map;
      }
    };
    g.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        g.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, siteDataMaps]);

  // 셀콤보(A 메타 4종 + B 재조회 6종)의 @토큰 해소 — divisionId 는 40 고정. per-row 좁힘(PARAM2)·
  //   재조회(PARAM10='D')는 admin 메타 구동(useRowParamCombos). CN-3: AS-IS PARAM2/9/10 NULL 이라
  //   메타 미보강 시 후보 좁힘이 재현되지 않음(05_register.sql / 확인필요).
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // 콜백을 ref 로 들고 있어 cellEditEnded effect 를 재등록하지 않는다 — onEndCustomerSourceChanged 는
  //   매 렌더 재생성(내부 loadEndCustomer 가 조회마다 바뀜)이라 effect 가 직접 닫으면 stale 참조가 된다.
  const onEndCustomerSourceChangedRef = useRef(onEndCustomerSourceChanged);
  onEndCustomerSourceChangedRef.current = onEndCustomerSourceChanged;
  const onEndCustomerCellFocusRef = useRef(onEndCustomerCellFocus);
  onEndCustomerCellFocusRef.current = onEndCustomerCellFocus;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 게이트 — **행 조건 + 팝업셀 취소만** 한다(표준 COL-02 / hook #130). 열 축(INPUT_TP_CD)은
    //   공용 DataGrid 의 beginningEdit/pastingCell 핸들러(GridUtils.isEditableCell)가 이미 판정한다.
    //   그래서 여기서는 e.cancel 을 **true 로만** 설정하고 false 로 되돌리지 않는다 — 되돌리면
    //   공용 핸들러의 메타 잠금이 무효화된다(종전 `e.cancel = !isCellEditable(...)` 가 바로 그 메타
    //   override 위반이었다). 선행조건: INPUT_TP_CD 정비 SQL(design/31_fix_main_input-tp-cd_standard-parity.sql)
    //   적용 — 미적용이면 메타가 전건 'S'라 편집이 전면 잠긴다.
    const editGate = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      // 팝업셀(ITEM_ID/PROJECT_CODE)은 key-in + 붙여넣기 + 더블클릭 팝업 동시 허용(FPTextModal, 사용자
      //   지시 2026-11-17). 인라인 편집을 더 이상 취소하지 않는다 — 열 축은 메타(INPUT_TP_CD=IM → 신규행
      //   한정)와 공용 isEditableCell 이, 더블클릭 팝업은 handleDblClick 이 담당한다. PROJECT_CODE 는
      //   메타 CELL_CONTROL_OBJECT_TYPE_CODE 를 FPModal→FPTextModal 로 바꿔야 공용 beginningEdit 의
      //   FPModal 취소 분기에 안 걸린다(design/32_fix_main_popup-cell_keyin_fptextmodal.sql).
      // END_CUSTOMER 는 메타상 IM(편집가능)이지만 Insert(복사) 신규행에서만 추가로 잠근다 —
      //   AS-IS 비대칭(Insert=잠금 / New=편집). 메타로 표현 못 하는 생성경로 차이라 여기서 가른다.
      if (isEndCustomerLockedOnInsert(row, binding)) {
        e.cancel = true;
        return;
      }
      // 행 조건(신규행 / 기존 status='C' / ERP 미확정)에 걸리면 잠근다(erp_status='C' 차단 포함).
      if (!isRowEditable(row, canEdit)) e.cancel = true;
    };
    g.beginningEdit.addHandler(editGate);
    g.pastingCell.addHandler(editGate);

    // 셀 값 변경 파생 — EDIT_MAIN 플래그 + SO No 그룹 전파 + Reason Code/Detail 가드(§3.2).
    //   편집 종료(cellEditEnded)와 **붙여넣기(pastedCell)** 양쪽에 등록한다 — AS-IS shtMain_Change 는
    //   붙여넣기에도 발동해 수량·날짜·운송모드가 동일 SO 로 전파된다(리뷰 #2). pastingCell(editGate)이
    //   비편집 셀 붙여넣기를 이미 취소하므로 여기는 통과한 편집 셀만 온다(ITEM_ID/PROJECT_CODE 는 이제
    //   편집 허용 — switch 에 케이스가 없어 default no-op, 값만 기록된다).
    const applyCellChange = (
      sender: FlexGridType,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const all = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      // 파생·전파는 EditTracker 를 경유한다 — 형제 행 값 복사가 CRUD_TYPE='M' 마킹까지 해야
      //   draftingModifyGroups(CRUD {I,M,D})에 묶여 같은 SO 전행이 함께 저장된다(종전엔 EDIT_MAIN 만
      //   찍어 CRUD 가 비어 저장 그룹에서 빠졌다 — 사용자 신고 2026-10-26).
      const write = trackedWriter(editTrackerRef.current);
      // SHIPMENT_DATE 파생값은 편집 행에서 한 번 구해 전파 대상에도 그대로 쓴다(AS-IS cs:5553-5558).
      let dateDerived: ShipmentDateDerived | null = null;
      // 선행값 안내 라벨 — lbl 이 있으면 i18n(t), 없으면 fallback 영문(리뷰 #3).
      const label = (p: PrereqLabel): string =>
        p.lbl ? t(p.lbl, { defaultValue: p.fallback }) : p.fallback;

      switch (binding) {
        case 'FROM_SITE_DESCRIPTION':
          // From Site 변경 cascade(AS-IS cs:4773-4786) — ITEM_ID 있으면 하위 파생 3열 clear.
          if (str(row.ITEM_ID)) clearBodDerived(row, write);
          setEditMain(row, 'Y');
          break;
        case 'TO_SITE_DESCRIPTION': {
          // To Site 변경 선행값 — From Site 선행 필수(AS-IS cs:4795-4801, MSG00098). 위반 시 안내 후 중단.
          const toSiteMissing = firstMissingToSitePrereq(row);
          if (toSiteMissing) {
            onBlockedEdit('FROM_SITE_REQUIRED', 'Please select the {0} first.', label(toSiteMissing));
            sender.invalidate();
            return;
          }
          // ITEM_ID 있으면 하위 파생 3열 clear(AS-IS cs:4804-4808). End Customer 재조회는 아래.
          if (str(row.ITEM_ID)) clearBodDerived(row, write);
          setEditMain(row, 'Y');
          break;
        }
        case 'INCOTERMS': {
          // 선행값 Div→From Site→To Site→Model 검증(AS-IS cs:4895-4932, MSG00098 "먼저 {0}을…").
          //   위반 시 INCOTERMS 를 되돌리고 누락 필드를 특정해 안내 후 중단한다.
          const missing = firstMissingIncotermsPrereq(row);
          if (missing) {
            write(row, 'INCOTERMS', '');
            onBlockedEdit('FROM_SITE_REQUIRED', 'Please select the {0} first.', label(missing));
            sender.invalidate();
            return;
          }
          // 통과 시 TRANSPORT_MODE/BOD clear(AS-IS cs:4934-4935). FindData_BOD 재조회는 저장 SP 소관.
          write(row, 'TRANSPORT_MODE', '');
          write(row, 'BOD_ID', '');
          setEditMain(row, 'Y');
          break;
        }
        case 'TRANSPORT_MODE': {
          // 선행값 Shipment Date→Incoterms 검증(AS-IS cs:4963-4982, MSG00098). 위반 시 되돌리고 중단.
          //   (후보 없음 MSG00293 은 TRANSPORT_MODE 가 메타 셀콤보라 범위 밖.)
          const tmMissing = firstMissingTransportModePrereq(row);
          if (tmMissing) {
            write(row, 'TRANSPORT_MODE', '');
            write(row, 'BOD_ID', '');
            onBlockedEdit('FROM_SITE_REQUIRED', 'Please select the {0} first.', label(tmMissing));
            sender.invalidate();
            return;
          }
          // NEW_* 경로·BOD 파생은 SP 이관(AS-IS 주석). FE 는 EDIT_MAIN 마킹 + 값 전파만(§3.2:231).
          setEditMain(row, 'Y');
          break;
        }
        case 'SHIPMENT_DATE': {
          // NEW_LT_DAY 공백이면 파생 없음 → AS-IS 처럼 그 자리에서 끝낸다(마킹·전파 없음, cs:5528 return).
          dateDerived = shipmentDateDerivedOf(row, row.SHIPMENT_DATE);
          if (!dateDerived) {
            sender.invalidate();
            return;
          }
          writeShipmentDateDerived(row, dateDerived, write);
          setEditMain(row, 'Y');
          break;
        }
        case 'CHANGE_REASON_CODE':
          applyChangeReasonCode(row, str(row.CHANGE_REASON_CODE), write);
          break;
        case 'CHANGE_REASON_DETAIL': {
          // Reason Detail 입력 전 Reason Code 선행 필수(MSG00287) — 누락 시 값 리셋.
          if (isReasonCodeMissing(row)) {
            write(row, 'CHANGE_REASON_DETAIL', '');
            onBlockedEdit('REASON_CODE_REQUIRED');
            sender.invalidate();
            return;
          }
          setEditMain(row, 'Y');
          break;
        }
        default:
          // REMARKS/REMARKS2/SHIPMENT_CONFIRM_QTY — 자기행 EDIT_MAIN 마킹(행상태 전파는 아래).
          if (STATUS_PROPAGATION.has(binding)) setEditMain(row, 'Y');
      }

      // 실질 변경(QTY/DATE/TRANS/INCOTERMS/SHIPTO) 수정행 사유코드 미입력 → T07 자동 세팅
      //   (AS-IS SSP_Main_Validation cs:3211-3215). 사유 컬럼이 30_fix 로 숨겨져 수동 입력 경로가 없어
      //   이게 없으면 사유 빈 채로 저장된다. 신규행·remarks-only 는 헬퍼/트리거셋이 걸러낸다.
      if (T07_TRIGGER_COLUMNS.has(binding)) applyAutoReasonCode(row);

      // To Site 변경 → End Customer 후보(scmSiteId 바인드) 재조회·1건 자동확정(AS-IS cs:5101 setEndCustomer).
      //   div40/EE 가드·자동확정은 페이지 콜백이 담당한다. ref 로 최신 콜백을 읽어 stale 참조를 피한다.
      if (binding === 'TO_SITE_DESCRIPTION') onEndCustomerSourceChangedRef.current(row);

      // 동일 SO 그룹 전파(design 03 §3.2) — 값(SHIPMENT_DATE/TRANSPORT_MODE/CHANGE_REASON)은 **값 복사**,
      //   REMARKS/REMARKS2/SHIPMENT_CONFIRM_QTY 는 **행상태만**(markPropagated). 값 복사는 write(=tracked)
      //   경유라 형제 행 CRUD_TYPE='M' 이 찍혀 저장 그룹에 포함된다.
      if (VALUE_PROPAGATION.has(binding) || STATUS_PROPAGATION.has(binding)) {
        for (const target of soGroupRows(all, row)) {
          if (target === row) continue;
          let markChanged = true;
          if (binding === 'TRANSPORT_MODE') {
            write(target, 'TRANSPORT_MODE', row[binding]);
          } else if (binding === 'CHANGE_REASON_CODE') {
            // '-' 전파는 대상 행도 DETAIL clear + EDIT_MAIN='N' + 변경행 마킹 없음(cs:5087-5093).
            markChanged = propagateChangeReason(
              target,
              str(row[binding]),
              str(row.CHANGE_REASON_DETAIL),
              write
            );
          } else if (binding === 'CHANGE_REASON_DETAIL') {
            write(target, 'CHANGE_REASON_DETAIL', row[binding]);
          } else if (binding === 'SHIPMENT_DATE') {
            if (!dateDerived) continue;
            writeShipmentDateDerived(target, dateDerived, write);
          }
          // 값 전파 행 + REMARKS/REMARKS2/QTY 행상태 전파 — CRUD_TYPE='M' + EDIT_MAIN='Y' 강제.
          if (markChanged) markPropagated(target);
          // 값으로 전파된 실질 컬럼(TransMode/Date)은 형제 행도 실질 변경이라 사유코드 T07 대상이다
          //   (AS-IS 는 Validation_Check 가 행마다 판정). 행상태만 전파(QTY/REMARKS)는 형제 값이 안 바뀌어
          //   T07 대상이 아니다 — 그래서 여기 두 컬럼으로 한정한다.
          if (markChanged && (binding === 'TRANSPORT_MODE' || binding === 'SHIPMENT_DATE')) {
            applyAutoReasonCode(target);
          }
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(applyCellChange);
    g.pastedCell.addHandler(applyCellChange);

    // 조건부 포맷 — 잠금 회색 / 편집 노랑(hook #95 3색) + 동적 컬럼 토글(changeType='P').
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      // 편집색(노랑) = 행 조건(isRowEditable) AND 열 메타(INPUT_TP_CD -> GridUtils.isEditableCell) 둘 다 통과.
      //   공용 DataGrid 편집색은 열 메타만 보므로 여기서 행 조건까지 반영해 최종 확정한다(자매 SSP0200 미러).
      //   추가로 END_CUSTOMER 는 Insert 복사행에서 잠금색으로 — editGate 의 추가잠금과 일치시킨다.
      //   수정행 강조는 StringAction/EDIT_MAIN.
      const editable =
        isRowEditable(row, canEdit) &&
        GridUtils.isEditableCell(sender, e.row, e.col) &&
        !isEndCustomerLockedOnInsert(row, binding);
      e.cell.classList.toggle('wj-cell-editable', editable);
      e.cell.classList.toggle('wj-cell-locked', !editable);
    };
    g.formatItem.addHandler(formatItemHandler);

    // End Customer 드롭다운은 **컬럼 dataMap 1개를 전행이 공유**한다(Wijmo 구조). AS-IS 는 행별 셀 콤보
    //   (SetCellTypeCombo(iROW,...) cs:5780)라 행마다 후보가 독립이지만, TO-BE 는 마지막 조회(Insert/New/
    //   To Site 트리거) 행 후보가 전역에 남아 다른 행 드롭다운에도 그대로 보인다(사용자 신고 2026-10-27).
    //   -> 활성 셀이 **신규행** END_CUSTOMER 로 이동할 때 그 행 기준으로 슬롯을 동기 교체한다(캐시 적중이면
    //   즉시, 미캐시면 비동기 조회, 빈 신규행이면 슬롯 비움). 자동확정은 안 한다(AS-IS 도 포커스에선 안 함).
    //   기존행은 END_CUSTOMER 가 잠금(IM=신규행 전용)이라 건드리지 않는다.
    const refreshEndCustomerOnFocus = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'END_CUSTOMER') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row || !isInsertedRow(row)) return;
      onEndCustomerCellFocusRef.current(row);
    };
    g.selectionChanged.addHandler(refreshEndCustomerOnFocus);

    return () => {
      try {
        g.beginningEdit?.removeHandler(editGate);
        g.pastingCell?.removeHandler(editGate);
        g.cellEditEnded?.removeHandler(applyCellChange);
        g.pastedCell?.removeHandler(applyCellChange);
        g.formatItem?.removeHandler(formatItemHandler);
        g.selectionChanged?.removeHandler(refreshEndCustomerOnFocus);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, canEdit, editTrackerRef]);

  // 동적 헤더/컬럼 토글 — changeType='P'(Plan): CONFIRM_ID 숨김 + Qty 라벨 변경(design 03 §2 #1).
  //   메인 ERP_SO_NO 는 **이 토글 대상이 아니다** — AS-IS 가 else 분기에서 되살리지 않아(cs:569 주석)
  //   메타 VISIBLE_FLAG='N' 으로 컬럼셋에서 빠져 있다(PLAN_TOGGLE_COLUMNS 주석 / 24_fix SQL).
  //   Division 40/EE 상호배타(design 03 §2 #2)는 여기가 아니라 staticColumns(columns useMemo)에서
  //   처리한다 — effect 로 토글하면 columnGroups 재빌드가 메타값으로 되돌리기 때문(위 columns 주석).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const isPlan = changeType === PLAN_TYPE_PLAN;
    for (const c of g.columns) {
      if (c.binding && PLAN_TOGGLE_COLUMNS.includes(c.binding)) {
        c.visible = !isPlan;
      }
      if (c.binding === 'SHIPMENT_CONFIRM_QTY') {
        // AS-IS cs:562/574 `MessageHelper.GetTerm("Shipment Plan Qty"/"Shipment Confirm Qty")`.
        //   두 문구는 TO-BE SCM_ADM_MSG_M 0행이라 MSG/LBL 코드를 빌리지 않고 화면 전용 키 + defaultValue
        //   로 둔다(hook #114 — 번호를 빌리면 그 코드가 등록되는 순간 엉뚱한 문구가 뜬다).
        //   `*` 는 메타 COLUMN_LABEL_NAME('Shipment Qty*') 의 필수 표식 승계.
        c.header = isPlan
          ? t(SCREEN_TEXT.QTY_HEADER_PLAN, { defaultValue: 'Shipment Plan Qty*' })
          : t(SCREEN_TEXT.QTY_HEADER_CONFIRM, { defaultValue: 'Shipment Confirm Qty*' });
      }
    }
    g.invalidate();
  }, [changeType, columns, gridRef, t]);

  // 이미지셀(ITEM_ID/PROJECT_CODE) 더블클릭 -> 팝업. 신규행/40·EE 배타는 편집 화이트리스트가 판정.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g || !canEdit) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!POPUP_COLUMNS.has(binding)) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    // 신규행에서만 팝업 편집(ITEM_ID/PROJECT_CODE). PROJECT_CODE 는 40/EE 아닌 division 만.
    if (!isInsertedRow(row)) return;
    if (binding === PROJECT_POPUP_COLUMN && isEndCustomerDivision(row)) return;
    // AS-IS(cs:4334-4356)는 팝업 오픈 전 Div/From/To Site 선행검사(MSG00098)를 했으나 **이관하지 않는다**:
    //   그 가드의 전제는 AS-IS SSP0026 팝업이 From Site 로 모델을 필터링한다는 것인데, TO-BE 팝업
    //   (MaterialByDivisionModal/COM0013)은 division+item 으로만 조회하고 site 를 받지 않는다(G-9 드리프트).
    //   site 미입력 행은 저장 시 SAVE_NEW 가 'X'(BOD 무효)로 명확히 거부하므로(saveFailMessage new 'X'),
    //   팝업 선오픈을 막을 정합성 근거가 없다. 07 §5 G1② "미이식" → "의도적 제외(전제 소멸)".
    onPopupCellDblClick(row, binding);
  };

  return (
    // isReadOnly 를 걸지 않는다 — 편집 기본 ON(convert-core §2.1(11)/§2.4·ANL-06). 편집 가부는 메타
    //   (INPUT_TP_CD)와 행 조건(editGate/formatItem 의 isRowEditable)이 담당한다(COL-01·GRID-07, 자매
    //   SSP0200 과 동일). 그리드 레벨 읽기전용으로 막으면 수정상태(CRUD) 행헤더 인디케이터까지 사라진다.
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      /* 자매 SSP0200 메인 그리드와 동일하게 맞춘다(사용자 지시 2026-10-07 "기능이 동일하게").
         SSP0200 은 allowMerging 을 **주지 않아** 공용 기본값 `ColumnHeaders` 로 동작한다
         (DataGrid.tsx:553) — 여기서는 같은 값을 명시해 의도를 드러낸다.
         이 시트는 단일 헤더(main 메타 SMALL_CLASS_LABEL_NAME 0행 실측)라 헤더 병합 대상이 없어
         **외관상 차이는 없고**, 바뀌는 것은 데이터 셀 세로병합 유무뿐이다.
         트레이드오프: AS-IS `siMain.SmartColMerge()`(cs:1446·2732 live) 의 데이터 셀 병합은 포기한다 —
         자매 화면과의 동작 일치를 우선한 사용자 결정이다. 되살리려면 `AllowMerging.Cells` 로 되돌린다. */
      allowMerging={AllowMerging.ColumnHeaders}
      dblClick={handleDblClick}
      gotFocus={onGridFocus}
    />
  );
};
