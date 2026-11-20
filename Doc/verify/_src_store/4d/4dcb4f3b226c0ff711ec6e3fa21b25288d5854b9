import type { AutocompleteProps } from '@mui/material';
import { Autocomplete, TextField } from '@mui/material';

import { IcCheckBlack, IcCheckbox } from '@foundation/assets';

// 1. 단일 선택용 Props
interface SingleProps<T> extends Omit<
  AutocompleteProps<T, boolean, boolean, boolean>,
  'multiple' | 'onChange' | 'renderInput'
> {
  multiple?: false;
  onChange?: (event: React.SyntheticEvent, value: T | null) => void;
}

// 2. 다중 선택용 Props
interface MultipleProps<T> extends Omit<
  AutocompleteProps<T, boolean, boolean, boolean>,
  'multiple' | 'onChange' | 'renderInput'
> {
  multiple: true;
  onChange?: (event: React.SyntheticEvent, value: T[]) => void;
}

// export const CustomDropdownMui = ({ ...props }: SingleProps<Lookup> | MultipleProps<Lookup>) => {
export const CustomDropdownMui = ({ ...props }: SingleProps<Lookup> | MultipleProps<Lookup>) => {
  return (
    <Autocomplete<Lookup>
      size='small'
      disableCloseOnSelect
      getOptionLabel={option => option.NAME}
      renderOption={(props, option, { selected }) => {
        const { key, ...optionProps } = props;
        const SelectionIcon = selected ? IcCheckBlack : IcCheckbox;

        return (
          <li key={key} {...optionProps}>
            <SelectionIcon fontSize='small' style={{ boxSizing: 'content-box' }} />
            {option.NAME}
          </li>
        );
      }}
      renderInput={params => <TextField {...params} variant='filled' />}
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      {...(props as any)}
    />
  );
};
