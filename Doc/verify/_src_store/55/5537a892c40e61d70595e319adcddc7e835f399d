import { ClickAwayListener, IconButton, Menu, MenuItem, Popper, useTheme } from '@mui/material';
import dayjs, { type Dayjs } from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import { useEffect, useMemo, useRef, useState } from 'react';

import { todayInTimeZone } from '@foundation/utils';
import { clsx } from '@shared/clsx';
import { Button, FormItem } from '@shared/lges';
import {
  ArrowChevron2Icon,
  ArrowChevronIcon,
  ControlConfirmIcon,
  FunctionCalendarIcon,
} from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import styles from './PeriodRangePicker.module.scss';

dayjs.extend(isoWeek);

const VALUE_FORMAT = 'YYYYMMDD';
// 표시 포맷은 점 구분(YYYY.MM.DD) — 앱 표준 단일 DatePicker(design-system format='YYYY.MM.DD')와 통일
//   (사용자 지시 2026-10-27). 값 계약(start/end/onChange = YYYYMMDD)은 불변이고, 키인 커밋은 숫자 8자리만
//   뽑아 정규화하므로 구분자와 무관하게 동작한다.
const DISPLAY_FORMAT = 'YYYY.MM.DD';
// 월 단위 기간 화면(monthOnly)의 표기. AS-IS 가 월 콤보 2개로 'yyyy.MM' 만 보여주던 화면용
//   (예: SCP0111 통합PSI — cs L841 `ParseExact(cmbFromMonth.Text, "yyyy.MM", ...)`).
const DISPLAY_FORMAT_MONTH = 'YYYY.MM';

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
  // 고정 프리셋 버튼 주 단위 목록(각 n → W{n} 버튼). 기본값은 W26/W52(W82 은 기본 미표시 — 사용자 지시 2026-11-19).
  quickWeeks?: number[];
  // 동적 WLast 프리셋 — 값을 주면 W{lastWeeks} 버튼이 고정 프리셋 옆에 뜬다(미지정이면 미표시).
  //   quickWeeks 에 이미 같은 주 수가 있으면 중복이라 띄우지 않는다(예: lastWeeks=52 ↔ 고정 W52).
  //   SCP0013 은 선택 Plan Date 행의 OVER_52W_YN='Y'(계획기간 52주 초과)일 때 그 행 PLAN_WEEKS 를 넘겨
  //   W{PLAN_WEEKS} 버튼을 띄운다(DATE_WEEKLY1_SCP_ALL, 사용자 지시 2026-11-17).
  lastWeeks?: number;
  // 기본은 handleQuickWeeks 가 현재 선택된 From 기준으로 주 수를 더한다(여러 화면의 기존 동작, 하위호환 유지).
  //   AS-IS 화면 중 서버 GetDayRange(p_from_date="") 처럼 항상 오늘 기준으로 계산하는 화면은 이 플래그로
  //   오늘 기준을 강제한다(SCP0024 — cs:1184-1197, p_from_date 를 아예 비워 보내 서버가 오늘로 계산).
  quickWeeksFromToday?: boolean;
  // From/To 직접 키인 허용. AS-IS UsrDateRangePicker3 의 txtStart/txtEnd MaskedTextBox 복원.
  //   기본 true(공용 기본값, 2026-10-19) — 날짜 박스가 편집 input 이 되고(YYYY-MM-DD, 하이픈 유무 무관)
  //   blur/Enter 시 YYYYMMDD 로 커밋한다. 달력 아이콘 클릭은 종전처럼 팝업을 연다.
  //   달력 전용으로 되돌리려면 allowTextInput={false} 를 명시한다. monthOnly 화면은 아래 사유로 자동 달력 전용.
  allowTextInput?: boolean;
  // 월 단위 기간 — 표기를 'YYYY-MM' 로 줄이고, 확정값을 월 경계(시작월 1일 ~ 종료월 말일)로 정규화한다.
  //   값 계약(start/end/onChange = YYYYMMDD)은 그대로다 — 소비자가 YYYYMM 으로 쓰려면 앞 6자리만 취하면 된다.
  //   조회 param 이 월 단위인 화면이 쓴다(SCP0111 p_from_yyyymm/p_to_yyyymm). 기본값 false 라 기존 화면 영향 없음.
  //   주의: 월 표기 칸에 일 단위 키인을 허용하면 표기(YYYY-MM)와 입력 단위가 어긋나므로, monthOnly 면
  //   키인 기본값과 무관하게 항상 달력 전용이다. 필요해지면 monthOnly 쪽 파서를 YYYY-MM 로 따로 맞춰야 한다.
  monthOnly?: boolean;
}

