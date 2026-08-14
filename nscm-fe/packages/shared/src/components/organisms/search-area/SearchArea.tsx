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
import React, { useContext, useRef, useState } from 'react';

import {
  confirmIfDirtyKey,
  DialogScopeContext,
  scopeDirtyKey,
  tabDirtyKey,
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
  const { minWidthSearchAreaContainer, sizesCommon } = $semantic.shared.size;
  const { size1, size2, size4, size8, size10, size16, size24, size32, size48 } = sizesCommon;

  const [isExpanded, setIsExpanded] = useState<boolean>(false);
  const buttonGroups = useRef<HTMLElement>();

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

  // isHidden 이어도 언마운트하지 않고 Collapse 로 접는다.
  // → 입력한 검색조건·확장(extraConditions) 상태가 그대로 보존된다.
  //   (접힘 여부 자체는 페이지의 per-tab 영속 스토어가 기억)
  return (
    <Collapse in={!isHidden} timeout='auto'>
      <Box minWidth={`${minWidthSearchAreaContainer}px`} width='100%' sx={mergeSx(sx)}>
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
                width={`calc(100% - ${buttonGroups?.current?.clientWidth}px)`}
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
