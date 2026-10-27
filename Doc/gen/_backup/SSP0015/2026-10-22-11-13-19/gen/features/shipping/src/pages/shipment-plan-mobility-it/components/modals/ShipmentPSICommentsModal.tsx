// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 팝업 SSP0015_ShipmentPSICommentsPopup (SSP0015_ShipmentPSICommentsPopup.Designer.cs) → 화면 종속 모달. 공통 lookup(features/master/src/components *Modal)으로 대체 가능하면 매핑표 §POPUP 에 명시하고 이 파일을 삭제
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../../shipment-plan-mobility-it.constants';

import styles from './ShipmentPSICommentsModal.module.scss';

interface ShipmentPSICommentsModalProps {
  open: boolean;
  modalClose: () => void;
  /** 선택 결과를 부모에 돌려준다 — As-is 팝업 반환값(DialogResult/Tag) 1:1. TODO(이식): 반환 타입을 As-is 로 맞출 것 */
  onSelect?: (rows: Record<string, unknown>[]) => void;
  /** 부모 조회조건(As-is 팝업 생성자 인자) */
  preSearchParams?: Record<string, string>;
  /** 팝업 그리드 컬럼 — 메타(SCM_MST_SHEET_COLUMNS SHEET_NAME='SSP0015_ShipmentPSICommentsPopup') 를 부모 store 가 내려준다 */
  staticColumns?: RawFlexGridColumnConfig[];
}

