import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { BUCKET_TYPE } from '../shipment-plan-fix.constants';
import { MEASURE_FIX_REASON, WEEKEND_COLOR } from '../shipment-plan-fix.constants';
import type { MainRow } from '../shipment-plan-fix.types';
import { buildFixedColumns, buildPivotColumns } from '../utils/shipmentPlanFixColumns';
import { FIX_REASON_FIELD } from '../utils/shipmentPlanFixDerive';
import { ShipmentPlanFixMergeManager } from '../utils/shipmentPlanFixMerge';
import { isPivotVisible, pivotKind, type VisibilityContext } from '../utils/shipmentPlanFixVisibility';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  visibilityCtx: VisibilityContext;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 다단(월/주/일) 헤더 각 행 높이(px). 3단이면 총 72px — 다른 3단 화면 기준(사용자 지시 2026-10-01).
const HEADER_ROW_HEIGHT = 24;

// AS-IS GSCM.SCP.Analysis.UIL SCP0025 spdMain — 20 고정(정보/키·measure frozen) + D_/W_/M_ 동적 pivot(3단 헤더).
//   measure=행 축(Ship Plan 위 / Fix Reason 아래). 전 컬럼 read-only(INPUT_TP_CD='S' 전건, LockColumn all — design 03 R-G).
//   편집 그리드가 아니다 → beginningEdit/pastingCell/EditTracker 편집 없음. Unfix 는 셀 선택 → 페이지 handleUnfix(§4.3).
//   버튼-API 배선(DB 실측): SCM_ADM_MNU_BTN_MPG_M 2행(main/SEARCH·main/SAVE) 등록. PKG_SCP0025 VALID.
export const ShipmentPlanFixGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  bucket,
  chkSum,
  visibilityCtx,
  adminColumns,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, visibilityCtx),
    [adminColumns, visibilityCtx]
  );
  // SUM 토글은 컬럼 재생성 없이 imperative visible flip 으로 반영한다(아래 applyPivotVisibility) — 스크롤/폭
  //   보존 + 헤더 재레이아웃 깜빡임 제거. 그래서 pivotColumns 빌드 dep 에서 chkSum 을 제외하고(bucket/rows 구조
  //   변화에만 재생성), 빌드 시점 초기 visible 만 chkSumRef 로 최신값을 참조한다(자매 SSP0015 chkSumRef 패턴).
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;
  // 헤더 더블클릭 드릴 오버라이드(binding → visible). base(isPivotVisible) 위에 우선 적용. bucket/조회 변경 시 리셋.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyPivotVisibilityRef = useRef<(() => void) | null>(null);
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSumRef.current),
    [rows, bucket]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 요일 헤더 색(design 03 §2.4 R-A — 토 Blue / 일 Red, gridSignals #29 ForeColor).
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (pivotKind(binding) !== 'D') return;
        const d = pivotTag(binding);
        if (d.length < 8) return;
        const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        const dow = date.getUTCDay();
        if (dow === 6) ev.cell.style.color = WEEKEND_COLOR.SATURDAY; // 토 Blue
        else if (dow === 0) ev.cell.style.color = WEEKEND_COLOR.SUNDAY; // 일 Red
        return;
      }
      // Fix Reason 행의 pivot 셀 = 텍스트(사유)인데 pivot 컬럼이 숫자(format n0 → dataType=Number 자동부여)라
      //   Wijmo 가 숫자로 강제해 NaN→공란이 된다. AS-IS Set_FixReason 이 SetCellTypeText 로 해당 셀을 텍스트셀로
      //   바꿔 FIX_REASON 을 넣던 것(cs:644·698)의 TO-BE 등가 — dataItem 의 원문(mergeFixReason 이 병합한 사유)을
      //   직접 그려준다. Ship Plan 행 숫자셀은 기본 n0 렌더 그대로 둔다.
      if (ev.panel.cellType === CellType.Cell && pivotKind(binding) !== null) {
        const item = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
        if (!item) return;
        if ((str(item.MEASURE) || str(item.measure)) === MEASURE_FIX_REASON) {
          // Fix Reason 행 = 별도 필드(FIX_REASON_FIELD)의 YYYYMMDD→사유 맵에서 이 셀 날짜로 조회해 텍스트 렌더.
          //   pivot 숫자 셀을 쓰지 않으므로 Wijmo dataType=Number coercion 과 무관(AS-IS SetCellTypeText 등가).
          const reasons = item[FIX_REASON_FIELD] as Record<string, string> | undefined;
          ev.cell.textContent = reasons?.[pivotTag(binding).slice(0, 8)] ?? '';
        } else {
          // Ship Plan 행 = 숫자 n0(천단위) 포맷. pivot 컬럼에서 format 을 뺐으므로 여기서 직접 적용한다.
          const v = item[binding];
          const n = typeof v === 'number' ? v : Number(v);
          ev.cell.textContent = v == null || v === '' || Number.isNaN(n) ? '' : n.toLocaleString();
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 병합 매니저 — 공용 매니저를 감싸 (a) 선행 식별 컬럼 데이터셀 계층 세로병합 (b) 동적 M_/W_/D_
    //   헤더 병합(년월/주차 가로 · M_ SUM 세로) 전담. 정적 헤더·그 외는 delegate.
    //   자매 SSP0015 ShipmentPsiMainGrid 1:1(사용자 요구 "SSP0015 와 동일" 2026-10-01 — 값기반 공용
    //   병합이 M_/W_ 'SUM' 라벨을 가로로 잘못 뭉치거나 SUM 세로병합을 풀던 것 교정).
    //   instanceof 가드 — DataGrid 가 init 에서 mergeManager 를 CustomMergeManager→TopLeft 로 재배선하므로
    //   ref 표식 대신 "내 타입이 아닐 때만" 감싼다. 이미 내 매니저면 재래핑 안 함(체인 증식 방지).
    if (!(g.mergeManager instanceof ShipmentPlanFixMergeManager)) {
      g.mergeManager = new ShipmentPlanFixMergeManager(g.mergeManager);
    }
    const mergeManager = g.mergeManager as ShipmentPlanFixMergeManager;

    // 계층 세로병합 키(fixedBindings) 갱신 — 동적(M_/W_/D_)·MEASURE(측정치 행라벨)를 제외한 선행 식별
    //   컬럼(Div/Operation Group/Model/Nick Name/To Site …)을 값이 같은 연속 행끼리 세로병합한다
    //   (AS-IS siMain.SmartColMerge, gridSignals #26/#44 design 03 R-F).
    //   주의: col.allowMerging 은 여기서 쓰지 않는다 — DataGrid 가 정적 컬럼에 이미 true 를 심고(pivot 은
    //   buildPivotColumns 가 false), Wijmo 는 셀마다 getMergedRange 를 부르므로 매니저 ①이 fixedBindings
    //   만으로 판정한다. updatedLayout 에서 allowMerging 을 매번 다시 쓰면 레이아웃 재계산이 반복돼
    //   그리드가 깜빡인다(2026-10-01 회귀). fixedBindings 는 매니저 필드라 대입해도 invalidate 가 없다.
    const syncFixedBindings = () => {
      const fixed: string[] = [];
      g.columns.forEach(col => {
        const b = col.binding ?? '';
        if (!!b && pivotKind(b) === null && b !== 'MEASURE') fixed.push(b);
      });
      // 무조건 대입 — fixedBindings 는 매니저 필드라 대입해도 invalidate 가 없어 깜빡임과 무관하다
      //   (SSP0015 동일). 읽기 비교(.join)는 mergeManager 가 교체돼 undefined 일 때 크래시 원인이라 제거.
      mergeManager.fixedBindings = fixed;
    };
    g.updatedLayout.addHandler(syncFixedBindings);
    syncFixedBindings();

    // 다단 헤더 각 행 높이 강제(3단=72) — 공용 columnMapping 이 flat 고정컬럼에 ONE_DEPTH(48) 명시 height 를
    //   박아(고정컬럼에 소/대분류 라벨이 없어 THREE_DEPTH 미판정) 3단 pivot 과 겹치면 48×3=144 로 벌어진다.
    //   컬럼에 박힌 명시 height 가 panel defaultSize(headerRowHeight prop)를 이기므로, columnGroups 재빌드마다
    //   발생하는 updatedLayout 에서 defaultSize + 각 헤더 행 height 를 직접 24 로 덮어쓴다. guard 로 재적용 루프 차단.
    const applyHeaderHeight = () => {
      const hr = g.columnHeaders?.rows;
      // 단일 단(조회 전 고정컬럼만 = 1 header row)은 기본 높이(ONE_DEPTH 48)를 유지한다 — 압축하면
      //   다른 화면 대비 너무 낮아진다(사용자 지시). 다단(pivot 로드)일 때만 각 행을 24 로 압축(3단=72).
      if (!hr || hr.length <= 1) return;
      if (Math.round(hr.defaultSize) !== HEADER_ROW_HEIGHT) hr.defaultSize = HEADER_ROW_HEIGHT;
      for (let i = 0; i < hr.length; i++) {
        if (Math.round(hr[i].height ?? 0) !== HEADER_ROW_HEIGHT) hr[i].height = HEADER_ROW_HEIGHT;
      }
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.updatedLayout?.removeHandler(syncFixedBindings);
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  // 동적 컬럼 visible 제어 — (a) SUM(chkSum)·bucket 기본 가시성 + (b) 헤더 더블클릭 드릴 오버라이드.
  //   컬럼을 재생성하지 않고 col.visible 만 flip 하므로 헤더 재레이아웃(48→24 clamp) 깜빡임이 없다(자매 SSP0015 동형).
  //   DataGrid 의 columnGroups 재적용이 visible 을 덮을 수 있어 updatedLayout 마다 재적용하고, 바뀐 게 있을 때만 invalidate.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyPivotVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (pivotKind(b) === null) continue;
        // base(bucket×chkSum) 위에 드릴 오버라이드 우선(AS-IS SetSpreadColumn + SetDblClickColumnShowHide 통합).
        const base = isPivotVisible(b, bucket, chkSum);
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyPivotVisibilityRef.current = applyPivotVisibility;
    g.updatedLayout.addHandler(applyPivotVisibility);
    applyPivotVisibility();

    // 헤더 더블클릭 드릴다운 (AS-IS SpdMain_CellDoubleClick → siMain.SetDblClickColumnShowHide, cs:446-447 / 자매
    //   SSP0015 ShipmentPsiMainGrid 1:1): M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기 /
    //   W_ 헤더 = 그 주 구간(다음 W_/M_ 전까지) D_ 토글. 표시 순서(g.columns)의 동적 바인딩을 walk 한다.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = pivotKind(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const dyn: string[] = [];
      for (let i = 0; i < g.columns.length; i++) {
        const b = g.columns[i].binding ?? '';
        if (pivotKind(b) !== null) dyn.push(b);
      }
      const idx = dyn.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dyn.length; i++) {
        const t = dyn[i];
        const tk = pivotKind(t);
        if (hk === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyPivotVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyPivotVisibility);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [bucket, chkSum, pivotColumns, gridRef]);

  // 드릴 오버라이드 리셋 — bucket 변경·새 조회(pivotColumns 재생성) 시 초기화한다. SUM 토글은 드릴을 보존한다
  //   (SSP0015 동형 — Monthly 에서 드릴 펼친 뒤 Sum 체크해도 접히지 않도록 chkSum 은 리셋 트리거에서 제외).
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucket, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      // 전 컬럼 표시전용(INPUT_TP_CD='S' 전건, 편집 불가) — read-only 로 선언해 rowHeader 의
      //   Status(수정상태 표시) 컬럼을 떼어 No 컬럼만 남긴다(수정 불가 화면이라 Status 무의미).
      isReadOnly
      // 헤더 행 높이는 headerRowHeight prop(panel defaultSize) 으로는 고정컬럼에 박힌 명시 height 를 못 이겨
      //   useEffect 의 updatedLayout 핸들러에서 각 행 height 를 직접 덮는다(위 주석). prop 미사용.
      gotFocus={onFocus}
    />
  );
};
