# accounts/urls.py
from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .views import LoginView, RegisterView, MeView

urlpatterns = [
    path("register/", RegisterView.as_view(), name="account-register"),
    path("token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("me/", MeView.as_view(), name="account-me"),
    path('login/', LoginView.as_view(), name='login'),
]

