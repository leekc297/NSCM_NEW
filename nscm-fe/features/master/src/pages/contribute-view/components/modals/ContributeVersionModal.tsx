/**
 * DMF0043_VersionPopup — Sales Plan Version 선택 모달 (View 전용)
 *
 * AS-IS: DMF0043_VersionPopup.cs (btnSPVer_Click 으로 호출)
 * SP: DMF0043_GET_CONT_VIEW_VERSIONPOPUP
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import { FlexGrid as FlexGridReact, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { MENU_ID } from '../../contribute-view.constants';
import type { ContributeVersionRow } from '../../contribute-view.types';

import styles from './ContributeVersionModal.module.scss';

interface ContributeVersionModalProps {
  open: boolean;
  modalClose: () => void;
  onApply?: (versionId: string) => void;
}

export const ContributeVersionModal = ({
  open,
  modalClose,
  onApply,
}: ContributeVersionModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ContributeVersionRow>>();

  /** AS-IS .cs:461 DMF0043_VersionPopup — DMF0043_GET_CONT_VIEW_VERSIONPOPUP
   *  2026-05-29 stub → useTabProcQuery 로 교체 (sheetNm=version) */
  const { data } = useTabProcQuery({
    menuId: MENU_ID as never,
    sheetName: 'version' as never,
    tabId: MENU_ID,
    filters: {} as never,
    enabled: open,
  });
  const rows = (data as { o_rc1?: ContributeVersionRow[] } | undefined)?.o_rc1 ?? [];

  const onApplyClick = () => {
    const selected = gridRef.current?.selectedItems[0] as ContributeVersionRow | undefined;
    if (selected?.VER_SEQ && onApply) {
      onApply(selected.VER_SEQ);
    }
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      title={t('LBL_DMF0043_VERSION_TITLE', '_Sales Plan Version 선택')}
      onClose={modalClose}
      maxWidth='md'
      fullWidth
    >
      <Stack className={styles.container} spacing={2}>
        <FlexGridReact
          itemsSource={rows}
          initialized={(g: FlexGrid<ContributeVersionRow>) => {
            gridRef.current = g;
          }}
          selectionMode='Row'
          isReadOnly={true}
          style={{ height: 300 }}
        >
          <FlexGridColumn binding='VER_SEQ' header='VER_SEQ' width={70} />
          <FlexGridColumn binding='YYYY' header='Year' width={70} />
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
