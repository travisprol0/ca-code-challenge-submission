<?php
/**
 * Plugin Name: Challenge ACF Field Groups
 * Description: Registers ACF field groups for `brand` and `review` post types in code. Survives DB resets and documents the schema for the migration challenge.
 */

if (!defined('ABSPATH')) {
    exit;
}

add_action('acf/init', function () {
    if (!function_exists('acf_add_local_field_group')) {
        return;
    }

    acf_add_local_field_group([
        'key'      => 'group_brand_profile',
        'title'    => 'Brand Profile',
        'location' => [[[
            'param'    => 'post_type',
            'operator' => '==',
            'value'    => 'brand',
        ]]],
        'show_in_rest' => 1,
        'fields'   => [
            [
                'key'           => 'field_brand_website_url',
                'label'         => 'Website URL',
                'name'          => 'website_url',
                'type'          => 'url',
                'required'      => 0,
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_brand_founded_year',
                'label'         => 'Founded Year',
                'name'          => 'founded_year',
                'type'          => 'number',
                'min'           => 1800,
                'max'           => 2100,
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_brand_headquarters',
                'label'         => 'Headquarters',
                'name'          => 'headquarters',
                'type'          => 'text',
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_brand_average_rating',
                'label'         => 'Average Rating',
                'name'          => 'average_rating',
                'type'          => 'number',
                'min'           => 0,
                'max'           => 5,
                'step'          => 0.1,
                'show_in_rest'  => 1,
            ],
        ],
    ]);

    acf_add_local_field_group([
        'key'      => 'group_review_details',
        'title'    => 'Review Details',
        'location' => [[[
            'param'    => 'post_type',
            'operator' => '==',
            'value'    => 'review',
        ]]],
        'show_in_rest' => 1,
        'fields'   => [
            [
                'key'           => 'field_review_rating',
                'label'         => 'Rating (1-5)',
                'name'          => 'rating',
                'type'          => 'number',
                'min'           => 1,
                'max'           => 5,
                'step'          => 1,
                'required'      => 1,
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_review_reviewer_name',
                'label'         => 'Reviewer Name',
                'name'          => 'reviewer_name',
                'type'          => 'text',
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_review_reviewer_location',
                'label'         => 'Reviewer Location',
                'name'          => 'reviewer_location',
                'type'          => 'text',
                'show_in_rest'  => 1,
            ],
            [
                'key'           => 'field_review_brand',
                'label'         => 'Brand',
                'name'          => 'brand',
                'type'          => 'post_object',
                'post_type'     => ['brand'],
                'return_format' => 'id',
                'required'      => 1,
                'show_in_rest'  => 1,
            ],
        ],
    ]);
});
