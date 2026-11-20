import { useEffect, useMemo, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import styles from './PersonalSettingModal.module.scss';

interface PersonalSettingModalProps {
  open: boolean;
  onClose: () => void;
}

// AS-IS PersonalSettingPopup 대응. Default Role 은 TO-BE 범위에서 제외, Language 는 헤더
// LanguageButton 이 담당하므로 이 팝업은 Time Zone(SCM_ADM_USER_M.TMZ_CD) 저장만 한다.
export const PersonalSettingModal = ({ open, onClose }: PersonalSettingModalProps) => {
  const { t } = useTranslation();

  const session = useSessionStore(state => state.session);
  const changeTimeZone = useSessionStore(state => state.changeTimeZone);
  const setToast = useMessageStore(state => state.setToast);
  const setAlert = useMessageStore(state => state.setAlert);

  const [selected, setSelected] = useState('');
  const [isSaving, setIsSaving] = useState(false);

  // 열릴 때마다 현재 세션 타임존으로 초기화 — 재오픈 시 이전 선택 잔존 방지(POP-08).
  useEffect(() => {
    if (open) setSelected(session.tmzCd ?? '');
  }, [open, session.tmzCd]);

  // 콤보 'TimeZone'(SCM_ADM_CMBO_SQL_M → SCM_ADM_LOOKUP_MASTER_DETAIL TIME_ZONE). 메뉴 스코프 없음.
  const [timeZones] = useTabComboQueries({
    filters: [{ comboId: 'TimeZone' }],
    enabled: open,
  });

  const options = useMemo(
    () => (timeZones ?? []).map(item => ({ label: item.NAME, value: item.CODE })),
    [timeZones]
  );

  const handleSave = async () => {
    if (isSaving) return;
    const changed = selected !== (session.tmzCd ?? '');
    try {
      setIsSaving(true);
      await changeTimeZone(selected);
      // 타임존이 실제로 바뀌면 전체 새로고침 — 이미 열린 화면의 서버 계산 Period 기본값(FN_MULTY_TIME)·그리드는
      //   session.tmzCd 반응만으로는 재조회되지 않으므로, 새 타임존으로 전면 재계산되게 한다(사용자 지시 2026-11-19).
      //   리로드가 곧 피드백이라 저장 토스트는 바뀐 경우 생략(리로드 중 사라짐).
      if (changed) {
        globalThis.window.location.reload();
        return;
      }
      setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
      onClose();
    } catch {
      void setAlert({ content: t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback) });
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      size={400}
      height={200}
      type='modal'
      position='basic'
      // 사용자 지시(2026-10-26): 제목은 그냥 영문 리터럴로 둔다(미등록 라벨, 코드화 안 함).
      title='Personal Setting'
      handleClose={onClose}
      disableButtonCancel
      customContentArea={
        <div className={styles.content}>
          <div className={styles.field}>
            <FormItem
              label={t('LBL00738', '_Time Zone')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={selected}
                  options={options}
                  onChange={(_, value) => setSelected(value)}
                />
              )}
            />
          </div>
          <div className={styles.buttonRow}>
            <Button
              appearance='contained'
              priority='primary'
              buttonLabel={t('LBL00395', '_Save')}
              disabled={isSaving}
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              buttonLabel={t('LBL00394', '_Cancel')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
