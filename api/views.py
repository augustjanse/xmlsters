from rest_framework import generics

from api.models import Chart
from api.serializers import ChartSerializer


class CreateView(generics.ListCreateAPIView):
    queryset = Chart.objects.all()
    serializer_class = ChartSerializer

    def perform_create(self, serializer):
        serializer.save()
