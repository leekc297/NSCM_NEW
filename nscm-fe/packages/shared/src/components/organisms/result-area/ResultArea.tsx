import clsx from 'clsx';
import { Children, Fragment, isValidElement, type ReactNode } from 'react';

import { useFilteredGridCount } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import styles from './ResultArea.module.scss';
import type { ResultAreaGroupProps, ResultAreaProps } from './ResultArea.types';

export type { ResultAreaGroupProps, ResultAreaProps } from './ResultArea.types';

/**
 * flex prop 정규화 — 비율 숫자를 CSS flex 축약형으로 확장한다.
 *   - 숫자 / 숫자 문자열('6') → `'6 1 0'` (grow 비율)
 *   - 그 외 CSS 문자열('0 0 180px') → 그대로 통과 (고정 크기 유지)
 *   - undefined → undefined (SCSS 기본값 `flex: 1 1 0`)
 */
const toFlex = (flex: number | string | undefined): string | undefined => {
  if (flex === undefined) return undefined;
  if (typeof flex === 'number') return `${flex} 1 0`;
  return /^\d+$/.test(flex.trim()) ? `${flex.trim()} 1 0` : flex;
};

/**
 * SubTitle 아래 결과(그리드) 영역 표준 컴포넌트 — "제목 헤더 + 그리드 본문" 을 한 프레임으로 고정한다.
 * (화면마다 TitleArea + GridArea.Section 을 제각기 조립해 제목 유무·간격·flex 가 어긋나던 걸 통일)
 *
 * 여러 영역을 세로/좌우로 나눌 때는 `<ResultArea.Group>` 으로 감싼다.
 *
 * ex) 단일 그리드 — 제목 없이 프레임만
 * <ResultArea>
 *   <MyGrid ... />
 * </ResultArea>
 *
 * ex) 제목 + 건수 + 전용 버튼
 * <ResultArea title={t('LBL00057', 'Lookup Type')} count={rows.length} rightButtons={<Button ... />}>
 *   <MasterGrid ... />
 * </ResultArea>
 *
 * ex) master(위 6) / detail(아래 4) 세로 분할 — 비율은 합이 10 이 되게
 * <ResultArea.Group>
 *   <ResultArea title={t('LBL00057', 'Lookup Type')} flex={6}>
 *     <MasterGrid ... />
 *   </ResultArea>
 *   <ResultArea title={t('LBL00637', 'Lookup Values')} flex={4}>
 *     <DetailGrid ... />
 *   </ResultArea>
 * </ResultArea.Group>
 *
 * ex) 사용자가 경계를 드래그해 조절하는 분할 — split 만 추가하면 된다(초기 비율은 그대로 flex)
 * <ResultArea.Group split>
 *   <ResultArea title={t('LBL00057', 'Lookup Type')} flex={7}>
 *     <MasterGrid ... />
 *   </ResultArea>
 *   <ResultArea title={t('LBL00637', 'Lookup Values')} flex={3}>
 *     <DetailGrid ... />
 *   </ResultArea>
 * </ResultArea.Group>
 *
 * ex) 좌우 분할 — 왼쪽만 고정폭이면 CSS 원형 문자열로
 * <ResultArea.Group direction='horizontal' gap={24}>
 *   <ResultArea title='List' flex='0 0 320px'>...</ResultArea>
 *   <ResultArea title='Detail'>...</ResultArea>
 * </ResultArea.Group>
 */
const ResultAreaRoot = ({
  children,
  title,
  depth = 'h4',
  count,
  gridRef,
  gridFilterRef,
  rightButtons,
  flex,
  gap = 4,
  onClickCapture,
  className,
  style,
}: ResultAreaProps) => {
  // gridRef/gridFilterRef 미지정 시 종전과 동일하게 count 그대로(0/undefined 면 미표시) 반환.
  const totalCases = useFilteredGridCount(gridRef, gridFilterRef, count ?? 0);

  return (
    <div
      className={clsx(styles.resultArea, className)}
      style={{ gap: `${gap}px`, ...(flex !== undefined && { flex: toFlex(flex) }), ...style }}
      onClickCapture={onClickCapture}
    >
      {(title !== undefined || rightButtons) && (
        <TitleArea
          isSubTitle
          depth={depth}
          title={title ?? ''}
          totalCases={totalCases}
          rightButtons={rightButtons}
        />
      )}
      <div className={styles.body}>{children}</div>
    </div>
  );
};

/**
 * 자식 ResultArea 의 flex 비율을 Panel 의 defaultSize(%) 로 환산한다.
 * 비율을 안 준 자식은 1 로 보고, 전체 합 기준 백분율로 나눈다. (6,4 → 60%, 40%)
 */
const toPanelSizes = (items: ReactNode[]): number[] => {
  const weights = items.map(item => {
    const flex = isValidElement<ResultAreaProps>(item) ? item.props.flex : undefined;
    if (typeof flex === 'number') return flex;
    if (typeof flex === 'string' && /^\d+$/.test(flex.trim())) return Number(flex.trim());
    return 1;
  });
  const total = weights.reduce((sum, w) => sum + w, 0);
  return weights.map(w => (w / total) * 100);
};

/**
 * 여러 ResultArea 를 세로/좌우로 묶는 컨테이너. 자식 배치 방향과 분할 방식을 결정한다.
 *   - 기본: flex 비율 고정 분할
 *   - `split`: 경계를 드래그해 조절 (자식 flex 가 초기 비율)
 */
const ResultAreaGroup = ({
  children,
  direction = 'vertical',
  gap = 4,
  split,
  minSize = 10,
  flex,
  className,
  style,
}: ResultAreaGroupProps) => {
  const isHorizontal = direction === 'horizontal' || direction === 'row';
  const groupClassName = clsx(styles.group, isHorizontal ? styles.row : styles.column, className);
  const groupStyle = { ...(flex !== undefined && { flex: toFlex(flex) }), ...style };

  if (split) {
    // 조건부 자식({cond && <ResultArea/>})은 toArray 가 걸러준다.
    const items = Children.toArray(children).filter(isValidElement);
    const sizes = toPanelSizes(items);
    // gap 은 주지 않는다 — 자식 사이 간격은 드래그 바(Separator)가 대신한다.
    return (
      <PanelGroup
        className={groupClassName}
        style={groupStyle}
        orientation={isHorizontal ? 'horizontal' : 'vertical'}
      >
        {items.map((item, index) => (
          <Fragment key={index}>
            {index > 0 && (
              <PanelSeparator
                className={clsx(
                  styles.splitBar,
                  isHorizontal ? styles.splitBarCol : styles.splitBarRow
                )}
              />
            )}
            <Panel defaultSize={sizes[index]} minSize={minSize}>
              <div className={styles.panel}>{item}</div>
            </Panel>
          </Fragment>
        ))}
      </PanelGroup>
    );
  }

  return (
    <div className={groupClassName} style={{ gap: `${gap}px`, ...groupStyle }}>
      {children}
    </div>
  );
};

export const ResultArea = Object.assign(ResultAreaRoot, {
  Group: ResultAreaGroup,
});
