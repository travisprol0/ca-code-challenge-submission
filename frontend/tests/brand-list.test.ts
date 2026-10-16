import { cleanup, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { axe, toHaveNoViolations } from "jest-axe";
import { act } from "react";
import { afterEach, beforeEach, expect, test, vi } from "vitest";

expect.extend(toHaveNoViolations);

const PAGE_ONE = "Showing 1\u20132 of 5 brands";
const PAGE_TWO = "Showing 3\u20134 of 5 brands";

const INDUSTRIES = [
  { slug: "insurance", name: "Insurance" },
  { slug: "retail", name: "Retail" },
];

const SORT_VALUES = ["-rating", "-reviews", "rating", "reviews"];

type Hit = {
  url: URL;
  init?: RequestInit;
  raw: RequestInfo | URL;
};

let restoreListen = () => {};

beforeEach(() => {
  vi.resetModules();
  window.history.replaceState(null, "", "/brand/");
  const tracked: Array<
    [string, EventListenerOrEventListenerObject, boolean | AddEventListenerOptions | undefined]
  > = [];
  const add = window.addEventListener.bind(window);
  const remove = window.removeEventListener.bind(window);
  window.addEventListener = ((type, listener, options) => {
    tracked.push([String(type), listener, options]);
    add(type, listener, options);
  }) as typeof window.addEventListener;
  restoreListen = () => {
    window.addEventListener = add as typeof window.addEventListener;
    for (const [type, listener, options] of tracked) {
      remove(type, listener, options);
    }
  };
});

afterEach(() => {
  cleanup();
  document.body.replaceChildren();
  restoreListen();
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

test("reads industry, sort, page, and page_size from the URL on load", async () => {
  setUrl("?industry=insurance&sort=-reviews&page=2&page_size=2");
  const calls = installCatalog();

  await mount();

  await waitFor(() => {
    expect(calls.length).toBeGreaterThan(0);
  });
  expect(calls[0].url.searchParams.get("industry")).toBe("insurance");
  expect(calls[0].url.searchParams.get("sort")).toBe("-reviews");
  expect(calls[0].url.searchParams.get("page")).toBe("2");
  expect(calls[0].url.searchParams.get("page_size")).toBe("2");

  const insurance = screen.getByRole("checkbox", { name: "Insurance" }) as HTMLInputElement;
  const retail = screen.getByRole("checkbox", { name: "Retail" }) as HTMLInputElement;
  expect(insurance.checked).toBe(true);
  expect(retail.checked).toBe(false);
  expect(screen.getAllByRole("checkbox")).toHaveLength(2);

  const sort = screen.getByRole("combobox") as HTMLSelectElement;
  expect(sort).toBeInstanceOf(HTMLSelectElement);
  expect(sort.value).toBe("-reviews");
  expect(optionValues(sort)).toEqual(SORT_VALUES);
});

test("writes a sort change into the URL with pushState and resets page to 1", async () => {
  setUrl("?page_size=2");
  const calls = installCatalog();
  const pushState = vi.spyOn(window.history, "pushState");
  const user = userEvent.setup();

  await mount();
  await screen.findAllByRole("article");

  await user.selectOptions(screen.getByRole("combobox"), "reviews");

  await waitFor(() => {
    const current = new URL(window.location.href);
    expect(current.pathname).toBe("/brand/");
    expect(current.searchParams.get("sort")).toBe("reviews");
    expect(current.searchParams.get("page")).toBe("1");
    expect(current.searchParams.get("page_size")).toBe("2");
  });
  expect(pushState).toHaveBeenCalled();
  const sent = calls.at(-1)!.url.searchParams;
  expect(sent.get("sort")).toBe("reviews");
  expect(sent.get("page")).toBe("1");
  expect(sent.get("page_size")).toBe("2");
});

test("restores the list from the URL when the user goes Back", async () => {
  setUrl("?page_size=2&sort=rating");
  const calls = installCatalog();
  const user = userEvent.setup();

  await mount();
  await screen.findAllByRole("article");
  const before = window.location.href;

  await user.selectOptions(screen.getByRole("combobox"), "-rating");
  await waitFor(() => {
    expect(new URL(window.location.href).searchParams.get("sort")).toBe("-rating");
  });

  window.history.back();

  await waitFor(() => {
    const current = new URL(window.location.href).searchParams;
    expect(current.get("sort")).toBe("rating");
    expect(current.get("page_size")).toBe("2");
    const sort = screen.getByRole("combobox") as HTMLSelectElement;
    expect(sort.value).toBe("rating");
    expect(calls.at(-1)!.url.searchParams.get("sort")).toBe("rating");
    expect(calls.at(-1)!.url.searchParams.get("page_size")).toBe("2");
  });
  expect(new URL(before).searchParams.get("sort")).toBe("rating");
});

test("pager is absent when five brands fit on one page", async () => {
  setUrl("?page_size=5");
  installCatalog();

  await mount();
  await screen.findAllByRole("article");

  expect(screen.getAllByRole("article")).toHaveLength(5);
  expect(screen.queryByRole("navigation", { name: "Pagination" })).toBeNull();
});

test("pager is present at page_size 2", async () => {
  setUrl("?page_size=2");
  installCatalog();

  await mount();
  await screen.findByRole("heading", { name: PAGE_ONE });

  const pager = screen.getByRole("navigation", { name: "Pagination" });
  const current = pager.querySelector("[aria-current='page']");
  expect(current).toBeTruthy();
  expect(current?.tagName).not.toBe("A");
  expect(current?.tagName).not.toBe("BUTTON");
  expect(current?.textContent?.trim()).toBe("1");
});

test("caps page size at 50 and still paginates a longer list", async () => {
  setUrl("?page_size=1000");
  const brands = Array.from({ length: 60 }, (_, index) =>
    brand({ name: `Brand ${index + 1}`, slug: `brand-${index + 1}` }),
  );
  const calls: URL[] = [];
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    const url = assertApiRequest(input, init);
    calls.push(url);
    const page = Number(url.searchParams.get("page") || "1");
    const requested = Number(url.searchParams.get("page_size") || "12");
    const pageSize = Math.min(requested, 50);
    const start = (page - 1) * pageSize;
    return Promise.resolve(jsonResponse(pageOf(brands.slice(start, start + pageSize), brands.length)));
  });
  const user = userEvent.setup();

  await mount();

  await screen.findByRole("heading", { name: "Showing 1\u201350 of 60 brands" });
  expect(calls[0].searchParams.get("page_size")).toBe("50");
  expect(screen.getAllByRole("article")).toHaveLength(50);
  expect(screen.getByRole("navigation", { name: "Pagination" })).toBeTruthy();

  await user.click(screen.getByRole("button", { name: "Next" }));

  expect(await screen.findByRole("heading", { name: "Showing 51\u201360 of 60 brands" })).toBeTruthy();
  expect(calls.at(-1)!.searchParams.get("page")).toBe("2");
  expect(calls.at(-1)!.searchParams.get("page_size")).toBe("50");
});

test("does not skip a page when Next is clicked twice before the response", async () => {
  setUrl("?page_size=2");
  const calls: URL[] = [];
  const gate = deferred<void>();
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    const url = assertApiRequest(input, init);
    calls.push(url);
    requests += 1;
    if (requests === 1) return Promise.resolve(jsonResponse(sliceCatalog(url)));
    return gate.promise.then(() => jsonResponse(sliceCatalog(url)));
  });
  const user = userEvent.setup();

  await mount();
  await screen.findByRole("heading", { name: PAGE_ONE });

  await user.click(screen.getByRole("button", { name: "Next" }));

  await waitFor(() => {
    expect((screen.getByRole("button", { name: "Next" }) as HTMLButtonElement).disabled).toBe(true);
  });
  screen.getByRole("button", { name: "Next" }).click();
  expect(calls.map((url) => url.searchParams.get("page"))).toEqual(["1", "2"]);

  gate.resolve();

  expect(await screen.findByRole("heading", { name: PAGE_TWO })).toBeTruthy();
});

