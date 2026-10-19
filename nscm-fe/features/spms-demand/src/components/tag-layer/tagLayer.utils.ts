// ⭐ TAG pill 색 컬럼 관례 — `X_NAME` 표시 컬럼의 색은 `X_COLOR_TYPE` 커서 컬럼이 준다
//   (SDM1010 승계 관례. 커서 실명이 관례와 다른 컬럼은 화면별 TAG_SOURCE 맵이 우선한다)
//   JSX 없는 파일로 분리 — react-refresh/only-export-components (컴포넌트 파일은 컴포넌트만 export)
export const colorTypeColumnOf = (binding: string): string =>
  `${binding.replace(/_NAME$/, '')}_COLOR_TYPE`;
