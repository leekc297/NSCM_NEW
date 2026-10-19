import { ClickAwayListener, IconButton, Menu, MenuItem, Popper } from '@mui/material';
import dayjs, { type Dayjs } from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import { useMemo, useRef, useState } from 'react';

import { clsx } from '@shared/clsx';
import { Button, FormItem } from '@shared/lges';
import {
  ArrowChevron2Icon,
  ArrowChevronIcon,
  ControlConfirmIcon,
  FunctionCalendarIcon,
} from '@shared/lges-icons';

import styles from './PeriodRangePicker.module.scss';

dayjs.extend(isoWeek);

const VALUE_FORMAT = 'YYYYMMDD';
const DISPLAY_FORMAT = 'YYYY-MM-DD';

// 월~일 순서(isoWeek 기준).
// 다국어 처리 보류 — SCM_ADM_MSG_M(LANG_CD=KO/EN/CN)에 정식 LBL 코드가 등록되기 전까지는
// 하드코딩 유지. 로컬 KO.json/EN.json 최댓값만 보고 LBL01038~01045 를 새로 붙였다가
// 실제 DB에 이미 다른 화면 라벨로 등록돼 있어 클라우드 배포 시 충돌났음(2026-09-21).
// 재등록 시 반드시 ora.py 로 SCM_ADM_MSG_M 실측 후 빈 코드로 등록할 것.
const DOW_LABELS = ['월', '화', '수', '목', '금', '토', '일'];

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
        <div className={styles.headerLabels}>
          <button
            type='button'
            className={styles.selectorButton}
            onClick={e => setYearAnchor(e.currentTarget)}
          >
            {cursor.format('YYYY')}년
            <ArrowChevron2Icon direction='down' appearance='single' iconSize={10} />
          </button>
          <button
            type='button'
            className={styles.selectorButton}
            onClick={e => setMonthAnchor(e.currentTarget)}
          >
            {cursor.month() + 1}월
            <ArrowChevron2Icon direction='down' appearance='single' iconSize={10} />
          </button>
        </div>
        <div className={styles.headerNav}>
          <IconButton className={styles.navButton} size='medium' onClick={onPrevMonth}>
            <ArrowChevronIcon
              direction='left'
              appearance='single'
              iconSize={18}
              sx={{ color: 'rgba(0, 0, 0, 0.6)' }}
            />
          </IconButton>
          <IconButton className={styles.navButton} size='medium' onClick={onNextMonth}>
            <ArrowChevronIcon
              direction='right'
              appearance='single'
              iconSize={18}
              sx={{ color: 'rgba(0, 0, 0, 0.6)' }}
            />
          </IconButton>
        </div>
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
              <div
                key={day.format(VALUE_FORMAT)}
                className={clsx(styles.dayCellOuter, inRange && styles.dayCellOuterInRange)}
              >
                <button
                  type='button'
                  className={clsx(
                    styles.dayCell,
                    !inMonth && styles.dayCellMuted,
                    isToday && !isStart && !isEnd && styles.dayCellToday,
                    (isStart || isEnd) && styles.dayCellSelected
                  )}
                  onClick={() => onDayClick(day)}
                >
                  {day.date()}
                </button>
              </div>
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
    setRightCursor(e ?? s.add(1, 'month'));
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
    const newEnd = base.add(weeks * 7 - 1, 'day');
    setDraftStart(base);
    setDraftEnd(newEnd);
    setLeftCursor(base);
    setRightCursor(newEnd);
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
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='W26'
                      onClick={() => handleQuickWeeks(26)}
                    />
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='W52'
                      onClick={() => handleQuickWeeks(52)}
                    />
                  </div>
                  <div className={styles.footerActions}>
                    <Button
                      appearance='contained'
                      priority='primary'
                      size='medium'
                      buttonLabel='OK'
                      iconComponent={<ControlConfirmIcon size='small' />}
                      iconPosition='leading'
                      onClick={handleOk}
                      disabled={!draftStart || !draftEnd}
                    />
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='medium'
                      buttonLabel='Cancel'
                      onClick={handleCancel}
                    />
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
