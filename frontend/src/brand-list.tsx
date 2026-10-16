import { useEffect, useRef, useState } from "react";
import { createRoot } from "react-dom/client";

type IndustryOption = {
  slug: string;
  name: string;
};

type BrandIndustry = {
  slug: string;
  name: string | null;
};

type BrandCard = {
  name: string;
  slug: string;
  industry: BrandIndustry | null;
  average_rating: number | null;
  review_count: number;
  short_description: string;
  top_review: { slug: string; title: string; snippet: string; reviewer_name: string } | null;
};

type BrandPage = {
  count: number;
  results: BrandCard[];
};

type Query = {
  industries: string[];
  sort: string;
  page: number;
  pageSize: number;
};

type Shown = {
  page: number;
  pageSize: number;
  count: number;
  results: BrandCard[];
};

const SORTS = ["rating", "-rating", "reviews", "-reviews"] as const;
const MAX_PAGE_SIZE = 50;

export function mountBrandList() {
  const root = document.getElementById("brand-list");
  if (!root) return;
  createRoot(root).render(<BrandList />);
}

function BrandList() {
  const [industries] = useState(readIndustries);
  const [query, setQuery] = useState(readQuery);
  const [shown, setShown] = useState<Shown | null>(null);
  const [loading, setLoading] = useState(true);
  const [problem, setProblem] = useState<null | "retry" | "reset">(null);
  const [attempt, setAttempt] = useState(0);
  const headingRef = useRef<HTMLHeadingElement>(null);
  const pendingFocus = useRef(false);

  useEffect(() => {
    const onPop = () => {
      setLoading(true);
      setQuery(readQuery());
    };
    window.addEventListener("popstate", onPop);
    return () => window.removeEventListener("popstate", onPop);
  }, []);

  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);
    setProblem(null);
    const requested = query;
    fetch(apiUrl(requested), { signal: controller.signal })
      .then(async (response) => {
        if (controller.signal.aborted) return;
        if (response.status === 400 || response.status === 404) {
          setProblem("reset");
          setLoading(false);
          return;
        }
        if (!response.ok) {
          setProblem("retry");
          setLoading(false);
          return;
        }
        const body = (await response.json()) as BrandPage;
        if (controller.signal.aborted) return;
        setShown({
          page: requested.page,
          pageSize: requested.pageSize,
          count: body.count,
          results: body.results,
        });
        setLoading(false);
      })
      .catch((error: unknown) => {
        if (controller.signal.aborted) return;
        if (error instanceof DOMException && error.name === "AbortError") return;
        setProblem("retry");
        setLoading(false);
      });
    return () => controller.abort();
  }, [query, attempt]);

  useEffect(() => {
    if (!pendingFocus.current || loading) return;
    if (problem || !shown || shown.results.length === 0) {
      pendingFocus.current = false;
      return;
    }
    headingRef.current?.focus();
    pendingFocus.current = false;
  }, [loading, problem, shown]);

  function commit(next: Query) {
    setLoading(true);
    window.history.pushState(null, "", hrefFor(next));
    setQuery(next);
  }

  function showPage(page: number) {
    pendingFocus.current = true;
    commit({ ...query, page });
  }

  function toggleIndustry(slug: string, selected: boolean) {
    const industries = selected
      ? [...query.industries, slug]
      : query.industries.filter((current) => current !== slug);
    commit({ ...query, industries, page: 1 });
  }

  const start = shown ? (shown.page - 1) * shown.pageSize + 1 : 0;
  const end = shown ? start + shown.results.length - 1 : 0;
  const heading =
    shown && shown.results.length > 0
      ? `Showing ${start}\u2013${end} of ${shown.count} brands`
      : "";

  return (
    <>
      <div className="brand-filters">
        <fieldset>
          <legend>Industry</legend>
          {industries.map((industry) => (
            <label key={industry.slug}>
              <input
                type="checkbox"
                checked={query.industries.includes(industry.slug)}
                onChange={(event) => {
                  toggleIndustry(industry.slug, event.currentTarget.checked);
                }}
                onKeyUp={(event) => {
                  if (event.key !== "Space") return;
                  event.currentTarget.click();
                }}
              />
              {industry.name}
            </label>
          ))}
        </fieldset>
        <label>
          Sort
          <select
            value={query.sort || "-rating"}
            onChange={(event) => commit({ ...query, sort: event.currentTarget.value, page: 1 })}
          >
            {SORTS.map((value) => (
              <option key={value} value={value}>
                {sortLabel(value)}
              </option>
            ))}
          </select>
        </label>
      </div>
      {loading && !shown && !problem ? <Skeletons /> : null}
      {problem === "retry" ? (
        <div role="alert">
          <p>The brand list could not be loaded.</p>
          <button
            type="button"
            onClick={() => {
              setLoading(true);
              setProblem(null);
              setAttempt((value) => value + 1);
            }}
          >
            Retry
          </button>
        </div>
      ) : null}
      {problem === "reset" ? (
        <div role="alert">
          <p>Those filters could not be applied.</p>
          <button
            type="button"
            onClick={() => commit({ ...query, industries: [], sort: "", page: 1 })}
          >
            Reset
          </button>
        </div>
      ) : null}
      {shown && !problem && shown.results.length === 0 ? (
        <div>
          <p>No brands match these filters.</p>
          <button type="button" onClick={() => commit({ ...query, industries: [], page: 1 })}>
            Clear
          </button>
        </div>
      ) : null}
      {shown && !problem && shown.results.length > 0 ? (
        <section className={loading ? "dimmed" : undefined} aria-busy={loading} aria-labelledby="brand-list-heading">
          <h2 id="brand-list-heading" tabIndex={-1} ref={headingRef} aria-live="polite">
            {heading}
          </h2>
          <ul className="brand-list">
            {shown.results.map((brand) => (
              <li key={brand.slug}>
                <article className="card" aria-labelledby={`brand-${brand.slug}`}>
                  {brand.industry ? (
                    <div>
                      <span className="badge">{brand.industry.name || brand.industry.slug}</span>
                    </div>
                  ) : null}
                  <h3 id={`brand-${brand.slug}`}>
                    <a href={`/brand/${brand.slug}/`}>{brand.name}</a>
                  </h3>
                  {brand.average_rating != null ? <Stars rating={brand.average_rating} /> : null}{" "}
                  <p className="meta">{brand.review_count} reviews</p>
                  {brand.short_description ? <p className="excerpt">{brand.short_description}</p> : null}
                  {brand.top_review?.snippet ? (
                    <figure className="top-review">
                      <figcaption>
                        <a href={`/review/${brand.top_review.slug}/`}>{brand.top_review.title}</a>
                        <span className="meta">{" \u2014 "}{brand.top_review.reviewer_name}</span>
                      </figcaption>
                      <blockquote>
                        <p className="excerpt">{brand.top_review.snippet}</p>
                      </blockquote>
                    </figure>
                  ) : null}
                </article>
              </li>
            ))}
          </ul>
          {shown.count > shown.pageSize ? (
            <nav className="pagination" aria-label="Pagination">
              <button type="button" onClick={() => showPage(query.page - 1)} disabled={loading || query.page <= 1}>
                Previous
              </button>
              <span aria-current="page">{shown.page}</span>
              <button type="button" onClick={() => showPage(query.page + 1)} disabled={loading || end >= shown.count}>
                Next
              </button>
            </nav>
          ) : null}
        </section>
      ) : null}
    </>
  );
}

