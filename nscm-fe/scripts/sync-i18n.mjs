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

  let messages;
  try {
    const response = await apiClient.get('http://10.34.220.80:8080/admin/message');
    messages = response.data.result;
  } catch {
    console.log('api 요청 실패. 목데이터로 동작합니다.');
    messages = mockMessage;
  } finally {
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
    const targetDir = path.resolve(__dirname, '../public/locales');
    if (!fs.existsSync(targetDir)) fs.mkdirSync(targetDir, { recursive: true });

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

await run();

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
