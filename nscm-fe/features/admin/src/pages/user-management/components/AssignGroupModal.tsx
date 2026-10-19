import { useEffect, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { t } from '@foundation/i18n';
import { CustomDialog } from '@shared/components';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import styles from './AssignGroupModal.module.scss';

// AS-IS UserInfo.cs 의 Assign Group View 버튼 재현 — 사용자 소속 그룹(USE_YN='Y') 그룹명을 나열.
interface UserGroupRow {
  USER_GR_ID: string;
  USER_GR_NM: string;
}

interface AssignGroupModalProps {
  open: boolean;
  userId?: string;
  onClose: () => void;
}

export const AssignGroupModal = ({ open, userId, onClose }: AssignGroupModalProps) => {
  const [groups, setGroups] = useState<UserGroupRow[]>([]);
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    if (!open || !userId) {
      setGroups([]);
      return;
    }

    let canceled = false;
    setLoading(true);
    void apiClient
      .get<UserGroupRow[]>(`/user/${userId}/groups`)
      .then(res => {
        if (!canceled) setGroups(res.data.result ?? []);
      })
      .finally(() => {
        if (!canceled) setLoading(false);
      });

    return () => {
      canceled = true;
    };
  }, [open, userId]);

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>Assign Group</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={360}
      type='modal'
      position='basic'
      draggable={false}
      disableScale
      disableMaximize
      disableButtonCancel
      handleClose={onClose}
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.listWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            {!loading && groups.length === 0 ? (
              <p className={styles.empty}>No assigned group.</p>
            ) : (
              <ul className={styles.groupList}>
                {groups.map(group => (
                  <li key={group.USER_GR_ID} className={styles.groupItem}>
                    {group.USER_GR_NM}
                  </li>
                ))}
              </ul>
            )}
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t('LBL00627', '_Close')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
