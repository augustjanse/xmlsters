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
        self.data = {"placement": 1,
                     "mbid": "86949026-de16-34f1-8d8a-1d662ed8c0bb"}
        self.response = self.client.post(
            reverse('create'),
            self.data
        )

    def test_can_create_chart(self):
        self.assertEqual(self.response.status_code, status.HTTP_201_CREATED)

    def test_can_get_chart(self):
        chart = Chart.objects.get()
        response = self.client.get(
            reverse('details', kwargs={'pk': chart.pk})
        )

        # Should test contents of response
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_can_delete_chart(self):
        chart = Chart.objects.get()
        response = self.client.delete(
            reverse('details', kwargs={'pk': chart.pk}), follow=True
        )

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
