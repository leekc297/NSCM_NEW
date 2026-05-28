export {};

declare global {
  interface MyTestType {
    t: string;
    a: number;
  }

  /** JSON primitive 타입 */
  type JsonPrimitive = string | number | boolean | null;

  /** JSON 객체 타입 */
  interface JsonObject extends Record<string, JsonValue> {}

  /** JSON 값 타입 (재귀적) */
  type JsonValue = JsonPrimitive | JsonValue[] | JsonObject;

  /** Wijmo primitive 타입 */
  type WijmoPrimitive = string | number | boolean | Date | null;

  /** Wijmo Row item 타입 */
  interface WijmoRowItem extends Record<string, WijmoPrimitive> { CRUD_TYPE?: string }

  /** Lookup 타입 */
  type Lookup = { CODE: string; NAME: string } & Record<string, JsonPrimitive>;
}
