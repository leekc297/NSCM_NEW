import dayjs, { type Dayjs } from 'dayjs';
import { VersionField } from 'features/master/src/components';

import { SearchArea } from '@shared/components';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useDemandManagerStore } from '../useDemandManagerStore';

import styles from './DemandManagerForm.module.scss';

interface Props {
  onSearch: () => void;
  onOpenVersionModal: () => void;
  versionLabel: string;
}

// AS-IS DMF0068 조회조건 전수 — Version(팝업 주입) / Period(월 구간). 사업부는 40 고정이라 조회조건에 없다.
//   Version 은 표준 조회조건 카탈로그 VersionField 를 그대로 사용한다(입력창 우측에 검색 버튼이 붙는 표준 형태).
//   Period 는 시작월/종료월 각각 독립 월 달력이며 값은 yyyyMM 6자리. 높이는 다른 조회조건과 같은 36px.
const ymToDayjs = (ym: string): Dayjs | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;

export const DemandManagerForm = ({ onSearch, onOpenVersionModal, versionLabel }: Props) => {
  const { t } = useTranslation();

  const sc = useDemandManagerStore(s => s.searchCondition);
  const set = useDemandManagerStore(s => s.setSearchCondition);
  const openSearchArea = useDemandManagerStore(s => s.openSearchArea);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Version — 표준 카탈로그 (입력창 + 우측 검색 버튼) */}
          <VersionField
            gridSize={6}
            value={versionLabel || sc.versionNo}
            onOpenPopup={onOpenVersionModal}
          />

          {/* Period — 월 구간. 이 값이 그리드 월 컬럼 개수와 헤더를 결정한다 */}
          <Grid size={6}>
            <FormItem
              label={t('LBL00013', 'Period')}
              labelAlign='right'
              required
              render={() => (
                <div className={styles.periodSplit}>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='month'
                      elevation
                      size='small'
                      value={ymToDayjs(sc.periodFrom)}
                      onChange={
                        ((date: Dayjs | null) => {
                          set({ periodFrom: date?.format('YYYYMM') ?? '' });
                        }) as never
                      }
                    />
                  </div>
                  <span className={styles.periodSep}>~</span>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='month'
                      elevation
                      size='small'
                      value={ymToDayjs(sc.periodTo)}
                      onChange={
                        ((date: Dayjs | null) => {
                          set({ periodTo: date?.format('YYYYMM') ?? '' });
                        }) as never
                      }
                    />
                  </div>
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
