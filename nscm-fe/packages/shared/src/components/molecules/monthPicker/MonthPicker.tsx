/* @refresh reload */
import { useMemo } from 'react';

import dayjs, { type Dayjs } from '@foundation/dayjs';
import { DatePickerCalendar } from '@shared/lges';

/**
 * G10 — MonthPicker (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS UsrMonthPicker 동등. value 형식: "YYYYMM".
 *
 * 사용 예:
 * ```typescript
 * <MonthPicker
 *   value={searchParams.targetMonth ? dayjs(searchParams.targetMonth, 'YYYYMM') : null}
 *   onChange={(m) => setSearchParams({ targetMonth: m.format('YYYYMM') })}
 * />
 * ```
 *
 * ⚠️ DatePickerCalendar 의 `view='month'` prop 의무 (월 단위 view 만 노출).
 *    LGES design system 의 DatePickerCalendar 가 view prop 지원 안 하면 별도 구현 필요.
 */
export interface MonthPickerProps {
  value?: Dayjs | string | null;
  onChange: (month: Dayjs) => void;
  minMonth?: Dayjs;
  maxMonth?: Dayjs;
  format?: string;
  disabled?: boolean;
  required?: boolean;
  className?: string;
}

export const MonthPicker = ({
  value,
  onChange,
  minMonth,
  maxMonth,
  format = 'YYYY-MM',
  disabled,
  required,
  className,
}: MonthPickerProps) => {
  const v = useMemo(() => {
    if (!value) return null;
    return typeof value === 'string' ? dayjs(value, 'YYYYMM') : value;
  }, [value]);

  const handleChange = (newValue: Dayjs | null) => {
    if (!newValue) return;
    // 일자 부분 정규화 (월의 1일)
    onChange(newValue.startOf('month'));
  };

  return (
    <DatePickerCalendar
      value={v}
      onChange={handleChange}
      minDate={minMonth?.startOf('month')}
      maxDate={maxMonth?.endOf('month')}
      format={format}
      disabled={disabled}
      view='month'
      className={className}
    />
  );
};
