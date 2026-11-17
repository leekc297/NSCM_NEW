import { AllowMerging, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  attachDigitLimit,
  clampNonNegative,
  clearCellText,
  isCellEditable,
  isInvalidPlanGroupRow,
  matchSiteByDivision,
} from '../utils/warehouseCapacityEditLock';
import { COMBO, MSG } from '../warehouse-capacity.constants';
import type { MainRow } from '../warehouse-capacity.types';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  divisionId: string;
  onFocus: () => void;
}

/**
 * Warehouse Capacity 시트(design 03 §1.1, 15컬럼) — DataGrid. 컬럼은 admin
 * `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID='SCP0133', 31행 실측)를 그대로 쓴다(속성 단위 덮어쓰기 금지,
 * convert-core §2.3).
 *
 * 편집잠금(design 01 §2 #2/#6, gridSignals#7~18) — 조회 직후에도 바로 편집 가능하며, DIVISION_ID·
 * 감사4컬럼·PRE_KEY_VALUES 만 항상 잠금(`isCellEditable` 단일 진실원, EditButton 토글 어포던스
 * 미이식). admin `INPUT_TP_CD` 는 현재 전 컬럼 'S'(design 03 실측)라 메타만으로는 편집이 열리지
 * 않는다 — 메타 정비는 `05_register.sql` 대상, 정비 전까지 이 코드의 화이트리스트가 유일한
 * 편집 게이트다.
 *
 * MAX_CAPA 음수 클램프 0(design 03 §3 #27) — TO-BE 문구 확인된 MSG00085 사용(AS-IS MSG00193 은
 * TO-BE 문구 미대조라 MSG00085 하나로 통일, Hook #114).
 *
 * SmartColMerge(design 03 §3 #18, line1180) — 병합 대상 컬럼이 detail 공란이라 미확정
 * (`guides/grid-behavior-parity.md` §1.1). 확인 필요로 명시하고 `allowMerging` 은 None 유지 —
 * 추측 병합 적용 금지.
 *
 * 셀 콤보 Division cascade(A4) — OPMZ_PLAN_GR_ID/STAGE 는 admin 메타 ATTRIBUTE2='DIVISION_ID:
 * DIVISION_ID'(05_register.sql)로 공용 DataGrid 가 행 DIVISION_ID 기준 자동 좁힘(화면 코드 없음,
 * SCP0127/0128 동형). SCM_SITE_ID 는 AS-IS RefreshSiteByDivision EE 분기(EE→81/40/82)가 단순일치로
 * 표현 불가라 화면 코드(matchSiteByDivision + siteDataMap)로 처리한다(memory scp-site-combo-ee-branch).
 */
