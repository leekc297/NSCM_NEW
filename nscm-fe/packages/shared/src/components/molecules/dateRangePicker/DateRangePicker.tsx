/* @refresh reload */
import { useMemo } from 'react';

import dayjs, { type Dayjs } from '@foundation/dayjs';
import { DatePickerCalendar } from '@shared/lges';

/**
 * G9 — DateRangePicker (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS UsrDateRangePicker (IRangeSettable) 동등.
 * ControlValues 형식: "yyyyMMdd-yyyyMMdd" (csv) — AS-IS BaseForm.InitPanel 의 restore 패턴과 일치.
 *
 * 사용 예 (조회조건 Form):
 * ```typescript
 * <DateRangePicker
 *   startDate={searchParams.periodStartDate ? dayjs(searchParams.periodStartDate, 'YYYYMMDD') : null}
 *   endDate={searchParams.periodEndDate ? dayjs(searchParams.periodEndDate, 'YYYYMMDD') : null}
 *   onChange={({ startDate, endDate }) => setSearchParams({
 *     periodStartDate: startDate.format('YYYYMMDD'),
 *     periodEndDate:   endDate.format('YYYYMMDD'),
 *   })}
 * />
 * ```
 */
export interface DateRangePickerProps {
  startDate?: Dayjs | string | null;
  endDate?: Dayjs | string | null;
  onChange: (range: { startDate: Dayjs; endDate: Dayjs }) => void;
  minDate?: Dayjs;
  maxDate?: Dayjs;
  format?: string;
  separator?: string;
  disabled?: boolean;
  required?: boolean;
  className?: string;
}

export const DateRangePicker = ({
  startDate,
  endDate,
  onChange,
  minDate,
  maxDate,
  format = 'YYYY-MM-DD',
  separator = ' ~ ',
  disabled,
  required,
  className,
}: DateRangePickerProps) => {
  const start = useMemo(() => {
    if (!startDate) return null;
    return typeof startDate === 'string' ? dayjs(startDate, 'YYYYMMDD') : startDate;
  }, [startDate]);

  const end = useMemo(() => {
    if (!endDate) return null;
    return typeof endDate === 'string' ? dayjs(endDate, 'YYYYMMDD') : endDate;
  }, [endDate]);

  const handleStartChange = (newStart: Dayjs | null) => {
    if (!newStart) return;
    const newEnd = end && newStart.isAfter(end) ? newStart : (end ?? newStart);
    onChange({ startDate: newStart, endDate: newEnd });
  };

  const handleEndChange = (newEnd: Dayjs | null) => {
    if (!newEnd) return;
    const newStart = start && newEnd.isBefore(start) ? newEnd : (start ?? newEnd);
    onChange({ startDate: newStart, endDate: newEnd });
  };

  return (
    <div className={className} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
      <DatePickerCalendar
        value={start}
        onChange={handleStartChange}
        minDate={minDate}
        maxDate={end ?? maxDate}
        format={format}
        disabled={disabled}
      />
      <span>{separator}</span>
      <DatePickerCalendar
        value={end}
        onChange={handleEndChange}
        minDate={start ?? minDate}
        maxDate={maxDate}
        format={format}
        disabled={disabled}
      />
    </div>
  );
};
