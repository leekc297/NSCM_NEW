import type { FlexGrid as FlexGridType, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { AllowMerging, CellRange, CellType, HeadersVisibility } from '@mescius/wijmo.grid';
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
import { CustomMergeManager, type EditTracker } from '@foundation/utils';
import { Button } from '@shared/lges';

import { toText } from '../../../lib/call-proc';
import {
  DataGrid,
  keepMergeColumnsByMeta,
  keepServerComboOrder,
  refreshLayoutOnHostResize,
  renderCheckboxCell,
} from '../../../lib/grid';
import { LBL, MERGE_ATTR, PLANT_GROUP_BINDING } from '../plan-yield.constants';
import type { BuildRow, PlantRow } from '../plan-yield.types';
import {
  groupRowRange,
  isFirstRowOfGroup,
  isPlantCellEditable,
  plantProgress,
} from '../utils/plan-yield.editLock';

import styles from './RequestPlantPanel.module.scss';

// ⭐ SDM2020 [1. 샘플 요청 법인] 패널 — 설계서 GRID LEFT 시트.
//   상단 = 빌드 헤더 4행(D-PJT 코드 / 빌드 차수 / 공법 / 특이사항 — GET_PJT_SAMPLE_BUILD 단건, 조회 전용)
//   하단 = 공정별 요청법인 그리드 (admin 메타 100% 주도 — 구분(세로 병합, ATTRIBUTE1='MERGE') / 공정 /
//     요청법인(FPComboBox PlantByDivisionCompany @divisionId=빌드 사업부) / 확인(FPCheckBox — 구분과 같은
//     범위로 세로 병합, 구분 단위 1개, 조회 전용 표시 — 화면에서 토글 불가)) + 진행률 도넛(확인 완료 구분 / 전체 구분).
//   No./상태(I·M·D) rowHeader 는 숨긴다 — 저장이 전 행 replace-set 이라 행별 상태 표시가 무의미 (목업에도 없음).
//   구분(공정 그룹) 셀 선택만 → 수율/Loss 그리드 조회 (페이지 onSelectRow). 다른 컬럼 선택은 트리거 아님.

const quoteCombo = (value?: string): string => `'${value && value.trim() !== '' ? value : 'ALL'}'`;

// 구분 단위 세로 병합 컬럼 — 구분(ATTRIBUTE1='MERGE') + 확인(FPCheckBox)
const isGroupMergeMeta = (meta: RawFlexGridColumnConfig | undefined): boolean =>
  !!meta &&
  (meta.attribute1 === MERGE_ATTR || (meta.cellCtrlObjTpCd as unknown as string) === 'FPCheckBox');

// ⭐ 구분 병합 매니저 — 공용 CustomMergeManager 는 좌측 전 컬럼 누적 키로 병합해 우측 확인 컬럼이
//   공정/요청법인 차이로 갈라진다. 구분 병합 컬럼은 PLANT_GROUP_BINDING 연속 범위(groupRowRange)로
//   병합하고(값이 같은 인접 구분도 넘지 않음), 나머지는 공용 동작 그대로 위임한다.
class PlantGroupMergeManager extends CustomMergeManager {
  constructor(
    grid: FlexGridType,
    private readonly isGroupColumn: (binding: string) => boolean
  ) {
    super(grid as never);
  }

  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    const binding = panel.columns[currentCol]?.binding ?? '';
    if (panel.cellType === CellType.Cell && this.isGroupColumn(binding)) {
      const items: Record<string, unknown>[] = [];
      for (let i = 0; i < panel.rows.length; i++) {
        items.push((panel.rows[i]?.dataItem ?? {}) as Record<string, unknown>);
      }
      const [start, end] = groupRowRange(items, currentRow);
      return start === end ? null : new CellRange(start, currentCol, end, currentCol);
    }
    return super.getMergedRange(panel, currentRow, currentCol);
  }
}

// 진행률 도넛 기하 (viewBox 40) — 반지름·원주
const DONUT_R = 16;
const DONUT_CIRC = 2 * Math.PI * DONUT_R;

interface Props {
  build?: BuildRow;
  rows: PlantRow[];
  gridRef: Ref<FlexGridType<PlantRow>>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  staticColumns?: RawFlexGridColumnConfig[];
  divisionId: string;
  canSave: boolean;
  onSave: () => void;
  onSelectRow: (row: PlantRow | undefined) => void;
}

