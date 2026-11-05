import { Divider, Button, Chip } from '@lges/design-system';
import { $semantic } from '@lges/design-system/design-token';
import {
  ArrowChevronIcon,
  CommunicationBookmarkIcon,
  ControlResetIcon,
  FunctionSearchIcon,
} from '@lges/design-system/icon';
import type { BoxProps, SxProps, Theme } from '@mui/material';
import { Box, Collapse, Grid, useTheme } from '@mui/material';
import _ from 'lodash';
import React, { useContext, useEffect, useLayoutEffect, useRef, useState } from 'react';

import {
  confirmIfDirtyKey,
  DialogScopeContext,
  scopeDirtyKey,
  tabDirtyKey,
  useDialogStore,
  useTabid,
} from '@shared/stores';

const makeSxArray = (sx: SxProps<Theme>): SxProps<Theme>[] => {
  return Array.isArray(sx) ? (sx as SxProps<Theme>[]) : [sx];
};

const mergeSx = (...sxs: Array<SxProps<Theme> | undefined>) => {
  const mergedSx = (sxs.filter(Boolean).filter(sx => !_.isEmpty(sx)) as SxProps<Theme>[]).flatMap(
    makeSxArray
  );

  if (mergedSx.length === 0) return undefined;
  if (mergedSx.length === 1) return mergedSx[0];

  return mergedSx as SxProps<Theme>;
};

// 조회조건 필드(4개/행, 각 25%)가 이 폭 아래에서 더 줄지 않도록 유지하는 페이지 최소너비.
//   ViewContainer(apps/web/src/mdi)가 페이지 전체(MainTitle+SearchArea+SubTitle+Result)를
//   이 값으로 감싸 하나의 스크롤 컨테이너로 묶는다 — 가용 폭이 이보다 좁아지면 페이지 전체가
//   이 폭을 유지한 채 화면 하나에서만 가로 스크롤된다(검색영역/툴바/그리드가 각자 스크롤되지 않음).
//   튜닝: 필드를 더 크게/작게 유지하려면 이 값만 올리거나 내린다(필드폭 ≈ +(Δ폭)/4).
export const SEARCH_AREA_MIN_WIDTH = 1460;

