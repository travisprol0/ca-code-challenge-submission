<?php get_header(); ?>

<section class="hero" style="padding:48px 0;">
  <div class="container">
    <h1>Brands</h1>
    <p>Browse all brands in our reviews directory.</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="grid">
      <?php while (have_posts()): the_post();
        $brand_id = get_the_ID();
        $industry = cr_brand_industry($brand_id);
        $rating = get_post_meta($brand_id, 'average_rating', true);
        $hq = get_post_meta($brand_id, 'headquarters', true);
        $review_count = count(cr_get_reviews_for_brand($brand_id));
      ?>
        <article class="card">
          <?php if ($industry): ?>
            <div><span class="badge"><?php echo esc_html($industry->name); ?></span></div>
          <?php endif; ?>
          <h3><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
          <div><?php echo cr_stars($rating); ?> <span class="meta" style="margin-left:6px;">(<?php echo (int) $review_count; ?>)</span></div>
          <p class="meta"><?php echo esc_html($hq); ?></p>
          <p class="excerpt"><?php echo esc_html(wp_trim_words(wp_strip_all_tags(get_the_content()), 22)); ?></p>
        </article>
      <?php endwhile; ?>
    </div>
    <div class="pagination">
      <?php echo paginate_links(); ?>
    </div>
  </div>
</section>

<?php get_footer(); ?>
