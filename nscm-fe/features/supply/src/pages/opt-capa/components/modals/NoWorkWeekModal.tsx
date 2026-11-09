import dayjs, { type Dayjs } from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button, DatePickerCalendar } from '@shared/lges';
import { Popover } from '@shared/mui';

import { LBL } from '../../opt-capa.constants';
import { weekLabelOfDate } from '../../utils/optCapa.week';

interface Props {
  open: boolean;
  /** 더블클릭한 Week 셀의 아래쪽 좌표(viewport 기준). 달력이 이 지점 밑에 붙어 뜬다. */
  anchor?: { top: number; left: number };
  onClose: () => void;
  onSelect: (weekName: string) => void;
}

/**
 * No Work Week 칸 달력 — AS-IS `SCP0126_SingleDatePopup`(더블클릭, 고른 날짜의 ISO 주차 반환).
 * AS-IS 처럼 셀 바로 밑에 작게 뜨도록 가운데 다이얼로그(`CustomDialog`) 대신 Popover 로 띄운다.
 * 바깥을 누르면 Cancel 과 같이 닫힌다. 기본 날짜는 오늘이다(AS-IS `CurrentDate = DateTime.Now`).
 */
export const NoWorkWeekModal = ({ open, anchor, onClose, onSelect }: Props) => {
  const { t } = useTranslation();
  const [date, setDate] = useState<Dayjs | null>(null);

  useEffect(() => {
    if (open) setDate(dayjs());
  }, [open]);

  const weekName = date ? weekLabelOfDate(date.format('YYYY-MM-DD')) : '';

  return (
    <Popover
      open={open && !!anchor}
      onClose={onClose}
      anchorReference='anchorPosition'
      anchorPosition={anchor}
      transformOrigin={{ vertical: 'top', horizontal: 'left' }}
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8, padding: 8 }}>
        <DatePickerCalendar
          usecase='date'
          size='small'
          value={date}
          onChange={((value: Dayjs | null) => setDate(value)) as never}
        />
        <div style={{ display: 'flex', justifyContent: 'center', gap: 8 }}>
          <Button
            appearance='contained'
            priority='primary'
            size='medium'
            disabled={!weekName}
            buttonLabel={t(LBL.OK, 'OK')}
            onClick={() => {
              onSelect(weekName);
              onClose();
            }}
          />
          <Button
            appearance='outlined'
            priority='normal'
            size='medium'
            buttonLabel={t(LBL.CANCEL, 'Cancel')}
            onClick={onClose}
          />
        </div>
      </div>
    </Popover>
  );
};
