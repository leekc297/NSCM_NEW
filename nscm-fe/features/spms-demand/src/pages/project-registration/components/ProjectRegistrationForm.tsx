import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useProjectRegistrationStore } from '../useProjectRegistrationStore';

import styles from './ProjectRegistrationForm.module.scss';

interface ProjectRegistrationFormProps {
  hidden: boolean;
  onSearch: () => void;
}

// 화면설계서 §개요 > 조회조건: 사업부* / 고객 / 나의 권한 / 등록 상태 / 등록 완료일*(period)
// 조회조건은 TAB2에서만 표시하며 SearchArea의 Collapse가 하단 영역을 함께 이동시킨다.
// 고객/나의 권한/등록 상태는 체크박스 멀티셀렉트(CustomDropdown multiple) — 값은 콤마 구분 string.
export const ProjectRegistrationForm = ({ hidden, onSearch }: ProjectRegistrationFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useProjectRegistrationStore(state => state.openSearchArea);
  const searchParams = useProjectRegistrationStore(state => state.searchParams);
  const setSearchParams = useProjectRegistrationStore(state => state.setSearchParams);

  const [divisions, endCustomers, myAuthTypes, regStatuses] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'DpjtAuthType', 'DpjtRegStatus'],
  });
  // 나의 권한 / 등록 상태 — 공용 콤보가 아니라 SCM0001_GET_LOOKUP_VALUES(p_lookup_type) 룩업.

  const toDate = (value: string) => {
    const normalized = /^\d{8}$/.test(value)
      ? `${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`
      : value;
    return /^\d{4}-\d{2}-\d{2}$/.test(normalized) ? dayjs(normalized) : null;
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={hidden || !openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1행 — 사업부 / 고객 / 나의 권한 (4칸씩 균등 배치, 합 12 → 자동 줄바꿈).
              SalesSite 조회조건(Grid size 균등 배치 + commonStyles.formItem) 과 동일 관례. */}
          {/* 사업부(필수) — 단일 선택. 화면설계서 §개요 F13: 사용자 권한에 따라 표시,
              변경 시 컬럼정보 재조회 + 그리드 초기화(useProjectRegistrationStore.setSearchParams) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          {/* 고객(선택, 다중) — CustomDropdown 계약상 값은 콤마 구분 string ('ALL' 포함). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01003', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.endCustomer}
                  options={
                    endCustomers
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => setSearchParams({ endCustomer: options })}
                />
              )}
            />
          </Grid>
          {/* 나의 권한(선택, 다중) — 관리자/입력권한/조회권한 등. 공용 콤보가 아니라
              SCM0001_GET_LOOKUP_VALUES(p_lookup_type='SPMS_DPJT_AUTH_TYPE') 룩업 결과다. */}
          <Grid size={3}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.keepWordsFormItem}`}
              label={t('LBL00879', '_My Authority')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.dpjtAuthType}
                  options={
                    myAuthTypes?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => setSearchParams({ dpjtAuthType: options })}
                />
              )}
            />
          </Grid>
          {/* 2행 — 등록 상태(4칸) / 등록 완료일(8칸, 기간 필드는 카탈로그 PeriodField 표준 폭). */}
          {/* 등록 상태(선택, 다중) — 작성중/승인대기/등록완료 등.
              SCM0001_GET_LOOKUP_VALUES(p_lookup_type='SPMS_DPJT_REG_STATUS') 룩업 결과다. */}
          <Grid size={3}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.keepWordsFormItem}`}
              label={t('LBL00878', '_Reg. Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.dpjtRegStatus}
                  options={
                    regStatuses?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => setSearchParams({ dpjtRegStatus: options })}
                />
              )}
            />
          </Grid>
          {/* 등록 완료일(필수, 기간) — YYYY-MM-DD 시작/종료 두 개의 달력.
              기본값은 M-1(한 달 전) ~ Today(useProjectRegistrationStore 의 initSearchParams).
              handleSearch 에서 시작>종료, 3년 초과 여부를 검증한다. */}
          <Grid size={6}>
            <FormItem
              className={`${commonStyles.formItem} ${styles.keepWordsFormItem}`}
              label={t('LBL00877', '_Reg. Completion Date')}
              labelAlign='right'
              render={() => (
                <div className={styles.periodSplit}>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='date'
                      elevation
                      size='small'
                      format='YYYY.MM.DD'
                      value={toDate(searchParams.regCompDateFr)}
                      onChange={
                        ((date: ReturnType<typeof dayjs> | null) => {
                          setSearchParams({ regCompDateFr: date?.format('YYYY-MM-DD') ?? '' });
                        }) as never
                      }
                    />
                  </div>
                  <span className={styles.periodSep}>~</span>
                  <div className={styles.datePickerFix}>
                    <DatePickerCalendar
                      usecase='date'
                      elevation
                      size='small'
                      format='YYYY.MM.DD'
                      value={toDate(searchParams.regCompDateTo)}
                      mindate={toDate(searchParams.regCompDateFr) ?? undefined}
                      onChange={
                        ((date: ReturnType<typeof dayjs> | null) => {
                          setSearchParams({ regCompDateTo: date?.format('YYYY-MM-DD') ?? '' });
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
