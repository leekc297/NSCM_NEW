/assign_reviewer @{리뷰어}

## Figma

-

## Description

-
-

<details><summary>Show All Commits</summary>
%{all_commits}
</details>

## CheckList

### pulisher

- [ ] Design Tokens (디자인 토큰 활용)  
       하드코딩된 Hex 값 대신 프로젝트에 정의된 디자인 토큰(CSS/SCSS Variables)을 사용했는가?  
       (Are defined Design Tokens used instead of hard-coded Hex values?)

- [ ] Responsive Design (해상도 대응)  
       정의된 표준 해상도(1920×963) 및 최저 해상도(1366×768) 환경에서 레이아웃이 깨짐 없이 대응되는가?  
       (Is the layout compatible with the defined standard resolution [1920×963] and the minimum resolution [1366×768]?)

- [ ] Style Architecture (스타일 구조)  
       특수 사례를 제외한 모든 스타일이 CSS Modules(_.module.scss)로 격리 및 관리되고 있는가?  
       (Are all styles managed using CSS Modules [.module.scss], except for specific exceptions?)_

- [ ] Web Accessibility (웹 접근성)  
       시맨틱 태그(Semantic Tags)를 적절히 사용했으며, 필요한 경우 aria-label 등 보조 속성을 추가했는가?  
       (Are appropriate semantic tags used, and are attributes like aria-label added where necessary for accessibility?)

### 리뷰어 (Reviewer)

- [ ] 불필요한 라이브러리 또는 기능 수정은 없는가?
- [ ] MR의 목적(스타일 수정)을 벗어난 수정사항은 없는가?

## ScreenShot (Optional)

/assign me
/target_branch dev
/cc @dong.lee2
/draft