// 동적 WLast 주 수 — DATE_WEEKLY / DATE_WEEKLY1_SCP_ALL 콤보가 함께 반환하는 PLAN_WEEKS·OVER_52W_YN 으로
//   결정한다(SCM_ADM_CMBO_SQL_M 실측). W26/W52 는 고정이고 이 값만 가변(DB 에서 70·99 등으로 날아옴).
//   OVER_52W_YN='Y'(계획기간 = Plan Date~Horizon End 가 52주 초과)인 선택 행의 PLAN_WEEKS 를 반환,
//   'N'·미선택·미등록이면 undefined → lastWeeks 미지정과 동일하게 버튼 숨김. 위 두 콤보를 쓰는 화면에서
//   lastWeeks={over52WeekPreset(planDates, 선택CODE)} 로 일괄 적용한다(사용자 지시 2026-11-17).
//   rows 는 ComboResponse([key]:string) 호환 — CODE/PLAN_WEEKS/OVER_52W_YN 만 참조하므로 타입 결합 없이 받는다.
export const over52WeekPreset = (
  rows: ReadonlyArray<{ readonly [key: string]: string }> | undefined,
  selectedCode: string
): number | undefined => {
  const row = (rows ?? []).find(r => r.CODE === selectedCode);
  if (!row || row.OVER_52W_YN !== 'Y') return undefined;
  return Number(row.PLAN_WEEKS) || undefined;
};

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
  // 사용자 타임존 기준 '오늘'(PC 시계 아님) — 오늘 셀 강조·연도 범위 산정에 쓴다.
  today: Dayjs;
}

