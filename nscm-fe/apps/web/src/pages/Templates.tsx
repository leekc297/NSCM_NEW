import { templateItemsSource, templateStaticColumns } from '@mock/data/template';

import { ChartType, FlexChart } from '@mescius/wijmo.chart';
import { PivotEngine } from '@mescius/wijmo.olap';
import { PivotGrid, PivotPanel } from '@mescius/wijmo.react.olap';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { SupplyPopupGallery } from '@supply/popup-gallery';
import { apiClient } from '@foundation/apis';
import { API_CONFIG } from '@foundation/constants';
import { i18n } from '@foundation/i18n';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import {
  DataGrid,
  CascadeDropdown,
  CustomDropdown,
  PeriodRangePicker,
  TabWrapper,
  TabItem,
  MainTitle,
  SearchArea,
} from '@shared/components';
import type { CascadeNode } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import type { DropdownOption } from '@shared/lges';
import { Divider, FormItem, InputField, Radio, RadioGroup } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { useMDIStore } from '../mdi/useMDIStore';

import type { GanttTask } from './TemplatesGantt';
import {
  ganttTasks,
  repeatGanttTasks,
  getGanttTooltipContent,
  formatRepeatGanttAxisLabel,
  renderGanttProgress,
  renderGanttDependencies,
} from './TemplatesGantt';
import { TreeViewExample } from './TemplatesTreeView';

interface SearchParamsProps {
  텍스트: string;
  멀티: string;
  멀티_WITH_ALL: string;
  단일: string;
  단일_WITH_ALL: string;
  추가1: string;
  추가2: string;
  추가3: string;
  추가4: string;
}

const genBulkDropdown = (count: number = 10, txt?: string) => {
  const result: DropdownOption[] = [];
  Array.from({ length: count }, (_, i) => {
    result.push({ label: `${i}_${txt ?? 'lbl'}`, value: `${i}` });
  });
  return result;
};

// 데모용 정적 트리(지역 > 국가 > 도시 > 구역, 최대 4단계). 실제 화면에서는 이 자리에
//   조회 콤보 결과를 넣으면 된다 — 데이터 모양만 { value, label, children } 로 맞추면 동작한다.
const CASCADE_SAMPLE_TREE: CascadeNode[] = [
  {
    value: 'asia',
    label: '아시아',
    children: [
      {
        value: 'kr',
        label: '대한민국',
        children: [
          {
            value: 'seoul',
            label: '서울',
            children: [
              { value: 'gangnam', label: '강남구' },
              { value: 'mapo', label: '마포구' },
            ],
          },
          {
            value: 'busan',
            label: '부산',
            children: [
              { value: 'haeundae', label: '해운대구' },
              { value: 'suyeong', label: '수영구' },
            ],
          },
        ],
      },
      {
        value: 'jp',
        label: '일본',
        children: [
          {
            value: 'tokyo',
            label: '도쿄',
            children: [
              { value: 'shinjuku', label: '신주쿠' },
              { value: 'shibuya', label: '시부야' },
            ],
          },
          {
            value: 'osaka',
            label: '오사카',
            children: [
              { value: 'kita', label: '기타구' },
              { value: 'chuo', label: '주오구' },
            ],
          },
        ],
      },
    ],
  },
  {
    value: 'europe',
    label: '유럽',
    children: [
      {
        value: 'de',
        label: '독일',
        children: [
          {
            value: 'berlin',
            label: '베를린',
            children: [
              { value: 'mitte', label: '미테' },
              { value: 'pankow', label: '판코' },
            ],
          },
        ],
      },
      {
        value: 'fr',
        label: '프랑스',
        children: [
          {
            value: 'paris',
            label: '파리',
            children: [
              { value: 'louvre', label: '루브르' },
              { value: 'marais', label: '마레' },
            ],
          },
        ],
      },
    ],
  },
];

// CascadeDropdown · CascadeNode · CascadeLevel 은 공용 컴포넌트로 이동했다(@shared/components).
//   아래 두 데모는 그 공용 컴포넌트를 쓴다.

