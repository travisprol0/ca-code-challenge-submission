<?php get_header(); ?>
<div class="container">
  <article class="page-body">
    <?php if (have_posts()): while (have_posts()): the_post(); ?>
      <h1><?php the_title(); ?></h1>
      <?php the_content(); ?>
    <?php endwhile; else: ?>
      <h1>Nothing found</h1>
    <?php endif; ?>
  </article>
</div>
<?php get_footer(); ?>
