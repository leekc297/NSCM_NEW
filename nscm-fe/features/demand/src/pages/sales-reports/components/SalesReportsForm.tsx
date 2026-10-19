import { DivisionField, VersionField, YearField } from 'features/master/src/components';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

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

  // Division 변경은 그리드를 초기화한다(onDivisionChange → resetGrid). 편집중(dirty)이면 MSG00704
  //   confirm 후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를 콤보 변경에도 동일
  //   적용. DivisionField 는 controlled(value=sc.divisionId)라 취소 시 자동 복귀.
  const tabId = useTabid();

  // 콤보 원천 (SCM_ADM_CMBO_SQL_M — MDF_TYPE 기등록 / MDF_TYPE2 P4 신설 2026-07-22)
  //   Year 는 콤보 목록이 아니라 YearField(연도 피커)로 받는다. 그쪽이 CALENDAR_YYYY 를
  //   선택 가능 범위(min/max) 계산에만 쓰므로 여기서 따로 조회하지 않는다.
  const [mdfType, mdfType2] = useTabComboQueries({
    filters: ['MDF_TYPE', 'MDF_TYPE2'],
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
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (!ok) return;
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
                    // AS-IS DMF0044_Sales_Reports.cs clbType_SelectedIndexChanged = InitSpread()(시트 재생성)
                    //   + txtSPVersion 비움 ⇒ TO-BE 도 Version 초기화 + 그리드/CRUD reset
                    //   Data Type 도 ALL 로 되돌린다 (사용자 지정 2026-09-04). Report Type 이 바뀌면
                    //   그리드가 비워지므로, 직전 타입에서 좁혀 둔 Data Type 이 남아 있으면 다음 조회가
                    //   왜 좁게 나오는지 화면만 봐서는 알 수 없다. Division 변경 시 처리와 같은 규약.
                    set({
                      mdfType: String(v ?? '') as ReportType,
                      versionNo: '',
                      versionLabel: '',
                      dataType: DATA_TYPE.ALL,
                    });
                    onReportTypeChange();
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
              label={t('LBL00089', '_Data Type')}
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