// Production Plan Line 의 Plan Date → Plan Type → Seq 세트(종속 콤보)를 위 캐스케이더로 재구성한 예.
//   콤보는 실제 등록 콤보를 그대로 가져온다 — home 탭이라도 mnuId 를 SCP0013 으로 명시해 그 화면과 같은
//   스코프로 요청한다(withMenuId 는 param 에 mnuId 가 없을 때만 주입하므로 명시하면 그 값이 쓰인다).
//   _SCP_ALL 전량 콤보라, 반환 컬럼(PLANDATE/PLANTYPE)으로 상위-하위를 이어 트리를 만든다
//   (AS-IS CommonAll + DBUtils.Filter 클라 재현과 동치, convert-core §2.6).
const PLAN_VERSION_MENU_ID = 'SCP0013';
const PLAN_VERSION_COMBO = {
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // CODE=plan_start_yyyymmdd, 반환 DIVISION_ID
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE/PLANTYPE
} as const;

const PlanVersionCascade = () => {
  const [planDates, planTypes, planSeqs] = useTabComboQueries({
    filters: [
      { comboId: PLAN_VERSION_COMBO.PLAN_DATE, mnuId: PLAN_VERSION_MENU_ID },
      { comboId: PLAN_VERSION_COMBO.PLAN_TYPE, mnuId: PLAN_VERSION_MENU_ID },
      { comboId: PLAN_VERSION_COMBO.PLAN_SEQ, mnuId: PLAN_VERSION_MENU_ID },
    ],
  });

  // 반환 컬럼으로 상위-하위를 잇는다 — planType 행은 PLANDATE 로, planSeq 행은 PLANDATE+PLANTYPE 로 묶는다.
  const tree = useMemo<CascadeNode[]>(() => {
    // 콤보 셀 값은 문자열/숫자다 — 객체가 '[object Object]' 로 찍히지 않도록 원시값만 문자열화한다.
    const cell = (row: unknown, key: string): string => {
      const v = (row as Record<string, unknown>)[key];
      return typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    };
    const toNode = (row: unknown): CascadeNode => ({
      value: cell(row, 'CODE'),
      label: cell(row, 'NAME') || cell(row, 'CODE'),
    });
    // 같은 value 중복 제거(division 필터가 없어 콤보가 넓게 올 수 있다 — 표시 기준 first-wins).
    const dedupe = (nodes: CascadeNode[]): CascadeNode[] => {
      const seen = new Map<string, CascadeNode>();
      nodes.forEach(node => {
        if (node.value && !seen.has(node.value)) seen.set(node.value, node);
      });
      return [...seen.values()];
    };

    return dedupe((planDates ?? []).map(toNode)).map(date => ({
      ...date,
      children: dedupe(
        (planTypes ?? []).filter(row => cell(row, 'PLANDATE') === date.value).map(toNode)
      ).map(type => ({
        ...type,
        children: dedupe(
          (planSeqs ?? [])
            .filter(
              row => cell(row, 'PLANDATE') === date.value && cell(row, 'PLANTYPE') === type.value
            )
            .map(toNode)
        ),
      })),
    }));
  }, [planDates, planTypes, planSeqs]);

  return (
    <CascadeDropdown
      tree={tree}
      levels={[
        { name: 'planDate', label: 'Plan Date' },
        { name: 'planType', label: 'Plan Type' },
        { name: 'planSeq', label: 'Seq' },
      ]}
    />
  );
};

const GanttChartExample = ({
  title,
  description,
  items,
  repeatAxis = false,
  showProgress = false,
  showDependencies = false,
}: {
  title: string;
  description: string;
  items: GanttTask[];
  repeatAxis?: boolean;
  showProgress?: boolean;
  showDependencies?: boolean;
}) => {
  const chartRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!chartRef.current) {
      return undefined;
    }

    const chart = new FlexChart(chartRef.current, {
      itemsSource: items,
      chartType: ChartType.Bar,
      bindingX: repeatAxis ? 'index' : 'name',
      series: [{ binding: 'start,end', name: '기간' }],
      axisX: {
        format: 'MM/dd',
      },
      axisY: {
        majorGrid: false,
        minorGrid: true,
        reversed: true,
        ...(repeatAxis ? { itemFormatter: formatRepeatGanttAxisLabel(items) } : {}),
      },
      plotMargin: repeatAxis ? 'auto auto auto 180' : 'auto',
      tooltip: {
        content: getGanttTooltipContent,
      },
      ...(showProgress ? { itemFormatter: renderGanttProgress } : {}),
      ...(showDependencies ? { rendered: renderGanttDependencies } : {}),
    });

    return () => {
      chart.dispose();
    };
  }, [items, repeatAxis, showDependencies, showProgress]);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      <h3>{title}</h3>
      <span>{description}</span>
      <div style={{ overflowX: 'auto' }}>
        <div ref={chartRef} style={{ minWidth: '720px', height: '320px' }} />
      </div>
    </div>
  );
};