// AS-IS 컨트롤 40: usrLayoutControl1(UsrLayoutControl), layoutControlGroup1(LayoutControlGroup), usrConditionPanel1(UsrConditionPanel), usrLayoutControl2(UsrLayoutControl), txtGap_Qty(UsrTextBox), txtBefore_Qty(UsrTextBox), txtProd_Qty(UsrTextBox), txtWHin_Qty(UsrTextBox), txtMeasure(UsrTextBox), txtFrom_Site(UsrTextBox), txtDivision_ID(UsrTextBox), rtxComments(RichTextBox) …
// AS-IS 이벤트 9: txtGap_Qty.TextChanged, txtBefore_Qty.TextChanged, txtProd_Qty.TextChanged, txtWHin_Qty.TextChanged, txtCurrent_Qty.TextChanged, txtChange_Qty.TextChanged, txtChange_Qty.KeyPress, btnButtonList.UsrButtonList_Click_Detected
// AS-IS SP 1: SSP0015_SAVE_SHIPMENT_PSI_COMMENTS — 등록 3-키는 register.json / <ID>_registration.sql 참조
export const ShipmentPSICommentsModal = ({ open, modalClose, onSelect, preSearchParams, staticColumns = [] }: ShipmentPSICommentsModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [filters, setFilters] = useState<Record<string, string> | undefined>(undefined);
  const [gap_Qty, setGap_Qty] = useState(''); // AS-IS txtGap_Qty (UsrTextBox)
  const [before_Qty, setBefore_Qty] = useState(''); // AS-IS txtBefore_Qty (UsrTextBox)
  const [prod_Qty, setProd_Qty] = useState(''); // AS-IS txtProd_Qty (UsrTextBox)
  const [wHin_Qty, setWHin_Qty] = useState(''); // AS-IS txtWHin_Qty (UsrTextBox)
  const [measure, setMeasure] = useState(''); // AS-IS txtMeasure (UsrTextBox)
  const [from_Site, setFrom_Site] = useState(''); // AS-IS txtFrom_Site (UsrTextBox)
  const [division_ID, setDivision_ID] = useState(''); // AS-IS txtDivision_ID (UsrTextBox)
  const [rtxComments, setRtxComments] = useState(''); // AS-IS rtxComments (RichTextBox)
  const [current_Qty, setCurrent_Qty] = useState(''); // AS-IS txtCurrent_Qty (UsrTextBox)
  const [change_Qty, setChange_Qty] = useState(''); // AS-IS txtChange_Qty (UsrTextBox)
  const [date, setDate] = useState(''); // AS-IS txtDate (UsrTextBox)
  const [item_ID, setItem_ID] = useState(''); // AS-IS txtItem_ID (UsrTextBox)
  const [plan_Date, setPlan_Date] = useState(''); // AS-IS txtPlan_Date (UsrTextBox)

  // AS-IS 팝업 조회 SP: SSP0015_SAVE_SHIPMENT_PSI_COMMENTS — 시트 'popup'
  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: 'SSP0015-ShipmentPSICommentsModal',
    filters,
    enabled: open && filters !== undefined,
  });

  const handleSearch = () => {
    // TODO(이식): As-is 팝업 조회 파라미터 — 생성자 인자(preSearchParams) + 입력값
    setFilters({ ...(preSearchParams ?? {}), gap_Qty, before_Qty, prod_Qty, wHin_Qty, measure, from_Site, division_ID, rtxComments, current_Qty, change_Qty, date, item_ID, plan_Date });
  };
  // As-is 팝업 Load 시 조회 — 열릴 때 1회 (조회조건 입력이 있으면 SearchArea 조회 버튼이 담당)
  useEffect(() => {
    if (open && false) handleSearch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);
  const handleSubmit = () => {
    // TODO(이식): As-is 선택 반환 — 선택 행(GridUtils.getSelectedRows) → onSelect
    onSelect?.([]);
    modalClose();
  };

  // AS-IS 팝업 이벤트(이식 TODO — DataGrid 이벤트 prop 또는 버튼 onClick 으로 배선):
  //   txtGap_Qty.TextChanged → txtGap_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:192)
  //   txtBefore_Qty.TextChanged → txtBefore_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:227)
  //   txtProd_Qty.TextChanged → txtProd_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:262)
  //   txtWHin_Qty.TextChanged → txtWHin_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:297)
  //   txtCurrent_Qty.TextChanged → txtCurrent_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:474)
  //   txtChange_Qty.TextChanged → txtChange_Qty_TextChanged (SSP0015_ShipmentPSICommentsPopup.Designer.cs:509)
  //   txtChange_Qty.KeyPress → txtChange_Qty_KeyPress (SSP0015_ShipmentPSICommentsPopup.Designer.cs:510)
  //   btnButtonList.UsrButtonList_Click_Detected → btnButtonList_UsrButtonList_Click_Detected (SSP0015_ShipmentPSICommentsPopup.Designer.cs:657)
  //   this.Load → Form_Load (SSP0015_ShipmentPSICommentsPopup.cs:207)

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL?????', '_Shipment PSIComments Popup')}</h2>
        </div>
      }
      customContentArea={
        <>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  {/* AS-IS txtGap_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Gap_Qty')} labelAlign='right' render={() => <InputField fullWidth value={gap_Qty} onChange={event => setGap_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtBefore_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Before_Qty')} labelAlign='right' render={() => <InputField fullWidth value={before_Qty} onChange={event => setBefore_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtProd_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Prod_Qty')} labelAlign='right' render={() => <InputField fullWidth value={prod_Qty} onChange={event => setProd_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtWHin_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_WHin_Qty')} labelAlign='right' render={() => <InputField fullWidth value={wHin_Qty} onChange={event => setWHin_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtMeasure / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Measure')} labelAlign='right' render={() => <InputField fullWidth value={measure} onChange={event => setMeasure(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtFrom_Site / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_From_Site')} labelAlign='right' render={() => <InputField fullWidth value={from_Site} onChange={event => setFrom_Site(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtDivision_ID / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Division_ID')} labelAlign='right' render={() => <InputField fullWidth value={division_ID} onChange={event => setDivision_ID(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS rtxComments / RichTextBox */}
                  <FormItem label={t('LBL?????', '_rtx Comments')} labelAlign='right' render={() => <InputField fullWidth value={rtxComments} onChange={event => setRtxComments(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtCurrent_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Current_Qty')} labelAlign='right' render={() => <InputField fullWidth value={current_Qty} onChange={event => setCurrent_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtChange_Qty / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Change_Qty')} labelAlign='right' render={() => <InputField fullWidth value={change_Qty} onChange={event => setChange_Qty(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtDate / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Date')} labelAlign='right' render={() => <InputField fullWidth value={date} onChange={event => setDate(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtItem_ID / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Item_ID')} labelAlign='right' render={() => <InputField fullWidth value={item_ID} onChange={event => setItem_ID(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtPlan_Date / UsrTextBox */}
                  <FormItem label={t('LBL?????', '_Plan_Date')} labelAlign='right' render={() => <InputField fullWidth value={plan_Date} onChange={event => setPlan_Date(event.target.value)} />} />
                </Grid>
              </>
            }
          />
          <DataGrid
            gridRef={gridRef}
            gridFilterRef={gridFilterRef}
            itemsSource={data?.o_rc ?? []}
            staticColumns={staticColumns}
          />
          <div className={styles.actions}>
            {/* AS-IS btnButtonList */}
            <Button appearance='contained' priority='primary' buttonLabel={t('LBL00013', '_Confirm')} onClick={handleSubmit} />
            <Button appearance='outlined' priority='normal' buttonLabel={t('LBL00012', '_Cancel')} onClick={modalClose} />
          </div>
        </>
      }
    />
  );
};
