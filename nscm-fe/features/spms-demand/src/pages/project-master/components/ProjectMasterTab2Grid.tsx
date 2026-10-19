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

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';

import { colorTypeColumnOf, TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { DataGrid, keepDivisionCodeDisplay } from '../../../lib/grid';
import {
  DISABLE_CHECK,
  DISABLE_YN_BINDING,
  MODAL_ATTR,
  TAG_ATTR,
  TAG_SOURCE,
} from '../project-master.constants';
import type { Tab2Row } from '../project-master.types';
import styles from '../ProjectMaster.module.scss';
import {
  isCellEditableTab2,
  isDisableToggleable,
  isEditableInputTp,
} from '../utils/project-master.editLock';
import { toDisplayDate } from '../utils/project-master.validate';
import { toText } from '../utils/project-master.value';

// ⭐ SDM5010 TAB2 '프로젝트 Master 관리' 그리드 — 정적 24컬럼(계약 ④) admin 메타 100% 주도 (hook #113).
//   - 편집 = 개발현황(DPJT_DEVELOP_STATUS — FPComboBox `DpjtDevelopStatus`) + 비활성(DISABLE_YN —
//     FPCheckBox) **2컬럼만** (P-12 — 계약 ④ IO 재지정 축. 나머지 전 컬럼 'S' 잠금).
//   - 개발현황 콤보 편집 확정 = EditTracker 가 CRUD_TYPE 'M' 마킹 → [저장] 대상 축 (E19/E20).
//   - DISABLE_YN 체크 (계약 ⑥) : 서버 문자열 CHECKED/UNCHECKED 렌더 + 클릭 토글 + CRUD_TYPE 'M'
//     수동 마킹 (편집기 경유 금지 — beginningEdit cancel. 값은 서버 문자열 그대로 왕복).
//   - TAG/FPModal(권한관리 링크)/DATE 표시 = TAB1 동일 규약 (E08/E24).

interface Props {
  rows: Tab2Row[];
  gridRef: Ref<FlexGridType<Tab2Row>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  excludeFromDirtyCheck?: boolean;
  divisionId: string;
  staticColumns?: RawFlexGridColumnConfig[];
  onAuthRegCellClick?: (row: Tab2Row) => void;
}

export const ProjectMasterTab2Grid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  excludeFromDirtyCheck,
  divisionId,
  staticColumns,
  onAuthRegCellClick,
}: Props) => {
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

  // ===== Grid 콤보 — 메타(FPComboBox + cellCboDataTp) 기반, 공용 DataGrid 파이프라인 단일 원천
  //   (TAB1 동일 — comboParams 만 전달. DpjtDevelopStatus 는 독립 lookup CF-19,
  //   @divisionId 토큰 없는 콤보는 전달해도 무해).
  //   ⚠ 화면 자체 useTabComboQueries + updatedLayout dataMap 재대입(구 hook #93 방식)은 금지 —
  //   공용 파이프라인이 대입하는 dataMap 과 서로 덮어쓰며 invalidate 를 반복해 상태(TAG) 컬럼이
  //   pill ↔ raw 로 계속 깜빡였다 (2026-09-02 실증 — TAB2 에서만 재현되던 원인).
  const comboParams = useMemo(() => ({ divisionId: `'${divisionId || 'ALL'}'` }), [divisionId]);

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));

  // ⭐ 페이지 콜백 ref 미러 — effect 의존성에서 빼 클릭→페이지 리렌더마다 핸들러 재등록 +
  //   invalidate(true) 전체 재그리기(깜빡임)가 나는 것을 막는다 (datagrid-rerender-flicker)
  const onAuthRegCellClickRef = useRef(onAuthRegCellClick);
  onAuthRegCellClickRef.current = onAuthRegCellClick;

  // ⭐ TAB1 동일 처방(#83-88) — gridRef.current 직접 참조 effect 는 재실행 타이밍에 그리드가
  //   미준비면 조용히 bail 해, cleanup 으로 지운 핸들러(formatItem TAG/편집색 포함)가 재등록되지
  //   않은 채 남는다(상태 pill ↔ raw 텍스트가 번갈아 보이던 원인). initialized 를 state 로 받아
  //   등록 effect 를 그 뒤에 다시 태운다.
  const [gridControl, setGridControl] = useState<FlexGridType<Tab2Row> | null>(null);
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    keepDivisionCodeDisplay(grid); // 인스턴스당 1회 (WeakSet) — 여기서 등록
    setGridControl(grid as FlexGridType<Tab2Row>);
  }, []);

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const formatHandler = (_s: FlexGridType<Tab2Row>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const rowItem = g.rows[e.row]?.dataItem as Tab2Row | undefined;
      const meta = colMetaRef.current.get(binding);
      if (!rowItem || !meta) return;
      const rec = rowItem as Record<string, unknown>;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';

      // ⚠ 편집 중 셀은 건드리지 않는다 — 삽입된 편집기 <input> 이 지워지는 사고 방어 (DMF0044 계보)
      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;
      const isTagColumn = meta.attribute1 === TAG_ATTR;

      if (!isTagColumn || isEditing) {
        tagLayerRef.current?.clear(e.cell);
      }
      toggleClass(e.cell, styles.authRegistrationLink, ctrlType === 'FPModal');
      toggleClass(e.cell, styles.disableCheckboxCell, ctrlType === 'FPCheckBox');

      // ⭐ TAG 렌더 — 표시 = TAG_SOURCE NAME 컬럼 / 색 = COLOR_TYPE 컬럼 데이터 주도 (TAB1 동일 규약)
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

      // ⭐ FPCheckBox 셀 (DISABLE_YN — 계약 ⑥) : 서버 문자열 CHECKED/UNCHECKED 렌더 + 편집색
      if (ctrlType === 'FPCheckBox') {
        const v = toText(rec[binding]);
        e.cell.textContent = '';
        e.cell.style.textAlign = 'center';
        const cb = document.createElement('input');
        cb.type = 'checkbox';
        cb.className = styles.disableCheckbox;
        cb.checked = v === DISABLE_CHECK.CHECKED;
        cb.disabled = !isDisableToggleable(v);
        cb.tabIndex = -1;
        e.cell.appendChild(cb);
        toggleClass(e.cell, 'wj-cell-editable', isDisableToggleable(v)); // 편집 2컬럼 Yellow (#95)
        return;
      }

      // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (FPDate* 메타 — 하드코딩 목록 금지)
      if (ctrlType.startsWith('FPDate') && !isEditing) {
        const text = toDisplayDate(rec[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }

      // ⭐ 편집 색 — 편집 게이트와 **같은 함수**(isCellEditableTab2) 사용 (#95 — P-12 2컬럼 Yellow)
      const inputTp = inputTpRef.current.get(binding);
      const editable = isCellEditableTab2(inputTp);
      toggleClass(e.cell, 'wj-cell-editable', editable);
      toggleClass(e.cell, 'wj-cell-non-editable', isEditableInputTp(inputTp) && !editable);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD 단일 원천 (P-12). 링크/체크박스 셀은 편집기 자체 차단
    const beginningEditHandler = (
      s: FlexGridType<Tab2Row>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const meta = colMetaRef.current.get(binding);
      const ctrlType = (meta?.cellCtrlObjTpCd as unknown as string) ?? '';
      // FPModal/FPCheckBox 셀은 편집이 아니라 클릭 액션 (체크 토글이 편집기·EditTracker 를 타면
      //   문자열 계약(CHECKED/UNCHECKED)이 boolean 으로 오염 — 계약 ⑥ 보호)
      if (ctrlType === 'FPModal' || ctrlType === 'FPCheckBox') {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditableTab2(inputTpRef.current.get(binding));
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 클릭 라우팅 — FPModal(권한관리)/FPCheckBox(비활성 토글) 메타 소비 (바인딩 하드코딩 금지)
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta) return;
      const row = g.rows[ht.row]?.dataItem as Tab2Row | undefined;
      if (!row) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType === 'FPModal' && meta.attribute1 === MODAL_ATTR.AUTH_REG) {
        onAuthRegCellClickRef.current?.(row);
        return;
      }
      if (ctrlType === 'FPCheckBox' && binding === DISABLE_YN_BINDING) {
        const rec = row as Record<string, unknown>;
        const v = toText(rec[binding]);
        if (!isDisableToggleable(v)) return; // 계약 ⑥ — CHECKED/UNCHECKED 외 잠금
        const nextValue =
          v === DISABLE_CHECK.CHECKED ? DISABLE_CHECK.UNCHECKED : DISABLE_CHECK.CHECKED;
        editTrackerRef?.current?.storeChange(row, binding, v, nextValue);
        rec[binding] = nextValue;
        g.invalidate();
      }
    };
    g.hostElement.addEventListener('click', clickHandler);

    // No. 코너 헤더 정렬 보강 (hook #108 — 공용 TopLeft 'No' 승계 + 가운데 정렬)
    const cornerHandler = (_s: FlexGridType<Tab2Row>, e: FormatItemEventArgs) => {
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
    // ⭐ 콜백은 ref 미러 — 의존성에서 제외해 페이지 리렌더마다 재등록 + invalidate(깜빡임) 방지
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridControl, visibleColumns]);

  // ⭐ hook #93 — 헤더 총 48px (n단 = 48/n 자동 분배. dataMap 재적용은 폐기 — 공용 파이프라인
  //   단일 원천, 위 콤보 주석 참조)
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
    </>
  );
};