// 조회조건 그리드를 12열 CSS Grid 로 깐다(레거시 flex-wrap Grid 대체).
//   열 정렬: 한 그리드 안에선 모든 행이 같은 12트랙 경계를 공유하므로 입력칸 시작점이 열끼리 정렬된다.
//   폭 맞춤(중요): 그리드는 주어진 공간(viewInner − 버튼 − gap)에 '꽉 맞춰' 1fr 로 늘고/줄어든다
//     (minWidth:0). 그래서 조회영역이 아래 그리드(= viewInner 폭)를 '넘지 않는다' — 넘으면 조회영역만
//     오른쪽으로 튀어나온다(DMF0082 신고). 종전엔 아이템 min-width(290)+그리드 min-content 로 '칸 크기
//     유지, 넘치면 스크롤'을 했는데, Period(388) 있는 화면은 그 합이 viewInner(1460)를 넘어 조회영역이
//     그리드보다 넓어졌다(튀어나옴) → min-content 바닥을 빼고 일반 칸은 1fr 로 분배한다(2026-10-28).
//   긴 필드(Period, periodSplit)만 min-width 388 로 그 열을 넓게 유지(겹침 방지) — 나머지 칸은
//     min-width 없이 1fr 로 분배(viewInner 1460 바닥에서도 ≈280px 로 충분).
//   한계와 보완: 상단(conditions)·확장(extraConditions)은 별도 두 그리드라, Period 가 상단에만 있으면
//     트랙폭이 달라져 확장(3행~)이 어긋난다 → 컴포넌트에서 확장 그리드 트랙폭을 상단 실측값으로
//     동기화한다(아래 useLayoutEffect).
//   아이템은 레거시 size 클래스(MuiGrid-grid-xs-N)를 grid-column 스팬으로 매핑하고, 25% 캡은 푼다.
// 상단 SearchArea 와 하단 DetailBar(SSP0060/0021/mobility 등) 가 공유하는 조회조건 Grid 레이아웃.
//   하단바도 같은 구조(<Grid container columns={12}> + size=3)라 그대로 재사용한다 — 재사용처가 gap 을
//   따로 안 줘도 되게 간격(24/8px)을 내장한다.
export const CONDITIONS_GRID_LAYOUT_SX = {
  display: 'grid',
  gridTemplateColumns: 'repeat(12, 1fr)',
  columnGap: '24px',
  rowGap: '8px',
  // 주어진 공간에 맞춰 줄어들 수 있게 minWidth:0 — flex 기본 min-width:auto(=min-content)를 풀어
  //   조회영역이 컨테이너(viewInner)를 넘어 '튀어나오는' 것을 막는다. 좁아져도 viewInner 1460 바닥이
  //   있어 칸은 읽기 크기로 유지되고, 그보다 좁으면 .view 가 통째로 가로 스크롤된다(버튼 비겹침).
  minWidth: 0,
  '& > .MuiGrid-root': {
    // 레거시 MUI 아이템의 고정폭(width:calc(25%))·25% 캡을 푼다 — 아이템이 트랙을 채워 입력칸이 함께 늘어난다.
    maxWidth: 'none',
    width: 'auto',
  },
  // 긴 날짜범위(PeriodField = periodSplit)가 든 칸만 더 넓게(라벨 140 + 피커 241 ≈ 388) — 겹침 방지.
  //   PeriodField 자체에 전역 min-width 를 걸면 bespoke flex 하단바(예: SSP0023 electrode, MUI Grid 아님)
  //   까지 깨지므로, '이 그리드 안의 Period 칸'에만 :has 로 스코프한다(블랭킷 290 보다 특이도 높아 이김).
  '& > .MuiGrid-root:has([class*="periodSplit"])': { minWidth: '388px' },
  ...Object.fromEntries(
    Array.from({ length: 12 }, (_, i) => [
      `& > .MuiGrid-grid-xs-${i + 1}`,
      { gridColumn: `span ${i + 1}` },
    ])
  ),
};

// 하단 DetailBar 전용. 상단(CSS Grid)과 달리 레거시 flex-wrap Grid 를 그대로 둔다 — 하단바는
//   리사이즈 Panel(width 1460 + overflow:hidden) 안이라 넘쳐도 가로 스크롤이 닿지 않아, 넘치면
//   '2줄로 줄바꿈'을 허용하는 쪽이 자연스럽다(사용자 결정 2026-10-21). 날짜범위(PeriodField) 칸만
//   min-width 388 로 넓혀 겹침만 막는다 — 필드가 많은 하단바(SSP0060: 4필드)는 좁아지면 2줄로
//   접히고, 적은 하단바(SSP0021: 3필드)는 1줄로 들어간다(스크롤·잘림 없음).
export const DETAIL_CONDITIONS_SX = {
  '& > .MuiGrid-root:has([class*="periodSplit"])': { minWidth: '388px' },
} as const;

export type SearchAreaProps = BoxProps & {
  searchButtonLabel?: string;
  isHidden?: boolean;
  myOptions?: string[];
  onSearch?: () => void;
  // 조회 미저장 변경 가드의 dirty 키 override(옵션). 미지정 시 tab 전역 키(현행). 상단/하단 그리드가
  //   독립적인 화면이 "조회 대상 그리드만" 확인하도록 그리드 단위 키를 넘긴다(SSP0060/SSP0021).
  searchDirtyKey?: string;
  onResetCondition?: () => void;
  onSelectedMyOption?: (val?: string) => void;
  onSaveOption?: () => void;
  conditions?: React.ReactNode;
  extraConditions?: React.ReactNode;
  isCustomExtraCondition?: boolean;
  // Search 버튼 바로 왼쪽에 배치할 화면별 커스텀 액션 버튼 (예: Version Create/Transfer 등).
  extraButtons?: React.ReactNode;
  // Search 버튼 바로 위에 배치할 요소 (예: 조회 결과 표시 옵션 체크박스). 첫째 조회조건 행과 같은 높이에 놓인다.
  aboveSearch?: React.ReactNode;
};

