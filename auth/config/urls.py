from django.urls import path

from users.tokens import TokenObtainView

urlpatterns = [
    path("api/token/", TokenObtainView.as_view()),
]
