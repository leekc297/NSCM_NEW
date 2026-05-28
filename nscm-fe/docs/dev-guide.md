# Conventions

## File Names

| Type               | Format     | Example                            |
| ------------------ | ---------- | ---------------------------------- |
| Components         | PascalCase | Button.tsx, ForecastPrice.tsx      |
| Utils/Hooks/Stores | camelCase  | useDebounce.ts, useSessionStore.ts |
| Folders            | kebab-case | forecast-price/, form-field/       |
| Types              | kebab-case | forecast-price.types.ts            |
| Constants          | kebab-case | app-config.ts                      |

## Directory

```bash
src
└── pages
    ├── {page-name}
    │   ├── components -- 메인컴포넌트를 제외한 모든 컴포넌트는 폴더 내부에 보관
    │   │   ├── PageNameForm.tsx -- 검색영역 컴포넌트
    │   │   ├── PageNameFirstSheet.tsx -- 시트1 컴포넌트
    │   │   └── PageNameSecondSheet.tsx -- 시트2 컴포넌트
    │   ├── page-name.constants.ts -- constants
    │   ├── page-name.types.ts -- types
    │   ├── usePageName.ts -- store
    │   └── PageName.tsx -- 메인 Component
    └── index.ts -- export PageName.tsx
```

## Files

```PageName.tsx
//imports...


// 메인컴포넌트에서는 데이터 관리와 컴포넌트 조합 위주로 작성
export const PageName = ({
  tabId, // 탭 을 구분하기 위한 해시값
  title, // 탭 이름의 메세지코드
}: PageProps<PROC_NAME>) => {

  // 리액트쿼리 사용하여 api 호출
  const { data, refetch } = useTabProcQuery<PROC_NAME>({
    menuId: PROC_NAME,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  return (
    <>
      <PageNameForm/>
      <PageNameFirstSheet/>
      <PageNameSecondSheet/>
    </>
  )
}


```