const MonthPanel = ({
  cursor,
  onPrevMonth,
  onNextMonth,
  onCursorChange,
  draftStart,
  draftEnd,
  onDayClick,
  today,
}: MonthPanelProps) => {
  const weeks = useMemo(() => buildMonthWeeks(cursor), [cursor]);
  const [yearAnchor, setYearAnchor] = useState<HTMLElement | null>(null);
  const [monthAnchor, setMonthAnchor] = useState<HTMLElement | null>(null);

  // AS-IS YearSet(L104~119) 규칙 재사용 — ExchangeRateModal.tsx:179-186 과 동일 범위(현재년 -5~+10).
  //   '현재년' 은 사용자 타임존 기준(연말/연초 경계에서 PC 시계와 어긋나지 않도록).
  const yearOptions = useMemo(() => {
    const base = today.year();
    const from = base - 5;
    const to = base + 10;
    return Array.from({ length: to - from + 1 }, (_, i) => from + i);
  }, [today]);

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

              const isToday = day.isSame(today, 'day');
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
  quickWeeks = [26, 52],
  lastWeeks,
  quickWeeksFromToday,
  allowTextInput,
  monthOnly,
}: PeriodRangePickerProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  // 달력의 '오늘'(Today·W 버튼·오늘 셀 강조·연도 범위)은 PC 시계가 아니라 사용자 타임존(session.tmzCd)
  //   기준으로 잡는다 — 화면 최초 오픈 시 Period 기본값(서버 FN_MULTY_TIME)과 같은 날짜. 한국 PC 에 미국
  //   타임존으로 설정한 사용자가 달력 Today 로 한국 날짜가 들어가던 문제 교정. 미매핑·빈 코드는 브라우저 폴백.
  const tmzCd = useSessionStore(state => state.session.tmzCd);
  const today = useMemo(() => todayInTimeZone(tmzCd), [tmzCd]);
  const anchorRef = useRef<HTMLDivElement>(null);
  // 기간 역전 안내(setAlert)가 떠 있는 동안은 click-away 로 달력을 닫지 않기 위한 억제 플래그.
  //   setAlert 는 MUI Dialog(포털)로 뜨므로 그 버튼/백드롭 클릭이 Popper 바깥 클릭으로 잡혀
  //   ClickAwayListener 가 handleCancel 을 불러 달력까지 닫아버린다 → 알림 동안/직후 1회 억제한다.
  const suppressClickAwayRef = useRef(false);
  // 트리거 날짜 박스 색상은 테마 토큰에서 끌어온다(라이트/다크 자동). .dateBox 에 #fff/#d9d9d9 를
  //   하드코딩하면 다크 테마 조회영역(commonBgDeep)에서 혼자 흰색으로 튄다 — DMF0003 PeriodField 가
  //   쓰는 design-system DatePickerCalendar 처럼 테마를 따르게 한다. (레이아웃은 .dateBox scss 가 담당)
  const {
    palette: { semantic },
  } = useTheme();
  const dateBoxStyle = {
    background: semantic.color.commonBgBasic,
    borderColor: semantic.color.commonBorderBasic,
    color: semantic.color.commonTextBasic,
  };
  const [open, setOpen] = useState(false);
  const [draftStart, setDraftStart] = useState<Dayjs | null>(null);
  const [draftEnd, setDraftEnd] = useState<Dayjs | null>(null);
  const [leftCursor, setLeftCursor] = useState(today);
  const [rightCursor, setRightCursor] = useState(today.add(1, 'month'));

  // 키인 기본 활성. 명시적으로 allowTextInput={false} 를 준 소비자만 달력 전용.
  //   monthOnly 는 표기(YYYY-MM)와 일 단위 키인이 어긋나므로 항상 달력 전용으로 강제한다.
  const textInputEnabled = (allowTextInput ?? true) && !monthOnly;

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
    const s = parseValue(start) ?? today;
    const e = parseValue(end);
    setDraftStart(s);
    setDraftEnd(e);
    setLeftCursor(s);
    setRightCursor(e ?? s.add(1, 'month'));
    setOpen(true);
  };

  const handleCancel = () => {
    // 알림이 떠 있는 동안의 click-away(알림 버튼/백드롭 클릭)로는 달력을 닫지 않는다.
    if (suppressClickAwayRef.current) return;
    setOpen(false);
  };

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
    // To 를 From 보다 앞선 날짜로 고르면 방금 찍은 To 만 해제(From 유지)하고 안내만 한다. 달력은 닫지 않는다.
    //   기간 역전(시작일 > 종료일) 금지는 사내 등록 코드 MSG00108 로 알린다(같은 날은 허용).
    if (draftStart && day.isBefore(draftStart, 'day')) {
      setDraftEnd(null);
      suppressClickAwayRef.current = true;
      // 알림이 닫힌 뒤(= 닫기 클릭이 유발하는 click-away 까지) 억제를 유지하고, 그다음 틱에 해제한다.
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_The end date must be on or after the start date.'),
      }).finally(() => {
        setTimeout(() => {
          suppressClickAwayRef.current = false;
        }, 0);
      });
      return;
    }
    setDraftEnd(day);
  };

  // Today — From 만 오늘 날짜로 이동(To 는 그대로, 단 오늘이 기존 To 보다 뒤면 To 는 재선택하도록 비운다).
  //   좌측 패널(From) 커서도 오늘이 보이는 달로 옮긴다.
  const handleToday = () => {
    handleStartDayClick(today);
    setLeftCursor(today);
  };

  // W26/W52(quickWeeks 기본값): 현재 선택된 From 기준 해당 주 수 구간. From 이 없으면 오늘을 From 으로 삼는다.
  //   quickWeeksFromToday=true 인 화면(SCP0024)은 선택된 From 을 무시하고 항상 오늘을 base 로 삼는다.
  const handleQuickWeeks = (weeks: number) => {
    const base = quickWeeksFromToday ? today : (draftStart ?? today);
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
          {textInputEnabled ? (
            <div className={styles.dateBox} style={dateBoxStyle}>
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
            <div className={styles.dateBox} style={dateBoxStyle} onClick={handleOpen}>
              <FunctionCalendarIcon appearance='lined' />
              <span>{startDisplay}</span>
            </div>
          )}
          <span className={styles.periodSep}>~</span>
          {textInputEnabled ? (
            <div className={styles.dateBox} style={dateBoxStyle}>
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
            <div className={styles.dateBox} style={dateBoxStyle} onClick={handleOpen}>
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
                    today={today}
                  />
                  <MonthPanel
                    cursor={rightCursor}
                    onPrevMonth={() => setRightCursor(c => c.subtract(1, 'month'))}
                    onNextMonth={() => setRightCursor(c => c.add(1, 'month'))}
                    onCursorChange={setRightCursor}
                    draftStart={draftStart}
                    draftEnd={draftEnd}
                    onDayClick={handleEndDayClick}
                    today={today}
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
                    {quickWeeks.map(w => (
                      <Button
                        key={`W${w}`}
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={`W${w}`}
                        onClick={() => handleQuickWeeks(w)}
                      />
                    ))}
                    {/* 동적 WLast — lastWeeks 지정 + 고정 프리셋과 중복 아닐 때만(위 주석). */}
                    {lastWeeks != null && !quickWeeks.includes(lastWeeks) && (
                      <Button
                        key={`WLast-${lastWeeks}`}
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={`W${lastWeeks}`}
                        onClick={() => handleQuickWeeks(lastWeeks)}
                      />
                    )}
                  </div>
                  <div className={styles.footerActions}>
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='medium'
                      buttonLabel='Cancel'
                      onClick={handleCancel}
                    />
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
