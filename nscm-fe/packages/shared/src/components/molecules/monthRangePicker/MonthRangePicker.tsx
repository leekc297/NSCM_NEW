/* @refresh reload */
import { useMemo } from 'react';

import dayjs, { type Dayjs } from '@foundation/dayjs';

import { MonthPicker } from '../monthPicker/MonthPicker';

/**
 * G10 — MonthRangePicker (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS UsrMonthRangePicker 동등. value 형식: "YYYYMM-YYYYMM".
 *
 * 사용 예:
 * ```typescript
 * <MonthRangePicker
 *   startMonth={...}
 *   endMonth={...}
 *   onChange={({ startMonth, endMonth }) => setSearchParams({
 *     periodFrom: startMonth.format('YYYYMM'),
 *     periodTo:   endMonth.format('YYYYMM'),
 *   })}
 * />
 * ```
 */
export interface MonthRangePickerProps {
  startMonth?: Dayjs | string | null;
  endMonth?: Dayjs | string | null;
  onChange: (range: { startMonth: Dayjs; endMonth: Dayjs }) => void;
  minMonth?: Dayjs;
  maxMonth?: Dayjs;
  separator?: string;
  disabled?: boolean;
  required?: boolean;
  className?: string;
}

export const MonthRangePicker = ({
  startMonth,
  endMonth,
  onChange,
  minMonth,
  maxMonth,
  separator = ' ~ ',
  disabled,
  required,
  className,
}: MonthRangePickerProps) => {
  const start = useMemo(() => {
    if (!startMonth) return null;
    return typeof startMonth === 'string' ? dayjs(startMonth, 'YYYYMM') : startMonth;
  }, [startMonth]);

  const end = useMemo(() => {
    if (!endMonth) return null;
    return typeof endMonth === 'string' ? dayjs(endMonth, 'YYYYMM') : endMonth;
  }, [endMonth]);

  const handleStartChange = (newStart: Dayjs) => {
    const newEnd = end && newStart.isAfter(end) ? newStart : (end ?? newStart);
    onChange({ startMonth: newStart, endMonth: newEnd });
  };

  const handleEndChange = (newEnd: Dayjs) => {
    const newStart = start && newEnd.isBefore(start) ? newEnd : (start ?? newEnd);
    onChange({ startMonth: newStart, endMonth: newEnd });
  };

  return (
    <div className={className} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
      <MonthPicker
        value={start}
        onChange={handleStartChange}
        minMonth={minMonth}
        maxMonth={end ?? maxMonth}
        disabled={disabled}
      />
      <span>{separator}</span>
      <MonthPicker
        value={end}
        onChange={handleEndChange}
        minMonth={start ?? minMonth}
        maxMonth={maxMonth}
        disabled={disabled}
      />
    </div>
  );
};
