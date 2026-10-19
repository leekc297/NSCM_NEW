import { useEffect, useMemo, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, SHEETS, USE_TYPE_CODE } from '../mail-setup.constants';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailDialog.module.scss';

interface MailSqlDialogProps {
  tabId: string;
  onSave: (sqlText: string) => void;
}

export const MailSqlDialog = ({ tabId, onSave }: MailSqlDialogProps) => {
  const { t } = useTranslation();

  const isOpen = useMailSetupStore(state => state.isSqlDialogOpen);
  const closeSqlDialog = useMailSetupStore(state => state.closeSqlDialog);
  const categoryId = useMailSetupStore(state => state.selectedCategoryId);
  const categoryDesc = useMailSetupStore(state => state.selectedCategoryDesc);
  const moduleCode = useMailSetupStore(state => state.selectedModuleCode);
  const subModuleCode = useMailSetupStore(state => state.selectedSubModuleCode);

  const [sqlText, setSqlText] = useState('');

  // filters 는 참조 비교 대상 — 인라인 객체 전달 시 매 렌더 재조회(무한 루프)
  const sqlFilters = useMemo(
    () => ({
      useType: USE_TYPE_CODE,
      module: moduleCode,
      submodule: subModuleCode,
      categoryId,
    }),
    [moduleCode, subModuleCode, categoryId]
  );

  const { data } = useTabProcQuery<MENU_ID, SHEETS.SQL_TEXT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SQL_TEXT,
    tabId,
    filters: sqlFilters,
    enabled: isOpen && !!categoryId,
  });

  useEffect(() => {
    if (!isOpen) return;
    setSqlText((data?.o_rc1?.[0] as Record<string, string> | undefined)?.SQL_TEXT ?? '');
  }, [isOpen, data]);

  if (!isOpen) return null;

  return (
    <CustomDialog
      open={isOpen}
      size={1000}
      height='60vh'
      title={`${t('LBL00780', '_SQL VIEW')} (${categoryDesc})`}
      handleClose={closeSqlDialog}
      handleSubmit={() => onSave(sqlText)}
      customContentArea={
        <div className={styles.contentArea}>
          <textarea
            className={styles.sqlTextArea}
            value={sqlText}
            onChange={event => setSqlText(event.target.value)}
          />
          {/* CustomDialog 는 customContentArea 지정 시 기본 하단 OK/Cancel 버튼을 렌더링하지 않는다
              (CustomDialogContent.tsx lowerButtonGroup 분기) — 위 handleSubmit 은 그래서 실제로는
              호출되지 않는다. */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              buttonLabel={t('LBL00359', '_확인')}
              onClick={() => onSave(sqlText)}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00107', '_취소')}
              onClick={closeSqlDialog}
            />
          </div>
        </div>
      }
    />
  );
};
