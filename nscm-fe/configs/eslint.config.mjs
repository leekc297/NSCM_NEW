import js from '@eslint/js';
import reactPlugin from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import typescript from 'typescript-eslint';
import importPlugin from 'eslint-plugin-import';
import reactRefresh from 'eslint-plugin-react-refresh';
import unusedImports from 'eslint-plugin-unused-imports';
import queryPlugin from '@tanstack/eslint-plugin-query';

const baseConfig = [
  {
    ignores: [
      'node_modules',
      'dist',
      'build',
      'scripts/**',
      '.turbo',
      'configs',
      'configs/**',
      '**/configs/**',
      '**/*.config.js',
      '**/*.config.mjs',
      '**/*.config.ts',
      '__mocks__/**',
    ],
  },
  js.configs.recommended,
  ...typescript.configs.recommendedTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
    },
    plugins: {
      react: reactPlugin,
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
      import: importPlugin,
      'unused-imports': unusedImports,
      'tanstack-query': queryPlugin,
    },
    settings: {
      react: {
        version: 'detect',
      },
    },
    rules: {
      //JS
      'no-multiple-empty-lines': ['error', { max: 1 }], // 빈줄 2줄 이상 금지
      'no-console': ['warn', { allow: ['warn', 'error'] }], // 개발 console.log 금지
      eqeqeq: ['error', 'always', { null: 'ignore' }], // 자동 수정 + null 허용
      quotes: ['error', 'single'],
      'jsx-quotes': ['error', 'prefer-single'], // JSX에서도 싱글 쿼테션 사용
      semi: ['error', 'always'],
      'func-style': ['error', 'expression'], // 일반 함수를 화살표 함수로 강제

      //Import
      'unused-imports/no-unused-vars': [
        'warn',
        {
          vars: 'all',
          varsIgnorePattern: '^_',
          args: 'after-used',
          argsIgnorePattern: '^_',
        },
      ],
      'unused-imports/no-unused-imports': 'error', // 미사용 import 자동

      'import/no-relative-parent-imports': 'warn', // 상위 상대 import 제한 (../utils 금지)
      'import/newline-after-import': 'error', // import 블록 끝 빈줄 필수
      'import/no-unresolved': 'off', // path alias 오류 무시 (@utils/* 등)

      //React
      'react/prop-types': 'off', // PropTypes 검증 비활성화 (TypeScript interface 사용)
      'react/react-in-jsx-scope': 'off',
      'react/jsx-key': 'error', // map에서 key 누락 방지
      'react/no-array-index-key': 'warn', // 배열 인덱스를 key로 쓰지 않기
      'react/jsx-no-target-blank': 'error', // target="_blank" 보안 이슈
      'react/self-closing-comp': 'warn', // <div></div> → <div />
      'react/jsx-curly-brace-presence': ['warn', { props: 'never', children: 'never' }], // 불필요한 중괄호 제거
      'react/function-component-definition': [
        // 리액트 컴포넌트 선언 방식을 화살표 함수로 통일
        // 'function-declaration' 대신 'arrow-function' 사용하도록 설정
        'error',
        {
          namedComponents: 'arrow-function',
          unnamedComponents: 'arrow-function',
        },
      ],

      //React hooks
      ...reactHooks.configs.recommended.rules,
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'warn',
      'react-refresh/only-export-components': ['warn', { allowConstantExport: true }], // Vite HMR 허용

      // --- [3] TanStack Query (React Query) ---
      'tanstack-query/exhaustive-deps': 'error', // queryKey와 queryFn 내부 변수 일치 여부 체크
      'tanstack-query/no-rest-destructuring': 'warn', // 쿼리 결과 구조 분해 시 성능 저하 방지

      //Typescript
      '@typescript-eslint/no-unused-vars': 'off', // unused-imports에 위임.
      '@typescript-eslint/unbound-method': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'warn',
      '@typescript-eslint/no-use-before-define': 'error', // 선언 전 사용 금지 (호이스팅 문제 방지)
      '@typescript-eslint/consistent-type-imports': 'error', // type import 명시 강제 (import type {} 사용)
      '@typescript-eslint/no-explicit-any': 'error', // any 사용 경고
      '@typescript-eslint/no-floating-promises': 'warn', // await 없는 Promise 방지
      '@typescript-eslint/no-non-null-assertion': 'warn', // ! (non-null assertion) 사용 경고
      '@typescript-eslint/no-empty-function': 'warn', // 빈 함수 사용 경고 (주석으로 의도 명시 필요)
      // '@typescript-eslint/explicit-function-return-type': 'off',
      //   'warn',
      //   {
      //     // 1. 함수 표현식(화살표 함수 등)에서 타입 추론이 가능하면 생략 허용
      //     allowExpressions: true,
      //     // 2. 다른 변수에 할당될 때 이미 타입이 정의되어 있다면 생략 허용 (예: const 핸들러: MouseEventHandler = (e) => ...)
      //     allowTypedFunctionExpressions: true,
      //     // 3. 고차 함수(함수를 리턴하는 함수) 내부의 리턴 타입 생략 허용
      //     allowHigherOrderFunctions: true,
      //     // 4. 직접적으로 리턴하는 값이 명확한 경우 생략 허용
      //     allowDirectConstAssertionInArrowFunctions: true,
      //     // 5. 리액트 컴포넌트나 훅에서 자주 쓰이는 패턴 허용
      //     allowFunctionsWithoutTypeParameters: false,
      //     // 6. 리턴 타입이 추론 가능한 '화살표 함수'에서 명시를 생략할 수 있게 해줍니다.
      //     allowTypedFunctionExpressions: true,
      //   },
      // ],
      // 외부로 노출되는(exported) 함수만 검사하는 이 규칙을 사용하세요.
      '@typescript-eslint/explicit-module-boundary-types': [
        'off',
        // {
        //   allowArgumentsExplicitlyTypedAsAny: false,
        //   allowDirectConstAssertionInArrowFunctions: true,
        //   allowHigherOrderFunctions: true,
        //   allowTypedFunctionExpressions: true,
        // },
      ],
      '@typescript-eslint/no-misused-promises': [
        // Axios/Zustand 등 비동기 로직 안정성
        'error',
        { checksVoidReturn: false }, // useEffect 등에서 비동기 함수 사용 시 발생하는 에러 완화
      ],
      '@typescript-eslint/no-restricted-types': [
        'error',
        {
          types: {
            'React.FC': {
              message:
                'React.FC를 사용하는 대신 Props 타입을 직접 명시하세요. (예: ({ name }: Props) => ...)',
              fixWith: '',
            },
            FC: {
              message:
                'FC를 사용하는 대신 Props 타입을 직접 명시하세요. (예: ({ name }: Props) => ...)',
              fixWith: '',
            },
          },
        },
      ],

      '@typescript-eslint/no-namespace': 'warn', // namespace 완화

      // Import 순서
      'import/order': [
        'error',
        {
          groups: [
            'builtin',
            'external',
            'internal',
            'parent',
            'sibling',
            'index',
            // 'type',
            'unknown',
            'object',
          ],
          pathGroups: [
            { pattern: '@mock/**', group: 'builtin', position: 'before' }, // mock 최우선
            { pattern: '@admin', group: 'internal', position: 'before' }, // features
            { pattern: '@admin/**', group: 'internal', position: 'before' }, // features
            { pattern: '@master', group: 'internal', position: 'before' }, // features
            { pattern: '@master/**', group: 'internal', position: 'before' }, // features
            { pattern: '@demand', group: 'internal', position: 'before' }, // features
            { pattern: '@demand/**', group: 'internal', position: 'before' }, // features
            { pattern: '@supply', group: 'internal', position: 'before' }, // features
            { pattern: '@supply/**', group: 'internal', position: 'before' }, // features
            { pattern: '@factory', group: 'internal', position: 'before' }, // features
            { pattern: '@factory/**', group: 'internal', position: 'before' }, // features
            { pattern: '@shipping', group: 'internal', position: 'before' }, // features
            { pattern: '@shipping/**', group: 'internal', position: 'before' }, // features
            { pattern: '@foundation', group: 'internal', position: 'before' }, // foundation
            { pattern: '@foundation/**', group: 'internal', position: 'before' }, // foundation
            { pattern: '@shared', group: 'internal', position: 'before' }, // shared
            { pattern: '@shared/**', group: 'internal', position: 'before' }, // shared
            {
              pattern: '**/*.+(css|scss|module.scss|module.css)$',
              group: 'object',
              position: 'after',
            }, // CSS 최후순위
          ],
          pathGroupsExcludedImportTypes: ['type'], // type import 분리
          'newlines-between': 'always', // 그룹 간 빈줄
          alphabetize: { order: 'asc', caseInsensitive: true }, // 알파벳 정렬
          distinctGroup: false, // 그룹 강제 분리 해제
        },
      ],
    },
  },
];

export default baseConfig;