test("heading is a live region", async () => {
  setUrl("?page_size=2");
  installCatalog();

  await mount();
  const heading = await screen.findByRole("heading", { name: PAGE_ONE });
  expect(heading.getAttribute("aria-live")).toBe("polite");
});

test("select has no empty option, and a URL with no sort shows -rating and does not send sort", async () => {
  setUrl("?page_size=2");
  const calls = installCatalog();

  await mount();
  await screen.findAllByRole("article");

  const sort = screen.getByRole("combobox") as HTMLSelectElement;
  const values = [...sort.options].map((option) => option.value);
  expect(values).not.toContain("");
  expect(values.sort()).toEqual([...SORT_VALUES].sort());
  expect(sort.value).toBe("-rating");
  expect(calls[0].url.searchParams.has("sort")).toBe(false);
});

test("paginates /brand/?page_size=2, announces page 2, and focuses the results heading", async () => {
  setUrl("?page_size=2");
  const calls = installCatalog();
  const user = userEvent.setup();

  await mount();

  const firstHeading = await screen.findByRole("heading", { name: PAGE_ONE });
  const section = firstHeading.closest("section");
  expect(section).toBeTruthy();
  expect(section?.querySelectorAll("ul article")).toHaveLength(2);
  expect(calls[0].url.searchParams.get("page")).toBe("1");
  expect(calls[0].url.searchParams.get("page_size")).toBe("2");
  expect(calls[0].url.searchParams.get("industry")).toBeNull();
  expect(calls[0].url.searchParams.get("sort")).toBeNull();

  await user.click(screen.getByRole("button", { name: "Next" }));

  const secondHeading = await screen.findByRole("heading", { name: PAGE_TWO });
  expect(secondHeading.closest("section")?.querySelectorAll("ul article")).toHaveLength(2);
  await waitFor(() => {
    expect(document.activeElement).toBe(secondHeading);
  });
  const sent = calls.at(-1)!.url.searchParams;
  expect(sent.get("page")).toBe("2");
  expect(sent.get("page_size")).toBe("2");
});

