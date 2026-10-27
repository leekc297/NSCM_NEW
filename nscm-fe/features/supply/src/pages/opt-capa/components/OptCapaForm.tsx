// 같은 feature(supply) 밖의 공용 조회조건 카탈로그 — baseUrl 기준 비상대 경로(Top11 #1).
import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { ALL, BUCKET, BUCKET_OPTIONS, LBL, SHEETS } from '../opt-capa.constants';
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
  /** 갭분석 C-06 — Model/Nickname 돋보기(메1 = Material by Division 창). 페이지가 open state 소유. */
  onModelSearch: () => void;
}

/**
 * 영역2 조회조건 — AS-IS `usrConditionPanel1` / `usrLayoutControl2`(design 02 §1 S-1~S-7).
 *
 * 레이아웃: 한 줄 4필드(각 size 3) × 2줄(사용자 지시 2026-10-20). Bucket 은 No Work 탭에서만 1줄차에
 * 끼고, 숨겨지면 뒤 필드가 MUI Grid wrap 으로 앞으로 당겨져 계속 4필드/줄을 유지한다:
 *   1줄 : Division · Plan Group · Period · Bucket(No Work 전용)
 *   2줄 : Plant · Line · Model/Nickname   (Bucket 숨김 시: Plant 가 1줄로 올라가 2줄은 2필드)
 * 전 조건이 2줄에 들어가므로 접힘 영역(extraConditions)은 없다 — 3줄차가 생기면 그때 분리한다.
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
  onModelSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useOptCapaStore(s => s.searchParams);
  const setSearchParams = useOptCapaStore(s => s.setSearchParams);
  const setDivision = useOptCapaStore(s => s.setDivision);
  const openSearchArea = useOptCapaStore(s => s.openSearchArea);
  // Bucket 조회조건은 활성 시트가 No Work 일 때만 노출한다(AS-IS `SetVisibleSearchControls` 축, 스크린샷 실측).
  const activeSheet = useOptCapaStore(s => s.activeSheet);

  const tabId = useTabid();

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

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 권한 Division 0건 = 조회조건 **영역 전체** 비활성(AS-IS `usrLayoutControl2.Enabled=false`
      //   등가, R01). 필드별 `disabled` 만으로는 공용 `PeriodField`(disabled prop 없음)와
      //   Search 버튼이 남는다 — 공용 컴포넌트에 prop 을 추가하는 것은 Hard Boundary 밖이라
      //   자매 `line-master`(LineMasterForm.tsx:172) 선례대로 컨테이너를 잠근다.
      //   DOM 밖 진입점(F5·SubTitle 단축키)은 `OptCapa` 의 `hasDivisionAuth` 가드가 막는다.
      sx={locked ? { pointerEvents: 'none', opacity: 0.5 } : undefined}
      conditions={
        <>
          {/* S-1 Division — 단일선택, **ALL 옵션 금지**. 기본 포커스(AS-IS TabIndex=1).
              변경 = 검색조건(Division·Period 제외) + 그리드 초기화(store `setDivision`, TO-BE 공통 요건).
              AS-IS `SetChangedControl`(cs:553-559)이 4콤보를 전부 재구성해 이전 선택이 사라지던 것을
              TO-BE 공통 요건으로 전 조건(Nick Name·Model 포함)까지 확장한다 — 남겨 두면 이전 Division 의
              입력이 그대로 SP 파라미터에 실린다(design 02 §3.1·§3.3). 편집중(dirty)이면 MSG00704 confirm
              후에만 실행, 취소 시 controlled 콤보가 이전 Division 으로 복귀(commit 51d4e9fa 패턴). */}
          {singleField(
            LBL.DIVISION,
            'Division',
            sc.divisionId,
            divisionOptions,
            code => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(code);
              });
            },
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
            gridSize={3}
            mode='month'
            label={t(LBL.PERIOD, 'Period')}
            start={sc.fromYyyymm}
            end={sc.toYyyymm}
            onChange={(start, end) => setSearchParams({ fromYyyymm: start, toYyyymm: end })}
          />
          {/* Bucket(Day/Week) — **No Work 탭 전용**(AS-IS 는 활성 시트 No Work 일 때만 노출). Week 선택 시
              조회는 `noWorkWeek` SP 로 라우팅되고 그리드는 Date·Day of Week·Valid·Fix 컬럼을 숨긴다
              (`OptCapa` querySheet / `NO_WORK_WEEK_HIDDEN_COLUMNS`). LBL 미존재라 리터럴 라벨을 쓴다. */}
          {activeSheet === SHEETS.NO_WORK &&
            singleField('Bucket', 'Bucket', sc.bucket, BUCKET_OPTIONS, code =>
              setSearchParams({ bucket: (code as BUCKET) || BUCKET.DAY })
            )}
          {/* S-4 Plant — 변경 시 Line 을 비운다(AS-IS `ClbPlant_SelectedIndexChanged` → `RefreshLine`). */}
          {multiField(LBL.PLANT, 'Plant', sc.plantIds, plantOptions, codes =>
            setSearchParams({ plantIds: codes, lineIds: [] })
          )}
          {/* S-5 Line — 하위 종속 없음. **Line 변경은 그리드를 비우지 않는다**(AS-IS 비대칭, V2-16). */}
          {multiField(LBL.LINE, 'Line', sc.lineIds, lineOptions, codes =>
            setSearchParams({ lineIds: codes })
          )}
          {/* S-6 Model/Nickname — 갭분석 C-06 : 조회조건 표준(SCP v0.5)대로 AS-IS Nick Name · Model 두 칸을
              한 칸(LBL00618) + 메1 팝업(Material by Division)으로 합쳤다. 값은 조회 인자 itemId 로 보내고
              조회 프로시저가 코드 · 별칭 부분 일치 · 쉼표 복수 · 대소문자 무시로 처리한다.
              No Work 시트에서도 보이고 입력되지만 payload 만 공백이다(§4.4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, 'Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  disabled={locked}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onModelSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={event => setSearchParams({ itemId: event.target.value })}
                  onKeyDown={event => event.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
