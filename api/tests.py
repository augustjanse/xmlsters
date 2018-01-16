from django.test import TestCase


class ChartTestCase(TestCase):
    def setUp(self):
        Chart.objects.create(placement=1, mbid="19a8b6e5-f753-36c6-a3c6-189390d09935")
        Chart.objects.create(placement=2, mbid="86949026-de16-34f1-8d8a-1d662ed8c0bb")


class UserTestCase(TestCase):
    def setUp(self):
        User.objects.create(chart_id="abc123")
