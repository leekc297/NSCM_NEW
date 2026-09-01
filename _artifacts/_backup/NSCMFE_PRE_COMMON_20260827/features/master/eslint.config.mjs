import baseConfig from '../../configs/eslint.config.mjs';

export default [
  ...baseConfig,
  {
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['zustand', 'zustand/**/*'],
              message: '@shared에서 re-export된 것을 쓰세요.',
            },
            {
              group: ['@tanstack/react-query', '@tanstack/react-query/**/*'],
              message: '@foundation에서 re-export된 것을 쓰세요.',
            },
            {
              group: ['clsx', '!@shared/clsx'],
              message: '@shared에서 re-export된 것을 쓰세요.',
            },
            {
              group: ['@mui/material', '@mui/material/**/*'],
              message: '@shared에서 re-export된 것을 쓰세요.',
            },
          ],
        },
      ],
    },
  },
];
