import { forwardRef, useEffect, useMemo } from 'react';
import type { HTMLAttributes, Ref } from 'react';
import { List, type ListImperativeAPI } from 'react-window';

import {
  CustomListboxRow,
  type ListboxChild,
  type ListboxGroupHeader,
  type ListboxRow,
} from './CustomListboxRow';

const LISTBOX_PADDING = 8;
const GROUP_HEADER_SIZE = 48;
const ITEM_SIZE = 36;
const MAX_VISIBLE_ROW = 8;

export interface CustomListboxProps extends HTMLAttributes<HTMLElement> {
  internalListRef: Ref<ListImperativeAPI>;
  onOptionsBuilt: (optionIndexMap: Map<string, number>) => void;
  multiple: boolean;
}

export const CustomListbox = forwardRef<HTMLDivElement, CustomListboxProps>(
  (props: CustomListboxProps, ref) => {
    const isGroupHeader = (item: ListboxGroupHeader | ListboxChild): item is ListboxGroupHeader => {
      return 'children' in item && !Array.isArray(item);
    };

    const { children, internalListRef, onOptionsBuilt, ...other } = props;
    const rowData: ListboxRow = [];
    const optionIndexMap = useMemo(() => new Map<string, number>(), []);

    (children as ListboxRow).forEach(item => {
      rowData.push(item);
      if (isGroupHeader(item)) rowData.push(...item.children);
    });

    rowData.forEach((item, index) => {
      if (Array.isArray(item) && item[1]) optionIndexMap.set(item[1], index);
    });

    const itemCount = rowData.length;
    const itemSize = ITEM_SIZE;

    const getChildSize = (child: ListboxRow[number]) => {
      if (isGroupHeader(child)) return GROUP_HEADER_SIZE;
      return itemSize;
    };

    const getHeight = () => {
      if (itemCount > MAX_VISIBLE_ROW) return MAX_VISIBLE_ROW * itemSize;
      return rowData.map(getChildSize).reduce((a, b) => a + b, 0);
    };

    useEffect(() => {
      onOptionsBuilt?.(optionIndexMap);
    }, [onOptionsBuilt, optionIndexMap]);

    const { className, style, ...otherProps } = other;

    return (
      <div ref={ref} {...otherProps}>
        <List
          className={className}
          style={{
            ...style,
            height: getHeight() + 2 * LISTBOX_PADDING,
          }}
          key={itemCount}
          listRef={internalListRef}
          rowCount={itemCount}
          rowHeight={index => getChildSize(rowData[index])}
          rowComponent={CustomListboxRow}
          rowProps={{ rowData: rowData, multiple: props.multiple }}
          overscanCount={5}
          tagName='ul'
        />
      </div>
    );
  }
);
