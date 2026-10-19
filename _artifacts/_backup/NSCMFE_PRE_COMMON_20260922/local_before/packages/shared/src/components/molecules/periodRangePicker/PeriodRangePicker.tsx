import { ClickAwayListener, IconButton, Menu, MenuItem, Popper } from '@mui/material';
import dayjs, { type Dayjs } from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import { useMemo, useRef, useState } from 'react';

import { clsx } from '@shared/clsx';
import { FormItem } from '@shared/lges';
import { ArrowChevron2Icon, FunctionCalendarIcon } from '@shared/lges-icons';
import { Button } from '@shared/mui';

import styles from './PeriodRangePicker.module.scss';

dayjs.extend(isoWeek);

const VALUE_FORMAT = 'YYYYMMDD';
const DISPLAY_FORMAT = 'YYYY-MM-DD';
const DOW_LABELS = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

interface PeriodRangePickerProps {
  start: string;
  end: string;
  onChange: (start: string, end: string) => void;
  label?: string;
  required?: boolean;
}

const parseValue = (value: string): Dayjs | null => {
  if (!value || value.length !== 8) return null;
  const parsed = dayjs(value, VALUE_FORMAT);
  return parsed.isValid() ? parsed : null;
};

const weekLabel = (day: Dayjs): string =>
  `${day.isoWeekYear()}${String(day.isoWeek()).padStart(2, '0')}`;

// 화면에 보이는 6행 고정 월 그리드. 월요일 시작(WEEK 컬럼)이 이미지 As-Is 기준과 동일.
const buildMonthWeeks = (monthCursor: Dayjs): Dayjs[][] => {
  const gridStart = monthCursor.startOf('month').startOf('isoWeek');
  const weeks: Dayjs[][] = [];
  let cursor = gridStart;
  for (let w = 0; w < 6; w += 1) {
    const week: Dayjs[] = [];
    for (let d = 0; d < 7; d += 1) {
      week.push(cursor);
      cursor = cursor.add(1, 'day');
    }
    weeks.push(week);
  }
  return weeks;
};

interface MonthPanelProps {
  cursor: Dayjs;
  onPrevMonth: () => void;
  onNextMonth: () => void;
  onCursorChange: (day: Dayjs) => void;
  draftStart: Dayjs | null;
  draftEnd: Dayjs | null;
  onDayClick: (day: Dayjs) => void;
}

const MonthPanel = ({
  cursor,
  onPrevMonth,
  onNextMonth,
  onCursorChange,
  draftStart,
  draftEnd,
  onDayClick,
}: MonthPanelProps) => {
  const weeks = useMemo(() => buildMonthWeeks(cursor), [cursor]);
  const [yearAnchor, setYearAnchor] = useState<HTMLElement | null>(null);
  const [monthAnchor, setMonthAnchor] = useState<HTMLElement | null>(null);

  // AS-IS YearSet(L104~119) 규칙 재사용 — ExchangeRateModal.tsx:179-186 과 동일 범위(현재년 -5~+10)
  const yearOptions = useMemo(() => {
    const from = new Date().getFullYear() - 5;
    const to = new Date().getFullYear() + 10;
    return Array.from({ length: to - from + 1 }, (_, i) => from + i);
  }, []);

  const handleYearSelect = (y: number) => {
    onCursorChange(cursor.year(y));
    setYearAnchor(null);
  };
  const handleMonthSelect = (m: number) => {
    onCursorChange(cursor.month(m));
    setMonthAnchor(null);
  };

  return (
    <div className={styles.monthPanel}>
      <div className={styles.monthHeader}>
        <button
          type='button'
          className={styles.selectorButton}
          onClick={e => setYearAnchor(e.currentTarget)}
        >
          {cursor.format('YYYY')}년
          <ArrowChevron2Icon direction='down' appearance='single' />
        </button>
        <button
          type='button'
          className={styles.selectorButton}
          onClick={e => setMonthAnchor(e.currentTarget)}
        >
          {cursor.month() + 1}월
          <ArrowChevron2Icon direction='down' appearance='single' />
        </button>
        <span className={styles.headerSpacer} />
        <IconButton size='small' onClick={onPrevMonth}>
          <ArrowChevron2Icon direction='left' appearance='single' />
        </IconButton>
        <IconButton size='small' onClick={onNextMonth}>
          <ArrowChevron2Icon direction='right' appearance='single' />
        </IconButton>
        <Menu anchorEl={yearAnchor} open={!!yearAnchor} onClose={() => setYearAnchor(null)}>
          {yearOptions.map(y => (
            <MenuItem key={y} selected={y === cursor.year()} onClick={() => handleYearSelect(y)}>
              {y}년
            </MenuItem>
          ))}
        </Menu>
        <Menu anchorEl={monthAnchor} open={!!monthAnchor} onClose={() => setMonthAnchor(null)}>
          {Array.from({ length: 12 }, (_, i) => i).map(m => (
            <MenuItem
              key={m}
              selected={m === cursor.month()}
              onClick={() => handleMonthSelect(m)}
            >
              {m + 1}월
            </MenuItem>
          ))}
        </Menu>
      </div>
      <div className={styles.weekRow}>
        <span className={clsx(styles.weekCell, styles.weekHeadCell)}>WEEK</span>
        {DOW_LABELS.map(dow => (
          <span key={dow} className={styles.dowCell}>
            {dow}
          </span>
        ))}
      </div>
      {weeks.map(week => (
        <div className={styles.weekRow} key={week[0].format(VALUE_FORMAT)}>
          <span className={styles.weekCell}>{weekLabel(week[0])}</span>
          {week.map(day => {
            const inMonth = day.month() === cursor.month();
            const isStart = !!draftStart && day.isSame(draftStart, 'day');
            const isEnd = !!draftEnd && day.isSame(draftEnd, 'day');
            const inRange =
              !!draftStart &&
              !!draftEnd &&
              day.isAfter(draftStart, 'day') &&
              day.isBefore(draftEnd, 'day');

            const isToday = day.isSame(dayjs(), 'day');

            return (
              <button
                key={day.format(VALUE_FORMAT)}
                type='button'
                className={clsx(
                  styles.dayCell,
                  !inMonth && styles.dayCellMuted,
                  isToday && !isStart && !isEnd && styles.dayCellToday,
                  (isStart || isEnd) && styles.dayCellSelected,
                  inRange && styles.dayCellInRange
                )}
                onClick={() => onDayClick(day)}
              >
                {day.date()}
              </button>
            );
          })}
        </div>
      ))}
    </div>
  );
};