export const RequestPlantPanel = ({
  build,
  rows,
  gridRef,
  editTrackerRef,
  staticColumns,
  divisionId,
  canSave,
  onSave,
  onSelectRow,
}: Props) => {
  const { t } = useTranslation();

  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );

  // ===== Grid 콤보 — 공용 DataGrid 가 admin 메타(FPComboBox + cellCboDataTp)로 조회한다 (ProjectListGrid 동일).
  //   @divisionId 토큰 해소용 comboParams 만 전달 (빌드 사업부, 따옴표 전달 계약).
  //   ⚠ 패널이 따로 조회해 col.dataMap 을 덮지 말 것 — DataGrid 는 comboParams 없이 조회한 자기 dataMap 을
  //     updatedLayout 마다 되돌리므로(appliedDataMapsRef 복원) 무필터 콤보가 이겨 사업부 필터가 안 걸린다
  //     (2026-09-04 요청법인 리포트). =====
  const comboParams = useMemo(() => ({ divisionId: quoteCombo(divisionId) }), [divisionId]);

  // ⭐ 메타 ref 미러 — 핸들러가 effect 안에서 등록되므로 최신 메타를 ref 로 본다
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));
  const canSaveRef = useRef(canSave);
  canSaveRef.current = canSave;
  const onSelectRowRef = useRef(onSelectRow);
  onSelectRowRef.current = onSelectRow;

  const progress = useMemo(
    () => plantProgress(rows as unknown as Record<string, unknown>[]),
    [rows]
  );

  // ⭐ SDM5010 TAB2 동일 처방 — gridRef.current 직접 참조 effect 는 그리드 미준비 시 조용히 bail 해
  //   핸들러(체크박스 렌더/구분 병합/클릭 토글/공정 선택)가 끝내 등록되지 않는다 (wijmo 기본 boolean
  //   체크박스가 행마다 보이던 원인). initialized 를 state 로 받아 등록 effect 를 그 뒤에 태운다.
  const [gridControl, setGridControl] = useState<FlexGridType<PlantRow> | null>(null);
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    setGridControl(grid as FlexGridType<PlantRow>);
  }, []);

  // ⭐ 레이아웃 재계산 옵저버 — 그리드 인스턴스당 1회만 붙인다 (deps 는 gridControl 뿐).
  //   메타/콤보 변경 effect 에 얹으면 옵저버가 재생성되면서 그 순간의 크기 변화를 놓쳐,
  //   "어떤 때는 클릭이 되고 어떤 때는 안 되는" 경쟁 조건이 된다 (2026-09-04).
  useEffect(() => {
    const g = gridControl;
    if (!g?.hostElement?.isConnected) return;
    return refreshLayoutOnHostResize(g as FlexGridType);
  }, [gridControl]);

  // ===== grid 핸들러 =====
  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 0) g.alternatingRowStep = 0; // 병합 그리드 — zebra 는 병합 셀과 충돌
    keepServerComboOrder(g as FlexGridType);
    const isGroupColumn = (binding: string) => isGroupMergeMeta(colMetaRef.current.get(binding));
    const detachMerge = keepMergeColumnsByMeta(g as FlexGridType, isGroupColumn);
    // 그리드 인스턴스당 1회 — CustomMergeManager 생성자가 grid 이벤트를 구독하므로 effect 재실행마다 만들지 않는다
    if (!(g.mergeManager instanceof PlantGroupMergeManager))
      g.mergeManager = new PlantGroupMergeManager(g as FlexGridType, isGroupColumn);

    const sourceRows = () =>
      (g.collectionView?.sourceCollection ?? []) as unknown as Record<string, unknown>[];

    const formatHandler = (_s: FlexGridType<PlantRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      const rowItem = g.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!meta || !rowItem) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;
      if (isEditing) return; // 편집기 <input> 보호 (DMF0044 계보)

      // ⭐ 확인 체크박스 — 구분 범위로 병합된 셀 1개 (렌더는 병합 첫 행). 병합이 풀린 행은 빈 셀.
      //   조회 전용 — 화면에서 토글 불가 (disabled 렌더, 편집 색 없음)
      if (ctrlType === 'FPCheckBox') {
        e.cell.classList.remove('wj-cell-editable');
        const all = sourceRows();
        const idx = all.indexOf(rowItem);
        if (!isFirstRowOfGroup(all, idx)) {
          e.cell.textContent = '';
          return;
        }
        renderCheckboxCell(e.cell, toText(rowItem[binding]), {
          className: styles.checkbox,
          enabled: false,
        });
        return;
      }

      // ⭐ 편집 색 — 편집 게이트와 같은 함수 (isPlantCellEditable)
      const editable = canSaveRef.current && isPlantCellEditable(meta.inputTpCd, ctrlType);
      e.cell.classList.toggle('wj-cell-editable', editable);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — INPUT_TP_CD 단일 원천. 체크박스 셀은 편집기 자체 차단(클릭 토글)
    const beginningEditHandler = (
      s: FlexGridType<PlantRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      e.cancel = !(canSaveRef.current && isPlantCellEditable(meta.inputTpCd, ctrlType));
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ⭐ 구분(공정 그룹) 셀 선택 → 수율/Loss 그리드 조회 (같은 구분이면 페이지가 무시).
    //   트리거는 **구분 컬럼만** — 공정/요청법인/확인 셀 선택은 조회를 바꾸지 않는다 (2026-09-04 사용자 확정.
    //   조회 단위가 공정 1건이 아니라 구분 1블록이라 공정 셀 클릭은 의미가 없다).
    //   hostElement click 이 아니라 wijmo selectionChanged 를 쓴다 — 편집 가능 그리드라 클릭 도중
    //   셀 DOM 이 교체되면 click 이 유실될 수 있고, 키보드 이동도 같은 경로로 잡힌다.
    const selectionHandler = () => {
      const { row = -1, col = -1 } = g.selection ?? {};
      if (row < 0 || col < 0) return;
      if (g.columns[col]?.binding !== PLANT_GROUP_BINDING) return;
      onSelectRowRef.current(g.rows[row]?.dataItem as PlantRow | undefined);
    };
    g.selectionChanged.addHandler(selectionHandler);

    g.invalidate(true);

    return () => {
      try {
        detachMerge();
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.selectionChanged?.removeHandler(selectionHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridControl, visibleColumns]);

  // 빌드 차수 — 목업대로 B | 2 | - | 1 네 칸 (SDM2010 SampleBuildPanel 은 "B 2 - 1" 한 줄)
  const buildSeqCells = build
    ? [build.DPJT_BUILD_TYPE, build.DPJT_BUILD_SEQ, '-', build.DPJT_BIND_SEQ]
    : ['', '', '', ''];

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span
          className={styles.title}
        >{`1. ${t(LBL.REQUEST_PLANT_TITLE, '_샘플 요청 법인')}`}</span>
        {canSave && (
          <div className={styles.actions}>
            <Button size='small' appearance='contained' onClick={onSave} disabled={!build}>
              {t(LBL.SAVE, '_저장')}
            </Button>
          </div>
        )}
      </div>

      <div className={styles.fieldTable}>
        <div className={styles.row}>
          <div className={styles.label}>{t(LBL.DPJT_CODE, '_D-PJT 코드')}</div>
          <div className={styles.value}>{toText(build?.DPJT_CODE)}</div>
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t(LBL.BUILD_NO, '_빌드 차수')}</div>
          {buildSeqCells.map((v, i) => (
            <div key={i} className={styles.value}>
              {toText(v)}
            </div>
          ))}
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t(LBL.STACK_METHOD, '_공법')}</div>
          <div className={styles.value}>
            {toText(build?.STACK_METHOD_NAME) || toText(build?.STACK_METHOD)}
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t(LBL.NOTE, '_특이사항')}</div>
          <div className={styles.value}>{toText(build?.NOTE)}</div>
        </div>
      </div>

      {/* ⭐ 컬럼 메타가 온 뒤에 그리드를 만든다 — 0 컬럼으로 먼저 만들면 메타 도착 시 key 가 바뀌며
          그 그리드가 폐기되는데, 폐기 시점에 예약돼 있던 wijmo refresh 가 뒤늦게 돌아
          `finishEditing` 널 참조로 터진다. 이 예외가 wijmo 의 공용 refresh 큐를 끊어 **뒤이어 만들어진
          그리드의 레이아웃 계산까지 중단**되고, 그 결과 hitTest 가 cellType=None/row=-1 을 돌려
          셀을 클릭해도 선택이 안 옮겨진다 = "그리드 클릭이 안 된다" (2026-09-04 콘솔 실측). */}
      <div className={styles.grid}>
        {visibleColumns.length > 0 && (
          <DataGrid
            key={visibleColumns.map(c => c.colNm).join(',')}
            className={styles.plantGrid}
            gridRef={gridRef as never}
            editTrackerRef={editTrackerRef as never}
            initialized={handleGridInitialized}
            staticColumns={visibleColumns}
            itemsSource={rows as unknown as WijmoRowItem[]}
            comboParams={comboParams}
            autoGenerateColumns={false}
            allowSorting={false}
            allowMerging={AllowMerging.All}
            headersVisibility={HeadersVisibility.Column} // No./상태 rowHeader 숨김
            useContextMenu={false}
          />
        )}
      </div>

      {/* 진행률 도넛 — 확인 완료 구분 / 전체 구분 (목업 우하단 67%). SVG stroke-dasharray (인라인 style 금지) */}
      <div className={styles.progress} title={t(LBL.PROGRESS, '_진행률')}>
        <svg
          className={styles.donut}
          viewBox='0 0 40 40'
          role='img'
          aria-label={`${progress.percent}%`}
        >
          <circle className={styles.donutTrack} cx='20' cy='20' r={DONUT_R} />
          <circle
            className={styles.donutValue}
            cx='20'
            cy='20'
            r={DONUT_R}
            strokeDasharray={`${(DONUT_CIRC * progress.percent) / 100} ${DONUT_CIRC}`}
          />
          <text className={styles.donutText} x='20' y='20'>
            {`${progress.percent}%`}
          </text>
        </svg>
      </div>
    </div>
  );
};