test("resets to page 1 when the filter or the sort changes", async () => {
  setUrl("?page=3&page_size=2");
  const calls = installCatalog();
  const user = userEvent.setup();

  await mount();
  await screen.findByRole("article");

  await user.selectOptions(screen.getByRole("combobox"), "reviews");
  await waitFor(() => {
    const sent = calls.at(-1)!.url.searchParams;
    expect(sent.get("sort")).toBe("reviews");
    expect(sent.get("page")).toBe("1");
    expect(sent.get("page_size")).toBe("2");
    expect(new URL(window.location.href).searchParams.get("page")).toBe("1");
  });

  await user.click(screen.getByRole("button", { name: "Next" }));
  await waitFor(() => {
    expect(calls.at(-1)!.url.searchParams.get("page")).toBe("2");
  });

  await user.click(screen.getByRole("checkbox", { name: "Insurance" }));
  await waitFor(() => {
    const sent = calls.at(-1)!.url.searchParams;
    expect(sent.get("industry")).toBe("insurance");
    expect(sent.get("sort")).toBe("reviews");
    expect(sent.get("page")).toBe("1");
    expect(sent.get("page_size")).toBe("2");
  });
});

test("sends two industries in one param and still renders one badge", async () => {
  setUrl("?page_size=2");
  const calls = installJson(() =>
    jsonResponse({
      count: 1,
      next: null,
      previous: null,
      results: [
        brand({
          name: "Both Markets",
          slug: "both-markets",
          industry: { slug: "finance", name: "Finance" },
        }),
      ],
    }),
  );
  const user = userEvent.setup();

  await mount();
  await screen.findByRole("article");

  await user.click(screen.getByRole("checkbox", { name: "Insurance" }));
  await user.click(screen.getByRole("checkbox", { name: "Retail" }));

  await waitFor(() => {
    const params = calls.at(-1)!.url.searchParams;
    expect(params.getAll("industry")).toHaveLength(1);
    expect(params.get("industry")?.split(",").sort()).toEqual(["insurance", "retail"]);
  });

  const card = articleByName("Both Markets");
  const badges = card.querySelectorAll(".badge");
  expect(badges).toHaveLength(1);
  expect(badges[0].textContent?.trim()).toBe("Finance");
});

