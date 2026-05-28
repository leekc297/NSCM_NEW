# React Monorepo with Turborepo

> 3-Layer Architecture 기반 Turborepo 모노레포
> YAGNI (You Aren’t Gonna Need It)

## 기술 스택

- **Runtime**: Node.js >= 20.14.0 (LTS)
- **Package Manager**: pnpm >= 10.0.0 (LTS)
- **Monorepo Tool**: Turborepo 2.1.x (LTS)
- **Framework**: React 19.2.0
- **Language**: TypeScript 5.7.x
- **Build Tool**: Vite 6.x
- **Linting**: ESLint 9.x (Flat Config)
- **Styling**: SCSS Modules
- **State Management**: Zustand 5.x
- **HTTP Client**: Axios 1.7.x

## Extentions (VS Code 기준)

- **ESLint**
- **Prettier**
- **SonarQube**

## 시작하기

```bash
npm install -g pnpm

# 의존성 설치
pnpm install

# 개발 서버 실행
pnpm dev

# 빌드
pnpm build

# 린트
pnpm lint

# 타입 체크
pnpm type-check
```

## 프로젝트 구조

```bash
의존구조: "foundation > shared > features.{demand,admin,...} > apps/web" 단방향 의존만 가능

root/
├── apps/web                    # 메인 애플리케이션
│       ├── src/
│       ├── index.html          # 실제로 서버에 올라가는 유일한 앱.
│       ├── .env
│       ├── vite.config.ts
│       ├── package.json
│       ├── eslint.config.mjs
│       └── tsconfig.json
├── features/                   # 도메인별 기능
│   ├── demand/
│   │   ├── src/
│   │   ├── package.json
│   │   ├── eslint.config.mjs
│   │   └── tsconfig.json
│   ├── supply/
│   ├── factory/
│   ├── shipping/
│   └── admin/
│       ├── package.json
│       ├── eslint.config.mjs
│       └── tsconfig.json
├── packages/
│   ├── foundation/             # Layer 1: 기반 계층
│   │   │   └── src/
│   │   │       ├── apis/
│   │   │       ├── constants/
│   │   │       ├── utils/
│   │   │       ├── models/
│   │   │       └── styls/
│   │   ├── package.json
│   │   ├── eslint.config.mjs
│   │   └── tsconfig.json
│   └── shared/                 # Layer 2: 공유 로직
│       │   └── src/
│       │       ├── components/
│       │       ├── hooks/
│       │       └── stores/
│       ├── package.json
│       ├── eslint.config.mjs
│       └── tsconfig.json
├── configs/                    # 공유 설정
│   ├── types/
│   ├── eslint.config.mjs
│   └── tsconfig.base.json
├── turbo.json
├── package.json               # 루트 deps
└── pnpm-workspace.yaml
```

## 3-Layer 아키텍처

### 🔵 Layer 1: Foundation (기반 계층)

- 순수 함수, 타입 정의, HTTP 프록시

### 🟢 Layer 2: Shared (공유 로직)

- 재사용 훅, 전역 상태, UI 컴포넌트

### 🟡 Layer 3: Application (애플리케이션)

- 비즈니스 로직, 페이지, 라우팅

## 의존성 규칙

✅ Layer 3 → Layer 2 → Layer 1 (하향 의존)
❌ 상향 의존 금지
❌ Feature 간 의존 금지

## 주요 명령어

| 명령어            | 설명               |
| ----------------- | ------------------ |
| `pnpm dev`        | 개발 서버 실행     |
| `pnpm build`      | 프로덕션 빌드      |
| `pnpm preview`    | 프로덕션 실행      |
| `pnpm lint`       | ESLint 실행        |
| `pnpm lint:fix`   | ESLint 실행 + 수정 |
| `pnpm type-check` | TypeScript 체크    |
| `pnpm clean`      | 캐시 초기화        |
| `pnpm clean:all`  | 라이브러리 초기화  |

---

자세한 정보는 `docs/` 디렉토리를 참고하세요.
