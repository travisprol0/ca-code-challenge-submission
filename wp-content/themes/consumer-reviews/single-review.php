<?php get_header(); the_post();
$review_id = get_the_ID();
$rating = get_post_meta($review_id, 'rating', true);
$name = get_post_meta($review_id, 'reviewer_name', true);
$location = get_post_meta($review_id, 'reviewer_location', true);
$brand = cr_get_brand_for_review($review_id);
?>

<section class="review-hero">
  <div class="container">
    <?php if ($brand): ?>
      <div class="brand-link"><a href="<?php echo esc_url(get_permalink($brand)); ?>">&larr; <?php echo esc_html($brand->post_title); ?></a></div>
    <?php endif; ?>
    <h1><?php the_title(); ?></h1>
    <div><?php echo cr_stars($rating); ?></div>
    <div class="review-byline" style="margin-top:8px;">
      <?php echo esc_html($name); ?><?php if ($location): ?>, <?php echo esc_html($location); ?><?php endif; ?>
      &middot; <?php echo esc_html(get_the_date('F j, Y')); ?>
      &middot; Posted by <?php the_author(); ?>
    </div>
  </div>
</section>

<section class="brand-body">
  <div class="container">
    <div class="content">
      <?php the_content(); ?>
    </div>
  </div>
</section>

<?php get_footer(); ?>
