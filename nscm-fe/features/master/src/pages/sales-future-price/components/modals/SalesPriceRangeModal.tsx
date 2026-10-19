import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { attachRowNoHeader, GridAction } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon, FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './SalesPriceRangeModal.module.scss';

// AS-IS DMF0020_SalesPriceRangePopUp (Title 'Range Rate', 907×324 — 분석서 v6.5)
//   저장 후 SAVE SP(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL) 의 O_RC1 이 반환하는
//   "입력 Price 가 주변 주차 대비 Range Rate(LOOKUP SALES_PRICE_RANGE_RATE 배율) 초과" 리스트를 표시.
//   AS-IS SaveData L1939: ds.Tables[2].Rows.Count > 0 → popup.LoadData(ds.Tables[2]) → ShowDialog.
//   표준: CustomDialog + 표준 header + gridWrapper(DataGrid, CH_PRICE 만 편집가능) + buttonWrapper(Close/Save).
//   커서 컬럼(SP W_RETURN): V_ROWNUM / END_CUSTOMER / PROJECT_CODE / SCM_SITE_ID / ITEM_ID / INCOTERMS /
//   FCST_TYPE / CURRENCY / DIVISION_ID / PLANT_SITE_ID / MEASURE / DOM_EXP /
//   CH_YYYYMMDD·CH_PRICE(입력) / ST_YYYYMMDD·ST_PRICE(기준 인접 주차).
// No.25 (2026-08-04) — "선택하고 저장할 수 없음": 목록 확인 후 필요하면 CH_PRICE 를 바로 고쳐
//   선택한 행만 재저장할 수 있어야 한다. 행 하나하나가 이미 완결된 (키+주차+measure) 레코드이므로
//   추가 변환 없이 activeFlag='M'(가격 0 이면 'D')으로 그대로 보낸다.
// 저장 SP 는 메인(_ALL)이 아니라 팝업 전용 DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP
//   (AS-IS .cs L432 FoxDataRequest 동일). 이 SP 는 메타에 DMF0020_priceBatch_SAVE 로 등록돼 있어
//   호출 경로가 sheet 'priceBatch' 다 — 이름은 Price Batch 지만 SP 기준으로 이 팝업의 저장과 같다.
//   차이: 메인 _ALL 은 p_ROWNUM 을 받아 Range Rate 초과분(O_RC1)을 다시 만들어 돌려주지만
//   (AS-IS 메인 .cs L1855 주석 [PJ20200138] '20% 초과되어 입력되는 데이터 보여줌'),
//   팝업 SP 는 그 파라미터가 없다 — 사용자가 초과를 이미 확인하고 저장하는 자리라 재검사하지 않는다.
//   그래서 payload 도 rownumKey 를 빼고 16-key 로 보낸다.
export interface SalesPriceRangeRow {
  V_ROWNUM?: number | string;
  END_CUSTOMER?: string;
  PROJECT_CODE?: string;
  SCM_SITE_ID?: string;
  ITEM_ID?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  CURRENCY?: string;
  DIVISION_ID?: string;
  PLANT_SITE_ID?: string;
  MEASURE?: string;
  DOM_EXP?: string;
  CH_YYYYMMDD?: string;
  CH_PRICE?: number | string;
  ST_YYYYMMDD?: string;
  ST_PRICE?: number | string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  rows: SalesPriceRangeRow[];
  /** 저장 성공 후 부모 재조회 — AS-IS 메인 .cs L1943 popup.ShowDialog() 반환 직후 FindData() 동등. */
  onSaved?: () => void;
}

