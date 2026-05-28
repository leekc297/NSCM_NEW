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

export const CustomDropdown = ({
  options,
  value,
  onChange,
  limitTags = 2,
  allOption,
  ...props
}: SingleProps<DropdownOption> | MultipleProps<DropdownOption>) => {
  const internalListRef = useListRef(null);
  const optionIndexMapRef = useRef<Map<string, number>>(new Map());
  const lastIndexRef = useRef<number | null>(null);

  const splitValueSet = new Set(value?.trim().split(',') ?? []);

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
      !clickedOptionValue
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
                <Chip
                  key={key}
                  {...itemProps}
                  sx={{ overflow: 'hidden' }}
                  chipText={option.label}
                  size='small'
                  type='input'
                  deletable
                />
              );
            })}

            {hiddenCount > 0 && (
              <Chip
                size='small'
                type='input'
                chipText={`+${hiddenCount}`}
                sx={{
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
