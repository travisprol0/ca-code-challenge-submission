<?php
/**
 * Plugin Name: Challenge CPTs and Taxonomies
 * Description: Registers the `brand` and `review` custom post types plus the `industry` taxonomy. Loaded automatically as a must-use plugin so the schema is always present, even after a DB reset.
 */

if (!defined('ABSPATH')) {
    exit;
}

add_action('init', function () {
    register_post_type('brand', [
        'label'         => 'Brands',
        'labels'        => [
            'name'          => 'Brands',
            'singular_name' => 'Brand',
            'add_new_item'  => 'Add New Brand',
            'edit_item'     => 'Edit Brand',
        ],
        'public'        => true,
        'show_in_rest'  => true,
        'rest_base'     => 'brands',
        'menu_icon'     => 'dashicons-awards',
        'has_archive'   => true,
        'rewrite'       => ['slug' => 'brand'],
        'supports'      => ['title', 'editor', 'thumbnail', 'excerpt', 'custom-fields'],
    ]);

    register_post_type('review', [
        'label'         => 'Reviews',
        'labels'        => [
            'name'          => 'Reviews',
            'singular_name' => 'Review',
            'add_new_item'  => 'Add New Review',
            'edit_item'     => 'Edit Review',
        ],
        'public'        => true,
        'show_in_rest'  => true,
        'rest_base'     => 'reviews',
        'menu_icon'     => 'dashicons-star-filled',
        'has_archive'   => true,
        'rewrite'       => ['slug' => 'review'],
        'supports'      => ['title', 'editor', 'author', 'custom-fields'],
    ]);

    register_taxonomy('industry', ['brand'], [
        'label'         => 'Industries',
        'public'        => true,
        'hierarchical'  => false,
        'show_in_rest'  => true,
        'rewrite'       => ['slug' => 'industry'],
    ]);
});