export const SearchArea = ({
  searchButtonLabel = '조회',
  isHidden,
  sx,
  myOptions,
  onSearch,
  searchDirtyKey,
  onResetCondition,
  onSaveOption,
  onSelectedMyOption,
  conditions,
  extraConditions,
  isCustomExtraCondition,
  extraButtons,
  aboveSearch,
}: SearchAreaProps) => {
  const {
    palette: { semantic },
  } = useTheme();
  const { sizesCommon } = $semantic.shared.size;
  const { size1, size2, size4, size8, size10, size16, size32, size48 } = sizesCommon;

  const [isExpanded, setIsExpanded] = useState<boolean>(false);
  const buttonGroups = useRef<HTMLElement>();
  const [buttonGroupsWidth, setButtonGroupsWidth] = useState<number>(0);
  // 상단(conditions)·확장(extraConditions) 두 그리드의 열을 맞추기 위한 참조. 아래 동기화 effect 참조.
  const conditionsGridRef = useRef<HTMLDivElement | null>(null);
  const extraGridRef = useRef<HTMLDivElement | null>(null);

  // 확장조건 행의 폭을 버튼 그룹 실측값으로 맞춘다(윗줄 조회조건과 컬럼 정렬).
  //   금지: 렌더 중 buttonGroups.current.clientWidth 를 직접 읽기.
  //   ref 읽기는 비반응형이라 마지막 렌더 시점의 값이 그대로 굳는다. 비활성 탭은 display:none 으로
  //   남아 있어 그 상태에서 리렌더가 일어나면 0 으로 측정되고, 탭을 다시 열어도 리렌더가 없어
  //   calc(100% - 0px) 가 유지되며 확장조건만 어긋난다.
  //   숨김(0) 측정은 무시하고 마지막 유효 폭을 유지한다.
  useEffect(() => {
    const el = buttonGroups.current;
    if (!el || typeof ResizeObserver === 'undefined') return;

    const measure = () => {
      const width = el.clientWidth;
      if (width > 0) setButtonGroupsWidth(prev => (prev === width ? prev : width));
    };

    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  // 확장 그리드 열을 상단 그리드에 맞춘다.
  //   상단·확장은 '별도 두 CSS Grid'라, Period(periodSplit)처럼 자기 열만 넓어지는 필드가 상단에만
  //   있으면 두 그리드의 트랙폭이 달라져 확장 영역(3행~)이 윗줄과 어긋난다(DMF0082 신고). 상단 그리드의
  //   '실측 트랙폭(computed grid-template-columns, px)'을 확장 그리드에 그대로 입혀 열을 맞춘다 —
  //   상단은 Period 열만 넓히는 좁은 1fr 레이아웃을 유지하므로(조회영역이 그리드폭 안에 들어옴),
  //   확장도 같은 폭이 되어 '정렬 + 화면폭 안'을 둘 다 만족한다. 창 크기 변경 시 상단이 1fr 로 다시
  //   풀리므로 ResizeObserver 로 재동기화한다. isCustomExtraCondition 경로는 확장이 Grid 가 아니라
  //   extraGridRef 가 null → 조용히 건너뛴다.
  useLayoutEffect(() => {
    const main = conditionsGridRef.current;
    const extra = extraGridRef.current;
    if (!main || !extra || !isExpanded || typeof ResizeObserver === 'undefined') return;

    const sync = () => {
      const cols = getComputedStyle(main).gridTemplateColumns;
      if (cols && cols !== 'none' && extra.style.gridTemplateColumns !== cols) {
        extra.style.gridTemplateColumns = cols;
      }
    };
    sync();
    const observer = new ResizeObserver(sync);
    observer.observe(main);
    return () => {
      observer.disconnect();
      extra.style.gridTemplateColumns = '';
    };
  }, [isExpanded]);

  const [selectedOption, setSelectedOption] = useState<string>('');

  // 조회 미저장 변경 가드 — 대부분 화면의 실제 조회 진입점은 SubTitle(F5)이 아니라
  //   이 조회 버튼이므로 여기서도 감싼다(SubTitle 의 F5 가드와 동일 규약, 화면 무수정).
  //   조회는 그리드 데이터를 통째로 덮어쓰므로 dirty 면 confirm 후 실행한다.
  const tabId = useTabid();
  const scopeId = useContext(DialogScopeContext);
  const dirtyKey =
    searchDirtyKey ?? (scopeId === null ? tabDirtyKey(tabId) : scopeDirtyKey(scopeId));
  const handleSearchClick = onSearch
    ? () => {
        void confirmIfDirtyKey(dirtyKey, 'search').then(ok => {
          if (ok) onSearch();
        });
      }
    : undefined;

  // F5 = 조회 단축키(앱 전역 규약). 검색 진입점인 SearchArea 가 팝업·메인 화면 모두에서 F5 를 조회로 잇는다.
  //   - 스코프 게이트 isActiveScope(scopeId): 팝업이 열려 있으면 뒤 메인 화면(scopeId===null)은 눌러도
  //     안 나가고 최상위 팝업만 조회된다(팝업끼리도 최상위만).
  //   - MDI 게이트(메인 화면만): 보이는 활성 탭에서만. keep-alive 로 숨은 탭들의 SearchArea 리스너가
  //     동시에 조회하는 것을 막는다(SubTitle 의 offsetParent 가드와 같은 규약).
  //   - 조회는 버튼 클릭과 같은 미저장 변경 가드 경로(handleSearchClick)를 그대로 태운다.
  //   메인 화면 SubTitle 의 기본 F5 는 no-op(브라우저 새로고침만 차단)이라 중복 조회는 없다.
  const rootRef = useRef<HTMLDivElement>(null);
  const searchClickRef = useRef(handleSearchClick);
  searchClickRef.current = handleSearchClick;
  useEffect(() => {
    const handler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key !== 'F5') return;
      if (!useDialogStore.getState().isActiveScope(scopeId)) return;
      // 메인 화면(root)은 보이는 탭에서만 — 숨은 MDI 탭의 동시 조회 방지. 팝업은 최상위 하나뿐이라 무관.
      if (scopeId === null && !rootRef.current?.offsetParent) return;
      const run = searchClickRef.current;
      if (!run) return;
      // 브라우저 새로고침(F5 기본 동작)·상위 리스너(SubTitle 의 no-op F5) 차단.
      keyboardEvent.preventDefault();
      keyboardEvent.stopImmediatePropagation();
      run();
    };
    globalThis.window.addEventListener('keydown', handler, true);
    return () => globalThis.window.removeEventListener('keydown', handler, true);
  }, [scopeId]);

  const buttonGroup = (
    <Box
      display='flex'
      gap={`${size4}px`}
      height={`${size32}px`}
      minWidth='fit-content'
      ref={buttonGroups}
    >
      {onSaveOption && (
        <Button
          size='medium'
          appearance='outlined'
          priority='normal'
          iconComponent={<CommunicationBookmarkIcon appearance='lined' iconSize={20} />}
          onClick={onSaveOption}
        />
      )}
      {onResetCondition && (
        <Button
          size='medium'
          appearance='outlined'
          priority='normal'
          iconComponent={<ControlResetIcon size='default' iconSize={20} />}
          onClick={onResetCondition}
        />
      )}
      {extraButtons}
      {onSearch && (
        <Button
          size='medium'
          appearance='contained'
          priority='normal'
          iconComponent={<FunctionSearchIcon appearance='lined' iconSize={20} />}
          onClick={handleSearchClick}
        >
          {searchButtonLabel}
        </Button>
      )}
      {extraConditions && (
        <Button
          size='medium'
          appearance='contained'
          priority='normal'
          iconComponent={
            <ArrowChevronIcon
              direction={isExpanded ? 'up' : 'down'}
              appearance='single'
              iconSize={20}
            />
          }
          onClick={() => setIsExpanded(prev => !prev)}
        />
      )}
    </Box>
  );

  // isHidden 이어도 언마운트하지 않고 Collapse 로 접는다.
  // → 입력한 검색조건·확장(extraConditions) 상태가 그대로 보존된다.
  //   (접힘 여부 자체는 페이지의 per-tab 영속 스토어가 기억)
  // 조회조건 영역 축소 금지 (flexShrink:0). 세로 flex 컨테이너(팝업 본문/페이지) 안에서
  //   기본값 flex:0 1 auto 이면, 형제 그리드의 flex-basis 가 auto 인 경우 조회 결과가 많아질수록
  //   그리드 기준 크기가 커지며 초과분이 형제에게 비율 분배되어 조회영역이 0 높이로 눌린다.
  //   페이지 화면들이 래퍼 div 에 수동으로 걸던 방어를 컴포넌트로 내재화한 것.
  return (
    <Collapse in={!isHidden} timeout='auto' sx={{ flexShrink: 0 }}>
      <Box ref={rootRef} sx={mergeSx(sx)}>
        {myOptions && (
          <Box
            display='flex'
            alignItems='center'
            gap={`${size4}px`}
            flexWrap='wrap'
            pb={`${size4}px`}
          >
            {myOptions.map(option => (
              <Chip
                key={option}
                type='choice'
                chipText={option}
                size='large'
                selected={selectedOption === option}
                onClick={() => {
                  setSelectedOption(option);
                  onSelectedMyOption?.(option);
                }}
              />
            ))}
          </Box>
        )}
        <Box
          padding={`${size8}px ${size16}px`}
          border={`${size1}px solid ${semantic.color.commonBorderBasic}`}
          bgcolor={semantic.color.commonBgDeep}
          borderRadius={`${size2}px`}
        >
          <Box display='flex' alignItems='flex-end' gap={`${size48}px`}>
            <Grid
              ref={conditionsGridRef}
              container
              columns={12}
              flexGrow={size1}
              sx={CONDITIONS_GRID_LAYOUT_SX}
            >
              {conditions}
            </Grid>
            {aboveSearch ? (
              <Box display='flex' flexDirection='column' alignItems='flex-start' gap={`${size8}px`}>
                <Box display='flex' alignItems='center' height={`${size32}px`}>
                  {aboveSearch}
                </Box>
                {buttonGroup}
              </Box>
            ) : (
              buttonGroup
            )}
          </Box>
          {!isCustomExtraCondition && (
            <Box mt={`${size10}px`} display={isExpanded ? 'block' : 'none'}>
              <Divider sx={{ background: semantic.color.commonBorderBasic }} />
              <Box
                pt={`${size8}px`}
                pr={`${size48}px`}
                width={`calc(100% - ${buttonGroupsWidth}px)`}
              >
                <Grid
                  ref={extraGridRef}
                  container
                  columns={12}
                  flexGrow={size1}
                  sx={CONDITIONS_GRID_LAYOUT_SX}
                >
                  {extraConditions}
                </Grid>
              </Box>
            </Box>
          )}
        </Box>
        {isCustomExtraCondition && (
          <Box mt={`${size10}px`} display={isExpanded ? 'block' : 'none'}>
            {extraConditions}
          </Box>
        )}
      </Box>
    </Collapse>
  );
};
