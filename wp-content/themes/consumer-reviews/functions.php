<?php
if (!defined('ABSPATH')) exit;

add_action('after_setup_theme', function () {
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('automatic-feed-links');
    add_theme_support('html5', ['search-form', 'comment-form', 'comment-list', 'gallery', 'caption']);
    register_nav_menus(['primary' => 'Primary Menu']);
});

add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'consumer-reviews',
        get_stylesheet_uri(),
        [],
        wp_get_theme()->get('Version')
    );
});

/**
 * Render a star rating (1-5, allows half stars via floor).
 */
function cr_stars($rating, $show_value = true) {
    $rating = (float) $rating;
    $rating = max(0, min(5, $rating));
    $full = (int) floor($rating);
    $empty = 5 - $full;
    $html = '<span class="stars" aria-label="Rating: ' . esc_attr(number_format($rating, 1)) . ' out of 5">';
    $html .= str_repeat('<span class="star-full">&#9733;</span>', $full);
    $html .= str_repeat('<span class="star-empty">&#9734;</span>', $empty);
    if ($show_value) {
        $html .= '<span class="rating-value">' . esc_html(number_format($rating, 1)) . '</span>';
    }
    $html .= '</span>';
    return $html;
}

/**
 * Get reviews linked to a given brand ID via the ACF "brand" post_object field.
 */
function cr_get_reviews_for_brand($brand_id, $limit = 100) {
    return get_posts([
        'post_type'      => 'review',
        'posts_per_page' => $limit,
        'meta_query'     => [[
            'key'     => 'brand',
            'value'   => (string) $brand_id,
            'compare' => '=',
        ]],
        'orderby'        => 'date',
        'order'          => 'DESC',
    ]);
}

/**
 * Get the linked brand for a review.
 */
function cr_get_brand_for_review($review_id) {
    $brand_id = (int) get_post_meta($review_id, 'brand', true);
    return $brand_id ? get_post($brand_id) : null;
}

/**
 * First industry term name for a brand.
 */
function cr_brand_industry($brand_id) {
    $terms = get_the_terms($brand_id, 'industry');
    if (is_wp_error($terms) || empty($terms)) return null;
    return $terms[0];
}
