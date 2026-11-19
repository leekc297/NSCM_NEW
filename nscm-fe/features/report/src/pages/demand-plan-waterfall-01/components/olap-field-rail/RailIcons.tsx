import type { SVGProps } from 'react';

/**
 * 레일 전용 아이콘 — 핸드오프가 지정한 Lucide 아이콘(stroke-width 1.5)을 동일 형상의 inline SVG 로.
 *   (`lucide-react` 는 프로젝트 의존성에 없고, @shared/lges-icons 에 대응 아이콘이 없어 로컬 정의.)
 *   크기는 CSS 에서 제어(width/height 1em 기본).
 */
const base: SVGProps<SVGSVGElement> = {
  width: '1em',
  height: '1em',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  strokeWidth: 1.5,
  strokeLinecap: 'round',
  strokeLinejoin: 'round',
  'aria-hidden': true,
};

export const FilterIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='M22 3H2l8 9.46V19l4 2v-8.54L22 3z' />
  </svg>
);
export const Columns3Icon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <rect width='18' height='18' x='3' y='3' rx='0' />
    <path d='M9 3v18M15 3v18' />
  </svg>
);
export const Rows3Icon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <rect width='18' height='18' x='3' y='3' rx='0' />
    <path d='M21 9H3M21 15H3' />
  </svg>
);
export const SigmaIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='M18 7V4H6l6 8-6 8h12v-3' />
  </svg>
);
export const SearchIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <circle cx='11' cy='11' r='8' />
    <path d='m21 21-4.3-4.3' />
  </svg>
);
export const ChevronDownIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='m6 9 6 6 6-6' />
  </svg>
);
export const ChevronRightIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='m9 18 6-6-6-6' />
  </svg>
);
export const ChevronLeftIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='m15 18-6-6 6-6' />
  </svg>
);
export const XIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d='M18 6 6 18M6 6l12 12' />
  </svg>
);
export const GripVerticalIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p} fill='currentColor' stroke='none'>
    <circle cx='9' cy='5' r='1.3' />
    <circle cx='9' cy='12' r='1.3' />
    <circle cx='9' cy='19' r='1.3' />
    <circle cx='15' cy='5' r='1.3' />
    <circle cx='15' cy='12' r='1.3' />
    <circle cx='15' cy='19' r='1.3' />
  </svg>
);
export const CheckIcon = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p} strokeWidth={3}>
    <path d='M20 6 9 17l-5-5' />
  </svg>
);
