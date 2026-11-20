import { DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { LBL, MENU_ID, MSG, SHEETS } from '../../production-plan-line.constants';
import { MOCK_MAIN_ENABLED } from '../../production-plan-line.mock'; // ⚠ 임시 개발용 목데이터
import { isEeDivision } from '../../utils/productionPlanLineEditLock';

import styles from './ProductionPlanInsertModal.module.scss';

// AS-IS SCM0002_ProductionPlanInsertPopup(FpSpread 편집 그리드) 를 공용 DataGrid 셀 콤보로 재현
//   (design 01 R5 / 사용자 지시 2026-10-15 — SCP0005 식 그리드 내부 콤보, 행별 캐스케이드 유지).
//   버전키(Plan date/type/seq/div/opGroup)는 locked 텍스트, Material(ITEM_ID)·Plant Site·Line(+EE Origin
//   Div)만 셀 콤보로 편집한다. Material 은 고정 콤보(전 행 동일), Plant/Line/OriginDiv 은 그 행의 상위
//   선택에 따라 후보가 달라지는 행별 캐스케이드 — DataMap superset + getDisplayValues(rowItem) override 로
//   구현한다(column.dataMap 을 beginningEdit 에서 갈아끼우면 DMF0049 실사고, gridCombos 금지규약).
//   데이터 원천(ora.py 실측): Item 후보=ItemProdPlanLinePopup_SCP(div/opGroup) / Line=LineProdPlanLinePopup_SCP
//   (div/opGroup/plant/operation/originDiv/item) / Origin Div(EE)=OriginDivFromFinalItem_SCP(item).
//   저장: 행별 newCheck(P_SCP0013_GET_LINE_NEW_CHECK)→savePopup(P_SCP0013_SAVE_LINE_POPUP).

interface Option {
  value: string;
  label: string;
}

interface ItemPlantRow {
  CODE?: string; // ITEM_ID
  NAME?: string;
  PLANT_SITE_ID?: string;
  SITE_DESCRIPTION?: string;
  NICK_NAME?: string;
  ITEM_TYPE?: string;
  OPERATION_ID?: string;
  DIVISION_ID?: string; // originDivisionId 원천(EE)
  OSP_YN?: string;
}

// DataGrid itemsSource 행(신규 — CRUD_TYPE='I'). 버전키 포함(그리드가 locked 셀로 표시).
//   WijmoRowItem(=Record<string,WijmoPrimitive>) 확장 — DataGrid<T> 제약 충족.
interface InsertRow extends WijmoRowItem {
  _key: number;
  CRUD_TYPE: 'I';
  PLAN_DATE: string;
  PLAN_TYPE: string;
  PLAN_SEQ: string;
  DIVISION_ID: string;
  ORIGIN_DIVISION_ID: string;
  OPERATION_GROUP: string; // 표시명(Pack/Cell/Electrode)
  ITEM_ID: string;
  NICK_NAME: string;
  ITEM_TYPE: string;
  PLANT_SITE_ID: string;
  LINE_ID: string;
  OPERATION_ID: string; // 파생(hidden) — Line 조회·저장용
}

interface Props {
  open: boolean;
  modalClose: () => void;
  params: {
    divisionId: string;
    operationGroupId: string;
    planStartYyyymmdd: string;
    planType: string;
    planSeq: string;
  };
  onSaved: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const lineKey = (itemId: string, plantSiteId: string): string => `${itemId}|${plantSiteId}`;

// 콤보 컬럼 1건 정의(FPComboBox + 편집). 버전키/파생은 _inputEditType='S' 텍스트.
const col = (
  colNm: string,
  colLblNm: string,
  width: number,
  opts?: { combo?: boolean; align?: 'L' | 'C' }
): RawFlexGridColumnConfig => ({
  colNm,
  colLblNm,
  horzAlgnCd: opts?.align ?? (opts?.combo ? 'L' : 'C'),
  colWth: width,
  visible: true,
  display: true,
  inputTpCd: opts?.combo ? CELL_INPUT_EDIT_TYPE.OPTIONAL : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  cellCtrlObjTpCd: opts?.combo ? CELL_CONTROL_TYPE.COMBO : undefined,
});

export const ProductionPlanInsertModal = ({ open, modalClose, params, onSaved }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const isEe = isEeDivision(params.divisionId);
  const requiredMsg = (label: string): string =>
    t(MSG.REQUIRED_FIELD, '_{0} is required.').replace('{0}', label);

  const gridRef = useRef<FlexGridType<InsertRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<InsertRow>>();

  // Operation Group 코드→명(Pack/Cell/Electrode) — AS-IS 런타임 동일.
  const [operationGroupData] = useTabLookupQueries({ filters: [{ lookupType: 'OPERATION_GROUP' }] });
  const operationGroupName = useMemo(() => {
    const m = new Map<string, string>();
    (operationGroupData ?? []).forEach(r => m.set(str(r.CODE), str(r.NAME)));
    return m.get(params.operationGroupId) || params.operationGroupId;
  }, [operationGroupData, params.operationGroupId]);

  const [itemPlantRows, setItemPlantRows] = useState<ItemPlantRow[]>([]);
  const [originDivByItem, setOriginDivByItem] = useState<Record<string, Option[]>>({}); // EE
  const [linesByKey, setLinesByKey] = useState<Record<string, Option[]>>({}); // `${item}|${plant}`
  const [rows, setRows] = useState<InsertRow[]>([]);
  const [saving, setSaving] = useState(false);
  const keyRef = useRef(0);

  const makeRow = useCallback(
    (): InsertRow => ({
      _key: keyRef.current++,
      CRUD_TYPE: 'I',
      PLAN_DATE: params.planStartYyyymmdd,
      PLAN_TYPE: params.planType,
      PLAN_SEQ: params.planSeq,
      DIVISION_ID: params.divisionId,
      ORIGIN_DIVISION_ID: isEe ? '' : params.divisionId,
      OPERATION_GROUP: operationGroupName,
      ITEM_ID: '',
      NICK_NAME: '',
      ITEM_TYPE: '',
      PLANT_SITE_ID: '',
      LINE_ID: '',
      OPERATION_ID: '',
    }),
    [params, isEe, operationGroupName]
  );

  // 오픈 시 Item 후보 조회 + 사전채움 행 1개(AS-IS InsertRow on load).
  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    void (async () => {
      try {
        const res = await apiClient.getCombo({
          comboId: 'ItemProdPlanLinePopup_SCP',
          divisionId: params.divisionId,
          operationGroup: params.operationGroupId,
          originDivisionId: '',
        });
        if (!cancelled) setItemPlantRows(res as unknown as ItemPlantRow[]);
      } catch {
        if (!cancelled) setItemPlantRows([]);
      }
    })();
    setRows([makeRow()]);
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, params.divisionId, params.operationGroupId]);

  useEffect(() => {
    if (open) return;
    setRows([]);
    setItemPlantRows([]);
    setOriginDivByItem({});
    setLinesByKey({});
  }, [open]);

  // ===== 컬럼 =====
  const columns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const base: RawFlexGridColumnConfig[] = [
      col('PLAN_DATE', t(LBL.PLAN_DATE, '_Plan Date'), 90),
      col('PLAN_TYPE', t(LBL.PLAN_TYPE, '_Plan Type'), 70),
      col('PLAN_SEQ', t(LBL.SEQ, '_Seq'), 55),
      col('DIVISION_ID', t(LBL.DIVISION, '_Div'), 55),
      col('ORIGIN_DIVISION_ID', `Origin Div${isEe ? '*' : ''}`, 80, { combo: isEe }),
      col('OPERATION_GROUP', t(LBL.OPERATION_GROUP, '_Operation Group'), 90),
      col('ITEM_ID', `${t(LBL.MATERIAL, '_Material')}*`, 150, { combo: true }),
      col('NICK_NAME', t(LBL.NICK_NAME, '_Nick Name'), 110, { align: 'L' }),
      col('ITEM_TYPE', 'Item Type', 70),
      col('PLANT_SITE_ID', `${t(LBL.PLANT_SITE, '_Plant Site')}*`, 150, { combo: true }),
      col('LINE_ID', `${t(LBL.LINE, '_Line')}*`, 130, { combo: true }),
    ];
    return base;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEe]);

  // ===== 콤보 DataMap (superset + getDisplayValues(rowItem) override) =====
  //   display(getDisplayValue)는 superset 전체로, 드롭다운 후보(getDisplayValues)는 행 컨텍스트로 좁힌다.
  const itemDataMap = useMemo(() => {
    const seen = new Set<string>();
    const items: Option[] = [];
    for (const r of itemPlantRows) {
      const v = str(r.CODE);
      if (!v || seen.has(v)) continue;
      seen.add(v);
      items.push({ value: v, label: str(r.NAME) || v });
    }
    return new DataMap(items, 'value', 'label');
  }, [itemPlantRows]);

  const plantDataMap = useMemo(() => {
    // superset = 전 Plant(코드→명). 후보는 행의 ITEM_ID(+EE originDiv)로 좁힌다.
    const seen = new Set<string>();
    const all: Option[] = [];
    for (const r of itemPlantRows) {
      const v = str(r.PLANT_SITE_ID);
      if (!v || seen.has(v)) continue;
      seen.add(v);
      all.push({ value: v, label: str(r.SITE_DESCRIPTION) || v });
    }
    const dm = new DataMap(all, 'value', 'label');
    dm.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as InsertRow;
      const itemId = str(row.ITEM_ID);
      if (!itemId) return [];
      const s = new Set<string>();
      const out: string[] = [];
      for (const r of itemPlantRows) {
        if (str(r.CODE) !== itemId) continue;
        if (isEe && str(row.ORIGIN_DIVISION_ID) && str(r.DIVISION_ID) !== str(row.ORIGIN_DIVISION_ID))
          continue;
        const code = str(r.PLANT_SITE_ID);
        if (!code || s.has(code)) continue;
        s.add(code);
        out.push(str(r.SITE_DESCRIPTION) || code);
      }
      return out;
    };
    return dm;
  }, [itemPlantRows, isEe]);

  const lineDataMap = useMemo(() => {
    // superset = 로드된 전 Line(코드→명). 후보는 행의 (item,plant) 로드분으로 좁힌다.
    const seen = new Set<string>();
    const all: Option[] = [];
    for (const opts of Object.values(linesByKey)) {
      for (const o of opts) {
        if (seen.has(o.value)) continue;
        seen.add(o.value);
        all.push(o);
      }
    }
    const dm = new DataMap(all, 'value', 'label');
    dm.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as InsertRow;
      const opts = linesByKey[lineKey(str(row.ITEM_ID), str(row.PLANT_SITE_ID))] ?? [];
      return opts.map(o => o.label);
    };
    return dm;
  }, [linesByKey]);

  const originDivDataMap = useMemo(() => {
    const seen = new Set<string>();
    const all: Option[] = [];
    for (const opts of Object.values(originDivByItem)) {
      for (const o of opts) {
        if (seen.has(o.value)) continue;
        seen.add(o.value);
        all.push(o);
      }
    }
    const dm = new DataMap(all, 'value', 'label');
    dm.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as InsertRow;
      return (originDivByItem[str(row.ITEM_ID)] ?? []).map(o => o.label);
    };
    return dm;
  }, [originDivByItem]);

  // 콤보 dataMap 을 컬럼에 적용 — columnGroups 재대입마다(updatedLayout) 다시 건다(공용 패턴).
  const dataMapByBinding = useMemo<Record<string, DataMap>>(
    () => ({
      ITEM_ID: itemDataMap,
      PLANT_SITE_ID: plantDataMap,
      LINE_ID: lineDataMap,
      ...(isEe ? { ORIGIN_DIVISION_ID: originDivDataMap } : {}),
    }),
    [itemDataMap, plantDataMap, lineDataMap, originDivDataMap, isEe]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      for (const [binding, dm] of Object.entries(dataMapByBinding)) {
        const c = g.columns.getColumn(binding);
        if (c && c.dataMap !== dm) c.dataMap = dm;
      }
    };
    apply();
    g.updatedLayout.addHandler(apply);
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [dataMapByBinding, rows]);

  // ===== 캐스케이드 (cellEditEnded) =====
  const loadLines = useCallback(
    async (row: InsertRow) => {
      const key = lineKey(row.ITEM_ID, row.PLANT_SITE_ID);
      if (!row.ITEM_ID || !row.PLANT_SITE_ID || linesByKey[key]) return;
      try {
        const res = await apiClient.getCombo({
          comboId: 'LineProdPlanLinePopup_SCP',
          divisionId: params.divisionId,
          operationGroup: params.operationGroupId,
          plantSiteId: row.PLANT_SITE_ID,
          operationId: row.OPERATION_ID,
          originDivisionId: row.ORIGIN_DIVISION_ID,
          itemId: row.ITEM_ID,
        });
        const opts = (res as unknown as { CODE?: string; NAME?: string }[]).map(r => ({
          value: str(r.CODE),
          label: str(r.NAME) || str(r.CODE),
        }));
        setLinesByKey(prev => ({ ...prev, [key]: opts }));
      } catch {
        setLinesByKey(prev => ({ ...prev, [key]: [] }));
      }
    },
    [linesByKey, params.divisionId, params.operationGroupId]
  );

  const loadOriginDiv = useCallback(async (itemId: string) => {
    if (!itemId) return;
    try {
      const res = await apiClient.getCombo({ comboId: 'OriginDivFromFinalItem_SCP', itemId });
      const opts = (res as unknown as { CODE?: string; NAME?: string }[]).map(r => ({
        value: str(r.CODE),
        label: str(r.NAME) || str(r.CODE),
      }));
      setOriginDivByItem(prev => ({ ...prev, [itemId]: opts }));
    } catch {
      setOriginDivByItem(prev => ({ ...prev, [itemId]: [] }));
    }
  }, []);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const onEdit = (sender: FlexGridType<InsertRow>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as InsertRow | undefined;
      if (!row) return;
      if (binding === 'ITEM_ID') {
        const itemRow = itemPlantRows.find(r => str(r.CODE) === str(row.ITEM_ID));
        row.NICK_NAME = str(itemRow?.NICK_NAME);
        // AS-IS: ITEM_TYPE=='Z' 는 공백 표시(cs:684/1063/1244).
        const itemType = str(itemRow?.ITEM_TYPE);
        row.ITEM_TYPE = itemType === 'Z' ? '' : itemType;
        row.PLANT_SITE_ID = '';
        row.LINE_ID = '';
        row.OPERATION_ID = '';
        if (isEe) {
          row.ORIGIN_DIVISION_ID = '';
          void loadOriginDiv(str(row.ITEM_ID));
        }
        sender.invalidate();
      } else if (binding === 'ORIGIN_DIVISION_ID') {
        row.PLANT_SITE_ID = '';
        row.LINE_ID = '';
        row.OPERATION_ID = '';
        sender.invalidate();
      } else if (binding === 'PLANT_SITE_ID') {
        const itemRow = itemPlantRows.find(
          r => str(r.CODE) === str(row.ITEM_ID) && str(r.PLANT_SITE_ID) === str(row.PLANT_SITE_ID)
        );
        row.OPERATION_ID = str(itemRow?.OPERATION_ID);
        row.LINE_ID = '';
        void loadLines(row);
        sender.invalidate();
      }
    };
    g.cellEditEnded.addHandler(onEdit as never);
    // AS-IS SpdMain_ClipboardPasted→setRowForNotEE/setRowForEE(cs:810/1034/1215) — 붙여넣기 후에도
    //   Nick Name·Item Type 파생 + plant/line 캐스케이드를 재현한다(콤보 선택과 동일 경로). pastedCell 은
    //   cellEditEnded 와 동일 CellRangeEventArgs(row/col) 라 같은 핸들러를 재사용(SmsCategoryGrid 선례).
    g.pastedCell.addHandler(onEdit as never);
    return () => {
      g.cellEditEnded?.removeHandler(onEdit as never);
      g.pastedCell?.removeHandler(onEdit as never);
    };
  }, [itemPlantRows, isEe, loadLines, loadOriginDiv]);

  // ===== 툴바 =====
  const handleInsert = () => setRows(rs => [...rs, makeRow()]);

  const handleDelete = () => {
    const g = gridRef.current;
    const sel = g?.selection;
    const idx = sel && sel.row >= 0 ? sel.row : rows.length - 1;
    if (idx < 0) return;
    setRows(rs => rs.filter((_, i) => i !== idx));
  };

  const dirtyRows = (): InsertRow[] => {
    const g = gridRef.current;
    g?.finishEditing();
    return g?.collectionView?.sourceCollection ?? rows;
  };

  const handleSave = async () => {
    const list = dirtyRows();
    if (list.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_TARGET, '_No row to save.') });
      return;
    }
    for (const row of list) {
      if (isEe && !str(row.ORIGIN_DIVISION_ID)) {
        void setAlert({ type: 'alert', content: requiredMsg(t(LBL.DIVISION, '_Origin Div')) });
        return;
      }
      if (!str(row.ITEM_ID)) {
        void setAlert({ type: 'alert', content: requiredMsg(t(LBL.MATERIAL, '_Material')) });
        return;
      }
      if (!str(row.PLANT_SITE_ID)) {
        void setAlert({ type: 'alert', content: requiredMsg(t(LBL.PLANT_SITE, '_Plant Site')) });
        return;
      }
      if (!str(row.LINE_ID)) {
        void setAlert({ type: 'alert', content: requiredMsg(t(LBL.LINE, '_Line')) });
        return;
      }
    }
    // AS-IS checkValidN0(cs:1402) — Item Type(P/H) 체크 + 신규행끼리 중복 체크(newCheck 前).
    for (let i = 0; i < list.length; i++) {
      const row = list[i];
      const itemType = str(row.ITEM_TYPE);
      // AS-IS: !(P||H) 가 빈값(Z/미확장)도 먼저 잡는다 → 빈값도 이 메시지(MSG00254 미확장은 死코드).
      if (itemType !== 'P' && itemType !== 'H') {
        void setAlert({
          type: 'alert',
          content: t(MSG.ITEM_TYPE_PH, '_Item Type must be Product (P) or Semi-Product (H).'),
        });
        return;
      }
      for (let j = 0; j < list.length; j++) {
        if (i === j) continue;
        const other = list[j];
        if (
          str(row.PLANT_SITE_ID) === str(other.PLANT_SITE_ID) &&
          str(row.LINE_ID) === str(other.LINE_ID) &&
          str(row.ITEM_ID) === str(other.ITEM_ID)
        ) {
          void setAlert({
            type: 'alert',
            content: t(
              MSG.DUP_NEW_INPUT,
              '_There is duplicated data among new input data.\n{0}'
            ).replace('{0}', `${str(row.PLANT_SITE_ID)}/${str(row.LINE_ID)}/${str(row.ITEM_ID)}`),
          });
          return;
        }
      }
    }
    setSaving(true);
    try {
      for (const row of list) {
        if (MOCK_MAIN_ENABLED) continue;
        const common = {
          divisionId: params.divisionId,
          planDate: params.planStartYyyymmdd,
          planType: params.planType,
          seq: params.planSeq,
          itemId: str(row.ITEM_ID),
          lineId: str(row.LINE_ID),
          operationGroup: params.operationGroupId,
          scmSiteId: str(row.PLANT_SITE_ID),
          originDivisionId: str(row.ORIGIN_DIVISION_ID),
        };
        const checkRes = await apiClient.callProc<MENU_ID, SHEETS.NEW_CHECK>(
          MENU_ID,
          SHEETS.NEW_CHECK,
          'SEARCH',
          common
        );
        if (Number(checkRes.code)) {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
          return;
        }
        const checkRow = ((checkRes.result as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [])[0];
        // 주의: 반드시 컬럼명으로 읽는다. SP 는 SELECT 'L' AS RESULT_CODE, V_MSG AS MSG 순이지만
        //   BE JSON 직렬화는 컬럼을 알파벳순(MSG → RESULT_CODE)으로 돌려줘 Object.values()[0] 는 MSG 가 된다
        //   → status 에 detail 문자열이 들어가 L/T 판정이 모두 깨지고 generic 'Failed to save' 로 샜다
        //   (테스터 신고 2026-11-18, newCheck 응답 실측으로 확정).
        const status = str(checkRow?.RESULT_CODE);
        const detail =
          str(checkRow?.MSG) || `${str(row.PLANT_SITE_ID)}/${str(row.LINE_ID)}/${str(row.ITEM_ID)}`;
        if (status !== 'S') {
          const content =
            status === 'L'
              ? t('MSG01271', '_Production plan already registered.\n{0}').replace('{0}', detail)
              : status === 'T'
                ? t('MSG01272', '_Tact Time is not registered.\n{0}').replace('{0}', detail)
                : t(MSG.SAVE_FAIL, '_Failed to save.');
          void setAlert({ type: 'alert', content });
          return;
        }
        const saveRes = await apiClient.callProc<MENU_ID, SHEETS.SAVE_POPUP>(
          MENU_ID,
          SHEETS.SAVE_POPUP,
          'SAVE',
          common
        );
        // SP 가 예외를 자체 EXCEPTION 블록에서 삼켜 RESULT_CODE='F' + envelope code='0' 로 돌려줄 수 있어
        //   (저장 0건 false success 위험 [[scp0013-save-false-success-defect]]), envelope code 와 함께
        //   RESULT_CODE='S' 를 확인한다. 컬럼명으로 읽는다(위 newCheck 와 동일 직렬화 순서 문제 회피).
        const saveRow = ((saveRes.result as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [])[0];
        if (Number(saveRes.code) || str(saveRow?.RESULT_CODE) !== 'S') {
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
          return;
        }
      }
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      onSaved();
      modalClose();
    } catch {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      size={980}
      height={440}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Production Plan Insert</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrap}>
          <div className={styles.toolbar}>
            <Button appearance='outlined' priority='normal' size='small' buttonLabel='＋ Insert' onClick={handleInsert} />
            <Button
              appearance='outlined'
              priority='normal'
              size='small'
              buttonLabel='－ Delete'
              disabled={rows.length === 0}
              onClick={handleDelete}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='small'
              buttonLabel={t(LBL.OK, '_Save')}
              disabled={saving || rows.length === 0}
              onClick={() => void handleSave()}
            />
            <Button appearance='outlined' priority='normal' size='small' buttonLabel={t(LBL.CLOSE, '_Cancel')} onClick={modalClose} />
          </div>

          <div className={styles.gridWrap}>
            <DataGrid<InsertRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={editTrackerRef}
              itemsSource={rows}
              staticColumns={columns}
            />
          </div>
        </div>
      }
    />
  );
};
