import { Breadcrumb } from '@lges/design-system';
import { memo } from 'react';

import { Switch, TitleArea } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import styles from './MainTitle.module.scss';

interface MainTitleProps {
  title: string;
  menuId: string;
  openSearchArea?: boolean;
  disableSearchArea?: boolean;
  toggleOpenSearchArea?: (open?: boolean) => void;
}

const MainTitleComp = ({
  title,
  menuId,
  openSearchArea = true,
  disableSearchArea = false,
  toggleOpenSearchArea,
}: MainTitleProps) => {
  const { t } = useTranslation();
  const { findMenuPath, toggleFavorite } = useSessionStore();

  const menus = findMenuPath(menuId);
  const menu = menus?.at(-1);

  return (
    <div className={styles.titleAreaWrapper}>
      <TitleArea
        title={t(title, menuId)}
        bookmark={menu?.favorite}
        onFavorite={() => {
          toggleFavorite(menuId, !menu?.favorite);
        }}
        isSubTitle={false}
        bullet={false}
        hasRightButtons
        breadcrumb={
          <Breadcrumb data={menus?.map(menu => ({ label: t(menu.mnuMsgId, menu.mnuDesc) }))} />
        }
        rightButtons={
          !disableSearchArea && (
            <Switch
              color='primary'
              label={t('LBL00324', '_Search Area')}
              checked={openSearchArea}
              onChange={(_, val) => toggleOpenSearchArea?.(val)}
            />
          )
        }
      />
    </div>
  );
};

export const MainTitle = memo(MainTitleComp);
