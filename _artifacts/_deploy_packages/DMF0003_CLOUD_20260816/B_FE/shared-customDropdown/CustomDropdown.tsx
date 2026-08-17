import { Chip, DropdownField } from '@lges/design-system';
import type { DropdownFieldProps, DropdownOption } from '@lges/design-system';
import type { AutocompleteChangeDetails, AutocompleteChangeReason } from '@mui/material';
import { autocompleteClasses, Popper } from '@mui/material';
import { styled } from '@mui/material/styles';
import { useCallback, useRef } from 'react';
import type { SyntheticEvent } from 'react';
import { useListRef } from 'react-window';

import { CustomListbox } from './components/CustomListbox';
import type { CustomListboxProps } from './components/CustomListbox';
import type { ListboxChild } from './components/CustomListboxRow';
import styles from './CustomDropdownMui.module.scss';

const StyledPopper = styled(Popper)({
  [`& .${autocompleteClasses.listbox}`]: {
    boxSizing: 'border-box',
    '& ul': {
      padding: 0,
      margin: 0,
    },
    '& li': {
      gap: '5px',
    },
  },
});

interface SingleProps<T> extends Omit<DropdownFieldProps<T>, 'multiple' | 'onChange' | 'value'> {
  multiple?: false;
  allOption?: boolean;
  value?: string;
  onChange?: (event: React.SyntheticEvent, value: string) => void;
}

// 2. 다중 선택용 Props
interface MultipleProps<T> extends Omit<DropdownFieldProps<T>, 'multiple' | 'onChange' | 'value'> {
  multiple: true;
  allOption?: boolean;
  value?: string;
  onChange?: (event: React.SyntheticEvent, value: string) => void;
}

const SELECT_ALL_OPTION = {
  value: '',
  label: 'SELECT ALL',
};

const SINGLE_ALL_OPTION = {
  value: '',
  label: 'ALL',
};

/**
 * ⭐ [2026-08-16] 콤보 옵션 **중복 제거** — 전 화면 일괄 적용 지점.
 *
 * Lookup/CMBO 계열 SQL 은 화면 표시용 CODE/NAME 외에 cascade 용 부가 컬럼
 * (DIVISION_ID·DEPT_ID·END_CUSTOMER …)을 함께 반환한다. 그래서 **같은 CODE 가
 * 부가 컬럼 값마다 여러 행**으로 온다(실측: SCM_MST_SITE 의 END_CUSTOMER 'LGESMI'
 * = 8행/5부서). 화면이 그 행을 그대로 옵션으로 만들면 드롭다운에 같은 값이 여러 번 뜬다
 * (사용자 신고 2026-08-16 — 클라우드 DMF0003 조회조건 End Customer 에 'LGE' 2회).
 *
 * ⚠ 데이터 계층(useTabComboQueries/apiClient)에서 지우면 **cascade 가 깨진다** —
 *   부가 컬럼별 행이 하위 콤보를 좁히는 근거이기 때문. 그래서 **표시 직전인 여기**에서만
 *   value 기준으로 first-wins 합친다(행 데이터는 그대로 보존).
 * value 는 코드값이라 앞뒤 공백 변형도 같은 값으로 본다(TRIM 후 비교).
 */
const dedupeOptions = <T extends { value: string; label?: unknown }>(opts: T[]): T[] => {
  const seen = new Map<string, T>();
  for (const o of opts) {
    const key = String(o?.value ?? '').trim();
    if (!seen.has(key)) seen.set(key, o);
  }
  return seen.size === opts.length ? opts : [...seen.values()];
};

