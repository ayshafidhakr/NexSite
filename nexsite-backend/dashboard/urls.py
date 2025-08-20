# dashboard/urls.py
from django.urls import path
from .views import (
    SingleOwnerDashboardView,
    SmallBuilderDashboardView,
    TurnkeyBuilderDashboardView,
)

urlpatterns = [
    path("single-owner/", SingleOwnerDashboardView.as_view(), name="single-owner-dashboard"),
    path("small-builder/", SmallBuilderDashboardView.as_view(), name="small-builder-dashboard"),
    path("turnkey/", TurnkeyBuilderDashboardView.as_view(), name="turnkey-dashboard"),
]
