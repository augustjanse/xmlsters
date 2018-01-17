from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from api.models import Chart
from api.serializers import ChartSerializer


class CreateChart(APIView):
    queryset = Chart.objects.all()
    serializer_class = ChartSerializer

    def post(self, request):
        return Response(status.HTTP_201_CREATED)