// 2단 헤더 — AS-IS DMF0020_SalesPriceRangePopUp 1:1 (입력값 / 비교값 그룹 아래 YYYYMMDD · Price).
//   sClsLblNm 이 있으면 공용 mapRawColumnsToWijmoColumns 가 TWO_DEPTH 로 판정해 그룹 헤더를 만든다
//   (columnMapping.ts COLUMN_DEPTH.TWO_DEPTH). 그룹이 없는 좌측 컬럼은 sClsLblNm 미지정 →
//   그룹 라벨이 colLblNm 과 같아져 CustomMergeManager 가 헤더 2행을 세로 병합(AS-IS 동일 형태).
const RANGE_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div.', colWth: 60, horzAlgnCd: 'C' },
  { colNm: 'END_CUSTOMER', colLblNm: 'End Customer', colWth: 120 },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code', colWth: 110 },
  { colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site', colWth: 140 },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 150 },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 90, horzAlgnCd: 'C' },
  { colNm: 'DOM_EXP', colLblNm: 'Customs Handbook', colWth: 110, horzAlgnCd: 'C' },
  { colNm: 'CURRENCY', colLblNm: 'Currency', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'CH_YYYYMMDD', colLblNm: 'YYYYMMDD', sClsLblNm: '입력값', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'CH_PRICE', colLblNm: 'Price', sClsLblNm: '입력값', colWth: 110, horzAlgnCd: 'R' },
  { colNm: 'ST_YYYYMMDD', colLblNm: 'YYYYMMDD', sClsLblNm: '비교값', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'ST_PRICE', colLblNm: 'Price', sClsLblNm: '비교값', colWth: 110, horzAlgnCd: 'R' },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  // No.25 — 입력값 Price(CH_PRICE) 만 그 자리에서 수정 가능. 나머지는 조회 전용 유지.
  inputTpCd:
    c.colNm === 'CH_PRICE' ? CELL_INPUT_EDIT_TYPE.OPTIONAL : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const SalesPriceRangeModal = ({ open, modalClose, rows, onSaved }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const gridRef = useRef<FlexGridType<SalesPriceRangeRow> | null>(null);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  // No.25 — CH_PRICE 수정을 위한 로컬 작업본(부모 rows 는 SAVE 응답을 그대로 보관).
  //   저장에 성공하면 AS-IS 와 동일하게 팝업을 닫으므로 이 작업본은 다음 open 때 새로 채워진다.
  const [localRows, setLocalRows] = useState<SalesPriceRangeRow[]>([]);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (open) setLocalRows(rows);
  }, [open, rows]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, localRows]);

  // CH_PRICE 만 편집가능(Yellow) 표시 — 나머지 컬럼은 기본색 유지(형제 PriceBatchInputModal PRICE_ALL 과 동일 규칙).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const editable = binding === 'CH_PRICE';
      toggleClass(e.cell, 'wj-cell-editable', editable);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [localRows]);

  // 선택한 행만 재저장 — 팝업 전용 SAVE(sheet 'priceBatch' = _POPUP SP) 16-key payload.
  const handleSave = async () => {
    const g = gridRef.current;
    const selected = (g?.selectedItems ?? []) as SalesPriceRangeRow[];
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_저장할 행을 선택하세요.') });
      return;
    }

    const userId = sessionUserId ?? '';
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const acc: Record<string, string[]> = {
      activeFlag: [],
      divisionId: [],
      projectCode: [],
      scmSiteId: [],
      plantSiteId: [],
      itemId: [],
      yyyymmdd: [],
      currency: [],
      measure: [],
      domExp: [],
      fcstType: [],
      incoterms: [],
      price: [],
      createdByList: [],
      creationDate: [],
      lastUpdatedByList: [],
    };
    for (const r of selected) {
      const price =
        String(r.CH_PRICE ?? '')
          .replace(/,/g, '')
          .trim() || '0';
      acc.activeFlag.push(price === '0' ? 'D' : 'M');
      acc.divisionId.push(String(r.DIVISION_ID ?? ''));
      acc.projectCode.push(String(r.PROJECT_CODE ?? ''));
      acc.scmSiteId.push(String(r.SCM_SITE_ID ?? ''));
      // PLANT_SITE_ID 는 값 그대로 전송 — 메인 화면 handleSave(pushEntry) 와 동일(AS-IS 는 빈값을
      //   '-' 로 치환하지 않는다, .cs:1584/1598).
      acc.plantSiteId.push(String(r.PLANT_SITE_ID ?? ''));
      acc.itemId.push(String(r.ITEM_ID ?? ''));
      acc.yyyymmdd.push(String(r.CH_YYYYMMDD ?? ''));
      acc.currency.push(String(r.CURRENCY ?? ''));
      acc.measure.push(String(r.MEASURE ?? ''));
      acc.domExp.push(String(r.DOM_EXP ?? ''));
      acc.fcstType.push(String(r.FCST_TYPE ?? ''));
      acc.incoterms.push(String(r.INCOTERMS ?? ''));
      acc.price.push(price);
      acc.createdByList.push(userId);
      acc.creationDate.push(today);
      acc.lastUpdatedByList.push(userId);
    }
    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    setSaving(true);
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.PRICE_BATCH}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      // AS-IS 팝업 SaveData L459-463 — 저장 메시지 후 팝업 Close. 부모는 ShowDialog 반환 직후
      //   FindData() 로 재조회하므로(메인 .cs L1949) onSaved 로 동일하게 트리거한다.
      void setToast({ message: t('MSG00606', '_저장되었습니다.'), type: 'success' });
      modalClose();
      onSaved?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setSaving(false);
    }
  };

  // Excel Download — 공용 GridAction.excelDownload (backcolor 제외 + 숨김 컬럼 제외 표준).
  //   depth>1 경로가 입력값/비교값 2단 헤더를 그대로 유지해 내려준다(gridAction headerDepth 분기).
  const handleExcel = async () => {
    const g = gridRef.current;
    if (!g) return;
    if (localRows.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00667', 'No data to save.') });
      return;
    }
    await GridAction.excelDownload(g as never, 'Range Rate');
  };

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Range Rate</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 안내 — AS-IS Designer simpleLabelItem1.Text '허용범위를 벗어나는 Sales Price' 그대로.
              입력가가 인접 주차 기준가 대비 허용 배율(Range Rate) 초과 목록이라는 뜻(저장은 완료된 상태).
              금지: t('MSG00619') 재사용 — 이 코드는 admin message DB 에 '승인할 항목을 선택해 주십시오.'
              로 이미 등록돼 있어(auth-approval 사용) 화면에 엉뚱한 문구가 떴다. AS-IS 도 DB 메시지가
              아니라 폼 고정 라벨이므로 헤더 타이틀('Range Rate')·컬럼명과 같이 리터럴로 둔다. */}
          <div className={styles.notice}>허용범위를 벗어나는 Sales Price</div>

          {/* Grid — SAVE SP O_RC1 초과 리스트. 입력값 Price(CH_PRICE) 만 편집 가능, 나머지는 조회 전용. */}
          <div className={styles.gridWrapper}>
            <ResultArea
              title=''
              count={localRows.length}
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                itemsSource={localRows as unknown as WijmoRowItem[]}
                staticColumns={RANGE_COLUMNS}
                autoGenerateColumns={false}
                className={styles.grid}
              />
            </ResultArea>
          </div>

          {/* Action — 표준 buttonWrapper */}
          <div className={styles.buttonWrapper}>
            {/* Excel — 공용 GridAction.excelDownload 사용. 버튼 순서는 Excel 다음 Save, Close 가 마지막. */}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              iconComponent={<FileExceldownloadIcon />}
              disabled={localRows.length === 0}
              onClick={handleExcel}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00111', 'Save')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={saving || localRows.length === 0}
              onClick={handleSave}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