function Skeletons() {
  return (
    <div className="brand-list" aria-hidden="true">
      <div className="skeleton" />
      <div className="skeleton" />
      <div className="skeleton" />
      <div className="skeleton" />
    </div>
  );
}

function Stars({ rating }: { rating: number }) {
  const shown = rating.toFixed(1);
  const halves = Math.max(0, Math.min(10, Math.round(rating * 2)));
  const full = Math.floor(halves / 2);
  const half = halves % 2;
  return (
    <span className="stars" aria-label={`Rating: ${shown} out of 5`}>
      {Array.from({ length: full }, (_, index) => (
        <span key={`full-${index}`} className="star-full" aria-hidden="true">
          ★
        </span>
      ))}
      {half ? (
        <span className="star-half" aria-hidden="true">
          ☆
        </span>
      ) : null}
      {Array.from({ length: 5 - full - half }, (_, index) => (
        <span key={`empty-${index}`} className="star-empty" aria-hidden="true">
          ☆
        </span>
      ))}
      <span className="rating-value">{shown}</span>
    </span>
  );
}

function sortLabel(value: (typeof SORTS)[number]) {
  if (value === "rating") return "Lowest rating";
  if (value === "-rating") return "Highest rating";
  if (value === "reviews") return "Fewest reviews";
  return "Most reviews";
}

function readIndustries() {
  const node = document.getElementById("brand-list-industries");
  if (!node?.textContent) return [];
  return JSON.parse(node.textContent) as IndustryOption[];
}

function readQuery(): Query {
  const params = new URLSearchParams(window.location.search);
  const industry = params.get("industry");
  const page = Number(params.get("page") || "1");
  const pageSize = Number(params.get("page_size") || "12");
  const size = Number.isFinite(pageSize) && pageSize > 0 ? pageSize : 12;
  return {
    industries: industry ? industry.split(",").filter(Boolean) : [],
    sort: params.get("sort") ?? "-rating",
    page: Number.isFinite(page) && page > 0 ? page : 1,
    pageSize: Math.min(size, MAX_PAGE_SIZE),
  };
}

function hrefFor(query: Query) {
  const params = new URLSearchParams();
  if (query.industries.length > 0) params.set("industry", query.industries.join(","));
  if (query.sort) params.set("sort", query.sort);
  params.set("page", String(query.page));
  params.set("page_size", String(query.pageSize));
  const search = params.toString();
  return `${window.location.pathname}${search ? `?${search}` : ""}`;
}

function apiUrl(query: Query) {
  const params = new URLSearchParams();
  if (query.industries.length > 0) params.set("industry", query.industries.join(","));
  if (query.sort && query.sort !== "-rating") params.set("sort", query.sort);
  params.set("page", String(query.page));
  params.set("page_size", String(query.pageSize));
  return `/api/brands/?${params.toString()}`;
}
