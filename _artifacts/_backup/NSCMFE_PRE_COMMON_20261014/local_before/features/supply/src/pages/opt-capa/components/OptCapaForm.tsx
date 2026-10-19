// 같은 feature(supply) 밖의 공용 조회조건 카탈로그 — baseUrl 기준 비상대 경로(Top11 #1).
import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ALL, LBL, PERIOD_MONTHS_AHEAD } from '../opt-capa.constants';
import type { ComboOption } from '../opt-capa.types';
import { useOptCapaStore } from '../useOptCapaStore';

interface Props {
  divisionOptions: ComboOption[];
  planGroupOptions: ComboOption[];
  plantOptions: ComboOption[];
  lineOptions: ComboOption[];
  /** 권한 Division 0건이면 조회조건 **전 영역** 비활성(AS-IS 는 패널 통째 비활성 — R01). */
  hasDivisionAuth: boolean;
  onSearch: () => void;
}

/**
 * 영역2 조회조건 — AS-IS `usrConditionPanel1` / `usrLayoutControl2`(design 02 §1 S-1~S-7).
 *
 * 조건 7개 > 6 이므로 hook #52(12-column 그리드 2단 = 6필드) 기준 초과분을 접는다:
 *   conditions      : Division · Plan Group · Period(2칸) · Plant · Line · Nick Name  → 6필드
 *   extraConditions : Model                                                          → 1필드
 *
 * 조회조건 변경만으로는 조회가 발사되지 않는다 — `setFilters()` 참조 교체만이 트리거다
 * (`refetch()` 직접 호출 금지, nscm-patterns §5-1).
 */
