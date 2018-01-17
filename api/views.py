from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView


class CreateChart(APIView):
    def post(self, request):
        return Response(status.HTTP_201_CREATED)
