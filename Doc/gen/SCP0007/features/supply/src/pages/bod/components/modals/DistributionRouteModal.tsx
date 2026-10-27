// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 팝업 SCP0007_DistributionRoutePopup (SCP0007_DistributionRoutePopup.Designer.cs) → 화면 종속 모달. 공통 lookup(features/master/src/components *Modal)으로 대체 가능하면 매핑표 §POPUP 에 명시하고 이 파일을 삭제
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../../bod.constants';

import styles from './DistributionRouteModal.module.scss';

interface DistributionRouteModalProps {
  open: boolean;
  modalClose: () => void;
  /** 선택 결과를 부모에 돌려준다 — As-is 팝업 반환값(DialogResult/Tag) 1:1. TODO(이식): 반환 타입을 As-is 로 맞출 것 */
  onSelect?: (rows: Record<string, unknown>[]) => void;
  /** 부모 조회조건(As-is 팝업 생성자 인자) */
  preSearchParams?: Record<string, string>;
  /** 팝업 그리드 컬럼 — 메타(SCM_MST_SHEET_COLUMNS SHEET_NAME='SCP0007_DistributionRoutePopup') 를 부모 store 가 내려준다 */
  staticColumns?: RawFlexGridColumnConfig[];
}

// AS-IS 컨트롤 28: usrLayoutControl1(UsrLayoutControl), layoutControlGroup1(LayoutControlGroup), usrConditionPanel1(UsrConditionPanel), usrLayoutControl2(UsrLayoutControl), btnToSrch(UsrButton), txtToCity(UsrMultiLineEditor), btnFromSrch(UsrButton), txtToCountry(UsrMultiLineEditor), txtFromCity(UsrMultiLineEditor), txtFromCountry(UsrMultiLineEditor), btnButtonList(UsrButtonList), clbTransMode(UsrCheckedList) …
// AS-IS 이벤트 7: btnToSrch.Click, btnFromSrch.Click, btnButtonList.UsrButtonList_Click_Detected, this.Load, spdMain.CellDoubleClick, dsdm.Changed, dsdm.Changed
// AS-IS SP 1: SCP0005_GET_DISTRIBUTION_ROUTE — 등록 3-키는 register.json / <ID>_registration.sql 참조
export const DistributionRouteModal = ({ open, modalClose, onSelect, preSearchParams, staticColumns = [] }: DistributionRouteModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [filters, setFilters] = useState<Record<string, string> | undefined>(undefined);
  const [toCity, setToCity] = useState(''); // AS-IS txtToCity (UsrMultiLineEditor)
  const [toCountry, setToCountry] = useState(''); // AS-IS txtToCountry (UsrMultiLineEditor)
  const [fromCity, setFromCity] = useState(''); // AS-IS txtFromCity (UsrMultiLineEditor)
  const [fromCountry, setFromCountry] = useState(''); // AS-IS txtFromCountry (UsrMultiLineEditor)
  const [transMode, setTransMode] = useState(''); // AS-IS clbTransMode (UsrCheckedList)

  // AS-IS 팝업 조회 SP: SCP0005_GET_DISTRIBUTION_ROUTE — 시트 'popup'
  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: 'SCP0007-DistributionRouteModal',
    filters,
    enabled: open && filters !== undefined,
  });

  const handleSearch = () => {
    // TODO(이식): As-is 팝업 조회 파라미터 — 생성자 인자(preSearchParams) + 입력값
    setFilters({ ...(preSearchParams ?? {}), toCity, toCountry, fromCity, fromCountry, transMode });
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
  //   btnToSrch.Click → btnToSrch_Click (SCP0007_DistributionRoutePopup.Designer.cs:168)
  //   btnFromSrch.Click → btnFromSrch_Click (SCP0007_DistributionRoutePopup.Designer.cs:238)
  //   btnButtonList.UsrButtonList_Click_Detected → btnButtonList_UsrButtonList_Click_Detected (SCP0007_DistributionRoutePopup.Designer.cs:394)
  //   this.Load → Form_Load (SCP0007_DistributionRoutePopup.cs:149)
  //   spdMain.CellDoubleClick → spdMain_CellDoubleClick (SCP0007_DistributionRoutePopup.cs:201)
  //   dsdm.Changed → spdMainDataModel_Changed (SCP0007_DistributionRoutePopup.cs:203)
  //   dsdm.Changed → spdMainDataModel_Changed (SCP0007_DistributionRoutePopup.cs:521)

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
          <h2 className='headerTitle'>{t('LBL?????', '_Distribution Route Popup')}</h2>
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
                  {/* AS-IS txtToCity / UsrMultiLineEditor */}
                  <FormItem label={t('LBL?????', '_To City')} labelAlign='right' render={() => <InputField fullWidth value={toCity} onChange={event => setToCity(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtToCountry / UsrMultiLineEditor */}
                  <FormItem label={t('LBL?????', '_To Country')} labelAlign='right' render={() => <InputField fullWidth value={toCountry} onChange={event => setToCountry(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtFromCity / UsrMultiLineEditor */}
                  <FormItem label={t('LBL?????', '_From City')} labelAlign='right' render={() => <InputField fullWidth value={fromCity} onChange={event => setFromCity(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS txtFromCountry / UsrMultiLineEditor */}
                  <FormItem label={t('LBL?????', '_From Country')} labelAlign='right' render={() => <InputField fullWidth value={fromCountry} onChange={event => setFromCountry(event.target.value)} />} />
                </Grid>
                <Grid size={4}>
                  {/* AS-IS clbTransMode / UsrCheckedList */}
                  <FormItem label={t('LBL?????', '_Trans Mode')} labelAlign='right' render={() => <InputField fullWidth value={transMode} onChange={event => setTransMode(event.target.value)} />} />
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
            {/* AS-IS btnToSrch */}
            {/* AS-IS btnFromSrch */}
            {/* AS-IS btnButtonList */}
            <Button appearance='contained' priority='primary' buttonLabel={t('LBL00013', '_Confirm')} onClick={handleSubmit} />
            <Button appearance='outlined' priority='normal' buttonLabel={t('LBL00012', '_Cancel')} onClick={modalClose} />
          </div>
        </>
      }
    />
  );
};
