import fs from 'node:fs';

const ICONS_DIR = 'packages/foundation/src/assets/icon'; // 아이콘 경로
const OUTPUT_FILE = 'packages/foundation/src/assets/icon/index.ts'; // 내보낼 파일

// 파일명 보정 (예: 'home-menu.svg' -> 'IconHomeMenu')
const toPascalCase = str => {
  return str
    .replace('.svg', '')
    .split(/[-_ ]+/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join('');
};

const generate = () => {
  const files = fs.readdirSync(ICONS_DIR).filter(file => file.endsWith('.svg'));

  const exports = files.map(file => {
    const componentName = toPascalCase(file);
    return `export { default as ${componentName} } from './${file}?react';`;
  });

  const content = [
    '// 이 파일은 스크립트에 의해 자동 생성되었습니다. 직접 수정하지 마세요.',
    ...exports,
    '',
  ].join('\n');

  fs.writeFileSync(OUTPUT_FILE, content);
  console.log(`✅ ${files.length}개의 아이콘이 index.ts에 등록되었습니다.`);
};

generate();
