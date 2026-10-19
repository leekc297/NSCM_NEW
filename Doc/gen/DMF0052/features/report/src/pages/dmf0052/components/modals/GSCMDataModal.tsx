// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 팝업 DMF0052_GSCMDataPopup (DMF0052_GSCMDataPopup.Designer.cs) → 화면 종속 모달. 공통 lookup(features/master/src/components *Modal)으로 대체 가능하면 매핑표 §POPUP 에 명시하고 이 파일을 삭제
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';

import { MENU_ID, SHEETS } from '../../dmf0052.constants';

import styles from './GSCMDataModal.module.scss';

interface GSCMDataModalProps {
  open: boolean;
  modalClose: () => void;
  /** 선택 결과를 부모에 돌려준다 — As-is 팝업 반환값(DialogResult/Tag) 1:1. TODO(이식): 반환 타입을 As-is 로 맞출 것 */
  onSelect?: (rows: Record<string, unknown>[]) => void;
  /** 부모 조회조건(As-is 팝업 생성자 인자) */
  preSearchParams?: Record<string, string>;
  /** 팝업 그리드 컬럼 — 메타(SCM_MST_SHEET_COLUMNS SHEET_NAME='EDI Summary GSCM DATA Popup') 를 부모 store 가 내려준다 */
  staticColumns?: RawFlexGridColumnConfig[];
}

// AS-IS 컨트롤 10: usrLayoutControl1(UsrLayoutControl), layoutControlGroup1(LayoutControlGroup), usrConditionPanel1(UsrConditionPanel), usrLayoutControl2(UsrLayoutControl), btnButtonList(UsrButtonList), layoutControlGroup2(LayoutControlGroup), emptySpaceItem1(EmptySpaceItem), layoutControlItem2(LayoutControlItem), spdMain(FpSpread), spdMain_Sheet1(SheetView)
// AS-IS 이벤트 3: btnButtonList.UsrButtonList_Click_Detected, spdMain.TopChange, this.Load
// AS-IS SP 1: DMF0052_GET_SITE_POPUP — 등록 3-키는 register.json / <ID>_registration.sql 참조
export const GSCMDataModal = ({ open, modalClose, onSelect, preSearchParams, staticColumns = [] }: GSCMDataModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [filters, setFilters] = useState<Record<string, string> | undefined>(undefined);

  // AS-IS 팝업 조회 SP: DMF0052_GET_SITE_POPUP — 시트 'EDI Summary GSCM DATA Popup'
  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP,
    tabId: 'DMF0052-GSCMDataModal',
    filters,
    enabled: open && filters !== undefined,
  });

  const handleSearch = () => {
    // TODO(이식): As-is 팝업 조회 파라미터 — 생성자 인자(preSearchParams) + 입력값
    setFilters({ ...(preSearchParams ?? {}) });
  };
  // As-is 팝업 Load 시 조회 — 열릴 때 1회 (조회조건 입력이 있으면 SearchArea 조회 버튼이 담당)
  useEffect(() => {
    if (open) handleSearch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);
  const handleSubmit = () => {
    // TODO(이식): As-is 선택 반환 — 선택 행(GridUtils.getSelectedRows) → onSelect
    onSelect?.([]);
    modalClose();
  };

  // AS-IS 팝업 이벤트(이식 TODO — DataGrid 이벤트 prop 또는 버튼 onClick 으로 배선):
  //   btnButtonList.UsrButtonList_Click_Detected → btnButtonList_UsrButtonList_Click_Detected (DMF0052_GSCMDataPopup.Designer.cs:183)
  //   spdMain.TopChange → spdMain_TopChange (DMF0052_GSCMDataPopup.Designer.cs:227)
  //   this.Load → Form_Load (DMF0052_GSCMDataPopup.cs:76)

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
          <h2 className='headerTitle'>{t('LBL?????', '_GSCMData Popup')}</h2>
        </div>
      }
      customContentArea={
        <>
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
