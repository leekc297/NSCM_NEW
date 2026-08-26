import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { safeString } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  AUTH_MGMT_LINK_LABEL,
  AUTH_REQ_LINK_LABEL,
  CELL_TYPE_BINDING,
  CELLTYPE_SCOPED_COMBO,
  colorTypeColumnOf,
  LINK_SEALED,
  MODAL_ATTR,
  REQ_ACTION_ATTR,
  REQ_CHECK,
  REQ_CHECK_BINDINGS,
  STACK_METHOD_BINDING,
  TAG_ATTR,
  TAG_SOURCE,
} from '../project-list.constants';
import type { MainRow, ReqCheckOrigin } from '../project-list.types';
import styles from '../ProjectList.module.scss';
import {
  canOpenAuthMgmt,
  canReqAuth,
  isCellEditable,
  isReqCheckToggleable,
} from '../utils/project-list.editLock';
import { toDisplayDate } from '../utils/project-list.validate';

// ⭐ SDM1020 'Project List' 단일 그리드 — 정적 30컬럼(계약 ④) admin 메타 100% 주도 (hook #113).
//   - 편집 게이트 = utils/project-list.editLock (INPUT_TP_CD × ADMIN 행 — P-01. EditTracker 가
//     편집 확정 시 CRUD_TYPE 'M' 마킹 → [등록요청] 대상 축, P-06/P-25).
//   - 셀 콤보 : CODE 컬럼 직결 dataMap(CODE→NAME 표시 — 콤보 셀 명칭 표시 의무). division 종속은
//     조회 Division 단일 축(따옴표 전달) — Division 변경 시 그리드가 비워지므로 dataMap 재구성으로 충분.
//     행 단위 종속은 CF-11 (CELL_TYPE→STACK_METHOD) 1건: beginningEdit 행값 dataMap 스왑 +
//     cellEditEnded 기본 dataMap 원복 + Cell Type 변경 시 Stack Method clear (hook #59 §5-G).
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

