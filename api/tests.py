import xml.etree.ElementTree as ET

from defusedxml.ElementTree import parse
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient

from api.models import Chart
from api.models import User


class ModelTestCase(TestCase):
    def setUp(self):
        Chart.objects.create(placement=1, mbid="19a8b6e5-f753-36c6-a3c6-189390d09935")
        Chart.objects.create(placement=2, mbid="86949026-de16-34f1-8d8a-1d662ed8c0bb")
        User.objects.create(chart_id=Chart.objects.get(pk=1))

    def test_number_of_objects(self):
        self.assertEqual(Chart.objects.all().count(), 2)
        self.assertEqual(User.objects.all().count(), 1)

class ViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
    def test_can_create_chart(self):
        chart = parse("api/tests/testchart.xml")

        self.response = self.client.post(
            reverse('create'),
            ET.tostring(chart.getroot()),
            format='xml'
        )

        self.assertEqual(self.response.status_code, status.HTTP_201_CREATED)
