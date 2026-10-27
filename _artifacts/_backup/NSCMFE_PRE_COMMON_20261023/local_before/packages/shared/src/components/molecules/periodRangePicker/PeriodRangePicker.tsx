import { ClickAwayListener, IconButton, Menu, MenuItem, Popper } from '@mui/material';
import dayjs, { type Dayjs } from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import { useEffect, useMemo, useRef, useState } from 'react';

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
// 월 단위 기간 화면(monthOnly)의 표기. AS-IS 가 월 콤보 2개로 'yyyy-MM' 만 보여주던 화면용
//   (예: SCP0111 통합PSI — cs L841 `ParseExact(cmbFromMonth.Text, "yyyy-MM", ...)`).
const DISPLAY_FORMAT_MONTH = 'YYYY-MM';

// 월~일 순서(isoWeek 기준). AS-IS Period 캘린더와 동일하게 영문 고정(MON~SUN) — 언어 무관.
// 다국어가 필요해지면 SCM_ADM_MSG_M 에 정식 LBL 코드 등록 후 치환할 것(과거 로컬 json 최댓값만 보고
// LBL01038~01045 를 붙였다가 실 DB 충돌난 선례 있음, 2026-09-21 — 반드시 ora.py 실측 후 빈 코드로).
const DOW_LABELS = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

interface PeriodRangePickerProps {
  start: string;
  end: string;
  onChange: (start: string, end: string) => void;
  label?: string;
  required?: boolean;
  // FormItem 래퍼 클래스 — 다른 조회조건 필드와 동일 레이아웃(commonStyles.formItem) 적용용.
  className?: string;
  // 프리셋 버튼 주 단위 목록. 기본값은 W26/W52/W82.
  quickWeeks?: number[];
  // WLast(사업부별 최종 주차) 프리셋 — 값을 주면 W{lastWeeks} 버튼이 고정 프리셋 옆에 뜬다.
  //   AS-IS R7: 사업부 기본기간(SCM_MST_DIVISION.DAILY_PLAN_PERIOD)이 52면 숨김(W52와 중복). 미지정이면 미표시.
  lastWeeks?: number;
  // 기본은 handleQuickWeeks 가 현재 선택된 From 기준으로 주 수를 더한다(여러 화면의 기존 동작, 하위호환 유지).
  //   AS-IS 화면 중 서버 GetDayRange(p_from_date="") 처럼 항상 오늘 기준으로 계산하는 화면은 이 플래그로
  //   오늘 기준을 강제한다(SCP0024 — cs:1184-1197, p_from_date 를 아예 비워 보내 서버가 오늘로 계산).
  quickWeeksFromToday?: boolean;
  // From/To 직접 키인 허용(opt-in). AS-IS UsrDateRangePicker3 의 txtStart/txtEnd MaskedTextBox 복원.
  //   기본 false — 미지정 화면은 종전 달력 전용 동작 그대로(공용 컴포넌트 회귀 방지, Hard Boundary).
  //   true 면 날짜 박스가 편집 input 이 되고(YYYY-MM-DD, 하이픈 유무 무관) blur/Enter 시 YYYYMMDD 로
  //   커밋한다. 달력 아이콘 클릭은 종전처럼 팝업을 연다.
  allowTextInput?: boolean;
  // 월 단위 기간 — 표기를 'YYYY-MM' 로 줄이고, 확정값을 월 경계(시작월 1일 ~ 종료월 말일)로 정규화한다.
  //   값 계약(start/end/onChange = YYYYMMDD)은 그대로다 — 소비자가 YYYYMM 으로 쓰려면 앞 6자리만 취하면 된다.
  //   조회 param 이 월 단위인 화면이 쓴다(SCP0111 p_from_yyyymm/p_to_yyyymm). 기본값 false 라 기존 화면 영향 없음.
  //   주의: allowTextInput 과 함께 쓰는 소비자는 없다 — 월 표기 칸에 일 단위 키인을 허용하면 표기와
  //   입력 단위가 어긋난다. 필요해지면 monthOnly 쪽 파서를 YYYY-MM 로 따로 맞춰야 한다.
  monthOnly?: boolean;
}

// 고정 프리셋 기본 세트. 모듈 상수로 둬 미전달 소비자의 렌더마다 새 배열 생성을 막는다.

