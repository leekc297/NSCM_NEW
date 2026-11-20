/**
 * 디자인 시스템 TitleArea(SubTitleArea) 의 `language` 값 — 건수 표기 「총 N건」 / 「Total N rows」 를 고른다.
 *
 * 디자인 시스템은 `language` 기본값이 'ko' 이고 'ko' 가 아니면 모두 영어(Total / rows)로 그린다.
 *   중국어 문구는 디자인 시스템에 없다('zhC' 를 줘도 Total / rows). 그래서 화면 언어가 KO 면 'ko',
 *   그 외(EN · CN)는 'en' 으로 넘긴다. 종전에는 아무 값도 넘기지 않아 EN · CN 화면에도 「총 N건」 이 떴다.
 *
 * 화면 언어는 i18n 현재 언어(세션 langCd 와 동기화 — Providers)를 따른다. useTranslation 구독이라
 * 언어를 바꾸면 다시 그려진다.
 */
export const useTitleAreaLanguage = (): 'ko' | 'en' => {
  const { i18n } = useTranslation();
  return (i18n.language ?? 'KO').toUpperCase() === 'KO' ? 'ko' : 'en';
};

/**
 * TitleArea `totalCases` 에 넘길 건수 — 천 단위 쉼표(12345 → '12,345').
 *
 * 디자인 시스템은 totalCases 를 서식 없이 그대로 그린다(타입은 number 지만 렌더는 children 출력뿐).
 *   그래서 쉼표를 붙인 문자열을 넘긴다 — 타입만 number 로 맞춘다. 언어와 무관하게 쉼표 구분(en-US)이다.
 * 0 · undefined 는 손대지 않는다 — 디자인 시스템이 `totalCases && …` 로 표시 여부를 가르므로 종전 표시를 그대로 둔다.
 */
export const formatTotalCases = (value: number | undefined): number | undefined =>
  value ? (value.toLocaleString('en-US') as unknown as number) : value;
