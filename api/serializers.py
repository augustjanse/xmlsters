from django.utils.six import BytesIO
from rest_framework import serializers
from rest_framework.parsers import JSONParser


class ChartSerializer(serializers.BaseSerializer):
    def to_internal_value(self, data):
        """Deserializes a request body into internal data."""
        # data = request.body
        # http://www.django-rest-framework.org/api-guide/serializers/#deserializing-objects

        stream = BytesIO(data)
        parsed_data = JSONParser().parse(stream)  # Change this (and other stuff) to parse XML instead

        return {  # This also needs to be changed if using XML
            "chartid": parsed_data["chart"]["head"]["chartid"],
            "userid": parsed_data["chart"]["head"]["userid"],
            "release": parsed_data["chart"]["body"]["release"]
        }

    def to_representation(self, instance):
        """Serializes internal data into something for the response body."""
        print("test333")
