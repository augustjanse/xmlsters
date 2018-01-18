from django.utils.six import BytesIO
from rest_framework import status
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework.views import APIView

from api.serializers import ChartSerializer


class CreateChart(APIView):
    def post(self, request):
        # http://www.django-rest-framework.org/api-guide/serializers/#deserializing-objects
        stream = BytesIO(request.body)
        data = JSONParser().parse(stream)
        serializer = ChartSerializer(data=data)
        serializer.is_valid()

        return Response(status.HTTP_201_CREATED)
