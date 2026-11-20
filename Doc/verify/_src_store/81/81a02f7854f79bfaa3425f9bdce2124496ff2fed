import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';

import styles from './ColorPickerButton.module.scss';
import { buildThemeGrid, isValidHex, normalizeHex, STANDARD_COLORS } from './colorUtils';
import { getRecentColors, pushRecentColor, subscribeRecent } from './recentColors';

export interface ColorPickerButtonProps {
  /** 현재 색 hex 또는 '' (자동/기본색) */
  value: string;
  onChange: (hex: string) => void;
  title?: string;
  autoColor?: string;
}

const THEME_GRID = buildThemeGrid();

// 팝오버 대략 크기 — 화면 경계에서 접기 위치 계산용.
const POPOVER_W = 220;
const POPOVER_H = 340;

export const ColorPickerButton = ({
  value,
  onChange,
  title,
  autoColor = '#000000',
}: ColorPickerButtonProps) => {
  const [open, setOpen] = useState(false);
  const [pos, setPos] = useState<{ top: number; left: number }>({ top: 0, left: 0 });
  const [hexInput, setHexInput] = useState('');
  const [recent, setRecent] = useState<string[]>(getRecentColors());
  const btnRef = useRef<HTMLButtonElement>(null);
  const popoverRef = useRef<HTMLDivElement>(null);

  // 최근색 스토어 구독 (세션 공유)
  useEffect(() => subscribeRecent(() => setRecent(getRecentColors())), []);

  // 트리거 버튼 기준으로 팝오버 위치 계산 (화면 밖이면 위/왼쪽으로 접기)
  const reposition = () => {
    const el = btnRef.current;
    if (!el) return;
    const r = el.getBoundingClientRect();
    let left = r.left;
    let top = r.bottom + 2;
    if (left + POPOVER_W > window.innerWidth - 8) left = window.innerWidth - POPOVER_W - 8;
    if (left < 8) left = 8;
    if (top + POPOVER_H > window.innerHeight - 8) top = Math.max(8, r.top - POPOVER_H - 2);
    setPos({ top, left });
  };

  // 열려있는 동안 스크롤/리사이즈 시 위치 갱신 + 외부 클릭 닫기
  useEffect(() => {
    if (!open) return;
    reposition();
    const onDocDown = (e: MouseEvent) => {
      const t = e.target as Node;
      if (btnRef.current?.contains(t) || popoverRef.current?.contains(t)) return;
      setOpen(false);
    };
    const onScrollOrResize = () => reposition();
    document.addEventListener('mousedown', onDocDown);
    window.addEventListener('scroll', onScrollOrResize, true);
    window.addEventListener('resize', onScrollOrResize);
    return () => {
      document.removeEventListener('mousedown', onDocDown);
      window.removeEventListener('scroll', onScrollOrResize, true);
      window.removeEventListener('resize', onScrollOrResize);
    };
  }, [open]);

  // 색 선택 — '자동'('')은 최근색에 넣지 않음
  const pick = (hex: string) => {
    onChange(hex);
    if (hex) pushRecentColor(hex);
    setOpen(false);
  };

  const applyHex = () => {
    if (isValidHex(hexInput)) pick(normalizeHex(hexInput));
  };

  const swatch = (color: string, key: string) => (
    <button
      key={key}
      type='button'
      className={styles.gridCell}
      style={{ backgroundColor: color }}
      title={color}
      onClick={() => pick(color)}
    />
  );

  return (
    <div className={styles.root}>
      <button
        ref={btnRef}
        type='button'
        className={styles.swatchBtn}
        title={title ?? 'Color'}
        onClick={() => {
          if (open) {
            setOpen(false);
          } else {
            reposition();
            setOpen(true);
          }
        }}
      >
        <span
          className={value ? styles.swatch : styles.swatchAuto}
          style={{ backgroundColor: value || autoColor }}
        />
        <span className={styles.caret}>▼</span>
      </button>
      {open &&
        createPortal(
          <div ref={popoverRef} className={styles.popover} style={{ top: pos.top, left: pos.left }}>
            <button type='button' className={styles.autoRow} onClick={() => pick('')}>
              <span className={styles.swatchAuto} style={{ backgroundColor: autoColor }} /> 자동
            </button>

            <div className={styles.sectionLabel}>테마 색</div>
            <div className={styles.themeGrid}>
              {THEME_GRID.map((row, ri) => (
                <div key={ri} className={styles.gridRow}>
                  {row.map((color, ci) => swatch(color, `t-${ri}-${ci}`))}
                </div>
              ))}
            </div>

            <div className={styles.sectionLabel}>표준 색</div>
            <div className={styles.gridRow}>
              {STANDARD_COLORS.map((color, ci) => swatch(color, `s-${ci}`))}
            </div>

            {recent.length > 0 && (
              <>
                <div className={styles.sectionLabel}>최근에 사용한 색</div>
                <div className={styles.gridRow}>
                  {recent.map((color, ci) => swatch(color, `r-${ci}`))}
                </div>
              </>
            )}

            <div className={styles.sectionLabel}>다른 색</div>
            <div className={styles.customRow}>
              <input
                type='color'
                className={styles.nativeColor}
                value={normalizeHex(hexInput) || (value ? value : '#000000')}
                onChange={e => pick(normalizeHex(e.target.value))}
                title='다른 색 선택'
              />
              <input
                type='text'
                className={styles.hexInput}
                placeholder='#RRGGBB'
                value={hexInput}
                onChange={e => setHexInput(e.target.value)}
              />
              <button type='button' className={styles.applyBtn} onClick={applyHex}>
                적용
              </button>
            </div>
          </div>,
          document.body
        )}
    </div>
  );
};
