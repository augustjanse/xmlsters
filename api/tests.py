from django.test import TestCase

from api.models import Chart
from api.models import User


class ChartTestCase(TestCase):
    def setUp(self):
        Chart.objects.create(placement=1, mbid="19a8b6e5-f753-36c6-a3c6-189390d09935")
        Chart.objects.create(placement=2, mbid="86949026-de16-34f1-8d8a-1d662ed8c0bb")

    def test_nothing(self):
        pass


class UserTestCase(TestCase):
    def setUp(self):
        Chart.objects.create(placement=1, mbid="19a8b6e5-f753-36c6-a3c6-189390d09935")
        User.objects.create(chart_id=Chart.objects.get(placement=1))

    def test_nothing(self):
        print(User.objects.all())
