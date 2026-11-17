// viewRegistry 가 `features/*/src/pages/*/index.ts` glob 으로 수집한다.
//   라우트 코드 수정은 없다 — 폴더 추가 + DB `SCM_ADM_MNU_M.ROUTE_PATH='supply/capa-line-assign'`
//   등록(05_register.sql)으로 해석된다(convert-core §2.2).
export { CapaLineAssign } from './CapaLineAssign';
