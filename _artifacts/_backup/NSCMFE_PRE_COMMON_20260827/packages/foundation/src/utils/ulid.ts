import { ulid } from 'ulid';

export const getUuid = (): string => {
  return ulid();
};
