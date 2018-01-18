from rest_framework import serializers

from .models import Chart


# http://www.django-rest-framework.org/api-guide/relations/
class ChartSerializer(serializers.ModelSerializer):
    user_id = serializers.StringRelatedField()

    class Meta:
        model = Chart
        fields = ('placement', 'mbid', 'user_id')
