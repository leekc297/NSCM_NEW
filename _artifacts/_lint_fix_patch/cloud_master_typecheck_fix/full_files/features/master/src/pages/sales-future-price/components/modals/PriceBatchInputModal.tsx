import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../../components';
import { MENU_ID, SHEETS } from '../../sales-future-price.constants';
import { isPeriodInverted } from '../../utils/futurePriceDate';

import styles from './PriceBatchInputModal.module.scss';

// YYYYMMDD ↔ YYYY-MM-DD (use-before-define 회피 — file 상단 정의)
const toDate = (s: string): string => {
  if (!s) return '';
  if (s.length === 8) return `${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`;
  return s;
};
const fromDate = (s: string): string => s.replace(/-/g, '');

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
  onSaveResult?: () => void;
}

interface PriceBatchRow {
  DIVISION_ID?: string;
  DEPT_ID?: string;
  TEAM_INCHARGE?: string;
  END_CUSTOMER?: string;
  SCM_SITE_ID?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  DOM_EXP?: string;
  CURRENCY?: string;
  PLANT_SITE_ID?: string;
  MEASURE?: string;
  PRICE_ALL?: string | number;
  [key: string]: string | number | undefined;
}

// AS-IS DMF0020_SaveSalesFuturePrice_Popup.cs (2,614줄) + 캡쳐 Doc/ui_cap/DMF0020_Price_batch.png 정밀 매핑
//   SP: P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (17 IN, PKG stub — 현재 priceBatch 의 6 IN SP 사용)
//   Header: Div+Sales Site + Project popup + Model popup + Period (2-row layout)
//   Grid 12 cols: Div / Team / Sales Site / Project Code / Model / Incoterms / FCST Type /
//                 Customs Handbook / Currency / Plant Site / Measure / 일괄입력 Price
//   Cell merge: Div column 같은 값 row (Restricted)
//   Button: Find / Edit / Save / Excel / Close
export const PriceBatchInputModal = ({
  open, modalClose, defaultDivision, defaultPeriod, onSaveResult,
}: Props) => {
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<PriceBatchRow> | null>(null);

  const [divisionId, setDivisionId] = useState(defaultDivision);
  const [salesSite, setSalesSite] = useState('ALL');
  const [projectCode, setProjectCode] = useState('');
  const [itemId, setItemId] = useState('');
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);
  const [editMode, setEditMode] = useState(false);

  // popup state
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultPeriod.start);
      setPeriodTo(defaultPeriod.end);
      setEditMode(false);
    }
  }, [open, defaultDivision, defaultPeriod]);

  // ===== Combo dropdown — Div / Sales Site / Team / Incoterms / FCST / Customs Handbook / Currency =====
  const [divQ, ssQ, teamQ, incoQ, currQ, fcstQ, customsQ] = useTabComboQueries({
    filters: [
      'MyDivision',
      { comboId: 'SiteByEndCustomer', divisionId },
      { comboId: 'TeambyDivision', divisionId },
      'Incoterms',
      'CurrencyList',
      { comboId: 'FcstType', divisionId },
      { comboId: 'CustomsHandbook', divisionId },
    ],
  });
  type ComboItem = { CODE?: string; NAME?: string };
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (q: ComboItem[] | undefined): DataMap | null => {
      const arr = q ?? [];
      if (arr.length === 0) return null;
      return new DataMap(arr, 'CODE', 'NAME');
    };
    return {
      DIVISION_ID: make(divQ as never),
      SCM_SITE_ID: make(ssQ as never),
      DEPT_ID: make(teamQ as never),
      INCOTERMS: make(incoQ as never),
      CURRENCY: make(currQ as never),
      FCST_TYPE: make(fcstQ as never),
      DOM_EXP: make(customsQ as never),
    };
  }, [divQ, ssQ, teamQ, incoQ, currQ, fcstQ, customsQ]);

  const divItems = (divQ ?? []) as ComboItem[];
  const ssItems = (ssQ ?? []) as ComboItem[];

  // ===== SP — sheet 'priceBatch' (2026-06-03 v2 fix: P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 17 IN) =====
  //   이전 SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP 는 환율 데이터 반환 → 메인 SP 로 변경
  const filters = useMemo(
    () => ({
      divisionId,
      deptId:       'ALL',
      endCustomer:  'ALL',
      scmSiteId:    salesSite || 'ALL',
      plantSiteId:  'ALL',
      projectCode:  projectCode || 'ALL',
      itemId:       itemId || 'ALL',
      fromYyyymmdd: periodFrom,
      toYyyymmdd:   periodTo,
      biztype:      'ALL',
      owner:        'ALL',
      overRange:    'N',
      invalidExec:  'N',
      versionType:  'CURRENT',
      bucketType:   'M',
    } as never),
    [divisionId, periodFrom, periodTo, salesSite, projectCode, itemId],
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.PRICE_BATCH,
    tabId: MENU_ID,
    filters,
    enabled: false,
  });

  const allRows = (data?.o_rc1 ?? []) as unknown as PriceBatchRow[];
  // 추가 client-side filter (사용자 명시 검색조건)
  const rows = useMemo(() => allRows.filter(r => {
    if (salesSite && salesSite !== 'ALL' && String(r.SCM_SITE_ID ?? '') !== salesSite) return false;
    if (projectCode && !String(r.PROJECT_CODE ?? '').includes(projectCode)) return false;
    if (itemId && !String(r.ITEM_ID ?? '').includes(itemId)) return false;
    return true;
  }), [allRows, salesSite, projectCode, itemId]);

  const loading = isLoading || isFetching;

  // ===== Button handlers =====
  const handleFind = () => {
    if (isPeriodInverted(periodFrom, periodTo)) {
      void setAlert({ type: 'alert', content: '[MSG00108] Period 가 역전되었습니다.' });
      return;
    }
    if (!divisionId) {
      void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' });
      return;
    }
    refetch?.();
    setEditMode(false);
  };

  // AS-IS L815 EditButton — 필수 컬럼 체크 + SwitchLock
  const handleEdit = () => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: '[MSG00113] 조회 후 편집하세요.' });
      return;
    }
    setEditMode(true);
    void setToast({ message: '편집 모드 활성화 (Price 컬럼만 수정 가능)', type: 'default', duration: 2000 });
  };

  const handleSave = async () => {
    if (!editMode) {
      void setAlert({ type: 'alert', content: '[MSG00099] 편집 모드에서만 저장 가능합니다.' });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: '[MSG00004] 저장하시겠습니까?' });
    if (!ok) return;
    void setToast({ message: 'Save SP 후속 phase — P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP 16 IN ^join', type: 'warning', duration: 4000 });
    onSaveResult?.();
  };

  const handleExcel = () => {
    if (!gridRef.current) return;
    void setToast({ message: 'Excel 다운로드는 SubTitle 의 Excel 버튼 패턴 (후속 phase)', type: 'default', duration: 2000 });
  };

  return (
    <>
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1400}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 12, height: 12, background: '#1976d2', borderRadius: '50%' }} />
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>Price 일괄입력</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container}>
          {/* Row 1 — Div / Sales Site / 버튼 5종 (AS-IS 캡쳐) */}
          <div className={styles.filterRow}>
            <label className={styles.field}>Div
              <select value={divisionId} onChange={e => setDivisionId(e.target.value)}>
                {divItems.map(i => (
                  <option key={i.CODE} value={i.CODE}>{i.NAME ?? i.CODE}</option>
                ))}
              </select>
            </label>
            <label className={styles.field}>Sales Site
              <select value={salesSite} onChange={e => setSalesSite(e.target.value)}>
                <option value='ALL'>ALL</option>
                {ssItems.map(i => (
                  <option key={i.CODE} value={i.CODE}>{i.NAME ?? i.CODE}</option>
                ))}
              </select>
            </label>
            <button type='button' onClick={handleFind} className={styles.findBtn} disabled={loading}>
              {loading ? '⏳' : '🔍'} Find
            </button>
            <button type='button' onClick={handleEdit} className={styles.editBtn} disabled={loading || rows.length === 0}>
              ✏️ Edit
            </button>
            <button type='button' onClick={handleSave} className={styles.saveBtn} disabled={!editMode}>
              💾 Save
            </button>
            <button type='button' onClick={handleExcel} className={styles.excelBtn}>
              📗 Excel
            </button>
            <button type='button' onClick={modalClose} className={styles.closeBtn}>
              ❌ Close
            </button>
          </div>

          {/* Row 2 — Project popup / Model popup / Period (AS-IS 캡쳐) */}
          <div className={styles.filterRow}>
            <label className={styles.field}>Project
              <input type='text' value={projectCode} onChange={e => setProjectCode(e.target.value)} placeholder='' />
              <button type='button' onClick={() => setOpenProject(true)} className={styles.iconBtn}>🔍</button>
            </label>
            <label className={styles.field}>Model
              <input type='text' value={itemId} onChange={e => setItemId(e.target.value)} placeholder='' />
              <button type='button' onClick={() => setOpenItem(true)} className={styles.iconBtn}>🔍</button>
            </label>
            <label className={styles.field}>Period
              <input type='date' value={toDate(periodFrom)} onChange={e => setPeriodFrom(fromDate(e.target.value))} />
            </label>
            <span>~</span>
            <label className={styles.field}>
              <input type='date' value={toDate(periodTo)} onChange={e => setPeriodTo(fromDate(e.target.value))} />
            </label>
            <span className={styles.hint}>
              {loading ? '데이터 조회 중' : `${rows.length} rows${editMode ? ' (편집 모드)' : ''}`}
            </span>
          </div>

          {/* Grid — 12 cols (AS-IS 캡쳐, Div cell merge) */}
          <div className={styles.gridWrap}>
            <FlexGrid
              initialized={(g: FlexGridType<PriceBatchRow>) => {
                gridRef.current = g;
                // DataMap 적용
                for (let i = 0; i < g.columns.length; i++) {
                  const col = g.columns[i];
                  const binding = col.binding ?? '';
                  const dm = dataMaps[binding];
                  if (dm) col.dataMap = dm;
                  col.allowMerging = true;
                }
                // Div column cell merge (AS-IS Restricted)
                g.allowMerging = AllowMerging.Cells;
                class DivMerge extends MergeManager {
                  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
                    if (panel.cellType !== CellType.Cell) return null;
                    const col = panel.columns[c];
                    if (col?.binding !== 'DIVISION_ID') return null;
                    const view = panel.rows;
                    const ri = (i: number): PriceBatchRow | undefined =>
                      (view[i] as unknown as { dataItem?: PriceBatchRow })?.dataItem;
                    const cur = ri(r);
                    if (!cur) return null;
                    const sameRow = (a: number, b: number): boolean => {
                      const ra = ri(a); const rb = ri(b);
                      return !!ra && !!rb && ra.DIVISION_ID === rb.DIVISION_ID;
                    };
                    let r1 = r, r2 = r;
                    while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
                    while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
                    if (r1 === r2) return null;
                    return new CellRange(r1, c, r2, c);
                  }
                }
                g.mergeManager = new DivMerge();
              }}
              itemsSource={rows}
              autoGenerateColumns={false}
              style={{ height: '100%' }}
              frozenColumns={11}
              allowSorting={true}
            >
              {/* AS-IS 캡쳐 12 cols (Div* / Team / Sales Site* / Project Code* / Model* / Incoterms* / FCST Type* / Customs Handbook / Currency* / Plant Site* / Measure* / 일괄입력 Price) */}
              <FlexGridColumn binding='DIVISION_ID'  header='Div*'              width={50}  align='center' isReadOnly />
              <FlexGridColumn binding='DEPT_ID'      header='Team'              width={100} align='left' isReadOnly />
              <FlexGridColumn binding='SCM_SITE_ID'  header='Sales Site*'       width={140} align='left' isReadOnly />
              <FlexGridColumn binding='PROJECT_CODE' header='Project Code*'     width={120} align='left' isReadOnly />
              <FlexGridColumn binding='ITEM_ID'      header='Model*'            width={150} align='left' isReadOnly />
              <FlexGridColumn binding='INCOTERMS'    header='Incoterms*'        width={80}  align='center' isReadOnly />
              <FlexGridColumn binding='FCST_TYPE'    header='FCST Type*'        width={100} align='center' isReadOnly />
              <FlexGridColumn binding='DOM_EXP'      header='Customs Handbook'  width={110} align='center' isReadOnly />
              <FlexGridColumn binding='CURRENCY'     header='Currency*'         width={80}  align='center' isReadOnly />
              <FlexGridColumn binding='PLANT_SITE_ID' header='Plant Site*'      width={90}  align='left' isReadOnly />
              <FlexGridColumn binding='MEASURE'      header='Measure*'          width={80}  align='center' isReadOnly />
              <FlexGridColumn binding='PRICE_ALL'    header='일괄입력 Price'    width={130} align='right' format='n4' isReadOnly={!editMode} />
            </FlexGrid>
          </div>
        </div>
      }
    />

    {/* Project popup */}
    <ProjectByDivisionModal
      open={openProject}
      modalClose={() => setOpenProject(false)}
      setSelectedValue={(code) => { setProjectCode(code ?? ''); }}
      preSearchParams={{
        divisionId,
        deptId: 'ALL',
        endCustomer: 'ALL',
        salesSite: salesSite || 'ALL',
        projectCode: '',
        etc: 'N',
      } as never}
      callFromCell={true}
    />

    {/* Item popup */}
    <ItemByDivisionModal
      open={openItem}
      modalClose={() => setOpenItem(false)}
      setSelectedValue={(id) => { setItemId(id ?? ''); }}
      preSearchParams={{
        divisionId,
        deptId: 'ALL',
        endCustomer: 'ALL',
        salesSite: salesSite || 'ALL',
        projectCode: projectCode || '',
        itemId: '',
      } as never}
      callFromCell={true}
    />
    </>
  );
};

