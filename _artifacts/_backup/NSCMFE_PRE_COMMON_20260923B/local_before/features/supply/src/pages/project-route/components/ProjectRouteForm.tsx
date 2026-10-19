import { ModelByDivisionPopup, PeriodField, ProjectByDivisionPopup } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  COMBO,
  EXCLUDE_EE_DIVISION,
  isProjectHiddenDivision,
  MSG,
  PERIOD_MONTHS_SPAN,
} from '../project-route.constants';
import { addMonthsToYyyymm, useProjectRouteStore } from '../useProjectRouteStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(design/02) — Division*(cascade 최상위) / Sales Site(division별 후보 표시·항상 ALL·비활성
//   死필터) / Model(픽커) / Period(월범위) / Project(픽커, 82/40 비활성) / Status(YesOrNo+ALL).
export const ProjectRouteForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const searchParams = useProjectRouteStore(state => state.searchParams);
  const setSearchParams = useProjectRouteStore(state => state.setSearchParams);
  const openSearchArea = useProjectRouteStore(state => state.openSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);

  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // BLUtils.GetDivisionWithoutEE 2단계 중 화면측 후처리 — EE 사업부 제외(project-route.constants.ts
  //   COMBO.DIVISION 주석 참고). 참조 안정화(nscm-patterns §5-4) — 매 렌더 새 배열 방지.
  const divisions = useMemo(
    () => divisionsRaw?.filter(EXCLUDE_EE_DIVISION),
    [divisionsRaw]
  );
  const [statusRows] = useTabComboQueries({ filters: [COMBO.STATUS] });
  // Sales Site 후보(division별, 권한 무시 전체 — Data_SCP.CommonAll 재현). 화면은 항상 disabled+
  //   'ALL' 고정이라(design/02 §2, AS-IS SetValues("ALL") 강제잠금) 선택에는 쓰이지 않지만, AS-IS 도
  //   비활성 상태로 실제 후보 목록을 노출하므로 화면 표시를 맞추기 위해 조회한다.
  const [salesSiteRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.SALES_SITE, divisionId: searchParams.divisionId }],
    enabled: !!searchParams.divisionId,
  });

  // 권한목록 교정형(design/04_react-gap.md G5) — sales-reports/cust-fcst-waterfall/etc-sales-reports/
  //   demand-plan-waterfall 등 8개 화면과 동일 패턴. session.div 가 권한목록(EE 제외)에 있으면 그
  //   값, 없으면 목록 첫 행으로 자동 교정한다(AS-IS 권한 division 첫 행과 동등). 기존 값(사용자
  //   선택·F6 복원값)이 있으면 덮지 않는다.
  const session = useSessionStore(state => state.session);
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchParams({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [divisions, searchParams.divisionId, session.div, setSearchParams]);

  // PERIOD_DEFAULT 서버 교정(design/02 §4, G6) — 등록 SQL 실측(2026-09-21 ora.py) 확인 완료.
  //   렌더 즉시 필요해 클라 근사치(defaultPeriod)로 먼저 그리고, 이 콤보 응답이 오면 From 을
  //   SP 기준(BASIS_YYYYMMDD, ISO_WEEK 당주)으로 1회 교정한다. To 는 기존대로 From+11개월 로컬
  //   계산(SQL 자체 TO_VALUE 는 당주+3주라는 다른 의미라 이 화면 계약과 무관, constants.ts 주석 참고).
  //   run-once ref — fromYyyymm 은 항상 값이 있어(G5 의 빈 문자열 센티널과 달리) 빈 값 가드를 못
  //   쓴다. 사용자가 이미 From 을 조작할 방법은 없으므로(disabledStart, L188) 덮어써도 안전.
  const [periodDefaultRows] = useTabComboQueries({ filters: [COMBO.PERIOD_DEFAULT] });
  const periodCorrectedRef = useRef(false);
  useEffect(() => {
    if (periodCorrectedRef.current) return;
    const fromValue = periodDefaultRows?.[0]?.FROM_VALUE;
    if (!fromValue || fromValue.length < 6) return;
    periodCorrectedRef.current = true;
    const fromYyyymm = fromValue.slice(0, 6);
    setSearchParams({
      fromYyyymm,
      toYyyymm: addMonthsToYyyymm(fromYyyymm, PERIOD_MONTHS_SPAN),
    });
  }, [periodDefaultRows, setSearchParams]);

  // R1(design/01) — 권한 division 0건이면 조회패널 비활성 + MSG00097(04_impl-gap-audit M3).
  //   MyDivision 콤보 자체가 WHERE 절에서 사용자 권한 division 으로 이미 좁혀 반환하므로
  //   (convert-core §2.6 실측), 빈 목록 = 권한 0건과 동치.
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;
  const { setAlert } = useMessageStore.getState();
  useEffect(() => {
    if (!noDivisionAuth) return;
    void setAlert({
      type: 'alert',
      content: t(MSG.REQUIRE_DIVISION, '_조회 가능한 사업부 권한이 없습니다.'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noDivisionAuth]);

  // Status = YesOrNo(Y/N) + 선두 ALL sentinel(design/02 C8, isAddALL=true).
  const statusOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: 'ALL' },
      ...(statusRows?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [statusRows, t]
  );

  // 82/40 = Project 입력/픽커 비활성 + 값 clear(design/01 R2). Sales Site 는 항상 ALL·비활성(R4).
  const projectDisabled = isProjectHiddenDivision(searchParams.divisionId);

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={noDivisionAuth ? undefined : onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) => setSearchParams({ divisionId: String(option ?? '') })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  // 선택값은 항상 ALL·비활성 死필터(2021.03.30 속도개선, design/02 R4) — SP 로는 'ALL'
                  //   고정 전달, 사용자 선택 불가. 단 AS-IS 는 division별 후보를 비활성 상태로 그대로
                  //   보여주므로(COMBO.SALES_SITE 주석 참고) 목록 자체는 실제 콤보 결과로 채운다.
                  <CustomDropdown
                    disabled
                    value='ALL'
                    options={[
                      { label: t('LBL00632', '_ALL'), value: 'ALL' },
                      ...(salesSiteRows?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []),
                    ]}
                    onChange={() => undefined}
                  />
                )}
              />
            </Grid>
            {/* AS-IS 배치 순서(design/01 §1 Loc): Div → Sales Site → Project → Model → Period → Status */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00617', '_Project')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={projectDisabled || noDivisionAuth}
                    className={commonStyles.popupSearchField}
                    value={searchParams.projectCode ?? ''}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={projectDisabled || noDivisionAuth}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() =>
                                !projectDisabled && !noDivisionAuth && setOpenProjectModal(true)
                              }
                            />
                          }
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00669', '_Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={noDivisionAuth}
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId ?? ''}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={noDivisionAuth}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !noDivisionAuth && setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                  />
                )}
              />
            </Grid>
            <PeriodField
              gridSize={3}
              mode='month'
              start={searchParams.fromYyyymm}
              end={searchParams.toYyyymm}
              // 시작월(From) 고정(design/02_search-combo.md §2 #6, G6) — AS-IS InitControls() L264
              // `MonthMin1=MonthMax1`로 From 월 자체를 재선택 불가하게 잠근다(변경 이벤트 핸들러도
              // dead code). `disabledStart`(공용 PeriodField 확장, Hard Boundary 예외 사용자 승인
              // 2026-09-21 — 04_react-gap.md G6)로 동일하게 재현. noDivisionAuth 시 Search 버튼
              // 자체가 사라져(위 onSearch) 조회는 막히므로 별도 비활성 처리는 하지 않는다.
              disabledStart
              onChange={(from, to) => setSearchParams({ fromYyyymm: from, toYyyymm: to })}
            />
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00014', '_Status')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.status}
                    options={statusOptions}
                    onChange={(_, option) => setSearchParams({ status: String(option ?? 'ALL') })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />

      {/* Model 픽커(design/02 C3/C4) — AS-IS SCM0002_ItembyDivisionPopup(base, 모1) 재사용.
          division + Sales Site + project 사전필터(AS-IS Form_Load L1302 은 division+project 둘 다
          넘긴다. project 미전달 시 후보범위가 넓어지는 드리프트였다 — 04_impl-gap-audit L3).
          DMF0014 전용 COM0008(ItemByDivisionModal, "Item Popup")은 조회조건·컬럼·SP 가 달라
          잘못된 재사용이었다 — SupplyPopupGallery.tsx 모1과 동일한 base 팝업으로 교체(2026-09-22). */}
      <ModelByDivisionPopup
        open={openItemModal}
        onClose={() => setOpenItemModal(false)}
        onSelect={selected => setSearchParams({ itemId: selected.itemId })}
        params={{
          divisionId: searchParams.divisionId,
          scmSiteId: searchParams.scmSiteId,
          projectCode: searchParams.projectCode ?? '',
          itemId: searchParams.itemId ?? '',
        }}
      />

      {/* Project 픽커(design/02 §4.6·§7-8) — AS-IS btnProject 가 여는 클래스는
          SCM0002_ProjectbyDivisionPopup(base, 프1) — DMF0040 계열 Ex(COM0005, 프2=ProjectByDivisionModal)
          와는 다른 AS-IS 팝업이다. division + 현재 입력값 사전필터(Form_Load(true, division,
          txtProject.Text)). Model 필드의 모1 교정(2026-09-22)과 동일하게 base 팝업으로 교체.
          82/40 은 비활성이라 열리지 않음. */}
      <ProjectByDivisionPopup
        open={openProjectModal}
        onClose={() => setOpenProjectModal(false)}
        onSelect={selected => setSearchParams({ projectCode: selected.projectCode })}
        params={{
          divisionId: searchParams.divisionId,
          projectCode: searchParams.projectCode ?? '',
        }}
      />
    </>
  );
};
