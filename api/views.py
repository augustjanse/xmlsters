from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from api.serializers import ChartSerializer


class CreateChart(APIView):
    def post(self, request):
        ser = ChartSerializer(data=request.body)
        ser.is_valid()
        return Response(ser.validated_data, status.HTTP_201_CREATED)
