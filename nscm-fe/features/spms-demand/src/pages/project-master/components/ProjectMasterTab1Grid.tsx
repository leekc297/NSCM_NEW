import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  type MutableRefObject,
  type Ref,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { createPortal } from 'react-dom';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { Button } from '@shared/lges';

import { colorTypeColumnOf, TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { attachComboCascadeAutoFill } from '../../../lib/comboCascadeAutoFill';
import { DataGrid, keepDivisionCodeDisplay, keepServerComboOrder } from '../../../lib/grid';
import { MODAL_ATTR, REG_ACTION_ATTR, TAG_ATTR, TAG_SOURCE } from '../project-master.constants';
import type { Tab1Row } from '../project-master.types';
import styles from '../ProjectMaster.module.scss';
import { isCellEditableTab1, isModRow } from '../utils/project-master.editLock';
import { toDisplayDate } from '../utils/project-master.validate';
import { toText } from '../utils/project-master.value';

// ⭐ SDM5010 TAB1 '프로젝트 등록 요청' 그리드 — 정적 24컬럼(계약 ④) admin 메타 100% 주도 (hook #113).
//   - 편집 게이트 = utils/project-master.editLock (INPUT_TP_CD × DPJT_CODE_MOD_YN —
//     P-06/P-07. EditTracker 가 편집 확정 시 CRUD_TYPE 'M' 마킹 → 편집값은 승인 파라미터로 전달 E05).
//   - 셀 콤보 : CODE 컬럼 직결 dataMap(CODE→NAME 표시 — 콤보 셀 명칭 표시 의무). division 종속은
//     조회 Division 단일 축(따옴표 전달) — Division 변경 시 그리드가 비워지므로 dataMap 재구성으로
//     충분(Cascade §4). 행 단위 종속은 CF-15 (CELL_TYPE→STACK_METHOD) 1건: beginningEdit 행값
//     dataMap 스왑 + cellEditEnded 기본 dataMap 원복 + Cell Type 변경 시 Stack Method clear (hook #59 §5-G).
//   - TAG 셀 (메타 ATTRIBUTE1='TAG') : 표시 = TAG_SOURCE NAME 컬럼 / 색 = COLOR_TYPE 컬럼 데이터 주도.
//   - FPModal 셀 (DPJT_ATUH_REG_STR/ATTRIBUTE1='ProjectAuthRegModal' — 커서 실명 유지 F-12) :
//     SP '권한관리' 리터럴 → 링크 렌더 → 권한관리 모달 (E08).
//   - REG_COL 셀 (메타 ATTRIBUTE1='REG_ACTION' — 커서 '' 반환·FE 파생 렌더 F-15) : 행 내
//     [승인][반려] 버튼 (hasButton CONFIRM/CANCEL 게이트 — E06/E07 행 단건).
//   - '수정'(DPJT_REG_CAT='MOD') 행 = 행 단위 색상 (P-05/F-10 — formatItem 전 셀 클래스 토글).
//   - DATE 원형 커서 컬럼(SOP_DATE — FPDateText 메타) : 'YYYY.MM.DD' 표시.

interface Props {
  rows: Tab1Row[];
  gridRef: Ref<FlexGridType<Tab1Row>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  excludeFromDirtyCheck?: boolean;
  divisionId: string;
  staticColumns?: RawFlexGridColumnConfig[];
  // 행 버튼 노출 게이트 (hasButton CONFIRM/CANCEL — 페이지 소유)
  canConfirm: boolean;
  canCancel: boolean;
  approveLabel: string; // LBL00623 (계약 ③ — i18n 은 페이지 t() 산출 전달)
  rejectLabel: string; // LBL00624
  onConfirmClick?: (row: Tab1Row) => void;
  onCancelClick?: (row: Tab1Row) => void;
  onAuthRegCellClick?: (row: Tab1Row) => void;
}

export const ProjectMasterTab1Grid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  excludeFromDirtyCheck,
  divisionId,
  staticColumns,
  canConfirm,
  canCancel,
  approveLabel,
  rejectLabel,
  onConfirmClick,
  onCancelClick,
  onAuthRegCellClick,
}: Props) => {
  const tagLayerRef = useRef<TagLayerHandle>(null);
  const actionPortalsRef = useRef<Map<string, HTMLDivElement>>(new Map());
  const [, setPortalTick] = useState(0);

  // ⭐ wijmo react 는 initialized 를 setTimeout 으로 비동기 호출한다 — 컬럼 메타 도착으로 key 가
  //   바뀌어 그리드가 재생성된 렌더에서는 gridRef.current 가 아직 비어 있다(구 DataGrid cleanup 이
  //   ref 를 undefined 로 되돌리기까지 함). ref 만 보는 effect 는 그 렌더에서 조용히 skip 되는데,
  //   TAB1 자동조회(E01-3)처럼 메타 도착이 마지막 재렌더면 핸들러(편집색/TAG/클릭)가 영영 안 걸린다.
  //   initialized 를 state 로 받아 등록 effect 를 그 뒤에 다시 태운다 (공용 formatEditableColumns
  //   등록 완료 후 호출되므로 "본 판정이 최종" 순서도 그대로 보장).
  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지.
  //   콤보 행 필터 ATTRIBUTE2 도 admin Column param2 단일 원천 — FE patch 없음)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  // ⭐ 메타 ref 미러 — initialized 1회 등록 핸들러(keepServerComboOrder)도 최신 ATTRIBUTE2 를 본다
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));

  const [gridControl, setGridControl] = useState<FlexGridType<Tab1Row> | null>(null);
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    // 행 필터(ATTRIBUTE2) 콤보는 그 행으로 좁힌 서버 순서로 복원 (사업부 중복 NAME 섞임 방지)
    keepServerComboOrder(grid, binding => colMetaRef.current.get(binding)?.attribute2);
    keepDivisionCodeDisplay(grid);
    setGridControl(grid as FlexGridType<Tab1Row>);
  }, []);

  // ⭐ 페이지 콜백 ref 미러 — effect 의존성에서 빼 클릭→페이지 리렌더마다 핸들러 재등록 +
  //   invalidate(true) 전체 재그리기(깜빡임)가 나는 것을 막는다 (datagrid-rerender-flicker)
  const onAuthRegCellClickRef = useRef(onAuthRegCellClick);
  onAuthRegCellClickRef.current = onAuthRegCellClick;

  const actionKey = (row: Tab1Row) => String(row.DPJT_KEY ?? '');
  const staticBindingSet = useMemo(
    () => new Set(visibleColumns.map(c => c.colNm)),
    [visibleColumns]
  );

  // ===== Grid 콤보 — 메타(FPComboBox + cellCboDataTp) 기반. division 종속 콤보는 따옴표 전달
  //   (BE makeComboQuery raw 치환 — @divisionId 토큰 없는 콤보는 전달해도 무해.
  //   CELL_TYPE 좁힘은 ATTRIBUTE2 행 필터 담당) =====
  const comboParams = useMemo(() => ({ divisionId: `'${divisionId || 'ALL'}'` }), [divisionId]);

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const formatHandler = (_s: FlexGridType<Tab1Row>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const rowItem = g.rows[e.row]?.dataItem as Tab1Row | undefined;
      const meta = colMetaRef.current.get(binding);
      if (!rowItem || !meta) return;
      const rec = rowItem as Record<string, unknown>;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      const inputTp = inputTpRef.current.get(binding);
      const editable = isCellEditableTab1(inputTp, binding, rowItem);

      // ⭐ '수정' 구분 행 색상 (P-05/F-10 — DPJT_REG_CAT='MOD' 행 단위. 색상 토큰 미기재(T-7)라
      //   공통 warning 계열 임시 — 편집 Yellow(.wj-cell-editable)가 최종 우선)
      toggleClass(e.cell, styles.rowMod, isModRow(rowItem) && editable);

      // ⚠ 편집 중 셀은 건드리지 않는다 — 삽입된 편집기 <input> 이 지워지는 사고 방어 (DMF0044 계보)
      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;
      const isTagColumn = meta.attribute1 === TAG_ATTR;

      if (!isTagColumn || isEditing) {
        tagLayerRef.current?.clear(e.cell);
      }
      toggleClass(e.cell, styles.authRegistrationLink, ctrlType === 'FPModal');

      // ⭐ TAG 렌더 — 표시 = TAG_SOURCE NAME 컬럼 / 색 = COLOR_TYPE 컬럼 데이터 주도 (미지정 = Gray)
      if (isTagColumn && !isEditing) {
        const src = TAG_SOURCE[binding];
        const text = toText(
          (src ? rec[src.name] : undefined) ?? rec[`${binding}_NAME`] ?? rec[binding] ?? ''
        );
        const colorType = toText(
          (src ? rec[src.color] : undefined) ?? rec[colorTypeColumnOf(binding)] ?? ''
        );
        if (text !== '') {
          tagLayerRef.current?.apply(e.cell, text, colorType);
        } else {
          tagLayerRef.current?.clear(e.cell);
        }
        return;
      }

      // ⭐ FPModal 셀 (권한관리 링크 — E08) : SP '권한관리' 리터럴 값 → 링크 렌더
      if (ctrlType === 'FPModal') {
        toggleClass(e.cell, 'wj-cell-popup', false);
        const label = toText(rec[binding]);
        e.cell.textContent = label;
        return;
      }

      // ⭐ REG_COL 셀 (승인/반려 행 버튼 — F-15 FE 파생 렌더. hasButton 게이트 E06/E07)
      if (meta.attribute1 === REG_ACTION_ATTR) {
        e.cell.style.textAlign = 'center';
        const key = actionKey(rowItem);
        const existing = actionPortalsRef.current.get(key);
        if (existing) {
          if (e.cell.firstElementChild !== existing) e.cell.replaceChildren(existing);
          return;
        }
        const container = globalThis.document.createElement('div');
        container.className = styles.regButtons;
        e.cell.replaceChildren(container);
        actionPortalsRef.current.set(key, container);
        setPortalTick(tick => tick + 1);
        return;
      }

      // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (FPDate* 메타 — 하드코딩 목록 금지)
      if (ctrlType.startsWith('FPDate') && !isEditing) {
        const text = toDisplayDate(rec[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }

      // ⭐ 편집 색 — 편집 게이트와 **같은 함수**(isCellEditableTab1) 사용 (#95 — 편집 Yellow /
      //   잠금 Gray). 공용 formatEditableColumns 보다 뒤에 걸려 본 판정이 최종
      toggleClass(e.cell, 'wj-cell-editable', editable);
      // TAB1의 수정 불가 셀은 별도 배경색 없이 기본 White를 유지한다.
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD × '수정' 행 단일 원천. 링크/버튼 셀은 편집기 자체 차단
    const beginningEditHandler = (
      s: FlexGridType<Tab1Row>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const row = s.rows[e.row]?.dataItem as Tab1Row | undefined;
      const meta = colMetaRef.current.get(binding);
      const ctrlType = (meta?.cellCtrlObjTpCd as unknown as string) ?? '';
      // FPModal/REG_ACTION 셀은 편집이 아니라 클릭 액션 (EditTracker 'M' 오염 방지)
      if (ctrlType === 'FPModal' || meta?.attribute1 === REG_ACTION_ATTR) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditableTab1(inputTpRef.current.get(binding), binding, row);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 클릭 라우팅 — FPModal(권한관리)/REG_ACTION(승인·반려 버튼) 메타 소비 (바인딩 하드코딩 금지)
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta) return;
      const row = g.rows[ht.row]?.dataItem as Tab1Row | undefined;
      if (!row) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType === 'FPModal' && meta.attribute1 === MODAL_ATTR.AUTH_REG) {
        onAuthRegCellClickRef.current?.(row);
        return;
      }
      if (meta.attribute1 === REG_ACTION_ATTR) {
        return;
      }
    };
    g.hostElement.addEventListener('click', clickHandler);

    // No. 코너 헤더 정렬 보강 (hook #108 — 공용 TopLeft 'No' 승계 + 가운데 정렬)
    const cornerHandler = (_s: FlexGridType<Tab1Row>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.TopLeft) return;
      e.cell.style.textAlign = 'center';
    };
    g.formatItem.addHandler(cornerHandler);

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.formatItem?.removeHandler(cornerHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // ⭐ 콜백/라벨은 effect 본문 미사용(포탈 JSX 소비) 또는 ref 미러 — 의존성에서 제외해
    //   페이지 리렌더마다 재등록 + invalidate(깜빡임)가 나지 않게 한다
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridControl, visibleColumns]);

  // ⭐ SDM 공통 — 상위 셀 변경 시 종속 콤보(ATTRIBUTE2) 첫 후보 자동 입력
  //   (CF-15 CELL_TYPE→STACK_METHOD: 공용 stale clear 가 비운 자리를 새 후보 첫 값으로 채움)
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected) return;
    return attachComboCascadeAutoFill({
      grid: g,
      getColumns: () => [...colMetaRef.current.values()],
      getEditTracker: () => editTrackerRef?.current,
    });
  }, [gridControl, editTrackerRef]);

  // ⭐ hook #93 — 헤더 총 48px (n단 = 48/n 자동 분배) + combo dataMap 재적용 (UC-05 Excel NAME 승계)
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, gridControl]);

  useEffect(() => {
    const validKeys = new Set(rows.map(row => String(row.DPJT_KEY ?? '')));
    let changed = false;
    actionPortalsRef.current.forEach((_, key) => {
      if (!validKeys.has(key)) {
        actionPortalsRef.current.delete(key);
        changed = true;
      }
    });
    if (changed) setPortalTick(tick => tick + 1);
  }, [rows]);

  return (
    <>
      <TagLayer ref={tagLayerRef} />
      <DataGrid
        key={visibleColumns.map(c => c.colNm).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef as never}
        excludeFromDirtyCheck={excludeFromDirtyCheck}
        initialized={handleGridInitialized}
        staticColumns={visibleColumns}
        comboParams={comboParams}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
      />
      {[...actionPortalsRef.current.entries()].flatMap(([key, container]) => {
        const row = rows.find(item => actionKey(item) === key);
        if (!row) return [];
        return [
          createPortal(
            <>
              {canConfirm && (
                <Button
                  appearance='contained'
                  priority='primary'
                  size='small'
                  buttonLabel={approveLabel}
                  onClick={() => onConfirmClick?.(row)}
                />
              )}
              {canCancel && (
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  buttonLabel={rejectLabel}
                  onClick={() => onCancelClick?.(row)}
                />
              )}
            </>,
            container,
            key
          ),
        ];
      })}
    </>
  );
};