const DEFAULT_QUICK_WEEKS = [26, 52, 82];

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
            Year {cursor.format('YYYY')}
            <ArrowChevron2Icon direction='down' appearance='single' iconSize={10} />
          </button>
          <button
            type='button'
            className={styles.selectorButton}
            onClick={e => setMonthAnchor(e.currentTarget)}
          >
            Month {cursor.month() + 1}
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
              {y}
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
              {m + 1}
            </MenuItem>
          ))}
        </Menu>
      </div>
      <div className={styles.weekRow}>
        <span className={clsx(styles.weekCell, styles.weekHeadCell)}>WEEK</span>
        {DOW_LABELS.map((dow, i) => (
          <span
            key={dow}
            className={clsx(styles.dowCell, i === 5 && styles.dowSat, i === 6 && styles.dowSun)}
          >
            {dow}
          </span>
        ))}
      </div>
      {weeks.map(week => {
        // AS-IS: 선택한 일자(From/To)가 속한 주의 WEEK 셀에 배경 강조.
        const weekHasSelected =
          (!!draftStart && week.some(d => d.isSame(draftStart, 'day'))) ||
          (!!draftEnd && week.some(d => d.isSame(draftEnd, 'day')));
        return (
          <div className={styles.weekRow} key={week[0].format(VALUE_FORMAT)}>
            <span className={clsx(styles.weekCell, weekHasSelected && styles.weekCellSelected)}>
              {weekLabel(week[0])}
            </span>
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
              // AS-IS 토(파랑)/일(빨강) 글자색 — 선택/오늘(배경+흰글자)이 아닐 때만.
              const plain = !isStart && !isEnd && !isToday;
              const isSaturday = day.isoWeekday() === 6;
              const isSunday = day.isoWeekday() === 7;

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
                      (isStart || isEnd) && styles.dayCellSelected,
                      plain && isSaturday && styles.dayCellSat,
                      plain && isSunday && styles.dayCellSun
                    )}
                    onClick={() => onDayClick(day)}
                  >
                    {day.date()}
                  </button>
                </div>
              );
            })}
          </div>
        );
      })}
    </div>
  );
};

