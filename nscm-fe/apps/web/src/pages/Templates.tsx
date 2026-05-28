import { templateItemsSource, templateStaticColumns } from '@mock/data/template';

import { useState } from 'react';

import { apiClient } from '@foundation/apis';
import { i18n } from '@foundation/i18n';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import {
  DataGrid,
  CustomDropdown,
  TabWrapper,
  TabItem,
  MainTitle,
  SearchArea,
} from '@shared/components';
import type { DropdownOption } from '@shared/lges';
import { Divider, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { useMDIStore } from '../mdi/useMDIStore';

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

export const Templates = () => {
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

  return (
    <div style={{ padding: '20px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
      <h1>Templates</h1>
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
    </div>
  );
};