export const ProjectListGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  divisionId,
  staticColumns,
  reqCheckOriginsRef,
  onAuthMgmtClick,
  onAuthReqClick,
}: Props) => {
  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const staticBindingSet = useMemo(
    () => new Set(visibleColumns.map(c => c.colNm)),
    [visibleColumns]
  );

  // ===== Grid 콤보 — 메타(FPComboBox + cellCboDataTp) 기반. division 종속 콤보는 따옴표 전달
  //   (BE makeComboQuery raw 치환 — @divisionId 토큰 없는 콤보는 전달해도 무해).
  //   StackMethodByCellType 은 @cellType 토큰 필수 — 기본 map 은 빈 값(전체 반환 NVL 가드) =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const comboResults = useTabComboQueries({
    filters: comboColumns.map((c): ComboParam => {
      const param: ComboParam = { comboId: c.cellCboDataTp as string, divisionId: q(divisionId) };
      if ((c.cellCboDataTp as unknown as string) === CELLTYPE_SCOPED_COMBO) {
        // 빈값 NVL 가드 = 전체 반환 (계약 ⑤ 스모크 실측 — 'ALL' 센티널 아님)
        param.divisionId = `'${divisionId}'`;
        param.cellType = '\'\'';
      }
      return param;
    }),
  });
  // ⚠ division 을 시그니처에 포함 — 미포함 시 division 전환 후 행수가 우연히 같으면
  //   이전 division 의 dataMap 이 잔존한다 (DMF0042 실측 계보)
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}@${divisionId}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      // DpjtDevelopStatus lookup 원장 0행(계약 ⑤ 보고) = 빈 콤보 허용 — null 로 두고 원문 표시
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // ===== ⭐ CF-11 행 CELL_TYPE 종속 — StackMethodByCellType 을 CellType 코드별 선적재 후
  //   beginningEdit 에서 행 CELL_TYPE 의 dataMap 으로 스왑 (hook #59 §5-G) =====
  const cellTypeCodes = useMemo(() => {
    const i = comboColumns.findIndex(
      c => (c.cellCboDataTp as unknown as string) === 'CellTypeByDivision'
    );
    return i >= 0 ? (comboResults[i] ?? []).map(r => String(r.CODE)) : [];
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);
  const stackScopedFilters = useMemo(
    () =>
      cellTypeCodes.map(
        (ct): ComboParam => ({
          comboId: CELLTYPE_SCOPED_COMBO,
          divisionId: `'${divisionId}'`,
          cellType: `'${ct}'`,
        })
      ),
    [cellTypeCodes, divisionId]
  );
  const stackScopedResults = useTabComboQueries({ filters: stackScopedFilters });
  const stackScopedSig = stackScopedFilters
    .map((f, i) => `${f.cellType}#${stackScopedResults[i]?.length ?? 'x'}`)
    .join(',');
  const stackMapsRef = useRef<Record<string, DataMap>>({});
  useEffect(() => {
    const maps: Record<string, DataMap> = {};
    stackScopedFilters.forEach((f, i) => {
      const arr = (stackScopedResults[i] ?? []) as unknown as Record<string, string>[];
      const ct = String(f.cellType ?? '').replace(/'/g, '');
      if (arr.length > 0) maps[ct] = new DataMap(arr, 'CODE', 'NAME');
    });
    stackMapsRef.current = maps;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stackScopedSig]);
  // CELL_TYPE 편집 직전 값 (변경 여부 판정 — 동일 값 재선택 시 STACK_METHOD clear 방지)
  const preEditCellTypeRef = useRef<string>('');

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MainRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)

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

    // COLOR_TYPE 값 → pill 클래스 ('Gray/Amber/Green/Red' + 'warning-major'→tagWarningMajor 정규화)
    const pillClass = (colorType: string): string => {
      const key = `tag${colorType.replace(/(^|[-_])(\w)/g, (_m, _s: string, ch: string) => ch.toUpperCase())}`;
      return styles[key] ?? styles.tagGray;
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

      // ⭐ TAG 렌더 — 표시 = TAG_SOURCE NAME 컬럼(D2 보정 — 미등재 시 관례 `_NAME`/원값 폴백),
      //   색 = COLOR 컬럼 데이터 주도 (미지정/미지 값은 Gray 기본)
      if (meta.attribute1 === TAG_ATTR && !isEditing) {
        const src = TAG_SOURCE[binding];
        const text = safeString(
          (src ? rec[src.name] : undefined) ?? rec[`${binding}_NAME`] ?? rec[binding]
        );
        const colorType = safeString((src ? rec[src.color] : undefined) ?? rec[colorTypeColumnOf(binding)]);
        e.cell.textContent = '';
        if (text !== '') {
          const pill = document.createElement('span');
          pill.className = `${styles.tag} ${pillClass(colorType)}`;
          pill.textContent = text;
          e.cell.appendChild(pill);
        }
        return;
      }

      // ⭐ FPModal 셀 (권한관리 — P-02) : SP 값 '-'=봉인 텍스트 / 그 외(''·NULL)= '권한관리' 링크
      if ((meta.cellCtrlObjTpCd as unknown as string) === 'FPModal') {
        toggleClass(e.cell, 'wj-cell-popup', false);
        if (!canOpenAuthMgmt(rowItem)) {
          e.cell.textContent = LINK_SEALED;
          e.cell.style.cursor = '';
          return;
        }
        renderLink(e.cell, AUTH_MGMT_LINK_LABEL);
        return;
      }

      // ⭐ REQ_ACTION 셀 (권한요청 링크 — FE 파생, P-03) : 둘 다 DISABLED = '-' / 그 외 링크
      if (meta.attribute1 === REQ_ACTION_ATTR) {
        if (!canReqAuth(rowItem)) {
          e.cell.textContent = LINK_SEALED;
          e.cell.style.cursor = '';
          return;
        }
        renderLink(e.cell, AUTH_REQ_LINK_LABEL);
        return;
      }

      // ⭐ FPCheckBox 셀 (P-04/P-05) — 서버 3상태 문자열 렌더 (DISABLED=잠금·CHECKED=요청 진행 중)
      if ((meta.cellCtrlObjTpCd as unknown as string) === 'FPCheckBox') {
        const v = safeString(rec[binding]);
        e.cell.textContent = '';
        e.cell.style.textAlign = 'center';
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

      // ⭐ 편집 색 — 편집 게이트와 **같은 함수**(isCellEditable) 사용 (#95 — 편집 Yellow / 잠금 Gray).
      //   공용 formatEditableColumns 보다 뒤에 걸려 본 판정이 최종 (P-01 — 비관리자 행 = Gray)
      const inputTp = inputTpRef.current.get(binding);
      const editable = isCellEditable(inputTp, rowItem);
      toggleClass(e.cell, 'wj-cell-editable', editable);
      const editableType = inputTp === 'IM' || inputTp === 'IO' || inputTp === 'M' || inputTp === 'O';
      toggleClass(e.cell, 'wj-cell-non-editable', editableType && !editable);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD × ADMIN 행 단일 원천. 링크/체크박스 셀은 편집기 자체 차단
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
      if (ctrlType === 'FPModal' || ctrlType === 'FPCheckBox' || meta?.attribute1 === REQ_ACTION_ATTR) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(inputTpRef.current.get(binding), row);
      if (e.cancel) return;
      // ⭐ CF-11 — STACK_METHOD 는 행 CELL_TYPE 의 dataMap 으로 스왑 (hook #59 §5-G)
      if (binding === STACK_METHOD_BINDING) {
        const ct = String(row?.CELL_TYPE ?? '');
        const dm = stackMapsRef.current[ct];
        const col = s.columns[e.col];
        if (col && dm && col.dataMap !== dm) col.dataMap = dm;
      }
      if (binding === CELL_TYPE_BINDING) preEditCellTypeRef.current = String(row?.CELL_TYPE ?? '');
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — ① CELL_TYPE 변경 시 STACK_METHOD clear (CF-11 계단식) ② STACK_METHOD dataMap 원복
    const cellEditEndedHandler = (s: FlexGridType<MainRow>, e: { row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;
      if (binding === CELL_TYPE_BINDING && safeString(rec[binding]) !== preEditCellTypeRef.current) {
        rec[STACK_METHOD_BINDING] = '';
        s.invalidate();
      }
      if (binding === STACK_METHOD_BINDING) {
        // ⭐ 전체 dataMap 원복 (hook #59 §5-G — 누락 시 타 행이 마지막 편집 행의 cellType 맵으로 표시)
        const col = s.columns[e.col];
        const base = dataMaps[binding];
        if (col && base && col.dataMap !== base) col.dataMap = base;
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

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
        const v = safeString(rec[binding]);
        if (!isReqCheckToggleable(v)) return; // P-04 — DISABLED 잠금
        // 토글 최초 1회 서버 원본 기록 (P-12 취소 경로 판정 — 재조회 시 페이지가 clear)
        if (!reqCheckOriginsRef.current.has(row)) {
          reqCheckOriginsRef.current.set(row, {
            write: safeString(rec[REQ_CHECK_BINDINGS.WRITE]),
            read: safeString(rec[REQ_CHECK_BINDINGS.READ]),
          });
        }
        const next = v === REQ_CHECK.CHECKED ? REQ_CHECK.UNCHECKED : REQ_CHECK.CHECKED;
        rec[binding] = next;
        // ⭐ 상호배타 (P-05) — 하나 CHECKED 시 반대쪽 자동 UNCHECKED (DISABLED 는 애초에 토글 불가 축)
        if (next === REQ_CHECK.CHECKED) {
          const other =
            binding === REQ_CHECK_BINDINGS.WRITE ? REQ_CHECK_BINDINGS.READ : REQ_CHECK_BINDINGS.WRITE;
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
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dataMaps, onAuthMgmtClick, onAuthReqClick]);

  // ⭐ hook #93 — 헤더 총 48px (n단 = 48/n 자동 분배) + combo dataMap 재적용 (UC-05 Excel NAME 승계)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<MainRow> | null } | null)?.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
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
  }, [visibleColumns, dataMaps, gridRef]);

  return (
    <DataGrid
      key={visibleColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      staticColumns={visibleColumns}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowSorting={true}
      useCheckbox={true}
    />
  );
};
