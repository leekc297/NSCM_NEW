import { DivisionField, VersionField } from 'features/master/src/components';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { DataType, ReportType } from '../sales-reports.constants';
import { useSalesReportsStore } from '../useSalesReportsStore';

import styles from './SalesReportsForm.module.scss';

interface SalesReportsFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset)
  onDivisionChange: () => void;
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
      searchButtonLabel={t('LBL00691', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division* / Report Type* / Year* / Data Type* */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={v => {
              // Version 은 division 종속(버전 목록이 division별) — 변경 시 초기화 (AS-IS 파리티)
              set({ divisionId: v, versionNo: '', versionLabel: '' });
              onDivisionChange();
            }}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00795', '_Report Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.mdfType}
                  options={toOptions(mdfType)}
                  onChange={(_, v) =>
                    set({ mdfType: String(v ?? '') as ReportType, versionNo: '', versionLabel: '' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00160', '_Year')}
              labelAlign='right'
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
            value={sc.versionLabel}
            onOpenPopup={onOpenVersionModal}
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
