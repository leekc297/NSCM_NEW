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
import React, { useContext, useEffect, useRef, useState } from 'react';

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

export type SearchAreaProps = BoxProps & {
  searchButtonLabel?: string;
  isHidden?: boolean;
  myOptions?: string[];
  onSearch?: () => void;
  onResetCondition?: () => void;
  onSelectedMyOption?: (val?: string) => void;
  onSaveOption?: () => void;
  conditions?: React.ReactNode;
  extraConditions?: React.ReactNode;
  isCustomExtraCondition?: boolean;
  // Search 버튼 바로 왼쪽에 배치할 화면별 커스텀 액션 버튼 (예: Version Create/Transfer 등).
  extraButtons?: React.ReactNode;
};

export const SearchArea = ({
  searchButtonLabel = '조회',
  isHidden,
  sx,
  myOptions,
  onSearch,
  onResetCondition,
  onSaveOption,
  onSelectedMyOption,
  conditions,
  extraConditions,
  isCustomExtraCondition,
  extraButtons,
}: SearchAreaProps) => {
  const {
    palette: { semantic },
  } = useTheme();
  const { sizesCommon } = $semantic.shared.size;
  const { size1, size2, size4, size8, size10, size16, size24, size32, size48 } = sizesCommon;

  const [isExpanded, setIsExpanded] = useState<boolean>(false);
  const buttonGroups = useRef<HTMLElement>();
  const [buttonGroupsWidth, setButtonGroupsWidth] = useState<number>(0);

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

  const [selectedOption, setSelectedOption] = useState<string>('');

  // 조회 미저장 변경 가드 — 대부분 화면의 실제 조회 진입점은 SubTitle(F5)이 아니라
  //   이 조회 버튼이므로 여기서도 감싼다(SubTitle 의 F5 가드와 동일 규약, 화면 무수정).
  //   조회는 그리드 데이터를 통째로 덮어쓰므로 dirty 면 confirm 후 실행한다.
  const tabId = useTabid();
  const scopeId = useContext(DialogScopeContext);
  const dirtyKey = scopeId === null ? tabDirtyKey(tabId) : scopeDirtyKey(scopeId);
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
              container
              columns={12}
              columnSpacing={`${size24}px`}
              rowSpacing={`${size8}px`}
              flexGrow={size1}
            >
              {conditions}
            </Grid>
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
                  container
                  columnSpacing={`${size24}px`}
                  rowSpacing={`${size8}px`}
                  flexGrow={size1}
                  columns={12}
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