test("does not let a slow first response overwrite a faster second one", async () => {
  setUrl("?page_size=2");
  const first = deferred<Response>();
  const second = deferred<Response>();
  const signals: Array<AbortSignal | null | undefined> = [];
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    assertApiRequest(input, init);
    signals.push(signalOf(input, init));
    return requests === 1 ? first.promise : second.promise;
  });
  const user = userEvent.setup();

  await mount();
  expect(document.querySelectorAll(".skeleton").length).toBeGreaterThan(0);

  await user.selectOptions(screen.getByRole("combobox"), "reviews");
  await waitFor(() => {
    expect(requests).toBe(2);
  });
  expect(signals[0]?.aborted).toBe(true);
  expect(signals[1]?.aborted).toBe(false);

  await act(async () => {
    second.resolve(jsonResponse(pageOf([brand({ name: "Second Wind", slug: "second-wind" })])));
  });
  await screen.findByText("Second Wind");

  await act(async () => {
    first.resolve(jsonResponse(pageOf([brand({ name: "First Wind", slug: "first-wind" })])));
  });

  expect(screen.queryByText("First Wind")).toBeNull();
  expect(screen.getByText("Second Wind")).toBeTruthy();
});

test("shows skeletons on the first load and articles after the response", async () => {
  setUrl("?page_size=2");
  const pending = deferred<Response>();
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    assertApiRequest(input, init);
    return pending.promise;
  });

  await mount();

  expect(document.querySelectorAll("#brand-list .skeleton").length).toBeGreaterThan(0);
  expect(document.querySelectorAll("#brand-list article")).toHaveLength(0);

  await act(async () => {
    pending.resolve(jsonResponse(sliceCatalog(new URL(window.location.href))));
  });

  expect(await screen.findAllByRole("article")).toHaveLength(2);
  expect(document.querySelectorAll("#brand-list .skeleton")).toHaveLength(0);
});

test("keeps the previous results dimmed and aria-busy while a later load is in flight", async () => {
  setUrl("?page_size=2");
  const first = deferred<Response>();
  const second = deferred<Response>();
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    assertApiRequest(input, init);
    return requests === 1 ? first.promise : second.promise;
  });
  const user = userEvent.setup();

  await mount();
  await act(async () => {
    first.resolve(jsonResponse(sliceCatalog(new URL("/brand/?page=1&page_size=2", window.location.origin))));
  });
  await screen.findByText("Acme Insurance Co.");

  await user.selectOptions(screen.getByRole("combobox"), "-rating");
  await waitFor(() => {
    expect(requests).toBe(2);
  });

  const busy = document.querySelector("[aria-busy='true']");
  expect(busy).toBeTruthy();
  expect(busy?.classList.contains("dimmed")).toBe(true);
  expect(busy?.textContent).toContain("Acme Insurance Co.");
  expect(document.querySelectorAll("#brand-list article").length).toBeGreaterThan(0);

  second.resolve(jsonResponse(sliceCatalog(new URL(window.location.href))));
});

test("shows a clear control when there are no brands", async () => {
  setUrl("?industry=retail&page_size=2");
  const calls: URL[] = [];
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    const url = assertApiRequest(input, init);
    calls.push(url);
    if (requests === 1) {
      return Promise.resolve(jsonResponse({ count: 0, next: null, previous: null, results: [] }));
    }
    return Promise.resolve(jsonResponse(sliceCatalog(url)));
  });
  const user = userEvent.setup();

  await mount();

  const clear = await screen.findByRole("button", { name: "Clear" });
  expect(document.querySelectorAll("#brand-list article")).toHaveLength(0);

  await user.click(clear);

  await waitFor(() => {
    expect(calls.at(-1)!.searchParams.get("industry")).toBeNull();
    const page = calls.at(-1)!.searchParams.get("page");
    expect(page === null || page === "1").toBe(true);
  });
  expect(await screen.findAllByRole("article")).not.toHaveLength(0);
});

test("shows an alert and Retry when the request fails", async () => {
  setUrl("?page_size=2");
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    assertApiRequest(input, init);
    if (requests === 1) return Promise.reject(new Error("offline"));
    return Promise.resolve(
      jsonResponse(sliceCatalog(new URL("/brand/?page=1&page_size=2", window.location.origin))),
    );
  });
  const user = userEvent.setup();

  await mount();

  expect(await screen.findByRole("alert")).toBeTruthy();
  await user.click(screen.getByRole("button", { name: "Retry" }));

  expect(await screen.findAllByRole("article")).not.toHaveLength(0);
  expect(requests).toBe(2);
});

