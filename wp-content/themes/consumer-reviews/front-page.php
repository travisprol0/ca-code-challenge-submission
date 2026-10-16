<?php get_header(); ?>

<section class="hero">
  <div class="container">
    <h1>Honest reviews of consumer brands</h1>
    <p>Independent customer feedback on insurance, telecom, finance, home services, and retail companies.</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-header">
      <h2>Featured Brands</h2>
      <a href="<?php echo esc_url(get_post_type_archive_link('brand')); ?>">All brands &rarr;</a>
    </div>
    <div class="grid">
      <?php
      $brands = get_posts([
          'post_type'      => 'brand',
          'posts_per_page' => 6,
          'orderby'        => 'meta_value_num',
          'meta_key'       => 'average_rating',
          'order'          => 'DESC',
      ]);
      foreach ($brands as $brand):
          $industry = cr_brand_industry($brand->ID);
          $rating = get_post_meta($brand->ID, 'average_rating', true);
          $hq = get_post_meta($brand->ID, 'headquarters', true);
      ?>
      <article class="card">
        <?php if ($industry): ?>
          <div><span class="badge"><?php echo esc_html($industry->name); ?></span></div>
        <?php endif; ?>
        <h3><a href="<?php echo esc_url(get_permalink($brand)); ?>"><?php echo esc_html($brand->post_title); ?></a></h3>
        <div><?php echo cr_stars($rating); ?></div>
        <p class="meta"><?php echo esc_html($hq); ?></p>
        <p class="excerpt"><?php echo esc_html(wp_trim_words(wp_strip_all_tags($brand->post_content), 22)); ?></p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="section" style="background:#ffffff;border-top:1px solid var(--color-border);border-bottom:1px solid var(--color-border);">
  <div class="container">
    <div class="section-header">
      <h2>Recent Reviews</h2>
      <a href="<?php echo esc_url(get_post_type_archive_link('review')); ?>">All reviews &rarr;</a>
    </div>
    <div class="grid">
      <?php
      $reviews = get_posts([
          'post_type'      => 'review',
          'posts_per_page' => 6,
      ]);
      foreach ($reviews as $review):
          $rating = get_post_meta($review->ID, 'rating', true);
          $name = get_post_meta($review->ID, 'reviewer_name', true);
          $location = get_post_meta($review->ID, 'reviewer_location', true);
          $brand = cr_get_brand_for_review($review->ID);
      ?>
      <article class="card">
        <?php if ($brand): ?>
          <div class="meta"><a href="<?php echo esc_url(get_permalink($brand)); ?>"><?php echo esc_html($brand->post_title); ?></a></div>
        <?php endif; ?>
        <h3><a href="<?php echo esc_url(get_permalink($review)); ?>"><?php echo esc_html($review->post_title); ?></a></h3>
        <div><?php echo cr_stars($rating, false); ?></div>
        <p class="excerpt"><?php echo esc_html(wp_trim_words(wp_strip_all_tags($review->post_content), 24)); ?></p>
        <p class="meta">— <?php echo esc_html($name); ?>, <?php echo esc_html($location); ?></p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<?php get_footer(); ?>
