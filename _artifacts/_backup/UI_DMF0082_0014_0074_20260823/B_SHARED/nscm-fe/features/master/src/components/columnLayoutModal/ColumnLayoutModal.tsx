// ⭐ [2026-08-20 정본 단일화 — 사용자 지시] Grid Column Setting(컬럼 개인화) 모달 정본은
//   `packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx` **유일**이다.
//   본 파일은 기존 소비처(mkt-fcst / forecast-price / sales-reports / sales-future-price /
//   contribute-view / sales-monitoring 등) 호환용 **재수출 스텁** — 여기에 구현을 되살리지 말 것.
//   신규 화면은 `@shared/components` 에서 직접 import 한다. 룰 = hook #132
//   (`Doc/_rules_v2/hooks/ui-layout-shell-modal-feedback-standard.md` §Column 모달 정본).
//   (구 사본에만 있던 2026-08-13 HIDDEN_FROM_LIST 순번 fix 는 정본에 이식 완료 — 2026-08-20)
export { ColumnLayoutModal } from '@shared/components';
