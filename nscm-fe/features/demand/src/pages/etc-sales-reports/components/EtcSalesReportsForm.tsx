import { DivisionField, VersionField, YearField } from 'features/master/src/components';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  PLAN_RESULT,
  REPORT_TYPE,
  type PlanResult,
  type ReportType,
} from '../etc-sales-reports.constants';
import { useEtcSalesReportsStore } from '../useEtcSalesReportsStore';

interface EtcSalesReportsFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset)
  onDivisionChange: () => void;
  // ⭐ REQ:CHAT-20260820-15 — AS-IS 가 `InitSpread()` 를 부르는 나머지 2개 조회조건.
  //   Report Type = `DMF0049_Sales_ETC_Reports.cs:1530~1539`, Plan/Result = `.cs:1566~1573`.
  //   Year 는 AS-IS 에 변경 핸들러가 없어 prop 을 두지 않는다(.Designer.cs 등록 0건 실측).
  onReportTypeChange: () => void;
  onPlanResultChange: () => void;
  onOpenVersionModal: () => void; // btnSPVer '...' — United 팝업 (Version 주입)
}

// AS-IS DMF0049 조회조건 (주요이벤트 L17 전수 — Company 캐시만 제외. clbDivision 이중구독 승계 금지):
//   Row1: Division*(카탈로그 MyDivision) / Report Type*(MDF_TYPE) / Year*(CALENDAR_YYYY) / Data Type*(MDF_TYPE2)
//   Row2: Version(readonly + '...' 버튼 — United 팝업 주입. 조회·저장 필수키)
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 36px. 버튼 3종(Measure/Exchange/Textbox)은 TitleArea(메인) 소관.
//   ⚠ AS-IS clbDivision 이중 구독(Designer+코드 — InitSpread 2회) 은 승계 금지 — 단일 핸들러.
export const EtcSalesReportsForm = ({
  onSearch,
  onDivisionChange,
  onReportTypeChange,
  onPlanResultChange,
  onOpenVersionModal,
}: EtcSalesReportsFormProps) => {
  const { t } = useTranslation();

  const sc = useEtcSalesReportsStore(s => s.searchCondition);
  const set = useEtcSalesReportsStore(s => s.setSearchCondition);
  const openSearchArea = useEtcSalesReportsStore(s => s.openSearchArea);

  // Division 변경은 그리드를 초기화한다(onDivisionChange → clearChanges/clearFilters). 편집중(dirty)
  //   이면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를 콤보
  //   변경에도 동일 적용. DivisionField 는 controlled(value=sc.divisionId)라 취소 시 자동 복귀.
  const tabId = useTabid();

  // 콤보 원천 (SCM_ADM_CMBO_SQL_M — MDF_TYPE 기등록 / MDF_TYPE2·CALENDAR_YYYY P4 신설 2026-07-22)
  // const [mdfType, calendarYyyy] = useTabComboQueries({
  //   filters: ['MDF_TYPE', 'CALENDAR_YYYY'],
  // });
  const [mdfType] = useTabComboQueries({ filters: ['MDF_TYPE'] });

  const toOptions = (rows: Array<Record<string, unknown>> | undefined) =>
    ((rows ?? []) as unknown as Array<Record<string, string>>).map(r => ({
      label: String(r.NAME ?? r.CODE ?? ''),
      value: String(r.CODE ?? ''),
    }));

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division* / Report Type* / Year* / Data Type* */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (!ok) return;
                // Version 은 division 종속(버전 목록이 division별) — 변경 시 초기화 (AS-IS 파리티)
                set({
                  divisionId: v,
                  versionNo: '',
                  versionLabel: '',
                  mdfType: REPORT_TYPE.SP_W,
                  yyyy: dayjs().format('YYYY'),
                  planResult: PLAN_RESULT.PLAN,
                });
                onDivisionChange();
              });
            }}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00795', '_Report Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={sc.mdfType}
                  options={toOptions(mdfType)}
                  onChange={(_, v) => {
                    // AS-IS clbType_SelectedIndexChanged(.cs:1530~1539): txtSPVersion.Text = null
                    //   (BP/SP 로 버전 체계가 갈리므로 이전 버전은 그대로 쓸 수 없다)
                    set({
                      mdfType: String(v ?? '') as ReportType,
                      versionNo: '',
                      versionLabel: '',
                    });
                    onReportTypeChange(); // 같은 핸들러의 InitSpread() = 그리드 초기화
                  }}
                />
              )}
            />
          </Grid>
          <YearField
            gridSize={3}
            label={t('LBL00086', '_Year')}
            value={sc.yyyy}
            onChange={v => set({ yyyy: v })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00094', '_Plan/Result')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={sc.planResult}
                  options={[
                    { label: 'Plan', value: PLAN_RESULT.PLAN },
                    { label: 'Result', value: PLAN_RESULT.RESULT },
                  ]}
                  onChange={(_, v) => {
                    set({ planResult: String(v ?? '') as PlanResult });
                    // AS-IS clbPlanResult_SelectedIndexChanged(.cs:1566~1573) = InitSpread() +
                    //   DefineProperty(). Plan↔Result 는 잠금·회색 축이 뒤집히므로 기존 조회 결과를
                    //   그대로 두면 편집 가능 구간이 화면과 어긋난다. 버전은 AS-IS 도 유지한다.
                    onPlanResultChange();
                  }}
                />
              )}
            />
          </Grid>

          {/* Row 2 — Version — 표준 VersionField 로 교체 (2026-07-30 사용자 지시).
              이전엔 FormItem 밖에 '...' 텍스트 Button 을 둔 커스텀 div(versionCell — scss 미정의)로
              조회조건 표준(PopupSearchInput + 우상단 검색 아이콘 버튼)을 벗어나 있었다.
              라벨은 BP/SP 구분이 있어 label prop 으로만 오버라이드하고(기본값 LBL00513 보존),
              미선택 상태는 'Current' 가 아니므로 emptyText='' 로 둔다. */}
          <VersionField
            // BOX WIDTH = 타 조회항목(1개) 동일 — 기본 size 6 은 2배폭 (사용자 지정 2026-08-28, DMF0044 동일)
            gridSize={3}
            value={sc.versionLabel}
            onOpenPopup={onOpenVersionModal}
            // 직접 입력(key-in) 허용 — 친 문자열을 그대로 조회키(versionNo)로 쓴다 (DMF0044 동일 규약).
            //   팝업 선택은 표시문에 DESCRIPTION 이 붙지만 직접 입력은 원문이 곧 표시문이다.
            //    --> 해당 주석 변경, DESCRIPTION을 아예 붙이지 않는 것으로 변경됨 (2026-09-03)
            //   존재하지 않는 버전을 치면 조회 0건으로 떨어진다(SP 판정 — FE 사전 검증 없음).
            onValueChange={v => set({ versionNo: v, versionLabel: v })}
            // 팝업 라벨('VERSION_NO 설명') 뒤에서 편집을 시작하면 설명까지 조회키가 되므로
            //   포커스 순간 코드만 남긴다.
            versionNo={sc.versionNo}
            label={
              sc.mdfType === 'REPORT_BP_M'
                ? t('LBL00797', '_BP Version')
                : t('LBL00798', '_SP Version')
            }
            emptyText=''
          />
        </>
      }
    />
  );
};
