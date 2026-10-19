import dayjs from 'dayjs';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { LBL } from '../delegate.constants';
import { useDelegateStore } from '../useDelegateStore';

import styles from './DelegateForm.module.scss';

export interface DivisionOption {
  label: string;
  value: string;
}

interface Props {
  onSearch: () => void; // 조회(GET) — SubTitle SEARCH 와 동일 핸들러
  onSave: () => void; // 위임 저장 (btnSave)
  onUnset: () => void; // 위임 해제 (btnUnSet)
  onDelegateeSearch: () => void; // UserInfoPopup(SsoUserModal) 오픈
  showActions: boolean; // 권한(SAVE/UnSet) 보유 시 버튼 렌더 — 버튼그룹 폭 고정 위해 두 시트 모두 렌더
  actionsActive: boolean; // R1/R2 — Delegate 시트에서만 활성. 그 외 시트는 visibility:hidden 로 자리만 유지
  disabled: boolean; // R3 — Division 무권한(EE 제외 0건) 시 헤더 폼 전체 disable
  divisionOptions: DivisionOption[];
  allDivisionCodes: string[]; // "All" 선택 시 확장 대상(권한 division 전건)
}

const ALL = 'ALL';

// yyyymmdd(문자) -> dayjs. 빈값이면 null.
const toDate = (value: string): dayjs.Dayjs | null =>
  value && value.length === 8
    ? dayjs(`${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`)
    : null;

// AS-IS usrConditionPanel1 헤더 폼(design 01 §1) — Delegatee(입력+팝업) / Division(다중 체크리스트) /
//   Period(From~To) + SAVE·UnSet 헤더 버튼. 조회조건이 아니라 위임 설정 입력 영역(design 02 §5).
export const DelegateForm = ({
  onSearch,
  onSave,
  onUnset,
  onDelegateeSearch,
  showActions,
  actionsActive,
  disabled,
  divisionOptions,
  allDivisionCodes,
}: Props) => {
  const { t } = useTranslation();

  const input = useDelegateStore(s => s.input);
  const setInput = useDelegateStore(s => s.setInput);
  const openSearchArea = useDelegateStore(s => s.openSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      extraButtons={
        showActions ? (
          // 권한이 있으면 두 시트 모두에서 렌더해 버튼그룹 폭을 고정한다. Delegate 시트가 아니면
          //   visibility:hidden 으로 자리만 남기고 비활성(disabled) — 시트 전환 시 조회영역 폭 반동 방지.
          <div
            className={`${styles.actionButtons}${actionsActive ? '' : ` ${styles.actionButtonsHidden}`}`}
          >
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.SAVE, { defaultValue: 'Save' })}
              disabled={disabled || !actionsActive}
              onClick={onSave}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.UNSET, { defaultValue: 'UnSet' })}
              disabled={disabled || !actionsActive}
              onClick={onUnset}
            />
          </div>
        ) : undefined
      }
      conditions={
        <>
          {/* Delegatee* (필수, 기본포커스 — design 02 §2.3) 입력 + 돋보기(UserInfoPopup=SsoUserModal). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DELEGATEE, { defaultValue: 'Delegatee' })}
              labelAlign='right'
              required
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={input.delegatee}
                  disabled={disabled}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={disabled}
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onDelegateeSearch} />
                        }
                      />
                    ),
                  }}
                  // 수기 입력 시 확정 id 초기화 — 저장 전 UserName_Search 로 재검증(design 02 §2.3).
                  onChange={e => setInput({ delegatee: e.target.value, delegateeId: '' })}
                />
              )}
            />
          </Grid>

          {/* Division* (다중 체크리스트, EE 제외 — AS-IS cs:137 클라 필터 재현, Delegate.tsx divisionRows.
              ALL 옵션 없음이나 "All" 선택=권한 division 전건 확장 — design 02 §2.1·03 §3 은 "EE 포함" 오판정). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={input.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    const tokens = String(picked ?? '')
                      .split(',')
                      .filter(Boolean);
                    // CustomDropdown(필터용)은 전체선택·전체해제를 모두 'ALL' sentinel 로 내보낸다.
                    //   위임 입력에선 둘을 구분해야 하므로 현재 선택 상태로 토글한다(AS-IS chkAll 재현):
                    //   이미 전건 선택이면 'ALL' = 전체 해제(비움), 아니면 'ALL' = 전건 선택.
                    if (tokens.includes(ALL)) {
                      const isAllSelected =
                        allDivisionCodes.length > 0 &&
                        input.divisionIds.length === allDivisionCodes.length;
                      setInput({ divisionIds: isAllSelected ? [] : allDivisionCodes });
                      return;
                    }
                    setInput({ divisionIds: tokens.filter(v => v !== ALL) });
                  }}
                />
              )}
            />
          </Grid>

          {/* Period* (From~To, YYYYMMDD — human-doc 보완-3 확정). 공백/역전 검증(MSG00134/00219). */}
          <Grid size={4}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PERIOD, { defaultValue: 'Period' })}
              labelAlign='right'
              required
              render={() => (
                <div className={styles.periodWrapper}>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={disabled}
                    value={toDate(input.fromDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        setInput({ fromDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                  <span className={styles.periodSeparator}>~</span>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={disabled}
                    mindate={toDate(input.fromDate) ?? undefined}
                    value={toDate(input.toDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        setInput({ toDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
