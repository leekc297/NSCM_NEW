import { DivisionField, VersionField } from 'features/master/src/components';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { DATA_TYPE, REPORT_TYPE } from '../sales-reports.constants';
import type { DataType, ReportType } from '../sales-reports.constants';
import { useSalesReportsStore } from '../useSalesReportsStore';

interface SalesReportsFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset)
  onDivisionChange: () => void;
  // ⭐ Report Type 변경 = Grid 초기화 (AS-IS clbType_SelectedIndexChanged = InitSpread + Version 비움.
  //    사용자 지정 2026-08-20 REQ:CHAT-20260820-2 — Division 과 동일 처우)
  onReportTypeChange: () => void;
  onOpenVersionModal: () => void; // btnSPVer '...' — United 팝업 (Version 주입)
}

// AS-IS DMF0044 조회조건 8 컨트롤 (상세동작 §2.2 전수 — Company 캐시만·바인딩 없음 제외):
//   Row1: Division*(카탈로그 MyDivision) / Report Type*(MDF_TYPE) / Year*(CALENDAR_YYYY) / Data Type*(MDF_TYPE2)
//   Row2: Version(readonly + '...' 버튼 — United 팝업 주입. 조회·저장 필수키)
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 36px. 버튼 3종(Measure/Exchange/Textbox)은 TitleArea(메인) 소관.
//   ⚠ AS-IS clbDivision 이중 구독(Designer+코드 — InitSpread 2회) 은 승계 금지 — 단일 핸들러.
export const SalesReportsForm = ({
  onSearch,
  onDivisionChange,
  onReportTypeChange,
  onOpenVersionModal,
}: SalesReportsFormProps) => {
  const { t } = useTranslation();

  const sc = useSalesReportsStore(s => s.searchCondition);
  const set = useSalesReportsStore(s => s.setSearchCondition);
  const openSearchArea = useSalesReportsStore(s => s.openSearchArea);

  // 콤보 원천 (SCM_ADM_CMBO_SQL_M — MDF_TYPE 기등록 / MDF_TYPE2·CALENDAR_YYYY P4 신설 2026-07-22)
  const [mdfType, mdfType2, calendarYyyy] = useTabComboQueries({
    filters: ['MDF_TYPE', 'MDF_TYPE2', 'CALENDAR_YYYY'],
  });

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
              // Version 은 division 종속(버전 목록이 division별) — 변경 시 초기화 (AS-IS 파리티)
              set({
                divisionId: v,
                versionNo: '',
                versionLabel: '',
                mdfType: REPORT_TYPE.SP_W,
                yyyy: dayjs().format('YYYY'),
                dataType: DATA_TYPE.ALL,
              });
              onDivisionChange();
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
                    // AS-IS DMF0044_Sales_Reports.cs clbType_SelectedIndexChanged = InitSpread()(시트 재생성)
                    //   + txtSPVersion 비움 ⇒ TO-BE 도 Version 초기화 + 그리드/CRUD reset
                    set({
                      mdfType: String(v ?? '') as ReportType,
                      versionNo: '',
                      versionLabel: '',
                    });
                    onReportTypeChange();
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00086', '_Year')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={sc.yyyy}
                  options={toOptions(calendarYyyy)}
                  onChange={(_, v) => set({ yyyy: String(v ?? '') })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00796', '_Data Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={sc.dataType}
                  options={toOptions(mdfType2)}
                  onChange={(_, v) => set({ dataType: String(v ?? '') as DataType })}
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
            // BOX WIDTH = 타 조회항목(1개) 동일 — 기본 size 6 은 2배폭 (사용자 지정 2026-08-28)
            gridSize={3}
            value={sc.versionLabel}
            onOpenPopup={onOpenVersionModal}
            // 직접 입력(key-in) 허용 — 친 문자열을 그대로 조회키(versionNo)로 쓴다.
            //   팝업 선택은 표시문에 DESCRIPTION 이 붙지만 직접 입력은 원문이 곧 표시문이다.
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
