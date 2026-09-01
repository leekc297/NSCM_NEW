import { templateItemsSource, templateStaticColumns } from '@mock/data/template';

import { ChartType, FlexChart } from '@mescius/wijmo.chart';
import { PivotEngine } from '@mescius/wijmo.olap';
import { PivotGrid, PivotPanel } from '@mescius/wijmo.react.olap';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { API_CONFIG } from '@foundation/constants';
import { i18n } from '@foundation/i18n';
import { quoteComboParams } from '@foundation/models';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import {
  DataGrid,
  CustomDropdown,
  TabWrapper,
  TabItem,
  MainTitle,
  SearchArea,
  ToastMessage,
  Alert,
} from '@shared/components';
import type { DropdownOption } from '@shared/lges';
import { Divider, FormItem, InputField } from '@shared/lges';
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

/**
 * 회귀 테스트 섹션 — 최근 수정 2건을 화면에서 바로 재현/검증한다.
 *   1) 토스트 자동닫힘(4초)이 그 사이 뜬 알림(Alert)을 끄지 않는다.
 *   2) 공통 콤보 파라미터가 서버로 나갈 때 자동으로 홑따옴표 인용된다(idempotent).
 * 이 페이지(/ui)는 앱 셸(MDIContainer) 밖이라 ToastMessage/Alert 를 Templates 가 직접 마운트한다.
 */
const RegressionTestSection = () => {
  const { setToast, setAlert } = useMessageStore();
  const [division, setDivision] = useState('81_UC');

  const reproToastKeepsAlert = () => {
    // 로딩 토스트 표시 → 4초 자동닫힘 타이머 시작.
    setToast({ message: '로딩중... (4초 뒤 자동으로 닫힘)' });
    // 서버가 2.5초 뒤 에러를 리턴하는 상황을 흉내낸다 → 에러 알림 표시.
    setTimeout(() => {
      void setAlert({
        type: 'alert',
        content: '에러 메시지 — 확인을 누를 때까지 유지되어야 한다 (토스트 4초 타이머와 무관).',
      });
    }, 2500);
  };

  const comboPayload = JSON.stringify(
    quoteComboParams({ comboId: 'TeambyDivision', divisionId: division }),
    null,
    2
  );

  return (
    <section aria-labelledby='regression-test'>
      <h2 id='regression-test'>회귀 테스트 (최근 수정 검증)</h2>

      <h3>1) 토스트 자동닫힘이 알림을 끄지 않는다</h3>
      <p style={{ color: '#666', fontSize: 13, whiteSpace: 'pre-line' }}>
        {'버튼 → 로딩 토스트(4초 자동닫힘) + 2.5초 뒤 에러 알림.\n' +
          '수정 후: 4초에 토스트만 닫히고 알림은 확인 누를 때까지 유지.\n' +
          '수정 전: 알림이 뜬 지 약 1초 만에 토스트와 함께 사라졌음.'}
      </p>
      <button onClick={reproToastKeepsAlert}>로딩 토스트 + 2.5초 뒤 에러 알림</button>

      <h3 style={{ marginTop: 20 }}>2) 공통 콤보 파라미터 자동 인용</h3>
      <p style={{ color: '#666', fontSize: 13 }}>
        division 값을 바꾸면 서버(POST admin/combo)로 실제 전송되는 payload 를 보여준다. raw 문자열은
        홑따옴표가 자동으로 붙고, 이미 인용된 값은 그대로 둔다(idempotent).
      </p>
      <input
        value={division}
        onChange={e => setDivision(e.target.value)}
        placeholder="예: 81_UC / 40 / '81_UC'"
        style={{ padding: 4, width: 260 }}
      />
      <pre style={{ background: '#f5f5f5', padding: 8, marginTop: 8, fontSize: 13 }}>
        {comboPayload}
      </pre>
    </section>
  );
};

/**
 * @param embedded MDI 탭으로 렌더될 때 true — 전역 ToastMessage/Alert(MDIContainer)를 재사용하므로
 *   자체 마운트를 생략한다. 단독 /ui 라우트(셸 밖)에서는 false 라 직접 마운트해 토스트/알림이 동작한다.
 */
export const Templates = ({ embedded = false }: { embedded?: boolean } = {}) => {
  const { t } = useTranslation();

  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);

  const [file, setFile] = useState<File>();
  const [drpodown1, setDrpodown1] = useState<string>();
  const [drpodown2, setDrpodown2] = useState<string>();

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

      <RegressionTestSection />
      <Divider />

      <section aria-labelledby='file-upload'>
        <h2>파일업로드</h2>
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
      <section aria-labelledby='i18n'>
        <h2>다국어 처리</h2>
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
      <div style={{ display: 'flex', gap: '12px' }}>
        <div style={{ width: '400px' }}>
          <PivotPanel itemsSource={pivotEngine} />
        </div>

        <div style={{ flex: 1, height: '600px' }}>
          <PivotGrid itemsSource={pivotEngine} />
        </div>
      </div>
      <Divider />
      <MainTitle
        title='Message'
        menuId='SYS0001'
        openSearchArea={true}
        toggleOpenSearchArea={() => {}}
      />
      <h2>SubTitle Default</h2>
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
        <DataGrid
          itemsSource={templateItemsSource}
          staticColumns={templateStaticColumns as RawFlexGridColumnConfig[]}
        />
      </section>
      <Divider />
      <section aria-labelledby='wijmo-gantt-chart'>
        <h2 id='wijmo-gantt-chart'>간트 차트 렌더링 예시</h2>
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
        <span>
          화면 중간의 세로 메뉴 패턴. 좌측 트리에서 노드를 선택하면 우측 상세 영역이 바뀝니다.
        </span>
        <TreeViewExample />
      </section>
      <Divider />
      <ImageUploadExample />

      {/*
        MDI 탭(embedded)에선 MDIContainer 가 전역 토스트/알림을 이미 렌더하므로 생략한다(중복 방지).
        단독 /ui 라우트는 셸 밖이라 전역 토스트/알림이 없어 여기서 직접 마운트한다.
      */}
      {!embedded && (
        <>
          <ToastMessage />
          <Alert />
        </>
      )}
    </div>
  );
};
