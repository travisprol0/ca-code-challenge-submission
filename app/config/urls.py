from django.urls import path

from content.views import (
    BrandListView,
    BrandPatchView,
    about_page,
    brand_archive,
    brand_page,
    home,
    review_archive,
    review_page,
)

urlpatterns = [
    path("", home),
    path("api/brands/", BrandListView.as_view()),
    path("api/brands/<slug:slug>/", BrandPatchView.as_view()),
    path("brand/", brand_archive),
    path("brand/<slug:slug>/", brand_page),
    path("review/", review_archive),
    path("review/page/<int:number>/", review_archive),
    path("review/<slug:slug>/", review_page),
    path("about/", about_page),
]
