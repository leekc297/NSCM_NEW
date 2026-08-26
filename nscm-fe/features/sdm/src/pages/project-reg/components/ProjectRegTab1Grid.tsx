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
  CODE_PAIR,
  colorTypeColumnOf,
  DIVISION_SCOPED_COMBOS,
  MODAL_ATTR,
  TAG_ATTR,
} from '../project-reg.constants';
import type { Tab1Row } from '../project-reg.types';
import styles from '../ProjectReg.module.scss';
import { isCellEditable, isRowEditable } from '../utils/project-reg.editLock';
import { toDisplayDate } from '../utils/project-reg.validate';

// ⭐ SDM1010 TAB1 '프로젝트 등록' 그리드 — 정적 35컬럼(§1 신본 커서) admin 메타 100% 주도 (hook #113).
//   - 편집 게이트 = utils/project-reg.editLock (INPUT_TP_CD × 행 상태 — 신규 'C'/DRAFT·WRITING 만).
//   - CODE/NAME 페어 : NAME 컬럼(FPComboBox 메타) dataMap 편집 → cellEditEnded 에서 CODE 동기 기입.
//   - DPJT_ATUH_REG_STR(FPModal/ATTRIBUTE1='ProjectAuthRegModal' — 오타 alias 가 패키지 정본 §18-10)
//     클릭 → 권한관리 모달 (신규행 = P-31).
//   - TAG 셀 (메타 ATTRIBUTE1='TAG') : 색 = 커서 `*_COLOR_TYPE` 컬럼 소비 (데이터 주도 — 계약 결정 7).
//   - DATE 원형 커서 컬럼(SOP_DATE/REG_REQ_DATE — FPDate* 메타) : 'YYYY.MM.DD' 표시 (계약 결정 8).
//   - 체크박스 선택(useCheckbox) = 등록요청/요청취소 대상 수집(row.isSelected).

interface Props {
  rows: Tab1Row[];
  gridRef: Ref<FlexGridType<Tab1Row>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  divisionId: string;
  staticColumns?: RawFlexGridColumnConfig[];
  // 신규(CRUD_TYPE 'C') 행 식별 — EditTracker 가 편집 시 'C'→'M' 으로 뒤집는 것을 원복하기 위한 참조
  insertedRows: Tab1Row[];
  onAuthRegCellClick?: (row: Tab1Row) => void;
}

