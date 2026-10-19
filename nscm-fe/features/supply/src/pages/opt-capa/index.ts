// viewRegistry 가 `features/*/src/pages/*/index.ts` 를 glob 으로 수집한다.
//   라우트 코드 수정은 없다 — 폴더 추가 + DB `SCM_ADM_MNU_M.ROUTE_PATH`(이미 등록됨,
//   `supply/opt-plan/opt-capa`) 로 해석된다(convert-core §2.2).
export { OptCapa } from './OptCapa';