export const CustomDropdown = ({
  options: rawOptions,
  value,
  onChange,
  // 앱 표준: 칩 1개 + "+N". 명시적으로 넘기지 않은 화면(구 default 2)도 일관되게 맞춘다.
  // 2개 이상 노출이 필요한 곳은 limitTags 를 직접 지정한다(예: Templates 데모).
  limitTags = 1,
  allOption,
  ...props
}: SingleProps<DropdownOption> | MultipleProps<DropdownOption>) => {
  const internalListRef = useListRef(null);
  const optionIndexMapRef = useRef<Map<string, number>>(new Map());
  const lastIndexRef = useRef<number | null>(null);

  // 표시 직전 중복 제거 (위 dedupeOptions 주석 참조 — 중복 없으면 원본 참조 그대로 반환)
  const options = dedupeOptions(rawOptions);

  // const splitValueSet = new Set(value?.trim().split(',') ?? []);
  const splitValueSet = new Set(value?.trim().split(',').filter(Boolean) ?? []);

  // TODO: 성능 개선 필요해보임, mockHeavyDropdown 기준 버벅거림 있음 - 강민재
  const isAllSelected = splitValueSet.size > 0 && splitValueSet.size === options.length;

  const allOptionEntry = props.multiple ? SELECT_ALL_OPTION : SINGLE_ALL_OPTION;
  const optionsWithAll = allOption ? [allOptionEntry, ...options] : options;
  const singleValue =
    allOption && value === 'ALL'
      ? SINGLE_ALL_OPTION
      : optionsWithAll.find(opt => opt.value === value);

  const multipleValue =
    isAllSelected && allOption
      ? optionsWithAll
      : options.filter(opt => splitValueSet.has(opt.value));
  const dropdownValue = props.multiple ? multipleValue : singleValue;

  const handleOptionsBuilt = useCallback((optionIndexMap: Map<string, number>) => {
    optionIndexMapRef.current = optionIndexMap;
  }, []);

  const handleHighlightChange = (_: SyntheticEvent, option: Lookup | null) => {
    if (!option || !internalListRef.current) return;

    const index = optionIndexMapRef.current.get(option.CODE);

    if (!index) return;
    if (lastIndexRef.current === index) return;

    lastIndexRef.current = index;
    internalListRef.current.scrollToRow({ index: index, align: 'auto' });
  };

  const handleSelectAll = (
    newValue: DropdownOption[],
    reason: AutocompleteChangeReason,
    details?: AutocompleteChangeDetails<DropdownOption>
  ) => {
    const clickedOptionValue = details?.option.value;
    if (
      (reason !== 'selectOption' && reason !== 'removeOption') ||
      dropdownValue === undefined ||
      // SELECT ALL 옵션의 value 는 빈 문자열('')이라 !clickedOptionValue 로 거르면 안 된다.
      // (옵션 클릭이 없을 때만, 즉 details 미존재일 때만 통과)
      clickedOptionValue === undefined
    )
      return newValue;

    if (clickedOptionValue === SELECT_ALL_OPTION.value) {
      if (reason === 'selectOption') return options;
      else return [SELECT_ALL_OPTION];
    }

    return newValue.filter(opt => opt.value !== SELECT_ALL_OPTION.value);
  };

  const handleMultipleChange = (
    event: SyntheticEvent<Element, Event>,
    value: DropdownOption[],
    reason: AutocompleteChangeReason,
    details?: AutocompleteChangeDetails<DropdownOption>
  ) => {
    if (value.length === 0) {
      onChange?.(event, 'ALL');
      return;
    }
    if (allOption) {
      const nextValue = handleSelectAll(value, reason, details);
      onChange?.(event, nextValue.map(item => item.value).toString());
    } else onChange?.(event, value.map(item => item.value).toString());
  };

  return (
    <DropdownField<DropdownOption>
      className={styles.customDropdown}
      disableListWrap
      options={optionsWithAll}
      value={dropdownValue}
      placeholder={props.placeholder ?? (props.multiple ? 'ALL' : undefined)}
      onChange={
        props.multiple
          ? handleMultipleChange
          : (event, value: DropdownOption) => onChange?.(event, value.value)
      }
      limitTags={limitTags}
      /**
       * TODO: List box 내에서 그룹핑 필요할 경우 사용 - 강민재
       * groupBy={option => option.label[0].toUpperCase()}
       * renderGroup={params => params as unknown as ReactNode}
       */
      renderTags={(selectedRows, getTagProps) => {
        const rowsWithoutAll = selectedRows.filter(row => row.value !== SELECT_ALL_OPTION.value);
        const visibleChips = rowsWithoutAll.slice(0, limitTags ?? undefined);
        const hiddenCount = rowsWithoutAll.length - visibleChips.length;

        return (
          <>
            {visibleChips.map((option, index) => {
              const valueIndex = isAllSelected ? index + 1 : index;
              const { key, ...itemProps } = getTagProps({ index: valueIndex });

              return (
                // span 래퍼: 남는 폭에 맞춰 줄고(flex), hover 시 전체 라벨 툴팁(title).
                <span key={key} className={styles.chipClip} title={option.label}>
                  <Chip
                    {...itemProps}
                    sx={{
                      minWidth: 0,
                      overflow: 'hidden',
                      // 칩 내부 Box/Typography 가 줄어들며 라벨을 …로 자르게 한다.
                      '& .MuiBox-root': { minWidth: 0 },
                      '& .MuiTypography-root': {
                        display: 'block',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      },
                    }}
                    chipText={option.label}
                    size='small'
                    type='input'
                    deletable
                  />
                </span>
              );
            })}

            {hiddenCount > 0 && (
              <Chip
                size='small'
                type='input'
                chipText={`+${hiddenCount}`}
                sx={{
                  // 항상 온전히 보이도록 축소 금지(+N 은 절대 잘리지 않는다).
                  flexShrink: 0,
                  pointerEvents: 'none',
                }}
              />
            )}
          </>
        );
      }}
      renderOption={(props, option, state) =>
        [{ ...props }, option.value, option.label, state.index, state.selected] as ListboxChild
      }
      onHighlightChange={handleHighlightChange}
      slots={{
        popper: StyledPopper,
      }}
      slotProps={{
        listbox: {
          component: CustomListbox,
          internalListRef: internalListRef,
          onOptionsBuilt: handleOptionsBuilt,
          multiple: props.multiple,
        } as CustomListboxProps,
      }}
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      {...(props as any)}
    />
  );
};
