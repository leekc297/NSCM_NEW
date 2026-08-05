import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, Tooltip } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  MENU_ID,
  MSG,
  SHEETS,
  TEMPLATE_BLANK_PLACEHOLDER,
  TEMPLATE_EXCEL_PREFIX,
  UPLOAD_COLUMNS_DEFAULT,
  UPLOAD_COLUMNS_DIV40,
} from '../../metal-link-price.constants';
import type { MetalLinkTemplateRow } from '../../metal-link-price.types';
import { MetalLinkPriceGrid } from '../MetalLinkPriceGrid';

import styles from './MetalLinkTemplateModal.module.scss';

// ⭐ AS-IS DMF0074_MetalLinkPricePopup (물리 347줄 — btnTemplate 'Excel Form' .cs L704~713) 1:1:
//   팝업 = 조회 그리드 + Excel Export 가 곧 "템플릿 다운로드" (서버 파일 다운로드 아님).
//   - 진입 시 자동조회 없음 (AS-IS //FindData() 주석 1:1) — 상단 SearchArea Search 로 조회.
//   - SP = PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE (divisionId 단일 — 부모 division 고정.
//     division-gate 동일 적용 L837: 권한 없는 사업부 = 행 미반환).
//   - 0건 = MSG00656 (이번 주 Sales Plan Waterfall MRF 'Y' 버전 부재 — AS-IS 팝업 L229 구 MSG00427 의도)
//   - Excel Download(아이콘 버튼) = GridAction.flatExcelDownload — 업로드 양식(HEADER_CONTENT) 과
//     동일한 평탄 헤더 1행 + '-' placeholder 는 빈칸으로 치환 (그대로 두면 업로드 검증에서 값으로 인식)
//   ⭐ 표준 디자인 (사용자 요구 2026-07-10): 상단 SearchArea(Div 고정 + Search) /
//     하단 [Excel Download 아이콘] + [Close 맨 오른쪽]
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

  // Div 표기 — 메인 화면 division 고정 (수정 불가 · MetalLinkVersionModal 동일 패턴)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  // AS-IS 자동조회 없음 — Search 명시 게이트 (모달 닫으면 초기화)
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
    () => (data as { o_rc1?: MetalLinkTemplateRow[] })?.o_rc1 ?? [],
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
          "_Monthly Rolling Forecast 'Y' version does not exist in this week's Sales Plan Waterfall."
        ),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, hasSearched, isFetching, isSuccess, rows.length]);

  const handleFind = () => {
    if (isFetching) return;
    if (!divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    setHasSearched(true);
  };

  // 업로드 양식 = HEADER_CONTENT 토큰과 1:1 (DIV=40 은 Project 2열 제외 → 53열)
  const uploadColumns = divisionId === '40' ? UPLOAD_COLUMNS_DIV40 : UPLOAD_COLUMNS_DEFAULT;

  // ⭐ 템플릿 다운로드 = 업로드 양식 그대로의 평탄 헤더 1행 export.
  //   그리드 export(2단 병합 헤더)는 BE 이름 기반 매핑과 호환되지 않아 사용하지 않는다.
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(
          MSG.TEMPLATE_EMPTY,
          "_Monthly Rolling Forecast 'Y' version does not exist in this week's Sales Plan Waterfall."
        ),
      });
      return;
    }
    // SP placeholder '-' 는 사용자가 채울 빈칸 — 값으로 업로드되면 검증에서 탈락하므로 제거
    const exportRows = rows.map(row =>
      Object.fromEntries(
        uploadColumns.map(({ key }) => {
          const value = row[key];
          return [key, value === TEMPLATE_BLANK_PLACEHOLDER ? '' : (value ?? '')];
        })
      )
    );
    void GridAction.flatExcelDownload(exportRows, uploadColumns, TEMPLATE_EXCEL_PREFIX).catch(
      (error: unknown) => {
        void setAlert({
          type: 'alert',
          content: error instanceof Error ? error.message : 'Excel download failed.',
        });
      }
    );
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
          {/* ⭐ 표준 SearchArea — Search 버튼 상단 (Div = 메인 화면 division 고정) */}
          <SearchArea
            searchButtonLabel={isFetching ? t('LBL00665', 'Loading...') : t('LBL00664', 'Search')}
            onSearch={handleFind}
            conditions={
              <Grid size={3}>
                <FormItem
                  label={t('LBL00001', 'Div.')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                  )}
                />
              </Grid>
            }
          />
          {/* 업로드 대상 조합 미리보기 — Base + 메탈 42 ('-' placeholder). division 고정 */}
          <div className={styles.gridWrapper}>
            <MetalLinkPriceGrid
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              data={rows}
              searchedDivision={divisionId}
            />
          </div>
          {/* ⭐ 하단 — Excel Download 아이콘 버튼 + Close 맨 오른쪽 (사용자 요구 2026-07-10) */}
          <div className={styles.buttonWrapper}>
            <Tooltip followCursor title={t('LBL00763', 'Excel Download')} placement='bottom'>
              <div>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  // disabled={isFetching || rows.length === 0}
                  iconComponent={<FileExceldownloadIcon />}
                  onClick={handleExcel}
                />
              </div>
            </Tooltip>
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
