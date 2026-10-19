import { useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';

import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import styles from './CascadeDropdown.module.scss';

// 계층 선택지 트리 노드 — value/label 과 선택 시 펼쳐질 하위(children).
//   children 이 없으면 잎(최종 선택)이다.
export interface CascadeNode {
  value: string;
  label: string;
  children?: CascadeNode[];
}

// 단계 정의 — 다른 검색조건처럼 name(값이 담길 키)과 label(화면 표시)을 나눈다.
//   예: { name: 'level1', label: '1단계' } → 선택값은 level1 키에 담기고 라벨은 '1단계'.
export interface CascadeLevel {
  name: string;
  label: string;
  // 필수 입력 표시(라벨 *). 표준 콤보와 동일하게 FormItem 이 그린다.
  required?: boolean;
}

export interface CascadeDropdownProps {
  // 계층 선택지 트리.
  tree: CascadeNode[];
  // 단계 목록(순서 = 열 순서). 각 단계의 name 키로 선택값이 담긴다.
  levels: CascadeLevel[];
  // 선택값(name 키 객체). 주면 controlled, 안 주면 내부 상태(uncontrolled)로 동작한다.
  value?: Record<string, string>;
  // 선택이 바뀔 때마다 확정값(name 키 객체)을 돌려준다.
  onChange?: (value: Record<string, string>) => void;
  // 미선택 필드에 표시할 placeholder.
  placeholder?: string;
  // 레이아웃 — 기본은 검색영역과 동일(Grid size=3 + columnSpacing 24px / rowSpacing 8px).
  //   필드와 팝업 열이 같은 그리드라 각 열이 대응 필드 바로 아래에 정렬된다.
  gridSize?: number;
  columnSpacing?: string;
  rowSpacing?: string;
  // 라벨 배치 — FormItem 과 동일. 검색영역의 표준 콤보처럼 쓰려면 variant='horizontal' + labelAlign='right'
  //   + formItemClassName={commonStyles.formItem}(라벨 컬럼 폭 통일) 를 넘긴다. 기본은 세로(라벨 위).
  variant?: 'horizontal' | 'vertical';
  labelAlign?: 'left' | 'right';
  formItemClassName?: string;
}

const DEFAULT_GRID_SIZE = 3;
const DEFAULT_COLUMN_SPACING = '24px';
const DEFAULT_ROW_SPACING = '8px';

/**
 * 종속 콤보(공유 캐스케이더) — 1~N단계 필드를 항상 나란히 보여주되, 어느 필드를 누르든 같은
 * 액션(하나의 컬럼 팝업)이 열린다. 팝업에서 경로를 골라 내려가면 각 단계 필드가 함께 채워지고,
 * 상위를 다시 고르면 하위는 초기화된다. 값은 name 키 객체({ level1, level2, ... })로 담긴다.
 *
 * 데이터 모양만 { value, label, children } 트리로 맞추면 어느 화면에서든 쓸 수 있다
 * (플랫 콤보 행이면 상위-하위 키 컬럼으로 트리를 만들어 넘긴다).
 */
export const CascadeDropdown = ({
  tree,
  levels,
  value: valueProp,
  onChange,
  placeholder = '선택',
  gridSize = DEFAULT_GRID_SIZE,
  columnSpacing = DEFAULT_COLUMN_SPACING,
  rowSpacing = DEFAULT_ROW_SPACING,
  variant = 'vertical',
  labelAlign,
  formItemClassName,
}: CascadeDropdownProps) => {
  const rootRef = useRef<HTMLDivElement>(null);
  // 각 단계 필드 버튼(라벨 제외한 박스)의 ref — 팝업 열을 그 박스 바로 아래에 같은 폭으로 맞추기
  //   위한 측정용(가로 레이아웃의 라벨폭을 하드코딩하지 않고 실제 위치를 잰다).
  const fieldBtnRefs = useRef<(HTMLButtonElement | null)[]>([]);
  // 측정된 팝업 열 위치(rootRef 기준 left)·폭. 미측정 시 셀 전체(기존 동작)로 폴백.
  const [popupCols, setPopupCols] = useState<{ left: number; width: number }[]>([]);
  const [internalValue, setInternalValue] = useState<Record<string, string>>({});
  // value 를 주면 controlled, 아니면 내부 상태.
  const value = valueProp ?? internalValue;
  const [open, setOpen] = useState(false);
  // 팝업에서 지금 펼쳐 둔 경로(깊이 배열) — 어느 열까지 보일지를 정한다.
  const [activePath, setActivePath] = useState<string[]>([]);

  const commit = (next: Record<string, string>) => {
    if (valueProp === undefined) setInternalValue(next);
    onChange?.(next);
  };

  // 단계별 선택지 — 상위(0..i-1) 확정값을 따라 트리를 내려가며 구한다(각 필드 표시 라벨용).
  const optionsByLevel = useMemo(() => {
    const result: { value: string; label: string }[][] = [];
    let nodes: CascadeNode[] | undefined = tree;
    for (const level of levels) {
      result.push((nodes ?? []).map(node => ({ value: node.value, label: node.label })));
      const picked: CascadeNode | undefined = nodes?.find(node => node.value === value[level.name]);
      nodes = picked?.children;
    }
    return result;
  }, [tree, levels, value]);

  // value(name 키 객체)를 깊이 배열로 — 팝업 열 때 현재 선택에서 다시 시작하기 위함.
  const valuePath = useMemo(() => {
    const path: string[] = [];
    for (const level of levels) {
      const picked = value[level.name];
      if (!picked) break;
      path.push(picked);
    }
    return path;
  }, [value, levels]);

  // 팝업에 펼쳐 보일 열들 — activePath 를 따라 내려가며 자식이 있는 동안 열을 이어 붙인다.
  const columns = useMemo(() => {
    const result: CascadeNode[][] = [tree];
    let nodes: CascadeNode[] | undefined = tree;
    for (let level = 0; level < activePath.length; level++) {
      const picked: CascadeNode | undefined = nodes?.find(node => node.value === activePath[level]);
      if (!picked?.children?.length) break;
      result.push(picked.children);
      nodes = picked.children;
    }
    return result;
  }, [tree, activePath]);

  // 바깥을 누르면 닫는다. 캡처 단계로 등록 — Wijmo 그리드처럼 mousedown 을 자체 처리(캡처 단계
  //   preventDefault/stopPropagation)하는 컴포넌트 위를 눌러도, document 캡처 리스너가 전파 최상위에서
  //   가장 먼저 실행되므로 안전하게 닫힌다(버블 단계면 그리드가 가로채 안 닫히던 문제).
  useEffect(() => {
    if (!open) return;
    const onDown = (event: MouseEvent) => {
      if (!rootRef.current?.contains(event.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onDown, true);
    return () => document.removeEventListener('mousedown', onDown, true);
  }, [open]);

  // 팝업을 열 때 각 필드 박스의 실제 위치(rootRef 기준)·폭을 측정해 팝업 열에 반영한다. paint 전에
  //   실행(useLayoutEffect)되므로 깜빡임 없이 버튼 바로 아래에 같은 폭으로 뜬다. 라벨폭을 가정하지 않는다.
  useLayoutEffect(() => {
    if (!open || !rootRef.current) return;
    const rootLeft = rootRef.current.getBoundingClientRect().left;
    setPopupCols(
      levels.map((_, i) => {
        const btn = fieldBtnRefs.current[i];
        if (!btn) return { left: 0, width: 0 };
        const r = btn.getBoundingClientRect();
        return { left: r.left - rootLeft, width: r.width };
      })
    );
  }, [open, levels]);

  // 어느 단계 필드를 눌러도 같은 액션 — 현재 확정값에서 시작해 팝업을 연다.
  const openPicker = () => {
    setActivePath(valuePath);
    setOpen(prev => !prev);
  };

  const handlePick = (colIndex: number, node: CascadeNode) => {
    const next = activePath.slice(0, colIndex).concat(node.value);
    setActivePath(next);
    // 고른 즉시 각 단계 필드에 반영되도록 name 키 객체로 확정한다(하위는 비워진다).
    const committed: Record<string, string> = {};
    next.forEach((picked, i) => {
      const level = levels[i];
      if (level) committed[level.name] = picked;
    });
    commit(committed);
    // 잎이면 닫고, 자식이 있으면 다음 열을 펼친 채 선택을 더 받는다.
    if (!node.children?.length) setOpen(false);
  };

  return (
    <div ref={rootRef} style={{ position: 'relative' }}>
      <Grid container columnSpacing={columnSpacing} rowSpacing={rowSpacing}>
        {levels.map((level, index) => {
          const selectedLabel = optionsByLevel[index]?.find(
            opt => opt.value === value[level.name]
          )?.label;
          return (
            <Grid size={gridSize} key={level.name}>
              {/* 라벨은 표준 콤보와 동일하게 FormItem 이 그린다. variant/labelAlign/className 으로 검색영역
                  표준 콤보(라벨 좌측·140px 폭)와 맞출 수 있다. */}
              <FormItem
                variant={variant}
                labelAlign={labelAlign}
                className={formItemClassName}
                label={level.label}
                required={level.required}
                render={() => (
                  <button
                    ref={el => {
                      fieldBtnRefs.current[index] = el;
                    }}
                    type='button'
                    onClick={openPicker}
                    style={{
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                      width: '100%',
                      // 표준 CustomDropdown 필드와 높이(36px)·폰트를 맞춘다. 네이티브 button 은 폰트를
                      //   상속하지 않으므로 디자인시스템 폰트(body = Spoqa Han Sans Neo)·사이즈를 명시한다.
                      height: '36px',
                      boxSizing: 'border-box',
                      padding: '0 10px',
                      border: '1px solid #ccc',
                      borderRadius: '4px',
                      background: '#fff',
                      fontFamily: 'inherit',
                      fontSize: '13px',
                      fontWeight: 400,
                      lineHeight: 'normal',
                      overflow: 'hidden',
                      cursor: 'pointer',
                      color: selectedLabel ? '#1f1f1f' : '#999',
                    }}
                  >
                    {/* 표준 콤보처럼 단일 행·좌측정렬, 넘치면 … 로 자른다(줄바꿈 금지). */}
                    <span
                      style={{
                        flex: 1,
                        minWidth: 0,
                        textAlign: 'left',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                    >
                      {selectedLabel ?? placeholder}
                    </span>
                    <span style={{ color: '#aaa', flexShrink: 0, marginLeft: 4 }}>▾</span>
                  </button>
                )}
              />
            </Grid>
          );
        })}
      </Grid>

      {open && (
        <div
          style={{
            position: 'absolute',
            top: 'calc(100% + 4px)',
            left: 0,
            width: '100%',
            zIndex: 10,
          }}
        >
          {columns.map((nodes, colIndex) => {
            // 각 열은 대응 필드 박스(fieldBtnRefs[colIndex]) 왼쪽에 맞춰 띄운다(좌측 고정). 폭은 필드
            //   박스를 하한으로 두되 내용이 길면 그 길이에 맞춰 오른쪽으로 넓어진다(예: Plan Date 날짜).
            //   미측정 시 폴백(left 0 · 내용폭).
            const geom = popupCols[colIndex];
            return (
              // 열은 단계(level) 순서로 고정이라 그 단계 name 을 key 로 쓴다.
              <div
                key={levels[colIndex]?.name ?? colIndex}
                className={styles.menu}
                style={{
                  position: 'absolute',
                  top: 0,
                  left: geom?.left ?? 0,
                  minWidth: geom?.width,
                  width: 'max-content',
                  maxWidth: 'min(420px, 90vw)',
                }}
              >
                <ul className={styles.list}>
                  {nodes.map(node => {
                    const active = activePath[colIndex] === node.value;
                    return (
                      <li key={node.value}>
                        <button
                          type='button'
                          onClick={() => handlePick(colIndex, node)}
                          className={[styles.item, active && styles.itemActive]
                            .filter(Boolean)
                            .join(' ')}
                        >
                          <span className={styles.itemLabel}>{node.label}</span>
                        </button>
                      </li>
                    );
                  })}
                </ul>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