export const WarehouseCapacityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  divisionId,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  // SCM_SITE_ID 셀 콤보 — 'Site' 콤보(DIVISION_ID 반환)를 matchSiteByDivision 으로 좁혀 DataMap 을
  //   SCM_SITE_ID 컬럼에 덮어쓴다. 공용 DataGrid 가 레이아웃 재계산마다 메타 dataMap 으로 재대입하므로
  //   updatedLayout 마다 재부착한다(SafetyStockGrid SCM_SITE_ID 선례와 동형).
  const [sites, planGroups] = useTabComboQueries({ filters: [COMBO.SITE, COMBO.PLAN_GROUP] });
  const siteDataMap = useMemo(() => {
    const filtered = (sites ?? []).filter(r => matchSiteByDivision(r.DIVISION_ID, divisionId));
    return filtered.length ? new DataMap(filtered, 'CODE', 'NAME') : null;
  }, [sites, divisionId]);

  // OPMZ_PLAN_GR_ID 빈 값 표시(사용자 보고 2026-11-09/10 QA I-06) — SCP_OPMZ_PLAN_GR_M 에서
  //   VALID_YN='Y' 인 코드만 담은 'PlanGroup_SCP_ALL' 콤보(전 사업부, Form 필터와 동일 원천)를
  //   그대로 재사용해 유효코드 집합을 만든다. DB/프로시저 변경 없이 화면(formatItem)에서만 가린다
  //   — 저장키·조회조건은 원본 CRUD 데이터(row.OPMZ_PLAN_GR_ID) 그대로라 영향 없음.
  const validPlanGroupKeys = useMemo(() => {
    const set = new Set<string>();
    for (const r of planGroups ?? []) set.add(`${String(r.DIVISION_ID ?? '')}|${String(r.CODE ?? '')}`);
    return set;
  }, [planGroups]);
  const validPlanGroupKeysRef = useRef(validPlanGroupKeys);
  validPlanGroupKeysRef.current = validPlanGroupKeys;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      if (!siteDataMap) return;
      const col = g.getColumn('SCM_SITE_ID');
      if (col && col.dataMap !== siteDataMap) col.dataMap = siteDataMap;
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, siteDataMap]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const item = sender.rows[e.row]?.dataItem as MainRow | undefined;
      if (!item) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // MAX_CAPA 음수 클램프 0(design 03 §3 #27, MSG00085).
    const cellEditEndedHandler = (
      sender: FlexGridType<MainRow>,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'MAX_CAPA') return;
      const row = GridUtils.getRow(sender, e.row);
      if (!row) return;
      const { value, coerced } = clampNonNegative((row as Record<string, unknown>)[binding]);
      if (coerced) {
        editTrackerRef.current?.storeChange(
          row,
          binding as never,
          (row as Record<string, unknown>)[binding] as never,
          value as never
        );
        (row as Record<string, unknown>)[binding] = value;
        setToast({
          type: 'error',
          message: t(
            MSG.NUMBER_NON_NEGATIVE,
            '_Only values greater than or equal to {0} are allowed.'
          ).replace('{0}', '0'),
        });
        sender.invalidate();
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    // OPMZ_PLAN_GR_ID 빈 값 표시 — 유효 Plan Group 집합 밖 코드는 셀 텍스트만 지운다(DataMap 은
    //   건드리지 않아 편집·저장 값은 그대로 원본 코드를 유지한다). clearCellText 는 텍스트 노드만
    //   비워 Wijmo 가 같이 심어 둔 드롭다운 화살표 요소는 남긴다(2026-11-10 실사고 — textContent
    //   전체 초기화는 그 요소까지 지워 편집 진입 후 드롭다운이 안 뜸).
    const formatItemHandler = (
      sender: FlexGridType<MainRow>,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) clearCellText(e.cell);
    };
    g.formatItem.addHandler(formatItemHandler as never);

    // 편집 진입 시에도 빈값으로 시작(사용자 지시 2026-11-10) — 더블클릭하면 무효 코드(PG0004 등)가
    //   그대로 보이던 것을 빈 입력으로 바꾼다. 단, 아무것도 새로 고르지 않고 그대로 커밋(포커스
    //   이탈)하면 원본 값을 유지해야 한다 — 그렇지 않으면 셀을 클릭했다 나가기만 해도 유효하던
    //   저장값이 빈 문자열로 덮여 데이터가 유실된다(OPMZ_PLAN_GR_ID 는 PRE_KEY_VALUES 구성요소).
    const planGroupPrepareEditHandler = (sender: FlexGridType<MainRow>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) return;
      const editor = sender.activeEditor as { value?: string } | null;
      if (editor) editor.value = '';
    };
    g.prepareCellForEdit.addHandler(planGroupPrepareEditHandler as never);

    const planGroupEditEndingHandler = (
      sender: FlexGridType<MainRow>,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isInvalidPlanGroupRow(row, validPlanGroupKeysRef.current)) return;
      const editor = sender.activeEditor as { value?: string } | null;
      // 빈 입력으로 시작했다가 아무것도 고르지 않았으면(= 여전히 빈 문자열) 취소 — 원본 코드 유지.
      if (!(editor?.value ?? '').trim()) e.cancel = true;
    };
    g.cellEditEnding.addHandler(planGroupEditEndingHandler as never);

    // MAX_CAPA 정수부 10자리 제한(사용자 요청 2026-11-10).
    const detachDigitLimit = attachDigitLimit(g as FlexGridType);

    return () => {
      try {
        detachDigitLimit();
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.formatItem?.removeHandler(formatItemHandler as never);
        g.prepareCellForEdit?.removeHandler(planGroupPrepareEditHandler as never);
        g.cellEditEnding?.removeHandler(planGroupEditEndingHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns]);

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={adminColumns ?? []}
      allowMerging={AllowMerging.None}
      // MAX_CAPA 는 정수만 — 소수점 입력 자체를 막는다(사용자 요청 2026-10-22, COL-11 numberRules).
      //   음수는 기존 clampNonNegative(커밋 시 0 클램프, MSG00085)가 별도로 처리한다.
      numberRules={{ MAX_CAPA: { integerOnly: true } }}
      gotFocus={onFocus}
    />
  );
};
