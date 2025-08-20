# nexsite/urls.py
from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

def index(request):
    return JsonResponse({"message": "Nexsite API is up ✔️"}, status=200)

urlpatterns = [
    path("", index, name="index"),
    path("admin/", admin.site.urls),
    path("api/accounts/", include("accounts.urls")),
    path("api/dashboard/", include("dashboard.urls")),  # ✅ added dashboard
]
