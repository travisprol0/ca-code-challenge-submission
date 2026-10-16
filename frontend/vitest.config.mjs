export default {
  oxc: {
    jsx: {
      runtime: "automatic",
    },
  },
  test: {
    environment: "jsdom",
    include: ["tests/brand-list.test.ts"],
  },
};
