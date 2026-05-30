/**
 * DMF0043_ContributeRatePopup — 기여율 버전관리 모달 (공유)
 *
 * 부모 화면 (Main 과 View 양쪽 호출):
 *   - DMF0043_Contribute_Main  (`contribute-main`)
 *   - DMF0043_Contribute_View (`contribute-view`) — `import` 시 상대경로 사용
 *
 * AS-IS: DMF0043_ContributeRatePopup.cs (1102×320 모달)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main_POPUP_DMF0043_ContributeRate/__asis-mapping__.md
 * SP: DMF0000_GET_COMMON_SPREAD_TITLE / DMF0043_GET_CONTRIBUTE_RATE_POPUP / DMF0043_GET_CONTRIBUTE_YEAR_POPUP / DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import { FlexGrid as FlexGridReact, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import styles from './ContributeRateModal.module.scss';

interface ContributeRateModalProps {
  open: boolean;
  modalClose: () => void;
  /** parent menu id — Main 호출 시 'DMF0043', View 호출 시 'DMF0043_01' */
  parentMenuId: string;
  /** 부모로 선택 결과 전달 (옵션) */
  onApply?: (selectedVerSeq: string) => void;
}

interface ContributeRateRow {
  EDIT_FLAG?: string;
  VER_SEQ?: string;
  YYYY?: string;
  VERSION_NM?: string;
  VALID_YN?: 'Y' | 'N';
  DESCRIPTION?: string;
}

export const ContributeRateModal = ({
  open,
  modalClose,
  parentMenuId,
  onApply,
}: ContributeRateModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const gridRef = useRef<FlexGrid<ContributeRateRow>>();
  const [year, setYear] = useState('');
  const [enabled, setEnabled] = useState(false);

  /** AS-IS .cs:209 FindData — DMF0043_GET_CONTRIBUTE_RATE_POPUP (sheetNm=contributeRate)
   *  2026-05-29 stub → useTabProcQuery 로 교체. parentMenuId 에 따라 DMF0043 / DMF0043_01 분기. */
  const { data } = useTabProcQuery({
    menuId: parentMenuId as never,
    sheetName: 'contributeRate' as never,
    tabId: parentMenuId,
    filters: { yyyy: year } as never,
    enabled: enabled && !!year,
  });
  const rows = (data as { o_rc1?: ContributeRateRow[] } | undefined)?.o_rc1 ?? [];

  /** AS-IS .cs:198-202 FindData — Year 필수 검증 (MSG00019) */
  const onFindClick = () => {
    if (!year) {
      void setAlert({
        type: 'alert',
        content: t('MSG00019', '_조회조건을 입력해 주세요.'),
      });
      return;
    }
    setEnabled(true);
  };

  const onApplyClick = () => {
    const selected = gridRef.current?.selectedItems[0] as ContributeRateRow | undefined;
    if (selected?.VER_SEQ && onApply) {
      onApply(selected.VER_SEQ);
    }
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      title={t('LBL_DMF0043_CONTRIBUTE_RATE_TITLE', '_기여율 버전관리')}
      onClose={modalClose}
      maxWidth='lg'
      fullWidth
    >
      <Stack className={styles.container} spacing={2}>
        <Stack direction='row' spacing={1} alignItems='center'>
          <span className={styles.label}>{t('LBL_DMF0043_YEAR', '_Year')}</span>
          <InputField
            value={year}
            onChange={event => setYear(event.target.value)}
            placeholder='YYYY'
          />
          <Button appearance='outlined' priority='normal' onClick={onFindClick}>
            {t('LBL_DMF0043_FIND', '_조회')}
          </Button>
        </Stack>

        <FlexGridReact
          itemsSource={rows}
          initialized={(g: FlexGrid<ContributeRateRow>) => {
            gridRef.current = g;
          }}
          selectionMode='Row'
          style={{ height: 232 }}
        >
          <FlexGridColumn binding='VER_SEQ' header='VER_SEQ' width={70} isReadOnly />
          <FlexGridColumn binding='YYYY' header='Year' width={70} isReadOnly />
          <FlexGridColumn binding='VERSION_NM' header='버전명' width={200} />
          <FlexGridColumn binding='VALID_YN' header='유효' width={60} />
          <FlexGridColumn binding='DESCRIPTION' header='설명' width={300} />
        </FlexGridReact>

        <Stack direction='row' spacing={1} justifyContent='flex-end' className={styles.actions}>
          <Button appearance='outlined' priority='normal' onClick={modalClose}>
            {t('LBL_DMF0043_CANCEL', '_취소')}
          </Button>
          <Button appearance='filled' priority='primary' onClick={onApplyClick}>
            {t('LBL_DMF0043_APPLY', '_적용')}
          </Button>
        </Stack>
      </Stack>
    </CustomDialog>
  );
};
