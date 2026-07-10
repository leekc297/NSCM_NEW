import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridAction } from '@foundation/utils';
import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS, TEMPLATE_EXCEL_PREFIX } from '../../metal-link-price.constants';
import type { MetalLinkTemplateRow } from '../../metal-link-price.types';
import { MetalLinkPriceGrid } from '../MetalLinkPriceGrid';

import styles from './MetalLinkTemplateModal.module.scss';

// ⭐ AS-IS DMF0074_MetalLinkPricePopup (277줄 — btnTemplate 'Excel Form' .cs L704~713) 1:1:
//   팝업 = 조회 그리드 + Excel Export 가 곧 "템플릿 다운로드" (서버 파일 다운로드 아님).
//   - 진입 시 자동조회 없음 (AS-IS //FindData() 주석 1:1) — Find 버튼으로 조회.
//   - SP = PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE (divisionId 단일 — 부모 division 고정.
//     division-gate 동일 적용 L837: 권한 없는 사업부 = 행 미반환).
//   - 0건 = MSG00656 (이번 주 Sales Plan Waterfall MRF 'Y' 버전 부재 — AS-IS 팝업 L229 구 MSG00427 의도)
//   - Excel = GridAction.excelDownload (measure 열 '-' placeholder 포함 그대로 export)
interface MetalLinkTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  // 부모 화면 조회 division 고정 전달 (AS-IS ctor division 파라미터 1:1)
  divisionId: string;
}

export const MetalLinkTemplateModal = ({
  open,
  modalClose,
  divisionId,
}: MetalLinkTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid<MetalLinkTemplateRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // AS-IS 자동조회 없음 — Find 명시 게이트 (모달 닫으면 초기화)
  const [hasSearched, setHasSearched] = useState(false);
  useEffect(() => {
    if (!open) setHasSearched(false);
  }, [open]);

  // sesUserId/mnuId 는 BE 세션 자동 (division-gate 키 — 보강 전송, DMF0014 선례)
  const filters = useMemo(() => {
    if (!open || !hasSearched) return undefined;
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    return { divisionId, sesUserId, mnuId: MENU_ID };
  }, [open, hasSearched, divisionId]);

  const { data, isFetching, isSuccess } = useTabProcQuery<MENU_ID, SHEETS.TEMPLATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.TEMPLATE,
    tabId: MENU_ID,
    filters,
    enabled: !!filters,
  });

  const rows = useMemo<MetalLinkTemplateRow[]>(
    () => ((data as { o_rc1?: MetalLinkTemplateRow[] })?.o_rc1 ?? []),
    [data]
  );

  // AS-IS 팝업 FindData 0건 → MSG (L229 1:1) — 조회 완료 시점 1회 안내
  useEffect(() => {
    if (!open || !hasSearched || isFetching || !isSuccess) return;
    if (rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(
          MSG.TEMPLATE_EMPTY,
          '_Monthly Rolling Forecast \'Y\' version does not exist in this week\'s Sales Plan Waterfall.'
        ),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, hasSearched, isFetching, isSuccess, rows.length]);

  const handleFind = () => {
    if (isFetching) return;
    if (!divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    setHasSearched(true);
  };

  // ⭐ 템플릿 다운로드 = 그리드 Excel export (AS-IS 팝업 Excel 버튼 1:1)
  const handleExcel = () => {
    const g = gridRef.current;
    if (!g || rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(
          MSG.TEMPLATE_EMPTY,
          '_Monthly Rolling Forecast \'Y\' version does not exist in this week\'s Sales Plan Waterfall.'
        ),
      });
      return;
    }
    void GridAction.excelDownload(g, TEMPLATE_EXCEL_PREFIX);
  };

  return (
    <CustomDialog
      open={open}
      size={1400}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00762', 'Excel Form')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 업로드 대상 조합 미리보기 — Base + 메탈 42 ('-' placeholder). division 고정 */}
          <div className={styles.gridWrapper}>
            <MetalLinkPriceGrid
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              data={rows}
              searchedDivision={divisionId}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              disabled={isFetching}
              buttonLabel={isFetching ? t('LBL00665', 'Loading...') : t('LBL00664', 'Search')}
              onClick={handleFind}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              disabled={isFetching || rows.length === 0}
              buttonLabel={t('LBL00763', 'Excel Download')}
              onClick={handleExcel}
            />
          </div>
        </div>
      }
    />
  );
};