export const ProjectRegTab1Grid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  divisionId,
  staticColumns,
  insertedRows,
  onAuthRegCellClick,
}: Props) => {
  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const staticBindingSet = useMemo(() => new Set(visibleColumns.map(c => c.colNm)), [visibleColumns]);

  // ===== Grid 콤보 — 메타(FPComboBox + cellCboDataTp) 기반. division 종속 콤보는 따옴표 전달
  //   (BE makeComboQuery raw 치환 — @divisionId 토큰 없는 콤보는 전달해도 무해) =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(
      (c): ComboParam => ({ comboId: c.cellCboDataTp as string, divisionId: q(divisionId) })
    ),
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
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);
  const comboRowsRef = useRef<Record<string, Record<string, string>[]>>({});
  useEffect(() => {
    const byBinding: Record<string, Record<string, string>[]> = {};
    comboColumns.forEach((c, i) => {
      byBinding[c.colNm] = (comboResults[i] ?? []) as unknown as Record<string, string>[];
    });
    comboRowsRef.current = byBinding;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // ===== ⭐ Division 행별 필수입력(2026-08-13) — division 종속 콤보의 행별 dataMap =====
  //   신규행에서 사용자가 행마다 다른 division 을 고를 수 있으므로, ByDivision 계열 콤보는
  //   MyDivision 전 값에 대해 선적재하고 beginningEdit 에서 행 division 의 dataMap 으로 스왑
  //   (hook #59 §5-G — 스왑 미적용 시 타 division 옵션이 노출되는 오염).
  const divisionCodes = useMemo(() => {
    const i = comboColumns.findIndex(c => (c.cellCboDataTp as unknown as string) === 'MyDivision');
    return i >= 0 ? (comboResults[i] ?? []).map(r => String(r.CODE)) : [];
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);
  const scopedCols = useMemo(
    () =>
      comboColumns.filter(c =>
        (DIVISION_SCOPED_COMBOS as readonly string[]).includes(c.cellCboDataTp as unknown as string)
      ),
    [comboColumns]
  );
  const scopedFilters = useMemo(
    () =>
      divisionCodes.flatMap(dv =>
        scopedCols.map(
          (c): ComboParam => ({ comboId: c.cellCboDataTp as string, divisionId: `'${dv}'` })
        )
      ),
    [divisionCodes, scopedCols]
  );
  const scopedResults = useTabComboQueries({ filters: scopedFilters });
  const scopedSig = scopedFilters
    .map((f, i) => `${f.comboId}@${f.divisionId}#${scopedResults[i]?.length ?? 'x'}`)
    .join(',');
  // key = `${colNm}|${divisionCode}` — dataMap(에디터 스왑) + rows(CODE 동기 기입)
  const scopedMapsRef = useRef<Record<string, DataMap>>({});
  const scopedRowsRef = useRef<Record<string, Record<string, string>[]>>({});
  useEffect(() => {
    const maps: Record<string, DataMap> = {};
    const rows: Record<string, Record<string, string>[]> = {};
    scopedFilters.forEach((f, i) => {
      const raw = (scopedResults[i] ?? []) as unknown as Record<string, string>[];
      const dv = String(f.divisionId ?? '').replace(/'/g, '');
      // ⭐ 콤보 payload 에 DIVISION_ID 컬럼이 있으면 행 division 으로 클라이언트 필터 + CODE dedupe
      //   (실측 2026-08-13: 'EndCustomer' SQL 은 @divisionId 토큰이 없고 @sesUserId 권한 division
      //   **전체**를 반환 — 미필터 시 타 division 고객(40=PROJECT_CODE 도메인)이 노출되고,
      //   §1 EDC INNER JOIN(DIVISION_ID+END_CUSTOMER) 불일치 저장 행이 조회에서 소실된다.
      //   DEPT_ID 축으로 동일 CODE 가 중복 반환되므로 CODE 단위 dedupe)
      const divisionScoped =
        raw.length > 0 && 'DIVISION_ID' in raw[0]
          ? raw.filter(r => String(r.DIVISION_ID) === dv)
          : raw;
      const seen = new Set<string>();
      const arr = divisionScoped.filter(r => {
        const codeVal = String(r.CODE ?? '');
        if (codeVal === '' || seen.has(codeVal)) return false;
        seen.add(codeVal);
        return true;
      });
      scopedCols
        .filter(c => (c.cellCboDataTp as unknown as string) === f.comboId)
        .forEach(c => {
          const key = `${c.colNm}|${dv}`;
          rows[key] = arr;
          if (arr.length > 0) maps[key] = new DataMap(arr, 'CODE', 'NAME');
        });
    });
    scopedMapsRef.current = maps;
    scopedRowsRef.current = rows;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [scopedSig]);
  // division 변경 시 clear 할 종속 필드 (콤보 메타 + CODE 페어 — 메타 주도)
  const scopedFieldsRef = useRef<string[]>([]);
  scopedFieldsRef.current = scopedCols.flatMap(c => [c.colNm, CODE_PAIR[c.colNm]]).filter(Boolean);
  // DIVISION_NAME 편집 직전 값 (변경 여부 판정 — 동일 값 재선택 시 종속 clear 방지)
  const preEditDivisionRef = useRef<string>('');

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined]));
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));
  // 신규행 식별 Set (EditTracker 'C'→'M' 원복용)
  const insertedSetRef = useRef<Set<Tab1Row>>(new Set());
  insertedSetRef.current = new Set(insertedRows);

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<Tab1Row> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)

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

      // ⚠ 편집 중 셀은 건드리지 않는다 — 삽입된 편집기 <input> 이 지워지는 사고 방어 (DMF0044 계보)
      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;

      // ⭐ TAG 렌더 — 메타 ATTRIBUTE1='TAG' 소비. 색 = 커서 `*_COLOR_TYPE` 컬럼(Gray/Amber/Green/Red)
      //   데이터 주도 (계약 결정 7 — FE 하드코딩 매핑 제거. 미지정/미지 값은 Gray 기본 표시)
      if (meta.attribute1 === TAG_ATTR && !isEditing) {
        const text = String(rowItem[binding] ?? '');
        const colorType = String(rowItem[colorTypeColumnOf(binding)] ?? '');
        e.cell.textContent = '';
        if (text !== '') {
          const pill = document.createElement('span');
          pill.className = `${styles.tag} ${styles[`tag${colorType}`] ?? styles.tagGray}`;
          pill.textContent = text;
          e.cell.appendChild(pill);
        }
        return;
      }

      // ⭐ FPModal 셀 — 전용 span 팝업 아이콘 (DMF0020/DMF0003 표준. wj-cell-popup 자동 토글 무력화)
      if ((meta.cellCtrlObjTpCd as unknown as string) === 'FPModal') {
        toggleClass(e.cell, 'wj-cell-popup', false);
        e.cell.style.cursor = 'pointer';
        e.cell.style.paddingRight = '20px';
        if (!e.cell.querySelector('.popup-icon')) {
          const icon = document.createElement('span');
          icon.className = `popup-icon ${styles.popupIcon}`;
          e.cell.appendChild(icon);
        }
        return;
      }

      // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (계약 결정 8 — formatItem 경로.
      //   메타 FPDate* 판정 = 하드코딩 컬럼 목록 금지. 편집 중 셀 제외 — 에디터 <input> 파손 방어)
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType.startsWith('FPDate') && !isEditing) {
        const text = toDisplayDate(rowItem[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }

      // ⭐ 편집 색 — 편집 게이트와 **같은 함수**(isCellEditable) 사용 (#95 — 편집 Yellow / 잠금 Gray).
      //   공용 formatEditableColumns(IM/IO=CRUD 'I' 기준)보다 뒤에 걸려 본 판정이 최종.
      const inputTp = inputTpRef.current.get(binding);
      const editable = isCellEditable(inputTp, rowItem);
      toggleClass(e.cell, 'wj-cell-editable', editable);
      // 편집형 컬럼(IM/IO/M/O)인데 행 상태로 잠긴 셀만 Gray (S/미지정 컬럼은 기본 White+zebra)
      const editableType = inputTp === 'IM' || inputTp === 'IO' || inputTp === 'M' || inputTp === 'O';
      toggleClass(e.cell, 'wj-cell-non-editable', editableType && !editable && !isRowEditable(rowItem));
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD × 행 상태 단일 원천. 공용 defaultEditHandler(IM/IO='I' 기준) 뒤에
    //   등록되므로 본 핸들러의 e.cancel 명시 설정이 최종 판정 (FIFO 마지막 승리)
    const beginningEditHandler = (
      s: FlexGridType<Tab1Row>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const row = s.rows[e.row]?.dataItem as Tab1Row | undefined;
      const meta = colMetaRef.current.get(binding);
      // FPModal 셀은 편집이 아니라 클릭 팝업 (공용 cellEditHandler 도 cancel — 이중 방어)
      if ((meta?.cellCtrlObjTpCd as unknown as string) === 'FPModal') {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(inputTpRef.current.get(binding), row);
      if (e.cancel) return;
      // ⭐ division 종속 콤보 — 행 division 의 dataMap 으로 스왑. division 미선택 신규행은 편집 차단
      //   (division 먼저 — 타 division 옵션 오염 방지, hook #59 §5-G)
      if (
        (DIVISION_SCOPED_COMBOS as readonly string[]).includes(
          (meta?.cellCboDataTp as unknown as string) ?? ''
        )
      ) {
        const dv = String(row?.DIVISION_ID ?? '');
        if (dv === '') {
          e.cancel = true;
          return;
        }
        const dm = scopedMapsRef.current[`${binding}|${dv}`];
        const col = s.columns[e.col];
        if (col && dm && col.dataMap !== dm) col.dataMap = dm;
      }
      // DIVISION_NAME 편집 직전 CODE 보관 — cellEditEnded 에서 실제 변경 여부 판정
      if (binding === 'DIVISION_NAME') preEditDivisionRef.current = String(row?.DIVISION_ID ?? '');
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — ① NAME 콤보 → CODE 컬럼 동기 기입 ② 신규행 CRUD_TYPE 'C' 원복
    const cellEditEndedHandler = (s: FlexGridType<Tab1Row>, e: { row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as Tab1Row | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;
      // ① dataMap 편집 확정값 = CODE. 콤보 원천에서 CODE 매칭 → CODE 컬럼 기입 + NAME 표시값 유지
      //   (division 종속 콤보는 행 division 의 원천으로 매칭 — 전역 원천과 CODE 충돌 방지)
      const codeBinding = CODE_PAIR[binding];
      if (codeBinding && staticBindingSet.has(binding)) {
        const stored = safeString(rec[binding]);
        const rowDv = safeString(rec.DIVISION_ID);
        const comboRows =
          scopedRowsRef.current[`${binding}|${rowDv}`] ?? comboRowsRef.current[binding] ?? [];
        const hit =
          comboRows.find(r => String(r.CODE ?? '') === stored) ??
          comboRows.find(r => String(r.NAME ?? '') === stored);
        if (hit) {
          rec[codeBinding] = String(hit.CODE ?? '');
          rec[binding] = String(hit.NAME ?? '');
        }
        // ⭐ DIVISION 변경 확정 시 종속 셀(ByDivision 콤보 + CODE 페어) clear — 타 division 값 잔존 방지
        if (binding === 'DIVISION_NAME' && safeString(rec.DIVISION_ID) !== preEditDivisionRef.current) {
          scopedFieldsRef.current.forEach(f => {
            rec[f] = '';
          });
        }
        s.invalidate();
      }
      // ② EditTracker 는 'C' 를 모르는 공용 규약('I'/'D' 만 보존)이라 신규행 편집 시 'M' 으로
      //    뒤집는다 → 본 화면 신규행 계약(CRUD_TYPE 'C')으로 원복 (본 핸들러가 Tracker 뒤에 등록됨)
      if (insertedSetRef.current.has(row) && row.CRUD_TYPE !== 'C') {
        row.CRUD_TYPE = 'C';
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    // FPModal 셀 클릭 → 권한등록 모달 라우팅 (메타 ATTRIBUTE1 소비 — 바인딩 하드코딩 금지)
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if ((meta?.cellCtrlObjTpCd as unknown as string) !== 'FPModal') return;
      const row = g.rows[ht.row]?.dataItem as Tab1Row | undefined;
      if (!row) return;
      if (meta?.attribute1 === MODAL_ATTR.AUTH_REG) onAuthRegCellClick?.(row);
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
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, onAuthRegCellClick]);

  // ⭐ hook #93 — 헤더 총 48px (n단 = 48/n 자동 분배) + combo dataMap 재적용
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<Tab1Row> | null } | null)?.current;
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