export const OptCapaForm = ({
  divisionOptions,
  planGroupOptions,
  plantOptions,
  lineOptions,
  hasDivisionAuth,
  onSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useOptCapaStore(s => s.searchParams);
  const setSearchParams = useOptCapaStore(s => s.setSearchParams);
  const openSearchArea = useOptCapaStore(s => s.openSearchArea);

  const locked = !hasDivisionAuth;

  /**
   * Division 기본값 = **권한 목록의 첫 행**이다(design 02 §4.2).
   * AS-IS `setListBox(dtMyDivision, cboDivision, false, ...)` 가 DataSource 바인딩만 하므로
   * index 0 이 자동 선택된다. 세션 division 을 기본 선택하면 AS-IS 와 다른 화면이 뜬다.
   */
  useEffect(() => {
    const first = divisionOptions[0]?.value ?? '';
    if (!sc.divisionId && first) setSearchParams({ divisionId: first });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  /**
   * 조회조건 Reset — Period 는 **기본값으로 복원**하고(초기화 아님) 나머지는 비운다
   * (CommonCheckList 조회조건 §"Condition 저장/Reset(Period 제외)").
   * Division 은 AS-IS 도 ALL 이 없는 단일선택이라 목록 첫 행으로 되돌린다.
   */
  const handleResetCondition = () => {
    // 권한 Division 0건이면 Reset 도 무동작이다 — AS-IS `SetDivisionAuthCheck` 는 조회조건
    //   **컨테이너 전체**(`usrLayoutControl.Enabled=false`, BaseForm.cs:5269-5277)를 잠그므로
    //   Reset 버튼도 눌리지 않는다. `sx` 잠금은 DOM 경로만 막으므로 핸들러에도 가드를 둔다
    //   (iter-3 감사 G3-4 / 자매 선례 `line-master` LineMaster.tsx:87-91).
    if (locked) return;
    setSearchParams({
      divisionId: divisionOptions[0]?.value ?? '',
      planGrId: ALL,
      fromYyyymm: dayjs().format('YYYYMM'),
      toYyyymm: dayjs().add(PERIOD_MONTHS_AHEAD, 'month').format('YYYYMM'),
      plantIds: [],
      lineIds: [],
      nickName: '',
      itemId: '',
    });
  };

  const singleField = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: ComboOption[],
    onPick: (code: string) => void,
    extra?: { autoFocus?: boolean }
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            autoFocus={extra?.autoFocus}
            disabled={locked}
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 다중선택 2축(Plant/Line) — 빈 배열 = ALL 이다(AS-IS `UsrCheckedList2` 기본 ALL).
  //   `'ALL'` sentinel 은 서버로 나가지 않는다 — store `setFilters` 가 공백으로 보낸다.
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: ComboOption[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            disabled={locked}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(String(picked ?? '').split(',').filter(Boolean))
            }
          />
        )}
      />
    </Grid>
  );

  const textField = (
    labelCode: string,
    labelEn: string,
    value: string,
    onChange: (next: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            disabled={locked}
            value={value}
            onChange={event => onChange(event.target.value)}
            onKeyDown={event => event.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      onResetCondition={handleResetCondition}
      // 권한 Division 0건 = 조회조건 **영역 전체** 비활성(AS-IS `usrLayoutControl2.Enabled=false`
      //   등가, R01). 필드별 `disabled` 만으로는 공용 `PeriodField`(disabled prop 없음)와
      //   Search/Reset 버튼이 남는다 — 공용 컴포넌트에 prop 을 추가하는 것은 Hard Boundary 밖이라
      //   자매 `line-master`(LineMasterForm.tsx:172) 선례대로 컨테이너를 잠근다.
      //   DOM 밖 진입점(F5·SubTitle 단축키)은 `OptCapa` 의 `hasDivisionAuth` 가드가 막는다.
      sx={locked ? { pointerEvents: 'none', opacity: 0.5 } : undefined}
      conditions={
        <>
          {/* S-1 Division — 단일선택, **ALL 옵션 금지**. 기본 포커스(AS-IS TabIndex=1).
              변경 시 Plan Group·Plant·Line 을 비운다 — AS-IS `SetChangedControl`(cs:553-559)이
              4콤보를 전부 재구성해 이전 선택이 사라진다. 남겨 두면 이전 Division 의 코드가
              그대로 SP 파라미터에 실린다(design 02 §3.1·§3.3). */}
          {singleField(
            LBL.DIVISION,
            'Division',
            sc.divisionId,
            divisionOptions,
            code => setSearchParams({ divisionId: code, planGrId: ALL, plantIds: [], lineIds: [] }),
            { autoFocus: true }
          )}
          {/* S-2 Plan Group — 단일 + ALL. `DIVISION_ID` 클라 필터 + NAME 오름차순은 훅이 처리한다. */}
          {singleField(LBL.PLAN_GROUP, 'Plan Group', sc.planGrId, planGroupOptions, code =>
            setSearchParams({ planGrId: code || ALL })
          )}
          {/* S-3 Period — 공용 `PeriodField` 기본 라벨 `LBL00505` 는 DB·번들 모두 0건이라
              (design 02 §5 M-2) `LBL00013` 을 **명시 전달**한다. 공용 컴포넌트 기본값 수정은
              Hard Boundary 위반이므로 건드리지 않는다. 값 형식 `YYYYMM` = SP 계약과 동일. */}
          <PeriodField
            gridSize={4}
            mode='month'
            label={t(LBL.PERIOD, 'Period')}
            start={sc.fromYyyymm}
            end={sc.toYyyymm}
            onChange={(start, end) => setSearchParams({ fromYyyymm: start, toYyyymm: end })}
          />
          {/* S-4 Plant — 변경 시 Line 을 비운다(AS-IS `ClbPlant_SelectedIndexChanged` → `RefreshLine`). */}
          {multiField(LBL.PLANT, 'Plant', sc.plantIds, plantOptions, codes =>
            setSearchParams({ plantIds: codes, lineIds: [] })
          )}
          {/* S-5 Line — 하위 종속 없음. **Line 변경은 그리드를 비우지 않는다**(AS-IS 비대칭, V2-16). */}
          {multiField(LBL.LINE, 'Line', sc.lineIds, lineOptions, codes =>
            setSearchParams({ lineIds: codes })
          )}
          {/* S-6 Nick Name — No Work 시트에서도 **보이고 입력되지만** payload 만 공백이다(§4.4).
              숨기는 AS-IS 코드는 주석처리돼 있어 이식 금지. */}
          {textField(LBL.NICK_NAME, 'Nick Name', sc.nickName, next =>
            setSearchParams({ nickName: next })
          )}
        </>
      }
      extraConditions={
        <>
          {/* S-7 Model(= `ITEM_ID`) — 7번째 필드라 접힘 영역으로 분리(hook #52). 동상. */}
          {textField(LBL.MODEL, 'Model', sc.itemId, next => setSearchParams({ itemId: next }))}
        </>
      }
    />
  );
};
