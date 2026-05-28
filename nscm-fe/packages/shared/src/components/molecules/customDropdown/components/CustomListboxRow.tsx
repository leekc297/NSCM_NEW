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

  return (
    <li className={styles.childItem} style={inlineStyle} key={key} {...optionProps}>
      {multiple && <Checkbox checked={selected} />}
      {childLabel}
    </li>
  );
};