test("offers reset when the API returns 400", async () => {
  setUrl("?industry=not-a-real-industry&sort=title&page=4&page_size=2");
  const calls: URL[] = [];
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    const url = assertApiRequest(input, init);
    calls.push(url);
    if (requests === 1) return Promise.resolve(jsonResponse({ detail: "Unknown industry." }, 400));
    return Promise.resolve(jsonResponse(sliceCatalog(url)));
  });
  const user = userEvent.setup();

  await mount();

  await user.click(await screen.findByRole("button", { name: "Reset" }));

  await waitFor(() => {
    const current = new URL(window.location.href);
    expect(current.searchParams.get("industry")).toBeNull();
    expect(current.searchParams.get("sort")).toBeNull();
    const page = current.searchParams.get("page");
    expect(page === null || page === "1").toBe(true);
  });
  expect(await screen.findAllByRole("article")).not.toHaveLength(0);
  expect(calls.at(-1)!.searchParams.get("industry")).toBeNull();
  expect(calls.at(-1)!.searchParams.get("sort")).toBeNull();
});

test("offers reset when the page is out of range", async () => {
  setUrl("?page=99&page_size=2");
  const calls: URL[] = [];
  let requests = 0;
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    requests += 1;
    const url = assertApiRequest(input, init);
    calls.push(url);
    if (requests === 1) return Promise.resolve(jsonResponse({ detail: "Invalid page." }, 404));
    return Promise.resolve(jsonResponse(sliceCatalog(url)));
  });
  const user = userEvent.setup();

  await mount();

  await user.click(await screen.findByRole("button", { name: "Reset" }));

  await waitFor(() => {
    expect(new URL(window.location.href).searchParams.get("page")).not.toBe("99");
  });
  expect(await screen.findAllByRole("article")).not.toHaveLength(0);
  const page = calls.at(-1)!.searchParams.get("page");
  expect(page === null || page === "1").toBe(true);
});

test("filters, sorts, and paginates without a mouse", async () => {
  setUrl("?page_size=2");
  const calls = installCatalog();
  const user = userEvent.setup();

  await mount();
  await screen.findAllByRole("article");

  const insurance = screen.getByRole("checkbox", { name: "Insurance" });
  insurance.focus();
  await user.keyboard("{Space}");
  await waitFor(() => {
    expect(calls.at(-1)!.url.searchParams.get("industry")).toBe("insurance");
  });

  const sort = screen.getByRole("combobox") as HTMLSelectElement;
  expect(sort).toBeInstanceOf(HTMLSelectElement);
  sort.focus();
  expect(document.activeElement).toBe(sort);
  await user.selectOptions(sort, "reviews");
  await waitFor(() => {
    expect(calls.at(-1)!.url.searchParams.get("sort")).toBe("reviews");
    expect(calls.at(-1)!.url.searchParams.get("page")).toBe("1");
  });

  const next = screen.getByRole("button", { name: "Next" });
  next.focus();
  await user.keyboard("{Enter}");
  await waitFor(() => {
    expect(calls.at(-1)!.url.searchParams.get("page")).toBe("2");
    expect(calls.at(-1)!.url.searchParams.get("page_size")).toBe("2");
  });
});

test("rounds HomeShield, UrbanRetail, and Acme to one decimal and to the nearest half star", async () => {
  setUrl("?page_size=12");
  installJson(() => jsonResponse(pageOf(ratedBrands(), ratedBrands().length)));

  await mount();
  await screen.findByText("Acme Insurance Co.");

  expect(rounded(articleByName("HomeShield Pro"))).toBe("3.1");
  expect(rounded(articleByName("UrbanRetail Co."))).toBe("3.7");
  expect(rounded(articleByName("Acme Insurance Co."))).toBe("3.9");
  expect(starCounts(articleByName("HomeShield Pro"))).toEqual([3, 0, 2]);
  expect(starCounts(articleByName("UrbanRetail Co."))).toEqual([3, 1, 1]);
  expect(starCounts(articleByName("Acme Insurance Co."))).toEqual([4, 0, 1]);
});

