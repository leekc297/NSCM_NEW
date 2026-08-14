import { createJiti } from 'jiti';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const jiti = createJiti(import.meta.url);

// Script moved to repo root/scripts, so resolve foundation source by absolute path.
const foundationAxiosPath = path.resolve(__dirname, '../packages/foundation/src/apis/axios.ts');
const { apiClient } = jiti(foundationAxiosPath);

async function run() {
  console.log('🚀 다국어 동기화 스크립트 시작...');

  // API 후보: env 지정 → 로컬 BE → 구주소. 전부 실패 시 기존 locales 를 지우지 않고 중단한다.
  //   (2026-08-13 실사고 — 구주소 도달 불가 상태에서 목데이터가 실 locales 를 덮어써
  //    전 화면 LBL 이 '_' fallback 으로 표시)
  const apiCandidates = [
    process.env.NSCM_I18N_API,
    'http://127.0.0.1:8080/admin/message',
    'http://10.34.220.80:8080/admin/message',
  ].filter(Boolean);

  let messages;
  for (const url of apiCandidates) {
    try {
      const response = await apiClient.get(url);
      if (Array.isArray(response.data?.result) && response.data.result.length > 0) {
        messages = response.data.result;
        console.log(`✅ 메시지 원천: ${url} (${messages.length}건)`);
        break;
      }
    } catch {
      console.log(`⚠ API 실패: ${url}`);
    }
  }
  if (!messages) {
    const existing = path.resolve(__dirname, '../public/locales/KO.json');
    if (fs.existsSync(existing)) {
      console.error('❌ 모든 API 실패 — 기존 locales 보존을 위해 중단합니다. (목데이터 덮어쓰기 금지)');
      process.exit(1);
    }
    console.log('api 요청 실패. 목데이터로 동작합니다.');
    messages = mockMessage;
  }
  {
    const koMap = new Map();
    const keyList = []; // 타입 생성을 위한 키 목록
    messages
      .filter(m => m.langCd.toLocaleUpperCase() === 'KO')
      .forEach(m => {
        koMap.set(m.messageId, m.messageNm);
        keyList.push(`  | '${m.messageId}'`);
      });

    const locales = {};

    // 2. 데이터 가공
    messages.forEach(({ langCd, messageId, messageNm, message }) => {
      if (!locales[langCd]) locales[langCd] = {};

      const combinedKey = `${messageId}`;

      locales[langCd][combinedKey] = messageNm ?? message;
    });

    // 3. 파일 저장 (repoRoot/public/locales)
    // 재생성 전 기존 디렉터리를 정리한다. (rm -rf 대신 크로스플랫폼 fs.rmSync 사용)
    const targetDir = path.resolve(__dirname, '../public/locales');
    fs.rmSync(targetDir, { recursive: true, force: true });
    fs.mkdirSync(targetDir, { recursive: true });

    Object.entries(locales).forEach(([lang, data]) => {
      console.log(lang);
      const filePath = path.join(targetDir, `${lang}.json`);
      fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf-8');
    });

    // 2. generated-keys.ts 파일 생성 (타입 자동화)
    // const typeDefinitionDir = path.resolve(__dirname, '../src/models/common/generated-keys.ts');
    const typeDefinitionDir = path.resolve(__dirname, '../configs/types/generated-keys.d.ts');

    const typeContent = [
      '// 이 파일은 sync-locales 스크립트에 의해 자동 생성되었습니다. 직접 수정하지 마세요.',
      'declare type AppI18nKey = ',
      ...keyList,
      '| (string & {}); // 자동완성을 지원하면서도 유연성 유지',
    ].join('\n');

    fs.writeFileSync(typeDefinitionDir, typeContent, 'utf-8');
  }
  return { success: true };
}

const mockMessage = [
  {
    messageId: 'lbl.label',
    message: '라벨',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.msg',
    message: '메시지',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.code',
    message: '코드',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.name',
    message: '명',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.screen',
    message: '화면',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.popup',
    message: '팝업',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.save',
    message: '저장',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.select',
    message: '조회',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.delete',
    message: '삭제',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.row.add',
    message: '행추가',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.cancel',
    message: '취소',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.save',
    message: 'Save',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.comm.select',
    message: 'Search',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.comm.delete',
    message: 'Delete',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.comm.row.add',
    message: 'Add Row',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.comm.cancel',
    message: 'Cancel',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.comm.row.del',
    message: '행삭제',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.comm.row.del',
    message: 'Del Row',
    langCd: 'EN',
  },
  {
    messageId: 'lbl.user.id',
    message: '사용자아이디',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.user.nm',
    message: '사용자명',
    langCd: 'KO',
  },
  {
    messageId: 'lbl.menu',
    message: '메뉴',
    langCd: 'KO',
  },
];

await run();