/** 백엔드 POST /file/image-upload 응답 (BaseResponse.result) */
interface ImageUploadResult {
  fileId: string;
  url: string;
  fileName: string;
  size: number;
}

/**
 * 이미지 업로드 / 조회 샘플.
 *
 * 백엔드는 조회 경로를 상대경로(`/file/image/{fileId}`)로만 내려주므로
 * 화면에서 API baseURL을 앞에 붙여 <img src>를 조립해야 한다.
 */
const ImageUploadExample = () => {
  const [imageFile, setImageFile] = useState<File>();
  const [uploadedImages, setUploadedImages] = useState<ImageUploadResult[]>([]);
  const [uploading, setUploading] = useState(false);
  const { setAlert, setToast } = useMessageStore();

  const toImageSrc = (url: string) => `${API_CONFIG.BASE_URL}${url}`;

  const handleUpload = async () => {
    if (!imageFile) {
      void setAlert({ type: 'alert', content: '업로드할 이미지를 선택하세요.' });
      return;
    }

    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('file', imageFile);
      formData.append('fileKdnCd', 'NOTICE');

      // Content-Type을 직접 지정하지 않는다.
      // apiClient가 FormData를 감지해 헤더를 지우고 브라우저가 boundary를 채우도록 위임한다.
      const res = await apiClient.post<ImageUploadResult>('/file/image-upload', formData);

      // 인터셉터가 403/500을 reject하지 않으므로 status와 code를 함께 확인한다.
      if (res.status >= 400 || Number(res.data?.code)) {
        void setAlert({
          type: 'alert',
          content: res.data?.message?.trim() || '이미지 업로드에 실패했습니다.',
        });
        return;
      }

      setUploadedImages(prev => [res.data.result, ...prev]);
      setToast({ message: '이미지를 업로드했습니다.', type: 'success' });
    } finally {
      setUploading(false);
    }
  };

  return (
    <section aria-labelledby='image-upload'>
      <h2 id='image-upload'>이미지 업로드 / 보기</h2>
      <FilePath paths={['apps/web/src/pages/Templates.tsx (ImageUploadExample)']} />
      <p style={{ color: '#666', fontSize: '13px' }}>
        jpg, jpeg, png, gif, webp / 최대 15MB. 서버가 확장자와 실제 파일 헤더(매직바이트)를 함께
        검사합니다.
      </p>

      <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
        <input
          type='file'
          accept='image/jpeg,image/png,image/gif,image/webp'
          onChange={e => setImageFile(e.target.files?.[0] || undefined)}
        />
        <button disabled={uploading} onClick={() => void handleUpload()}>
          {uploading ? '업로드 중...' : '이미지 업로드'}
        </button>
      </div>

      {uploadedImages.length > 0 && (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '16px', marginTop: '16px' }}>
          {uploadedImages.map(image => (
            <figure
              key={image.fileId}
              style={{ margin: 0, border: '1px solid #ddd', padding: '8px', width: '260px' }}
            >
              <img
                src={toImageSrc(image.url)}
                alt={image.fileName}
                style={{ width: '100%', height: '160px', objectFit: 'contain' }}
              />
              <figcaption style={{ fontSize: '12px', wordBreak: 'break-all', marginTop: '8px' }}>
                <div>{image.fileName}</div>
                <div style={{ color: '#666' }}>{Math.round(image.size / 1024)} KB</div>
                <div style={{ color: '#666' }}>{image.url}</div>
              </figcaption>
            </figure>
          ))}
        </div>
      )}
    </section>
  );
};