test("names Acme's rating Rating: 3.9 out of 5 and hides the star glyphs", async () => {
  setUrl("?page_size=12");
  installJson(() => jsonResponse(pageOf(ratedBrands(), ratedBrands().length)));

  await mount();
  await screen.findByText("Acme Insurance Co.");

  const acme = articleByName("Acme Insurance Co.");
  expect(acme.querySelector('[aria-label="Rating: 3.9 out of 5"]')).toBeTruthy();
  const stars = acme.querySelectorAll(".star-full, .star-half, .star-empty");
  expect(stars).toHaveLength(5);
  for (const star of stars) {
    expect(star.getAttribute("aria-hidden")).toBe("true");
  }

  const urban = articleByName("UrbanRetail Co.");
  expect(urban.querySelector(".star-half")?.getAttribute("aria-hidden")).toBe("true");
});

test("quotes the brand's review under its description with a linked title and the reviewer", async () => {
  setUrl("?page_size=12");
  installJson(() => jsonResponse(pageOf([brand()], 1)));

  await mount();
  await screen.findByText("Acme Insurance Co.");

  const card = articleByName("Acme Insurance Co.");
  expect(card.querySelector(":scope > .excerpt")?.textContent).toBe("Coverage for the careful.");

  const figure = card.querySelector("figure.top-review");
  expect(figure).toBeTruthy();
  expect(figure!.firstElementChild?.tagName).toBe("FIGCAPTION");

  const caption = figure!.querySelector("figcaption")!;
  expect(caption.textContent).not.toMatch(/top review/i);
  expect(caption.textContent).toContain("Dana Cho");
  const link = caption.querySelector("a");
  expect(link?.textContent).toBe("Fine but nothing special");
  expect(link?.getAttribute("href")).toBe("/review/fine-but-nothing-special/");

  expect(figure!.querySelector("blockquote")?.textContent).toBe("Fine but nothing special overall.");
});

test("renders a cut description and snippet ending in an ellipsis character", async () => {
  setUrl("?page_size=12");
  const cut = brand({
    short_description: "Coverage for the careful and…",
    top_review: { ...baseBrand().top_review!, snippet: "Fine but nothing special…" },
  });
  installJson(() => jsonResponse(pageOf([cut], 1)));

  await mount();
  await screen.findByText("Acme Insurance Co.");

  const card = articleByName("Acme Insurance Co.");
  expect(card.textContent).toContain("Coverage for the careful and…");
  expect(card.textContent).toContain("Fine but nothing special…");
  for (const article of screen.getAllByRole("article")) {
    expect(article.textContent).not.toContain("&hellip;");
  }
});

test("passes jest-axe on a loaded list", async () => {
  setUrl("?page_size=2");
  installCatalog();

  await mount();
  await screen.findAllByRole("article");

  const results = await axe(document.getElementById("brand-list")!);
  expect(results).toHaveNoViolations();
});

function setUrl(search: string) {
  window.history.replaceState(null, "", `/brand/${search}`);
}

function installDom() {
  document.body.replaceChildren();
  const script = document.createElement("script");
  script.id = "brand-list-industries";
  script.type = "application/json";
  script.textContent = JSON.stringify(INDUSTRIES);
  const root = document.createElement("div");
  root.id = "brand-list";
  document.body.append(script, root);
}

async function mount() {
  installDom();
  const loaded = (await import("../src/brand-list")) as { mountBrandList?: () => void };
  if (typeof loaded.mountBrandList !== "function") {
    throw new Error("frontend/src/brand-list must export mountBrandList");
  }
  await act(async () => {
    loaded.mountBrandList!();
  });
}

function installCatalog() {
  const calls: Hit[] = [];
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    const url = assertApiRequest(input, init);
    calls.push({ url, init, raw: input });
    return Promise.resolve(jsonResponse(sliceCatalog(url)));
  });
  return calls;
}

function installJson(respond: (url: URL) => Response) {
  const calls: Hit[] = [];
  vi.stubGlobal("fetch", (input: RequestInfo | URL, init?: RequestInit) => {
    const url = assertApiRequest(input, init);
    calls.push({ url, init, raw: input });
    return Promise.resolve(respond(url));
  });
  return calls;
}

