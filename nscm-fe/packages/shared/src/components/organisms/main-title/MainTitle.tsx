import { Breadcrumb } from '@lges/design-system';
import { useTheme } from '@mui/material';
import { memo, useMemo } from 'react';

import { Switch, TitleArea } from '@shared/lges';
import { ControlZoomIcon } from '@shared/lges-icons';
import { useSessionStore, useUIStore } from '@shared/stores';

import styles from './MainTitle.module.scss';

// 디자인시스템 Breadcrumb 은 data 를 참조 비교로 useEffect 의존성에 걸고 그 안에서 무조건
// setState 한다. 따라서 매 렌더마다 새 배열을 넘기면 렌더 루프에 빠진다
// (data 미지정 시 기본값 `[]` 도 렌더마다 새 배열이라 동일한 문제).
// → breadcrumb 데이터는 반드시 참조가 안정적이어야 하며, 빈 경우도 이 상수를 재사용한다.
const EMPTY_BREADCRUMB: { label: string }[] = [];

interface MainTitleProps {
  title: string;
  menuId: string;
  openSearchArea?: boolean;
  disableSearchArea?: boolean;
  disableSearchAreaToggle?: boolean;
  toggleOpenSearchArea?: (open?: boolean) => void;
}

const MainTitleComp = ({
  title,
  menuId,
  openSearchArea = true,
  disableSearchArea = false,
  disableSearchAreaToggle = false,
  toggleOpenSearchArea,
}: MainTitleProps) => {
  const { t } = useTranslation();
  const { palette } = useTheme();
  const findMenuPath = useSessionStore(state => state.findMenuPath);
  const toggleFavorite = useSessionStore(state => state.toggleFavorite);
  // 메뉴 로딩(로그인/세션 갱신) 후 breadcrumb 을 다시 계산하기 위한 의존성
  const sessionMenus = useSessionStore(state => state.session?.menus);
  // Page 영역 전체화면 — 다이얼로그의 최대화(ControlMaximize/Minimize)와 동일한 아이콘/토글 패턴.
  // 실제 전체화면 적용은 ViewContainer 가 담당(공통 처리).
  const pageFullscreen = useUIStore(state => state.pageFullscreen);
  const togglePageFullscreen = useUIStore(state => state.togglePageFullscreen);

  const menus = useMemo(
    () => findMenuPath(menuId),
    // sessionMenus 가 바뀔 때(메뉴 로딩 완료)만 경로를 다시 찾는다
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [findMenuPath, menuId, sessionMenus]
  );
  const menu = menus?.at(-1);
  const breadcrumbData = useMemo(
    () => menus?.map(m => ({ label: t(m.mnuMsgId, m.mnuDesc) })) ?? EMPTY_BREADCRUMB,
    [menus, t]
  );
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
        breadcrumb={<Breadcrumb data={breadcrumbData} />}
        rightButtons={
          <>
            {!disableSearchArea && (
              <Switch
                color='primary'
                label={t('LBL00324', '_Search Area')}
                checked={openSearchArea}
                disabled={disableSearchAreaToggle}
                onChange={(_, val) => toggleOpenSearchArea?.(val)}
              />
            )}
            <ControlZoomIcon
              type={pageFullscreen ? 'zoom-out' : 'zoom-in'}
              iconSize={20}
              onClick={togglePageFullscreen}
              cursor='pointer'
              sx={{ color: palette.semantic.color.commonTextLight }}
            />
          </>
        }
      />
    </div>
  );
};

export const MainTitle = memo(MainTitleComp);
