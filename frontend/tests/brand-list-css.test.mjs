import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { dirname, resolve } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const frontend = resolve(dirname(fileURLToPath(import.meta.url)), "..");

test("compiled CSS includes the brand-list grid, the one-column media query, and line-clamp", () => {
  const compiled = spawnSync(
    "npx",
    ["sass", "scss/main.scss", "--no-source-map", "--style=expanded"],
    { cwd: frontend, encoding: "utf8" },
  );
  assert.equal(compiled.status, 0, compiled.stderr || compiled.stdout);

  const css = compiled.stdout;
  const desktop = stripAtMedia(css);
  assert.ok(
    hasDeclaration(
      desktop,
      /grid-template-columns:\s*repeat\(\s*auto-fill\s*,\s*minmax\(\s*280px\s*,\s*1fr\s*\)\s*\)\s*;/,
    ),
    "desktop CSS is missing .brand-list { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); }",
  );
  assert.ok(
    hasDeclaration(css, /line-clamp\s*:/),
    "compiled CSS is missing line-clamp on a .brand-list rule",
  );

  const narrow = mediaBlocks(css, "@media (max-width: 640px)").join("\n");
  assert.ok(
    hasDeclaration(narrow, /grid-template-columns:\s*1fr\s*;/),
    "the max-width: 640px query is missing a one-column .brand-list rule (grid-template-columns: 1fr)",
  );
});

test("nav.pagination shares padding, border, and gap with buttons, links, and the current page", () => {
  const compiled = spawnSync(
    "npx",
    ["sass", "scss/main.scss", "--no-source-map", "--style=expanded"],
    { cwd: frontend, encoding: "utf8" },
  );
  assert.equal(compiled.status, 0, compiled.stderr || compiled.stdout);

  const css = compiled.stdout;
  assert.doesNotMatch(css, /\.page-numbers/);

  const nav = css.match(/nav\.pagination\s*\{([^}]*)\}/);
  assert.ok(nav, "compiled CSS is missing a nav.pagination rule");
  assert.match(nav[1], /padding\s*:/);
  assert.match(nav[1], /border\s*:/);
  assert.match(nav[1], /gap\s*:/);

  const shared = [
    ...css.matchAll(
      /([^{}]+)\{([^{}]*)\}/g,
    ),
  ].find((match) => {
    const selector = match[1];
    return (
      /nav\.pagination[^{]*button/.test(selector) &&
      /nav\.pagination[^{]*\ba\b/.test(selector) &&
      /aria-current\s*=\s*["']?page["']?/.test(selector)
    );
  });
  assert.ok(
    shared,
    'compiled CSS is missing one rule for nav.pagination buttons, links, and [aria-current="page"]',
  );
});

function hasDeclaration(css, bodyPattern) {
  for (const match of css.matchAll(/\.brand-list[^{]*\{([^}]*)\}/g)) {
    if (bodyPattern.test(match[1])) return true;
  }
  return false;
}

function mediaBlocks(css, header) {
  const blocks = [];
  let from = 0;
  while (from < css.length) {
    const start = css.indexOf(header, from);
    if (start === -1) break;
    const open = css.indexOf("{", start);
    let depth = 0;
    let index = open;
    for (; index < css.length; index += 1) {
      if (css[index] === "{") depth += 1;
      else if (css[index] === "}") {
        depth -= 1;
        if (depth === 0) {
          blocks.push(css.slice(open + 1, index));
          break;
        }
      }
    }
    from = index + 1;
  }
  return blocks;
}

function stripAtMedia(css) {
  let out = "";
  for (let index = 0; index < css.length; index += 1) {
    if (css.startsWith("@media", index)) {
      const open = css.indexOf("{", index);
      let depth = 0;
      let end = open;
      for (; end < css.length; end += 1) {
        if (css[end] === "{") depth += 1;
        else if (css[end] === "}") {
          depth -= 1;
          if (depth === 0) {
            end += 1;
            break;
          }
        }
      }
      index = end - 1;
    } else {
      out += css[index];
    }
  }
  return out;
}
