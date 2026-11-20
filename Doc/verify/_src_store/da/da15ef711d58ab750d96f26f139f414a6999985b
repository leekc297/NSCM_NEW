import { forwardRef, useEffect, useMemo } from 'react';
import type { FocusEvent, HTMLAttributes, KeyboardEvent, Ref } from 'react';
import { List, type ListImperativeAPI } from 'react-window';

import styles from './CustomListbox.module.scss';
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
  /**
   * 팝업 안 전용 검색칸. CustomDropdown 이 다중 선택일 때만 넘긴다(AS-IS 콤보와 같은 배치).
   * searchValue 가 undefined 면 검색줄을 아예 그리지 않는다 - 단일 선택은 종전대로
   * 필드 입력창이 곧 검색칸이라 여기에 또 만들 이유가 없다.
   */
  searchValue?: string;
  // 검색칸 DOM. CustomDropdown 이 포커스를 되돌릴 때 쓴다(그쪽 handleFocusCapture 참조).
  searchInputRef?: Ref<HTMLInputElement>;
  onSearchChange?: (value: string) => void;
  onSearchKeyDown?: (event: KeyboardEvent<HTMLInputElement>) => void;
  onSearchBlur?: (event: FocusEvent<HTMLInputElement>) => void;
  searchPlaceholder?: string;
}

// CustomDropdown 이 blur 판정에 쓰는 표식. 필드 입력창의 blur 를 막을지,
// 검색칸의 blur 로 목록을 닫을지 가르는 기준이라 양쪽이 같은 값을 봐야 한다.
export const DROPDOWN_SEARCH_ATTR = 'data-dropdown-search';

export const CustomListbox = forwardRef<HTMLDivElement, CustomListboxProps>(
  (props: CustomListboxProps, ref) => {
    const isGroupHeader = (item: ListboxGroupHeader | ListboxChild): item is ListboxGroupHeader => {
      return 'children' in item && !Array.isArray(item);
    };

    const {
      children,
      internalListRef,
      onOptionsBuilt,
      multiple,
      searchValue,
      searchInputRef,
      onSearchChange,
      onSearchKeyDown,
      onSearchBlur,
      searchPlaceholder,
      ...other
    } = props;
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
        {searchValue !== undefined && (
          // 필수: 마우스다운을 여기서 끊는다.
          //   MUI getListboxProps().onMouseDown 이 event.preventDefault() 라서, 그대로 두면
          //   상위(리스트박스 루트 div)까지 올라가 기본동작이 막히고 클릭으로 포커스가 안 잡힌다.
          // role='presentation': 바깥 div 가 role='listbox' 라 그 안의 입력칸을 옵션으로 읽지 않게 한다.
          <div
            className={styles.searchRow}
            role='presentation'
            onMouseDown={event => event.stopPropagation()}
          >
            <input
              // autoFocus: 목록이 열릴 때 바로 칠 수 있어야 한다. 팝업은 닫히면 언마운트되므로
              //   열 때마다 새로 마운트되어 매번 동작한다.
              // 주의: 이것만으로는 부족하다. 목록을 여는 클릭의 click 단계에서 MUI 가
              //   필드 입력창으로 포커스를 도로 가져간다 - CustomDropdown 이 되돌려 준다.
              autoFocus
              ref={searchInputRef}
              className={styles.searchInput}
              value={searchValue}
              placeholder={searchPlaceholder}
              aria-label={searchPlaceholder}
              onChange={event => onSearchChange?.(event.target.value)}
              onKeyDown={onSearchKeyDown}
              onBlur={onSearchBlur}
              {...{ [DROPDOWN_SEARCH_ATTR]: '1' }}
            />
          </div>
        )}
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
          rowProps={{ rowData: rowData, multiple: multiple }}
          overscanCount={5}
          tagName='ul'
        />
      </div>
    );
  }
);