export const PeriodRangePicker = ({
  start,
  end,
  onChange,
  label,
  required,
}: PeriodRangePickerProps) => {
  const anchorRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);
  const [draftStart, setDraftStart] = useState<Dayjs | null>(null);
  const [draftEnd, setDraftEnd] = useState<Dayjs | null>(null);
  const [leftCursor, setLeftCursor] = useState(dayjs());
  const [rightCursor, setRightCursor] = useState(dayjs().add(1, 'month'));

  const startDisplay = useMemo(() => parseValue(start)?.format(DISPLAY_FORMAT) ?? '', [start]);
  const endDisplay = useMemo(() => parseValue(end)?.format(DISPLAY_FORMAT) ?? '', [end]);

  const handleOpen = () => {
    const s = parseValue(start) ?? dayjs();
    const e = parseValue(end);
    setDraftStart(s);
    setDraftEnd(e);
    setLeftCursor(s);
    setRightCursor(s.add(1, 'month'));
    setOpen(true);
  };

  const handleCancel = () => setOpen(false);

  const handleOk = () => {
    if (draftStart && draftEnd) {
      onChange(draftStart.format(VALUE_FORMAT), draftEnd.format(VALUE_FORMAT));
    }
    setOpen(false);
  };

  const handleDayClick = (day: Dayjs) => {
    if (!draftStart || (draftStart && draftEnd)) {
      setDraftStart(day);
      setDraftEnd(null);
      return;
    }
    if (day.isBefore(draftStart, 'day')) {
      setDraftStart(day);
      setDraftEnd(null);
      return;
    }
    setDraftEnd(day);
  };

  // W26/W52: 현재 선택된 From 기준 26/52주(182/364일) 구간. From 이 없으면 오늘을 From 으로 삼는다.
  const handleQuickWeeks = (weeks: number) => {
    const base = draftStart ?? dayjs();
    setDraftStart(base);
    setDraftEnd(base.add(weeks * 7 - 1, 'day'));
  };

  return (
    <FormItem
      label={label ?? 'Period'}
      labelAlign='right'
      required={required}
      render={() => (
        <div ref={anchorRef} className={styles.trigger}>
          <div className={styles.dateBox} onClick={handleOpen}>
            <FunctionCalendarIcon appearance='lined' />
            <span>{startDisplay}</span>
          </div>
          <span className={styles.periodSep}>~</span>
          <div className={styles.dateBox} onClick={handleOpen}>
            <FunctionCalendarIcon appearance='lined' />
            <span>{endDisplay}</span>
          </div>
          <Popper
            open={open}
            anchorEl={anchorRef.current}
            placement='bottom-start'
            className={styles.popper}
          >
            <ClickAwayListener onClickAway={handleCancel}>
              <div className={styles.popup}>
                <div className={styles.panels}>
                  <MonthPanel
                    cursor={leftCursor}
                    onPrevMonth={() => setLeftCursor(c => c.subtract(1, 'month'))}
                    onNextMonth={() => setLeftCursor(c => c.add(1, 'month'))}
                    onCursorChange={setLeftCursor}
                    draftStart={draftStart}
                    draftEnd={draftEnd}
                    onDayClick={handleDayClick}
                  />
                  <MonthPanel
                    cursor={rightCursor}
                    onPrevMonth={() => setRightCursor(c => c.subtract(1, 'month'))}
                    onNextMonth={() => setRightCursor(c => c.add(1, 'month'))}
                    onCursorChange={setRightCursor}
                    draftStart={draftStart}
                    draftEnd={draftEnd}
                    onDayClick={handleDayClick}
                  />
                </div>
                <div className={styles.footer}>
                  <div className={styles.quickButtons}>
                    <Button variant='outlined' size='small' onClick={() => handleQuickWeeks(26)}>
                      W26
                    </Button>
                    <Button variant='outlined' size='small' onClick={() => handleQuickWeeks(52)}>
                      W52
                    </Button>
                  </div>
                  <div className={styles.footerActions}>
                    <Button
                      variant='contained'
                      size='small'
                      onClick={handleOk}
                      disabled={!draftStart || !draftEnd}
                    >
                      OK
                    </Button>
                    <Button variant='outlined' size='small' onClick={handleCancel}>
                      Cancel
                    </Button>
                  </div>
                </div>
              </div>
            </ClickAwayListener>
          </Popper>
        </div>
      )}
    />
  );
};

export default PeriodRangePicker;
