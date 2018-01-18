from rest_framework import serializers

from .models import Chart


# http://www.django-rest-framework.org/api-guide/relations/
class ChartSerializer(serializers.Serializer):
    user_id = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Chart
        fields = ('placement', 'mbid', 'user_id')
