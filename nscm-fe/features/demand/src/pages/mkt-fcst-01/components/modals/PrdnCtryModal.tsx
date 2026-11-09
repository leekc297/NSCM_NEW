import { HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, SHEETS } from '../../mkt-fcst-01.constants';
import styles from '../../MktFcst01.module.scss';
import { useMktFcst01Store } from '../../useMktFcst01Store';
import {
  normalizePrdnCtry,
  PRDN_CTRY_NA,
  PRDN_CTRY_OPT_NA,
  toCellStr,
} from '../../utils/mkt-fcst-01.cell';

// Prod. Country 선택 팝업 (설계서 popup-3, 요건 2).
//   Suffix Gr. 별 Cell · Pack · Link Site(모델 코드 14 · 15 · 16 자리 생산국)를 보여 주고, 체크한 Suffix Gr. 를
//   번호순 · 쉼표로 이어 셀에 넣는다. 머리글 체크 = 모두 선택. Skip = 99(N/A) 단독(Option 은 호출부가 N/A 로 맞춘다).
//   조회: prdnCtry / SEARCH → PKG_DMF0003_01.P_DMF0003_01_GET_PRDN_CTRY_POPUP (사업부 · 사용자).
//   99 와 다른 번호를 함께 고르면 저장 프로시저가 막는다(설계서 메시지 · 검증) — 팝업은 그대로 넘긴다.
//   N/A 상수와 값 정리 규칙은 셀 직접 입력과 같이 쓰도록 utils/mkt-fcst-01.cell 에 둔다.
export { PRDN_CTRY_NA, PRDN_CTRY_OPT_NA };

type PrdnCtryRow = ResponseData<MENU_ID, SHEETS.PRDN_CTRY>;

interface PrdnCtryModalProps {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  // 셀에 이미 있는 값(쉼표 구분) — 열 때 그 번호를 체크해 둔다.
  value: string;
  onConfirm: (result: { prdnCtry: string; skip: boolean }) => void;
}

export const PrdnCtryModal = ({ open, modalClose, divisionId, value, onConfirm }: PrdnCtryModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<PrdnCtryRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const staticColumns = useMktFcst01Store(state => state.staticColumns[SHEETS.PRDN_CTRY]);
  const fetchPopupColumns = useMktFcst01Store(state => state.fetchPopupColumns);

  useEffect(() => {
    if (open) void fetchPopupColumns(SHEETS.PRDN_CTRY, divisionId);
  }, [open, divisionId, fetchPopupColumns]);

  const filters = useMemo(() => ({ divisionId }), [divisionId]);
  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.PRDN_CTRY>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRDN_CTRY,
    tabId: 'PrdnCtryModal',
    filters: filters as never,
    enabled: open && !!divisionId,
  });
  const itemsSource = useMemo(() => data?.o_rc1 ?? [], [data]);

  // 열 때 셀 값의 번호를 체크해 둔다. 같은 Suffix Gr. 가 두 행이면 둘 다 체크된다.
  useEffect(() => {
    const g = gridRef.current;
    if (!open || !g) return;
    const current = new Set(value.split(',').map(v => v.trim()).filter(Boolean));
    for (const row of g.rows) {
      const item = row.dataItem as PrdnCtryRow | undefined;
      row.isSelected = !!item && current.has(toCellStr(item.SUFFIX_GR).trim());
    }
    g.invalidate();
  }, [open, value, itemsSource]);

  const handleOk = () => {
    const g = gridRef.current;
    if (!g) return;
    const picked: string[] = [];
    for (const row of g.rows) {
      const item = row.dataItem as PrdnCtryRow | undefined;
      if (row.isSelected && item) picked.push(toCellStr(item.SUFFIX_GR));
    }
    // 하나도 고르지 않으면 셀을 비운다(설계서 popup-3 확인 버튼).
    onConfirm({ prdnCtry: normalizePrdnCtry(picked.join(',')), skip: false });
    modalClose();
  };

  const handleSkip = () => {
    onConfirm({ prdnCtry: PRDN_CTRY_NA, skip: true });
    modalClose();
  };

  return (
    <CustomDialog
      size={600}
      type='modal'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업이 MuiDialog-container 밖에 붙어 FocusTrap 과 충돌한다(SspSyncCompareModal 과 같은 이유).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL01232', 'Prod. Country')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={isLoading || isFetching}
              placement='parent'
            />
            <ResultArea title='' count={itemsSource.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<PrdnCtryRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox
                // 체크박스(머리글 = 모두 선택)는 rowHeader 의 Selector 가 그린다 — rowHeader 를 남긴다.
                headersVisibility={HeadersVisibility.All}
                staticColumns={staticColumns}
                itemsSource={itemsSource}
              />
            </ResultArea>
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Skip' onClick={handleSkip} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
          </div>
        </div>
      }
    />
  );
};
