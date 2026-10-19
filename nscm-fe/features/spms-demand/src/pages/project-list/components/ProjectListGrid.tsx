import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType, Column } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  memo,
  type MutableRefObject,
  type Ref,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { useTranslation } from 'react-i18next';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';

import { colorTypeColumnOf, TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { attachComboCascadeAutoFill } from '../../../lib/comboCascadeAutoFill';
import {
  DataGrid,
  keepDivisionCodeDisplay,
  keepServerComboOrder,
  restoreMultiRangeSelection,
} from '../../../lib/grid';
import {
  LINK_SEALED,
  MODAL_ATTR,
  REQ_ACTION_ATTR,
  REQ_CHECK,
  REQ_CHECK_BINDINGS,
  TAG_ATTR,
  TAG_SOURCE,
} from '../project-list.constants';
import type { MainRow, ReqCheckOrigin } from '../project-list.types';
import {
  canOpenAuthMgmt,
  canReqAuth,
  isCellEditable,
  isReqCheckToggleable,
} from '../utils/project-list.editLock';
import { toDisplayDate } from '../utils/project-list.validate';
import { toText } from '../utils/project-list.value';

import styles from './ProjectListGrid.module.scss';

const quoteCombo = (value?: string): string => `'${value && value.trim() !== '' ? value : 'ALL'}'`;

// ⭐ SDM1020 'Project List' 단일 그리드 — 정적 30컬럼(계약 ④) admin 메타 100% 주도 (hook #113).
//   - 편집 게이트 = utils/project-list.editLock (INPUT_TP_CD × MOD_ROW_YN='Y' 행 — P-01. EditTracker 가
//     편집 확정 시 CRUD_TYPE 'M' 마킹 → [등록요청] 대상 축, P-06/P-25).
//   - 셀 콤보 : 공용 DataGrid 가 admin 메타(FPComboBox + CELL_COMBO_DATA_TYPE + ATTRIBUTE2)로
//     전부 처리한다 — 후보 좁힘·상위 변경 시 stale clear·첫 후보 autofill 모두 Column param2
//     (ATTRIBUTE2) 단일 원천 (2026-08-28 협의: 모든 SPMS 화면 cascade 는 admin 메타 주도,
//     FE 하드코딩 금지). @divisionId 토큰 콤보는 comboParams 로 해소.
//   - TAG 셀 (메타 ATTRIBUTE1='TAG') : 표시 = TAG_SOURCE NAME 컬럼(D2 커서명 보정) / 색 = COLOR 컬럼.
//   - FPModal 셀 (DPJT_AUTH_MGMT/ATTRIBUTE1='ProjectAuthRegModal') : SP 값 '-'=봉인 / 그 외('' NULL)
//     = '권한관리' 링크 → 권한관리 모달 (P-02 — SP 산출값 단일 원천).
//   - REQ_ACTION 셀 (DPJT_AUTH_REQ_LINK — FE 파생·커서 미반환) : 체크박스 둘 다 DISABLED = '-' /
//     그 외 = '권한요청' 링크 → 권한요청 핸들러 (P-03).
//   - FPCheckBox 셀 (DPJT_AUTH_REQ_WRITE/_READ) : 서버 3상태 문자열 렌더 (P-04 — DISABLED 잠금) +
//     클릭 토글 + 상호배타 (P-05). 편집기 경유 금지(beginningEdit cancel) — EditTracker 'M' 오염 방지.
//     토글 최초 1회 서버 원본을 reqCheckOriginsRef 에 기록 (P-12 취소 경로 판정).
//   - DATE 원형 커서 컬럼(SOP_DATE/REG_COMP_DATE — FPDateText 메타) : 'YYYY.MM.DD' 표시.
//   - 체크박스 선택(useCheckbox) = 등록요청 대상 수집(row.isSelected).

interface Props {
  rows: MainRow[];
  gridRef: Ref<FlexGridType<MainRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  divisionId: string;
  staticColumns?: RawFlexGridColumnConfig[];
  // 권한요청 체크박스 서버 원본 (페이지 소유 — 재조회 시 clear. P-12 취소 경로 판정 원천)
  reqCheckOriginsRef: MutableRefObject<Map<MainRow, ReqCheckOrigin>>;
  onAuthMgmtClick?: (row: MainRow) => void;
  onAuthReqClick?: (row: MainRow) => void;
}

export const ProjectListGrid = memo(function ProjectListGrid({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  divisionId,
  staticColumns,
  reqCheckOriginsRef,
  onAuthMgmtClick,
  onAuthReqClick,
}: Props) {
  const { t } = useTranslation();
  const tagLayerRef = useRef<TagLayerHandle>(null);

  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const staticBindingSet = useMemo(
    () => new Set(visibleColumns.map(c => c.colNm)),
    [visibleColumns]
  );

  // ⭐ wijmo react 는 initialized 를 setTimeout 으로 비동기 호출한다 — 컬럼 메타 도착으로 key 가
  //   바뀌어 그리드가 재생성된 렌더에서는 gridRef.current 가 아직 비어 있어, ref 만 보는 effect 는
  //   조용히 skip 된다(콤보 결과가 캐시에 있으면 재실행 계기도 없어 cascade 가 영영 안 걸리던
  //   원인). ProjectMasterTab1Grid 와 동일하게 state 로 받아 등록 effect 를 그 뒤에 다시 태운다.
  // ⭐ 메타 ref 미러 — initialized 1회 등록 핸들러(keepServerComboOrder)도 최신 ATTRIBUTE2 를 본다
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));

  const [gridControl, setGridControl] = useState<FlexGridType<MainRow> | null>(null);
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    restoreMultiRangeSelection(grid);
    // 행 필터(ATTRIBUTE2) 콤보는 그 행으로 좁힌 서버 순서로 복원 (사업부 중복 NAME 섞임 방지)
    keepServerComboOrder(grid, binding => colMetaRef.current.get(binding)?.attribute2);
    keepDivisionCodeDisplay(grid);
    setGridControl(grid as FlexGridType<MainRow>);
  }, []);

  // ===== Grid 콤보 — 공용 DataGrid 가 admin 메타로 생성 (Column param2 = ATTRIBUTE2 계약).
  //   @divisionId 토큰 콤보 해소용 comboParams 만 전달한다 (BE makeComboQuery raw 치환
  //   — 토큰 없는 콤보는 여분 파라미터 무시. CELL_TYPE 좁힘은 ATTRIBUTE2 행 필터 담당) =====
  const comboParams = useMemo(() => ({ divisionId: quoteCombo(divisionId) }), [divisionId]);

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );

  const formatRowHeader = useCallback(
    (grid: FlexGridType<MainRow>, event: FormatItemEventArgs) => {
      if (event.panel.cellType === CellType.RowHeader && event.col === 1) {
        delete event.cell.dataset.status;
        event.cell.textContent = String(event.row + 1);
      } else if (event.panel.cellType === CellType.RowHeader && event.col === 2) {
        delete event.cell.dataset.status;
        event.cell.textContent = '';
        const row = grid.rows[event.row]?.dataItem as MainRow | undefined;
        if (row?.CRUD_TYPE) event.cell.dataset.status = String(row.CRUD_TYPE);
      } else if (event.panel.cellType === CellType.TopLeft && event.col === 1) {
        event.cell.textContent = t('LBL00674', '_No');
        event.cell.style.textAlign = 'center';
      }
    },
    [t]
  );

  const handleLoadedRows = useCallback(
    (grid: FlexGridType<MainRow>) => {
      // loadedRows가 DataGrid initialized 완료 전에 올 수 있어 Selector/상태 컬럼 생성 뒤로 미룬다.
      globalThis.queueMicrotask(() => {
        if (!grid.hostElement.isConnected || grid.rowHeaders.columns.length < 2) return;
        if (grid.rowHeaders.columns.length === 2) {
          grid.rowHeaders.columns.insert(1, new Column({ align: 'center', width: 40 }));
        }
        grid.rowHeaders.columns[1].width = 40;
        grid.rowHeaders.columns[2].width = 24;
        grid.formatItem.removeHandler(formatRowHeader);
        grid.formatItem.addHandler(formatRowHeader);
        grid.invalidate(true);
      });
    },
    [formatRowHeader]
  );

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const renderLink = (cell: HTMLElement, label: string) => {
      cell.textContent = '';
      cell.style.cursor = 'pointer';
      const link = document.createElement('span');
      link.className = styles.linkCell;
      link.textContent = label;
      cell.appendChild(link);
    };

    const formatHandler = (_s: FlexGridType<MainRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const rowItem = g.rows[e.row]?.dataItem as MainRow | undefined;
      const meta = colMetaRef.current.get(binding);
      if (!rowItem || !meta) return;
      const rec = rowItem as Record<string, unknown>;

      // ⚠ 편집 중 셀은 건드리지 않는다 — 삽입된 편집기 <input> 이 지워지는 사고 방어 (DMF0044 계보)
      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;
      const isTagColumn = meta.attribute1 === TAG_ATTR;
      const isCheckboxColumn = (meta.cellCtrlObjTpCd as unknown as string) === 'FPCheckBox';

      // 조회/잠금 셀은 기본 White를 유지한다. 편집 가능 셀의 Yellow만 별도로 표시한다.
      toggleClass(e.cell, 'wj-cell-non-editable', false);
      toggleClass(e.cell, styles.reqCheckboxCell, isCheckboxColumn);

      // Wijmo가 셀 DOM을 재사용하므로 TAG가 아닌 셀 또는 편집 중인 셀에는 이전 Portal을 제거한다.
      if (!isTagColumn || isEditing) tagLayerRef.current?.clear(e.cell);

      // SDM1010 Project Registration과 동일한 LGES Tag Portal 렌더링.
      if (isTagColumn && !isEditing) {
        const src = TAG_SOURCE[binding];
        const text = toText(
          (src ? rec[src.name] : undefined) ?? rec[`${binding}_NAME`] ?? rec[binding] ?? ''
        );
        const colorType =
          (src ? rec[src.color] : undefined) ?? rec[colorTypeColumnOf(binding)] ?? '';
        if (text) tagLayerRef.current?.apply(e.cell, text, colorType);
        else tagLayerRef.current?.clear(e.cell);
        return;
      }

      // ⭐ FPModal 셀 (권한관리 — P-02) : SP 값 '-'=봉인 텍스트 / 그 외(''·NULL)= '권한관리' 링크
      if ((meta.cellCtrlObjTpCd as unknown as string) === 'FPModal') {
        if (!canOpenAuthMgmt(rowItem)) {
          toggleClass(e.cell, 'wj-cell-popup', false);
          e.cell.textContent = LINK_SEALED;
          e.cell.style.cursor = '';
          return;
        }
        renderLink(e.cell, t('LBL00875', '_Authority Registration'));
        return;
      }

      // ⭐ REQ_ACTION 셀 (권한요청 링크 — FE 파생, P-03) : 둘 다 DISABLED = '-' / 그 외 링크
      if (meta.attribute1 === REQ_ACTION_ATTR) {
        if (!canReqAuth(rowItem)) {
          e.cell.textContent = LINK_SEALED;
          e.cell.style.cursor = '';
          return;
        }
        renderLink(e.cell, t('LBL01002', '_Authority Request'));
        return;
      }

      // ⭐ FPCheckBox 셀 (P-04/P-05) — 서버 3상태 문자열 렌더 (DISABLED=잠금·CHECKED=요청 진행 중)
      if (isCheckboxColumn) {
        const v = toText(rec[binding]);
        e.cell.textContent = '';
        const cb = document.createElement('input');
        cb.type = 'checkbox';
        cb.className = styles.reqCheckbox;
        cb.checked = v === REQ_CHECK.CHECKED;
        cb.disabled = !isReqCheckToggleable(v);
        cb.tabIndex = -1;
        e.cell.appendChild(cb);
        return;
      }

      // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (FPDate* 메타 — 하드코딩 목록 금지)
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType.startsWith('FPDate') && !isEditing) {
        const text = toDisplayDate(rec[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }

      // 편집 가능한 행의 셀만 Yellow, 나머지는 White.
      const inputTp = inputTpRef.current.get(binding);
      const editable = isCellEditable(inputTp, rowItem);
      toggleClass(e.cell, 'wj-cell-editable', editable);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD × MOD_ROW_YN 단일 원천. 링크/체크박스 셀은 편집기 자체 차단
    const beginningEditHandler = (
      s: FlexGridType<MainRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      const meta = colMetaRef.current.get(binding);
      const ctrlType = (meta?.cellCtrlObjTpCd as unknown as string) ?? '';
      // FPModal/FPCheckBox/REQ_ACTION 셀은 편집이 아니라 클릭 액션 (체크 토글이 편집기·EditTracker 를
      //   타면 CRUD_TYPE 'M' 오염 → 등록요청 대상 오판 — P-06 축 보호)
      if (
        ctrlType === 'FPModal' ||
        ctrlType === 'FPCheckBox' ||
        meta?.attribute1 === REQ_ACTION_ATTR
      ) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(inputTpRef.current.get(binding), row);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // (CF-11 계단식 clear 는 화면 코드가 아니라 공용 DataGrid 의 stale clear 가 담당한다 —
    //   admin ATTRIBUTE2(Column param2) 기준 findStaleComboCells. 비운 자리는
    //   attachComboCascadeAutoFill 이 microtask 에서 첫 후보로 채운다.)

    // 클릭 라우팅 — FPModal(권한관리)/REQ_ACTION(권한요청)/FPCheckBox(토글) 메타 소비 (바인딩 하드코딩 금지)
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta) return;
      const row = g.rows[ht.row]?.dataItem as MainRow | undefined;
      if (!row) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType === 'FPModal' && meta.attribute1 === MODAL_ATTR.AUTH_REG) {
        if (canOpenAuthMgmt(row)) onAuthMgmtClick?.(row); // P-02 — 봉인('-') 행 무시
        return;
      }
      if (meta.attribute1 === REQ_ACTION_ATTR) {
        if (canReqAuth(row)) onAuthReqClick?.(row); // P-03 — 봉인('-') 행 무시
        return;
      }
      if (ctrlType === 'FPCheckBox') {
        const rec = row as Record<string, unknown>;
        const v = toText(rec[binding]);
        if (!isReqCheckToggleable(v)) return; // P-04 — DISABLED 잠금
        // 토글 최초 1회 서버 원본 기록 (P-12 취소 경로 판정 — 재조회 시 페이지가 clear)
        if (!reqCheckOriginsRef.current.has(row)) {
          reqCheckOriginsRef.current.set(row, {
            write: toText(rec[REQ_CHECK_BINDINGS.WRITE]),
            read: toText(rec[REQ_CHECK_BINDINGS.READ]),
          });
        }
        const next = v === REQ_CHECK.CHECKED ? REQ_CHECK.UNCHECKED : REQ_CHECK.CHECKED;
        rec[binding] = next;
        // ⭐ 상호배타 (P-05) — 하나 CHECKED 시 반대쪽 자동 UNCHECKED (DISABLED 는 애초에 토글 불가 축)
        if (next === REQ_CHECK.CHECKED) {
          const other =
            binding === REQ_CHECK_BINDINGS.WRITE
              ? REQ_CHECK_BINDINGS.READ
              : REQ_CHECK_BINDINGS.WRITE;
          if (isReqCheckToggleable(rec[other])) rec[other] = REQ_CHECK.UNCHECKED;
        }
        g.invalidate();
      }
    };
    g.hostElement.addEventListener('click', clickHandler);

    // No. 코너 헤더 정렬 보강 (hook #108 — 공용 TopLeft 'No' 승계 + 가운데 정렬)
    const cornerHandler = (_s: FlexGridType<MainRow>, e: FormatItemEventArgs) => {
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridControl, visibleColumns, onAuthMgmtClick, onAuthReqClick, t]);

  // ⭐ SDM 공통 — 상위 셀 변경 시 종속 콤보 첫 후보 자동 입력 (CF-11: Division→Cell 유형→Stack Method).
  //   공용 stale clear 가 하위를 비운 뒤(헬퍼는 microtask 로 늦게 돈다) 새 후보의 첫 값을 채운다.
  //   종속 선언·후보 전부 admin 메타(Column param2 = ATTRIBUTE2) 단일 원천 — FE 보강 없음.
  useEffect(() => {
    if (!gridControl) return;
    return attachComboCascadeAutoFill({
      grid: gridControl,
      getColumns: () => [...colMetaRef.current.values()],
      getEditTracker: () => editTrackerRef?.current,
    });
  }, [gridControl, visibleColumns, editTrackerRef]);

  // ⭐ hook #93 — 헤더 총 48px (n단 = 48/n 자동 분배)
  useEffect(() => {
    const g = gridControl;
    if (!g) return;
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
  }, [gridControl]);

  return (
    <>
      <TagLayer ref={tagLayerRef} />
      <DataGrid
        key={visibleColumns.map(c => c.colNm).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef as never}
        staticColumns={staticColumns ?? []}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        useCheckbox={true}
        comboParams={comboParams}
        initialized={handleGridInitialized}
        loadedRows={handleLoadedRows}
      />
    </>
  );
});
