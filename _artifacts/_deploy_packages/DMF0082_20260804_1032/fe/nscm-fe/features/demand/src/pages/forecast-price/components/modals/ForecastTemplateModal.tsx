import { useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, Tooltip } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { TEMPLATE_EXCEL_PREFIX, UPLOAD_HEADERS } from '../../forecast-price.constants';

import styles from './ForecastTemplateModal.module.scss';

// ⭐ Excel Form(템플릿 다운로드) — division 81 전용. metal-link MetalLinkTemplateModal 레이아웃 1:1:
//   상단 SearchArea(Div 고정 + Search) / 하단 [Excel Download 아이콘] + [Close].
//   현재는 "빈 파일" 스텁 — DMF0082 템플릿 백엔드 프로시저가 아직 없어 조회는 붙이지 않고
//   빈 그리드 + 헤더만 있는 업로드 양식 다운로드만 제공한다.
//   TODO(backend): P_DMF0082 템플릿 조회 proc 배선 시 — useTabProcQuery 로 rows 조회 →
//     그리드/Excel export 에 실제 데이터 반영 (metal-link MetalLinkTemplateModal 참조).
interface ForecastTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  // 부모 화면 조회 division 고정 전달 (metal-link 동일 패턴)
  divisionId: string;
}

export const ForecastTemplateModal = ({
  open,
  modalClose,
  divisionId,
}: ForecastTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // Div 표기 — 메인 화면 division 고정 (수정 불가 · metal-link MetalLinkTemplateModal 동일)
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

  // 업로드 양식 컬럼 = UPLOAD_HEADERS (헤더 라벨). 스텁 단계라 데이터 행은 없으므로 key 는 합성.
  const uploadColumns = useMemo(
    () => UPLOAD_HEADERS.map((header, i) => ({ header, key: `COL${i}` })),
    []
  );

  // 빈 그리드 미리보기 — 헤더만 표시 (rows 없음). 백엔드 배선 후 실제 조합 미리보기로 대체.
  const gridColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      uploadColumns.map(({ header, key }) => ({
        colNm: key,
        colLblNm: header,
        colWth: 120,
        horzAlgnCd: 'L',
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      })),
    [uploadColumns]
  );

  // TODO(backend): 템플릿 조회 proc 배선 전까지 Search 는 no-op (레이아웃 유지용).
  //   divisionId 는 부모(division 81 게이트)에서 항상 고정 전달되므로 별도 검증 불요.
  const handleFind = () => {
    // 백엔드 템플릿 proc 배선 시 이 자리에서 조회 트리거.
  };

  // ⭐ 템플릿 다운로드 = 업로드 양식 그대로의 평탄 헤더 1행 export (현재 데이터 행 0 = 빈 양식).
  const handleExcel = () => {
    void GridAction.flatExcelDownload([], uploadColumns, TEMPLATE_EXCEL_PREFIX).catch(
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
            searchButtonLabel={t('LBL00664', 'Search')}
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
          {/* 업로드 대상 조합 미리보기 — 현재는 빈 그리드(헤더만). 백엔드 배선 후 데이터 반영 */}
          <div className={styles.gridWrapper}>
            <DataGrid isReadOnly staticColumns={gridColumns} itemsSource={[]} />
          </div>
          {/* ⭐ 하단 — Excel Download 아이콘 버튼 + Close 맨 오른쪽 (metal-link 동일) */}
          <div className={styles.buttonWrapper}>
            <Tooltip followCursor title={t('LBL00763', 'Excel Download')} placement='bottom'>
              <div>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
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
