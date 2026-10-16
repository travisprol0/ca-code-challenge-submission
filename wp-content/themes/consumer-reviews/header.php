<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo('charset'); ?>">
<meta name="viewport" content="width=device-width, initial-scale=1">
<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<header class="site-header">
  <div class="container">
    <h1 class="site-title"><a href="<?php echo esc_url(home_url('/')); ?>"><?php bloginfo('name'); ?></a></h1>
    <nav class="site-nav" aria-label="Primary">
      <a href="<?php echo esc_url(home_url('/')); ?>">Home</a>
      <a href="<?php echo esc_url(get_post_type_archive_link('brand')); ?>">Brands</a>
      <a href="<?php echo esc_url(get_post_type_archive_link('review')); ?>">Reviews</a>
      <a href="<?php echo esc_url(home_url('/about/')); ?>">About</a>
    </nav>
  </div>
</header>
<main id="main">
