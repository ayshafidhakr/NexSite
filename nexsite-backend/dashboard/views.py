# dashboard/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class SingleOwnerDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # TODO: Replace with actual data for Single Owner
        return Response({"dashboard": "Single Owner Dashboard data"})


class SmallBuilderDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # TODO: Replace with actual data for Small Builder
        return Response({"dashboard": "Small Builder Dashboard data"})


class TurnkeyBuilderDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # TODO: Replace with actual data for Turnkey Builder
        return Response({"dashboard": "Turnkey Builder Dashboard data"})