/** 섹션이 사용하는 실제 컴포넌트 파일 위치(nscm-fe 루트 기준) — 제목·본문과 떨어뜨려 한 블록으로 표시한다. */
const FilePath = ({ paths }: { paths: string[] }) => (
  <div
    style={{
      display: 'flex',
      flexDirection: 'column',
      gap: '2px',
      margin: '4px 0 12px',
      color: '#aaa',
      fontSize: '12px',
      lineHeight: 1.5,
    }}
  >
    {paths.map(path => (
      <span key={path}>{path}</span>
    ))}
  </div>
);

const RadioGroupExample = () => {
  const [basic, setBasic] = useState('MONTH');
  const [withDisabled, setWithDisabled] = useState('A');
  const [inForm, setInForm] = useState('MONTH');

  return (
    <section aria-labelledby='radio-group'>
      <h2 id='radio-group'>라디오 그룹</h2>
      <FilePath
        paths={[
          'packages/shared/src/lib/lges.ts (Radio, RadioGroup)',
          'apps/web/src/pages/Templates.tsx (RadioGroupExample)',
        ]}
      />
      <p style={{ color: '#666', fontSize: '13px' }}>
        RadioGroup 안에 Radio(value, labelText)를 나열한다. 선택값은 RadioGroup 의 value /
        onChange 로 관리한다.
      </p>

      <h3>가로 배치 (row)</h3>
      <RadioGroup row value={basic} onChange={(_, v) => setBasic(v)}>
        <Radio value='MONTH' labelText='월마감 기준' />
        <Radio value='DAILY' labelText='일별 기준' />
      </RadioGroup>
      <div>선택값: {basic}</div>

      <h3>비활성 옵션 포함</h3>
      <RadioGroup row value={withDisabled} onChange={(_, v) => setWithDisabled(v)}>
        <Radio value='A' labelText='옵션 A' />
        <Radio value='B' labelText='옵션 B (disabled)' disabled />
        <Radio value='C' labelText='옵션 C' />
      </RadioGroup>
      <div>선택값: {withDisabled}</div>

      <h3>세로 배치 + FormItem 라벨</h3>
      <Grid size={4}>
        <FormItem
          label='조회 기준'
          labelAlign='right'
          render={() => (
            <RadioGroup value={inForm} onChange={(_, v) => setInForm(v)}>
              <Radio value='MONTH' labelText='월마감 기준' />
              <Radio value='DAILY' labelText='일별 기준' />
            </RadioGroup>
          )}
        />
      </Grid>
      <div>선택값: {inForm}</div>
    </section>
  );
};

