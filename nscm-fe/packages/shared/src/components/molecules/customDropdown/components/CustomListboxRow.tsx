import { Checkbox, Tooltip } from '@lges/design-system';
import { useRef, useState, type MouseEvent, type ReactElement } from 'react';
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
  const labelRef = useRef<HTMLSpanElement>(null);
  // 잘린 라벨에만 툴팁을 띄운다. disableHoverListener 로 거르면 상태 반영이
  // 한 박자 늦어 첫 hover 를 놓치므로 open 을 직접 제어한다.
  const [tooltipOpen, setTooltipOpen] = useState(false);

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

  // 라벨 span 과 행 li 를 둘 다 본다. 어느 쪽이 넘치는지는 MUI 옵션 스타일이
  // 행을 flex 로 만드는지에 따라 갈리므로 한쪽만 재면 놓친다.
  const handleMouseEnter = (event: MouseEvent<HTMLLIElement>) => {
    const label = labelRef.current;
    const row = event.currentTarget;
    const overflowed =
      (!!label && label.scrollWidth > label.clientWidth) || row.scrollWidth > row.clientWidth;
    if (overflowed) setTooltipOpen(true);
  };

  const handleMouseLeave = () => setTooltipOpen(false);

  return (
    <Tooltip
      open={tooltipOpen}
      title={childLabel}
      placement='right'
      disableFocusListener
      disableTouchListener
    >
      <li
        {...restOptionProps}
        className={[optionClassName, styles.childItem].filter(Boolean).join(' ')}
        style={inlineStyle}
        key={key}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
      >
        {multiple && <Checkbox checked={selected} />}
        <span ref={labelRef} className={styles.childLabel}>
          {childLabel}
        </span>
      </li>
    </Tooltip>
  );
};