export const PeriodRangePicker = ({
  start,
  end,
  onChange,
  label,
  required,
  className,
  quickWeeksFromToday,
  allowTextInput,
  monthOnly,
}: PeriodRangePickerProps) => {
  const anchorRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);
  const [draftStart, setDraftStart] = useState<Dayjs | null>(null);
  const [draftEnd, setDraftEnd] = useState<Dayjs | null>(null);
  const [leftCursor, setLeftCursor] = useState(dayjs());
  const [rightCursor, setRightCursor] = useState(dayjs().add(1, 'month'));

  const displayFormat = monthOnly ? DISPLAY_FORMAT_MONTH : DISPLAY_FORMAT;
  const startDisplay = useMemo(
    () => parseValue(start)?.format(displayFormat) ?? '',
    [start, displayFormat]
  );
  const endDisplay = useMemo(
    () => parseValue(end)?.format(displayFormat) ?? '',
    [end, displayFormat]
  );

  // 키인(allowTextInput) 전용 로컬 입력 상태 — 타이핑 중에는 로컬만 바뀌고, 커밋(blur/Enter) 시
  //   onChange 로 상위 값을 바꾼다. prop(start/end)이 바뀌면(달력 선택·외부 리셋) 표시값으로 재동기화.
  const [startInput, setStartInput] = useState(startDisplay);
  const [endInput, setEndInput] = useState(endDisplay);
  useEffect(() => setStartInput(startDisplay), [startDisplay]);
  useEffect(() => setEndInput(endDisplay), [endDisplay]);

  // 하이픈 유무 무관하게 숫자 8자리를 뽑아 유효 날짜면 YYYYMMDD, 아니면 null(무효).
  const normalizeInput = (raw: string): string | null => {
    const digits = raw.replace(/\D/g, '');
    if (digits.length !== 8) return null;
    return parseValue(digits) ? digits : null;
  };
  // 커밋: 무효면 직전 표시값으로 되돌리고, 유효면 해당 축만 바꿔 onChange(start, end) 호출.
  const commitInput = (raw: string, which: 'start' | 'end') => {
    const v = normalizeInput(raw);
    if (v === null) {
      if (which === 'start') setStartInput(startDisplay);
      else setEndInput(endDisplay);
      return;
    }
    if (which === 'start') onChange(v, end);
    else onChange(start, v);
  };

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
      // monthOnly: 표기가 'YYYY-MM' 뿐이라 일자는 화면에서 구분되지 않는다 → 고른 달 **전체**를 구간으로 못박는다.
      //   (시작월 1일 ~ 종료월 말일). 그러지 않으면 "2026-09 ~ 2027-02" 로 보이는 값이 실제로는 09-17~02-03 이 되어
      //   표기와 값이 어긋난다.
      const s = monthOnly ? draftStart.startOf('month') : draftStart;
      const e = monthOnly ? draftEnd.endOf('month') : draftEnd;
      onChange(s.format(VALUE_FORMAT), e.format(VALUE_FORMAT));
    }
    setOpen(false);
  };

  // 좌측 패널(From)과 우측 패널(To)은 서로 다른 달을 보여주는 같은 달력이 아니라 각자 From/To 전용이다 —
  //   패널 구분 없이 하나의 핸들러로 날짜를 받으면 우측 패널을 클릭해도 From 이 바뀌는 등 어느 쪽을 클릭해도
  //   from/to 양쪽이 다 바뀔 수 있었다(실사용 리포트). 좌측은 draftStart 만, 우측은 draftEnd 만 갱신한다.
  const handleStartDayClick = (day: Dayjs) => {
    setDraftStart(day);
    if (draftEnd && day.isAfter(draftEnd, 'day')) setDraftEnd(null);
  };

  const handleEndDayClick = (day: Dayjs) => {
    setDraftEnd(day);
    if (draftStart && day.isBefore(draftStart, 'day')) setDraftStart(null);
  };

  // Today — From 만 오늘 날짜로 이동(To 는 그대로, 단 오늘이 기존 To 보다 뒤면 To 는 재선택하도록 비운다).
  //   좌측 패널(From) 커서도 오늘이 보이는 달로 옮긴다.
  const handleToday = () => {
    const today = dayjs();
    handleStartDayClick(today);
    setLeftCursor(today);
  };

  // W26/W52/W92(quickWeeks 기본값): 현재 선택된 From 기준 해당 주 수 구간. From 이 없으면 오늘을 From 으로 삼는다.
  //   quickWeeksFromToday=true 인 화면(SCP0024)은 선택된 From 을 무시하고 항상 오늘을 base 로 삼는다.
  const handleQuickWeeks = (weeks: number) => {
    const base = quickWeeksFromToday ? dayjs() : (draftStart ?? dayjs());
    const newEnd = base.add(weeks * 7 - 1, 'day');
    setDraftStart(base);
    setDraftEnd(newEnd);
    setLeftCursor(base);
    setRightCursor(newEnd);
  };

  return (
    <FormItem
      className={className}
      label={label ?? 'Period'}
      labelAlign='right'
      required={required}
      render={() => (
        <div ref={anchorRef} className={styles.trigger}>
          {allowTextInput ? (
            <div className={styles.dateBox}>
              <span
                style={{ cursor: 'pointer', display: 'inline-flex' }}
                onClick={handleOpen}
                role='button'
                tabIndex={-1}
                aria-label='Open calendar'
              >
                <FunctionCalendarIcon appearance='lined' />
              </span>
              <input
                value={startInput}
                placeholder={DISPLAY_FORMAT}
                onChange={event => setStartInput(event.target.value)}
                onBlur={() => commitInput(startInput, 'start')}
                onKeyDown={event => {
                  if (event.key === 'Enter') event.currentTarget.blur();
                }}
                style={{
                  border: 'none',
                  background: 'transparent',
                  outline: 'none',
                  width: '80px',
                  font: 'inherit',
                  color: 'inherit',
                }}
              />
            </div>
          ) : (
            <div className={styles.dateBox} onClick={handleOpen}>
              <FunctionCalendarIcon appearance='lined' />
              <span>{startDisplay}</span>
            </div>
          )}
          <span className={styles.periodSep}>~</span>
          {allowTextInput ? (
            <div className={styles.dateBox}>
              <span
                style={{ cursor: 'pointer', display: 'inline-flex' }}
                onClick={handleOpen}
                role='button'
                tabIndex={-1}
                aria-label='Open calendar'
              >
                <FunctionCalendarIcon appearance='lined' />
              </span>
              <input
                value={endInput}
                placeholder={DISPLAY_FORMAT}
                onChange={event => setEndInput(event.target.value)}
                onBlur={() => commitInput(endInput, 'end')}
                onKeyDown={event => {
                  if (event.key === 'Enter') event.currentTarget.blur();
                }}
                style={{
                  border: 'none',
                  background: 'transparent',
                  outline: 'none',
                  width: '80px',
                  font: 'inherit',
                  color: 'inherit',
                }}
              />
            </div>
          ) : (
            <div className={styles.dateBox} onClick={handleOpen}>
              <FunctionCalendarIcon appearance='lined' />
              <span>{endDisplay}</span>
            </div>
          )}
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
                    onDayClick={handleStartDayClick}
                  />
                  <MonthPanel
                    cursor={rightCursor}
                    onPrevMonth={() => setRightCursor(c => c.subtract(1, 'month'))}
                    onNextMonth={() => setRightCursor(c => c.add(1, 'month'))}
                    onCursorChange={setRightCursor}
                    draftStart={draftStart}
                    draftEnd={draftEnd}
                    onDayClick={handleEndDayClick}
                  />
                </div>
                <div className={styles.footer}>
                  <div className={styles.quickButtons}>
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='Today'
                      onClick={handleToday}
                    />
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
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='W82'
                      onClick={() => handleQuickWeeks(82)}
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
