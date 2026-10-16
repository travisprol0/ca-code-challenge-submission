<?php get_header(); the_post();
$brand_id = get_the_ID();
$website = get_post_meta($brand_id, 'website_url', true);
$founded = get_post_meta($brand_id, 'founded_year', true);
$hq = get_post_meta($brand_id, 'headquarters', true);
$rating = get_post_meta($brand_id, 'average_rating', true);
$industry = cr_brand_industry($brand_id);
$reviews = cr_get_reviews_for_brand($brand_id);
?>

<section class="brand-hero">
  <div class="container">
    <?php if ($industry): ?>
      <div><span class="badge"><?php echo esc_html($industry->name); ?></span></div>
    <?php endif; ?>
    <h1><?php the_title(); ?></h1>
    <div><?php echo cr_stars($rating); ?> <span class="meta" style="margin-left:8px;">(<?php echo count($reviews); ?> review<?php echo count($reviews) === 1 ? '' : 's'; ?>)</span></div>
    <div class="brand-meta">
      <?php if ($hq): ?><div><strong>HQ:</strong> <?php echo esc_html($hq); ?></div><?php endif; ?>
      <?php if ($founded): ?><div><strong>Founded:</strong> <?php echo esc_html($founded); ?></div><?php endif; ?>
      <?php if ($website): ?><div><strong>Website:</strong> <a href="<?php echo esc_url($website); ?>" rel="nofollow noopener" target="_blank"><?php echo esc_html(parse_url($website, PHP_URL_HOST)); ?></a></div><?php endif; ?>
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

<section class="reviews-section">
  <div class="container">
    <h2>Customer Reviews</h2>
    <?php if (empty($reviews)): ?>
      <p class="meta">No reviews yet.</p>
    <?php else: foreach ($reviews as $review):
      $r_rating = get_post_meta($review->ID, 'rating', true);
      $r_name = get_post_meta($review->ID, 'reviewer_name', true);
      $r_location = get_post_meta($review->ID, 'reviewer_location', true);
    ?>
      <article class="review-item">
        <div class="review-head">
          <h3><a href="<?php echo esc_url(get_permalink($review)); ?>"><?php echo esc_html($review->post_title); ?></a></h3>
          <div><?php echo cr_stars($r_rating, false); ?></div>
        </div>
        <div class="review-byline">
          <?php echo esc_html($r_name); ?><?php if ($r_location): ?>, <?php echo esc_html($r_location); ?><?php endif; ?>
          &middot; <?php echo esc_html(get_the_date('M j, Y', $review)); ?>
        </div>
        <div class="review-body">
          <?php echo wp_kses_post(wpautop($review->post_content)); ?>
        </div>
      </article>
    <?php endforeach; endif; ?>
  </div>
</section>

<?php get_footer(); ?>
