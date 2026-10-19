// supply 공통 팝업 스켈레톤 데모(SupplyPopupGallery)를 외부(apps/web)로 노출하는 page 엔트리.
//   feature 는 pages/* 만 외부 공개하는 규약이라, components/ 의 갤러리를 여기서 재노출한다.
//   apps/web Templates(/ui)에서 `@supply/popup-gallery` 로 가져와 렌더한다.
export { SupplyPopupGallery } from '../../components/SupplyPopupGallery';
