import dayjs, { type Dayjs } from 'dayjs';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { SearchArea } from '@shared/components';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useDemandManagerStore } from '../useDemandManagerStore';

import styles from './DemandManagerForm.module.scss';

interface Props {
  onSearch: () => void;
  onOpenVersionModal: () => void;
  versionLabel: string;
  /** Version 직접 입력 — 입력값이 곧 조회에 쓰이는 VERSION_NO 다(팝업 라벨은 해제된다). */
  onChangeVersion: (versionNo: string) => void;
}

// AS-IS DMF0068 조회조건 전수 — Version(팝업 주입) / Period(월 구간). 사업부는 40 고정이라 조회조건에 없다.
//   Version 은 표준 조회조건 카탈로그 VersionField 를 그대로 사용한다(입력창 우측에 검색 버튼이 붙는 표준 형태).
//   Period 는 시작월/종료월 각각 독립 월 달력이며 값은 yyyyMM 6자리. 높이는 다른 조회조건과 같은 36px.
const ymToDayjs = (ym: string): Dayjs | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;

export const DemandManagerForm = ({
  onSearch,
  onOpenVersionModal,
  versionLabel,
  onChangeVersion,
}: Props) => {
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
          {/* Version — 직접 입력 + 우측 팝업 버튼. 기본 선택값이 없어 미선택 시 빈 칸이고,
              조회는 MSG00283 으로 막는다.
              공용 VersionField 를 쓰지 않는 이유: 빈 값에 'Current' 를 대신 표시해
              (DMF0082/DMF0093 은 그 값이 유효한 버전 토큰) 선택된 것처럼 보이기 때문.

              ⭐ 표시값은 팝업 채택 시 'VERSION_NO + 설명'(versionLabel)이지만, 조회에 나가는 값은
                VERSION_NO(sc.versionNo) 하나다. 그래서 라벨이 떠 있는 상태로 편집을 시작하면
                설명까지 VERSION_NO 로 들어가 버린다 → 포커스 순간 라벨을 풀어 코드만 남긴다. */}
          <Grid size={6}>
            <FormItem
              label={t('LBL00513', 'Version')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <div className={styles.versionCell}>
                  <InputField
                    fullWidth
                    value={versionLabel || sc.versionNo}
                    onFocus={() => {
                      if (versionLabel) onChangeVersion(sc.versionNo);
                    }}
                    onChange={e => onChangeVersion(e.target.value)}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={onOpenVersionModal}
                  />
                </div>
              )}
            />
          </Grid>

          {/* Period — 월 구간. 이 값이 그리드 월 컬럼 개수와 헤더를 결정한다 */}
          <Grid size={6}>
            <FormItem
              label={t('LBL00013', 'Period')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
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