export const Templates = () => {
  const { t } = useTranslation();

  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);

  const [file, setFile] = useState<File>();
  const [drpodown1, setDrpodown1] = useState<string>();
  const [drpodown2, setDrpodown2] = useState<string>();
  const [periodStart, setPeriodStart] = useState('20260914');
  const [periodEnd, setPeriodEnd] = useState('20270912');

  const { setToast, setAlert } = useMessageStore();
  const { refetch } = useQuery({
    queryKey: [tabs[activeIndex].tabId, 'TEST'],
    queryFn: async () => {
      await new Promise(_ => setTimeout(_, 2000));
    },
    enabled: false,
  });

  const [searchParams, setSearchParams] = useState<SearchParamsProps>({} as SearchParamsProps);
  const [searchParamsOption, setSearchParamsOption] = useState<SearchParamsProps>(
    {} as SearchParamsProps
  );

  const sampleData = [
    { item: 'A', account: '거래처1', month: '202601', qty: 100 },
    { item: 'A', account: '거래처2', month: '202601', qty: 200 },
    { item: 'B', account: '거래처1', month: '202602', qty: 300 },
  ];

  const pivotEngine = useMemo(() => {
    return new PivotEngine({
      itemsSource: sampleData,
      rowFields: ['Item'],
      columnFields: ['Month'],
      valueFields: ['Qty'],
      showRowTotals: 'Subtotals',
      showColumnTotals: 'Subtotals',
    });
  }, []);

  return (
    <div
      style={{
        height: '100%',
        overflowY: 'auto',
        padding: '20px',
        display: 'flex',
        flexDirection: 'column',
        gap: '20px',
      }}
    >
      <h1>Templates</h1>
      <Divider />

      <SupplyPopupGallery />
      <Divider />

      <section aria-labelledby='file-upload'>
        <h2>파일업로드</h2>
        <FilePath
          paths={[
            'packages/foundation/src/apis/axios.ts (apiClient)',
            'apps/web/src/pages/Templates.tsx (인라인 구현)',
          ]}
        />
        <input type='file' onChange={e => setFile(e.target.files?.[0] || undefined)} />
        <button
          onClick={() => {
            const formData = new FormData();
            if (file) formData.append('file', file);
            void apiClient.post('/common/fileupload', formData);
          }}
        >
          업로드
        </button>
      </section>
      <Divider />
      <section aria-labelledby='i18n'>
        <h2>커스텀 드롭다운</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx',
          ]}
        />
        <br />
        <div style={{ width: '300px' }}>
          단일선택
          <CustomDropdown
            placeholder='단일선택'
            value={drpodown1}
            onChange={(_, option) => setDrpodown1(option)}
            options={genBulkDropdown(1000, 'aaa')}
          />
        </div>
        <div style={{ width: '300px' }}>
          단일선택 with ALL
          <CustomDropdown
            placeholder='단일선택'
            value={drpodown1}
            allOption={true}
            onChange={(_, option) => setDrpodown1(option)}
            options={genBulkDropdown(1000, 'aaa')}
          />
        </div>
        <div style={{ width: '300px' }}>
          다중선택
          <CustomDropdown
            limitTags={2}
            useClearIcon
            multiple
            value={drpodown2}
            onChange={(_, options) => setDrpodown2(options)}
            options={genBulkDropdown(1000, 'bbb')}
          />
        </div>
      </section>
      <Divider />
      <section aria-labelledby='cascade-dropdown'>
        <h2>캐스케이딩 드롭다운 (종속 콤보 + 공유 캐스케이더)</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/molecules/cascadeDropdown/CascadeDropdown.tsx',
          ]}
        />
        <span>
          1단계~4단계 필드를 항상 보여주되, 어느 필드를 누르든 같은 컬럼 팝업이 열린다. 팝업에서 경로를
          골라 내려가면 각 단계 필드가 함께 채워지고, 상위를 바꾸면 하위는 초기화된다. 값은 다른
          검색조건처럼 name 키(level1~level4)로 담긴다.
        </span>
        <br />
        <CascadeDropdown
          tree={CASCADE_SAMPLE_TREE}
          levels={[
            { name: 'level1', label: '1단계' },
            { name: 'level2', label: '2단계' },
            { name: 'level3', label: '3단계' },
            { name: 'level4', label: '4단계' },
          ]}
        />
      </section>
      <Divider />
      <section aria-labelledby='plan-version-cascade'>
        <h2>Plan Date / Plan Type / Seq 세트 (실콤보 — SCP0013)</h2>
        <FilePath
          paths={[
            'apps/web/src/pages/Templates.tsx (PlanVersionCascade)',
            'packages/shared/src/components/molecules/cascadeDropdown/CascadeDropdown.tsx',
            'packages/shared/src/hooks/useCustomQueryClient.ts (useTabComboQueries)',
          ]}
        />
        <span>
          Production Plan Line 의 Plan Date → Plan Type → Seq 종속 세트를 위 캐스케이더 구성으로 가져온
          것. 콤보는 실제 등록 콤보(_SCP_ALL)를 SCP0013 스코프로 불러와, 반환 컬럼(PLANDATE/PLANTYPE)으로
          상위-하위를 이어 붙인다.
        </span>
        <br />
        <PlanVersionCascade />
      </section>
      <Divider />
      <section aria-labelledby='period-range-picker'>
        <h2>Period 컴포넌트 (임시)</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/molecules/periodRangePicker/PeriodRangePicker.tsx',
          ]}
        />
        <span>
          주차(WEEK) 표시 from/to 달력 프로토타입. kyr/SCP_DM_화면별 조회조건 정리_260731_v0.5
          To-Do 2번 참고.
        </span>
        <div style={{ width: '360px' }}>
          <PeriodRangePicker
            start={periodStart}
            end={periodEnd}
            onChange={(s, e) => {
              setPeriodStart(s);
              setPeriodEnd(e);
            }}
            required
          />
        </div>
      </section>
      <Divider />
      <section aria-labelledby='i18n'>
        <h2>다국어 처리</h2>
        <FilePath
          paths={[
            'packages/foundation/src/lib/i18n.ts',
          ]}
        />
        <span>우측 상단 버튼으로도 다국어 제어 가능</span>
        <div>
          <button onClick={() => i18n.changeLanguage('KO')}>KO</button>
          <button onClick={() => i18n.changeLanguage('EN')}>EN</button>
          <button onClick={() => i18n.changeLanguage('CN')}>CN</button>
        </div>
        <div>{t('LBL00110', '_LBL00110')}</div>
        <div>{t('LBL00111', '_LBL00111')}</div>
      </section>
      <Divider />
      <section aria-labelledby='tab-component'>
        <h2>탭 컴포넌트 예시</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/molecules/tab/Tab.tsx (TabWrapper, TabItem)',
          ]}
        />
        <TabWrapper
          onTabClick={e => alert(`탭 클릭!! index:${e}`)}
          onClose={e => alert(`탭 닫기 클릭!! index:${e}`)}
          clearAll={() => alert('clearAll')}
          clearOthers={() => alert('clear Others')}
        >
          <TabItem label='1번탭'>1번탭 내용</TabItem>
          <TabItem label='2번탭-closable' closable>
            2번탭 내용
          </TabItem>
          <TabItem label='3번탭'>3번탭 내용</TabItem>
        </TabWrapper>
      </section>
      <Divider />
      <section aria-labelledby='spinner'>
        <h2>각종 기능</h2>
        <FilePath
          paths={[
            '스피너: apps/web/src/mdi/MDIContainer.tsx (ProgressIndicator)',
            'packages/shared/src/components/organisms/toast-message/ToastMessage.tsx (토스트)',
            'packages/shared/src/components/organisms/alert/Alert.tsx',
            'packages/shared/src/components/templates/modals/message-modal/MessageModal.tsx (메세지)',
            'packages/shared/src/stores/useMessageStore.ts',
          ]}
        />
        <span>스피너</span>
        <button onClick={() => refetch()}>2초 페이지 스피너 기동</button>
        <br />
        <span>토스트</span>
        <button onClick={() => setToast({ message: '기본 토스트메세지입니다' })}>기본</button>
        <button onClick={() => setToast({ type: 'success', message: '성공 토스트메세지입니다' })}>
          성공
        </button>
        <button onClick={() => setToast({ type: 'error', message: '에러 토스트메세지입니다' })}>
          에러
        </button>
        <button onClick={() => setToast({ type: 'warning', message: '경고 토스트메세지입니다' })}>
          경고
        </button>
        <br />
        <span>메세지</span>
        <button
          onClick={async () =>
            alert(
              await setAlert({
                type: 'confirm',
                header: 'confirm header',
                content: 'confirm은 취소버튼이 있어요',
                onClose: () => alert('confirm: 취소/닫기'),
                onConfirm: () => alert('confirm: 확인'),
              })
            )
          }
        >
          confirm (await 가능)
        </button>
        <button
          onClick={async () => {
            const value = await setAlert({
              header: 'alert header',
              content: 'alert은 취소버튼이 없어요.\n그래도 창이 닫힐 때 onClose는 동작함',
              onClose: () => alert('alert: 닫기'),
              onConfirm: () => alert('alert: 확인'),
            });
            alert(value);
          }}
        >
          alert (await 가능)
        </button>
      </section>
      <Divider />
      <section aria-labelledby='search-area'>
        <h2>검색조건 영역</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/organisms/search-area/SearchArea.tsx',
            'features/master/src/components/searchFields/SearchFields.tsx (PeriodField)',
            'packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx',
          ]}
        />
        <SearchArea
          searchButtonLabel='Search'
          myOptions={['MyOption']}
          onSearch={() => alert(JSON.stringify(searchParams))}
          onResetCondition={() => setSearchParams({} as SearchParamsProps)}
          onSaveOption={() => {
            setSearchParamsOption(searchParams);
            alert('검색조건 저장');
          }}
          onSelectedMyOption={() => {
            setSearchParams(searchParamsOption);
            alert('검색조건 로드');
          }}
          conditions={
            <>
              <Grid size={4}>
                <FormItem
                  id='req1'
                  label={t('', '_텍스트')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={searchParams.텍스트 ?? ''}
                      onChange={val =>
                        setSearchParams(state => ({
                          ...state,
                          텍스트: val.target.value,
                        }))
                      }
                      size='large'
                      status='default'
                      textAlign='left'
                      type='text'
                    />
                  )}
                  required
                />
              </Grid>
              <Grid size={3}>
                <FormItem
                  id='req2'
                  label={t('', '_멀티')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      multiple
                      limitTags={2}
                      value={searchParams?.멀티}
                      onChange={(_, options) =>
                        setSearchParams(state => ({
                          ...state,
                          멀티: options,
                        }))
                      }
                      options={[
                        { value: '1', label: '1' },
                        { value: '2', label: '2' },
                        { value: '3', label: '3' },
                        { value: '4', label: '4' },
                        { value: '5', label: '5' },
                        { value: '6', label: '6' },
                      ]}
                    />
                  )}
                  required
                />
              </Grid>
              <Grid size={3}>
                <FormItem
                  id='req2'
                  label={t('', '_멀티 with ALL')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      multiple
                      allOption
                      useClearIcon
                      limitTags={2}
                      value={searchParams?.멀티_WITH_ALL}
                      onChange={(_, options) =>
                        setSearchParams(state => ({
                          ...state,
                          멀티_WITH_ALL: options,
                        }))
                      }
                      options={[
                        { value: '1', label: '1' },
                        { value: '2', label: '2' },
                        { value: '3', label: '3' },
                        { value: '4', label: '4' },
                        { value: '5', label: '5' },
                        { value: '6', label: '6' },
                      ]}
                    />
                  )}
                  required
                />
              </Grid>
              <Grid size={3}>
                <FormItem
                  id='opt1'
                  label={t('', '_단일')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      id='opt1'
                      isInput={false}
                      value={searchParams?.단일}
                      placeholder='단일'
                      onChange={(_, option) => {
                        setSearchParams(state => ({
                          ...state,
                          단일: option,
                        }));
                      }}
                      options={[
                        { value: 'A', label: 'AA' },
                        { value: 'B', label: 'BB' },
                        { value: 'C', label: 'CC' },
                        { value: 'D', label: 'DD' },
                        { value: 'E', label: 'EE' },
                        { value: 'F', label: 'FF' },
                      ]}
                    />
                  )}
                />
              </Grid>
              <Grid size={3}>
                <FormItem
                  id='opt1'
                  label={t('', '_단일 with ALL')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      id='opt1'
                      isInput={false}
                      allOption
                      value={searchParams?.단일_WITH_ALL}
                      placeholder='단일 with ALL'
                      onChange={(_, option) => {
                        setSearchParams(state => ({
                          ...state,
                          단일_WITH_ALL: option,
                        }));
                      }}
                      options={[
                        { value: 'A', label: 'AA' },
                        { value: 'B', label: 'BB' },
                        { value: 'C', label: 'CC' },
                        { value: 'D', label: 'DD' },
                        { value: 'E', label: 'EE' },
                        { value: 'F', label: 'FF' },
                      ]}
                    />
                  )}
                />
              </Grid>
              <PeriodField
                gridSize={4}
                start={periodStart}
                end={periodEnd}
                onChange={(s, e) => {
                  setPeriodStart(s);
                  setPeriodEnd(e);
                }}
              />
            </>
          }
          extraConditions={
            <>
              <Grid size={4}>
                <FormItem
                  id='ext1'
                  label={t('', '_추가 조회조건 01')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      onChange={val =>
                        setSearchParams(state => ({
                          ...state,
                          추가1: val.target.value,
                        }))
                      }
                      size='large'
                      status='default'
                      textAlign='left'
                      type='text'
                    />
                  )}
                />
              </Grid>
              <Grid size={2}>
                <FormItem
                  id='ext2'
                  label={t('', '_추가 조회조건 02')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      isInput={false}
                      options={[
                        { value: 'Y', label: 'Y' },
                        { value: 'N', label: 'N' },
                      ]}
                      onChange={(_, option) => {
                        setSearchParams(state => ({
                          ...state,
                          추가2: option,
                        }));
                      }}
                    />
                  )}
                />
              </Grid>
              <Grid size={2}>
                <FormItem
                  id='ext3'
                  label={t('', '_추가 조회조건 03')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      isInput={false}
                      options={[
                        { value: 'Y', label: 'Y' },
                        { value: 'N', label: 'N' },
                      ]}
                      onChange={(_, option) => {
                        setSearchParams(state => ({
                          ...state,
                          추가3: option,
                        }));
                      }}
                    />
                  )}
                />
              </Grid>
              <Grid size={2}>
                <FormItem
                  id='ext4'
                  label={t('', '_추가 조회조건 04')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      isInput={false}
                      options={[
                        { value: 'Y', label: 'Y' },
                        { value: 'N', label: 'N' },
                      ]}
                      onChange={(_, option) => {
                        setSearchParams(state => ({
                          ...state,
                          추가4: option,
                        }));
                      }}
                    />
                  )}
                />
              </Grid>
            </>
          }
        />
      </section>
      <Divider />
      <h2>Pivot Table</h2>
      <FilePath
        paths={[
          '외부 라이브러리 @mescius/wijmo.react.olap (PivotPanel, PivotGrid) 직접 사용',
        ]}
      />
      <div style={{ display: 'flex', gap: '12px' }}>
        <div style={{ width: '400px' }}>
          <PivotPanel itemsSource={pivotEngine} />
        </div>

        <div style={{ flex: 1, height: '600px' }}>
          <PivotGrid itemsSource={pivotEngine} />
        </div>
      </div>
      <Divider />
      <FilePath
        paths={[
          'packages/shared/src/components/organisms/main-title/MainTitle.tsx',
        ]}
      />
      <MainTitle
        title='Message'
        menuId='SYS0001'
        openSearchArea={true}
        toggleOpenSearchArea={() => {}}
      />
      <h2>SubTitle Default</h2>
      <FilePath
        paths={[
          'packages/shared/src/components/organisms/sub-title/SubTitle.tsx (현재 주석 처리)',
        ]}
      />
      {/* <SubTitle grid={testGrid} gridFilter={testGridFilter} dataCount={10} /> */}
      <h2>SubTitle Custom</h2>
      {/* <SubTitle
        grid={testGrid}
        gridFilter={testGridFilter}
        dataCount={10}
        onInsert={{
          tooltipText: '커스텀 툴팁',
          buttonLabel: '인서트버튼',
          onClick: () => {
            alert('오버라이드 된 커스텀 로직입니다');
          },
        }}
        onDelete={{ disable: true }}
        onExcel={{ buttonLabel: '엑셀다운로드' }}
      /> */}
      <section aria-labelledby='wijmo-grid'>
        <h2>그리드 랜더링 예시</h2>
        <FilePath
          paths={[
            'packages/shared/src/components/organisms/data-grid/DataGrid.tsx',
          ]}
        />
        <DataGrid
          itemsSource={templateItemsSource}
          staticColumns={templateStaticColumns as RawFlexGridColumnConfig[]}
        />
      </section>
      <Divider />
      <section aria-labelledby='wijmo-gantt-chart'>
        <h2 id='wijmo-gantt-chart'>간트 차트 렌더링 예시</h2>
        <FilePath
          paths={[
            'apps/web/src/pages/Templates.tsx (GanttChartExample)',
            'apps/web/src/pages/TemplatesGantt.ts',
          ]}
        />
        <GanttChartExample
          title='기본 간트 차트'
          description='작업 기간, 진행률, 작업 간 의존성을 함께 표시합니다.'
          items={ganttTasks}
          showProgress
          showDependencies
        />
        <GanttChartExample
          title='반복 작업 간트 차트'
          description='같은 index 값을 가진 데이터 항목을 같은 작업 행에 반복 일정으로 표시합니다.'
          items={repeatGanttTasks}
          repeatAxis
        />
      </section>
      <Divider />
      <section aria-labelledby='wijmo-treeview'>
        <h2 id='wijmo-treeview'>트리 메뉴(TreeView) 렌더링 예시</h2>
        <FilePath
          paths={[
            'apps/web/src/pages/TemplatesTreeView.tsx',
          ]}
        />
        <span>
          화면 중간의 세로 메뉴 패턴. 좌측 트리에서 노드를 선택하면 우측 상세 영역이 바뀝니다.
        </span>
        <TreeViewExample />
      </section>
      <Divider />
      <ImageUploadExample />
      <Divider />
      <RadioGroupExample />
    </div>
  );
};
