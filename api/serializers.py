from rest_framework import serializers

from .models import Chart
from .models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User


class ChartSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chart
