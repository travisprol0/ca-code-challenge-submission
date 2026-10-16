<?php get_header(); ?>

<section class="hero" style="padding:48px 0;">
  <div class="container">
    <h1>All Reviews</h1>
    <p>Honest customer feedback from real users.</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <?php while (have_posts()): the_post();
      $review_id = get_the_ID();
      $rating = get_post_meta($review_id, 'rating', true);
      $name = get_post_meta($review_id, 'reviewer_name', true);
      $location = get_post_meta($review_id, 'reviewer_location', true);
      $brand = cr_get_brand_for_review($review_id);
    ?>
      <article class="review-item">
        <div class="review-head">
          <h3>
            <?php if ($brand): ?>
              <span class="meta" style="font-weight:600;text-transform:uppercase;font-size:0.78rem;letter-spacing:0.04em;color:var(--color-primary);">
                <a href="<?php echo esc_url(get_permalink($brand)); ?>"><?php echo esc_html($brand->post_title); ?></a>
              </span><br>
            <?php endif; ?>
            <a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
          </h3>
          <div><?php echo cr_stars($rating, false); ?></div>
        </div>
        <div class="review-byline">
          <?php echo esc_html($name); ?><?php if ($location): ?>, <?php echo esc_html($location); ?><?php endif; ?>
          &middot; <?php echo esc_html(get_the_date('M j, Y')); ?>
        </div>
        <div class="review-body">
          <?php echo esc_html(wp_trim_words(wp_strip_all_tags(get_the_content()), 40)); ?>
        </div>
      </article>
    <?php endwhile; ?>
    <div class="pagination">
      <?php echo paginate_links(); ?>
    </div>
  </div>
</section>

<?php get_footer(); ?>
