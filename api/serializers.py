import xml.etree.ElementTree as ET

from defusedxml.ElementTree import parse
from django.utils.six import BytesIO
from rest_framework import serializers

from api.models import Chart, User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('chart_id')

    chart_id = serializers.PrimaryKeyRelatedField(read_only=True)


class ChartInstanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chart
        fields = ('placement', 'mbid')

class ChartSerializer(serializers.BaseSerializer):
    def to_internal_value(self, data):
        """Deserializes a request body into internal data."""
        # data = request.body
        # http://www.django-rest-framework.org/api-guide/serializers/#deserializing-objects

        stream = BytesIO(data)
        parsed_data = parse(stream)

        return {
            "chart_id": parsed_data.find("/chart/head/chartid"),
            "user_id": parsed_data.find("/chart/head/userid"),
            "release": parsed_data.find("/chart/head/release")
        }

    def to_representation(self, instance):
        """Serializes internal data into something for the response body."""
        # Assume instance has a chartid somehow, maybe?

        chart_id = instance.id

        charts = Chart.objects.get(pk=chart_id)
        user = User.objects.get(chart_id=instance)

        user_id = user.pk

        root = parse("api/tests/skeleton.xml").getRoot()
        root.find("/chart/head/chartid").text = chart_id
        root.find("/chart/head/userid").text = user_id

        body = root.find("/chart/body")
        for chart in charts:
            release = ET.SubElement(body, "release")
            release.text = chart.mbid
            release.set("placement", chart.placement)

        ET.dump(root)
        return ET.tostring(root)

    def create(self, validated_data):
        # http://www.django-rest-framework.org/api-guide/serializers/#writing-create-methods-for-nested-representationsrk.org/api-guide/serializers/#writing-create-methods-for-nested-representations
        releases = validated_data["release"]
        chart = None
        for release in releases:
            chart = Chart.objects.create(placement=release["-placement"], mbid=["#text"])

        user = User.objects.create(chart_id=chart)
        return user