function assertApiRequest(input: RequestInfo | URL, init?: RequestInit) {
  const url = asUrl(input);
  const method = (init?.method ?? (input instanceof Request ? input.method : "GET")).toUpperCase();
  if (method !== "GET" || url.origin !== window.location.origin || url.pathname !== "/api/brands/") {
    throw new Error(`expected GET ${window.location.origin}/api/brands/ but fetched ${method} ${url.href}`);
  }
  return url;
}

function asUrl(input: RequestInfo | URL) {
  if (typeof input === "string") return new URL(input, window.location.origin);
  if (input instanceof URL) return new URL(input.href);
  return new URL(input.url);
}

function signalOf(input: RequestInfo | URL, init?: RequestInit) {
  if (init?.signal) return init.signal;
  if (input instanceof Request) return input.signal;
  return undefined;
}

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function sliceCatalog(url: URL) {
  const page = Number(url.searchParams.get("page") || "1");
  const pageSize = Number(url.searchParams.get("page_size") || "12");
  const start = (page - 1) * pageSize;
  return pageOf(CATALOG.slice(start, start + pageSize), CATALOG.length);
}

function pageOf(results: ReturnType<typeof brand>[], count = 5) {
  return { count, next: null, previous: null, results };
}

function optionValues(sort: HTMLSelectElement) {
  return [...sort.options].map((option) => option.value).filter(Boolean).sort();
}

function articleByName(name: string) {
  const match = screen.getAllByRole("article").find((article) => article.textContent?.includes(name));
  expect(match).toBeTruthy();
  return match!;
}

function starCounts(article: HTMLElement) {
  return [".star-full", ".star-half", ".star-empty"].map(
    (selector) => article.querySelectorAll(selector).length,
  );
}

function rounded(article: HTMLElement) {
  const match = article.textContent?.match(/\d\.\d(?!\d)/);
  return match?.[0] ?? "";
}

function deferred<T>() {
  let resolve!: (value: T) => void;
  const promise = new Promise<T>((res) => {
    resolve = res;
  });
  return { promise, resolve };
}

function brand(overrides: Partial<ReturnType<typeof baseBrand>> = {}) {
  return { ...baseBrand(), ...overrides };
}

function baseBrand() {
  return {
    name: "Acme Insurance Co.",
    slug: "acme-insurance",
    industry: { slug: "insurance", name: "Insurance" } as { slug: string; name: string } | null,
    average_rating: 3.92,
    review_count: 4,
    short_description: "Coverage for the careful.",
    top_review: {
      slug: "fine-but-nothing-special",
      title: "Fine but nothing special",
      snippet: "Fine but nothing special overall.",
      reviewer_name: "Dana Cho",
    } as { slug: string; title: string; snippet: string; reviewer_name: string } | null,
  };
}

const CATALOG = [
  brand(),
  brand({
    name: "PrimePath Bank",
    slug: "primepath-bank",
    average_rating: 4.2,
    industry: { slug: "finance", name: "Finance" },
  }),
  brand({
    name: "UrbanRetail Co.",
    slug: "urbanretail-co",
    average_rating: 3.67,
    industry: { slug: "retail", name: "Retail" },
  }),
  brand({
    name: "SwiftStream Internet",
    slug: "swiftstream-internet",
    average_rating: 3.5,
    industry: { slug: "telecom", name: "Telecom" },
  }),
  brand({
    name: "HomeShield Pro",
    slug: "homeshield-pro",
    average_rating: 3.08,
    industry: { slug: "home-services", name: "Home Services" },
  }),
];

function ratedBrands() {
  return [
    brand({
      name: "HomeShield Pro",
      slug: "homeshield-pro",
      average_rating: 3.08,
      industry: { slug: "home-services", name: "Home Services" },
    }),
    brand({
      name: "UrbanRetail Co.",
      slug: "urbanretail-co",
      average_rating: 3.67,
      industry: { slug: "retail", name: "Retail" },
    }),
    brand({
      name: "Acme Insurance Co.",
      slug: "acme-insurance",
      average_rating: 3.92,
      industry: { slug: "insurance", name: "Insurance" },
    }),
  ];
}
