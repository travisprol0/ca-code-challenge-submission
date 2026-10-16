<?php get_header(); the_post(); ?>
<div class="container">
  <article class="page-body">
    <h1><?php the_title(); ?></h1>
    <?php the_content(); ?>
  </article>
</div>
<?php get_footer(); ?>
