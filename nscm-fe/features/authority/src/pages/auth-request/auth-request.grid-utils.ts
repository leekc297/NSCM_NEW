// No 컬럼/헤더 유틸 — 팝업(*Modal.tsx) 그리드 공통 적용(2026-09-03)을 위해
//   packages/foundation/src/utils/gridRowNo.ts 로 승격. 기존 호출부(AuthorityGrid/DivisionGrid/
//   MyAuthorityListGrid) 무변경 유지를 위해 재-export 만 남긴다.
export { ROW_NO_BINDING, buildNoColumn, withRowNo, attachRowNoHeader } from '@foundation/utils';
