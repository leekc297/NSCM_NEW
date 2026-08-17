import { Checkbox } from '@lges/design-system';
import type { ReactElement } from 'react';
import type { RowComponentProps } from 'react-window';

import styles from './CustomListboxRow.module.scss';

const LISTBOX_PADDING = 8;

export type ListboxGroupHeader = {
  key: number;
  group: string;
  children: ListboxChild[];
};
export type ListboxChild = [ReactElement, string, string, number, boolean];
export type ListboxRow = Array<ListboxGroupHeader | ListboxChild>;

export const CustomListboxRow = ({
  index,
  rowData,
  multiple,
  style,
}: RowComponentProps & {
  rowData: ListboxRow;
  multiple: boolean;
}) => {
  const dataSet = rowData[index];
  const inlineStyle = {
    ...style,
    top: ((style.top as number) ?? 0) + LISTBOX_PADDING,
  };

  if ('children' in dataSet) {
    return (
      <div className={styles.groupHeader} style={inlineStyle} key={dataSet.key}>
        {dataSet.group}
      </div>
    );
  }

  const [{ key, ...optionProps }, , childLabel, , selected] = dataSet;

  // optionProps(MUI 옵션 props)에 className(MuiAutocomplete-option)이 들어있어
  // 스프레드가 styles.childItem 을 덮어썼다 → nowrap/ellipsis 가 적용 안 돼 긴 라벨이
  // 2줄로 줄바꿈되고 행 높이가 react-window 고정 높이(ITEM_SIZE=36)를 넘겼다.
  // className 을 스프레드 뒤에서 병합해 childItem(한 줄 고정)이 살아남게 한다.
  const { className: optionClassName, ...restOptionProps } = optionProps as {
    className?: string;
  } & Record<string, unknown>;

  return (
    <li
      {...restOptionProps}
      className={[optionClassName, styles.childItem].filter(Boolean).join(' ')}
      style={inlineStyle}
      key={key}
    >
      {multiple && <Checkbox checked={selected} />}
      {childLabel}
    </li>
  );
};
