// ====================================================================================
// CascadeFields — 단일 콤보 기반 cascade 조회조건 (2026-08-23 사용자 요구)
//
// "콤보 id 1개를 조회해서 각 code/name 으로 셋팅하고, 화면에는 4개 쓸지 3개 쓸지 지정"
//
// Div - Team - End Customer - Sales Site 처럼 상위 선택이 하위 목록을 좁히는 조회조건을
// 한 벌로 그려 준다. 전 화면에 일괄 적용할 컴포넌트이므로, 아래 규약대로만 쓰면 화면마다
// 배선을 다시 짤 일이 없다.
//
// SearchFields 카탈로그(DivisionField / TeamField / EndCustomerField / SalesSiteField)와의 차이:
//   카탈로그 - 단계마다 콤보를 따로 조회하고 클라이언트에서 서로 필터링한다. 콤보마다 스키마가
//     달라 어느 조회조건이 어느 컬럼에 대응하는지를 화면이 cascade prop 으로 배선했고,
//     상위 컬럼이 공란인 행을 자를지 말지(strict)도 콤보마다 달라 화면이 판단했다.
//   이 컴포넌트 - 조인된 평면 콤보 1건만 조회한다. 한 SQL 결과라 모든 행에 모든 단계 컬럼이
//     차 있으므로 strict/관대 분기가 필요 없고, 배선도 levels 배열 순서가 전부다.
//
// ====================================================================================
// 1. 준비물 - 콤보 SQL
// ====================================================================================
// 단계별로 콤보를 따로 등록하지 않는다. 상위부터 하위까지 한 행에 다 들어간 조인된 평면
// 콤보 1건을 SCM_ADM_CMBO_SQL_M 에 등록하고 그 ID 를 comboId 로 넘긴다.
//
// 컬럼 이름 규약: 전 단계를 풀네임 컬럼으로 내려준다.
//   DIVISION_CODE / DIVISION_NAME, TEAM_CODE / TEAM_NAME,
//   END_CUSTOMER / END_CUSTOMER_NAME, SALES_SITE_CODE / SALES_SITE_NAME ...
//
// 마지막 단계만 CODE / NAME 으로 읽던 종전 규약은 없앴다. 몇 단으로 쓰든, 그 단계가 마지막이든
// 아니든 컬럼명은 카탈로그(CASCADE_LEVELS)에 적힌 이름 하나뿐이다. 같은 콤보를 3단으로 쓰는
// 화면과 4단으로 쓰는 화면이 컬럼을 다르게 읽을 일이 없어진다.
//
// 콤보 SQL 이 이 규약과 다른 이름을 쓰면 그 단계 levels 항목에 columns 를 직접 넘겨 덮는다.
// 목록이 통째로 비는 사고는 대부분 여기다 - 컬럼명이 규약과 어긋나면 첫 단계에서 전 행이
// 잘린다. debugLabel 을 넣으면 콘솔에 원본 컬럼 목록과 단계별 잔여 행 수가 찍히니 그것부터
// 확인한다.
//
// ====================================================================================
// 2. Props - CascadeFields 와 useCascadeFields 가 같은 입력을 받는다
// ====================================================================================
//   comboId     필수. 조인된 평면 콤보 1건의 등록 ID. 같은 comboId 를 쓰는 화면끼리는
//               react-query 캐시를 공유하므로 단계를 3개로 줄이든 4개로 늘리든 호출은 1회다.
//
//   levels      필수. 화면에 쓸 단계와 순서. 배열 순서가 곧 cascade 순서이며 렌더 위치와는
//               무관하다. 문자열 키만 주면 카탈로그 기본값을 쓰고, 객체로 주면 화면별로
//               덮는다. 항목 구조는 아래 3장.
//
//   value       필수. 조회조건 스토어 객체를 통째로 넘긴다. 각 단계는 자기 field(미지정 시
//               key)로 여기서 현재 선택값을 읽는다. 스토어 필드가 배열이든 문자열이든 된다.
//
//   onChange    필수. (next, changed) 두 인자를 받는다.
//                 next    - 바뀐 단계 값 + 그 아래 전 단계 초기화가 담긴 부분 객체.
//                           스토어가 partial merge 라 set(next) 한 줄이면 끝난다.
//                 changed - 방금 바뀐 단계의 key. 화면 고유 조회조건까지 초기화해야 할 때
//                           이걸로 분기한다 (예: division 이 바뀌면 Project/Item 도 clear).
//
//   gridSize    선택. 전 단계 공통 Grid size. 미지정 시 4. 단계별로 다르게 주려면 levels
//               항목의 gridSize 로 덮는다.
//
//   enabled     선택. 기본 true. false 면 콤보 조회 자체를 하지 않는다. 특정 Division 에서만
//               의미 있는 가지(MktFcstForm 의 Plant Site / Sender Code 는 81 계열 전용)를
//               통째로 끌 때 쓴다. 칸은 그리되 비활성만 하고 싶으면 이게 아니라 disabled 다.
//
//   debugLabel  선택. 임시 로컬 디버그. 넘기면 콘솔에 콤보 원본 컬럼 목록과 단계별 잔여 행
//               수가 찍힌다. 컬럼명이 규약과 맞는지 확인되면 호출부에서 그 줄을 지운다.
//
// ====================================================================================
// 3. levels 항목 (CascadeLevelSpec)
// ====================================================================================
//   key         필수. 단계 카탈로그(CASCADE_LEVELS)의 키. 라벨 / 다중선택 여부 / ALL 허용
//               여부 / 필수 여부 / 기본 컬럼명이 카탈로그 한 곳에 모여 있다.
//
//                 key          라벨(기본)     multiple  allOption  required  기본 컬럼
//                 division     Div            X         X          O         DIVISION_CODE/NAME
//                 team         Team           O         O          X         TEAM_CODE/NAME
//                 endCustomer  End Customer   O         O          X         END_CUSTOMER/END_CUSTOMER_NAME
//                 salesSite    Sales Site     O         O          X         SALES_SITE_CODE/NAME
//                 plantSite    Plant Site     O         O          X         PLANT_SITE_CODE/NAME
//                 bizType      Biz.Type       O         O          X         BIZ_TYPE_CODE/NAME
//                 senderCode   Sender Code    X         O          X         SENDER_CODE/SENDER_NAME
//
//               multiple 과 allOption 은 별개다 - 다중선택은 아니지만 전체(ALL)는 허용하는
//               단계가 있다(senderCode). allOption 은 clear 아이콘 노출 여부도 겸한다.
//               새 단계가 필요하면 CascadeFields.utils 의 카탈로그에 한 줄 추가한다.
//
//   field       선택. 이 단계 값이 담기는 스토어 필드명. 미지정 시 key 를 그대로 쓴다.
//               스토어 필드 타입에 맞춰 알아서 읽고 쓴다 - 배열 필드(deptIds: string[])면
//               배열로, 문자열 필드(deptId: string)면 문자열로 담기므로 호출부가 모양을
//               맞출 필요는 없다. 필드명 오타는 FieldOf<V> 로 컴파일 단계에서 잡힌다.
//
//   label       선택. i18n 기본 라벨 대신 화면 전용 문구를 쓸 때.
//   columns     선택. { code, name }. 콤보 SQL 이 표준 규약과 다른 컬럼명을 쓸 때만.
//   disabled    선택. 그 단계 콤보만 비활성. 콤보 조회는 그대로 나간다(enabled 와 구분).
//   gridSize    선택. 그 단계만 다른 폭으로.
//
// ====================================================================================
// 4. 값 규약
// ====================================================================================
// 전체선택은 값을 열거하지 않고 'ALL' sentinel 로 들어온다(배열 필드면 ['ALL']). 하위 단계
// 초기화 값도 배열이면 [], 문자열이면 'ALL' 이며, 조회 필터에서는 둘 다 "필터 없음"으로
// 똑같이 취급된다. 그래서 센티널 행(공백/'-' 등)도 조회 대상에서 빠지지 않는다.
//
// 자동 선택 보정은 없다 (2026-08-23 사용자 요청으로 제거). 스토어에 남아 있는 값이 콤보
// 옵션에 없어도 첫 옵션으로 덮어쓰지 않으며, 옵션이 1건뿐인 단계도 ALL 과 그 1건을 그대로
// 보여 주고 선택은 사용자에게 맡긴다.
//
// ====================================================================================
// 5. 두 가지 사용법
// ====================================================================================
// (1) 단계를 순서대로 쭉 붙여 그리면 되는 화면 - 컴포넌트를 그대로 쓴다.
//
//   <CascadeFields
//     comboId='SalesSiteCascade'
//     levels={[
//       { key: 'division', field: 'divisionId' },
//       { key: 'team', field: 'deptId' },
//       { key: 'endCustomer', field: 'endCustomer' },
//       { key: 'salesSite', field: 'salesSite' },
//     ]}
//     gridSize={3}
//     value={searchParams}
//     onChange={(next, changed) => {
//       // 단계 값과 하위 단계 초기화는 next 에 이미 들어 있다. 화면 고유 조회조건만 얹는다.
//       if (changed === 'division') return setSearchParams({ ...next, projectCode: '', owner: '' });
//       setSearchParams(next);
//     }}
//   />
//
// (2) 중간에 다른 조회조건이 끼어 배치가 찢어지는 화면 - 훅으로 받아 원하는 자리에 꽂는다.
//     (NnMasterMappingForm 처럼 Project / Model popup 이 End Customer 와 Sales Site 사이에
//      들어가는 경우)
//
//   const cascade = useCascadeFields({ comboId, levels, value: sc, onChange: ... });
//   ...
//   {cascade.field('division')}
//   {cascade.field('team')}
//   {cascade.field('endCustomer')}
//   <Grid size={3}>{/* Project popup */}</Grid>
//   <Grid size={3}>{/* Model / Nickname popup */}</Grid>
//   {cascade.field('salesSite')}
//
//   cascade.fields 는 전 단계 배열, cascade.field(key) 는 그중 하나다. levels 에 없는 key 를
//   부르면 아무것도 그리지 않는다. 렌더 위치를 어떻게 흩든 cascade 계산은 levels 순서를 따른다.
//
// ====================================================================================
// 6. 한 화면에서 여러 벌 쓰기
// ====================================================================================
// 가지가 갈리는 화면(MktFcstForm - Sales Site / Plant Site / Sender Code / Biz Type)은 훅을
// 여러 벌 쓴다. 상위 단계를 같은 field(divisionId, deptIds 등)로 맞춰 두면 한 값을 공유하면서
// 각자 자기 콤보를 좁힌다. 상위 단계는 필터로만 쓰고 렌더는 마지막 단계만 하면 된다 -
// field(key) 로 필요한 것만 꺼내면 나머지 단계는 그려지지 않는다.
// ====================================================================================

import type { CascadeFieldsProps } from './CascadeFields.utils';
import { useCascadeFields } from './useCascadeFields';

// 단계 카탈로그와 helper 는 CascadeFields.utils 에 있다 - 컴포넌트 파일이 상수/함수까지 export 하면
// react-refresh/only-export-components 가 걸린다. 호출부가 쓸 만한 타입만 여기서 다시 내보낸다.
export type {
  CascadeFieldsProps,
  CascadeLevelKey,
  CascadeLevelSpec,
  UseCascadeFieldsOptions,
} from './CascadeFields.utils';

// ====================================================================================
// CascadeFields
// ====================================================================================
/**
 * 단계를 levels 순서대로 붙여서 렌더하는 기본형.
 * 중간에 다른 조회조건이 끼는 화면은 이 컴포넌트 대신 useCascadeFields 를 쓴다.
 * prop 설명과 콤보 SQL 규약은 이 파일 헤더 참조.
 */
export const CascadeFields = <V extends object>(props: CascadeFieldsProps<V>) => {
  const { fields } = useCascadeFields(props);
  return <>{fields}</>;
};
