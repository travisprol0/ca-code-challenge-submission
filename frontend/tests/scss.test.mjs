import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const frontend = resolve(dirname(fileURLToPath(import.meta.url)), "..");

const compiled = spawnSync(
  "npx",
  ["sass", "scss/main.scss", "--no-source-map", "--style=expanded"],
  { cwd: frontend, encoding: "utf8" },
);

assert.equal(compiled.status, 0, compiled.stderr || compiled.stdout);
assert.doesNotMatch(compiled.stderr, /deprecat/i);

const css = compiled.stdout;
const root = css.match(/:root\s*\{([^}]*)\}/);
assert.ok(root, "compiled CSS has a :root block");
assert.match(root[1], /--[A-Za-z0-9-]+\s*:/);
assert.match(root[1], /--space-/, "compiled :root is missing a --space- custom property");
assert.match(css, /22px/);
assert.match(css, /@media \(max-width: 640px\)/);

for (const file of scssSources()) {
  const lines = readFileSync(file, "utf8").split("\n");
  for (const [index, line] of lines.entries()) {
    if (!/(?:^|[^-\w])(?:padding|margin|gap)(?:-[\w-]+)?\s*:/.test(line)) continue;
    assert.doesNotMatch(
      line,
      /\d+px/,
      `${relative(frontend, file)}:${index + 1} has a raw px length on padding, margin, or gap`,
    );
  }
}

const onDisk = readFileSync(resolve(frontend, "../app/static/dist/main.css"), "utf8");
assert.equal(onDisk, css);

assert.equal(
  existsSync(resolve(frontend, "scss/layout/_mobile.scss")),
  false,
  "scss/layout/_mobile.scss must not exist",
);
const layoutIndex = readFileSync(resolve(frontend, "scss/layout/_index.scss"), "utf8");
assert.doesNotMatch(layoutIndex, /mobile/);

assert.match(root[1], /--space-40:\s*40px\s*;/);
assert.equal(countRule(css, ".hero", /padding:\s*var\(--space-40\) var\(--space-0\)\s*;/), 1);
assert.equal(countRule(css, ".hero h1", /font-size:\s*1\.75rem\s*;/), 1);
assert.equal(
  countRule(css, ".site-header .container", /flex-direction:\s*column\s*;/),
  1,
);
assert.equal(countRule(css, ".grid", /grid-template-columns:\s*1fr\s*;/), 1);

function scssSources() {
  const roots = ["layout", "components", "pages"].map((dir) => resolve(frontend, "scss", dir));
  return roots.flatMap((dir) => collectScss(dir));
}

function collectScss(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) return collectScss(path);
    return entry.name.endsWith(".scss") ? [path] : [];
  });
}

function countRule(css, selector, bodyPattern) {
  const escaped = selector.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const rule = new RegExp(`${escaped}\\s*\\{([^}]*)\\}`, "g");
  return [...css.matchAll(rule)].filter((match) => bodyPattern.test(match[1])).length;
}
